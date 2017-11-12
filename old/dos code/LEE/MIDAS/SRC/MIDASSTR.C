/*      midasstr.c
 *
 * MIDAS stream library
 *
 * $Id: midasstr.c,v 1.7 1997/01/26 23:31:44 jpaana Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifdef __LINUX__
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#else
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <string.h>                     /* FIXME - don't use C RTL */
#include <process.h>
#endif

#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "mmem.h"
#include "sdevice.h"
#include "file.h"
#include "midasstr.h"



/* Maximum number of streams: (just for keeping track of all streams in
   playback) */
#define MAXSTREAMS 32
/* 32 streams will probably bring any system to its knees, but we'll just
   be safe */

static strStream *streams[MAXSTREAMS];  /* all streams currently playing */
static SoundDevice *SD;                 /* Sound Device for streams */



/****************************************************************************\
*       enum strFunctIDs
*       ----------------
* Description:  Function IDs for stream library functions
\****************************************************************************/

enum strFunctIDs
{
    ID_strInit = ID_str,
    ID_strClose,
    ID_strPlayStreamFile,
    ID_strPlayStreamPolling,
    ID_strPlayStreamCallback,
    ID_strStopStream,
    ID_strFeedStreamData,
    ID_strSetStreamVolume,
    ID_strSetStreamPanning,
    ID_strIsStreamFinished,
    ID_strSetStreamRate
};




/****************************************************************************\
*
* Function:     int strInit(SoundDevice *SD)
*
* Description:  Initializes the stream library
*
* Input:        SoundDevice *SD         Pointer to the Sound Device that will
*                                       be used for playing the streams
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING strInit(SoundDevice *_SD)
{
    int         i;

    /* Remember the Sound Device: */
    SD = _SD;

    /* No streams are being played: */
    for ( i = 0; i < MAXSTREAMS; i++ )
        streams[i] = NULL;

    return OK;
}




/****************************************************************************\
*
* Function:     int strClose(void)
*
* Description:  Uninitializes the stream library
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING strClose(void)
{
    int         i, error;

    /* Check if there are any streams being played - if yes, stop them: */
    for ( i = 0; i < MAXSTREAMS; i++ )
    {
        if ( streams[i] != NULL )
        {
            if ( (error = strStopStream(streams[i])) != OK )
                PASSERROR(ID_strClose)
        }
    }

    return OK;
}



/****************************************************************************\
*
* Function:     static int StartStream(strStream **stream)
*
* Description:  Starts a new stream, and allocates the info structure.
*
* Input:        strStream **stream      pointer to steam state pointer
*
* Returns:      MIDAS error code
*
\****************************************************************************/

static int StartStream(strStream **stream)
{
    int         error;
    int         num;

    /* Find a free spot from the stream table: */
    num = 0;
    while ( streams[num] != NULL )
    {
        num++;
        if ( num >= MAXSTREAMS )
            return errOutOfResources;
    }

    /* Allocate memory for the stream state structure: */
    if ( (error = memAlloc(sizeof(strStream), (void**) stream)) != OK )
        return error;

    streams[num] = *stream;

    return OK;
}




/****************************************************************************\
*
* Function:     static int FreeStream(strStream *stream)
*
* Description:  Deallocates a steram and removes it from the stream list
*
* Input:        strStream *stream       stream to be deallocated
*
* Returns:      MIDAS error code
*
\****************************************************************************/

static int FreeStream(strStream *stream)
{
    int         error;
    int         i;

    /* Remove the stream from the stream list: */
    for ( i = 0; i < MAXSTREAMS; i++ )
    {
        if ( streams[i] == stream )
            streams[i] = NULL;
    }

    /* Deallocate the stream structure: */
    if ( (error = memFree(stream)) != OK )
        return error;

    return OK;
}



/****************************************************************************\
*
* Function:     unsigned StreamBufferLeft(strStream *stream)
*
* Description:  Calculates the number of bytes of free space in a stream
*               buffer
*
* Input:        strStream *stream       stream to check
*
* Returns:      Number of bytes of free space left
*
\****************************************************************************/

