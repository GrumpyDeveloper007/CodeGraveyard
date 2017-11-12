/*

 Tile Functions - In Assembler cos everything else is!


  Ok, Dale you win... this code is now v.similar to yours with a few alterations (done since I
 will need to alter these at the plot level for add/sub effects in my render engine!).

*/

.balign 16
PLOT8x8_8BplTile:	/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
				/*  Bp2=*(TileAddress+16) */
				/*  Bp3=*(TileAddress+17) */
	movw 32(%esi),%bx	/*  bx(hi)=BPl4 & BPl5 */
	movw 48(%esi),%cx	/*  cx(hi)=BPL6 & BPl7 */
	roll $16,%ebx
	roll $16,%ecx
	movw (%esi),%bx		/*  bx(lo)=BPl0 & BPl1 */
	movw 16(%esi),%cx	/*  cx(lo)=BPl2 & BPl3 */

	movl $7,%edx		/* Test left most bit of packed bpl, bpl0,2 */
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax

	btl %edx,%ebx
	jnc 7f
	incb %al
7:				/* Pixel 1 */
	btl %edx,%ecx
	jnc 7f
	addb $4,%al
7:				/* Pixel 3 */

	addl $8,%dx		/* Test left most bit of packed bpl, bpl1,3 */

	btl %edx,%ebx
	jnc 7f
	addb $2,%al
7:				/* Pixel 2 */
	btl %edx,%ecx
	jnc 7f
	addb $8,%al
7:				/* Pixel 4 */

	addl $8,%dx		/* Test left most bit of packed bpl, bpl4,6 */

	btl %edx,%ebx
	jnc 7f
	addb $0x10,%al
7:				/* Pixel 5 */
	btl %edx,%ecx
	jnc 7f
	addb $0x40,%al
7:				/* Pixel 7 */

	addl $8,%dx		/* Test left most bit of packed bpl, bpl5,7 */

	btl %edx,%ebx
	jnc 7f
	addb $0x20,%al
7:				/* Pixel 6 */
	btl %edx,%ecx
	jnc 7f
	addb $0x80,%al
7:				/* Pixel 8 */

	movb %al,(%edi)
	subw $24,%dx
6:	incl %edi
	decl %edx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	addl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_8BplTile_X:	/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
				/*  Bp2=*(TileAddress+16) */
				/*  Bp3=*(TileAddress+17) */
	movw 32(%esi),%bx	/*  bx(hi)=BPl4 & BPl5 */
	movw 48(%esi),%cx	/*  cx(hi)=BPL6 & BPl7 */
	roll $16,%ebx
	roll $16,%ecx
	movw (%esi),%bx		/*  bx(lo)=BPl0 & BPl1 */
	movw 16(%esi),%cx	/*  cx(lo)=BPl2 & BPl3 */

	movl $0,%edx		/* Test right most bit of packed bpl, bpl0,2 */
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax

	btl %edx,%ebx
	jnc 7f
	incb %al
7:				/* Pixel 1 */
	btl %edx,%ecx
	jnc 7f
	addb $4,%al
7:				/* Pixel 3 */

	addl $8,%dx		/* Test right most bit of packed bpl, bpl1,3 */

	btl %edx,%ebx
	jnc 7f
	addb $2,%al
7:				/* Pixel 2 */
	btl %edx,%ecx
	jnc 7f
	addb $8,%al
7:				/* Pixel 4 */

	addl $8,%dx		/* Test right most bit of packed bpl, bpl4,6 */

	btl %edx,%ebx
	jnc 7f
	addb $0x10,%al
7:				/* Pixel 5 */
	btl %edx,%ecx
	jnc 7f
	addb $0x40,%al
7:				/* Pixel 7 */

	addl $8,%dx		/* Test right most bit of packed bpl, bpl5,7 */

	btl %edx,%ebx
	jnc 7f
	addb $0x20,%al
