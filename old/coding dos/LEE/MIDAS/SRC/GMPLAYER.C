/*      gmplayer.c
 *
 * Generic Module Player
 *
 * $Id: gmplayer.c,v 1.13 1997/02/05 15:30:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

/*#define DEBUGMESSAGES */

#ifdef DEBUGMESSAGES
#include <stdio.h>
#include <stdlib.h>
#endif

#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "sdevice.h"
#include "gmplayer.h"
#include "mmem.h"

#ifdef DEBUGMESSAGES
#define DEBUGprintf(x,y) printf(x,y)
#define DEBUGputs(x) puts(x)
#else
#define DEBUGprintf(x,y)
#define DEBUGputs(x)
#endif

RCSID(const char *gmplayer_rcsid = "$Id: gmplayer.c,v 1.13 1997/02/05 15:30:59 pekangas Exp $";)


static volatile int  gmpNoPlay = 0;     /* 1 if music should NOT be played */
SoundDevice     *gmpSD;                 /* Sound Device used by GMP */
gmpChannel      *gmpChan;               /* current GMP channel */
unsigned        gmpTempo;               /* GMP playing tempo (global for
                                           all songs) */
unsigned        gmpPlayMode;            /* current playing mode */
gmpPlayHandle   gmpHandle;              /* current playing handle */
gmpModule       *gmpCurModule;          /* current playing module */
static gmpPlayHandle playHandles[MAXSONGS];     /* playing handles */
static int (CALLING *SetUpdRate)(unsigned updRate);
                                        /* pointer to update rate changing
                                           function */


    /* Period values for octave 0 notes for all finetune values in Protracker
       modules: */
static unsigned gmpPeriodsPT[16*12] = {
        /* Tuning 0: */
        1712,1616,1524,1440,1356,1280,1208,1140,1076,1016,960,907,
        /* Tuning 1: */
        1700,1604,1514,1430,1348,1274,1202,1134,1070,1010,954,900,
        /* Tuning 2: */
        1688,1592,1504,1418,1340,1264,1194,1126,1064,1004,948,894,
        /* Tuning 3: */
        1676,1582,1492,1408,1330,1256,1184,1118,1056,996,940,888,
        /* Tuning 4: */
        1664,1570,1482,1398,1320,1246,1176,1110,1048,990,934,882,
        /* Tuning 5: */
        1652,1558,1472,1388,1310,1238,1168,1102,1040,982,926,874,
        /* Tuning 6: */
        1640,1548,1460,1378,1302,1228,1160,1094,1032,974,920,868,
        /* Tuning 7: */
        1628,1536,1450,1368,1292,1220,1150,1086,1026,968,914,862,
        /* Tuning -8: */
        1814,1712,1616,1524,1440,1356,1280,1208,1140,1076,1016,960,
        /* Tuning -7: */
        1800,1700,1604,1514,1430,1350,1272,1202,1134,1070,1010,954,
        /* Tuning -6: */
        1788,1688,1592,1504,1418,1340,1264,1194,1126,1064,1004,948,
        /* Tuning -5: */
        1774,1676,1582,1492,1408,1330,1256,1184,1118,1056,996,940,
        /* Tuning -4: */
        1762,1664,1570,1482,1398,1320,1246,1176,1110,1048,988,934,
        /* Tuning -3: */
        1750,1652,1558,1472,1388,1310,1238,1168,1102,1040,982,926,
        /* Tuning -2: */
        1736,1640,1548,1460,1378,1302,1228,1160,1094,1032,974,920,
        /* Tuning -1: */
        1724,1628,1536,1450,1368,1292,1220,1150,1086,1026,968,914 };

    /* Period table for Fasttracker 2 module playing: */
static unsigned gmpPeriodsFT2[96+8] = {
        907,900,894,887,881,875,868,862,856,850,844,838,832,826,820,814,
        808,802,796,791,785,779,774,768,762,757,752,746,741,736,730,725,
        720,715,709,704,699,694,689,684,678,675,670,665,660,655,651,646,
        640,636,632,628,623,619,614,610,604,601,597,592,588,584,580,575,
        570,567,563,559,555,551,547,543,538,535,532,528,524,520,516,513,
        508,505,502,498,494,491,487,484,480,477,474,470,467,463,460,457,
        453,450,447,443,440,437,434,431 };

    /* Period table for Screamtracker 3 module playing: */
static unsigned gmpPeriodsST3[12] = {
        1712,1616,1524,1440,1356,1280,1208,1140,1076,1016,960,907 };


    /* Magic table for Fasttracker 2 linear frequency support: (don't ask me
       what this is - I ripped it from Jarno's PS3M source (PK)) */
static unsigned long gmpLinTable[768] = {
        535232,534749,534266,533784,533303,532822,532341,531861,
        531381,530902,530423,529944,529466,528988,528511,528034,
        527558,527082,526607,526131,525657,525183,524709,524236,
        523763,523290,522818,522346,521875,521404,520934,520464,
        519994,519525,519057,518588,518121,517653,517186,516720,
        516253,515788,515322,514858,514393,513929,513465,513002,
        512539,512077,511615,511154,510692,510232,509771,509312,
        508852,508393,507934,507476,507018,506561,506104,505647,
        505191,504735,504280,503825,503371,502917,502463,502010,
        501557,501104,500652,500201,499749,499298,498848,498398,
        497948,497499,497050,496602,496154,495706,495259,494812,
        494366,493920,493474,493029,492585,492140,491696,491253,
        490809,490367,489924,489482,489041,488600,488159,487718,
        487278,486839,486400,485961,485522,485084,484647,484210,
        483773,483336,482900,482465,482029,481595,481160,480726,
        480292,479859,479426,478994,478562,478130,477699,477268,
        476837,476407,475977,475548,475119,474690,474262,473834,
        473407,472979,472553,472126,471701,471275,470850,470425,
        470001,469577,469153,468730,468307,467884,467462,467041,
        466619,466198,465778,465358,464938,464518,464099,463681,
        463262,462844,462427,462010,461593,461177,460760,460345,
        459930,459515,459100,458686,458272,457859,457446,457033,
        456621,456209,455797,455386,454975,454565,454155,453745,
        453336,452927,452518,452110,451702,451294,450887,450481,
        450074,449668,449262,448857,448452,448048,447644,447240,
        446836,446433,446030,445628,445226,444824,444423,444022,
        443622,443221,442821,442422,442023,441624,441226,440828,
        440430,440033,439636,439239,438843,438447,438051,437656,
        437261,436867,436473,436079,435686,435293,434900,434508,
        434116,433724,433333,432942,432551,432161,431771,431382,
        430992,430604,430215,429827,429439,429052,428665,428278,
        427892,427506,427120,426735,426350,425965,425581,425197,
        424813,424430,424047,423665,423283,422901,422519,422138,
        421757,421377,420997,420617,420237,419858,419479,419101,
        418723,418345,417968,417591,417214,416838,416462,416086,
        415711,415336,414961,414586,414212,413839,413465,413092,
        412720,412347,411975,411604,411232,410862,410491,410121,
        409751,409381,409012,408643,408274,407906,407538,407170,
        406803,406436,406069,405703,405337,404971,404606,404241,
        403876,403512,403148,402784,402421,402058,401695,401333,
        400970,400609,400247,399886,399525,399165,398805,398445,
        398086,397727,397368,397009,396651,396293,395936,395579,
        395222,394865,394509,394153,393798,393442,393087,392733,
        392378,392024,391671,391317,390964,390612,390259,389907,
        389556,389204,388853,388502,388152,387802,387452,387102,
        386753,386404,386056,385707,385359,385012,384664,384317,
        383971,383624,383278,382932,382587,382242,381897,381552,
        381208,380864,380521,380177,379834,379492,379149,378807,
        378466,378124,377783,377442,377102,376762,376422,376082,
        375743,375404,375065,374727,374389,374051,373714,373377,
        373040,372703,372367,372031,371695,371360,371025,370690,
        370356,370022,369688,369355,369021,368688,368356,368023,
        367691,367360,367028,366697,366366,366036,365706,365376,
        365046,364717,364388,364059,363731,363403,363075,362747,
        362420,362093,361766,361440,361114,360788,360463,360137,
        359813,359488,359164,358840,358516,358193,357869,357547,
        357224,356902,356580,356258,355937,355616,355295,354974,
        354654,354334,354014,353695,353376,353057,352739,352420,
        352103,351785,351468,351150,350834,350517,350201,349885,
        349569,349254,348939,348624,348310,347995,347682,347368,
        347055,346741,346429,346116,345804,345492,345180,344869,
        344558,344247,343936,343626,343316,343006,342697,342388,
        342079,341770,341462,341154,340846,340539,340231,339924,
        339618,339311,339005,338700,338394,338089,337784,337479,
        337175,336870,336566,336263,335959,335656,335354,335051,
        334749,334447,334145,333844,333542,333242,332941,332641,
        332341,332041,331741,331442,331143,330844,330546,330247,
        329950,329652,329355,329057,328761,328464,328168,327872,
        327576,327280,326985,326690,326395,326101,325807,325513,
        325219,324926,324633,324340,324047,323755,323463,323171,
        322879,322588,322297,322006,321716,321426,321136,320846,
        320557,320267,319978,319690,319401,319113,318825,318538,
        318250,317963,317676,317390,317103,316817,316532,316246,
        315961,315676,315391,315106,314822,314538,314254,313971,
        313688,313405,313122,312839,312557,312275,311994,311712,
        311431,311150,310869,310589,310309,310029,309749,309470,
        309190,308911,308633,308354,308076,307798,307521,307243,
        306966,306689,306412,306136,305860,305584,305308,305033,
        304758,304483,304208,303934,303659,303385,303112,302838,
        302565,302292,302019,301747,301475,301203,300931,300660,
        300388,300117,299847,299576,299306,299036,298766,298497,
        298227,297958,297689,297421,297153,296884,296617,296349,
        296082,295815,295548,295281,295015,294749,294483,294217,
        293952,293686,293421,293157,292892,292628,292364,292100,
        291837,291574,291311,291048,290785,290523,290261,289999,
        289737,289476,289215,288954,288693,288433,288173,287913,
        287653,287393,287134,286875,286616,286358,286099,285841,
        285583,285326,285068,284811,284554,284298,284041,283785,
        283529,283273,283017,282762,282507,282252,281998,281743,
        281489,281235,280981,280728,280475,280222,279969,279716,
        279464,279212,278960,278708,278457,278206,277955,277704,
        277453,277203,276953,276703,276453,276204,275955,275706,
        275457,275209,274960,274712,274465,274217,273970,273722,
        273476,273229,272982,272736,272490,272244,271999,271753,
        271508,271263,271018,270774,270530,270286,270042,269798,
        269555,269312,269069,268826,268583,268341,268099,267857 };

