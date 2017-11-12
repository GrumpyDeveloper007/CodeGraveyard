/*      MIDPDISP.C
 *
 * MIDAS Module Player v2.00 display handling routines
 *
 * Copyright 1995 Petteri Kangaslampi and Jarno Paananen
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#ifdef __WATCOMC__
#include <i86.h>
#else
#include <dos.h>
#endif

#include "midas.h"
#include "vu.h"
#include "vgatext.h"
#include "midp.h"


int             dispChannels = 0;       /* number of channels to display */

static uchar    oldDispMode;            /* old display mode */
static uchar    oldRows;                /* old number of rows */
static ushort   oldColumns;             /* old number of columns */
static int      numRows;                /* number of character rows */
static int      numColumns;             /* number of character columns */
static int      modeChanged;            /* has display mode been changed? */
static int      instNameRows;           /* number of instrument name rows */

#ifdef __16__
//static uchar    *display = (uchar*) 0xB8000000;  /* ptr to display memory */
#else
//static uchar    *display = (uchar*) 0xB8000;   /* pointer to display memory */
#endif

static char     s[32];                  /* temporary working area */


/* Display top message: */
static char     *dispTop =
"MIDAS Module Player v" MIDPVERSTR " - Copyright 1995 Petteri Kangaslampi & "
"Jarno Paananen";

/* Note strings: */
char            *noteStr[13] =
    {"C-", "C#", "D-", "D#", "E-", "F-", "F#", "G-", "G#", "A-", "A#", "B-"};

/* Hexadecimal numbers: */
char            *hexTable = "0123456789ABCDEF";

/* Command name strings: */
char            *commandStr[gmpNumCommands] = {
    "",
    "Arpeggio",
    "Slide Up",
    "Slide Down",
    "Tone Porta",
    "Vibrato",
    "TPrt+VolSld",
    "Vib+VolSld",
    "TREMOLO",
    "Set Panning",
    "Sample Offs",
    "VolumeSlide",
    "Pos. Jump",
    "Set Volume",
    "Patt. Break",
    "Set Speed",
    "Set Tempo",
    "FineSld Up",
    "FineSld Dwn",
    "Patt. Loop",
    "Set Panning",
    "Retrig Note",
    "Fine VSl Up",
    "Fine VSl Dn",
    "Note Cut",
    "Note Delay",
    "Patt. Delay",
    "Set M.Vol.",
    "M.VolSlide",
    "ST3 Retrig",
    "Music Sync",
    "XtrFnSld Up",
    "XtrFnSld Dn",
    "Pan Slide" };

/* Channel ID characters: */
char            *channelID = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";




#ifdef __32__
#define VIDEOINT int386(0x10, &regs, &regs);
#else
#define VIDEOINT int86(0x10, &regs, &regs);
#endif


/****************************************************************************\
*
* Function:     void Set80x50(void)
*
* Description:  Sets up 80x50 VGA color alphanumeric display mode
*
\****************************************************************************/

static void Set80x50(void)
{
    static union REGS  regs;

    regs.w.ax = 3;
    VIDEOINT

    regs.w.ax = 0x0500;
    VIDEOINT

    regs.w.ax = 0x1202;
    regs.h.bl = 0x30;
    VIDEOINT

    regs.w.ax = 3;
    VIDEOINT

    regs.w.ax = 0x1112;
    regs.h.bl = 0;
    VIDEOINT

    *((uchar*) 0x487) = (*((uchar*) 0x487)) | 1;

    regs.h.ah = 1;
    regs.w.cx = 0x0600;
    VIDEOINT

    *((uchar*) 0x487) = (*((uchar*) 0x487)) & 0xFE;

    outpw(0x3D4, 0x0814);
}




/****************************************************************************\
*
* Function:     void InitDisplay(void)
*
* Description:  Initializes MIDP display
*
\****************************************************************************/

