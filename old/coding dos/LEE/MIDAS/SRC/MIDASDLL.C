/*      midasdll.c
 *
 * MIDAS DLL programming interface
 *
 * $Id: midasdll.c,v 1.6 1997/01/16 19:57:19 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#if defined(__NT__) || defined(__WINDOWS__)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#endif

#include "midas.h"

/* This is a kluge, but necessary as Watcom C sucks: */
#if defined(DLL_EXPORT)
#define EXPORT_IN_MIDASDLL_H
#endif

#include "midasdll.h"


RCSID(const char *midasdll_rcsid = "$Id: midasdll.c,v 1.6 1997/01/16 19:57:19 pekangas Exp $";)


    /* Channel numbers used with gmpPlaySong(): */
static unsigned midasSDChannels[32] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
    12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31 };

static int      lastError;
static int      MIDASthread = 0;
#ifdef __WIN32__
static volatile int DLLinUse = 0;
#endif
static int      midasFxInit, midasStrInit;


_FUNC(int) MIDASgetLastError(void)
{
    return lastError;
}


_FUNC(char*) MIDASgetErrorMessage(int errorCode)
{
    return errorMsg[errorCode];
}




/****************************************************************************\
*
* Function:     BOOL MIDASstartup(void)
*
* Description:  Sets all configuration variables to default values and
*               prepares MIDAS for use. This function must be called before
*               ANY other MIDAS function, including MIDASinit and
*               MIDASsetOption. After this function has been called,
*               MIDASclose can be called at any point, regarless of whether
*               MIDAS has been initialized or not.
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASstartup(void)
{
    MIDASthread = 0;
    midasFxInit = 0;
    midasStrInit = 0;
    midasSetDefaults();

    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDASdetectSD(void)
*
* Description:  Attempts to detect a Sound Device. Sets the global variable
*               midasSD to point to the detected Sound Device or NULL if no
*               Sound Device was detected
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASdetectSD(void)
{
    int         dsd;
    int         error;
    static int  dResult;

    midasSD = NULL;                     /* no Sound Device detected yet */
    midasSDNumber = -1;
    dsd = 0;                            /* start from first Sound Device */

    /* search through Sound Devices until a Sound Device is detected: */
    while ( (midasSD == NULL) && (dsd < NUMSDEVICES) )
    {
        /* attempt to detect current SD: */
        if ( (error = (*midasSoundDevices[dsd]->Detect)(&dResult)) != OK )
        {
            lastError = error;
            return FALSE;
        }
        if ( dResult == 1 )
        {
            midasSDNumber = dsd;        /* Sound Device detected */
            /* point midasSD to this Sound Device: */
            midasSD = midasSoundDevices[dsd];
        }
        dsd++;                          /* try next Sound Device */
    }

    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL midasInit(void);
