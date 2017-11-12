#include <stdio.h>
#define WIN32_LEAN_AND_MEAN
#include <windows.h>


int main(void)
{
    HKEY        key;
    LONG        err;
    DWORD       createStatus;
    char        name[MAX_PATH];
    DWORD       nameLen = MAX_PATH;
    DWORD       valType;

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

    return 0;
}