static signed char ft2VibratoTable[256] = {
        0,-2,-3,-5,-6,-8,-9,-11,-12,-14,-16,-17,-19,-20,-22,-23,
        -24,-26,-27,-29,-30,-32,-33,-34,-36,-37,-38,-39,-41,-42,
        -43,-44,-45,-46,-47,-48,-49,-50,-51,-52,-53,-54,-55,-56,
        -56,-57,-58,-59,-59,-60,-60,-61,-61,-62,-62,-62,-63,-63,
        -63,-64,-64,-64,-64,-64,-64,-64,-64,-64,-64,-64,-63,-63,
        -63,-62,-62,-62,-61,-61,-60,-60,-59,-59,-58,-57,-56,-56,
        -55,-54,-53,-52,-51,-50,-49,-48,-47,-46,-45,-44,-43,-42,
        -41,-39,-38,-37,-36,-34,-33,-32,-30,-29,-27,-26,-24,-23,
        -22,-20,-19,-17,-16,-14,-12,-11,-9,-8,-6,-5,-3,-2,0,
        2,3,5,6,8,9,11,12,14,16,17,19,20,22,23,24,26,27,29,30,
        32,33,34,36,37,38,39,41,42,43,44,45,46,47,48,49,50,51,
        52,53,54,55,56,56,57,58,59,59,60,60,61,61,62,62,62,63,
        63,63,64,64,64,64,64,64,64,64,64,64,64,63,63,63,62,62,
        62,61,61,60,60,59,59,58,57,56,56,55,54,53,52,51,50,49,
        48,47,46,45,44,43,42,41,39,38,37,36,34,33,32,30,29,27,
        26,24,23,22,20,19,17,16,14,12,11,9,8,6,5,3,2 };

        /* Flags for FT2 commands - 1 if previous infobyte should be used when
           the infobyte is 0: */
static uchar    ft2UsePrevInfo[gmpNumCommands] =
    {
        0,    /* no command */
        0,    /* arpeggio */
        1,    /* period slide up */
        1,    /* period slide down */
        0,    /* tone portamento */                 /* handled by command */
        0,    /* vibrato */                         /* handled by command */
        0,    /* tone portamento + volume slide */  /* handled by command */
        0,    /* vibrato + volume slide */          /* handled by command */
        0,    /* tremolo */                         /* handled by command */
        0,    /* set panning (PT cmd 8) */
        0,    /* set sample offset */               /* handled by command */
        0,    /* volume slide */                    /* handled by command */
        0,    /* position jump */
        0,    /* set volume */
        0,    /* pattern break (to a row) */
        0,    /* set speed */
        0,    /* set tempo in BPM */
        1,    /* fine period slide up */
        1,    /* fine period slide down */
        0,    /* pattern loop set/loop */
        0,    /* set 16-point panning value */
        0,    /* Protracker-style retrig note */
        1,    /* fine volume slide up */
        1,    /* fine volume slide down */
        0,    /* note cut */
        0,    /* note delay */
        0,    /* pattern delay */
        0,    /* set master volume */
        1,    /* master volume slide */
        0,    /* S3M retrig note */
        0,    /* music synchronization command */
        1,    /* extra fine period slide up */
        1,    /* extra fine period slide down */
        0    /* panning slide */
    };

/* Local prototypes: */
int gmpPlayPattern(gmpPlayHandle playHandle);
int gmpHandleCommands(gmpPlayHandle playHandle);
int gmpRunEnvelopes(gmpPlayHandle playHandle);



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

int CALLING gmpInit(SoundDevice *SD)
{
    int         i;
    int         error;

    /* Store Sound Device pointer: */
    gmpSD = SD;

    /* Point all playing handles to NULL to mark them free: */
    for ( i = 0; i < MAXSONGS; i++ )
        playHandles[i] = NULL;

    /* Point SetUpdRate() to NULL to mark it has not been set: */
    SetUpdRate = NULL;

    /* Set tempo by default to 125 and set Sound Device updating rate
       accordingly: */
    if ( (error = gmpSetTempo(125)) != OK )
        PASSERROR(ID_gmpInit);

    return OK;
}




/****************************************************************************\
*
* Function:     int gmpClose(void);
*
* Description:  Uninitializes Generic Module Player
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING gmpClose(void)
{
    int         i;
    int         error;

    /* Stop all still playing songs: */
    for ( i = 0; i < MAXSONGS; i++ )
    {
        if ( playHandles[i] != NULL )
        {
            if ( (error = gmpStopSong(playHandles[i])) != OK )
                PASSERROR(ID_gmpClose)
        }
    }

    return OK;
}




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

