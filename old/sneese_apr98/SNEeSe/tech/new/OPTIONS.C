#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "machine.h"
#include "options.h"

options::options(void)
{
	fname=NULL;
	startAddress=-1;
	cutHeader=0;
	rtiMode=0;
	beginAddress=0;
	endAddress=0xffff;
}
int options::parseCommandLine(int argc,char **argv)
{
	printf("SPC700 Interactive Disassembler v1.0a(c)1994 Jeremy Gordon\n");
	printf("please send bugfixes to jgordon@animator.slip.umd.edu\n");
	printf("use option -h or -help for help.\n");
        for(int count=0;count<(argc-1);count++)
	 if( (strcmp(argv[count+1],"-begin")==0) ||
		  (strcmp(argv[count+1],"-b")==0) ) {
	    count++;
	    beginAddress=(word)hextodec(argv[count+1]);
            if(startAddress<0x10000)
	     printf("starting disassembly at $%d.\n",dectohex(beginAddress,4));
	    else {
	     printf("error: invalid begin address, SPC700 address space exceeded.\n");	 
	     return(1);	 
	    }	
	  }
	 else if( (strcmp(argv[count+1],"-end")==0) ||
		  (strcmp(argv[count+1],"-e")==0) ) {
	    count++;
	    endAddress=(word)hextodec(argv[count+1]);
            if(startAddress<0x10000)
	      printf("ending disassembly at $%d.\n",dectohex(endAddress,4));
            else {
             printf("error: invalid end address, SPC700 address space exceeded.\n");
             return(1);
            }

	  }	
	 else if( (strcmp(argv[count+1],"-cut")==0) ||
		  (strcmp(argv[count+1],"-c")==0) ) {
	    cutHeader=1;
	    printf("cutting 4 byte header\n");
	  }
	 else if( (strcmp(argv[count+1],"-t")==0) ||
	          (strcmp(argv[count+1],"-rti")==0) ) {
	    rtiMode=1;
	    printf("ending disassembly at first rts/rti.\n");
	 }
         else if( (strcmp(argv[count+1],"-h")==0) ||
                  (strcmp(argv[count+1],"-help")==0) ) {
           printf("use:\n\t%s [options] <object file> <load address>\n",argv[0]);
           printf("options are:\n");
	   printf("\t-begin or -b sets start of disassembly\n");
	   printf("\t-end or -e sets end of disassembly\n"); 
	   printf("\t-cut or -c cuts out the 'standard' 4 byte header\n");
	   printf("\t-rti or -t stops disassembly at first rts/rti\n");
           printf("\t-help or -h lists this message\n");
           return(1);
         }
         else if((argv[count+1][0]!='-')&&!fname) {
             fname=new char[strlen(argv[count+1]+1)];
             strcpy(fname,argv[count+1]);
             printf("using object file '%s'.\n",fname);
          }
 	 else {
	   startAddress=hextodec(argv[count+1]); 
	   if(startAddress<0x10000)
	    printf("loading object code at $%s.\n",dectohex(startAddress,4));
	   else {
	    printf("error: invalid load address, SPC700 address space exceeded.\n"); 
	    return(1);
	   }
	   count++;
	  }
	if(!fname) {
	 printf("error: no input file specified.\n");
	 return(1);
	}
	if(startAddress==-1) {
	  startAddress=0;
	  printf("loading object code at default address $%s\n",dectohex(startAddress,4));
	}
        return(0);
}
char *options::getFname(void)
{
	return(fname);
}
word options::getLoadAddress(void)
{
	return(startAddress);
}
word options::getBeginAddress(void)
{
	return(beginAddress);
}
word options::getEndAddress(void)
{
	return(endAddress);
}
int options::isCutHeader(void)
{
	return(cutHeader);
}
int options::isRTI(void)
{
	return(rtiMode);
} 
options::~options(void)
{
	delete fname;
}
