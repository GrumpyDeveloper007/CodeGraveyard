/*

 SCREEN Hicolour FUNCTIONS - New for Version 0.14

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

#include "TilesL.S"		/* Include all tile plotters */
#include "spriteL.S"
#include "hdma.S"

.macro	SETUP_SCREEN_ADDRESS addr,num
	movb \addr,%bl
	andl $0x000000FC,%ebx
	shll $9,%ebx			/* 1024 >> 2 << 1*/
	addl _VRamAddress,%ebx	
	movl %ebx,ScreenAddress\num
.endm

.macro	SETUP_TILE_LOW addr,num
	movb \addr,%bl
	andl $0x0000000F,%ebx
	shll $13,%ebx			/* 4096 << 1*/
	addl _VRamAddress,%ebx
	movl %ebx,TileAddress\num
.endm

.macro	SETUP_TILE_HIGH addr,num
	movb \addr,%bl
	andl $0x000000F0,%ebx
	shll $9,%ebx			/* 4096>>4 << 1*/
	addl _VRamAddress,%ebx
	movl %ebx,TileAddress\num
.endm

/* %esi is the screen address, works cos we only plot until wraparound! */
/* TileAddress contains the location for the snes tile data */
/*It is assumed that TileAddress is offset to the correct line for that row*/
/*Therefor TileAddressY is used in cases of flipping verticle! */
/* ch contains the X counter */
/* %edi is the address to draw to.. */


RENDER_LINE_8x8_C2:
	pusha
1:
	movw (%esi),%dx		/* Get tile information for screen pos */

	movl %edx,%eax
	addl $2,%esi		/* Update screen pointer */
	andl $0x000003FF,%eax	/* Get TileNum */
	shll $4,%eax			/* 2*8 */

	andl	$0x0000DC00,%edx	/* Get Plotver as     YX00 NNN0 0000 0000 */
	movl	%edx,%ebx
	shrl	$8,%edx
	movb	%dl,%dh
	andl	$0x00001C1C,%edx
	orw	%dx,ColourBase1

	shrl	$14,%ebx

	call	Tile_Line_8x8_2(,%ebx,4)
	movl	$0x08040201,ColourBase1

	addl	$8,%edi

	decb	%ch
	jnz	1b

	popa
	ret

RENDER_LINE_8x8_C4:

	pusha
1:
	movw	(%esi),%dx		/* Get Tile Information */

	movl %edx,%eax
	addl $2,%esi		/* Update screen pointer */
	andl $0x000003FF,%eax	/* Get TileNum */
	shll $5,%eax			/* 4*8 */

	andl	$0x0000DC00,%edx	/* Get Plotver as     YX00 NNN0 0000 0000 */
	movl	%edx,%ebx
	shrl	$6,%edx
	movb	%dl,%dh
	andl	$0x00007070,%edx
	orw	%dx,ColourBase1
	orw	%dx,ColourBase4

	shrl	$14,%ebx

	call	Tile_Line_8x8_4(,%ebx,4)
	movl	$0x08040201,ColourBase1

	addl	$8,%edi

	decb	%ch
	jnz	1b

	popa
	ret

RENDER_LINE_8x8_C8:

	pusha
1:
	movw	(%esi),%dx		/* Get Tile Information */

	movl %edx,%eax
	addl $2,%esi		/* Update screen pointer */
	andl $0x000003FF,%eax	/* Get TileNum */
	shll $6,%eax			/* 8*8 */

	andl	$0x0000C000,%edx	/* Get PlotVer */
	shrl	$14,%edx		/* Get bits sorted as 00YX */

	call	Tile_Line_8x8_8(,%edx,4)	/* got address of tile routine */

	addl	$8,%edi

	decb	%ch
	jnz	1b

	popa
	ret

RENDER_LINE_16x16_C2:
	pusha
	movl TileAddress_2,%eax
	movl TileAddressY_2,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY
1:
	movw (%esi),%dx		/* Get tile information for screen pos */

	movl %edx,%eax
	addl $2,%esi		/* Update screen pointer */
	andl $0x000003FF,%eax	/* Get TileNum */
	shll $4,%eax			/* 2*8 */

	andl	$0x0000DC00,%edx	/* Get Plotver as     YX00 NNN0 0000 0000 */
	movl	%edx,%ebx
	shrl	$8,%edx
	movb	%dl,%dh
	andl	$0x00001C1C,%edx
	orw	%dx,ColourBase1

	shrl	$14,%ebx

	call	Tile_Line_16x16_2(,%ebx,4)
	movl	$0x08040201,ColourBase1

	addl	$8,%edi

	decb	%ch
	jnz	1b

	popa
	ret

RENDER_LINE_16x16_C4:
	pusha
	movl TileAddress_4,%eax
	movl TileAddressY_4,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY
1:
	movw	(%esi),%dx		/* Get Tile Information */

	movl %edx,%eax
	addl $2,%esi		/* Update screen pointer */
	andl $0x000003FF,%eax	/* Get TileNum */
	shll $5,%eax			/* 4*8 */

	andl	$0x0000DC00,%edx	/* Get Plotver as     YX00 NNN0 0000 0000 */
	movl	%edx,%ebx
	shrl	$6,%edx
	movb	%dl,%dh
	andl	$0x00007070,%edx
	orw	%dx,ColourBase1
	orw	%dx,ColourBase4

	shrl	$14,%ebx

	call	Tile_Line_16x16_4(,%ebx,4)
	movl	$0x08040201,ColourBase1

	addl	$8,%edi

	decb	%ch
	jnz	1b

	popa
	ret

RENDER_LINE_16x16_C8:
	pusha
	movl TileAddress_8,%eax
	movl TileAddressY_8,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY
1:
	movw	(%esi),%dx		/* Get Tile Information */

	movl %edx,%eax
	addl $2,%esi		/* Update screen pointer */
	andl $0x000003FF,%eax	/* Get TileNum */
	shll $6,%eax			/* 8*8 */

	andl	$0x0000C000,%edx	/* Get PlotVer */
	shrl	$14,%edx		/* Get bits sorted as 00YX */

	call	Tile_Line_16x16_8(,%edx,4)	/* got address of tile routine */

	addl	$8,%edi

	decb	%ch
	jnz	1b

	popa
	ret

