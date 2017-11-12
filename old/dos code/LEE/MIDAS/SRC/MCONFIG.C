/*      MCONFIG.C
 *
 * MIDAS Sound System configuration. Meant to be used with the simplified
 * MIDAS API, MIDAS.C
 *
 * $Id: mconfig.c,v 1.4 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include "midas.h"
#include "vgatext.h"

RCSID(const char *mconfig_rcsid = "$Id: mconfig.c,v 1.4 1997/01/16 18:41:59 pekangas Exp $";)



static char     *title = "MIDAS Sound System v" MVERSTR " configuration";

static char     *hexDigits = "0123456789ABCDEF";

/* Possible selections for IRQ selection screen: */
#define NUMIRQS 10
static int      IRQs[NUMIRQS] = { 2, 3, 4, 5, 7, 9, 10, 11, 12, 15 };
static char     *IRQStrings[NUMIRQS] = {
    "2", "3", "4", "5", "7", "9", "10", "11", "12", "15" };

/* Possible selections for DMA channel selection screen: */
#define NUMDMAS 6
static int      DMAs[NUMDMAS] = { 0, 1, 3, 5, 6, 7 };
static char     *DMAStrings[NUMDMAS] = { "0", "1", "3", "5", "6", "7" };

/* Possible selections for mixing rate selection screen: */
#define NUMRATES 7
#define DEFAULTRATE 6
static unsigned mixRates[NUMRATES] = {
    8000, 11025, 16000, 22050, 32000, 38000, 44100 };
static char     *mixRateStrings[NUMRATES+1] = {
    "8000Hz", "11025Hz", "16000Hz", "22050Hz", "32000Hz", "38000Hz",
    "44100Hz", "Other" };

/* Possible selections for output mode selection screen: */
#define DEFAULTBITS sd16bit
#define DEFAULTSTEREO sdStereo
#define NUMMODES 4
static unsigned outputModes[NUMMODES] = {
    sd8bit | sdMono,
    sd8bit | sdStereo,
    sd16bit | sdMono,
    sd16bit | sdStereo };
static char     *outputModeStrings[NUMMODES] = {
    "8-bit mono",
    "8-bit stereo",
    "16-bit mono",
    "16-bit stereo" };

static int      detectedSD;             /* detected Sound Device number */




/****************************************************************************\
*
* Function:     void InitScreen(void);
*
* Description:  Initializes the display mode and draws the screen.
*
\****************************************************************************/

static void InitScreen(void)
{
    int         y;
    int         x;

    /* Set up standard 80x25 text mode: */
    vgaSetMode(3);
    vgaSetWidth(80);

    /* Hide cursor by moving it outside the display area: */
    vgaMoveCursor(0, 26);

    /* Fill whole screen with blue: */
    vgaFillRect(1, 1, 80, 25, 0x10);

    /* Write display texts: */
    x = 40 - mStrLength(title)/2;
    vgaWriteStr(x, 1, title, 0x13, mStrLength(title));
    vgaDrawChars(x, 2, 0xC4, 0x13, mStrLength(title));
/*    vgaWriteText(x, 2, "\xFF\x13\x7F\x27Ä"); */
    vgaWriteStr(13, 24, "Use arrows to select, Enter to confirm or Esc to "
        "cancel", 0x13, 55);

    /* Draw the menu box in the middle of the screen: */
    vgaWriteText(7, 4, "\xFF\x1F\x7F\x43Ü\xFF\x18Ü");
    vgaWriteText(7, 5, "\xFF\x7FÛ\x7F\x42 \xFF\x78Û");
    vgaWriteText(7, 6, "\xFF\x7FÛ \xFF\x78Ú\x7F\x3EÄ\xFF\x7F¿ \xFF\x78Û");
    for ( y = 7; y < 21; y++ )
        vgaWriteText(7, y, "\xFF\x7FÛ \xFF\x78³\x7F\x3E \xFF\x7F³ \xFF\x78Û");
    vgaWriteText(7, 21, "\xFF\x7FÛ \xFF\x78À\xFF\x7F\x7F\x3EÄÙ \xFF\x78Û");
    vgaWriteText(7, 22, "\xFF\x1Fß\xFF\x18\x7F\x43ß");
}



