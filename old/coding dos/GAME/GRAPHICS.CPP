#define ButtonCol1 64
#define ButtonCol2 128
#define ButtonFontCol 56
#define ScreenX 640
#define ScreenY 480

extern unsigned char Font1Set[];
extern unsigned char Font1Data[];
extern unsigned char Font2Data[];

#include <stdlib.h>

extern unsigned char *Screen;

#include "\coding\include\std\std.h"
#include "\coding\include\other\pcx.h"

///////////////////////////////////
//
// Graphic routines -


// D - at end is for direct output (screen plot)


// PutPCX(WindowType,BitMapType) -- Copys bitmap to window
//// function supports loading of PCX if not in memory

// CopyWindow(WindowType,WindowType) (source,dest) -- 
// ClearWindow(WindowType) -- Clears window
// NewWindow(SizeX,SizeY,Changed,Virtual,Destnation);
// PlotWindow(WindowType)  -- Plot window to viewport (non cliped)
// PlotWindows() -- Plot all windows in list

// PlotObjectM(ObjectType,WindowType) -- Plots masked objects (move/non-move)

// PlotObjectCLIP(ObjectType,WindowType) -- Plot any sized object (overwrite)
// BoxCLIP(WindowType,x1,y1,x2,y2,col) -- Plot box Cliped******* fucked******
// Box(WindowType,x1,y1,x2,y2,col) -- Plot box
// FillBox(WindowType,x1,y1,x2,y2,col) -- Filled box (non cliped)
// ButtonBox(WindowType,x1,y1,x2,y2,col1,col2) -- Plot box, button type
// ButtonBoxD(x1,y1,x2,y2,col1,col2) -- Plot box, button type (Direct)

// PlotLetterD(Destnation,SizeX,SizeY,Source) -- plots colour font character
// PlotLetterD(Destnation,SizeX,SizeY,Source,Colour) -- plots mono font char
// PlotStringD2(X,Y,String) -- Plots zero terminated string/////old
// PlotStringD(X,Y,String,fontaddress) -- Plots zero terminated string
// PlotButtonD2(int x,int y,char *String) -- Draws box as well
// PlotButtonD(int x,int y,char *String,fontAddress) -- Draws box as well

// Window operations
// PlotLetter(WindowType,Destnation,SizeX,SizeY,modulo,dmodulo,Source)
// PlotLetter(WindowType,Destnation,SizeX,SizeY,modulo,dmodulo,Source,Colour)
// PlotString(WindowType,X,Y,String,fontaddress) -- Plots zero terminated string
// PlotButton(WindowType,int x,int y,char *String,fontAddress) -- Draws box as well

///////////////////////////////////

void PlotPixel(unsigned char *Offset,unsigned char Col);
#pragma aux PlotPixel = \
            "add edi,Screen " \            
            "mov fs:[edi],al" \
            parm caller [edi] [al];

void PlotPixel2(unsigned char *Offset,unsigned char Col);
#pragma aux PlotPixel2 = \
            "mov fs:[edi],al" \
            parm caller [edi] [al];


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
// Anim Stuff
// 
// Anim structure used to define anim
struct AnimFrameType
 {
 unsigned char *GFXPointer;
 AnimFrameType *Next;
 };

// Header for anim
struct AnimHeader
 {
 long SizeX,SizeY;
 long Frames;
 AnimFrameType *Next;
 };

// Anim Structure to define anim in effect
struct AnimType
 {
 long XPos,YPos;
 long CurrentFrame; 
 AnimHeader *Anim; // Pointer to anim to use
 };


// Graphic stuff
struct BitMapType
 {
 long XPos,YPos;
 long SizeX,SizeY;
 char *Name;
 unsigned char *GFXPointer;
 };
struct BackPlotObject
 {
 long XPos,YPos;
 long SizeX,SizeY;
 unsigned char *GFXPointer;
 };

