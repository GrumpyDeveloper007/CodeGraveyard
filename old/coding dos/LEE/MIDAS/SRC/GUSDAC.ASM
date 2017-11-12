;*	GUSDAC.ASM
;*
;* Gravis UltraSound Mixing Sound Device
;*
;* $Id: gusdac.asm,v 1.3 1997/01/16 18:41:59 pekangas Exp $
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
INCLUDE "sdevice.inc"
INCLUDE "mixsd.inc"
INCLUDE "dsm.inc"
INCLUDE "dma.inc"
INCLUDE "mutils.inc"

;BORDERS = 1

GLOBAL	LANG dmaBufferSize : _int
GLOBAL	LANG dmaPos : _int
GLOBAL	LANG mixPos : _int
GLOBAL	LANG buffer : dmaBuffer
GLOBAL	LANG buffer2 : dmaBuffer
GLOBAL	LANG uploaded : _int


;/***************************************************************************\
;*	 enum gdcFunctIDs
;*	 ----------------
;* Description:  ID numbers for GUS DAC Sound Device functions
;\***************************************************************************/

enum	gdcFunctIDs \
	ID_gdcDetect = ID_gdc, \
	ID_gdcInit, \
	ID_gdcClose, \
	ID_gdcStartPlay



DATASEG

IFDEF __PASCAL__
EXTRN	GDC : SoundDevice
ENDIF


D_int		selreg
D_int		voicesel
D_int		datalow
D_int		gdcRate
D_int		gdcMode
D_int		numChans
D_int		bufHalf
D_int		oldPos
D_int		uploaded
D_int		playing
D_int           dmaActive
D_int           gusDMAPos


IDATASEG


GDCCONFIGBITS = sdUsePort or sdUseDMA or sdUseMixRate or \
		sdUseOutputMode or sdUseDSM
GDCMODEBITS = sdMono or sd8bit or sd16bit

; If compiling for Pascal, Sound Device name is gdcSD, from which the data
; will be copied to Sound Device GDC, defined in Pascal.

IFDEF	__PASCAL__
SDNAM		equ	gdcSD
ELSE
SDNAM		equ	GDC
ENDIF

GLOBAL	SDNAM : SoundDevice

SDNAM	SoundDevice	< \
 0,\
 GDCCONFIGBITS,\
 220h, 0, 1,\
 1, 1,\
 GDCMODEBITS,\
 ptr_to gdcSDName,\
 ptr_to gdcCardNames,\
 6, ptr_to gdcPortAddresses,\
 ptr_to gdcDetect,\
 ptr_to gdcInit,\
 ptr_to gdcClose,\
 ptr_to dsmGetMixRate,\
 ptr_to mixsdGetMode,\
 ptr_to mixsdOpenChannels,\
 ptr_to dsmCloseChannels,\
 ptr_to dsmClearChannels,\
 ptr_to dsmMute,\
 ptr_to dsmPause,\
 ptr_to dsmSetMasterVolume,\
 ptr_to dsmGetMasterVolume,\
 ptr_to mixsdSetAmplification,\
 ptr_to mixsdGetAmplification,\
 ptr_to dsmPlaySound,\
 ptr_to dsmReleaseSound\
 ptr_to dsmStopSound,\
 ptr_to dsmSetRate,\
 ptr_to dsmGetRate,\
 ptr_to dsmSetVolume,\
 ptr_to dsmGetVolume,\
 ptr_to dsmSetSample,\
 ptr_to dsmGetSample,\
 ptr_to dsmSetPosition,\
 ptr_to dsmGetPosition,\
 ptr_to dsmGetDirection,\
 ptr_to dsmSetPanning,\
 ptr_to dsmGetPanning,\
 ptr_to dsmMuteChannel,\
 ptr_to dsmAddSample,\
 ptr_to dsmRemoveSample,\
 ptr_to mixsdSetUpdRate,\
 ptr_to gdcStartPlay,\
 ptr_to gdcPlay >

gdcSDName	DB	"Gravis UltraSound Mixing Sound Device v0.05", 0

