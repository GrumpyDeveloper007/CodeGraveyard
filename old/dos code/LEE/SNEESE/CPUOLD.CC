/*

  65816 CPU Emulation Engine - For SNEeSe

 Code By Savoury SnaX

*/

#include <stdlib.h>

#include "RomImage.h"
#include "mem.h"
#include "CPU.h"	// include CPU defines

SNES_RegisterSetTYPE SNES_Registers;

#define SNES_FLAG_C (0x0001)
#define SNES_FLAG_M (0x0002)
#define SNES_FLAG_X (0x0004)
#define SNES_FLAG_I (0x0008)
#define SNES_FLAG_D (0x0010)
#define SNES_FLAG_B (0x0020)
#define SNES_FLAG_Z (0x0040)
#define SNES_FLAG_N (0x0080)
#define SNES_FLAG_E (0x0100)
// 0x0200
// 0x0400
#define SNES_FLAG_V (0x0800)

#define SET_FLAG(x) (SNES_Registers.Flags|=x)
#define CLR_FLAG(x) (SNES_Registers.Flags&=~x)
#define TEST_FLAG(x) ((SNES_Registers.Flags&x)==x) // True=Set

unsigned long SNES_Cycles;		// CPU Clocks (Updated Per Instruction)

inline void doDMA0(unsigned char Byte)
 {
 unsigned short numBytes=GetSNESWord_Unmapped(0x4305+RomAddress)/2;	// DMAing Words
 unsigned char VidReg=GetSNESByte_Unmapped(0x4301+RomAddress);
 unsigned char *VidAddress=RomAddress+(0x2100+VidReg);
 unsigned char *SrcAddress=(unsigned char *)(RomAddress+GetSNESWord_Unmapped(0x4302+RomAddress)+(GetSNESByte_Unmapped(0x4304+RomAddress)<<16));
 unsigned short DataWord;
 for (int a=0;a<numBytes;a++)
  {
  DataWord=GetSNESWord(SrcAddress);
  SrcAddress+=2;
  SetSNESByte(VidAddress,DataWord&0xFF);
  SetSNESByte(VidAddress,DataWord>>8);
  }
 }

inline void doDMA1(unsigned char Byte)
 {
 unsigned short numBytes=GetSNESWord_Unmapped(0x4305+RomAddress)/2;	// DMAing Words
 unsigned char VidReg=GetSNESByte_Unmapped(0x4301+RomAddress);
 unsigned char *VidAddress=RomAddress+(0x2100+VidReg);
 unsigned char *SrcAddress=(unsigned char *)(RomAddress+GetSNESWord_Unmapped(0x4302+RomAddress)+(GetSNESByte_Unmapped(0x4304+RomAddress)<<16));
 for (int a=0;a<numBytes;a++)
  {
  SetSNESWord(VidAddress,GetSNESWord(SrcAddress));	// Not as recursive as it looks!
  SrcAddress+=2;
  }
 }

void doDMA(unsigned char Byte)	// Made into a function due to VC compiler errors!
 {
 // Only Simple Copy To Vid Ram Supported At Present & DMA 0
 if (((Byte)&0x01)==0x01)	// Do DMA 0
  {
  switch((GetSNESByte_Unmapped(0x4300+RomAddress)&0x07))
   {
   case 0x00:	// 1 Address double write
	doDMA0(Byte);
	break;
   case 0x01:	// 2 Addresses
    doDMA1(Byte);
	break;
   default:
    OutMessage("\nEEk Unsupported DMA Mode !\n");
    return;
   }
  }
 else
  {
  if (Byte!=0)
   {
   OutMessage("\nUnsupported DMA Number !\n");
   return;
   }
  }
 }

unsigned char *MappedVRAMAddress;	// Fast Access To VRAM through 0x2116

void doVRAMPoke1(unsigned char Byte)
 {
 *MappedVRAMAddress=Byte;
 if ((GetSNESByte_Unmapped(0x2115+RomAddress)&0x80)==0x00)
  MappedVRAMAddress++;		// Increment Address (BYTE MODE)
 }

void doVRAMPoke2(unsigned char Byte)
 {
 *(MappedVRAMAddress+1)=Byte;
 if ((GetSNESByte_Unmapped(0x2115+RomAddress)&0x80)==0x80)
  MappedVRAMAddress+=2;		// Increment Address (WORD MODE)
 }

int ColourRegNum=0;			// Palette Number Currently
int ColourDataWrite=0;		// Number of times written too,
unsigned short ColourData;	//this must be written to twice lo-hi!

unsigned char SNESPalette[256*3];

void SetPalette(unsigned char *);

void SetSNESPalette(int Num,unsigned short Data)
 {
 // Colour Data is Shifted left by 3 bits to use up 8Bit PC Range
 SNESPalette[Num*3+0]=((Data&0x001F))<<3;		// Red (first 5 bits)
 SNESPalette[Num*3+1]=((Data&0x03E0)>>5)<<3;	// Green (second 5 bits)
 SNESPalette[Num*3+2]=((Data&0x7C00)>>10)<<3;	// Blue (last 5 bits)
 SetPalette(SNESPalette);
 }

