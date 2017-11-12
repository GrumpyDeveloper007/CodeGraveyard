/*

 Sprite Render Functions - In Assembler cos everything else is!

 This code is mostly guess work, and it should not be done like this, I have written this
file :

 A - To make sure I have the idea of how sprites are handled on snes.
 B - To show dale how the sprites are done, so he can deal with 'em!

 Dale the sprite decoding thing, is a nightmare! If you cant follow the code I understand, tell
me what you need to know and I`ll try and explain it!

*/

SPRITE_NOT_SUPPORTED:		/* This covers special cases or not implemented features! */
	ret

.macro  AddressSetup Tilesize
// Don't draw unless sprite is on this scanline
 movb 1(%esi),%al       // Get Y position
 movb HDMAYCount,%dh
 testb %dh,%dh
 jz 5f                  // Gets rid of sprite trash
 incb %al
 subb %dh,%al           // If result is not > -(Tilesize-1) then don't plot!
 jz 4f
 cmpb $-(\Tilesize-1),%al
 jb 5f
4:
 andb $(\Tilesize-1),%al    // This gives us an offset into sprite offset table

.if \Tilesize-8  // Not 8-bit
.if \Tilesize-16 // Not 16-bit
.if \Tilesize-32 // Not 32-bit
 movl Sprite_Offset_Table_64_Y(,%eax,4),%ebx
 movl Sprite_Offset_Table_64(,%eax,4),%eax
.else
 movl Sprite_Offset_Table_32_Y(,%eax,4),%ebx
 movl Sprite_Offset_Table_32(,%eax,4),%eax
.endif
.else
 movl Sprite_Offset_Table_16_Y(,%eax,4),%ebx
 movl Sprite_Offset_Table_16(,%eax,4),%eax
.endif
.else
 movl Sprite_Offset_Table_8_Y(,%eax,4),%ebx
 movl Sprite_Offset_Table_8(,%eax,4),%eax
.endif

 movl OBADDR,%ebp
 movb 3(%esi),%dh   // tile number MSB, attrib info
 testb $1,%dh
 jz 4f
 movl OBNAME,%ebp
4:
 addl %ebp,%eax
 addl %ebp,%ebx
 movl %eax,TileAddress
 movl %ebx,TileAddressY

/*
 Tile attribute word: YXPP CCCT TTTT TTTT
  Where:
   Y, X are vertical/horizontal flip
   P is priority
   C is color palette selector
   T is tile number
*/
 movb %dh,%ah
 movb 2(%esi),%al   // tile number
 andb $0x30,%dh     // Get sprite priority
 cmpb %ch,%dh       // Check sprite priority, plot only if same!
 jne 5f

// tile address in ebx, plane screen in edi

// ColourBases have bits 4-7 set to 1CCC
 movl %eax,%ebx
 shrl $5,%eax
 andb $0x70,%al
 orb  $0x80,%al     // al = 1CCC 0000
 movb %al,%ah
 movb %al,%dh
 bswapl %eax
 movb %dh,%al
 movb %dh,%ah
 orl  %eax,ColourBase1
 movl %ebx,%eax
 shrl $14,%ebx
 andl $0x1FF,%eax   // Get tile number
 shll $5,%eax       // tile * 32
 andl $3,%ebx       // ebx = YX

.if \Tilesize-8  // Not 8-bit
.if \Tilesize-16 // Not 16-bit
.if \Tilesize-32 // Not 32-bit
 call Sprite_Tile_Plot_64x64_4(,%ebx,4)
.else
 call Sprite_Tile_Plot_32x32_4(,%ebx,4)
.endif
.else
 call Sprite_Tile_Plot_16x16_4(,%ebx,4)
.endif
.else
 call Sprite_Tile_Plot_8x8_4(,%ebx,4)
.endif

 movl $0x08040201,ColourBase1
5:
 popl %ebx
 popl %edi
7:
 subb $2,%cl
 jnz 8f             // If not zero
 movb $8,%cl
 incl %ebx          // Goto next sprite byte
