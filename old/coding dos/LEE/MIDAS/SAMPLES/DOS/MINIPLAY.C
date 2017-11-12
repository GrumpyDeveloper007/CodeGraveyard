/*      miniplay.c
 *
 * A minimal module player for DOS
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#include <conio.h>
#include "midas.h"

#define MODULEFILE "..\\data\\templsun.xm"


int main(void)
{
    int         error;
    static gmpModule *module;

    /* Set MIDAS to default setup: */
    midasSetDefaults();

    /* Initialize MIDAS: */
    midasInit();

    /* Load the module (easy to change for MODs or S3Ms): */
    if ( (error = gmpLoadXM(MODULEFILE, 1, NULL, &module)) != OK )
        midasError(error);

    /* Play the module: */
    midasPlayModule(module, 0);

    /* Wait for a keypress: */
    printf("Playing \"%s\", press a key to quit\n", module->name);
    getch();

    /* Stop playing the module: */
    midasStopModule(module);

    /* Free the module: */
    if ( (error = gmpFreeModule(module)) != OK )
        midasError(error);

    /* Uninitialize MIDAS: */
    midasClose();

    return 0;
}
