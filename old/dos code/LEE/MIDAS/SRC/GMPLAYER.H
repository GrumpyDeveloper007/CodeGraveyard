/*      gmplayer.h
 *
 * Generic Module Player
 *
 * $Id: gmplayer.h,v 1.9 1996/10/06 16:48:10 pekangas Exp $
 *
 * Copyright 1996 Petteri Kangaslampi and Jarno Paananen
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __GMPLAYER_H
#define __GMPLAYER_H


#define MAXSONGS 16                     /* maximum number of songs played
                                           simultaneously */



/****************************************************************************\
*       enum gmpCommands
*       ----------------
* Description:  Command numbers for module commands
\****************************************************************************/

enum gmpCommands
{
    gmpcNone = 0,                       /* no command */
    gmpcArpeggio = 1,                   /* arpeggio */
    gmpcSlideUp = 2,                    /* period slide up */
    gmpcSlideDown = 3,                  /* period slide down */
    gmpcTonePortamento = 4,             /* tone portamento */
    gmpcVibrato = 5,                    /* vibrato */
    gmpcTPortVSlide = 6,                /* tone portamento + volume slide */
    gmpcVibVSlide = 7,                  /* vibrato + volume slide */
    gmpcTremolo = 8,                    /* tremolo */
    gmpcSetPanning = 9,                 /* set panning (PT cmd 8) */
    gmpcSampleOffset = 10,              /* set sample offset */
    gmpcVolumeSlide = 11,               /* volume slide */
    gmpcPositionJump = 12,              /* position jump */
    gmpcSetVolume = 13,                 /* set volume */
    gmpcPatternBreak = 14,              /* pattern break (to a row) */
    gmpcSetSpeed = 15,                  /* set speed */
    gmpcSetTempo = 16,                  /* set tempo in BPM */
    gmpcFineSlideUp = 17,               /* fine period slide up */
    gmpcFineSlideDown = 18,             /* fine period slide down */
    gmpcPatternLoop = 19,               /* pattern loop set/loop */
    gmpcSetPanning16 = 20,              /* set 16-point panning value */
    gmpcPTRetrig = 21,                  /* Protracker-style retrig note */
    gmpcFineVolSlideUp = 22,            /* fine volume slide up */
    gmpcFineVolSlideDown = 23,          /* fine volume slide down */
    gmpcNoteCut = 24,                   /* note cut */
    gmpcNoteDelay = 25,                 /* note delay */
    gmpcPatternDelay = 26,              /* pattern delay */
    gmpcSetMVolume = 27,                /* set master volume */
    gmpcMVolSlide = 28,                 /* master volume slide */
    gmpcS3MRetrig = 29,                 /* S3M retrig note */
    gmpcMusicSync = 30,                 /* music synchronization command */
    gmpcExtraFineSlideUp = 31,          /* extra fine period slide up */
    gmpcExtraFineSlideDown = 32,        /* extra fine period slide down */
    gmpcPanSlide = 33,                  /* panning slide */
    gmpNumCommands                      /* total number of commands */
/* Hack for Watcom C 10.0: */
#define GMP_NUM_COMMANDS 34
};



/****************************************************************************\
*       enum gmpPlayModes
*       -----------------
* Description:  Generic Module Player playing modes - affects command
*               implementation and other tracker compatibility issues
\****************************************************************************/

enum gmpPlayModes
{
    gmpPT = 1,                          /* Protracker compatibility mode */
    gmpST3,                             /* Scream Tracker 3 mode */
    gmpFT2                              /* Fast Tracker 2 mode */
};




/****************************************************************************\
*       struct gmpSample
*       ----------------
* Description:  Generic Module Player sample in memory
\****************************************************************************/

