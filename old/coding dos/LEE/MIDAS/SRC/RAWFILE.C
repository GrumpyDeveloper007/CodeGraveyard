/*      RAWFILE.C
 *
 * Raw file I/O for MIDAS Sound System
 *
 * $Id: rawfile.c,v 1.2 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "mmem.h"
#include "rawfile.h"

RCSID(const char *rawfile_rcsid = "$Id: rawfile.c,v 1.2 1997/01/16 18:41:59 pekangas Exp $";)


/****************************************************************************\
*
* Function:     int ErrorCode(void)
*
* Description:  Get the MIDAS error code corresponding to errno.
*
* Returns:      MIDAS error code
*
\****************************************************************************/

static int ErrorCode(void)
{
    switch ( errno )
    {
        case ENOENT:
            return errFileNotFound;

        case ENODEV:
        #ifdef ENOPATH
        case ENOPATH:
        #endif
            return errInvalidPath;

        case EMFILE:
            return errTooManyFiles;

        case EBADF:
            return errInvalidFileHandle;

        case EACCES:
            return errAccessDenied;

        case ENOMEM:
            return errOutOfMemory;

        case EEXIST:
            return errFileExists;

        default:
            return errUndefined;
    }
}




/****************************************************************************\
*
* Function:     int rfOpen(char *fileName, int openMode, rfHandle *file);
*
* Description:  Opens a file for reading or writing
*
* Input:        char *fileName          name of file
*               int openMode            file opening mode, see enum rfOpenMode
*               rfHandle *file          pointer to file handle
*
* Returns:      MIDAS error code.
*               File handle is stored in *file.
*
\****************************************************************************/

int CALLING rfOpen(char *fileName, int openMode, rfHandle *file)
{
    int         error;
    rfHandle    hdl;

    /* allocate file structure */
    if ( (error = memAlloc(sizeof(rfFile), (void**) &hdl)) != OK )
        PASSERROR(ID_rfOpen)

    switch ( openMode )
    {
        case rfOpenRead:        /* open file for reading */
            hdl->f = fopen(fileName, "rb");
            break;

        case rfOpenWrite:       /* open file for writing */
            hdl->f = fopen(fileName, "wb");
            break;

        case rfOpenReadWrite:   /* open file for reading and writing */
            hdl->f = fopen(fileName, "r+b");
            break;
    }

    /* If an error occurred during opening file, return the error code
       specified by errno: */
    if ( hdl->f == NULL )
    {
        error = ErrorCode();
        ERROR(error, ID_rfOpen);
        return error;
    }

    /* store file handle in *file: */
    *file = hdl;

    return OK;
}




/****************************************************************************\
*
* Function:     int rfClose(rfHandle file);
*
* Description:  Closes a file opened with rfOpen().
*
* Input:        rfHandle file           handle of an open file
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING rfClose(rfHandle file)
{
    int         error;

    /* close file: */
    if ( fclose(file->f) != 0 )
    {
        /* error occurred - return error code specified by errno: */
        error = ErrorCode();
        ERROR(error, ID_rfClose);
        return error;
    }

    /* deallocate file structure: */
    if ( (error = memFree(file)) != OK )
        PASSERROR(ID_rfClose)

    return OK;
}




/****************************************************************************\
*
* Function:     int rfGetSize(rfHandle file, long *fileSize);
*
* Description:  Get the size of a file
*
* Input:        rfHandle file           handle of an open file
*               ulong *fileSize         pointer to file size
*
* Returns:      MIDAS error code.
*               File size is stored in *fileSize.
*
\****************************************************************************/

int CALLING rfGetSize(rfHandle file, long *fileSize)
{
    int         error;
    static long fpos;

    /* store current file position: */
    if ( (error = rfGetPosition(file, &fpos)) != OK )
        PASSERROR(ID_rfGetSize)

    /* seek to end of file: */
    if ( (error = rfSeek(file, 0, rfSeekEnd)) != OK )
        PASSERROR(ID_rfGetSize)

    /* read file position to *filesize: */
    if ( (error = rfGetPosition(file, fileSize)) != OK )
        PASSERROR(ID_rfGetSize)

    /* return original file position: */
    if ( (error = rfSeek(file, fpos, rfSeekAbsolute)) != OK )
        PASSERROR(ID_rfGetSize)

    return OK;
}




/****************************************************************************\
*
* Function:     int rfRead(rfHandle file, void *buffer, ulong numBytes);
*
* Description:  Reads binary data from a file
*
* Input:        rfHandle file           file handle
*               void *buffer            reading buffer
*               ulong numBytes          number of bytes to read
*
* Returns:      MIDAS error code.
*               Read data is stored in *buffer, which must be large enough
*               for it.
*
\****************************************************************************/