void SetSNESByte(unsigned char *Ptr,unsigned char Byte)
 {
 // This function wraps all hw addresses onto the first bank of
 //memory, at present much wastage occurs..will rid it l8r!

 // These two variables are known but lost by this point
 unsigned short Offset=(unsigned short)(((unsigned long)Ptr-(unsigned long)RomAddress)&0xFFFF);
 unsigned char Bank=(unsigned char)((((unsigned long)Ptr-(unsigned long)RomAddress)&0xFF0000)>>16);

 if (Bank>=0 && Bank<=0x3F)		// Hardware possible
  {
  if (Offset>0x7FFF)			// Rom ADDRESS!
   {
   char Message[100];
   itoa(Offset,Message,16);
   OutMessage("\nWrite To Rom Ignored : - 0x");
   OutMessage(Message);
   OutMessage("\n");
   return;
   }

  *(Offset+RomAddress)=Byte;	// Poke The Byte Immediately (Makes Things easier)

  if (Offset>0x2000 && Offset<=0x5FFF)	// Hardware access
   {
   switch (Offset)
    {
	case 0x2116:				// Set VRAM Address
	case 0x2117:
	 MappedVRAMAddress=VRamAddress+GetSNESWord_Unmapped(0x2116+RomAddress); 
	 break;
	case 0x2118:						// Poke byte to VRAM (in 2116)
	 doVRAMPoke1(Byte);				// Might increment (depends on 2115)
	 break;
	case 0x2119:					// Same as 2118 almost
	 doVRAMPoke2(Byte);
	 break;
	case 0x2121:					// SNES colour register number
	 ColourRegNum=Byte;
	 break;
	case 0x2122:					// SNES colour data
	 if (ColourDataWrite==0)		// First time written too
	  {
	  ColourData&=0xFF00;
	  ColourData|=Byte;
	  ColourDataWrite=1;
	  }
	 else
	  {
	  ColourData&=0x00FF;
	  ColourData|=Byte<<8;
	  SetSNESPalette(ColourRegNum++,ColourData);
	  ColourDataWrite=0;
	  }
	 break;
	case 0x420B:						// Start DMA - only simple copy supported
	 doDMA(Byte);
	 break;
	case 0x2140:
	 if (Byte==0 && SPC_State==0)		// Reset Request ?
	  SPC_Action=1;
	 if (SPC_State==1)
	  SPC_Action=2;
	 break;
	case 0x2141:
	 if (Byte==0 && SPC_State==0)		// Reset Request ?
	  SPC_Action=1;
	 if (SPC_State==1)		// Initialised
	  SPC_Action=2;
	 break;
	case 0x4300:		// All these are supported via another register
	case 0x4301:		// e.g. DMA setup is supported by doDMA
	case 0x4302:
	case 0x4303:
	case 0x4304:
	case 0x4305:
	case 0x4306:
	 break;
	default:
     char Message[100];
     itoa(Offset,Message,16);
     OutMessage("\nWrite To Hardware Address Not Yet Supported : - 0x");
     OutMessage(Message);
     OutMessage("\n");
	 break;
	}
   return;
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

inline void SNES_Push_W(unsigned short Word)
 {
 SNES_Registers.S.SNESPointer.Offset.W--;
 SetSNESWord(SNESAddress(SNES_Registers.S),Word);
 SNES_Registers.S.SNESPointer.Offset.W--;
 }

inline void SNES_Push_B(unsigned char Byte)
 {
 SetSNESByte(SNESAddress(SNES_Registers.S),Byte);
 SNES_Registers.S.SNESPointer.Offset.W--;
 }

inline unsigned short SNES_Pull_W()
 {
 unsigned short Temp;
 SNES_Registers.S.SNESPointer.Offset.W++;
 Temp=GetSNESWord(SNESAddress(SNES_Registers.S));
 SNES_Registers.S.SNESPointer.Offset.W++;
 return Temp;
 }

inline unsigned char SNES_Pull_B()
 {
 SNES_Registers.S.SNESPointer.Offset.W++;
 return GetSNESByte(SNESAddress(SNES_Registers.S));
 }

// Addressing mappers (Must be called when PC points after opcode!)

inline unsigned char *Immediate()	// get effective address for immediate
 {
 return SNESAddress(SNES_Registers.PC);
 }

inline unsigned char *Absolute()	// get effective address for absolute
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Bank=SNES_Registers.D.SNESPointer.Bank;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 return SNESAddress(Address);
 }

inline unsigned char *AbsoluteX()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Bank=SNES_Registers.D.SNESPointer.Bank;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2; 
 Address.SNESPointer.Offset.W+=SNES_Registers.X.W;

 return SNESAddress(Address);
 }

inline unsigned char *AbsoluteLong()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2; 
 Address.SNESPointer.Bank=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

inline unsigned char *AbsoluteLongX()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2; 
 Address.SNESPointer.Bank=GetSNESByte(SNESAddress(SNES_Registers.PC));
 Address.SNESPointer.Offset.W+=SNES_Registers.X.W;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

inline unsigned char *DirectInderectIndexedLongY()
 {
 SNES2PC_Pointer Address,Address2;

 Address.PCPointer=0;
 Address2.PCPointer=0;
 Address.SNESPointer.Offset.W=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 Address.SNESPointer.Offset.W+=SNES_Registers.D.SNESPointer.Offset.W;
 Address2.SNESPointer.Offset.W=GetSNESWord(SNESAddress(Address));
 Address.SNESPointer.Offset.W+=2;
 Address2.SNESPointer.Bank=GetSNESByte(SNESAddress(Address));
 Address2.PCPointer+=SNES_Registers.Y.W;

 return SNESAddress(Address2);
 }

inline unsigned char *Direct()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=SNES_Registers.D.SNESPointer.Offset.W;
 Address.SNESPointer.Offset.W+=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

inline unsigned char *DirectIndexX()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=SNES_Registers.D.SNESPointer.Offset.W;
 Address.SNESPointer.Offset.W+=GetSNESByte(SNESAddress(SNES_Registers.PC));
 Address.SNESPointer.Offset.W+=SNES_Registers.X.W;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

inline unsigned char *StackRelative()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=SNES_Registers.S.SNESPointer.Offset.W;
 Address.SNESPointer.Offset.W+=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

void (*OpTable[256])();		// Jump Table To All The Instructions

void SEI()		// Set Interrupt Disable
 {
 SET_FLAG(SNES_FLAG_I);
 SNES_Cycles+=2;			// Instruction Takes 2 Clock Ticks
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

/*void STX_d_y()	// Store Index X In Location D+Y+Immediate
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  { 
  SNES_Registers.PC.SNESPointer.Offset.W++;
  Address.SNESPointer.Offset.W=SNES_Registers.D.SNESPointer.Offset.W+SNES_Registers.Y.W+*SNESAddress(SNES_Registers.PC);
  SetSNESWord(SNESAddress(Address),SNES_Registers.X.W);
  SNES_Cycles+=5;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 else
  {
  SNES_Registers.PC.SNESPointer.Offset.W++;
  Address.SNESPointer.Offset.W=SNES_Registers.D.SNESPointer.Offset.W+SNES_Registers.Y.B.L+*SNESAddress(SNES_Registers.PC);
  *SNESAddress(Address)=SNES_Registers.X.B.L;
  SNES_Cycles+=4;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }*/

void STZ_a()	// Zero Absolute Address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  { 
  SetSNESWord(Absolute(),0);
  SNES_Cycles+=4;
  }
 else
  {
  SetSNESByte(Absolute(),0);
  SNES_Cycles+=3;
  }
 }

