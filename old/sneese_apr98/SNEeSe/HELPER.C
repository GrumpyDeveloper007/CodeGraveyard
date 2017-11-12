/*

 This contains variable and function defintions used by both ASM and C++, defined as C for
easier referencing.... NB I had to do this for vars cos, debugger was playing up!?

*/

#include <process.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <sys/movedata.h>
#include <pc.h>
#include <dpmi.h>

#include <sys/segments.h>

#include <allegro.h>

extern unsigned char TBGMODE,TBG1SC,TBG2SC,TBG3SC,TBG4SC;
extern unsigned char TOBSEL,TBG12NBA,TBG34NBA,TVMAIN,TTM,TTD;
extern unsigned short TBG1HScr,TBG1VScr,TBG2HScr,TBG2VScr;
extern unsigned short TBG3HScr,TBG3VScr,TBG4HScr,TBG4VScr;
extern unsigned short TOAMADDH;

unsigned char SPC_TIMER0,SPC_TIMER1,SPC_TIMER2,
              SPC_TIMT0 ,SPC_TIMT1 ,SPC_TIMT2 ,
              SPC_TIM0  ,SPC_TIM1  ,SPC_TIM2  ,
              SPC_CNT0  ,SPC_CNT1  ,SPC_CNT2  ,
              SPC_CTRL;

unsigned long SNES_KEY_UP,SNES_KEY_DOWN,SNES_KEY_LEFT,SNES_KEY_RIGHT,
              SNES_KEY_A,SNES_KEY_B,SNES_KEY_X,SNES_KEY_Y,
              SNES_KEY_L,SNES_KEY_R,SNES_KEY_SELECT,SNES_KEY_START,
              SNES2_KEY_UP,SNES2_KEY_DOWN,SNES2_KEY_LEFT,SNES2_KEY_RIGHT,
              SNES2_KEY_A,SNES2_KEY_B,SNES2_KEY_X,SNES2_KEY_Y,
              SNES2_KEY_L,SNES2_KEY_R,SNES2_KEY_SELECT,SNES2_KEY_START
              __attribute__ ((__aligned__));

unsigned char *MappedSaveRamAddress;
unsigned char *MappedLoRamAddress;
unsigned char *MappedWorkRamAddress;
unsigned long RomReadBuffer[64+32];
unsigned long RomHiReadBuffer[64+32];
unsigned long HRomReadBuffer[64+32];
unsigned long HRomHiReadBuffer[64+32];
unsigned long HRomLinReadBuffer[64+32];
unsigned long HRomLinReadBuffer_48[64+32];
unsigned long SRAM30Buffer[16];
unsigned long SRAMB0Buffer[16];

unsigned short ScreenX,ScreenY;

/*

unsigned long SNESPatch[10];	// Used to Apply Patches!
unsigned long *SNESPatchPtr=&SNESPatch[0];
unsigned long NumPatches=0;


	movl _NumPatches,%ecx
	movl _SNESPatchPtr,%edx
	cmpl $0,%ecx
	je 0f
1:
	movl (%edx),%esi
	movl %esi,%eax
	andl $0x00FFFFFF,%esi
	shrl $24,%eax
	SET_BYTE
	decl %ecx
	jne 1b
0:

 SNESPatch[0]=0x3F7E0B9D;
 NumPatches=1;

*/

unsigned char Div16Table[16*256];	// Used for faster divides etc.
unsigned char SNES_Palette_Buffer[256*4];	// So I can access from cc modules!
unsigned char Real_SNES_Palette_Buffer[256*2];	// Updated by palette write
unsigned char HICOLOUR_Palette_Buffer[256*4];	// values in here are plotted direct to PC!
unsigned char *SNES_Palette=&SNES_Palette_Buffer[0];
unsigned char *Real_SNES_Palette=&Real_SNES_Palette_Buffer[0];
unsigned char *HICOLOUR_Palette=&HICOLOUR_Palette_Buffer[0];

//#ifdef ELF
unsigned char RegDump_Buffer[256*2];
unsigned char *RegDump=&RegDump_Buffer[0];
//#endif

#ifdef DEBUG
volatile unsigned long Timer_Counter_Profile=0;
volatile unsigned long Timer_Counter_FPS=0;
unsigned long Frames=0;
unsigned long Total_CPU,Total_Screen;
#endif

long M7X_DATA,M7Y_DATA,M7A_DATA,M7B_DATA,M7C_DATA,M7D_DATA;

