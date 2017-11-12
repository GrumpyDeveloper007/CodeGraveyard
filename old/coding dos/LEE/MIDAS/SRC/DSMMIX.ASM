;*      DSMMIX.ASM
;*
;* Digital Sound Mixer low-level mixing routines
;*
;* $Id: dsmmix.asm,v 1.9 1997/01/16 18:41:59 pekangas Exp $
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

; Possibly environment dependent code is marked with *!!*


INCLUDE "lang.inc"
INCLUDE "errors.inc"
INCLUDE "sdevice.inc"
INCLUDE "dsm.inc"
INCLUDE "mglobals.inc"

IFNDEF NOEMS
INCLUDE "ems.inc"
ENDIF




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



;/***************************************************************************\
;*
;* Macro:       MixLoop         mname, mixLp, DIinc, counter
;*
;* Description: Generates code for inner mixing loop, REPeaTed 16 times.
;*              Mixing is started with a near call to some label in the
;*              mixing loop and ends with a near return
;*
;* Input:	mname		mixing loop name (ie. m8mna)
;*		mixLp		macro that contains code for mixing loop
;*              DIinc           _di increment after each loop (16 times)
;*		counter 	loop counter (ie. cx)
;*
;\***************************************************************************/

MACRO   MixLoop         mname, mixLp, DIinc, counter
LOCAL	lp

LABEL   &mname  _int
JmpTable	&mname, 17

lp:
num = 0
REPT	16
	NumLabel &mname, %num
	&mixLp %num
	num = num + 1
ENDM
	NumLabel &mname, %num

IF DIinc NE 0
        add     di,DIinc                ; mix next DIInc bytes
ENDIF
	dec	counter
	jnz	lp
	retn

ENDM	MixLoop





DATASEG

; Mixing routine temporary variables: (in data segment for easier access and
; speed)

D_int   lim1 ;FIXME
D_int   lim2

D_ptr   sample                  ; pointer to beginning of sample data
D_ptr   chan                    ; pointer to current channel struct
D_int   lpStart                 ; current loop start
D_int   lpEnd                   ; current loop end
D_int   lpType                  ; current loop type
D_int   direction               ; current playing direction
D_int   released                ; sound released flag - 1 if sound has been
                                ; released but first loop is still being
                                ; played
D_int   ALEChange               ; 1 if Amiga Loop Emulation sample change
                                ; is necessary when sample or loop ends
D_int   mixLeft                 ; number of elements left to mix
D_ptr   dest                    ; mixing destination pointer
D_long  incr                    ; sample playing position increment
D_long  maxMix                  ; maximum number of sample bytes that may be
                                ; mixed during this mixing process
D_int   position                ; sample playing position whole part
D_int   posLow                  ; sample playing position fractional part
                                ; (only lower 16 bits are used)
D_ptr   mixRout                 ; pointer to mixing routine
IFDEF __16__
D_int   prevPos                 ; position before mixing (required for
                                ; checking for bidirectional loop start in
                                ; 16-bit modes under some circumstances)
ENDIF
D_int   mixLoop                 ; pointer to mixing loop start

IFDEF __16__
D_int   mixCount                ; mixing counter for 16-bit mixing loops
ENDIF

D_int   panning                 ; current channel panning position
D_int   fracIncr                ; mixing position fraction increment in some
                                ; mixing routines
D_int   chanNum                 ; channel number
D_ptr   loopCallback            ; loop callback function

leftVolume      DB      ?       ; left channel volume in smooth panning
rightVolume     DB      ?       ; right channel volume in smooth panning



CODESEG




