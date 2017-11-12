StartAddress:	EQU	$400
	org	$400
CodeStart:
Control:	EQU	$f1
Port0:		EQU	$f4
Port1:		EQU	$f5


hi		equ	0
lo		equ	1
voice1		equ	0
voice2		equ	7
voice3		equ	14
freq		equ	0
retrig		equ	2
pulsevalue	equ	3
waveform	equ	4
adsr		equ	5


destination	equ	$72
source1		equ	$74
source2		equ	$76
samp		equ	$78
mixit		equ	$7a
noise		equ	$7b
first		equ	$7c
wavef1		equ	$7d
wavef2		equ	$7e
wavef3		equ	$7f
sidemu		equ	$80

ss	clrp 
	mov	x,#$cf		;set stack
	mov	sp,x

	mov	$f4,#$ff


	mov	a,#0
	mov	x,a
.Clr1	mov	(x)+,a
	cmp	x,#$f0
	bne	.Clr1

	mov	x,a
.Clr2	mov	|$100+x,a
	mov	|$200+x,a
	mov	|$300+x,a
	inc	x
	bne	.Clr2

	mov	Control,#0
	mov	Control,#$30	;Reset Ports 0-3


	call	|init
	call	|InitBaj

	mov	x,#$00
	mov	y,#$00
.copytolibrary
	mov	a,|whatsample+x
	mov	|$200+y,a
	mov	|$202+y,a
	inc	x
	inc	y
	mov	a,|whatsample+x
	mov	|$200+y,a
	mov	|$202+y,a
	inc	x
	inc	y
	inc	y
	inc	y
	cmp	x,#init-whatsample
	bne	.copytolibrary		
	
wait	
	mov	$f4,#$fd
.wait	cmp	$f4,#$fe
	bne	.wait
	mov	$f4,#$fe	;sycronisation ready? de let bra hehe
	mov	$f2,#$39
	mov	$f6,$f3

	mov	x,#$00
.doitagain
	cmp	x,$f4		;check handshaking
	bne	.doitagain	;not finished
	mov	a,$f5		;get data
	mov	sidemu+x,a	;store data
	inc	x		;increase x
	mov	$f4,x		;new handshaking
	cmp	x,#21		;all data transffered
	bne	.doitagain	;nops .. do i again

	
	mov	noise,#$00

	mov	a,sidemu+voice1+waveform
	and	a,#$7f

	cmp	a,#36
	bne	.domix
	mov	$f2,#$34
	mov	$f3,a
	bra	.noisedone
.domix
	mov	x,a
	and	a,#$20
	beq	.doother
	mov	a,sidemu+voice1+waveform
	mov	destination,#<tom1
	mov	destination+1,#>tom1
	mov	mixit,sidemu+voice1+pulsevalue
	call	|mix
	mov	$f2,#$34
	mov	$f3,#37
	bra	.mixdone
.doother
	mov	a,x
	cmp	a,#3
	bne	.donormal
	or	noise,#8
	lsr	sidemu+voice1+adsr+1
	lsr	sidemu+voice1+adsr+1
	bra	.noisedone
.donormal
	cmp	a,#$2
	bne	.nopulse
	clrc
	adc	a,sidemu+voice1+pulsevalue
.nopulse
	mov	$f2,#$34	;waveform
	asl	a
	clrc
	adc	a,sidemu+voice1+retrig
	mov	$f3,a

.mixdone
	mov	$f2,#$32	;Pitch-Lo
	mov	a,sidemu+voice1+freq
	and	a,#$f0
	mov	$f3,a
	mov	$f2,#$33	;Pitch-Hi
	mov	$f3,sidemu+voice1+freq+1
.noisedone


	mov	$f2,#$30
	mov	$f3,sidemu+voice1+adsr+1
	mov	$f2,#$31
	mov	$f3,sidemu+voice1+adsr+1