gdcCardNames	DD	ptr_to gdcName

gdcName 	DB	"Gravis UltraSound Software Mixing", 0

IFDEF __16__
gdcPortAddresses  DW	210h, 220h, 230h, 240h, 250h, 260h
ELSE
gdcPortAddresses  DD	210h, 220h, 230h, 240h, 250h, 260h
ENDIF

env		DB	"ULTRASND",0

chantab dw	44100,41160,38587,36317,34300,32494,30870,29400,28063,26843
	dw	25725,24696,23746,22866,22050,21289,20580,19916,19293

buffer2 dmaBuffer ?


CODESEG

MACRO	SetBorder	color
IFDEF BORDERS
	push	_dx _ax
	mov	dx,03DAh
	in	al,dx
	mov	dx,03C0h
	mov	al,31h
	out	dx,al
	mov	al,color
	out	dx,al
	pop	_ax _dx
ENDIF
ENDM

;******* GUS Register Select - Macro ************

MACRO	regsel	register
	mov	_dx,[selreg]
	mov	al,register
	out	dx,al
ENDM

;******* GUS-delay subroutine ************

PROC	gusdelay NEAR
	push	_dx _ax
	mov	dx,84h
	rept	8
	in	al,dx
	endm
	pop	_ax _dx
	ret
ENDP

;/***************************************************************************\
;*
;* Function:	gusReset
;*
;* Description: Resets the GUS card
;*
;* Destroys:	al, dx
;*
;\***************************************************************************/
PROC	gusReset NEAR

	regsel	4ch				; RESET
	add	_dx,2
	xor	al,al
	out	dx,al				; RESET!

	call	gusdelay
	call	gusdelay

	mov	al,1
	out	dx,al				; Enable GF1

	call	gusdelay
	call	gusdelay
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gdcDetect(int *result);
;*
;* Description: Detects Gravis UltraSound soundcard
;*
;* Returns:	MIDAS error code.
;*		1 stored to *result if GUS was detected, 0 if not.
;*
;\***************************************************************************/

PROC	gdcDetect	_funct	result : _ptr
USES    _bx

	; Search for "ULTRASND" environment string:
IFDEF __16__
	call	mGetEnv LANG, seg env offset env
	mov	bx,dx			; was "ULTRASND" environment found?
	or	bx,ax			; if not, no GUS
	jz	@@noGUS

	mov	es,dx			; point es:si to environment
	mov	bx,ax			; string

ELSE
	call	mGetEnv LANG, offset env
	test	eax,eax 		; was "ULTRASND" environment found?
	jz	@@noGUS 		; if not, no GUS

	mov	ebx,eax 		; point _esbx to environment string

ENDIF
	mov	cl,3				; 3 digits
	xor	_ax,_ax
@@dloop:
	mov	dl,[_esbx]
	inc	_bx
	sub	dl,"0"
	shl	_ax,4
	add	al,dl
	dec	cl
	jnz	@@dloop

	mov	[GDC.port],_ax

; Take Playback DMA-channel
	inc	_bx
	xor	_dx,_dx
	mov	dl,[_esbx]
	sub	dl,"0"
	mov	[GDC.DMA],_dx

; Test if there really is a GUS

	add	_ax,103h
	mov	[selreg],_ax			; Register select (2x0h+103h)

	call	gusReset

	regsel	44h
	add	_dx,2
	xor	al,al
	out	dx,al				; upper bits of address

	regsel	43h
	inc	_dx
	xor	_ax,_ax 			; Address 0
	out	dx,ax
	add	dx,3
	mov	al,055h
	out	dx,al				; Poke data 1 (55h)

	sub	dx,3
	mov	_ax,1				; Address 1
	out	dx,ax
	add	dx,3
	mov	al,0AAh
	out	dx,al				; Poke data 2 (AAh)

	sub	dx,3
	xor	_ax,_ax 			; Address 0
	out	dx,ax
	add	dx,3
	in	al,dx				; Peek data 1
	cmp	al,055h
	jne	@@noGUS

	sub	dx,3
	mov	_ax,1				; Address 1
	out	dx,ax
	add	dx,3
	in	al,dx				; Peek data 2
	cmp	al,0AAh
	je	@@found

