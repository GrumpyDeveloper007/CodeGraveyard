;*      PAS.ASM
;*
;* Pro Audio Spectrum Sound Device
;*
;* $Id: pas.asm,v 1.3 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*

;* NOTE! A lot of this code is ripped more or less directly from the PAS
;* SDK and might therefore seem messy.
;* I really do not understand some parts of this code... Perhaps I'll clear
;* it up some day when I have time.
;* (PK)

;* Update: The above probably won't ever happen though. The statement has been
;* there over a year now, through three major revisions of the Sound Device..



IDEAL
P386
JUMPS

INCLUDE "pas.inc"
INCLUDE "lang.inc"
INCLUDE "errors.inc"
INCLUDE "sdevice.inc"
INCLUDE "dsm.inc"
INCLUDE "mixsd.inc"
IFDEF __DPMI__
INCLUDE "dpmi.inc"
ENDIF



;/***************************************************************************\
;*       enum pasFunctIDs
;*       ----------------
;* Description:  ID numbers for PAS Sound Device functions
;\***************************************************************************/

ENUM    pasFunctIDs \
        ID_pasDetect = ID_pas, \
        ID_pasInit, \
        ID_pasClose



;/***************************************************************************\
;*      enumpasCardTypes
;*      ----------------
;* Description: Sound Card type number for Pro Audio Spectrum Sound Device
;\***************************************************************************/

ENUM    pasCardTypes \
        pasAutoType = 0, \              ; autodetect card type
        pasNormal, \                    ; Pro Audio Spectrum
        pasPlus, \                      ; Pro Audio Spectrum plus
        pas16                           ; Pro Audio Spectrum 16




DATASEG


D_int   pasSpeed                        ; output rate value
D_int   pasRate                         ; actual output rate
D_int   pasMode                         ; output mode

IFDEF __DPMI__
regs            dpmiRealCallRegs  ?     ; DPMI interrupt calling registers
ENDIF


IFDEF __PASCAL__
EXTRN   PAS : SoundDevice
ENDIF


IDATASEG

PASCONFIGBITS = sdUsePort or sdUseIRQ or sdUseDMA or sdUseMixRate or \
        sdUseOutputMode or sdUseDSM
PASMODEBITS = sdMono or sdStereo or sd8bit or sd16bit



; If compiling for Pascal, Sound Device name is pasSD, from which the data
; will be copied to Sound Device PAS, defined in Pascal.

IFDEF   __PASCAL__
SDNAM           equ     pasSD
ELSE
SDNAM           equ     PAS
ENDIF

GLOBAL  LANG SDNAM : SoundDevice

SDNAM   SoundDevice     < \
 0,\
 PASCONFIGBITS,\
 388h, 15, 5,\
 pasAutoType, 3,\
 PASMODEBITS,\
 ptr_to pasSDName,\
 ptr_to pasCardNames,\
 4, ptr_to pasPortAddresses,\
 ptr_to pasDetect,\
 ptr_to pasInit,\
 ptr_to pasClose,\
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


pasSDName       DB      "Pro Audio Spectrum series Sound Device v1.30", 0

                ; *!!*
pasCardNames    DD      ptr_to pasName
                DD      ptr_to pasPlusName
                DD      ptr_to pas16Name

pasName         DB      "Pro Audio Spectrum", 0
pasPlusName     DB      "Pro Audio Spectrum plus", 0
pas16Name       DB      "Pro Audio Spectrum 16", 0

IFDEF __16__
pasPortAddresses  DW    388h, 384h, 38Ch, 288h
ELSE
pasPortAddresses  DD    388h, 384h, 38Ch, 288h
ENDIF




DATASEG


D_int   mvTranslateCode                 ; I/O base xor default_base

D_farptr mvhwShadowPointer              ; pointer to shadow register values
IFDEF __32__
                DW      0               ; kluge - 32-bit DPMI functions assume
                                        ; 32-bit selector values with upper
                                        ; 16 bits zero
ENDIF




CODESEG



PUBLIC	pasDetect
PUBLIC	pasInit
PUBLIC	pasClose




