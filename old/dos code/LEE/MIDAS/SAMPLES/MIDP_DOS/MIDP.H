/*      MIDP.H
 *
 * Common data and function prototypes for all MIDP modules
 *
 * Copyright 1995 Petteri Kangaslampi and Jarno Paananen
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __MIDP_H
#define __MIDP_H


#define MIDPVERSION 2.00a
#define MIDPVERNUM 0x200
#define MIDPVERSTR "2.00a"

#ifdef __cplusplus
extern "C" {
#endif



/****************************************************************************\
*
* Function:     void InitDisplay(void)
*
* Description:  Initializes MIDP display
*
\****************************************************************************/

void InitDisplay(void);



/****************************************************************************\
*
* Function:     void DrawScreen(void)
*
* Description:  Draws the MIDP screen (without information)
*
\****************************************************************************/

void DrawScreen(void);



/****************************************************************************\
*
* Function:     void UpdateScreen(void)
*
* Description:  Updates the song playing information on screen
*
\****************************************************************************/

void UpdateScreen(void);



/****************************************************************************\
*
* Function:     void DrawSongInfo(void)
*
* Description:  Writes song-specific information on the screen
*
\****************************************************************************/

void DrawSongInfo(void);



/****************************************************************************\
*
* Function:     void DrawInstNames(void)
*
* Description:  Draws instrument names on the screen
*
\****************************************************************************/

void DrawInstNames(void);



/****************************************************************************\
*      General variables:
\****************************************************************************/

extern int      numChannels;            /* number of channels in module */
extern int      dispChannels;           /* number of channels to display */
extern int      activeChannel;          /* active channel number */
extern gmpModule  *module;              /* current playing module */
extern gmpInformation  *info;           /* current module playing info */
extern int      paused;                 /* is playing paused? */
extern unsigned masterVolume;           /* master volume */
extern int      instNameMode;           /* instrument name display mode */
extern int      firstInstName;          /* first instrument name on screen */

extern time_t   startTime;              /* total playing time */
extern time_t   pauseTime;              /* time spent paused */
extern time_t   pauseStart;             /* start time for current pause */

extern int      msgWindowHeight;        /* message window height */

extern uchar    chMuted[32];            /* channel muted flags */

extern int      realVU;                 /* are real VU meters active? */





/****************************************************************************\
*      Display attributes:
\****************************************************************************/

extern uchar    attrDispTop;            /* display top message */
extern uchar    attrMainBg;             /* main window background */
extern uchar    attrMainLit;            /* main window lit areas */
extern uchar    attrMainShadow;         /* main window shadow areas */
extern uchar    attrMainBorderLit;      /* main window lit border */
extern uchar    attrMainBorderSh;       /* main window shadow border */
extern uchar    attrChanInfoSep;        /* channel information separator */
extern uchar    attrChanInfo;           /* channel information */
extern uchar    attrSongInfoLabel;      /* song information label */
extern uchar    attrSongInfo;           /* song information */
extern uchar    attrUsedInstName;       /* used instrument name */
extern uchar    attrUnusedInstName;     /* unused instrument name */
extern uchar    attrInstNameSeparator;  /* instrument name separator */
extern uchar    attrInstIndicator;      /* instrument used indicator */
extern uchar    attrActChanMarker;      /* active channel marker */
extern uchar    attrVUMeters;           /* VU meters */
extern uchar    attrVUBlank;            /* Blank VU meters */


#ifdef __cplusplus
}
#endif

#endif
