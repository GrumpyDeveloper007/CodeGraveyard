/*
 Compile under DJGPP (GNU-AS) - Written By Savoury SnaX (Not quite sure if I like AT&T)

   NOTE - This must have .S (capital) or the # stuff wont be pre-processed!!!

 SPC INFORMATION :

	  [   A   ]	- A register 	(_SPC_A)	8 Bit
          [   Y   ]	- Y register 	(_SPC_Y)	8 Bit
	  [   X   ]	- X register 	(_SPC_X)	8 Bit
    [      SP     ]	- SP register	(_SPC_SP)	16 Bit
    [      PC     ]	- PC register	(_SPC_PC)	16 Bit
    [     PSW     ]	- PSW register 	(_SPC_PSW)	16 Bit
				??|??|??|??|OV|??|??|??|SI|ZE|??|AF|??|??|??|CF|     PC
				??|??|??|??|V |??|??|??|N |Z |??|H |??|I |P |C |     SPC
              			TRUE LAYOUT = |N|V|P|-|H|I|Z|C|    


 SPC - Timer functions 

  SPC has 40960 cycles to execute every vbl, since the timers run at 8KHz and 64KHz and the
 main chip runs at 2.048Mhz. In theory the timers can be clocked as follows :

	40960 / (8000/50)	= 40960 / 160	= 256 cycles	(Timer 0 and 1)
	40960 / (64000/50)	= 40960 / 1280	= 32  cycles	(Timer 2)

  I think my brain has screwed all this up but sod it!

*/

#include <libc/asmdefs.h>

.macro	DUPLICATE vartype, amount, data, from=1
.\vartype \data
.if \amount-\from
DUPLICATE \vartype,\amount,\data,"(\from+1)"
.endif
.endm

#define OPBEGIN(name) ; \
.globl SPC_##name    ; \
  .align 4            ; \
SPC_##name:          ; \

#define OPEND(C)      ; \
  movl  $C, %eax      ; \
  jmp   execute_end   ; \

#define nA %cl
#define nY %ch
#define nX %bl
#define nB %bh

//-------------------------------------
// flags macros
//-------------------------------------

#define SAVEF(reg)   ; \
  movb  reg, _f_Z    ; \
  movb  reg, _f_N    ; \

/*
  setz  _f_Z         ; \
  sets  _f_N         ; \
*/

#define SAVEFC(reg)  ; \
  movb  reg, _f_Z    ; \
  movb  reg, _f_N    ; \
  setc  _f_C         ; \

#define SAVEFO(reg)  ; \
  movb  reg, _f_Z    ; \
  movb  reg, _f_N    ; \
  seto  _f_V         ; \

#define SAVEFCO(reg) ; \
  movb  reg, _f_Z    ; \
  movb  reg, _f_N    ; \
  setc  _f_C         ; \
  seto  _f_V         ; \

#define GETC      ; \
  cmpb  _f_C, %ah ; \


/* The following definition is to allow more than one FUNC() LEAVE decleration */

#define LEAVEL(label) label: POPL_EDI POPL_ESI POPL_EBX movl %ebp,%esp; popl %ebp; ret

.data
.balign 16
.globl SPC_Cycles
SPC_Cycles:	.long	0		/* Number of cycles to execute for SPC */

SPC_PAGE:	.word	0
SPC_SP:		.word	0
SPC_PC:		.word	0
SPC_PSW:	.word	0		/* Flags Register - See information at top! */
SPC_A:		.byte	0
SPC_X:		.byte	0
SPC_Y:		.byte	0

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

SPC_TIMER0:     .byte   0               /* These hold cycles done, a carry indicates increment 8 bit timer */
SPC_TIMER1:     .byte   0
SPC_TIMER2:     .byte   0

SPC_DSP_ADDR:	.byte	0
SPC_DSP_DATA:	.byte	0

SPC_TEMP:	.byte	0

_sA:      .byte 0
_sX:      .byte 0
_sY:      .byte 0
//_sPSW:    .byte 0

_sSP:     .byte 0
_sPC:     .word 0

_f_V:	.byte	0
_f_Z:	.byte	0
_f_N:	.byte	0
_f_P:	.byte	0
_f_C:	.byte	0

_sPC_base:	.long 0

SPC_LOOP_ADDRESS:	.word	0	/* Loop address for sample */
SPC_DECODE_COUNT:	.byte	0
.balign 16
SPC_DECODE_LENGTH:	.long	0	/* Count of how many packets unpacked */

.globl SPC_MASK
SPC_MASK:	.byte	0xFF		/* Used for disabling sound channels (temp hack) */


.balign 16
SPCOpTable:
        DUPLICATE long,64,SPC_INVALID           /* Initialise this lot to invalid opcode */
        DUPLICATE long,64,SPC_INVALID		/* Done *4 to prevent - nested to deep error! */
        DUPLICATE long,64,SPC_INVALID
        DUPLICATE long,64,SPC_INVALID

.text
.balign 16				/* Align to paragraph */

//-------------------------------------
// fetch macros
//-------------------------------------

#define FETCHBYTE(reg) ; \

.macro FETCHBYTE reg=%dl
       movb  (%esi), \reg
       incl   %esi
.endm

.macro FETCHWORD reg=%dx
       movw  (%esi), \reg
       incl   %esi
       incl   %esi
.endm

//-------------------------------------
// lea macros
//-------------------------------------

.macro LEA_dp
       FETCHBYTE
       movb  _f_P, %dh
.endm
.macro LEA_dpX
       FETCHBYTE
       movb  _f_P, %dh
       addb  nX, %dl
       adcb  %ah, %dh
.endm
.macro LEA_dpY
       FETCHBYTE
       movb  _f_P, %dh
       addb  nY, %dl
       adcb  %ah, %dh
.endm
.macro LEA_iX
       movb  nX, %dl
       movb  _f_P, %dh
.endm
.macro LEA_iY
       movb  nY, %dl
       movb  _f_P, %dh
.endm
.macro LEA_iXinc
       movb  nX, %dl
       incb  nX
       movb  _f_P, %dh
.endm
.macro LEA_abs
       FETCHWORD
.endm
.macro LEA_absX
       FETCHWORD
       addb  nX, %dl
       adcb  %ah, %dh
.endm
.macro LEA_absY
       FETCHWORD
       addb  nY, %dl
       adcb  %ah, %dh
.endm
.macro LEA_idpX
       LEA_dpX
       movw (%ebp, %edx), %dx
.endm
.macro LEA_idpY
       LEA_dp
       movw (%ebp, %edx), %dx
       addb nY, %dl
       adcb %ah, %dh
.endm

  .align 4
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
	movl %edx,%esi
	movl %esi,%edi
	andl $0x0000000F,%edi
	call  Read_Func_Map(,%edi,4)
	movb %al,SPC_TEMP
	popa
	movb SPC_TEMP,%al
        ret

  .align 4
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
	movl %edx,%esi
	movl %esi,%edi
	andl $0x0000000F,%edi
	call  Write_Func_Map(,%edi,4)
	popa
        ret

SPC_READ_INVALID:
	movb $0xFF,%al
	ret

SPC_WRITE_INVALID:
	ret

SPC_INVALID:
	ret

//-------------------------------------
// read macros
//-------------------------------------

.macro GETBYTE_imm
       FETCHBYTE %al
.endm
.macro GETBYTE_dp
       LEA_dp
       call SPC_read
.endm
.macro GETWORD_dp
       LEA_dp
       call SPC_read
       movb %al, %ah
       incl %edx
       call SPC_read
       xchg %al, %ah
       decl %edx
.endm
.macro GETBYTE_dpX
       LEA_dpX
       call SPC_read
.endm
.macro GETBYTE_dpY
       LEA_dpX
       call SPC_read
.endm
.macro GETBYTE_iX
       LEA_iX
       call SPC_read