8:
 addl $4,%esi       // Next sprite
 decb %dl
 jnz 0b             // Loop for all sprites
 popl %edx
 subl $0x200,%esi
 subl $0x20,%ebx
 testb %dl,%dl
 jnz 0b

 popl %edi
 popl %esi
 popl %ebp
 popl %edx
 popl %ecx
 ret 

.endm

/*
 In all the sprite renderers...
  eax = (internal)
  ebx = (internal)
  cl  = sprite bit mask (internal)
  ch  = sprite plane    (input)
  dl  = sprite counter  (internal)
  dh  = (internal)
  esi = sprite tables   (internal)
  edi = sprite flags    (internal)
*/

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

.balign 16
RENDER_SPRITE_8x8_16x16:
    pushl %ecx
    pushl %edx
    pushl %ebp
    pushl %esi
    pushl %edi

    movb HiSpriteCnt2,%al
    testb %al,%al
    jz  0f
    pushl $0
0:  pushl %eax
    movl _OAMAddress,%esi   // Address of 512-byte XYTA table
    movl %esi,%ebx
    addl HighestSprite,%esi // Byte offset in 512b table
    addl HiSpriteBits,%ebx  // Byte offset in 32b table
    movb HiSpriteBits2,%cl  // Bit offset in small table byte
    movb HiSpriteCnt1,%dl   // Number of sprites in first set
    movl OBADDR,%ebp
0:  xorl %eax,%eax          // Set up eax for X position
    movb (%ebx),%dh
    rolb %cl,%dh            // Is X negative?
    jnc 4f
    
    subb (%esi),%al         // eax = -X
    jz  7f                  // This fixed the clipping!
    rorb $2,%dh             // 0: 8x8, 1: 16x16
    jc  2f

    cmpb $0x07,%al          // If X<-7, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
	jmp 3f

4:  movb (%esi),%al         // eax = X
    pushl %edi
    pushl %ebx
    addl %eax,%edi          // Plane address + X position
    rorb $2,%dh             // 0: 8x8, 1: 16x16
    jc  1f

/* 8x8 */

3:
    AddressSetup 8

2:
    cmpb $0x0F,%al          // If X<-15, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
1:

/* 16x16 */

    AddressSetup 16

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

.balign 16
RENDER_SPRITE_8x8_32x32:
    pushl %ecx
    pushl %edx
    pushl %ebp
    pushl %esi
    pushl %edi

    movb HiSpriteCnt2,%al
    testb %al,%al
    jz  0f
    pushl $0
0:  pushl %eax
    movl _OAMAddress,%esi   // Address of 512-byte XYTA table
    movl %esi,%ebx
    addl HighestSprite,%esi // Byte offset in 512b table
    addl HiSpriteBits,%ebx  // Byte offset in 32b table
    movb HiSpriteBits2,%cl  // Bit offset in small table byte
    movb HiSpriteCnt1,%dl   // Number of sprites in first set
    movl OBADDR,%ebp
0:  xorl %eax,%eax          // Set up eax for X position
    movb (%ebx),%dh
    rolb %cl,%dh            // Is X negative?
    jnc 4f
    
    subb (%esi),%al         // eax = -X
    jz  7f                  // This fixed the clipping!
    rorb $2,%dh             // 0: 8x8, 1: 32x32
    jc  2f

    cmpb $0x07,%al          // If X<-7, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
	jmp 3f

4:  movb (%esi),%al         // eax = X
    pushl %edi
    pushl %ebx
    addl %eax,%edi          // Plane address + X position
    rorb $2,%dh             // 0: 8x8, 1: 32x32
    jc  1f

/* 8x8 */

3:
    AddressSetup 8

2:
    cmpb $0x1F,%al          // If X<-31, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
1:

/* 32x32 */

    AddressSetup 32

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

.balign 16
RENDER_SPRITE_8x8_64x64:
    pushl %ecx
    pushl %edx
    pushl %ebp
    pushl %esi
    pushl %edi

    movb HiSpriteCnt2,%al
    testb %al,%al
    jz  0f
    pushl $0
