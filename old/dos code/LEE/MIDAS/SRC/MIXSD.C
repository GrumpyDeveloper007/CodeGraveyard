/*      MIXSD.C
 *
 * Miscellaneous helper functions common to all mixing sound devices.
 * Technically these functions should be part of each Sound Device's internal
 * code, but are here to save some space and help maintenance.
 *
 * $Id: mixsd.c,v 1.2 1997/01/16 18:41:59 pekangas Exp $
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
#include "mixsd.h"
#include "sdevice.h"
#include "dsm.h"
#include "dma.h"

RCSID(const char *mixsd_rcsid = "$Id: mixsd.c,v 1.2 1997/01/16 18:41:59 pekangas Exp $";)


//#define DUMPBUFFER



#define MIX8BITS 12                     /* number of bits of accuracy in
                                           mixing for 8-bit output */

unsigned dmaBufferSize;                 /* DMA playback buffer size */
//static dmaBuffer buffer;                /* DMA playback buffer */
dmaBuffer buffer;
static unsigned mixRate;                /* mixing rate */
static unsigned outputMode;             /* output mode */
static unsigned amplification;          /* amplification level */
static unsigned updateMix;              /* number of elements to mix between
                                           two updates */
static unsigned mixLeft;                /* number of elements to mix before
                                           next update */
//static unsigned dmaPos;                 /* DMA position inside buffer */
//static unsigned mixPos;                 /* mixing position */
unsigned dmaPos, mixPos;
int             playDMA;                /* Playing through DMA -flag */
static uchar    *ppTable;               /* post-processing table for 8-bit
                                           output */

#ifdef DUMPBUFFER
#include <stdio.h>
static FILE     *f;
#endif




/****************************************************************************\
*
* Function:     static unsigned CALLING (*postProc)(unsigned numElements,
*                   uchar *bufStart, unsigned mixPos, unsigned *mixBuffer,
*                   uchar *ppTable);
*
* Description:  Pointer to the actual post-processing routine. Takes
*               DSM output elements from dsmMixBuffer and writes them to
*               DMA buffer at *bufStart in a format suitable for the Sound
*               Device.
*
* Input:        unsigned numElements    number of elements to process
*                                       (guaranteed to be even)
*               uchar *bufStart         pointer to start of DMA buffer
*               unsigned mixPos         mixing position in DMA buffer
*               unsigned *mixBuffer     source mixing buffer
*               uchar *ppTable          pointer to post-processing table
*
* Returns:      New mixing position in DMA buffer. Can not fail.
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
* Function:     int mixsdInit(unsigned mixRate, unsigned mode, unsigned
*                   dmaChNum)
*
* Description:  Common initialization for all mixing Sound Devices.
*               Initializes DMA functions, DSM, starts DMA playback and
*               allocates memory for possible post-processing tables
*
* Input:        unsigned mixRate        mixing rate in Hz
*               unsigned mode           output mode
*               int dmaChNum            DMA channel number / -1 if not to be
*                                       played yet
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING mixsdInit(unsigned _mixRate, unsigned mode, int dmaChNum)
{
    int         error;
    int         mixMode;
    U8          *p, val;
    unsigned    i;

    mixRate = _mixRate;
    outputMode = mode;
    mixPos = 0;

    /* Calculate required DMA buffer size: (1/25th of a second) */
    dmaBufferSize = mixRate / DMABUFLEN;
//    dmaBufferSize = mixRate / 10;

    /* Multiply by 2 if stereo: */
    if ( mode & sdStereo )
        dmaBufferSize *= 2;

    /* Multiply by 2 if 16-bit: */
    if ( mode & sd16bit )
        dmaBufferSize *= 2;

    /* Make buffer length a multiple of 16: */
    dmaBufferSize = (dmaBufferSize + 15) & 0xFFF0;

    /* Point postProc() to correct post-processing routine: */
    switch ( mode )
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
            ERROR(errInvalidArguments, ID_mixsdInit);
            return errInvalidArguments;
    }

    /* Allocate DMA buffer: */
    if ( (error = dmaAllocBuffer(dmaBufferSize, &buffer)) != OK )
        PASSERROR(ID_mixsdInit)

    /* Now clear the DMA buffer to avoid nasty clicks */

    /* Check zero value: */
    if ( mode & sd8bit )
        val = 0x80;
    else
        val = 0;

    /* And clear it: */
    for ( p = (U8*) buffer.dataPtr, i = 0; i < dmaBufferSize; i++,
        *(p++) = val );

    /* Allocate memory for post-processing table if necessary: */
    if ( mode & sd8bit )
    {
        /* Allocate memory for 8-bit output mode post-processing table: */
        if ( (error = memAlloc((1 << MIX8BITS), (void**) &ppTable)) != OK )
            PASSERROR(ID_mixsdInit);
    }
    else
        ppTable = NULL;

    /* Check correct mixing mode: */
    if ( mode & sdStereo )
        mixMode = dsmMixStereo;
    else
        mixMode = dsmMixMono;

    /* Initialize Digital Sound Mixer: */
    if ( mode & sd16bit )
    {
        if ( (error = dsmInit(mixRate, mixMode, 16)) != OK )
            PASSERROR(ID_mixsdInit)
    }
    else
    {
        if ( (error = dsmInit(mixRate, mixMode, MIX8BITS)) != OK )
            PASSERROR(ID_mixsdInit)
    }


    if ( dmaChNum != -1 )
    {
        /* Start playing the DMA buffer: */
        if ( (error = dmaPlayBuffer(&buffer, dmaChNum, 1)) != OK )
            PASSERROR(ID_mixsdInit)
        playDMA = 1;
    }
    else
    {
        playDMA = 0;
    }

    /* Set update rate to 50Hz: */
    if ( (error = mixsdSetUpdRate(5000)) != OK )
        PASSERROR(ID_mixsdInit)

