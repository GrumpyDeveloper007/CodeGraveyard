;*      TIMER.ASM
;*
;* TempoTimer
;*
;* $Id: timer.asm,v 1.2 1997/01/16 18:41:59 pekangas Exp $
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
INCLUDE "mglobals.inc"
INCLUDE "errors.inc"
INCLUDE "timer.inc"
IFNDEF NOEMS
INCLUDE "ems.inc"
ENDIF
INCLUDE "sdevice.inc"

;TIMERBORDERS=1

MAXPLAYERS = 16                         ; maximum number of music players

NTPRATE = 100                           ; non-tempoPolling SoundDevice
					; interrupt rate if not synchronized
					; to screen (in Hz)

IFDEF __32__
FRAMETIME = 950
ELSE
FRAMETIME = 965 		; Time between two interrupts is 96.5%
				; of total frame time - the interrupt comes
				; somewhat _before_ the Vertical Retrace
				; actually starts.
ENDIF


ENUM    tmrStates \                     ; timer state
        tmrSystem, \                    ; system timer
        tmrPlayer, \                    ; music player timer
        tmrScreen                       ; Vertical Retrace timer



;/***************************************************************************\
;*
;* Macro:       SetBorder color
;*
;* Description: Sets the border color if TIMERBORDERS is defined
;*
;* Input:       color           border color
;*
;* Destroys:    none
;*
;\***************************************************************************/

MACRO   SetBorder       color
IFDEF TIMERBORDERS
        push    _dx _ax
	mov	dx,03DAh
	in	al,dx
	mov	dx,03C0h
	mov	al,31h
	out	dx,al
	mov	al,color
	out	dx,al
        pop     _ax _dx
ENDIF
ENDM




;/***************************************************************************\
;*
;* Macro:       WaitNextVR
;*
;* Description: Waits for next Vertical Retrace
;*
;\***************************************************************************/

MACRO   WaitNextVR
LOCAL	w1, w2

	mov	dx,03DAh
w1:	in	al,dx		; wait for a non-retrace period
	test	al,8
	jnz	w1

w2:	in	al,dx
	test	al,8		; wait for retrace
	jz	w2
ENDM




DATASEG


D_farptr systemTimer                    ; pointer to system timer routine
sysTmrCount	DD	?		; system timer counter

playCount	DD	?		; player timer counter
playTmrCount	DD	?		; initial value for player timer count
D_ptr sdev                              ; pointer to Sound Device

musicPlayers    DD      MAXPLAYERS DUP(?)       ; music player routines

D_int playSD                            ; 1 if sound should be played
D_int plTimer                           ; 1 if player-timer is active
D_int plError                           ; music playing error code
D_int plCallMP                          ; call music player?

scrCount	DD	?		; Retrace timer counter
scrTmrCount	DD	?		; initial value for VR timer counter
scrPVCount	DD	?		; timer count for time before Retrace
D_ptr preVR                             ; pre-VR function
D_ptr immVR                             ; immVR()
D_ptr inVR                              ; inVR()
D_int scrSync                           ; 1 if timer is synchronized to screen
D_int scrTimer                          ; 1 if screen-timer is active
D_int scrPlayer                         ; synchronize player to screen?

D_int tmrState                          ; timer state

D_int sysTimer                          ; system timer active?

IFNDEF __PASCAL__
D_int tmrActive                         ; running in timer interrupt? (global)
ENDIF




CODESEG



;/***************************************************************************\
;*
;* Function:	setCount
;*
;* Description: Set timer count and restart timer
;*
;* Input:       bx              timer count
;*
;* Destroys:	al
;*
;\***************************************************************************/

PROC NOLANGUAGE setCount     NEAR	; set timer counter and restart

	mov	al,30h			; counter mode 0 - interrupt on
	out	43h,al			; terminal count
	mov	al,bl
	out	40h,al			; set timer count and restart timer
	mov	al,bh
	out	40h,al

	ret
ENDP




;/***************************************************************************\
;*
;* Function:	nextTimer
;*
;* Description: Prepare for next timer interrupt
;*
;* Destroys:    eax, ebx
;*
;\***************************************************************************/

