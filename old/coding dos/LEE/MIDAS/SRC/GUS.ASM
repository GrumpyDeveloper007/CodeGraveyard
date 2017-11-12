;*	GUS.ASM
;*
;* Gravis Ultrasound Sound Device
;*
;* $Id: gus.asm,v 1.3 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*

comment #

Preliminary InterWave support added on 08-Mar-1996
by Jarno Petteri Heikkinen (japehe@cc.jyu.fi)

historical notes:

13/04/96      "upgraded" gus code from pre-release 4

10/03/96      made somewhat "midas compliant" by defining two different
	      cards (gusCardTypes)
	      support for InterWave's >4MB memory does not exist
	      (cant test it anyway, I have only 2MB)

08/03/96      I dont have a clue about how MIDAS Surround thing works
	      so it prolly doesnt :)

#

IDEAL
P386
JUMPS

INCLUDE "lang.inc"
INCLUDE "errors.inc"
INCLUDE "sdevice.inc"
INCLUDE "mmem.inc"
INCLUDE "mglobals.inc"
INCLUDE "mutils.inc"

; This switch determines whether GUS SoundDevice should use full volume
; ramps when setting instruments (no clicks, but slower) or just faster
; ramping.  Value 1 sets fast ramps.

FASTGUS = 0

;/***************************************************************************\
;*	 enum gusFunctIDs
;*	 ----------------
;* Description:  ID numbers for GUS Sound Device functions
;\***************************************************************************/

enum	gusFunctIDs \
ID_gusDetect = ID_gus, \
ID_gusInit, \
ID_gusClose, \
ID_gusGetMixRate, \
ID_gusGetMode, \
ID_gusOpenChans, \
ID_gusCloseChans, \
ID_gusClearChans, \
ID_gusMute, \
ID_gusPause, \
ID_gusSetMasterVolume, \
ID_gusGetMasterVolume, \
ID_gusSetAmplification, \
ID_gusGetAmplification, \
ID_gusPlaySound, \
ID_gusReleaseSound, \
ID_gusStopSound, \
ID_gusSetRate, \
ID_gusGetRate, \
ID_gusSetVolume, \
ID_gusGetVolume, \
ID_gusSetSample, \
ID_gusGetSample, \
ID_gusSetPosition, \
ID_gusGetPosition, \
ID_gusGetDirection, \
ID_gusSetPanning, \
ID_gusGetPanning, \
ID_gusMuteChannel, \
ID_gusAddSample, \
ID_gusRemoveSample, \
ID_gusSetUpdRate, \
ID_gusStartPlay, \
ID_gusPlay, \
ID_gusInitHeap, \
ID_gusFreeHeap, \
ID_gusMalloc, \
ID_gusFree, \
ID_gusAllocBlock, \
ID_gusCoreFree


;/***************************************************************************\
;*	ENUM gusCardTypes
;*	----------------
;* Description: Sound Card type number for GUS Sound Device
;\***************************************************************************/

enum	gusCardTypes \
	gusAutoType = 0, \		; autodetect card type
	gusGF1, \			; original GF1 based card
	gusIW				; AMD InterWave based card


DATASEG

IFDEF	__PASCAL__
	EXTRN	GUS:SoundDevice
ENDIF

STRUC	gusInstrument
	D_int	sampleType	; sampleType
	D_long	sample		; ptr to sample in GUS mem
	D_long	surround	; ptr to surround sample in GUS mem / 0
	D_int	length		; length in bytes
	D_int	loopMode	; See enum
	D_int	loopNum 	; In loop 1/2 (0 if not looped [anymore])
	D_int	loop1Type	; See enum
	D_int	loop1Start	; Offset from beg.
	D_int	loop1End	; Offset from beg.
	D_int	loop2Type	; See enum
	D_int	loop2Start	; Offset from beg.
	D_int	loop2End	; Offset from beg.
ENDS



; STATUS BITS:

enum	gusStatusBits \
	gsStop = 1, \		; Stop voice
	gsRetrig = 2, \ 	; Retrig note
	gsVolume = 4, \ 	; Set volume
	gsFC = 8, \		; Set FC
	gsSample = 16, \	; Sample changed
	gsOnOff = 32, \ 	; Sample on/off (used for pause)
	gsPanning = 64, \	; Set panning
	gsMute = 128, \ 	; Muted
	gsReleased = 256	; Note released



STRUC	gusChannel
	D_int	status		; See enum above
	D_int	inst		; Number
	D_int	curinst 	; Current instrument playing
	D_int	fc		; In FC-format
	D_long	frequency	; In Hz
	D_int	volume		; 0-64
	D_int	surround	; Surround flag
	D_int	sampleType	; See enum
	D_int	loopMode	; See enum
	D_int	loop1Type	; See enum
	D_int	loop2Type	; See enum
	D_long	scurrent	; Current position for GUS
	D_long	sstart		; Sample start for GUS
	D_long	send		; Sample end for GUS
	D_long	l2start 	; Loop 2 start for GUS
	D_long	l2end		; Loop 2 end for GUS
	D_int	panning 	; Panning position (see enum)
	D_int	panningHW	; Panning hardware value
	D_int	onoff		; On / Off switch (DEBUG!)
ENDS


STRUC	ghb			; GUS Heap Block
	D_long	next		; Pointer to next block
	D_long	gusmem		; Pointer to GUS memory
	D_long	length		; Length of this block (Rounded to 32 byte border)
ENDS

; lengthFlags:
;		0 free / allocated



D_int	chancount	; Amount of channels
D_int	voicesel	; Voice Select register
D_int	selreg		; Select Register

D_int	mixfreq 	; Mixing frequency
D_int	updRate 	; SD update rate

D_int	instpos 	; Instrument to be filled next

D_int	muted		; 0 = unmuted, 1 = muted
D_int	paused		; 0 = not, 1 = paused
D_int	mastervol	; Default = max
D_int	masterchanged	; Overrides channel set volume
D_int	numInsts	; Max instrument.

D_long	memamount	; Amount of memory on GUS
D_long	memavail	; Memory available on GUS
D_long	largestblock	; Largest block of memory on GUS
D_long	gusHeapStart	; First block of GUS heap
D_long	gusHeap 	; Pointer to GUS heap
D_int	monoFlag	; Force mono output
D_long	temp		; Temporary storage
D_int	flag		; Internal flag
D_int	chansOpen	; channels open flag
D_int	gusAmp		; amplification value

label channels gusChannel
	rept	32
	gusChannel	?
	endm

D_long	Instruments	; Pointer to GUS instruments



IDATASEG


; If compiling for Pascal, Sound Device name is gusSD, from which the data
; will be copied to Sound Device GUS, defined in Pascal.

IFDEF	__PASCAL__
SDNAM		equ	gusSD
ELSE
SDNAM		equ	GUS
ENDIF


GLOBAL	SDNAM : SoundDevice

; sdMono or sdStereo or sd16bit, \

SDNAM	SoundDevice	< \
1, \					; Called according to tempo
sdUsePort or sdUseOutputMode, \
220h, 0, 0, \				; Port, IRQ, DMA
gusAutoType, 2,\			; Card, num.cards
sdMono or sdStereo or sd16bit, \
ptr_to gusSDName, \
ptr_to gusCardNames, \
6, ptr_to gusPortAddresses, \
ptr_to gusDetect, \
ptr_to gusInit, \
ptr_to gusClose, \
ptr_to gusGetMixRate, \
ptr_to gusGetMode, \
ptr_to gusOpenChans, \
ptr_to gusCloseChans, \
ptr_to gusClearChans, \
ptr_to gusMute, \
ptr_to gusPause, \
ptr_to gusSetMasterVolume, \
ptr_to gusGetMasterVolume, \
ptr_to gusSetAmplification, \
ptr_to gusGetAmplification, \
ptr_to gusPlaySound, \
ptr_to gusReleaseSound, \
ptr_to gusStopSound, \
ptr_to gusSetRate, \
ptr_to gusGetRate, \
ptr_to gusSetVolume, \
ptr_to gusGetVolume, \
ptr_to gusSetSample, \
ptr_to gusGetSample, \
ptr_to gusSetPosition, \
ptr_to gusGetPosition, \
ptr_to gusGetDirection, \
ptr_to gusSetPanning, \
ptr_to gusGetPanning, \
ptr_to gusMuteChannel, \
ptr_to gusAddSample, \
ptr_to gusRemoveSample, \
ptr_to gusSetUpdRate, \
ptr_to gusStartPlay, \
ptr_to gusPlay >

gusSDName	DB	"Gravis Ultrasound Sound Device v4.10",0

gusCardNames	DD ptr_to gusName
		DD ptr_to iwName

;gusName         DB "Gravis GF1 (Compatible mode)", 0
;iwName          DB "AMD InterWave (Enhanced mode)", 0
gusName         DB      "Gravis UltraSound (GF1 Hardware mixing)",0
iwName          DB      "GUS PnP (AMD Interwave Hardware mixing)",0

IFDEF __16__
gusPortAddresses DW	210h, 220h, 230h, 240h, 250h, 260h
ELSE
gusPortAddresses DD	210h, 220h, 230h, 240h, 250h, 260h
ENDIF

gusIRQAddresses  db 2, 3, 5, 7, 11, 12, 15
gusIRQints	 db 71h, 0bh, 0dh, 0fh, 73h, 74h, 77h


; gusInterrupt	  db 0		  ; fuck

env		DB "ULTRASND",0
env_iw		DB "INTERWAVE", 0

; Mixing frequencies for channel amounts 14-32

chantab dw	44100,41160,38587,36317,34300,32494,30870,29400,28063,26843
	dw	25725,24696,23746,22866,22050,21289,20580,19916,19293



LABEL	voltable	WORD
	dw	01500h,08f10h,09f10h,0ab50h,0af10h,0b970h,0bb50h,0bd30h
	dw	0bf10h,0c880h,0c970h,0ca60h,0cb50h,0cc40h,0cd30h,0ce20h
	dw	0cf10h,0d800h,0d880h,0d8f0h,0d970h,0d9e0h,0da60h,0dad0h
	dw	0db50h,0dbc0h,0dc40h,0dcb0h,0dd30h,0dda0h,0de20h,0de90h
	dw	0df10h,0df80h,0e800h,0e840h,0e880h,0e8b0h,0e8f0h,0e930h
	dw	0e970h,0e9a0h,0e9e0h,0ea20h,0ea60h,0ea90h,0ead0h,0eb10h
	dw	0eb50h,0eb80h,0ebc0h,0ec00h,0ec40h,0ec70h,0ecb0h,0ecf0h
	dw	0ed30h,0ed60h,0eda0h,0ede0h,0ee20h,0ee50h,0ee90h,0eed0h
	dw	0ef00h

	; Louder volume table

	IF	0
	dw	01500h,09c10h,0ac10h,0b910h,0bc10h,0bf10h,0c910h,0ca90h
	dw	0cc10h,0cd90h,0cf10h,0d850h,0d910h,0d9d0h,0da90h,0db50h
	dw	0dc10h,0dcd0h,0dd90h,0de50h,0df10h,0dfd0h,0e850h,0e8b0h
	dw	0e910h,0e970h,0e9d0h,0ea30h,0ea90h,0eaf0h,0eb50h,0ebb0h
	dw	0ec10h,0ec70h,0ecd0h,0ed30h,0ed90h,0edf0h,0ee50h,0eeb0h
	dw	0ef10h,0ef70h,0efd0h,0f820h,0f850h,0f880h,0f8b0h,0f8e0h
	dw	0f910h,0f940h,0f970h,0f9a0h,0f9d0h,0fa00h,0fa30h,0fa60h
	dw	0fa90h,0fac0h,0faf0h,0fb20h,0fb50h,0fb80h,0fbb0h,0fbe0h
	dw	0fc00h
	ENDIF

; Panning table for InterWave (pan registers are logarithmic too !!!)
label pantable word
	dw 0FFF0h, 06FD0h, 05FD0h, 05670h, 04FD0h, 04AB0h, 04670h, 042E0h
	dw 03FD0h, 03D20h, 03AB0h, 03870h, 03670h, 034A0h, 032E0h, 03150h
	dw 02FD0h, 02E70h, 02D20h, 02BE0h, 02AB0h, 02990h, 02870h, 02770h
	dw 02670h, 02580h, 024A0h, 023C0h, 022E0h, 02210h, 02150h, 02090h
	dw 01FD0h, 01F20h, 01E70h, 01DC0h, 01D20h, 01C70h, 01BE0h, 01B40h
	dw 01AB0h, 01A20h, 01990h, 01900h, 01870h, 017F0h, 01770h, 016F0h
	dw 01670h, 01600h, 01580h, 01510h, 014A0h, 01430h, 013C0h, 01350h
	dw 012E0h, 01280h, 01210h, 011B0h, 01150h, 010F0h, 01090h, 01030h
label pantablemid word
	dw 00FD0h, 00F70h, 00F20h, 00EC0h, 00E70h, 00E10h, 00DC0h, 00D70h
	dw 00D20h, 00CD0h, 00C70h, 00C30h, 00BE0h, 00B90h, 00B40h, 00AF0h
	dw 00AB0h, 00A60h, 00A20h, 009D0h, 00990h, 00940h, 00900h, 008C0h
	dw 00870h, 00830h, 007F0h, 007B0h, 00770h, 00730h, 006F0h, 006B0h
	dw 00670h, 00640h, 00600h, 005C0h, 00580h, 00550h, 00510h, 004D0h
	dw 004A0h, 00460h, 00430h, 003F0h, 003C0h, 00380h, 00350h, 00320h
	dw 002E0h, 002B0h, 00280h, 00250h, 00210h, 001E0h, 001B0h, 00180h
	dw 00150h, 00120h, 000F0h, 000C0h, 00090h, 00060h, 00030h, 00000h,0