static unsigned StreamBufferLeft(strStream *stream)
{
    unsigned    readPos;
    unsigned    spaceLeft;

    /* FIXME - error callback? */

    /* Get reading position: */
    SD->GetPosition(stream->sdChannel, &readPos);

    /* If read and write positions are equal, the whole buffer is empty: */
    if ( readPos == stream->bufferWritePos )
        return stream->bufferBytes - stream->sampleSize;

    /* Calculate the amount of free space: */
    if ( readPos >= stream->bufferWritePos )
        spaceLeft = readPos - stream->bufferWritePos;
    else
        spaceLeft = stream->bufferBytes - stream->bufferWritePos + readPos;

    /* Make sure that we won't wrap around: */
    if ( spaceLeft >= stream->sampleSize )
        spaceLeft -= stream->sampleSize;
    else
        spaceLeft = 0;

    return spaceLeft;
}




/****************************************************************************\
*
* Function:     void WriteStreamData(strStream *stream, uchar *data,
*                   unsigned numBytes)
*
* Description:  Writes data to a stream buffer, updating buffer write position
*               and taking care of wraparound
*
* Input:        strStream *stream       stream for the data
*               uchar *data             pointer to data
*               unsigned numBytes       number of bytes of data to write
*
\****************************************************************************/

static void WriteStreamData(strStream *stream, uchar *data, unsigned numBytes)
{
    unsigned    len = stream->bufferBytes;
    unsigned    pos = stream->bufferWritePos;
    unsigned    left, now;

    /* Loop until we get everything copied: */
    while ( numBytes )
    {
        /* Get number of bytes of space before buffer end: */
        left = len - pos;

        /* Don't copy past buffer end: */
        if ( numBytes > left )
            now = left;
        else
            now = numBytes;

        /* Copy the data: */
        memcpy(&stream->buffer[pos], data, now);

        /* Advance buffer position: */
        pos += now;
        numBytes -= now;
        data += now;

        /* Wrap to buffer beginning if necessary: */
        if ( pos >= len )
            pos = 0;
    }

    /* Remember the new buffer position: */
    stream->bufferWritePos = pos;
    /* FIXME: error check: */
    SD->SetStreamWritePosition(stream->sdChannel, pos);
}




/****************************************************************************\
*
* Function:     void FillStreamBuffer(strStream *stream, uchar value,
*                   unsigned numBytes)
*
* Description:  Fills a stream buffer with a byte, updating buffer write
*               position and taking care of wraparound
*
* Input:        strStream *stream       stream for the data
*               uchar value             byte to fill the buffer with
*               unsigned numBytes       number of bytes to fill
*
\****************************************************************************/

static void FillStreamBuffer(strStream *stream, uchar value,
    unsigned numBytes)
{
    unsigned    len = stream->bufferBytes;
    unsigned    pos = stream->bufferWritePos;
    unsigned    left, now;

    /* Loop until we get everything filled */
    while ( numBytes )
    {
        /* Get number of bytes of space before buffer end: */
        left = len - pos;

        /* Don't fill past buffer end: */
        if ( numBytes > left )
            now = left;
        else
            now = numBytes;

        /* Fill it: */
        memset(&stream->buffer[pos], value, now);

        /* Advance buffer position: */
        pos += now;
        numBytes -= now;

        /* Wrap to buffer beginning if necessary: */
        if ( pos >= len )
            pos = 0;
    }

    /* Remember the new buffer position: */
    stream->bufferWritePos = pos;
    /* FIXME: error check: */
    SD->SetStreamWritePosition(stream->sdChannel, pos);
}




/****************************************************************************\
*
* Function:     void StreamPlayerThread(void *stream)
*
* Description:  The stream player thread
*
* Input:        void *stream            stream state information for this
*                                       stream
*
\****************************************************************************/

