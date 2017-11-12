;*	WSS.ASM
;*
;* Windows Sound System Sound Device
;*
;* $Id: wss.asm,v 1.3 1997/01/16 18:41:59 pekangas Exp $
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


;/***************************************************************************\
;*       enum wssFunctIDs
;*       ----------------
;* Description:  ID numbers for WSS Sound Device functions
;\***************************************************************************/

enum    wssFunctIDs \
        ID_wssDetect = ID_wss, \
        ID_wssInit, \
        ID_wssClose



DATASEG

D_int   wssRate                         ; WSS actual output rate

wssSpd		DB	?		; WSS speed value
wssOLMute	DB	?		; WSS old left channel mute value
wssORMute	DB	?		; WSS old right channel mute value


IFDEF __PASCAL__
EXTRN   WSS : SoundDevice
ENDIF




IDATASEG


WSSCONFIGBITS = sdUsePort or sdUseIRQ or sdUseDMA or sdUseMixRate or \
                sdUseOutputMode or sdUseDSM
WSSMODEBITS = sdMono or sdStereo or sd8bit or sd16bit

; If compiling for Pascal, Sound Device name is wssSD, from which the data
; will be copied to Sound Device WSS, defined in Pascal.

IFDEF   __PASCAL__
SDNAM           equ     wssSD
ELSE
SDNAM           equ     WSS
ENDIF

GLOBAL  SDNAM : SoundDevice

SDNAM   SoundDevice     < \
 0,\
 WSSCONFIGBITS,\
 530h, 9, 3,\
 1, 1,\
 WSSMODEBITS,\
 ptr_to wssSDName,\
 ptr_to wssCardNames,\
 4, ptr_to wssPortAddresses,\
 ptr_to wssDetect,\
 ptr_to wssInit,\
 ptr_to wssClose,\
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
 ptr_to mixsdStartPlay,\
 ptr_to mixsdPlay >


LABEL	wssRates	WORD		; sampling rates for WSS
	DW	 8000, 00h
	DW	 5513, 01h
	DW	16000, 02h
	DW	11025, 03h
	DW	27429, 04h
	DW	18900, 05h
	DW	32000, 06h
	DW	22050, 07h
	DW	    0, 08h		; not supported
	DW	37800, 09h
	DW	    0, 0Ah
	DW	44100, 0Bh
	DW	48000, 0Ch
	DW	33075, 0Dh
	DW	 9600, 0Eh
	DW	 6615, 0Fh


wssSDName       DB      "Windows Sound System Sound Device v1.30", 0

wssCardNames    DD      ptr_to wssName

wssName         DB      "Windows Sound System (Crystal/Analog CODEC)", 0

IFDEF __16__
wssPortAddresses  DW    530h, 604h, 0E80h, 0F40h
ELSE
wssPortAddresses  DD    530h, 604h, 0E80h, 0F40h
ENDIF



CODESEG



;/***************************************************************************\
;*
;* Function:    WaitCODEC
;*
;* Description: Waits until the WSS CODEC finishes initializing
;*
;* Returns:	carry set if error, otherwise carry clear
;*
;* Destroys:	ax, cx, dx
;*
;\***************************************************************************/

PROC NOLANGUAGE WaitCODEC	NEAR	; waits until CODEC finishes
					;  initializing. Carry set if error
	clc

        mov     _dx,[WSS.port]          ; dx = CODEC Index Address Register
        add     _dx,4

        mov     _cx,8000h

@@wait: in	al,dx
	or	al,al			; wait until bit 7 is zero or 2000h
	jns	@@ok			; reads
	loop	@@wait

	stc				; if read 2000h times, there is a
					; problem with the CODEC
@@ok:	ret

ENDP




;/***************************************************************************\
;*
;* Function:    int wssDetect(int *result);
;*
;* Description: Detects Windows Sound System soundcard
;*
;* Returns:     MIDAS error code.
;*              1 stored to *result if WSS was detected, 0 if not.
;*
;\***************************************************************************/