CODESEG

;******* GUS Register Select - Macro ************

MACRO	regsel	register
	mov	_dx,[selreg]
	mov	al,register
	out	dx,al
ENDM

;******* GUS-delay subroutine ************

PROC	gusdelay NEAR
	push	dx ax
	mov	dx,300h
	rept	8
	in	al,dx
	endm
	pop	ax dx
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusDetect(int *result)
;*
;* Description: Detects Gravis UltraSound and fills in GUS SoundDevice
;*		structure with appropriate values for port, DMA and IRQ
;*
;* Returns:	MIDAS error code.
;*		1 stored to *result if GUS was detected, 0 if not.
;*
;\***************************************************************************/

PROC	gusDetect _funct   result : _ptr
USES    _bx

; interwave detect
	cmp	[GUS.cardType],gusAutoType	; has a card type been set?
	jne	@@cardtypeset			; if not, detect it

; this finds out if there's INTERWAVE env str set and forces
; native interwave mode if it exists... dunno about better way to detect ;)

IFDEF	__16__
	call	mGetEnv LANG, seg env offset env_iw
	mov	bx,ax
	or	bx,dx
ELSE
	call	mGetEnv LANG, ptr_to env_iw
	test	_ax, _ax
ENDIF
	mov	_dx, gusGF1
	jz	@@plaingus
	mov	_dx, gusIW
@@plaingus:
	mov	[GUS.cardType], _dx
@@cardtypeset:

IFDEF	__16__
	call	mGetEnv LANG, seg env offset env
	mov	bx,ax
	or	bx,dx
	jz	@@noGUS
	mov	bx,ax
	mov	es,dx			; point es:bx to environment string
ELSE
	call	mGetEnv LANG, ptr_to env
	test	eax,eax
	jz	@@noGUS
	mov	ebx,eax
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
	mov	[GUS.port],_ax
;
;	 mov	 cl, 3			 ; now skip three commas
;@@comma:
;	 mov	 al, [_esbx]
;	 inc	 _bx
;	 test	 al, al 		 ; if zero the ULTRASND env is wrong
;	 jz	 @@noGUS
;	 cmp	 al, ','
;	 jnz	 @@comma
;	 dec	 cl
;	 jnz	 @@comma
;
;	 mov	 al,[_esbx]		 ; first irq digit (skip comma)
;	 sub	 al,"0"
;	 mov	 ah, 10
;	 cmp	 [byte _esbx+1], ','
;	 jz	 @@onedigitirq
;	 imul	 ah
;	 add	 al,[_esbx+1]		 ; second irq digit is necessary
;	 sub	 al,"0"
;@@onedigitirq:
;	 xor	 ah, ah
;	 xor	 _bx, _bx
;@@scanirqlist:
;	 cmp	 [gusIRQAddresses+_bx], al
;	 jz	 @@scanirqfound
;	 inc	 _bx
;	 cmp	 _bx, 7
;	 jb	 @@scanirqlist
;	 jmp	 @@noGUS
;@@scanirqfound:
;	 cmp	 al, 2
;	 jnz	 @@not2nd
;	 mov	 al, 9
;@@not2nd:
;	 mov	 [GUS.IRQ],_ax
;
;	 mov	 al, [gusIRQints+_bx]	 ; translate irq to interrupt number
;	 mov	 [gusInterrupt], al
;	 inc	 bl			 ; irq ports start from 0 unlike our irq list
;	 mov	 _dx, [GUS.port]
;	 add	 dl, 0bh		 ; irq control register
;	 mov	 al, bl
;	 out	 dx, al
;

; Test if there really is a GUS

	add	_ax,103h
	mov	[selreg],_ax			; Register select (2x0h+103h)

	call	gusReset

	regsel	44h
	add	_dx,2
	xor	_ax,_ax
	out	dx,al				; upper bits of address

	regsel	43h
	inc	_dx
	xor	_ax,_ax 			; Address 0
	out	dx,ax
	add	_dx,3
	mov	al,055h
	out	dx,al				; Poke data 1 (55h)

	sub	_dx,3
	mov	_ax,1				; Address 1
	out	dx,ax
	add	_dx,3
	mov	al,0AAh
	out	dx,al				; Poke data 2 (AAh)

	sub	_dx,3
	xor	_ax,_ax 			; Address 0
	out	dx,ax
	add	_dx,3
	in	al,dx				; Peek data 1
	cmp	al,055h
	jne	@@noGUS

	sub	_dx,3
	mov	_ax,1				; Address 1
	out	dx,ax
	add	_dx,3
	in	al,dx				; Peek data 2
	cmp	al,0AAh
	je	@@found

@@noGUS:
	mov	[GUS.port],0
	xor	_ax,_ax 			; No GUS found
	jmp	@@quit

@@found:
	mov	_ax,1				; GUS found
@@quit:
	LOADPTR es,_bx,[result]
	mov	[_esbx],_ax
	xor	_ax,_ax
	ret
ENDP

;/***************************************************************************\
;*
;* Function:	int gusInit(int rate, int mode)
;*
;* Description: Initializes the GUS for playing
;*
;* Input:	int rate		Mixing rate (no effect on GUS)
;*		int mode		Mode (see enum) (mono flag only)
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusInit _funct	   rate : _int, mode : _int
USES    _di,_bx

	mov	[instpos],1			; First instrument to be filled
	mov	[numInsts],0			; No instruments
	mov	[mastervol],64			; Default master volume
	mov	[masterchanged],0
	mov	[flag],0
	mov	[chansOpen],0

	mov	_ax,[mode]
	and	_ax,sdMono			; AND mono bit
	mov	[monoFlag],_ax			; 1 if mono, 0 otherwise

;	 mov	 [monoFlag],0

	mov	_ax,[GUS.port]			; Base address (Set before!)
	add	_ax,103h
	mov	[selreg],_ax			; Register select (2x0h+103h)
	dec	_ax
	mov	[voicesel],_ax			; Voice select (2x0h+102h)

	call	gusReset			; Reset GUS

	cmp	[GUS.cardType], gusIW
	jnz	@@noiwfound			; interwave init?

; interwave to enhanced mode (19h bit 0)
	regsel	19h
	add	_dx, 2
	mov	al, 01h 			; set enhanced mode
	out	dx, al
@@noiwfound:

	mov	[memamount],0			; Initial memory amount
	mov	_cx,64				; Max amount of 256k chunks(IW)
	xor	_bx,_bx 			; Start from 00000h

@@memloop:
	regsel	44h
	add	_dx,2
	mov	_ax,_bx
	out	dx,al				; upper bits of address

	regsel	43h
	inc	_dx
	xor	_ax,_ax 			; Address 0
	out	dx,ax
	add	_dx,3
	mov	al,055h
	out	dx,al				; Poke data 1 (55h)

	sub	_dx,3
	mov	_ax,1				; Address 1
	out	dx,ax
	add	_dx,3
	mov	al,0AAh
	out	dx,al				; Poke data 2 (AAh)

	sub	dx,3
	xor	_ax,_ax 			; Address 0
	out	dx,ax
	add	_dx,3
	in	al,dx				; Peek data 1
	cmp	al,055h
	jne	@@poiss

	sub	_dx,3
	mov	_ax,1				; Address 1
	out	dx,ax
	add	_dx,3
	in	al,dx				; Peek data 2
	cmp	al,0AAh
	jne	@@poiss

	add	[memamount],256*1024		; Add amount of memory by 256k
	add	_bx,4				; Next 256k chunk
	dec	_cx
	jnz	@@memloop

@@poiss:					; No more memory
	cmp	[memamount],0
	jne	@@memok 			; NO MEMORY!

	mov	_ax,errSDFailure		; NO GUS
	jmp	@@err

@@memok:
	mov	eax,[memamount] 		; Initialize mem variables
	mov	[memavail],eax
	mov	[largestblock],eax


; Clear the all 32 channels

	mov	_dx,[GUS.port]			; Mixer
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

	cmp	[GUS.cardType], gusIW
	jnz	@@noiwregs

	regsel	15h				;interwave synth mode select
	add	_dx, 2
	mov	al, 22h ; deactivate voice (bit 1), enhanced panning (bit 5)
	out	dx, al

	regsel	10h				;interwave synth upper addr
	add	_dx, 2
	xor	eax, eax
	out	dx, al

	regsel	13h				;interwave synth left offset
	inc	dl
	mov	bx, [pantablemid]
	mov	ax, bx
	out	dx, ax
	regsel	1ch
	inc	dl
	mov	ax, bx
	out	dx, ax

	regsel	0ch				;interwave synth right offset
	inc	dl
	mov	ax, bx
	out	dx, ax
	regsel	1bh
	inc	dl
	mov	ax, bx
	out	dx, ax
@@noiwregs:
	dec	_cx
	jnz	@@resetloop

	regsel	4ch				; RESET
	add	_dx,2
	mov	al,3
	out	dx,al				; Enable GF1 and DACs

	mov	_dx,[GUS.port]
	xor	al,al
	out	dx,al				; Enable line in and out

	call	initHeap			; Initialize GUS-heap
	test	_ax,_ax
	jne	@@err

IFDEF	__16__
	call	memAlloc LANG, MAXSAMPLES * SIZE gusInstrument,\
		seg temp offset temp		; Alloc room for instruments
ELSE
	call	memAlloc LANG, MAXSAMPLES * SIZE gusInstrument,\
		ptr_to temp			; Alloc room for instruments
ENDIF
	test	_ax,_ax
	jne	@@err

	COPYPTR [Instruments],[temp]

	LOADPTR es,_di,[Instruments]
IFDEF	__32__
	push	ds
	pop	es
ENDIF
	xor	_ax,_ax
	mov	_cx,MAXSAMPLES * SIZE gusInstrument
	cld
	rep	stosb				; Clear instrument datas
	xor	_ax,_ax
	ret

@@err:	ERROR	ID_gusInit			; Heap error
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
;* FOR GUS SOUNDDEVICE INTERNAL USE ONLY!
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
;* Function:	int gusClose()
;*
;* Description: Closes up the GUS.
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusClose _funct
USES    _bx

	call	gusReset

	regsel	19h				; interwave to gus mode
	add	_dx, 2
	xor	al, al				; set gus compatible mode
	out	dx, al

	mov	_dx,[GUS.port]			; Mixer
	xor	al,al
	out	dx,al				; Enable Line in & out

	call	freeHeap
	test	_ax,_ax
	jnz	@@err

	call	memFree LANG, [Instruments]	; Free instruments
	test	_ax,_ax
	jnz	@@err

	mov	[instpos],1			; Flush instruments
	ret					; ax already 0

@@err:	ERROR	ID_gusClose
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusGetMixRate(int *rate)
;*
;* Description: Returns the mixing rate of the SD
;*
;* Returns:	MIDAS error code.
;*		Mixing rate is written to *rate.
;*
;\***************************************************************************/

PROC	gusGetMixRate _funct	   rate : _ptr
USES    _bx

	mov	_ax,[mixfreq]			 ; Get mixing rate
	LOADPTR es,_bx,[rate]
	mov	[_esbx],_ax
	xor	_ax,_ax 			 ; Can't fail
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gusGetMode(int *mode)
;*
;* Description: Returns the output mode
;*
;* Returns:	MIDAS error code.
;*		Output mode is written to *mode.
;*
;\***************************************************************************/

PROC	gusGetMode	_funct	   mode : _ptr
USES    _bx

	mov	_ax,sd16bit
	mov	_bx,2
	sub	_bx,[monoFlag]			; 1 if mono (=sdMono)
						; 2 if not (=sdStereo)
	or	_ax,_bx
	LOADPTR es,_bx,[mode]
	mov	[_esbx],_ax
	xor	_ax,_ax 			; Can't fail
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusOpenChans(int chans)
;*
;* Description: Opens channels from the GUS
;*
;* Input:	int chans		Number of channels to open
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusOpenChans _funct    chans : _int
USES    _si,_di,_bx

	mov	[gusAmp],64


	mov	_bx,[chans]
	mov	[chancount],_bx

	mov	[muted],0
	mov	[paused],0

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@nsurr
	add	_bx,_bx
	cmp	_bx,32
	ja	@@err
@@nsurr:
ENDIF
	cmp	_bx,14
	jae	@@okei
	mov	_bx,14				; At least 14 channels open
@@okei:
	mov	_cx,_bx

	sub	_bx,14
	add	_bx,_bx
	mov	bx,[chantab+_bx]	       ; Take the mixing rate

	cmp	[GUS.cardType], gusIW
	jnz	@@noiwmixrate
	mov	_bx, 44100		       ; interwave is always 44.1kHz
@@noiwmixrate:
	mov	[mixfreq],_bx

	regsel	0eh
	add	_dx,2
	mov	_ax,_cx
	dec	_ax				; Amount-1
	or	al,0c0h
	out	dx,al

	mov	_ax,ds
	mov	es,_ax
	mov	_di,offset channels
	xor	al,al
	cld
	mov	_cx,size gusChannel*32
	rep	stosb				; Clear channel blocks

	mov	_cx,[chans]			; to the table
	xor	_bx,_bx 			; Start from channel 0
