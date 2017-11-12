/*

 Screen Functions / Macros / Hardware Mappings for SNES - In Assembler cos everything else is!


 Screen Version 3.0 - Aarrrg not again.

  Minor change, now I use dales tile plotters because they take up less memory so I can add a
 new set of plotter to all for overlay effects (screen add/sub).

*/

.macro	DUPLICATE vartype, amount, data, from=1		/* Why does this need to be 1 ? */
.\vartype \data
.if \amount-\from
DUPLICATE \vartype,\amount,\data,"(\from+1)"
.endif
.endm

#include "Tiles.S"		/* Include all tile plotters, 8x8,16x16 X flipped etc.... */
#include "sprite.S"		/* Include all sprite code */

.macro	SET_SCREEN_ADDRESS addr

	movb \addr,%bl
	andl $0x000000FC,%ebx
	shll $9,%ebx			/* 1024 >> 2 << 1*/
	addl _VRamAddress,%ebx	
	movl %ebx,ScreenAddress
.endm

.macro	SET_TILE_LOW addr

	movb \addr,%bl
	andl $0x0000000F,%ebx
	shll $13,%ebx			/* 4096 << 1*/
	addl _VRamAddress,%ebx
	movl %ebx,TileAddress
.endm

.macro	SET_TILE_HIGH addr

	movb \addr,%bl
	andl $0x000000F0,%ebx
	shll $9,%ebx			/* 4096>>4 << 1*/
	addl _VRamAddress,%ebx
	movl %ebx,TileAddress
.endm


/* Here we go again! Render_Mode_x has been replaced with a more logical Render_Plane_??? */

/* Always renders to BKG */
/* ScreenAddress contains the location for the snes screen data */
/* TileAddress contains the location for the snes tile data */
/* HScroll contains the scroll data byte horizontal (only 8 bits needed!) */
/* bh contains 0 and its top 16 bits!! This is very important!*/
/* bl contains the scroll data byte verticle   (only 8 bits needed!) */
/* ch contains the Y counter */
/* ah contains the X counter */
/* %edi is the address to draw to.. */

RENDER_PLANE_8x8_C2:  /* Render a plane, 8x8 tiles 2 plane (4 colour) */

	pusha
0:
	movb	%ah,%cl			/* X Counter renewal! */
	movb	HScroll,%al		/* H Scroll renewal! */
1:
	movb	$0,%dh
	movb	%al,%dl
	shrb	$2,%dl			/* (x*2)/8 = <<1 >>3 = >>2 */
	movl	%ebx,%esi		/* This ensures top of esi is clear! */
	shlw	$3,%si			/* (y*32*2)/8 = <<6 >> 3 = <<3 */			
	addw	%dx,%si
	addl	ScreenAddress,%esi
	movw	(%esi),%dx		/* Get Tile Information */

	pushl %ecx

	movl	%edx,%esi
	andl	$0x000003FF,%esi	/* Get TileNum */
	shll	$4,%esi
	addl	TileAddress,%esi

	andl	$0x0000DC00,%edx	/* Get Plotver as     YX00 NNN0 0000 0000 */
	movl	%edx,%ecx
	shrl	$8,%edx
	movb	%dl,%dh
	andl	$0x00001C1C,%edx
	orw	%dx,ColourBase1

	shrl	$14,%ecx

	call	Tile_Plot_8x8_2(,%ecx,4)
	movl	$0x08040201,ColourBase1

	popl %ecx

	addb	$8,%al
	addl	$8,%edi

	decb	%cl
	jnz	1b

	addb	$8,%bl
	addl	$((256+64*2)*8),%edi	/* Next row */
	movl	$0,%edx			/* 8 is number of tiles at start of screen! */
	movb	%ah,%dl			/* Count will not overflow! */
	shll	$3,%edx			/* Amount to sub to get to next row */
	subl	%edx,%edi
	decb	%ch
	jnz	0b

	popa
	ret

RENDER_PLANE_8x8_C4:  /* Render a plane, 8x8 tiles 4 plane (16 colour) */

	pusha
0:
	movb	%ah,%cl			/* X Counter renewal! */
	movb	HScroll,%al		/* H Scroll renewal! */
1:
	movb	$0,%dh
	movb	%al,%dl
	shrb	$2,%dl			/* (x*2)/8 = <<1 >>3 = >>2 */
	movl	%ebx,%esi
	shlw	$3,%si			/* (y*32*2)/8 = <<6 >> 3 = <<3 */			
	addw	%dx,%si
	addl	ScreenAddress,%esi
	movw	(%esi),%dx		/* Get Tile Information */

	pushl %ecx

	movl	%edx,%esi
	andl	$0x000003FF,%esi	/* Get TileNum */
	shll	$5,%esi
	addl	TileAddress,%esi

	andl	$0x0000DC00,%edx	/* Get Plotver as     YX00 NNN0 0000 0000 */
	movl	%edx,%ecx
	shrl	$6,%edx
	movb	%dl,%dh
	andl	$0x00007070,%edx
	orw	%dx,ColourBase1
	orw	%dx,ColourBase4

	shrl	$14,%ecx

	call	Tile_Plot_8x8_4(,%ecx,4)
	movl	$0x08040201,ColourBase1

	popl %ecx

	addb	$8,%al
	addl	$8,%edi

	decb	%cl
	jnz	1b

	addb	$8,%bl
	addl	$((256+64*2)*8),%edi	/* Next row */
	movl	$0,%edx			/* 8 is number of tiles at start of screen! */
	movb	%ah,%dl			/* Count will not overflow! */
	shll	$3,%edx			/* Amount to add to get to next row */
	subl	%edx,%edi
	decb	%ch
	jnz	0b

	popa
	ret

