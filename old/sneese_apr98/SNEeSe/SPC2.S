/*

 SPC 20-2F Commands

*/

/* 20 */

SPC_CLRP:
	CLR_FLAG_SPC(SPC_FLAG_P)
	movw $0,SPC_PAGE
	jmp SPC_BACK

/* 21 */

/* TCALL - not yet implemented */

/* 22 */

SPC_SET1:
	SPC_SET 1
	jmp SPC_BACK

/* 23 */

SPC_BBS1:
	SPC_BBS 1
	jmp SPC_BACK

/* 24 */

SPC_AND_A_dp:
	SPC_AND_A SPC_dp_ADDR
	jmp SPC_BACK

/* 25 */

SPC_AND_A_abs:
	SPC_AND_A SPC_ABS_ADDR
	jmp SPC_BACK

/* 26 */

SPC_AND_A_OXO:
	SPC_AND_A SPC_OXO_ADDR
	jmp SPC_BACK

/* 27 */

SPC_AND_A_OOdp_XOO:
	SPC_AND_A SPC_OOdp_XOO_ADDR
	jmp SPC_BACK

/* 28 */

SPC_AND_A_IM:
	SPC_AND_A SPC_IM_ADDR
	jmp SPC_BACK

/* 29 */

SPC_AND_dp_dp:
	SPC_dp_dp_ADDR		/* %dl is (s), %si is d */
	GET_BYTE_SPC		/* get (d) */
	andb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 2A */

SPC_OR1C:		/* Carry flag = Carry flag OR !mem.bit */
	SPC_membit_ADDR		/* %si contains mem and %dx contains bit number */
	GET_BYTE_SPC		/* Get byte at location */
	btw %dx,%ax
	jc SPC_BACK			/* bit set so C = C OR ~1 -> C = C */
	SET_FLAG_SPC (SPC_FLAG_C)	/* bit not set so C = C OR ~0 -> C = 1 */
	jmp SPC_BACK

/* 2B */

SPC_ROL_dp:
	SPC_ROL SPC_dp_ADDR
	jmp SPC_BACK

/* 2C */

SPC_ROL_abs:
	SPC_ROL SPC_ABS_ADDR
	jmp SPC_BACK

/* 2D */

SPC_PUSH_A:
	movb SPC_A,%al
	PUSH_B
	jmp SPC_BACK

/* 2E */

SPC_CBNE_dp:
	SPC_dp_ADDR
	GET_BYTE_SPC			/* Get (dp) */
	SPC_IM_ADDR
	cmpb %al,SPC_A
	je SPC_BACK
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* 2F */

SPC_BRA:
	SPC_IM_ADDR
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

