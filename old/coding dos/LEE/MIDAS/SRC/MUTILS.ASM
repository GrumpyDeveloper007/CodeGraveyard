;*	MUTILS.ASM
;*
;* Miscellaneous utility functions for MIDAS Sound System used
;* by various system components.
;*
;* $Id: mutils.asm,v 1.4 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*

; Possibly environment dependent code is marked with *!!*



IDEAL
P386

INCLUDE "lang.inc"
INCLUDE "mutils.inc"


DATASEG

IFDEF __WC32__
EXTRN   _psp : word
ENDIF


CODESEG


;/***************************************************************************\
;*
;* Function:	 int mGetKey(void)
;*
;* Description:  Waits for a keypress and returns the read key
;*
;* Returns:	 ASCII code for the key pressed. Extended keycodes are
;*		 returned with bit 8 set, eg. up arrow becomes \x148.
;*
;\***************************************************************************/

PROC    mGetKey         _funct
USES    _bx

        ;*!!*

IFDEF __32__
        xor     eax,eax
ENDIF

	mov	ax,0700h		; read key without echo
	int	21h

	xor	ah,ah
	test	al,al			; read key zero?
	jnz	@@keyok 		; if not, it is the key ASCII code

	; the read key was zero - now read the actual extended keycode and
	; return it with bit 8 set.

	mov	ax,0700h		; read key without echo
	int	21h
	mov	ah,1			; set bit 8 to 1

@@keyok:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	 int mStrLength(char *str)
;*
;* Description:  Calculates the length of a ASCIIZ string
;*
;* Input:	 char *str		 pointer to string
;*
;* Returns:	 String length excluding the terminating '\0'.
;*
;\***************************************************************************/

PROC    mStrLength      _funct  str : _ptr
USES    _bx

IFDEF __32__
        mov     ax,ds
        mov     es,ax
ENDIF

        LOADPTR es,_bx,[str]            ; point es:bx to string
        xor     _ax,_ax                 ; current length = 0

@@lp:
        cmp     [byte _esbx],0          ; is current byte 0
	je	@@done			; if is, we are finished
        inc     _bx                     ; next byte
        inc     _ax
	jmp	@@lp

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	 void mStrCopy(char *dest, char *src);
;*
;* Description:  Copies an ASCIIZ string from *src to *dest.
;*
;* Input:	 char *dest		 pointer to destination string
;*		 char *src		 pointer to source string
;*
;\***************************************************************************/

PROC    mStrCopy        _funct  dest : _ptr, src : _ptr
USES    _si,_di

        PUSHSEGREG ds

	; Clear enough as it is? If not, maybe you shouldn't be reading
	; this source after all...

IFDEF __32__
        mov     ax,ds
        mov     es,ax
ENDIF

	cld
        LOADPTR ds,_si,[src]
        LOADPTR es,_di,[dest]

@@lp:	lodsb
	stosb
	test	al,al
	jnz	@@lp

@@done:
        POPSEGREG ds

	ret
ENDP




;/***************************************************************************\
;*
;* Function:	 void mStrAppend(char *dest, char *src);
;*
;* Description:  Appends an ASCIIZ string to the end of another.
;*
;* Input:	 char *dest		 pointer to destination string
;*		 char *src		 pointer to source string
;*
;\***************************************************************************/

PROC    mStrAppend      _funct  dest : _ptr, src : _ptr
USES    _si,_di

	; Again, if you don't understand this you should perhaps consider
	; switching hobby...

        PUSHSEGREG ds

IFDEF __32__
        mov     ax,ds
        mov     es,ax
ENDIF

	cld
        LOADPTR ds,_si,[src]
        LOADPTR es,_di,[dest]

@@l1:   mov     al,[_esdi]
	test	al,al
	jz	@@lp
        inc     _di
	jmp	@@l1

@@lp:	lodsb
	stosb
	test	al,al
        jz      @@done
	jmp	@@lp

@@done:
        POPSEGREG ds

	ret
ENDP



;/***************************************************************************\
;*
;* Function:	 void mMemCopy(char *dest, char *src, unsigned numBytes);
;*
;* Description:  Copies a memory block from *src to *dest.
;*
;* Input:	 char *dest		 pointer to destination
;*		 char *src		 pointer to source
;*		 unsigned numBytes	 number of bytes to copy
;*
;\***************************************************************************/

