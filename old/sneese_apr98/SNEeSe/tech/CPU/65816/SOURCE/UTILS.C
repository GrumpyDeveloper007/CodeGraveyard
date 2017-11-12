#include <externs.h>
#include <headr.h>
#include <math.h>

#include <adrsmode.h>
#include <instr.h>
#include "f:\emulator\includes\memory.h"
#include <utils.h>

/*Turns a Bit of a specified memory location ON/Off*/
/*memory=memlocation,bit=bit to set, out=set to what*/
void setbit(unsigned short memory,unsigned char bit,unsigned char out)
{	if (out) 
		{memory =memory || pow(2,bit);}
	else
		{memory =memory && pow(2,bit);}
}

/*Sets a specified flag*/
void flagset(unsigned char flags)
{	P|=flags;
}
/*Same as above*/
void setflags(unsigned char flags)
{	P|=flags;
}

/*Flips flag on or off(what=to what)*/
void setflag(unsigned char flag,unsigned char what)
{	if (what>=1) {P|=flag;}
		else
	{P&=(flag^0xffff);}
}

void checksetflags(unsigned int check,unsigned char flags)
{	
   if (overflowbit & flags) 
	{ if (checkflag(accumodebit) || checkflag(emulationbit)) 
		{  if (((char)check>127) || ((char)check<-128))  setflag(overflowbit,1); 
			else
		   setflag(carrybit,0);
		}
		
		    	else
		
		 { if (((short)check>32767) || ((short)check<-32768)) setflag(overflowbit,1);
		 	else
		   setflag(overflowbit,0);
		  }
	}
	
	if (negativebit&flags) 
		{if (checkbit(check,7))  setflag(negativebit,1); 
			else
		 setflag(negativebit,0);
		 }
	
	
	if (zerobit&flags) 
	{ 	if (check==0) setflag(negativebit,1);
			else
		setflag(negativebit,0);
	}
	
	if (carrybit & flags) 
	{
		if (checkflag(accumodebit) || checkflag(emulationbit)) 
		{  if (check>255)  setflag(carrybit,1); 
			else
		    setflag(carrybit,0); 
		 }
		    else
		 { if (check>65536) setflag(carrybit,1); 
		 	else
		    setflag(carrybit,0); 
		 }
	}	  
}

void checksetflagsindex(unsigned int check,unsigned char flags)
{	if (overflowbit & flags)
	 {
		if (checkflag(indexbit) || checkflag(emulationbit)) 
		{  if (((char)check>127) || ((char)check<-128))  setflag(overflowbit,1); 
			else
		    setflag(carrybit,0); 
		 }
		    else
		 { if (((short)check>32767) || ((short)check<-32768))  setflag(overflowbit,1); 
		 	else
		    setflag(overflowbit,0);
		 } 
	}
	
	if (negativebit&flags) 
	{
		if (checkbit(check,7))  setflag(negativebit,1); 
			else
		 setflag(negativebit,0); 
	}
	
	if (zerobit&flags) 
	{
		if (check==0)  setflag(negativebit,1); 
			else
		 setflag(negativebit,0); 
	}
	
	if (carrybit & flags) 
	{
		if (checkflag(indexbit) || checkflag(emulationbit)) 
		{  if (check>255)  setflag(carrybit,1); 
			else
		    setflag(carrybit,0); 
		 }
		    else
		 { if (check>65536) setflag(carrybit,1); 
		 	else
		   setflag(carrybit,0);
		 }
	}
}

int checkflag(unsigned char flag)
{	if (flag&P) {return(1);}
		else
	return(0);
}


int checkbit(unsigned short number, unsigned char bit)
{	if (pow(2,bit)&&number) {return(1);}
		else
	{return(0);}
}



		
void readmemory()
{ if (checkflag(accumodebit) || checkflag(emulationbit)) 
		{ memory=getbyte(effective_addr);}
			else
		{memory=getword(effective_addr);}
}

void readmemoryindex()
{ if (checkflag(indexbit)) 
		{ memory=getbyte(effective_addr);}
			else
		{memory=getword(effective_addr);}
}

void readmemoryword()
{ 		{memory=getword(effective_addr);}
}

void readmemorybyte()
{ 		{memory=getbyte(effective_addr);}
}



