; Assembler for tunnel ploting routine
; 
; NOTE: master class book is wrong !
; - inc esi,inc esi is faster than add esi,immediate

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public AsmPlotTable_

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
;        mov edi,0x00a0000
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

        mov [edi],eax

        dec ebp
        jnz lloop
        pop ebp
        ret


_TEXT  ends
       end
