#include <math.h>
#include <fstream.h>
#include <time.h>
#include "\coding\lee\xavstuff\h\vesa.h"
#include "\coding\elfinc\std.h"
extern unsigned char *VESAVirtualScreen;  // Address of virtual screen
extern unsigned char *VESAScreenPtr;      // Address of screen
extern int VESAScreenLength;              // Length of screen / 4

#include "\coding\lee\XavStuff\h\fixed32.h"
#include "\coding\lee\XavStuff\h\pcx.h"
#include "assem.h"

char TextureName[]="texture.pcx";
int TextureX=64 ,TextureY=64;

int kbhit2();
#pragma aux kbhit2 =   \
        "mov     ax,0x0B00"\
        "int     0x21"   \
        "cbw"          \
        "cwde"         \
		value [eax]             \

void PlotPixel(unsigned char *Offset,char Col);
#pragma aux PlotPixel = \
            "mov fs:[edi],al" \
            parm caller [edi] [al];

// Tunnel stuff
int startx;
const int MaxX=640;
const int MaxY=480;


unsigned char *ScreenB;

 const float _PI=3.141592654;
 float DistanceTable[65536];
 unsigned short ScanBufferLeft[MaxY];
 unsigned short ScanBufferRight[MaxY];
 unsigned char *Screen;
 unsigned char *Texture;

 float Ax,Ay,Bx,By,Cx,Cy,Dx,Dy;
 int IAx,IAy,IBx,IBy,ICx,ICy,IDx,IDy;
 int i,t;

 unsigned char *Buffer1;
 unsigned char CurrentPal[256*3];

PCXHeader HeaderInfo;

void ScanConvert(int x1,int y1,int x2,int y2)   // To convert standard poly {
 {
 Fixed mx;   // slope of x
 Fixed temp; // for swapping
 Fixed x,y;  // source x and y screen coordinates
 int TempX;  // Dark

 if(y1 > y2) // make sure that edge goes from top to bottom
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;
  }

 if(y2!=y1 ) // initialize the slopes for stepping the edges
  mx = (Int2Fixed(x2-x1)) / (y2-y1); // dx/dy

 x=Int2Fixed(x1);
 for(y=y1;y<=y2;y++)
  {
   TempX=Fixed2Int(x);
   if (TempX<ScanBufferLeft[y])
     ScanBufferLeft[y]=TempX;
   if (TempX>ScanBufferRight[y])
     ScanBufferRight[y]=TempX;
  x+=mx;
  }
 }

// Lots of revisions in this code
//
//