;/***************************************************************************\
;*
;* Function:    int dsmMix(unsigned channel, void *mixRoutine,
;*                  unsigned volume, unsigned numElems);
;*
;* Description: Mixes data for one channel. Used internally by dsmMixData().
;*
;* Input:       unsigned channel        channel number
;*              void *mixRoutine        pointer to low-level mixing routine
;*              unsigned volume         actual playing volume (volume in
;*                                      channel structure is ignored)
;*              unsigned numElems       number of elements to mix (see
;*                                      dsmMixData())
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    dsmMix  _funct          channel : _int, mixRoutine : _ptr, \
                                volume : _int, numElems : _int
USES    _si,_di,_bx

        cld

        mov     ax,ds
IFDEF __32__
        mov     es,ax
ENDIF
IFDEF __16__
        mov     fs,ax                   ; fs will be used to access variables
ENDIF                                   ; in data segment when ds is destroyed

        mov     _ax,[numElems]          ; mixLeft = number of elements left
        mov     [mixLeft],_ax           ; to mix

        mov     _ax,[channel]           ; make sure we have channel number
        mov     [chanNum],_ax           ; always accessable

        ; Set dest to current mixing position in buffer:
        COPYPTR [dest],[dsmMixBuffer]

        ; Point mixRout to mixing routine:
        COPYPTR [mixRout],[mixRoutine]

        ; Point _gsbx and chan to current channel structure:
        LOADPTR gs,_bx,[dsmChannels]
        imul    _ax,[channel],SIZE dsmChannel
        add     _bx,_ax
        mov     [_int chan],_bx
IFDEF __16__
        ;*!!*
        mov     [word chan+2],gs
ENDIF

        ; Copy loop callback pointer:
        mov     eax,[_gsbx+dsmChannel.loopCallback]
        mov     [loopCallback],eax

        ; Check that there is a sample:
        cmp     [_gsbx+dsmChannel.sampleType],smpNone
        je      @@nodata

        ; Store current playing direction in direction:
        mov     _ax,[_gsbx+dsmChannel.direction]
        mov     [direction],_ax

        ; Copy position whole and fractional parts to internal variables:
        mov     _ax,[_gsbx+dsmChannel.playPos]
        mov     [position],_ax
        mov     _ax,[_gsbx+dsmChannel.playPosLow]
        mov     [posLow],_ax

        ; Copy channel panning position
        mov     _ax,[_gsbx+dsmChannel.panning]
        mov     [panning],_ax

        ; Calculate sample position increment for each destination element:
        mov     eax,[_gsbx+dsmChannel.rate]     ; playing rate
        mov     edx,eax                 ; eax = sample pos increment =
        shl     eax,16                  ; rate / dsmMixRate
        shr     edx,16
IFDEF __16__
        xor     ecx,ecx
ENDIF
        mov     _cx,[dsmMixRate]        ; (16.16 bit fixed point number)
        div     ecx
	mov	[incr],eax		; store position increment

        ; Calculate maximum number of sample bytes that can be mixed during
        ; the whole mixing process for this channel (used to prevent divide
        ; overflows and speed up some processing):
IFDEF __16__
        xor     eax,eax
ENDIF
        mov     _ax,[numElems]          ; eax = number of elements
        mul     [incr]                  ; multiply with position increment
        shrd    eax,edx,16              ; convert to integer
        add     eax,2                   ; add two for safety and rounding
        mov     [maxMix],eax            ; margin


@@newsample:    ; ALE logic jumps here if sample is changed

        ; Check channel status:
        mov     _ax,[_gsbx+dsmChannel.status]
        cmp     _ax,dsmChanStopped      ; channel stopped?
        je      @@nodata                ; if yes, there is no data to mix
        cmp     _ax,dsmChanEnd          ; channel ended?
        je      @@nodata                ; if yes, there is no data to mix
        cmp     _ax,dsmChanPlaying      ; playing normally?
        je      @@playnorm              ; if yes, use first loop

        ; Channel sound has been released. Check if the first loop is still
        ; being played, and if so, mark playing released so that the loop will
        ; be changed when the end of the first loop is reached. Otherwise
        ; just use the second loop:
        cmp     [_gsbx+dsmChannel.loopNum],2
        je      @@loop2
        mov     [released],1            ; change loop when loop end is reached
        jmp     @@loop1                 ; use first loop

@@loop2:
        ; Use second loop:
        mov     _ax,[_gsbx+dsmChannel.loop2Start]
        mov     [lpStart],_ax
        mov     _ax,[_gsbx+dsmChannel.loop2End]
        mov     [lpEnd],_ax
        mov     _ax,[_gsbx+dsmChannel.loop2Type]
        mov     [lpType],_ax
        jmp     @@loopok1


@@playnorm:
        mov     [released],0            ; playing not released

@@loop1:
        ; Use first loop:
        mov     _ax,[_gsbx+dsmChannel.loop1Start]
        mov     [lpStart],_ax
        mov     _ax,[_gsbx+dsmChannel.loop1End]
        mov     [lpEnd],_ax
        mov     _ax,[_gsbx+dsmChannel.loop1Type]
        mov     [lpType],_ax

@@loopok1:
        ; Check if sample has been changed so that ALE sample changing logic
        ; may have to be used later (sample has been changed and both current
        ; and new samples have Amiga compatible looping):
        cmp     [_gsbx+dsmChannel.sampleChanged],0
        je      @@noalech
        cmp     [_gsbx+dsmChannel.loopMode],sdLoopAmiga
        je      @@1
        cmp     [_gsbx+dsmChannel.loopMode],sdLoopAmigaNone
        jne     @@noalech

@@1:
        ; Point _essi to new sample:
        LOADPTR es,_si,[dsmSamples]
        imul    _ax,[_gsbx+dsmChannel.sampleHandle],SIZE dsmSample
        add     _si,_ax
        cmp     [_essi+dsmSample.loopMode],sdLoopAmigaNone
        je      @@alech
        cmp     [_essi+dsmSample.loopMode],sdLoopAmiga
        jne     @@noalech

@@alech:
        ; Sample has been changed and both current and new sample have Amiga
        ; compatible looping - Amiga Loop Emulation sample change will occur
        ; if current sample ends or reaches loop end:
        mov     [ALEChange],1
        jmp     @@aleok1

@@noalech:
        ; Sample will not be changed:
        mov     [ALEChange],0

@@aleok1:
        ; Get sample start address:
        mov     edx,[ebx+dsmChannel.sample]

        ; We'll need to divide the sample start address by sample size to
        ; make sample start address and mixing position match:
        mov     _ax,[_gsbx+dsmChannel.sampleType]
        cmp     _ax,smp8bitStereo
        je      @@smp8bitStereo
        cmp     _ax,smp16bitMono
        je      @@smp16bitMono
        cmp     _ax,smp16bitStereo
        je      @@smp16bitStereo
        jmp     @@sampleok

@@smp8bitStereo:
@@smp16bitMono:
        shr     edx,1
        jmp     @@sampleok

@@smp16bitStereo:
        shr     edx,2

@@sampleok:
        mov     [sample],edx
        ; Loop sample:
@@loop:
        cmp     [mixLeft],0             ; better safe than sorry
        je      @@alldone

        ; Check if we are really playing a stream:
        cmp     [_gsbx+dsmChannel.sampleHandle],DSM_SMP_STREAM
        jne     @@notstream

IFDEF __16__
        xor     eax,eax
ENDIF
        ; Check if we would reach stream write position before the loop end:
        mov     _ax,[_gsbx+dsmChannel.streamWritePos]
        cmp     _ax,[position]
        jb      @@notstream             ; nope

        ; Check if we have any data in stream buffer:
        je      @@nodata                ; nothing to do - no data

        ; Calculate the number of sample bytes to write position:
        sub     _ax,[position]          ; _ax = number of sample bytes
        mov     edx,eax                 ; edx:eax = number of sample bytes in
        shr     edx,16                  ; 16.16 fixed point format
        shl     eax,16
IFDEF __16__
        xor     ecx,ecx
        mov     cx,[posLow]             ; substract position fractional part
        sub     eax,ecx
ELSE
        sub     eax,[posLow]
ENDIF
        sbb     edx,0

        jmp     @@loopset


@@notstream:
        ; Check current loop type:
        mov     _ax,[lpType]
        cmp     _ax,loopNone
        je      @@noloop
        cmp     _ax,loopUnidir
        je      @@unidir

        ; Bidirectional loop, check direction:
        cmp     [direction],-1
        je      @@bdback

        ; Bidirectional loop forwards - calculate number of sample bytes to
        ; loop end:
IFDEF __16__
        xor     eax,eax
ENDIF
        mov     _ax,[lpEnd]             ; _ax = number of sample bytes
        sub     _ax,[position]          ; before loop end
        mov     edx,eax                 ; edx:eax = number of sample bytes in
        shr     edx,16                  ; 16.16 fixed point format
        shl     eax,16
IFDEF __16__
        xor     ecx,ecx
        mov     cx,[posLow]             ; substract position fractional part
        sub     eax,ecx
ELSE
        sub     eax,[posLow]
ENDIF
        sbb     edx,0

        ; edx:eax now contains number of sample bytes to mix in 16.16
        ; fixed point format before loop end is reached
        jmp     @@loopset


@@bdback:
        ; Bidirectional loop backwards - calculate number of sample bytes to
        ; loop start:
IFDEF __16__
        xor     eax,eax
ENDIF
        mov     _ax,[position]          ; _ax = number of sample bytes before
        sub     _ax,[lpStart]           ; loop end
        mov     edx,eax                 ; edx:eax = number of sample bytes in
        shr     edx,16                  ; 16.16 fixed point format
        shl     eax,16
IFDEF __16__
        xor     ecx,ecx
        mov     cx,[posLow]             ; add position fractional part
        add     eax,ecx
ELSE
        add     eax,[posLow]
ENDIF
        adc     edx,0

        ; edx:eax now contains number of sample bytes to mix in 16.16
        ; fixed point format before loop end is reached
        jmp     @@loopset


@@unidir:
        ; Unidirectional loop - calculate number of sample bytes to loop end:
IFDEF __16__
        xor     eax,eax
ENDIF
        mov     _ax,[lpEnd]             ; _ax = number of sample bytes
        sub     _ax,[position]          ; before loop end
        mov     edx,eax                 ; edx:eax = number of sample bytes in
        shr     edx,16                  ; 16.16 fixed point format
        shl     eax,16
IFDEF __16__
        xor     ecx,ecx
        mov     cx,[posLow]             ; substract position fractional part
        sub     eax,ecx
ELSE
        sub     eax,[posLow]
ENDIF
        sbb     edx,0

        ; edx:eax now contains number of sample bytes to mix in 16.16
        ; fixed point format before loop end is reached
        jmp     @@loopset


@@noloop:
        ; No loop - calculate number of sample bytes to sample end:
IFDEF __16__
        xor     eax,eax
ENDIF
        mov     _ax,[_gsbx+dsmChannel.sampleLength]     ; _ax = number of
        sub     _ax,[position]          ; sample bytes before sampleloop end
        mov     edx,eax                 ; edx:eax = number of sample bytes in
        shr     edx,16                  ; 16.16 fixed point format
        shl     eax,16
IFDEF __16__
        xor     ecx,ecx
        mov     cx,[posLow]             ; substract position fractional part
        sub     eax,ecx
ELSE
        sub     eax,[posLow]
ENDIF
        sbb     edx,0


@@loopset:
        ; edx:eax now contains number of sample bytes to mix in 16.16
        ; fixed point format before loop end is reached

        ; Check if maxMix (maximum number of sample bytes that can be mixed
        ; now) is below calculated number of bytes. If so, mix all that is
        ; left and exit: (done to prevent divide overflows later)

        mov     ecx,[maxMix]            ; ecx = maximum number of sample bytes
        shr     ecx,16
        cmp     ecx,edx                 ; check high word of whole part
        jb      @@mixmax

        mov     ecx,[maxMix]
        shl     ecx,16
        cmp     ecx,eax                 ; check low word of whole part
        jb      @@mixmax


        ; Now calculate the number of destination elements the number of
        ; sample bytes in edx:eax corresponds to: (this still could overflow,
        ; but it only should happen with playing rates over 800kHz if tempo
        ; is above 31bpm or mixing buffers over 1/13th of a second in length)

        div     [incr]                  ; eax = edx:eax / increment
        test    edx,edx                 ; if modulus is not zero, one more
        jz      @@nomod                 ; element must be mixed to actually
        inc     eax                     ; reach loop end

@@nomod:
IFDEF __16__
        cmp     eax,0FFFFh              ; limit to 65535 elements (just to
        jb      @@eaxok                 ; make sure there is no unwanted
        mov     eax,0FFFFh              ; truncation)
@@eaxok:
ENDIF

        cmp     _ax,[mixLeft]           ; do not mix more elements than there
        jbe     @@mixlset               ; is left to do for this mixing
        mov     _ax,[mixLeft]           ; process
        jmp     @@mixlset


@@mixmax:
        ; The number of sample bytes to sample/loop end is less than the
        ; maximum number of sample bytes that can be mixed during the whole
        ; mixing process - do all remaining destination elements:
        mov     _ax,[mixLeft]

@@mixlset:
        ; eax = number of destination elements to mix
        sub     [mixLeft],_ax           ; decrease number of elements left

        cmp     [volume],0              ; is volume zero?
        je      @@zerovol               ; if so, just advance mixing position

        ; Call the actual low-level mixing routine:
        PUSHSEGREG gs
        push    _bx
        push    _bp

IFDEF __16__
        ; In 16-bit modes store position before mixing so that it can be used
        ; for checking for bidirectional loop start. This is necessary as the
        ; playing position can wrap if the loop start is at the very start of
        ; the sample and there would be no way of knowing if this happened.
        ; In 32-bit modes wrapping is also possible, but it would only cause
        ; problems with loops longer than 2 gigabytes.
        mov     _dx,[position]
        mov     [prevPos],_dx
ENDIF

        LOADPTR gs,_si,[sample]         ; point _gssi to sample
        add     _si,[position]          ; point _gssi to current mixing pos.
        mov     bl,[byte channel]       ; bl = channel number
        mov     bh,[byte volume]        ; bh = volume
        mov     _bp,[posLow]            ; _bp = mixing position fract. part
        mov     edx,[incr]              ; edx = mixing position increment
        mov     _cx,_ax                 ; _cx = number of elements to mix
        mov     _di,[_int dest]         ; _di points to mixing destination

        cmp     [direction],-1          ; playing backwards?
        jne     @@noback                ; if yes, negate direction
        neg     edx

@@noback:
        ; Mix the sound: (we can't do call [mixRout] as it would confuse
        ; the wdisasm/gasm procedure we use to convert this to Linux)
        mov     eax,[mixRout]
        call    eax
;        call    [mixRout]               ; mix the sound!

        mov     [posLow],_bp            ; store new position fractional part
        sub     _si,[_int sample]
        mov     [position],_si          ; store new position whole part
        mov     [_int dest],_di         ; store new mixing destination pos.

        pop     _bp
        pop     _bx
        POPSEGREG gs

        jmp     @@mixdone


@@zerovol:
        ; Zero volume - just update mixing position: (eax = number of
        ; destination elements to mix)

        mov     _cx,_ax                 ; _cx = number of dest. elements
        mov     edx,[incr]              ; edx = position increment
        cmp     [direction],-1          ; playing backwards?
        jne     @@zvfwd
        neg     edx                     ; if yes, negate direction
@@zvfwd:
        imul    edx

        ; edx:eax is now the number of sample bytes "mixed" - add it to
        ; sample playing position: (could use some optimization and thinking)
IFDEF __16__
        mov     edx,eax
        sar     eax,16                  ; update position (number of sample
        add     [posLow],ax             ; bytes mixed always fits in 16 bits)
        adc     [position],dx
ELSE
        mov     esi,[position]
        mov     edi,esi                 ; edi:esi is current playing position
        shl     esi,16                  ; in 16.16 fixed point format
        sar     edi,16
        mov     si,[word posLow]

        add     esi,eax                 ; update position in edi:esi
        adc     edi,edx

        mov     [word posLow],si        ; set new position fractional part

        shr     esi,16
        shl     edi,16                  ; set new position whole part
        or      esi,edi
        mov     [position],esi
ENDIF

        cmp     [channel],0             ; is this the first channel?
        jne     @@mixdone               ; if not, mixing is done

        ; First channel - clear mixing buffer for this area:
        ; (_cx still contains number of elements)
        PUSHSEGREG ds
        push    _bx
        LOADPTR ds,_di,[dest]
        call    Clear
        mov     [_int dest],_di
        pop     _bx
        POPSEGREG ds



@@mixdone:
        ; Mixing is finished. Sample end or loop end might have been reached
        ; or we might simply have mixed all elements for this process. Check
        ; what is the case and proceed accordingly:

        cmp     [lpType],loopNone       ; is there no loop? if so, just check
        je      @@checksmpend           ; if sample end was reached

        cmp     [direction],-1          ; going backwards? If so, check if
        je      @@backwards             ; loop start was reached

        ; Mixing forward and there is a loop - check if we reached loop end:
        mov     _ax,[position]          ; is position below loop end?
        cmp     _ax,[lpEnd]             ; if is, all mixing is done
        jae     @@loopend

        ; We didn't, but if we were playing a stream we might have reached
        ; stream write position - just loop then to make sure:
        cmp     [_esbx+dsmChannel.sampleHandle],DSM_SMP_STREAM
        jne     @@alldone
        jmp     @@loop

@@loopend:
        ; Loop end was reached. Check if we should call the callback:
        cmp     [loopCallback],0
        je      @@noloopcb1

        ; Call it!
        ; Again, avoid GNU asm confusion:
        mov     eax,[loopCallback]
        call    eax LANG, [channel]
;        call    [_ptr loopCallback] LANG, [channel]

@@noloopcb1:
        ; Check if ALE sample change is necessary:
        cmp     [ALEChange],1
        je      @@alechange

        ; ALE sample change not needed. Check if sound has been released and
        ; we should change to second loop:
        cmp     [released],1
        je      @@released

        ; None of the above. Check loop type:
        cmp     [lpType],loopUnidir
        je      @@unidirend


        ; Bidirectional loop end reached - start playing backwards and set
        ; position to lpEnd - (position - lpEnd) = 2*lpEnd - position
        mov     [direction],-1

IFDEF __16__
        mov     ax,[lpEnd]              ; edx = eax = lpEnd in 16.16 fixed
        shl     eax,16                  ; point format
        mov     edx,eax
        mov     si,[position]           ; esi = position in 16.16 fixed point
        shl     esi,16                  ; format
        mov     si,[posLow]
        sub     eax,esi                 ; eax = lpEnd - (position - lpEnd)
        add     eax,edx

        mov     [posLow],ax             ; store new position
        shr     eax,16
        mov     [position],ax
ELSE
        mov     esi,[lpEnd]
        mov     edi,esi                 ; edi:esi = lpEnd in 16.16 fixed
        shl     esi,16                  ; point format
        shr     edi,16

        add     esi,esi                 ; edi:esi = 2*lpEnd
        adc     edi,edi

        mov     edx,eax                 ; edx:eax = position in 16.16 fixed
        shl     eax,16                  ; point format
        sar     edx,16
        mov     ax,[word posLow]

        sub     esi,eax                 ; edi:esi = 2*lpEnd - position
        sbb     edi,edx

        mov     [word posLow],si
        shr     esi,16                  ; store new position
        shl     edi,16
        or      esi,edi
        mov     [position],esi
ENDIF
        jmp     @@checkend


@@unidirend:
        ; Unidirectional loop end reached - substract loop length from
        ; playing position:
        mov     _ax,[lpEnd]
        sub     _ax,[lpStart]
        sub     [position],_ax
        jmp     @@checkend


@@backwards:
        ; Playing backwards - check if we reached bidirectional loop start:
IFDEF __32__
        ; 32-bit mode - just check if playing position is below loop start
        ; position: (Use signed comparison to take care of possible wrapping,
        ; so that it won't cause any problems unless the loop is over 2
        ; gigabytes long)
        mov     _ax,[position]          ; if position is above or equal to
        cmp     _ax,[lpStart]           ; loop start, all mixing is done
        jge     @@alldone
ELSE
        ; 16-bit mode - the check above must be done unsigned, and therefore
        ; we also need to check if the playing position after mixing is above
        ; that of before. In that case the position has wrapped and we have
        ; reached loop start:
        mov     _ax,[position]
        cmp     _ax,[prevPos]           ; has position wrapped?
        ja      @@bdlpstart             ; if yes, we are at loop start

        cmp     _ax,[lpStart]           ; if position is above or equal to
        jae     @@alldone               ; loop start, all mixing is done

@@bdlpstart:
ENDIF
        ; Bidirectional loop start has been reached. Check if we should call
        ; the callback:
        cmp     [loopCallback],0
        je      @@noloopcb2

        ; Call it!
        ; GNU asm fix
        mov     eax,[loopCallback]
        call    eax LANG, [channel]
;        call    [_ptr loopCallback] LANG, [channel]

@@noloopcb2:
        ; Change direction and
        ; set new position to (lpStart-position) + lpStart
        mov     [direction],1
IFDEF __16__
        mov     si,[lpStart]            ; esi = lpStart in 16.16 fixed point
        shl     esi,16                  ; format
        shl     eax,16                  ; eax = position in 16.16 fixed point
        mov     ax,[posLow]             ; format
        mov     edx,esi
        sub     esi,eax                 ; esi = lpStart - position + lpStart
        add     esi,edx

        mov     [posLow],si             ; store new position
        shr     esi,16
        mov     [position],si
ELSE
        mov     esi,[lpStart]
        mov     edi,esi                 ; edi:esi = lpStart in 16.16 fixed
        shl     esi,16                  ; point format
        shr     edi,16

        add     esi,esi                 ; edi:esi = lpStart*2
        adc     edi,edi                 ; (a - b + a = 2a - b)

        mov     edx,eax                 ; edx:eax = position in 16.16 fixed
        shl     eax,16                  ; point format
        sar     edx,16
        mov     ax,[word posLow]

        sub     esi,eax                 ; edi:esi = lpStart - position +
        sbb     edi,edx                 ;  lpStart = 2*lpStart - position

        mov     [word posLow],si
        shr     esi,16                  ; store new position
        shl     edi,16
        or      esi,edi
        mov     [position],esi
ENDIF
        jmp     @@checkend


@@checksmpend:
        ; No loop - check if sample end has been reached:
        mov     _ax,[position]                          ; position below
        cmp     _ax,[_gsbx+dsmChannel.sampleLength]     ; sample end? if not,
        jb      @@alldone                               ; all mixing is done

        ; Sample end reached. Check if ALE sample changing is necessary:
        cmp     [ALEChange],1
        je      @@alechange

        ; ALE sample changing not necessary - sample has ended:
        mov     [_gsbx+dsmChannel.status],dsmChanEnd
        jmp     @@nodata


@@checkend:
        ; Loop end/start succesfully handled. Check if there is more data
        ; to mix, and if not, exit
        cmp     [mixLeft],0
        je      @@alldone
        jmp     @@loop                  ; loop sample


@@alechange:
        ; Loop end or sample end has been reached and new sample has to be
        ; taken into use (ALE logic):
        PUSHSEGREG gs
        push    _bx
        call    dsmChangeSample LANG, [channel]
        pop     _bx
        POPSEGREG gs
        test    _ax,_ax
        jnz     @@err

        ; If new sample is looping start playing from loop start, otherwise
        ; stop playing:
        cmp     [_gsbx+dsmChannel.loopMode],sdLoopAmiga
        jne     @@alenol

        ; Start playing from sample loop start:
        mov     _ax,[_gsbx+dsmChannel.loop1Start]
        mov     [position],_ax
        mov     [posLow],0
        jmp     @@newsample

@@alenol:
        ; stop playing:
        mov     [_gsbx+dsmChannel.status],dsmChanEnd
        jmp     @@nodata


@@released:
        ; Sound had been released, but loop had not been changed yet. Now when
        ; we have reached first loop end set values for second loop and
        ; continue playing:

        mov     [_gsbx+dsmChannel.loopNum],2    ; playing second loop
        mov     [released],0                    ; sound releasing handled
        mov     _ax,[_gsbx+dsmChannel.loop2Start]
        mov     [lpStart],_ax
        mov     _ax,[_gsbx+dsmChannel.loop2End]
        mov     [lpEnd],_ax
        mov     _ax,[_gsbx+dsmChannel.loop2Type]
        mov     [lpType],_ax

        jmp     @@loop



@@nodata:
        ; No more data to be mixed - if this is the first channel clear
        ; the rest of the mixing buffer, otherwise we are done:
        cmp     [channel],0
        jne     @@alldone

        ; Clear the rest of the mixing buffer:
        PUSHSEGREG ds
        push    _bx
        mov     _cx,[mixLeft]
        LOADPTR ds,_di,[dest]
        call    Clear
        pop     _bx
        POPSEGREG ds


@@alldone:
        ; All mixing done - save new mixing position and direction:
        mov     _ax,[position]
        mov     [_gsbx+dsmChannel.playPos],_ax
        mov     _ax,[posLow]
        mov     [_gsbx+dsmChannel.playPosLow],_ax
        mov     _ax,[direction]
        mov     [_gsbx+dsmChannel.direction],_ax

@@ok:
        xor     _ax,_ax
        jmp     @@done

@@err:
        ERROR   ID_dsmMix

@@done:
        ret
ENDP




IFDEF __16__

; mono mixing routine: (16-bit)
MACRO   _mono   num
        mov     bl,[gs:si]              ; take byte from source
        add     bp,cx                   ; increment sample position fraction
        mov     ax,[ebx+ebx]            ; take correct value from volume tbl
        adc     si,dx                   ; increment sample position whole part
        add     [di+2*num],ax           ; add word into buffer
ENDM
MixLoop mono, _mono, 32, [fs:mixCount]

ELSE

; mono mixing routine: (32-bit)
MACRO   _mono   num
        mov     bl,[esi]                ; take byte from source
        add     ebp,ecx                 ; increment sample position fraction
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        adc     esi,edx                 ; increment sample position whole part
        add     [edi+4*num],eax         ; add word into buffer
ENDM
MixLoop mono, _mono, 64, bp

ENDIF


IFDEF __16__

; mono mixing routine, first channel: (16-bit)
MACRO   _monom  num
	mov	bl,[gs:si]		; take byte from source
        add     bp,cx                   ; increment sample position fraction
	mov	ax,[ebx+ebx]		; take correct value from volume tbl
        adc     si,dx                   ; increment sample position whole part
        mov     [di+2*num],ax           ; write word into buffer
ENDM
MixLoop monom, _monom, 32, [fs:mixCount]

ELSE

; mono mixing routine, first channel: (32-bit)
MACRO   _monom  num
        mov     bl,[esi]                ; take byte from source
        add     ebp,ecx                 ; increment sample position fraction
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        adc     esi,edx                 ; increment sample position whole part
        mov     [edi+4*num],eax         ; write word into buffer
ENDM
MixLoop monom, _monom, 64, bp

ENDIF




;/***************************************************************************\
;*
;* Function:    dsmMix8bitMonoMono
;*
;* Description: Mixing routine for 8-bit mono samples to mono output
;*
;* Input:       gs              sample data segment (16-bit only)
;*              _si             sample mixing position whole part, from the
;*                              beginning of the sample segment
;*              _bp             sample position fractional part, only lower
;*                              16 bits used
;*		edx		sample mixing position increment for each
;*				destination byte, 16.16 fixed point format
;*              _di             pointer to mixing buffer (assumed to be in
;*                              the volume table segment)
;*              _cx             number of destination elements to mix
;*              bh              volume to be used
;*              bl              current channel number
;*              [ds:panning]    channel panning position
;*
;* Returns:     _si._bp         new mixing position (same format as input)
;*              _di             new destination position
;*
;* Destroys:    eax, ebx, ecx, edx, esi, edi
;*
;\***************************************************************************/

