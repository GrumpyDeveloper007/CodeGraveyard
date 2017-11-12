;*      VGATEXT.ASM
;*
;* VGA text output routines for MIDAS Sound System
;*
;* $Id: vgatext.asm,v 1.3 1997/01/16 18:41:59 pekangas Exp $
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
INCLUDE "vgatext.inc"


DATASEG


IFDEF __PASCAL__
IFDEF __PROTMODE__
EXTRN   SegB800 : word
ENDIF
ENDIF

D_int   scrWidth                        ; Screen width in _bytes_ (!!)



IDATASEG


hextable	DB	"0123456789ABCDEF"


CODESEG


;/***************************************************************************\
;*
;* Macro:       STARTADDR
;*
;* Description: Calculates the start address in display memory
;*
;* Input:       segreg          segment register for address
;*              indexreg        index register for address
;*              xc              starting x coordinate
;*              yc              starting y coordinate
;*
;* Returns:     points segreg:indexreg to correct display memory byte
;*
;* Destroys:    _ax
;*
;\***************************************************************************/

MACRO   STARTADDR       segreg, indexreg, xc, yc

        mov     _ax,yc
        dec     _ax
        mul     [scrWidth]
        mov     indexreg,xc             ; point indexter to dest in display
        dec     indexreg                ; memory (160*y + 2*x)
        shl     indexreg,1
        add     indexreg,_ax

IFDEF __REALMODE__
        mov     ax,0B800h               ; point segreg to display memory
        mov     segreg,ax
ELSE
IFDEF __16__
        mov     segreg,[SegB800]
ELSE
        add     indexreg,0B8000h
ENDIF
ENDIF

ENDM





;/***************************************************************************\
;*
;* Function:    void vgaSetWidth(int width);
;*
;* Description: Sets the screen width used by text output routines
;*
;* Input:       int width               screen width in characters
;*
;\***************************************************************************/

PROC    vgaSetWidth     _funct  width : _int

        mov     _ax,[width]
        shl     _ax,1
        mov     [scrWidth],_ax

        ret
ENDP




;/***************************************************************************\
;*
;* Function:	 void vgaWriteText(int x, int y, char *txt);
;*
;* Description:  Writes text on the screen
;*
;* Input:	 int x			 X coordinate of string (up-left
;*					 corner is (1,1))
;*		 int y			 Y coordinate
;*		 char *txt		 pointer to null-terminated text
;*					 string, which may contain also the
;*					 following special characters:
;*					     \xFF - next char is attribute
;*					     \x7F - next char is RLE count for
;*						 the character following it
;*
;\***************************************************************************/

PROC    vgaWriteText    _funct  x : _int, y : _int, txt : _ptr
USES    _si,_di,_bx

        STARTADDR es, _di, [x], [y]

        PUSHSEGREG ds

        LOADPTR ds,_si,[txt]            ; point ds:si to string

	mov	ah,07h			; default attribute is 07h - white
					; on black

@@lp:   mov     al,[_si]                ; get byte from string
        inc     _si
        test    al,al                   ; zero? (string termination)
	jz	@@done

	cmp	al,0FFh 		; is next byte attribute?
	je	@@attr

	cmp	al,07Fh 		; is next byte RLE count?
	je	@@rle

        mov     [_esdi],ax              ; normal character - write to screen
        add     _di,2
	jmp	@@lp			; and get next character

@@attr:
        mov     ah,[_si]                ; get next attribute
        inc     _si
	jmp	@@lp			; get next character

@@rle:
        xor     _cx,_cx
        mov     cl,[_si]                ; get RLE count
        mov     al,[_si+1]              ; get RLE byte
        add     _si,2
	rep	stosw			; draw characters
	jmp	@@lp			; get next character

@@done:
        POPSEGREG ds

	ret
ENDP




;/***************************************************************************\
;*
;* Function:     void vgaWriteStr(int x, int y, char *str, char attr,
;*                   int txtlen);
;*
;* Description:  Writes a string on the screen
;*
;* Input:	 int x			 X coordinate of the string
;*		 int y			 Y coordinate
;*		 char *str		 pointer to a ASCIIZ string
;*		 char attr		 attribute for the string
;*		 int txtlen		 number of characters to be printed on
;*					 screen - padded with spaces
;*
;\***************************************************************************/

PROC    vgaWriteStr     _funct  x : _int, y : _int, str : _ptr, attr : _int,\
                                maxlen : _int
USES    _si,_di,_bx

        STARTADDR es, _di, [x], [y]

        PUSHSEGREG ds

        LOADPTR ds,_si,[str]            ; point ds:si to string

        mov     ah,[byte attr]          ; attribute
        mov     _cx,[maxlen]            ; maximum number of characters
        test    _cx,_cx
        jz      @@done

@@lp:	lodsb				; get character
        test    al,al                   ; zero? (end of string)
	jz	@@send			; if is, stop
	stosw				; write character and attribute
	loop	@@lp			; and get next character
	jmp	@@done

@@send:
        mov     al,' '                  ; string end - pad with spaces
	rep	stosw

@@done:
        POPSEGREG ds

	ret
ENDP




