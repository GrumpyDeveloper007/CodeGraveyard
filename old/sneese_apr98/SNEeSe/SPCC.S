/*

 SPC C0-CF Commands

*/

/* C0 */

SPC_DI:
	CLR_FLAG_SPC(SPC_FLAG_I)
	jmp SPC_BACK

/* C2 */

SPC_SET6:
	SPC_SET 6
	jmp SPC_BACK

/* C3 */

SPC_BBS6:
	SPC_BBS 6
	jmp SPC_BACK

/* C4 */

SPC_MOV_dp_A:
	SPC_MOV__A SPC_dp_ADDR
	jmp SPC_BACK

/* C5 */

SPC_MOV_abs_A:
	SPC_MOV__A SPC_ABS_ADDR
	jmp SPC_BACK

/* C6 */

SPC_MOV_OXO_A:
	SPC_MOV__A SPC_OXO_ADDR
	jmp SPC_BACK

/* C7 */

SPC_MOV_OOdp_XOO_A:
	SPC_MOV__A SPC_OOdp_XOO_ADDR
	jmp SPC_BACK

/* C8 */

SPC_CMP_X_IM:
	SPC_CMP_X SPC_IM_ADDR
	jmp SPC_BACK

/* C9 */

SPC_MOV_abs_X:
	SPC_MOV__X SPC_ABS_ADDR
	jmp SPC_BACK

/* CA */

SPC_MOV1__C:		/* mem.bit = Carry flag */
	SPC_membit_ADDR		/* %si contains mem and %dx contains bit number */
	TEST_FLAG_SPC (SPC_FLAG_C)
	jnc 0f
	GET_BYTE_SPC
	btsw %dx,%ax
	SET_BYTE_SPC
	jmp SPC_BACK
0:	GET_BYTE_SPC
	btrw %dx,%ax
	SET_BYTE_SPC
	jmp SPC_BACK

/* CB */

SPC_MOV_dp_Y:
	SPC_MOV__Y SPC_dp_ADDR
	jmp SPC_BACK

/* CC */

SPC_MOV_abs_Y:
	SPC_MOV__Y SPC_ABS_ADDR
	jmp SPC_BACK

/* CD */

SPC_MOV_X_IM:
	SPC_MOV_X_ SPC_IM_ADDR
	jmp SPC_BACK

/* CE */

SPC_POP_X:
	POP_B
	movb %al,SPC_X
	jmp SPC_BACK

/* CF */

SPC_MUL:
	movb SPC_Y,%al
	mulb SPC_A
	movb %al,SPC_A
	movb %ah,SPC_Y
	cmp $0,%ax
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK
