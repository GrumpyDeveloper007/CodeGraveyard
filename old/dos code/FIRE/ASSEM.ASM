; Assembler for tunnel ploting routine
; 

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public AsmPlotFire_
       public AsmPlotFire2_
       public AsmCopyPic_

AsmPlotFire_:
        pushad
        push ebp
        mov ecx,64000/2
        xor ebx,ebx
        xor edx,edx
        xor eax,eax
        align 16
lloop1:
        mov al,[esi-1]
        mov dl,[esi]
        mov bl,[esi+1]
        mov ebp,edx             ;/
        mov dl,[esi+319]        ;+320-1
        add ebp,ebx
        add eax,edx

        mov bl,[esi+320]
        mov dl,[esi+321]        ;+320+1
        add ebp,ebx
        add ebp,edx
        mov bl,[esi+639]        ; +640-1
        mov dl,[esi+641]        ;+640+1
        add eax,ebx
        add eax,edx

        add eax,ebp

        shr eax,3               ; divide by 8
        mov [edi],al

        inc edi

;2
        mov al,[esi+2]
        mov dl,[esi+320]        ;+320-1
        add ebp,eax
        add ebp,edx
              
        mov bl,[esi+640]        ; +640-1
        mov dl,[esi+642]        ;+640+1
        add ebp,ebx
        add ebp,edx

        shr ebp,3               ; divide by 8
        mov eax,ebp
        mov [edi],al

        inc esi
        inc esi
        inc edi

        loop lloop1
;        dec ecx
;        jnz lloop1
        pop ebp
        popad
        ret

AsmPlotFire2_:
        pushad
        push ebp
        mov ebp,64000/4
        xor ebx,ebx
        xor edx,edx
        xor eax,eax
        align 16
lloop2:

        mov al,[esi-1]
        mov dl,[esi+320]        ;+320-1
        add eax,edx
        mov bl,[esi+1]
        mov dl,[esi]
        add ebx,edx
        add eax,ebx

        shr eax,2               ; divide by 4
        mov [edi],al
        inc edi

        mov dl,[esi+2]
        mov al,[esi+320+1]        ;+320-1
        add ebx,eax
        add ebx,edx

        shr ebx,2               ; divide by 4
        mov [edi],bl
        inc edi

        mov al,[esi+3]
        mov dl,[esi+320+2]        ;+320-1
        add eax,edx
        mov bl,[esi+1]
        mov dl,[esi+2]
        add ebx,edx
        add eax,ebx

        shr eax,2               ; divide by 4
        mov [edi],al
        inc edi

        mov al,[esi+4]
        mov dl,[esi+320+3]        ;+320-1
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
        push esi
        push edi
        push ecx
        push eax
        mov ecx,64000/4
        mov edi,0x0a0000
        align 16
CLoop:
        mov eax,[esi]
        add esi,4
        mov [edi],eax
        add edi,4
        dec ecx
        jnz CLoop
        pop eax
        pop ecx
        pop edi
        pop esi
        ret




_TEXT  ends
       end