struct MovePlotObject
 {
 long XPos,YPos;
 long SizeX,SizeY;
 long MaxFrames;
 long Frame;
 long OFrame;
 unsigned long Type;
 unsigned char *GFXPointer; // or anim list pointer
 unsigned char *BackPointer;
 long OXPos,OYPos;
 };
// TYPE -
//  Bit
//   0000 - Overwrite // Back textures
//   0001 - BackCopy  // Non-moving objects
//   0010 - 0 Mask    
//   0100 - Moving (use old x,y to put background back )
//   1000 - ClearBack (backbuffer not read yet)
struct ButtonType
 {
 long XPos,YPos;         // Window offset of button
 long SizeX,SizeY;       // The size of the button
 char *String;           // The string to plot with the button
 unsigned char *Effect;  // This points to a byte to set if button is pressed
 ButtonType *Next;       // Next pointer
 };
struct HitType
 {
 long XPos,YPos;         // Window offset of button
 long SizeX,SizeY;       // The area that this pressable area covers
 unsigned char *Effect;  // Byte pointer to set if clicked on
 };
struct WindowType
 {
 unsigned char *Virtual;   // Screen Pointer
 long SizeX,SizeY;
 long Changed;                  // Should this window be updated
 unsigned char *Destnation;
 ButtonType *ButtonPointer; // Pointer to linked list of buttons in window
 HitType *HitPointer;
 WindowType *Next;         // All windows are in a linked list 
 };

WindowType *FirstWindow=0;


void PutBitMap(WindowType *WIN,BitMapType *BitMap)
 {
 // Check if PCX is in memory
 if ( BitMap->GFXPointer==0)
  {
  PCXHeader *Temp=new PCXHeader;
  GetPCXInfo(Temp,BitMap->Name);
  BitMap->SizeX=Temp->Xmax-Temp->Xmin+1;
  BitMap->SizeY=Temp->Ymax-Temp->Ymin+1;
  BitMap->GFXPointer= (unsigned char*)calloc(
          (Temp->Xmax-Temp->Xmin+1)*(Temp->Ymax-Temp->Ymin+1),1);
  GetPCXPicture(Temp,BitMap->Name,BitMap->GFXPointer);
  }
 // Copy Picture to window
 unsigned char *Source=BitMap->GFXPointer;
 unsigned char *Destnation=WIN->Virtual+BitMap->XPos+(BitMap->YPos*WIN->SizeX);
 int            Modulo=WIN->SizeX-BitMap->SizeX;
 int i,t;
 for (t=0;t<BitMap->SizeY;t++)
  {
  for (i=0;i<BitMap->SizeX;i++)
   {
   *Destnation++=*Source++;
   }
  Destnation+=Modulo;
  }
 }

void PlotWindow(WindowType *WIN)
 {
 if (WIN->Changed==1)
  {
  WIN->Changed=0;
  unsigned char *Source=WIN->Virtual,
                *Destnation=WIN->Destnation;
  int            Modulo=ScreenX-WIN->SizeX;
  int i,t;
  for (i=0;i<WIN->SizeY;i++)
   {
   for (t=0;t<WIN->SizeX;t++)
     PlotPixel(Destnation++,*Source++);
   Destnation+=Modulo;
   }
  }
 }


void PlotWindows()
 {
 WindowType *WIN=FirstWindow;
 while (WIN!=0)
  {
  PlotWindow(WIN);
  WIN=WIN->Next;
  }
 }

void CopyWindow(WindowType *WIN1,WindowType *WIN2)
 {
 unsigned char *Source=WIN1->Virtual,
               *Destnation=WIN2->Virtual;
 int            Modulo=WIN2->SizeX-WIN1->SizeX;
 int i,t;
 for (i=0;i<WIN1->SizeY;i++)
  {
  for (t=0;t<WIN1->SizeX;t++)
    *Destnation++=*Source++;
  Destnation+=Modulo;
  }
 }

void ClearWindow(WindowType *WIN)
 {
 unsigned char *Destnation=WIN->Virtual;
 int i,t;
 for (i=0;i<WIN->SizeY;i++)
  for (t=0;t<WIN->SizeX;t++)
   *Destnation++=0;
 }

