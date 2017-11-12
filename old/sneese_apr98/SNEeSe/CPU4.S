/*

 CPU Opcodes 0x40-0x4F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   RTI s   | EOR (d,x) |  reserve  |  EOR d,s  |
|    1 7    |    2 6    |    2 2    |    2 4    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|  MVP xya  |   EOR d   |   LSR d   |  EOR [d]  |
|    3 7    |    2 3    |    2 5    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   PHA s   |   EOR #   |   LSR A   |   PHK s   |
|    1 3    |    2 2    |    1 2    |    1 3    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   JMP a   |   EOR a   |   LSR a   |   EOR al  |
|    3 3    |    3 4    |    3 6    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 40 */

E0_RTI:
	E0_POP_B
    E0_RESTOREFLAGS
	E0_POP_B
	movb %al,_SNES_PC
	E0_POP_B
	movb %al,_SNES_PC+1
	E0_POP_B
    movb %al,_SNES_PB
	SET_TABLE_MX

E1_RTI:
	E1_POP_B
    E1_RESTOREFLAGS
    SET_FLAG(SNES_FLAG_B)   // Set break flag
	E1_POP_B
	movb %al,_SNES_PC
	E1_POP_B
	movb %al,_SNES_PC+1
	ret

/* 41 */

EM_EOR_Od_xO:
	EM_EOR DIRECT_INDEX_INDIRECT_X_ADDR
	ret
E0_EOR_Od_xO:
	E0_EOR DIRECT_INDEX_INDIRECT_X_ADDR
	ret

/* 42 */
ALL_WDM:
    incw %si
    movw %si,_SNES_PC
    ret

/* 43 */

EM_EOR_d_s:
	EM_EOR STACK_RELATIVE_ADDR
	ret
E0_EOR_d_s:
	E0_EOR STACK_RELATIVE_ADDR
	ret

/* 44 */

E0_MVP:
	IMMEDIATE_ADDR
    xorl %eax,%eax
    GET_BYTE    // Dest bank
    xorl %ebx,%ebx
    movb %al,%bl
	incl %esi
    GET_BYTE    // Src bank
    incl %esi
    shll $16,%ebx
    movw %si,_SNES_PC
    shll $16,%eax
	movw _SNES_X,%ax			/* Src Address */
    movw _SNES_Y,%bx            /* Dest Address */
	movl %eax,%esi
    decl %eax
    movw %ax,_SNES_X
	GET_BYTE
    movl %ebx,%esi
    decl %ebx
    movw %bx,_SNES_Y
	SET_BYTE
    movl _SNES_A,%eax
    testl %eax,%eax
    jz 0f

    subw $3,_SNES_PC

0:  decl %eax
    movw %ax,_SNES_A
	ret
	
EX_MVP:
	IMMEDIATE_ADDR
    xorl %eax,%eax
    GET_BYTE    // Dest bank
    xorl %ebx,%ebx
    movb %al,%bl
	incl %esi
    GET_BYTE    // Src bank
    incl %esi
    roll $16,%ebx
    movw %si,_SNES_PC
	roll $16,%eax
    movb _SNES_X,%al            /* Src Address */
    movb _SNES_Y,%bl            /* Dest Address */
	movl %eax,%esi
    decl %eax
    movb %al,_SNES_X
	GET_BYTE
    movl %ebx,%esi
    decl %ebx
    movb %bl,_SNES_Y
	SET_BYTE
    movl _SNES_A,%eax
    testl %eax,%eax
    jz 0f

    subw $3,_SNES_PC

0:  decl %eax
    movw %ax,_SNES_A
	ret

/* 45 */

EM_EOR_d:
	EM_EOR DIRECT_ADDR
	ret
E0_EOR_d:
	E0_EOR DIRECT_ADDR
	ret

/* 46 */

EM_LSR_d:						/* lsr d */
	EM_LSR DIRECT_ADDR
	ret
E0_LSR_d:
	E0_LSR DIRECT_ADDR
	ret

/* 47 */

EM_EOR_IdI:
	EM_EOR DIRECT_INDIRECT_LONG_ADDR
	ret
E0_EOR_IdI:
	E0_EOR DIRECT_INDIRECT_LONG_ADDR
	ret

/* 48 */

E0_PHA:				/* Push A onto stack */
	movw _SNES_A,%ax
	E0_PUSH_W
	ret
EM_PHA:
	movb _SNES_A,%al
	E0_PUSH_B
	ret
E1_PHA:
	movb _SNES_A,%al
	E1_PUSH_B
	ret

/* 49 */

EM_EOR_i:
	EM_EOR IMMEDIATE_ADDR
	incw _SNES_PC
	ret
E0_EOR_i:
	E0_EOR IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* 4A */

EM_SRA:						/* Shr A */
    movb _SNES_A,%al
    shrb $1,%al
    movb %al,_SNES_A
	STORE_FLAGS (MASK_FLAG_C)
    testb %al,%al
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_SRA:
    movl _SNES_A,%eax
    shrl $1,%eax
    movl %eax,_SNES_A
	STORE_FLAGS (MASK_FLAG_C)
    cmpw $0,_SNES_A
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 4B */

E0_PHK:				/* Push PB(K) onto stack */
    movb _SNES_PB,%al
	E0_PUSH_B
	ret
E1_PHK:
    movb _SNES_PB,%al
	E1_PUSH_B
	ret

/* 4C */

ALL_JMP_a:				/* JMP Absolute address */
	ABSOLUTE_ADDR_JMP
	movw %si,_SNES_PC
	ret

/* 4D */

EM_EOR_a:
	EM_EOR ABSOLUTE_ADDR
	ret
E0_EOR_a:
	E0_EOR ABSOLUTE_ADDR
	ret

/* 4E */

EM_LSR_a:						/* lsr a */
	EM_LSR ABSOLUTE_ADDR
	ret
E0_LSR_a:
	E0_LSR ABSOLUTE_ADDR
	ret

/* 4F */

EM_EOR_al:
	EM_EOR ABSOLUTE_LONG_ADDR
	ret
E0_EOR_al:
	E0_EOR ABSOLUTE_LONG_ADDR
	ret
