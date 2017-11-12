;
;       SPC Explorer 2.0 '95 Source Code
;

INIDISP		equ	$2100	; Screen Brightness Setting
OBJSEL		equ	$2101	; Object Size & Data Area
OAMADDL		equ	$2102	; OAM Port Address in VRAM
OAMADDH		equ	$2103
OAMDATA		equ	$2104	; OAM Port Write Data
BGMODE		equ	$2105	; Background Mode and Character Size
MOSAIC		equ	$2106	; Pixel Size
BG1SC		equ	$2107	; Screen Data Address in VRAM
BG2SC		equ	$2108
BG3SC		equ	$2109
BG4SC		equ	$210A
BG12NBA		equ	$210B	; Character Data Address in VRAM
BG34NBA		equ	$210C
BG1HOFS		equ	$210D	; H/V Scroll Value
BG1VOFS		equ	$210E
BG2HOFS		equ	$210F
BG2VOFS		equ	$2110
BG3HOFS		equ	$2111
BG3VOFS		equ	$2112
BG4HOFS		equ	$2113
BG4VOFS		equ	$2114
VMAINC		equ	$2115	; VRAM Port Control
VMADDL		equ	$2116	; VRAM Port Address
VMADDH		equ	$2117
VMDATAL		equ	$2118	; VRAM Port Write Data
VMDATAH		equ	$2119
M7SEL		equ	$211A	; Mode 7 Screen Settings
M7A		equ	$211B	; Mode 7 Transformation
M7B		equ	$211C
M7C		equ	$211D
M7D		equ	$211E
M7X		equ	$211F
M7Y		equ	$2120
CGADD		equ	$2121	; CGRAM Port Address
CGDATA		equ	$2122	; CGRAM Port Data
W12SEL		equ	$2123	; Window Mask Settings
W34SEL		equ	$2124
WOBJSEL		equ	$2125
WH0		equ	$2126	; Window Position
WH1		equ	$2127
WH2		equ	$2128
WH3		equ	$2129
WBGLOG		equ	$212A	; Window Mask
WOBJLOG		equ	$212B
TM		equ	$212C	; Screen Addition/Subtraction Main Screen
TS		equ	$212D	; Screen Addition/Subtraction Subordinate Screen
TMW		equ	$212E	; Window Mask Main Screen
TSW		equ	$212F	; Window Mask Subordinate Screen
CGWSEL		equ	$2130	; Fixed Color Addition / Screen Addition
CGADSUB		equ	$2131	; Screen Addition/Subtraction Control
COLDATA		equ	$2132	; Screen Addition/Subtraction Fixed Color Data
SETINI		equ	$2133	; Interlace/Syncronization Control
MPYL		equ	$2134	; Multiplication Result
MPYM		equ	$2135
MPYH		equ	$2136
SLHV		equ	$2137	; Software Latch for H/V Counter
OAMDATAREAD	equ	$2138	; OAM Port Read Data
VMDATALREAD	equ	$2139	; VRAM Port Read Data
VMDATAHREAD	equ	$213A
CGDATAREAD	equ	$213B	; CGRAM Port Read Data
OPHCT		equ	$213C	; Latched H/V Counter
OPVCT		equ	$213D
STAT77		equ	$213E	; PPU Status & Version
STAT78		equ	$213F
APUIO0		equ	$2140	; Audio Processor Communication Port
APUIO1		equ	$2141
APUIO2		equ	$2142
APUIO3		equ	$2143
WMDATA		equ	$2180	; WRAM Port Data
WMADDL		equ	$2181	; WRAM Port Address
WMADDM		equ	$2182
WMADDH		equ	$2183
NMITIMEN	equ	$4200	; Enable Flag for V-Blank, Timer Interrupt & Joypad Read
WRIO		equ	$4201	; Out Port
WRMPYA		equ	$4202	; Multiplier and Multiplicand for Multiplication
WRMPYB		equ	$4303
WRDIVL		equ	$4204	; Divisor & Dividend for Division
WRDIVH		equ	$4205
WRDIVB		equ	$4206
HTIMEL		equ	$4207	; H-Count Timer Settings
HTIMEH		equ	$4208
VTIMEL		equ	$4209	; V-Count Timer Settings
VTIMEH		equ	$420A
MDMAEN		equ	$420B	; General DMA Trigger
HDMAEN		equ	$420C	; H-DMA Trigger
MEMSEL		equ	$420D	; Memory Speed
RDNMI		equ	$4210	; NMI Flag Status
TIMEUP		equ	$4211	; IRQ (Timer) Flag
HVBJOY		equ	$4212	; H/V Blank Flag & Joypad Ready
RDIO		equ	$4213	; In Port
RDDIVL		equ	$4214	; Quotient for Division
RDDIVH		equ	$4215
RDMPYL		equ	$4216	; Product for Multiplication / Quotient for Division
RDMPYH		equ	$4217
JOY1L		equ	$4218	; Joypad Data
JOY1H		equ	$4219
JOY2L		equ	$421A
JOY2H		equ	$421B
JOY3L		equ	$421C
JOY3H		equ	$421D
JOY4L		equ	$421E
JOY4H		equ	$421F
DMAP0		equ	$4300	; DMA 0 Parameter
BBAD0		equ	$4301	; DMA 0 B-Bus Address
A1T0L		equ	$4302	; DMA 0 A1 Table Address
A1T0H		equ	$4303
A1B0		equ	$4304
DAS0L		equ	$4305	; DMA 0 Length
DAS0H		equ	$4306
DASB0		equ	$4307
A2A0L		equ	$4308	; DMA 0 A2 Table Address
A2A0H		equ	$4309
NTRL0		equ	$430A	; DMA 0 H-DMA Number of Lines
joy_data	equ	$10	; ..$11
cursor          equ     $12     ; ..$13
input_value	equ	$14	; ..$17
input_digit	equ	$18	; ..$19
input_location	equ	$1a	; ..$1b
input_length	equ	$1c	; ..$1d
last_write	equ	$1e	; ..$25
last_digit	equ	$26	; ..$2d
current_field	equ	$2e	; ..$2f
STACK_TOP	equ	$01FF
text		equ	$1000	; .. $13FF
max_field	equ	3