void TexturePlot()
 {
 unsigned char *ScreenT=Screen;
 int i, t;
 int YMul;
 char TYPE,TYPE2;
 int A, B, C, D; // Y values of points (Orded)
 short StartX, EndX;
 float SX, SY, DX, DY;
 int DXStep;
 Fixed GXF,GYF,MGXF,MGYF;
 float MSX, MSY, MDX, MDY;

// Fixed SXF,SYF,DXF,DYF;
// Fixed MSXF,MSYF,MDXF,MDYF;
 A=IAy;B=IBy;C=ICy;D=IDy;
 if (A>B)
  { i=A;A=B;B=i;}
 if (B>C)
  { i=B;B=C;C=i;}
 if (C>D)
  { i=C;C=D;D=i;}
 if (A>B)
  { i=A;A=B;B=i;}
 if (B>C)
  { i=B;B=C;C=i;}
 if (A>B)
  { i=A;A=B;B=i;}
 TYPE2=0;
 if (IAy<=IBy && IAy<=ICy && IAy<=IDy)
  { SX=0;SY=0;TYPE=1;
  MSX=TextureX/(float)(IBy-IAy); // Source in source gradient
  MSY=0;
  MDX=0;                // Destnation in source gradient
  MDY=TextureY/(float)(IDy-IAy);
  if (IBy==D)
    TYPE2=1;
  if (IDy==D)
    TYPE2=2;
  }
 else
   if (ICy<=IAy && ICy<=IBy && ICy<=IDy)
    { SX=TextureX; SY=TextureY; TYPE=2;
    MSX=-(TextureX/(float)(IDy-ICy)); // Source in source gradient
    MSY=0;
    MDX=0;                // Destnation in source gradient
    MDY=-(TextureY/(float)(IBy-ICy));
  if (IDy==D)
    TYPE2=1;
  if (IBy==D)
    TYPE2=2;
    }
   else
     if (IBy<IAy && IBy<ICy && IBy<IDy)
      { SX=TextureX; SY=0; TYPE=3;
  MSX=0; // Source in source gradient
  MSY=(TextureY/(float)(ICy-IBy));
  MDX=-(TextureX/(float)(IAy-IBy));                // Destnation in source gradient
  MDY=0;
  if (ICy==D)
    TYPE2=1;
  if (IAy==D)
    TYPE2=2;
      }
      else
//      if (IDy<IAy && IDy<IBy && IDy<ICy)
        { SX=0; SY=TextureY;TYPE=4;
  MSX=0; // Source in source gradient
  MSY=-(TextureY/(float)(IAy-IDy));
  MDX=(TextureX/(float)(ICy-IDy));                // Destnation in source gradient
  MDY=0;
  if (IAy==D)
    TYPE2=1;
  if (ICy==D)
    TYPE2=2;
        }
 DX=SX;DY=SY;

 YMul=(int)A*MaxX;
// SXF=Float2Fixed(SX);
// SYF=Float2Fixed(SY);
// DXF=Float2Fixed(DX);
// DYF=Float2Fixed(SY);

// MSXF=Float2Fixed(MSX);
// MSYF=Float2Fixed(MSY);
// MDXF=Float2Fixed(MDX);
// MDYF=Float2Fixed(MSY);

 for(i=A;i<B;i++)
   {
   StartX=ScanBufferLeft[i];
   EndX=ScanBufferRight[i];
   DXStep=EndX-StartX; // M1=length of line in destnation
   GXF=Float2Fixed(DX);
   GYF=Float2Fixed(DY);
   MGXF=Float2Fixed(((SX-DX)/DXStep));
   MGYF=Float2Fixed(((SY-DY)/DXStep));
   ScreenT=ScreenB+YMul+StartX;
   for(t=0;t<DXStep;t++)
     {
     PlotPixel(ScreenT++,Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )]);//&16383];
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=MaxX;
   SX+=MSX; // Next X line in source
   SY+=MSY; // Next Y line in source
   DX+=MDX;
   DY+=MDY;
   }

  if (TYPE==1)
   {
   if (B==IBy)  // Check right edge
    { SX=TextureX;SY=0;MSX=0;MSY=(TextureY/(Cy-By)); }
   if (B==IDy)  // Check left edge
    { DX=0;DY=TextureY;MDX=(TextureX/(Cy-Dy));MDY=0; }
   }

  if (TYPE==2)
   {
   if (B==IDy)
    { SX=0;SY=TextureY;MSX=0;MSY=-(TextureY/(Ay-Dy)); }
   if (B==IBy)
    { DX=TextureX;DY=0;MDX=-(TextureX/(Ay-By));MDY=0; }
   }

  if (TYPE==3)
   {
   if (B==ICy)
    { SX=TextureX;SY=TextureY;MSX=-(TextureY/(Dy-Cy));MSY=0; }
   if (B==IAy)
    { DX=0;DY=0;MDX=0;MDY=TextureY/(Dy-Ay); }
   }

  if (TYPE==4)
   {
   if (B==IAy)
    { SX=0;SY=0;MSX=TextureX/(By-Ay);MSY=0;}
   if (B==ICy)
    { DX=TextureX;DY=TextureY;MDX=0;MDY=-(TextureX/(By-Cy)); }
   }
 for(i=B;i<C;i++)
   {
   StartX=ScanBufferLeft[i];
   EndX=ScanBufferRight[i];
   DXStep=EndX-StartX; // M1=length of line in destnation
   GXF=Float2Fixed(DX);
   GYF=Float2Fixed(DY);
   MGXF=Float2Fixed(((SX-DX)/DXStep));
   MGYF=Float2Fixed(((SY-DY)/DXStep));
   ScreenT=ScreenB+YMul+StartX;
   for(t=0;t<DXStep;t++)
     {
     PlotPixel(ScreenT++,Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )]);//&16383]);
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=MaxX;
   SX+=MSX; // Next X line in source
   SY+=MSY; // Next Y line in source
   DX+=MDX;
   DY+=MDY;
   }