7:				/* Pixel 6 */
	btl %edx,%ecx
	jnc 7f
	addb $0x80,%al
7:				/* Pixel 8 */

	movb %al,(%edi)
	subw $24,%dx
6:	incl %edi
	incl %edx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	addl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_8BplTile_Y:	/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
				/*  Bp2=*(TileAddress+16) */
				/*  Bp3=*(TileAddress+17) */
	movw 46(%esi),%bx	/*  bx(hi)=BPl4 & BPl5 */
	movw 62(%esi),%cx	/*  cx(hi)=BPL6 & BPl7 */
	roll $16,%ebx
	roll $16,%ecx
	movw 14(%esi),%bx	/*  bx(lo)=BPl0 & BPl1 */
	movw 30(%esi),%cx	/*  cx(lo)=BPl2 & BPl3 */

	movl $7,%edx		/* Test left most bit of packed bpl, bpl0,2 */
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax

	btl %edx,%ebx
	jnc 7f
	incb %al
7:				/* Pixel 1 */
	btl %edx,%ecx
	jnc 7f
	addb $4,%al
7:				/* Pixel 3 */

	addl $8,%dx		/* Test left most bit of packed bpl, bpl1,3 */

	btl %edx,%ebx
	jnc 7f
	addb $2,%al
7:				/* Pixel 2 */
	btl %edx,%ecx
	jnc 7f
	addb $8,%al
7:				/* Pixel 4 */

	addl $8,%dx		/* Test left most bit of packed bpl, bpl4,6 */

	btl %edx,%ebx
	jnc 7f
	addb $0x10,%al
7:				/* Pixel 5 */
	btl %edx,%ecx
	jnc 7f
	addb $0x40,%al
7:				/* Pixel 7 */

	addl $8,%dx		/* Test left most bit of packed bpl, bpl5,7 */

	btl %edx,%ebx
	jnc 7f
	addb $0x20,%al
7:				/* Pixel 6 */
	btl %edx,%ecx
	jnc 7f
	addb $0x80,%al
7:				/* Pixel 8 */

	movb %al,(%edi)
	subw $24,%dx
6:	incl %edi
	decl %edx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	subl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_8BplTile_XY:	/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
				/*  Bp2=*(TileAddress+16) */
				/*  Bp3=*(TileAddress+17) */
	movw 46(%esi),%bx	/*  bx(hi)=BPl4 & BPl5 */
	movw 62(%esi),%cx	/*  cx(hi)=BPL6 & BPl7 */
	roll $16,%ebx
	roll $16,%ecx
	movw 14(%esi),%bx	/*  bx(lo)=BPl0 & BPl1 */
	movw 30(%esi),%cx	/*  cx(lo)=BPl2 & BPl3 */

	movl $0,%edx		/* Test right most bit of packed bpl, bpl0,2 */
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax

	btl %edx,%ebx
	jnc 7f
	incb %al
7:				/* Pixel 1 */
	btl %edx,%ecx
	jnc 7f
	addb $4,%al
7:				/* Pixel 3 */

	addl $8,%dx		/* Test right most bit of packed bpl, bpl1,3 */

	btl %edx,%ebx
	jnc 7f
	addb $2,%al
7:				/* Pixel 2 */
	btl %edx,%ecx
	jnc 7f
	addb $8,%al
7:				/* Pixel 4 */

	addl $8,%dx		/* Test right most bit of packed bpl, bpl4,6 */

	btl %edx,%ebx
	jnc 7f
	addb $0x10,%al
7:				/* Pixel 5 */
	btl %edx,%ecx
	jnc 7f
	addb $0x40,%al
7:				/* Pixel 7 */

	addl $8,%dx		/* Test right most bit of packed bpl, bpl5,7 */

	btl %edx,%ebx
	jnc 7f
	addb $0x20,%al
7:				/* Pixel 6 */
	btl %edx,%ecx
	jnc 7f
	addb $0x80,%al
