/*

 SPC 70-7F Commands

*/

/* 70 */

SPC_BVS:
	SPC_IM_ADDR
	TEST_FLAG_SPC(SPC_FLAG_V)
	jnc SPC_BACK		/* condition false */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* 71 */

/* TCALL - not yet implemented */

/* 72 */

SPC_CLR3:
	SPC_CLR 3
	jmp SPC_BACK

/* 73 */

SPC_BBC3:
	SPC_BBC 3
	jmp SPC_BACK

/* 74 */

SPC_CMP_A_Odp_XO:
	SPC_CMP_A SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 75 */

SPC_CMP_A_Oabs_XO:
	SPC_CMP_A SPC_OABS_XO_ADDR
	jmp SPC_BACK

/* 76 */

SPC_CMP_A_Oabs_YO:
	SPC_CMP_A SPC_OABS_YO_ADDR
	jmp SPC_BACK

/* 77 */

SPC_CMP_A_OOdpO_YO:
	SPC_CMP_A SPC_OOdpO_YO_ADDR
	jmp SPC_BACK

/* 78 */

SPC_CMP_dp_IM:
	SPC_dp_IM_ADDR
	GET_BYTE_SPC
	cmpb %dl,%al			/* Flags N,Z & C are setup so we can mask them off */
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C)
	CPL_FLAG_SPC(SPC_FLAG_C)
	jmp SPC_BACK

/* 79 */

SPC_CMP_OXO_OYO:
	SPC_OXO_OYO_ADDR
	GET_BYTE_SPC
	cmpb %dl,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C)
	CPL_FLAG_SPC(SPC_FLAG_C)
	jmp SPC_BACK

/* 7A */

SPC_ADDW_YA_dp:
	SPC_dp_ADDR
	GET_WORD_SPC			/* get DP word */
	movb SPC_A,%bl
	movb SPC_Y,%bh
	addw %ax,%bx
	pushf
	jo 1f
	CLR_FLAG_SPC(SPC_FLAG_V)		/* Done cos STORE_FLAGS cant alter V ! */
	jmp 2f
1:	SET_FLAG_SPC(SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C+SPC_MASK_H)
	movb %bh,SPC_Y
	movb %bl,SPC_A
	jmp SPC_BACK

/* 7B */

SPC_ROR_Odp_XO:
	SPC_ROR SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 7C */

SPC_ROR_A:
	MAKE_FLAGS_SPC (SPC_MASK_C)
	rcrb $1,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_C)
	cmpb $0,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_N+SPC_MASK_Z)
	jmp SPC_BACK

/* 7D */

SPC_MOV_A_X:
	movb SPC_X,%al
	movb %al,SPC_A
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 7E */

SPC_CMP_Y_dp:
	SPC_CMP_Y SPC_dp_ADDR
	jmp SPC_BACK

/* 7F */

/* RETI - not yet implemented */