.endm
.macro GETBYTE_iXinc
       LEA_iXinc
       call SPC_read
.endm
.macro GETBYTE_dp_dp
       LEA_dp
       call SPC_read
.endm
.macro GETBYTE_iY
       LEA_iY
       call SPC_read
.endm
.macro GETBYTE_abs
       LEA_abs
       call SPC_read
.endm
.macro GETBYTE_absX
       LEA_absX
       call SPC_read
.endm
.macro GETBYTE_absY
       LEA_absY
       call SPC_read
.endm
.macro GETBYTE_idpX
       LEA_idpX
       call SPC_read
.endm
.macro GETBYTE_idpY
       LEA_idpY
       call SPC_read
.endm
.macro SETBYTE_dp
       call SPC_write
.endm
.macro SETWORD_dp
       call SPC_write
       xchg %al, %ah
       incl %edx
       call SPC_write
       xchg %al, %ah
       decl %edx
.endm
.macro SETBYTE_dpX
       call SPC_write
.endm
.macro SETBYTE_dpY
       call SPC_write
.endm
.macro SETBYTE_iX
       call SPC_write
.endm
.macro SETBYTE_iXinc
       call SPC_write
.endm
.macro SETBYTE_dp_dp
       LEA_dp
       call SPC_write
.endm
.macro SETBYTE_iY
       call SPC_write
.endm
.macro SETBYTE_abs
       call SPC_write
.endm
.macro SETBYTE_absX
       call SPC_write
.endm
.macro SETBYTE_absY
       call SPC_write
.endm
.macro SETBYTE_idpX
       call SPC_write
.endm
.macro SETBYTE_idpY
       call SPC_write
.endm

.macro	SETUPOPCODE_SPC opCode,func,cycle
	movl $\opCode,%ebx
	roll $2,%ebx
	movl $SPCOpTable,%eax
	movl $\func,(%eax,%ebx)
.endm

	FUNC(_Reset_SPC)
	ENTER

	movl $64,%eax		/* This sets up the rom code, done before registers as it */
	movl _SPCAddress,%edi	/*contains the reset address for the rom code (0xFFC0) */
	addl $0xFFC0,%edi
	movl $SPC_ROM_CODE,%esi
