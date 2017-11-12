/*

 SNEeSe - Emulation Version 0.16 beta

 This is the base file, it contains the calls to set up the emulation and a few other bits:

  GUI.CC - This file contains a simple GUI interface for altering informaton about the emulation
          etc.

  ROMLOAD.CC - This file contains the rom loading routine also decodes information such as
              memory model etc from the rom image.

  MEM.S - Not the memory allocation routines but the entire memory mapping functions set. This
         includes the functions to implement many hardware registers etc.

  SPRITE.S - This contains the code for rendering sprites

  SCREEN.S - This contains how each of the snes screen modes is decoded onto the PC Screen.

  TILES.S - This contains the code to render tile images onto a snes screen.

  ADDR.S - This contains the code for the memory addressing modes used by the snes.

  CPUx.S - This contains the code for table row x on the cpu table where x is (0-F).

  CPU.S - This contains the cpu reset code and the cpu loop code
*/

#define RELEASE_DATE "Not Yet"
#define SNEESE_VERSION "0.16 beta"

//#ifdef ELF
void StartScreen();
extern unsigned char *SNESVRAM;
extern unsigned char *SNESREGS;
extern unsigned char *SpriteRAM;
extern unsigned char *temppal;
extern unsigned short SEGREG;
extern unsigned char *VESAScreenPtr;
extern "C" unsigned char *RegDump;
//#endif

extern "C" unsigned char *Real_SNES_Palette;

#include <fstream.h>
#include <dos.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#include <allegro.h>
unsigned short lb_segment2;

#include "romload.h"

extern "C" void Do_CPU();
extern "C" void Reset_CPU();
extern "C" void Reset_SPC();
extern "C" void DisplayStatus();
extern "C" unsigned char *SNES_Screen;
extern "C" unsigned char *GUI_Screen;
extern "C" unsigned long BKG;
extern "C" unsigned char Div16Table[16*256];
extern "C" unsigned short PC_SCREEN_MODE;
extern "C" unsigned char JOYSTICK_ENABLED;
extern "C" unsigned char JOYSTICK_ENABLED2;
extern "C" unsigned char SPC_ENABLED;

extern "C" unsigned char *MappedSaveRamAddress;
extern "C" unsigned char *MappedLoRamAddress;
extern "C" unsigned char *MappedWorkRamAddress;
extern "C" unsigned long RomReadBuffer[64+32];
extern "C" unsigned long RomHiReadBuffer[64+32];
extern "C" unsigned long HRomReadBuffer[64+32];
extern "C" unsigned long HRomHiReadBuffer[64+32];
extern "C" unsigned long HRomLinReadBuffer[64+32];
extern "C" unsigned long HRomLinReadBuffer_48[64+32];
extern "C" unsigned long SRAM30Buffer[16];
extern "C" unsigned long SRAMB0Buffer[16];

extern "C" BITMAP *Allegro_Bitmap;
extern "C" BITMAP *Allegro_Bitmap_GUI;
extern "C" unsigned short ScreenX;
extern "C" unsigned short ScreenY;

extern "C" SAMPLE *test[8];
extern "C" int VoiceList[8];
extern "C" unsigned long SampleData0;
extern "C" unsigned long SampleData1;
extern "C" unsigned long SampleData2;
extern "C" unsigned long SampleData3;
extern "C" unsigned long SampleData4;
extern "C" unsigned long SampleData5;
extern "C" unsigned long SampleData6;
extern "C" unsigned long SampleData7;
extern "C" unsigned long SampleLength0;
extern "C" unsigned long SampleLength1;
extern "C" unsigned long SampleLength2;
extern "C" unsigned long SampleLength3;
extern "C" unsigned long SampleLength4;
extern "C" unsigned long SampleLength5;
extern "C" unsigned long SampleLength6;
extern "C" unsigned long SampleLength7;

extern unsigned int SaveRamLength;
extern unsigned char *RealVRamAddress;
extern unsigned char *VRamAddress;		// Global Offset To Video Ram
extern unsigned char *RealRomAddress;
extern unsigned char *RomAddress;
extern unsigned char *RealRamAddress;
extern unsigned char *RamAddress;
extern unsigned char *SaveRamAddress;
extern unsigned char *WorkRamAddress;
extern unsigned char *RealOAMAddress;
extern unsigned char *OAMAddress;
extern unsigned char *RealSPCAddress;
extern unsigned char *SPCAddress;
extern "C" unsigned long FRAME_SKIP; // Frames waited until refresh

