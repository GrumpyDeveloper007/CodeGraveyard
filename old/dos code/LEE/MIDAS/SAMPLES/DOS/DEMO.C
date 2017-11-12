/*      DEMO.C
 *
 * MIDAS megademo
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <conio.h>
#include <math.h>
#include "midas.h"
#include "mconfig.h"
#include "vga.h"


/* Some changes to demo behaviour for Assembly '96. The rules state that the
   demo must start without a configuration screen if either GUS or SB has been
   detected, and this does exactly that. In addition, if the user specifies
   _any_ command line arguments, the config will be run. Feel free to modify
   main(). To get the old behaviour, ie. a config screen always, comment out
   the next line: */
#define ASM96


/* Music playing position information - updated by UpdateInfo: */
unsigned        position;               /* Current position */
unsigned        pattern;                /* Current pattern number */
unsigned        row;                    /* Current row number */
int             syncInfo;               /* Music synchronization info */

/* Music file name ;) */
char            *moduleName = "..\\data\\templsun.xm";


/* Frame counter variable - note VOLATILE! */
volatile unsigned   frameCount;

void CALLING prevr(void)
{
    frameCount++;
}


/****************************************************************************\
*
* Function:     void Error(char *msg)
*
* Description:  Displays an error message and exits to DOS
*
* Input:        char *msg               error message
*
\****************************************************************************/

void Error(char *msg)
{
    vgaSetMode(3);
    printf("Error: %s\n", msg);
#ifndef NOMUSIC
    midasClose();           /* IMPORTANT! */
#endif
    exit(EXIT_FAILURE);
}




/****************************************************************************\
*
* Function:     void Errorcode(int errorcode)
*
* Description:  Displays an error message related to a MIDAS error code and
*               exits to DOS
*
* Input:        int errorcode           MIDAS error code
*
\****************************************************************************/

void Errorcode(int errorcode)
{
    Error(errorMsg[errorcode]);
}




/****************************************************************************\
*
* Function:     void WaitFrame(void)
*
* Description:  Waits for the next frame
*
\****************************************************************************/

void WaitFrame(void)
{
    unsigned    old;

#ifdef NOMUSIC
    vgaWaitNoVR();
    vgaWaitVR();
#else

    /* Playing music - wait for frame counter to change: */
    old = frameCount;
    while ( old == frameCount );
#endif
}




/****************************************************************************\
*
* Function:     void UpdateInfo(void)
*
* Description:  Updates song playing information (defined at the beginning of
*               this file)
*
* Note:         To use the position information from Assembler, do the
*               following (almost - get the idea?)
*
*               INCLUDE "midas.inc"
*               ...
*               GLOBAL  UpdateInfo : LANG
*               ...
*               EXTRN   position : dword
*               EXTRN   pattern : dword
*               EXTRN   row : dword
*               EXTRN   syncInfo : dword
*               ...
*               CODESEG
*               ...
*               PROC    SuperRoutine    NEAR
*               ...
*               call    UpdateInfo C
*               cmp     [position],17
*               je      @@design
*               ...
*
\****************************************************************************/

void CALLING UpdateInfo(void)
{
    static gmpInformation   *info;
    int         error;

    /* Get GMP playing information: (this can't fail but let's just play it
       safe) */
    if ( (error = gmpGetInformation(midasPlayHandle, &info)) != OK )
        midasError(error);

    /* Store interesting information in easy-to-access variables: */
    position = info->position;
    pattern = info->pattern;
    row = info->row;
    syncInfo = info->syncInfo;
}



/****************************************************************************\
*
* Function:     void SyncCallback(unsigned syncNum, unsigned position,
*                   unsigned row);
*
* Description:  Music synchronization callback function. Called by GMPlayer
*               whenever command 'W' is encountered (XMs and S3Ms).
*
* Input:        unsigned syncNum        synchronization command infobyte
*               unsigned position       current position
*               unsigned row            current row
*
* Notes:        This function is called from inside the music player timer
*               interrupt! Therefore it may not take very much time (more
*               than a few rasterlines maximum) and shouldn't do really
*               much anything...
*
\****************************************************************************/