0:  pushl %eax
    movl _OAMAddress,%esi   // Address of 512-byte XYTA table
    movl %esi,%ebx
    addl HighestSprite,%esi // Byte offset in 512b table
    addl HiSpriteBits,%ebx  // Byte offset in 32b table
    movb HiSpriteBits2,%cl  // Bit offset in small table byte
    movb HiSpriteCnt1,%dl   // Number of sprites in first set
    movl OBADDR,%ebp
0:  xorl %eax,%eax          // Set up eax for X position
    movb (%ebx),%dh
    rolb %cl,%dh            // Is X negative?
    jnc 4f
    
    subb (%esi),%al         // eax = -X
    jz  7f                  // This fixed the clipping!
    rorb $2,%dh             // 0: 8x8, 1: 64x64
    jc  2f

    cmpb $0x07,%al          // If X<-7, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
	jmp 3f

4:  movb (%esi),%al         // eax = X
    pushl %edi
    pushl %ebx
    addl %eax,%edi          // Plane address + X position
    rorb $2,%dh             // 0: 8x8, 1: 64x64
    jc  1f

/* 8x8 */

3:
    AddressSetup 8

2:
    cmpb $0x3F,%al          // If X<-63, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
1:

/* 64x64 */

    AddressSetup 64

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

.balign 16
RENDER_SPRITE_16x16_32x32:
    pushl %ecx
    pushl %edx
    pushl %ebp
    pushl %esi
    pushl %edi

    movb HiSpriteCnt2,%al
    testb %al,%al
    jz  0f
    pushl $0
0:  pushl %eax
    movl _OAMAddress,%esi   // Address of 512-byte XYTA table
    movl %esi,%ebx
    addl HighestSprite,%esi // Byte offset in 512b table
    addl HiSpriteBits,%ebx  // Byte offset in 32b table
    movb HiSpriteBits2,%cl  // Bit offset in small table byte
    movb HiSpriteCnt1,%dl   // Number of sprites in first set
    movl OBADDR,%ebp
0:  xorl %eax,%eax          // Set up eax for X position
    movb (%ebx),%dh
    rolb %cl,%dh            // Is X negative?
    jnc 4f
    
    subb (%esi),%al         // eax = -X
    jz  7f                  // This fixed the clipping!
    rorb $2,%dh             // 0: 16x16, 1: 32x32
    jc  2f

    cmpb $0x0F,%al          // If X<-15, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
	jmp 3f

4:  movb (%esi),%al         // eax = X
    pushl %edi
    pushl %ebx
    addl %eax,%edi          // Plane address + X position
    rorb $2,%dh             // 0: 16x16, 1: 32x32
    jc  1f

/* 16x16 */

3:
    AddressSetup 16

2:
    cmpb $0x1F,%al          // If X<-31, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
1:
/* 32x32 */

    AddressSetup 32

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

.balign 16
RENDER_SPRITE_16x16_64x64:
    pushl %ecx
    pushl %edx
    pushl %ebp
    pushl %esi
    pushl %edi

    movb HiSpriteCnt2,%al
    testb %al,%al
    jz  0f
    pushl $0
0:  pushl %eax
    movl _OAMAddress,%esi   // Address of 512-byte XYTA table
    movl %esi,%ebx
    addl HighestSprite,%esi // Byte offset in 512b table
    addl HiSpriteBits,%ebx  // Byte offset in 32b table
    movb HiSpriteBits2,%cl  // Bit offset in small table byte
    movb HiSpriteCnt1,%dl   // Number of sprites in first set
    movl OBADDR,%ebp
0:  xorl %eax,%eax          // Set up eax for X position
    movb (%ebx),%dh
    rolb %cl,%dh            // Is X negative?
    jnc 4f
    
    subb (%esi),%al         // eax = -X
    jz  7f                  // This fixed the clipping!
    rorb $2,%dh             // 0: 16x16, 1: 64x64
    jc  2f

    cmpb $0x0F,%al          // If X<-15, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
	jmp 3f

