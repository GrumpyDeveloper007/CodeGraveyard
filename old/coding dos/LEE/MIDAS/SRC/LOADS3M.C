/*      loads3m.c
 *
 * Generic Module Player Screamtracker 3 Module loader
 *
 * $Id: loads3m.c,v 1.15 1997/01/25 15:23:16 pekangas Exp $
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
#include "mglobals.h"
#include "mmem.h"
#include "file.h"
#include "sdevice.h"
#include "gmplayer.h"
#ifndef NOEMS
#include "ems.h"
#endif
#include "mutils.h"


/*#define CHECK_THE_HEAP*/

#ifdef CHECK_THE_HEAP
#include <malloc.h>
#endif


RCSID(const char *loads3m_rcsid = "$Id: loads3m.c,v 1.15 1997/01/25 15:23:16 pekangas Exp $";)



/* Pass error code in variable "error" on, used in gmpLoadS3M(). */
#define PASSERR() { LoadError(); PASSERROR(ID_gmpLoadS3M) }

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

#if defined(CHECKTHEHEAP) && defined(__WC32__)
    /* Maximum valid block in heap: */
#define MAXBLK (2048*1024)

int TestHeap(void)
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

/****************************************************************************\
*       struct s3mHeader
*       ----------------
* Description:  Scream Tracker 3 module file header
\****************************************************************************/

typedef struct
{
    char	name[28];		/* song name */
    U8          num1A;                  /* 0x1A */
    U8          type;                   /* file type */
    U16         unused1;
    U16         songLength;             /* number of orders */
    U16         numInsts;               /* number of instruments */
    U16         numPatts;               /* number of patterns */
    U16         flags;

/*
    struct
	{
        int     st2Vibrato : 1;
        int     st2Tempo : 1;
        int     ptSlides : 1;
        int     zeroVolOpt : 1;
        int     ptLimits : 1;
        int     filter : 1;
        int     fastVolSlide : 1;
        int     unused : 9;
	} flags;
*/
    U16         trackerVer;             /* tracker version */
    U16         formatVer;              /* file format version */
    char	SCRM[4];		/* "SCRM" */
    U8          masterVol;              /* master volume */
    U8          speed;                  /* initial speed */
    U8          tempo;                  /* initial tempo */
    U8          masterMult;             /* master multiplier (bits 0-3),stereo (bit 4) */
    U8          ultraClicks;            /* Ultraclick removal info */
    U8          panningMagic;           /* 0FCh if panning infos exist */
    U8          unused2[8];
    U16         special;                /* pointer to special custom data */
    U8          chanSettings[32];       /* channel settings */

} s3mHeader;


/****************************************************************************\
*       struct s3mPattern
*       ----------------
* Description:  Screamtracker 3 Module pattern
\****************************************************************************/

typedef struct
{
    U16         pattDataSize;           /* pattern data size */
    U8          data[EMPTYARRAY];       /* packed pattern data */
} s3mPattern;


/****************************************************************************\
*       struct s3mInstHdr
*       -----------------
* Description:  Scream Tracker 3 module instrument file header
\****************************************************************************/

typedef struct
{
    U8          type;                   /* instrument type */
    char        dosName[12];            /* DOS filename (8+3) */
    char        zero;                   /* 0 */
    U16         samplePtr;              /* paragraph ptr to sample data */
    U32         length;                 /* sample length */
    U32         loopStart;              /* sample loop start */
    U32         loopEnd;                /* sample loop end */
    U8          volume;                 /* volume */
    U8          disk;                   /* instrument disk number */
    U8          pack;                   /* sample packing info (0 = raw,1 = DP30ADPCM1) */
    U8          flags;                  /* bit0 = loop, bit1 = stereo,bit2 = 16-bit */
    U32         c2Rate;                 /* C2 sampling rate */
    U32         unused;
    U16         gusPos;                 /* position in GUS memory / 32 */
    U16         int512;
    U32         intLastUsed;
    char        iname[28];              /* instrument name */
    char        SCRS[4];                /* "SCRS" if sample */
} s3mInstHdr;


