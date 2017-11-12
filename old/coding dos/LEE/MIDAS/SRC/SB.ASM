;*	SB.ASM
;*
;* Sound Blaster series Sound Device
;*
;* $Id: sb.asm,v 1.5 1997/01/16 18:41:59 pekangas Exp $
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
INCLUDE "dsm.inc"
INCLUDE "dma.inc"
INCLUDE "mixsd.inc"
INCLUDE "mutils.inc"


SB_RESETDELAY = 64      ; Delay for SB reset. According to SDK 8 should be
                        ; enough but doesn't seem so on my P90 (PK)



;/***************************************************************************\
;*	 enum sbFunctIDs
;*	 ----------------
;* Description:  ID numbers for SB Sound Device functions
;\***************************************************************************/

enum	sbFunctIDs \
	ID_sbDetect = ID_sb, \
	ID_sbInit, \
        ID_sbClose



;/***************************************************************************\
;*	ENUM sbCardTypes
;*	----------------
;* Description: Sound Card type number for SB Sound Device
;\***************************************************************************/

ENUM	sbCardTypes \
	sbAutoType = 0, \		; autodetect card type
	sb10, \ 			; Sound Blaster 1.0 (DSP v1.xx)
	sb15, \ 			; Sound Blaster 1.5 (DSP v2.00)
	sb20, \ 			; Sound Blaster 2.0 (DSP v2.01)
	sbPro, \			; Sound Blaster Pro (DSP v3.xx)
	sb16				; Sound Blaster 16 (DSP v4.00+)



DATASEG

D_farptr oldIRQ                         ; old IRQ vector
D_int   sb22C                           ; SB DSP data port (2xCh)
D_int   sbTimeConstant                  ; SB Transfer Time Constant
D_int   sbRate                          ; SB actual playing rate
D_int   sbVersion                       ; DSP version number
D_int   sbMode                          ; actual output mode
D_int   sbInterrupt                     ; IRQ interrupt number
D_int   sbBlockLength                   ; DSP playing block length
D_int   sbStereoOK                      ; flag used by sbSetStereo()

sbStereoDMABuffer  dmaBuffer ?          ; dummy DMA buffer used to play one
                                        ; byte with DMA before starting with
                                        ; SB Pro cards to get left and right
                                        ; channel the right way

convBuffer      DB      4 DUP (?)       ; string to number conversion buffer
oldIRQMask      DB      ?               ; old IRQ mask
sbOutputFilter  DB      ?               ; initial output filter status



IFDEF __PASCAL__
EXTRN   SB : SoundDevice                ; Sound Device for Pascal version
ENDIF




IDATASEG


SBCONFIGBITS = sdUsePort or sdUseIRQ or sdUseDMA or sdUseMixRate or \
               sdUseOutputMode or sdUseDSM
SBMODEBITS = sdMono or sdStereo or sd8bit or sd16bit

; If compiling for Pascal, Sound Device name is sbSD, from which the data
; will be copied to Sound Device SB, defined in Pascal.

IFDEF   __PASCAL__
SDNAM           equ     sbSD
ELSE
SDNAM           equ     SB
ENDIF

GLOBAL  SDNAM : SoundDevice

SDNAM   SoundDevice     < \
 0,\
 SBCONFIGBITS,\
 220h, 7, 1,\
 sbAutoType, 5,\
 SBMODEBITS,\
 ptr_to sbSDName,\
 ptr_to sbCardNames,\
 4, ptr_to sbPortAddresses,\
 ptr_to sbDetect,\
 ptr_to sbInit,\
 ptr_to sbClose,\
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

sbSDName        DB      "Sound Blaster series Sound Device v2.21",0

                ; *!!*
sbCardNames     DD      ptr_to sb10Name
                DD      ptr_to sb15Name
                DD      ptr_to sb20Name
                DD      ptr_to sbProName
                DD      ptr_to sb16Name

sb10Name	DB	"Sound Blaster 1.0 or clone (DSP v1.xx)", 0
sb15Name	DB	"Sound Blaster 1.5 (DSP v2.00)", 0
sb20Name	DB	"Sound Blaster 2.0 (DSP v2.01)", 0
sbProName	DB	"Sound Blaster Pro (DSP v3.xx)", 0
sb16Name	DB	"Sound Blaster 16 (DSP v4.00+)", 0

IFDEF __16__
sbPortAddresses DW	210h, 220h, 230h, 240h, 250h, 260h
ELSE
sbPortAddresses DD      210h, 220h, 230h, 240h, 250h, 260h
ENDIF

blasterStr	DB	"BLASTER", 0



CODESEG



PUBLIC	sbDetect
PUBLIC	sbInit
PUBLIC	sbClose




;/***************************************************************************\
;*
;* Function:	sbWait
;*
;* Description: Waits until data can be written to the DSP command/data port
;*		2xCh
;*
;* Returns:     MIDAS error code
;*
;* Destroys:    _ax, _cx, _dx. _dx now contains the DSP command/data port
;*              value, 2xCh.
;*
;\***************************************************************************/

