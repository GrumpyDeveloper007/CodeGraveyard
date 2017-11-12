/*
 *      Archivers.cpp
 *
 * MIDAS Module Player for Windows NT archiver support
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <dos.h>

#include "midasdll.h"

#ifdef __VC32__
#include <io.h>
#endif

#include "MidpNT.h"
#include "archivers.h"



int             numArchives = 4;
Archive         archives[4] =
    {
        { ".mdz", "unzip -o \"%s\" -d %s" },
        { ".s3z", "unzip -o \"%s\" -d %s" },
        { ".xmz", "unzip -o \"%s\" -d %s" },
        { ".zip", "unzip -o \"%s\" -d %s" }
    };




/****************************************************************************\
*
* Function:     int IsArchive(char *fileName);
*
* Description:  Checks if a file is an archive (based on the extension)
*
* Input:        char *fileName          file name
*
* Returns:      1 if the file is an archive, 0 if not
*
\****************************************************************************/

int IsArchive(char *fileName)
{
    int         i;
    char        ext[_MAX_EXT];

    _splitpath(fileName, NULL, NULL, NULL, ext);

    for ( i = 0; i < numArchives; i++ )
    {
        if ( !stricmp(ext, archives[i].extension) )
            return 1;
    }

    return 0;
}




/****************************************************************************\
*
* Function:     MIDASmodule LoadArchive(char *fileName);
*
* Description:  Loads a module from an archive
*
* Input:        char *fileName          file name
*
* Returns:      MIDAS module handle for the module or NULL if failed
*
\****************************************************************************/

MIDASmodule LoadArchive(char *fileName)
{
    int         i;
    char        ext[_MAX_EXT];
    char        file[_MAX_FNAME];
    char        *decompress;
    char        commandLine[_MAX_PATH + 128];
    STARTUPINFO startInfo;
    PROCESS_INFORMATION procInfo;
    DWORD       exitCode;
    WIN32_FIND_DATA findData;
    HANDLE      findHandle;
    DWORD       creationFlags;
    SECURITY_ATTRIBUTES secAttr = { sizeof(SECURITY_ATTRIBUTES), NULL, FALSE};
    int         fileFound;
    MIDASmodule module;

    AddTextLine("Decompressing module");
    SendMessage(mainWinHandle, WM_SETTEXT, 0,
        (LPARAM) "MidpNT - Decompressing...");

    GetCurrentDirectory(MAX_PATH+127, commandLine);
    if ( SetCurrentDirectory(unzipDir) )
    {
        SetCurrentDirectory(commandLine);
        sprintf(commandLine, "Directory \"%s\" already exists", unzipDir);
        MessageBox(NULL, commandLine, "Decompression error",
            MB_ICONERROR | MB_OK);
        return NULL;
    }

    _splitpath(fileName, NULL, NULL, file, ext);

    decompress = NULL;
    for ( i = 0; i < numArchives; i++ )
    {
        if ( !stricmp(ext, archives[i].extension) )
            decompress = archives[i].decompress;
    }

    if ( decompress == NULL )
        Panic("Decompress: Unknown extension!");

    sprintf(commandLine, decompress, fileName, unzipDir);
    AddTextLine(commandLine);

    startInfo.cb = sizeof(STARTUPINFO);
    startInfo.lpReserved = NULL;
    startInfo.lpDesktop = NULL;
    startInfo.lpTitle = commandLine;
    startInfo.dwFlags = STARTF_USESHOWWINDOW;
    startInfo.wShowWindow = SW_HIDE;
    startInfo.cbReserved2 = 0;
    startInfo.lpReserved2 = NULL;

    creationFlags = CREATE_NEW_CONSOLE | NORMAL_PRIORITY_CLASS;

    if ( !CreateProcess(NULL, commandLine, NULL, NULL, FALSE,
        creationFlags, NULL, NULL,
        &startInfo, &procInfo) )
    {
        sprintf(commandLine, "Decompress: CreateProcess failed: %i",
            GetLastError());
        Panic(commandLine);
    }

    exitCode = STILL_ACTIVE;
    while ( exitCode == STILL_ACTIVE )
    {
        Sleep(250);
        if ( !GetExitCodeProcess(procInfo.hProcess, &exitCode) )
        {
            sprintf(commandLine, "Decompress: GetExitCodeProcess failed: %i",
                GetLastError());
            Panic(commandLine);
        }
    }

    if ( exitCode != 0 )
    {
        sprintf(commandLine, "Decompressor failed: %i",
            exitCode);
        MessageBox(NULL, commandLine, "Decompression error",
            MB_OK | MB_ICONERROR);
        return NULL;
    }

    AddTextLine("Loading Module");
    SendMessage(mainWinHandle, WM_SETTEXT, 0, (LPARAM) "MidpNT - Loading...");

    sprintf(commandLine, "%s\\*.*", unzipDir, file);

    if ( (findHandle = FindFirstFile(commandLine, &findData))
          == INVALID_HANDLE_VALUE )
    {
        MessageBox(NULL, "Decompressed file not found", "Decompression error",
            MB_OK | MB_ICONERROR);
        return NULL;
    }

    fileFound = 0;

    do
    {
        if ( !(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) )
        {
            sprintf(commandLine, "%s\\%s", unzipDir, findData.cFileName);

            if ( (module = MIDASloadModule(commandLine)) != NULL )
            {
                fileFound = 1;
            }

            if ( !DeleteFile(commandLine) )
            {
                MessageBox(NULL, "Couldn't delete file",
                    "Decompression error", MB_OK | MB_ICONERROR);
                return NULL;
            }
        }
    } while ( (!fileFound) && FindNextFile(findHandle, &findData) );

    FindClose(findHandle);

    RemoveDirectory(unzipDir);

    if ( fileFound )
        return module;

    MessageBox(NULL, "No valid module files found", "Decompression error",
        MB_OK | MB_ICONERROR);
    return NULL;
}