void InitDisplay(void)
{
    /* Get old display mode, number of columns and number of rows: */
    /* Warning! Works only for large model in real mode and _FLAT_ 32-bit
       modes */
    oldDispMode = *((uchar*) 0x449);
    oldColumns = *((ushort*) 0x44A);
    oldRows = *((uchar*) 0x484) + 1;

    /* Check if the current display mode is enough (at least 80 columns and
       50 rows): */
    if ( (oldColumns >= 80) && (oldRows >= 40) )
    {
        /* Use old display mode: */
        numRows = oldRows;
        numColumns = oldColumns;
        modeChanged = 0;
    }
    else
    {
        /* Set up 80x50 display mode: */
        Set80x50();
        numRows = 50;
        numColumns = 80;
        modeChanged = 1;
    }

    /* Set display width: */
    vgaSetWidth(numColumns);

    /* Clear display memory: */
    vgaFillRect(1, 1, numColumns, numRows, 0x07);

    /* Move cursor to the start of the message window: */
    vgaMoveCursor(1, numRows-msgWindowHeight+1);
}



/****************************************************************************\
*
* Function:     void DrawWindow(int x1, int y1, int x2, int y2,
*                   uchar attrBackgroud, attrLitBorder, attrShadowBorder)
*
* Description:  Draws a window on the screen
*
* Input:        int x1                  x-coordinate of top left corner
*               int y1                  y-coordinate of top left corner
*               int x2                  x-coordinate of bottom right corner
*               int y2                  y-coordinate of bottom right corner
*               uchar attrBackgroud     background attribute
*               uchar attrLitBorder     lit border attribute
*               uchar attrShadowBorder  shadow border attribute
*
\****************************************************************************/

void DrawWindow(int x1, int y1, int x2, int y2, uchar attrBackground,
    uchar attrLitBorder, uchar attrShadowBorder)
{
    int         y;

    /* Draw the top of the window: */
    vgaDrawChar(x1, y1, 'Þ', attrLitBorder);
    vgaDrawChars(x1+1, y1, 'ß', attrLitBorder | (attrBackground & 0xF0),
        x2 - x1 - 1);
    vgaDrawChar(x2, y1, 'Ý', attrShadowBorder);

    /* Draw the middle rows of the window: */
    for ( y = (y1+1); y < y2; y++ )
    {
        vgaDrawChar(x1, y, 'Þ', attrLitBorder);
        vgaDrawChars(x1+1, y, ' ', attrBackground, x2-x1-1);
        vgaDrawChar(x2, y, 'Ý', attrShadowBorder);
    }

    /* Draw the bottom of the window: */
    vgaDrawChar(x1, y2, 'Þ', attrLitBorder);
    vgaDrawChars(x1+1, y2, 'Ü', attrShadowBorder | (attrBackground & 0xF0),
        x2-x1-1);
    vgaDrawChar(x2, y2, 'Ý', attrShadowBorder);
}




/****************************************************************************\
*
* Function:     void DrawBox(int x1, int y1, int x2, int y2,
*                   uchar attrBackgroud, attrLitBorder, attrShadowBorder)
*
* Description:  Draws a shaded box (inside a window) on the screen. Note
*               that the box is shaded to show it has been pressed "into"
*               the window.
*
* Input:        int x1                  x-coordinate of top left corner
*               int y1                  y-coordinate of top left corner
*               int x2                  x-coordinate of bottom right corner
*               int y2                  y-coordinate of bottom right corner
*               uchar attrBackgroud     background attribute
*               uchar attrLitBorder     lit border attribute
*               uchar attrShadowBorder  shadow border attribute
*
\****************************************************************************/