PROC NOLANGUAGE sbWait	NEAR

        mov     _dx,[sb22C]
        mov     _cx,0FFFFh

@@wait:
	in	al,dx			; read port 22Ch
	test	al,al			; is bit 7 set?
	jns	@@ok			; if not, DSP is ready
	loop	@@wait			; read maximum of 0FFFFh times


	; The bit is still set after 0FFFFh reads, so apparently the DSP
	; is for some reason locked up. Return error.

        mov     _ax,errSDFailure        ; Sound Device hardware failure
	jmp	@@done

@@ok:
        xor     _ax,_ax

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Macro:	SBCMD
;*
;* Description: Writes a command to SB's DSP. Jumps to label @@err if an
;*		error occurs, with the error code in ax
;*
;* Input:	command 	command
;*
;* Destroys:	see function sbCommand
;*
;\***************************************************************************/

MACRO	SBCMD	command
	mov	bl,command
	call	sbCommand
        test    _ax,_ax
	jnz	@@err
ENDM




;/***************************************************************************\
;*
;* Function:	sbCommand
;*
;* Description: Writes a command to SB's DSP
;*
;* Input:	bl	command
;*
;* Returns:     MIDAS error code in _ax
;*
;* Destroys:    _ax, _dx, _cx
;*
;\***************************************************************************/

PROC NOLANGUAGE sbCommand	NEAR

	call	sbWait			; wait until data or command can be
        test    _ax,_ax                 ; written to the DSP
	jnz	@@done

	mov	al,bl			; write the command
	out	dx,al

        xor     _ax,_ax

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	sbRead
;*
;* Description: Reads a byte from the DSP data port
;*
;* Returns:	bl		byte read
;*              _ax             MIDAS error copde
;*
;* Destroys:    _ax, _cx, _dx
;*
;\***************************************************************************/

PROC NOLANGUAGE sbRead		NEAR

        mov     _dx,[SB.port]
        add     _dx,0Eh                 ; dx = 2xEh = SB DSP Data Available
        mov     _cx,0FFFFh              ; port
@@wait:
	in	al,dx
	test	al,al			; wait until bit 7 is set
	js	@@dok
	loop	@@wait

	; Read port 2xEh 65535 time and bit 7 is still zero - failure
        mov     _ax,errSDFailure
	jmp	@@done

@@dok:  add     _dx,0Ah-0Eh             ; dx = 2xAh = SB DSP Data port
	in	al,dx			; read data from port
	mov	bl,al			; and store it in bl

        xor     _ax,_ax                 ; success

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    sbReset
;*
;* Description: Resets the Sound Blaster DSP
;*
;\***************************************************************************/

PROC    sbReset         NEAR

        mov     _dx,[SB.port]
        add     _dx,6
	mov	al,1			; reset SB DSP by first writing 1 to
	out	dx,al			; port 2x6h
        mov     _cx,SB_RESETDELAY
@@delay:
	in	al,dx			; wait for a while (3 usecs)
	loop	@@delay
	xor	al,al			; and write 0 to port 2x6h
        out     dx,al

        mov     _dx,[SB.port]
        add     _dx,0Eh                 ; SB data available port 2xEh
        mov     _cx,1000

@@wd1:	in	al,dx
	test	al,al
	js	@@ok1			; wait until bit 7 (data available)
	loop	@@wd1			; is 1 or 1000 times
        jmp     @@err                   ; no data - no SB

@@ok1:  add     _dx,0Ah-0Eh             ; read data port (2xAh)
        mov     _cx,1000

@@wd2:	in	al,dx
	cmp	al,0AAh 		; wait until data is 0AAh or 1000
	je	@@sbok			; times
	loop	@@wd2
        jmp     @@err                   ; no 0AAh - no SB

@@sbok:
        xor     _ax,_ax                 ; SB resetted succesfully
        jmp     @@done

@@err:
        mov     _ax,errSDFailure

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:	sbGetVersion
;*
;* Description: Get Sound Blaster DSP version and set up SB.cardType,
;*              sbVersion and SB.modes accordingly
;*
;\***************************************************************************/

PROC NOLANGUAGE sbGetVersion	NEAR

	SBCMD	0E1h			; Get DSP version number
	call	sbRead			; read version high byte
        test    _ax,_ax
	jnz	@@err
	mov	bh,bl
	call	sbRead			; read version low byte
        test    _ax,_ax
	jnz	@@err
        mov     [sbVersion],_bx         ; store version number

        cmp     _bx,200h                ; DSP version < 2.00?
	jb	@@sb10			; if yes, SB version 1.0
        cmp     _bx,200h                ; DSP version 2.00?
	je	@@sb15			; if yes, SB version 1.5
        cmp     _bx,300h                ; DSP version < 3.00?
	jb	@@sb20			; if yes, SB version 2.0
        cmp     _bx,400h                ; DSP version < 4.00?
	jb	@@sbPro 		; if yes, SB Pro

	; DSP version >= 4.00 - Sound Blaster 16
	mov	[SB.cardType],sb16
        mov     [SB.modes],sdMono or sdStereo or sd8bit or sd16bit
        jmp     @@ok