;--------------------------------------------------------------[start]------

        int     all=do_rti
	int	res=START

START   sei
        phk                     ;Get current bank, store on stack
        plb                     ;Get value from stack & make it current bank
        clc                     ;Clear Carry Bit
        xce                     ;Native 16bit mode (no 6502 emulation)
	rep	#$30
	lda.w	#$0000		; Direct page is 0
	tcd
	ldx.w	#STACK_TOP
	txs

	ldx.w	#$0100
-       stz     $00,x
	dex
        bne     -

	jsr	init_snes
	jsr	init

	ldx.w	#$0000
	lda	write_field_location,x
	sta	input_location
	lda	write_field_length,x
	sta	input_length

	jsr	get_input_value
	jsr	show_input_value

main	sep	#$20
	jsr	read
-	lda	HVBJOY		; Wait for joypad not ready
	and	#$01		; (to make sure we're getting fresh data)
	beq	-		; (else we might have already read this press)

-	lda     HVBJOY		; Wait for joypad ready
	and	#$01
	bne	-

	rep	#$30

	lda     JOY1L		; Read joypad
	bit	joy_data	; Has previous press been released?
	bne	main		; No

	sta	joy_data

	ldx.w	#66
	jsr	outhex4
	ldy.w	#$0004
	jsr	update

	bit.w	#$0800		; Up?
	beq	j1
	jmp	do_up

j1	bit.w	#$0400		; Down?
	beq	j2
	jmp	do_down

j2	bit.w	#$0080		; A?
	beq	j3
	jmp	do_a

j3	bit.w	#$0020		; TL?
	beq	j4
	jmp	do_tl

j4	bit.w	#$0010		; TR?
	beq	j5
	jmp	do_tr

j5	bit.w	#$0200		; L?
	beq	j6
	jmp	do_l

j6	bit.w	#$0100		; R?
	beq	j7
	jmp	do_r

j7      bra     main



do_up	ldx	current_field
	lda	last_write,x
	jsr	put_input_value
	ldy.w	#$FFFF
	sty	input_digit
	jsr	show_input_value

	dex
	dex
	bpl	do_updown
	ldx.w	#max_field*2
	bra	do_updown

do_down	ldx	current_field
	lda	last_write,x
	jsr	put_input_value
	ldy.w	#$FFFF
	sty	input_digit
	jsr	show_input_value

	inx
	inx
	cpx.w	#max_field*2+2
	bne	do_updown
	ldx.w	#$0000