@@panloop:
	mov	_dx,[voicesel]			; Voice Select
	mov	_ax,[chans]
	sub	_ax,_cx
	out	dx,al

	regsel	12				; Pan Position
	add	_dx,2				; data low

	mov	[_bx+channels.panning],panMiddle ; Panning position

	mov	al,8				; Middle
	out	dx,al

	cmp	[GUS.cardType], gusIW
	jnz	@@noiwregs

; interwave synth mode select
	regsel	15h
	add	_dx, 2
	mov	al, 20h 	; activate voice, select enhanced panning
	out	dx, al
; interwave synth right offset ( bigger blocks sound )
	regsel	0ch
	inc	dl
	mov	ax, [pantablemid]
	out	dx, ax
	regsel	1bh			; right offset fine
	inc	dl
	mov	ax, [pantablemid]
	out	dx, ax
; interwave synth left offset
	regsel	13h			; left offset
	inc	dl
	mov	ax, [pantablemid]
	out	dx, ax
	regsel	1ch			; left offset fine
	inc	dl
	mov	ax, [pantablemid]
	out	dx, ax

@@noiwregs:

	mov	[_bx+channels.status],gsStop
	cmp	[mEnableSurround],0
	je	@@nss

	mov	_ax,[chancount]
	imul	_ax,_ax,size gusChannel 	; Get surround chan
	mov	_si,_ax
	add	_si,_bx
	mov	[_si+channels.status],gsMute OR gsStop

@@nss:	add	_bx,SIZE gusChannel
	dec	_cx
	jnz	@@panloop

	mov	[chansOpen],1

	mov	_dx,[GUS.port]
	xor	al,al
	out	dx,al				; Enable line in and out

	call	gusMute LANG, 0
	test	_ax,_ax
	jnz	@@err2
	ret

@@err:	mov	_ax,errNoChannels		; Too much channels
@@err2: ERROR	ID_gusOpenChans
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusCloseChans()
;*
;* Description: Closes channels from the GUS
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusCloseChans	 _funct
USES    _bx

	call	gusClearChans LANG
	mov	[chansOpen],0
	mov	[chancount],0
	xor	_ax,_ax 		; Can't fail
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusClearChans()
;*
;* Description: Clears the channels from the GUS
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusClearChans	 _funct
USES    _si,_bx

	xor	_bx,_bx
	mov	_cx,[chancount]
@@clloop:
	mov	_dx,[voicesel]			; Voice Select
	mov	_ax,[chancount]
	sub	_ax,_cx
	out	dx,al

	regsel	0				; Voice control
	add	_dx,2
	mov	al,3
	out	dx,al				; Stop sound

	call	gusdelay

	out	dx,al				; Stop sound

	regsel	12				; Pan Position
	add	_dx,2				; data low

	mov	[_bx+channels.panning],panMiddle ; Panning position
	mov	[_bx+channels.inst],0		; No instrument
	mov	[_bx+channels.curinst],0	; No instrument
	mov	[_bx+channels.status],gsStop

	mov	al,8				; Middle
	out	dx,al

	cmp	[GUS.cardType], gusIW
	jnz	@@noiwregs
; interwave synth mode select
	regsel	0ch
	add	dl, 2
	mov	al, 2			; de-active channel
	out	dx, al
; interwave synth right offset
	regsel	0ch
	inc	dl
	mov	ax, [pantablemid]
	out	dx, ax
	regsel	1bh			; right offset fine
	inc	dl
	mov	ax, [pantablemid]
	out	dx, ax
; interwave synth left offset
	regsel	13h			; left offset
	inc	dl
	mov	ax, [pantablemid]
	out	dx, ax
	regsel	1ch			; left offset fine
	inc	dl
	mov	ax, [pantablemid]
	out	dx, ax
@@noiwregs:


IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@nss

	mov	_ax,[chancount]
	imul	_ax,_ax,size gusChannel 	; Get surround chan
	mov	_si,_ax
	add	_si,_bx
	mov	[_si+channels.status],gsMute OR gsStop

	mov	_dx,[voicesel]			; Voice Select
	mov	_ax,[chancount]
	add	_ax,_ax 			; Surround channel
	sub	_ax,_cx
	out	dx,al

	regsel	0				; Voice control
	add	_dx,2
	mov	al,3
	out	dx,al				; Stop sound

	call	gusdelay

	out	dx,al				; Stop sound

@@nss:
ENDIF
	add	_bx,SIZE gusChannel
	dec	_cx
	jnz	@@clloop
	xor	_ax,_ax 			; Can't fail
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusMute(ushort mute)
;*
;* Description: Mutes/unmutes GUS Sound Device
;*
;* Input:	int mute		UnMute = 0 / Mute = 1
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusMute _funct	   mute : _int
USES    _bx

	mov	_ax,[mute]
	cmp	[muted],_ax
	je	@@done				; Already at that state
	mov	[muted],_ax
	mov	bl,1				; Enable GF1 (Disable DACs)
	test	_ax,_ax
	jnz	@@mute
	mov	bl,3				; Enable DACs (unmute)
@@mute: cli
	regsel	4ch				; RESET
	add	_dx,2
	mov	al,bl
	out	dx,al
	sti
@@done: xor	_ax,_ax 			; Can't fail
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gusPause(ushort pause)
;*
;* Description: Pauses/unpauses GUS SD
;*
;* Input:	int pause		Unpause = 0 / Pause = 1
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusPause _funct     pause : _int
USES    _bx

	mov	_ax,[pause]
	cmp	[paused],_ax
	je	@@done				; Already at that state
	mov	[paused],_ax
	test	_ax,_ax
	jnz	@@pause

	xor	_cx,_cx
	xor	_bx,_bx
@@chloop:
	test	[_bx+channels.status],gsOnOff
	jz	@@off

	cli
	mov	_dx,[voicesel]			; Select voice
	mov	_ax,_cx
	out	dx,al

	regsel	0
	add	_dx,2
	mov	_ax,[_bx+channels.loopMode]
	cmp	_ax,sdLoopNone
	je	@@noloop
	cmp	_ax,sdLoopAmigaNone
	je	@@noloop
	cmp	_ax,sdLoopAmiga
	je	@@loopuni

	test	[_bx+channels.status],gsReleased
	jnz	@@loop2

	cmp	[_bx+channels.loop1Type],loopUnidir
	je	@@loopuni
	jmp	@@loopbidi

@@loop2:
	cmp	[_bx+channels.loop2Type],loopNone
	je	@@noloop
	cmp	[_bx+channels.loop2Type],loopBidir
	je	@@loopbidi

@@loopuni:
	mov	al,8
	jmp	@@loopok

@@loopbidi:
	mov	al,24
	jmp	@@loopok

@@noloop:
	xor	al,al

@@loopok:
	out	dx,al
	sti

@@off:	add	_bx,SIZE gusChannel
	inc	_cx
	cmp	_cx,32
	jne	@@chloop
	jmp	@@done

@@pause:
	xor	_cx,_cx
	xor	_bx,_bx
@@chloop2:
	cli
	mov	_dx,[voicesel]			; Select voice
	mov	_ax,_cx
	out	dx,al

	regsel	80h
	add	_dx,2
	in	al,dx
	sti

	and	_ax,1				; Voice on / off
	xor	al,1				; To active high
	shl	al,5				; to bit 5
	and	[_bx+channels.status],NOT gsOnOff
	or	[_bx+channels.status],_ax

	cli
	regsel	0
	add	_dx,2
	mov	al,3
	out	dx,al				; Stop
	sti

	add	_bx,SIZE gusChannel
	inc	_cx
	cmp	_cx,32
	jne	@@chloop2

@@done: xor	_ax,_ax
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gusSetMasterVolume(uchar master)
;*
;* Description: Sets the master volume for the GUS
;*
;* Input:	int master		new master volume (0-64)
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusSetMasterVolume _funct	master : _int
USES    _bx

	mov	_ax,[master]
	cmp	[mastervol],_ax
	je	@@done				; Already at that value
	mov	[mastervol],_ax
	mov	[masterchanged],1
@@done: xor	_ax,_ax 			; Can't fail
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	int gusGetMasterVolume(uchar *masterVolume)
;*
;* Description: Sets the master volume for the GUS
;*
;* Input:	int *masterVolume	pointer to master volume (0-64)
;*
;* Returns:	MIDAS error code. Master volume is written to *masterVolume.
;*
;\***************************************************************************/

PROC	gusGetMasterVolume _funct	masterVolume : _ptr
USES    _bx

	mov	_ax,[mastervol]
	LOADPTR es,_bx,[masterVolume]
	mov	[_esbx],_ax
	xor	_ax,_ax 		; Can't fail
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	int gusSetAmplification(unsigned amplification);
;*
;* Description: Sets amplification level - does nothing except stores the
;*		value for gusGetAmplification().
;*
;* Input:	unsigned amplification	amplification level - 64 = normal
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusSetAmplification _funct	amplification : _int

	mov	_ax,[amplification]
	mov	[gusAmp],_ax
	xor	_ax,_ax 		; Can't fail
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	int gusGetAmplification(unsigned *amplification);
;*
;* Description: Gets amplification level.
;*
;* Input:	unsigned *amplification   pointer to amplification level
;*
;* Returns:	MIDAS error code. Amplification level is written to
;*		*amplification.
;*
;\***************************************************************************/

PROC	gusGetAmplification _funct	amplification : _ptr
USES    _bx

	mov	_ax,[gusAmp]
	LOADPTR es,_bx,[amplification]
	mov	[_esbx],_ax
	xor	_ax,_ax 		; Can't fail
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	int gusPlaySound(int chan, ulong freq)
;*
;* Description: Starts a sound with a frequency
;*
;* Input:	int chan		Channel number
;*		ulong freq		Playing frequency
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/
PROC	gusPlaySound _funct	chan : _int, freq : dword
USES    _si,_bx
LOCAL	fc : _int

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@errchan

	imul	_bx,_bx,size gusChannel 	; Get channel block

	mov	eax,[freq]
	cmp	[_bx+channels.frequency],eax
	je	@@nochange
	mov	[_bx+channels.frequency],eax

	shl	eax,10
	xor	edx,edx
IFDEF	__16__
	xor	ecx,ecx
ENDIF
	mov	_cx,[mixfreq]			; GUS freq = frequency / mixing rate
	idiv	ecx
	and	al,0feh 			; Bit 0 unused
	mov	[_bx+channels.fc],_ax
	mov	[fc],_ax
	or	[_bx+channels.status],gsFC

@@nochange:
	mov	_dx,[_bx+channels.inst] 	; Instrument number
	test	_dx,_dx
	jz	@@errinst			; No instrument?
	cmp	[numInsts],_dx
	jb	@@errinst

	dec	_dx				; Table starts from 1
	imul	_dx,_dx,SIZE gusInstrument

	LOADPTR es,_si,[Instruments]
	add	_si,_dx
	cmp	[_essi+gusInstrument.length],0
	je	@@stop

	mov	ecx,[_essi+gusInstrument.sample] ; Start address
	mov	[_bx+channels.scurrent],ecx	; Tell start position to GUS
	and	[_bx+channels.status],NOT (gsStop OR gsReleased)
	or	[_bx+channels.status],gsRetrig

	mov	[_bx+channels.onoff],1

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@quit

	mov	_bx,[chan]
	add	_bx,[chancount]
	imul	_bx,_bx,size gusChannel 	  ; Get channel block

	mov	eax,[freq]
	cmp	[_bx+channels.frequency],eax
	je	@@nocha
	mov	[_bx+channels.frequency],eax

	mov	_ax,[fc]
	mov	[_bx+channels.fc],_ax
	or	[_bx+channels.status],gsFC

@@nocha:
	mov	ecx,[_essi+gusInstrument.surround] ; Start address
	test	ecx,ecx
	jnz	@@ok2
	mov	ecx,[_essi+gusInstrument.sample] ; Start address
@@ok2:	mov	[_bx+channels.scurrent],ecx	; Tell start position to GUS
	and	[_bx+channels.status],NOT (gsStop OR gsReleased)
	or	[_bx+channels.status],gsRetrig
	mov	[_bx+channels.onoff],1
ENDIF
@@quit:
	xor	_ax,_ax
	ret

@@stop: call	gusStopSound LANG, [chan]
	ret

@@errchan:
	mov	_ax,errInvalidChanNumber
	jmp	@@err
@@errinst:
	mov	_ax,errInvalidSampleHandle
@@err:	ERROR	ID_gusPlaySound
	ret

ENDP


