/*      MIDAS.C
 *
 * Simplified MIDAS Sound System API
 *
 * $Id: midas.c,v 1.11 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "midas.h"

RCSID(const char *midas_rcsid = "$Id: midas.c,v 1.11 1997/01/16 18:41:59 pekangas Exp $";)


//#define NOTIMER

#define puts(x)



/****************************************************************************\
*      Global variables:
\****************************************************************************/

SoundDevice     *midasSD;               /* current Sound Device */

#ifdef __WIN32__
SoundDevice     *midasSoundDevices[NUMSDEVICES] =
    { &WinWave,
      &MixNoSound };
#else
#ifdef __LINUX__
SoundDevice     *midasSoundDevices[NUMSDEVICES] =
    { &OSS };
#else
SoundDevice     *midasSoundDevices[NUMSDEVICES] =
    {
      &GUS,
      &GDC,
      &PAS,
      &WSS,
      &SB,
      &NoSound };
#endif
#endif

gmpPlayHandle   midasPlayHandle;        /* Generic Module Player playing
                                           handle */

int             midasDisableEMS;        /* 1 if EMS usage is disabled
                                           (default 0) */
int             midasSDNumber;          /* Sound Device number (-1 for
                                           autodetect, default -1) */
int             midasSDPort;            /* Sound Device I/O port number
                                           (-1 for autodetect or SD default,
                                           default -1) */
int             midasSDIRQ;             /* Sound Device IRQ number (-1 for
                                           autodetect or SD default,
                                           default -1) */
int             midasSDDMA;             /* Sound Device DMA channel number
                                           (-1 for autodetect or SD default,
                                           default -1) */
int             midasSDCard;            /* Sound Device sound card type
                                           (-1 for autodetect or SD default,
                                           default -1) */
unsigned        midasMixRate;           /* Sound Device mixing rate */
unsigned        midasOutputMode;        /* Sound Device output mode force
                                           bits, default 0 (SD default) */
int             midasAmplification;     /* Forced amplification level or -1
                                           for SD default (default -1) */
int             midasChannels;          /* number of channels open or 0 if no
                                           channels have been opened using
                                           midasOpenChannels() */
int             midasPlayerNum;         /* timer music player number */

int             midasEMSInit;           /* is EMS heap manager initialized? */
int             midasTMRInit;           /* is TempoTimer initialized? */
int             midasTMRPlay;           /* is sound being played with timer?*/
int             midasSDInit;            /* is Sound Device initialized? */
int             midasSDChans;           /* are Sound Device channels open? */
int             midasGMPInit;           /* is GMP initialized? */
int             midasGMPPlay;           /* is GMP playing? */
int             midasTMRMusic;          /* is music being player with timer?*/

void (CALLING *midasErrorExit)(char *msg);      /* error exit function */


    /* Channel numbers used with gmpPlaySong(): */
static unsigned midasSDChannels[32] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
    12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31 };

static char     errmsg[90];
static int      dResult;




/****************************************************************************\
*
* Function:     void midasError(int errNum)
*
* Description:  Prints a MIDAS error message to stderr and exits to DOS
*
* Input:        int errNum              MIDAS error code
*
\****************************************************************************/

void CALLING midasError(int errNum)
{
    midasClose();                       /* uninitialize MIDAS Sound System */
    mStrCopy(&errmsg[0], "MIDAS Error: ");
    mStrAppend(&errmsg[0], errorMsg[errNum]);
    midasErrorExit(&errmsg[0]);         /* print error message */
}




/****************************************************************************\
*
* Function:     void midasUninitError(int errNum)
*
* Description:  Prints an error message to stderr and exits to DOS without
*               uninitializing MIDAS. This function should only be used
*               from midasClose();
*
* Input:        int errNum              MIDAS error code
*
\****************************************************************************/

void CALLING midasUninitError(int errNum)
{
    mStrCopy(&errmsg[0], "FATAL MIDAS uninitialization failure: ");
    mStrAppend(&errmsg[0], errorMsg[errNum]);
    midasErrorExit(&errmsg[0]);         /* print error message */
}




/****************************************************************************\
*
* Function:     void midasDetectSD(void)
*
* Description:  Attempts to detect a Sound Device. Sets the global variable
*               midasSD to point to the detected Sound Device or NULL if no
*               Sound Device was detected
*
\****************************************************************************/

