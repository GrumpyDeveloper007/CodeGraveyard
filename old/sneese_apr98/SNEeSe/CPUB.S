/*

 CPU Opcodes 0xB0-0xBF Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BCS r   | LDA (d),y |  LDA (d)  |LDA (d,s),y|
|    2 2    |    2 5    |    2 5    |    2 7    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|  LDY d,x  |  LDA d,x  |  LDX d,y  | LDA [d],y |
|    2 4    |    2 4    |    2 4    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   CLV i   |  LDA a,y  |   TSX i   |   TYX i   |
|    1 2    |    3 4    |    1 2    |    1 2    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|  LDY a,x  |  LDA a,x  |  LDX a,y  | LDA al,x  |
|    3 4    |    3 4    |    3 4    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* B0 */

ALL_BCS:
	BCT SNES_FLAG_C		/* branch if C=1 */
	ret

/* B1 */

EM_LDA_OdO_y:			/* Put Direct indirect indexed Y into A */
	EM_LDA DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret
E0_LDA_OdO_y:
	E0_LDA DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret

/* B2 */

EM_LDA_OdO:			/* Put Direct indirect into A */
	EM_LDA DIRECT_INDIRECT_ADDR
	ret
E0_LDA_OdO:
	E0_LDA DIRECT_INDIRECT_ADDR
	ret

/* B3 */

EM_LDA_Od_sO_y:			/* Put (Stack Relative) + Y into A */
	EM_LDA STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret
E0_LDA_Od_sO_y:
	E0_LDA STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret

/* B4 */

EX_LDY_d_x:
	EX_LDY DIRECT_INDEX_X_ADDR
	ret
E0_LDY_d_x:
	E0_LDY DIRECT_INDEX_X_ADDR
	ret

/* B5 */

EM_LDA_d_x:			/* Put Direct index x into A */
	EM_LDA DIRECT_INDEX_X_ADDR
	ret
E0_LDA_d_x:
	E0_LDA DIRECT_INDEX_X_ADDR
	ret

/* B6 */

EX_LDX_d_y:
	EX_LDX DIRECT_INDEX_Y_ADDR
	ret
E0_LDX_d_y:
	E0_LDX DIRECT_INDEX_Y_ADDR
	ret

/* B7 */

EM_LDA_IdI_y:			/* Put Direct indirect indexed long Y into A */
	EM_LDA DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret
E0_LDA_IdI_y:
	E0_LDA DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret

/* B8 */

ALL_CLV:			/* Clr Overflow Flag */
	CLR_FLAG SNES_FLAG_V
	ret		/* Take the processor back to the CPU loop no rets saves time */

/* B9 */

EM_LDA_a_y:			/* Put Absolute Index Y into A */
	EM_LDA ABSOLUTE_INDEX_Y_ADDR
	ret
E0_LDA_a_y:
	E0_LDA ABSOLUTE_INDEX_Y_ADDR
	ret

/* BA */

EX_TSX:
	movb _SNES_S,%al
	movb %al,_SNES_X
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_TSX:
    movl _SNES_S,%eax
    movl %eax,_SNES_X
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* BB */

EX_TYX:
	movb _SNES_Y,%al
	movb %al,_SNES_X
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_TYX:
    movl _SNES_Y,%eax
    movl %eax,_SNES_X
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* BC */

EX_LDY_a_x:
	EX_LDY ABSOLUTE_INDEX_X_ADDR
	ret
E0_LDY_a_x:
	E0_LDY ABSOLUTE_INDEX_X_ADDR
	ret

/* BD */

EM_LDA_a_x:			/* Put Absolute Index X into A */
	EM_LDA ABSOLUTE_INDEX_X_ADDR
	ret
E0_LDA_a_x:
	E0_LDA ABSOLUTE_INDEX_X_ADDR
	ret

/* BE */

EX_LDX_a_y:
	EX_LDX ABSOLUTE_INDEX_Y_ADDR
	ret
E0_LDX_a_y:
	E0_LDX ABSOLUTE_INDEX_Y_ADDR
	ret

/* BF */

EM_LDA_al_x:			/* Put Absolute Long Index X into A */
	EM_LDA ABSOLUTE_LONG_INDEX_X_ADDR
	ret
E0_LDA_al_x:
	E0_LDA ABSOLUTE_LONG_INDEX_X_ADDR
	ret
