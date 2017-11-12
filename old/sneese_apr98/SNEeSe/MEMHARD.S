/*

 memhard.S - Contains the hardware mapping functions

*/

/* JOYPAD UPDATE FUNCTION.. now called during VBL to accomodate JOYC1 & JOYC2 */

.macro TEST_DEF_KEY key		/* Jnz indicates key pressed! */
	pushl %edx
	movl \key,%edx
	cmpb $0,_key(%edx)	/* Is Key Pressed */
	popl %edx		/* This is allowed as it does not affect the flags! */
.endm

.globl UPDATE_CONTROLLERS
UPDATE_CONTROLLERS:
	pusha

/* UPDATE CONTROLLER 1 */

	cmpb $0,_JOYSTICK_ENABLED
	je 1f

	call _poll_joystick

	xorb %al,%al
        cmpw $0,_joy_b4         /* Is A pressed */
	je 0f
	orb $0x80,%al
0:      cmpw $0,_joy_b2         /* Is X pressed */
        je 0f
	orb $0x40,%al
0:	cmpw $0,_joy_b5		/* Is L pressed */
	je 0f
	orb $0x20,%al
0:	cmpw $0,_joy_b6		/* Is R pressed */
	je 0f
	orb $0x10,%al
0:	movb %al,JOY1L

	xorb %al,%al
        cmpw $0,_joy_b3         /* Is B pressed */
	je 0f
	orb $0x80,%al
0:      cmpw $0,_joy_b1         /* Is Y pressed */
        je 0f
	orb $0x40,%al
0:	TEST_DEF_KEY _SNES_KEY_SELECT		/* Is <SELECT> pressed */
	jz 0f
	orb $0x20,%al
0:	TEST_DEF_KEY _SNES_KEY_START		/* Is <START> pressed */
	jz 0f
	orb $0x10,%al
0:	cmpw $0,_joy_up		/* Is <UP> pressed */
	je 0f
	orb $0x08,%al
0:	cmpw $0,_joy_down	/* Is <DOWN> pressed */
	je 0f
	orb $0x04,%al
0:	cmpw $0,_joy_left	/* Is <LEFT> pressed */
	je 0f
	orb $0x02,%al
0:	cmpw $0,_joy_right	/* Is <RIGHT> pressed */
	je 0f
	orb $0x01,%al
0:	movb %al,JOY1H
	jmp 2f
1:
	xorb %al,%al
	TEST_DEF_KEY _SNES_KEY_A		/* Is A pressed */
	jz 0f
	orb $0x80,%al
0:	TEST_DEF_KEY _SNES_KEY_X		/* Is X pressed */
	jz 0f
	orb $0x40,%al
0:	TEST_DEF_KEY _SNES_KEY_L		/* Is L pressed */
	jz 0f
	orb $0x20,%al
0:	TEST_DEF_KEY _SNES_KEY_R		/* Is R pressed */
	jz 0f
	orb $0x10,%al
0:	movb %al,JOY1L

	xorb %al,%al
	TEST_DEF_KEY _SNES_KEY_B		/* Is B pressed */
	jz 0f
	orb $0x80,%al
0:	TEST_DEF_KEY _SNES_KEY_Y		/* Is Y pressed */
	jz 0f
	orb $0x40,%al
0:	TEST_DEF_KEY _SNES_KEY_SELECT		/* Is <SELECT> pressed */
	jz 0f
	orb $0x20,%al
0:	TEST_DEF_KEY _SNES_KEY_START		/* Is <START> pressed */
	jz 0f
	orb $0x10,%al
0:	TEST_DEF_KEY _SNES_KEY_UP		/* Is <UP> pressed */
	jz 0f
	orb $0x08,%al
0:	TEST_DEF_KEY _SNES_KEY_DOWN	/* Is <DOWN> pressed */
	jz 0f
	orb $0x04,%al
0:	TEST_DEF_KEY _SNES_KEY_LEFT	/* Is <LEFT> pressed */
	jz 0f
	orb $0x02,%al
0:	TEST_DEF_KEY _SNES_KEY_RIGHT	/* Is <RIGHT> pressed */
	jz 0f
	orb $0x01,%al
0:	movb %al,JOY1H

2:

/* UPDATE CONTROLLER 2 */

	cmpb $0,_JOYSTICK_ENABLED2
	je 1f

	call _poll_joystick

	xorb %al,%al
        cmpw $0,_joy_b4         /* Is A pressed */
	je 0f
	orb $0x80,%al
0:      cmpw $0,_joy_b2         /* Is X pressed */
        je 0f
	orb $0x40,%al
0:	cmpw $0,_joy_b5		/* Is L pressed */
	je 0f
	orb $0x20,%al
0:	cmpw $0,_joy_b6		/* Is R pressed */
	je 0f
	orb $0x10,%al
0:	movb %al,JOY2L

	xorb %al,%al
        cmpw $0,_joy_b3         /* Is B pressed */
	je 0f
	orb $0x80,%al
0:      cmpw $0,_joy_b1         /* Is Y pressed */
        je 0f
	orb $0x40,%al
0:	TEST_DEF_KEY _SNES2_KEY_SELECT		/* Is <SELECT> pressed */
	jz 0f
	orb $0x20,%al
0:	TEST_DEF_KEY _SNES2_KEY_START		/* Is <START> pressed */
	jz 0f
	orb $0x10,%al
0:	cmpw $0,_joy_up		/* Is <UP> pressed */
	je 0f
	orb $0x08,%al
0:	cmpw $0,_joy_down	/* Is <DOWN> pressed */
	je 0f
	orb $0x04,%al
0:	cmpw $0,_joy_left	/* Is <LEFT> pressed */
	je 0f
	orb $0x02,%al
0:	cmpw $0,_joy_right	/* Is <RIGHT> pressed */
	je 0f
	orb $0x01,%al
0:	movb %al,JOY2H
	jmp 2f
1:
	xorb %al,%al
	TEST_DEF_KEY _SNES2_KEY_A		/* Is A pressed */
	jz 0f
	orb $0x80,%al
0:	TEST_DEF_KEY _SNES2_KEY_X		/* Is X pressed */
	jz 0f
	orb $0x40,%al
0:	TEST_DEF_KEY _SNES2_KEY_L		/* Is L pressed */
	jz 0f
	orb $0x20,%al
0:	TEST_DEF_KEY _SNES2_KEY_R		/* Is R pressed */
	jz 0f
	orb $0x10,%al
0:	movb %al,JOY2L

	xorb %al,%al
	TEST_DEF_KEY _SNES2_KEY_B		/* Is B pressed */
	jz 0f
	orb $0x80,%al
0:	TEST_DEF_KEY _SNES2_KEY_Y		/* Is Y pressed */
	jz 0f
	orb $0x40,%al
0:	TEST_DEF_KEY _SNES2_KEY_SELECT		/* Is <SELECT> pressed */
	jz 0f
	orb $0x20,%al
0:	TEST_DEF_KEY _SNES2_KEY_START		/* Is <START> pressed */
	jz 0f
	orb $0x10,%al
0:	TEST_DEF_KEY _SNES2_KEY_UP		/* Is <UP> pressed */
	jz 0f
	orb $0x08,%al
0:	TEST_DEF_KEY _SNES2_KEY_DOWN	/* Is <DOWN> pressed */
	jz 0f
	orb $0x04,%al
0:	TEST_DEF_KEY _SNES2_KEY_LEFT	/* Is <LEFT> pressed */
	jz 0f
	orb $0x02,%al
0:	TEST_DEF_KEY _SNES2_KEY_RIGHT	/* Is <RIGHT> pressed */
	jz 0f
	orb $0x01,%al
0:	movb %al,JOY2H
2:
	popa
	ret

.macro	DUPLICATE vartype, amount, data, from=1		/* Why does this need to be 1 ? */
.\vartype \data
.if \amount-\from
DUPLICATE \vartype,\amount,\data,"(\from+1)"
.endif
.endm

/* al is assumed to be the writing byte.. nothing corrupted! */

.macro	DOUBLE_WRITE addr,addrinc	/* Used in Double Write Mapping write h then l */
	cmpb $0,\addrinc		/* Is addrinc first time write ? */
	jnz 5f

	movb %al,\addr			/* Set first byte data */
	movb $1,\addrinc		/* Set to high write next */

	jmp 6f
5:
	movb %al,((\addr)+1)		/* Set high byte */
	movb $0,\addrinc
6:
.endm

.macro TEST_KEY key		/* Jnz indicates key pressed! */
	cmpb $0,_key+\key	/* Is Key Pressed */
.endm

.globl MAP_READ_21
MAP_READ_21:

	movl %esi,%edi
    andl $0xFF,%edi             // Got lo part of hardware address
    jmp Read_Map_21(,%edi,4)    // Jump to mapping routine


MAP_READ_MPYL:
	movb MPYL,%al
	ret

MAP_READ_MPYM:
	movb MPYM,%al
	ret

MAP_READ_MPYH:
	movb MPYH,%al
	ret

MAP_READ_SLHV:  // This latches the counter for horizontal/verticle data!
    movb $0,%al
    movb %al,OPHCT
    movb %al,OPVCT

    // Set up H counters to cycles executed *4, V counter to current scanline

	pushl %eax
	movl SNES_Cycles,%eax
    movl %eax,HoriCount // Already *4... 
    movl HDMAYCount,%eax
    subl $270/2,%eax
    movl %eax,VertCount
	popl %eax	

	ret

MAP_READ_OAMDATAREAD:
    movl OAMAddress,%edi
	addl _OAMAddress,%edi
	movb (%edi),%al
    movl OAMAddress,%edi    // Auto increment sprite number
    incl %edi
    cmpl $0x0220,%edi       // Ensure address wraps correctly!
	jne 0f
    xorl %edi,%edi
0:  movl %edi,OAMAddress
    ret

MAP_READ_VMDATALREAD:

    /* Peek at lower byte assume al is byte*/
    movl VRAMAddress,%edi
    addl %edi,%edi
	addl _VRamAddress,%edi
	movb (%edi),%al
	testb $0x80,VMAIN
	jnz 0f
    pushl %eax
	movw SCINC,%ax
	addw %ax,VRAMAddress		/* Always words (since <<1 !)*/
    popl %eax
0:
  andl $0x7FFF,VRAMAddress    // It fails if this is in on sample.smc
	ret

MAP_READ_VMDATAHREAD:

    /* Peek at upper byte assume al is byte*/
    movl VRAMAddress,%edi
    addl %edi,%edi
	addl _VRamAddress,%edi
    movb 1(%edi),%al
	testb $0x80,VMAIN
	jz 0f
    pushl %eax
	movw SCINC,%ax
    addw %ax,VRAMAddress            /* Always words (since <<1 !)*/
    popl %eax
0:
  andl $0x7FFF,VRAMAddress
	ret

MAP_READ_CGDATAREAD:

	cmpb $0,CGDATAREAD		/* Is addrinc first time read ? */
	jnz 5f

	pushl %ebx
	pushl %eax
	xorl %eax,%eax
	movb CGADD,%al
	movl _Real_SNES_Palette,%edi
	movw (%edi,%eax,2),%bx
	popl %eax
	movb %bl,%al
	popl %ebx
	ret
5:
	movb $0,CGDATAREAD
	pushl %ebx
	pushl %eax
	xorl %eax,%eax
	movb CGADD,%al
	movl _Real_SNES_Palette,%edi
	movw (%edi,%eax,2),%bx
	popl %eax
	movb %bh,%al
	popl %ebx

	incb CGADD		/* Auto Inc address */
	ret

MAP_READ_OPHCT:

	cmpb $0,OPHCT
	jne 0f

	movb HoriCount,%al
	ret

0:	movb HoriCount+1,%al
	movb $0,OPHCT
	ret

MAP_READ_OPVCT:

	cmpb $0,OPVCT
	jne 0f

	movb VertCount,%al
	ret

0:	movb VertCount+1,%al
	movb $0,OPVCT
	ret

MAP_READ_STAT77:

    movb $1,%al        /* This is not supported yet! */
	ret

MAP_READ_STAT78:

	movb _SNES_COUNTRY,%al	/* 0x10 means PAL not NTSC, other bits fairly pointless! */
	ret

