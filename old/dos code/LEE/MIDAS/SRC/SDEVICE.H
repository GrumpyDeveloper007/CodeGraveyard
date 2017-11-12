/*      SDEVICE.H
 *
 * Sound Device definitions
 *
 * $Id: sdevice.h,v 1.9 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/


#ifndef __SDEVICE_H
#define __SDEVICE_H

#ifdef __16__
#define SMPMAX 65519                    /* max sample length (65536-16 - 1) */
#else
#define SMPMAX 2147483631               /* max sample length (2^31 - 17) */
#endif
#define MAXSAMPLES 256                  /* maximum number of samples */

#define DMABUFLEN 25                    /* mixing buffer length is a 1/25th of
                                           a second */



/****************************************************************************\
*       enum sdSampleType
*       -----------------
* Description:  Sample types
\****************************************************************************/

enum sdSampleType
{
    smpNone = 0,                        /* no sample */
    smp8bitMono = 1,                    /* 8-bit mono unsigned sample */
    smp8bit = smp8bitMono,              /* for compatibility */
    smp16bitMono = 2,                   /* 16-bit mono signed sample */
    smp16bit = smp16bitMono,            /* for compatibility */
    smp8bitStereo = 3,                  /* 8-bit stereo unsigned sample */
    smp16bitStereo = 4                  /* 16-bit stereo signed sample */
};




/****************************************************************************\
*       enum sdLoopMode
*       ---------------
* Description:  Sample looping modes
\****************************************************************************/

enum sdLoopMode
{
    sdLoopNone = 0,                     /* no looping */
    sdLoop1 = 1,                        /* 1 loop, release ends note */
    sdLoop1Rel = 2,                     /* 1 loop, sample data after loop is
                                           played when note is released */
    sdLoop2 = 3,                        /* 2 loops, when note is released
                                           playing is continued looping the
                                           second loop */
    sdLoopAmigaNone = 4,                /* Amiga compatible looping, no
                                           loop - ALE logic enabled anyway */
    sdLoopAmiga = 5                     /* Amiga compatible looping - 1
                                           loop, ALE logic enabled */
};




/****************************************************************************\
*       enum sdLoopType
*       ---------------
* Description:  Sample looping type for one loop
\****************************************************************************/

enum sdLoopType
{
    loopNone = 0,                       /* no looping */
    loopUnidir = 1,                     /* unidirectional loop */
    loopBidir = 2                       /* bidirectional loop */
};




/****************************************************************************\
*       enum sdSmpPos
*       -------------
* Description:  Sample positions in memory
\****************************************************************************/

enum sdSmpPos
{
    sdSmpNone = 0,                   /* no sample */
    sdSmpConv,                       /* conventional memory */
    sdSmpEMS                         /* EMS */
};




/****************************************************************************\
*       struct sdSample
*       ---------------
* Description:  Sound Device sample information structure
\****************************************************************************/

typedef struct
{
    uchar       *sample;                /* sample data pointer */
    int         samplePos;              /* sample position in memory, see enum
                                           sdSmpPos */
    int         sampleType;             /* sample type, see enum
                                           sdSampleType */
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
} sdSample;




/****************************************************************************\
*       enum sdPanning
*       --------------
* Description:  Sound Device panning values. Legal values range from
*               panLeft to panRight, in steps of 1, plus panSurround.
*               Surround sound is played from middle if surround is not
*               enabled.
\****************************************************************************/

enum sdPanning
{
    panLeft = -64,                      /* left speaker */
    panMiddle = 0,                      /* middle (both speakers) */
    panRight = 64,                      /* right speaker */
    panSurround = 0x80                  /* surround sound */
};




/****************************************************************************\
*       enum sdMode
*       -----------
* Description:  Possible SoundDevice output modes
\****************************************************************************/

enum sdMode
{
    sdMono = 1,                         /* mono */
    sdStereo = 2,                       /* stereo */

    sd8bit = 4,                         /* 8-bit output */
    sd16bit = 8                         /* 16-bit output */
};




/****************************************************************************\
*       enum sdConfigBits
*       -----------------
* Description:  Sound Device configuration information bits
\****************************************************************************/

enum sdConfigBits
{
    sdUsePort = 1,                      /* SD uses an I/O port */
    sdUseIRQ = 2,                       /* SD uses an IRQ */
    sdUseDMA = 4,                       /* SD uses a DMA channel */
    sdUseMixRate = 8,                   /* SD uses the set mixing rate */
    sdUseOutputMode = 16,               /* SD uses the set output mode */
    sdUseDSM = 32                       /* SD uses software mixing (DSM) */
};




