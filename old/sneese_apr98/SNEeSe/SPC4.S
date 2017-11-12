/*

 SPC 40-4F Commands

*/

/* 40 */

SPC_SETP:
	SET_FLAG_SPC(SPC_FLAG_P)
	CLR_FLAG_SPC(SPC_FLAG_I)
	movw $0x0100,SPC_PAGE
	jmp SPC_BACK

/* 41 */

/* TCALL - not yet implemented */

/* 42 */

SPC_SET2:
	SPC_SET 2
	jmp SPC_BACK

/* 43 */

SPC_BBS2:
	SPC_BBS 2
	jmp SPC_BACK

/* 44 */

SPC_EOR_A_dp:
	SPC_EOR_A SPC_dp_ADDR
	jmp SPC_BACK

/* 45 */

SPC_EOR_A_abs:
	SPC_EOR_A SPC_ABS_ADDR
	jmp SPC_BACK

/* 46 */

SPC_EOR_A_OXO:
	SPC_EOR_A SPC_OXO_ADDR
	jmp SPC_BACK

/* 47 */

SPC_EOR_A_OOdp_XOO:
	SPC_EOR_A SPC_OOdp_XOO_ADDR
	jmp SPC_BACK

/* 48 */

SPC_EOR_A_IM:
	SPC_EOR_A SPC_IM_ADDR
	jmp SPC_BACK

/* 49 */

SPC_EOR_dp_dp:
	SPC_dp_dp_ADDR
	GET_BYTE_SPC
	xorb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 4A */

SPC_AND1:		/* Carry flag = Carry flag AND mem.bit */
	SPC_membit_ADDR		/* %si contains mem and %dx contains bit number */
	GET_BYTE_SPC		/* Get byte at location */
	btw %dx,%ax
	jc SPC_BACK			/* bit set so C = C */
	CLR_FLAG_SPC (SPC_FLAG_C)	/* bit not set so C = 0 */
	jmp SPC_BACK

/* 4B */

SPC_LSR_dp:
	SPC_LSR SPC_dp_ADDR
	jmp SPC_BACK

/* 4C */

SPC_LSR_abs:
	SPC_LSR SPC_ABS_ADDR
	jmp SPC_BACK

/* 4D */

SPC_PUSH_X:
	movb SPC_X,%al
	PUSH_B
	jmp SPC_BACK

/* 4E */

SPC_TCLR1:			/* I have done this as TRB (65816) including the flag setting based on AND */
	SPC_ABS_ADDR
	GET_BYTE_SPC		/* Get byte */
	movb %al,%bl		/* Get a copy so we can and it later */
	movb SPC_A,%cl
	notb %cl
	andb %cl,%al		/* Set bits as specified */
	SET_BYTE_SPC		/* Save back to memory address */
	andb SPC_A,%bl		/* now setup the flags */
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 4F */

SPC_PCALL:			/* u-page is the last page on the SPC RAM (uppermost-page!) */
	SPC_IM_ADDR
	movw $0xFF00,%ax	/* Setup uppermost page */
	GET_BYTE_SPC		/* Get offset into upage to jump to */
	movw %ax,%si
	movw SPC_PC,%ax
	PUSH_W
	movw %si,SPC_PC
	jmp SPC_BACK
