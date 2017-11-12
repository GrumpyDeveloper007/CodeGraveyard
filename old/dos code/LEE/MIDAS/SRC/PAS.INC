;*	PAS.INC
;*
;* Include files for Pro Audio Spectrum Sound Device
;*
;* $Id: pas.inc,v 1.3 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*

; This file includes necessary pieces from the PAS SDK include files


DEFAULT_BASE	EQU	00388h		;; default base I/O address
ALT_BASE_1	EQU	00384h		;; first alternate address
ALT_BASE_2	EQU	0038Ch		;; second alternate address
ALT_BASE_3	EQU	00288h		;; third alternate address
USE_ACTIVE_ADDR EQU	00000h		;; uses what is currently active

pAUDIOMIXR	EQU	0078Bh		;; Parallel interface Audio Mixer Reg
AUDIOMIXR	EQU	00B88h		;; Audio Mixer Control Register
AUDIOFILT	EQU	00B8Ah		;; Audio Filter Control Register
INTRCTLRST	EQU	00B89h		;; Interrupt Control Status Register
INTRCTLR	EQU	00B8Bh		;; Interrupt Control Register write
INTRCTLRRB	EQU	00B8Bh		;; Interrupt Control Register read back
PCMDATA 	EQU	00F88h		;; PCM data I/O register (low byte)
PCMDATAH	EQU	00F89h		;; PCM data I/O register (high byte)
CROSSCHANNEL	EQU	00F8Ah		;; Cross Channel Register
SAMPLERATE	EQU	01388h		;; (t0) Sample Rate Timer Register
SAMPLECNT	EQU	01389h		;; (t1) Sample Count Register
SPKRTMR 	EQU	0138Ah		;; (t2) Local Speaker Timer Address
TMRCTLR 	EQU	0138Bh		;; Local Timer Control Register
MDIRQVECT	EQU	01788H		;; MIDI-0 IRQ Vector Register
MDSYSCTLR	EQU	01789H		;; MIDI-1 System Control Register
MDSYSSTAT	EQU	0178AH		;; MIDI-2 IRQ Status Register
MDIRQCLR	EQU	0178BH		;; MIDI-3 IRQ Clear Register
MDGROUP4	EQU	01B88H		;; MIDI-4 Group #1 Register (MDGROUP1)
MDGROUP5	EQU	01B89H		;; MIDI-5 Group #2 Register (MDGROUP2)
MDGROUP6	EQU	01B8AH		;; MIDI-6 Group #3 Register (MDGROUP3)
MDGROUP7	EQU	01B8BH		;; MIDI-7 Group #4 Register (MDGROUP4)

;
; mixer select
;
OUTPUTMIXER	equ	00h		;; output mixer H/W select
INPUTMIXER	equ	40h		;; input mixer select
DEFMIXER	equ	-1		;; use last mixer selected
MIXERMAX	equ	1fh		;; maximum mixer setting

MVVOLUMEMAX	equ	3fh		;; MVA508 maximum mixer setting
NSVOLUMEMAX	equ	28h		;; National maximum mixer setting

EQUALIZERMAX	equ	0ch		;; maximum equalizer setting
EQUALIZERMID	equ	06h		;; maximum mid setting

;
;	Filter register bits
;
fFIdatabits	equ	00011111B	;; filter select and decode field bits
fFImutebits	equ	00100000B	;; filter mute field bits
fFIpcmbits	equ	11000000B	;; filter sample rate field bits
bFImute 	equ	00100000B	;; filter mute bit
bFIsrate	equ	01000000B	;; filter sample rate timer mask
bFIsbuff	equ	10000000B	;; filter sample buffer counter mask
FILTERMAX	equ	6		;; six possible settings

;
;	Cross Channel Bit definitions
;
fCCcrossbits	EQU	00001111B	;; cross channel bit field
fCCpcmbits	EQU	11110000B	;; pcm/dma control bit field
bCCr2r		EQU	00000001B	;; CROSSCHANNEL Right to Right
bCCl2r		EQU	00000010B	;; CROSSCHANNEL Left  to Right
bCCr2l		EQU	00000100B	;; CROSSCHANNEL Right to Right
bCCl2l		EQU	00001000B	;; CROSSCHANNEL Left  to Left
bCCdac		EQU	00010000B	;; DAC/ADC Control
bCCmono 	EQU	00100000B	;; PCM Monaural Enable
bCCenapcm	EQU	01000000B	;; Enable PCM state machine
bCCdrq		EQU	10000000B	;; Enable DRQ bit