7:				/* Pixel 8 */

	movb %al,(%edi)
	subw $24,%dx
6:	incl %edi
	incl %edx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	subl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_4BplTile:		/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
				/*  Bp2=*(TileAddress+16) */
				/*  Bp3=*(TileAddress+17) */
	movw (%esi),%bx
	movw 16(%esi),%cx

	movl $7,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb ColourBase1,%al
7:				/* Pixel 1 */
	btw %dx,%cx
	jnc 7f
	orb ColourBase4,%al

7:				/* Pixel 3 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb ColourBase2,%al
7:				/* Pixel 2 */
	btw %dx,%cx
	jnc 7f
	orb ColourBase8,%al
7:				/* Pixel 4 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	decw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	addl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_4BplTile_X:		/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
				/*  Bp2=*(TileAddress+16) */
				/*  Bp3=*(TileAddress+17) */
	movw (%esi),%bx
	movw 16(%esi),%cx

	movl $0,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb ColourBase1,%al
7:				/* Pixel 1 */
	btw %dx,%cx
	jnc 7f
	orb ColourBase4,%al

7:				/* Pixel 3 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb ColourBase2,%al
7:				/* Pixel 2 */
	btw %dx,%cx
	jnc 7f
	orb ColourBase8,%al
7:				/* Pixel 4 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	incw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	addl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_4BplTile_Y:		/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
				/*  Bp2=*(TileAddress+16) */
				/*  Bp3=*(TileAddress+17) */
	movw 14(%esi),%bx
	movw 30(%esi),%cx

	movl $7,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb ColourBase1,%al
7:				/* Pixel 1 */
	btw %dx,%cx
	jnc 7f
	orb ColourBase4,%al

7:				/* Pixel 3 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb ColourBase2,%al
7:				/* Pixel 2 */
	btw %dx,%cx
	jnc 7f
	orb ColourBase8,%al
7:				/* Pixel 4 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	decw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	subl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_4BplTile_XY:		/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
				/*  Bp2=*(TileAddress+16) */
				/*  Bp3=*(TileAddress+17) */
	movw 14(%esi),%bx
	movw 30(%esi),%cx

	movl $0,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb ColourBase1,%al
7:				/* Pixel 1 */
	btw %dx,%cx
	jnc 7f
	orb ColourBase4,%al

7:				/* Pixel 3 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb ColourBase2,%al
7:				/* Pixel 2 */
	btw %dx,%cx
	jnc 7f
	orb ColourBase8,%al
7:				/* Pixel 4 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	incw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	subl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_2BplTile:		/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
	movw (%esi),%bx

	movl $7,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb ColourBase1,%al

7:				/* Pixel 1 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb ColourBase2,%al
7:				/* Pixel 2 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	decw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	addl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_2BplTile_X:		/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
	movw (%esi),%bx

	movl $0,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb ColourBase1,%al

7:				/* Pixel 1 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb ColourBase2,%al
7:				/* Pixel 2 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	incw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	addl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_2BplTile_Y:	/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
	movw 14(%esi),%bx

	movl $7,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb ColourBase1,%al

7:				/* Pixel 1 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb ColourBase2,%al
7:				/* Pixel 2 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	decw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	subl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.balign 16
PLOT8x8_2BplTile_XY:		/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
	movw 14(%esi),%bx

	movl $0,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	cmpb $0,(%edi)		/* Is screen 0, if not dont plot pixel! */
	jne 6f

	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb ColourBase1,%al

