/*      loadxm.c
 *
 * Generic Module Player Fasttracker 2 Module loader
 *
 * $Id: loadxm.c,v 1.12 1997/01/25 15:23:16 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

/* Note! Loading an XM module requires INSANE amounts of memory for buffers
   - 90kb for pattern buffers (for 32 channels) plus the size of the largest
   sample for samples. */

#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "mglobals.h"
#include "mmem.h"
#include "file.h"
#include "sdevice.h"
#include "gmplayer.h"
#include "xm.h"
#ifndef NOEMS
#include "ems.h"
#endif
#include "mutils.h"

#ifdef __WC32__
#include <malloc.h>
#endif

#include <stdio.h>

RCSID(const char *loadxm_rcsid = "$Id: loadxm.c,v 1.12 1997/01/25 15:23:16 pekangas Exp $";)

/*#define CHECK_THE_HEAP*/

extern ulong *__nheapbeg;

/*#define DEBUGMESSAGES*/


/****************************************************************************\
*
* Function:     TestHeap(void)
*
* Description:  Test if the heap is corrupted. Watcom C ONLY! Implemented here
*               because the Watcom _heapchk() often reports the heap is OK
*               even though it isn't.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

#if defined(CHECK_THE_HEAP) && defined(__WC32__)
    /* Maximum valid block in heap: */
#define MAXBLK (2048*1024)

static int TestHeap(void)
{
    static struct _heapinfo hinfo;
    int         hstatus;
    unsigned    len;

    hinfo._pentry = NULL;

    while ( 1 )
    {
        hstatus = _heapwalk(&hinfo);
        if ( hstatus != _HEAPOK )
            break;
        len = hinfo._size;
        if ( (len == 0) || (len > MAXBLK) || (len & 3) )
            return errHeapCorrupted;
    }

    if ( (hstatus == _HEAPEND) || (hstatus == _HEAPEMPTY) )
        return OK;
    return errHeapCorrupted;
}
#define CHECKHEAP \
    { \
        if ( TestHeap() != OK ) \
        { \
            puts("HEAP CORRUPTED!"); \
            ERROR(errHeapCorrupted, ID_gmpLoadXM); \
            LoadError(); \
            return errHeapCorrupted; \
        } \
    }

#else
#define CHECKHEAP
#endif

/* Pass error code in variable "error" on, used in gmpLoadXM(). */
#define PASSERR() { LoadError(); PASSERROR(ID_gmpLoadXM) }


/* Conversion table from FT2 command number to GMP ones: */
static uchar ft2Commands[36] =
{
    gmpcArpeggio,               /* 0 - Arpeggio */
    gmpcSlideUp,                /* 1 - Portamento up */
    gmpcSlideDown,              /* 2 - Portamento down */
    gmpcTonePortamento,         /* 3 - Tone portamento */
    gmpcVibrato,                /* 4 - Vibrato */
    gmpcTPortVSlide,            /* 5 - Tone portamento + volume slide */
    gmpcVibVSlide,              /* 6 - Vibrato + volume slide */
    gmpcTremolo,                /* 7 - Tremolo */
    gmpcSetPanning,             /* 8 - Set panning (extension) */
    gmpcSampleOffset,           /* 9 - Sample offset */
    gmpcVolumeSlide,            /* A - Volume slide */
    gmpcPositionJump,           /* B - Position jump */
    gmpcSetVolume,              /* C - Set volume */
    gmpcPatternBreak,           /* D - Pattern break */
    gmpcNone,                   /* E - E-commands (see below) */
    gmpcSetSpeed,               /* F - Set speed/tempo */
    gmpcSetMVolume,             /* G - Set master volume */
    gmpcMVolSlide,              /* H - Master volume slide */
    gmpcNone,                   /* I - Unused */
    gmpcNone,                   /* J - Unused */
    gmpcNone,                   /* K - Unused */
    gmpcNone,                   /* L - Set envelope position */
    gmpcNone,                   /* M - Unused */
    gmpcNone,                   /* N - Unused */
    gmpcNone,                   /* O - Unused */
    gmpcPanSlide,               /* P - Panning slide */
    gmpcNone,                   /* Q - Unused */
    gmpcS3MRetrig,              /* R - ST3 multi retrig */
    gmpcNone,                   /* S - Unused */
    gmpcNone,                   /* T - Tremor */
    gmpcNone,                   /* U - Unused */
    gmpcNone,                   /* V - Unused */
    gmpcMusicSync,              /* W - Music Synchronization (extension) */
    gmpcNone,                   /* Extra fine slides - handled separately */
    gmpcNone,                   /* Y - Unused */
    gmpcNone,                   /* Z - Unused */
};

/* Conversion table from FT2 E-command numbers to GMP commands: */
static uchar ft2ECommands[16] =
{
    gmpcNone,                   /* E0 - Toggle filter */
    gmpcFineSlideUp,            /* E1 - Fine portamento up */
    gmpcFineSlideDown,          /* E2 - Fine portamento down */
    gmpcNone,                   /* E3 - Set glissando control */
    gmpcNone,                   /* E4 - Set vibrato type */
    gmpcNone,                   /* E5 - Set finetune */
    gmpcPatternLoop,            /* E6 - Pattern loop */
    gmpcNone,                   /* E7 - Set tremolo type */
    gmpcSetPanning16,           /* E8 - Set panning (extension) */
    gmpcPTRetrig,               /* E9 - Retrig note */
    gmpcFineVolSlideUp,         /* EA - Fine volume slide up */
    gmpcFineVolSlideDown,       /* EB - Fine volume slide down */
    gmpcNoteCut,                /* EC - Note cut */
    gmpcNoteDelay,              /* ED - Note delay */
    gmpcPatternDelay,           /* EE - Pattern delay */
    gmpcNone                    /* EF - Invert loop */
};