unsigned long INT_BANK,RESET_VECTOR;
unsigned long Map_Address;
unsigned char Map_Byte;

// Mode 0 = 320,200 : Mode 1 = 320,200 SQUASH
// Mode 2 = 320,240 : Mode 3 = 256,256
// Mode 4 = 640,480 : Mode 5 = 640,480 STRETCH
// Treated as char in screen core! Only modes 0-7 used!
unsigned short PC_SCREEN_MODE=0;

unsigned char *SNES_Screen __attribute__ ((__aligned__));
/* Temp Buffer for screen */
unsigned char *GUI_Screen;

BITMAP *Allegro_Bitmap=NULL;		// Renamed (I'm using mostly allegro now so what the hell!)
BITMAP *Allegro_Bitmap_GUI=NULL;

SAMPLE *test[8];	// We will allocate 64k worth of sample to each of these!
int VoiceList[8];	// List of voices

unsigned long FRAME_SKIP=4; // Frames waited until refresh
unsigned char SNES_COUNTRY; // Used for PAL/NTSC protection checks
unsigned char JOYSTICK_ENABLED=0;
unsigned char JOYSTICK_ENABLED2=0;
unsigned char SPC_ENABLED=0;

unsigned long BKG;

unsigned long VRamTop;

/* CPU REGISTERS AND STUFF */

unsigned long SNES_X __attribute__ ((__aligned__));
unsigned long SNES_Y;  // X and Y indices
unsigned long SNES_A;  // Accumulator
unsigned long SNES_F;  // Flags register
unsigned long SNES_S;  // Stack pointer
unsigned long SNES_D;  // Direct Address
unsigned long SNES_PC; // Program counter
unsigned long SNES_DataBank;
unsigned long SNES_ProgBank;
#define SNES_DB (SNES_DataBank>>16)
#define SNES_PB (SNES_ProgBank>>16)
unsigned long NMITrip; // Cycles per screen refresh
unsigned long IRQTrip; // Cycles per scanline

unsigned char SPC_DSP_Buffer[256];		/* DSP Registers */
unsigned char *SPC_DSP=&SPC_DSP_Buffer[0];

unsigned short DSP_PITCH[8],*DSP_PITCHP=&DSP_PITCH[0];
unsigned char DSP_VOL[8],*DSP_VOLP=&DSP_VOL[0];
unsigned char DSP_MVOL,DSP_KEY_ON;
unsigned char DECODE_BYTE;

void Dummy()
 {
 int a;
 a=a+1;
 }

extern unsigned char *SPCAddress;

void SPC_DECODE()		/* archeide + Brad Martin + SnaX */
 {
 unsigned char BRR_byte, tmp, end = 0, loop = 0;
 unsigned short K, cnt, pos, tmp2;
 unsigned char *S_ptr,*L_ptr;
 unsigned short VSrc=((short)SPC_DSP[(DECODE_BYTE<<4)+0x04])<<2;
 short *samp;
 register int i;

// return;		/* If we don't do this BOOOOOOOOM */

 K = 0;
 pos = 0;

// get the sample address

 S_ptr = &SPCAddress[SPCAddress[SPC_DSP[0x5D]*0x100+VSrc]+
         SPCAddress[SPC_DSP[0x5D]*0x100+VSrc+1]*0x100];
 L_ptr = &SPCAddress[SPCAddress[SPC_DSP[0x5D]*0x100+VSrc+2]+
         SPCAddress[SPC_DSP[0x5D]*0x100+VSrc+3]*0x100];
 samp  = (short *)test[DECODE_BYTE]->data;

 do
  {
  BRR_byte = S_ptr[pos++];
  if (BRR_byte & 0x01) 
   end = 1;
  tmp = (BRR_byte&12) >> 2;
  BRR_byte >>= 4;
  cnt = 0;

  do
   {
   tmp2 = (S_ptr[pos]>>4)&0x0F;
   if (tmp2 > 7) 
    tmp2 |= -16;
   tmp2 <<= BRR_byte;
   if (tmp == 1) 
    tmp2 += (*(samp + K-1)*15)/16;
   if (tmp == 2) 
    tmp2 += (*(samp + K-1)*61)/32-(*(samp+K-2)*15)/16;
   if (tmp == 3) 
    tmp2 += (*(samp + K-1)*115)/64-(*(samp+K-2)*13)/15;
   *(samp + K++) = tmp2;

   tmp2 = S_ptr[pos]&0x0F;
   if (tmp2 > 7) 
    tmp2 |= -16;
   tmp2 <<= BRR_byte;
   if (tmp == 1) 
    tmp2 += (*(samp + K-1)*15)/16;
   if (tmp == 2) 
    tmp2 += (*(samp + K-1)*61)/32 -(*(samp +K-2)*15)/16;
   if (tmp == 3) 
    tmp2 += (*(samp + K-1)*115)/64 - (*(samp +K-2)*13)/15;
   *(samp + K++) = tmp2;

   cnt++;
   pos++;
   } 
  while (cnt < 8);
  }
 while (!end);

// translate signed to unsigned :
 for (i = 0; i < K; i++)
  *(samp + i) ^= 0x8000;

 test[DECODE_BYTE]->len=K;
 if ((BRR_byte&0x02)==0x02)	// Looping sample
  test[DECODE_BYTE]->loop_end=(L_ptr-S_ptr)/9*16;
 else
  test[DECODE_BYTE]->loop_end=0;
 }

