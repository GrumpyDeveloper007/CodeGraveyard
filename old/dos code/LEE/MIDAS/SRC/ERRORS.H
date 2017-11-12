/*      errors.h
 *
 * MIDAS Sound System error codes and error message strings
 *
 * $Id: errors.h,v 1.6 1996/10/20 20:53:36 pekangas Exp $
 *
 * Copyright 1996 Petteri Kangaslampi and Jarno Paananen
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/


#ifndef __errors_h
#define __errors_h


#define MAXERRORS 256       /* maximum number of errors to store */


/****************************************************************************\
*       enum ErrorCodes
*       ---------------
* Description:  MIDAS Sound System error codes
\****************************************************************************/

enum ErrorCodes
{
    OK = 0,                             /* no error */
    errUndefined,                       /* undefined error */
    errOutOfMemory,                     /* out of (conventional) memory */
    errHeapCorrupted,                   /* (conventional memory) heap
                                           corrupted */
    errInvalidBlock,                    /* invalid memory block */
    errOutOfEMS,                        /* out of EMS memory */
    errEMSHeapCorrupted,                /* EMS heap corrupted */
    errInvalidEMSBlock,                 /* invalid EMS memory block */
    errEMMFailure,                      /* Expanded Memory Manager failure */
    errOutOfCardMemory,                 /* out of soundcard memory */
    errCardHeapCorrupted,               /* soundcard heap corrupted */
    errInvalidCardBlock,                /* invalid soundcard memory block */
    errNoSampleHandles,                 /* out of sample handles */
    errFileOpen,                        /* unable to open file */
    errFileRead,                        /* unable to read file */
    errInvalidModule,                   /* invalid module file */
    errInvalidInst,                     /* invalid instrument in module */
    errInvalidPatt,                     /* invalid pattern data in module */
    errInvalidChanNumber,               /* invalid channel number */
    errInvalidSampleHandle,             /* invalid sample handle */
    errNoChannels,                      /* Sound Device channels not open */
    errSDFailure,                       /* Sound Device hardware failure */
    errInvalidArguments,                /* invalid function arguments */
    errFileNotFound,                    /* file does not exist */
    errInvalidFileHandle,               /* invalid file handle */
    errAccessDenied,                    /* access denied */
    errFileExists,                      /* file exists */
    errTooManyFiles,                    /* too many open files */
    errDiskFull,                        /* disk full */
    errEndOfFile,                       /* unexpected end of file */
    errInvalidPath,                     /* invalid path */
    errFileWrite,                       /* unable to write file */
    errVDSLock,                         /* unable to lock VDS DMA buffer */
    errVDSUsage,                        /* unable to use Virtual DMA */
    errBadVDS,                          /* invalid VDS version */
    errDPMIFailure,                     /* DPMI failure */
    errInvalidDescriptor,               /* invalid segment descriptor */
    errOutOfResources,                  /* out of system resources */
    errInvalidDevice,                   /* invalid device used */
    errUnsupported,                     /* unsupported function used */
    errDeviceNotAvailable,              /* device not available */
    errDeviceBusy,                      /* device is busy */
    errBadMode,                         /* unsupported output mode used */
    errUnableToLock,                    /* unable to lock memory */
    errNumErrorCodes
};



/****************************************************************************\
*       enum FunctionIDs
*       ----------------
* Description:  ID numbers for first functions in all modules
\****************************************************************************/

enum FunctionIDs
{
    ID_error = 0,                       /* error handling */
    ID_dma = 100,                       /* DMA handling routines */
    ID_dsm = 200,                       /* Digital Sound Mixer */
    ID_ems = 300,                       /* EMS heap manager */
    ID_mem = 400,                       /* Conventional memory management */
    ID_mod = 500,                       /* Protracker Module Player */
    ID_s3m = 600,                       /* Scream Tracker 3 Module Player */
    ID_mtm = 700,                       /* Multitracker Module Player */
    ID_tmr = 1000,                      /* TempoTimer */
    ID_vu = 1100,                       /* Real VU meters */
    ID_rf = 1200,                       /* Raw file I/O */
    ID_file = 1300,                     /* High-level file I/O */
    ID_dpmi = 1400,                     /* DPMI functions */
    ID_gmp = 1500,                      /* Generic Module Player */
    ID_fx = 1600,                       /* Sound effects library */
    ID_str = 1700,                      /* Stream library */
    ID_gus = 2000,                      /* GUS Sound Device */
    ID_pas = 2100,                      /* PAS Sound Device */
    ID_wss = 2200,                      /* WSS Sound Device */
    ID_sb = 2300,                       /* SB Sound Device */
    ID_winw = 2400,                     /* Windows Wave Sound Device */
    ID_oss = 2500,                      /* OSS Sound Device */
    ID_gdc = 2600,                      /* GUS Mixing Sound Device */
    ID_awe = 2700,                      /* AWE32 Sound Device */
    ID_nsnd = 2900,                     /* No Sound Sound Device */
    ID_mixsd = 3000                     /* Common mixing Sound Device
                                           functions */
};



#ifdef __cplusplus
extern "C" {
#endif


#ifdef DEBUG

/****************************************************************************\
*       struct errRecord
*       ----------------
* Description:  Error record for error list
\****************************************************************************/

typedef struct
{
    int         errorCode;              /* error code number */
    unsigned    functID;                /* ID for function that caused the
                                           error */
} errRecord;


extern errRecord GLOBALVAR  errorList[MAXERRORS];       /* error list */
extern unsigned GLOBALVAR   numErrors;  /* number of errors in list */



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

void CALLING errAdd(int errorCode, unsigned functID);




/****************************************************************************\
*
* Function:     void errClearList(void)
*
* Description:  Clears the error list. Can be called if a error has been
*               handled without exiting the program to avoid filling the
*               error list with handled errors.
*
\****************************************************************************/

void CALLING errClearList(void);




/****************************************************************************\
*
* Function:     void errPrintList(void);
*
* Description:  Prints the error list to stderr
*
\****************************************************************************/

void CALLING errPrintList(void);


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

void CALLING errErrorExit(char *msg);






/* error message string pointers: */
extern char * GLOBALVAR errorMsg[errNumErrorCodes];


#ifdef __cplusplus
}
#endif




//win-
#ifdef ERROR
#undef ERROR
#endif


/* ERROR - adds an error to the MIDAS error list if DEBUG is defined.
   Does nothing otherwise. */

#ifdef DEBUG
    #define ERROR(errCode, functID) errAdd(errCode, functID)
#else
    #define ERROR(errCode, functID)
#endif


/* PASSERROR - passes error value in variable error on */

#ifdef DEBUG
    #define PASSERROR(functID) { errAdd(error, functID); return error; }
#else
    #define PASSERROR(functID) return error;
#endif



/* CLEARERRORLIST - clear the MIDAS error list if DEBUG is defined. */
#ifdef DEBUG
    #define CLEARERRORLIST errClearList();
#else
    #define CLEARERRORLIST ;
#endif



#endif  /* #ifndef __errors_h */


/*
 * $Log: errors.h,v $
 * Revision 1.6  1996/10/20 20:53:36  pekangas
 * Added AWE32 Sound Device ID
 *
 * Revision 1.5  1996/09/22 23:15:33  pekangas
 * Added ID_fx and ID_str
 *
 * Revision 1.4  1996/09/21 16:38:00  jpaana
 * Changed uss to oss
 *
 * Revision 1.3  1996/06/05 19:40:35  jpaana
 * Changed usswave to uss
 *
 * Revision 1.2  1996/05/24 20:40:12  jpaana
 * Added USSWave
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/