MAP_READ_APUI00:

	cmpb $0,APUI00b
	jnz 0f

	movb _SNES_A,%al
	incb APUI00b
	movb $0,APUI01b
	ret

0:	cmpb $1,APUI00b
	jnz 0f

	movb _SNES_X,%al
	incb APUI00b
	movb $1,APUI01b
	ret

0:	cmpb $2,APUI00b
	jnz 0f

	movb _SNES_Y,%al
	incb APUI00b
	movb $2,APUI01b
	ret

0:	cmpb $3,APUI00b
	jnz 0f

    movb $0,%al
	incb APUI00b
	ret

0:	cmpb $4,APUI00b
	jnz 0f

	movb $0xff,%al
	incb APUI00b
	ret

0:	cmpb $5,APUI00b
	jnz 0f

	movb $0x55,%al
	incb APUI00b
	ret

0:	cmpb $6,APUI00b
	jnz 0f

	movb $0x01,%al
	incb APUI00b
	ret

0:	cmpb $7,APUI00b
	jnz 0f

	movb $0xaa,%al
	movb $6,APUI01b
	incb APUI00b
	ret

0:	cmpb $8,APUI00b
	jnz 0f

	movb APUI00a,%al
	incb APUI00b
	ret

0:	movb APUI00c,%al			/* New extra skipper, if all else fails this should work for 2140! */
	incb APUI00c
	movb $0xb,APUI01b			/* This keeps high word at 0 during cycle (for now at least) */
	cmpb $0,APUI00c
	je 0f
	ret

0:	movb $0,APUI00b				/* Ensures the skipper switches off */
	incb APUI01c
	movb $0,APUI01b
	ret

MAP_READ_APUI01:

	cmpb $0,APUI01b
	jnz 0f

	movb _SNES_A+1,%al
	incb APUI01b
	ret

0:	cmpb $1,APUI01b
	jnz 0f

	movb _SNES_X+1,%al
	incb APUI01b
	ret

0:	cmpb $2,APUI01b
	jnz 0f

	movb _SNES_Y+1,%al
	incb APUI01b
	ret

0:	cmpb $3,APUI01b
	jnz 0f

	movb _SNES_A,%al
	incb APUI01b
	ret

0:	cmpb $4,APUI01b
	jnz 0f

	movb _SNES_X,%al
	incb APUI01b
	ret

0:	cmpb $5,APUI01b
	jnz 0f

	movb _SNES_Y,%al
	incb APUI01b
	ret

0:	cmpb $6,APUI01b
	jnz 0f

	movb $0xbb,%al
	incb APUI01b
	ret

0:	cmpb $7,APUI01b
	jnz 0f

    movb $0,%al
	incb APUI01b
	ret

0:	cmpb $8,APUI01b
	jnz 0f

	movb $0xff,%al
	incb APUI01b
	ret

0:	cmpb $9,APUI01b
	jnz 0f

	movb $0x55,%al
	incb APUI01b
	ret

0:	cmpb $0xa,APUI01b
	jnz 0f

	movb APUI01a,%al
	movb $0,APUI01b
	ret

0:	movb APUI01c,%al		/* This can only be reached in special cases */
	ret

MAP_READ_APUI02:

	cmpb $0,APUI02b
	jnz 0f

	movb _SNES_A,%al
	incb APUI02b
	movb $0,APUI03b
	ret

0:	cmpb $1,APUI02b
	jnz 0f

	movb _SNES_X,%al
	incb APUI02b
	movb $1,APUI03b
	ret

0:	cmpb $2,APUI02b
	jnz 0f

	movb _SNES_Y,%al
	incb APUI02b
	movb $2,APUI03b
	ret

0:	cmpb $3,APUI02b
	jnz 0f

	movb $0,%al
	incb APUI02b
	ret

0:	cmpb $4,APUI02b
	jnz 0f

	movb $0xff,%al
	incb APUI02b
	ret

0:	cmpb $5,APUI02b
	jnz 0f

	movb $0x55,%al
	incb APUI02b
	ret

0:	cmpb $6,APUI02b
	jnz 0f

	movb $0xaa,%al
	movb $6,APUI03b
	incb APUI02b
	ret

0:	movb APUI02a,%al
	movb $0,APUI02b
	ret

MAP_READ_APUI03:

	cmpb $0,APUI03b
	jnz 0f

	movb _SNES_A+1,%al
	incb APUI03b
	ret

0:	cmpb $1,APUI03b
	jnz 0f

	movb _SNES_X+1,%al
	incb APUI03b
	ret

0:	cmpb $2,APUI03b
	jnz 0f

	movb _SNES_Y+1,%al
	incb APUI03b
	ret

0:	cmpb $3,APUI03b
	jnz 0f

	movb _SNES_A,%al
	incb APUI03b
	ret

0:	cmpb $4,APUI03b
	jnz 0f

	movb _SNES_X,%al
	incb APUI03b
	ret

0:	cmpb $5,APUI03b
	jnz 0f

	movb _SNES_Y,%al
	incb APUI03b
	ret

0:	cmpb $6,APUI03b
	jnz 0f

	movb $0xbb,%al
	incb APUI03b
	ret

0:	cmpb $7,APUI03b
	jnz 0f

	movb $0,%al
	incb APUI03b
	ret

0:	cmpb $8,APUI03b
	jnz 0f

	movb $0xff,%al
	incb APUI03b
	ret

0:	cmpb $9,APUI03b
	jnz 0f

	movb $0x55,%al
	incb APUI03b
	ret

0:
	movb APUI03a,%al
	movb $0,APUI03b
	ret

MAP_READ_SPCI00:
	movb SPC_PORT_0_W,%al
	ret

MAP_READ_SPCI01:
	movb SPC_PORT_1_W,%al
	ret

MAP_READ_SPCI02:
	movb SPC_PORT_2_W,%al
	ret

MAP_READ_SPCI03:
	movb SPC_PORT_3_W,%al
	ret

MAP_READ_WMDATA:

    movl WMADDL,%edi
    addl _WorkRamAddress,%edi   /* Address now ready for work ram read! */
	movb (%edi),%al
    incl %edi
    andl $0x01FFFF,%edi
    movl %edi,WMADDL
	ret

MAP_READ_WMADDL:

	movb WMADDL,%al
	ret

MAP_READ_WMADDM:

	movb WMADDM,%al
	ret

MAP_READ_WMADDH:

	movb WMADDH,%al
	ret

.globl MAP_READ_40
MAP_READ_40:

	movl %esi,%edi
    andl $0xFF,%edi
	jmp Read_Map_40(,%edi,4)

/* SNEeSe 0.13, random speculation time, this register or at least bit 0 handles input for controller 1

  I have no documentation on this but I know from bomber man that it is read 16 times in succession.

  Also 4016 is written to... BEST GUESS :

   It is referred to in SNES9x as old joypad emulation, so perhaps on the famicom (NES) the joypad status
  was read a bit at a time, the programmer shifted the data correctly before use. Every time 4016 is
  written the joypad is setup to be read.. This would mean that the standard method is simply an
  automated version of the old method... Basicly every time the JOYC1 is read we shift the stored joy-
  pad status and output the bit, inc our shift value and then wait for another read.. if JOYC1 is
  written to, we reset our shift count..

   All other bits should be kept low to ensure the connected part works ok... 

 V0.15 In fact 17th bit is an indication of joypad connected status 0 = connected

 */

MAP_READ_JOYC1:
	push %ecx
	push %ebx
	movb JOYC1,%cl
	incb %cl
	cmpb $17,%cl
	je 0f
	andb $0x0F,%cl
	movw JOY1L,%bx
	rolw %cl,%bx
	movb %bl,%al
	andb $0x01,%al
	pop %ebx
	pop %ecx
	ret
0:
	movb $0,JOYC1
	movb $0,%al		/* Joypad connected */
	pop %ebx
	pop %ecx
	ret

MAP_READ_JOYC2:
	push %ecx
	push %ebx
	movb JOYC2,%cl
	incb %cl
	cmpb $17,%cl
	je 0f
	andb $0x0F,%cl
	movw JOY2L,%bx
	rolw %cl,%bx
	movb %bl,%al
	andb $0x01,%al
	pop %ebx
	pop %ecx
	ret
0:
	movb $0,JOYC2
	movb $0,%al		/* Joypad connected */
	pop %ebx
	pop %ecx
	ret

.globl MAP_READ_42
MAP_READ_42:

	movl %esi,%edi
    andl $0xFF,%edi
	jmp Read_Map_42(,%edi,4)

MAP_READ_RDNMI:

	movb RDNMI,%al
	movb $0,RDNMI			/* NMI on/off + Version (unknown) */
	ret

MAP_READ_TIMEUP:

	movb TIMEUP,%al
    movb $0,TIMEUP
	ret

MAP_READ_HVBJOY:    // This is dodgy but will fake past some roms!
    // 00-01-40-41-00...
    movb HVBJOY,%al
    testb $1,%al
    jz 0f
    testb $0x40,%al
    jnz 0f
1:  xorb $0x41,HVBJOY
    ret
0:  xorb $1,HVBJOY
	ret

MAP_READ_RDIO:

	movb $0xFF,%al		/* V 0.14 - not supported but returns a value */
	ret

MAP_READ_RDDIVL:

	movb RDDIVL,%al
	ret

MAP_READ_RDDIVH:

	movb RDDIVH,%al
	ret

MAP_READ_RDMPYL:

	movb RDMPYL,%al
	ret

MAP_READ_RDMPYH:

	movb RDMPYH,%al
	ret

MAP_READ_JOY1L:

	movb JOY1L,%al
	ret

MAP_READ_JOY1H:	

	movb JOY1H,%al
	ret

MAP_READ_JOY2L:

	movb JOY2L,%al
	ret

MAP_READ_JOY2H:	

	movb JOY2H,%al
	ret

MAP_READ_JOY3L:

	movb $0,%al
	ret

MAP_READ_JOY3H:	

	movb $0,%al
	ret

MAP_READ_JOY4L:

	movb $0,%al
	ret

MAP_READ_JOY4H:	

	movb $0,%al
	ret

.globl MAP_READ_43
MAP_READ_43:
	movl %esi,%edi
    andl $0xFF,%edi
    jmp Read_Map_43(,%edi,4)

MAP_READ_DMAP0:
    movb DMAP0,%al
	ret

MAP_READ_BBAD0:
    movb BBAD0,%al
	ret

MAP_READ_A1T0L:
    movb A1T0L,%al
	ret

MAP_READ_A1T0H:
    movb A1T0H,%al
	ret

MAP_READ_A1B0:
    movb A1B0,%al
	ret

MAP_READ_DAS0L:
    movb DAS0L,%al
	ret

MAP_READ_DAS0H:
    movb DAS0H,%al
	ret

MAP_READ_A2L0:
    movb A2L0,%al
	ret

MAP_READ_A2H0:
    movb A2H0,%al
	ret

MAP_READ_DMAP1:
    movb DMAP1,%al
	ret

MAP_READ_BBAD1:
    movb BBAD1,%al
	ret

MAP_READ_A1T1L:
    movb A1T1L,%al
	ret

MAP_READ_A1T1H:
    movb A1T1H,%al
	ret

MAP_READ_A1B1:
    movb A1B1,%al
	ret

MAP_READ_DAS1L:
    movb DAS1L,%al
	ret

MAP_READ_DAS1H:
    movb DAS1H,%al
	ret

MAP_READ_A2L1:
    movb A2L1,%al
	ret

MAP_READ_A2H1:
    movb A2H1,%al
	ret

MAP_READ_DMAP2:
    movb DMAP2,%al
	ret

MAP_READ_BBAD2:
    movb BBAD2,%al
	ret

MAP_READ_A1T2L:
    movb A1T2L,%al
	ret

MAP_READ_A1T2H:
    movb A1T2H,%al
	ret

MAP_READ_A1B2:
    movb A1B2,%al
	ret

MAP_READ_DAS2L:
    movb DAS2L,%al
	ret

MAP_READ_DAS2H:
    movb DAS2H,%al
	ret

MAP_READ_A2L2:
    movb A2L2,%al
	ret

MAP_READ_A2H2:
    movb A2H2,%al
	ret

