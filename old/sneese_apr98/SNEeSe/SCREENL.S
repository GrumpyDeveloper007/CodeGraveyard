/*

 SCREEN HDMA FUNCTIONS - I had a load more here but my computer crashed!!@!!


  I really wish I didn't have to re-write the entire screen code to support
 this, but I do! What follows is a summary as to how I intend to tackle the
 problem of LINExLINE rendering!

  Oh and once this is up and running, say goodbye to tile code!!!!!!!!!!!

  As before there will be a plotter for each colour depth, this time though
 each plotter will only write a single run of pixels (1 scan line!).

  Each run will be told how many tiles to plot (0-33 or 0-17) and it will
 then go ahead, this is to accomodate those layout modes horizontally!
 Vertical layout handling will be performed at the scanline level!

  Optimisations are last on my mind, first time through it will be stable
 and fully functional. The tile plotters in this method only plot a
 single line from a tile, which makes them a little simpler.

  Sprites will also be plotted a line at a time, making them a bit more
 nightmarish!!!!!! 

  The layout functions are a lot simpler than in tile mode, they bare a
 small resemblance to Dark Elfs code.. hehehehe!

*/

#include "TilesL.S"     // Include all tile plotters
#include "spriteL.S"

// esi is screen address, works cos we only plot until wraparound!
// ch contains the X counter
// cl contains the screen addition for palette offsetting (2bpl only)
// edi is the address to draw to..
// TileAddress contains the location for the SNES tile data
// TileAddress(Y) must be offset to the correct line for that row
// TileAddressY is used for Y-flip

.balign 16
RENDER_LINE_8x8_OFFSET_CHANGE:      /* Am I the first to support this? */

	pusha

	movb $32,%cl			/* %ch contains cmpb for determining planes to affect */
    movl ScreenAddress3,%ebx    /. %ebx contains address of vert offset data
	addl $64,%ebx
2:
	pushl %ecx
	movb %ch,%dh

	movl HDMAYCount,%ecx
	movw (%ebx),%ax
	andb %dh,%ah
	jz 0f
	addb %al,%cl
0:	addl $2,%ebx
    andl $0xFF,%ecx             /* ecx contains real Y offset for next tile */

	pushl %ebx

	movl %ecx,%eax
    andl $0x07,%eax
    andl $0xF8,%ecx
    shll $3,%ecx    // Get screen offset
    movl TileAddressM2,%edx
	movl Tile_Offset_Table_8_Y(,%eax,4),%ebx
	movl Tile_Offset_Table_8(,%eax,4),%eax
    addl %edx,%eax
    addl %edx,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY

	addl %esi,%ecx

    movl (%ecx),%eax    // Get Tile Information
    movb %ah,%dl
    addl $2,%esi        // Update screen pointer
    movl %eax,%ebx
    andl $0x1C,%edx     // Get palette
    andl $0x3FF,%eax    // Get TileNum
    addl %edx,%edx
    shll $5,%eax        // 4*8
    addl %edx,%edx
    movb %dl,%dh
    orl  %edx,ColourBase1
    orw  %dx,ColourBase4

    shrl $14,%ebx
    andl $3,%ebx    // Get Y/X flip

    call Tile_Line_8x8_4(,%ebx,4)
    movl $0x08040201,ColourBase1

	popl %ebx
	popl %ecx

    decb %cl
	jnz	2b

	popa
	ret


// New for v0.15, Mode 0 has its own renderers
.macro LINE_8x8_M0
    pushl %ecx

1:  movl (%esi),%eax    // Get tile information for screen pos
    movb %ah,%dl
    addl $2,%esi        // Update screen pointer
    movl %eax,%ebx
    andl $0x1C,%edx     // Get palette
    andl $0x3FF,%eax    // Get TileNum
    addb %cl,%dl        // Adjust palette for mode 0
    shll $4,%eax        // 2*8
    movb %dl,%dh
    orl  %edx,ColourBase1

    shrl $14,%ebx
    andl $3,%ebx        // Get Y/X flip

    call Tile_Line_8x8_2(,%ebx,4)
    movl $0x08040201,ColourBase1

    decb %ch
	jnz	1b

    popl %ecx
.endm

.macro RENDER_M0_8x8
    testb %al,%al   // If 0 simply plot 32 tiles
    jz 0f

    movl $0x100,%edx
    movb %al,%bl
    andl $0x07,%eax     /* Amount to subtract from edi */
    andl $0xF8,%ebx
	subl %eax,%edi
    subl %ebx,%edx
    shrl $3,%edx
    movb %dl,%ch
    movb $32,%dl
    subb %ch,%dl
	pushl %esi
	addl ScreenAddressL,%esi
	addl %edx,%esi
	addl %edx,%esi
    LINE_8x8_M0
	xorl %edx,%edx
	popl %esi
	movb %ch,%dl
    movb $33,%ch
    subb %dl,%ch
    shll $3,%edx
	addl ScreenAddressR,%esi
    LINE_8x8_M0
    ret
0:	addl ScreenAddressL,%esi
	movb $32,%ch
    LINE_8x8_M0
    ret
.endm

.macro LINE_16x16_M0
    pushl %ecx

	movl TileAddress_2,%eax
	movl TileAddressY_2,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY

1:  movl (%esi),%eax    // Get tile information for screen pos
    movb %ah,%dl
    addl $2,%esi        // Update screen pointer
    movl %eax,%ebx
    andl $0x1C,%edx     // Get palette
    andl $0x3FF,%eax    // Get TileNum
    addb %cl,%dl        // Adjust palette for mode 0
    shll $4,%eax        // 2*8
    movb %dl,%dh
    orl  %edx,ColourBase1

    shrl $14,%ebx
    andl $3,%ebx        // Get Y/X flip

    call Tile_Line_16x16_2(,%ebx,4)
    movl $0x08040201,ColourBase1

    decb %ch
	jnz	1b

    popl %ecx
.endm

.macro RENDER_M0_16x16
    testb %al,%al   // If 0 simply plot 32 tiles
    jz 0f

    movl $0x100,%edx
    movb %al,%bl
    andl $0x0F,%eax     /* Amount to subtract from edi */
    andl $0xF0,%ebx
	subl %eax,%edi
    subl %ebx,%edx
    shrl $4,%edx
	movb %dl,%ch
	movb $16,%dl
	subb %ch,%dl
	pushl %esi
	addl ScreenAddressL,%esi
	addl %edx,%esi
	addl %edx,%esi
    LINE_16x16_M0
	xorl %edx,%edx
	popl %esi
	movb %ch,%dl
    movb $17,%ch
    subb %dl,%ch
    shll $4,%edx
	addl ScreenAddressR,%esi
    LINE_16x16_M0
    ret
0:	addl ScreenAddressL,%esi
	movb $16,%ch
    LINE_16x16_M0
    ret
.endm

.macro LINE_8x8_C2
    pushl %ecx

1:  movl (%esi),%eax    // Get tile information for screen pos
    movb %ah,%dl
    addl $2,%esi        // Update screen pointer
    movl %eax,%ebx
    andl $0x1C,%edx     // Get palette
    andl $0x3FF,%eax    // Get TileNum
    shll $4,%eax        // 2*8
    movb %dl,%dh
    orl  %edx,ColourBase1

    shrl $14,%ebx
    andl $3,%ebx        // Get Y/X flip

    call Tile_Line_8x8_2(,%ebx,4)
    movl $0x08040201,ColourBase1

    decb %ch
	jnz	1b

    popl %ecx
.endm

.macro LINE_8x8_C4
    pushl %ecx

