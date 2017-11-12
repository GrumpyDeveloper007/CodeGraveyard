/*      mpoll.c
 *
 * Functions for polling MIDAS Sound System in a thread
 *
 * $Id: mpoll.c,v 1.9 1997/01/26 23:29:45 jpaana Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __LINUX__
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <process.h>
#else
#include <unistd.h>
#include "pthread.h"
#endif
#include "midas.h"

RCSID(const char *mpoll_rcsid = "$Id: mpoll.c,v 1.9 1997/01/26 23:29:45 jpaana Exp $";)

#ifdef __LINUX__
    static pthread_t pollThread = NULL;
#endif



/****************************************************************************\
*
* Function:     void PollMIDAS(void)
*
* Description:  Polls MIDAS Sound System
*
\****************************************************************************/

void PollMIDAS(void)
{
    int         error;
    int         callMP;

    if ( !midasSDInit )
        return;

    if ( (error = midasSD->StartPlay()) != OK )
        midasError(error);
    do
    {
        if ( (error = midasSD->Play(&callMP)) != OK )
            midasError(error);
        if ( callMP )
        {
            if ( midasGMPInit )
            {
                if ( (error = gmpPlay()) != OK )
                    midasError(error);
            }
        }
    } while ( callMP && (midasSD->tempoPoll == 0) );
}



static volatile int stopPolling = 0;
static volatile unsigned pollSleep = 50;

#ifdef __LINUX__
void *PollerThread(void *dummy)
#else
#ifdef __WC32__
static void PollerThread(void *dummy)
#else
static void __cdecl PollerThread(void *dummy)
#endif
#endif
{
    dummy = dummy;

#ifndef __LINUX__
    /* We'd better make the player thread's priority still above normal: */
    SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_ABOVE_NORMAL);
#endif

    while ( stopPolling == 0 )
    {
        PollMIDAS();
#ifdef __LINUX__
	usleep(pollSleep * 1000);
#else
        Sleep(pollSleep);
#endif
    }

    stopPolling = 0;

#ifdef __LINUX__
    pthread_exit(0);
    return NULL;
#else
    _endthread();
#endif
}



/****************************************************************************\
*
* Function:     void StartPlayThread(unsigned pollPeriod)
*
* Description:  Starts polling MIDAS in a thread
*
* Input:        unsigned pollPeriod     polling period (delay between two
*                                       polling loops) in milliseconds
*
\****************************************************************************/

void StartPlayThread(unsigned pollPeriod)
{
#ifndef __LINUX__
#ifdef __WC32__
    int         pollThread;
#else
    unsigned long pollThread;
#endif
#else
    int code;
#endif
    pollSleep = pollPeriod;

    /* Start polling MIDAS in a thread: */
#ifdef __LINUX__
    code = pthread_create(&pollThread, NULL, PollerThread, NULL);
    if ( code )
        midasErrorExit("StartPlayThread: Couldn't create player thread!");
#else
#ifdef __WC32__
    pollThread = _beginthread(PollerThread, NULL, 4096, NULL);
    if ( pollThread == -1 )
        midasErrorExit("StartPlayThread: Couldn't create player thread!");
#else
    pollThread = _beginthread(PollerThread, 4096, NULL);
    if ( pollThread == -1 )
        midasErrorExit("StartPlayThread: Couldn't create player thread!");
#endif
#endif
}




/****************************************************************************\
*
* Function:     void StopPlayThread(void)
*
* Description:  Stops polling MIDAS in a thread
*
\****************************************************************************/

void StopPlayThread(void)
{
#ifdef __LINUX__
    void    *retval;
#endif
    /* Ugly but works */

    stopPolling = 1;
    while ( stopPolling )
#ifdef __LINUX__
        pthread_join(pollThread, &retval);
#else
        Sleep(pollSleep/2);
#endif
}


/*
 * $Log: mpoll.c,v $
 * Revision 1.9  1997/01/26 23:29:45  jpaana
 * Small fixes for Linux
 *
 * Revision 1.8  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.7  1996/09/28 09:00:16  jpaana
 * Still fixes for Linux
 *
 * Revision 1.6  1996/09/28 08:12:40  jpaana
 * Fixed return value of pthread_create
 *
 * Revision 1.5  1996/09/28 06:50:36  jpaana
 * Fixed for Linuxthreads-0.4
 *
 * Revision 1.4  1996/09/21 17:40:45  jpaana
 * fixed some warnings
 *
 * Revision 1.3  1996/09/21 17:18:01  jpaana
 * Added Linux-stuff
 *
 * Revision 1.2  1996/09/02 20:19:30  pekangas
 * Changed to use _beginthread with Visual C as well
 *
 * Revision 1.1  1996/08/06 20:36:37  pekangas
 * Initial revision
 *
*/
