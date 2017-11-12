                .file   "postproc"
.text
                .align 16
                .globl  pp16Mono 
                .globl  pp8Mono 
                .globl  pp16Stereo 
                .globl  pp8Stereo 
pp16Mono:      enter   $0x00,$0x0000
                pushl   %esi
                pushl   %edi
                pushl   %ebx
                movl    0xc(%ebp),%edi
                addl    0x10(%ebp),%edi
                movl    0x14(%ebp),%esi
                movl    L24,%ebx
                movl    0x8(%ebp),%ecx
                testl   %ecx,%ecx
                je      L4
L1:             movl    (%esi),%eax
                addl    $0x00000004,%esi
                cmpl    $0x00007fff,%eax
                jg      L2
                cmpl    $0xffff8000,%eax
                jl      L3
                movw    %ax,(%edi)
                addl    $0x00000002,%edi
                decl    %ecx
                jne     L1
                jmp     L4
L2:             movw    $0x7fff,(%edi)
                movl    $0x00007fff,%ebx
                addl    $0x00000002,%edi
                decl    %ecx
                jne     L1
                jmp     L4
L3:             movw    $0x8000,(%edi)
                movl    $0xffff8000,%ebx
                addl    $0x00000002,%edi
                decl    %ecx
                jne     L1
L4:             movl    %ebx,L24
                subl    0xc(%ebp),%edi
                movl    %edi,%eax
                popl    %ebx
                popl    %edi
                popl    %esi
                leave   
                ret     
L5:             .long   L6
                .long   L7
                .long   L8
                .long   L9
                .long   L10
                .long   L11
                .long   L12
                .long   L13
                .long   L14
                .long   L15
                .long   L16
                .long   L17
                .long   L18
                .long   L19
                .long   L20
                .long   L21
                .long   L22
pp8Mono:       enter   $0x00,$0x0000
                pushl   %esi
                pushl   %edi
                pushl   %ebx
                movl    0x14(%ebp),%esi
                movl    0xc(%ebp),%edi
                addl    0x10(%ebp),%edi
                movl    0x8(%ebp),%ecx
                testl   %ecx,%ecx
                je      L23
                shrl    $1,%ecx
                movl    %ecx,%eax
                andl    $0x0000000f,%eax
                shll    $1,%eax
                negl    %eax
                addl    $0x00000020,%eax
                subl    %eax,%edi
                shll    $1,%eax
                movl    L5(%eax),%ebx
                shll    $1,%eax
                subl    %eax,%esi
                shrl    $0x04,%ecx
                incl    %ecx
                movl    0x18(%ebp),%edx
                jmp     %ebx
L6:             movl    (%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x4(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,(%edi)
L7:             movl    0x8(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0xc(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x2(%edi)
L8:             movl    0x10(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x14(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x4(%edi)
L9:             movl    0x18(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x1c(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x6(%edi)
L10:            movl    0x20(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x24(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x8(%edi)
L11:            movl    0x28(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x2c(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0xa(%edi)
L12:            movl    0x30(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x34(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0xc(%edi)
L13:            movl    0x38(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x3c(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0xe(%edi)
L14:            movl    0x40(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x44(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x10(%edi)
L15:            movl    0x48(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x4c(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x12(%edi)
L16:            movl    0x50(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x54(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x14(%edi)
L17:            movl    0x58(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x5c(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x16(%edi)
L18:            movl    0x60(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x64(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x18(%edi)
L19:            movl    0x68(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x6c(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x1a(%edi)
L20:            movl    0x70(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x74(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x1c(%edi)
L21:            movl    0x78(%esi),%ebx
                movb    0x800(%edx,%ebx),%al
                movl    0x7c(%esi),%ebx
                movb    0x800(%edx,%ebx),%ah
                movw    %ax,0x1e(%edi)
L22:            addl    $0x00000080,%esi
                addl    $0x00000020,%edi
                decl    %ecx
                jne     L6
L23:            subl    0xc(%ebp),%edi
                movl    %edi,%eax
                popl    %ebx
                popl    %edi
                popl    %esi
                leave   
                ret     
pp16Stereo:    enter   $0x00,$0x0000
                pushl   %esi
                pushl   %edi
                pushl   %ebx
                movl    0x8(%ebp),%eax
                shll    $1,%eax
                pushl   0x18(%ebp)
                pushl   0x14(%ebp)
                pushl   0x10(%ebp)
                pushl   0xc(%ebp)
                pushl   %eax
                call    pp16Mono
                addl    $0x00000014,%esp
                popl    %ebx
                popl    %edi
                popl    %esi
                leave   
                ret     
pp8Stereo:     enter   $0x00,$0x0000
                pushl   %esi
                pushl   %edi
                pushl   %ebx
                movl    0x8(%ebp),%eax
                shll    $1,%eax
                pushl   0x18(%ebp)
                pushl   0x14(%ebp)
                pushl   0x10(%ebp)
                pushl   0xc(%ebp)
                pushl   %eax
                call    pp8Mono
                addl    $0x00000014,%esp
                popl    %ebx
                popl    %edi
                popl    %esi
                leave   
                ret     

.data
                .align 16
L24:            .byte   0x00,0x00,0x00,0x00

