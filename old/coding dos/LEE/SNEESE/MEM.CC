/*

  MEMory functions (Mappings,IO,etc) - For SNEeSe

 Code By Savoury SnaX

*/

#include <stdlib.h>
#include <iostream.h>
#include <conio.h>

#include "romload.h"
#include "mem.h"
#include "scankeys.h"

 #include "main.h"

extern volatile int KeyCodeBuffer[128];

// Reads are mapped onto bank 0
// Writes are mapped to bank 0
// Dont know why I did this but I did!?

/////////////////////////////////////////
// Local varibles mode global
// GetSNESByte()
 unsigned short Offset;
 unsigned char Bank;
 unsigned char Temp;
// doDMA0(), doDMA1() shared ?
 unsigned short numBytes;
 unsigned char VidReg;
 unsigned char *VidAddress;
 unsigned char *SrcAddress;
 unsigned short DataWord;




unsigned char GetSNESByte(unsigned char *Ptr)
 {
 // This function wraps all hw addresses onto the first bank of
 //memory, at present much wastage occurs..will rid it l8r!

 // These two variables are known but lost by this point
 Offset=(unsigned short)(((unsigned long)Ptr-(unsigned long)RomAddress)&0xFFFF);
 Bank=(unsigned char)((((unsigned long)Ptr-(unsigned long)RomAddress)&0xFF0000)>>16);
 Temp;

 if (/*Bank>=0 &&*/ Bank<=0x3F)             // Hardware possible
  {
  if (Offset>0x2000 && Offset<=0x5FFF)	// Hardware access
   {
   switch(Offset)
    {
    case 0x2100:		// not readable!
    case 0x2101:
    case 0x2102:
    case 0x2103:
    case 0x2104:
    case 0x2105:
    case 0x2106:
    case 0x2107:
    case 0x2108:
    case 0x2109:
    case 0x210a:
    case 0x210b:
    case 0x210c:
    case 0x210d:
    case 0x210e:
    case 0x210f:
    case 0x2110:
    case 0x2111:
    case 0x2112:
    case 0x2113:
    case 0x2114:
    case 0x2115:
    case 0x2116:
    case 0x2117:
    case 0x2118:
    case 0x2119:
    case 0x211a:
    case 0x211b:
    case 0x211c:
    case 0x211d:
    case 0x211e:
    case 0x211f:
    case 0x2120:
    case 0x2121:
    case 0x2122:
    case 0x2123:
    case 0x2124:
    case 0x2125:
    case 0x2126:
    case 0x2127:
    case 0x2128:
    case 0x2129:
    case 0x212a:
    case 0x212b:
    case 0x212c:
    case 0x212d:
    case 0x212e:
    case 0x212f:
    case 0x2130:
    case 0x2131:
    case 0x2132:
    case 0x2133:
    case 0x4200:
    case 0x4201:
    case 0x4202:
    case 0x4203:
    case 0x4204:
    case 0x4205:
    case 0x4206:
    case 0x4207:
    case 0x4208:
    case 0x4209:
    case 0x420a:
    case 0x420b:
    case 0x420c:
    case 0x420d:
     break;
    case 0x4210:		// VBLANK NMI READ + VERSION (dont know what version is?)
     Temp=*(Offset+RomAddress);
     *(Offset+RomAddress)=0;
     return Temp;
    case 0x4212:		// HBLANK/VBLANK/JOY STATE READ
     return 0;			// may need changing l8r!
    case 0x4218:		// AXLR - Joy Buttons (PAD 1)
     Temp=0;
     if (KeyCodeBuffer[K_X])	// A pressed
      Temp+=0x80;
     if (KeyCodeBuffer[K_S])	// X pressed
      Temp+=0x40;
     if (KeyCodeBuffer[K_Q])	// L pressed
      Temp+=0x20;
     if (KeyCodeBuffer[K_W])	// R pressed
      Temp+=0x10;
     return Temp;
    case 0x4219:		// BY<SELECT><START><UP><DOWN><LEFT><RIGHT> - Joy (PAD 1)
     Temp=0;
     if (KeyCodeBuffer[K_Z])		// B pressed
      Temp+=0x80;
     if (KeyCodeBuffer[K_A])		// Y pressed
      Temp+=0x40;
     if (KeyCodeBuffer[K_N])		// <SELECT> pressed
      Temp+=0x20;
     if (KeyCodeBuffer[K_M])		// <START> pressed
      Temp+=0x10;
     if (KeyCodeBuffer[C_UP])		// <UP> pressed
      Temp+=0x08;
     if (KeyCodeBuffer[C_DOWN])		// <DOWN> pressed
      Temp+=0x04;
     if (KeyCodeBuffer[C_LEFT])		// <LEFT> pressed
      Temp+=0x02;
     if (KeyCodeBuffer[C_RIGHT])	// <RIGHT> pressed
      Temp+=0x01;
     return Temp;
    case 0x4300:		// Not readable
    case 0x4301:
    case 0x4302:
    case 0x4303:
    case 0x4304:
    case 0x4305:
    case 0x4306:
    case 0x430a:
    case 0x4310:
    case 0x4311:
    case 0x4312:
    case 0x4313:
    case 0x4314:
    case 0x4315:
    case 0x4316:
    case 0x431a:
    case 0x4320:
    case 0x4321:
    case 0x4322:
    case 0x4323:
    case 0x4324:
    case 0x4325:
    case 0x4326:
    case 0x432a:
    case 0x4330:
    case 0x4331:
    case 0x4332:
    case 0x4333:
    case 0x4334:
    case 0x4335:
    case 0x4336:
    case 0x433a:
    case 0x4340:
    case 0x4341:
    case 0x4342:
    case 0x4343:
    case 0x4344:
    case 0x4345:
    case 0x4346:
    case 0x434a:
    case 0x4350:
    case 0x4351:
    case 0x4352:
    case 0x4353:
    case 0x4354:
    case 0x4355:
    case 0x4356:
    case 0x435a:
    case 0x4360:
    case 0x4361:
    case 0x4362:
    case 0x4363:
    case 0x4364:
    case 0x4365:
    case 0x4366:
    case 0x436a:
    case 0x4370:
    case 0x4371:
    case 0x4372:
    case 0x4373:
    case 0x4374:
    case 0x4375:
    case 0x4376:
    case 0x437a:
     break;
    default:
     char Message[100];
     itoa(Offset,Message,16);

     cout << "\nRead From Unhandled Hardware Address : - 0x" << Message;
     cout.flush();
     getch();
     return *(Offset+RomAddress);
    }
   }
  }
 
 return *Ptr;
 }

