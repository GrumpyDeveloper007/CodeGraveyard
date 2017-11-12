/*      MTYPES.H
 *
 * MIDAS Sound System common type definitions
 *
 * $Id: mtypes.h,v 1.4 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __MTYPES_H
#define __MTYPES_H

typedef unsigned char uchar;
#ifndef _LINUX_TYPES_H
typedef unsigned short ushort;
typedef unsigned long ulong;
#endif

#ifndef NULL
#define NULL 0L
#endif

#endif


/*
 * $Log: mtypes.h,v $
 * Revision 1.4  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.3  1996/09/21 17:40:45  jpaana
 * Fixed ushort and ulong warnings on Linux
 *
 * Revision 1.2  1996/05/25 15:49:57  jpaana
 * Nothing really
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/