@@sb10:
	; SB version 1.0
	mov	[SB.cardType],sb10
        mov     [SB.modes],sdMono or sd8bit
	jmp	@@ok

@@sb15:
	; SB version 1.5
	mov	[SB.cardType],sb15
        mov     [SB.modes],sdMono or sd8bit
	jmp	@@ok

@@sb20:
	; SB version 2.0
	mov	[SB.cardType],sb20
        mov     [SB.modes],sdMono or sd8bit
	jmp	@@ok

@@sbPro:
	; SB Pro
	mov	[SB.cardType],sbPro
        mov     [SB.modes],sdMono or sdStereo or sd8bit

@@ok:
        xor     _ax,_ax

@@err:
	ret
ENDP



;/***************************************************************************\
;*
;* Function:	int sbDetect(int *result);
;*
;* Description: Detects Sound Blaster soundcard
;*
;* Returns:	MIDAS error code.
;*		1 stored to *result if SB was detected, 0 if not.
;*
;\***************************************************************************/

PROC    sbDetect        _funct          result : _ptr
USES    _si,_di,_bx
LOCAL   port : _int, IRQ : _int, DMA : _int, highDMA : _int

	; Search for "BLASTER" environment string:
IFDEF __16__
	call	mGetEnv LANG, seg blasterStr offset blasterStr
        mov     bx,dx                   ; was "BLASTER" environment found?
	or	bx,ax			; if not, no SB
	jz	@@nosb

	mov	es,dx			; point es:si to environment
	mov	si,ax			; string

ELSE
        call    mGetEnv LANG, offset blasterStr
        test    eax,eax                 ; was "BLASTER" environment found?
        jz      @@nosb                  ; if not, no SB
	jz	@@nosb

        mov     esi,eax                 ; point _essi to environment string

ENDIF
        mov     [port],-1               ; no port found
	mov	[IRQ],-1		; no IRQ found
	mov	[DMA],-1		; no DMA found
	mov	[highDMA],-1		; no High DMA found

@@envloop:
        mov     al,[_essi]              ; get character from string
        inc     _si
	test	al,al			; end of string?
	jz	@@strend

	and	al,not 20h		; convert to uppercase if a letter

	cmp	al,'A'                  ; Axxx - port address
	je	@@port

	cmp	al,'I'                  ; Ix - IRQ number
	je	@@irq

	cmp	al,'D'                  ; Dx - DMA channel number
	je	@@dma

	cmp	al,'H'                  ; Hx - High DMA channel number
	je	@@highdma

	jmp	@@envloop


@@port:
	; port - the following characters up to next space or \0, maximum
	; 3, are the I/O port number in hexadecimal

        mov     _cx,4
        mov     _di,offset convBuffer

@@ploop:
        mov     al,[_essi]
        inc     _si
	cmp	al,' '
	je	@@port1
	test	al,al
	jz	@@port1
        mov     [_di],al                ; copy port number to conversion
        inc     _di                     ; buffer
	loop	@@ploop 		; max 3 characters

	jmp	@@nosb			; over 3 characters - bad environment

@@port1:
        mov     [byte _di],0            ; append terminating zero

	; convert hex string to number:
	push	es
IFDEF __16__
	call	mHex2Long LANG, seg convBuffer offset convBuffer
ELSE
        call    mHex2Long LANG, offset convBuffer
ENDIF
	pop	es
        cmp     _ax,-1
	je	@@nosb

        mov     [port],_ax
	jmp	@@envloop


@@irq:
	; IRQ - the following characters up to next space or \0, maximum
	; 2, are the IRQ number in decimal

        xor     _ax,_ax
        mov     al,[_essi]              ; get first character
        inc     _si
	cmp	al,'0'                  ; below '0'?
	jb	@@nosb			; if is, bad environment
	sub	al,'0'

        xor     _bx,_bx
        mov     bl,[_essi]              ; next character
	cmp	bl,' '                  ; space?
	je	@@irq1
	test	bl,bl			; terminating zero?
	jz	@@irq1
	cmp	bl,'0'                  ; below '0'?
	jb	@@nosb			; if is, bad environment
        sub     bl,'0'
        imul    _ax,_ax,10              ; IRQ = 10*first + second
        add     _ax,_bx

@@irq1:
        mov     [IRQ],_ax
	jmp	@@envloop


@@dma:
	; DMA - the following character is the DMA channel number
        xor     _ax,_ax
        mov     al,[_essi]              ; get first character
        inc     _si
	cmp	al,'0'                  ; below '0'?
	jb	@@nosb			; if is, bad environment
	sub	al,'0'
        mov     [DMA],_ax
	jmp	@@envloop