unsigned short GetSNESWord(unsigned char *Ptr)
 {
 return (GetSNESByte(Ptr)+(GetSNESByte(Ptr+1)<<8));
 }

unsigned char GetSNESByte_Unmapped(unsigned char *Ptr)
 {
 return (*Ptr);
 }

unsigned short GetSNESWord_Unmapped(unsigned char *Ptr)
 {
 return (*Ptr+((*(Ptr+1))<<8));
 }

void doDMA0(unsigned short BaseAddress)
 {
 numBytes=GetSNESWord_Unmapped((BaseAddress+5)+RomAddress)/2;
 VidReg=GetSNESByte_Unmapped((BaseAddress+1)+RomAddress);
 VidAddress=RomAddress+(0x2100+VidReg);
 SrcAddress=(unsigned char *)(RomAddress+GetSNESWord_Unmapped((BaseAddress+2)+RomAddress)+(GetSNESByte_Unmapped((BaseAddress+4)+RomAddress)<<16));
 DataWord;
 for (int a=0;a<numBytes;a++)
  {
  DataWord=GetSNESWord(SrcAddress);
  SrcAddress+=2;
  SetSNESByte(VidAddress,DataWord&0xFF);
  SetSNESByte(VidAddress,DataWord>>8);
  }
 }

void doDMA1(unsigned short BaseAddress)
 {
 numBytes=GetSNESWord_Unmapped((BaseAddress+5)+RomAddress)/2;
 VidReg=GetSNESByte_Unmapped((BaseAddress+1)+RomAddress);
 VidAddress=RomAddress+(0x2100+VidReg);
 SrcAddress=(unsigned char *)(RomAddress+GetSNESWord_Unmapped((BaseAddress+2)+RomAddress)+(GetSNESByte_Unmapped((BaseAddress+4)+RomAddress)<<16));
 for (int a=0;a<numBytes;a++)
  {
  SetSNESWord(VidAddress,GetSNESWord(SrcAddress));
  SrcAddress+=2;
  }
 }