/* Y location to plot in %bx */

.macro	RENDER_MODE_7_FX_OLD

	pusha

	movw M7X_Data,%cx
	bt $12,%cx			/* Sign extend 13 bit data! */
	jnc 3f
	orw $0xF000,%cx
	jmp 4f
3:	andw $0x0FFF,%cx
4:
	movw M7Y_Data,%dx
	bt $12,%dx			/* Sign extend 13 bit data! */
	jnc 3f
	orw $0xF000,%dx
	jmp 4f
3:	andw $0x0FFF,%dx
4:
	movw %cx,Mode7_X
	movw %dx,Mode7_Y

	movw $0,%ax			/* X Location */
1:
/* Convert Screen X,Y location to SNES Pic location */

	pusha

	pushl %ebx
	pushl %eax

/* Matrix Test 1 */

	shlw $8,%ax			/* Make coord XX.XX format */
	shlw $8,%bx

	movw Mode7_X,%cx
	movw Mode7_Y,%dx

	subw %cx,%ax			/* X1-X0 */
	subw %dx,%bx			/* Y1-Y0 */

	pushw %cx
	pushw %dx
	pushw %ax
	movw M7A_Data,%dx
	imul %dx			/* Result in DX:AX */
	xchg %al,%ah
	movb %dl,%ah			/* Result in ax */
	movw %ax,%cx
	popw %ax
	movw M7C_Data,%dx
	imul %dx			/* Result in DX:AX */
	xchg %al,%ah
	movb %dl,%ah			/* Result in ax */
	addw %cx,%ax			/* Result in ax */
	pushw %ax
	movw %bx,%ax
	movw M7B_Data,%dx
	imul %dx			/* Result in DX:AX */
	xchg %al,%ah
	movb %dl,%ah			/* A*(X1-X0)+C*(X1-X0) Result in ax */
	movw %ax,%cx
	movw %bx,%ax
	movw M7D_Data,%dx
	imul %dx			/* Result in DX:AX */
	xchg %al,%ah
	movb %dl,%ah			/* Result in ax */
	movw %ax,%bx
	addw %cx,%bx			/* B*(Y1-Y0)+D*(Y1-Y0) Result in bx */
	popw %ax
	popw %dx
	popw %cx

	addw %cx,%ax
	addw %dx,%bx			/* ax,bx now setup! */

	shrl $8,%ax
	shrl $8,%bx

	popl %eax
	popl %ebx

	addw BG1HScrollData,%ax
	addw BG1VScrollData,%bx

	movw %ax,%cx
	movw %bx,%dx
	andl $0x0007,%ecx
	andl $0x0007,%edx	/* Get pixel shift within tile */
	shrw $3,%ax
	shrw $3,%bx		/* Get Tile Position (in 128 by 128 map) */
	andl $0x0000FFFF,%ebx
	shll $8,%ebx		/* *256 cos thats width of map */
	shlb $1,%al
	movb %al,%bl		/* Map offset now in %ebx */
	xorl %eax,%eax
	movb (%esi,%ebx),%al	/* Got Tile Number */
	
	shll $7,%eax			/* Make 64*2 offset to tile data */
	addl %esi,%eax
	incl %eax

	shll $1,%ecx
	addl %ecx,%eax			/* Add X offset */
	shll $4,%edx
	addl %edx,%eax			/* Add Y offset */

	movb (%eax),%bl
	cmpb $0,(%edi)
	jne 4f
	movb %bl,(%edi)
4:	incl %edi

	popa

	incw %ax
	incl %edi

	cmpw $256,%ax
	jne 1b

	popa
.endm

.macro	WIPE_SNES_SCREEN
	pusha

	movl _BKG,%edi
	movl $0,%ecx
	movl $((256+2*64)*(256+2*64))/4,%eax
0:					/* OuterLoop */
	movl %ecx,(%edi)
	addl $4,%edi

	decl %eax
	jnz 0b

	popa
.endm

/* Y location to plot in %bx */

Mode7_A:	.long	0
Mode7_B:	.long	0
Mode7_C:	.long	0
Mode7_D:	.long	0

RENDER_MODE_7_FX:		/* Its a function now too. This new one is based on a method suggested to me recently! */

	pusha

	pushl %ebx

	shlw $3,_M7X_DATA		/* This ensures values in -1024 to +1023 range */
	shlw $3,_M7Y_DATA
	shlw $3,BG1HScrollData
	shlw $3,BG1VScrollData
	sarw $3,_M7X_DATA
	sarw $3,_M7Y_DATA
	sarw $3,BG1HScrollData
	sarw $3,BG1VScrollData

	movswl BG1VScrollData,%ecx
	movswl _M7Y_DATA,%eax
	subl %eax,%ecx

	movswl _M7B_DATA,%ebx
	imul %ecx,%ebx
	movl %ebx,Mode7_B

	movswl _M7D_DATA,%ebx
	imul %ecx,%ebx
	movl %ebx,Mode7_D
	
	movswl BG1HScrollData,%ecx
	movswl _M7X_DATA,%eax
	subl %eax,%ecx

	movswl _M7C_DATA,%ebx
	imul %ecx,%ebx
	movl %ebx,Mode7_C

	movswl _M7A_DATA,%ebx
	imul %ecx,%ebx
	movl %ebx,Mode7_A

	movswl _M7X_DATA,%eax
	shll $8,%eax
	addl Mode7_B,%eax
	addl %eax,Mode7_A

	movswl _M7Y_DATA,%eax
	shll $8,%eax
	addl Mode7_D,%eax
	addl %eax,Mode7_C

	popl %ebx

	movswl _M7B_DATA,%edx
	imul %ebx,%edx
	addl %edx,Mode7_A

	movswl _M7D_DATA,%edx
	imul %ebx,%edx
	addl %edx,Mode7_C

/* Once we reach here the maths is done, now we determine which mode 7 to use */

	movb M7SEL,%al
	shrb $6,%al			/* Get repetition mode values in low part */
	cmpb $2,%al
	je M7_REPEAT			/* Screen repeats e.g. wrap x and y values - this is opposite of docs! */

	cmpb $1,%al
