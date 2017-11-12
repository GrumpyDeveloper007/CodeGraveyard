/*

 HDMA functions 

 NB for indirect addressing the address per table fetch must be taken from
 43x8/43x9 thanks zsknight!

*/

.macro ELF_THING
//#ifdef ELF
    pusha
    movl DMA_Vid/num,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
//#endif
.endm
     
#include "mem.h"

.macro HDMAOPERATION num
    movb HDMAON,%al
    testb $(1<<\num),%al
    jz  9f

    movl HDMA_Add_\num,%ebx
    movl HDMA_Ptr_\num,%esi
    movb DMAP\num,%al
    movb NTRL\num,%ah
    testb $0x40,%al     // Indirect mode?
    jnz 3f

    testb $0x7F,%ah
    movl HDMA_Siz_\num,%ecx
    jnz 2f
    negl %ebx
    addl %ecx,%ebx
    addw %bx,%si
    GET_BYTE
    incw %si
    movb %al,NTRL\num
    movl %esi,HDMA_Ptr_\num
    testb %al,%al
    jz  0f
    movb $0,%bl
    cmpb $0x80,%al
    movb %al,%ah
    jbe 1f
    movb %cl,%bl
1:  movb %bl,HDMA_Add_\num
2:

    GET_BYTE
//    ELF_THING
    pusha
    movl %esi,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
    incw %si
    call *HDMA_Wr0_\num
    decb %cl
    jz  1f

    GET_BYTE
//    ELF_THING
    pusha
    movl %esi,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
    incw %si
    call *HDMA_Wr1_\num
    decb %cl
    jz  1f

    GET_BYTE
//    ELF_THING
    pusha
    movl %esi,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
    incw %si
    call *HDMA_Wr2_\num

    GET_BYTE
//    ELF_THING
    pusha
    movl %esi,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
    call *HDMA_Wr3_\num
1:  addw %bx,HDMA_Ptr_\num
    decb %ah
    movb %ah,NTRL\num
    jmp 9f

0:  movb HDMAON,%al
    andb $~(1<<\num),%al
    movb %al,HDMAON
    jmp 9f

3:  testb $0x7F,%ah
    movl HDMA_Siz_\num,%ecx
    jnz 2f
    GET_BYTE
    incw %si
    movb %al,NTRL\num
    movb %al,%ah
    GET_BYTE
    incw %si
    movb %al,DAS\num
    GET_BYTE
    incw %si
    movb %al,DAS\num+1
    movl %esi,HDMA_Ptr_\num
    testb %ah,%ah
    jz  0b
    cmpb $0x80,%ah
    movb $0,%bl
    jbe 1f
    movb %cl,%bl
1:  movb %bl,HDMA_Add_\num
2:  movl DAS\num,%esi
    GET_BYTE
//    ELF_THING
    pusha
    movl %esi,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
    incw %si
    call *HDMA_Wr0_\num
    decb %cl
    jz  1f

    GET_BYTE
//    ELF_THING
    pusha
    movl %esi,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
    incw %si
    call *HDMA_Wr1_\num
    decb %cl
    jz  1f

    GET_BYTE
//    ELF_THING
    pusha
    movl %esi,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
    incw %si
    call *HDMA_Wr2_\num

    GET_BYTE
//    ELF_THING
    pusha
    movl %esi,%edx       /* %dl contains xx of 000021xx */
    movl HDMAYCount,%ecx        /* long 0-??? includes overscan */
    call HDMAListWrite          /* Value it writes in %al */
    popa
    call *HDMA_Wr3_\num
1:  addw %bx,DAS\num
    decb %ah
    movb %ah,NTRL\num
9:
    movl HDMA_Ptr_\num,%eax
    movl %eax,A2L\num
.endm

.macro EXPAND_ME_HDMA   num
    movb $0x80,NTRL\num

    movl A1T\num,%eax    // Src Address in ebx
    movl %eax,A2L\num
    movl %eax,HDMA_Ptr_\num

    movb DMAP\num,%al
    andl $7,%eax
    movb HDMA_Size(%eax),%bl
    movb %bl,HDMA_Siz_\num
    movb %bl,HDMA_Add_\num

    leal DMA_PPU_Order(,%eax,4),%eax
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb (%eax),%dl
    movl Write_Map_21(,%edx,4),%edx
    movl %edx,HDMA_Wr0_\num
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 1(%eax),%dl
    movl Write_Map_21(,%edx,4),%edx
    movl %edx,HDMA_Wr1_\num
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 2(%eax),%dl
    movl Write_Map_21(,%edx,4),%edx
    movl %edx,HDMA_Wr2_\num
    movl DMA_Vid_\num,%edx  // PPU address in edx
    addb 3(%eax),%dl
    movl Write_Map_21(,%edx,4),%edx
    movl %edx,HDMA_Wr3_\num
.endm

.macro RESTORE_HDMA_ADDRESS
    movb HDMAEN,%al
    movb %al,HDMAON
    EXPAND_ME_HDMA 0
    EXPAND_ME_HDMA 1
    EXPAND_ME_HDMA 2
    EXPAND_ME_HDMA 3
    EXPAND_ME_HDMA 4
    EXPAND_ME_HDMA 5
    EXPAND_ME_HDMA 6
    EXPAND_ME_HDMA 7
.endm

.macro do_HDMA
    pusha
    HDMAOPERATION 0
    HDMAOPERATION 1
    HDMAOPERATION 2
    HDMAOPERATION 3
    HDMAOPERATION 4
    HDMAOPERATION 5
    HDMAOPERATION 6
    HDMAOPERATION 7
    popa
.endm