void DrawBox(int x1, int y1, int x2, int y2, uchar attrBackground,
    uchar attrLitBorder, uchar attrShadowBorder)
{
    int         y;

    /* Draw the top of the box: */
    vgaDrawChar(x1, y1, 'Ú', attrShadowBorder);
    vgaDrawChars(x1+1, y1, 'Ä', attrShadowBorder, x2 - x1 - 1);
    vgaDrawChar(x2, y1, '¿', attrLitBorder);

    /* Draw the middle rows of the box: */
    for ( y = (y1+1); y < y2; y++ )
    {
        vgaDrawChar(x1, y, '³', attrShadowBorder);
        vgaDrawChars(x1+1, y, ' ', attrBackground, x2-x1-1);
        vgaDrawChar(x2, y, '³', attrLitBorder);
    }

    /* Draw the bottom of the box: */
    vgaDrawChar(x1, y2, 'À', attrShadowBorder);
    vgaDrawChars(x1+1, y2, 'Ä', attrLitBorder, x2-x1-1);
    vgaDrawChar(x2, y2, 'Ù', attrLitBorder);
}




/****************************************************************************\
*
* Function:     void DrawScreen(void)
*
* Description:  Draws the MIDP screen (without information)
*
\****************************************************************************/

void DrawScreen(void)
{
    int         y, x;
    int         numch;
    char        *s;

    /* If no module is loaded assume 4 channels: */
    if ( dispChannels == 0 )
        numch = 4;
    else
        numch = dispChannels;

    /* Draw display top message: */
    x = (numColumns - strlen(dispTop)) / 2;
    vgaWriteStr(1, 1, "", attrDispTop, x);
    vgaWriteStr(x+1, 1, dispTop, attrDispTop, numColumns - x);

    /* Draw the main window: */
    DrawWindow(1, 2, numColumns, numRows-msgWindowHeight, attrMainBg,
        attrMainBorderLit, attrMainBorderSh);

    /* Draw the upper information box: */
    x = (numColumns - 80) / 2;
    DrawBox(2+x, 3, 79+x, 7, attrMainBg, attrMainLit, attrMainShadow);

    /* Draw the labels in the upper information box: */
    vgaWriteStr(3+x, 4, "Module:", attrSongInfoLabel, 7);
    vgaWriteStr(41+x, 4, "Type:", attrSongInfoLabel, 5);
    vgaWriteStr(3+x, 5, "Mixing Rate:", attrSongInfoLabel, 12);
    vgaWriteStr(27+x, 5, "Output Mode:", attrSongInfoLabel, 12);
    vgaWriteStr(66+x, 5, "Time:", attrSongInfoLabel, 5);
    vgaWriteStr(3+x, 6, "Length:", attrSongInfoLabel, 7);
    vgaWriteStr(14+x, 6, "Position:", attrSongInfoLabel, 9);
    vgaWriteStr(27+x, 6, "Pattern:", attrSongInfoLabel, 8);
    vgaWriteStr(39+x, 6, "Row:", attrSongInfoLabel, 4);
    vgaWriteStr(47+x, 6, "Tempo:", attrSongInfoLabel, 6);
    vgaWriteStr(58+x, 6, "Speed:", attrSongInfoLabel, 6);
    vgaWriteStr(68+x, 6, "Volume:", attrSongInfoLabel, 7);

    /* Draw the channel information box: */
    DrawBox(2, 8, numColumns-1, 9+numch, attrMainBg, attrMainLit,
        attrMainShadow);

    /* Draw the separators inside the channel information box: */
    s = "\xFF\x01\x7F\x03 ³\x7F\x01 ³   ³  ³\x7F\x0E ³";
    s[1] = attrChanInfoSep;
    s[7] = numColumns - 63;
    for ( y = 9; y < (9+numch); y++ )
    {
        vgaWriteText(3, y, s);
    }

    /* Draw the instrument name box: */
    DrawBox(2, 10+numch, numColumns-1, numRows - msgWindowHeight - 1,
        attrMainBg, attrMainLit, attrMainShadow);

    /* Calculate number of instrument name rows: */
    instNameRows = numRows - msgWindowHeight - numch - 12;
}




