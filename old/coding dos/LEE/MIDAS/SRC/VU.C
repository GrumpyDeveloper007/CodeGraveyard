/*      VU.H
 *
 * Real VU meter routines
 *
 * $Id: vu.c,v 1.2 1997/01/16 18:41:59 pekangas Exp $
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
#include "sdevice.h"
#include "vu.h"
#include "mutils.h"

RCSID(const char *vu_rcsid = "$Id: vu.c,v 1.2 1997/01/16 18:41:59 pekangas Exp $";)



    /* VU meter calculation block size in bytes: */
#define VUBLOCK 128
    /* Amount to shift right to convert from bytes to blocks:
       (log2 VUBLOCK) */
#define VUBSHIFT 7


sdSample        *vuSamples;             /* VU sample information */




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

int CALLING vuInit(void)
{
    int         error, i;

    /* Allocate memory for sample information structures: */
    if ( (error = memAlloc(MAXSAMPLES * sizeof(sdSample), (void**)
        &vuSamples)) != OK )
        PASSERROR(ID_vuInit)

    /* Point all sample VU information initially to NULL to mark it
       unallocated: */
    for ( i = 0; i < MAXSAMPLES; i++ )
        vuSamples[i].sample = NULL;

    return OK;
}




/****************************************************************************\
*
* Function:     int vuClose(void);
*
* Description:  Uninitializes VU-meters
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING vuClose(void)
{
    int         error, i;

    /* Deallocate all sample VU information that is still allocated: */
    for ( i = 0; i < MAXSAMPLES; i++ )
    {
        if ( vuSamples[i].sample != NULL )
        {
            if ( (error = memFree(vuSamples[i].sample)) != OK )
                PASSERROR(ID_vuClose)
            vuSamples[i].sample = NULL;
        }
    }

    /* Deallocate sample information structures: */
    if ( (error = memFree(vuSamples)) != OK )
        PASSERROR(ID_vuClose);

    return OK;
}




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

int CALLING vuPrepare(sdSample *sample, unsigned sampleNumber)
{
    sdSample    *vuSample = &vuSamples[sampleNumber];
    int         error;
    uchar       *src, *dest;
    int         min, max;
    unsigned    i, bleft;

    /* Copy sample information: */
    mMemCopy(vuSample, sample, sizeof(sdSample));

    /* If there is no sample data or the sample type is unknown, mark there
       is no VU-meter information for this sample and exit: */
    if ( (vuSample->sampleLength == 0) || (vuSample->sampleType != smp8bit)
        || (vuSample->samplePos != sdSmpConv) )
    {
        vuSample->sample = NULL;
        return OK;
    }

    /* FIXME - only 8-bit samples supported! */

    /* Allocate memory for VU information: */
    if ( (error = memAlloc((vuSample->sampleLength + (VUBLOCK-1)) >> VUBSHIFT,
        (void**) &vuSample->sample)) != OK )
        PASSERROR(ID_vuPrepare)

    /* Point dest to destination buffer and src to sample data: */
    dest = vuSample->sample;
    src = sample->sample;

    bleft = sample->sampleLength;

    /* Process all VU information blocks: */
    while ( bleft )
    {
        /* Process VUBLOCK bytes maximum: */
        if ( bleft > VUBLOCK )
            i = VUBLOCK;
        else
            i = bleft;

        /* Decrease bytes left: */
        bleft -= i;

        /* Reset minimum and maximum values found: */
        min = 255; max = 0;

        /* Go through all sample bytes belonging to this block to find the
           minimum and maximum values: */
        while ( i )
        {
            if ( *src < min )
                min = *src;
            if ( *src > max )
                max = *src;
            src++;
            i--;
        }

        /* Calculate VU-meter value for this block ((max-min)/4, rounded up),
           and store it in *dest: */
        *(dest++) = (uchar) ((max - min + 2) / 4);
    }

    return OK;
}




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

int CALLING vuRemove(unsigned sampleNumber)
{
    int         error;

    /* Deallocate VU information for this sample if allocated: */
    if ( vuSamples[sampleNumber].sample != NULL )
    {
        if ( (error = memFree(vuSamples[sampleNumber].sample)) != OK )
            PASSERROR(ID_vuRemove)
    }

    /* Mark VU information unallocated: */
    vuSamples[sampleNumber].sample = NULL;

    return OK;
}




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
    unsigned volume, unsigned *meter)
{
    sdSample    *sample = &vuSamples[sampleNumber];
    unsigned    clippos;

    /* Make sure that there is VU information for this sample: */
    if ( (sample->sample == NULL) || (sampleNumber >= MAXSAMPLES) )
    {
        *meter = 0;
        return OK;
    }

    /* Make sure the position is inside the sample: */
    if ( position >= sample->sampleLength )
        clippos = sample->sampleLength - 1;
    else
        clippos = position;

    /* Just take the VU meter value for current block and scale it with
       volume (FIXME?) */
    *meter = ((unsigned) sample->sample[clippos >> VUBSHIFT]) * volume / 64;

    return OK;
}


/*
 * $Log: vu.c,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/