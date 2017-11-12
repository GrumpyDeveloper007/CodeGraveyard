#include <i86.h>
#include <math.h>
#include <conio.h>
//#include <fstream.h>
#include <iostream.h>
#include <time.h>
#include "\coding\include\video\video.h"
#include "\coding\include\other\fixed32.h"
#include "\coding\include\other\pcx.h"
#include "assem.h"

// Tunnel stuff
int startx;
const float MaxX=320;
const float MaxY=200;
const float ScaleHyp=4096;
const int Memory=MaxX*MaxY*2;
const int CopySize=MaxX*MaxY/4;
char *file="graymarb.pcx";
unsigned char SinTable[256];
unsigned char YTable[256];
unsigned char *picture,*circle;
const int CenterX=MaxX/2;
const int CenterY=MaxY/2;


unsigned char *ScreenB;

const float _PI=3.141592654;
float DistanceTable[65536];
unsigned short ScanBufferLeft[200];
unsigned short ScanBufferRight[200];
//unsigned char *Screen=(unsigned char *)0x0a0000;
unsigned char *Texture;

float Ax=160,Ay=5,Bx=300,By=50,Cx=160,Cy=190,Dx=10,Dy=50;
int IAx,IAy,IBx,IBy,ICx,ICy,IDx,IDy;
 int TextureX=64 ,TextureY=64;
 int i,t;

 unsigned char *Buffer1,*Screen;
 unsigned char CurrentPal[256*3];

PCXHeader HeaderInfo;

// Tunnel stuff
 unsigned char pal[256*3];

float GetAngle(float &dx,float &dy)
 {
 if (dx==0)
  return 0;
 if (dy==0)
  return 45;
 if (dx>=dy)             // adj > opp
  return (180*atan(dy/dx))/_PI;
 return (180*atan(dx/dy))/_PI;
 }

// opp/Sin (a) = hyp


float GetHyp(float &dx,float &dy,float &Angle)  // Angle = degrees
 {
 if (dx==0)
  return dy;
 if (dy==0)
  return dx;
 if (dx>=dy)
  return dy/sin(( Angle*_PI/180 ));
 return dx/sin(( Angle*_PI/180 ));
 }

float abs(float val)
 {
 if (val<0)
  return -val;
 return val;
 }

void MakeTable(unsigned char* Table)
 {
 float dx,dy;
 float Angle;
 int i,t;
 float Temp,Temp2;
 for (i=0;i<MaxY;i++)
  {
  dy=abs(i-CenterY);
  for (t=0;t<MaxX;t++)
   {
   dx=abs(t-CenterX);

   Temp=0;
   Temp2=0;
   if (dx>dy)
    Angle=GetAngle(dy,dx);
   else
    Angle=GetAngle(dx,dy);

   if (t>=CenterX && i>=CenterY)
    {
    if (dx>dy)
     Temp=(90+Angle);
    else
     Temp=135+(45-Angle);
    }            
   if (t>CenterX && i<CenterY)
    {
    if (dx>dy)
     Temp=90-(Angle);
    else
     Temp=45-(45-Angle);
    }
   if (t<CenterX && i>CenterY)
    {
    if (dx>dy)
     Temp=180+45+(45-Angle);
    else
     Temp=180+(Angle);
    }
   if (t<=CenterX && i<=CenterY)
    {
    if (dx>dy)
     Temp=270+(Angle);
    else
     Temp=315+(45-Angle);
    }
   Temp2=ScaleHyp/GetHyp(dx,dy,Angle);
   Temp=Temp*256/360;
   *Table++=(unsigned char) Temp2;
   *Table++=(unsigned char) Temp;
   }
  }
 }

void AdjustTable()
 {
 unsigned char *screenT=(unsigned char*)0x0a0000;
 unsigned char *CircleT=(unsigned char*) circle;
 unsigned char *PictureT=(unsigned char *)picture+startx;
 unsigned char temp;
 for(i=0;i<64000;i++)
  {
  CircleT++;
  temp=SinTable[*CircleT];
  CircleT--;
  *CircleT=temp+*CircleT;
  CircleT++;
  CircleT++;
  }
 }

//// end

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

 YMul=(int)A*320;
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
     *ScreenT++=Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )];//&16383];
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=320;
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
     *ScreenT++=Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )];//&16383];
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=320;
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
     *ScreenT++=Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )];//&16383];
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=320;
   SX+=MSX; // Next X line in source
   SY+=MSY; // Next Y line in source
   DX+=MDX;
   DY+=MDY;
   }

 }
void ccopy()
 {
 unsigned int *Source=(unsigned int*)ScreenB;
 unsigned int *Dest=(unsigned int*)Screen;
 int i;
 for (i=0;i<64000/4;i++)
  {
  *Dest++=*Source++;
  }
 }





void main ()
 {
 clock_t Start,End;
 float Frame=0;

  /// tunnel
 ScreenB =new unsigned char[64000];
 picture =new unsigned char[65536*2];
 circle = new unsigned char[Memory]; // wont let me do MaxX*MaxY SHIT

 // Load picture / palette
 GetPCXPicture(&HeaderInfo,file,picture);
 GetPCXPicture2(&HeaderInfo,file,picture+65536,pal);
 MakeTable(circle);
 SetPalette(pal,0,256);

 Screen=(unsigned char*)0x0a0000;
 Buffer1=new unsigned char[65536];

 GetPCXPicture2(&HeaderInfo,"texture.PCX",Buffer1,CurrentPal);


 InitVideo();
 SetPalette(CurrentPal,0,256);

 Start=clock();
 float ax1=20,ay1=-20,bx1=50,by1=50;
 float cx1=-20,cy1=20,dx1=-50,dy1=-50;
 float Angle=0;
  startx=0;

 while(!kbhit())
 {
    PlotTable2();
    startx-=256-1;
    if (startx>=65536)
     startx-=65536;
    if (startx<0)
     startx+=65536;
 Angle+=0.01;
 if (Angle>=_PI*2)
  Angle=0;
// ax1+=1;
// if (ax1>80)
//  ax1=40;
 for(i=0;i<200;i++)     // Initialises Scanbuffer
  {
  ScanBufferLeft[i]=320;
  ScanBufferRight[i]=0;
  }
 Ax=(ax1*sin(Angle)+ay1*cos(Angle))+160;
 Ay=(-ax1*cos(Angle)+ay1*sin(Angle))+100;
 Bx=(bx1*sin(Angle)+by1*cos(Angle))+160;
 By=(-bx1*cos(Angle)+by1*sin(Angle))+100;
 Cx=(cx1*sin(Angle)+cy1*cos(Angle))+160;
 Cy=(-cx1*cos(Angle)+cy1*sin(Angle))+100;
 Dx=(dx1*sin(Angle)+dy1*cos(Angle))+160;
 Dy=(-dx1*cos(Angle)+dy1*sin(Angle))+100;
// Dx=Cx;Dy=Cy;
 IAx=Ax;IAy=Ay;IBx=Bx;IBy=By;ICx=Cx;ICy=Cy;IDx=Dx;IDy=Dy; 
 ScanConvert(IAx,IAy,IBx,IBy);
 ScanConvert(IBx,IBy,ICx,ICy);
 ScanConvert(ICx,ICy,IDx,IDy);
 ScanConvert(IDx,IDy,IAx,IAy);
   TexturePlot();
  ccopy();
    Frame++;
  }

 End=clock();
 KillVideo();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }




