/*      DSM.C
 *
 * Digital Sound Mixer
 *
 * $Id: dsm.c,v 1.11 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

/* Possibly environment dependent code is marked with *!!* */

#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "mmem.h"
#include "sdevice.h"
#include "dsm.h"
#include "mutils.h"
#include "mglobals.h"

#ifndef NOEMS
#include "ems.h"
#endif

#ifdef __DPMI__
#include "dpmi.h"
#endif

RCSID(const char *dsm_rcsid = "$Id: dsm.c,v 1.11 1997/01/16 18:41:59 pekangas Exp $";)


#ifndef NULL
#define NULL ((void*) 0L)
#endif


#define MIXBUFLEN 40                    /* mixing buffer length 1/40th of a
                                           second */

unsigned *dsmMixBuffer;                 /* DSM mixing buffer. dsmPlay() writes
                                           the mixed data here. Post-
                                           processing is usually necessary. */
unsigned dsmMixBufferSize;              /* DSM mixing buffer size */

/* The following global variables are used internally by different DSM
   functions and should not be accessed by other modules: */

unsigned        dsmMixRate;             /* mixing rate in Hz */
unsigned        dsmMode;                /* output mode (see enum
                                           dsmMixMode) */
#ifdef __16__
unsigned        dsmVolTableSeg;         /* volume table segment */
#endif
unsigned        *dsmVolumeTable;        /* pointer to volume table */

dsmChannel      *dsmChannels;           /* pointer to channel datas */
dsmSample       *dsmSamples;            /* sample structures */
unsigned        dsmOutputBits;          /* output bit width */


/* DSM internal variables: */

static unsigned *dsmVolTableMem;        /* pointer to volume table returned
                                           by memAlloc(). Used for
                                           deallocating */
static unsigned dsmChOpen;              /* number of open channels */
static volatile unsigned dsmChPlay;     /* 1 if data on channels may be
                                           played */
static unsigned dsmMasterVolume;        /* master volume */

static int      dsmMuted;               /* 1 if muted, 0 if not */
static int      dsmPaused;              /* 1 if paused, 0 if not */

static unsigned dsmAmplification;       /* amplification level */

static void     *mixingRoutines[3][5] = /* Pointers to mixing routines */
    {
        {
            /* Make sure we'll crash right away if mixing mode is 0: */
            NULL, NULL, NULL, NULL, NULL
        },
        {
            /* Mixing routines for all sample types to mono output: */
            &dsmMix8bitMonoMono,
            &dsmMix8bitMonoMono,
            &dsmMix16bitMonoMono,
            &dsmMix8bitStereoMono,
            &dsmMix16bitStereoMono
        },
        {
            /* Mixing routines for all sample types to stereo output: */
            &dsmMix8bitMonoStereo,
            &dsmMix8bitMonoStereo,
            &dsmMix16bitMonoStereo,
            &dsmMix8bitStereoStereo,
            &dsmMix16bitStereoStereo
        }
    };


/* Calculate log2(sampleSize) based on sample type */
static int dsmSampleShift(int sampleType)
{
    switch ( sampleType )
    {
        case smp8bitStereo:
        case smp16bitMono:
            return 1;

        case smp16bitStereo:
            return 2;
    }
    return 0;
}



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

