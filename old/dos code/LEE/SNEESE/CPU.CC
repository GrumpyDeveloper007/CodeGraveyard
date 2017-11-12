/*

  65816 CPU Emulation Engine - For SNEeSe

 Code By Savoury SnaX


NOTES - There are 5 Jump Tables (when Pe=0, when Pm=1, when Px=1, when Pm & Px=1 and when Pe=1)

*/

#include <stdlib.h>
#include <fstream.h>
#include <process.h>

#include "Romload.h"
#include "mem.h"
#include "CPU.h"	// include CPU defines
#include "addr.h"	// include addressing mode stuff

void InvalidOpcode();

SNES_RegisterSetTYPE SNES_Registers;

unsigned long SNES_Cycles;		// CPU Clocks (Updated Per Instruction)

void (**CurTable)();		// Points to the jump table to use at present

void (*E0OpTable[256])();	// Jump Table For non Emulation with Pm=0 & Px=0
void (*PxOpTable[256])();	// Jump Table For non Emulation with Pm=0 & Px=1
void (*PmOpTable[256])();	// Jump Table For non Emulation with Pm=1 & Px=0
void (*MXOpTable[256])();	// Jump Table For non Emulation with Pm=1 & Px=1
void (*E1OpTable[256])();	// Jump Table For Emulation Mode

void E0_SNES_Push_B(unsigned char Byte)	// Push non emulation
 {
 SetSNESByte(SNESAddress(SNES_Registers.S),Byte);
 SNES_Registers.S.SNESPointer.Offset.W--;
 }

void E1_SNES_Push_B(unsigned char Byte)	// Push emulation mode (S is only a byte)
 {
 SetSNESByte(SNESAddress(SNES_Registers.S),Byte);
 SNES_Registers.S.SNESPointer.Offset.B.L--;
 }

void E0_SNES_Push_W(unsigned short Word)
 {
 SNES_Registers.S.SNESPointer.Offset.W--;
 SetSNESWord(SNESAddress(SNES_Registers.S),Word);
 SNES_Registers.S.SNESPointer.Offset.W--;
 }

void E1_SNES_Push_W(unsigned short Word)
 {
 SNES_Registers.S.SNESPointer.Offset.B.L--;
 SetSNESWord(SNESAddress(SNES_Registers.S),Word);
 SNES_Registers.S.SNESPointer.Offset.B.L--;
 }

unsigned char E0_SNES_Pull_B()
 {
 SNES_Registers.S.SNESPointer.Offset.W++;
 return GetSNESByte(SNESAddress(SNES_Registers.S));
 }

unsigned char E1_SNES_Pull_B()
 {
 SNES_Registers.S.SNESPointer.Offset.B.L++;
 return GetSNESByte(SNESAddress(SNES_Registers.S));
 }

unsigned short E0_SNES_Pull_W()
 {
 unsigned short Temp;
 SNES_Registers.S.SNESPointer.Offset.W++;
 Temp=GetSNESWord(SNESAddress(SNES_Registers.S));
 SNES_Registers.S.SNESPointer.Offset.W++;
 return Temp;
 }

unsigned short E1_SNES_Pull_W()
 {
 unsigned short Temp;
 SNES_Registers.S.SNESPointer.Offset.B.L++;
 Temp=GetSNESWord(SNESAddress(SNES_Registers.S));
 SNES_Registers.S.SNESPointer.Offset.B.L++;
 return Temp;
 }

void ALL_NOP()        // No Operation
 {
 // DO NOTHING!
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

/*extern "C"
 {
 void ALL_NOP();
 }*/

void ALL_SEI()	// Set Interrupt Disable Bit
 {
 SET_FLAG(SNES_FLAG_I);
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void E0_PHK()	// Push PB (non emulation)
 {
 E0_SNES_Push_B(SNES_Registers.PC.SNESPointer.Bank);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void E1_PHK()	// Push PB (emulation)
 {
 E1_SNES_Push_B(SNES_Registers.PC.SNESPointer.Bank);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void E0_PLB()	// Pop DB (non emulation)
 {
 SNES_Registers.D.SNESPointer.Bank=E0_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.D.SNESPointer.Bank==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);	// Can assume this
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.D.SNESPointer.Bank>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E1_PLB()	// Pop DB (emulation)
 {
 SNES_Registers.D.SNESPointer.Bank=E1_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.D.SNESPointer.Bank==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);	// Can assume this
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.D.SNESPointer.Bank>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_CLC()	// Clear Carry Bit
 {
 CLR_FLAG(SNES_FLAG_C);
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void ALL_XCE()	// Exchange carry with emulation bit
 {
 int Temp=TEST_FLAG(SNES_FLAG_E);

 if (TEST_FLAG(SNES_FLAG_C))
  {
  SET_FLAG(SNES_FLAG_E);
  SET_FLAG(SNES_FLAG_M);	// Emulation mode settings
  SET_FLAG(SNES_FLAG_X);
  SNES_Registers.X.B.H=0;
  SNES_Registers.Y.B.H=0;
  SNES_Registers.S.SNESPointer.Offset.B.H=1;
  CurTable=E1OpTable;		// Needs setting since we are going into emulation mode
  }
 else
  {
  CLR_FLAG(SNES_FLAG_E);
  if (TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
   CurTable=MXOpTable;		// non emulation x & m set
  else
   if (!TEST_FLAG(SNES_FLAG_M) && !TEST_FLAG(SNES_FLAG_X))
    CurTable=E0OpTable;		// non emulation x & m clear
   else
    if (!TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
     CurTable=PxOpTable;	// non emulation x set m clear
    else
     CurTable=PmOpTable;	// non emulation x clear m set
  }

 if (Temp)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void E0_REP_i()		// Reset Flags Specified in immediate Byte (dont mask M & X)
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

// M&X can be changed so the jump table pointer may need to be reset

 if (TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
  CurTable=MXOpTable;		// non emulation x & m set
 else
  if (!TEST_FLAG(SNES_FLAG_M) && !TEST_FLAG(SNES_FLAG_X))
   CurTable=E0OpTable;		// non emulation x & m clear
  else
   if (!TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
    CurTable=PxOpTable;	// non emulation x set m clear
   else
    CurTable=PmOpTable;	// non emulation x clear m set

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void E1_REP_i()		// Reset Flags Specified in immediate Byte (mask M & X emulation mode)
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

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void EM_LDA_i()	// Put Imediate Byte into A (emulation or 8 bit M)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L=GetSNESByte(Immediate());

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDA_i()	// Put Imediate Word into A (non emulation & 16 bit M)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W=GetSNESWord(Immediate());

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_TCD()	// Transfer A into D
 {
 SNES_Registers.D.SNESPointer.Offset.W=SNES_Registers.A.W;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_STZ_d()	// Zero direct Offset (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(Direct(),0);
 SNES_Cycles+=3;
 }

void E0_STZ_d()	// Zero direct offset (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(Direct(),0);
 SNES_Cycles+=4;
 }

void E0_JSR_a()	// Jump to absolute subroutine (push pc on stack)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 E0_SNES_Push_W(SNES_Registers.PC.SNESPointer.Offset.W+2);

 SNES_Registers.PC.PCPointer=(unsigned char *)((unsigned long)Absolute()-(unsigned long)RomAddress);
 SNES_Cycles+=6;
 }

void E1_JSR_a()	// Jump to absolute subroutine (push pc on stack)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 E1_SNES_Push_W(SNES_Registers.PC.SNESPointer.Offset.W+2);

 SNES_Registers.PC.PCPointer=(unsigned char *)((unsigned long)Absolute()-(unsigned long)RomAddress);
 SNES_Cycles+=6;
 }

void E0_SEP_i()	// Set flags Specified in immediate byte (dont mask m & x)
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

// M&X can be changed so the jump table pointer may need to be reset

 if (TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
  CurTable=MXOpTable;		// non emulation x & m set
 else
  if (!TEST_FLAG(SNES_FLAG_M) && !TEST_FLAG(SNES_FLAG_X))
   CurTable=E0OpTable;		// non emulation x & m clear
  else
   if (!TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
    CurTable=PxOpTable;	// non emulation x set m clear
   else
    CurTable=PmOpTable;	// non emulation x clear m set

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void E1_SEP_i()	// Set flags Specified in immediate byte (mask m & x)
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

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void EM_STA_a()	// Put A at absolute address (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(Absolute(),SNES_Registers.A.B.L);
 SNES_Cycles+=3;
 }

void E0_STA_a()	// Put A at absolute address (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(Absolute(),SNES_Registers.A.W);
 SNES_Cycles+=4;
 }

void EM_STZ_a()	// Zero Absolute Address (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(Absolute(),0);
 SNES_Cycles+=3;
 }

void E0_STZ_a()	// Zero Absolute Address (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(Absolute(),0);
 SNES_Cycles+=4;
 }

void E0_RTS()	// Return from subroutine.
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.PC.SNESPointer.Offset.W=E0_SNES_Pull_W();
 SNES_Cycles+=6;
 }

void E1_RTS()	// Return from subroutine.
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.PC.SNESPointer.Offset.W=E1_SNES_Pull_W();
 SNES_Cycles+=6;
 }

void EX_LDX_i()	// Put immediate into X (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.X.B.L=GetSNESByte(Immediate());

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.X.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDX_i()	// Put immediate into X (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.X.W=GetSNESWord(Immediate());

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 if (SNES_Registers.X.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_STX_a()	// Put X at absolute address (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(Absolute(),SNES_Registers.X.B.L);
 SNES_Cycles+=4;
 }

void E0_STX_a()	// Put X at absolute address (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(Absolute(),SNES_Registers.X.W);
 SNES_Cycles+=5;
 }

void EM_STA_d()	// Put A at direct address (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(Direct(),SNES_Registers.A.B.L);
 SNES_Cycles+=3;
 }

void E0_STA_d()	// Put A at direct address (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(Direct(),SNES_Registers.A.W);
 SNES_Cycles+=4;
 }