#ifdef DUMPBUFFER
    f = fopen("dmabuffer.smp", "wb");
#endif

    return OK;
}




/****************************************************************************\
*
* Function:     int CALLING mixsdClose(void)
*
* Description:  Common uninitialization code for all mixing Sound Devices.
*               Uninitializes DMA playback and DSM and deallocates memory.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING mixsdClose(void)
{
    int         error;

    if ( playDMA == 1 )
    {
        /* Stop DMA playback: */
        if ( (error = dmaStop(buffer.channel)) != OK )
            PASSERROR(ID_mixsdClose)
    }

    /* Uninitialize Digital Sound Mixer: */
    if ( (error = dsmClose()) != OK )
        PASSERROR(ID_mixsdClose)

    /* Deallocate DMA buffer: */
    if ( (error = dmaFreeBuffer(&buffer)) != OK )
        PASSERROR(ID_mixsdClose)

    /* Deallocate post-processing table if necessary: */
    if ( outputMode & sd8bit )
    {
        if ( (error = memFree(ppTable)) != OK )
            PASSERROR(ID_mixsdClose);
    }

#ifdef DUMPBUFFER
    fclose(f);
#endif

    return OK;
}




/****************************************************************************\
*
* Function:     int mixsdGetMode(unsigned *mode)
*
* Description:  Reads the current output mode
*
* Input:        unsigned *mode          pointer to output mode
*
* Returns:      MIDAS error code. Output mode is written to *mode.
*
\****************************************************************************/

int CALLING mixsdGetMode(unsigned *mode)
{
    *mode = outputMode;

    return OK;
}




/****************************************************************************\
*
* Function:     int mixsdOpenChannels(unsigned channels)
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

int CALLING mixsdOpenChannels(unsigned channels)
{
    int         error;

    /* Open DSM channels: */
    if ( (error = dsmOpenChannels(channels)) != OK )
        PASSERROR(ID_mixsdOpenChannels)

    /* Take care of default amplification and calculate new post-processing
       table if necessary: */
    if ( channels < 5 )
        mixsdSetAmplification(64);
    else
        mixsdSetAmplification(14*channels);

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
* Function:     int mixsdSetAmplification(unsigned amplification)
*
* Description:  Sets the amplification level. Calculates new post-processing
*               tables and calls dsmSetAmplification() as necessary.
*
* Input:        unsigned amplification  amplification value
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING mixsdSetAmplification(unsigned _amplification)
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
            PASSERROR(ID_mixsdSetAmplification)
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int mixsdGetAmplification(unsigned *amplification);
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

int CALLING mixsdGetAmplification(unsigned *_amplification)
{
    *_amplification = amplification;

    return OK;
}




/****************************************************************************\
*
* Function:     int mixsdSetUpdRate(unsigned updRate);
*
* Description:  Sets the channel value update rate (depends on song tempo)
*
* Input:        unsigned updRate        update rate in 100*Hz (eg. 50Hz
*                                       becomes 5000).
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING mixsdSetUpdRate(unsigned updRate)
{
    /* Calculate number of elements to mix between two updates: (even) */
    mixLeft = updateMix = ((unsigned) ((100L * (ulong) mixRate) /
        ((ulong) updRate)) + 1) & 0xFFFFFFFE;

    return OK;
}