typedef struct
{
    char        name[32];               /* sample name */
    unsigned    sdHandle;               /* Sound Device sample handle */
    uchar       *sample;                /* sample data pointer, NULL if sample
                                           data only in SD memory */
    unsigned    sampleLength;           /* sample length */
    uchar       sampleType;             /* sample type, see enum
                                           sdSampleType */
    uchar       loopMode;               /* sample looping mode, see enum
                                           sdLoopMode */
    uchar       loop1Type;              /* first loop type, see enum
                                           sdLoopType */
    uchar       loop2Type;              /* second loop type, see enum
                                           sdLoopType */
    unsigned    loop1Start;             /* first loop start */
    unsigned    loop1End;               /* first loop end */
    unsigned    loop2Start;             /* second loop start */
    unsigned    loop2End;               /* second loop end */
    unsigned    volume;                 /* sample volume */
    int         panning;                /* sample panning position */
    long        baseTune;               /* base tune */
    int         finetune;               /* fine tuning value */
    ulong       fileOffset;             /* sample start offset in module
                                           file */
} gmpSample;




/****************************************************************************\
*       struct gmpEnvelope
*       ------------------
* Description:  Envelope information for one instrument envelope (volume or
*               panning)
\****************************************************************************/

typedef struct
{
    uchar       numPoints;              /* number of points in envelope */
    signed char sustain;                /* sustain point number, -1 if no
                                           sustain is used */
    signed char loopStart;              /* envelope loop start point number,
                                           -1 if no loop */
    signed char loopEnd;                /* envelope loop end point number, -1
                                           if no loop */
    signed short points[24];            /* envelope points: a maximum of 12
                                           points, in (X,Y) coordinate
                                           pairs */
} gmpEnvelope;




/****************************************************************************\
*       struct gmpInstrument
*       --------------------
* Description:  Generic Module Player instrument in memory
\****************************************************************************/

typedef struct
{
    char        name[32];               /* instrument name */
    unsigned    numSamples;             /* number of samples */
    uchar       *noteSamples;           /* sample numbers for all keyboard
                                           notes, NULL if sample 0 is used
                                           for all (always 96 bytes) */
    gmpEnvelope *volEnvelope;           /* pointer to volume envelope info or
                                           NULL if volume envelope is not
                                           used */
    gmpEnvelope *panEnvelope;           /* pointer to panning envelope info or
                                           NULL if panning envelope is not
                                           used */
    int         volFadeout;             /* FT2 volume fade-out speed */
    uchar       vibType;                /* FT2 auto-vibrato type */
    uchar       vibSweep;               /* FT2 auto-vibrato sweep value */
    uchar       vibDepth;               /* FT2 auto-vibrato depth */
    uchar       vibRate;                /* FT2 auto-vibrato rate */
    int         used;                   /* 1 if instrument is used, 0 if not.
                                           Unused instruments are not loaded
                                           or added to Sound Device */
    gmpSample   samples[EMPTYARRAY];    /* samples */
} gmpInstrument;




/****************************************************************************\
*       struct gmpPattern
*       -----------------
* Description:  One Generic Module Player pattern in memory
\****************************************************************************/

typedef struct
{
    unsigned    length;                 /* pattern size in bytes, INCLUDING
                                           this header */
    unsigned    rows;                   /* number of rows in pattern */
    uchar       data[EMPTYARRAY];       /* pattern data */

    /* The pattern data is built as follows:
       The first byte is compression information byte. Bits 0-4 form the
       channel number (0-31) and bits 5-7 compression info:
                bit 5   if 1, note and instrument number bytes follow
                bit 6   if 1, volume column byte follows
                bit 7   if 1, command and infobyte bytes follow
       If the compression infobyte is 0, it marks the end of the current
       row. Possible other data follows the compression information byte in
       the following order: note, instrument, volume, command, infobyte.

       In note numbers the upper nybble is the octave number, and lower
       nybble note number in octave. So, for example, D#2 becomes 0x23.
       0xFE as a note number represents a release note, and 0xFF no new
       note as does 0xFF as an instrument number. Valid instrument numbers
       range from 0 to 254 inclusive.

       This isn't quite as efficient as it could be, but is very simple and
       fast to process, and compresses most pattern data very efficiently
       anyway.
    */

} gmpPattern;