vojs2
	mov	a,sidemu+voice2+waveform
	and	a,#$7f
	cmp	a,#36
	bne	.domix
	mov	$f2,#$44
	mov	$f3,a
	bra	.noisedone
.domix
	mov	x,a
	and	a,#$20
	beq	.doother
	mov	a,sidemu+voice2+waveform
	mov	destination,#<tom2
	mov	destination+1,#>tom2
	mov	mixit,sidemu+voice2+pulsevalue
	call	|mix
	mov	$f2,#$44
	mov	$f3,#38
	bra	.mixdone
.doother
	mov	a,x
	cmp	a,#3
	bne	.donormal
	or	noise,#16
	lsr	sidemu+voice2+adsr+1
	lsr	sidemu+voice2+adsr+1
	bra	.noisedone
.donormal
	cmp	a,#$2
	bne	.nopulse
	clrc
	adc	a,sidemu+voice2+pulsevalue
.nopulse
	mov	$f2,#$44	;waveform
	asl	a
	clrc
	adc	a,sidemu+voice2+retrig
	mov	$f3,a
.mixdone
	mov	$f2,#$42	;Pitch-Lo
	mov	a,sidemu+voice2+freq
	and	a,#$f0
	mov	$f3,a
	mov	$f2,#$43	;Pitch-Hi
	mov	$f3,sidemu+voice2+freq+1

.noisedone

	mov	$f2,#$40
	mov	$f3,sidemu+voice2+adsr+1
	mov	$f2,#$41
	mov	$f3,sidemu+voice2+adsr+1
vojs3
	mov	a,sidemu+voice3+waveform
	and	a,#$7f
	cmp	a,#36
	bne	.domix
	mov	$f2,#$24
	mov	$f3,a
	bra	.noisedone
.domix
	mov	x,a
	and	a,#$20
	beq	.doother
	mov	a,sidemu+voice3+waveform
	mov	destination,#<tom3
	mov	destination+1,#>tom3
	mov	mixit,sidemu+voice3+pulsevalue
	call	|mix
	mov	$f2,#$24
	mov	$f3,#39
	bra	.mixdone
.doother
	mov	a,x
	cmp	a,#3
	bne	.donormal
	or	noise,#4
	lsr	sidemu+voice3+adsr+1
	lsr	sidemu+voice3+adsr+1
	bra	.noisedone
.donormal
	cmp	a,#$2
	bne	.nopulse
	clrc
	adc	a,sidemu+voice3+pulsevalue
	nop
.nopulse
	asl	a
	clrc
	adc	a,sidemu+voice3+retrig
	mov	x,a
	mov	$f2,#$24	;waveform
	mov	$f3,a
.mixdone
	mov	$f2,#$22	;Pitch-Lo
	mov	a,sidemu+voice3+freq
	and	a,#$f0
	mov	$f3,a
	mov	$f2,#$23	;Pitch-Hi
	mov	$f3,sidemu+voice3+freq+1

.noisedone

	mov	$f2,#$20
	mov	$f3,sidemu+voice3+adsr+1
	mov	$f2,#$21
	mov	$f3,sidemu+voice3+adsr+1

end

	mov	$f2,#$3d
	mov	$f3,noise




	mov	a,$f6
	cmp	a,#$40
	bne	.over
	mov	a,$f6
	call	|init
	mov	x,#$00
.hej	mov	a,|rom+x
	mov	|$ffc0+x,a
	inc	x
	cmp	x,#$40
	bne	.hej
	jmp	|$ffc0
.over	mov	$f2,#$39
	mov	$f7,$f3
	jmp	|wait


puls0hi
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls0
puls1hi
	dc.b	$b0,$88,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls1
puls2hi
	dc.b	$b0,$88,$88,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls2
puls3hi
	dc.b	$b0,$88,$88,$88,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls3
puls4hi
	dc.b	$b0,$88,$88,$88,$88,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls4
puls5hi
	dc.b	$b0,$88,$88,$88,$88,$88,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls5
