/*      midasfx.c
 *
 * MIDAS sound effect library
 *
 * $Id: midasfx.c,v 1.4 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/


#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "mmem.h"
#include "sdevice.h"
#include "midasfx.h"
#include "file.h"


/* Magic constant that is used to identify playing handles that refer to
   sounds on automatic effect channels: */
#define AUTOMAGIC 0x100

/* Maximum playing handle: */
#define MAXHANDLE 0xFFFE

/* Magic channel number - not found: */
#define NOCHANNEL 0xFFFF



/****************************************************************************\
*       enum fxFunctIDs
*       ---------------
* Description:  Function IDs for sound effect library functions
\****************************************************************************/

enum fxFunctIDs
{
    ID_fxInit = ID_fx,
    ID_fxClose,
    ID_fxLoadRawSample,
    ID_fxFreeSample,
    ID_fxSetAutoChannels,
    ID_fxPlaySample,
    ID_fxStopSample,
    ID_fxSetSampleRate,
    ID_fxSetSampleVolume,
    ID_fxSetSamplePanning,
    ID_fxSetSamplePriority
};



static unsigned numAutoChannels;        /* Number of auto FX channels */
static fxChannel *autoChannels;         /* Automatic effect channels */
static unsigned nextHandle;             /* Next sample playing handle */
static SoundDevice *SD;                 /* Sound Device for the effects */
static unsigned nextChannel;            /* Next automatic channel */



/****************************************************************************\
*
* Function:     int fxInit(void)
*
* Description:  Initializes the sound effect library
*
* Input:        SoundDevice *SD         Pointer to the Sound Device that will
*                                       be used for playing the effects
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxInit(SoundDevice *_SD)
{
    /* Remember the Sound Device: */
    SD = _SD;

    /* We don't have any automatic channels: */
    numAutoChannels = 0;
    autoChannels = NULL;

    nextHandle = AUTOMAGIC;
    nextChannel = 0;

    return OK;
}