void CALLING midasDetectSD(void)
{
    int         dsd;
    int         error;

    midasSD = NULL;                     /* no Sound Device detected yet */
    midasSDNumber = -1;
    dsd = 0;                            /* start from first Sound Device */

    /* search through Sound Devices until a Sound Device is detected: */
    while ( (midasSD == NULL) && (dsd < NUMSDEVICES) )
    {
        /* attempt to detect current SD: */
        if ( (error = (*midasSoundDevices[dsd]->Detect)(&dResult)) != OK )
            midasError(error);
        if ( dResult == 1 )
        {
            midasSDNumber = dsd;        /* Sound Device detected */
            /* point midasSD to this Sound Device: */
            midasSD = midasSoundDevices[dsd];
        }
        dsd++;                          /* try next Sound Device */
    }
}




/****************************************************************************\
*
* Function:     void midasInit(void);
*
* Description:  Initializes MIDAS Sound System
*
\****************************************************************************/

void CALLING midasInit(void)
{
    int         error;

#ifndef NOEMS
    if ( !midasDisableEMS )             /* is EMS usage disabled? */
    {
        /* Initialize EMS Heap Manager: */
        if ( (error = emsInit(&midasEMSInit)) != OK )
            midasError(error);

        /* was EMS Heap Manager initialized? */
        if ( midasEMSInit == 1 )
        {
            mUseEMS = 1;                /* yes, use EMS memory */
        }
        else
        {
            mUseEMS = 0;                /* no, do not use EMS memory */
        }
    }
    else
#endif
    {
        midasEMSInit = 0;
        mUseEMS = 0;                    /* EMS disabled - do not use it */
    }



    if ( midasSDNumber == -1 )      /* has a Sound Device been selected? */
    {
        midasDetectSD();            /* attempt to detect Sound Device */
        if ( midasSD == NULL )
            midasError(errSDFailure);
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
                midasError(error);
    }

    if ( midasSDPort != -1 )            /* has an I/O port been selected? */
        midasSD->port = midasSDPort;    /* if yes, set it to Sound Device */
    if ( midasSDIRQ != -1 )             /* SD IRQ number? */
        midasSD->IRQ = midasSDIRQ;      /* if yes, set it to Sound Device */
    if ( midasSDDMA != -1 )             /* SD DMA channel number? */
        midasSD->DMA = midasSDDMA;
    if ( midasSDCard != -1 )            /* sound card type? */
        midasSD->cardType = midasSDCard;

#ifndef NOTIMER
    /* initialize TempoTimer: */
    if ( (error = tmrInit()) != OK )
        midasError(error);

    midasTMRInit = 1;                 /* TempoTimer initialized */
#endif

    /* initialize Sound Device: */
    if ( (error = midasSD->Init(midasMixRate, midasOutputMode)) != OK )
        midasError(error);

    midasSDInit = 1;                  /* Sound Device initialized */

#ifndef NOTIMER
    /* start playing sound using the timer: */
    if ( (error = tmrPlaySD(midasSD)) != OK )
        midasError(error);
    midasTMRPlay = 1;
#endif

    /* Initialize Generic Module Player: */
    if ( (error = gmpInit(midasSD)) != OK )
        midasError(error);
    midasGMPInit = 1;
}




/****************************************************************************\
*
* Function:     void midasClose(void)
*
* Description:  Uninitializes MIDAS Sound System
*
\****************************************************************************/

void CALLING midasClose(void)
{
    int         error;

#ifndef NOTIMER
    /* if music is being played with timer, stop it: */
    if ( midasTMRMusic )
    {
        if ( (error = gmpSetUpdRateFunct(NULL)) != OK )
            midasUninitError(error);
        if ( (error = tmrStopMusic(midasPlayerNum)) != OK )
            midasUninitError(error);
        midasTMRMusic = 0;
    }
#endif

    /* If music is being played, stop it: */
    if ( midasGMPPlay )
    {
        if ( (error = gmpStopSong(midasPlayHandle)) != OK )
            midasUninitError(error);
        midasGMPPlay = 0;
    }

    /* If Generic Module Player has been initialized, uninitialize it: */
    if ( midasGMPInit )
    {
        if ( (error = gmpClose()) != OK )
            midasUninitError(error);
        midasGMPInit = 0;
    }

    /* if Sound Device channels are open, close them: */
    if ( midasSDChans )
    {
        if ( (error = midasSD->CloseChannels()) != OK )
            midasUninitError(error);
        midasSDChans = 0;
        midasChannels = 0;
    }

#ifndef NOTIMER
    /* if sound is being played, stop it: */
    if ( midasTMRPlay )
    {
        if ( (error = tmrStopSD()) != OK )
            midasUninitError(error);
        midasTMRPlay = 0;
    }
#endif

    /* if Sound Device is initialized, uninitialize it: */
    if ( midasSDInit )
    {
        if ( (error = midasSD->Close()) != OK )
            midasUninitError(error);
        midasSDInit = 0;
        midasSD = NULL;
    }

#ifndef NOTIMER
    /* if TempoTimer is initialized, uninitialize it: */
    if ( midasTMRInit )
    {
        if ( (error = tmrClose()) != OK )
            midasUninitError(error);
        midasTMRInit = 0;
    }
#endif

#ifndef NOEMS
    /* if EMS Heap Manager is initialized, uninitialize it: */
    if ( midasEMSInit )
    {
        if ( (error = emsClose()) != OK )
            midasUninitError(error);
        midasEMSInit = 0;
    }
#endif
}




