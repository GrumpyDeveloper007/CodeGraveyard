#include <stdio.h>
#include <string.h>
#include "memory.h"


memory::memory(void)
{
	fp=0;
	size=0;
	base=0;
}
int memory::load(char *fname,int address)
{
	if(!(fp=fopen(fname,"rb"))) {
	  printf("error: can't open file '%s'.\n",fname);
	  return(1);
	}
	base=(word)address;
	fseek(fp,0,2);	
	size=ftell(fp);
	if(size>0xffff) {
	 printf("warning: only first 0xffff bytes read (address space of spc exceeded).\n");
	 size=0xffff;
	}
	buffer=new char[size];
	fseek(fp,0,0);
        if(fread(buffer,size,1,fp)!=1) {
	  printf("error: can't read file '%s'.\n",fname);
	  return(0);
	}
	printf("sucessfully opened file '%s' (%d bytes)\n",fname,size);
	return(0);
}
byte memory::get(word address)
{
	return(buffer[address-base]);
}
word memory::getSize(void)
{
	return(size);
}
word memory::getBase(void)
{
	return(base);
}
memory::~memory(void)
{
	if(fp)
	  fclose(fp);
	if(buffer)
	  delete buffer;
}
