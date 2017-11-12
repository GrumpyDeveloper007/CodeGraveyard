/*
   65816 CPU Include File - By Savoury SnaX

  Notes - I have decided to alter the flags to map as bits directly to the PC flags
         where possible. The following shows this :

               PC FLAGS - ??|??|??|??|OV|??|??|??|SI|ZE|??|??|??|??|??|CF
             SNES FLAGS -            |V |  |1 |E |N |Z |B |D |I |X |M |C

		  This is annoyingly fidly but allows the flags to be copied
		 when needed by simplying masking the required bits then
		 anding!

*/

struct _8Bit_Reg
 {
 unsigned char L;		// Low 8 Bits Of Register
 unsigned char H;		// High 8 Bits Of Register
 };

union Reg_16
 {
 unsigned short W;		// Word (16 Bit) Value
 _8Bit_Reg B;			// Byte (2*8 Bit) Value
 };

struct SNES_Pointer
 {
 Reg_16 Offset;			// Offset in bank
 unsigned char Bank;	// Bank Number Of Instruction
 unsigned char BlankME;	// Dummy Place Holder (Always 0)
 };

union SNES2PC_Pointer	// Used to find page addresses quicker.
 {
 SNES_Pointer SNESPointer;	// Pointer in SNES Bank Style
 unsigned char *PCPointer;	// Pointer in PC Style
 };

struct SNES_RegisterSetTYPE
 {
 Reg_16 A;				// Accumulator
 SNES2PC_Pointer D;		// Data Bank & Direct Register
 Reg_16 X,Y;			// Index Registers (X,Y)
 unsigned short Flags;	// SNES FLAGS see note at top
 SNES2PC_Pointer PC;	// Program Bank & Program Counter
 SNES2PC_Pointer S;		// Stack Pointer + Bank=0 always
 };

extern unsigned long SNES_Cycles;
extern SNES_RegisterSetTYPE SNES_Registers;

void Reset_CPU(unsigned short);
void Do_CPU();

#define SNES_FLAG_C (0x0001)
#define SNES_FLAG_M (0x0002)
#define SNES_FLAG_X (0x0004)
#define SNES_FLAG_I (0x0008)
#define SNES_FLAG_D (0x0010)
#define SNES_FLAG_B (0x0020)
#define SNES_FLAG_Z (0x0040)
#define SNES_FLAG_N (0x0080)
#define SNES_FLAG_E (0x0100)
// 0x0200
// 0x0400
#define SNES_FLAG_V (0x0800)

#define SET_FLAG(x) (SNES_Registers.Flags|=x)
#define CLR_FLAG(x) (SNES_Registers.Flags&=~x)
#define TEST_FLAG(x) ((SNES_Registers.Flags&x)==x) // True=Set