/****************************************************************************\
*
* Function:     int InstCoords(int inst, int *x, int *y)
*
* Description:  Calculates the coordinates of an instrument name on the
*               screen.
*
* Input:        int inst                instrument number
*               int *x                  pointer to x-coordinate
*               int *y                  pointer to y-coordinate
*
* Returns:      1 if instrument is visible, 0 if not.
*
\****************************************************************************/

int InstCoords(int inst, int *x, int *y)
{
    /* Check that the instrument name is visible: */
    if ( (inst < firstInstName) || ((instNameMode == 0) &&
        (inst >= (firstInstName + 2*instNameRows))) ||
        ((instNameMode == 1) && (inst >= (firstInstName + instNameRows))) )
        return 0;

    /* Check the appropriate instrument display mode and calculate the
       x and y coordinates of the instrument name: */
    if ( instNameMode == 0 )
    {
        *y = ((inst - firstInstName) % instNameRows) + 11 + dispChannels;
        if ( (inst - firstInstName) < instNameRows )
            *x = 3;
        else
            *x = (numColumns / 2) + 1;
    }
    else
    {
        *y = inst - firstInstName + 11 + dispChannels;
        *x = 3;
    }

    return 1;
}




/****************************************************************************\
*
* Function:     void DrawInstNames(void)
*
* Description:  Draws instrument names on the screen
*
\****************************************************************************/

void DrawInstNames(void)
{
    static int  x, y;
    int         i, error, len;
    static char *s;
    static char *c;

    /* Draw the separator bar in the middle of the window if in two-column
       mode: */
    for ( y = 0; y < instNameRows; y++ )
        vgaDrawChar(numColumns / 2, y + 11 + dispChannels, '³',
            attrInstNameSeparator);

    /* Allocate memory for string buffer: */
    if ( (error = memAlloc(256, &s)) != OK )
        midasError(error);

    /* Allocate memory for channel ID characters: */
    if ( (error = memAlloc(numChannels+1, &c)) != OK )
        midasError(error);

    /* Build channel ID string: */
    for ( i = 0; i < numChannels; i++ )
        c[i] = channelID[i];

    c[i] = 0;

    /* Build and display information for all instruments: */
    for ( i = 0; i < module->numInsts; i++ )
    {
        /* Calculate instrument name coordinates and check if it is visible:*/
        if ( InstCoords(i+1, &x, &y) )
        {
            /* Check correct maximum string length: */
            if ( instNameMode == 0 )
            {
                if ( x > 3 )
                    len = (numColumns / 2) - 3;
                else
                    len = (numColumns / 2) - 4;
            }
            else
            {
                len = numColumns - 4;
            }

            /* Build instrument name string (includes channel ID characters,
               instrument number and instrument name): */
            sprintf(s, "%s %02X %s", c, i + 1,
                &module->instruments[i]->name[0]);
            /* Draw info using color based on whether the instrument is
               used or not: */
            if ( module->instruments[i]->used )
                vgaWriteStr(x, y, s, attrUsedInstName, len+1);
            else
                vgaWriteStr(x, y, s, attrUnusedInstName, len+1);
        }
    }

    /* If there are still free instrument name slots on the screen, clear
       them: */
    while ( InstCoords(i+1, &x, &y) )
    {
        /* Check correct maximum string length: */
        if ( instNameMode == 0 )
        {
            if ( y > 3 )
                len = (numColumns / 2) - 3;
            else
                len = (numColumns / 2) - 4;
        }
        else
        {
            len = numColumns - 4;
        }

        /* Draw empty string: */
        vgaWriteStr(x, y, "", attrUsedInstName, len+1);

        i++;
    }

    /* Deallocate string buffer: */
    if ( (error = memFree(s)) != OK )
        midasError(error);

    /* Deallocate channel ID characters: */
    if ( (error = memFree(c)) != OK )
        midasError(error);
}




/****************************************************************************\
*
* Function:     void UpdateScreen(void)
*
* Description:  Updates the song playing information on screen
*
\****************************************************************************/