PROC    dsmMix8bitMonoMono      _funct

        test    _cx,_cx                 ; don't mix zero bytes
	jz	@@done

        test    bl,bl                   ; first channel?
        jne     @@notfirst
        mov     [mixLoop],offset monom  ; first channel - move to buffer
        jmp     @@mlok

@@notfirst:
        mov     [mixLoop],offset mono   ; not the first channel - add to buf.

@@mlok:
        call    MixMono

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    void MixMono(void)
;*
;* Description: Common code for all mono mixing routines.
;*
;\***************************************************************************/

PROC    MixMono         _funct

        add     bh,VOLADD               ; convert volume rounding up
        shr     bh,VOLSHIFT
        mov     al,bh
        xor     ebx,ebx                 ; bh contains volume and bl sample
        mov     bh,al

        mov     eax,[dsmVolumeTable]    ; add volume table offset / 4 to
        shr     eax,2                   ; ebx in 32-bit modes
        add     ebx,eax

        mov     eax,ecx                 ; eax = number of elements to mix
        and     eax,15                  ; in the first loop

        shl     eax,2
        neg     eax                     ; eax = jump table offset (64 - 4*eax)
        add     eax,64

        sub     edi,eax                 ; undo edi incrementing in loop
        add     eax,[mixLoop]
        mov     eax,[eax]

        shr     ecx,4                   ; ecx = number of loops to mix
        inc     ecx

        shl     ebp,16                  ; set position whole part to ebp
                                        ; upper word
        mov     bp,cx                   ; set loop counter to bp

        mov     ecx,edx                 ; ecx = mixing position increment
        shl     ecx,16                  ; fractional part
        sar     edx,16                  ; edx = increment whole part

        call    eax                     ; call the mixing routine

        shr     ebp,16                  ; restore position fractional part
                                        ; to ebp lower 16 bits