1:  movl (%esi),%eax    // Get tile information for screen pos
    movb %ah,%dl
    addl $2,%esi        // Update screen pointer
    movl %eax,%ebx
    andl $0x1C,%edx     // Get palette
    andl $0x3FF,%eax    // Get TileNum
    addl %edx,%edx
    shll $5,%eax        // 4*8
    addl %edx,%edx
    movb %dl,%dh
    orl  %edx,ColourBase1
    orw  %dx,ColourBase4

    shrl $14,%ebx
    andl $3,%ebx    // Get Y/X flip

    call Tile_Line_8x8_4(,%ebx,4)
    movl $0x08040201,ColourBase1

    decb %ch
	jnz	1b

    popl %ecx
.endm

.macro LINE_8x8_C8
    pushl %ecx

1:  movl (%esi),%eax    // Get tile information for screen pos
    addl $2,%esi        // Update screen pointer

    movl %eax,%ebx
    andl $0x3FF,%eax    // Get TileNum
    shll $6,%eax        // 8*8

    shrl $14,%ebx
    andl $3,%ebx        // Get Y/X flip

    call Tile_Line_8x8_8(,%ebx,4)

    decb %ch
	jnz	1b

    popl %ecx
.endm

.macro RENDER_8x8 depth
    testb %al,%al   // If 0 simply plot 32 tiles
    jz 0f

    movl $0x100,%edx
    movb %al,%bl
    andl $0x07,%eax     /* Amount to subtract from edi */
    andl $0xF8,%ebx
	subl %eax,%edi
    subl %ebx,%edx
    shrl $3,%edx
    movb %dl,%ch
    movb $32,%dl
    subb %ch,%dl
	pushl %esi
	addl ScreenAddressL,%esi
	addl %edx,%esi
	addl %edx,%esi
    LINE_8x8_C\depth
	xorl %edx,%edx
	popl %esi
	movb %ch,%dl
    movb $33,%ch
    subb %dl,%ch
    shll $3,%edx
	addl ScreenAddressR,%esi
    LINE_8x8_C\depth
    ret
0:	addl ScreenAddressL,%esi
	movb $32,%ch
    LINE_8x8_C\depth
    ret
.endm

.macro LINE_16x16_C2
    pushl %ecx

	movl TileAddress_2,%eax
	movl TileAddressY_2,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY

1:  movl (%esi),%eax    // Get tile information for screen pos
    movb %ah,%dl
    addl $2,%esi        // Update screen pointer
    movl %eax,%ebx
    andl $0x1C,%edx     // Get palette
    andl $0x3FF,%eax    // Get TileNum
    shll $4,%eax        // 2*8
    movb %dl,%dh
    orl  %edx,ColourBase1

    shrl $14,%ebx
    andl $3,%ebx        // Get Y/X flip

    call Tile_Line_16x16_2(,%ebx,4)
    movl $0x08040201,ColourBase1

    decb %ch
	jnz	1b

    popl %ecx
.endm

.macro LINE_16x16_C4
    pushl %ecx

	movl TileAddress_4,%eax
	movl TileAddressY_4,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY

1:  movl (%esi),%eax    // Get tile information for screen pos
    movb %ah,%dl
    addl $2,%esi        // Update screen pointer
    movl %eax,%ebx
    andl $0x1C,%edx     // Get palette
    andl $0x3FF,%eax    // Get TileNum
    addl %edx,%edx
    shll $5,%eax        // 4*8
    addl %edx,%edx
    movb %dl,%dh
    orl  %edx,ColourBase1
    orw  %dx,ColourBase4

    shrl $14,%ebx
    andl $3,%ebx    // Get Y/X flip

    call Tile_Line_16x16_4(,%ebx,4)
    movl $0x08040201,ColourBase1

    decb %ch
	jnz	1b

    popl %ecx
.endm

.macro LINE_16x16_C8
    pushl %ecx

	movl TileAddress_8,%eax
	movl TileAddressY_8,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY

1:  movl (%esi),%eax    // Get tile information for screen pos
    addl $2,%esi        // Update screen pointer

    movl %eax,%ebx
    andl $0x3FF,%eax    // Get TileNum
    shll $6,%eax        // 8*8

    shrl $14,%ebx
    andl $3,%ebx        // Get Y/X flip

    call Tile_Line_16x16_8(,%ebx,4)

    decb %ch
	jnz	1b

    popl %ecx
.endm

.macro RENDER_16x16 depth
    testb %al,%al   // If 0 simply plot 32 tiles
    jz 0f

    movl $0x100,%edx
    movb %al,%bl
    andl $0x0F,%eax     /* Amount to subtract from edi */
    andl $0xF0,%ebx
	subl %eax,%edi
    subl %ebx,%edx
    shrl $4,%edx
	movb %dl,%ch
	movb $16,%dl
	subb %ch,%dl
	pushl %esi
	addl ScreenAddressL,%esi
	addl %edx,%esi
	addl %edx,%esi
    LINE_16x16_C\depth
	xorl %edx,%edx
	popl %esi
	movb %ch,%dl
    movb $17,%ch
    subb %dl,%ch
    shll $4,%edx
	addl ScreenAddressR,%esi
    LINE_16x16_C\depth
    ret
0:	addl ScreenAddressL,%esi
	movb $16,%ch
    LINE_16x16_C\depth
    ret
.endm

.balign 16
RENDER_8x8_M0:
    RENDER_M0_8x8
.balign 16
RENDER_16x16_M0:
    RENDER_M0_16x16
.balign 16
RENDER_8x8_C2:
    RENDER_8x8 2
.balign 16
RENDER_16x16_C2:
    RENDER_16x16 2
.balign 16
RENDER_8x8_C4:
    RENDER_8x8 4
.balign 16
RENDER_16x16_C4:
    RENDER_16x16 4
.balign 16
RENDER_8x8_C8:
    RENDER_8x8 8
.balign 16
RENDER_16x16_C8:
    RENDER_16x16 8

RENDER_MODE_7_FX:
	pusha

    movb Redo_M7,%dl
    testb $0x0F,%dl // Need to do any recalculating?
    jz  0f
    testb $0x0A,%dl // Recalculate B or D?
    jz  1f
    movl BG1VScrollData,%eax
    subl _M7Y_DATA,%eax
    testb $0x02,%dl // Recalculate B?
    jz  2f
    pushl %eax
    imull _M7B_DATA,%eax
    movl %eax,Mode7_B
    popl %eax
    testb $0x08,%dl // Recalculate D?
    jz  1f
2:  imull _M7D_DATA,%eax
    movl %eax,Mode7_D
1:  movl BG1HScrollData,%eax
    subl _M7X_DATA,%eax
2:  testb $0x05,%dl // Recalculate A or C?
    jz  0f
    movl BG1HScrollData,%eax
    subl _M7X_DATA,%eax
    testb $0x01,%dl // Recalculate A?
    jz  2f
    pushl %eax
    imull _M7A_DATA,%eax
    movl _M7X_DATA,%ebx
    shll $8,%ebx
    addl %ebx,%eax
    movl %eax,Mode7_A_P
    popl %eax
    testb $0x04,%dl // Recalculate C?
    jz  0f
2:  imull _M7C_DATA,%eax
    movl _M7Y_DATA,%ebx
    shll $8,%ebx
    addl %ebx,%eax
    movl %eax,Mode7_C_P
0:  movb $0,Redo_M7 // Done with recalculating
    movl HDMAYCount,%ebx

	movb M7SEL,%al
    testb $2,%al    // Is Y flip
    jz  SKIP_M7_Y

	movl $255,%edx
	subl %ebx,%edx
	movl %edx,%ebx

SKIP_M7_Y:
    movl _M7B_DATA,%edx
    imull %ebx,%edx
    addl Mode7_A_P,%edx
    addl Mode7_B,%edx
    movl %edx,Mode7_A

    movl _M7D_DATA,%edx
    imull %ebx,%edx
    addl Mode7_C_P,%edx
    addl Mode7_D,%edx
    movl %edx,Mode7_C

	movl _VRamAddress,%esi

// Once we reach here the maths is done,
// now we determine which mode 7 to use

    testb $1,%al    // Is X flip
    jnz M7_X

    shrb $6,%al     // Get repetition mode values in low part
	cmpb $3,%al
    je M7_CLIP

    testb %al,%al
    jz M7_REPEAT    // Screen repeats e.g. wrap x and y values

	jmp M7_CHAR0