/*	je 1f*/				/* NOT SURE about this one... REMMed to prevent mode 7 disapearing */

	jmp M7_CLIP			/* Screen clipped e.g. no mode 7 data if x or y not in 0-1023 range! */

M7_REPEAT:
	movl Mode7_A,%eax
	movl Mode7_C,%ebx

	movl $256,%ebp			/* Horizontal Count */
1:

	pusha

	shrl $8,%eax
	shrl $8,%ebx
	andw $0x03FF,%ax
	andw $0x03FF,%bx

	cmpb $0,(%edi)		/* Check to see if pixel see through */
	jne 4f

/* Convert Screen X,Y location to SNES Pic location */

				/* Assumes %ax is X coord 0-1023, $bx is Y 0-1023 */
	movw %ax,%cx
	movw %bx,%dx
	andl $0x0007,%ecx
	andl $0x0007,%edx	/* Get pixel shift within tile */
	shrw $3,%ax
	shrw $3,%bx		/* Get Tile Position (in 128 by 128 map) */
	andl $0x0000FFFF,%ebx
	shll $8,%ebx		/* *256 cos thats width of map */
	shlb $1,%al
	movb %al,%bl		/* Map offset now in %ebx */
	xorl %eax,%eax
	movb (%esi,%ebx),%al	/* Got Tile Number */
	
	shll $7,%eax			/* Make 64*2 offset to tile data */
	addl %esi,%eax
	incl %eax

	shll $1,%ecx
	addl %ecx,%eax			/* Add X offset */
	shll $4,%edx
	addl %edx,%eax			/* Add Y offset */

	movb (%eax),%bl
/*	cmpb $0,(%edi)
	jne 4f*/
	movb %bl,(%edi)
4:	incl %edi

	popa

	movswl _M7A_DATA,%ecx
	movswl _M7C_DATA,%edx
	addl %ecx,%eax
	addl %edx,%ebx

	incl %edi

	decl %ebp
	jnz 1b

	popa
	ret

M7_CLIP:
	movl Mode7_A,%eax
	movl Mode7_C,%ebx

	movl $256,%ebp			/* Horizontal Count */
1:

	pusha

	shrl $8,%eax
	shrl $8,%ebx

	cmpb $0,(%edi)		/* Check to see if pixel see through */
	jne 4f

	cmpw $1023,%ax		/* If outside screen range we simply skip the pixel */
	ja 4f
	cmpw $1023,%bx
	ja 4f

/* Convert Screen X,Y location to SNES Pic location */

				/* Assumes %ax is X coord 0-1023, $bx is Y 0-1023 */
	movw %ax,%cx
	movw %bx,%dx
	andl $0x0007,%ecx
	andl $0x0007,%edx	/* Get pixel shift within tile */
	shrw $3,%ax
	shrw $3,%bx		/* Get Tile Position (in 128 by 128 map) */
	andl $0x0000FFFF,%ebx
	shll $8,%ebx		/* *256 cos thats width of map */
	shlb $1,%al
	movb %al,%bl		/* Map offset now in %ebx */
	xorl %eax,%eax
	movb (%esi,%ebx),%al	/* Got Tile Number */
	
	shll $7,%eax			/* Make 64*2 offset to tile data */
	addl %esi,%eax
	incl %eax

	shll $1,%ecx
	addl %ecx,%eax			/* Add X offset */
	shll $4,%edx
	addl %edx,%eax			/* Add Y offset */

	movb (%eax),%bl
/*	cmpb $0,(%edi)
	jne 4f*/
	movb %bl,(%edi)
4:	incl %edi

	popa

	movswl _M7A_DATA,%ecx
	movswl _M7C_DATA,%edx
	addl %ecx,%eax
	addl %edx,%ebx

	incl %edi

	decl %ebp
	jnz 1b

	popa
	ret

.macro	WIPE_SNES_SCREEN
	pusha

	movl _BKG,%edi
	movl $0,%ecx
	movl $((256+2*64)*(256+2*64))/4,%eax
0:					/* OuterLoop */
	movl %ecx,(%edi)
	addl $4,%edi

	decl %eax
	jnz 0b

	popa
.endm

.balign 16
.globl Clear_Screen
Clear_Screen:
	pusha

	movl _ScreenY,%eax
	movl _ScreenX,%edx
	shrl $2,%edx

	movl _SNES_Screen,%edi
	movl $0,%ecx
0:					/* OuterLoop */
	movl %edx,%ebx                                    
1:					/* InnerLoop */
	movl %ecx,(%edi)
	addl $4,%edi

	decl %ebx
	jnz 1b

	decl %eax
	jnz 0b

	popa
	ret

.balign 16
.globl Copy_Screen
Copy_Screen:
	pusha

	movb SETINI,%al
	btw $2,%ax		/* Is Field 224 or 240 in length? */
	jc 0f			/* 240 lines so skip long blanking routine */

	movl _BKG,%edi
	addl $64+(256+2*64)*(64+224),%edi

	movl $32,%edx
2:
	movl $(256/4),%ebx                                    
1:					/* InnerLoop */
	movl $0,(%edi)
	addl $4,%edi

	decl %ebx
	jnz 1b

	addl $128,%edi			/* Sixteen tile positions added to get to next row! */
	decl %edx
	jnz 2b
	jmp 3f

0:
	movl _BKG,%edi
	addl $64+(256+2*64)*(64+240),%edi

	movl $16,%edx
2:
	movl $(256/4),%ebx                                    
1:					/* InnerLoop */
	movl $0,(%edi)
	addl $4,%edi

	decl %ebx
	jnz 1b

	addl $128,%edi			/* Sixteen tile positions added to get to next row! */
	decl %edx
	jnz 2b
3:
	cmpw $1,_PC_SCREEN_MODE
	je SQUASH

	cmpw $4,_PC_SCREEN_MODE
	je HICOLOUR0_COPY

	cmpw $5,_PC_SCREEN_MODE
	je HICOLOUR1_COPY

	cmpw $6,_PC_SCREEN_MODE
	je HICOLOUR2_COPY

	cmpw $7,_PC_SCREEN_MODE
	je STRETCH_COPY

	movl _ScreenY,%eax
	movl _ScreenX,%edx
	subl $256,%edx

	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
0:					/* OuterLoop */
	movl $(256/4),%ebx                                    