*
* Description:  Initializes MIDAS Sound System
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASinit(void)
{
    int         error;
    static int  dResult;

    midasEMSInit = 0;
    mUseEMS = 0;

    if ( midasSDNumber == -1 )      /* has a Sound Device been selected? */
    {
        /* attempt to detect Sound Device */
        if ( !MIDASdetectSD() )
        {
            return FALSE;
        }

        if ( midasSD == NULL )
        {
            lastError = errSDFailure;
            return FALSE;
        }
    }
    else
    {
        /* use selected Sound Device: */
        midasSD = midasSoundDevices[midasSDNumber];

        /* Sound Device number was forced, but if no I/O port, IRQ, DMA or
           sound card type has been set, try to autodetect the values for this
           Sound Device. If detection fails, use default values: */

        if ( (midasSDPort == -1) && (midasSDIRQ == -1) &&
            (midasSDDMA == -1) && (midasSDCard == -1) )
            if ( (error = midasSD->Detect(&dResult)) != OK )
            {
                lastError = error;
                return FALSE;
            }
    }

    if ( midasSDPort != -1 )            /* has an I/O port been selected? */
        midasSD->port = midasSDPort;    /* if yes, set it to Sound Device */
    if ( midasSDIRQ != -1 )             /* SD IRQ number? */
        midasSD->IRQ = midasSDIRQ;      /* if yes, set it to Sound Device */
    if ( midasSDDMA != -1 )             /* SD DMA channel number? */
        midasSD->DMA = midasSDDMA;
    if ( midasSDCard != -1 )            /* sound card type? */
        midasSD->cardType = midasSDCard;

#if defined (__DOS__) && (!defined(NOTIMER))
    /* initialize TempoTimer: */
    if ( (error = tmrInit()) != OK )
    {
        lastError = error;
        return FALSE;
    }

    midasTMRInit = 1;                 /* TempoTimer initialized */
#endif

    /* initialize Sound Device: */
    if ( (error = midasSD->Init(midasMixRate, midasOutputMode)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    midasSDInit = 1;                  /* Sound Device initialized */


#if defined (__DOS__) && (!defined(NOTIMER))
    /* start playing sound using the timer: */
    if ( (error = tmrPlaySD(midasSD)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    midasTMRPlay = 1;
#endif


    /* Initialize Generic Module Player: */
    if ( (error = gmpInit(midasSD)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    midasGMPInit = 1;

    /* Initialize Sound Effects library: */
    if ( (error = fxInit(midasSD)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    midasFxInit = 1;

#ifdef SUPPORTSTREAMS
    /* Initialize stream player library: */
    if ( (error = strInit(midasSD)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    midasStrInit = 1;
#endif

    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDASclose(void)
*
* Description:  Uninitializes MIDAS Sound System
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASclose(void)
{
    int         error;

#if defined(__WIN32__) || defined(__LINUX__)
    /* Stop playing thread: */
    if ( MIDASthread )
        MIDASstopBackgroundPlay();
#endif

#if defined (__DOS__) && (!defined(NOTIMER))
    /* if music is being played with timer, stop it: */
    if ( midasTMRMusic )
    {
        if ( (error = gmpSetUpdRateFunct(NULL)) != OK )
        {
            lastError = error;
            return FALSE;
        }
        if ( (error = tmrStopMusic(midasPlayerNum)) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasTMRMusic = 0;
    }
#endif


#ifdef SUPPORTSTREAMS
    /* Uninitialize stream player if initialized: */
    if ( midasStrInit )
    {
        if ( (error = strClose()) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasStrInit = 0;
    }
#endif

    /* Uninitialize sound effect library if initialized: */
    if ( midasFxInit )
    {
        if ( (error = fxClose()) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasFxInit = 0;
    }

    /* If music is being played, stop it: */
    if ( midasGMPPlay )
    {
        if ( (error = gmpStopSong(midasPlayHandle)) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasGMPPlay = 0;
    }

    /* If Generic Module Player has been initialized, uninitialize it: */
    if ( midasGMPInit )
    {
        if ( (error = gmpClose()) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasGMPInit = 0;
    }

    /* if Sound Device channels are open, close them: */
    if ( midasSDChans )
    {
        if ( (error = midasSD->CloseChannels()) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasSDChans = 0;
        midasChannels = 0;
    }

#if defined (__DOS__) && (!defined(NOTIMER))
    /* if sound is being played, stop it: */
    if ( midasTMRPlay )
    {
        if ( (error = tmrStopSD()) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasTMRPlay = 0;
    }
#endif

    /* if Sound Device is initialized, uninitialize it: */
    if ( midasSDInit )
    {
        if ( (error = midasSD->Close()) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasSDInit = 0;
        midasSD = NULL;
    }

#if defined (__DOS__) && (!defined(NOTIMER))
    /* if TempoTimer is initialized, uninitialize it: */
    if ( midasTMRInit )
    {
        if ( (error = tmrClose()) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasTMRInit = 0;
    }
#endif


    return TRUE;
}


/****************************************************************************\
*
* Function:     BOOL MIDASclose(void)
*
* Description:  Uninitializes MIDAS Sound System
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(char*) MIDASgetVersionString(void)
{
    return MVERSTR;
}



/****************************************************************************\
*
* Function:     BOOL MIDASopenChannels(int numChans);
*
* Description:  Opens Sound Device channels for sound and music output.
*
* Input:        int numChans            Number of channels to open
*
* Notes:        Channels opened with this function can be used for sound
*               playing, and modules played with midasPlayModule() will be
*               played through the last of these channels. This function is
*               provided so that the same number of channels can be open
*               the whole time throughout the execution of the program,
*               keeping the volume level constant. Note that you must ensure
*               that you open enough channels for all modules, otherwise
*               midasPlayModule() will fail.
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASopenChannels(int numChans)
{
    int         error;

    midasChannels = numChans;

    /* open Sound Device channels: */
    if ( (error = midasSD->OpenChannels(numChans)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    midasSDChans = 1;

    /* set amplification level if forced: */
    if ( midasAmplification != -1 )
    {
        if ( (error = midasSD->SetAmplification(midasAmplification)) != OK )
        {
            lastError = error;
            return FALSE;
        }
    }

    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDAScloseChannels(void);
*
* Description:  Closes Sound Device channels opened with midasOpenChannels().
*               Do NOT call this function unless you have opened the sound
*               channels used yourself with midasOpenChannels().
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDAScloseChannels(void)
{
    int         error;

    /* Close Sound Device channels: */
    if ( (error = midasSD->CloseChannels()) != OK )
    {
        lastError = error;
        return FALSE;
    }
    midasSDChans = 0;
    midasChannels = 0;

    return TRUE;
}



/****************************************************************************\
*
* Function:     MIDASmodule MIDASloadModule(char *fileName)
*
* Description:  Loads a module into memory
*
* Input:        char *fileName          module file name
*
* Returns:      Module handle if successful, NULL if failed
*
\****************************************************************************/

_FUNC(MIDASmodule) MIDASloadModule(char *fileName)
{
    static fileHandle  f;
    static char buf[64];
    int         error;
    static gmpModule *module;

    /* Check the module type and use the correct module loader
       (fixme, hardwired types and poor detection) */
    if ( (error = fileOpen(fileName, fileOpenRead, &f)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    if ( (error = fileRead(f, buf, 48)) != OK )
    {
        fileClose(f);
        lastError = error;
        return FALSE;
    }
    if ( (error = fileClose(f)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    if ( mMemEqual(buf, "Extended Module:", 16) )
    {
        /* It's a FastTracker module: */
        error = gmpLoadXM(fileName, 1, NULL, &module);
    }
    else
    {
        if ( mMemEqual(buf+44, "SCRM", 4) )
        {
            /* It's a Scream Tracker 3 module */
            error = gmpLoadS3M(fileName, 1, NULL, &module);
        }
        else
        {
            /* None of the above - we'll assume it's a Protracker module,
               the loader will fail if this is not the case */
            error = gmpLoadMOD(fileName, 1, NULL, &module);
        }
    }

    if ( error != OK )
    {
        lastError = error;
        return NULL;
    }

    return (MIDASmodule) module;
}




/****************************************************************************\
*
* Function:     BOOL MIDASplayModule(MIDASmodule module,
*                   int numEffectChannels)
*
* Description:  Starts playing a Generic Module Player module loaded to memory
*
* Input:        gmpModule *module       Pointer to loaded module structure
*               int numEffectChns       Number of channels to open for sound
*                                       effects. Ignored if sound channels
*                                       have already been opened with
*                                       midasOpenChannels().
*
* Returns:      TRUE if successful, FALSE if not
*
* Notes:        The Sound Device channels available for sound effects are the
*               _first_ numEffectChns channels. So, for example, if you use
*               midasPlayModule(module, 3), you can use channels 0-2 for sound
*               effects. If you already have opened channels with
*               midasOpenChannels(), the module will be played with the last
*               possible channels, so that the first channels will be
*               available for sound effects. Note that if not enough channels
*               are open this function will fail.
*
\****************************************************************************/

_FUNC(BOOL) MIDASplayModule(MIDASmodule module, int numEffectChannels)
{
    short       numChans;
    int         error;
    int         firstChannel;
    gmpModule   *gmpmod = (gmpModule*) module;

    numChans = gmpmod->numChannels;

    /* Open Sound Device channels if not already open: */
    if ( midasChannels == 0 )
    {
        if ( (error = midasSD->OpenChannels(numChans + numEffectChannels))
            != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasSDChans = 1;
        firstChannel = numEffectChannels;

        /* set amplification level if forced: */
        if ( midasAmplification != -1 )
        {
            if ( (error = midasSD->SetAmplification(midasAmplification))
                != OK )
            {
                lastError = error;
                return FALSE;
            }
        }
    }
    else
    {
        if ( midasChannels < numChans )
        {
            lastError = errNoChannels;
            return FALSE;
        }
        firstChannel = midasChannels - numChans;
    }

    /* Start playing the whole song in the module using the last Sound Device
       channels: */
    if ( (error = gmpPlaySong(gmpmod    , -1, -1, -1, -1,
        &midasSDChannels[firstChannel], &midasPlayHandle)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    midasGMPPlay = 1;

#if defined (__DOS__) && (!defined(NOTIMER))
    /* Start playing using the timer: */
    if ( (error = tmrPlayMusic(&gmpPlay, &midasPlayerNum)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    if ( (error = gmpSetUpdRateFunct(&tmrSetUpdRate)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    midasTMRMusic = 1;
#endif


    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDASstopModule(gmpModule *module)
*
* Input:        gmpModule *module       the module which is being played
*
* Description:  Stops playing a module and uninitializes the Module Player.
*               If sound channels were NOT opened through midasOpenChannels(),
*               but by letting midasPlayModule() open them, they will be
*               closed. Sound channels opened with midasOpenChannels() are NOT
*               closed and must be closed separately.
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASstopModule(MIDASmodule module)
{
    int         error, i;
    gmpModule   *gmpmod = (gmpModule*) module;

#if defined (__DOS__) && (!defined(NOTIMER))
    /* Stop playing music with timer: */
    if ( (error = gmpSetUpdRateFunct(NULL)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    if ( (error = tmrStopMusic(midasPlayerNum)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    midasTMRMusic = 0;
#endif

    /* Stop playing the module: */
    if ( (error = gmpStopSong(midasPlayHandle)) != OK )
    {
        lastError = error;
        return FALSE;
    }
    midasGMPPlay = 0;
    midasPlayHandle = NULL;

    /* If Sound Device channels were not opened with midasOpenChannels(),
       close them: */
    if ( midasChannels == 0 )
    {
        if ( (error = midasSD->CloseChannels()) != OK )
        {
            lastError = error;
            return FALSE;
        }
        midasSDChans = 0;
    }
    else
    {
        /* Sound Device channels were originally opened with
           midasOpenChannels(). Now stop sounds from the channels used by
           the Module Player: */
        for ( i = (midasChannels - gmpmod->numChannels); i < midasChannels;
            i++ )
        {
            if ( (error = midasSD->StopSound(i)) != OK )
            {
                lastError = error;
                return FALSE;
            }
            if ( (error = midasSD->SetVolume(i, 0)) != OK )
            {
                lastError = error;
                return FALSE;
            }
        }
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASfreeModule(MIDASmodule module)
*
* Description:  Deallocates a module loaded with MIDASloadModule();
*
* Input:        DWORD module            module handle
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASfreeModule(MIDASmodule module)
{
    int         error;

    if ( (error = gmpFreeModule((gmpModule*) module)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASstartBackgroundPlay(DWORD pollRate)
*
* Description:  Starts playing music in the background
*
* Input:        DWORD pollRate          polling rate (in Hz - polls per
*                                       second)
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASstartBackgroundPlay(DWORD pollRate)
{
#if defined(__WIN32__) || defined(__LINUX__)
    DWORD       pollPeriod;

    /* Calculate delay between polls - default is 20ms, otherwise calculate
       delay based on rate, and divide by two to make sure polling is done
       at least often enough */
    if ( !pollRate )
        pollPeriod = 20;
    else
        pollPeriod = 1000 / pollRate / 2;

    StartPlayThread(pollPeriod);
    MIDASthread = 1;
#else
    pollRate = pollRate;
#endif
    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDASstopBackgroundPlay(void)
*
* Description:  Stops playing music in the background
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASstopBackgroundPlay(void)
{
#if defined(__WIN32__) || defined(__LINUX__)
    if ( !MIDASthread )
        return TRUE;

    StopPlayThread();
    MIDASthread = 0;
#endif
    return TRUE;
}


#if defined(__WIN32__) || defined(__LINUX__)


/****************************************************************************\
*
* Function:     BOOL MIDASpoll(void)
*
* Description:  Polls the sound and music player manually
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASpoll(void)
{
    PollMIDAS();

    return TRUE;
}


#endif /* #if defined(__WIN32__) || defined(__LINUX__) */





/****************************************************************************\
*
* Function:     BOOL MIDASsetOption(int option, int value);
*
* Description:  Sets a MIDAS option
*
* Input:        int option              option (see enum MIDASoptions)
*               int value               value for the option
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetOption(int option, int value)
{
    switch ( option )
    {
        case MIDAS_OPTION_MIXRATE:
            midasMixRate = value;
            return TRUE;

        case MIDAS_OPTION_OUTPUTMODE:
            midasOutputMode = value;
            return TRUE;

        case MIDAS_OPTION_MIXBUFLEN:
            mBufferLength = value;
            return TRUE;

        case MIDAS_OPTION_MIXBUFBLOCKS:
            mBufferBlocks = value;
            return TRUE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     MIDASsample MIDASloadRawSample(char *filename, int sampleType,
*                   int loopSample)
*
* Description:  Loads a raw sound effect sample
*
* Input:        char *filename          sample file name
*               int sampleType          sample type
*               int loopSample          1 if sample should be looped
*
* Returns:      MIDAS sample handle, NULL if failed
*
\****************************************************************************/

_FUNC(MIDASsample) MIDASloadRawSample(char *fileName, int sampleType,
    int loopSample)
{
    int         error;
    static unsigned sampleHandle;

    /* Load the sample: */
    if ( (error = fxLoadRawSample(fileName, sampleType, loopSample,
        &sampleHandle)) != OK )
    {
        lastError = error;
        return 0;
    }

    return sampleHandle;
}




/****************************************************************************\
*
* Function:     BOOL MIDASfreeSample(MIDASsample sample)
*
* Description:  Deallocates a sample
*
* Input:        MIDASsample sample      sample to be deallocated
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASfreeSample(MIDASsample sample)
{
    int         error;

    if ( (error = fxFreeSample(sample)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASsetAutoEffectChannels(unsigned firstChannel,
*                   unsigned numChannels)
*
* Description:  Sets the range of channels that can be used for automatic
*               sound effect channels
*
* Input:        unsigned firstChannel   first channel to use
*               unsigned numChannels    number of channels to use
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetAutoEffectChannels(unsigned firstChannel,
    unsigned numChannels)
{
    unsigned    *numbers;
    int         error;
    unsigned    i;
    unsigned    n;

    /* Allocate memory for channel number table: */
    if ( (error = memAlloc(numChannels * sizeof(unsigned), (void**) &numbers))
        != OK )
    {
        lastError = error;
        return FALSE;
    }

    /* Fill the table with the channel numbers: */
    n = firstChannel;
    for ( i = 0; i < numChannels; i++ )
        numbers[i] = n++;

    /* Set the channels: */
    if ( (error = fxSetAutoChannels(numChannels, numbers)) != OK )
    {
        memFree(numbers);
        lastError = error;
        return FALSE;
    }

    /* Free the number table: */
    if ( (error = memFree(numbers)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}




/****************************************************************************\
*
* Function:     MIDASsamplePlayHandle MIDASplaySample(MIDASsample sample,
*                   unsigned channel, int priority, unsigned rate,
*                   unsigned volume, int panning)
*
* Description:  Plays a sound effect sample
*
* Input:        MIDASsample sample      sample to be played
*               unsigned channel        channel the sample should be played
*                                       on, MIDAS_CHANNEL_AUTO for automatic
*                                       selection
*               int priority            sample playing priority, the higher
*                                       the value the higher the priority
*               unsigned rate           initial sample rate
*               unsigned volume         initial volume
*               int panning             initial panning position
*
* Returns:      Sample playing handle or NULL if failed
*
\****************************************************************************/

_FUNC(MIDASsamplePlayHandle) MIDASplaySample(MIDASsample sample,
    unsigned channel, int priority, unsigned rate, unsigned volume,
    int panning)
{
    int         error;
    static unsigned playHandle;

    if ( (error = fxPlaySample(channel, sample, priority, rate, volume,
        panning, &playHandle)) != OK )
    {
        lastError = error;
        return 0;
    }

    /* KLUGE! Add 1 to the handle to make sure NULL is an illegal handle: */
    return playHandle + 1;
}




/****************************************************************************\
*
* Function:     BOOL MIDASstopSample(MIDASsamplePlayHandle sample)
*
* Description:  Stops playing a sample
*
* Input:        MIDASsamplePlayHandle sample    sample playing handle
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASstopSample(MIDASsamplePlayHandle sample)
{
    int         error;

    if ( (error = fxStopSample(sample-1)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASsetSampleRate(MIDASsamplePlayHandle sample,
*                   unsigned rate)
*
* Description:  Changes the sample rate for a sound effect sample that is
*               being played
*
* Input:        MIDASsamplePlayHandle sample    sample to change
*               unsigned rate                   new rate
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetSampleRate(MIDASsamplePlayHandle sample, unsigned rate)
{
    int         error;

    if ( (error = fxSetSampleRate(sample-1, rate)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASsetSampleVolume(MIDASsamplePlayHandle sample,
*                   unsigned volume)
*
* Description:  Changes the volume for a sound effect sample that is being
*               played
*
* Input:        MIDASsamplePlayHandle sample    sample to change
*               unsigned volume                 new volume
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetSampleVolume(MIDASsamplePlayHandle sample,
    unsigned volume)
{
    int         error;

    if ( (error = fxSetSampleVolume(sample-1, volume)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASsetSamplePanning(MIDASsamplePlayHandle sample,
*                   int panning)
*
* Description:  Changes the panning position of a sound effect sample that is
*               being played
*
* Input:        MIDASsamplePlayHandle sample    sample to change
*               int panning                     new panning position
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetSamplePanning(MIDASsamplePlayHandle sample,
    int panning)
{
    int         error;

    if ( (error = fxSetSamplePanning(sample-1, panning)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASsetSamplePriority(MIDASsamplePlayHandle sample,
*                   int priority)
*
* Description:  Changes the playing priority of a sound effect sample that is
*               being played
*
* Input:        MIDASsamplePlayHandle sample    sample to change
*               int priority                    new playing priority
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetSamplePriority(MIDASsamplePlayHandle sample,
    int priority)
{
    int         error;

    if ( (error = fxSetSamplePriority(sample-1, priority)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDASgetPlayStatus(MIDASplayStatus *status)
*
* Description:  Gets current module playing status
*
* Input:        MIDASplayStatus *status     pointer to status structure
*
* Returns:      TRUE if successful, FALSE if not.
*               Module playing status will be written to *status
*
\****************************************************************************/

_FUNC(BOOL) MIDASgetPlayStatus(MIDASplayStatus *status)
{
    static gmpInformation *gmpInfo;
    int         error;

    /* Check that we really are playing something: */
    if ( midasPlayHandle == NULL )
    {
        status->position = status->pattern = status->row = 0;
        return TRUE;
    }

    /* Get information from GMPlayer: */
    if ( (error = gmpGetInformation(midasPlayHandle, &gmpInfo)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    /* Copy them: */
    status->position = gmpInfo->position;
    status->pattern = gmpInfo->pattern;
    status->row = gmpInfo->row;
    status->syncInfo = gmpInfo->syncInfo;

    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDASsetPosition
*
* Description:  Sets module playback position
*
* Input:        int newPosition         new position
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetPosition(int newPosition)
{
    int         error;

    if ( midasPlayHandle == NULL )
        return TRUE;

    if ( (error = gmpSetPosition(midasPlayHandle, newPosition)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASsetMusicVolume
*
* Description:  Sets module playback volume
*
* Input:        unsigned volume     new volume
*
* Returns:      TRUE if successful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetMusicVolume(unsigned volume)
{
    if ( midasPlayHandle == NULL )
        return TRUE;

    midasPlayHandle->masterVolume = volume;

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASgetModuleInfo(MIDASmodule module,
*                   MIDASmoduleInfo *info)
*
* Description:  Gets information about a module
*
* Input:        MIDASmodule module      MIDAS module handle
*               MIDASmoduleInfo *info   pointer to module info structure
*
* Returns:      TRUE if successful, FALSE if not. Module information is
*               written to *info.
*
\****************************************************************************/

_FUNC(BOOL) MIDASgetModuleInfo(MIDASmodule module, MIDASmoduleInfo *info)
{
    gmpModule   *gmpMod = (gmpModule*) module;

    if ( module == NULL )
    {
        lastError = errInvalidArguments;
        return FALSE;
    }

    mMemCopy(info->songName, gmpMod->name, 32);
    info->songName[31] = 0;
    info->songLength = gmpMod->songLength;
    info->numInstruments = gmpMod->numInsts;
    info->numPatterns = gmpMod->numPatts;
    info->songLength = gmpMod->songLength;
    info->numChannels = gmpMod->numChannels;

    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDASgetInstrumentInfo(MIDASmodule module, int instNum,
*                   MIDASinstrumentInfo *info);
*
* Description:  Gets information about an instrument in a module
*
* Input:        MIDASmodule module      MIDAS module handle
*               int instNum             instrument number
*               MIDASinstrumentInfo *info   pointer to destination info struct
*
* Returns:      TRUE if successful, FALSE if not. Instrument information is
*               written to *info.
*
\****************************************************************************/

_FUNC(BOOL) MIDASgetInstrumentInfo(MIDASmodule module, int instNum,
    MIDASinstrumentInfo *info)
{
    gmpModule   *gmpMod = (gmpModule*) module;

    if ( (module == NULL) || (((unsigned) instNum) >= gmpMod->numInsts) )
    {
        lastError = errInvalidArguments;
        return FALSE;
    }

    mMemCopy(info->instName, gmpMod->instruments[instNum]->name, 32);
    info->instName[31] = 0;

    return TRUE;
}


#ifdef SUPPORTSTREAMS



/****************************************************************************\
*
* Function:     MIDASstreamHandle MIDASplayStreamFile(unsigned channel,
*                   char *fileName, unsigned sampleType, unsigned sampleRate,
*                   unsigned bufferLength, int loopStream)
*
* Description:  Starts playing a digital audio stream from a file
*
* Input:        unsigned channel        channel to play the stream on
*               char *fileName          stream file name
*               unsigned sampleType     stream sample type
*               unsigned sampleRate     stream sampling rate
*               unsigned bufferLength   stream buffer length in milliseconds
*               int loopStream          1 if stream should be looped
*
* Returns:      Stream handle or NULL if failed
*
\****************************************************************************/

_FUNC(MIDASstreamHandle) MIDASplayStreamFile(unsigned channel,
    char *fileName, unsigned sampleType, unsigned sampleRate,
    unsigned bufferLength, int loopStream)
{
    int         error;
    strStream   *stream;

    if ( (error = strPlayStreamFile(channel, fileName, sampleType, sampleRate,
        bufferLength, loopStream, &stream)) != OK )
    {
        lastError = error;
        return NULL;
    }

    return (MIDASstreamHandle) stream;
}




/****************************************************************************\
*
* Function:     BOOL MIDASstopStream(MIDASstreamHandle stream)
*
* Description:  Stops playing a stream
*
* Input:        MIDASstreamHandle stream    stream to be stopped
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASstopStream(MIDASstreamHandle stream)
{
    int         error;

    if ( (error = strStopStream((strStream*) stream)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}


/****************************************************************************\
*
* Function:     MIDASstreamHandle MIDASplayStreamPolling(unsigned channel,
                    unsigned sampleType, unsigned sampleRate,
                    unsigned bufferLength);
*
* Description:  Starts playing a stream in polling mode. Use
*               MIDASfeedStreamData() to feed the stream data to the player
*
* Input:        unsigned channel        channel number for the stream
*               unsigned sampleType     stream sample type
*               unsigned sampleRate     stream sampling rate
*               unsigned bufferLength   stream buffer length in milliseconds
*
* Returns:      Stream handle or NULL if failed
*
\****************************************************************************/

_FUNC(MIDASstreamHandle) MIDASplayStreamPolling(unsigned channel,
    unsigned sampleType, unsigned sampleRate, unsigned bufferLength)
{
    int         error;
    strStream   *stream;

    if ( (error = strPlayStreamPolling(channel, sampleType, sampleRate,
        bufferLength, &stream)) != OK )
    {
        lastError = error;
        return NULL;
    }

    return (MIDASstreamHandle) stream;
}



/****************************************************************************\
*
* Function:     unsigned MIDASfeedStreamData(MIDASstreamHandle stream,
                    unsigned char *data, unsigned numBytes, BOOL feedAll)
* Description:  Feeds sample data to a stream that is being played in polling
*               mode.
*
* Input:        MIDASstreamHandle stream    Stream playing handle
*               uchar *data             pointer to stream data
*               unsigned numBytes       number of bytes of data to feed. Note!
*                                       This must be a multiple of the stream
*                                       sample size
*               BOOL feedAll            TRUE if all data should be fed in all
*                                       circumstances. The function will block
*                                       the current thread if this flag is 1
*                                       until all data is fed.
*
* Returns:      The number of bytes of sample data that was actually fed.
*
\****************************************************************************/

_FUNC(unsigned) MIDASfeedStreamData(MIDASstreamHandle stream,
    unsigned char *data, unsigned numBytes, BOOL feedAll)
{
    int         error;
    unsigned    numFed;
    int         iFeedAll;

    if ( feedAll )
        iFeedAll = 1;
    else
        iFeedAll = 0;

    if ( (error = strFeedStreamData((strStream*) stream, data, numBytes,
        iFeedAll, &numFed)) != OK )
    {
        lastError = error;
        return 0;
    }

    return numFed;
}


/****************************************************************************\
*
* Function:     BOOL MIDASsetStreamRate(MIDASstreamHandle stream,
*                   unsigned rate)
*
* Description:  Changes the playback rate of a stream
*
* Input:        MIDASstreamHandle stream    Stream playing handle
*               unsigned rate           New playback sample rate, in Hz
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetStreamRate(MIDASstreamHandle stream, unsigned rate)
{
    int         error;

    if ( (error = strSetStreamRate((strStream*) stream, rate)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



/****************************************************************************\
*
* Function:     BOOL MIDASsetStreamVolume(MIDASstreamHandle stream,
*                   unsigned volume)
*
* Description:  Changes the playback volume of a stream
*
* Input:        MIDASstreamHandle stream    Stream playing handle
*               unsigned volume         New volume
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetStreamVolume(MIDASstreamHandle stream, unsigned volume)
{
    int         error;

    if ( (error = strSetStreamVolume((strStream*) stream, volume)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}




/****************************************************************************\
*
* Function:     BOOL MIDASsetStreamPanning(MIDASstreamHandle stream,
*                   int panning)
*
* Description:  Changes the panning position of a stream
*
* Input:        MIDASstreamHandle stream    Stream playing handle
*               int panning             New panning position
*
* Returns:      TRUE if succesful, FALSE if not
*
\****************************************************************************/

_FUNC(BOOL) MIDASsetStreamPanning(MIDASstreamHandle stream, int panning)
{
    int         error;

    if ( (error = strSetStreamPanning((strStream*) stream, panning)) != OK )
    {
        lastError = error;
        return FALSE;
    }

    return TRUE;
}



#endif /* #ifdef SUPPORTSTREAMS */


#ifdef __WIN32__


int PASCAL WEP(short nParameter)
{
    /* The DLL is being unloaded by a process */

    /* Stop playing in a thread: */
    if ( MIDASthread )
    {
        MIDASstopBackgroundPlay();
    }

    /* Close MIDAS - this can safely be done many times: */
    MIDASclose();

    DLLinUse = 0;

    return 1;
}


/* The DLL main: */


int APIENTRY LibMain(HANDLE hdll, DWORD reason, LPVOID reserved)
{
    switch ( reason )
    {
        case DLL_PROCESS_ATTACH:
            /* The DLL is loaded by a process. Check that the DLL is not in
               use by some other process, and if not, mark that we are in use
               and set to default config: */
            if ( DLLinUse )
                return 0;               /* Only one program can use MIDAS */

            DLLinUse = 1;
            MIDASstartup();

            break;

        case DLL_PROCESS_DETACH:
            /* The DLL is being unloaded by a process */

            /* Stop playing in a thread: */
            if ( MIDASthread )
            {
                MIDASstopBackgroundPlay();
            }

            /* Close MIDAS - this can safely be done many times: */
            MIDASclose();

            DLLinUse = 0;

            break;

        /* We aren't interested in thread creation */
    }

    return 1;
}


#endif /* #ifdef __WIN32__ */


/*
 * $Log: midasdll.c,v $
 * Revision 1.6  1997/01/16 19:57:19  pekangas
 * Removed a couple of Visual C warnings
 *
 * Revision 1.5  1997/01/16 19:43:55  pekangas
 * Removed a warning
 *
 * Revision 1.4  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.3  1997/01/16 18:26:27  pekangas
 * Added numerous new functions
 *
 * Revision 1.2  1996/12/07 22:19:56  pekangas
 * No change
 *
 * Revision 1.1  1996/09/25 18:38:02  pekangas
 * Initial revision
 *
*/