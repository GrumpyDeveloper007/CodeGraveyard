/*

 Addressing mode code

 Note: As of 2-15-98, be very careful when modifying this code, and
 the CPU loops! The CPU loops set eax to 0, except al, and esi to
 PB:PC+1 (start of immediate data), and the new address mode
 emulation expects this!

*/

/* Addressing mode stuff... final address always in esi ! */

/* Immediate address corrupts esi! */

.macro	IMMEDIATE_ADDR
.endm

/* Direct Address corrupts esi,eax */

.macro	DIRECT_ADDR
	GET_BYTE				/* Direct offset byte in al */
    incl %esi
    movw %si,_SNES_PC
	addw _SNES_D,%ax
	movl %eax,%esi
.endm

/* Direct index x Address corrupts esi,eax */

.macro	DIRECT_INDEX_X_ADDR
	GET_BYTE				/* Direct Offset Byte in dl */
    incl %esi
    movw %si,_SNES_PC
    addw _SNES_D,%ax
    addw _SNES_X,%ax
    movl %eax,%esi
.endm

/* Direct index y Address corrupts esi,eax */

.macro	DIRECT_INDEX_Y_ADDR
	GET_BYTE				/* Direct Offset Byte in dl */
    incl %esi
    movw %si,_SNES_PC
    addw _SNES_D,%ax
    addw _SNES_Y,%ax
    movl %eax,%esi
.endm

/* Direct indirect Address corrupts esi,eax */

.macro	DIRECT_INDIRECT_ADDR
	GET_BYTE			/* Direct Offset Byte in dl */
    incl %esi
    movw %si,_SNES_PC
    addw _SNES_D,%ax
    movl %eax,%esi
	movl SNES_DataBank,%eax
	GET_WORD
	movl %eax,%esi
.endm

/* Direct indirect long Address corrupts esi,eax */

.macro	DIRECT_INDIRECT_LONG_ADDR
	GET_BYTE			/* Direct Offset Byte in dl */
    incl %esi
    movw %si,_SNES_PC
    addw _SNES_D,%ax
    movl %eax,%esi
	GET_WORD
    shll $16,%eax
	incl %esi
	GET_BYTE
    rorl $16,%eax
	movl %eax,%esi
.endm

/* Direct indirect indexed y address corrupts esi,eax */

.macro	DIRECT_INDIRECT_INDEXED_Y_ADDR
	GET_BYTE				/* Direct Offset Byte in dl */
    incl %esi
    movw %si,_SNES_PC
    addw _SNES_D,%ax
    movl %eax,%esi
	movl SNES_DataBank,%eax				/* Set up direct bank */
	GET_WORD
    movl _SNES_Y,%esi
    addl %eax,%esi
    andl $0x00FFFFFF,%esi           /* Ensure address is a valid bank */
.endm

/* Direct indirect indexed long y address corrupts esi,eax */

.macro	DIRECT_INDIRECT_INDEXED_LONG_Y_ADDR
	GET_BYTE
    incl %esi
    movw %si,_SNES_PC
    addw _SNES_D,%ax
    movl %eax,%esi
	GET_WORD
	shll $16,%eax
	incl %esi
	GET_BYTE
	rorl $16,%eax
    movl _SNES_Y,%esi
    addl %eax,%esi
    andl $0x00FFFFFF,%esi           /* Ensure address is a valid bank */
.endm

/* Direct index indirect x address corrupts esi,eax */

.macro	DIRECT_INDEX_INDIRECT_X_ADDR address
	GET_BYTE				/* Direct Offset Byte in dl */
    incl %esi
    movw %si,_SNES_PC
    addw _SNES_D,%ax
	addw _SNES_X,%ax
    movl %eax,%esi
	movl SNES_DataBank,%eax
	GET_WORD
	movl %eax,%esi
.endm

/* Absolute address jmp corrupts esi,eax */

.macro	ABSOLUTE_ADDR_JMP			/* Used for JSR and JMP instructions */
	GET_WORD				/* Address in eax so needs copying to address */
    incl %esi
    movw %si,_SNES_PC
	movl SNES_ProgBank,%esi
	movw %ax,%si
