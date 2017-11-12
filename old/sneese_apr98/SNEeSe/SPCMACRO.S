/*

	SPC Macro stuff - because the SPC looks a nitemare without it!

		Code By Savouy SnaX - yup another macro based chunk

*/

.macro SPC_SET bitnum
	SPC_dp_ADDR
	GET_BYTE_SPC		/* Get (dp) */
	orb $1<<(\bitnum),%al
	SET_BYTE_SPC
.endm

.macro SPC_CLR bitnum
	SPC_dp_ADDR
	GET_BYTE_SPC		/* Get (dp) */
	andb $~(1<<(\bitnum)),%al
	SET_BYTE_SPC
.endm

.macro SPC_BBS bitnum
	SPC_dp_ADDR
	GET_BYTE_SPC		/* Get (dp) */
	SPC_IM_ADDR
	andb $1<<(\bitnum),%al
	jz 9f			/* bit clr - No branch */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
9:
.endm

.macro SPC_BBC bitnum
	SPC_dp_ADDR
	GET_BYTE_SPC		/* Get (dp) */
	SPC_IM_ADDR
	andb $1<<(\bitnum),%al
	jnz 9f			/* bit set - No branch */
	subl $2,SPC_Cycles	/* Branch taken */
	GET_BYTE_SPC
	cbw			/* sign extend for addition */
	addw %ax,SPC_PC
9:
.endm

.macro SPC_OR_A addr
	\addr
	GET_BYTE_SPC
	orb %al,SPC_A
	cmpb $0,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
.endm

.macro SPC_AND_A addr
	\addr
	GET_BYTE_SPC
	andb %al,SPC_A
	cmpb $0,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
.endm

.macro SPC_EOR_A addr
	\addr
	GET_BYTE_SPC
	xorb %al,SPC_A
	cmpb $0,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
.endm

.macro SPC_CMP_A addr
	\addr
	GET_BYTE_SPC
	cmpb %al,SPC_A
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C)
	CPL_FLAG_SPC(SPC_FLAG_C)
.endm

.macro SPC_ADC_A addr
	\addr
	GET_BYTE_SPC
	pushw %ax
	MAKE_FLAGS_SPC (SPC_MASK_C)
	popw %ax
	adcb %al,SPC_A
	pushf
	jo 1f
	CLR_FLAG_SPC(SPC_FLAG_V)		/* Done cos STORE_FLAGS cant alter V ! */
	jmp 2f
1:	SET_FLAG_SPC(SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C+SPC_MASK_H)
.endm

.macro SPC_SBC_A addr
	\addr
	GET_BYTE_SPC
	pushw %ax
	MAKE_FLAGS_SPC_INV (SPC_MASK_C)
	popw %ax
	sbbb %al,SPC_A
	pushf
	jo 1f
	CLR_FLAG_SPC(SPC_FLAG_V)		/* Done cos STORE_FLAGS cant alter V ! */
	jmp 2f
1:	SET_FLAG_SPC(SPC_FLAG_V)
2:	popf
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C+SPC_MASK_H)
	CPL_FLAG_SPC(SPC_FLAG_C)
.endm

.macro SPC_DEC addr
	\addr
	GET_BYTE_SPC
	decb %al
	SET_BYTE_SPC
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
.endm

.macro SPC_INC addr
	\addr
	GET_BYTE_SPC
	incb %al
	SET_BYTE_SPC
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
.endm

.macro SPC_ASL addr
	\addr
	GET_BYTE_SPC
	movb %al,%bl
	salb $1,%bl
	STORE_FLAGS_SPC (SPC_MASK_C+SPC_MASK_Z+SPC_MASK_N)
	movb %bl,%al
	SET_BYTE_SPC
.endm

.macro SPC_LSR addr
	\addr
	GET_BYTE_SPC
	movb %al,%bl
	shrb $1,%bl
	STORE_FLAGS_SPC (SPC_MASK_C+SPC_MASK_Z+SPC_MASK_N)
	movb %bl,%al
	SET_BYTE_SPC
.endm

.macro SPC_ROL addr
	\addr
	GET_BYTE_SPC
	movb %al,%bl
	MAKE_FLAGS_SPC (SPC_MASK_C)
	rclb $1,%bl
	STORE_FLAGS_SPC (SPC_MASK_C)
	cmpb $0,%bl
	STORE_FLAGS_SPC (SPC_MASK_N+SPC_MASK_Z)
	movb %bl,%al
	SET_BYTE_SPC
.endm

.macro SPC_ROR addr
	\addr
	GET_BYTE_SPC
	movb %al,%bl
	MAKE_FLAGS_SPC (SPC_MASK_C)
	rcrb $1,%bl
	STORE_FLAGS_SPC (SPC_MASK_C)
	cmpb $0,%bl
	STORE_FLAGS_SPC (SPC_MASK_N+SPC_MASK_Z)
	movb %bl,%al
	SET_BYTE_SPC
.endm

.macro SPC_CMP_X addr
	\addr
	GET_BYTE_SPC
	cmpb %al,SPC_X
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C)
	CPL_FLAG_SPC(SPC_FLAG_C)
.endm

.macro SPC_CMP_Y addr
	\addr
	GET_BYTE_SPC
	cmpb %al,SPC_Y
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N+SPC_MASK_C)
	CPL_FLAG_SPC(SPC_FLAG_C)
.endm

.macro SPC_MOV__A addr
	\addr
	movb SPC_A,%al
	SET_BYTE_SPC
.endm

.macro SPC_MOV__X addr
	\addr
	movb SPC_X,%al
	SET_BYTE_SPC
.endm

.macro SPC_MOV__Y addr
	\addr
	movb SPC_Y,%al
	SET_BYTE_SPC
.endm

.macro SPC_MOV_A_ addr
	\addr
	GET_BYTE_SPC
	movb %al,SPC_A
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
.endm

.macro SPC_MOV_X_ addr
	\addr
	GET_BYTE_SPC
	movb %al,SPC_X
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
.endm

.macro SPC_MOV_Y_ addr
	\addr
	GET_BYTE_SPC
	movb %al,SPC_Y
	cmpb $0,%al
	STORE_FLAGS_SPC (SPC_MASK_Z+SPC_MASK_N)
.endm
