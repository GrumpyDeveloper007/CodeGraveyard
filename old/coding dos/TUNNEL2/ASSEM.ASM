; Assembler for tunnel ploting routine
; 
; NOTE: master class book is wrong !
; - inc esi,inc esi is faster than add esi,immediate

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public PlotTable2_
       public UpdateScreen2_
       public AsmWaitVBL_

; eax - Write buffer
; ebx - Temp offset into picture
; ecx - constant 2
; edx - Picture address
;
; esi - Table pointer
; edi - Destnation address
; ebp - loop counter
;
        mov eax,0x0a0000
        mov ebx,[eax]
        mov ebx,0x044332211
        mov eax,ebx
        bswap ebx
        bswap eax


PlotTable2_:
        push $00000000
        mov [eax],'D'
        push ebp
        mov ebp,ecx
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

; esi - source A
; edi - destnation
; edx - source B

UpdateScreen2_:
        mov ecx,64000/4
lllooP:
        mov eax,[esi]
        add esi,4
        or eax,[edx]
        add edx,4
        mov [edi],eax
        add edi,4
        dec ecx
        jnz lllooP
        ret

AsmWaitVBL_:  ; void AsmWaitVBL()
       push eax
       push edx
       mov edx,0x3da;
VRT:
       in al,dx;
       test al,8;
       jnz VRT;         //wait until Verticle Retrace starts
NoVRT:
       in al,dx;
       test al,8;
       jz NoVRT;       //wait until Verticle Retrace Ends
       pop edx
       pop eax
       ret

_TEXT  ends
       end
