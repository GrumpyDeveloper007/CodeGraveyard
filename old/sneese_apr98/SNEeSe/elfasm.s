#include <libc/asmdefs.h>

#define FUNC(x)		.globl x; x:

#define ENTER		pushl %ebp; movl %esp,%ebp; PUSHL_EBX PUSHL_ESI PUSHL_EDI

#define LEAVE		L_leave: POPL_EDI POPL_ESI POPL_EBX movl %ebp,%esp; popl %ebp; ret
#define LEAVEP(x)	L_leave: x; POPL_EDI POPL_ESI POPL_EBX movl %ebp,%esp; popl %ebp; ret

#define LEAVEL(label) label: POPL_EDI POPL_ESI POPL_EBX movl %ebp,%esp; popl %ebp; ret


// eax- address (0-64K)
// 
E_VRAM_Write:
	ret





	FUNC(_SetLinear)
	pusha
	
	movl	$0,%eax
	movl	$1,%ecx
//	int	0x31
//	movl	%eax,_LinSeg

//    regs.x.eax = 0;
//    regs.x.ecx = 1;
//    int386(0x31,&regs,&regs);            // Allocate Local Descriptor
//    LinearSelector=regs.w.ax;            // Get selector to linear frame buffer

	movl	$0x800,%eax
	movl	$0xe000,%ebx
	movl	$0x0000,%ecx
	movl	$0x3f,%esi
	movl	$0xffff,%edi
//	int	0x31
	shll	$16,%ebx
	movw	%cx,%bx
//	movl	%ebx,_LinAddr

//    regs.x.eax = 0x800;
//    regs.x.ebx = ((ModeInfo->PhysBasePtr)>>16)&0xffff;
//    regs.x.ecx = (ModeInfo->PhysBasePtr)&0xffff;
//    regs.w.si = 0x003f;
//    regs.w.di = 0xffff;
//    int386(0x31,&regs,&regs);            // Get linear address from physical
//    LinearAddress=((regs.w.bx<<16)&0xffff0000)+(regs.w.cx&0xffff);

//    regs.x.eax = 7;
//    regs.x.ecx = (LinearAddress>>16)&0xffff;  // start address of screen (frame buffer)
//    regs.x.edx = (LinearAddress)&0xffff;
//    regs.x.ebx = LinearSelector;
//    int386(0x31,&regs,&regs);            // Set descriptor base address

//    regs.x.eax = 8;
//    regs.x.ecx = Num64Ks-1;         // CX:DX = limit of selector
//    regs.x.edx = 0xffff;          // 64K limit
//    regs.x.ebx = LinearSelector;
//    int386(0x31,&regs,&regs);            // Set descriptor limit
	popa
	ret
//3584MB
	FUNC(_E_PlotPixel)
	movl _VESAScreenDestnation,%edi
//	movw _lb_segment2,%eax
//	movw %ax,%fs
	movb _VESAScreenPixel,%bl
	movb %al,%gs:(%edi)

	ret

//
iy:	.long	0

	FUNC(_PlotTileA)

	pusha
	push	%ebp
	movl	$0,%eax
	movl	%eax,iy

	movl	_TileDestnation,%edi
	movl	$8,%ebp
PlotTileAY:
//  PlotTileLoopTemp=(*(TileYTable+iy))<<3;//*8
	movl	_TileYTable,%esi
	addl	iy,%esi
	incl	iy

	xorl	%ebx,%ebx
	movb	(%esi),%bl
	shll	$3,%ebx

	movl	_TileSource,%esi
	addl	%ebx,%esi

	movl	_TileXTable,%edx

	movl	$8,%ecx // xloop
	xorl	%eax,%eax
PlotTileAX:
	movl	%esi,%ebx

	movb	-1(%edx,%ecx),%al

	addb	%al,%bl
	movb	(%ebx),%al

	test	%al,%al
	je	SkipColourBase
	addb	_ColourBase,%al
SkipColourBase:
	movb	%al,(%edi)
	incl	%edi

	decl	%ecx
	jne	PlotTileAX

	addl	$256-8,%edi

	decl	%ebp
	jne	PlotTileAY

	pop	%ebp
	popa
	ret

/////////////////////////////////////////
// tiles
	FUNC(_PlotTileA_F00_M0)
	pusha

	movl	_TileDestnation,%edi
	movl	_TileSource,%esi
	movl	$8,%edx // yloop
	xorl	%eax,%eax
	xorl	%ebx,%ebx
	movb	_ColourBase,%bl
0:
	movl	$8,%ecx // xloop
1:
	movb	(%esi),%al
	incl	%esi

	test	%al,%al
	je	2f
	addl	%ebx,%eax
