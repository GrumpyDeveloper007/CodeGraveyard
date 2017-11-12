/*      Registry.cpp
 *
 * Registry handling class
 *
 * $Id: Registry.cpp 1.3 1997/01/14 17:42:08 pekangas Exp $
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "midasdll.h"
#include "MidpNT.h"
#include "registry.h"


static void Error(char *msg)
{
    Panic(msg);
}


Registry::Registry()
{
}


Registry::~Registry()
{
}


int Registry::KeyExists(const char *name)
{
    LONG        err;

    err = RegOpenKeyEx(HKEY_CURRENT_USER, name, 0, KEY_ALL_ACCESS, &key);
    if ( err != ERROR_SUCCESS )
        return 0;
    return 1;
}


void Registry::CreateKey(const char *name)
{
    LONG        err;
    DWORD       createStatus;

    err = RegCreateKeyEx(HKEY_CURRENT_USER, name, 0, NULL,
        REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &key, &createStatus);
    if ( err != ERROR_SUCCESS )
        Error("Registry key creation failed");
}



void Registry::OpenKey(const char *name)
{
    LONG        err;

    err = RegOpenKeyEx(HKEY_CURRENT_USER, name, 0, KEY_ALL_ACCESS, &key);
    if ( err != ERROR_SUCCESS )
        Error("Registry key opening failed");
}


void Registry::Value(const char *name, void *data, DWORD *dataLength, DWORD
    bufferLength, DWORD *dataType)
{
    LONG        err;
    DWORD       len;
    DWORD       type;

    len = bufferLength;
    err = RegQueryValueEx(key, (LPSTR) name, 0, &type, (LPBYTE) data,
        &len);
    if ( err != ERROR_SUCCESS )
    {
        len = *dataLength;
        type = *dataType;
        err = RegSetValueEx(key, (LPSTR) name, 0, type,
            (CONST BYTE*) data, len);
        if ( err != ERROR_SUCCESS )
            Error("Registry value creation failed");
    }

    *dataLength = len;
    *dataType = type;
}


void Registry::ValueString(const char *name, const char *defaultData,
    char *dest, int bufferLength)
{
    DWORD       len;
    DWORD       type = REG_SZ;

    if ( (unsigned) bufferLength < (strlen(defaultData) + 1) )
        Error("Registry::ValueString() - too long default");

    strcpy(dest, defaultData);
    len = strlen(dest) + 1;

    Value(name, (void*) dest, &len, bufferLength, &type);

    if ( type != REG_SZ )
        Error("Registry::ValueString() - illegal value type");
}



void Registry::WriteString(const char *name, const char *string)
{
    DWORD       err;

    err = RegSetValueEx(key, (LPSTR) name, 0, REG_SZ, (CONST BYTE*) string,
        strlen(string)+1);
    if ( err != ERROR_SUCCESS )
        Error("Registry::WriteString(): value creation failed");
}



DWORD Registry::ValueDWORD(const char *name, DWORD defaultData)
{
    DWORD       len, type, buf;

    buf = defaultData;
    len = sizeof(DWORD);
    type = REG_DWORD;

    Value(name, (void*) &buf, &len, sizeof(DWORD), &type);

    if ( type != REG_DWORD )
        Error("Registy::ValueDWORD() - illegal value type");

    return buf;
}



void Registry::WriteDWORD(const char *name, const DWORD data)
{
    DWORD       err;
    DWORD       buf = data;

    err = RegSetValueEx(key, (LPSTR) name, 0, REG_DWORD, (CONST BYTE*) &buf,
        sizeof(DWORD));
    if ( err != ERROR_SUCCESS )
        Error("Registry::WriteDWORD(): value creation failed");
}



int Registry::ValueExists(const char *name)
{
    LONG        err;

    err = RegQueryValueEx(key, (LPSTR) name, 0, NULL, NULL, 0);
    if ( err != ERROR_SUCCESS )
        return 0;
    return 1;
}


/*
 * $Log: Registry.cpp $
 * Revision 1.3  1997/01/14 17:42:08  pekangas
 * Changed to use MIDAS DLL API
 *
 * Revision 1.2  1996/07/16 19:37:31  pekangas
 * Fixed to compile with Visual C, converted to LFs and added RCS keywords
 *
*/