void doDMA(unsigned char Byte)
 {
 if ((Byte)&0x01==0x01)		// channel 0
  {
  switch((GetSNESByte_Unmapped(0x4300+RomAddress)&0x07))
   {
   case 0x00:		// 1 address double write
    doDMA0(0x4300);
    break;
   case 0x01:		// 2 addresses
    doDMA1(0x4300);
    break;
   default:
    cout << "\nUNSUPPORTED - DMA Mode " << (GetSNESByte_Unmapped(0x4300+RomAddress)&0x07);
    cout << "\nMODE INFO " << GetSNESByte_Unmapped(0x4300+RomAddress);
    cout.flush();
    getch();
    break;
   }
  }
 if ((Byte)&0x02==0x02)		// channel 1
  {
  switch((GetSNESByte_Unmapped(0x4310+RomAddress)&0x07))
   {
   case 0x00:		// 1 address double write
    doDMA0(0x4310);
    break;
   case 0x01:		// 2 addresses
    doDMA1(0x4310);
    break;
   default:
    cout << "\nUNSUPPORTED - DMA Mode " << (GetSNESByte_Unmapped(0x4310+RomAddress)&0x07);
    cout.flush();
    getch();
    break;
   }
  }
 if ((Byte)&0x04==0x04)		// channel 2
  {
  switch((GetSNESByte_Unmapped(0x4320+RomAddress)&0x07))
   {
   case 0x00:		// 1 address double write
    doDMA0(0x4320);
    break;
   case 0x01:		// 2 addresses
    doDMA1(0x4320);
    break;
   default:
    cout << "\nUNSUPPORTED - DMA Mode " << (GetSNESByte_Unmapped(0x4320+RomAddress)&0x07);
    cout.flush();
    getch();
    break;
   }
  }
 if ((Byte)&0x08==0x08)		// channel 3
  {
  switch((GetSNESByte_Unmapped(0x4330+RomAddress)&0x07))
   {
   case 0x00:		// 1 address double write
    doDMA0(0x4330);
    break;
   case 0x01:		// 2 addresses
    doDMA1(0x4330);
    break;
   default:
    cout << "\nUNSUPPORTED - DMA Mode " << (GetSNESByte_Unmapped(0x4330+RomAddress)&0x07);
    cout.flush();
    getch();
    break;
   }
  }
 if ((Byte)&0x10==0x10)		// channel 4
  {
  switch((GetSNESByte_Unmapped(0x4340+RomAddress)&0x07))
   {
   case 0x00:		// 1 address double write
    doDMA0(0x4340);
    break;
   case 0x01:		// 2 addresses
    doDMA1(0x4340);
    break;
   default:
    cout << "\nUNSUPPORTED - DMA Mode " << (GetSNESByte_Unmapped(0x4340+RomAddress)&0x07);
    cout.flush();
    getch();
    break;
   }
  }
 if ((Byte)&0x20==0x20)		// channel 5
  {
  switch((GetSNESByte_Unmapped(0x4350+RomAddress)&0x07))
   {
   case 0x00:		// 1 address double write
    doDMA0(0x4350);
    break;
   case 0x01:		// 2 addresses
    doDMA1(0x4350);
    break;
   default:
    cout << "\nUNSUPPORTED - DMA Mode " << (GetSNESByte_Unmapped(0x4350+RomAddress)&0x07);
    cout.flush();
    getch();
    break;
   }
  }
 if ((Byte)&0x40==0x40)		// channel 6
  {
  switch((GetSNESByte_Unmapped(0x4360+RomAddress)&0x07))
   {
   case 0x00:		// 1 address double write
    doDMA0(0x4360);
    break;
   case 0x01:		// 2 addresses
    doDMA1(0x4360);
    break;
   default:
    cout << "\nUNSUPPORTED - DMA Mode " << (GetSNESByte_Unmapped(0x4360+RomAddress)&0x07);
    cout.flush();
    getch();
    break;
   }
  }
 if ((Byte)&0x80==0x80)		// channel 7
  {
  switch((GetSNESByte_Unmapped(0x4370+RomAddress)&0x07))
   {
   case 0x00:		// 1 address double write
    doDMA0(0x4370);
    break;
   case 0x01:		// 2 addresses
    doDMA1(0x4370);
    break;
   default:
    cout << "\nUNSUPPORTED - DMA Mode " << (GetSNESByte_Unmapped(0x4370+RomAddress)&0x07);
    cout.flush();
    getch();
    break;
   }
  }
 }