unsigned char *RealBKG1;
unsigned char *BlankRom;

extern "C" unsigned long VRamTop;

extern "C" unsigned long SNES_KEY_A;
extern "C" unsigned long SNES_KEY_B;
extern "C" unsigned long SNES_KEY_X;
extern "C" unsigned long SNES_KEY_Y;
extern "C" unsigned long SNES_KEY_L;
extern "C" unsigned long SNES_KEY_R;
extern "C" unsigned long SNES_KEY_UP;
extern "C" unsigned long SNES_KEY_DOWN;
extern "C" unsigned long SNES_KEY_LEFT;
extern "C" unsigned long SNES_KEY_RIGHT;
extern "C" unsigned long SNES_KEY_START;
extern "C" unsigned long SNES_KEY_SELECT;

extern "C" unsigned long SNES2_KEY_A;
extern "C" unsigned long SNES2_KEY_B;
extern "C" unsigned long SNES2_KEY_X;
extern "C" unsigned long SNES2_KEY_Y;
extern "C" unsigned long SNES2_KEY_L;
extern "C" unsigned long SNES2_KEY_R;
extern "C" unsigned long SNES2_KEY_UP;
extern "C" unsigned long SNES2_KEY_DOWN;
extern "C" unsigned long SNES2_KEY_LEFT;
extern "C" unsigned long SNES2_KEY_RIGHT;
extern "C" unsigned long SNES2_KEY_START;
extern "C" unsigned long SNES2_KEY_SELECT;

void SetupTables()
 {
 for (int a=1;a<16;a++)
  {
  for (int b=0;b<256;b++)
   {					/* Not Really Div by 16 table !!! */
   int temp=((b+1))-(((256-b)/64)*(16-a));
   if (temp<0)
    temp=0;
   Div16Table[a*256+b]=temp;
   }
  }
 for (int c=0;c<256;c++)
  {
  Div16Table[c]=0;
  }
 }

int ScreenCount=0;				// Used to determine screen filename

BITMAP *sneese=NULL;
BITMAP *joypad=NULL;
PALETTE sneesepal,sneesepal2;

void OutputScreen()
 {
 char Temp[10],FileName[13]="PICCYxxx.PCX";

 itoa(ScreenCount,Temp,10);
 ScreenCount++;
 if (ScreenCount>999)
  ScreenCount=0;

 int a=strlen(Temp);
 switch (a)
  {
  case 1:
   FileName[5]='0';
   FileName[6]='0';
   FileName[7]=Temp[0];
   break;
  case 2:
   FileName[5]='0';
   FileName[6]=Temp[0];
   FileName[7]=Temp[1];
   break;
  case 3:
   FileName[5]=Temp[0];
   FileName[6]=Temp[1];
   FileName[7]=Temp[2];
   break;
  default:
   break;
  }

 get_palette(sneesepal2);
 save_pcx(FileName,Allegro_Bitmap,sneesepal2);
 }