2:
	movb	%al,(%edi)
	incl	%edi

	decl	%ecx
	jne	1b

	addl	$256-8,%edi

	decl	%edx
	jne	0b

	popa
	ret

	FUNC(_PlotTileA_FX0_M0)
	pusha

	movl	_TileDestnation,%edi
	movl	_TileSource,%esi
	movl	$8,%edx // yloop
	xorl	%eax,%eax
	xorl	%ebx,%ebx
	movb	_ColourBase,%bl
0:
	movl	$8,%ecx // xloop
	addl	$7,%edi
1:
	movb	(%esi),%al
	incl	%esi

	test	%al,%al
	je	2f
	addl	%ebx,%eax
2:
	movb	%al,(%edi)
	decl	%edi

	decl	%ecx
	jne	1b

	addl	$256+1,%edi

	decl	%edx
	jne	0b

	popa
	ret

	FUNC(_PlotTileA_F0Y_M0)
	pusha

	movl	_TileDestnation,%edi
	movl	_TileSource,%esi
	movl	$8,%edx // yloop
	addl	$256*7,%edi
	xorl	%eax,%eax
	xorl	%ebx,%ebx
	movb	_ColourBase,%bl
0:
	movl	$8,%ecx // xloop
1:
	movb	(%esi),%al
	incl	%esi

	test	%al,%al
	je	2f
	addl	%ebx,%eax
2:
	movb	%al,(%edi)
	incl	%edi

	decl	%ecx
	jne	1b

	subl	$256+8,%edi

	decl	%edx
	jne	0b

	popa
	ret
	FUNC(_PlotTileA_FXY_M0)
	pusha

	movl	_TileDestnation,%edi
	movl	_TileSource,%esi
	movl	$8,%edx // yloop
	addl	$256*7,%edi
	xorl	%eax,%eax
	xorl	%ebx,%ebx
	movb	_ColourBase,%bl
0:
	movl	$8,%ecx // xloop
	addl	$7,%edi
1:
	movb	(%esi),%al
	incl	%esi

	test	%al,%al
	je	2f
	addl	%ebx,%eax
2:
	movb	%al,(%edi)
	decl	%edi

	decl	%ecx
	jne	1b

	subl	$256-1,%edi

	decl	%edx
	jne	0b

	popa
	ret


//#ifdef ELF
.global HDMAListWrite
HDMAListWrite:
//    pusha
	movl %edx,_RegisterNumber
	movw %cx,_VertNumber
	movb %al,_RegisterValue
	call _WriteRegisterHoriz__Fv
//    movl DMA_Vid/num,%edx       /* %dl contains xx of 000021xx */
//    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
//    call HDMAListWrite          /* Value it writes in %al */
//    popa
	ret

///////////////////////////////////////
	FUNC(_ChunkyToPlanar4)

	pusha
	push %ebp
	movl $8,%ebp
	movl _ChunkyTileDestnation,%edi
	movl _SNESTileSource,%esi

9:				/* YLoop */
				/*  Bp0=*(TileAddress+0) */
				/*  Bp1=*(TileAddress+1) */
	movw (%esi),%bx

	movl $7,%edx
	push %ebp
	movl $8,%ebp

8:				/* XLoop */
	xorl %eax,%eax
	btw %dx,%bx
	jnc 7f
	orb $1,%al

7:				/* Pixel 1 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb $2,%al
7:				/* Pixel 2 */
	movb %al,(%edi)
	subw $8,%dx
	incl %edi
	decw %dx

	decl %ebp
	jne 8b
	pop %ebp

	addl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret


//.global _ChunkyToPlanar16

	FUNC(_ChunkyToPlanar16)
//_ChunkyToPlanar16:		/* tile address in esi, plane screen in edi */
	pusha
	push %ebp
	movl $8,%ebp
	movl _ChunkyTileDestnation,%edi
	movl _SNESTileSource,%esi
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
	xorl %eax,%eax

	btw %dx,%bx
	jnc 7f
	orb $1,%al
7:				/* Pixel 1 */
	btw %dx,%cx
	jnc 7f
	orb $4,%al

7:				/* Pixel 3 */
	addw $8,%dx
	btw %dx,%bx
	jnc 7f
	orb $2,%al
7:				/* Pixel 2 */
	btw %dx,%cx
	jnc 7f
	orb $8,%al
7:				/* Pixel 4 */
	movb %al,(%edi)
	subw $8,%dx
6:	incl %edi
	decw %dx

	decl %ebp
	jne 8b
	pop %ebp

//	addl $(-8),%edi
	addl $2,%esi

	decl %ebp
	jne 9b
	pop %ebp
	popa
	ret





.globl RegUpdate
RegUpdate:
	push	%eax

	movb	INIDISP,%al
	movb	%al,_E_INIDISP

	movb	OBSEL,%al
	movb	%al,_E_OBSEL