@@noGUS:
	mov	[GDC.port],0
	xor	_ax,_ax 			; No GUS found
	jmp	@@quit

@@found:
	mov	_ax,1				; GUS found
@@quit:
	LOADPTR es,_bx,[result] 		; store in *result
	mov	[_int _esbx],_ax
	xor	_ax,_ax
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gdcInit(unsigned mixRate, unsigned mode);
;*
;* Description: Initializes Gravis UltraSound
;*
;* Input:	unsigned mixRate	mixing rate
;*		unsigned mode		output mode (see enum sdMode)
;*
;* Returns:	MIDAS error code
;*
;\***************************************************************************/

PROC	gdcInit 	_funct	mixRate : _int, mode : _int
USES    _si,_di,_bx

	mov	[gdcMode],0

	test	[mode],sd8bit		; force 8-bit?
	jnz	@@8b
	or	[gdcMode],sd16bit	; if not, use 16 bits
	jmp	@@bit
@@8b:	or	[gdcMode],sd8bit

@@bit:
; FIXME!!!
	or	[gdcMode],sdMono
	mov	_ax,[mixRate]

	mov	[gdcRate],_ax
	mov	[numChans],14			; Always 14 channels active
						; in mono mode
	mov	[bufHalf],0
	mov	[oldPos],0
	mov	[playing],0

	mov	_ax,[GDC.port]			; Base address (Set before!)
	add	_ax,103h
	mov	[selreg],_ax			; Register select (2x0h+103h)
	dec	_ax
	mov	[voicesel],_ax			; Voice select (2x0h+102h)
	add	_ax,2
	mov	[datalow],_ax			; Data Low Byte (2x0h+104h)

	call	gusReset			; Reset GUS


; Clear all 32 channels

	mov	_dx,[GDC.port]			; Mixer
	mov	al,3
	out	dx,al				; Disable Line in & out

	regsel	0eh
	add	_dx,2
	mov	al,31 OR 0c0h
	out	dx,al				; Set number of active
						; voices to 32 just for
						; sure

	mov	_cx,32				; Number of voices
@@resetloop:
	mov	_dx,[voicesel]			; Voice Select
	mov	_ax,_cx
	out	dx,al

	regsel	0				; Voice control
	add	_dx,2				; data low
	mov	al,3				; Stop voice
	out	dx,al

	regsel	9				; Current Volume
	inc	_dx				; data high
	mov	_ax,0500h			; Zero volume
	out	dx,ax

	regsel	12				; Pan Position
	add	_dx,2				; data low
	mov	al,8				; Center
	out	dx,al

	regsel	13				; Volume Ramping
	add	_dx,2				; data low
	mov	al,3				; disable
	out	dx,al

	regsel	6				; Ramp Rate
	add	_dx,2
	mov	al,3fh				; Rate
	out	dx,al

	dec	_cx
	jnz	@@resetloop

	; Take care of common initialization for all mixing Sound Devices:
	call	mixsdInit LANG, [gdcRate], [gdcMode], -1
	test	_ax,_ax
	jnz	@@err


	; Clear the GUS buffer

	regsel	4ch				; RESET
	add	_dx,2
	mov	al,3
	out	dx,al				; Enable GF1 and DACs

	mov	_cx,[dmaBufferSize]
	add	_cx,32

	xor	_bx,_bx

	regsel	44h				; Addr hi
	add	_dx,2				; 3x5
	xor	_ax,_ax
	out	dx,al				; upper bits of address

	regsel	43h				; Addr lo
@@cloop:
	mov	_dx,[datalow]
	mov	_ax,_bx
	out	dx,ax
	add	_dx,3				; 3x7
	xor	al,al
	inc	_bx
	out	dx,al
	dec	_cx
	jnz	@@cloop


	; Allocate an extra DMA buffer:
	mov	_ax,[dmaBufferSize]
	call	dmaAllocBuffer LANG, _ax, offset buffer2
	test	_ax,_ax
	jnz	@@err

	; Set amount of open channels:

	regsel	0eh
	add	_dx,2
	mov	_ax,[numChans]
	dec	_ax				; Amount-1
	or	al,0c0h
	out	dx,al

	mov	_ax,[gdcRate]
	shl	_ax,10
	xor	_dx,_dx
	mov	_bx,44100
	div	_bx
	and	_ax,NOT 1

	push	_ax

	mov	_dx,[voicesel]			; Select voice
	xor	_ax,_ax
	out	dx,al

	regsel	1				; Frequency control
	inc	_dx
	pop	_ax
	out	dx,ax

	mov	_cx,[dmaBufferSize]		; Set sample end
	test	[gdcMode],sd16bit
	jz	@@bit8
	shr	_cx,1
@@bit8:
	dec	_cx
	regsel	4				; End position high
	inc	_dx
	mov	_ax,_cx
	shr	_ax,7
	out	dx,ax
	regsel	5				; End position low
	inc	_dx
	mov	_ax,_cx
	shl	_ax,9
	out	dx,ax

	regsel	2				; Start position high
	inc	_dx
	xor	_ax,_ax
	out	dx,ax
	regsel	3				; Start position low
	inc	_dx
	xor	_ax,_ax
	out	dx,ax

	regsel	10				; Current position high
	inc	_dx
	xor	_ax,_ax
	out	dx,ax
	regsel	11				; Current position low
	inc	_dx
	xor	_ax,_ax
	out	dx,ax

	call	gusdelay

	out	dx,ax

	regsel	10				; Current position high
	inc	_dx
	xor	_ax,_ax
	out	dx,ax

	regsel	0				; Voice control
	mov	al,8				; Loop
	test	[gdcMode],sd16bit
	jz	@@8bit
	or	al,4				; 16 bit
@@8bit: add	_dx,2
	out	dx,al
	call	gusdelay			; Delay
	out	dx,al

	regsel	9				; Current volume
	inc	_dx
	mov	ax,0ef00h
	out	dx,ax
	call	gusdelay
	out	dx,ax

	call	dmaStop LANG, [GDC.DMA]

	regsel	41h
	add	_dx,2
	xor	al,al
	out	dx,al

	mov	_dx,[GDC.port]			; Mixer
	xor	al,al
	out	dx,al				; Enable Line in & out

@@ok:	xor	_ax,_ax 			; gdc succesfully initialized
	jmp	@@done


@@err:	ERROR	ID_gdcInit

@@done:
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gdcClose(void)
;*
;* Description: Uninitializes Gravis UltraSound
;*
;* Returns:	MIDAS error code
;*
;\***************************************************************************/

PROC	gdcClose	_funct
USES    _bx

	; Stop DMA
	call	dmaStop LANG, [GDC.DMA]

	regsel	41h
	add	_dx,2
	xor	al,al
	out	dx,al

	call	gusReset

	mov	_dx,[GDC.port]			; Mixer
	xor	al,al
	out	dx,al				; Enable Line in & out

	; Free the extra DMA buffer
	mov	_ax,[dmaBufferSize]
	mov	[buffer2.bufferLen],_ax
	call	dmaFreeBuffer LANG, offset buffer2
	test	_ax,_ax
	jnz	@@err

	; Take care of common uninitialization for all mixing Sound Devices:
	call	mixsdClose
	test	_ax,_ax
	jnz	@@err

	xor	_ax,_ax
	jmp	@@done


@@err:	ERROR	ID_gdcClose

@@done:
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gdcStartPlay(void)
;*
;* Description: Update the "DMA"-position of GUS
;*
;* Returns:	MIDAS error code
;*
;\***************************************************************************/