/****************************************************************************\
*
* Function:     int AskSelection(char *selTitle, char **selections,
*                   int numSelections, int defaultSel)
*
* Description:  Get a menu selection from the user
*
* Input:        char *selTitle          selection title (ie. "Select sound
*                                       card")
*               char **selections       pointer to array of pointers to
*                                       possible selections (ASCIIZ)
*               int numSelections       number of possible selections
*               int defaultSel          default selection
*
* Returns:      User selection (0 - (numSelections-1)) or -1 if Esc was
*               pressed.
*
\****************************************************************************/

static int AskSelection(char *selTitle, char **selections, int numSelections,
    int defaultSel)
{
    int         current, first;
    int         selDone, n, a, y;

    current = defaultSel;
    first = 0;
    selDone = 0;

    /* write title string: */
    vgaWriteStr(8, 5, "", 0x70, 66);
    vgaWriteStr(40 - mStrLength(selTitle)/2, 5, selTitle, 0x70,
        mStrLength(selTitle));

    /* loop until Enter or Esc has been pressed: */
    while ( !selDone )
    {
        /* draw all menu entries, with the current one highlighted: */
        for ( n = 0; n < 14; n++ )
        {
            y = 7 + n;
            if ( n < (numSelections-first) )
            {
                /* if the entry that is being drawn is selected, highlight
                   it: */
                if ( (n + first) != current )
                    a = 0x70;
                else
                    a = 0x07;

                /* draw a space at the leftmost column: */
                vgaDrawChar(10, y, ' ', a);
                /* draw the menu entry: */
                vgaWriteStr(11, y, selections[n+first], a, 61);
            }
            else
                vgaWriteStr(10, y, "", 0x70, 62);
        }

        /* wait for a keypress and process it: */
        switch ( mGetKey() )
        {
            case 27:                    /* Escape */
                return -1;              /* return -1 - cancel */

            case 13:                    /* Enter */
                return current;         /* return current selection */

            case 0x148:                 /* Up arrow */
                if ( current > 0 )
                    current--;          /* select previous one */
                if ( current < first )  /* scroll up if necessary */
                    first = current;
                break;

            case 0x150:                 /* down arrow */
                if ( current < (numSelections-1) )
                    current++;          /* select next one */
                if ( current > (first + 13) )   /* scroll down if */
                    first = current - 13;       /* necessary */
                break;
        }
    }

    return -1;
}




/****************************************************************************\
*
* Function:     void PromptString(char *title, int maxLength, char *str);
*
* Description:  Prompts the user for a string in a separate window.
*
* Input:        char *title             window title (determines window
*                                       width)
*               int maxLength           maximum string length
*               char *str               pointer to a buffer where the string
*                                       will be stored.
*
* Returns:      1 if a string was entered (Enter was pressed), 0 if not
*               (Escape pressed).
*
\****************************************************************************/