1:					/* InnerLoop */
	movl (%esi),%ecx
	movl %ecx,(%edi)
	addl $4,%esi
	addl $4,%edi

	decl %ebx
	jnz 1b

	addl %edx,%edi
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */
	decl %eax
	jnz 0b

	popa
	ret

HICOLOUR0_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

/* 320x200 screen... */

	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl _HICOLOUR_Palette,%ecx
	xorl %eax,%eax

	movb $200,%dl
0:	xorb %dh,%dh		/* do 256 times */
1:
	movb (%esi),%al
	movw (%ecx,%eax,4),%ebx
	incl %esi
	movw %ebx,(%edi)
	addl $2,%edi

	decb %dh
	jnz 1b

	addl $(320-256)*2,%edi		/* Goto next line */
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */

	decb %dl
	jnz 0b	

	popa
	ret

HICOLOUR1_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

/* 320x240 screen... */

	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl _HICOLOUR_Palette,%ecx
	xorl %eax,%eax

	movb $240,%dl
0:	xorb %dh,%dh		/* do 256 times */
1:
	movb (%esi),%al
	movw (%ecx,%eax,4),%ebx
	incl %esi
	movw %ebx,(%edi)
	addl $2,%edi

	decb %dh
	jnz 1b

	addl $(320-256)*2,%edi		/* Goto next line */
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */

	decb %dl
	jnz 0b	

	popa
	ret

HICOLOUR2_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

/* 640x480 screen... 256*2 used 128 remains */

	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl _HICOLOUR_Palette,%ecx
	xorl %eax,%eax

	movb $240,%dl
0:	xorb %dh,%dh		/* do 256 times */
1:
	movb (%esi),%al
	movw (%ecx,%eax,4),%ebx
	incl %esi
	movw %ebx,(%edi)
	addl $2,%edi

	decb %dh
	jnz 1b

	addl $256*3,%edi		/* Goto next line */
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */

	decb %dl
	jnz 0b	

	popa
	ret

STRETCH_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

/* 640x480 screen... 256*2 used 128 remains */

	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl _HICOLOUR_Palette,%ecx
	xorl %eax,%eax

	movb $240,%dl
0:	xorb %dh,%dh		/* do 256 times */
1:
	movb (%esi),%al
	movl (%ecx,%eax,4),%ebx
	incl %esi
	movl %ebx,(%edi)
	addl $4,%edi
	movl %ebx,1276(%edi)

	decb %dh
	jnz 1b

	addl $128*2+(640*2),%edi	/* Goto next line */
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */

	decb %dl
	jnz 0b	

	popa
	ret

SQUASH:		/* This routine is specialised! 320x200 squash copy */
	movl _SNES_Screen,%edi
	movl _BKG,%esi
	addl $64+(256+2*64)*64,%esi	/* Offset to center of bkground! */
	movl $40,%eax
0:					/* OuterLoop */
	movl $5,%edx
2:
	movl $(256/4),%ebx                                    
1:					/* InnerLoop */
	movl (%esi),%ecx
	movl %ecx,(%edi)
	addl $4,%esi
	addl $4,%edi

	decl %ebx
	jnz 1b

	addl $(320-256),%edi
	addl $128,%esi			/* Sixteen tile positions added to get to next row! */
	decl %edx
	jnz 2b

	addl $(256+2*64),%esi		/* Skip a scan line */

	decl %eax
	jnz 0b

	popa
	ret

.globl UpdateSNESScreen
UpdateSNESScreen:		/* HDMA VERSION.. FAR MORE COMPLEX........... */

	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */

	RESTORE_HDMA_ADDRESS

/* HDMA Means we have to do almost all the checks every scanline.. slower but much better
  emulation once its done... */

/* NB: %edi is reserved as the destination screen pointer! */

	movl $0,FrameCount

	movl $0,HDMAYCount			/* Number of lines to update! */
	movl _BKG,%edi
	addl $64+(256+2*64)*64,%edi		/* Destination screen pointer */

HDMA_YLoopHere:

	/* UPDATE HDMA CALL HERE...  */

	do_HDMA

	SETUP_SCREEN_ADDRESS BG1SC,1
	SETUP_SCREEN_ADDRESS BG2SC,2
	SETUP_SCREEN_ADDRESS BG3SC,3
	SETUP_SCREEN_ADDRESS BG4SC,4
	SETUP_TILE_LOW BG12NBA,1
	SETUP_TILE_HIGH BG12NBA,2
	SETUP_TILE_LOW BG34NBA,3
	SETUP_TILE_HIGH BG34NBA,4

	movb TM_MASK,%al
	movb TM,%ah
	orb  TD,%ah		/* Thats why the screens were not there dale! */
	andb %ah,%al
	movb %al,SCR_TM

	movb INIDISP,%al
	cmpb $0,%al		/* Check for screen off */
	jns NO_CLEAR_LINE

	/* TO CLEAR A LINE WE SIMPLY FILL IT WITH COLOUR 0 for now! */

	movl $0,%eax
	movl $256/4,%ebx

CLEAR_LINE_LOOP:
	movl %eax,(%edi)
	addl $4,%edi
	decl %ebx
	jnz CLEAR_LINE_LOOP

	addl $128,%edi		/* Point screen to next line */
	incl HDMAYCount
	cmpl $256,HDMAYCount
	jne HDMA_YLoopHere

	call Copy_Screen
	ret

NO_CLEAR_LINE:
	movb BGMODE,%al
	andl $0x00000007,%eax

	jmp Screen_HDMA_Mode(,%eax,4)	/* got address of screen mode routines */

LINE_END:

	incl HDMAYCount
	cmpl $256,HDMAYCount
	jne HDMA_YLoopHere

	call Copy_Screen

	ret

.macro SORT_LAYOUT_8x8 num
	movl HDMAYCount,%esi
	addl VScrollData_\num,%esi
	andl $0x000000FF,%esi
	movl %esi,%eax
	shrl $3,%esi
	andl $0x07,%eax
	shll $6,%esi	/* <<6 to get screen offset (assumes 8x8) */
	movl Tile_Offset_Table_8_Y(,%eax,4),%ebx
	movl Tile_Offset_Table_8(,%eax,4),%eax
	addl TileAddress\num,%eax
	addl TileAddress\num,%ebx
	movl %eax,TileAddress
	movl %ebx,TileAddressY

	movb BGSC\num,%al
	andb $3,%al
	cmpb $0,%al
	je 0f
	cmpb $1,%al
	je 1f
	cmpb $2,%al
	je 2f