int SetupMemory()			// Sets up all memory  was called SetupScreenMemory but that was a lie!
 {
 long a;
 unsigned char *temp;

 // Removed all Dark Elfs memory allocation since he has now left the project ;-(

// - SRAM 	=7
// - VRAM	=2
// - OAM	=2
// - Align	=1
//		=12


/* The following RAM is allocated for SRAM 5*64k blocks and 2*64k blocks work ram */
/* SRAM is in the first 5 blocks, and work ram is in the last 2 */

 RealRamAddress=(unsigned char *)malloc((12)*65536);
 if (RealRamAddress==NULL)
  return ((12)*65536)+((256+128)*(256+128)+65536)+(65536*2);

 temp=(unsigned char *)(((unsigned long)(RealRamAddress+0x10000))&0xFFFF0000);

 RamAddress=temp;
 SaveRamAddress=temp;
 MappedSaveRamAddress=temp-0x00700000;	// This saves doing a sub during mapping!
 temp=(unsigned char *)(((unsigned long)temp)+0x010000*4);

 for (a=0;a<11*65536;a++)
  RamAddress[a]=0xFF;			// 0xFF is used because it seems thats how static ram boots on SNES

 WorkRamAddress=temp;
 MappedLoRamAddress=temp;
 MappedWorkRamAddress=temp-0x007E0000;
 temp=(unsigned char *)(((unsigned long)temp)+0x010000*2);

 VRamAddress=temp;
 temp=(unsigned char *)(((unsigned long)temp)+0x010000*1);	// only 64K allocated now!!
 BlankRom=temp;				// Pointer to area full of 0xFF (used in dynamic rom)
 temp=(unsigned char *)(((unsigned long)temp)+0x010000*1);
 VRamTop=(unsigned long)temp;
 OAMAddress=temp;

/* **************************************************************************** */

/* Background allocated such that there is space for 8 tiles on either side of the screen,
 this allows the rendering to function without breaking up any of the plotters! */

 RealBKG1=new unsigned char [(256+128)*(256+128)+65536];
 if (RealBKG1==NULL)
  return ((256+128)*(256+128)+65536)+(65536*2);
 
 BKG=(((unsigned long)(RealBKG1+0x10000))&0xFFFF0000);

 for (a=0;a<(256+128)*(256+128)+65536;a++)
  RealBKG1[a]=0;			/* Ensure memory is blank before we start */

 RealSPCAddress=new unsigned char [65536*2];
 if (RealSPCAddress==NULL)
  return (65536*2);
 SPCAddress=(unsigned char *)(((unsigned long)(RealSPCAddress+0x10000))&0xFFFF0000);

 for (a=0;a<65536;a++)
  SPCAddress[a]=0xFF;

 for (a=0;a<16;a++)	// Create SRAM mappings for hirom modes only
  {
  SRAM30Buffer[a]=(unsigned long)(SaveRamAddress-(a*0x2000)-0x00306000);
  SRAMB0Buffer[a]=(unsigned long)(SaveRamAddress-(a*0x2000)-0x00B06000);
  }

 return 0;
 }

int Allocate_Rom(unsigned short NumBanks)		/* Num Banks is 64k blocks */
 {
 unsigned int a;
 /* Rom is now dynamically allocated. This is to add 48Mb without uping ram requirements */

 if (RealRomAddress!=NULL)
  free(RealRomAddress);		/* De-allocate any previous memory */

 RealRomAddress=(unsigned char *)malloc((NumBanks+1)*65536);
 if (RealRomAddress==NULL)
  return ((NumBanks+1)*65536);
 
 RomAddress=(unsigned char *)(((unsigned long)(RealRomAddress+0x10000))&0xFFFF0000); //Aligned 64k

 /* - ----- -- - - - --  MAKE ROM MAPPING TABLES HERE - - - - - --- - --- - */

 for (a=0;a<NumBanks;a++)	// Do linear mappings for the 64K blocks
  {
  HRomLinReadBuffer[a]=(unsigned long)(RomAddress-0x00C00000);	// This is just a simple linear map
  HRomLinReadBuffer_48[a]=(unsigned long)(RomAddress);
//  HRomLinReadBuffer_48[a]=(unsigned long)(RomAddress-0x00400000);	// This is just a simple linear map
  }

 for (a=NumBanks;a<64+32;a++)	// Do linear mappings for non rom banks
  {
  HRomLinReadBuffer[a]=(unsigned long)(BlankRom-(a*0x10000)-0x00C00000);
  HRomLinReadBuffer_48[a]=(unsigned long)(BlankRom-(a*0x10000)-0x00400000);
  }

 NumBanks*=2;		// We are now doing the 32k rom banks
 if (NumBanks>(64+32))
  NumBanks=64+32;	// Maximum addressable in 32k rom bank areas is 3MB.

 for (a=0;a<NumBanks;a++)
  {
  if ((a&0x01)==0x01)	// Do Odd numbers in table
   {
  // These are the low rom maps

   RomReadBuffer[a]=(unsigned long)(RomAddress-(((a/2)+1)*0x10000));
   RomHiReadBuffer[a]=(unsigned long)(RomAddress-(((a/2)+1)*0x10000)-0x00800000);

  // These are the hirom maps

   HRomReadBuffer[a]=(unsigned long)(RomAddress);
   HRomHiReadBuffer[a]=(unsigned long)(RomAddress-0x00800000);
//   HRomReadBuffer[a]=(unsigned long)(RomAddress-(((a/2)+1)*0x10000));
//   HRomHiReadBuffer[a]=(unsigned long)(RomAddress-(((a/2)+1)*0x10000)-0x00800000);
   }
  else			// Do Even numbers in table
   {
  // These are the low rom maps

   RomReadBuffer[a]=(unsigned long)(RomAddress-((a/2)*0x10000)-0x8000);
   RomHiReadBuffer[a]=(unsigned long)(RomAddress-((a/2)*0x10000)-0x00808000);

  // These are the hirom maps

   HRomReadBuffer[a]=(unsigned long)(RomAddress-((a/2)*0x10000));
   HRomHiReadBuffer[a]=(unsigned long)(RomAddress-((a/2)*0x10000)-0x00800000);
   }
  }

 for (a=NumBanks;a<64+32;a++)	// Points remaining banks at blank rom area.
  {
  // These are the low rom maps

  RomReadBuffer[a]=(unsigned long)(BlankRom-(a*0x10000));
  RomHiReadBuffer[a]=(unsigned long)(BlankRom-(a*0x10000)-0x00800000);

  // These are the hirom maps

  HRomReadBuffer[a]=(unsigned long)(BlankRom-(a*0x10000));
  HRomHiReadBuffer[a]=(unsigned long)(BlankRom-(a*0x10000)-0x00800000);
  }

 return 0;
 }