unsigned char *MappedVRAMAddress;

void doVRAMPoke1(unsigned char Byte)
 {
 *MappedVRAMAddress=Byte;
 if ((GetSNESByte_Unmapped(0x2115+RomAddress)&0x80)==0x00)
  MappedVRAMAddress++;	// Increment Address Byte Mode
 }

void doVRAMPoke2(unsigned char Byte)
 {
 *(MappedVRAMAddress+1)=Byte;
 if ((GetSNESByte_Unmapped(0x2115+RomAddress)&0x80)==0x80)
  MappedVRAMAddress+=2;	// Increment Address Word Mode
 }

int ColourRegNum=0;
int ColourDataWrite=0;
unsigned short ColourData;

unsigned char SNESPalette[16][256*3];	// Cunning Auto Brightness for nothing!

void SetPalette(unsigned char *);

void SetSNESPalette(int Num,unsigned short Data)
 {					// Shift left 1 to make inside VGA 0-63 range!
 int Red,Green,Blue;

 Red=((Data&0x001F))<<1;
 Green=((Data&0x03E0)>>5)<<1;
 Blue=((Data&0x7C00)>>10)<<1;

 for (int a=0;a<16;a++)		// Calculate palette with brightness levels
  {
  SNESPalette[a][Num*3+0]=Red/(16-a);
  SNESPalette[a][Num*3+1]=Green/(16-a);
  SNESPalette[a][Num*3+2]=Blue/(16-a);
  } 
 SetPalette(SNESPalette[GetSNESByte_Unmapped(0x2100+RomAddress)&0x0F]);
 }

int BG1HScrollWrite=0;
int BG1VScrollWrite=0;
int BG2HScrollWrite=0;
int BG2VScrollWrite=0;
int BG3HScrollWrite=0;
int BG3VScrollWrite=0;
int BG4HScrollWrite=0;
int BG4VScrollWrite=0;

