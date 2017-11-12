/*      oss.c
 *
 * Open Sound System Sound Devicee
 *
 * $Id: oss.c,v 1.11 1996/11/09 21:08:04 jpaana Exp $
 *
 * Copyright 1996 Petteri Kangaslampi and Jarno Paananen
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <stdio.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/soundcard.h>

#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "sdevice.h"
#include "mmem.h"
#include "dsm.h"
#include "mglobals.h"


RCSID(char const *oss_rcsid = "$Id: oss.c,v 1.11 1996/11/09 21:08:04 jpaana Exp $";)

#define DEVICE_NAME "/dev/dsp"

#define open_mode O_WRONLY

static    int audio_fd;
static    int format_16bits = AFMT_S16_LE;
static    int format_8bits = AFMT_U8;
static    int format_stereo;
static    int format_mixingrate;
static    audio_buf_info info;
static    uchar *audioBuffer;
static    int audioBufferSize;

/* Make that "e" smaller (to c or even a) if you have small DMA buffer */

static    int numFragments = 0xffff000e;

//#define DUMPBUFFER

#define OSSVERSION 1.02
#define OSSVERSTR "1.02"

/* Number of bits of accuracy in mixing for 8-bit output: */
#define MIX8BITS 12


/* Sound Device information */

    /* Sound Card names: */
static char     *ossCardName = "Unix Sound System output";



/* Sound Device internal static variables */
static unsigned mixRate, outputMode;
static unsigned mixElemSize;

static unsigned amplification;
static unsigned updateMix;              /* number of elements to mix between
                                           two updates */
static unsigned mixLeft;                /* number of elements to mix before
                                           next update */

static unsigned bufferPos;               /* mixing position inside buffer */

static uchar    *ppTable;               /* post-processing table for 8-bit
                                           output */

#ifdef DUMPBUFFER
static FILE     *buff;
#endif


/****************************************************************************\
*       enum ossFunctIDs
*       -----------------
* Description:  ID numbers for OSS Sound Device functions
\****************************************************************************/

enum ossFunctIDs
{
    ID_ossDetect = ID_oss,
    ID_ossInit,
    ID_ossClose,
    ID_ossGetMode,
    ID_ossOpenChannels,
    ID_ossSetAmplification,
    ID_ossGetAmplification,
    ID_ossSetUpdRate,
    ID_ossStartPlay,
    ID_ossPlay
};



/* Local prototypes: */
int CALLING ossSetAmplification(unsigned _amplification);
int CALLING ossGetAmplification(unsigned *_amplification);
int CALLING ossSetUpdRate(unsigned updRate);

/****************************************************************************\
*
* Function:     static unsigned CALLING (*postProc)(unsigned numElements,
*                   uchar *bufStart, unsigned mixPos, unsigned *mixBuffer,
*                   uchar *ppTable);
*
* Description:  Pointer to the actual post-processing routine. Takes
*               DSM output elements from dsmMixBuffer and writes them to
*               output buffer at *bufStart in a format suitable for the Sound
*               Device.
*
* Input:        unsigned numElements    number of elements to process
*                                       (guaranteed to be even)
*               uchar *bufStart         pointer to start of output buffer
*               unsigned mixPos         mixing position in output buffer
*               unsigned *mixBuffer     source mixing buffer
*               uchar *ppTable          pointer to post-processing table
*
* Returns:      New mixing position in output buffer. Can not fail.
*
\****************************************************************************/

static unsigned CALLING (*postProc)(unsigned numElements, uchar *bufStart,
    unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);


/****************************************************************************\
*
* Function:     unsigned pp16Mono();
*
* Description:  16-bit mono post-processing routine
*
\****************************************************************************/

unsigned CALLING pp16Mono(unsigned numElements, uchar *bufStart,
    unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);

/****************************************************************************\
*
* Function:     unsigned pp8Mono();
*
* Description:  8-bit mono post-processing routine
*
\****************************************************************************/

unsigned CALLING pp8Mono(unsigned numElements, uchar *bufStart,
    unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);

/****************************************************************************\
*
* Function:     unsigned pp16Stereo();
*
* Description:  16-bit stereo post-processing routine
*
\****************************************************************************/