/* Conversion table from Screamtracker command number to GMP ones: */
static uchar s3mCommands[26] =
{
    gmpcSetSpeed,               /* A - Set speed */
    gmpcPositionJump,           /* B - Position jump */
    gmpcPatternBreak,           /* C - Pattern break */
    gmpcVolumeSlide,            /* D - Volume slide */
    gmpcSlideDown,              /* E - Slide down */
    gmpcSlideUp,                /* F - Slide up */
    gmpcTonePortamento,         /* G - Tone portamento */
    gmpcVibrato,                /* H - Vibrato */
    gmpcNone,                   /* I - Tremor */
    gmpcArpeggio,               /* J - Arpeggio */
    gmpcVibVSlide,              /* K - Vibrato + volume slide */
    gmpcTPortVSlide,            /* L - Tone portamento + volume slide */
    gmpcNone,                   /* M - Unused */
    gmpcNone,                   /* N - Unused */
    gmpcSampleOffset,           /* O - Set sample offset */
    gmpcNone,                   /* P - Unused */
    gmpcS3MRetrig,              /* Q - ST3 extended retrig */
    gmpcTremolo,                /* R - Tremolo */
    gmpcNone,                   /* S - S-commands (table below) */
    gmpcSetTempo,               /* T - Set tempo */
    gmpcNone,                   /* U - Fine vibrato */
    gmpcSetMVolume,             /* V - Set master volume */
    gmpcMusicSync,              /* W - Music synchronization (extension) */
    gmpcSetPanning,             /* X - Set panning (extension) */
    gmpcNone,                   /* Y - Unused */
    gmpcSetPanning16            /* Z - Set panning (extension) */
};

/* Conversion table from Screamtracker S-command numbers to GMP commands: */
static uchar s3mSCommands[16] =
{
    gmpcNone,                   /* S0 - Set filter */
    gmpcNone,                   /* S1 - Set glissando control */
    gmpcNone,                   /* S2 - Set finetune */
    gmpcNone,                   /* S3 - Set vibrato waveform */
    gmpcNone,                   /* S4 - Set tremolo waveform */
    gmpcNone,                   /* S5 - Unused */
    gmpcNone,                   /* S6 - Unused */
    gmpcNone,                   /* S7 - Unused */
    gmpcSetPanning16,           /* S8 - Set panning */
    gmpcNone,                   /* S9 - Unused */
    gmpcNone,                   /* SA - Stereo control (obsolete) */
    gmpcPatternLoop,            /* SB - Pattern loop */
    gmpcNoteCut,                /* SC - Note cut */
    gmpcNoteDelay,              /* SD - Note delay */
    gmpcPatternDelay,           /* SE - Pattern delay */
    gmpcNone                    /* SF - Invert loop (unused in ST3) */
};



/****************************************************************************\
*       Module loader buffers and file handle. These variables are static
*       instead of local so that a separate deallocation can be used which
*       will be called before exiting in error situations
\****************************************************************************/
static fileHandle f;                    /* file handle for module file */
static int      fileOpened;             /* 1 if module file has been opened */
static gmpModule *module;               /* pointer to GMP module structure */
static s3mHeader *header;               /* pointer to S3M module header */
static uchar    *instUsed;              /* instrument used flags */
static s3mPattern *s3mPatt;             /* pointer to S3M pattern data */
static gmpPattern *convPatt;            /* pointer to converted pattern data*/
static U16      *instPtrs;              /* instrument paragraph pointers */
static U16      *pattPtrs;              /* pattern paragraph pointers */
static uchar    *smpBuf;                /* sample loading buffer */
static unsigned numChans;               /* number of channels in module */
static unsigned maxChan;                /* maximum enabled channel */
static unsigned maxInstUsed;            /* maximum instrument used */
static s3mInstHdr s3mi;





/****************************************************************************\
*
* Function:     int ConvertPattern(s3mPattern *srcPatt, gmpPattern *destPatt,
*                   unsigned *convLen);
*
* Description:  Converts a pattern from S3M to GMP internal format.
*               Also updates instUsed flags.
*
* Input:        s3mPattern *srcPatt     pointer to pattern in S3M format
*               gmpPattern *destPatt    pointer to destination GMP pattern
*               unsigned *convLen       pointer to converted pattern length
*
* Returns:      MIDAS error code. Converted pattern length (in bytes,
*               including header) is written to *convLen.
*
\****************************************************************************/

