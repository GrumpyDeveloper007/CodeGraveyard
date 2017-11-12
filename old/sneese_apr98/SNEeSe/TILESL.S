/*

 Tile Functions - In Assembler cos everything else is!

  Not actually tile functions.. Line plotters, they plot only a line from
 a tile, the line is determined by the address in %eax + TileAddress(Y)

*/

/*
 In the plotters...
  eax = tile address    (input)
   ah = pixel counter   (internal)
   al = output pixel    (internal)
  ebx = bpl0,1,4,5 data (internal)
  ecx = bpl2,3,6,7 data (internal)
  edi = screen address  (input)
 And in the 32x32 and 64x64 sprite plotters...
  esi = tile address    (internal)
*/

.macro P8x8_8Bpl_Plot Xflip Big=0
.if \Big-1
    //  Bp4=*(TileAddress+32), Bp5=*(TileAddress+33)
    //  Bp6=*(TileAddress+48), Bp7=*(TileAddress+49)
    movl 32(%eax),%ebx  // bx(hi)=BPl4 & BPl5
    movl 48(%eax),%ecx  // cx(hi)=BPL6 & BPl7
    bswapl %ebx
    bswapl %ecx
    //  Bp0=*(TileAddress+0), Bp1=*(TileAddress+1)
    //  Bp2=*(TileAddress+16), Bp3=*(TileAddress+17)
    movw (%eax),%bx     // bx(lo)=BPl0 & BPl1
    movw 16(%eax),%cx   // cx(lo)=BPl2 & BPl3
.else
    //  Bp4=*(TileAddress+32), Bp5=*(TileAddress+33)
    //  Bp6=*(TileAddress+48), Bp7=*(TileAddress+49)
    movl 32(%esi),%ebx  // bx(hi)=BPl4 & BPl5
    movl 48(%esi),%ecx  // cx(hi)=BPL6 & BPl7
    bswapl %ebx
    bswapl %ecx
    //  Bp0=*(TileAddress+0), Bp1=*(TileAddress+1)
    //  Bp2=*(TileAddress+16), Bp3=*(TileAddress+17)
    movw (%esi),%bx     // bx(lo)=BPl0 & BPl1
    movw 16(%esi),%cx   // cx(lo)=BPl2 & BPl3
.endif

.if \Xflip-1
    addl $7,%edi
.endif
    movb $1,%ah     // Start with rightmost bit

8:  cmpb $0,(%edi)  // Is screen 0, if not don't plot pixel!
    jnz 6f
    xorb %al,%al

    // Test packed bpl 0
    testb %ah,%bl
    jz  7f
	incb %al
7:  // Test packed bpl 1
    testb %ah,%bh
    jz  7f
    orb $2,%al
7:  // Test packed bpl 2
    testb %ah,%cl
    jz  7f
    orb $4,%al
7:  // Test packed bpl 3
    testb %ah,%ch
    jz  7f
    orb $8,%al
7:  bswapl %ebx
    bswapl %ecx
    // Test packed bpl 4
    testb %ah,%bl
    jz  7f
    orb $0x10,%al
7:  // Test packed bpl 5
    testb %ah,%bh
    jz  7f
    orb $0x20,%al
7:  // Test packed bpl 6
    testb %ah,%cl
    jz  7f
    orb $0x40,%al
7:  // Test packed bpl 7
    testb %ah,%ch
    jz  7f
    orb $0x80,%al
7:  bswapl %ebx
    bswapl %ecx
	movb %al,(%edi)
6:
.if \Xflip-1
    decl %edi
.else
    incl %edi
.endif
    addb %ah,%ah
    jnz 8b
.endm

.macro P8x8_4Bpl_Plot Xflip Big=0
.if \Big-1
    //  Bp0=*(TileAddress+0), Bp1=*(TileAddress+1)
    //  Bp2=*(TileAddress+16), Bp3=*(TileAddress+17)
    movl (%eax),%ebx
    movl 16(%eax),%ecx
.else
    //  Bp0=*(TileAddress+0), Bp1=*(TileAddress+1)
    //  Bp2=*(TileAddress+16), Bp3=*(TileAddress+17)
    movl (%esi),%ebx
    movl 16(%esi),%ecx
.endif

.if \Xflip-1
    addl $7,%edi
.endif
    movb $1,%ah     // Start with rightmost bit

8:  cmpb $0,(%edi)  // Is screen 0, if not don't plot pixel!
    jnz 6f
    xorb %al,%al

    // Test packed bpl 0
    testb %ah,%bl
    jz  7f
	orb ColourBase1,%al
