; Assembler for tunnel ploting routine
; 
; NOTE: master class book is wrong !
; - inc esi,inc esi is faster than add esi,immediate

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public AsmPlotTable_
       public ASMSetParam_

VirtualScreen dd 0
PhysicalScreen dd 0
ScreenLength dd 0
ASMSetParam_:
        mov [VirtualScreen],eax
        mov [PhysicalScreen],ebx
        mov [ScreenLength],ecx
        ret
;#pragma aux SetParam parm [eax][ebx][ecx];

; eax - Write buffer
; ebx - Temp offset into picture
; ecx - constant 2
; edx - Picture address
;
; esi - Table pointer
; edi - Destnation address
; ebp - loop counter
;
AsmPlotTable_:
        push ebp
        mov ebp,ecx
;        mov edi,[PhysicalScreen]
        mov edi,[VirtualScreen]
        mov ecx,[PhysicalScreen]
        mov [VirtualScreen],ecx
        mov [PhysicalScreen],edi
        add edx,eax
        xor eax,eax
        xor ebx,ebx
        mov ecx,2

        lea edi,[edi-4]         ; allows pre decrement
        align 16
lloop:
        mov bx,[esi]
        add esi,ecx
        mov al,[edx+ebx]
        lea edi,[edi+4]           ; next set of pixels

        mov bx,[esi]
        add esi,ecx
        mov ah,[edx+ebx]
        ror eax,16

        mov bx,[esi]
        add esi,ecx
        mov al,[edx+ebx]

        mov bx,[esi]
        add esi,ecx
        mov ah,[edx+ebx]
        ror eax,16

        mov [fs:edi],eax

        dec ebp
        jnz lloop
        pop ebp
        ret


_TEXT  ends
       end