int CALLING dsmInit(unsigned mixRate, unsigned mode, unsigned outputBits)
{
    int         error, i;
#if defined(__16__) & defined(__PROTMODE__)
    ulong       baseAddr
#endif

    dsmMixRate = mixRate;
    dsmMode = mode;
    dsmOutputBits = outputBits;

    dsmChOpen = 0;                      /* no open channels */
    dsmChPlay = 0;                      /* do not play data in channels */
    dsmChannels = NULL;                 /* channel structures not allocated */
    dsmMuted = 0;                       /* not muted */
    dsmPaused = 0;                      /* not paused */
    dsmMasterVolume = 64;               /* master volume maximum */

    /* Calculate mixing buffer size: (FIXME) */
    if ( mode == dsmMixStereo )
        dsmMixBufferSize = 2 * sizeof(unsigned) * mixRate / MIXBUFLEN;
    else
        dsmMixBufferSize = sizeof(unsigned) * mixRate / MIXBUFLEN;


#if 0
    --------------------
    This code is only for the new fast stereo mixing that is not implemented
    yet
    --------------------
#ifdef __16__
    if ( mode == dsmMixStereo )
        dsmMixBufferSize = 4 * mixRate / MIXBUFLEN;
    else
        dsmMixBufferSize = 2 * mixRate / MIXBUFLEN;
#else
    dsmMixBufferSize = sizeof(unsigned) * mixRate / MIXBUFLEN;
#endif
#endif /* #if 0 */

    /* Round up mixing buffer size to nearest paragraph: */
    dsmMixBufferSize = (dsmMixBufferSize + 15) & 0xFFFFFFF0;

    /* Allocate memory for volume table: (mixing buffer follows
       volume table) */
#ifdef __16__
    if ( (error = memAlloc(VOLLEVELS * 256 * sizeof(unsigned) +
        dsmMixBufferSize+ 16, (void**) &dsmVolTableMem)) != OK )
        PASSERROR(ID_dsmInit);
#else
    if ( (error = memAlloc(VOLLEVELS * 256 * sizeof(unsigned) +
        dsmMixBufferSize + 1024 + 16,
        (void**) &dsmVolTableMem)) != OK )
        PASSERROR(ID_dsmInit);
#endif
    /* (in 16-bit modes the volume table is paragraph aligned and in 32-bit
       modes it has to be aligned to a 1024-byte boundary, hence the
       difference) */

#ifdef __16__
#ifdef __REALMODE__
    /* *!!* */
    /* Real mode - align volume table to a beginning of a segment: */
    dsmVolTableSeg = *((unsigned*) ((uchar*)&dsmVolTableMem + 2)) +
        (((*(unsigned*) &dsmVolTableMem) + 15) >> 4);
    /* (now if that isn't ugly code I don't know what is) */
#else
    /* 16-bit protected mode under DPMI - allocate descriptor for volume
       table: */
    if ( (error = dpmiAllocDescriptor(&dsmVolTableSeg)) != OK )
        PASSERROR(ID_dsmInit);

    /* Get allocated memory area segment base address to baseAddr: */
    if ( (error = dpmiGetSegmentBase((unsigned)
        (((ulong) dsmVolTableMem) >> 16), &baseAddr)) != OK )
        PASSERROR(ID_dsmInit);

    /* Calculate volume table memory start address: */
    baseAddr += ((ulong) dsmVolTableMem) & 0xFFFF;

    /* Align volume table to paragraph boundary: */
    baseAddr = (baseAddr + 0x0F) & 0xFFFFFFF0L;

    /* Set volume table segment base address: */
    if ( (error = dpmiSetSegmentBase(dsmVolTableSeg, baseAddr)) != OK )
        PASSERROR(ID_dsmInit);

    /* Set correct segment limit for volume table area (volume table +
       mixing buffer): */
    if ( (error = dpmiSetSegmentLimit(dsmVolTableSeg, 256*2*VOLLEVELS +
        dsmMixBufferSize)) != OK )
        PASSERROR(ID_dsmInit);
#endif
    /* Point mixing buffer to the memory immediately after the volume
       table: */
    dsmMixBuffer = (unsigned*) ((((ulong) dsmVolTableSeg) << 16) +
        256 * 2 * VOLLEVELS);

    /* Build a normal pointer to the volume table: */
    dsmVolumeTable = (unsigned*) (((ulong) dsmVolTableSeg) << 16);
#else
    /* 32-bit mode - align volume table to a 1024-byte boundary: */
    dsmVolumeTable = (unsigned*) ((((unsigned) dsmVolTableMem) + 1023) &
        0xFFFFFC00L);

    /* Point mixing buffer to the memory immediately after the volume
       table: */
    dsmMixBuffer = (unsigned*) (((unsigned)dsmVolumeTable) +
        256 * VOLLEVELS * sizeof(unsigned));
#endif

    /* Allocate memory for sample structures: */
    if ( (error = memAlloc(MAXSAMPLES * sizeof(dsmSample), (void**)
        &dsmSamples)) != OK )
        PASSERROR(ID_dsmInit);

    /* Mark all samples unused: */
    for ( i = 0; i < MAXSAMPLES; i++ )
        dsmSamples[i].inUse = 0;

    return OK;
}