/****************************************************************************\
*       Module loader buffers and file handle. These variables are static
*       instead of local so that a separate deallocation can be used which
*       will be called before exiting in error situations
\****************************************************************************/
static fileHandle f;                    /* file handle for module file */
static int      fileOpened;             /* 1 if module file has been opened */
static gmpModule *module;               /* pointer to GMP module structure */
static xmHeader *header;                /* pointer to FT2 module header */
static uchar    *instUsed;              /* instrument used flags */
static xmPattern *xmPatt;               /* pointer to XM pattern data */
static gmpPattern *convPatt;            /* pointer to converted pattern data*/
static uchar    *smpBuf;                /* sample loading buffer */
static unsigned numChans;               /* number of channels in module */
static xmInstHeader *xmInst;            /* XM instrument header */
static xmInstSampleHeader *xmInstSmp;   /* XM instrument sample header */
static xmSampleHeader *xmSample;        /* XM sample header */
static int      maxInstUsed;            /* maximum used instrument number */





/****************************************************************************\
*
* Function:     int ConvertPattern(xmPattern *srcPatt, gmpPattern *destPatt,
*                   unsigned *convLen);
*
* Description:  Converts a pattern from FT2 to GMP internal format.
*               Also updates instUsed flags.
*
* Input:        xmPattern *srcPatt      pointer to pattern in FT2 format
*               gmpPattern *destPatt    pointer to destination GMP pattern
*               unsigned *convLen       pointer to converted pattern length
*
* Returns:      MIDAS error code. Converted pattern length (in bytes,
*               including header) is written to *convLen.
*
\****************************************************************************/

static int ConvertPattern(xmPattern *srcPatt, gmpPattern *destPatt,
    unsigned *convLen)
{
    uchar       *src = &srcPatt->data[0];
    uchar       *dest = &destPatt->data[0];
    unsigned    row, chan;
    unsigned    len;
    uchar       note, inst, command, infobyte, vol, compInfo;
    uchar       xmComp;
    uchar       gmpCommand;

/*
   ***********************
   *   Pattern format:	 *
   ***********************

   The patterns are stored as ordinary MOD patterns, except that each
   note is stored as 5 bytes:

      ?      1	 (byte) Note (0-71, 0 = C-0)
     +1      1	 (byte) Instrument (0-128)
     +2      1	 (byte) Volume column byte (see below)
     +3      1	 (byte) Effect type
     +4      1	 (byte) Effect parameter

   A simle packing scheme is also adopted, so that the patterns not become
   TOO large: Since the MSB in the note value is never used, if is used for
   the compression. If the bit is set, then the other bits are interpreted
   as follows:

      bit 0 set: Note follows
	  1 set: Instrument follows
	  2 set: Volume column byte follows
	  3 set: Effect follows
	  4 set: Guess what!
*/

    if ( srcPatt->numRows > 256 || srcPatt->numRows == 0 )
        return errInvalidModule;

    /* Check if the pattern is empty: */
    if ( srcPatt->pattDataSize == 0 )
    {
        /* Write row end marker for each row: */
        for ( row = 0; row < srcPatt->numRows; row++ )
            *(dest++) = 0;

        /* Write number of rows to pattern header: */
        destPatt->rows = srcPatt->numRows;

        /* Write converted pattern length to header and return it in
           *convLen: */
        *convLen = destPatt->length = srcPatt->numRows + sizeof(gmpPattern);
        return OK;
    }

    for ( row = 0; row < srcPatt->numRows; row++ )
    {
        for ( chan = 0; chan < numChans; chan++ )
        {
            /* No data for this channel yet: */
            compInfo = 0;
            note = 0xFF;
            inst = 0xFF;
            command = 0;
            infobyte = 0;
            vol = 0;
            gmpCommand = 0;

            /* Get note number/compression info from pattern data: */
            xmComp = *src;

            /* If the most significant bit in the read byte is 1 the byte
               contains compression info bits, otherwise it is the note
               number and all fields are present: */
            if ( xmComp & 0x80 )
            {
                /* The byte is compression info - continue from next byte: */
                src++;
                xmComp &= 0x7F;
            }
            else
            {
                /* The byte is note number - mark that all fields are present
                   and use current byte as the note number: */
                xmComp = 0x7F;
            }

            /* Check if there is a new note: */
            if ( xmComp & 1 )
            {
                /* Check that the note is not key off and convert it to GMP
                   internal format: */
                if ( *src > 96 )
                    note = 0xFE;
                else
                    note = ((((*src)-1) / 12) << 4) | (((*src)-1) % 12);

                src++;

                /* Mark that there is a new note: */
                compInfo |= 32;
            }

            /* Check if there is a new instrument: */
            if ( xmComp & 2 )
            {
                /* Get the instrument number: */
                inst = (*(src++)) - 1;

                /* [Petteri] 06 Dec 1997 - Why was this here?
                if ( note == 0xFE )
                    inst = 0xFF;
                */

                if ( inst != 0xFF )
                {
                    /* Check if the instrument number if above maximum instrument
                       number used: */
                    if ( inst > maxInstUsed )
                        maxInstUsed = inst;

                    /* Mark instrument used: */
                    instUsed[inst] = 1;

                    /* Mark that there is a new instrument: */
                    compInfo |= 32;
                }
            }

            /* Check if there is a volume column byte: */
            if ( xmComp & 4 )
            {
                /* Get the volume column byte: */
                vol = *(src++);

                /* Ignore the volume column byte if it is zero: */
                if ( vol != 0 )
                {
                    /* Convert the byte to volume number if it is a set
                       volume command: */
                    if ( (vol >= 0x10) && (vol <= 0x50) )
                        vol -= 0x10;

                    /* Mark that there is a volume column byte: */
                    compInfo |= 64;
                }
            }

            /* Check if there is a command: */
            if ( xmComp & 8 )
            {
                /* Get the command number: */
                command = *(src++);
            }

            /* Check if there is an infobyte: */
            if ( xmComp & 16 )
            {
                /* Get the infobyte: */
                infobyte = *(src++);
            }

            /* If there is a command or an infobyte we need to write the
               command to the destination pattern: */
            if ( (command != 0) || (infobyte != 0) )
            {
                /* Convert command to GMP command number: */
                gmpCommand = ft2Commands[command];

                /* Special commands */
                switch ( command )
                {
                    case 0x0E:
                        /* Command E - check actual command number: */
                        gmpCommand = ft2ECommands[infobyte >> 4];
                        infobyte = infobyte & 0x0F;
                        break;

                    case 0x0F:
                        /* Fasttracker 2 command 0Fh - set speed or set tempo.
                           If infobyte >= 32, the BPM tempo is changed: */
                        if ( infobyte >= 32 )
                            gmpCommand = gmpcSetTempo;
                        else
                            gmpCommand = gmpcSetSpeed;
                        break;

                    case ('K' - 'F' + 0x0F):
                        /* FT2 command K - release note. Convert to release
                           note note number: */
                        note = 254;
                        compInfo |= 32;
                        gmpCommand = gmpcNone;
                        break;

                    case ('X' - 'F' + 0x0F):
                        /* FT2 command X - eXtra fine slides.  Convert
                            to separate commands: */
                        gmpCommand = gmpcNone;
                        if ( (infobyte & 0xF0) == 0x10 )
                            gmpCommand = gmpcExtraFineSlideUp;
                        if ( (infobyte & 0xF0) == 0x20 )
                            gmpCommand = gmpcExtraFineSlideDown;

                        infobyte = infobyte & 0x0F;
                        break;
                }

                /* Mark that there is a command: */
                if ( gmpCommand != gmpcNone )
                    compInfo |= 128;
            }

            /* If the compression information is nonzero, there is some
               data for this channel: */
            if ( compInfo != 0 )
            {
                /* Set channel number to lower 5 bits of the compression info
                   and write it to destination: */
                compInfo |= chan;
                *(dest++) = compInfo;

                /* Check if there a note+instrument pair: */
                if ( compInfo & 32 )
                {
                    /* Write note and instrument numbers: */
                    *(dest++) = note;
                    *(dest++) = inst;
                }

                /* Check if there is a volume column byte: */
                if ( compInfo & 64 )
                {
                    /* Write the volume column byte: */
                    *(dest++) = vol;
                }

                /* Check if there is a command: */
                if ( compInfo & 128 )
                {
                    /* Write command and command infobyte: */
                    *(dest++) = gmpCommand;
                    *(dest++) = infobyte;
                }
            }
        }

        /* Write row end marker: */
        *(dest++) = 0;
    }

    /* Write number of rows to pattern header: */
    destPatt->rows = srcPatt->numRows;

    /* Calculate converted pattern length: */
    len = (unsigned) (dest  - ((uchar*) destPatt));

    /* Write converted pattern length to header and return it in *convLen: */
    destPatt->length = len;
    *convLen = len;

    return OK;
}




