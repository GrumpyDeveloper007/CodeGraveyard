/*

 CPU Macros e.g. LDA macro... then you just apply the addressing mode!

*/

.macro EM_LDA addr
	\addr		/* Get address set up in esi for reading from */
	GET_BYTE
	movb %al,_SNES_A
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro E0_LDA addr
	\addr
	GET_WORD
    movw %ax,_SNES_A
    testw %ax,%ax       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro EM_STZ addr
	\addr
    xorb %al,%al
	SET_BYTE
.endm

.macro E0_STZ addr
	\addr
    xorl %eax,%eax
	SET_WORD
.endm

.macro EM_STA addr
	\addr
	movb _SNES_A,%al
	SET_BYTE
.endm

.macro E0_STA addr
	\addr
    movl _SNES_A,%eax
	SET_WORD
.endm

.macro EX_LDX addr
	\addr
	GET_BYTE
	movb %al,_SNES_X
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro E0_LDX addr
	\addr
	GET_WORD
    movw %ax,_SNES_X
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	BCT flag
	IMMEDIATE_ADDR
	incw _SNES_PC
    JUMP_NOT_FLAG \flag,9f /* condition not true */
    addl $4,SNES_Cycles2   /* Branch taken */
	GET_BYTE
	cbw			/* sign extend for addition */
	addw %ax,_SNES_PC
9:
.endm

.macro	BCF flag
	IMMEDIATE_ADDR
	incw _SNES_PC
    JUMP_FLAG \flag,9f      /* condition true */
    addl $4,SNES_Cycles2    /* Branch taken */
	GET_BYTE
	cbw			/* sign extend for addition */
	addw %ax,_SNES_PC
9:
.endm

.macro EX_LDY addr
	\addr
	GET_BYTE
	movb %al,_SNES_Y
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro E0_LDY addr
	\addr
	GET_WORD
    movw %ax,_SNES_Y
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro EM_CMP addr			/* CMP */
	\addr
	GET_BYTE
	cmpb %al,_SNES_A		/* Flags N,Z & C are setup so we can mask them off */
    cmc
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
.endm

.macro E0_CMP addr
	\addr
	GET_WORD
    cmpw %ax,_SNES_A        /* Flags N,Z & C are setup so we can mask them off */
    cmc
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
.endm

.macro EX_CPX addr			/* CPX */
	\addr
	GET_BYTE
	cmpb %al,_SNES_X		/* Flags N,Z & C are setup so we can mask them off */
    cmc
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
.endm

.macro E0_CPX addr
	\addr
	GET_WORD
	cmpw %ax,_SNES_X		/* Flags N,Z & C are setup so we can mask them off */
    cmc
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
.endm

.macro EM_ADC addr
	\addr
	GET_BYTE
	pushw %ax
    CLR_FLAG(SNES_FLAG_V)
    MAKE_FLAGS(MASK_FLAG_C)
	popw %ax
	adcb %al,_SNES_A
	pushf
    jno 2f
    SET_FLAG(SNES_FLAG_V)
2:  JUMP_FLAG SNES_FLAG_D,0f
    popf
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
	jmp 3f

0:  popf
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	movb _SNES_A,%al
	daa				/* Adjust byte to be decimal */
	movb %al,_SNES_A
	STORE_FLAGS (MASK_FLAG_C)
3:
.endm

.macro E0_ADC addr
	\addr
	GET_WORD
    pushl %eax
    CLR_FLAG(SNES_FLAG_V)
    JUMP_FLAG SNES_FLAG_D,0f
    MAKE_FLAGS(MASK_FLAG_C)
    popl %eax
	adcw %ax,_SNES_A
	pushf
    jno 2f
    SET_FLAG(SNES_FLAG_V)
2:	popf
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
	jmp 3f

0:	MAKE_FLAGS (MASK_FLAG_C)
    popl %eax
    movl _SNES_A,%ecx
    adcb %cl,%al
	daa
    movb %al,%cl
    adcb %ah,%ch
    movb %al,%ch
	pushf
    jno 2f
    SET_FLAG(SNES_FLAG_V)
