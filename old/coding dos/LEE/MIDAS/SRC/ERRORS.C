/*      ERRORS.C
 *
 * MIDAS Sound System error codes and error message strings
 *
 * $Id: errors.c,v 1.4 1996/07/13 20:33:43 pekangas Exp $
 *
 * Copyright 1996 Petteri Kangaslampi and Jarno Paananen
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <stdio.h>
#include <stdlib.h>
#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#ifndef __LINUX__
#include "vgatext.h"
#endif

RCSID(const char *errors_rcsid = "$Id: errors.c,v 1.4 1996/07/13 20:33:43 pekangas Exp $";)


/* maximum length of an error message is 40 characters! */

char            *errorMsg[] =
{
    "OK",
    "Undefined error",
#ifdef __REALMODE__
    "Out of conventional memory",
    "Conventional memory heap corrupted",
    "Invalid conventional memory block",
#else
    "Out of memory",
    "Heap corrupted",
    "Invalid memory block",
#endif
    "Out of EMS memory",
    "EMS memory heap corrupted",
    "Invalid EMS memory block",
    "Expanded Memory Manager failure",
    "Out of soundcard memory",
    "Soundcard memory heap corrupted",
    "Invalid soundcard memory block",
    "Out of sample handles",
    "Unable to open file",
    "Unable to read file",
    "Invalid module file",
    "Invalid instrument in module",
    "Invalid pattern data in module",
    "Invalid channel number",
    "Invalid sample handle",
    "Sound Device channels not open",
    "Sound Device hardware failure",
    "Invalid function arguments",
    "File does not exist",
    "Invalid file handle",
    "Access denied",
    "File exists",
    "Too many open files",
    "Disk full",
    "Unexpected end of file",
    "Invalid path",
    "Unable to write file",
    "Unable to lock Virtual DMA buffer",
    "Unable to use Virtual DMA Services",
    "Invalid Virtual DMA Service version",
    "DPMI failure",
    "Invalid segment descriptor",
    "Out of system resources",
    "Invalid device used",
    "Unsupported function used" ,
    "Device is not available",
    "Device is busy",
    "Unsupported output mode used",
    "Unable to lock memory"
};




#ifdef DEBUG

errRecord   errorList[MAXERRORS];       /* error list */
unsigned    numErrors = 0;              /* number of errors in list */



/****************************************************************************\
*
* Function:     void errAdd(int errorCode, unsigned functID);
*
* Description:  Add an error to error list
*
* Input:        int errorCode           error code
*               unsigned functID        ID for function that caused the error
*
\****************************************************************************/

void CALLING errAdd(int errorCode, unsigned functID)
{
    /* make sure that error list does not overflow */
    if ( numErrors <= MAXERRORS )
    {
        /* store error information to list: */
        errorList[numErrors].errorCode = errorCode;
        errorList[numErrors].functID = functID;

        numErrors++;
    }
}




/****************************************************************************\
*
* Function:     void errClearList(void)
*
* Description:  Clears the error list. Can be called if a error has been
*               handled without exiting the program to avoid filling the
*               error list with handled errors.
*
\****************************************************************************/

void CALLING errClearList(void)
{
    numErrors = 0;
}




/****************************************************************************\
*
* Function:     void errPrintList(void);
*
* Description:  Prints the error list to stderr
*
\****************************************************************************/

void CALLING errPrintList(void)
{
    unsigned    i;

    if ( numErrors > 0 )
        fputs("MIDAS error list:\n", stderr);

    for ( i = 0; i < numErrors; i++ )
    {
        fprintf(stderr, "%u: <%i, %u> - %s at %u\n", i,
            errorList[i].errorCode, errorList[i].functID,
            errorMsg[errorList[i].errorCode], errorList[i].functID);
    }
}





#endif


#ifdef __WATCOMC__

void SetMode3(void);
#pragma aux SetMode3 = \
        "mov    ax,0003h" \
        "int    10h" \
        modify exact [ax];

#endif


/****************************************************************************\
*
* Function:     void errErrorExit(char *msg)
*
* Description:  Set up standard text mode, print an error message and exit
*
* Input:        char *msg               pointer to error message, ASCIIZ
*
\****************************************************************************/

void CALLING errErrorExit(char *msg)
{
    /* set up standard 80x25 text mode: */
#ifdef __BORLANDC__
asm     mov     ax,0003h
asm     int     10h
#else
#ifdef __WATCOMC__
//    SetMode3();
#else
#if (!defined(__LINUX__)) && (!defined(__WIN32__))
    vgaSetMode(3);
#endif
#endif
#endif

    fputs(msg, stderr);
    fputs("\n", stderr);

#ifdef DEBUG
    errPrintList();                     /* print error list */
#endif

    /* exit to DOS: */
    exit(EXIT_FAILURE);
}


/*
 * $Log: errors.c,v $
 * Revision 1.4  1996/07/13 20:33:43  pekangas
 * Fixed for Visual C
 *
 * Revision 1.3  1996/05/24 20:40:12  jpaana
 * Added USSWave
 *
 * Revision 1.2  1996/05/24 16:20:36  jpaana
 * Added Linux specific stuff
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/