PROC NOLANGUAGE nextTimer    NEAR

	cmp	[scrSync],1		; is timer synchronized to screen?
	jne	@@noscr

        cmp     [playSD],1              ; should sound be played?
	jne	@@scr

	mov	ebx,[playCount] 	; player timer count
	or	ebx,ebx 		; negative
	jns	@@nos1
	mov	ebx,10			; make sure count is not negative
	mov	[playCount],10
	jmp	@@setpl
@@nos1:
	cmp	ebx,[scrCount]		; will player timer come before scr?
	jl	@@setpl

@@scr:	mov	ebx,[scrCount]		; screen timer count
	or	ebx,ebx 		; negative?
	jns	@@nos2
	mov	ebx,10			; make sure count is not negative
	mov	[scrCount],10
@@nos2:
	mov	[tmrState],tmrScreen	; next interrupt will be screen timer
	call	setCount		; set count and restart timer
	jmp	@@done


@@setpl:
	mov	[tmrState],tmrPlayer	; next interrupt will be player
	call	setCount		; set count and restart
	jmp	@@done


@@noscr:
        cmp     [playSD],1              ; should sound be played?
	jne	@@sys

	mov	[tmrState],tmrPlayer
	mov	ebx,[playCount] 	; player timer count
	or	ebx,ebx 		; negative?
	jns	@@1

	mov	ebx,10			; make sure count is not negative
	mov	[playCount],10

@@1:	call	setCount
	jmp	@@done


@@sys:					; system timer only
	mov	[tmrState],tmrSystem	; next int is system timer
        xor     _bx,_bx
	call	setCount		; set system timer count

@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    timer
;*
;* Description: timer interrupt handler
;*
;\***************************************************************************/

PROC NOLANGUAGE timer			; timer interrupt

	pushad
	push	ds es fs gs

        SetBorder 15

        mov     ax,DGROUP
	mov	ds,ax			; set valid values to segment
        mov     es,ax                   ; registers

        mov     [tmrActive],1           ; in timer interrupt

	cmp	[tmrState],tmrScreen	; screen timer interrupt?
	je	@@scrtmr
	cmp	[tmrState],tmrSystem	; system timer only?
	je	@@systmr
	cmp	[tmrState],tmrPlayer	; player timer?
	je	@@plrtmr
	jmp	@@systmr		; do _something_


@@scrtmr:
	cli				; no interrupts here!

	SetBorder 14

	cmp	[scrTimer],1		; is screen timer already active?
	jne	@@scrnot

	; screen timer already active - PANIC!

	mov	eax,[scrCount]
	add	eax,[scrPVCount]
	sub	[playCount],eax 	; update player timer counter
	add	[sysTmrCount],eax	; update system timer counter

	mov	eax,[scrTmrCount]	; reset screen timer counter
	mov	[scrCount],eax

	call	nextTimer		; next timer interrupt

	mov	al,20h			; send End Of Interrupt
	out	20h,al
	sti				; enable interrupts
	jmp	@@done			; stop processing this interrupt


@@scrnot:
	cmp	[scrSync],1		; should timer be synchronized to
	jne	@@chksys		; screen?

	mov	[scrTimer],1		; screen-timer is now active

	mov	dx,03DAh
@@wnvr: in	al,dx			; wait until we are _not_ in a
	test	al,8			; retrace (just to make sure...)
	jnz	@@wnvr

	cmp	[preVR],0
        je      @@npvr                  ; call preVR() if pointer is not
        call    [_ptr preVR] LANG       ; NULL
@@npvr:

	SetBorder 1
	mov	eax,[scrCount]
	add	eax,[scrPVCount]	; update timer counters
	add	[sysTmrCount],eax

	cmp	[scrPlayer],1		; synchronize player to screen?
	je	@@syncpl
	sub	[playCount],eax 	; no, update count
	jmp	@@scd

@@syncpl:
	mov	eax,[playTmrCount]	; synchronize player
	mov	[playCount],eax

@@scd:
	mov	eax,[scrTmrCount]	; reset screen-interrupt count
	mov	[scrCount],eax

	mov	dx,03DAh