PROC    wssDetect       _funct  result : _ptr
USES    _bx

        LOADPTR es,_bx,[result]         ; store 0 in *result - no detection
        mov     [_int _esbx],0

;FIXME!!!

        xor     _ax,_ax
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    int wssInit(unsigned mixRate, unsigned mode);
;*
;* Description: Initializes Windows Sound System
;*
;* Input:       unsigned mixRate        mixing rate
;*              unsigned mode           output mode (see enum sdMode)
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    wssInit         _funct  mixRate : _int, mode : _int
USES    _si,_di,_bx
LOCAL   wssMode : _int

	mov	[wssMode],0

	test	[mode],sd8bit		; force 8-bit?
	jnz	@@8b
	or	[wssMode],sd16bit	; if not, use 16 bits
	jmp	@@bit
@@8b:	or	[wssMode],sd8bit

@@bit:	test	[mode],sdMono		; force mono?
	jnz	@@mono
	or	[wssMode],sdStereo	; if not, use stereo
	jmp	@@mst
@@mono: or	[wssMode],sdMono

@@mst:
        mov     _dx,[WSS.port]
        add     _dx,4                   ; dx = CODEC Index Address Register
	in	al,dx			; is the CODEC busy?
	or	al,al
        jns     @@notbusy

        mov     _ax,errSDFailure        ; CODEC busy - failure
        jmp     @@err

@@notbusy:
IF 0
	mov	al,0Ch			; select misc. register
	out	dx,al
        inc     _dx
	in	al,dx			; AL = CODEC version

	mov	bl,al

	xor	al,al
	out	dx,al			; write 0 to misc. register
	in	al,dx			; and read it back
	cmp	al,bl			; if value changed this is not a
        je      @@codecok               ; CODEC

        mov     _ax,errSDFailure        ; value changed - not a CODEC
        jmp     @@err
ENDIF

@@codecok:
        mov     _bx,[WSS.IRQ]
	cmp	bl,7
	je	@@IRQ7
	cmp	bl,9
	je	@@IRQ9
	cmp	bl,10
	je	@@IRQ10
	cmp	bl,11
	je	@@IRQ11

        mov     _ax,errSDFailure        ; invalid IRQ number
        jmp     @@err

@@IRQ7: mov	al,08h			; IRQ value for CODEC configuration
	jmp	@@IRQd

@@IRQ9: mov	al,10h			; IRQ value for CODEC configuration
	jmp	@@IRQd

@@IRQ10:
	mov	al,18h			; IRQ value for CODEC configuration
	jmp	@@IRQd

@@IRQ11:
	mov	al,20h			; IRQ value for CODEC configuration


@@IRQd:
        mov     _bx,[WSS.DMA]
	cmp	bl,0
	je	@@DMA0
	cmp	bl,1
	je	@@DMA1
	cmp	bl,3
	je	@@DMA3

        mov     _ax,errSDFailure        ; invalid DMA number
        jmp     @@err

@@DMA0: or	al,01h			; DMA value for CODEC configuration
	jmp	@@DMAd

@@DMA1: or	al,02h			; DMA value for CODEC configuration
	jmp	@@DMAd

@@DMA3: or	al,03h			; DMA value for CODEC configuration

@@DMAd: mov     _dx,[WSS.port]
	out	dx,al			; set IRQ and DMA numbers

	; WSS does _NOT_ seem to use any interrupts if using autoinit
	; DMA, so setting a IRQ-handler is unnecessary.

	; now search for closest match of the mixing rate from the wssRates
	; table

        mov     _cx,16                  ; 16 possible values
        xor     _si,_si                 ; pointer to rate table
        mov     _dx,32767               ; distance from best match
        xor     _bx,_bx                 ; rate number for best match

@@rl:
IFDEF __32__
        xor     eax,eax
