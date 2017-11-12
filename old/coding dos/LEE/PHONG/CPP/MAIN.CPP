/*

   Phong Shading attempt one !

    Theory - Angle between light and each edge of polygon is interpolated
            across the surface. Colour is determined from angle! 

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <math.h>
#include <conio.h>
#include <stdio.h>
#include <dos.h>
#include <iostream.h>
#include <time.h>
#include <i86.h>
#include <stdlib.h>

#include "..\XavStuff\h\video.h"
#include "..\XavStuff\h\fixed32.h"
#include "..\XavStuff\h\pcx.h"
unsigned char *ScreenTemp;
unsigned char *GFXPointer=(unsigned char*)0x0a0000;//=Map->Graphic[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];
#include "assem.h"
#include "..\XavStuff\h\tree.h"
#include "h\3dstruct.h"
#include "h\defines.h"

ParseBlock *Parse(char *FileName);

float Perspective=512;   //WINBOTTOM-WINTOP;
float InvPerspective=-Perspective;

unsigned char LightTables[255][256];     // NB last 32 cols are reserved
ParseBlock *Map;
extern PCXHeader HeaderInfo;

void ScanConvEdgeWin(Fixed x1,Fixed y1,Fixed x2,Fixed y2);
void PolygonPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);

void (*DrawTable[])(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)=
               {PolygonPlot,
               };

float Sin[360],Cos[360];	// sin & cos based on degrees not rads!
int LightDistY[641],LightDistX[641];

int PhongShadeTable[360];    // light level for an angle
int PhongShadeTable2[360];      // second buffer for overrun

int *DistY=&LightDistY[320],*DistX=&LightDistX[320];    // Quick PTRS
Fixed AngleLeft[200],AngleRight[200];

extern short ScanBufferLeft[200],ScanBufferRight[200];   // For converting polygons!
extern short YMin,YMax;
////////////////////////////////////////////////////////////////

void TexturePlot2(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float a,b,c;
 float u,v;
 int j,n,i;

 float Ax,Ay,Bx,By,Cx,Cy,Dx,Dy;
 int IAx,IAy,IBx,IBy,ICx,ICy,IDx,IDy;
 unsigned char *ScreenT=VirtualScreen;
 unsigned char *ScreenB=VirtualScreen;
 int  t;
 int YMul;
 char TYPE,TYPE2;
 int A, B, C, D; // Y values of points (Orded)
 short StartX, EndX;
 float SX, SY, DX, DY;
 int DXStep;
 Fixed GXF,GYF,MGXF,MGYF;
 float MSX, MSY, MDX, MDY;
 int TextureX,TextureY;


 unsigned char *GFXPointer=Map->Graphic[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

 ClearScanBuffer(); // Initiate scanbuffers

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWin(Vertices[j].sx,Vertices[j].sy,Vertices[n].sx,Vertices[n].sy);
  if (n==0)
   { Ax=Vertices[j].sx;Ay=Vertices[j].sy;Bx=Vertices[n].sx;By=Vertices[n].sy;}
  if (n==2)
   { Cx=Vertices[j].sx;Cy=Vertices[j].sy;Dx=Vertices[n].sx;Dy=Vertices[n].sy;}
  j=n;
  }
 IAx=Ax;IAy=Ay;
 IBx=Bx;IBy=By;
 ICx=Cx;ICy=Cy;
 IDx=Dx;IDy=Dy;
 
 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 int Cu,Cv;
 int THeight=Polygon->Texture->Height;
 int TWidth=Polygon->Texture->Width;
 int XMask=Polygon->Texture->Width-1;
 int YMask=Polygon->Texture->Height-1;
 int OffX=Polygon->TextOffX;
 int OffY=Polygon->TextOffY;

 TextureX=64;
 TextureY=64;

 unsigned char *Buffer1=GFXPointer;
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










////////////////////////////////////
void MakeTables()       // Creates the Sin & Cos tables + dist tables
 {
 for (int a=90;a<=270;a++)
  {
  PhongShadeTable[a]=0;      // no light in those angles
  PhongShadeTable2[a]=0;      // no light in those angles
  }

 for (a=1;a<90;a++)
  {
  PhongShadeTable[a]=180-a*2;     // light levels (SHOULD BE A PHONG CURVEY THING)
  PhongShadeTable2[a]=180-a*2;     // light levels (SHOULD BE A PHONG CURVEY THING)
  }

 PhongShadeTable[0]=184;//254;       // phong spot (angle 0)
 PhongShadeTable2[0]=184;//254;

 for (a=271;a<360;a++)
  {
  PhongShadeTable[a]=180-(359-a)*2;
  PhongShadeTable2[a]=180-(359-a)*2;
  }

 for (a=-320;a<=320;a++)
  {
  if (a<0)
   {
   LightDistY[a+320]=-(a>>1);
   LightDistX[a+320]=254+(a>>1);
   }
  else
   {
   LightDistY[a+320]=a>>1;
   LightDistX[a+320]=254-(a>>1);
   }
  }

 for (int Loop=0;Loop<360;Loop++)
  {
  Sin[Loop]=sin((Loop*M_PI)/180);
  Cos[Loop]=cos((Loop*M_PI)/180);
  }
 }

short FindClosestRGB(short Red,short Green,short Blue,unsigned char *Palette)
 {
 long DiffPal,Val1,Val2,Val3;                           
 unsigned long ClosestDif,ClosestCol;

 ClosestDif=-1;      // furthest away possible!

 for (int a=0;a<256;a++)
  {
  Val1=Red-Palette[a*3+0];
  if (Val1<0)
   Val1*=-1;
  Val2=Green-Palette[a*3+1];
  if (Val2<0)
   Val2*=-1;
  Val3=Blue-Palette[a*3+2];
  if (Val3<0)
   Val3*=-1;
  DiffPal=Val1+Val2+Val3;
  if (DiffPal<ClosestDif)
   {
   ClosestDif=DiffPal;
   ClosestCol=a;
   }
  }
 return ClosestCol;
 }

void BuildLightTables()
 {
// Ive fudged this routine for the shadow cos the light table is
// really simple

 int temp;

 for (int a=0;a<255;a++)
  {
  for (int b=0;b<256;b++)
   {
   temp=b-(254-a)/1.5;
   if (temp<0)
    temp=0;
   LightTables[a][b]=temp;
   }
  }


/* int red,green,blue,col;
 for (int a=0;a<255;a++)
  {
  for (int b=0;b<256;b++)       // for all colours
   {
   red=Map->Palette[b*3+0]-(254-a)/4;   // reduce colour intensity
   green=Map->Palette[b*3+1]-(254-a)/4;
   blue=Map->Palette[b*3+2]-(254-a)/4;
   if (red<0)
    red=0;
   if (green<0)
    green=0;
   if (blue<0)
    blue=0;
   col=FindClosestRGB(red,green,blue,Map->Palette);
   LightTables[a][b]=col;
   }
  }*/
 }