/****************************************************************************\
*
* Function:     void LoadError(void)
*
* Description:  Stops loading the module, deallocates all buffers and closes
*               the file.
*
\****************************************************************************/

#define condFree(x) { if ( x != NULL ) if ( memFree(x) != OK) return; }

static void LoadError(void)
{
    /* Close file if opened. Do not process errors. */
    if ( fileOpened )
        if ( fileClose(f) != OK )
            return;

    /* Attempt to deallocate module if allocated. Do not process errors. */
    if ( module != NULL )
        if ( gmpFreeModule(module) != OK )
            return;

    /* Deallocate structures if allocated: */
    condFree(header)
    condFree(instUsed)
    condFree(smpBuf)
    condFree(xmInst)
    condFree(xmInstSmp)
    condFree(xmSample)
}




/****************************************************************************\
*
* Function:     int gmpLoadXM(char *fileName, int addSD, mpModule **module)
*
* Description:  Loads a Fasttracker 2 module to memory in Generic Module
*               Player module format
*
* Input:        char *fileName          module file name
*               int addSD               1 if module samples should be added to
*                                       the current Sound Device, 0 if not
*               int (*SampleCallback)(...)  pointer to callback function that
*                                       will be called after sample has been
*                                       added to Sound Device, but before
*                                       sample data is deallocated
*               mpModule **module       pointer to GMP module pointer
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING gmpLoadXM(char *fileName, int addSD, int
    (CALLING *SampleCallback)(sdSample *sdsmp, gmpSample *gmpsmp),
    gmpModule **_module)
{
    int             error;              /* MIDAS error code */
    static gmpInstrument *inst;
    unsigned        i, s;
    unsigned        n;
    unsigned        numSamplesUsed;
    ulong           maxSample;
    static unsigned convPattLen;
    static long     filePos;
    static gmpSample *sample;
    static sdSample sdSmp;
    ulong           smpTotal;
    long            smpStart;
    long            skip;
    gmpEnvelope     *env;
    uchar           *smpData;
    int             d;
    unsigned        numInsts;
    unsigned        maxPatt;
#ifndef NOEMS
    uchar           *patt;
#endif


    /* point buffers to NULL and set fileOpened to 0 so that LoadError()
       can be called at any point: */
    fileOpened = 0;
    module = NULL;
    header = NULL;
    instUsed = NULL;
    xmPatt = NULL;
    convPatt = NULL;
    smpBuf = NULL;
    xmInst = NULL;
    xmInstSmp = NULL;
    xmSample = NULL;

#ifdef DEBUGMESSAGES
    puts("Loading header");
