/*

 OK - Main source file, SNEeSe - Erm init me, load an image, etc.!

*/
// BKG1,BKG2,BKG3,BKG4,DataStore
extern "C" void SetFieldAddress(unsigned char*,unsigned char *,
                        unsigned char*,unsigned char *,unsigned short *);
#pragma aux     SetFieldAddress parm [eax] [ebx] [ecx] [edx] [esi];

unsigned char *SNES_Screen=(unsigned char *)0x0a0000;     // Memory for snes output
//
// these varibles must be stored contiguiously (there accessed by assembler)
// DataStore:
unsigned short BG1HScrollData;   // Storage for h scroll value
unsigned short BG1VScrollData;   // Storage for h scroll value
unsigned short BG2HScrollData;   // Storage for h scroll value
unsigned short BG2VScrollData;   // Storage for h scroll value
unsigned short BG3HScrollData;   // Storage for h scroll value
unsigned short BG3VScrollData;   // Storage for h scroll value
unsigned short BG4HScrollData;   // Storage for h scroll value
unsigned short BG4VScrollData;   // Storage for h scroll value

unsigned char *BKG1;            // I`ll merge the backgrounds to create the screen
unsigned char *BKG2;
unsigned char *BKG3;
unsigned char *BKG4;


#define CPU_VERSION 0.1         // 65816 - Emulation Version
#define HDW_VERSION 0.1         // Snes Hardware - Emulation Version
#define GUI_VERSION 0.0         // GUI - User Interface Version


#define FRAME_SKIP 4

#include <conio.h>
#include <iostream.h>
//#include <dpmi.h>
//#include <go32.h>
#include <dos.h>
//#include <sys/movedata.h>
//#include <pc.h>
#include <stdlib.h>
#include <process.h>

#include "romload.h"
#include "cpu.h"                      // NOT USED NOW (CPU in ASM)
#include "mem.h"
#include "scankeys.h"
#include "\coding\include\video\video.h"



extern int InterruptDone;

void UpdateSNESScreen();
void Process_Interrupt();

/*void SetMode(short Mode)
 {
 __dpmi_regs r;
 r.x.ax=Mode;
 __dpmi_int(0x10,&r);
 }
  
_go32_dpmi_seginfo old_handler,new_handler;	// DJGPP DPMI stuff for KB routines
  */

void (__interrupt __far *OldInterrupt)();
void (__interrupt __far *OldKInterrupt)();

volatile int KeyCodeBuffer[128];

void __interrupt __far NewKBHandler()
 {
 int SKode;

 SKode=inp(0x060);      // READ KEY

 if (SKode<128)
  KeyCodeBuffer[SKode]=(1==1);  //Key Pressed
 else
  KeyCodeBuffer[SKode-128]=(1==0);      // Key Released

 outp(0x20,0x20);
 }