RENDER_PLANE_8x8_C8:  /* Render a plane, 8x8 tiles 8 plane (256 colour) */

	pusha
0:
	movb	%ah,%cl			/* X Counter renewal! */
	movb	HScroll,%al		/* H Scroll renewal! */
1:
	movb	$0,%dh
	movb	%al,%dl
	shrb	$2,%dl			/* (x*2)/8 = <<1 >>3 = >>2 */
	movl	%ebx,%esi
	shlw	$3,%si			/* (y*32*2)/8 = <<6 >> 3 = <<3 */			
	addw	%dx,%si
	addl	ScreenAddress,%esi
	movw	(%esi),%dx		/* Get Tile Information */

	movw	%dx,%si
	andl	$0x0000C000,%edx	/* Get PlotVer */
	shrw	$14,%dx			/* Get bits sorted as 00YX */
	andl	$0x000003FF,%esi	/* Get TileNum */

	shll	$6,%esi			/* 8*8 */
	addl	TileAddress,%esi

	call	Tile_Plot_8x8_8(,%edx,4)	/* got address of tile routine */

	addb	$8,%al
	addl	$8,%edi

	decb	%cl
	jnz	1b

	addb	$8,%bl
	addl	$((256+64*2)*8),%edi	/* Next row */
	movl	$0,%edx			/* 8 is number of tiles at start of screen! */
	movb	%ah,%dl			/* Count will not overflow! */
	shll	$3,%edx			/* Amount to add to get to next row */
	subl	%edx,%edi
	decb	%ch
	jnz	0b

	popa
	ret

/* NB: 16x16 tile screens have a max x or y count of 17 not 33 */

RENDER_PLANE_16x16_C2:  /* Render a plane, 16x16 tiles 2 plane (4 colour) */

	pusha
0:
	movb	%ah,%cl			/* X Counter renewal! */
	movb	HScroll,%al		/* H Scroll renewal! */
1:
	movb	$0,%dh
	movb	%al,%dl
	shrb	$3,%dl			/* (x*2)/16 = <<1 >>4 = >>3 */
	movl	%ebx,%esi		/* This ensures top of esi is clear! */
	shlw	$2,%si			/* (y*32*2)/16 = <<6 >> 4 = <<2 */			
	addw	%dx,%si
	addl	ScreenAddress,%esi
	movw	(%esi),%dx		/* Get Tile Information */

	movw	%dx,%si
	andl	$0x0000DC00,%edx	/* Get PlotVer */
	shrw	$5,%dx			/* Get bits sorted as 0YX0 NNN0 0000 */
	shrb	$1,%dh			/* Get bits sorted as 00YX NNN0 0000 */
	shrw	$5,%dx			/* Get bits sorted as 0000 000Y XNNN */
	andl	$0x000003FF,%esi	/* Get TileNum */

	shll	$4,%esi			/* 2*8 */
	addl	TileAddress,%esi

	call	Tile_Plot_16x16_2(,%edx,4)	/* got address of tile routine */

	addb	$16,%al
	addl	$16,%edi

	decb	%cl
	jnz	1b

	addb	$16,%bl
	addl	$((256+64*2)*16),%edi	/* Next row */
	movl	$0,%edx			/* 8 is number of tiles at start of screen! */
	movb	%ah,%dl			/* Count will not overflow! */
	shll	$4,%edx			/* Amount to sub to get to next row */
	subl	%edx,%edi
	decb	%ch
	jnz	0b

	popa
	ret

RENDER_PLANE_16x16_C4:  /* Render a plane, 16x16 tiles 4 plane (16 colour) */

	pusha
0:
	movb	%ah,%cl			/* X Counter renewal! */
	movb	HScroll,%al		/* H Scroll renewal! */
1:
	movb	$0,%dh
	movb	%al,%dl
	shrb	$3,%dl			/* (x*2)/16 = <<1 >>4 = >>3 */
	movl	%ebx,%esi		/* This ensures top of esi is clear! */
	shlw	$2,%si			/* (y*32*2)/16 = <<6 >> 4 = <<2 */			
	addw	%dx,%si
	addl	ScreenAddress,%esi
	movw	(%esi),%dx		/* Get Tile Information */

	movw	%dx,%si
	andl	$0x0000DC00,%edx	/* Get PlotVer */
	shrw	$5,%dx			/* Get bits sorted as 0YX0 NNN0 0000 */
	shrb	$1,%dh			/* Get bits sorted as 00YX NNN0 0000 */
	shrw	$5,%dx			/* Get bits sorted as 0000 000Y XNNN */
	andl	$0x000003FF,%esi	/* Get TileNum */

	shll	$5,%esi			/* 4*8 */
	addl	TileAddress,%esi

	call	Tile_Plot_16x16_4(,%edx,4)	/* got address of tile routine */

	addb	$16,%al
	addl	$16,%edi

	decb	%cl
	jnz	1b

	addb	$16,%bl
	addl	$((256+64*2)*16),%edi	/* Next row */
	movl	$0,%edx			/* 8 is number of tiles at start of screen! */
	movb	%ah,%dl			/* Count will not overflow! */
	shll	$4,%edx			/* Amount to sub to get to next row */
	subl	%edx,%edi
	decb	%ch
	jnz	0b

	popa
	ret

