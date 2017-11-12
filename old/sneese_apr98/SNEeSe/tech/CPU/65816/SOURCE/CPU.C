#include <externs.h>
#include <headr.h>

#include "f:\emulator\includes\memory.h"
#include <utils.h>
#include <adrsmode.h>
#include <setup.h>


void INIT_REGISTERS()
{	/*Set Accumulator*/
	C=0;
	/*Set Index Regs.*/
	X=Y=0;
	/*Set Flags*/
	P=0;
	
	/*Set Up Stack WORK ON ME FOR 6502 MODE*/
	stack=0x01FF;
	
	/*Set Up MAIN JSR TO LOOK AT CART DATA*/
	putword(0xFFFC,0x8000);
	/*Set IRQ JUMP*/
	putword(0xFFFE,0x8000);
	
	/*Set Program Counter to the address*/
	PC=getword(0xFFFC);
	
	DBR=0;
	PBR=0;
	/*Set Direct Page*/
	D=0;
}


void INIT_CPU()
{	int x;

	set_adrmodes();
 	set_instructions(); 
	x=INITMEMORY(45);
 	INIT_REGISTERS();
}
