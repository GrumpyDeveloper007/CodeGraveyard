	# 1 "spc.S"
































	.long	
	.balign 16
	.globl SPC_Cycles
SPC_Cycles:	.long	0		 

SPC_PAGE:	.word	0
SPC_SP:	.word	0
SPC_PC:	.word	0
SPC_PSW:	.word	0		 
SPC_A:	.byte	0
SPC_X:	.byte	0
SPC_Y:	.byte	0

	.globl SPC_PORT_0_R
SPC_PORT_0_R:	.byte	0
	.globl SPC_PORT_1_R
SPC_PORT_1_R:	.byte	0
	.globl SPC_PORT_2_R
SPC_PORT_2_R:	.byte	0
	.globl SPC_PORT_3_R
SPC_PORT_3_R:	.byte	0
	.globl SPC_PORT_0_W
SPC_PORT_0_W:	.byte	0
	.globl SPC_PORT_1_W
SPC_PORT_1_W:	.byte	0
	.globl SPC_PORT_2_W
SPC_PORT_2_W:	.byte	0
	.globl SPC_PORT_3_W
SPC_PORT_3_W:	.byte	0

SPC_TIMER0:	.byte   0                
SPC_TIMER1:	.byte   0
SPC_TIMER2:	.byte   0

SPC_DSP_ADDR:	.byte	0
SPC_DSP_DATA:	.byte	0

SPC_TEMP:	.byte	0

_sA:	.byte 0
_sX:	.byte 0
_sY:	.byte 0

_sSP:	.byte 0
_sPC:	.word 0

_f_V:	.byte	0
_f_Z:	.byte	0
_f_N:	.byte	0
_f_P:	.byte	0
_f_C:	.byte	0

_sPC_base:	.long 0

SPC_LOOP_ADDRESS:	.word	0	 
SPC_DECODE_COUNT:	.byte	0
	.balign 16
SPC_DECODE_LENGTH:	.long	0	 

	.globl SPC_MASK
SPC_MASK:	.byte	0xFF		 

	.text
	.balign 16				 




















































	.align	4
SPC_read:
	cmpl $0x0100, %edx
	jl 0f
	movb (%ebp, %edx), %al
	ret

	0:     cmpl $0x00f0, %edx
	jge 0f
	movb (%ebp, %edx), %al
	ret

	0:
	pusha
	movl %esi,%edi
	andl $0x0000000F,%edi
	call  Read_Func_Map(,%edi,4)
	movb %al,SPC_TEMP
	popa
	movb SPC_TEMP,%al
	ret

	.align	4
SPC_write:
	cmpl $0x00f0, %edx
	jge 0f
	movb %al, (%ebp, %edx)
	ret

	0:     cmpl $0x0100, %edx
	jl 0f
	cmpl $0xFFC0, %edx
	jge 1f

	movb %al, (%ebp, %edx)
	1:     ret

	0:
	pusha
	movl %esi,%edi
	andl $0x0000000F,%edi
	call  Write_Func_Map(,%edi,4)
	popa
	ret



	FUNC(_Reset_SPC)
	ENTER

	movl $64,%eax		 
	movl _SPCAddress,%edi	 
	addl $0xFFC0,%edi
	movl $SPC_ROM_CODE,%esi
	0:	movb (%esi),%cl
	movb %cl,(%edi)
	incl %esi
	incl %edi
	decb %eax
	jnz 0b

	movl $0,SPC_Cycles		 
	movb $0,_f_V
	movb $0,_f_Z
	movb $0,_f_N
	movb $0,_f_P
	movb $0,_f_C
	movb $0,_sA
	movb $0,_sX
	movb $0,_sY
	movb $0xFF,sSP

	movb $0xff,SPC_PORT_0_W
	movb $0xff,SPC_PORT_1_W
	movb $0xff,SPC_PORT_2_W
	movb $0xff,SPC_PORT_3_W
	movb $0,_SPC_CTRL
	movb $0xff,_SPC_CNT0
	movb $0xff,_SPC_CNT1
	movb $0xff,_SPC_CNT2
	movb $0,_SPC_TIM0
	movb $0,_SPC_TIM1
	movb $0,_SPC_TIM2
	movb $0,_SPC_TIMT0
	movb $0,_SPC_TIMT1
	movb $0,_SPC_TIMT2
	movb $0,_SPC_TIMER0
	movb $0,_SPC_TIMER1
	movb $0,_SPC_TIMER2
	movb $0xff,SPC_PORT_0_R
	movb $0xff,SPC_PORT_1_R
	movb $0xff,SPC_PORT_2_R
	movb $0xff,SPC_PORT_3_R
	movb $0xff,SPC_DSP_ADDR
	movb $0xff,SPC_DSP_DATA

	movl _SPCAddress,%eax		 
	movw $0xFFFE,%ax		 
	movw (%eax),%ax
	andl $0x0000FFFF,%eax
	addl _SPCAddress,%eax
	movl %eax,_sPC_base

	L_Reset_CPU : POPL_EDI POPL_ESI POPL_EBX movl %ebp,%esp; popl %ebp; ret 

	.globl SPC_START
SPC_START:

	movl SPC_Cycles,%eax		 

	btw $0,_SPC_CTRL	 
	jnc SKIP_INC_TMR_0

	addb %al,SPC_TIMER0	 
	jnc SKIP_INC_TMR_0	 

	incb _SPC_TIMT0
	movb _SPC_TIM0,%bl
	cmpb %bl,_SPC_TIMT0	 
	jne SKIP_INC_TMR_0

	incb _SPC_CNT0
	andb $0x0F,_SPC_CNT0
	movb $0,_SPC_TIMT0

