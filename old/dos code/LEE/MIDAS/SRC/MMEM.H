/*      MMEM.H
 *
 * MIDAS Sound System memory handling routines
 *
 * $Id: mmem.h,v 1.2 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/


#ifndef __MEM_H
#define __MEM_H


#ifdef __cplusplus
extern "C" {
#endif



/****************************************************************************\
*
* Function:     int memAlloc(unsigned len, void **blk);
*
* Description:  Allocates a block of conventional memory
*
* Input:        unsigned len            Memory block length in bytes
*               void **blk              Pointer to memory block pointer
*
* Returns:      MIDAS error code.
*               Pointer to allocated block stored in *blk, NULL if error.
*
\****************************************************************************/

int CALLING memAlloc(unsigned len, void **blk);



/****************************************************************************\
*
* Function:     int memFree(void *blk);
*
* Description:  Deallocates a memory block allocated with memAlloc()
*
* Input:        void *blk               Memory block pointer
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING memFree(void *blk);




/****************************************************************************\
*       enum memFunctIDs
*       ----------------
* Description:  ID numbers for memory handling functions
\****************************************************************************/

enum memFunctIDs
{
    ID_memAlloc = ID_mem,
    ID_memFree
};




#ifdef __cplusplus
}
#endif

#endif


/*
 * $Log: mmem.h,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/