/****************************************************************************\
*
* Function:     int fxClose(void)
*
* Description:  Uninitializes the sound effect library
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxClose(void)
{
    int         error;
    unsigned    i;
    unsigned    chan;

    /* Check if we have automatic effect channels. If yes, clear the sounds
       on them and free the channel structures: */
    if ( numAutoChannels != 0 )
    {
        for ( i = 0; i < numAutoChannels; i++ )
        {
            chan = autoChannels[i].sdChannel;

            if ( (error = SD->StopSound(chan)) != OK )
                PASSERROR(ID_fxClose);
        }

        if ( (error = memFree(autoChannels)) != OK )
            PASSERROR(ID_fxClose);
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int fxLoadRawSample(char *fileName, unsigned sampleType,
*                   int loopSample, unsigned *sampleHandle)
*
* Description:  Loads a raw sample file into memory and adds the sample to
*               the sound device.
*
* Input:        char *fileName          sample file name
*               unsigned sampleType     sample type, see enum sdSampleType
*               int loopSample          1 if sample is looped, 0 if not
*               unsigned *sampleHandle  pointer to sample handle variable
*
* Returns:      MIDAS error code. The sample handle for the sample will be
*               written to *sampleHandle.
*
\****************************************************************************/

int CALLING fxLoadRawSample(char *fileName, unsigned sampleType,
    int loopSample, unsigned *sampleHandle)
{
    int         error;
    static char *buffer;
    static fileHandle f;
    static long len;
    static sdSample smp;


    /* Open the sound effect file: */
    if ( (error = fileOpen(fileName, fileOpenRead, &f)) != OK )
        PASSERROR(ID_fxLoadRawSample);

    /* Get file size: */
    if ( (error = fileGetSize(f, &len)) != OK )
    {
        fileClose(f);
        PASSERROR(ID_fxLoadRawSample);
    }

    /* Allocate sample loading buffer: */
    if ( (error = memAlloc(len, (void**) &buffer)) != OK )
    {
        fileClose(f);
        PASSERROR(ID_fxLoadRawSample);
    }

    /* Read the sample: */
    if ( (error = fileRead(f, buffer, len)) != OK )
    {
        fileClose(f);
        memFree(buffer);
        PASSERROR(ID_fxLoadRawSample);
    }

    /* Close the sample file: */
    if ( (error = fileClose(f)) != OK )
    {
        memFree(buffer);
        PASSERROR(ID_fxLoadRawSample);
    }

    /* Build Sound Device sample structure for the sample: */
    smp.sample = buffer;
    smp.samplePos = sdSmpConv;
    smp.sampleType = sampleType;
    smp.sampleLength = len;

    if ( loopSample )
    {
        /* Loop the whole sample: */
        smp.loopMode = sdLoop1;
        smp.loop1Start = 0;
        smp.loop1End = len;
        smp.loop1Type = loopUnidir;
    }
    else
    {
        /* No loop: */
        smp.loopMode = sdLoopNone;
        smp.loop1Start = smp.loop1End = 0;
        smp.loop1Type = loopNone;
    }

    /* No loop 2: */
    smp.loop2Start = smp.loop2End = 0;
    smp.loop2Type = loopNone;

    /* Add the sample to the Sound Device: */
    if ( (error = SD->AddSample(&smp, 1, sampleHandle)) != OK )
    {
        memFree(buffer);
        PASSERROR(ID_fxLoadRawSample);
    }

    /* Deallocate the buffer: */
    if ( (error = memFree(buffer)) != OK )
        PASSERROR(ID_fxLoadRawSample);

    return OK;
}




/****************************************************************************\
*
* Function:     int fxFreeSample(unsigned sample)
*
* Description:  Deallocates a sample and frees it from the Sound Device.
*
* Input:        unsigned sample         sample handle for the sample to be
*                                       deallocated.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxFreeSample(unsigned sample)
{
    int         error;

    /* Just free the sample from the Sound Device: */
    if ( (error = SD->RemoveSample(sample)) != OK )
        PASSERROR(ID_fxFreeSample);

    return OK;
}




/****************************************************************************\
*
* Function:     int fxSetAutoChannels(int numChannels,
*                   unsigned *channelNumbers)
*
* Description:  Sets the channel numbers that can be used as automatic effect
*               channels.
*
* Input:        int numChannels             number of channels that can be
*                                           used
*               unsigned *channelNumbers    pointer to a table that contains
*                                           the channels that can be used
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxSetAutoChannels(int numChannels, unsigned *channelNumbers)
{
    int         error;
    unsigned    i;
    unsigned    chan;
    fxChannel   *fxchan;

    /* Check if there are previous automatic effect channels. If yes, clear
       them and free the channel structures: */
    if ( numAutoChannels != 0 )
    {
        for ( i = 0; i < numAutoChannels; i++ )
        {
            chan = autoChannels[i].sdChannel;

            if ( (error = SD->StopSound(chan)) != OK )
                PASSERROR(ID_fxClose);
        }

        if ( (error = memFree(autoChannels)) != OK )
            PASSERROR(ID_fxClose);
    }

    if ( numChannels )
    {
        /* Allocate memory for channel structures: */
        numAutoChannels = numChannels;
        if ( (error = memAlloc(numChannels * sizeof(fxChannel),
            (void**) &autoChannels)) != OK )
            PASSERROR(ID_fxSetAutoChannels);

        /* Initialize channels: */
        for ( i = 0; i < (unsigned) numChannels; i++ )
        {
            fxchan = &autoChannels[i];
            fxchan->sdChannel = channelNumbers[i];
            fxchan->sampleHandle = 0;
            fxchan->playHandle = 0;
            fxchan->priority = 0;
        }
    }
    else
    {
        /* There are no automatic effect channels: */
        numAutoChannels = 0;
        autoChannels = NULL;
    }

    nextHandle = AUTOMAGIC;
    nextChannel = 0;

    return OK;
}