//	movb	OAMAddress,%al
//	movb	%al,_E_OAMAddress

	movb	BGSIZE,%al
	movb	%al,_E_BGMODE

	movb	MOSAIC,%al
	movb	%al,_E_MOSAIC

	movb	_TBG1SC,%al
	movb	%al,_E_BG1SC

	movb	_TBG2SC,%al
	movb	%al,_E_BG2SC

	movb	_TBG3SC,%al
	movb	%al,_E_BG3SC

	movb	_TBG4SC,%al
	movb	%al,_E_BG4SC

	movb	_TBG12NBA,%al
	movb	%al,_E_BG12NBA

	movb	_TBG34NBA,%al
	movb	%al,_E_BG34NBA

	movw	BG1HScrollData,%ax
	movw	%ax,_E_BG1HScrollData

	movw	BG1VScrollData,%ax
	movw	%ax,_E_BG1VScrollData

	movw	BG2HScrollData,%ax
	movw	%ax,_E_BG2HScrollData

	movw	BG2VScrollData,%ax
	movw	%ax,_E_BG2VScrollData

	movw	BG3HScrollData,%ax
	movw	%ax,_E_BG3HScrollData

	movw	BG3VScrollData,%ax
	movw	%ax,_E_BG3VScrollData

	movw	BG4HScrollData,%ax
	movw	%ax,_E_BG4HScrollData

	movw	BG4VScrollData,%ax
	movw	%ax,_E_BG4VScrollData

	movb	TD,%al
	movb	%al,_E_TD

	movb	TM,%al
	movb	%al,_E_TM

	pop	%eax
	ret

//////////////////////////////////////////////////////////////
	FUNC(_PlotSNESScreenASM)
	pusha

	movl	_ScreenDestnationBuffer,%ecx
	movl	_ScreenDestnationDest,%edi
	movl	_E_SNESPAL,%esi
	xorl	%ebx,%ebx

	movw	_Feature1Index,%ax
	test	%ax,%ax
	jne	Feature1

	movl	$240,%edx
0:
	movb	(%ecx),%bl

	movl	(%esi,%ebx,4),%eax

	movw	%ax,(%edi)

	shrl	$16,%eax
	movb	%al,2(%edi)
	addl	$3,%edi

	incb	%cl
	jne	0b

	incb	%ch

	addl	$(800-256)*3,%edi

	decl	%edx
	jne	0b

	popa
	ret

Feature1:
	push	%ebp
	xorl	%edx,%edx
	movl	_Feature1Buffer,%ebp
	movl	%edx,_Feature1YVal
2:
	movb	(%ebp),%dl
	cmpl	%edx,_Feature1YVal
	je	4f
0:
	movb	(%ecx),%bl

	movl	(%esi,%ebx,4),%eax
	movw	%ax,(%edi)

	shrl	$16,%eax
	movb	%al,2(%edi)
	addl	$3,%edi

	incb	%cl
	jne	0b

	incb	%ch
	je	3f

	addl	$(800-256)*3,%edi
	incl	_Feature1YVal

	cmpl	%edx,_Feature1YVal
	jne	0b

4:
	movb	1(%ebp),%bl

	movl	2(%ebp),%eax
	movl	%eax,(%esi,%ebx,4)

	addl	$8,%ebp

	cmpl	%ebp,_Feature1BufferEnd
	jne	2b
3:

	pop	%ebp
	popa
	ret


/////////////////////////////////////////
// tiles - plot 1 line only ( y fliped are generated by altering TileYPos to inverse
	FUNC(_PlotTileA_F00_M0L)
	pusha

	movl	_TileDestnation,%edi
	movl	_TileSource,%esi
	movl	_TileYPos,%eax
	shll	$3,%eax
	addl	%eax,%esi
	shll	$8-3,%eax
	addl	%eax,%edi

	xorl	%eax,%eax
	xorl	%ebx,%ebx
	movb	_ColourBase,%bl
	movl	$8,%ecx // xloop
1:
	movb	(%esi),%al
	incl	%esi

	test	%al,%al
	je	2f
	addl	%ebx,%eax
2:
	movb	%al,(%edi)
	incl	%edi

	decl	%ecx
	jne	1b

	popa
	ret

	FUNC(_PlotTileA_FX0_M0L)
	pusha

	movl	_TileDestnation,%edi
	movl	_TileSource,%esi
	movl	_TileYPos,%eax
	shll	$3,%eax
	addl	%eax,%esi
	shll	$8-3,%eax
	addl	%eax,%edi

	xorl	%eax,%eax
	xorl	%ebx,%ebx
	movb	_ColourBase,%bl

	movl	$8,%ecx // xloop
	addl	$7,%edi
1:
	movb	(%esi),%al
	incl	%esi

	test	%al,%al
	je	2f
	addl	%ebx,%eax
2:
	movb	%al,(%edi)
	decl	%edi

	decl	%ecx
	jne	1b

	popa
	ret



