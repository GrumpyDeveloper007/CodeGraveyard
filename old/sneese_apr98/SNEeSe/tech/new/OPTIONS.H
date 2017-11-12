#ifndef __options_
#define __options_

#include "machine.h"

class options {
   public:
	options(void);
	int parseCommandLine(int, char**);
	char *getFname(void);
	word getLoadAddress(void);
	word getBeginAddress(void);
	word getEndAddress(void);
	int isCutHeader(void);
	int isRTI(void);
	~options(void);
   private:
	char *fname;
	int startAddress;
	word endAddress;
	word beginAddress;
	int rtiMode;	
	int cutHeader;
};

#endif