static int PromptString(char *title, int maxLength, char *str)
{
    int         x;
    int         width;
    int         strPos, done;
    int         strOK;
    int         key;

    /* calculate window width: */
    width = mStrLength(title) + 2;

    x = 40 - (width+1)/2;

    /* draw window: */
    vgaDrawChar(x, 10, 'Û', 0x3B);
    vgaDrawChars(x+1, 10, 'ß', 0x3B, width);
    vgaDrawChar(x+width+1, 10, 'Û', 0x38);

    vgaWriteText(x, 11, "\xFF\x3BÛ ");
    vgaWriteText(x+width, 11, "\xFF\x38 Û");
    vgaWriteStr(x+2, 11, title, 0x30, width-2);

    vgaWriteText(x, 12, "\xFF\x3BÛ \xFF\x38Ú");
    vgaDrawChars(x+3, 12, 'Ä', 0x38, width-4);
    vgaWriteText(x+width-1, 12, "\xFF\x3B¿ \xFF\x38Û");

    vgaWriteText(x, 13, "\xFF\x3BÛ \xFF\x38³");
    vgaDrawChars(x+3, 13, ' ', 0x30, width-4);
    vgaWriteText(x+width-1, 13, "\xFF\x3B³ \xFF\x38Û");

    vgaWriteText(x, 14, "\xFF\x3BÛ \xFF\x38À");
    vgaDrawChars(x+3, 14, 'Ä', 0x3B, width-4);
    vgaWriteText(x+width-1, 14, "\xFF\x3BÙ \xFF\x38Û");

    vgaDrawChar(x, 15, 'Û', 0x3B);
    vgaDrawChars(x+1, 15, 'Ü', 0x38, width);
    vgaDrawChar(x+width+1, 15, 'Û', 0x38);

    strPos = 0;
    done = 0;
    strOK = 0;
    str[0] = 0;
    while ( !done )
    {
        /* write current string to screen: */
        vgaWriteStr(x+3, 13, &str[0], 0x30, maxLength);

        /* move cursor to end of string: */
        vgaMoveCursor(x + 3 + mStrLength(&str[0]), 13);

        key = mGetKey();                /* get keypress */
        switch ( key )
        {
            case 27:                    /* Escape */
                strOK = 0;
                done = 1;
                break;

            case 13:                    /* Enter */
                strOK = 1;
                done = 1;
                break;

            case 8:                     /* BackSpace */
                if ( strPos > 0 )
                {
                    strPos--;
                    str[strPos] = 0;
                }
                break;

            default:
                /* Some other key was pressed. If the key is not a control
                   character or an extended keycode, append it to the end of
                   the string provided that it's not already too long: */
                if ( (key >= ' ') && (key <= 255) && (strPos < maxLength) )
                {
                    str[strPos] = key;
                    strPos++;
                    str[strPos] = 0;
                }
                break;
        }
    }

    /* Hide cursor by moving it out of the screen: */
    vgaMoveCursor(1, 26);

    if ( strOK == 1 )
        return 1;
    return 0;
}




/****************************************************************************\
*
* Function:     int SelectCard(int *selected)
*
* Description:  Gets a sound card selection from the user. Updates
*               midasSDNumber and midasSDCard.
*
* Returns:      MIDAS error code. *selected contains 1 if selection was
*               successful (Enter was pressed) or 0 if not (Escape).
*
\****************************************************************************/

static int SelectCard(int *selected)
{
    char        **cardNames;            /* sound card names */
    int         *cardSDs;               /* Sound Device number corresponding
                                           to each sound card selection */
    int         *cardTypes;             /* SD sound card type corresponding
                                           to each sound card selection */
    int         numCards;               /* total number of card selections */
    int         sdNum, cardNum, i;
    int         error;
    SoundDevice *SD;

    /* find the total number of sound cards: */
    numCards = 0;
    for ( sdNum = 0; sdNum < NUMSDEVICES; sdNum++ )
        numCards += midasSoundDevices[sdNum]->numCardTypes;

    /* allocate memory for card name pointers: */
    if ( (error = memAlloc(numCards * sizeof(char*), (void**) &cardNames))
        != OK )
        midasError(error);

    /* allocate memory for Sound Device numbers: */
    if ( (error = memAlloc(numCards * sizeof(int), (void**) &cardSDs)) != OK )
        midasError(error);

    /* allocate memory for sound card type numbers: */
    if ( (error = memAlloc(numCards * sizeof(int), (void**) &cardTypes))
        != OK )
        midasError(error);

    /* Set all entries in cardNames[], cardSDs[] and cardTypes[] to their
       correct values: */
    cardNum = 0;
    for ( sdNum = 0; sdNum < NUMSDEVICES; sdNum++ )
    {
        /* Point SD to current Sound Device: */
        SD = midasSoundDevices[sdNum];

        /* Do for all sound card possibilities for this SD: */
        for ( i = 0; i < SD->numCardTypes; i++ )
        {
            cardSDs[cardNum] = sdNum;
            cardNames[cardNum] = SD->cardNames[i];
            cardTypes[cardNum] = i + 1;
            cardNum++;
        }
    }

    /* Attempt to autodetect sound card type: */
    midasDetectSD();
    detectedSD = midasSDNumber;

    /* If a Sound Device was detected, attempt to find a sound card from
       the selections which corresponds to the detected type: */
    cardNum = 0;
    if ( midasSDNumber != -1 )
    {
        for ( i = 0; i < numCards; i++ )
        {
            /* If the Sound Device number and card type number match, this
               is the correct sound card */
            if ( (cardSDs[i] == midasSDNumber) &&
                 (cardTypes[i] == midasSD->cardType) )
                cardNum = i;
        }
    }

    /* Get user sound card selection: */
    cardNum = AskSelection("Select Sound Card", cardNames, numCards, cardNum);

    /* If a card was selected, set up midasSDNumber, midasSDCard and
       midasSD variables for later use: */
    if ( cardNum != -1 )
    {
        midasSDNumber = cardSDs[cardNum];
        midasSDCard = cardTypes[cardNum];
        midasSD = midasSoundDevices[midasSDNumber];

        *selected = 1;                  /* selected succesfully */
    }
    else
    {
        /* Esc was pressed - no sound card selected */
        *selected = 0;
    }

    /* Deallocate sound card names: */
    if ( (error = memFree(cardNames)) != OK )
        midasError(error);

    /* Deallocate sound card Sound Device numbers: */
    if ( (error = memFree(cardSDs)) != OK )
        midasError(error);

    /* Deallocate sound card type numbers: */
    if ( (error = memFree(cardTypes)) != OK )
        midasError(error);

    return OK;
}