;
;	Interrupt Control Register Bits
;
fICintmaskbits	EQU	00011111B	;; interrupt mask field bits
fICrevbits	EQU	11100000B	;; revision mask field bits
fICidbits	EQU	11100000B	;; Board revision ID field bits
bICleftfm	EQU	00000001B	;; Left FM interrupt enable
bICritfm	EQU	00000010B	;; Right FM interrupt enable
bICsamprate	EQU	00000100B	;; Sample Rate timer interrupt enable
bICsampbuff	EQU	00001000B	;; Sample buffer timer interrupt enable
bICmidi 	EQU	00010000B	;; MIDI interrupt enable
   fICrevshr	EQU	5		;; rotate rev bits to lsb

;
;	Interrupt Status Register Bits
;
fISints 	EQU	00011111B	;; Interrupt bit field
bISleftfm	EQU	00000001B	;; Left FM interrupt active
bISritfm	EQU	00000010B	;; Right FM interrupt active
bISsamprate	EQU	00000100B	;; Sample Rate timer interrupt active
bISsampbuff	EQU	00001000B	;; Sample buffer timer interrupt active
bISmidi 	EQU	00010000B	;; MIDI interrupt active
bISPCMlr	EQU	00100000B	;; PCM left/right active
bISActive	EQU	01000000B	;; Hardware is active (not in reset)
bISClip 	EQU	10000000B	;; Sample Clipping has occured

;
;	cross channel channel #s
;
RIGHT2RIGHT	equ	00h		;; right to right
LEFT2RIGHT	equ	01h		;; left  to right
RIGHT2LEFT	equ	02h		;; right to left
LEFT2LEFT	equ	03h		;; left  to left

;
; left/right mixer channel selection
;

;	left channel values

L_FM		equ	01h
L_IMIXER	equ	02h
L_EXT		equ	03h
L_INT		equ	04h
L_MIC		equ	05h
L_PCM		equ	06h
L_SPEAKER	equ	07h
L_FREE		equ	00h
L_SBDAC 	equ	00h

;	right channel values

R_FM		equ	08h
R_IMIXER	equ	09h
R_EXT		equ	0Ah
R_INT		equ	0Bh
R_MIC		equ	0Ch
R_PCM		equ	0Dh
R_SPEAKER	equ	0Eh
R_FREE		equ	0Fh
R_SBDAC 	equ	0Fh

;	Mixer register bits

fMImixerbits	EQU	00010111B	;; mixer control bit fields
fMIspkrbits	EQU	01000000B	;; speaker integrator field bits
bMIdata 	EQU	00000001B	;; data bit
bMIclock	EQU	00000010B	;; clock strobe
bMImistrb	EQU	00000100B	;; mixer output strobe
bMIna1		EQU	00001000B	;; not used
bMIvol		EQU	00010000B	;; total volume enabled
bMIna2		EQU	00100000B	;; not used
bMIspkrint	EQU	01000000B	;; speaker integrator
bMImonofm	EQU	10000000B	;; make both FMs mono

bMIfmreset	EQU	bMIdata 	;; OPL3 FM chip reset
bMIdacreset	EQU	bMIclock	;; CODEC reset
bMIsbreset	EQU	bMImistrb	;; SB microprocessor reset
bMI508reset	EQU	bMIvol		;; MVA508 reset

;	volume control channel #s

VOLMUTE 	equ	40h		;; MUTE button
VOLLOUDENH	equ	41h		;; LOUDNESS and ENHANCED STEREO switch
VOLBASS 	equ	42h		;; BASS level setting
VOLTREBLE	equ	43h		;; TREBLE level setting
VOLLEFT 	equ	44h		;; MASTER LEFT LEVEL settting
VOLRIGHT	equ	45h		;; MASTER RIGHT LEVEL settting
VOLMODE 	equ	46h		;; Model Select Left/Stereo/Right

bVOLEbass	equ	0001b		;; enhanced bass bit
bVOLEstereo	equ	0010b		;; enhanced stereo bit

;	output control

