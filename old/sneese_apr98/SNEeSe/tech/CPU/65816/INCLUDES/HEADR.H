/* Macros for convenience */
struct lohi { unsigned char lo;
	      unsigned char hi;};

#define MEM_DEBUG 1

#define C *(unsigned short*)&accu
#define A accu.lo
#define B accu.hi

#define X *(unsigned short *)&xreg
#define XL xreg.lo
#define XH xreg.hi

#define Y *(unsigned short*)&yreg
#define YL yreg.lo
#define YH treg.hi

#define P flags
#define S stack
#define PC pcnt
#define PCH (PC&0x00FF)
#define PCL ((PC&0xFF00)>>8)

#define memory operand
#define carrybit 1
#define zerobit 2
#define interruptbit 4
#define decimalbit 8
#define breakbit 16
#define overflowbit 64
#define negativebit 128
#define accumodebit 32
#define indexbit 16
#define emulationbit 256

#define stackbank 01

