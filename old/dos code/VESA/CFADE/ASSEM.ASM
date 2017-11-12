_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public AsmUpdateFade_
       public ASMSetParam_
        align 16
VirtualScreen dd 0
PhysicalScreen dd 0
ScreenLength dd 0

ASMSetParam_:
        mov [VirtualScreen],eax
        mov [PhysicalScreen],ebx
        mov [ScreenLength],ecx
        ret

; esi - buffera (source picture)
; ebp - bufferb (destnation picture)

; eax - loop counter
; ebx - plot buffer                                   
; ecx - tablea (256 byte aligned)
; edx - tableb (256 byte aligned) 

; edi - screen
        align 16
AsmUpdateFade_:
        push ebp
        mov ebp,ebx
        mov edi,[PhysicalScreen]
        mov eax,640*350/2
        lea edi,[edi-4]        ; allow pre incerement
        align 16
loopCC:
        mov cl,[esi]
        mov dl,[ebp]
        lea edi,[edi+4]        ; pre incerement
        mov bl,[ecx]
        add bl,[edx]

        mov cl,[esi+1]
        mov dl,[ebp+1]
        mov bh,[ecx]
        add bh,[edx]
        ror ebx,16

        mov cl,[esi+2]
        mov dl,[ebp+2]
        mov bl,[ecx]
        add bl,[edx]

        mov bh,0
        ror ebx,16

        mov [fs:edi],ebx

        mov cl,[esi+3]
        mov dl,[ebp+3]
        lea edi,[edi+4]        ; pre incerement
        mov bl,[ecx]
        add bl,[edx]

        mov cl,[esi+4]
        mov dl,[ebp+4]
        mov bh,[ecx]
        add bh,[edx]
        ror ebx,16

        mov cl,[esi+5]
        mov dl,[ebp+5]
        mov bl,[ecx]
        add bl,[edx]

        lea esi,[esi+6]   ; same speed as inc
        lea ebp,[ebp+6]

        mov bh,0
        ror ebx,16

        mov [fs:edi],ebx

        dec eax
        jnz loopCC

        pop ebp
        ret


_TEXT  ends
       end