/****************************************************************************\
*
* Function:     void midasSetDefaults(void)
*
* Description:  Initializes MIDAS Sound System variables to their default
*               states. MUST be the first MIDAS function called.
*
\****************************************************************************/

void CALLING midasSetDefaults(void)
{
    midasEMSInit = 0;                   /* EMS heap manager is not
                                           initialized yet */
    midasTMRInit = 0;                   /* TempoTimer is not initialized */
    midasTMRPlay = 0;                   /* Sound is not being played */
    midasSDInit = 0;                    /* Sound Device is not initialized */
    midasSDChans = 0;                   /* Sound Device channels are not
                                           open */
    midasGMPInit = 0;                   /* GMP is not initialized */
    midasGMPPlay = 0;                   /* GMP is not playing */
    midasTMRMusic = 0;                  /* Music is not being played with
                                           timer */
    midasChannels = 0;                  /* No channels opened */

    midasDisableEMS = 0;                /* do not disable EMS usage */
    midasSDNumber = -1;                 /* no Sound Device forced */
    midasSDPort = -1;                   /* no I/O port forced */
    midasSDIRQ = -1;                    /* no IRQ number forced */
    midasSDDMA = -1;                    /* no DMA channel number forced */
    midasSDCard = -1;                   /* no sound card type forced */
    midasOutputMode = 0;                /* no output mode forced */
    midasMixRate = 44100;               /* attempt to use 44100Hz mixing
                                           rate */
    midasAmplification = -1;            /* use default amplification level */

    mEnableSurround = 0;

    midasErrorExit = &errErrorExit;

    midasSD = NULL;                     /* point midasSD and midasMP to */

    /* Set up buffer length. For multitasking operating systems we will use
       much longer buffer to eliminate breaks in sound under all
       circumstances. Also note that no DOS Sound Devices actually use
       mBufferBlocks: */

#if defined(__WIN32__) || defined(__LINUX__)
    mBufferLength = 500;                /* 500ms buffer */
    mBufferBlocks = 16;                 /* in 16 blocks */
#else
    mBufferLength = 40;                 /* 40ms buffer */
    mBufferBlocks = 8;                  /* in 8 blocks (ha) */
#endif
    mDefaultFramerate = 7000;           /* default frame rate 70Hz */
    mSyncScreen = 1;                    /* try to synchronize to screen by
                                           default */
}




/****************************************************************************\
*
* Function:     void midasOpenChannels(int numChans);
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
\****************************************************************************/

void CALLING midasOpenChannels(int numChans)
{
    int         error;

    midasChannels = numChans;

    /* open Sound Device channels: */
    if ( (error = midasSD->OpenChannels(numChans)) != OK )
        midasError(error);
    midasSDChans = 1;

    /* set amplification level if forced: */
    if ( midasAmplification != -1 )
    {
        if ( (error = midasSD->SetAmplification(midasAmplification)) != OK )
            midasError(error);
    }
}




/****************************************************************************\
*
* Function:     void midasCloseChannels(void);
*
* Description:  Closes Sound Device channels opened with midasOpenChannels().
*               Do NOT call this function unless you have opened the sound
*               channels used yourself with midasOpenChannels().
*
\****************************************************************************/

void CALLING midasCloseChannels(void)
{
    int         error;

    /* Close Sound Device channels: */
    if ( (error = midasSD->CloseChannels()) != OK )
        midasError(error);
    midasSDChans = 0;
    midasChannels = 0;
}