@@wvr:	in	al,dx			; wait for the retrace
	test	al,8
	jz	@@wvr

        cmp     [immVR],0
        je      @@nivr                  ; call immVR() if pointer is not
        call    [_ptr immVR] LANG       ; NULL

@@nivr:
	SetBorder 2

	call	nextTimer		; next timer iterrupt

	mov	[scrTimer],0		; screen-timer (almost) finished

	SetBorder 4

	sti				; enable interrupts now

	mov	al,20h			; send End Of Interrupt to Interrupt
	out	20h,al			; Controller


        cmp     [inVR],0
        je      @@nvr                   ; call inVR() if pointer is not NULL
        call    [_ptr inVR] LANG

@@nvr:
	SetBorder 0
	mov	[scrTimer],0
	jmp	@@chksys		; check if system timer should be
					; called





@@plrtmr:
        ;SetBorder 7
	cmp	[plTimer],1		; is player timer already active?
	jne	@@plnot 		; if not, it's OK to continue

	; player timer already active - PANIC!

	mov	eax,[playCount] 	; previous player timer count
	sub	[scrCount],eax		; update screen timer count
	add	[sysTmrCount],eax	; and system timer count
	mov	eax,[playTmrCount]	; reset player timer count
	mov	[playCount],eax
	call	nextTimer		; next timer interrupt (hopefully
					; not player anymore...)
	sti				; enable interrupts
	mov	al,20h			; send End Of Interrupt
	out	20h,al
	jmp	@@done			; quit interrupt - no playing until
					; the previous player interrupt has
					; finished

@@plnot:
        mov     [plTimer],1             ; player timer is active
	mov	eax,[playCount] 	; player timer count
	or	eax,eax
	js	@@pn1
	sub	[scrCount],eax		; update screen timer count
	add	[sysTmrCount],eax	; increase system timer count
@@pn1:
	cmp	[scrPlayer],1		; synchronize player to screen?
	je	@@pspl
	mov	ebx,[playTmrCount]	; new player timer count
	mov	[playCount],ebx 	; set player timer count to counter
	jmp	@@pnt
@@pspl:
        mov     [playCount],0FFFFh      ; make sure that next interrupt will
@@pnt:					; be screen, not timer

	call	nextTimer		; next timer interrupt

	sti				; enable interrupts
	mov	al,20h			; send End Of Interrupt to Interrupt
	out	20h,al			; Controller

        cmp     [playSD],1              ; should music be played?
	je	@@playmus

	mov	[plTimer],0		; player timer not active
	jmp	@@chksys		; call system timer if appropriate

@@playmus:
        cmp     [plError],0             ; error during playing?
        jne     @@pl1

	mov	edi,[playTmrCount]	; store player timer count

        ; Start playing loop: (usually updates DMA position)
        LOADPTR es,_si,[sdev]
        call    [_essi+SoundDevice.StartPlay] LANG
        test    _ax,_ax
        jnz     @@plerr

        SetBorder 14

IFNDEF NOEMS
        cmp     [mUseEMS],1             ; is EMS used?
	jne	@@play
	call	emsSave LANG		; save EMS mappings
        test    _ax,_ax
        jnz     @@plerr

        call    emsSafe LANG            ; set EMS "safe"-flag on
        test    _ax,_ax
        jnz     @@plerr
ENDIF

@@play:
	SetBorder 15
        ; Update Sound Device registers / mix data:
        LOADPTR es,_si,[sdev]
IFDEF __16__
        call    [_essi+SoundDevice.Play] LANG, seg plCallMP offset plCallMP
ELSE
        call    [_essi+SoundDevice.Play] LANG, ptr_to plCallMP
ENDIF
	SetBorder 2
        test    _ax,_ax
        jnz     @@plerr

        cmp     [plCallMP],1            ; should music player be called?
        jne     @@noplay

        lea     _si,[musicPlayers]      ; point ds:si to music players

@@playmusic:
        cmp     [_ptr _si],0            ; is current music player zero?
        je      @@nothispl              ; if is, do not play

        call    [_ptr _si] LANG         ; play music
        test    _ax,_ax
        jnz     @@plerr

