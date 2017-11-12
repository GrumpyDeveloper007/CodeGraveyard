/*

 SPC D0-DF Commands

*/

/* D0 */

SPC_BNE:
	SPC_IM_ADDR
	TEST_FLAG_SPC(SPC_FLAG_Z)
	jc SPC_BACK		/* condition true */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* D1 */

/* TCALL - not yet implemented */

/* D2 */

SPC_CLR6:
	SPC_CLR 6
	jmp SPC_BACK

/* D3 */

SPC_BBC6:
	SPC_BBC 6
	jmp SPC_BACK

/* D4 */

SPC_MOV_Odp_XO_A:
	SPC_MOV__A SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* D5 */

SPC_MOV_Oabs_XO_A:
	SPC_MOV__A SPC_OABS_XO_ADDR
	jmp SPC_BACK

/* D6 */

SPC_MOV_Oabs_YO_A:
	SPC_MOV__A SPC_OABS_YO_ADDR
	jmp SPC_BACK

/* D7 */

SPC_MOV_OOdpO_YO_A:
	SPC_MOV__A SPC_OOdpO_YO_ADDR
	jmp SPC_BACK

/* D8 */

SPC_MOV_dp_X:
	SPC_MOV__X SPC_dp_ADDR
	jmp SPC_BACK

/* D9 */

SPC_MOV_Odp_YO_X:
	SPC_MOV__X SPC_Odp_YO_ADDR
	jmp SPC_BACK

/* DA */

SPC_MOV_dp_YA:
	SPC_dp_ADDR
	movb SPC_A,%al
	movb SPC_Y,%ah
	SET_WORD_SPC
	jmp SPC_BACK

/* DB */

SPC_MOV_Odp_XO_Y:
	SPC_MOV__Y SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* DC */

SPC_DEC_Y:
	decb SPC_Y
	cmpb $0,SPC_Y
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* DD */

SPC_MOV_A_Y:
	movb SPC_Y,%al
	movb %al,SPC_A
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* DE */

SPC_CBNE_Odp_XO:
	SPC_Odp_XO_ADDR
	GET_BYTE_SPC			/* Get (dp) */
	SPC_IM_ADDR
	cmpb %al,SPC_A
	je SPC_BACK
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* DF */

/* DAA - not yet implemented */