/****************************************************************************\
*
* Function:     int dsmClose(void)
*
* Description:  Uninitializes Digital Sound Mixer
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmClose(void)
{
    int         error;

#if defined(__16__) & defined(__PROTMODE__)
    /* Deallocate volume table segment descriptor: */
    if ( (error = dpmiFreeDescriptor(dsmVolTableSeg)) != OK )
        PASSERROR(ID_dsmClose);
#endif

    /* Deallocate volume table and mixing buffer: */
    if ( (error = memFree(dsmVolTableMem)) != OK )
        PASSERROR(ID_dsmClose);

    /* Deallocate sample structures: */
    if ( (error = memFree(dsmSamples)) != OK )
        PASSERROR(ID_dsmClose);

    return OK;
}




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

int CALLING dsmGetMixRate(unsigned *mixRate)
{
    *mixRate = dsmMixRate;
    return OK;
}




/****************************************************************************\
*
* Function:     int dsmOpenChannels(unsigned channels)
*
* Description:  Opens channels for output
*
* Input:        unsigned channels       number of channels to open
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmOpenChannels(unsigned channels)
{
    int         error;

    dsmChPlay = 0;                      /* data on channels may not be
                                           played */
    dsmChOpen = channels;
    dsmMuted = 0;                       /* not muted */
    dsmPaused = 0;                      /* not paused */

    /* Allocate memory for channel structures: */
    if ( (error = memAlloc(channels * sizeof(dsmChannel), (void**)
        &dsmChannels)) != OK )
        PASSERROR(ID_dsmOpenChannels);

    /* Set default amplification level and calculate volume table: */
    if ( (error = dsmSetAmplification(64)) != OK )
        PASSERROR(ID_dsmOpenChannels);

    /* Clear all channels: */
    if ( (error = dsmClearChannels()) != OK )
        PASSERROR(ID_dsmOpenChannels);

    dsmChPlay = 1;                      /* data on channels may now be
                                           played */
    return OK;
}




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