@@nothispl:
        add     _si,4
        cmp     _si,(offset musicPlayers) + 4*MAXPLAYERS
        jb      @@playmusic

        LOADPTR es,_si,[sdev]
        cmp     [_essi+SoundDevice.tempoPoll],0         ; poll again if
	je	@@play			; tempoPoll flag is zero

@@noplay:
IFNDEF NOEMS
        cmp     [mUseEMS],1
	jne	@@nems1
	SetBorder 14
	call	emsStopSafe LANG
        test    _ax,_ax
        jnz     @@plerr

	call	emsRestore LANG
        test    _ax,_ax
        jnz     @@plerr
ENDIF

@@nems1:
	SetBorder 0

        LOADPTR es,_si,[sdev]
        cmp     [_essi+SoundDevice.tempoPoll],1         ; no need to change
	jne	@@pl1			; timer rate if tempoPoll is zero.

	cmp	[playTmrCount],edi	; has player timer count been changed?
	je	@@pl1

        mov     ebx,[playTmrCount]
        mov     [playCount],ebx         ; set new player timer count
        cmp     [tmrState],tmrPlayer    ; would next interrupt be player?
        jne     @@pl1
        call    nextTimer               ; if so, set new count

        jmp     @@pl1

@@plerr:
        mov     [plError],_ax           ; playing error

@@pl1:	mov	[plTimer],0		; player timer finished


@@chksys:				; check system timer
	sti
	cmp	[sysTmrCount],10000h	; should system timer be called?
	jb	@@done

	mov	eax,[sysTmrCount]
	sub	eax,10000h		; substract 65536 from system timer
	or	eax,eax 		; count. Is the result negative?
	jns	@@stcok 		; (SHOULD not be)
	xor	eax,eax 		; negative - set to zero
@@stcok:
	mov	[sysTmrCount],eax	; new timer count
IFDEF __16__
        pushf
ELSE
        pushfd
ENDIF
        call    [_farptr systemTimer]   ; call system timer
	jmp	@@chksys



@@systmr:				; system timer only
	sti
        xor     _bx,_bx                 ; set new timer count and restart
	call	setCount
IFDEF __16__
        pushf
ELSE
        pushfd
ENDIF
        call    [_farptr systemTimer]   ; call system timer


@@done:
        mov     [tmrActive],0           ; not in timer interrupt
        SetBorder 0
        pop     gs fs es ds             ; restore registers
	popad
        nop                             ; avoid the popad-bug...
IFDEF __16__
	iret
ELSE
        iretd
ENDIF
ENDP




;/***************************************************************************\
;*
;* Function:     int tmrGetScrSync(unsigned *scrSync);
;*
;* Description:  Calculates the screen synchronization value for timer
;*
;* Input:        unsigned *scrSync       pointer to screen synchronization
;*                                       value
;*
;* Returns:      MIDAS error code.
;*               Screen syncronization value used with tmrSyncScr() is stored
;*               in *scrSync.
;*
;\***************************************************************************/

PROC    tmrGetScrSync   _funct  PscrSync : _ptr
LOCAL   tmrVal : _int

	cli				; disable interrupts for maximum
					; accuracy
@@read:
        xor     _ax,_ax
	WaitNextVR			; wait for next Vertical Retrace

	mov	al,36h
	out	43h,al
	xor	al,al			; reset the timer
	out	40h,al
	out	40h,al


	WaitNextVR			; wait for next Vertical Retrace

	xor	al,al
	out	43h,al
	in	al,40h
	mov	ah,al
	in	al,40h			; read timer count - time between
	xchg	al,ah			; two Vertical Retraces
        neg     ax
        mov     [tmrVal],_ax

        xor     _ax,_ax
	WaitNextVR			; wait for next Vertical Retrace

	mov	al,36h
	out	43h,al
	xor	al,al			; reset timer again
	out	40h,al
	out	40h,al


	WaitNextVR			; wait...

	xor	al,al
	out	43h,al
	in	al,40h
	mov	ah,al			; and read the timer count again
	in	al,40h
	xchg	al,ah
        neg     ax

        mov     _dx,_ax

        sub     _dx,[tmrVal]
        cmp     _dx,2                   ; If the difference between the two
	jg	@@read			; values read was >2, read again.
        cmp     _dx,-2
	jl	@@read

        sti                             ; enable interrupts

        LOADPTR es,_bx,[PscrSync]       ; store time in *scrSync
        mov     [_esbx],_ax

        xor     _ax,_ax                 ; success

	ret
