/*

 CPU Opcodes 0x60-0x6F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   RTS s   | ADC (d,x) |   PER s   |  ADC d,s  |
|    1 6    |    2 6    |    3 6    |    2 4    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   STZ d   |   ADC d   |   ROR d   |  ADC [d]  |
|    2 3    |    2 3    |    2 5    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   PLA s   |   ADC #   |   ROR A   |   RTL s   |
|    1 4    |    2 2    |    1 2    |    1 6    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|  JMP (a)  |   ADC a   |   ROR a   |   ADC al  |
|    3 5    |    3 4    |    3 6    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 60 */

E0_RTS:
	E0_POP_W
    incl %eax               /* This is a MAD processor! */
	movw %ax,_SNES_PC
	ret
E1_RTS:
	E1_POP_W
    incl %eax               /* This is a MAD processor! */
	movw %ax,_SNES_PC
	ret

/* 61 */

EM_ADC_Od_xO:
	EM_ADC DIRECT_INDEX_INDIRECT_X_ADDR
	ret
E0_ADC_Od_xO:
	E0_ADC DIRECT_INDEX_INDIRECT_X_ADDR
	ret

/* 62 */

E0_PER:				/* Push PC Relative address onto stack */
	IMMEDIATE_ADDR
    addw $2,_SNES_PC
	GET_WORD
	addw _SNES_PC,%ax
	E0_PUSH_W
	ret
E1_PER:
	IMMEDIATE_ADDR
    addw $2,_SNES_PC
	GET_WORD
	addw _SNES_PC,%ax
	E1_PUSH_W
	ret

/* 63 */

EM_ADC_d_s:
	EM_ADC STACK_RELATIVE_ADDR
	ret
E0_ADC_d_s:
	E0_ADC STACK_RELATIVE_ADDR
	ret

/* 64 */

EM_STZ_d:				/* Zero Direct Offset */
	EM_STZ DIRECT_ADDR
	ret
E0_STZ_d:
	E0_STZ DIRECT_ADDR
	ret

/* 65 */

EM_ADC_d:
	EM_ADC DIRECT_ADDR
	ret
E0_ADC_d:
	E0_ADC DIRECT_ADDR
	ret

/* 66 */

EM_ROR_d:						/* Ror d */
	EM_ROR DIRECT_ADDR
	ret
E0_ROR_d:
	E0_ROR DIRECT_ADDR
	ret

/* 67 */

EM_ADC_IdI:
	EM_ADC DIRECT_INDIRECT_LONG_ADDR
	ret
E0_ADC_IdI:
	E0_ADC DIRECT_INDIRECT_LONG_ADDR
	ret

/* 68 */

E0_PLA:				/* Pop A off stack */
	E0_POP_W
	movw %ax,_SNES_A
    testw %ax,%ax       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
EM_PLA:
	E0_POP_B
	movb %al,_SNES_A
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E1_PLA:
	E1_POP_B
	movb %al,_SNES_A
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 69 */

EM_ADC_i:
	EM_ADC IMMEDIATE_ADDR
	incw _SNES_PC
	ret
E0_ADC_i:
	E0_ADC IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* 6A */

EM_RRA:						/* Ror A */
	MAKE_FLAGS (MASK_FLAG_C)
    movb _SNES_A,%al
    rcrb $1,%al
    movb %al,_SNES_A
	STORE_FLAGS (MASK_FLAG_C)
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_RRA:
	MAKE_FLAGS (MASK_FLAG_C)
    movl _SNES_A,%eax
    rcrw $1,%ax
    movl %eax,_SNES_A
	STORE_FLAGS (MASK_FLAG_C)
    cmpw $0,_SNES_A
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 6B */

E0_RTL:
	E0_POP_W
	incw %ax				/* This is a MAD processor! */
	movw %ax,_SNES_PC
	E0_POP_B
    movb %al,_SNES_PB
	ret
E1_RTL:
	E1_POP_W
	incw %ax				/* This is a MAD processor! */
	movw %ax,_SNES_PC
	E1_POP_B
    movb %al,_SNES_PB
	ret

/* 6C */

ALL_JMP_OaO:				/* JMP Absolute address (a)*/
	ABSOLUTE_INDIRECT_ADDR
	GET_WORD
	movw %ax,_SNES_PC		/* Only want lo-word */
	ret

/* 6D */

EM_ADC_a:
	EM_ADC ABSOLUTE_ADDR
	ret
E0_ADC_a:
	E0_ADC ABSOLUTE_ADDR
	ret

/* 6E */

EM_ROR_a:						/* Ror a */
	EM_ROR ABSOLUTE_ADDR
	ret
E0_ROR_a:
	E0_ROR ABSOLUTE_ADDR
	ret

/* 6F */

EM_ADC_al:
	EM_ADC ABSOLUTE_LONG_ADDR
	ret
E0_ADC_al:
	E0_ADC ABSOLUTE_LONG_ADDR
	ret
