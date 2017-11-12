; Assembler for tunnel ploting routine
; 
; NOTE: master class book is wrong !
; - inc esi,inc esi is faster than add esi,immediate

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public AsmPlotFire_
       public AsmPlotFire2_
       public AsmCopyPic_

       public AsmPlotTable_

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

AsmPlotFire_:
        pushad
        mov ecx,65536
        xor ebx,ebx
        xor edx,edx
        align 16
lloopf1:
        xor eax,eax
        mov bl,[esi-1]
        mov dl,[esi]
        add eax,ebx
        add eax,edx
        mov bl,[esi+1]
        mov dl,[esi+255]        ;+320-1
        add eax,ebx
        add eax,edx

        mov bl,[esi+256]
        mov dl,[esi+257]        ;+320+1
        add eax,ebx
        add eax,edx
        mov bl,[esi+511]        ; +640-1
        mov dl,[esi+513]        ;+640+1
        add eax,ebx
        add eax,edx

        shr eax,3               ; divide by 8
        mov [edi],al

        inc esi
        inc edi

        dec ecx
        jnz lloopf1
        popad
        ret

AsmPlotFire2_:
        pushad
        push ebp
        mov ebp,65536/4
        xor ebx,ebx
        xor edx,edx
        xor eax,eax
        align 16
lloop2:

        mov al,[esi-1]
        mov dl,[esi+255]        ;+320-1
        add eax,edx
        mov bl,[esi+1]
        mov dl,[esi]
        add ebx,edx
        add eax,ebx

        shr eax,2               ; divide by 4
        mov [edi],al
        inc edi

        mov dl,[esi+2]
        mov al,[esi+256+1]        ;+320-1
        add ebx,eax
        add ebx,edx

        shr ebx,2               ; divide by 4
        mov [edi],bl
        inc edi

        mov al,[esi+3]
        mov dl,[esi+256+2]        ;+320-1
        add eax,edx
        mov bl,[esi+1]
        mov dl,[esi+2]
        add ebx,edx
        add eax,ebx

        shr eax,2               ; divide by 4
        mov [edi],al
        inc edi

        mov al,[esi+4]
        mov dl,[esi+256+3]        ;+320-1
        add ebx,edx
        add ebx,eax

        shr ebx,2               ; divide by 4
        mov cl,bl

        mov [edi],bl
        inc edi

        lea esi,[esi+4]

        dec ebp
        jnz lloop2
        pop ebp
        popad
        ret

AsmCopyPic_:
        push ecx
        push eax
        mov edi,esi
        add edi,65536
        mov ecx,65536/4
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
        ret

_TEXT  ends
       end