PROC    pasSearchHW     _funct
USES    _si,_di,_bx

;
; calculate the translation code
;
        mov     [PAS.port],_di

        xor     _di,DEFAULT_BASE        ; di holds the translation code

;
; grab the version # in the interrupt mask. The top few bits hold the version #
;
        mov     _dx,INTRCTLR            ; board ID is in MSB 3 bits
        xor     _dx,_di                 ; adjust to other address
	in	al,dx
	cmp	al,-1			; bus float meaning not present?
	je	@@bad			; yes, there is no card here

	mov	ah,al			; save an original copy
	xor	al,fICrevbits		; the top bits wont change

	out	dx,al			; send out the inverted bits
        jmp short $+2
        jmp short $+2
	in	al,dx			; get it back...

	cmp	al,ah			; both should match now...
	xchg	al,ah			; (restore without touching the flags)
	out	dx,al

	jnz	@@bad			; we have a bad board

;
; We do have hardware!
;

        mov     _ax,1                   ; a valid PAS card found
        jmp     @@done


@@bad:
        xor     _ax,_ax                 ; we got here due to a bad board

@@done:
	ret
ENDP



PROC    pasSetVersion   _funct
USES    _di,_bx

        mov     _di,[PAS.port]
        xor     _di,DEFAULT_BASE        ; di holds the translation code

;
; grab the version # in the interrupt mask. The top few bits hold the version #
;
        mov     _dx,INTRCTLR            ; board ID is in MSB 3 bits
        xor     _dx,_di                 ; adjust to other address
	in	al,dx
	cmp	al,-1			; bus float meaning not present?
	je	@@bad			; yes, there is no card here

	mov	ah,al			; save an original copy
	xor	al,fICrevbits		; the top bits wont change

	out	dx,al			; send out the inverted bits
	jmp	$+2
	jmp	$+2
	in	al,dx			; get it back...

	cmp	al,ah			; both should match now...
	xchg	al,ah			; (restore without touching the flags)
	out	dx,al

	jnz	@@bad			; we have a bad board

        and     _ax,fICrevbits          ; isolate the ID bits & clear AH
        shr     al,fICrevshr            ; shift the bits into a meaningful
                                        ; position (least signficant bits)
        mov     _si,_ax                 ; save the version #
;
; We do have hardware! Load the product bit definitions
;
        test    al,al                   ; is this the first version of h/w?
        jz      @@vpas                  ; yes, it's a standard PAS

        ; The card is either PAS plus or PAS 16. The only thing that
        ; actually matters here is whether the card has a 16-bit DAC or
        ; not. If yes, it's a PAS 16, otherwise assume it's PAS plus.

;
; determine the CDROM drive type, FM chip, 8/16 bit DAC, and mixer
;
        mov     _dx,SLAVEMODRD          ; check for the CDPC
        xor     _dx,_di                 ; modify via the translate code
	in	al,dx

	test	al,bSMRDdactyp		; 16 bit DAC?
        jz      @@vpasplus              ; no, its an 8 bit DAC - PAS plus

        ; neither PAS or PAS plus - assume PAS 16
        mov     [PAS.cardType],pas16
        mov     [PAS.modes],sdStereo or sdMono or sd16bit or sd8bit
        jmp     @@ok

@@vpas:
        ; standard PAS card
        mov     [PAS.cardType],pasNormal
        mov     [PAS.modes],sdStereo or sdMono or sd8bit
        jmp     @@ok

@@vpasplus:
        ; PAS plus
        mov     [PAS.cardType],pasPlus
        mov     [PAS.modes],sdStereo or sdMono or sd8bit
        jmp     @@ok


@@bad:
        mov     _ax,errSDFailure        ; bad card - SD hardware failure
        jmp     @@done

@@ok:
        xor     _ax,_ax

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int pasDetect(int *result);
;*
;* Description: Detects Pro Audio Spectrum soundcard
;*
;* Returns:     MIDAS error code.
;*              1 stored to *result if PAS was detected, 0 if not.
;*
;\***************************************************************************/

