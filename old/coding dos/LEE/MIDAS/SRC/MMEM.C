/*      MMEM.C
 *
 * MIDAS Sound System memory handling routines
 *
 * $Id: mmem.c,v 1.4 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <stdlib.h>

#if defined(__WATCOMC__) || defined(__VC32__)
#include <malloc.h>
#else
#ifdef __LINUX__
#include <malloc.h>
#else
#include <alloc.h>
#endif
#endif

#include "lang.h"
#include "errors.h"
#include "mmem.h"

RCSID(const char *mmem_rcsid = "$Id: mmem.c,v 1.4 1997/01/16 18:41:59 pekangas Exp $";)


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

int CALLING memAlloc(unsigned len, void **blk)
{
#ifdef DEBUG
    unsigned    cnt, *b;
#endif

    /* check that block length is not zero: */
    if ( len == 0 )
    {
        ERROR(errInvalidBlock, ID_memAlloc);
        return errInvalidBlock;
    }

#ifdef DEBUG
    len = (len + 3) & 0xFFFFFFFC;
    cnt = len >> 2;
#endif

    /* allocate memory: */
    *blk = malloc(len);

    if ( *blk == NULL )
    {
        /* Memory allocation failed - check if heap is corrupted. If not,
           assume out of memory: */
#ifndef __LINUX__
#if defined(__WATCOMC__) || defined(__VC32__)
        if ( _heapchk() != _HEAPOK )
#else
        if ( heapcheck() != _HEAPOK )
#endif
        {
            ERROR(errHeapCorrupted, ID_memAlloc);
            return errHeapCorrupted;
        }
        else
#endif
        {
            ERROR(errOutOfMemory, ID_memAlloc);
            return errOutOfMemory;
        }
    }

#ifdef DEBUG
    b = (unsigned*) *blk;
    while ( cnt )
    {
        *(b++) = 0xDEADBEEF;
        cnt--;
    }
#endif

    /* memory allocated successfully */
    return OK;
}



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

int CALLING memFree(void *blk)
{
    /* Check that block pointer is not NULL: */
    if ( blk == NULL )
    {
        ERROR(errInvalidBlock, ID_memFree);
        return errInvalidBlock;
    }

    /* deallocate block: */
    free(blk);

    /* deallocation successful */
    return OK;
}


/*
 * $Log: mmem.c,v $
 * Revision 1.4  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.3  1996/07/13 18:21:05  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Fixed for Linux
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/