.endm

/* Absolute address corrupts esi,eax */

.macro	ABSOLUTE_ADDR
	GET_WORD
    incl %esi
    movw %si,_SNES_PC
	movl SNES_DataBank,%esi
	movw %ax,%si
.endm

/* Absolute index x address corrupts esi,eax */

.macro	ABSOLUTE_INDEX_X_ADDR
	GET_WORD
    incl %esi
    movw %si,_SNES_PC
	movl SNES_DataBank,%esi
    addl %eax,%esi
	addl _SNES_X,%esi
    andl $0x00FFFFFF,%esi           /* Ensure address is a valid bank */
.endm

/* Absolute index y address corrupts esi,eax */

.macro	ABSOLUTE_INDEX_Y_ADDR
	GET_WORD
    incl %esi
    movw %si,_SNES_PC
	movl SNES_DataBank,%esi
    addl %eax,%esi
	addl _SNES_Y,%esi
	andl $0x00FFFFFF,%esi			/* Ensure address is a valid bank */
.endm

/* Absolute long index x address corrupts esi,eax */

.macro	ABSOLUTE_LONG_INDEX_X_ADDR
	GET_WORD
	incl %esi				/* ESI incremented by 1 after GET_WORD */
	shll $16,%eax				/* Shift Offset to get bank */
	GET_BYTE
    incl %esi
    movw %si,_SNES_PC
	rorl $16,%eax				/* Long Address now setup */
    movl _SNES_X,%esi
    addl %eax,%esi
	andl $0x00FFFFFF,%esi			/* Ensure address is a valid bank */
.endm

/* Absolute long address corrupts esi,eax */

.macro	ABSOLUTE_LONG_ADDR
	GET_WORD
	incl %esi				/* ESI incremented by 1 after GET_WORD */
	shll $16,%eax				/* Shift Offset to get bank */
	GET_BYTE
    incl %esi
    movw %si,_SNES_PC
	rorl $16,%eax				/* Long Address now setup */
	movl %eax,%esi
.endm

/* Absolute index indirect x address corrupts esi,eax */

/* NB This differs from GTE DOCS, PB is used not bank 0! */

.macro	ABSOLUTE_INDEX_INDIRECT_X_ADDR
    movl %esi,%eax
	GET_WORD
    incl %esi
    movw %si,_SNES_PC
    addw _SNES_X,%ax
    movl %eax,%esi
.endm

/* Absolute indirect jml address corrupts esi,eax */

/* NB This uses bank 0! */

.macro	ABSOLUTE_INDIRECT_JML_ADDR
	GET_WORD
    incl %esi
    movw %si,_SNES_PC
	movl %eax,%esi
	GET_WORD
    incl %esi
	shll $16,%eax
	GET_BYTE
	rorl $16,%eax
	movl %eax,%esi
.endm

/* Absolute indirect address corrupts esi,eax */

/* NB This uses bank 0! */

.macro	ABSOLUTE_INDIRECT_ADDR address
	GET_WORD
    incl %esi
    movw %si,_SNES_PC
	movl %eax,%esi
.endm

/* Stack relative address corrupts esi,eax */

.macro	STACK_RELATIVE_ADDR
	GET_BYTE				/* Get unsigned offset */
    incl %esi               /* Skip the relative offset byte */
    movw %si,_SNES_PC
    movl _SNES_S,%esi       /* Add stack pointer to make address */
    addw %ax,%si
.endm

/* Stack relative indirect indexed y address corrupts esi,eax */

.macro	STACK_RELATIVE_INDIRECT_INDEXED_Y_ADDR address
	GET_BYTE				/* Get unsigned offset */
    incl %esi               /* Skip the relative offset byte */
    movw %si,_SNES_PC
    movl _SNES_S,%esi
    addw %ax,%si            /* Add stack pointer to make address */
	movl SNES_DataBank,%eax
	GET_WORD
    movl _SNES_Y,%esi
    addl %eax,%esi
	andl $0x00FFFFFF,%esi			/* Ensure address is a valid bank */
.endm
