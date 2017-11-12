/*

 CPU Opcodes 0xE0-0xEF Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   CPX #   | SBC (d,x) |   SEP #   |  SBC d,s  |
|    2 2    |    2 6    |    2 3    |    2 4    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   CPX d   |   SBC d   |   INC d   |  SBC [d]  |
|    2 3    |    2 3    |    2 5    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   INX i   |   SBC #   |   NOP i   |   XBA i   |
|    1 2    |    2 2    |    1 2    |    1 3    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   CPX a   |   SBC a   |   INC a   |  SBC al   |
|    3 4    |    3 4    |    3 6    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* E0 */

EX_CPX_i:
	EX_CPX IMMEDIATE_ADDR
	incw _SNES_PC
	ret
E0_CPX_i:
	E0_CPX IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* E1 */

EM_SBC_Od_xO:
	EM_SBC DIRECT_INDEX_INDIRECT_X_ADDR
	ret
E0_SBC_Od_xO:
	E0_SBC DIRECT_INDEX_INDIRECT_X_ADDR
	ret

/* E2 */

.macro	SEP_BIT bitnum,flag
    testb $(1<<\bitnum),%al
    jz  9f
    orl $(1<<\flag),%ebx
9:
.endm

E0_SEP:
	IMMEDIATE_ADDR
	incw _SNES_PC
	GET_BYTE

    movl SNES_Flags,%ebx
	SEP_BIT 7,SNES_FLAG_N
	SEP_BIT 6,SNES_FLAG_V
	SEP_BIT 5,SNES_FLAG_M
	SEP_BIT 4,SNES_FLAG_X
	SEP_BIT 3,SNES_FLAG_D
	SEP_BIT 2,SNES_FLAG_I
	SEP_BIT 1,SNES_FLAG_Z
	SEP_BIT 0,SNES_FLAG_C
    movl %ebx,SNES_Flags

    SET_TABLE_MX

	ret

E1_SEP:
	IMMEDIATE_ADDR
	incw _SNES_PC
	GET_BYTE

    movl SNES_Flags,%ebx
	SEP_BIT 7,SNES_FLAG_N
	SEP_BIT 6,SNES_FLAG_V
	SEP_BIT 3,SNES_FLAG_D
	SEP_BIT 2,SNES_FLAG_I
	SEP_BIT 1,SNES_FLAG_Z
	SEP_BIT 0,SNES_FLAG_C
    movl %ebx,SNES_Flags

	ret

/* E3 */

EM_SBC_d_s:
	EM_SBC STACK_RELATIVE_ADDR
	ret
E0_SBC_d_s:
	E0_SBC STACK_RELATIVE_ADDR
	ret

/* E4 */

EX_CPX_d:
	EX_CPX DIRECT_ADDR
	ret
E0_CPX_d:
	E0_CPX DIRECT_ADDR
	ret

/* E5 */

EM_SBC_d:
	EM_SBC DIRECT_ADDR
	ret
E0_SBC_d:
	E0_SBC DIRECT_ADDR
	ret

/* E6 */

EM_INC_d:
	EM_INC DIRECT_ADDR
	ret
E0_INC_d:
	E0_INC DIRECT_ADDR
	ret

/* E7 */

EM_SBC_IdI:
	EM_SBC DIRECT_INDIRECT_LONG_ADDR
	ret
E0_SBC_IdI:
	E0_SBC DIRECT_INDIRECT_LONG_ADDR
	ret

/* E8 */

EX_INX:
	incb _SNES_X
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_INX:
	incw _SNES_X
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* E9 */

EM_SBC_i:
	EM_SBC IMMEDIATE_ADDR
	incw _SNES_PC			/* Needed cos Immediate does not update PC */
	ret
E0_SBC_i:
	E0_SBC IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* EA */

ALL_NOP:
	ret

/* EB */

ALL_XBA:
	movw _SNES_A,%ax
    xchgb %al,%ah
	movw %ax,_SNES_A
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* EC */

EX_CPX_a:
	EX_CPX ABSOLUTE_ADDR
	ret
E0_CPX_a:
	E0_CPX ABSOLUTE_ADDR
	ret

/* ED */

EM_SBC_a:
	EM_SBC ABSOLUTE_ADDR
	ret
E0_SBC_a:
	E0_SBC ABSOLUTE_ADDR
	ret

/* EE */

EM_INC_a:
	EM_INC ABSOLUTE_ADDR
	ret
E0_INC_a:
	E0_INC ABSOLUTE_ADDR
	ret

/* EF */

EM_SBC_al:
	EM_SBC ABSOLUTE_LONG_ADDR
	ret
E0_SBC_al:
	E0_SBC ABSOLUTE_LONG_ADDR
	ret
