;

_TEXT  SEGMENT PARA PUBLIC USE32 'CODE'
       assume CS:_TEXT

        public MergeMode1A_
        public SetFieldAddress_
        public Plot4BplTileA_
        public Plot2BplTileA_

BKGA1 dd 0
BKGA2 dd 0
BKGA3 dd 0
BKGA4 dd 0

DataStore dd 0
; DataStoreRef
_BG1HScrollData equ 0
_BG1VScrollData equ 2
_BG2HScrollData equ 4
_BG2VScrollData equ 6
_BG3HScrollData equ 8
_BG3VScrollData equ 10
_BG4HScrollData equ 12
_BG4VScrollData equ 14
                    
;////////////////////////////////////////////////////////////////////////////
;// 3 playfield version
SetFieldAddress_:
        mov BKGA1,eax
        mov BKGA2,ebx
        mov BKGA3,ecx
        mov BKGA4,edx
        mov DataStore,esi
        ret

MergeMode1A_    PROC
        push ebp
        pusha
     mov esi,DataStore
     mov edi,0x0a0000
     mov ebx,BKGA1
     mov ax,[esi+_BG1VScrollData]
     mov bh,al
     mov ax,[esi+_BG1HScrollData]
     mov bl,al
     mov ecx,BKGA2
     mov ax,[esi+_BG2VScrollData]
     mov ch,al
     mov ax,[esi+_BG2HScrollData]
     mov cl,al
     mov edx,BKGA3
     mov ax,[esi+_BG3VScrollData]
     mov dh,al
     mov ax,[esi+_BG3HScrollData]
     mov dl,al

     mov ebp,199
OuterLoop:
                                    
     mov esi,256/4
InnerLoop:

     mov al,[ebx]
     test al,al
     jne NonZero
     mov al,[ecx]
     test al,al
     jne NonZero
     mov al,[edx]
NonZero:
     ror eax,8

     mov al,[ebx+1]
     test al,al
     jne NonZero2
     mov al,[ecx+1]
     test al,al
     jne NonZero2
     mov al,[edx+1]
NonZero2:
     ror eax,8

     mov al,[ebx+2]
     test al,al
     jne NonZero3
     mov al,[ecx+2]
     test al,al
     jne NonZero3
     mov al,[edx+2]
NonZero3:
     ror eax,8

     mov al,[ebx+3]
     test al,al
     jne NonZero4
     mov al,[ecx+3]
     test al,al
     jne NonZero4
     mov al,[edx+3]
NonZero4:
     add bl,4
     add cl,4
     add dl,4
     ror eax,8

     mov [edi],eax
     add edi,4

     dec esi
     jnz InnerLoop

     add edi, 320-256
     inc bh
     inc ch
     inc dh
     dec ebp
     jnz OuterLoop

     popa
     pop ebp
     ret
MergeMode1A_    ENDP

; No mirror
; esi - TileAddress
; edi - ScreenAddress
Plot4BplTileA_  PROC
        pusha
        push ebp
        mov ebp,8       ; Yloop
YLoop:
;  Bp0=*(TileAddress+0);
;  Bp1=*(TileAddress+1);
;  Bp2=*(TileAddress+16);
;  Bp3=*(TileAddress+17);
        mov bx,[esi]    ; bp0 + bp1
        mov bh,[esi+1]  ; bp1
        mov cx,[esi+16] ; bp2 + bp3
        mov ch,[esi+17]
        mov edx,7       ; Shift
        push ebp
        mov ebp,8       ; Xloop
XLoop:
        xor eax,eax
        bt bx,dx
        jnc   Pixel1
        inc al
pixel1:
        bt cx,dx
        jnc Pixel3
        add al,4
Pixel3:
        add dx,8
        bt bx,dx
        jnc Pixel2
        add al,2
Pixel2:
        bt cx,dx
        jnc Pixel4
        add al,8
Pixel4:
        sub dx,1+8
        mov [edi],al
        inc edi

        dec ebp
        jne XLoop
        pop ebp

        add edi,256-8
        add esi,2

        dec ebp
        jne YLoop
        pop ebp
        popa
        ret
Plot4BplTileA_  ENDP    

; No mirror
; esi - TileAddress
; edi - ScreenAddress
Plot2BplTileA_  PROC
        pusha
        push ebp
        mov ebp,8       ; Yloop
Plot2BplYLoop:
;  Bp0=*(TileAddress+0);
;  Bp1=*(TileAddress+1);
        mov bx,[esi]    ; bp0 + bp1 -------------- i'm not sure about this
        mov cl,bh       ; bp1
        mov edx,7       ; Shift
        push ebp
        mov ebp,8       ; Xloop
Plot2BplXLoop:
        xor eax,eax

        bt bx,dx
        jnc   Plot2BplPixel1
        inc al
Plot2Bplpixel1:
        bt cx,dx
        jnc Plot2BplPixel3
        add al,2
Plot2BplPixel3:
        sub dx,1
        mov [edi],al
        inc edi

        dec ebp
        jne Plot2BplXLoop
        pop ebp

        add edi,256-8
        add esi,2

        dec ebp
        jne Plot2BplYLoop
        pop ebp
        popa
        ret
Plot2BplTileA_  ENDP    


_TEXT  ends
       end