PROC    mMemCopy        _funct  dest : _ptr, src : _ptr, numBytes : _int
USES    _si,_di

IFDEF __32__
        mov     ax,ds
        mov     es,ax
ENDIF

        PUSHSEGREG ds

	cld
        LOADPTR ds,_si,[src]
        LOADPTR es,_di,[dest]
        mov     _cx,[numBytes]
	rep	movsb

        POPSEGREG ds

	ret
ENDP




;/***************************************************************************\
;*
;* Function:	 int mMemEqual(char *m1, char *m2, unsigned numBytes);
;*
;* Description:  Compares two memory blocks.
;*
;* Input:	 char *m1		 pointer to memory block #1
;*		 char *m2		 pointer to memory block #2
;*		 unsigned numBytes	 number of bytes to compare
;*
;* Returns:	 1 if the memory blocks are equal, 0 if not.
;*
;\***************************************************************************/

PROC    mMemEqual       _funct  m1 : _ptr, m2 : _ptr, numBytes : _int
USES    _si,_di

IFDEF __32__
        mov     ax,ds
        mov     es,ax
ENDIF

        PUSHSEGREG ds

	cld
        LOADPTR ds,_si,[m1]
        LOADPTR es,_di,[m2]
        mov     _cx,[numBytes]
	repe	cmpsb
        test    _cx,_cx
	jnz	@@une
        mov     _ax,1
	jmp	@@done

@@une:  xor     _ax,_ax

@@done:
        POPSEGREG ds

	ret
ENDP




;/***************************************************************************\
;*
;* Function:	 long mHex2Long(char *hex)
;*
;* Description:  Converts a hexadecimal string to a long integer.
;*
;* Input:	 char *hex		 pointer to hex string, ASCIIZ
;*
;* Returns:	 Value of the string or -1 if conversion failure.
;*
;\***************************************************************************/

PROC    mHex2Long       _funct  hex : _ptr
USES    _bx

        LOADPTR es,_bx,[hex]            ; point es:bx to string
	xor	edx,edx 		; current number is zero

@@lp:   mov     al,[_esbx]              ; get character from string
        inc     _bx
	test	al,al			; terminating '\0'?
	jz	@@strend

	shl	edx,4			; move previous string data to left

	cmp	al,'0'                  ; character below '0'?
	jb	@@err			; if yes, error
	cmp	al,'9'                  ; character <= '9'?
	jbe	@@decdigit		; if yes, it's a decimal digit

	cmp	al,'A'                  ; character below 'A'?
	jb	@@err			; if yes, error
	cmp	al,'F'                  ; character <= 'F'?
	jbe	@@chexdigit		; if yes, it's a capital hex digit

	cmp	al,'a'                  ; character below 'a'?
	jb	@@err			; if yes, error
	cmp	al,'f'                  ; character <= 'f'?
	jbe	@@shexdigit		; if yes, it's a small hex digit

	jmp	@@err			; unrecognized character - error

@@decdigit:
	sub	al,'0'                  ; al = current digit value
	or	dl,al			; add it to edx
	jmp	@@lp			; and get next character

@@chexdigit:
	sub	al,'A'-0Ah              ; al = current digit value
	or	dl,al			; add it to edx
	jmp	@@lp			; and get next character

@@shexdigit:
	sub	al,'a'-0Ah              ; al = current digit value
	or	dl,al			; add it to edx
	jmp	@@lp			; and get next character

@@strend:
IFDEF __16__
	mov	ax,dx			; move result from edx to dx:ax
	shr	edx,16
ELSE
        mov     eax,edx
ENDIF
	jmp	@@done			; and leave

@@err:
IFDEF __16__
        mov     ax,-1
	mov	dx,-1
ELSE
        mov     _ax,-1
ENDIF

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	 long mDec2Long(char *dec)
;*
;* Description:  Converts an unsigned decimal string to a long integer
;*
;* Input:	 char *dec		 pointer to string, ASCIIZ
;*
;* Returns:	 Value of the string or -1 if conversion failure.
;*
;\***************************************************************************/

PROC    mDec2Long       _funct  dec : _ptr
USES    _bx

        LOADPTR es,_bx,[dec]            ; point es:bx to string
	xor	edx,edx 		; current value is zero
        xor     eax,eax

