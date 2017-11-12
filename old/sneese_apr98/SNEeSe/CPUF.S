/*

 CPU Opcodes 0xF0-0xFF Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BEQ r   | SBC (d),y |  SBC (d)  |SBC (d,s),y|
|    2 2    |    2 5    |    2 5    |    2 7    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   PEA s   |  SBC d,x  |  INC d,x  | SBC [d],y |
|    3 5    |    2 4    |    2 6    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   SED i   |  SBC a,y  |   PLX s   |   XCE i   |
|    1 2    |    3 4    |    1 4    |    1 2    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
| JSR (a,x) |  SBC a,x  |  INC a,x  | SBC al,x  |
|    3 6    |    3 4    |    3 7    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* F0 */

ALL_BEQ:
	BCT SNES_FLAG_Z		/* branch if Z=1 */
	ret

/* F1 */

EM_SBC_OdO_y:
	EM_SBC DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret
E0_SBC_OdO_y:
	E0_SBC DIRECT_INDIRECT_INDEXED_Y_ADDR
	ret

/* F2 */

EM_SBC_OdO:
	EM_SBC DIRECT_INDIRECT_ADDR
	ret
E0_SBC_OdO:
	E0_SBC DIRECT_INDIRECT_ADDR
	ret

/* F3 */

EM_SBC_Od_sO_y:
	EM_SBC STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret
E0_SBC_Od_sO_y:
	E0_SBC STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR
	ret

/* F4 */

E0_PEA:				/* Push Effective Absolute address onto stack */
	movl SNES_ProgBank,%esi
	movw _SNES_PC,%si
	GET_WORD
    addw $2,_SNES_PC
	E0_PUSH_W
	ret
E1_PEA:
	movl SNES_ProgBank,%esi
	movw _SNES_PC,%si
	GET_WORD
    addw $2,_SNES_PC
	E1_PUSH_W
	ret

/* F5 */

EM_SBC_d_x:
	EM_SBC DIRECT_INDEX_X_ADDR
	ret
E0_SBC_d_x:
	E0_SBC DIRECT_INDEX_X_ADDR
	ret

/* F6 */

EM_INC_d_x:
	EM_INC DIRECT_INDEX_X_ADDR
	ret
E0_INC_d_x:
	E0_INC DIRECT_INDEX_X_ADDR
	ret

/* F7 */

EM_SBC_IdI_y:
	EM_SBC DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret
E0_SBC_IdI_y:
	E0_SBC DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	ret

/* F8 */

ALL_SED:			/* Set Decimal Flag */
	SET_FLAG SNES_FLAG_D
	ret		/* Take the processor back to the CPU loop no rets saves time */

/* F9 */

EM_SBC_a_y:
	EM_SBC ABSOLUTE_INDEX_Y_ADDR
	ret
E0_SBC_a_y:
	E0_SBC ABSOLUTE_INDEX_Y_ADDR
	ret

/* FA */

E0_PLX:				/* Pop X off stack */
	E0_POP_W
	movw %ax,_SNES_X
    testw %ax,%ax       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
EX_PLX:
	E0_POP_B
	movb %al,_SNES_X
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E1_PLX:
	E1_POP_B
	movb %al,_SNES_X
    testb %al,%al       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* FB */

E0_XCE:				/* Exchange carry and emulation bits */
    JUMP_FLAG SNES_FLAG_C,0f   /* C=status */
				/* no change E=C=0 */
	ret
0:				/* E=1 C=0 must set the CurTable pointer */
    CLR_FLAG SNES_FLAG_C
    orl $(MASK_FLAG_E+MASK_FLAG_M+MASK_FLAG_X),SNES_Flags
//  SET_FLAG SNES_FLAG_E    // Emulation mode settings */
//  SET_FLAG SNES_FLAG_M
//  SET_FLAG SNES_FLAG_X

    andl $0xFF,_SNES_Y
    andl $0xFF,_SNES_X
    andl $0xFF,_SNES_S
    movb $0x01,_SNES_S+1    /* Make High S=0x01 */

    addl $4,%esp
	cmpb $0,_SPC_ENABLED
	je 0f

    jmpl E1_SPC_RETURN_POSITION
0:  jmpl E1_RETURN_POSITION

E1_XCE:	
    JUMP_NOT_FLAG SNES_FLAG_C,0f   /* C=status */
				/* no change E=C=1 */
	ret
0:				/* E=0 C=1 must set the CurTable pointer */
//  CLR_FLAG SNES_FLAG_E
//  CLR_FLAG SNES_FLAG_B
    andl $~(MASK_FLAG_B+MASK_FLAG_E),SNES_Flags
	SET_FLAG SNES_FLAG_C

    andl $0xFF,_SNES_Y
    andl $0xFF,_SNES_X

    addl $4,%esp
	cmpb $0,_SPC_ENABLED
	je 0f

    jmpl MX_SPC_RETURN_POSITION
0:  jmpl MX_RETURN_POSITION

/* FC */

E0_JSR_Oa_xO:				/* JSR (a,x) */
	ABSOLUTE_INDEX_INDIRECT_X_ADDR
	GET_WORD
    pushl %eax
    movl _SNES_PC,%eax
	decw %ax			/* Address of last byte not next instruction (huh!) */
	E0_PUSH_W
    popl %eax
	movw %ax,_SNES_PC
	ret
E1_JSR_Oa_xO:
	ABSOLUTE_INDEX_INDIRECT_X_ADDR
	GET_WORD
    pushl %eax
    movl _SNES_PC,%eax
	decw %ax			/* Address of last byte not next instruction (huh!) */
	E1_PUSH_W
    popl %eax
	movw %ax,_SNES_PC
	ret

/* FD */

EM_SBC_a_x:
	EM_SBC ABSOLUTE_INDEX_X_ADDR
	ret
E0_SBC_a_x:
	E0_SBC ABSOLUTE_INDEX_X_ADDR
	ret

/* FE */

EM_INC_a_x:
	EM_INC ABSOLUTE_INDEX_X_ADDR
	ret
E0_INC_a_x:
	E0_INC ABSOLUTE_INDEX_X_ADDR
	ret

/* FF */

EM_SBC_al_x:
	EM_SBC ABSOLUTE_LONG_INDEX_X_ADDR
	ret
E0_SBC_al_x:
	E0_SBC ABSOLUTE_LONG_INDEX_X_ADDR
	ret