void LDA_i()	// Put Imediate Byte/Word into A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W=GetSNESWord(Immediate());
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  SNES_Registers.A.B.L=GetSNESByte(Immediate());
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void STA_a()	// Put A at absolute address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  { 
  SetSNESWord(Absolute(),SNES_Registers.A.W);
  SNES_Cycles+=4;
  }
 else
  {
  SetSNESByte(Absolute(),SNES_Registers.A.B.L);
  SNES_Cycles+=3;
  }
 }

void CLC()		// Clear Carry Flag
 {
 CLR_FLAG(SNES_FLAG_C);
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void XCE()		// Exchange carry with emulation bit
 {
 int Temp;

 SNES_Registers.X.B.H=0;
 SNES_Registers.Y.B.H=0;
 SNES_Registers.S.SNESPointer.Offset.B.H=1;

 if (TEST_FLAG(SNES_FLAG_E))
  Temp=1;
 else
  Temp=0;

 if (TEST_FLAG(SNES_FLAG_C))
  SET_FLAG(SNES_FLAG_E);
 else
  CLR_FLAG(SNES_FLAG_E);

 if (Temp==1)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);
  
 if (TEST_FLAG(SNES_FLAG_E))
  {
  SET_FLAG(SNES_FLAG_M);
  SET_FLAG(SNES_FLAG_X);
  }
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void REP_i()	// Reset Flags Specified in immediate Byte
 {
 unsigned char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(Immediate());
 Temp=~Temp;

 if (TEST_FLAG(SNES_FLAG_N) && ((Temp&0x80)>>7)==1)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 if (TEST_FLAG(SNES_FLAG_V) && ((Temp&0x40)>>6)==1)
  SET_FLAG(SNES_FLAG_V);
 else
  CLR_FLAG(SNES_FLAG_V);
 if (TEST_FLAG(SNES_FLAG_M) && ((Temp&0x20)>>5)==1)
  SET_FLAG(SNES_FLAG_M);
 else
  CLR_FLAG(SNES_FLAG_M);
 if (TEST_FLAG(SNES_FLAG_X) && ((Temp&0x10)>>4)==1)
  SET_FLAG(SNES_FLAG_X);
 else
  CLR_FLAG(SNES_FLAG_X);
 if (TEST_FLAG(SNES_FLAG_D) && ((Temp&0x08)>>3)==1)
  SET_FLAG(SNES_FLAG_D);
 else
  CLR_FLAG(SNES_FLAG_D);
 if (TEST_FLAG(SNES_FLAG_I) && ((Temp&0x04)>>2)==1)
  SET_FLAG(SNES_FLAG_I);
 else
  CLR_FLAG(SNES_FLAG_I);
 if (TEST_FLAG(SNES_FLAG_Z) && ((Temp&0x02)>>1)==1)
  SET_FLAG(SNES_FLAG_Z);
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (TEST_FLAG(SNES_FLAG_C) && ((Temp&0x01)>>0)==1)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);
 if (TEST_FLAG(SNES_FLAG_E))	// Ensures M,X remain Masked (6502)
  {
  SET_FLAG(SNES_FLAG_M);
  SET_FLAG(SNES_FLAG_X);
  }
 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void TCD()	// Transfer A into D
 {
 SNES_Registers.D.SNESPointer.Offset.W=SNES_Registers.A.W;
 if (SNES_Registers.A.W==0)
  SET_FLAG(SNES_FLAG_Z);
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void TCS()	// Transfer A into S
 {
 SNES_Registers.S.SNESPointer.Offset.W=SNES_Registers.A.W;
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void STA_al()	// Put A at Absolute Address Long
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  { 
  SetSNESWord(AbsoluteLong(),SNES_Registers.A.W);
  SNES_Cycles+=6;
  }
 else
  {
  SetSNESByte(AbsoluteLong(),SNES_Registers.A.B.L);
  SNES_Cycles+=4;
  }
 }

void LDX_i()	// Put immediate into X
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.X.W=GetSNESWord(Immediate());
  if (SNES_Registers.X.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  SNES_Registers.X.B.L=GetSNESByte(Immediate());
  if (SNES_Registers.X.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void LDY_i()	// Put immediate into Y
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.Y.W=GetSNESWord(Immediate());
  if (SNES_Registers.Y.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.Y.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  SNES_Registers.Y.B.L=GetSNESByte(Immediate());
  if (SNES_Registers.Y.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.Y.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void STA_al_x()	// Store A into absolute long + X
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  { 
  SetSNESWord(AbsoluteLongX(),SNES_Registers.A.W);
  SNES_Cycles+=6;
  }
 else
  {
  SetSNESByte(AbsoluteLongX(),SNES_Registers.A.B.L);
  SNES_Cycles+=4;
  }
 }

void TYA()	// Transfer Y To A
 {
 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W=SNES_Registers.Y.W;
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 else
  {
  SNES_Registers.A.B.L=SNES_Registers.Y.B.L;
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void SEC()	// Set Carry Flag
 {
 SET_FLAG(SNES_FLAG_C);
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void SBC_i()	// Sub with carry immediate from A
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  Temp.W=GetSNESWord(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov ax,SNES_Registers.A.W;
   mov bx,Temp.W;
   popf;			// get flags ready for action
   sbb ax,bx;		// Do Subtraction
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.W,ax;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  Temp.B.L=GetSNESByte(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov al,SNES_Registers.A.B.L;
   mov bl,Temp.B.L;
   popf;			// get flags ready for action
   sbb al,bl;		// Do Subtraction
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.B.L,al;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void TAY()	// Transfer A To Y
 {
 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.Y.W=SNES_Registers.A.W;
  if (SNES_Registers.Y.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.Y.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 else
  {
  SNES_Registers.Y.B.L=SNES_Registers.A.B.L;
  if (SNES_Registers.Y.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.Y.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void DEX()	// Decrement X
 {
 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.X.W--;
  if (SNES_Registers.X.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 else
  {
  SNES_Registers.X.B.L--;
  if (SNES_Registers.X.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void BPL_r()	// Branch if N==0 PC+r
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (!TEST_FLAG(SNES_FLAG_N))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void SEP_i()	// Set Bytes Specified in immediate byte
 {
 unsigned char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(Immediate());

 if (TEST_FLAG(SNES_FLAG_N) || ((Temp&0x80)>>7)==1)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 if (TEST_FLAG(SNES_FLAG_V) || ((Temp&0x40)>>6)==1)
  SET_FLAG(SNES_FLAG_V);
 else
  CLR_FLAG(SNES_FLAG_V);
 if (TEST_FLAG(SNES_FLAG_M) || ((Temp&0x20)>>5)==1)
  SET_FLAG(SNES_FLAG_M);
 else
  CLR_FLAG(SNES_FLAG_M);
 if (TEST_FLAG(SNES_FLAG_X) || ((Temp&0x10)>>4)==1)
  SET_FLAG(SNES_FLAG_X);
 else
  CLR_FLAG(SNES_FLAG_X);
 if (TEST_FLAG(SNES_FLAG_D) || ((Temp&0x08)>>3)==1)
  SET_FLAG(SNES_FLAG_D);
 else
  CLR_FLAG(SNES_FLAG_D);
 if (TEST_FLAG(SNES_FLAG_I) || ((Temp&0x04)>>2)==1)
  SET_FLAG(SNES_FLAG_I);
 else
  CLR_FLAG(SNES_FLAG_I);
 if (TEST_FLAG(SNES_FLAG_Z) || ((Temp&0x02)>>1)==1)
  SET_FLAG(SNES_FLAG_Z);
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (TEST_FLAG(SNES_FLAG_C) || ((Temp&0x01)>>0)==1)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);
 if (TEST_FLAG(SNES_FLAG_E))	// Ensures M,X remain Masked (6502)
  {
  SET_FLAG(SNES_FLAG_M);
  SET_FLAG(SNES_FLAG_X);
  }
 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void JSR_a()	// Jump to absolute subroutine (push pc on stack)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Push_W(SNES_Registers.PC.SNESPointer.Offset.W+2);

 SNES_Registers.PC.PCPointer=(unsigned char *)((unsigned long)Absolute()-(unsigned long)RomAddress);
 SNES_Cycles+=6;
 }

void PHP_s()	// Push Flags onto stack
 {
 unsigned char Temp=0;

 if (TEST_FLAG(SNES_FLAG_N))
  Temp|=0x80;
 if (TEST_FLAG(SNES_FLAG_V))
  Temp|=0x40;
 if (TEST_FLAG(SNES_FLAG_M))
  Temp|=0x20;
 if (TEST_FLAG(SNES_FLAG_X))
  Temp|=0x10;
 if (TEST_FLAG(SNES_FLAG_D))
  Temp|=0x08;
 if (TEST_FLAG(SNES_FLAG_I))
  Temp|=0x04;
 if (TEST_FLAG(SNES_FLAG_Z))
  Temp|=0x02;
 if (TEST_FLAG(SNES_FLAG_C))
  Temp|=0x01;

 SNES_Push_B(Temp);

 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void CMP_a()	// compare
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  Temp.W=GetSNESWord(Absolute());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov ax,SNES_Registers.A.W;
   mov bx,Temp.W;
   cmp ax,bx;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=5;
  }
 else
  {
  Temp.B.L=GetSNESByte(Absolute());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov al,SNES_Registers.A.B.L;
   mov bl,Temp.B.L;
   cmp al,bl;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=4;
  }
 }

void BNE_r()	// Branch if Z=0
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (!TEST_FLAG(SNES_FLAG_Z))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void BRA_r()	// Branch always
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void PHA_s()	// Push Accumulator onto stack
 {
 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Push_W(SNES_Registers.A.W);
  SNES_Registers.PC.SNESPointer.Offset.W++;
  SNES_Cycles+=4;
  }
 else
  {
  SNES_Push_B(SNES_Registers.A.B.L);
  SNES_Registers.PC.SNESPointer.Offset.W++;
  SNES_Cycles+=3;
  }
 }

void LDA_IdI_y()	// LDA [d],y - B7
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W=GetSNESWord(DirectInderectIndexedLongY());
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=7;
  }
 else
  {
  SNES_Registers.A.B.L=GetSNESByte(DirectInderectIndexedLongY());
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=6;
  }
 }

void INY()	// Increment Y
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.Y.W++;
  if (SNES_Registers.Y.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.Y.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  }
 else
  {
  SNES_Registers.Y.B.L++;
  if (SNES_Registers.Y.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.Y.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  }
 }

void TAX()	// Transfer A To X
 {
 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.X.W=SNES_Registers.A.W;
  if (SNES_Registers.X.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 else
  {
  SNES_Registers.X.B.L=SNES_Registers.A.B.L;
  if (SNES_Registers.X.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void CPX_i()	//Compare immediate with X
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  Temp.W=GetSNESWord(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov ax,SNES_Registers.X.W;
   mov bx,Temp.W;
   cmp bx,ax;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  Temp.B.L=GetSNESByte(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov al,SNES_Registers.X.B.L;
   mov bl,Temp.B.L;
   cmp bl,al;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void BRK_s()	// Software interrupt (looks like COP?)
 {
 // I ignore the immediate byte for now, none of the documentation
 //I have tells me what it is for !

 unsigned char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(Immediate());
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E))
  {
  SNES_Push_B(SNES_Registers.PC.SNESPointer.Bank);
  SNES_Push_B(SNES_Registers.PC.SNESPointer.Offset.B.H);
  SNES_Push_B(SNES_Registers.PC.SNESPointer.Offset.B.L);
  CLR_FLAG(SNES_FLAG_D);
  SET_FLAG(SNES_FLAG_I);
  CLR_FLAG(SNES_FLAG_X);	// This is B (its position on 6502!)

  Temp=0;
  if (TEST_FLAG(SNES_FLAG_N))
   Temp|=0x80;
  if (TEST_FLAG(SNES_FLAG_V))
   Temp|=0x40;
  if (TEST_FLAG(SNES_FLAG_M))
   Temp|=0x20;
  if (TEST_FLAG(SNES_FLAG_X))
   Temp|=0x10;
  if (TEST_FLAG(SNES_FLAG_D))
   Temp|=0x08;
  if (TEST_FLAG(SNES_FLAG_I))
   Temp|=0x04;
  if (TEST_FLAG(SNES_FLAG_Z))
   Temp|=0x02;
  if (TEST_FLAG(SNES_FLAG_C))
   Temp|=0x01;

  SNES_Push_B(Temp);
  SNES_Registers.PC.SNESPointer.Bank=0;
  SNES_Registers.PC.SNESPointer.Offset.W=GetSNESWord(0xFFE6+RomAddress);
  SNES_Cycles+=8;
  }
 else
  {
  SNES_Push_B(SNES_Registers.PC.SNESPointer.Offset.B.H);
  SNES_Push_B(SNES_Registers.PC.SNESPointer.Offset.B.L);
  CLR_FLAG(SNES_FLAG_D);
  SET_FLAG(SNES_FLAG_I);
  SET_FLAG(SNES_FLAG_X);	// This is B (its position on 6502)

  Temp=0;
  if (TEST_FLAG(SNES_FLAG_N))
   Temp|=0x80;
  if (TEST_FLAG(SNES_FLAG_V))
   Temp|=0x40;
  if (TEST_FLAG(SNES_FLAG_M))
   Temp|=0x20;
  if (TEST_FLAG(SNES_FLAG_X))
   Temp|=0x10;
  if (TEST_FLAG(SNES_FLAG_D))
   Temp|=0x08;
  if (TEST_FLAG(SNES_FLAG_I))
   Temp|=0x04;
  if (TEST_FLAG(SNES_FLAG_Z))
   Temp|=0x02;
  if (TEST_FLAG(SNES_FLAG_C))
   Temp|=0x01;

  SNES_Push_B(Temp);
  SNES_Registers.PC.SNESPointer.Bank=0;
  SNES_Registers.PC.SNESPointer.Offset.W=GetSNESWord(0xFFFE+RomAddress);
  SNES_Cycles+=7;
  }
 }

void ROL_A()		// Rol Accumulator
 {
 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov ax,SNES_Registers.A.W;
   popf;			// get flags ready for action
   rol ax,1;		// Do rol
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_C); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_C);	// clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.W,ax;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 else
  {
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov al,SNES_Registers.A.B.L;
   popf;			// get flags ready for action
   rol al,1;		// Do Subtraction
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_C); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_C); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.B.L,al;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void ADC_i()	// Add with carry to accumulator
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  Temp.W=GetSNESWord(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov ax,SNES_Registers.A.W;
   mov bx,Temp.W;
   popf;			// get flags ready for action
   adc ax,bx;		// Do Addition
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.W,ax;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  Temp.B.L=GetSNESByte(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov al,SNES_Registers.A.B.L;
   mov bl,Temp.B.L;
   popf;			// get flags ready for action
   adc al,bl;		// Do Addition
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.B.L,al;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void PLA_s()	// Pop Accumulator
 {
 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W=SNES_Pull_W();
  SNES_Registers.PC.SNESPointer.Offset.W++;
  SNES_Cycles+=5;
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  }
 else
  {
  SNES_Registers.A.B.L=SNES_Pull_B();
  SNES_Registers.PC.SNESPointer.Offset.W++;
  SNES_Cycles+=4;
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  }
 }

void BVS_r()	// Branch if V=1
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (TEST_FLAG(SNES_FLAG_V))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void PLP_s()	// Pull Flags from stack
 {
 unsigned char Temp=0;
 Temp=SNES_Pull_B();

 if (((Temp&0x80)>>7)==1)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 if (((Temp&0x40)>>6)==1)
  SET_FLAG(SNES_FLAG_V);
 else
  CLR_FLAG(SNES_FLAG_V);
 if (((Temp&0x20)>>5)==1)
  SET_FLAG(SNES_FLAG_M);
 else
  CLR_FLAG(SNES_FLAG_M);
 if (((Temp&0x10)>>4)==1)
  SET_FLAG(SNES_FLAG_X);
 else
  CLR_FLAG(SNES_FLAG_X);
 if (((Temp&0x08)>>3)==1)
  SET_FLAG(SNES_FLAG_D);
 else
  CLR_FLAG(SNES_FLAG_D);
 if (((Temp&0x04)>>2)==1)
  SET_FLAG(SNES_FLAG_I);
 else
  CLR_FLAG(SNES_FLAG_I);
 if (((Temp&0x02)>>1)==1)
  SET_FLAG(SNES_FLAG_Z);
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (((Temp&0x01)>>0)==1)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 }

void RTS_s()	// Return from subroutine.
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.PC.SNESPointer.Offset.W=SNES_Pull_W();
 SNES_Cycles+=6;
 }

void CLI()	// Clear Interrupt Disable
 {
 CLR_FLAG(SNES_FLAG_I);
 SNES_Cycles+=2;			// Instruction Takes 2 Clock Ticks
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void STZ_d_x()	// Zero direct Offset + X
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  { 
  SetSNESWord(DirectIndexX(),0);
  SNES_Cycles+=5;
  }
 else
  {
  SetSNESByte(DirectIndexX(),0);
  SNES_Cycles+=4;
  }
 }

void PHK_s()	// Push Program Bank Register onto stack
 {
 SNES_Push_B(SNES_Registers.PC.SNESPointer.Bank);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void PLB_s()	// Pop Data Bank Register
 {
 SNES_Registers.D.SNESPointer.Bank=SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.D.SNESPointer.Bank==0)
  SET_FLAG(SNES_FLAG_Z);
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.D.SNESPointer.Bank>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void STX_a()	// Put X at absolute address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  { 
  SetSNESWord(Absolute(),SNES_Registers.X.W);
  SNES_Cycles+=5;
  }
 else
  {
  SetSNESByte(Absolute(),SNES_Registers.X.B.L);
  SNES_Cycles+=4;
  }
 }

void INX()	// Increment X
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.X.W++;
  if (SNES_Registers.X.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  }
 else
  {
  SNES_Registers.X.B.L++;
  if (SNES_Registers.X.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  }
 }

void STY_a()	// Put Y at absolute address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  { 
  SetSNESWord(Absolute(),SNES_Registers.Y.W);
  SNES_Cycles+=5;
  }
 else
  {
  SetSNESByte(Absolute(),SNES_Registers.Y.B.L);
  SNES_Cycles+=4;
  }
 }

void LDX_a()	// Put absolute into X
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.X.W=GetSNESWord(Absolute());
  if (SNES_Registers.X.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  }
 else
  {
  SNES_Registers.X.B.L=GetSNESByte(Absolute());
  if (SNES_Registers.X.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.X.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  }
 }

void STA_d_s()	// Put A at stack relative address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  { 
  SetSNESWord(StackRelative(),SNES_Registers.A.W);
  SNES_Cycles+=5;
  }
 else
  {
  SetSNESByte(StackRelative(),SNES_Registers.A.B.L);
  SNES_Cycles+=4;
  }
 }

void LDA_a_x()	// Put absolute index x Byte/Word into A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W=GetSNESWord(AbsoluteX());
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  }
 else
  {
  SNES_Registers.A.B.L=GetSNESByte(AbsoluteX());
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  }
 }

void STA_d()	// Put A at direct address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  { 
  SetSNESWord(Direct(),SNES_Registers.A.W);
  SNES_Cycles+=4;
  }
 else
  {
  SetSNESByte(Direct(),SNES_Registers.A.B.L);
  SNES_Cycles+=3;
  }
 }

void STZ_d()	// Zero direct Offset
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  { 
  SetSNESWord(Direct(),0);
  SNES_Cycles+=4;
  }
 else
  {
  SetSNESByte(Direct(),0);
  SNES_Cycles+=3;
  }
 }

void LDY_d()	// Put direct offset into Y
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  SNES_Registers.Y.W=GetSNESWord(Direct());
  if (SNES_Registers.Y.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.Y.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=4;
  }
 else
  {
  SNES_Registers.Y.B.L=GetSNESByte(Direct());
  if (SNES_Registers.Y.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.Y.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  }
 }

void CMP_i()	// compare
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  Temp.W=GetSNESWord(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov ax,SNES_Registers.A.W;
   mov bx,Temp.W;
   cmp ax,bx;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  Temp.B.L=GetSNESByte(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov al,SNES_Registers.A.B.L;
   mov bl,Temp.B.L;
   cmp al,bl;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void ADC_a()	// Add with carry to accumulator
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  Temp.W=GetSNESWord(Absolute());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov ax,SNES_Registers.A.W;
   mov bx,Temp.W;
   popf;			// get flags ready for action
   adc ax,bx;		// Do Addition
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.W,ax;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=5;
  }
 else
  {
  Temp.B.L=GetSNESByte(Absolute());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov al,SNES_Registers.A.B.L;
   mov bl,Temp.B.L;
   popf;			// get flags ready for action
   adc al,bl;		// Do Addition
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.B.L,al;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=4;
  }
 }

void BCC_r()	// Branch if C=0
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (!TEST_FLAG(SNES_FLAG_C))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void STY_d()	// Put Y at direct address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  { 
  SetSNESWord(Direct(),SNES_Registers.Y.W);
  SNES_Cycles+=5;
  }
 else
  {
  SetSNESByte(Direct(),SNES_Registers.Y.B.L);
  SNES_Cycles+=4;
  }
 }

void CPX_d()	//Compare direct offset with X
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  Temp.W=GetSNESWord(Direct());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov ax,SNES_Registers.X.W;
   mov bx,Temp.W;
   cmp bx,ax;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=4;
  }
 else
  {
  Temp.B.L=GetSNESByte(Direct());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov al,SNES_Registers.X.B.L;
   mov bl,Temp.B.L;
   cmp bl,al;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=3;
  }
 }

void BEQ_r()	// Branch if Z=1
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (TEST_FLAG(SNES_FLAG_Z))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void TXA()	// Transfer X To A
 {
 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W=SNES_Registers.X.W;
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 else
  {
  SNES_Registers.A.B.L=SNES_Registers.X.B.L;
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void AND_i()	// AND A with immediate byte/word
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W&=GetSNESWord(Immediate());
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  SNES_Registers.A.B.L&=GetSNESByte(Immediate());
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void BIT_i()	//Bit test immediate
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  Temp.W=GetSNESWord(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov ax,SNES_Registers.A.W;
   mov bx,Temp.W;
   and ax,bx;		// Do test
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_Z); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_Z); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  Temp.B.L=GetSNESByte(Immediate());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov al,SNES_Registers.A.B.L;
   mov bl,Temp.B.L;
   and al,bl;		// Do test
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_Z); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_Z); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void DEC_d()	// Decrement direct offset
 {
 Reg_16 Temp2;
 unsigned char *Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++; 
 Temp=Direct();

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  Temp2.W=GetSNESWord(Temp)-1;
  SetSNESWord(Temp,Temp2.W);
  if (Temp2.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (Temp2.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=6;
  }
 else
  {
  Temp2.B.L=GetSNESByte(Temp)-1;
  SetSNESByte(Temp,Temp2.B.L);
  if (Temp2.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (Temp2.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=5;
  }
 }

void LDA_al_x()	// Put absolute index x Byte/Word into A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W=GetSNESWord(AbsoluteLongX());
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=6;
  }
 else
  {
  SNES_Registers.A.B.L=GetSNESByte(AbsoluteLongX());
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=5;
  }
 }

void ADC_d()	// Add with carry to accumulator
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  Temp.W=GetSNESWord(Direct());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov ax,SNES_Registers.A.W;
   mov bx,Temp.W;
   popf;			// get flags ready for action
   adc ax,bx;		// Do Addition
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.W,ax;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=4;
  }
 else
  {
  Temp.B.L=GetSNESByte(Direct());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   push ecx;
   pushf;
   pop ax;			// Flags are in ax!
   mov bx,SNES_Registers.Flags;	// Snes flags in bx
   and bx,(SNES_FLAG_C);		// We want the carry flag
   or ax,bx;					// set carry if needed
   push ax;						// put flags back
   mov al,SNES_Registers.A.B.L;
   mov bl,Temp.B.L;
   popf;			// get flags ready for action
   adc al,bl;		// Do Addition
   pushf;
   pop bx;			// flags are in bx!
   and bx,(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov cx,SNES_Registers.Flags;
   and cx,~(SNES_FLAG_V|SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or cx,bx;			// Set the relevant information 
   mov SNES_Registers.Flags,cx;	// flags updated
   mov SNES_Registers.A.B.L,al;	// A updated
   pop ecx;
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=3;
  }
 }

void WAI()	// Wait For Interrupt
 {
 // Erm, I dunno, I`ll just skip it for now
 //
 // The final version will loop on this instruction untill an
 //interrupt

// CLR_FLAG(SNES_FLAG_I);
 SNES_Cycles+=3;			// Instruction Takes 2 Clock Ticks
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void LDA_a()	// Put absolute address into A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W=GetSNESWord(Absolute());
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=5;
  }
 else
  {
  SNES_Registers.A.B.L=GetSNESByte(Absolute());
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=4;
  }
 }