ENDP




;/***************************************************************************\
;*
;* Function:     int tmrInit(void);
;*
;* Description:  Initializes TempoTimer.
;*
;* Returns:      MIDAS error code
;*
;\***************************************************************************/

PROC    tmrInit         _funct

	mov	[tmrState],tmrSystem	; only system timer now
        mov     [playSD],0
	mov	[scrSync],0
	mov	[plTimer],0
	mov	[scrTimer],0
	mov	[sysTmrCount],0
	mov	[sysTimer],0
        mov     [plError],0

IFDEF __32__
        push    es
ENDIF

	mov	ax,3508h
	int	21h
IFDEF __16__
        mov     [word systemTimer],bx   ; save system timer interrupt
	mov	[word systemTimer+2],es
ELSE
        mov     [dword systemTimer],ebx ; save system timer interrupt
        mov     [word systemTimer+4],es
ENDIF

IFDEF __32__
        pop     es
ENDIF

	push	ds
;        mov     ax,seg timer
        mov     ax,cs
	mov	ds,ax			; set new timer interrupt
        mov     _dx,offset timer
	mov	ax,2508h
	int	21h
	pop	ds

        xor     _bx,_bx                 ; set timer count and restart
	call	setCount

        SetBorder 2

        xor     _ax,_ax                 ; success
	ret
ENDP




;/***************************************************************************\
;*
;* Function:     int tmrClose(void);
;*
;* Description:  Uninitializes TempoTimer. MUST be called if and ONLY if
;*               tmrInit() has been called.
;*
;* Returns:      MIDAS error code
;*
;\***************************************************************************/

PROC    tmrClose        _funct

	mov	al,36h			; DOS default timer mode
	out	43h,al
	xor	al,al			; set timer count to 65536 - 18.2Hz
	out	40h,al			; (DOS default)
	out	40h,al

	push	ds
	mov	ax,2508h
        lds     _dx,[systemTimer]       ; restore system timer interrupt
	int	21h
	pop	ds

	mov	al,36h			; DOS default timer mode
	out	43h,al
	xor	al,al			; set timer again for safety
	out	40h,al
	out	40h,al

        xor     _ax,_ax                 ; success
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    int tmrPlaySD(SoundDevice *SD);
;*
;* Description: Starts playing sound with a Sound Device ie. calling its
;*              Play() function in the update rate, which is set to
;*              50Hz.
;*
;* Input:       SoundDevice *SD         Sound Device that will be used
;*
;* Returns:     MIDAS error code.
;*
;\***************************************************************************/

PROC    tmrPlaySD       _funct  SD : _ptr
USES    _di

        mov     eax,[SD]                ; save Sound Device pointer
	mov	[sdev],eax

        lea     _di,[musicPlayers]
        mov     ax,ds
        mov     es,ax                   ; reset music player pointers
        xor     al,al                   ; to NULL - no music players
        mov     _cx,MAXPLAYERS * PTRSIZE
        cld
        rep     stosb

	cli				; disable interrupts for a while

        LOADPTR es,_di,[sdev]
        cmp     [_esdi+SoundDevice.tempoPoll],1
	je	@@tempo 		; use tempo-polling?

	cmp	[scrSync],0		; synchronize to screen?
	je	@@noss
	mov	eax,25			; yes - synchronize also player
	mul	[scrTmrCount]		; interrupt count = 1/4 of screen
	mov	ebx,100 		; interrupt count (player interrupt
	div	ebx			; will come somewhat after Vertical
	mov	ebx,eax 		; Retrace end)
	mov	[scrPlayer],1		; synchronize player to screen
	jmp	@@1

@@noss:
	mov	ebx,1193180/NTPRATE	; set polling rate to NTPRATE Hz
					; (default 100Hz)
	mov	[scrPlayer],0		; don't synchronize to screen
	jmp	@@1
@@tempo:
        mov     ebx,1193180/50          ; tempo-polling - set update rate to
        mov     [scrPlayer],0           ; 50Hz, don't synchronize to screen
