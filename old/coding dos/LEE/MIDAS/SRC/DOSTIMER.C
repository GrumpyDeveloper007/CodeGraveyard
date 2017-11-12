/*      dostimer.c
 *
 * MIDAS Sound System timer for MS-DOS
 *
 * $Id: dostimer.c,v 1.6 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <dos.h>
#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "sdevice.h"
#include "timer.h"
#include "mglobals.h"

RCSID(const char *dostimer_rcsid = "$Id: dostimer.c,v 1.6 1997/01/16 18:41:59 pekangas Exp $";)

//#define TIMERBORDERS

/* Time between to screen interrupts is 96.5% of total frame time - the
   interrupt comes somewhat before the Vertical Retrace actually starts: */
#define FRAMETIME 965

/* Timer mode: */
#define TIMERMODE 0x30

/* Maximum # of music players: */
#define MAXPLAYERS 16


static void (__interrupt __far *oldTimer)();
static volatile int tmrState;
static volatile int playSD;

static volatile long sysTmrCount;       /* system timer counter */
static volatile long playTmrCount;      /* initial player timer count */
static volatile long playCount;         /* player timer count */
static volatile SoundDevice *sdev;      /* current SD */

static int CALLING (*musicPlayers[MAXPLAYERS])(void);    /* music players */

static volatile int playSD;             /* 1 if sound should be played */
static volatile int plTimer;            /* 1 if player-timer is active */
static volatile int plError;            /* music playing error code */

static volatile long scrCount;          /* screen timer counter */
static volatile long scrTmrCount;       /* initial value for screen timer */
static volatile long scrPVCount;        /* count before retrace */

static void CALLING (*preVR)();         /* pre-VR function */
static void CALLING (*immVR)();         /* immVR() */
static void CALLING (*inVR)();          /* inVR() */

static volatile int scrSync;            /* is timer synchronized to screen? */
static volatile int scrTimer;           /* 1 if screen-timer is active */
static volatile int scrPlayer;          /* synchronize player to screen? */

static volatile int tmrState;           /* timer state */




/****************************************************************************\
*       enum tmrStates
*       --------------
* Description:  Possible timer states
\****************************************************************************/

enum tmrStates
{
    tmrSystem = 0,                      /* system timer */
    tmrPlayer,                          /* music player */
    tmrScreen                           /* display synchronized timer */
};



void outp(unsigned port, unsigned value);
#pragma aux outp = \
    "out    dx,al" \
    parm [edx] [eax] \
    modify exact [];

unsigned inp(unsigned port);
#pragma aux inp = \
    "xor    eax,eax" \
    "in     al,dx" \
    parm [edx] \
    value [eax] \
    modify exact [eax];

void DoSTI(void);
#pragma aux DoSTI = "sti" modify exact[];

void DoCLI(void);
#pragma aux DoCLI = "cli" modify exact[];

void SendEOI(void);
#pragma aux SendEOI = \
    "   mov     al,20h" \
    "   out     20h,al" \
    modify exact[eax];


/* Set border color: */
#ifdef TIMERBORDERS
void SetBorder(int color);
#pragma aux SetBorder = \
    "   mov     dx,03DAh" \
    "   in      al,dx" \
    "   mov     dx,03C0h" \
    "   mov     al,31h" \
    "   out     dx,al" \
    "   mov     al,bl" \
    "   out     dx,al" \
    parm [ebx] \
    modify exact [eax edx];
#else
#define SetBorder(x)
#endif


/* Wait for next Vertical Retrace: */
void WaitNextVR(void);
#pragma aux WaitNextVR = \
    "   mov     dx,03DAh" \
    "n: in      al,dx" \
    "   test    al,8" \
    "   jnz     n" \
    "v: in      al,dx" \
    "   test    al,8" \
    "   jz      v" \
    modify exact [eax edx];

/* Wait for Vertical Retrace: */
void WaitVR(void);
#pragma aux WaitVR = \
    "   mov     dx,03DAh" \
    "w: in      al,dx" \
    "   test    al,8" \
    "   jz      w" \
    modify exact [eax edx];