pmADDRSELECT	equ	80h		;; Parallel mixer addr select
pmDATASELECT	equ	00h		;; Parallel mixer data select

;	mixer channel programming selection

pmCHANNELLR	equ	00h		;; Left/Right channel select
pmCHANNELL	equ	20h		;; Left  channel only select
pmCHANNELR	equ	40h		;; Right channel only select

;	device select

pmMIXERSELECT	equ	10h		;; Parallel Mixer device select
pmVOLUMESELECT	equ	00h		;; Parallel Volume device select

;	Volume Device selects

pmVOLUMEA	equ	01h		;; Left/Right channel select
pmVOLUMEB	equ	02h		;; Left/Right channel select
pmVOLUMEBASS	equ	03h		;; Left/Right channel select
pmVOLUMETREB	equ	04h		;; Left/Right channel select
pmVOLUMEMODE	equ	05h		;; Left/Right channel select

;	mixer selection

pmOUTPUTMIXER	equ	00h		;; Mixer-A selection
pmINPUTMIXER	equ	20h		;; Mixer-B selection

;	mixer channel swap

pmCHSWAP	equ	40h		;; Mixer channel reroute
					;;
;	int 2F application ID codes

INT2FCODE1	equ	0BCH		;; Bryan's initials

;	int 2F ID (func 0) return register values

INT2FREGBX	equ	6D00h		;; 'm '
INT2FREGCX	equ	0076h		;; ' v'
INT2FREGDX	equ	2020h		;; UPPERCASE XOR MASK

; hardware specific equates for the MV101 (digital ASIC)

MASTERADDRP	equ	09a01h		;; Master Address Pointer    (w)
MIDIPRESCALE	equ	01788h		;; MIDI prescale	     (r/w)
MIDITIMER	equ	01789h		;; MIDI Timer		     (r/w)
MIDIDATA	equ	0178ah		;; MIDI Data		     (r/w)
MIDICONTROL	equ	0178bh		;; MIDI Control 	     (r/w)
MIDISTATUS	equ	01b88h		;; MIDI Status		     (r/w)
MIDIFIFOS	equ	01b89h		;; MIDI Fifo Status	     (r/w)
MIDICOMPARE	equ	01b8ah		;; MIDI Compare Time	     (r/w)
MIDITEST	equ	01b8bh		;; MIDI Test		     (w)
MASTERCHIPR	equ	0ff88h		;; Master Chip Rev	     (r)
SLAVECHIPR	equ	0ef88h		;; Slave Chip Rev	     (r)
ENHANCEDSCSI	equ	07f89h		;; Enhanced SCSI detect port
SYSCONFIG1	equ	08388h		;; System Config 1	     (r/w)
SYSCONFIG2	equ	08389h		;; System Config 2	     (r/w)
SYSCONFIG3	equ	0838ah		;; System Config 3	     (r/w)
SYSCONFIG4	equ	0838bh		;; System Config 4	     (r/w)
IOCONFIG1	equ	0f388h		;; I/O Config 1 	     (r/w)
IOCONFIG2	equ	0f389h		;; I/O Config 2 	     (r/w)
IOCONFIG3	equ	0f38ah		;; I/O Config 3 	     (r/w)
IOCONFIG4	equ	0f38bh		;; I/O Config 4 	     (r/w)
COMPATREGE	equ	0f788h		;; Compatible Rgister Enable (r/w)
EMULADDRP	equ	0f789h		;; Emulation Address Pointer (r/w)
WAITSTATE	equ	0bf88h		;; Wait State		     (r/w)
PUSHBUTTON	equ	0e388h		;; Push Button (slave)	     (???)
AUXINTSTAT	equ	0e38ah		;; Aux Int Status	     (???)
AUXINTENA	equ	0e38bh		;; Aux Int Enable	     (???)
OVRSMPPRE	equ	0bf8ah		;; Over Sample Prescale      (r/w)
ANALSERD	equ	0bf89h		;; Analog Chip Serial Data   (w)
MASTERMODRD	equ	0ff8bh		;; Master Mode Read	     (r)
SLAVEMODRD	equ	0ef8bh		;; Slave Mode Read	     (r)
INTWATCHDOG	equ	0fb8bh		;; Interrupt Watch Dog	     (???)
MASTERuPDATA	equ	0fb88h		;; Master uP Data	     (???)
MASTERuPCMD	equ	0fb89h		;; Master uP Command/Status  (???)
MASTERuPRST	equ	0fb8ah		;; Master uP Restart	     (???)
SLAVEuPDATA	equ	0eb88h		;; Slave uP Data	     (???)
SLAVEuPCMD	equ	0eb88h		;; Slave uP Command/Status   (???)
SLAVEuPRST	equ	0eb88h		;; Slave uP Restart	     (???)
CDTOCOUNTER	equ	04388h		;; CD-ROM timeout counter    (r/w)
CDTOSTAT	equ	04389h		;; CD-ROM timeout status     (r/w)
LEFTVURD	equ	02388h		;; Left VU Read 	     (r)
RITVURD 	equ	02389h		;; Right VU Read	     (r)

