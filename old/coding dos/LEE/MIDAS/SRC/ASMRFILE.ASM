;*      ASMRFILE.ASM
;*
;* Raw file I/O for MIDAS Sound System 16-bit C, Pascal or Assembler version
;*
;* $Id: asmrfile.asm,v 1.2 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*


IDEAL
P386
JUMPS

INCLUDE "lang.inc"
INCLUDE "errors.inc"
INCLUDE "rawfile.inc"
INCLUDE "mmem.inc"



DATASEG

D_long  fpos                            ; temporary file position used by
                                        ; some functions


IDATASEG


;/***************************************************************************\
;*      errorCodes
;*      ----------
;* Table of error codes, with one word (16-bit) DOS error code, followed by
;* the corresponding MIDAS error code.
;\***************************************************************************/

LABEL   errorCodes      WORD
        DW      02h, errFileNotFound    ; File not found
        DW      03h, errFileNotFound    ; Path not found
        DW      04h, errTooManyFiles    ; Too many open files
        DW      05h, errAccessDenied    ; Access denied
        DW      06h, errInvalidFileHandle       ; Invalid handle
        DW      07h, errHeapCorrupted   ; Memory control blocks destroyed
        DW      08h, errOutOfMemory     ; Insufficient memory
        DW      09h, errInvalidBlock    ; Invalid memory block address
        DW      0Fh, errFileNotFound    ; Invalid drive specified
        DW      13h, errAccessDenied    ; Attempt to write on a write-prot.
        DW      14h, errFileNotFound    ; Unknown unit
        DW      1Dh, errFileWrite       ; Write fault
        DW      1Eh, errFileRead        ; Read fault
        DW      20h, errAccessDenied    ; Sharing violation
        DW      50h, errFileExists      ; File already exists
        DW      -1, -1                  ; end marker



CODESEG


;/***************************************************************************\
;*
;* Function:     int ErrorCode(void)
;*
;* Description:  Get the MIDAS error code corresponding to DOS Extended Error.
;*
;* Returns:      MIDAS error code in ax
;*
;\***************************************************************************/

PROC    ErrorCode       _funct

        push    ds _si _di
        mov     _ax,5900h               ; DOS function 59h - get extended
        xor     _bx,_bx                 ; error
        int     21h
        pop     _di _si ds

        mov     _dx,_ax                 ; dx = extended error
        xor     _bx,_bx                 ; offset to error table

@@errloop:
        cmp     [errorCodes+_bx],dx     ; Is the table error code the current
        je      @@errok                 ; one? If is, return the table value
        cmp     [errorCodes+_bx],-1     ; end of table
        je      @@noerr
        add     _bx,4
        jmp     @@errloop

@@errok:
IFDEF __32__
        xor     eax,eax
ENDIF
        mov     ax,[errorCodes+_bx+2]   ; ax = MIDAS error code
        jmp     @@done

@@noerr:
        mov     _ax,errUndefined        ; undefined error

@@done:
        ret
ENDP





;/***************************************************************************\
;*
;* Function:     int rfOpen(char *fileName, int openMode, rfHandle *file);
;*
;* Description:  Opens a file for reading or writing
;*
;* Input:        char *fileName          name of file
;*               int openMode            file opening mode, see enum
;*                                       rfOpenMode
;*               rfHandle *file          pointer to file handle
;*
;* Returns:      MIDAS error code.
;*               File handle is stored in *file.
;*
;\***************************************************************************/

PROC    rfOpen          _funct  fileName : _ptr, openMode : _int, \
                                file : _ptr

        ; allocate memory for file structure:
        call    memAlloc LANG, SIZE rfFile, [file]
        test    _ax,_ax
        jnz     @@err

        cmp     [openMode],rfOpenRead   ; open file for reading?
        jne     @@noread
        mov     _ax,3D00h               ; open a read only file
        jmp     @@open

@@noread:
        cmp     [openMode],rfOpenWrite  ; open file for writing?
        jne     @@nowrite
        mov     _ax,3C00h               ; create a write only file
        xor     _cx,_cx
        jmp     @@open

@@nowrite:
        cmp     [openMode],rfOpenReadWrite      ; open for read & write?
        jne     @@invmode
        mov     _ax,3D02h               ; open a file for read & write
        jmp     @@open

@@invmode:
        mov     _ax,errInvalidArguments ; invalid function arguments
        jmp     @@err

@@open:
        PUSHSEGREG ds
        LOADPTR ds,_dx,[fileName]       ; ds:dx = file name
        int     21h
        POPSEGREG ds
        jc      @@doserr                ; carry set if error