SKIP_INC_TMR_0:

	btw $1,_SPC_CTRL	 
	jnc SKIP_INC_TMR_1

	addb %al,SPC_TIMER1	 
	jnc SKIP_INC_TMR_1	 

	incb _SPC_TIMT1
	movb _SPC_TIM1,%bl
	cmpb %bl,_SPC_TIMT1	 
	jne SKIP_INC_TMR_1

	incb _SPC_CNT1
	andb $0x0F,_SPC_CNT1
	movb $0,_SPC_TIMT1

SKIP_INC_TMR_1:

	btw $2,_SPC_CTRL	 
	jnc SKIP_INC_TMR_2

	shlb $3,%al		 
	addb %al,SPC_TIMER2	 
	jnc SKIP_INC_TMR_2	 

	incb _SPC_TIMT2
	movb _SPC_TIM2,%bl
	cmpb %bl,_SPC_TIMT2	 
	jne SKIP_INC_TMR_2

	incb _SPC_CNT2
	andb $0x0F,_SPC_CNT2
	movb $0,_SPC_TIMT2

SKIP_INC_TMR_2:

SPC_LOOP:

	movl     _SPCAddress,  %ebp
	movl     _sPC_base, %esi
	movb     _sA, %cl 
	movb     _sX, %bl 
	movb     _sY, %ch 

	xorl     %eax, %eax
	xorl     %edx, %edx
	lodsb
	jmp      *_SPC_Opcodes(,%eax,4)

execute_end:
	subl     %eax, SPC_Cycles

	movb     %cl , _sA
	movb     %bl , _sX
	movb     %ch , _sY

	movl     %esi, _sPC_base

	cmpl $0,SPC_Cycles
	jg SPC_LOOP		 

	movl SPC_Cycles,%eax
	movl Get_Fixup(,%eax,4),%eax
	movl %eax,SPC_Fixup		 

	ret			 

	.long   20*4                       
	.long   16*4                       
	.long   16*4
	.long   16*4
	.long   12*4
	.long   12*4
	.long   12*4
	.long   8*4
	.long   8*4
	.long   8*4
	.long   4*4
	.long   4*4
Get_Fixup:
	.long   4*4

	; .globl _SPC_NOP     ; .align 4            ; _SPC_NOP :          ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 


MOV_:	A,       %cl , imm,   2
MOV_:	A_iX,    %cl , iX,    3
MOV_:	A_iXinc, %cl , iXinc, 4
MOV_:	A_dp,    %cl , dp,    3
MOV_:	A_dpX,   %cl , dpX,   4
MOV_:	A_abs,   %cl , abs,   4
MOV_:	A_absX,  %cl , absX,  5
MOV_:	A_absY,  %cl , absY,  5
MOV_:	A_idpX,  %cl , idpX,  6
MOV_:	A_idpY,  %cl , idpY,  6

MOV_:	X,       %bl , imm,   2
MOV_:	X_dp,    %bl , dp,    3
MOV_:	X_dpY,   %bl , dpY,   4
MOV_:	X_abs,   %bl , abs,   4

MOV_:	Y,       %ch , imm,   2
MOV_:	Y_dp,    %ch , dp,    3
MOV_:	Y_dpX,   %ch , dpX,   4
MOV_:	Y_abs,   %ch , abs,   4


MOV__:	iX_A,    %cl , iX,    4
MOV__:	iXinc_A, %cl , iXinc, 4
MOV__:	dp_A,    %cl , dp,    4
MOV__:	dpX_A,   %cl , dpX,   5
MOV__:	abs_A,   %cl , abs,   5
MOV__:	absX_A,  %cl , absX,  6
MOV__:	absY_A,  %cl , absY,  6
MOV__:	idpX_A,  %cl , idpX,  7
MOV__:	idpY_A,  %cl , idpY,  7

MOV__:	dp_X,    %bl , dp,    4
MOV__:	dpY_X,   %bl , dpY,   5
MOV__:	abs_X,   %bl , abs,   5

MOV__:	dp_Y,    %ch , dp,    4
MOV__:	dpX_Y,   %ch , dpX,   5
MOV__:	abs_Y,   %ch , abs,   5


MOV___:	A_X,    %bl , %cl ,    2
MOV___:	A_Y,    %ch , %cl ,    2
MOV___:	X_A,    %cl , %bl ,    2
MOV___:	Y_A,    %cl , %ch ,    2

	; .globl _SPC_MOV_X_SP     ; .align 4            ; _SPC_MOV_X_SP :          ; 
	movb _sSP, %bl 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_MOV_SP_X     ; .align 4            ; _SPC_MOV_SP_X :          ; 
	movb %bl , _sSP
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_MOV_dp_dp     ; .align 4            ; _SPC_MOV_dp_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_MOV_dp     ; .align 4            ; _SPC_MOV_dp :          ; 
	movb  (%esi), %al
	incl   %esi
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 



