#include <externs.h>
#include <headr.h>
#include <stdio.h>

#include <adrsmode.h>
#include <instr.h>
#include "f:\emulator\includes\memory.h"
#include <utils.h>

void ADC()
{ 	
	readmemory();
	answer+=memory+checkflag(carrybit);
	C=answer;
	checksetflags(answer,carrybit|zerobit|overflowbit|negativebit);
}

void AND65816()
{	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	 { A&=memory;}
		else
	{C&=memory;}
	checksetflags(C,negativebit|zerobit);
}

void ASL()
{	readmemory();	
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{if (checkbit(memory,7)) {setflags(carrybit);}}
		 else
	{if (checkbit(memory,15)) {setflags(carrybit);}}

	memory<<1;
	writememory(effective_addr,memory);
}

void ASLC()
{	if (checkflag(emulationbit) || checkflag(accumodebit))

	{if (checkbit(A,7)) {setflags(carrybit);A<<1;}}
		 else
	{if (checkbit(C,15)) {setflags(carrybit);C<<1;}}
}

void BCC()
{	if  (!checkflag(carrybit)) PC+=effective_addr;
}

void BCS()
{	if (!checkflag(carrybit)) PC+=effective_addr;
}

void BEQ()
{	
	if (!checkflag(zerobit)) PC+=effective_addr;
}

void BIT()
{	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{ answer=A&memory;
	  setflag(overflowbit,checkbit(answer,6));
	  setflag(negativebit,checkbit(answer,7));
	  }
	  else
	 { answer=C&memory;
	   setflag(overflowbit,checkbit(answer,14));
	   setflag(negativebit,checkbit(answer,15));
	  }
}

void BMI()
{    if (checkflag(negativebit))
	{PC+=effective_addr;}
}

void BNE()
{    if  (!checkflag(zerobit))
	{PC+=effective_addr;}
}


void BPL()
{    if  (!checkflag(negativebit))
	{PC+=effective_addr;}
}

void BRA()
{	PC+=effective_addr;
}

void BRK()
{	if (checkflag(emulationbit))
	{	PC=PC+2;
		pushword(PC);
		setflag(breakbit,1);
		push(P);
		PC=getword(0x00fffe);}
		else
	{	push(PBR);
		PC=PC+2;
		pushword(PC);
		push(P);
		setflag(breakbit,0);
		PC=getword(0x00ffe6);
	}
}

void BRL()
{	BRA();
}


void BVC()
{    if  (!checkflag(overflowbit))
	{PC+=effective_addr;}
}

void BVS()
{    if (checkflag(overflowbit))
	{PC+=effective_addr;}
}

void CLC()
{	setflag(carrybit,0);
}

void CLD()
{	setflag(decimalbit,0);
}

void CLI()
{	setflag(interruptbit,0);
}

void CLV()
{	setflag(overflowbit,0);
}

void CMP()
{	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{ answer=A-memory;}
		  else
	 { answer=C-memory;}
	 checksetflags(answer,negativebit|zerobit|carrybit);
}

void CPX()
{	readmemoryindex();
	if (checkflag(emulationbit) || checkflag(indexbit))
	{ answer=XL-memory;}
		  else
	 { answer=X-memory;}
	 checksetflags(answer,negativebit|zerobit|carrybit);
}

void CPY()
{	readmemoryindex();
	if (checkflag(emulationbit) || checkflag(indexbit))
	{ answer=YL-memory;}
		  else
	 { answer=Y-memory;}
	 checksetflags(answer,negativebit|zerobit|carrybit);
}


void DEC()
{	readmemory();
	writememory(effective_addr,--memory);
	checksetflags(memory,negativebit|zerobit);
}

void DECC()
{	C=C-1;
	checksetflags(C,negativebit|zerobit);
}

void DEX()
{	X=X-1;
	checksetflagsindex(X,negativebit|zerobit);
}

void DEY()
{	Y=Y-1;
	checksetflagsindex(Y,negativebit|zerobit);
}

void EOR()
{	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{ answer=A^memory; A=answer;}
		  else
	 { answer=C^memory;C=answer;}
	 checksetflags(answer,negativebit|zerobit);
}

void INC()
{	readmemory();
	writememory(effective_addr,++memory);
	checksetflags(memory,negativebit|zerobit);
}

void INCC()
{	C=C+1;
	checksetflags(C,negativebit|zerobit);
}

void INX()
{	X=X+1;
	checksetflagsindex(X,negativebit|zerobit);
}

void INY()
{	Y=Y+1;
	checksetflagsindex(Y,negativebit|zerobit);
}


void JML()
{	memory=effective_addr;
	PC=memory&0x00ffff;
	PBR=memory>>16;
}