/* Wait for no Vertical Retrace: */
void WaitNoVR(void);
#pragma aux WaitNoVR = \
    "   mov     dx,03DAh" \
    "w: in      al,dx" \
    "   test    al,8" \
    "   jnz     w" \
    modify exact [eax edx];

/* Set DS to ES: */
void SetDStoES(void);
#pragma aux SetDStoES = \
    "   mov     ax,ds" \
    "   mov     es,ax" \
    modify exact [eax];



/****************************************************************************\
*
* Function:     void SetCount(unsigned count)
*
* Description:  Sets new timer count
*
* Input:        unsigned count          new timer count
*
\****************************************************************************/

static void SetCount(unsigned count)
{
    outp(0x43, TIMERMODE);
    outp(0x40, count & 0xFF);
    outp(0x40, (count >> 8) & 0xFF);
}



/****************************************************************************\
*
* Function:     void NextTimer(void)
*
* Description:  Sets everything up for the next timer interrupt
*
\****************************************************************************/

static void NextTimer(void)
{
    if ( scrSync )
    {
        /* Timer is synchronized to screen: */
        if ( playSD && mSyncScreen )
        {
            if ( playCount < scrCount )
            {
                if ( playCount < 10 )
                    playCount = 10;

                /* Player interrupt, please */
                tmrState = tmrPlayer;
                SetCount(playCount);
                return;
            }
        }

        if ( scrCount < 10 )
            scrCount = 10;

        /* Screen interrupt, please: */
        tmrState = tmrScreen;
        SetCount(scrCount);
        return;
    }

    if ( playSD )
    {
        if ( playCount < 10 )
            playCount = 10;

        /* Player interrupt: */
        tmrState = tmrPlayer;
        SetCount(playCount);
        return;
    }

    /* System timer: */
    tmrState = tmrSystem;
    SetCount(0);
}


void CallDOSInt(void);
#pragma aux CallDOSInt = \
    "pushfd" \
    "call fword oldTimer" \
    modify exact [];


/****************************************************************************\
*
* Function:     void CheckSystemTimer(void)
*
* Description:  Calls the system timer if necessary, send EOI otherwise
*
\****************************************************************************/

void CheckSystemTimer(void)
{
    DoSTI();

    if ( sysTmrCount < 0x10000 )
    {
        SendEOI();
        return;
    }

    while ( sysTmrCount >= 0x10000 )
    {
        sysTmrCount -= 0x10000;
        CallDOSInt();
    }
}




/****************************************************************************\
*
* Function:     void PollMIDAS(void)
*
* Description:  Polls MIDAS
*
\****************************************************************************/

void PollMIDAS(void)
{
    static int callMP;
    int         i;

    if ( (playSD) && (plError == OK) )
    {
        /* Prepare SD for playing: */
        if ( (plError = sdev->StartPlay()) != OK )
        {
            plTimer = 0;
            return;
        }

        do
        {
            /* Poll Sound Device: */
            if ( (plError = sdev->Play(&callMP)) != OK )
            {
                plTimer = 0;
                return;
            }

            if ( callMP )
            {
                /* Call all music players: */
                for ( i = 0; i < MAXPLAYERS; i++ )
                {
                    if ( musicPlayers[i] != NULL )
                    {
                        if ( (plError = (*musicPlayers[i])()) != OK )
                        {
                            plTimer = 0;
                            return;
                        }
                    }
                }
            }
        } while ( callMP && (sdev->tempoPoll == 0) );
    }
}


/****************************************************************************\
*
* Function:     void __interrupt __far tmrISR(void)
*
* Description:  The timer ISR
*
\****************************************************************************/