void UpdateScreen(void)
{
    time_t      currTime;
    int         x, y;
    int         hour, min, sec;
    int         error;
    static unsigned  vol;
    int         i, n, ib;
    gmpChannel  *chan;
    static int  pan;
    static char s[32];
    static unsigned  meter;
    static unsigned  position, volume, sample;
    static ulong     rate;

    x = (numColumns - 80) / 2;

    /* Update the time display: */
    if ( !paused )
    {
        currTime = time(NULL) - startTime - pauseTime;
        hour = currTime / 3600;
        min = ((currTime - 3600*hour) / 60) % 60;
        sec = currTime % 60;
        sprintf(&s[0], "%2i:%02i:%02i", hour, min, sec);
        vgaWriteStr(71+x, 5, &s[0], attrSongInfo, 8);
    }
    else
        vgaWriteStr(71+x, 5, "-PAUSED-", attrSongInfo, 8);

    /* Update the playing information in the top information box: */
    vgaWriteByte(23+x, 6, info->position, attrSongInfo);
    vgaWriteByte(35+x, 6, info->pattern, attrSongInfo);
    vgaWriteByte(43+x, 6, info->row, attrSongInfo);
    itoa(info->tempo, &s[0], 10);
    vgaWriteStr(53+x, 6, &s[0], attrSongInfo, 3);
    vgaWriteByte(64+x, 6, info->speed, attrSongInfo);
    if ( (error = midasSD->GetMasterVolume(&vol)) != OK )
        midasError(error);
    vgaWriteByte(75+x, 6, vol, attrSongInfo);

    /* Draw channel information: */
    y = 9;
    for ( i = 0; i < numChannels; i++ )
    {
        /* Point chan to current channel structure: */
        chan = &info->channels[i];

        /* Get channel panning position: */
        if ( (error = midasSD->GetPanning(chan->sdChannel, &pan)) != OK )
            midasError(error);

        /* Build panning string in s[]: */
        switch ( pan )
        {
            case panLeft:
                mStrCopy(&s[0], "LFT");
                break;

            case panMiddle:
                mStrCopy(&s[0], "MID");
                break;

            case panRight:
                mStrCopy(&s[0], "RGT");
                break;

            case panSurround:
                mStrCopy(&s[0], "SUR");
                break;

            default:
                itoa(pan, &s[0], 10);
                break;
        }

        /* Write panning information on screen: */
        if ( i == activeChannel )
            vgaWriteStr(3, y, &s[0], attrActChanMarker, 3);
        else
            vgaWriteStr(3, y, &s[0], attrChanInfo, 3);

        x = numColumns - 80;

        /* Write instrument and note only if there is a valid instrument and
           the channel is not muted */
        if ( (chan->instrument != -1) && (!chMuted[i]) )
        {
            /* Write instrument number: */
            vgaWriteByte(7, y, chan->instrument + 1, attrChanInfo);

            /* Write instrument name: */
            vgaWriteStr(10, y,
                &module->instruments[chan->instrument]->name[0],
                attrChanInfo, 14+x);

            /* Write note number only if there is a valid note: */
            if ( chan->note != 0xFF )
            {
                mStrCopy(&s[0], noteStr[chan->note & 0x0F]);
                s[2] = '0' + (chan->note >> 4);
                vgaWriteStr(25+x, y, &s[0], attrChanInfo, 3);
            }
            else
                vgaWriteStr(25+x, y, "", attrChanInfo, 3);
        }
        else
        {
            vgaWriteStr(7, y, "", attrChanInfo, 17+x);
            vgaWriteStr(25+x, y, "", attrChanInfo, 3);
        }

        /* Write channel volume: */
        if ( chMuted[i] )
            vgaWriteStr(29+x, y, "", attrChanInfo, 2);
        else
            vgaWriteByte(29+x, y, chan->trueVolume, attrChanInfo);

        /* Write command name and infobyte only if there is a command and
           the channel is not muted: */
        if ( (chan->status.command) && (chan->command > gmpcNone) &&
            (chan->command < gmpNumCommands) && (!chMuted[i]) )
        {
            /* Get command name string: */
            mStrCopy(&s[0], commandStr[chan->command]);

            /* Append command infobyte: */
            n = mStrLength(&s[0]);
            s[n] = ' ';
            s[n+1] = hexTable[chan->infobyte >> 4];
            s[n+2] = hexTable[chan->infobyte & 0x0F];
            s[n+3] = 0;

            /* Write command string: */
            vgaWriteStr(32+x, y, &s[0], attrChanInfo, 14);
        }
        else
            vgaWriteStr(32+x, y, "", attrChanInfo, 14);

        /* Get VU meter value: */
        if ( realVU )
        {
            /* Get playing rate for channel: */
            if ( (error = midasSD->GetRate(i, &rate)) != OK )
                midasError(error);

            /* Get playing position for channel: */
            if ( (error = midasSD->GetPosition(i, &position)) != OK )
                midasError(error);

            /* Get current sample handle for channel: */
            if ( (error = midasSD->GetSample(i, &sample)) != OK )
                midasError(error);

            /* Get current volume for channel: */
            if ( (error = midasSD->GetVolume(i, &volume)) != OK )
                midasError(error);

            if ( (sample > 0) && (rate > 0) )
            {
                /* Get real VU meter value: */
                if ( (error = vuMeter(sample-1, rate, position, volume,
                    &meter)) != OK )
                    midasError(error);
            }
            else
                meter = 0;
        }
        else
        {
            meter = 0;
        }

        /* If channel is muted, make VU-meter value zero: */
        if ( chMuted[i] )
            meter = 0;

        if ( meter > 64 )
            meter = 64;

        /* Draw the VU meter: */
        vgaDrawChars(47+x, y, '\xFE', attrVUMeters, (meter >> 1));
        vgaDrawChars(47 + x + (meter >> 1), y, '\xFE', attrVUBlank,
            32 - (meter >> 1));

        y++;
    }
}