do_updown
	stx	current_field

	lda	write_field_length,x
	sta	input_length
	lda	write_field_location,x
	sta	input_location
	lda	last_digit,x
	sta	input_digit

	lda	last_write,x
	jsr	put_input_value

	jsr	show_input_value
	jmp	main

do_a	lda	current_field
	lsr
	tax
	jsr	get_input_value

	sep	#$20
	sta	APUIO0,X
	rep	#$30

	ldx	current_field
	sta	last_write,x
	lda	input_digit
	sta	last_digit,x
	jmp	main

do_tl	jsr	input_decrease
	jmp	main

do_tr	jsr	input_increase
	jmp	main

do_l	jsr	input_left
	jmp	main

do_r	jsr	input_right
	jmp	main

;--------------------------------------------------------------
;
; Read the APU registers and display them
;

read	php
	rep	#$30
	phx
	phy
	pha

	sep	#$20
	ldy.w	#$0000
-	lda	APUIO0,y

	phy

	rep	#$30
	pha
	tya
	asl
	tay
	pla
	sep	#$20

	ldx	read_field_location,y
	jsr	outhex2
	ldy.w	#$0002
	jsr	update

	ply

	iny
	cpy.w	#$0004
	bne	-

	rep	#$30
	pla
	ply
	plx
	plp
	rts

;
; Hex input routines
;

input_left
	php
	rep	#$30
	pha

	lda	input_digit
	cmp.w	#$0000
	beq	input_left1

	dec
	sta	input_digit

	jsr	show_input_value

input_left1
	pla
	plp
	rts	

input_right
	php
	rep	#$30
	pha

	lda	input_digit
	inc
	cmp.w	input_length
	beq	input_right1

	sta	input_digit

	jsr	show_input_value

input_right1
	pla
	plp
	rts


input_decrease
	php
	rep	#$30
	phx
	pha

	sep	#$20
	ldx	input_digit
	lda	input_value,x
	dec
	and	#$0f
	sta	input_value,x

	jsr	show_input_value

	rep	#$30
	pla
	plx
	plp
	rts

input_increase
	php
	rep	#$30
	phx
	pha

	sep	#$20
	ldx	input_digit
	lda	input_value,x
	inc
	and	#$0f
	sta	input_value,x

	jsr	show_input_value

	rep	#$30
	pla
	plx
	plp
	rts

put_input_value
	php
	rep	#$30
	phx
	pha
	sep	#$20

	ldx	input_length
	cpx.w	#$0004
	bne	put_input_value2

	xba

put_input_value2
	pha
	and	#$0f
	sta	input_value+1
	pla

	cpx.w	#$0001
	beq	put_input_value1

	lsr
	lsr
	lsr
	lsr	
	and	#$0f
	sta	input_value+0

	cpx.w	#$0002
	beq	put_input_value1

	rep	#$30
	pla
	pha
	sep	#$20

	pha
	and	#$0f
	sta	input_value+3
	pla

	lsr
	lsr
	lsr
	lsr
	and	#$0f
	sta	input_value+2

put_input_value1
	rep	#$30
	pla
	pha
	sep	#$20
	xba


	rep	#$30
	pla
	plx
	plp
	rts

get_input_value
	php
	rep	#$30
	phx
	sep	#$20

	ldx	input_length

	lda	input_value+0
	cpx.w	#$0001
	beq	get_input_value1

	asl
	asl
	asl
	asl
	ora	input_value+1

	cpx.w	#$0002
	beq	get_input_value1

	xba
	lda	input_value+2
	asl
	asl
	asl
	asl
	ora	input_value+3

get_input_value1
	plx
	plp
	rts

show_input_value
	php	
	rep	#$30
	phx
	phy
	pha

	ldx	input_location
	txa
	clc
	adc	input_digit
	sta	cursor

	jsr	get_input_value
	ldy	input_length
	jsr	outhex
	jsr	update

	pla
	ply
	plx
	plp
	rts


wait_vbl
	php
	sep	#$20

-	lda	RDNMI		; Wait for the beginning of the next period
	bit	#$80
	beq	-

	plp
	rts

update	php
	rep	#$30
	phx
	phy
	pha

	jsr	wait_vbl

	txa
	ora	#$1000
	sta	VMADDL

	sep	#$20
