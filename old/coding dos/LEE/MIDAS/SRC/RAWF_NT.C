/*      rawf_nt.c
 *
 * Win32 raw file I/O for MIDAS Sound System
 *
 * $Id: rawf_nt.c,v 1.3 1997/01/16 18:41:59 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc.
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*/

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include "lang.h"
#include "mtypes.h"
#include "errors.h"
#include "mmem.h"
#include "rawfile.h"

RCSID(const char *rawf_nt_rcsid = "$Id: rawf_nt.c,v 1.3 1997/01/16 18:41:59 pekangas Exp $";)


/****************************************************************************\
*
* Function:     int ErrorCode(void)
*
* Description:  Get the MIDAS error code corresponding to GetLastError()
*
* Returns:      MIDAS error code
*
\****************************************************************************/

static int ErrorCode(void)
{
    #define MAPERR(win32, midas) case win32: return midas;

    switch ( GetLastError() )
    {
            MAPERR( NO_ERROR,               OK )
            MAPERR( ERROR_ACCESS_DENIED,    errAccessDenied )
            MAPERR( ERROR_ALREADY_EXISTS,   errFileExists )
            MAPERR( ERROR_BAD_NET_NAME,     errInvalidPath )
            MAPERR( ERROR_BAD_NETPATH,      errInvalidPath )
            MAPERR( ERROR_CANNOT_MAKE,      errFileWrite )
            MAPERR( ERROR_DEV_NOT_EXIST,    errInvalidPath )
            MAPERR( ERROR_DIRECTORY,        errInvalidPath )
            MAPERR( ERROR_DISK_FULL,        errDiskFull )
            MAPERR( ERROR_FILE_EXISTS,      errFileExists )
            MAPERR( ERROR_FILE_NOT_FOUND,   errFileNotFound )
            MAPERR( ERROR_HANDLE_DISK_FULL, errDiskFull )
            MAPERR( ERROR_INVALID_COMPUTERNAME, errInvalidPath )
            MAPERR( ERROR_INVALID_DRIVE,    errInvalidPath )
            MAPERR( ERROR_INVALID_HANDLE,   errInvalidFileHandle )
            MAPERR( ERROR_INVALID_NAME,     errInvalidPath )
            MAPERR( ERROR_INVALID_SHARENAME, errInvalidPath )
            MAPERR( ERROR_NOT_ENOUGH_MEMORY, errOutOfMemory )
            MAPERR( ERROR_OPEN_FAILED,      errFileOpen )
            MAPERR( ERROR_OUTOFMEMORY,      errOutOfMemory )
            MAPERR( ERROR_READ_FAULT,       errFileRead )
            MAPERR( ERROR_SEEK,             errFileRead )
            MAPERR( ERROR_TOO_MANY_OPEN_FILES, errTooManyFiles )
            MAPERR( ERROR_WRITE_FAULT,      errFileWrite )
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
    HANDLE      handle;

    /* allocate file structure */
    if ( (error = memAlloc(sizeof(rfFile), (void**) &hdl)) != OK )
        PASSERROR(ID_rfOpen)

    switch ( openMode )
    {
        case rfOpenRead:        /* open file for reading */
            handle = CreateFile(fileName, GENERIC_READ, FILE_SHARE_READ,
                NULL, OPEN_EXISTING, 0, NULL);
            break;

        case rfOpenWrite:       /* open file for writing */
            handle = CreateFile(fileName, GENERIC_WRITE, 0,
                NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
            break;

        case rfOpenReadWrite:   /* open file for reading and writing */
            handle = CreateFile(fileName, GENERIC_READ | GENERIC_WRITE, 0,
                NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
            break;
    }

    /* If an error occurred during opening file, return the error code
       specified by GetLastError(): */
    if ( handle == INVALID_HANDLE_VALUE )
    {
        error = ErrorCode();

        if ( error == OK )
            error = errFileNotFound;

        ERROR(error, ID_rfOpen);
        return error;
    }

    /* Store handle: */
    hdl->f = (U32) handle;

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
    HANDLE      handle = (HANDLE) file->f;

    /* close file: */
    if ( !CloseHandle(handle) )
    {
        /* error occurred - return error code from GetLastError: */
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
    int         error;
    HANDLE      handle = (HANDLE) file->f;
    DWORD       numRead;

    if ( !ReadFile(handle, buffer, numBytes, &numRead, NULL) )
    {
        /* Return error code from GetLastError: */
        error = ErrorCode();
        ERROR(error, ID_rfRead);
        return error;
    }

    /* Check that we did read all data: */
    if ( numRead != numBytes )
    {
        ERROR(errEndOfFile, ID_rfRead);
        return errEndOfFile;
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
    int         error;
    HANDLE      handle = (HANDLE) file->f;
    DWORD       numWritten;

    if ( !WriteFile(handle, buffer, numBytes, &numWritten, NULL) )
    {
        /* Return error code from GetLastError: */
        error = ErrorCode();
        ERROR(error, ID_rfWrite);
        return error;
    }

    /* Check that we did write all data: */
    if ( numWritten != numBytes )
    {
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
    HANDLE      handle = (HANDLE) file->f;
    int         error;
    DWORD       moveMethod;
    LONG        moveDist = newPosition;

    /* Select pointer move starting point: */
    switch ( seekMode )
    {
        case rfSeekAbsolute:            /* seek to an absolute offset */
            moveMethod = FILE_BEGIN;
            break;

        case rfSeekRelative:            /* seek relative to current */
            moveMethod = FILE_CURRENT;
            break;

        case rfSeekEnd:                 /* seek from end of file */
            moveMethod = FILE_END;
            break;

        default:
            /* invalid seek mode: */
            ERROR(errInvalidArguments, ID_rfSeek);
            return errInvalidArguments;
    }

    /* Seek to new position: */
    if ( SetFilePointer(handle, moveDist, NULL, moveMethod) == 0xFFFFFFFF )
    {
        /* Unable to seek - check the error from GetLastError(): */
        error = ErrorCode();
        ERROR(error, ID_rfSeek);
        return error;
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
    HANDLE      handle = (HANDLE) file->f;
    int         error;
    DWORD       pos;

    /* Get position by using SetFilePointer(): */
    if ( (pos = SetFilePointer(handle, 0, NULL, FILE_CURRENT)) == 0xFFFFFFFF )
    {
        /* Error - check GetLastError(): */
        error = ErrorCode();
        ERROR(error, ID_rfGetPosition);
        return error;
    }

    *position = pos;                    /* store position in *position */

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
    HANDLE      handle;

    /* Attempt to open the file: */
    handle = CreateFile(fileName, GENERIC_READ, FILE_SHARE_READ, NULL,
        OPEN_EXISTING, 0, NULL);

    if ( handle == INVALID_HANDLE_VALUE )
    {
        /* Couldn't be opened: return 0: */
        *exists = 0;
        return OK;
    }

    /* Close the file: */
    CloseHandle(handle);

    return OK;
}


/*
 * $Log: rawf_nt.c,v $
 * Revision 1.3  1997/01/16 18:41:59  pekangas
 * Changed copyright messages to Housemarque
 *
 * Revision 1.2  1996/09/22 23:16:33  pekangas
 * Fixed to always return an error from rfOpenFile if CreateFile fails
 *
 * Revision 1.1  1996/08/13 20:49:10  pekangas
 * Initial revision
 *
*/