SBRST		equ	00206h		;; SB Reset		     (w)
SBDATA		equ	0020Ah		;; SB Data Read 	     (r)
SBCMD		equ	0020Ch		;; SB CMD Write/Status Read  (r/w)
SBSTAT		equ	0020Eh		;; SB Data Status	     (r)
MPUDATA 	equ	00300h		;; MPU-401 data reg	     (r/w)
MPUCMD		equ	00301h		;; MPU-401 command reg	     (r/w)

; Sys Config 1

bSC1timena	equ	00000001b	;; shadow enable
bSC1pcmemu	equ	00000010b	;; PCM Emulation of PAS1
bSC128mhz	equ	00000100b	;; 28mhz clock divisor
bSC1invcom	equ	00001000b	;; invert COM port interrupt input
bSC1stspea	equ	00010000b	;; stereoize pc speaker
bSC1realsnd	equ	00100000b	;; smart real sound emulatio
bSC1d6		equ	01000000b	;;
bSC1mstrst	equ	10000000b	;; master chip reset

; Sys Config 2

bSC2ovrsmp	equ	00000011b	;; oversampling 0,1,2,4
bSC216bit	equ	00000100b	;; 16 bit audio
bSC212bit	equ	00001000b	;; 12 bit interleaving (d2 must be set too)
bSC2msbinv	equ	00010000b	;; invert MSB from standard method
bSC2slavport	equ	01100000b	;; slave port bits
bSC2vcolock	equ	10000000b	;; VCO locked (Sample Rate Clock Valid)

; Sys Config 3

bSC328mhzfil	equ	00000001b	;; PCM Rate uses 28mhz
bSC31mhzsb	equ	00000010b	;; 1mhz timer for SB sample rate
bSC3vcoinv	equ	00000100b	;; invert VCO output
bSC3bclkinv	equ	00001000b	;; invert BCLK form 16 bit DAC
bSC3lrsync	equ	00010000b	;; 0=L/R, 1 = Sync Pulse
bSC3d5		equ	00100000b	;;
bSC3d6		equ	01000000b	;;
bSC3d7		equ	10000000b	;;

; Sys Config 4

bSC4drqahi	equ	00000001b	;; DRQ from drive active high
bSC4dackahi	equ	00000010b	;; DRQ from drive active high
bSC4intahi	equ	00000100b	;; INT from drive active high
bSC4drqvalid	equ	00001000b	;; DRQ line valid from drive
bSC4comena	equ	00010000b	;; enable COM interrupt
bSC4enascsi	equ	00100000b	;; enable SCSI interrupt
bSC4drqptr	equ	11000000b	;; DRQ timing pointer bits

; I/O Config 1

bIC1ps2ena	equ	00000001b	;; Enable Chip (PS2 only)
bIC1comdcd	equ	00000110b	;; COM port decode pointer
bIC1comint	equ	00111000b	;; COM port interrupt pointer
bIC1joyena	equ	01000000b	;; Enable joystick read
bIC1wporena	equ	10000000b	;; Enable warm boot reset

; I/O Config 2

bIC2dmaptr	equ	00000111b	;; DMA channel select

;;bIC28dmaptr	equ	00001111b	;;  8 bit DMA channel select
;;bIC216dmaptr	equ	11110000b	;; 16 bit DMA channel select

; I/O Config 3

bIC3pcmint	equ	00001111b	;; pcm IRQ channel select
bIC3cdint	equ	11110000b	;; cd  IRQ channel select

; Compatibility Register