IFDEF __32__
        and     eax,0000FFFFh
ENDIF

        LOADPTR es,_bx,[file]           ; point es:bx to handle
        LOADPTR es,_bx,[_esbx]          ; point es:bx to file structure
        mov     [_esbx+rfFile.handle],_ax       ; store file handle

        xor     _ax,_ax
        jmp     @@done

@@doserr:
        call    ErrorCode               ; get DOS error code

@@err:
        ERROR   ID_rfOpen

@@done:
        ret
ENDP





;/***************************************************************************\
;*
;* Function:     int rfClose(rfHandle file);
;*
;* Description:  Closes a file opened with rfOpen().
;*
;* Input:        rfHandle file           handle of an open file
;*
;* Returns:      MIDAS error code
;*
;\***************************************************************************/

PROC    rfClose         _funct  file : _ptr

        LOADPTR es,_bx,[file]           ; point es:bx to file structure
        mov     _bx,[_esbx+rfFile.handle]       ; bx = file handle
        mov     _ax,3E00h               ; DOS function 3Eh - close file
        int     21h
        jc      @@doserr                ; carry set if error

        ; deallocate file structure:
        call    memFree LANG, [file]
        test    _ax,_ax
        jnz     @@err

        xor     _ax,_ax
        jmp     @@done

@@doserr:
        call    ErrorCode               ; get DOS error code

@@err:
        ERROR   ID_rfClose

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:     int rfGetSize(rfHandle file, long *fileSize);
;*
;* Description:  Get the size of a file
;*
;* Input:        rfHandle file           handle of an open file
;*               ulong *fileSize         pointer to file size
;*
;* Returns:      MIDAS error code.
;*               File size is stored in *fileSize.
;*
;\***************************************************************************/

PROC    rfGetSize       _funct  file : _ptr, fileSize : _long

        ; store current file position:
IFDEF __16__
        call    rfGetPosition LANG, [file], seg fpos offset fpos
ELSE
        call    rfGetPosition LANG, [file], ptr_to fpos
ENDIF
        test    _ax,_ax
        jnz     @@err

        ; seek to end of file:
        xor     eax,eax
        call    rfSeek LANG, [file], eax, rfSeekEnd
        test    _ax,_ax
        jnz     @@err


        ; read file position to *filesize:
        call    rfGetPosition LANG, [file], [fileSize]
        test    _ax,_ax
        jnz     @@err

        ; return original file position:
        call    rfSeek LANG, [file], [fpos], rfSeekAbsolute
        test    _ax,_ax
        jnz     @@err

        xor     _ax,_ax
        jmp     @@done

@@doserr:
        call    ErrorCode               ; get DOS error code

@@err:
        ERROR   ID_rfGetSize

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:     int rfRead(rfHandle file, void *buffer, ulong numBytes);
;*
;* Description:  Reads binary data from a file
;*
;* Input:        rfHandle file           file handle
;*               void *buffer            reading buffer
;*               ulong numBytes          number of bytes to read
;*
;* Returns:      MIDAS error code.
;*               Read data is stored in *buffer, which must be large enough
;*               for it.
;*
;\***************************************************************************/

PROC    rfRead          _funct  file : _ptr, buffer : _ptr, numBytes : _long
LOCAL   readCount : _long, readBuf : _ptr

IFDEF __16__
        mov     eax,[numBytes]          ; store number of bytes left to
        mov     [readCount],eax         ; readCount
        mov     eax,[buffer]            ; store buffer ptr in readBuf
        mov     [readBuf],eax

        les     bx,[file]               ; point es:bx to file structure
        mov     bx,[es:bx+rfFile.handle]        ; bx = file handle

        ; As the DOS read function only accepts 16 bits as number of bytes,
        ; data must be read at chunks of 49152 bytes

@@readloop:
        cmp     [readCount],0           ; any more bytes to read?
        je      @@readok

        cmp     [readCount],49152       ; more than 49152 bytes left?
        jbe     @@readrest

        ; More than 49152 bytes left to read - read 49152 bytes and advance
        ; buffer pointer

        mov     ax,3F00h                ; DOS function 3Fh - read file
        mov     cx,49152                ; read 49152 bytes
        push    ds
        lds     dx,[readBuf]            ; read to *readBuf
        int     21h
        pop     ds
        jc      @@doserr                ; carry set if error
        cmp     ax,49152                ; ax = number of bytes read. If not
        jne     @@eof                   ; 49152, end of file was reached

        sub     [readCount],49152       ; 49152 bytes read
        add     [word readBuf+2],3072   ; advance pointer 49152 bytes
                                        ; (3072 paragraphs)
        jmp     @@readloop