// (PS verts Must be referenced clockwise to be visible)

void CalculateNormals(ObjectTYPE *Object)
 {
 double x1,x2,x3,y1,y2,y3,z1,z2,z3,xlen,ylen,zlen,length;
 int i,j,k;
 int count;

 PolygonTYPE *Polygon=Object->PolygonList;

 // first calculate the polygon normals
 for(i=0;i < Object->NumOfPolygons; i++,Polygon++)
  {
  x1=Polygon->Vertex[0]->ox;
  x2=Polygon->Vertex[1]->ox;
  x3=Polygon->Vertex[2]->ox;
  y1=Polygon->Vertex[0]->oy;
  y2=Polygon->Vertex[1]->oy;
  y3=Polygon->Vertex[2]->oy;
  z1=Polygon->Vertex[0]->oz;
  z2=Polygon->Vertex[1]->oz;
  z3=Polygon->Vertex[2]->oz;

  // calculate perpendicular via the cross product of 1st vertex & normal
  xlen = (y1-y2)*(z1-z3) - (z1-z2)*(y1-y3);
  ylen = (z1-z2)*(x1-x3) - (x1-x2)*(z1-z3);
  zlen = (x1-x2)*(y1-y3) - (y1-y2)*(x1-x3);

  // calculate the length of the normal
  length = sqrt(xlen*xlen + ylen*ylen + zlen*zlen);

  // scale it to a unit normal
  Polygon->Nx = xlen / length;
  Polygon->Ny = ylen / length;
  Polygon->Nz = zlen / length;
  }
 }

// This calculates psuedo normals - basicly the average of the normals
// from the faces adjoining a particular vertex.

void CalculatePsuedoNormals(ObjectTYPE *Object)
 {
 float Count,Length,XLen,YLen,ZLen;

 VertexTYPE *Vertex=Object->VertexList;

 for (int a=0;a<Object->NumOfVertices;a++)
  {
  Count=0;
  XLen=0;
  YLen=0;
  ZLen=0;

  // Find all polygons vertex belongs to

  PolygonTYPE *Polygon=Object->PolygonList;
  for (int b=0;b<Object->NumOfPolygons;b++)
   {
   for (int c=0;c<Polygon->NumVertices;c++)
    {
    if (Polygon->Vertex[c]==Vertex)     // Pointers == same point
     {
     XLen+=Polygon->Nx; // prepare for averaging normals
     YLen+=Polygon->Ny;
     ZLen+=Polygon->Nz;
     Count++;
     }
    }
   Polygon++;   // check next polygon
   }

  if (Count>0)  // just incase vertex not used ?? light maybe
   {
   XLen/=Count;
   YLen/=Count;
   ZLen/=Count;
   }
  Length=sqrt(XLen*XLen+YLen*YLen+ZLen*ZLen); // pythagorus

  Vertex->Nx=XLen/Length;       // must be a unit normal for maths!
  Vertex->Ny=YLen/Length;
  Vertex->Nz=ZLen/Length;

  Vertex++;
  }
 }

