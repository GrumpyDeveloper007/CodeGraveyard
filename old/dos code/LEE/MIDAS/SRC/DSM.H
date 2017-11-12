/*      DSM.H
 *
 * Digital Sound Mixer
 *
 * $Id: dsm.h,v 1.7 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __DSM_H
#define __DSM_H


#define VOLLEVELS 33
#define VOLSHIFT 1

/* Magic sample handle for streams: */
#define DSM_SMP_STREAM MAXSAMPLES


#include "sdevice.h"


/****************************************************************************\
*       enum dsmMixMode
*       ---------------
* Description:  Available DSM mixing modes
\****************************************************************************/

enum dsmMixMode
{
    dsmMixMono = 1,                     /* mono mixing */
    dsmMixStereo = 2                    /* stereo mixing */
};




/****************************************************************************\
*       enum dsmChanStatus
*       ------------------
* Description:  DSM channel sound playing status
\****************************************************************************/

enum dsmChanStatus
{
    dsmChanStopped = 0,                 /* playing is stopped */
    dsmChanEnd,                         /* playing has ended (not forced
                                           stopped */
    dsmChanPlaying,                     /* playing, not released */
    dsmChanReleased                     /* playing, note has been released */
};




/****************************************************************************\
*       enum dsmPlayDir
*       ---------------
* Description:  Playing direction in bidirectional loops
\****************************************************************************/

enum dsmPlayDir
{
    dsmPlayBackwards = -1,              /* playing backwards */
    dsmPlayForward = 1                  /* playing forward */
};




/****************************************************************************\
*       struct dsmChannel
*       -----------------
* Description:  DSM channel data
\****************************************************************************/

typedef struct
{
    uchar       *sample;                /* sample data pointer */
    int         sampleType;             /* sample type, see enum
                                           sdSampleType */
    int         samplePos;              /* sample position in memory */
    unsigned    sampleLength;           /* sample length */
    int         loopMode;               /* sample looping mode, see enum
                                           sdLoopMode */
    unsigned    loop1Start;             /* first loop start */
    unsigned    loop1End;               /* first loop end */
    int         loop1Type;              /* first loop type, see enum
                                           sdLoopType */
    unsigned    loop2Start;             /* second loop start */
    unsigned    loop2End;               /* second loop end */
    int         loop2Type;              /* second loop type, see enum
                                           sdLoopType */

    unsigned    playPos;                /* playing position whole part */
    unsigned    playPosLow;             /* playing position fractional part
                                           (only lower 16 bits used) */
    unsigned    streamWritePos;         /* stream write position */
    ulong       rate;                   /* playing rate in Hz */
    int         direction;              /* playing direction in bidirectional
                                           loops - 1 is forward, -1 back */
    unsigned    sampleHandle;           /* sample handle */
    unsigned    sampleChanged;          /* 1 if sample has been changed
                                           but values not yet set in
                                           channel struct */
    int         panning;                /* panning information */
    unsigned    volume;                 /* playing volume (0-64) */
    int         muted;                  /* 1 if channel muted, 0 if not */
    int         status;                 /* channel status, see enum dsm
                                           dsmChanStatus */
    int         loopNum;                /* currently played sample loop */
    void (CALLING *LoopCallback)(unsigned channel);     /* sample loop
                                                           callback */
} dsmChannel;




/****************************************************************************\
*       struct dsmSample
*       ----------------
* Description:  DSM internal sample structure
\****************************************************************************/

typedef struct
{
    uchar       *sample;                /* sample data pointer */
    int         sampleType;             /* sample type, see enum
                                           sdSampleType */
    int         samplePos;              /* sample position in memory */
    unsigned    sampleLength;           /* sample length */
    int         loopMode;               /* sample looping mode, see enum
                                           sdLoopMode */
    unsigned    loop1Start;             /* first loop start */
    unsigned    loop1End;               /* first loop end */
    int         loop1Type;              /* first loop type, see enum
                                           sdLoopType */
    unsigned    loop2Start;             /* second loop start */
    unsigned    loop2End;               /* second loop end */
    int         loop2Type;              /* second loop type, see enum
                                           sdLoopType */
    int         inUse;                  /* 1 if sample is in use, 0 if not
                                           (removed using dsmRemoveSample) */
    int         copied;                 /* 1 if a copied sample (should be
                                           deallocated), 0 if not */
} dsmSample;