/****************************************************************************\
*       struct gmpModule
*       ----------------
* Description:  Generic Module Player module in memory
\****************************************************************************/

typedef struct
{
    uchar       name[32];               /* module name */
    int         playMode;               /* module playing mode - see enum
                                           gmpPlayMode */
    unsigned    songLength;             /* song length */
    unsigned    restart;                /* song restart position */
    unsigned    numInsts;               /* number of instruments */
    unsigned    numPatts;               /* number of patterns */
    uchar       numChannels;            /* number of channels in module */
    uchar       masterVolume;           /* initial master volume */
    uchar       speed;                  /* initial speed */
    uchar       tempo;                  /* initial BPM tempo */
    int         *panning;               /* initial channel panning
                                           positions */
    ushort      *songData;              /* song data - pattern playing
                                           order */
    gmpInstrument **instruments;        /* instrument data */
    gmpPattern  **patterns;             /* pattern data */
    struct  /* Format-specific playing information flags: */
    {
        int     ptLimits : 1;           /* ST3: Protracker limits */
        int     fastVolSlides : 1;      /* ST3: Fast volume slides */
        int     extOctaves : 1;         /* PT: Extended octaves needed */
        int     linFreqTable : 1;       /* FT2: Linear frequency table used */
    } playFlags;
} gmpModule;




/****************************************************************************\
*       struct gmpChannel
*       -----------------
* Description:  Generic Module Player internal channel structure
\****************************************************************************/

typedef struct
{
    unsigned    period;                 /* current playing period */
    int         instrument;             /* current playing instrument, -1 if
                                           no instrument has been set */
    int         newInstrument;          /* new instrument number */
    unsigned    tpDest;                 /* tone portamento destination */
    unsigned    startOffset;            /* next note start offset */

    uchar       sample;                 /* current playing sample, 0xFF if
                                           there is no sample */
    uchar       sdChannel;              /* Sound Device channel number */
    uchar       volColumn;              /* volume column value */
    uchar       note;                   /* current note number, 0xFF if there
                                           is no note */

    int         oldInfo;                /* previous non-zero info byte */

    uchar       oldInfobytes[gmpNumCommands];   /* Old infobytes for all
                                                   commands */
/* Align structure: */
#if (GMP_NUM_COMMANDS % 4)
    uchar       oldInfoFiller[4 - (GMP_NUM_COMMANDS % 4)];
#endif

    uchar       volume;                 /* current volume */
    uchar       command;                /* current command number */
    uchar       infobyte;               /* current command infobyte */
    uchar       tpSpeed;                /* tone portamento speed */

    uchar       realVolume;             /* sound device volume (for envelopes) */
    uchar       volSustained;           /* volume envelope sustained */
    uchar       panSustained;           /* panning envelope sustained */

    uchar       fill;

    int         panning;                /* current panning */

    int         volEnvX;                /* volume envelope X-position */
    int         panEnvX;                /* panning envelope X-position */

    long        fadeOut;                /* fade out value */

    uchar       keyOff;                 /* there has been a key off -note */
    uchar       retrigCount;            /* note retrig counter */
    uchar       trueVolume;             /* ;) */
    uchar       prevNote;               /* previous real note value (the one
                                           that might be playing), 0xFF if
                                           no note has been played */

    uchar       vibSpeed;               /* vibrato speed */
    uchar       vibDepth;               /* vibrato depth */
    uchar       vibPos;                 /* vibrato position */
    uchar       smpOffset;              /* sample offset infobyte */

    int         realPeriod;             /* final period value */
    int         truePeriod;             /* final final period value */

    int         autoVibDepth;           /* auto vibrato depth */
    uchar       autoVibPos;             /* auto vibrato position */

    uchar       loopRow;                /* pattern loop start row (PT mode) */
    uchar       loopCount;              /* pattern loop count (PT mode) */
    uchar       volSlideInfobyte;       /* volume slide old infobyte */

    struct  /* Channel status flag bits: */
    {
        int     newNote : 1;            /* there is a new note number */
        int     newVolume : 1;          /* there is a new volume column
                                           value */
        int     newInst : 1;            /* there is a new instrument number */
        int     command : 1;            /* there is a valid command */
        int     noteDelay : 1;          /* note delay is active */
#ifdef __16__
        int     fillerb : 11;           /* make sure all word fields really */
#else                                   /* do get aligned to word boundaries*/
        int     fillerb : 27;           /* (either 32 or 16 bits) */
#endif
    } status;
} gmpChannel;