#endif

    /* Allocate memory for XM module header: */
    if ( (error = memAlloc(sizeof(xmHeader), (void**) &header)) != OK )
        PASSERR()

    /* Open module file: */
    if ( (error = fileOpen(fileName, fileOpenRead, &f)) != OK )
        PASSERR()
    fileOpened = 1;

    /* Allocate memory for the module structure: */
    if ( (error = memAlloc(sizeof(gmpModule), (void**) &module)) != OK )
        PASSERR()

    /* Clear module structure so that it can safely be deallocated with
       gmpFreeModule() at any point: */
    module->panning = NULL;
    module->songData = NULL;
    module->instruments = NULL;
    module->patterns = NULL;

    /* Read Fasttracker module header: */
    if ( (error = fileRead(f, header, sizeof(xmHeader))) != OK )
        PASSERR()

    /* Skip possible unused bytes at the end of the module header: */
    if ( (error = fileSeek(f, header->hdrSize - sizeof(xmHeader) + 60,
        fileSeekRelative)) != OK )
        PASSERR()

    /* Check that the header contains a valid signature and the file format
       version number is correct: */
    if ( (!mMemEqual(header->signature, "Extended Module: ", 17)) ||
        (header->version < 0x104) )
    {
        ERROR(errInvalidModule, ID_gmpLoadXM);
        LoadError();
        return errInvalidModule;
    }

    /* Get number of channels from the header: */
    numChans = header->numChans;
    module->numChannels = numChans;

    /* Copy song name: */
    mMemCopy(module->name, header->name, 20);
    module->name[20] = 0;                   /* force terminating '\0' */

    module->songLength = header->songLength;    /* copy song length */
    module->playMode = gmpFT2;              /* set FT2 playing mode */
    module->masterVolume = 64;              /* maximum master volume */
    module->speed = (uchar) header->speed;  /* copy initial speed */
    module->tempo = (uchar) header->tempo;  /* copy initial tempo */
    module->restart = header->restart;      /* copy restart position */
    module->numPatts = header->numPatts;    /* copy number of patterns */

    /* Check if linear frequencies are used: */
    if ( header->flags & xmLinearFreq )
        module->playFlags.linFreqTable = 1;
    else
        module->playFlags.linFreqTable = 0;

    /* Allocate memory for channel initial panning positions: */
    if ( (error = memAlloc(32 * sizeof(int), (void**) &module->panning))
        != OK )
        PASSERR()

    /* Set initial panning position to all middle: */
    for ( i = 0; i < numChans; i++ )
        module->panning[i] = 0x80;

    /* Allocate memory for song data: */
    if ( (error = memAlloc(sizeof(ushort) * module->songLength,
        (void**) &module->songData)) != OK )
        PASSERR()

    /* Copy song data and find the maximum pattern used: */
    maxPatt = 0;
    for ( i = 0; i < module->songLength; i++ )
    {
        module->songData[i] = header->orders[i];
        if ( module->songData[i] > maxPatt )
            maxPatt = module->songData[i];
    }

    /* If more patterns are used than there are in the file, allocate memory
       for all of them: */
    if ( maxPatt >= module->numPatts )
        module->numPatts = maxPatt + 1;

    /* Allocate memory for pattern pointers: */
    if ( (error = memAlloc(sizeof(gmpPattern*) * module->numPatts,
        (void**) &module->patterns)) != OK )
        PASSERR()

    /* Set all pattern pointers to NULL to mark them unallocated: */
    for ( i = 0; i < module->numPatts; i++ )
        module->patterns[i] = NULL;

    /* Allocate memory for instrument used flags: */
    if ( (error = memAlloc(256, (void**)&instUsed)) != OK )
        PASSERR()

    /* Mark all instruments unused: */
    for ( i = 0; i < 256; i++ )
        instUsed[i] = 0;

    /* Clear maximum instrument number used: */
    maxInstUsed = 0;

    /* Allocate memory for pattern loading buffer: */
    if ( (error = memAlloc(sizeof(xmPattern) + numChans * 5 * 256,
        (void**) &xmPatt)) != OK )
        PASSERR()

    /* Allocate memory for pattern conversion buffer: (maximum GMP pattern
       data size is 6 bytes per row per channel plus header) */
    if ( (error = memAlloc(numChans * 256 * 6 + sizeof(gmpPattern),
        (void**) &convPatt)) != OK )
        PASSERR()

#ifdef DEBUGMESSAGES
    puts("Starting to load patterns");
