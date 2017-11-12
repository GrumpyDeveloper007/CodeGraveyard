/*      NOSOUND.C
 *
 * No Sound Sound Device, v2.00. A really stupid one.
 *
 * $Id: nosound.c,v 1.2 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

/* None of these functions can fail and practically none of them does
   anything. */

#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "sdevice.h"

RCSID(const char *nosound_rcsid = "$Id: nosound.c,v 1.2 1997/01/16 18:41:59 pekangas Exp $";)


    /* A lot of functions do not use their arguments: */
#ifdef __WATCOMC__
#pragma off (unreferenced)
#endif




/* Names and stuff: */
char            *nsndCard = "No Sound";


/* Variables: */
static unsigned curSmpHandle;

/* And now the functions - coded with regexp search and replace */


int CALLING nsndDetect(int *result)
{
    *result = 1;
    return OK;
}


int CALLING nsndInit(unsigned mixRate, unsigned mode)
{
    curSmpHandle = 1;
    return OK;
}


int CALLING nsndClose(void)
{
    return OK;
}


int CALLING nsndGetMixRate(unsigned *mixRate)
{
    *mixRate = 44100;
    return OK;
}


int CALLING nsndGetMode(unsigned *mode)
{
    *mode = sdStereo | sd16bit;
    return OK;
}


int CALLING nsndOpenChannels(unsigned channels)
{
    return OK;
}


int CALLING nsndCloseChannels(void)
{
    return OK;
}


int CALLING nsndClearChannels(void)
{
    return OK;
}


int CALLING nsndMute(int mute)
{
    return OK;
}


int CALLING nsndPause(int pause)
{
    return OK;
}


int CALLING nsndSetMasterVolume(unsigned masterVolume)
{
    return OK;
}


int CALLING nsndGetMasterVolume(unsigned *masterVolume)
{
    *masterVolume = 0;
    return OK;
}


int CALLING nsndSetAmplification(unsigned amplification)
{
    return OK;
}


int CALLING nsndGetAmplification(unsigned *amplification)
{
    *amplification = 64;
    return OK;
}


int CALLING nsndPlaySound(unsigned channel, ulong rate)
{
    return OK;
}


int CALLING nsndReleaseSound(unsigned channel)
{
    return OK;
}


int CALLING nsndStopSound(unsigned channel)
{
    return OK;
}


int CALLING nsndSetRate(unsigned channel, ulong rate)
{
    return OK;
}


int CALLING nsndGetRate(unsigned channel, ulong *rate)
{
    *rate = 0;
    return OK;
}


int CALLING nsndSetVolume(unsigned channel, unsigned volume)
{
    return OK;
}


int CALLING nsndGetVolume(unsigned channel, unsigned *volume)
{
    *volume =0;
    return OK;
}


int CALLING nsndSetSample(unsigned channel, unsigned smpHandle)
{
    return OK;
}


int CALLING nsndGetSample(unsigned channel, unsigned *smpHandle)
{
    *smpHandle = 0;
    return OK;
}


int CALLING nsndSetPosition(unsigned channel, unsigned pos)
{
    return OK;
}


int CALLING nsndGetPosition(unsigned channel, unsigned *pos)
{
    *pos = 0;
    return OK;
}


int CALLING nsndGetDirection(unsigned channel, int *direction)
{
    *direction = 1;
    return OK;
}


int CALLING nsndSetPanning(unsigned channel, int panning)
{
    return OK;
}


int CALLING nsndGetPanning(unsigned channel, int *panning)
{
    *panning = panMiddle;
    return OK;
}


int CALLING nsndMuteChannel(unsigned channel, int mute)
{
    return OK;
}


int CALLING nsndAddSample(sdSample *sample, int copySample,
    unsigned *smpHandle)
{
    *smpHandle = curSmpHandle;
    curSmpHandle++;
    if ( curSmpHandle > 255 )
        curSmpHandle = 1;

    return OK;
}


int CALLING nsndRemoveSample(unsigned smpHandle)
{
    return OK;
}


int CALLING nsndSetUpdRate(unsigned updRate)
{
    return OK;
}


int CALLING nsndStartPlay(void)
{
    return OK;
}


int CALLING nsndPlay(int *callMP)
{
    *callMP = 1;
    return OK;
}


/* And the struct: */

SoundDevice NoSound = {
    1,                                  /* Poll to tempo */
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    "No Sound Sound Device v2.00",
    &nsndCard,
    0,
    NULL,
    &nsndDetect,
    &nsndInit,
    &nsndClose,
    &nsndGetMixRate,
    &nsndGetMode,
    &nsndOpenChannels,
    &nsndCloseChannels,
    &nsndClearChannels,
    &nsndMute,
    &nsndPause,
    &nsndSetMasterVolume,
    &nsndGetMasterVolume,
    &nsndSetAmplification,
    &nsndGetAmplification,
    &nsndPlaySound,
    &nsndReleaseSound,
    &nsndStopSound,
    &nsndSetRate,
    &nsndGetRate,
    &nsndSetVolume,
    &nsndGetVolume,
    &nsndSetSample,
    &nsndGetSample,
    &nsndSetPosition,
    &nsndGetPosition,
    &nsndGetDirection,
    &nsndSetPanning,
    &nsndGetPanning,
    &nsndMuteChannel,
    &nsndAddSample,
    &nsndRemoveSample,
    &nsndSetUpdRate,
    &nsndStartPlay,
    &nsndPlay
};


/*
 * $Log: nosound.c,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/