/****************************************************************************\
*       struct gmpInformation
*       ---------------------
* Description:  Generic Module Player information structure, used by
*               gmpGetInformation().
\****************************************************************************/

typedef struct
{
    unsigned    position;               /* current playing position */
    unsigned    pattern;                /* current pattern number */
    unsigned    row;                    /* current row in pattern */
    unsigned    tempo;                  /* current tempo in BPM */
    unsigned    speed;                  /* current playing speed */
    int         syncInfo;               /* latest music synchronization
                                           command infobyte or -1 if no
                                           synchronization commands yet */
    gmpChannel  *channels;              /* pointer to channel information
                                           structures. DO NOT MODIFY these! */
} gmpInformation;




/****************************************************************************\
*       struct gmpPlayStatus
*       --------------------
* Description:  Generic Module Player internal playing status structure. Used
*               to enable playing several songs at the same time.
\****************************************************************************/

typedef struct
{
    unsigned    handleNum;              /* playing handle number for this
                                           status struct in GMP internal
                                           table */
    gmpModule   *module;                /* currently playing module */
    uchar       *playPtr;               /* pointer to current pattern data
                                           playing position */
    unsigned    position;               /* current song position */
    unsigned    pattern;                /* current pattern number */
    unsigned    row;                    /* current pattern row number */
    unsigned    songEnd;                /* song end position */
    unsigned    restartPos;             /* song restart position */
    unsigned    tempo;                  /* current tempo in BPM */
    unsigned    speed;                  /* current playing speed */
    unsigned    playCount;              /* playing counter - pattern data is
                                           processed when playCount >= speed
                                         */
    unsigned    pattDelayCount;         /* pattern delay counter */
    unsigned    numChannels;            /* number of channels to be played */
    unsigned    perLimitUp;             /* upper period limit for playing */
    unsigned    perLimitLow;            /* lower period limit for playing */
    unsigned    perMultiplier;          /* multiplier for period values */
    unsigned    volLimit;               /* upper volume limit */

    uchar       loopRow;                /* pattern loop start row */
    uchar       loopCount;              /* pattern loop count */
    uchar       masterVolume;           /* master volume */
    uchar       filler;

    gmpChannel  *channels;              /* GMP channel structures */
    gmpInformation *information;        /* GMP information structure */
    void (CALLING *SyncCallback)(unsigned syncNum, unsigned position,
        unsigned row);                  /* music synchronization callback
                                           function */
    int         syncInfo;               /* latest music synchronization
                                           command infobyte or -1 if no
                                           synchronization commands yet */
} gmpPlayStatus;




/****************************************************************************\
*       typedef gmpPlayHandle
*       ---------------------
* Description:  Generic Module Player playing handle
\****************************************************************************/

typedef gmpPlayStatus* gmpPlayHandle;




