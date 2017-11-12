#include <stdio.h>
#define WIN32_LEAN_AND_MEAN
#include <windows.h>


void Error(char *msg)
{
    printf("Error: %s\n", msg);
}


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
};


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

    if ( bufferLength < (strlen(defaultData) + 1) )
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




int main(void)
{
    char        name[MAX_PATH];
    DWORD       nameLen = MAX_PATH;
    DWORD       valType;
    Registry    reg;

    if ( !reg.KeyExists("Software\\Sahara Surfers\\MidpNT") )
        reg.CreateKey("Software\\Sahara Surfers\\MidpNT");
    else
        reg.OpenKey("Software\\Sahara Surfers\\MidpNT");

    strcpy(name, "c:\\haa\\huujamaaa");
    nameLen = strlen(name)+1;
    valType = REG_SZ;
    reg.Value("DefaultDirectory", name, &nameLen, MAX_PATH, &valType);
    printf("Data: \"%s\", len %lu, type %lu\n", name, nameLen, valType);

    reg.ValueString("TestString", "DefaultString", name, MAX_PATH);
    printf("Got string: \"%s\"\n", name);

    printf("Got DWORD: %lu\n", reg.ValueDWORD("KalanArvo", 17));
    printf("Lahna Got DWORD: %lu\n", reg.ValueDWORD("LahnanArvo", 17));
    reg.WriteDWORD("LahnanArvo", 42);

    reg.ValueString("LahnaStr", "Lahna", name, MAX_PATH);
    printf("Lahna Got string: \"%s\"\n", name);
    reg.WriteString("LahnaStr", "Hauki");

/*
    err = RegOpenKeyEx(HKEY_CURRENT_USER,
        "Software\\Sahara Surfers\\MidpNT", 0, KEY_ALL_ACCESS, &key);
    if ( err != ERROR_SUCCESS )
    {
        printf("Couldn't open key, will create it\n");
        err = RegCreateKeyEx(HKEY_CURRENT_USER,
            "Software\\Sahara Surfers\\MidpNT", 0, NULL,
            REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &key,
                &createStatus);
        if ( err != ERROR_SUCCESS )
        {
            printf("Couldn't create key: %li\n", err);
            return 1;
        }
        if ( createStatus == REG_CREATED_NEW_KEY )
            printf("Created new key\n");
        else
            printf("Opened old key (?!?)\n");
    }
    printf("We have a key: %08X\n", (unsigned) key);

    err = RegQueryValueEx(key, "DefaultDirectory", 0, &valType,
        (LPBYTE) name, &nameLen);
    if ( err != ERROR_SUCCESS )
    {
        printf("Couldn't query value, will create it\n");
        err = RegSetValueEx(key, "DefaultDirectory", 0, REG_SZ,
            (CONST BYTE*) "q:\\kala\\dirikkkka", 18);
        if ( err != ERROR_SUCCESS )
        {
            printf("Creation failed: %li\n", err);
            return 2;
        }
    }
    else
    {
        printf("Got value: \"%s\", type %li, len %li\n", name, valType,
            nameLen);
    }
*/

    return 0;
}