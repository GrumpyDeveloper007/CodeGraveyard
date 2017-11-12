// Uncomment next line for old flag manipulation
// #define USE_BTx
// Uncomment next line for old flag testing
// #define USE_BT
/*
 Compile under DJGPP (GNU-AS)
 Written By Savoury SnaX (Not quite sure if I like AT&T)

  NOTE - This must have .S (capital) or the # stuff wont be pre-processed!!!


 CPU INFORMATION:

  EAX,EBX,ECX,EDX,ESI,EDI are used in the cpu core.. however only EAX,ESI,EDI
  are used by the memory mapper. EBX,ECX are used during only a few cpu
  operations too, plenty of scope for optimisations I hope!

          [   A   ] - Accumulator      (_SNES_A)
          [   X   ] - X index          (_SNES_X)
          [   Y   ] - Y index          (_SNES_Y)
          [   S   ] - Stack pointer    (_SNES_S)
          [   D   ] - Direct Address   (_SNES_D)
          [   PC  ] - Program Counter  (_SNES_PC)
  [00 | DB|  00   ] - Data Bank        (SNES_DataBank)
  [00 | PB|  00   ] - Program Bank     (SNES_ProgBank)
          [ Flags ] - Flags Variable   (SNES_Flags)
                ??|??|??|??|OV|??|??|??|SI|ZE|??|??|??|??|??|CF|     PC
				??|??|??|??| V|??|1 |E |N |Z |B |D |I |X |M |C |     SNES


 SPC / CPU INTERLEAVING (since processor run parrallel!)

  CPU Runs at 53600 cycles per VBL interrupt. CPU runs at 2.68Mhz.
  SPC Runs at 2.048Mhz, therefor for every x cycles of CPU, 1 spc cycle must be done!.

	53600 / 2.680 Mhz = num cycles if running at 1.00 Mhz = 20000
	20000 * 2.048 Mhz = num cycles spc does per vbl = 40960
	53600 / 40960 = 1.3 CPU Cycles per SPC Cycle (Awkward!)

   So for now I will execute the spc every 4 CPU cycles, this will be done as follows :

  divide executed cycles by 4 then multiply by 3, then execute spc until 0 or less cycles
 left then return to cpu!

   e.g. if an 8 cycle cpu instruction is executed then :

     8>>2 = 2 + 2<<1 = 6 SPC so loop round until 0 or less cycles left in spc then return.

*/

#include <libc/asmdefs.h>

#include "scankeys.h"

#define SNES_Flags _SNES_F  // Flags Register - See information at top! */
#define SNES_DataBank _SNES_DataBank
#define SNES_ProgBank _SNES_ProgBank
#define _SNES_DB (SNES_DataBank+2)
#define _SNES_PB (SNES_ProgBank+2)
#define IRQTrip _IRQTrip
#define INT_BANK _INT_BANK
#define RESET_VECTOR _RESET_VECTOR

#include "mem.h"

SNES_FLAG_C	=	0	/* These are the bit numbers for bit set/clr operations */
SNES_FLAG_M	=	1
SNES_FLAG_X	=	2
SNES_FLAG_I	=	3
SNES_FLAG_D	=	4
SNES_FLAG_B	=	5
SNES_FLAG_Z	=	6
SNES_FLAG_N	=	7
SNES_FLAG_E	=	8
SNES_FLAG_1	=	9	/* This bit should remain set according to docs */

SNES_FLAG_V	=	11

MASK_FLAG_C	=	0x0001	/* These are the masks for flag bits */
MASK_FLAG_M	=	0x0002
MASK_FLAG_X	=	0x0004
MASK_FLAG_I	=	0x0008
MASK_FLAG_D	=	0x0010
MASK_FLAG_B	=	0x0020
MASK_FLAG_Z	=	0x0040
MASK_FLAG_N	=	0x0080
MASK_FLAG_E	=	0x0100
MASK_FLAG_1	=	0x0200	/* This bit should remain set according to docs */

MASK_FLAG_V	=	0x0800

/* --- Ease up on the finger cramps ;-) */

// All flag macros corrupt flags

#ifdef USE_BTx // Using old BT's?
.macro  SET_FLAG bitnumber
 btsl $\bitnumber,SNES_Flags
.endm

.macro  CLR_FLAG bitnumber
 btrl $\bitnumber,SNES_Flags
.endm

.macro  CPL_FLAG bitnumber
 btcl $\bitnumber,SNES_Flags
.endm

#else // Using simple logic

.macro  SET_FLAG bitnumber
 orl  $(1<<\bitnumber),SNES_Flags
.endm

.macro  CLR_FLAG bitnumber
 andl $(~(1<<\bitnumber)),SNES_Flags
.endm

.macro  CPL_FLAG bitnumber
 xorl $(1<<\bitnumber),SNES_Flags
.endm

#endif

#ifdef USE_BT
.macro TEST_FLAG bitnumber
 btl $\bitnumber,SNES_Flags // Set CARRY=bitnumber
.endm

.macro JUMP_FLAG bitnumber,wheretogo
 btl $\bitnumber,SNES_Flags // Set CARRY=bitnumber
 jc  \wheretogo
.endm

.macro JUMP_NOT_FLAG bitnumber,wheretogo
 btl $\bitnumber,SNES_Flags // Set CARRY=bitnumber
 jnc \wheretogo
.endm

#else
.macro TEST_FLAG bitnumber
 testl $(1<<\bitnumber),SNES_Flags // Set ZERO=!bitnumber
.endm

.macro JUMP_FLAG bitnumber,wheretogo
 testl $(1<<\bitnumber),SNES_Flags // Set ZERO=!bitnumber
 jnz \wheretogo
.endm

.macro JUMP_NOT_FLAG bitnumber,wheretogo
 testl $(1<<\bitnumber),SNES_Flags // Set ZERO=!bitnumber
 jz  \wheretogo
.endm

#endif

.macro	DUPLICATE vartype, amount, data, from=1
.\vartype \data
.if \amount-\from
DUPLICATE \vartype,\amount,\data,"(\from+1)"
.endif
.endm

/* Push / Pop Macros assume eax contains value - corrupt esi,edi */

.macro  E0_PUSH_B       // Non Emulation Push Byte (S_W--)
    movl _SNES_S,%esi   // S only - bank always 0!
    SET_BYTE            // Put value onto stack
    decw %si            // Decrement S
    movl %esi,_SNES_S   // Set stack pointer
.endm

.macro  E1_PUSH_B       // Emulation Push Byte (S_B--)
    movl _SNES_S,%esi   // S only - bank always 0!
    decb _SNES_S        // Decrement S (Byte)
    SET_BYTE            // Put value onto stack
.endm

.macro  E0_POP_B        // Non Emulation Pop Byte (S_W++)
    movl _SNES_S,%esi   // S only - bank always 0!
    incw %si            // Increment S
    movl %esi,_SNES_S   // Set stack pointer
    GET_BYTE            // Get value from stack
.endm

.macro  E1_POP_B        // Emulation Pop Byte (S_B--)
    incb _SNES_S        // Increment S (Byte)
    movl _SNES_S,%esi   // S only - bank always 0!
    GET_BYTE            // Get value from stack
.endm

.macro  E0_PUSH_W       // Non Emulation Push Word (S_W--)
    movl _SNES_S,%esi   // S only - bank always 0!
    xchgb %al,%ah
    SET_BYTE            // Put value onto stack
    decw %si            // Decrement S
    xchgb %al,%ah
    SET_BYTE            // Put value onto stack
    decw %si            // Decrement S
    movl %esi,_SNES_S   // Set stack pointer
.endm

.macro  E1_PUSH_W       // Emulation Push Word (S_B--)
    movl _SNES_S,%esi   // S only - bank always 0!
    xchgb %al,%ah       // Get high byte in al
    SET_BYTE            // Put value onto stack
    decb _SNES_S        // Decrement S (Byte)
    movl _SNES_S,%esi   // S only - bank always 0!
    xchgb %al,%ah       // Now lo byte in al
    SET_BYTE            // Put value onto stack
    decb _SNES_S        // Decrement S (Byte)
.endm

.macro  E0_POP_W        // Non Emulation Pop Word (S_W--)
    movl _SNES_S,%esi   // S only - bank always 0!
    incw %si            // Increment S
    GET_BYTE            // Get value from stack
    movb %al,%ah        // Put lo byte into high
    incw %si            // Increment S
    GET_BYTE            // Get value from stack
    movl %esi,_SNES_S   // Set stack pointer
    xchgb %al,%ah       // swap hi,lo bytes
.endm

.macro  E1_POP_W        // Emulation Pop Word (S_B--)
    incb _SNES_S        // Increment S
    movl _SNES_S,%esi   // S only - bank always 0!
    GET_BYTE            // Get value from stack
    movb %al,%ah        // Put lo byte into high
    incb _SNES_S        // Increment S
    movl _SNES_S,%esi   // S only - bank always 0!
    GET_BYTE            // Get value from stack
    xchgb %al,%ah       // swap hi,lo bytes
.endm

/* Set SNES_FLAGS corrupts eax*/

.macro	STORE_FLAGS flags
	lahf
    andb $(~\flags),SNES_Flags
    andb $(\flags),%ah
    orb %ah,SNES_Flags
.endm

/* Set PC Flags To SNES Flags (only sets required flags all others cleared!) corrupts eax */

.macro	MAKE_FLAGS flags
    movb SNES_Flags,%ah
    andb $\flags,%ah
	sahf
.endm

/* Set PC Flags To SNES Flags (Inverts bit (e.g. C=1 means clear carry)) corrupts eax */

.macro	MAKE_FLAGS_INV flags
    movb SNES_Flags,%ah
    notb %ah
    andb $\flags,%ah
	sahf
.endm

/*
 Set The CurTable Pointer Based on M&X bits, must be last instruction
 Corrupts eax
*/

.macro	SET_TABLE_MX
    addl $4,%esp
    movl SNES_Flags,%eax
    andl $6,%eax    // Mask out M & X flags

	cmpb $0,_SPC_ENABLED
	je 7f

    jmpl CPU_SPC_Return_Table(,%eax,2)
7:  jmpl CPU_Return_Table(,%eax,2)
.endm

/* Set up the flags from PC Flag format to SNES Flag format stored in %al */

.macro  E0_SETUPFLAGS
    xorl %eax,%eax
    movb SNES_Flags,%al
    movb E0_Setup_Flags_Table(%eax),%al
    JUMP_NOT_FLAG SNES_FLAG_V,9f
	orb $0x40,%al
9:
.endm

.macro  E1_SETUPFLAGS
    xorl %eax,%eax
    movb SNES_Flags,%al
    movb E1_Setup_Flags_Table(%eax),%al
    JUMP_NOT_FLAG SNES_FLAG_V,9f
	orb $0x40,%al
9:
.endm

/* Restore the flags from SNES packed byte to PC format in %al */

.macro  E0_RESTOREFLAGS
    xorl %ebx,%ebx
    movb %al,%bl
    movl E0_Restore_Flags_Table(,%ebx,4),%ebx
    movl SNES_Flags,%eax
    andl $(MASK_FLAG_B+MASK_FLAG_E+MASK_FLAG_1),%eax
    orl %ebx,%eax
    movl %eax,SNES_Flags
