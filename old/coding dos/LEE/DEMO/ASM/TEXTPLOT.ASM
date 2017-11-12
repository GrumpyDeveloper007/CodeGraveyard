;
; BNOTE: kinda hard writing assembler programs when the assenbler cannot
; assemble ! either that or the assembler is assembling 286 code
;  just try j<condition> instruction - on 286- only 256 byte offset alowed
;  386+ larger loops alowed. (SHIT PC)

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public TextPlot_
       public TextPlot2_
       public InitParamsT_
       public InitParamsT2_
       public PlotFont_
       public AsmUpdateFade_
       public AsmWaitVBL_

       public CLS_
       public AsmUpdateScreen_
       public UpdateScreen2_
       public Slide_

VirtualScreen dd 0
AlignedPointer dd 0
va       dd 0
vb       dd 0
vc       dd 0
FVa     dd 0
FVb     dd 0
FVc     dd 0
FHa     dd 0
FHb     dd 0

v       dd 0
dv      dd 0

TempPicture dd 0 ; Tempory picture address used in - slide
ScreenX equ 320
FontX equ 16
FontY equ 16
; eax - character
; ebx - read buffer
; ecx - X loop counter
; edx - Y loop counter

; esi - address of font
; edi - address to plot to (screen)
PlotFont_:
        push ebx
        push ecx
        push edx
;  for (int y=0;y<16;y++)
;   for (int x=0;x<16;x++)
;    if (FONT16[x+y*16]!=0)
;     VirtualScreen[x+32+y*320]=(FONT16[x+y*16]);

        shl eax,8      ; Size of font is 16*16
        add esi,eax

        mov edx,FontY  ; Size Y
YLoop:
        mov ecx,FontX/4  ; Size X
XLoop:
        mov ebx,[esi]
        cmp bl,0
        je NOPlot
        mov [edi],bl
NoPlot:
        cmp bh,0
        je NOPlot2
        mov [edi+1],bh
NoPlot2:
        ror ebx,16
        cmp bl,0
        je NOPlot3
        mov [edi+2],bl
NoPlot3:
        cmp bh,0
        je NOPlot4
        mov [edi+3],bh
NoPlot4:
        add esi,4
        add edi,4
        dec ecx
        jnz XLoop
        add edi,ScreenX-FontX

        dec edx
        jnz YLoop

        pop edx
        pop ecx
        pop ebx
        ret



TextPlot_:

; edi - destination for screen
; esi - loop count
; edx - Textaddress (top 16 bits.. must be 64k aligned!)+(whole v)<<8+whole u
; ebx - (fraction u) << 24 + 0<<16 + (whole v)<<8 + (fraction v)
; ecx - (fraction du) << 24 + (0 or FF see above) << 16 + (whole dv) << 8 +(fraction dv)
; eax - Used to hold pixels for plotting to screen
; ebp - whole delta U

; Loop is unrolled * 4 to allow 4 pixels update at once
;  I hope... 

    push ebp    ; We use this so it must be saved
    mov ebp,eax ; I had to pass the variable in eax !

    align 16
LOOPP:
    lea  edi,[edi+4]
    mov   al, [edx]     ; Get texel
    add   ebx, ecx      ; Update texture coords
    adc   dx, bp        ; update texture coords
    mov   dh, bh        ; update whole v part of texture

    mov   ah, [edx]     ; Get texel
    add   ebx, ecx      ; Update texture coords
    adc   dx, bp        ; update texture coords
    ror   eax,16         ; 
    mov   dh, bh        ; update whole v part of texture

    mov   al, [edx]     ; Get texel
    add   ebx, ecx      ; Update texture coords
    adc   dx, bp        ; update texture coords
    mov   dh, bh        ; update whole v part of texture

    mov   ah, [edx]     ; Get texel
    add   ebx, ecx      ; Update texture coords
    adc   dx, bp        ; update texture coords
    ror   eax,16         ; 
    mov   dh, bh        ; update whole v part of texture

    mov   [edi], eax    ; update screen (4 pixels)
    dec   esi           ; dec loop count
    jnz   LOOPP         ; loop

    pop ebp     ; Remove temporary variable
    ret

