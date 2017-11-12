;*      POSTPROC.ASM
;*
;* Post-processing routines common for all mixing Sound Devices
;*
;* $Id: postproc.asm,v 1.3 1997/01/16 18:41:59 pekangas Exp $
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

INCLUDE "lang.inc"

MIX8BITS = 12                           ; number of bits of accuracy in
                                        ; mixing for 8-bit output



;/***************************************************************************\
;*
;* Macro:	NumLabel lblname, lblnum
;*
;* Description: Creates a numbered label in the source, format _namenum
;*              (eg. _table1)
;*
;* Input:	lblname 	name for the label
;*		lblnum		number for the label
;*
;\***************************************************************************/

MACRO	NumLabel lblname, lblnum
_&lblname&lblnum:
ENDM



;/***************************************************************************\
;*
;* Macro:	JmpTable lblname, lblcount
;*
;* Description: Creates a jump offset table in the source. The table consists
;*		of near offsets of labels _lblname0 - _lblnameX
;*
;* Input:	lblname 	name of labels to be used for the table
;*		lblcount	number of labels
;*
;\***************************************************************************/

MACRO   defoffs lblname, lblnum
IFDEF __16__
	DW	offset _&lblname&lblnum
ELSE
        DD      offset _&lblname&lblnum
ENDIF
ENDM

MACRO	JmpTable lblname, lblcount
numb = 0
REPT	lblcount
        defoffs lblname, %numb
numb = numb + 1
ENDM
ENDM


DATASEG

oldValue        DD      0


CODESEG



GLOBAL  LANG pp16Mono : _funct
GLOBAL  LANG pp8Mono : _funct
GLOBAL  LANG pp16Stereo : _funct
GLOBAL  LANG pp8Stereo : _funct




;IFDEF __32__
;LABEL   pp16Jump        _int
;JmpTable pp16, 17
;ENDIF

;/***************************************************************************\
;*
;* Function:    unsigned pp16Mono(unsigned numElements, uchar *bufStart,
;*                  unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);
;*
;* Description: 16-bit mono post-processing routine
;*
;* Input:       unsigned numElements    number of elements to process
;*                                       (guaranteed to be even)
;*              uchar *bufStart         pointer to start of DMA buffer
;*              unsigned mixPos         mixing position in DMA buffer
;*              unsigned *mixBuffer     pointer to source mixing buffer
;*              uchar *ppTable          post-processing table
;*
;* Returns:     New mixing position in DMA buffer. Can not fail.
;*
;\***************************************************************************/

PROC    pp16Mono        _funct  numElements : _int, bufStart : _ptr, \
                                mixPos : _int, mixBuffer : _ptr, \
                                ppTable : _ptr
USES _si,_di,_bx

        PUSHSEGREG ds

        LOADPTR es,_di,[bufStart]       ; point _esdi to destinatio buffer
        add     _di,[mixPos]
        LOADPTR ds,_si,[mixBuffer]      ; point _dssi to source buffer

IF 0    ; new clipping post-processing routine below!

IFDEF __16__
        mov     cx,[numElements]        ; cx = number of elements
        test    cx,cx
        jz      @@done
        shr     cx,1                    ; cx = number of dwords
        cld
        rep     movsd
ELSE
        mov     ecx,[numElements]
        test    ecx,ecx
        jz      @@done
        shr     ecx,1                   ; two elements are done at a time

        mov     eax,ecx
        and     eax,15

        shl     eax,2
        neg     eax                     ; eax = jump table offset (64 - 4*eax)
        add     eax,64

        sub     edi,eax                 ; undo edi incrementing in loop
        mov     ebx,[pp16Jump+eax]      ; ebx = jump offset
        shl     eax,1
        sub     esi,eax                 ; undo edi incrementing in loop

        shr     ecx,4                   ; ecx = number of loops to mix
        inc     ecx

        jmp     ebx


@@loop:
a = 0
REPT 16
NumLabel pp16, %a
        mov     eax,[esi + 8*a + 4]
        shl     eax,16
        mov     ax,[word esi+8*a]
        mov     [edi+4*a],eax