#endif

    /* Load and convert all patterns: */
    for ( i = 0; i < module->numPatts; i++ )
    {
#ifdef DEBUGMESSAGES
        printf("Pattern %i - ", i);
#endif

        CHECKHEAP

        /* Check if this pattern is in file: */
        if ( i < header->numPatts )
        {
            /* Read pattern header: */
            if ( (error = fileRead(f, xmPatt, sizeof(xmPattern))) != OK )
                PASSERR()

            /* Skip possible unused bytes at the end of the pattern header: */
            if ( (error = fileSeek(f, xmPatt->headerLength - sizeof(xmPattern),
                fileSeekRelative)) != OK )
                PASSERR()

#ifdef DEBUGMESSAGES
	    printf("sizeof(xmPattern) = %i - ", sizeof(xmPattern));
	    printf("offsetti = %u - ",
		   (unsigned) &xmPatt->numRows - (unsigned) xmPatt);
            printf("Rows: %u, size %u, bsize %u - ", xmPatt->numRows,
                xmPatt->pattDataSize, 5 * 256 * numChans);
#endif

            /* Read pattern data: */
            if ( xmPatt->pattDataSize != 0 )
            {
                if ( (error = fileRead(f, xmPatt->data, xmPatt->pattDataSize))
                    != OK )
                    PASSERR()
            }
        }
        else
        {
            /* Pattern used but not in file - mark empty: */
            xmPatt->pattDataSize = 0;
            xmPatt->numRows = 64;

#ifdef DEBUGMESSAGES
            printf("Empty -");
#endif
        }

        CHECKHEAP

#ifdef DEBUGMESSAGES
        printf("Loaded, about to convert - ");
#endif

        /* Convert the pattern data, checking the instruments used: */
        if ( (error = ConvertPattern(xmPatt, convPatt, &convPattLen))
            != OK )
            PASSERR()

#ifdef DEBUGMESSAGES
        printf("Conv. size %u - ", convPattLen);
#endif

        CHECKHEAP

#ifndef NOEMS
        if ( mUseEMS == 1 )             /* is EMS memory used? */
        {
            /* Allocate EMS for converted pattern data for current pattern in
               module: */
            if ( (error = emsAlloc(convPattLen, (emsBlock**)
                &module->patterns[i])) != OK )
                PASSERR()

            /* Map the allocated EMS block to conventional memory: */
            if ( (error = emsMap((emsBlock*) module->patterns[i],
                (void**) &patt)) != OK)
                PASSERR()

            /* Copy the converted pattern data to the EMS block: */
            mMemCopy(patt, convPatt, convPattLen);
        }
        else
#endif
        {
            /* Allocate memory for converted pattern data for current pattern
               in module: */
            if ( (error = memAlloc(convPattLen, (void**)&module->patterns[i]))
                != OK )
                PASSERR()

            /* Copy the converted pattern data to the EMS block: */
            mMemCopy(module->patterns[i], convPatt, convPattLen);
        }
#ifdef DEBUGMESSAGES
        puts("OK");
#endif
        CHECKHEAP
    }

#ifdef DEBUGMESSAGES
    puts("Patterns loaded");
#endif

    CHECKHEAP

    /* Deallocate pattern conversion buffer: */
    if ( (error = memFree(convPatt)) != OK )
        PASSERR()
    convPatt = NULL;

    /* Deallocate pattern loading buffer: */
    if ( (error = memFree(xmPatt)) != OK )
        PASSERR()
    xmPatt = NULL;

    /* Check actual number of instruments needed: (ensure that all used
       instruments are added to Sound Device) */
    if ( maxInstUsed >= header->numInsts )
        numInsts = maxInstUsed + 1;
    else
        numInsts = header->numInsts;
    module->numInsts = numInsts;

#ifdef DEBUGMESSAGES
    printf("maxInstUsed = %i\n", maxInstUsed);