.endm

.macro  E1_RESTOREFLAGS
    xorl %ebx,%ebx
    movb %al,%bl
    movl E1_Restore_Flags_Table(,%ebx,4),%ebx
    movl SNES_Flags,%eax
    andl $(MASK_FLAG_B+MASK_FLAG_E+MASK_FLAG_1),%eax
    orl %ebx,%eax
    movl %eax,SNES_Flags
.endm

/* The following definition is to allow more than one FUNC() LEAVE decleration */

#define LEAVEL(label) label: POPL_EDI POPL_ESI POPL_EBX movl %ebp,%esp; popl %ebp; ret

.macro TEST_KEY key		/* Jnz indicates key pressed! */
	cmpb $0,_key+\key	/* Is Key Pressed */
.endm

.macro JUMP_KEY_DOWN key,wheretogo
 cmpb $0,_key+\key   // !ZF = key down
 jnz \wheretogo
.endm

.macro JUMP_KEY_UP key,wheretogo
 cmpb $0,_key+\key   // ZF = key up
 jz  \wheretogo
.endm

.data
.balign 16					/* Align to paragraph */

.globl E0OpTable
E0OpTable:
.long   E0_BRK       ,E0_ORA_Od_xO,E0_COP    ,E0_ORA_d_s
.long   E0_TSB_d     ,E0_ORA_d    ,E0_ASL_d  ,E0_ORA_IdI
.long   E0_PHP       ,E0_ORA_i    ,E0_SLA    ,E0_PHD
.long   E0_TSB_a     ,E0_ORA_a    ,E0_ASL_a  ,E0_ORA_al
.long   ALL_BPL      ,E0_ORA_OdO_y,E0_ORA_OdO,E0_ORA_Od_sO_y
.long   E0_TRB_d     ,E0_ORA_d_x  ,E0_ASL_d_x,E0_ORA_IdI_y
.long   ALL_CLC      ,E0_ORA_a_y  ,E0_INA    ,E0_TCS
.long   E0_TRB_a     ,E0_ORA_a_x  ,E0_ASL_a_x,E0_ORA_al_x
.long   E0_JSR_a     ,E0_AND_Od_xO,E0_JSL_al ,E0_AND_d_s
.long   E0_BIT_d     ,E0_AND_d    ,E0_ROL_d  ,E0_AND_IdI
.long   E0_PLP       ,E0_AND_i    ,E0_RLA    ,E0_PLD
.long   E0_BIT_a     ,E0_AND_a    ,E0_ROL_a  ,E0_AND_al
.long   ALL_BMI      ,E0_AND_OdO_y,E0_AND_OdO,E0_AND_Od_sO_y
.long   E0_BIT_d_x   ,E0_AND_d_x  ,E0_ROL_d_x,E0_AND_IdI_y
.long   ALL_SEC      ,E0_AND_a_y  ,E0_DEA    ,ALL_TSC
.long   E0_BIT_a_x   ,E0_AND_a_x  ,E0_ROL_a_x,E0_AND_al_x
.long   E0_RTI       ,E0_EOR_Od_xO,DO_INVALID,E0_EOR_d_s
.long   E0_MVP       ,E0_EOR_d    ,E0_LSR_d  ,E0_EOR_IdI
.long   E0_PHA       ,E0_EOR_i    ,E0_SRA    ,E0_PHK
.long   ALL_JMP_a    ,E0_EOR_a    ,E0_LSR_a  ,E0_EOR_al
.long   ALL_BVC      ,E0_EOR_OdO_y,E0_EOR_OdO,E0_EOR_Od_sO_y
.long   E0_MVN       ,E0_EOR_d_x  ,E0_LSR_d_x,E0_EOR_IdI_y
.long   ALL_CLI      ,E0_EOR_a_y  ,E0_PHY    ,ALL_TCD
.long   ALL_JMP_al   ,E0_EOR_a_x  ,E0_LSR_a_x,E0_EOR_al_x
.long   E0_RTS       ,E0_ADC_Od_xO,E0_PER    ,E0_ADC_d_s
.long   E0_STZ_d     ,E0_ADC_d    ,E0_ROR_d  ,E0_ADC_IdI
.long   E0_PLA       ,E0_ADC_i    ,E0_RRA    ,E0_RTL
.long   ALL_JMP_OaO  ,E0_ADC_a    ,E0_ROR_a  ,E0_ADC_al
.long   ALL_BVS      ,E0_ADC_OdO_y,E0_ADC_OdO,E0_ADC_Od_sO_y
.long   E0_STZ_d_x   ,E0_ADC_d_x  ,E0_ROR_d_x,E0_ADC_IdI_y
.long   ALL_SEI      ,E0_ADC_a_y  ,E0_PLY    ,ALL_TDC
.long   ALL_JMP_Oa_xO,E0_ADC_a_x  ,E0_ROR_a_x,E0_ADC_al_x
.long   ALL_BRA      ,E0_STA_Od_xO,ALL_BRL   ,E0_STA_d_s
.long   E0_STY_d     ,E0_STA_d    ,E0_STX_d  ,E0_STA_IdI
.long   E0_DEY       ,E0_BIT_i    ,E0_TXA    ,E0_PHB
.long   E0_STY_a     ,E0_STA_a    ,E0_STX_a  ,E0_STA_al
.long   ALL_BCC      ,E0_STA_OdO_y,E0_STA_OdO,E0_STA_Od_sO_y
.long   E0_STY_d_x   ,E0_STA_d_x  ,E0_STX_d_y,E0_STA_IdI_y
.long   E0_TYA       ,E0_STA_a_y  ,E0_TXS    ,E0_TXY
.long   E0_STZ_a     ,E0_STA_a_x  ,E0_STZ_a_x,E0_STA_al_x
.long   E0_LDY_i     ,E0_LDA_Od_xO,E0_LDX_i  ,E0_LDA_d_s
.long   E0_LDY_d     ,E0_LDA_d    ,E0_LDX_d  ,E0_LDA_IdI
.long   E0_TAY       ,E0_LDA_i    ,E0_TAX    ,E0_PLB
.long   E0_LDY_a     ,E0_LDA_a    ,E0_LDX_a  ,E0_LDA_al
.long   ALL_BCS      ,E0_LDA_OdO_y,E0_LDA_OdO,E0_LDA_Od_sO_y
.long   E0_LDY_d_x   ,E0_LDA_d_x  ,E0_LDX_d_y,E0_LDA_IdI_y
.long   ALL_CLV      ,E0_LDA_a_y  ,E0_TSX    ,E0_TYX
.long   E0_LDY_a_x   ,E0_LDA_a_x  ,E0_LDX_a_y,E0_LDA_al_x
.long   E0_CPY_i     ,E0_CMP_Od_xO,E0_REP    ,E0_CMP_d_s
.long   E0_CPY_d     ,E0_CMP_d    ,E0_DEC_d  ,E0_CMP_IdI
.long   E0_INY       ,E0_CMP_i    ,E0_DEX    ,ALL_WAI
.long   E0_CPY_a     ,E0_CMP_a    ,E0_DEC_a  ,E0_CMP_al
.long   ALL_BNE      ,E0_CMP_OdO_y,E0_CMP_OdO,E0_CMP_Od_sO_y
.long   E0_PEI       ,E0_CMP_d_x  ,E0_DEC_d_x,E0_CMP_IdI_y
.long   ALL_CLD      ,E0_CMP_a_y  ,E0_PHX    ,DO_INVALID
.long   ALL_JML_OaO  ,E0_CMP_a_x  ,E0_DEC_a_x,E0_CMP_al_x
.long   E0_CPX_i     ,E0_SBC_Od_xO,E0_SEP    ,E0_SBC_d_s
.long   E0_CPX_d     ,E0_SBC_d    ,E0_INC_d  ,E0_SBC_IdI
.long   E0_INX       ,E0_SBC_i    ,ALL_NOP   ,ALL_XBA
.long   E0_CPX_a     ,E0_SBC_a    ,E0_INC_a  ,E0_SBC_al
.long   ALL_BEQ      ,E0_SBC_OdO_y,E0_SBC_OdO,E0_SBC_Od_sO_y
.long   E0_PEA       ,E0_SBC_d_x  ,E0_INC_d_x,E0_SBC_IdI_y
.long   ALL_SED      ,E0_SBC_a_y  ,E0_PLX    ,E0_XCE
.long   E0_JSR_Oa_xO ,E0_SBC_a_x  ,E0_INC_a_x,E0_SBC_al_x