@@1:
	mov	[playTmrCount],ebx	; player timer count
	mov	[playCount],ebx
        mov     [playSD],1              ; playing sound
        mov     [plTimer],0             ; player timer not active
        mov     [plError],0             ; no error during playing

	cmp	[tmrState],tmrSystem	; is only system timer running?
	jne	@@noset 		; if not, don't set count and restart

	mov	[tmrState],tmrPlayer	; next interrupt will be player int
	call	setCount
	mov	[sysTmrCount],0

@@noset:
	sti

        SetBorder 3

        xor     _ax,_ax                 ; success
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    int tmrStopSD(void);
;*
;* Description: Stops playing sound with the Sound Device.
;*
;* Returns:     MIDAS error code.
;*
;\***************************************************************************/

PROC    tmrStopSD       _funct

	cli

        mov     [playSD],0
	cmp	[scrSync],0		; is timer synchronized to screen?
	jne	@@noset 		; if is, don't force system timer

	mov	[tmrState],tmrSystem	; only system timer now
        xor     _bx,_bx
	call	setCount

@@noset:
	sti

        xor     _ax,_ax                 ; success
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    int tmrPlayMusic(void *play, int *playerNum);
;*
;* Description: Starts playing music with the timer.
;*
;* Input:       void *play              Pointer to music playing function.
;*                                      Must return MIDAS error codes
;*              int *playerNum          Pointer to player number, used
;*                                      for stopping music
;*
;* Returns:     MIDAS error code. Player number is written to *playerNum.
;*
;* Notes:       There can be a maximum of 16 music players active at the
;*              same time.
;*
;\****************************************************************************/

PROC    tmrPlayMusic    _funct  play : _ptr, playerNum : _ptr

        mov     eax,[play]
        lea     _bx,[musicPlayers]      ; point bx to music player ptrs
        xor     _cx,_cx                 ; cx = player number

        ; Find free music player slot or return errOutOfResources if none
        ; left:
@@search:
        cmp     [_ptr _bx],0            ; is current player slot free?
        je      @@free
        add     _bx,PTRSIZE
        inc     _cx                     ; next player number
        cmp     _cx,MAXPLAYERS          ; past the limit?
        jb      @@search

        mov     _ax,errOutOfResources
        jmp     @@err

@@free:
        mov     [_bx],eax               ; free player number found (in cx)
        LOADPTR es,_bx,[playerNum]      ; write player number to
        mov     [_esbx],_cx             ; *playerNum

        xor     _ax,_ax
        jmp     @@done

@@err:
        ERROR   ID_tmrPlayMusic

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int tmrStopMusic(int playerNum);
;*
;* Description: Stops playing music with the timer.
;*
;* Input:       int playerNum           Number of player to be stopped.
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    tmrStopMusic    _funct  playerNum : _int

        mov     _bx,[playerNum]         ; write NULL to player pointer to
        shl     _bx,2                   ; mark it free
        mov     [_ptr musicPlayers+_bx],0

        xor     _ax,_ax

        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int tmrSyncScr(unsigned sync, void (*preVR)(),
;*                  void (*immVR)(), void (*inVR)());
;*
;* Description: Synchronizes the timer to screen refresh.
;*
;* Input:       unsigned sync           Screen synchronization value returned
;*                                      by tmrGetScrSync().
;*              void (*preVR)()         Pointer to the routine that will be
;*                                      called BEFORE Vertical Retrace
;*              void (*immVR)()         Pointer to the routine that will be
;*                                      called immediately after Vertical
;*                                      Retrace starts
;*              void (*inVR)()          Pointer to the routine that will be
;*                                      called some time during Vertical
;*                                      Retrace
;*
;* Returns:     MIDAS error code
;*
;* Notes:       preVR() and immVR() functions must be as short as possible
;*              and do nothing else than update counters or set some VGA
;*              registers to avoid timer synchronization problems. inVR()
;*              can take a longer time and can be used for, for example,
;*              setting the palette.
;*
;*              Remember to use the correct calling convention for the xxVR()
;*              routines! (pascal for Pascal programs, cdecl otherwise).
;*
;\***************************************************************************/