4:  movb (%esi),%al         // eax = X
    pushl %edi
    pushl %ebx
    addl %eax,%edi          // Plane address + X position
    rorb $2,%dh             // 0: 16x16, 1: 64x64
    jc  1f

/* 16x16 */

3:
    AddressSetup 16

2:
    cmpb $0x3F,%al          // If X<-63, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
1:
/* 64x64 */

    AddressSetup 64

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

.balign 16
RENDER_SPRITE_32x32_64x64:
    pushl %ecx
    pushl %edx
    pushl %ebp
    pushl %esi
    pushl %edi

    movb HiSpriteCnt2,%al
    testb %al,%al
    jz  0f
    pushl $0
0:  pushl %eax
    movl _OAMAddress,%esi   // Address of 512-byte XYTA table
    movl %esi,%ebx
    addl HighestSprite,%esi // Byte offset in 512b table
    addl HiSpriteBits,%ebx  // Byte offset in 32b table
    movb HiSpriteBits2,%cl  // Bit offset in small table byte
    movb HiSpriteCnt1,%dl   // Number of sprites in first set
    movl OBADDR,%ebp
0:  xorl %eax,%eax          // Set up eax for X position
    movb (%ebx),%dh
    rolb %cl,%dh            // Is X negative?
    jnc 4f
    
    subb (%esi),%al         // eax = -X
    jz  7f                  // This fixed the clipping!
    rorb $2,%dh             // 0: 32x32, 1: 64x64
    jc  2f

    cmpb $0x1F,%al          // If X<-31, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
	jmp 3f

4:  movb (%esi),%al         // eax = X
    pushl %edi
    pushl %ebx
    addl %eax,%edi          // Plane address + X position
    rorb $2,%dh             // 0: 32x32, 1: 64x64
    jc  1f

/* 32x32 */

3:
    AddressSetup 32

2:
    cmpb $0x3F,%al          // If X<-63, sprite is off screen, skip it
    ja  7f
    pushl %edi              // Sprite is partially off left edge
	pushl %ebx
    subl %eax,%edi          // Plane address + X position
1:
/* 64x64 */

    AddressSetup 64

.macro ALL_SPRITES_PLANE_1
    movb SPR_MASK,%bl
    testb $1,%bl    // Plane 1 sprites disabled?
    jz  0f
// Plot all sprites for plane 1
    movb $0,%ch     // Plane 1
    call *SPRMODE   // got address of sprite routines
0:
.endm

.macro ALL_SPRITES_PLANE_2
    movb SPR_MASK,%bl
    testb $2,%bl    // Plane 2 sprites disabled?
    jz  0f
// Plot all sprites for plane 2
    movb $0x10,%ch  // Plane 2
    call *SPRMODE   // got address of sprite routines
0:
.endm

.macro ALL_SPRITES_PLANE_3
    movb SPR_MASK,%bl
    testb $4,%bl    // Plane 3 sprites disabled?
    jz  0f
// Plot all sprites for plane 3
    movb $0x20,%ch  // Plane 3
    call *SPRMODE   // got address of sprite routines
0:
.endm

.macro ALL_SPRITES_PLANE_4
    movb SPR_MASK,%bl
    testb $8,%bl    // Plane 4 sprites disabled?
    jz  0f
// Plot all sprites for plane 4
    movb $0x30,%ch  // Plane 4
    call *SPRMODE   // got address of sprite routines
0:
.endm

.data

.balign 4

/* Sprite tables a little more complex than tiles... not much though! */

Sprite_Offset_Table_8:
	.long	0		/* This is line 0 of sprite */
	.long	14		/* This is line 7 of sprite */
	.long	12		/* This is line 6 of sprite */
	.long	10		/* This is line 5 of sprite */
	.long	8		/* This is line 4 of sprite */
	.long	6		/* This is line 3 of sprite */
	.long	4		/* This is line 2 of sprite */
	.long	2		/* This is line 1 of sprite */

