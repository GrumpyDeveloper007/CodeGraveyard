/*      DMA.C
 *
 * DMA handling routines
 *
 * $Id: dma.c,v 1.3 1997/01/16 18:41:59 pekangas Exp $
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
#include "mtypes.h"
#include "errors.h"
#include "mmem.h"
#include "dma.h"

#ifdef __DPMI__
#include "dpmi.h"
#endif

RCSID(const char *dma_rcsid = "$Id: dma.c,v 1.3 1997/01/16 18:41:59 pekangas Exp $";)



/****************************************************************************\
*       DMA channel data:
\****************************************************************************/

dmaChannel      dmaChannels[8] = {
    { 0, 1, 0x00, 0x01, 0x09, 0x0A, 0x0B, 0x0C, 0x87 },
    { 1, 2, 0x02, 0x03, 0x09, 0x0A, 0x0B, 0x0C, 0x83 },
    { 2, 4, 0x04, 0x05, 0x09, 0x0A, 0x0B, 0x0C, 0x81 },
    { 3, 8, 0x06, 0x07, 0x09, 0x0A, 0x0B, 0x0C, 0x82 },
    { 4, 1, 0xC0, 0xC2, 0xD2, 0xD4, 0xD6, 0xD8, 0x8F },
    { 5, 2, 0xC4, 0xC6, 0xD2, 0xD4, 0xD6, 0xD8, 0x8B },
    { 6, 4, 0xC8, 0xCA, 0xD2, 0xD4, 0xD6, 0xD8, 0x89 },
    { 7, 8, 0xCC, 0xCE, 0xD2, 0xD4, 0xD6, 0xD8, 0x8A } };



/* *!!* */
#ifdef __WATCOMC__

#ifdef __16__

void outp(unsigned port, unsigned value);
#pragma aux outp = \
    "out    dx,al" \
    parm [dx] [ax] \
    modify exact [];

unsigned inp(unsigned port);
#pragma aux inp = \
    "xor    ax,ax" \
    "in     al,dx" \
    parm [dx] \
    value [ax] \
    modify exact [ax];

#else

void outp(unsigned port, unsigned value);
#pragma aux outp = \
    "out    dx,al" \
    parm [edx] [eax] \
    modify exact [];

unsigned inp(unsigned port);
#pragma aux inp = \
    "xor    eax,eax" \
    "in     al,dx" \
    parm [edx] \
    value [eax] \
    modify exact [eax];

#endif

#endif

#ifdef __BORLANDC__

void outp(unsigned port, unsigned value)
{
asm     mov     dx,word ptr port
asm     mov     al,byte ptr value
asm     out     dx,al
}

unsigned inp(unsigned port)
{
asm     xor     ax,ax
asm     in      al,dx
    return _AX;
}

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