/****************************************************************************\
*
* Function:     void DrawSongInfo(void)
*
* Description:  Writes song-specific information on the screen
*
\****************************************************************************/

void DrawSongInfo(void)
{
    static unsigned mixRate, outputMode;
    int         error;
    int         x;

    /* Write song name: */
    x = (numColumns - 80) / 2;
    vgaWriteStr(10+x, 4, &module->name[0], attrSongInfo, 31);

    /* Write module type: */
    switch ( module->playMode )
    {
        case gmpPT:
            vgaWriteStr(46+x, 4, "Protracker module", attrSongInfo, 33);
            break;

        case gmpFT2:
            vgaWriteStr(46+x, 4, "Fasttracker ][ module", attrSongInfo, 33);
            break;

        case gmpST3:
            vgaWriteStr(46+x, 4, "Screamtracker ]I[ module", attrSongInfo, 33);
            break;
    }

    /* Write mixing rate: */
    if ( (error = midasSD->GetMixRate(&mixRate)) != OK )
        midasError(error);
    mStrAppend(ltoa(mixRate, &s[0], 10), "Hz");
    vgaWriteStr(15+x, 5, &s[0], attrSongInfo, 12);

    /* Write output mode: */
    if ( (error = midasSD->GetMode(&outputMode)) != OK )
        midasError(error);
    if ( outputMode & sd16bit )
        mStrCopy(&s[0], "16-bit ");
    else
        mStrCopy(&s[0], "8-bit ");
    if ( outputMode & sdStereo )
        mStrAppend(&s[0], "Stereo");
    else
        mStrAppend(&s[0], "Mono");
    vgaWriteStr(39+x, 5, &s[0], attrSongInfo, 27);

    /* Write song length: */
    vgaWriteByte(10+x, 6, module->songLength, attrSongInfo);

    /* Write instrument names: */
    DrawInstNames();
}
