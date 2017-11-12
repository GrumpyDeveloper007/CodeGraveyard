;
; Assembler routines for optimal performance from important loops
;
; NOTE THESE MAY NOT YET BE OPTIMISED FULLY

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

       public AsmVESACLS_

; AsmCLS variable VirtualScreen is passed to the routine in edi by the
;       very nice WATCOM compiler, thus the variable is not pushed nor
;       initialised (no need!) also ECX is set up with the length to
;       clear by the watcom compiler.

AsmVESACLS_:  ; void AsmVESACLS()
       push eax
       xor eax,eax
       align 4
Clear: mov fs:[edi],eax
       add edi,4                ; I`m told 1 cycle????
       dec ecx
       jnz Clear
       pop eax
       ret

       public AsmVESAUpdateScreenMem_

; ECX,EDI,ESI are passed by watcom Size,Dest,Source

AsmVESAUpdateScreenMem_:
       push eax
       sub edi,4          ; Possible removal of an AGI l8r
       align 4
Copy:  mov eax,[esi]
       add edi,4          ; This should remove a 486 AGI
       add esi,4          ; 1 cycle?
       mov FS:[edi],eax
       dec ecx
       jnz Copy
       pop eax
       ret

_TEXT  ends
       end
