#include <stdlib.h>
#include <stdio.h>
#include <io.h>
#include <dos.h>
// #include <stat.h>
#include <fcntl.h>
#include <externs.h>
#include <headr.h>
#include <string.h>

#include <adrsmode.h>
#include <instr.h>
#include "f:\emulator\includes\memory.h"
#include <utils.h>


int filehandle;

int INITMEMORY(int banks)
{ char pathname[128];
  int it;
  char *memblock;
  unsigned long count;
  int wow;
  
  strcpy(pathname,"\\");
  
    //* Createing File to handle Memory*//
  filehandle = creattemp(pathname,0);
  if (filehandle == -1)
  	{printf("Sorry File Exists, Please Delete SNES.MEM \n");
	return(-1);}
  printf("Memory File Created\n");
  close(filehandle);
  
  filehandle=open(pathname,O_RDWR|O_BINARY);

  //* Zeroing Disk Memory*//
  //*first clear a memory buffer*// 
  printf("Zeroing Memory in %s. PLEASE WAIT\n",pathname);
 memblock = (char *)calloc(2050,sizeof(char));
  
  if (memblock==NULL) {printf("You screwed\n");} 
  //*Next write it to disk*//
  for (count=0;count<32*banks;count++){
  it=write(filehandle,memblock,2048);
  //printf("%d %d %d\n",it,errno,count);
    }
getch();
   free(memblock);
   return 1;}

 
unsigned char getbyte(unsigned int location)
{ unsigned char data;
  lseek(filehandle,location,SEEK_SET);
  read(filehandle,&data,1);
  return(data);
 }


unsigned short getword(unsigned int location)
{ unsigned short data;
  lseek(filehandle,location,SEEK_SET);
  read(filehandle,&data,2);
  return(data);
 }


unsigned long getmemory(long location,unsigned char size)
{ unsigned int data=0;
  lseek(filehandle,location,SEEK_SET);
  read(filehandle,&data,size);
  return(data);
 };

unsigned long putword(unsigned int location,unsigned short data)
{
 lseek(filehandle,location,SEEK_SET);
 write(filehandle,&data,2);
 return 0;
} 

unsigned long putbyte(unsigned int location,unsigned char data)
{
 lseek(filehandle,location,SEEK_SET);
 write(filehandle,&data,1);
 return 0;
}


unsigned long putmemory(unsigned int location,unsigned int data,unsigned char size)
{
  lseek(filehandle,location,SEEK_SET);
  write(filehandle,&data,size);
  return 0;
  }



 void writememory(unsigned int location,unsigned short data)
 {
	if (checkflag(accumodebit) || checkflag(emulationbit))
		{  putbyte(location,data);}
 			else
		{ putword(location,data);}
 }
 
 void push(unsigned char data)
 { printf("PUSHED -> %x \n",data);
	putbyte((stackbank<<16)+S--,data);}
 
 void pushword(unsigned short data)
 {	push(data>>8);
	push(data&0x00ff);

 }

 unsigned char pull()
 { unsigned char thebyte;
	thebyte=getbyte(++S+(stackbank<<16));
	//S++;
	//thebyte=getbyte(++S+(stackbank<<16));
	printf("Pulled ->%x \n",thebyte);
	return(thebyte);
 }

 unsigned short pullword()
 { unsigned int theword;
	theword=pull()+(pull()<<8);
	return(theword);
 }



 
