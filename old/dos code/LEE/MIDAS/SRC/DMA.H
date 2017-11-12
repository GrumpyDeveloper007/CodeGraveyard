/*      DMA.H
 *
 * DMA handling routines
 *
 * $Id: dma.h,v 1.2 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/


#ifndef __DMA_H
#define __DMA_H



/****************************************************************************\
*       struct dmaBuffer
*       ----------------
* Description:  DMA playing buffer
\****************************************************************************/

typedef struct
{
#ifdef __16__
    unsigned    bufferSeg;              /* DMA buffer segment (offset is
                                           zero) */
#endif
#ifdef __PROTMODE__
    unsigned    dosSeg;                 /* DMA buffer DOS segment */
    unsigned    dpmiSel;                /* DMA buffer DPMI selector */
#endif
    ulong       startAddr;              /* buffer physical start address */
    unsigned    bufferLen;              /* DMA buffer length in bytes */
    void        *memBlk;                /* internal, used for unallocating */
    int         channel;                /* channel on which the buffer is
                                           being played or -1 */
#if defined(__PROTMODE__) && !defined(__FLATMODE__)
    void far    *dataPtr;               /* pointer to DMA buffer data */
#else
    void        *dataPtr;               /* pointer to DMA buffer data *//*!!*/
#endif
} dmaBuffer;




/****************************************************************************\
*       struct dmaChannel
*       -----------------
* Description:  DMA channel data used by DMA functions.
\****************************************************************************/

typedef struct
{
    unsigned    number;                 /* DMA channel number */
    unsigned    bit;                    /* DMA channel bit for registers */
    unsigned    baseAddr;               /* base address port */
    unsigned    wordCount;              /* word count port */
    unsigned    request;                /* request port */
    unsigned    singleMask;             /* mask port */
    unsigned    mode;                   /* mode port */
    unsigned    clearFF;                /* clear flip-flop port */
    unsigned    page;                   /* page port */
} dmaChannel;



#ifdef __cplusplus
extern "C" {
#endif



/****************************************************************************\
*
* Function:     int dmaAllocBuffer(unsigned size, dmaBuffer *buf);
*
* Description:  Allocates a DMA buffer (totally inside a 64K physical page)
*
* Input:        unsigned size           size of buffer in bytes
*               dmaBuffer *buf          pointer to DMA buffer information
*
* Returns:      MIDAS error code. DMA buffer information is written to *buf.
*
\****************************************************************************/

int CALLING dmaAllocBuffer(unsigned size, dmaBuffer *buf);




/****************************************************************************\
*
* Function:     int dmaFreeBuffer(dmaBuffer *buf);
*
* Description:  Deallocates an allocated DMA buffer
*
* Input:        dmaBuffer *buf          pointer to DMA buffer information
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dmaFreeBuffer(dmaBuffer *buf);




/****************************************************************************\
*
* Function:     int dmaPlayBuffer(dmaBuffer *buf, unsigned channel,
*                   unsigned autoInit);
*
* Description:  Plays a DMA buffer
*
* Input:        dmaBuffer *buf          pointer to DMA buffer information
*               unsigned channel        DMA channel number
*               unsigned autoInit       1 if autoinitializing DMA is used, 0
*                                       if not
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dmaPlayBuffer(dmaBuffer *buf, unsigned channel,
    unsigned autoInit);




/****************************************************************************\
*
* Function:     int dmaStop(unsigned channel);
*
* Description:  Stops DMA playing
*
* Input:        unsigned channel        DMA channel number
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING dmaStop(unsigned channel);




/****************************************************************************\
*
* Function:     int dmaGetPos(dmaBuffer *buf, unsigned *pos);
*
* Description:  Reads the DMA playing position
*
* Input:        dmaBuffer *buf          pointer to DMA buffer information
*               unsigned *pos           pointer to playing position
*
* Returns:      MIDAS error code. DMA playing position from the beginning
*               of the buffer, in bytes, is written to *pos.
*
\****************************************************************************/

int CALLING dmaGetPos(dmaBuffer *buf, unsigned *pos);




#ifdef __cplusplus
}
#endif




/****************************************************************************\
*       enum dmaFunctIDs
*       ----------------
* Description:  ID numbers for DMA handling functions
\****************************************************************************/

enum dmaFunctIDs
{
    ID_dmaAllocBuffer = ID_dma,
    ID_dmaFreeBuffer,
    ID_dmaPlayBuffer,
    ID_dmaStop,
    ID_dmaGetPos
};


#endif


/*
 * $Log: dma.h,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/