static int ConvertPattern(s3mPattern *srcPatt, gmpPattern *destPatt,
    unsigned *convLen)
{
    uchar       *src = &srcPatt->data[0];
    uchar       *dest = &destPatt->data[0];
    int         row;
    unsigned    len;
    U8          note, inst, command, infobyte, vol, compInfo;
    U8          s3mComp;

/*
        Packed data consits of following entries:
        BYTE:what  0=end of row
                   &31=channel
                   &32=follows;  BYTE:note, BYTE:instrument
                   &64=follows;  BYTE:volume
                   &128=follows; BYTE:command, BYTE:info
*/
    /* Check if the pattern is empty: */
    if ( (srcPatt->pattDataSize == 0) || (srcPatt == NULL) )
    {
        /* Write row end marker for each row: */
        for ( row = 0; row < 64; row++ )
            *(dest++) = 0;

        /* Write number of rows to pattern header: */
        destPatt->rows = 64;

        /* Write converted pattern length to header and return it in
           *convLen: */
        *convLen = destPatt->length = 64 + sizeof(gmpPattern);
        return OK;
    }

    for ( row = 0; row < 64; row++ )
    {
        while ( *src != 0 )
        {
            /* No data for this channel yet: */
            compInfo = 0;
            note = 0xFF;
            inst = 0xFF;
            command = 0;
            infobyte = 0;
            vol = 0;

            /* Get note number/compression info from pattern data: */
            s3mComp = *src++;

            /* Check if there is a new note and instrument: */
            if ( s3mComp & 32 )
            {
                /* Check that the note is not key off and convert it to GMP
                   internal format: */
                if ( ( *src < 0x7f ) || ( *src == 0xfe ) || ( *src == 0xff ) )
                    note = *src;
                src++;

                /* Get the instrument number: */
                if ( *src <= module->numInsts )
                    inst = (*src) - 1;

                src++;

                /* Check if the instrument number if above maximum instrument
                   number used: */
                if ( inst <= 100 )
                {
                    if ( inst < module->numInsts )
                    {
                        if ( inst > maxInstUsed )
                            maxInstUsed = inst;

                        /* Mark instrument used: */
                        instUsed[inst] = 1;
                    }
                }
                /* Mark that there is a new note and/or instrument: */
                compInfo |= 32;

                if ( numChans <= (unsigned) (s3mComp & 31) )
                    numChans = (s3mComp & 31) + 1;
            }

            /* Check if there is a volume column byte: */
            if ( s3mComp & 64 )
            {
                /* Get the volume column byte: */
                vol = *(src++);

                if ( vol > 63 ) vol = 63;

                /* Mark that there is a volume column byte: */
                compInfo |= 64;
            }

            /* Check if there is a command: */
            if ( s3mComp & 128 )
            {
                /* Get the command number: */
                command = *(src++);

                /* Get the infobyte: */
                infobyte = *(src++);
            }

            /* If there is a command or an infobyte we need to write the
               command to the destination pattern: */
            if ( (command > 0) && (command < 26 ) )
            {
                switch ( command )
                {
                    case 19:
                        /* Command S - check actual command number: */
                        command = s3mSCommands[infobyte >> 4];
                        infobyte = infobyte & 0x0F;
                        break;

                    default:
                        /* Convert command to GMP command number: */
                        command = s3mCommands[command - 1];
                        break;
                }

                /* Mark that there is a command: */
                if ( command != gmpcNone )
                    compInfo |= 128;
            }

            /* If the compression information is nonzero, there is some
               data for this channel: */
            if ( ( compInfo & 0xE0 ) != 0 )
            {
                /* Set channel number to lower 5 bits of the compression info
                   and write it to destination: */
                compInfo |= ( s3mComp & 31 );
                if ( (unsigned) (s3mComp & 31) <= maxChan )
                {
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
                        *(dest++) = command;
                        *(dest++) = infobyte;
                    }
                }
            }
        }

        /* Write row end marker: */
        *(dest++) = 0;
        src++;
    }

    /* Write number of rows to pattern header: */
    destPatt->rows = 64;

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
}