#ifdef __LINUX__
static void* StreamPlayerThread(void *stream)
#else
#ifdef __WC32__
static void StreamPlayerThread(void *stream)
#else
static void __cdecl StreamPlayerThread(void *stream)
#endif
#endif
{
    /* FIXME - we should check for errors, but for that we need some way to
       report the errors to the user - a callback maybe? */

    unsigned    bufferLeft;
    unsigned    doNow;
    strStream   *s = (strStream*) stream;

    /* Round and round we go, until it's exit time */

    while ( !s->threadExitFlag )
    {
        /* Get amount of free space in buffer: */
        bufferLeft = StreamBufferLeft(s);

        /* Fill the free space - either read data from the file or just
           clear it: */
        while ( bufferLeft )
        {
            if ( s->fileLeft )
            {
                /* There is still data in the file to read */

                /* Don't read past End Of File: */
                if ( bufferLeft > s->fileLeft )
                    doNow = s->fileLeft;
                else
                    doNow = bufferLeft;

                /* Read the data from the file: */
                /* (the file buffer is always at least as large as the
                   stream buffer so we can't overflow) */
                fileRead(s->f, s->fileBuffer, doNow);

                /* Write the data to the stream buffer: */
                WriteStreamData(s, s->fileBuffer, doNow);

                bufferLeft -= doNow;
                s->fileLeft -= doNow;

                /* Check if we reached the file end and should loop: */
                if ( (s->fileLeft <= 0) && (s->loop) )
                {
                    /* Restart the file: */
                    s->fileLeft = s->fileLength;
                    fileSeek(s->f, 0, fileSeekAbsolute);
                }
            }
            else
            {
                /* No data left in file, just clear the buffer: */
                FillStreamBuffer(s, s->bufferClearVal, bufferLeft);
                bufferLeft = 0;
            }
        }

        /* Sleep for a while: */
#ifdef __LINUX__
        usleep(s->threadDelay * 1000);
#else
        Sleep(s->threadDelay);
#endif
    }

    /* Exit flag detected: */
    s->threadExitFlag = 0;

    /* Get lost: */
#ifdef __LINUX__
    pthread_exit(0);
    return NULL;
#else
    _endthread();
#endif
}




/****************************************************************************\
*
* Function:     int strPlayStreamFile(unsigned channel, char *fileName,
*                   unsigned sampleType, ulong sampleRate,
*                   unsigned bufferLength, int loop, strStream **stream)
*
* Description:  Starts playing a digital sound stream from a file. Creates a
*               new thread that will take care of reading the file and feeding
*               it to the stream buffer
*
* Input:        unsigned channel        channel number for the stream
*               char *fileName          stream file name
*               unsigned sampleType     stream sample type
*               ulong sampleRate        sampling rate
*               unsigned bufferLength   stream buffer length in milliseconds
*               int loop                1 if the stream should be looped,
*                                       0 if not
*               strStream **stream      pointer to stream state pointer
*
* Returns:      MIDAS error code. Pointer to the stream state structure will
*               be written to *stream
*
\****************************************************************************/