void __interrupt __far tmrISR(void)
{
    int         chainDOS = 1;
    long        oldPlayCount;

    /* Set DS to ES as well: (stupid Watcom doesn't to this, and then assumes
       ES is valid) */
    SetDStoES();

    SetBorder(9);

    switch ( tmrState )
    {
        case tmrScreen:
            SetBorder(15);
            DoCLI();                    /* Disable interrupts here */

            if ( scrTimer )
            {
                /* PANIC, screen timer still active! */
                playCount -= scrCount + scrPVCount;
                sysTmrCount += scrCount + scrPVCount;
                scrCount = scrTmrCount;
                NextTimer();
                SendEOI();
                DoSTI();
                chainDOS = 0;
                break;
            }

            if ( scrSync )
            {
                SetBorder(14);

                scrTimer = 1;

                if ( mSyncScreen )
                    WaitNoVR();

                if ( preVR != NULL )
                    (*preVR)();

                /* Update timer counters: */
                sysTmrCount += scrCount + scrPVCount;
                if ( scrPlayer )
                    playCount = playTmrCount;
                else
                    playCount -= scrCount + scrPVCount;
                scrCount = scrTmrCount;

                if ( mSyncScreen )
                    WaitVR();

                if ( immVR != NULL )
                    (*immVR)();

                NextTimer();
                CheckSystemTimer();
                scrTimer = 0;

                /* If not synchronizing to screen we need to poll MIDAS
                   here: */
                if ( (!mSyncScreen) && playSD )
                {
                    if ( sdev->tempoPoll )
                    {
                        while ( playCount < 0 )
                        {
                            PollMIDAS();
                            playCount += playTmrCount;
                        }
                    }
                    else
                        PollMIDAS();
                }

                if ( inVR != NULL )
                    (*inVR)();
                chainDOS = 0;
                break;
            }
            else
            {
                /* We shouldn't really be here - check system timer and
                   exit */
                CheckSystemTimer();
                chainDOS = 0;
                break;
            }
            break;

        case tmrPlayer:
            if ( plTimer )
            {
                /* Player timer active - panic! */
                scrCount -= playCount;
                sysTmrCount += playCount;
                playCount = playTmrCount;
                NextTimer();
                SendEOI();
                DoSTI();
                chainDOS = 0;
                break;
            }

            plTimer = 1;
            scrCount -= playCount;
            sysTmrCount += playCount;

            if ( scrPlayer )
                playCount = 0xFFFF;
            else
                playCount = playTmrCount;
            NextTimer();

            CheckSystemTimer();
            chainDOS = 0;

            oldPlayCount = playTmrCount;

            PollMIDAS();

            /* Check if player timer rate has been updated: */
            if ( (sdev->tempoPoll == 1) && (playTmrCount != oldPlayCount))
            {
                playCount = playTmrCount;
                if ( tmrState == tmrPlayer )
                    NextTimer();
            }

            plTimer = 0;
            chainDOS = 0;
            break;

        case tmrSystem:
        default:
            /* The system timer - set rate to 18.2Hz and chain to DOS: */
            SetCount(0);
            chainDOS = 1;
            break;
    }

    SetBorder(0);

    if ( chainDOS )
        _chain_intr(oldTimer);
}



/****************************************************************************\
*
* Function:     int tmrInit(void);
*
* Description:  Initializes the timer
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING tmrInit(void)
{
    tmrState = tmrSystem;               /* system timer only */
    playSD = 0;

    /* Get old timer interrupt and set our own: */
    oldTimer = _dos_getvect(8);
    _dos_setvect(8, tmrISR);

    /* Restart timer at 18.2Hz: */