@@highdma:
	; High DMA - the following character is the High DMA channel number
        xor     _ax,_ax
        mov     al,[_essi]              ; get first character
        inc     _si
	cmp	al,'0'                  ; below '0'?
	jb	@@nosb			; if is, bad environment
	sub	al,'0'
        mov     [highDMA],_ax
	jmp	@@envloop


@@strend:
	; End of environment string. If port, IRQ or DMA value was not found,
	; the environment string is bad
	cmp	[port],-1
	je	@@nosb
	cmp	[IRQ],-1
	je	@@nosb

	cmp	[highDMA],-1		; was high DMA channel number found?
	jne	@@high1

	cmp	[DMA],-1		; no, use normal DMA
	je	@@nosb
	jmp	@@set

@@high1:
	; High DMA channel number was found - use it as DMA channel
        mov     _ax,[highDMA]
        mov     [DMA],_ax

@@set:
	; Set detected values to card structure:
        mov     _ax,[port]
        mov     [SB.port],_ax
        add     _ax,0Ch
        mov     [sb22C],_ax
        mov     _ax,[IRQ]
        mov     [SB.IRQ],_ax
        mov     _ax,[DMA]
        mov     [SB.DMA],_ax

        call    sbReset                 ; reset the DSP
        test    _ax,_ax
        jnz     @@err

        cmp     [SB.cardType],sbAutoType        ; has a card type been set?
        jne     @@cardtypeset                   ; if not, detect it

        call    sbGetVersion
        test    _ax,_ax
        jnz     @@err

@@cardtypeset:
        LOADPTR es,_bx,[result]
        mov     [_int _esbx],1          ; Sound Blaster was detected
        xor     _ax,_ax
	jmp	@@done

@@nosb:
        LOADPTR es,_bx,[result]
        mov     [_int _esbx],0          ; Sound Blaster not detected
        xor     _ax,_ax
	jmp	@@done

@@err:
	ERROR	ID_sbDetect

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    int sbInit(unsigned mixRate, unsigned mode);
;*
;* Description: Initializes Sound Blaster series Sound Device
;*
;* Input:       unsigned mixRate        mixing rate
;*              unsigned mode           output mode (see enum sdMode)
;*
;* Returns:	MIDAS error code
;*
;\***************************************************************************/

PROC    sbInit          _funct  mixRate : _int, mode : _int
USES    _bx

        mov     _ax,[SB.port]
        add     _ax,0Ch                 ; set sb22C variable to real SB DSP
        mov     [sb22C],_ax             ; command port

        call    sbReset                 ; reset the DSP
        jnz     @@err

        cmp     [SB.cardType],sbAutoType        ; has a card type been set?
	jne	@@typeset
        call    sbGetVersion                    ; if not, detect it

@@typeset:
	cmp	[SB.cardType],sb16	; Sound Blaster 16?
	je	@@modeall		; if yes, all modes supported
	cmp	[SB.cardType],sbPro	; Sound Blaster Pro?
	jae	@@modestereo		; if yes, stereo is supported

	; normal Sound Blaster - only 8-bit mono
	mov	[sbMode],sd8bit or sdMono
	jmp	@@moded

@@modestereo:
	; Sound Blaster Pro - only 8-bit mono or stereo
        mov     _ax,sd8bit              ; 8-bit output
	test	[mode],sdMono		; is mono mode forced?
	jnz	@@smono
        or      _ax,sdStereo            ; no, use stereo
	jmp	@@sok
@@smono:
        or      _ax,sdMono              ; yes, use mono
@@sok:
        mov     [sbMode],_ax            ; store output mode
	jmp	@@moded


@@modeall:
	; Sound Blaster 16 - all output modes
	test	[mode],sd8bit		; force 8-bit?
	jnz	@@8b
        mov     _ax,sd16bit             ; if not, use 16 bits
	jmp	@@bit
@@8b:   mov     _ax,sd8bit

@@bit:	test	[mode],sdMono		; force mono?
	jnz	@@mono
        or      _ax,sdStereo            ; if not, use stereo
	jmp	@@mst
@@mono: or      _ax,sdMono

@@mst:  mov     [sbMode],_ax

@@moded:
        mov     _ax,[SB.IRQ]
	cmp	al,7			; IRQ number > 7 ?
	ja	@@i8

	add	al,8			; no, interrupt number is IRQ+8
	jmp	@@ivect

@@i8:	add	al,70h-8		; yes, interrupt number is IRQ+68h

