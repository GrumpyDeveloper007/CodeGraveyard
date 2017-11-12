/*

 memDMA.S - DMA memory mapped functions

*/

#include "mem.h"

.macro DMAOPERATION num
    movb MDMAEN,%al
    testb $(1<<\num),%al
    jz  7f

    movl A1T\num,%esi       // CPU address in esi
    xorl %ecx,%ecx          // Set address increment to 0

    xorl %ebp,%ebp
    movw DAS\num,%bp
    testl %ebp,%ebp
    jnz 0f
    movl $0x10000,%ebp

0:  movb DMAP\num,%al
    testb $8,%al    // Does the operation require address adjustment?
    jnz 1f

    decl %ecx       // Set address decrement
    testb $0x10,%al
    jnz 1f

    addl $2,%ecx    // Set address increment

1:  testb $0x80,%al // Is the operation CPU->PPU?
    jz  0f

// PPU->CPU
    andl $7,%eax
    leal DMA_PPU_Order(,%eax,4),%eax
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb (%eax),%dl
    movl Read_Map_21(,%edx,4),%edx
    movl %edx,DMA_Access0
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 1(%eax),%dl
    movl Read_Map_21(,%edx,4),%edx
    movl %edx,DMA_Access1
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 2(%eax),%dl
    movl Read_Map_21(,%edx,4),%edx
    movl %edx,DMA_Access2
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 3(%eax),%dl
    movl Read_Map_21(,%edx,4),%edx
    movl %edx,DMA_Access3
1:  call *DMA_Access0
    SET_BYTE
    addw %cx,%si
    decl %ebp
    jz  1f

    call *DMA_Access1
    SET_BYTE
    addw %cx,%si
    decl %ebp
    jz  1f

    addb $2,%dl
    call *DMA_Access2
    SET_BYTE
    addw %cx,%si
    decl %ebp
    jz  1f

    call *DMA_Access3
    SET_BYTE
    addw %cx,%si
    subb $2,%dl
    decl %ebp
	jnz 1b
	jmp 1f

0:  andl $7,%eax
    leal DMA_PPU_Order(,%eax,4),%eax
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb (%eax),%dl
    movl Write_Map_21(,%edx,4),%edx
    movl %edx,DMA_Access0
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 1(%eax),%dl
    movl Write_Map_21(,%edx,4),%edx
    movl %edx,DMA_Access1
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 2(%eax),%dl
    movl Write_Map_21(,%edx,4),%edx
    movl %edx,DMA_Access2
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 3(%eax),%dl
    movl Write_Map_21(,%edx,4),%edx
    movl %edx,DMA_Access3
0:  GET_BYTE
    call *DMA_Access0
    addw %cx,%si
    decl %ebp
    jz  1f

    GET_BYTE
    call *DMA_Access1
    addw %cx,%si
    decl %ebp
    jz  1f

    GET_BYTE
    call *DMA_Access2
    addw %cx,%si
    decl %ebp
    jz  1f

    GET_BYTE
    call *DMA_Access3
    addw %cx,%si
    decl %ebp
	jnz 0b

1:  movw %si,A1T\num    // v0.15 forgot to update DMA pointers!
7:
.endm

.globl doDMA
doDMA:
    pusha
    DMAOPERATION 0
    DMAOPERATION 1
    DMAOPERATION 2
    DMAOPERATION 3
    DMAOPERATION 4
    DMAOPERATION 5
    DMAOPERATION 6
    DMAOPERATION 7
    popa
8:  ret