3:
	movl VScrollData_\num,%eax
	addl HDMAYCount,%eax
	btw $8,%ax
	jc 4f			/* If set do top */

	movl HScrollData_\num,%eax
	btw $8,%ax		/* If set do Right screen then left */
	jc 3f
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressL
	addl $32*32*2,%eax
	movl %eax,ScreenAddressR
	jmp 9f
3:
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressR
	addl $32*32*2,%eax
	movl %eax,ScreenAddressL
	jmp 9f

4:
	movl HScrollData_\num,%eax
	btw $8,%ax		/* If set do Right screen then left */
	jc 3f
	movl ScreenAddress\num,%eax
	addl $32*32*2*2,%eax
	movl %eax,ScreenAddressL
	addl $32*32*2,%eax
	movl %eax,ScreenAddressR
	jmp 9f
3:
	movl ScreenAddress\num,%eax
	addl $32*32*2*2,%eax
	movl %eax,ScreenAddressR
	addl $32*32*2,%eax
	movl %eax,ScreenAddressL
	jmp 9f
0:
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressL
	movl %eax,ScreenAddressR
	jmp 9f
1:
	movl HScrollData_\num,%eax
	btw $8,%ax		/* If set do Right screen then left */
	jc 1f
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressL
	addl $32*32*2,%eax
	movl %eax,ScreenAddressR
	jmp 9f
1:
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressR
	addl $32*32*2,%eax
	movl %eax,ScreenAddressL
	jmp 9f
2:
	movl VScrollData_\num,%eax
	addl HDMAYCount,%eax
	btw $8,%ax
	jc 2f			/* If set do top */
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressL
	movl %eax,ScreenAddressR
	jmp 9f
2:
	movl ScreenAddress\num,%eax
	addl $32*32*2,%eax
	movl %eax,ScreenAddressL
	movl %eax,ScreenAddressR
	jmp 9f
9:
.endm

.macro SORT_LAYOUT_16x16 num
	movl HDMAYCount,%esi
	addl VScrollData_\num,%esi
	andl $0x000000FF,%esi
	movl %esi,%eax
	shrl $4,%esi
	andl $0x0F,%eax
	shll $6,%esi	/* <<6 to get screen offset (assumes 8x8) */
	movl Tile_Offset_Table_16_2(,%eax,4),%ebx
	movl Tile_Offset_Table_16_2_Y(,%eax,4),%ecx
	addl TileAddress\num,%ebx
	addl TileAddress\num,%ecx
	movl %ebx,TileAddress_2
	movl %ecx,TileAddressY_2
	movl Tile_Offset_Table_16_4(,%eax,4),%ebx
	movl Tile_Offset_Table_16_4_Y(,%eax,4),%ecx
	addl TileAddress\num,%ebx
	addl TileAddress\num,%ecx
	movl %ebx,TileAddress_4
	movl %ecx,TileAddressY_4
	movl Tile_Offset_Table_16_8(,%eax,4),%ebx
	movl Tile_Offset_Table_16_8_Y(,%eax,4),%ecx
	addl TileAddress\num,%ebx
	addl TileAddress\num,%ecx
	movl %ebx,TileAddress_8
	movl %ecx,TileAddressY_8

	movb BGSC\num,%al
	andb $3,%al
	cmpb $0,%al
	je 0f
	cmpb $1,%al
	je 1f
	cmpb $2,%al
	je 2f
3:
	movl VScrollData_\num,%eax
	addl HDMAYCount,%eax
	btw $8,%ax
	jc 4f			/* If set do top */

	movl HScrollData_\num,%eax
	btw $8,%ax		/* If set do Right screen then left */
	jc 3f
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressL
	addl $32*32*2,%eax
	movl %eax,ScreenAddressR
	jmp 9f
3:
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressR
	addl $32*32*2,%eax
	movl %eax,ScreenAddressL
	jmp 9f

4:
	movl HScrollData_\num,%eax
	btw $8,%ax		/* If set do Right screen then left */
	jc 3f
	movl ScreenAddress\num,%eax
	addl $32*32*2*2,%eax
	movl %eax,ScreenAddressL
	addl $32*32*2,%eax
	movl %eax,ScreenAddressR
	jmp 9f
3:
	movl ScreenAddress\num,%eax
	addl $32*32*2*2,%eax
	movl %eax,ScreenAddressR
	addl $32*32*2,%eax
	movl %eax,ScreenAddressL
	jmp 9f
0:
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressL
	movl %eax,ScreenAddressR
	jmp 9f
1:
	movl HScrollData_\num,%eax
	btw $8,%ax		/* If set do Right screen then left */
	jc 1f
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressL
	addl $32*32*2,%eax
	movl %eax,ScreenAddressR
	jmp 9f
1:
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressR
	addl $32*32*2,%eax
	movl %eax,ScreenAddressL
	jmp 9f
2:
	movl VScrollData_\num,%eax
	addl HDMAYCount,%eax
	btw $8,%ax
	jc 2f			/* If set do top */
	movl ScreenAddress\num,%eax
	movl %eax,ScreenAddressL
	movl %eax,ScreenAddressR
	jmp 9f
2:
	movl ScreenAddress\num,%eax
	addl $32*32*2,%eax
	movl %eax,ScreenAddressL
	movl %eax,ScreenAddressR
	jmp 9f
9:
.endm

NO_HDMA_PLANES:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc NO_HDMA_PLANES_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
NO_HDMA_PLANES_S:
	addl $256+128,%edi		/* Point screen to next line */
	jmp LINE_END