/****************************************************************************\
*
* Function:     int fxPlaySample(unsigned channel, unsigned sample,
*                   int priority, unsigned rate, unsigned volume, int panning,
*                   unsigned *playHandle)
*
* Description:  Starts playing a sound effect sample on a channel
*
* Input:        unsigned channel        channel number, or fxAutoChannel for
*                                       automatic selection
*               unsigned sample         sample handle
*               int priority            effect priority, the higher the value
*                                       the higher the priority
*               unsigned rate           effect initial sample rate
*               unsigned volume         effect initial volume (0-64)
*               int panning             effect initial panning, see enum
*                                       sdPanning
*               unsigned *playHandle    effect playing handle variable
*
* Returns:      MIDAS error code. The playing handle for the effect will be
*               written to *playHandle.
*
\****************************************************************************/

int CALLING fxPlaySample(unsigned channel, unsigned sample, int priority,
    unsigned rate, unsigned volume, int panning, unsigned *playHandle)
{
    int         error;
    unsigned    chan;
    unsigned    handle;

    if ( channel == fxAutoChannel )
    {
        /* We should select the channel automatically */

        /* Check that we do have automatic channels: */
        if ( numAutoChannels == 0 )
        {
            ERROR(errNoChannels, ID_fxPlaySample);
            return errNoChannels;
        }

        handle = nextHandle;

        /* We'll just use the next automatic channel: */
        autoChannels[nextChannel].sampleHandle = sample;
        autoChannels[nextChannel].priority = priority;
        autoChannels[nextChannel].playHandle = handle;
        chan = autoChannels[nextChannel].sdChannel;

        /* Go to the next channel: */
        nextChannel++;
        if ( nextChannel >= numAutoChannels )
            nextChannel = 0;

        /* Prepare next possible play handle: */
        nextHandle++;
        if ( (nextHandle < AUTOMAGIC) || (nextHandle > MAXHANDLE) )
            nextHandle = AUTOMAGIC;
    }
    else
    {
        /* Just use the channel given: */
        chan = channel;
        handle = chan;
    }

    /* The handle returned will be >= AUTOMAGIC if it refers to a sound on an
       automagic channel, otherwise it is simply the SD channel number */

    /* Stop any previous sound on the channel: */
    if ( (error = SD->StopSound(chan)) != OK )
        PASSERROR(ID_fxPlaySample);

    /* Set the sample to the channel: */
    if ( (error = SD->SetSample(chan, sample)) != OK )
        PASSERROR(ID_fxPlaySample);

    /* Set the new volume to the channel: */
    if ( (error = SD->SetVolume(chan, volume)) != OK )
        PASSERROR(ID_fxPlaySample);

    /* Set the new panning position: */
    if ( (error = SD->SetPanning(chan, panning)) != OK )
        PASSERROR(ID_fxPlaySample);

    /* Play the sound: */
    if ( (error = SD->PlaySound(chan, rate)) != OK )
        PASSERROR(ID_fxPlaySample);

    *playHandle = handle;

    return OK;
}



/****************************************************************************\
*
* Function:     unsigned FindChannel(unsigned playHandle)
*
* Description:  Finds the channel where a sound is being played
*
* Input:        unsigned playHandle     playing handle for the sound
*
* Returns:      Sound Device channel number for the sound, or NOCHANNEL if it
*               is not being played.
*
\****************************************************************************/

static unsigned FindChannel(unsigned playHandle)
{
    unsigned    i;

    if ( playHandle < AUTOMAGIC )
    {
        /* Just a simple channel number: */
        return playHandle;
    }

    /* Search through the channels and try to find the sound: */
    for ( i = 0; i < numAutoChannels; i++ )
    {
        if ( autoChannels[i].playHandle == playHandle )
            return autoChannels[i].sdChannel;
    }

    /* We couldn't find it: */
    return NOCHANNEL;
}



