/*      gmpcmds.c
 *
 * Generic Module Player command handling
 *
 * $Id: gmpcmds.c,v 1.7 1997/02/05 13:43:33 pekangas Exp $
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
#include "sdevice.h"
#include "gmplayer.h"

RCSID(const char *gmpcmds_rcsid = "$Id: gmpcmds.c,v 1.7 1997/02/05 13:43:33 pekangas Exp $";)



/* Commands that support continuing with previous infobyte in case of a zero
   infobyte in pattern data use the infobyte passed as an arguments, others
   just take the value from the channel structure. */

/* Protracker-compatible vibrato table: */
static uchar    ptVibratoTable[32] =
    { 0, 24, 49, 74, 97, 120, 141, 161, 180, 197, 212, 224, 235, 244, 250,
      253, 255, 253, 250, 244, 235, 224, 212, 197, 180, 161, 141, 120, 97,
      74, 49, 24 };

/* volume fade tables for Retrig Note: */
static signed char retrigTable1[16] =
    { 0, 0, 0, 0, 0, 0, 10, 8, 0, 0, 0, 0, 0, 0, 24, 32 };

static signed char retrigTable2[16] =
    { 0, -1, -2, -4, -8, -16, 0, 0, 0, 1, 2, 4, 8, 16, 0, 0 };




/* No command: */
static int gmpCmdEmpty(void)
{
    return OK;
}


/* Set speed: */
static int gmpCmdSetSpeed(void)
{
    if (gmpChan->infobyte != 0 )
        gmpHandle->speed = gmpChan->infobyte;
    else
    {
        switch ( gmpPlayMode )
        {
            case gmpST3:
                break;

            default:
                /* Restart song */

                gmpHandle->position = gmpHandle->restartPos;

                /* Get the pattern number for new position: */
                gmpHandle->pattern = gmpCurModule->songData[gmpHandle->position];

                /* Set pattern data pointer to NULL to mark playing position
                    has changed: */
                gmpHandle->playPtr = NULL;
                gmpHandle->row = 0;
                break;
        }
    }
    return OK;
}


/* Set tempo in BPM: */
static int gmpCmdSetTempo(void)
{
    /* We will just ignore tempos below 32 - ST3 and FT2 do that and with PT
       you just can't set tempos below that */
    if ( gmpChan->infobyte < 32 )
        return OK;

    return gmpSetTempo(gmpChan->infobyte);
}


/* Set volume: */
static int gmpCmdSetVolume(void)
{
    return gmpSetVolume(gmpChan->infobyte);
}

/* Set master volume: */
static int gmpCmdSetMVolume(void)
{
    gmpHandle->masterVolume = gmpChan->infobyte;
    if ( gmpHandle->masterVolume > 64 )
        gmpHandle->masterVolume = 64;
    return OK;
}

/* Set panning: */
static int gmpCmdSetPanning(void)
{
    return gmpSetPanning(gmpChan->infobyte);
}


/* Volume slide: */
static int gmpCmdVolSlide(unsigned infobyte)
{
    switch ( gmpPlayMode )
    {
        case gmpST3:
            if ( ((infobyte & 0x0F) == 0x0F) && ((infobyte & 0xF0) != 0) )
            {
                /* The lower nybble is 0xF, and the upper nybble is nonzero
                   - fine volume slide up (if the upper nybble is zero, ST3
                   does a normal volume slide down with speed 0xF) */

                if ( gmpHandle->playCount == 0 )
                    return gmpSetVolume(gmpChan->volume +
                        (infobyte >> 4));
                else
                    return OK;
            }

            if ( ((infobyte & 0xF0) == 0xF0) && ((infobyte & 0x0F) != 0) )
            {
                /* The upper nybble is 0xF and the lower nybble is nonzero
                   - fine volume slide down (if the lower nybble is zero, ST3
                   does a normal volume slide up with speed 0xF) */
                if ( gmpHandle->playCount == 0 )
                    return gmpSetVolume((int)gmpChan->volume -
                        (int)(infobyte & 0x0F));
                else
                    return OK;
            }

            /* We are doing a normal volume slide */

            if ( (infobyte & 0x0F) != 0 )
            {
                /* The lower nybble is set - do a volume slide down */
                /* Note! ST3 does the check in _this_ order, PT and FT2 the
                   other way around! */

                if ( (gmpCurModule->playFlags.fastVolSlides) ||
                     (gmpHandle->playCount != 0) )
                    return gmpSetVolume((int)gmpChan->volume -
                        (int)(infobyte & 0x0F));
                    else
                        return OK;
            }

            /* The lower nybble was not set - do a volume slide up: */
            if ( (gmpCurModule->playFlags.fastVolSlides) ||
                 (gmpHandle->playCount != 0) )
                return gmpSetVolume(gmpChan->volume + (infobyte >> 4));

            return OK;

        case gmpFT2:
            /* FT2 playing mode - if the infobyte is zero, use the old
               volume slide infobyte */
            if ( !infobyte )
                infobyte = gmpChan->volSlideInfobyte;
            else
                gmpChan->volSlideInfobyte = infobyte;

            /* FALL THROUGH to combined PT and FT2 volume slide code! */

        default:
            /* The volume slide for PT and FT2 */

            if ( (infobyte & 0xF0) != 0 )
            {
                /* The upper nybble is set - do volume slide up */
                /* Note! We don't need to check the play count as this command
                   won't be called on 0-ticks */
                return gmpSetVolume(gmpChan->volume + (infobyte >> 4));
            }

            /* Do volume slide down: */
            return gmpSetVolume((int)gmpChan->volume - (int)(infobyte & 0xF));
    }
}


