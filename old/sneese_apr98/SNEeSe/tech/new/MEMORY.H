#ifndef __MEMORY_
#define __MEMORY_

#include <stdio.h>
#include "machine.h"

class memory {
   public:
	memory(void);
	int load(char *,int);
	byte get(word);
	word getSize(void);
	word getBase(void);
	~memory(void);
   private:
	int size;
	FILE *fp;
	byte *buffer;
	word base;
};

#endif