-	lda	text,x
	and	#$3f
	sta	VMDATAL

	lda	#$00
	cpx	cursor
	bne	update1
	lda	#$04		; Use palette 1

update1	sta	VMDATAH
	inx
	dey
	bne	-

	rep	#$30
	pla
	ply
	plx
	plp
	rts

hex     DCB     "0123456789ABCDEF"

outhex1	php
	rep	#$30
	phy
	pha

	and.w	#$000f
	tay
	sep	#$20
	lda	hex,y
	sta	text,x
	rep	#$30

	pla
	ply
	plp
	rts

outhex2	php
	rep	#$30
	phx

	pha
	lsr
	lsr
	lsr
	lsr
	jsr	outhex1
	inx
	pla

	jsr	outhex1

	plx
	plp
	rts

outhex4	php
	rep	#$30
	phx
	pha

	xba
	jsr	outhex2
	inx
	inx

	xba
	jsr	outhex2

	pla
	plx
	plp
	rts

outhex	cpy.w	#$0001
	bne	oh1
	jsr	outhex1
	bra	oh3

oh1	cpy.w	#$0002
	bne	oh2
	jsr	outhex2
	bra	oh3

oh2	jsr	outhex4
oh3	rts

sdebug	php
	rep	#$30
	phx
	phy
	pha

	ldx.w	#$0284

	xba
	lsr
	lsr
	lsr
	lsr
	and.w	#$000f
	tay
	sep	#$20
	lda	hex,y
	sta	text,x
	inx
	rep	#$30

	pla
	pha
	xba
	and.w	#$000f
	tay
	sep	#$20
	lda	hex,y
	sta	text,x
	inx
	rep	#$30

	pla
	pha
	lsr
	lsr
	lsr
	lsr
	and.w	#$000f
	tay
	sep	#$20
	lda	hex,y
	sta	text,x
	inx
	rep	#$30

	pla
	pha
	and.w	#$000f
	tay
	sep	#$20
	lda	hex,y
	sta	text,x
	rep	#$30

	ldx.w	#$0284
	ldy.w	#$0004
	jsr	update

	pla
	ply
	plx
	plp
	rts

init	php
	rep     #$30		; X,Y,A fixed -> 16 bit mode
	sep     #$20		; Accumulator ->  8 bit mode

	lda     #$10            ; Screen map data @ VRAM location $1000
	sta     BG1SC		; Plane 0 Map location register
	lda     #$02            ; Plane 0 Tile graphics @ $2000
	sta     BG12NBA		; Plane 0 Tile graphics register
	lda     #$00            ; MODE 0 value
	sta     BGMODE		; Graphics mode register
	lda     #$01            ; Plane 0 value (bit one)
	sta     TM		; Plane enable register

	lda	#$00
	sta	CGADD
	ldx.w	#$0100
-	stz	CGDATA
	stz	CGDATA
	dex
	bne	-

	lda     #$00		; Start with Palette 0, Color 0
	sta     CGADD

	lda     #$46		; Palette 0, Color 0 = Blue (Background)
	sta     CGDATA
	lda     #$60
	sta     CGDATA

	lda     #$ff            ; Palette 0, Color 1 = White
	sta     CGDATA
	sta     CGDATA

	stz	CGDATA		; Palette 0, Color 2 = Black (Unused)
	stz	CGDATA

	stz	CGDATA		; Palette 0, Color 3 = Black (Unused)
	stz	CGDATA

	stz	CGDATA		; Palette 1, Color 0 = Black (Unavailable)
	stz	CGDATA

	lda	#$06		; Palette 1, Color 0 = Green Blue
	sta	CGDATA
	lda	#$63
	sta	CGDATA


	ldx.w   #$2000          ; Assign VRAM location $2000 to $2116/7
	stx     VMADDL		; writing to $2118/9 will store data here!
	ldy.w	#$0000
-	lda	charset,y	; Get CHARACTER SET DATA (Font DATA)
	sta     VMDATAL		; store bitplane 1
	stz     VMDATAH		; clear bitplane 2 and increase VRAM address
	iny
	cpy.w   #$0200		; Transfer $0200 bytes
	bne     -

	ldx.w	#0000		; Move the initial text screen to the writable area