void SetSNESByte(unsigned char *Ptr,unsigned char Byte)
 {
 // This function wraps all hw addresses onto the first bank of
 //memory, at present much wastage occurs..will rid it l8r!

 // These two variables are known but lost by this point
 unsigned short Offset=(unsigned short)(((unsigned long)Ptr-(unsigned long)RomAddress)&0xFFFF);
 unsigned char Bank=(unsigned char)((((unsigned long)Ptr-(unsigned long)RomAddress)&0xFF0000)>>16);
 char Message[100];

 if (/*Bank>=0 &&*/ Bank<=0x3F)		// Hardware possible
  {
  if (Offset>0x7FFF)			// Rom ADDRESS!
   {
   itoa(Offset,Message,16);

   cout << "\nWrite To Rom Ignored : - 0x" << Message;
   cout.flush();
   return;
   }

  if (Offset>0x2000 && Offset<=0x5FFF)	// Hardware access
   {
   switch (Offset)
    {
    case 0x2100:	// Screen Enable + Brightness
     SetPalette(SNESPalette[Byte&0x0F]);
     return;
    case 0x210d:	// Set Horiz Scroll BG1
     if (BG1HScrollWrite==0)
      {
      BG1HScrollData&=0xff00;
      BG1HScrollData|=Byte;
      BG1HScrollWrite++;
      }
     else
      {
      BG1HScrollData&=0x00ff;
      BG1HScrollData|=Byte<<8;
      BG1HScrollWrite--;
      }
     return;
    case 0x210e:	// Set Vert Scroll BG1
     if (BG1VScrollWrite==0)
      {
      BG1VScrollData&=0xff00;
      BG1VScrollData|=Byte;
      BG1VScrollWrite++;
      }
     else
      {
      BG1VScrollData&=0x00ff;
      BG1VScrollData|=Byte<<8;
      BG1VScrollWrite--;
      }
     return;
    case 0x210f:	// Set Horiz Scroll BG2
     if (BG2HScrollWrite==0)
      {
      BG2HScrollData&=0xff00;
      BG2HScrollData|=Byte;
      BG2HScrollWrite++;
      }
     else
      {
      BG2HScrollData&=0x00ff;
      BG2HScrollData|=Byte<<8;
      BG2HScrollWrite--;
      }
     return;
    case 0x2110:	// Set Vert Scroll BG2
     if (BG2VScrollWrite==0)
      {
      BG2VScrollData&=0xff00;
      BG2VScrollData|=Byte;
      BG2VScrollWrite++;
      }
     else
      {
      BG2VScrollData&=0x00ff;
      BG2VScrollData|=Byte<<8;
      BG2VScrollWrite--;
      }
     return;
    case 0x2111:	// Set Horiz Scroll BG3
     if (BG3HScrollWrite==0)
      {
      BG3HScrollData&=0xff00;
      BG3HScrollData|=Byte;
      BG3HScrollWrite++;
      }
     else
      {
      BG3HScrollData&=0x00ff;
      BG3HScrollData|=Byte<<8;
      BG3HScrollWrite--;
      }
     return;
    case 0x2112:	// Set Vert Scroll BG3
     if (BG3VScrollWrite==0)
      {
      BG3VScrollData&=0xff00;
      BG3VScrollData|=Byte;
      BG3VScrollWrite++;
      }
     else
      {
      BG3VScrollData&=0x00ff;
      BG3VScrollData|=Byte<<8;
      BG3VScrollWrite--;
      }
     return;
    case 0x2113:	// Set Horiz Scroll BG4
     if (BG4HScrollWrite==0)
      {
      BG4HScrollData&=0xff00;
      BG4HScrollData|=Byte;
      BG4HScrollWrite++;
      }
     else
      {
      BG4HScrollData&=0x00ff;
      BG4HScrollData|=Byte<<8;
      BG4HScrollWrite--;
      }
     return;
    case 0x2114:	// Set Vert Scroll BG4
     if (BG4VScrollWrite==0)
      {
      BG4VScrollData&=0xff00;
      BG4VScrollData|=Byte;
      BG4VScrollWrite++;
      }
     else
      {
      BG4VScrollData&=0x00ff;
      BG4VScrollData|=Byte<<8;
      BG4VScrollWrite--;
      }
     return;
    case 0x2116:	// Set VRAMAddress
    case 0x2117:
     *(Offset+RomAddress)=Byte;	// Poke The Byte Immediately (Makes Things easier)
     MappedVRAMAddress=VRamAddress+GetSNESWord_Unmapped(0x2116+RomAddress);
     return;
    case 0x2118:	// Poke byte to video ram
     doVRAMPoke1(Byte);
     return;
    case 0x2119:	// poke byte to video ram
     doVRAMPoke2(Byte);
     return;
    case 0x2121:	// SNES colour register number
     ColourRegNum=Byte;
     return;
    case 0x2122:	// SNES colour data
     if (ColourDataWrite==0)	// first time (its a double write register)
      {
      ColourData&=0xFF00;
      ColourData|=Byte;
      ColourDataWrite++;
      }
     else
      {
      ColourData&=0x00FF;
      ColourData|=Byte<<8;
      SetSNESPalette(ColourRegNum++,ColourData);
      ColourDataWrite--;
      }
     return;
    case 0x2134:	//unwritable register
    case 0x2135:
    case 0x2136:
    case 0x2137:
    case 0x2138:
    case 0x2139:
    case 0x213a:
    case 0x213b:
    case 0x213c:
    case 0x213d:
    case 0x213e:
    case 0x213f:
     return;
    case 0x420b:	// Start DMA
     doDMA(Byte);
     return;
    case 0x4210:	// unwritable register
     return;
    case 0x4213:	// unwritable register
    case 0x4214:
    case 0x4215:
    case 0x4216:
    case 0x4217:
    case 0x4218:
    case 0x4219:
    case 0x421a:
    case 0x421b:
    case 0x421c:
    case 0x421d:
    case 0x421e:
    case 0x421f:
     return;
    case 0x4300:	// Supported via DMA channel 0
    case 0x4301:
    case 0x4302:
    case 0x4303:
    case 0x4304:
    case 0x4305:
    case 0x4306:
    case 0x4310:	// Supported via DMA channel 1
    case 0x4311:
    case 0x4312:
    case 0x4313:
    case 0x4314:
    case 0x4315:
    case 0x4316:
    case 0x4320:	// Supported via DMA channel 2
    case 0x4321:
    case 0x4322:
    case 0x4323:
    case 0x4324:
    case 0x4325:
    case 0x4326:
    case 0x4330:	// Supported via DMA channel 3
    case 0x4331:
    case 0x4332:
    case 0x4333:
    case 0x4334:
    case 0x4335:
    case 0x4336:
    case 0x4340:	// Supported via DMA channel 4
    case 0x4341:
    case 0x4342:
    case 0x4343:
    case 0x4344:
    case 0x4345:
    case 0x4346:
    case 0x4350:	// Supported via DMA channel 5
    case 0x4351:
    case 0x4352:
    case 0x4353:
    case 0x4354:
    case 0x4355:
    case 0x4356:
    case 0x4360:	// Supported via DMA channel 6
    case 0x4361:
    case 0x4362:
    case 0x4363:
    case 0x4364:
    case 0x4365:
    case 0x4366:
    case 0x4370:	// Supported via DMA channel 7
    case 0x4371:
    case 0x4372:
    case 0x4373:
    case 0x4374:
    case 0x4375:
    case 0x4376:
     *(Offset+RomAddress)=Byte;	// Poke The Byte Immediately (Makes Things easier)
     return;
    default:
     itoa(Offset,Message,16);
 
     cout << "\nWrite To Hardware Address Not Yet Supported : - 0x" << Message;
     cout.flush();
//     getch();

     *(Offset+RomAddress)=Byte;	// Poke The Byte Immediately (Makes Things easier)

     return;
    }
   }
  }
 
 *Ptr=Byte;
 }

void SetSNESWord(unsigned char *Ptr,unsigned short Word)
 {
 SetSNESByte(Ptr,Word&0x00ff);
 SetSNESByte(Ptr+1,Word>>8);
 }

void SetSNESByte_Unmapped(unsigned char *Ptr,unsigned char Byte)
 {
 *Ptr=Byte;
 }

void SetSNESWord_Unmapped(unsigned char *Ptr,unsigned short Word)
 {
 SetSNESByte_Unmapped(Ptr,Word&0x00ff);
 SetSNESByte_Unmapped(Ptr+1,Word>>8);
 }