void JMP()
{	if (opcode==0x5C) JML;
		else
	{	memory=effective_addr;
		PC=memory&0x00ffff;
	}
}

void JSL()
{	push(PBR);
	push(PCH);
	push(PCL);
	memory=getword(effective_addr++);
	memory|=getbyte(++effective_addr);
	PC=memory&0x00ffff;
	PBR=memory>>16;
}

void JSR()
{  printf("PC %x PCH->%x",PC,PCH,PCL);
	push(PCH);
	push(PCL);
	PC=effective_addr&0x00ffff;
}

void LDA()
{	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{	A=memory;}
		  else
	 { C=memory;}
	 checksetflags(memory,negativebit|zerobit);
}

void LDX()
{	readmemoryindex();
	X=memory;
	checksetflags(memory,negativebit|zerobit);
}

void LDY()
{	readmemoryindex();
	Y=memory;
	checksetflags(memory,negativebit|zerobit);
}

void LSR()
{ 	readmemory();
	setflag(carrybit,checkbit(memory,0));
  	memory>>1;
  	checksetflags(memory,zerobit);
  	setflag(negativebit,0);
  	writememory(effective_addr,memory);
}

void LSRC()
{ setflag(carrybit,checkbit(C,0));
  if (checkflag(emulationbit) || checkflag(accumodebit)){A>>1;}
  	else
  {C>>1;}
  	checksetflags(C,zerobit);
  	setflag(negativebit,0);
}


  
	
void MVN()
{	unsigned char sourcebank,destbank;
	readmemoryword();

	destbank=(unsigned char)memory&0x00ff;
	sourcebank=(unsigned char)(memory&0xff00)>>8;
	do
	{memory=(sourcebank<<16)|X;
	 putbyte(((destbank<<16)|Y),memory);
	 X=X+1;
	 Y=Y+1;
	 C=C-1;
	 }
	while (C>0);
}

void MVP()
{	unsigned char sourcebank,destbank;
	readmemoryword();
	destbank=(unsigned char)memory&0x00ff;
	sourcebank=(unsigned char)(memory&0xff00)>>8;
	do 
	{memory=(sourcebank<<16)|X;
	 putbyte(((destbank<<16)|Y),memory);
	 X=X-1;
	 Y=Y-1;
	 C=C-1;
	 } while (C>0);
}


void NOP()
{}	 

void ORA()
{ 	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{A|=memory;
		setflag(negativebit,checkbit(A,7));}
		else
	{C|=memory;
		setflag(negativebit,checkbit(C,15));}
		checksetflags(C,zerobit);
}

	
void PEA()
{	readmemoryword();
	pushword(memory);}

void PEI()
{	readmemoryword();
	effective_addr=D+memory;
	memory=getword(effective_addr);
	pushword(memory);
}

void PER()
{  	readmemoryword();
	pushword(PC+memory);
}

void PHA()
{  if (checkflag(emulationbit) || checkflag(accumodebit)){push(A);}
	else
   {pushword(C);}
}

void PHB()
{ push(DBR);}

void PHD()
{ pushword(D);}

void PHK()
{ push(PBR);}

void PHP()
{ push(P);}

void PHX()
{  if (checkflag(emulationbit) || checkflag(indexbit)){push(XL);}
	else
   {pushword(X);}
}

void PHY()
{  if (checkflag(emulationbit) || checkflag(indexbit)){push(YL);}
	else
   {pushword(Y);}
}


void PLA()
{  if (checkflag(emulationbit) || checkflag(accumodebit)){A=pull();}
	else
   {C=pullword();}
}

void PLB()
{ DBR=pull();}

void PLD()
{ D=pullword();}

void PLP()
{ P=pull();}

void PLX()
{  if (checkflag(emulationbit) || checkflag(indexbit)){XL=pull();}
	else
   {X=pullword();}
}

void PLY()
{  if (checkflag(emulationbit) || checkflag(indexbit)){YL=pull();}
	else
   {Y=pullword();}
}

void REP()
{ 	readmemorybyte();
	if (checkflag(emulationbit)) 
	{answer=P&(memory^0xcf);}
		else
	{answer=P&(memory^0xff);}
}

void ROL()
{	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit)) 
		{answer=checkbit(memory,7);
		 setflag(negativebit,checkbit(memory,6));}
		else
		{answer=checkbit(memory,15);
		 setflag(negativebit,checkbit(memory,14));}
	memory<<1;
	setbit(memory,15,answer);
	checksetflags(memory,zerobit);
	writememory(effective_addr,memory);
}