// Remove Window
void RemoveWindow(WindowType *WIN)
 {
 WindowType *Current=FirstWindow;
 if (FirstWindow==WIN)
   FirstWindow=0;
 else
  {
  while (Current->Next!=WIN)
   {
   Current=Current->Next;
   if (Current==0)
     return;
   }
  Current->Next=0;
  }
 }

// NewWindow -- add window to end a linked list
WindowType* NewWindow(int SizeX,int SizeY,int Changed,
                unsigned char *Virtual,unsigned char *Destnation)
 {
 WindowType *Current;
 if (FirstWindow==0)
  {
  FirstWindow=(WindowType*)calloc(sizeof(WindowType),1);
  Current=FirstWindow;
  }
 else
  {
  // Find last entry in list
  Current=FirstWindow;
  while (Current->Next!=0)
    Current=Current->Next;
  Current->Next=(WindowType*)calloc(sizeof(WindowType),1);
  Current=Current->Next;
  }
  Current->SizeX=SizeX;   // Init window definition
  Current->SizeY=SizeY;
  Current->Changed=Changed;
  Current->Virtual=Virtual;
  Current->Destnation=Destnation;
  Current->ButtonPointer=0;
  Current->HitPointer=0;
  Current->Next=0;
 return Current;
 }
















///////////////////////////////////////////////////////////////////////////



void PlotObjectCLIP(BackPlotObject *OBJ,WindowType *WIN)
 {
  // Check if on screen
  if ( OBJ->XPos+OBJ->SizeX<0 || OBJ->XPos>WIN->SizeX ||
       OBJ->YPos+OBJ->SizeY<0 || OBJ->YPos>WIN->SizeY )
    return;
  unsigned char  *Source=OBJ->GFXPointer,
                 *Destnation=WIN->Virtual+OBJ->XPos+OBJ->YPos*WIN->SizeX;
  long            DModulo=WIN->SizeX-OBJ->SizeX;
  long            SModulo=0;
  long SizeX=OBJ->SizeX;
  long SizeY=OBJ->SizeY;
 
  int i,t;
  // Check for clipping
  if ( OBJ->XPos<0 || OBJ->XPos+OBJ->SizeX>WIN->SizeX ||
       OBJ->YPos<0 || OBJ->YPos+OBJ->SizeY>WIN->SizeY )
   {
   if (OBJ->XPos<0)
     {
     SizeX=SizeX+OBJ->XPos;
     Source=Source-OBJ->XPos;
     Destnation-=OBJ->XPos;
     }
    if (OBJ->XPos+OBJ->SizeX>WIN->SizeX )
     SizeX=SizeX- ((OBJ->XPos+OBJ->SizeX)-WIN->SizeX);
   if (OBJ->YPos<0)
     {
     SizeY=SizeY+OBJ->YPos;
     Source=Source- (OBJ->YPos*OBJ->SizeX);
     Destnation-=(OBJ->YPos*WIN->SizeX);
     }
    if (OBJ->YPos+OBJ->SizeY>WIN->SizeY)
     SizeY=SizeY- ((OBJ->YPos+OBJ->SizeY)-WIN->SizeY);
   SModulo=OBJ->SizeX-SizeX;
   DModulo=WIN->SizeX-SizeX;
   }
 
  for(i=0;i<SizeY;i++)
   {
   for(t=0;t<SizeX;t++)
    {
//    PlotPixel2(Destnation++,*Source++);
    *Destnation++=*Source;
    Source++;
    }
   Destnation+=DModulo;
   Source+=SModulo;
   }
 }