//    SetCount(0);

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrClose(void);
*
* Description:  Uninitializes the timer.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING tmrClose(void)
{
    /* Set DOS default timer mode and 18.2Hz rate: */
    outp(0x43, 0x36);
    outp(0x40, 0);
    outp(0x40, 0);

    /* Restore old interrupt vector: */
    _dos_setvect(8, oldTimer);

    /* Set DOS default timer mode and 18.2Hz rate: */
    outp(0x43, 0x36);
    outp(0x40, 0);
    outp(0x40, 0);

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrGetScrSync(unsigned *scrSync);
*
* Description:  Calculates the screen synchronization value for timer
*
* Input:        unsigned *scrSync       pointer to screen synchronization
*                                       value
*
* Returns:      MIDAS error code.
*               Screen syncronization value used with tmrSyncScr() is stored
*               in *scrSync.
*
\****************************************************************************/

int CALLING tmrGetScrSync(unsigned *scrSync)
{
    int         failCount = 0, success = 0;
    long        count1, count2, prevCount = 0, count;

    if ( !mSyncScreen )
    {
        /* No sync - just return the default frame rate: */
        *scrSync = 119318000 / mDefaultFramerate;
        return OK;
    }

    DoCLI();

    while ( (failCount < 4) && (success != 1) )
    {
        WaitNextVR();
        outp(0x43, 0x36);
        outp(0x40, 0);
        outp(0x40, 0);
        WaitNextVR();
        outp(0x43, 0);
        count1 = inp(0x40);
        count1 |= (inp(0x40)) << 8;
        count1 = 0x10000-count1;

        WaitNextVR();
        outp(0x43, 0x36);
        outp(0x40, 0);
        outp(0x40, 0);
        WaitNextVR();
        outp(0x43, 0);
        count2 = inp(0x40);
        count2 |= (inp(0x40)) << 8;
        count2 = 0x10000-count2;

        if ( ((count2 - count1) > 2) || ((count2 - count1) < -2) )
        {
            failCount++;
        }
        else
        {
            count = count1 >> 1;
            if ( ((prevCount - count) <= 2) && ((prevCount - count) >= -2) )
                success = 1;
            else
            {
                prevCount = count;
                failCount++;
            }
        }
    }

    if ( success )
    {
        /* We got the synchronization value! */
        *scrSync = count;
    }
    else
    {
        /* Couldn't synchronize - turn sync off and return default
           frame rate: */
        mSyncScreen = 0;
        *scrSync = 119318000 / mDefaultFramerate;
    }

    DoSTI();

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrPlaySD(SoundDevice *SD);
*
* Description:  Starts playing sound with a Sound Device ie. calling its
*               Play() function in the update rate, which is set to
*               50Hz.
*
* Input:        SoundDevice *SD         Sound Device that will be used
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING tmrPlaySD(SoundDevice *SD)
{
    int         i;

    sdev = SD;

    /* Reset all music player pointers to NULL: */
    for ( i = 0; i < MAXPLAYERS; i++ )
        musicPlayers[i] = NULL;

    if ( !sdev->tempoPoll )
    {
        if ( scrSync && mSyncScreen )
        {
            /* We are synchronizing to screen and have a non-tempoPoll SD -
               call the music player a 1/4th of a frame after the retrace: */
            scrPlayer = 1;
            playTmrCount = playCount = scrTmrCount / 4;
        }
        else
        {
            /* No tempo-polling and no screen-sync - poll at 100Hz: */
            playTmrCount = playCount = 1193180 / 100;
            scrPlayer = 0;
        }
    }
    else
    {
        /* Tempo-polling Sound Device - set initially to 50Hz: */
        playTmrCount = playCount = 1193180 / 50;
        scrPlayer = 0;
    }

    plTimer = 0;
    plError = 0;

    /* Start playing: */
    DoCLI();

    if ( tmrState == tmrSystem )
    {
        tmrState = tmrPlayer;
        SetCount(playCount);
        sysTmrCount = 0;
    }

    playSD = 1;

    DoSTI();

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrStopSD(void);
*
* Description:  Stops playing sound with the Sound Device.
*
* Returns:      MIDAS error code.
*
\****************************************************************************/

int CALLING tmrStopSD(void)
{
    DoCLI();

    playSD = 0;

    if ( !scrSync )
    {
        /* No screen sync - only system timer now: */
        tmrState = tmrSystem;
        SetCount(0);
    }

    DoSTI();

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrPlayMusic(void *play, int *playerNum);
*
* Description:  Starts playing music with the timer.
*
* Input:        void *play              Pointer to music playing function,
*                                       must return MIDAS error codes
*               int *playerNum          Pointer to player number, used
*                                       for stopping music
*
* Returns:      MIDAS error code. Player number is written to *playerNum.
*
* Notes:        There can be a maximum of 16 music players active at the
*               same time.
*
\****************************************************************************/

int CALLING tmrPlayMusic(int CALLING (*play)(), int *playerNum)
{
    int         i;


    /* Try to find a free music player: */
    for ( i = 0; i < MAXPLAYERS; i++ )
    {
        if ( musicPlayers[i] == NULL )
            break;
    }

    if ( i >= MAXPLAYERS )
    {
        /* No free player found: */
        ERROR(errOutOfResources, ID_tmrPlayMusic);
        return errOutOfResources;
    }

    /* Free player found - store the pointer and return player ID: */
    musicPlayers[i] = play;
    *playerNum = i;

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrStopMusic(int playerNum);
*
* Description:  Stops playing music with the timer.
*
* Input:        int playerNum           Number of player to be stopped.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING tmrStopMusic(int playerNum)
{
    musicPlayers[playerNum] = NULL;

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrSyncScr(unsigned sync, void (*preVR)(),
*                   void (*immVR)(), void (*inVR)());
*
* Description:  Synchronizes the timer to screen refresh.
*
* Input:        unsigned sync           Screen synchronization value returned
*                                       by tmrGetScrSync().
*               void (*preVR)()         Pointer to the routine that will be
*                                       called BEFORE Vertical Retrace
*               void (*immVR)()         Pointer to the routine that will be
*                                       called immediately after Vertical
*                                       Retrace starts
*               void (*inVR)()          Pointer to the routine that will be
*                                       called some time during Vertical
*                                       Retrace
*
* Returns:      MIDAS error code
*
* Notes:        preVR() and immVR() functions must be as short as possible
*               and do nothing else than update counters or set some VGA
*               registers to avoid timer synchronization problems. inVR()
*               can take a longer time and can be used for, for example,
*               setting the palette.
*
*               Remember to use the correct calling convention for the xxVR()
*               routines! (pascal for Pascal programs, cdecl otherwise).
*
\****************************************************************************/

int CALLING tmrSyncScr(unsigned sync, void CALLING (*_preVR)(),
    void CALLING (*_immVR)(), void CALLING (*_inVR)())
{
    /* We don't want to get disturbed right now: */
    DoCLI();

    /* Save the function pointers: */
    preVR = _preVR;
    immVR = _immVR;
    inVR = _inVR;

    if ( mSyncScreen )
    {
        scrTmrCount = FRAMETIME * sync / 1000;
        scrPVCount = sync - scrTmrCount;
    }
    else
    {
        scrTmrCount = sync;
        scrPVCount = 0;
    }

    /* Next interrupt will be screen - synchronize to screen and start: */
    scrCount = scrTmrCount;
    tmrState = tmrScreen;
    scrSync = 1;
    WaitNextVR();
    SetCount(scrCount);

    /* If we are synchronizing to the screen fully and the card is not
       tempopolling, start screen sync playing: */
    if ( mSyncScreen && (!sdev->tempoPoll) )
    {
        playCount = playTmrCount = scrTmrCount / 4;
        scrPlayer = 1;
    }

    DoSTI();

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrStopScrSync(void);
*
* Description:  Stops synchronizing the timer to the screen.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING tmrStopScrSync(void)
{
    DoCLI();

    if ( scrPlayer )
    {
        /* Player was synchronized to screen - restart at 100Hz: */
        playCount = playTmrCount = 1193180/100;
        scrPlayer = 0;
    }

    scrSync = 0;
    scrTimer = 0;
    NextTimer();

    DoSTI();

    return OK;
}




/****************************************************************************\
*
* Function:     int tmrSetUpdRate(unsigned updRate);
*
* Description:  Sets the timer update rate, ie. the rate at which the music
*               playing routines are called
*
* Input:        unsigned updRate        updating rate, in 100*Hz (5000=50Hz)
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING tmrSetUpdRate(unsigned updRate)
{
    /* Only change if tempopolling: */
    if ( sdev->tempoPoll )
    {
        playTmrCount = 119318000 / updRate;
    }

    return OK;
}









/*
 * $Log: dostimer.c,v $
 * Revision 1.6  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.5  1996/10/13 16:53:07  pekangas
 * The timer ISR now sets ES to DS
 *
 * Revision 1.4  1996/08/06 18:46:09  pekangas
 * Removed border colors
 *
 * Revision 1.3  1996/08/06 16:51:36  pekangas
 * Fixed SB and timer conflicts
 *
 * Revision 1.2  1996/08/04 18:08:21  pekangas
 * Fixed a nasty bug in tmrGetScrSync - interrupts were left disabled
 *
 * Revision 1.1  1996/06/06 19:28:17  pekangas
 * Initial revision
 *
*/
