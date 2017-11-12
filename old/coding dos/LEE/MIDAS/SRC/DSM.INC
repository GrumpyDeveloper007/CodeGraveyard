;*      DSM.INC
;*
;* Digital Sound Mixer
;*
;* $Id: dsm.inc,v 1.5 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*


VOLLEVELS = 33                          ; total number of volume levels
VOLSHIFT = 1				; amount to shift volume right
VOLADD = 1				; amount to add to volume before
					; shifting - used to round up

DSM_SMP_STREAM = MAXSAMPLES             ; magic sample handle for streams



;/***************************************************************************\
;*      enum dsmMixMode
;*      ---------------
;* Description: Available DSM mixing modes
;\***************************************************************************/

ENUM    dsmMixMode \
        dsmMixMono = 1, \               ; mono mixing
        dsmMixStereo = 2                ; stereo mixing




;/***************************************************************************\
;*      enum dsmChanStatus
;*      ------------------
;* Description: DSM channel sound playing status
;\***************************************************************************/

ENUM    dsmChanStatus \
        dsmChanStopped = 0, \           ; playing is stopped
        dsmChanEnd, \                   ; playing has ended (not forced
        \                               ; stopped
        dsmChanPlaying, \               ; playing, not released
        dsmChanReleased                 ; playing, note has been released




;/***************************************************************************\
;*      enum dsmPlayDir
;*      ---------------
;* Description: Playing direction in bidirectional loops
;\***************************************************************************/

ENUM    dsmPlayDir \
        dsmPlayBackwards = -1, \        ; playing backwards
        dsmPlayForwards = 1             ; playing forward




;/***************************************************************************\
;*      struct dsmChannel
;*      -----------------
;* Description: DSM channel data
;\***************************************************************************/

STRUC   dsmChannel
        D_ptr   sample                  ; sample data pointer
        D_int   sampleType              ; sample type, see enum sdSampleType
        D_int   samplePos               ; sample position in memory
        D_int   sampleLength            ; sample length
        D_int   loopMode                ; sample looping mode, see enum
                                        ; sdLoopMode
        D_int   loop1Start              ; first loop start
        D_int   loop1End                ; first loop end
        D_int   loop1Type               ; first loop type, see enum sdLoopType
        D_int   loop2Start              ; second loop start
        D_int   loop2End                ; second loop end
        D_int   loop2Type               ; second loop type

        D_int   playPos                 ; playing position whole part
        D_int   playPosLow              ; playing position fractional part
                                        ; (only lower 16 bits used)
        D_int   streamWritePos;         ; stream write position
        rate    DD      ?               ; playing rate in Hz
        D_int   direction               ; playing direction in bidirectional
                                        ; loops - 1 is forward, -1 back
        D_int   sampleHandle            ; sample handle
        D_int   sampleChanged           ; 1 if sample has been changed
                                        ; but values not yet set in
                                        ; channel struct
        D_int   panning                 ; panning information
        D_int   volume                  ; playing volume (0-64)
        D_int   muted                   ; 1 if channel muted, 0 if not
        D_int   status                  ; channel status, see enum dsm
                                        ; dsmChanStatus
        D_int   loopNum                 ; currently played sample loop
        D_ptr   loopCallback            ; looping callback function
ENDS




;/***************************************************************************\
;*      struct dsmSample
;*      ----------------
;* Description: DSM internal sample structure
;\***************************************************************************/

STRUC   dsmSample
        D_ptr   sample                  ; sample data pointer
        D_int   sampleType              ; sample type, see enum sdSampleType
        D_int   samplePos               ; sample position in memory
        D_int   sampleLength            ; sample length
        D_int   loopMode                ; sample looping mode, see enum
                                        ; sdLoopMode
        D_int   loop1Start              ; first loop start
        D_int   loop1End                ; first loop end
        D_int   loop1Type               ; first loop type, see enum sdLoopType
        D_int   loop2Start              ; second loop start
        D_int   loop2End                ; second loop end
        D_int   loop2Type               ; second loop type

        D_int   inUse                   ; 1 if sample is in use, 0 if not
                                        ; (removed using dsmRemoveSample)
        D_int   copied                  ; 1 if a copied sample (should be
                                        ; deallocated), 0 if not
ENDS



GLOBAL  LANG dsmMixBuffer : _ptr        ; DSM mixing buffer. dsmPlay()
                                        ; writes the mixed data here. Post-
                                        ; processing is usually necessary.
GLOBAL  LANG dsmMixBufferSize : _int    ; DSM mixing buffer size

; The following global variables are used internally by different DSM
; functions and should not be accessed by other modules:

GLOBAL  LANG dsmMixRate : _int          ; mixing rate in Hz
GLOBAL  LANG dsmMode : _int             ; output mode (see enum dsmMixMode)
IFDEF __16__
GLOBAL  LANG dsmVolTableSeg : word      ; volume table segment
ENDIF
GLOBAL  LANG dsmVolumeTable : _ptr      ; pointer to volume table

GLOBAL  LANG dsmChannels : _ptr         ; pointer to channel datas
GLOBAL  LANG dsmSamples : _ptr          ; sample structures
GLOBAL  LANG dsmOutputBits : _int       ; output bit width




;/***************************************************************************\
;*
;* Function:    int dsmInit(unsigned mixRate, unsigned mode,
;*                  unsigned outputBits);
;*
;* Description: Initializes Digital Sound Mixer
;*
;* Input:       unsigned mixRate        mixing rate in Hz
;*              unsigned mode           mixing mode (see enum dsmMixMode)
;*              unsigned outputBits     output bit width (if less than
;*                                      16, output values are divided
;*                                      accordingly - mixing buffer is
;*                                      always a sequence of unsigned ints)
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmInit : _funct




;/***************************************************************************\
;*
;* Function:    int dsmClose(void)
;*
;* Description: Uninitializes Digital Sound Mixer
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmClose : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetMixRate(unsigned *mixRate)
;*
;* Description: Reads the actual mixing rate
;*
;* Input:       unsigned *mixRate       pointer to mixing rate variable
;*
;* Returns:     MIDAS error code.
;*              Mixing rate, in Hz, is stored in *mixRate
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetMixRate : _funct




;/***************************************************************************\
;*
;* Function:    int dsmOpenChannels(unsigned channels);
;*
;* Description: Opens channels for output
;*
;* Input:       unsigned channels       number of channels to open
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmOpenChannels : _funct




;/***************************************************************************\
;*
;* Function:    int dsmCalcVolTable(unsigned amplification)
;*
;* Description: Calculates a new volume table
;*
;* Input:       unsigned amplification  Amplification level. 64 - normal
;*                                      (100%), 32 = 50%, 128 = 200% etc.
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmCalcVolTable : _funct




;/***************************************************************************\
;*
;* Function:    int dsmCloseChannels(void)
;*
;* Description: Closes open output channels
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmCloseChannels : _funct




;/***************************************************************************\
;*
;* Function:    int dsmClearChannels(void)
;*
;* Description: Clears open channels (removes all sounds)
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmClearChannels : _funct




;/***************************************************************************\
;*
;* Function:    int dsmMute(int mute)
;*
;* Description: Mutes all channels
;*
;* Input:       int mute                1 = mute, 0 = un-mute
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmMute : _funct




;/***************************************************************************\
;*
;* Function:    int dsmPause(int pause)
;*
;* Description: Pauses or resumes playing
;*
;* Input:       int pause               1 = pause, 0 = resume
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmPause : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetMasterVolume(unsigned masterVolume)
;*
;* Description: Sets the master volume
;*
;* Input:       unsigned masterVolume   master volume (0 - 64)
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetMasterVolume : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetMasterVolume(unsigned *masterVolume)
;*
;* Description: Reads the master volume
;*
;* Input:       unsigned *masterVolume  pointer to master volume
;*
;* Returns:     MIDAS error code. Master volume is written to *masterVolume.
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetMasterVolume : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetAmplification(unsigned amplification)
;*
;* Description: Sets amplification level and calculates new volume table.
;*
;* Input:       unsigned amplification  amplification level, 64 = normal
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetAmplification : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetAmplification(unsigned *amplification)
;*
;* Description: Reads the amplification level
;*
;* Input:       unsigned *amplification   pointer to amplification level
;*
;* Returns:     MIDAS error code. Amplification level is written to
;*              *amplification.
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetAmplification : _funct




;/***************************************************************************\
;*
;* Function:    int dsmPlaySound(unsigned channel, ulong rate)
;*
;* Description: Starts playing a sound
;*
;* Input:       unsigned channel        channel number
;*              ulong rate              playing rate in Hz
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmPlaySound : _funct




;/***************************************************************************\
;*
;* Function:    int dsmReleaseSound(unsigned channel)
;*
;* Description: Releases the current sound from the channel. If sdLoop1Rel or
;*              sdLoop2 looping modes are used, playing will be continued from
;*              the release part of the current sample (data after the end
;*              of the first loop) after the end of the first loop is reached
;*              next time, otherwise the sound will be stopped.
;*
;* Input:       unsigned channel        channel number
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmReleaseSound : _funct




;/***************************************************************************\
;*
;* Function:    int dsmStopSound(unsigned channel)
;*
;* Description: Stops playing a sound
;*
;* Input:       unsigned channel        channel number
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmStopSound : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetRate(unsigned channel, ulong rate)
;*
;* Description: Sets the playing rate
;*
;* Input:       unsigned channel        channel number
;*              ulong rate              playing rate in Hz
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetRate : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetRate(unsigned channel, ulong *rate)
;*
;* Description: Reads the playing rate on a channel
;*
;* Input:       unsigned channel        channel number
;*              ulong *rate             pointer to playing rate
;*
;* Returns:     MIDAS error code. Playing rate is written to *rate, 0 if
;*              no sound is being played.
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetRate : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetVolume(unsigned channel, unsigned volume)
;*
;* Description: Sets the playing volume
;*
;* Input:       unsigned channel        channel number
;*              unsigned volume         playing volume (0-64)
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetVolume : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetVolume(unsigned channel, unsigned *volume)
;*
;* Description: Reads the playing volume
;*
;* Input:       unsigned channel        channel number
;*              unsigned *volume        pointer to volume
;*
;* Returns:     MIDAS error code. Playing volume is written to *volume.
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetVolume : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetSample(unsigned channel, unsigned smpHandle)
;*
;* Description: Sets the sample number on a channel
;*
;* Input:       unsigned channel        channel number
;*              unsigned smpHandle      sample handle returned by
;*                                      dsmAddSample()
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetSample : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetSample(unsigned channel, unsigned *smpHandle)
;*
;* Description: Reads current sample handle
;*
;* Input:       unsigned channel        channel number
;*              unsigned *smpHandle     pointer to sample handle
;*
;* Returns:     MIDAS error code. Sample handle is written to *smpHandle;
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetSample : _funct




;/***************************************************************************\
;*
;* Function:    int dsmChangeSample(unsigned channel)
;*
;* Description: Changes the sample used in a channel to the one specified
;*              by the channel's sample handle. Used only internally by
;*              other DSM functions, does no error checking.
;*
;* Input:       unsigned channel        channel number
;*
;* Returns:     MIDAS error code (does not fail)
;*
;\***************************************************************************/

GLOBAL  LANG dsmChangeSample : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetPosition(unsigned channel, unsigned position)
;*
;* Description: Sets the playing position from the beginning of the sample
;*
;* Input:       unsigned channel        channel number
;*              unsigned position       new playing position
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetPosition : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetPosition(unsigned channel, unsigned *position)
;*
;* Description: Reads the current playing position
;*
;* Input:       unsigned channel        channel number
;*              unsigned *position      pointer to playing position
;*
;* Returns:     MIDAS error code. Playing position is written to *position.
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetPosition : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetDirection(unsigned channel, int *direction)
;*
;* Description: Reads current playing direction
;*
;* Input:       unsigned channel        channel number
;*              int *direction          pointer to playing direction. 1 is
;*                                      forward, -1 backwards
;*
;* Returns:     MIDAS error code. Playing direction is written to *direction.
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetDirection : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetPanning(unsigned channel, int panning)
;*
;* Description: Sets the panning position of a channel
;*
;* Input:       unsigned channel        channel number
;*              int panning             panning position (see enum sdPanning)
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetPanning : _funct




;/***************************************************************************\
;*
;* Function:    int dsmGetPanning(unsigned channel, int *panning)
;*
;* Description: Reads the panning position of a channel
;*
;* Input:       unsigned channel        channel number
;*              int *panning            pointer to panning position
;*
;* Returns:     MIDAS error code. Panning position is written to *panning.
;*
;\***************************************************************************/

GLOBAL  LANG dsmGetPanning : _funct




;/***************************************************************************\
;*
;* Function:    int dsmMuteChannel(unsigned channel, int mute)
;*
;* Description: Mutes/un-mutes a channel
;*
;* Input:       unsigned channel        channel number
;*              int mute                muting status - 1 = mute, 0 = un-mute
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmMuteChannel : _funct




;/***************************************************************************\
;*
;* Function:    int dsmAddSample(sdSample *sample, int copySample,
;*                  unsigned *smpHandle);
;*
;* Description: Adds a new sample to the DSM sample list and prepares it for
;*              DSM use
;*
;* Input:       sdSample *sample        pointer to sample information
;*                                          structure
;*              int copySample          copy sample data to a new place in
;*                                      memory? 1 = yes, 0 = no
;*              unsigned *smpHandle     pointer to sample handle
;*
;* Returns:     MIDAS error code. Sample handle for the new sample is written
;*              to *smpHandle
;*
;* Notes:       If copySample = 1, sample data must not be in EMS memory
;*
;\***************************************************************************/

GLOBAL  LANG dsmAddSample : _funct




;/***************************************************************************\
;*
;* Function:    int dsmRemoveSample(unsigned smpHandle)
;*
;* Description: Removes a sample from the sample list and deallocates it if
;*              necessary.
;*
;* Input:       unsigned smpHandle      sample handle returned by
;*                                      dsmAddSample()
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmRemoveSample : _funct




;/***************************************************************************\
;*
;* Function:    int dsmMixData(unsigned numElems)
;*
;* Description: Mixes data to dsmMixBuffer.
;*
;* Input:       unsigned numElems       number of buffer elements to be mixed.
;*                                      In mono modes an "element" is an
;*                                      unsigned integer, and in stereo
;*                                      two.
;*
;* Returns:     MIDAS error code. Mixed data is written to *dsmMixBuffer.
;*
;\***************************************************************************/

GLOBAL  LANG dsmMixData : _funct




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

GLOBAL  LANG dsmMix : _funct




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

GLOBAL  LANG dsmClearBuffer : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetLoopCallback(unsigned channel,
;*                  void CALLING (*callback)(unsigned channel));
;*
;* Description: Sets sample looping callback to a channel
;*
;* Input:       unsigned channel        channel number
;*              [..] *callback          pointer to callback function, NULL to
;*                                      disable callback
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetLoopCallback : _funct




;/***************************************************************************\
;*
;* Function:    int dsmSetStreamWritePosition(unsigned channel,
;*                  unsigned position)
;*
;* Description: Sets the stream write position on a channel
;*
;* Input:       unsigned channel        channel number
;*              unsigned position       new stream write position
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dsmSetStreamWritePosition : _funct




; Mixing routines:
GLOBAL  LANG dsmMix8bitMonoMono : _funct
GLOBAL  LANG dsmMix8bitMonoStereo : _funct
GLOBAL  LANG dsmMix8bitStereoMono : _funct
GLOBAL  LANG dsmMix8bitStereoStereo : _funct
GLOBAL  LANG dsmMix16bitMonoMono : _funct
GLOBAL  LANG dsmMix16bitMonoStereo : _funct
GLOBAL  LANG dsmMix16bitStereoMono : _funct
GLOBAL  LANG dsmMix16bitStereoStereo : _funct




;/***************************************************************************\
;*      enum dsmFunctIDs
;*      ----------------
;* Description: ID numbers for DSM functions
;\***************************************************************************/

ENUM    dsmFunctIDs \
ID_dsmInit = ID_dsm, \
ID_dsmClose, \
ID_dsmGetMixRate, \
ID_dsmOpenChannels, \
ID_dsmCalcVolTable, \
ID_dsmCloseChannels, \
ID_dsmClearChannels, \
ID_dsmMute, \
ID_dsmPause, \
ID_dsmSetMasterVolume, \
ID_dsmGetMasterVolume, \
ID_dsmSetAmplification, \
ID_dsmGetAmplification, \
ID_dsmPlaySound, \
ID_dsmReleaseSound, \
ID_dsmStopSound, \
ID_dsmSetRate, \
ID_dsmGetRate, \
ID_dsmSetVolume, \
ID_dsmGetVolume, \
ID_dsmSetSample, \
ID_dsmGetSample, \
ID_dsmChangeSample, \
ID_dsmSetPosition, \
ID_dsmGetPosition, \
ID_dsmSetPanning, \
ID_dsmGetPanning, \
ID_dsmMuteChannel, \
ID_dsmAddSample, \
ID_dsmRemoveSample, \
ID_dsmMixData, \
ID_dsmMix, \
ID_dsmMixMoNormal, \
ID_dsmMixStNormal, \
ID_dsmClearBuffer, \
ID_dsmStartStream, \
ID_dsmStopStream, \
ID_dsmSetLoopCallback, \
ID_dsmSetStreamWritePosition




;* $Log: dsm.inc,v $
;* Revision 1.5  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.4  1997/01/16 18:19:10  pekangas
;* Added support for setting the stream write position.
;* Stream data is no longer played past the write position
;*
;* Revision 1.3  1996/06/26 19:15:13  pekangas
;* Added sample loop callbakcs
;*
;* Revision 1.2  1996/05/28 20:30:22  pekangas
;* Made new mixing routines GLOBAL
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*