MAP_READ_DMAP3:
    movb DMAP3,%al
	ret

MAP_READ_BBAD3:
    movb BBAD3,%al
	ret

MAP_READ_A1T3L:
    movb A1T3L,%al
	ret

MAP_READ_A1T3H:
    movb A1T3H,%al
	ret

MAP_READ_A1B3:
    movb A1B3,%al
	ret

MAP_READ_DAS3L:
    movb DAS3L,%al
	ret

MAP_READ_DAS3H:
    movb DAS3H,%al
	ret

MAP_READ_A2L3:
    movb A2L3,%al
	ret

MAP_READ_A2H3:
    movb A2H3,%al
	ret

MAP_READ_DMAP4:
    movb DMAP4,%al
	ret

MAP_READ_BBAD4:
    movb BBAD4,%al
	ret

MAP_READ_A1T4L:
    movb A1T4L,%al
	ret

MAP_READ_A1T4H:
    movb A1T4H,%al
	ret

MAP_READ_A1B4:
    movb A1B4,%al
	ret

MAP_READ_DAS4L:
    movb DAS4L,%al
	ret

MAP_READ_DAS4H:
    movb DAS4H,%al
	ret

MAP_READ_A2L4:
    movb A2L4,%al
	ret

MAP_READ_A2H4:
    movb A2H4,%al
	ret

MAP_READ_DMAP5:
    movb DMAP5,%al
	ret

MAP_READ_BBAD5:
    movb BBAD5,%al
	ret

MAP_READ_A1T5L:
    movb A1T5L,%al
	ret

MAP_READ_A1T5H:
    movb A1T5H,%al
	ret

MAP_READ_A1B5:
    movb A1B5,%al
	ret

MAP_READ_DAS5L:
    movb DAS5L,%al
	ret

MAP_READ_DAS5H:
    movb DAS5H,%al
	ret

MAP_READ_A2L5:
    movb A2L5,%al
	ret

MAP_READ_A2H5:
    movb A2H5,%al
	ret

MAP_READ_DMAP6:
    movb DMAP6,%al
	ret

MAP_READ_BBAD6:
    movb BBAD6,%al
	ret

MAP_READ_A1T6L:
    movb A1T6L,%al
	ret

MAP_READ_A1T6H:
    movb A1T6H,%al
	ret

MAP_READ_A1B6:
    movb A1B6,%al
	ret

MAP_READ_DAS6L:
    movb DAS6L,%al
	ret

MAP_READ_DAS6H:
    movb DAS6H,%al
	ret

MAP_READ_A2L6:
    movb A2L6,%al
	ret

MAP_READ_A2H6:
    movb A2H6,%al
	ret

MAP_READ_DMAP7:
    movb DMAP7,%al
	ret

MAP_READ_BBAD7:
    movb BBAD7,%al
	ret

MAP_READ_A1T7L:
    movb A1T7L,%al
	ret

MAP_READ_A1T7H:
    movb A1T7H,%al
	ret

MAP_READ_A1B7:
    movb A1B7,%al
	ret

MAP_READ_DAS7L:
    movb DAS7L,%al
	ret

MAP_READ_DAS7H:
    movb DAS7H,%al
	ret

MAP_READ_A2L7:
    movb A2L7,%al
	ret

MAP_READ_A2H7:
    movb A2H7,%al
	ret

/*   --------   */

.globl MAP_WRITE_21
MAP_WRITE_21:
	movl %esi,%edi
    andl $0xFF,%edi
	jmp Write_Map_21(,%edi,4)

MAP_WRITE_INIDISP:

	movb %al,INIDISP			/* Get our copy of this */
	movb %al,_BrightnessLevel
	andb $0x0F,_BrightnessLevel		/* Sets the brightness level for palette set */

	ret

MAP_WRITE_OBSEL:
    // Note: SPRMODE is declared in SpriteL.S
	pushl %eax
	pushl %ebx
	movb %al,OBSEL			/* Get our copy of this */
    xorl %ebx,%ebx
    movb %al,%bl
	shrb $5,%al
    andl $7,%eax
    movl Sprite_Mode(,%eax,4),%eax
    movl %eax,SPRMODE
    movl %ebx,%eax
    andb $3,%al             /* Base address 0000 0000 0000 0xbb*/
/* At present the next line is 0x00 to prevent corrupt images in PACMAN.. it does not fix anything i have seen */
    andb $0x18,%bl          /* Name address 0000 0000 000n n000 */
    shll $10,%ebx           /* Name is either 0x0000,0x1000,0x2000,0x3000 */
    shll $14,%eax           /* Base is either 0x0000,0x2000,0x4000,0x6000 */
    addl %eax,%ebx
    andl $0xFFFF,%eax
    andl $0xFFFF,%ebx
	addl _VRamAddress,%eax
    addl _VRamAddress,%ebx
	movl %eax,OBADDR
    movl %ebx,OBNAME
	popl %ebx
	popl %eax
	ret	

MAP_WRITE_OAMADDL:
    pushl %ebx
    movl OAMAddress,%ebx
    shrl $1,%ebx
    movb %al,%bl
    addl %ebx,%ebx
    movl %ebx,OAMAddress
    movl %ebx,VBLANKOAMAddress
    cmpb $0,SPRLatch
    jz 1f
    movb $0,SPRLatch
    andl $0x01FC,%ebx
    movl %ebx,HighestSprite
    shrl $4,%ebx
    addl $0x200,%ebx
    movl %ebx,HiSpriteBits
    movl HighestSprite,%ebx
    shrl $2,%ebx
    movb $128,%bh
    movb %bl,HiSpriteCnt2
    subb %bl,%bh
    movb %bh,HiSpriteCnt1
    andb $3,%bl
    addb %bl,%bl
    movb $8,%bh
    subb %bl,%bh
    movb %bh,HiSpriteBits2
1:  popl %ebx
    ret

MAP_WRITE_OAMADDH:
    testb %al,%al           // Is priority rotation bit set?
    movb $0,SPRLatch
    jns 0f
    movb $-1,SPRLatch
0:  pushl %ebx
    movl OAMAddress,%ebx
    shrl $1,%ebx
    movb %al,%bh
    andb $1,%bh             // Only want MSB of address
    addl %ebx,%ebx
    movl %ebx,OAMAddress
    movl %ebx,VBLANKOAMAddress
    popl %ebx
	ret

MAP_WRITE_OAMDATA:

    movl OAMAddress,%edi
	addl _OAMAddress,%edi
	movb %al,(%edi)
    movl OAMAddress,%edi    // Auto increment sprite number
    incl %edi
    cmpl $0x0220,%edi       // Ensure address wraps correctly!
	jne 0f
    xorl %edi,%edi
0:  movl %edi,OAMAddress
    ret

MAP_WRITE_BGMODE:
    // Note: BGMODE is declared in ScreenL.S
    movb %al,BGSIZE
    pushl %ebx
    movb %al,%bl
    andl $7,%ebx
    movl Screen_HDMA_Mode(,%ebx,4),%ebx
    movl %ebx,BGMODE
    popl %ebx
	ret

MAP_WRITE_MOSAIC:			/* NEEDS IMPLEMENTING IN LINExLINE ENGINE */

	movb %al,MOSAIC
	ret

MAP_WRITE_BG1SC:

    pushl %ebx
    movb %al,_TBG1SC
    movb %al,%bl
    andl $3,%ebx
    movb %bl,BGSC1
    movb %al,%bl
    andl $0x7C,%ebx
    shll $9,%ebx
    addl _VRamAddress,%ebx
    movl %ebx,ScreenAddress1

    testb $1,%al
    jz 0f

1:  movl BG1HScrollData,%ebx
    testb $1,%bh    // If set do Right screen then left
    jz  4f
    movl ScreenAddress1,%ebx
    movl %ebx,ScreenAddressR1
    addl $32*32*2,%ebx
    movl %ebx,ScreenAddressL1
    jmp 6f

0:  movl ScreenAddress1,%ebx
    movl %ebx,ScreenAddressL1
    jmp 5f

4:  movl ScreenAddress1,%ebx
    movl %ebx,ScreenAddressL1
    addl $32*32*2,%ebx
5:  movl %ebx,ScreenAddressR1
6:  popl %ebx
	ret

MAP_WRITE_BG2SC:

    pushl %ebx
    movb %al,_TBG2SC
    movb %al,%bl
    andl $3,%ebx
    movb %bl,BGSC2
    movb %al,%bl
    andl $0x7C,%ebx
    shll $9,%ebx
    addl _VRamAddress,%ebx
    movl %ebx,ScreenAddress2

    testb $1,%al
    jz 0f

1:  movl BG2HScrollData,%ebx
    testb $1,%bh    // If set do Right screen then left
    jz  4f
    movl ScreenAddress2,%ebx
    movl %ebx,ScreenAddressR2
    addl $32*32*2,%ebx
    movl %ebx,ScreenAddressL2
    jmp 6f

0:  movl ScreenAddress2,%ebx
    movl %ebx,ScreenAddressL2
    jmp 5f

4:  movl ScreenAddress2,%ebx
    movl %ebx,ScreenAddressL2
    addl $32*32*2,%ebx
5:  movl %ebx,ScreenAddressR2
6:  popl %ebx
	ret

MAP_WRITE_BG3SC:

    pushl %ebx
    movb %al,_TBG3SC
    movb %al,%bl
    andl $3,%ebx
    movb %bl,BGSC3
    movb %al,%bl
    andl $0x7C,%ebx
    shll $9,%ebx
    addl _VRamAddress,%ebx
    movl %ebx,ScreenAddress3

    testb $1,%al
    jz 0f

1:  movl BG3HScrollData,%ebx
    testb $1,%bh    // If set do Right screen then left
    jz  4f
    movl ScreenAddress3,%ebx
    movl %ebx,ScreenAddressR3
    addl $32*32*2,%ebx
    movl %ebx,ScreenAddressL3
    jmp 6f

0:  movl ScreenAddress3,%ebx
    movl %ebx,ScreenAddressL3
    jmp 5f

4:  movl ScreenAddress3,%ebx
    movl %ebx,ScreenAddressL3
    addl $32*32*2,%ebx
5:  movl %ebx,ScreenAddressR3
6:  popl %ebx
	ret

MAP_WRITE_BG4SC:

    pushl %ebx
    movb %al,_TBG4SC
    movb %al,%bl
    andl $3,%ebx
    movb %bl,BGSC4
    movb %al,%bl
    andl $0x7C,%ebx
    shll $9,%ebx
    addl _VRamAddress,%ebx
    movl %ebx,ScreenAddress4

    testb $1,%al
    jz 0f

1:  movl BG4HScrollData,%ebx
    testb $1,%bh    // If set do Right screen then left
    jz  4f
    movl ScreenAddress4,%ebx
    movl %ebx,ScreenAddressR4
    addl $32*32*2,%ebx
    movl %ebx,ScreenAddressL4
    jmp 6f

0:  movl ScreenAddress4,%ebx
    movl %ebx,ScreenAddressL4
    jmp 5f

4:  movl ScreenAddress4,%ebx
    movl %ebx,ScreenAddressL4
    addl $32*32*2,%ebx
5:  movl %ebx,ScreenAddressR4
6:  popl %ebx
	ret

MAP_WRITE_BG12NBA:

    pushl %ebx
    movb %al,_TBG12NBA
    movb %al,%bl
    andl $0x07,%ebx
    shll $13,%ebx           // Tile Address * 4096
    addl _VRamAddress,%ebx
    movl %ebx,TileAddress1
    movb %al,%bl
    andl $0x70,%ebx
    shll $9,%ebx            // Tile Address * 4096
    addl _VRamAddress,%ebx
    movl %ebx,TileAddress2
    popl %ebx
	ret

MAP_WRITE_BG34NBA:

    pushl %ebx
    movb %al,_TBG34NBA
    movb %al,%bl
    andl $0x07,%ebx
    shll $13,%ebx           // Tile Address * 4096
    addl _VRamAddress,%ebx
    movl %ebx,TileAddress3
    movb %al,%bl
    andl $0x70,%ebx
    shll $9,%ebx            // Tile Address * 4096
    addl _VRamAddress,%ebx
    movl %ebx,TileAddress4
    popl %ebx
	ret

