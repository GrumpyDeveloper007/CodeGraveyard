2****************************************************
*                   SIDPLAYER V1.0                  *
*             Coded by Alfatech/Censor              *
*						    *
* Released to the public as a X-Mas present to all  *
*                      CODERS                       *
*****************************************************
*                    Some Info                      *
*              Remove Lines 550-End                 *
*     That code is just for testing the tune        *
*    
*                                                   *
*  If you have any kind of problems then just call  *
*  me at +47-22420102 and ask for "CHE"             *
*						    *
*        HAVE A NICE XMAS AND A HAPPY NEW YEAR      *
*****************************************************

	heap O=64k
	smc+
song		equ	3
latstelle	equ	$7f41be	;Where the music is located		
initreal	equ	$41c9	;Init
playreal	equ	$41c0	;Play

initmusic	equ	$7f0200 ;dessa2 ska ha samma
playmusic	equ	initmusic+8
sustain		equ	1
voice1		equ	0
voice2		equ	7
voice3		equ	14
freq		equ	0
retrig		equ	2
pulsevalue	equ	3
waveform	equ	4
adsr		equ	5
	rs=$0200
sid	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
equal	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
decay	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
var	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
var1	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
var2	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
var3	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
var4	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
var5	rs.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
work	rs.b	0,0
retriga	rs.b	0
samp	rs.b	0
ad_sr	rs.b	0,0,0,0
majba	rs.b	0
	*=$8010
	Jmp	Init
	Jmp	Play
Reset	lda	#$40	;Reset the APU (spc-700)
	sta	$2142
	rts
*****************************************
c64tune
        .bin    snes:giana  ; ** Amiga device refference ** Change it if PC!
c64tuneend
*****************************************
Init	php
	sep	#$30
	ldx	#$00
	txa
.hej	stz	$00,x
	inx
	bne	.hej

	jsr	initram

	ldx	#$00
	txa
.cler	sta	$7fd400,x
	inx
	bne	.cler
	lda	#$0f
	sta	$7fd418
	sec
	xce
	lda	#song
	jsl	initmusic
	clc
	xce
	jsr	StartSending	;Send Spc code/data
	stz	majba
	plp
	rts
*************************************
Play	php
	sep	#$30
	ldx	#$3f
	lda	$2100,x		;Pal or NTSC
	and	#$10
	bne	.gaga		;if NTSC then play 5 frames out of 6
	inc	majba
	lda	majba
	cmp	#6
	bne	.gaga
	stz	majba
	bra	.gaga2
.gaga	jsl	playmusic
	jsr	Send_Freq
.gaga2	plp
	rts
*********************************
* Send Frequence
*********************************
Send_Freq
	php
	sep	#$30
	lda	#$fd
.again	cmp	$2140
	bne	.again
	lda	#$fe		;reset handshaking
	sta	$2140		;for my routines
.waita	cmp	$2140
	bne	.waita




	lda	#$00
	sta	work+1
	ldx	#voice1
	jsr	getvoicedata
	inc	work+1
	ldx	#voice2
	jsr	getvoicedata
	inc	work+1
	ldx	#voice3
	jsr	getvoicedata



	ldx	#$00

.loop	lda	sid,x
	sta	$2141
	stx	$2140
.jups	cpx	$2140
	beq	.jups
	inx
.nops	cpx	$2140
	bne	.nops
	cpx	#21
	bne	.loop

	plp
	rts
*********************************
getvoicedata
	php
	rep	#$20
	clc
	lda	$7fd400,x
	ldy	#$00
	lsr	a
	cmp	#$3000
	bcc	.nops
	clc
	lsr	a
	ldy	#1
.nops	sta	sid+freq,x
	tya
	sta	sid+retrig,x

	sep	#$20
	ldy	#$00
	lda	#$00
	sta	sid+waveform,x
	lda	$7fd404,x
	and	#$01
	beq	.fade
	ldy	#$80
.fade	sty	work
	lda	$7fd404,x
	and	#$f0
	sta	samp
	and	#$80
	beq	.noss2
	lda	#$03
	sta	sid+waveform,x
	bra	.getadsr
.noss2
	lda	samp
	and	#$40
	beq	.nopulse
	lda	#$02
	sta	sid+waveform,x
	lda	samp
	and	#$10
	beq	.getadsr
	lda	#$22
	sta	sid+waveform,x
	bra	.getadsr
.nopulse
	lda	samp
	and	#$20
	beq	.noss
	lda	#$01
	sta	sid+waveform,x
	bra	.getadsr
.noss
	lda	samp
	and	#$10
	beq	.noss1
	lda	#$00
	sta	sid+waveform,x
	bra	.getadsr
.noss1
	lda	samp
	bne	.getadsr
	lda	#36
	sta	sid+waveform,x
.getadsr
	lda	$7fd405,x
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	asl	a
	sta	ad_sr

	lda	$7fd405,x
	and	#$0f
	asl	a
	sta	ad_sr+1

	lda	$7fd406,x
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	eor	#$0f
	asl	a
	sta	ad_sr+2

	lda	$7fd406,x
	and	#$0f
	asl	a
	sta	ad_sr+3

	lda	$7fd400+voice1+pulsevalue,x
	and	#$0f
	pha
	cmp	#$00
	bne	.ok
	lda	$7fd400+voice1+retrig,x
	beq	.ok	
	pla
	inc	a
	bra	.ok+1