unsigned CALLING pp16Stereo(unsigned numElements, uchar *bufStart,
    unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);

/****************************************************************************\
*
* Function:     unsigned pp8Stereo();
*
* Description:  8-bit stereo post-processing routine
*
\****************************************************************************/

unsigned CALLING pp8Stereo(unsigned numElements, uchar *bufStart,
    unsigned mixPos, unsigned *mixBuffer, uchar *ppTable);


/****************************************************************************\
*
* Function:     int ossDetect(int *result)
*
* Description:  Detects a OSS Sound Device
*
* Input:        int *result             pointer to detection result
*
* Returns:      MIDAS error code. Detection result (1 if detected, 0 if not)
*               is written to *result.
*
* Notes:        OSS Sound Device is always detected.
*
\****************************************************************************/

int CALLING ossDetect(int *result)
{
    *result = 1;
    return OK;
}




/****************************************************************************\
*
* Function:     int ossInit(unsigned mixRate, unsigned mode)
*
* Description:  Initializes OSS Sound Device
*
* Input:        unsigned mixRate        mixing rate in Hz
*               unsigned mode           output mode
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING ossInit(unsigned _mixRate, unsigned mode)
{
    int         error;
    int         mixMode;
    int         *modetag;

    mixRate = _mixRate;

    /* Determine the actual output mode: */
    if ( mode & sdMono )
	format_stereo = 0;
    else
	format_stereo = 1;

    if ( mode & sd8bit )
	modetag = &format_8bits;
    else
	modetag = &format_16bits;

    /* Open output device using the format just set up: */
    if (( audio_fd = open(DEVICE_NAME, open_mode, 0 )) == -1 )
    {
	perror(DEVICE_NAME);
	return errDeviceNotAvailable;
    }

    if ( ((int)mode = ioctl(audio_fd, SNDCTL_DSP_SETFMT, modetag)) == -1)
    { /* Fatal error */
        perror("SNDCTL_DSP_SETFMT");
	return(errSDFailure);
    }

    if (ioctl(audio_fd, SNDCTL_DSP_STEREO, &format_stereo) == -1)
    { /* Fatal error */
        perror("SNDCTL_DSP_STEREO");
	return(errSDFailure);
    }
    
    if (format_stereo)
        outputMode = sdStereo;
    else
        outputMode = sdMono;

    if ( *modetag == AFMT_U8 )
        outputMode |= sd8bit;
    else
    {
        if ( *modetag == AFMT_S16_LE )
            outputMode |= sd16bit;
        else
	    return(errSDFailure);
    }

    format_mixingrate = mixRate;

    if (ioctl(audio_fd, SNDCTL_DSP_SPEED, &format_mixingrate) == -1)
    { /* Fatal error */
        perror("SNDCTL_DSP_SPEED");
	return(errSDFailure);
    }

    mixRate = format_mixingrate;
    
    /* Calculate one mixing element size: */
    if ( outputMode & sd16bit )
        mixElemSize = 2;
    else
        mixElemSize = 1;
    if ( outputMode & sdStereo )
        mixElemSize <<= 1;

    /* Allocate memory for post-processing table if necessary: */
    if ( outputMode & sd8bit )
    {
        /* Allocate memory for 8-bit output mode post-processing table: */
        if ( (error = memAlloc((1 << MIX8BITS), (void**)&ppTable)) != OK )
            PASSERROR(ID_ossInit);
    }
    else
        ppTable = NULL;


    /* Check correct mixing mode: */
    if ( outputMode & sdStereo )
        mixMode = dsmMixStereo;
    else
        mixMode = dsmMixMono;

    /* Initialize Digital Sound Mixer: */
    if ( outputMode & sd16bit )
    {
        if ( (error = dsmInit(mixRate, mixMode, 16)) != OK )
            PASSERROR(ID_ossInit)
    }
    else
    {
        if ( (error = dsmInit(mixRate, mixMode, MIX8BITS)) != OK )
            PASSERROR(ID_ossInit)
    }

    /* Set update rate to 50Hz: */
    if ( (error = ossSetUpdRate(5000)) != OK )
        PASSERROR(ID_ossInit)

    /* Allocate memory for audiobuffer: */

    if (ioctl(audio_fd, SNDCTL_DSP_SETFRAGMENT, &numFragments) == -1)
    { /* Fatal error */
        perror("SNDCTL_DSP_SETFRAGMENT");
	return(errSDFailure);
    }

    
    if (ioctl(audio_fd, SNDCTL_DSP_GETOSPACE, &info) == -1)
    { /* Fatal error */
        perror("SNDCTL_DSP_GETOSPACE");
	return(errSDFailure);
    }