@@ivect:
        mov     [sbInterrupt],_ax       ; save interrupt number

        push    es
	mov	ah,35h
	int	21h			; save old IRQ vector
        mov     [_int oldIRQ],_bx
        mov     [word oldIRQ+INTSIZE],es
        pop     es

        mov     _ax,[SB.IRQ]
	cmp	al,7			; is IRQ > 7 ?
	ja	@@i82

	mov	cl,al			; no
	in	al,21h
        mov     [oldIRQMask],al         ; save old IRQ mask
	mov	bl,not 1
	rol	bl,cl			; enable SB's IRQ
	and	al,bl
	out	21h,al
	jmp	@@idone

@@i82:	mov	cl,al
	sub	cl,8
	in	al,0A1h
        mov     [oldIRQMask],al         ; save old IRQ mask
	mov	bl,not 1
	rol	bl,cl			; enable SB's IRQ
	and	al,bl
	out	0A1h,al

@@idone:

	cmp	[SB.cardType],sb16	; Sound Blaster 16?
	jae	@@userate		; if so, the sampling rate is directly
					; used

	cmp	[SB.cardType],sb20	; Sound Blaster version < 2.0?
	jb	@@limit1		; if yes, rate limit is 21739Hz

	; Sound Blaster 2.0 or Pro - sampling rate limit is 43478Hz, so the
	; maximum Time Constant is 233
	mov	ecx,233
	jmp	@@timeconstant

@@limit1:
	; Sound Blaster 1.0 or 1.5 - sampling rate limit is 21739Hz, making
	; the maximum Time Constant 210
	mov	ecx,210

@@timeconstant:
	; Calculate the Transfer Time Constant
IFDEF __16__
        xor     ebx,ebx
ENDIF
        mov     _bx,[mixRate]
	test	[sbMode],sdStereo	; use stereo?
	jz	@@nostt 		; if yes, multiply rate with 2 when
	shl	ebx,1			; calculating Time Constant

@@nostt:
	mov	eax,1000000		; eax = Time Constant =
        xor     edx,edx                 ; 256 - (1000000 / rate)
	div	ebx
	neg	eax
	add	eax,256

	test	eax,eax
	jns	@@non1			; Time Constant must be nonnegative
	xor	eax,eax

@@non1: cmp	eax,ecx 		; ecx is the maximum Time Constant
	jbe	@@noa1
	mov	eax,ecx 		; limit Time Constant to ecx value

@@noa1: mov     [sbTimeConstant],_ax    ; store Transfer Time Constant

	mov	ebx,256
	sub	ebx,eax
	mov	eax,1000000		; calculate actual playing rate
        xor     edx,edx                 ; (= 1000000 / (256 - TimeConstant))
	div	ebx

	test	[sbMode],sdStereo	; using stereo?
	jz	@@nostt2
	shr	eax,1			; divide with 2 to get rate

@@nostt2:
        mov     [sbRate],_ax
        jmp     @@initmixsd


@@userate:
	; Sound Blaster 16 - output uses the sampling rate directly
        mov     _ax,[mixRate]
        mov     [sbRate],_ax


@@initmixsd:
        cmp     [SB.cardType],sbPro     ; if playing stereo on SB Pro
	jne	@@dmaok 		; set stereo mode and output one
	test	[sbMode],sdStereo	; silent byte before starting the
	jz	@@dmaok 		; actual transfer

	call	sbSetStereo
        test    _ax,_ax
	jnz	@@err

@@dmaok:
        ; Take care of common initialization for all mixing Sound Devices:
        push    es
        call    mixsdInit LANG, [sbRate], [sbMode], [SB.DMA]
        pop     es
        test    _ax,_ax
        jnz     @@err

        mov     [sbBlockLength],0FFF0h  ; set DSP block length to 0FFF0h
					; samples - autoinit DMA mode takes
					; care of wrapping

        mov     _bx,[SB.cardType]
        cmp     _bx,sb10                ; Sound Blaster 1.0?
	je	@@v100			; if is, auto-initialize mode is not
					; available

	; set up interrupt service routine for auto-initialize mode:
	push	ds
	mov	ah,25h
        mov     al,[byte sbInterrupt]
        mov     dx,cs
	mov	ds,dx
        mov     _dx,offset sbAutoinitIRQ
	int	21h
	pop	ds

        cmp     _bx,sb16                ; Sound Blaster 16?
	je	@@v400			; if is, use DSP 4.00 playing mode
					; for all output modes

        cmp     _bx,sb20                ; Sound Blaster 2.0 or Pro?
	jae	@@v201			; if is, high-speed output is
					; available

	jmp	@@v200


@@v100:
	; Sound Blaster 1.0 - play using mono single-cycle mode

	; set up interrupt service routine for single-cycle mode:
	push	ds
	mov	ah,25h
        mov     al,[byte sbInterrupt]
        mov     dx,cs
	mov	ds,dx
        mov     _dx,offset sbSingleCycleIRQ
	int	21h
	pop	ds

	; start playing:
	call	sbPlayMonoSingleCycle
	jmp	@@playing

@@v200:
	; Sound Blaster 1.5 - play using mono auto-initialize mode
	call	sbPlayMonoAutoinit
	jmp	@@playing