/****************************************************************************\
*
* Function:     midasPlayModule(gmpModule *module, int numEffectChns)
*
* Description:  Starts playing a Generic Module Player module loaded to memory
*
* Input:        gmpModule *module       Pointer to loaded module structure
*               int numEffectChns       Number of channels to open for sound
*                                       effects. Ignored if sound channels
*                                       have already been opened with
*                                       midasOpenChannels().
*
* Returns:      Pointer to module structure. This function can not fail,
*               as it will call midasError() to handle all error cases.
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

void CALLING midasPlayModule(gmpModule *module, int numEffectChns)
{
    short       numChans;
    int         error;
    int         firstChannel;

    numChans = module->numChannels;

    /* Open Sound Device channels if not already open: */
    if ( midasChannels == 0 )
    {
        if ( (error = midasSD->OpenChannels(numChans + numEffectChns)) != OK )
            midasError(error);
        midasSDChans = 1;
        firstChannel = numEffectChns;

        /* set amplification level if forced: */
        if ( midasAmplification != -1 )
        {
            if ( (error = midasSD->SetAmplification(midasAmplification)) != OK )
                midasError(error);
        }
    }
    else
    {
        if ( midasChannels < numChans )
            midasError(errNoChannels);
        firstChannel = midasChannels - numChans;
    }

    /* Start playing the whole song in the module using the last Sound Device
       channels: */
    if ( (error = gmpPlaySong(module, -1, -1, -1, -1,
        &midasSDChannels[firstChannel], &midasPlayHandle)) != OK )
        midasError(error);
    midasGMPPlay = 1;

#ifndef NOTIMER
    /* Start playing using the timer: */
    if ( (error = tmrPlayMusic(&gmpPlay, &midasPlayerNum)) != OK )
        midasError(error);
    if ( (error = gmpSetUpdRateFunct(&tmrSetUpdRate)) != OK )
        midasError(error);

    midasTMRMusic = 1;
#endif
}




/****************************************************************************\
*
* Function:     void midasStopModule(gmpModule *module)
*
* Input:        gmpModule *module       the module which is being played
*
* Description:  Stops playing a module and uninitializes the Module Player.
*               If sound channels were NOT opened through midasOpenChannels(),
*               but by letting midasPlayModule() open them, they will be
*               closed. Sound channels opened with midasOpenChannels() are NOT
*               closed and must be closed separately.
*
\****************************************************************************/

void CALLING midasStopModule(gmpModule *module)
{
    int         error, i;

#ifndef NOTIMER
    puts("gmpSetUpdRateFunct");
    /* Stop playing music with timer: */
    if ( (error = gmpSetUpdRateFunct(NULL)) != OK )
        midasError(error);
    puts("tmrStopMusic");
    if ( (error = tmrStopMusic(midasPlayerNum)) != OK )
        midasError(error);

    midasTMRMusic = 0;
#endif
    puts("gmpStopSong");
    /* Stop playing the module: */
    if ( (error = gmpStopSong(midasPlayHandle)) != OK )
        midasError(error);
    midasGMPPlay = 0;
    midasPlayHandle = NULL;

    puts("CloseChannels");
    /* If Sound Device channels were not opened with midasOpenChannels(),
       close them: */
    if ( midasChannels == 0 )
    {
        if ( (error = midasSD->CloseChannels()) != OK )
            midasError(error);
        midasSDChans = 0;
    }
    else
    {
        /* Sound Device channels were originally opened with
           midasOpenChannels(). Now stop sounds from the channels used by
           the Module Player: */
        for ( i = (midasChannels - module->numChannels); i < midasChannels;
            i++ )
        {
            if ( (error = midasSD->StopSound(i)) != OK )
                midasError(error);
            if ( (error = midasSD->SetVolume(i, 0)) != OK )
                midasError(error);
        }
    }
}




/****************************************************************************\
*
* Function:     void midasSetErrorExit(void (CALLING *errorExit)(char *msg))
*
* Description:  Sets error exit function.
*
* Input:        void (CALLING *errorExit)() Pointer to the function that will
*                                           be called to exit the program with
*                                           an error message.
*
\****************************************************************************/

void midasSetErrorExit(void (CALLING *errorExit)(char *msg))
{
    midasErrorExit = errorExit;
}


/*
 * $Log: midas.c,v $
 * Revision 1.11  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.10  1996/09/21 16:38:00  jpaana
 * Changed uss to oss
 *
 * Revision 1.9  1996/07/29 19:36:18  pekangas
 * Added MixNoSound Sound Device for Win32
 *
 * Revision 1.8  1996/07/16 20:05:01  pekangas
 * Fixed buffer size with Visual C
 *
 * Revision 1.7  1996/07/13 20:32:07  pekangas
 * Fixed Sound Device pointers with Visual C
 *
 * Revision 1.6  1996/07/13 19:42:21  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.5  1996/07/13 18:18:33  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.4  1996/06/05 19:40:35  jpaana
 * Changed usswave to uss
 *
 * Revision 1.3  1996/05/25 09:33:10  pekangas
 * Added mBufferLength and mBufferBlocks initialization to midasSetDefaults()
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Added USSWave device and fixed Linux support
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/