ADC_:	A,       %cl , imm,   2
ADC_:	A_iX,    %cl , iX,    3
ADC_:	A_dp,    %cl , dp,    3
ADC_:	A_dpX,   %cl , dpX,   4
ADC_:	A_abs,   %cl , abs,   4
ADC_:	A_absX,  %cl , absX,  5
ADC_:	A_absY,  %cl , absY,  5
ADC_:	A_idpX,  %cl , idpX,  6
ADC_:	A_idpY,  %cl , idpY,  6

	; .globl _SPC_ADC_iX_iY     ; .align 4            ; _SPC_ADC_iX_iY :          ; 
	movb  %ch , %dl
	movb  _f_P, %dh
	call SPC_read
	movb %al, %bh
	movb  %bl , %dl
	movb  _f_P, %dh
	call SPC_read
	; cmpb  _f_C, %ah ; 
	adcb %bh, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_ADC_dp_dp     ; .align 4            ; _SPC_ADC_dp_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %bh
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	; cmpb  _f_C, %ah ; 
	adcb %bh, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	call SPC_write
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_ADC_dp     ; .align 4            ; _SPC_ADC_dp :          ; 
	movb  (%esi), %al
	incl   %esi
	movb %al, %bh
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	; cmpb  _f_C, %ah ; 
	adcb %bh, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

SBC_:	A,       %cl , imm,   2
SBC_:	A_iX,    %cl , iX,    3
SBC_:	A_dp,    %cl , dp,    3
SBC_:	A_dpX,   %cl , dpX,   4
SBC_:	A_abs,   %cl , abs,   4
SBC_:	A_absX,  %cl , absX,  5
SBC_:	A_absY,  %cl , absY,  5
SBC_:	A_idpX,  %cl , idpX,  6
SBC_:	A_idpY,  %cl , idpY,  6

	; .globl _SPC_SBC_iX_iY     ; .align 4            ; _SPC_SBC_iX_iY :          ; 
	movb  %ch , %dl
	movb  _f_P, %dh
	call SPC_read
	xorb $0xff, %al
	movb %al, %bh
	movb  %bl , %dl
	movb  _f_P, %dh
	call SPC_read
	; cmpb  _f_C, %ah ; 
	adcb %bh, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_SBC_dp_dp     ; .align 4            ; _SPC_SBC_dp_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	xorb $0xff, %al
	movb %al, %bh
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	; cmpb  _f_C, %ah ; 
	adcb %bh, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	call SPC_write
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_SBC_dp     ; .align 4            ; _SPC_SBC_dp :          ; 
	movb  (%esi), %al
	incl   %esi
	xorb $0xff, %al
	movb %al, %bh
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	; cmpb  _f_C, %ah ; 
	adcb %bh, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 


CMP_:	A,       %cl , imm,   2
CMP_:	A_iX,    %cl , iX,    3
CMP_:	A_dp,    %cl , dp,    3
CMP_:	A_dpX,   %cl , dpX,   4
CMP_:	A_abs,   %cl , abs,   4
CMP_:	A_absX,  %cl , absX,  5
CMP_:	A_absY,  %cl , absY,  5
CMP_:	A_idpX,  %cl , idpX,  6
CMP_:	A_idpY,  %cl , idpY,  6

CMP_:	X,       %bl , imm,   2
CMP_:	X_dp,    %bl , dp,    3
CMP_:	X_abs,   %bl , abs,   4

CMP_:	Y,       %ch , imm,   2
CMP_:	Y_dp,    %ch , dp,    3
CMP_:	Y_abs,   %ch , abs,   4

	; .globl _SPC_CMP_iX_iY     ; .align 4            ; _SPC_CMP_iX_iY :          ; 
	movb  %ch , %dl
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	movb  %bl , %dl
	movb  _f_P, %dh
	call SPC_read
	subb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	setnc _f_C
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_CMP_dp_dp     ; .align 4            ; _SPC_CMP_dp_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	subb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	setnc _f_C
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_CMP_dp     ; .align 4            ; _SPC_CMP_dp :          ; 
	movb  (%esi), %al
	incl   %esi
	movb %al, %ah
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	subb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	setnc _f_C
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 




AND_:	A,       %cl , imm,   2
AND_:	A_iX,    %cl , iX,    3
AND_:	A_dp,    %cl , dp,    3
AND_:	A_dpX,   %cl , dpX,   4
AND_:	A_abs,   %cl , abs,   4
AND_:	A_absX,  %cl , absX,  5
AND_:	A_absY,  %cl , absY,  5
AND_:	A_idpX,  %cl , idpX,  6
AND_:	A_idpY,  %cl , idpY,  6

OR_:	A,       %cl , imm,   2
OR_:	A_iX,    %cl , iX,    3
OR_:	A_dp,    %cl , dp,    3
OR_:	A_dpX,   %cl , dpX,   4
OR_:	A_abs,   %cl , abs,   4
OR_:	A_absX,  %cl , absX,  5
OR_:	A_absY,  %cl , absY,  5
OR_:	A_idpX,  %cl , idpX,  6
OR_:	A_idpY,  %cl , idpY,  6