void Transform(CameraTYPE *Camera,ObjectTYPE *Object,int A4,int A5,int A6) // Takes a pointer to the object
 {
 float SS,CS,XX,XY,XZ,YX,YY,YZ,ZX,ZY,ZZ;
 float SA1,SA2,SA3,CA1,CA2,CA3;
 float SS2,CS2,XX2,XY2,XZ2,YX2,YY2,YZ2,ZX2,ZY2,ZZ2;
 float SA12,SA22,SA32,CA12,CA22,CA32;
 int A1,A2,A3,count;
 float Ox,Oy,Oz;
 VertexTYPE *VertexPointer;

 if (Object->ObjectType!=OBJECT_SECTOR) // prepare own rotate matrix
  {
  SA12=Sin[Object->Ax];   // Get All the Sin & Cos values to save on some
  SA22=Sin[Object->Ay];      // indexing on arrays... <NOT A LOT THO!>
  SA32=Sin[Object->Az];
  CA12=Cos[Object->Ax];
  CA22=Cos[Object->Ay];
  CA32=Cos[Object->Az];
  SS2=SA32*SA22;    // Precalculate some magic numbers for faster rotate
  CS2=CA32*SA22;
  XX2=CA22*CA12;
  XY2=CA22*SA12;
  XZ2=SA22;
  YX2=CA32*SA12+SS2*CA12;
  YY2=-CA32*CA12+SS2*SA12;
  YZ2=-SA32*CA22;
  ZX2=SA32*SA12-CS2*CA12;
  ZY2=-SA32*CA12-CS2*SA12;
  ZZ2=CA32*CA22;
  }

 Ox=Object->Ox;
 Oy=Object->Oy;
 Oz=Object->Oz;

 A1=Camera->Ax;     // Get rotate X angle (e.g. 3 degrees)
 A2=Camera->Ay;     // Get rotate Y angle
 A3=Camera->Az;     // Get rotate Z angle

 SA1=Sin[A1];	// Get All the Sin & Cos values to save on some
 SA2=Sin[A2];      // indexing on arrays... <NOT A LOT THO!>
 SA3=Sin[A3];
 CA1=Cos[A1];
 CA2=Cos[A2];
 CA3=Cos[A3];
 SS=SA3*SA2;	// Precalculate some magic numbers for faster rotate
 CS=CA3*SA2;
 XX=CA2*CA1;
 XY=CA2*SA1;
 XZ=SA2;
 YX=CA3*SA1+SS*CA1;
 YY=-CA3*CA1+SS*SA1;
 YZ=-SA3*CA2;
 ZX=SA3*SA1-CS*CA1;
 ZY=-SA3*CA1-CS*SA1;
 ZZ=CA3*CA2;

 Camera->Xwx=XX*Camera->Xx+XY*Camera->Xy+XZ*Camera->Xz;
 Camera->Xwy=YX*Camera->Xx+YY*Camera->Xy+YZ*Camera->Xz;
 Camera->Xwz=ZX*Camera->Xx+ZY*Camera->Xy+ZZ*Camera->Xz;
 Camera->Ywx=XX*Camera->Yx+XY*Camera->Yy+XZ*Camera->Yz;
 Camera->Ywy=YX*Camera->Yx+YY*Camera->Yy+YZ*Camera->Yz;
 Camera->Ywz=ZX*Camera->Yx+ZY*Camera->Yy+ZZ*Camera->Yz;
 Camera->Zwx=XX*Camera->Zx+XY*Camera->Zy+XZ*Camera->Zz;
 Camera->Zwy=YX*Camera->Zx+YY*Camera->Zy+YZ*Camera->Zz;
 Camera->Zwz=ZX*Camera->Zx+ZY*Camera->Zy+ZZ*Camera->Zz;

 VertexPointer=Object->VertexList;	// Get pointer to make things faster

 SA1=Sin[A4];	// Get All the Sin & Cos values to save on some
 SA2=Sin[A5];      // indexing on arrays... <NOT A LOT THO!>
 SA3=Sin[A6];
 CA1=Cos[A4];
 CA2=Cos[A5];
 CA3=Cos[A6];
 SS=SA3*SA2;	// Precalculate some magic numbers for faster rotate
 CS=CA3*SA2;
 XX=CA2*CA1;
 XY=CA2*SA1;
 XZ=SA2;
 YX=CA3*SA1+SS*CA1;
 YY=-CA3*CA1+SS*SA1;
 YZ=-SA3*CA2;
 ZX=SA3*SA1-CS*CA1;
 ZY=-SA3*CA1-CS*SA1;
 ZZ=CA3*CA2;

 VertexTYPE Temp,Temp2;

 if (Object->ObjectType!=OBJECT_SECTOR)
  {
  for (count=0;count<Object->NumOfVertices;count++)
   {
   Temp.wx=VertexPointer->ox*XX2+VertexPointer->oy*XY2+VertexPointer->oz*XZ2;
   Temp.wy=VertexPointer->ox*YX2+VertexPointer->oy*YY2+VertexPointer->oz*YZ2;
   Temp.wz=VertexPointer->ox*ZX2+VertexPointer->oy*ZY2+VertexPointer->oz*ZZ2;

   // Rotate points by using dot product!!!! ;-)
   // This looks awful but should work in theory!

   Temp2.wx=Camera->Xwx*(Temp.wx+Ox-Camera->Ox)+Camera->Xwy*(Temp.wy+Oy-Camera->Oy)+Camera->Xwz*(Temp.wz+Oz-Camera->Oz);
   Temp2.wy=Camera->Ywx*(Temp.wx+Ox-Camera->Ox)+Camera->Ywy*(Temp.wy+Oy-Camera->Oy)+Camera->Ywz*(Temp.wz+Oz-Camera->Oz);
   Temp2.wz=Camera->Zwx*(Temp.wx+Ox-Camera->Ox)+Camera->Zwy*(Temp.wy+Oy-Camera->Oy)+Camera->Zwz*(Temp.wz+Oz-Camera->Oz);

   VertexPointer->wx=XX*Temp2.wx+XY*Temp2.wy+XZ*Temp2.wz;
   VertexPointer->wy=YX*Temp2.wx+YY*Temp2.wy+YZ*Temp2.wz;
   VertexPointer->wz=ZX*Temp2.wx+ZY*Temp2.wy+ZZ*Temp2.wz;

   Temp.wx=VertexPointer->Nx*XX2+VertexPointer->Ny*XY2+VertexPointer->Nz*XZ2;
   Temp.wy=VertexPointer->Nx*YX2+VertexPointer->Ny*YY2+VertexPointer->Nz*YZ2;
   Temp.wz=VertexPointer->Nx*ZX2+VertexPointer->Ny*ZY2+VertexPointer->Nz*ZZ2;

   // Rotate points by using dot product!!!! ;-)
   // This looks awful but should work in theory!

   Temp2.wx=Camera->Xwx*Temp.wx+Camera->Xwy*Temp.wy+Camera->Xwz*Temp.wz;
   Temp2.wy=Camera->Ywx*Temp.wx+Camera->Ywy*Temp.wy+Camera->Ywz*Temp.wz;
   Temp2.wz=Camera->Zwx*Temp.wx+Camera->Zwy*Temp.wy+Camera->Zwz*Temp.wz;

   VertexPointer->Nwx=XX*Temp2.wx+XY*Temp2.wy+XZ*Temp2.wz;
   VertexPointer->Nwy=YX*Temp2.wx+YY*Temp2.wy+YZ*Temp2.wz;
   VertexPointer->Nwz=ZX*Temp2.wx+ZY*Temp2.wy+ZZ*Temp2.wz;

   VertexPointer++;              // Goto next vertex
   }
  }
 else
  {
  for (count=0;count<Object->NumOfVertices;count++)
   {
   // Rotate points by using dot product!!!! ;-)
   // This looks awful but should work in theory!

   Temp.wx=Camera->Xwx*(VertexPointer->ox+Ox-Camera->Ox)+Camera->Xwy*(VertexPointer->oy+Oy-Camera->Oy)+Camera->Xwz*(VertexPointer->oz+Oz-Camera->Oz);
   Temp.wy=Camera->Ywx*(VertexPointer->ox+Ox-Camera->Ox)+Camera->Ywy*(VertexPointer->oy+Oy-Camera->Oy)+Camera->Ywz*(VertexPointer->oz+Oz-Camera->Oz);
   Temp.wz=Camera->Zwx*(VertexPointer->ox+Ox-Camera->Ox)+Camera->Zwy*(VertexPointer->oy+Oy-Camera->Oy)+Camera->Zwz*(VertexPointer->oz+Oz-Camera->Oz);

   VertexPointer->wx=XX*Temp.wx+XY*Temp.wy+XZ*Temp.wz;
   VertexPointer->wy=YX*Temp.wx+YY*Temp.wy+YZ*Temp.wz;
   VertexPointer->wz=ZX*Temp.wx+ZY*Temp.wy+ZZ*Temp.wz;

   VertexPointer++;              // Goto next vertex
   }
  }

 PolygonTYPE *PolygonPointer=Object->PolygonList;

 if (Object->ObjectType!=OBJECT_SECTOR)
  {
  for (count=0;count<Object->NumOfPolygons;count++) // rotate poly normals
   {
   Temp.wx=PolygonPointer->Nx*XX2+PolygonPointer->Ny*XY2+PolygonPointer->Nz*XZ2;
   Temp.wy=PolygonPointer->Nx*YX2+PolygonPointer->Ny*YY2+PolygonPointer->Nz*YZ2;
   Temp.wz=PolygonPointer->Nx*ZX2+PolygonPointer->Ny*ZY2+PolygonPointer->Nz*ZZ2;

   Temp2.wx=Camera->Xwx*Temp.wx+Camera->Xwy*Temp.wy+Camera->Xwz*Temp.wz;
   Temp2.wy=Camera->Ywx*Temp.wx+Camera->Ywy*Temp.wy+Camera->Ywz*Temp.wz;
   Temp2.wz=Camera->Zwx*Temp.wx+Camera->Zwy*Temp.wy+Camera->Zwz*Temp.wz;
 
   PolygonPointer->Nwx=XX*Temp2.wx+XY*Temp2.wy+XZ*Temp2.wz;
   PolygonPointer->Nwy=YX*Temp2.wx+YY*Temp2.wy+YZ*Temp2.wz;
   PolygonPointer->Nwz=ZX*Temp2.wx+ZY*Temp2.wy+ZZ*Temp2.wz;

   PolygonPointer++;
   }
  }
 else
  {
  for (count=0;count<Object->NumOfPolygons;count++) // rotate poly normals
   {
   Temp.wx=Camera->Xwx*PolygonPointer->Nx+Camera->Xwy*PolygonPointer->Ny+Camera->Xwz*PolygonPointer->Nz;
   Temp.wy=Camera->Ywx*PolygonPointer->Nx+Camera->Ywy*PolygonPointer->Ny+Camera->Ywz*PolygonPointer->Nz;
   Temp.wz=Camera->Zwx*PolygonPointer->Nx+Camera->Zwy*PolygonPointer->Ny+Camera->Zwz*PolygonPointer->Nz;
 
   PolygonPointer->Nwx=XX*Temp.wx+XY*Temp.wy+XZ*Temp.wz;
   PolygonPointer->Nwy=YX*Temp.wx+YY*Temp.wy+YZ*Temp.wz;
   PolygonPointer->Nwz=ZX*Temp.wx+ZY*Temp.wy+ZZ*Temp.wz;

   PolygonPointer++;
   }
  }
 }

