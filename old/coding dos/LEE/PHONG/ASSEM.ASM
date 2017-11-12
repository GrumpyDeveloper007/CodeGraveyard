_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public AsmInitParams_
       public AsmScanConvEdgeWin_
       public AsmScanConvEdgeWinG_
       public AsmClearScanBuffer_

WINTOP  equ    0      ; //40)
WINBOTTOM equ  199    ; //160)
WINRIGHT equ  319  ;//240)

ScanBufferLPTR  dd 0
ScanBufferRPTR  dd 0
YMinPTR dd 0
YMaxPTR dd 0

GraphicPTR dd 0
ScreenTempPTR dd 0
LightTablePTR dd 0

ASMClearScanBuffer_:
        pusha
        mov ecx,200/4
        mov eax,319*65536+319
        mov ebx,0
        mov edx,8
loopforwhat:
        mov [esi],eax
        mov [edi],ebx
        mov [esi+4],eax
        mov [edi+4],ebx
        add esi,edx
        add edi,edx

        dec ecx
        jnz loopforwhat

        popa
        ret


; Params - eax-ScanbufferLeft (PTR), ebx-ScanBufferRight (PTR)
;          ecx-&YMin, edx-&YMax
;          esi-ScreenTemp, edi-GraphicPointer
ASMInitParams_:
        mov [GraphicPTR],edi
        mov [ScreenTempPTR],esi
        mov [ScanBufferLPTR],eax
        mov [ScanBufferRPTR],ebx
        mov [YMinPTR],ecx
        mov [YMaxPTR],edx
        ret
; eax-LightTablePTR       
ASMInitParams2_:
        mov [LightTablePTR],eax
        ret

;-------------------------------------------------------------------------

; To convert stanard polygon
; eax - x1, ebx - y1, ecx - x2, edx - y2
ASMScanConvEdgeWin_:
        push edi
        push esi
        push ebp

        cmp ebx,edx
        jle  Skip1
        mov ebp,eax
        mov eax,ecx
        mov ecx,ebp

        mov ebp,ebx
        mov ebx,edx
        mov edx,ebp
Skip1:
; if(y1 > y2) // make sure that edge goes from top to bottom
;  {
;  temp=x1;  // we need to swap the coordinates around
;  x1=x2;
;  x2=temp;
;  temp=y1;
;  y1=y2;
;  y2=temp;
;  }

        mov edi,[YMinPTR]
        cmp bx,[edi]
        jge  Skip2
        mov [edi],bx
Skip2:
; if (y1<YMin)
;  YMin=y1;

        mov edi,[YMaxPTR]
        cmp dx,[edi]
        jle  Skip3
        mov [edi],dx
Skip3:
; if (y2>YMax)
;  YMax=y2;

        cmp ebx,edx
        je Skip4

        sub ecx,eax     ; (x2-x1)<<16
        sal ecx,16
        mov ebp,edx
        sub ebp,ebx     ; ebp = (y2-y1)
        push eax        ; shit i dont know how divide works
        mov eax,ecx
        cdq
        idiv ebp
        add ebp,ebx     ; ebp = (y2-y1)+y1
        mov edx,eax     ; edx = MX

        pop eax

        sal eax,16
; x=Int2Fixed(x1); // I dont understand why this is done

; Scanbuffer pointers
        mov esi,[ScanBufferLPTR]
        mov edi,[ScanBufferRPTR]

; :: For (y1 to y2) - eax = x, ebx = y, ecx = , edx = MX
; :: ebp =y2 (end loop)
; :: esi - ScanBufferLeft PTR, edi - ScanBufferRight PTR
LoopMe:
        cmp ebx,ebp
        jg  EndMe
; for(y=y1;y<=y2;y++)

        cmp ebx,WinTop
        jle  NoPlot
        cmp ebx,WinBottom
        jge  NoPlot
;  if (y>=WINTOP && y<=WINBOTTOM)

        ror eax,16
        cmp ax,[esi+ebx*2]        ; not sure about the conditions
        jg NotPlot
        mov [esi+ebx*2],ax
NotPlot:
;   if (Fixed2Int(x)<ScanBufferLeft[y]) ScanBufferLeft[y]=(Fixed2Int(x));

        cmp ax,[edi+ebx*2]
        jl NotPlot2
        mov [edi+ebx*2],ax
;   if (Fixed2Int(x)>ScanBufferRight[y]) ScanBufferRight[y]=(Fixed2Int(x));
NotPlot2:
        rol eax,16
NoPlot:
        add eax,edx
;  x+=mx;

        inc ebx    ;for (y++)
        jmp LoopMe
EndMe:
        pop ebp
        pop esi
        pop edi
        ret
; ----------------------------------------
; Source opened out for speed optimization
;  -- No loop because y1=y2
Skip4:
        sal eax,16

; Scanbuffer pointers
        mov esi,[ScanBufferLPTR]
        mov edi,[ScanBufferRPTR]

; :: For (y1 to y2) - eax = x, ebx = y, ecx = , edx = 
; :: esi - ScanBufferLeft PTR, edi - ScanBufferRight PTR

        cmp ebx,WinTop
        jle  NoPlotA
        cmp ebx,WinBottom
        jge  NoPlotA
;  if (y>=WINTOP && y<=WINBOTTOM)

        ror eax,16
        cmp ax,[esi+ebx*2]        ; not sure about the conditions
        jg NotPlotA
        mov [esi+ebx*2],ax
NotPlotA:
;   if (Fixed2Int(x)<ScanBufferLeft[y])  ScanBufferLeft[y]=(Fixed2Int(x));

        cmp ax,[edi+ebx*2]
        jl NotPlot2A
        mov [edi+ebx*2],ax
;   if (Fixed2Int(x)>ScanBufferRight[y]) ScanBufferRight[y]=(Fixed2Int(x));
NotPlot2A:
NoPlotA:
        pop ebp
        pop esi
        pop edi
        ret
;---------------------------------------------------------------------------


;// this one is for real light sourcing  ( KEWL HUH! )
; This assembler optimization uses a lot of hope conserning varible locations
; (the light tables (Left/Right) must be allocated directly after the Scan
; buffers. 
; eax - x1, ebx - y1, ecx - x2, edx - y2, esi - Light1, edi- Light2
Light1 dd 0
Light2 dd 0
ML dd 0
L dd 0
ASMScanConvEdgeWinG_:
        pusha
        push ebp
        sal esi,16      ; Convert to fixed point
        sal edi,16
        mov [Light1],esi
        mov [Light2],edi

        cmp ebx,edx
        jle  ASkip1
        mov ebp,eax
        mov eax,ecx
        mov ecx,ebp

        mov ebp,ebx
        mov ebx,edx
        mov edx,ebp

        mov esi,[Light1]
        mov edi,[Light2]
        mov [Light1],edi
        mov [Light2],esi
ASkip1:
; if(y1 > y2) // make sure that edge goes from top to bottom
;  {
;  temp=x1;  // we need to swap the coordinates around
;  x1=x2; x2=temp;
;  temp=y1; y1=y2; y2=temp; Light1=Light2 + Light2=Light1
;  }

        mov edi,[YMinPTR]
        cmp bx,[edi]
        jge  ASkip2
        mov [edi],bx
ASkip2:
; if (y1<YMin)
;  YMin=y1;

        mov edi,[YMaxPTR]
        cmp dx,[edi]
        jle  ASkip3
        mov [edi],dx
ASkip3:
; if (y2>YMax)
;  YMax=y2;

        cmp ebx,edx
        je ASkip4

        sub ecx,eax     ; (x2-x1)<<16
        sal ecx,16
        mov ebp,edx
        sub ebp,ebx     ; ebp = (y2-y1)
        push eax        ; shit i dont know how divide works
        mov eax,ecx
        cdq
        idiv ebp
;        push eax
;        mov eax,[Light1]
;        sub eax,[Light2]
;        cdq
;        idiv ebp
;        mov [ML],eax
;        pop eax
        add ebp,ebx     ; ebp = (y2-y1)+y1
        mov edx,eax     ; edx = MX
;  ml = (Int2Fixed(light2-light1)) / (y2-y1); //dl/dy
;  ML = Light difference / distance between point A,B
        pop eax
; Do ML shit

        sal eax,16
; x=Int2Fixed(x1); // I dont understand why this is done

; Scanbuffer pointers
        mov esi,[ScanBufferLPTR]
        mov edi,[ScanBufferRPTR]
        mov ecx,[Light1]

; :: For (y1 to y2) - eax = x, ebx = y, ecx = , edx = MX
; :: ebp =y2 (end loop)
; :: esi - ScanBufferLeft PTR, edi - ScanBufferRight PTR
ALoopMe:
        cmp ebx,ebp
        jg  AEndMe
; for(y=y1;y<=y2;y++)

        cmp ebx,WinTop
        jle  ANoPlot
        cmp ebx,WinBottom
        jge  ANoPlot
;  if (y>=WINTOP && y<=WINBOTTOM)

        ror eax,16
        ror ecx,16
        cmp ax,[esi+ebx*2]        ; not sure about the conditions
        jg ANotPlot
        mov [esi+ebx*2],ax
        mov [esi+ebx+400],cl
ANotPlot:
;   if (Fixed2Int(x)<ScanBufferLeft[y]) ScanBufferLeft[y]=(Fixed2Int(x));
; LightBufferLeft=l
        cmp ax,[edi+ebx*2]
        jl ANotPlot2
        mov [edi+ebx*2],ax
        mov [edi+ebx+400],cl
;   if (Fixed2Int(x)>ScanBufferRight[y]) ScanBufferRight[y]=(Fixed2Int(x));
; LightBufferRight=l
ANotPlot2:
        ror ecx,16
        rol eax,16
ANoPlot:
        add eax,edx
        add ecx,[ML]
;  x+=mx; l+=ML

        inc ebx    ;for (y++)
        jmp ALoopMe
AEndMe:
        pop ebp
        popa
        ret
; ----------------------------------------
; Source opened out for speed optimization
;  -- No loop because y1=y2
ASkip4:
        sal eax,16

; Scanbuffer pointers
        mov esi,[ScanBufferLPTR]
        mov edi,[ScanBufferRPTR]
        mov ecx,[Light1]

; :: For (y1 to y2) - eax = x, ebx = y, ecx = , edx = 
; :: esi - ScanBufferLeft PTR, edi - ScanBufferRight PTR

        cmp ebx,WinTop
        jle  ANoPlotA
        cmp ebx,WinBottom
        jge  ANoPlotA
;  if (y>=WINTOP && y<=WINBOTTOM)

        ror ecx,16
        ror eax,16
        cmp ax,[esi+ebx*2]        ; not sure about the conditions
        jg ANotPlotA
        mov [esi+ebx*2],ax
        mov [esi+ebx+400],cl
ANotPlotA:
;   if (Fixed2Int(x)<ScanBufferLeft[y])  ScanBufferLeft[y]=(Fixed2Int(x));

        cmp ax,[edi+ebx*2]
        jl ANotPlot2A
        mov [edi+ebx*2],ax
        mov [edi+ebx+400],cl
;   if (Fixed2Int(x)>ScanBufferRight[y]) ScanBufferRight[y]=(Fixed2Int(x));
ANotPlot2A:
ANoPlotA:
        pop ebp
        popa
        ret
;---------------------------------------------------------------------------


_TEXT  ends
       end