int LoadSRAM(char *FileName)
 {
 fstream InFile;
 
 InFile.open(FileName,ios::in|ios::binary);

 if (!InFile)
  return 1==0;		// File aint there m8

 InFile.seekg(0,ios::beg);

 InFile.read(SaveRamAddress,SaveRamLength*128);	// Read in Save Ram

 return 1==1;
 }

int SaveSRAM(char *FileName)
 {
 fstream OutFile;
 
 OutFile.open(FileName,ios::out|ios::binary);

 if (!OutFile)
  return 1==0;		// File aint there m8

 OutFile.seekg(0,ios::beg);

 OutFile.write(SaveRamAddress,SaveRamLength*128);	// Write out Save Ram

 return 1==1;
 }

int GUI();

char *SRAMFileName=NULL;

char SaveExtension[4];

void CreateSRAMFileName(char *FileName)
 {
 SRAMFileName=new char [strlen(FileName)+4];	// Get length + 4 for extension (.RAM is default)
 if (SRAMFileName!=NULL)		// If unable to determine name, we skip save ram!
  {
  int Count=0;
  while(FileName[Count]!=0 && FileName[Count]!='.')
   {
   SRAMFileName[Count]=FileName[Count];	// Copy the filename (& path)
   Count++;
   }
  SRAMFileName[Count+0]='.';
  SRAMFileName[Count+1]=SaveExtension[0];
  SRAMFileName[Count+2]=SaveExtension[1];
  SRAMFileName[Count+3]=SaveExtension[2];
  SRAMFileName[Count+4]=SaveExtension[3];
  }
 }

#ifdef DEBUG
extern "C" volatile unsigned long Timer_Counter_Profile;
extern "C" volatile unsigned long Timer_Counter_FPS;
extern "C" unsigned long Frames;
extern "C" unsigned long Total_CPU;
extern "C" unsigned long Total_Screen;

void Timer_Handler_Profile(...)
 {
 Timer_Counter_Profile++;
 }
END_OF_FUNCTION(Timer_Handler_Profile);

void Timer_Handler_FPS(...)
 {
 Timer_Counter_FPS++;
 }
END_OF_FUNCTION(Timer_Handler_FPS);

#endif