7:				/* Pixel 1 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb ColourBase2,%al
7:				/* Pixel 2 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	incw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $(256+128-8),%edi
	subl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret

.macro P_TILE_16x16_2
	pushl %edi
	pushl %esi
	call PLOT8x8_2BplTile
	addl $2*8,%esi
	addl $8,%edi
	call PLOT8x8_2BplTile
	addl $16*2*8-2*8,%esi
	addl $(256+128)*8-8,%edi
	call PLOT8x8_2BplTile
	addl $2*8,%esi
	addl $8,%edi
	call PLOT8x8_2BplTile
	popl %esi
	popl %edi
.endm

.macro P_TILE_16x16_2_X
	pushl %edi
	pushl %esi
	addl $8,%edi
	call PLOT8x8_2BplTile_X
	addl $2*8,%esi
	subl $8,%edi
	call PLOT8x8_2BplTile_X
	addl $16*2*8-2*8,%esi
	addl $(256+128)*8+8,%edi
	call PLOT8x8_2BplTile_X
	addl $2*8,%esi
	subl $8,%edi
	call PLOT8x8_2BplTile_X
	popl %esi
	popl %edi
.endm

.macro P_TILE_16x16_2_Y
	pushl %edi
	pushl %esi
	addl $(256+128)*8,%edi
	call PLOT8x8_2BplTile_Y
	addl $2*8,%esi
	addl $8,%edi
	call PLOT8x8_2BplTile_Y
	addl $16*2*8-2*8,%esi
	subl $(256+128)*8+8,%edi
	call PLOT8x8_2BplTile_Y
	addl $2*8,%esi
	addl $8,%edi
	call PLOT8x8_2BplTile_Y
	popl %esi
	popl %edi
.endm

.macro P_TILE_16x16_2_XY
	pushl %edi
	pushl %esi
	addl $(256+128)*8+8,%edi
	call PLOT8x8_2BplTile_XY
	addl $2*8,%esi
	subl $8,%edi
	call PLOT8x8_2BplTile_XY
	addl $16*2*8-2*8,%esi
	subl $(256+128)*8-8,%edi
	call PLOT8x8_2BplTile_XY
	addl $2*8,%esi
	subl $8,%edi
	call PLOT8x8_2BplTile_XY
	popl %esi
	popl %edi
.endm


.macro P_TILE_16x16_4
	pushl %edi
	pushl %esi
	call PLOT8x8_4BplTile
	addl $4*8,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*4*8-4*8,%esi
	addl $(256+128)*8-8,%edi
	call PLOT8x8_4BplTile
	addl $4*8,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	popl %esi
	popl %edi
.endm

.macro P_TILE_16x16_4_X
	popl %edi
	popl %esi
	addl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $4*8,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*4*8-4*8,%esi
	addl $(256+128)*8+8,%edi
	call PLOT8x8_4BplTile_X
	addl $4*8,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	popl %esi
	popl %edi
.endm

.macro P_TILE_16x16_4_Y
	pushl %esi
	pushl %edi
	addl $(256+128)*8,%edi
	call PLOT8x8_4BplTile_Y
	addl $4*8,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*4*8-4*8,%esi
	subl $(256+128)*8+8,%edi
	call PLOT8x8_4BplTile_Y
	addl $4*8,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	popl %esi
	popl %edi
.endm

.macro P_TILE_16x16_4_XY
	pushl %edi
	pushl %esi
	addl $(256+128)*8+8,%edi
	call PLOT8x8_4BplTile_XY
	addl $4*8,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*4*8-4*8,%esi
	subl $(256+128)*8-8,%edi
	call PLOT8x8_4BplTile_XY
	addl $4*8,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	popl %esi
	popl %edi
.endm

.balign 16
TILE_16x16_8_P1:
	pushl %edi
	pushl %esi
	call PLOT8x8_8BplTile
	addl $8*8,%esi
	addl $8,%edi
	call PLOT8x8_8BplTile
	addl $16*8*8-8*8,%esi
	addl $(256+128)*8-8,%edi
	call PLOT8x8_8BplTile
	addl $8*8,%esi
	addl $8,%edi
	call PLOT8x8_8BplTile
	popl %esi
	popl %edi
	ret

.balign 16
TILE_16x16_8_P1_X:
	pushl %edi
	pushl %esi
	addl $8,%edi
	call PLOT8x8_8BplTile_X
	addl $8*8,%esi
	subl $8,%edi
	call PLOT8x8_8BplTile_X
	addl $16*8*8-8*8,%esi
	addl $(256+128)*8+8,%edi
	call PLOT8x8_8BplTile_X
	addl $8*8,%esi
	subl $8,%edi
	call PLOT8x8_8BplTile_X
	popl %esi
	popl %edi
	ret

.balign 16
TILE_16x16_8_P1_Y:
	pushl %edi
	pushl %esi
	addl $(256+128)*8,%edi
	call PLOT8x8_8BplTile_Y
	addl $8*8,%esi
	addl $8,%edi
	call PLOT8x8_8BplTile_Y
	addl $16*8*8-8*8,%esi
	subl $(256+128)*8+8,%edi
	call PLOT8x8_8BplTile_Y
	addl $8*8,%esi
	addl $8,%edi
	call PLOT8x8_8BplTile_Y
	popl %esi
	popl %edi
	ret

.balign 16
TILE_16x16_8_P1_XY:
	pushl %edi
	pushl %esi
	addl $(256+128)*8+8,%edi
	call PLOT8x8_8BplTile_XY
	addl $8*8,%esi
	subl $8,%edi
	call PLOT8x8_8BplTile_XY
	addl $16*8*8-8*8,%esi
	subl $(256+128)*8-8,%edi
	call PLOT8x8_8BplTile_XY
	addl $8*8,%esi
	subl $8,%edi
	call PLOT8x8_8BplTile_XY
	popl %esi
	popl %edi
	ret

TILE_16x16_2_P1:
	P_TILE_16x16_2
	ret
TILE_16x16_2_P2:
	P_TILE_16x16_2_X
	ret
TILE_16x16_2_P3:
	P_TILE_16x16_2_Y
	ret
TILE_16x16_2_P4:
	P_TILE_16x16_2_XY
	ret


TILE_16x16_4_P1:
	P_TILE_16x16_4
	ret
TILE_16x16_4_P2:
	P_TILE_16x16_4_X
	ret
TILE_16x16_4_P3:
	P_TILE_16x16_4_Y
	ret
TILE_16x16_4_P4:
	P_TILE_16x16_4_XY
	ret


.data
.balign 16					/* Align to paragraph */
.global	ColourBase
ColourBase:	.byte	0
.global ColourBase1
ColourBase1:	.byte	1
.global ColourBase2
ColourBase2:	.byte	2
.global ColourBase4
ColourBase4:	.byte	4
.global ColourBase8
ColourBase8:	.byte	8