void SPC_UPDATEAUDIO()
 {
 int a;

 set_volume((SPC_DSP[0x0C]&0x7F)+(SPC_DSP[0x1C]&0x7F),-1);
 for (a=0;a<8;a++)
  {
  voice_set_volume(VoiceList[a],255);		/* Force Maximum volume helps */
//  voice_set_volume(VoiceList[a],(SPC_DSP[(a<<4)+0x00]&0x7F)+(SPC_DSP[(a<<4)+0x01]&0x7F));
  voice_set_frequency(VoiceList[a],(((short)SPC_DSP[(a<<4)+0x02])<<8)+SPC_DSP[(a<<4)+0x03]);
  }
 }

void PlayVoices()		// Plays voices set by Key_On state
 {
 int a;
 for (a=0;a<8;a++)
  {
  if (((1<<a)&DSP_KEY_ON)!=0)
   voice_start(VoiceList[a]);
  }
 }

void InvalidDMAMode()
 {
 char Message[100];

 set_gfx_mode(GFX_TEXT,0,0,0,0);

 itoa(Map_Byte,Message,16);

 printf("\nUnsupported DMA Mode! - 0x%s",Message);

 fflush(stdout);    // Flushes output cos its buffered for some reason!

 exit(-1);
 }

unsigned char BrightnessLevel;		/* SNES Brightness level, set up in memhard.s */

char palettechanged=FALSE;
char fixedpalettecheck=0;

void SetPalette()			/* V 0.15, we do palette conversion here */
 {
 /* NB - CGRamAddress[256*2] contains 256 palette entries as follows :
         CGRamAddress[0*2+0] contains GGGRRRRR  R = Red component
         CGRamAddress[0*2+1] contains 0BBBBBGG  G = Green component
                                                B = Blue component

    So each 2 addresses contains 1 palette entry.
 */
 
 unsigned short Word;
 unsigned short Redw,Greenw,Bluew;
 unsigned char Red,Green,Blue,Hi1,Hi2;
 int Count;

 if (PC_SCREEN_MODE>3)		/* Hi colour mode so do different palette set up */
  {
  for (Count=0;Count<256;Count++)
   {
   Word=(((unsigned short)(Real_SNES_Palette[Count*2+1]))<<8)|Real_SNES_Palette[Count*2+0];
   Redw=(Word&0x001F);
   Greenw=((Word>>5)&0x001F);
   Bluew=((Word>>10)&0x001F);
   Hi1=(Greenw<<6)|(Bluew);
   Hi2=(Redw<<3)|(Greenw>>2);
   HICOLOUR_Palette[Count*4+0]=Hi1;
   HICOLOUR_Palette[Count*4+1]=Hi2;
   HICOLOUR_Palette[Count*4+2]=Hi1;
   HICOLOUR_Palette[Count*4+3]=Hi2;
   Red=Div16Table[BrightnessLevel*256+(Redw<<1)];
   Green=Div16Table[BrightnessLevel*256+(Greenw<<1)];
   Blue=Div16Table[BrightnessLevel*256+(Bluew<<1)];
   SNES_Palette_Buffer[Count*4+0]=Red;		/* We still have to do this or save pcx */
   SNES_Palette_Buffer[Count*4+1]=Green;	/* will fail */
   SNES_Palette_Buffer[Count*4+2]=Blue;
   }
  }
 else
  {
  for (Count=0;Count<256;Count++)
   {
   Word=(((unsigned short)(Real_SNES_Palette[Count*2+1]))<<8)|Real_SNES_Palette[Count*2+0];
   Red=Div16Table[BrightnessLevel*256+((Word&0x001F)<<1)];
   Green=Div16Table[BrightnessLevel*256+(((Word>>5)&0x001F)<<1)];
   Blue=Div16Table[BrightnessLevel*256+(((Word>>10)&0x001F)<<1)];
   SNES_Palette_Buffer[Count*4+0]=Red;		/* We still have to do this or save pcx */
   SNES_Palette_Buffer[Count*4+1]=Green;	/* will fail */
   SNES_Palette_Buffer[Count*4+2]=Blue;
   }
  }

 if(PC_SCREEN_MODE<2)
  set_palette((RGB *)SNES_Palette_Buffer);
 else
  {
  palettechanged=TRUE;
  }
 fixedpalettecheck=1;
 }