int CALLING gmpSetUpdRateFunct(int (CALLING *_SetUpdRate)(unsigned updRate))
{
    int         error;

    /* Save update rate changing function: */
    SetUpdRate = _SetUpdRate;

    if ( SetUpdRate != NULL )
    {
        /* Set update rate to match current tempo: */
        if ( (error = SetUpdRate(40*gmpTempo)) != OK )
            PASSERROR(ID_gmpSetUpdRateFunct)
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int gmpPlaySong(gmpModule *module, int startPos, int endPos,
*                   int restartPos, int numChannels,
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
    gmpPlayHandle *playHandle)
{
    static gmpPlayHandle  handle;
    int         error, i, hnum, c;
    int         numChs;
    gmpChannel  *chan;

    /* Check if number of channels has been specified, and if not, use the
       full number of channels from module: */
    if ( numChannels != -1 )
        numChs = numChannels;
    else
        numChs = module->numChannels;

    /* Find first free position from playing handle table: */
    hnum = -1;
    for ( i = 0; i < MAXSONGS; i++ )
    {
        if ( playHandles[i] == NULL )
            hnum = i;
    }

    /* If there are no free playing handles, return error: */
    if ( hnum == -1 )
    {
        ERROR(errOutOfResources, ID_gmpPlaySong);
        return errOutOfResources;
    }

    /* Don't play while we are setting up the channels: */
    gmpNoPlay = 1;

    /* Allocate memory for new playing handle: */
    if ( (error = memAlloc(sizeof(gmpPlayStatus), (void**) &handle)) != OK )
        PASSERROR(ID_gmpPlaySong)

    /* Point channel structure pointer to NULL for safety: */
    handle->channels = NULL;

    playHandles[hnum] = handle;
    handle->handleNum = hnum;

    /* Allocate memory for channel structures: */
    if ( (error = memAlloc(numChs * sizeof(gmpChannel), (void**)
        &handle->channels)) != OK)
        PASSERROR(ID_gmpPlaySong)

    /* Set up initial values for playing status structure: */
    handle->module = module;
    handle->playPtr = NULL;
    handle->tempo = module->tempo;
    handle->speed = module->speed;
    handle->playCount = 0;
    handle->numChannels = numChs;
    handle->row = 0;
    handle->pattDelayCount = 0;
    handle->SyncCallback = NULL;
    handle->syncInfo = -1;
    handle->loopRow = handle->loopCount = 0;
    handle->masterVolume = module->masterVolume;
    gmpTempo = handle->tempo;

    /* Set song initial tempo: */
    if ( (error = gmpSetTempo(handle->tempo)) != OK )
        PASSERROR(ID_gmpPlaySong)

    /* Check if song playing range has been specified, and if not, play
       whole module: */
    if ( startPos != -1 )
    {
        handle->position = startPos;
        handle->songEnd = endPos;
        handle->restartPos = restartPos;
    }
    else
    {
        handle->position = 0;
        handle->songEnd = module->songLength - 1;
        handle->restartPos = module->restart;
    }

    handle->pattern = module->songData[handle->position];

    /* Clear channel structures to their initial states: */
    chan = handle->channels;
    /* Set gmpPlayMode to current playing mode: */
    gmpPlayMode = module->playMode;

    for ( i = 0; i < numChs; i++ )
    {
        gmpChan = chan;
        gmpHandle = handle;

        chan->command = gmpcNone;       /* no command */
        chan->infobyte = 0;             /* no infobyte */
        chan->oldInfo = 0;              /* no old infobyte */
        chan->period = 0;               /* no period set */
        chan->realPeriod = 0;
        chan->truePeriod = 0;
        chan->tpDest = 0;               /* no tone portamento destination */
        chan->tpSpeed = 0;              /* no tone portamento speed */
        chan->instrument = -1;          /* no instrument set */
        chan->newInstrument = -1;       /* no new instrument set */
        chan->sample = 0xFF;
        chan->note = 0xFF;              /* no note set */
        chan->prevNote = 0xFF;          /* there has been no note */
        chan->startOffset = 0;          /* start from beginning of sample */
        chan->sdChannel = (uchar) sdChannels[i];    /* SD channel number */
        chan->volume = 64;              /* initial volume is 64 */
        chan->realVolume = 64;          /* initial volume is 64 */
        chan->keyOff = 0;               /* no key off -note yet */
        chan->vibSpeed = 0;             /* clear vibrato speed */
        chan->vibDepth = 0;             /* clear vibrato depth */
        chan->vibPos = 0;               /* reset vibrato position */
        chan->autoVibPos = 0;           /* auto vibrato position */
        chan->autoVibDepth = 0;         /* auto vibrato depth */
        chan->smpOffset = 0;            /* reset sample offset infobyte */
        chan->loopRow = 0;
        chan->loopCount = 0;
        chan->volSlideInfobyte = 0;

        /* Clear old infobytes: */
        for ( c = 0; c < gmpNumCommands; chan->oldInfobytes[c++] = 0 );

        /* Set channel initial panning position: */
        if ( (error = gmpSetPanning(module->panning[i])) != OK )
        {
            gmpNoPlay = 0;
            PASSERROR(ID_gmpPlaySong)
        }
        chan++;
    }

    /* Set correct period limits: */
    switch ( module->playMode )
    {
        case gmpPT:
            handle->perMultiplier = 0;
            handle->volLimit = 64;
            if ( module->playFlags.extOctaves )
            {
                /* Protracker module with extended octaves enabled: */
                handle->perLimitUp = 1712;
                handle->perLimitLow = 28;
            }
            else
            {
                /* Protracker module with extended octaves disabled: */
                handle->perLimitUp = 856;
                handle->perLimitLow = 113;
            }
            break;

        case gmpFT2:
            /* Fasttracker 2 period limits: (??) */
            handle->perMultiplier = 2;
            handle->volLimit = 64;
            handle->perLimitUp = 54784;
            handle->perLimitLow = 57;
            break;

        case gmpST3:
            /* Screamtracker 3 period limits: */
            handle->perMultiplier = 2;
            handle->volLimit = 63;
            if ( module->playFlags.ptLimits )
            {
                handle->perLimitUp = 856 << 2;
                handle->perLimitLow = 113 << 2;
            }
            else
                handle->perLimitUp = 0x7fff;
                handle->perLimitLow = 64;
            break;
    }

    /* Allocate memory for playing information structure: */
    if ( (error = memAlloc(sizeof(gmpInformation), (void**)
        &handle->information)) != OK )
        PASSERROR(ID_gmpPlaySong)

    /* Set information structure channel pointer to channel structures: */
    handle->information->channels = handle->channels;

    /* Reset information structure values: */
    handle->information->position = handle->position;
    handle->information->pattern = handle->pattern;
    handle->information->row = handle->row;
    handle->information->tempo = gmpTempo;
    handle->information->speed = handle->speed;

    /* We can play again: */
    gmpNoPlay = 0;

    /* Return new playing handle in *playHandle: */
    *playHandle = handle;

    return OK;
}




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

int CALLING gmpStopSong(gmpPlayHandle playHandle)
{
    int         error;

    /* Deallocate channel structures if allocated: */
    if ( playHandle->channels != NULL )
    {
        if ( (error = memFree(playHandle->channels)) != OK )
            PASSERROR(ID_gmpStopSong)
    }

    /* Mark playing handle free in table: */
    playHandles[playHandle->handleNum] = NULL;

    /* Deallocate playing handle: */
    if ( (error = memFree(playHandle)) != OK )
        PASSERROR(ID_gmpStopSong)

    return OK;
}




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

int CALLING gmpFreeModule(gmpModule *module)
{
    int         error;
    gmpInstrument *inst;
    unsigned    i, s;

    if ( module == NULL )
        return OK;

    DEBUGputs("gmpFreeModule");
    DEBUGputs("module->panning");

    /* Deallocate initial channel panning positions if allocated: */
    if ( module->panning != NULL )
    {
        if ( (error = memFree(module->panning)) != OK )
            PASSERROR(ID_gmpFreeModule)
    }

    DEBUGputs("module->songData");

    /* Deallocate song data if allocated: */
    if ( module->songData != NULL )
    {
        if ( (error = memFree(module->songData)) != OK )
            PASSERROR(ID_gmpFreeModule)
    }

    /* Deallocate instruments if allocated: */
    if ( module->instruments != NULL )
    {
        for ( i = 0; i < module->numInsts; i++ )
        {
            inst = module->instruments[i];
            if ( inst != NULL )
            {
                DEBUGprintf("inst[%i]->noteSamples\n", i);
                /* If the instrument has keyboard note sample list, deallocate
                   it: */
                if ( inst->noteSamples != NULL )
                {
                    if ( (error = memFree(inst->noteSamples)) != OK )
                        PASSERROR(ID_gmpFreeModule)
                }

                DEBUGprintf("inst[%i]->volEnvelope\n", i);
                /* If the instrument has volume envelope, deallocate it: */
                if ( inst->volEnvelope != NULL )
                {
                    if ( (error = memFree(inst->volEnvelope)) != OK )
                        PASSERROR(ID_gmpFreeModule)
                }

                DEBUGprintf("inst[%i]->panEnvelope\n", i);
                /* If the instrument has panning envelope, deallocate it: */
                if ( inst->panEnvelope != NULL )
                {
                    if ( (error = memFree(inst->panEnvelope)) != OK )
                        PASSERROR(ID_gmpFreeModule)
                }

                DEBUGprintf("inst[%i]->samples\n", i);
                /* If the instrument has samples, deallocate them: */
                for ( s = 0; s < inst->numSamples; s++ )
                {
                    /* If the sample has a Sound Device sample handle, remove
                       it from the Sound Device: */
                    if ( inst->samples[s].sdHandle != 0 )
                    {
                        if ( (error = gmpSD->RemoveSample(
                            inst->samples[s].sdHandle)) != OK )
                            PASSERROR(ID_gmpFreeModule)
                    }

                    /* If the sample sample data is available, deallocate
                       it: */
                    if ( inst->samples[s].sample != NULL )
                    {
                        if ( (error = memFree(inst->samples[s].sample)) != OK)
                            PASSERROR(ID_gmpFreeModule)
                    }
                }

                DEBUGprintf("inst[%i]\n", i);
                /* Deallocate the instrument structure: */
                if ( (error = memFree(inst)) != OK )
                    PASSERROR(ID_gmpFreeModule)
            }

        }

        DEBUGputs("module->instruments");
        /* Deallocate instrument structure pointers: */
        if ( (error = memFree(module->instruments)) != OK )
            PASSERROR(ID_gmpFreeModule)
    }

    /* If the module has pattern data, deallocate it: */
    if ( module->patterns != NULL )
    {
        for ( i = 0; i < module->numPatts; i++ )
        {
            DEBUGprintf("patterns[%i]\n", i);
            /* If current pattern is allocated, deallocate it: */
            if ( module->patterns[i] != NULL )
            {
                if ( (error = memFree(module->patterns[i])) != OK )
                    PASSERROR(ID_gmpFreeModule)
            }
        }

        DEBUGputs("module->patterns");
        /* Deallocate pattern pointers: */
        if ( (error = memFree(module->patterns)) != OK )
            PASSERROR(ID_gmpFreeModule)
    }

    DEBUGputs("module");
    /* Deallocate the module structure: */
    if ( (error = memFree(module)) != OK )
        PASSERROR(ID_gmpFreeModule)

    return OK;
}




/****************************************************************************\
*
* Function:     int gmpPlay(void)
*
* Description:  Plays music for one song tick.
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING gmpPlay(void)
{
    int         error;
    gmpPlayHandle handle;
    unsigned    handleNum;

    /* Do for all playing handles: */
    for ( handleNum = 0; handleNum < MAXSONGS; handleNum++ )
    {
        if ( playHandles[handleNum] != NULL )
        {
            /* Handle number is in use - play: */
            handle = playHandles[handleNum];

            /* Increase handle tick counter: */
            handle->playCount++;

            /* If playCount reached speed process new pattern data, otherwise
               just handle continuous commands: */
            if ( handle->playCount >= handle->speed )
            {
                handle->playCount = 0;

                if ( (error = gmpPlayPattern(handle)) != OK )
                    PASSERROR(ID_gmpPlay)
            }
            else
            {
                if ( (error = gmpHandleCommands(handle)) != OK )
                    PASSERROR(ID_gmpPlay)
            }

            if ( ( error = gmpRunEnvelopes(handle)) != OK )
                    PASSERROR(ID_gmpPlay)
        }
    }

    return OK;
}




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
    gmpInformation **information)
{
    /* Set information structure tempo and speed values: (pos, row and patt.
       are updated in gmpPlay()) */
    playHandle->information->speed = playHandle->speed;
    playHandle->information->tempo = gmpTempo;

    playHandle->information->syncInfo = playHandle->syncInfo;

    /* Return information structure pointer in *information: */
    *information = playHandle->information;

    return OK;
}