EOR_:	A,       %cl , imm,   2
EOR_:	A_iX,    %cl , iX,    3
EOR_:	A_dp,    %cl , dp,    3
EOR_:	A_dpX,   %cl , dpX,   4
EOR_:	A_abs,   %cl , abs,   4
EOR_:	A_absX,  %cl , absX,  5
EOR_:	A_absY,  %cl , absY,  5
EOR_:	A_idpX,  %cl , idpX,  6
EOR_:	A_idpY,  %cl , idpY,  6

	; .globl _SPC_AND_iX_iY     ; .align 4            ; _SPC_AND_iX_iY :          ; 
	movb  %ch , %dl
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	movb  %bl , %dl
	movb  _f_P, %dh
	call SPC_read
	andb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_AND_dp_dp     ; .align 4            ; _SPC_AND_dp_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	andb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_AND_dp     ; .align 4            ; _SPC_AND_dp :          ; 
	movb  (%esi), %al
	incl   %esi
	movb %al, %ah
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	andb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_OR_iX_iY     ; .align 4            ; _SPC_OR_iX_iY :          ; 
	movb  %ch , %dl
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	movb  %bl , %dl
	movb  _f_P, %dh
	call SPC_read
	orb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_OR_dp_dp     ; .align 4            ; _SPC_OR_dp_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	orb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_OR_dp     ; .align 4            ; _SPC_OR_dp :          ; 
	movb  (%esi), %al
	incl   %esi
	movb %al, %ah
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	orb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_EOR_iX_iY     ; .align 4            ; _SPC_EOR_iX_iY :          ; 
	movb  %ch , %dl
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	movb  %bl , %dl
	movb  _f_P, %dh
	call SPC_read
	xorb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_EOR_dp_dp     ; .align 4            ; _SPC_EOR_dp_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	xorb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_EOR_dp     ; .align 4            ; _SPC_EOR_dp :          ; 
	movb  (%esi), %al
	incl   %esi
	movb %al, %ah
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	xorb %ah, %al
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; 
	call SPC_write
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_INC_A     ; .align 4            ; _SPC_INC_A :          ; 
	incb %cl 
	; movb   %cl  , _f_Z    ; movb   %cl  , _f_N    ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_INC_X     ; .align 4            ; _SPC_INC_X :          ; 
	incb %bl 
	; movb   %bl  , _f_Z    ; movb   %bl  , _f_N    ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_INC_Y     ; .align 4            ; _SPC_INC_Y :          ; 
	incb %ch 
	; movb   %ch  , _f_Z    ; movb   %ch  , _f_N    ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DEC_A     ; .align 4            ; _SPC_DEC_A :          ; 
	decb %cl 
	; movb   %cl  , _f_Z    ; movb   %cl  , _f_N    ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DEC_X     ; .align 4            ; _SPC_DEC_X :          ; 
	decb %bl 
	; movb   %bl  , _f_Z    ; movb   %bl  , _f_N    ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DEC_Y     ; .align 4            ; _SPC_DEC_Y :          ; 
	decb %ch 
	; movb   %ch  , _f_Z    ; movb   %ch  , _f_N    ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 




INC_:	INC_dp,  dp,  4
INC_:	INC_dpX, dpX, 5
INC_:	INC_abs, abs, 5

DEC_:	DEC_dp,  dp,  4
DEC_:	DEC_dpX, dpX, 5
DEC_:	DEC_abs, abs, 5

	; .globl _SPC_ASL_A     ; .align 4            ; _SPC_ASL_A :          ; 
	shlb $1, %cl 
	; movb   %cl  , _f_Z    ; movb   %cl  , _f_N    ; setc  _f_C         ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_LSR_A     ; .align 4            ; _SPC_LSR_A :          ; 
	shrb $1, %cl 
	; movb   %cl  , _f_Z    ; movb   %cl  , _f_N    ; setc  _f_C         ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_ROL_A     ; .align 4            ; _SPC_ROL_A :          ; 
	; cmpb  _f_C, %ah ; 
	rclb $1, %cl 
	; movb   %cl  , _f_Z    ; movb   %cl  , _f_N    ; setc  _f_C         ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_ROR_A     ; .align 4            ; _SPC_ROR_A :          ; 
	; cmpb  _f_C, %ah ; 
	rcrb $1, %cl 
	; movb   %cl  , _f_Z    ; movb   %cl  , _f_N    ; setc  _f_C         ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 



SH_:	ASL_dp,  shlb, dp,  4
SH_:	ASL_dpX, shlb, dpX, 5
SH_:	ASL_abs, shlb, abs, 5

SH_:	LSR_dp,  shrb, dp,  4
SH_:	LSR_dpX, shrb, dpX, 5
SH_:	LSR_abs, shrb, abs, 5

ROT_:	ROL_dp,  rclb, dp,  4
ROT_:	ROL_dpX, rclb, dpX, 5
ROT_:	ROL_abs, rclb, abs, 5