PROC    pasDetect       _funct  result : _ptr
USES    _si,_di,_bx

        ; For some oddball reason this function does not work with
        ; Borland Pascal 7 in Protected mode. Therefore when compiling for
        ; BP7 Protect Mode this function just stores 0 in *result and
        ; exits. Therefore it is important to have a reasonable setup like
        ; midasConfig() where the user can enter the correct values for
        ; Port, IRQ and DMA if they differ from the default ones.

IFDEF __DPMI__
IFDEF __PASCAL__
;NOPASDETECT = 1
ENDIF
ENDIF

IFDEF NOPASDETECT

        les     bx,[result]             ; no detection for BP7 protected mode
        mov     [word es:bx],0
        xor     ax,ax
        ret
ELSE

IFDEF __DPMI__
        ; use DPMI to emulate real mode interrupt:

        mov     [regs.rEAX],0BC00h      ; make sure MVSOUND.SYS is loaded
        mov     [regs.rEBX],'??'        ; this is our way of knowing if the
        mov     [regs.rECX],0           ; hardware is actually present.
        mov     [regs.rEDX],0
        mov     [regs.rSP],0
        mov     [regs.rSS],0
IFDEF __16__
        call    dpmiRealModeInt LANG, 2Fh, seg regs offset regs
ELSE
        call    dpmiRealModeInt LANG, 2Fh, offset regs
ENDIF
        test    _ax,_ax
        jnz     @@err

        mov     bx,[word regs.rEBX]     ; build the result
        xor     bx,[word regs.rECX]
        xor     bx,[word regs.rEDX]

ELSE
        mov     ax,0BC00H               ; make sure MVSOUND.SYS is loaded
	mov	bx,'??'                 ; this is our way of knowing if the
	xor	cx,cx			; hardware is actually present.
	xor	dx,dx
        int     2Fh                     ; get the ID pattern
	xor	bx,cx			; build the result
	xor	bx,dx
ENDIF

        cmp     bx,'MV'                 ; if not here, exit...
        jne     @@nopas

;
; get the MVSOUND.SYS specified DMA and IRQ channel
;
IFDEF __DPMI__
        ; use DPMI to emulate real mode interrupt:
        mov     [regs.rEAX],0BC04h      ; get the DMA and IRQ numbers
        mov     [regs.rSP],0
        mov     [regs.rSS],0
IFDEF __16__
        call    dpmiRealModeInt LANG, 2Fh, seg regs offset regs
ELSE
        call    dpmiRealModeInt LANG, 2Fh, offset regs
ENDIF
        test    _ax,_ax
        jnz     @@err
        xor     _ax,_ax
        mov     al,[byte regs.rEBX]
        mov     [PAS.DMA],_ax
        mov     al,[byte regs.rECX]
        mov     [PAS.IRQ],_ax
ELSE
        mov     ax,0BC04h               ; get the DMA and IRQ numbers
        int     2Fh
        xor     bh,bh
        mov     [PAS.DMA],bx            ; save the correct DMA & IRQ
        xor     ch,ch
        mov     [PAS.IRQ],cx
ENDIF


        ; now search for the hardware port address:


    ; search the default address

        mov     _di,DEFAULT_BASE        ; try the first address
	call	pasSearchHW
        cmp     _ax,1
        je      @@found

    ; search the first alternate address

        mov     _di,ALT_BASE_1          ; try the first alternate
	call	pasSearchHW
        cmp     _ax,1
        je      @@found

    ; search the second alternate address

        mov     _di,ALT_BASE_2          ; try the second alternate
	call	pasSearchHW
        cmp     _ax,1
        je      @@found

    ; search the third, or user requested alternate address

        mov     _di,ALT_BASE_3          ; try the third alternate
	call	pasSearchHW		; pass the third A, or user I/O
        cmp     _ax,1
        jne     @@nopas