@@v201:
	; Sound Blaster 2.0 or Pro - high-speed output is available
	test	[sbMode],sdStereo	; use stereo?
	jnz	@@plstereo		; if yes, play using stereo mode

	cmp	[sbRate],22000		; is sampling rate over 22000Hz?
	ja	@@highspeed		; if is, use high-speed mode

	; Sound Blaster 2.0 or Pro, mono, rate <= 22000Hz - play using mono
	; auto-initialize mode
	call	sbPlayMonoAutoinit
	jmp	@@playing

@@highspeed:
	; Sound Blaster 2.0 or Pro, mono, rate > 22000Hz - play using mono
	; high-speed (auto-initialize) mode
	call	sbPlayMonoHighSpeed
	jmp	@@playing

@@plstereo:
	; Sound Blaster Pro, stereo - play using stereo
	; high-speed auto-initialize mode
	call	sbPlayStereo
	jmp	@@playing

@@v400:
	; Sound Blaster 16 - use DSP v4.00 auto-initialize mode for all output
	; modes
	call	sbPlay400

@@playing:
        test    _ax,_ax
	jnz	@@err

        xor     _ax,_ax                 ; SB succesfully initialized
	jmp	@@done

@@sberr:
        mov     _ax,errSDFailure        ; Hardware failure

@@err:	ERROR	ID_sbInit

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	sbPlayMonoSingleCycle
;*
;* Description: Starts playing the buffer using 8-bit mono Single-Cycle mode
;*
;\***************************************************************************/

PROC NOLANGUAGE sbPlayMonoSingleCycle	NEAR

	SBCMD	0D1h			; turn on DAC speaker
	SBCMD	40h			; set Transfer Time Constant
        SBCMD   <[byte sbTimeConstant]> ; Time Constant
	SBCMD	14h			; 8-bit PCM output
	SBCMD	<[byte sbBlockLength]>	  ; block length low byte
	SBCMD	<[byte sbBlockLength+1]>  ; block length high byte

@@err:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	sbSingleCycleIRQ
;*
;* Description: SB DSP interrupt service routine for 8-bit Single-Cycle mode
;*
;\***************************************************************************/

PROC NOLANGUAGE sbSingleCycleIRQ

	sti
        push    _ax
        push    _cx
        push    _dx                     ; save all registers that will be
	push	ds			; changed

        ; FIXME:
        mov     ax,DGROUP
	mov	ds,ax

	SBCMD	14h			; 8-bit PCM output
	SBCMD	<[byte sbBlockLength]>	  ; block length low byte
	SBCMD	<[byte sbBlockLength+1]>  ; block length high byte

@@err:	; no error handling can be done here

        mov     _dx,[SB.port]
        add     _dx,0Eh                 ; acknowledge DSP interrupt
	in	al,dx

	cmp	[SB.IRQ],7
	ja	@@upirq

	mov	al,20h			; send End Of Interrupt command to
	out	20h,al			; PIC
	jmp	@@done

@@upirq:
	mov	al,20h			; send EOI to PIC #2 (IRQ > 7)
	out	0A0h,al
        out     20h,al

@@done:
	pop	ds
        pop     _dx
        pop     _cx
        pop     _ax

IFDEF __16__
        iret                            ; some TASM versions seem to generate
ELSE                                    ; iret even in 32-bit modes
        iretd
ENDIF
ENDP




;/***************************************************************************\
;*
;* Function:	sbPlayMonoAutoinit
;*
;* Description: Starts playing the buffer using 8-bit Auto-initialize mode
;*
;\***************************************************************************/

PROC NOLANGUAGE sbPlayMonoAutoinit	NEAR

	SBCMD	0D1h			; turn on DAC speaker
	SBCMD	40h			; set DSP Transfer Time Constant
        SBCMD   <[byte sbTimeConstant]> ; Transfer Time Constant
	SBCMD	48h			; set DSP transfer block size
	SBCMD	<[byte sbBlockLength]>	  ; block length low byte
	SBCMD	<[byte sbBlockLength+1]>  ; block length high byte
	SBCMD	1Ch			; start 8-bit PCM output

@@err:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	sbAutoinitIRQ
;*
;* Description: SB DSP interrupt service routine for 8-bit Auto-initialize
;*		mode
;*
;\***************************************************************************/

PROC NOLANGUAGE sbAutoinitIRQ

	sti
        push    _ax
        push    _cx
        push    _dx                     ; save all registers that will be
        push    ds                      ; changed

        ; Fixme:
        mov     ax,DGROUP
	mov	ds,ax

	test	[sbMode],sd16bit	; 16-bit output mode?
	jnz	@@16

        mov     _dx,[SB.port]
        add     _dx,0Eh                 ; acknowledge DSP interrupt
	in	al,dx
	jmp	@@ackdone

@@16:
        mov     _dx,[SB.port]
        add     _dx,0Fh                 ; acknowledge DSP interrupt
	in	al,dx

