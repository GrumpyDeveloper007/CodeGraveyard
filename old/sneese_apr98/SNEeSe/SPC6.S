/*

 SPC 60-6F Commands

*/

/* 60 */

SPC_CLRC:
	CLR_FLAG_SPC (SPC_FLAG_C)
	jmp SPC_BACK

/* 61 */

/* TCALL - not yet implemented */

/* 62 */

SPC_SET3:
	SPC_SET 3
	jmp SPC_BACK

/* 63 */

SPC_BBS3:
	SPC_BBS 3
	jmp SPC_BACK

/* 64 */

SPC_CMP_A_dp:
	SPC_CMP_A SPC_dp_ADDR
	jmp SPC_BACK

/* 65 */

SPC_CMP_A_abs:
	SPC_CMP_A SPC_ABS_ADDR
	jmp SPC_BACK

/* 66 */

SPC_CMP_A_OXO:
	SPC_CMP_A SPC_OXO_ADDR
	jmp SPC_BACK

/* 67 */

SPC_CMP_A_OOdp_XOO:
	SPC_CMP_A SPC_OOdp_XOO_ADDR
	jmp SPC_BACK

/* 68 */

SPC_CMP_A_IM:
	SPC_CMP_A SPC_IM_ADDR
	jmp SPC_BACK

/* 69 */

SPC_CMP_dp_dp:
	SPC_dp_dp_ADDR
	GET_BYTE_SPC
	cmpb %dl,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C)
	CPL_FLAG_SPC(SPC_FLAG_C)
	jmp SPC_BACK

/* 6A */

SPC_AND1C:		/* Carry flag = Carry flag AND !mem.bit */
	SPC_membit_ADDR		/* %si contains mem and %dx contains bit number */
	GET_BYTE_SPC		/* Get byte at location */
	btw %dx,%ax
	jnc SPC_BACK			/* bit not set so C = C & ~0 -> C = C*/
	CLR_FLAG_SPC (SPC_FLAG_C)	/* bit set so C = C & ~1 -> C = 0 */
	jmp SPC_BACK

/* 6B */

SPC_ROR_dp:
	SPC_ROR SPC_dp_ADDR
	jmp SPC_BACK

/* 6C */

SPC_ROR_abs:
	SPC_ROR SPC_ABS_ADDR
	jmp SPC_BACK

/* 6D */

SPC_PUSH_Y:
	movb SPC_Y,%al
	PUSH_B
	jmp SPC_BACK

/* 6E */

SPC_DBNZ_dp:
	SPC_dp_ADDR
	pushw %si
	GET_BYTE_SPC		/* get (dp) */	
	movb %al,%cl		/* %cl contains (dp) */
	SPC_IM_ADDR
	GET_BYTE_SPC		/* %al contains relative offset */
	decb %cl
	jz 9f
	subl $2,SPC_Cycles	/* Branch taken */
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
9:	popw %si
	movb %cl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 6F */

SPC_RET:
	POP_W
	movw %ax,SPC_PC
	jmp SPC_BACK