0:	movb (%esi),%cl
	movb %cl,(%edi)
	incl %esi
	incl %edi
	decb %eax
	jnz 0b

	SETUPOPCODE_SPC 0x00,SPC_NOP,2
	SETUPOPCODE_SPC 0x02,SPC_SET0,4
	SETUPOPCODE_SPC	0x03,SPC_BBS0,5
	SETUPOPCODE_SPC 0x04,SPC_OR_A_dp,3
	SETUPOPCODE_SPC 0x05,SPC_OR_A_abs,4
	SETUPOPCODE_SPC 0x06,SPC_OR_A_iX,3
	SETUPOPCODE_SPC 0x07,SPC_OR_A_idpX,6
	SETUPOPCODE_SPC 0x08,SPC_OR_A,2
	SETUPOPCODE_SPC 0x09,SPC_OR_dp_dp,6
	SETUPOPCODE_SPC 0x0A,SPC_OR1_C_mem,5
	SETUPOPCODE_SPC 0x0B,SPC_ASL_dp,4
	SETUPOPCODE_SPC 0x0C,SPC_ASL_abs,5
	SETUPOPCODE_SPC 0x0D,SPC_PUSH_PSW,4
	SETUPOPCODE_SPC 0x0E,SPC_TSET1,6
	SETUPOPCODE_SPC 0x10,SPC_BPL,2
	SETUPOPCODE_SPC 0x12,SPC_CLR0,4
	SETUPOPCODE_SPC	0x13,SPC_BBC0,5
	SETUPOPCODE_SPC 0x14,SPC_OR_A_dpX,4
	SETUPOPCODE_SPC 0x15,SPC_OR_A_absX,5
	SETUPOPCODE_SPC 0x16,SPC_OR_A_absY,5
	SETUPOPCODE_SPC 0x17,SPC_OR_A_idpY,6
	SETUPOPCODE_SPC 0x18,SPC_OR_dp,5
	SETUPOPCODE_SPC 0x19,SPC_OR_iX_iY,5
	SETUPOPCODE_SPC 0x1A,SPC_DECW_dp,6
	SETUPOPCODE_SPC 0x1B,SPC_ASL_dpX,5
	SETUPOPCODE_SPC 0x1C,SPC_ASL_A,2
	SETUPOPCODE_SPC 0x1D,SPC_DEC_X,2
	SETUPOPCODE_SPC 0x1E,SPC_CMP_X_abs,4
	SETUPOPCODE_SPC 0x1F,SPC_JMP_iabslX,6
	SETUPOPCODE_SPC 0x20,SPC_CLRP,2
	SETUPOPCODE_SPC 0x22,SPC_SET1,4
	SETUPOPCODE_SPC	0x23,SPC_BBS1,5
	SETUPOPCODE_SPC 0x24,SPC_AND_A_dp,3
	SETUPOPCODE_SPC 0x25,SPC_AND_A_abs,4
	SETUPOPCODE_SPC 0x26,SPC_AND_A_iX,3
	SETUPOPCODE_SPC 0x27,SPC_AND_A_idpX,6
	SETUPOPCODE_SPC 0x28,SPC_AND_A,2
	SETUPOPCODE_SPC 0x29,SPC_AND_dp_dp,6
	SETUPOPCODE_SPC 0x2A,SPC_OR1_C_notmem,5
	SETUPOPCODE_SPC 0x2B,SPC_ROL_dp,4
	SETUPOPCODE_SPC 0x2C,SPC_ROL_abs,5
	SETUPOPCODE_SPC 0x2D,SPC_PUSH_A,4
	SETUPOPCODE_SPC 0x2E,SPC_CBNE_dp,5
	SETUPOPCODE_SPC 0x2F,SPC_BRA,4
	SETUPOPCODE_SPC 0x30,SPC_BMI,2
	SETUPOPCODE_SPC 0x32,SPC_CLR1,4
	SETUPOPCODE_SPC	0x33,SPC_BBC1,5
	SETUPOPCODE_SPC 0x34,SPC_AND_A_dpX,4
	SETUPOPCODE_SPC 0x35,SPC_AND_A_absX,5
	SETUPOPCODE_SPC 0x36,SPC_AND_A_absY,5
	SETUPOPCODE_SPC 0x37,SPC_AND_A_idpY,6
	SETUPOPCODE_SPC 0x38,SPC_AND_dp,5
	SETUPOPCODE_SPC 0x39,SPC_AND_iX_iY,5
	SETUPOPCODE_SPC 0x3A,SPC_INCW_dp,6
	SETUPOPCODE_SPC 0x3B,SPC_ROL_dpX,5
	SETUPOPCODE_SPC 0x3C,SPC_ROL_A,2
	SETUPOPCODE_SPC 0x3D,SPC_INC_X,2
	SETUPOPCODE_SPC 0x3E,SPC_CMP_X_dp,3
	SETUPOPCODE_SPC 0x3F,SPC_CALL,8
	SETUPOPCODE_SPC 0x40,SPC_SETP,2
	SETUPOPCODE_SPC 0x42,SPC_SET2,4
	SETUPOPCODE_SPC	0x43,SPC_BBS2,5
	SETUPOPCODE_SPC 0x44,SPC_EOR_A_dp,3
	SETUPOPCODE_SPC 0x45,SPC_EOR_A_abs,4
	SETUPOPCODE_SPC 0x46,SPC_EOR_A_iX,3
	SETUPOPCODE_SPC 0x47,SPC_EOR_A_idpX,6
	SETUPOPCODE_SPC 0x48,SPC_EOR_A,2
	SETUPOPCODE_SPC 0x49,SPC_EOR_dp_dp,6
	SETUPOPCODE_SPC 0x4A,SPC_AND1_C_mem,4
	SETUPOPCODE_SPC 0x4B,SPC_LSR_dp,4
	SETUPOPCODE_SPC 0x4C,SPC_LSR_abs,5
	SETUPOPCODE_SPC 0x4D,SPC_PUSH_X,4
	SETUPOPCODE_SPC 0x4E,SPC_TCLR1,6
	SETUPOPCODE_SPC 0x4F,SPC_PCALL,6
	SETUPOPCODE_SPC 0x50,SPC_BVC,2
	SETUPOPCODE_SPC 0x52,SPC_CLR2,4
	SETUPOPCODE_SPC	0x53,SPC_BBC2,5
	SETUPOPCODE_SPC 0x54,SPC_EOR_A_dpX,4
	SETUPOPCODE_SPC 0x55,SPC_EOR_A_absX,5
	SETUPOPCODE_SPC 0x56,SPC_EOR_A_absY,5
	SETUPOPCODE_SPC 0x57,SPC_EOR_A_idpY,6
	SETUPOPCODE_SPC 0x58,SPC_EOR_dp,5
	SETUPOPCODE_SPC 0x59,SPC_EOR_iX_iY,5
	SETUPOPCODE_SPC 0x5A,SPC_CMPW_dp,4
	SETUPOPCODE_SPC 0x5B,SPC_LSR_dpX,5
	SETUPOPCODE_SPC 0x5C,SPC_LSR_A,2
	SETUPOPCODE_SPC 0x5D,SPC_MOV_X_A,2
	SETUPOPCODE_SPC 0x5E,SPC_CMP_Y_abs,4
	SETUPOPCODE_SPC 0x5F,SPC_JMP_absl,3
	SETUPOPCODE_SPC 0x60,SPC_CLRC,2
	SETUPOPCODE_SPC 0x62,SPC_SET3,4
	SETUPOPCODE_SPC	0x63,SPC_BBS3,5
	SETUPOPCODE_SPC 0x64,SPC_CMP_A_dp,3
	SETUPOPCODE_SPC 0x65,SPC_CMP_A_abs,4
	SETUPOPCODE_SPC 0x66,SPC_CMP_A_iX,3
	SETUPOPCODE_SPC 0x67,SPC_CMP_A_idpX,6
	SETUPOPCODE_SPC 0x68,SPC_CMP_A,2
	SETUPOPCODE_SPC 0x69,SPC_CMP_dp_dp,6
	SETUPOPCODE_SPC 0x6A,SPC_AND1_C_notmem,4
	SETUPOPCODE_SPC 0x6B,SPC_ROR_dp,4
	SETUPOPCODE_SPC 0x6C,SPC_ROR_abs,5
	SETUPOPCODE_SPC 0x6D,SPC_PUSH_Y,4
	SETUPOPCODE_SPC 0x6E,SPC_DBNZ_dp,5
	SETUPOPCODE_SPC 0x6F,SPC_RET,5
	SETUPOPCODE_SPC 0x70,SPC_BVS,2
	SETUPOPCODE_SPC 0x72,SPC_CLR3,4
	SETUPOPCODE_SPC	0x73,SPC_BBC3,5
	SETUPOPCODE_SPC 0x74,SPC_CMP_A_dpX,4
	SETUPOPCODE_SPC 0x75,SPC_CMP_A_absX,5
	SETUPOPCODE_SPC 0x76,SPC_CMP_A_absY,5
	SETUPOPCODE_SPC 0x77,SPC_CMP_A_idpY,6
	SETUPOPCODE_SPC 0x78,SPC_CMP_dp,5
	SETUPOPCODE_SPC 0x79,SPC_CMP_iX_iY,5
	SETUPOPCODE_SPC 0x7A,SPC_ADDW_dp,5
	SETUPOPCODE_SPC 0x7B,SPC_ROR_dpX,5
	SETUPOPCODE_SPC 0x7C,SPC_ROR_A,2
	SETUPOPCODE_SPC 0x7D,SPC_MOV_A_X,2
	SETUPOPCODE_SPC 0x7E,SPC_CMP_Y_dp,3
	SETUPOPCODE_SPC 0x80,SPC_SETC,2
	SETUPOPCODE_SPC 0x82,SPC_SET4,4
	SETUPOPCODE_SPC	0x83,SPC_BBS4,5
	SETUPOPCODE_SPC 0x84,SPC_ADC_A_dp,3
	SETUPOPCODE_SPC 0x85,SPC_ADC_A_abs,4
	SETUPOPCODE_SPC 0x86,SPC_ADC_A_iX,3
	SETUPOPCODE_SPC 0x87,SPC_ADC_A_idpX,6
	SETUPOPCODE_SPC 0x88,SPC_ADC_A,2
	SETUPOPCODE_SPC 0x89,SPC_ADC_dp_dp,6
	SETUPOPCODE_SPC 0x8A,SPC_EOR1_C_mem,5
	SETUPOPCODE_SPC 0x8B,SPC_DEC_dp,4
	SETUPOPCODE_SPC 0x8C,SPC_DEC_abs,5
	SETUPOPCODE_SPC 0x8D,SPC_MOV_Y,2
	SETUPOPCODE_SPC 0x8E,SPC_POP_PSW,4
	SETUPOPCODE_SPC 0x8F,SPC_MOV_dp,5
	SETUPOPCODE_SPC 0x90,SPC_BCC,2
	SETUPOPCODE_SPC 0x92,SPC_CLR4,4
	SETUPOPCODE_SPC	0x93,SPC_BBC4,5
	SETUPOPCODE_SPC 0x94,SPC_ADC_A_dpX,4
	SETUPOPCODE_SPC 0x95,SPC_ADC_A_absX,5
	SETUPOPCODE_SPC 0x96,SPC_ADC_A_absY,5
	SETUPOPCODE_SPC 0x97,SPC_ADC_A_idpY,6
	SETUPOPCODE_SPC 0x98,SPC_ADC_dp,5
	SETUPOPCODE_SPC 0x99,SPC_ADC_iX_iY,5
	SETUPOPCODE_SPC 0x9A,SPC_SUBW_dp,5
	SETUPOPCODE_SPC 0x9B,SPC_DEC_dpX,5
	SETUPOPCODE_SPC 0x9C,SPC_DEC_A,2
	SETUPOPCODE_SPC 0x9D,SPC_MOV_X_SP,3
	SETUPOPCODE_SPC 0x9E,SPC_DIV,12
	SETUPOPCODE_SPC 0x9F,SPC_XCN,5
	SETUPOPCODE_SPC 0xA0,SPC_EI,3
	SETUPOPCODE_SPC 0xA2,SPC_SET5,4
	SETUPOPCODE_SPC	0xA3,SPC_BBS5,5
	SETUPOPCODE_SPC 0xA4,SPC_SBC_A_dp,3
	SETUPOPCODE_SPC 0xA5,SPC_SBC_A_abs,4
	SETUPOPCODE_SPC 0xA6,SPC_SBC_A_iX,3
	SETUPOPCODE_SPC 0xA7,SPC_SBC_A_idpX,6
	SETUPOPCODE_SPC 0xA8,SPC_SBC_A,2
	SETUPOPCODE_SPC 0xA9,SPC_SBC_dp_dp,6
	SETUPOPCODE_SPC 0xAA,SPC_MOV1_C_mem,4
	SETUPOPCODE_SPC 0xAB,SPC_INC_dp,4
	SETUPOPCODE_SPC 0xAC,SPC_INC_abs,5
	SETUPOPCODE_SPC 0xAD,SPC_CMP_Y,2
	SETUPOPCODE_SPC 0xAE,SPC_POP_A,4
	SETUPOPCODE_SPC 0xAF,SPC_MOV_iXinc_A,4
	SETUPOPCODE_SPC 0xB0,SPC_BCS,2
	SETUPOPCODE_SPC 0xB2,SPC_CLR5,4
	SETUPOPCODE_SPC	0xB3,SPC_BBC5,5
	SETUPOPCODE_SPC 0xB4,SPC_SBC_A_dpX,4
	SETUPOPCODE_SPC 0xB5,SPC_SBC_A_absX,5
	SETUPOPCODE_SPC 0xB6,SPC_SBC_A_absY,5
	SETUPOPCODE_SPC 0xB7,SPC_SBC_A_idpY,6
	SETUPOPCODE_SPC 0xB8,SPC_SBC_dp,5
	SETUPOPCODE_SPC 0xB9,SPC_SBC_iX_iY,5
	SETUPOPCODE_SPC 0xBA,SPC_MOVW_YA_dp,5
	SETUPOPCODE_SPC 0xBB,SPC_INC_dpX,5
	SETUPOPCODE_SPC 0xBC,SPC_INC_A,2
	SETUPOPCODE_SPC 0xBD,SPC_MOV_SP_X,2
	SETUPOPCODE_SPC 0xBF,SPC_MOV_A_iXinc,4
	SETUPOPCODE_SPC 0xC0,SPC_DI,3
	SETUPOPCODE_SPC 0xC2,SPC_SET6,4
	SETUPOPCODE_SPC	0xC3,SPC_BBS6,5
	SETUPOPCODE_SPC 0xC4,SPC_MOV_dp_A,4
	SETUPOPCODE_SPC 0xC5,SPC_MOV_abs_A,5
	SETUPOPCODE_SPC 0xC6,SPC_MOV_iX_A,4
	SETUPOPCODE_SPC 0xC7,SPC_MOV_idpX_A,7
	SETUPOPCODE_SPC 0xC8,SPC_CMP_X,2
	SETUPOPCODE_SPC 0xC9,SPC_MOV_abs_X,5
	SETUPOPCODE_SPC 0xCA,SPC_MOV1_mem_C,6
	SETUPOPCODE_SPC 0xCB,SPC_MOV_dp_Y,4
	SETUPOPCODE_SPC 0xCC,SPC_MOV_abs_Y,5
	SETUPOPCODE_SPC 0xCD,SPC_MOV_X,2
	SETUPOPCODE_SPC 0xCE,SPC_POP_X,4
	SETUPOPCODE_SPC 0xCF,SPC_MUL,9
	SETUPOPCODE_SPC 0xD0,SPC_BNE,2
	SETUPOPCODE_SPC 0xD2,SPC_CLR6,4
	SETUPOPCODE_SPC	0xD3,SPC_BBC6,5
	SETUPOPCODE_SPC 0xD4,SPC_MOV_dpX_A,5
	SETUPOPCODE_SPC 0xD5,SPC_MOV_absX_A,6
	SETUPOPCODE_SPC 0xD6,SPC_MOV_absY_A,6
	SETUPOPCODE_SPC 0xD7,SPC_MOV_idpY_A,7
	SETUPOPCODE_SPC 0xD8,SPC_MOV_dp_X,4
	SETUPOPCODE_SPC 0xD9,SPC_MOV_dpY_X,5
	SETUPOPCODE_SPC 0xDA,SPC_MOVW_dp_YA,4
	SETUPOPCODE_SPC 0xDB,SPC_MOV_dpX_Y,5
	SETUPOPCODE_SPC 0xDC,SPC_DEC_Y,2
	SETUPOPCODE_SPC 0xDD,SPC_MOV_A_Y,2
	SETUPOPCODE_SPC 0xDE,SPC_CBNE_dpX,6
	SETUPOPCODE_SPC 0xE0,SPC_CLRV,2
	SETUPOPCODE_SPC 0xE2,SPC_SET7,4
	SETUPOPCODE_SPC	0xE3,SPC_BBS7,5
	SETUPOPCODE_SPC 0xE4,SPC_MOV_A_dp,3
	SETUPOPCODE_SPC 0xE5,SPC_MOV_A_abs,4
	SETUPOPCODE_SPC 0xE6,SPC_MOV_A_iX,3
	SETUPOPCODE_SPC 0xE7,SPC_MOV_A_idpX,6
	SETUPOPCODE_SPC 0xE8,SPC_MOV_A,2
	SETUPOPCODE_SPC 0xE9,SPC_MOV_X_abs,4
	SETUPOPCODE_SPC 0xEA,SPC_NOT1,5
	SETUPOPCODE_SPC 0xEB,SPC_MOV_Y_dp,3
	SETUPOPCODE_SPC 0xEC,SPC_MOV_Y_abs,4
	SETUPOPCODE_SPC 0xED,SPC_NOTC,3
	SETUPOPCODE_SPC 0xEE,SPC_POP_Y,4
	SETUPOPCODE_SPC 0xEF,SPC_SLEEP,3
	SETUPOPCODE_SPC 0xF0,SPC_BEQ,2
	SETUPOPCODE_SPC 0xF2,SPC_CLR7,4
	SETUPOPCODE_SPC	0xF3,SPC_BBC7,5
	SETUPOPCODE_SPC 0xF4,SPC_MOV_A_dpX,4
	SETUPOPCODE_SPC 0xF5,SPC_MOV_A_absX,5
	SETUPOPCODE_SPC 0xF6,SPC_MOV_A_absY,5
	SETUPOPCODE_SPC 0xF7,SPC_MOV_A_idpY,6
	SETUPOPCODE_SPC 0xF8,SPC_MOV_X_dp,3
	SETUPOPCODE_SPC 0xFA,SPC_MOV_dp_dp,5
	SETUPOPCODE_SPC 0xFB,SPC_MOV_Y_dpX,4
	SETUPOPCODE_SPC 0xFC,SPC_INC_Y,2
	SETUPOPCODE_SPC 0xFD,SPC_MOV_Y_A,2
	SETUPOPCODE_SPC 0xFE,SPC_DBNZ_Y,4
	SETUPOPCODE_SPC 0xFF,SPC_STOP,3

	movl $0,SPC_Cycles		/* Clear Cycle Count */
	movb $0,_f_V
	movb $0,_f_Z
	movb $0,_f_N
	movb $0,_f_P
	movb $0,_f_C
	movb $0,_sA
	movb $0,_sX
	movb $0,_sY