/****************************************************************************\
*
* Function:     int fxStopSample(unsigned playHandle)
*
* Description:  Stops playing a sample
*
* Input:        unsigned playHandle     sample playing handle (from
*                                       fxPlaySample)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxStopSample(unsigned playHandle)
{
    unsigned    chan;
    int         error;

    /* Find the channel number for the sound, exit if it's not being played:*/
    if ( (chan = FindChannel(playHandle)) == NOCHANNEL )
        return OK;

    /* Stop the sound: */
    if ( (error = SD->StopSound(chan)) != OK )
        PASSERROR(ID_fxStopSample);

    return OK;
}



/****************************************************************************\
*
* Function:     int fxSetSampleRate(unsigned playHandle, ulong rate)
*
* Description:  Changes the sample rate for a sample that is being played
*
* Input:        unsigned playHandle     sample playing handle (from
*                                       fxPlaySample)
*               ulong rate              new rate
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxSetSampleRate(unsigned playHandle, ulong rate)
{
    unsigned    chan;
    int         error;

    /* Find the channel number for the sound, exit if it's not being played:*/
    if ( (chan = FindChannel(playHandle)) == NOCHANNEL )
        return OK;

    /* Set the new sample rate: */
    if ( (error = SD->SetRate(chan, rate)) != OK )
        PASSERROR(ID_fxSetSampleRate);

    return OK;
}




/****************************************************************************\
*
* Function:     int fxSetSampleVolume(unsigned playHandle, unsigned volume)
*
* Description:  Changes the volume for a sample that is being played
*
* Input:        unsigned playHandle     sample playing handle (from
*                                       fxPlaySample)
*               unsigned volume         new volume
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxSetSampleVolume(unsigned playHandle, unsigned volume)
{
    unsigned    chan;
    int         error;

    /* Find the channel number for the sound, exit if it's not being played:*/
    if ( (chan = FindChannel(playHandle)) == NOCHANNEL )
        return OK;

    /* Set the new sample rate: */
    if ( (error = SD->SetVolume(chan, volume)) != OK )
        PASSERROR(ID_fxSetSampleVolume);

    return OK;
}




/****************************************************************************\
*
* Function:     int fxSetSamplePanning(unsigned playHandle, int panning)
*
* Description:  Changes the panning position for a sample that is being played
*
* Input:        unsigned playHandle     sample playing handle (from
*                                       fxPlaySample)
*               int panning             new panning position
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxSetSamplePanning(unsigned playHandle, int panning)
{
    unsigned    chan;
    int         error;

    /* Find the channel number for the sound, exit if it's not being played:*/
    if ( (chan = FindChannel(playHandle)) == NOCHANNEL )
        return OK;

    /* Set the new sample rate: */
    if ( (error = SD->SetPanning(chan, panning)) != OK )
        PASSERROR(ID_fxSetSamplePanning);

    return OK;
}




/****************************************************************************\
*
* Function:     int fxSetSamplePriority(unsigned playHandle, int priority)
*
* Description:  Changes the priority for a sample that is being played
*
* Input:        unsigned playHandle     sample playing handle (from
*                                       fxPlaySample)
*               int priority            new playing priority
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING fxSetSamplePriority(unsigned playHandle, int priority)
{
    unsigned    i;

    /* Check that the handle is for an automatic channel - priorities don't
       make sense otherwise: */
    if ( playHandle < AUTOMAGIC )
        return OK;

    /* Try to find the channel the sound is being played on, and set its
       priority if found: */
    for ( i = 0; i < numAutoChannels; i++ )
    {
        if ( autoChannels[i].playHandle == playHandle )
            autoChannels[i].priority = priority;
    }

    return OK;
}


/*
 * $Log: midasfx.c,v $
 * Revision 1.4  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.3  1996/09/28 08:12:40  jpaana
 * Fixed for Linux
 *
 * Revision 1.2  1996/09/25 18:36:41  pekangas
 * Fixed to compile in DOS without warnings
 *
 * Revision 1.1  1996/09/22 23:17:48  pekangas
 * Initial revision
 *
*/