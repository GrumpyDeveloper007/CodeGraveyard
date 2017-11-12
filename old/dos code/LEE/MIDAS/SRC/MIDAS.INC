;*      MIDAS.INC
;*
;* Simplified MIDAS Sound System API
;*
;* $Id: midas.inc,v 1.3 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*

; Note that the Simplified MIDAS API for assembler is implemented in C.
; The source is in file MIDAS.C.

taa ei toimi!


;/***************************************************************************\
;*     MIDAS version defines
;\***************************************************************************/

MVERSION        EQU     0.40a
MVERSTR         EQU     "0.40a"
MVERNUM = 0040h




;/***************************************************************************\
;*     MIDAS header files:
;\***************************************************************************/

; Far NULL pointer:
NULL            EQU     0 0

INCLUDE "lang.inc"
INCLUDE "errors.inc"
INCLUDE "mglobals.inc"
INCLUDE "mmem.inc"
INCLUDE "rawfile.inc"
INCLUDE "file.inc"
INCLUDE "sdevice.inc"
INCLUDE "mplayer.inc"
INCLUDE "s3m.inc"
INCLUDE "mod.inc"
INCLUDE "mtm.inc"
INCLUDE "timer.inc"
INCLUDE "ems.inc"
INCLUDE "dma.inc"
INCLUDE "dsm.inc"
INCLUDE "vu.inc"
INCLUDE "mconfig.inc"
INCLUDE "mparser.inc"
INCLUDE "vgatext.inc"
INCLUDE "mutils.inc"
INCLUDE "mm.inc"



;/***************************************************************************\
;*      MIDAS global variables:
;\***************************************************************************/

GLOBAL LANG GUS : SoundDevice           ; Gravis UltraSound Sound Device
GLOBAL LANG GDC : SoundDevice           ; Gravis UltraSound Sound Device
GLOBAL LANG PAS : SoundDevice           ; Pro Audio Spectrum Sound Device
GLOBAL LANG WSS : SoundDevice           ; Windows Sound System Sound Device
GLOBAL LANG SB : SoundDevice            ; Sound Blaster Sound Device
GLOBAL LANG NSND : SoundDevice          ; No Sound Sound Device

NUMSDEVICES = 6                         ; total number of Sound Devices
NUMMPLAYERS = 3                         ; total number of Module Players

GLOBAL LANG mpS3M : ModulePlayer        ; Scream Tracker 3 Module Player
GLOBAL LANG mpMOD : ModulePlayer        ; Protracker Module Player
GLOBAL LANG mpMTM : ModulePlayer        ; Multitracker Module Player

GLOBAL LANG midasSD : dword             ; current Sound Device
GLOBAL LANG midasMP : dword             ; current Module Player

    ; array to pointers to all Sound Devices, in numbering and detection
    ; order - GUS is SD #1:
GLOBAL LANG midasSoundDevices : dword

GLOBAL LANG midasDisableEMS : word      ; 1 if EMS usage is disabled
                                        ; (default 0)
GLOBAL LANG midasSDNumber : word        ; Sound Device number (-1 for
                                        ; autodetect, default -1)
GLOBAL LANG midasSDPort : word          ; Sound Device I/O port number
                                        ; (-1 for autodetect or SD default,
                                        ; default -1)
GLOBAL LANG midasSDIRQ : word           ; Sound Device IRQ number (-1 for
                                        ; autodetect or SD default,
                                        ; default -1)
GLOBAL LANG midasSDDMA : word           ; Sound Device DMA channel number
                                        ; (-1 for autodetect or SD default,
                                        ; default -1)
GLOBAL LANG midasSDCard : word          ; Sound Device sound card type
                                        ; (-1 for autodetect or SD default,
                                        ; default -1)
GLOBAL LANG midasMixRate : word         ; Sound Device mixing rate
GLOBAL LANG midasOutputMode : word      ; Sound Device output mode force
                                        ; bits, default 0 (SD default)
GLOBAL LANG midasAmplification : word   ; Forced amplification level or -1
                                        ; for SD default (default -1)
GLOBAL LANG midasChannels : word        ; number of channels open or 0 if no
                                        ; channels have been opened using
                                        ; midasOpenChannels()
GLOBAL LANG midasPlayerNum : word       ; timer music player number


GLOBAL LANG midasEMSInit : word         ; is EMS heap manager initialized?
GLOBAL LANG midasTMRInit : word         ; is TempoTimer initialized?
GLOBAL LANG midasTMRPlay : word         ; is sound beind player with timer?
GLOBAL LANG midasSDInit : word          ; is Sound Device initialized?
GLOBAL LANG midasSDChans : word         ; are Sound Device channels open?
GLOBAL LANG midasMPInit : word          ; is Module Player initialized?
GLOBAL LANG midasMPPlay : word          ; is Module Player playing?
GLOBAL LANG midasTMRMusic : word        ; is music being player with timer?




;/***************************************************************************\
;*     MIDAS global functions from MIDAS.C:
;\***************************************************************************/



;/***************************************************************************\
;*
;* Function:    void midasError(int errNum)
;*
;* Description: Prints a MIDAS error message to stderr and exits to DOS
;*
;* Input:       int errNum              MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG midasError : far




;/***************************************************************************\
;*;* Function:    void midasUninitError(int errNum)
;*
;* Description: Prints an error message to stderr and exits to DOS without
;*              uninitializing MIDAS. This function should only be used
;*              from midasClose();
;*
;* Input:       int errNum              MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG midasUninitError : far




;/***************************************************************************\
;*
;* Function:    void midasDetectSD(void)
;*
;* Description: Attempts to detect a Sound Device. Sets the global variable
;*              midasSD to point to the detected Sound Device or NULL if no
;*              Sound Device was detected
;*
;\***************************************************************************/