void ZClip(VertexTYPE *Vertex1,VertexTYPE *Vertex2)
 {
 float R;

 R=(1-Vertex1->wz)/(Vertex2->wz-Vertex1->wz);
 Vertex1->wx=Vertex1->wx+(Vertex2->wx-Vertex1->wx)*R;
 Vertex1->wy=Vertex1->wy+(Vertex2->wy-Vertex1->wy)*R;
 Vertex1->light=Vertex1->light+(Vertex2->light-Vertex1->light)*R;
 Vertex1->TextFX=Vertex1->TextFX+(Vertex2->TextFX-Vertex1->TextFX)*R;
 Vertex1->TextFY=Vertex1->TextFY+(Vertex2->TextFY-Vertex1->TextFY)*R;
 Vertex1->TextRX=Vertex1->TextRX+(Vertex2->TextRX-Vertex1->TextRX)*R;
 Vertex1->TextRY=Vertex1->TextRY+(Vertex2->TextRY-Vertex1->TextRY)*R;
 Vertex1->wz=1;
 }

int PolyClipZ(PolygonTYPE *Polygon,VertexTYPE VertStore[])
 {
 VertexTYPE *Last,*Next;

 int Count=0;	// count of polygons in output buffer

 Last = Polygon->Vertex[Polygon->NumVertices-1];
 for (int J=0;J<Polygon->NumVertices;J++)
  {
  Next = Polygon->Vertex[J];
  if (Next->wz>=1) // If Next Point is visible
   {
   if (Last->wz>=1)	// If Last Point is visible
    {
    VertStore[Count].wx=Next->wx;
    VertStore[Count].wy=Next->wy;
    VertStore[Count].wz=Next->wz;
    VertStore[Count].Nwx=Next->Nwx;
    VertStore[Count].Nwy=Next->Nwy;
    VertStore[Count].Nwz=Next->Nwz;
    VertStore[Count].light=Next->light;
    VertStore[Count].TextFX=Next->TextFX;
    VertStore[Count].TextFY=Next->TextFY;
    VertStore[Count].TextRX=Next->TextRX;
    VertStore[Count].TextRY=Next->TextRY;
    Count++;
    }
   else				// Last Point is invisible
    {
    VertStore[Count].wx=Last->wx;
    VertStore[Count].wy=Last->wy;
    VertStore[Count].wz=Last->wz;
    VertStore[Count].Nwx=Next->Nwx;
    VertStore[Count].Nwy=Next->Nwy;
    VertStore[Count].Nwz=Next->Nwz;
    VertStore[Count].light=Last->light;
    VertStore[Count].TextFX=Next->TextFX;
    VertStore[Count].TextFY=Next->TextFY;
    VertStore[Count].TextRX=Next->TextRX;
    VertStore[Count].TextRY=Next->TextRY;
    ZClip(&VertStore[Count],Next);
    Count++;
    VertStore[Count].wx=Next->wx;
    VertStore[Count].wy=Next->wy;
    VertStore[Count].wz=Next->wz;
    VertStore[Count].Nwx=Next->Nwx;
    VertStore[Count].Nwy=Next->Nwy;
    VertStore[Count].Nwz=Next->Nwz;
    VertStore[Count].light=Next->light;
    VertStore[Count].TextFX=Next->TextFX;
    VertStore[Count].TextFY=Next->TextFY;
    VertStore[Count].TextRX=Next->TextRX;
    VertStore[Count].TextRY=Next->TextRY;
    Count++;
    }
   }
  else				// Next Point is invisible
   {
   if (Last->wz>=1)	// Last Point is visible
    {
    VertStore[Count].wx=Last->wx;
    VertStore[Count].wy=Last->wy;
    VertStore[Count].wz=Last->wz;
    VertStore[Count].Nwx=Next->Nwx;
    VertStore[Count].Nwy=Next->Nwy;
    VertStore[Count].Nwz=Next->Nwz;
    VertStore[Count].light=Last->light;
    VertStore[Count].TextFX=Next->TextFX;
    VertStore[Count].TextFY=Next->TextFY;
    VertStore[Count].TextRX=Next->TextRX;
    VertStore[Count].TextRY=Next->TextRY;
    ZClip(&VertStore[Count],Next);
    Count++;
    }
   }
  Last=Next;	// Next Point
  }
 return Count;
 }


