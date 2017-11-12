/*

 SPC 90-9F Commands

*/

/* 90 */

SPC_BCC:
	SPC_IM_ADDR
	TEST_FLAG_SPC(SPC_FLAG_C)
	jc SPC_BACK		/* condition true */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* 91 */

/* TCALL - not yet implemented */

/* 92 */

SPC_CLR4:
	SPC_CLR 4
	jmp SPC_BACK

/* 93 */

SPC_BBC4:
	SPC_BBC 4
	jmp SPC_BACK

/* 94 */

SPC_ADC_A_Odp_XO:
	SPC_ADC_A SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 95 */

SPC_ADC_A_Oabs_XO:
	SPC_ADC_A SPC_OABS_XO_ADDR
	jmp SPC_BACK

/* 96 */

SPC_ADC_A_Oabs_YO:
	SPC_ADC_A SPC_OABS_YO_ADDR
	jmp SPC_BACK

/* 97 */

SPC_ADC_A_OOdpO_YO:
	SPC_ADC_A SPC_OOdpO_YO_ADDR
	jmp SPC_BACK

/* 98 */

SPC_ADC_dp_IM:
	SPC_dp_IM_ADDR
	GET_BYTE_SPC
	pushw %ax
	MAKE_FLAGS_SPC (SPC_MASK_C)
	popw %ax
	adcb %al,%dl		/* result needs saving to (dp) */
	pushf
	jo 1f
	CLR_FLAG_SPC(SPC_FLAG_V)		/* Done cos STORE_FLAGS cant alter V ! */
	jmp 2f
1:	SET_FLAG_SPC(SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C+SPC_MASK_H)
	movb %dl,%al
	SET_BYTE_SPC		/* store in (dp) */
	jmp SPC_BACK

/* 99 */

SPC_ADC_OXO_OYO:
	SPC_OXO_OYO_ADDR
	GET_BYTE_SPC
	pushw %ax
	MAKE_FLAGS_SPC (SPC_MASK_C)
	popw %ax
	adcb %al,%dl		/* result needs saving to (dp) */
	pushf
	jo 1f
	CLR_FLAG_SPC(SPC_FLAG_V)		/* Done cos STORE_FLAGS cant alter V ! */
	jmp 2f
1:	SET_FLAG_SPC(SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C+SPC_MASK_H)
	movb %dl,%al
	SET_BYTE_SPC		/* store in (dp) */
	jmp SPC_BACK

/* 9A */

SPC_SUBW_YA_dp:
	SPC_dp_ADDR
	GET_WORD_SPC			/* get DP word */
	movb SPC_A,%bl
	movb SPC_Y,%bh
	subw %ax,%bx
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

/* 9B */

SPC_DEC_Odp_XO:
	SPC_DEC SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* 9C */

SPC_DEC_A:
	decb SPC_A
	cmpb $0,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 9D */

SPC_MOV_X_SP:
	movb SPC_SP,%al
	movb %al,SPC_X
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 9E */

SPC_DIV:			/* This may not be 100% due to overflow checking! */
	xorl %edx,%edx
	xorl %ebx,%ebx
	movb SPC_Y,%ah		/* Dividend */
	movb SPC_X,%bl
	movb SPC_A,%al
	cmpb $0,%bl		/* If zero skip divide! */
	je SPC_BACK
	divw %bx			/* Result is ax=quotient,dx=remainder */
	pushw %ax
	pushf
	cmpb $0,%ah		/* Check for overflow */
	jne 1f
	CLR_FLAG_SPC (SPC_FLAG_V)
	jmp 2f
1:	SET_FLAG_SPC (SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_H)
	popw %ax
	movb %al,SPC_A		/* Quotient in A */
	movb %dl,SPC_Y		/* Remainder in Y */
	jmp SPC_BACK

/* 9F */

SPC_XCN:
	movb SPC_A,%al
	rolb $4,%al
	movb %al,SPC_A
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	ret