void E0_PHA()	// Push Accumulator onto stack (no emulation)
 {
 E0_SNES_Push_W(SNES_Registers.A.W);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 }

void EM_PHA()	// Push Accumulator onto stack (m is 8 bit)
 {
 E0_SNES_Push_B(SNES_Registers.A.B.L);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void E1_PHA()	// Push Accumulator onto stack (emulation mode)
 {
 E1_SNES_Push_B(SNES_Registers.A.B.L);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void EM_LDA_d()	// Put direct address into A (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L=GetSNESByte(Direct());

 SNES_Cycles+=3;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDA_d()	// Put direct address into A (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W=GetSNESWord(Absolute());

 SNES_Cycles+=4;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_INA()	// Increment A (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L++;
 SNES_Cycles+=2;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_INA()	// Increment A (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W++;
 SNES_Cycles+=2;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_LDA_a()	// Put absolute address into A (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L=GetSNESByte(Absolute());

 SNES_Cycles+=4;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDA_a()	// Put absolute address into A (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W=GetSNESWord(Absolute());

 SNES_Cycles+=5;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_BPL()	// Branch if N==0 PC+r
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (!TEST_FLAG(SNES_FLAG_N))
  {
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
  SNES_Cycles+=3;
  return;
  }
 SNES_Cycles+=2;
 }

void E0_PLA()	// Pop Accumulator (no emulation)
 {
 SNES_Registers.A.W=E0_SNES_Pull_W();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=5;
 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_PLA()	// Pop Accumulator (m is 8 bit)
 {
 SNES_Registers.A.B.L=E0_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E1_PLA()	// Pop Accumulator (emulation mode)
 {
 SNES_Registers.A.B.L=E1_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_CMP_d()	// compare direct (8 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Direct());

 if (SNES_Registers.A.B.L<Temp.B.L)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.B.L=SNES_Registers.A.B.L-Temp.B.L;	// do subtraction

 SNES_Cycles+=4;

 if (Temp.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_CMP_d()	// compare direct (16 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESByte(Direct());

 if (SNES_Registers.A.W<Temp.W)		// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.W=SNES_Registers.A.W-Temp.W;	// do subtraction

 SNES_Cycles+=5;

 if (Temp.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_BNE()	// Branch if Z=0
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (!TEST_FLAG(SNES_FLAG_Z))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void EX_DEX()	// Decrement X (8 bit)
 {
 SNES_Registers.X.B.L--;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.X.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_DEX()	// Decrement X (16 bit)
 {
 SNES_Registers.X.W--;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.X.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_DEA()	// Decrement A (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L--;
 SNES_Cycles+=2;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_DEA()	// Decrement A (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W--;
 SNES_Cycles+=2;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_CLI()	// Clear Interrupt Disable
 {
 CLR_FLAG(SNES_FLAG_I);
 SNES_Cycles+=2;			// Instruction Takes 2 Clock Ticks
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

int InterruptDone=(1==0);	// This is read by the next instruction

void ALL_WAI()	// Wait For Interrupt
 {
 SNES_Cycles+=3;
 if (InterruptDone)
  {
  SNES_Registers.PC.SNESPointer.Offset.W++;
  InterruptDone=(1==0);		// Reset Interrupt status (This may need to be reset elsewhere)
  }
 }

void EM_BIT_i()	//Bit test immediate (8 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Immediate());

 Temp.B.L&=SNES_Registers.A.B.L;	// Do And
  
 if (Temp.B.L==0)
  SET_FLAG(SNES_FLAG_Z);
 else
  CLR_FLAG(SNES_FLAG_Z);

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void E0_BIT_i()	//Bit test immediate (16 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Immediate());

 Temp.W&=SNES_Registers.A.W;

 if (Temp.W==0)
  SET_FLAG(SNES_FLAG_Z);
 else 
  CLR_FLAG(SNES_FLAG_Z);  

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W+=2;
 }

void ALL_BEQ()	// Branch if Z=1
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (TEST_FLAG(SNES_FLAG_Z))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void ALL_BRA()	// Branch always
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

unsigned char SetupFlags()		// Helper Function
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

 return Temp;
 }

void E0_PHP()	// Push Flags onto stack (no emulation)
 {
 E0_SNES_Push_B(SetupFlags());

 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void E1_PHP()	// Push Flags onto stack (emulation)
 {
 E1_SNES_Push_B(SetupFlags());

 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void E0_PHX()	// Push X onto stack (no emulation)
 {
 E0_SNES_Push_W(SNES_Registers.X.W);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 }

void EX_PHX()	// Push X onto stack (x is 8 bit)
 {
 E0_SNES_Push_B(SNES_Registers.X.B.L);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void E1_PHX()	// Push X onto stack (emulation mode)
 {
 E1_SNES_Push_B(SNES_Registers.X.B.L);
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=3;
 }

void EM_INC_d()	// Increment direct offset (byte)
 {
 unsigned char *Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp=Direct();			// Get address to increment
 (*Temp)++;
 SNES_Cycles+=5;

 if (*Temp==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (*Temp>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_INC_d()	// Increment direct offset (word)
 {
 unsigned short *Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp=(unsigned short *)Direct();
 (*Temp)++;
 SNES_Cycles+=6;

 if (*Temp==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (*Temp>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }


void EM_DEC_d()	// Decrement direct offset (byte)
 {
 unsigned char *Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp=Direct();			// Get address to increment
 (*Temp)--;
 SNES_Cycles+=5;

 if (*Temp==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (*Temp>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_DEC_d()	// Decrement direct offset (word)
 {
 unsigned short *Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp=(unsigned short *)Direct();
 (*Temp)--;
 SNES_Cycles+=6;

 if (*Temp==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (*Temp>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_AND_i()	// AND A with immediate (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L&=GetSNESByte(Immediate());

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z); 
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_AND_i()	// AND A with immediate (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W&=GetSNESWord(Immediate());

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_LDX_a()	// Put absolute into X (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.X.B.L=GetSNESByte(Absolute());

 SNES_Cycles+=2;

 if (SNES_Registers.X.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDX_a()	// Put absolute into X (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.X.W=GetSNESWord(Absolute());

 SNES_Cycles+=3;

 if (SNES_Registers.X.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_STX_d()	// Put X at direct address (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(Direct(),SNES_Registers.X.B.L);
 SNES_Cycles+=3;
 }

void E0_STX_d()	// Put X at direct address (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(Direct(),SNES_Registers.X.W);
 SNES_Cycles+=4;
 }

void E0_PLX()	// Pop X (no emulation)
 {
 SNES_Registers.X.W=E0_SNES_Pull_W();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=5;
 if (SNES_Registers.X.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_PLX()	// Pop X (x is 8 bit)
 {
 SNES_Registers.X.B.L=E0_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.X.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E1_PLX()	// Pop X (emulation mode)
 {
 SNES_Registers.X.B.L=E1_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.X.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void Pull_Flags(unsigned char Temp)	// Helper, puts flags back from a temp stack value
 {
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
 }
 
void E0_PLP()	// Pull Flags from stack (no emulation)
 {
 Pull_Flags(E0_SNES_Pull_B());

// M&X can be changed so the jump table pointer may need to be reset

 if (TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
  CurTable=MXOpTable;		// non emulation x & m set
 else
  if (!TEST_FLAG(SNES_FLAG_M) && !TEST_FLAG(SNES_FLAG_X))
   CurTable=E0OpTable;		// non emulation x & m clear
  else
   if (!TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
    CurTable=PxOpTable;	// non emulation x set m clear
   else
    CurTable=PmOpTable;	// non emulation x clear m set

 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 }

void E1_PLP()	// Pull Flags from stack (emulation)
 {
 Pull_Flags(E1_SNES_Pull_B());

 SET_FLAG(SNES_FLAG_X);	// ensure emulation bits set
 SET_FLAG(SNES_FLAG_M);

 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 }

void E0_RTI()	// Return from interrupt (no emulation)
 {
 Pull_Flags(E0_SNES_Pull_B());
 SNES_Registers.PC.SNESPointer.Offset.B.L=E0_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.B.H=E0_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Bank=E0_SNES_Pull_B();

// M&X can be changed so the jump table pointer may need to be reset

 if (TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
  CurTable=MXOpTable;		// non emulation x & m set
 else
  if (!TEST_FLAG(SNES_FLAG_M) && !TEST_FLAG(SNES_FLAG_X))
   CurTable=E0OpTable;		// non emulation x & m clear
  else
   if (!TEST_FLAG(SNES_FLAG_M) && TEST_FLAG(SNES_FLAG_X))
    CurTable=PxOpTable;	// non emulation x set m clear
   else
    CurTable=PmOpTable;	// non emulation x clear m set

 SNES_Cycles+=7;
 }

void E1_RTI()	// Return from interrupt (emulation)
 {
 Pull_Flags(E1_SNES_Pull_B());
 SNES_Registers.PC.SNESPointer.Offset.B.L=E1_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.B.H=E1_SNES_Pull_B();

 SET_FLAG(SNES_FLAG_X);	// ensure emulation bits set
 SET_FLAG(SNES_FLAG_M);

 SNES_Cycles+=6;
 }

void EX_INX()	// Increment X (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.X.B.L++;
 SNES_Cycles+=2;

 if (SNES_Registers.X.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_INX()	// Increment X (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.X.W++;
 SNES_Cycles+=2;

 if (SNES_Registers.X.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_CPX_i()	// compare X (8 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Immediate());

 if (SNES_Registers.X.B.L<Temp.B.L)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.B.L=SNES_Registers.X.B.L-Temp.B.L;	// do subtraction

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (Temp.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_CPX_i()	// compare direct (16 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Immediate());

 if (SNES_Registers.X.W<Temp.W)		// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.W=SNES_Registers.X.W-Temp.W;	// do subtraction

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 if (Temp.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_LDA_a_x()	// Put absolute index x (Byte) into A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L=GetSNESByte(AbsoluteX());

 SNES_Cycles+=2;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDA_a_x()	// Put absolute index x (word) into A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W=GetSNESWord(AbsoluteX());

 SNES_Cycles+=3;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_JMP_a()	// Jump to absolute address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.PC.PCPointer=(unsigned char *)((unsigned long)Absolute()-(unsigned long)RomAddress);

 SNES_Cycles+=3;
 }

void ALL_JMP_al()	// Jump to absolute address long
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.PC.PCPointer=(unsigned char *)((unsigned long)AbsoluteLong()-(unsigned long)RomAddress);

 SNES_Cycles+=3;
 }

void E1_TCS()	// Transfer A into S (emulation mode)
 {
 SNES_Registers.S.SNESPointer.Offset.B.L=SNES_Registers.A.B.L;
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void E0_TCS()	// Transfer A into S (no emulation)
 {
 SNES_Registers.S.SNESPointer.Offset.W=SNES_Registers.A.W;
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void EM_STA_al()	// Put A at Absolute Address Long (Byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(AbsoluteLong(),SNES_Registers.A.B.L);
 SNES_Cycles+=4;
 }

void E0_STA_al()	// Put A at Absolute Address Long (Word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(AbsoluteLong(),SNES_Registers.A.W);
 SNES_Cycles+=6;
 }

void EX_LDY_i()	// Put immediate into Y (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.Y.B.L=GetSNESByte(Immediate());

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.Y.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDY_i()	// Put immediate into Y (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.Y.W=GetSNESWord(Immediate());

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 if (SNES_Registers.Y.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_STA_al_x()	// Store A into absolute long + X (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SetSNESByte(AbsoluteLongX(),SNES_Registers.A.B.L);
 SNES_Cycles+=4;
 }

void E0_STA_al_x()	// Store A into absolute long + X (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SetSNESWord(AbsoluteLongX(),SNES_Registers.A.W);
 SNES_Cycles+=6;
 }

void EM_TYA()	// Transfer Y To A (byte)
 {
 SNES_Registers.A.B.L=SNES_Registers.Y.B.L;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_TYA()	// Transfer Y to A (word)
 {
 SNES_Registers.A.W=SNES_Registers.Y.W;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_SEC()	// Set Carry Flag
 {
 SET_FLAG(SNES_FLAG_C);
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;
 }

void EM_SBC_i()	// Sub with carry immediate from A (byte)
 {
 Reg_16 Temp;
 int Sign,Sign2,Carry;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Immediate());

 if (TEST_FLAG(SNES_FLAG_C))
  Carry=1;
 else
  Carry=0;

 if (SNES_Registers.A.B.L<(Temp.B.L+Carry))	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Sign=(SNES_Registers.A.B.L&0x80)==0x80;		// Check for bit set
 SNES_Registers.A.B.L=SNES_Registers.A.B.L-(Temp.B.L+Carry);	// do subtraction
 Sign2=(SNES_Registers.A.B.L&0x80)==0x80;		// Check for bit set

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (Sign==Sign2)	// No Overflow
  CLR_FLAG(SNES_FLAG_V);
 else
  SET_FLAG(SNES_FLAG_V);

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_SBC_i()	// Sub with carry immediate from A (word)
 {
 Reg_16 Temp;
 int Sign,Sign2,Carry;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Immediate());

 if (TEST_FLAG(SNES_FLAG_C))
  Carry=1;
 else
  Carry=0;

 if (SNES_Registers.A.W<(Temp.W+Carry))	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Sign=(SNES_Registers.A.W&0x8000)==0x8000;		// Check for bit set
 SNES_Registers.A.W=SNES_Registers.A.W-(Temp.W+Carry);	// do subtraction
 Sign2=(SNES_Registers.A.W&0x8000)==0x8000;		// Check for bit set

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 if (Sign==Sign2)	// No Overflow
  CLR_FLAG(SNES_FLAG_V);
 else
  SET_FLAG(SNES_FLAG_V);

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_TAY()	// Transfer A To Y (byte)
 {
 SNES_Registers.Y.B.L=SNES_Registers.A.B.L;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.Y.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_TAY()	// Transfer A To Y (word)
 {
 SNES_Registers.Y.W=SNES_Registers.A.W;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.Y.W==0)
  { 
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_CMP_a()	// compare absolute (8 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Absolute());

 if (SNES_Registers.A.B.L<Temp.B.L)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.B.L=SNES_Registers.A.B.L-Temp.B.L;	// do subtraction

 SNES_Cycles+=4;

 if (Temp.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_CMP_a()	// compare absolute (16 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Absolute());

 if (SNES_Registers.A.W<Temp.W)		// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.W=SNES_Registers.A.W-Temp.W;	// do subtraction

 SNES_Cycles+=5;

 if (Temp.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_LDA_IdI_y()	// LDA [d],y - B7 (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L=GetSNESByte(DirectInderectIndexedLongY());

 SNES_Cycles+=6;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDA_IdI_y()	// LDA [d],y - B7 (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W=GetSNESWord(DirectInderectIndexedLongY());

 SNES_Cycles+=7;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_INY()	// Increment Y (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.Y.B.L++;
 SNES_Cycles+=2;

 if (SNES_Registers.Y.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_INY()	// Increment Y (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.Y.W++;
 SNES_Cycles+=2;

 if (SNES_Registers.Y.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_TAX()	// Transfer A To X (byte)
 {
 SNES_Registers.X.B.L=SNES_Registers.A.B.L;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.X.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_TAX()	// Transfer A To X (word)
 {
 SNES_Registers.X.W=SNES_Registers.A.W;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.X.W==0)
  { 
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.X.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_ROL_A()		// Rol Accumulator (byte)
 {
 int Carry; 

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 Carry=TEST_FLAG(SNES_FLAG_C);
 if ((SNES_Registers.A.B.L&0x80)==0x80)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 SNES_Registers.A.B.L=SNES_Registers.A.B.L<<1;	// 0 is put in lsb (in c++)
 if (Carry)
  SNES_Registers.A.B.L|=0x01;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 } 

void E0_ROL_A()		// Rol Accumulator (word)
 {
 int Carry; 

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 Carry=TEST_FLAG(SNES_FLAG_C);
 if ((SNES_Registers.A.W&0x8000)==0x8000)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 SNES_Registers.A.W=SNES_Registers.A.W<<1;	// 0 is put in lsb (in c++)
 if (Carry)
  SNES_Registers.A.W|=0x01;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 } 

void EM_ADC_i()	// Add with carry immediate to A (byte)
 {
 Reg_16 Temp;
 int Sign,Sign2,Carry;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Immediate());

 if (TEST_FLAG(SNES_FLAG_C))
  Carry=1;
 else
  Carry=0;

 if ((long)(SNES_Registers.A.B.L+Temp.B.L+Carry)>255)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Sign=(SNES_Registers.A.B.L&0x80)==0x80;		// Check for bit set
 SNES_Registers.A.B.L=SNES_Registers.A.B.L+Temp.B.L+Carry;	// do addition
 Sign2=(SNES_Registers.A.B.L&0x80)==0x80;		// Check for bit set

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (Sign==Sign2)	// No Overflow
  CLR_FLAG(SNES_FLAG_V);
 else
  SET_FLAG(SNES_FLAG_V);

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_ADC_i()	// Add with carry immediate to A (word)
 {
 Reg_16 Temp;
 int Sign,Sign2,Carry;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Immediate());

 if (TEST_FLAG(SNES_FLAG_C))
  Carry=1;
 else
  Carry=0;

 if ((long)(SNES_Registers.A.W+Temp.W+Carry)>65535)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Sign=(SNES_Registers.A.W&0x8000)==0x8000;		// Check for bit set
 SNES_Registers.A.W=SNES_Registers.A.W+Temp.W+Carry;	// do addition
 Sign2=(SNES_Registers.A.W&0x8000)==0x8000;		// Check for bit set

 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 if (Sign==Sign2)	// No Overflow
  CLR_FLAG(SNES_FLAG_V);
 else
  SET_FLAG(SNES_FLAG_V);

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_BVS()	// Branch if V=1
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (TEST_FLAG(SNES_FLAG_V))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void EM_STZ_d_x()	// Zero direct Offset + X (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(DirectIndexX(),0);
 SNES_Cycles+=4;
 }

void E0_STZ_d_x()	// Zero direct offset + x (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(DirectIndexX(),0);
 SNES_Cycles+=5;
 }

void EM_STZ_a_x()	// Zero absolute Offset + X (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(AbsoluteX(),0);
 SNES_Cycles+=5;
 }

void E0_STZ_a_x()	// Zero absolute offset + x (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(AbsoluteX(),0);
 SNES_Cycles+=6;
 }

void EM_STA_a_x()	// Store A into absolute + X (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SetSNESByte(AbsoluteX(),SNES_Registers.A.B.L);
 SNES_Cycles+=5;
 }

void E0_STA_a_x()	// Store A into absolute + X (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SetSNESWord(AbsoluteX(),SNES_Registers.A.W);
 SNES_Cycles+=6;
 }

void E0_JSL_al()	// Jump to absolute long subroutine (push pc on stack)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 E0_SNES_Push_B(SNES_Registers.PC.SNESPointer.Bank);
 E0_SNES_Push_W(SNES_Registers.PC.SNESPointer.Offset.W+3);

 SNES_Registers.PC.PCPointer=(unsigned char *)((unsigned long)AbsoluteLong()-(unsigned long)RomAddress);
 SNES_Cycles+=8;
 }

void E1_JSL_al()	// Jump to absolute long subroutine (push pc on stack)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 E1_SNES_Push_B(SNES_Registers.PC.SNESPointer.Bank);
 E1_SNES_Push_W(SNES_Registers.PC.SNESPointer.Offset.W+3);

 SNES_Registers.PC.PCPointer=(unsigned char *)((unsigned long)AbsoluteLong()-(unsigned long)RomAddress);
 SNES_Cycles+=8;
 }

void EX_STY_d()	// Put Y at direct address (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(Direct(),SNES_Registers.Y.B.L);
 SNES_Cycles+=3;
 }

void E0_STY_d()	// Put Y at direct address (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(Direct(),SNES_Registers.Y.W);
 SNES_Cycles+=4;
 }

void E0_PLY()	// Pop Y (no emulation)
 {
 SNES_Registers.Y.W=E0_SNES_Pull_W();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=5;
 if (SNES_Registers.Y.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EX_PLY()	// Pop Y (x is 8 bit)
 {
 SNES_Registers.Y.B.L=E0_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.Y.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E1_PLY()	// Pop Y (emulation mode)
 {
 SNES_Registers.Y.B.L=E1_SNES_Pull_B();
 SNES_Registers.PC.SNESPointer.Offset.W++;
 SNES_Cycles+=4;
 if (SNES_Registers.Y.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_ASL_A()		// Shift left Accumulator (byte)
 {
 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if ((SNES_Registers.A.B.L&0x80)==0x80)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 SNES_Registers.A.B.L=SNES_Registers.A.B.L<<1;	// 0 is put in lsb (in c++)

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 } 

void E0_ASL_A()		// Shift left Accumulator (word)
 {
 SNES_Cycles+=3;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if ((SNES_Registers.A.W&0x8000)==0x8000)
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 SNES_Registers.A.W=SNES_Registers.A.W<<1;	// 0 is put in lsb (in c++)

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 } 

void EX_LDY_d()	// Put direct into Y (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.Y.B.L=GetSNESByte(Direct());

 SNES_Cycles+=3;

 if (SNES_Registers.Y.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDY_d()	// Put direct into Y (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.Y.W=GetSNESWord(Direct());

 SNES_Cycles+=4;

 if (SNES_Registers.Y.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.Y.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_JML_ai()	// Jump to absolute indirect address
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.PC.PCPointer=(unsigned char *)((unsigned long)AbsoluteIndirectJML()-(unsigned long)RomAddress);

 SNES_Cycles+=6;
 }

void EX_STY_a()	// Put Y at absolute address (byte)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESByte(Absolute(),SNES_Registers.Y.B.L);
 SNES_Cycles+=4;
 }

void E0_STY_a()	// Put Y at absolute address (word)
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SetSNESWord(Absolute(),SNES_Registers.Y.W);
 SNES_Cycles+=5;
 }

void E0_RTL()	// Return from subroutine long
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.PC.SNESPointer.Offset.W=E0_SNES_Pull_W();
 SNES_Registers.PC.SNESPointer.Bank=E0_SNES_Pull_B();
 SNES_Cycles+=6;
 }

void E1_RTL()	// Return from subroutine long
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.PC.SNESPointer.Offset.W=E1_SNES_Pull_W();
 SNES_Registers.PC.SNESPointer.Bank=E1_SNES_Pull_B();
 SNES_Cycles+=6;
 }

void EM_TSB_d()	// Test and Set Bit direct (byte)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 unsigned char *AddressT=Direct();

 Temp.B.L=GetSNESByte(AddressT)|SNES_Registers.A.B.L;

 SetSNESByte(AddressT,Temp.B.L);

 SNES_Cycles+=5;

 if (Temp.B.L==0)
  SET_FLAG(SNES_FLAG_Z);
 else
  CLR_FLAG(SNES_FLAG_Z);
 }

void E0_TSB_d()	// Test and Set Bit direct (word)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 unsigned char *AddressT=Direct();

 Temp.W=GetSNESWord(AddressT)|SNES_Registers.A.W;

 SetSNESWord(AddressT,Temp.W);

 SNES_Cycles+=6;

 if (Temp.W==0)
  SET_FLAG(SNES_FLAG_Z);
 else
  CLR_FLAG(SNES_FLAG_Z);
 }

void EM_CMP_i()	// compare immediate (8 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Immediate());

 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.A.B.L<Temp.B.L)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.B.L=SNES_Registers.A.B.L-Temp.B.L;	// do subtraction

 SNES_Cycles+=4;

 if (Temp.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_CMP_i()	// compare immediate (16 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Immediate());

 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 if (SNES_Registers.A.W<Temp.W)		// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.W=SNES_Registers.A.W-Temp.W;	// do subtraction

 SNES_Cycles+=5;

 if (Temp.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_ADC_a()	// Add with carry absolute to A (byte)
 {
 Reg_16 Temp;
 int Sign,Sign2,Carry;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Absolute());

 if (TEST_FLAG(SNES_FLAG_C))
  Carry=1;
 else
  Carry=0;

 if ((long)(SNES_Registers.A.B.L+Temp.B.L+Carry)>255)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Sign=(SNES_Registers.A.B.L&0x80)==0x80;		// Check for bit set
 SNES_Registers.A.B.L=SNES_Registers.A.B.L+Temp.B.L+Carry;	// do addition
 Sign2=(SNES_Registers.A.B.L&0x80)==0x80;		// Check for bit set

 SNES_Cycles+=4;

 if (Sign==Sign2)	// No Overflow
  CLR_FLAG(SNES_FLAG_V);
 else
  SET_FLAG(SNES_FLAG_V);

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_ADC_a()	// Add with carry absolute to A (word)
 {
 Reg_16 Temp;
 int Sign,Sign2,Carry;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Absolute());

 if (TEST_FLAG(SNES_FLAG_C))
  Carry=1;
 else
  Carry=0;

 if ((long)(SNES_Registers.A.W+Temp.W+Carry)>65535)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Sign=(SNES_Registers.A.W&0x8000)==0x8000;		// Check for bit set
 SNES_Registers.A.W=SNES_Registers.A.W+Temp.W+Carry;	// do addition
 Sign2=(SNES_Registers.A.W&0x8000)==0x8000;		// Check for bit set

 SNES_Cycles+=5;

 if (Sign==Sign2)	// No Overflow
  CLR_FLAG(SNES_FLAG_V);
 else
  SET_FLAG(SNES_FLAG_V);

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void ALL_BCC()	// Branch if C=0
 {
 signed char Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;
 Temp=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;
 if (!TEST_FLAG(SNES_FLAG_C))
  SNES_Registers.PC.SNESPointer.Offset.W+=Temp;
 SNES_Cycles+=2;
 }

void EX_CPX_d()	// compare X (8 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Direct());

 if (SNES_Registers.X.B.L<Temp.B.L)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.B.L=SNES_Registers.X.B.L-Temp.B.L;	// do subtraction

 SNES_Cycles+=3;

 if (Temp.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_CPX_d()	// compare direct (16 bit)
 {
 Reg_16 Temp;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Direct());

 if (SNES_Registers.X.W<Temp.W)		// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Temp.W=SNES_Registers.X.W-Temp.W;	// do subtraction

 SNES_Cycles+=3;

 if (Temp.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (Temp.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_TXA()	// Transfer X To A (byte)
 {
 SNES_Registers.A.B.L=SNES_Registers.X.B.L;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_TXA()	// Transfer X to A (word)
 {
 SNES_Registers.A.W=SNES_Registers.X.W;

 SNES_Cycles+=2;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_LDA_al_x()	// Put absolute long index x (Byte) into A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.B.L=GetSNESByte(AbsoluteLongX());

 SNES_Cycles+=5;

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_LDA_al_x()	// Put absolute long index x (word) into A
 {
 SNES_Registers.PC.SNESPointer.Offset.W++;

 SNES_Registers.A.W=GetSNESWord(AbsoluteLongX());

 SNES_Cycles+=6;

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void EM_ADC_d()	// Add with carry direct to A (byte)
 {
 Reg_16 Temp;
 int Sign,Sign2,Carry;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.B.L=GetSNESByte(Direct());

 if (TEST_FLAG(SNES_FLAG_C))
  Carry=1;
 else
  Carry=0;

 if ((long)(SNES_Registers.A.B.L+Temp.B.L+Carry)>255)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Sign=(SNES_Registers.A.B.L&0x80)==0x80;		// Check for bit set
 SNES_Registers.A.B.L=SNES_Registers.A.B.L+Temp.B.L+Carry;	// do addition
 Sign2=(SNES_Registers.A.B.L&0x80)==0x80;		// Check for bit set

 SNES_Cycles+=3;

 if (Sign==Sign2)	// No Overflow
  CLR_FLAG(SNES_FLAG_V);
 else
  SET_FLAG(SNES_FLAG_V);

 if (SNES_Registers.A.B.L==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.B.L>=0x80)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

void E0_ADC_d()	// Add with carry direct to A (word)
 {
 Reg_16 Temp;
 int Sign,Sign2,Carry;

 SNES_Registers.PC.SNESPointer.Offset.W++;

 Temp.W=GetSNESWord(Direct());

 if (TEST_FLAG(SNES_FLAG_C))
  Carry=1;
 else
  Carry=0;

 if ((long)(SNES_Registers.A.W+Temp.W+Carry)>65535)	// Carry occured
  SET_FLAG(SNES_FLAG_C);
 else
  CLR_FLAG(SNES_FLAG_C);

 Sign=(SNES_Registers.A.W&0x8000)==0x8000;		// Check for bit set
 SNES_Registers.A.W=SNES_Registers.A.W+Temp.W+Carry;	// do addition
 Sign2=(SNES_Registers.A.W&0x8000)==0x8000;		// Check for bit set

 SNES_Cycles+=4;

 if (Sign==Sign2)	// No Overflow
  CLR_FLAG(SNES_FLAG_V);
 else
  SET_FLAG(SNES_FLAG_V);

 if (SNES_Registers.A.W==0)
  {
  SET_FLAG(SNES_FLAG_Z);
  CLR_FLAG(SNES_FLAG_N);
  return;
  }
 else
  CLR_FLAG(SNES_FLAG_Z);
 if (SNES_Registers.A.W>=0x8000)
  SET_FLAG(SNES_FLAG_N);
 else
  CLR_FLAG(SNES_FLAG_N);
 }

Reg_16 NMIAddress;		// I dont think this can change (since its stored in ROM!)

void Process_Interrupt()	// Psuedo Operation Bung all stack elements on and change PC
 {
 if (TEST_FLAG(SNES_FLAG_E))	// Is emulation mode set
  {				// 8 bit mode
  E1_SNES_Push_B(SNES_Registers.PC.SNESPointer.Offset.B.H);
  E1_SNES_Push_B(SNES_Registers.PC.SNESPointer.Offset.B.L);
  CLR_FLAG(SNES_FLAG_X);	// Emulation mode set bit 4 to 0 !
  E1_SNES_Push_B(SetupFlags()); // Push flags onto stack
  SNES_Registers.PC.SNESPointer.Bank=0;
  SNES_Registers.PC.SNESPointer.Offset.W=GetSNESWord(0xfffa+RomAddress);	// PC now points at interrupt code!
  }
 else
  {
  E0_SNES_Push_B(SNES_Registers.PC.SNESPointer.Bank);
  E0_SNES_Push_B(SNES_Registers.PC.SNESPointer.Offset.B.H);
  E0_SNES_Push_B(SNES_Registers.PC.SNESPointer.Offset.B.L);
  E0_SNES_Push_B(SetupFlags());
  SNES_Registers.PC.SNESPointer.Bank=0;
  SNES_Registers.PC.SNESPointer.Offset.W=GetSNESWord(0xffea+RomAddress);	// PC now points at interrupt code!
  }
 }

void Reset_CPU(unsigned short Reset)
 {                               // Clears Registers To Reset Values
                                 //and prepares for CPU Emulation

 for (int a=0;a<256;a++)
  {
  E0OpTable[a]=InvalidOpcode;	// Set All Opcodes To Unsupported
  PmOpTable[a]=InvalidOpcode;
  PxOpTable[a]=InvalidOpcode;
  MXOpTable[a]=InvalidOpcode;
  E1OpTable[a]=InvalidOpcode;
  }

 E0OpTable[0x04]=PxOpTable[0x04]=E0_TSB_d;
 E1OpTable[0x04]=PmOpTable[0x04]=MXOpTable[0x04]=EM_TSB_d;
 E0OpTable[0x08]=PmOpTable[0x08]=PxOpTable[0x08]=MXOpTable[0x08]=E0_PHP;
 E1OpTable[0x08]=E1_PHP;
 E0OpTable[0x0a]=PxOpTable[0x0a]=E0_ASL_A;
 E1OpTable[0x0a]=PmOpTable[0x0a]=MXOpTable[0x0a]=EM_ASL_A;
 E0OpTable[0x10]=PmOpTable[0x10]=PxOpTable[0x10]=MXOpTable[0x10]=E1OpTable[0x10]=ALL_BPL;
 E0OpTable[0x18]=PmOpTable[0x18]=PxOpTable[0x18]=MXOpTable[0x18]=E1OpTable[0x18]=ALL_CLC;
 E0OpTable[0x1a]=PxOpTable[0x1a]=E0_INA;
 E1OpTable[0x1a]=PmOpTable[0x1a]=MXOpTable[0x1a]=EM_INA;
 E0OpTable[0x1b]=PmOpTable[0x1b]=PxOpTable[0x1b]=MXOpTable[0x1b]=E0_TCS;
 E1OpTable[0x1b]=E1_TCS;
 E0OpTable[0x20]=PmOpTable[0x20]=PxOpTable[0x20]=MXOpTable[0x20]=E0_JSR_a;
 E1OpTable[0x20]=E1_JSR_a;
 E0OpTable[0x22]=PmOpTable[0x22]=PxOpTable[0x22]=MXOpTable[0x22]=E0_JSL_al;
 E1OpTable[0x22]=E1_JSL_al;
 E0OpTable[0x28]=PmOpTable[0x28]=PxOpTable[0x28]=MXOpTable[0x28]=E0_PLP;
 E1OpTable[0x28]=E1_PLP;
 E0OpTable[0x29]=PxOpTable[0x29]=E0_AND_i;
 E1OpTable[0x29]=PmOpTable[0x29]=MXOpTable[0x29]=EM_AND_i;
 E0OpTable[0x2a]=PxOpTable[0x2a]=E0_ROL_A;
 E1OpTable[0x2a]=PmOpTable[0x2a]=MXOpTable[0x2a]=EM_ROL_A;
 E0OpTable[0x38]=PmOpTable[0x38]=PxOpTable[0x38]=MXOpTable[0x38]=E1OpTable[0x38]=ALL_SEC;
 E0OpTable[0x3a]=PxOpTable[0x3a]=E0_DEA;
 E1OpTable[0x3a]=PmOpTable[0x3a]=MXOpTable[0x3a]=EM_DEA;
 E0OpTable[0x40]=PmOpTable[0x40]=PxOpTable[0x40]=MXOpTable[0x40]=E0_RTI;
 E1OpTable[0x40]=E1_RTI;
 E0OpTable[0x48]=PxOpTable[0x48]=E0_PHA;
 PmOpTable[0x48]=MXOpTable[0x48]=EM_PHA;
 E1OpTable[0x48]=E1_PHA;
 E0OpTable[0x4b]=PmOpTable[0x4b]=PxOpTable[0x4b]=MXOpTable[0x4b]=E0_PHK;
 E1OpTable[0x4b]=E1_PHK;
 E0OpTable[0x4c]=PmOpTable[0x4c]=PxOpTable[0x4c]=MXOpTable[0x4c]=E1OpTable[0x4c]=ALL_JMP_a;
 E0OpTable[0x58]=PmOpTable[0x58]=PxOpTable[0x58]=MXOpTable[0x58]=E1OpTable[0x58]=ALL_CLI;
 E0OpTable[0x5b]=PmOpTable[0x5b]=PxOpTable[0x5b]=MXOpTable[0x5b]=E1OpTable[0x5b]=ALL_TCD;
 E0OpTable[0x5c]=PmOpTable[0x5c]=PxOpTable[0x5c]=MXOpTable[0x5c]=E1OpTable[0x5c]=ALL_JMP_al;
 E0OpTable[0x60]=PmOpTable[0x60]=PxOpTable[0x60]=MXOpTable[0x60]=E0_RTS;
 E1OpTable[0x60]=E1_RTS;
 E0OpTable[0x64]=PxOpTable[0x64]=E0_STZ_d;
 E1OpTable[0x64]=PmOpTable[0x64]=MXOpTable[0x64]=EM_STZ_d;
 E0OpTable[0x65]=PxOpTable[0x65]=E0_ADC_d;
 E1OpTable[0x65]=PmOpTable[0x65]=MXOpTable[0x65]=EM_ADC_d;
 E0OpTable[0x68]=PxOpTable[0x68]=E0_PLA;
 PmOpTable[0x68]=MXOpTable[0x68]=EM_PLA;
 E1OpTable[0x68]=E1_PLA;
 E0OpTable[0x69]=PxOpTable[0x69]=E0_ADC_i;
 E1OpTable[0x69]=PmOpTable[0x69]=MXOpTable[0x69]=EM_ADC_i;
 E0OpTable[0x6b]=PmOpTable[0x6b]=PxOpTable[0x6b]=MXOpTable[0x6b]=E0_RTL;
 E1OpTable[0x6b]=E1_RTL;
 E0OpTable[0x6d]=PxOpTable[0x6d]=E0_ADC_a;
 E1OpTable[0x6d]=PmOpTable[0x6d]=MXOpTable[0x6d]=EM_ADC_a;
 E0OpTable[0x70]=PmOpTable[0x70]=PxOpTable[0x70]=MXOpTable[0x70]=E1OpTable[0x70]=ALL_BVS;
 E0OpTable[0x74]=PxOpTable[0x74]=E0_STZ_d_x;
 E1OpTable[0x74]=PmOpTable[0x74]=MXOpTable[0x74]=EM_STZ_d_x;
 E0OpTable[0x78]=PmOpTable[0x78]=PxOpTable[0x78]=MXOpTable[0x78]=E1OpTable[0x78]=ALL_SEI;
 E0OpTable[0x7a]=PmOpTable[0x7a]=E0_PLY;
 PxOpTable[0x7a]=MXOpTable[0x7a]=EX_PLY;
 E1OpTable[0x7a]=E1_PLY;
 E0OpTable[0x80]=PmOpTable[0x80]=PxOpTable[0x80]=MXOpTable[0x80]=E1OpTable[0x80]=ALL_BRA;
 E0OpTable[0x84]=PmOpTable[0x84]=E0_STY_d;
 E1OpTable[0x84]=PxOpTable[0x84]=MXOpTable[0x84]=EX_STY_d;
 E0OpTable[0x85]=PxOpTable[0x85]=E0_STA_d;
 E1OpTable[0x85]=PmOpTable[0x85]=MXOpTable[0x85]=EM_STA_d;
 E0OpTable[0x86]=PmOpTable[0x86]=E0_STX_d;
 E1OpTable[0x86]=PxOpTable[0x86]=MXOpTable[0x86]=EX_STX_d;
 E0OpTable[0x89]=PxOpTable[0x89]=E0_BIT_i;
 E1OpTable[0x89]=PmOpTable[0x89]=MXOpTable[0x89]=EM_BIT_i;
 E0OpTable[0x8a]=PxOpTable[0x8a]=E0_TXA;
 E1OpTable[0x8a]=PmOpTable[0x8a]=MXOpTable[0x8a]=EM_TXA;
 E0OpTable[0x8c]=PmOpTable[0x8c]=E0_STY_a;
 E1OpTable[0x8c]=PxOpTable[0x8c]=MXOpTable[0x8c]=EX_STY_a;
 E0OpTable[0x8d]=PxOpTable[0x8d]=E0_STA_a;
 E1OpTable[0x8d]=PmOpTable[0x8d]=MXOpTable[0x8d]=EM_STA_a;
 E0OpTable[0x8e]=PmOpTable[0x8e]=E0_STX_a;
 E1OpTable[0x8e]=PxOpTable[0x8e]=MXOpTable[0x8e]=EX_STX_a;
 E0OpTable[0x8f]=PxOpTable[0x8f]=E0_STA_al;
 E1OpTable[0x8f]=PmOpTable[0x8f]=MXOpTable[0x8f]=EM_STA_al;
 E0OpTable[0x90]=PmOpTable[0x90]=PxOpTable[0x90]=MXOpTable[0x90]=E1OpTable[0x90]=ALL_BCC;
 E0OpTable[0x98]=PxOpTable[0x98]=E0_TYA;
 E1OpTable[0x98]=PmOpTable[0x98]=MXOpTable[0x98]=EM_TYA;
 E0OpTable[0x9c]=PxOpTable[0x9c]=E0_STZ_a;
 E1OpTable[0x9c]=PmOpTable[0x9c]=MXOpTable[0x9c]=EM_STZ_a;
 E0OpTable[0x9d]=PxOpTable[0x9d]=E0_STA_a_x;
 E1OpTable[0x9d]=PmOpTable[0x9d]=MXOpTable[0x9d]=EM_STA_a_x;
 E0OpTable[0x9e]=PxOpTable[0x9e]=E0_STZ_a_x;
 E1OpTable[0x9e]=PmOpTable[0x9e]=MXOpTable[0x9e]=EM_STZ_a_x;
 E0OpTable[0x9f]=PxOpTable[0x9f]=E0_STA_al_x;
 E1OpTable[0x9f]=PmOpTable[0x9f]=MXOpTable[0x9f]=EM_STA_al_x;
 E0OpTable[0xa0]=PmOpTable[0xa0]=E0_LDY_i;
 E1OpTable[0xa0]=PxOpTable[0xa0]=MXOpTable[0xa0]=EX_LDY_i;
 E0OpTable[0xa2]=PmOpTable[0xa2]=E0_LDX_i;
 E1OpTable[0xa2]=PxOpTable[0xa2]=MXOpTable[0xa2]=EX_LDX_i;
 E0OpTable[0xa4]=PmOpTable[0xa4]=E0_LDY_d;
 E1OpTable[0xa4]=PxOpTable[0xa4]=MXOpTable[0xa4]=EX_LDY_d;
 E0OpTable[0xa5]=PxOpTable[0xa5]=E0_LDA_d;
 E1OpTable[0xa5]=PmOpTable[0xa5]=MXOpTable[0xa5]=EM_LDA_d;
 E0OpTable[0xa8]=PmOpTable[0xa8]=E0_TAY;
 E1OpTable[0xa8]=PxOpTable[0xa8]=MXOpTable[0xa8]=EX_TAY;
 E0OpTable[0xa9]=PxOpTable[0xa9]=E0_LDA_i;
 E1OpTable[0xa9]=PmOpTable[0xa9]=MXOpTable[0xa9]=EM_LDA_i;
 E0OpTable[0xaa]=PmOpTable[0xaa]=E0_TAX;
 E1OpTable[0xaa]=PxOpTable[0xaa]=MXOpTable[0xaa]=EX_TAX;
 E0OpTable[0xab]=PmOpTable[0xab]=PxOpTable[0xab]=MXOpTable[0xab]=E0_PLB;
 E1OpTable[0xab]=E1_PLB;
 E0OpTable[0xad]=PxOpTable[0xad]=E0_LDA_a;
 E1OpTable[0xad]=PmOpTable[0xad]=MXOpTable[0xad]=EM_LDA_a;
 E0OpTable[0xae]=PmOpTable[0xae]=E0_LDX_a;
 E1OpTable[0xae]=PxOpTable[0xae]=MXOpTable[0xae]=EX_LDX_a;
 E0OpTable[0xb7]=PxOpTable[0xb7]=E0_LDA_IdI_y;
 E1OpTable[0xb7]=PmOpTable[0xb7]=MXOpTable[0xb7]=EM_LDA_IdI_y;
 E0OpTable[0xbd]=PxOpTable[0xbd]=E0_LDA_a_x;
 E1OpTable[0xbd]=PmOpTable[0xbd]=MXOpTable[0xbd]=EM_LDA_a_x;
 E0OpTable[0xbf]=PxOpTable[0xbf]=E0_LDA_al_x;
 E1OpTable[0xbf]=PmOpTable[0xbf]=MXOpTable[0xbf]=EM_LDA_al_x;
 E0OpTable[0xc2]=PmOpTable[0xc2]=PxOpTable[0xc2]=MXOpTable[0xc2]=E0_REP_i;
 E1OpTable[0xc2]=E1_REP_i;
 E0OpTable[0xc5]=PxOpTable[0xc5]=E0_CMP_d;
 E1OpTable[0xc5]=PmOpTable[0xc5]=MXOpTable[0xc5]=EM_CMP_d;
 E0OpTable[0xc6]=PxOpTable[0xc6]=E0_DEC_d;
 E1OpTable[0xc6]=PmOpTable[0xc6]=MXOpTable[0xc6]=EM_DEC_d;
 E0OpTable[0xc8]=PmOpTable[0xc8]=E0_INY;
 E1OpTable[0xc8]=PxOpTable[0xc8]=MXOpTable[0xc8]=EX_INY;
 E0OpTable[0xc9]=PxOpTable[0xc9]=E0_CMP_i;
 E1OpTable[0xc9]=PmOpTable[0xc9]=MXOpTable[0xc9]=EM_CMP_i;
 E0OpTable[0xca]=PmOpTable[0xca]=E0_DEX;
 E1OpTable[0xca]=PxOpTable[0xca]=MXOpTable[0xca]=EX_DEX;
 E0OpTable[0xcb]=PmOpTable[0xcb]=PxOpTable[0xcb]=MXOpTable[0xcb]=E1OpTable[0xcb]=ALL_WAI;
 E0OpTable[0xcd]=PxOpTable[0xcd]=E0_CMP_a;
 E1OpTable[0xcd]=PmOpTable[0xcd]=MXOpTable[0xcd]=EM_CMP_a;
 E0OpTable[0xd0]=PmOpTable[0xd0]=PxOpTable[0xd0]=MXOpTable[0xd0]=E1OpTable[0xd0]=ALL_BNE;
 E0OpTable[0xda]=PmOpTable[0xda]=E0_PHX;
 PxOpTable[0xda]=MXOpTable[0xda]=EX_PHX;
 E1OpTable[0xda]=E1_PHX;
 E0OpTable[0xdc]=PmOpTable[0xdc]=PxOpTable[0xdc]=MXOpTable[0xdc]=E1OpTable[0xdc]=ALL_JML_ai;
 E0OpTable[0xe0]=PmOpTable[0xe0]=E0_CPX_i;
 E1OpTable[0xe0]=PxOpTable[0xe0]=MXOpTable[0xe0]=EX_CPX_i;
 E0OpTable[0xe2]=PmOpTable[0xe2]=PxOpTable[0xe2]=MXOpTable[0xe2]=E0_SEP_i;
 E1OpTable[0xe2]=E1_SEP_i;
 E0OpTable[0xe4]=PmOpTable[0xe4]=E0_CPX_d;
 E1OpTable[0xe4]=PxOpTable[0xe4]=MXOpTable[0xe4]=EX_CPX_d;
 E0OpTable[0xe6]=PxOpTable[0xe6]=E0_INC_d;
 E1OpTable[0xe6]=PmOpTable[0xe6]=MXOpTable[0xe6]=EM_INC_d;
 E0OpTable[0xe8]=PmOpTable[0xe8]=E0_INX;
 E1OpTable[0xe8]=PxOpTable[0xe8]=MXOpTable[0xe8]=EX_INX;
 E0OpTable[0xe9]=PxOpTable[0xe9]=E0_SBC_i;
 E1OpTable[0xe9]=PmOpTable[0xe9]=MXOpTable[0xe9]=EM_SBC_i;
 E0OpTable[0xea]=PmOpTable[0xea]=PxOpTable[0xea]=MXOpTable[0xea]=E1OpTable[0xea]=ALL_NOP;
 E0OpTable[0xf0]=PmOpTable[0xf0]=PxOpTable[0xf0]=MXOpTable[0xf0]=E1OpTable[0xf0]=ALL_BEQ;
 E0OpTable[0xfa]=PmOpTable[0xfa]=E0_PLX;
 PxOpTable[0xfa]=MXOpTable[0xfa]=EX_PLX;
 E1OpTable[0xfa]=E1_PLX;
 E0OpTable[0xfb]=PmOpTable[0xfb]=PxOpTable[0xfb]=MXOpTable[0xfb]=E1OpTable[0xfb]=ALL_XCE;

 CurTable=E1OpTable;

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
// NMIAddress.W=NMI;
 }

void Do_CPU()		// This executes the next instruction in the
 {					//ROM/RAM where-ever!
 unsigned char OpCode=GetSNESByte_Unmapped(SNESAddress(SNES_Registers.PC));

 CurTable[OpCode]();
 }
