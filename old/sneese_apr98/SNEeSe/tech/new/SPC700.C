#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include "machine.h"
#include "memory.h"
#include "spc700.h"

#include "quicktable.h"
#include "opcodetable.h"

spc700::spc700(void)
{
	line=0;
	islabel=0;
}
void spc700::scan(memory *obj,word start,word end)
{
	word temp[end-start];
	linecount=0;
	int count=start;
	while(count<end) {
	 temp[linecount]=count;
	 count=count+(int)QUICK_TABLE[obj->get(count)];
	 linecount++;
	}
	if(line)
	  delete(line);
	line=new word[linecount];
	memcpy(line,temp,linecount*2);
	islabel=(char **)malloc(sizeof(char*)*linecount);
	for(count=0;count<linecount;count++)
	  *(islabel+count)=0;
	  
}
int spc700::inList(word value)
{
	for(int count=0;count<linecount;count++) {
	  if(line[count]==value)  
		return(count);
	}
	return(-1);
}
char *spc700::getLine(memory *obj,int linenum)
{
	char temp[255];
	char temp2[255]="";
	char *result=new char[255];
	byte instr;char*freeme;
	current=linenum;
	for(int count=0;count<(int)QUICK_TABLE[obj->get(line[linenum])];count++) {
	  sprintf(temp," %s",freeme=dectohex(obj->get(line[linenum]+count),2));
          strcat(temp2,temp);	
	  if(freeme)
		delete freeme;
	}
	sprintf(result," %s %-10s %11s ",
		dectohex(line[linenum],4),temp2,(*(islabel+linenum)==NULL?"":*(islabel+linenum)));

	instr=obj->get(line[linenum]);
	freeme=0;
	if((instr%16)==0)
          strcat(result,freeme=column0(obj,line[linenum]));
        else if((instr%16)==1)
          strcat(result,freeme=column1(obj,line[linenum]));
        else if((instr%16)==2)
          strcat(result,freeme=column2(obj,line[linenum]));
	else if((instr%16)==3)
          strcat(result,freeme=column3(obj,line[linenum]));
	else if((instr%16)==4)
          strcat(result,freeme=column4(obj,line[linenum]));
	else if((instr%16)==5)
	  strcat(result,freeme=column5(obj,line[linenum]));
        else if((instr%16)==6)
          strcat(result,freeme=column6(obj,line[linenum]));
	else if((instr%16)==7)
	  strcat(result,freeme=column7(obj,line[linenum]));
        else if(((instr%16)==8)||(instr==0x8f))
          strcat(result,freeme=column8(obj,line[linenum]));
	else if((instr%16)==9)
	  strcat(result,freeme=column9(obj,line[linenum]));
        else if((instr%16)==0xa)
          strcat(result,freeme=columna(obj,line[linenum]));
        else if((instr%16)==0xb)
          strcat(result,freeme=columnb(obj,line[linenum]));
        else if((instr%16)==0xc)
          strcat(result,freeme=columnc(obj,line[linenum]));
        else if((instr%16)==0xd)
          strcat(result,freeme=columnd(obj,line[linenum]));
        else if((instr%16)==0xe)
          strcat(result,freeme=columne(obj,line[linenum]));
        else if((instr%16)==0xf)
          strcat(result,freeme=columnf(obj,line[linenum]));
	if(freeme)
	  delete freeme;
	return(result);
}
int spc700::getLinecount(void)
{
	return(linecount);
}
int spc700::isret(memory *obj,int whatline)
{
	if((obj->get(line[whatline])==0x6f)||(obj->get(line[whatline])==0x7f))
	  return(1);
	return(0);
}
char *spc700::column8(memory *obj,word addr)
{
	char *result=new char[255],*freeme=0,*freeme2=0;
	
	if(obj->get(addr)==0xc8)
        sprintf(result,"%-6s X,#$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));  
	else if(obj->get(addr)==0xd8)
        sprintf(result,"%-6s $%s,X",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));  
	else if(obj->get(addr)==0xf8) 
        sprintf(result,"%-6s X,$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));  
	else if(((div(obj->get(addr),16)%2)==0)&&(obj->get(addr)!=0x8f))
	sprintf(result,"%-6s A,#$%s",opcode[obj->get(addr)],
		freeme2=dectohex(obj->get(addr+1),2));	
	else
        sprintf(result,"%-6s $%s,#$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+2),2),
                freeme2=dectohex(obj->get(addr+1),2));  
	if(freeme)
	 delete freeme;
	if(freeme2)
	 delete freeme2;
	return(result);
}
char *spc700::column7(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
	if(obj->get(addr)==0xc7)
	        sprintf(result,"%-6s [$%s+X],A",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));  
	else if(obj->get(addr)==0xd7)
        sprintf(result,"%-6s [$%s]+Y,A",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s A,[$%s+X]",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));  
        else 
        sprintf(result,"%-6s A,[$%s]+Y",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::column9(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        if(obj->get(addr)==0xc9)
                sprintf(result,"%-6s >$%s,X",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),2));  
	else if(obj->get(addr)==0xe9)
                sprintf(result,"%-6s X,!$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),2));
	else if(obj->get(addr)==0xd9)
        sprintf(result,"%-6s $%s+Y,X",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0xf9)
        sprintf(result,"%-6s X,$%s+Y",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s $%s<d>,$%s<S>",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+2),2),
		freeme=dectohex(obj->get(addr+1),2));
        else 
        sprintf(result,"%-6s (X),(Y)",opcode[obj->get(addr)]);
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::column6(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        if(obj->get(addr)==0xc6)
                sprintf(result,"%-6s (X),A",opcode[obj->get(addr)]);
        else if(obj->get(addr)==0xd6)
        sprintf(result,"%-6s !$%s+Y,A",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
        else if(obj->get(addr)==0xf6)
        sprintf(result,"%-6s A,!$%s+Y",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
        else if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s A,(X)",opcode[obj->get(addr)]);
	else
        sprintf(result,"%-6s A,!$%s+X",opcode[obj->get(addr)],
                freeme2=dectohex(((obj->get(addr+2)<<8)&0xff00)+obj->get(addr+1),4));
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::column5(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        if(obj->get(addr)==0xc5)
        sprintf(result,"%-6s !$%s,A",opcode[obj->get(addr)],
		freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
        else if(obj->get(addr)==0xd5)
        sprintf(result,"%-6s !$%s+X,A",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
        else if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s A,!$%s",opcode[obj->get(addr)],
		freeme2=dectohex(((obj->get(addr+2)<<8)&0xff00)+obj->get(addr+1),4));
        else
        sprintf(result,"%-6s A,!$%s+X",opcode[obj->get(addr)],
                freeme2=dectohex(((obj->get(addr+2)<<8)&0xff00)+obj->get(addr+1),4));
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::column4(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        if(obj->get(addr)==0xc4)
        sprintf(result,"%-6s $%s,A",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0xd4)
        sprintf(result,"%-6s $%s+X,A",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s A,$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));
        else
        sprintf(result,"%-6s A,$%s+X",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::column3(memory *obj,word addr)
{
	int  temp;
        char *result=new char[255],*freeme=0,*freeme2=0,*freeme3=0;
        if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s <$%s.%s,$%s",opcode[obj->get(addr)],
	 	freeme3=dectohex(obj->get(addr+1),2),
		freeme=dectohex(div(div(obj->get(addr),16),2),1),
                freeme2=dectohex(addr+3+(char)obj->get(addr+2),4));
        else  {
        temp=addr2line(addr+3+(char)obj->get(addr+1));
        if((temp+1)&&*(islabel+temp))
        sprintf(result,"%-6s <$%s.%s,%s",opcode[obj->get(addr)],
                freeme3=dectohex(obj->get(addr+1),2),
                freeme=dectohex(div(div(obj->get(addr),16),2),1),
                *(islabel+temp));
	else
        sprintf(result,"%-6s <$%s.%s,$%s",opcode[obj->get(addr)],
                freeme3=dectohex(obj->get(addr+1),2),
                freeme=dectohex(div(obj->get(addr)%16-1,2),1),
                freeme2=dectohex(addr+3+(char)obj->get(addr+2),4));
	}
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
	if(freeme3)
	 delete freeme3;
        return(result);
}
char *spc700::column2(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s $%s.$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2),
                freeme=dectohex(div(obj->get(addr)%16,2),1));
        else
        sprintf(result,"%-6s $%s.$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2),
                freeme=dectohex(div(obj->get(addr)%16-1,2),1));
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::column1(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        sprintf(result,"%s.$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr)%16,1));
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::column0(memory *obj,word addr)
{
	int temp;
        char *result=new char[255],*freeme=0,*freeme2=0;
        if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s",opcode[obj->get(addr)]);
        else {
	temp=addr2line(addr+2+(char)obj->get(addr+1));
        if((temp+1)&&*(islabel+temp))
         sprintf(result,"%-6s %s",opcode[obj->get(addr)],*(islabel+temp));
	else
         sprintf(result,"%-6s $%s",opcode[obj->get(addr)],
                freeme2=dectohex(addr+2+(char)obj->get(addr+1),4));
	}
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
int spc700::addr2line(word addr)
{
	int count=0;
	while(count<linecount) {
	 if(line[count]==addr)
	  return(count);
	 count++;
	}
	return(-1);
}
char *spc700::columna(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        if(obj->get(addr)==0xca)
        sprintf(result,"%-6s oops, sorry!",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0xda)
        sprintf(result,"%-6s $%s,YA",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0x3a)
        sprintf(result,"%-6s $%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0x1a)
        sprintf(result,"%-6s $%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0xea)
        sprintf(result,"%-6s oops, sorry!",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0xfa)
        sprintf(result,"%-6s $%s<d>,$%s<S>",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+2),2),
		freeme2=dectohex(obj->get(addr+1),2));
        else if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s oops, sorry!",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));
        else
        sprintf(result,"%-6s YA,$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::columnb(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        if(obj->get(addr)==0xcb)
        sprintf(result,"%-6s $%s,Y",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0xdb)
        sprintf(result,"%-6s $%s+X,Y",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0xeb)
        sprintf(result,"%-6s Y,$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if(obj->get(addr)==0xfb)
        sprintf(result,"%-6s Y,$%s+X",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
        else if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s $%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));
        else
        sprintf(result,"%-6s $%s+X",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::columnc(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        if(obj->get(addr)==0xcc)
        sprintf(result,"%-6s !$%s,Y",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
        else if(obj->get(addr)==0xdc)
        sprintf(result,"%-6s Y",opcode[obj->get(addr)]);
        else if(obj->get(addr)==0xec)
        sprintf(result,"%-6s Y,>$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
        else if(obj->get(addr)==0xfc)
        sprintf(result,"%-6s Y",opcode[obj->get(addr)]);
        else if((div(obj->get(addr),16)%2)==0)
        sprintf(result,"%-6s !$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
        else
        sprintf(result,"%-6s A",opcode[obj->get(addr)]);
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::columnd(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
	switch(obj->get(addr)) {
	  case 0x0d:
             sprintf(result,"%-6s PSW",opcode[obj->get(addr)]);
	     break;	
	  case 0x1d:
	     sprintf(result,"%-6s X",opcode[obj->get(addr)]);
	     break; 
	  case 0x2d:
             sprintf(result,"%-6s A",opcode[obj->get(addr)]);
             break;
          case 0x3d:
             sprintf(result,"%-6s X",opcode[obj->get(addr)]);
             break;
          case 0x4d:
             sprintf(result,"%-6s X",opcode[obj->get(addr)]);
             break;
          case 0x5d:
             sprintf(result,"%-6s X,A",opcode[obj->get(addr)]);
             break;
          case 0x6d:
             sprintf(result,"%-6s Y",opcode[obj->get(addr)]);
             break;
          case 0x7d:
             sprintf(result,"%-6s A,X",opcode[obj->get(addr)]);
             break;
          case 0x8d:
             sprintf(result,"%-6s Y,#$%s",opcode[obj->get(addr)],
			freeme=dectohex(obj->get(addr+1),2));
             break;
          case 0x9d:
             sprintf(result,"%-6s X,SP",opcode[obj->get(addr)]);
             break;
          case 0xad:
             sprintf(result,"%-6s Y,#$%s",opcode[obj->get(addr)],
                        freeme=dectohex(obj->get(addr+1),2));
             break;
          case 0xbd:
             sprintf(result,"%-6s SP,X",opcode[obj->get(addr)]);
             break;
          case 0xcd:
             sprintf(result,"%-6s X,#$%s",opcode[obj->get(addr)],
                        freeme=dectohex(obj->get(addr+1),2));
             break;
	  case 0xdd:
	     sprintf(result,"%-6s A,Y",opcode[obj->get(addr)]);
	     break;	
          case 0xed:
             sprintf(result,"%-6s",opcode[obj->get(addr)]);
             break;
          case 0xfd:
             sprintf(result,"%-6s Y,A",opcode[obj->get(addr)]);
             break;
	  }
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::columne(memory *obj,word addr)
{
        char *result=new char[255],*freeme=0,*freeme2=0;
        switch(obj->get(addr)) {
          case 0x0e:
             sprintf(result,"%-6s !$%s",opcode[obj->get(addr)],
		freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
             break;     
	  case 0x1e:
             sprintf(result,"%-6s X,!$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
             break;     
          case 0x2e:
             sprintf(result,"%-6s $%s,$%s ?",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+2),2),
		freeme2=dectohex(addr+3+(char)obj->get(addr+1),4));
             break;     
          case 0x3e:
             sprintf(result,"%-6s X,$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
             break;     
          case 0x4e:
             sprintf(result,"%-6s !$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
             break;     
	  case 0x5e:
             sprintf(result,"%-6s Y,!$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
             break;
	  case 0x6e:
             sprintf(result,"%-6s $%s,$%s ?",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+2),2),
                freeme2=dectohex(addr+3+(char)obj->get(addr+1),4));
             break;     
	  case 0x7e:
             sprintf(result,"%-6s Y,$%s",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+1),2));
             break;     
	  case 0x8e:
	     sprintf(result,"%-6s PSW",opcode[obj->get(addr)]);
	     break;
	  case 0x9e:
             sprintf(result,"%-6s YA,X",opcode[obj->get(addr)]);
             break;
	  case 0xae:
             sprintf(result,"%-6s A",opcode[obj->get(addr)]);
             break;
          case 0xbe:
             sprintf(result,"%-6s A",opcode[obj->get(addr)]);
             break;
          case 0xce:
             sprintf(result,"%-6s X",opcode[obj->get(addr)]);
             break;
          case 0xde:
             sprintf(result,"%-6s $%s+X,$%s ?",opcode[obj->get(addr)],
                freeme=dectohex(obj->get(addr+2),2),
                freeme2=dectohex(addr+3+(char)obj->get(addr+1),4));
             break;
          case 0xee:
             sprintf(result,"%-6s Y",opcode[obj->get(addr)]);
             break;
          case 0xfe:
             sprintf(result,"%-6s Y,$%s",opcode[obj->get(addr)],
                freeme2=dectohex(addr+2+(char)obj->get(addr+1),4));
             break;
	}
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
char *spc700::columnf(memory *obj,word addr)
{
	int temp;
        char *result=new char[255],*freeme=0,*freeme2=0;
        switch(obj->get(addr)) {
          case 0x0f:
             sprintf(result,"%-6s",opcode[obj->get(addr)]);
	     break;
          case 0x1f:
           temp=addr2line(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00));
           if((temp+1)&&*(islabel+temp))
             sprintf(result,"%-6s [!%s+X]",opcode[obj->get(addr)], *(islabel+temp));
	   else
             sprintf(result,"%-6s [!$%s+X]",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
             break;
	  case 0x2f:
             sprintf(result,"%-6s $%s",opcode[obj->get(addr)],
                freeme2=dectohex(addr+2+(char)obj->get(addr+1),4));
             break;
	  case 0x3f:
           temp=addr2line(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00));
           if((temp+1)&&*(islabel+temp))
             sprintf(result,"%-6s !%s",opcode[obj->get(addr)],*(islabel+temp));
	   else
             sprintf(result,"%-6s !$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
             break;
          case 0x4f:
             sprintf(result,"%-6s $%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1),2));
             break;
          case 0x5f:
           temp=addr2line(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00));
           if((temp+1)&&*(islabel+temp))
             sprintf(result,"%-6s !%s",opcode[obj->get(addr)],*(islabel+temp));
	   else
             sprintf(result,"%-6s !$%s",opcode[obj->get(addr)],
                freeme2=dectohex(obj->get(addr+1)+((obj->get(addr+2)<<8)&0xff00),4));
             break;
          case 0x6f:
             sprintf(result,"%-6s",opcode[obj->get(addr)]);
             break;
          case 0x7f:
             sprintf(result,"%-6s",opcode[obj->get(addr)]);
             break;
          case 0x9f:
             sprintf(result,"%-6s A",opcode[obj->get(addr)]);
             break;
          case 0xaf:
             sprintf(result,"%-6s (X)+,A",opcode[obj->get(addr)]);
             break;
          case 0xbf:
             sprintf(result,"%-6s A,(X)+",opcode[obj->get(addr)]);
             break;
          case 0xcf:
             sprintf(result,"%-6s YA",opcode[obj->get(addr)]);
             break;
          case 0xdf:
             sprintf(result,"%-6s A",opcode[obj->get(addr)]);
             break;
          case 0xef:
             sprintf(result,"%-6s",opcode[obj->get(addr)]);
             break;
          case 0xff:
             sprintf(result,"%-6s",opcode[obj->get(addr)]);
             break;
	}
        if(freeme)
         delete freeme;
        if(freeme2)
         delete freeme2;
        return(result);
}
int spc700::div(int a,int b)
{
	int c;
	c=(a-(a%b))/b;
	return(c);	
}
void spc700::addLabel(int current,char *label)
{
	if(*(islabel+current))
	  delete *(islabel+current);
	*(islabel+current)=new char[strlen(label)+1];
	strcpy(*(islabel+current),label);
}
spc700::~spc700(void)
{
	if(line)
	  delete line;
	if(islabel) {
	  for(int count=0;count<linecount;count++)
	   if(*(islabel+count))
	    delete(*(islabel+count));
	  free(islabel);
	}
}
