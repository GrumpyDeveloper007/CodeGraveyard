/*

   Simple Light Shadow Vector routine, casts a shadow onto the background
  only, but can compute light point in real time. Uses similar triangles
  to compute the location of new vertices cast by a ray.

   This routine must be fed 3 sided polygons only!!!!!

    NB 3DO parser code is unchanged.. but most of the functionality is
     unused, in fact using it would probably cause a crash. The first
     object in the dynamic objects list is assumed to be the point
     light source.. saves having to alter 3DO parser to add a new
     CLASS type.

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

#include "..\XavStuff\h\video.h"
#include "..\XavStuff\h\fixed32.h"
#include "..\XavStuff\h\pcx.h"

#include "..\XavStuff\h\tree.h"
#include "h\3dstruct.h"
#include "h\defines.h"

#define BACKWALL 40     // Z depth of rear wall

struct
 {
 float XPos,YPos,ZPos;
 } Player={10,5,5};

ParseBlock *Parse(char *FileName);

float Perspective=WINBOTTOM-WINTOP;
float InvPerspective=-Perspective;

unsigned char LightTables[255][256];     // NB last 32 cols are reserved
ParseBlock *Map;
extern PCXHeader HeaderInfo;

void ScanConvEdgeWin(Fixed x1,Fixed y1,Fixed x2,Fixed y2);
void PolygonPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);

unsigned char BKPic[320*200];   // picture for screen background

void (*DrawTable[])(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)=
               {PolygonPlot,
               };

float Sin[360],Cos[360];	// sin & cos based on degrees not rads!
int LightDistY[641],LightDistX[641];

int *DistY=&LightDistY[320],*DistX=&LightDistX[320];    // Quick PTRS

void MakeTables()       // Creates the Sin & Cos tables + dist tables
 {
 for (int a=-320;a<=320;a++)
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

void DisplaySector(ObjectTYPE *Object)
 {
 PolygonTYPE *PolygonPointer;
 float ZStore;
 VertexTYPE VertsTemp[NUMVERTS*2];	// Temp Store For Z Clipping
 int Clipping,n,Loop;

 PolygonPointer=Object->PolygonList;

 for (Loop=0;Loop<Object->NumOfPolygons;Loop++,PolygonPointer++)
  {
  Clipping=PolyClipZ(PolygonPointer,VertsTemp);

  if (Clipping>2 && (VertsTemp[0].wx*PolygonPointer->Nwx+
                     VertsTemp[0].wy*PolygonPointer->Nwy+
                     VertsTemp[0].wz*PolygonPointer->Nwz)>0)
   {
   for (n=0;n<Clipping;n++)	// Perspectivate the coords now they are clipped
    {
    ZStore=Perspective/VertsTemp[n].wz;
    VertsTemp[n].sx=VertsTemp[n].wx*ZStore+HCENTER;
    VertsTemp[n].sy=VertsTemp[n].wy*(-ZStore)+VCENTER;
    }
   DrawTable[PolygonPointer->TypeOfPolygon](VertsTemp,Clipping,PolygonPointer);
   }
  }
 }

void DrawWindows()
 {
 // Draw The 3D projection
 for (int a=0;a<Map->LastDynaObject;a++)
  DisplaySector(&Map->Dyna_Object[a]); // draw dynamic stuff
 }

VertexTYPE ShadowV[3];
PolygonTYPE ShadowP[1]={3,{&ShadowV[0],&ShadowV[1],&ShadowV[2]},0,0,0,0,0,0,POLY_NORMAL,0};

void DrawShadows()      // computes and draws shadow (do before DrawWindows)
 {
 float XDiff,YDiff,ZDiff,WallDiff,ZRatio;
 float ZStore;
 int ZNeg;
 int object,Loop,v;
 ObjectTYPE *Object;
 PolygonTYPE *PolygonPointer;

 for (object=1;object<Map->LastDynaObject;object++)
  {
  Object=&Map->Dyna_Object[object];
  PolygonPointer=Object->PolygonList;

// do following for every polygon in object
  for (Loop=0;Loop<Object->NumOfPolygons;Loop++,PolygonPointer++)
   {
   // Is polygon visible from light world location (X,Y,Z)
//   if ((Map->Dyna_Object[0].VertexList->wx*PolygonPointer->Nwx+
//        Map->Dyna_Object[0].VertexList->wy*PolygonPointer->Nwy+
//        Map->Dyna_Object[0].VertexList->wz*PolygonPointer->Nwz)>0)
//    {
    // compute 3 points for triangle to generate (if ZDiff is at any
    // point negative then the polygon is not shadowed, cos the light
    // is between it and the wall!

    ZNeg=0;
    for (v=0;v<3;v++)
     {
     // project the ray through the point and onto the backwall (easy)
     XDiff=PolygonPointer->Vertex[v]->wx-Map->Dyna_Object[0].VertexList->wx;
     YDiff=PolygonPointer->Vertex[v]->wy-Map->Dyna_Object[0].VertexList->wy;
     ZDiff=PolygonPointer->Vertex[v]->wz-Map->Dyna_Object[0].VertexList->wz;
     if (ZDiff<0)
      ZNeg=1;
     WallDiff=BACKWALL-PolygonPointer->Vertex[v]->wz;
     ZRatio=WallDiff/ZDiff;     // Scale of shadowed polyline

     ShadowV[v].wz=BACKWALL;    // easy one
     ShadowV[v].wx=(ZRatio*XDiff)+PolygonPointer->Vertex[v]->wx;
     ShadowV[v].wy=(ZRatio*YDiff)+PolygonPointer->Vertex[v]->wy;
     }
    if (ZNeg==0) // ensure shadow visible
     {
     // we now have a polygon projected by the shadow
     for (v=0;v<3;v++)     // Perspectivate the coords
      {
      ZStore=Perspective/ShadowV[v].wz;
      ShadowV[v].sx=ShadowV[v].wx*ZStore+HCENTER;
      ShadowV[v].sy=ShadowV[v].wy*(-ZStore)+VCENTER;
      }
     DrawTable[POLY_NORMAL](&ShadowV[0],3,&ShadowP[0]);
     }
   // }
   }
  }

 }

void main()
 {
 char String[50];

 int Rott=0;

 cout << "\n\nInitialising 3D Engine  -  Design & Code By Xavier / Phobia '96";

 Map=Parse("maps\\test.3do");
// CalculateNormals(&Map->Object[0]); // calculate the normals for the map
 for (int a=1;a<Map->LastDynaObject;a++)        // start at a proper object
  CalculateNormals(&Map->Dyna_Object[a]); // calculate the normals for dynamic stuff

 GetPCXInfo(&HeaderInfo,"gfx\\palette.PCX");
 GetPCXPicture(&HeaderInfo,"gfx\\palette.PCX",(unsigned char *)BKPic);

 MakeTables();	//create sin & cos tables in memory
 BuildLightTables();    // creates a better lighting arrangment

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

 while (1==1)
  {
  Start=clock();        // Start timer

  Map->Camera[0].Ax=Rotate1;               // rotate Eye as follows
  Map->Camera[0].Ay=Rotate2;
  Map->Camera[0].Az=Rotate3;

  Map->Camera[0].Ox=Player.XPos;
  Map->Camera[0].Oy=Player.YPos;
  Map->Camera[0].Oz=Player.ZPos;

  for (Loop=0;Loop<Map->LastDynaObject;Loop++)  // rotate scene including light
   Transform(&Map->Camera[0],&Map->Dyna_Object[Loop],BankX,BankY,BankZ);

  Rott+=3;
  if (Rott>359)
   Rott-=360;

  Map->Dyna_Object[0].Ax=0;//Rott;  // object 0 is light
  Map->Dyna_Object[0].Ay=0;//Rott;
  Map->Dyna_Object[0].Az=Rott;

  Map->Dyna_Object[1].Ax=Rott;  // object 0 is light
  Map->Dyna_Object[1].Ay=Rott;
  Map->Dyna_Object[1].Az=0;//Rott;

// GONNA GRADIATE THE BACKGROUND COLOUR COS I THINK IT MIGHT LOOK BETTER
// ALSO DRIFT DOES IT - > :)

  Fixed XDiff,DeltaXDiff,XLDiff,XRDiff;
  float ZStore;
  Fixed YDiff,DeltaYDiff,YTDiff,YBDiff;
  ZStore=Perspective/Map->Dyna_Object[0].VertexList[0].wz;
//  ShadowV[v].sx=ShadowV[v].wx*ZStore+HCENTER;
//  ShadowV[v].sy=ShadowV[v].wy*(-ZStore)+VCENTER;

  XLDiff=Float2Fixed(WINLEFT-(Map->Dyna_Object[0].VertexList[0].wx*ZStore+HCENTER));
  XRDiff=Float2Fixed(WINRIGHT-(Map->Dyna_Object[0].VertexList[0].wx*ZStore+HCENTER));

  YTDiff=Float2Fixed(WINTOP-(Map->Dyna_Object[0].VertexList[0].wy*(-ZStore)+VCENTER));
  YBDiff=Float2Fixed(WINBOTTOM-(Map->Dyna_Object[0].VertexList[0].wy*(-ZStore)+VCENTER));

  DeltaXDiff=(XRDiff-XLDiff)/320;       // num pixels
  DeltaYDiff=(YBDiff-YTDiff)/320;       // num pixels

  unsigned char *TempScreen,*TempPicture;
  int LightLevel,YAdjust;

  YDiff=YTDiff;
  TempScreen=VirtualScreen;
  TempPicture=BKPic;
  for (int y=WINTOP;y<=WINBOTTOM;y++)
   {
   YAdjust=DistY[(YDiff>>16)];
   XDiff=XLDiff;
   for (int x=WINLEFT;x<=WINRIGHT;x++)
    {
    LightLevel=DistX[(XDiff>>16)]-YAdjust;
    *TempScreen++=LightTables[LightLevel][*TempPicture++]; // clear screen.... sloooooow
    XDiff+=DeltaXDiff;
    }
   YDiff+=DeltaYDiff;
   }

  DrawShadows();
  DrawWindows();
  End=clock();          // Get end of time

  sprintf(String,"Ticks Per Frame = %i [%i Per Second]",End-Start,CLOCKS_PER_SEC);

  PlotText(0,0,String,255);

  UpdateScreen();

  if(kbhit())
   break;

  }
 KillVideo();

 cout << "\n\nCode By Xavier / Phobia '96";
 }