/****************************************************************************\
*
* Function:     int gmpLoadS3M(char *fileName, int addSD, mpModule **module)
*
* Description:  Loads a Scream Tracker 3 module to memory in Generic Module
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

int CALLING gmpLoadS3M(char *fileName, int addSD, int
    (CALLING *SampleCallback)(sdSample *sdsmp, gmpSample *gmpsmp),
    gmpModule **_module)
{
    int             error;              /* MIDAS error code */
    gmpInstrument   *inst;
    uchar           *panningInfos;
    unsigned        i;
    ulong           maxSample;
    static unsigned convPattLen;
    unsigned        slength;
    gmpSample       *sample;
    uchar           *temp;
    static sdSample sdSmp;
    int             n;
#ifndef NOEMS
    uchar           *patt;
#endif
    int             panValue;
    unsigned        numS3MPatterns;
    unsigned        numUsedPatterns;


    /* point buffers to NULL and set fileOpened to 0 so that LoadError()
       can be called at any point: */
    fileOpened = 0;
    module = NULL;
    header = NULL;
    instUsed = NULL;
    s3mPatt = NULL;
    convPatt = NULL;
    instPtrs = NULL;
    pattPtrs = NULL;
    smpBuf = NULL;

    /* Clear other loader variables: */
    maxInstUsed = 0;

    /* Allocate memory for Screamtracker module header: */
    if ( (error = memAlloc(sizeof(s3mHeader), (void**) &header)) != OK )
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

    /* read Screamtracker module header: */
    if ( (error = fileRead(f, header, sizeof(s3mHeader))) != OK )
        PASSERR()

    numChans = 0;

    /* Check the module signature: */
    if ( !(mMemEqual(&header->SCRM[0], "SCRM", 4) ) )
    {
        ERROR(errInvalidModule, ID_gmpLoadS3M);
        LoadError();
        return errInvalidModule;
    }


    /* Copy song name: */
    mMemCopy(&module->name[0], &header->name[0], 28);
    module->name[28] = 0;                   /* force terminating '\0' */

    module->songLength = header->songLength;    /* copy song length */
    module->numInsts = header->numInsts;    /* set number of instruments */
    numS3MPatterns = header->numPatts;      /* store number of patterns */
    module->numPatts = 0;                   /* not really known yet! */
    module->playMode = gmpST3;              /* set ST3 playing mode */
    module->masterVolume = header->masterVol; /* copy master volume */
    module->speed = header->speed;          /* initial speed */
    module->tempo = header->tempo;          /* initial tempo */

    /* Copy some flags */
    module->playFlags.ptLimits = ( header->flags & 0x10 ) >> 4;
    module->playFlags.fastVolSlides = ( header->flags & 0x40 ) >> 6;
    if ( header->trackerVer < 0x1320 )
        module->playFlags.fastVolSlides = 1;

    module->restart = 0;

#ifdef DEBUGMESSAGES
    puts("Header ready");
#endif
    CHECKHEAP

    /* Allocate memory for song data: */
    if ( (error = memAlloc(sizeof(ushort) * module->songLength,
        (void**) &module->songData)) != OK )
        PASSERR()

    /* read song data: */
    if ( (error = fileRead(f, module->songData, sizeof(uchar) *
        module->songLength)) != OK )
        PASSERR()

    /* Calculate real song length: (exclude 0xFF bytes from end) */
    for ( n = (module->songLength - 1); module->songData[n] == 0xFF; n-- );
        module->songLength = n + 1;

    /* Convert song data and find the highest pattern number used: */
    temp = (uchar*) module->songData;
    numUsedPatterns = 0;
    for ( n = module->songLength - 1; n >= 0 ; n-- )
    {
        switch ( temp[n] )
        {
            case 0xfe:
                module->songData[n] = 0xfffe;
                break;

            case 0xff:
                module->songData[n] = 0xffff;
                break;

            default:
                module->songData[n] = temp[n];
                if ( temp[n] >= numUsedPatterns )
                    numUsedPatterns = temp[n] + 1;
        }
    }

    module->numPatts = numUsedPatterns;

    /* check that song length is nonzero: */
    if ( module->songLength == 0 )
    {
        ERROR(errInvalidModule, ID_gmpLoadS3M);
        LoadError();
        return errInvalidModule;
    }

#ifdef DEBUGMESSAGES
    puts("Song data ready");
    printf("Num.patts: %i\n", module->numPatts);