@@readrest:
        ; 49152 or less bytes remaining - read the rest

        mov     ax,3F00h                ; DOS function 3Fh - read file
        mov     cx,[word readCount]     ; read the rest
        push    ds
        lds     dx,[readBuf]            ; read to *readBuf
        int     21h
        pop     ds
        jc      @@doserr                ; carry set if error
        cmp     ax,[word readCount]     ; ax = number of bytes read. If not
        jne     @@eof                   ; readCount, end of file was reached

        mov     [readCount],0           ; no more to read
ELSE

        mov     ebx,[file]              ; point es:bx to file structure
        mov     ebx,[ebx+rfFile.handle] ; bx = file handle

        mov     eax,3F00h               ; DOS function 3Fh - read file
        mov     ecx,[numBytes]
        mov     edx,[buffer]
        int     21h
        jc      @@doserr                ; carry set if error
        cmp     eax,[numBytes]          ; ax = number of bytes read. If not
        jne     @@eof                   ; readCount, end of file was reached

ENDIF

@@readok:
        xor     _ax,_ax
        jmp     @@done

@@eof:
        mov     _ax,errEndOfFile        ; unexpected end of file
        jmp     @@err

@@doserr:
        call    ErrorCode               ; get DOS error code
        cmp     _ax,errUndefined        ; undefined error?
        jne     @@err
@@readerr:
        mov     _ax,errFileRead         ; if is, change it to file read error

@@err:
        ERROR   ID_rfRead

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:     int rfWrite(rfHandle file, void *buffer, ulong numBytes);
;*
;* Description:  Writes binary data to a file
;*
;* Input:        rfHandle file           file handle
;*               void *buffer            pointer to data to be written
;*               ulong numBytes          number of bytes to write
;*
;* Returns:      MIDAS error code
;*
;\***************************************************************************/

PROC    rfWrite         _funct  file : _ptr, buffer : _ptr, numBytes : _long
LOCAL   writeCount : _long, writeBuf : _ptr

IFDEF __16__
        mov     eax,[numBytes]          ; store number of bytes left to
        mov     [writeCount],eax        ; writeCount
        mov     eax,[buffer]            ; store buffer ptr in writeBuf
        mov     [writeBuf],eax

        les     bx,[file]               ; point es:bx to file structure
        mov     bx,[es:bx+rfFile.handle]        ; bx = file handle

        ; As the DOS write function only accepts 16 bits as number of bytes,
        ; data must be written at chunks of 49152 bytes

@@writeloop:
        cmp     [writeCount],0          ; any more bytes to write?
        je      @@writeok

        cmp     [writeCount],49152      ; more than 49152 bytes left?
        jbe     @@writerest

        ; More than 49152 bytes left to write - write 49152 bytes and advance
        ; buffer pointer

        mov     ax,4000h                ; DOS function 40h - write file
        mov     cx,49152                ; write 49152 bytes
        push    ds
        lds     dx,[writeBuf]           ; write from *writeBuf
        int     21h
        pop     ds
        jc      @@doserr                ; carry set if error
        cmp     ax,49152                ; ax = number of bytes written. If
        jne     @@diskfull              ; not 49152, disk is full

        sub     [writeCount],49152      ; 49152 bytes written
        add     [word writeBuf+2],3072  ; advance pointer 49152 bytes
                                        ; (3072 paragraphs)
        jmp     @@writeloop


@@writerest:
        ; 49152 or less bytes remaining - write the rest

        mov     ax,4000h                ; DOS function 40h - read file
        mov     cx,[word writeCount]    ; write the rest
        push    ds
        lds     dx,[writeBuf]           ; write from *readBuf
        int     21h
        pop     ds
        jc      @@doserr                ; carry set if error
        cmp     ax,[word writeCount]    ; ax = number of bytes to written. If
        jne     @@diskfull              ; not writeCount, disk is full

ELSE
        mov     ebx,[file]              ; point es:bx to file structure
        mov     ebx,[ebx+rfFile.handle] ; bx = file handle

        mov     eax,4000h               ; DOS function 40h - read file
        mov     ecx,[numBytes]
        mov     edx,[buffer]
        int     21h
        jc      @@doserr                ; carry set if error
        cmp     _ax,[numBytes]          ; ax = number of bytes to written. If
        jne     @@diskfull              ; not writeCount, disk is full