Tile_Plot_8x8_2:
	.long	PLOT8x8_2BplTile
	.long	PLOT8x8_2BplTile_X
	.long	PLOT8x8_2BplTile_Y
	.long	PLOT8x8_2BplTile_XY

Tile_Plot_8x8_4:
	.long	PLOT8x8_4BplTile
	.long	PLOT8x8_4BplTile_X
	.long	PLOT8x8_4BplTile_Y
	.long	PLOT8x8_4BplTile_XY

Tile_Plot_8x8_8:
	.long	PLOT8x8_8BplTile
	.long	PLOT8x8_8BplTile_X
	.long	PLOT8x8_8BplTile_Y
	.long	PLOT8x8_8BplTile_XY

Tile_Plot_16x16_2:
	.long	TILE_16x16_2_P1
	.long	TILE_16x16_2_P2
	.long	TILE_16x16_2_P3
	.long	TILE_16x16_2_P4

Tile_Plot_16x16_4:
	.long	TILE_16x16_4_P1
	.long	TILE_16x16_4_P2
	.long	TILE_16x16_4_P3
	.long	TILE_16x16_4_P4

Tile_Plot_16x16_8:
	.long	TILE_16x16_8_P1
	.long	TILE_16x16_8_P1_X
	.long	TILE_16x16_8_P1_Y
	.long	TILE_16x16_8_P1_XY

.text