.globl PmOpTable
PmOpTable:
.long   E0_BRK       ,EM_ORA_Od_xO,E0_COP    ,EM_ORA_d_s
.long   EM_TSB_d     ,EM_ORA_d    ,EM_ASL_d  ,EM_ORA_IdI
.long   E0_PHP       ,EM_ORA_i    ,EM_SLA    ,E0_PHD
.long   EM_TSB_a     ,EM_ORA_a    ,EM_ASL_a  ,EM_ORA_al
.long   ALL_BPL      ,EM_ORA_OdO_y,EM_ORA_OdO,EM_ORA_Od_sO_y
.long   EM_TRB_d     ,EM_ORA_d_x  ,EM_ASL_d_x,EM_ORA_IdI_y
.long   ALL_CLC      ,EM_ORA_a_y  ,EM_INA    ,E0_TCS
.long   EM_TRB_a     ,EM_ORA_a_x  ,EM_ASL_a_x,EM_ORA_al_x
.long   E0_JSR_a     ,EM_AND_Od_xO,E0_JSL_al ,EM_AND_d_s
.long   EM_BIT_d     ,EM_AND_d    ,EM_ROL_d  ,EM_AND_IdI
.long   E0_PLP       ,EM_AND_i    ,EM_RLA    ,E0_PLD
.long   EM_BIT_a     ,EM_AND_a    ,EM_ROL_a  ,EM_AND_al
.long   ALL_BMI      ,EM_AND_OdO_y,EM_AND_OdO,EM_AND_Od_sO_y
.long   EM_BIT_d_x   ,EM_AND_d_x  ,EM_ROL_d_x,EM_AND_IdI_y
.long   ALL_SEC      ,EM_AND_a_y  ,EM_DEA    ,ALL_TSC
.long   EM_BIT_a_x   ,EM_AND_a_x  ,EM_ROL_a_x,EM_AND_al_x
.long   E0_RTI       ,EM_EOR_Od_xO,DO_INVALID,EM_EOR_d_s
.long   E0_MVP       ,EM_EOR_d    ,EM_LSR_d  ,EM_EOR_IdI
.long   EM_PHA       ,EM_EOR_i    ,EM_SRA    ,E0_PHK
.long   ALL_JMP_a    ,EM_EOR_a    ,EM_LSR_a  ,EM_EOR_al
.long   ALL_BVC      ,EM_EOR_OdO_y,EM_EOR_OdO,EM_EOR_Od_sO_y
.long   E0_MVN       ,EM_EOR_d_x  ,EM_LSR_d_x,EM_EOR_IdI_y
.long   ALL_CLI      ,EM_EOR_a_y  ,E0_PHY    ,ALL_TCD
.long   ALL_JMP_al   ,EM_EOR_a_x  ,EM_LSR_a_x,EM_EOR_al_x
.long   E0_RTS       ,EM_ADC_Od_xO,E0_PER    ,EM_ADC_d_s
.long   EM_STZ_d     ,EM_ADC_d    ,EM_ROR_d  ,EM_ADC_IdI
.long   EM_PLA       ,EM_ADC_i    ,EM_RRA    ,E0_RTL
.long   ALL_JMP_OaO  ,EM_ADC_a    ,EM_ROR_a  ,EM_ADC_al
.long   ALL_BVS      ,EM_ADC_OdO_y,EM_ADC_OdO,EM_ADC_Od_sO_y
.long   EM_STZ_d_x   ,EM_ADC_d_x  ,EM_ROR_d_x,EM_ADC_IdI_y
.long   ALL_SEI      ,EM_ADC_a_y  ,E0_PLY    ,ALL_TDC
.long   ALL_JMP_Oa_xO,EM_ADC_a_x  ,EM_ROR_a_x,EM_ADC_al_x
.long   ALL_BRA      ,EM_STA_Od_xO,ALL_BRL   ,EM_STA_d_s
.long   E0_STY_d     ,EM_STA_d    ,E0_STX_d  ,EM_STA_IdI
.long   E0_DEY       ,EM_BIT_i    ,EM_TXA    ,E0_PHB
.long   E0_STY_a     ,EM_STA_a    ,E0_STX_a  ,EM_STA_al
.long   ALL_BCC      ,EM_STA_OdO_y,EM_STA_OdO,EM_STA_Od_sO_y
.long   E0_STY_d_x   ,EM_STA_d_x  ,E0_STX_d_y,EM_STA_IdI_y
.long   EM_TYA       ,EM_STA_a_y  ,E0_TXS    ,E0_TXY
.long   EM_STZ_a     ,EM_STA_a_x  ,EM_STZ_a_x,EM_STA_al_x
.long   E0_LDY_i     ,EM_LDA_Od_xO,E0_LDX_i  ,EM_LDA_d_s
.long   E0_LDY_d     ,EM_LDA_d    ,E0_LDX_d  ,EM_LDA_IdI
.long   E0_TAY       ,EM_LDA_i    ,E0_TAX    ,E0_PLB
.long   E0_LDY_a     ,EM_LDA_a    ,E0_LDX_a  ,EM_LDA_al
.long   ALL_BCS      ,EM_LDA_OdO_y,EM_LDA_OdO,EM_LDA_Od_sO_y
.long   E0_LDY_d_x   ,EM_LDA_d_x  ,E0_LDX_d_y,EM_LDA_IdI_y
.long   ALL_CLV      ,EM_LDA_a_y  ,E0_TSX    ,E0_TYX
.long   E0_LDY_a_x   ,EM_LDA_a_x  ,E0_LDX_a_y,EM_LDA_al_x
.long   E0_CPY_i     ,EM_CMP_Od_xO,E0_REP    ,EM_CMP_d_s
.long   E0_CPY_d     ,EM_CMP_d    ,EM_DEC_d  ,EM_CMP_IdI
.long   E0_INY       ,EM_CMP_i    ,E0_DEX    ,ALL_WAI
.long   E0_CPY_a     ,EM_CMP_a    ,EM_DEC_a  ,EM_CMP_al
.long   ALL_BNE      ,EM_CMP_OdO_y,EM_CMP_OdO,EM_CMP_Od_sO_y
.long   E0_PEI       ,EM_CMP_d_x  ,EM_DEC_d_x,EM_CMP_IdI_y
.long   ALL_CLD      ,EM_CMP_a_y  ,E0_PHX    ,DO_INVALID
.long   ALL_JML_OaO  ,EM_CMP_a_x  ,EM_DEC_a_x,EM_CMP_al_x
.long   E0_CPX_i     ,EM_SBC_Od_xO,E0_SEP    ,EM_SBC_d_s
.long   E0_CPX_d     ,EM_SBC_d    ,EM_INC_d  ,EM_SBC_IdI
.long   E0_INX       ,EM_SBC_i    ,ALL_NOP   ,ALL_XBA
.long   E0_CPX_a     ,EM_SBC_a    ,EM_INC_a  ,EM_SBC_al
.long   ALL_BEQ      ,EM_SBC_OdO_y,EM_SBC_OdO,EM_SBC_Od_sO_y
.long   E0_PEA       ,EM_SBC_d_x  ,EM_INC_d_x,EM_SBC_IdI_y
.long   ALL_SED      ,EM_SBC_a_y  ,E0_PLX    ,E0_XCE
.long   E0_JSR_Oa_xO ,EM_SBC_a_x  ,EM_INC_a_x,EM_SBC_al_x

.globl PxOpTable
PxOpTable:
.long   E0_BRK       ,E0_ORA_Od_xO,E0_COP    ,E0_ORA_d_s
.long   E0_TSB_d     ,E0_ORA_d    ,E0_ASL_d  ,E0_ORA_IdI
.long   E0_PHP       ,E0_ORA_i    ,E0_SLA    ,E0_PHD
.long   E0_TSB_a     ,E0_ORA_a    ,E0_ASL_a  ,E0_ORA_al
.long   ALL_BPL      ,E0_ORA_OdO_y,E0_ORA_OdO,E0_ORA_Od_sO_y
.long   E0_TRB_d     ,E0_ORA_d_x  ,E0_ASL_d_x,E0_ORA_IdI_y
.long   ALL_CLC      ,E0_ORA_a_y  ,E0_INA    ,E0_TCS
.long   E0_TRB_a     ,E0_ORA_a_x  ,E0_ASL_a_x,E0_ORA_al_x
.long   E0_JSR_a     ,E0_AND_Od_xO,E0_JSL_al ,E0_AND_d_s
.long   E0_BIT_d     ,E0_AND_d    ,E0_ROL_d  ,E0_AND_IdI
.long   E0_PLP       ,E0_AND_i    ,E0_RLA    ,E0_PLD
.long   E0_BIT_a     ,E0_AND_a    ,E0_ROL_a  ,E0_AND_al
.long   ALL_BMI      ,E0_AND_OdO_y,E0_AND_OdO,E0_AND_Od_sO_y
.long   E0_BIT_d_x   ,E0_AND_d_x  ,E0_ROL_d_x,E0_AND_IdI_y
.long   ALL_SEC      ,E0_AND_a_y  ,E0_DEA    ,ALL_TSC
.long   E0_BIT_a_x   ,E0_AND_a_x  ,E0_ROL_a_x,E0_AND_al_x
.long   E0_RTI       ,E0_EOR_Od_xO,DO_INVALID,E0_EOR_d_s
.long   EX_MVP       ,E0_EOR_d    ,E0_LSR_d  ,E0_EOR_IdI
.long   E0_PHA       ,E0_EOR_i    ,E0_SRA    ,E0_PHK
.long   ALL_JMP_a    ,E0_EOR_a    ,E0_LSR_a  ,E0_EOR_al
.long   ALL_BVC      ,E0_EOR_OdO_y,E0_EOR_OdO,E0_EOR_Od_sO_y
.long   EX_MVN       ,E0_EOR_d_x  ,E0_LSR_d_x,E0_EOR_IdI_y
.long   ALL_CLI      ,E0_EOR_a_y  ,EX_PHY    ,ALL_TCD
.long   ALL_JMP_al   ,E0_EOR_a_x  ,E0_LSR_a_x,E0_EOR_al_x
.long   E0_RTS       ,E0_ADC_Od_xO,E0_PER    ,E0_ADC_d_s
.long   E0_STZ_d     ,E0_ADC_d    ,E0_ROR_d  ,E0_ADC_IdI
.long   E0_PLA       ,E0_ADC_i    ,E0_RRA    ,E0_RTL
.long   ALL_JMP_OaO  ,E0_ADC_a    ,E0_ROR_a  ,E0_ADC_al
.long   ALL_BVS      ,E0_ADC_OdO_y,E0_ADC_OdO,E0_ADC_Od_sO_y
.long   E0_STZ_d_x   ,E0_ADC_d_x  ,E0_ROR_d_x,E0_ADC_IdI_y
.long   ALL_SEI      ,E0_ADC_a_y  ,EX_PLY    ,ALL_TDC
.long   ALL_JMP_Oa_xO,E0_ADC_a_x  ,E0_ROR_a_x,E0_ADC_al_x
.long   ALL_BRA      ,E0_STA_Od_xO,ALL_BRL   ,E0_STA_d_s
.long   EX_STY_d     ,E0_STA_d    ,EX_STX_d  ,E0_STA_IdI
.long   EX_DEY       ,E0_BIT_i    ,E0_TXA    ,E0_PHB
.long   EX_STY_a     ,E0_STA_a    ,EX_STX_a  ,E0_STA_al
.long   ALL_BCC      ,E0_STA_OdO_y,E0_STA_OdO,E0_STA_Od_sO_y
.long   EX_STY_d_x   ,E0_STA_d_x  ,EX_STX_d_y,E0_STA_IdI_y
.long   E0_TYA       ,E0_STA_a_y  ,E0_TXS    ,EX_TXY
.long   E0_STZ_a     ,E0_STA_a_x  ,E0_STZ_a_x,E0_STA_al_x
.long   EX_LDY_i     ,E0_LDA_Od_xO,EX_LDX_i  ,E0_LDA_d_s
.long   EX_LDY_d     ,E0_LDA_d    ,EX_LDX_d  ,E0_LDA_IdI
.long   EX_TAY       ,E0_LDA_i    ,EX_TAX    ,E0_PLB
.long   EX_LDY_a     ,E0_LDA_a    ,EX_LDX_a  ,E0_LDA_al
.long   ALL_BCS      ,E0_LDA_OdO_y,E0_LDA_OdO,E0_LDA_Od_sO_y
.long   EX_LDY_d_x   ,E0_LDA_d_x  ,EX_LDX_d_y,E0_LDA_IdI_y
.long   ALL_CLV      ,E0_LDA_a_y  ,EX_TSX    ,EX_TYX
.long   EX_LDY_a_x   ,E0_LDA_a_x  ,EX_LDX_a_y,E0_LDA_al_x
.long   EX_CPY_i     ,E0_CMP_Od_xO,E0_REP    ,E0_CMP_d_s
.long   EX_CPY_d     ,E0_CMP_d    ,E0_DEC_d  ,E0_CMP_IdI
.long   EX_INY       ,E0_CMP_i    ,EX_DEX    ,ALL_WAI
.long   EX_CPY_a     ,E0_CMP_a    ,E0_DEC_a  ,E0_CMP_al
.long   ALL_BNE      ,E0_CMP_OdO_y,E0_CMP_OdO,E0_CMP_Od_sO_y
.long   E0_PEI       ,E0_CMP_d_x  ,E0_DEC_d_x,E0_CMP_IdI_y
.long   ALL_CLD      ,E0_CMP_a_y  ,EX_PHX    ,DO_INVALID
.long   ALL_JML_OaO  ,E0_CMP_a_x  ,E0_DEC_a_x,E0_CMP_al_x
.long   EX_CPX_i     ,E0_SBC_Od_xO,E0_SEP    ,E0_SBC_d_s
.long   EX_CPX_d     ,E0_SBC_d    ,E0_INC_d  ,E0_SBC_IdI
.long   EX_INX       ,E0_SBC_i    ,ALL_NOP   ,ALL_XBA
.long   EX_CPX_a     ,E0_SBC_a    ,E0_INC_a  ,E0_SBC_al
.long   ALL_BEQ      ,E0_SBC_OdO_y,E0_SBC_OdO,E0_SBC_Od_sO_y
.long   E0_PEA       ,E0_SBC_d_x  ,E0_INC_d_x,E0_SBC_IdI_y
.long   ALL_SED      ,E0_SBC_a_y  ,EX_PLX    ,E0_XCE
.long   E0_JSR_Oa_xO ,E0_SBC_a_x  ,E0_INC_a_x,E0_SBC_al_x