//    printf("Fragment size: %i, total fragments: %i\n", info.fragsize, info.fragstotal);

//    audioBufferSize = mixRate * mixElemSize * mBufferLength / 1000;
    audioBufferSize = dsmMixBufferSize;
//    audioBufferSize = info.fragsize;

    if ( (error = memAlloc(audioBufferSize, (void**)&audioBuffer)) != OK )
        PASSERROR(ID_ossInit);


    /* Point postProc() to correct post-processing routine: */
    switch ( outputMode )
    {
        case (sd16bit | sdMono):
            postProc = &pp16Mono;
            break;

        case (sd8bit | sdMono):
            postProc = &pp8Mono;
            break;

        case (sd16bit | sdStereo):
            postProc = &pp16Stereo;
            break;

        case (sd8bit | sdStereo):
            postProc = &pp8Stereo;
            break;

        default:
            ERROR(errInvalidArguments, ID_ossInit);
            return errInvalidArguments;
    }

    amplification = 64;

#ifdef DUMPBUFFER
    buff = fopen("buffer.raw", "wb");
#endif
    return OK;
}




/****************************************************************************\
*
* Function:     ossClose(void)
*
* Description:  Uninitializes OSS Sound Device
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int ossClose(void)
{
    int         error;

#ifdef DUMPBUFFER
    fclose(buff);
#endif

    /* Uninitialize Digital Sound Mixer: */
    if ( (error = dsmClose()) != OK )
        PASSERROR(ID_ossClose)

    /* Deallocate post-processing table if necessary: */
    if ( outputMode & sd8bit )
    {
        if ( (error = memFree(ppTable)) != OK )
            PASSERROR(ID_ossClose);
    }

    /* Deallocate audio buffer */
    if ( (error = memFree(audioBuffer)) != OK )
      PASSERROR(ID_ossClose);

    close(audio_fd);

    return OK;
}




/****************************************************************************\
*
* Function:     int ossGetMode(unsigned *mode)
*
* Description:  Reads the current output mode
*
* Input:        unsigned *mode          pointer to output mode
*
* Returns:      MIDAS error code. Output mode is written to *mode.
*
\****************************************************************************/

int CALLING ossGetMode(unsigned *mode)
{
    *mode = outputMode;

    return OK;
}




/****************************************************************************\
*
* Function:     int ossOpenChannels(unsigned channels)
*
* Description:  Opens sound channels for output. Prepares post-processing
*               tables, takes care of default amplification and finally opens
*               DSM channels. Channels can be closed by simply calling
*               dsmCloseChannels().
*
* Input:        unsigned channels       number of channels to open
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING ossOpenChannels(unsigned channels)
{
    int         error;

    /* Open DSM channels: */
    if ( (error = dsmOpenChannels(channels)) != OK )
        PASSERROR(ID_ossOpenChannels)

    /* Take care of default amplification and calculate new post-processing
       table if necessary: */

        if ( channels < 5 )
            ossSetAmplification(64);
        else
            ossSetAmplification(14*channels);

    return OK;
}




/****************************************************************************\
*
* Function:     void CalcPP8Table(void)
*
* Description:  Calculates a new 8-bit output post-processing table using
*               current amplification level
*
\****************************************************************************/

static void CalcPP8Table(void)
{
    uchar       *tbl;
    int         val;
    long        temp;

    tbl = ppTable;                      /* tbl points to current table pos */

    /* Calculate post-processing table for all possible DSM values:
       (table must be used with unsigned numbers - add (1 << MIX8BITS)/2 to
       DSM output values first) */
    for ( val = -(1 << MIX8BITS)/2; val < (1 << MIX8BITS)/2; val++ )
    {
        /* Calculate 8-bit unsigned output value corresponding to the
           current DSM output value (val), taking amplification into
           account: */
        temp = 128 + ((((long) amplification) * ((long) val) / 64L) >>
            (MIX8BITS-8));

        /* Clip the value to fit between 0 and 255 inclusive: */
        if ( temp < 0 )
            temp = 0;
        if ( temp > 255 )
            temp = 255;

        /* Write the value to the post-processing table: */
        *(tbl++) = (uchar) temp;
    }
}