ENDIF

@@writeok:
        xor     _ax,_ax
        jmp     @@done

@@diskfull:
        mov     _ax,errDiskFull         ; unexpected end of file
        jmp     @@err

@@doserr:
        call    ErrorCode               ; get DOS error code
        cmp     _ax,errUndefined        ; undefined error?
        jne     @@err
        mov     _ax,errFileWrite        ; if is, change to file write error

@@err:
        ERROR   ID_rfWrite

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:     int rfSeek(rfHandle file, long newPosition, int seekMode);
;*
;* Description:  Seeks to a new position in file. Subsequent reads and writes
;*               go to the new position.
;*
;* Input:        rfHandle file           file handle
;*               long newPosition        new file position
;*               int seekMode            file seek mode, see enum rfSeekMode
;*
;* Returns:      MIDAS error code
;*
;\***************************************************************************/

PROC    rfSeek          _funct  file : _ptr, newPosition : _long, \
                                seekMode : _int

IFDEF __32__
        xor     eax,eax
ENDIF

        ; select DOS seek mode corresponding to seekMode:

        cmp     [seekMode],rfSeekAbsolute       ; absolute seek?
        jne     @@noabs
        mov     al,0
        jmp     @@seek

@@noabs:
        cmp     [seekMode],rfSeekRelative       ; relative seek?
        jne     @@norel
        mov     al,1
        jmp     @@seek

@@norel:
        cmp     [seekMode],rfSeekEnd            ; seek from end of file?
        jne     @@invarg
        mov     al,2
        jmp     @@seek

@@invarg:
        mov     _ax,errInvalidArguments         ; invalid seeking mode
        jmp     @@err

@@seek:
        LOADPTR es,_bx,[file]
        mov     _bx,[_esbx++rfFile.handle]      ; bx = file handle
        mov     ah,42h                  ; DOS function 42h - move file pointer
        mov     cx,[word newPosition+2]
        mov     dx,[word newPosition]
        int     21h
        jc      @@doserr

        xor     _ax,_ax
        jmp     @@done

@@doserr:
        call    ErrorCode               ; get DOS error code

@@err:
        ERROR   ID_rfSeek

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:     int rfGetPosition(rfHandle file, long *position);
;*
;* Description:  Reads the current position in a file
;*
;* Input:        rfHandle file           file handle
;*               long *position          pointer to file position
;*
;* Returns:      MIDAS error code.
;*               Current file position is stored in *position.
;*
;\***************************************************************************/

PROC    rfGetPosition   _funct  file : _ptr, position : _ptr

        LOADPTR es,_bx,[file]
        mov     _bx,[_esbx+rfFile.handle]       ; bx = file handle

        mov     eax,4201h               ; DOS function 42h - move file pointer
                                        ; 1: move relative to current position
        xor     cx,cx                   ; new position = 0 (current)
        xor     dx,dx
        int     21h
        jc      @@doserr                ; carry set if error

        ; dx:ax contains current file position - store it in *position:
        LOADPTR es,_bx,[position]
        les     bx,[position]
        mov     [_esbx],ax
        mov     [_esbx+2],dx

        xor     _ax,_ax
        jmp     @@done

@@doserr:
        call    ErrorCode               ; get DOS error code

@@err:
        ERROR   ID_rfGetPosition

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:     int rfFileExists(char *fileName, int *exists);
;*
;* Description:  Checks if a file exists or not
;*
;* Input:        char *fileName          file name, ASCIIZ
;*               int *exists             pointer to file exists status
;*
;* Returns:      MIDAS error code.
;*               *exists contains 1 if file exists, 0 if not.
;*
;\***************************************************************************/

PROC    rfFileExists    _funct  fileName : _ptr, exists : _ptr

        ; Attempt to open the file for reading. If this succeeds, the file
        ; exists.

        PUSHSEGREG ds
        LOADPTR ds,_dx,[fileName]
        mov     _ax,3D00h
        int     21h
        POPSEGREG ds
        LOADPTR es,_bx,[exists]
        jc      @@nofile

        ; the file exists:
        mov     [_int _esbx],1

        ; the file is still open - close it:
        mov     _bx,_ax
        mov     _ax,3E00h
        int     21h
        jmp     @@ok

@@nofile:
        ; the file does not exist:
        mov     [_int _esbx],0

@@ok:
        xor     _ax,_ax
        ret

ENDP



;* $Log: asmrfile.asm,v $
;* Revision 1.2  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*


END