int CALLING dsmCalcVolTable(unsigned amplification)
{
    int         volume, value;
    long        temp;
    unsigned    *tablePtr;              /* current volume table position */

    /* FIXME - does not support new fast stereo mixing */

    tablePtr = dsmVolumeTable;

    for ( volume = 0; volume < VOLLEVELS; volume++ )
    {
        for ( value = -128; value < 128; value++ )
        {
            /*!!*/
            temp = ((long) (value * volume)) * ((long) amplification) / 64L;
            temp = (temp * 256L / ((long)(VOLLEVELS-1)) / ((long) dsmChOpen))
                >> (16 - dsmOutputBits);
            *(tablePtr++) = (unsigned) (temp);
        }
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int dsmCloseChannels(void)
*
* Description:  Closes open output channels
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmCloseChannels(void)
{
    int         error;

    /* Check that channels have been opened: */
    if ( dsmChOpen == 0 )
    {
        /* No open channels - return error: */
        ERROR(errNoChannels, ID_dsmCloseChannels);
        return errNoChannels;
    }

    dsmChPlay = 0;                      /* do not play data on channels */

    /* Deallocate channel structures: */
    if ( (error = memFree(dsmChannels)) != OK )
        PASSERROR(ID_dsmCloseChannels)

    dsmChOpen = 0;                      /* no open channels */

    return OK;
}




/****************************************************************************\
*
* Function:     int dsmClearChannels(void)
*
* Description:  Clears open channels (removes all sounds)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dsmClearChannels(void)
{
    unsigned    i;
    dsmChannel  *chan;

    /* Check that channels have been opened: */
    if ( dsmChOpen == 0 )
    {
        /* No open channels - return error: */
        ERROR(errNoChannels, ID_dsmCloseChannels);
        return errNoChannels;
    }

    /* Remove sounds from channels: */
    for ( i = 0; i < dsmChOpen; i++ )
    {
        chan = &dsmChannels[i];
        chan->status = dsmChanStopped;  /* playing is stopped */
        chan->sampleHandle = 0;         /* no sample selected */
        chan->sampleChanged = 0;        /* sample not changed */
        chan->sampleType = smpNone;     /* no sample */
        chan->samplePos = sdSmpNone;    /* no sample */
        chan->rate = 0;                 /* no playing rate set */
        chan->direction = 1;            /* forward direction */
        chan->panning = panMiddle;      /* channel at middle */
        chan->muted = 0;                /* channel not muted */
        chan->LoopCallback = NULL;      /* no loop callback */
    }

    return OK;
}




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

int CALLING dsmMute(int mute)
{
    dsmMuted = mute;
    return OK;
}




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

int CALLING dsmPause(int pause)
{
    dsmPaused = pause;
    return OK;
}




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

int CALLING dsmSetMasterVolume(unsigned masterVolume)
{
    dsmMasterVolume = masterVolume;
    return OK;
}




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

int CALLING dsmGetMasterVolume(unsigned *masterVolume)
{
    *masterVolume = dsmMasterVolume;
    return OK;
}




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

int CALLING dsmSetAmplification(unsigned amplification)
{
    int         error;

    dsmAmplification = amplification;

    if ( (error = dsmCalcVolTable(amplification)) != OK )
        PASSERROR(ID_dsmSetAmplification)

    return OK;
}




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

int CALLING dsmGetAmplification(unsigned *amplification)
{
    *amplification = dsmAmplification;
    return OK;
}




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

int CALLING dsmPlaySound(unsigned channel, ulong rate)
{
    int         error;

    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmPlaySound);
        return errInvalidChanNumber;
    }

    /* Playing sound: */
    dsmChannels[channel].status = dsmChanPlaying;

    /* Set playing rate: */
    if ( (error = dsmSetRate(channel, rate)) != OK )
        PASSERROR(ID_dsmPlaySound)

    /* Set playing position to the beginning of the sample: */
    if ( (error = dsmSetPosition(channel, 0)) != OK )
        PASSERROR(ID_dsmPlaySound)

    return OK;
}




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

int CALLING dsmReleaseSound(unsigned channel)
{
    dsmChannel  *chan;

    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmReleaseSound);
        return errInvalidChanNumber;
    }

    chan = &dsmChannels[channel];

    /* If no sound is being played in the channel do nothing: */
    if ( chan->status == dsmChanPlaying )
    {
        if ( (chan->loopMode == sdLoop1Rel) || (chan->loopMode == sdLoop2) )
        {
            /* Release sound - continue from release portion of the sample: */
            chan->status = dsmChanReleased;
        }
        else
        {
            /* One loop only or no looping - let playback continue normally */
        }
    }

    return OK;
}




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

int CALLING dsmStopSound(unsigned channel)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmStopSound);
        return errInvalidChanNumber;
    }

    /* Stop sound: */
    dsmChannels[channel].status = dsmChanStopped;

    return OK;
}




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

int CALLING dsmSetRate(unsigned channel, ulong rate)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmSetRate);
        return errInvalidChanNumber;
    }

    /* Set the playing rate: */
    dsmChannels[channel].rate = rate;

    return OK;
}




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

int CALLING dsmGetRate(unsigned channel, ulong *rate)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmGetRate);
        return errInvalidChanNumber;
    }

    if ( (dsmChannels[channel].status == dsmChanStopped) ||
        (dsmChannels[channel].status == dsmChanEnd) )
    {
        /* Nothing is being played - write 0 to *rate: */
        *rate = 0;
    }
    else
    {
        /* Write the playing rate: */
        *rate = dsmChannels[channel].rate;
    }

    return OK;
}




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

int CALLING dsmSetVolume(unsigned channel, unsigned volume)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmSetVolume);
        return errInvalidChanNumber;
    }

    /* Set the volume: */
    dsmChannels[channel].volume = volume;

    return OK;
}




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

int CALLING dsmGetVolume(unsigned channel, unsigned *volume)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmGetVolume);
        return errInvalidChanNumber;
    }

    /* Get the volume: */
    *volume = dsmChannels[channel].volume;

    return OK;
}




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