//	movw $0,SPC_PAGE		/* Used to save looking up P flag for Direct page stuff!*/
//	movw $0,SPC_PSW			/* Clear Flags Register */
	movb $0xFF,_sSP

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

	movl _SPCAddress,%eax		/* Get Address of SPC Data */
	movw $0xFFFE,%ax		/* Get Location of Rom Reset Vector */
	movw (%eax),%ax
	andl $0x0000FFFF,%eax
	addl _SPCAddress,%eax
	movl %eax,_sPC_base

	LEAVEL(L_Reset_CPU)

.globl SPC_START
SPC_START:

	pusha
	movl SPC_Cycles,%eax		/* Not bigger than 16 or so */

	btw $0,_SPC_CTRL	/* Is STO clr, if so timer disabled */
	jnc SKIP_INC_TMR_0

	addb %al,SPC_TIMER0	/* Add cycle count to timer value */
	jnc SKIP_INC_TMR_0	/* If no carry dont increment timer */

	incb _SPC_TIMT0
	movb _SPC_TIM0,%bl
	cmpb %bl,_SPC_TIMT0	/* If equal we should increment cnt */
	jne SKIP_INC_TMR_0

	incb _SPC_CNT0
	andb $0x0F,_SPC_CNT0
	movb $0,_SPC_TIMT0

SKIP_INC_TMR_0:

	btw $1,_SPC_CTRL	/* Is ST1 clr, if so timer disabled */
	jnc SKIP_INC_TMR_1

	addb %al,SPC_TIMER1	/* Add cycle count to timer value */
	jnc SKIP_INC_TMR_1	/* If no carry dont increment timer */

	incb _SPC_TIMT1
	movb _SPC_TIM1,%bl
	cmpb %bl,_SPC_TIMT1	/* If equal we should increment cnt */
	jne SKIP_INC_TMR_1

	incb _SPC_CNT1
	andb $0x0F,_SPC_CNT1
	movb $0,_SPC_TIMT1