@@done:
	ret
ENDP




; left mixing routine: (32-bit)
MACRO   _left   num
        mov     bl,[esi]                ; take byte from source
        add     ebp,ecx                 ; increment sample position fraction
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        adc     esi,edx                 ; increment sample position whole part
        add     [edi+8*num],eax         ; add word into buffer
ENDM
MixLoop left, _left, 128, bp


; right mixing routine: (32-bit)
MACRO   _right  num
        mov     bl,[esi]                ; take byte from source
        add     ebp,ecx                 ; increment sample position fraction
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        adc     esi,edx                 ; increment sample position whole part
        add     [edi+8*num+4],eax       ; add word into buffer
ENDM
MixLoop right, _right, 128, bp


; middle mixing routine: (32-bit)
MACRO   _middle num
        mov     bl,[esi]                ; take byte from source
        add     ebp,ecx                 ; increment sample position fraction
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        adc     esi,edx                 ; increment sample position whole part
        add     [edi+8*num],eax         ; add word to left channel
        add     [edi+8*num+4],eax       ; add word to right channel
ENDM
MixLoop middle, _middle, 128, bp


; right mixing routine: (32-bit)
MACRO   _surround num
        mov     bl,[esi]                ; take byte from source
        add     ebp,ecx                 ; increment sample position fraction
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        adc     esi,edx                 ; increment sample position whole part
        add     [edi+8*num],eax         ; add word to left channel
        sub     [edi+8*num+4],eax       ; add word to right channel
