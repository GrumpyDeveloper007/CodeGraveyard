/*      module.c
 *
 * A minimal module playing example with the DLL API
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <stdio.h>
#include <conio.h>
#include "midasdll.h"



int main(void)
{
    MIDASmodule module;

    /* Error checking has been removed for clarity - see other API examples */

    /* Initialize MIDAS and start background playback: */
    MIDASstartup();
    MIDASinit();
    MIDASstartBackgroundPlay(0);

    /* Load the module and start playing: */
    module = MIDASloadModule("..\\data\\templsun.xm");
    MIDASplayModule(module, 0);

    puts("Playing - press any key");
    getch();

    /* Stop playing and deallocate module: */
    MIDASstopModule(module);
    MIDASfreeModule(module);

    /* Stop background playback and uninitialize MIDAS: */
    MIDASstopBackgroundPlay();
    MIDASclose();

    return 0;
}