;/***************************************************************************\
;*
;* Function:	int gusReleaseSound(int chan)
;*
;* Description: Releases a sound in channel
;*
;* Input:	int chan		Channel number
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusReleaseSound _funct	   chan : _int
USES    _bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@errchan

	imul	_bx,_bx,size gusChannel 	; Get channel block
	or	[_bx+channels.status],gsReleased
	xor	_ax,_ax
	ret

@@errchan:
	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusReleaseSound
	ret


ENDP

;/***************************************************************************\
;*
;* Function:	int gusStopSound(int chan)
;*
;* Description: Stops sound on a channel
;*
;* Input:	int chan		Channel number
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusStopSound _funct	chan : _int
USES    _bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@err

	imul	_bx,_bx,size gusChannel 	; Channel block

	and	[_bx+channels.status],NOT gsRetrig
	or	[_bx+channels.status],gsStop

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@quit

	mov	_bx,[chan]
	add	_bx,[chancount]
	imul	_bx,_bx,size gusChannel 	; Channel block

	and	[_bx+channels.status],NOT gsRetrig
	or	[_bx+channels.status],gsStop
ENDIF
@@quit: xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusStopSound
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusSetRate(int chan, ulong freq)
;*
;* Description: Sets the playing rate for a channel
;*
;* Input:	int chan		Channel number
;*		ulong freq		New playing frequency
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusSetRate _funct     chan : _int, freq : dword
USES    _bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@err

	imul	_bx,_bx,size gusChannel

	mov	eax,[freq]
	cmp	[_bx+channels.frequency],eax
	je	@@quit
	mov	[_bx+channels.frequency],eax

	shl	eax,10
	xor	edx,edx
IFDEF	__16__
	xor	ecx,ecx
ENDIF
	mov	_cx,[mixfreq]			; GUS freq = frequency / mixing rate
	idiv	ecx
	and	al,0feh 			; bit 0 unused
	mov	[_bx+channels.fc],_ax
	or	[_bx+channels.status],gsFC

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@quit

	mov	_bx,[chan]
	add	_bx,[chancount]
	imul	_bx,_bx,size gusChannel

	mov	[_bx+channels.fc],_ax
	mov	eax,[freq]
	mov	[_bx+channels.frequency],eax
	or	[_bx+channels.status],gsFC
ENDIF
@@quit: xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusSetRate
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusGetRate(int chan, ulong *freq)
;*
;* Description: Returns the playing rate for a channel
;*
;* Input:	int chan		Channel number
;*		ulong *freq		Pointer to frequency
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusGetRate	_funct	   chan : _int, freq : _ptr
USES    _bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@err

	cli
	mov	_dx,[voicesel]			 ; Select voice
	mov	_ax,_bx
	out	dx,al

	regsel	80h				; Voice control
	add	_dx,2
	in	al,dx
	sti

	test	al,1
	jnz	@@stopped			; Is sound on?

	mov	_bx,[chan]
	imul	_bx,_bx,size gusChannel

	mov	eax,[_bx+channels.frequency]
	LOADPTR es,_bx,[freq]
	mov	[_esbx],eax
	xor	_ax,_ax
	ret

@@stopped:
	LOADPTR es,_bx,[freq]
	mov	[dword _esbx],0
	xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusGetRate
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gusSetVolume(int chan, int volume)
;*
;* Description: Sets the volume for a channel
;*
;* Input:	int chan		Channel number
;*		int volume		New playing volume
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/
PROC	gusSetVolume	_funct	   chan : _int, vol : _int
USES    _bx

	mov	_ax,[vol]
	cmp	_ax,64
	jbe	@@not64 			; Max volume = 64
	mov	_ax,64
@@not64:
	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@err

	imul	_bx,_bx,size gusChannel

	cmp	[_bx+channels.volume],_ax
	je	@@quit

	mov	[_bx+channels.volume],_ax
	or	[_bx+channels.status],gsVolume

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@quit

	mov	_bx,[chan]
	add	_bx,[chancount]
	imul	_bx,_bx,size gusChannel

	mov	[_bx+channels.volume],_ax
	or	[_bx+channels.status],gsVolume
ENDIF
@@quit: xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusSetVolume
	ret

ENDP


;/***************************************************************************\
;*
;* Function:	int gusGetVolume(int chan, int *volume)
;*
;* Description: Sets the volume for a channel
;*
;* Input:	int chan		Channel number
;*		int *volume		Pointer to volume
;*
;* Returns:	MIDAS error code. Playing volume is written to *volume
;*
;\***************************************************************************/

PROC	gusGetVolume	_funct	   chan : _int, volume : _ptr
USES    _bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@err

	imul	_bx,_bx,size gusChannel

	mov	_ax,[_bx+channels.volume]
	LOADPTR es,_bx,[volume]
	mov	[_esbx],_ax

	xor	_ax,_ax
	jmp	@@done

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusGetVolume

@@done:
	ret

ENDP




;/***************************************************************************\
;*
;* Function:	int gusSetSample(int chan, int sample)
;*
;* Description: Sets up a sample for playing
;*
;* Input:	int chan		Channel number
;*		int inst		Sample number from AddSample
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusSetSample	  _funct     chan : _int, inst : _int
USES    edi,_si,_bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@errchn
	imul	_bx,_bx,size gusChannel 	; Channel block

	mov	_ax,[inst]
	test	_ax,_ax
	jz	@@errinst			; No instrument at all?
	cmp	[numInsts],_ax
	jb	@@errinst

	mov	_dx,_ax
	dec	_dx				; Table starts from 1
	imul	_dx,_dx,SIZE gusInstrument
	LOADPTR es,_si,[Instruments]
	add	_si,_dx

	cmp	[_bx+channels.inst],_ax
	je	@@nochange

	mov	[_bx+channels.inst],_ax 	; Set instrument

	cmp	[_essi+gusInstrument.length],0
	je	@@stop

	mov	_cx,[_essi+gusInstrument.sampleType]
	mov	[_bx+channels.sampleType],_cx

	mov	ecx,[_essi+gusInstrument.sample] ; Start address
	mov	[_bx+channels.scurrent],ecx
	mov	edi,ecx

	mov	_dx,[_essi+gusInstrument.loop1Type]
	mov	[_bx+channels.loop1Type],_dx	; Copy loop 1 type
	mov	_dx,[_essi+gusInstrument.loop2Type]
	mov	[_bx+channels.loop2Type],_dx	; Copy loop 2 type

	mov	_dx,[_essi+gusInstrument.loopMode]
	mov	[_bx+channels.loopMode],_dx	; Copy loop mode

	cmp	_dx,sdLoopNone
	je	@@noloop
	cmp	_dx,sdLoopAmigaNone
	je	@@noloop

IFDEF	__16__
	xor	eax,eax
ENDIF
	push	ecx edi
	mov	_ax,[_essi+gusInstrument.loop2End]
	add	ecx,eax 			; Loop 2 end address
	mov	[_bx+channels.l2end],ecx
	mov	_ax,[_essi+gusInstrument.loop2Start]
	add	edi,eax 			; Loop 2 end address
	mov	[_bx+channels.l2start],edi
	pop	edi ecx

	mov	_ax,[_essi+gusInstrument.loop1End]
	add	edi,eax 			; Loop end address
	mov	_ax,[_essi+gusInstrument.loop1Start]
	add	ecx,eax 			; Loop start address
	jmp	@@duu

@@noloop:
IFDEF	__16__
	xor	eax,eax
ENDIF
	mov	_ax,[_essi+gusInstrument.length]
	add	edi,eax 			; Sample end address
@@duu:
	mov	[_bx+channels.sstart],ecx	; Tell loop start to GUS
	mov	[_bx+channels.send],edi 	; And loop end
	or	[_bx+channels.status],gsSample

@@nochange:
IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@quit

	mov	_bx,[chan]
	add	_bx,[chancount]
	imul	_bx,_bx,size gusChannel 	; Channel block

	mov	_ax,[inst]

	cmp	[_bx+channels.inst],_ax
	je	@@nochange2

	mov	[_bx+channels.inst],_ax 	; Set instrument

	mov	ecx,[_essi+gusInstrument.surround] ; Start address
	test	ecx,ecx
	jnz	@@ok2
	mov	ecx,[_essi+gusInstrument.sample] ; Start address
@@ok2:
	mov	edi,ecx
IFDEF	__16__
	xor	eax,eax
ENDIF
	mov	_dx,[_essi+gusInstrument.loopMode]
	mov	[_bx+channels.loopMode],_dx	; Copy loop mode

	cmp	_dx,sdLoopNone
	je	@@noloop2
	cmp	_dx,sdLoopAmigaNone
	je	@@noloop2

	mov	_ax,[_essi+gusInstrument.loop1End]
	add	edi,eax 			; Loop end address
	mov	_ax,[_essi+gusInstrument.loop1Start]
	add	ecx,eax 			; Loop start address
	jmp	@@duu2

@@noloop2:
	mov	_ax,[_essi+gusInstrument.length]
	add	edi,eax 			; Sample end address
@@duu2:
	mov	[_bx+channels.sstart],ecx	; Tell loop start to GUS
	mov	[_bx+channels.send],edi 	; And loop end
	or	[_bx+channels.status],gsSample

@@nochange2:
ENDIF
@@quit:
	xor	_ax,_ax
	ret

@@stop: call	gusStopSound LANG, [chan]
	ret

@@errinst:
	mov	_ax,errInvalidSampleHandle
	jmp	@@err
@@errchn:
	mov	_ax,errInvalidChanNumber
@@err:	ERROR	ID_gusSetSample
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	int gusGetSample(int chan, ushort *sample)
;*
;* Description: Gets the last sample set for playing
;*
;* Input:	int chan		channel number
;*		int *sample		pointer to sample number
;*
;* Returns:	MIDAS error code. Sample number is written to *sample.
;*
;\***************************************************************************/

PROC	gusGetSample	_funct	   chan : _int, inst : _ptr
USES    _bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@errchn
	imul	_bx,_bx,size gusChannel 	  ; Channel block

	mov	_ax,[_bx+channels.inst]
	LOADPTR es,_bx,[inst]
	mov	[_esbx],_ax

	xor	_ax,_ax
	jmp	@@done

@@errchn:
	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusGetSample

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	int gusSetPosition(int chan, ushort pos)
;*
;* Description: Sets the playing position for a channel
;*
;* Input:	int chan		Channel number
;*		int pos 		New playing position
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/
PROC	gusSetPosition _funct	  chan : _int, pos : _int
USES    _si,_bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@err
	imul	_bx,_bx,size gusChannel 	; Channel block

	mov	_dx,[_bx+channels.inst]
	test	_dx,_dx
	jz	@@quit				; No instrument?

	dec	_dx				; Table starts from 1
	imul	_dx,_dx,SIZE gusInstrument
	LOADPTR es,_si,[Instruments]
	add	_si,_dx

IFDEF	__16__
	xor	ecx,ecx
ENDIF
	mov	_cx,[pos]
	cmp	[_essi+gusInstrument.sampleType],smp16bit
	jne	@@skip
	add	_cx,_cx
@@skip: cmp	[_essi+gusInstrument.length],_cx ; Over from end?
	jae	@@ok

	cmp	[_essi+gusInstrument.loopMode],sdLoopAmiga
	je	@@ale

	call	gusStopSound LANG, [chan]
	ret

@@ale:	mov	_cx,[_essi+gusInstrument.loop1Start] ; Yep. Start from loop

@@ok:	add	ecx,[_essi+gusInstrument.sample] ; Add sample start to position
	mov	[_bx+channels.scurrent],ecx	 ; Set start position
	and	[_bx+channels.status],NOT gsStop
	or	[_bx+channels.status],gsRetrig
	mov	[_bx+channels.onoff],1

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@quit

	mov	_bx,[chan]
	add	_bx,[chancount]
	imul	_bx,_bx,size gusChannel 	  ; Channel block
IFDEF	__16__
	xor	ecx,ecx
ENDIF
	mov	_cx,[pos]
	cmp	[_essi+gusInstrument.surround],0
	je	@@nop
	add	ecx,[_essi+gusInstrument.surround] ; Add sample start to position
	jmp	@@kop
@@nop:	add	ecx,[_essi+gusInstrument.surround] ; Add sample start to position
@@kop:	mov	[_bx+channels.scurrent],ecx	 ; Set start position
	and	[_bx+channels.status],NOT gsStop
	or	[_bx+channels.status],gsRetrig
	mov	[_bx+channels.onoff],1
ENDIF
@@quit: xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusSetPosition
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusGetPosition(int chan, ushort *pos)
;*
;* Description: Gets the playing position of a channel
;*
;* Input:	int chan	     Channel number
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusGetPosition _funct	  chan : _int, pos:_ptr
USES    _si,_bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@err

	cli
	mov	_dx,[voicesel]			; Select voice
	mov	_ax,_bx
	out	dx,al

	regsel	80h				; Voice control
	add	_dx,2
	in	al,dx
	test	al,1
	jnz	@@stopped			; Is sound on?

	imul	_bx,_bx,size gusChannel 	; Channel block

	;FIXME!
	cmp	[_bx+channels.sampleType],smp16bit
	je	@@stopped

@@huuko:
	regsel	8ah				; Current position high
	inc	_dx
	in	ax,dx
IFDEF	__16__
	xor	ecx,ecx
ENDIF
	mov	_cx,_ax
	and	_cx,01fffh
	shl	ecx,7

	regsel	8bh				; Current position low
	inc	_dx
	in	ax,dx
	shr	ax,9
	or	_cx,_ax

	call	gusdelay

; Read the value again to avoid GF1 self-modifying...
	regsel	8ah				; Current position high
	inc	_dx
	in	ax,dx
IFDEF	__16__
	xor	esi,esi
ENDIF
	mov	_si,_ax
	and	_si,01fffh
	shl	esi,7

	regsel	8bh				; Current position low
	inc	dx
	in	ax,dx
	shr	ax,9
	or	_si,_ax