ROT_:	ROR_dp,  rcrb, dp,  4
ROT_:	ROR_dpX, rcrb, dpX, 5
ROT_:	ROR_abs, rcrb, abs, 5

	; .globl _SPC_XCN     ; .align 4            ; _SPC_XCN :          ; 
	rolb $4, %cl 
	; movb   %cl  , _f_Z    ; movb   %cl  , _f_N    ; 
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_MOVW_YA_dp     ; .align 4            ; _SPC_MOVW_YA_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	incl %edx
	call SPC_read
	xchg %al, %ah
	decl %edx
	movw %ax, %cx

	; movb   %ah , _f_Z    ; movb   %ah , _f_N    ; 
	orb %al, _f_Z
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_MOVW_dp_YA     ; .align 4            ; _SPC_MOVW_dp_YA :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh

	movw %cx, %ax
	call SPC_write
	xchg %al, %ah
	incl %edx
	call SPC_write
	xchg %al, %ah
	decl %edx
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_INCW_dp     ; .align 4            ; _SPC_INCW_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	incl %edx
	call SPC_read
	xchg %al, %ah
	decl %edx
	incw %ax
	; movb   %ah , _f_Z    ; movb   %ah , _f_N    ; 
	orb %al, _f_Z
	call SPC_write
	xchg %al, %ah
	incl %edx
	call SPC_write
	xchg %al, %ah
	decl %edx
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DECW_dp     ; .align 4            ; _SPC_DECW_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	incl %edx
	call SPC_read
	xchg %al, %ah
	decl %edx
	decw %ax
	; movb   %ah , _f_Z    ; movb   %ah , _f_N    ; 
	orb %al, _f_Z
	call SPC_write
	xchg %al, %ah
	incl %edx
	call SPC_write
	xchg %al, %ah
	decl %edx
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_ADDW_dp     ; .align 4            ; _SPC_ADDW_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	incl %edx
	call SPC_read
	xchg %al, %ah
	decl %edx
	addw %ax, %cx
	; movb   %ah , _f_Z    ; movb   %ah , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	orb %al, _f_Z
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_SUBW_dp     ; .align 4            ; _SPC_SUBW_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	incl %edx
	call SPC_read
	xchg %al, %ah
	decl %edx
	subw %ax, %cx
	; movb   %ah , _f_Z    ; movb   %ah , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	orb %al, _f_Z
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_CMPW_dp     ; .align 4            ; _SPC_CMPW_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb %al, %ah
	incl %edx
	call SPC_read
	xchg %al, %ah
	decl %edx
	movw %cx, %dx
	subw %ax, %dx
	; movb   %dh , _f_Z    ; movb   %dh , _f_N    ; 
	orb %dl, _f_Z
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_MUL     ; .align 4            ; _SPC_MUL :          ; 
	movb %ch , %al
	mulb %cl 
	movw %ax, %cx
	; movb   %ah , _f_Z    ; movb   %ah , _f_N    ; 
	orb %al, _f_Z
	; movl  $ 9 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DIV     ; .align 4            ; _SPC_DIV :          ; 
	testb %bl , %bl 
	jz 0f
	movw %cx, %ax
	movb $0, %bh
	divw %bx
	movb %al, %cl 
	movb %dl, %ch 
	; movb   %al , _f_Z    ; movb   %al , _f_N    ; setc  _f_C         ; seto  _f_V         ; 
	testb %ah, %ah
	setnz _f_V
	0:
	; movl  $ 12 , %eax      ; jmp   execute_end   ; 

do_branch:
	movb  (%esi), %al
	incl   %esi

	subl _SPCAddress, %esi
	movl %esi, %edx

	testb %al, %al
	jl br_backward
br_forward:
	addb %al, %dl
	jnc  done_branch
	incb %dh
	movl %edx, %esi
	addl _SPCAddress, %esi
	xchg %ah, %al
	addb $4, %al
	andl $0xff, %eax
	jmp execute_end

br_backward:
	addb %al, %dl
	jc   done_branch
	decb %dh
	movl %edx, %esi
	addl _SPCAddress, %esi
	xchg %ah, %al
	addb $4, %al
	andl $0xff, %eax
	jmp execute_end

done_branch:
	movl %edx, %esi
	addl _SPCAddress, %esi
	xchg %ah, %al
	addb $3, %al
	andl $0xff, %eax
	jmp execute_end

	; .globl _SPC_BRA     ; .align 4            ; _SPC_BRA :          ; 
	jmp do_branch

	; .globl _SPC_BEQ     ; .align 4            ; _SPC_BEQ :          ; 
	cmpb %dl, _f_Z
	jz do_branch

	incl %esi
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_BNE     ; .align 4            ; _SPC_BNE :          ; 
	cmpb %dl, _f_Z
	jnz do_branch

	incl %esi
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_BCS     ; .align 4            ; _SPC_BCS :          ; 
	cmpb %dl, _f_C
	jnz do_branch

	incl %esi
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_BCC     ; .align 4            ; _SPC_BCC :          ; 
	cmpb %dl, _f_C
	jz do_branch

	incl %esi
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_BVS     ; .align 4            ; _SPC_BVS :          ; 
	cmpb %dl, _f_V
	jnz do_branch

	incl %esi
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_BVC     ; .align 4            ; _SPC_BVC :          ; 
	cmpb %dl, _f_V
	jz do_branch

	incl %esi
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_BPL     ; .align 4            ; _SPC_BPL :          ; 
	movb _f_N, %dl
	testb %dl, %dl
	jns do_branch

	incl %esi
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_BMI     ; .align 4            ; _SPC_BMI :          ; 
	movb _f_N, %dl
	testb %dl, %dl
	js do_branch

	incl %esi
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 


