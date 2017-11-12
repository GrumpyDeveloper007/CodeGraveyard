/*

 CPU Opcodes 0x20-0x2F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   JSR a   | AND (d,x) |  JSL al   |  AND d,s  |
|    3 6    |    2 6    |    4 8    |    2 4    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   BIT d   |   AND d   |   ROL d   |  AND [d]  |
|    2 3    |    2 3    |    2 5    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   PLP s   |   AND #   |   ROL A   |   PLD s   |
|    1 4    |    2 2    |    1 2    |    1 5    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   BIT a   |   AND a   |   ROL a   |  AND al   |
|    3 4    |    3 4    |    3 6    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 20 */

E0_JSR_a:				/* JSR Absolute address */
	ABSOLUTE_ADDR_JMP		/* SI set to address not esi!*/
    movl _SNES_PC,%eax
	decw %ax			/* Address of last byte not next instruction (huh!) */
	movw %si,_SNES_PC
	E0_PUSH_W
	ret

E1_JSR_a:
	ABSOLUTE_ADDR_JMP
    movl _SNES_PC,%eax
	decw %ax			/* Address of last byte not next instruction (huh!) */
	movw %si,_SNES_PC
	E1_PUSH_W
	ret

/* 21 */

EM_AND_Od_xO:
	EM_AND DIRECT_INDEX_INDIRECT_X_ADDR
	ret
E0_AND_Od_xO:
	E0_AND DIRECT_INDEX_INDIRECT_X_ADDR
	ret

/* 22 */

E0_JSL_al:				/* JSR Absolute long address */
	ABSOLUTE_LONG_ADDR
	pushl %esi
    movb _SNES_PB,%al   /* Convert to SNES Bank Style */
	E0_PUSH_B
    movl _SNES_PC,%eax
	decw %ax			/* Address of last byte not next instruction (huh!) */
	E0_PUSH_W
	popl %esi
	movw %si,_SNES_PC
	andl $0x00FF0000,%esi
	movl %esi,SNES_ProgBank
	ret
E1_JSL_al:
	ABSOLUTE_LONG_ADDR
	pushl %esi
    movb _SNES_PB,%al
	E1_PUSH_B
    movl _SNES_PC,%eax
	decw %ax			/* Address of last byte not next instruction (huh!) */
	E1_PUSH_W
	popl %esi
	movw %si,_SNES_PC
	andl $0x00FF0000,%esi
	movl %esi,SNES_ProgBank
	ret

/* 23 */

EM_AND_d_s:
	EM_AND STACK_RELATIVE_ADDR
	ret
E0_AND_d_s:
	E0_AND STACK_RELATIVE_ADDR
	ret

/* 24 */

EM_BIT_d:
	EM_BIT DIRECT_ADDR
	ret
E0_BIT_d:
	E0_BIT DIRECT_ADDR
	ret

/* 25 */

EM_AND_d:
	EM_AND DIRECT_ADDR
	ret
E0_AND_d:
	E0_AND DIRECT_ADDR
	ret

/* 26 */

EM_ROL_d:						/* Rol d */
	EM_ROL DIRECT_ADDR
	ret
E0_ROL_d:
	E0_ROL DIRECT_ADDR
	ret

/* 27 */

EM_AND_IdI:
	EM_AND DIRECT_INDIRECT_LONG_ADDR
	ret
E0_AND_IdI:
	E0_AND DIRECT_INDIRECT_LONG_ADDR
	ret

/* 28 */

E0_PLP:
	E0_POP_B
    E0_RESTOREFLAGS
	SET_TABLE_MX

E1_PLP:
	E1_POP_B
    E1_RESTOREFLAGS
	ret

/* 29 */

EM_AND_i:
	EM_AND IMMEDIATE_ADDR
	incw _SNES_PC
	ret
E0_AND_i:
	E0_AND IMMEDIATE_ADDR
    addw $2,_SNES_PC
	ret

/* 2A */

EM_RLA:						/* Rol A */
	MAKE_FLAGS (MASK_FLAG_C)
    movb _SNES_A,%al
    adcb %al,%al
    movb %al,_SNES_A
    STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	ret
E0_RLA:
	MAKE_FLAGS (MASK_FLAG_C)
    movl _SNES_A,%eax
    adcw %ax,%ax
    movl %eax,_SNES_A
    STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 2B */

E0_PLD:				/* Pop D off stack */
	E0_POP_W
	movw %ax,_SNES_D
    testw %ax,%ax       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret
E1_PLD:
	E1_POP_W
	movw %ax,_SNES_D
    testw %ax,%ax       /* Flags N and Z are setup so we can mask them off */
	STORE_FLAGS (MASK_FLAG_Z+MASK_FLAG_N)
	ret

/* 2C */

EM_BIT_a:
	EM_BIT ABSOLUTE_ADDR
	ret
E0_BIT_a:
	E0_BIT ABSOLUTE_ADDR
	ret

/* 2D */

EM_AND_a:
	EM_AND ABSOLUTE_ADDR
	ret
E0_AND_a:
	E0_AND ABSOLUTE_ADDR
	ret

/* 2E */

EM_ROL_a:						/* Rol a */
	EM_ROL ABSOLUTE_ADDR
	ret
E0_ROL_a:
	E0_ROL ABSOLUTE_ADDR
	ret

/* 2F */

EM_AND_al:
	EM_AND ABSOLUTE_LONG_ADDR
	ret
E0_AND_al:
	E0_AND ABSOLUTE_LONG_ADDR
	ret