a = a + 1
ENDM
NumLabel pp16, %a
        add     edi,64
        add     esi,128
        dec     ecx
        jnz     @@loop

ENDIF


ENDIF   ; IF 0

        mov     ebx,[oldValue]
        mov     ecx,[numElements]       ; ecx = number of elements, loop count
        test    ecx,ecx
        jz      @@done

@@loop:
        mov     eax,[esi]
        add     esi,4
        cmp     eax,32767
        jg      @@above
        cmp     eax,-32768
        jl      @@below

IF 0
        mov     edx,eax
;        add     eax,edx
;        add     eax,edx
        add     eax,ebx
        sar     eax,1
        mov     ebx,edx
ENDIF

        mov     [edi],ax
        add     edi,2
        dec     ecx
        jnz     @@loop
        jmp     @@done

@@above:
        mov     [word ptr edi],32767
        mov     ebx,32767
        add     edi,2
        dec     ecx
        jnz     @@loop
        jmp     @@done

@@below:
        mov     [word ptr edi],-32768
        mov     ebx,-32768
        add     edi,2
        dec     ecx
        jnz     @@loop


@@done:
        mov     [oldValue],ebx
        sub     _di,[_int bufStart]     ; return new mixing position
        mov     _ax,_di

        POPSEGREG ds

        ret
ENDP




LABEL   pp8Jump         _int
JmpTable pp8, 17

;/***************************************************************************\
;*
;* Function:    unsigned pp8Mono(unsigned numElements, uchar *bufStart,
;*                  unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);
;*
;* Description: 8-bit mono post-processing routine
;*
;* Input:       unsigned numElements    number of elements to process
;*                                       (guaranteed to be even)
;*              uchar *bufStart         pointer to start of DMA buffer
;*              unsigned mixPos         mixing position in DMA buffer
;*              unsigned *mixBuffer     pointer to source mixing buffer
;*              uchar *ppTable          post-processing table
;*
;* Returns:     New mixing position in DMA buffer. Can not fail.
;*
;* (Could use some optimization)
;*
;\***************************************************************************/

PROC    pp8Mono         _funct  numElements : _int, bufStart : _ptr, \
                                mixPos : _int, mixBuffer : _ptr, \
                                ppTable : _ptr
USES    _si,_di,_bx

        PUSHSEGREG ds

IFDEF __16__

        lds     si,[ppTable]            ; point ds:si to post-proc. table
        LOADPTR es,_di,[bufStart]       ; point _esdi to destination buffer
        add     _di,[mixPos]

        mov     _cx,[numElements]       ; number of elements to process
        test    _cx,_cx
        jz      @@done
        shr     _cx,1                   ; number of destination words

        mov     bx,cx
        and     bx,15

        shl     bx,1
        neg     bx
        add     bx,32                   ; undo di incrementing in loop
        sub     di,bx
        mov     ax,[pp8Jump+bx]         ; ax = jump offset

        push    bp
        LOADPTR gs,_bp,[mixBuffer]      ; point gs:bp to source buffer

        shl     bx,1
        sub     bp,bx                   ; undo bp incrementing in loop

        shr     cx,4                    ; cx = number of loops to do
        inc     cx

        jmp     ax

@@loop:
a = 0
REPT 16
NumLabel pp8, %a
        mov     bx,[gs:bp+4*a]
        mov     al,[si+bx+((1 SHL MIX8BITS)/2)]
        mov     bx,[gs:bp+4*a+2]
        mov     ah,[si+bx+((1 SHL MIX8BITS)/2)]
        mov     [es:di+2*a],ax
a = a + 1
ENDM
NumLabel pp8, %a
        add     bp,64
        add     di,32
        dec     cx
        jnz     @@loop

        pop     bp