int CALLING dmaAllocBuffer(unsigned size, dmaBuffer *buf)
{
    int         error;
#ifdef __REALMODE__
    unsigned    bseg;
#endif
#ifdef __DPMI__
    static ulong addr;
#endif

    /* Check that buffer size is below 30000 bytes: */
    if ( size > 30000 )
    {
        ERROR(errInvalidArguments, ID_dmaAllocBuffer);
        return errInvalidArguments;
    }

#ifdef __REALMODE__
    /* Allocate memory for 2*size bytes, to ensure the block always fits
       in a 64k physical page: */
    if ( (error = memAlloc(2 * size + 16, &buf->memBlk)) != OK )
        PASSERROR (ID_dmaAllocBuffer)

    /* bseg = allocated memory block segment: */
    bseg = *((unsigned*) ((uchar*)&buf->memBlk + 2)) +
        (((*(unsigned*) &buf->memBlk) + 15) >> 4);
    /* /me really hates 16-bit compilers */

    /* Move buffer to the beginning of the next 64k page if it does not fit
       into current one: */
    if ( (bseg & 0x0FFF) >= (0x0FFF - (size + 15) / 16) )
        bseg = (bseg & 0xF000) + 0x1000;

    buf->bufferSeg = bseg;                  /* buffer segment */
    buf->startAddr = ((ulong) bseg) << 4;   /* buffer phys. start address */

    /* Create pointer to buffer data: */
    buf->dataPtr = (void*) (((ulong) bseg) << 16);
#else

    /* Protected mode under DPMI: */

    /* This code assumes in the first megabyte the logical addresses
       correspond to the physical ones (mapped directly). */

    /* Allocate DOS memory for DMA buffer: */
    if ( (error = dpmiAllocDOSMem((2 * size + 32 + 1024) / 16, &buf->dosSeg,
        &buf->dpmiSel)) != OK )
        PASSERROR(ID_dmaAllocBuffer);

    /* Get the allocated memory block linear start address: */
    if ( (error = dpmiGetSegmentBase(buf->dpmiSel, &addr)) != OK )
        PASSERROR(ID_dmaAllocBuffer);

    /* Align to paragraph boundary: */
//    addr = (addr + 15) & 0xFFFFFFF0;

    /* Align to 512-byte boundary: */
    addr = (addr + 511) & (~511);

    /* Move the buffer in to the beginning of the next 64kb page if it does
       not fit into the current one: */
    if ( (addr & 0xFFFF) >= (0x10000 - size) )
        addr = (addr & 0xFFFF0000) + 0x10000;

    buf->startAddr = addr;

    /* Lock the DMA buffer memory area: */
    if ( (error = dpmiLockMemory(addr, size)) != OK )
        PASSERROR(ID_dmaAllocBuffer);

#ifdef __FLATMODE__
    /* Build pointer to buffer data: */
    buf->dataPtr = (void*) buf->startAddr;

#else
    /* Not fully flat memory - allocate descriptor for DMA buffer memory: */
    if ( (error = dpmiAllocDescriptor(&buf->bufferSeg)) != OK )
        PASSERROR(ID_dmaAllocBuffer)

    /* Set new segment base and limit to the DMA buffer: */
    if ( (error = dpmiSetSegmentBase(buf->bufferSeg, addr)) != OK )
        PASSERROR(ID_dmaAllocBuffer)
    if ( (error = dpmiSetSegmentLimit(buf->bufferSeg, size)) != OK )
        PASSERROR(ID_dmaAllocBuffer)

#ifdef __16__
    /* Build pointer to buffer data: */
    buf->dataPtr = (void*) (((ulong) buf->bufferSeg) << 16);
#else
    /* Build pointer to buffer data: */
    *((ushort*)(((ulong) &buf->dataPtr) + 4) = buf->bufferSeg;  /* segment */
    *((ulong*)(((ulong) &buf->dataPtr)) = 0;  /* offset */
#endif

#endif
#endif

    buf->bufferLen = size;
    buf->channel = -1;

    return OK;
}




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

int CALLING dmaFreeBuffer(dmaBuffer *buf)
{
    int         error;
#ifdef __REALMODE__
    /* Deallocate buffer memory block: */
    if ( (error = memFree(buf->memBlk)) != OK )
        PASSERROR(ID_dmaFreeBuffer)
#else
    /* Unlock the DMA buffer memory area: */
    if ( (error = dpmiLockMemory(buf->startAddr, buf->bufferLen)) != OK )
        PASSERROR(ID_dmaFreeBuffer);

    /* Deallocate DOS memory: */
    if ( (error = dpmiFreeDOSMem(buf->dpmiSel)) != OK )
        PASSERROR(ID_dmaFreeBuffer)

#ifndef __FLATMODE__
    /* Deallocate DPMI selector: */
    if ( (error = dpmiFreeSelector(buf->bufferSeg)) != OK )
        PASSERROR(ID_dmaFreeBuffer)
#endif
#endif

    return OK;
}




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

int CALLING dmaPlayBuffer(dmaBuffer *buf, unsigned channel, unsigned autoInit)
{
    dmaChannel  *chan;

    /* Point chan to correct DMA channel information structure: */
    chan = &dmaChannels[channel];

    buf->channel = channel;

    /* Reset DMA request: */
    outp(chan->request, channel & 3);

    /* Mask out the channel: */
    outp(chan->singleMask, (channel & 3) | 4);

    if ( autoInit )
    {
        /* Read mode, single mode, autoinitialization: */
        outp(chan->mode, (channel & 3) | 8 | 16 | 64);
    }
    else
    {
        /* Read mode, single mode, no autoinitialization: */
        outp(chan->mode, (channel & 3) | 8 | 64);
    }

    /* Set DMA page: */
    outp(chan->page, (buf->startAddr >> 16L));

    /* Clear byte pointer flip-flop so that next write to a 16-bit register
       will go to the low byte: */
    outp(chan->clearFF, 0);

    /* Set DMA start address and buffer length: */
    if ( channel < 4 )
    {
        /* 8-bit DMA channel - just set the address: */
        outp(chan->baseAddr, (buf->startAddr & 0xFF));
        outp(chan->baseAddr, (buf->startAddr & 0xFFFF) >> 8);

        /* Set word count: */
        outp(chan->wordCount, (buf->bufferLen-1) & 0xFF);
        outp(chan->wordCount, ((buf->bufferLen-1) & 0xFFFF) >> 8);
    }
    else
    {
        /* 16-bit DMA channel - divide address by 2 (starting word) */
        outp(chan->baseAddr, (buf->startAddr >> 1) & 0xFF);
        outp(chan->baseAddr, ((buf->startAddr >> 1) & 0xFFFF) >> 8);

        /* Set word count: */
        outp(chan->wordCount, ((buf->bufferLen >> 1)-1) & 0xFF);
        outp(chan->wordCount, (((buf->bufferLen >> 1)-1) & 0xFFFF) >> 8);
    }

    /* Enable channel: */
    outp(chan->singleMask, channel & 3);

    return OK;
}




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

int CALLING dmaStop(unsigned channel)
{
    dmaChannel  *chan;

    /* Point chan to correct DMA channel info structure: */
    chan = &dmaChannels[channel];

    /* Mask out channel: */
    outp(chan->singleMask, (channel & 3) | 4);

    /* Clear byte pointer flip-flop: */
    outp(chan->clearFF, 0);

    return OK;
}




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

int CALLING dmaGetPos(dmaBuffer *buf, unsigned *pos)
{
    dmaChannel  *chan;
    int         count1, count2;

    /* Point chan to correct DMA channel info structure: */
    chan = &dmaChannels[buf->channel];

    /* Clear byte pointer flip-flop: */
    outp(chan->clearFF, 0);

    /* Read DMA word count two times until the difference between the
       counts read is below or equal to 4 and the value is legal:
       (make sure we won't be disturbed by Expanded Memory Managers or
       something) */
    do
    {
        count1 = inp(chan->wordCount);
        count1 = count1 + ((inp(chan->wordCount)) << 8);

        /* Convert count1 to number of bytes if the channel is 16-bit: */
        if ( buf->channel > 3 )
            count1 = count1 << 1;

        count2 = inp(chan->wordCount);
        count2 = count2 + ((inp(chan->wordCount)) << 8);

        /* Convert count2 to number of bytes if the channel is 16-bit: */
        if ( buf->channel > 3 )
            count2 = count2 << 1;
    } while ( ((count1 - count2) > 4) || ((count1 - count2) < (-4)) ||
        (count1 >= buf->bufferLen) );

    /* Write position to *pos: */
    *pos = buf->bufferLen - count1;

    return OK;
}


/*
 * $Log: dma.c,v $
 * Revision 1.3  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.2  1996/10/13 17:06:54  pekangas
 * Now properly masks out channel in dmaStop()
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/