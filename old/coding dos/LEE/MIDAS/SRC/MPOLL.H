/*      mpoll.h
 *
 * Functions for polling MIDAS Sound System in a thread
 *
 * $Id: mpoll.h,v 1.2 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __mpoll_h
#define __mpoll_h


#ifdef __cplusplus
extern "C" {
#endif


/****************************************************************************\
*
* Function:     void PollMIDAS(void)
*
* Description:  Polls MIDAS Sound System
*
\****************************************************************************/

void PollMIDAS(void);



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

void StartPlayThread(unsigned pollPeriod);



/****************************************************************************\
*
* Function:     void StopPlayThread(void)
*
* Description:  Stops polling MIDAS in a thread
*
\****************************************************************************/

void StopPlayThread(void);


#ifdef __cplusplus
}
#endif

#endif

/*
 * $Log: mpoll.h,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/08/06 20:36:45  pekangas
 * Initial revision
 *
*/