void BRL_r()	// Branch always long
 {
 signed short Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2;
 SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=3;
 }

void ORA_i()	// Or immediate Byte/Word with A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_M))
  {
  SNES_Registers.A.W|=GetSNESWord(Immediate());
  if (SNES_Registers.A.W==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.W>=0x8000)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=3;
  SNES_Registers.PC.SNESPointer.Offset.W+=2;
  }
 else
  {
  SNES_Registers.A.B.L|=GetSNESByte(Immediate());
  if (SNES_Registers.A.B.L==0)
   SET_FLAG(SNES_FLAG_Z);
  else
   CLR_FLAG(SNES_FLAG_Z);
  if (SNES_Registers.A.B.L>=0x80)
   SET_FLAG(SNES_FLAG_N);
  else
   CLR_FLAG(SNES_FLAG_N);
  SNES_Cycles+=2;
  SNES_Registers.PC.SNESPointer.Offset.W++;
  }
 }

void CPY_d()	//Compare direct offset with Y
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (!TEST_FLAG(SNES_FLAG_E) && !TEST_FLAG(SNES_FLAG_X))
  {
  Temp.W=GetSNESWord(Direct());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov ax,SNES_Registers.Y.W;
   mov bx,Temp.W;
   cmp bx,ax;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=4;
  }
 else
  {
  Temp.B.L=GetSNESByte(Direct());
  
  _asm		// Done in ASM to make borrow and overflow flags easier
   {
   push eax;
   push ebx;
   mov al,SNES_Registers.Y.B.L;
   mov bl,Temp.B.L;
   cmp bl,al;		// Do Comparison
   pushf;
   pop ax;			// flags are in bx!
   and ax,(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // get bits that are to be updated
   mov bx,SNES_Registers.Flags;
   and bx,~(SNES_FLAG_C|SNES_FLAG_Z|SNES_FLAG_N); // clear bits in snes flags
   or bx,ax;			// Set the relevant information 
   mov SNES_Registers.Flags,bx;	// flags updated
   pop ebx;
   pop eax;
   }
  SNES_Cycles+=3;
  }
 }

