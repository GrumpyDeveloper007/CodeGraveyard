/*      Registry.h
 *
 * Registry handling class
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#ifndef __Registry_h
#define __Registry_h


class Registry
{
    HKEY        key;
public:
    Registry();
    ~Registry();
    int KeyExists(const char *name);
    void CreateKey(const char *name);
    void OpenKey(const char *name);
    void Value(const char *name, void *data, DWORD *dataLength,
        DWORD bufferLength, DWORD *dataType);
    void ValueString(const char *name, const char *defaultData, char *dest,
        int bufferLength);
    void WriteString(const char *name, const char *string);
    DWORD ValueDWORD(const char *name, DWORD defaultData);
    void WriteDWORD(const char *name, const DWORD data);
    int ValueExists(const char *name);
};


#endif