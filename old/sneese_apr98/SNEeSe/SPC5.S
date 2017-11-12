/*

 SPC 50-5F Commands

*/

/* 50 */

SPC_BVC:
	SPC_IM_ADDR
	TEST_FLAG_SPC(SPC_FLAG_V)
	jc SPC_BACK		/* condition true */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* 51 */

/* TCALL - not yet implemented */

/* 52 */

SPC_CLR2:
	SPC_CLR 2
	jmp SPC_BACK

/* 53 */

SPC_BBC2:
	SPC_BBC 2
	jmp SPC_BACK

/* 54 */

SPC_EOR_A_Odp_XO:
	SPC_EOR_A SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 55 */

SPC_EOR_A_Oabs_XO:
	SPC_EOR_A SPC_OABS_XO_ADDR
	jmp SPC_BACK

/* 56 */

SPC_EOR_A_Oabs_YO:
	SPC_EOR_A SPC_OABS_YO_ADDR
	jmp SPC_BACK

/* 57 */

SPC_EOR_A_OOdpO_YO:
	SPC_EOR_A SPC_OOdpO_YO_ADDR
	jmp SPC_BACK

/* 58 */

SPC_EOR_dp_IM:
	SPC_dp_IM_ADDR
	GET_BYTE_SPC
	xorb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 59 */

SPC_EOR_OXO_OYO:
	SPC_OXO_OYO_ADDR
	GET_BYTE_SPC
	xorb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 5A */

SPC_CMPW_YA_dp:
	SPC_dp_ADDR
	GET_WORD_SPC			/* get DP word */
	movb SPC_A,%bl
	movb SPC_Y,%bh
	cmpw %ax,%bx
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 5B */

SPC_LSR_Odp_XO:
	SPC_LSR SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 5C */

SPC_LSR_A:
	shrb $1,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_C+SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 5D */

SPC_MOV_X_A:
	movb SPC_A,%al
	movb %al,SPC_X
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 5E */

SPC_CMP_Y_abs:
	SPC_CMP_Y SPC_ABS_ADDR
	jmp SPC_BACK

/* 5F */

SPC_JMP_abs:
	SPC_ABS_ADDR
	movw %si,SPC_PC
	jmp SPC_BACK

