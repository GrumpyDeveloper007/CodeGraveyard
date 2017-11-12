/*
 *      MidpMIDAS.cpp
 *
 * MIDAS Module Player for Windows NT MIDAS interface module
 *
 * $Id: MidpMIDAS.cpp 1.7 1997/01/25 13:17:44 pekangas Exp $
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <mmsystem.h>
#include <ddeml.h>
#include <process.h>
#include <stdio.h>
#include "midasdll.h"
#include "MidpNT.h"

#define POLLRATE 50

int             mixRate = 44100, stereo = 1, force8bit = 0;
static volatile int backgroundPlay = 0;




/****************************************************************************\
*
* Function:     void MIDASerror(void)
*
* Description:  Gets the last MIDAS error, displays it, and exits
*
\****************************************************************************/

void MIDASerror(void)
{
    char        *errorMessage;

    errorMessage = MIDASgetErrorMessage(MIDASgetLastError());
    MessageBox(NULL, errorMessage, "MIDAS Error!",
        MB_APPLMODAL | MB_ICONSTOP | MB_OK);
    if ( ddeInit )
        DdeUninitialize(ddeInstance);
    MIDASclose();
    ExitProcess(1);
    while(1);                           // we should NEVER end up here
}




/****************************************************************************\
*
* Function:     void StopFreeModule(MIDASmodule module);
*
* Description:  Stops playing a module and deallocates it
*
* Input:        gmpModule *module       Pointer to module structure returned
*                                       by LoadPlayModule().
*
\****************************************************************************/

void StopFreeModule(MIDASmodule module)
{
    if ( module == NULL )
        return;

    AddTextLine("Stopping module");
    if ( !MIDASstopModule(module) )
        MIDASerror();

    AddTextLine("Deallocating module");
    if ( !MIDASfreeModule(module) )
        MIDASerror();

    SendMessage(mainWinHandle, WM_SETTEXT, 0,
        (LPARAM) "MIDAS Module Player for Windows NT");
}




/****************************************************************************\
*
* Function:     MIDASmodule LoadModule(char *fileName);
*
* Description:  Loads a module file
*
* Input:        char *fileName          module file name
*
* Returns:      Pointer to gmpModule structure for the loaded module,
*               NULL if loading failed.
*
\****************************************************************************/

MIDASmodule LoadModule(char *fileName)
{
    MIDASmodule module;
    char        *errorMessage;

    AddTextLine("Loading Module");

    SendMessage(mainWinHandle, WM_SETTEXT, 0, (LPARAM) "MidpNT - Loading...");

    if ( (module = MIDASloadModule(fileName)) == NULL )
    {
        errorMessage = MIDASgetErrorMessage(MIDASgetLastError());
        MessageBox(NULL, errorMessage, "Module load failure",
            MB_APPLMODAL | MB_ICONSTOP | MB_OK);
        return NULL;
    }

    return module;
}




/****************************************************************************\
*
* Function:     void PlayModule(MIDASmodule module);
*
* Description:  Starts playing a module
*
* Input:        MIDASmodule module      the module
*
\****************************************************************************/

void PlayModule(MIDASmodule module)
{
    char        buf[64];
    MIDASmoduleInfo moduleInfo;

    if ( !MIDASplayModule(module, 0) )
        MIDASerror();

    if ( !MIDASgetModuleInfo(module, &moduleInfo) )
        MIDASerror();

    sprintf(buf, "Playing \"%s\" - %i channels", moduleInfo.songName,
        moduleInfo.numChannels);
    AddTextLine(buf);

    sprintf(buf, "MidpNT - %s", moduleInfo.songName);
    SendMessage(mainWinHandle, WM_SETTEXT, 0, (LPARAM) buf);
}




/****************************************************************************\
*
* Function:     void InitMIDAS(void)
*
* Description:  Initializes MIDAS Sound System
*
\****************************************************************************/

void InitMIDAS(void)
{
    AddTextLine("Initializing MIDAS Sound System");

    if ( !MIDASinit() )
        MIDASerror();

    /* Start polling MIDAS in a thread: */
    if ( !MIDASstartBackgroundPlay(POLLRATE) )
        MIDASerror();

    backgroundPlay = 1;
}




/****************************************************************************\
*
* Function:     void CloseMIDAS(void)
*
* Description:  Uninitializes MIDAS Sound System
*
\****************************************************************************/

void CloseMIDAS(void)
{
    if ( backgroundPlay )
        if ( !MIDASstopBackgroundPlay() )
            MIDASerror();

    if ( !MIDASclose() )
        MIDASerror();
}




/****************************************************************************\
*
* Function:     void StartupMIDAS(void)
*
* Description:  Start up interface to MIDAS Sound System
*
\****************************************************************************/

void StartupMIDAS(void)
{
    MIDASstartup();
}


/*
 * $Log: MidpMIDAS.cpp $
 * Revision 1.7  1997/01/25 13:17:44  pekangas
 * Rewrote archive support
 *
 * Revision 1.6  1997/01/17 00:08:51  pekangas
 * Now puts song name and loading/decompressing messages in main window
 * caption
 *
 * Revision 1.5  1997/01/14 17:42:08  pekangas
 * Changed to use MIDAS DLL API
 *
 * Revision 1.4  1996/08/13 20:22:15  pekangas
 * #included stdio.h as MIDAS rawfile.h no longer does that
 *
 * Revision 1.3  1996/08/02  17:53:13  pekangas
 * Fixed to compile with Watcom C again
 *
 * Revision 1.2  1996/07/16  19:19:37  pekangas
 * Fixed to compile with Visual C, added RCS keywords, changed to LFs
 *
*/