void BoxCLIP(WindowType *WIN,int x1,int y1,int x2,int y2,unsigned char col)
 {
 // Check for clipping
 if (x1>x2)
  {  int t=x1;x1=x2;x2=t;  }
 if (y1>y2)
  {  int t=y1;y1=y2;y2=t;  }
 if (x1<0)
  x1=0;
 if (x2<0)
  x2=0;
 if (y1<0)
  y1=0;
 if (y2<0)
  y2=0;

 if (x1>WIN->SizeX)
  x1=WIN->SizeX;
 if (x2>WIN->SizeX)
  x2=WIN->SizeX;
 if (y1>WIN->SizeY)
  y1=WIN->SizeY;
 if (y2>WIN->SizeY)
  y2=WIN->SizeY;

  // Do horiz lines
  unsigned char *Destnation1=WIN->Virtual+x1+(y1*WIN->SizeX);
  unsigned char *Destnation2=WIN->Virtual+x2+(y2*WIN->SizeX);
  int i;
  for (i=x1;i<x2;i++)
    {
    *Destnation1++=col;
    *Destnation2--=col;
    }
  // Do vertical lines
  for (i=y1;i<y2;i++)
    {
    *Destnation1=col;
    *Destnation2=col;
    Destnation1+=WIN->SizeX;
    Destnation2-=WIN->SizeX;
    }
  }





void Box(WindowType *WIN,int x1,int y1,int x2,int y2,unsigned char col)
 {
 // Check for ordering
 if (x1>x2)
  {  int t=x1;x1=x2;x2=t;  }
 if (y1>y2)
  {  int t=y1;y1=y2;y2=t;  }

  // Do horiz lines
  unsigned char *Destnation1=WIN->Virtual+x1+(y1*WIN->SizeX);
  unsigned char *Destnation2=WIN->Virtual+x2+(y2*WIN->SizeX);
  int i;
  for (i=x1;i<x2;i++)
    {
    *Destnation1++=col;
    *Destnation2--=col;
    }
  // Do vertical lines
  for (i=y1;i<y2;i++)
    {
    *Destnation1=col;
    *Destnation2=col;
    Destnation1+=WIN->SizeX;
    Destnation2-=WIN->SizeX;
    }
  }

void FillBox(WindowType *WIN,int x1,int y1,int x2,int y2,unsigned char col)
 {
 // Check for ordering
 if (x1>x2)
  {  int t=x1;x1=x2;x2=t;  }
 if (y1>y2)
  {  int t=y1;y1=y2;y2=t;  }

  // Do horiz lines
  unsigned char *Destnation1=WIN->Virtual+x1+(y1*WIN->SizeX);
  unsigned char *Destnation2;
  int i,t;
  for (t=y1;t<y2;t++)
    {
    Destnation2=Destnation1;
    Destnation1+=WIN->SizeX;
    for (i=x1;i<x2;i++)
      *Destnation2++=col;
    }
  }

void ButtonBox(WindowType *WIN,int x1,int y1,int x2,int y2,
                unsigned char col1,unsigned char col2)
 {
 // Check for ordering
 if (x1>x2)
  {  int t=x1;x1=x2;x2=t;  }
 if (y1>y2)
  {  int t=y1;y1=y2;y2=t;  }

  // Do horiz lines
  unsigned char *Destnation1=WIN->Virtual+x1+(y1*WIN->SizeX);
  unsigned char *Destnation2=WIN->Virtual+x2+(y2*WIN->SizeX);
  int i;
  for (i=x1;i<x2;i++)
    {
    *Destnation1++=col1;
    *Destnation2--=col2;
    }
  // Do vertical lines
  for (i=y1;i<y2;i++)
    {
//    PlotPixel(Destnation1,col2);
//    PlotPixel(Destnation2,col1);
    *Destnation1=col2;
    *Destnation2=col1;
    Destnation1+=WIN->SizeX;
    Destnation2-=WIN->SizeX;
    }
  }