#ifdef __cplusplus
extern "C" {
#endif




extern unsigned * GLOBALVAR dsmMixBuffer;  /* DSM mixing buffer. dsmPlay()
                                           writes the mixed data here. Post-
                                           processing is usually necessary. */
extern unsigned GLOBALVAR dsmMixBufferSize;      /* DSM mixing buffer size */

/* The following global variables are used internally by different DSM
   functions and should not be accessed by other modules: */

extern unsigned GLOBALVAR dsmMixRate;   /* mixing rate in Hz */
extern unsigned GLOBALVAR dsmMode;      /* output mode (see enum
                                           dsmMixMode) */
#ifdef __16__
extern unsigned GLOBALVAR dsmVolTableSeg;   /* volume table segment */
#endif
extern unsigned GLOBALVAR *dsmVolumeTable;  /* pointer to volume table */

extern dsmChannel * GLOBALVAR dsmChannels;  /* pointer to channel datas */
extern dsmSample * GLOBALVAR dsmSamples;    /* sample structures */
extern unsigned GLOBALVAR dsmOutputBits;    /* output bit width */




/****************************************************************************\
*
* Function:     int dsmInit(unsigned mixRate, unsigned mode,
*                   unsigned outputBits);
*
* Description:  Initializes Digital Sound Mixer
*
* Input:        unsigned mixRate        mixing rate in Hz
*               unsigned mode           mixing mode (see enum dsmMixMode)
*               unsigned outputBits     output bit width (if less than
*                                       16, output values are divided
*                                       accordingly - mixing buffer is
*                                       always a sequence of unsigned ints)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmInit(unsigned mixRate, unsigned mode, unsigned amplitude);




/****************************************************************************\
*
* Function:     int dsmClose(void)
*
* Description:  Uninitializes Digital Sound Mixer
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmClose(void);




/****************************************************************************\
*
* Function:     int dsmGetMixRate(unsigned *mixRate)
*
* Description:  Reads the actual mixing rate
*
* Input:        unsigned *mixRate       pointer to mixing rate variable
*
* Returns:      MIDAS error code.
*               Mixing rate, in Hz, is stored in *mixRate
*
\****************************************************************************/

int CALLING dsmGetMixRate(unsigned *mixRate);




/****************************************************************************\
*
* Function:     int dsmOpenChannels(unsigned channels);
*
* Description:  Opens channels for output
*
* Input:        unsigned channels       number of channels to open
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmOpenChannels(unsigned channels);




/****************************************************************************\
*
* Function:     int dsmCalcVolTable(unsigned amplification)
*
* Description:  Calculates a new volume table
*
* Input:        unsigned amplification  Amplification level. 64 - normal
*                                       (100%), 32 = 50%, 128 = 200% etc.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmCalcVolTable(unsigned amplification);




/****************************************************************************\
*
* Function:     int dsmCloseChannels(void)
*
* Description:  Closes open output channels
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmCloseChannels(void);




/****************************************************************************\
*
* Function:     int dsmClearChannels(void)
*
* Description:  Clears open channels (removes all sounds)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmClearChannels(void);




/****************************************************************************\
*
* Function:     int dsmMute(int mute)
*
* Description:  Mutes all channels
*
* Input:        int mute                1 = mute, 0 = un-mute
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmMute(int mute);




/****************************************************************************\
*
* Function:     int dsmPause(int pause)
*
* Description:  Pauses or resumes playing
*
* Input:        int pause               1 = pause, 0 = resume
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmPause(int pause);




/****************************************************************************\
*
* Function:     int dsmSetMasterVolume(unsigned masterVolume)
*
* Description:  Sets the master volume
*
* Input:        unsigned masterVolume   master volume (0 - 64)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetMasterVolume(unsigned masterVolume);




/****************************************************************************\
*
* Function:     int dsmGetMasterVolume(unsigned *masterVolume)
*
* Description:  Reads the master volume
*
* Input:        unsigned *masterVolume  pointer to master volume
*
* Returns:      MIDAS error code. Master volume is written to *masterVolume.
*
\****************************************************************************/

int CALLING dsmGetMasterVolume(unsigned *masterVolume);




/****************************************************************************\
*
* Function:     int dsmSetAmplification(unsigned amplification)
*
* Description:  Sets amplification level and calculates new volume table.
*
* Input:        unsigned amplification  amplification level, 64 = normal
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetAmplification(unsigned amplification);




/****************************************************************************\
*
* Function:     int dsmGetAmplification(unsigned *amplification)
*
* Description:  Reads the amplification level
*
* Input:        unsigned *amplification   pointer to amplification level
*
* Returns:      MIDAS error code. Amplification level is written to
*               *amplification.
*
\****************************************************************************/

int CALLING dsmGetAmplification(unsigned *amplification);




/****************************************************************************\
*
* Function:     int dsmPlaySound(unsigned channel, ulong rate)
*
* Description:  Starts playing a sound
*
* Input:        unsigned channel        channel number
*               ulong rate              playing rate in Hz
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmPlaySound(unsigned channel, ulong rate);




/****************************************************************************\
*
* Function:     int dsmReleaseSound(unsigned channel)
*
* Description:  Releases the current sound from the channel. If sdLoop1Rel or
*               sdLoop2 looping modes are used, playing will be continued from
*               the release part of the current sample (data after the end
*               of the first loop) after the end of the first loop is reached
*               next time, otherwise the sound will be stopped.
*
* Input:        unsigned channel        channel number
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmReleaseSound(unsigned channel);




/****************************************************************************\
*
* Function:     int dsmStopSound(unsigned channel)
*
* Description:  Stops playing a sound
*
* Input:        unsigned channel        channel number
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmStopSound(unsigned channel);




/****************************************************************************\
*
* Function:     int dsmSetRate(unsigned channel, ulong rate)
*
* Description:  Sets the playing rate
*
* Input:        unsigned channel        channel number
*               ulong rate              playing rate in Hz
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetRate(unsigned channel, ulong rate);




/****************************************************************************\
*
* Function:     int dsmGetRate(unsigned channel, ulong *rate)
*
* Description:  Reads the playing rate on a channel
*
* Input:        unsigned channel        channel number
*               ulong *rate             pointer to playing rate
*
* Returns:      MIDAS error code. Playing rate is written to *rate, 0 if
*               no sound is being played.
*
\****************************************************************************/

int CALLING dsmGetRate(unsigned channel, ulong *rate);




/****************************************************************************\
*
* Function:     int dsmSetVolume(unsigned channel, unsigned volume)
*
* Description:  Sets the playing volume
*
* Input:        unsigned channel        channel number
*               unsigned volume         playing volume (0-64)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetVolume(unsigned channel, unsigned volume);




/****************************************************************************\
*
* Function:     int dsmGetVolume(unsigned channel, unsigned *volume)
*
* Description:  Reads the playing volume
*
* Input:        unsigned channel        channel number
*               unsigned *volume        pointer to volume
*
* Returns:      MIDAS error code. Playing volume is written to *volume.
*
\****************************************************************************/

int CALLING dsmGetVolume(unsigned channe, unsigned *volume);




/****************************************************************************\
*
* Function:     int dsmSetSample(unsigned channel, unsigned smpHandle)
*
* Description:  Sets the sample number on a channel
*
* Input:        unsigned channel        channel number
*               unsigned smpHandle      sample handle returned by
*                                       dsmAddSample()
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetSample(unsigned channel, unsigned smpHandle);




/****************************************************************************\
*
* Function:     int dsmGetSample(unsigned channel, unsigned *smpHandle)
*
* Description:  Reads current sample handle
*
* Input:        unsigned channel        channel number
*               unsigned *smpHandle     pointer to sample handle
*
* Returns:      MIDAS error code. Sample handle is written to *smpHandle;
*
\****************************************************************************/

int CALLING dsmGetSample(unsigned channel, unsigned *smpHandle);




/****************************************************************************\
*
* Function:     int dsmChangeSample(unsigned channel)
*
* Description:  Changes the sample used in a channel to the one specified
*               by the channel's sample handle. Used only internally by
*               other DSM functions, does no error checking.
*
* Input:        unsigned channel        channel number
*
* Returns:      MIDAS error code (does not fail)
*
\****************************************************************************/

int CALLING dsmChangeSample(unsigned channel);




/****************************************************************************\
*
* Function:     int dsmSetPosition(unsigned channel, unsigned position)
*
* Description:  Sets the playing position from the beginning of the sample
*
* Input:        unsigned channel        channel number
*               unsigned position       new playing position
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetPosition(unsigned channel, unsigned position);




/****************************************************************************\
*
* Function:     int dsmGetPosition(unsigned channel, unsigned *position)
*
* Description:  Reads the current playing position
*
* Input:        unsigned channel        channel number
*               unsigned *position      pointer to playing position
*
* Returns:      MIDAS error code. Playing position is written to *position.
*
\****************************************************************************/

int CALLING dsmGetPosition(unsigned channel, unsigned *position);




/****************************************************************************\
*
* Function:     int dsmGetDirection(unsigned channel, int *direction)
*
* Description:  Reads current playing direction
*
* Input:        unsigned channel        channel number
*               int *direction          pointer to playing direction. 1 is
*                                       forward, -1 backwards
*
* Returns:      MIDAS error code. Playing direction is written to *direction.
*
\****************************************************************************/

int CALLING dsmGetDirection(unsigned channel, int *direction);




/****************************************************************************\
*
* Function:     int dsmSetPanning(unsigned channel, int panning)
*
* Description:  Sets the panning position of a channel
*
* Input:        unsigned channel        channel number
*               int panning             panning position (see enum sdPanning)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetPanning(unsigned channel, int panning);




/****************************************************************************\
*
* Function:     int dsmGetPanning(unsigned channel, int *panning)
*
* Description:  Reads the panning position of a channel
*
* Input:        unsigned channel        channel number
*               int *panning            pointer to panning position
*
* Returns:      MIDAS error code. Panning position is written to *panning.
*
\****************************************************************************/

int CALLING dsmGetPanning(unsigned channel, int *panning);




/****************************************************************************\
*
* Function:     int dsmMuteChannel(unsigned channel, int mute)
*
* Description:  Mutes/un-mutes a channel
*
* Input:        unsigned channel        channel number
*               int mute                muting status - 1 = mute, 0 = un-mute
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmMuteChannel(unsigned channel, int mute);




/****************************************************************************\
*
* Function:     int dsmAddSample(sdSample *sample, int copySample,
*                   unsigned *smpHandle);
*
* Description:  Adds a new sample to the DSM sample list and prepares it for
*               DSM use
*
* Input:        sdSample *sample        pointer to sample information
*                                           structure
*               int copySample          copy sample data to a new place in
*                                       memory? 1 = yes, 0 = no
*               unsigned *smpHandle     pointer to sample handle
*
* Returns:      MIDAS error code. Sample handle for the new sample is written
*               to *smpHandle
*
* Notes:        If copySample = 1, sample data must not be in EMS memory
*
\****************************************************************************/

int CALLING dsmAddSample(sdSample *sample, int copySample, unsigned *smpHandle);




/****************************************************************************\
*
* Function:     int dsmRemoveSample(unsigned smpHandle)
*
* Description:  Removes a sample from the sample list and deallocates it if
*               necessary.
*
* Input:        unsigned smpHandle      sample handle returned by
*                                       dsmAddSample()
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmRemoveSample(unsigned smpHandle);




/****************************************************************************\
*
* Function:     int dsmMixData(unsigned numElems)
*
* Description:  Mixes data to dsmMixBuffer.
*
* Input:        unsigned numElems       number of buffer elements to be mixed.
*                                       In mono modes an "element" is an
*                                       unsigned integer, and in stereo
*                                       two.
*
* Returns:      MIDAS error code. Mixed data is written to *dsmMixBuffer.
*
\****************************************************************************/

int CALLING dsmMixData(unsigned numElems);




/****************************************************************************\
*
* Function:     int dsmMix(unsigned channel, void *mixRoutine,
*                   unsigned volume, unsigned numElems);
*
* Description:  Mixes data for one channel. Used internally by dsmMixData().
*
* Input:        unsigned channel        channel number
*               void *mixRoutine        pointer to low-level mixing routine
*               unsigned volume         actual playing volume (volume in
*                                       channel structure is ignored)
*               unsigned numElems       number of elements to mix (see
*                                       dsmMixData())
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmMix(unsigned channel, void *mixRoutine, unsigned volume,
    unsigned numElems);




/****************************************************************************\
*
* Function:     int dsmClearBuffer(unsigned numElems)
*
* Description:  Clears the mixing buffer. Used only by dsmMixData().
*
* Input:        unsigned numElems       number of elements to clear
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING dsmClearBuffer(unsigned numElems);




#ifdef SUPPORTSTREAMS


/****************************************************************************\
*
* Function:     int dsmStartStream(unsigned channel, uchar *buffer,
*                   unsigned bufferLength, int sampleType);
*
* Description:  Starts playing a digital audio stream on a channel
*
* Input:        unsigned channel        channel number
*               uchar *buffer           pointer to stream buffer
*               unsigned bufferLength   buffer length in bytes
*               int sampleType          stream sample type
*               ulong rate              stream playing rate (in Hz)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmStartStream(unsigned channel, uchar *buffer, unsigned
    bufferLength, int sampleType, ulong rate);




/****************************************************************************\
*
* Function:     int dsmStopStream(unsigned channel);
*
* Description:  Stops playing digital audio stream on a channel
*
* Input:        unsigned channel        channel number
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmStopStream(unsigned channel);




/****************************************************************************\
*
* Function:     int dsmSetLoopCallback(unsigned channel,
*                   void (CALLING *callback)(unsigned channel));
*
* Description:  Sets sample looping callback to a channel
*
* Input:        unsigned channel        channel number
*               [..] *callback          pointer to callback function, NULL to
*                                       disable callback
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetLoopCallback(unsigned channel,
    void (CALLING *callback)(unsigned channel));




/****************************************************************************\
*
* Function:     int dsmSetStreamWritePosition(unsigned channel,
*                   unsigned position)
*
* Description:  Sets the stream write position on a channel
*
* Input:        unsigned channel        channel number
*               unsigned position       new stream write position
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmSetStreamWritePosition(unsigned channel, unsigned position);



#endif /* #ifdef SUPPORTSTREAMS */


/* Prototypes for the actual mixing routines: */
void CALLING dsmMix8bitMonoMono(void);      /* 8-bit Mono => Mono */
void CALLING dsmMix8bitMonoStereo(void);    /* 8-bit Mono => Stereo */
void CALLING dsmMix8bitStereoMono(void);    /* 8-bit Stereo => Mono */
void CALLING dsmMix8bitStereoStereo(void);  /* 8-bit Stereo => Stereo */
void CALLING dsmMix16bitMonoMono(void);     /* 16-bit Mono => Mono */
void CALLING dsmMix16bitMonoStereo(void);   /* 16-bit Mono => Stereo */
void CALLING dsmMix16bitStereoMono(void);   /* 16-bit Stereo => Mono */
void CALLING dsmMix16bitStereoStereo(void); /* 16-bit Stereo => Stereo */







#ifdef __cplusplus
}
#endif



