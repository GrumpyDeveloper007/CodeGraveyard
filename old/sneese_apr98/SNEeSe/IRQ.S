// IRQ implementation below!

#include "hdma.S"
#include "mem.h"
#include "cpu.h"
#include "screen.h"
#include "misc.h"

// Requires current scanline to be in %eax
.macro CheckIRQ
    movb NMITIMEN,%bl
    testb $0x10,%bl         // Horizontal IRQ enabled?
    jnz 1f                  // Very rough HIRQ support
    cmpl VTIMEL,%eax        // IRQ set for this scanline?
    jne 0f
    testb $0x20,%bl         // Vertical IRQ enabled?
    jz  0f
    movb TIMEUP,%bh
    testb $0x80,%bh         // Previous IRQ cleared?
/*    jnz 0f*/
1:  movl SNES_Flags,%ebx
    testl $MASK_FLAG_I,%ebx // Interrupts disabled?
    jz  2f
    movb $-1,IRQRcvd
    jmp 0f
2:  testl $MASK_FLAG_E,%ebx // Emulation mode?
    jz  1f
    // Emulation mode IRQ
    movb _SNES_PC+1,%al
    E1_PUSH_B
	movb _SNES_PC,%al
	E1_PUSH_B
    CLR_FLAG(SNES_FLAG_B)   // Clear break bit
    E1_SETUPFLAGS           // put flags into SNES packed flag format
	E1_PUSH_B

    xorl %esi,%esi          // Setup bank
    movl %esi,SNES_ProgBank
    addl $0xfffe,%esi
    jmp 2f

1:  // Native mode IRQ
    movb _SNES_PB,%al
    E0_PUSH_B
    movb _SNES_PC+1,%al
    E0_PUSH_B
	movb _SNES_PC,%al
	E0_PUSH_B
    E0_SETUPFLAGS           // put flags into SNES packed flag format
	E0_PUSH_B

    xorl %esi,%esi          // Setup bank
    movl %esi,SNES_ProgBank
    addl $0xffee,%esi
2:  SET_FLAG(SNES_FLAG_I)   // Disable interrupts
	CLR_FLAG(SNES_FLAG_D)
	GET_WORD
	movw %ax,_SNES_PC
    movb $0x80,TIMEUP       // Disable further IRQ's
0:
.endm

IRQFrameCheck:      // Check IRQ, Frame Skip
    movb $1,HVBJOY          // Vblank off
    xorl %eax,%eax
    decl FrameCount         // Should we redraw the screen this frame?
    movl %eax,HDMAYCount    // Reset scanline counter
    jnz 0f
    movl FRAME_SKIP,%ebx
    orb $8,%al
    movl %ebx,FrameCount    // Reset frame counter
#ifdef DEBUG
	incl _Frames
#endif
0:  movb SETINI,%bl
    testb $4,%bl            // 224 or 240 lines tall?
    jz  0f
    orb $4,%al
0:  pushl %eax
    movl IRQ_Handler_Table(%eax),%eax
    movl %eax,IRQ_Handler
    WIPE_SNES_SCREEN        // Must be done... hazard of new method!
    RESTORE_HDMA_ADDRESS    // Relatch HDMA registers
	movl _BKG,%edi
    addl $64+(256+2*64)*64,%edi
    movl %edi,ScreenDestPtr // Setup destination screen pointer
    do_HDMA
    popl %eax
    testb $8,%al
    jz  0f                  // Don't render if frame skipped!
//#ifdef ELF
    pushl %eax
    movw _PC_SCREEN_MODE,%ax
    cmpw $8,%ax
    popl %eax
    je 0f
//#endif
#ifndef BUGFIND
    RenderScanline
#endif
0:  xorl %eax,%eax
    CheckIRQ                // Check for IRQ
    ret                     // Return to CPU

IRQHDMARender:      // Check HDMA, IRQ, Render
    incl HDMAYCount
    do_HDMA
//#ifdef ELF
    pushl %eax
    movw _PC_SCREEN_MODE,%ax
    cmpw $8,%ax
    popl %eax
    je 0f
//#endif
    RenderScanline
0:  movl HDMAYCount,%eax    // Get current scanline
    CheckIRQ                // Check for IRQ
    ret                     // Return to CPU

IRQOverscan:        // Check IRQ
    movl HDMAYCount,%eax    // Get current scanline
    incl %eax
    movl %eax,HDMAYCount
    CheckIRQ                // Check for IRQ
    ret                     // Return to CPU

VBL:movb $0x81,HVBJOY       // Vblank on
    incl HDMAYCount
    ret

IRQHDMA:            // Check HDMA, IRQ
    incl HDMAYCount
    do_HDMA
    movl HDMAYCount,%eax    // Get current scanline
    CheckIRQ                // Check for IRQ
    ret                     // Return to CPU

.data
.balign 4
.globl IRQ_Table_224_NoRender
IRQ_Table_224_NoRender:
DUPLICATE long,64,IRQHDMA
DUPLICATE long,64,IRQHDMA
DUPLICATE long,64,IRQHDMA
DUPLICATE long,31,IRQHDMA
DUPLICATE long,38,IRQOverscan
.long NMI_NoRender
DUPLICATE long,7,VBL
.long IRQFrameCheck