int CALLING dsmSetSample(unsigned channel, unsigned smpHandle)
{
    dsmChannel  *chan;
    dsmSample   *sample;
    int         error;

    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmSetSample);
        return errInvalidChanNumber;
    }

    /* Check that the sample handle is valid and the sample is in use: */
    if ( (smpHandle > MAXSAMPLES) || (dsmSamples[smpHandle-1].inUse == 0) )
    {
        ERROR(errInvalidSampleHandle, ID_dsmSetSample);
        return errInvalidSampleHandle;
    }

    chan = &dsmChannels[channel];
    sample = &dsmSamples[smpHandle-1];

    /* Set new sample number to channel: */
    chan->sampleHandle = smpHandle;

    /* Sample has been changed: */
    chan->sampleChanged = 1;

    /* If the new sample has one Amiga-compatible loop and playing has ended
       (not released or stopped), set the new sample and start playing from
       loop start: */
    if ( (sample->loopMode == sdLoopAmiga) && (chan->status == dsmChanEnd) )
    {
        /* Set sample and start playing: */
        chan->status = dsmChanPlaying;
        if ( (error = dsmSetPosition(channel, sample->loop1Start)) != OK )
            PASSERROR(ID_dsmSetSample)
    }

    return OK;
}




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

int CALLING dsmGetSample(unsigned channel, unsigned *smpHandle)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmGetSample);
        return errInvalidChanNumber;
    }

    /* Write sample handle to *smpHandle: */
    *smpHandle = dsmChannels[channel].sampleHandle;

    return OK;
}




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

int CALLING dsmChangeSample(unsigned channel)
{
    dsmChannel  *chan = &dsmChannels[channel];
    dsmSample   *sample = &dsmSamples[chan->sampleHandle-1];

    /* Start using the sample specified by chan->sampleHandle: */

    chan->sample = sample->sample;
    chan->sampleType = sample->sampleType;
    chan->samplePos = sample->samplePos;
    chan->sampleLength = sample->sampleLength;
    chan->loopMode = sample->loopMode;
    chan->loop1Start = sample->loop1Start;
    chan->loop1End = sample->loop1End;
    chan->loop1Type = sample->loop1Type;
    chan->loop2Start = sample->loop2Start;
    chan->loop2End = sample->loop2End;
    chan->loop2Type = sample->loop2Type;
    chan->sampleChanged = 0;

    return OK;
}




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

