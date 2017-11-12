/*

 CPU Opcodes 0x80-0x8F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BRA r   | STA (d,x) |   BRL rl  |  STA d,s  |
|    2 2    |    2 6    |    3 3    |    2 4    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   STY d   |   STA d   |   STX d   |  STA [d]  |
|    2 3    |    2 3    |    2 3    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   DEY i   |   BIT #   |   TXA i   |   PHB s   |
|    1 2    |    2 2    |    1 2    |    1 3    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   STY a   |   STA a   |   STX a   |  STA al   |
|    3 4    |    3 4    |    3 4    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 80 */

ALL_BRA:
	IMMEDIATE_ADDR
	GET_BYTE
	cbw
    incw %ax
	addw %ax,_SNES_PC
	ret

/* 81 */

EM_STA_Od_xO:				/* Put A at Direct index indirect x*/
	EM_STA DIRECT_INDEX_INDIRECT_X_ADDR
	ret
E0_STA_Od_xO:
	E0_STA DIRECT_INDEX_INDIRECT_X_ADDR
	ret

/* 82 */

ALL_BRL:				/* Branch always long (-32768 to 32767) */
	IMMEDIATE_ADDR
	GET_WORD
    addl $2,%eax
	addw %ax,_SNES_PC
	ret

/* 83 */

EM_STA_d_s:				/* Put A at stack relative */
	EM_STA STACK_RELATIVE_ADDR
	ret
E0_STA_d_s:
	E0_STA STACK_RELATIVE_ADDR
	ret

/* 84 */

EX_STY_d:
	EX_STY DIRECT_ADDR
	ret
E0_STY_d:
	E0_STY DIRECT_ADDR
	ret

/* 85 */

EM_STA_d:				/* Put A at Direct */
	EM_STA DIRECT_ADDR
	ret
E0_STA_d:
	E0_STA DIRECT_ADDR
	ret

/* 86 */

EX_STX_d:
	EX_STX DIRECT_ADDR
	ret
E0_STX_d:
	E0_STX DIRECT_ADDR
	ret

/* 87 */

EM_STA_IdI:
	EM_STA DIRECT_INDIRECT_LONG_ADDR
	ret
E0_STA_IdI:
	E0_STA DIRECT_INDIRECT_LONG_ADDR
	ret

/* 88 */

EX_DEY:
	decb _SNES_Y
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_DEY:
	decw _SNES_Y
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 89 */	/* Differs from norm, only sets Z flag */

EM_BIT_i:
	IMMEDIATE_ADDR
	GET_BYTE
	andb _SNES_A,%al		/* Flag Z is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z)
	incw _SNES_PC
	ret
E0_BIT_i:
	IMMEDIATE_ADDR
	GET_WORD
	andw _SNES_A,%ax		/* Flag Z is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z)
    addw $2,_SNES_PC
	ret

/* 8A */

EM_TXA:
	movb _SNES_X,%al
	movb %al,_SNES_A
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_TXA:
    movl _SNES_X,%eax
    movl %eax,_SNES_A
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 8B */

E0_PHB:				/* Push DB onto stack */
    movb _SNES_DB,%al
	E0_PUSH_B
	ret
E1_PHB:
    movb _SNES_DB,%al
	E1_PUSH_B
	ret

/* 8C */

EX_STY_a:
	EX_STY ABSOLUTE_ADDR
	ret
E0_STY_a:
	E0_STY ABSOLUTE_ADDR
	ret

/* 8D */

EM_STA_a:				/* Put A at Absolute */
	EM_STA ABSOLUTE_ADDR
	ret
E0_STA_a:
	E0_STA ABSOLUTE_ADDR
	ret

/* 8E */

EX_STX_a:
	EX_STX ABSOLUTE_ADDR
	ret
E0_STX_a:
	E0_STX ABSOLUTE_ADDR
	ret

/* 8F */

EM_STA_al:				/* Put A at Absolute long*/
	EM_STA ABSOLUTE_LONG_ADDR
	ret
E0_STA_al:
	E0_STA ABSOLUTE_LONG_ADDR
	ret
