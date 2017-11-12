/*

 SPC 80-8F Commands

*/

/* 80 */

SPC_SETC:
	SET_FLAG_SPC (SPC_FLAG_C)
	jmp SPC_BACK

/* 81 */

/* TCALL - not yet implemented */

/* 82 */

SPC_SET4:
	SPC_SET 4
	jmp SPC_BACK

/* 83 */

SPC_BBS4:
	SPC_BBS 4
	jmp SPC_BACK

/* 84 */

SPC_ADC_A_dp:
	SPC_ADC_A SPC_dp_ADDR
	jmp SPC_BACK

/* 85 */

SPC_ADC_A_abs:
	SPC_ADC_A SPC_ABS_ADDR
	jmp SPC_BACK

/* 86 */

SPC_ADC_A_OXO:
	SPC_ADC_A SPC_OXO_ADDR
	jmp SPC_BACK

/* 87 */

SPC_ADC_A_OOdp_XOO:
	SPC_ADC_A SPC_OOdp_XOO_ADDR
	jmp SPC_BACK

/* 88 */

SPC_ADC_A_IM:
	SPC_ADC_A SPC_IM_ADDR
	jmp SPC_BACK

/* 89 */

SPC_ADC_dp_dp:
	SPC_dp_dp_ADDR
	GET_BYTE_SPC
	pushw %ax
	MAKE_FLAGS_SPC (SPC_MASK_C)
	popw %ax
	adcb %al,%dl
	pushf
	jo 1f
	CLR_FLAG_SPC(SPC_FLAG_V)		/* Done cos STORE_FLAGS cant alter V ! */
	jmp 2f
1:	SET_FLAG_SPC(SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C+SPC_MASK_H)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 8A */

SPC_EOR1:		/* Carry flag = Carry flag EOR mem.bit */
	SPC_membit_ADDR		/* %si contains mem and %dx contains bit number */
	GET_BYTE_SPC		/* Get byte at location */
	btw %dx,%ax
	jnc SPC_BACK			/* C = C EOR 0 -> C = C */
	CPL_FLAG_SPC (SPC_FLAG_C)	/* C = C EOR 1 -> C = !C */
	jmp SPC_BACK

/* 8B */

SPC_DEC_dp:
	SPC_DEC SPC_dp_ADDR
	jmp SPC_BACK

/* 8C */

SPC_DEC_abs:
	SPC_DEC SPC_ABS_ADDR
	jmp SPC_BACK

/* 8D */

SPC_MOV_Y_IM:
	SPC_MOV_Y_ SPC_IM_ADDR
	jmp SPC_BACK

/* 8E */

SPC_POP_PSW:
	POP_B
	RESTOREFLAGS_SPC
	jmp SPC_BACK

/* 8F */

SPC_MOV_dp_IM:
	SPC_dp_IM_ADDR
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