BB_:	0
BB_:	1
BB_:	2
BB_:	3
BB_:	4
BB_:	5
BB_:	6
BB_:	7

	; .globl _SPC_CBNE_dp     ; .align 4            ; _SPC_CBNE_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	movb $3, %ah
	cmpb %al, %cl 
	jne do_branch

	incl %esi
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_CBNE_dpX     ; .align 4            ; _SPC_CBNE_dpX :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	addb  %bl , %dl
	adcb  %ah, %dh
	call SPC_read
	movb $4, %ah
	cmpb %al, %cl 
	jne do_branch

	incl %esi
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DBNZ_dp     ; .align 4            ; _SPC_DBNZ_dp :          ; 
	movb  (%esi), %dl
	incl   %esi
	movb  _f_P, %dh
	call SPC_read
	decb %al
	call SPC_write
	movb $3, %ah
	testb %al, %al
	jne do_branch

	incl %esi
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DBNZ_Y     ; .align 4            ; _SPC_DBNZ_Y :          ; 
	movb $2, %ah
	decb %ch 
	jne do_branch

	incl %esi
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_JMP_absl     ; .align 4            ; _SPC_JMP_absl :          ; 
	movw  (%esi), %dx
	incl   %esi
	incl   %esi
	addl _SPCAddress, %edx
	movl %edx, %esi
	; movl  $ 3 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_JMP_iabslX     ; .align 4            ; _SPC_JMP_iabslX :          ; 
	movw  (%esi), %dx
	incl   %esi
	incl   %esi
	addb  %bl , %dl
	adcb  %ah, %dh
	movw (%ebp, %edx), %dx
	addl _SPCAddress, %edx
	movl %edx, %esi
	; movl  $ 3 , %eax      ; jmp   execute_end   ; 





	; .globl _SPC_CALL     ; .align 4            ; _SPC_CALL :          ; 
	movl %esi, %eax
	movb _sSP, %dl
	subl _SPCAddress, %esi
	addw $2, %si
	decl %edx
	movw %si, 0x100(%ebp, %edx)
	decl %edx
	movb %dl, _sSP

	movw (%eax), %dx
	addl _SPCAddress, %edx
	movl %edx, %esi
	; movl  $ 8 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_RET     ; .align 4            ; _SPC_RET :          ; 
	xorl %esi, %esi

	movb _sSP, %dl
	incl %edx
	movw 0x100(%ebp, %edx), %si
	incl %edx
	movb %dl, _sSP

	addl _SPCAddress, %esi
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_PUSH_A     ; .align 4            ; _SPC_PUSH_A :          ; 
	movb _sSP, %dl
	movb %cl, 0x100(%ebp, %edx)
	decl %edx
	movb %dl, _sSP
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_PUSH_X     ; .align 4            ; _SPC_PUSH_X :          ; 
	movb _sSP, %dl
	movb %bl, 0x100(%ebp, %edx)
	decl %edx
	movb %dl, _sSP
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_PUSH_Y     ; .align 4            ; _SPC_PUSH_Y :          ; 
	movb _sSP, %dl
	movb %ch, 0x100(%ebp, %edx)
	decl %edx
	movb %dl, _sSP
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_POP_A     ; .align 4            ; _SPC_POP_A :          ; 
	movb _sSP, %dl
	incl %edx
	movb 0x100(%ebp, %edx), %cl
	movb %dl, _sSP
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_POP_X     ; .align 4            ; _SPC_POP_X :          ; 
	movb _sSP, %dl
	incl %edx
	movb 0x100(%ebp, %edx), %bl
	movb %dl, _sSP
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_POP_Y     ; .align 4            ; _SPC_POP_Y :          ; 
	movb _sSP, %dl
	incl %edx
	movb 0x100(%ebp, %edx), %ch
	movb %dl, _sSP
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_PUSH_PSW     ; .align 4            ; _SPC_PUSH_PSW :          ; 
	xorb %al, %al

	cmpb %dl, _f_C
	jz 0f
	orb $0x01, %al
	0:
	cmpb %dl, _f_Z
	jnz 0f
	orb $0x02, %al
	0:
	cmpb %dl, _f_P
	jz 0f
	orb $0x20, %al
	0:
	cmpb %dl, _f_V
	jz 0f
	orb $0x40, %al
	0:
	movb _f_N, %dl
	testb %dl, %dl
	jns 0f
	orb $0x80, %al
	0:
	movb _sSP, %dl
	movb %al, 0x100(%ebp, %edx)
	decl %edx
	movb %dl, _sSP
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_POP_PSW     ; .align 4            ; _SPC_POP_PSW :          ; 
	movb _sSP, %dl
	incl %edx
	movb 0x100(%ebp, %edx), %al
	movb %dl, _sSP

	movb %al, _f_N

	testb $0x01, %al
	setnz _f_C

	testb $0x02, %al
	setz  _f_Z

	testb $0x20, %al
	setnz _f_P

	testb $0x40, %al
	setnz _f_V
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 