Sprite_Offset_Table_8_Y:
	.long	14
	.long	0
	.long	2
	.long	4
	.long	6
	.long	8
	.long	10
	.long	12

Sprite_Offset_Table_16:
	.long	0
	.long	16*8*4+14
	.long	16*8*4+12
	.long	16*8*4+10
	.long	16*8*4+8
	.long	16*8*4+6
	.long	16*8*4+4
	.long	16*8*4+2
	.long	16*8*4
	.long	14
	.long	12
	.long	10
	.long	8
	.long	6
	.long	4
	.long	2

Sprite_Offset_Table_16_Y:
	.long	16*8*4+14
	.long	0
	.long	2
	.long	4
	.long	6
	.long	8
	.long	10
	.long	12
	.long	14
	.long	16*8*4
	.long	16*8*4+2
	.long	16*8*4+4
	.long	16*8*4+6
	.long	16*8*4+8
	.long	16*8*4+10
	.long	16*8*4+12

Sprite_Offset_Table_32:
	.long	0
	.long	16*8*4*3+14
	.long	16*8*4*3+12
	.long	16*8*4*3+10
	.long	16*8*4*3+8
	.long	16*8*4*3+6
	.long	16*8*4*3+4
	.long	16*8*4*3+2
	.long	16*8*4*3
	.long	16*8*4*2+14
	.long	16*8*4*2+12
	.long	16*8*4*2+10
	.long	16*8*4*2+8
	.long	16*8*4*2+6
	.long	16*8*4*2+4
	.long	16*8*4*2+2
	.long	16*8*4*2
	.long	16*8*4+14
	.long	16*8*4+12
	.long	16*8*4+10
	.long	16*8*4+8
	.long	16*8*4+6
	.long	16*8*4+4
	.long	16*8*4+2
	.long	16*8*4
	.long	14
	.long	12
	.long	10
	.long	8
	.long	6
	.long	4
	.long	2

Sprite_Offset_Table_32_Y:
	.long	16*8*4*3+14
	.long	0
	.long	2
	.long	4
	.long	6
	.long	8
	.long	10
	.long	12
	.long	14
	.long	16*8*4
	.long	16*8*4+2
	.long	16*8*4+4
	.long	16*8*4+6
	.long	16*8*4+8
	.long	16*8*4+10
	.long	16*8*4+12
	.long	16*8*4+14
	.long	16*8*4*2
	.long	16*8*4*2+2
	.long	16*8*4*2+4
	.long	16*8*4*2+6
	.long	16*8*4*2+8
	.long	16*8*4*2+10
	.long	16*8*4*2+12
	.long	16*8*4*2+14
	.long	16*8*4*3
	.long	16*8*4*3+2
	.long	16*8*4*3+4
	.long	16*8*4*3+6
	.long	16*8*4*3+8
	.long	16*8*4*3+10
	.long	16*8*4*3+12

Sprite_Offset_Table_64:
	.long	0
	.long	16*8*4*7+14
	.long	16*8*4*7+12
	.long	16*8*4*7+10
	.long	16*8*4*7+8
	.long	16*8*4*7+6
	.long	16*8*4*7+4
	.long	16*8*4*7+2
	.long	16*8*4*7
	.long	16*8*4*6+14
	.long	16*8*4*6+12
	.long	16*8*4*6+10
	.long	16*8*4*6+8
	.long	16*8*4*6+6
	.long	16*8*4*6+4
	.long	16*8*4*6+2
	.long	16*8*4*6
	.long	16*8*4*5+14
	.long	16*8*4*5+12
	.long	16*8*4*5+10
	.long	16*8*4*5+8
	.long	16*8*4*5+6
	.long	16*8*4*5+4
	.long	16*8*4*5+2
	.long	16*8*4*5
	.long	16*8*4*4+14
	.long	16*8*4*4+12
	.long	16*8*4*4+10
	.long	16*8*4*4+8
	.long	16*8*4*4+6
	.long	16*8*4*4+4
	.long	16*8*4*4+2
	.long	16*8*4*4
	.long	16*8*4*3+14
	.long	16*8*4*3+12
	.long	16*8*4*3+10
	.long	16*8*4*3+8
	.long	16*8*4*3+6
	.long	16*8*4*3+4
	.long	16*8*4*3+2
	.long	16*8*4*3
	.long	16*8*4*2+14
	.long	16*8*4*2+12
	.long	16*8*4*2+10
	.long	16*8*4*2+8
	.long	16*8*4*2+6
	.long	16*8*4*2+4
	.long	16*8*4*2+2
	.long	16*8*4*2
	.long	16*8*4+14
	.long	16*8*4+12
	.long	16*8*4+10
	.long	16*8*4+8
	.long	16*8*4+6
	.long	16*8*4+4
	.long	16*8*4+2
	.long	16*8*4
	.long	14
	.long	12
	.long	10
	.long	8
	.long	6
	.long	4
	.long	2

Sprite_Offset_Table_64_Y:
	.long	16*8*4*7+14
	.long	0
	.long	2
	.long	4
	.long	6
	.long	8
	.long	10
	.long	12
	.long	14
	.long	16*8*4
	.long	16*8*4+2
	.long	16*8*4+4
	.long	16*8*4+6
	.long	16*8*4+8
	.long	16*8*4+10
	.long	16*8*4+12
	.long	16*8*4+14
	.long	16*8*4*2
	.long	16*8*4*2+2
	.long	16*8*4*2+4
	.long	16*8*4*2+6
	.long	16*8*4*2+8
	.long	16*8*4*2+10
	.long	16*8*4*2+12
	.long	16*8*4*2+14
	.long	16*8*4*3
	.long	16*8*4*3+2
	.long	16*8*4*3+4
	.long	16*8*4*3+6
	.long	16*8*4*3+8
	.long	16*8*4*3+10
	.long	16*8*4*3+12
	.long	16*8*4*3+14
	.long	16*8*4*4
	.long	16*8*4*4+2
	.long	16*8*4*4+4
	.long	16*8*4*4+6
	.long	16*8*4*4+8
	.long	16*8*4*4+10
	.long	16*8*4*4+12
	.long	16*8*4*4+14
	.long	16*8*4*5
	.long	16*8*4*5+2
	.long	16*8*4*5+4
	.long	16*8*4*5+6
	.long	16*8*4*5+8
	.long	16*8*4*5+10
	.long	16*8*4*5+12
	.long	16*8*4*5+14
	.long	16*8*4*6
	.long	16*8*4*6+2
	.long	16*8*4*6+4
	.long	16*8*4*6+6
	.long	16*8*4*6+8
	.long	16*8*4*6+10
	.long	16*8*4*6+12
	.long	16*8*4*6+14
	.long	16*8*4*7
	.long	16*8*4*7+2
	.long	16*8*4*7+4
	.long	16*8*4*7+6
	.long	16*8*4*7+8
	.long	16*8*4*7+10
	.long	16*8*4*7+12

.globl SPRMODE
SPRMODE:    .long   RENDER_SPRITE_8x8_16x16

.globl Sprite_Mode
Sprite_Mode:
    .long   RENDER_SPRITE_8x8_16x16     // 8x8 or 16x16
    .long   RENDER_SPRITE_8x8_32x32     // 8x8 or 32x32
    .long   RENDER_SPRITE_8x8_64x64     // 8x8 or 64x64
    .long   RENDER_SPRITE_16x16_32x32   // 16x16 or 32x32
    .long   RENDER_SPRITE_16x16_64x64   // 16x16 or 64x64
    .long   RENDER_SPRITE_32x32_64x64   // 32x32 or 64x64
    .long   SPRITE_NOT_SUPPORTED        // NOT SUPPORTED BY SUPER NINTENDO!
    .long   SPRITE_NOT_SUPPORTED        // NOT SUPPORTED BY SUPER NINTENDO!

.text