int CALLING strPlayStreamFile(unsigned channel, char *fileName,
    unsigned sampleType, ulong sampleRate, unsigned bufferLength, int loop,
    strStream **stream)
{
    int         error;
    long        fileLen;
    fileHandle  f;
    strStream   *s;
#ifdef __WIN32__
#ifdef __WC32__
    int         streamThread;
#else
    ulong       streamThread;
#endif
#endif
#ifdef __LINUX__
    int         code;
#endif


    /* Stop any sound on the channel: */
    if ( (error = SD->StopSound(channel)) != OK )
        PASSERROR(ID_strPlayStreamFile);

    /* Allocate a stream state structure for the new stream: */
    if ( (error = StartStream(stream)) != OK )
        PASSERROR(ID_strPlayStreamFile);
    s = *stream;

    /* Initialize the stream structure: */
    s->sdChannel = channel;
    s->streamMode = strStreamPlayFile;
    s->loop = loop;
    s->threadExitFlag = 0;
    s->threadDelay = bufferLength / 8;
    s->callback = NULL;

    /* Check the sample type and initialize accordingly: */
    switch ( sampleType )
    {
        case smp8bitMono:
            s->sampleSize = 1;
            s->bufferClearVal = 128;
            break;

        case smp16bitMono:
            s->sampleSize = 2;
            s->bufferClearVal = 0;
            break;

        case smp8bitStereo:
            s->sampleSize = 2;
            s->bufferClearVal = 128;
            break;

        case smp16bitStereo:
            s->sampleSize = 4;
            s->bufferClearVal = 0;
            break;

        default:
            ERROR(errInvalidArguments, ID_strPlayStreamFile);
            return errInvalidArguments;
    }

    /* Calculate the buffer size in samples: (make it a multiple of 4) */
    s->bufferSamples = ((bufferLength * sampleRate / 1000) + 3) & (~3);

    /* And in bytes: */
    s->bufferBytes = s->sampleSize * s->bufferSamples;

    /* Allocate the buffer: */
    if ( (error = memAlloc(s->bufferBytes, (void**) &s->buffer)) != OK )
    {
        FreeStream(s);
        PASSERROR(ID_strPlayStreamFile);
    }

    /* Clear it: */
    s->bufferWritePos = 0;
    memset(s->buffer, s->bufferClearVal, s->bufferBytes);

    /* Allocate a file reading buffer: */
    s->fileBufferBytes = s->bufferBytes;
    if ( (error = memAlloc(s->fileBufferBytes, (void**) &s->fileBuffer))
        != OK )
    {
        memFree(s->buffer);
        FreeStream(s);
        PASSERROR(ID_strPlayStreamFile);
    }

    /* Open the stream file and get its length: */
    if ( (error = fileOpen(fileName, fileOpenRead, &f)) != OK )
    {
        memFree(s->fileBuffer);
        memFree(s->buffer);
        FreeStream(s);
        PASSERROR(ID_strPlayStreamFile);
    }

    if ( (error = fileGetSize(f, &fileLen)) != OK )
    {
        fileClose(f);
        memFree(s->fileBuffer);
        memFree(s->buffer);
        FreeStream(s);
        PASSERROR(ID_strPlayStreamFile);
    }

    s->f = f;
    s->fileLength = s->fileLeft = fileLen;

    /* If the file is larger than the stream buffer, fill the buffer with data
       from the file to minimize delay at startup: */
    if ( s->fileLeft > s->bufferBytes )
    {
        if ( (error = fileRead(f, s->buffer, s->bufferBytes -
            s->sampleSize)) != OK )
        {
            fileClose(f);
            memFree(s->fileBuffer);
            memFree(s->buffer);
            FreeStream(s);
            PASSERROR(ID_strPlayStreamFile);
        }
        s->fileLeft -= s->bufferBytes - s->sampleSize;

        s->bufferWritePos = s->bufferBytes - s->sampleSize;
    }

    /* Start playing the stream: */
    if ( (error = SD->StartStream(s->sdChannel, s->buffer, s->bufferBytes,
        sampleType, sampleRate)) != OK )
    {
        fileClose(f);
        memFree(s->fileBuffer);
        memFree(s->buffer);
        FreeStream(s);
        PASSERROR(ID_strPlayStreamFile);
    }

    /* Set stream write position to the end of (possibly) just read data: */
    if ( (error = SD->SetStreamWritePosition(s->sdChannel, s->bufferWritePos))
        != OK )
    {
        SD->StopStream(s->sdChannel);
        fileClose(f);
        memFree(s->fileBuffer);
        memFree(s->buffer);
        FreeStream(s);
        PASSERROR(ID_strPlayStreamFile);
    }

    /* Start the stream player thread: */

#ifdef __WIN32__
#ifdef __WC32__
    streamThread = _beginthread(StreamPlayerThread, NULL, 4096, (void*) s);

    if ( streamThread == -1 )
    {
        /* Couldn't create thread */
        SD->StopStream(s->sdChannel);
        fileClose(f);
        memFree(s->fileBuffer);
        memFree(s->buffer);
        FreeStream(s);
        ERROR(errOutOfResources, ID_strPlayStreamFile);
        return errOutOfResources;
    }
#else
    streamThread = _beginthread(StreamPlayerThread, 4096, (void*) s);

    if ( streamThread == -1 )
    {
        /* Couldn't create thread */
        SD->StopStream(s->sdChannel);
        fileClose(f);
        memFree(s->fileBuffer);
        memFree(s->buffer);
        FreeStream(s);
        ERROR(errOutOfResources, ID_strPlayStreamFile);
        return errOutOfResources;
    }
#endif
#else
    code = pthread_create(&s->playerThread, NULL, StreamPlayerThread,
        (void*) s);
    if ( code )
    {
        /* Couldn't create thread */
        SD->StopStream(s->sdChannel);
        fileClose(f);
        memFree(s->fileBuffer);
        memFree(s->buffer);
        FreeStream(s);
        ERROR(errOutOfResources, ID_strPlayStreamFile);
        return errOutOfResources;
    }
#endif
    /* The thread is playing OK */

    return OK;
}




