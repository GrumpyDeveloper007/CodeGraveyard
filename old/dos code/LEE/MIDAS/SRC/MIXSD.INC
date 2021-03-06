;*      MIXSD.INC
;*
;* Miscellaneous helper functions common to all mixing sound devices.
;* Technically these functions should be part of each Sound Device's internal
;* code, but are here to save some space and help maintenance.
;*
;* $Id: mixsd.inc,v 1.3 1997/01/16 18:41:59 pekangas Exp $
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
;* Function:    int mixsdInit(unsigned mixRate, unsigned mode,
;*                  unsigned dmaChNum)
;*
;* Description: Common initialization for all mixing Sound Devices.
;*              Initializes DMA functions, DSM, start DMA playback and
;*              allocates memory for possible post-processing tables
;*
;* Input:       unsigned mixRate        mixing rate in Hz
;*              unsigned mode           output mode
;*              unsigned dmaChNum       DMA channel number
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG mixsdInit : _funct




;/***************************************************************************\
;*
;* Function:    int CALLING mixsdClose(void)
;*
;* Description: Common uninitialization code for all mixing Sound Devices.
;*              Uninitializes DMA playback and DSM and deallocates memory.
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG mixsdClose : _funct




;/***************************************************************************\
;*
;* Function:    int mixsdGetMode(unsigned *mode)
;*
;* Description: Reads the current output mode
;*
;* Input:       unsigned *mode          pointer to output mode
;*
;* Returns:     MIDAS error code. Output mode is written to *mode.
;*
;\***************************************************************************/

GLOBAL  LANG mixsdGetMode : _funct




;/***************************************************************************\
;*
;* Function:    int mixsdOpenChannels(unsigned channels)
;*
;* Description: Opens sound channels for output. Prepares post-processing
;*              tables, takes care of default amplification and finally opens
;*              DSM channels. Channels can be closed by simply calling
;*              dsmCloseChannels().
;*
;* Input:       unsigned channels       number of channels to open
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG mixsdOpenChannels : _funct




;/***************************************************************************\
;*
;* Function:    int mixsdSetAmplification(unsigned amplification)
;*
;* Description: Sets the amplification level. Calculates new post-processing
;*              tables and calls dsmSetAmplification() as necessary.
;*
;* Input:       unsigned amplification  amplification value
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG mixsdSetAmplification : _funct




;/***************************************************************************\
;*
;* Function:    int mixsdGetAmplification(unsigned *amplification);
;*
;* Description: Reads the current amplification level. (DSM doesn't
;*              necessarily know the actual amplification level if
;*              post-processing takes care of amplification)
;*
;* Input:       unsigned *amplification   pointer to amplification level
;*
;* Returns:     MIDAS error code. Amplification level is written to
;*              *amplification.
;*
;\***************************************************************************/

GLOBAL  LANG mixsdGetAmplification : _funct




;/***************************************************************************\
;*
;* Function:    int mixsdSetUpdRate(unsigned updRate);
;*
;* Description: Sets the channel value update rate (depends on song tempo)
;*
;* Input:       unsigned updRate        update rate in 100*Hz (eg. 50Hz
;*                                      becomes 5000).
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG mixsdSetUpdRate : _funct




;/***************************************************************************\
;*
;* Function:    int mixsdStartPlay(void)
;*
;* Description: Prepares for playing - reads DMA playing position. Called
;*              once before the Sound Device and music player polling loop.
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG mixsdStartPlay : _funct




;/***************************************************************************\
;*
;* Function:    int mixsdPlay(int *callMP);
;*
;* Description: Plays the sound - mixes the correct amount of data with DSM
;*              and copies it to DMA buffer with post-processing.
;*
;* Input:       int *callMP             pointer to music player calling flag
;*
;* Returns:     MIDAS error code. If enough data was mixed for one updating
;*              round and music player should be called, 1 is written to
;*              *callMP, otherwise 0 is written there. Note that if music
;*              player can be called, mixsdPlay() should be called again
;*              with a new check for music playing to ensure the DMA buffer
;*              gets filled with new data.
;*
;\***************************************************************************/

GLOBAL  LANG mixsdPlay : _funct


;* $Log: mixsd.inc,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*