void ScanConvEdgeAngle(Fixed x1,Fixed y1,Fixed angle1,Fixed x2,Fixed y2,Fixed angle2)  // To convert standard poly
 {
 Fixed mx,ma;   // slope of x and angle
 Fixed temp;    // for swapping
 Fixed x,y,a;   // source x and y screen coordinates, and angle

 if(y1 > y2) // make sure that edge goes from top to bottom
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;

  temp=angle1;
  angle1=angle2;
  angle2=temp;
  }

 if (y1<YMin)
  YMin=y1;
 if (y2>YMax)
  YMax=y2;

 if((y2-y1) != 0) // initialize the slopes for stepping the edges
  {
  mx = (Int2Fixed(x2-x1)) / (y2-y1); // dx/dy
  ma = (Int2Fixed(angle2-angle1)) / (y2-y1); //da/dy
  }
 else
  {
  mx = (Int2Fixed(x2-x1)); // dx
  ma = (Int2Fixed(angle2-angle1)); // da
  }

 x=Int2Fixed(x1);
 a=Int2Fixed(angle1);

 for(y=y1;y<=y2;y++)
  {
  if (y>=WINTOP && y<=WINBOTTOM)
   {
   if ((Fixed2Int(x))<ScanBufferLeft[y])
    {
    ScanBufferLeft[y]=Fixed2Int(x);
    AngleLeft[y]=Fixed2Int(a);
    }
   if ((Fixed2Int(x))>ScanBufferRight[y])
    {
    ScanBufferRight[y]=Fixed2Int(x);
    AngleRight[y]=Fixed2Int(a);
    }
   }
  x+=mx;
  a+=ma;
  }
 }