int CALLING dsmSetPosition(unsigned channel, unsigned position)
{
    dsmChannel  *chan;
    int         error;

    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmSetPosition);
        return errInvalidChanNumber;
    }

    chan = &dsmChannels[channel];

    /* Convert position from bytes to samples: */
    position = position >> dsmSampleShift(chan->sampleType);

    /* Check if sample has been changed, and if so, set the values to the
       channel structure: */
    if ( chan->sampleChanged )
    {
        if ( (error = dsmChangeSample(channel)) != OK )
            PASSERROR(ID_dsmSetPosition)

        /* If channel status is released and the new channel does not have
           two loops, end the sample: */
        if ( (chan->loopMode != sdLoop1Rel) && (chan->loopMode != sdLoop2) &&
            (chan->status == dsmChanReleased) )
        {
            chan->status = dsmChanEnd;
            return OK;
        }
    }

    /* Check that sample and playing rate have been set on the channel: */
    if ( (chan->sampleHandle != 0) && (chan->rate != 0) )
    {
        switch ( chan->status )
        {
            case dsmChanEnd:
            case dsmChanPlaying:
                /* Either playing sample before releasing or playing has
                   ended - check the first loop type: */
                chan->loopNum = 1;
                switch ( chan->loop1Type )
                {
                    case loopNone:
                        /* No looping - if position is below sample end, set
                           it and start playing there: */
                        if ( position < chan->sampleLength )
                        {
                            chan->playPos = position;
                            chan->playPosLow = 0;
                            chan->status = dsmChanPlaying;
                            chan->direction = dsmPlayForward;
                        }
                        else
                            chan->status = dsmChanEnd;
                        break;

                    case loopUnidir:
                        /* Unidirectional looping - if position is below
                           loop end, set it, otherwise set loop start as the
                           new position. Start playing in any case: */
                        if ( position < chan->loop1End )
                            chan->playPos = position;
                        else
                            chan->playPos = chan->loop1Start;
                        chan->playPosLow = 0;
                        chan->status = dsmChanPlaying;
                        chan->direction = dsmPlayForward;
                        break;

                    case loopBidir:
                        /* Bidirectional looping - if position is below loop
                           end, set it and start playing forward, otherwise
                           set loop end as the new position and start playing
                           backwards: */
                        if ( position < chan->loop1End )
                        {
                            chan->playPos = position;
                            chan->direction = dsmPlayForward;
                        }
                        else
                        {
                            chan->playPos = chan->loop1End;
                            chan->direction = dsmPlayBackwards;
                        }
                        chan->playPosLow = 0;
                        chan->status = dsmChanPlaying;
                }
                break;

            case dsmChanReleased:
                /* Playing after sample has been released - check second loop
                   type: */
                chan->loopNum = 2;
                switch ( chan->loop2Type )
                {
                    case loopNone:
                        /* No looping - if position is below sample end, set
                           it and start playing there: */
                        if ( position < chan->sampleLength )
                        {
                            chan->playPos = position;
                            chan->playPosLow = 0;
                            chan->status = dsmChanPlaying;
                            chan->direction = dsmPlayForward;
                        }
                        else
                            chan->status = dsmChanEnd;
                        break;

                    case loopUnidir:
                        /* Unidirectional looping - if position is below
                           loop end, set it, otherwise set loop start as the
                           new position. Start playing in any case: */
                        if ( position < chan->loop2End )
                            chan->playPos = position;
                        else
                            chan->playPos = chan->loop2Start;
                        chan->playPosLow = 0;
                        chan->status = dsmChanPlaying;
                        chan->direction = dsmPlayForward;
                        break;

                    case loopBidir:
                        /* Bidirectional looping - if position is below loop
                           end, set it and start playing forward, otherwise
                           set loop end as the new position and start playing
                           backwards: */
                        if ( position < chan->loop2End )
                        {
                            chan->playPos = position;
                            chan->direction = dsmPlayForward;
                        }
                        else
                        {
                            chan->playPos = chan->loop2End;
                            chan->direction = dsmPlayBackwards;
                        }
                        chan->playPosLow = 0;
                        chan->status = dsmChanPlaying;
                }
                break;

            case dsmChanStopped:
            default:
                /* If sound has been stopped do nothing: */
                break;
        }
    }

    return OK;
}




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

int CALLING dsmGetPosition(unsigned channel, unsigned *position)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmGetPosition);
        return errInvalidChanNumber;
    }

    /* Write position to *position and convert to bytes: */
    *position = dsmChannels[channel].playPos << dsmSampleShift(
        dsmChannels[channel].sampleType);;

    return OK;
}




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

int CALLING dsmGetDirection(unsigned channel, int *direction)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmGetDirection);
        return errInvalidChanNumber;
    }

    /* Write position to *position: */
    *direction = dsmChannels[channel].direction;

    return OK;
}




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

int CALLING dsmSetPanning(unsigned channel, int panning)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmSetPanning);
        return errInvalidChanNumber;
    }

    /* Set panning position to channel: */
    dsmChannels[channel].panning = panning;

    return OK;
}




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

int CALLING dsmGetPanning(unsigned channel, int *panning)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmGetPanning);
        return errInvalidChanNumber;
    }

    /* Write panning position to *panning: */
    *panning = dsmChannels[channel].panning;

    return OK;
}




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

int CALLING dsmMuteChannel(unsigned channel, int mute)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmMuteChannel);
        return errInvalidChanNumber;
    }

    /* Set muting status: */
    dsmChannels[channel].muted = mute;

    return OK;
}




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
* Notes:        If copySample = 1, sample data must not be in EMS memory.
*               If copySample = 0 and sample is 16-bit, the sample data WILL
*               be modified by this function.
*
\****************************************************************************/