/****************************************************************************\
*       struct SoundDevice
*       ------------------
* Description:  SoundDevice structure. See SDEVICE.TXT for documentation
\****************************************************************************/

typedef struct
{
    unsigned    tempoPoll;
    unsigned    configBits;             /* Configuration info bits. See enum
                                           sdConfigBits. */
    unsigned    port;                   /* Sound Device I/O port address */
    unsigned    IRQ;                    /* Sound Device IRQ number */
    unsigned    DMA;                    /* Sound Device DMA channel number */
    unsigned    cardType;               /* Sound Device sound card type.
                                           Starting from 1, 0 means
                                           autodetect */
    unsigned    numCardTypes;           /* number of different sound card
                                           types for this Sound Device */
    unsigned    modes;                  /* Possible modes for this SD,
                                           see enum sdMode. Updated by
                                           Detect() */

    char        *name;                  /* pointer to Sound Device name */
    char        **cardNames;            /* pointer to an array of pointers to
                                           sound card name strings */
    unsigned    numPortAddresses;       /* number of possible port
                                           addresses in table */
    unsigned    *portAddresses;         /* pointer to an array of possible
                                           I/O port addresses */


    int (CALLING *Detect)(int *result);
    int (CALLING *Init)(unsigned mixRate, unsigned mode);
    int (CALLING *Close)(void);
    int (CALLING *GetMixRate)(unsigned *mixRate);
    int (CALLING *GetMode)(unsigned *mode);
    int (CALLING *OpenChannels)(unsigned channels);
    int (CALLING *CloseChannels)(void);
    int (CALLING *ClearChannels)(void);
    int (CALLING *Mute)(int mute);
    int (CALLING *Pause)(int pause);
    int (CALLING *SetMasterVolume)(unsigned masterVolume);
    int (CALLING *GetMasterVolume)(unsigned *masterVolume);
    int (CALLING *SetAmplification)(unsigned amplification);
    int (CALLING *GetAmplification)(unsigned *amplification);
    int (CALLING *PlaySound)(unsigned channel, ulong rate);
    int (CALLING *ReleaseSound)(unsigned channel);
    int (CALLING *StopSound)(unsigned channel);
    int (CALLING *SetRate)(unsigned channel, ulong rate);
    int (CALLING *GetRate)(unsigned channel, ulong *rate);
    int (CALLING *SetVolume)(unsigned channel, unsigned volume);
    int (CALLING *GetVolume)(unsigned channel, unsigned *volume);
    int (CALLING *SetSample)(unsigned channel, unsigned smpHandle);
    int (CALLING *GetSample)(unsigned channel, unsigned *smpHandle);
    int (CALLING *SetPosition)(unsigned channel, unsigned pos);
    int (CALLING *GetPosition)(unsigned channel, unsigned *pos);
    int (CALLING *GetDirection)(unsigned channel, int *direction);
    int (CALLING *SetPanning)(unsigned channel, int panning);
    int (CALLING *GetPanning)(unsigned channel, int *panning);
    int (CALLING *MuteChannel)(unsigned channel, int mute);
    int (CALLING *AddSample)(sdSample *sample, int copySample,
        unsigned *smpHandle);
    int (CALLING *RemoveSample)(unsigned smpHandle);
    int (CALLING *SetUpdRate)(unsigned updRate);
    int (CALLING *StartPlay)(void);
    int (CALLING *Play)(int *callMP);

#ifdef SUPPORTSTREAMS
    int (CALLING *StartStream)(unsigned channel, uchar *buffer, unsigned
        bufferLength, int sampleType, ulong rate);
    int (CALLING *StopStream)(unsigned channel);
    int (CALLING *SetLoopCallback)(unsigned channel, void (CALLING *callback)
        (unsigned channel));
    int (CALLING *SetStreamWritePosition)(unsigned channel,
        unsigned position);
#endif
} SoundDevice;



#endif


/*
 * $Log: sdevice.h,v $
 * Revision 1.9  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.8  1997/01/16 18:21:23  pekangas
 * Added function SetStreamWritePosition
 *
 * Revision 1.7  1996/10/09 17:59:59  pekangas
 * Fixed to conform to the Sound Device specification
 *
 * Revision 1.6  1996/07/13 18:01:30  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.5  1996/05/28 20:28:45  pekangas
 * Fixed a minor but annoying typo
 *
 * Revision 1.4  1996/05/26 20:56:17  pekangas
 * Added rate to SoundDevice.StartStream prototype
 *
 * Revision 1.3  1996/05/24 16:20:36  jpaana
 * Fixed for Linux
 *
 * Revision 1.2  1996/05/23 18:24:02  pekangas
 * Added 8-bit stereo and 16-bit mono & stereo sample types and stream playing functions
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/