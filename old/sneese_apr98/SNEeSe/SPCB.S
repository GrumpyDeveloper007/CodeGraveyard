/*

 SPC B0-BF Commands

*/

/* B0 */

SPC_BCS:
	SPC_IM_ADDR
	TEST_FLAG_SPC(SPC_FLAG_C)
	jnc SPC_BACK		/* condition false */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* B1 */

/* TCALL - not yet implemented */

/* B2 */

SPC_CLR5:
	SPC_CLR 5
	jmp SPC_BACK

/* B3 */

SPC_BBC5:
	SPC_BBC 5
	jmp SPC_BACK

/* B4 */

SPC_SBC_A_Odp_XO:
	SPC_SBC_A SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* B5 */

SPC_SBC_A_Oabs_XO:
	SPC_SBC_A SPC_OABS_XO_ADDR
	jmp SPC_BACK

/* B6 */

SPC_SBC_A_Oabs_YO:
	SPC_SBC_A SPC_OABS_YO_ADDR
	jmp SPC_BACK

/* B7 */

SPC_SBC_A_OOdpO_YO:
	SPC_SBC_A SPC_OOdpO_YO_ADDR
	jmp SPC_BACK

/* B8 */

SPC_SBC_dp_IM:
	SPC_dp_IM_ADDR
	GET_BYTE_SPC
	pushw %ax
	MAKE_FLAGS_SPC_INV (SPC_MASK_C)
	popw %ax
	sbbb %al,%dl
	pushf
	jo 1f
	CLR_FLAG_SPC(SPC_FLAG_V)		/* Done cos STORE_FLAGS cant alter V ! */
	jmp 2f
1:	SET_FLAG_SPC(SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C+SPC_MASK_H)
	CPL_FLAG_SPC(SPC_FLAG_C)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* B9 */

SPC_SBC_OXO_OYO:
	SPC_OXO_OYO_ADDR
	GET_BYTE_SPC
	pushw %ax
	MAKE_FLAGS_SPC_INV (SPC_MASK_C)
	popw %ax
	sbbb %al,%dl
	pushf
	jo 1f
	CLR_FLAG_SPC(SPC_FLAG_V)		/* Done cos STORE_FLAGS cant alter V ! */
	jmp 2f
1:	SET_FLAG_SPC(SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C+SPC_MASK_H)
	CPL_FLAG_SPC(SPC_FLAG_C)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* BA */

SPC_MOV_YA_dp:
	SPC_dp_ADDR
	GET_WORD_SPC
	movb %al,SPC_A
	movb %ah,SPC_Y
	cmpw $0,%ax
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* BB */

SPC_INC_Odp_XO:
	SPC_INC SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* BC */

SPC_INC_A:
	incb SPC_A
	cmpb $0,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* BD */

SPC_MOV_SP_X:
	movb SPC_X,%al
	movb %al,SPC_SP
	jmp SPC_BACK

/* BE */

/* DAS - not yet implemented */

/* BF */

SPC_MOV_A_OXOInc:
	SPC_OXOInc_ADDR
	GET_BYTE_SPC
	movb %al,SPC_A
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