void CopySNESScreen()
 {
 if(palettechanged==TRUE)
  {
  set_palette((RGB *)SNES_Palette_Buffer);
  palettechanged=FALSE;
  }
//#ifdef ELF
 if (PC_SCREEN_MODE==8)
  {
  UpdateScreen__Fv();
  }
//#endif

 if (PC_SCREEN_MODE!=8)
  blit(Allegro_Bitmap,screen,0,0,0,0,ScreenX,ScreenY);
 }

void CopyGUIScreen()
 {
 blit(Allegro_Bitmap,screen,0,0,0,0,ScreenX,ScreenY);
 }

#ifdef DEBUG

void InvalidHWRead()
 {
/* char Message[100];
 unsigned long Temp=Map_Address&0x0000FFFF;

 itoa(Temp,Message,16);

 printf("\nRead From Unsupported HW Address! - 0x%s",Message);

 itoa(Map_Byte,Message,16);

 printf(" with 0x%s",Message);

// fflush(stdout);  // Flushes output cos its buffered for some reason!*/

//getch();
 }

void InvalidSPCHWRead()
 {
/* char Message[100];
 unsigned long Temp=Map_Address&0x0000FFFF;

 itoa(Temp,Message,16);

 printf("\nRead From Unsupported SPC HW Address! - 0x%s",Message);

 itoa(Map_Byte,Message,16);

 printf(" with 0x%s",Message);

 fflush(stdout);    // Flushes output cos its buffered for some reason!*/
 }

void InvalidSPCROMWrite()
 {
/* char Message[100];
 unsigned long Temp=Map_Address&0x0000FFFF;

 itoa(Temp,Message,16);

 printf("\nWrite To SPC ROM Ignored - 0x%s",Message);

 itoa(Map_Byte,Message,16);

 printf(" with 0x%s",Message);

 fflush(stdout);	// Flushes output cos its buffered for some reason!*/
 }

void InvalidSPCHWWrite()
 {
/* char Message[100];
 unsigned long Temp=Map_Address&0x0000FFFF;

 itoa(Temp,Message,16);

 printf("\nWrite To Unsupported SPC HW Address! - 0x%s",Message);

 itoa(Map_Byte,Message,16);

 printf(" with 0x%s",Message);

 fflush(stdout);	// Flushes output cos its buffered for some reason!*/
 }

void InvalidROMWrite()
 {
/* char Message[100];
 unsigned long Temp=Map_Address&0x0000FFFF;

 itoa(Temp,Message,16);

// printf("\nWrite To ROM Ignored - 0x%s",Message);

 itoa(Map_Byte,Message,16);

// printf(" with 0x%s",Message);

// fflush(stdout);  // Flushes output cos its buffered for some reason!*/
 }

void InvalidHWWrite()
 {
/* char Message[100];
 unsigned long Temp=Map_Address&0x0000FFFF;

 itoa(Temp,Message,16);

 printf("\nWrite To Unsupported HW Address! - 0x%s",Message);

 itoa(Map_Byte,Message,16);

 printf(" with 0x%s",Message);

// fflush(stdout);  // Flushes output cos its buffered for some reason!*/
 }

#endif

#ifdef DEBUG
void DisplayStatus();
#endif

void InvalidOpcode()
 {
 char Message[100];

 set_gfx_mode(GFX_TEXT,0,0,0,0);

#ifdef DEBUG
 DisplayStatus();
#endif

 itoa(Map_Byte,Message,16);

 printf("\nOpcode Not Currently Supported SORRY! - 0x%s",Message);

 itoa((Map_Address>>16),Message,16);

 printf("\nAt Address 0x%s",Message);

 itoa((Map_Address&0xFFFF),Message,16);

 printf(":0x%s",Message);

 fflush(stdout);	// Flushes output cos its buffered for some reason!

 exit(-1);
 }