// If type2==0 regular polygon
// IF type2==1 DX= all change in gradients
// If type2==2 SX= all change in gradients

 if (TYPE2==1)
  {
  if (TYPE==1)
   {
    DX=TextureX;DY=TextureY;MDX=0;MDY=-TextureY/(By-Cy);
   }
 
  if (TYPE==2)
   {
     DX=0;DY=0;MDX=0;MDY=(TextureY/(Dy-Ay));
   }
 
  if (TYPE==3)
   {
     DX=0;DY=TextureY;MDX=(TextureY/(Cy-Dy));MDY=0;
   }
 
  if (TYPE==4)
   {
    DX=TextureX;DY=0;MDX=-TextureX/(Ay-By);MDY=0;
   }
  }


 if (TYPE2==2)
  {
  if (TYPE==1)
   {
     SX=TextureX;SY=TextureY;MSX=-TextureX/(Dy-Cy);MSY=0;
   }
 
  if (TYPE==2)
   {
     SX=0;SY=0;MSX=(TextureX/(By-Ay));MSY=0;
   }
 
  if (TYPE==3)
   {
     SX=0;SY=TextureY;MSX=0;MSY=-TextureY/(Ay-Dy);
   }
 
  if (TYPE==4)
   {
     SX=TextureX;SY=0;MSX=0;MSY=(TextureX/(Cy-By));
   }
  }


 if (TYPE2==0)
  {
  if (TYPE==1)
   {
   if (C==IBy)  // Check right edge
    { SX=TextureX;SY=0;MSX=0;MSY=TextureY/(Cy-By);}
   if (C==IDy)  // Check left edge
    { DX=0;DY=TextureY;MDX=TextureX/(Cy-Dy);MDY=0;}
   }
 
  if (TYPE==2)
   {
   if (C==IDy)
    { SX=0;SY=TextureY;MSX=0;MSY=-(TextureY/(Ay-Dy));}
   if (C==IBy)
    { DX=TextureX;DY=0;MDX=-(TextureX/(Ay-By));MDY=0;}
   }
 
  if (TYPE==3)
   {
   if (C==ICy)
    { SX=TextureX;SY=TextureY;MSX=-(TextureY/(Dy-Cy));MSY=0;}
   if (C==IAy)
    { DX=0;DY=0;MDX=0;MDY=TextureY/(Dy-Ay);}
   }
 
  if (TYPE==4)
   {
   if (C==IAy)
    { SX=0;SY=0;MSX=TextureX/(By-Ay);MSY=0;}
   if (C==ICy)
    { DX=TextureX;DY=TextureY;MDX=0;MDY=-(TextureX/(By-Cy));}
   }
  }

 for(i=C;i<D;i++)
   {
   StartX=ScanBufferLeft[i];
   EndX=ScanBufferRight[i];
   DXStep=EndX-StartX; // M1=length of line in destnation
   GXF=Float2Fixed(DX);
   GYF=Float2Fixed(DY);
   MGXF=Float2Fixed(((SX-DX)/DXStep));
   MGYF=Float2Fixed(((SY-DY)/DXStep));
   ScreenT=ScreenB+YMul+StartX;
   for(t=0;t<DXStep;t++)
     {
     PlotPixel(ScreenT++,Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )]);//&16383]);
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=MaxX;
   SX+=MSX; // Next X line in source
   SY+=MSY; // Next Y line in source
   DX+=MDX;
   DY+=MDY;
   }

 }
float PA1X=20,PA1Y=-20;
float PA2X=20,PA2Y=20;
float PA3X=-20,PA3Y=20;
float PA4X=-20,PA4Y=-20;

float PA5X=PA2X-20,PA5Y=PA2Y+20;
float PA6X=PA3X-20,PA6Y=PA3Y+20;
float PA7X=PA4X-20,PA7Y=PA4Y+20;

float op=40;
float oq=-40;
float og=40;
float oh=40;


