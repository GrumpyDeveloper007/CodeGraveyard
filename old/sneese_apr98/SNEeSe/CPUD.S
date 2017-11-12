/*

 CPU Opcodes 0xD0-0xDF Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BNE r   | CMP (d),y |  CMP (d)  |CMP (d,s),y|
|    2 2    |    2 5    |    2 5    |    2 7    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   PEI s   |  CMP d,x  |  DEC d,x  | CMP [d],y |
|    2 6    |    2 4    |    2 6    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   CLD i   |  CMP a,y  |   PHX s   |   STP i   |
|    1 2    |    3 4    |    1 3    |    1 3    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|  JML (a)  |  CMP a,x  |  DEC a,x  | CMP al,x  |
|    3 6    |    3 4    |    3 7    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* D0 */

ALL_BNE:
	BCF SNES_FLAG_Z		/* branch if Z=0 */
	ret

/* D1 */

EM_CMP_OdO_y:
	EM_CMP DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret
E0_CMP_OdO_y:
	E0_CMP DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret

/* D2 */

EM_CMP_OdO:
	EM_CMP DIRECT_INDIRECT_ADDR
	ret
E0_CMP_OdO:
	E0_CMP DIRECT_INDIRECT_ADDR
	ret

/* D3 */

EM_CMP_Od_sO_y:
	EM_CMP STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret
E0_CMP_Od_sO_y:
	E0_CMP STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret

/* D4 */

E0_PEI:				/* Push Effective indirect address onto stack */
	DIRECT_INDIRECT_ADDR
	GET_WORD
	E0_PUSH_W
	ret
E1_PEI:
	DIRECT_INDIRECT_ADDR
	GET_WORD
	E1_PUSH_W
	ret

/* D5 */

EM_CMP_d_x:
	EM_CMP DIRECT_INDEX_X_ADDR
	ret
E0_CMP_d_x:
	E0_CMP DIRECT_INDEX_X_ADDR
	ret

/* D6 */

EM_DEC_d_x:
	EM_DEC DIRECT_INDEX_X_ADDR
	ret
E0_DEC_d_x:
	E0_DEC DIRECT_INDEX_X_ADDR
	ret

/* D7 */

EM_CMP_IdI_y:
	EM_CMP DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret
E0_CMP_IdI_y:
	E0_CMP DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret

/* D8 */

ALL_CLD:			/* Clr Decimal Flag */
	CLR_FLAG SNES_FLAG_D
	ret		/* Take the processor back to the CPU loop no rets saves time */

/* D9 */

EM_CMP_a_y:
	EM_CMP ABSOLUTE_INDEX_Y_ADDR
	ret
E0_CMP_a_y:
	E0_CMP ABSOLUTE_INDEX_Y_ADDR
	ret

/* DA */

E0_PHX:				/* Push X onto stack */
	movw _SNES_X,%ax
	E0_PUSH_W
	ret
EX_PHX:
	movb _SNES_X,%al
	E0_PUSH_B
	ret
E1_PHX:
	movb _SNES_X,%al
	E1_PUSH_B
	ret

/* DC */

ALL_JML_OaO:					/* JMP long to Absolute Indirect address */
	ABSOLUTE_INDIRECT_JML_ADDR
	movw %si,_SNES_PC
	andl $0x00FF0000,%esi
	movl %esi,SNES_ProgBank
	ret

/* DD */

EM_CMP_a_x:
	EM_CMP ABSOLUTE_INDEX_X_ADDR
	ret
E0_CMP_a_x:
	E0_CMP ABSOLUTE_INDEX_X_ADDR
	ret

/* DE */

EM_DEC_a_x:
	EM_DEC ABSOLUTE_INDEX_X_ADDR
	ret
E0_DEC_a_x:
	E0_DEC ABSOLUTE_INDEX_X_ADDR
	ret

/* DF */

EM_CMP_al_x:
	EM_CMP ABSOLUTE_LONG_INDEX_X_ADDR
	ret
E0_CMP_al_x:
	E0_CMP ABSOLUTE_LONG_INDEX_X_ADDR
	ret