/* Master volume slide: */
static int gmpCmdMVolSlide(unsigned infobyte)
{
    int         newMasterVol = gmpHandle->masterVolume;

    if ( (infobyte & 0xF0) != 0 )
    {
        /* The upper nybble is set - slide up */
        newMasterVol += (int) (infobyte >> 4);
    }
    else
    {
        /* Slide down: */
        newMasterVol -= (int) (infobyte & 0x0F);
    }

    /* Clip master volume: */
    if ( newMasterVol < 0 )
        newMasterVol = 0;
    if ( newMasterVol > 64 )
        newMasterVol = 64;

    gmpHandle->masterVolume = newMasterVol;

    return OK;
}


/* Fine volume slide up: */
static int gmpCmdFineVolSlideUp(unsigned infobyte)
{
    return gmpSetVolume(gmpChan->volume + infobyte);
}


/* Fine volume slide down */
static int gmpCmdFineVolSlideDown(unsigned infobyte)
{
    return gmpSetVolume((int)gmpChan->volume - (int)infobyte);
}


/* Panning slide: */
static int gmpCmdPanSlide(unsigned infobyte)
{
    if ( (infobyte & 0xF0) != 0 )
    {
        /* Upper nybble is nonzero - slide right */
        return gmpSetPanning(gmpChan->panning + (infobyte >> 4));
    }

    /* Upper nybble is zero - slide left: */
    return gmpSetPanning((int) gmpChan->panning - (int) (infobyte & 0x0F));
}


/* Period slide up: */
static int gmpCmdSlideUp(unsigned infobyte)
{
    if ( gmpPlayMode == gmpST3 )
    {
        if ( infobyte < 0xE0 )
        {
            if ( gmpHandle->playCount != 0 )
                return gmpSetPeriod(gmpChan->period - (((int) infobyte) <<
                    gmpHandle->perMultiplier));
            else
                return OK;
        }
        else
        {
            if ( gmpHandle->playCount == 0 )
            {
                if ( infobyte < 0xF0 )
                    return gmpSetPeriod(gmpChan->period - (infobyte & 0xF));
                else
                    return gmpSetPeriod(gmpChan->period -
                        (((int) infobyte & 0xF) << gmpHandle->perMultiplier));
            }
            else
                return OK;
        }
    }
    else
        return gmpSetPeriod(gmpChan->period - (((int) infobyte) <<
            gmpHandle->perMultiplier));
}


/* Period slide down: */
static int gmpCmdSlideDown(unsigned infobyte)
{
    if ( gmpPlayMode == gmpST3 )
    {
        if ( infobyte < 0xE0 )
        {
            if ( gmpHandle->playCount != 0 )
                return gmpSetPeriod(gmpChan->period + (((int) infobyte) <<
                    gmpHandle->perMultiplier));
            else
                return OK;
        }
        else
        {
            if ( gmpHandle->playCount == 0 )
            {
                if ( infobyte < 0xF0 )
                    return gmpSetPeriod(gmpChan->period + (infobyte & 0xF));
                else
                    return gmpSetPeriod(gmpChan->period +
                        (((int) infobyte & 0xF) << gmpHandle->perMultiplier));
            }
            else
                return OK;
        }
    }
    else
        return gmpSetPeriod(gmpChan->period + (((int) infobyte) <<
            gmpHandle->perMultiplier));
}


/* Fine period slide up: */
static int gmpCmdFineSlideUp(unsigned infobyte)
{
    return gmpSetPeriod(gmpChan->period - (((int) infobyte) <<
        gmpHandle->perMultiplier));
}


/* Fine period slide down: */
static int gmpCmdFineSlideDown(unsigned infobyte)
{
    return gmpSetPeriod(gmpChan->period - (((int) infobyte) >>
        gmpHandle->perMultiplier));
}


/* Extra fine period slide up: */
static int gmpCmdExtraFineSlideUp(unsigned infobyte)
{
    return gmpSetPeriod((int)gmpChan->period - (int)infobyte);
}


/* Extra fine period slide down: */
static int gmpCmdExtraFineSlideDown(unsigned infobyte)
{
    return gmpSetPeriod(gmpChan->period + infobyte);
}


/* Do the actual tone portamento */
static int doTonePortamento(unsigned infobyte)
{
    unsigned    tpSpeed;

    /* Skip if portamento destination is zero: */
    if ( gmpChan->tpDest == 0 )
        return OK;

    /* If command infobyte is not zero, use it as new tone portamento speed: */
    if ( infobyte != 0 )
        gmpChan->tpSpeed = infobyte;

    /* Skip if channel period already equals tone portamento destination: */
    if ( gmpChan->period == gmpChan->tpDest )
        return OK;

    tpSpeed = ((unsigned) gmpChan->tpSpeed) << gmpHandle->perMultiplier;

    if ( gmpChan->period < gmpChan->tpDest )
    {
        /* Period is below tone portamento destination - check if we'd reach
           the portamento destination this time. If yes, set the tone
           portamento destination as new period, otherwise just increase
           the period: */
        if ( (gmpChan->period + tpSpeed) >= gmpChan->tpDest )
            return gmpSetPeriod(gmpChan->tpDest);
        else
            return gmpSetPeriod(gmpChan->period + tpSpeed);
    }
    else
    {
        /* Period is above tone portamento destination. Check if we'd reach
           the destination this time, and if so, set the destination as the
           new period. Otherwise just decrease the period: */
        if ( (gmpChan->period - gmpChan->tpDest) <= tpSpeed)
            return gmpSetPeriod(gmpChan->tpDest);
        else
            return gmpSetPeriod(gmpChan->period - tpSpeed);
    }
}


/* Tone portamento: */
static int gmpCmdTonePortamento(void)
{
    return doTonePortamento(gmpChan->infobyte);
}


/* Set tone portamento: */
static int gmpCmdSetTonePorta(void)
{
    int         error;

    /* If there is a new note, set its period as tone portamento destination
       and clear the new note flag so that the sound won't be retrigged: */
    if ( (gmpChan->status.newNote) && (gmpChan->instrument != -1)
        && (gmpChan->sample != 0xFF) && ( gmpChan->note != 0xFE ))
    {
        if ( (error = gmpNotePeriod(gmpChan->note, &gmpChan->tpDest))
            != OK )
            return error;
        gmpChan->status.newNote = 0;
    }

    return OK;
}


/* Tone Portamento + Volume Slide: */
static int gmpCmdTPortVSlide(unsigned infobyte)
{
    int         error;

    /* Do the volume slide using current infobyte: */
    if ( (error = gmpCmdVolSlide(infobyte)) != OK )
        return error;

    /* Do the tone portamento using previous portamento speed: */
    return doTonePortamento(0);
}


/* Do vibrato command: */
static int doVibrato(unsigned infobyte)
{
    unsigned    vibPer;
    int         error;

    /* If infobyte lower nybble is nonzero, use it as new vibrato depth: */
    if ( (infobyte & 0x0F) != 0 )
        gmpChan->vibDepth = infobyte & 0x0F;

    /* If infobyte upper nybble is nonzero, use it as new vibrato speed: */
    if ( (infobyte & 0xF0) != 0 )
        gmpChan->vibSpeed = infobyte >> 4;

    /* Get vibrato value from vibrato table and scale it with the vibrato
       depth: */
    vibPer = (((unsigned) ptVibratoTable[gmpChan->vibPos & 31]) *
        ((unsigned) gmpChan->vibDepth)) >> (7 - gmpHandle->perMultiplier);

    /* If vibrato position bit 5 is 0, add value to period, otherwise
       substract it: */
    if ( (gmpChan->vibPos & 32) == 0 )
        error = gmpChangePeriod(gmpChan->period + vibPer);
    else
        error = gmpChangePeriod(gmpChan->period - vibPer);

    /* Update vibrato position: */
    gmpChan->vibPos += gmpChan->vibSpeed;

    return error;
}


/* Vibrato: */
static int gmpCmdVibrato(void)
{
    return doVibrato(gmpChan->infobyte);
}


/* Vibrato and volume slide: */
static int gmpCmdVibVSlide(unsigned infobyte)
{
    int         error;

    /* Do the volume slide using current infobyte: */
    if ( (error = gmpCmdVolSlide(infobyte)) != OK )
        return error;

    /* Do the vibrato using previous values: */
    return doVibrato(0);
}


/* Sample Offset: */
static int gmpCmdSampleOffset(void)
{
    int         error;
    unsigned    soAdd;

    /* If infobyte is nonzero, use it as new sample offset value: */
    if ( gmpChan->infobyte != 0 )
        gmpChan->smpOffset = gmpChan->infobyte;

    /* Calculate sample offset in bytes: */
    soAdd = ((unsigned) gmpChan->smpOffset) << 8;

    /* Check if there is a new note: */
    if ( gmpChan->status.newNote )
    {
        /* FT2 simply sets the new sample offset as the note start offset,
           others add it there: */
        if ( gmpPlayMode == gmpFT2 )
            gmpChan->startOffset = soAdd;
        else
            gmpChan->startOffset += soAdd;

        /* Play the note: */
        if ( (error = gmpNewNote()) != OK )
            return error;
    }

    /* Now increase new note start offset again - next note will be
       started from 2*sampleoffset unless a new instrument is set:
       (Protracker "feature") */
    if ( gmpPlayMode == gmpPT)
        gmpChan->startOffset += soAdd;

    return OK;
}


/* Set note retrig count: (retrig note on tick 0) */
static int gmpCmdSetRetrig(void)
{
    gmpChan->retrigCount = 1;
    return OK;
}


/* Retrig note: */
static int gmpCmdRetrigNote(unsigned infobyte)
{
    int         error;

    /* FIXME! */
    if ( gmpPlayMode == gmpST3 )
        gmpChan->infobyte = infobyte;

    /* No retrig if channel infobyte is zero: */
    if ( gmpChan->infobyte != 0 )
    {
        /* Check if note needs to be retriggered: */
        if ( gmpChan->retrigCount >= (gmpChan->infobyte & 0xF) )
        {
            /* Retrig note - set playing position to startOffset: */
            if ( (error = gmpSD->SetPosition(gmpChan->sdChannel,
                gmpChan->startOffset)) != OK )
                return error;

            /* Reset retrig counter: */
            gmpChan->retrigCount = 0;
        }
    }

    /* Increase retrig counter: */
    gmpChan->retrigCount++;

    return OK;
}