@@ackdone:
	cmp	[SB.IRQ],7
	ja	@@upirq

	mov	al,20h			; send End Of Interrupt command to
	out	20h,al			; PIC
	jmp	@@done

@@upirq:
	mov	al,20h			; send EOI to PIC #2 (IRQ > 7)
	out	0A0h,al
        out     20h,al

@@done:
	pop	ds
        pop     _dx
        pop     _cx
        pop     _ax

IFDEF __16__
        iret                            ; some TASM versions seem to generate
ELSE                                    ; iret even in 32-bit modes
        iretd
ENDIF
ENDP




;/***************************************************************************\
;*
;* Function:	sbPlayMonoHighSpeed
;*
;* Description: Starts playing the buffer using 8-bit mono High-Speed
;*		Auto-initialize mode
;*
;\***************************************************************************/

PROC NOLANGUAGE sbPlayMonoHighSpeed	NEAR

	SBCMD	0D1h			; turn on DAC speaker
	SBCMD	40h			; set DSP transfer Time Constant
        SBCMD   <[byte sbTimeConstant]> ; transfer Time Constant
	SBCMD	48h			; set DSP transfer block size
	SBCMD	<[byte sbBlockLength]>	  ; block length low byte
	SBCMD	<[byte sbBlockLength+1]>  ; block length high byte
	SBCMD	90h			; 8-bit PCM high-speed output

@@err:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	sbSetStereo
;*
;* Description: Sets the SB hardware to stereo mode and plays a single
;*		silent byte. Called before starting stereo transfer on
;*		DSP < 4.00 to make sure that the channels are the right
;*		way and not reversed (left comes from left and right from
;*              right). Note that this is not of our own invention, but is
;*              actually documented in the SDK.
;*
;\***************************************************************************/

PROC NOLANGUAGE sbSetStereo	NEAR

	SBCMD	0D1h

        mov     _dx,[SB.port]
        add     _dx,04h
	mov	al,0Eh
	out	dx,al			; set the mixer to stereo mode
        inc     _dx
	in	al,dx
	or	al,2
	out	dx,al

        ; set up the IRQ handler for transfer:
        push    ds
	mov	ah,25h
        mov     al,[byte sbInterrupt]
        mov     dx,cs
	mov	ds,dx
        mov     _dx,offset @@irqhandler
	int	21h
	pop	ds

        ; Set up the DMA buffer for one byte transfer:
        mov     [sbStereoDMABuffer.startAddr],0
        mov     [sbStereoDMABuffer.bufferLen],0
        mov     [sbStereoDMABuffer.channel],-1

        ; program the DMA controller for single-cycle output:
IFDEF __16__
        call    dmaPlayBuffer LANG, \
                seg sbStereoDMABuffer offset sbStereoDMABuffer, [SB.DMA], 0
ELSE
        push    es
        call    dmaPlayBuffer LANG, offset sbStereoDMABuffer, [SB.DMA], 0
        pop     es
ENDIF
        test    _ax,_ax
	jnz	@@err

	mov	[sbStereoOK],0

	SBCMD	14h
	SBCMD	0			; program the DSP to output one
	SBCMD	0			; silent byte (80h)

	; wait until the IRQ occurs:
@@w:
	cmp	[sbStereoOK],1
	jne	@@w

        xor     _ax,_ax

@@err:
	ret


@@irqhandler:
	; IRQ handler routine:

        push    _ax
        push    _cx
        push    _dx                     ; save all registers that will be
	push	ds			; changed

        ; FIXME:
        mov     ax,DGROUP
	mov	ds,ax

	mov	[sbStereoOK],1		; set interrupt flag

        mov     _dx,[SB.port]
        add     _dx,0Eh                 ; acknowledge DSP interrupt
	in	al,dx

	cmp	[SB.IRQ],7
	ja	@@upirq

	mov	al,20h			; send End Of Interrupt command to
	out	20h,al			; PIC
	jmp	@@done

@@upirq:
	mov	al,20h			; send EOI to PIC #2 (IRQ > 7)
	out	0A0h,al
        out     020h,al

@@done:
	pop	ds
        pop     _dx
        pop     _cx
        pop     _ax

IFDEF __16__
	iret
ELSE
        iretd
ENDIF
ENDP




;/***************************************************************************\
;*
;* Function:	sbPlayStereo
;*
;* Description: Starts playing the buffer using 8-bit stereo High-Speed
;*		Auto-initialize mode
;*
;\***************************************************************************/