/****************************************************************************\
*
* Function:     int ossSetAmplification(unsigned amplification)
*
* Description:  Sets the amplification level. Calculates new post-processing
*               tables and calls dsmSetAmplification() as necessary.
*
* Input:        unsigned amplification  amplification value
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING ossSetAmplification(unsigned _amplification)
{
    int         error;

    amplification = _amplification;

    if ( outputMode & sd8bit )
    {
        /* 8-bit output mode - do not set amplification level using DSM,
           but calculate a new post-processing table instead: */
        CalcPP8Table();
    }
    else
    {
        /* Set amplification level to DSM: */
        if ( (error = dsmSetAmplification(amplification)) != OK )
            PASSERROR(ID_ossSetAmplification)
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int ossGetAmplification(unsigned *amplification);
*
* Description:  Reads the current amplification level. (DSM doesn't
*               necessarily know the actual amplification level if
*               post-processing takes care of amplification)
*
* Input:        unsigned *amplification   pointer to amplification level
*
* Returns:      MIDAS error code. Amplification level is written to
*               *amplification.
*
\****************************************************************************/

int CALLING ossGetAmplification(unsigned *_amplification)
{
    *_amplification = amplification;

    return OK;
}




/****************************************************************************\
*
* Function:     int ossSetUpdRate(unsigned updRate);
*
* Description:  Sets the channel value update rate (depends on song tempo)
*
* Input:        unsigned updRate        update rate in 100*Hz (eg. 50Hz
*                                       becomes 5000).
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING ossSetUpdRate(unsigned updRate)
{
    /* Calculate number of elements to mix between two updates: (even) */
    mixLeft = updateMix = ((unsigned) ((100L * (ulong) mixRate) /
        ((ulong) updRate)) + 1) & 0xFFFFFFFE;

    return OK;
}




/****************************************************************************\
*
* Function:     int ossStartPlay(void)
*
* Description:  Prepares for playing - doesn't actually do anything here...
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING ossStartPlay(void)
{
    return OK;
}




/****************************************************************************\
*
* Function:     int ossPlay(int *callMP);
*
* Description:  Plays the sound - mixes the correct amount of data with DSM
*               and copies it to output buffer with post-processing.
*               Also takes care of sending fully mixed buffer to the 
*               output device.
*
* Input:        int *callMP             pointer to music player calling flag
*
* Returns:      MIDAS error code. If enough data was mixed for one updating
*               round and music player should be called, 1 is written to
*               *callMP, otherwise 0 is written there. Note that if music
*               player can be called, ossPlay() should be called again
*               with a new check for music playing to ensure the mixing buffer
*               gets filled with new data.
*
\****************************************************************************/

