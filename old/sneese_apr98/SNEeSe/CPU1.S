/*

 CPU Opcodes 0x10-0x1F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BPL r   | ORA (d),y |  ORA (d)  |ORA (d,s),y|
|    2 2    |    2 5    |    2 5    |    2 7    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   TRB d   |  ORA d,x  |  ASL d,x  | ORA [d],y |
|    2 5    |    2 4    |    2 6    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   CLC i   |  ORA a,y  |   INC A   |   TCS i   |
|    1 2    |    3 4    |    1 2    |    1 2    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   TRB a   |  ORA a,x  |  ASL a,x  | ORA al,x  |
|    3 6    |    3 4    |    3 7    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 10 */

ALL_BPL:
	BCF SNES_FLAG_N
	ret

/* 11 */

EM_ORA_OdO_y:
	EM_ORA DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret
E0_ORA_OdO_y:
	E0_ORA DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret

/* 12 */

EM_ORA_OdO:
	EM_ORA DIRECT_INDIRECT_ADDR
	ret
E0_ORA_OdO:
	E0_ORA DIRECT_INDIRECT_ADDR
	ret

/* 13 */

EM_ORA_Od_sO_y:
	EM_ORA STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret
E0_ORA_Od_sO_y:
	E0_ORA STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret

/* 14 */

EM_TRB_d:
	EM_TRB DIRECT_ADDR
	ret
E0_TRB_d:
	E0_TRB DIRECT_ADDR
	ret

/* 15 */

EM_ORA_d_x:
	EM_ORA DIRECT_INDEX_X_ADDR
	ret
E0_ORA_d_x:
	E0_ORA DIRECT_INDEX_X_ADDR
	ret

/* 16 */

EM_ASL_d_x:						/* Asl d,x */
	EM_ASL DIRECT_INDEX_X_ADDR
	ret
E0_ASL_d_x:
	E0_ASL DIRECT_INDEX_X_ADDR
	ret

/* 17 */

EM_ORA_IdI_y:
	EM_ORA DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret
E0_ORA_IdI_y:
	E0_ORA DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret

/* 18 */

ALL_CLC:			/* Clr Carry Flag */
	CLR_FLAG SNES_FLAG_C
	ret		/* Take the processor back to the CPU loop no rets saves time */

/* 19 */

EM_ORA_a_y:
	EM_ORA ABSOLUTE_INDEX_Y_ADDR
	ret
E0_ORA_a_y:
	E0_ORA ABSOLUTE_INDEX_Y_ADDR
	ret

/* 1A */

EM_INA:
	incb _SNES_A
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_INA:
	incw _SNES_A
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 1B */

E0_TCS:
    movl _SNES_A,%eax
    movl %eax,_SNES_S
	ret
E1_TCS:
	movb _SNES_A,%al
	movb %al,_SNES_S
	ret

/* 1C */

EM_TRB_a:
	EM_TRB ABSOLUTE_ADDR
	ret
E0_TRB_a:
	E0_TRB ABSOLUTE_ADDR
	ret

/* 1D */

EM_ORA_a_x:
	EM_ORA ABSOLUTE_INDEX_X_ADDR
	ret
E0_ORA_a_x:
	E0_ORA ABSOLUTE_INDEX_X_ADDR
	ret

/* 1E */

EM_ASL_a_x:						/* Asl a,x */
	EM_ASL ABSOLUTE_INDEX_X_ADDR
	ret
E0_ASL_a_x:
	E0_ASL ABSOLUTE_INDEX_X_ADDR
	ret

/* 1F */

EM_ORA_al_x:
	EM_ORA ABSOLUTE_LONG_INDEX_X_ADDR
	ret
E0_ORA_al_x:
	E0_ORA ABSOLUTE_LONG_INDEX_X_ADDR
	ret

