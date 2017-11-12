_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public Slide_
       public AsmWaitVBL_

; esi - Picture
; edi - Screen address
; ecx - Angle
; edx - 

; ebp - MaxAngle
TempPicture dd 0
Slide_:
        push ebp
        mov eax,0
        mov ebp,edx
        mov [TempPicture],esi

;  for (i=0;i<200;i++)
;   {
        mov ebx,0
YLoop:
        xor eax,eax
        mov ax,bx
        ror ebx,16
        mov bx,320/4

;   ydif=((i*Angle/MaxAngle)%200)*320;
        mul ecx
        div ebp
        mov edx,320
        mul edx

        add eax,[TempPicture]
        mov esi,eax
;   for (t=0;t<320;t++)
XLoop:
;    Screen[ymul+t]=Buffer1[t+ydif];
        mov eax,[esi]
        mov [edi],eax

        add esi,4
        add edi,4

        dec bx
        jnz XLoop

        ror ebx,16
        inc bx
        cmp bx,200
        jne YLoop


        pop ebp
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