@@lp:
        mov     al,[_esbx]              ; get character from string
	inc	bx
	test	al,al			; terminating '\0'?
	jz	@@strend

	imul	edx,edx,10		; multiply current value by 10 to
					; make room for the new digit
	cmp	al,'0'                  ; character below '0'?
	jb	@@err			; if yes, error
	cmp	al,'9'                  ; character above '9'?
	ja	@@err			; if yes, error

	sub	al,'0'                  ; al = current digit value
        add     edx,eax                 ; add it to edx
	jmp	@@lp			; and get next character

@@strend:
IFDEF __16__
	mov	ax,dx			; move result from edx to dx:ax
	shr	edx,16
ELSE
        mov     eax,edx
ENDIF

	jmp	@@done			; and leave

@@err:
IFDEF __16__
	mov	ax,-1
	mov	dx,-1
ELSE
        mov     eax,-1
ENDIF

@@done:
	ret
ENDP




;/**************************************************************************\
;*
;* Function:	 char *mGetEnv(char *envVar);
;*
;* Description:  Searches a string from the environment
;*
;* Input:	 envVar 		 environment variable name, ASCIIZ
;*
;* Returns:	 Pointer to environment string value (ASCIIZ), NULL if string
;*		 was not found.
;*
;\**************************************************************************/

PROC    mGetEnv         _funct  envVar : _ptr
USES    _si,_di,_bx

        ;*!!*

        PUSHSEGREG ds
IFDEF __32__
        push    es
        mov     ax,ds
        mov     es,ax
ENDIF

        cld
        LOADPTR es,_di,[envVar]         ; point es:di and es:bx to environment
        mov     _bx,_di                 ; variable name
	xor	al,al
	mov	cx,7FFFh
	repne	scasb			; scan for first 0 in string
        sub     _di,_bx
        dec     _di
        mov     _dx,_di                 ; dx = string length (excl. '\0')

        test    _dx,_dx                 ; skip if zero length string
	jz	@@notfound

IFDEF __WC32__
        mov     bx,[_psp]
ELSE
	mov	ah,62h			; int 21h, function 62h - get PSP seg
	int	21h			; bx = PSP segment
ENDIF

        LOADPTR ds,_si,[envVar]         ; point ds:si to variable name
	mov	es,bx			; es = PSP segment
        mov     es,[es:2Ch]             ; es = Environment segment
        xor     _di,_di                 ; point es:di to environment

        mov     ah,[_si]                ; ah = first character of string
	xor	al,al			; al = 0 !!!

@@search:
        cmp     [es:_di],ah             ; Is the first letter of the current
	jne	@@skipend		; environment string same as the one
					; we are looking for? If not, skip
					; the whole string.

        push    _si
        mov     _cx,_dx
	repe	cmpsb			; check if the whole string is equal
        pop     _si
	jne	@@skipend		; skip if not
        cmp     [byte es:_di],"="       ; check is the next character is '='
	jne	@@skipend		; skip if not
        inc     _di                     ; point es:di to start of environment
IFDEF __16__
	mov	dx,es			; return pointer in dx:ax
	mov	ax,di
ELSE

        mov     eax,0006h               ; DPMI function 7 - get segment base
        xor     ebx,ebx
        mov     bx,es
        int     31h
        jc      @@notfound

        mov     eax,ecx                 ; eax = environment selector base
        shl     eax,16                  ; address
        mov     ax,dx
        add     eax,edi
ENDIF
	jmp	@@done

@@skipend:
        mov     _cx,7FFFh
	repne	scasb			; search for first '\0'.
        cmp     [byte es:_di],0         ; is the next byte also 0?
	je	@@notfound		; if is, end of environment
	jmp	@@search

@@notfound:
        xor     _ax,_ax                 ; string was not found - return NULL
IFDEF __16__
	xor	dx,dx
ENDIF

@@done:
IFDEF __32__
        pop     es
ENDIF
        POPSEGREG ds

	ret
ENDP


;* $Log: mutils.asm,v $
;* Revision 1.4  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.3  1996/08/04 11:31:14  pekangas
;* All routines now preserve _ebx
;*
;* Revision 1.2  1996/07/13 17:28:46  pekangas
;* All routines now preserve ebx
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*


END