/* ST3 Retrig note: */
static int gmpCmdS3MRetrig(unsigned infobyte)
{
    int         error, i;

    /* No retrig if channel infobyte is zero: */

    /* Check if note needs to be retriggered: */
    if ( gmpChan->retrigCount >= (infobyte & 0xF) )
    {
        /* Retrig note - set playing position to startOffset: */
        if ( (error = gmpSD->SetPosition(gmpChan->sdChannel,
            gmpChan->startOffset)) != OK )
            return error;

        /* Reset retrig counter: */
        gmpChan->retrigCount = 0;


        i = ( infobyte & 0xf0 ) >> 4;
        if ( retrigTable1[i] == 0 )
            i = gmpChan->volume + retrigTable2[i];
        else
            i = ( gmpChan->volume * retrigTable1[i] ) >> 4;

        error = gmpSetVolume( i );
        if ( error != OK )
            return error;
    }

    /* Increase retrig counter: */
    gmpChan->retrigCount++;
    return OK;
}


/* Position Jump: */
static int gmpCmdPositionJump(void)
{
    /* Break to next position: */
    gmpHandle->position = (unsigned)gmpChan->infobyte;

    /* Check if we reached song length, and if so, jump to restart
        position: */
    if ( gmpHandle->position > gmpHandle->songEnd )
    {
        gmpHandle->position = gmpHandle->restartPos;
    }

    /* Get the pattern number for new position: */
    gmpHandle->pattern = gmpCurModule->songData[gmpHandle->position];

    /* Set pattern data pointer to NULL to mark playing position
        has changed: */
    gmpHandle->playPtr = NULL;

    gmpHandle->row = 0;

    /* Reset pattern loop destination row if playing ST3 module: */
    if ( gmpPlayMode == gmpST3 )
        gmpHandle->loopRow = 0;

    return OK;
}

/* Pattern Break: */
static int gmpCmdPatternBreak(void)
{
    if ( gmpHandle->playPtr != NULL )
    {
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

        /* Reset pattern loop destination row if playing ST3 module: */
        if ( gmpPlayMode == gmpST3 )
            gmpHandle->loopRow = 0;
    }

    /* infobyte is new row number: (IN BCD FORMAT!) */
    if ( gmpChan->infobyte <= 0x63 )
        gmpHandle->row = (gmpChan->infobyte & 0x0F) +
        ((gmpChan->infobyte >> 4) * 10);
    else
        gmpHandle->row = 63;

    return OK;
}


/* Note Cut: */
static int gmpCmdNoteCut(void)
{
    /* Cut note by setting volume to zero if play counter equals infobyte: */
    if ( gmpHandle->playCount == gmpChan->infobyte )
        return gmpSetVolume(0);
    else
        return OK;
}


/* Set Note Delay: (Note Delay at tick 0) */
static int gmpCmdSetNoteDelay(void)
{
    /* If infobyte is 0 or there is no new note, play normally: */
    if ( (gmpChan->infobyte == 0) || (!gmpChan->status.newNote) )
    {
        gmpChan->status.noteDelay = 0;      /* no note delay */
        return OK;
    }

    /* Mark there is a valid new note for note delay, and do not play it
       normally: */
    gmpChan->status.noteDelay = 1;
    gmpChan->status.newNote = 0;
    return OK;
}


/* Note Delay: */
static int gmpCmdNoteDelay(void)
{
    /* If infobyte equals player counter and there is a valid new note for
       note delay, start the new note: */
    if ( (gmpHandle->playCount == gmpChan->infobyte) &&
        (gmpChan->status.noteDelay) )
    {
        return gmpNewNote();
    }

    return OK;
}


/* Pattern Delay: */
static int gmpCmdPatternDelay(void)
{
    /* Set pattern delay counter to infobyte if pattern delay is not in
       progress: */
    if ( gmpHandle->pattDelayCount == 0 )
        gmpHandle->pattDelayCount = gmpChan->infobyte;
    return OK;
}



/* Set 16-point panning value: */
static int gmpCmdSetPanning16(void)
{
    int         panValue;

    panValue = gmpChan->infobyte;
    if ( panValue < 7 )
    {
        panValue = 8 * panValue;
    }
    else
    {
        if ( panValue > 8 )
            panValue = 0x80 - (15 - panValue) * 8;
        else
            panValue = 0x40;
    }

    return gmpSetPanning(panValue);
}


/* Arpeggio: */
static int gmpCmdArpeggio(unsigned infobyte)
{
    static unsigned newPeriod;
    int         error;
    int         note = gmpChan->note & 0x0F;
    int         oct = (gmpChan->note >> 4) & 0x0F;

    /* Make sure that we have a valid instrument: */
    if ( (gmpChan->instrument != -1) && (gmpChan->sample != 0xFF) )
    {
        /* Check that current note is not key off: */
        if ( gmpChan->note == 0xFE )
            return OK;

        /* Add correct infobyte nybble to note number: */
        switch ( gmpHandle->playCount % 3 )
        {
            case 0:
                break;

            case 1:
                note += (infobyte >> 4) & 0x0F;
                break;

            case 2:
                note += infobyte & 0x0F;
                break;
        }

        /* Update octave if necessary: */
        if ( note > 11 )
        {
            oct++;
            note -= 12;
        }

        if ( (gmpPlayMode == gmpPT) && (!gmpCurModule->playFlags.extOctaves) )
        {
            /* Playing a Protracker module with extended octaves disabled -
               take care of arpeggio wrap: */
            if ( oct > 3 )
                oct -= 3;
            /* Actually we should increment finetune here and play random
               trash if finetune was 0x0F... */
        }

        note |= oct << 4;

        /* Get new note period value: */
        if ( (error = gmpNotePeriod(note, &newPeriod)) != OK )
            return error;

        /* Set new period value: */
        if ( (error = gmpChangePeriod(newPeriod)) != OK )
            return error;
    }

    return OK;
}



