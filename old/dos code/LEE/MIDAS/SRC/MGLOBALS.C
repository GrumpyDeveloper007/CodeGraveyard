/*      MGLOBALS.C
 *
 * MIDAS Sound System global variables
 *
 * $Id: mglobals.c,v 1.4 1997/01/16 18:41:59 pekangas Exp $
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
RCSID(const char *mglobals_rcsid = "$Id: mglobals.c,v 1.4 1997/01/16 18:41:59 pekangas Exp $";)

int             mUseEMS;                /* 1 if EMS should be used */
int             mEnableSurround;        /* 1 if surround sound is enabled */
int             mBufferLength;          /* buffer length in milliseconds */
int             mBufferBlocks;          /* number of buffer blocks
                                           (not applicable to all SDs) */
int             mDefaultFramerate;      /* default framerate (in 100*Hz), used
                                           when screen sync is not available*/
int             mSyncScreen;            /* 1 if timer can be synchronized to
                                           screen */


/*
 * $Log: mglobals.c,v $
 * Revision 1.4  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.3  1996/05/31 21:40:23  pekangas
 * Added mSyncScreen and mDefaultFramerate
 *
 * Revision 1.2  1996/05/25 09:32:13  pekangas
 * Added mBufferLength and mBufferBlocks
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/