/****************************************************************************\
*
* Function:     int gmpRunEnvelopes(gmpPlayHandle playHandle)
*
* Description:  Process envelopes for a playing handle
*
* Input:        gmpPlayHandle playHandle   playing handle
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpRunEnvelopes(gmpPlayHandle playHandle)
{
    int             error;
    unsigned        chanNum;
    int             x, y, tx, ty;
    /* signed long     vol, pan; */
    int             vol, pan;
    int             i, point, val;
    static ulong rate;
    gmpInstrument   *inst;
    gmpEnvelope     *env;

    /* Point gmpHandle to current playing handle: */
    gmpHandle = playHandle;

    /* Point gmpCurModule to current playing module: */
    gmpCurModule = gmpHandle->module;

    /* Set gmpPlayMode to current playing mode: */
    gmpPlayMode = gmpCurModule->playMode;

    for ( chanNum = 0; chanNum < playHandle->numChannels; chanNum++ )
    {
        gmpChan = &playHandle->channels[chanNum];

        switch ( gmpPlayMode )
        {
            case gmpFT2:
                vol = gmpChan->realVolume;
                if ( gmpChan->instrument != -1 )
                {
                    inst = gmpCurModule->instruments[gmpChan->instrument];

                    vol = (vol * gmpChan->fadeOut) >> 16;
                    if ( gmpChan->keyOff != 0)
                    {
                        gmpChan->fadeOut -= 2*inst->volFadeout;
                        if ( gmpChan->fadeOut < 0 ) gmpChan->fadeOut = 0;
                    }

                    if ( ( env = inst->volEnvelope ) != NULL)
                    {
                        point = -1;

                        for ( i = 0; i < env->numPoints; i++ )
                        {
                            if ( gmpChan->volEnvX <= env->points[i * 2] )
                            {
                                point = i;
                                break;
                            }
                        }
                        if ( point == -1 )
                            point = i - 1;

                        if ( gmpChan->volEnvX == env->points[point * 2] )
                        {
                            y = env->points[point * 2 + 1] * 256;
                        }
                        else
                        {
                            y = env->points[point * 2 - 1] ;
                            ty = env->points[point * 2 + 1] - y;
                            x = env->points[point * 2 - 2];
                            tx = env->points[point * 2] - x;
                            y *= 256;
                            y += ty * 256 / tx * ( gmpChan->volEnvX - x );
                        }
                        vol = ( vol * y ) >> 14;
                        if ( vol < 0 ) vol = 0;
                        if ( vol > 64 ) vol = 64;

                        if ( ( gmpChan->volEnvX == env->points[env->sustain * 2]) &&
                            (gmpChan->keyOff == 0) && ( env->sustain != -1 ) )
                            gmpChan->volSustained = 1;

                        if ( !gmpChan->volSustained  )
                        {
                            if ( gmpChan->volEnvX < env->points[env->numPoints * 2 - 2] )
                                gmpChan->volEnvX++;

                            if ( (gmpChan->volEnvX >= env->points[env->loopEnd * 2] )&&
                                 (env->loopEnd != -1 ) )
                                gmpChan->volEnvX = env->points[env->loopStart * 2];
                            if ( ( gmpChan->volEnvX == env->points[env->sustain * 2]) &&
                                (gmpChan->keyOff == 0) && ( env->sustain != -1 ) )
                                gmpChan->volSustained = 1;
                        }
                    }
                }

                vol = ( vol * playHandle->masterVolume ) >> 6;

                if ( vol > 64 )
                    vol = 64;
                if ( vol < 0 )
                    vol = 0;

                gmpChan->trueVolume = (uchar) vol;

                if ( (error = gmpSD->SetVolume(gmpChan->sdChannel, vol)) != OK )
                    PASSERROR(ID_gmpRunEnvelopes)

                pan = gmpChan->panning;
/*                DEBUGprintf("pan %i\n", (int) pan); */

                if ( gmpChan->instrument != -1 )
                {
                    inst = gmpCurModule->instruments[gmpChan->instrument];

                    if ( ( env = inst->panEnvelope ) != NULL)
                    {
                        point = -1;

                        for ( i = 0; i < env->numPoints; i++ )
                        {
                            if ( gmpChan->panEnvX <= env->points[i * 2] )
                            {
                                point = i;
                                break;
                            }
                        }
                        if ( point == -1 )
                            point = i;

                        if ( gmpChan->panEnvX == env->points[point * 2] )
                        {
                            y = env->points[point * 2 + 1] * 256;
                        }
                        else
                        {
                            y = env->points[point * 2 - 1];
                            ty = env->points[point * 2 + 1] - y;
                            x = env->points[point * 2 - 2];
                            tx = env->points[point * 2] - x;
                            y *= 256;
                            y += ty * 256 / tx * ( gmpChan->panEnvX - x );
                        }


                        /* Was
                            pan = pan + ( ( y >> 8 ) - 32 )
                                * (128-abs(pan-128)) / 32;
                           Eliminated the need to use abs():
                        */

                        if ( pan >= 128 )
                        {
                            pan = pan + ( ( y >> 8 ) - 32 )
                                * (128-(pan-128)) / 32;
                        }
                        else
                        {
                            pan = pan + ( ( y >> 8 ) - 32 )
                                * (128+(pan-128)) / 32;
                        }

                        /* [Petteri] Was: if ( pan < 0 ) pan = 255; - feature? */
                        if ( pan < 0 ) pan = 0;
                        if ( pan > 255 ) pan = 255;

                        if ( ( gmpChan->panEnvX == env->points[env->sustain * 2]) &&
                            (gmpChan->keyOff == 0) && ( env->sustain != -1 ) )
                            gmpChan->panSustained = 1;

                        if ( !gmpChan->panSustained  )
                        {
                            if ( gmpChan->panEnvX < env->points[env->numPoints * 2 - 2] )
                                gmpChan->panEnvX++;

                            if ( (gmpChan->panEnvX >= env->points[env->loopEnd * 2] ) &&
                                 (env->loopEnd != -1 ) )
                                gmpChan->panEnvX = env->points[env->loopStart * 2];
                            if ( ( gmpChan->panEnvX == env->points[env->sustain * 2]) &&
                                (gmpChan->keyOff == 0) && ( env->sustain != -1 ) )
                                gmpChan->panSustained = 1;
                        }

                    }
                }

                pan = (pan - 0x80) / 2;

                if ( pan < panLeft )
                    pan = panLeft;
                if ( pan > panRight )
                    pan = panRight;

                /* Set panning to Sound Device: */
                if ( (error = gmpSD->SetPanning(gmpChan->sdChannel, pan)) != OK )
                    PASSERROR(ID_gmpRunEnvelopes)


                /* Run autovibrato */

                if ( gmpChan->instrument != -1 )
                {
                    inst = gmpCurModule->instruments[gmpChan->instrument];

                    if ( inst->vibDepth == 0)
                    {
                        /* no vibrato... */
                        gmpChan->truePeriod = gmpChan->realPeriod;
                    }
                    else
                    {
                        if ( inst->vibSweep == 0)
                            gmpChan->autoVibDepth = inst->vibDepth << 8;
                        else
                        {
                            if ( !gmpChan->keyOff )
                            {
                                gmpChan->autoVibDepth +=
                                    ( inst->vibDepth << 8 ) / inst->vibSweep;
                                if ( (gmpChan->autoVibDepth >> 8 ) > inst->vibDepth )
                                    gmpChan->autoVibDepth = inst->vibDepth << 8;
                            }
                        }

                        gmpChan->autoVibPos += inst->vibRate;

                        switch (inst->vibType)
                        {
                            case 3:
                                val = ((0x40-(gmpChan->autoVibPos>>1))&0x7f)-0x40;
                                break;
                            case 2:
                                val = ((0x40+(gmpChan->autoVibPos>>1))&0x7f)-0x40;
                                break;
                            case 1:
                                val = gmpChan->autoVibPos & 128 ? +64 : -64;
                                break;
                            case 0:
                            default:
                                val = ft2VibratoTable[gmpChan->autoVibPos & 255];
                                break;
                        }

                        gmpChan->truePeriod = gmpChan->realPeriod +
                            ((val * gmpChan->autoVibDepth ) >> 14);

                        /* Limit period value within current limits: */
                        if ( gmpChan->truePeriod <
                                (int) gmpHandle->perLimitLow )
                            gmpChan->truePeriod = gmpHandle->perLimitLow;
                        if ( gmpChan->truePeriod >
                                (int) gmpHandle->perLimitUp )
                            gmpChan->truePeriod = gmpHandle->perLimitUp;
                    }

                    if ( gmpChan->truePeriod != 0 )
                    {
                        /* Get rate corresponding to period value: */
                        if ( (error = gmpPeriodRate(gmpChan->truePeriod,
                            &rate)) != OK )
                            PASSERROR(ID_gmpSetPeriod)

                        /* Set new playing rate to Sound Device: */
                        if ( (error = gmpSD->SetRate(gmpChan->sdChannel,
                            rate)) != OK )
                            PASSERROR(ID_gmpSetPeriod)
                    }
                }
                break;

            default:
                vol = ( gmpChan->realVolume * playHandle->masterVolume ) >> 6;
                gmpChan->trueVolume = (uchar) vol;

                /* Set volume to Sound Device: */
                if ( (error = gmpSD->SetVolume(gmpChan->sdChannel, vol)) != OK )
                    PASSERROR(ID_gmpRunEnvelopes)

                gmpChan->truePeriod = gmpChan->realPeriod;

                /* If a period has been set, set it to Sound Device: */
                if ( gmpChan->truePeriod != 0 )
                {
                    /* Get rate corresponding to period value: */
                    if ( (error = gmpPeriodRate(gmpChan->truePeriod, &rate))
                        != OK )
                        PASSERROR(ID_gmpSetPeriod)

                    /* Set new playing rate to Sound Device: */
                    if ( (error = gmpSD->SetRate(gmpChan->sdChannel, rate))
                        != OK )
                        PASSERROR(ID_gmpSetPeriod)
                }
                break;
        }
    }
    return  OK;
}