.globl MXOpTable
MXOpTable:
.long   E0_BRK       ,EM_ORA_Od_xO,E0_COP    ,EM_ORA_d_s
.long   EM_TSB_d     ,EM_ORA_d    ,EM_ASL_d  ,EM_ORA_IdI
.long   E0_PHP       ,EM_ORA_i    ,EM_SLA    ,E0_PHD
.long   EM_TSB_a     ,EM_ORA_a    ,EM_ASL_a  ,EM_ORA_al
.long   ALL_BPL      ,EM_ORA_OdO_y,EM_ORA_OdO,EM_ORA_Od_sO_y
.long   EM_TRB_d     ,EM_ORA_d_x  ,EM_ASL_d_x,EM_ORA_IdI_y
.long   ALL_CLC      ,EM_ORA_a_y  ,EM_INA    ,E0_TCS
.long   EM_TRB_a     ,EM_ORA_a_x  ,EM_ASL_a_x,EM_ORA_al_x
.long   E0_JSR_a     ,EM_AND_Od_xO,E0_JSL_al ,EM_AND_d_s
.long   EM_BIT_d     ,EM_AND_d    ,EM_ROL_d  ,EM_AND_IdI
.long   E0_PLP       ,EM_AND_i    ,EM_RLA    ,E0_PLD
.long   EM_BIT_a     ,EM_AND_a    ,EM_ROL_a  ,EM_AND_al
.long   ALL_BMI      ,EM_AND_OdO_y,EM_AND_OdO,EM_AND_Od_sO_y
.long   EM_BIT_d_x   ,EM_AND_d_x  ,EM_ROL_d_x,EM_AND_IdI_y
.long   ALL_SEC      ,EM_AND_a_y  ,EM_DEA    ,ALL_TSC
.long   EM_BIT_a_x   ,EM_AND_a_x  ,EM_ROL_a_x,EM_AND_al_x
.long   E0_RTI       ,EM_EOR_Od_xO,DO_INVALID,EM_EOR_d_s
.long   EX_MVP       ,EM_EOR_d    ,EM_LSR_d  ,EM_EOR_IdI
.long   EM_PHA       ,EM_EOR_i    ,EM_SRA    ,E0_PHK
.long   ALL_JMP_a    ,EM_EOR_a    ,EM_LSR_a  ,EM_EOR_al
.long   ALL_BVC      ,EM_EOR_OdO_y,EM_EOR_OdO,EM_EOR_Od_sO_y
.long   EX_MVN       ,EM_EOR_d_x  ,EM_LSR_d_x,EM_EOR_IdI_y
.long   ALL_CLI      ,EM_EOR_a_y  ,EX_PHY    ,ALL_TCD
.long   ALL_JMP_al   ,EM_EOR_a_x  ,EM_LSR_a_x,EM_EOR_al_x
.long   E0_RTS       ,EM_ADC_Od_xO,E0_PER    ,EM_ADC_d_s
.long   EM_STZ_d     ,EM_ADC_d    ,EM_ROR_d  ,EM_ADC_IdI
.long   EM_PLA       ,EM_ADC_i    ,EM_RRA    ,E0_RTL
.long   ALL_JMP_OaO  ,EM_ADC_a    ,EM_ROR_a  ,EM_ADC_al
.long   ALL_BVS      ,EM_ADC_OdO_y,EM_ADC_OdO,EM_ADC_Od_sO_y
.long   EM_STZ_d_x   ,EM_ADC_d_x  ,EM_ROR_d_x,EM_ADC_IdI_y
.long   ALL_SEI      ,EM_ADC_a_y  ,EX_PLY    ,ALL_TDC
.long   ALL_JMP_Oa_xO,EM_ADC_a_x  ,EM_ROR_a_x,EM_ADC_al_x
.long   ALL_BRA      ,EM_STA_Od_xO,ALL_BRL   ,EM_STA_d_s
.long   EX_STY_d     ,EM_STA_d    ,EX_STX_d  ,EM_STA_IdI
.long   EX_DEY       ,EM_BIT_i    ,EM_TXA    ,E0_PHB
.long   EX_STY_a     ,EM_STA_a    ,EX_STX_a  ,EM_STA_al
.long   ALL_BCC      ,EM_STA_OdO_y,EM_STA_OdO,EM_STA_Od_sO_y
.long   EX_STY_d_x   ,EM_STA_d_x  ,EX_STX_d_y,EM_STA_IdI_y
.long   EM_TYA       ,EM_STA_a_y  ,E0_TXS    ,EX_TXY
.long   EM_STZ_a     ,EM_STA_a_x  ,EM_STZ_a_x,EM_STA_al_x
.long   EX_LDY_i     ,EM_LDA_Od_xO,EX_LDX_i  ,EM_LDA_d_s
.long   EX_LDY_d     ,EM_LDA_d    ,EX_LDX_d  ,EM_LDA_IdI
.long   EX_TAY       ,EM_LDA_i    ,EX_TAX    ,E0_PLB
.long   EX_LDY_a     ,EM_LDA_a    ,EX_LDX_a  ,EM_LDA_al
.long   ALL_BCS      ,EM_LDA_OdO_y,EM_LDA_OdO,EM_LDA_Od_sO_y
.long   EX_LDY_d_x   ,EM_LDA_d_x  ,EX_LDX_d_y,EM_LDA_IdI_y
.long   ALL_CLV      ,EM_LDA_a_y  ,EX_TSX    ,EX_TYX
.long   EX_LDY_a_x   ,EM_LDA_a_x  ,EX_LDX_a_y,EM_LDA_al_x
.long   EX_CPY_i     ,EM_CMP_Od_xO,E0_REP    ,EM_CMP_d_s
.long   EX_CPY_d     ,EM_CMP_d    ,EM_DEC_d  ,EM_CMP_IdI
.long   EX_INY       ,EM_CMP_i    ,EX_DEX    ,ALL_WAI
.long   EX_CPY_a     ,EM_CMP_a    ,EM_DEC_a  ,EM_CMP_al
.long   ALL_BNE      ,EM_CMP_OdO_y,EM_CMP_OdO,EM_CMP_Od_sO_y
.long   E0_PEI       ,EM_CMP_d_x  ,EM_DEC_d_x,EM_CMP_IdI_y
.long   ALL_CLD      ,EM_CMP_a_y  ,EX_PHX    ,DO_INVALID
.long   ALL_JML_OaO  ,EM_CMP_a_x  ,EM_DEC_a_x,EM_CMP_al_x
.long   EX_CPX_i     ,EM_SBC_Od_xO,E0_SEP    ,EM_SBC_d_s
.long   EX_CPX_d     ,EM_SBC_d    ,EM_INC_d  ,EM_SBC_IdI
.long   EX_INX       ,EM_SBC_i    ,ALL_NOP   ,ALL_XBA
.long   EX_CPX_a     ,EM_SBC_a    ,EM_INC_a  ,EM_SBC_al
.long   ALL_BEQ      ,EM_SBC_OdO_y,EM_SBC_OdO,EM_SBC_Od_sO_y
.long   E0_PEA       ,EM_SBC_d_x  ,EM_INC_d_x,EM_SBC_IdI_y
.long   ALL_SED      ,EM_SBC_a_y  ,EX_PLX    ,E0_XCE
.long   E0_JSR_Oa_xO ,EM_SBC_a_x  ,EM_INC_a_x,EM_SBC_al_x

