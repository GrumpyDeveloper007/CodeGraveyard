/*

 SPC 00-0F Commands

*/

/* 00 */

SPC_NOP:
	jmp SPC_BACK

/* 01 */

/* TCALL - Yet to be implemented */

/* 02 */

SPC_SET0:
	SPC_SET 0
	jmp SPC_BACK

/* 03 */

SPC_BBS0:
	SPC_BBS 0
	jmp SPC_BACK

/* 04 */

SPC_OR_A_dp:
	SPC_OR_A SPC_dp_ADDR
	jmp SPC_BACK

/* 05 */

SPC_OR_A_abs:
	SPC_OR_A SPC_ABS_ADDR
	jmp SPC_BACK

/* 06 */

SPC_OR_A_OXO:
	SPC_OR_A SPC_OXO_ADDR
	jmp SPC_BACK

/* 07 */

SPC_OR_A_OOdp_XOO:
	SPC_OR_A SPC_OOdp_XOO_ADDR
	jmp SPC_BACK

/* 08 */

SPC_OR_A_IM:
	SPC_OR_A SPC_IM_ADDR
	jmp SPC_BACK

/* 09 */

SPC_OR_dp_dp:
	SPC_dp_dp_ADDR		/* %dl is source byte, %si dest address */
	GET_BYTE_SPC		/* %al contains byte at dest address */
	orb %al,%dl
	cmpb $0,%dl
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	movb %dl,%al
	SET_BYTE_SPC
	jmp SPC_BACK

/* 0A */

SPC_OR1:		/* Carry flag = Carry flag OR mem.bit */
	SPC_membit_ADDR		/* %si contains mem and %dx contains bit number */
	GET_BYTE_SPC		/* Get byte at location */
	btw %dx,%ax
	jnc SPC_BACK			/* bit not set so C = C */
	SET_FLAG_SPC (SPC_FLAG_C)	/* bit set so C = 1 */
	jmp SPC_BACK

/* 0B */

SPC_ASL_dp:
	SPC_ASL SPC_dp_ADDR
	jmp SPC_BACK

/* 0C */

SPC_ASL_abs:
	SPC_ASL SPC_ABS_ADDR
	jmp SPC_BACK

/* 0D */

SPC_PUSH_PSW:
	SETUPFLAGS_SPC
	PUSH_B
	jmp SPC_BACK

/* 0E */

SPC_TSET1:			/* I have done this as TSB (65816) including the flag setting based on AND */
	SPC_ABS_ADDR
	GET_BYTE_SPC		/* Get byte */
	movb %al,%bl		/* Get a copy so we can and it later */
	orb SPC_A,%al		/* Set bits as specified */
	SET_BYTE_SPC		/* Save back to memory address */
	andb SPC_A,%bl		/* now setup the flags */
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
	jmp SPC_BACK

/* 0F */

/* BRK - Not yet implemented (maybe never) */