/****************************************************************************\
*
* Function:     int gmpPlayPattern(gmpPlayHandle playHandle)
*
* Description:  Process one row of new pattern data for a playing handle
*
* Input:        gmpPlayHandle playHandle   playing handle
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpPlayPattern(gmpPlayHandle playHandle)
{
    unsigned    chanNum;
    int         error, row, xmNote;
    uchar       compInfo;
    uchar       note, inst;
    uchar       *pattData;
    uchar       command, infobyte;
    gmpInstrument *instStruct;
    int (**Commands)(unsigned);         /* pointer to command table */

    /* Point pattData to current pattern playing position: */
    pattData = playHandle->playPtr;

    /* Point gmpHandle to current playing handle: */
    gmpHandle = playHandle;

    /* Point gmpCurModule to current playing module: */
    gmpCurModule = gmpHandle->module;

    /* Set gmpPlayMode to current playing mode: */
    gmpPlayMode = gmpCurModule->playMode;

    /* Set Commands to point to appropriate command pointer table: */
    switch ( gmpPlayMode )
    {
        case gmpPT:
        default:
            Commands = &gmpTick0CommandsPT[0];
            break;

        case gmpFT2:
            Commands = &gmpTick0CommandsFT2[0];
            break;

        case gmpST3:
            Commands = &gmpTick0CommandsST3[0];
            break;
    }

    /* Set playing handle information structure position, pattern and row
       fields now so that they reflect the current playing values, not the
       next ones: */
    gmpHandle->information->position = gmpHandle->position;
    gmpHandle->information->pattern = gmpHandle->pattern;
    gmpHandle->information->row = gmpHandle->row;

    /* If pattern delay is in progress, run both tick 0 and continuous
       commands, decrease delay counter and exit: */
    if ( gmpHandle->pattDelayCount )
    {
        /* Run tick 0 commands: */
        gmpChan = &gmpHandle->channels[0];
        for ( chanNum = 0; chanNum < gmpHandle->numChannels; chanNum++ )
        {
            /* Run command for this channel if there is one: */
            if ( gmpChan->status.command )
            {
                if ( (error = Commands[gmpChan->command](gmpChan->infobyte))
                    != OK )
                    PASSERROR(ID_gmpPlayPattern)
            }
            gmpChan++;
        }

        /* Run continuous commands: */
        if ( (error = gmpHandleCommands(gmpHandle)) != OK )
            PASSERROR(ID_gmpPlayPattern)

        /* Decrease pattern delay counter: */
        gmpHandle->pattDelayCount--;

        return OK;
    }

    /* If pattData is NULL, playing position has been changed and new position
       must be set: */
    if ( pattData == NULL )
    {
        /* Get the start address of current pattern: */
        pattData = (uchar*) gmpCurModule->patterns[playHandle->pattern]
            + sizeof(gmpPattern);

        /* Skip pattern data to correct row number: */
        row = gmpHandle->row;
        while ( row )
        {
            do
            {
                /* Get compression infobyte: */
                compInfo = *(pattData++);

                /* Skip all data bytes required: */
                if ( compInfo & 32 )
                    pattData += 2;
                if ( compInfo & 64 )
                    pattData += 1;
                if ( compInfo & 128 )
                    pattData += 2;
            } while ( compInfo != 0 );

            row--;
        }
    }

    /* Clear all new data flags from all channels: */
    for ( chanNum = 0; chanNum < playHandle->numChannels; chanNum++ )
    {
        playHandle->channels[chanNum].status.newNote = 0;
        playHandle->channels[chanNum].status.newInst = 0;
        playHandle->channels[chanNum].status.newVolume = 0;
        playHandle->channels[chanNum].status.command = 0;
    }

    /* Parse new pattern data: */
    do
    {
        /* Get compression information byte: */
        compInfo = *(pattData++);

        /* Get channel number: */
        chanNum = compInfo & 31;

        /* If channel data should not be played, skip it: */
        if ( chanNum >= playHandle->numChannels )
        {
            if ( compInfo & 32 )
                pattData += 2;
            if ( compInfo & 64 )
                pattData += 1;
            if ( compInfo & 128 )
                pattData += 2;
        }
        else
        {
            /* Point chan to current channel: */
            gmpChan = &playHandle->channels[chanNum];

            /* Check if there is a new note+instrument pair: */
            if ( compInfo & 32 )
            {
                /* Get note: */
                note = *(pattData++);

                /* Get instrument: */
                inst = *(pattData++);

                /* If note number is not 0xFF, there is a new note: */
                if ( note != 0xFF )
                {
                    gmpChan->status.newNote = 1;
                    gmpChan->note = note;
                }

                /* If instrument number is not 0xFF, there is a new
                   instrument: */
                if ( inst != 0xFF )
                {
                    gmpChan->status.newInst = 1;
                    gmpChan->newInstrument = inst;
                }
            }

            /* Check if there is a volume column value: */
            if ( compInfo & 64 )
            {
                gmpChan->volColumn = *(pattData++);
                gmpChan->status.newVolume = 1;
            }

            /* Check if there is a command+infobyte pair: */
            if ( compInfo & 128 )
            {
                gmpChan->command = *(pattData++);
                gmpChan->infobyte = *(pattData++);
                gmpChan->status.command = 1;
            }
        }
    } while ( compInfo != 0 );


    /* Store new pattern data playing position: */
    gmpHandle->playPtr = pattData;

    /* Now process new data on all channels: */
    gmpChan = &playHandle->channels[0];
    for ( chanNum = 0; chanNum < playHandle->numChannels; chanNum++ )
    {
        /* Check if there is a new instrument for this channel: */
        /* FIXME - note delay on ST3 and FT2 */

        if ( gmpChan->status.newInst )
        {
            switch ( gmpPlayMode )
            {
                case gmpPT :
                case gmpST3 :
                    gmpChan->instrument = gmpChan->newInstrument;

                    /* Point instStruct to new instrument: */
                    instStruct = gmpCurModule->instruments[gmpChan->instrument];

                    /* Set instrument volume as current channel volume: */
                    gmpSetVolume(instStruct->samples[0].volume);

                    /* Set channel sample number as zero: */
                    gmpChan->sample = 0;

                    /* Set new note start offset to zero: */
                    gmpChan->startOffset = 0;

                    /* Set the sample to the Sound Device: */
                    if ( (error = gmpSD->SetSample(gmpChan->sdChannel,
                        instStruct->samples[0].sdHandle)) != OK )
                        PASSERROR(ID_gmpPlayPattern)
                    break;

                case gmpFT2:
                    gmpChan->volEnvX = 0;
                    gmpChan->volSustained = 0;
                    gmpChan->panEnvX = 0;
                    gmpChan->panSustained = 0;
                    gmpChan->fadeOut = 0x10000;
                    gmpChan->autoVibPos = 0;
                    gmpChan->autoVibDepth = 0;

                    /* Key is not released any more: */
                    gmpChan->keyOff = 0;

                    /* We'll only actually change the instrument if there is
                       a new note: */
                    if ( (gmpChan->status.newNote) && (gmpChan->note < 0xFE)
                        && ((!gmpChan->status.command) ||
                            (gmpChan->command != gmpcTonePortamento)) )
                    {
                        gmpChan->instrument = gmpChan->newInstrument;
                        instStruct = gmpCurModule->instruments[
                            gmpChan->instrument];

                        xmNote = gmpChan->note;
                        if ( xmNote < 0xFE )
                        {
                            xmNote = (xmNote & 0xF) + (((xmNote & 0xF0) >> 4) * 12);
                            if ( xmNote > 95 ) xmNote = 95;
                            if ( xmNote < 0 ) xmNote = 0;

                            /* Set channel sample number: */
                            if ( instStruct->noteSamples != NULL )
                                gmpChan->sample =
                                    instStruct->noteSamples[xmNote];
                            else
                                gmpChan->sample = 0;
                        }
                    }

                    /* Point instStruct to new instrument: */
                    instStruct = gmpCurModule->instruments[gmpChan->instrument];

                    if ( gmpChan->sample != 0xff )
                    {
                        /* Set instrument volume as current channel volume: */
                        gmpSetVolume(instStruct->samples[gmpChan->sample].volume);

                        /* Set instrument panning as current channel panning: */
                        gmpSetPanning(instStruct->samples[gmpChan->sample].panning);

                        /* Set new note start offset to zero: */
                        gmpChan->startOffset = 0;

                        if ( gmpChan->status.newNote )
                        {
                            /* Set the sample to the Sound Device: */
                            if ( instStruct->samples[gmpChan->sample].sdHandle != 0 )
                                if ( (error = gmpSD->SetSample(gmpChan->sdChannel,
                                    instStruct->samples[gmpChan->sample].sdHandle)) != OK )
                                    PASSERROR(ID_gmpPlayPattern)
                        }
                    }

                    break;
            }
        }

        /* Check if there is a new volume column value: */
        if ( gmpChan->status.newVolume )
        {
            /* Check if it is a volume change: */
            if (gmpChan->volColumn <= 64 )
            {
                if ( (error = gmpSetVolume(gmpChan->volColumn)) != OK )
                    PASSERROR(ID_gmpPlayPattern)
            }
            else
            {
                /* Volume column command: */
                if ( (error = gmpSetVolCommand()) != OK )
                    PASSERROR(ID_gmpPlayPattern)
            }
        }

        /* Check if there is a command for this channel: */
        if ( gmpChan->status.command )
        {
            if ( gmpChan->command != gmpcNone )
            {
                command = gmpChan->command;
                infobyte = gmpChan->infobyte;

                /* Check that the command number is legal: */
                if ( command >= gmpNumCommands )
                {
                    ERROR(errInvalidPatt, ID_gmpPlayPattern);
                    return errInvalidPatt;
                }

                /* If the infobyte is nonzero, we'll save it as the
                   "old infobyte": */
                if ( infobyte != 0  )
                {
                    switch ( gmpPlayMode )
                    {
                        case gmpST3:
                            gmpChan->oldInfo = infobyte;
                            break;

                        case gmpFT2:
                            gmpChan->oldInfobytes[command] = infobyte;
                            break;
                    }
                }
                else
                {
                    /* The infobyte is 0 - use "old infobyte" if necessary: */
                    switch ( gmpPlayMode )
                    {
                        case gmpST3:
                            infobyte = gmpChan->oldInfo;
                            break;

                        case gmpFT2:
                            if ( ft2UsePrevInfo[command] )
                                infobyte = gmpChan->oldInfobytes[command];
                            break;
                    }
                }

/*                DEBUGprintf("Tick-0 command %i\n", gmpChan->command); */

                /* Handle the command - call the appropriate tick 0 command
                   routine: */
                if ( (error = Commands[command](infobyte)) != OK )
                    PASSERROR(ID_gmpPlayPattern)
            }
        }

        /* Check if there is a new note: */
        if ( gmpChan->status.newNote )
        {
            if ( (gmpPlayMode == gmpFT2) && (gmpChan->instrument != -1) )
            {
                /* Point instStruct to new instrument: */
                instStruct = gmpCurModule->instruments[gmpChan->instrument];

                xmNote = gmpChan->note;
                if ( xmNote < 0xFE )
                {
                    xmNote = (xmNote & 0xF) + (((xmNote & 0xF0) >> 4) * 12);
                    if ( xmNote > 95 ) xmNote = 95;
                    if ( xmNote < 0 ) xmNote = 0;

                    /* Set channel sample number: */
                    if ( instStruct->noteSamples != NULL )
                        gmpChan->sample = instStruct->noteSamples[xmNote];
                    else
                        gmpChan->sample = 0;
                }

                if ( ( gmpChan->sample != 0xff ) && ( gmpChan->note != 0xFE ) )
                {
                    /* Set new note start offset to zero: */
                    gmpChan->startOffset = 0;

                    gmpChan->instrument = gmpChan->newInstrument;
                    /* Point instStruct to new instrument: */
                    instStruct = gmpCurModule->instruments[gmpChan->instrument];

                    /* Set the sample to the Sound Device: */
                    if ( instStruct->samples[gmpChan->sample].sdHandle != 0 )
                        if ( (error = gmpSD->SetSample(gmpChan->sdChannel,
                            instStruct->samples[gmpChan->sample].sdHandle)) != OK )
                            PASSERROR(ID_gmpPlayPattern)
                }
            }
            /* Play the note: */
            if ( (error = gmpNewNote()) != OK )
                PASSERROR(ID_gmpPlayPattern)
        }
        else
        {
            /* Always reset channel period when there is no new note unless
               there is a vibrato command active (except for Protracker mode
               where the period is always resetted): */
            if ( (gmpPlayMode == gmpPT) || (gmpPlayMode == gmpST3) ||
                (((gmpChan->command != gmpcVibrato) ||
                (!gmpChan->status.command)) && ((gmpChan->volColumn & 0xF0)
                != 0xB0)) )
            {
                /* Reset channel period: */
                if ( (error = gmpChangePeriod(gmpChan->period)) != OK )
                    PASSERROR(ID_gmpPlayPattern)
            }
        }

        /* Point gmpChan to next channel: */
        gmpChan++;
    }

    /* Continue from next row if playing position has not been changed: */
    if ( gmpHandle->playPtr != NULL )
    {
        gmpHandle->row++;

        /* Check if we reached pattern end: */
        if ( gmpHandle->row >=
            gmpCurModule->patterns[gmpHandle->pattern]->rows )
        {
            gmpHandle->row = 0;

            /* Reset pattern loop destination row if playing ST3 module: */
            if ( gmpPlayMode == gmpST3 )
                gmpHandle->loopRow = 0;

            /* Go to next position skipping S3M song data filler: */
            do
            {
                gmpHandle->position++;

                /* Check if we reached song length, and if so, jump to restart
                   position: */
                if ( (gmpHandle->position > gmpHandle->songEnd) ||
                    (gmpCurModule->songData[gmpHandle->position] == 0xffff))
                {
                    gmpHandle->position = gmpHandle->restartPos;
                }
            } while ( gmpCurModule->songData[gmpHandle->position] == 0xfffe );

            /* Get the pattern number for new position: */
            gmpHandle->pattern = gmpCurModule->songData[gmpHandle->position];

            /* Set pattern data pointer to NULL to mark playing position
               has changed: */
            gmpHandle->playPtr = NULL;
        }
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int gmpHandleCommands(gmpPlayHandle playHandle)
*
* Description:  Handle continuous commands for a playing handle
*
* Input:        gmpPlayHandle playHandle   playing handle
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpHandleCommands(gmpPlayHandle playHandle)
{
    unsigned    chanNum;
    int         error;
    unsigned    command, infobyte;
    int (**Commands)(unsigned);         /* pointer to command table */

    /* Point gmpHandle to current playing handle: */
    gmpHandle = playHandle;

    /* Point gmpCurModule to current playing module: */
    gmpCurModule = gmpHandle->module;

    /* Set gmpPlayMode to current playing mode: */
    gmpPlayMode = gmpCurModule->playMode;

    /* Set Commands to point to appropriate continuous command pointer
       table: */
    switch ( gmpPlayMode )
    {
        case gmpPT :
        default:
            Commands = &gmpContCommandsPT[0];
            break;

        case gmpFT2 :
            Commands = &gmpContCommandsFT2[0];
            break;

        case gmpST3 :
            Commands = &gmpContCommandsST3[0];
            break;
    }

    /* Handle commands on all channels: */
    gmpChan = &gmpHandle->channels[0];
    for ( chanNum = 0; chanNum < gmpHandle->numChannels; chanNum++ )
    {
        /* Check if there is a new volume column value: */
        if ( gmpChan->status.newVolume )
        {
            /* Check that it is a command: */
            if ( ( gmpChan->volColumn > 64 ) && ( gmpPlayMode == gmpFT2 ) )
            {
                /* Volume column command: */
                if ( (error = gmpRunVolCommand()) != OK )
                    PASSERROR(ID_gmpHandleCommands)
            }
        }

        /* Check if there is a command, and if is, handle it by calling the
           correct continuous command processing routine: */
        if ( gmpChan->status.command )
        {
            command = gmpChan->command;
            infobyte = gmpChan->infobyte;

            /* Check that the command number is legal: */
            if ( command >= gmpNumCommands )
            {
                ERROR(errInvalidPatt, ID_gmpHandleCommands);
                return errInvalidPatt;
            }

            /* Check if we should use the "old infobyte": */
            if ( infobyte == 0 )
            {
                /* The infobyte is 0 - use "old infobyte" if necessary: */
                switch ( gmpPlayMode )
                {
                    case gmpST3:
                        infobyte = gmpChan->oldInfo;
                        break;

                    case gmpFT2:
                        if ( ft2UsePrevInfo[command] )
                            infobyte = gmpChan->oldInfobytes[command];
                        break;
                }
            }

/*            DEBUGprintf("Continuous command %i\n", gmpChan->command); */
            if ( (error = Commands[command](infobyte)) != OK )
                PASSERROR(ID_gmpHandleCommands)
        }

        /* Point gmpChan to next channel: */
        gmpChan++;
    }

    return OK;
}




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

int gmpSetTempo(unsigned tempo)
{
    int         error;

    /* Do a small sanity-check: */
    if ( tempo == 0 )
        return OK;

    /* Remember new tempo: */
    gmpTempo = tempo;

    /* Change Sound Device updating rate: */
    if ( (error = gmpSD->SetUpdRate(40*tempo)) != OK )
        PASSERROR(ID_gmpSetTempo)

    /* If update rate changing function has been set, call it: */
    if ( SetUpdRate != NULL )
    {
        if ( (error = SetUpdRate(40*tempo)) != OK )
            PASSERROR(ID_gmpSetTempo)
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int gmpNotePeriod(unsigned note, unsigned *period)
*
* Description:  Converts a note number to a period value (both depend on
*               current playing mode). Uses *gmpChan and *gmpCurModule to
*               get sample tuning values. GMP internal.
*
* Input:        unsigned note           note number
*               unsigned *period        pointer to period value
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpNotePeriod(unsigned note, unsigned *period)
{
    int         finetune;
    int         realNote;
    gmpSample   *sample;
    int         rnote, roct, rfine;
    int         per1, per2;

    switch ( gmpPlayMode )
    {
        case gmpPT:
            /* Protracker playing mode: */

            /* Get finetune value from correct sample: */
            finetune = gmpCurModule->instruments[gmpChan->instrument]->
                samples[gmpChan->sample].finetune;

            /* Get period value from correct part of period table for this
               finetune value and shift it right by the octave number: */
            *period = gmpPeriodsPT[12*finetune + (note & 0x0F)] >>
                (note >> 4);
            break;


        case gmpFT2:
            /* Fasttracker 2 playing mode: */

            /* Point sample to current playing sample: */
            sample = &gmpCurModule->instruments[gmpChan->instrument]->
                samples[gmpChan->sample];

            /* Calculate real note number: */

            realNote = (note & 15) + (((note & 0xf0) >> 4) * 12);
            realNote += sample->baseTune;
            if ( realNote > 118 )
                realNote = 118;
            if ( realNote < 0 )
                realNote = 0;

/*            DEBUGprintf("Noteperiod channel %i\n", gmpChan->sdChannel); */

            /* Check if we are using linear frequencies: */
            if ( gmpCurModule->playFlags.linFreqTable )
            {
                *period = 10*12*16*4 - 16*4*realNote - sample->finetune / 2;
//                Period = 10*12*16*4 - Note*16*4 - FineTune/2;
            }
            else
            {
                realNote = (realNote % 12) | ((realNote / 12) << 4);
                finetune = sample->finetune;

                /* Calculate period value for this note: */

                rnote = realNote & 0xF;
                roct = (realNote & 0xF0) >> 4;
                rfine = finetune / 16;

                rnote = rnote << 3;
                per1 = gmpPeriodsFT2[rnote+rfine+8];

                if ( finetune < 0 )
                {
                    rfine--;
                    finetune = -finetune;
                }
                else
                    rfine++;

                per2 = gmpPeriodsFT2[rnote+rfine+8];

                rfine = finetune & 0xF;
                per1 *= 16-rfine;
                per2 *= rfine;
                *period = ((per1 + per2) * 2) >> roct;
            }
            break;

        case gmpST3:
            /* Screamtracker 3 playing mode: */

            /* Point sample to current playing sample: */
            sample = &gmpCurModule->instruments[gmpChan->instrument]->
                samples[gmpChan->sample];

/*
     Calculate sampling rate that corresponds to new note. A crazy
     method, but this is what the Scream Tracker 3 documentation
     says:

                     8363 * 16 * ( period(NOTE) >> octave(NOTE) )
    note_st3period = --------------------------------------------
                        middle_c_finetunevalue(INSTRUMENT)

    note_amigaperiod = note_st3period / 4

    note_herz=14317056 / note_st3period

*/
            /* Calculate period value for this note: */

            *period = ( ( 8363 * 16 * ( gmpPeriodsST3[note & 0xF] ) )
                 >> ((note & 0xf0) >> 4) ) / sample->baseTune;
            break;

    }

    return OK;
}




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

int gmpPlayNote(unsigned period)
{
    static ulong rate;
    int         error;

    gmpChan->realPeriod = period;

    /* Get sampling rate corresponding to the new period value: */
    if ( (error = gmpPeriodRate(period, &rate)) != OK )
        PASSERROR(ID_gmpPlayNote)

    /* Start the note: */
    if ( (error = gmpSD->PlaySound(gmpChan->sdChannel, rate)) != OK )
        PASSERROR(ID_gmpPlayNote)

    return OK;
}




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

int gmpPeriodRate(unsigned period, ulong *rate)
{
    /* FIXME */

    /* Check that the period value is nonzero: */
    if ( period == 0 )
    {
        ERROR(errInvalidPatt, ID_gmpPeriodRate);
        return errInvalidPatt;
    }

    switch ( gmpPlayMode )
    {
        case gmpPT:
            /* Calculate sampling rate: (assume PAL Amiga) */
            *rate = 3546895L / ((ulong) period);
            break;

        case gmpFT2:
            /* Check if we are using linear frequency table: */
            if ( gmpCurModule->playFlags.linFreqTable )
            {
                /* Kool: */
                *rate = gmpLinTable[period % 768] >> (period / 768);
//                Frequency = 8363*2^((6*12*16*4 - Period) / (12*16*4));
            }
            else
            {
                *rate = 8363L * 1712L / ((ulong) period);
            }
            break;

        case gmpST3:
            *rate = 14317056L / ((ulong) period);
            break;
    }

    return OK;
}




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

int gmpSetPeriod(unsigned period)
{
    /* Skip if period is zero: */
    if ( period == 0 )
        return OK;

    /* Limit period value within current limits: */
    if ( period < gmpHandle->perLimitLow )
        period = gmpHandle->perLimitLow;
    if ( period > gmpHandle->perLimitUp )
        period = gmpHandle->perLimitUp;

    /* Set period value to channel: */
    gmpChan->period = period;
    gmpChan->realPeriod = period;
    return OK;
}




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

int gmpChangePeriod(unsigned period)
{
    /* Limit period value within current limits: */
    if ( period < gmpHandle->perLimitLow )
        period = gmpHandle->perLimitLow;
    if ( period > gmpHandle->perLimitUp )
        period = gmpHandle->perLimitUp;

    gmpChan->realPeriod = period;
    return OK;
}




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

int gmpSetVolume(int volume)
{
    /* Limit volume: */
    if ( volume < 0 )
        volume = 0;
    if ( volume > (int) gmpHandle->volLimit )
        volume = gmpHandle->volLimit;

    /* Set volume to channel structure: */
    gmpChan->volume = volume;

    /* Set volume to Sound Device: */
    gmpChan->realVolume = volume;
    return OK;
}




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

int gmpChangeVolume(int volume)
{
    /* Limit volume: */
    if ( volume < 0 )
        volume = 0;
    if ( volume > (int) gmpHandle->volLimit )
        volume = gmpHandle->volLimit;

    gmpChan->realVolume = volume;

    return OK;
}


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

int gmpSetPanning(int panning)
{
    int         error;

    switch ( gmpPlayMode )
    {
        case gmpFT2:
            if ( panning < 0 ) panning = 0;
            if ( panning > 255 ) panning = 255;
            break;

        default:
            /* Convert DMP-compatible panning value to MIDAS and set it to
               Sound Device: */
            if ( panning == 0xA4 )
            {
                panning = panSurround;
            }
            else
            {
                panning -= 0x40;
                if ( panning < panLeft )
                    panning = panLeft;
                if ( panning > panRight )
                    panning = panRight;
            }

            if ( (error = gmpSD->SetPanning(gmpChan->sdChannel, panning))
                != OK )
                PASSERROR(ID_gmpSetPanning)
            break;
    }

    DEBUGprintf("Set pan %i\n", (int) panning);
    gmpChan->panning = panning;

    return OK;
}

/****************************************************************************\
*
* Function:     int gmpNewNote(void)
*
* Description:  Plays the new note on the current channel
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpNewNote(void)
{
    int         error;

    /* Clear vibrato position: */
    gmpChan->vibPos = 0;

    /* Check if there is a valid instrument: */
    if ( (gmpChan->instrument != -1) && (gmpChan->sample != 0xFF) )
    {
        /* Check if the note is a key off command: */
        if ( gmpChan->note == 0xFE )
        {
            switch ( gmpPlayMode )
            {
                case gmpFT2:
                    gmpChan->keyOff = 1;
                    gmpChan->volSustained = 0;
                    gmpChan->panSustained = 0;

                    if ( (gmpCurModule->instruments[gmpChan->instrument]
                            ->volEnvelope == NULL) &&
                        (!gmpChan->status.newInst) )
                            gmpSetVolume(0);
                    break;

                case gmpST3:
                    if ( (error = gmpSD->StopSound(gmpChan->sdChannel)) != OK )
                        PASSERROR(ID_gmpNewNote)

                    break;

                default:
                    /* Release sound: */
                    if ( (error = gmpSD->ReleaseSound(gmpChan->sdChannel)) != OK )
                        PASSERROR(ID_gmpNewNote)

                    /* Mark channel released: */
                    /* FIXME */
                    break;
            }
        }
        else
        {
            /*gmpChan->keyOff = 0;*/
            /* It would make sense to reset keyOff here, but it shouldn't
               be done - FT2 continues the fade out, for example, until
               a new instrument is set, even if there are new notes */

            gmpChan->prevNote = gmpChan->note;

            /* Set channel period to new note period: */
            if ( (error = gmpNotePeriod(gmpChan->note, &gmpChan->period))
                != OK )
                PASSERROR(ID_gmpNewNote)

            /* Retrig note - start playing with new period: */
            if ( (error = gmpPlayNote(gmpChan->period)) != OK )
                PASSERROR(ID_gmpNewNote)

            /* Set playing position to startOffset if it has been
                changed by a Sample Offset command: */
            if ( gmpChan->startOffset != 0 )
            {
                if ( (error = gmpSD->SetPosition(gmpChan->sdChannel,
                    gmpChan->startOffset)) != OK)
                    PASSERROR(ID_gmpNewNote)
            }
        }
    }

    /* Mark there is no new note: */
    gmpChan->status.newNote = 0;

    return OK;
}




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
    unsigned row))
{
    playHandle->SyncCallback = SyncCallback;

    return OK;
}




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

