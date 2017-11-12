/*      WinWave.c
 *
 * Windows Wave Sound Devicee
 *
 * $Id: winwave.c,v 1.8 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <windows.h>
#include <mmsystem.h>
#include <stdio.h>

#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "mglobals.h"
#include "sdevice.h"
#include "mmem.h"
#include "dsm.h"

RCSID(char const *winwave_rcsid = "$Id: winwave.c,v 1.8 1997/01/16 18:41:59 pekangas Exp $";)

//#define DUMPBUFFER

#define WINWVERSION 1.00
#define WINWVERSTR "1.00"


/* Maximum number of buffer blocks: (FIXME) */
#define MAXBUFBLOCKS 32

/* Number of bits of accuracy in mixing for 8-bit output: */
#define MIX8BITS 12




/* Sound Device information */

    /* Sound Card names: */
static char     *winwCardName = "Windows Wave output";



/* Sound Device internal static variables */
static unsigned mixRate, outputMode;
static unsigned bufferLen, numBlocks, blockLen;
static unsigned mixElemSize;

static unsigned amplification;
static unsigned updateMix;              /* number of elements to mix between
                                           two updates */
static unsigned mixLeft;                /* number of elements to mix before
                                           next update */


static HWAVEOUT waveHandle;
static HANDLE   blockHandles[MAXBUFBLOCKS];
static uchar    *blocks[MAXBUFBLOCKS];
static HANDLE   blockHeaderHandles[MAXBUFBLOCKS];
static WAVEHDR  *blockHeaders[MAXBUFBLOCKS];
static int      blockPrepared[MAXBUFBLOCKS];

static unsigned blockNum;               /* current mixing block number */
static unsigned blockPos;               /* mixing position inside block */

static uchar    *ppTable;               /* post-processing table for 8-bit
                                           output */

#ifdef DUMPBUFFER
static FILE     *buff;
#endif


/****************************************************************************\
*       enum winwFunctIDs
*       -----------------
* Description:  ID numbers for Windows Wave Sound Device functions
\****************************************************************************/

enum winwFunctIDs
{
    ID_winwDetect = ID_winw,
    ID_winwInit,
    ID_winwClose,
    ID_winwGetMode,
    ID_winwOpenChannels,
    ID_winwSetAmplification,
    ID_winwGetAmplification,
    ID_winwSetUpdRate,
    ID_winwStartPlay,
    ID_winwPlay
};



/* Local prototypes: */
int CALLING winwSetAmplification(unsigned _amplification);
int CALLING winwGetAmplification(unsigned *_amplification);
int CALLING winwSetUpdRate(unsigned updRate);





/****************************************************************************\
*
* Function:     static int winwError(MMRESULT error)
*
* Description:  Converts a Windows multimedia system error code to MIDAS
*               error code
*
* Input:        MMRESULT error          Windows multimedia system error code
*
* Returns:      MIDAS error code
*
\****************************************************************************/

static int winwError(MMRESULT error)
{
    switch ( error )
    {
        case MMSYSERR_NOERROR:
            return OK;
        case MMSYSERR_ERROR:
            return errUndefined;
        case MMSYSERR_BADDEVICEID:
        case MMSYSERR_INVALHANDLE:
        case MMSYSERR_NOTENABLED:
            return errInvalidDevice;
        case MMSYSERR_ALLOCATED:
        case MMSYSERR_HANDLEBUSY:
            return errDeviceBusy;
        case MMSYSERR_NODRIVER:
            return errDeviceNotAvailable;
        case MMSYSERR_NOMEM:
            return errOutOfMemory;
        case MMSYSERR_NOTSUPPORTED:
            return errUnsupported;
        case MMSYSERR_INVALFLAG:
        case MMSYSERR_INVALPARAM:
            return errInvalidArguments;
        case WAVERR_BADFORMAT:
            return errBadMode;
        case WAVERR_STILLPLAYING:
            return errDeviceBusy;
        case WAVERR_UNPREPARED:
            return errInvalidArguments;
        case WAVERR_SYNC:
            return errInvalidDevice;
    }

    return errUndefined;
}

    /* Error code passing macros for multimedia system errors - similar to
       PASSERROR in errors.h: */

