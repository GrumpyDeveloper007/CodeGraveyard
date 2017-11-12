;*      errors.inc
;*
;* MIDAS Sound System error codes and error message strings
;*
;* $Id: errors.inc,v 1.4 1997/01/16 18:41:59 pekangas Exp $
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
;*	 enum ErrorCodes
;*	 ---------------
;* Description:  MIDAS Sound System error codes
;\***************************************************************************/

ENUM	ErrorCodes \
	OK = 0, \			; no error
	errUndefined, \ 		; undefined error
	errOutOfMemory, \		; out of (conventional) memory
	errHeapCorrupted, \		; (conventional memory) heap corrupted
	errInvalidBlock, \		; invalid memory block
	errOutOfEMS, \			; out of EMS memory
	errEMSHeapCorrupted, \		; EMS heap corrupted
	errInvalidEMSBlock, \		; invalid EMS memory block
	errEMMFailure, \		; Expanded Memory Manager failure
	errOutOfCardMemory, \		; out of soundcard memory
	errCardHeapCorrupted, \ 	; soundcard heap corrupted
	errInvalidCardBlock, \		; invalid soundcard memory block
	errNoInstHandles, \		; out of instrument handles
	errFileOpen, \			; unable to open file
	errFileRead, \			; unable to read file
	errInvalidModule, \		; invalid module file
	errInvalidInst, \		; invalid instrument in module
	errInvalidPatt, \		; invalid pattern data in module
	errInvalidChanNumber, \ 	; invalid channel number
	errInvalidSampleHandle, \	  ; invalid instrument handle
	errNoChannels, \		; Sound Device channels not open
	errSDFailure, \ 		; Sound Device hardware failure
	errInvalidArguments, \		; invalid function arguments
	errFileNotFound, \		; file does not exist
	errInvalidFileHandle, \ 	; invalid file handle
	errAccessDenied, \		; access denied
	errFileExists, \		; file exists
	errTooManyFiles, \		; too many open files
	errDiskFull, \			; disk full
	errEndOfFile, \ 		; unexpected end of file
	errInvalidPath, \		; invalid path
	errFileWrite, \ 		; unable to write file
	errVDSLock, \			; unable to lock VDS DMA buffer
	errVDSUsage, \			; unable to use Virtual DMA
	errBadVDS, \			; invalid VDS version
	errDPMIFailure, \		; DPMI failure
	errInvalidDescriptor, \ 	; invalid segment descriptor
	errOutOfResources		; out of system resources




GLOBAL	LANG errorMsg : _ptr		; error message strings


;/***************************************************************************\
;*	 enum FunctionIDs
;*	 ----------------
;* Description:  ID numbers for first functions in all modules
;\***************************************************************************/

ENUM	FunctionIDs \
	ID_error = 0, \ 		; error handling
	ID_dma = 100, \ 		; DMA handling routines
	ID_dsm = 200, \ 		; Digital Sound Mixer
	ID_ems = 300, \ 		; EMS heap manager
	ID_mem = 400, \ 		; Conventional memory management
	ID_mod = 500, \ 		; Protracker Module Player
	ID_s3m = 600, \ 		; Scream Tracker 3 Module Player
	ID_mtm = 700, \ 		; Multitracker Module Player
	ID_tmr = 1000, \		; TempoTimer
	ID_vu = 1100, \ 		; Real VU meters
	ID_rf = 1200, \ 		; Raw file I/O
	ID_file = 1300, \		; High-level file I/O
	ID_dpmi = 1400, \		; DPMI functions
	ID_gmp = 1500, \		; Generic Module Player
        ID_fx = 1600, \                 ; Sound effects library
        ID_str = 1700, \                ; Stream library
	ID_gus = 2000, \		; GUS Sound Device
	ID_pas = 2100, \		; PAS Sound Device
	ID_wss = 2200, \		; WSS Sound Device
	ID_sb = 2300, \ 		; SB Sound Device
        ID_winw = 2400, \               ; Windows Wave Sound Device
        ID_oss = 2500, \                ; OSS Sound Device
        ID_gdc = 2600, \                ; GUS Mixing Sound Device
	ID_nsnd = 2900, \		; No Sound Sound Device
	ID_mixsd = 3000 		; Mixing Sound Device common functions



IFDEF DEBUG

;/***************************************************************************\
;*	 struct errRecord
;*	 ----------------
;* Description:  Error record for error list
;\***************************************************************************/

STRUC	errRecord
D_int	errorCode			; error code number
D_int	functID 			; ID for function that caused the
					; error
ENDS

MAXERRORS = 256 			; maximum number of errors in list

GLOBAL	LANG errorList : errRecord	; error list
GLOBAL	LANG numErrors : _int		; number of errors in list



;/***************************************************************************\
;*
;* Function:	 void errAdd(int errorCode, unsigned functID);
;*
;* Description:  Add an error to error list
;*
;* Input:	 int errorCode		 error code
;*		 unsigned functID	 ID for function that caused the error
;*
;\***************************************************************************/

GLOBAL	LANG errAdd : _funct




;/***************************************************************************\
;*
;* Function:	void errClearList(void)
;*
;* Description: Clears the error list. Can be called if a error has been
;*		handled without exiting the program to avoid filling the
;*		error list with handled errors.
;*
;\***************************************************************************/

GLOBAL	LANG errClearList : _funct




;/***************************************************************************\
;*
;* Function:	 void errPrintList(void);
;*
;* Description:  Prints the error list to stderr
;*
;\***************************************************************************/

GLOBAL	LANG errPrintList : _funct


ENDIF



;/***************************************************************************\
;*
;* Function:	 void errErrorExit(char *msg)
;*
;* Description:  Set up standard text mode, print an error message and exit
;*
;* Input:	 char *msg		 pointer to error message, ASCIIZ
;*
;\***************************************************************************/

GLOBAL	LANG errErrorExit : _funct




;/***************************************************************************\
;*
;* Macro:	ERROR	functID
;*
;* Description: Adds an error to the MIDAS error list if DEBUG is defined.
;*		Does nothing otherwise.
;*
;* Input:	ax		error code
;*		functID 	function ID
;*
;* Destroys:	all except ax, ds, si, di
;*
;\***************************************************************************/

MACRO	ERROR	functID
IFDEF	DEBUG
	push	_ax
	call	errAdd LANG, _ax, functID
	pop	_ax
ENDIF
ENDM


;* $Log: errors.inc,v $
;* Revision 1.4  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.3  1996/09/22 23:15:45  pekangas
;* Updated to correspond to current errors.h
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*