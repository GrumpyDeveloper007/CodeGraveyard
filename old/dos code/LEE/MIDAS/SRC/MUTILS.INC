;*      MUTILS.INC
;*
;* Miscellaneous utility functions for MIDAS Sound System used
;* by various system components.
;*
;* $Id: mutils.inc,v 1.3 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*



;/***************************************************************************\
;*
;* Function:     int mGetKey(void)
;*
;* Description:  Waits for a keypress and returns the read key
;*
;* Returns:      ASCII code for the key pressed. Extended keycodes are
;*               returned with bit 8 set, eg. up arrow becomes \x148.
;*
;\***************************************************************************/

GLOBAL  LANG mGetKey : _funct




;/***************************************************************************\
;*
;* Function:     int mStrLength(char *str)
;*
;* Description:  Calculates the length of a ASCIIZ string
;*
;* Input:        char *str               pointer to string
;*
;* Returns:      String length excluding the terminating '\0'.
;*
;\***************************************************************************/

GLOBAL  LANG mStrLength : _funct




;/***************************************************************************\
;*
;* Function:     void mStrCopy(char *dest, char *src);
;*
;* Description:  Copies an ASCIIZ string from *src to *dest.
;*
;* Input:        char *dest              pointer to destination string
;*               char *src               pointer to source string
;*
;\***************************************************************************/

GLOBAL  LANG mStrCopy : _funct




;/***************************************************************************\
;*
;* Function:     void mStrAppend(char *dest, char *src);
;*
;* Description:  Appends an ASCIIZ string to the end of another.
;*
;* Input:        char *dest              pointer to destination string
;*               char *src               pointer to source string
;*
;\***************************************************************************/

GLOBAL  LANG mStrAppend : _funct



;/***************************************************************************\
;*
;* Function:     void mMemCopy(char *dest, char *src, unsigned numBytes);
;*
;* Description:  Copies a memory block from *src to *dest.
;*
;* Input:        char *dest              pointer to destination
;*               char *src               pointer to source
;*               unsigned numBytes       number of bytes to copy
;*
;\***************************************************************************/

GLOBAL  LANG mMemCopy : _funct




;/***************************************************************************\
;*
;* Function:     int mMemEqual(char *m1, char *m2, unsigned numBytes);
;*
;* Description:  Compares two memory blocks.
;*
;* Input:        char *m1                pointer to memory block #1
;*               char *m2                pointer to memory block #2
;*               unsigned numBytes       number of bytes to compare
;*
;* Returns:      1 if the memory blocks are equal, 0 if not.
;*
;\***************************************************************************/

GLOBAL  LANG mMemEqual : _funct




;/***************************************************************************\
;*
;* Function:     long mHex2Long(char *hex)
;*
;* Description:  Converts a hexadecimal string to a long integer.
;*
;* Input:        char *hex               pointer to hex string, ASCIIZ
;*
;* Returns:      Value of the string or -1 if conversion failure.
;*
;\***************************************************************************/

GLOBAL  LANG mHex2Long : _funct




;/***************************************************************************\
;*
;* Function:     long mDec2Long(char *dec)
;*
;* Description:  Converts an unsigned decimal string to a long integer
;*
;* Input:        char *dec               pointer to string, ASCIIZ
;*
;* Returns:      Value of the string or -1 if conversion failure.
;*
;\***************************************************************************/

GLOBAL  LANG mDec2Long : _funct




;/**************************************************************************\
;*
;* Function:     char *mGetEnv(char *envVar);
;*
;* Description:  Searches a string from the environment
;*
;* Input:        envVar                  environment variable name, ASCIIZ
;*
;* Returns:      Pointer to environment string value (ASCIIZ), NULL if string
;*               was not found.
;*
;\**************************************************************************/

GLOBAL  LANG mGetEnv : _funct


;* $Log: mutils.inc,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*