.globl IRQ_Table_240_NoRender
IRQ_Table_240_NoRender:
DUPLICATE long,64,IRQHDMA
DUPLICATE long,64,IRQHDMA
DUPLICATE long,64,IRQHDMA
DUPLICATE long,47,IRQHDMA
DUPLICATE long,22,IRQOverscan
.long NMI_NoRender
DUPLICATE long,7,VBL
.long IRQFrameCheck

.globl IRQ_Table_224
IRQ_Table_224:
DUPLICATE long,64,IRQHDMARender
DUPLICATE long,64,IRQHDMARender
DUPLICATE long,64,IRQHDMARender
DUPLICATE long,31,IRQHDMARender
DUPLICATE long,38,IRQOverscan
.long NMI
DUPLICATE long,7,VBL
.long IRQFrameCheck

.globl IRQ_Table_240
IRQ_Table_240:
DUPLICATE long,64,IRQHDMARender
DUPLICATE long,64,IRQHDMARender
DUPLICATE long,64,IRQHDMARender
DUPLICATE long,47,IRQHDMARender
DUPLICATE long,22,IRQOverscan
.long NMI
DUPLICATE long,7,VBL
Dummy_IRQ_Table:        // Used at init
.long IRQFrameCheck

.globl IRQ_Handler_Table
IRQ_Handler_Table:
.long IRQ_Table_224_NoRender
.long IRQ_Table_240_NoRender
.long IRQ_Table_224
.long IRQ_Table_240

.globl IRQ_Handler
// New for IRQ, controls screen height and render
IRQ_Handler:.long   Dummy_IRQ_Table
.globl ScreenDestPtr
ScreenDestPtr:  .long   0
.globl FrameCount
FrameCount: .long   1   // Number of frames waited, for speeding up emu
.globl IRQRcvd
IRQRcvd:    .byte   0   // Used for IRQ + interrupt disable

// HDMA_Ptr_x - These point to the table in use
// HDMA_Add_x - These hold the add info for implementing continue mode
//              new for v0.13
// HDMA_Vid_x - These hold the PPU base address
// HDMA_Wr#_x - These hold the write handlers for HDMA
// HDMA_Siz_x - These hold the register size for HDMA
// HDMA_Cnt_x - No longer used - NTRLx used instead
.balign 16
HDMA_Siz_0: .long   0
HDMA_Ptr_0: .long   0
HDMA_Add_0: .long   0
HDMA_Vid_0: .long   0
HDMA_Wr0_0: .long   0
HDMA_Wr1_0: .long   0
HDMA_Wr2_0: .long   0
HDMA_Wr3_0: .long   0
HDMA_Siz_1: .long   0
HDMA_Ptr_1: .long   0
HDMA_Add_1: .long   0
HDMA_Vid_1: .long   0
HDMA_Wr0_1: .long   0
HDMA_Wr1_1: .long   0
HDMA_Wr2_1: .long   0
HDMA_Wr3_1: .long   0
HDMA_Siz_2: .long   0
HDMA_Ptr_2: .long   0
HDMA_Add_2: .long   0
HDMA_Vid_2: .long   0
HDMA_Wr0_2: .long   0
HDMA_Wr1_2: .long   0
HDMA_Wr2_2: .long   0
HDMA_Wr3_2: .long   0
HDMA_Siz_3: .long   0
HDMA_Ptr_3: .long   0
HDMA_Add_3: .long   0
HDMA_Vid_3: .long   0
HDMA_Wr0_3: .long   0
HDMA_Wr1_3: .long   0
HDMA_Wr2_3: .long   0
HDMA_Wr3_3: .long   0
HDMA_Siz_4: .long   0
HDMA_Ptr_4: .long   0
HDMA_Add_4: .long   0
HDMA_Vid_4: .long   0
HDMA_Wr0_4: .long   0
HDMA_Wr1_4: .long   0
HDMA_Wr2_4: .long   0
HDMA_Wr3_4: .long   0
HDMA_Siz_5: .long   0
HDMA_Ptr_5: .long   0
HDMA_Add_5: .long   0
HDMA_Vid_5: .long   0
HDMA_Wr0_5: .long   0
HDMA_Wr1_5: .long   0
HDMA_Wr2_5: .long   0
HDMA_Wr3_5: .long   0
HDMA_Siz_6: .long   0
HDMA_Ptr_6: .long   0
HDMA_Add_6: .long   0
HDMA_Vid_6: .long   0
HDMA_Wr0_6: .long   0
HDMA_Wr1_6: .long   0
HDMA_Wr2_6: .long   0
HDMA_Wr3_6: .long   0
HDMA_Siz_7: .long   0
HDMA_Ptr_7: .long   0
HDMA_Add_7: .long   0
HDMA_Vid_7: .long   0
HDMA_Wr0_7: .long   0
HDMA_Wr1_7: .long   0
HDMA_Wr2_7: .long   0
HDMA_Wr3_7: .long   0