ENDM
MixLoop surround, _surround, 128, bp


; smooth panning mixing routine: (32-bit) (S-L-O-W)
MACRO   _smooth num
        mov     bl,[esi]                ; take byte from source
        add     ebp,[fracIncr]          ; increment sample position fraction
        mov     cl,bl
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        adc     esi,edx                 ; increment sample position whole part
        add     [edi+8*num],eax         ; add word to left channel
        mov     eax,[4*ecx]
        add     [edi+8*num+4],eax       ; add word to right channel
ENDM
MixLoop smooth, _smooth, 128, bp





;/***************************************************************************\
;*
;* Function:    void dsmMix8bitMonoStereo(void)
;*
;* Description: Mixing routine for 8-bit mono samples to stereomono output
;*              See dsmMix8bitMonoMono() for input/output documentation.
;*
;\***************************************************************************/

PROC    dsmMix8bitMonoStereo    _funct

@@ook:
        test    _cx,_cx                 ; don't mix zero bytes
	jz	@@done

        test    bl,bl                   ; first channel?
        jne     @@notfirst

        ; This is the first channel - first clear the destination area
        push    _di _cx
        shl     ecx,1
        xor     eax,eax
        rep     stosd
        pop     _cx _di

@@notfirst:
        ; Check the channel panning position to determine which mixing
        ; routine to use: (plus the smooth panning routine requires some
        ; extra work here)
        mov     _ax,[panning]
        cmp     _ax,panLeft
        je      @@left
        cmp     _ax,panRight
        je      @@right
        cmp     _ax,panMiddle
        je      @@middle
        cmp     _ax,panSurround
        je      @@surround

        ; Smooth panning
        mov     [mixLoop],offset smooth         ; use smooth panning routine

        call    MixStereo
        jmp     @@done