2:	popf
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
    movb %ch,%al
	daa				/* Adjust byte to be decimal */
    movb %al,%ch
    movw %cx,_SNES_A
	STORE_FLAGS (MASK_FLAG_C)
3:
.endm

.macro EX_STX addr
	\addr
	movb _SNES_X,%al
	SET_BYTE
.endm

.macro E0_STX addr
	\addr
	movw _SNES_X,%ax
	SET_WORD
.endm

.macro	EM_INC addr
	\addr
	GET_BYTE
	incb %al
	SET_BYTE
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	E0_INC addr
	\addr
	GET_WORD
	incw %ax
	decl %esi		/* Must do this or esi will point to second byte of word! */
	SET_WORD
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	EM_DEC addr
	\addr
	GET_BYTE
	decb %al
	SET_BYTE
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	E0_DEC addr
	\addr
	GET_WORD
	decw %ax
	decl %esi
	SET_WORD
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	EM_AND addr
	\addr
	GET_BYTE
	andb %al,_SNES_A		/* Flag Z,N is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	E0_AND addr
	\addr
	GET_WORD
	andw %ax,_SNES_A		/* Flag Z,N is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	EM_BIT addr
	\addr
	GET_BYTE
    CLR_FLAG(SNES_FLAG_N)
    testb $0x80,%al
    jz  1f
    SET_FLAG(SNES_FLAG_N)
1:  CLR_FLAG(SNES_FLAG_V)
    testb $0x40,%al
    jz  1f
    SET_FLAG(SNES_FLAG_V)
1:	andb _SNES_A,%al		/* Flag Z is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z)
.endm

.macro	E0_BIT addr
	\addr
	GET_WORD
    CLR_FLAG(SNES_FLAG_N)
    testl $0x8000,%eax
    jz  1f
0:  SET_FLAG(SNES_FLAG_N)
1:  CLR_FLAG(SNES_FLAG_V)
    testl $0x4000,%ax
    jz  1f
    SET_FLAG(SNES_FLAG_V)
1:	andw _SNES_A,%ax		/* Flag Z is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z)
.endm

.macro EX_STY addr
	\addr
    movb _SNES_Y,%al
	SET_BYTE
.endm

.macro E0_STY addr
	\addr
	movw _SNES_Y,%ax
	SET_WORD
.endm

.macro EM_SBC addr
	\addr
	GET_BYTE
	pushw %ax
    CLR_FLAG(SNES_FLAG_V)
    MAKE_FLAGS_INV(MASK_FLAG_C)
	popw %ax
	sbbb %al,_SNES_A
	pushf
    jno 2f
    SET_FLAG(SNES_FLAG_V)
2:  JUMP_FLAG SNES_FLAG_D,0f
    popf
    cmc
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
	jmp 3f

0:  popf
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	movb _SNES_A,%al
	das				/* Adjust byte to be decimal */
	movb %al,_SNES_A
    cmc
    STORE_FLAGS(MASK_FLAG_C)
3:
.endm

.macro E0_SBC addr
	\addr
	GET_WORD
	pushw %ax
    CLR_FLAG(SNES_FLAG_V)
    JUMP_FLAG SNES_FLAG_D,0f
	MAKE_FLAGS_INV (MASK_FLAG_C)
	popw %ax
	sbbw %ax,_SNES_A
	pushf
    jno 2f
    SET_FLAG(SNES_FLAG_V)
2:	popf
    cmc
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
	jmp 3f

0:	MAKE_FLAGS_INV (MASK_FLAG_C)
    popw %bx
    movw _SNES_A,%cx
    movb %cl,%al
    sbbb %bl,%al
	das
    movb %al,%bl
    movb %ch,%al
    sbbb %bh,%al
    movb %al,%bh
	pushf
    jno 2f
    SET_FLAG(SNES_FLAG_V)
2:	popf
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
    movb %bh,%al
	das				/* Adjust byte to be decimal */
    movb %al,%bh
    movw %bx,_SNES_A
    cmc
	STORE_FLAGS (MASK_FLAG_C)
3:
.endm