.globl E1OpTable
E1OpTable:
.long   E1_BRK       ,EM_ORA_Od_xO,E1_COP    ,EM_ORA_d_s
.long   EM_TSB_d     ,EM_ORA_d    ,EM_ASL_d  ,EM_ORA_IdI
.long   E1_PHP       ,EM_ORA_i    ,EM_SLA    ,E1_PHD
.long   EM_TSB_a     ,EM_ORA_a    ,EM_ASL_a  ,EM_ORA_al
.long   ALL_BPL      ,EM_ORA_OdO_y,EM_ORA_OdO,EM_ORA_Od_sO_y
.long   EM_TRB_d     ,EM_ORA_d_x  ,EM_ASL_d_x,EM_ORA_IdI_y
.long   ALL_CLC      ,EM_ORA_a_y  ,EM_INA    ,E1_TCS
.long   EM_TRB_a     ,EM_ORA_a_x  ,EM_ASL_a_x,EM_ORA_al_x
.long   E1_JSR_a     ,EM_AND_Od_xO,E1_JSL_al ,EM_AND_d_s
.long   EM_BIT_d     ,EM_AND_d    ,EM_ROL_d  ,EM_AND_IdI
.long   E1_PLP       ,EM_AND_i    ,EM_RLA    ,E1_PLD
.long   EM_BIT_a     ,EM_AND_a    ,EM_ROL_a  ,EM_AND_al
.long   ALL_BMI      ,EM_AND_OdO_y,EM_AND_OdO,EM_AND_Od_sO_y
.long   EM_BIT_d_x   ,EM_AND_d_x  ,EM_ROL_d_x,EM_AND_IdI_y
.long   ALL_SEC      ,EM_AND_a_y  ,EM_DEA    ,ALL_TSC
.long   EM_BIT_a_x   ,EM_AND_a_x  ,EM_ROL_a_x,EM_AND_al_x
.long   E1_RTI       ,EM_EOR_Od_xO,DO_INVALID,EM_EOR_d_s
.long   EX_MVP       ,EM_EOR_d    ,EM_LSR_d  ,EM_EOR_IdI
.long   EM_PHA       ,EM_EOR_i    ,EM_SRA    ,E1_PHK
.long   ALL_JMP_a    ,EM_EOR_a    ,EM_LSR_a  ,EM_EOR_al
.long   ALL_BVC      ,EM_EOR_OdO_y,EM_EOR_OdO,EM_EOR_Od_sO_y
.long   EX_MVN       ,EM_EOR_d_x  ,EM_LSR_d_x,EM_EOR_IdI_y
.long   ALL_CLI      ,EM_EOR_a_y  ,E1_PHY    ,ALL_TCD
.long   ALL_JMP_al   ,EM_EOR_a_x  ,EM_LSR_a_x,EM_EOR_al_x
.long   E1_RTS       ,EM_ADC_Od_xO,E1_PER    ,EM_ADC_d_s
.long   EM_STZ_d     ,EM_ADC_d    ,EM_ROR_d  ,EM_ADC_IdI
.long   E1_PLA       ,EM_ADC_i    ,EM_RRA    ,E1_RTL
.long   ALL_JMP_OaO  ,EM_ADC_a    ,EM_ROR_a  ,EM_ADC_al
.long   ALL_BVS      ,EM_ADC_OdO_y,EM_ADC_OdO,EM_ADC_Od_sO_y
.long   EM_STZ_d_x   ,EM_ADC_d_x  ,EM_ROR_d_x,EM_ADC_IdI_y
.long   ALL_SEI      ,EM_ADC_a_y  ,E1_PLY    ,ALL_TDC
.long   ALL_JMP_Oa_xO,EM_ADC_a_x  ,EM_ROR_a_x,EM_ADC_al_x
.long   ALL_BRA      ,EM_STA_Od_xO,ALL_BRL   ,EM_STA_d_s
.long   EX_STY_d     ,EM_STA_d    ,EX_STX_d  ,EM_STA_IdI
.long   EX_DEY       ,EM_BIT_i    ,EM_TXA    ,E1_PHB
.long   EX_STY_a     ,EM_STA_a    ,EX_STX_a  ,EM_STA_al
.long   ALL_BCC      ,EM_STA_OdO_y,EM_STA_OdO,EM_STA_Od_sO_y
.long   EX_STY_d_x   ,EM_STA_d_x  ,EX_STX_d_y,EM_STA_IdI_y
.long   EM_TYA       ,EM_STA_a_y  ,E1_TXS    ,EX_TXY
.long   EM_STZ_a     ,EM_STA_a_x  ,EM_STZ_a_x,EM_STA_al_x
.long   EX_LDY_i     ,EM_LDA_Od_xO,EX_LDX_i  ,EM_LDA_d_s
.long   EX_LDY_d     ,EM_LDA_d    ,EX_LDX_d  ,EM_LDA_IdI
.long   EX_TAY       ,EM_LDA_i    ,EX_TAX    ,E1_PLB
.long   EX_LDY_a     ,EM_LDA_a    ,EX_LDX_a  ,EM_LDA_al
.long   ALL_BCS      ,EM_LDA_OdO_y,EM_LDA_OdO,EM_LDA_Od_sO_y
.long   EX_LDY_d_x   ,EM_LDA_d_x  ,EX_LDX_d_y,EM_LDA_IdI_y
.long   ALL_CLV      ,EM_LDA_a_y  ,EX_TSX    ,EX_TYX
.long   EX_LDY_a_x   ,EM_LDA_a_x  ,EX_LDX_a_y,EM_LDA_al_x
.long   EX_CPY_i     ,EM_CMP_Od_xO,E1_REP    ,EM_CMP_d_s
.long   EX_CPY_d     ,EM_CMP_d    ,EM_DEC_d  ,EM_CMP_IdI
.long   EX_INY       ,EM_CMP_i    ,EX_DEX    ,ALL_WAI
.long   EX_CPY_a     ,EM_CMP_a    ,EM_DEC_a  ,EM_CMP_al
.long   ALL_BNE      ,EM_CMP_OdO_y,EM_CMP_OdO,EM_CMP_Od_sO_y
.long   E1_PEI       ,EM_CMP_d_x  ,EM_DEC_d_x,EM_CMP_IdI_y
.long   ALL_CLD      ,EM_CMP_a_y  ,E1_PHX    ,DO_INVALID
.long   ALL_JML_OaO  ,EM_CMP_a_x  ,EM_DEC_a_x,EM_CMP_al_x
.long   EX_CPX_i     ,EM_SBC_Od_xO,E1_SEP    ,EM_SBC_d_s
.long   EX_CPX_d     ,EM_SBC_d    ,EM_INC_d  ,EM_SBC_IdI
.long   EX_INX       ,EM_SBC_i    ,ALL_NOP   ,ALL_XBA
.long   EX_CPX_a     ,EM_SBC_a    ,EM_INC_a  ,EM_SBC_al
.long   ALL_BEQ      ,EM_SBC_OdO_y,EM_SBC_OdO,EM_SBC_Od_sO_y
.long   E1_PEA       ,EM_SBC_d_x  ,EM_INC_d_x,EM_SBC_IdI_y
.long   ALL_SED      ,EM_SBC_a_y  ,E1_PLX    ,E1_XCE
.long   E1_JSR_Oa_xO ,EM_SBC_a_x  ,EM_INC_a_x,EM_SBC_al_x

E0Cycles: // These hold the base number of cycles for instructions
.byte 8,7,8,5,7,4,7,7,3,3,2,4,8,5,8,6
.byte 2,6,6,8,8,5,8,7,2,5,2,2,8,5,9,6
.byte 6,7,8,5,4,4,7,7,4,3,2,5,5,5,8,6
.byte 2,6,6,8,5,5,8,7,2,5,2,2,5,5,9,6
.byte 7,7,0,5,7,4,7,7,4,3,2,3,3,5,8,6
.byte 2,6,6,8,7,5,8,7,2,5,4,2,4,5,9,6
.byte 6,7,6,5,4,4,7,7,5,3,2,6,5,5,8,6
.byte 2,6,6,8,5,5,9,7,2,5,5,2,6,5,8,6
.byte 2,7,3,5,4,4,4,7,2,3,2,3,5,5,5,6
.byte 2,6,6,8,5,5,5,7,2,5,2,2,5,5,5,6
.byte 3,7,3,5,4,4,4,7,2,3,2,4,5,5,5,6
.byte 2,6,6,8,5,5,5,7,2,5,2,2,5,5,5,6
.byte 3,7,3,5,4,4,4,7,2,3,2,3,5,5,5,6
.byte 2,6,6,8,6,5,5,7,2,5,4,0,6,5,9,6
.byte 3,7,3,5,4,4,4,7,2,3,2,3,5,5,5,6
.byte 2,6,6,8,5,5,8,7,2,5,5,2,8,5,5,6

PmCycles:
.byte 8,6,8,4,5,3,5,6,3,2,2,4,6,4,6,5
.byte 2,5,5,7,6,4,6,6,2,4,2,2,6,4,7,5
.byte 6,6,8,4,3,3,5,6,4,2,2,5,4,4,6,5
.byte 2,5,5,7,4,4,6,6,2,4,2,2,4,4,7,5
.byte 7,6,0,4,7,3,5,6,3,2,2,3,3,4,6,5
.byte 2,5,5,7,7,4,6,6,2,4,4,2,4,4,7,5
.byte 6,6,6,4,3,3,5,6,4,2,2,6,5,4,6,5
.byte 2,5,5,7,4,4,7,6,2,4,5,2,6,4,6,5
.byte 2,6,3,4,4,3,4,6,2,2,2,3,5,4,5,5
.byte 2,5,5,7,5,4,5,6,2,4,2,2,4,4,4,5
.byte 3,6,3,4,4,3,4,6,2,2,2,4,5,4,5,5
.byte 2,5,5,7,5,4,5,6,2,4,2,2,5,4,5,5
.byte 3,6,3,4,4,3,3,6,2,2,2,3,5,4,4,5
.byte 2,5,5,7,6,4,4,6,2,4,4,0,6,4,7,5
.byte 3,6,3,4,4,3,3,6,2,2,2,3,5,4,4,5
.byte 2,5,5,7,5,4,6,6,2,4,5,2,8,4,4,5

PxCycles:
.byte 8,7,8,5,7,4,7,7,3,3,2,4,8,5,8,6
.byte 2,6,6,8,8,5,8,7,2,5,2,2,8,5,9,6
.byte 6,7,8,5,4,4,7,7,4,3,2,5,5,5,8,6
.byte 2,6,6,8,5,5,8,7,2,5,2,2,5,5,9,6
.byte 7,7,0,5,7,4,7,7,4,3,2,3,3,5,8,6
.byte 2,6,6,8,7,5,8,7,2,5,3,2,4,5,9,6
.byte 6,7,6,5,4,4,7,7,5,3,2,6,5,5,8,6
.byte 2,6,6,8,5,5,9,7,2,5,4,2,6,5,8,6
.byte 2,7,3,5,3,4,3,7,2,3,2,3,4,5,4,6
.byte 2,6,6,8,4,5,4,7,2,5,2,2,5,5,5,6
.byte 2,7,2,5,3,4,3,7,2,3,2,4,4,5,4,6
.byte 2,6,6,8,4,5,4,7,2,5,2,2,4,5,4,6
.byte 2,7,3,5,3,4,4,7,2,3,2,3,4,5,5,6
.byte 2,6,6,8,6,5,5,7,2,5,3,0,6,5,9,6
.byte 2,7,3,5,3,4,4,7,2,3,2,3,4,5,5,6
.byte 2,6,6,8,5,5,8,7,2,5,4,2,8,5,5,6

MXCycles:
.byte 8,6,8,4,5,3,5,6,3,2,2,4,6,4,6,5
.byte 2,5,5,7,6,4,6,6,2,4,2,2,6,4,7,5
.byte 6,6,8,4,3,3,5,6,4,2,2,5,4,4,6,5
.byte 2,5,5,7,4,4,6,6,2,4,2,2,4,4,7,5
.byte 7,6,0,4,7,3,5,6,3,2,2,3,3,4,6,5
.byte 2,5,5,7,7,4,6,6,2,4,3,2,4,4,7,5
.byte 6,6,6,4,3,3,5,6,4,2,2,6,5,4,6,5
.byte 2,5,5,7,4,4,7,6,2,4,4,2,6,4,6,5
.byte 2,6,3,4,3,3,3,6,2,2,2,3,4,4,4,5
.byte 2,5,5,7,4,4,4,6,2,4,2,2,4,4,4,5
.byte 2,6,2,4,3,3,3,6,2,2,2,4,4,4,4,5
.byte 2,5,5,7,4,4,4,6,2,4,2,2,4,4,4,5
.byte 2,6,3,4,3,3,3,6,2,2,2,3,4,4,4,5
.byte 2,5,5,7,6,4,4,6,2,4,3,0,6,4,7,5
.byte 2,6,3,4,3,3,3,6,2,2,2,3,4,4,4,5
.byte 2,5,5,7,5,4,6,6,2,4,4,2,8,4,4,5

E1Cycles:
.byte 7,6,7,4,5,3,5,6,3,2,2,4,6,4,6,5
.byte 2,5,5,7,6,4,6,6,2,4,2,2,6,4,7,5
.byte 6,6,8,4,3,3,5,6,4,2,2,5,4,4,6,5
.byte 2,5,5,7,4,4,6,6,2,4,2,2,4,4,7,5
.byte 6,6,0,4,7,3,5,6,3,2,2,3,3,4,6,5
.byte 2,5,5,7,7,4,6,6,2,4,3,2,4,4,7,5
.byte 6,6,6,4,3,3,5,6,4,2,2,6,5,4,6,5
.byte 2,5,5,7,4,4,7,6,2,4,4,2,6,4,6,5
.byte 2,6,3,4,3,3,3,6,2,2,2,3,4,4,4,5
.byte 2,5,5,7,4,4,4,6,2,4,2,2,4,4,4,5
.byte 2,6,2,4,3,3,3,6,2,2,2,4,4,4,4,5
.byte 2,5,5,7,4,4,4,6,2,4,2,2,4,4,4,5
.byte 2,6,3,4,3,3,3,6,2,2,2,3,4,4,4,5
.byte 2,5,5,7,6,4,4,6,2,4,3,0,6,4,7,5
.byte 2,6,3,4,3,3,3,6,2,2,2,3,4,4,4,5
.byte 2,5,5,7,5,4,6,6,2,4,4,2,8,4,4,5