#ifdef DEBUG
    #define PASSWINERR(error_, functID) { error = winwError(error_); \
        errAdd(winwError(error_), functID); return error; }
#else
    #define PASSWINERR(error_, functID) return winwError(error_);
#endif




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
* Function:     int winwDetect(int *result)
*
* Description:  Detects a Windows Wave Sound Device
*
* Input:        int *result             pointer to detection result
*
* Returns:      MIDAS error code. Detection result (1 if detected, 0 if not)
*               is written to *result.
*
\****************************************************************************/

int CALLING winwDetect(int *result)
{
    /* Check that we have at least one wave output device: */
    if ( waveOutGetNumDevs() < 1 )
        *result = 0;
    else
        *result = 1;

    return OK;
}




/****************************************************************************\
*
* Function:     int winwInit(unsigned mixRate, unsigned mode)
*
* Description:  Initializes Windows Wave Sound Device
*
* Input:        unsigned mixRate        mixing rate in Hz
*               unsigned mode           output mode
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING winwInit(unsigned _mixRate, unsigned mode)
{
    unsigned    i;
    MMRESULT    mmError;
    int         error;
    WAVEHDR     *header;
    WAVEFORMATEX format;
    int         mixMode;

    mixRate = _mixRate;

    /* Determine the actual output mode: */
    if ( mode & sdMono )
        outputMode = sdMono;
    else
        outputMode = sdStereo;
    if ( mode & sd8bit )
        outputMode |= sd8bit;
    else
        outputMode |= sd16bit;

    /* Calculate one mixing element size: */
    if ( outputMode & sd16bit )
        mixElemSize = 2;
    else
        mixElemSize = 1;
    if ( outputMode & sdStereo )
        mixElemSize <<= 1;

    /* Limit number of blocks to MAXBUFBLOCKS: */
    numBlocks = mBufferBlocks;
    if ( numBlocks > MAXBUFBLOCKS )
        numBlocks = MAXBUFBLOCKS;

    /* Calculate required buffer block length: (must be a multiple of
       16 bytes) */
    blockLen = mixRate * mixElemSize * mBufferLength / 1000 / numBlocks;
    blockLen = (blockLen + 15) & (~15);

    bufferLen = numBlocks * blockLen;

    blockNum = blockPos = 0;

    /* Set up wave output format structure: */
    format.wFormatTag = WAVE_FORMAT_PCM;
    if ( outputMode & sdStereo )
        format.nChannels = 2;
    else
        format.nChannels = 1;
    format.nSamplesPerSec = mixRate;
    format.nAvgBytesPerSec = mixElemSize * mixRate;
    format.nBlockAlign = mixElemSize;
    if ( outputMode & sd16bit )
        format.wBitsPerSample = 16;
    else
        format.wBitsPerSample = 8;
    format.cbSize = 0;

    /* Open wave output device using the format just set up: */
    if ( (mmError = waveOutOpen(&waveHandle, WAVE_MAPPER, &format, 0, 0, 0))
        != 0 )
        PASSWINERR(mmError, ID_winwInit);

    /* Allocate and lock memory for all mixing blocks: */
    for ( i = 0; i < numBlocks; i++ )
    {
        /* Allocate global memory for mixing block: */
        if ( (blockHandles[i] = GlobalAlloc(GMEM_MOVEABLE | GMEM_SHARE,
            blockLen)) == NULL )
        {
            ERROR(errOutOfMemory, ID_winwInit);
            return errOutOfMemory;
        }
/*        printf("Block %i handle %08X\n", i, blockHandles[i]); */

        /* Lock mixing block memory: */
        if ( (blocks[i] = GlobalLock(blockHandles[i])) == NULL )
        {
            ERROR(errUnableToLock, ID_winwInit);
            return errUnableToLock;
        }
    }

    /* Allocate and lock memory for all mixing block headers: */
    for ( i = 0; i < numBlocks; i++ )
    {
        /* Allocate global memory for mixing block: */
        if ( (blockHeaderHandles[i] = GlobalAlloc(GMEM_MOVEABLE | GMEM_SHARE,
            sizeof(WAVEHDR))) == NULL )
        {
            ERROR(errOutOfMemory, ID_winwInit);
            return errOutOfMemory;
        }

        /* Lock mixing block memory: */
        if ( (header = blockHeaders[i] = GlobalLock(blockHeaderHandles[i]))
            == NULL )
        {
            ERROR(errUnableToLock, ID_winwInit);
            return errUnableToLock;
        }

        /* Reset wave header fields: */
        header->lpData = blocks[i];
        header->dwBufferLength = blockLen;
        header->dwFlags = WHDR_DONE;        /* mark the block is done */
        header->dwLoops = 0;

        /* Block header is not prepared: */
        blockPrepared[i] = 0;
    }

    /* Allocate memory for post-processing table if necessary: */
    if ( outputMode & sd8bit )
    {
        /* Allocate memory for 8-bit output mode post-processing table: */
        if ( (error = memAlloc((1 << MIX8BITS), &ppTable)) != OK )
            PASSERROR(ID_winwInit);
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
            PASSERROR(ID_winwInit)
    }
    else
    {
        if ( (error = dsmInit(mixRate, mixMode, MIX8BITS)) != OK )
            PASSERROR(ID_winwInit)
    }

    /* Set update rate to 50Hz: */
    if ( (error = winwSetUpdRate(5000)) != OK )
        PASSERROR(ID_winwInit)

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
            ERROR(errInvalidArguments, ID_winwInit);
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
* Function:     winwClose(void)
*
* Description:  Uninitializes Windows Wave Sound Device
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING winwClose(void)
{
    int         error;
    MMRESULT    mmError;
    unsigned    i;
    int         allDone;
    DWORD       lasterror;

#ifdef DUMPBUFFER
    fclose(buff);
#endif

    /* Uninitialize Digital Sound Mixer: */
    if ( (error = dsmClose()) != OK )
        PASSERROR(ID_winwClose)

    /* Deallocate post-processing table if necessary: */
    if ( outputMode & sd8bit )
    {
        if ( (error = memFree(ppTable)) != OK )
            PASSERROR(ID_winwClose);
    }

    /* Reset wave output device, stop playback, and mark all blocks done: */
    if ( (mmError = waveOutReset(waveHandle)) != 0 )
        PASSWINERR(mmError, ID_winwClose);

    /* Make sure all blocks are indeed done: */
    while ( 1 )
    {
        allDone = 1;
        for ( i = 0; i < numBlocks; i++ )
        {
            if ( (blockHeaders[i]->dwFlags & WHDR_DONE) == 0 )
                allDone = 0;
        }
        if ( allDone )
            break;
        Sleep(20);
    }

    /* Unprepare all mixing blocks: */
    for ( i = 0; i < numBlocks; i++ )
    {
        if ( blockPrepared[i] )
        {
            if ( (mmError = waveOutUnprepareHeader(waveHandle, blockHeaders[i],
                sizeof(WAVEHDR))) != 0 )
                PASSWINERR(mmError, ID_winwClose);
        }
    }

    /* Close wave output device: */
    if ( (mmError = waveOutClose(waveHandle)) != 0 )
        PASSWINERR(mmError, ID_winwClose);

    /* Unlock and deallocate all mixing blocks: */
    for ( i = 0; i < numBlocks; i++ )
    {
/*        printf("Unlock block %i\n", i); */
        /* Unlock the mixing block handle: */
        if ( (!GlobalUnlock(blockHandles[i])) && ((lasterror = GetLastError())
            != NO_ERROR) )
        {
/*
            printf("GetLastError(): %u, Handle: %08X\n", lasterror,
                blockHandles[i]);
*/
            ERROR(errHeapCorrupted, ID_winwClose);
            return errHeapCorrupted;
        }

/*        printf("Free block %i\n", i); */
        /* Deallocate the mixing block: */
        if ( GlobalFree(blockHandles[i]) != NULL )
        {
            ERROR(errHeapCorrupted, ID_winwClose);
            return errHeapCorrupted;
        }
    }

    /* Unlock and deallocate all mixing block headers: */
    for ( i = 0; i < numBlocks; i++ )
    {
/*        printf("Unlock header %i\n", i); */
        /* Unlock the mixing block header handle: */
        if ( (!GlobalUnlock(blockHeaderHandles[i])) && (
            GetLastError() != NO_ERROR) )
        {
            ERROR(errHeapCorrupted, ID_winwClose);
            return errHeapCorrupted;
        }

/*        printf("Free header %i\n", i); */
        /* Deallocate the mixing block: */
        if ( GlobalFree(blockHeaderHandles[i]) != NULL )
        {
            ERROR(errHeapCorrupted, ID_winwClose);
            return errHeapCorrupted;
        }
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int winwGetMode(unsigned *mode)
*
* Description:  Reads the current output mode
*
* Input:        unsigned *mode          pointer to output mode
*
* Returns:      MIDAS error code. Output mode is written to *mode.
*
\****************************************************************************/

int CALLING winwGetMode(unsigned *mode)
{
    *mode = outputMode;

    return OK;
}




/****************************************************************************\
*
* Function:     int winwOpenChannels(unsigned channels)
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

int CALLING winwOpenChannels(unsigned channels)
{
    int         error;

    /* Open DSM channels: */
    if ( (error = dsmOpenChannels(channels)) != OK )
        PASSERROR(ID_winwOpenChannels)

    /* Take care of default amplification and calculate new post-processing
       table if necessary: */
/*
    if ( outputMode & sd8bit )
    {
*/
        if ( channels < 5 )
            winwSetAmplification(64);
        else
            winwSetAmplification(14*channels);
/*
    }
*/

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
* Function:     int winwSetAmplification(unsigned amplification)
*
* Description:  Sets the amplification level. Calculates new post-processing
*               tables and calls dsmSetAmplification() as necessary.
*
* Input:        unsigned amplification  amplification value
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING winwSetAmplification(unsigned _amplification)
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
            PASSERROR(ID_winwSetAmplification)
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int winwGetAmplification(unsigned *amplification);
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

int CALLING winwGetAmplification(unsigned *_amplification)
{
    *_amplification = amplification;

    return OK;
}




/****************************************************************************\
*
* Function:     int winwSetUpdRate(unsigned updRate);
*
* Description:  Sets the channel value update rate (depends on song tempo)
*
* Input:        unsigned updRate        update rate in 100*Hz (eg. 50Hz
*                                       becomes 5000).
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING winwSetUpdRate(unsigned updRate)
{
    /* Calculate number of elements to mix between two updates: (even) */
    mixLeft = updateMix = ((unsigned) ((100L * (ulong) mixRate) /
        ((ulong) updRate)) + 1) & 0xFFFFFFFE;

    return OK;
}




/****************************************************************************\
*
* Function:     int winwStartPlay(void)
*
* Description:  Prepares for playing - doesn't actually do anything here...
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING winwStartPlay(void)
{
    return OK;
}




/****************************************************************************\
*
* Function:     int winwPlay(int *callMP);
*
* Description:  Plays the sound - mixes the correct amount of data with DSM
*               and copies it to wave output buffer with post-processing.
*               Also takes care of sending fully mixed blocks to the wave
*               output device.
*
* Input:        int *callMP             pointer to music player calling flag
*
* Returns:      MIDAS error code. If enough data was mixed for one updating
*               round and music player should be called, 1 is written to
*               *callMP, otherwise 0 is written there. Note that if music
*               player can be called, winwPlay() should be called again
*               with a new check for music playing to ensure the mixing buffer
*               gets filled with new data.
*
\****************************************************************************/

int CALLING winwPlay(int *callMP)
{
    int         error;
    MMRESULT    mmError;
    unsigned    blockLeft, numElems;
    unsigned    dsmBufSize;
    unsigned    oldPos;

    /* Calculate DSM mixing buffer size in elements: (FIXME) */
    dsmBufSize = dsmMixBufferSize;
#ifdef __32__
    dsmBufSize >>= 2;
#else
    dsmBufSize >>= 1;
#endif
    if ( outputMode & sdStereo )
        dsmBufSize >>= 1;

    /* Repeat while we have unused blocks left: */

    while ( blockHeaders[blockNum]->dwFlags & WHDR_DONE )
    {
        /* Check if the block is prepared - if so, unprepare it: */
        if ( blockPrepared[blockNum] )
        {
            if ( (mmError = waveOutUnprepareHeader(waveHandle,
                blockHeaders[blockNum], sizeof(WAVEHDR))) != 0 )
                PASSWINERR(mmError, ID_winwPlay);
            blockPrepared[blockNum] = 0;
        }

        /* Calculate number of bytes of block left: */
        blockLeft = blockLen - blockPos;

        /* Calculate number of mixing elements left: */
        numElems = blockLeft / mixElemSize;

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
            PASSERROR(ID_winwPlay)

        /* Write the mixed data to output buffer: */
        oldPos = blockPos;
        blockPos = postProc(numElems, blocks[blockNum], blockPos,
            dsmMixBuffer, ppTable);

#ifdef DUMPBUFFER
        fwrite(&blocks[blockNum][oldPos], numElems * mixElemSize, 1, buff);
#endif

        /* Check if the block is full - if so, write it to the wave output
           device and move to the next one: */
        if ( blockPos >= blockLen )
        {
            blockHeaders[blockNum]->dwFlags = 0;
            /* Reset wave header fields: */
            blockHeaders[blockNum]->lpData = blocks[blockNum];
            blockHeaders[blockNum]->dwBufferLength = blockLen;
            blockHeaders[blockNum]->dwFlags = 0;
            blockHeaders[blockNum]->dwLoops = 0;

            /* Prepare block header: */
            if ( (mmError = waveOutPrepareHeader(waveHandle,
                blockHeaders[blockNum], sizeof(WAVEHDR))) != 0 )
                PASSWINERR(mmError, ID_winwPlay);
            blockPrepared[blockNum] = 1;

            if ( (mmError = waveOutWrite(waveHandle, blockHeaders[blockNum],
                sizeof(WAVEHDR))) != 0 )
                PASSWINERR(mmError, ID_winwPlay);

            //blockNum = (blockNum++) % numBlocks;
            blockPos = 0;
            blockNum++;
            if ( blockNum >= numBlocks )
                blockNum = 0;
        }

        /* Check if the music player should be called: */
        if ( mixLeft == 0 )
        {
            mixLeft = updateMix;
            *callMP = 1;
            return OK;
        }
    }

    /* No more data fits to the mixing blocks - just return without
       update: */
    *callMP = 0;

    return OK;
}






    /* WinWave Sound Device structure: */

SoundDevice     WinWave = {
    0,                                  /* tempoPoll = 0 */
    sdUseMixRate | sdUseOutputMode | sdUseDSM,  /* configBits */
    0,                                  /* port */
    0,                                  /* IRQ */
    0,                                  /* DMA */
    1,                                  /* cardType */
    1,                                  /* numCardTypes */
    sdMono | sdStereo | sd8bit | sd16bit,       /* modes */

    "Windows Wave Sound Device " WINWVERSTR,     /* name */
    &winwCardName,                              /* cardNames */
    0,                                          /* numPortAddresses */
    NULL,                                       /* portAddresses */

    &winwDetect,
    &winwInit,
    &winwClose,
    &dsmGetMixRate,
    &winwGetMode,
    &winwOpenChannels,
    &dsmCloseChannels,
    &dsmClearChannels,
    &dsmMute,
    &dsmPause,
    &dsmSetMasterVolume,
    &dsmGetMasterVolume,
    &winwSetAmplification,
    &winwGetAmplification,
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
    &winwSetUpdRate,
    &winwStartPlay,
    &winwPlay
#ifdef SUPPORTSTREAMS
    ,
    &dsmStartStream,
    &dsmStopStream,
    &dsmSetLoopCallback,
    &dsmSetStreamWritePosition
#endif
};


/*
 * $Log: winwave.c,v $
 * Revision 1.8  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.7  1997/01/16 18:28:40  pekangas
 * Added pointer to dsmSetStreamWritePosition
 *
 * Revision 1.6  1996/07/29 19:33:10  pekangas
 * Added a proper detection function
 *
 * Revision 1.5  1996/07/13 19:56:40  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.4  1996/07/08 19:40:32  pekangas
 * Fixed winwClose() calling convention
 *
 * Revision 1.3  1996/05/26 20:57:00  pekangas
 * Added StartStream and EndStream to WinWave Sound Device structure
 *
 * Revision 1.2  1996/05/25 09:32:47  pekangas
 * Changed to use mBufferLength and mBufferBlocks
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/