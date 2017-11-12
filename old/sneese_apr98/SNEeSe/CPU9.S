/*

 CPU Opcodes 0x90-0x9F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BCC r   | STA (d),y |  STA (d)  |STA (d,s),y|
|    2 2    |    2 6    |    2 5    |    2 7    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|  STY d,x  |  STA d,x  |  STX d,y  | STA [d],y |
|    2 4    |    2 4    |    2 4    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   TYA i   |  STA a,y  |   TXS i   |   TXY i   |
|    1 2    |    3 5    |    1 2    |    1 2    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   STZ a   |  STA a,x  |  STZ a,x  | STA al,x  |
|    3 4    |    3 5    |    3 5    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 90 */

ALL_BCC:
	BCF SNES_FLAG_C		/* branch if C=0 */
	ret

/* 91 */

EM_STA_OdO_y:				/* STA (d),y Put A at Direct Indirect Index y*/
	EM_STA DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret
E0_STA_OdO_y:
	E0_STA DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret

/* 92 */

EM_STA_OdO:				/* STA (d) Put A at Direct Indirect */
	EM_STA DIRECT_INDIRECT_ADDR
	ret
E0_STA_OdO:
	E0_STA DIRECT_INDIRECT_ADDR
	ret

/* 93 */

EM_STA_Od_sO_y:				/* Put A at (stack relative)+Y */
	EM_STA STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret
E0_STA_Od_sO_y:
	E0_STA STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret

/* 94 */

EX_STY_d_x:
	EX_STY DIRECT_INDEX_X_ADDR
	ret
E0_STY_d_x:
	E0_STY DIRECT_INDEX_X_ADDR
	ret

/* 95 */

EM_STA_d_x:				/* Put A at Direct index x*/
	EM_STA DIRECT_INDEX_X_ADDR
	ret
E0_STA_d_x:
	E0_STA DIRECT_INDEX_X_ADDR
	ret

/* 96 */

EX_STX_d_y:
	EX_STX DIRECT_INDEX_Y_ADDR
	ret
E0_STX_d_y:
	E0_STX DIRECT_INDEX_Y_ADDR
	ret

/* 97 */

EM_STA_IdI_y:				/* STA [d],y Put A at Direct Indirect Index Long y*/
	EM_STA DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret
E0_STA_IdI_y:
	E0_STA DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret

/* 98 */

EM_TYA:
	movb _SNES_Y,%al
	movb %al,_SNES_A
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_TYA:
    movl _SNES_Y,%eax
    movl %eax,_SNES_A
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 99 */

EM_STA_a_y:				/* Put A at Absolute Index Y*/
	EM_STA ABSOLUTE_INDEX_Y_ADDR
	ret
E0_STA_a_y:
	E0_STA ABSOLUTE_INDEX_Y_ADDR
	ret

/* 9A */

E0_TXS:
    movl _SNES_X,%eax
    movl %eax,_SNES_S
	ret
E1_TXS:
	movb _SNES_X,%al
	movb %al,_SNES_S
	ret

/* 9B */

EX_TXY:
	movb _SNES_X,%al
	movb %al,_SNES_Y
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_TXY:
    movl _SNES_X,%eax
    movl %eax,_SNES_Y
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 9C */

EM_STZ_a:				/* Zero Absolute Offset */
	EM_STZ ABSOLUTE_ADDR
	ret
E0_STZ_a:
	E0_STZ ABSOLUTE_ADDR
	ret

/* 9D */

EM_STA_a_x:				/* Put A at Absolute Index X*/
	EM_STA ABSOLUTE_INDEX_X_ADDR
	ret
E0_STA_a_x:
	E0_STA ABSOLUTE_INDEX_X_ADDR
	ret

/* 9E */

EM_STZ_a_x:				/* Zero Absolute Index X Offset */
	EM_STZ ABSOLUTE_INDEX_X_ADDR
	ret
E0_STZ_a_x:
	E0_STZ ABSOLUTE_INDEX_X_ADDR
	ret	

/* 9F */

EM_STA_al_x:				/* Put A at Absolute long index x*/
	EM_STA ABSOLUTE_LONG_INDEX_X_ADDR
	ret
E0_STA_al_x:
	E0_STA ABSOLUTE_LONG_INDEX_X_ADDR
	ret

