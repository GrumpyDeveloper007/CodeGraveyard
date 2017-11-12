/*

 SPC A0-AF Commands

*/

/* A0 */

SPC_EI:
	SET_FLAG_SPC(SPC_FLAG_I)
	jmp SPC_BACK

/* A1 */

/* TCALL - not yet implemented */

/* A2 */

SPC_SET5:
	SPC_SET 5
	jmp SPC_BACK

/* A3 */

SPC_BBS5:
	SPC_BBS 5
	jmp SPC_BACK

/* A4 */

SPC_SBC_A_dp:
	SPC_SBC_A SPC_dp_ADDR
	jmp SPC_BACK

/* A5 */

SPC_SBC_A_abs:
	SPC_SBC_A SPC_ABS_ADDR
	jmp SPC_BACK

/* A6 */

SPC_SBC_A_OXO:
	SPC_SBC_A SPC_OXO_ADDR
	jmp SPC_BACK

/* A7 */

SPC_SBC_A_OOdp_XOO:
	SPC_SBC_A SPC_OOdp_XOO_ADDR
	jmp SPC_BACK

/* A8 */

SPC_SBC_A_IM:
	SPC_SBC_A SPC_IM_ADDR
	jmp SPC_BACK

/* A9 */

SPC_SBC_dp_dp:
	SPC_dp_dp_ADDR
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

/* AA */

SPC_MOV1_C_:		/* Carry flag = mem.bit */
	SPC_membit_ADDR		/* %si contains mem and %dx contains bit number */
	GET_BYTE_SPC		/* Get byte at location */
	btw %dx,%ax
	jnc 0f
	SET_FLAG_SPC (SPC_FLAG_C)
	jmp SPC_BACK
0:	CLR_FLAG_SPC (SPC_FLAG_C)
	jmp SPC_BACK

/* AB */

SPC_INC_dp:
	SPC_INC SPC_dp_ADDR
	jmp SPC_BACK

/* AC */

SPC_INC_abs:
	SPC_INC SPC_ABS_ADDR
	jmp SPC_BACK

/* AD */

SPC_CMP_Y_IM:
	SPC_CMP_Y SPC_IM_ADDR
	jmp SPC_BACK

/* AE */

SPC_POP_A:
	POP_B
	movb %al,SPC_A
	jmp SPC_BACK

/* AF */

SPC_MOV_OXOInc_A:
	SPC_OXOInc_ADDR
	movb SPC_A,%al
	SET_BYTE_SPC
	jmp SPC_BACK