int CALLING dsmAddSample(sdSample *sample, int copySample, unsigned
    *smpHandle)
{
    int         i, handle, error;
    static void *copyDest;
    dsmSample   *dsmSmp;
    unsigned    destLength;             /* destination sample length */
    int         smpShift;

    /* Find first unused sample handle: */
    handle = 0;
    for ( i = 0; i < MAXSAMPLES; i++ )
    {
        if ( dsmSamples[i].inUse == 0 )
        {
            handle = i+1;
            break;
        }
    }

    /* Check if an empty handle was found. If not, return an error: */
    if ( handle == 0 )
    {
        ERROR(errNoSampleHandles, ID_dsmAddSample);
        return errNoSampleHandles;
    }

    /* Point dsmSmp to new sample: */
    dsmSmp = &dsmSamples[handle-1];

    /* Mark sample used: */
    dsmSmp->inUse = 1;

    smpShift = dsmSampleShift(sample->sampleType);

    /* Copy sample information: */
    dsmSmp->sampleType = sample->sampleType;
    dsmSmp->sampleLength = sample->sampleLength >> smpShift;
    dsmSmp->loopMode = sample->loopMode;
    dsmSmp->loop1Start = sample->loop1Start >> smpShift;
    dsmSmp->loop1End = sample->loop1End >> smpShift;
    dsmSmp->loop1Type = sample->loop1Type;
    dsmSmp->loop2Start = sample->loop2Start >> smpShift;
    dsmSmp->loop2End = sample->loop2End >> smpShift;
    dsmSmp->loop2Type = sample->loop2Type;

    if ( (sample->sampleType == smpNone) || (sample->sampleLength == 0) ||
        (sample->sample == NULL) || (sample->samplePos == sdSmpNone) )
    {
        /* There is no sample - set up DSM sample structure accordingly: */
        dsmSmp->sampleType = smpNone;
        dsmSmp->sampleLength = 0;
        dsmSmp->sample = NULL;
        dsmSmp->copied = 0;
        dsmSmp->samplePos = sdSmpNone;
    }
    else
    {
        if ( copySample )
        {
            /* Sample data should be copied elsewhere in memory */
            destLength = sample->sampleLength;

            /* Allocate memory for sample: */
            if ( (error = memAlloc(destLength, (void**) &dsmSmp->sample))
                != OK )
                PASSERROR(ID_dsmAddSample)

            copyDest = dsmSmp->sample;

            /* Sample is in conventional memory: */
            dsmSmp->samplePos = sdSmpConv;

            /* Copy sample data: */
            mMemCopy(copyDest, sample->sample, destLength);

            /* Sample is copied and should be deallocated when removed: */
            dsmSmp->copied = 1;
        }
        else
        {
            /* There is sample data, but it should not be copied - copy sample
               pointer and position: */
            dsmSmp->sample = sample->sample;
            dsmSmp->samplePos = sample->samplePos;
            dsmSmp->copied = 0;
        }
    }

    /* Write sample handle to *smpHandle: */
    *smpHandle = handle;

    return OK;
}




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

int CALLING dsmRemoveSample(unsigned smpHandle)
{
    dsmSample   *sample;
    int         error;

    /* Check that the sample handle is valid and the sample is in use: */
    if ( (smpHandle > MAXSAMPLES) || (dsmSamples[smpHandle-1].inUse == 0) )
    {
        ERROR(errInvalidSampleHandle, ID_dsmRemoveSample);
        return errInvalidSampleHandle;
    }

    sample = &dsmSamples[smpHandle-1];

    /* Mark sample unused: */
    sample->inUse = 0;

    /* Check if sample data should be deallocated: */
    if ( sample->copied )
    {
        if ( (error = memFree(sample->sample)) != OK )
            PASSERROR(ID_dsmRemoveSample)
    }

    return OK;
}




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