/* Music synchronization: */
static int gmpCmdMusicSync(void)
{
    /* Set synchronization info to handle: */
    gmpHandle->syncInfo = gmpChan->infobyte;

    /* Call music synchronization callback function if set: */
    if ( gmpHandle->SyncCallback != NULL )
    {
        gmpHandle->SyncCallback(gmpChan->infobyte, gmpHandle->position,
            gmpHandle->row);
    }

    return OK;
}



static int gmpCmdPatternLoop(void)
{
    uchar       info = gmpChan->infobyte;
    int         jump = -1;

    /* Pattern loop is handled differently for Scream Tracker 3 modules -
       in PT and FT2 modules each channel has its own pattern loop info and
       the loops can be nested, while in ST3 the values are global for the
       whole song. Also, in ST3 the pattern loop destination row is reset
       to zero for each new pattern, while in PT and FT2 the values from
       the previous pattern are used. */
    if ( gmpPlayMode == gmpST3 )
    {
        if ( info == 0 )
        {
            /* Infobyte = 0 - set pattern loop start row: */
            gmpHandle->loopRow = gmpHandle->row;
        }
        else
        {
            /* Infobyte != 0 - set loop count if not already looping: */
            if ( gmpHandle->loopCount == 0 )
            {
                gmpHandle->loopCount = info;
                jump = gmpHandle->loopRow;
            }
            else
            {
                /* Already looping - jump to loop start if loop counter
                   is not yet zero: */
                gmpHandle->loopCount--;
                if ( gmpHandle->loopCount > 0 )
                    jump = gmpHandle->loopRow;
            }
        }
    }
    else
    {
        if ( info == 0 )
        {
            /* Infobyte = 0 - set pattern loop start row: */
            gmpChan->loopRow = gmpHandle->row;
        }
        else
        {
            /* Infobyte != 0 - set loop count if not already looping: */
            if ( gmpChan->loopCount == 0 )
            {
                gmpChan->loopCount = info;
                jump = gmpChan->loopRow;
            }
            else
            {
                /* Already looping - jump to loop start if loop counter
                   is not yet zero: */
                gmpChan->loopCount--;
                if ( gmpChan->loopCount > 0 )
                    jump = gmpChan->loopRow;
            }
        }
    }

    /* Jump to loop start row if necessary: */
    if ( jump != -1 )
    {
        gmpHandle->row = jump;
        gmpHandle->playPtr = NULL;
    }

    return OK;
}





/****************************************************************************\
*
* Function:     int gmpSetVolCommand(void)
*
* Description:  Runs tick-0 volume column command for current channel (FT2)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpSetVolCommand(void)
{
    int         infobyte = gmpChan->volColumn & 0x0F;

    switch ( gmpChan->volColumn & 0xF0 )
    {
        case 0x80:
            /* Fine volume slide down: */
            return gmpSetVolume(gmpChan->volume - infobyte);

        case 0x90:
            /* Fine volume slide up: */
            return gmpSetVolume(gmpChan->volume + infobyte);

        case 0xA0:
            /* Set vibrato speed: */
            gmpChan->vibSpeed = infobyte;
            break;

        case 0xC0:
            /* Set panning: */
            return gmpSetPanning(infobyte | (infobyte << 4));
            break;

        case 0xF0:
            /* Tone portamento: */
            return gmpCmdSetTonePorta();
            break;
    }

    return OK;
}

/*
      0       Do nothing
    $10-$50   Set volume Value-$10
      :          :        :
      :          :        :
    $60-$6f   Volume slide down
    $70-$7f   Volume slide up
    $80-$8f   Fine volume slide down
    $90-$9f   Fine volume slide up
    $a0-$af   Set vibrato speed
    $b0-$bf   Vibrato
    $c0-$cf   Set panning
    $d0-$df   Panning slide left
    $e0-$ef   Panning slide right
    $f0-$ff   Tone porta
*/


/****************************************************************************\
*
* Function:     int gmpRunVolCommand(void)
*
* Description:  Runs continuous volume column command for current channel
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int gmpRunVolCommand(void)
{
    int         infobyte = gmpChan->volColumn & 0x0F;

    switch ( gmpChan->volColumn & 0xF0 )
    {
        case 0x60:
            /* Volume slide down: */
            return gmpSetVolume((int)gmpChan->volume - infobyte);

        case 0x70:
            /* Volume slide up: */
            return gmpSetVolume((int)gmpChan->volume + infobyte);

        case 0xB0:
            /* Vibrato: */
            return doVibrato(infobyte);

        case 0xD0:
            /* Panning slide left: */
            return gmpSetPanning((int)gmpChan->panning - infobyte);

        case 0xE0:
            /* Panning slide right: */
            return gmpSetPanning((int)gmpChan->panning + infobyte);

        case 0xF0:
            /* Tone portamento: */
            return doTonePortamento(infobyte << 4);
    }

    /*
      0       Do nothing
    $10-$50   Set volume Value-$10
      :          :        :
      :          :        :
    $60-$6f   Volume slide down
    $70-$7f   Volume slide up
    $80-$8f   Fine volume slide down
    $90-$9f   Fine volume slide up
    $a0-$af   Set vibrato speed
    $b0-$bf   Vibrato
    $c0-$cf   Set panning
    $d0-$df   Panning slide left
    $e0-$ef   Panning slide right
    $f0-$ff   Tone porta
    */

    return OK;
}