-	lda	initial_text,x
	sta	text,x
	inx
	cpx.w	#$0400
	bne	-

	cli                     ; Clear interrupt bit
	lda     #$01
	sta     NMITIMEN	; Enable Joypad and VBlank

	ldx.w	#$0000
	ldy.w	#$0400
	jsr	update

        lda     #$0f            ; Screen Enabled, Brightness Full
	sta     INIDISP

	plp
 	rts

init_snes
	php
	rep	#$30

	SEP	#$20		; A is 8 bit

	LDA	#$8F		; screen off, full brightness
	STA	INIDISP		; brightness + screen enable register
	LDA	#$00
	STA	OBJSEL		; Sprite register (size + address in VRAM)
	LDA	#$00
	STA	OAMADDL		; Sprite registers (address of sprite memory [OAM])
	STA	OAMADDH
	LDA	#$00		; Mode 0
	STA	BGMODE		; Graphic mode register
	LDA	#$00		; no planes, no mosaic
	STA	MOSAIC		; Mosaic register
	LDA	#$00
	STA	BG1SC		; Plane 0 map VRAM location
	LDA	#$00
	STA	BG2SC		; Plane 1 map VRAM location
	LDA	#$00
	STA	BG3SC		; Plane 2 map VRAM location
	LDA	#$00
	STA	BG4SC		; Plane 3 map VRAM location
	LDA	#$00
	STA	BG12NBA		; Plane 0+1 Tile data location
	LDA	#$00
	STA	BG34NBA		; Plane 2+3 Tile data location
	LDA	#$00
	STA	BG1HOFS		; Plane 0 scroll x (first 8 bits)
	STA	BG1HOFS		; Plane 0 scroll x (last 3 bits) #$0 - #$07ff
	STA	BG1VOFS		; Plane 0 scroll y (first 8 bits)
	STA	BG1VOFS		; Plane 0 scroll y (last 3 bits) #$0 - #$07ff
	STA	BG2HOFS		; Plane 1 scroll x (first 8 bits)
	STA	BG2HOFS		; Plane 1 scroll x (last 3 bits) #$0 - #$07ff
	STA	BG2VOFS		; Plane 1 scroll y (first 8 bits)
	STA	BG2VOFS		; Plane 1 scroll y (last 3 bits) #$0 - #$07ff
	STA	BG3HOFS		; Plane 2 scroll x (first 8 bits)
	STA	BG3HOFS		; Plane 2 scroll x (last 3 bits) #$0 - #$07ff
	STA	BG3VOFS		; Plane 2 scroll y (first 8 bits)
	STA	BG3VOFS		; Plane 2 scroll y (last 3 bits) #$0 - #$07ff
	STA	BG4HOFS		; Plane 3 scroll x (first 8 bits)
	STA	BG4HOFS		; Plane 3 scroll x (last 3 bits) #$0 - #$07ff
	STA	BG4VOFS		; Plane 3 scroll y (first 8 bits)
	STA	BG4VOFS		; Plane 3 scroll y (last 3 bits) #$0 - #$07ff
	LDA	#$80		; increase VRAM address after writing to $2119
	STA	VMAINC		; VRAM address increment register
	LDA	#$00
	STA	VMADDL		; VRAM address low
	STA	VMADDH		; VRAM address high
	STA	M7SEL		; Initial Mode 7 setting register
	STA	M7A		; Mode 7 matrix parameter A register (low)
	LDA	#$01
	STA	M7A		; Mode 7 matrix parameter A register (high)
	LDA	#$00
	STA	M7B		; Mode 7 matrix parameter B register (low)
	STA	M7B		; Mode 7 matrix parameter B register (high)
	STA	M7C		; Mode 7 matrix parameter C register (low)
	STA	M7C		; Mode 7 matrix parameter C register (high)
	STA	M7D		; Mode 7 matrix parameter D register (low)
	LDA	#$01
	STA	M7D		; Mode 7 matrix parameter D register (high)
	LDA	#$00
	STA	M7X		; Mode 7 center position X register (low)
	STA	M7X		; Mode 7 center position X register (high)
	STA	M7Y		; Mode 7 center position Y register (low)
	STA	M7Y		; Mode 7 center position Y register (high)
	STA	CGADD		; Color number register ($0-ff)
	STA	W12SEL		; BG1 & BG2 Window mask setting register
	STA	W34SEL		; BG3 & BG4 Window mask setting register
	STA	WOBJSEL		; OBJ & Color Window mask setting register
	STA	WH0		; Window 1 left position register
	STA	WH1		; Window 2 left position register
	STA	WH2		; Window 3 left position register
	STA	WH3		; Window 4 left position register
	STA	WBGLOG		; BG1, BG2, BG3, BG4 Window Logic register
	STA	WOBJLOG		; OBJ, Color Window Logic Register (or,and,xor,xnor)
	LDA	#$01
	STA	TM		; Main Screen designation (planes, sprites enable)
	LDA	#$00
	STA	TS		; Sub Screen designation
	LDA	#$00
	STA	TMW		; Window mask for Main Screen
	STA	TSW		; Window mask for Sub Screen
	LDA	#$30
	STA	CGWSEL		; Color addition & screen addition init setting
	LDA	#$00
	STA	CGADSUB		; Add/Sub sub designation for screen, sprite, color
	LDA	#$E0
	STA	COLDATA		; color data for addition/subtraction
	LDA	#$00
	STA	SETINI		; Screen setting (interlace x,y/enable SFX data)
	LDA	#$00
	STA	NMITIMEN	; Enable V-blank, interrupt, Joypad register
	LDA	#$FF
	STA	WRIO		; Programmable I/O port
	LDA	#$00
	STA	WRMPYA		; Multiplicand A
	STA	WRMPYB		; Multiplier B
	STA	WRDIVL		; Multiplier C
	STA	WRDIVH		; Multiplicand C
	STA	WRDIVB		; Divisor B
	STA	HTIMEL		; Horizontal Count Timer
	STA	HTIMEH		; Horizontal Count Timer MSB (most significant bit)
	STA	VTIMEL		; Vertical Count Timer
	STA	VTIMEH		; Vertical Count Timer MSB
	STA	MDMAEN		; General DMA enable (bits 0-7)
	STA	HDMAEN		; Horizontal DMA (HDMA) enable (bits 0-7)
	STA	MEMSEL		; Access cycle designation (slow/fast rom)

	plp
	rts

