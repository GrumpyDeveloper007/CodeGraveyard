;*	VGATEXT.INC
;*
;* VGA text output routines for MIDAS Sound System
;*
;* $Id: vgatext.inc,v 1.3 1997/01/16 18:41:59 pekangas Exp $
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
;* Function:    void vgaSetWidth(int width);
;*
;* Description: Sets the screen width used by text output routines
;*
;* Input:       int width               screen width in characters
;*
;\***************************************************************************/

GLOBAL  vgaSetWidth : _funct




;/***************************************************************************\
;*
;* Function:	 void vgaWriteText(int x, int y, char *txt);
;*
;* Description:  Writes text on the screen
;*
;* Input:	 int x			 X coordinate of string (up-left
;*					 corner is (1,1))
;*		 int y			 Y coordinate
;*		 char *txt		 pointer to null-terminated text
;*					 string, which may contain also the
;*					 following special characters:
;*					     \xFF - next char is attribute
;*					     \x7F - next char is RLE count for
;*                                               the character following it
;*
;\***************************************************************************/

GLOBAL  LANG vgaWriteText : _funct




;/***************************************************************************\
;*
;* Function:	 void vgaWriteStr(int x, int y, char *str, char attr);
;*
;* Description:  Writes a string on the screen
;*
;* Input:	 int x			 X coordinate of the string
;*		 int y			 Y coordinate
;*		 char *str		 pointer to a ASCIIZ string
;*		 char attr		 attribute for the string
;*		 int txtlen		 number of characters to be printed on
;*					 screen - padded with spaces
;*
;\***************************************************************************/

GLOBAL  LANG vgaWriteStr : _funct



;/***************************************************************************\
;*
;* Function:	 void vgaWriteByte(int x, int y, uchar byte, char attr);
;*
;* Description:  Writes a hex byte on the screen
;*
;* Input:	 int x			 X coordinate
;*		 int y			 Y coordinate
;*		 uchar byte		 byte to be written
;*		 char attr		 attribute for the byte
;*
;\***************************************************************************/

GLOBAL  LANG vgaWriteByte : _funct



;/***************************************************************************\
;*
;* Function:     void vgaFillRect(int x1, int y1, int x2, int y2, char attr);
;*
;* Description:  Draws a filled rectangle on the screen
;*
;* Input:        int x1                  X-coordinate of upper left corner
;*               int y1                  Y-coordinate of upper left corner
;*               int x2                  X-coordinate of lower left corner
;*               int y2                  Y-coordinate of lower left corner
;*               char attr               rectangle attribute
;*
;\***************************************************************************/

GLOBAL  LANG vgaFillRect : _funct



;/***************************************************************************\
;*
;* Function:     void vgaDrawChar(int x, int y, char ch, char attr);
;*
;* Description:  Draws a single character on the screen
;*
;* Input:        int x                   character X-coordinate
;*               int y                   character Y-coordinate
;*               char ch                 character
;*               char attr               character attribute
;*
;\***************************************************************************/

GLOBAL  LANG vgaDrawChar : _funct




;/***************************************************************************\
;*
;* Function:     void vgaSetMode(int mode)
;*
;* Description:  Sets a VGA BIOS display mode
;*
;* Input:        int mode                BIOS mode number
;*
;\***************************************************************************/

GLOBAL  LANG vgaSetMode : _funct



;/***************************************************************************\
;*
;* Function:     void vgaMoveCursor(int x, int y);
;*
;* Description:  Moves the text mode cursor to a new location
;*
;* Input:        int x                   cursor X-coordinate
;*               int y                   cursor Y-coordinate
;*
;\***************************************************************************/

GLOBAL  LANG vgaMoveCursor : _funct




;/***************************************************************************\
;*
;* Function:     void vgaDrawChars(int x, int y, char ch, char attr, int num);
;*
;* Description:  Draws many charactersr on the screen
;*
;* Input:        int x                   character X-coordinate
;*               int y                   character Y-coordinate
;*               char ch                 character
;*               char attr               character attribute
;*               int num                 number characters to draw
;*
;\***************************************************************************/

GLOBAL  LANG vgaDrawChars : _funct


;* $Log: vgatext.inc,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*