BO_:	0
BO_:	1
BO_:	2
BO_:	3
BO_:	4
BO_:	5
BO_:	6
BO_:	7

	; .globl _SPC_TSET1     ; .align 4            ; _SPC_TSET1 :          ; 
	movw  (%esi), %dx
	incl   %esi
	incl   %esi
	call SPC_read
	movb %al, %ah
	orb %cl , %al
	call SPC_write

	andb %cl , %ah
	; movb   %ah , _f_Z    ; movb   %ah , _f_N    ; 
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_TCLR1     ; .align 4            ; _SPC_TCLR1 :          ; 
	movw  (%esi), %dx
	incl   %esi
	incl   %esi
	call SPC_read
	movb %al, %ah
	notb %cl 
	andb %cl , %al
	notb %cl 
	call SPC_write

	andb %cl , %ah
	; movb   %ah , _f_Z    ; movb   %ah , _f_N    ; 
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_MOV1_C_mem     ; .align 4            ; _SPC_MOV1_C_mem :          ; 
	movw  (%esi), %ax
	incl   %esi
	incl   %esi
	movb %al, %bh
	andb $7, %bh
	shrl $3, %eax
	movb (%ebp, %eax), %dl
	btb  %bh, %dl
	setc _f_C
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_EOR1_C_mem     ; .align 4            ; _SPC_EOR1_C_mem :          ; 
	movw  (%esi), %ax
	incl   %esi
	incl   %esi
	movb %al, %bh
	andb $7, %bh
	shrl $3, %eax
	movb (%ebp, %eax), %dl
	btb  %bh, %dl
	jnc  0f
	notb _f_C
	0:
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_OR1_C_mem     ; .align 4            ; _SPC_OR1_C_mem :          ; 
	movw  (%esi), %ax
	incl   %esi
	incl   %esi
	movb %al, %bh
	andb $7, %bh
	shrl $3, %eax
	movb (%ebp, %eax), %dl
	btb  %bh, %dl
	jnc  0f
	movb $1, _f_C
	0:
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_OR1_C_notmem     ; .align 4            ; _SPC_OR1_C_notmem :          ; 
	movw  (%esi), %ax
	incl   %esi
	incl   %esi
	movb %al, %bh
	andb $7, %bh
	shrl $3, %eax
	movb (%ebp, %eax), %dl
	btb  %bh, %dl
	jc  0f
	movb $1, _f_C
	0:
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_AND1_C_mem     ; .align 4            ; _SPC_AND1_C_mem :          ; 
	movw  (%esi), %ax
	incl   %esi
	incl   %esi
	movb %al, %bh
	andb $7, %bh
	shrl $3, %eax
	movb (%ebp, %eax), %dl
	btb  %bh, %dl
	jc  0f
	movb $0, _f_C
	0:
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_AND1_C_notmem     ; .align 4            ; _SPC_AND1_C_notmem :          ; 
	movw  (%esi), %ax
	incl   %esi
	incl   %esi
	movb %al, %bh
	andb $7, %bh
	shrl $3, %eax
	movb (%ebp, %eax), %dl
	btb  %bh, %dl
	jnc  0f
	movb $0, _f_C
	0:
	; movl  $ 4 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_NOT1     ; .align 4            ; _SPC_NOT1 :          ; 
	movw  (%esi), %ax
	incl   %esi
	incl   %esi
	movb %al, %bh
	andb $7, %bh
	shrl $3, %eax
	movb (%ebp, %eax), %dl
	btcb  %bh, %dl
	movb %dl, (%ebp, %eax)
	; movl  $ 5 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_MOV1_mem_C     ; .align 4            ; _SPC_MOV1_mem_C :          ; 
	movw  (%esi), %ax
	incl   %esi
	incl   %esi
	movb %al, %bh
	andb $7, %bh
	shrl $3, %eax
	movb (%ebp, %eax), %dl
	cmpb %dh, _f_C
	jnc  0f
	btsb %bh, %dl
	jmp  1f
	0:btrb %bh, %dl
	1:
	movb %dl, (%ebp, %eax)
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_CLRC     ; .align 4            ; _SPC_CLRC :          ; 
	movb %dl, _f_C
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_SETC     ; .align 4            ; _SPC_SETC :          ; 
	movb $1, _f_C
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_NOTC     ; .align 4            ; _SPC_NOTC :          ; 
	notb _f_C
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_CLRV     ; .align 4            ; _SPC_CLRV :          ; 
	movb %dl, _f_V
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_CLRP     ; .align 4            ; _SPC_CLRP :          ; 
	movb %dl, _f_P
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_SETP     ; .align 4            ; _SPC_SETP :          ; 
	movb $1, _f_P
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 


	; .globl _SPC_DAS     ; .align 4            ; _SPC_DAS :          ; 
	; movl  $ 3 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DAA     ; .align 4            ; _SPC_DAA :          ; 
	; movl  $ 3 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_EI     ; .align 4            ; _SPC_EI :          ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_DI     ; .align 4            ; _SPC_DI :          ; 
	; movl  $ 2 , %eax      ; jmp   execute_end   ; 


TCALL_:	0
TCALL_:	1
TCALL_:	2
TCALL_:	3
TCALL_:	4
TCALL_:	5
TCALL_:	6
TCALL_:	7
TCALL_:	8
TCALL_:	9
TCALL_:	10
TCALL_:	11
TCALL_:	12
TCALL_:	13
TCALL_:	14
TCALL_:	15

	; .globl _SPC_RETI     ; .align 4            ; _SPC_RETI :          ; 
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_STOP     ; .align 4            ; _SPC_STOP :          ; 
	decl %esi
	; movl  $ 3 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_SLEEP     ; .align 4            ; _SPC_SLEEP :          ; 
	decl %esi
	; movl  $ 3 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_BRK     ; .align 4            ; _SPC_BRK :          ; 
	decl %esi
	; movl  $ 8 , %eax      ; jmp   execute_end   ; 

	; .globl _SPC_PCALL     ; .align 4            ; _SPC_PCALL :          ; 
	incl %esi
	; movl  $ 6 , %eax      ; jmp   execute_end   ; 

SPC_ROM_CODE:
	.byte	0xCD,0xEF,0xBD,0xE8,0x00,0xC6,0x1D,0xD0
	.byte	0xFC,0x8F,0xAA,0xF4,0x8F,0xBB,0xF5,0x78
	.byte	0xCC,0xF4,0xD0,0xFB,0x2F,0x19,0xEB,0xF4
	.byte	0xD0,0xFC,0x7E,0xF4,0xD0,0x0B,0xE4,0xF5
	.byte	0xCB,0xF4,0xD7,0x00,0xFC,0xD0,0xF3,0xAB
	.byte	0x01,0x10,0xEF,0x7E,0xF4,0x10,0xEB,0xBA
	.byte	0xF6,0xDA,0x00,0xBA,0xF4,0xC4,0xF4,0xDD
	.byte	0x5D,0xD0,0xDB,0x1F,0x00,0x00,0xC0,0xFF

SPC_READ_DSP_ADDR:
	movb SPC_DSP_ADDR,%al
	ret

SPC_READ_DSP_DATA:
	pushl %ebx
	xorl %ebx,%ebx
	movb SPC_DSP_ADDR,%bl
	movl _SPC_DSP,%edi
	movb (%edi,%ebx),%al		 
	popl %ebx
	ret

SPC_READ_PORT_0:
	movb SPC_PORT_0_R,%al
	ret