.macro RENDER_LINE planenum,depth,bitnum

	movb BGMODE,%al
	btw $\bitnum,%ax
	jc 8f			/* If set 16x16 tiles */

	SORT_LAYOUT_8x8 \planenum		/* This sets up the screen vert 2! */

	cmpb $0,HScrollData_\planenum	/* If 0 simply plot 32 tiles! */
	je 0f

	pushl %edi
	xorl %eax,%eax
	xorl %edx,%edx
	movb HScrollData_\planenum,%al		/* Scroll Value */
	movb %al,%bl
	andb $0x07,%al		/* Amount to subtract from edi */
	andb $0xF8,%bl
	subl %eax,%edi
	movb $255,%dl
	subb %bl,%dl
	incw %dx
	shrw $3,%dx
	movb %dl,%ch
	movb $32,%dl
	subb %ch,%dl
	pushl %esi
	addl ScreenAddressL,%esi
	addl %edx,%esi
	addl %edx,%esi
	call RENDER_LINE_8x8_C\depth
	xorl %edx,%edx
	popl %esi
	movb %ch,%dl
	shlw $3,%dx
	addl %edx,%edi
	movb $33,%dl
	addl ScreenAddressR,%esi
	subb %ch,%dl
	movb %dl,%ch
	call RENDER_LINE_8x8_C\depth
	popl %edi
	jmp 7f
0:
	addl ScreenAddressL,%esi
	movb $32,%ch
	call RENDER_LINE_8x8_C\depth
	jmp 7f
8:			/* 16x16 tiles */
	SORT_LAYOUT_16x16 \planenum		/* This sets up the screen vert 2! */

	cmpb $0,HScrollData_\planenum	/* If 0 simply plot 32 tiles! */
	je 0f

	pushl %edi
	xorl %eax,%eax
	xorl %edx,%edx
	movb HScrollData_\planenum,%al		/* Scroll Value */
	movb %al,%bl
	andb $0x0F,%al		/* Amount to subtract from edi */
	andb $0xF0,%bl
	subl %eax,%edi
	movb $255,%dl
	subb %bl,%dl
	incw %dx
	shrw $4,%dx
	movb %dl,%ch
	movb $16,%dl
	subb %ch,%dl
	pushl %esi
	addl ScreenAddressL,%esi
	addl %edx,%esi
	addl %edx,%esi
	call RENDER_LINE_16x16_C\depth
	xorl %edx,%edx
	popl %esi
	movb %ch,%dl
	shlw $4,%dx
	addl %edx,%edi
	movb $17,%dl
	addl ScreenAddressR,%esi
	subb %ch,%dl
	movb %dl,%ch
	call RENDER_LINE_16x16_C\depth
	popl %edi
	jmp 7f
0:
	addl ScreenAddressL,%esi
	movb $16,%ch
	call RENDER_LINE_16x16_C\depth
7:
.endm