PROC NOLANGUAGE sbPlayStereo    NEAR

	SBCMD	0D1h			; turn on DAC speaker
	SBCMD	40h			; set DSP transfer Time Constant
        SBCMD   <[byte sbTimeConstant]> ; transfer Time Constant

	; save output filter status and turn it off:
        mov     _dx,[SB.port]
        add     _dx,04h
	mov	al,0Ch
	out	dx,al
        inc     _dx
	in	al,dx
        mov     [sbOutputFilter],al
	or	al,20h
	out	dx,al

	SBCMD	48h			; set DSP transfer block size
	SBCMD	<[byte sbBlockLength]>	  ; block length low byte
	SBCMD	<[byte sbBlockLength+1]>  ; block length high byte
	SBCMD	90h			; 8-bit PCM high-speed output

@@err:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	sbPlay400
;*
;* Description: Starts playing the buffer using the DSP 4.00 Auto-initialize
;*		transfer
;*
;\***************************************************************************/

PROC NOLANGUAGE sbPlay400	NEAR

	SBCMD	41h			; set DSP output sampling rate
	SBCMD	<[byte sbRate+1]>	; sampling rate high byte
	SBCMD	<[byte sbRate]> 	; sampling rate low byte

	test	[sbMode],sd8bit 	; 8-bit mode?
	jnz	@@8bit

	SBCMD	0B4h			; 16-bit output
	test	[sbMode],sdMono 	; mono?
	jnz	@@mono16
	SBCMD	30h			; 16-bit stereo signed PCM
	jmp	@@setlen
@@mono16:
	SBCMD	10h			; 16-bit mono signed PCM
	jmp	@@setlen

@@8bit:
	SBCMD	0C6h			; 8-bit output
	test	[sbMode],sdMono 	; mono?
	jnz	@@mono8
	SBCMD	20h			; 8-bit stereo unsigned PCM
	jmp	@@setlen
@@mono8:
	SBCMD	00h			; 8-bit mono unsigned PCM

@@setlen:
	SBCMD	<[byte sbBlockLength]>	  ; transfer length low byte
	SBCMD	<[byte sbBlockLength+1]>  ; transfer length high byte

@@err:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:	int sbClose(void)
;*
;* Description: Uninitializes Sound Blaster
;*
;* Returns:	MIDAS error code
;*
;\***************************************************************************/

PROC    sbClose         _funct
USES    _bx

	; Reset DSP _twice_ to stop playing and reset it: (In High-Speed mode
	; the first DSP reset just stops the playing. Besides, this should
        ; not hurt anyone in any output mode anyway.)
        mov     _bx,2
        mov     _dx,[SB.port]
        add     _dx,06h

@@reset:
	mov	al,1			; reset SB DSP by first writing 1 to
	out	dx,al			; port 2x6h
        mov     _cx,SB_RESETDELAY
@@delay:
	in	al,dx			; wait for a while (3 usecs)
	loop	@@delay
	xor	al,al			; and write 0 to port 2x6h
        out     dx,al

        mov     _cx,SB_RESETDELAY
@@delay2:				; another delay
	in	al,dx
	loop	@@delay2

        dec     _bx                     ; and reset again
	jnz	@@reset


        ; Take care of common uninitialization for all mixing Sound Devices:
        push    es
        call    mixsdClose
        pop     es
        test    _ax,_ax
        jnz     @@err


        cmp     [SB.IRQ],7              ; is IRQ number > 7 ?
	ja	@@i8

        mov     al,[oldIRQMask]
	out	21h,al			; restore old IRQ mask, IRQ <= 7
	jmp	@@ivect

@@i8:   mov     al,[oldIRQMask]         ; restore old IRQ mask, IRQ > 7
	out	0A1h,al

@@ivect:
	push	ds
        mov     al,[byte sbInterrupt]
	mov	ah,25h			; restore old IRQ vector
        lds     _dx,[oldIRQ]
	int	21h
	pop	ds

        SBCMD   0D3h                    ; turn off the DAC speaker

	cmp	[SB.cardType],sbPro
	jne	@@stok			; using stereo on SB Pro?
	test	[sbMode],sdStereo
	jz	@@stok

	; stereo on SB Pro - restore the output filter status and set
	; hardware to mono mode:

        mov     _dx,[SB.port]
        add     _dx,04h                 ; write 04h to port 2x4h
	mov	al,0Ch
	out	dx,al
        inc     _dx
	mov	al,[sbOutputFilter]	; write output filter value to 2x5h
	out	dx,al

        dec     _dx
	mov	al,0Eh
	out	dx,al
        inc     _dx                     ; turn off stereo mode
	in	al,dx
	and	al,not 02h
	out	dx,al

@@stok:
        xor     _ax,_ax
	jmp	@@done

@@err:	ERROR	ID_sbClose

@@done:
	ret
ENDP


;* $Log: sb.asm,v $
;* Revision 1.5  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.4  1997/01/16 18:27:15  pekangas
;* Fixed IRQ acknowledging with IRQs >7 (thanks Statix)
;*
;* Revision 1.3  1996/10/13 16:55:18  pekangas
;* Fixed a bug in detecting IRQs >9
;*
;* Revision 1.2  1996/08/04 11:33:44  pekangas
;* All functions now preserve _bx
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*

END