void LoadConfig()
 {
 PC_SCREEN_MODE=get_config_int(NULL,"screenmode",0);
//#ifdef ELF
 if (PC_SCREEN_MODE>8)
//#else
// if (PC_SCREEN_MODE>7)
//#endif
  PC_SCREEN_MODE=0;
  FRAME_SKIP=get_config_int(NULL,"frameskip",4);
 if (FRAME_SKIP>9)
  FRAME_SKIP=9;
 if (FRAME_SKIP<1)
  FRAME_SKIP=1;
 JOYSTICK_ENABLED=get_config_int(NULL,"joystick",0);
 if (JOYSTICK_ENABLED>1)
  JOYSTICK_ENABLED=0;
 JOYSTICK_ENABLED2=get_config_int(NULL,"joystick2",0);
 if (JOYSTICK_ENABLED2>1)
  JOYSTICK_ENABLED2=0;
 SPC_ENABLED=get_config_int(NULL,"emulatespc",0);	// This is remmed to prevent emulator failing!
 for (int a=0;a<4;a++)
  SaveExtension[a]='\0';
 strncpy(SaveExtension,get_config_string(NULL,"saveextension","RAM"),3);

 SNES_KEY_A=get_config_int(NULL,"sneskey_a",KEY_X);
 SNES_KEY_A&=0x0000007F;
 SNES_KEY_B=get_config_int(NULL,"sneskey_b",KEY_Z);
 SNES_KEY_B&=0x0000007F;
 SNES_KEY_X=get_config_int(NULL,"sneskey_x",KEY_S);
 SNES_KEY_X&=0x0000007F;
 SNES_KEY_Y=get_config_int(NULL,"sneskey_y",KEY_A);
 SNES_KEY_Y&=0x0000007F;
 SNES_KEY_L=get_config_int(NULL,"sneskey_l",KEY_Q);
 SNES_KEY_L&=0x0000007F;
 SNES_KEY_R=get_config_int(NULL,"sneskey_r",KEY_W);
 SNES_KEY_R&=0x0000007F;
 SNES_KEY_UP=get_config_int(NULL,"sneskey_up",KEY_UP);
 SNES_KEY_UP&=0x0000007F;
 SNES_KEY_DOWN=get_config_int(NULL,"sneskey_down",KEY_DOWN);
 SNES_KEY_DOWN&=0x0000007F;
 SNES_KEY_LEFT=get_config_int(NULL,"sneskey_left",KEY_LEFT);
 SNES_KEY_LEFT&=0x0000007F;
 SNES_KEY_RIGHT=get_config_int(NULL,"sneskey_right",KEY_RIGHT);
 SNES_KEY_RIGHT&=0x0000007F;
 SNES_KEY_SELECT=get_config_int(NULL,"sneskey_select",KEY_N);
 SNES_KEY_SELECT&=0x0000007F;
 SNES_KEY_START=get_config_int(NULL,"sneskey_start",KEY_M);
 SNES_KEY_START&=0x0000007F;

 SNES2_KEY_A=get_config_int(NULL,"sneskey2_a",KEY_E);
 SNES2_KEY_A&=0x0000007F;
 SNES2_KEY_B=get_config_int(NULL,"sneskey2_b",KEY_R);
 SNES2_KEY_B&=0x0000007F;
 SNES2_KEY_X=get_config_int(NULL,"sneskey2_x",KEY_T);
 SNES2_KEY_X&=0x0000007F;
 SNES2_KEY_Y=get_config_int(NULL,"sneskey2_y",KEY_Y);
 SNES2_KEY_Y&=0x0000007F;
 SNES2_KEY_L=get_config_int(NULL,"sneskey2_l",KEY_U);
 SNES2_KEY_L&=0x0000007F;
 SNES2_KEY_R=get_config_int(NULL,"sneskey2_r",KEY_I);
 SNES2_KEY_R&=0x0000007F;
 SNES2_KEY_UP=get_config_int(NULL,"sneskey2_up",KEY_H);
 SNES2_KEY_UP&=0x0000007F;
 SNES2_KEY_DOWN=get_config_int(NULL,"sneskey2_down",KEY_J);
 SNES2_KEY_DOWN&=0x0000007F;
 SNES2_KEY_LEFT=get_config_int(NULL,"sneskey2_left",KEY_K);
 SNES2_KEY_LEFT&=0x0000007F;
 SNES2_KEY_RIGHT=get_config_int(NULL,"sneskey2_right",KEY_L);
 SNES2_KEY_RIGHT&=0x0000007F;
 SNES2_KEY_SELECT=get_config_int(NULL,"sneskey2_select",KEY_P);
 SNES2_KEY_SELECT&=0x0000007F;
 SNES2_KEY_START=get_config_int(NULL,"sneskey2_start",KEY_O);
 SNES2_KEY_START&=0x0000007F;
 }

