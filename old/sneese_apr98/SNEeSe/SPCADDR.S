/*

	SPC Addressing mode stuff - because the SPC looks a nitemare without it!

		Code By Savouy SnaX - yup another macro based chunk

   ALL macros setup %si, the same as the CPU code.

*/

.macro SPC_IM_ADDR
	movw SPC_PC,%si
	incw SPC_PC
.endm

.macro SPC_dp_ADDR
	movw SPC_PC,%si
	incw SPC_PC
	movw SPC_PAGE,%ax
	GET_BYTE_SPC		/* Get dp */
	movw %ax,%si
.endm

.macro SPC_Odp_XO_ADDR
	xorl %ebx,%ebx
	SPC_dp_ADDR
	movb SPC_X,%bl
	addw %bx,%si
.endm

.macro SPC_Odp_YO_ADDR
	xorl %ebx,%ebx
	SPC_dp_ADDR
	movb SPC_Y,%bl
	addw %bx,%si
.endm

.macro SPC_OOdp_XOO_ADDR
	SPC_Odp_XO_ADDR
	GET_WORD_SPC
	movw %ax,%si
.endm

.macro SPC_ABS_ADDR
	movw SPC_PC,%si
	addw $2,SPC_PC
	GET_WORD_SPC
	movw %ax,%si
.endm

.macro SPC_OABS_XO_ADDR
	xorl %ebx,%ebx
	SPC_ABS_ADDR
	movb SPC_X,%bl
	addw %bx,%si
.endm

.macro SPC_OABS_YO_ADDR
	xorl %ebx,%ebx
	SPC_ABS_ADDR
	movb SPC_Y,%bl
	addw %bx,%si
.endm

.macro SPC_OOdpO_YO_ADDR
	SPC_dp_ADDR
	xorl %ebx,%ebx
	GET_WORD_SPC
	movw %ax,%si
	movb SPC_Y,%bl
	addw %bx,%si
.endm

.macro SPC_OXO_ADDR
	movw SPC_PAGE,%ax		/* Get Page Variable! */
	movb SPC_X,%al
	movw %ax,%si
.endm

.macro SPC_OYO_ADDR
	movw SPC_PAGE,%ax		/* Get Page Variable! */
	movb SPC_Y,%al
	movw %ax,%si
.endm

.macro SPC_dp_dp_ADDR		/* Special one, %dl contains source byte %si dest address */
	SPC_dp_ADDR
	GET_BYTE_SPC		/* Get source byte */
	movb %al,%dl		/* .. and store in %dl */
	SPC_dp_ADDR		/* Get dest address */
.endm

.macro SPC_dp_IM_ADDR		/* Special one, %dl contains IM byte %si dest address */
	SPC_IM_ADDR
	GET_BYTE_SPC
	movb %al,%dl
	SPC_dp_ADDR
.endm

.macro SPC_OXO_OYO_ADDR		/* Special one, %dl contains (Y) %si dest address */
	SPC_OYO_ADDR
	GET_BYTE_SPC
	movb %al,%dl
	SPC_OXO_ADDR
.endm

.macro SPC_membit_ADDR		/* This is a weird addressing mode! */
	SPC_IM_ADDR
	GET_BYTE_SPC		/* Get address lo + bit num in lowest 3 bits */
	movb %al,%dl		/* We need somewhere to mask off bits */
	movb %al,%cl		/* We build address in %cx */
	andw $0x0007,%dx	/* We now have the bit number in %dx */
	SPC_IM_ADDR
	GET_BYTE_SPC		/* Get hi part of address */
	movb %al,%ch		/* %cx contains address to swap bit of << 3 */
	shrw $3,%cx
	movw %cx,%si		/* Return address in %si */
.endm

.macro SPC_OXOInc_ADDR
	movw SPC_PAGE,%ax		/* Get Page Variable! */
	movb SPC_X,%al
	movw %ax,%si
	incb SPC_X
.endm