; Some sanity checking...
	sub	esi,ecx
	js	@@huuko
	cmp	esi,16
	ja	@@huuko

	mov	_bx,[_bx+channels.curinst]
	dec	_bx
	imul	_bx,_bx,SIZE gusInstrument

	LOADPTR es,_si,[Instruments]
	sub	ecx,[_essi+_bx+gusInstrument.sample]
	jns	@@oke2

	xor	ecx,ecx
	jmp	@@oke
@@oke2:
	cmp	ecx,[_essi+_bx+gusInstrument.length]
	jb	@@oke

	mov	ecx,[_essi+_bx+gusInstrument.length]
	dec	ecx

@@oke:	sti
	LOADPTR es,_bx,[pos]
	mov	[_esbx],_cx
	xor	_ax,_ax
	ret

@@stopped:					; No sound is being played
	xor	_cx,_cx
	jmp	@@oke
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusGetPosition
	ret

ENDP


;/***************************************************************************\
;*
;* Function:	int gusGetDirection(int chan, ushort *dir)
;*
;* Description: Gets the playing direction of a channel
;*
;* Input:	int chan		Channel number
;*		int dir 		Pointer to direction
;*
;* Returns:	MIDAS error code.
;*		Playing direction is stored in *dir.
;*
;\***************************************************************************/

PROC	gusGetDirection _funct	   chan : _int, dir : _ptr
USES    _bx

	mov	_ax,[chan]
	cmp	[chancount],_ax
	jle	@@err

	cli
	mov	_dx,[voicesel]			; Select voice
	out	dx,al

	regsel	80h				; Voice control
	add	_dx,2
	in	al,dx
	sti

	test	al,40h
	jnz	@@back
	mov	_ax,1
	jmp	@@end
@@back:
	mov	_ax,-1
@@end:	LOADPTR es,_bx,[pos]
	mov	[_esbx],_ax
	xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusGetDirection
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusSetPanning(int chan, int panning)
;*
;* Description: Sets the panning position for a channel
;*
;* Input:	int channel		Channel number
;*		int panning		Panning value (See enum)
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusSetPanning	_funct	   chan : _int, panning : _int
USES    _bx

	mov	_ax,[chan]
	cmp	[chancount],_ax
	jle	@@err
	mov	_dx,[voicesel]			; Voice Select
	out	dx,al

	mov	_bx,_ax
	imul	_bx,_bx,size gusChannel 	; Channel block

	mov	_ax,[panning]
	cmp	[_bx+channels.panning],_ax
	je	@@kwit
	mov	[_bx+channels.panning],_ax	; Panning position

IFNDEF NOSTEREO
	cmp	[monoFlag],1
	je	@@kwit				; Skip if forced mono

	cmp	_ax,panSurround
	jne	@@juuh

	cmp	[mEnableSurround],0
	jne	@@huu
	xor	_ax,_ax 			; No surround enabled --> middle
	jmp	@@juuh

@@huu:
	mov	[_bx+channels.panningHW],0	; Extreme left
	or	[_bx+channels.status],gsPanning

	mov	[_bx+channels.surround],1	; This is a surround channel
	mov	_ax,[_bx+channels.status]	; Copy status (mute)

	mov	_cx,[chancount]
	imul	_cx,_cx,size gusChannel 	; Channel block
	add	_bx,_cx

	mov	[_bx+channels.panningHW],15	; Extreme right
	mov	[_bx+channels.surround],1	; This is a surround, too
	mov	[_bx+channels.status],_ax
	jmp	@@jatkuu

@@juuh: mov	[_bx+channels.surround],0	; Normal channel

	sar	_ax,3
	or	_ax,_ax 			; Sign
	jns	@@pos
	inc	_ax
@@pos:	add	_ax,7
	mov	[_bx+channels.panningHW],_ax
	or	[_bx+channels.status],gsPanning

	mov	_bx,[chan]
	add	_bx,[chancount]
	cmp	_bx,32
	jae	@@jatkuu
	imul	_bx,_bx,size gusChannel 	; Channel block
	mov	[_bx+channels.surround],0	; No longer surround channel (?)
	or	[_bx+channels.status],gsMute

@@jatkuu:
	mov	[masterchanged],1		; Force reset of volume
ENDIF
@@kwit: sti
@@quit: xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusSetPanning
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gusGetPanning(int chan, short *panning)
;*
;* Description: Gets the panning position for a channel
;*
;* Input:	int channel		Channel number
;*		int *panning		Pointer to panning value
;*
;* Returns:	MIDAS error code.
;*		Panning value is stored in *panning.
;*
;\***************************************************************************/

PROC	gusGetPanning	_funct	   channel : _int, panning : _ptr
USES    _bx

	mov	_bx,[channel]
	cmp	[chancount],_bx
	jle	@@err
	imul	_bx,_bx,size gusChannel 	; Channel block
	mov	_ax,[_bx+channels.panning]	; Panning position
	LOADPTR es,_bx,[panning]
	mov	[_esbx],_ax
	xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusGetPanning
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gusMuteChannel(int chan, int mute)
;*
;* Description: Mutes or unmutes a channel
;*
;* Input:	int chan		Channel number
;*		int mute		Unmute = 0 / Mute = 1
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusMuteChannel	_funct	   chan : _int, mute : _int
USES    _bx

	mov	_bx,[chan]
	cmp	[chancount],_bx
	jle	@@err
	imul	_bx,_bx,SIZE gusChannel

	cmp	[mute],1
	je	@@mute
	and	[_bx+channels.status],NOT gsMute
	or	[_bx+channels.status],gsVolume
	jmp	@@guu
@@mute:
	or     [_bx+channels.status],gsMute OR gsVolume

@@guu:
IFNDEF NOSTEREO
	cmp	[_bx+channels.surround],0
	je	@@pois

	mov	_bx,[chan]
	add	_bx,[chancount]
	imul	_bx,_bx,SIZE gusChannel

	cmp	[mute],1
	je	@@mute2
	and	[_bx+channels.status],NOT gsMute
	or	[_bx+channels.status],gsVolume
	jmp	@@pois
@@mute2:
	or     [_bx+channels.status],gsMute OR gsVolume
ENDIF
@@pois: xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidChanNumber
	ERROR	ID_gusMuteChannel
	ret

ENDP


;/***************************************************************************\
;*
;* Function:	int gusAddSample(sdSample *sample, int copySample,
;*				 int *sdNum);
;*
;* Description:  Adds a new sample to the sample list
;*
;* Input:	 sdSample *sample	pointer to sample information
;*					structure.
;*		 int copySample 	1 if sample should be copied
;*		 int *sdNum		pointer to variable to store the SD
;*					sample handle
;*
;* Returns:	MIDAS error code.
;*		SD sample handle is stored in *sdNum.
;*
;\***************************************************************************/

PROC	gusAddSample _funct	sample : _ptr, copysample : _int, sdNum : _ptr
USES    _si,_di,_bx
LOCAL	gusmem : dword, gusmem2 : dword, smpStart : _ptr, glength : _int, \
	loopMode : _int, loopStart : _int

	LOADPTR gs,_si,[sample]
	cmp	[_gssi+sdSample.sampleType],smp8bit
	je	@@instok
	cmp	[_gssi+sdSample.sampleType],smp16bit
	je	@@instok
	cmp	[_gssi+sdSample.sampleType],smpNone
	jne	@@errinst
	mov	[_gssi+sdSample.sampleLength],0
@@instok:
	mov	_ax,[instpos]
	dec	_ax				; Table starts from 1
	imul	_ax,_ax,SIZE gusInstrument
	LOADPTR es,_di,[Instruments]
	add	_di,_ax

	cmp	[_gssi+sdSample.sampleLength],0
	je	@@nsurr

	cmp	[_gssi+sdSample.sampleType],smp8bit
	jne	@@not8bit

	; FIXME!!!!
	mov	_cx,[_gssi+sdSample.sampleLength]

	PUSHSEGREG es
	LOADPTR es,_bx,[_gssi+sdSample.sample]	; Pointer to sample
@@signloop:
	xor	[byte _esbx],80h
	inc	_bx
	dec	_cx
	jnz	@@signloop
	POPSEGREG es

@@not8bit:
	PUSHSEGREG es gs
	call	gusMalloc LANG, [_gssi+sdSample.sampleLength],	\
		 [_gssi+sdSample.sampleType], ptr_to temp
	POPSEGREG gs es
	test	_ax,_ax
	jnz	@@err

	mov	eax,[temp]
	mov	[gusmem],eax

	mov	[_esdi+gusInstrument.sample],eax   ; Sample start
	mov	[_esdi+gusInstrument.surround],0

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@nsurr
	cmp	[_gssi+sdSample.sampleType],smp16bit
	je	@@nsurr

	PUSHSEGREG es
	call	gusMalloc LANG, [_gssi+sdSample.sampleLength],	\
		 [_gssi+sdSample.sampleType], ptr_to temp
	POPSEGREG es
	test	_ax,_ax
	jnz	@@err

	mov	eax,[temp]
	mov	[gusmem2],eax
	mov	[_esdi+gusInstrument.surround],eax ; Surround sample start
ENDIF
@@nsurr:
	COPYPTR [smpStart],[_gssi+sdSample.sample]

	; FIXME!
	mov	_ax,[_gssi+sdSample.sampleType]
	cmp	_ax,smpNone
	jne	@@smp2
	mov	_ax,smp8bit
@@smp2:
	mov	[_esdi+gusInstrument.sampleType],_ax

	mov	_ax,[_gssi+sdSample.sampleLength]
	mov	[_esdi+gusInstrument.length],_ax ; Sample length

	mov	_ax,[_gssi+sdSample.loopMode]
	mov	[_esdi+gusInstrument.loopMode],_ax
	mov	[loopMode],_ax

	mov	_ax,[_gssi+sdSample.loop1Type]
	mov	[_esdi+gusInstrument.loop1Type],_ax

	mov	_ax,[_gssi+sdSample.loop1Start]
	mov	[_esdi+gusInstrument.loop1Start],_ax

	mov	_ax,[_gssi+sdSample.loop1End]
	mov	[_esdi+gusInstrument.loop1End],_ax

	mov	_ax,[_gssi+sdSample.loop2Type]
	mov	[_esdi+gusInstrument.loop2Type],_ax

	mov	_ax,[_gssi+sdSample.loop2Start]
	mov	[_esdi+gusInstrument.loop2Start],_ax

	mov	_ax,[_gssi+sdSample.loop2End]
	mov	[_esdi+gusInstrument.loop2End],_ax

;PK-
	cmp	[loopMode],sdLoop2
	jne	@@loop1
;-PK
	cmp	[_gssi+sdSample.loop2Type],loopNone
	je	@@loop1
	mov	_ax,[_gssi+sdSample.loop2Start]
	jmp	@@loopok
@@loop1:
	mov	_ax,[_gssi+sdSample.loop1Start]
@@loopok:
	mov	[loopStart],_ax

	mov	_cx,[_gssi+sdSample.sampleLength]
	test	_cx,_cx
	jz	@@qwit

	LOADPTR es,_si,[smpStart]		; Pointer to sample

	mov	ebx,[gusmem]			; Start in GUS memory
IFDEF	__32__
	xor	edi,edi
ENDIF
	mov	di,bx
	shr	ebx,16

	mov	[flag],1

@@dumploop2:
	cli
	regsel	44h				; Addr hi
	add	_dx,2				; 3x5
	mov	_ax,_bx
	out	dx,al				; upper bits of address
	sti

	regsel	43h				; Addr lo
@@dumploop:
	mov	_dx,[selreg]
	mov	_ax,_di
	inc	_dx				; 3x4
	out	dx,ax
	add	_dx,3				; 3x7
	mov	al,[_essi]			; Get data
	inc	_si
	out	dx,al

	inc	di
	jz	@@yli64
	dec	_cx
	jnz	@@dumploop			; Dump the whole sample
	jmp	@@quit

@@yli64:
	inc	_bx				; Crossed 64kb border
	dec	_cx
	jnz	@@dumploop2			; Dump the whole sample


@@quit:
	cmp	[loopMode],sdLoopNone
	je	@@noloob
	cmp	[loopMode],sdLoop1Rel
	je	@@noloob
	cmp	[loopMode],sdLoopAmigaNone
	je	@@noloob
@@loobed:					; Copy loop to next 32 byte border
	LOADPTR es,_si,[smpStart]
	add	_si,[loopStart]

	mov	_dx,_di
	mov	_cx,64
	and	_dx,01fh			 ; AND lowest bits off
	sub	_cx,_dx

@@dumploop3:
	cli
	regsel	44h				; Addr hi
	add	_dx,2				; 3x5
	mov	_ax,_bx
	out	dx,al				; upper bits of address
	sti

	regsel	43h				; Addr lo
@@dumploop4:
	mov	_dx,[selreg]
	mov	_ax,_di
	inc	_dx				; 3x4

	out	dx,ax
	add	_dx,3				; 3x7
	mov	al,[_essi]			; Get data
	inc	_si
	out	dx,al

	inc	di
	jz	@@yli642
	dec	_cx
	jnz	@@dumploop4			; Do whole loop
	jmp	@@qwti

@@yli642:
	inc	_bx				; Crossed 64kb border
	dec	_cx
	jnz	@@dumploop3			; Do whole loop
	jmp	@@qwti


@@noloob:					; Copy the last byte
	dec	_si
	mov	_dx,_di
	mov	_cx,64
	and	_dx,01fh			; AND lowest bits away...
	sub	_cx,_dx

