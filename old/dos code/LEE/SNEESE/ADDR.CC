/*

  Addressing mode functions - For SNEeSe

 Code By Savoury SnaX

*/

#include "Romload.h"
#include "mem.h"
#include "CPU.h"	// include CPU defines
#include "addr.h"	// include addressing mode stuff

unsigned char *Immediate()	// get effective address for immediate
 {
 return SNESAddress(SNES_Registers.PC);
 }

unsigned char *Direct()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=SNES_Registers.D.SNESPointer.Offset.W;
 Address.SNESPointer.Offset.W+=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

unsigned char *Absolute()	// get effective address for absolute
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Bank=SNES_Registers.D.SNESPointer.Bank;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2;

 return SNESAddress(Address);
 }

unsigned char *AbsoluteX()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Bank=SNES_Registers.D.SNESPointer.Bank;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2; 
 if (TEST_FLAG(SNES_FLAG_X))
  Address.SNESPointer.Offset.B.L+=SNES_Registers.X.B.L;
 else
  Address.SNESPointer.Offset.W+=SNES_Registers.X.W;

 return SNESAddress(Address);
 }

unsigned char *AbsoluteLong()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2; 
 Address.SNESPointer.Bank=GetSNESByte(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

unsigned char *AbsoluteLongX()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2; 
 Address.SNESPointer.Bank=GetSNESByte(SNESAddress(SNES_Registers.PC));
 if (TEST_FLAG(SNES_FLAG_X))
  Address.SNESPointer.Offset.B.L+=SNES_Registers.X.B.L;
 else
  Address.SNESPointer.Offset.W+=SNES_Registers.X.W;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

unsigned char *DirectInderectIndexedLongY()
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
 if (TEST_FLAG(SNES_FLAG_X))
  Address2.SNESPointer.Offset.B.L+=SNES_Registers.Y.B.L;
 else
  Address2.SNESPointer.Offset.W+=SNES_Registers.Y.W;

 return SNESAddress(Address2);
 }

unsigned char *DirectIndexX()
 {
 SNES2PC_Pointer Address;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=SNES_Registers.D.SNESPointer.Offset.W;
 Address.SNESPointer.Offset.W+=GetSNESByte(SNESAddress(SNES_Registers.PC));
 if (TEST_FLAG(SNES_FLAG_X))
  Address.SNESPointer.Offset.B.L+=SNES_Registers.X.B.L;
 else
  Address.SNESPointer.Offset.W+=SNES_Registers.X.W;
 SNES_Registers.PC.SNESPointer.Offset.W++;

 return SNESAddress(Address);
 }

unsigned char *AbsoluteIndirectJML()	// get effective address for absolute indirect JML ver.
 {
 SNES2PC_Pointer Address,Address2;
 
 Address.PCPointer=0;
 Address.SNESPointer.Offset.W=GetSNESWord(SNESAddress(SNES_Registers.PC));
 SNES_Registers.PC.SNESPointer.Offset.W+=2;
 Address2.PCPointer=0;
 Address2.SNESPointer.Offset.W=GetSNESWord(SNESAddress(Address));
 Address.SNESPointer.Offset.W+=2;
 Address2.SNESPointer.Bank=GetSNESByte(SNESAddress(Address));

 return SNESAddress(Address2);
 }

