#include <stdlib.h>
#include <stdio.h>
#include <io.h>
#include <dos.h>
//#include <stat.h>
#include <fcntl.h>
#include <externs.h>
#include <headr.h>
#include <string.h>

#include <cart.h>
#include "f:\emulator\includes\memory.h"
#include <utils.h>



void LOWROM_LOW();

int cart_handle;
extern filehandle;
 void LOWROM_LOAD()
 {	unsigned long error,location,bank;
 	unsigned long count,count2;
 	char *memblock;
 	char it;
  
 	bank=0;
 	location=0x8000;
 
 	printf("LOADING INTO LOROM 0x8000+");
 	
  	/*Advance FilePointer to next block*/
  	lseek(filehandle,location+bank,SEEK_SET);
  	printf("At Location %d",location);
  	 
  	do {	count2=read(cart_handle,&it,1); 
  		if (count2!=0) {error=write(filehandle,&it,1);}
  		if (count2==0)  count2=21;  	
  	      } while (count2!=21);

	close(cart_handle);
     
  }

int LOAD_CART()
{ 	struct CART_HEADER cart_header;
	char *fname;
	unsigned long count,error;
  
  	/*--------FNAME SHOULD BE LOADED FROM THE ARGUMENT LIST--------*/
  	fname="f:\\emulator\\cdi.smc";
  	
  	/*OPEN THE CART FILE RETURN IF ERROR*/
	cart_handle=open(fname,O_RDONLY|O_BINARY);
    	if (cart_handle == -1)
  	{	printf("Sorry File not present\n");
		return(-1);
	}

  /*LOAD THE CARTRIDGE HEADER*/	
  error=read(cart_handle,&cart_header,512);
  printf("Loading Cartridge File\n");
/* Load Cart data into programs memory file*/
  printf("Copying Cartridge %s. PLEASE WAIT\n",fname);
 LOWROM_LOAD();
  }
  



void RUN_CART()
{	int done;
	done = 0;
	
	PC=0x8000;
	PBR=0;
	C=0;
	
	do {
	opcode=getbyte((PBR<<16)+PC++);
	adrmode[opcode]();
	instruction[opcode]();
	printf("\n Opcode :%x  Accumulator:%d  Program Counter:%x \n",opcode,C,PC);
	printf("Index X:%u Index Y:%u Flags:%u Stack Pointer:%u \n",X,Y,P,S);
	printf("PBR ->%x \n",PBR);
	getch();
	
	} while(done==0);
}

	