cpMPUEmulation	equ	00000001b	;; MPU emuation is on bit
cpSBEmulation	equ	00000010b	;; SB emuation is on bit

; Emulation Address Pointer

epSBptr 	equ	00001111b	;; bit field for SB emulation
epMPUptr	equ	11110000b	;; bit field for MPU emulation

; Slave Mode Read

bSMRDdrvtyp	equ	00000011b	;; drive interface type
bSMRDfmtyp	equ	00000100b	;; FM chip type
bSMRDdactyp	equ	00001000b	;; 16 bit dac (1) or 8 bit dac (0)
bSMRDimidi	equ	00010000b	;; use internal MIDI
bSMRDswrep	equ	10000000b	;; switch is auto repeating

; Master Mode Read

bMMRDatps2	equ	00000001b	;; AT(1) or PS2(0) bus
bMMRDtmremu	equ	00000010b	;; timer emulation enabled
bMMRDmsmd	equ	00000100b	;; master/slave mode
bMMRDslave	equ	00001000b	;; slave power on or device present
bMMRDattim	equ	00010000b	;; xt/at timing
bMMRDmstrev	equ	11100000b	;; master  rev level

; MIDI Control Register

bMCRenatstmp	equ	00000001b	;; MIDI enable time stamp interrupt
bMCRenacmptm	equ	00000010b	;; MIDI enable compare time interrupt
bMCRenafifoi	equ	00000100b	;; MIDI enable FIFO input interrupt
bMCRenafifoo	equ	00001000b	;; MIDI enable FIFO output interrupt
bMCRenafifooh	equ	00010000b	;; MIDI enable FIFO output half int
bMCRrstfifoi	equ	00100000b	;; MIDI reset Input FIFO pointer
bMCRrstfifoo	equ	01000000b	;; MIDI reset Output FIFO pointer
bMCRechoio	equ	10000000b	;; MIDI echo input to output (THRU)

; MIDI Status Register

bMSRtimstamp	equ	00000001b	;; MIDI time stamp interrupt
bMSRcmptime	equ	00000010b	;; MIDI compare time interrupt
bMSRififo	equ	00000100b	;; MIDI input FIFO data avail interrupt
bMSRofifo	equ	00001000b	;; MIDI output FIFO empty interrupt
bMSRofifohalf	equ	00010000b	;; MIDI output FIFO half empty interrupt
bMSRififoovr	equ	00100000b	;; MIDI input FIFO overrun error
bMSRofifoovr	equ	01000000b	;; MIDI output FIFO overrun error
bMSRframeerr	equ	10000000b	;; MIDI frame error

; MIDI FIFO count

bMFCififo	equ	00001111b	;; MIDI input FIFO count
bMFCofifo	equ	11110000b	;; MIDI output FIFO count

; Aux interrupt status/enable

bAUfmrit	equ	00000001b	;; FM right interrupt
bAUpushb	equ	00000010b	;; push button active
bAUslavecpu	equ	00000100b	;; slave coprocessor
bAUaux0int	equ	00001000b	;; aux 0 interrupt
bAUaux1int	equ	00010000b	;; aux 1 interrupt
bAUaux2int	equ	00100000b	;; aux 2 interrupt
bAUaux3int	equ	01000000b	;; aux 3 interrupt
bAUmastrcpu	equ	10000000b	;; master coprocessor or emulation active

; Push Buttons on the Front Panel

bPSHmute	equ	00000001b	;; mute on the front panel
bPSHdnarrow	equ	00000010b	;; down arrow on the front panel
bPSHuparrow	equ	00000100b	;; up arrow on the front panel
bPSauxbit1	equ	00001000b	;; unused bit...
bPSauxbit2	equ	00010000b	;; unused bit...
bPSauxbit3	equ	00100000b	;; unused bit...
bPSauxbit4	equ	01000000b	;; unused bit...
bPSauxbit5	equ	10000000b	;; unused bit...