/* Type cast for pointer to a command function: (Commands that do not use
   their info byte have been made int command(void) to avoid warnings.
   Note that even though this is safe under all supported compilers it might
   fail with some architechtures.) */ /*!!*/
#define CMD (int (*)(unsigned))


    /* Protracker playing mode tick-0 commands: */
int (*gmpTick0CommandsPT[gmpNumCommands])(unsigned infobyte) = {
    CMD &gmpCmdEmpty,                   /* no command */
    CMD &gmpCmdEmpty,                   /* arpeggio */
    CMD &gmpCmdEmpty,                   /* period slide up */
    CMD &gmpCmdEmpty,                   /* period slide down */
    CMD &gmpCmdSetTonePorta,            /* tone portamento */
    CMD &gmpCmdEmpty,                   /* vibrato */
    CMD &gmpCmdSetTonePorta,            /* tone portamento + volume slide */
    CMD &gmpCmdEmpty,                   /* vibrato + volume slide */
    CMD &gmpCmdEmpty,                   /* tremolo */
    CMD &gmpCmdSetPanning,              /* set panning (PT cmd 8) */
    CMD &gmpCmdSampleOffset,            /* set sample offset */
    CMD &gmpCmdEmpty,                   /* volume slide */
    CMD &gmpCmdPositionJump,            /* position jump */
    CMD &gmpCmdSetVolume,               /* set volume */
    CMD &gmpCmdPatternBreak,            /* pattern break (to a row) */
    CMD &gmpCmdSetSpeed,                /* set speed */
    CMD &gmpCmdSetTempo,                /* set tempo in BPM */
    CMD &gmpCmdFineSlideUp,             /* fine period slide up */
    CMD &gmpCmdFineSlideDown,           /* fine period slide down */
    CMD &gmpCmdPatternLoop,             /* pattern loop set/loop */
    CMD &gmpCmdSetPanning16,            /* set 16-point panning value */
    CMD &gmpCmdSetRetrig,               /* Protracker-style retrig note */
    CMD &gmpCmdFineVolSlideUp,          /* fine volume slide up */
    CMD &gmpCmdFineVolSlideDown,        /* fine volume slide down */
    CMD &gmpCmdNoteCut,                 /* note cut */
    CMD &gmpCmdSetNoteDelay,            /* note delay */
    CMD &gmpCmdPatternDelay,            /* pattern delay */
    CMD &gmpCmdEmpty,                   /* set master volume */
    CMD &gmpCmdEmpty,                   /* master volume slide */
    CMD &gmpCmdEmpty,                   /* S3M retrig note */
    CMD &gmpCmdMusicSync,               /* music synchronization */
    CMD &gmpCmdEmpty,                   /* extra fine period slide up */
    CMD &gmpCmdEmpty,                   /* extra fine period slide down */
    CMD &gmpCmdEmpty                    /* panning slide */
    };



    /* Protracker playing mode continuous commands: */
int (*gmpContCommandsPT[gmpNumCommands])(unsigned infobyte) = {
    CMD &gmpCmdEmpty,                   /* no command */
    CMD &gmpCmdArpeggio,                /* arpeggio */
    CMD &gmpCmdSlideUp,                 /* period slide up */
    CMD &gmpCmdSlideDown,               /* period slide down */
    CMD &gmpCmdTonePortamento,          /* tone portamento */
    CMD &gmpCmdVibrato,                 /* vibrato */
    CMD &gmpCmdTPortVSlide,             /* tone portamento + volume slide */
    CMD &gmpCmdVibVSlide,               /* vibrato + volume slide */
    CMD &gmpCmdEmpty,                   /* tremolo */
    CMD &gmpCmdEmpty,                   /* set panning (PT cmd 8) */
    CMD &gmpCmdEmpty,                   /* set sample offset */
    CMD &gmpCmdVolSlide,                /* volume slide */
    CMD &gmpCmdEmpty,                   /* position jump */
    CMD &gmpCmdEmpty,                   /* set volume */
    CMD &gmpCmdEmpty,                   /* pattern break (to a row) */
    CMD &gmpCmdEmpty,                   /* set speed */
    CMD &gmpCmdEmpty,                   /* set tempo in BPM */
    CMD &gmpCmdEmpty,                   /* fine period slide up */
    CMD &gmpCmdEmpty,                   /* fine period slide down */
    CMD &gmpCmdEmpty,                   /* pattern loop set/loop */
    CMD &gmpCmdEmpty,                   /* set 16-point panning value */
    CMD &gmpCmdRetrigNote,              /* Protracker-style retrig note */
    CMD &gmpCmdEmpty,                   /* fine volume slide up */
    CMD &gmpCmdEmpty,                   /* fine volume slide down */
    CMD &gmpCmdNoteCut,                 /* note cut */
    CMD &gmpCmdNoteDelay,               /* note delay */
    CMD &gmpCmdEmpty,                   /* pattern delay */
    CMD &gmpCmdEmpty,                   /* set master volume */
    CMD &gmpCmdEmpty,                   /* master volume slide */
    CMD &gmpCmdEmpty,                   /* S3M retrig note */
    CMD &gmpCmdEmpty,                   /* music synchronization */
    CMD &gmpCmdEmpty,                   /* extra fine period slide up */
    CMD &gmpCmdEmpty,                   /* extra fine period slide down */
    CMD &gmpCmdEmpty                    /* panning slide */
    };




    /* Fasttracker 2 playing mode tick-0 commands: */
