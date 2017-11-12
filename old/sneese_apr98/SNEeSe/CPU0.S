/*

 CPU Opcodes 0x00-0x0F Are Here As In :

+-----------+-----------+-----------+-----------+
|     0     |     1     |     2     |     3     |
+-----------+-----------+-----------+-----------+
|   BRK s   | ORA (d,x) |   COP s   |  ORA d,s  |
|    2 8    |    2 6    |    2 8    |    2 4    |
+-----------+-----------+-----------+-----------+
|     4     |     5     |     6     |     7     |
+-----------+-----------+-----------+-----------+
|   TSB d   |   ORA d   |   ASL d   |  ORA [d]  |
|    2 5    |    2 3    |    2 5    |    2 6    |
+-----------+-----------+-----------+-----------+
|     8     |     9     |     A     |     B     |
+-----------+-----------+-----------+-----------+
|   PHP s   |   ORA #   |   ASL A   |   PHD s   |
|    1 3    |    2 2    |    1 2    |    1 4    |
+-----------+-----------+-----------+-----------+
|     C     |     D     |     E     |     F     |
+-----------+-----------+-----------+-----------+
|   TSB a   |   ORA a   |   ASL a   |   ORA al  |
|    3 6    |    3 4    |    3 6    |    4 5    |
+-----------+-----------+-----------+-----------+
*/

/* 00 */

.balign 16
E0_BRK:
    incl %esi
    movw %si,_SNES_PC
    movb _SNES_PB,%al
	E0_PUSH_B
    movb _SNES_PC+1,%al
	E0_PUSH_B
	movb _SNES_PC,%al
	E0_PUSH_B
    E0_SETUPFLAGS               // Put flags into SNES packed flag format
	E0_PUSH_B
    SET_FLAG(SNES_FLAG_I)       // Disable interrupts
	CLR_FLAG(SNES_FLAG_D)

    xorl %esi,%esi              // Setup bank
    movl %esi,SNES_ProgBank     
    addl $0xffe6,%si
    GET_BYTE
    incw %si
    movb %al,_SNES_PC
    GET_BYTE
    movb %al,_SNES_PC+1
	ret 

.balign 16
E1_BRK:
    incl %esi
    movw %si,_SNES_PC
    movb _SNES_PC+1,%al
	E1_PUSH_B
    movb _SNES_PC,%al
	E1_PUSH_B
    E1_SETUPFLAGS               // Put flags into SNES packed flag format
	E1_PUSH_B
    SET_FLAG(SNES_FLAG_I)       // Disable interrupts
	CLR_FLAG(SNES_FLAG_D)

    xorl %esi,%esi              // Setup bank
    movl %esi,SNES_ProgBank     
    addl $0xfffe,%si
    GET_BYTE
    incw %si
    movb %al,_SNES_PC
    GET_BYTE
    movb %al,_SNES_PC+1
	ret 	

/* 01 */

.balign 16
EM_ORA_Od_xO:
	EM_ORA DIRECT_INDEX_INDIRECT_X_ADDR
	ret
.balign 16
E0_ORA_Od_xO:
	E0_ORA DIRECT_INDEX_INDIRECT_X_ADDR
	ret

/* 02 */

.balign 16
E0_COP:
    incl %esi
    movw %si,_SNES_PC
    movb _SNES_PB,%al
	E0_PUSH_B
	movb _SNES_PC+1,%al
	E0_PUSH_B
	movb _SNES_PC,%al
	E0_PUSH_B
    E0_SETUPFLAGS               // put flags into SNES packed flag format
	E0_PUSH_B
    SET_FLAG(SNES_FLAG_I)       // Disable interrupts
	CLR_FLAG(SNES_FLAG_D)

    xorl %esi,%esi              // Setup bank
    movl %esi,SNES_ProgBank     
    addl $0xffe4,%esi
    GET_BYTE
    incw %si
    movb %al,_SNES_PC
    GET_BYTE
    movb %al,_SNES_PC+1
	ret 

