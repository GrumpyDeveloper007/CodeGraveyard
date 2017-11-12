;*      SDEVICE.INC
;*
;* Sound Device definitions
;*
;* $Id: sdevice.inc,v 1.4 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*


IFDEF __16__
SMPMAX = 65519                          ; max sample length (65536-16 - 1)
ELSE
SMPMAX = 4294967279                     ; max sample length (2^32 - 17)
ENDIF

MAXSAMPLES = 256                        ; maximum number of samples


;/***************************************************************************\
;*      enum sdSampleType
;*      -----------------
;* Description: Sample types
;\***************************************************************************/

ENUM    sdSampleType \
        smpNone = 0, \                  ; no sample
        smp8bitMono = 1, \              ; 8-bit mono unsigned sample
        smp8bit = smp8bitMono, \        ; for compatibility
        smp16bitMono = 2, \             ; 16-bit mono signed sample
        smp16bit = smp16bitMono, \      ; for compatibility
        smp8bitStereo = 3, \            ; 8-bit stereo unsigned sample
        smp16bitStereo = 4              ; 16-bit stereo signed sample




;/***************************************************************************\
;*      enum sdLoopMode
;*      ---------------
;* Description: Sample looping modes
;\***************************************************************************/

ENUM    sdLoopMode \
        sdLoopNone = 0, \               ; no looping */
        sdLoop1, \                      ; 1 loop, release ends note
        sdLoop1Rel, \                   ; 1 loop, sample data after loop is
        \                               ; played when note is released
        sdLoop2, \                      ; 2 loops, when note is released
        \                               ; playing is continued looping the
        \                               ; second loop
        sdLoopAmigaNone, \              ; Amiga compatible looping, no
        \                               ; loop - ALE logic enabled anyway
        sdLoopAmiga                     ; Amiga compatible looping - 1
                                        ; loop, ALE logic enabled




;/***************************************************************************\
;*      enum sdLoopType
;*      ---------------
;* Description: Sample looping type for one loop
;\***************************************************************************/

ENUM    sdLoopType \
        loopNone = 0, \                 ; no looping
        loopUnidir, \                   ; unidirectional loop
        loopBidir                       ; bidirectional loop




;/***************************************************************************\
;*      enum sdSmpPos
;*      -------------
;* Description: Sample positions in memory
;\***************************************************************************/

ENUM    sdSmpPos \
        sdSmpNone = 0, \                ; no sample
        sdSmpConv, \                    ; conventional memory
        sdSmpEMS                        ; EMS




;/***************************************************************************\
;*      struct sdSample
;*      ---------------
;* Description: Sound Device sample information structure
;\***************************************************************************/

STRUC   sdSample

D_ptr   sample                          ; sample data pointer
D_int   samplePos                       ; sample position in memory, see enum
                                        ; sdSmpPos
D_int   sampleType                      ; sample type, see enum sdSampleType
D_int   sampleLength                    ; sample length
D_int   loopMode                        ; sample looping mode, see enum
                                        ; sdLoopMode
D_int   loop1Start                      ; first loop start
D_int   loop1End                        ; first loop end
D_int   loop1Type                       ; first loop type, see enum sdLoopType
D_int   loop2Start                      ; second loop start
D_int   loop2End                        ; second loop end
D_int   loop2Type                       ; second loop type, see enum

ENDS



;/***************************************************************************\
;*      enum sdPanning
;*      --------------
;* Description: Sound Device panning values. Legal values range from
;*              panLeft to panRight, in steps of 1, plus panSurround.
;*              Surround sound is played from middle if surround is not
;*              enabled.
;\***************************************************************************/

ENUM    sdPanning \
        panLeft = -64, \                ; left speaker
        panMiddle = 0, \                ; middle (both speakers)
        panRight = 64, \                ; right speaker
        panSurround = 80h               ; surround sound




;/***************************************************************************\
;*      enum sdMode
;*      -----------
;* Description: Possible SoundDevice output modes
;\***************************************************************************/

ENUM    sdMode \
        sdMono = 1, \                   ; mono
        sdStereo = 2, \                 ; stereo
        sd8bit = 4, \                   ; 8-bit output
        sd16bit = 8                     ; 16-bit output




;/***************************************************************************\
;*      enum sdConfigBits
;*      -----------------
;* Description: Sound Device configuration information bits
;\***************************************************************************/

ENUM    sdConfigBits \
        sdUsePort = 1, \                ; SD uses an I/O port
        sdUseIRQ = 2, \                 ; SD uses an IRQ
        sdUseDMA = 4, \                 ; SD uses a DMA channel
        sdUseMixRate = 8, \             ; SD uses the set mixing rate
        sdUseOutputMode = 16, \         ; SD uses the set output mode
        sdUseDSM = 32                   ; SD uses software mixing (DSM)




;/***************************************************************************\
;*      struct SoundDevice
;*      ------------------
;* Description: SoundDevice structure. See SDEVICE.TXT for documentation
;\***************************************************************************/

STRUC   SoundDevice

        D_int   tempoPoll
        D_int   configBits              ; Configuration info bits. See enum
                                        ; sdConfigBits.
        D_int   port                    ; Sound Device I/O port address
        D_int   IRQ                     ; Sound Device IRQ number
        D_int   DMA                     ; Sound Device DMA channel number
        D_int   cardType                ; Sound Device sound card type.
                                        ; Starting from 1, 0 means
                                        ; autodetect
        D_int   numCardTypes            ; number of different sound card
                                        ; types for this Sound Device
        D_int   modes                   ; Possible modes for this SD,
                                        ; see enum sdMode. Updated by
                                        ; Detect()
        D_ptr   sdName                  ; pointer to Sound Device name string
        D_ptr   cardNames               ; pointer to an array of pointers to
                                        ; sound card name strings
        D_int   numPortAddresses        ; number of possible port
                                        ; addresses in table
        D_ptr   portAddresses           ; pointer to an array of possible
                                        ; I/O port addresses

        D_ptr   Detect
        D_ptr   Init
        D_ptr   Close
        D_ptr   GetMixRate
        D_ptr   GetMode
        D_ptr   OpenChannels
        D_ptr   CloseChannels
        D_ptr   ClearChannels
        D_ptr   Mute
        D_ptr   Pause
        D_ptr   SetMasterVolume
        D_ptr   GetMasterVolume
        D_ptr   SetAmplification
        D_ptr   GetAmplification
        D_ptr   PlaySound
        D_ptr   ReleaseSound
        D_ptr   StopSound
        D_ptr   SetRate
        D_ptr   GetRate
        D_ptr   SetVolume
        D_ptr   GetVolume
        D_ptr   SetSample
        D_ptr   GetSample
        D_ptr   SetPosition
        D_ptr   GetPosition
        D_ptr   GetDirection
        D_ptr   SetPanning
        D_ptr   GetPanning
        D_ptr   MuteChannel
        D_ptr   AddSample
        D_ptr   RemoveSample
        D_ptr   SetUpdRate
        D_ptr   StartPlay
        D_ptr   Play

IFDEF SUPPORTSTREAMS
        D_ptr   StartStream
        D_ptr   StopStream
        D_ptr   SetLoopCallback
        D_ptr   SetStreamWritePosition
ENDIF

ENDS


;* $Log: sdevice.inc,v $
;* Revision 1.4  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.3  1997/01/16 18:21:23  pekangas
;* Added function SetStreamWritePosition
;*
;* Revision 1.2  1996/05/28 20:29:07  pekangas
;* Added definitions for stereo sample types
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*