int (*gmpTick0CommandsFT2[gmpNumCommands])(unsigned infobyte) = {
    CMD &gmpCmdEmpty,                   /* no command */
    CMD &gmpCmdEmpty,                   /* arpeggio */
    CMD &gmpCmdEmpty,                   /* period slide up */
    CMD &gmpCmdEmpty,                   /* period slide down */
    CMD &gmpCmdSetTonePorta,            /* tone portamento */
    CMD &gmpCmdEmpty,                   /* vibrato */
    CMD &gmpCmdSetTonePorta,            /* tone portamento + volume slide */
    CMD &gmpCmdEmpty,                   /* vibrato + volume slide */
    CMD &gmpCmdEmpty,                   /* tremolo */
    CMD &gmpCmdSetPanning,              /* set panning (PT cmd 8) */
    CMD &gmpCmdSampleOffset,            /* set sample offset */
    CMD &gmpCmdEmpty,                   /* volume slide */
    CMD &gmpCmdPositionJump,            /* position jump */
    CMD &gmpCmdSetVolume,               /* set volume */
    CMD &gmpCmdPatternBreak,            /* pattern break (to a row) */
    CMD &gmpCmdSetSpeed,                /* set speed */
    CMD &gmpCmdSetTempo,                /* set tempo in BPM */
    CMD &gmpCmdFineSlideUp,             /* fine period slide up */
    CMD &gmpCmdFineSlideDown,           /* fine period slide down */
    CMD &gmpCmdPatternLoop,             /* pattern loop set/loop */
    CMD &gmpCmdSetPanning16,            /* set 16-point panning value */
    CMD &gmpCmdSetRetrig,               /* Protracker-style retrig note */
    CMD &gmpCmdFineVolSlideUp,          /* fine volume slide up */
    CMD &gmpCmdFineVolSlideDown,        /* fine volume slide down */
    CMD &gmpCmdNoteCut,                 /* note cut */
    CMD &gmpCmdSetNoteDelay,            /* note delay */
    CMD &gmpCmdPatternDelay,            /* pattern delay */
    CMD &gmpCmdSetMVolume,              /* set master volume */
    CMD &gmpCmdEmpty,                   /* master volume slide */
    CMD &gmpCmdSetRetrig,               /* S3M retrig note */
    CMD &gmpCmdMusicSync,               /* music synchronization */
    CMD &gmpCmdExtraFineSlideUp,        /* extra fine period slide up */
    CMD &gmpCmdExtraFineSlideDown,      /* extra fine period slide down */
    CMD &gmpCmdEmpty                    /* panning slide */
    };



    /* Fasttracker 2 playing mode continuous commands: */
int (*gmpContCommandsFT2[gmpNumCommands])(unsigned infobyte) = {
    CMD &gmpCmdEmpty,                   /* no command */
    CMD &gmpCmdArpeggio,                /* arpeggio */
    CMD &gmpCmdSlideUp,                 /* period slide up */
    CMD &gmpCmdSlideDown,               /* period slide down */
    CMD &gmpCmdTonePortamento,          /* tone portamento */
    CMD &gmpCmdVibrato,                 /* vibrato */
    CMD &gmpCmdTPortVSlide,             /* tone portamento + volume slide */
    CMD &gmpCmdVibVSlide,               /* vibrato + volume slide */
    CMD &gmpCmdEmpty,                   /* tremolo */
    CMD &gmpCmdEmpty,                   /* set panning (PT cmd 8) */
    CMD &gmpCmdEmpty,                   /* set sample offset */
    CMD &gmpCmdVolSlide,                /* volume slide */
    CMD &gmpCmdEmpty,                   /* position jump */
    CMD &gmpCmdEmpty,                   /* set volume */
    CMD &gmpCmdEmpty,                   /* pattern break (to a row) */
    CMD &gmpCmdEmpty,                   /* set speed */
    CMD &gmpCmdEmpty,                   /* set tempo in BPM */
    CMD &gmpCmdEmpty,                   /* fine period slide up */
    CMD &gmpCmdEmpty,                   /* fine period slide down */
    CMD &gmpCmdEmpty,                   /* pattern loop set/loop */
    CMD &gmpCmdEmpty,                   /* set 16-point panning value */
    CMD &gmpCmdRetrigNote,              /* Protracker-style retrig note */
    CMD &gmpCmdEmpty,                   /* fine volume slide up */
    CMD &gmpCmdEmpty,                   /* fine volume slide down */
    CMD &gmpCmdNoteCut,                 /* note cut */
    CMD &gmpCmdNoteDelay,               /* note delay */
    CMD &gmpCmdEmpty,                   /* pattern delay */
    CMD &gmpCmdEmpty,                   /* set master volume */
    CMD &gmpCmdMVolSlide,               /* master volume slide */
    CMD &gmpCmdS3MRetrig,               /* S3M retrig note */
    CMD &gmpCmdEmpty,                   /* music synchronization */
    CMD &gmpCmdEmpty,                   /* extra fine period slide up */
    CMD &gmpCmdEmpty,                   /* extra fine period slide down */
    CMD &gmpCmdPanSlide                 /* panning slide */
    };

    /* Screamtracker 3 playing mode tick-0 commands: */