#endif


    /* Now we read all instrument and sample headers from the files,
       converting them to GMPlayer structures. Offsets to sample data in the
       file are saved in GMPlayer sample structure sample pointers (always
       at least 32-bit) so that they can be read faster. This is necessary
       as we need to be able to find out the maximum sample length to be able
       to allocate a loading buffer for the samples. */


    /* Allocate memory for instrument pointers: */
    if ( (error = memAlloc(sizeof(gmpInstrument*) * numInsts,
        (void**) &module->instruments)) != OK )
        PASSERR()

    /* Set all instrument pointers to NULL to mark them unallocated: */
    for ( i = 0; i < numInsts; i++ )
        module->instruments[i] = NULL;

    /* Allocate memory for instrument and sample headers: */
    if ( (error = memAlloc(sizeof(xmInstHeader), (void**) &xmInst)) != OK )
        PASSERR()
    if ( (error = memAlloc(sizeof(xmInstSampleHeader), (void**) &xmInstSmp))
        != OK )
        PASSERR()
    if ( (error = memAlloc(sizeof(xmSampleHeader), (void**) &xmSample))
        != OK )
        PASSERR()

    maxSample = 0;

    for ( i = 0; i < numInsts; i++ )
    {
#ifdef DEBUGMESSAGES
        printf("Loading instrument %i\n", i);
#endif

        /* Check if the instrument number is below XM header maximum. If so,
           load the instrument header, otherwise fill in necessary information
           so that it appears like an empty header (which it is). Ugly? You
           bet! */
        if ( i < header->numInsts )
        {
            /* Read instrument header: */
            if ( (error = fileRead(f, xmInst, sizeof(xmInstHeader))) != OK )
                PASSERR()

            skip = xmInst->instSize - sizeof(xmInstHeader);

            /* If the instrument has samples read instrument sample header: */
            if ( xmInst->numSamples != 0 )
            {
                if ( (error = fileRead(f, xmInstSmp, sizeof(xmInstSampleHeader)))
                    != OK )
                    PASSERR()

                skip -= sizeof(xmInstSampleHeader);

                /* Check number of samples used: */
                numSamplesUsed = 0;
                for ( n = 0; n < 96; n++ )
                {
                    if ( xmInstSmp->noteSmpNums[n] >= numSamplesUsed )
                        numSamplesUsed = xmInstSmp->noteSmpNums[n] + 1;
                }
            }
            else
                numSamplesUsed = 0;
        }
        else
        {
            /* Instrument not in the file is used - clear the structure: */
            xmInst->instSize = 0;
            xmInst->instName[0] = 0;
            xmInst->instType = 0;
            xmInst->numSamples = 0;
            numSamplesUsed = 0;

            /* And how we love Triton! */
            mMemCopy(&xmInst->instName[1], "S2 loves Triton!", 17);

            /* No data after the header: (what header? ;) */
            skip = 0;
        }


        /* If instrument is used, it must have at least one sample (regardless
           of what the XM instrument header says) */
        if ( instUsed[i] )
        {
            if ( numSamplesUsed > 0 )
                n = numSamplesUsed;
            else
                n = 1;
        }
        else
        {
            n = 0;
        }

        /* Allocate memory for instrument and sample structures: */
        if ( (error = memAlloc(sizeof(gmpInstrument) + n*sizeof(gmpSample),
            (void**) &inst))
            != OK )
            PASSERR()
        module->instruments[i] = inst;

        /* Copy instrument name: */
        mMemCopy(inst->name, xmInst->instName, 22);
        inst->name[22] = 0;

        inst->numSamples = n;
        inst->used = instUsed[i];

        /* Clear all allocated samples so that the module can be deallocated
           safely: */
        sample = &inst->samples[0];
        for ( s = 0; s < n; s++ )
        {
            sample->sdHandle = 0;
            sample->sample = NULL;
            sample->sampleType = smpNone;
            sample->volume = 0;
            sample->panning = panMiddle;
            sample->baseTune = 0;
            sample->finetune = 0;
        }

        inst->noteSamples = NULL;
        inst->volEnvelope = NULL;
        inst->panEnvelope = NULL;

        /* Process instrument sample header: */
        if ( xmInst->numSamples > 0 )
        {
            /* Check if we need a note sample number table: */
            if ( numSamplesUsed > 1 )
            {
                /* Allocate memory for table: */
                if ( (error = memAlloc(96, (void**) &inst->noteSamples))
                    != OK )
                    PASSERR()

                /* Copy note numbers: */
                mMemCopy(inst->noteSamples, xmInstSmp->noteSmpNums, 96);

#ifdef DEBUGMESSAGES
                printf("\nnoteSamples!\n");
#endif
            }

            /* Check if volume envelope is used: */
            if ( xmInstSmp->volEnvFlags & xmEnvelopeOn )
            {
                /* Allocate memory for volume envelope info: */
                if ( (error = memAlloc(sizeof(gmpEnvelope), (void**)
                    &inst->volEnvelope)) != OK )
                    PASSERR()
                env = inst->volEnvelope;

                /* Copy number of points in envelope: */
                env->numPoints = xmInstSmp->numVolPoints;

                /* Set sustain point: */
                if ( xmInstSmp->volEnvFlags & xmEnvelopeSustain )
                    env->sustain = xmInstSmp->volSustain;
                else
                    env->sustain = -1;

                /* Set loop start and end points: (FT2 ignores envelope
                   loops where the start and end positions are the same) */
                if ( (xmInstSmp->volEnvFlags & xmEnvelopeLoop) &&
                    (xmInstSmp->volLoopStart != xmInstSmp->volLoopEnd) )
                {
                    env->loopStart = xmInstSmp->volLoopStart;
                    env->loopEnd = xmInstSmp->volLoopEnd;
                }
                else
                {
                    env->loopStart = env->loopEnd = -1;
                }

                /* Copy envelope points: */
                mMemCopy(env->points, xmInstSmp->volEnvelope, 48);
            }
            else
                inst->volEnvelope = NULL;

            /* Check if panning envelope is used: */
            if ( xmInstSmp->panEnvFlags & xmEnvelopeOn )
            {
                /* Allocate memory for volume envelope info: */
                if ( (error = memAlloc(sizeof(gmpEnvelope), (void**)
                    &inst->panEnvelope)) != OK )
                    PASSERR()
                env = inst->panEnvelope;

                /* Copy number of points in envelope: */
                env->numPoints = xmInstSmp->numPanPoints;

                /* Set sustain point: */
                if ( xmInstSmp->panEnvFlags & xmEnvelopeSustain )
                    env->sustain = xmInstSmp->panSustain;
                else
                    env->sustain = -1;

                /* Set loop start and end points: (FT2 ignores envelope
                   loops where the start and end positions are the same) */
                if ( (xmInstSmp->panEnvFlags & xmEnvelopeLoop) &&
                     (xmInstSmp->panLoopStart != xmInstSmp->panLoopEnd) )
                {
                    env->loopStart = xmInstSmp->panLoopStart;
                    env->loopEnd = xmInstSmp->panLoopEnd;
                }
                else
                {
                    env->loopStart = env->loopEnd = -1;
                }

                /* Copy envelope points: */
                mMemCopy(env->points, xmInstSmp->panEnvelope, 48);
            }
            else
                inst->panEnvelope = NULL;

            /* Copy volume fade-out speed: */
            inst->volFadeout = xmInstSmp->volFadeout;

            /* Copy instrument auto-vibrato information: */
            inst->vibType = xmInstSmp->vibType;
            inst->vibSweep = xmInstSmp->vibSweep;
            inst->vibDepth = xmInstSmp->vibDepth;
            inst->vibRate = xmInstSmp->vibRate;
        }

        /* Skip possible unnecessary bytes at the end of the instrument
           header: */
        if ( (error = fileSeek(f, skip, fileSeekRelative)) != OK )
            PASSERR()

        /* Get current file position: */
        if ( (error = fileGetPosition(f, &filePos)) != OK )
            PASSERR()

        /* Calculate start offset for first sample: */
        smpStart = filePos + xmInst->numSamples * xmInstSmp->headerSize;

        /* Total sample length for this instrument: */
        smpTotal = 0;

        /* Load and convert all sample headers and calculate total sample
           length: */
        sample = &inst->samples[0];
        for ( s = 0; s < xmInst->numSamples; s++ )
        {
            /* Read sample header: */
            if ( (error = fileRead(f, xmSample, sizeof(xmSampleHeader)))
                != OK )
                PASSERR()

            /* Convert sample header if it used: */
            if ( s < inst->numSamples )
            {
                /* Point sample->fileOffset to sample data start: */
                sample->fileOffset = smpStart;

                /* Copy sample name: */
                mMemCopy(sample->name, xmSample->smpName, 22);
                sample->name[22] = 0;

                /* Copy sample information: */
                sample->sampleLength = xmSample->smpLength;
                sample->loop1Start = xmSample->loopStart;
                sample->loop1End = xmSample->loopStart + xmSample->loopLength;
                sample->volume = xmSample->volume;
                sample->panning = (int) ((unsigned) xmSample->panning);
                sample->baseTune = xmSample->relNote;
                sample->finetune = (int) ((signed char) xmSample->finetune);
                sample->loop2Type = loopNone;

                /* Convert sample type: */
                if ( xmSample->flags & xmSample16bit )
                    sample->sampleType = smp16bit;
                else
                    sample->sampleType = smp8bit;

                /* Update maximum sample length: */
                if ( sample->sampleLength > maxSample )
                    maxSample = sample->sampleLength;

                /* Convert sample loop type information: */
                switch ( xmSample->flags & 3 )
                {
                    case 1:
                        /* Unidirectional loop: */
                        sample->loopMode = sdLoop1;
                        sample->loop1Type = loopUnidir;
                        break;

                    case 2:
                        /* Bidirectional loop: */
                        sample->loopMode = sdLoop1;
                        sample->loop1Type = loopBidir;
                        break;

                    default:
                        /* No loop: */
                        sample->loopMode = sdLoopNone;
                        sample->loop1Type = loopNone;
                        break;
                }

                /* Check that the loop is legal if there is one: */
                if ( sample->loop1End == sample->loop1Start )
                {
                    sample->loopMode = sdLoopNone;
                    sample->loop1Type = loopNone;
                }
            }

            /* Add sample length to sample total: */
            smpTotal += xmSample->smpLength;

            /* Update sample data start offset: */
            smpStart += xmSample->smpLength;

            /* Skip possible unused data at the end of sample header: */
            if ( (error = fileSeek(f, xmInstSmp->headerSize -
                sizeof(xmSampleHeader), fileSeekRelative)) != OK )
                PASSERR();

            sample++;
        }

        /* Create an empty sample header if a sample was allocated but not
           loaded: */
        if ( (n != 0) && (xmInst->numSamples == 0) )
        {
            sample->name[0] = 0;
            sample->sample = NULL;
            sample->sampleType = smpNone;
            sample->volume = 0;
            sample->panning = panMiddle;
            sample->sdHandle = 0;
        }

        /* Seek to the start of next instrument header: */
        if ( (error = fileSeek(f, smpStart, fileSeekAbsolute)) != OK )
            PASSERR();

        CHECKHEAP
    }


    /* Deallocate memory instrument and sample headers: */
    if ( (error = memFree(xmInst)) != OK )
        PASSERR()
    xmInst = NULL;
    if ( (error = memFree(xmInstSmp)) != OK )
        PASSERR()
    xmInstSmp = NULL;
    if ( (error = memFree(xmSample)) != OK )
        PASSERR()
    xmSample = NULL;


    /* Check that the maximum sample length is below the Sound Device limit:*/
    if ( maxSample > SMPMAX )
    {
        ERROR(errInvalidInst, ID_gmpLoadXM);
        LoadError();
        return errInvalidInst;
    }

    /* If samples should be added to Sound Device, allocate memory for sample
       loading buffer: */
    if ( addSD )
    {
        if ( (error = memAlloc(maxSample, (void**) &smpBuf)) != OK )
            PASSERR()
    }

    /* Load all samples, convert the sample data and add the samples to Sound
       Device if necessary: */
    for ( i = 0; i < numInsts; i++ )
    {
        inst = module->instruments[i];

        /* Load all samples for this instrument: */
        sample = &inst->samples[0];
        for ( s = 0; s < inst->numSamples; s++ )
        {
#ifdef DEBUGMESSAGES
            printf("Loading sample %i for instrument %i - ", s, i);
#endif
            CHECKHEAP

            if ( sample->sampleType == smpNone )
            {
#ifdef DEBUGMESSAGES
                puts("no sample");
#endif
                /* There is no sample - just build an empty Sound Device
                   sample structure: */
                sdSmp.sampleType = smpNone;
                sdSmp.samplePos = sdSmpNone;
                sdSmp.sample = NULL;
            }
            else
            {
#ifdef DEBUGMESSAGES
                printf("sample, len = %u\n", sample->sampleLength);
#endif
                /* There is a sample. If sample data should not be added to
                   Sound Device, allocate memory for the sample data and
                   point smpBuf there: */
                if ( (!addSD) && (sample->sampleLength > 0) )
                {
                    smpBuf = NULL;
                    if ( (error = memAlloc(sample->sampleLength, (void**)&smpBuf))
                        != OK )
                        PASSERR()
                    sample->sample = smpBuf;
                }
                else
                {
                    /* Sample is added to the Sound Device - sample data is
                       not available: */
                    sample->sample = NULL;
                }

                /* Seek to beginning of sample data in file: */
                if ( (error = fileSeek(f, sample->fileOffset,
                    fileSeekAbsolute)) != OK )
                    PASSERR();

                /* Read the sample data: */
                if ( sample->sampleLength > 0 )
                {
                    if ( sample->sampleLength > maxSample )
                    {
#ifdef DEBUGMESSAGES
                        puts("BIG trouble!");
#endif
                    }
                    else
                    {
#ifdef DEBUGMESSAGES
                        printf("Reading %i bytes to %p\n",
                            sample->sampleLength, smpBuf);
#endif
                        if ( (error = fileRead(f, smpBuf,
                            sample->sampleLength)) != OK)
                            PASSERR();
#ifdef DEBUGMESSAGES
                        printf("Done\n");
#endif
                        CHECKHEAP
                    }
                }
                else
                {
                    sample->sampleType = smpNone;
                }

#ifdef DEBUGMESSAGES
                printf("smpBuf = %p, len = %ld\n", smpBuf, maxSample);
#endif

#if 0   /* 16-bit sample support removed for now */
                /* The sample data is in delta format. */
                if ( sample->sampleType == smp16bit )
                {
                    /* 16-bit sample */
#ifdef DEBUGMESSAGES
                    puts("16-bit sample data!");
#endif
                    sdSmp.sampleType = smp16bit;
                    smpData = smpBuf;
                    d = 0;
                    for ( n = 0; n < (sample->sampleLength / 2); n++ )
                    {
                        d += (int) *((signed short*) smpData);
                        *((signed short*) smpData) = d;
                        smpData += 2;
                    }
                    CHECKHEAP
                }
                else
                {
                    /* 8-bit sample */
                    sdSmp.sampleType = smp8bit;
                    smpData = smpBuf;
                    d = 0;
                    for ( n = 0; n < sample->sampleLength; n++ )
                    {
                        d += (int) *((signed char*) smpData);
                        *smpData = (uchar) (128 + d);
                        smpData++;
                    }
                }


                /* Set Sound Device sample type: */
#endif /* #if 0 */

/* Code from older version added */

                /* The sample data is in delta format. Convert it to raw
                   unsigned 8-bit data: (FIXME - 16-bit samples!) */
                if ( sample->sampleType == smp16bit )
                {
#ifdef DEBUGMESSAGES
                    puts("Converting 16-bit sample data");
#endif
                    /* 16-bit sample - convert to 8-bit on the fly */
                    smpData = smpBuf;
                    d = 0;
                    for ( n = 0; n < (sample->sampleLength / 2); n++ )
                    {
                        d += (int) *((signed short*) smpData);
                        smpBuf[n] = (uchar) (128 + (d >> 8));
                        smpData += 2;
                    }
#ifdef DEBUGMESSAGES
                    puts("Converting sample structure");
#endif
                    /* Converted to 8-bit - update sample structure: */
                    sample->sampleLength /= 2;
                    sample->loop1Start /= 2;
                    sample->loop1End /= 2;
                    sample->sampleType = smp8bit;
                    /* (second loop not used) */
                    CHECKHEAP
                }
                else
                {
                    /* 8-bit sample */
                    smpData = smpBuf;
                    d = 0;
                    for ( n = 0; n < sample->sampleLength; n++ )
                    {
                        d += (int) *((signed char*) smpData);
                        *smpData = (uchar) (128 + d);
                        smpData++;
                    }
                }

                /* Set Sound Device sample type: */
                sdSmp.sampleType = smp8bit;

    /* end of added code */

                /* Set Sound Device sample position in memory: */
                sdSmp.samplePos = sdSmpConv;

                /* Point Sound Device sample data to sample loading buffer: */
                sdSmp.sample = smpBuf;

                /* Point smpBuf to NULL if the sample is not added to Sound
                   Device to mark it should not be deallocated: */
                if ( !addSD )
                    smpBuf = NULL;
            }

            sdSmp.sampleLength = sample->sampleLength;
            sdSmp.loopMode = sample->loopMode;
            sdSmp.loop1Start = sample->loop1Start;
            sdSmp.loop1End = sample->loop1End;
            sdSmp.loop1Type = sample->loop1Type;

            /* Set up the rest of Sound Device sample structure so that the sample
               can be added to the Sound Device: */
            if ( addSD )
            {
                CHECKHEAP

#ifdef DEBUGMESSAGES
                puts("gmpSD->AddSample()");
#endif

                /* Add the sample to Sound Device and store the Sound Device
                   sample handle in sample->sdHandle: */
                if ( (error = gmpSD->AddSample(&sdSmp, 1, &sample->sdHandle))
                    != OK)
                    PASSERR()

                CHECKHEAP

               /* Call sample callback if used: */
                if ( SampleCallback != NULL )
                {
                    if ( (error = SampleCallback(&sdSmp, sample)) != OK )
                        PASSERR()
                }
            }
            else
            {
                /* Sample data has not been added to Sound Device: */
                sample->sdHandle = 0;
            }
            sample++;
        }
    }