SKIP_INC_TMR_1:

	btw $2,_SPC_CTRL	/* Is ST2 clr, if so timer disabled */
	jnc SKIP_INC_TMR_2

	shlb $3,%al		/* Safe since al<32 */
	addb %al,SPC_TIMER2	/* Add cycle count to timer value */
	jnc SKIP_INC_TMR_2	/* If no carry dont increment timer */

	incb _SPC_TIMT2
	movb _SPC_TIM2,%bl
	cmpb %bl,_SPC_TIMT2	/* If equal we should increment cnt */
	jne SKIP_INC_TMR_2

	incb _SPC_CNT2
	andb $0x0F,_SPC_CNT2
	movb $0,_SPC_TIMT2

SKIP_INC_TMR_2:

SPC_LOOP:

       movl     _SPCAddress,  %ebp
       movl     _sPC_base, %esi
       movb     _sA, nA
       movb     _sX, nX
       movb     _sY, nY

       xorl     %eax, %eax
       xorl     %edx, %edx
       lodsb
       jmp      SPCOpTable(,%eax,4)

execute_end:
       subl     %eax, SPC_Cycles

       movb     nA, _sA
       movb     nX, _sX
       movb     nY, _sY

       movl     %esi, _sPC_base

       cmpl $0,SPC_Cycles
       jg SPC_LOOP		/* Do another instruction if still cycles left to execute */

       movl SPC_Cycles,%eax
       movl Get_Fixup(,%eax,4),%eax
       movl %eax,SPC_Fixup		/* CPUs now rebalanced (or there abouts!) */

       popa
       ret			/* Otherwise return and execute some more CPU code */

        .long   20*4                      /* The largest cycle count is 12 so this table should */
        .long   16*4                      /*be big enough to balance the two cpus! */
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
Get_Fixup:				/* Pointer to 0th point on negative climbing table */
        .long   4*4

// 00 : NOP
OPBEGIN(NOP)
OPEND(2)

.macro MOV_ suff reg addr cycles
OPBEGIN(MOV_\suff)
  GETBYTE_\addr
  movb %al, \reg
  SAVEF(%al)
OPEND(\cycles)
.endm

MOV_ A,       nA, imm,   2
MOV_ A_iX,    nA, iX,    3
MOV_ A_iXinc, nA, iXinc, 4
MOV_ A_dp,    nA, dp,    3
MOV_ A_dpX,   nA, dpX,   4
MOV_ A_abs,   nA, abs,   4
MOV_ A_absX,  nA, absX,  5
MOV_ A_absY,  nA, absY,  5
MOV_ A_idpX,  nA, idpX,  6
MOV_ A_idpY,  nA, idpY,  6

MOV_ X,       nX, imm,   2
MOV_ X_dp,    nX, dp,    3
MOV_ X_dpY,   nX, dpY,   4
MOV_ X_abs,   nX, abs,   4

MOV_ Y,       nY, imm,   2
MOV_ Y_dp,    nY, dp,    3
MOV_ Y_dpX,   nY, dpX,   4
MOV_ Y_abs,   nY, abs,   4

.macro MOV__ suff reg addr cycles
OPBEGIN(MOV_\suff)
  LEA_\addr
  movb \reg, %al
  SETBYTE_\addr
OPEND(\cycles)
.endm

MOV__ iX_A,    nA, iX,    4
MOV__ iXinc_A, nA, iXinc, 4
MOV__ dp_A,    nA, dp,    4
MOV__ dpX_A,   nA, dpX,   5
MOV__ abs_A,   nA, abs,   5
MOV__ absX_A,  nA, absX,  6
MOV__ absY_A,  nA, absY,  6
MOV__ idpX_A,  nA, idpX,  7
MOV__ idpY_A,  nA, idpY,  7

MOV__ dp_X,    nX, dp,    4
MOV__ dpY_X,   nX, dpY,   5
MOV__ abs_X,   nX, abs,   5

MOV__ dp_Y,    nY, dp,    4
MOV__ dpX_Y,   nY, dpX,   5
MOV__ abs_Y,   nY, abs,   5

.macro MOV___ suff src dest cycles
OPBEGIN(MOV_\suff)
  movb \src, \dest
  SAVEF(\dest)
OPEND(\cycles)
.endm

MOV___ A_X,    nX, nA,    2
MOV___ A_Y,    nY, nA,    2
MOV___ X_A,    nA, nX,    2
MOV___ Y_A,    nA, nY,    2

OPBEGIN(MOV_X_SP)
  movb _sSP, nX
OPEND(2)

OPBEGIN(MOV_SP_X)
  movb nX, _sSP
OPEND(2)

OPBEGIN(MOV_dp_dp)
  GETBYTE_dp_dp
  SETBYTE_dp_dp
OPEND(5)

OPBEGIN(MOV_dp)
  GETBYTE_imm
  LEA_dp
  SETBYTE_dp
OPEND(5)

.macro ADC_ suff reg addr cycles
OPBEGIN(ADC_\suff)
  GETBYTE_\addr
  GETC
  adcb %al, \reg
  SAVEFCO(\reg)
OPEND(\cycles)
.endm

.macro SBC_ suff reg addr cycles
OPBEGIN(SBC_\suff)
  GETBYTE_\addr
  xorb $0xff, %al
  GETC
  adcb %al, \reg
  SAVEFCO(\reg)
OPEND(\cycles)
.endm

ADC_ A,       nA, imm,   2
ADC_ A_iX,    nA, iX,    3
ADC_ A_dp,    nA, dp,    3
ADC_ A_dpX,   nA, dpX,   4
ADC_ A_abs,   nA, abs,   4
ADC_ A_absX,  nA, absX,  5
ADC_ A_absY,  nA, absY,  5
ADC_ A_idpX,  nA, idpX,  6
ADC_ A_idpY,  nA, idpY,  6

OPBEGIN(ADC_iX_iY)
  GETBYTE_iY
  movb %al, %bh
  GETBYTE_iX
  GETC
  adcb %bh, %al
  SAVEFCO(%al)
  SETBYTE_iX
OPEND(5)

OPBEGIN(ADC_dp_dp)
  GETBYTE_dp
  movb %al, %bh
  GETBYTE_dp
  GETC
  adcb %bh, %al
  SAVEFCO(%al)
  SETBYTE_dp
OPEND(6)

OPBEGIN(ADC_dp)
  GETBYTE_imm
  movb %al, %bh
  GETBYTE_dp
  GETC
  adcb %bh, %al
  SAVEFCO(%al)
  SETBYTE_dp
OPEND(5)

SBC_ A,       nA, imm,   2
SBC_ A_iX,    nA, iX,    3
SBC_ A_dp,    nA, dp,    3
SBC_ A_dpX,   nA, dpX,   4
SBC_ A_abs,   nA, abs,   4
SBC_ A_absX,  nA, absX,  5
SBC_ A_absY,  nA, absY,  5
SBC_ A_idpX,  nA, idpX,  6
SBC_ A_idpY,  nA, idpY,  6

OPBEGIN(SBC_iX_iY)
  GETBYTE_iY
  xorb $0xff, %al
  movb %al, %bh
  GETBYTE_iX
  GETC
  adcb %bh, %al
  SAVEFCO(%al)
  SETBYTE_iX
OPEND(5)

OPBEGIN(SBC_dp_dp)
  GETBYTE_dp
  xorb $0xff, %al
  movb %al, %bh
  GETBYTE_dp
  GETC
  adcb %bh, %al
  SAVEFCO(%al)
  SETBYTE_dp
OPEND(6)