M7_X:
    shrb $6,%al     // Get repetition mode values in low part
	cmpb $3,%al
	je M7_CLIPX

    testb %al,%al
    jz M7_REPEATX   // Screen repeats e.g. wrap x and y values

	jmp M7_CHAR0X

M7_REPEAT:
	movl Mode7_A,%eax
	movl Mode7_C,%ebx

    movl $256,%ebp      // Horizontal Count

1:  pushl %eax
    pushl %ebx

	shrl $8,%eax
	shrl $8,%ebx
    andl $0x3FF,%eax
    andl $0x3FF,%ebx

    cmpb $0,(%edi)      // Check to see if pixel see through
	jne 4f

// Convert Screen X,Y location to SNES Pic location

                // Assumes %ax is X coord 0-1023, $bx is Y 0-1023
    pushl %ecx
    pushl %edx
    movl %eax,%ecx
    movl %ebx,%edx
    shrl $3,%eax    // Get Tile Position (in 128 by 128 map)
    andl $7,%ecx    // Get pixel shift within tile
    andl $~7,%ebx
    andl $7,%edx
    shll $5,%ebx    // Tile Position*256 cos thats width of map
    addb %al,%al
    movb %al,%bl    // Map offset now in %ebx
	xorl %eax,%eax
    movb (%esi,%ebx),%al    // Got Tile Number
	
    shll $7,%eax            // Make 64*2 offset to tile data
	addl %esi,%eax
	incl %eax

    addl %ecx,%ecx
    addl %ecx,%eax          // Add X offset
	shll $4,%edx
    addl %edx,%eax          // Add Y offset

    movb (%eax),%al
    movb %al,(%edi)
    popl %edx
    popl %ecx

4:  popl %ebx
    popl %eax

    movl _M7A_DATA,%ecx
    movl _M7C_DATA,%edx
	addl %ecx,%eax
	addl %edx,%ebx

    incl %edi

	decl %ebp
	jnz 1b

	popa
	ret

M7_REPEATX:
	movl Mode7_A,%eax
	movl Mode7_C,%ebx

	addl $255,%edi

    movl $256,%ebp      // Horizontal Count

1:  pushl %eax
    pushl %ebx

	shrl $8,%eax
	shrl $8,%ebx
    andl $0x3FF,%eax
    andl $0x3FF,%ebx

    cmpb $0,(%edi)      // Check to see if pixel see through
	jne 4f

// Convert Screen X,Y location to SNES Pic location

                // Assumes %ax is X coord 0-1023, $bx is Y 0-1023
    pushl %ecx
    pushl %edx
    movl %eax,%ecx
    movl %ebx,%edx
    shrl $3,%eax    // Get Tile Position (in 128 by 128 map)
    andl $7,%ecx    // Get pixel shift within tile
    andl $~7,%ebx
    andl $7,%edx
    shll $5,%ebx    // Tile Position*256 cos thats width of map
    addb %al,%al
    movb %al,%bl    // Map offset now in %ebx
	xorl %eax,%eax
    movb (%esi,%ebx),%al    // Got Tile Number
	
    shll $7,%eax            // Make 64*2 offset to tile data
	addl %esi,%eax
	incl %eax

    addl %ecx,%ecx
    addl %ecx,%eax          // Add X offset
	shll $4,%edx
    addl %edx,%eax          // Add Y offset

    movb (%eax),%al
    movb %al,(%edi)
    popl %edx
    popl %ecx

4:  popl %ebx
    popl %eax

    movl _M7A_DATA,%ecx
    movl _M7C_DATA,%edx
	addl %ecx,%eax
	addl %edx,%ebx

	decl %edi

	decl %ebp
	jnz 1b

	popa
	ret

M7_CHAR0:           // For now it acts like clip mode
M7_CLIP:
	movl Mode7_A,%eax
	movl Mode7_C,%ebx

    movl $256,%ebp      // Horizontal Count

1:  pushl %eax
    pushl %ebx

	shrl $8,%eax
	shrl $8,%ebx

    cmpb $0,(%edi)      // Check to see if pixel see through
	jne 4f

    cmpl $1023,%eax     // If outside screen range we simply skip the pixel
	ja 4f
    cmpl $1023,%ebx
	ja 4f

// Convert Screen X,Y location to SNES Pic location

                // Assumes %ax is X coord 0-1023, $bx is Y 0-1023
    pushl %ecx
    pushl %edx
    movl %eax,%ecx
    movl %ebx,%edx
    shrl $3,%eax    // Get Tile Position (in 128 by 128 map)
    andl $7,%ecx    // Get pixel shift within tile
    andl $~7,%ebx
    andl $7,%edx
    shll $5,%ebx    // Tile Position*256 cos thats width of map
    addb %al,%al
    movb %al,%bl    // Map offset now in %ebx
	xorl %eax,%eax
    movb (%esi,%ebx),%al    // Got Tile Number
	
    shll $7,%eax            // Make 64*2 offset to tile data
	addl %esi,%eax
	incl %eax

    addl %ecx,%ecx
    addl %ecx,%eax          // Add X offset
	shll $4,%edx
    addl %edx,%eax          // Add Y offset

    movb (%eax),%al
    movb %al,(%edi)
    popl %edx
    popl %ecx

4:  popl %ebx
    popl %eax

    movl _M7A_DATA,%ecx
    movl _M7C_DATA,%edx
	addl %ecx,%eax
	addl %edx,%ebx

	incl %edi

	decl %ebp
	jnz 1b

	popa
	ret

M7_CHAR0X:          // For now it acts like clip mode
M7_CLIPX:
	movl Mode7_A,%eax
	movl Mode7_C,%ebx

	addl $255,%edi

    movl $256,%ebp          // Horizontal Count

1:  pushl %eax
    pushl %ebx

	shrl $8,%eax
	shrl $8,%ebx

    cmpb $0,(%edi)      // Check to see if pixel see through
	jne 4f

    cmpl $1023,%eax     // If outside screen range we simply skip the pixel
	ja 4f
    cmpl $1023,%ebx
	ja 4f

// Convert Screen X,Y location to SNES Pic location

                // Assumes %ax is X coord 0-1023, $bx is Y 0-1023
    pushl %ecx
    pushl %edx
    movl %eax,%ecx
    movl %ebx,%edx
    shrl $3,%eax    // Get Tile Position (in 128 by 128 map)
    andl $7,%ecx    // Get pixel shift within tile
    andl $~7,%ebx
    andl $7,%edx
    shll $5,%ebx    // Tile Position*256 cos thats width of map
    addb %al,%al
    movb %al,%bl    // Map offset now in %ebx
	xorl %eax,%eax
    movb (%esi,%ebx),%al    // Got Tile Number
	
    shll $7,%eax            // Make 64*2 offset to tile data
	addl %esi,%eax
	incl %eax

    addl %ecx,%ecx
    addl %ecx,%eax          // Add X offset
	shll $4,%edx
    addl %edx,%eax          // Add Y offset

    movb (%eax),%al
    movb %al,(%edi)
    popl %edx
    popl %ecx

4:  popl %ebx
    popl %eax

    movl _M7A_DATA,%ecx
    movl _M7C_DATA,%edx
	addl %ecx,%eax
	addl %edx,%ebx

	decl %edi

	decl %ebp
	jnz 1b

	popa
	ret

.balign 16
.globl Clear_Screen
Clear_Screen:
    pushl %eax
    pushl %ecx
    pushl %edi

    movl _ScreenX,%ecx
    shrl $2,%ecx
    imull _ScreenY,%ecx

	movl _SNES_Screen,%edi
    xorl %eax,%eax
    rep
    stosl

    popl %edi
    popl %ecx
    popl %eax
	ret