.ok	pla
	sta	sid+pulsevalue,x

.doadsr
	lda	work
	beq	.decrease
	lda	decay,x
	bne	.decay

	rep	#$20
	lda	equal+adsr,x
	cmp	#$7fff
	beq	.e
	ldy	ad_sr
	lda	equal+adsr,x
	clc
	adc	.attack,y
	cmp	#$7fff
	bcc	.nottop
	lda	#sustain
	sta	decay,x
	lda	#$7fff
.nottop	sta	equal+adsr,x
	bra	.endcalcdata
.e
	lda	#sustain
	sta	decay,x
	bra	.endcalcdata
.decrease

	rep	#$20
	lda	#$00
	sta	decay,x
	lda	equal+adsr,x
	cmp	#$0000
	beq	.endcalcdata
	jsr	.checkvar
	bcc	.endcalcdata
	ldy	ad_sr+3
	lda	equal+adsr,x
	sec
	sbc	.release,y
	bpl	.notbot
	lda	#$0000
.notbot	sta	equal+adsr,x
	bra	.endcalcdata
.decay
	rep	#$20
	ldy	ad_sr+2
	lda	equal+adsr,x
	cmp	.sustain,y
	beq	.endcalcdata
	jsr	.checkvar
	bcc	.endcalcdata
	ldy	ad_sr+1
	lda	equal+adsr,x
	sec
	sbc	.release,y
	ldy	ad_sr+2
	cmp	.sustain,y
	bcs	.notsus
	lda	.sustain,y
.notsus	sta	equal+adsr,x
.endcalcdata
	lda	equal+adsr,x
	sta	$4204
	sep	#$30
	lda	$7fd418
	eor	#$0f
	and	#$0f
	bne	.divid
.full	rep	#$20
	lda     equal+adsr,x
	bra	.full2
.divid	sta	$4206
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	rep	#$20
	lda	$4214
.full2	and	#$7fff
	sta	sid+adsr,x
	plp
	rts
.checkvar
	lda     equal+adsr,x
	cmp	#$0001
	bmi	.check6
	cmp	#$0c01
	bmi	.check5
	cmp	#$1401
	bmi	.check4
	cmp	#$2001
	bmi	.check3
	cmp	#$2c01
	bmi	.check2
	cmp	#$3801
	bmi	.check1
.subba	lda	#0
	sta	var,x
	sta	var1,x
	sta	var2,x
	sta	var3,x
	sta	var4,x
	sta	var5,x
	sec
	rts
.checko
	jmp	.check6
.check1
	inc	var,x
	lda	var,x
	cmp	#2
	beq	.subba
	clc
	rts
.check2
	inc	var1,x
	lda	var1,x
	cmp	#3
	beq	.subba
	clc
	rts
.check3
	inc	var2,x
	lda	var2,x
	cmp	#4
	beq	.subba
	clc
	rts
.check4
	inc	var3,x
	lda	var3,x
	cmp	#4
	beq	.subba
	clc
	rts
.check5
	inc	var4,x
	lda	var4,x
	cmp	#5
	beq	.subba
	clc
	rts
.check6
	inc	var5,x
	lda	var5,x
	cmp	#6
	beq	.subba
	clc
	rts


.attack		;attack verde ... hur snabb okning fran nuvarande
		;till fullljudstyrka
	dcr.w	32767,32767,32767,27306,17246,11565,9637,8192
	dcr.w	6553,2621,1310,819,655,218,131,82
.release	;release/decay ... samma tabell
	dcr.w	32767,27306,13653,9102,5748,3900,3212,2730
	dcr.w	2184,873,436,273,218,72,43,27

.sustain
	dcr.w	32767,30720,28672,26624,24576,22528,20480,18432
	dcr.w	16384,14336,12288,10240,8192,6144,4096,2048,0
*********************************




initram
	php
	rep	#$10
	sep	#$20
	ldx	#$00
.copram	lda	ram,x
	sta	initmusic,x
	inx
	cpx	#endram-ram
	bne	.copram
	ldx	#$00
.copmus	lda	c64tune,x
	sta	latstelle,x
	inx
	cpx	#c64tuneend-c64tune
	bne	.copmus
	plp
	rts
	mode	a8x8
ram
	phb
	phk
	plb
	jsr	initreal
	plb
	rtl
rum
	phb
	phk
	plb
	jsr	playreal
	plb
	rtl
endram
**************************

StartSending
	php
	SEP #$20
	phk
	pla
	STA $FF
	REP #$20
	LDA #code
	STA $FD
	JSR SendToSpc
	SEP #$20
	lda #$ff
	sta $2140
	Stz $2142
	plp
	RTS
SendToSpc
	PHP
	REP #$30
	LDY #$0000
	LDA #$BBAA
.wait	CMP $2140
	BNE .wait
	SEP #$20
	LDA #$CC
	BRA .lab3