#endif
    CHECKHEAP

    /* Allocate memory for pattern pointers: */
    if ( (error = memAlloc(4 * module->numPatts,
        (void**) &module->patterns)) != OK )
        PASSERR()

    /* Set all pattern pointers to NULL to mark them unallocated: */
    for ( i = 0; i < module->numPatts; i++ )
        module->patterns[i] = NULL;

    /* Allocate memory for instrument pointers: */
    if ( (error = memAlloc(sizeof(gmpInstrument*) * module->numInsts,
        (void**) &module->instruments)) != OK )
        PASSERR()

    /* Set all instrument pointers to NULL to mark them unallocated: */
    for ( i = 0; i < module->numInsts; i++ )
        module->instruments[i] = NULL;

    /* Allocate memory for instrument used flags: */
    if ( (error = memAlloc(module->numInsts, (void**)&instUsed)) != OK )
        PASSERR()

    /* Mark all instruments unused: */
    for ( i = 0; i < module->numInsts; i++ )
        instUsed[i] = 0;

     /* Allocate memory for instrument paragraph pointers: */
    if ( (error = memAlloc(sizeof(U16) * module->numInsts, (void**)
        &instPtrs)) != OK )
        PASSERR()

    /* Read instrument pointers: */
    if ( (error = fileRead(f, instPtrs, sizeof(U16) * module->numInsts))
        != OK )
        PASSERR()

    /* Allocate memory for S3M file pattern pointers: */
    if ( (error = memAlloc(sizeof(U16) * numS3MPatterns, (void**)
        &pattPtrs)) != OK )
        PASSERR()

    /* Read pattern pointers: */
    if ( (error = fileRead(f, pattPtrs, sizeof(U16) * numS3MPatterns))
        != OK )
        PASSERR()

#ifdef DEBUGMESSAGES
    puts("Misc. pointers ready");
#endif
    CHECKHEAP

    /* Allocate memory for channel initial panning positions: */
    if ( (error = memAlloc(32 * sizeof(int), (void**) &module->panning))
        != OK )
        PASSERR()

    if ( header->panningMagic == 0xFC )
    {
        /* Allocate memory for panning infos: */
        if ( (error = memAlloc(32 * sizeof(uchar),
            (void**) &panningInfos)) != OK )
            PASSERR()

        /* Read panning infos: */
        if ( ( error = fileRead(f, panningInfos, 32 * sizeof(uchar)) ) != OK )
            PASSERR()

        /* Convert panning values: */
        for (i = 0; i < 32; i++)
        {
            if ( header->chanSettings[i] > 15 )
            {
                module->panning[i] = 0x40;
            }
            else
            {
                maxChan = i;
                if ( panningInfos[i] & 0x20 )
                {
                    panValue = panningInfos[i] & 0xF;
                    if ( panValue < 7 )
                    {
                        module->panning[i] = 8 * panValue;
                    }
                    else
                    {
                        if ( panValue > 8 )
                            module->panning[i] = 0x80 - (15 - panValue) * 8;
                        else
                            module->panning[i] = 0x40;
                    }
                }
                else
                {
                    if (header->chanSettings[i] < 8)
                        module->panning[i] = 0x00;
                    else
                        module->panning[i] = 0x80;
                }
            }
        }

        /* Free panning infos: */
        if ( (error = memFree(panningInfos)) != OK )
            PASSERR()
        panningInfos = NULL;
    }
    else
    {
        /* copy default channel panning settings: */
        for (i = 0; i < 32; i++)
        {
            if (header->chanSettings[i] > 15)
                module->panning[i] = 0;
            else
            {
                maxChan = i;
                if (header->chanSettings[i] < 8)
                    module->panning[i] = 0x00;
                else
                    module->panning[i] = 0x80;
            }
        }
    }

#ifdef DEBUGMESSAGES
    puts("Panning ready");
#endif
    CHECKHEAP

    /* Find maximum sample length: */
    maxSample = 0;
    for ( i = 0; i < module->numInsts; i++ )
    {
        /* Seek to instrument header in file: */
        if ( (error = fileSeek(f, 16L * instPtrs[i], fileSeekAbsolute))
            != OK )
            PASSERR()

        /* Read instrument header from file: */
        if ( (error = fileRead(f, &s3mi, sizeof(s3mInstHdr))) != OK )
            PASSERR()

        if ( maxSample < s3mi.length )
            maxSample = s3mi.length;
    }

    /* Check that the maximum sample length is below the Sound Device limit:*/
    if ( maxSample > SMPMAX )
    {
        ERROR(errInvalidInst, ID_gmpLoadS3M);
        LoadError();
        return errInvalidInst;
    }