OPBEGIN(SBC_dp)
  GETBYTE_imm
  xorb $0xff, %al
  movb %al, %bh
  GETBYTE_dp
  GETC
  adcb %bh, %al
  SAVEFCO(%al)
  SETBYTE_dp
OPEND(5)

.macro CMP_ suff reg addr cycles
OPBEGIN(CMP_\suff)
  GETBYTE_\addr
  movb \reg, %ah
  subb %al,  %ah
  SAVEF(%ah)
  setnc _f_C
OPEND(\cycles)
.endm

CMP_ A,       nA, imm,   2
CMP_ A_iX,    nA, iX,    3
CMP_ A_dp,    nA, dp,    3
CMP_ A_dpX,   nA, dpX,   4
CMP_ A_abs,   nA, abs,   4
CMP_ A_absX,  nA, absX,  5
CMP_ A_absY,  nA, absY,  5
CMP_ A_idpX,  nA, idpX,  6
CMP_ A_idpY,  nA, idpY,  6

CMP_ X,       nX, imm,   2
CMP_ X_dp,    nX, dp,    3
CMP_ X_abs,   nX, abs,   4

CMP_ Y,       nY, imm,   2
CMP_ Y_dp,    nY, dp,    3
CMP_ Y_abs,   nY, abs,   4

OPBEGIN(CMP_iX_iY)
  GETBYTE_iY
  movb %al, %ah
  GETBYTE_iX
  subb %ah, %al
  SAVEF(%al)
  setnc _f_C
OPEND(5)

OPBEGIN(CMP_dp_dp)
  GETBYTE_dp
  movb %al, %ah
  GETBYTE_dp
  subb %ah, %al
  SAVEF(%al)
  setnc _f_C
OPEND(6)

OPBEGIN(CMP_dp)
  GETBYTE_imm
  movb %al, %ah
  GETBYTE_dp
  subb %ah, %al
  SAVEF(%al)
  setnc _f_C
OPEND(6)

.macro AND_ suff reg addr cycles
OPBEGIN(AND_\suff)
  GETBYTE_\addr
  andb %al, \reg
  SAVEF(\reg)
OPEND(\cycles)
.endm

.macro OR_ suff reg addr cycles
OPBEGIN(OR_\suff)
  GETBYTE_\addr
  orb %al, \reg
  SAVEF(\reg)
OPEND(\cycles)
.endm

.macro EOR_ suff reg addr cycles
OPBEGIN(EOR_\suff)
  GETBYTE_\addr
  xorb %al, \reg
  SAVEF(\reg)
OPEND(\cycles)
.endm

AND_ A,       nA, imm,   2
AND_ A_iX,    nA, iX,    3
AND_ A_dp,    nA, dp,    3
AND_ A_dpX,   nA, dpX,   4
AND_ A_abs,   nA, abs,   4
AND_ A_absX,  nA, absX,  5
AND_ A_absY,  nA, absY,  5
AND_ A_idpX,  nA, idpX,  6
AND_ A_idpY,  nA, idpY,  6

OR_  A,       nA, imm,   2
OR_  A_iX,    nA, iX,    3
OR_  A_dp,    nA, dp,    3
OR_  A_dpX,   nA, dpX,   4
OR_  A_abs,   nA, abs,   4
OR_  A_absX,  nA, absX,  5
OR_  A_absY,  nA, absY,  5
OR_  A_idpX,  nA, idpX,  6
OR_  A_idpY,  nA, idpY,  6

EOR_ A,       nA, imm,   2
EOR_ A_iX,    nA, iX,    3
EOR_ A_dp,    nA, dp,    3
EOR_ A_dpX,   nA, dpX,   4
EOR_ A_abs,   nA, abs,   4
EOR_ A_absX,  nA, absX,  5
EOR_ A_absY,  nA, absY,  5
EOR_ A_idpX,  nA, idpX,  6
EOR_ A_idpY,  nA, idpY,  6

OPBEGIN(AND_iX_iY)
  GETBYTE_iY
  movb %al, %ah
  GETBYTE_iX
  andb %ah, %al
  SAVEF(%al)
  SETBYTE_iX
OPEND(5)

OPBEGIN(AND_dp_dp)
  GETBYTE_dp
  movb %al, %ah
  GETBYTE_dp
  andb %ah, %al
  SAVEF(%al)
  SETBYTE_dp
OPEND(6)

OPBEGIN(AND_dp)
  GETBYTE_imm
  movb %al, %ah
  GETBYTE_dp
  andb %ah, %al
  SAVEF(%al)
  SETBYTE_dp
OPEND(5)

OPBEGIN(OR_iX_iY)
  GETBYTE_iY
  movb %al, %ah
  GETBYTE_iX
  orb %ah, %al
  SAVEF(%al)
  SETBYTE_iX
OPEND(5)

OPBEGIN(OR_dp_dp)
  GETBYTE_dp
  movb %al, %ah
  GETBYTE_dp
  orb %ah, %al
  SAVEF(%al)
  SETBYTE_dp
OPEND(6)

OPBEGIN(OR_dp)
  GETBYTE_imm
  movb %al, %ah
  GETBYTE_dp
  orb %ah, %al
  SAVEF(%al)
  SETBYTE_dp
OPEND(5)

OPBEGIN(EOR_iX_iY)
  GETBYTE_iY
  movb %al, %ah
  GETBYTE_iX
  xorb %ah, %al
  SAVEF(%al)
  SETBYTE_iX
OPEND(5)

OPBEGIN(EOR_dp_dp)
  GETBYTE_dp
  movb %al, %ah
  GETBYTE_dp
  xorb %ah, %al
  SAVEF(%al)
  SETBYTE_dp
OPEND(6)

OPBEGIN(EOR_dp)
  GETBYTE_imm
  movb %al, %ah
  GETBYTE_dp
  xorb %ah, %al
  SAVEF(%al)
  SETBYTE_dp
OPEND(5)

OPBEGIN(INC_A)
  incb nA
  SAVEF(nA)
OPEND(2)

OPBEGIN(INC_X)
  incb nX
  SAVEF(nX)
OPEND(2)

OPBEGIN(INC_Y)
  incb nY
  SAVEF(nY)
OPEND(2)

OPBEGIN(DEC_A)
  decb nA
  SAVEF(nA)
OPEND(2)

OPBEGIN(DEC_X)
  decb nX
  SAVEF(nX)
OPEND(2)

OPBEGIN(DEC_Y)
  decb nY
  SAVEF(nY)
OPEND(2)


.macro INC_ name addr cycles
OPBEGIN(\name)
  GETBYTE_\addr
  incb %al
  SAVEF(%al)
  SETBYTE_\addr
OPEND(\cycles)
.endm

.macro DEC_ name addr cycles
OPBEGIN(\name)
  GETBYTE_\addr
  decb %al
  SAVEF(%al)
  SETBYTE_\addr
OPEND(\cycles)
.endm

INC_ INC_dp,  dp,  4
INC_ INC_dpX, dpX, 5
INC_ INC_abs, abs, 5

DEC_ DEC_dp,  dp,  4
DEC_ DEC_dpX, dpX, 5
DEC_ DEC_abs, abs, 5

OPBEGIN(ASL_A)
  shlb $1, nA
  SAVEFC(nA)
OPEND(2)

OPBEGIN(LSR_A)
  shrb $1, nA
  SAVEFC(nA)
OPEND(2)

OPBEGIN(ROL_A)
  GETC
  rclb $1, nA
  SAVEFC(nA)
OPEND(2)

OPBEGIN(ROR_A)
  GETC
  rcrb $1, nA
  SAVEFC(nA)
OPEND(2)

.macro SH_ name instr addr cycles
OPBEGIN(\name)
  GETBYTE_\addr
  \instr $1, %al
  SAVEFC(%al)
  SETBYTE_\addr
OPEND(\cycles)
.endm

.macro ROT_ name instr addr cycles
OPBEGIN(\name)
  GETBYTE_\addr
  GETC
  \instr $1, %al
  SAVEFC(%al)
  SETBYTE_\addr