@@dumploop5:
	cli
	regsel	44h				; addr hi
	add	_dx,2				; 3x5
	mov	_ax,_bx
	out	dx,al				; upper bits of address
	sti

	regsel	43h				; addr lo
@@dumploop6:
	mov	_dx,[selreg]
	inc	_dx				; 3x4
	mov	_ax,_di

	out	dx,ax
	mov	al,[_essi]			; Get data
	add	_dx,3				; 3x7
	out	dx,al

	inc	di
	jz	@@yli643
	dec	_cx
	jnz	@@dumploop6
	jmp	@@qwti

@@yli643:
	inc	_bx				; Crossed 64kb border
	dec	_cx
	jnz	@@dumploop5

@@qwti:
	LOADPTR gs,_si,[sample]

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@qwit
	cmp	[_gssi+sdSample.sampleType],smp16bit
	je	@@qwit

	call	CopySurroundSample LANG, [smpStart], [glength], [loopStart],\
					 [loopMode], [gusmem2]

ENDIF
@@qwit:
	cmp	[_gssi+sdSample.sampleType],smp8bit
	jne	@@not8bit2

	; FIXME!!!!
	mov	_cx,[_gssi+sdSample.sampleLength]
	test	_cx,_cx
	jz	@@not8bit2

	PUSHSEGREG es
	LOADPTR es,_bx,[_gssi+sdSample.sample]	; Pointer to sample
@@signloop2:
	xor	[byte _esbx],80h
	inc	_bx
	dec	_cx
	jnz	@@signloop2
	POPSEGREG es

@@not8bit2:
	push	[instpos]			; Return instrument number

	mov	[flag],0

	mov	_ax,[instpos]
	mov	_bx,_ax
	dec	_bx
	imul	_bx,_bx,SIZE gusInstrument
	LOADPTR es,_si,[Instruments]
	add	_si,_bx
@@search:					; Search next free instrument
	cmp	[_essi+gusInstrument.sampleType],smpNone
	je	@@found
	add	_si,SIZE gusInstrument
	inc	_ax
	jmp	@@search

@@found:
	mov	[instpos],_ax
	pop	_ax
	LOADPTR es,_bx,[sdNum]
	mov	[_esbx],_ax

	cmp	[numInsts],_ax
	jae	@@huu
	mov	[numInsts],_ax
@@huu:
	xor	_ax,_ax
	ret


@@errinst:
	mov	_ax,errInvalidInst
@@err:	ERROR	ID_gusAddSample
	ret
ENDP


IFNDEF NOSTEREO
PROC	CopySurroundSample NEAR inst : _ptr, glength : _int, loopStart : _int,\
				gloop : _int, gusmem : dword
USES    _si,_di,_bx

	LOADPTR es,_si,[inst]			; Pointer to sample

	mov	_cx,[glength]

	mov	ebx,[gusmem]			; Start in GUS memory
	mov	_di,_bx
	shr	ebx,16

@@dumploop2:
	cli
	regsel	44h
	add	_dx,2				;3x5
	mov	_ax,_bx
	out	dx,al				;upper bits of address
	sti

	regsel	43h
@@dumploop:
	mov	_dx,[selreg]
	inc	_dx				; 3x4
	mov	_ax,_di
	out	dx,ax
	add	_dx,3				; 3x7
	mov	al,[_essi]			; Get data
	inc	_si
	not	al				; 180 degree phase transformation
	out	dx,al

	inc	di
	jz	@@yli64
	dec	_cx
	jnz	@@dumploop			; Dump the whole sample
	jmp	@@quit

@@yli64:
	inc	_bx				; Crossed 64kb border
	dec	_cx
	jnz	@@dumploop2			; Dump the whole sample

@@quit:
	cmp	[loopMode],sdLoopNone
	je	@@noloob
	cmp	[loopMode],sdLoop1Rel
	je	@@noloob
	cmp	[loopMode],sdLoopAmigaNone
	je	@@noloob

@@loobed:					; Copy loop to next 32 byte border
	LOADPTR es,_si,[inst]
	add	_si,[loopStart]

	mov	_dx,_di
	and	_dx,01fh			; AND the lowest bits away...
	mov	_cx,64
	sub	_cx,_dx

@@dumploop3:
	cli
	regsel	44h
	add	_dx,2				;3x5
	mov	_ax,_bx
	out	dx,al				;upper bits of address
	sti

	regsel	43h
@@dumploop4:
	mov	_dx,[selreg]
	mov	_ax,_di
	inc	_dx				; 3x4

	out	dx,ax
	add	_dx,3				; 3x7
	mov	al,[_essi]			; Get data
	inc	_si
	not	al				; 180 degree phase transformation
	out	dx,al

	inc	di
	jz	@@yli642
	dec	_cx
	jnz	@@dumploop4			; Do whole loop
	jmp	@@qwit

@@yli642:
	inc	_bx				; Crossed 64kb border
	dec	_cx
	jnz	@@dumploop3			; Do whole loop
	jmp	@@qwit

@@noloob:					; Copy the last byte
	mov	_dx,_di
	dec	_si
	and	_dx,01fh			; Alimmat pois
	mov	_cx,64
	sub	_cx,_dx

@@dumploop5:
	cli
	regsel	44h
	add	_dx,2				;3x5
	mov	_ax,_bx
	out	dx,al				;upper bits of address
	sti

	regsel	43h
@@dumploop6:
	mov	_dx,[selreg]
	mov	_ax,_di
	inc	_dx				; 3x4

	out	dx,ax
	add	dx,3				; 3x7
	mov	al,[_essi]			; Get data
	not	al				; 180 degree phase transformation
	out	dx,al

	inc	di
	jz	@@yli643
	dec	_cx
	jnz	@@dumploop6
	jmp	@@qwit
@@yli643:
	inc	_bx				; Crossed 64kb border
	dec	_cx
	jnz	@@dumploop5
@@qwit:
	ret
ENDP
ENDIF

;/***************************************************************************\
;*
;* Function:	int gusRemoveSample(int sample)
;*
;* Description: Removes a sample from the GUS SD internal tables
;*		and frees it from GUS memory
;*
;* Input:	int sample		Sample number from AddSample
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusRemoveSample _funct	   sample : _int
USES    _si,_bx

	mov	_bx,[inst]
	dec	_bx
	imul	_bx,_bx,SIZE gusInstrument
	LOADPTR es,_si,[Instruments]
	add	_si,_bx

	cmp	[_essi+gusInstrument.sampleType],smpNone
	je	@@nothing

	mov	[_essi+gusInstrument.sampleType],smpNone ; Free instrument

	cmp	[_essi+gusInstrument.length],0
	je	@@nsurround

	PUSHSEGREG es
	call	gusFree LANG, [_essi+gusInstrument.sample]
	POPSEGREG es
	test	_ax,_ax
	jnz	@@err

IFNDEF NOSTEREO
	cmp	[_essi+gusInstrument.surround],0
	je	@@nsurround

	call	gusFree LANG, [_essi+gusInstrument.surround]
	test	_ax,_ax
	jnz	@@err
ENDIF
@@nsurround:
	mov	_ax,[inst]
	cmp	[instpos],_ax
	jbe	@@nothing

	mov	[instpos],_ax			; Lowest instrument number
@@nothing:
	cmp	[numInsts],_ax
	jne	@@juu

	LOADPTR es,_si,[Instruments]
	mov	_cx,_ax
	mov	_bx,1
	mov	_ax,_bx
@@search:					; Search next free instrument
	cmp	[_essi+gusInstrument.sampleType],smpNone
	je	@@nop
	mov	_ax,_bx
@@nop:	add	_si,SIZE gusInstrument
	inc	_bx
	dec	_cx
	jnz	@@search
	mov	[numInsts],_ax
@@juu:	xor	_ax,_ax
	ret

@@err:	ERROR	ID_gusRemoveSample
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gusSetUpdRate(int rate)
;*
;* Description: Sets the update rate of SD.
;*
;* Input:	int rate		Rate in Hz*100
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/

PROC	gusSetUpdRate _funct	 rate : _int

	mov	_ax,[rate]
	mov	[updRate],_ax
	xor	_ax,_ax
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	 int gusStartPlay(void);
;*
;* Description:  Called before gusPlay() is called. This function doesn't
;*		 have to do anything, however.
;*
;* Returns:	 MIDAS error code
;*
;\***************************************************************************/

PROC	gusStartPlay	_funct

	xor	_ax,_ax
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	int gusPlay(int *callMP)
;*
;* Description: Updates the GUS registers according to the Sound Device
;*		internal datas
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/
PROC	gusPlay _funct	   callMP : _ptr
LOCAL	chanc : _int, selsave : _int, voicesave : _int, retrigfl : _int
USES    _di,_si,_bx

	cmp	[paused],0
	jne	@@paused

	cmp	[chansOpen],0
	je	@@paused

	xor	_ax,_ax
	mov	_dx,[voicesel]
	in	al,dx
	mov	[voicesave],_ax

	mov	_dx,[selreg]
	in	al,dx
	cmp	[flag],0			; Are we uploading
	je	@@kd				; at the same time?
	mov	al,43h
@@kd:	mov	[selsave],_ax

	mov	[chanc],0			; Start from channel 0
	xor	_si,_si 			; Channel data
@@loop:
	cmp	[_si+channels.onoff],0
	je	@@retrigged

	mov	_dx,[voicesel]			; Select voice
	mov	_ax,[chanc]
	out	dx,al

	test	[_si+channels.status],gsStop OR gsRetrig ; Retrig / stop sound?
	jz	@@nothing

	and	[_si+channels.status],NOT gsStop

IF FASTGUS
	test	[_si+channels.status],gsRetrig
	jz	@@juststop

	regsel	9				; Current volume
	inc	_dx
	mov	_ax,1500h
	out	dx,ax

	call	gusdelay

	out	dx,ax
	jmp	@@setfc

@@juststop:
ENDIF
	regsel	7				; Volume ramp start
	add	_dx,2
	mov	al,15h				; to zero
	out	dx,al

	regsel	0dh				; Volume ramp control
	add	_dx,2
	mov	al,40h				; Start decreasing ramp
	out	dx,al

	regsel	0				; Voice control
	add	_dx,2
	mov	al,3				; Stop voice
	out	dx,al

	call	gusdelay

	out	dx,al				; again...

	regsel	0dh				; Volume ramp control
	add	_dx,2
	mov	al,40h				; Start decreasing ramp
	out	dx,al
	jmp	@@setfc

@@nothing:
	cmp	[masterchanged],0
	jnz	@@set
	test	[_si+channels.status],gsVolume
	jz	@@setfc
@@set:	and	[_si+channels.status],NOT gsVolume
	regsel	89h
	inc	_dx
	in	ax,dx

	mov	cx,ax
	xor	cl,cl

	mov	_ax,[_si+channels.volume]	; To set volume
	test	[_si+channels.status],gsMute
	jz	@@oek2
	xor	_ax,_ax
@@oek2: mov	_bx,[mastervol]
	mul	bl
	shr	_ax,6
	mov	_bx,_ax
	add	_bx,_bx
	mov	bx,[voltable+_bx]

	cmp	[_si+channels.surround],0
	je	@@hu2
	sub	bh,10h				; Halve the volume
@@hu2:	xor	bl,bl
	cmp	cx,bx
	je	@@setfc 			; Already at that value
	cmp	cx,bx
	jb	@@yli
	xchg	cx,bx
	mov	cl,40h
@@yli:
	regsel	0dh				; Ramp Control
	add	_dx,2
	mov	al,3
	out	dx,al				; Stop Ramp

	call	gusdelay

	out	dx,al				; Stop Ramp

	regsel	7				; Ramp start
	add	_dx,2
	mov	al,ch				; From lower
	out	dx,al

	regsel	8				; Ramp end
	add	_dx,2
	mov	al,bh				; To higher volume
	out	dx,al

	regsel	0dh				; Ramp Control
	add	_dx,2
	mov	al,cl
	out	dx,al				; GO!

	call	gusdelay

	out	dx,al				; GO!

@@setfc:
	test	[_si+channels.status],gsFC
	jz	@@setpan

	and	[_si+channels.status],NOT gsFC
	regsel	1				; Frequency control
	inc	_dx
@@writefc:
	mov	_ax,[_si+channels.fc]
	out	dx,ax

; Let's see if this helps the Tone Portamento problems... (PK)
; Unfortunately this has no chances of working, reading GUS
; registers is made from register+80h... (JP)
	if	0
	call	gusdelay
	in	ax,dx
	cmp	_ax,[_si+channels.fc]
	je	@@fcok
	call	gusdelay
	jmp	@@writefc
@@fcok:
; End of TP fix
	endif


@@setpan:
	test	[_si+channels.status],gsPanning
	jz	@@stopped

	and	[_si+channels.status],NOT gsPanning

	cmp	[GUS.cardType], gusIW
	jz	@@iwsmoothpan		; no crappy on/off panning for iw ;)
; regular gus compatible panning
	regsel	12				; Pan Position
	add	_dx,2
	mov	_ax,[_si+channels.panningHW]
	out	dx,al
	jmp	@@stopped
@@iwsmoothpan:
	mov	_bx, [_si+channels.panning]
	add	_bx, _bx
;interwave synth right offset ( bigger blocks sound )
	regsel	0ch
	inc	dl
	mov	ax, [pantablemid+_bx]
	out	dx, ax
	regsel	1bh			; right offset fine
	inc	dl
	mov	ax, [pantablemid+_bx]
	out	dx, ax

	neg	_bx