void SaveConfig()
 {
 set_config_int(NULL,"screenmode",PC_SCREEN_MODE);
 set_config_int(NULL,"frameskip",FRAME_SKIP);
 set_config_int(NULL,"joystick",JOYSTICK_ENABLED);
 set_config_int(NULL,"joystick2",JOYSTICK_ENABLED2);
 set_config_int(NULL,"emulatespc",SPC_ENABLED);
 set_config_int(NULL,"sneskey_a",SNES_KEY_A);
 set_config_int(NULL,"sneskey_b",SNES_KEY_B);
 set_config_int(NULL,"sneskey_x",SNES_KEY_X);
 set_config_int(NULL,"sneskey_y",SNES_KEY_Y);
 set_config_int(NULL,"sneskey_l",SNES_KEY_L);
 set_config_int(NULL,"sneskey_r",SNES_KEY_R);
 set_config_int(NULL,"sneskey_up",SNES_KEY_UP);
 set_config_int(NULL,"sneskey_down",SNES_KEY_DOWN);
 set_config_int(NULL,"sneskey_left",SNES_KEY_LEFT);
 set_config_int(NULL,"sneskey_right",SNES_KEY_RIGHT);
 set_config_int(NULL,"sneskey_select",SNES_KEY_SELECT);
 set_config_int(NULL,"sneskey_start",SNES_KEY_START);
 set_config_int(NULL,"sneskey2_a",SNES2_KEY_A);
 set_config_int(NULL,"sneskey2_b",SNES2_KEY_B);
 set_config_int(NULL,"sneskey2_x",SNES2_KEY_X);
 set_config_int(NULL,"sneskey2_y",SNES2_KEY_Y);
 set_config_int(NULL,"sneskey2_l",SNES2_KEY_L);
 set_config_int(NULL,"sneskey2_r",SNES2_KEY_R);
 set_config_int(NULL,"sneskey2_up",SNES2_KEY_UP);
 set_config_int(NULL,"sneskey2_down",SNES2_KEY_DOWN);
 set_config_int(NULL,"sneskey2_left",SNES2_KEY_LEFT);
 set_config_int(NULL,"sneskey2_right",SNES2_KEY_RIGHT);
 set_config_int(NULL,"sneskey2_select",SNES2_KEY_SELECT);
 set_config_int(NULL,"sneskey2_start",SNES2_KEY_START);
 }

void RedoBackPic()
 {
 if (sneese!=NULL)
  {
  destroy_bitmap(sneese);
  sneese=NULL;
  }

 #ifdef DEBUG
  sneese=load_pcx("sneese.dat#sneese",sneesepal);
 #else
  sneese=load_pcx("#sneese",sneesepal);
 #endif
 }