;/***************************************************************************\
;*
;* Function:	 void vgaWriteByte(int x, int y, uchar byte, char attr);
;*
;* Description:  Writes a hex byte on the screen
;*
;* Input:	 int x			 X coordinate
;*		 int y			 Y coordinate
;*		 uchar byte		 byte to be written
;*		 char attr		 attribute for the byte
;*
;\***************************************************************************/

PROC    vgaWriteByte    _funct  x : _int, y : _int, b : _int, attr : _int
USES    _di,_bx

        STARTADDR es, _di, [x], [y]

        mov     ah,[byte attr]          ; attribute
        mov     bl,[byte b]
        shr     _bx,4                   ; upper nybble
        and     _bx,0Fh
        mov     al,[hextable+_bx]       ; upper nybble character
        mov     [_esdi],ax              ; write upper nybble

        mov     bl,[byte b]
	and	bx,0Fh			; lower nybble
        mov     al,[hextable+_bx]       ; lower nybble character
        mov     [_esdi+2],ax            ; write lower nybble

	ret
ENDP




;/***************************************************************************\
;*
;* Function:     void vgaFillRect(int x1, int y1, int x2, int y2, char attr);
;*
;* Description:  Draws a filled rectangle on the screen
;*
;* Input:        int x1                  X-coordinate of upper left corner
;*               int y1                  Y-coordinate of upper left corner
;*               int x2                  X-coordinate of lower left corner
;*               int y2                  Y-coordinate of lower left corner
;*               char attr               rectangle attribute
;*
;\***************************************************************************/

PROC    vgaFillRect     _funct  x1 : _int, y1 : _int, x2 : _int, y2 : _int, \
                                attr : _int
USES    _si,_di,_bx

        cld

        STARTADDR es, _di, [x1], [y1]

        mov     _bx,[y2]
        sub     _bx,[y1]                ; _bx = row counter (y2-y1+1)
        inc     _bx

        mov     _dx,[x2]
        sub     _dx,[x1]                ; _dx = number of columns (x2-x1+1)
        inc     _dx

        mov     _ax,_dx
        shl     _ax,1                   ; _si = number of bytes to skip
        mov     _si,160                 ; at the end of each row
        sub     _si,_ax                 ; (160 - 2*width)

        mov     ah,[byte attr]          ; ah = attribute
        mov     al,' '

@@rowlp:
        mov     _cx,_dx
        rep     stosw                   ; draw one row's space+attr pairs
        add     _di,_si                 ; point di to beginning of next row
        dec     _bx
        jnz     @@rowlp                 ; do next row

        ret
ENDP




;/***************************************************************************\
;*
;* Function:     void vgaDrawChar(int x, int y, char ch, char attr);
;*
;* Description:  Draws a single character on the screen
;*
;* Input:        int x                   character X-coordinate
;*               int y                   character Y-coordinate
;*               char ch                 character
;*               char attr               character attribute
;*
;\***************************************************************************/

PROC    vgaDrawChar     _funct  x : _int, y : _int, cha : _int, attr : _int
USES    _bx

        STARTADDR es, _bx, [x], [y]

        mov     ah,[byte attr]          ; ah = attribute
        mov     al,[byte cha]           ; al = character
        mov     [_esbx],ax              ; draw character & attribute

        ret
ENDP




;/***************************************************************************\
;*
;* Function:     void vgaSetMode(int mode)
;*
;* Description:  Sets a VGA BIOS display mode
;*
;* Input:        int mode                BIOS mode number
;*
;\***************************************************************************/

PROC    vgaSetMode      _funct  mode : _int
USES    _bx

        mov     al,[byte mode]
        xor     ah,ah                   ; int 10h, function 0 - set display
        int     10h                     ; mode

        ret
ENDP




;/***************************************************************************\
;*
;* Function:     void vgaMoveCursor(int x, int y);
;*
;* Description:  Moves the text mode cursor to a new location
;*
;* Input:        int x                   cursor X-coordinate
;*               int y                   cursor Y-coordinate
;*
;\***************************************************************************/

PROC    vgaMoveCursor   _funct  x : _int, y : _int
USES    _bx

        mov     ax,0200h                ; int 10h, function 2 - set cursor
                                        ; location
        xor     bx,bx                   ; bh = display page (0)
        mov     dl,[byte x]             ; dl = column (0-based)
        dec     dl
        mov     dh,[byte y]             ; dh = row (0-based)
        dec     dh
        int     10h

        ret
ENDP




;/***************************************************************************\
;*
;* Function:     void vgaDrawChars(int x, int y, char ch, char attr, int num);
;*
;* Description:  Draws many charactersr on the screen
;*
;* Input:        int x                   character X-coordinate
;*               int y                   character Y-coordinate
;*               char ch                 character
;*               char attr               character attribute
;*               int num                 number characters to draw
;*
;\***************************************************************************/

PROC    vgaDrawChars    _funct  x : _int, y : _int, cha : _int, attr : _int, \
                                num : _int
USES    _di

        STARTADDR es, _di, [x], [y]

        mov     ah,[byte attr]          ; ah = attribute
        mov     al,[byte cha]           ; al = character
        mov     _cx,[num]               ; number of characters to draw
        cld
        rep     stosw                   ; draw characted-attribute pairs

        ret
ENDP



;* $Log: vgatext.asm,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/08/04 11:34:55  pekangas
;* All functions now preserve _bx
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*

END