int CALLING ossPlay(int *callMP)
{
    int         error;
    unsigned    bufferLeft, numElems;
    unsigned    dsmBufSize;
//    uchar       *temp;

    if (ioctl(audio_fd, SNDCTL_DSP_GETOSPACE, &info) == -1)
    { /* Fatal error */
        perror("SNDCTL_DSP_GETOSPACE");
	return(errSDFailure);
    }

//    printf("avail frags: %i\n", info.fragments);

    if ( info.fragments == 0 )
    {
        *callMP = 0;
        return OK;
    }

    /* Calculate DSM mixing buffer size in elements: (FIXME) */
    dsmBufSize = dsmMixBufferSize;
    dsmBufSize >>= 2;


    if ( outputMode & sdStereo )
        dsmBufSize >>= 1;

    /* Calculate number of bytes of buffer left: */

    bufferLeft = audioBufferSize - bufferPos;

    /* Calculate number of mixing elements left: */
    numElems = bufferLeft / mixElemSize;

    /* Check that we won't mix more data than there is to the next
       update: */
    if ( numElems > mixLeft )
        numElems = mixLeft;

    /* Check that we won't mix more data than fits to DSM mixing
       buffer: */
    if ( numElems > dsmBufSize )
        numElems = dsmBufSize;

    /* Decrease number of elements before next update: */
    mixLeft -= numElems;

    /* Mix the data to DSM mixing buffer: */
    if ( (error = dsmMixData(numElems)) != OK )
        PASSERROR(ID_ossPlay)

    /* Write the mixed data to output buffer: */
    bufferPos = postProc(numElems, audioBuffer, 0,
        dsmMixBuffer, ppTable);

#ifdef DUMPBUFFER
    fwrite(&audioBuffer[oldPos], numElems * mixElemSize, 1, buff);
#endif


    /* Check if the buffer is full - if so, write it to the output
       device and start over: */

    write(audio_fd, audioBuffer, bufferPos);

    /* Check if the music player should be called: */
    if ( mixLeft == 0)
    {
        mixLeft = updateMix;
        *callMP = 1;
        return OK;
    }

    /* No more data fits to the mixing buffers - just return without
       update: */
    *callMP = 0;

    return OK;
}




    /* OSS Sound Device structure: */

SoundDevice     OSS = {
    0,                                  /* tempoPoll = 0 */
    sdUseMixRate | sdUseOutputMode | sdUseDSM,  /* configBits */
    0,                                  /* port */
    0,                                  /* IRQ */
    0,                                  /* DMA */
    1,                                  /* cardType */
    1,                                  /* numCardTypes */
    sdMono | sdStereo | sd8bit | sd16bit,       /* modes */

    "Open Sound System Sound Device " OSSVERSTR,              /* name */
    &ossCardName,                               /* cardNames */
    0,                                          /* numPortAddresses */
    NULL,                                       /* portAddresses */

    &ossDetect,
    &ossInit,
    &ossClose,
    &dsmGetMixRate,
    &ossGetMode,
    &ossOpenChannels,
    &dsmCloseChannels,
    &dsmClearChannels,
    &dsmMute,
    &dsmPause,
    &dsmSetMasterVolume,
    &dsmGetMasterVolume,
    &ossSetAmplification,
    &ossGetAmplification,
    &dsmPlaySound,
    &dsmReleaseSound,
    &dsmStopSound,
    &dsmSetRate,
    &dsmGetRate,
    &dsmSetVolume,
    &dsmGetVolume,
    &dsmSetSample,
    &dsmGetSample,
    &dsmSetPosition,
    &dsmGetPosition,
    &dsmGetDirection,
    &dsmSetPanning,
    &dsmGetPanning,
    &dsmMuteChannel,
    &dsmAddSample,
    &dsmRemoveSample,
    &ossSetUpdRate,
    &ossStartPlay,
    &ossPlay
};


/*
 * $Log: oss.c,v $
 * Revision 1.11  1996/11/09 21:08:04  jpaana
 * Fixed some "comparison between signed and unsigned" warnings
 *
 * Revision 1.10  1996/09/22 17:11:56  jpaana
 * Still tweaking...
 *
 * Revision 1.9  1996/09/21 17:18:01  jpaana
 * Misc Fixes
 *
 * Revision 1.8  1996/09/21 16:40:26  jpaana
 * Fixed some typos
 *
 * Revision 1.7  1996/09/21 16:38:00  jpaana
 * Renamed to Open Sound System Sound Device (blah)
 *
 * Revision 1.6  1996/09/15 09:18:28  jpaana
 * Removed some debug texts
 *
 * Revision 1.5  1996/09/09 09:52:12  jpaana
 * Added some more fragments
 *
 * Revision 1.4  1996/09/08 20:32:32  jpaana
 * Misc. tweaking (most commented out now)
 *
 * Revision 1.3  1996/08/03 13:16:42  jpaana
 * Fixed to work without Pthreads ;)
 *
 * Revision 1.1  1996/06/05 19:40:35  jpaana
 * Initial revision
 *
 * Revision 1.2  1996/05/25 15:49:57  jpaana
 * Cleaned up
 *
 * Revision 1.1  1996/05/24 20:40:12  jpaana
 * Initial revision
 *
 *
*/
