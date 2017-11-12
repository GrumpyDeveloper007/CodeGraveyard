/*

 CPU Opcodes 0x70-0x7F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BVS r   | ADC (d),y |  ADC (d)  |ADC (d,s),y|
|    2 2    |    2 5    |    2 5    |    2 7    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|  STZ d,x  |  ADC d,x  |  ROR d,x  | ADC [d],y |
|    2 4    |    2 4    |    2 6    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   SEI i   |  ADC a,y  |   PLY s   |   TDC i   |
|    1 2    |    3 4    |    1 4    |    1 2    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
| JMP (a,x) |  ADC a,x  |  ROR a,x  | ADC al,x  |
|    3 6    |    3 4    |    3 7    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 70 */

ALL_BVS:
	BCT SNES_FLAG_V		/* branch if V=1 */
	ret

/* 71 */

EM_ADC_OdO_y:
	EM_ADC DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret
E0_ADC_OdO_y:
	E0_ADC DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret

/* 72 */

EM_ADC_OdO:
	EM_ADC DIRECT_INDIRECT_ADDR
	ret
E0_ADC_OdO:
	E0_ADC DIRECT_INDIRECT_ADDR
	ret

/* 73 */

EM_ADC_Od_sO_y:
	EM_ADC STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret
E0_ADC_Od_sO_y:
	E0_ADC STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret

/* 74 */

EM_STZ_d_x:				/* Zero Direct Index X Offset */
	EM_STZ DIRECT_INDEX_X_ADDR
	ret

E0_STZ_d_x:
	E0_STZ DIRECT_INDEX_X_ADDR
	ret

/* 75 */

EM_ADC_d_x:
	EM_ADC DIRECT_INDEX_X_ADDR
	ret
E0_ADC_d_x:
	E0_ADC DIRECT_INDEX_X_ADDR
	ret

/* 76 */

EM_ROR_d_x:						/* Ror d,x */
	EM_ROR DIRECT_INDEX_X_ADDR
	ret
E0_ROR_d_x:
	E0_ROR DIRECT_INDEX_X_ADDR
	ret

/* 77 */

EM_ADC_IdI_y:
	EM_ADC DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret
E0_ADC_IdI_y:
	E0_ADC DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret

/* 78 */

ALL_SEI:			/* Set Interrupt Disable Flag */
	SET_FLAG SNES_FLAG_I 
	ret		/* Take the processor back to the CPU loop no rets saves time */

/* 79 */

EM_ADC_a_y:
	EM_ADC ABSOLUTE_INDEX_Y_ADDR
	ret
E0_ADC_a_y:
	E0_ADC ABSOLUTE_INDEX_Y_ADDR
	ret

/* 7A */

E0_PLY:				/* Pop Y off stack */
	E0_POP_W
	movw %ax,_SNES_Y
    testw %ax,%ax       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
EX_PLY:
	E0_POP_B
	movb %al,_SNES_Y
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E1_PLY:
	E1_POP_B
	movb %al,_SNES_Y
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 7B */

ALL_TDC:				/* Transfer D to A */
    movl _SNES_D,%eax
    movl %eax,_SNES_A
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 7C */

ALL_JMP_Oa_xO:				/* JMP Absolute address (a,x)*/
	ABSOLUTE_INDEX_INDIRECT_X_ADDR
	GET_WORD
	movw %ax,_SNES_PC		/* Only want lo-word */
	ret

/* 7D */

EM_ADC_a_x:
	EM_ADC ABSOLUTE_INDEX_X_ADDR
	ret
E0_ADC_a_x:
	E0_ADC ABSOLUTE_INDEX_X_ADDR
	ret

/* 7E */

EM_ROR_a_x:						/* Ror a,x */
	EM_ROR ABSOLUTE_INDEX_X_ADDR
	ret
E0_ROR_a_x:
	E0_ROR ABSOLUTE_INDEX_X_ADDR
	ret

/* 7F */

EM_ADC_al_x:
	EM_ADC ABSOLUTE_LONG_INDEX_X_ADDR
	ret
E0_ADC_al_x:
	E0_ADC ABSOLUTE_LONG_INDEX_X_ADDR
	ret