.loop	LDA [$FD],y
	INY
	XBA
	LDA #$00
	BRA .lab1
.loop2	XBA
	LDA [$FD],y
	INY
	XBA
.lab2	CMP $2140
	BNE .lab2
	INC A
.lab1	REP #$20
	STA $2140
	SEP #$20
	DEX
	BNE .loop2
.lab5	CMP $2140
	BNE .lab5
.lab4	ADC #$03
	BEQ .lab4
.lab3	PHA
	REP #$20
	LDA [$FD],y
	INY
	INY
	TAX
	LDA [$FD],y
	INY
	INY
	STA $2142
	SEP #$20
	CPX #$0001
	LDA #$00
	ROL A
	STA $2141
	ADC #$7F
	PLA
	STA $2140
.lab6	CMP $2140
	BNE .lab6
	BVS .loop
	PLP
	RTS
*****************************************
*		SPC CODE		*
*****************************************
code	
	dcr.w	CodeEnd-CodeStart,$0400
CodeStart
        .bin    snes:SOURCES/variuos/spc_code_vblank ; Amiga HD Reff
                                                     ; Change if using PC!
CodeEnd
	dcr.w	0,$0400	;start,address
	dc.b	"MusicRoutine © Alfatech/Censor 94"
*****************************************





calc
	php
	sep	#$30
	lda	$7fd400
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1029
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1028
	lda	$7fd401
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1027
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1026

	lda	$7fd403
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1046
	ldx	#$20


	lda	$7fd404
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1067
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1066

	lda	sid+adsr+voice1+1
;	lda	$7fd405
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1087
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1086
	lda	sid+adsr+voice1
;	lda	$7fd406
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1089
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1088





	lda	$7fd400+voice2
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1029+11
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1028+11
	lda	$7fd401+voice2
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1027+11
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1026+11

	lda	$7fd403+voice2
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1046+11
	ldx	#$20


	lda	$7fd404+voice2
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1067+11
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1066+11

	lda	sid+adsr+voice2+1
;	lda	$7fd405+7
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1087+11
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1086+11
	lda	sid+adsr+voice2
;	lda	$7fd406+7
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1089+11
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1088+11





	lda	$7fd400+voice3
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1029+22
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1028+22
	lda	$7fd401+voice3
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1027+22
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1026+22

	lda	$7fd403+voice3
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1046+22
	ldx	#$20


	lda	$7fd404+voice3
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1067+22
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1066+22

	lda	$7fd400+adsr+voice3
;	lda	$2142
	lda	sid+adsr+voice3+1
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1087+22
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1086+22
	lda	$7fd400+adsr+voice3+1
;	lda	$2143
	lda	sid+adsr+voice3
	sta	work
	and	#$0f
	tax
	lda	.data,x
	sta	$1089+22
	lda	work
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	tax
	lda	.data,x
	sta	$1088+22
	plp
	rts
.data	dc.b	'0123456789ABCDEF'


text
	dc.b	'   VOICE1    VOICE2     VOICE3  '
	dc.b	'FREQ=$0000 FREQ=$0000 FREQ=$0000'
	dc.b	'PULS=$00   PULS=$00   PULS=$00  '
	dc.b	'SAMP=$00   SAMP=$00   SAMP=$00  '
	dc.b	'VOLU=$0000 VOLU=$0000 VOLU=$0000'








irq
	php
	rep	#$30
	pha
	phx
	phy
	phb
	phk
	plb
	sep	#$20
	rep	#$10

	lda	#$80
	sta	$2115
	ldx	#$1000
	stx	$2116
	ldx	#$00
.loop	lda	$1000,x
	sta	$2118
	stz	$2119
	inx
	cpx	#$a0
	bne	.loop

	ldx	#$00
.loop2	lda	$7f1000,x
	and	#$1f
	sta	$2118
	stz	$2119
	inx
	cpx	#$100
	bne	.loop2


	rep	#$30
	plb
	ply
	plx
	pla
	plp
	rti

Start
	clc
	xce
	sep	#$30
	ldx	#$00
.coptxt	lda	text,x
	sta	$1000,x
	inx
	cpx	#$a0
	bne	.coptxt

	rep	#$10	
	lda	#$80
	sta	$2115
	ldx	#$1000
	stx	$2116
	ldx	#$00
	lda	#$20
.copfnt	sta	$2118
	stz	$2119
	inx
	cpx	#$400
	bne	.copfnt

	sep	#$30
	stz	$210d
	stz	$210d
	lda	#$ff
	sta	$210e
	stz	$210e

	Jsr	Init
	lda	#01
	sta	$212c
	lda	#$10
	sta	$2107
	lda	#$00
	sta	$210b
	sep	#$30
	lda	#$0f
	sta	$2100
	lda	#$e0
	sta	$2132
	lda	#$81
	sta	$4200
.loop
	wai
	jsr	Play
	jsr	calc
	lda	$4218
	and	#$80
	beq	.loop
	jsr	Reset
	ldx	#$ff
.l	dex
	bne	.l
	jsr	StartSending
	bra	.loop




	*=$ffea
	dcr.w	irq
	*=$fffc
	dcr.w	Start
