/*      XM.H
 *
 * Fasttracker 2 eXtended Module format structures
 *
 * $Id: xm.h,v 1.4 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/


#ifndef __XM_H
#define __XM_H


/****************************************************************************\
*       enum xmFlags
*       ------------
* Description:  Flag bits for different flag bytes and words in the XM
*               file
\****************************************************************************/

enum xmFlags
{
    xmLinearFreq = 1,                   /* xmHeader: linear frequency table
                                           used */
    xmEnvelopeOn = 1,                   /* xmInstSampleHeader: envelope on */
    xmEnvelopeSustain = 2,              /* envelope sustain on */
    xmEnvelopeLoop = 4,                 /* envelope loop on */

    xmSample16bit = 16                  /* xmSampleHeader: 16-bit sample */
};




/****************************************************************************\
*       struct xmHeader
*       ---------------
* Description:  Extended Module file header
\****************************************************************************/

typedef struct
{
    char        signature[17];          /* "Extended Module: " */
    char        name[20];               /* module name */
    uchar       num1A;                  /* 0x1A */
    char        trackerName[20];        /* tracker name */
    U16         version;                /* version number, major-minor */
    U32         hdrSize;                /* header size */
    U16         songLength;             /* song length */
    U16         restart;                /* restart position */
    U16         numChans;               /* number of channels */
    U16         numPatts;               /* number of patterns */
    U16         numInsts;               /* number of instruments */
    U16         flags;                  /* header flags, see enum
                                           xmFlags */
    U16         speed;                  /* initial speed */
    U16         tempo;                  /* initial tempo */
    uchar       orders[256];            /* pattern order table */
} xmHeader;




/****************************************************************************\
*       struct xmPattern
*       ----------------
* Description:  Fasttracker 2 Extended Module pattern
\****************************************************************************/

typedef struct
{
    U32         headerLength;           /* pattern header length */
    U8          packType;               /* packing type (now 0) */
    U16         numRows;                /* number of rows */
    U16         pattDataSize;           /* pattern data size */
    uchar       data[EMPTYARRAY];       /* packed pattern data */
} xmPattern;




/****************************************************************************\
*       struct xmInstHeader
*       -------------------
* Description:  Fasttracker 2 Extended Module instrument file header
\****************************************************************************/

typedef struct
{
    U32         instSize;               /* instrument size */
    char        instName[22];           /* instrument filename */
    U8          instType;               /* instrument type (now 0) */
    U16         numSamples;             /* number of samples in instrument */
} xmInstHeader;



/****************************************************************************\
*       struct xmInstSampleHeader
*       -------------------------
* Description:  Fasttracker 2 Extended Module instrument sample header
*               (follows instrument header if the instrument has samples.
*               Only once per instrument!)
\****************************************************************************/

typedef struct
{
    U32         headerSize;             /* sample header size */
    U8          noteSmpNums[96];        /* sample numbers for notes */
    U8          volEnvelope[48];        /* volume envelope points */
    U8          panEnvelope[48];        /* panning envelope points */
    U8          numVolPoints;           /* number of volume envelope points */
    U8          numPanPoints;           /* number of panning env. points */
    U8          volSustain;             /* volume sustain point */
    U8          volLoopStart;           /* volume loop start point */
    U8          volLoopEnd;             /* volume loop end point */
    U8          panSustain;             /* panning sustain point */
    U8          panLoopStart;           /* panning loop start point */
    U8          panLoopEnd;             /* panning loop end point */
    U8          volEnvFlags;            /* volume envelope flags */
    U8          panEnvFlags;            /* panning envelope flags */

    U8          vibType;                /* vibrato type */
    U8          vibSweep;               /* vibrato sweep */
    U8          vibDepth;               /* vibrato depth */
    U8          vibRate;                /* vibrato rate */
    U16         volFadeout;             /* volume fadeout */
    U16         reserved;
} xmInstSampleHeader;






/****************************************************************************\
*       struct xmSampleHeader
*       ---------------------
* Description:  Fasttracker 2 Extended Module sample file header
\****************************************************************************/

typedef struct
{
    U32         smpLength;              /* sample length */
    U32         loopStart;              /* loop start */
    U32         loopLength;             /* loop length */
    U8          volume;                 /* volume */
    S8          finetune;               /* finetune */
    U8          flags;                  /* sample flags, bits 0-1 are loop
                                           type: 0 = no loop, 1 = unidir,
                                           2 = bidir loop */
    U8          panning;                /* sample panning */
    S8          relNote;                /* relative note number */
    U8          reserved;
    char        smpName[22];            /* sample name */
    /* Sample data follows, in delta format */
} xmSampleHeader;



#endif


/*
 * $Log: xm.h,v $
 * Revision 1.4  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.3  1996/05/24 17:02:08  pekangas
 * Fixed to work with Watcom C again - using EMPTYARRAY
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Fixed for Linux
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/