/****************************************************************************\
*
* Function:     int strStopStream(strStream *stream)
*
* Description:  Stops playing a stream. This function will also destroy the
*               playback thread for stream file playback.
*
* Input:        strStream *stream       stream state pointer for the stream
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING strStopStream(strStream *stream)
{
#ifdef __LINUX__
    void        *retval;
#endif
    int         error;

    /* Stop the player thread if we are playing from a file: */
    if ( stream->streamMode == strStreamPlayFile )
    {
        /* Signal the stream player thread that it should actually stop: */
        stream->threadExitFlag = 1;

        /* Wait until it stops: */
#ifdef __LINUX__
        pthread_join(stream->playerThread, &retval);
#else
        while ( stream->threadExitFlag )
            Sleep(stream->threadDelay);
#endif
        /* [Now is that ugly or what? But it works and it's portable] */
    }

    /* Stop the Sound Device playing the stream: */
    if ( (error = SD->StopStream(stream->sdChannel)) != OK )
    {
        /* Failed - let's try to do at least some cleanup anyway: */
        if ( stream->streamMode == strStreamPlayFile )
        {
            fileClose(stream->f);
            memFree(stream->fileBuffer);
        }
        memFree(stream->buffer);
        FreeStream(stream);
        PASSERROR(ID_strStopStream);
    }

    /* Close the file and deallocate file buffer only if we were playing a
       stream file: */
    if ( stream->streamMode == strStreamPlayFile )
    {
        /* Close the stream file: */
        if ( (error = fileClose(stream->f)) != OK )
        {
            memFree(stream->fileBuffer);
            memFree(stream->buffer);
            FreeStream(stream);
            PASSERROR(ID_strStopStream);
        }

        /* Deallocate stream file buffer: */
        if ( (error = memFree(stream->fileBuffer)) != OK )
        {
            memFree(stream->buffer);
            FreeStream(stream);
            PASSERROR(ID_strStopStream);
        }
    }

    /* Deallocate stream buffer: */
    if ( (error = memFree(stream->buffer)) != OK )
    {
        FreeStream(stream);
        PASSERROR(ID_strStopStream);
    }

    /* Finally, free the stream: */
    if ( (error = FreeStream(stream)) != OK )
        PASSERROR(ID_strStopStream);

    /* Phew, done: */
    return OK;
}




/****************************************************************************\
*
* Function:     int strPlayStreamPolling(unsigned channel,
*                   unsigned sampleType, ulong sampleRate,
*                   unsigned bufferLength, strStream **stream)
*
* Description:  Starts playing a stream in polling mode. Use
*               strFeedStreamData() to feed the stream data to the player
*
* Input:        unsigned channel        channel number for the stream
*               unsigned sampleType     stream sample type
*               ulong sampleRate        stream sampling rate
*               unsigned bufferLength   stream buffer length in milliseconds
*               strStream **stream      pointer to stream state pointer
*
* Returns:      MIDAS error code. Pointer to the stream state structure will
*               be written to *stream
*
\****************************************************************************/