puls6hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls6
puls7hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls7
puls8hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls8
puls9hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$77,$77,$77,$77,$77,$77,$77	;puls9
puls10hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$77,$77,$77,$77,$77,$77	;puls10
puls11hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$88,$77,$77,$77,$77,$77	;puls11
puls12hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$88,$88,$77,$77,$77,$77	;puls12
puls13hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$88,$88,$88,$77,$77,$77	;puls13
puls14hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$88,$88,$88,$88,$77,$77	;puls14
puls15hi
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$88,$88,$88,$88,$88,$77	;puls15

sawtoothhi
	dc.b	$b0,$00,$11,$22,$33,$44,$55,$66,$77	;sawtooth
	dc.b	$b3,$88,$99,$aa,$bb,$cc,$dd,$ee,$ff
trianglehi
	dc.b	$b0,$01,$23,$45,$67,$65,$43,$21,$0f	;triangular
	dc.b	$b3,$fe,$dc,$ba,$98,$89,$ab,$cd,$ef
puls0
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls0
puls1
	dc.b	$b0,$88,$88,$77,$77,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls1
puls2
	dc.b	$b0,$88,$88,$88,$88,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls2
puls3
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls3
puls4
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls4
puls5
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$77,$77,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls5
puls6
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$77,$77,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls6
puls7
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$77,$77	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls7
puls8
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$77,$77,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls8
puls9
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$77,$77,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls9
puls10
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$77,$77,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls10
puls11
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$77,$77	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls11
puls12
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$77,$77,$77,$77,$77,$77,$77,$77	;puls12
puls13
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$77,$77,$77,$77,$77,$77	;puls13
puls14
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$88,$88,$77,$77,$77,$77	;puls14
puls15
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b0,$88,$88,$88,$88,$88,$88,$88,$88	;
	dc.b	$b3,$88,$88,$88,$88,$88,$88,$77,$77	;puls15
sawtooth
	dc.b	$b0,$00,$00,$11,$11,$22,$22,$33,$33
	dc.b	$b0,$44,$44,$55,$55,$66,$66,$77,$77
	dc.b	$b0,$88,$88,$99,$99,$aa,$aa,$bb,$bb	;sawtooth
	dc.b	$b3,$cc,$cc,$dd,$dd,$ee,$ee,$ff,$ff
triangle
	dc.b	$b0,$00,$11,$22,$33,$44,$55,$66,$77	;triangular
	dc.b	$b0,$77,$66,$55,$44,$33,$22,$11,$00
	dc.b	$b0,$ff,$ee,$dd,$cc,$bb,$aa,$99,$88
	dc.b	$b3,$88,$99,$aa,$bb,$cc,$dd,$ee,$ff
quiet
	dc.b	$03,$00,$00,$00,$00,$00,$00,$00,$00
tom1
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
tom2
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
tom3
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00

whatsample
	dcr.w	triangle,trianglehi,sawtooth,sawtoothhi,puls0,puls0hi
	dcr.w	puls1,puls1hi,puls2,puls2hi,puls3,puls3hi,puls4,puls4hi,puls5,puls5hi
	dcr.w	puls6,puls6hi,puls7,puls7hi,puls8,puls8hi,puls9,puls9hi,puls10,puls10hi,puls11,puls11hi,puls12,puls12hi,puls13,puls13hi
	dcr.w	puls14,puls14hi,puls15,puls15hi,quiet,tom1,tom2,tom3
init
	mov	x,#$00
	clrc
.i
	mov	a,x
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	inc	x
	cmp	x,#$a
	bne	.i

	mov	x,#$0c
	clrc
.i1
	mov	a,x
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	adc	a,#$10
	mov	$f2,a
	mov	$f3,#$00
	inc	x
	cmp	x,#$10
	bne	.i1
	ret