OPEND(\cycles)
.endm

SH_ ASL_dp,  shlb, dp,  4
SH_ ASL_dpX, shlb, dpX, 5
SH_ ASL_abs, shlb, abs, 5

SH_ LSR_dp,  shrb, dp,  4
SH_ LSR_dpX, shrb, dpX, 5
SH_ LSR_abs, shrb, abs, 5

ROT_ ROL_dp,  rclb, dp,  4
ROT_ ROL_dpX, rclb, dpX, 5
ROT_ ROL_abs, rclb, abs, 5

ROT_ ROR_dp,  rcrb, dp,  4
ROT_ ROR_dpX, rcrb, dpX, 5
ROT_ ROR_abs, rcrb, abs, 5

OPBEGIN(XCN)
  rolb $4, nA
  SAVEF(nA)
OPEND(5)

OPBEGIN(MOVW_YA_dp)
  GETWORD_dp
  movw %ax, %cx

  SAVEF(%ah)
  orb %al, _f_Z
OPEND(5)

OPBEGIN(MOVW_dp_YA)
  LEA_dp

  movw %cx, %ax
  SETWORD_dp
OPEND(4)

OPBEGIN(INCW_dp)
  GETWORD_dp
  incw %ax
  SAVEF(%ah)
  orb %al, _f_Z
  SETWORD_dp
OPEND(6)

OPBEGIN(DECW_dp)
  GETWORD_dp
  decw %ax
  SAVEF(%ah)
  orb %al, _f_Z
  SETWORD_dp
OPEND(6)

OPBEGIN(ADDW_dp)
  GETWORD_dp
  addw %ax, %cx
  SAVEFCO(%ah)
  orb %al, _f_Z
OPEND(5)

OPBEGIN(SUBW_dp)
  GETWORD_dp
  subw %ax, %cx
  SAVEFCO(%ah)
  orb %al, _f_Z
OPEND(5)

OPBEGIN(CMPW_dp)
  GETWORD_dp
  movw %cx, %dx
  subw %ax, %dx
  SAVEF(%dh)
  orb %dl, _f_Z
OPEND(6)

OPBEGIN(MUL)
  movb nY, %al
  mulb nA
  movw %ax, %cx
  SAVEF(%ah)
  orb %al, _f_Z
OPEND(9)

OPBEGIN(DIV)
  testb nX, nX
  jz 0f
  movw %cx, %ax
  movb $0, %bh
  divw %bx
  movb %al, nA
  movb %dl, nY
  SAVEFCO(%al)
  testb %ah, %ah
  setnz _f_V
0:
OPEND(12)

do_branch:
  FETCHBYTE %al

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

OPBEGIN(BRA)
  jmp do_branch

OPBEGIN(BEQ)
  cmpb %dl, _f_Z
  jz do_branch

  incl %esi
OPEND(2)

OPBEGIN(BNE)
  cmpb %dl, _f_Z
  jnz do_branch

  incl %esi
OPEND(2)

OPBEGIN(BCS)
  cmpb %dl, _f_C
  jnz do_branch

  incl %esi
OPEND(2)

OPBEGIN(BCC)
  cmpb %dl, _f_C
  jz do_branch

  incl %esi
OPEND(2)

OPBEGIN(BVS)
  cmpb %dl, _f_V
  jnz do_branch

  incl %esi
OPEND(2)

OPBEGIN(BVC)
  cmpb %dl, _f_V
  jz do_branch

  incl %esi
OPEND(2)

OPBEGIN(BPL)
  movb _f_N, %dl
  testb %dl, %dl
  jns do_branch

  incl %esi
OPEND(2)

OPBEGIN(BMI)
  movb _f_N, %dl
  testb %dl, %dl
  js do_branch

  incl %esi
OPEND(2)

.macro BB_ bit
OPBEGIN(BBS\bit)
  GETBYTE_dp
  movb $3, %ah
  btb $\bit, %al
  jc do_branch

  incl %esi
OPEND(5)

OPBEGIN(BBC\bit)
  GETBYTE_dp
  movb $3, %ah
  btb $\bit, %al
  jnc do_branch

  incl %esi
OPEND(5)
.endm

BB_ 0
BB_ 1
BB_ 2
BB_ 3
BB_ 4
BB_ 5
BB_ 6
BB_ 7

OPBEGIN(CBNE_dp)
  GETBYTE_dp
  movb $3, %ah
  cmpb %al, nA
  jne do_branch

  incl %esi
OPEND(5)

OPBEGIN(CBNE_dpX)
  GETBYTE_dpX
  movb $4, %ah
  cmpb %al, nA
  jne do_branch

  incl %esi
OPEND(6)

OPBEGIN(DBNZ_dp)
  GETBYTE_dp
  decb %al
  SETBYTE_dp
  movb $3, %ah
  testb %al, %al
  jne do_branch

  incl %esi
OPEND(5)

OPBEGIN(DBNZ_Y)
  movb $2, %ah
  decb nY
  jne do_branch

  incl %esi
OPEND(4)

OPBEGIN(JMP_absl)
  LEA_abs
  addl _SPCAddress, %edx
  movl %edx, %esi
OPEND(3)

OPBEGIN(JMP_iabslX)
  LEA_absX
  movw (%ebp, %edx), %dx
  addl _SPCAddress, %edx
  movl %edx, %esi
OPEND(3)

.macro PUSHB reg
  movb \reg, 0x100(%ebp, %edx)
  decl %edx
.endm

.macro POPB reg
  incl %edx
  movb 0x100(%ebp, %edx), \reg
.endm

.macro PUSHW reg
  decl %edx
  movw \reg, 0x100(%ebp, %edx)
  decl %edx
.endm

.macro POPW reg
  incl %edx
  movw 0x100(%ebp, %edx), \reg
  incl %edx
.endm

OPBEGIN(CALL)
  movl %esi, %eax
  movb _sSP, %dl
  subl _SPCAddress, %esi
  addw $2, %si
  PUSHW %si
  movb %dl, _sSP

  movw (%eax), %dx
  addl _SPCAddress, %edx
  movl %edx, %esi
OPEND(8)

OPBEGIN(RET)
  xorl %esi, %esi

  movb _sSP, %dl
  POPW %si
  movb %dl, _sSP

  addl _SPCAddress, %esi
OPEND(5)

OPBEGIN(PUSH_A)
  movb _sSP, %dl
  PUSHB nA
  movb %dl, _sSP
OPEND(4)

OPBEGIN(PUSH_X)
  movb _sSP, %dl
  PUSHB nX
  movb %dl, _sSP
OPEND(4)

OPBEGIN(PUSH_Y)
  movb _sSP, %dl
  PUSHB nY
  movb %dl, _sSP
OPEND(4)

OPBEGIN(POP_A)
  movb _sSP, %dl
  POPB nA
  movb %dl, _sSP
OPEND(4)

OPBEGIN(POP_X)
  movb _sSP, %dl
  POPB nX
  movb %dl, _sSP
OPEND(4)

OPBEGIN(POP_Y)
  movb _sSP, %dl
  POPB nY
  movb %dl, _sSP
OPEND(4)

OPBEGIN(PUSH_PSW)
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
  PUSHB %al
  movb %dl, _sSP
OPEND(4)

OPBEGIN(POP_PSW)
  movb _sSP, %dl
  POPB %al
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
OPEND(4)

.macro BO_ bit
OPBEGIN(SET\bit)
  GETBYTE_dp
  btsb $\bit, %al
  SETBYTE_dp
OPEND(4)

OPBEGIN(CLR\bit)
  GETBYTE_dp
  btcb $\bit, %al
  SETBYTE_dp
OPEND(4)
.endm

BO_ 0
BO_ 1
BO_ 2
BO_ 3
BO_ 4
BO_ 5
BO_ 6
BO_ 7