#ifdef DEBUGMESSAGES
    puts("Max. sample ready");
    printf("Max. sample: %i\n", maxSample);
#endif
    CHECKHEAP

    /* Allocate memory for pattern loading buffer: */
    if ( (error = memAlloc(32 * 64 * 6 + sizeof(s3mPattern),
        (void**) &s3mPatt)) != OK )
        PASSERR()

    /* Allocate memory for pattern conversion buffer: (maximum GMP pattern
       data size is 6 bytes per row per channel plus header) */
    if ( (error = memAlloc(32 * 64 * 6 + sizeof(gmpPattern),
        (void**) &convPatt)) != OK )
        PASSERR()

#ifdef DEBUGMESSAGES
    puts("Ready for conversion");
#endif
    CHECKHEAP

    /* Load and convert all patterns: */
    for ( i = 0; i < module->numPatts; i++ )
    {
        if ( (i < numS3MPatterns) && (pattPtrs[i] != 0) )
        {
#ifdef DEBUGMESSAGES
            puts("Seek");
#endif
            CHECKHEAP
            /* Seek to pattern beginning in file: */
            if ( (error = fileSeek(f, 16L * pattPtrs[i], fileSeekAbsolute))
                != OK )
                PASSERR()

#ifdef DEBUGMESSAGES
            puts("Read pattern length");
#endif
            CHECKHEAP
            /* Read pattern length from file: */
            if ( (error = fileRead(f, &s3mPatt->pattDataSize, sizeof(U16))) != OK )
                PASSERR()

#ifdef DEBUGMESSAGES
            printf("Patt.len: %i\n", s3mPatt->pattDataSize);
            puts("Read pattern data");
#endif
            CHECKHEAP
            /* Read pattern data from file: */
            if ( (error = fileRead(f, &s3mPatt->data[0], s3mPatt->pattDataSize)) != OK )
                PASSERR()
        }
        else
        {
            s3mPatt->pattDataSize = 0;
#ifdef DEBUGMESSAGES
            puts("Empty pattern");
#endif
        }
#ifdef DEBUGMESSAGES
        puts("Convert pattern");
#endif
        CHECKHEAP

        /* Convert the pattern data, checking the instruments used: */
        if ( (error = ConvertPattern(s3mPatt, convPatt, &convPattLen))
            != OK )
            PASSERR()

#if 0
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

#endif
        {
#ifdef DEBUGMESSAGES
            printf("Alloc mem: %i\n", convPattLen);
#endif
            CHECKHEAP
            /* Allocate memory for converted pattern data for current pattern
                in module: */
            if ( (error = memAlloc(convPattLen, (void**)&module->patterns[i]))
                != OK )
                PASSERR()


#ifdef DEBUGMESSAGES
            puts("Copy pattern");
#endif
            CHECKHEAP
            /* Copy the converted pattern data: */
            mMemCopy(module->patterns[i], convPatt, convPattLen);
        }
#ifdef DEBUGMESSAGES
        printf("Pattern %i, Conv.len: %i\n", i, convPattLen);
#endif
        CHECKHEAP
    }

    maxChan++;
    /* store number of channels */
    module->numChannels = ( maxChan < numChans ) ? maxChan : numChans;
#ifdef DEBUGMESSAGES
    printf("Num.channels: %i\n", module->numChannels);
#endif
    CHECKHEAP

    /* Deallocate pattern paragraph pointers: */
    if ( (error = memFree(pattPtrs)) != OK )
        PASSERR()
    pattPtrs = NULL;

    /* Deallocate pattern conversion buffer: */
    if ( (error = memFree(convPatt)) != OK )
        PASSERR()
    convPatt = NULL;

    /* Deallocate pattern loading buffer: */
    if ( (error = memFree(s3mPatt)) != OK )
        PASSERR()
    s3mPatt = NULL;

#ifdef DEBUGMESSAGES
    puts("Pattern conversion ready");