void PhongShade(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
// lets phong shade

 int i,j,n,Y,a;
 unsigned char *TempScreen;
 int ScanLeft,ScanRight;

 YMin=WINBOTTOM;      // set up optimal buffers
 YMax=WINTOP;

 for(i=0;i<200;i++)       // Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 float angle1,angle2;

 j=NumSides-1;        // set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  // light normal is at present 0,0,1 pointing into screen (i hope)

  // angle between polyvertex and normal is dot product

  angle1=acos(Map->Dyna_Object[0].VertexList->Nwx*Vertices[j].Nwx+Map->Dyna_Object[0].VertexList->Nwy*Vertices[j].Nwy+Map->Dyna_Object[0].VertexList->Nwz*Vertices[j].Nwz);
  angle2=acos(Map->Dyna_Object[0].VertexList->Nwx*Vertices[n].Nwx+Map->Dyna_Object[0].VertexList->Nwy*Vertices[n].Nwy+Map->Dyna_Object[0].VertexList->Nwz*Vertices[n].Nwz);

  angle1=(angle1*180)/M_PI;     // angle in degrees
  angle2=(angle2*180)/M_PI;     // angle in degrees

  if (angle2<angle1 && angle1>270)    // case for 350 - 360 degrees not 350 - 0 degrees
   angle2+=360; // makes it correct
  if (angle2>angle1 && angle2>270)    // case for 350 - 360 degrees not 350 - 0 degrees
   angle1+=360; // makes it correct

  ScanConvEdgeAngle(Vertices[j].sx,Vertices[j].sy,angle1,Vertices[n].sx,Vertices[n].sy,angle2);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 int AngLeft,AngRight;
 float Ang,MAng;

 if (YMin!=YMax)
  for (Y=YMin;Y<=YMax;Y++)
   {
   ScanLeft=ScanBufferLeft[Y];
   ScanRight=ScanBufferRight[Y];

   AngLeft=AngleLeft[Y];
   AngRight=AngleRight[Y];

  if (AngRight<AngLeft && AngLeft>270)    // case for 350 - 360 degrees not 350 - 0 degrees
   AngRight+=360; // makes it correct

  if (AngRight>AngLeft && AngRight>270)    // case for 350 - 360 degrees not 350 - 0 degrees
   AngLeft+=360; // makes it correct

   Ang=AngLeft;
   if (ScanRight-ScanLeft!=0)
    MAng=((float)AngRight-AngLeft)/((float)ScanRight-ScanLeft);
   else
    MAng=(AngRight-AngLeft);

   if (ScanLeft<WINLEFT) // is poly span left visible
    ScanLeft=WINLEFT;
   if (ScanRight>WINRIGHT)
    ScanRight=WINRIGHT;
   if (ScanLeft<ScanRight)
    {
    TempScreen=VirtualScreen+ScanLeft+Y*320;

    for (a=ScanLeft;a<ScanRight;a++)
     {
//    *TempScreen++=LightTables[LightLevel][*TempPicture++]; // clear screen.... sloooooow
     *TempScreen++=PhongShadeTable[(int)Ang];
//     *TempScreen++=255;//PhongShadeTable[(int)Ang];
     Ang+=MAng;
     }
    }
   }

 }

