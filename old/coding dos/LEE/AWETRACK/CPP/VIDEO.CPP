// Devised for Watcom C++ By Xavier / SCUDD

// For now the SVGA code is not used which is a pain! 
// This is due to a problem with the VESA 2.0 specification e.g.
// I have no idea how it works, and I don`t want to hack it and get it wrong.

// VGA & SVGA 256 colour display drivers (320*200)
//
// Why VGA & SVGA ? - VGA has no page buffer and so the entire screen must
//                   be copied, SVGA however has a page buffer and this
//                   will save a few cycles (I Think). Also, SVGA has a
//                   PMode Linear frame buffer (if I can figure it out!)   

#include <i86.h>
#include <conio.h>
#include <string.h>

#include "h\tinyfont.h"

int OldMode=0x0003;    // Last mode video card was in (FIXED AT PRESENT)
REGS Registers;

unsigned char *VirtualScreen;  // Address of virtual screen
unsigned char *ScreenPtr=(unsigned char *)0xa0000;      // Address of screen

unsigned char ScreenBuffer[(320*200)];  // VGA virtual screen

#include "h\MACROS.H"

void InitVideo()        // Attempts to latch an SVGA mode 320*200*256
 {                      //if unavailable, it will use standard MODE 0x13

// AT PRESENT WILL ALWAYS USE MODE 13

 Registers.x.eax=0x0013;        // BOOT UP 320 * 200 mode
 int386(0x10,&Registers,&Registers);

 VirtualScreen=ScreenBuffer;
 }

void KillVideo()
 {
 Registers.x.eax=OldMode;
 int386(0x10,&Registers,&Registers);
 }

void SetPalette(unsigned char *PaletteRGB,int StartCol,int NumCols)
  {
  for (int a=StartCol;a<StartCol+NumCols;a++)
   {
   outp(0x3c8,a);
   outp(0x3c9,PaletteRGB[a*3+0]);
   outp(0x3c9,PaletteRGB[a*3+1]);
   outp(0x3c9,PaletteRGB[a*3+2]);
   }
  }

extern void PutPixel(int x,int y,unsigned char Col);

void PlotChar(int X,int Y,int Char,unsigned char Colour)
 {
 for (int a=Y;a<Y+FONTYSIZE;a++)
  for (int b=X;b<X+FONTXSIZE;b++)
   PutPixel(b,a,Colour*Font[Char].Character[(b-X)+(a-Y)*FONTXSIZE]);
 }

void PlotText(int X,int Y,char *String,unsigned char Colour)
 {
 char *Ptr;
 int Position;

 while (*String!='\0')
  {
  if ((Ptr=strchr(CharSet,*String))!=NULL)
   {
   Position=(long)Ptr-(long)CharSet;   // 0 = 0
   PlotChar(X,Y,Position,Colour);
   X=X+FONTXSIZE;
   }
  String++;
  X++;
  }
 }

void PlotText(int X,int Y,char Character,unsigned char Colour)
 {
 char *Ptr;
 int Position;

 if (Character!=' ')	// skip char if space
  {
  if ((Ptr=strchr(CharSet,Character))!=NULL)
   {
   Position=(long)Ptr-(long)CharSet;	// 0 = 0
   PlotChar(X,Y,Position,Colour);
   }
  }
 }