ENDIF
        mov     ax,[wssRates+_si]       ; get a rate from table
        add     _si,2
        sub     _ax,[mixRate]           ; distance from wanted mixing rate
	js	@@1			; if this rate is smaller, ignore
        cmp     _ax,_dx                 ; is distance greater than best match?
	jae	@@1			; if is, ignore

        mov     bx,[wssRates+_si]       ; rate number for this match
        mov     _dx,_ax                 ; distance

@@1:    add     _si,2                   ; next rate
	loop	@@rl

	mov	[wssSpd],bl		; store rate number
        shl     _bx,2
IFDEF __32__
        xor     eax,eax
ENDIF
        mov     ax,[wssRates+_bx]       ; get actual mixing rate from table
        mov     [wssRate],_ax           ; store actual mixing rate


        ; Take care of common initialization for all mixing Sound Devices:
        push    es
        call    mixsdInit LANG, [wssRate], [wssMode], [WSS.DMA]
        pop     es
        test    _ax,_ax
        jnz     @@err


        mov     _dx,[WSS.port]
        add     _dx,4
	mov	al,0Ah
	out	dx,al
        inc     _dx
	in	al,dx			; external mute on
	or	al,40h
	out	dx,al

        mov     _cx,1200h               ; delay to prevent clicks (value from
					;  CODEC.ASM, ExtMute, WSS SDK 1.0)
@@w1:	in	al,84h			; a "safe" I/O port
	loop	@@w1


        ; Write zero to Pin Control (why?)
        mov     _dx,[WSS.port]
        add     _dx,4
        mov     al,0Ah
        out     dx,al
        inc     _dx
        xor     al,al
        out     dx,al


        ; Set single DMA mode and start autocalibration:

        mov     _dx,[WSS.port]
        add     _dx,4
        mov     al,49h                  ; enable MCE
	out	dx,al
        inc     _dx
	mov	al,04h or 08h		; single DMA channel, enable
	out	dx,al			; autocalibration

        ; Maybe we should do the port reading again? Shouldn't hurt anyone
        ; anyhow:

        in      al,dx
        in      al,dx


        ; Now set playing rate and output format:

        mov     _dx,[WSS.port]
        add     _dx,4                   ; enable MCE and select Clock and
	mov	al,48h			; Data Format Register (08h)
	out	dx,al

        inc     _dx
	mov	al,[wssSpd]		; Clock Frequency Source & Divide
	test	[wssMode],sd16bit
	jz	@@no16
	or	al,40h			; 16-bit signed linear (0 - 8-bit
					; unsigned linear)
@@no16:
	test	[wssMode],sdStereo	; stereo?
	jz	@@nostereo
	or	al,10h			; if yes, set stereo bit 1

@@nostereo:
	out	dx,al

        ; Now according to GUS MAX SDK source we need to read from the CODEC
        ; data port twice. Don't ask me why, but I really hope this solves
        ; the problem in setting the sample rate...

        in      al,dx
        in      al,dx

        ; Wait for CODEC initialization to complete:
        call    WaitCODEC
        jnc     @@initok
        mov     _ax,errSDFailure
        jmp     @@err

@@initok:
        ; Now disable MCE:

        mov     _dx,[WSS.port]
        add     _dx,4

@@disablemce:
	mov	al,08h			; disable MCE
	out	dx,al
        jmp short $+2
        in      al,dx                   ; according to the GUS MAX SDK we need
        cmp     al,08h                  ; to check the out got through - maybe
        jne     @@disablemce            ; a bug in the CODEC?


        ; Delay to ensure autocalibration has started:
        mov     _cx,10000
@@delay:
        in      al,84h
        loop    @@delay


        ; Now we need to wait until autocalibration is finished. First check
        ; that we actually do get the Test and Initialization register
        ; number written to the index: (Again from GUS MAX SDK)

@@testinit:
        mov     al,0Bh
        out     dx,al
        jmp short $+2
        in      al,dx
        cmp     al,0Bh
        jne     @@testinit

        ; Now wait until bit 5 becomes zero in the register:
