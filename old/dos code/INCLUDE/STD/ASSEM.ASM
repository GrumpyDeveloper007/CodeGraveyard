; Standard functions 
;
;
;
_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public AsmWaitVBL_
       public Copy_



Copy_:
        push ebx
        shr eax,2      
CopyLoop:    
        mov ebx,[esi]
        lea esi,[esi+4]
        mov [edi],ebx
        lea edi,[edi+4]
        dec eax
        jnz CopyLoop
        pop ebx 
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