@@left:
        mov     [mixLoop],offset left
        jmp     @@mlok

@@right:
        mov     [mixLoop],offset right
        jmp     @@mlok

@@middle:
        mov     [mixLoop],offset middle
        jmp     @@mlok

@@surround:
        mov     [mixLoop],offset surround
        jmp     @@mlok


@@mlok:
        ; Build correct value to ebx:
        add     bh,VOLADD               ; convert volume rounding up
        shr     bh,VOLSHIFT
        and     ebx,0000FF00h           ; bh contains volume and bl sample

        mov     eax,[dsmVolumeTable]    ; add volume table offset / 4 to
        shr     eax,2                   ; ebx in 32-bit modes
        add     ebx,eax

        mov     eax,ecx                 ; eax = number of elements to mix
        and     eax,15                  ; in the first loop

        shl     eax,2
        neg     eax                     ; eax = jump table offset (64 - 4*eax)
        add     eax,64

        sub     edi,eax                 ; undo edi incrementing in loop
        sub     edi,eax
        add     eax,[mixLoop]
        mov     eax,[eax]

        shr     ecx,4                   ; ecx = number of loops to mix
        inc     ecx

        shl     ebp,16                  ; set position whole part to ebp
                                        ; upper word
        mov     bp,cx                   ; set loop counter to bp

        mov     ecx,edx                 ; ecx = mixing position increment
        shl     ecx,16                  ; fractional part
        sar     edx,16                  ; edx = increment whole part

        call    eax                     ; call the mixing routine

        shr     ebp,16                  ; restore position fractional part
                                        ; to ebp lower 16 bits
@@done:
	ret
