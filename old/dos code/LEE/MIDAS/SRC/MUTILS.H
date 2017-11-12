/*      MUTILS.H
 *
 * Miscellaneous utility functions for MIDAS Sound System used
 * by various system components.
 *
 * $Id: mutils.h,v 1.2 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#ifndef __MUTILS_H
#define __MUTILS_H


#ifdef __cplusplus
extern "C" {
#endif


/****************************************************************************\
*
* Function:     int mGetKey(void)
*
* Description:  Waits for a keypress and returns the read key
*
* Returns:      ASCII code for the key pressed. Extended keycodes are
*               returned with bit 8 set, eg. up arrow becomes \x148.
*
\****************************************************************************/

int CALLING mGetKey(void);



/****************************************************************************\
*
* Function:     int mStrLength(const char *str)
*
* Description:  Calculates the length of a ASCIIZ string
*
* Input:        char *str               pointer to string
*
* Returns:      String length excluding the terminating '\0'.
*
\****************************************************************************/

int CALLING mStrLength(const char *str);




/****************************************************************************\
*
* Function:     void mStrCopy(char *dest, const char *src);
*
* Description:  Copies an ASCIIZ string from *src to *dest.
*
* Input:        char *dest              pointer to destination string
*               char *src               pointer to source string
*
\****************************************************************************/

void CALLING mStrCopy(char *dest, const char *src);




/****************************************************************************\
*
* Function:     void mStrAppend(char *dest, const char *src);
*
* Description:  Appends an ASCIIZ string to the end of another.
*
* Input:        char *dest              pointer to destination string
*               char *src               pointer to source string
*
\****************************************************************************/

void CALLING mStrAppend(char *dest, const char *src);



/****************************************************************************\
*
* Function:     void mMemCopy(void *dest, const void *src, unsigned numBytes);
*
* Description:  Copies a memory block from *src to *dest.
*
* Input:        void *dest              pointer to destination
*               void *src               pointer to source
*               unsigned numBytes       number of bytes to copy
*
\****************************************************************************/

void CALLING mMemCopy(void *dest, const void *src, unsigned numBytes);




/****************************************************************************\
*
* Function:     int mMemEqual(const void *m1, const void *m2,
*                   unsigned numBytes);
*
* Description:  Compares two memory blocks.
*
* Input:        void *m1                pointer to memory block #1
*               void *m2                pointer to memory block #2
*               unsigned numBytes       number of bytes to compare
*
* Returns:      1 if the memory blocks are equal, 0 if not.
*
\****************************************************************************/

int CALLING mMemEqual(const void *m1, const void *m2, unsigned numBytes);




/****************************************************************************\
*
* Function:     long mHex2Long(const char *hex)
*
* Description:  Converts a hexadecimal string to a long integer.
*
* Input:        char *hex               pointer to hex string, ASCIIZ
*
* Returns:      Value of the string or -1 if conversion failure.
*
\****************************************************************************/

long CALLING mHex2Long(const char *hex);




/****************************************************************************\
*
* Function:     long mDec2Long(const char *dec)
*
* Description:  Converts an unsigned decimal string to a long integer
*
* Input:        char *dec               pointer to string, ASCIIZ
*
* Returns:      Value of the string or -1 if conversion failure.
*
\****************************************************************************/

long CALLING mDec2Long(const char *dec);




/***************************************************************************\
*
* Function:     char *mGetEnv(const char *envVar);
*
* Description:  Searches a string from the environment
*
* Input:        envVar                  environment variable name, ASCIIZ
*
* Returns:      Pointer to environment string value (ASCIIZ), NULL if string
*               was not found.
*
\***************************************************************************/

char * CALLING mGetEnv(const char *envVar);


#ifdef __cplusplus
}
#endif


#endif


/*
 * $Log: mutils.h,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/