;//////////////////////////
TextPlot2_:
        push ebp
        mov [va],eax
        mov [vb],ebx
        mov [vc],ecx
        mov [FVa],edx
        mov [FVb],esi
        mov [FVc],edi

        mov ebp,0

        align 16
; for (j=0;j<200;j++)
MainLoop:
        mov eax,[FVa]
        add [va],eax
;  a+=FVa;
        mov eax,[FVb]
        add [vb],eax
;  b+=FVb;
        mov eax,[FVc]
        add [vc],eax
;  c+=FVc;

        mov ebx,[vc]
        cmp ebx,0
        jne NoneZero
        mov eax,[FVc]
        add ebx,[FVc]
        mov [vc],ebx
NoneZero:
;  if (c==0)
;   c+=FVc;

; divides - eax,edx,ebx-constant Vc 
        mov edx,[vb]
        xor eax, eax            
        shrd eax, edx, 16       
        sar edx, 16             
        idiv ebx                
        mov [v],eax
;  v  = (FixedDiv(b,c));

        mov edx,[FHb]
        xor eax, eax            
        shrd eax, edx, 16       
        sar edx, 16             
        idiv ebx
        sar eax,8
        mov [dv],eax
;  dv = (FixedDiv(FHb,c))>>8;

        mov edx,[FHa]
        xor eax, eax            
        shrd eax, edx, 16       
        sar edx, 16             
        idiv ebx
        sar eax,8
        mov ecx,eax
;  du = (FixedDiv(FHa,c))>>8;

        mov edx,[va]
        xor eax, eax
        shrd eax, edx, 16
        sar edx, 16
        idiv ebx
        mov ebx,eax
;  u  = (FixedDiv(a,c));

        mov eax,ecx
;  TextPlot -
; eax - du
; ebx - u
; ecx - du
; edx - v
; esi - 320/4
; edi - Destnation pointer

;           ((long)(AlignedPointer))+(v&0xff00)+((u&0xff00)>>8), // edx
        mov edx,[v]
        and edx,0x0000FF00
        mov dl,bh
        add edx,[AlignedPointer]

;           ((u&0xff)<<24)+(v&0xffff),                  // ebx
        shl ebx,24
        mov bx,word ptr [v]

;           ((du&0xff)<<24)+(dv&0xffff),               // ecx
        shl ecx,24
        mov cx,word ptr [dv]

;           ((du&0xff00)>>8));                                   // eax
        shr eax,8
        and eax,0x0ff

;           320>>2,                                               // esi
        mov esi,320/4

; (VirtualScreen+j*320-4),                           // edi
        mov edi,[VirtualScreen]
        lea edi,[edi+ebp-4]

; edi - destination for screen
; esi - loop count
; edx - Textaddress (top 16 bits.. must be 64k aligned!)+(whole v)<<8+whole u
; ebx - (fraction u) << 24 + 0<<16 + (whole v)<<8 + (fraction v)
; ecx - (fraction du) << 24 + (0 or FF see above) << 16 + (whole dv) << 8 +(fraction dv)
; eax - Used to hold pixels for plotting to screen
; ebp - whole delta U

; Loop is unrolled * 4 to allow 4 pixels update at once
;  I hope... 

    push ebp    ; We use this so it must be saved
    mov ebp,eax ; I had to pass the variable in eax !

    align 16
