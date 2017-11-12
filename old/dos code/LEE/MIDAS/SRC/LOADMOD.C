/*      loadmod.c
 *
 * Generic Module Player Protracker Module loader
 *
 * $Id: loadmod.c,v 1.8 1997/01/25 15:23:16 pekangas Exp $
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

RCSID(const char *modload_rcsid = "$Id: loadmod.c,v 1.8 1997/01/25 15:23:16 pekangas Exp $";)


/* Macro for endianness-swap. DANGEROUS - references the argument x
   twice */
#define SWAP16(x) ( ((x << 8) & 0xFF00) | ( (x >> 8) & 0x00FF) )

/* Pass error code in variable "error" on, used in gmpLoadMOD(). */
#define PASSERR() { LoadError(); PASSERROR(ID_gmpLoadMOD) }


/****************************************************************************\
*       struct modInstHdr
*       -----------------
* Description:  Protracker module instrument header. Note that all 16-bit
*               fields are big-endian.
\****************************************************************************/

typedef struct
{
    char        iname[22];              /* instrument name */
    ushort      slength;                /* sample length */
    uchar       finetune;               /* sample finetune value */
    uchar       volume;                 /* sample default volume */
    ushort      loopStart;              /* sample loop start, in words */
    ushort      loopLength;             /* sample loop length, in words */
} modInstHdr;




/****************************************************************************\
*       struct modHeader
*       ----------------
* Description:  Protracker module file header
\****************************************************************************/

typedef struct
{
    char        songName[20];           /* song name */
    modInstHdr  instruments[31];        /* instrument headers */
    uchar       songLength;             /* song length */
    uchar       restart;                /* unused by Protracker, song restart
                                           position in some modules */
    uchar       songData[128];          /* pattern playing orders */
    char        sign[4];                /* module signature */
} modHeader;




/* Period table for Protracker octaves 0-5: */
static unsigned ptPeriods[6*12] = {
    1712,1616,1524,1440,1356,1280,1208,1140,1076,1016,960,907,
    856,808,762,720,678,640,604,570,538,508,480,453,
    428,404,381,360,339,320,302,285,269,254,240,226,
    214,202,190,180,170,160,151,143,135,127,120,113,
    107,101,95,90,85,80,75,71,67,63,60,56,
    53,50,47,45,42,40,37,35,33,31,30,28 };


/* Conversion table from Protracker command number to GMP ones: */
static uchar ptCommands[16] =
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

};

/* Conversion table from Protracker E-command numbers to GMP commands: */
static uchar ptECommands[16] =
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
static modHeader *header;               /* pointer to PT module header */
static uchar    *instUsed;              /* instrument used flags */
static int      extOctaves;             /* 1 if extended octaves are needed */
static uchar    *ptPatt;                /* pointer to PT pattern data */
static gmpPattern *convPatt;            /* pointer to converted pattern data*/
static uchar    *smpBuf;                /* sample loading buffer */
static unsigned numChans;               /* number of channels in module */





/****************************************************************************\
*
* Function:     int ConvertPattern(uchar *srcPatt, gmpPattern *destPatt,
*                   unsigned *convLen);
*
* Description:  Converts a pattern from Protracker to GMP internal format.
*               Also updates extOctaves and instUsed flags.
*
* Input:        uchar *srcPatt          pointer to pattern in PT format
*               gmpPattern *destPatt    pointer to destination GMP pattern
*               unsigned *convLen       pointer to converted pattern length
*
* Returns:      MIDAS error code. Converted pattern length (in bytes,
*               including header) is written to *convLen.
*
\****************************************************************************/