#ifdef DEBUGMESSAGES
    puts("Samples loaded");
#endif
    CHECKHEAP

    /* Deallocate sample loading buffer if allocated: */
    if ( addSD )
    {
        if ( (error = memFree(smpBuf)) != OK )
            PASSERR()
    }
    smpBuf = NULL;

    /* Deallocate instrument use flags: */
    if ( (error = memFree(instUsed)) != OK )
        PASSERR()
    instUsed = 0;

    /* Now we are finished loading. Close module file: */
    if ( (error = fileClose(f)) != OK)
        PASSERR()
    fileOpened = 0;

    /* Deallocate Fasttracker 2 module header: */
    if ( (error = memFree(header)) != OK )
        PASSERR();

    /* Return module pointer in *module: */
    *_module = module;

    return OK;
}


/*
 * $Log: loadxm.c,v $
 * Revision 1.12  1997/01/25 15:23:16  pekangas
 * The file is now closed properly if loading terminates to an error
 *
 * Revision 1.11  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.10  1997/01/07 19:18:15  pekangas
 * Now ignores envelope loops if start position = end position (as FT2 does)
 *
 * Revision 1.9  1996/12/30 23:37:19  jpaana
 * Cleaned up LoadError
 *
 * Revision 1.8  1996/10/06 16:48:38  pekangas
 * Fixed a potential signed/unsigned mismatch in panning
 *
 * Revision 1.7  1996/09/01 15:42:18  pekangas
 * Changed to use new style slides (no more signed infobytes)
 *
 * Revision 1.6  1996/07/13 20:14:11  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.5  1996/07/13 18:24:02  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.4  1996/06/14 16:23:40  pekangas
 * Removed heap checking to speed up loading
 *
 * Revision 1.3  1996/05/25 15:49:57  jpaana
 * Tried to fix for Linux, succeeded too
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Fixed to work with gcc
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/