#endif
    CHECKHEAP

    /* If samples should be added to Sound Device, allocate memory for sample
       loading buffer: */
    if ( addSD )
    {
        if ( (error = memAlloc(maxSample, (void**) &smpBuf)) != OK )
            PASSERR()
    }

    if ( maxInstUsed > module->numInsts )
        module->numInsts = maxInstUsed;

#ifdef DEBUGMESSAGES
    printf("Max.inst. used: %i\n", maxInstUsed);
#endif
    CHECKHEAP

    /* Load all samples and convert sample and instrument data: */
    for ( i = 0; i < module->numInsts; i++ )
    {
        /* Seek to instrument header in file: */
        if ( (error = fileSeek(f, 16L * instPtrs[i], fileSeekAbsolute))
            != OK )
            PASSERR()

        /* Read instrument header from file: */
        if ( (error = fileRead(f, &s3mi, sizeof(s3mInstHdr))) != OK )
            PASSERR()

        /* Allocate memory for this instrument structure: (add space for one
           sample if the instrument is used) */
        if ( instUsed[i] )
        {
            if ( (error = memAlloc(sizeof(gmpInstrument) + sizeof(gmpSample),
                (void**) &module->instruments[i])) != OK )
                PASSERR()
        }
        else
        {
            if ( (error = memAlloc(sizeof(gmpInstrument),
                (void**) &module->instruments[i])) != OK )
                PASSERR()
        }

        /* Point inst to current instrument structure: */
        inst = module->instruments[i];

        /* Mark there are no sample for the instrument: */
        inst->numSamples = 0;

        /* Copy instrument name: */
        mMemCopy(&inst->name[0], &s3mi.iname[0], 28);
        inst->name[28] = 0;             /* force terminating '\0' */

        /* Mark the instrument has no sample number table for keyboard
           notes: */
        inst->noteSamples = NULL;

        /* Mark the instrument has no volume or panning envelopes: */
        inst->volEnvelope = NULL;
        inst->panEnvelope = NULL;

        /* Mark the instrument has no FT2 auto-vibrato: */
        inst->vibType = inst->vibSweep = inst->vibDepth = inst->vibRate = 0;

        /* Check if the instrument is used in the module: */
        if ( instUsed[i] )
        {
            /* The instrument is used - mark it used and point sample to its
               sample information: */
            inst->used = 1;
            inst->numSamples = 1;
            sample = &inst->samples[0];

            /* Mark there is no sample data and the sample has not been added
               to Sound Device: */
            sample->sample = NULL;
            sample->sdHandle = 0;

            /* Copy sample loop start and calculate loop end: */
            sample->loop1Start = s3mi.loopStart;
            sample->loop1End = s3mi.loopEnd;

            slength = s3mi.length;

            if ( ( s3mi.flags & 1 ) && ( s3mi.loopStart != s3mi.loopEnd ) )
            {
                /* Looping sample - set loop types and limit sample length
                   to loop end: */
                sample->loopMode = sdLoop1;
                sample->loop1Type = loopUnidir;
                if ( slength > sample->loop1End )
                    slength = sample->loop1End;
            }
            else
            {
                /* Sample not looping: */
                sample->loopMode = sdLoopNone;
                sample->loop1Type = loopNone;
            }

            /* Set sample length: */
            sample->sampleLength = slength;

            /* Copy sample default volume: */
            sample->volume = s3mi.volume;

            /* No finetune used: */
            sample->finetune = 0;

            /* Copy sample base tune: */
            sample->baseTune = s3mi.c2Rate;

            /* Set sample default panning position to middle: */
            sample->panning = panMiddle;

            /* Check if there is sample data for this sample: */
            if ( slength != 0 )
            {
                /* If sample data should not be added to Sound Device, allocate
                   memory for the sample data and point smpBuf there: */
                if ( !addSD )
                {
                    smpBuf = NULL;
                    if ( (error = memAlloc(slength, (void**)&smpBuf)) != OK )
                        PASSERR()
                    sample->sample = smpBuf;
                }
                else
                {
                    /* Sample is added to the Sound Device - sample data is not
                       available: */
                    sample->sample = NULL;
                }

                /* Seek to instrument in file: */
                if ( (error = fileSeek(f, 16L * s3mi.samplePtr, fileSeekAbsolute))
                    != OK )
                    PASSERR()

                /* There is sample data - load sample: */
                if ( (error = fileRead(f, smpBuf, slength)) != OK )
                    PASSERR()

                /* Set Sound Device sample type: */
                sdSmp.sampleType = smp8bit;
                sample->sampleType = smp8bit;

                /* Set Sound Device sample position in memory: */
                sdSmp.samplePos = sdSmpConv;

                /* Point Sound Device sample data to sample loading buffer: */
                sdSmp.sample = smpBuf;

                /* Point smpBuf to NULL if the sample is not added to Sound
                   Device to mark it should not be deallocated: */
                if ( !addSD )
                    smpBuf = NULL;
            }
            else
            {
                /* Mark there is no sample data: */
                sdSmp.sampleType = smpNone;
                sdSmp.samplePos = sdSmpNone;
                sdSmp.sample = NULL;
            }

            sdSmp.sampleLength = slength;
            sdSmp.loopMode = sample->loopMode;
            sdSmp.loop1Start = sample->loop1Start;
            sdSmp.loop1End = sample->loop1End;
            sdSmp.loop1Type = sample->loop1Type;


            /* Set up the rest of Sound Device sample structure so that the sample
               can be added to the Sound Device: */
            if ( addSD )
            {

                /* Add the sample to Sound Device and store the Sound Device
                   sample handle in sample->sdHandle: */
                if ( (error = gmpSD->AddSample(&sdSmp, 1, &sample->sdHandle))
                    != OK)
                    PASSERR()

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
        }
        else
        {
            /* Sample is not used - there is no sample data: */
            inst->used = 0;
            inst->numSamples = 0;
        }

#ifdef DEBUGMESSAGES
        printf("Inst: %i, Len: %i\n", i, slength);
#endif
        CHECKHEAP
    }

    /* Deallocate sample loading buffer if allocated: */
    if ( addSD )
    {
        if ( (error = memFree(smpBuf)) != OK )
            PASSERR()
    }
    smpBuf = NULL;

    /* Deallocate instrument paragraph pointers: */
    if ( (error = memFree(instPtrs)) != OK )
        PASSERR()
    instPtrs = NULL;

    /* Deallocate instrument use flags: */
    if ( (error = memFree(instUsed)) != OK )
        PASSERR()
    instUsed = NULL;

#ifdef DEBUGMESSAGES
    puts("Samples ready");
#endif
    CHECKHEAP

    /* Now we are finished loading. Close module file: */
    if ( (error = fileClose(f)) != OK)
        PASSERR()
    fileOpened = 0;

    /* Deallocate Screamtracker module header: */
    if ( (error = memFree(header)) != OK )
        PASSERR();

    /* Return module pointer in *module: */
    *_module = module;

#ifdef DEBUGMESSAGES
    puts("Load Ok");
#endif
    CHECKHEAP

    return OK;
}