;
; Not all chars are defined. Unused char will output a solid white box.
;
charset 
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'@' 00
        DCB     $00,$3c,$66,$7e,$66,$66,$66,$00 ;'A' 01
        DCB     $00,$7c,$66,$7c,$66,$66,$7c,$00 ;'B' 02
        DCB     $00,$3c,$66,$60,$60,$66,$3c,$00 ;'C' 03
        DCB     $00,$78,$6c,$66,$66,$6c,$78,$00 ;'D' 04
        DCB     $00,$7e,$60,$78,$60,$60,$7e,$00 ;'E' 05
        DCB     $00,$7e,$60,$78,$60,$60,$60,$00 ;'F' 06
        DCB     $00,$3c,$66,$60,$6e,$66,$3c,$00 ;'G' 07
        DCB     $00,$66,$66,$7e,$66,$66,$66,$00 ;'H' 08
        DCB     $00,$3c,$18,$18,$18,$18,$3c,$00 ;'I' 09
        DCB     $00,$1e,$0c,$0c,$0c,$6c,$38,$00 ;'J' 0a
        DCB     $00,$6c,$78,$70,$78,$6c,$66,$00 ;'K' 0b
        DCB     $00,$60,$60,$60,$60,$60,$7e,$00 ;'L' 0c
        DCB     $00,$63,$77,$7f,$6b,$63,$63,$00 ;'M' 0d
        DCB     $00,$66,$76,$7e,$7e,$6e,$66,$00 ;'N' 0e
        DCB     $00,$3c,$66,$66,$66,$66,$3c,$00 ;'O' 0f
        DCB     $00,$7c,$66,$66,$7c,$60,$60,$00 ;'P' 10
        DCB     $00,$3c,$66,$66,$66,$3c,$0e,$00 ;'Q' 11
        DCB     $00,$7c,$66,$66,$7c,$6c,$66,$00 ;'R' 12
        DCB     $00,$3e,$60,$3c,$06,$66,$3c,$00 ;'S' 13
        DCB     $00,$7e,$18,$18,$18,$18,$18,$00 ;'T' 14
        DCB     $00,$66,$66,$66,$66,$66,$3c,$00 ;'U' 15
        DCB     $00,$66,$66,$66,$66,$3c,$18,$00 ;'V' 16
        DCB     $00,$63,$63,$6b,$7f,$77,$63,$00 ;'W' 17
        DCB     $00,$66,$3c,$18,$3c,$66,$66,$00 ;'X' 18
        DCB     $00,$66,$66,$3c,$18,$18,$18,$00 ;'Y' 19
        DCB     $00,$7e,$0c,$18,$30,$60,$7e,$00 ;'Z' 1a
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'[' 1b
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'\' 1c
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;']' 1d
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'^' 1e
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'_' 1f
        DCB     $00,$00,$00,$00,$00,$00,$00,$00 ;' ' 20
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'!' 21
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'"' 22
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'#' 23
        DCB     $10,$3c,$50,$38,$14,$78,$10,$00 ;'$' 24
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'%' 25
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'&' 26
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;''' 27
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'(' 28
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;')' 29
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'*' 2a
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'+' 2b
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;',' 2c
        DCB     $00,$00,$00,$FF,$00,$00,$00,$00 ;'-' 2d
        DCB     $00,$00,$00,$00,$00,$18,$18,$00 ;'.' 2e
        DCB     $00,$04,$08,$10,$20,$40,$00,$00 ;'/' 2f
        DCB     $00,$3c,$66,$6e,$76,$66,$3c,$00 ;'0' 30
        DCB     $00,$18,$38,$18,$18,$18,$7e,$00 ;'1' 31
        DCB     $00,$7c,$06,$0c,$30,$60,$7e,$00 ;'2' 32
        DCB     $00,$7e,$06,$1c,$06,$66,$3c,$00 ;'3' 33
        DCB     $00,$0e,$1e,$36,$7f,$06,$06,$00 ;'4' 34
        DCB     $00,$7e,$60,$7c,$06,$66,$3c,$00 ;'5' 35
        DCB     $00,$3e,$60,$7c,$66,$66,$3c,$00 ;'6' 36
        DCB     $00,$7e,$06,$0c,$0c,$0c,$0c,$00 ;'7' 37
        DCB     $00,$3c,$66,$3c,$66,$66,$3c,$00 ;'8' 38
        DCB     $00,$3c,$66,$3e,$06,$66,$3c,$00 ;'9' 39
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;':' 3a
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;';' 3b
        DCB     $00,$04,$08,$10,$08,$04,$00,$00 ;'<' 3c
        DCB     $00,$00,$3C,$00,$3C,$00,$00,$00 ;'=' 3d
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'>' 3e
        DCB     $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;'?' 3f

; Locations of read data on screen
read_field_location
	dcw	7*32+16, 8*32+16, 9*32+16, 10*32+16

; Locations and lengths of write data on screen
write_field_location
	dcw	7*32+22, 8*32+22, 9*32+22, 10*32+22
write_field_length
	dcw	2, 2, 2, 2

initial_text
        DCB     "                                " ;  0
        DCB     "                                " ;  1
        DCB     "                                " ;  2
        DCB     "                                " ;  3
        DCB     "      SPC EXPLORER 2.0 '95      " ;  4
        DCB     "                                " ;  5
        DCB     "      REGISTER READ  WRITE      " ;  6
        DCB     "        $2140 = 00 <- 00        " ;  7
        DCB     "        $2141 = 00 <- 00        " ;  8
        DCB     "        $2142 = 00 <- 00        " ;  9
        DCB     "        $2143 = 00 <- 00        " ; 10
        DCB     "                                " ; 11
        DCB     "                                " ; 12
        DCB     "                                " ; 13
        DCB     "                                " ; 14
        DCB     "                                " ; 15
        DCB     "                                " ; 16
        DCB     "                                " ; 17
        DCB     "                                " ; 18
        DCB     "                                " ; 19
        DCB     "                                " ; 20
        DCB     "                                " ; 21
        DCB     "  A BUTTO................WRITE  " ; 22
        DCB     "  UP/DOWN.........APU REGISTER  " ; 23
        DCB     "  PAD LEFT/RIGHT..SELECT DIGIT  " ; 24
        DCB     "  TOP LEFT......DECREASE DIGIT  " ; 25
        DCB     "  TOP RIGHT.....INCREASE DIGIT  " ; 26
        DCB     "                                " ; 27
        DCB     "                                " ; 28
        DCB     "                                " ; 29
        DCB     "                                " ; 30
        DCB     "                                " ; 31
; End