void ROLC()
{	if (checkflag(emulationbit) || checkflag(accumodebit)) 
		{answer=checkbit(A,7);
		 setflag(negativebit,checkbit(A,6));
		 A<<1;}
		else
		{answer=checkbit(C,15);
		 setflag(negativebit,checkbit(C,14));
		 C<<1;}
	setbit(C,0,answer);
	checksetflags(C,zerobit);
}


void ROR()
{	readmemory();
	answer=checkbit(memory,0);
	memory>>1;
	setflag(negativebit,checkflag(carrybit));
	if (checkflag(emulationbit) || checkflag(accumodebit)) 
		{  setbit(memory,7,checkflag(carrybit));
		   }
			else
		{  setbit(memory,15,checkflag(carrybit));}
	setflag(carrybit,answer);
	checksetflags(memory,zerobit);
}

void RORC()
{	answer=checkbit(memory,0);
	if (checkflag(emulationbit) || checkflag(accumodebit)) 
		{A>>1;}
	else
		{C>>1;}
	
	setflag(negativebit,checkflag(carrybit));
	if (checkflag(emulationbit) || checkflag(accumodebit)) 
		{  setbit(A,7,checkflag(carrybit));
		   }
			else
		{  setbit(C,15,checkflag(carrybit));}
	setflag(carrybit,answer);
}

void RTI()
{ P=pull();
  PC=pullword();
  PBR=pull();
 }
 
 void RTL()
 { PC=pullword();
   PBR=pull();
 }
 
 void RTS()
 { PC=pullword();
 }
 
void SBC()
{	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{ answer=A-memory-(checkflag(carrybit));}
		  else
	 { answer=C-memory-(checkflag(carrybit));}
	 checksetflags(answer,negativebit|zerobit|carrybit|overflowbit);
}

void SEC()
{	setflag(carrybit,1);}

void SED()
{	setflag(decimalbit,1);}

void SEI()
{	setflag(interruptbit,1);}

void SEP()
{	readmemorybyte();
	P|=memory;
}

void STA()
{
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{ putbyte(effective_addr,A);}
		  else
	 { putword(effective_addr,C);}
}

void STP()
{	printf("SCREWED: CPU TOLD TO HALT");
}

void STX()
{	if (checkflag(emulationbit) || checkflag(indexbit))
	{ putbyte(effective_addr,XL);}
		  else
	 { putword(effective_addr,X);}
}

void STY()
{	if (checkflag(emulationbit) || checkflag(indexbit))
	{ putbyte(effective_addr,YL);}
		  else
	 { putword(effective_addr,Y);}
}
void STZ()
{
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{ putbyte(effective_addr,0);}
		  else
	 { putword(effective_addr,0);}
}

void TAX()
{ X=C;
	 checksetflagsindex(X,negativebit|zerobit);
}

void TAY()
{	Y=C;
	checksetflagsindex(Y,negativebit|zerobit);
}

void TCD()
{  D=C;
	checksetflagsindex(D,negativebit|zerobit);
}

void TDC()
{  C=D;
	checksetflagsindex(C,negativebit|zerobit);
}

 
 void TCS()
{  S=C;}



void TRB()
{ 	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{memory&=(A^0xff);}
		else
	{memory&=(C^0xffff);}
	checksetflags(memory,zerobit);
	writememory(effective_addr,memory);
}

void TSB()
{ 	readmemory();
	if (checkflag(emulationbit) || checkflag(accumodebit))
	{memory|=A;}
		else
	{memory|=C;}
	checksetflags(memory,zerobit);
	writememory(effective_addr,memory);
}



void TSC()
{  C=S;
	checksetflags(C,negativebit|zerobit);
}

void TSX()
{  X=S;
	checksetflagsindex(X,negativebit|zerobit);
}


void TXA()
{ 	if (checkflag(emulationbit) || checkflag(accumodebit))
	{A=X;}
		else
	{C=X;}
	checksetflags(C,zerobit|negativebit);
}

void TXS()
{  S=X;
}

void TXY()
{  Y=X;
	checksetflagsindex(C,negativebit|zerobit);
}

void TYA()
{ 	if (checkflag(emulationbit) || checkflag(accumodebit))
	{A=Y;}
		else
	{C=Y;}
	checksetflags(C,zerobit|negativebit);
}


void TYX()
{  X=Y;
	checksetflagsindex(C,negativebit|zerobit);
}


void WAI()
{  }

void XBA()
{	unsigned char swap;
	swap=B;
	B=A;
	A=swap;
	checksetflags(A,zerobit|negativebit);
}

void XCE()
{  char emubit;
	emubit=checkflag(emulationbit);
	setflag(emulationbit,checkflag(carrybit));
	setflag(carrybit,emubit);}








 

 

 

 
 	


		 
	
	

	
		
	