.balign 16
.globl Copy_Screen
Copy_Screen:
	pusha

	movb _fixedpalettecheck,%al
	cmpb $0,%al
	je 0f

	movb $0,_fixedpalettecheck	
	movb CGWSEL,%al		/* Fix mario blue sky colour */
	andb $0x02,%al
	jz 0f
	movb CGADSUB,%al
	andb $0x20,%al
	jz 0f
	movb CGADSUB,%al
	andb $0x80,%al
	jnz 0f

	movw FIXEDCOLDATA,%bx
	xorl %eax,%eax
	movl _Real_SNES_Palette,%edi
	movw %bx,(%edi,%eax,2)

	pusha
        call _SetPalette
	popa
0:
    xorl %eax,%eax
	movl _BKG,%edi
	addl $64+(256+2*64)*(64+224),%edi
    movl $32,%edx   // Assume 224 tall
    testb $4,SETINI // Is Field 224 or 240 in length?
    jz  2f          // 224 lines, do long blanking routine

    addl $(256+2*64)*16,%edi
    subl $16,%edx   // Adjust for 240 tall

2:  movl $(256/4),%ecx
    rep
    stosl

    addl $128,%edi      // 16 tile positions added to get to next row!
	decl %edx
	jnz 2b

    movb _PC_SCREEN_MODE,%al
    andb $0xF,%eax
    jmpl Copy_Screen_Table(,%eax,4)

VGA_COPY:   // Blits directly to VGA memory
    pushl %es
    pushl %gs
    popl %es
    movl $0xA0000,%edi
	movl _BKG,%esi
    addl $64+(256+2*64)*64,%esi // Offset to center of bkground!
    movb $200,%dl
0:  movl $(256/4),%ecx
    rep
    movsl

	addl $(320-256),%edi
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */
    decb %dl
    jnz 0b

    popl %es
	popa
	ret

MODEX_COPY:
	movl _ScreenY,%eax
	movl _ScreenX,%edx
	subl $256,%edx

	movl _SNES_Screen,%edi
	movl _BKG,%esi
    addl $64+(256+2*64)*64,%esi // Offset to center of bkground!
0:  movl $(256/4),%ecx
    rep
    movsl

	addl %edx,%edi
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */
	decl %eax
	jnz 0b

	popa
    call _CopySNESScreen        /* Redraw VGA Mode Screen */
	ret

HICOLOUR0_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

/* 320x200 screen... */

	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl _HICOLOUR_Palette,%ecx
	xorl %eax,%eax

	movb $200,%dl
0:  movb $0,%dh         /* do 256 times */
1:
	movb (%esi),%al
	movw (%ecx,%eax,4),%ebx
	incl %esi
	movw %bx,(%edi)
	addl $2,%edi

	decb %dh
	jnz 1b

	addl $(320-256)*2,%edi		/* Goto next line */
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */

	decb %dl
	jnz 0b	

	popa
	call _CopySNESScreen		/* Redraw VGA Mode Screen */
	ret

HICOLOUR1_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

/* 320x240 screen... */

	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl _HICOLOUR_Palette,%ecx
	xorl %eax,%eax

	movb $240,%dl
0:  movb $0,%dh         /* do 256 times */
1:
	movb (%esi),%al
	movw (%ecx,%eax,4),%ebx
	incl %esi
	movw %bx,(%edi)
	addl $2,%edi

	decb %dh
	jnz 1b

	addl $(320-256)*2,%edi		/* Goto next line */
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */

	decb %dl
	jnz 0b	

	popa
	call _CopySNESScreen		/* Redraw VGA Mode Screen */
	ret

HICOLOUR2_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

/* 640x480 screen... 256*2 used 128 remains */

	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl _HICOLOUR_Palette,%ecx
	xorl %eax,%eax

	movb $240,%dl
0:  movb $0,%dh         /* do 256 times */
1:
	movb (%esi),%al
	movw (%ecx,%eax,4),%ebx
	incl %esi
	movw %bx,(%edi)
	addl $2,%edi

	decb %dh
	jnz 1b

	addl $256*3,%edi		/* Goto next line */
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */

	decb %dl
	jnz 0b	

	popa
	call _CopySNESScreen		/* Redraw VGA Mode Screen */
	ret

STRETCH_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

/* 640x480 screen... 256*2 used 128 remains */

	movl _BKG,%esi
	movl _SNES_Screen,%edi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl _HICOLOUR_Palette,%ecx
	xorl %eax,%eax

	movb $240,%dl
0:  movb $0,%dh         /* do 256 times */
1:
	movb (%esi),%al
	incl %esi
	movl (%ecx,%eax,4),%ebx
	movl %ebx,(%edi)
    movl %ebx,1280(%edi)
	addl $4,%edi

	decb %dh
	jnz 1b

	addl $128*2+(640*2),%edi	/* Goto next line */
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */

	decb %dl
	jnz 0b	

	popa
	call _CopySNESScreen		/* Redraw VGA Mode Screen */
	ret

SQUASH:		/* This routine is specialised! 320x200 squash copy */
    pushl %es
    pushl %gs
    popl %es
    movl $0xA0000,%edi
	movl _BKG,%esi
    addl $64+(256+2*64)*64,%esi // Offset to center of bkground!
    movb $40,%dh
0:  // Outer Loop
    movb $5,%dl
2:  // Inner Loop
    movl $(256/4),%ecx
    rep
    movsl

	addl $(320-256),%edi
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */
    decb %dl
	jnz 2b

	addl $(256+2*64),%esi		/* Skip a scan line */

    decb %dh
	jnz 0b

    popl %es
	popa
	ret

.macro SORT_SCREEN_LAYOUT num
    xorl %edx,%edx
    movb BGSC\num,%al
    cmpb $2,%al
    jb 0f
    movl VScrollData_\num,%eax
    je 2f

3:  addl HDMAYCount,%eax
    testb $1,%ah
    jz  0f          // If set do top
    movl $32*32*2*2,%edx
    jmp 0f

2:  addl HDMAYCount,%eax
    testb $1,%ah
    jz  0f          // If set do top
    movl $32*32*2,%edx

0:  movl ScreenAddressL\num,%eax
    addl %edx,%eax
    movl %eax,ScreenAddressL
    movl ScreenAddressR\num,%eax
    addl %edx,%eax
    movl %eax,ScreenAddressR
.endm

.macro SORT_TILES_8x8 num
    // using: eax, ebx, edx
    // returns: esi
    movl HDMAYCount,%eax
    movl TileAddress\num,%edx
    addl VScrollData_\num,%eax
    movl %eax,%esi
    andl $0xF8,%esi
    andl $0x07,%eax
    shll $3,%esi    // Get screen offset
	movl Tile_Offset_Table_8_Y(,%eax,4),%ebx
	movl Tile_Offset_Table_8(,%eax,4),%eax
    addl %edx,%ebx
    addl %edx,%eax
	movl %eax,TileAddress
	movl %ebx,TileAddressY
.endm

/* V 0.15 - Support for snes' 16x8 tiles.. I wonder if there are 8x16 modes..? */

.macro SORT_TILES_16x8 num
    // using: eax, ebx, edx, ebp
    // returns: esi
    movl HDMAYCount,%eax
    movl TileAddress\num,%edx
    addl VScrollData_\num,%eax
    movl %eax,%esi
    andl $0xF8,%esi
	andl $0x07,%eax
	shl $3,%esi  // Get screen offset
	movl Tile_Offset_Table_16_2(,%eax,4),%ebx
    movl Tile_Offset_Table_16_2_Y(,%eax,4),%ebp
    addl %edx,%ebx
    addl %edx,%ebp
	movl %ebx,TileAddress_2
    movl %ebp,TileAddressY_2
	movl Tile_Offset_Table_16_4(,%eax,4),%ebx
    movl Tile_Offset_Table_16_4_Y(,%eax,4),%ebp
    addl %edx,%ebx
    addl %edx,%ebp
	movl %ebx,TileAddress_4
    movl %ebp,TileAddressY_4
	movl Tile_Offset_Table_16_8(,%eax,4),%ebx
    movl Tile_Offset_Table_16_8_Y(,%eax,4),%ebp
    addl %edx,%ebx
    addl %edx,%ebp
	movl %ebx,TileAddress_8
    movl %ebp,TileAddressY_8