void SetupScreen(int ScreenMode)	// Used to configure the screen and set internal variables for rendering!
 {
 PC_SCREEN_MODE=ScreenMode;		// Set up a global remainder of the current screen mode

 switch (PC_SCREEN_MODE)
  {
  case 0: 
   ScreenX=320;
   ScreenY=200;
   set_color_depth(8);			// New for allegro 3.0 (removes need for my shitty VESA code!)
   break;
  case 1:
   ScreenX=320;
   ScreenY=200;
   set_color_depth(8);
   break;
  case 2:
   ScreenX=320;
   ScreenY=240;
   set_color_depth(8);
   break;
  case 3:
   ScreenX=256;
   ScreenY=256;
   set_color_depth(8);
   break;
  case 4:
   ScreenX=320;
   ScreenY=200;
   set_color_depth(16);
   break;
  case 5:
   ScreenX=320;
   ScreenY=240;
   set_color_depth(16);
   break;
  case 6:
   ScreenX=640;
   ScreenY=480;
   set_color_depth(16);
   break;
  case 7:
   ScreenX=640;
   ScreenY=480;
   set_color_depth(16);
   break;
  case 8:
   ScreenX=800;
   ScreenY=600;
   set_color_depth(24);
   break;
  }

 if (Allegro_Bitmap!=NULL)		// If bitmap exists destroy it
  destroy_bitmap(Allegro_Bitmap);
 Allegro_Bitmap=create_bitmap(ScreenX,ScreenY);
 clear(Allegro_Bitmap);
 SNES_Screen=(unsigned char *)Allegro_Bitmap->dat;
//#ifdef ELF
//
// lb_segment2=lb_segment;
// VESAScreenPtr=(unsigned char *)lb_linear;
 VESAScreenPtr=(unsigned char *)Allegro_Bitmap->dat;
//#endif
#ifndef BUGFIND
 if (PC_SCREEN_MODE==0 || PC_SCREEN_MODE==1)
  set_gfx_mode(GFX_VGA,ScreenX,ScreenY,ScreenX,ScreenY);
 else
  if (PC_SCREEN_MODE>=4 && PC_SCREEN_MODE<=8)
   {
   if (set_gfx_mode(GFX_VESA2L,ScreenX,ScreenY,ScreenX,ScreenY)!=0)
    {
    PC_SCREEN_MODE=0;	// Set screen to standard mode (if error!)
    ScreenX=320;
    ScreenY=200;
    destroy_bitmap(Allegro_Bitmap);
    Allegro_Bitmap=create_bitmap(ScreenX,ScreenY);
    clear(Allegro_Bitmap);
    SNES_Screen=(unsigned char *)Allegro_Bitmap->dat;
    set_gfx_mode(GFX_VGA,ScreenX,ScreenY,ScreenX,ScreenY);
    }
   }
  else
   if (set_gfx_mode(GFX_MODEX,ScreenX,ScreenY,ScreenX,ScreenY)!=0)
    {
    PC_SCREEN_MODE=0;	// Set screen to standard mode (if error!)
    ScreenX=320;
    ScreenY=200;
    destroy_bitmap(Allegro_Bitmap);
    Allegro_Bitmap=create_bitmap(ScreenX,ScreenY);
    clear(Allegro_Bitmap);
    SNES_Screen=(unsigned char *)Allegro_Bitmap->dat;
    set_gfx_mode(GFX_VGA,ScreenX,ScreenY,ScreenX,ScreenY);
    }
#endif
 RedoBackPic();		// We reload as it is then converted to the correct bit depth!
 }

void Wangle()
 {
 fstream SPC_DUMP("SPC.DMP",ios::bin|ios::out);

 SPC_DUMP.write(SPCAddress,65536);

 SPC_DUMP.close();

 fstream COL_DUMP("COL.DMP",ios::bin|ios::out);

 COL_DUMP.write(Real_SNES_Palette,2*256);

 COL_DUMP.close();

 fstream VRM_DUMP("VRM.DMP",ios::bin|ios::out);

 VRM_DUMP.write(VRamAddress,65536*2);

 VRM_DUMP.close();

#ifdef ELF
 fstream REG_DUMP("REG21.DMP",ios::bin|ios::out);		// ignore me

 REG_DUMP.write(RegDump,256*2);

 REG_DUMP.close();
#endif
 }