ENDP




;/***************************************************************************\
;*
;* Function:    void MixStereo(void)
;*
;* Description: Common code for all stereo mixing routines (smooth panning
;*              ones)
;*
;\***************************************************************************/

PROC    MixStereo       _funct

        ; Calculate the volumes for left and right channels

        mov     bl,[byte panning]
        mov     al,bh
        test    bl,bl
        jns     @@spright

        ; Panning is < 0 (left) - set left channel volume to full value and
        ; right to volume * (64+panning) / 64:
        mov     [leftVolume],al
        add     bl,64
        mul     bl
        shr     _ax,6
        mov     [rightVolume],al
        jmp     @@spvol

@@spright:
        ; Panning is > 0 (right) - set right channel volume to full value and
        ; left to volume * (64-panning) / 64:
        mov     [rightVolume],al
        neg     bl
        add     bl,64
        mul     bl
        shr     _ax,6
        mov     [leftVolume],al

@@spvol:
        ; Write mixing position fractional part increment to [fracIncr]:
        mov     eax,edx
        shl     eax,16
        mov     [fracIncr],eax

        mov     eax,ecx                 ; eax = number of elements to mix
        and     eax,15                  ; in the first loop

        shl     eax,2
        neg     eax                     ; eax = jump table offset (64 - 4*eax)
        add     eax,64

        sub     edi,eax                 ; undo edi incrementing in loop
        sub     edi,eax
        add     eax,[mixLoop]
        mov     eax,[eax]

        shr     ecx,4                   ; ecx = number of loops to mix
        inc     ecx

        shl     ebp,16                  ; set position whole part to ebp
                                        ; upper word
        mov     bp,cx                   ; set loop counter to bp

        sar     edx,16                  ; edx = increment whole part

        push    eax

        ; Set ebx to left channel volume * 256
        mov     bh,[leftVolume]
        add     bh,VOLADD               ; convert volume rounding up
        shr     bh,VOLSHIFT
        and     ebx,0000FF00h           ; bh contains volume and bl sample

        mov     eax,[dsmVolumeTable]
        shr     eax,2
        add     ebx,eax

        ; Set ecx to right channel volume * 256
        mov     ch,[rightVolume]
        add     ch,VOLADD               ; convert volume rounding up
        shr     ch,VOLSHIFT
        and     ecx,0000FF00h           ; ch contains volume and cl sample

        add     ecx,eax

        pop     eax

        call    eax                     ; call the mixing routine

        shr     ebp,16                  ; restore position fractional part
                                        ; to ebp lower 16 bits

        ret
ENDP



; 8-bit stereo => mono mixing routine: (32-bit) (S-L-O-W)
MACRO   _m8stmo num
        mov     bl,[2*esi]              ; take byte from source
        add     ebp,ecx                 ; increment sample position fraction
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        mov     bl,[2*esi+1]            ; take right byte
        adc     esi,edx                 ; increment sample position whole part
        add     eax,[4*ebx]             ; add its value
        add     [edi+4*num],eax         ; add word into buffer
ENDM
MixLoop m8stmo, _m8stmo, 64, bp

PROC    dsmMix8bitStereoMono    _funct

        test    _cx,_cx                 ; don't mix zero bytes
	jz	@@done

        test    bl,bl                   ; first channel?
        jne     @@notfirst

        ; This is the first channel - first clear the destination area
        push    _di _cx
        xor     eax,eax
        rep     stosd
        pop     _cx _di

@@notfirst:
        ; Divide volume by two - we'll add the channels together:
        inc     bh
        shr     bh,1

        mov     [mixLoop],offset m8stmo ; not the first channel - add to buf.

        call    MixMono

@@done:
        ret
ENDP




; 8-bit stereo => stereo mixing routine: (32-bit) (S-L-O-W)
MACRO   _m8stst num
        mov     bl,[2*esi]              ; take left byte from source
        add     ebp,[fracIncr]          ; increment sample position fraction
        mov     cl,[2*esi+1]            ; take right byte from source
        mov     eax,[4*ebx]             ; take correct value from volume tbl
        adc     esi,edx                 ; increment sample position whole part
        add     [edi+8*num],eax         ; add word to left channel
        mov     eax,[4*ecx]
        add     [edi+8*num+4],eax       ; add word to right channel
ENDM
MixLoop m8stst, _m8stst, 128, bp

PROC    dsmMix8bitStereoStereo  _funct

@@ook:
        test    _cx,_cx                 ; don't mix zero bytes
	jz	@@done

        test    bl,bl                   ; first channel?
        jne     @@notfirst

        ; This is the first channel - first clear the destination area
        push    _di _cx
        shl     ecx,1
        xor     eax,eax
        rep     stosd
        pop     _cx _di

@@notfirst:
        ; Mix 8-bit stereo samples to stereo destination:
        mov     [mixLoop],offset m8stst

        call    MixStereo

@@done:
        ret
ENDP



; 16-bit mono => mono mixing routine: (32-bit) (S-L-O-W)
MACRO   _m16momo        num
        mov     bl,[2*esi]
        add     ebp,ecx                 ; increment sample position fraction
        mov     eax,[4*ebx]
        mov     bl,[2*esi+1]
        adc     esi,edx                 ; increment sample position whole part
        sar     eax,8
        xor     bl,80h
        add     eax,[4*ebx]
        add     [edi+4*num],eax         ; add word to left channel
ENDM
MixLoop m16momo, _m16momo, 64, bp

PROC    dsmMix16bitMonoMono     _funct

        test    _cx,_cx                 ; don't mix zero bytes
	jz	@@done

        test    bl,bl                   ; first channel?
        jne     @@notfirst

        ; This is the first channel - first clear the destination area
        push    _di _cx
        xor     eax,eax
        rep     stosd
        pop     _cx _di

@@notfirst:
        mov     [mixLoop],offset m16momo ; not the first channel - add to buf.

        call    MixMono

@@done:
        ret
ENDP



; 16-bit mono => stereo mixing routine: (32-bit) (S-L-O-W)
MACRO   _m16most        num
        mov     bl,[2*esi]
        add     ebp,[fracIncr]          ; increment sample position fraction
        mov     eax,[4*ebx]
        mov     cl,bl
        mov     bl,[2*esi+1]
        adc     esi,edx                 ; increment sample position whole part
        sar     eax,8
        xor     bl,80h
        add     eax,[4*ebx]
        add     [edi+8*num],eax         ; add word to left channel
        mov     eax,[4*ecx]
        mov     cl,bl
        sar     eax,8
        add     eax,[4*ecx]
        add     [edi+8*num+4],eax
