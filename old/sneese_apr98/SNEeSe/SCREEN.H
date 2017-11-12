.macro	WIPE_SNES_SCREEN
	movl _BKG,%edi
    xorl %eax,%eax
    movl $((256+2*64)*(256+2*64))/4,%ecx
    rep
    stosl
.endm

.macro RenderScanline
    movl ScreenDestPtr,%edi

    movb INIDISP,%ah
    testb %ah,%ah   // Check for screen off
    jns 1f

    xorl %eax,%eax
    movl $256/4,%ecx
    rep
    stosl

	addl $128,%edi		/* Point screen to next line */
    jmp 2f

1:  cli
    call *BGMODE
    sti
	addl $256+128,%edi
2:  movl %edi,ScreenDestPtr
.endm