int CALLING gmpSetPosition(gmpPlayHandle playHandle, int newPosition)
{
    unsigned    oldPos = playHandle->position;
    int         pos, songLength;
    ushort      *song;

    song = playHandle->module->songData;
    songLength = (int) playHandle->module->songLength;

    pos = newPosition;
    if ( pos > songLength )
        pos = playHandle->restartPos;
    if ( pos < 0 )
        pos = songLength-1;

    /* Skip possible ST3 song filler entries: */
    if ( pos < (int) oldPos )
    {
        while ( (song[pos] == 0xFFFE) || (song[pos] == 0xFFFF) )
            if ( (--pos) < 0 )
                pos = songLength-1;
    }
    else
    {
        while ( (song[pos] == 0xFFFE) || (song[pos] == 0xFFFF) )
            if ( (++pos) < 0 )
                pos = playHandle->restartPos;
    }

    /* Start at the beginning of the new pattern: */
    playHandle->row = 0;
    playHandle->playPtr = NULL;
    playHandle->position = pos;
    playHandle->pattern = song[pos];

    return OK;
}

/*
 * $Log: gmplayer.c,v $
 * Revision 1.13  1997/02/05 15:30:59  pekangas
 * Added sanity checking to gmpSetPanning() - this fixes some annoying
 * crashes with a few S3Ms.
 *
 * Revision 1.12  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.11  1997/01/16 18:30:31  pekangas
 * Fixed XM note fadeouts
 *
 * Revision 1.10  1997/01/07 19:18:15  pekangas
 * Fixed changing instrument w/o note in XMs
 *
 * Revision 1.9  1996/10/06 16:48:24  pekangas
 * Fixed an overflow problem in XM panning and added some checks
 *
 * Revision 1.8  1996/09/08 20:32:31  pekangas
 * gmpRunEnvelopes() no longer tries to set zero periods to SD
 *
 * Revision 1.7  1996/09/01 15:41:11  pekangas
 * Changed command handling for FT2 - all commands have now a separate old infobyte
 *
 * Revision 1.6  1996/07/16 20:25:09  pekangas
 * Removed Watcom C warnings
 *
 * Revision 1.5  1996/07/13 20:04:34  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.4  1996/07/13 18:22:30  pekangas
 * Fixed to compile with Visual C
 *
 * Revision 1.3  1996/06/13 20:01:43  pekangas
 * Fixed a bug that crashed MIDAS if the song set tempo to 0
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Fixed to work with gcc
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/
