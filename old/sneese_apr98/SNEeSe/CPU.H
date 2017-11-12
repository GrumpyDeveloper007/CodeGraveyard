#define SNES_Flags _SNES_F  // Flags Register - See information at top! */
#define SNES_ProgBank _SNES_ProgBank
#define _SNES_PB (SNES_ProgBank+2)
#define FRAME_SKIP _FRAME_SKIP
#define INT_BANK _INT_BANK
#define RESET_VECTOR _RESET_VECTOR

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

.macro  SET_FLAG bitnumber
 orl  $(1<<\bitnumber),SNES_Flags
.endm

.macro  CLR_FLAG bitnumber
 andl $(~(1<<\bitnumber)),SNES_Flags
.endm

.macro  CPL_FLAG bitnumber
 xorl $(1<<\bitnumber),SNES_Flags
.endm

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