int main(int argc, char **argv)
 {
#ifdef DEBUG
 LOCK_VARIABLE(Timer_Counter_Profile);
 LOCK_VARIABLE(Timer_Counter_FPS);
 LOCK_FUNCTION(Timer_Handler_Profile);
 LOCK_FUNCTION(Timer_Handler_FPS);
#endif
        int memoryneeded;

 cout << "\nSNEeSe Version " << SNEESE_VERSION << "\nRelease Date - " << RELEASE_DATE;
 cout << "\nCode By Lee Hammerton (Savoury Snax), Santeri Saarimaa, Charles Bilyue\n";
 cout << allegro_id << "\n\n";
 cout.flush();

 if (argc!=2)
  {
  cout << "Please specify a rom to load.\n";
  return -1;
  }

 allegro_init();

 install_timer();

        memoryneeded = SetupMemory();

        if (memoryneeded != 0)
        {
                cout << "Out of memory. You need at least " << memoryneeded << " more bytes of memory!\n";
                return -1;
        }

        cout << "Trying to load " << argv[1] << "... ";

 if (!LoadROM(argv[1]))
  {
  cout << "Failed to load cartridge rom.\n";
  return -1;
  }

 set_config_file("SNEeSe.CFG");	// Yup, config files exist

 LoadConfig();			// Sets up all internal variables to some state based on the config file

#ifdef DEBUG
 install_int_ex(Timer_Handler_Profile,MSEC_TO_TIMER(5));
 install_int_ex(Timer_Handler_FPS,SECS_TO_TIMER(1));
#endif

 CreateSRAMFileName(argv[1]);		// Done so it can be used in gui()

 if (SRAMFileName!=NULL && SaveRamLength!=0)
  LoadSRAM(SRAMFileName);		// This loads in the Save Ram

 SetupTables();

 Allegro_Bitmap_GUI=create_bitmap_ex(8,320,200);		// This is used for the gui
 clear(Allegro_Bitmap_GUI);
 GUI_Screen=(unsigned char *)Allegro_Bitmap_GUI->dat;

        cout << "\n\nPress any key to continue...";
        cout.flush();

 // install a digital sound driver
 if (install_sound(DIGI_AUTODETECT, MIDI_NONE, NULL) != 0) 
  {
  cout << "\n\nError initialising sound system\n" << allegro_error;
  return -1;
  }

 for (int a=0;a<8;a++)
  {
  test[a]=new SAMPLE;			// This is to be used for sample decompression
  test[a]->bits=16;
  test[a]->freq=8000;
  test[a]->priority=255;
  test[a]->len=32768; ;
  test[a]->loop_start=0;
  test[a]->loop_end=0;
  test[a]->data=new char [32768*2*10];
  for (int b=0;b<32768*2*10;b++)
   ((char *)(test[a]->data))[b]=0;

  VoiceList[a]=allocate_voice(test[a]);
  }

// Take Control Of Keyboard here (else getch()) wont bloody work!

#ifndef BUGFIND
 install_keyboard();
#endif

//Warning... from now on the keyboard is not accessable except via 128 byte buffer!

 joy_type=JOY_TYPE_6BUTTON;

 initialise_joystick();

 #ifdef DEBUG
  joypad=load_pcx("sneese.dat#joypad",sneesepal);
 #else
  joypad=load_pcx("#joypad",sneesepal);
 #endif

 SetupScreen(PC_SCREEN_MODE);		// PC_SCREEN_MODE set by config file

//#ifdef ELF
 StartScreen();

 SNESVRAM=VRamAddress;
 SNESREGS=RegDump;
 SpriteRAM=OAMAddress;
 temppal=Real_SNES_Palette;
//#endif

 Reset_CPU();

 Reset_SPC();

// RomAddress[0x820C-0x8000]=0x42;
// RomAddress[0x9040-0x8000]=0xEA;
// RomAddress[0x9041-0x8000]=0xEA;
// RomAddress[0x9067-0x8000]=0xEA;
// RomAddress[0x9068-0x8000]=0xEA;

 while (1==1)
  { 
  Do_CPU();	// This is the Emulation core.

  if (GUI()==0)	// Exit was pushed
   break;
  }

 set_gfx_mode(GFX_TEXT,0,0,0,0);

 remove_keyboard();

// Keyboard restored from now on... 

#ifdef DEBUG

 Wangle();

 DisplayStatus();

 cout << "\n\nTotal Screen - " << Total_Screen << "   Total CPU - " << Total_CPU;

 if (Timer_Counter_FPS>0)
  {
  cout << "\n\nFrames Per Second - " << (Frames/Timer_Counter_FPS) << "." << ((Frames*100)/Timer_Counter_FPS)%100;
  }

 if (Total_CPU+Total_Screen!=0)
  {
  cout << "\nPercentage Of CPU - " << (Total_CPU*100)/(Total_CPU+Total_Screen);
  cout << "\nPercentage Of Screen - " << (Total_Screen*100)/(Total_CPU+Total_Screen);
  }
#else
 cout << "\nThanks for using SNEeSe - Look Out For Future Releases\n";
 cout << "\nSavoury SnaX.\n";
#endif
 cout.flush();

 if (SRAMFileName!=NULL && SaveRamLength!=0)
  SaveSRAM(SRAMFileName);		// Save the Save Ram to file

 SaveConfig();

 return 0;
 }