PROC	gdcStartPlay	_funct
USES    _bx

        mov     [dmaActive],0

	mov	_dx,[voicesel]			; Select voice
	xor	_ax,_ax
	out	dx,al

	regsel	8ah				; Current position high
	inc	_dx
	in	ax,dx

	xor	ecx,ecx
	mov	_cx,_ax
	and	_cx,01fffh
	shl	ecx,7

	regsel	8bh				; Current position low
	inc	_dx
	in	ax,dx
	shr	_ax,9
	or	_cx,_ax

	test	[gdcMode],sd16bit
	jz	@@ok16
	add	_cx,_cx
@@ok16:
	mov	_ax,_cx
	xor	_dx,_dx
	idiv	[dmaBufferSize]
	mov	[dmaPos],_dx

	xor	_ax,_ax
	ret
ENDP

;/***************************************************************************\
;*
;* Function:	int gdcPlay(int *play)
;*
;* Description: Uploads the mixing buffer contents to GUS
;*
;* Returns:	MIDAS error code
;*
;\***************************************************************************/

PROC	gdcPlay    _funct  play:dword
USES    _si,_di,_bx

	call	mixsdPlay LANG, [play]

	SetBorder(15)

        cmp     [dmaActive],0
        jne     @@skip

        cmp     [playing],0
        je      @@nodmacheck

        call    dmaGetPos LANG, offset buffer2, offset gusDMAPos
        mov     _si,[gusDMAPos]
        mov     _di,8

@@waitchange:
        call    dmaGetPos LANG, offset buffer2, offset gusDMAPos
        cmp     _si,[gusDMAPos]
        jne     @@skip
        call    gusdelay
        dec     _di
        jnz     @@waitchange

;        regsel  41h
;        add     _dx,2
;        in      al,dx
;        test    al,40h
;        jz      @@skip

@@nodmacheck:
	mov	_cx,[mixPos]
	and	_cx,NOT 31
	sub	_cx,[oldPos]
	jns	@@ok

	mov	_cx,[dmaBufferSize]
	sub	_cx,[oldPos]
	mov	_bx,[oldPos]
	mov	[oldPos],0
	test	_cx,_cx
	jz	@@skip
	jmp	@@copy

@@ok:	cmp	_cx,64
	jbe	@@skip

	mov	_bx,[oldPos]
	mov	_ax,[mixPos]
	and	_ax,NOT 31
	mov	[oldPos],_ax

@@copy:
	mov	[buffer2.bufferLen],_cx
	mov	[uploaded],_cx
	PUSHSEGREG ds
        LOADPTR ds,_si,[buffer.bufDataPtr]
        LOADPTR es,_di,[buffer2.bufDataPtr]
	add	_si,_bx
	shr	_cx,2
	cld
	rep	movsd
	POPSEGREG ds

	push	_bx
	call	dmaStop LANG, [GDC.DMA]

	regsel	41h
	add	_dx,2
	xor	al,al
	out	dx,al
	call	gusdelay
	out	dx,al
	pop	_bx

	shr	_bx,4
	cmp	[GDC.DMA],4
	jb	@@nope
	shr	_bx,1
@@nope:
	regsel	42h
	inc	_dx
	mov	_ax,_bx
	out	dx,ax

	regsel	41h
	add	_dx,2

	mov	al,00000001b			; 650kb/s
;	 mov	 al,00001001b			 ; 325kb/s
;	 mov	 al,00010001b			 ; 217kb/s
;	 mov	 al,00011001b			 ; 163kb/s
        or      al,20h
	cmp	[GDC.DMA],4
	jb	@@dmaok2
	or	al,4				; 16-bit DMA channel
@@dmaok2:
	test	[gdcMode],sd8bit
	jz	@@oka2
	or	al,80h				; Invert high bit
@@oka2:
; And START!
	out	dx,al
	call	gusdelay
	out	dx,al

	call	dmaPlayBuffer LANG, offset buffer2, [GDC.DMA], 0

	regsel	41h
	add	_dx,2
	in	al,dx

	mov	[playing],1
        mov     [dmaActive],1
@@skip:
	SetBorder(0)
	xor	_ax,_ax
	ret
ENDP


;* $Log: gusdac.asm,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/08/04 11:29:00  pekangas
;* All functions now preserve _Bx
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*

END