.balign 16
E1_COP:
    incl %esi
    movw %si,_SNES_PC
	movb _SNES_PC+1,%al
	E1_PUSH_B
	movb _SNES_PC,%al
	E1_PUSH_B
    E1_SETUPFLAGS           // put flags into SNES packed flag format
	E1_PUSH_B
	SET_FLAG(SNES_FLAG_I)	/* Disable Interrupts */
	CLR_FLAG(SNES_FLAG_D)

    xorl %esi,%esi              // Setup bank
    movl %esi,SNES_ProgBank     
    addl $0xfff4,%esi
    GET_BYTE
    incw %si
    movb %al,_SNES_PC
    GET_BYTE
    movb %al,_SNES_PC+1
	ret 	

/* 03 */

.balign 16
EM_ORA_d_s:
	EM_ORA STACK_RELATIVE_ADDR
	ret 
.balign 16
E0_ORA_d_s:
	E0_ORA STACK_RELATIVE_ADDR
	ret 

/* 04 */

.balign 16
EM_TSB_d:
	EM_TSB DIRECT_ADDR
	ret 
.balign 16
E0_TSB_d:
	E0_TSB DIRECT_ADDR
	ret 

/* 05 */

.balign 16
EM_ORA_d:
	EM_ORA DIRECT_ADDR
	ret 
.balign 16
E0_ORA_d:
	E0_ORA DIRECT_ADDR
	ret 

/* 06 */

.balign 16
EM_ASL_d:						/* Asl d */
	EM_ASL DIRECT_ADDR
	ret 
.balign 16
E0_ASL_d:
	E0_ASL DIRECT_ADDR
	ret 

/* 07 */

.balign 16
EM_ORA_IdI:
	EM_ORA DIRECT_INDIRECT_LONG_ADDR
	ret 
.balign 16
E0_ORA_IdI:
	E0_ORA DIRECT_INDIRECT_LONG_ADDR
	ret 

/* 08 */

.balign 16
E0_PHP:
    E0_SETUPFLAGS
    E0_PUSH_B
	ret 
.balign 16
E1_PHP:
    E1_SETUPFLAGS
	E1_PUSH_B
	ret 

/* 09 */

.balign 16
EM_ORA_i:
	EM_ORA IMMEDIATE_ADDR
	incw _SNES_PC
	ret 
.balign 16
E0_ORA_i:
	E0_ORA IMMEDIATE_ADDR
	addw $2,_SNES_PC
	ret 

/* 0A */

.balign 16
EM_SLA:						/* Shl A */
    shlb $1,_SNES_A
	STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	ret 
.balign 16
E0_SLA:
    shlw $1,_SNES_A
	STORE_FLAGS (MASK_FLAG_C+MASK_FLAG_Z+MASK_FLAG_N)
	ret 

/* 0B */
.balign 16
E0_PHD:				/* Push D onto stack */
    movl _SNES_D,%eax
	E0_PUSH_W
	ret 
.balign 16
E1_PHD:
    movl _SNES_D,%eax
	E1_PUSH_W
	ret 

/* 0C */
.balign 16
EM_TSB_a:
	EM_TSB ABSOLUTE_ADDR
	ret 
.balign 16
E0_TSB_a:
	E0_TSB ABSOLUTE_ADDR
	ret 

/* 0D */
.balign 16
EM_ORA_a:
	EM_ORA ABSOLUTE_ADDR
	ret 
.balign 16
E0_ORA_a:
	E0_ORA ABSOLUTE_ADDR
	ret 

/* 0E */
.balign 16
EM_ASL_a:						/* Asl a */
	EM_ASL ABSOLUTE_ADDR
	ret 
.balign 16
E0_ASL_a:
	E0_ASL ABSOLUTE_ADDR
	ret 

/* 0F */

.balign 16
EM_ORA_al:
	EM_ORA ABSOLUTE_LONG_ADDR
	ret
.balign 16
E0_ORA_al:
	E0_ORA ABSOLUTE_LONG_ADDR
	ret

