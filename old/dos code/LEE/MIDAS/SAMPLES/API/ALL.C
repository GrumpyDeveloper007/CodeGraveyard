/*      all.c
 *
 * A great all-in-one DLL API example
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#if defined(__NT__) || defined(__WINDOWS__) || defined(_MSC_VER)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#endif

#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include "midasdll.h"

/* No stream support in DOS: */
#ifdef __DOS__
#define NOSTREAMS
#endif


/* We'll use a maximum of 2 stream channels, 4 sample channels and
   16 channels for music: */
#define NUMSTREAMCHANNELS 2
#define NUMSAMPLECHANNELS 4
#define NUMMUSICCHANNELS 16


/****************************************************************************\
*
* Function:     void MIDASerror(void)
*
* Description:  Handles a MIDAS error - displays an error message and exits
*
\****************************************************************************/

void MIDASerror(void)
{
    int         error;

    error = MIDASgetLastError();
    printf("\nMIDAS error: %s\n", MIDASgetErrorMessage(error));
    if ( !MIDASclose() )
    {
        printf("\nBIG PANIC! MIDASclose Failed: %s\n", MIDASgetErrorMessage(
            MIDASgetLastError()));
    }
    exit(EXIT_FAILURE);
}



static MIDASmodule module;
static MIDASstreamHandle stream1, stream2;
static MIDASsample sample1, sample2;
static MIDASsamplePlayHandle playHandle1, playHandle2;


int main(void)
{
    int         key, exit = 0;

    MIDASstartup();

    setbuf(stdout, NULL);

    /* Flag that we don't have a module, effects or streams playing: */
    module = NULL;
    stream1 = stream2 = NULL;
    sample1 = sample2 = 0;
    playHandle1 = playHandle2 = 0;

    /* Decrease the size of buffer used: */
    MIDASsetOption(MIDAS_OPTION_MIXBUFLEN, 150);
    MIDASsetOption(MIDAS_OPTION_MIXBUFBLOCKS, 4);

    /* Initialize MIDAS and start background playback (at 100 polls
       per second): */
    if ( !MIDASinit() )
        MIDASerror();
    if ( !MIDASstartBackgroundPlay(100) )
        MIDASerror();

    /* Open all channels: */
    if ( !MIDASopenChannels(NUMSTREAMCHANNELS + NUMSAMPLECHANNELS +
        NUMMUSICCHANNELS) )
        MIDASerror();

    /* The first NUMSTREAMCHANNELS channels are used for streams, the next
       NUMSAMPLECHANNELS for samples and the rest for music */

    /* Set automatic sample channel range: */
    if ( !MIDASsetAutoEffectChannels(NUMSTREAMCHANNELS, NUMSAMPLECHANNELS) )
        MIDASerror();

    /* Load our samples: */
    if ( (sample1 = MIDASloadRawSample("..\\data\\explosi1.pcm",
        MIDAS_SAMPLE_8BIT_MONO, MIDAS_LOOP_NO)) == 0 )
        MIDASerror();
    if ( (sample2 = MIDASloadRawSample("..\\data\\laugh1.pcm",
        MIDAS_SAMPLE_8BIT_MONO, MIDAS_LOOP_YES)) == 0 )
        MIDASerror();

    /* Loop, reading user input, until we should exit: */
    while ( !exit )
    {
        puts("Keys:     1/2     Play/Stop sample 1\n"
             "          q/w     Play/Stop sample 2\n"
#ifndef NOSTREAMS
             "          3/4     Play/Stop stream 1\n"
             "          e/r     Play/Stop stream 2\n"
#endif
             "          5/6     Play/Stop module\n"
             "          Esc     Exit\n");

        key = getch();

        switch ( key )
        {
            case 27:
                exit = 1;
                break;

            case '1':
                if ( (playHandle1 = MIDASplaySample(sample1,
                    MIDAS_CHANNEL_AUTO, 0, 22050, 64, MIDAS_PAN_MIDDLE)) == 0)
                    MIDASerror();
                break;

            case '2':
                if ( playHandle1 != 0 )
                {
                    if ( !MIDASstopSample(playHandle1) )
                        MIDASerror();
                }
                break;

            case 'q':
                if ( (playHandle2 = MIDASplaySample(sample2,
                    MIDAS_CHANNEL_AUTO, 0, 16000, 64, -20)) == 0 )
                    MIDASerror();
                break;

            case 'w':
                if ( playHandle2 != 0 )
                {
                    if ( !MIDASstopSample(playHandle2) )
                        MIDASerror();
                }
                break;

#ifndef NOSTREAMS
            case '3':
                if ( stream1 != NULL )
                {
                    if ( !MIDASstopStream(stream1) )
                        MIDASerror();
                }
                if ( (stream1 = MIDASplayStreamFile(0, "e:\\fable-mono.sw",
                    MIDAS_SAMPLE_16BIT_MONO, 44100, 500, 0)) == NULL )
                    MIDASerror();
                break;

            case '4':
                if ( stream1 != NULL )
                {
                    if ( !MIDASstopStream(stream1) )
                        MIDASerror();
                    stream1 = NULL;
                }
                break;

            case 'e':
                if ( stream2 != NULL )
                {
                    if ( !MIDASstopStream(stream2) )
                        MIDASerror();
                }
                if ( (stream2 = MIDASplayStreamFile(1,
                    "..\\data\\powerups.pcm", MIDAS_SAMPLE_8BIT_MONO, 11025,
                    500, 1)) == NULL )
                    MIDASerror();
                break;

            case 'r':
                if ( stream2 != NULL )
                {
                    if ( !MIDASstopStream(stream2) )
                        MIDASerror();
                    stream2 = NULL;
                }
                break;
#endif /* #ifndef NOSTREAMS */

            case '5':
                if ( module != NULL )
                {
                    if ( !MIDASstopModule(module) )
                        MIDASerror();
                    if ( !MIDASfreeModule(module) )
                        MIDASerror();
                }
                if ( (module = MIDASloadModule("..\\data\\templsun.xm"))
                    == NULL )
                    MIDASerror();
                if ( !MIDASplayModule(module, 0) )
                    MIDASerror();
                break;

            case '6':
                if ( module != NULL )
                {
                    if ( !MIDASstopModule(module) )
                        MIDASerror();
                    if ( !MIDASfreeModule(module) )
                        MIDASerror();

                    module = NULL;
                }
                break;
        }
    }

    /* Stop MIDAS: */
    if ( !MIDASstopBackgroundPlay() )
        MIDASerror();
    if ( !MIDASclose() )
        MIDASerror();

    return 0;
}