.endm

.macro SORT_TILES_16x16 num
    // using: eax, ebx, edx, ebp
    // returns: esi
    movl HDMAYCount,%eax
    movl TileAddress\num,%edx
    addl VScrollData_\num,%eax
    movl %eax,%esi
    andl $0xF0,%esi
	andl $0x0F,%eax
    addl %esi,%esi
    addl %esi,%esi  // Get screen offset
	movl Tile_Offset_Table_16_2(,%eax,4),%ebx
    movl Tile_Offset_Table_16_2_Y(,%eax,4),%ebp
    addl %edx,%ebx
    addl %edx,%ebp
	movl %ebx,TileAddress_2
    movl %ebp,TileAddressY_2
	movl Tile_Offset_Table_16_4(,%eax,4),%ebx
    movl Tile_Offset_Table_16_4_Y(,%eax,4),%ebp
    addl %edx,%ebx
    addl %edx,%ebp
	movl %ebx,TileAddress_4
    movl %ebp,TileAddressY_4
	movl Tile_Offset_Table_16_8(,%eax,4),%ebx
    movl Tile_Offset_Table_16_8_Y(,%eax,4),%ebp
    addl %edx,%ebx
    addl %edx,%ebp
	movl %ebx,TileAddress_8
    movl %ebp,TileAddressY_8
.endm

.balign 16
NO_HDMA_PLANES:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
NO_HDMA_PLANES_S:
    ret

// v0.15 - Mode 0 has it's own renderer, %cl is palette offset for bkg layer

.macro RENDER_LINE_M0 planenum,bitnum

	pusha
    SORT_SCREEN_LAYOUT \planenum

    movb BGSIZE,%al
    testb $(1<<\bitnum),%al
    jnz 8f          // If set 16x16 tiles

    // 8x8 tiles
    SORT_TILES_8x8 \planenum    // This sets up the screen vert 2!

	movb HScrollData_\planenum,%al		/* Scroll Value */
    pushl $7f
    jmp RENDER_8x8_M0

    // 16x16 tiles
8:  SORT_TILES_16x16 \planenum  // This sets up the screen vert 2!

	movb HScrollData_\planenum,%al		/* Scroll Value */
    call RENDER_16x16_M0
7:
	popa			/* The following is a windows test, got to find a rom that works*/
/*  pusha
	movb WH0,%al
	movb WH1,%ah
	cmpb %al,%ah
    ja 8f

    movl $255,%ecx
7:
	cmpb %cl,%al
	jb 9f
	cmpb %cl,%ah
	ja 9f
    movb $0,(%edi,%ecx)
9:  decl %ecx
	jnz 7b
8:  popa*/
.endm

.macro RENDER_LINE planenum,depth,bitnum

	pusha
    SORT_SCREEN_LAYOUT \planenum

    movb BGSIZE,%al
    testb $(1<<\bitnum),%al
    jnz 8f          // If set 16x16 tiles

    // 8x8 tiles
    SORT_TILES_8x8 \planenum    // This sets up the screen vert 2!

	movb HScrollData_\planenum,%al		/* Scroll Value */
    pushl $7f
    jmp RENDER_8x8_C\depth

    // 16x16 tiles
8:  SORT_TILES_16x16 \planenum  // This sets up the screen vert 2!

	movb HScrollData_\planenum,%al		/* Scroll Value */
    call RENDER_16x16_C\depth
7:
	popa			/* The following is a windows test, got to find a rom that works*/
/*  pusha
	movb WH0,%al
	movb WH1,%ah
	cmpb %al,%ah
    ja 8f

    movl $255,%ecx
7:
	cmpb %cl,%al
	jb 9f
	cmpb %cl,%ah
	ja 9f
    movb $0,(%edi,%ecx)
9:  decl %ecx
	jnz 7b
8:  popa*/
.endm

/* V 0.15 - Modes 5 & 6 correctly supported ;-0 */

.macro RENDER_LINE_M5_M6 planenum,depth,bitnum

	pusha
    SORT_SCREEN_LAYOUT \planenum

    movb BGSIZE,%al
    testb $(1<<\bitnum),%al
    jnz 8f          // If set 16x16 tiles

    // 16x8 tiles
    SORT_TILES_16x8 \planenum    // This sets up the screen vert 2!

	movb HScrollData_\planenum,%al		/* Scroll Value */
    pushl $7f
    jmp RENDER_16x16_C\depth

    // 16x16 tiles
8:  SORT_TILES_16x16 \planenum  // This sets up the screen vert 2!

	movb HScrollData_\planenum,%al		/* Scroll Value */
    call RENDER_16x16_C\depth
7:
	popa			/* The following is a windows test, got to find a rom that works*/
/*  pusha
	movb WH0,%al
	movb WH1,%ah
	cmpb %al,%ah
    ja 8f

    movl $255,%ecx
7:
	cmpb %cl,%al
	jb 9f
	cmpb %cl,%ah
	ja 9f
    movb $0,(%edi,%ecx)
9:  decl %ecx
	jnz 7b
8:  popa*/
.endm

/* V 0.15 - New for rendering offset change mode (mode 2) ignores scrolling */

.macro RENDER_LINE_OFFSET_CHANGE_MODE planenum,depth,bitnum

	pusha
	movl TileAddress\planenum,%eax
	movl %eax,TileAddressM2
	movb $1<<((\planenum)-1+5),%ch
    movb BGSIZE,%al
    testb $(1<<\bitnum),%al
    jnz 8f          /* If set 16x16 tiles */

	movl ScreenAddress\planenum,%esi
	call RENDER_LINE_8x8_OFFSET_CHANGE
	jmp 7f
8:				/* 16x16 tiles */
/*
	addl ScreenAddressL,%esi
	call RENDER_LINE_16x16_OFFSET_CHANGE*/
7:
	popa
.endm

.balign 16
SCREEN_HDMA_MODE_0:		/* There are 15 Versions of Render & Merge functions (4 planes) */

    movb SCR_TM,%al     // Get BG status (on/off) for planes
    testb $0x10,%al     // Are sprites enabled?
    jz 0f

    andl $0x0F,%eax
    jmp Screen_HDMA_Mode_Table_0(,%eax,4)

0:  andl $0x0F,%eax
    jmp Screen_HDMA_Mode_Table_0_S(,%eax,4)

.balign 16
M0_HDMA_P1:
	ALL_SPRITES_PLANE_4
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
.balign 16
M0_HDMA_P1_S:
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
    ret
.balign 16
M0_HDMA_P2:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
.balign 16
M0_HDMA_P12:
	ALL_SPRITES_PLANE_4
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	ALL_SPRITES_PLANE_3
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
.balign 16
M0_HDMA_P12_S:
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
M0_HDMA_P2_S:
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
    ret
.balign 16
M0_HDMA_P3:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	ALL_SPRITES_PLANE_1
    ret
.balign 16
M0_HDMA_P13:
	ALL_SPRITES_PLANE_4
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	ALL_SPRITES_PLANE_1
    ret
.balign 16
M0_HDMA_P13_S:
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
    ret
.balign 16
M0_HDMA_P23:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	ALL_SPRITES_PLANE_2
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	ALL_SPRITES_PLANE_1
    ret
.balign 16
M0_HDMA_P123:
	ALL_SPRITES_PLANE_4
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	ALL_SPRITES_PLANE_3
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	ALL_SPRITES_PLANE_2
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	ALL_SPRITES_PLANE_1
    ret
.balign 16
M0_HDMA_P123_S:
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
M0_HDMA_P23_S:
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
M0_HDMA_P3_S:
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
    ret