int CALLING dsmMixData(unsigned numElems)
{
    int         error;
    unsigned    ch;
    unsigned    volume;
    dsmChannel  *chan;
    void        *mixRoutine;

    /* If playing is paused, no channels are open or data on channels may not
       be used, just clear the buffer and exit: */
    if ( dsmPaused || (dsmChOpen == 0) || (!dsmChPlay) )
    {
        if ( (error = dsmClearBuffer(numElems)) != OK )
            PASSERROR(ID_dsmMixData)
        return OK;
    }

    for ( ch = 0; ch < dsmChOpen; ch++ )
    {
        chan = &dsmChannels[ch];

        /* Point mixRoutine to correct low-level mixing routine: */
        mixRoutine = mixingRoutines[dsmMode][chan->sampleType];

        /* If current channel is muted or DSM is muted, set channel volume to
           zero, otherwise calculate it: */
        if ( chan->muted || dsmMuted )
            volume = 0;
        else
            volume = (chan->volume * dsmMasterVolume) / 64;

        /* Mix data for this channel: */
        if ( (error = dsmMix(ch, mixRoutine, volume, numElems)) != OK )
            PASSERROR(ID_dsmMixData)
    }

    return OK;
}



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
    bufferLength, int sampleType, ulong rate)
{
    dsmChannel  *chan;

    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmStartStream);
        return errInvalidChanNumber;
    }

    chan = &dsmChannels[channel];

    /* Set up channel for playing the stream: */
    chan->sample = buffer;
    chan->sampleType = sampleType;
    chan->samplePos = sdSmpConv;
    chan->sampleLength = bufferLength >> dsmSampleShift(sampleType);
    chan->loopMode = sdLoop1;
    chan->loop1Start = 0;
    chan->loop1End = bufferLength >> dsmSampleShift(sampleType);
    chan->loop1Type = loopUnidir;
    chan->loop2Start = chan->loop2End = 0;
    chan->loop2Type = sdLoopNone;
    chan->playPos = chan->playPosLow = 0;
    chan->rate = rate;
    chan->direction = dsmPlayForward;
    chan->sampleHandle = DSM_SMP_STREAM;        /* magic */
    chan->sampleChanged = 0;
    chan->panning = panMiddle;
    chan->volume = 64;
    chan->muted = 0;
    chan->loopNum = 1;
    chan->status = dsmChanPlaying;
    chan->streamWritePos = 0;

    return OK;
}




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

int CALLING dsmStopStream(unsigned channel)
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmStopSound);
        return errInvalidChanNumber;
    }

    /* Stop sound: */
    dsmChannels[channel].status = dsmChanStopped;

    return OK;
}




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
    void (CALLING *callback)(unsigned channel))
{
    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmStopSound);
        return errInvalidChanNumber;
    }

    /* Set callback: */
    dsmChannels[channel].LoopCallback = callback;

    return OK;
}




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

int CALLING dsmSetStreamWritePosition(unsigned channel, unsigned position)
{
    dsmChannel  *chan;

    /* Check that the channel number is legal and channels are open: */
    if ( channel >= dsmChOpen )
    {
        ERROR(errInvalidChanNumber, ID_dsmSetStreamWritePosition);
        return errInvalidChanNumber;
    }

    chan = &dsmChannels[channel];

    chan->streamWritePos = position >> dsmSampleShift(chan->sampleType);

    return OK;
}




#endif /* #ifdef SUPPORTSTREAMS */




/*
 * $Log: dsm.c,v $
 * Revision 1.11  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.10  1997/01/16 18:19:10  pekangas
 * Added support for setting the stream write position.
 * Stream data is no longer played past the write position
 *
 * Revision 1.9  1996/10/09 15:54:22  pekangas
 * Fixed dsmReleaseSound() to work as specified
 *
 * Revision 1.8  1996/07/13 19:44:22  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.7  1996/07/13 18:40:48  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.6  1996/06/26 19:14:55  pekangas
 * Added sample loop callbacks
 *
 * Revision 1.5  1996/05/30 21:10:27  pekangas
 * Fixed a small bug in looping other samples than 8-bit mono
 *
 * Revision 1.4  1996/05/28 20:31:11  pekangas
 * Added support for 8-bit stereo and 16-bit mono and stereo samples
 *
 * Revision 1.3  1996/05/26 20:55:39  pekangas
 * Implemented digital audio stream support
 *
 * Revision 1.2  1996/05/24 16:19:39  jpaana
 * Misc fixes for Linux
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/