MAP_WRITE_BG1HOFS:

    DOUBLE_WRITE BG1HScrollData,BG1HOFS

    pushl %eax
    movb BGSIZE,%al
    andb $7,%al
    cmpb $7,%al     // Are we in mode 7?
    jz  7f

    movb BGSC1,%al
    testb $1,%al
    jz 0f

1:  movl BG1HScrollData,%eax
    shll $0x13,%eax
    sarl $0x13,%eax
    movl %eax,BG1HScrollData
    testb $1,%ah    // If set do Right screen then left
    jz  4f
    movl ScreenAddress1,%eax
    movl %eax,ScreenAddressR1
    addl $32*32*2,%eax
    movl %eax,ScreenAddressL1
    jmp 6f

0:  movl ScreenAddress1,%eax
    movl %eax,ScreenAddressL1
    jmp 5f

4:  movl ScreenAddress1,%eax
    movl %eax,ScreenAddressL1
    addl $32*32*2,%eax
5:  movl %eax,ScreenAddressR1
6:  popl %eax
	ret

7:  movb $0x05,%al  // Recalculate A and C
    orb  %al,Redo_M7
    popl %eax
    ret

MAP_WRITE_BG1VOFS:

	DOUBLE_WRITE BG1VScrollData,BG1VOFS

    pushl %eax
    movb BGSIZE,%al
    andb $7,%al
    cmpb $7,%al     // Are we in mode 7?
    jz  0f
    popl %eax
	ret

0:  movl BG1VScrollData,%eax
    shll $0x13,%eax
    sarl $0x13,%eax
    movl %eax,BG1VScrollData
    movb $0x0A,%al  // Recalculate B and D
    orb  %al,Redo_M7
    popl %eax
	ret

MAP_WRITE_BG2HOFS:

	DOUBLE_WRITE BG2HScrollData,BG2HOFS

    pushl %eax
    movb BGSC2,%al
    testb $1,%al
    jz 0f

1:  movl BG2HScrollData,%eax
    testb $1,%ah    // If set do Right screen then left
    jz  4f
    movl ScreenAddress2,%eax
    movl %eax,ScreenAddressR2
    addl $32*32*2,%eax
    movl %eax,ScreenAddressL2
    jmp 6f

0:  movl ScreenAddress2,%eax
    movl %eax,ScreenAddressL2
    jmp 5f

4:  movl ScreenAddress2,%eax
    movl %eax,ScreenAddressL2
    addl $32*32*2,%eax
5:  movl %eax,ScreenAddressR2
6:  popl %eax
    ret

MAP_WRITE_BG2VOFS:

	DOUBLE_WRITE BG2VScrollData,BG2VOFS
	ret

MAP_WRITE_BG3HOFS:

	DOUBLE_WRITE BG3HScrollData,BG3HOFS

    pushl %eax
    movb BGSC3,%al
    testb $1,%al
    jz 0f

1:  movl BG3HScrollData,%eax
    testb $1,%ah    // If set do Right screen then left
    jz  4f
    movl ScreenAddress3,%eax
    movl %eax,ScreenAddressR3
    addl $32*32*2,%eax
    movl %eax,ScreenAddressL3
    jmp 6f

0:  movl ScreenAddress3,%eax
    movl %eax,ScreenAddressL3
    jmp 5f

4:  movl ScreenAddress3,%eax
    movl %eax,ScreenAddressL3
    addl $32*32*2,%eax
5:  movl %eax,ScreenAddressR3
6:  popl %eax
    ret

MAP_WRITE_BG3VOFS:

	DOUBLE_WRITE BG3VScrollData,BG3VOFS
	ret

MAP_WRITE_BG4HOFS:

	DOUBLE_WRITE BG4HScrollData,BG4HOFS

    pushl %eax
    movb BGSC4,%al
    testb $1,%al
    jz 0f

1:  movl BG4HScrollData,%eax
    testb $1,%ah    // If set do Right screen then left
    jz  4f
    movl ScreenAddress4,%eax
    movl %eax,ScreenAddressR4
    addl $32*32*2,%eax
    movl %eax,ScreenAddressL4
    jmp 6f

0:  movl ScreenAddress4,%eax
    movl %eax,ScreenAddressL4
    jmp 5f

4:  movl ScreenAddress4,%eax
    movl %eax,ScreenAddressL4
    addl $32*32*2,%eax
5:  movl %eax,ScreenAddressR4
6:  popl %eax
    ret

MAP_WRITE_BG4VOFS:

	DOUBLE_WRITE BG4VScrollData,BG4VOFS
	ret

MAP_WRITE_VMAIN:

	movb %al,VMAIN			/* Get our copy of this */
    andb $0x3,%al           /* Only supports SC size at present! */
	jnz 0f

	movw $1,SCINC			/* 1*1 Data */
	movb VMAIN,%al
	ret

0:	cmpb $1,%al
	jnz 0f

	movw $32,SCINC			/* 32*32 Data */
	movb VMAIN,%al
	ret

0:	cmpb $2,%al
	jnz 0f

	movw $128,SCINC			/* 64*64 Data - A bug in SNES makes this 128 !*/
	movb VMAIN,%al
	ret

0:	movw $128,SCINC			/* 128*128 Data */
	movb VMAIN,%al
	ret

MAP_WRITE_VMADDL:

	movb %al,VRAMAddress
	ret

MAP_WRITE_VMADDH:

	movb %al,VRAMAddress+1
  andb $0x7F,VRAMAddress+1
	ret

MAP_WRITE_VMDATAL:

    /* Poke to lower byte assumes al is byte to poke */
    movl VRAMAddress,%edi
    addl %edi,%edi
	addl _VRamAddress,%edi
	movb %al,(%edi)
	testb $0x80,VMAIN
	jnz 0f
    pushl %eax
	movw SCINC,%ax
	addw %ax,VRAMAddress		/* Always words (since <<1 !)*/
    popl %eax
0:
  andl $0x7FFF,VRAMAddress
	ret	

MAP_WRITE_VMDATAH:

    /* Poke to upper byte assumes al is byte to poke */
    movl VRAMAddress,%edi
    addl %edi,%edi
	addl _VRamAddress,%edi
    movb %al,1(%edi)
	testb $0x80,VMAIN
	jz 0f
    pushl %eax
	movw SCINC,%ax
	addw %ax,VRAMAddress		/* Always words (since <<1 !)*/
    popl %eax
0:
  andl $0x7FFF,VRAMAddress
	ret

MAP_WRITE_M7SEL:		/* New for 0.12 */

	movb %al,M7SEL
	ret

MAP_WRITE_M7A:

    pushl %eax
    DOUBLE_WRITE _M7A_DATA,M7A
    movswl _M7A_DATA,%eax
    movl %eax,_M7A_DATA
    movb $0x01,%al      // Recalculate A
    orb  %al,Redo_M7
    popl %eax
	ret

MAP_WRITE_M7B:  // This one is used for 16bit*8bit=24bit multiply and mode 7

	pushl %eax
    DOUBLE_WRITE _M7B_DATA,M7B

    movsbl %al,%eax
    imull _M7A_DATA,%eax    // I think signed is used makes most sense!
    movl %eax,MPYL

    movswl _M7B_DATA,%eax
    movl %eax,_M7B_DATA
    movb $0x02,%al      // Recalculate B
    orb  %al,Redo_M7
    popl %eax
	ret

MAP_WRITE_M7C:

    pushl %eax
	DOUBLE_WRITE _M7C_DATA,M7C
    movb $0x04,%al      // Recalculate C
    movswl _M7C_DATA,%eax
    movl %eax,_M7C_DATA
    orb  %al,Redo_M7
    popl %eax
	ret

MAP_WRITE_M7D:

    pushl %eax
	DOUBLE_WRITE _M7D_DATA,M7D
    movswl _M7D_DATA,%eax
    movl %eax,_M7D_DATA
    movb $0x08,%al      // Recalculate D
    orb  %al,Redo_M7
    popl %eax
	ret

MAP_WRITE_M7X:

    pushl %eax
	DOUBLE_WRITE _M7X_DATA,M7X
    movl _M7X_DATA,%eax
    shll $0x13,%eax
    sarl $0x13,%eax
    movl %eax,_M7X_DATA
    movb $0x05,%al      // Recalculate A and C
    orb  %al,Redo_M7
    popl %eax
    ret

MAP_WRITE_M7Y:

    pushl %eax
	DOUBLE_WRITE _M7Y_DATA,M7Y
    movl _M7Y_DATA,%ebx
    shll $0x13,%ebx
    sarl $0x13,%ebx
    movl %ebx,_M7Y_DATA
    movb $0x0A,%al      // Recalculate B and D
    orb  %al,Redo_M7
    popl %eax
	ret

MAP_WRITE_CGADD:

	movb $0,CGDATA			/* Test function V0.13 see if this fixes palette mare! */
	movb %al,CGADD			/* Get our copy of this */
	ret	

MAP_WRITE_CGDATA:

	cmpb $0,CGDATA			/* Is addrinc first time write ? */
	jnz 5f

	movb %al,PaletteData		/* Set first byte data */
	movb $1,CGDATA			/* Set to high write next */

					/* Palette should be set even if just lo byte set! */

					/* We now set the palette in CGRam */
	pusha

	movw PaletteData,%bx		/* 0BBBBBGG GGGRRRRR */

	xorl %eax,%eax
	movb CGADD,%al			/* V 0.15 - Palette conversion done in set palette */
	movl _Real_SNES_Palette,%edi	/*          from now on. */
	movw %bx,(%edi,%eax,2)
	
	movb $1,PaletteChanged

	popa

	jmp 6f
5:
	movb %al,PaletteData+1		/* Set high byte */
	movb $0,CGDATA

					/* Palette should be set even if just lo byte set! */

					/* We now set the palette in CGRam */
	pusha

	movw PaletteData,%bx		/* 0BBBBBGG GGGRRRRR */

	xorl %eax,%eax
	movb CGADD,%al			/* V 0.14 - Support CGData read, I might remove */
	movl _Real_SNES_Palette,%edi	/*         a lot of this palette code next version */
	movw %bx,(%edi,%eax,2)
	
	incb CGADD			/* Auto Inc address */

	movb $1,PaletteChanged

	popa
6:
	ret

MAP_WRITE_W12SEL:

    movb %al,W12SEL
    ret

MAP_WRITE_W34SEL:

    movb %al,W34SEL
    ret

MAP_WRITE_WOBJSEL:

    movb %al,WOBJSEL
    ret

MAP_WRITE_WH0:

	movb %al,WH0
	ret

MAP_WRITE_WH1:

	movb %al,WH1
	ret

MAP_WRITE_WH2:

    movb %al,WH2
	ret

MAP_WRITE_WH3:

    movb %al,WH3
	ret

MAP_WRITE_WBGLOG:

    movb %al,WBGLOG
    ret

MAP_WRITE_WOBJLOG:

    movb %al,WOBJLOG
    ret

MAP_WRITE_TM:

	movb %al,TM
    orb  TD,%al
    andb TM_MASK,%al
	movb %al,SCR_TM
    movb TM,%al
	ret

MAP_WRITE_TD:

    movb %al,TD
    orb  TM,%al
    andb TM_MASK,%al
	movb %al,SCR_TM
    movb TD,%al
	ret

MAP_WRITE_TMW:		/* Not supported yet... long time till they are ! */
MAP_WRITE_TSW:
	ret

MAP_WRITE_CGWSEL:

	movb %al,CGWSEL
	ret

MAP_WRITE_CGADSUB:

	movb %al,CGADSUB
	ret

MAP_WRITE_COLDATA:

	movb %al,COLDATA
	pusha

	btw $7,%ax
	jnc 0f

	xorl %ebx,%ebx

	movb %al,%bl
	andb $0x1F,%bx
	shlw $10,%bx
	
	movw FIXEDCOLDATA,%cx
	andw $0x03FF,%cx
	orw %bx,%cx
	movw %cx,FIXEDCOLDATA
0:
	btw $6,%ax
	jnc 0f

	xorl %ebx,%ebx

	movb %al,%bl
	andb $0x1F,%bx
	shlw $5,%bx
	
	movw FIXEDCOLDATA,%cx
	andw $0x7C1F,%cx
	orw %bx,%cx
	movw %cx,FIXEDCOLDATA