void ButtonBoxD(int x1,int y1,int x2,int y2,
                unsigned char col1,unsigned char col2)
 {
 // Check for ordering
 if (x1>x2)
  {  int t=x1;x1=x2;x2=t;  }
 if (y1>y2)
  {  int t=y1;y1=y2;y2=t;  }

  // Do horiz lines
  unsigned char *Destnation1=Screen+x1+(y1*ScreenX);
  unsigned char *Destnation2=Screen+x2+(y2*ScreenX);
  int i;
  for (i=x1;i<x2;i++)
    {
    PlotPixel2(Destnation1++,col1);
    PlotPixel2(Destnation2--,col2);
//    *Destnation1++=col1;
//    *Destnation2--=col2;
    }
  // Do vertical lines
  for (i=y1;i<y2;i++)
    {
    PlotPixel2(Destnation1,col2);
    PlotPixel2(Destnation2,col1);
//    *Destnation1=col2;
//    *Destnation2=col1;
    Destnation1+=ScreenX;
    Destnation2-=ScreenX;
    }
  }


void PlotLetterD(unsigned char *Destnation,int SizeX,int SizeY,int Modulo,
                unsigned char *Source)
 {
 int i,t;
 for (t=0;t<SizeY;t++)
  {
  for (i=0;i<SizeX;i++)
   {
//   *Destnation++=*(Source++);
   PlotPixel2(Destnation++,*Source++);
   }
  Source+=Modulo;
  Destnation+=ScreenX-SizeX;
  }
 }

void PlotLetterD(unsigned char *Destnation,int SizeX,int SizeY,int Modulo,
                unsigned char *Source, unsigned char col)
 {
 int i,t;
 for (t=0;t<SizeY;t++)
  {
  for (i=0;i<SizeX;i++)
   {
   if (*Source++>0)
//     *Destnation++=col;
     PlotPixel2(Destnation++,col);
   else
//    *Destnation++=0;
     PlotPixel2(Destnation++,0);
   }
  Source+=Modulo;
  Destnation+=ScreenX-SizeX;
  }
 }

// Made for old xavier fonts
//
// Requires font structure
// Header - SizeX,SizeY
// Per Character - SpaceX

void PlotStringD2(int x,int y,char *String)
 {
 unsigned char Letter;
 int FontX,FontY,SizeX,i;

 unsigned char *Source=Font1Data; //=Font Address
 unsigned char *Scan=Font1Set;
 FontX=*Source++;
 FontY=*Source++;
 int FontLetter=FontX*FontY+1;
 unsigned char *Destnation=(unsigned char*)x+y*ScreenX;
 while ((*String)!=0)
  {
  Letter=*String++;
  i=0;
  while (Scan[i]!=Letter)
   {
   i++;
   }
  Letter=i;
  SizeX=Source[Letter*FontLetter];
  PlotLetterD(Destnation,SizeX,FontY,FontX-SizeX,Source+Letter*FontLetter+1);
  Destnation+=SizeX;
  }
 }
  
// Made for Elf fonts
//
void PlotStringD(int x,int y,char *String,unsigned char *Source)
 {
 unsigned char Letter;
 int FontX,FontY,SizeX,i;

// unsigned char *Source=Font1Data; //=Font Address
 FontX=*Source++;
 FontY=*Source++;
 int FontLetter=FontX*FontY+1;
 unsigned char *Destnation=(unsigned char*)x+y*ScreenX;
 while ((*String)!=0)
  {
  Letter=*String++;
  SizeX=Source[Letter*FontLetter];
  PlotLetterD(Destnation,SizeX,FontY,FontX-SizeX,Source+Letter*FontLetter+1);
  Destnation+=SizeX;
  }
 }


void PlotButtonD2(int x,int y,char *String)
 {
 unsigned char Letter;
 int FontX,FontY,SizeX,i;

 unsigned char *Source=Font1Data; //=Font Address
 unsigned char *Scan=Font1Set;
 FontX=*Source++;
 FontY=*Source++;
 int FontLetter=FontX*FontY+1;
 unsigned char *Destnation=(unsigned char*)x+2+(y+2)*ScreenX;
 while ((*String)!=0)
  {
  Letter=*String++;
  i=0;
  while (Scan[i]!=Letter)
   {
   i++;
   }
  Letter=i;
  SizeX=Source[Letter*FontLetter];
  PlotLetterD(Destnation,SizeX,FontY,FontX-SizeX,Source+Letter*FontLetter+1,ButtonFontCol);
  Destnation+=SizeX;
  }
 ButtonBoxD(x,y,(int)Destnation%320+1,y+8,ButtonCol1,ButtonCol2);
 }

