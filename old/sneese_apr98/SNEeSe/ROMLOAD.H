/*
        ROMIMAGE HEADER FILE
*/

struct SWCHeader
{
        unsigned short NumPages;
        unsigned char ImageInformation;
        char Reserved_1[5];
        unsigned char SWC_Ident1;
        unsigned char SWC_Ident2;
        unsigned char SWC_Ident3;
        char RestOfHeader[501];
};

struct SNESRomInfoStruct
{
        char ROM_Title[21];           //FFC0
        unsigned char ROM_MakeUp;     //FFD6
        unsigned char ROM_Type;       //FFD7
        unsigned char ROM_Size;       //FFD8
        unsigned char SRAM_Size;      //FFD9
        unsigned char Country_Code;   //FFDA
        unsigned char License;        //FFDB
        unsigned char ROM_Version;    //FFDC
        unsigned short int Complement;//FFDD
        unsigned short int Checksum;  //FFDF
};

int LoadROM(char *);

extern unsigned char *RomAddress;        // Global Offset To SNES Blocks 0-3F
extern unsigned char *VRamAddress;       // Global Offset To Video Ram
extern unsigned short InitNMI,InitReset; // Initial CPU Starts from ROM