0:
	btw $5,%ax
	jnc 0f

	xorl %ebx,%ebx

	movb %al,%bl
	andb $0x1F,%bx
	
	movw FIXEDCOLDATA,%cx
	andw $0x7FE0,%cx
	orw %bx,%cx
	movw %cx,FIXEDCOLDATA
0:
	popa

	ret

MAP_WRITE_SETINI:	/* Not supported, never will be? no need! */
	movb %al,SETINI
    ret

MAP_WRITE_APUI00:

	movb %al,APUI00a
	cmpb $0xff,%al
	je 0f
/*	movb $0,APUI00b*/
	ret
0:/*	movb $7,APUI00b*/
	ret

MAP_WRITE_APUI01:

	movb %al,APUI01a
	movb $0,APUI01b
	ret

MAP_WRITE_APUI02:

	movb %al,APUI02a
	movb $0,APUI02b
	ret

MAP_WRITE_APUI03:

	movb %al,APUI03a
	movb $0,APUI03b
	ret

MAP_WRITE_SPCI00:
	movb %al,SPC_PORT_0_R
	ret

MAP_WRITE_SPCI01:
	movb %al,SPC_PORT_1_R
	ret

MAP_WRITE_SPCI02:
	movb %al,SPC_PORT_2_R
	ret

MAP_WRITE_SPCI03:
	movb %al,SPC_PORT_3_R
	ret

MAP_WRITE_WMDATA:

    movl WMADDL,%edi
    addl _WorkRamAddress,%edi   /* Address now ready for work ram write! */
    movb %al,(%edi)
    incl %edi
    andl $0x01FFFF,%edi
    movl %edi,WMADDL
	ret

MAP_WRITE_WMADDL:

	movb %al,WMADDL
	ret

MAP_WRITE_WMADDM:

    movb %al,WMADDM
	ret

MAP_WRITE_WMADDH:

	movb %al,WMADDH
    andb $1,WMADDH
	ret

.globl MAP_WRITE_40		/* New for V0.13 to accomodate JOYC1 support */
MAP_WRITE_40:
	movl %esi,%edi
    andl $0xFF,%edi
	jmp Write_Map_40(,%edi,4)

MAP_WRITE_JOYC1:

	movb $0,JOYC1		/* This may need altering later if JOYC1 can handle more than controller 1? */
	ret

MAP_WRITE_JOYC2:

	movb $0,JOYC2
	ret

.globl MAP_WRITE_42
MAP_WRITE_42:
	movl %esi,%edi
    andl $0xFF,%edi
	jmp Write_Map_42(,%edi,4)

MAP_WRITE_NMITIMEN:

	movb %al,NMITIMEN
	ret

MAP_WRITE_WRMPYA:

	movb %al,WRMPYA
	ret

MAP_WRITE_WRMPYB:

	pushl %eax
	movb %al,WRMPYB		/* Do the multiplication */
	mulb WRMPYA
	movb %al,RDMPYL
	movb %ah,RDMPYH
	popl %eax
	ret

MAP_WRITE_WRDIVL:

	movb %al,WRDIVL
	ret

MAP_WRITE_WRDIVH:

	movb %al,WRDIVH
	ret

MAP_WRITE_WRDIVB:

	pushl %eax
	pushl %ebx
	pushl %edx
	movb %al,WRDIVB
	cmpb $0,%al
	je 0f
	movw $0,%dx			/* Divide uses DX:AX / BX */
	movb WRDIVL,%al
	movb WRDIVH,%ah
	movb WRDIVB,%bl
	movb $0,%bh
	divw %bx			/* Result is ax=quotient,dx=remainder */
	movb %al,RDDIVL
	movb %ah,RDDIVH
	movb %dl,RDMPYL
	movb %dh,RDMPYH
0:	popl %edx
	popl %ebx
	popl %eax
	ret

MAP_WRITE_HTIMEL:   // Currently unsupported!

    movb %al,HTIMEL
	ret

MAP_WRITE_HTIMEH:   // Currently unsupported!

    movb %al,HTIMEH
	ret

MAP_WRITE_VTIMEL:   // Handled in screen core!

    movb %al,VTIMEL
	ret

MAP_WRITE_VTIMEH:   // Handled in screen core!

    movb %al,VTIMEH
	ret

MAP_WRITE_MDMAEN:

	movb %al,MDMAEN
    testb %al,%al
    jz  0f
    call doDMA      // Why this was not a function I don't know!
0:	ret

MAP_WRITE_HDMAEN:   // Actually handled within SCREEN core!

	movb %al,HDMAEN
	ret

MAP_WRITE_MEMSEL:   // FastROM switch

    andl $1,%eax
    shll $0x17,%eax // Set bit 7 of bank to switch flag
    movl %eax,MEMSEL
	ret

.globl MAP_WRITE_43
MAP_WRITE_43:
	movl %esi,%edi
    andl $0xFF,%edi
	jmp Write_Map_43(,%edi,4)

MAP_WRITE_DMAP0:
	movb %al,DMAP0
	ret

MAP_WRITE_BBAD0:
	movb %al,BBAD0
	ret

MAP_WRITE_A1T0L:
	movb %al,A1T0L
    movb %al,A2L0
	ret

MAP_WRITE_A1T0H:
	movb %al,A1T0H
    movb %al,A2H0
	ret

MAP_WRITE_A1B0:
	movb %al,A1B0
	ret

MAP_WRITE_DAS0L:
	movb %al,DAS0L
	ret

MAP_WRITE_DAS0H:
	movb %al,DAS0H
	ret

MAP_WRITE_DASB0:
    movb %al,DASB0
    ret

MAP_WRITE_A2L0:
//    call _InvalidOpcode
    pushl %eax
    movb A1T0L,%al
    movb %al,A2L0
    popl %eax
	ret

MAP_WRITE_A2H0:
    pushl %eax
    movb A1T0H,%al
	movb %al,A2H0
    popl %eax
	ret

MAP_WRITE_DMAP1:
	movb %al,DMAP1
	ret

MAP_WRITE_BBAD1:
	movb %al,BBAD1
	ret

MAP_WRITE_A1T1L:
	movb %al,A1T1L
    movb %al,A2L1
	ret

MAP_WRITE_A1T1H:
	movb %al,A1T1H
    movb %al,A2H1
	ret

MAP_WRITE_A1B1:
	movb %al,A1B1
	ret

MAP_WRITE_DAS1L:
	movb %al,DAS1L
	ret

MAP_WRITE_DAS1H:
	movb %al,DAS1H
	ret

MAP_WRITE_DASB1:
    movb %al,DASB1
    ret

MAP_WRITE_A2L1:
//    call _InvalidOpcode
    pushl %eax
    movb A1T1L,%al
	movb %al,A2L1
    popl %eax
	ret

MAP_WRITE_A2H1:
    pushl %eax
    movb A1T1H,%al
	movb %al,A2H1
    popl %eax
	ret

MAP_WRITE_DMAP2:
	movb %al,DMAP2
	ret

MAP_WRITE_BBAD2:
	movb %al,BBAD2
	ret

MAP_WRITE_A1T2L:
	movb %al,A1T2L
    movb %al,A2L2
	ret

MAP_WRITE_A1T2H:
	movb %al,A1T2H
    movb %al,A2H2
	ret

MAP_WRITE_A1B2:
	movb %al,A1B2
	ret

MAP_WRITE_DAS2L:
	movb %al,DAS2L
	ret

MAP_WRITE_DAS2H:
	movb %al,DAS2H
	ret

MAP_WRITE_DASB2:
    movb %al,DASB2
    ret

MAP_WRITE_A2L2:
//    call _InvalidOpcode
    pushl %eax
    movb A1T2L,%al
	movb %al,A2L2
    popl %eax
	ret

MAP_WRITE_A2H2:
    pushl %eax
    movb A1T2H,%al
	movb %al,A2H2
    popl %eax
	ret

MAP_WRITE_DMAP3:
	movb %al,DMAP3
	ret

MAP_WRITE_BBAD3:
	movb %al,BBAD3
	ret

MAP_WRITE_A1T3L:
    movb %al,A1T3L
    movb %al,A2L3
	ret

MAP_WRITE_A1T3H:
	movb %al,A1T3H
    movb %al,A2H3
	ret

MAP_WRITE_A1B3:
	movb %al,A1B3
	ret

MAP_WRITE_DAS3L:
	movb %al,DAS3L
	ret

MAP_WRITE_DAS3H:
	movb %al,DAS3H
	ret

MAP_WRITE_DASB3:
    movb %al,DASB3
    ret

MAP_WRITE_A2L3:
//    call _InvalidOpcode
    pushl %eax
    movb A1T3L,%al
	movb %al,A2L3
    popl %eax
	ret

MAP_WRITE_A2H3:
    pushl %eax
    movb A1T3H,%al
	movb %al,A2H3
    popl %eax
	ret

MAP_WRITE_DMAP4:
	movb %al,DMAP4
	ret

MAP_WRITE_BBAD4:
	movb %al,BBAD4
	ret

MAP_WRITE_A1T4L:
	movb %al,A1T4L
    movb %al,A2L4
	ret

MAP_WRITE_A1T4H:
	movb %al,A1T4H
    movb %al,A2H4
	ret

MAP_WRITE_A1B4:
	movb %al,A1B4
	ret

MAP_WRITE_DAS4L:
	movb %al,DAS4L
	ret

MAP_WRITE_DAS4H:
	movb %al,DAS4H
	ret

MAP_WRITE_DASB4:
    movb %al,DASB4
    ret

MAP_WRITE_A2L4:
//    call _InvalidOpcode
    pushl %eax
    movb A1T4L,%al
	movb %al,A2L4
    popl %eax
	ret

MAP_WRITE_A2H4:
    pushl %eax
    movb A1T4H,%al
	movb %al,A2H4
    popl %eax
	ret

MAP_WRITE_DMAP5:
	movb %al,DMAP5
	ret

MAP_WRITE_BBAD5:
	movb %al,BBAD5
	ret

MAP_WRITE_A1T5L:
	movb %al,A1T5L
    movb %al,A2L5
	ret

MAP_WRITE_A1T5H:
	movb %al,A1T5H
    movb %al,A2H5
	ret

MAP_WRITE_A1B5:
	movb %al,A1B5
	ret

MAP_WRITE_DAS5L:
	movb %al,DAS5L
	ret

MAP_WRITE_DAS5H:
	movb %al,DAS5H
	ret

MAP_WRITE_DASB5:
    movb %al,DASB5
    ret

MAP_WRITE_A2L5:
//    call _InvalidOpcode
    pushl %eax
    movb A1T5L,%al
	movb %al,A2L5
    popl %eax
	ret

MAP_WRITE_A2H5:
    pushl %eax
    movb A1T5H,%al
	movb %al,A2H5
    popl %eax
	ret

MAP_WRITE_DMAP6:
	movb %al,DMAP6
	ret

MAP_WRITE_BBAD6:
	movb %al,BBAD6
	ret

MAP_WRITE_A1T6L:
	movb %al,A1T6L
    movb %al,A2L6
	ret

MAP_WRITE_A1T6H:
	movb %al,A1T6H
    movb %al,A2H6
	ret

MAP_WRITE_A1B6:
	movb %al,A1B6
	ret

MAP_WRITE_DAS6L:
	movb %al,DAS6L
	ret

MAP_WRITE_DAS6H:
	movb %al,DAS6H
	ret

MAP_WRITE_DASB6:
    movb %al,DASB6
    ret

MAP_WRITE_A2L6:
//    call _InvalidOpcode
    pushl %eax
    movb A1T6L,%al
	movb %al,A2L6
    popl %eax
	ret

MAP_WRITE_A2H6:
    pushl %eax
    movb A1T6H,%al
	movb %al,A2H6
    popl %eax
	ret

MAP_WRITE_DMAP7:
	movb %al,DMAP7
	ret

MAP_WRITE_BBAD7:
	movb %al,BBAD7
	ret

MAP_WRITE_A1T7L:
	movb %al,A1T7L
    movb %al,A2L7
	ret