@@wacal:
        mov     al,0Bh
        out     dx,al
        inc     _dx                     ; wait until autocalibration is
        in      al,dx                   ; finished
        dec     _dx
        test    al,32
        jnz     @@wacal


        ; Set Single DMA channel mode, disable autocalibration:
        mov     _dx,[WSS.port]
        add     _dx,4
        mov     al,49h
        out     dx,al
        inc     _dx
        mov     al,04h
        out     dx,al

        ; Disable MCE:
        dec     _dx
        xor     al,al
        out     dx,al


        mov     _cx,1200h               ; delay to prevent clicks (value from
					;  CODEC.ASM, ExtMute, WSS SDK 1.0)
@@w2:	in	al,84h			; a "safe" I/O port
	loop	@@w2

        mov     _dx,[WSS.port]
        add     _dx,4
	mov	al,0Ah
	out	dx,al
        inc     _dx                     ; external mute off
	in	al,dx
	and	al,NOT 40h
	out	dx,al


        mov     _dx,[WSS.port]
        add     _dx,6                   ; acknowledge CODEC interrupt (just
	xor	al,al			;  for safety...)
	out	dx,al


        mov     _dx,[WSS.port]
        add     _dx,4                   ; select the lower base count
	mov	al,0Fh
	out	dx,al
        inc     _dx
	mov	al,255			; set the low byte of count (DMAC
	out	dx,al			; takes care of wrapping)

        dec     _dx
	mov	al,0Eh			; select the upper base count
	out	dx,al
        inc     _dx
	mov	al,255			; set the high byte of count
	out	dx,al

        ; Write 0 to Pin Control register: (?)
        dec     _dx
        mov     al,0Ah
        out     dx,al
        inc     _dx
        xor     al,al
        out     dx,al

        mov     _dx,[WSS.port]
        add     _dx,4                   ; write to the Interface Configuration
	mov	al,09h
	out	dx,al

        inc     _dx
	mov	al,05h			; use DMA playback
	out	dx,al

        dec     _dx
	mov	al,06h
	out	dx,al			; mute off from left channel
        inc     _dx
	in	al,dx
	mov	[wssOLMute],al
	and	al,NOT 128
	out	dx,al

        dec     _dx
	mov	al,07h
	out	dx,al			; mute off from right channel
        inc     _dx
	in	al,dx
	mov	[wssORMute],al
	and	al,NOT 128
	out	dx,al

@@ok:
        xor     _ax,_ax                 ; WSS succesfully initialized
        jmp     @@done


@@err:  ERROR   ID_wssInit

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    int wssClose(void)
;*
;* Description: Uninitializes Windows Sound System
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    wssClose        _funct
USES    _bx

        mov     _dx,[WSS.port]
        add     _dx,4

	mov	al,06h
	out	dx,al			; old mute setting to left channel
        inc     _dx
	mov	al,[wssOLMute]
	out	dx,al

        dec     _dx
	mov	al,07h
	out	dx,al			; old mute setting to right channel
        inc     _dx
	mov	al,[wssORMute]
	out	dx,al

        dec     _dx                     ; Pin Control Register
	mov	al,0Ah
	out	dx,al
        inc     _dx
	xor	al,al			; turn off interrupts
	out	dx,al

        inc     _dx
	out	dx,al			; acnowledge outstanding interrupts

        sub     _dx,2
	mov	al,09h			; Interface Configuration Register
	out	dx,al
        inc     _dx
	xor	al,al			; turn off CODEC's DMA
	out	dx,al

        ; Take care of common uninitialization for all mixing Sound Devices:
        push    es
        call    mixsdClose
        pop     es
        test    _ax,_ax
        jnz     @@err

        xor     _ax,_ax
        jmp     @@done


@@err:  ERROR   ID_wssClose

@@done:
	ret
ENDP


;* $Log: wss.asm,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/08/04 11:35:36  pekangas
;* All functions now preserve _bx
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*

END