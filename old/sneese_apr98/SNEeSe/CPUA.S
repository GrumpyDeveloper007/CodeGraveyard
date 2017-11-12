/*

 CPU Opcodes 0xA0-0xAF Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   LDY #   | LDA (d,x) |   LDX #   |  LDA d,s  |
|    2 2    |    2 6    |    2 2    |    2 4    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   LDY d   |   LDA d   |   LDX d   |  LDA [d]  |
|    2 3    |    2 3    |    2 3    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   TAY i   |   LDA #   |   TAX i   |   PLB s   |
|    1 2    |    2 2    |    1 2    |    1 4    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   LDY a   |   LDA a   |   LDX a   |   LDA al  |
|    3 4    |    3 4    |    3 4    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* A0 */

EX_LDY_i:			/* Put Immediate into Y */
	EX_LDY IMMEDIATE_ADDR
	incw _SNES_PC
	ret
E0_LDY_i:
	E0_LDY IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* A1 */

EM_LDA_Od_xO:			/* Put Direct index indirect x into A */
	EM_LDA DIRECT_INDEX_INDIRECT_X_ADDR
	ret
E0_LDA_Od_xO:
	E0_LDA DIRECT_INDEX_INDIRECT_X_ADDR
	ret

/* A2 */

EX_LDX_i:			/* Put Immediate into X */
	EX_LDX IMMEDIATE_ADDR
	incw _SNES_PC
	ret
E0_LDX_i:
	E0_LDX IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* A3 */

EM_LDA_d_s:			/* Put Stack Relative into A */
	EM_LDA STACK_RELATIVE_ADDR
	ret
E0_LDA_d_s:
	E0_LDA STACK_RELATIVE_ADDR
	ret

/* A4 */

EX_LDY_d:
	EX_LDY DIRECT_ADDR
	ret
E0_LDY_d:
	E0_LDY DIRECT_ADDR
	ret

/* A5 */

EM_LDA_d:			/* Put Direct into A */
	EM_LDA DIRECT_ADDR
	ret
E0_LDA_d:
	E0_LDA DIRECT_ADDR
	ret

/* A6 */

EX_LDX_d:
	EX_LDX DIRECT_ADDR
	ret
E0_LDX_d:
	E0_LDX DIRECT_ADDR
	ret

/* A7 */

EM_LDA_IdI:
	EM_LDA DIRECT_INDIRECT_LONG_ADDR
	ret
E0_LDA_IdI:
	E0_LDA DIRECT_INDIRECT_LONG_ADDR
	ret

/* A8 */

EX_TAY:
	movb _SNES_A,%al
	movb %al,_SNES_Y
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_TAY:
    movl _SNES_A,%eax
    movl %eax,_SNES_Y
    testw %ax,%ax   // cx was being checked before, gah!
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* A9 */

EM_LDA_i:			/* Put Immediate into A */
	EM_LDA IMMEDIATE_ADDR
	incw _SNES_PC		/* Needed cos Immediate does not update PC */
	ret
E0_LDA_i:
	E0_LDA IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* AA */

EX_TAX:
	movb _SNES_A,%al
	movb %al,_SNES_X
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_TAX:
    movl _SNES_A,%eax
    movl %eax,_SNES_X
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* AB */

E0_PLB:				/* Pop DB off stack */
	E0_POP_B
    movb %al,_SNES_DB
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

E1_PLB:
	E1_POP_B
    movb %al,_SNES_DB
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* AC */

EX_LDY_a:
	EX_LDY ABSOLUTE_ADDR
	ret
E0_LDY_a:
	E0_LDY ABSOLUTE_ADDR
	ret

/* AD */

EM_LDA_a:			/* Put Absolute into A */
	EM_LDA ABSOLUTE_ADDR
	ret
E0_LDA_a:
	E0_LDA ABSOLUTE_ADDR
	ret

/* AE */

EX_LDX_a:
	EX_LDX ABSOLUTE_ADDR
	ret
E0_LDX_a:
	E0_LDX ABSOLUTE_ADDR
	ret

/* AF */

EM_LDA_al:			/* Put Absolute long into A */
	EM_LDA ABSOLUTE_LONG_ADDR
	ret
E0_LDA_al:
	E0_LDA ABSOLUTE_LONG_ADDR
	ret