ELSE
        LOADPTR ds,_si,[mixBuffer]      ; point _si to source buffer
        LOADPTR es,_di,[bufStart]       ; point _esdi to destination buffer
        add     _di,[mixPos]

        mov     _cx,[numElements]       ; number of elements to process
        test    _cx,_cx
        jz      @@done
        shr     _cx,1                   ; number of destination words


        mov     eax,ecx
        and     eax,15

        shl     eax,1
        neg     eax
        add     eax,32                  ; undo edi incrementing in loop
        sub     edi,eax

        shl     eax,1
        mov     ebx,[pp8Jump+eax]       ; ebx = jump offset

        shl     eax,1
        sub     esi,eax                 ; undo esi incrementing in loop

        shr     ecx,4                   ; ecx = number of loops to do
        inc     ecx

;        push    ebp
;        mov     ebp,[ppTable]           ; point ebp to post-proc. table
        mov     edx,[ppTable]

        jmp     ebx

@@loop:
a = 0
REPT 16
NumLabel pp8, %a
        mov     ebx,[esi+8*a]
        mov     al,[edx+ebx+((1 SHL MIX8BITS)/2)]
        mov     ebx,[esi+8*a+4]
        mov     ah,[edx+ebx+((1 SHL MIX8BITS)/2)]
        mov     [edi+2*a],ax
a = a + 1
ENDM
NumLabel pp8, %a
        add     esi,128
        add     edi,32
        dec     ecx
        jnz     @@loop

;        pop     ebp

ENDIF
@@done:
        sub     _di,[_int bufStart]     ; return new mixing position
        mov     _ax,_di

        POPSEGREG ds

        ret
ENDP




;/***************************************************************************\
;*
;* Function:    unsigned pp16Stereo(unsigned numElements, uchar *bufStart,
;*                  unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);
;*
;* Description: 16-bit stereo post-processing routine
;*
;* Input:       unsigned numElements    number of elements to process
;*                                       (guaranteed to be even)
;*              uchar *bufStart         pointer to start of DMA buffer
;*              unsigned mixPos         mixing position in DMA buffer
;*              unsigned *mixBuffer     pointer to source mixing buffer
;*              uchar *ppTable          post-processing table
;*
;* Returns:     New mixing position in DMA buffer. Can not fail.
;*
;\***************************************************************************/

PROC    pp16Stereo      _funct  numElements : _int, bufStart : _ptr, \
                                mixPos : _int, mixBuffer : _ptr, \
                                ppTable : _ptr
USES _si,_di,_bx

        ; Since the mono post-processing routine does exactly what we need
        ; to do here, why not as well use it?
        mov     _ax,[numElements]
        shl     _ax,1
        call    pp16Mono LANG, _ax, [bufStart], [mixPos], [mixBuffer], \
                [ppTable]

        ret
ENDP




;/***************************************************************************\
;*
;* Function:    unsigned pp8Stereo(unsigned numElements, uchar *bufStart,
;*                  unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);
;*
;* Description: 8-bit stereo post-processing routine
;*
;* Input:       unsigned numElements    number of elements to process
;*                                       (guaranteed to be even)
;*              uchar *bufStart         pointer to start of DMA buffer
;*              unsigned mixPos         mixing position in DMA buffer
;*              unsigned *mixBuffer     pointer to source mixing buffer
;*              uchar *ppTable          post-processing table
;*
;* Returns:     New mixing position in DMA buffer. Can not fail.
;*
;* (Could use some optimization)
;*
;\***************************************************************************/

PROC    pp8Stereo       _funct  numElements : _int, bufStart : _ptr, \
                                mixPos : _int, mixBuffer : _ptr, \
                                ppTable : _ptr
USES    _si,_di,_bx

        ; Since the mono post-processing routine does exactly what we need
        ; to do here, why not as well use it?
        mov     _ax,[numElements]
        shl     _ax,1
        call    pp8Mono LANG, _ax, [bufStart], [mixPos], [mixBuffer], \
                [ppTable]

        ret
ENDP


;* $Log: postproc.asm,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/07/13 17:28:28  pekangas
;* Fixed to preserve ebx
;*
;* Revision 1.1  1996/05/22 21:00:30  pekangas
;* Initial revision
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*


END