void PlotButtonD(int x,int y,char *String,unsigned char *FontAddress)
 {
 unsigned char Letter;
 int FontX,FontY,SizeX,i;

 unsigned char *Source=FontAddress; //=Font Address
 unsigned char *Scan=Font1Set;
 FontX=*Source++;
 FontY=*Source++;
 int FontLetter=FontX*FontY+1;
 unsigned char *Destnation=(unsigned char*)x+2+(y+2)*ScreenX;
 while ((*String)!=0)
  {
  Letter=*String++;
  SizeX=Source[Letter*FontLetter];
  PlotLetterD(Destnation,SizeX,FontY,FontX-SizeX,Source+Letter*FontLetter+1,ButtonFontCol);
  Destnation+=SizeX;
  }
 ButtonBoxD(x,y,(int)Destnation%ScreenX+1,y+FontY+2,ButtonCol1,ButtonCol2);
 }

////////////////////////////////////////////////////////////////////////////
// normal window
void PlotLetter(unsigned char *Destnation,int SizeX,int SizeY,int Modulo,
                int DModulo,unsigned char *Source)
 {
 int i,t;
 for (t=0;t<SizeY;t++)
  {
  for (i=0;i<SizeX;i++)
   {
   *Destnation++=*(Source++);
   }
  Source+=Modulo;
  Destnation+=DModulo;
  }
 }

void PlotLetter(unsigned char *Destnation,int SizeX,int SizeY,int Modulo,
                int DModulo,unsigned char *Source, unsigned char col)
 {
 int i,t;
 for (t=0;t<SizeY;t++)
  {
  for (i=0;i<SizeX;i++)
   {
   if (*Source++>0)
     *Destnation++=col;
   else
     *Destnation++=0;
   }
  Source+=Modulo;
  Destnation+=DModulo;
  }
 }

// Made for Elf fonts
//
void PlotString(WindowType *WIN,int x,int y,char *String,unsigned char *Source)
 {
 unsigned char Letter;
 int FontX,FontY,SizeX,i;

// unsigned char *Source=Font1Data; //=Font Address
 FontX=*Source++;
 FontY=*Source++;
 int FontLetter=FontX*FontY+1;
 unsigned char *Destnation=WIN->Virtual+x+y*WIN->SizeX;
 while ((*String)!=0)
  {
  Letter=*String++;
  SizeX=Source[Letter*FontLetter];
  PlotLetter(Destnation,SizeX,FontY,FontX-SizeX,WIN->SizeX-SizeX,Source+Letter*FontLetter+1);
  Destnation+=SizeX;
  }
 }

void PlotButton(WindowType *WIN,int x,int y,char *String,unsigned char *FontAddress)
 {
 unsigned char Letter;
 int FontX,FontY,SizeX,i;

 unsigned char *Source=FontAddress; //=Font Address
 unsigned char *Scan=Font1Set;
 FontX=*Source++;
 FontY=*Source++;
 int FontLetter=FontX*FontY+1;
 unsigned char *Destnation=WIN->Virtual+x+2+(y+2)*WIN->SizeX;
 while ((*String)!=0)
  {
  Letter=*String++;
  SizeX=Source[Letter*FontLetter];
  PlotLetter(Destnation,SizeX,FontY,FontX-SizeX,WIN->SizeX-SizeX,Source+Letter*FontLetter+1,ButtonFontCol);
  Destnation+=SizeX;
  }
 ButtonBox(WIN,x,y, ((int)Destnation-(int)WIN->Virtual) %WIN->SizeX+1,y+FontY+2,ButtonCol1,ButtonCol2);
 }