LOOPPS:
    lea  edi,[edi+4]
    mov   al, [edx]     ; Get texel
    add   ebx, ecx      ; Update texture coords
    adc   dx, bp        ; update texture coords
    mov   dh, bh        ; update whole v part of texture

    mov   ah, [edx]     ; Get texel
    add   ebx, ecx      ; Update texture coords
    adc   dx, bp        ; update texture coords
    ror   eax,16         ; 
    mov   dh, bh        ; update whole v part of texture

    mov   al, [edx]     ; Get texel
    add   ebx, ecx      ; Update texture coords
    adc   dx, bp        ; update texture coords
    mov   dh, bh        ; update whole v part of texture

    mov   ah, [edx]     ; Get texel
    add   ebx, ecx      ; Update texture coords
    adc   dx, bp        ; update texture coords
    ror   eax,16         ; 
    mov   dh, bh        ; update whole v part of texture

    mov   [edi], eax    ; update screen (4 pixels)
    dec   esi           ; dec loop count
    jnz   LOOPPS         ; loop

    pop ebp     ; Remove temporary variable

        add ebp,320
        cmp ebp,200*320
        je ShitAssembler
        jmp Mainloop

ShitAssembler:
        pop ebp
        ret


InitParamsT_:
        mov [AlignedPointer],eax
        mov [VirtualScreen],ebx
        ret

InitParamsT2_:
        mov [FHa],ecx
        mov [FHb],edx
        ret




;//////////////////////////


; AsmWaitVBL - Wait for retrace before updating screen


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

; esi - buffera
; ebx - bufferb
; ecx - tablea
; edx - tableb

; edi - screen
; ebp - bufferb

AsmUpdateFade_:
        push ebp
        mov ebp,ebx
        mov edi,0x0a0000
        mov eax,64000/4
        lea edi,[edi-4]        ; allow pre incerement
        align 16
loopCC:
        mov cl,[esi]
        mov dl,[ebp]
        inc esi
        inc ebp
        lea edi,[edi+4]        ; pre incerement
        mov bl,[ecx]
        add bl,[edx]

        mov cl,[esi]
        mov dl,[ebp]
        inc ebp
        inc esi
        mov bh,[ecx]
        add bh,[edx]
        ror ebx,16

        mov cl,[esi]
        mov dl,[ebp]
        inc ebp
        inc esi
        mov bl,[ecx]
        add bl,[edx]

        mov cl,[esi]
        mov dl,[ebp]
        inc ebp
        inc esi
        mov bh,[ecx]
        add bh,[edx]
        ror ebx,16

        mov [edi],ebx

        dec eax
        jnz loopCC

        pop ebp
        ret


; AsmCLS variable VirtualScreen is passed to the routine in edi by the
;       very nice WATCOM compiler, thus the variable is not pushed nor
;       initialised (no need!)

CLS_:
       push ecx
       push eax
       mov ecx,16000
       xor eax,eax
       align 16
Clear: mov [edi],eax
       add edi,4
       dec ecx
       jnz Clear
       pop eax
       pop ecx
       ret
        

; AsmUpdateScreen variables VirtualScreen and ScreenPtr are passed 
;       by the WATCOM compiler, thus the variables are not pushed nor
;       initialised (no need!)

AsmUpdateScreen_: ; void AsmUpdateScreen()
               push ecx
               push eax
               mov ecx,16000
               sub edi,4          ; Possible removal of an AGI l8r
               align 16
Copy:          mov eax,[esi]
               add edi,4          ; This should remove a 486 AGI
               add esi,4          ; 1 cycle?
               mov [edi],eax
               dec ecx
               jnz Copy
               pop eax
               pop ecx
               ret

; esi - source A
; edi - destnation

; eax - buffer
; ebx -
; ecx - Loop counter
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


; esi - Picture
; edi - Screen address
; ecx - Angle
; edx - 

; ebp - MaxAngle
Slide_:
        push ebp
        mov eax,0
        mov ebp,edx
        mov [TempPicture],esi

;  for (i=0;i<200;i++)
;   {
        mov ebx,0
SlideYLoop:
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
SlideXLoop:
;    Screen[ymul+t]=Buffer1[t+ydif];
        mov eax,[esi]
        mov [edi],eax

        add esi,4
        add edi,4

        dec bx
        jnz SlideXLoop

        ror ebx,16
        inc bx
        cmp bx,200
        jne SlideYLoop


        pop ebp
        ret


_TEXT  ends
       end