PolygonTYPE *Sorted[2000];       //lots of space

int compare (const void *op1,const void *op2)
 {
 return ((PolygonTYPE *)op1)->Vertex[0]->wz-((PolygonTYPE *)op2)->Vertex[0]->wz;
 }

// WARNING I HAVE PRE SORTED ALL THE VERTICES !!!!!!!

int FLAG,COUNT; // SHOULD NOT BE GLOBAL BUT I AM DOING THIS QUICKLY

void DisplaySector(ObjectTYPE *Object)
 {
 PolygonTYPE *PolygonPointer;
 float ZStore;
 VertexTYPE VertsTemp[NUMVERTS*2];	// Temp Store For Z Clipping
 int Clipping,n,Loop;

// PolygonPointer=Object->PolygonList;

 for (Loop=0;Loop<COUNT;Loop++) //,PolygonPointer++)
  {
  PolygonPointer=Sorted[Loop];
  Clipping=PolyClipZ(PolygonPointer,VertsTemp);

  if (Clipping>2)// && (VertsTemp[0].wx*PolygonPointer->Nwx+
                 //    VertsTemp[0].wy*PolygonPointer->Nwy+
                 //    VertsTemp[0].wz*PolygonPointer->Nwz)>0)
   {
   for (n=0;n<Clipping;n++)	// Perspectivate the coords now they are clipped
    {
    ZStore=Perspective/VertsTemp[n].wz;
    VertsTemp[n].sx=VertsTemp[n].wx*ZStore+HCENTER;
    VertsTemp[n].sy=VertsTemp[n].wy*(-ZStore)+VCENTER;
    }

   TexturePlot2(VertsTemp,Clipping,PolygonPointer);
//   PhongShade(VertsTemp,Clipping,PolygonPointer);
   }
  }
 }

void DrawWindows()
 {
// delay(200);
 // Draw The 3D projection
 for (int a=0;a<Map->LastDynaObject;a++)
  DisplaySector(&Map->Dyna_Object[a]); // draw dynamic stuff
 }