STRUC	MVState
  _sysspkrtmr	 db	0	;    42 System Speaker Timer Address
  _systmrctlr	 db	0	;    43 System Timer Control
  _sysspkrreg	 db	0	;    61 System Speaker Register
  _joystick	 db	0	;   201 Joystick Register
  _lfmaddr	 db	0	;   388 Left  FM Synth Address
  _lfmdata	 db	0	;   389 Left  FM Synth Data
  _rfmaddr	 db	0	;   38A Right FM Synth Address
  _rfmdata	 db	0	;   38B Right FM Synth Data
  _dfmaddr	 db	0	;   788 Dual  FM Synthesizer Address Register
  _dfmdata	 db	0	;   789 Dual  FM Synthesizer Data Register
		 db	0	;	reserved for future use
  _paudiomixr	 db	0	;   78B Paralllel Audio Mixer Control
  _audiomixr	 db	0	;   B88 Audio Mixer Control
  _intrctlrst	 db	0	;   B89 Interrupt Status
  _audiofilt	 db	0	;   B8A Audio Filter Control
  _intrctlr	 db	0	;   B8B Interrupt Control
  _pcmdata	 db	0	;   F88 PCM Data I/O Register
  _RESRVD2	 db	0	;	reserved
  _crosschannel  db	0	;   F8A Cross Channel
  _RESRVD3	 db	0	;	reserved
  _samplerate	 dw	0	;  1388 Sample Rate Timer
  _samplecnt	 dw	0	;  1389 Sample Count Register
  _spkrtmr	 dw	0	;  138A Shadow Speaker Timer Count
  _tmrctlr	 db	0	;  138B Shadow Speaker Timer Control
  _mdirqvect	 db	0	;  1788 MIDI IRQ Vector Register
  _mdsysctlr	 db	0	;  1789 MIDI System Control Register
  _mdsysstat	 db	0	;  178A MIDI IRQ Status Register
  _mdirqclr	 db	0	;  178B MIDI IRQ Clear Register
  _mdgroup1	 db	0	;  1B88 MIDI Group #1 Register
  _mdgroup2	 db	0	;  1B89 MIDI Group #2 Register
  _mdgroup3	 db	0	;  1B8A MIDI Group #3 Register
  _mdgroup4	 db	0	;  1B8B MIDI Group #4 Register
ENDS




;;
;; Each product will some/all of of these features
;;

bMVA508 	=	0000000000000001b	; MVA508(1) or National(0)
bMVPS2		=	0000000000000010b	; PS2 bus stuff
bMVSLAVE	=	0000000000000100b	; CDPC Slave device is present
bMVSCSI 	=	0000000000001000b	; SCSI interface
bMVENHSCSI	=	0000000000010000b	; Enhanced SCSI interface
bMVSONY 	=	0000000000100000b	; Sony 535 interface
bMVDAC16	=	0000000001000000b	; 16 bit DAC
bMVSBEMUL	=	0000000010000000b	; SB h/w emulation
bMVMPUEMUL	=	0000000100000000b	; MPU h/w emulation
bMVOPL3 	=	0000001000000000b	; OPL3(1) or 3812(0)
bMV101		=	0000010000000000b	; MV101 ASIC
bMV101_REV	=	0111100000000000b	; MV101 Revision
bMV101_MORE	=	1000000000000000b	; more bits in BX

;;
;; Define the ASIC versions
;;

ASIC_VERSION_B	=	0000000000000010b	; revision B
ASIC_VERSION_C	=	0000000000000011b	; revision C
ASIC_VERSION_D	=	0000000000000100b	; revision D
ASIC_VERSION_E	=	0000000000000101b	; revision E
ASIC_VERSION_F	=	0000000000000110b	; revision F

;;
;; First Pro Audio Spectrum feature list
;;
PRODUCT_PROAUDIO	=	bMVSCSI

;;
;; Pro Audio Plus feature list
;;
PRODUCT_PROPLUS 	=	bMV101+      \
				bMVSCSI+     \
				bMVENHSCSI+  \
				bMVSBEMUL+   \
				bMVOPL3
;;
;; Pro Audio Spectrum 16 feature list
;;
PRODUCT_PRO16		=	bMV101+      \
				bMVA508+     \
				bMVSCSI+     \
				bMVENHSCSI+  \
				bMVSBEMUL+   \
				bMVDAC16+    \
				bMVOPL3
;;
;; CDPC feature list
;;
PRODUCT_CDPC		=	bMV101+      \
				bMVSLAVE+    \
				bMVSONY+     \
				bMVSBEMUL+   \
				bMVDAC16+    \
				bMVOPL3


;* $Log: pas.inc,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*