#ifdef __cplusplus
extern "C" {
#endif



/****************************************************************************\
*
* Function:     int gmpInit(SoundDevice *SD);
*
* Description:  Initializes Generic Module Player
*
* Input:        SoundDevice *SD         Pointer to the Sound Device that will
*                                       be used for playing the music
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING gmpInit(SoundDevice *SD);




/****************************************************************************\
*
* Function:     int gmpClose(void);
*
* Description:  Uninitializes Generic Module Player
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING gmpClose(void);



/****************************************************************************\
*
* Function:     int gmpSetUpdRateFunct(int (*SetUpdRate)(unsigned updRate));
*
* Description:  Changes the function that will be used to change the playing
*               update rate. Every time song tempo changes, SetUpdRate()
*               will be called with the new player tick rate (in 100*Hz).
*
* Input:        int (*SetUpdRate)(unsigned updRate)   Pointer to updating rate
*                                                     changing function.
*
* Returns:      MIDAS error code
*
* Notes:        SetUpdRate usually points to tmrSetUpdRate(). GMPlayer
*               automatically sets the correct updating rate to the Sound
*               Device used.
*
\****************************************************************************/

int CALLING gmpSetUpdRateFunct(int (CALLING *_SetUpdRate)(unsigned updRate));




/****************************************************************************\
*
* Function:     int gmpPlaySong(gmpModule *module, int startPos, int endPos,
*                   int restartPos, int numChannels, unsigned *sdChannels,
*                   gmpPlayHandle *playHandle)
*
* Description:  Starts playing a song from a module
*
* Input:        gmpModule *module       pointer to module to be played
*               int startPos            song start position
*               int endPos              song end position
*               int restartPos          song restart position
*               int numChannels         number of channels to be played
*               unsigned *sdChannels    pointer to an array of Sound Device
*                                       channel numbers for all channels that
*                                       are required for playing
*               gmpPlayHandle *playHandle   pointer to GMP playing handle
*
* Returns:      MIDAS error code. Playing handle for this song is written to
*               *playHandle.
*
* Notes:        To play the whole module, set startPos, endPos, restartPos and
*               numChannels to -1.
*
\****************************************************************************/

int CALLING gmpPlaySong(gmpModule *module, int startPos, int endPos,
    int restartPos, int numChannels, unsigned *sdChannels,
    gmpPlayHandle *playHandle);




/****************************************************************************\
*
* Function:     int gmpStopSong(gmpPlayHandle playHandle)
*
* Description:  Stops playing a song
*
* Input:        gmpPlayHandle playHandle   playing handle returned by
*                                          gmpPlaySong().
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING gmpStopSong(gmpPlayHandle playHandle);




/****************************************************************************\
*
* Function:     int gmpPlay(void)
*
* Description:  Plays music for one song tick.
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING gmpPlay(void);




/****************************************************************************\
*
* Function:     int gmpFreeModule(gmpModule *module)
*
* Description:  Deallocates a module structure allocated by a module loader
*
* Input:        gmpModule *module       module to be deallocated
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING gmpFreeModule(gmpModule *module);




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
    gmpModule **_module);




/****************************************************************************\
*
* Function:     int gmpGetInformation(gmpPlayHandle playHandle,
*                   gmpInformation **information);
*
* Description:  Reads current playing status on a playing handle
*
* Input:        gmpPlayHandle playHandle        playing handle
*               gmpInformation **information    pointer to pointer to
*                                               information structure
*
* Returns:      MIDAS error code. Pointer to GMP information structure filled
*               is written to *information.
*
\****************************************************************************/

int CALLING gmpGetInformation(gmpPlayHandle playHandle,
    gmpInformation **information);




/****************************************************************************\
*
* Function:     int gmpSetTempo(unsigned tempo)
*
* Description:  Changes current playing tempo. GMP internal use only. Updates
*               Sound Device and UpdRateFunct() update rates as necessary.
*
* Input:        unsigned tempo          new tempo in beats per minute
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int gmpSetTempo(unsigned tempo);




/****************************************************************************\
*
* Function:     int gmpNotePeriod(unsigned note, unsigned *period)
*
* Description:  Converts a note number to a period value (both depend on
*               current playing mode). Uses *gmpChan and *gmpPlayModule to
*               get sample tuning values. GMP internal.
*
* Input:        unsigned note           note number
*               unsigned *period        pointer to period value
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpNotePeriod(unsigned note, unsigned *period);




/****************************************************************************\
*
* Function:     int gmpPlayNote(unsigned period)
*
* Description:  Starts playing a new note on channel *gmpChan with period
*               value period. GMP internal.
*
* Input:        unsigned period         period value for new note
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpPlayNote(unsigned period);




/****************************************************************************\
*
* Function:     int gmpPeriodRate(unsigned period, ulong *rate)
*
* Description:  Converts a period value to sampling rate, depending on current
*               playing mode. GMP internal.
*
* Input:        unsigned period         period number
*               ulong *rate             pointer to sampling rate
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int gmpPeriodRate(unsigned period, ulong *rate);




/****************************************************************************\
*
* Function:     int gmpSetPeriod(unsigned period)
*
* Description:  Sets the playing period on current channel. Updates the
*               value in *gmpChan and sets it to Sound Device, taking
*               current period limits into account.
*
* Input:        unsigned period         new period value
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpSetPeriod(unsigned period);




/****************************************************************************\
*
* Function:     int gmpChangePeriod(unsigned period)
*
* Description:  Changes the playing period on current channel. Sets the new
*               value to Sound Device, but does NOT update channel structure.
*
* Input:        unsigned period         new period value
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpChangePeriod(unsigned period);




/****************************************************************************\
*
* Function:     int gmpSetVolume(int volume)
*
* Description:  Sets the playing volume on current channel. Sets the volume
*               to Sound Device and updates the channel structure, taking
*               current volume limits into account
*
* Input:        int volume              new playing volume (signed to allow
*                                       easier limit checking)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpSetVolume(int volume);




/****************************************************************************\
*
* Function:     int gmpChangeVolume(int volume)
*
* Description:  Changes the playing volume on current channel. Sets the
*               volume to taking current volume limits into account, but
*               does NOT update channel structures.
*
* Input:        int volume              new playing volume (signed to allow
*                                       easier limit checking)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpChangeVolume(int volume);


/****************************************************************************\
*
* Function:     int gmpSetPanning(int panning)
*
* Description:  Sets the panning of current channel. Sets the panning
*               to Sound Device and updates the channel structure, taking
*               current panning limits into account
*
* Input:        int panning             new panning
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpSetPanning(int panning);


/****************************************************************************\
*
* Function:     int gmpNewNote(void)
*
* Description:  Plays the new note on the current channel
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpNewNote(void);




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
    gmpModule **_module);




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
    gmpModule **_module);




/****************************************************************************\
*
* Function:     int gmpSetVolCommand(void)
*
* Description:  Runs tick-0 volume column command for current channel (FT2)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpSetVolCommand(void);




/****************************************************************************\
*
* Function:     int gmpRunVolCommand(void)
*
* Description:  Runs continuous volume column command for current channel
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpRunVolCommand(void);




/****************************************************************************\
*
* Function:     int gmpSetSyncCallback(void (CALLING *musicSync)(unsigned syncNum, unsigned position, unsigned row))
*
* Description:  Sets music synchronization callback function. This function
*               will be called when the music synchronization command (command
*               W in FT2 and ST3) is encountered in the music. The function
*               receives as arguments the synchronization command infobyte,
*               current playing position position and current row number.
*               Note that the function will be called INSIDE THE PLAYER
*               TIMER INTERRUPT and thus SS != DS !!!
*
* Input:        gmpPlayHandle playHandle    playing handle
*               void (CALLING *SyncCallback)()  Pointer to music
*                                       synchronization callback function.
*                                       Set to NULL to disable callback
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING gmpSetSyncCallback(gmpPlayHandle playHandle,
    void (CALLING *SyncCallback)(unsigned syncNum, unsigned position,
    unsigned row));




/****************************************************************************\
*
* Function:     int gmpSetPosition(gmpPlayHandle playHandle, unsigned
*                   newPosition);
*
* Description:  Changes song playing position.
*
* Input:        gmpPlayHandle playHandle    playing handle
*               unsigned newPosition    new playing position
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING gmpSetPosition(gmpPlayHandle playHandle, int newPosition);




/****************************************************************************\
*      Global variables used by all GMP modules:
\****************************************************************************/


extern SoundDevice * GLOBALVAR gmpSD;   /* Sound Device used by GMP */
extern gmpChannel * GLOBALVAR gmpChan;  /* current GMP channel */
extern unsigned GLOBALVAR gmpTempo;     /* GMP playing tempo (global for
                                           all songs) */
extern unsigned GLOBALVAR gmpPlayMode;  /* current playing mode */
extern gmpPlayHandle GLOBALVAR gmpHandle;   /* current playing handle */
extern gmpModule * GLOBALVAR gmpCurModule;  /* current playing module */




/****************************************************************************\
*      Command pointer tables:
\****************************************************************************/

    /* Protracker playing mode tick-0 commands: */
extern int GLOBALVAR (*gmpTick0CommandsPT[])(unsigned infobyte);

    /* Protracker playing mode continuous commands: */
extern int GLOBALVAR (*gmpContCommandsPT[gmpNumCommands])(unsigned infobyte);

    /* Fasttracker 2 playing mode tick-0 commands: */
extern int GLOBALVAR (*gmpTick0CommandsFT2[])(unsigned infobyte);

    /* Fasttracker 2 playing mode continuous commands: */
extern int GLOBALVAR (*gmpContCommandsFT2[gmpNumCommands])(unsigned infobyte);

    /* Screamtracker 3 playing mode tick-0 commands: */
extern int GLOBALVAR (*gmpTick0CommandsST3[])(unsigned infobyte);

    /* Screamtracker 3 playing mode continuous commands: */
extern int GLOBALVAR (*gmpContCommandsST3[gmpNumCommands])(unsigned infobyte);



#ifdef __cplusplus
}
#endif







