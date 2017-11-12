#ifndef __SPC700_
#define __SPC700_

#include "machine.h"
#include "memory.h"

class spc700 {
   public:
	spc700(void);
	void scan(memory*,word,word);
	char *getLine(memory*,int);
	int getLinecount(void);
	int inList(word);
	int div(int,int);
	void addLabel(int,char*);
	int isret(memory *,int);
	~spc700(void);
   private:
	word *line;
	char **islabel;
	int linecount,current;
	int addr2line(word);
        char *columnf(memory *,word);
	char *columne(memory *,word);
	char *columnd(memory *,word);
	char *columnc(memory *,word);
	char *columnb(memory *,word);
	char *columna(memory *,word);
        char *column9(memory *,word);
        char *column8(memory *,word);
        char *column7(memory *,word);
	char *column6(memory *,word);
	char *column5(memory *,word); 
	char *column4(memory *,word);
	char *column3(memory *,word);
	char *column2(memory *,word);
	char *column1(memory *,word);
	char *column0(memory *,word);


};

#endif