/*
extern "C"
 {
 void Do_CPU();
 void Reset_CPU(unsigned short);
 void InvalidOpcode();
 }
*/
int main()
 {
 long temp;
 cout << "Allocating / Adjusting screen location :";
 temp=(long) (new unsigned char [256*256*4+(256*256)]);
 temp=(temp+(256*256))&0x0ffff0000;
 BKG1=(unsigned char *)temp;
 temp=(temp+(256*256));
 BKG2=(unsigned char *)temp;
 temp=(temp+(256*256));
 BKG3=(unsigned char *)temp;
 temp=(temp+(256*256));
 BKG4=(unsigned char *)temp;
 SetFieldAddress(BKG1,BKG2,BKG3,BKG4,(unsigned short *)&BG1HScrollData);

 cout << "\nSNEeSe Emulation Active";
 cout << "\nVersion " << CPU_VERSION << ":" << HDW_VERSION << ":" << GUI_VERSION;
 cout << "\nCode By Savoury Snax";
 cout.flush();

 OldKInterrupt=_dos_getvect(0x09);
 _dos_setvect(0x09,NewKBHandler);

// _go32_dpmi_get_protected_mode_interrupt_vector(0x09,&old_handler);     // SET KB

// new_handler.pm_offset = (int)NewKBHandler;
// new_handler.pm_selector = _go32_my_cs();

// _go32_dpmi_chain_protected_mode_interrupt_vector(0x09,&new_handler);

 if (!LoadROM("test2.smc"))
  {
  cout << "Failed To Load Cartridge Rom....Sorry!";
  return -1;
  }

 // HEHEHE = Ok, this next bit is a temporary poke to circumvent the musik init routine in the
 //demo (I say temp, cos Once I reach the end of the demo, I`ll start with the SPC!)
 //Erm no it isnt, its now a poke to circumvent Marios SPC stuff

// SetSNESByte_Unmapped(32796+RomAddress,0xea);
// SetSNESByte_Unmapped(32797+RomAddress,0xea);
// SetSNESByte_Unmapped(32798+RomAddress,0xea);

// SetSNESByte_Unmapped(0x8085+RomAddress,0xea);
// SetSNESByte_Unmapped(0x8086+RomAddress,0xea);
	
 // Reset CPU To Initial State

 Reset_CPU(InitReset);

 long NMITimer=0;
 const long NMITrip=53600;    // This value was taken from TSNES (It may not be right!)

 int FrameCount=0;
 
 InitVideo();       // DO VGA

 VirtualScreen=SNES_Screen;    // Avoid lameness Must be set before using video

 Do_CPU();	// This is the CPU core (everything is refernced from this function

// InvalidOpcode();       // Got here there must have been a serious problem (Invalid opcode!)

 for(;;)        // Infinite Loop (Do instead of while to avoid checks)
  {
  Do_CPU();       // Do Next OpCode
/*  char Message[100];
  itoa(SNES_Registers.PC.SNESPointer.Bank,Message,16);

  cout << "\rCPU - 0x"<<Message << ":0x";

  itoa(SNES_Registers.PC.SNESPointer.Offset.W,Message,16);
  cout << Message;
  cout.flush();   */

  NMITimer=SNES_Cycles;	// time ticks down to the NMI

  if (NMITimer>=NMITrip)
   {
   // Interrupt processing here!!!!!!
   NMITimer-=NMITrip;
   SNES_Cycles=0;	// Reset cycle count here

   if (KeyCodeBuffer[K_ESC])
    break;

   if (!TEST_FLAG(SNES_FLAG_I) && (GetSNESByte_Unmapped(0x4200+RomAddress)&0x80)==0x80)	// Interrupts enabled so call NMI function
    {
//    cout << "\nNMI CALL - NOT YET IMPLEMENTED (THIS PROGRAM WILL NOT WORK PROPERLY)";
//    cout.flush();
    Process_Interrupt();      // Set PC to intterupt, and emulate!
    InterruptDone=(1==1);
    }

   SNES2PC_Pointer Address2;
 
   Address2.PCPointer=0;
   Address2.SNESPointer.Offset.W=0x4210;	// Poke here for NMI interrupt!
 
   FrameCount++;

   if (FrameCount==FRAME_SKIP)
    {
    FrameCount=0;
    if ((GetSNESByte_Unmapped((unsigned char *)(0x2100+(unsigned long)RomAddress))&0x80)==0x00)
     {
     UpdateSNESScreen();

//     UpdateScreen();                // Update 0x13 GFX SCREEN
     }
    }

   SetSNESByte_Unmapped(SNESAddress(Address2),0x80);	// what the hell do I do for version!
   }
  }

 _dos_setvect(0x09,OldKInterrupt);

 KillVideo();

 return 0;
 }

void SetPalette(unsigned char *Pal)
 {
 for (int a=0;a<256;a++)
  {
  outp(0x3c8,a);
  outp(0x3c9,Pal[a*3+0]);
  outp(0x3c9,Pal[a*3+1]);
  outp(0x3c9,Pal[a*3+2]);
  }
 }

void InvalidOpcode()
 {
 char Message[100];

 unsigned char opcode=GetSNESByte_Unmapped((unsigned long)SNES_Registers.PC.PCPointer+RomAddress);

 itoa(opcode,Message,16);

 cout << "Invalid Opcode - 0x" << Message;
 exit(-1);
 }
