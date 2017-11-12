/*
 *      Archivers.h
 *
 * MIDAS Module Player for Windows NT archiver support
 *
 * Copyright 1997 Petteri Kangaslampi
*/

#ifndef __archivers_h
#define __archivers_h



typedef struct
{
    char        *extension;
    char        *decompress;
} Archive;


extern int      numArchives;
extern Archive  archives[];




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

int IsArchive(char *fileName);




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

MIDASmodule LoadArchive(char *fileName);



#endif