MAP_WRITE_A1T7H:
	movb %al,A1T7H
    movb %al,A2H7
	ret

MAP_WRITE_A1B7:
	movb %al,A1B7
	ret

MAP_WRITE_DAS7L:
	movb %al,DAS7L
	ret

MAP_WRITE_DAS7H:
	movb %al,DAS7H
	ret

MAP_WRITE_DASB7:
    movb %al,DASB7
    ret

MAP_WRITE_A2L7:
//    call _InvalidOpcode
    pushl %eax
    movb A1T7L,%al
	movb %al,A2L7
    popl %eax
	ret

MAP_WRITE_A2H7:
    pushl %eax
    movb A1T7H,%al
	movb %al,A2H7
    popl %eax
	ret

.globl MAKE_SPC
MAKE_SPC:
	movl $0x40,%ebx
	movl $MAP_READ_SPCI00,%eax
	movl %eax,Read_Map_21(,%ebx,4)
	movl $MAP_WRITE_SPCI00,%eax
	movl %eax,Write_Map_21(,%ebx,4)
	incl %ebx
	movl $MAP_READ_SPCI01,%eax
	movl %eax,Read_Map_21(,%ebx,4)
	movl $MAP_WRITE_SPCI01,%eax
	movl %eax,Write_Map_21(,%ebx,4)
	incl %ebx
	movl $MAP_READ_SPCI02,%eax
	movl %eax,Read_Map_21(,%ebx,4)
	movl $MAP_WRITE_SPCI02,%eax
	movl %eax,Write_Map_21(,%ebx,4)
	incl %ebx
	movl $MAP_READ_SPCI03,%eax
	movl %eax,Read_Map_21(,%ebx,4)
	movl $MAP_WRITE_SPCI03,%eax
	movl %eax,Write_Map_21(,%ebx,4)
	ret

.globl MAKE_APU
MAKE_APU:
	movl $0x40,%ebx
	movl $MAP_READ_APUI00,%eax
	movl %eax,Read_Map_21(,%ebx,4)
	movl $MAP_WRITE_APUI00,%eax
	movl %eax,Write_Map_21(,%ebx,4)
	incl %ebx
	movl $MAP_READ_APUI01,%eax
	movl %eax,Read_Map_21(,%ebx,4)
	movl $MAP_WRITE_APUI01,%eax
	movl %eax,Write_Map_21(,%ebx,4)
	incl %ebx
	movl $MAP_READ_APUI02,%eax
	movl %eax,Read_Map_21(,%ebx,4)
	movl $MAP_WRITE_APUI02,%eax
	movl %eax,Write_Map_21(,%ebx,4)
	incl %ebx
	movl $MAP_READ_APUI03,%eax
	movl %eax,Read_Map_21(,%ebx,4)
	movl $MAP_WRITE_APUI03,%eax
	movl %eax,Write_Map_21(,%ebx,4)
	ret

.data
.balign 16
VRAMAddress:    .long   0
.globl OBADDR,OBNAME
OBADDR:         .long   0   // VRAM location of sprite tiles 00-FF
OBNAME:         .long   0   // VRAM location of sprite tiles 100-1FF
.globl OAMAddress
OAMAddress:         .long   0
.globl VBLANKOAMAddress
VBLANKOAMAddress:   .long   0   /* Restore this at VBLank */
PaletteData:    .word   0
.globl FIXEDCOLDATA
FIXEDCOLDATA:	.word	0	/* Actual data from coldata */
/*.globl M7A_Data
M7A_Data:		.word	0
.globl M7B_Data
M7B_Data:		.word	0
.globl M7C_Data
M7C_Data:		.word	0
.globl M7D_Data
M7D_Data:		.word	0
.globl M7X_Data
M7X_Data:		.word	0
.globl M7Y_Data
M7Y_Data:		.word	0*/

SCINC:			.word	0	/* Used in updating VRAM address */
.balign 4
HoriCount:      .long   0   /* These two are latched values! */
VertCount:      .long   0
.globl HighestSprite
.globl _TOAMADDH            // Alias used for debug info
_TOAMADDH:
HighestSprite:  .long   0   // Number of the sprite to plot first!
.globl HiSpriteBits,HiSpriteBits2
.globl HiSpriteCnt1,HiSpriteCnt2
HiSpriteBits:   .long   0x200   // OAM address of sprite in 32b table
HiSpriteBits2:  .byte   8       // OAM address of bit in table byte
HiSpriteCnt1:   .byte   128     // Number of sprites to draw in first set
HiSpriteCnt2:   .byte   0       // Number of sprites to draw in second set
SPRLatch:       .byte   0       // Sprite Priority Rotation latch flag

/* New Idea, I will store all SNES variables in my own copy area... faster access! */

.globl INIDISP
INIDISP:	.byte	0	/* x000bbbb	x=screen on/off,bbbb=Brightness */
.globl OBSEL,_TOBSEL
_TOBSEL:                // Alias used for debug info
OBSEL:		.byte	0	/* sssnnbbb  sss=sprite size,nn=upper 4k address,bbb=offset */
.globl BGSIZE,_TBGMODE
_TBGMODE:
BGSIZE:     .byte   0   /* abcdefff a-d=tile size bg4-1 (8/16),e=priority bg3,fff=mode */
.globl MOSAIC
MOSAIC:		.byte	0	/* xxxxabcd  xxxx=0-F pixel size,a-d = affect BG4-1 */

.globl BG1SC,BG2SC,BG3SC,BG4SC
.globl BGSC1,BGSC2,BGSC3,BGSC4
.globl _TBG1SC,_TBG2SC,_TBG3SC,_TBG4SC
_TBG1SC:    .byte   0   /* xxxxxxab  xxxxxx=base address, ab=SC Size */
_TBG2SC:    .byte   0   /* xxxxxxab  xxxxxx=base address, ab=SC Size */
_TBG3SC:    .byte   0   /* xxxxxxab  xxxxxx=base address, ab=SC Size */
_TBG4SC:    .byte   0   /* xxxxxxab  xxxxxx=base address, ab=SC Size */

BG1SC:
BGSC1:      .byte   0   // SC size

BGSC2:
BG2SC:      .byte   0   // SC size

BGSC3:
BG3SC:      .byte   0   // SC size

BGSC4:
BG4SC:      .byte   0   // SC size

.globl _TBG12NBA,_TBG34NBA
_TBG12NBA:  .byte   0   // aaaabbbb  aaaa=base address 2, bbbb=base address 1
_TBG34NBA:  .byte   0   // aaaabbbb  aaaa=base address 4, bbbb=base address 3

.globl _TVMAIN          // Alias used for debug info
_TVMAIN:
VMAIN:		.byte	0	/* i000abcd  i=inc type,ab=full graphic,cd=SC increment */
.globl M7SEL
M7SEL:		.byte	0	/* ab0000yx  ab=mode 7 repetition info,y=flip verticle,x=flip horizontal */
M7A:		.byte	0	/* Holds wether writing to first or second byte */
M7B:		.byte	0	/* Holds wether writing to first or second byte */
M7C:		.byte	0	/* Holds wether writing to first or second byte */
M7D:		.byte	0	/* Holds wether writing to first or second byte */
M7X:		.byte	0	/* Holds wether writing to first or second byte */
M7Y:		.byte	0	/* Holds wether writing to first or second byte */
.globl CGADD
CGADD:		.byte	0	/* Palette Position For Writes To CGRAM */
.globl CGDATA
CGDATA:		.byte	0	/* Holds wether writing to first or second byte */
.balign 4
.globl W12SEL,W34SEL,WOBJSEL
W12SEL:     .byte   0   /* Holds plane 1/2 window mask settings */
W34SEL:     .byte   0   /* Holds plane 3/4 window mask settings */
WOBJSEL:    .byte   0   /* Holds colour/object window mask settings */
            .byte   0
.globl WH0,WH1,WH2,WH3
WH0:		.byte	0	/* Holds window 1 left position */
WH1:		.byte	0	/* Holds window 1 right position */
WH2:        .byte   0   /* Holds window 2 left position */
WH3:        .byte   0   /* Holds window 2 right position */
.globl WBGLOG,WOBJLOG
WBGLOG:     .byte   0   // BG Window mask logic
WOBJLOG:    .byte   0   // OBJ/Colour Window mask logic
.globl TM,TD,_TTM,_TTD
_TTM:
TM:		.byte	0	/* 000abcde  a=OBJ/OAM on/off,b-e=BG4-1 */
_TTD:
TD:		.byte	0	/* 000abcde  a=OBJ/OAM on/off,b-e=BG4-1 */
.globl CGWSEL,CGADSUB,COLDATA
CGWSEL:		.byte	0
CGADSUB:	.byte	0
COLDATA:	.byte	0
BG1HOFS:	.byte	0	/* Holds wether writing to first or second byte */
BG1VOFS:	.byte	0	/* Holds wether writing to first or second byte */
BG2HOFS:	.byte	0	/* Holds wether writing to first or second byte */
BG2VOFS:	.byte	0	/* Holds wether writing to first or second byte */
BG3HOFS:	.byte	0	/* Holds wether writing to first or second byte */
BG3VOFS:	.byte	0	/* Holds wether writing to first or second byte */
BG4HOFS:	.byte	0	/* Holds wether writing to first or second byte */
BG4VOFS:	.byte	0	/* Holds wether writing to first or second byte */
.globl SETINI
SETINI:		.byte	0
.balign 4
MPYL:		.byte	0	/* Low byte of multiplication result */
MPYM:		.byte	0	/* Middle byte of multiplication result */
MPYH:		.byte	0	/* High byte of multiplication result */
            .byte   0
CGDATAREAD:	.byte	0	/* Wether reading lo or high byte */
OPHCT:		.byte	0	/* wether reading lo or high byte */
OPVCT:		.byte	0	/* Wether reading lo or high byte */
.globl APUI00a,APUI00b,APUI00c
APUI00a:	.byte	0	/* This is the APU value when APUI00b=0 */
APUI00b:	.byte	0	/* This is a count type of variable for flipping APUI00a */
APUI00c:	.byte	0	/* Binary counter used in conjuction with APUI01c */
APUI01a:	.byte	0	/* This is the APU value when APUI01b=0 */
APUI01b:	.byte	0	/* This is a count type of variable for flipping APUI01a */
APUI01c:	.byte	0	/* Binary counter upper byte of APUI00c */
APUI02a:	.byte	0	/* This is the APU value when APUI02b=0 */
APUI02b:	.byte	0	/* This is a count type of variable for flipping APUI02a */
APUI02c:	.byte	0	/* Binary counter used in conjuction with APUI03c */
APUI03a:	.byte	0	/* This is the APU value when APUI03b=0 */
APUI03b:	.byte	0	/* This is a count type of variable for flipping APUI03a */
APUI03c:	.byte	0	/* Binary counter upper byte of APUI02c */
.balign 4
WMADDL:     .byte   0   /* Work RAM Address Lo Byte */
WMADDM:     .byte   0   /* Work RAM Address Mid Byte */
WMADDH:     .byte   0   /* Work RAM Address Hi Byte - Just bit 0 used ! */
            .byte   0
JOYC1:		.byte	0	/* This holds the shift count for outputing JOY1L & JOY1H as a bit stream! */
JOYC2:		.byte	0	/* same as above for controller 2? */

.globl NMITIMEN
NMITIMEN:	.byte	0	/* a0yx000b  a=NMI on/off,y=vert count,x=horiz count,b=joy read */
WRMPYA:		.byte	0	/* Multiplicand A */
WRMPYB:		.byte	0	/* Multiplicand B */
WRDIVL:		.byte	0	/* Dividend C */
WRDIVH:		.byte	0
WRDIVB:		.byte	0	/* Divisor B */
.balign 4
.globl HTIMEL,HTIMEH
HTIMEL:     .byte   0   // H IRQ position low
HTIMEH:     .byte   0   // H IRQ position high
            .byte   0
            .byte   0
.globl VTIMEL,VTIMEH
VTIMEL:     .byte   0   // V IRQ position low
VTIMEH:     .byte   0   // V IRQ position high
            .byte   0
            .byte   0