7:  // Test packed bpl 1
    testb %ah,%bh
    jz  7f
	orb ColourBase2,%al
7:  // Test packed bpl 2
    testb %ah,%cl
    jz  7f
	orb ColourBase4,%al
7:  // Test packed bpl 3
    testb %ah,%ch
    jz  7f
	orb ColourBase8,%al
7:
	movb %al,(%edi)
6:
.if \Xflip-1
    decl %edi
.else
    incl %edi
.endif
    addb %ah,%ah
    jnz 8b
.endm

.macro P8x8_2Bpl_Plot Xflip Big=0
.if \Big-1
    //  Bp0=*(TileAddress+0), Bp1=*(TileAddress+1)
    movl (%eax),%ebx
.else
    //  Bp0=*(TileAddress+0), Bp1=*(TileAddress+1)
    movl (%esi),%ebx
.endif

.if \Xflip-1
    addl $7,%edi
.endif
    movb $1,%ah     // Start with rightmost bit

8:  cmpb $0,(%edi)  // Is screen 0, if not don't plot pixel!
    jnz 6f
    xorb %al,%al

    // Test packed bpl 0
    testb %ah,%bl
    jz  7f
    orb %dl,%al     // ColourBase1
7:  // Test packed bpl 1
    testb %ah,%bh
    jz  7f
    orb %dh,%al     // ColourBase2
7:
	movb %al,(%edi)
6:
.if \Xflip-1
    decl %edi
.else
    incl %edi
.endif
    addb %ah,%ah
    jnz 8b
.endm

.balign 16
PLOT8x8_8BplTile:	/* tile address in eax, plane screen in edi */
// Corrupts ax,ebx,ecx,edi
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddress,%eax

    P8x8_8Bpl_Plot Xflip=0
    addl $9,%edi

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_8BplTile_X:	/* tile address in eax, plane screen in edi */
// Corrupts ax,ebx,ecx,edi
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddress,%eax

    P8x8_8Bpl_Plot Xflip=1

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_8BplTile_Y:	/* tile address in eax, plane screen in edi */
// Corrupts ax,ebx,ecx,edi
    pushl %eax
    pushl %ebx
    pushl %ecx

    addl TileAddressY,%eax

    P8x8_8Bpl_Plot Xflip=0
    addl $9,%edi

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_8BplTile_XY:	/* tile address in eax, plane screen in edi */
// Corrupts ax,ebx,ecx,edi
    pushl %eax
    pushl %ebx
    pushl %ecx

    addl TileAddressY,%eax

    P8x8_8Bpl_Plot Xflip=1

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_4BplTile:		/* tile address in eax, plane screen in edi */
// Corrupts ax,bx,cx,edi
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddress,%eax

    P8x8_4Bpl_Plot Xflip=0
    addl $9,%edi

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_4BplTile_X:		/* tile address in eax, plane screen in edi */
// Corrupts ax,bx,cx,edi
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddress,%eax

    P8x8_4Bpl_Plot Xflip=1

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_4BplTile_Y:		/* tile address in eax, plane screen in edi */
// Corrupts ax,bx,cx,edi
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddressY,%eax

    P8x8_4Bpl_Plot Xflip=0
    addl $9,%edi

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_4BplTile_XY:		/* tile address in eax, plane screen in edi */
// Corrupts ax,bx,cx,edi
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddressY,%eax

    P8x8_4Bpl_Plot Xflip=1

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_2BplTile:		/* tile address in eax, plane screen in edi */
// Corrupts ax,bx,edi
    pushl %eax
    pushl %ebx
    pushl %edx

    movb ColourBase1,%dl
    movb ColourBase2,%dh
    addl TileAddress,%eax

    P8x8_2Bpl_Plot Xflip=0
    addl $9,%edi

    popl %edx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_2BplTile_X:		/* tile address in eax, plane screen in edi */
// Corrupts ax,bx,edi
    pushl %eax
    pushl %ebx
    pushl %edx

    movb ColourBase1,%dl
    movb ColourBase2,%dh
	addl TileAddress,%eax

    P8x8_2Bpl_Plot Xflip=1

    popl %edx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_2BplTile_Y:	/* tile address in eax, plane screen in edi */
// Corrupts ax,bx,edi
    pushl %eax
    pushl %ebx
    pushl %edx

    movb ColourBase1,%dl
    movb ColourBase2,%dh
	addl TileAddressY,%eax

    P8x8_2Bpl_Plot Xflip=0
    addl $9,%edi

    popl %edx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT8x8_2BplTile_XY:		/* tile address in eax, plane screen in edi */