.balign 16
M0_HDMA_P4:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P14:
	ALL_SPRITES_PLANE_4
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P14_S:
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P24:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P124:
	ALL_SPRITES_PLANE_4
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	ALL_SPRITES_PLANE_3
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P124_S:
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
M0_HDMA_P24_S:
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P34:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	ALL_SPRITES_PLANE_1
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P134:
	ALL_SPRITES_PLANE_4
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	ALL_SPRITES_PLANE_1
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P134_S:
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P234:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	ALL_SPRITES_PLANE_2
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	ALL_SPRITES_PLANE_1
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P1234:
	ALL_SPRITES_PLANE_4
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
	ALL_SPRITES_PLANE_3
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
	ALL_SPRITES_PLANE_2
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
	ALL_SPRITES_PLANE_1
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret
.balign 16
M0_HDMA_P1234_S:
    movb $0,%cl         // Palette offset for plane 0
    RENDER_LINE_M0 1,4
M0_HDMA_P234_S:
	movb $0x20,%cl		/* Palette offset for plane 1 */
    RENDER_LINE_M0 2,5
M0_HDMA_P34_S:
	movb $0x40,%cl		/* Palette offset for plane 2 */
    RENDER_LINE_M0 3,6
M0_HDMA_P4_S:
	movb $0x60,%cl		/* Palette offset for plane 3 */
    RENDER_LINE_M0 4,7
    ret

SCREEN_HDMA_MODE_1:		/* There are 7 Versions of Render & Merge functions (3 planes) */

    movb SCR_TM,%al     // Get BG status (on/off) for planes
    testb $0x10,%al     // Are sprites enabled?
    jz 0f

    andl $7,%eax
    movb BGSIZE,%bl
    testb $8,%bl
    jnz 1f

    jmp Screen_HDMA_Mode_Table_1(,%eax,4)
1:  jmp Screen_HDMA_Mode_Table_1_3(,%eax,4)

0:  andl $7,%eax
    testb $8,BGSIZE
    jnz 1f

    jmp Screen_HDMA_Mode_Table_1_S(,%eax,4)
1:  jmp Screen_HDMA_Mode_Table_1_3_S(,%eax,4)

M1_HDMA_P1:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P1_S:
	RENDER_LINE 1,4,4
    ret
M1_HDMA_P1_3:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P2:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P2_3:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P12:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P12_3:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P3:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P3_3:
	ALL_SPRITES_PLANE_4
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P13:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P13_S:
	RENDER_LINE 1,4,4
	RENDER_LINE 3,2,6
    ret
M1_HDMA_P13_3:
	ALL_SPRITES_PLANE_4
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P13_3_S:
	RENDER_LINE 3,2,6
	RENDER_LINE 1,4,4
    ret
M1_HDMA_P23:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P23_3:
	ALL_SPRITES_PLANE_4
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P23_3_S:
	RENDER_LINE 3,2,6
	RENDER_LINE 2,4,5
    ret
M1_HDMA_P123:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P123_S:
	RENDER_LINE 1,4,4
M1_HDMA_P23_S:
	RENDER_LINE 2,4,5
M1_HDMA_P3_S:
	RENDER_LINE 3,2,6
    ret
M1_HDMA_P123_3:
	ALL_SPRITES_PLANE_4
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
    RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_1
    ret
M1_HDMA_P123_3_S:
	RENDER_LINE 3,2,6
M1_HDMA_P12_S:
	RENDER_LINE 1,4,4
M1_HDMA_P2_S:
	RENDER_LINE 2,4,5
    ret

/* Mode 2 is a special snes mode - It is known as offset change mode, basically the snes has
  the ability to change the horizontal and/or vertical offset of each column on the screen, a
  pig to emulate but here is the information :

  BG0 & BG1 are 16 colour planes (this much was simple to find out)
  BG2 - This does not exist but its address in VRAM is very important!

  What happens is the horizontal and verticle information is written to BG3 address's
  BG2+0 -  BG2+63, this gives 128 bytes (since VRAM is a word addressed system).
  BG2+0 -  BG2+31 is the address for changing the horizontal value
  BG2+32 - BG2+63 is the address for changing the vertical value

  There are 32 values per BG mode since there are 32 tiles horizontally across the screen! My
  best guess is this value is immune to scrolling (otherwise it would make more sense to
  give a 64 tile range in case of extra width modes).

  Ok, the only other thing you need to know is what do the values at address BG2+x do.

  Well its the same for horiz as vertical the values are encoded as :

  00           | 01          | 02           | 03          |.......| 62            | 63
  col 0 offset | col 0 flags | col 1 offset | col 1 flags |.......| col 31 offset | col 31 flags

  The flags as far as I can tell are :

   bit 7 6 5 4 3 2 1 0
       ? y x ? ? ? ? ?		where	y = affect bg1
					x = affect bg0

    			The above information came from me Savoury SnaX
*/

SCREEN_HDMA_MODE_2:		/* There are 3 Versions of Render & Merge functions (2 planes) */

    movb SCR_TM,%al     // Get BG status (on/off) for planes
    testb $0x10,%al     // Are sprites enabled?
    jz 0f

    andl $3,%eax
    jmp Screen_HDMA_Mode_Table_2(,%eax,4)

0:  andl $3,%eax
    jmp Screen_HDMA_Mode_Table_2_S(,%eax,4)

M2_HDMA_P1:
	ALL_SPRITES_PLANE_4
	/* Specialist render function used (ignores scroll values eeek!) */
	RENDER_LINE_OFFSET_CHANGE_MODE 1,4,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M2_HDMA_P1_S:
	RENDER_LINE_OFFSET_CHANGE_MODE 1,4,4
    ret
M2_HDMA_P2:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE_OFFSET_CHANGE_MODE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M2_HDMA_P2_S:
	RENDER_LINE_OFFSET_CHANGE_MODE 2,4,5
    ret
M2_HDMA_P12:
	ALL_SPRITES_PLANE_4
	RENDER_LINE_OFFSET_CHANGE_MODE 1,4,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE_OFFSET_CHANGE_MODE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M2_HDMA_P12_S:
	RENDER_LINE_OFFSET_CHANGE_MODE 1,4,4
	RENDER_LINE_OFFSET_CHANGE_MODE 2,4,5
    ret

SCREEN_HDMA_MODE_3:	/* There are 3 Versions of Render & Merge functions (2 planes) */

    movb SCR_TM,%al     // Get BG status (on/off) for planes
    testb $0x10,%al     // Are sprites enabled?
    jz 0f

    andl $3,%eax
    jmp Screen_HDMA_Mode_Table_3(,%eax,4)

0:  andl $3,%eax
    jmp Screen_HDMA_Mode_Table_3_S(,%eax,4)

M3_HDMA_P1:
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,8,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M3_HDMA_P1_S:
	RENDER_LINE 1,8,4
    ret
M3_HDMA_P2:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M3_HDMA_P2_S:
	RENDER_LINE 2,4,5
    ret
M3_HDMA_P12:
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,8,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M3_HDMA_P12_S:
	RENDER_LINE 1,8,4
	RENDER_LINE 2,4,5
    ret

SCREEN_HDMA_MODE_4:		/* There are 3 Versions of Render & Merge functions (2 planes) */

    movb SCR_TM,%al     // Get BG status (on/off) for planes
    testb $0x10,%al     // Are sprites enabled?
    jz 0f

    andl $3,%eax
    jmp Screen_HDMA_Mode_Table_4(,%eax,4)

0:  andl $3,%eax
    jmp Screen_HDMA_Mode_Table_4_S(,%eax,4)

M4_HDMA_P1:
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,8,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M4_HDMA_P1_S:
	RENDER_LINE 1,8,4
    ret
M4_HDMA_P2:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M4_HDMA_P2_S:
	RENDER_LINE 2,2,5
    ret