.globl MDMAEN
MDMAEN:     .byte   0   // DMA enable
.globl HDMAEN
HDMAEN:     .byte   0   // HDMA enable
.globl HDMAON
HDMAON:     .byte   0   // HDMA enabled this refresh
.balign 4
.globl MEMSEL
MEMSEL:     .long   0   // FastROM switch
.globl RDNMI
RDNMI:		.byte	0	/* x000vvvv  x=disable/enable NMI,vvvv=version ? */
.globl TIMEUP
TIMEUP:     .byte   0x80    // IRQ signalled flag
.globl HVBJOY
HVBJOY:		.byte	0	/* This is not supported correctly yet.. for now it alternates!*/
RDDIVL:		.byte	0	/* Quotient of divide */
RDDIVH:		.byte	0
RDMPYL:		.byte	0	/* Multiplication or remainder */
RDMPYH:		.byte	0
JOY1L:		.byte	0	/* These are updated per VBL rather than per read! */
JOY1H:		.byte	0
JOY2L:		.byte	0
JOY2H:		.byte	0

// vh0bcaaa v=CPU->PPU,h=addr,c=inc/fixed,b=inc/dec,aaa=type
.globl DMAP0,DMAP1,DMAP2,DMAP3,DMAP4,DMAP5,DMAP6,DMAP7
.globl BBAD0,BBAD1,BBAD2,BBAD3,BBAD4,BBAD5,BBAD6,BBAD7
.globl DMA_Vid_0,DMA_Vid_1,DMA_Vid_2,DMA_Vid_3
.globl DMA_Vid_4,DMA_Vid_5,DMA_Vid_6,DMA_Vid_7
.globl A1T0,A1T1,A1T2,A1T3,A1T4,A1T5,A1T6,A1T7
.globl A1B0,A1B1,A1B2,A1B3,A1B4,A1B5,A1B6,A1B7
.globl DAS0,DAS1,DAS2,DAS3,DAS4,DAS5,DAS6,DAS7
.globl DASB0,DASB1,DASB2,DASB3,DASB4,DASB5,DASB6,DASB7
.globl A2L0,A2L1,A2L2,A2L3,A2L4,A2L5,A2L6,A2L7
.globl A2H0,A2H1,A2H2,A2H3,A2H4,A2H5,A2H6,A2H7
.globl NTRL0,NTRL1,NTRL2,NTRL3,NTRL4,NTRL5,NTRL6,NTRL7
.balign 16
DMAP0:      .byte   0
NTRL0:      .byte   0
DMAP1:      .byte   0
NTRL1:      .byte   0
DMAP2:      .byte   0
NTRL2:      .byte   0
DMAP3:      .byte   0
NTRL3:      .byte   0
DMAP4:      .byte   0
NTRL4:      .byte   0
DMAP5:      .byte   0
NTRL5:      .byte   0
DMAP6:      .byte   0
NTRL6:      .byte   0
DMAP7:      .byte   0
NTRL7:      .byte   0
.balign 16
BBAD0:                  // Low byte of 0x21??
DMA_Vid_0:  .long   0

A1T0:                   // Source Address L/H/B
A1T0L:		.byte	0	/* Source Address L */
A1T0H:		.byte	0	/* Source Address H */
A1B0:       .byte   0   /* Source Bank Address */
            .byte   0
DAS0:                   // Data Size L/H
DAS0L:		.byte	0	/* Data Size L */
DAS0H:		.byte	0	/* Data Size H */
DASB0:      .byte   0   // Data address bank
            .byte   0
A2L0:		.byte	0	/* hdma table address L */
A2H0:       .byte   0   /* hdma table address H */
            .word   0
.balign 16
BBAD1:                  // Low byte of 0x21??
DMA_Vid_1:  .long   0

A1T1:                   // Source Address L/H/B
A1T1L:		.byte	0	/* Source Address L */
A1T1H:		.byte	0	/* Source Address H */
A1B1:		.byte	0	/* Source Bank Address */
            .byte   0
DAS1:                   // Data Size L/H
DAS1L:		.byte	0	/* Data Size L */
DAS1H:		.byte	0	/* Data Size H */
DASB1:      .byte   0   // Data address bank
            .byte   0
A2L1:		.byte	0	/* hdma table address L */
A2H1:       .byte   0   /* hdma table address H */
            .word   0
.balign 16
BBAD2:                  // Low byte of 0x21??
DMA_Vid_2:  .long   0

A1T2:                   // Source Address L/H/B
A1T2L:		.byte	0	/* Source Address L */
A1T2H:		.byte	0	/* Source Address H */
A1B2:		.byte	0	/* Source Bank Address */
            .byte   0
DAS2:                   // Data Size L/H
DAS2L:		.byte	0	/* Data Size L */
DAS2H:		.byte	0	/* Data Size H */
DASB2:      .byte   0   // Data address bank
            .byte   0
A2L2:		.byte	0	/* hdma table address L */
A2H2:       .byte   0   /* hdma table address H */
            .word   0
.balign 16
BBAD3:                  // Low byte of 0x21??
DMA_Vid_3:  .long   0

A1T3:                   // Source Address L/H/B
A1T3L:		.byte	0	/* Source Address L */
A1T3H:		.byte	0	/* Source Address H */
A1B3:		.byte	0	/* Source Bank Address */
            .byte   0
DAS3:                   // Data Size L/H
DAS3L:		.byte	0	/* Data Size L */
DAS3H:		.byte	0	/* Data Size H */
DASB3:      .byte   0   // Data address bank
            .byte   0
A2L3:		.byte	0	/* hdma table address L */
A2H3:       .byte   0   /* hdma table address H */
            .word   0
.balign 16
BBAD4:                  // Low byte of 0x21??
DMA_Vid_4:  .long   0

A1T4:                   // Source Address L/H/B
A1T4L:		.byte	0	/* Source Address L */
A1T4H:		.byte	0	/* Source Address H */
A1B4:		.byte	0	/* Source Bank Address */
            .byte   0
DAS4:                   // Data Size L/H
DAS4L:		.byte	0	/* Data Size L */
DAS4H:		.byte	0	/* Data Size H */
DASB4:      .byte   0   // Data address bank
            .byte   0
A2L4:		.byte	0	/* hdma table address L */
A2H4:       .byte   0   /* hdma table address H */
            .word   0
.balign 16
BBAD5:                  // Low byte of 0x21??
DMA_Vid_5:  .long   0

A1T5:                   // Source Address L/H/B
A1T5L:		.byte	0	/* Source Address L */
A1T5H:		.byte	0	/* Source Address H */
A1B5:		.byte	0	/* Source Bank Address */
            .byte   0
DAS5:                   // Data Size L/H
DAS5L:		.byte	0	/* Data Size L */
DAS5H:      .byte   0   /* Data Size H */
DASB5:      .byte   0   // Data address bank
            .byte   0
A2L5:		.byte	0	/* hdma table address L */
A2H5:       .byte   0   /* hdma table address H */
            .word   0
.balign 16
BBAD6:                  // Low byte of 0x21??
DMA_Vid_6:  .long   0

A1T6:                   // Source Address L/H/B
A1T6L:		.byte	0	/* Source Address L */
A1T6H:		.byte	0	/* Source Address H */
A1B6:		.byte	0	/* Source Bank Address */
            .byte   0
DAS6:                   // Data Size L/H
DAS6L:		.byte	0	/* Data Size L */
DAS6H:		.byte	0	/* Data Size H */
DASB6:      .byte   0   // Data address bank
            .byte   0
A2L6:		.byte	0	/* hdma table address L */
A2H6:       .byte   0   /* hdma table address H */
            .word   0
.balign 16
BBAD7:                  // Low byte of 0x21??
DMA_Vid_7:  .long   0

A1T7:                   // Source Address L/H/B
A1T7L:		.byte	0	/* Source Address L */
A1T7H:		.byte	0	/* Source Address H */
A1B7:		.byte	0	/* Source Bank Address */
            .byte   0
DAS7:                   // Data Size L/H
DAS7L:		.byte	0	/* Data Size L */
DAS7H:		.byte	0	/* Data Size H */
DASB7:      .byte   0   // Data address bank
            .byte   0
A2L7:		.byte	0	/* hdma table address L */
A2H7:       .byte   0   /* hdma table address H */
            .word   0
.balign 16
.globl DMA_Access0,DMA_Access1,DMA_Access2,DMA_Access3
DMA_Access0:.long   0   // Pointer for DMA PPU read/write
DMA_Access1:.long   0   // Pointer for DMA PPU read/write
DMA_Access2:.long   0   // Pointer for DMA PPU read/write
DMA_Access3:.long   0   // Pointer for DMA PPU read/write
.globl DMA_PPU_Order
DMA_PPU_Order:
    .byte   0,0,0,0
    .byte   0,1,0,1
    .byte   0,0,0,0
    .byte   0,0,1,1
    .byte   0,1,2,3
    .byte   0,1,2,3
    .byte   0,1,2,3
    .byte   0,1,2,3
.globl HDMA_Size
HDMA_Size:
    .byte   1,2,2,4
    .byte   4,4,4,4

.balign 16
.globl Read_Map_21
Read_Map_21:
    DUPLICATE long,0x34,UNSUPPORTED_READ
	.long	MAP_READ_MPYL
	.long	MAP_READ_MPYM
	.long	MAP_READ_MPYH
    .long   MAP_READ_SLHV           // Complete as of v0.15
	.long	MAP_READ_OAMDATAREAD
	.long	MAP_READ_VMDATALREAD
	.long	MAP_READ_VMDATAHREAD
	.long	MAP_READ_CGDATAREAD		/* V 0.14 */
	.long	MAP_READ_OPHCT			/* V 0.14 */
	.long	MAP_READ_OPVCT
	.long	MAP_READ_STAT77			/* Not supported yet (properly..) */
	.long	MAP_READ_STAT78
	.long	MAP_READ_APUI00
	.long	MAP_READ_APUI01
	.long	MAP_READ_APUI02
	.long	MAP_READ_APUI03
    DUPLICATE long,60,UNSUPPORTED_READ
	.long	MAP_READ_WMDATA			/* 2180 WMDATA - read/write to Work RAM */
	.long	MAP_READ_WMADDL			/* V 0.14 */
	.long	MAP_READ_WMADDM			/* V 0.14 */
	.long	MAP_READ_WMADDH			/* V 0.14 */
    DUPLICATE long,60,UNSUPPORTED_READ
	DUPLICATE long,64,UNSUPPORTED_READ

Read_Map_40:
	DUPLICATE long,0x16,UNSUPPORTED_READ
	.long	MAP_READ_JOYC1
	.long	MAP_READ_JOYC2
    DUPLICATE long,40,UNSUPPORTED_READ
	DUPLICATE long,64,UNSUPPORTED_READ
	DUPLICATE long,64,UNSUPPORTED_READ
	DUPLICATE long,64,UNSUPPORTED_READ

Read_Map_42:
	DUPLICATE long,0x10,UNSUPPORTED_READ
	.long	MAP_READ_RDNMI
	.long	MAP_READ_TIMEUP
	.long	MAP_READ_HVBJOY
	.long	MAP_READ_RDIO		/* Not yet supported... probably never */
	.long	MAP_READ_RDDIVL
	.long	MAP_READ_RDDIVH
	.long	MAP_READ_RDMPYL
	.long	MAP_READ_RDMPYH
	.long	MAP_READ_JOY1L
	.long	MAP_READ_JOY1H
	.long	MAP_READ_JOY2L
	.long	MAP_READ_JOY2H
	.long	MAP_READ_JOY3L		/* Not yet supported... no keys? */
	.long	MAP_READ_JOY3H
	.long	MAP_READ_JOY4L		/* Not yet supported... no keys? */
	.long	MAP_READ_JOY4H
    DUPLICATE long,32,UNSUPPORTED_READ
	DUPLICATE long,64,UNSUPPORTED_READ
	DUPLICATE long,64,UNSUPPORTED_READ
	DUPLICATE long,64,UNSUPPORTED_READ

