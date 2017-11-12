extern char emu;
extern unsigned char DBR,PBR,D;
extern unsigned short flags;
extern struct lohi accu,xreg,yreg;
extern unsigned short stack,pcnt;
extern unsigned short answer;


/* internal registers */
extern unsigned short operand;
extern unsigned int effective_addr;
extern unsigned char opcode;
extern unsigned char cpustate;
extern int clockticks;

/* help variables */
extern unsigned int savepc;
extern unsigned char value;
extern int sum,saveflags;
extern int tbc,tbi;

/* arrays */
extern void (*adrmode[256])();
extern void (*instruction[256])();
extern char ticks[256];
extern int stackbase;

