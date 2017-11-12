;
; Assembler routines for optimal performance from important loops
;
; NOTE THESE MAY NOT YET BE OPTIMISED FULLY

_TEXTVideo  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXTVideo

        public AsmCLS_
        public AsmUpdateScreen_
        public SetCol_



SetCol_:
        mov    dx,0x03c8
;        mov    al,[col]      ;Colour number                   
        out    dx,al
        inc    dx
;        mov    al,[r]        ;Red element
        out    dx,al
;        mov    al,[g]        ;Green element
        out    dx,al
;        mov    al,[b]        ;Blue element
        out    dx,al
        ret

; AsmCLS variable VirtualScreen is passed to the routine in edi by the
;       very nice WATCOM compiler, thus the variable is not pushed nor
;       initialised (no need!)

AsmCLS_:  ; void AsmCLS()
       push ecx
       push eax
       mov ecx,16000
       xor eax,eax
       align 4
Clear: mov [edi],eax
       add edi,4                ; I`m told 1 cycle????
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
               align 4
Copy:          mov eax,[esi]
               add edi,4          ; This should remove a 486 AGI
               add esi,4          ; 1 cycle?
               mov [edi],eax
               dec ecx
               jnz Copy
               pop eax
               pop ecx
               ret

_TEXTVideo  ends
       end
