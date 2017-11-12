/*

 SPC 30-3F Commands

*/

/* 30 */

SPC_BMI:
	SPC_IM_ADDR
	TEST_FLAG_SPC(SPC_FLAG_N)
	jnc SPC_BACK		/* condition false */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* 31 */

/* TCALL - not implemented yet */

/* 32 */

SPC_CLR1:
	SPC_CLR 1
	jmp SPC_BACK

/* 33 */

SPC_BBC1:
	SPC_BBC 1
	jmp SPC_BACK

/* 34 */

SPC_AND_A_Odp_XO:
	SPC_AND_A SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 35 */

SPC_AND_A_Oabs_XO:
	SPC_AND_A SPC_OABS_XO_ADDR
	jmp SPC_BACK

/* 36 */

SPC_AND_A_Oabs_YO:
	SPC_AND_A SPC_OABS_YO_ADDR
	jmp SPC_BACK

/* 37 */

SPC_AND_A_OOdpO_YO:
	SPC_AND_A SPC_OOdpO_YO_ADDR
	jmp SPC_BACK

/* 38 */

SPC_AND_dp_IM:
	SPC_dp_IM_ADDR		/* dl contains IM, %si dp */
	GET_BYTE_SPC
	andb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 39 */

SPC_AND_OXO_OYO:
	SPC_OXO_OYO_ADDR
	GET_BYTE_SPC
	andb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 3A */

SPC_INCW_dp:
	SPC_dp_ADDR
	GET_WORD_SPC			/* get DP word */
	movw %ax,%bx
	incw %bx
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	decw %si
	movw %bx,%ax
	SET_WORD_SPC
	jmp SPC_BACK

/* 3B */

SPC_ROL_Odp_XO:
	SPC_ROL SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 3C */

SPC_ROL_A:
	MAKE_FLAGS_SPC (SPC_MASK_C)
	rclb $1,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_C)
	cmpb $0,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_N+SPC_MASK_Z)
	jmp SPC_BACK

/* 3D */

SPC_INC_X:
	incb SPC_X
	cmpb $0,SPC_X
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 3E */

SPC_CMP_X_dp:
	SPC_CMP_X SPC_dp_ADDR
	jmp SPC_BACK

/* 3F */

SPC_CALL:
	SPC_ABS_ADDR
	movw SPC_PC,%ax
	movw %si,SPC_PC
	PUSH_W
	jmp SPC_BACK

