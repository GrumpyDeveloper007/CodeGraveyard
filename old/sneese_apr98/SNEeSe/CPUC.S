/*

 CPU Opcodes 0xC0-0xCF Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   CPY #   | CMP (d,x) |   REP #   |  CMP d,s  |
|    2 2    |    2 6    |    2 3    |    2 4    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   CPY d   |   CMP d   |   DEC d   |  CMP [d]  |
|    2 3    |    2 3    |    2 5    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   INY i   |   CMP #   |   DEX i   |   WAI i   |
|    1 2    |    2 2    |    1 2    |    1 3    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   CPY a   |   CMP a   |   DEC a   |  CMP al   |
|    3 4    |    3 4    |    3 4    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* C0 */

EX_CPY_i:
	EX_CPY IMMEDIATE_ADDR
	incw _SNES_PC
	ret
E0_CPY_i:
	E0_CPY IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* C1 */

EM_CMP_Od_xO:
	EM_CMP DIRECT_INDEX_INDIRECT_X_ADDR
	ret
E0_CMP_Od_xO:
	E0_CMP DIRECT_INDEX_INDIRECT_X_ADDR
	ret

/* C2 */

/* Special Macro To Save Typing in REP instruction */

.macro	REP_BIT bitnum,flag
    testb $(1<<\bitnum),%al
    jz  9f
    andl $(~(1<<\flag)),%ebx
9:
.endm

E0_REP:
	IMMEDIATE_ADDR
	incw _SNES_PC

	GET_BYTE

    movl SNES_Flags,%ebx
	REP_BIT 7,SNES_FLAG_N
	REP_BIT 6,SNES_FLAG_V
	REP_BIT 5,SNES_FLAG_M
	REP_BIT 4,SNES_FLAG_X
	REP_BIT 3,SNES_FLAG_D
	REP_BIT 2,SNES_FLAG_I
	REP_BIT 1,SNES_FLAG_Z
	REP_BIT 0,SNES_FLAG_C
    movl %ebx,SNES_Flags

	SET_TABLE_MX

	ret

E1_REP:
	IMMEDIATE_ADDR
	incw _SNES_PC
	GET_BYTE

    movl SNES_Flags,%ebx
	REP_BIT 7,SNES_FLAG_N
	REP_BIT 6,SNES_FLAG_V
	REP_BIT 3,SNES_FLAG_D
	REP_BIT 2,SNES_FLAG_I
	REP_BIT 1,SNES_FLAG_Z
	REP_BIT 0,SNES_FLAG_C
    movl %ebx,SNES_Flags

	ret

/* C3 */

EM_CMP_d_s:
	EM_CMP STACK_RELATIVE_ADDR
	ret
E0_CMP_d_s:
	E0_CMP STACK_RELATIVE_ADDR
	ret

/* C4 */

EX_CPY_d:
	EX_CPY DIRECT_ADDR
	ret
E0_CPY_d:
	E0_CPY DIRECT_ADDR
	ret

/* C5 */

EM_CMP_d:
	EM_CMP DIRECT_ADDR
	ret
E0_CMP_d:
	E0_CMP DIRECT_ADDR
	ret

/* C6 */

EM_DEC_d:
	EM_DEC DIRECT_ADDR
	ret
E0_DEC_d:
	E0_DEC DIRECT_ADDR
	ret

/* C7 */

EM_CMP_IdI:
	EM_CMP DIRECT_INDIRECT_LONG_ADDR
	ret
E0_CMP_IdI:
	E0_CMP DIRECT_INDIRECT_LONG_ADDR
	ret

/* C8 */

EX_INY:
	incb _SNES_Y
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_INY:
	incw _SNES_Y
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* C9 */

EM_CMP_i:
	EM_CMP IMMEDIATE_ADDR
	incw _SNES_PC
	ret
E0_CMP_i:
	E0_CMP IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* CA */

EX_DEX:
	decb _SNES_X
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_DEX:
	decw _SNES_X
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* CB */

ALL_WAI:			/* Wait for interrupt before continuing */
	cmpl $0,IntDone		/* has an interrupt occured */
	jnz 9f			/* yes */
	decw _SNES_PC
	ret
9:	movl $0,IntDone		/* Reset interrupt status */
	ret	

/* CC */

EX_CPY_a:
	EX_CPY ABSOLUTE_ADDR
	ret
E0_CPY_a:
	E0_CPY ABSOLUTE_ADDR
	ret

/* CD */

EM_CMP_a:
	EM_CMP ABSOLUTE_ADDR
	ret
E0_CMP_a:
	E0_CMP ABSOLUTE_ADDR
	ret

/* CE */

EM_DEC_a:
	EM_DEC ABSOLUTE_ADDR
	ret
E0_DEC_a:
	E0_DEC ABSOLUTE_ADDR
	ret

/* CF */

EM_CMP_al:
	EM_CMP ABSOLUTE_LONG_ADDR
	ret
E0_CMP_al:
	E0_CMP ABSOLUTE_LONG_ADDR
	ret