.macro	EM_ORA addr
	\addr
	GET_BYTE
	orb %al,_SNES_A			/* Flag Z,N is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	E0_ORA addr
	\addr
	GET_WORD
	orw %ax,_SNES_A			/* Flag Z,N is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro EX_CPY addr			/* CPY */
	\addr
	GET_BYTE
	cmpb %al,_SNES_Y		/* Flags N,Z & C are setup so we can mask them off */
    cmc
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
.endm

.macro E0_CPY addr
	\addr
	GET_WORD
	cmpw %ax,_SNES_Y			/* Flags N,Z & C are setup so we can mask them off */
    cmc
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N+MASK_FLAG_C)
.endm

/* TRB set flag Z on A & Memory Operand not A & !Memory Operand! */

.macro	EM_TRB addr			/* Test and Reset bit */
	\addr
	GET_BYTE
	movb %al,%bl
	movb _SNES_A,%al
	notb %al
	andb %bl,%al
	SET_BYTE
	andb _SNES_A,%bl		/* Flag Z is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z)
.endm

.macro	E0_TRB addr
	\addr
	GET_WORD
	movw %ax,%bx
	movw _SNES_A,%ax
	notw %ax
	andw %bx,%ax
	decl %esi
	SET_WORD
	andw _SNES_A,%bx		/* Flag Z is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z)
.endm

.macro	EM_EOR addr
	\addr
	GET_BYTE
	xorb %al,_SNES_A		/* Flag Z,N is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	E0_EOR addr
	\addr
	GET_WORD
	xorw %ax,_SNES_A		/* Flag Z,N is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
.endm

.macro	EM_ROR addr
	\addr
	GET_BYTE
	movl %eax,%ebx
	MAKE_FLAGS (MASK_FLAG_C)
	rcrb $1,%bl
	STORE_FLAGS (MASK_FLAG_C)
    testb %bl,%bl
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	movl %ebx,%eax
	SET_BYTE
.endm

.macro	E0_ROR addr
	\addr
	GET_WORD
	movl %eax,%ebx
	MAKE_FLAGS (MASK_FLAG_C)
	rcrw $1,%bx
	STORE_FLAGS (MASK_FLAG_C)
    testw %bx,%bx
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	movl %ebx,%eax
	decl %esi
	SET_WORD
.endm

.macro	EM_LSR addr
	\addr
	GET_BYTE
	movl %eax,%ebx
	shrb $1,%bl
	STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	movl %ebx,%eax
	SET_BYTE
.endm

.macro	E0_LSR addr
	\addr
	GET_WORD
	movl %eax,%ebx
	shrw $1,%bx
	STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	movl %ebx,%eax
	decl %esi
	SET_WORD
.endm

.macro	EM_ASL addr
	\addr
	GET_BYTE
	movl %eax,%ebx
    addb %bl,%bl
	STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	movl %ebx,%eax
	SET_BYTE
.endm

.macro	E0_ASL addr
	\addr
	GET_WORD
	movl %eax,%ebx
    addw %bx,%bx
	STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	movl %ebx,%eax
	decl %esi
	SET_WORD
.endm

.macro	EM_ROL addr
	\addr
	GET_BYTE
	movl %eax,%ebx
	MAKE_FLAGS (MASK_FLAG_C)
    adcb %bl,%bl
    STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	movl %ebx,%eax
	SET_BYTE
.endm

.macro	E0_ROL addr
	\addr
    GET_WORD
	movl %eax,%ebx
	MAKE_FLAGS (MASK_FLAG_C)
    adcw %bx,%bx
    STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	movl %ebx,%eax
	decl %esi
	SET_WORD
.endm

/* TSB set flag Z on A & Memory Operand not A | Memory Operand! */

.macro	EM_TSB addr			/* Test and Set bit */
	\addr
	GET_BYTE
	movl %eax,%ebx
	orb _SNES_A,%al
	SET_BYTE
	andb _SNES_A,%bl		/* Flag Z is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z)
.endm

.macro	E0_TSB addr
	\addr
	GET_WORD
	movl %eax,%ebx
	orw _SNES_A,%ax
	decl %esi
	SET_WORD
	andw _SNES_A,%bx		/* Flag Z is setup so we can mask it off */
	STORE_FLAGS (MASK_FLAG_Z)
.endm