PROC    tmrSyncScr      _funct  sync : _int, PpreVR : _ptr, PimmVR : _ptr, \
                                PinVR : _ptr
USES    _si

	cli				; make sure we won't be disturbed...

        mov     eax,[PpreVR]
	mov	[preVR],eax
        mov     eax,[PimmVR]            ; store function pointers
        mov     [immVR],eax
        mov     eax,[PinVR]
        mov     [inVR],eax

	mov	[scrSync],1		; synchronize to screen
	mov	[scrTimer],0		; screen timer is not active

IFDEF __16__
        xor     eax,eax
ENDIF
        mov     _ax,FRAMETIME
	mul	[sync]			; time between two screen interrupts
        mov     _bx,1000                ; is FRAMETIME/10 % of total frame
        div     _bx                     ; time

	shr	eax,1
	mov	[scrCount],eax		; screen timer counter
	mov	[scrTmrCount],eax
	mov	ebx,eax

IFDEF __16__
        xor     eax,eax
ENDIF
        mov     _ax,[sync]
	shr	eax,1			; scrPVCount = timer count between
	sub	eax,ebx 		; interrupt and start of Vertical
	mov	[scrPVCount],eax	; Retrace

	mov	[tmrState],tmrScreen	; next timer interrupt is screen timer
	WaitNextVR			; wait for next retrace
	call	setCount		; set count and restart timer

	sti


        cmp     [playSD],0              ; is sound being played?
	je	@@nomsync

        LOADPTR es,_si,[sdev]                   ; do not synchronize player
        cmp     [_essi+SoundDevice.tempoPoll],1 ; interrupt to screen if
	je	@@nomsync			; tempo-polling is used

	mov	eax,25
	mul	[scrTmrCount]		; interrupt count = 1/4 of screen
	mov	ebx,100 		; interrupt count (player interrupt
	div	ebx			; will come somewhat after Vertical
	mov	ebx,eax 		; Retrace end)
	mov	[scrPlayer],1		; synchronize player to screen

	mov	[playTmrCount],ebx	; player timer count
	mov	[playCount],ebx

@@nomsync:
        xor     _ax,_ax                 ; success
	ret
ENDP




;/***************************************************************************\
;*
;* Function:     int tmrStopScrSync(void);
;*
;* Description:  Stops synchronizing the timer to the screen.
;*
;* Returns:      MIDAS error code
;*
;\***************************************************************************/

PROC    tmrStopScrSync  _funct

	cli

	cmp	[scrPlayer],1		; is player being synchronized to
	jne	@@nospl 		; screen?

	mov	ebx,1193180/NTPRATE	; set polling rate to NTPRATE Hz
					; (default 100Hz)
	mov	[playTmrCount],ebx	; player timer count
	mov	[playCount],ebx
	mov	[scrPlayer],0		; don't synchronize to screen

@@nospl:
	mov	[scrSync],0		; no screen synchronization
	mov	[scrTimer],0		; screen timer is not active
	call	nextTimer		; set timer count and restart

	sti

        xor     _ax,_ax                 ; success
	ret
ENDP




;/***************************************************************************\
;*
;* Function:     int tmrSetUpdRate(unsigned updRate);
;*
;* Description:  Sets the timer update rate, ie. the rate at which the music
;*               playing routine is called
;*
;* Input:        unsigned updRate       updating rate, in 100*Hz (5000=50Hz)
;*
;* Returns:      MIDAS error code
;*
;\***************************************************************************/

PROC    tmrSetUpdRate   _funct  updRate : _int

        LOADPTR es,_bx,[sdev]
        cmp     [_esbx+SoundDevice.tempoPoll],0         ; don't change rate
        je      @@done                                  ; if tempoPoll == 0

        mov     eax,119318000
        xor     edx,edx                 ; eax = new timer count
IFDEF __16__
        xor     ebx,ebx
ENDIF
        mov     _bx,[updRate]
        div     ebx
        mov     [playTmrCount],eax

@@done:
        xor     _ax,_ax                 ; success
	ret
ENDP


;* $Log: timer.asm,v $
;* Revision 1.2  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*

END