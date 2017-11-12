/*

  ROM IMAGE LOADING MECHANISM - Code By Savoury SnaX

  Only LoRam Carts Are Supported
  Currently supports only SWC format (also known as SFC & SMC?)
    In fact I ignore the header size info (some dodgy roms etc)                       

*/

#include <fstream.h>

#include "mem.h"

#include "Romload.h"

// Rom Images are stored in blocks of 64K, however the rom address
//space of the SNES (at least in LoRam mode) allows only 32K per
//block. The copiers must therefor shift load it in 32K blocks, I
//will do the same which will result in about 28K of wasted memory
//per block. A block (0-0x3F) looks like :
//
//   0x0000-0x1FFF  -	Scratch Ram
//   0x2000-0x5FFF  -   Hardware Ports
//   0x6000-0x7FFF  -   Unknown (marked as expansion)
//   0x8000-0xFFFF  -   ROM Address space
//
// However the wasted memory will allow me to use a union to map
//SNES pages directly into PCAddress space (although I will need to
//add the offset to the physical ram until I can work out how to do
//virtual address space stuff.

unsigned char *RealRomAddress;	
unsigned char *RomAddress;		// Global Offset To SNES Blocks 0-7F
unsigned char *VRamAddress;		// Global Offset To Video Ram
unsigned short InitNMI,InitReset;	// Initial CPU Starts from ROM

int LoadROM(char *FileName)
 {
 // Returns pointer to allocated SNES RAM

 SWCHeader Header;
 SNESRomInfoStruct *RomInfo;

 int NumBanks;

 fstream InFile;
 
 InFile.open(FileName,ios::in|ios::binary);

 if (!InFile)
  return 1==0;		// File aint there m8

 InFile.read((unsigned char *)&Header,sizeof(SWCHeader));
 
 InFile.seekg(0,ios::end);

 NumBanks=((InFile.tellg()-512)/65536)+1;	// Add one for remainder

 if (NumBanks>(0x3f/2))
  return 1==0;				// Does Not Fit Into Address Space

 InFile.seekg(512,ios::beg);

 RealRomAddress=new unsigned char [0x81*0x10000];       // Lots of mem ;-( (64K alignment needed)
 if (RealRomAddress==NULL)
  return 1==0;
 
 RomAddress=(unsigned char *)(((unsigned long)(RealRomAddress+0x10000))&0xFFFF0000); //Aligned 64k

 VRamAddress=new unsigned char [65540];
 if (VRamAddress==NULL)
  {
  delete RomAddress;
  return 1==0;
  }

 for (int a=0;a<65540;a++)
  VRamAddress[a]=0;
 for (a=0;a<0x80*0x10000;a++)
  RomAddress[a]=0;

 for (a=0;a<NumBanks*2;a++)         // Read In As 32K Blocks
  {
  InFile.read(&RomAddress[a*0x10000+32768],32768);
  }

 RomInfo=(SNESRomInfoStruct *)&RomAddress[0xFFC0];

 RomInfo->dummy=0;

 cout << "\nRom Title = " << RomInfo->ROM_Title;
 cout.flush();

 InitNMI=GetSNESWord(&RomAddress[0xFFFA]);
 InitReset=GetSNESWord(&RomAddress[0xFFFC]);
 if (InitReset<0x8000)
  InitReset=0x8000;     // Rom Corrupt but this may be a safe bet

 InFile.close();

 return 1==1;
 }