int CALLING strPlayStreamPolling(unsigned channel, unsigned sampleType,
    ulong sampleRate, unsigned bufferLength, strStream **stream)
{
    int         error;
    strStream   *s;

    /* Stop any sound on the channel: */
    if ( (error = SD->StopSound(channel)) != OK )
        PASSERROR(ID_strPlayStreamFile);

    /* Allocate a stream state structure for the new stream: */
    if ( (error = StartStream(stream)) != OK )
        PASSERROR(ID_strPlayStreamFile);
    s = *stream;

    /* Initialize the stream structure: */
    s->sdChannel = channel;
    s->streamMode = strStreamPoll;
    s->loop = 1;
    s->threadExitFlag = 0;
    s->threadDelay = bufferLength / 8;
    s->callback = NULL;

    /* Check the sample type and initialize accordingly: */
    switch ( sampleType )
    {
        case smp8bitMono:
            s->sampleSize = 1;
            s->bufferClearVal = 128;
            break;

        case smp16bitMono:
            s->sampleSize = 2;
            s->bufferClearVal = 0;
            break;

        case smp8bitStereo:
            s->sampleSize = 2;
            s->bufferClearVal = 128;
            break;

        case smp16bitStereo:
            s->sampleSize = 4;
            s->bufferClearVal = 0;
            break;

        default:
            ERROR(errInvalidArguments, ID_strPlayStreamFile);
            return errInvalidArguments;
    }

    /* Calculate the buffer size in samples: (make it a multiple of 4) */
    s->bufferSamples = ((bufferLength * sampleRate / 1000) + 3) & (~3);

    /* And in bytes: */
    s->bufferBytes = s->sampleSize * s->bufferSamples;

    /* Allocate the buffer: */
    if ( (error = memAlloc(s->bufferBytes, (void**) &s->buffer)) != OK )
    {
        FreeStream(s);
        PASSERROR(ID_strPlayStreamPolling);
    }

    /* Clear it: */
    s->bufferWritePos = 0;
    memset(s->buffer, s->bufferClearVal, s->bufferBytes);

    /* Start playing the stream: */
    if ( (error = SD->StartStream(s->sdChannel, s->buffer, s->bufferBytes,
        sampleType, sampleRate)) != OK )
    {
        memFree(s->buffer);
        FreeStream(s);
        PASSERROR(ID_strPlayStreamFile);
    }

    return OK;
}



/****************************************************************************\
*
* Function:     int strPlayStreamCallback(unsigned sampleType,
*                  ulong sampleRate, unsigned bufferBytes,
*                  void (CALLING *callback)(uchar *buffer, strStream *stream))
*
* Description:  Starts playing a stream with a callback.
*
* Input:        unsigned sampleType     stream sample type
*               ulong sampleRate        stream sampling rate
*               unsigned bufferBytes    stream buffer size _IN BYTES_
*               ... *callback           stream player callback
*               strStream **stream      pointer to stream state pointer
*
* Returns:      MIDAS error code. Pointer to the stream state structure will
*               be written to *stream
*
* Notes:        The callback function will be called each time the whole
*               stream buffer needs to be filled. It receives as an argument
*               a pointer to the buffer, and the stream state pointer.
*
*               The function will be called from inside the mixing routine,
*               so it should return relatively rapidly - do not use this
*               function for, for example, loading data from disc.
*
\****************************************************************************/

int CALLING strPlayStreamCallback(unsigned sampleType, ulong sampleRate,
    unsigned bufferBytes,
    void (CALLING *callback)(uchar *buffer, strStream *stream));




/****************************************************************************\
*
* Function:     int strFeedStreamData(strStream *stream, uchar *data,
*                   unsigned numBytes, int feedAll, unsigned *numFed)
*
* Description:  Feeds sample data to a stream that is being played in polling
*               mode.
*
* Input:        strStream *stream       stream state pointer from
*                                       strPlayStreamPolling()
*               uchar *data             pointer to stream data
*               unsigned numBytes       number of bytes of data to feed. Note!
*                                       This must be a multiple of the stream
*                                       sample size
*               int feedAll             1 if all data should be fed in all
*                                       circumstances. The function will block
*                                       the current thread if this flag is 1
*                                       until all data is fed.
*               unsigned *numFed        pointer to a variable that will
*                                       contain the number of bytes actually
*                                       fed
*
* Returns:      MIDAS error code. The number of bytes of data actually fed is
*               written to *numFed.
*
\****************************************************************************/

