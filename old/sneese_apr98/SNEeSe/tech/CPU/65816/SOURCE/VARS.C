#include <headr.h>

 char emu;
 unsigned char DBR,PBR,D;
 unsigned short flags;
 struct lohi accu,xreg,yreg;
 unsigned short stack,pcnt;
unsigned short answer;


/* internal registers */
 unsigned short operand;
 unsigned int effective_addr;
 unsigned char opcode;
 unsigned char cpustate;
 int clockticks;

/* help variables */
 unsigned int savepc;
 unsigned char value;
 int sum,saveflags;
 int tbc,tbi;

/* arrays */
 void (*adrmode[256])();
 void (*instruction[258])();
 char ticks[256];
 int stackbase;