SPC_READ_PORT_1:
	movb SPC_PORT_1_R,%al
	ret
SPC_READ_PORT_2:
	movb SPC_PORT_2_R,%al
	ret
SPC_READ_PORT_3:
	movb SPC_PORT_3_R,%al
	ret



SPC_READ_COUNTER_0:
	movb _SPC_CNT0,%al
	movb $0,_SPC_CNT0
	ret

SPC_READ_COUNTER_1:
	movb _SPC_CNT1,%al
	movb $0,_SPC_CNT1
	ret

SPC_READ_COUNTER_2:
	movb _SPC_CNT2,%al
	movb $0,_SPC_CNT2
	ret

SPC_WRITE_CTRL:
	pushl %eax
	movb $0,%ah
	btw $4,%ax			 
	jnc 0f
	movb %ah,SPC_PORT_0_W
	movb %ah,SPC_PORT_1_W
	0:	btw $5,%ax
	jnc 0f
	movb %ah,SPC_PORT_2_W
	movb %ah,SPC_PORT_3_W
	0:	andb $0x07,%al
	movb %al,_SPC_CTRL
	popl %eax
	ret

SPC_WRITE_DSP_ADDR:
	movb %al,SPC_DSP_ADDR
	ret

	# 1730 "spc.S"



SPC_WRITE_DSP_DATA:
	pusha
	call _SPC_UPDATEAUDIO
	popa
	cmpb $0x4C,SPC_DSP_ADDR
	jne 0f
	andb SPC_MASK,%al		 
	movb %al,_DSP_KEY_ON
	pusha
	btw $0,%ax
	jnc 1f
	pusha
	movb $0,_DECODE_BYTE
	call _SPC_DECODE
	popa
	1:
	btw $1,%ax
	jnc 1f
	pusha
	movb $1,_DECODE_BYTE
	call _SPC_DECODE
	popa
	1:
	btw $2,%ax
	jnc 1f
	pusha
	movb $2,_DECODE_BYTE
	call _SPC_DECODE
	popa
	1:
	btw $3,%ax
	jnc 1f
	pusha
	movb $3,_DECODE_BYTE
	call _SPC_DECODE
	popa
	1:
	btw $4,%ax
	jnc 1f
	pusha
	movb $4,_DECODE_BYTE
	call _SPC_DECODE
	popa
	1:
	btw $5,%ax
	jnc 1f
	pusha
	movb $5,_DECODE_BYTE
	call _SPC_DECODE
	popa
	1:
	btw $6,%ax
	jnc 1f
	pusha
	movb $6,_DECODE_BYTE
	call _SPC_DECODE
	popa
	1:
	btw $7,%ax
	jnc 1f
	pusha
	movb $7,_DECODE_BYTE
	call _SPC_DECODE
	popa
	1:
	2:	call _PlayVoices
	popa
	0:
	pushl %ebx
	pushl %ecx
	xorl %ebx,%ebx
	movb SPC_DSP_ADDR,%bl
	andb $0x7F,%bl			 
	movb %bl,%cl
	andb $0x0F,%cl




	movl _SPC_DSP,%edi
	movb %al,(%edi,%ebx)	 
	popl %ecx
	popl %ebx
	ret
	# 1830 "spc.S"


SPC_WRITE_PORT_0:
	movb %al,SPC_PORT_0_W
	ret
SPC_WRITE_PORT_1:
	movb %al,SPC_PORT_1_W
	ret
SPC_WRITE_PORT_2:
	movb %al,SPC_PORT_2_W
	ret
SPC_WRITE_PORT_3:
	movb %al,SPC_PORT_3_W
	ret

SPC_WRITE_TIMER_0:
	btw $0,_SPC_CTRL
	jc 0f
	movb %al,_SPC_TIM0
	0:	ret

SPC_WRITE_TIMER_1:
	btw $1,_SPC_CTRL
	jc 0f
	movb %al,_SPC_TIM1
	0:	ret

SPC_WRITE_TIMER_2:
	btw $2,_SPC_CTRL
	jc 0f
	movb %al,_SPC_TIM2
	0:	ret

Read_Func_Map:
	.long	SPC_READ_INVALID
	.long	SPC_READ_INVALID
	.long	SPC_READ_DSP_ADDR
	.long	SPC_READ_DSP_DATA
	.long	SPC_READ_PORT_0
	.long	SPC_READ_PORT_1
	.long	SPC_READ_PORT_2
	.long	SPC_READ_PORT_3
	.long	SPC_READ_INVALID
	.long	SPC_READ_INVALID
	.long	SPC_READ_INVALID
	.long	SPC_READ_INVALID
	.long	SPC_READ_INVALID
	.long	SPC_READ_COUNTER_0
	.long	SPC_READ_COUNTER_1
	.long	SPC_READ_COUNTER_2

Write_Func_Map:
	.long	SPC_WRITE_INVALID
	.long	SPC_WRITE_CTRL
	.long	SPC_WRITE_DSP_ADDR
	.long	SPC_WRITE_DSP_DATA
	.long	SPC_WRITE_PORT_0
	.long	SPC_WRITE_PORT_1
	.long	SPC_WRITE_PORT_2
	.long	SPC_WRITE_PORT_3
	.long	SPC_WRITE_INVALID
	.long	SPC_WRITE_INVALID
	.long	SPC_WRITE_TIMER_0
	.long	SPC_WRITE_TIMER_1
	.long	SPC_WRITE_TIMER_2
	.long	SPC_WRITE_INVALID
	.long	SPC_WRITE_INVALID
	.long	SPC_WRITE_INVALID