Read_Map_43:
    .long   MAP_READ_DMAP0
    .long   MAP_READ_BBAD0
    .long   MAP_READ_A1T0L
    .long   MAP_READ_A1T0H
    .long   MAP_READ_A1B0
    .long   MAP_READ_DAS0L
    .long   MAP_READ_DAS0H
    .long   UNSUPPORTED_READ
    .long   MAP_READ_A2L0
    .long   MAP_READ_A2H0
    DUPLICATE long,6,UNSUPPORTED_READ
    .long   MAP_READ_DMAP1
    .long   MAP_READ_BBAD1
    .long   MAP_READ_A1T1L
    .long   MAP_READ_A1T1H
    .long   MAP_READ_A1B1
    .long   MAP_READ_DAS1L
    .long   MAP_READ_DAS1H
    .long   UNSUPPORTED_READ
    .long   MAP_READ_A2L1
    .long   MAP_READ_A2H1
    DUPLICATE long,6,UNSUPPORTED_READ
    .long   MAP_READ_DMAP2
    .long   MAP_READ_BBAD2
    .long   MAP_READ_A1T2L
    .long   MAP_READ_A1T2H
    .long   MAP_READ_A1B2
    .long   MAP_READ_DAS2L
    .long   MAP_READ_DAS2H
    .long   UNSUPPORTED_READ
    .long   MAP_READ_A2L2
    .long   MAP_READ_A2H2
    DUPLICATE long,6,UNSUPPORTED_READ
    .long   MAP_READ_DMAP3
    .long   MAP_READ_BBAD3
    .long   MAP_READ_A1T3L
    .long   MAP_READ_A1T3H
    .long   MAP_READ_A1B3
    .long   MAP_READ_DAS3L
    .long   MAP_READ_DAS3H
    .long   UNSUPPORTED_READ
    .long   MAP_READ_A2L3
    .long   MAP_READ_A2H3
    DUPLICATE long,6,UNSUPPORTED_READ
    .long   MAP_READ_DMAP4
    .long   MAP_READ_BBAD4
    .long   MAP_READ_A1T4L
    .long   MAP_READ_A1T4H
    .long   MAP_READ_A1B4
    .long   MAP_READ_DAS4L
    .long   MAP_READ_DAS4H
    .long   UNSUPPORTED_READ
    .long   MAP_READ_A2L4
    .long   MAP_READ_A2H4
    DUPLICATE long,6,UNSUPPORTED_READ
    .long   MAP_READ_DMAP5
    .long   MAP_READ_BBAD5
    .long   MAP_READ_A1T5L
    .long   MAP_READ_A1T5H
    .long   MAP_READ_A1B5
    .long   MAP_READ_DAS5L
    .long   MAP_READ_DAS5H
    .long   UNSUPPORTED_READ
    .long   MAP_READ_A2L5
    .long   MAP_READ_A2H5
    DUPLICATE long,6,UNSUPPORTED_READ
    .long   MAP_READ_DMAP6
    .long   MAP_READ_BBAD6
    .long   MAP_READ_A1T6L
    .long   MAP_READ_A1T6H
    .long   MAP_READ_A1B6
    .long   MAP_READ_DAS6L
    .long   MAP_READ_DAS6H
    .long   UNSUPPORTED_READ
    .long   MAP_READ_A2L6
    .long   MAP_READ_A2H6
    DUPLICATE long,6,UNSUPPORTED_READ
    .long   MAP_READ_DMAP7
    .long   MAP_READ_BBAD7
    .long   MAP_READ_A1T7L
    .long   MAP_READ_A1T7H
    .long   MAP_READ_A1B7
    .long   MAP_READ_DAS7L
    .long   MAP_READ_DAS7H
    .long   UNSUPPORTED_READ
    .long   MAP_READ_A2L7
    .long   MAP_READ_A2H7
    DUPLICATE long,6,UNSUPPORTED_READ
    DUPLICATE long,64,UNSUPPORTED_READ
    DUPLICATE long,64,UNSUPPORTED_READ

.globl Write_Map_21
Write_Map_21:
	.long	MAP_WRITE_INIDISP
	.long	MAP_WRITE_OBSEL
	.long	MAP_WRITE_OAMADDL
	.long	MAP_WRITE_OAMADDH
	.long	MAP_WRITE_OAMDATA
	.long	MAP_WRITE_BGMODE
	.long	MAP_WRITE_MOSAIC
	.long	MAP_WRITE_BG1SC
	.long	MAP_WRITE_BG2SC
	.long	MAP_WRITE_BG3SC
	.long	MAP_WRITE_BG4SC
	.long	MAP_WRITE_BG12NBA
	.long	MAP_WRITE_BG34NBA
	.long	MAP_WRITE_BG1HOFS
	.long	MAP_WRITE_BG1VOFS
	.long	MAP_WRITE_BG2HOFS
	.long	MAP_WRITE_BG2VOFS
	.long	MAP_WRITE_BG3HOFS
	.long	MAP_WRITE_BG3VOFS
	.long	MAP_WRITE_BG4HOFS
	.long	MAP_WRITE_BG4VOFS
	.long	MAP_WRITE_VMAIN
	.long	MAP_WRITE_VMADDL
	.long	MAP_WRITE_VMADDH
	.long	MAP_WRITE_VMDATAL
	.long	MAP_WRITE_VMDATAH
	.long	MAP_WRITE_M7SEL		/* V 0.14 Embarassing bug fixed! */
	.long	MAP_WRITE_M7A
	.long	MAP_WRITE_M7B
	.long	MAP_WRITE_M7C
	.long	MAP_WRITE_M7D
	.long	MAP_WRITE_M7X
	.long	MAP_WRITE_M7Y
	.long	MAP_WRITE_CGADD
	.long	MAP_WRITE_CGDATA
    .long   MAP_WRITE_W12SEL
    .long   MAP_WRITE_W34SEL
    .long   MAP_WRITE_WOBJSEL
	.long	MAP_WRITE_WH0
	.long	MAP_WRITE_WH1
    .long   MAP_WRITE_WH2
    .long   MAP_WRITE_WH3
    .long   MAP_WRITE_WBGLOG
    .long   MAP_WRITE_WOBJLOG
	.long	MAP_WRITE_TM
	.long	MAP_WRITE_TD			/* TD,TMW,TSW,CGWSEL,CGADSUB,COLDATA not done */
	.long	MAP_WRITE_TMW
	.long	MAP_WRITE_TSW
	.long	MAP_WRITE_CGWSEL
	.long	MAP_WRITE_CGADSUB
	.long	MAP_WRITE_COLDATA
	.long	MAP_WRITE_SETINI		/* Not supported... no need I dont think! */
	DUPLICATE long,12,UNSUPPORTED_WRITE
	.long	MAP_WRITE_APUI00			/* 2140 - SPC Registers */
	.long	MAP_WRITE_APUI01
	.long	MAP_WRITE_APUI02
	.long	MAP_WRITE_APUI03
	DUPLICATE long,60,UNSUPPORTED_WRITE
	.long	MAP_WRITE_WMDATA		/* 2180 WMDATA - read/write to Work RAM */
	.long	MAP_WRITE_WMADDL		/* 2181-3 WMAddress */
	.long	MAP_WRITE_WMADDM
	.long	MAP_WRITE_WMADDH
    DUPLICATE long,60,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE

Write_Map_40:
	DUPLICATE long,0x16,UNSUPPORTED_WRITE
	.long	MAP_WRITE_JOYC1
	.long	MAP_WRITE_JOYC2
    DUPLICATE long,50,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE

Write_Map_42:
	.long	MAP_WRITE_NMITIMEN
	.long	UNSUPPORTED_WRITE
	.long	MAP_WRITE_WRMPYA
	.long	MAP_WRITE_WRMPYB
	.long	MAP_WRITE_WRDIVL
	.long	MAP_WRITE_WRDIVH
	.long	MAP_WRITE_WRDIVB
    .long   MAP_WRITE_HTIMEL    // Saved but unused
    .long   MAP_WRITE_HTIMEH
    .long   MAP_WRITE_VTIMEL
    .long   MAP_WRITE_VTIMEH
	.long	MAP_WRITE_MDMAEN
	.long	MAP_WRITE_HDMAEN
    .long   MAP_WRITE_MEMSEL
    DUPLICATE long,50,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE

Write_Map_43:
	.long	MAP_WRITE_DMAP0
	.long	MAP_WRITE_BBAD0
	.long	MAP_WRITE_A1T0L
	.long	MAP_WRITE_A1T0H
	.long	MAP_WRITE_A1B0
	.long	MAP_WRITE_DAS0L
	.long	MAP_WRITE_DAS0H
    .long   MAP_WRITE_DASB0
	.long	MAP_WRITE_A2L0
	.long	MAP_WRITE_A2H0
	DUPLICATE long,6,UNSUPPORTED_WRITE
	.long	MAP_WRITE_DMAP1
	.long	MAP_WRITE_BBAD1
	.long	MAP_WRITE_A1T1L
	.long	MAP_WRITE_A1T1H
	.long	MAP_WRITE_A1B1
	.long	MAP_WRITE_DAS1L
	.long	MAP_WRITE_DAS1H
    .long   MAP_WRITE_DASB1
	.long	MAP_WRITE_A2L1
	.long	MAP_WRITE_A2H1
	DUPLICATE long,6,UNSUPPORTED_WRITE
	.long	MAP_WRITE_DMAP2
	.long	MAP_WRITE_BBAD2
	.long	MAP_WRITE_A1T2L
	.long	MAP_WRITE_A1T2H
	.long	MAP_WRITE_A1B2
	.long	MAP_WRITE_DAS2L
	.long	MAP_WRITE_DAS2H
    .long   MAP_WRITE_DASB2
	.long	MAP_WRITE_A2L2
	.long	MAP_WRITE_A2H2
	DUPLICATE long,6,UNSUPPORTED_WRITE
	.long	MAP_WRITE_DMAP3
	.long	MAP_WRITE_BBAD3
	.long	MAP_WRITE_A1T3L
	.long	MAP_WRITE_A1T3H
	.long	MAP_WRITE_A1B3
	.long	MAP_WRITE_DAS3L
	.long	MAP_WRITE_DAS3H
    .long   MAP_WRITE_DASB3
	.long	MAP_WRITE_A2L3
	.long	MAP_WRITE_A2H3
	DUPLICATE long,6,UNSUPPORTED_WRITE
	.long	MAP_WRITE_DMAP4
	.long	MAP_WRITE_BBAD4
	.long	MAP_WRITE_A1T4L
	.long	MAP_WRITE_A1T4H
	.long	MAP_WRITE_A1B4
	.long	MAP_WRITE_DAS4L
	.long	MAP_WRITE_DAS4H
    .long   MAP_WRITE_DASB4
	.long	MAP_WRITE_A2L4
	.long	MAP_WRITE_A2H4
	DUPLICATE long,6,UNSUPPORTED_WRITE
	.long	MAP_WRITE_DMAP5
	.long	MAP_WRITE_BBAD5
	.long	MAP_WRITE_A1T5L
	.long	MAP_WRITE_A1T5H
	.long	MAP_WRITE_A1B5
	.long	MAP_WRITE_DAS5L
	.long	MAP_WRITE_DAS5H
    .long   MAP_WRITE_DASB5
	.long	MAP_WRITE_A2L5
	.long	MAP_WRITE_A2H5
	DUPLICATE long,6,UNSUPPORTED_WRITE
	.long	MAP_WRITE_DMAP6
	.long	MAP_WRITE_BBAD6
	.long	MAP_WRITE_A1T6L
	.long	MAP_WRITE_A1T6H
	.long	MAP_WRITE_A1B6
	.long	MAP_WRITE_DAS6L
	.long	MAP_WRITE_DAS6H
    .long   MAP_WRITE_DASB6
	.long	MAP_WRITE_A2L6
	.long	MAP_WRITE_A2H6
	DUPLICATE long,6,UNSUPPORTED_WRITE
	.long	MAP_WRITE_DMAP7
	.long	MAP_WRITE_BBAD7
	.long	MAP_WRITE_A1T7L
	.long	MAP_WRITE_A1T7H
	.long	MAP_WRITE_A1B7
	.long	MAP_WRITE_DAS7L
	.long	MAP_WRITE_DAS7H
    .long   MAP_WRITE_DASB7
	.long	MAP_WRITE_A2L7
	.long	MAP_WRITE_A2H7
    DUPLICATE long,6,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE
	DUPLICATE long,64,UNSUPPORTED_WRITE

.text