int CALLING strFeedStreamData(strStream *stream, uchar *data,
    unsigned numBytes, int feedAll, unsigned *numFed)
{
    unsigned    bufferLeft;
    unsigned    doNow;

    *numFed = 0;

    /* Loop until all data has been fed if feedAll is 1: */
    do
    {
        /* Get amount of free space in buffer: */
        bufferLeft = StreamBufferLeft(stream);

        if ( bufferLeft > numBytes )
            doNow = numBytes;
        else
            doNow = bufferLeft;

        /* Write the data there: */
        WriteStreamData(stream, data, doNow);

        /* Update pointers and counters: */
        numBytes -= doNow;
        *numFed += doNow;
        data += doNow;

        /* If we should feed all data, and there is data to go, sleep for
           a while: */
        if ( feedAll && numBytes )
        {
#ifdef __LINUX__
            usleep(stream->threadDelay * 1000);
#else
            Sleep(stream->threadDelay);
#endif
        }
    } while ( feedAll && numBytes );

    return OK;
}



/****************************************************************************\
*
* Function:     int strSetStreamRate(strStream *stream, ulong sampleRate)
*
* Description:  Changes the sampling rate for a stream
*
* Input:        strStream *stream       stream state pointer
*               ulong sampleRate        new sampling rate in Hz
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING strSetStreamRate(strStream *stream, ulong sampleRate)
{
    int         error;

    /* Set the sample rate: */
    if ( (error = SD->SetRate(stream->sdChannel, sampleRate)) != OK )
        PASSERROR(ID_strSetStreamRate);

    return OK;
}




/****************************************************************************\
*
* Function:     int strSetStreamVolume(strStream *stream, unsigned volume)
*
* Description:  Changes the playback volume for a stream (the default is 64).
*
* Input:        strStream *stream       stream state pointer
*               unsigned volume         new volume (0-64)
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING strSetStreamVolume(strStream *stream, unsigned volume)
{
    int         error;

    /* Set the volume: */
    if ( (error = SD->SetRate(stream->sdChannel, volume)) != OK )
        PASSERROR(ID_strSetStreamVolume);

    return OK;
}




/****************************************************************************\
*
* Function:     int strSetStreamPanning(strStream *stream, int panning)
*
* Description:  Changes the panning for a stream (the default is middle).
*
* Input:        strStream *stream       stream state pointer
*               int panning             new panning position
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING strSetStreamPanning(strStream *stream, int panning)
{
    int         error;

    /* Set the panning position: */
    if ( (error = SD->SetRate(stream->sdChannel, panning)) != OK )
        PASSERROR(ID_strSetStreamPanning);

    return OK;
}




/****************************************************************************\
*
* Function:     int strIsStreamFinished(strStream *stream, int *finished)
*
* Description:  Checks whether a given stream has reached the end of the
*               stream file or not. Only applies to streams played from a
*               file.
*
* Input:        strStream *stream       stream state pointer
*               int *finished           pointer to result variable
*
* Returns:      MIDAS error code. If the stream is finished, 1 will be written
*               to *finished, otherwise *finished will contain 0.
*
\****************************************************************************/

int CALLING strIsStreamFinished(strStream *stream, int *finished);


/*
 * $Log: midasstr.c,v $
 * Revision 1.7  1997/01/26 23:31:44  jpaana
 * Small fixes for pthreads
 *
 * Revision 1.6  1997/01/16 19:31:53  pekangas
 * Fixed to compile with Linux GCC (but do they work?)
 *
 * Revision 1.5  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.4  1997/01/16 18:25:08  pekangas
 * Implemented strSetStreamRate, strSetStreamVolume and strSetStreamPanning
 *
*/