InitBaj

	mov	$f2,#$3d	;noise off on all voices
	mov	$f3,#$00

	mov	$f2,#$4d	;echo off on all voices
	mov	$f3,#$00

	mov	$f2,#$6c	;FLG
	mov	$f3,#$20	;Reset=Off,Mute=Off,/ECEN=Off
				;NCK=2kHz
	mov	$f2,#$0c	;MVOL-L
	mov	$f3,#$3f	;max
	mov	$f2,#$1c	;MVOL-R
	mov	$f3,#$3f	;max

	mov	$f2,#$5d	;DIR
	mov	$f3,#$02	;=$0200


	mov	$f2,#$30	;VOL-L Ch0
	mov	$f3,#$7f	;max volume
	mov	$f2,#$31	;VOL-R Ch0
	mov	$f3,#$7f	;max volume

	mov	$f2,#$35	;ADSR-1
	mov	$f3,#%01100111	;ADSR=ON,DR=180ms,AR=640ms
	mov	$f2,#$36	;ADSR-2
	mov	$f3,#%00011000	;SL=3,SR=F
	mov	$f2,#$37
	mov	$f3,#%01111111	;gain

	mov	$f2,#$40	;VOL-L Ch0
	mov	$f3,#$7f	;max volume
	mov	$f2,#$41	;VOL-R Ch0
	mov	$f3,#$7f	;max volume

	mov	$f2,#$45	;ADSR-1
	mov	$f3,#%01100111	;ADSR=ON,DR=180ms,AR=640ms
	mov	$f2,#$46	;ADSR-2
	mov	$f3,#%00011000	;SL=3,SR=F
	mov	$f2,#$47
	mov	$f3,#%01111111	;gain

	mov	$f2,#$20	;VOL-L Ch0
	mov	$f3,#$7f	;max volume
	mov	$f2,#$21	;VOL-R Ch0
	mov	$f3,#$7f	;max volume

	mov	$f2,#$25	;ADSR-1
	mov	$f3,#%01100111	;ADSR=ON,DR=180ms,AR=640ms
	mov	$f2,#$26	;ADSR-2
	mov	$f3,#%00011000	;SL=3,SR=F
	mov	$f2,#$27
	mov	$f3,#%01111111	;gain


	mov	first,#$00
	mov	wavef1,#$00
	mov	wavef2,#$00
	mov	wavef3,#$00

	mov	$f2,#$6c
	mov	$f3,#$38


	mov	$f2,#$4c
	mov	$f3,#4+8+16

	ret
mix
	mov	samp,#<whatsample
	mov	samp+1,#>whatsample
	mov	x,a
	lsr	a
	lsr	a
	lsr	a
	lsr	a
	mov	first,a
	mov	a,x
	and	a,#$03
	clrc
	adc	a,mixit
	asl	a
	asl	a
	mov	y,a
	mov	a,[samp]+y
	mov	source1,a
	inc	y
	mov	a,[samp]+y
	mov	source1+1,a
	mov	a,first
	mov	y,#$00
	mov	a,[samp]+y
	mov	source2,a
	inc	y
	mov	a,[samp]+y
	mov	source2+1,a



	mov	y,#$00
.inner
	mov	a,[source1]+y
	and	a,[source2]+y
	mov	[destination]+y,a
	inc	y
	cmp	y,#36	
	bne	.inner
	ret

ROM:	DC.B	$CD,$EF,$BD,$E8,$00,$C6,$1D,$D0
	DC.B	$FC,$8F,$AA,$F4,$8F,$BB,$F5,$78
	DC.B	$CC,$F4,$D0,$FB,$2F,$19,$EB,$F4
	DC.B	$D0,$FC,$7E,$F4,$D0,$0B,$E4,$F5
	DC.B	$CB,$F4,$D7,$00,$FC,$D0,$F3,$AB
	DC.B	$01,$10,$EF,$7E,$F4,$10,$EB,$BA
	DC.B	$F6,$DA,$00,$BA,$F4,$C4,$F4,$DD
	DC.B	$5D,$D0,$DB,$1F,$00,$00,$C0,$FF