//=================

void Reset_CPU(unsigned short Reset,unsigned short NMI)
 {						// Clears Registers To Reset Values
						//and prepares for CPU Emulation

 for (int a=0;a<256;a++)
  OpTable[a]=InvalidOpcode;	// Set All Opcodes To Unsupported

 //OpTable[0x00]=BRK_s;
 OpTable[0x08]=PHP_s;
 OpTable[0x09]=ORA_i;
 OpTable[0x10]=BPL_r;
 OpTable[0x18]=CLC;
 OpTable[0x1B]=TCS;
 OpTable[0x20]=JSR_a;
 OpTable[0x28]=PLP_s;
 OpTable[0x29]=AND_i;
 OpTable[0x2A]=ROL_A;
 OpTable[0x38]=SEC;
 OpTable[0x48]=PHA_s;
 OpTable[0x4B]=PHK_s;
 OpTable[0x58]=CLI;
 OpTable[0x5B]=TCD;
 OpTable[0x60]=RTS_s;
 OpTable[0x64]=STZ_d;
 OpTable[0x65]=ADC_d;
 OpTable[0x68]=PLA_s;
 OpTable[0x69]=ADC_i;
 OpTable[0x6D]=ADC_a;
 OpTable[0x70]=BVS_r;
 OpTable[0x74]=STZ_d_x;
 OpTable[0x78]=SEI;
 OpTable[0x80]=BRA_r;
 OpTable[0x82]=BRL_r;
 //OpTable[0x83]=STA_d_s;
 OpTable[0x84]=STY_d;
 OpTable[0x85]=STA_d;
 OpTable[0x89]=BIT_i;
 OpTable[0x8A]=TXA;
 OpTable[0x8C]=STY_a;
 OpTable[0x8D]=STA_a;
 OpTable[0x8E]=STX_a;
 OpTable[0x8F]=STA_al;
 //OpTable[0x96]=STX_d_y;
 OpTable[0x98]=TYA;
 OpTable[0x90]=BCC_r;
 OpTable[0x9C]=STZ_a;
 OpTable[0x9F]=STA_al_x;
 OpTable[0xA0]=LDY_i;
 OpTable[0xA2]=LDX_i;
 OpTable[0xA4]=LDY_d;
 OpTable[0xA8]=TAY;
 OpTable[0xA9]=LDA_i;
 OpTable[0xAA]=TAX;
 OpTable[0xAB]=PLB_s;
 OpTable[0xAD]=LDA_a;
 OpTable[0xAE]=LDX_a;
 OpTable[0xB7]=LDA_IdI_y;
 OpTable[0xBD]=LDA_a_x;
 OpTable[0xBF]=LDA_al_x;
 OpTable[0xC2]=REP_i;
 OpTable[0xC4]=CPY_d;
 OpTable[0xC6]=DEC_d;
 OpTable[0xC8]=INY;
 OpTable[0xC9]=CMP_i;
 OpTable[0xCA]=DEX;
 OpTable[0xCB]=WAI;
 OpTable[0xCD]=CMP_a;
 OpTable[0xD0]=BNE_r;
 OpTable[0xE0]=CPX_i;
 OpTable[0xE2]=SEP_i;
 OpTable[0xE4]=CPX_d;
 OpTable[0xE8]=INX;
 OpTable[0xE9]=SBC_i;
 OpTable[0xF0]=BEQ_r;
 OpTable[0xFB]=XCE;

 SNES_Cycles=0;
 SNES_Registers.A.W=0;
 SNES_Registers.D.PCPointer=0;
 SNES_Registers.X.W=0;
 SNES_Registers.Y.W=0;
 SNES_Registers.Flags=0x030E;	// Set 1|E|I|X|M
 SNES_Registers.PC.PCPointer=0;
 SNES_Registers.PC.SNESPointer.Offset.W=Reset;
 SNES_Registers.S.PCPointer=0;
 SNES_Registers.S.SNESPointer.Offset.W=0x100;

 Init_SPC();
 }

void Do_CPU()		// This executes the next instruction in the
 {					//ROM/RAM where-ever!

 unsigned char OpCode=GetSNESByte(SNESAddress(SNES_Registers.PC));

 OpTable[OpCode]();		// Do Emulated Opcode

 Do_SPC();
 }