.globl E0_Setup_Flags_Table
E0_Setup_Flags_Table:
.byte   0,  1, 32, 33, 16, 17, 48, 49
.byte   4,  5, 36, 37, 20, 21, 52, 53
.byte   8,  9, 40, 41, 24, 25, 56, 57
.byte  12, 13, 44, 45, 28, 29, 60, 61
.byte   0,  1, 32, 33, 16, 17, 48, 49
.byte   4,  5, 36, 37, 20, 21, 52, 53
.byte   8,  9, 40, 41, 24, 25, 56, 57
.byte  12, 13, 44, 45, 28, 29, 60, 61
.byte   2,  3, 34, 35, 18, 19, 50, 51
.byte   6,  7, 38, 39, 22, 23, 54, 55
.byte  10, 11, 42, 43, 26, 27, 58, 59
.byte  14, 15, 46, 47, 30, 31, 62, 63
.byte   2,  3, 34, 35, 18, 19, 50, 51
.byte   6,  7, 38, 39, 22, 23, 54, 55
.byte  10, 11, 42, 43, 26, 27, 58, 59
.byte  14, 15, 46, 47, 30, 31, 62, 63
.byte 128,129,160,161,144,145,176,177
.byte 132,133,164,165,148,149,180,181
.byte 136,137,168,169,152,153,184,185
.byte 140,141,172,173,156,157,188,189
.byte 128,129,160,161,144,145,176,177
.byte 132,133,164,165,148,149,180,181
.byte 136,137,168,169,152,153,184,185
.byte 140,141,172,173,156,157,188,189
.byte 130,131,162,163,146,147,178,179
.byte 134,135,166,167,150,151,182,183
.byte 138,139,170,171,154,155,186,187
.byte 142,143,174,175,158,159,190,191
.byte 130,131,162,163,146,147,178,179
.byte 134,135,166,167,150,151,182,183
.byte 138,139,170,171,154,155,186,187
.byte 142,143,174,175,158,159,190,191

.globl E1_Setup_Flags_Table
E1_Setup_Flags_Table:
.byte   0,  1,  0,  1,  0,  1,  0,  1
.byte   4,  5,  4,  5,  4,  5,  4,  5
.byte   8,  9,  8,  9,  8,  9,  8,  9
.byte  12, 13, 12, 13, 12, 13, 12, 13
.byte  16, 17, 16, 17, 16, 17, 16, 17
.byte  20, 21, 20, 21, 20, 21, 20, 21
.byte  24, 25, 24, 25, 24, 25, 24, 25
.byte  28, 29, 28, 29, 28, 29, 28, 29
.byte   2,  3,  2,  3,  2,  3,  2,  3
.byte   6,  7,  6,  7,  6,  7,  6,  7
.byte  10, 11, 10, 11, 10, 11, 10, 11
.byte  14, 15, 14, 15, 14, 15, 14, 15
.byte  18, 19, 18, 19, 18, 19, 18, 19
.byte  22, 23, 22, 23, 22, 23, 22, 23
.byte  26, 27, 26, 27, 26, 27, 26, 27
.byte  30, 31, 30, 31, 30, 31, 30, 31
.byte 128,129,128,129,128,129,128,129
.byte 132,133,132,133,132,133,132,133
.byte 136,137,136,137,136,137,136,137
.byte 140,141,140,141,140,141,140,141
.byte 144,145,144,145,144,145,144,145
.byte 148,149,148,149,148,149,148,149
.byte 152,153,152,153,152,153,152,153
.byte 156,157,156,157,156,157,156,157
.byte 130,131,130,131,130,131,130,131
.byte 134,135,134,135,134,135,134,135
.byte 138,139,138,139,138,139,138,139
.byte 142,143,142,143,142,143,142,143
.byte 146,147,146,147,146,147,146,147
.byte 150,151,150,151,150,151,150,151
.byte 154,155,154,155,154,155,154,155
.byte 158,159,158,159,158,159,158,159

E0_Restore_Flags_Table:
.long    0,   1,  64,  65,   8,   9,  72,  73
.long   16,  17,  80,  81,  24,  25,  88,  89
.long    4,   5,  68,  69,  12,  13,  76,  77
.long   20,  21,  84,  85,  28,  29,  92,  93
.long    2,   3,  66,  67,  10,  11,  74,  75
.long   18,  19,  82,  83,  26,  27,  90,  91
.long    6,   7,  70,  71,  14,  15,  78,  79
.long   22,  23,  86,  87,  30,  31,  94,  95
.long 2048,2049,2112,2113,2056,2057,2120,2121
.long 2064,2065,2128,2129,2072,2073,2136,2137
.long 2052,2053,2116,2117,2060,2061,2124,2125
.long 2068,2069,2132,2133,2076,2077,2140,2141
.long 2050,2051,2114,2115,2058,2059,2122,2123
.long 2066,2067,2130,2131,2074,2075,2138,2139
.long 2054,2055,2118,2119,2062,2063,2126,2127
.long 2070,2071,2134,2135,2078,2079,2142,2143
.long  128, 129, 192, 193, 136, 137, 200, 201
.long  144, 145, 208, 209, 152, 153, 216, 217
.long  132, 133, 196, 197, 140, 141, 204, 205
.long  148, 149, 212, 213, 156, 157, 220, 221
.long  130, 131, 194, 195, 138, 139, 202, 203
.long  146, 147, 210, 211, 154, 155, 218, 219
.long  134, 135, 198, 199, 142, 143, 206, 207
.long  150, 151, 214, 215, 158, 159, 222, 223
.long 2176,2177,2240,2241,2184,2185,2248,2249
.long 2192,2193,2256,2257,2200,2201,2264,2265
.long 2180,2181,2244,2245,2188,2189,2252,2253
.long 2196,2197,2260,2261,2204,2205,2268,2269
.long 2178,2179,2242,2243,2186,2187,2250,2251
.long 2194,2195,2258,2259,2202,2203,2266,2267
.long 2182,2183,2246,2247,2190,2191,2254,2255
.long 2198,2199,2262,2263,2206,2207,2270,2271

E1_Restore_Flags_Table:
.long    0,   1,  64,  65,   8,   9,  72,  73
.long   16,  17,  80,  81,  24,  25,  88,  89
.long   32,  33,  96,  97,  40,  41, 104, 105
.long   48,  49, 112, 113,  56,  57, 120, 121
.long    0,   1,  64,  65,   8,   9,  72,  73
.long   16,  17,  80,  81,  24,  25,  88,  89
.long   32,  33,  96,  97,  40,  41, 104, 105
.long   48,  49, 112, 113,  56,  57, 120, 121
.long 2048,2049,2112,2113,2056,2057,2120,2121
.long 2064,2065,2128,2129,2072,2073,2136,2137
.long 2080,2081,2144,2145,2088,2089,2152,2153
.long 2096,2097,2160,2161,2104,2105,2168,2169
.long 2048,2049,2112,2113,2056,2057,2120,2121
.long 2064,2065,2128,2129,2072,2073,2136,2137
.long 2080,2081,2144,2145,2088,2089,2152,2153
.long 2096,2097,2160,2161,2104,2105,2168,2169
.long  128, 129, 192, 193, 136, 137, 200, 201
.long  144, 145, 208, 209, 152, 153, 216, 217
.long  160, 161, 224, 225, 168, 168, 232, 233
.long  176, 177, 240, 241, 184, 185, 248, 249
.long  128, 129, 192, 193, 136, 137, 200, 201
.long  144, 145, 208, 209, 152, 153, 216, 217
.long  160, 161, 224, 225, 168, 168, 232, 233
.long  176, 177, 240, 241, 184, 185, 248, 249
.long 2176,2177,2240,2241,2184,2185,2248,2249
.long 2192,2193,2256,2257,2200,2201,2264,2265
.long 2208,2209,2272,2273,2216,2117,2280,2281
.long 2224,2225,2288,2289,2232,2233,2296,2297
.long 2176,2177,2240,2241,2184,2185,2248,2249
.long 2192,2193,2256,2257,2200,2201,2264,2265
.long 2208,2209,2272,2273,2216,2117,2280,2281
.long 2224,2225,2288,2289,2232,2233,2296,2297

CPU_Start_Table:
.long CPU_E0_START
.long CPU_Pm_START
.long CPU_Px_START
.long CPU_MX_START

CPU_SPC_Start_Table:
.long CPU_E0_SPC_START
.long CPU_Pm_SPC_START
.long CPU_Px_SPC_START
.long CPU_MX_SPC_START

CPU_Return_Table:
.long E0_RETURN_POSITION
.long Pm_RETURN_POSITION
.long Px_RETURN_POSITION
.long MX_RETURN_POSITION

CPU_SPC_Return_Table:
.long E0_SPC_RETURN_POSITION
.long Pm_SPC_RETURN_POSITION
.long Px_SPC_RETURN_POSITION
.long MX_SPC_RETURN_POSITION

IntDone:	.long	0		/* non zero when an interrupt has occured for WAI */

// NB: SNES_Cycles is the IRQ cycle count (0-IRQTrip)
//     SNES_Cycles2 is the counter for determining when to call SPC (0-16ish)

.globl SPC_Fixup
SPC_Fixup:  .long   0   // Number of CPU cycles to execute to redress balance
.globl SNES_Cycles
SNES_Cycles:	.long	0		/* Number of cycles executed for CPU */
SNES_Cycles2:	.long	0

.globl TM_MASK
TM_MASK:	.byte	0xff		/* This is used to force planes to disable! */
.globl SPR_MASK
SPR_MASK:   .byte   0xff        // This is used to force sprites to disable!
OldINIDISP:	.byte	0xcc		/* This is used to decide whether to change brightness etc! */
.globl PaletteChanged
PaletteChanged:	.byte	0		/* This is used to decide whether to change palette etc! */

.text
.balign 16				/* Align to paragraph */

.globl DO_INVALID
DO_INVALID:

	pusha

	movl SNES_ProgBank,%esi
    movw _SNES_PC,%si

	GET_BYTE

	movb %al,_Map_Byte

	popa

	movb %al,_Map_Byte		/* al contains opcode ! */

	movl SNES_ProgBank,%eax
	movw _SNES_PC,%ax
    movl %eax,_Map_Address  /* this just sets the error output up correctly! */

	call _InvalidOpcode		/* This exits.. avoids conflict with other things! */

	FUNC(_Do_CPU)
	ENTER
	movb $1,PaletteChanged		/* Incase we have come from the GUI! */

	cmpb $0,_SPC_ENABLED
	je 0f
	call MAKE_SPC
	call CPU_SPC_START
	jmp 1f

0:	call MAKE_APU
	call CPU_START
1:
	LEAVEL(L_Do_CPU)

/* ----------------------- START OF ASM CPU STUFF <NOT C LINK THINGS> --------------------- */


/* Ok there are 5!!! CPU looping functions (and 5 CPU+SPC) */