@@found:
        LOADPTR es,_bx,[result]         ; write 1 to *result - PAS detected
        mov     [_int _esbx],1          ; succesfully

        cmp     [PAS.cardType],pasAutoType      ; has the card type been set?
        jne     @@verset                        ; if yes, do not detect

        call    pasSetVersion           ; set card version to card structure
        test    _ax,_ax
        jnz     @@err

@@verset:
        cmp     [PAS.cardType],pasNormal        ; normal PAS or PAS plus?
        je      @@no16modes                     ; if yes, 16-bit modes are
        cmp     [PAS.cardType],pasPlus          ; not available
        je      @@no16modes

        ; All output modes available:
        mov     [PAS.modes],sd8bit or sd16bit or sdMono or sdStereo
        jmp     @@ok

@@no16modes:
        ; No 16-bit modes available:
        mov     [PAS.modes],sd8bit or sdMono or sdStereo
        jmp     @@ok

@@nopas:
        LOADPTR es,_bx,[result]
        mov     [_int _esbx],0          ; no PAS found

@@ok:
        xor     _ax,_ax                 ; success
        jmp     @@done

@@err:
        ERROR   ID_pasDetect

@@done:
	ret
ENDIF
ENDP




;/***************************************************************************\
;*
;* Function:    int pasInit(unsigned mixRate, unsigned mode);
;*
;* Description: Initializes Pro Audio Spectrum
;*
;* Input:       unsigned mixRate        mixing rate
;*              unsigned mode           output mode (see enum sdMode)
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    pasInit         _funct  mixRate : _int, mode : _int
USES    es,_si,_di,_bx

        mov     _di,[PAS.port]          ; PAS I/O port
	call	pasSearchHW		; search for hardware at this port
        cmp     _ax,1
        je      @@hwok

        mov     _ax,errSDFailure        ; Sound Device hardware failure
        jmp     @@err

@@hwok:
        xor     _di,DEFAULT_BASE        ; save port XOR default port
        mov     [mvTranslateCode],_di

        cmp     [PAS.cardType],pasAutoType      ; has card type been set?
        jne     @@typeset

        call    pasSetVersion           ; set card type to card structure


@@typeset:
        mov     [pasMode],0

	test	[mode],sd8bit		; force 8-bit?
	jnz	@@8b
        cmp     [PAS.cardType],pas16    ; is the card type PAS 16?
        jne     @@8b                    ; if not, use 8-bit output
        or      [pasMode],sd16bit       ; use 16 bits
	jmp	@@bit
@@8b:	or	[pasMode],sd8bit

@@bit:	test	[mode],sdMono		; force mono?
	jnz	@@mono
	or	[pasMode],sdStereo	; if not, use stereo
	jmp	@@mst
@@mono: or	[pasMode],sdMono

@@mst:

        ; from PAS SDK...

IFDEF __DPMI__
        ; Get pointer to PAS driver shadow hardware register table:

        mov     [regs.rEAX],0BC02h
        mov     [regs.rSS],0
        mov     [regs.rSP],0
IFDEF __16__
        call    dpmiRealModeInt LANG, 2Fh, seg regs offset regs
ELSE
        call    dpmiRealModeInt LANG, 2Fh, offset regs
ENDIF
        test    _ax,_ax
        jnz     @@err
        cmp     [word regs.rEAX],'MV'
        je      @@mvok

        mov     _ax,errSDFailure
        jmp     @@err

@@mvok:
        ; regs.rEDX:regs.rEBX now contains a real mode pointer to the PAS
        ; hardware status table. Now we must build a DPMI descriptor to
        ; the data area and store it plus offset 0 to mvhwShadowPointer:

        mov     [_int mvhwShadowPointer],0      ; offset 0

        ; Allocate descriptor from DPMI:
IFDEF __16__
        call    dpmiAllocDescriptor LANG, seg mvhwShadowPointer \
                (offset mvhwShadowPointer+2)
ELSE
        call    dpmiAllocDescriptor LANG, offset mvhwShadowPointer+4
ENDIF
        test    _ax,_ax
        jnz     @@err

        xor     eax,eax
        xor     ebx,ebx
        mov     ax,[word regs.rEDX]     ; eax = linear address of hardware
        shl     eax,4                   ; status table
        mov     bx,[word regs.rEBX]
        add     eax,ebx

        ; Set segment base address:
        call    dpmiSetSegmentBase LANG, [_int mvhwShadowPointer+INTSIZE], eax
        test    _ax,_ax
        jnz     @@err

        ; Set correct segment limit:
        mov     eax,(SIZE MVState) - 1
        call    dpmiSetSegmentLimit LANG, [_int mvhwShadowPointer+INTSIZE], \
                eax
        test    _ax,_ax
        jnz     @@err
ELSE
	mov	ax,0BC02H		; get the pointer
	int	2fh
	cmp	ax,'MV'                 ; busy or intercepted
	jnz	@@spdone

	mov	[word mvhwShadowPointer+0],bx
	mov	[word mvhwShadowPointer+2],dx
ENDIF
;
@@spdone:

        mov     _dx,INTRCTLRST                 ; flush any pending PCM irq
        xor     _dx,[mvTranslateCode]          ; xlate the board address
	out	dx,al


	; calculate sample rate

        les     _di,[mvhwShadowPointer]

	mov	eax,1193180
	xor	edx,edx
IFDEF __16__
        xor     ebx,ebx
ENDIF
        mov     _bx,[mixRate]
	div	ebx
        mov     [es:_di+MVState._samplerate],ax ; save output speed
        mov     [pasSpeed],_ax

	test	[pasMode],sdStereo
	jz	@@nostereo
        mov     _ax,[pasSpeed]
        shr     _ax,1                   ; multiply output rate with 2 if
        mov     [pasSpeed],_ax          ; stereo
        mov     [es:_di+MVState._samplerate],ax

@@nostereo:
	mov	eax,1193180
	xor	edx,edx
IFDEF __16__
        xor     ebx,ebx
ENDIF
        mov     _bx,[pasSpeed]          ; calculate actual output rate
	div	ebx

	test	[pasMode],sdStereo
	jz	@@nostereo2		; divide with 2 if stereo to get
	shr	eax,1			; actual output rate

@@nostereo2:
        mov     [pasRate],_ax

	mov	al,00110110b		; 36h Timer 0 & square wave
        mov     _dx,TMRCTLR
        xor     _dx,[mvTranslateCode]   ; xlate the board address

	cli

	out	dx,al			; setup the mode, etc
        mov     [es:_di+MVState._tmrctlr],al

        mov     ax,[es:_di+MVState._samplerate] ; pre-calculated & saved in
        mov     _dx,SAMPLERATE                  ; prior code
        xor     _dx,[mvTranslateCode]  ; xlate the board address
	out	dx,al			; output the timer value

        jmp short $+2

	xchg	ah,al
	out	dx,al
	sti

        mov     _dx,CROSSCHANNEL
        xor     _dx,[mvTranslateCode]

        mov     al,[es:_di+MVState._crosschannel]    ; Stop PAS' DMA transfer
	or	al,bCCdrq
        mov     [es:_di+MVState._crosschannel],al
	out	dx,al

        ; Take care of common initialization for all mixing Sound Devices:
        push    es
        call    mixsdInit LANG, [pasRate], [pasMode], [PAS.DMA]
        pop     es
        test    _ax,_ax
        jnz     @@err

	test	[pasMode],sd16bit
	jz	@@no16bit
        mov     _cx,(((NOT(bSC216bit+bSC212bit) AND 0FFh)*256) + bSC216bit)
        mov     _dx,SYSCONFIG2
        xor     _dx,[mvTranslateCode]  ; xlate the board address
	in	al,dx
	and	al,ch			; clear the bits
	or	al,cl			; set the appropriate bits
	out	dx,al
@@no16bit:
	mov	al,bCCmono		; get the stereo/mono mask bit
	test	[pasMode],sdStereo
	jz	@@nostereox
	sub	al,al
@@nostereox:
	or	al,bCCdac		; get the direction bit mask
	or	al,bCCenapcm		; enable the PCM state machine
        mov     _dx,CROSSCHANNEL
        xor     _dx,[mvTranslateCode]  ; xlate the board address

	mov	ah,0fh + bCCdrq 	; get a mask to load non PCM bits
        and     ah,[es:_di+MVState._crosschannel]
					; grab all but PCM/DRQ/MONO/DIRECTION
	or	al,ah			; merge the two states
	xor	al,bCCenapcm		; disable the PCM bit
	out	dx,al			; send to the hardware
        jmp short $+2
	xor	al,bCCenapcm		; enable the PCM bit
	out	dx,al			; send to the hardware
        mov     [es:_di+MVState._crosschannel],al ; and save the new state
;
; Setup the audio filter sample bits
;
        mov     al,[es:_di+MVState._audiofilt]
	or	al,(bFIsrate+bFIsbuff)	; enable the sample count/buff counters
        mov     _dx,AUDIOFILT
        xor     _dx,[mvTranslateCode]  ; xlate the board address
	out	dx,al
        mov     [es:_di+MVState._audiofilt],al

        mov     al,[es:_di+MVState._crosschannel] ; get the state
        mov     _dx,CROSSCHANNEL
        xor     _dx,[mvTranslateCode]  ; xlate the board address
	or	al,bCCdrq		; set the DRQ bit to control it
	out	dx,al
        mov     [es:_di+MVState._crosschannel],al ; and save the new state

@@ok:
        xor     _ax,_ax                 ; success
        jmp     @@done

@@err:
        ERROR   ID_pasInit

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    int pasClose()
;*
;* Description: Uninitializes Pro Audio Spectrum
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    pasClose        _funct
USES    es,_di,_bx

        les     _di,[mvhwShadowPointer]
;
; clear the audio filter sample bits
;
        mov     _dx,AUDIOFILT
        xor     _dx,[mvTranslateCode]     ; xlate the board address
	cli			; drop dead...
        mov     al,[es:_di+MVState._audiofilt]    ; get the state
	and	al,not (bFIsrate+bFIsbuff) ; flush the sample timer bits
        mov     [es:_di+MVState._audiofilt],al    ; save the new state
	out	dx,al

	test	[pasMode],sd16bit
	jz	@@no16bit

;
; disable the 16 bit stuff
;
        mov     _dx,SYSCONFIG2
        xor     _dx,[mvTranslateCode]     ; xlate the board address
	in	al,dx
	and	al,not bSC216bit+bSC212bit ; flush the 16 bit stuff
	out	dx,al
;
@@no16bit:

;
; clear the appropriate Interrupt Control Register bit
;
	mov	ah,bICsampbuff
	and	ah,bICsamprate+bICsampbuff
	not	ah
        mov     _dx,INTRCTLR
        xor     _dx,[mvTranslateCode]    ; xlate the board address
	in	al,dx
	and	al,ah			; kill sample timer interrupts
	out	dx,al
        mov     [es:_di+MVState._intrctlr],al

        mov     al,[es:_di+MVState._crosschannel] ; get the state
        mov     _dx,CROSSCHANNEL
        xor     _dx,[mvTranslateCode]  ; xlate the board address
	and	al,not bCCdrq		; clear the DRQ bit
	and	al,not bCCenapcm	; clear the PCM enable bit
	or	al,bCCdac
	out	dx,al

        mov     [es:_di+MVState._crosschannel],al ; and save the new state

        ; Take care of common uninitialization for all mixing Sound Devices:
        push    es
        call    mixsdClose
        pop     es
        test    _ax,_ax
        jnz     @@err

IFDEF __DPMI__
        ; Deallocate descriptor:
        call    dpmiFreeDescriptor LANG, [_int mvhwShadowPointer+INTSIZE]
        test    _ax,_ax
        jnz     @@err

@@nodesc:
ENDIF
        xor     _ax,_ax
        jmp     @@done

@@err:
        ERROR   ID_pasClose

@@done:
	ret
ENDP


;* $Log: pas.asm,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/08/04 11:32:25  pekangas
;* All functions now preserve _bx
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*


END