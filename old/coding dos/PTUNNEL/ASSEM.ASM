; Assembler for tunnel ploting routine
; 
; NOTE: master class book is wrong !
; - inc esi,inc esi is faster than add esi,immediate

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT
       assume DS:_TEXT

       public AsmPlotTable_
       public AsmCopyPic_

AsmPlotTable_:
        pushad
        push ebp
        mov ebp,ecx
        mov edi,0x00a0000
        add edx,eax
        xor eax,eax
        xor ebx,ebx
        mov ecx,2

        lea edi,[edi-4]         ; allows post decrement
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
        popad
        ret

AsmCopyPic_:
        push edi
        push ecx
        push eax
        mov edi,esi
        mov ecx,65535/4
        add edi,65535
        align 16
CLoop:
        mov eax,[esi]
        lea esi,[esi+4]
        mov [edi],eax
        lea edi,[edi+4]
        dec ecx
        jnz CLoop
        pop eax
        pop ecx
        pop edi
        ret

_TEXT  ends
       end