;interwave synth left offset
	regsel	13h			; left offset
	inc	dl
	mov	ax, [pantablemid+_bx]
	out	dx, ax
	regsel	1ch			; left offset fine
	inc	dl
	mov	ax, [pantablemid+_bx]
	out	dx, ax

@@stopped:
	test	[_si+channels.status],gsSample
	jz	@@retrigged			; No sample changed

	cmp	[_si+channels.loopMode],sdLoopAmigaNone
	je	@@ALE
	cmp	[_si+channels.loopMode],sdLoopAmiga
	jne	@@noALE

@@ALE:	test	[_si+channels.status],gsRetrig
	jnz	@@retrigged			; Already to be retrigged

; GUS-AMIGA-LOOP-EMULATOR (GALE) (TM) V1.14!!!

	regsel	80h				; Voice control
	add	_dx,2
	in	al,dx

	test	al,1
	jz	@@soundon

	cmp	[_si+channels.loopMode],sdLoopAmigaNone ; Next sample looped?
	je	@@stopsound			; No

	mov	_ax,[_si+channels.inst]
	mov	[_si+channels.curinst],_ax

	mov	ebx,[_si+channels.sstart]
	jmp	@@startfromloop 		; Start from loop start

@@soundon:
	mov	eax,[_si+channels.frequency]
	imul	eax,eax,100			; updRate is Hz*100
	xor	edx,edx

IFDEF	__16__
	xor	ebx,ebx
ENDIF
	mov	_bx,[updRate]
	idiv	ebx				; eax = bytes to play until next update
	push	eax

	regsel	84h				; Sample end position high
	inc	_dx
	in	ax,dx
IFDEF	__16__
	xor	ebx,ebx
ENDIF
	mov	_bx,_ax
	and	_bx,01fffh
	shl	ebx,7

	regsel	85h				; Sample end position low
	inc	_dx
	in	ax,dx
	shr	ax,9
	or	_bx,_ax

	regsel	8ah				; Current position high
	inc	_dx
	in	ax,dx
IFDEF	__16__
	xor	ecx,ecx
ENDIF
	mov	_cx,_ax
	and	_cx,01fffh
	shl	ecx,7

	regsel	8bh				; Current position low
	inc	_dx
	in	ax,dx
	shr	ax,9
	or	_cx,_ax

	sub	ebx,ecx 			; Bytes to sample / loop end
	pop	eax

	cmp	ebx,eax
	jg	@@retrigged			; Some sample still to go

	test	[_si+channels.loopMode],sdLoopAmigaNone ; Looped?
	je	@@stopsound

	mov	_ax,[_si+channels.inst]
	mov	[_si+channels.curinst],_ax

	cmp	ebx,0
	jg	@@norm

	mov	ebx,[_si+channels.sstart]
	jmp	@@startfromloop

@@norm: mov	ecx,[_si+channels.send]
	sub	ecx,ebx
	mov	ebx,ecx

@@startfromloop:
; EBX = Starting position

	mov	ecx,[_si+channels.send]        ; Set sample end

	regsel	4				; End position high
	inc	_dx
	mov	eax,ecx
	shr	eax,7
	out	dx,ax
	regsel	5				; End position low
	inc	_dx
	mov	eax,ecx
	shl	_ax,9
	out	dx,ax

	mov	ecx,[_si+channels.sstart]      ; Set loop start

	regsel	2				; Start position high
	inc	_dx
	mov	eax,ecx
	shr	eax,7
	out	dx,ax
	regsel	3				; Start position low
	inc	_dx
	mov	eax,ecx
	shl	_ax,9
	out	dx,ax

	regsel	0				; Voice control
	mov	al,8				; Enable voice and loop
	add	_dx,2
	out	dx,al

	regsel	10				; Current position high
	inc	_dx
	mov	eax,ebx
	shr	eax,7
	out	dx,ax
	regsel	11				; Current position low
	inc	_dx
	mov	eax,ebx
	shl	_ax,9
	out	dx,ax

	call	gusdelay			; Delay

	out	dx,ax

	regsel	10				; Current position high
	inc	_dx
	mov	eax,ebx
	shr	eax,7
	out	dx,ax

	regsel	0				; Voice control
	add	_dx,2
	mov	al,8				; Enable voice and loop
	out	dx,al
	jmp	@@retrigged

@@stopsound:
	regsel	0				; Voice control
	add	_dx,2
	mov	al,3				; Stop voice
	out	dx,al

	regsel	9				; Current volume
	inc	_dx
	mov	_ax,1500h			; To zero
	out	dx,ax

	regsel	0dh				; Ramp control
	add	_dx,2
	mov	al,3				; Stop
	out	dx,al

	call	gusdelay

	out	dx,al

	regsel	0				; Voice control
	add	_dx,2
	mov	al,3				; Stop voice
	out	dx,al

	regsel	9				; Current volume
	inc	_dx
	mov	ax,1500h			; To zero
	out	dx,ax

@@noALE:
@@retrigged:
	add	_si,size gusChannel		; Do all channels in order
	inc	[chanc]
	mov	_ax,[chancount]

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@ij
	add	_ax,_ax 			; Plus Surround channels
@@ij:
ENDIF
	cmp	[chanc],_ax
	jb	@@loop

@@waitloop:
	mov	[chanc],0			; Start from channel 0
	xor	_si,_si 			; Channel data
	mov	[retrigfl],0
@@loop2:
	cmp	[_si+channels.onoff],0
	je	@@skip

	test	[_si+channels.status],gsRetrig	; Retrig?
	jz	@@skip

	mov	_dx,[voicesel]			; Select voice
	mov	_ax,[chanc]
	out	dx,al

IFE FASTGUS
	regsel	8dh				; Ramp finished?
	add	_dx,2
	in	al,dx
	test	al,1
	jnz	@@retrig

	mov	[retrigfl],1			; Still voice(s) to wait...
	jmp	@@skip
ENDIF
@@retrig:
	test	[_si+channels.status],gsSample
	jz	@@not				; No sample changed

	mov	ecx,[_si+channels.send] 	; Set sample end
	cmp	[_si+channels.sampleType],smp16bit
	jne	@@spl
; translate 16 bit sample address...
	mov	edx,ecx
	shr	ecx,1
	and	ecx,01ffffh
	and	edx,0c0000h
	xor	ecx,edx
@@spl:
	regsel	4				; End position high
	inc	_dx
	mov	eax,ecx
	shr	eax,7
	out	dx,ax
	regsel	5				; End position low
	inc	_dx
	mov	eax,ecx
	shl	_ax,9
	out	dx,ax

	mov	ecx,[_si+channels.sstart]	; Set loop start
	cmp	[_si+channels.sampleType],smp16bit
	jne	@@spl2
; translate 16 bit sample address...
	mov	edx,ecx
	shr	ecx,1
	and	ecx,01ffffh
	and	edx,0c0000h
	xor	ecx,edx
@@spl2:
	regsel	2				; Start position high
	inc	_dx
	mov	eax,ecx
	shr	eax,7
	out	dx,ax
	regsel	3				; Start position low
	inc	_dx
	mov	eax,ecx
	shl	_ax,9
	out	dx,ax

	and	[_si+channels.status],NOT gsSample

@@not:	regsel	0				; Voice control
	add	_dx,2
	mov	al,3				; Stop voice
	out	dx,al

	mov	ecx,[_si+channels.scurrent]	; Set starting address
	cmp	[_si+channels.sampleType],smp16bit
	jne	@@spl3
; translate 16 bit sample address...
	mov	edx,ecx
	shr	ecx,1
	and	ecx,01ffffh
	and	edx,0c0000h
	xor	ecx,edx
@@spl3:
	regsel	10				; Current position high
	inc	_dx
	mov	eax,ecx
	shr	eax,7
	out	dx,ax
	regsel	11				; Current position low
	inc	_dx
	mov	eax,ecx
	shl	_ax,9
	out	dx,ax

	call	gusdelay

	out	dx,ax

	regsel	10				; Current position high
	inc	_dx
	mov	eax,ecx
	shr	eax,7
	out	dx,ax

	regsel	0				; Voice control
	add	_dx,2
	mov	al,3				; Stop voice
	out	dx,al

	mov	_ax,[_si+channels.inst]
	mov	[_si+channels.curinst],_ax

	regsel	0				; Voice control
	add	dx,2
	mov	_ax,[_si+channels.loop1Type]	; Enable voice and possible loop
	cmp	_ax,loopNone
	je	@@noloop2
	cmp	_ax,loopUnidir
	je	@@loopuni

@@loopbidi:
	mov	al,24
	jmp	@@loopok2
@@loopuni:
	mov	al,8
	jmp	@@loopok2
@@noloop2:
	xor	al,al
@@loopok2:
	mov	_cx,[_si+channels.sampleType]
	cmp	_cx,smp16bit
	jne	@@lok
	or	al,4
@@lok:	out	dx,al

	regsel	8				; Ramp end
	add	_dx,2
	mov	_ax,[_si+channels.volume]	; To set volume

	test	[_si+channels.status],gsMute
	jz	@@oek
	xor	_ax,_ax
@@oek:	mov	_bx,[mastervol]
	mul	bl
	shr	_ax,6
	mov	_bx,_ax
	add	_bx,_bx
	mov	ax,[voltable+_bx]
	mov	al,ah

	cmp	[_si+channels.surround],0
	je	@@hu
	sub	al,10h				; Halve the volume
@@hu:	out	dx,al

	regsel	0dh
	add	_dx,2
	xor	al,al
	out	dx,al

	call	gusdelay			; Delay

	out	dx,al

	regsel	0				; Voice control
	add	dx,2
	mov	_ax,[_si+channels.loop1Type]	; Enable voice and possible loop
	cmp	_ax,loopNone
	je	@@noloop3
	cmp	_ax,loopUnidir
	je	@@loopuni2
@@loopbidi2:
	mov	al,24
	jmp	@@loopok3
@@loopuni2:
	mov	al,8
	jmp	@@loopok3
@@noloop3:
	xor	al,al
@@loopok3:
	cmp	_cx,smp16bit
	jne	@@lok2
	or	al,4
@@lok2: out	dx,al

	and	[_si+channels.status],NOT (gsRetrig OR gsVolume)

@@skip: add	_si,size gusChannel		; Do all channels in order
	inc	[chanc]
	mov	_ax,[chancount]
IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@ij2
	add	_ax,_ax 			; Plus Surround channels
@@ij2:
ENDIF
	cmp	[chanc],_ax
	jb	@@loop2

IFE FASTGUS
	cmp	[retrigfl],0			; Still voices to wait?
	jne	@@waitloop
ENDIF
	mov	_ax,[voicesave]
	mov	_dx,[voicesel]
	out	dx,al

	mov	_ax,[selsave]
	mov	_dx,[selreg]
	out	dx,al

	mov	[masterchanged],0

	LOADPTR es,_bx,[callMP]
	mov	[_int _esbx],1			; Call mp.Play!
@@done: xor	_ax,_ax
	ret

@@paused:
	LOADPTR es,_bx,[callMP]
	mov	[_int _esbx],0			; Don't call mp.Play!
	jmp	@@done
ENDP




;/***************************************************************************\
;*
;* Function:	int initHeap()
;*
;* Description: Initializes the GUS heap
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/


PROC	initHeap NEAR
USES    _di,_bx

	mov	_ax,MAXSAMPLES * SIZE ghb

IFNDEF NOSTEREO
	cmp	[mEnableSurround],0
	je	@@kool

	add	_ax,_ax 			; Room for surround
						; blocks, too
@@kool:
ENDIF
	push	_ax
	call	memAlloc LANG, _ax, ptr_to temp
						; Alloc room for heap blocks
	pop	_cx				; Size to _cx
	test	_ax,_ax
	jne	@@err

	mov	ebx,[temp]
	mov	[gusHeapStart],ebx
	mov	[gusHeap],ebx

	LOADPTR es,_di,[temp]
	xor	al,al
						; Size already in _cx
	cld
	rep	stosb				; Clear instrument datas

	LOADPTR es,_bx,[temp]
	mov	eax,[memamount]
	mov	[_esbx+ghb.next],0		; first and last block
	mov	[_esbx+ghb.gusmem],0		; from the start of mem
	mov	[_esbx+ghb.length],eax		; whole memory
	xor	_ax,_ax
	ret

@@err:	ERROR	ID_gusInitHeap
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int freeHeap()
;*
;* Description: Uninitializes the GUS heap
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/


PROC	freeHeap NEAR
USES    _bx

	call	memFree LANG, [gusHeap]
	test	_ax,_ax
	jnz	@@err
	ret

@@err:	ERROR	ID_gusFreeHeap
	ret
ENDP


;/***************************************************************************\
;*
;* Function:	int gusMalloc(ushort length, ulong *mem)
;*
;* Description: Allocates GUS memory (with best fit alcorithm)
;*
;* Input:	ushort length		Length of the block to be allocated
;*					(Rounded up to next 64 bytes with
;*					at least 32 bytes for loop copy, etc.)
;*
;* Returns:	MIDAS error code.
;*
;\***************************************************************************/
PROC	gusMalloc _funct   glength : _int, gtype : _int, mem : _ptr
USES    _si,_di,_bx
LOCAL	bestfitoff : _int, bestfitseg : _int, leastslack : dword

