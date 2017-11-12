/*

 SPC 10-1F Commands

*/

/* 10 */

SPC_BPL:
	SPC_IM_ADDR
	TEST_FLAG_SPC(SPC_FLAG_N)
	jc SPC_BACK		/* condition true */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* 11 */

/* TCALL - not yet implemented */

/* 12 */

SPC_CLR0:
	SPC_CLR 0
	jmp SPC_BACK

/* 13 */

SPC_BBC0:
	SPC_BBC 0
	jmp SPC_BACK

/* 14 */

SPC_OR_A_Odp_XO:
	SPC_OR_A SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 15 */

SPC_OR_A_Oabs_XO:
	SPC_OR_A SPC_OABS_XO_ADDR
	jmp SPC_BACK

/* 16 */

SPC_OR_A_Oabs_YO:
	SPC_OR_A SPC_OABS_YO_ADDR
	jmp SPC_BACK

/* 17 */

SPC_OR_A_OOdpO_YO:
	SPC_OR_A SPC_OOdpO_YO_ADDR
	jmp SPC_BACK

/* 18 */

SPC_OR_dp_IM:
	SPC_dp_IM_ADDR		/* %dl contains immediate, %si dest address */
	GET_BYTE_SPC		/* get (dp) */
	orb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 19 */

SPC_OR_OXO_OYO:
	SPC_OXO_OYO_ADDR	/* %dl contains (Y), %si dest address */
	GET_BYTE_SPC		/* get (X) */
	orb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 1A */

SPC_DECW_dp:
	SPC_dp_ADDR
	GET_WORD_SPC			/* get DP word */
	movw %ax,%bx
	decw %bx
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	decw %si
	movw %bx,%ax
	SET_WORD_SPC
	jmp SPC_BACK

/* 1B */

SPC_ASL_Odp_XO:
	SPC_ASL SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 1C */

SPC_ASL_A:
	salb $1,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_C+SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 1D */

SPC_DEC_X:
	decb SPC_X
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 1E */

SPC_CMP_X_abs:
	SPC_CMP_X SPC_ABS_ADDR
	jmp SPC_BACK

/* 1F */

SPC_JMP_Oabs_XO:
	SPC_OABS_XO_ADDR
	GET_WORD_SPC
	movw %ax,SPC_PC
	jmp SPC_BACK