/****************************************************************************\
*
* Function:     int mixsdStartPlay(void)
*
* Description:  Prepares for playing - reads DMA playing position. Called
*               once before the Sound Device and music player polling loop.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING mixsdStartPlay(void)
{
    int         error;

    /* Read DMA playing position: */
    if ( (error = dmaGetPos(&buffer, &dmaPos)) != OK )
        PASSERROR(ID_mixsdStartPlay)

    return OK;
}




/****************************************************************************\
*
* Function:     int mixsdPlay(int *callMP);
*
* Description:  Plays the sound - mixes the correct amount of data with DSM
*               and copies it to DMA buffer with post-processing.
*
* Input:        int *callMP             pointer to music player calling flag
*
* Returns:      MIDAS error code. If enough data was mixed for one updating
*               round and music player should be called, 1 is written to
*               *callMP, otherwise 0 is written there. Note that if music
*               player can be called, mixsdPlay() should be called again
*               with a new check for music playing to ensure the DMA buffer
*               gets filled with new data.
*
\****************************************************************************/

int CALLING mixsdPlay(int *callMP)
{
    unsigned    *mixBuf;
    int         error;
    int         numElems, mixNow;
    int         dsmBufSize;
    int         dmaBufLeft;
#ifdef DUMPBUFFER
    unsigned    oldPos;
#endif

    /* Calculate number of bytes that fits in the buffer: */
    if ( dmaPos >= mixPos )
        numElems = dmaPos - mixPos - 16;
    else
        numElems = dmaBufferSize - mixPos + dmaPos - 16;

    /* Do not mix less than 16 bytes: */
    if ( numElems < 16 )
    {
        *callMP = 0;
        return OK;
    }

    /* Calculate actual number of elements: */
    if ( outputMode & sdStereo )
        numElems >>= 1;
    if ( outputMode & sd16bit )
        numElems >>= 1;

    /* Make sure number of elements is even: */
    numElems = numElems & 0xFFFFFFFE;

    /* Check that we won't mix more elements than there is left before next
       update: */
    if ( numElems > mixLeft )
        numElems = mixLeft;

    /* Calculate DSM mixing buffer size in elements: (FIXME) */
    dsmBufSize = dsmMixBufferSize;
#ifdef __32__
    dsmBufSize >>= 2;
#else
    dsmBufSize >>= 1;
#endif
    if ( outputMode & sdStereo )
        dsmBufSize >>= 1;

    /* Decrease number of elements before next update: */
    mixLeft -= numElems;

    /* Mix all the data and post-process it to the DMA buffer, making sure
       DSM mixing buffer will not overflow: */
    while ( numElems )
    {
        /* mixNow = number of elements to mix in this round: */
        if ( numElems > dsmBufSize )
            mixNow = dsmBufSize;
        else
            mixNow = numElems;

        /* Decrease number of elements left: */
        numElems -= mixNow;

        /* Mix the data: */
        if ( (error = dsmMixData(mixNow)) != OK )
            PASSERROR(ID_mixsdPlay)

        /* Point mixBuf to current mixing buffer position: */
        mixBuf = dsmMixBuffer;

        /* Calculate the number of elements left in DMA buffer before
           buffer end: */
        dmaBufLeft = dmaBufferSize - mixPos;
        if ( outputMode & sdStereo )
            dmaBufLeft >>= 1;
        if ( outputMode & sd16bit )
            dmaBufLeft >>= 1;

        /* If DMA buffer end would be reached, first process the data up
           to the buffer end: */
        if ( dmaBufLeft < mixNow )
        {
#ifdef DUMPBUFFER
            oldPos = mixPos;
#endif
            postProc(dmaBufLeft, (uchar*) buffer.dataPtr, mixPos, mixBuf,
                ppTable);
#ifdef DUMPBUFFER
            fwrite(((uchar*) buffer.dataPtr) + oldPos, dmaBufLeft, 1, f);
#endif
            mixNow -= dmaBufLeft;
            mixPos = 0;
            if ( outputMode & sdStereo )
                mixBuf += 2*dmaBufLeft;
            else
                mixBuf += dmaBufLeft;
        }

        /* Process the rest of the data and update mixing position: */
#ifdef DUMPBUFFER
        oldPos = mixPos;
#endif
        mixPos = postProc(mixNow, (uchar*) buffer.dataPtr, mixPos, mixBuf,
            ppTable);
#ifdef DUMPBUFFER
        fwrite(((uchar*) buffer.dataPtr) + oldPos, mixNow, 1, f);
#endif

        if ( mixPos >= dmaBufferSize )
            mixPos = 0;
    }

    /* Check if music player should be called: */
    if ( mixLeft == 0 )
    {
        mixLeft = updateMix;
        *callMP = 1;
    }
    else
    {
        *callMP = 0;
    }

    return OK;
}


/*
 * $Log: mixsd.c,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/