unsigned char S_A,S_X,S_Y;
unsigned short S_S,S_PC,S_P __attribute__ ((__aligned__));

void DisplaySPC()
 {
 char Message[100],Message2[100];;

 itoa(S_PC,Message,16);
 itoa(S_S,Message2,16);

 printf("\nS_PC - 0x%04s   S_S - 0x%04s",Message,Message2);

 itoa(S_A,Message,16);

 printf("\nS_A  - 0x%02s     V000NZ0H0IPC",Message);

 itoa(S_X,Message,16);
 itoa(S_P,Message2,2);

 printf("\nS_X  - 0x%02s     %012s",Message,Message2);

 itoa(S_Y,Message,16);

 printf("\nS_Y  - 0x%02s",Message);

 itoa(Map_Byte,Message,16);

 fflush(stdout);	// Flushes output cos its buffered for some reason!

// getch();
 }

void DisplayStatus();

#ifdef DEBUG
unsigned long OLD_PC;       // Pre-NMI PB:PC
unsigned char OLD_PB;
unsigned char PORT0R,PORT1R,PORT2R,PORT3R,PORT0W,PORT1W,PORT2W,PORT3W;
unsigned char APUI00a,APUI00b,APUI00c;
unsigned short OLD_SPC_ADDRESS;		// Temporary trying to trap bugs
#endif

void InvalidSPCOpcode()		// Simple at present... register dump will be done l8r
 {
 char Message[100],Message2[100];

 set_gfx_mode(GFX_TEXT,0,0,0,0);

 itoa(S_PC,Message,16);
 itoa(S_S,Message2,16);

 printf("\nS_PC - 0x%04s   S_S - 0x%04s",Message,Message2);

 itoa(S_A,Message,16);

 printf("\nS_A  - 0x%02s     V000NZ0H0IPC",Message);

 itoa(S_X,Message,16);
 itoa(S_P,Message2,2);

 printf("\nS_X  - 0x%02s     %012s",Message,Message2);

 itoa(S_Y,Message,16);

 printf("\nS_Y  - 0x%02s",Message);

 itoa(Map_Byte,Message,16);

 printf("\n\nSPC Opcode Not Currently Supported SORRY! - 0x%s",Message);

 itoa((Map_Address&0xFFFF),Message,16);

 printf("\nAt Address 0x%04s",Message);

#ifdef DEBUG

 itoa((OLD_SPC_ADDRESS&0xFFFF),Message,16);

 printf("\nOld Address 0x%04s",Message);

 itoa(PORT0R,Message,16);
 itoa(PORT1R,Message2,16);

 printf("\nSPC READ  0 - 0x%02s  1 - 0x%02s",Message,Message2);

 itoa(PORT2R,Message,16);
 itoa(PORT3R,Message2,16);

 printf("  2 - 0x%02s  3 - 0x%02s",Message,Message2);

 itoa(PORT0W,Message,16);
 itoa(PORT1W,Message2,16);

 printf("\nSPC WRITE  0 - 0x%02s  1 - 0x%02s",Message,Message2);

 itoa(PORT2W,Message,16);
 itoa(PORT3W,Message2,16);

 printf("  2 - 0x%02s  3 - 0x%02s",Message,Message2);

 Wangle__Fv();		// Output SPC_RAM contents
#endif

 fflush(stdout);	// Flushes output cos its buffered for some reason!

 exit(-1);
 }

#ifdef DEBUG