// Corrupts ax,bx,edi
    pushl %eax
    pushl %ebx
    pushl %edx

    movb ColourBase1,%dl
    movb ColourBase2,%dh
	addl TileAddressY,%eax

    P8x8_2Bpl_Plot Xflip=1

    popl %edx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT16x16_8BplTile:
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddress,%eax
	pushl %eax

    P8x8_8Bpl_Plot Xflip=0
    addl $9,%edi

    popl %eax

    addl $64,%eax

    P8x8_8Bpl_Plot Xflip=0
    addl $9,%edi

    popl %ebx
    popl %ecx
	popl %eax
	ret

.balign 16
PLOT16x16_8BplTile_X:
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddress,%eax
	pushl %eax
    addl $64,%eax

    P8x8_8Bpl_Plot Xflip=1

    popl %eax

    P8x8_8Bpl_Plot Xflip=1

    popl %ebx
    popl %ecx
	popl %eax
	ret

.balign 16
PLOT16x16_8BplTile_Y:
    pushl %eax
    pushl %ebx
    pushl %ecx

    addl TileAddressY,%eax
	pushl %eax

    P8x8_8Bpl_Plot Xflip=0
    addl $9,%edi

    popl %eax

    addl $64,%eax

    P8x8_8Bpl_Plot Xflip=0
    addl $9,%edi

    popl %ebx
    popl %ecx
	popl %eax
	ret

.balign 16
PLOT16x16_8BplTile_XY:
    pushl %eax
    pushl %ebx
    pushl %ecx

    addl TileAddressY,%eax
	pushl %eax
    addl $64,%eax

    P8x8_8Bpl_Plot Xflip=1

    popl %eax

    P8x8_8Bpl_Plot Xflip=1

    popl %ebx
    popl %ecx
	popl %eax
	ret

.balign 16
PLOT16x16_4BplTile:
    pushl %eax
    pushl %ebx
    pushl %ecx

	addl TileAddress,%eax
    pushl %eax

    P8x8_4Bpl_Plot Xflip=0
    addl $9,%edi

    popl %eax
    addl $32,%eax

    P8x8_4Bpl_Plot Xflip=0
    addl $9,%edi

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT16x16_4BplTile_X:
    pushl %eax
    pushl %ebx
    pushl %ecx

    addl TileAddress,%eax
    pushl %eax
    addl $32,%eax

    P8x8_4Bpl_Plot Xflip=1

    popl %eax

    P8x8_4Bpl_Plot Xflip=1

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT16x16_4BplTile_Y:
    pushl %eax
    pushl %ebx
    pushl %ecx

    addl TileAddressY,%eax
    pushl %eax

    P8x8_4Bpl_Plot Xflip=0
    addl $9,%edi

    popl %eax
    addl $32,%eax

    P8x8_4Bpl_Plot Xflip=0
    addl $9,%edi

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT16x16_4BplTile_XY:
    pushl %eax
    pushl %ebx
    pushl %ecx

    addl TileAddressY,%eax
    pushl %eax
    addl $32,%eax

    P8x8_4Bpl_Plot Xflip=1

    popl %eax

    P8x8_4Bpl_Plot Xflip=1

    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT16x16_2BplTile:
    pushl %eax
    pushl %ebx
    pushl %edx

    movb ColourBase1,%dl
    movb ColourBase2,%dh
	addl TileAddress,%eax
    pushl %eax

    P8x8_2Bpl_Plot Xflip=0
    addl $9,%edi

    popl %eax
    addl $16,%eax

    P8x8_2Bpl_Plot Xflip=0
    addl $9,%edi

    popl %edx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT16x16_2BplTile_X:
    pushl %eax
    pushl %ebx
    pushl %edx

    movb ColourBase1,%dl
    movb ColourBase2,%dh
    addl TileAddress,%eax
    pushl %eax
    addl $16,%eax

    P8x8_2Bpl_Plot Xflip=1

    popl %eax

    P8x8_2Bpl_Plot Xflip=1

    popl %edx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT16x16_2BplTile_Y:
    pushl %eax
    pushl %ebx
    pushl %edx

    movb ColourBase1,%dl
    movb ColourBase2,%dh
    addl TileAddressY,%eax
    pushl %eax

    P8x8_2Bpl_Plot Xflip=0
    addl $9,%edi

    popl %eax
    addl $16,%eax

    P8x8_2Bpl_Plot Xflip=0
    addl $9,%edi

    popl %edx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT16x16_2BplTile_XY:
    pushl %eax
    pushl %ebx
    pushl %edx

    movb ColourBase1,%dl
    movb ColourBase2,%dh
    addl TileAddressY,%eax
    pushl %eax
    addl $16,%eax

    P8x8_2Bpl_Plot Xflip=1

    popl %eax

    P8x8_2Bpl_Plot Xflip=1

    popl %edx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT32x32_4BplSprite:
S_TILE_32x32_4:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi

	addl TileAddress,%eax
    movl %eax,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=0
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1

    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT32x32_4BplSprite_X:
S_TILE_32x32_4_X:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi

    addl TileAddress,%eax
    addl $32*3,%eax
    movl %eax,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=0

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT32x32_4BplSprite_Y:
S_TILE_32x32_4_Y:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi

    addl TileAddressY,%eax
    movl %eax,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=0
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1

    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT32x32_4BplSprite_XY:
S_TILE_32x32_4_XY:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi

    addl TileAddressY,%eax
    addl $32*3,%eax
    movl %eax,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=0

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT64x64_4BplSprite:
S_TILE_64x64_4:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi

	addl TileAddress,%eax
    movl %eax,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=0
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1

    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT64x64_4BplSprite_X:
S_TILE_64x64_4_X:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi

    addl TileAddress,%eax
    addl $32*7,%eax
    movl %eax,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=0

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT64x64_4BplSprite_Y:
S_TILE_64x64_4_Y:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi

    addl TileAddressY,%eax
    movl %eax,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=0
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1
    addl $9,%edi

    addl $32,%esi

    P8x8_4Bpl_Plot Xflip=0 Big=1

    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
	ret

.balign 16
PLOT64x64_4BplSprite_XY:
S_TILE_64x64_4_XY:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi

    addl TileAddressY,%eax
    addl $32*7,%eax
    movl %eax,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=0

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    subl $32,%esi

    P8x8_4Bpl_Plot Xflip=1 Big=1

    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
	ret

.data
.balign 16					/* Align to paragraph */
Tile_Line_8x8_2:
	.long	PLOT8x8_2BplTile
	.long	PLOT8x8_2BplTile_X
	.long	PLOT8x8_2BplTile_Y
	.long	PLOT8x8_2BplTile_XY

Tile_Line_16x16_2:
    .long   PLOT16x16_2BplTile
    .long   PLOT16x16_2BplTile_X
    .long   PLOT16x16_2BplTile_Y
    .long   PLOT16x16_2BplTile_XY

Tile_Line_8x8_4:
Sprite_Tile_Plot_8x8_4:
	.long	PLOT8x8_4BplTile
	.long	PLOT8x8_4BplTile_X
	.long	PLOT8x8_4BplTile_Y
	.long	PLOT8x8_4BplTile_XY

Tile_Line_16x16_4:
Sprite_Tile_Plot_16x16_4:
    .long   PLOT16x16_4BplTile
    .long   PLOT16x16_4BplTile_X
    .long   PLOT16x16_4BplTile_Y
    .long   PLOT16x16_4BplTile_XY

Sprite_Tile_Plot_32x32_4:
    .long   PLOT32x32_4BplSprite
    .long   PLOT32x32_4BplSprite_X
    .long   PLOT32x32_4BplSprite_Y
    .long   PLOT32x32_4BplSprite_XY

Sprite_Tile_Plot_64x64_4:
    .long   PLOT64x64_4BplSprite
    .long   PLOT64x64_4BplSprite_X
    .long   PLOT64x64_4BplSprite_Y
    .long   PLOT64x64_4BplSprite_XY

Tile_Line_8x8_8:
	.long	PLOT8x8_8BplTile
	.long	PLOT8x8_8BplTile_X
	.long	PLOT8x8_8BplTile_Y
	.long	PLOT8x8_8BplTile_XY

Tile_Line_16x16_8:
    .long   PLOT16x16_8BplTile
    .long   PLOT16x16_8BplTile_X
    .long   PLOT16x16_8BplTile_Y
    .long   PLOT16x16_8BplTile_XY

.global ColourBase1
ColourBase1:	.byte	1
.global ColourBase2
ColourBase2:	.byte	2
.global ColourBase4
ColourBase4:	.byte	4
.global ColourBase8
ColourBase8:	.byte	8
.global	ColourBase
ColourBase:     .byte   0

.text
