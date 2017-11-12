/*      VU.H
 *
 * Real VU meter routines
 *
 * $Id: vu.h,v 1.2 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __VU_H
#define __VU_H




#ifdef __cplusplus
extern "C" {
#endif



/****************************************************************************\
*
* Function:     int vuInit(void);
*
* Description:  Initializes VU-meters, allocating room for MAXSAMPLES
*               samples.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING vuInit(void);




/****************************************************************************\
*
* Function:     int vuClose(void);
*
* Description:  Uninitializes VU-meters
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING vuClose(void);




/****************************************************************************\
*
* Function:     int vuPrepare(sdSample *sample, unsigned sampleNumber);
*
* Description:  Prepares the VU information for a sample
*
* Input:        sdSample *sample        pointer to Sound Device sample
*                                       structure for this sample
*               unsigned sampleNumber   sample number (0 - (MAXSAMPLES-1)),
*                                       usually sound device sample handle
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING vuPrepare(sdSample *sample, unsigned sampleNumber);




/****************************************************************************\
*
* Function:     int vuRemove(unsigned sampleNumber);
*
* Description:  Removes and deallocates the VU information for a sample
*
* Input:        unsigned sampleNumbe    sample number
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING vuRemove(unsigned sampleNumber);




/****************************************************************************\
*
* Function:     int vuMeter(unsigned sampleNumber, ulong rate,
*                   unsigned position, unsigned volume, unsigned *meter);
*
* Description:  Calculates the VU-meter value (0-64) for the next 1/50th of
*               a second
*
* Input:        unsigned sampleNumber   sample number
*               ulong rate              playing rate
*               unsigned position       sample playing position
*               unsigned volume         playing volume (0-64)
*               unsigned *meter         pointer to VU-meter value
*
* Returns:      MIDAS error code.
*               VU-meter value (0-64) is stored in *meter
*
\****************************************************************************/

int CALLING vuMeter(unsigned sampleNumber, ulong rate, unsigned position,
    unsigned volume, unsigned *meter);


#ifdef __cplusplus
}
#endif



/****************************************************************************\
*       enum vuFunctIDs
*       ---------------
* Description:  ID numbers for real VU-meter functions
\****************************************************************************/

enum vuFunctIDs
{
    ID_vuInit = ID_vu,
    ID_vuClose,
    ID_vuPrepare,
    ID_vuRemove,
    ID_vuMeter
};


#endif


/*
 * $Log: vu.h,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/