static int ConvertPattern(uchar *srcPatt, gmpPattern *destPatt,
    unsigned *convLen)
{
    uchar       *src = srcPatt;
    uchar       *dest = ((uchar*)destPatt) + sizeof(gmpPattern);
    unsigned    row, chan;
    unsigned    period, len;
    int         i;
    uchar       note, inst, command, infobyte, compInfo;
    int         legalCommand;

    for ( row = 0; row < 64; row++ )
    {
        for ( chan = 0; chan < numChans; chan++ )
        {
            /* Get period number from pattern data: */
            period = ((unsigned) (*(src) & 0x0F) << 8) | ((unsigned)
                *(src+1));

            /* Get instrument number from pattern data: */
            inst = ((*src) & 0xF0) | (*(src+2) >> 4);

            /* Get command number from pattern data: */
            command = *(src+2) & 0x0F;

            /* Get command infobyte from pattern data: */
            infobyte = *(src+3);

            /* Point src to next channel pattern data: */
            src += 4;

            /* Set compression info to zero to mark currently there is no
               new data: */
            compInfo = 0;

            /* Check if there is a new note: */
            note = 0;
            if ( period != 0 )
            {
                /* Find the that corresponds to current period value: */
                for ( i = 0; i < 6*12; i++ )
                {
                    if ( period >= ptPeriods[i] )
                    {
                        note = i;
                        break;
                    }
                }

                /* If we reached the end of period table, the pattern data
                   is invalid: */
                if ( i == (6*12) )
                    return errInvalidPatt;

                /* Convert note number to GMP internal format: */
                note = ((note / 12) << 4) | (note % 12);

                /* Check if extended octaves should be enabled: */
                if ( (note < 0x10) || (note > 0x3F) )
                    extOctaves = 1;

                /* Mark that there is a new note: */
                compInfo |= 32;
            }

            /* Check if there is a new instrument: */
            if ( inst != 0 )
            {
                /* Check that the instrument number is legal: */
                if ( inst > 31 )
                    return errInvalidPatt;

                /* Mark instrument used: */
                instUsed[inst-1] = 1;

                /* Mark that there is a new instrument: */
                compInfo |= 32;
            }

            /* Check if there is a command: */
            if ( (command != 0) || (infobyte != 0) )
            {
                /* Flag that we have a legal command: */
                legalCommand = 1;

                switch ( command )
                {
                    case 0x08:
                        /* Command 8 - possibly Set Panning. Convert to
                           "Set Panning" -command if the infobyte is a legal
                           DMP-compatible panning value: */
                        if ( (infobyte <= 0x80) || (infobyte == 0xA4) )
                        {
                            command = gmpcSetPanning;
                        }
                        else
                        {
                            legalCommand = 0;
                        }
                        break;

                    case 0x0E:
                        /* Command E - convert command number: */
                        command = ptECommands[infobyte >> 4];
                        infobyte = infobyte & 0x0F;
                        break;

                    case 0x0F:
                        /* Protracker command 0Fh - set speed or set tempo.
                           If infobyte > 32, the BPM tempo is changed: */
                        if ( infobyte > 32 )
                            command = gmpcSetTempo;
                        else
                            command = gmpcSetSpeed;
                        break;

                    default:
                        /* Convert command to GMP command number: */
                        command = ptCommands[command];
                        break;
                }

                /* Mark that there is a command: */
                if ( legalCommand )
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
                    /* Write note number if there is a new note, otherwise
                       write 0xFF as note: */
                    if ( period != 0 )
                        *(dest++) = note;
                    else
                        *(dest++) = 0xFF;

                    /* Write instrument number if there is a new instrument,
                       otherwise write 0xFF as instrument: */
                    if ( inst != 0 )
                        *(dest++) = inst-1;
                    else
                        *(dest++) = 0xFF;
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

        /* Write row end marker: */
        *(dest++) = 0;
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
* Function:     int gmpLoadMOD(char *fileName, int addSD, mpModule **module)
*
* Description:  Loads a Protracker module to memory in Generic Module Player
*               module format
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

int CALLING gmpLoadMOD(char *fileName, int addSD, int
    (CALLING *SampleCallback)(sdSample *sdsmp, gmpSample *gmpsmp),
    gmpModule **_module)
{
    int             error;              /* MIDAS error code */
    modInstHdr      *modi;
    gmpInstrument   *inst;
    unsigned        i;
    unsigned        numPatts, n;
    ulong           maxSample;
    static unsigned convPattLen;
    static long     filePos;
    unsigned        slength, loopStart, loopLength;
    gmpSample       *sample;
    static sdSample sdSmp;
#ifndef NOEMS
    uchar           *patt;
#endif


    /* point buffers to NULL and set fileOpened to 0 so that LoadError()
       can be called at any point: */
    fileOpened = 0;
    module = NULL;
    header = NULL;
    instUsed = NULL;
    ptPatt = NULL;
    convPatt = NULL;
    smpBuf = NULL;

    /* Allocate memory for Protracker module header: */
    if ( (error = memAlloc(sizeof(modHeader), (void**) &header)) != OK )
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

    /* read Protracker module header: */
    if ( (error = fileRead(f, header, sizeof(modHeader))) != OK )
        PASSERR()

    numChans = 0;

    /* Check the module signature to determine number of channels: */
    if ( mMemEqual(&header->sign[0], "M.K.", 4) )
        numChans = 4;
    if ( mMemEqual(&header->sign[0], "M!K!", 4) )
        numChans = 4;
    if ( mMemEqual(&header->sign[0], "FLT4", 4) )
        numChans = 4;
    if ( mMemEqual(&header->sign[0], "OCTA", 4) )
        numChans = 8;

    if ( mMemEqual(&header->sign[1], "CHN", 3) )
    {
        /* xCHN, where x is the number of channels */
        numChans = header->sign[0] - '0';
    }

    if ( mMemEqual(&header->sign[2], "CH", 2) )
    {
        /* xxCH, where xx is the number of channels */
        numChans = (header->sign[0] - '0') * 10 + (header->sign[1] - '0');
    }

    if ( mMemEqual(&header->sign[0], "TDZ", 3) )
    {
        /* TDZx, where x is the number of channels */
        numChans = header->sign[3] - '0';
    }


    /* If number of channels is undetermined, the signature is invalid. */
    if ( numChans == 0 )
    {
        ERROR(errInvalidModule, ID_gmpLoadMOD);
        LoadError();
        return errInvalidModule;
    }

    module->numChannels = numChans;         /* store number of channels */

    /* Copy song name: */
    mMemCopy(&module->name[0], &header->songName[0], 20);
    module->name[20] = 0;                   /* force terminating '\0' */

    module->songLength = header->songLength;    /* copy song length */
    module->numInsts = 31;                  /* set number of instruments */
    module->playMode = gmpPT;               /* set Protracker playing mode */
    module->masterVolume = 64;              /* maximum master volume */
    module->speed = 6;                      /* initial speed 6 */
    module->tempo = 125;                    /* initial tempo 125 BPM */
    module->playFlags.extOctaves = 0;       /* extended octaves not needed */

    /* Check if the header contains a valid restart position, and if it does,
       use it: */
    if ( (header->restart != 127) && (header->restart < header->songLength) )
        module->restart = header->restart;
    else
        module->restart = 0;

    /* Allocate memory for channel initial panning positions: */
    if ( (error = memAlloc(32 * sizeof(int), (void**) &module->panning))
        != OK )
        PASSERR()

    /* Set up initial panning positions: (LRRL LRRL LRRL...) */
    for ( i = 0; i < numChans; i++ )
    {
        if ( ((i & 3) == 0) || ((i & 3) == 3) )
            module->panning[i] = 0x00;
        else
            module->panning[i] = 0x80;
    }

    /* Find the number of patterns in file by searching through the song data
       to find the highest pattern number: */
    numPatts = 0;
    for ( i = 0; i < 128; i++ )
    {
        if ( header->songData[i] > numPatts )
            numPatts = header->songData[i];
    }
    numPatts++;

    module->numPatts = numPatts;    /* store number of patterns */

    /* Allocate memory for song data: */
    if ( (error = memAlloc(sizeof(ushort) * module->songLength,
        (void**) &module->songData)) != OK )
        PASSERR()

    /* Copy song data: */
    for ( i = 0; i < module->songLength; i++ )
        module->songData[i] = header->songData[i];

    /* Allocate memory for pattern pointers: */
    if ( (error = memAlloc(sizeof(gmpPattern*) * module->numPatts,
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
    if ( (error = memAlloc(31, (void**)&instUsed)) != OK )
        PASSERR()

    /* Mark all instruments unused: */
    for ( i = 0; i < module->numInsts; i++ )
        instUsed[i] = 0;

    /* Now convert all 16-bit fields in the Protracker module instrument
       headers to little-endian and find maximum sample length: *!!* */
    maxSample = 0;
    for ( i = 0; i < module->numInsts; i++ )
    {
        modi = &header->instruments[i];
        modi->slength = SWAP16(modi->slength);
        if ( maxSample < 2L * (ulong) modi->slength )
            maxSample = 2L * (ulong) modi->slength;
        modi->loopStart = SWAP16(modi->loopStart);
        modi->loopLength = SWAP16(modi->loopLength);
    }

    /* Check that the maximum sample length is below the Sound Device limit:*/
    if ( maxSample > SMPMAX )
    {
        ERROR(errInvalidInst, ID_gmpLoadMOD);
        LoadError();
        return errInvalidInst;
    }

    /* Allocate memory for pattern loading buffer: */
    if ( (error = memAlloc(numChans * 256, (void**) &ptPatt)) != OK )
        PASSERR()

    /* Allocate memory for pattern conversion buffer: (maximum GMP pattern
       data size is 6 bytes per row per channel plus header) */
    if ( (error = memAlloc(numChans * 64 * 6 + sizeof(gmpPattern),
        (void**) &convPatt)) != OK )
        PASSERR()

    /* Load and convert all patterns: */
    for ( i = 0; i < numPatts; i++ )
    {
        /* Read pattern data: */
        if ( (error = fileRead(f, ptPatt, 256 * numChans)) != OK )
            PASSERR()

        /* Convert the pattern data, checking the instruments used: */
        if ( (error = ConvertPattern(ptPatt, convPatt, &convPattLen))
            != OK )
            PASSERR()

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
    }

    /* Deallocate pattern conversion buffer: */
    if ( (error = memFree(convPatt)) != OK )
        PASSERR()
    convPatt = NULL;

    /* Deallocate pattern loading buffer: */
    if ( (error = memFree(ptPatt)) != OK )
        PASSERR()
    ptPatt = NULL;

    /* If samples should be added to Sound Device, allocate memory for sample
       loading buffer: */
    if ( addSD )
    {
        if ( (error = memAlloc(maxSample, (void**) &smpBuf)) != OK )
            PASSERR()
    }

    /* Get current file position: */
    if ( (error = fileGetPosition(f, &filePos)) != OK )
        PASSERR()

    /* Load all samples and convert sample and instrument data: */
    for ( i = 0; i < module->numInsts; i++ )
    {
        /* Seek to the beginning of current sample: */
        if ( (error = fileSeek(f, filePos, fileSeekAbsolute)) != OK )
            PASSERR()

        /* Point modi to current Protracker module instrument: */
        modi = &header->instruments[i];

        /* Convert sample length, loop start and loop end to bytes: */
        slength = 2 * ((unsigned) modi->slength);
        loopStart = 2 * ((unsigned) modi->loopStart);
        loopLength = 2 * ((unsigned) modi->loopLength);

        /* Set file position to the beginning of next sample: */
        filePos += (ulong) slength;

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
        mMemCopy(&inst->name[0], &modi->iname[0], 22);
        inst->name[22] = 0;             /* force terminating '\0' */

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
            sample->loop1Start = loopStart;
            sample->loop1End = loopStart + loopLength;

            /* If sample loop end is past byte 2, the sample is looping:
               (Protracker uses loop start 0, length 2 for no loop,
               Fasttracker 1 uses start 0, length 0) */
            if ( sample->loop1End > 2 )
            {
                /* Looping sample - set loop types and limit sample length
                   to loop end: */
                sample->loopMode = sdLoopAmiga;
                sample->loop1Type = loopUnidir;
                if ( slength > sample->loop1End )
                    slength = sample->loop1End;
                sample->sampleLength = slength;
            }
            else
            {
                /* Sample not looping: */
                sample->loopMode = sdLoopAmigaNone;
                sample->loop1Type = loopNone;
                sample->sampleLength = slength;
            }

            /* Copy sample default volume: */
            sample->volume = modi->volume;

            /* Copy sample finetune value: */
            sample->finetune = modi->finetune;

            /* Set sample base tune to 0: */
            sample->baseTune = 0;

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

                /* There is sample data - load sample: */
                if ( (error = fileRead(f, smpBuf, slength)) != OK )
                    PASSERR()

                /* Convert sample data from signed to unsigned: */
                for ( n = 0; n < slength; n++ )
                    smpBuf[n] ^= 0x80;

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
                sample->sampleType = smpNone;
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
    }

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

    /* Set extended octaves needed flag in module header if notes in extended
       octaves were found: */
    if ( extOctaves )
        module->playFlags.extOctaves = 1;

    /* Now we are finished loading. Close module file: */
    if ( (error = fileClose(f)) != OK)
        PASSERR()
    fileOpened = 0;

    /* Deallocate Protracker module header: */
    if ( (error = memFree(header)) != OK )
        PASSERR();

    /* Return module pointer in *module: */
    *_module = module;

    return OK;
}


/*
 * $Log: loadmod.c,v $
 * Revision 1.8  1997/01/25 15:23:16  pekangas
 * The file is now closed properly if loading terminates to an error
 *
 * Revision 1.7  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.6  1996/12/30 23:38:23  jpaana
 * Cleaned up LoadError
 *
 * Revision 1.5  1996/09/01 15:42:03  pekangas
 * Changed to use new style slides
 *
 * Revision 1.4  1996/07/13 20:11:19  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.3  1996/07/13 18:23:27  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Fixed to work with gcc
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/
