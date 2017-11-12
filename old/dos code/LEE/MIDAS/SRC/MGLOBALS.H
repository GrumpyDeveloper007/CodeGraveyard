/*      MGLOBALS.H
 *
 * MIDAS Sound System global variables
 *
 * $Id: mglobals.h,v 1.4 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __MGLOBALS_H
#define __MGLOBALS_H


#ifdef __cplusplus
extern "C" {
#endif


extern int GLOBALVAR mUseEMS;           /* 1 if EMS should be used */
extern int GLOBALVAR mEnableSurround;   /* 1 if surround sound is enabled */
extern int GLOBALVAR mBufferLength;     /* buffer length in milliseconds */
extern int GLOBALVAR mBufferBlocks;     /* number of buffer blocks
                                           (not applicable to all SDs) */
extern int GLOBALVAR mDefaultFramerate; /* default framerate (in 100*Hz), used
                                           when screen sync is not available*/
extern int GLOBALVAR mSyncScreen;       /* 1 if timer can be synchronized to
                                           screen */




#ifdef __cplusplus
}
#endif




#endif


/*
 * $Log: mglobals.h,v $
 * Revision 1.4  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.3  1996/05/31 21:40:35  pekangas
 * Added mSyncScreen and mDefaultFramerate
 *
 * Revision 1.2  1996/05/25 09:32:26  pekangas
 * Added mBufferLength and mBufferBlocks
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/