CPU_START:
    movl SNES_Flags,%eax
    testl $MASK_FLAG_E,%eax
    jnz CPU_E1_START        // 6502 emulation mode
    andl $6,%eax            // Mask out M & X flags
    jmpl CPU_Start_Table(,%eax,2)

/* START OF MULTIPLE CPU CORES... IN A TIGHT FISTED BUN... Maybe not! */

CPU_E0_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_E0_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb E0Cycles(%eax),%bl
    testl MEMSEL,%esi       // FastROM instruction?
    jnz 0f
    addl %ebx,%ebx          // SlowROM, timing * 4
    addl %ebx,%ebx
    jmp 1f
0:  leal (%ebx,%ebx,2),%ebx // FastROM, timing * 3
1:  incw %si
    movw %si,_SNES_PC
	movl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call E0OpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
E0_RETURN_POSITION:

	movl SNES_Cycles2,%eax
    addl SNES_Cycles,%eax       /* Update VBL cycle counter */

    movl %eax,SNES_Cycles
    subl IRQTrip,%eax
    jl CPU_E0_START2        /* Jump if less than IRQ Tripping value */

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_E0_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

CPU_Pm_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_Pm_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb PmCycles(%eax),%bl
    testl MEMSEL,%esi       // FastROM instruction?
    jnz 0f
    addl %ebx,%ebx          // SlowROM, timing * 4
    addl %ebx,%ebx
    jmp 1f
0:  leal (%ebx,%ebx,2),%ebx // FastROM, timing * 3
1:  incw %si
    movw %si,_SNES_PC
	movl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call PmOpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
Pm_RETURN_POSITION:

	movl SNES_Cycles2,%eax
    addl SNES_Cycles,%eax       /* Update VBL cycle counter */

    movl %eax,SNES_Cycles
    subl IRQTrip,%eax
    jl CPU_Pm_START2        /* Jump if less than IRQ Tripping value */

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_Pm_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

Px_RETURN_POSITION:
    andl $0xFF,_SNES_X
    andl $0xFF,_SNES_Y
    jmpl Px_RETURN_POSITION_2
CPU_Px_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_Px_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb PxCycles(%eax),%bl
    testl MEMSEL,%esi       // FastROM instruction?
    jnz 0f
    addl %ebx,%ebx          // SlowROM, timing * 4
    addl %ebx,%ebx
    jmp 1f
0:  leal (%ebx,%ebx,2),%ebx // FastROM, timing * 3
1:  incw %si
    movw %si,_SNES_PC
	movl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call PxOpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
Px_RETURN_POSITION_2:

	movl SNES_Cycles2,%eax
    addl SNES_Cycles,%eax       /* Update VBL cycle counter */

    movl %eax,SNES_Cycles
    subl IRQTrip,%eax
    jl CPU_Px_START2        /* Jump if less than IRQ Tripping value */

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_Px_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

MX_RETURN_POSITION:
    andl $0xFF,_SNES_X
    andl $0xFF,_SNES_Y
    jmpl MX_RETURN_POSITION_2
CPU_MX_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_MX_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb MXCycles(%eax),%bl
    testl MEMSEL,%esi       // FastROM instruction?
    jnz 0f
    addl %ebx,%ebx          // SlowROM, timing * 4
    addl %ebx,%ebx
    jmp 1f
0:  leal (%ebx,%ebx,2),%ebx // FastROM, timing * 3
1:  incw %si
    movw %si,_SNES_PC
	movl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call MXOpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
MX_RETURN_POSITION_2:

	movl SNES_Cycles2,%eax
    addl SNES_Cycles,%eax       /* Update VBL cycle counter */

    movl %eax,SNES_Cycles
    subl IRQTrip,%eax
    jl CPU_MX_START2        /* Jump if less than IRQ Tripping value */

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_MX_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

CPU_E1_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_E1_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb E1Cycles(%eax),%bl
    testl MEMSEL,%esi       // FastROM instruction?
    jnz 0f
    addl %ebx,%ebx          // SlowROM, timing * 4
    addl %ebx,%ebx
    jmp 1f
0:  leal (%ebx,%ebx,2),%ebx // FastROM, timing * 3
1:  incw %si
    movw %si,_SNES_PC
	movl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call E1OpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
E1_RETURN_POSITION:

	movl SNES_Cycles2,%eax
    addl SNES_Cycles,%eax       /* Update VBL cycle counter */

    movl %eax,SNES_Cycles
    subl IRQTrip,%eax
    jl CPU_E1_START2        /* Jump if less than IRQ Tripping value */

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_E1_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler


/* Ok there are 5!!! CPU looping functions (and 5 CPU+SPC) */

CPU_SPC_START:
    movl SNES_Flags,%eax
    testl $MASK_FLAG_E,%eax
    jnz CPU_E1_SPC_START    // 6502 emulation mode
    andl $6,%eax            // Mask out M & X flags
    jmpl CPU_SPC_Start_Table(,%eax,2)

CPU_E0_SPC_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_E0_SPC_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb E0Cycles(%eax),%bl
    incw %si
    movw %si,_SNES_PC
	addl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call E0OpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
E0_SPC_RETURN_POSITION:

	movl SNES_Cycles2,%eax
	cmpl SPC_Fixup,%eax
	jl CPU_E0_SPC_START2

    movl %eax,%ebx          // Don't lose cycles!!!
    andl $(~15),%eax
    andl $15,%ebx
    addl %eax,SNES_Cycles   // Update VBL cycle counter
    movl %ebx,SNES_Cycles2
    shrl $4,%eax            // Divide by 16
    leal (%eax,%eax,2),%eax // Multiply by 3
    addl %eax,SPC_Cycles    // Setup SPC cycles, added on purpose!

	call SPC_START

    movl SNES_Cycles,%eax
    subl IRQTrip,%eax
    jl CPU_E0_SPC_START2    // Jump if less than IRQ tripping value

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    call _SPC_UPDATEAUDIO
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_E0_SPC_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

CPU_Pm_SPC_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_Pm_SPC_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb PmCycles(%eax),%bl
    incw %si
    movw %si,_SNES_PC
	addl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call PmOpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
Pm_SPC_RETURN_POSITION:

	movl SNES_Cycles2,%eax
	cmpl SPC_Fixup,%eax
	jl CPU_Pm_SPC_START2

    movl %eax,%ebx          // Don't lose cycles!!!
    andl $(~15),%eax
    andl $15,%ebx
    addl %eax,SNES_Cycles   // Update VBL cycle counter
    movl %ebx,SNES_Cycles2
    shrl $4,%eax            // Divide by 16
    leal (%eax,%eax,2),%eax // Multiply by 3
    addl %eax,SPC_Cycles    // Setup SPC cycles, added on purpose!

	call SPC_START

    movl SNES_Cycles,%eax
    subl IRQTrip,%eax
    jl CPU_Pm_SPC_START2    // Jump if less than IRQ tripping value

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    call _SPC_UPDATEAUDIO
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_Pm_SPC_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

Px_SPC_RETURN_POSITION:
    andl $0xFF,_SNES_X
    andl $0xFF,_SNES_Y
    jmpl Px_SPC_RETURN_POSITION_2
CPU_Px_SPC_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_Px_SPC_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb PxCycles(%eax),%bl
    incw %si
    movw %si,_SNES_PC
	addl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call PxOpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
Px_SPC_RETURN_POSITION_2:

	movl SNES_Cycles2,%eax
	cmpl SPC_Fixup,%eax
	jl CPU_Px_SPC_START2

    movl %eax,%ebx          // Don't lose cycles!!!
    andl $(~15),%eax
    andl $15,%ebx
    addl %eax,SNES_Cycles   // Update VBL cycle counter
    movl %ebx,SNES_Cycles2
    shrl $4,%eax            // Divide by 16
    leal (%eax,%eax,2),%eax // Multiply by 3
    addl %eax,SPC_Cycles    // Setup SPC cycles, added on purpose!

	call SPC_START

    movl SNES_Cycles,%eax
    subl IRQTrip,%eax
    jl CPU_Px_SPC_START2    // Jump if less than IRQ tripping value

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    call _SPC_UPDATEAUDIO
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_Px_SPC_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

MX_SPC_RETURN_POSITION:
    andl $0xFF,_SNES_X
    andl $0xFF,_SNES_Y
    jmpl MX_SPC_RETURN_POSITION_2
CPU_MX_SPC_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_MX_SPC_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb MXCycles(%eax),%bl
    incw %si
    movw %si,_SNES_PC
	addl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call MXOpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
MX_SPC_RETURN_POSITION_2:

	movl SNES_Cycles2,%eax
	cmpl SPC_Fixup,%eax
	jl CPU_MX_SPC_START2

    movl %eax,%ebx          // Don't lose cycles!!!
    andl $(~15),%eax
    andl $15,%ebx
    addl %eax,SNES_Cycles   // Update VBL cycle counter
    movl %ebx,SNES_Cycles2
    shrl $4,%eax            // Divide by 16
    leal (%eax,%eax,2),%eax // Multiply by 3
    addl %eax,SPC_Cycles    // Setup SPC cycles, added on purpose!

	call SPC_START

    movl SNES_Cycles,%eax
    subl IRQTrip,%eax
    jl CPU_MX_SPC_START2    // Jump if less than IRQ tripping value

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    call _SPC_UPDATEAUDIO
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_MX_SPC_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

CPU_E1_SPC_START:
#ifdef DEBUG
	movl $0,_Timer_Counter_Profile
#endif
CPU_E1_SPC_START2:
    movl SNES_ProgBank,%esi // Get Program Bank Ready for Offset
    movw _SNES_PC,%si       // PC now setup
    xorl %ebx,%ebx
    xorl %eax,%eax          // Zero for table offset
    GET_BYTE                // Get opcode

    movb E1Cycles(%eax),%bl
    incw %si
    movw %si,_SNES_PC
	addl %ebx,SNES_Cycles2		/* Update Cycle Counter */

	call E1OpTable(,%eax,4)		/* jmp to function from table (*4 since DWORD table) */
E1_SPC_RETURN_POSITION:

	movl SNES_Cycles2,%eax
	cmpl SPC_Fixup,%eax
	jl CPU_E1_SPC_START2

    movl %eax,%ebx          // Don't lose cycles!!!
    andl $(~15),%eax
    andl $15,%ebx
    addl %eax,SNES_Cycles   // Update VBL cycle counter
    movl %ebx,SNES_Cycles2
    shrl $4,%eax            // Divide by 16
    leal (%eax,%eax,2),%eax // Multiply by 3
    addl %eax,SPC_Cycles    // Setup SPC cycles, added on purpose!

	call SPC_START

    movl SNES_Cycles,%eax
    subl IRQTrip,%eax
    jl CPU_E1_SPC_START2    // Jump if less than IRQ tripping value

    movl %eax,SNES_Cycles
#ifdef DEBUG
    movl _Timer_Counter_Profile,%eax
    addl %eax,_Total_CPU
#endif
    call _SPC_UPDATEAUDIO
    movl IRQ_Handler,%ebx
    movl HDMAYCount,%eax
    pushl $CPU_E1_SPC_START
    jmpl (%ebx,%eax,4)      // Call IRQ handler

.globl NMI
NMI:call Copy_Screen
.globl NMI_NoRender
NMI_NoRender:
//#ifdef ELF
    pusha
    call RegUpdate
    popa