ENDM
MixLoop m16most, _m16most, 128, bp

PROC    dsmMix16bitMonoStereo   _funct

        test    _cx,_cx                 ; don't mix zero bytes
	jz	@@done

        test    bl,bl                   ; first channel?
        jne     @@notfirst

        ; This is the first channel - first clear the destination area
        push    _di _cx
        shl     ecx,1
        xor     eax,eax
        rep     stosd
        pop     _cx _di

@@notfirst:
        ; Mix 8-bit stereo samples to stereo destination:
        mov     [mixLoop],offset m16most

        call    MixStereo

@@done:
        ret
ENDP



; 16-bit stereo => mono mixing routine: (32-bit) (S-L-O-W)
MACRO   _m16stmo        num
        mov     bl,[4*esi]
        mov     eax,[4*ebx]
        mov     bl,[4*esi+2]
        add     eax,[4*ebx]
        mov     bl,[4*esi+1]
        sar     eax,8
        xor     bl,80h
        add     eax,[4*ebx]
        mov     bl,[4*esi+3]
        xor     bl,80h
        add     ebp,ecx                 ; increment sample position fraction
        adc     esi,edx                 ; increment sample position whole part
        add     eax,[4*ebx]
        add     [edi+4*num],eax         ; add word to left channel
ENDM
MixLoop m16stmo, _m16stmo, 64, bp

PROC    dsmMix16bitStereoMono   _funct

        test    _cx,_cx                 ; don't mix zero bytes
	jz	@@done

        test    bl,bl                   ; first channel?
        jne     @@notfirst

        ; This is the first channel - first clear the destination area
        push    _di _cx
        xor     eax,eax
        rep     stosd
        pop     _cx _di

@@notfirst:
        ; Divide volume by two - we'll add the channels together:
        inc     bh
        shr     bh,1

        mov     [mixLoop],offset m16stmo ; not the first channel - add to buf.

        call    MixMono

@@done:
        ret
ENDP



; 16-bit stereo => stereo mixing routine: (32-bit) (S-L-O-W)
MACRO   _m16stst        num
        mov     bl,[4*esi]
        mov     eax,[4*ebx]
        mov     bl,[4*esi+1]
        sar     eax,8
        xor     bl,80h
        add     eax,[4*ebx]
        add     [edi+8*num],eax         ; add word to left channel
        mov     cl,[4*esi+2]
        mov     eax,[4*ecx]
        mov     cl,[4*esi+3]
        sar     eax,8
        xor     cl,80h
        add     ebp,[fracIncr]          ; increment sample position fraction
        adc     esi,edx                 ; increment sample position whole part
        add     eax,[4*ecx]
        add     [edi+8*num+4],eax
ENDM
MixLoop m16stst, _m16stst, 128, bp

PROC    dsmMix16bitStereoStereo _funct

        test    _cx,_cx                 ; don't mix zero bytes
	jz	@@done

        test    bl,bl                   ; first channel?
        jne     @@notfirst

        ; This is the first channel - first clear the destination area
        push    _di _cx
        shl     ecx,1
        xor     eax,eax
        rep     stosd
        pop     _cx _di

@@notfirst:
        ; Mix 8-bit stereo samples to stereo destination:
        mov     [mixLoop],offset m16stst

        call    MixStereo

@@done:
        ret
ENDP



;/***************************************************************************\
;*
;* Function:    int dsmClearBuffer(unsigned numElems)
;*
;* Description: Clears the mixing buffer. Used only by dsmMixData().
;*
;* Input:       unsigned numElems       number of elements to clear
;*
;* Returns:     MIDAS error code.
;*
;\***************************************************************************/

PROC    dsmClearBuffer  _funct          numElems : _int
USES    _si,_di,_bx

        PUSHSEGREG ds

        LOADPTR ds,_di,[dsmMixBuffer]   ; point es:di to mixing buffer
        mov     _cx,[numElems]          ; number of elements

        call    Clear

        POPSEGREG ds

        xor     _ax,_ax

        ret
ENDP




;/***************************************************************************\
;*
;* Function:    Clear
;*
;* Description: Clears part of the mixing buffer
;*
;* Input:       _di                     Points to mixing buffer position
;*              _cx                     Number of elements to clear
;*
;* Returns:     _di                     New mixing buffer position
;*
;* Destroys:    eax, _bx, _cx, _di
;*
;\***************************************************************************/

PROC    Clear   NEAR

        ; FIXME - doesn't work with new fast stereo mixing

        PUSHSEGREG es

        test    _cx,_cx
        jz      @@done

        mov     ax,ds
        mov     es,ax

        xor     eax,eax
        cld

        cmp     [dsmMode],dsmMixStereo  ; stereo mixing?
        jne     @@mono

        shl     _cx,1                   ; twice the number of bytes

@@mono:
IFDEF __16__
        test    di,2                    ; aligned to a dword boundary?
        jz      @@dword
        mov     [es:di],ax              ; nope, write one word
        add     di,2
        dec     cx
        jz      @@done
@@dword:
        mov     bx,cx
        shr     cx,1
        rep     stosd                   ; fill all dwords
        test    bx,1                    ; still one word to fill?
        jz      @@done
        mov     [es:di],ax
        add     di,2
ELSE
        rep     stosd
ENDIF
@@done:
        POPSEGREG es

        ret
ENDP



;* $Log: dsmmix.asm,v $
;* Revision 1.9  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.8  1997/01/16 18:19:10  pekangas
;* Added support for setting the stream write position.
;* Stream data is no longer played past the write position
;*
;* Revision 1.7  1996/08/02 17:50:24  pekangas
;* Changed calls to pointer to go through eax to prevent GNU asm confusion
;*
;* Revision 1.6  1996/07/13 17:28:10  pekangas
;* Fixed to preserve ebx always
;*
;* Revision 1.5  1996/06/26 19:15:24  pekangas
;* Added sample loop callbacks
;*
;* Revision 1.4  1996/05/30 21:25:48  pekangas
;* Fixed a small bug in 16-bit stereo mixing routines
;*
;* Revision 1.3  1996/05/28 20:30:52  pekangas
;* Added mixing routines for 8-bit stereo and 16-bit samples
;*
;* Revision 1.2  1996/05/23 20:59:08  pekangas
;* Removed some DD 0FFFFFFFFh - lines to keep wdisasm from getting confused
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*


END