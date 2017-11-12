/*

 SPC F0-FF Commands

*/

/* F0 */

SPC_BEQ:
	SPC_IM_ADDR
	TEST_FLAG_SPC(SPC_FLAG_Z)
	jnc SPC_BACK		/* condition false */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* F2 */

SPC_CLR7:
	SPC_CLR 7
	jmp SPC_BACK

/* F3 */

SPC_BBC7:
	SPC_BBC 7
	jmp SPC_BACK

/* F4 */

SPC_MOV_A_Odp_XO:
	SPC_MOV_A_ SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* F5 */

SPC_MOV_A_Oabs_XO:
	SPC_MOV_A_ SPC_OABS_XO_ADDR
	jmp SPC_BACK

/* F6 */

SPC_MOV_A_Oabs_YO:
	SPC_MOV_A_ SPC_OABS_YO_ADDR
	jmp SPC_BACK

/* F7 */

SPC_MOV_A_OOdpO_YO:
	SPC_MOV_A_ SPC_OOdpO_YO_ADDR
	jmp SPC_BACK

/* F8 */

SPC_MOV_X_dp:
	SPC_MOV_X_ SPC_dp_ADDR
	jmp SPC_BACK

/* FA */

SPC_MOV_dp_dp:
	SPC_dp_dp_ADDR		/* %dl is (s), %si d */
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* FB */

SPC_MOV_Y_Odp_XO:
	SPC_MOV_Y_ SPC_Odp_XO_ADDR
	jmp SPC_BACK

/* FC */

SPC_INC_Y:
	incb SPC_Y
	cmpb $0,SPC_Y
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* FD */

SPC_MOV_Y_A:
	movb SPC_A,%al
	movb %al,SPC_Y
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* FE */

SPC_DBNZ_Y:
	SPC_IM_ADDR
	decb SPC_Y
	jz SPC_BACK
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
	jmp SPC_BACK

/* FF */

SPC_STOP:
	decw SPC_PC
	ret			/* What else can stop do? */