/*
 * $Log: loads3m.c,v $
 * Revision 1.15  1997/01/25 15:23:16  pekangas
 * The file is now closed properly if loading terminates to an error
 *
 * Revision 1.14  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.13  1996/12/30 23:38:08  jpaana
 * Cleaned up LoadError
 *
 * Revision 1.12  1996/09/08 21:00:42  pekangas
 * Fixed Set Tempo -command
 *
 * Revision 1.11  1996/09/05 06:28:28  pekangas
 * Changed S8 command to SetPanning16 (was SetPanning) (thanks Zapper)
 *
 * Revision 1.10  1996/09/01 15:42:31  pekangas
 * Changed to use new style slides (no more signed infobytes)
 *
 * Revision 1.9  1996/08/06 19:18:48  pekangas
 * Fixed to produce legal gmpModules so that mod2gm works
 *
 * Revision 1.8  1996/08/02 19:46:10  pekangas
 * Kluged to skip all instruments above module->numInsts to prevent crashes
 *
 * Revision 1.7  1996/07/16 17:35:35  pekangas
 * Fixed song data conversion loop
 *
 * Revision 1.6  1996/07/13 20:19:32  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.5  1996/07/13 18:30:19  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.4  1996/06/14 16:23:28  pekangas
 * Removed heap checking to speed up loading
 *
 * Revision 1.3  1996/05/24 17:03:24  pekangas
 * Fixed to work with Watcom C again - using EMPTYARRAY
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Fixed to work with gcc
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/
