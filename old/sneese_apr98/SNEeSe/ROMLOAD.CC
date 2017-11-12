/*  ROM IMAGE LOADING MECHANISM - Code By Savoury SnaX & Santeri Saarimaa

        Supports now SMC/SWC/SFC and MGD2/BIN formats!

        SMC = Super Magicom
        SWC = SuperWildCard
        SFC = Super Famicom

        MGD2 = Multi Game Hunter 2
        BIN  = Binary (it's the same as MGD2)

        In fact I ignore the SMC/SWC/SFC header size info (some dodgy roms etc).

    TODO:

        Multiple rom loading?
        Convert this to C, so SNEeSe wouldn't be so dependent of C++
*/

#include <fstream.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "romload.h"

#ifndef TRUE
#define TRUE         -1
#define FALSE        0
#endif

char *rom_romfile;
char *rom_romhilo;
char *rom_romname;
char *rom_romtype;
char *rom_romsize;
char *rom_sram;
char *rom_country;

unsigned char *RealRomAddress;	
unsigned char *RomAddress;		// Global Offset To SNES Rom Code
unsigned char *RealRamAddress;
unsigned char *RamAddress;
unsigned char *SaveRamAddress;		// Macro, points to sram location within ram address
unsigned char *WorkRamAddress;		// Macro, points to work ram location
unsigned char *RealVRamAddress;
unsigned char *VRamAddress;		// Global Offset To Video Ram
unsigned char *RealOAMAddress;		// Address of OAM Data
unsigned char *OAMAddress;
unsigned char *RealSPCAddress;		// Address of SPC Data
unsigned char *SPCAddress;

unsigned int SaveRamLength;		// Used to determine size of file for saving/loading

int DoRom(char *FileName, int romcode, int lorom);
int Allocate_Rom(unsigned short NumBanks);

SNESRomInfoStruct RomInfoLo,RomInfoHi;

extern "C" unsigned char SNES_COUNTRY;

extern "C"
{
        unsigned long INT_BANK,RESET_VECTOR;
        unsigned long NMITrip,IRQTrip;
}

int LoadROM(char *FileName)
{
        fstream InFile;
        SWCHeader Header;      // For checking if the rom is SMC/SWC/SFC
        int cnt;
        int romcode;           // This is where the rom code itself starts.
 
        rom_romfile=(char *)malloc(100);
        rom_romhilo=(char *)malloc(100);
        rom_romtype=(char *)malloc(50);
        rom_romsize=(char *)malloc(50);
        rom_romname=(char *)malloc(50);
        rom_sram=(char *)malloc(50);
        rom_country=(char *)malloc(50);

        strcpy(rom_romfile,"File name: ");
        strcat(rom_romfile,FileName);

        rom_romfile[33]=0;

        InFile.open(FileName,ios::in|ios::binary);

        if (!InFile)
                return FALSE;          // File aint there m8

        InFile.seekg(0,ios::beg);
        InFile.read((unsigned char *)&Header,sizeof(SWCHeader));

/* Gridle 04/03/1998 (dmy)

Rom header in SMC files at 0x100 - 0x1FF usually is zero. I couldn't find
any other reliable way to check if the rom is really SMC or BIN.

Originally I checked everything from 0x10 - 0x1FF, but one of my roms
(Brainies) had some stupid pirate group stuff just before 0x100, so I
changed this to search from 0x100 - 0x1FF.

This is now changed to 0x100 - 0x1FD because of the pushover rom.
*/

        romcode=512;

        for (cnt=261;cnt<499;cnt++)
                if(Header.RestOfHeader[cnt]!=0)
                {
                        romcode=0;
                        break;
                }

        if(romcode==512)
                printf("SMC/SWC/SFC format ROM detected.");
        else
                printf("MGD2/BIN format ROM detected.");

        InFile.seekg(0x7FC0+romcode,ios::beg);
        InFile.read((unsigned char *)&RomInfoLo,sizeof(SNESRomInfoStruct));
        InFile.seekg(0xFFC0+romcode,ios::beg);
        InFile.read((unsigned char *)&RomInfoHi,sizeof(SNESRomInfoStruct));
        InFile.close();

        unsigned short Temp;

        Temp=RomInfoLo.Checksum+RomInfoLo.Complement;
        if (Temp==0xFFFF)              // Lo Rom Found
        {
                strcpy(rom_romhilo,"Rom Hi/Lo: LoRom");
                return DoRom(FileName,romcode,TRUE);
        }

        Temp=RomInfoHi.Checksum+RomInfoHi.Complement;
        if (Temp==0xFFFF)
        {
                strcpy(rom_romhilo,"Rom Hi/Lo: HiRom");
                return DoRom(FileName,romcode,FALSE);
        }

        strcpy(rom_romhilo,"Rom Hi/Lo: Can't detect, using LoRom");
        return DoRom(FileName,romcode,TRUE);
}

