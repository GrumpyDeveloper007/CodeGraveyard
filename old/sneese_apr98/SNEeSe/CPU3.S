/*

 CPU Opcodes 0x30-0x3F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BMI r   | AND (d),y |  AND (d)  |AND (d,s),y|
|    2 2    |    2 5    |    2 5    |    2 7    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|  BIT d,x  |  AND d,x  |  ROL d,x  | AND [d],y |
|    2 4    |    2 4    |    2 6    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   SEC i   |  AND a,y  |   DEC A   |   TSC i   |
|    1 2    |    3 4    |    1 2    |    1 2    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|  BIT a,x  |  AND a,x  |  ROL a,x  | AND al,x  |
|    3 4    |    3 4    |    3 7    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 30 */

ALL_BMI:
	BCT SNES_FLAG_N		/* branch if N=1 */
	ret

/* 31 */

EM_AND_OdO_y:
	EM_AND DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret
E0_AND_OdO_y:
	E0_AND DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret

/* 32 */

EM_AND_OdO:
	EM_AND DIRECT_INDIRECT_ADDR
	ret
E0_AND_OdO:
	E0_AND DIRECT_INDIRECT_ADDR
	ret

/* 33 */

EM_AND_Od_sO_y:
	EM_AND STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret
E0_AND_Od_sO_y:
	E0_AND STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret

/* 34 */

EM_BIT_d_x:
	EM_BIT DIRECT_INDEX_X_ADDR
	ret
E0_BIT_d_x:
	E0_BIT DIRECT_INDEX_X_ADDR
	ret

/* 35 */

EM_AND_d_x:
	EM_AND DIRECT_INDEX_X_ADDR
	ret
E0_AND_d_x:
	E0_AND DIRECT_INDEX_X_ADDR
	ret

/* 36 */

EM_ROL_d_x:						/* Rol d,x */
	EM_ROL DIRECT_INDEX_X_ADDR
	ret
E0_ROL_d_x:
	E0_ROL DIRECT_INDEX_X_ADDR
	ret

/* 37 */

EM_AND_IdI_y:
	EM_AND DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret
E0_AND_IdI_y:
	E0_AND DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret

/* 38 */

ALL_SEC:			/* Set Carry Flag */
	SET_FLAG SNES_FLAG_C
	ret		/* Take the processor back to the CPU loop no rets saves time */

/* 39 */

EM_AND_a_y:
	EM_AND ABSOLUTE_INDEX_Y_ADDR
	ret
E0_AND_a_y:
	E0_AND ABSOLUTE_INDEX_Y_ADDR
	ret

/* 3A */

EM_DEA:
	decb _SNES_A
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_DEA:
	decw _SNES_A
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 3B */

ALL_TSC:				/* Transfer S to A */
    movl _SNES_S,%eax
	movw %ax,_SNES_A
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 3C */

EM_BIT_a_x:
	EM_BIT ABSOLUTE_INDEX_X_ADDR
	ret
E0_BIT_a_x:
	E0_BIT ABSOLUTE_INDEX_X_ADDR
	ret

/* 3D */

EM_AND_a_x:
	EM_AND ABSOLUTE_INDEX_X_ADDR
	ret
E0_AND_a_x:
	E0_AND ABSOLUTE_INDEX_X_ADDR
	ret

/* 3E */

EM_ROL_a_x:						/* Rol a,x */
	EM_ROL ABSOLUTE_INDEX_X_ADDR
	ret
E0_ROL_a_x:
	E0_ROL ABSOLUTE_INDEX_X_ADDR
	ret

/* 3F */

EM_AND_al_x:
	EM_AND ABSOLUTE_LONG_INDEX_X_ADDR
	ret
E0_AND_al_x:
	E0_AND ABSOLUTE_LONG_INDEX_X_ADDR
	ret

