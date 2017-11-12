/*

 CPU Opcodes 0x50-0x5F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BVC r   | EOR (d),y |  EOR (d)  |EOR (d,s),y|
|    2 2    |    2 5    |    2 5    |    2 7    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|  MVN xya  |  EOR d,x  |  LSR d,x  | EOR [d],y |
|    3 7    |    2 4    |    2 6    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   CLI i   |  EOR a,y  |   PHY s   |   TCD i   |
|    1 2    |    3 4    |    1 3    |    1 2    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|  JMP al   |  EOR a,x  |  LSR a,x  | EOR al,x  |
|    4 4    |    3 4    |    3 7    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 50 */

ALL_BVC:
	BCF SNES_FLAG_V		/* branch if V=0 */
	ret

/* 51 */

EM_EOR_OdO_y:
	EM_EOR DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret
E0_EOR_OdO_y:
	E0_EOR DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret

/* 52 */

EM_EOR_OdO:
	EM_EOR DIRECT_INDIRECT_ADDR
	ret
E0_EOR_OdO:
	E0_EOR DIRECT_INDIRECT_ADDR
	ret

/* 53 */

EM_EOR_Od_sO_y:
	EM_EOR STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret
E0_EOR_Od_sO_y:
	E0_EOR STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret

/* 54 */

E0_MVN:
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
	movw _SNES_X,%ax			/* Src Address */
	movl %eax,%esi
    incl %eax
    movw %ax,_SNES_X
	GET_BYTE
    movw _SNES_Y,%bx            /* Dest Address */
    movl %ebx,%esi
    incl %ebx
    movw %bx,_SNES_Y
	SET_BYTE
    movl _SNES_A,%eax
    testl %eax,%eax
    jz 0f

    subw $3,_SNES_PC

0:  decl %eax
    movw %ax,_SNES_A
	ret
	
EX_MVN:
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
	movl %eax,%esi
    incl %eax
    movb %al,_SNES_X
	GET_BYTE
    movb _SNES_Y,%bl            /* Dest Address */
    movl %ebx,%esi
    incl %ebx
    movb %bl,_SNES_Y
	SET_BYTE
    movl _SNES_A,%eax
    testl %eax,%eax
    jz 0f

    subw $3,_SNES_PC

0:  decl %eax
    movw %ax,_SNES_A
	ret

/* 55 */

EM_EOR_d_x:
	EM_EOR DIRECT_INDEX_X_ADDR
	ret
E0_EOR_d_x:
	E0_EOR DIRECT_INDEX_X_ADDR
	ret

/* 56 */

EM_LSR_d_x:						/* lsr d,x */
	EM_LSR DIRECT_INDEX_X_ADDR
	ret
E0_LSR_d_x:
	E0_LSR DIRECT_INDEX_X_ADDR
	ret

/* 57 */

EM_EOR_IdI_y:
	EM_EOR DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret
E0_EOR_IdI_y:
	E0_EOR DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret

/* 58 */

ALL_CLI:			/* Clr Interrupt Disable Flag */
	CLR_FLAG SNES_FLAG_I
    movb IRQRcvd,%al
    testb %al,%al   // Was an IRQ missed?
    jz  0f
    movb $0,IRQRcvd // Service IRQ, clear flag
    testl $MASK_FLAG_E,%ebx // Emulation mode?
    jz  1f
    // Emulation mode IRQ
    movb _SNES_PC+1,%al
    E1_PUSH_B
	movb _SNES_PC,%al
	E1_PUSH_B
    CLR_FLAG(SNES_FLAG_B)   // Clear break bit
    E1_SETUPFLAGS           // put flags into SNES packed flag format
	E1_PUSH_B

    xorl %esi,%esi          // Setup bank
    movl %esi,SNES_ProgBank
    addl $0xfffe,%esi
    jmp 2f

1:  // Native mode IRQ
    movb _SNES_PB,%al
    E0_PUSH_B
    movb _SNES_PC+1,%al
    E0_PUSH_B
	movb _SNES_PC,%al
	E0_PUSH_B
    E0_SETUPFLAGS           // put flags into SNES packed flag format
	E0_PUSH_B

    xorl %esi,%esi          // Setup bank
    movl %esi,SNES_ProgBank
    addl $0xffee,%esi
2:  SET_FLAG(SNES_FLAG_I)   // Disable interrupts
	CLR_FLAG(SNES_FLAG_D)
	GET_WORD
	movw %ax,_SNES_PC
    movb $0x80,TIMEUP       // Disable further IRQ's
0:  ret

/* 59 */

EM_EOR_a_y:
	EM_EOR ABSOLUTE_INDEX_Y_ADDR
	ret
E0_EOR_a_y:
	E0_EOR ABSOLUTE_INDEX_Y_ADDR
	ret

/* 5A */

E0_PHY:				/* Push Y onto stack */
	movw _SNES_Y,%ax
	E0_PUSH_W
	ret
EX_PHY:
	movw _SNES_Y,%ax
	E0_PUSH_B
	ret
E1_PHY:
	movw _SNES_Y,%ax
	E1_PUSH_B
	ret

/* 5B */

ALL_TCD:				/* Transfer A to D */
    movl _SNES_A,%eax
    movl %eax,_SNES_D           /* D|A is now setup as A|A since D=A */
    testw %ax,%ax
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 5C */

ALL_JMP_al:				/* JMP Absolute long address */
	ABSOLUTE_LONG_ADDR
	movw %si,_SNES_PC
	andl $0x00FF0000,%esi
	movl %esi,SNES_ProgBank
	ret

/* 5D */

EM_EOR_a_x:
	EM_EOR ABSOLUTE_INDEX_X_ADDR
	ret
E0_EOR_a_x:
	E0_EOR ABSOLUTE_INDEX_X_ADDR
	ret

/* 5E */

EM_LSR_a_x:						/* lsr a,x */
	EM_LSR ABSOLUTE_INDEX_X_ADDR
	ret
E0_LSR_a_x:
	E0_LSR ABSOLUTE_INDEX_X_ADDR
	ret

/* 5F */

EM_EOR_al_x:
	EM_EOR ABSOLUTE_LONG_INDEX_X_ADDR
	ret
E0_EOR_al_x:
	E0_EOR ABSOLUTE_LONG_INDEX_X_ADDR
	ret