void DisplayRomStats(SNESRomInfoStruct *RomInfo);

int DoRom(char *FileName, int romcode, int lorom)
{
        int cnt;
        int NumBanks;

        fstream InFile;
 
        InFile.open(FileName,ios::in|ios::binary);

        if (!InFile)
                return FALSE;          // File aint there m8

        InFile.seekg(0,ios::end);

        NumBanks=((InFile.tellg()-romcode)/65536)+1;       // Add one for remainder

        if (NumBanks>96)			// Maximum 48Mbit rom size... simple
                NumBanks=96;

	if (Allocate_Rom(NumBanks)!=0)		// Dynamic allocation of rom
         return FALSE;				// return false if no memory left

        InFile.seekg(romcode,ios::beg);

        for (cnt=0;cnt<NumBanks*2;cnt++) // Read In As 32K Blocks
        {
                InFile.read(&RomAddress[cnt*32768],32768);
        }

        if (lorom==TRUE)
        {
                DisplayRomStats(&RomInfoLo);
                INT_BANK=0x00000000;           // only used now to identify if hirom or lorom remove soon
                RESET_VECTOR=0x00007FFC;
        }
        else
        {
                DisplayRomStats(&RomInfoHi);
                INT_BANK=0x00C00000;
                RESET_VECTOR=0x0000FFFC;
        }

        InFile.close();
        return TRUE;
}

char TypeTable[8][30]={"ROM",
                       "ROM / RAM",
                       "ROM / SRAM",
                       "ROM / DSP",
                       "ROM / DSP / RAM",
                       "ROM / DSP / SRAM",
                       "ROM / FX CHIP",
                       "UNKNOWN"};

char CountryTable[14][30]={"Japan",
                           "USA",
                           "Europe, Oceania, Asia",
                           "Sweden",
                           "Finland",
                           "Denmark",
                           "France",
                           "Holland",
                           "Spain",
                           "Germany, Austria, Switz.",
                           "Italy",
                           "Hong Kong, China",
                           "Indonesia",
                           "Korea"};

void DisplayRomStats(SNESRomInfoStruct *RomInfo)
{
        int a;
        char TempBuffer[30];

        // Rom Type

        strcpy(rom_romtype,"Rom Type : ");
        strcat(rom_romtype,TypeTable[(RomInfo->ROM_Type)&0x07]);

        // Rom Size

        strcpy(rom_romsize,"Rom Size : ");
        strcat(rom_romsize,itoa(1 << ((RomInfo->ROM_Size)-7),TempBuffer,10));
        strcat(rom_romsize,"MBits");

        // Rom SRam size

        if (((RomInfo->ROM_Type)&0x07)==2 || ((RomInfo->ROM_Type)&0x07)==5)
        {
                SaveRamLength=(1 << ((RomInfo->SRAM_Size)+3));
                strcpy(rom_sram,"SRam Size: ");
                strcat(rom_sram,itoa(SaveRamLength,TempBuffer,10));
                strcat(rom_sram,"KBits");
        }
        else
        {
                SaveRamLength=0;
                strcpy(rom_sram,"SRam Size: No SRam");
        }

        // Rom Country

        if (RomInfo->Country_Code<2)
        {
                strcpy(rom_country,"Country  : ");
                strcat(rom_country,CountryTable[RomInfo->Country_Code]);
                strcat(rom_country," (NTSC)");
                SNES_COUNTRY=0x00;

                NMITrip=47000*4;
                IRQTrip=174*4;

        }
        else if (RomInfo->Country_Code<14)
        {
                strcpy(rom_country,"Country  : ");
                strcat(rom_country,CountryTable[RomInfo->Country_Code]);
                strcat(rom_country," (PAL)");
                SNES_COUNTRY=0x10;

                NMITrip=56300*4;
                IRQTrip=209*4;
        }
        else
        {
                strcpy(rom_country,"Country  : Unknown (Using PAL)");
                SNES_COUNTRY=0x10;

                NMITrip=56300*4;
                IRQTrip=209*4;
        }

        // Rom Name

        for (a=0;a<21;a++)
                TempBuffer[a]=RomInfo->ROM_Title[a];

        TempBuffer[21]='\000';

        strcpy(rom_romname,"Rom Title: ");
        strcat(rom_romname,TempBuffer);

        // Print information

        printf("\n\n%s\n",rom_romname);
        printf("%s\n",rom_romtype);
        if (((RomInfo->ROM_Type)&0x07)>2)
                printf("This ROM contains additional hardware not yet supported!\n");
        printf("%s\n",rom_romhilo);
        printf("%s\n",rom_romsize);
        printf("%s\n",rom_sram);
        printf("%s",rom_country);

        // Ugly things, but helps with 256x256 in rom information window
        rom_romhilo[33]=0;
        rom_country[33]=0;
}