M4_HDMA_P12:
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,8,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M4_HDMA_P12_S:
	RENDER_LINE 1,8,4
	RENDER_LINE 2,2,5
    ret

SCREEN_HDMA_MODE_5:		/* There are 3 Versions of Render & Merge functions (2 planes) */

    movb SCR_TM,%al     // Get BG status (on/off) for planes
    testb $0x10,%al     // Are sprites enabled?
    jz 0f

    andl $3,%eax
    jmp Screen_HDMA_Mode_Table_5(,%eax,4)

0:  andl $3,%eax
    jmp Screen_HDMA_Mode_Table_5_S(,%eax,4)

M5_HDMA_P1:
	ALL_SPRITES_PLANE_4
	RENDER_LINE_M5_M6 1,4,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M5_HDMA_P1_S:
	RENDER_LINE_M5_M6 1,4,4
    ret
M5_HDMA_P2:
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE_M5_M6 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M5_HDMA_P2_S:
	RENDER_LINE_M5_M6 2,2,5
    ret
M5_HDMA_P12:
	ALL_SPRITES_PLANE_4
	RENDER_LINE_M5_M6 1,4,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE_M5_M6 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M5_HDMA_P12_S:
	RENDER_LINE_M5_M6 1,4,4
	RENDER_LINE_M5_M6 2,2,5
    ret

SCREEN_HDMA_MODE_6:		/* There is 1 Versions of Render & Merge functions (1 planes) */

    movb SCR_TM,%al     // Get BG status (on/off) for planes
    testb $0x10,%al     // Are sprites enabled?
    jz 0f

    andl $1,%eax
    jmp Screen_HDMA_Mode_Table_6(,%eax,4)

0:  andl $1,%eax
    jmp Screen_HDMA_Mode_Table_6_S(,%eax,4)

M6_HDMA_P1:
	ALL_SPRITES_PLANE_4
	RENDER_LINE_M5_M6 1,4,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M6_HDMA_P1_S:
	RENDER_LINE_M5_M6 1,4,4
    ret

SCREEN_HDMA_MODE_7:		/* There is 1 Version of the render code ! */

    movb SCR_TM,%al     // Get BG status (on/off) for planes
    testb $0x10,%al     // Are sprites enabled?
    jz 0f

    andl $1,%eax
    jmp Screen_HDMA_Mode_Table_7(,%eax,4)

0:  andl $1,%eax
    jmp Screen_HDMA_Mode_Table_7_S(,%eax,4)

M7_HDMA_P1:
	ALL_SPRITES_PLANE_4
	call RENDER_MODE_7_FX
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
    ret
M7_HDMA_P1_S:
    call RENDER_MODE_7_FX
    ret

.data
.balign 16					/* Align to paragraph */

Copy_Screen_Table:
.long VGA_COPY,SQUASH,MODEX_COPY,MODEX_COPY
.long HICOLOUR0_COPY,HICOLOUR1_COPY,HICOLOUR2_COPY,STRETCH_COPY
.long MENTAL,MENTAL,MENTAL,MENTAL		/* MENTAL defined elsewhere.. its ELF shit! */
.long MENTAL,MENTAL,MENTAL,MENTAL

.balign 16
ScreenAddressL: .long   0   // Screen address of current left window
ScreenAddressR: .long   0   // Screen address of current right window
TileAddress:	.long	0
TileAddressY:	.long	0

.globl HDMAYCount           // Handled differently for IRQ
HDMAYCount:     .long   0
TileAddressM2:	.long	0
TileAddress_2:	.long	0
TileAddressY_2:	.long	0
TileAddress_4:	.long	0
TileAddressY_4:	.long	0
TileAddress_8:	.long	0
TileAddressY_8:	.long	0
.globl ScreenAddress1,ScreenAddressL1,ScreenAddressR1,TileAddress1
.globl ScreenAddress2,ScreenAddressL2,ScreenAddressR2,TileAddress2
.globl ScreenAddress3,ScreenAddressL3,ScreenAddressR3,TileAddress3
.globl ScreenAddress4,ScreenAddressL4,ScreenAddressR4,TileAddress4
.balign 16
ScreenAddress1: .long   0   // Screen address of BG1
ScreenAddressL1:.long   0   // Screen address of BG1 left window
ScreenAddressR1:.long   0   // Screen address of BG1 right window
TileAddress1:   .long   0   // Tileset address of BG1
ScreenAddress2: .long   0   // Screen address of BG2
ScreenAddressL2:.long   0   // Screen address of BG2 left window
ScreenAddressR2:.long   0   // Screen address of BG2 right window
TileAddress2:   .long   0   // Tileset address of BG2
ScreenAddress3: .long   0   // Screen address of BG3
ScreenAddressL3:.long   0   // Screen address of BG3 left window
ScreenAddressR3:.long   0   // Screen address of BG3 right window
TileAddress3:   .long   0   // Tileset address of BG3
ScreenAddress4: .long   0   // Screen address of BG4
ScreenAddressL4:.long   0   // Screen address of BG4 left window
ScreenAddressR4:.long   0   // Screen address of BG4 right window
TileAddress4:   .long   0   // Tileset address of BG4

.balign 16					/* Align to paragraph */
.globl BG1HScrollData,BG1VScrollData,_TBG1HScr,_TBG1VScr
.globl BG2HScrollData,BG2VScrollData,_TBG2HScr,_TBG2VScr
.globl BG3HScrollData,BG3VScrollData,_TBG3HScr,_TBG3VScr
.globl BG4HScrollData,BG4VScrollData,_TBG4HScr,_TBG4VScr
_TBG1HScr:
HScrollData_1:			/* Other name for easier macro writing */
BG1HScrollData:	.long	0
_TBG1VScr:
VScrollData_1:			/* Other name for easier macro writing */
BG1VScrollData:	.long	0
_TBG2HScr:
HScrollData_2:			/* Other name for easier macro writing */
BG2HScrollData:	.long	0
_TBG2VScr:
VScrollData_2:			/* Other name for easier macro writing */
BG2VScrollData:	.long	0
_TBG3HScr:
HScrollData_3:			/* Other name for easier macro writing */
BG3HScrollData:	.long	0
_TBG3VScr:
VScrollData_3:			/* Other name for easier macro writing */
BG3VScrollData:	.long	0
_TBG4HScr:
HScrollData_4:			/* Other name for easier macro writing */
BG4HScrollData:	.long	0
_TBG4VScr:
VScrollData_4:			/* Other name for easier macro writing */
BG4VScrollData:	.long	0

.balign 16
Tile_Offset_Table_8:
	.long	0
	.long	2
	.long	4
	.long	6
	.long	8
	.long	10
	.long	12
	.long	14

Tile_Offset_Table_8_Y:
	.long	14
	.long	12
	.long	10
	.long	8
	.long	6
	.long	4
	.long	2
	.long	0

Tile_Offset_Table_16_2:
	.long	0
	.long	2
	.long	4
	.long	6
	.long	8
	.long	10
	.long	12
	.long	14
	.long	16*8*2
	.long	16*8*2+2
	.long	16*8*2+4
	.long	16*8*2+6
	.long	16*8*2+8
	.long	16*8*2+10
	.long	16*8*2+12
	.long	16*8*2+14

Tile_Offset_Table_16_2_Y:
	.long	16*8*2+14
	.long	16*8*2+12
	.long	16*8*2+10
	.long	16*8*2+8
	.long	16*8*2+6
	.long	16*8*2+4
	.long	16*8*2+2
	.long	16*8*2
	.long	14
	.long	12
	.long	10
	.long	8
	.long	6
	.long	4
	.long	2
	.long	0

Tile_Offset_Table_16_4:
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

Tile_Offset_Table_16_4_Y:
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
	.long	0

Tile_Offset_Table_16_8:
	.long	0
	.long	2
	.long	4
	.long	6
	.long	8
	.long	10
	.long	12
	.long	14
	.long	16*8*8
	.long	16*8*8+2
	.long	16*8*8+4
	.long	16*8*8+6
	.long	16*8*8+8
	.long	16*8*8+10
	.long	16*8*8+12
	.long	16*8*8+14