RENDER_PLANE_16x16_C8:  /* Render a plane, 16x16 tiles 8 plane (256 colour) */

	pusha
0:
	movb	%ah,%cl			/* X Counter renewal! */
	movb	HScroll,%al		/* H Scroll renewal! */
1:
	movb	$0,%dh
	movb	%al,%dl
	shrb	$3,%dl			/* (x*2)/16 = <<1 >>4 = >>3 */
	movl	%ebx,%esi		/* This ensures top of esi is clear! */
	shlw	$2,%si			/* (y*32*2)/16 = <<6 >> 4 = <<2 */			
	addw	%dx,%si
	addl	ScreenAddress,%esi
	movw	(%esi),%dx		/* Get Tile Information */

	movw	%dx,%si
	andl	$0x0000C000,%edx	/* Get PlotVer */
	shrw	$14,%dx			/* Get bits sorted as 00YX */
	andl	$0x000003FF,%esi	/* Get TileNum */

	shll	$6,%esi			/* 8*8 */
	addl	TileAddress,%esi

	call	Tile_Plot_16x16_8(,%edx,4)	/* got address of tile routine */

	addb	$16,%al
	addl	$16,%edi

	decb	%cl
	jnz	1b

	addb	$16,%bl
	addl	$((256+64*2)*16),%edi	/* Next row */
	movl	$0,%edx			/* 8 is number of tiles at start of screen! */
	movb	%ah,%dl			/* Count will not overflow! */
	shll	$4,%edx			/* Amount to sub to get to next row */
	subl	%edx,%edi
	decb	%ch
	jnz	0b

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
	jc 0f			/* 240 lines so skip blanking routine */

	movl _BKG,%edi
	addl $64+(256+2*64)*(64+224),%edi

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
0:
	cmpw $1,_PC_SCREEN_MODE
	je SQUASH

	cmpw $4,_PC_SCREEN_MODE
	je HICOLOUR_COPY

	cmpw $5,_PC_SCREEN_MODE
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

HICOLOUR_COPY:		/* Temp hack, converts 256 cols to 65536 col screen */

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
UpdateSNESScreen:

	movl $0,FrameCount

	movb TM_MASK,%al
	movb TM,%ah
	orb  TD,%ah		/* Thats why the screens were not there dale! */
	andb %ah,%al
	movb %al,SCR_TM

	movb INIDISP,%al
	cmpb $0,%al		/* Check for screen off */
	jns NO_CLEAR_SCREEN

	call Clear_Screen

	ret