void CALLING SyncCallback(unsigned syncNum, unsigned position, unsigned row)
{
    static      border = 0;

    /* Prevent warnings: */
    position = position;
    row = row;

    /* Check if the infobyte is interesting - do something only when command
       "W42" is encountered: */
    if ( syncNum == 0x42 )
    {
        /* Yeah, yeah, flash the border! */
        border ^= 1;
        vgaSetBorder(border);
    }
}





int main(int argc, char *argv[])
{
    static unsigned    sync;            /* Screen synchronization magic */
    int         error;
    static gmpModule   *module;         /* Da module */
    int         configOK;

    /* Prevent warnings: */
    argc = argc;
    argv = argv;

#ifndef NOMUSIC
    /* Call this first: */
    midasSetDefaults();

#ifdef ASM96
    /* Assembly'96 mode - try to detect the sound card: */
    midasDetectSD();

    /* If the card detected wasn't a GUS or an SB or there was something on
       the command line, run the config: */
    if ( ((midasSDNumber != 0) && (midasSDNumber != 4)) || (argc > 1) )
        configOK = midasConfig();
    else
        configOK = 1;
#else
    /* Run MIDAS Sound System setup: */
    configOK = midasConfig();
#endif
#endif

    /* Check if the user pressed Esc in config - if yes, exit: */
    if ( !configOK )
        return 0;

    /* Here we could set up a cool display mode */
    vgaSetMode(0x03);
    /* But we don't */

#ifndef NOMUSIC
    /* Get screen synchronization value: (ie. time per frame) */
    if ( (error = tmrGetScrSync(&sync)) != OK )
        midasError(error);

    /* Please read timer.txt for more information about this! */
#endif

    /* Now we could return to text mode for setup and stuff */

#ifndef NOMUSIC
    /* Check if we got proper screen sync: */
    if ( !mSyncScreen )
    {
        printf("Warning! Unable to synchronize to display refresh!\n"
               "This can lead to problems in music output and flickering.\n"
               "This usually happens only when running under Windows 95 - "
               "please consider\nrunning DOS programs in DOS instead.\n"
               "Press Esc to quit or any other key to continue\n");
        if ( getch() == 27 )
            return 0;
    }

    /* Now initialize MIDAS Sound System: */

    midasInit();

    /* Debug stuff: */
    printf("Using %s\n%s, using port %X, IRQ %i and DMA %i\n",
        midasSD->name, midasSD->cardNames[midasSD->cardType-1],
        midasSD->port, midasSD->IRQ, midasSD->DMA);

    puts("Loading music");

    /* Load the module: (Not too hard to change for PT or ST3 modules ;) */
    if ( (error = gmpLoadXM(moduleName, 1, NULL, &module)) != OK )
        midasError(error);
    /* Hint: Think of the file name extensions... */
#endif

    /* Now we could do all our initialization, set up a fancy display mode
       etc. */

#ifndef NOMUSIC
    /* Synchronize the timer to screen update and call prevr() just before
       each Vertical Retrace: */
    if ( (error = tmrSyncScr(sync, &prevr, NULL, NULL)) != OK )
        midasError(error);

    /* Start playing the module: */
    midasPlayModule(module, 0);

    /* Set the music synchronization callback function: */
   if ( (error = gmpSetSyncCallback(midasPlayHandle, &SyncCallback)) != OK )
        midasError(error);
#endif

    /* Now run a super demo:

       InitCredits();
       do
       {
           RunCredits();
           UpdateInfo();
       } while ( position < 2 );

       InitVectors();
       do
           RunVectors();
           UpdateInfo();
       } while ( position < 13 );

       Or just wait for a keypress: */

    while ( !kbhit() )
    {
        UpdateInfo();
        WaitFrame();
        printf("Pos %02X, Patt %02X, Row %02X", position,
            pattern, row);
        if ( syncInfo != -1 )
            printf(", Sync %02X\r", syncInfo);
        else
            printf("\r");
    }

    getch();

    /* Uninitialization */

#ifndef NOMUSIC
    /* Stop playing module: */
    midasStopModule(module);

    /* Deallocate the module: */
    if ( (error = gmpFreeModule(module)) != OK )
        midasError(error);

    /* And close MIDAS: */
    midasClose();
#endif

    /* End of DEMO - DOS! */

    return 0;
}