Tile_Offset_Table_16_8_Y:
	.long	16*8*8+14
	.long	16*8*8+12
	.long	16*8*8+10
	.long	16*8*8+8
	.long	16*8*8+6
	.long	16*8*8+4
	.long	16*8*8+2
	.long	16*8*8
	.long	14
	.long	12
	.long	10
	.long	8
	.long	6
	.long	4
	.long	2
	.long	0

.globl BGMODE
BGMODE:     .long   SCREEN_HDMA_MODE_0  // Mode Renderer

.globl Screen_HDMA_Mode
Screen_HDMA_Mode:
	.long	SCREEN_HDMA_MODE_0
	.long	SCREEN_HDMA_MODE_1
	.long	SCREEN_HDMA_MODE_2
	.long	SCREEN_HDMA_MODE_3
	.long	SCREEN_HDMA_MODE_4
	.long	SCREEN_HDMA_MODE_5
	.long	SCREEN_HDMA_MODE_6
    .long   SCREEN_HDMA_MODE_7

Screen_HDMA_Mode_Table_0:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M0_HDMA_P1      // Plane 1
    .long   M0_HDMA_P2      // Plane 2
    .long   M0_HDMA_P12     // Planes 1,2
    .long   M0_HDMA_P3      // Plane 3
    .long   M0_HDMA_P13     // Planes 1,3
    .long   M0_HDMA_P23     // Planes 2,3
    .long   M0_HDMA_P123    // Planes 1,2,3
    .long   M0_HDMA_P4      // Plane 4
    .long   M0_HDMA_P14     // Planes 1,4
    .long   M0_HDMA_P24     // Planes 2,4
    .long   M0_HDMA_P124    // Planes 1,2,4
    .long   M0_HDMA_P34     // Planes 3,4
    .long   M0_HDMA_P134    // Planes 1,3,4
    .long   M0_HDMA_P234    // Planes 2,3,4
    .long   M0_HDMA_P1234   // Planes 1,2,3,4

Screen_HDMA_Mode_Table_1:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M1_HDMA_P1      // Plane 1
    .long   M1_HDMA_P2      // Plane 2
    .long   M1_HDMA_P12     // Planes 1,2
    .long   M1_HDMA_P3      // Plane 3
    .long   M1_HDMA_P13     // Planes 1,3
    .long   M1_HDMA_P23     // Planes 2,3
    .long   M1_HDMA_P123    // Planes 1,2,3

Screen_HDMA_Mode_Table_1_3:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M1_HDMA_P1_3    // Plane 1
    .long   M1_HDMA_P2_3    // Plane 2
    .long   M1_HDMA_P12_3   // Planes 1,2
    .long   M1_HDMA_P3_3    // Plane 3
    .long   M1_HDMA_P13_3   // Planes 1,3
    .long   M1_HDMA_P23_3   // Planes 2,3
    .long   M1_HDMA_P123_3  // Planes 1,2,3

Screen_HDMA_Mode_Table_2:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M2_HDMA_P1      // Plane 1
    .long   M2_HDMA_P2      // Plane 2
    .long   M2_HDMA_P12     // Planes 1,2

Screen_HDMA_Mode_Table_3:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M3_HDMA_P1      // Plane 1
    .long   M3_HDMA_P2      // Plane 2
    .long   M3_HDMA_P12     // Planes 1,2

Screen_HDMA_Mode_Table_4:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M4_HDMA_P1      // Plane 1
    .long   M4_HDMA_P2      // Plane 2
    .long   M4_HDMA_P12     // Planes 1,2

Screen_HDMA_Mode_Table_5:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M5_HDMA_P1      // Plane 1
    .long   M5_HDMA_P2      // Plane 2
    .long   M5_HDMA_P12     // Planes 1,2

Screen_HDMA_Mode_Table_6:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M6_HDMA_P1      // Plane 1 only

Screen_HDMA_Mode_Table_7:
    .long   NO_HDMA_PLANES  // This is the same for all modes
    .long   M7_HDMA_P1      // Plane 1

Screen_HDMA_Mode_Table_0_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M0_HDMA_P1_S        // Plane 1
    .long   M0_HDMA_P2_S        // Plane 2
    .long   M0_HDMA_P12_S       // Planes 1,2
    .long   M0_HDMA_P3_S        // Plane 3
    .long   M0_HDMA_P13_S       // Planes 1,3
    .long   M0_HDMA_P23_S       // Planes 2,3
    .long   M0_HDMA_P123_S      // Planes 1,2,3
    .long   M0_HDMA_P4_S        // Plane 4
    .long   M0_HDMA_P14_S       // Planes 1,4
    .long   M0_HDMA_P24_S       // Planes 2,4
    .long   M0_HDMA_P124_S      // Planes 1,2,4
    .long   M0_HDMA_P34_S       // Planes 3,4
    .long   M0_HDMA_P134_S      // Planes 1,3,4
    .long   M0_HDMA_P234_S      // Planes 2,3,4
    .long   M0_HDMA_P1234_S     // Planes 1,2,3,4

Screen_HDMA_Mode_Table_1_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M1_HDMA_P1_S        // Plane 1
    .long   M1_HDMA_P2_S        // Plane 2
    .long   M1_HDMA_P12_S       // Planes 1,2
    .long   M1_HDMA_P3_S        // Plane 3
    .long   M1_HDMA_P13_S       // Planes 1,3
    .long   M1_HDMA_P23_S       // Planes 2,3
    .long   M1_HDMA_P123_S      // Planes 1,2,3

Screen_HDMA_Mode_Table_1_3_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M1_HDMA_P1_S        // Plane 1
    .long   M1_HDMA_P2_S        // Plane 2
    .long   M1_HDMA_P12_S       // Planes 1,2
    .long   M1_HDMA_P3_S        // Plane 3
    .long   M1_HDMA_P13_3_S     // Planes 1,3
    .long   M1_HDMA_P23_3_S     // Planes 2,3
    .long   M1_HDMA_P123_3_S    // Planes 1,2,3

Screen_HDMA_Mode_Table_2_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M2_HDMA_P1_S        // Plane 1
    .long   M2_HDMA_P2_S        // Plane 2
    .long   M2_HDMA_P12_S       // Planes 1,2

Screen_HDMA_Mode_Table_3_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M3_HDMA_P1_S        // Plane 1
    .long   M3_HDMA_P2_S        // Plane 2
    .long   M3_HDMA_P12_S       // Planes 1,2

Screen_HDMA_Mode_Table_4_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M4_HDMA_P1_S        // Plane 1
    .long   M4_HDMA_P2_S        // Plane 2
    .long   M4_HDMA_P12_S       // Planes 1,2

Screen_HDMA_Mode_Table_5_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M5_HDMA_P1_S        // Plane 1
    .long   M5_HDMA_P2_S        // Plane 2
    .long   M5_HDMA_P12_S       // Planes 1,2

Screen_HDMA_Mode_Table_6_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M6_HDMA_P1_S        // Plane 1 only

Screen_HDMA_Mode_Table_7_S:
    .long   NO_HDMA_PLANES_S    // This is the same for all modes
    .long   M7_HDMA_P1_S        // Plane 1

.globl Mode7_A_P,Mode7_B,Mode7_C_P,Mode7_D
Mode7_A:	.long	0
Mode7_B:    .long   0
Mode7_C:	.long	0
Mode7_D:    .long   0
Mode7_A_P:  .long   0   // Partially precalculated
Mode7_C_P:  .long   0   // Partially precalculated

HScroll:	.byte	0
.globl SCR_TM
SCR_TM:		.byte	0			/* TM taken from here (TM&TM_MASK=SCR_TM) */
.globl Redo_M7
Redo_M7:    .byte   0x0F

//.text
//#include "irq.S"