SCREEN_HDMA_MODE_0:		/* There are 15 Versions of Render & Merge functions (4 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x0000000F,%eax

	movl Screen_HDMA_Mode_Table_0(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M0_HDMA_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P1_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,2,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P1_S:
	cli
	RENDER_LINE 1,2,4
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P2_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P2_S:
	cli
	RENDER_LINE 2,2,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P12_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,2,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P12_S:
	cli
	RENDER_LINE 1,2,4
	RENDER_LINE 2,2,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P3_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P3_S:
	cli
	RENDER_LINE 3,2,6
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P13:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P13_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,2,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P13_S:
	cli
	RENDER_LINE 1,2,4
	RENDER_LINE 3,2,6
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P23:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P23_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P23_S:
	cli
	RENDER_LINE 2,2,5
	RENDER_LINE 3,2,6
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P123:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P123_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,2,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P123_S:
	cli
	RENDER_LINE 1,2,4
	RENDER_LINE 2,2,5
	RENDER_LINE 3,2,6
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P4:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P4_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P4_S:
	cli
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P14:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P14_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,2,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P14_S:
	cli
	RENDER_LINE 1,2,4
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P24:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P24_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P24_S:
	cli
	RENDER_LINE 2,2,5
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P124:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P124_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,2,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P124_S:
	cli
	RENDER_LINE 1,2,4
	RENDER_LINE 2,2,5
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P34:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P34_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P34_S:
	cli
	RENDER_LINE 3,2,6
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P134:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P134_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,2,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P134_S:
	cli
	RENDER_LINE 1,2,4
	RENDER_LINE 3,2,6
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P234:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P234_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P234_S:
	cli
	RENDER_LINE 2,2,5
	RENDER_LINE 3,2,6
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P1234:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_HDMA_P1234_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,2,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END
M0_HDMA_P1234_S:
	cli
	RENDER_LINE 1,2,4
	RENDER_LINE 2,2,5
	RENDER_LINE 3,2,6
	RENDER_LINE 4,2,7
	addl $256+128,%edi
	sti
	jmp LINE_END

SCREEN_HDMA_MODE_1:		/* There are 7 Versions of Render & Merge functions (3 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000007,%eax

	movl Screen_HDMA_Mode_Table_1(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M1_HDMA_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P1_S
	btw $3,BGMODE
        jc M1_HDMA_P1_3
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P1_S:
	cli
	RENDER_LINE 1,4,4
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P1_3:
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P2_S
	btw $3,BGMODE
        jc M1_HDMA_P2_3
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P2_S:
	cli
	RENDER_LINE 2,4,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P2_3:
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P12_S
	btw $3,BGMODE
        jc M1_HDMA_P12_3
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P12_S:
	cli
	RENDER_LINE 1,4,4
	RENDER_LINE 2,4,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P12_3:
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P3_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P3_S:
	cli
	RENDER_LINE 3,2,6
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P13:
	btw $3,BGMODE
        jc M1_HDMA_P13_3
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P13_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P13_S:
	cli
	RENDER_LINE 1,4,4
	RENDER_LINE 3,2,6
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P13_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P13_3_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P13_3_S:
	cli
	RENDER_LINE 3,2,6
	RENDER_LINE 1,4,4
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P23:
	btw $3,BGMODE
        jc M1_HDMA_P23_3
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P23_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P23_S:
	cli
	RENDER_LINE 2,4,5
	RENDER_LINE 3,2,6
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P23_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P23_3_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P23_3_S:
	cli
	RENDER_LINE 3,2,6
	RENDER_LINE 2,4,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P123:
	btw $3,BGMODE
        jc M1_HDMA_P123_3
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P123_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P123_S:
	cli
	RENDER_LINE 1,4,4
	RENDER_LINE 2,4,5
	RENDER_LINE 3,2,6
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P123_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_HDMA_P123_3_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 3,2,6
	ALL_SPRITES_PLANE_3
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_2
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M1_HDMA_P123_3_S:
	cli
	RENDER_LINE 3,2,6
	RENDER_LINE 1,4,4
	RENDER_LINE 2,4,5
	addl $256+128,%edi
	sti
	jmp LINE_END

SCREEN_HDMA_MODE_2:		/* There are 3 Versions of Render & Merge functions (2 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000003,%eax

	movl Screen_HDMA_Mode_Table_2(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M2_HDMA_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M2_HDMA_P1_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M2_HDMA_P1_S:
	cli
	RENDER_LINE 1,4,4
	addl $256+128,%edi
	sti
	jmp LINE_END
M2_HDMA_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M2_HDMA_P2_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M2_HDMA_P2_S:
	cli
	RENDER_LINE 2,4,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M2_HDMA_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M2_HDMA_P12_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M2_HDMA_P12_S:
	cli
	RENDER_LINE 1,4,4
	RENDER_LINE 2,4,5
	addl $256+128,%edi
	sti
	jmp LINE_END

SCREEN_HDMA_MODE_3:	/* There are 3 Versions of Render & Merge functions (2 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000003,%eax

	movl Screen_HDMA_Mode_Table_3(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M3_HDMA_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M3_HDMA_P1_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,8,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M3_HDMA_P1_S:
	cli
	RENDER_LINE 1,8,4
	addl $256+128,%edi
	sti
	jmp LINE_END
M3_HDMA_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M3_HDMA_P2_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M3_HDMA_P2_S:
	cli
	RENDER_LINE 2,4,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M3_HDMA_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M3_HDMA_P12_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,8,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,4,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M3_HDMA_P12_S:
	cli
	RENDER_LINE 1,8,4
	RENDER_LINE 2,4,5
	addl $256+128,%edi
	sti
	jmp LINE_END

SCREEN_HDMA_MODE_4:		/* There are 3 Versions of Render & Merge functions (2 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000003,%eax

	movl Screen_HDMA_Mode_Table_4(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M4_HDMA_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M4_HDMA_P1_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,8,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M4_HDMA_P1_S:
	cli
	RENDER_LINE 1,8,4
	addl $256+128,%edi
	sti
	jmp LINE_END
M4_HDMA_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M4_HDMA_P2_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M4_HDMA_P2_S:
	cli
	RENDER_LINE 2,2,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M4_HDMA_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M4_HDMA_P12_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,8,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M4_HDMA_P12_S:
	cli
	RENDER_LINE 1,8,4
	RENDER_LINE 2,2,5
	addl $256+128,%edi
	sti
	jmp LINE_END

SCREEN_HDMA_MODE_5:		/* There are 3 Versions of Render & Merge functions (2 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000003,%eax

	movl Screen_HDMA_Mode_Table_5(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M5_HDMA_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M5_HDMA_P1_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M5_HDMA_P1_S:
	cli
	RENDER_LINE 1,4,4
	addl $256+128,%edi
	sti
	jmp LINE_END
M5_HDMA_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M5_HDMA_P2_S
	cli
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M5_HDMA_P2_S:
	cli
	RENDER_LINE 2,2,5
	addl $256+128,%edi
	sti
	jmp LINE_END
M5_HDMA_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M5_HDMA_P12_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	RENDER_LINE 2,2,5
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M5_HDMA_P12_S:
	cli
	RENDER_LINE 1,4,4
	RENDER_LINE 2,2,5
	addl $256+128,%edi
	sti
	jmp LINE_END

SCREEN_HDMA_MODE_6:		/* There is 1 Versions of Render & Merge functions (1 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000001,%eax

	movl Screen_HDMA_Mode_Table_6(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M6_HDMA_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M6_HDMA_P1_S
	cli
	ALL_SPRITES_PLANE_4
	RENDER_LINE 1,4,4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M6_HDMA_P1_S:
	cli
	RENDER_LINE 1,4,4
	addl $256+128,%edi
	sti
	jmp LINE_END

SCREEN_HDMA_MODE_7:		/* There is 1 Version of the render code ! */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000001,%eax

	movl Screen_HDMA_Mode_Table_7(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M7_HDMA_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M7_HDMA_P1_S
	cli
	ALL_SPRITES_PLANE_4
	movl HDMAYCount,%ebx
	movl _VRamAddress,%esi
	call RENDER_MODE_7_FX
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	addl $256+128,%edi
	sti
	jmp LINE_END
M7_HDMA_P1_S:
	cli
	movl HDMAYCount,%ebx
	movl _VRamAddress,%esi
        call RENDER_MODE_7_FX
	sti
	addl $256+128,%edi
	jmp LINE_END

.data
.balign 16					/* Align to paragraph */

HDMA_Ptr_0:	.long	0	/* These point to the table in use .... */
HDMA_Ptr_1:	.long	0	/* They are restored every screen redraw */
HDMA_Ptr_2:	.long	0
HDMA_Ptr_3:	.long	0
HDMA_Ptr_4:	.long	0
HDMA_Ptr_5:	.long	0
HDMA_Ptr_6:	.long	0
HDMA_Ptr_7:	.long	0
HDMA_Vid_0:	.long	0
HDMA_Vid_1:	.long	0
HDMA_Vid_2:	.long	0
HDMA_Vid_3:	.long	0
HDMA_Vid_4:	.long	0
HDMA_Vid_5:	.long	0
HDMA_Vid_6:	.long	0
HDMA_Vid_7:	.long	0
HDMA_Cnt_0:	.long	0		/* These hold the count info... used differently from V0.13 onwards */
HDMA_Cnt_1:	.long	0
HDMA_Cnt_2:	.long	0
HDMA_Cnt_3:	.long	0
HDMA_Cnt_4:	.long	0
HDMA_Cnt_5:	.long	0
HDMA_Cnt_6:	.long	0
HDMA_Cnt_7:	.long	0
HDMA_Add_0:	.long	0		/* These hold the add info for implementing continue mode new for v0.13 */
HDMA_Add_1:	.long	0
HDMA_Add_2:	.long	0
HDMA_Add_3:	.long	0
HDMA_Add_4:	.long	0
HDMA_Add_5:	.long	0
HDMA_Add_6:	.long	0
HDMA_Add_7:	.long	0
HDMAYCount:	.long	0
TileAddress:	.long	0
TileAddressY:	.long	0
TileAddress_2:	.long	0
TileAddressY_2:	.long	0
TileAddress_4:	.long	0
TileAddressY_4:	.long	0
TileAddress_8:	.long	0
TileAddressY_8:	.long	0
ScreenAddressL:	.long	0	/* Screen address of left window */
ScreenAddressR:	.long	0	/* Screen address of right window */
ScreenAddress1:	.long	0
TileAddress1:	.long	0
ScreenAddress2:	.long	0
TileAddress2:	.long	0
ScreenAddress3:	.long	0
TileAddress3:	.long	0
ScreenAddress4:	.long	0
TileAddress4:	.long	0

HScroll:	.byte	0
SCR_TM:		.byte	0			/* TM taken from here (TM&TM_MASK=SCR_TM) */

.balign 16					/* Align to paragraph */
.globl BG1HScrollData
HScrollData_1:			/* Other name for easier macro writing */
BG1HScrollData:	.long	0
.globl BG1VScrollData
VScrollData_1:			/* Other name for easier macro writing */
BG1VScrollData:	.long	0
.globl BG2HScrollData
HScrollData_2:			/* Other name for easier macro writing */
BG2HScrollData:	.long	0
.globl BG2VScrollData
VScrollData_2:			/* Other name for easier macro writing */
BG2VScrollData:	.long	0
.globl BG3HScrollData
HScrollData_3:			/* Other name for easier macro writing */
BG3HScrollData:	.long	0
.globl BG3VScrollData
VScrollData_3:			/* Other name for easier macro writing */
BG3VScrollData:	.long	0
.globl BG4HScrollData
HScrollData_4:			/* Other name for easier macro writing */
BG4HScrollData:	.long	0
.globl BG4VScrollData
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

.balign 16
Tile_Offset_Table_8_Y:
	.long	14
	.long	12
	.long	10
	.long	8
	.long	6
	.long	4
	.long	2
	.long	0

.balign 16
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

.balign 16
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

.balign 16
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

.balign 16
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

.balign 16
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

.balign 16
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

.balign 16					/* Align to paragraph */

Screen_HDMA_Mode:
	.long	SCREEN_HDMA_MODE_0
	.long	SCREEN_HDMA_MODE_1
	.long	SCREEN_HDMA_MODE_2
	.long	SCREEN_HDMA_MODE_3
	.long	SCREEN_HDMA_MODE_4
	.long	SCREEN_HDMA_MODE_5
	.long	SCREEN_HDMA_MODE_6
	.long	SCREEN_HDMA_MODE_7			/* Early version, no FX */


Screen_HDMA_Mode_Table_0:
	.long	NO_HDMA_PLANES		/* No Planes but sprites maybe? */
	.long	M0_HDMA_P1		/* Plane 1 only */
	.long	M0_HDMA_P2		/* Plane 2 only */
	.long	M0_HDMA_P12		/* Planes 1&2 only */
	.long	M0_HDMA_P3		/* Plane 3 only */
	.long	M0_HDMA_P13		/* Planes 1&3 only */
	.long	M0_HDMA_P23		/* Planes 2&3 only */
	.long	M0_HDMA_P123		/* Planes 1&2&3 only */
	.long	M0_HDMA_P4		/* Plane 4 only */
	.long	M0_HDMA_P14		/* Planes 1&4 only */
	.long	M0_HDMA_P24		/* Planes 2&4 only */
	.long	M0_HDMA_P124		/* Planes 1&2&4 only */
	.long	M0_HDMA_P34		/* Planes 3&4 only */
	.long	M0_HDMA_P134		/* Planes 1&3&4 only */
	.long	M0_HDMA_P234		/* Planes 2&3&4 only */
	.long	M0_HDMA_P1234		/* Planes 1&2&3&4 */

Screen_HDMA_Mode_Table_1:
	.long	NO_HDMA_PLANES		/* This is the same for all modes */
	.long	M1_HDMA_P1		/* Plane 1 only */
	.long	M1_HDMA_P2		/* Plane 2 only */
	.long	M1_HDMA_P12		/* Planes 1&2 only */
	.long	M1_HDMA_P3		/* Plane 3 only */
	.long	M1_HDMA_P13		/* Planes 1&3 only */
	.long	M1_HDMA_P23		/* Planes 2&3 only */
	.long	M1_HDMA_P123		/* Planes 1&2&3 */

Screen_HDMA_Mode_Table_2:
	.long	NO_HDMA_PLANES		/* This is the same for all modes */
	.long	M2_HDMA_P1		/* Plane 1 only */
	.long	M2_HDMA_P2		/* Plane 2 only */
	.long	M2_HDMA_P12		/* Planes 1&2 only */

Screen_HDMA_Mode_Table_3:
	.long	NO_HDMA_PLANES		/* This is the same for all modes */
	.long	M3_HDMA_P1		/* Plane 1 only */
	.long	M3_HDMA_P2		/* Plane 2 only */
	.long	M3_HDMA_P12		/* Planes 1&2 only */

Screen_HDMA_Mode_Table_4:
	.long	NO_HDMA_PLANES		/* This is the same for all modes */
	.long	M4_HDMA_P1		/* Plane 1 only */
	.long	M4_HDMA_P2		/* Plane 2 only */
	.long	M4_HDMA_P12		/* Planes 1&2 only */

Screen_HDMA_Mode_Table_5:
	.long	NO_HDMA_PLANES		/* This is the same for all modes */
	.long	M5_HDMA_P1		/* Plane 1 only */
	.long	M5_HDMA_P2		/* Plane 2 only */
	.long	M5_HDMA_P12		/* Planes 1&2 only */

Screen_HDMA_Mode_Table_6:
	.long	NO_HDMA_PLANES		/* This is the same for all modes */
	.long	M6_HDMA_P1		/* Plane 1 only */

Screen_HDMA_Mode_Table_7:
	.long	NO_HDMA_PLANES		/* This is the same for all modes */
	.long	M7_HDMA_P1		/* Plane 1 only */