void DisplayStatus()
 {
 char Message[100],Message2[100];

 itoa(OLD_PB,Message,16);
 itoa(OLD_PC,Message2,16);
 printf("\nPC - 0x%02s:0x%04s ",Message,Message2);

 itoa(SNES_DB,Message,16);
 itoa(SNES_D,Message2,16);
 printf("D - 0x%02s:0x%04s ",Message,Message2);

 itoa(0,Message,16);
 itoa(SNES_S,Message2,16);
 printf("S - 0x%02s:0x%04s  V01ENZBDIXMC",Message,Message2);

 itoa(SNES_X,Message,16);
 itoa(SNES_Y,Message2,16);
 printf("\n X - 0x%04s      Y - 0x%04s ",Message,Message2);

 itoa(SNES_A,Message,16);
 itoa(SNES_F,Message2,2);
 printf("     A - 0x%04s       %012s",Message,Message2);

 itoa(Map_Byte,Message,16);
 printf("\nOpcode - 0x%s",Message);

 itoa(TBG1SC,Message,16);
 itoa(TBG2SC,Message2,16);
 printf("\nBG1SC - 0x%02s   BG2SC - 0x%02s",Message,Message2);

 itoa(TBG3SC,Message,16);
 itoa(TBG4SC,Message2,16);
 printf("   BG3SC - 0x%02s   BG4SC - 0x%02s",Message,Message2);

 itoa(TBG1HScr,Message,16);
 itoa(TBG1VScr,Message2,16);
 printf("\nBG1H - 0x%04s   BG1V - 0x%04s",Message,Message2);

 itoa(TBG2HScr,Message,16);
 itoa(TBG2VScr,Message2,16);
 printf("   BG2H - 0x%04s   BG2V - 0x%04s",Message,Message2);

 itoa(TBG3HScr,Message,16);
 itoa(TBG3VScr,Message2,16);
 printf("\nBG3H - 0x%04s   BG3V - 0x%04s",Message,Message2);

 itoa(TBG4HScr,Message,16);
 itoa(TBG4VScr,Message2,16);
 printf("   BG4H - 0x%04s   BG4V - 0x%04s",Message,Message2);

 itoa(TBGMODE,Message,16);
 itoa(TTM,Message2,16);
 printf("\nBGMODE - 0x%02s      TM - 0x%02s",Message,Message2);

 itoa(TVMAIN,Message,16);
 itoa(TTD,Message2,16);
 printf("\nVMAIN - 0x%02s       TD - 0x%02s",Message,Message2);

 itoa(TBG12NBA,Message,16);
 itoa(TBG34NBA,Message2,16);
 printf("\nBG12NBA - 0x%02s     BG34NBA - 0x%02s",Message,Message2);

 itoa(TOBSEL,Message,16);
 itoa(TOAMADDH,Message2,16);
 printf("\nOBSEL - 0x%02s      OAMADDH - 0x%02s",Message,Message2);

 itoa(PORT0R,Message,16);
 itoa(PORT1R,Message2,16);
 printf("\nSPC READ  0 - 0x%02s  1 - 0x%02s",Message,Message2);

 itoa(PORT2R,Message,16);
 itoa(PORT3R,Message2,16);
 printf("  2 - 0x%02s  3 - 0x%02s",Message,Message2);

 itoa(PORT0W,Message,16);
 itoa(PORT1W,Message2,16);
 printf("\nSPC WRITE  0 - 0x%02s  1 - 0x%02s",Message,Message2);

 itoa(PORT2W,Message,16);
 itoa(PORT3W,Message2,16);
 printf("  2 - 0x%02s  3 - 0x%02s",Message,Message2);

 itoa(APUI00a,Message,16);
 itoa(APUI00b,Message2,16);
 printf("\n  APUI00a - 0x%02s  APUI00b - 0x%02s",Message,Message2);

 itoa(APUI00c,Message,16);
 printf("\n  APUI00c - 0x%02s",Message);

 fflush(stdout);	// Flushes output cos its buffered for some reason!

// getch();
 }

RGB DebugPal[]={{63,63,63,0}};

unsigned char DEBUG_STRING[]="Voice : %d";

unsigned char DEBUG_VALUE1=0;
unsigned char DEBUG_VALUE2=0;
unsigned char DEBUG_VALUE3=0;
unsigned char DEBUG_VALUE4=0;
unsigned char DEBUG_VALUE5=0;
unsigned char DEBUG_VALUE6=0;
unsigned char DEBUG_VALUE7=0;
unsigned char DEBUG_VALUE8=0;

void Display_Debug()
 {
 set_palette_range(&DebugPal[-255],255,255,1);	// Set the GUI palette up.
 textprintf(screen,font,50,50,255,DEBUG_STRING,(int)DEBUG_VALUE1);
 textprintf(screen,font,50,60,255,DEBUG_STRING,(int)DEBUG_VALUE2);
 textprintf(screen,font,50,70,255,DEBUG_STRING,(int)DEBUG_VALUE3);
 textprintf(screen,font,50,80,255,DEBUG_STRING,(int)DEBUG_VALUE4);
 textprintf(screen,font,50,90,255,DEBUG_STRING,(int)DEBUG_VALUE5);
 textprintf(screen,font,50,100,255,DEBUG_STRING,(int)DEBUG_VALUE6);
 textprintf(screen,font,50,110,255,DEBUG_STRING,(int)DEBUG_VALUE7);
 textprintf(screen,font,50,120,255,DEBUG_STRING,(int)DEBUG_VALUE8);
 }

#endif
