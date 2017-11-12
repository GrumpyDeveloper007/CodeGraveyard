// Devised for Watcom C++ By Xavier / Phobia


#include <string.h>

#include "\coding\include\other\tinyfont.h"


unsigned char *VirtualScreen;  // Address of virtual screen
unsigned char *ScreenPtr=(unsigned char *)0xa0000;      // Address of screen

// Video macros

int outp2(long,long);
#pragma aux outp2 =   \
        "push    ebx     "\
        "push    ecx     "\
        "mov     ebx,eax "\
        "mov     ecx,edx "\
        "mov     edx,eax "\
        "mov     al,cl   "\
        "out     dx,al   "\
        "pop     ecx     "\
        "pop     ebx     "\
		parm caller [eax] [edx] \
                modify [eax edx];

void PutPixel(int x,int y,unsigned char Col);
#pragma aux PutPixel="mov edi,eax"           \
                     "shl edi,8"             \
                     "shl eax,6"             \  
                     "add edi,eax"           \   
                     "add edi,VirtualScreen" \
                     "add edi,ebx"           \
                     "mov [edi],cl"          \
                     parm [ebx] [eax] [cl]   \
                     modify [edi];

void SetPalette(unsigned char *PaletteRGB,int StartCol,int NumCols)
  {
  for (int a=StartCol;a<StartCol+NumCols;a++)
   {
   outp2(0x3c8,a);
   outp2(0x3c9,PaletteRGB[a*3+0]);
   outp2(0x3c9,PaletteRGB[a*3+1]);
   outp2(0x3c9,PaletteRGB[a*3+2]);
   }
  }

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
//  if (*String==' ')     // skip char
//   {
//   X=X+FONTXSIZE;
//   }
//  else
//   {
   if ((Ptr=strchr(CharSet,*String))!=NULL)
    {
    Position=(long)Ptr-(long)CharSet;	// 0 = 0

    PlotChar(X,Y,Position,Colour);
    X=X+FONTXSIZE;
    }
//   }
  String++;
  X++;
  }
 }

void PlotText(int X,int Y,char Character,unsigned char Colour)
 {
 char *Ptr;
 int Position;

// if (Character!=' ')    // skip char if space
//  {
  if ((Ptr=strchr(CharSet,Character))!=NULL)
   {
   Position=(long)Ptr-(long)CharSet;	// 0 = 0
   PlotChar(X,Y,Position,Colour);
   }
//  }
 }