int (*gmpTick0CommandsST3[gmpNumCommands])(unsigned infobyte) = {
    CMD &gmpCmdEmpty,                   /* no command */
    CMD &gmpCmdEmpty,                   /* arpeggio */
    CMD &gmpCmdSlideUp,                 /* period slide up */
    CMD &gmpCmdSlideDown,               /* period slide down */
    CMD &gmpCmdSetTonePorta,            /* tone portamento */
    CMD &gmpCmdEmpty,                   /* vibrato */
    CMD &gmpCmdSetTonePorta,            /* tone portamento + volume slide */
    CMD &gmpCmdVibVSlide,               /* vibrato + volume slide */
    CMD &gmpCmdEmpty,                   /* tremolo */
    CMD &gmpCmdSetPanning,              /* set panning (PT cmd 8) */
    CMD &gmpCmdSampleOffset,            /* set sample offset */
    CMD &gmpCmdVolSlide,                /* volume slide */
    CMD &gmpCmdPositionJump,            /* position jump */
    CMD &gmpCmdSetVolume,               /* set volume */
    CMD &gmpCmdPatternBreak,            /* pattern break (to a row) */
    CMD &gmpCmdSetSpeed,                /* set speed */
    CMD &gmpCmdSetTempo,                /* set tempo in BPM */
    CMD &gmpCmdFineSlideUp,             /* fine period slide up */
    CMD &gmpCmdFineSlideDown,           /* fine period slide down */
    CMD &gmpCmdPatternLoop,             /* pattern loop set/loop */
    CMD &gmpCmdSetPanning16,            /* set 16-point panning value */
    CMD &gmpCmdSetRetrig,               /* Protracker-style retrig note */
    CMD &gmpCmdFineVolSlideUp,          /* fine volume slide up */
    CMD &gmpCmdFineVolSlideDown,        /* fine volume slide down */
    CMD &gmpCmdNoteCut,                 /* note cut */
    CMD &gmpCmdSetNoteDelay,            /* note delay */
    CMD &gmpCmdPatternDelay,            /* pattern delay */
    CMD &gmpCmdSetMVolume,              /* set master volume */
    CMD &gmpCmdEmpty,                   /* master volume slide */
    CMD &gmpCmdSetRetrig,               /* S3M retrig note */
    CMD &gmpCmdMusicSync,               /* music synchronization */
    CMD &gmpCmdEmpty,                   /* extra fine period slide up */
    CMD &gmpCmdEmpty,                   /* extra fine period slide down */
    CMD &gmpCmdEmpty                    /* panning slide */
    };



    /* Screamtracker 3 playing mode continuous commands: */
int (*gmpContCommandsST3[gmpNumCommands])(unsigned infobyte) = {
    CMD &gmpCmdEmpty,                   /* no command */
    CMD &gmpCmdArpeggio,                /* arpeggio */
    CMD &gmpCmdSlideUp,                 /* period slide up */
    CMD &gmpCmdSlideDown,               /* period slide down */
    CMD &gmpCmdTonePortamento,          /* tone portamento */
    CMD &gmpCmdVibrato,                 /* vibrato */
    CMD &gmpCmdTPortVSlide,             /* tone portamento + volume slide */
    CMD &gmpCmdVibVSlide,               /* vibrato + volume slide */
    CMD &gmpCmdEmpty,                   /* tremolo */
    CMD &gmpCmdEmpty,                   /* set panning (PT cmd 8) */
    CMD &gmpCmdEmpty,                   /* set sample offset */
    CMD &gmpCmdVolSlide,                /* volume slide */
    CMD &gmpCmdEmpty,                   /* position jump */
    CMD &gmpCmdEmpty,                   /* set volume */
    CMD &gmpCmdEmpty,                   /* pattern break (to a row) */
    CMD &gmpCmdEmpty,                   /* set speed */
    CMD &gmpCmdEmpty,                   /* set tempo in BPM */
    CMD &gmpCmdEmpty,                   /* fine period slide up */
    CMD &gmpCmdEmpty,                   /* fine period slide down */
    CMD &gmpCmdEmpty,                   /* pattern loop set/loop */
    CMD &gmpCmdEmpty,                   /* set 16-point panning value */
    CMD &gmpCmdRetrigNote,              /* Protracker-style retrig note */
    CMD &gmpCmdEmpty,                   /* fine volume slide up */
    CMD &gmpCmdEmpty,                   /* fine volume slide down */
    CMD &gmpCmdNoteCut,                 /* note cut */
    CMD &gmpCmdNoteDelay,               /* note delay */
    CMD &gmpCmdEmpty,                   /* pattern delay */
    CMD &gmpCmdEmpty,                   /* set master volume */
    CMD &gmpCmdEmpty,                   /* master volume slide */
    CMD &gmpCmdS3MRetrig,               /* S3M retrig note */
    CMD &gmpCmdEmpty,                   /* music synchronization */
    CMD &gmpCmdEmpty,                   /* extra fine period slide up */
    CMD &gmpCmdEmpty,                   /* extra fine period slide down */
    CMD &gmpCmdEmpty                    /* panning slide */
    };

/*
 * $Log: gmpcmds.c,v $
 * Revision 1.7  1997/02/05 13:43:33  pekangas
 * Fixed FT2 sample offset command
 *
 * Revision 1.6  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.5  1996/09/01 19:14:55  pekangas
 * Changed infobytes to unsigned to keep Visual C happy
 *
 * Revision 1.4  1996/09/01 15:43:00  pekangas
 * Many changes for better FT2 compatibility, no commands use signed infobytes now
 *
 * Revision 1.3  1996/07/13 20:09:01  pekangas
 * Eliminated Visual C warnings
 *
 * Revision 1.2  1996/06/14 16:27:18  pekangas
 * Ignored all tempos below 32
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/