@@again:
IFDEF	__16__
	xor	eax,eax
ENDIF
	mov	_ax,[glength]
	test	_ax,_ax
	jz	@@done

	mov	ebx,eax 		; Round up to next 64 byte border
	and	ebx,1fh 		; with at least 32 bytes buffer
	mov	ecx,64
	sub	ecx,ebx
	add	eax,ecx

	cmp	eax,256*1024
	jb	@@mok

	cmp	[gtype],smp16bit
	je	@@notenoughmem			; can't play over 256kb
						; 16-; bit samples...
@@mok:	mov	[bestfitseg],0
	mov	[leastslack],7ffffffh

	cmp	[memavail],eax			; Is there that much memory left
	jl	@@notenoughmem

	cmp	[largestblock],eax		; Do we have to defragment?
	jg	@@noneedtodefragment

	push	eax
	call	gusDefragment
	pop	eax

	cmp	[largestblock],eax
	jl	@@notenoughmem

@@noneedtodefragment:
	LOADPTR es,_si,[gusHeapStart]

@@findbest:
	push	eax
	call	findFreeBlock
	pop	eax
	jc	@@notanymore

	mov	ebx,[_essi+ghb.length]
	and	ebx, NOT 1fh			; And flags off
	sub	ebx,eax
	js	@@nxt				; Too small

	cmp	[leastslack],ebx
	jl	@@nxt				; Not the best

	mov	[leastslack],ebx		; Set to be the best
IFDEF	__16__
	mov	_bx,es
	mov	[bestfitseg],_bx
ENDIF
	mov	[bestfitoff],_si

@@nxt:
	mov	ecx,[_essi+ghb.next]		; Advance to next block
	test	ecx,ecx
	jz	@@notanymore
	mov	_si,_cx
IFDEF	__16__
	shr	ecx,16
	mov	es,cx
ENDIF
	jmp	@@findbest

@@notanymore:
IFDEF	__16__
	cmp	[bestfitseg],0	; Was there any free blocks large enough?
	je	@@notenoughmem
ELSE
	cmp	[bestfitoff],0	; Was there any free blocks large enough?
	je	@@notenoughmem
ENDIF
	cmp	[leastslack],0
	je	@@justalloc

@@notfit:
	push	eax
	call	allocBlock LANG, ptr_to temp ; Allocate new block
	test	_ax,_ax
	jnz	@@memerr

	pop	eax
	LOADPTR gs,_di,[temp]

	mov	_si,[bestfitoff]
IFDEF	__16__
	mov	bx,[bestfitseg]
	mov	es,bx
ENDIF
	mov	ebx,[_essi+ghb.gusmem]		; Copy pointer

	cmp	[gtype],smp16bit
	jne	@@kool

	mov	ecx,ebx
	mov	edx,ecx
	add	ecx,eax
	and	ecx,NOT(256*1024-1)
	and	edx,NOT(256*1024-1)
	cmp	ecx,edx
	je	@@kool				; Wholly inside one
						; 256k bank

; We'll have to split this block to two, one for each bank.
@@split:
	mov	ecx,ebx
	add	ecx,256*1024-1
	and	ecx,NOT (256*1024-1)
	mov	[_gsdi+ghb.gusmem],ecx
	sub	ecx,ebx
	mov	ebx,[_essi+ghb.length]
	sub	ebx,ecx
	mov	[_gsdi+ghb.length],ebx		; second block length
	mov	[_essi+ghb.length],ecx		; first block length
	mov	ecx,[_essi+ghb.next]
	mov	ebx,[temp]
	mov	[_gsdi+ghb.next],ecx
	mov	[_essi+ghb.next],ebx

	PUSHSEGREG gs
	call	checkCoreFree			; Update biggest block
	POPSEGREG gs
	test	_ax,_ax
	jnz	@@err
	jmp	@@again

@@kool:
	mov	[_gsdi+ghb.gusmem],ebx
	mov	[_gsdi+ghb.length],eax		; Set block length
	or	[_gsdi+ghb.length],1		; Mark as allocated

	add	[_essi+ghb.gusmem],eax		; Move free block "upwards"
	sub	[_essi+ghb.length],eax		; Sub free block length

IFDEF	__16__
	mov	bx,es
	shl	ebx,16
ENDIF
	mov	_bx,_si

	mov	[_gsdi+ghb.next],ebx		; Link blocks
	cmp	[gusHeapStart],ebx
	jne	@@notfirst			; The first block?

IFDEF	__16__
	mov	bx,gs				; Set this block to HeapStart
	shl	ebx,16
ENDIF
	mov	_bx,_di
	mov	[gusHeapStart],ebx
	jmp	@@donee

@@notfirst:
	push	eax
	mov	eax,ebx
	call	findPrevBlock			; Find block linked to the free block
	pop	eax
	jc	@@heapcorr			; No such block!

IFDEF	__16__
	mov	bx,gs
	shl	ebx,16
ENDIF
	mov	_bx,_di
	mov	[_essi+ghb.next],ebx		; Link to previous block


@@donee:
	sub	[memavail],eax
	PUSHSEGREG gs
	call	checkCoreFree			; Update biggest block
	POPSEGREG gs
	test	_ax,_ax
	jnz	@@err
	mov	eax,[_gsdi+ghb.gusmem]		; Return pointer
	LOADPTR es,_bx,[mem]
	mov	[_esbx],eax
	xor	_ax,_ax
	ret

@@justalloc:					; Realloc?
	mov	ebx,[_essi+ghb.gusmem]		; Copy pointer

	cmp	[gtype],smp16bit
	jne	@@kool2

	mov	ecx,ebx
	mov	edx,ecx
	add	ecx,eax
	and	ecx,NOT(256*1024-1)
	and	edx,NOT(256*1024-1)
	cmp	ecx,edx
	jne	@@notfit			; we'll have to split...
@@kool2:
	or	[_essi+ghb.length],1
	sub	[memavail],eax
	PUSHSEGREG es
	call	checkCoreFree
	POPSEGREG es
	test	_ax,_ax
	jnz	@@err
	mov	eax,[_essi+ghb.gusmem]
@@done: LOADPTR es,_bx,[mem]
	mov	[_esbx],eax
	xor	_ax,_ax
	ret

@@memerr:
	pop	ebx				; pop saved pointer
	jmp	@@err

@@heapcorr:
	mov	_ax,errCardHeapCorrupted
	jmp	@@err

@@notenoughmem:
	mov	_ax,errOutOfCardMemory
@@err:	ERROR	ID_gusMalloc
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int gusFree(ulong mem)
;*
;* Description: Deallocates GUS memory
;*
;* Input:	ulong block		Pointer to allocated GUS mem
;*
;* Returns:	1 if success, 0 if not
;*
;* Destroys:	ax, bx, cx, dx
;*
;\***************************************************************************/
PROC	gusFree _funct	 block : dword
USES    _si,_di,_bx
LOCAL	freed : dword

	mov	eax,[block]

	LOADPTR gs,_di,[gusHeapStart]
@@sloop:
	cmp	[_gsdi+ghb.gusmem],eax
	je	@@found

	mov	ebx,[_gsdi+ghb.next]
	test	ebx,ebx
	jz	@@invalid
	mov	_di,_bx
IFDEF	__16__
	shr	ebx,16
	mov	gs,bx
ENDIF
	jmp	@@sloop

@@found:
	test	[_gsdi+ghb.length],1
	jz	@@heapcorr			; Not even allocated

	and	[_gsdi+ghb.length],NOT 1	; Free this block

	mov	ebx,[_gsdi+ghb.length]
	mov	[freed],ebx

	mov	ebx,[_gsdi+ghb.next]
	test	ebx,ebx
	jz	@@nonextblock			; Last block

	mov	_si,_bx
IFDEF	__16__
	shr	ebx,16
	mov	es,bx
ENDIF
	test	[_essi+ghb.length],1
	jnz	@@nonextblock			; Next allocated -> Can't merge blocks

	mov	edx,[_essi+ghb.next]
	mov	[_gsdi+ghb.next],edx
	mov	edx,[_essi+ghb.length]		; Merge blocks
	add	[_gsdi+ghb.length],edx

	PUSHSEGREG gs
IFDEF	__16__
	call	freeBlock LANG, es si		; Free block
ELSE
	call	freeBlock LANG, esi		; Free block
ENDIF
	POPSEGREG gs
	test	_ax,_ax
	jnz	@@err

@@nonextblock:
IFDEF	__16__
	mov	bx,gs
	shl	ebx,16
ENDIF
	mov	_bx,_di
	cmp	[gusHeapStart],ebx
	je	@@firstblock			; First block

	mov	eax,ebx
	call	findPrevBlock
	jc	@@heapcorr			; No such block! (Heap corrupt?)

	test	[_essi+ghb.length],1
	jnz	@@firstblock			; previous allocated -> can't merge blocks

	mov	edx,[_gsdi+ghb.next]
	mov	[_essi+ghb.next],edx
	mov	edx,[_gsdi+ghb.length]		; Merge blocks
	add	[_essi+ghb.length],edx

IFDEF	__16__
	call	freeBlock LANG, gs di		; Free block
ELSE
	call	freeBlock LANG, edi		; Free block
ENDIF
	test	_ax,_ax
	jnz	@@err

@@firstblock:
	mov	eax,[freed]
	add	[memavail],eax
	call	checkCoreFree
	test	_ax,_ax
	jnz	@@err
	xor	_ax,_ax
	ret

@@heapcorr:
	mov	_ax,errCardHeapCorrupted
	jmp	@@err

@@invalid:
	mov	_ax,errInvalidBlock
@@err:	ERROR	ID_gusFree
	ret
ENDP


PROC    allocBlock NEAR block : _ptr
uses    _bx

	LOADPTR es,_bx,[gusHeapStart]
	mov	_cx,MAXSAMPLES
	cmp	[mEnableSurround],0
	je	@@findloop
	add	_cx,_cx 			; Include surround blocks
@@findloop:
	cmp	[_esbx+ghb.length],0
	je	@@found
	add	_bx,size ghb
	dec	_cx
	jnz	@@findloop
	jmp	@@err
@@found:
IFDEF	__16__
	mov	ax,es
	shl	eax,16
ENDIF
	mov	_ax,_bx
	LOADPTR es,_bx,[block]
	mov	[_esbx],eax
	xor	_ax,_ax
	ret

@@err:	mov	_ax,errInvalidBlock
	ERROR	ID_gusAllocBlock
	ret
ENDP

PROC	freeBlock NEAR block : _ptr
USES    _bx

	LOADPTR es,_bx,[block]
	mov	[_esbx+ghb.next],0
	mov	[_esbx+ghb.gusmem],0
	mov	[_esbx+ghb.length],0
	xor	_ax,_ax
	ret
ENDP

; _essi = pointer to current block
; Returns: _essi = next free block
; Carry set if not found

PROC	findFreeBlock NEAR

@@sloop:
	test	[_essi+ghb.length],1
	jz	@@found

	mov	eax,[_essi+ghb.next]   ; Advance to next block
	test	eax,eax
	jz	@@nofree
	mov	_si,_ax
IFDEF	__16__
	shr	eax,16
	mov	es,ax
ENDIF
	jmp	@@sloop

@@found:
	clc
	ret
@@nofree:
	stc
	ret
ENDP


; eax = pointer to current block
; Returns: _essi = prev block
; Carry set if not found

PROC	findPrevBlock NEAR

	LOADPTR es,_si,[gusHeapStart]
@@sloop:
	cmp	[_essi+ghb.next],eax
	je	@@found

	mov	ebx,[_essi+ghb.next]
	test	ebx,ebx
	jz	@@done
	mov	_si,_bx
IFDEF	__16__
	shr	ebx,16
	mov	es,bx
ENDIF
	jmp	@@sloop

@@found:
	clc
	ret
@@done:
	stc
	ret
ENDP



; No parameters, also checks heap integrity
; Returns MIDAS error code

PROC	checkCoreFree	NEAR
USES    _si,_bx

	LOADPTR es,_si,[gusHeapStart]
	xor	edx,edx 			; Start from size 0
	xor	ecx,ecx 			; Total mem size
@@findloop:
	mov	eax,[_essi+ghb.length]
	mov	ebx,eax
	and	ebx,NOT 31			; ebx = size
	add	ecx,ebx 			; Add to total
	test	eax,1				; Allocated flag
	jnz	@@findnext			; Allocated
	cmp	ebx,edx 			; Largest?
	jle	@@findnext
	mov	edx,ebx
@@findnext:
	mov	eax,[_essi+ghb.next]   ; Advance to next block
	test	eax,eax
	jz	@@done
	mov	_si,_ax
IFDEF	__16__
	shr	eax,16
	mov	es,ax
ENDIF
	jmp	@@findloop

@@done: mov	[largestblock],edx
	cmp	[memamount],ecx 		; All memory in heap?
	jne	@@heapcorr			; heap corrupt!
	xor	_ax,_ax
	ret

@@heapcorr:
	mov	_ax,errCardHeapCorrupted
	ERROR	ID_gusCoreFree
	ret
ENDP

;/***************************************************************************\
;*
;* Function:	gusDefragment
;*
;* Description: Defragments the GUS memory
;*
;\***************************************************************************/
PROC	gusDefragment _funct
	ret
ENDP


;* $Log: gus.asm,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/08/04 11:27:42  pekangas
;* All functions now preserve _bx
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*


END