/****************************************************************************\
*       enum dsmFunctIDs
*       ----------------
* Description:  ID numbers for DSM functions
\****************************************************************************/

enum dsmFunctIDs
{
    ID_dsmInit = ID_dsm,
    ID_dsmClose,
    ID_dsmGetMixRate,
    ID_dsmOpenChannels,
    ID_dsmCalcVolTable,
    ID_dsmCloseChannels,
    ID_dsmClearChannels,
    ID_dsmMute,
    ID_dsmPause,
    ID_dsmSetMasterVolume,
    ID_dsmGetMasterVolume,
    ID_dsmSetAmplification,
    ID_dsmGetAmplification,
    ID_dsmPlaySound,
    ID_dsmReleaseSound,
    ID_dsmStopSound,
    ID_dsmSetRate,
    ID_dsmGetRate,
    ID_dsmSetVolume,
    ID_dsmGetVolume,
    ID_dsmSetSample,
    ID_dsmGetSample,
    ID_dsmChangeSample,
    ID_dsmSetPosition,
    ID_dsmGetPosition,
    ID_dsmGetDirection,
    ID_dsmSetPanning,
    ID_dsmGetPanning,
    ID_dsmMuteChannel,
    ID_dsmAddSample,
    ID_dsmRemoveSample,
    ID_dsmMixData,
    ID_dsmMix,
    ID_dsmMixMoNormal,
    ID_dsmMixStNormal,
    ID_dsmClearBuffer,
    ID_dsmStartStream,
    ID_dsmStopStream,
    ID_dsmSetLoopCallback,
    ID_dsmSetStreamWritePosition
};



#endif


/*
 * $Log: dsm.h,v $
 * Revision 1.7  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.6  1997/01/16 18:19:10  pekangas
 * Added support for setting the stream write position.
 * Stream data is no longer played past the write position
 *
 * Revision 1.5  1996/07/13 18:13:25  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.4  1996/06/26 19:15:03  pekangas
 * Added sample loop callbacks
 *
 * Revision 1.3  1996/05/28 20:29:56  pekangas
 * Changed mixing routine prototypes and added new ones
 *
 * Revision 1.2  1996/05/26 20:55:20  pekangas
 * Added dsmStartStream and dsmStopStream
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/