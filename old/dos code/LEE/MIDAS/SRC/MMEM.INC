;*      MMEM.INC
;*
;* MIDAS Sound System memory handling routines
;*
;* $Id: mmem.inc,v 1.3 1997/01/16 18:41:59 pekangas Exp $
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
;*
;* Function:    int memAlloc(unsigned len, void **blk);
;*
;* Description: Allocates a block of conventional memory
;*
;* Input:       unsigned len            Memory block length in bytes
;*              void **blk              Pointer to memory block pointer
;*
;* Returns:     MIDAS error code.
;*              Pointer to allocated block stored in *blk, NULL if error.
;*
;\***************************************************************************/

GLOBAL  LANG memAlloc : _funct




;/***************************************************************************\
;*
;* Function:    int memFree(void *blk);
;*
;* Description: Deallocates a memory block allocated with memAlloc()
;*
;* Input:       void *blk               Memory block pointer
;*
;* Returns:     MIDAS error code.
;*
;\***************************************************************************/

GLOBAL  LANG memFree : _funct


;* $Log: mmem.inc,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*