OPBEGIN(TSET1)
  GETBYTE_abs
  movb %al, %ah
  orb nA, %al
  SETBYTE_abs

  andb nA, %ah
  SAVEF(%ah)
OPEND(4)

OPBEGIN(TCLR1)
  GETBYTE_abs
  movb %al, %ah
  notb nA
  andb nA, %al
  notb nA
  SETBYTE_abs

  andb nA, %ah
  SAVEF(%ah)
OPEND(4)

OPBEGIN(MOV1_C_mem)
  FETCHWORD %ax
  movb %al, %bh
  andb $7, %bh
  shrl $3, %eax
  movb (%ebp, %eax), %dl
  btb  %bh, %dl
  setc _f_C
OPEND(4)

OPBEGIN(EOR1_C_mem)
  FETCHWORD %ax
  movb %al, %bh
  andb $7, %bh
  shrl $3, %eax
  movb (%ebp, %eax), %dl
  btb  %bh, %dl
  jnc  0f
  notb _f_C
0:
OPEND(4)

OPBEGIN(OR1_C_mem)
  FETCHWORD %ax
  movb %al, %bh
  andb $7, %bh
  shrl $3, %eax
  movb (%ebp, %eax), %dl
  btb  %bh, %dl
  jnc  0f
  movb $1, _f_C
0:
OPEND(4)

OPBEGIN(OR1_C_notmem)
  FETCHWORD %ax
  movb %al, %bh
  andb $7, %bh
  shrl $3, %eax
  movb (%ebp, %eax), %dl
  btb  %bh, %dl
  jc  0f
  movb $1, _f_C
0:
OPEND(4)

OPBEGIN(AND1_C_mem)
  FETCHWORD %ax
  movb %al, %bh
  andb $7, %bh
  shrl $3, %eax
  movb (%ebp, %eax), %dl
  btb  %bh, %dl
  jc  0f
  movb $0, _f_C
0:
OPEND(4)

OPBEGIN(AND1_C_notmem)
  FETCHWORD %ax
  movb %al, %bh
  andb $7, %bh
  shrl $3, %eax
  movb (%ebp, %eax), %dl
  btb  %bh, %dl
  jnc  0f
  movb $0, _f_C
0:
OPEND(4)

OPBEGIN(NOT1)
  FETCHWORD %ax
  movb %al, %bh
  andb $7, %bh
  shrl $3, %eax
  movb (%ebp, %eax), %dl
  btcb  %bh, %dl
  movb %dl, (%ebp, %eax)
OPEND(5)

OPBEGIN(MOV1_mem_C)
  FETCHWORD %ax
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
OPEND(6)

OPBEGIN(CLRC)
  movb %dl, _f_C
OPEND(2)

OPBEGIN(SETC)
  movb $1, _f_C
OPEND(2)

OPBEGIN(NOTC)
  notb _f_C
OPEND(2)

OPBEGIN(CLRV)
  movb %dl, _f_V
OPEND(2)

OPBEGIN(CLRP)
  movb %dl, _f_P
OPEND(2)

OPBEGIN(SETP)
  movb $1, _f_P
OPEND(2)

// nons implementees

OPBEGIN(DAS)
OPEND(3)

OPBEGIN(DAA)
OPEND(3)

OPBEGIN(EI)
OPEND(2)

OPBEGIN(DI)
OPEND(2)

.macro TCALL_ n
OPBEGIN(TCALL\n)
OPEND(8)
.endm

TCALL_ 0
TCALL_ 1
TCALL_ 2
TCALL_ 3
TCALL_ 4
TCALL_ 5
TCALL_ 6
TCALL_ 7
TCALL_ 8
TCALL_ 9
TCALL_ 10
TCALL_ 11
TCALL_ 12
TCALL_ 13
TCALL_ 14
TCALL_ 15

OPBEGIN(RETI)
OPEND(6)

OPBEGIN(STOP)
  decl %esi
OPEND(3)

OPBEGIN(SLEEP)
  decl %esi
OPEND(3)

OPBEGIN(BRK)
  decl %esi
OPEND(8)

OPBEGIN(PCALL)
  incl %esi
OPEND(6)

SPC_ROM_CODE:			/* This code should be copied into the top of the ram area */
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
	movb (%edi,%ebx),%al		/* read from DSP register */
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

/* WOOPS... TIMER registers are write only, the actual timer clock is internal not accessable! */

/* COUNTERS ARE 4 BIT, upon read they reset to 0 status */

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

SPC_WRITE_CTRL:			/* | ---- | ---- | PC32 | PC10 | ---- | ST2  | ST1  | ST0  | */
	pushl %eax
	movb $0,%ah
	btw $4,%ax			/* Is Reset ports 1 & 0 set? */
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

#ifdef DEBUG
.macro DSP_DATA_DEBUG num
	movb %al,_DEBUG_VALUE\num
	movl _SPC_DSP,%edi
	movb %al,(%edi,%ebx)	/* Write data to DSP register */
	popl %ecx
	popl %ebx
	ret
.endm
#endif

.macro SPC_DECODE num
	pusha
	movb $\num,_DECODE_BYTE
	call _SPC_DECODE
	popa
.endm

SPC_WRITE_DSP_DATA:
	pusha
	call _SPC_UPDATEAUDIO
	popa
	cmpb $0x4C,SPC_DSP_ADDR
	jne 0f
	andb SPC_MASK,%al		/* Temp hack to remove some channels for sound */
	movb %al,_DSP_KEY_ON
	pusha
      btw $0,%ax
	jnc 1f
	SPC_DECODE 0
1:
	btw $1,%ax
	jnc 1f
	SPC_DECODE 1
1:
	btw $2,%ax
	jnc 1f
	SPC_DECODE 2
1:
	btw $3,%ax
	jnc 1f
	SPC_DECODE 3
1:
	btw $4,%ax
	jnc 1f
	SPC_DECODE 4
1:
	btw $5,%ax
	jnc 1f
	SPC_DECODE 5
1:
	btw $6,%ax
	jnc 1f
	SPC_DECODE 6
1:
	btw $7,%ax
	jnc 1f
	SPC_DECODE 7
1:
2:	call _PlayVoices
	popa
0:
	pushl %ebx
	pushl %ecx
	xorl %ebx,%ebx
	movb SPC_DSP_ADDR,%bl
	andb $0x7F,%bl			/* Mask off bits not used ie.. top part of area */
	movb %bl,%cl
	andb $0x0F,%cl
#ifdef DEBUG
	cmpb $0x0C,%cl
	je 0f
#endif
	movl _SPC_DSP,%edi
	movb %al,(%edi,%ebx)	/* Write data to DSP register */
	popl %ecx
	popl %ebx
	ret
#ifdef DEBUG
0:
	movb %bl,%cl
	andb $0xF0,%cl
	cmpb $0x00,%cl
	je 1f
	cmpb $0x10,%cl
	je 2f
	cmpb $0x20,%cl
	je 3f
	cmpb $0x30,%cl
	je 4f
	cmpb $0x40,%cl
	je 5f
	cmpb $0x50,%cl
	je 6f
	cmpb $0x60,%cl
	je 7f
	cmpb $0x70,%cl
	je 8f
	popl %ecx
	popl %ebx
	ret
1:	DSP_DATA_DEBUG 1
2:	DSP_DATA_DEBUG 2
3:	DSP_DATA_DEBUG 3
4:	DSP_DATA_DEBUG 4
5:	DSP_DATA_DEBUG 5
6:	DSP_DATA_DEBUG 6
7:	DSP_DATA_DEBUG 7
8:	DSP_DATA_DEBUG 8
#endif

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

SPC_WRITE_TIMER_0:			/* This can only be done when ST? = 0 */
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

Read_Func_Map:				/* Mappings for SPC Registers */
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

Write_Func_Map:				/* Mappings for SPC Registers */
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