const float Scale=(MaxY/2)/120;
int Arr;
int Polygons=7;
float Aax[]={-70,PA1X+og,PA2X+og,PA3X+og  ,PA1X+op,PA2X+op,PA3X+op};
float Aay[]={-70,PA1Y+oh,PA2Y+oh,PA3Y+oh ,PA1Y+oq,PA2Y+oq,PA3Y+oq};

float Abx[]={70,PA2X+og,PA5X+og,PA6X+og  ,PA2X+op,PA5X+op,PA6X+op};
float Aby[]={-70,PA2Y+oh,PA5Y+oh,PA6Y+oh   ,PA2Y+oq,PA5Y+oq,PA6Y+oq};

float Acx[]={70,PA3X+og,PA6X+og,PA7X+og ,PA3X+op,PA6X+op,PA7X+op};
float Acy[]={70,PA3Y+oh,PA6Y+oh,PA7Y+oh   ,PA3Y+oq,PA6Y+oq,PA7Y+oq};

float Adx[]={-70,PA4X+og,PA3X+og,PA4X+og  ,PA4X+op,PA3X+op,PA4X+op};
float Ady[]={70,PA4Y+oh,PA3Y+oh,PA4Y+oh  ,PA4Y+oq,PA3Y+oq,PA4Y+oq};

 clock_t Start,End;
 float Frame=0;

void main ()
 {
 Buffer1=new unsigned char[65536];
 Clear(Buffer1,65536);
 GetPCXInfo(&HeaderInfo,TextureName);
 GetPCXPicture(&HeaderInfo,TextureName,Buffer1);
 GetPCXPalette(&HeaderInfo,TextureName,CurrentPal);

 InitVESA();
 ModeInfoBlock SetMode;
 SetMode.NumberOfPlanes=1;
 SetMode.BitsPerPixel=8;
 SetMode.XResolution=MaxX;
 SetMode.YResolution=MaxY;
 SetMode.MemoryModel=MODEL_PACKED;
 SetVideo(&SetMode);
 SetPalette(CurrentPal,0,256);
 ScreenB=VESAScreenPtr;      // Address of screen

 Start=clock();
 float Angle=0;
 startx=0;
 VESACLS();
 VESAUpdateScreen();
 VESACLS();


 while(!kbhit2())
 {
 Angle+=0.01;
 if (Angle>=_PI*2)
  Angle=0;
 for(Arr=0;Arr<Polygons;Arr++)
 {
  for(i=0;i<MaxY;i++)     // Initialises Scanbuffer
   {
   ScanBufferLeft[i]=MaxX;
   ScanBufferRight[i]=0;
   }
  Ax=(Aax[Arr]*Scale*sin(Angle)+Aay[Arr]*Scale*cos(Angle))+MaxX/2;
  Ay=(-Aax[Arr]*Scale*cos(Angle)+Aay[Arr]*Scale*sin(Angle))+MaxY/2;
  Bx=(Abx[Arr]*Scale*sin(Angle)+Aby[Arr]*Scale*cos(Angle))+MaxX/2;
  By=(-Abx[Arr]*Scale*cos(Angle)+Aby[Arr]*Scale*sin(Angle))+MaxY/2;
  Cx=(Acx[Arr]*Scale*sin(Angle)+Acy[Arr]*Scale*cos(Angle))+MaxX/2;
  Cy=(-Acx[Arr]*Scale*cos(Angle)+Acy[Arr]*Scale*sin(Angle))+MaxY/2;
  Dx=(Adx[Arr]*Scale*sin(Angle)+Ady[Arr]*Scale*cos(Angle))+MaxX/2;
  Dy=(-Adx[Arr]*Scale*cos(Angle)+Ady[Arr]*Scale*sin(Angle))+MaxY/2;
  IAx=Ax;IAy=Ay;IBx=Bx;IBy=By;ICx=Cx;ICy=Cy;IDx=Dx;IDy=Dy; 
  ScanConvert(IAx,IAy,IBx,IBy);
  ScanConvert(IBx,IBy,ICx,ICy);
  ScanConvert(ICx,ICy,IDx,IDy);
  ScanConvert(IDx,IDy,IAx,IAy);
  ScreenB=VESAVirtualScreen;      // Address of screen
  TexturePlot();
  }
  VESAUpdateScreen();
  VESACLS();
  Frame++;
  }

 End=clock();
 KillVESA();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }




