#include <externs.h>
#include <headr.h>

#include "f:\emulator\includes\memory.h"
#include <utils.h>
#include <adrsmode.h>
#include "stdio.h"

void stackmode()
{}

void stackrelative()
{	operand=effective_addr=getbyte((PBR<<16)|PC++)+S;
	printf("ADDRESS MODE: STACK RELATIVE\n");
	printf("EFFECTIVE ADDRESS %d",effective_addr);
}

void stackrelindindex()
{}
	
void accumulator()
{}


void PCrelative()
{	printf("ADDRESS MODE: PC RELATIVE\n");
	operand=effective_addr=getbyte((PBR<<16)|PC++);
	printf("EFFECTIVE ADDRESS %d",effective_addr);
}


void PCrelativeLONG()
{	operand=effective_addr=getword((PBR<<16)|PC++);
	PC++;
	printf("PC RELATIVE LONG");
	printf("EFFECTIVE ADDRESS %d",effective_addr);
}


/* Adressing modes */
/* Implied */
void implied ()
{
}

/* #Immediate */
void immediate()
{	printf("ADDRESS MODE: Immedite\n");
	effective_addr=(PBR<<16)+(PC);
	if ((checkflag(accumodebit) || checkflag(emulationbit) || opcode==0xC2 || opcode==0xe2))
		{ operand=getbyte(effective_addr);
		PC++;}
			else
		{operand=getword(effective_addr);
		PC=PC+2;}
}

/* ABS PBR*/
void absPBR ()
{	
	operand=effective_addr=getword((PBR<<16)+PC);
	PC=PC+2;
	effective_addr |= PBR<<16;
}

/* ABS DBR*/
void absDBR ()
{
	operand=effective_addr=getword((PBR<<16)+PC);
	PC=PC+2;
	effective_addr |= DBR<<16;
}

/* ABS LONG*/
void absLONG()
{
	effective_addr=getword((PBR<<16)|PC++);
	operand=effective_addr |= getbyte((PBR<<16)|++PC)<<16;
	PC++;
}

/* (ABS) */
void indirect ()
{
	operand=getword((PBR<<16)|PC);
	PC=PC+2;
	effective_addr=getword(operand);
	effective_addr |=PBR<<16;
}

/*(ABS) Long*/
void indirectlong()
{ 
	unsigned short help;

	operand=getword((PBR<<16)|PC);
	PC=PC+2;
	effective_addr=getword(help++);
	effective_addr |=getbyte(++help)<<16;
}

	

/* ABS,X */
void absx ()
{
	operand=effective_addr=getword((PBR<<16)|PC);
	PC=PC+2;
	effective_addr|=DBR<<16;
	effective_addr += X;
}

/* ABS,Y */
void absy ()
{
	operand=effective_addr=getword((PBR<<16)|PC);
	PC+=2;
	effective_addr |=DBR<<16;
	effective_addr += Y;
}

/* ABS,Y */
void absxLONG ()
{
	effective_addr=getword((PBR<<16)|PC);
	PC+=2;
	operand=effective_addr |= (getbyte(PBR<<16)+PC++)<<16;
	effective_addr += X;
}


/* (ABS)Indirect Indexed */
void indirectindexed ()
{
	unsigned short help;

	operand=getword((PBR<<16)|PC);
	PC=PC+2;
	help=operand+X;
	effective_addr=getword(help++);
	effective_addr |=PBR<<16;
}

void direct()
/*Direct*/
{	operand=getbyte((PBR<<16)|PC++);
	effective_addr=operand+D;
		
}

void directX()
/*DirectX*/
{	operand=getbyte((PBR<<16)|PC++);
	effective_addr=operand+D+X;
}

void directY()
/*DirectY*/
{	operand=getbyte((PBR<<16)|PC++);
	effective_addr=operand+D+Y;

}

/*Direct Indirect*/

void directind()
{
	unsigned short help;
	operand=getbyte((PBR<<16)|PC++);
	help=operand+D;
	effective_addr=getword(help++);
	effective_addr |=DBR<<16;
}

/*Direct Indirect LONG*/
void directindLONG()
{
	unsigned short help;
	operand=getbyte((PBR<<16)|PC++);
	help=operand+D;
	effective_addr=getword(help++);
	effective_addr |=getbyte(++help)<<16;
}

/*Direct Indirect INDEXED*/
void directindindex()
{
	unsigned short help;
	operand=getbyte((PBR<<16)|PC++);
	help=operand+D;
	effective_addr=getword(help++);
	effective_addr |=DBR<<16;
	effective_addr+=Y;

}

/*Direct Indirect INDEXED*/
void directindindexLONG()
{
	unsigned short help;
	operand=getbyte((PBR<<16)|PC++);
	help=operand+D;
	effective_addr=getword(help++);
	effective_addr |=getbyte(help++)<<16;
	effective_addr+=Y;

}

/*Direct Indexed Indirect*/
void directindexind()
{
	unsigned short help;
	operand=getbyte((PBR<<16)|PC++);
	help=operand+D+X;
	effective_addr=getword(help++);
	effective_addr |=DBR<<16;
}


/* Branch */
void relative ()
{
	operand=effective_addr=getbyte((PBR<<16)|PC++);
	if (effective_addr & 0x80) effective_addr -= 0x100;
}

void relativeLONG()
{
	operand=effective_addr=getword((PBR<<16)+PC++);
	PC++;
	if (effective_addr & 0x80) effective_addr -= 0x100;
}