//#endif
#ifdef DEBUG
//  call _Display_Debug
#endif
    call UPDATE_CONTROLLERS  // New for v0.13, seperated for emulation of JOYC1

    movb $0x80,RDNMI        // Set NMI enabled bit in 0x4210
    movb $0x81,HVBJOY       // VBlank on
    incl HDMAYCount
	movw VBLANKOAMAddress,%ax
	movw %ax,OAMAddress		/* Restore Sprite address every VBLANK! */

/*	jmp FRAME_CHECK*/	/* REM THIS TO RESTORE PALETTE DALE ! */

/* For now I`ll check the variable pallette stuff every frame */

	movb INIDISP,%al
	cmpb %al,OldINIDISP		/* Has screen brightess changed or screen off? */
    je  DO_PALETTE

	movb %al,OldINIDISP

PALETTE_CHECK:
    cmpb $0,PaletteChanged  /* If 1, palette changed! */
    jz CHECK_KEYS
DO_PALETTE:
	movb $0,PaletteChanged

	pusha

	call _SetPalette		/* A more VESA friendly method of setting the palette */

	popa

CHECK_KEYS:
    JUMP_KEY_UP KEY_1,0f        // Disable/enable BKG 1
    xorb $1,TM_MASK
1:  JUMP_KEY_DOWN KEY_1,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_2,0f        // Disable/enable BKG 2
    xorb $2,TM_MASK
1:  JUMP_KEY_DOWN KEY_2,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_3,0f        // Disable/enable BKG 3
    xorb $4,TM_MASK
1:  JUMP_KEY_DOWN KEY_3,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_4,0f        // Disable/enable BKG 4
    xorb $8,TM_MASK
1:  JUMP_KEY_DOWN KEY_4,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_5,0f        // Disable/enable sprites
    xorb $0x10,TM_MASK
1:  JUMP_KEY_DOWN KEY_5,1b      // Wait for key release

0:  // Update layer mask
    movb TM,%al
    orb  TD,%al
    andb TM_MASK,%al
	movb %al,SCR_TM

    JUMP_KEY_UP KEY_6,0f        // Disable/enable plane 0 sprites
    xorb $1,SPR_MASK
1:  JUMP_KEY_DOWN KEY_6,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_7,0f        // Disable/enable plane 1 sprites
    xorb $2,SPR_MASK
1:  JUMP_KEY_DOWN KEY_7,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_8,0f        // Disable/enable plane 2 sprites
    xorb $4,SPR_MASK
1:  JUMP_KEY_DOWN KEY_8,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_9,0f        // Disable/enable plane 3 sprites
    xorb $8,SPR_MASK
1:  JUMP_KEY_DOWN KEY_9,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_F1,0f       // Disable/enable channel 0
    xorb $1,SPC_MASK
1:  JUMP_KEY_DOWN KEY_F1,1b     // Wait for key release

0:  JUMP_KEY_UP KEY_F2,0f       // Disable/enable channel 1
    xorb $2,SPC_MASK
1:  JUMP_KEY_DOWN KEY_F2,1b     // Wait for key release

0:  JUMP_KEY_UP KEY_F3,0f       // Disable/enable channel 2
    xorb $4,SPC_MASK
1:  JUMP_KEY_DOWN KEY_F3,1b     // Wait for key release

0:  JUMP_KEY_UP KEY_F4,0f       // Disable/enable channel 3
    xorb $8,SPC_MASK
1:  JUMP_KEY_DOWN KEY_F4,1b     // Wait for key release

0:  JUMP_KEY_UP KEY_F5,0f       // Disable/enable channel 4
    xorb $0x10,SPC_MASK
1:  JUMP_KEY_DOWN KEY_F5,1b     // Wait for key release

0:  JUMP_KEY_UP KEY_F6,0f       // Disable/enable channel 5
    xorb $0x20,SPC_MASK
1:  JUMP_KEY_DOWN KEY_F6,1b     // Wait for key release

0:  JUMP_KEY_UP KEY_F7,0f       // Disable/enable channel 6
    xorb $0x40,SPC_MASK
1:  JUMP_KEY_DOWN KEY_F7,1b     // Wait for key release

0:  JUMP_KEY_UP KEY_F8,0f       // Disable/enable channel 7
    xorb $0x80,SPC_MASK
1:  JUMP_KEY_DOWN KEY_F8,1b     // Wait for key release

0:  JUMP_KEY_UP KEY_0,0f        // Save PCX Picture

	pusha
	call _OutputScreen__Fv
	popa

1:  JUMP_KEY_DOWN KEY_0,1b      // Wait for key release

0:  JUMP_KEY_UP KEY_ESC,CPU_INT // Is ESC pressed?

	pusha

    movl SNES_ProgBank,%esi
	movw _SNES_PC,%si
#ifdef DEBUG
    movb _SNES_PB,%al
    movb %al,_OLD_PB        // Save program bank
    movl _SNES_PC,%eax
    movl %eax,_OLD_PC       // Save program counter
#endif

	GET_BYTE

	movb %al,_Map_Byte

#ifdef DEBUG
	movb SPC_PORT_0_R,%al
	movb %al,_PORT0R
	movb SPC_PORT_1_R,%al
	movb %al,_PORT1R
	movb SPC_PORT_2_R,%al
	movb %al,_PORT2R
	movb SPC_PORT_3_R,%al
	movb %al,_PORT3R
	movb SPC_PORT_0_W,%al
	movb %al,_PORT0W
	movb SPC_PORT_1_W,%al
	movb %al,_PORT1W
	movb SPC_PORT_2_W,%al
	movb %al,_PORT2W
	movb SPC_PORT_3_W,%al
	movb %al,_PORT3W
	movb APUI00a,%al
	movb %al,_APUI00a
	movb APUI00b,%al
	movb %al,_APUI00b
	movb APUI00c,%al
	movb %al,_APUI00c
#endif
	popa

    addl $4,%esp    // Get rid of previous return value

CPU_INT:
    testb $0x80,NMITIMEN
    jnz 0f           // NMI off? (Via Hardware Register)

    ret

0:  JUMP_NOT_FLAG SNES_FLAG_E,Int_16 // Are we in emulation mode?

	movb _SNES_PC+1,%al
    E1_PUSH_B
	movb _SNES_PC,%al
	E1_PUSH_B
    E1_SETUPFLAGS           // put flags into SNES packed flag format
	E1_PUSH_B

    movl /*INT_BANK*/$0,%esi    // Ensures interrupts work in HiROM mode
    movl %esi,SNES_ProgBank // Setup bank
	movw $0xfffa,%si
	jmp Int_End
Int_16:
    movb _SNES_PB,%al
	E0_PUSH_B
	movb _SNES_PC+1,%al
	E0_PUSH_B
	movb _SNES_PC,%al
	E0_PUSH_B
    E0_SETUPFLAGS           // put flags into SNES packed flag format
	E0_PUSH_B

    movl /*INT_BANK*/$0,%esi    // Ensures interrupts work in HiROM mode
    movl %esi,SNES_ProgBank // Setup bank
	movw $0xffea,%si
Int_End:
    SET_FLAG(SNES_FLAG_I)   // Disable interrupts
	CLR_FLAG(SNES_FLAG_D)
	GET_WORD
	movw %ax,_SNES_PC

    movl $1,IntDone         /* Set Interrupt Done Status */
	ret

	FUNC(_Reset_CPU)
	ENTER

/* Due to an incredably lame assembler (DJGPP) I have had to do this here */

    cmpl $0xC00000,_INT_BANK  // Test for HiROM
	jne 0f
    call COPY_HIROM         // Setup HiROM mapping
	jmp 1f
0:  call COPY_LOROM         // Setup LoROM mapping
1:  movl $16,SPC_Fixup      // Set initial balance
    xorl %eax,%eax
    movl %eax,SNES_Cycles   // Clear cycle counts
    movl %eax,SNES_Cycles2
    movl %eax,_SNES_A       // Clear A, D, X, Y
    movl %eax,_SNES_D
    movl %eax,_SNES_X
    movl %eax,_SNES_Y
    movl %eax,SNES_DataBank // Clear data bank register
    // Initialize flags
    movl $(MASK_FLAG_1+MASK_FLAG_E+MASK_FLAG_I+ \
           MASK_FLAG_X+MASK_FLAG_M+MASK_FLAG_B),SNES_Flags
    movl $0,SNES_ProgBank       // Setup bank
    movl $0x01FF,_SNES_S
	movl _RomAddress,%eax		/* Get Address of Rom Data */
    addl RESET_VECTOR,%eax      /* Get Location of Rom Reset Vector */
    movzwl (%eax),%eax
    movl %eax,_SNES_PC      /* Setup PC Vector */

	LEAVEL(L_Reset_CPU)

COPY_HIROM:
    movl $4096,%ecx         /* 4096 elements in the table! */
	movl $Read_BankMapping,%edi	/* Destination */
	movl $HI_ROM_READ,%esi		/* Source */
    rep
    movsl

    movl $4096,%ecx         /* 4096 elements in the table! */
	movl $Write_BankMapping,%edi	/* Destination */
	movl $HI_ROM_WRITE,%esi		/* Source */
    rep
    movsl
	ret

COPY_LOROM:
    movl $4096,%ecx         /* 4096 elements in the table! */
	movl $Read_BankMapping,%edi	/* Destination */
	movl $LO_ROM_READ,%esi		/* Source */
    rep
    movsl

    movl $4096,%ecx         /* 4096 elements in the table! */
	movl $Write_BankMapping,%edi	/* Destination */
	movl $LO_ROM_WRITE,%esi		/* Source */
    rep
    movsl
	ret

#define BANK_B(variable) (variable+2)

#include "addr.S"		/* Include addressing mode macros */
#include "cpuMacro.S"		/* Include CPU Macros... these are used to aid in quicker code generation */

#include "CPU0.S"		/* Include opcodes 0x00-0x0F */
#include "CPU1.S"		/* Include opcodes 0x10-0x1F */
#include "CPU2.S"		/* Include opcodes 0x20-0x2F */
#include "CPU3.S"		/* Include opcodes 0x30-0x3F */
#include "CPU4.S"		/* Include opcodes 0x40-0x4F */
#include "CPU5.S"		/* Include opcodes 0x50-0x5F */
#include "CPU6.S"		/* Include opcodes 0x60-0x6F */
#include "CPU7.S"		/* Include opcodes 0x70-0x7F */
#include "CPU8.S"		/* Include opcodes 0x80-0x8F */
#include "CPU9.S"		/* Include opcodes 0x90-0x9F */
#include "CPUA.S"		/* Include opcodes 0xA0-0xAF */
#include "CPUB.S"		/* Include opcodes 0xB0-0xBF */
#include "CPUC.S"		/* Include opcodes 0xC0-0xCF */
#include "CPUD.S"		/* Include opcodes 0xD0-0xDF */
#include "CPUE.S"		/* Include opcodes 0xE0-0xEF */
#include "CPUF.S"		/* Include opcodes 0xF0-0xFF */


.globl MENTAL
MENTAL:			/* Temp hack, converts 256 cols to 65536 col screen */
	call _CopySNESScreen		/* Redraw VGA Mode Screen */
        popa
	ret



