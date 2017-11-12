/*

 SPC E0-EF Commands

*/

/* E0 */

SPC_CLRV:
	CLR_FLAG_SPC(SPC_FLAG_V)
	CLR_FLAG_SPC(SPC_FLAG_H)
	jmp SPC_BACK

/* E1 */

/* TCALL - not yet implemented */

/* E2 */

SPC_SET7:
	SPC_SET 7
	jmp SPC_BACK

/* E3 */

SPC_BBS7:
	SPC_BBS 7
	jmp SPC_BACK

/* E4 */

SPC_MOV_A_dp:
	SPC_MOV_A_ SPC_dp_ADDR
	jmp SPC_BACK

/* E5 */

SPC_MOV_A_abs:
	SPC_MOV_A_ SPC_ABS_ADDR
	jmp SPC_BACK

/* E6 */

SPC_MOV_A_OXO:
	SPC_MOV_A_ SPC_OXO_ADDR
	jmp SPC_BACK

/* E7 */

SPC_MOV_A_OOdp_XOO:
	SPC_MOV_A_ SPC_OOdp_XOO_ADDR
	jmp SPC_BACK

/* E8 */

SPC_MOV_A_IM:
	SPC_MOV_A_ SPC_IM_ADDR
	jmp SPC_BACK

/* E9 */

SPC_MOV_X_abs:
	SPC_MOV_X_ SPC_ABS_ADDR
	jmp SPC_BACK

/* EA */

SPC_NOT1:		/* !mem.bit */
	SPC_membit_ADDR		/* %si contains mem and %dx contains bit number */
	GET_BYTE_SPC		/* Get byte at location */
	btcw %dx,%ax	/* complement the bit */
	SET_BYTE_SPC	/* set byte */
	jmp SPC_BACK

/* EB */

SPC_MOV_Y_dp:
	SPC_MOV_Y_ SPC_dp_ADDR
	jmp SPC_BACK

/* EC */

SPC_MOV_Y_abs:
	SPC_MOV_Y_ SPC_ABS_ADDR
	jmp SPC_BACK

/* ED */

SPC_NOTC:
	CPL_FLAG_SPC(SPC_FLAG_C)
	jmp SPC_BACK

/* EE */

SPC_POP_Y:
	POP_B
	movb %al,SPC_Y
	jmp SPC_BACK

/* EF */

SPC_SLEEP:
	decw SPC_PC
	ret			/* What else can sleep do? */