/****************************************************************************\
*
* Function:     int SelectPort(int *selected)
*
* Description:  Gets a sound card I/O port selection from the user. Updates
*               midasSDPort. Assumes that midasSD points to the correct
*               Sound Device.
*
* Returns:      MIDAS error code. *selected contains 1 if selection was
*               successful (Enter was pressed) or 0 if not (Escape).
*
\****************************************************************************/

static int SelectPort(int *selected)
{
    int         numPorts;               /* number of port values */
    char        **portStrs;             /* pointers to port value strings */
    unsigned    *portValues;            /* port values */
    int         error;
    int         portNum, i;
    int         portValue;
    int         defaultSel;
    static int  result;
    long        portVal;
    static char promptStr[4];

    numPorts = midasSD->numPortAddresses;

    /* If the selected Sound Device is not the one initially detected,
       call its Detect() routine to autodetect port, IRQ and DMA values:
       (Borland Pascal extender seems to cause some problems if the PAS
       detection routine is called twice) */
    if ( midasSDNumber != detectedSD )
        if ( (error = midasSD->Detect(&result)) != OK )
            midasError(error);

    /* Allocate memory for I/O port string pointers: */
    if ( (error = memAlloc((numPorts+1) * sizeof(char*), (void**) &portStrs))
        != OK )
        midasError(error);

    /* Point portValues to Sound Device port address table: */
    portValues = midasSD->portAddresses;

    defaultSel = 0;
    for ( portNum = 0; portNum < numPorts; portNum++ )
    {
        /* Allocate memory for port number string ("xxxh\0"): */
        if ( (error = memAlloc(5, (void**) &portStrs[portNum])) != OK )
            midasError(error);

        portValue = portValues[portNum];

        /* Convert port value to a hexadecimal number: */
        portStrs[portNum][0] = hexDigits[portValue >> 8];
        portStrs[portNum][1] = hexDigits[(portValue >> 4) & 0x0F];
        portStrs[portNum][2] = hexDigits[portValue & 0x0F];
        portStrs[portNum][3] = 'h';
        portStrs[portNum][4] = 0;

        /* If current port value is equal to the SD port field, set this
           one as the default: */
        if ( portValue == midasSD->port)
            defaultSel = portNum;
    }

    /* Add "Other" as the last selection: */
    portStrs[numPorts] = "Other";

    /* Ask the user for the port number: */
    portNum = AskSelection("Select Sound Card I/O Port Address", portStrs,
        numPorts+1, defaultSel);

    if ( portNum != -1 )
    {
        /* Enter was pressed - if the selection was not "Other", place the
           selected port address to midasSDPort: */
        if ( portNum != numPorts )
        {
            midasSDPort = portValues[portNum];
        }
        else
        {
            /* "Other" was selected - prompt the user for the port value */
            portVal = -1;
            while ( portVal == -1 )
            {
                /* prompt the user for port value */
                if ( PromptString("Enter Sound Card I/O Port Address "
                    "(in HEXADECIMAL)", 3, &promptStr[0]) == 0 )
                {
                    /* PromptString() returned 0 - Escape was pressed */
                    selected = 0;
                    return OK;
                }

                /* Convert string to a long integer. If an illegal string
                   had been entered, the value will be -1 and the user will
                   be prompted for it again. */
                portVal = mHex2Long(&promptStr[0]);
            }

            /* Set the entered port value to midasSDPort: */
            midasSDPort = portVal;
        }
        *selected = 1;
    }
    else
        *selected = 0;

    /* Deallocate the memory allocated for each port number string: */
    for ( i = 0; i < numPorts; i++ )
    {
        if ( (error = memFree(portStrs[i])) != OK )
            midasError(error);
    }

    /* Deallocate port number string pointers: */
    if ( (error = memFree(portStrs)) != OK )
        midasError(error);

    return OK;
}




/****************************************************************************\
*
* Function:     int SelectIRQ(int *selected)
*
* Description:  Gets a sound card IRQ number selection from the user. Updates
*               midasSDIRQ. Assumes that midasSD points to the correct
*               Sound Device.
*
* Returns:      MIDAS error code. *selected contains 1 if selection was
*               successful (Enter was pressed) or 0 if not (Escape).
*
\****************************************************************************/

static int SelectIRQ(int *selected)
{
    int         IRQNum;
    int         i;

    /* Search through IRQ value table to find the entry that corresponds to
       the current Sound Device IRQ number: */
    IRQNum = 0;
    for ( i = 0; i < NUMIRQS; i++ )
    {
        if ( IRQs[i] == midasSD->IRQ )
            IRQNum = i;
    }

    /* Get the user IRQ selection: */
    IRQNum = AskSelection("Select Sound Card IRQ Number",
        (char**) &IRQStrings[0], NUMIRQS, IRQNum);

    if ( IRQNum != -1 )
    {
        /* Enter was pressed - set selected IRQ number to midasSDIRQ: */
        midasSDIRQ = IRQs[IRQNum];
        *selected = 1;
    }
    else
    {
        /* Escape was pressed - do not set IRQ number */
        *selected = 0;
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int SelectDMA(int *selected)
*
* Description:  Gets a sound card DMA channel number selection from the user.
*               Updates midasSDDMA. Assumes that midasSD points to the correct
*               Sound Device.
*
* Returns:      MIDAS error code. *selected contains 1 if selection was
*               successful (Enter was pressed) or 0 if not (Escape).
*
\****************************************************************************/

static int SelectDMA(int *selected)
{
    int         DMANum;
    int         i;

    /* Search through DMA value table to find the entry that corresponds to
       the current Sound Device DMA number: */
    DMANum = 0;
    for ( i = 0; i < NUMDMAS; i++ )
    {
        if ( DMAs[i] == midasSD->DMA )
            DMANum = i;
    }

    /* Get the user IRQ selection: */
    DMANum = AskSelection("Select Sound Card DMA Channel Number",
        (char**) &DMAStrings[0], NUMDMAS, DMANum);

    if ( DMANum != -1 )
    {
        /* Enter was pressed - set selected DMA number to midasSDDMA: */
        midasSDDMA = DMAs[DMANum];
        *selected = 1;
    }
    else
    {
        /* Escape was pressed - do not set IRQ number */
        *selected = 0;
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int SelectMixRate(int *selected)
*
* Description:  Gets a mixing rate selection from the user. Updates
*               midasMixRate. Assumes that midasSD points to the correct
*               Sound Device.
*
* Returns:      MIDAS error code. *selected contains 1 if selection was
*               successful (Enter was pressed) or 0 if not (Escape).
*
\****************************************************************************/

static int SelectMixRate(int *selected)
{
    int         rateNum;
    long        rateVal;
    static char promptStr[6];

    /* Get mixing rate selection from user: */
    rateNum = AskSelection("Select mixing rate", (char**) &mixRateStrings[0],
        NUMRATES+1, DEFAULTRATE);

    if ( rateNum != -1 )
    {
        /* A selection was made. If the selected value was not "Other",
           update midasMixRate: */
        if ( rateNum != NUMRATES )
        {
            midasMixRate = mixRates[rateNum];
        }
        else
        {
            /* "Other" was selected - prompt the user for mixing rate */
            rateVal = -1;
            while ( rateVal == -1 )
            {
                /* prompt the user for mixing rate: */
                if ( PromptString("Enter Mixing Rate (in DECIMAL)", 5,
                    &promptStr[0]) == 0 )
                {
                    /* PromptString() returned 0 - Escape was pressed */
                    selected = 0;
                    return OK;
                }

                /* Convert string to a long integer. If an illegal string
                   had been entered, the value will be -1 and the user will
                   be prompted for it again. */
                rateVal = mDec2Long(&promptStr[0]);

                /* Do not allow values larger than 65535 to prevent
                   overflows: */
                if ( rateVal > 65535 )
                    rateVal = -1;
            }

            /* Set the entered value to midasMixRate: */
            midasMixRate = rateVal;
        }

        *selected = 1;
    }
    else
        *selected = 0;

    return OK;
}



/****************************************************************************\
*
* Function:     int SelectOutputMode(int *selected)
*
* Description:  Gets a output mode selection from the user. Updates
*               midasOutputMode. Assumes that midasSD points to the correct
*               Sound Device.
*
* Returns:      MIDAS error code. *selected contains 1 if selection was
*               successful (Enter was pressed) or 0 if not (Escape).
*
\****************************************************************************/

static int SelectOutputMode(int *selected)
{
    int         modeNum;
    int         numModes = 0;
    static char *modeStr[NUMMODES];
    unsigned    modeBits[NUMMODES];
    int         defaultMode = 0;
    unsigned    sdModes = midasSD->modes;   /* available Sound Device modes */


    /* Search through outputModes[] table to find the output modes the
       Sound Device is capable of playing and add them to modeStr[]
       and modeBits[]: */
    for ( modeNum = 0; modeNum < NUMMODES; modeNum++ )
    {
        if ( (sdModes & outputModes[modeNum]) == outputModes[modeNum] )
        {
            /* Sound Device can play mode modeNum - add to tables: */
            modeStr[numModes] = outputModeStrings[modeNum];
            modeBits[numModes] = outputModes[modeNum];

            /* If the current mode is DEFAULTSTEREO (sdMono usually), set it
               as the default output mode - 16-bit modes always follow 8-bit
               modes in the list: */
            if ( (outputModes[modeNum] & DEFAULTSTEREO) == DEFAULTSTEREO )
                defaultMode = numModes;

            numModes++;
        }
    }


    /* Get output mode selection from user: */
    if (numModes>1) {
      modeNum = AskSelection("Select output mode", modeStr, numModes, defaultMode);
    } else modeNum=defaultMode;

    if ( modeNum != -1 )
    {
        /* A selection was made - update midasOutputMode: */
        midasOutputMode = modeBits[modeNum];
        *selected = 1;
    }
    else
        *selected = 0;

    return OK;
}



/****************************************************************************\
*
* Function:     int midasConfig(void)
*
* Description:  MIDAS Sound System configuration. Prompts the user for all
*               configuration information and sets the MIDAS variables
*               accordingly. Call before midasInit() but after
*               midasSetDefaults().
*
* Returns:      1 if configuration was successful, 0 if not (Esc was pressed)
*
\****************************************************************************/

int CALLING midasConfig(void)
{
    static int  selected;

    InitScreen();
    SelectCard(&selected);
    if ( selected && (midasSD->configBits & sdUsePort) )
        SelectPort(&selected);
    if ( selected && (midasSD->configBits & sdUseIRQ) )
        SelectIRQ(&selected);
    if ( selected && (midasSD->configBits & sdUseDMA) )
        SelectDMA(&selected);
    if ( selected && (midasSD->configBits & sdUseMixRate) )
        SelectMixRate(&selected);
    if ( selected && (midasSD->configBits & sdUseOutputMode) )
        SelectOutputMode(&selected);

    /* Move cursor to top left corner of the screen: */
    vgaMoveCursor(0, 0);

    /* Fill whole screen with black background, white foreground: */
    vgaFillRect(1, 1, 80, 25, 0x07);

    return selected;
}


#ifndef NOLOADERS



/****************************************************************************\
*
* Function:     int midasLoadConfig(char *fileName);
*
* Description:  Loads configuration from file saved using midasSaveConfig().
*
* Input:        char *fileName          configuration file name, ASCIIZ
*
* Returns:      1 if successful, 0 if file not found.
*
\****************************************************************************/

void CALLING midasLoadConfig(char *fileName)
{
    static fileHandle  f;
    int         error;

    /* open configuration file: */
    if ( (error = fileOpen(fileName, fileOpenRead, &f)) != OK )
        midasError(error);

    /* read Sound Device number: */
    if ( (error = fileRead(f, &midasSDNumber, sizeof(int))) != OK )
        midasError(error);

    /* read sound card type: */
    if ( (error = fileRead(f, &midasSDCard, sizeof(int))) != OK )
        midasError(error);

    /* read Sound Device I/O port number: */
    if ( (error = fileRead(f, &midasSDPort, sizeof(int))) != OK )
        midasError(error);

    /* read Sound Device IRQ number: */
    if ( (error = fileRead(f, &midasSDIRQ, sizeof(int))) != OK )
        midasError(error);

    /* read Sound Device DMA channel number: */
    if ( (error = fileRead(f, &midasSDDMA, sizeof(int))) != OK )
        midasError(error);

    /* read mixing rate: */
    if ( (error = fileRead(f, &midasMixRate, sizeof(unsigned))) != OK )
        midasError(error);

    /* read output mode: */
    if ( (error = fileRead(f, &midasOutputMode, sizeof(unsigned))) != OK )
        midasError(error);

    /* close configuration file: */
    if ( (error = fileClose(f)) != OK )
        midasError(error);
}




/****************************************************************************\
*
* Function:     void midasSaveConfig(char *fileName);
*
* Description:  Saves configuration to a file
*
* Input:        char *fileName          configuration file name, ASCIIZ
*
\****************************************************************************/

void CALLING midasSaveConfig(char *fileName)
{
    static fileHandle  f;
    int         error;

    /* open configuration file: */
    if ( (error = fileOpen(fileName, fileOpenWrite, &f)) != OK )
        midasError(error);

    /* write Sound Device number: */
    if ( (error = fileWrite(f, &midasSDNumber, sizeof(int))) != OK )
        midasError(error);

    /* write sound card type: */
    if ( (error = fileWrite(f, &midasSDCard, sizeof(int))) != OK )
        midasError(error);

    /* write Sound Device I/O port number: */
    if ( (error = fileWrite(f, &midasSDPort, sizeof(int))) != OK )
        midasError(error);

    /* write Sound Device IRQ number: */
    if ( (error = fileWrite(f, &midasSDIRQ, sizeof(int))) != OK )
        midasError(error);

    /* write Sound Device DMA channel number: */
    if ( (error = fileWrite(f, &midasSDDMA, sizeof(int))) != OK )
        midasError(error);

    /* write mixing rate: */
    if ( (error = fileWrite(f, &midasMixRate, sizeof(unsigned))) != OK )
        midasError(error);

    /* write output mode: */
    if ( (error = fileWrite(f, &midasOutputMode, sizeof(unsigned))) != OK )
        midasError(error);

    /* close configuration file: */
    if ( (error = fileClose(f)) != OK )
        midasError(error);
}

#endif


/*
 * $Log: mconfig.c,v $
 * Revision 1.4  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.3  1996/08/06 18:45:47  pekangas
 * Fixed title text width and underlining
 *
 * Revision 1.2  1996/06/06 20:32:14  pekangas
 * Changed to clear the screen after setup
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/