int CALLING rfRead(rfHandle file, void *buffer, ulong numBytes)
{
    FILE        *f = file->f;
    int         error;
    unsigned    readOK;

#ifdef __16__
    ulong       readCount = numBytes;
    uchar huge  *rbuf;

    /* 16-bit mode - data must be read at chunks of 49152 bytes */
    rbuf = (uchar huge*) buffer;

    while ( readCount > 0 )
    {
        if ( readCount > 49152 )
        {
            /* More than 49152 bytes left to read - read 49152 bytes and
               advance buffer pointer */
            if ( (readOK = fread(rbuf, 49152, 1, f)) != 1 )
                break;
            readCount -= 49152;
            rbuf += 49152;
        }
        else
        {
            /* 49152 or less bytes remaining - read them to *rbuf */
            if ( (readOK = fread(rbuf, readCount, 1, f)) != 1 )
                break;
            readCount = 0;
        }
    }

#else
    /* 32-bit mode - all data can be read with one call to fread */
    readOK = fread(buffer, numBytes, 1, f);
#endif

    if ( readOK != 1 )
    {
        /* Error occurred when reading file. Check if there is an error, and
           if is, return an error code corresponding to errno: */
        if ( ferror(f) )
        {
            error = ErrorCode();
            ERROR(error, ID_rfRead);
            return error;
        }

        /* no error - check if end of file: */
        if ( feof(f) )
        {
            ERROR(errEndOfFile, ID_rfRead);
            return errEndOfFile;
        }

        /* no error or end of file - return "Unable to read file" */
        ERROR(errFileRead, ID_rfRead);
        return errFileRead;
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int rfWrite(rfHandle file, void *buffer, ulong numBytes);
*
* Description:  Writes binary data to a file
*
* Input:        rfHandle file           file handle
*               void *buffer            pointer to data to be written
*               ulong numBytes          number of bytes to write
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING rfWrite(rfHandle file, void *buffer, ulong numBytes)
{
    FILE        *f = file->f;
    int         error;
    unsigned    writeOK;

#ifdef __16__
    ulong       writeCount = numBytes;
    uchar huge  *wbuf;
    /* 16-bit mode - data must be written in chunks of 49152 bytes */
    wbuf = (uchar huge*) buffer;

    while ( writeCount > 0 )
    {
        if ( writeCount > 49152 )
        {
            /* More than 49152 bytes left to write - write 49152 bytes and
               advance buffer pointer */
            if ( (writeOK = fwrite(wbuf, 49152, 1, f)) != 1 )
                break;
            writeCount -= 49152;
            wbuf += 49152;
        }
        else
        {
            /* 49152 or less bytes remaining - write all */
            if ( (writeOK = fwrite(wbuf, writeCount, 1, f)) != 1 )
                break;
            writeCount = 0;
        }
    }

#else
    /* 32-bit mode - all data can be written with one call to fwrite */
    writeOK = fwrite(buffer, numBytes, 1, f);
#endif
    if ( writeOK != 1 )
    {
        /* Error occurred when writing file. Check if there is an error, and
           if is, return an error code corresponding to errno: */
        if ( ferror(f) )
        {
            error = ErrorCode();
            ERROR(error, ID_rfWrite);
            return error;
        }

        /* no error - return "Unable to write file" */
        ERROR(errFileWrite, ID_rfWrite);
        return errFileWrite;
    }

    return OK;
}








/****************************************************************************\
*
* Function:     int rfSeek(rfHandle file, long newPosition, int seekMode);
*
* Description:  Seeks to a new position in file. Subsequent reads and writes
*               go to the new position.
*
* Input:        rfHandle file           file handle
*               long newPosition        new file position
*               int seekMode            file seek mode, see enum rfSeekMode
*
* Returns:      MIDAS error code
*
\****************************************************************************/

int CALLING rfSeek(rfHandle file, long newPosition, int seekMode)
{
    FILE        *f = file->f;
    int         error;
    int         fseekMode;

    /* select seek mode for fseek() corresponding to seekMode: */
    switch ( seekMode )
    {
        case rfSeekAbsolute:            /* seek to an absolute offset */
            fseekMode = SEEK_SET;
            break;

        case rfSeekRelative:            /* seek relative to current */
            fseekMode = SEEK_CUR;       /* position */
            break;

        case rfSeekEnd:
            fseekMode = SEEK_END;       /* seek from end of file */
            break;

        default:
            /* invalid seek mode: */
            ERROR(errInvalidArguments, ID_rfSeek);
            return errInvalidArguments;
    }

    /* seek to new position: */
    if ( fseek(f, newPosition, fseekMode) != 0 )
    {
        /* Error during seeking.  Check if there is an error, and if is,
           return an error code corresponding to errno: */
        if ( ferror(f) )
        {
            error = ErrorCode();
            ERROR(error, ID_rfSeek);
            return error;
        }

        /* no error - return "Unable to read file" */
        ERROR(errFileRead, ID_rfSeek);
        return errFileRead;
    }

    return OK;
}




/****************************************************************************\
*
* Function:     int rfGetPosition(rfHandle file, long *position);
*
* Description:  Reads the current position in a file
*
* Input:        rfHandle file           file handle
*               long *position          pointer to file position
*
* Returns:      MIDAS error code.
*               Current file position is stored in *position.
*
\****************************************************************************/

int CALLING rfGetPosition(rfHandle file, long *position)
{
    FILE        *f = file->f;
    int         error;
    long        fpos;

    /* get current position to fpos: */
    if ( (fpos = ftell(f)) == -1L )
    {
        /* Error - if errno is nonzero, return error code corresponding
           to it. Otherwise return undefined error. */
        if ( errno )
        {
            error = ErrorCode();
            ERROR(error, ID_rfGetPosition);
            return error;
        }
        else
        {
            ERROR(errUndefined, ID_rfGetPosition);
            return errUndefined;
        }
    }

    *position = fpos;                   /* store position in *position */

    return OK;
}




/****************************************************************************\
*
* Function:     int rfFileExists(char *fileName, int *exists);
*
* Description:  Checks if a file exists or not
*
* Input:        char *fileName          file name, ASCIIZ
*               int *exists             pointer to file exists status
*
* Returns:      MIDAS error code.
*               *exists contains 1 if file exists, 0 if not.
*
\****************************************************************************/

int CALLING rfFileExists(char *fileName, int *exists)
{
    FILE        *f;

    /* Attempt to open file using fopen(). If it succeeds, the file exists. */
    if ( (f = fopen(fileName, "rb")) != NULL )
    {
        *exists = 1;
        fclose(f);
    }
    else
        *exists = 0;

    return OK;
}


/*
 * $Log: rawfile.c,v $
 * Revision 1.2  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.1  1996/05/22 20:49:33  pekangas
 * Initial revision
 *
*/