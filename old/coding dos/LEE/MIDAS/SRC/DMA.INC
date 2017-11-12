;*      DMA.H
;*
;* DMA handling routines
;*
;* $Id: dma.inc,v 1.3 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*


;/***************************************************************************\
;*      struct dmaBuffer
;*      ----------------
;* Description: DMA playing buffer
;\***************************************************************************/

STRUC   dmaBuffer

IFDEF __16__
        D_int   bufferSeg               ; DMA buffer segment (offset is zero)
ENDIF
IFDEF __PROTMODE__
        D_int   bufDosSeg               ; DMA buffer DOS segment
        D_int   dpmiSel                 ; DMA buffer DPMI selector
ENDIF

        D_long  startAddr               ; buffer physical start address
        D_int   bufferLen               ; DMA buffer length in bytes
        D_ptr   memBlk                  ; internal, used for unallocating
        D_int   channel                 ; channel on which the buffer is
                                        ; being played or -1
        D_long  bufDataPtr              ; pointer to DMA buffer data
ENDS




;/***************************************************************************\
;*
;* Function:    int dmaAllocBuffer(unsigned size, dmaBuffer *buf);
;*
;* Description: Allocates a DMA buffer (totally inside a 64K physical page)
;*
;* Input:       unsigned size           size of buffer in bytes
;*              dmaBuffer *buf          pointer to DMA buffer information
;*
;* Returns:     MIDAS error code. DMA buffer information is written to *buf.
;*
;\***************************************************************************/

GLOBAL  LANG dmaAllocBuffer : _funct




;/***************************************************************************\
;*
;* Function:    int dmaFreeBuffer(dmaBuffer *buf);
;*
;* Description: Deallocates an allocated DMA buffer
;*
;* Input:       dmaBuffer *buf          pointer to DMA buffer information
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dmaFreeBuffer : _funct




;/***************************************************************************\
;*
;* Function:    int dmaPlayBuffer(dmaBuffer *buf, unsigned channel,
;*                  unsigned autoInit);
;*
;* Description: Plays a DMA buffer
;*
;* Input:       dmaBuffer *buf          pointer to DMA buffer information
;*              unsigned channel        DMA channel number
;*              unsigned autoInit       1 if autoinitializing DMA is used, 0
;*                                      if not
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dmaPlayBuffer : _funct




;/***************************************************************************\
;*
;* Function:    int dmaStop(unsigned channel);
;*
;* Description: Stops DMA playing
;*
;* Input:       unsigned channel        DMA channel number
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dmaStop : _funct




;/***************************************************************************\
;*
;* Function:    int dmaGetPos(dmaBuffer *buf, unsigned *pos);
;*
;* Description: Reads the DMA playing position
;*
;* Input:       dmaBuffer *buf          pointer to DMA buffer information
;*              unsigned *pos           pointer to playing position
;*
;* Returns:     MIDAS error code. DMA playing position from the beginning
;*              of the buffer, in bytes, is written to *pos.
;*
;\***************************************************************************/

GLOBAL  LANG dmaGetPos : _funct


;* $Log: dma.inc,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*