NO_CLEAR_SCREEN:
	movb BGMODE,%al
	andl $0x00000007,%eax

	movl Screen_Mode(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

SCREEN_END:
	ret


.macro	RENDER_MODE_7

	pusha

	movl	_VRamAddress,%esi
	movl	_BKG,%edi
	addl $64+(256+2*64)*64,%edi	/* Screen Address set to visible area */

	movl BG1HScrollData,%eax
	movl BG1VScrollData,%ebx

	movb %al,%cl
	andl $0x000003F8,%eax
	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movb %bl,%cl
	andl $0x000003F8,%ebx
	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	shrl $3,%eax			/* X/8 = >>3 */
	movb %al,%ah
	shll $4,%ebx			/* Y*128/8 = <<7 >>3 = <<4 */

	movb	$33,%dl
2:	movb	$33,%dh
3:
	xorl %ecx,%ecx
	movb %al,%cl
	addl %ebx,%ecx
	movb (%esi,%ecx,2),%cl		/* Get tile number */
	incb %al
	andb $0x7F,%al
	andl $0x000000FF,%ecx
	shll $7,%ecx			/* Make 64*2 offset to tile data */
	addl _VRamAddress,%ecx
	incl %ecx

	pushl %edx
	pushl %ebx
	pushl %edi

	movb $8,%dl
0:	movb $8,%dh
1:
	movb (%ecx),%bl
	addl $2,%ecx
	cmpb $0,(%edi)
	jne 4f
	movb %bl,(%edi)
4:	incl %edi

	decb %dh
	jnz 1b	

	addl $(256+128)-8,%edi

	decb %dl
	jnz 0b

	popl %edi
	popl %ebx
	addl $8,%edi
	popl %edx

	decb %dh
	jnz 3b	

	movb %ah,%al
	addl $128,%ebx
	andl $0x00003FFF,%ebx
	addl $(256+128)-(256+8)+(256+128)*7,%edi

	decb %dl
	jnz 2b

	popa
.endm

.macro	RENDER_MODE_7_FX

	pusha

	movl _VRamAddress,%esi		/* Address of SNES mode 7 data */
	movl _BKG,%edi			/* Address of where data is plot */
	addl $64+(256+2*64)*64,%edi	/* Screen Address set to visible area */

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

	movw $0,%bx			/* Y Location */
0:	movw $0,%ax			/* X Location */
1:
/* Convert Screen X,Y location to SNES Pic location */

	pusha

/*	pushl %ebx
	pushl %eax*/

/* Matrix Test 1 */

	shlw $8,%ax			/* Make coord XX.XX format */
	shlw $8,%bx

/*	movw Mode7_X,%cx
	movw Mode7_Y,%dx*/

/*	subw %cx,%ax*/			/* X1-X0 */
/*	subw %dx,%bx*/			/* Y1-Y0 */

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

/*	addw %cx,%ax
	addw %dx,%bx*/			/* ax,bx now setup! */

	shrl $8,%ax
	shrl $8,%bx

/*	popl %eax
	popl %ebx*/

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

	incw %bx
	addl $128,%edi			/* Advance to next line */

	cmpw $256,%bx
	jne 0b

	popa
.endm

/* I've made only one PLANE routine and lots of macro expansion to make first time coding
  easier, since any alterations I make to the initial idea will filter to all! ;-) */

/* plbit is the plane bit for testing 16x16 tile mode usage in BGMODE */

.macro	PLANE plbit,scr,tile,hscr,vscr,tmacro,renderversion8x8,renderversion16x16

	movb \scr,%al			/* Get SC value aaaaaaSC */
	andb $3,%al
	cmpb $0,%al			/* Screen is 32 x 32 tiles! */
	je 0f
	cmpb $1,%al			/* Screen is 64 x 32 tiles! */
	je 1f
	cmpb $2,%al			/* Screen is 32 x 64 tiles! */
	je 2f
	cmpb $3,%al			/* Screen is 64 x 64 tiles! */
	je 3f
					/* Rest not supported yet! */
0:
	SET_SCREEN_ADDRESS \scr		/* Render 32 x 32 screen */
	\tmacro \tile

	movl _BKG,%edi			/* Get Screen Address (points to offscreen top left corner!)*/
	addl $64+(256+2*64)*64,%edi	/* Screen Address set to visible area */

	btw $\plbit,BGMODE
	jc 0f

/* 8x8 */
	movl \hscr,%ecx
	movb %cl,HScroll
	andb $0xF8,HScroll
	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	andl $0x000000F8,%ebx
	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	movb $33,%ah
	movb $33,%ch

	call \renderversion8x8
	jmp 9f
0:
/* 16x16 */
	movl \hscr,%ecx
	movb %cl,HScroll
	andb $0xF0,HScroll
	andl $0xF,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	andl $0x000000F0,%ebx
	andl $0xF,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	movb $17,%ah
	movb $17,%ch

	call \renderversion16x16
	jmp 9f
1:					/* Render 64 x 32 tile screen mode */
	SET_SCREEN_ADDRESS \scr
	\tmacro \tile

	movl _BKG,%edi			/* Get Screen Address (points to offscreen top left corner!)*/
	addl $64+(256+2*64)*64,%edi	/* Screen Address set to visible area */

	movl \hscr,%ecx
	movb %cl,HScroll
	btw  $8,%cx			/* If this bit set, do screen 1 then 0! */
	jc 1f
					/* We render screen 0 then 1 */
	cmpb $0,%cl			/* If this is 0, then we render only screen 0 */
	je 8f				/* Early exit */

	andb $0xF8,HScroll
	movw $255,%dx
	subb HScroll,%dl		/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah			/* X Count set now! */

	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	andl $0x000000F8,%ebx
	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	movb $33,%ch

	call \renderversion8x8

	addl $32*32*2,ScreenAddress	/* Updates screen pointer to second screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8

	jmp 9f
8:
	andb $0xF8,HScroll
	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	andl $0x000000F8,%ebx
	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	movb $32,%ah
	movb $33,%ch

	call \renderversion8x8
	jmp 9f
1:
					/* We render screen 1 then 0 */

	addl $32*32*2,ScreenAddress	/* Point screen to next screen first... ;-) */

	cmpb $0,%cl			/* If this is 0, then we render only screen 1 */
	je 8f				/* Early exit */

	andb $0xF8,HScroll
	movw $255,%dx
	subb HScroll,%dl		/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah			/* X Count set now! */

	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	andl $0x000000F8,%ebx
	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	movb $33,%ch

	call \renderversion8x8

	subl $32*32*2,ScreenAddress	/* Updates screen pointer to first screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8

	jmp 9f
8:
	andb $0xF8,HScroll
	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	andl $0x000000F8,%ebx
	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	movb $32,%ah
	movb $33,%ch

	call \renderversion8x8
	jmp 9f

2:					/* Render 32 x 64 tile screen mode */
	SET_SCREEN_ADDRESS \scr
	\tmacro \tile

	movl _BKG,%edi			/* Get Screen Address (points to offscreen top left corner!)*/
	addl $64+(256+2*64)*64,%edi	/* Screen Address set to visible area */

	movl \hscr,%ecx
	movb %cl,HScroll
	andb $0xF8,HScroll
	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */


	movl \vscr,%ecx
	movb %cl,%bl
	btw  $8,%cx			/* If this bit set, do screen 1 then 0! */
	jc 2f

	cmpb $0,%cl			/* If this is 0, then we render only screen 0 */
	je 8f				/* Early exit */

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 0 then 1 */

	movb %ah,%ch			/* Y Count set now! */
	movb $33,%ah			/* Always do 33 tiles horizontal! */

	call \renderversion8x8

	addl $32*32*2,ScreenAddress	/* Updates screen pointer to second screen */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8

	jmp 9f
8:
	andb $0xF8,HScroll
	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	andl $0x000000F8,%ebx
	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	movb $33,%ah
	movb $32,%ch

	call \renderversion8x8
	jmp 9f
2:
					/* We render screen 1 then 0 */

	addl $32*32*2,ScreenAddress	/* Point screen to next screen first... ;-) */

	cmpb $0,%cl			/* If this is 0, then we render only screen 1 */
	je 8f				/* Early exit */

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 0 then 1 */

	movb %ah,%ch			/* Y Count set now! */
	movb $33,%ah			/* Always do 33 tiles horizontal! */

	call \renderversion8x8

	subl $32*32*2,ScreenAddress	/* Updates screen pointer to first screen */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8

	jmp 9f
8:
	andb $0xF8,HScroll
	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	andl $0x000000F8,%ebx
	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

	movb $33,%ah
	movb $32,%ch

	call \renderversion8x8
	jmp 9f

3:					/* Render 64 x 64 tile screen mode */

	SET_SCREEN_ADDRESS \scr
	\tmacro \tile

	movl _BKG,%edi			/* Get Screen Address (points to offscreen top left corner!)*/
	addl $64+(256+2*64)*64,%edi	/* Screen Address set to visible area */

	movl \hscr,%ecx
	movb %cl,HScroll
	btw  $8,%cx			/* If this bit set, do plot right screens first */
	jc 4f
					/* We render screen 0&1 then 2&3 */
	cmpb $0,%cl			/* If this is 0, then we render only screens 0 & 2 */
	je 5f				/* Early exit */

	andb $0xF8,HScroll
	movw $255,%dx
	subb HScroll,%dl		/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah			/* X Count set now! */

	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	btw  $8,%cx			/* If this bit set, do bottom screens first */
	jc 6f

	cmpb $0,%cl			/* If this is 0, then we render only screens 0 & 1*/
	je 7f				/* Early exit */

	pushl %eax

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 0 & 1 then 2 & 3 */

	movb %ah,%ch			/* Y Count set now! */
	popl %eax			/* X Count set */

	call \renderversion8x8

	pushl %eax			/* Store X Count for use in screen 2 & 3 plotting */
	movb HScroll,%al
	pushl %eax			/* Store HScroll for use in screen 2 & 3 plotting */
	pushl %edi

	addl $32*32*2,ScreenAddress	/* Updates screen pointer to second screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8


	addl $32*32*2,ScreenAddress	/* Updates screen pointer to third screen */

	popl %edi
	popl %eax
	movb %al,HScroll		/* Restore HScroll for next screen */
	popl %eax			/* Restore X Count */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8

	addl $32*32*2,ScreenAddress	/* Updates screen pointer to fourth screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8

	jmp 9f
7:					/* Screen 0 & 1 only */
	andl $0x000000F8,%ebx

	movb $32,%ch			/* Y Count set now! */
					/* X Count already set!*/

	call \renderversion8x8

	addl $32*32*2,ScreenAddress	/* Updates screen pointer to second screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8
	jmp 9f

6:					/* Screens 2 & 3 then 0 & 1 */

	addl $32*32*2*2,ScreenAddress	/* Updates screen pointer to third screen */

	cmpb $0,%cl			/* If this is 0, then we render only screens 2 & 3*/
	je 7f				/* Early exit */

	pushl %eax

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 2 & 3 then 0 & 1 */

	movb %ah,%ch			/* Y Count set now! */
	popl %eax			/* X Count set */

	call \renderversion8x8

	pushl %eax			/* Store X Count for use in screen 0 & 1 plotting */
	movb HScroll,%al
	pushl %eax			/* Store HScroll for use in screen 0 & 1 plotting */
	pushl %edi

	addl $32*32*2,ScreenAddress	/* Updates screen pointer to fourth screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8


	subl $32*32*2*3,ScreenAddress	/* Updates screen pointer to first screen */

	popl %edi
	popl %eax
	movb %al,HScroll		/* Restore HScroll for next screen */
	popl %eax			/* Restore X Count */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8

	addl $32*32*2,ScreenAddress	/* Updates screen pointer to second screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8

	jmp 9f
7:					/* Screen 2 & 3 only */
	andl $0x000000F8,%ebx

	movb $32,%ch			/* Y Count set now! */
					/* X Count already set!*/

	call \renderversion8x8

	addl $32*32*2,ScreenAddress	/* Updates screen pointer to fourth screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8
	jmp 9f
5:					/* Render screens 0 & 2 */

	movb $0,HScroll			/* Left screens only plotted! */

	movl \vscr,%ecx
	movb %cl,%bl
	btw  $8,%cx			/* If this bit set, do bottom screen first */
	jc 6f

	cmpb $0,%cl			/* If this is 0, then we render only screen 0*/
	je 7f				/* Early exit */

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 0 then 2 */

	movb %ah,%ch			/* Y Count set now! */
	movb $32,%ah			/* X Count set */

	call \renderversion8x8

	addl $32*32*2*2,ScreenAddress	/* Updates screen pointer to third screen */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8
	jmp 9f
7:					/* Render screen 0 only */
	andl $0x000000F8,%ebx

	movb $32,%ah
	movb $32,%ch

	call \renderversion8x8
	jmp 9f
6:					/* Render screen 2 then 0 */
	addl $32*32*2*2,ScreenAddress	/* Update screen pointer to third screen */

	cmpb $0,%cl			/* If this is 0, then we render only screen 2*/
	je 7f				/* Early exit */

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 2 then 0 */

	movb %ah,%ch			/* Y Count set now! */
	movb $32,%ah			/* X Count set */

	call \renderversion8x8

	subl $32*32*2*2,ScreenAddress	/* Updates screen pointer to first screen */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8
	jmp 9f
7:					/* Render screen 2 only */
	andl $0x000000F8,%ebx

	movb $32,%ah
	movb $32,%ch

	call \renderversion8x8
	jmp 9f

4:					/* We render screen 1&0 then 3&2 */
	addl $32*32*2,ScreenAddress	/* Point to second screen */

	cmpb $0,%cl			/* If this is 0, then we render only screens 1 & 3 */
	je 5f				/* Early exit */

	andb $0xF8,HScroll
	movw $255,%dx
	subb HScroll,%dl		/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah			/* X Count set now! */

	andl $7,%ecx			/* Get pixel offset */
	subl %ecx,%edi			/* edi points to left scrolled area */

	movl \vscr,%ecx
	movb %cl,%bl
	btw  $8,%cx			/* If this bit set, do bottom screens first */
	jc 6f

	cmpb $0,%cl			/* If this is 0, then we render only screens 1 & 0*/
	je 7f				/* Early exit */

	pushl %eax

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 0 & 1 then 2 & 3 */

	movb %ah,%ch			/* Y Count set now! */
	popl %eax			/* X Count set */

	call \renderversion8x8

	pushl %eax			/* Store X Count for use in screen 2 & 3 plotting */
	movb HScroll,%al
	pushl %eax			/* Store HScroll for use in screen 2 & 3 plotting */
	pushl %edi

	subl $32*32*2,ScreenAddress	/* Updates screen pointer to first screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8


	addl $32*32*2*3,ScreenAddress	/* Updates screen pointer to fourth screen */

	popl %edi
	popl %eax
	movb %al,HScroll		/* Restore HScroll for next screen */
	popl %eax			/* Restore X Count */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8

	subl $32*32*2,ScreenAddress	/* Updates screen pointer to third screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8

	jmp 9f
7:					/* Screen 1 & 0 only */
	andl $0x000000F8,%ebx

	movb $32,%ch			/* Y Count set now! */
					/* X Count already set!*/

	call \renderversion8x8

	subl $32*32*2,ScreenAddress	/* Updates screen pointer to first screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8
	jmp 9f

6:					/* Screens 3 & 2 then 1 & 0 */

	addl $32*32*2*2,ScreenAddress	/* Updates screen pointer to fourth screen */

	cmpb $0,%cl			/* If this is 0, then we render only screens 3 & 2*/
	je 7f				/* Early exit */

	pushl %eax

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 2 & 3 then 0 & 1 */

	movb %ah,%ch			/* Y Count set now! */
	popl %eax			/* X Count set */

	call \renderversion8x8

	pushl %eax			/* Store X Count for use in screen 0 & 1 plotting */
	movb HScroll,%al
	pushl %eax			/* Store HScroll for use in screen 0 & 1 plotting */
	pushl %edi

	subl $32*32*2,ScreenAddress	/* Updates screen pointer to third screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8


	subl $32*32*2,ScreenAddress	/* Updates screen pointer to second screen */

	popl %edi
	popl %eax
	movb %al,HScroll		/* Restore HScroll for next screen */
	popl %eax			/* Restore X Count */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8

	subl $32*32*2,ScreenAddress	/* Updates screen pointer to first screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8

	jmp 9f
7:					/* Screen 3 & 2 only */
	andl $0x000000F8,%ebx

	movb $32,%ch			/* Y Count set now! */
					/* X Count already set!*/

	call \renderversion8x8

	subl $32*32*2,ScreenAddress	/* Updates screen pointer to third screen */

	movl $0,%edx
	movb %ah,%dl			/* Get prev tile x count and update dest position */
	shll $3,%edx
	addl %edx,%edi			/* edi points to offset X position */

	movb $0,HScroll			/* Update rotation mask always 0 cos left of screen! */
	movb $33,%dl
	subb %ah,%dl
	movb %dl,%ah			/* Tile count X now updated for final columns */

					/* VScroll Already set! */
					/* Y Tile count already set! */
	call \renderversion8x8
	jmp 9f
5:					/* Render Screens 1 & 3 */

	movb $0,HScroll			/* Left screens only plotted! */

	movl \vscr,%ecx
	movb %cl,%bl
	btw  $8,%cx			/* If this bit set, do bottom screen first */
	jc 6f

	cmpb $0,%cl			/* If this is 0, then we render only screen 1*/
	je 7f				/* Early exit */

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 1 then 3 */

	movb %ah,%ch			/* Y Count set now! */
	movb $32,%ah			/* X Count set */

	call \renderversion8x8

	addl $32*32*2*2,ScreenAddress	/* Updates screen pointer to fourth screen */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8
	jmp 9f
7:					/* Render screen 1 only */
	andl $0x000000F8,%ebx

	movb $32,%ah
	movb $32,%ch

	call \renderversion8x8
	jmp 9f
6:					/* Render screen 3 then 1 */
	addl $32*32*2*2,ScreenAddress	/* Update screen pointer to fourth screen */

	cmpb $0,%cl			/* If this is 0, then we render only screen 3*/
	je 7f				/* Early exit */

	andl $0x000000F8,%ebx

	movw $255,%dx
	subb %bl,%dl			/* Pixels -1 to plot ! */
	incw %dx
	shrw $3,%dx			/* Number of tiles remaining! */
	movb %dl,%ah

	andl $7,%ecx			/* Get pixel offset */
	movw %cx,%dx
	shlw $8,%cx			/* Multiply by 256 */
	shlw $7,%dx			/* Multiply by 128 */
	addw %dx,%cx
	subl %ecx,%edi			/* edi points to up scrolled area */

					/* We render screen 3 then 1 */

	movb %ah,%ch			/* Y Count set now! */
	movb $32,%ah			/* X Count set */

	call \renderversion8x8

	subl $32*32*2*2,ScreenAddress	/* Updates screen pointer to second screen */

	movl $0,%edx
	movb %ch,%dl			/* Get prev tile y count and update dest position */
	shll $3,%edx			/* Number of pixels plotted vertically */
	movl %edx,%ebx
	shll $8,%ebx
	shll $7,%edx
	addl %ebx,%edx
	addl %edx,%edi			/* edi points to offset Y position */

	movl $0,%ebx			/* Update rotation mask always 0 cos top of screen! */
	movb $33,%dl
	subb %ch,%dl
	movb %dl,%ch			/* Tile count y now updated for final columns */

					/* HScroll Already set! */
					/* X Tile count already set! */
	call \renderversion8x8
	jmp 9f
7:					/* Render screen 3 only */
	andl $0x000000F8,%ebx

	movb $32,%ah
	movb $32,%ch

	call \renderversion8x8
	jmp 9f

9:
.endm

SCREEN_MODE_0:		/* There are 15 Versions of Render & Merge functions (4 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x0000000F,%eax

	movl Screen_Mode_Table_0(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M0_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P1_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P1_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END

M0_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P2_S

	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P2_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END

M0_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P12_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P12_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P13:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P13_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P13_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P23:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P23_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P23_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P123:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P123_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P123_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P4:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P4_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P4_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P14:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P14_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P14_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P24:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P24_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P24_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P124:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P124_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P124_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P34:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P34_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P34_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P134:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P134_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P134_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P234:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P234_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P234_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P1234:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M0_P1234_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M0_P1234_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 7,BG4SC,BG34NBA,BG4HScrollData,BG4VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END

SCREEN_MODE_1:		/* There are 7 Versions of Render & Merge functions (3 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000007,%eax

	movl Screen_Mode_Table_1(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M1_P1:
	btw $3,BGMODE
        jc M1_P1_3
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P1_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P1_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P1_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P1_3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P1_3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P2:
	btw $3,BGMODE
        jc M1_P2_3
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P2_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P2_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P2_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P2_3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P2_3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P12:
	btw $3,BGMODE
        jc M1_P12_3
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P12_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P12_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P12_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P12_3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P12_3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P3:
	btw $3,BGMODE
        jc M1_P3_3
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P3_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P3_3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P3_3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P13:
	btw $3,BGMODE
        jc M1_P13_3

	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P13_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P13_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P13_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P13_3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P13_3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P23:
	btw $3,BGMODE
        jc M1_P23_3

	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P23_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P23_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P23_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P23_3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P23_3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P123:
	btw $3,BGMODE
        jc M1_P123_3

	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P123_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P123_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P123_3:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M1_P123_3_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_3
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M1_P123_3_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 6,BG3SC,BG34NBA,BG3HScrollData,BG3VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END

SCREEN_MODE_2:		/* There are 3 Versions of Render & Merge functions (2 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000003,%eax

	movl Screen_Mode_Table_2(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M2_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M2_P1_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M2_P1_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M2_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M2_P2_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M2_P2_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M2_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M2_P12_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M2_P12_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END

SCREEN_MODE_3:		/* There are 3 Versions of Render & Merge functions (2 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000003,%eax

	movl Screen_Mode_Table_3(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M3_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M3_P1_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C8,RENDER_PLANE_16x16_C8
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M3_P1_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C8,RENDER_PLANE_16x16_C8
	call Copy_Screen
	sti
	jmp SCREEN_END
M3_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M3_P2_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M3_P2_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M3_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M3_P12_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C8,RENDER_PLANE_16x16_C8
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M3_P12_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C8,RENDER_PLANE_16x16_C8
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END

SCREEN_MODE_4:		/* There are 3 Versions of Render & Merge functions (2 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000003,%eax

	movl Screen_Mode_Table_4(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M4_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M4_P1_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C8,RENDER_PLANE_16x16_C8
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M4_P1_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C8,RENDER_PLANE_16x16_C8
	call Copy_Screen
	sti
	jmp SCREEN_END
M4_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M4_P2_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M4_P2_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M4_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M4_P12_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C8,RENDER_PLANE_16x16_C8
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M4_P12_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C8,RENDER_PLANE_16x16_C8
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END

SCREEN_MODE_5:		/* There are 3 Versions of Render & Merge functions (2 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000003,%eax

	movl Screen_Mode_Table_5(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M5_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M5_P1_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M5_P1_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END
M5_P2:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M5_P2_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M5_P2_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END
M5_P12:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M5_P12_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M5_P12_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	PLANE 5,BG2SC,BG12NBA,BG2HScrollData,BG2VScrollData,SET_TILE_HIGH,RENDER_PLANE_8x8_C2,RENDER_PLANE_16x16_C2
	call Copy_Screen
	sti
	jmp SCREEN_END

SCREEN_MODE_6:		/* There is 1 Versions of Render & Merge functions (1 planes) */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000001,%eax

	movl Screen_Mode_Table_6(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M6_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M6_P1_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M6_P1_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	PLANE 4,BG1SC,BG12NBA,BG1HScrollData,BG1VScrollData,SET_TILE_LOW,RENDER_PLANE_8x8_C4,RENDER_PLANE_16x16_C4
	call Copy_Screen
	sti
	jmp SCREEN_END

SCREEN_MODE_7:		/* There is 1 Version of the render code ! */

	movb SCR_TM,%al			/* Get BG status (on/off) for planes */
	andl $0x00000001,%eax

	movl Screen_Mode_Table_7(,%eax,4),%ecx	/* got address of screen mode routines */
	jmp %ecx

M7_P1:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc M7_P1_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
        RENDER_MODE_7_FX
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
M7_P1_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
        RENDER_MODE_7_FX
	call Copy_Screen
	sti
	jmp SCREEN_END

NO_PLANES:
	btw $4,SCR_TM		/* Are sprites enabled? */
	jnc NO_PLANES_S
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	ALL_SPRITES_PLANE_4
	ALL_SPRITES_PLANE_3
	ALL_SPRITES_PLANE_2
	ALL_SPRITES_PLANE_1
	call Copy_Screen
	sti
	jmp SCREEN_END
NO_PLANES_S:
	cli
	WIPE_SNES_SCREEN		/* Must be done... hazard of new method! */
	call Copy_Screen
	sti
	jmp SCREEN_END

.data
.balign 16					/* Align to paragraph */

ScreenAddress:	.long	0
TileAddress:	.long	0
Mode7_X:	.word	0
Mode7_Y:	.word	0
HScroll:	.byte	0
SCR_TM:		.byte	0			/* TM taken from here (TM&TM_MASK=SCR_TM) */

.balign 16					/* Align to paragraph */
.globl BG1HScrollData
BG1HScrollData:	.long	0
.globl BG1VScrollData
BG1VScrollData:	.long	0
.globl BG2HScrollData
BG2HScrollData:	.long	0
.globl BG2VScrollData
BG2VScrollData:	.long	0
.globl BG3HScrollData
BG3HScrollData:	.long	0
.globl BG3VScrollData
BG3VScrollData:	.long	0
.globl BG4HScrollData
BG4HScrollData:	.long	0
.globl BG4VScrollData
BG4VScrollData:	.long	0

Screen_Mode:
	.long	SCREEN_MODE_0
	.long	SCREEN_MODE_1
	.long	SCREEN_MODE_2
	.long	SCREEN_MODE_3
	.long	SCREEN_MODE_4
	.long	SCREEN_MODE_5
	.long	SCREEN_MODE_6
	.long	SCREEN_MODE_7			/* Early version, no FX */

Screen_Mode_Table_0:
	.long	NO_PLANES		/* No Planes but sprites maybe? */
	.long	M0_P1			/* Plane 1 only */
	.long	M0_P2			/* Plane 2 only */
	.long	M0_P12			/* Planes 1&2 only */
	.long	M0_P3			/* Plane 3 only */
	.long	M0_P13			/* Planes 1&3 only */
	.long	M0_P23			/* Planes 2&3 only */
	.long	M0_P123			/* Planes 1&2&3 only */
	.long	M0_P4			/* Plane 4 only */
	.long	M0_P14			/* Planes 1&4 only */
	.long	M0_P24			/* Planes 2&4 only */
	.long	M0_P124			/* Planes 1&2&4 only */
	.long	M0_P34			/* Planes 3&4 only */
	.long	M0_P134			/* Planes 1&3&4 only */
	.long	M0_P234			/* Planes 2&3&4 only */
	.long	M0_P1234		/* Planes 1&2&3&4 */

Screen_Mode_Table_1:
	.long	NO_PLANES		/* This is the same for all modes */
	.long	M1_P1			/* Plane 1 only */
	.long	M1_P2			/* Plane 2 only */
	.long	M1_P12			/* Planes 1&2 only */
	.long	M1_P3			/* Plane 3 only */
	.long	M1_P13			/* Planes 1&3 only */
	.long	M1_P23			/* Planes 2&3 only */
	.long	M1_P123			/* Planes 1&2&3 */

Screen_Mode_Table_2:
	.long	NO_PLANES		/* This is the same for all modes */
	.long	M2_P1			/* Plane 1 only */
	.long	M2_P2			/* Plane 2 only */
	.long	M2_P12			/* Planes 1&2 only */

Screen_Mode_Table_3:
	.long	NO_PLANES		/* This is the same for all modes */
	.long	M3_P1			/* Plane 1 only */
	.long	M3_P2			/* Plane 2 only */
	.long	M3_P12			/* Planes 1&2 only */

Screen_Mode_Table_4:
	.long	NO_PLANES		/* This is the same for all modes */
	.long	M4_P1			/* Plane 1 only */
	.long	M4_P2			/* Plane 2 only */
	.long	M4_P12			/* Planes 1&2 only */

Screen_Mode_Table_5:
	.long	NO_PLANES		/* This is the same for all modes */
	.long	M5_P1			/* Plane 1 only */
	.long	M5_P2			/* Plane 2 only */
	.long	M5_P12			/* Planes 1&2 only */

Screen_Mode_Table_6:
	.long	NO_PLANES		/* This is the same for all modes */
	.long	M6_P1			/* Plane 1 only */

Screen_Mode_Table_7:
	.long	NO_PLANES		/* This is the same for all modes */
	.long	M7_P1			/* Plane 1 only */