/****************************************************************************\
*       enum gmpFunctIDs
*       ----------------
* Description:  ID numbers for Generic Module Player
\****************************************************************************/

enum gmpFunctIDs
{
    ID_gmpInit = ID_gmp,
    ID_gmpClose,
    ID_gmpSetUpdRateFunct,
    ID_gmpPlaySong,
    ID_gmpStopSong,
    ID_gmpPlay,
    ID_gmpSetTempo,
    ID_gmpPlayPattern,
    ID_gmpHandleCommands,
    ID_gmpNotePeriod,
    ID_gmpPlayNote,
    ID_gmpPeriodRate,
    ID_gmpFreeModule,
    ID_gmpLoadMOD,
    ID_gmpSetPeriod,
    ID_gmpChangePeriod,
    ID_gmpSetVolume,
    ID_gmpChangeVolume,
    ID_gmpNewNote,
    ID_gmpLoadXM,
    ID_gmpRunEnvelopes,
    ID_gmpLoadS3M,
    ID_gmpSetPanning,
    ID_gmpSetSyncCallback
};



#endif


/*
 * $Log: gmplayer.h,v $
 * Revision 1.9  1996/10/06 16:48:10  pekangas
 * Fixed a overflow problem in panning
 *
 * Revision 1.8  1996/09/01 18:33:34  pekangas
 * Added GMP_NUM_COMMANDS #define, hack for Watcom C 10.0
 *
 * Revision 1.7  1996/09/01 15:41:43  pekangas
 * Changed command handling for FT2 and splitted some slides in two commands
 *
 * Revision 1.6  1996/07/13 20:01:05  pekangas
 * Changed gmpInstrument.numsamples to unsigned
 *
 * Revision 1.5  1996/07/13 19:41:13  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.4  1996/07/13 18:04:50  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.3  1996/05/24 16:59:11  pekangas
 * Fixed to work with Watcom C again - using EMPTYARRAY
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Fixed to work with gcc
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/