void main()
 {
 InitParams();
 char String[50];

 int Rott=0;

 cout << "\n\nInitialising 3D Engine  -  Design & Code By Xavier / Phobia '96";

 Map=Parse("maps\\test.3do");
// CalculateNormals(&Map->Object[0]); // calculate the normals for the map
 for (int a=1;a<Map->LastDynaObject;a++)        // start at a proper object
  {
  CalculateNormals(&Map->Dyna_Object[a]); // calculate the normals for dynamic stuff
  CalculatePsuedoNormals(&Map->Dyna_Object[a]);
  }

 Map->Dyna_Object[0].VertexList->Nx=1; // object 0 is light
 Map->Dyna_Object[0].VertexList->Ny=0;
 Map->Dyna_Object[0].VertexList->Nz=0;

 MakeTables();	//create sin & cos tables in memory
 BuildLightTables();    // creates a better lighting arrangment

 float red,green,blue;

 red=Map->Palette[150*3];
 green=Map->Palette[150*3+1];
 blue=Map->Palette[150*3+2];

 red=(63-red)/33;
 green=(63-green)/33;
 blue=(63-blue)/33;
                
 for (int p=151;p<=184;p++)
  {
  Map->Palette[p*3]=red*(p-151)+Map->Palette[150*3];
  Map->Palette[p*3+1]=green*(p-151)+Map->Palette[150*3+1];
  Map->Palette[p*3+2]=blue*(p-151)+Map->Palette[150*3+2];
  }

 char Key;
 int Loop,Loop2,Engine=0;

 InitVideo();

 unsigned char Byte,Count;

 SetPalette(Map->Palette,0,256);

 int light=0;

 CLS();

 clock_t Start,End;     // Start,End time to draw a frame!

 int Rotate1=0,Rotate2=90,Rotate3=270;
 int BankX=0,BankY=0,BankZ=0;

 float Direc=-1;

 Map->Camera[0].Ax=Rotate1;               // rotate Eye as follows
 Map->Camera[0].Ay=Rotate2;
 Map->Camera[0].Az=Rotate3;

 Map->Camera[0].Ox=10;
 Map->Camera[0].Oy=5;
 Map->Camera[0].Oz=5;
//while (1==1)
// {
 for (Loop=0;Loop<Map->LastDynaObject;Loop++)  // rotate scene including light
  Transform(&Map->Camera[0],&Map->Dyna_Object[Loop],0,0,0);

// This presorts the objects faces, since they are not rotated :)
//
// NEAT HUH!... Nah.. but more ticks per second... DOH... sorry less :)

 COUNT=0;
 PolygonTYPE *TempPoly;
 ObjectTYPE *Object=&Map->Dyna_Object[1];

 for (Loop=0;Loop<Object->NumOfPolygons;Loop++)
  {     // only sort visible polygons :)
  if ((Object->PolygonList[Loop].Vertex[0]->wx*Object->PolygonList[Loop].Nwx+
      Object->PolygonList[Loop].Vertex[0]->wy*Object->PolygonList[Loop].Nwy+
      Object->PolygonList[Loop].Vertex[0]->wz*Object->PolygonList[Loop].Nwz)>0)
   {
   Sorted[COUNT]=&Object->PolygonList[Loop];
   COUNT++;
   }
  }

// qsort(Sorted,COUNT,sizeof(PolygonTYPE *),compare);

 if (COUNT!=0)
  do
   {
   FLAG=0;
   for (Loop=0;Loop<COUNT-1;Loop++)
    {
    if (Sorted[Loop]->Vertex[0]->wz<Sorted[Loop+1]->Vertex[0]->wz)
     {
     TempPoly=Sorted[Loop];
     Sorted[Loop]=Sorted[Loop+1];
     Sorted[Loop+1]=TempPoly;
     FLAG=1;
     }
    }
   }while (FLAG==1);

 while (1==1)
  {
  Start=clock();        // Start timer

// Only do realtime rotation on light... dont bother with object
   Transform(&Map->Camera[0],&Map->Dyna_Object[0],BankX,BankY,BankZ);

  Rott+=3;
  if (Rott>359)
   Rott-=360;

  Map->Dyna_Object[0].Ax=0;//Rott;  // object 0 is light
  Map->Dyna_Object[0].Ay=45;//Rott;
  Map->Dyna_Object[0].Az=Rott;

  Map->Dyna_Object[1].Ax=Rott;  // object 0 is light
  Map->Dyna_Object[1].Ay=0;//Rott;
  Map->Dyna_Object[1].Az=Rott;

  DrawWindows();
  End=clock();          // Get end of time

  sprintf(String,"Ticks Per Frame = %i [%i Per Second]",End-Start,CLOCKS_PER_SEC);

  PlotText(0,0,String,255);

  UpdateScreen();
  CLS();

  if(kbhit())
   break;

  }
 KillVideo();

 cout << "\n\nCode By Xavier / Phobia '96";
 }