GLOBAL  LANG midasDetectSD : far




;/***************************************************************************\
;*
;* Function:    void midasInit(void)
;*
;* Description: Initializes MIDAS Sound System
;*
;\***************************************************************************/

GLOBAL  LANG midasInit : far




;/***************************************************************************\
;*
;* Function:    void midasClose(void)
;*
;* Description: Uninitializes MIDAS Sound System
;*
;\***************************************************************************/

GLOBAL  LANG midasClose : far




;/***************************************************************************\
;*
;* Function:    void midasSetDefaults(void)
;*
;* Description: Initializes MIDAS Sound System variables to their default
;*              states. MUST be the first MIDAS function to be called.
;*
;\***************************************************************************/

GLOBAL  LANG midasSetDefaults : far




;/***************************************************************************\
;*
;* Function:    mpModule *midasLoadModule(char *fileName, ModulePlayer *MP,
;*                  int (*SaveSampleInfo)(ushort sdInstHandle, uchar *sample,
;*                  ushort slength, ushort loopStart, ushort loopEnd );
;*
;* Description: Loads a module file into memory.
;*
;* Input:       char *fileName          Pointer to module file name
;*              ModulePlayer *MP        Pointer to the Module Player which
;*                                      will be used for loading the module
;*              int (*SaveSampleInfo)() Pointer to sample information saving
;*                                      function. sdInstHandle = Sound Device
;*                                      instrument handle, sample = pointer to
;*                                      sample data, slength = sample length,
;*                                      loopStart = sample loop start,
;*                                      loopEnd = sample loop end. The
;*                                      function must return a MIDAS error
;*                                      code. NULL if no such function is
;*                                      used.
;*
;* Returns:     Pointer to the loaded module structure
;*
;* Notes:       The only practical use at this point for SaveSampleInfo() are
;*              the real VU-meters. To load a module and add the prepare the
;*              VU meter information use:
;*                  module = midasLoadModule(fileName, MP, &vuPrepare);
;*              Note that the definition of SaveSampleInfo matches exactly
;*              the prototype of vuPrepare().
;*
;\***************************************************************************/

GLOBAL  LANG midasLoadModule : far




;/***************************************************************************\
;*
;* Function:    void midasFreeModule(mpModule *module);
;*
;* Description: Deallocates a module from memory
;*
;* Input:       mpModule *module        Pointer to module to be deallocated
;*
;\***************************************************************************/

GLOBAL  LANG midasFreeModule : far




;/***************************************************************************\
;*
;* Function:    void midasOpenChannels(int numChans);
;*
;* Description: Opens Sound Device channels for sound and music output.
;*
;* Input:       int numChans            Number of channels to open
;*
;* Notes:       Channels opened with this function can be used for sound
;*              playing, and modules played with midasPlayModule() will be
;*              played through the last of these channels. This function is
;*              provided so that the same number of channels can be open
;*              the whole time throughout the execution of the program,
;*              keeping the volume level constant. Note that you must ensure
;*              that you open enough channels for all modules, otherwise
;*              midasPlayModule() will fail.
;*
;\****************************************************************************/

GLOBAL  LANG midasOpenChannels : far




;/***************************************************************************\
;*
;* Function:    void midasCloseChannels(void);
;*
;* Description: Closes Sound Device channels opened with midasOpenChannels().
;*              Do NOT call this function unless you have opened the sound
;*              channels used yourself with midasOpenChannels().
;*
;\***************************************************************************/

GLOBAL  LANG midasCloseChannels : far




;/***************************************************************************\
;*
;* Function:    midasPlayModule(mpModule *module, int numEffectChns)
;*
;* Description: Loads a module into memory, points midasMP to the correct
;*              Module Player and starts playing it.
;*
;* Input:       mpModule *module        Module loaded with midasLoadModule()
;*              int numEffectChns       Number of channels to open for sound
;*                                      effects. Ignored if sound channels
;*                                      have already been opened with
;*                                      midasOpenChannels().
;*
;* Returns:     Pointer to module structure. This function can not fail,
;*              as it will call midasError() to handle all error cases.
;*
;* Notes:       The Sound Device channels available for sound effects are the
;*              _first_ numEffectChns channels. So, for example, if you use
;*              midasPlayModule(module, 3), you can use channels 0-2 for sound
;*              effects. If you already have opened channels with
;*              midasOpenChannels(), the module will be played with the last
;*              possible channels, so that the first channels will be
;*              available for sound effects. Note that if not enough channels
;*              are open this function will fail.
;*
;\****************************************************************************/

GLOBAL  LANG midasPlayModule : far




;/***************************************************************************\
;*
;* Function:    void midasStopModule(mpModule *module)
;*
;* Input:       mpModule *module        the module which is being played
;*
;* Description: Stops playing a module and uninitializes the Module Player.
;*              If sound channels were NOT opened through midasOpenChannels(),
;*              but by letting midasPlayModule() open them, they will be
;*              closed. Sound channels opened with midasOpenChannels() are NOT
;*              closed and must be closed separately.
;*
;\***************************************************************************/

GLOBAL  LANG midasStopModule : far


;* $Log: midas.inc,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*