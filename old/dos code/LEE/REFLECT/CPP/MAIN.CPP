/*

   Environment Mapping - Final optimised DOODA routine

    Theory - Take normal from surface and compute the u,v coordinates.

  Original Ticks with face at 475 units away (1360) approx for 101 frames

  o - First optimisation was to remove the bubble sort and replace with
     shell sort. (ticks now 530) approx

  o - Second optimisation was to remove the old SCANBUFFER method of
     generating the polygons.. now we do it using interpolation at draw
     time which is much quicker and avoids having to clear those darn
     tables! (ticks now 330) approx (without any assembler :))

  o - Tiny optimisation is to move the U,V calculations from the polygon
     drawing routine and into a quick loop over all vertices in the main
     function. This way I avoid calculating the U,V values for the same
     points over and over again! (ticks now 300) approx

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <math.h>     // THIS IS PURELY FOR PREGENERATION
#include <conio.h>
#include <stdio.h>
#include <dos.h>
#include <iostream.h>
#include <time.h>
#include <i86.h>
#include <stdlib.h>

#include "..\..\XavStuff\h\video.h"
#include "..\..\XavStuff\h\fixed32.h"
#include "..\..\XavStuff\h\pcx.h"

#include "..\..\XavStuff\h\tree.h"
#include "h\3dstruct.h"
#include "h\defines.h"

ParseBlock *Parse(char *FileName);

float Perspective=512;   //WINBOTTOM-WINTOP;
float InvPerspective=-Perspective;

unsigned char EnvMap[(256*256)];
unsigned char EnvMap2[(256*256)];

unsigned char LightTables[255][256];     // NB last 32 cols are reserved
ParseBlock *Map;
extern PCXHeader HeaderInfo;

void ScanConvEdgeWin(Fixed x1,Fixed y1,Fixed x2,Fixed y2);
void PolygonPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);

void (*DrawTable[])(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)=
               {PolygonPlot,
                };

Fixed Sin[360],Cos[360];        // sin & cos in Fixed format
//float Sin[360],Cos[360];        // sin & cos based on degrees not rads!

void MakeTables()       // Creates the Sin & Cos tables + dist tables
 {
 for (int Loop=0;Loop<360;Loop++)
  {
  Sin[Loop]=Float2Fixed(sin((Loop*M_PI)/180));
  Cos[Loop]=Float2Fixed(cos((Loop*M_PI)/180));
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
  SA12=Fixed2Float(Sin[Object->Ax]);   // Get All the Sin & Cos values to save on some
  SA22=Fixed2Float(Sin[Object->Ay]);      // indexing on arrays... <NOT A LOT THO!>
  SA32=Fixed2Float(Sin[Object->Az]);
  CA12=Fixed2Float(Cos[Object->Ax]);
  CA22=Fixed2Float(Cos[Object->Ay]);
  CA32=Fixed2Float(Cos[Object->Az]);
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

 SA1=Fixed2Float(Sin[A1]);   // Get All the Sin & Cos values to save on some
 SA2=Fixed2Float(Sin[A2]);      // indexing on arrays... <NOT A LOT THO!>
 SA3=Fixed2Float(Sin[A3]);
 CA1=Fixed2Float(Cos[A1]);
 CA2=Fixed2Float(Cos[A2]);
 CA3=Fixed2Float(Cos[A3]);
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

 SA1=Fixed2Float(Sin[A4]);   // Get All the Sin & Cos values to save on some
 SA2=Fixed2Float(Sin[A5]);      // indexing on arrays... <NOT A LOT THO!>
 SA3=Fixed2Float(Sin[A6]);
 CA1=Fixed2Float(Cos[A4]);
 CA2=Fixed2Float(Cos[A5]);
 CA3=Fixed2Float(Cos[A6]);
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
    VertStore[Count].U=Next->U;
    VertStore[Count].V=Next->V;
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
    VertStore[Count].U=Next->U;
    VertStore[Count].V=Next->V;
    ZClip(&VertStore[Count],Next);
    Count++;
    VertStore[Count].wx=Next->wx;
    VertStore[Count].wy=Next->wy;
    VertStore[Count].wz=Next->wz;
    VertStore[Count].Nwx=Next->Nwx;
    VertStore[Count].Nwy=Next->Nwy;
    VertStore[Count].Nwz=Next->Nwz;
    VertStore[Count].U=Next->U;
    VertStore[Count].V=Next->V;
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
    VertStore[Count].U=Next->U;
    VertStore[Count].V=Next->V;
    ZClip(&VertStore[Count],Next);
    Count++;
    }
   }
  Last=Next;	// Next Point
  }
 return Count;
 }

Fixed ULeft[200],URight[200];   // for 2d texture mapping.. (it`ll do)
Fixed VLeft[200],VRight[200];

extern short ScanBufferLeft[200],ScanBufferRight[200];   // For converting polygons!
extern short YMin,YMax;

void ScanConvEdgeUV(Fixed x1,Fixed y1,Fixed u1,Fixed v1,Fixed x2,Fixed y2,Fixed u2,Fixed v2)  // To convert standard poly
 {
 Fixed mx,mu,mv;   // slope of x and u,v
 Fixed temp;    // for swapping
 Fixed x,y,u,v;   // source x and y screen coordinates, and u,v

 if(y1 > y2) // make sure that edge goes from top to bottom
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;

  temp=u1;
  u1=u2;
  u2=temp;

  temp=v1;
  v1=v2;
  v2=temp;
  }

 if (y1<YMin)
  YMin=y1;
 if (y2>YMax)
  YMax=y2;

 if((y2-y1) != 0) // initialize the slopes for stepping the edges
  {
  mx = (Int2Fixed(x2-x1)) / (y2-y1); // dx/dy
  mu = (Int2Fixed(u2-u1)) / (y2-y1); // du/dy
  mv = (Int2Fixed(v2-v1)) / (y2-y1); // dv/dy
  }
 else
  {
  mx = (Int2Fixed(x2-x1)); // dx
  mu = (Int2Fixed(u2-u1)); // du
  mv = (Int2Fixed(v2-v1)); // dv
  }

 x=Int2Fixed(x1);
 u=Int2Fixed(u1);
 v=Int2Fixed(v1);

 for(y=y1;y<=y2;y++)
  {
  if (y>=WINTOP && y<=WINBOTTOM)
   {
   if ((Fixed2Int(x))<ScanBufferLeft[y])
    {
    ScanBufferLeft[y]=Fixed2Int(x);
    ULeft[y]=Fixed2Int(u);
    VLeft[y]=Fixed2Int(v);
    }
   if ((Fixed2Int(x))>ScanBufferRight[y])
    {
    ScanBufferRight[y]=Fixed2Int(x);
    URight[y]=Fixed2Int(u);
    VRight[y]=Fixed2Int(v);
    }
   }
  x+=mx;
  u+=mu;
  v+=mv;
  }
 }

VertexTYPE *Left[3],*Right[3];  // Left and Right Vertices for Triangle
int LeftSection,RightSection;
int LeftSectionHeight,RightSectionHeight;
Fixed DUDX,DVDX;
Fixed LeftU,DeltaLeftU,LeftV,DeltaLeftV;
Fixed LeftX,DeltaLeftX,RightX,DeltaRightX;

inline int CalcRightSection(void)
 {
 VertexTYPE * V1 = Right[RightSection];
 VertexTYPE * V2 = Right[RightSection-1];

 int Height = V2->sy - V1->sy;
 if(Height == 0)
  return 0;       // nothing to draw!

 // Calculate the deltas along this section

 DeltaRightX = ((V2->sx - V1->sx) << 16)/Height;
 RightX = V1->sx << 16;

 RightSectionHeight = Height;
 return Height;                  // return the height of this section
 }

inline int CalcLeftSection(void)
 {
 VertexTYPE * V1 = Left[LeftSection];
 VertexTYPE * V2 = Left[LeftSection-1];

 int Height = V2->sy - V1->sy;
 if(Height == 0)
  return 0;  // nothing to draw

 // Calculate the deltas along this section

 DeltaLeftX = ((V2->sx - V1->sx) << 16) / Height;
 LeftX = V1->sx << 16;
 DeltaLeftU = ((V2->U - V1->U) << 16) / Height;
 LeftU = V1->U << 16;
 DeltaLeftV = ((V2->V - V1->V) << 16) / Height;
 LeftV = V1->V << 16;

 LeftSectionHeight = Height;
 return Height;                  // return the height of this section
 }

void EnvironMap(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
// lets try to environment map
//
// This function will use the new polygon drawing method of no scanbuffers!

// MUST HAVE BEEN SENT A TRIANGLE>> IF NOT I CANT BE BLAMED FOR THE RESULTS!

// Sort triangle points as follows v1 = top, v2 = middle, v3 = bottom

 VertexTYPE *V1=&Vertices[0],*V2=&Vertices[1],*V3=&Vertices[2],*VTemp;

 if (V1->sy > V2->sy)
  {
  VTemp=V1;
  V1=V2;
  V2=VTemp;
  }
 if (V1->sy > V3->sy)
  {
  VTemp=V1;
  V1=V3;
  V3=VTemp;
  }
 if (V2->sy > V3->sy)
  {
  VTemp=V2;
  V2=V3;
  V3=VTemp;
  }

 // Now we need to know the length of the longest scan line.

 int Height=V3->sy-V1->sy;
 if (Height==0)
  return;       // polygon too small to draw

 Fixed Temp=((V2->sy - V1->sy) << 16) / Height;
 Fixed Longest=Temp*(V3->sx - V1->sx) + ((V1->sx - V2->sx) <<16);
 if (Longest==0)
  return;       // polygon too small to draw

 if (Longest<0) // we have the right side middle vertex
  {
  Right[0]=V3;
  Right[1]=V2;
  Right[2]=V1;
  Left[0]=V3;
  Left[1]=V1;
  RightSection=2;
  LeftSection=1;

  // Calculate Initial Left & Right Stuff

  if(CalcLeftSection() <= 0)
   return;      // polygon too small
  if(CalcRightSection() <= 0)
   {
   // The first right section had zero height. Use the next section. 
   RightSection--;
   if(CalcRightSection() <= 0)
    return;     // polygon too small
   }

  // Ugly compensation so that the dudx,dvdx divides won't overflow
  // if the longest scanline is very short.
  if(Longest > -0x1000) // -0x1000 is about -1/16
   Longest = -0x1000;     
  }
 else
  {
  // We have the left most point
  Left[0]=V3;
  Left[1]=V2;
  Left[2]=V1;
  Right[0]=V3;
  Right[1]=V1;
  LeftSection=2;
  RightSection=1;

  // Calculate initial right and left parameters
  if(CalcRightSection() <= 0)
   return;      // polygon too small
  if(CalcLeftSection() <= 0)
   {
   // The first left section had zero height. Use the next section.
   LeftSection--;
   if (CalcLeftSection() <= 0)
    return;     // polygon too small
   }

  // Ugly compensation so that the dudx,dvdx divides won't overflow
  // if the longest scanline is very short.
  if(Longest < 0x1000)  // about 1/16
   Longest = 0x1000;     
  }

 // Now we calculate the deltas for u & v

 DUDX = FixedDiv(Temp*(V3->U - V1->U)+((V1->U - V2->U)<<16),Longest);
 DVDX = FixedDiv(Temp*(V3->V - V1->V)+((V1->V - V2->V)<<16),Longest);

 unsigned char *TempScreen=VirtualScreen+(V1->sy*320);
 unsigned char *Destination;

 while (1==1)
  {
  int X1=LeftX >> 16;
  int Width=(RightX>>16)-X1;

  if (Width>0)
   {
   Destination=TempScreen+X1;
   int U=LeftU >> 8;    // 24:8 fixed point now!
   int V=LeftV >> 8;
   int DU=DUDX >> 8;
   int DV=DVDX >> 8;

   while (Width--)
    {
//    *Destination++=15;
    *Destination++=EnvMap[(V&0xff00)+((U&0xff00)>>8)];
    U+=DU;
    V+=DV;
    }

   }

  TempScreen+=320;
  // Interpolate accross the left edge of the triangle
  if (--LeftSectionHeight<=0)   // at the bottom of the section
   {
   if (--LeftSection<=0)
    return;     // all sections done
   if (CalcLeftSection()<=0)
    return;     // section too small
   }
  else
   {
   LeftX+=DeltaLeftX;
   LeftU+=DeltaLeftU;
   LeftV+=DeltaLeftV;
   }

  // Interpolate accross the right edge
  if (--RightSectionHeight<=0)  // at the bottom of the section
   {
   if (--RightSection<=0)
    return;     // All sections done
   if (CalcRightSection()<=0)
    return;     // Section too small
   }
  else
   {
   RightX+=DeltaRightX;
   }
  }
 }

#define NUMSORT 8000

PolygonTYPE *Sorted[NUMSORT];       //lots of space

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

   EnvironMap(VertsTemp,Clipping,PolygonPointer);
   }
  }
 }

void DrawWindows()
 {
// delay(200);
 // Draw The 3D projection
 for (int a=0;a<2;a++)
  DisplaySector(&Map->Dyna_Object[a]); // draw dynamic stuff
 }

void ShellSort(PolygonTYPE **Array,int Size)
 {
 int D1,D2,D3,D5;
 PolygonTYPE **A1,**A2,*A3;  // char to ensure array correction works!

 D1=Size;

//nxtgap
 while((D1>>=1)!=0)     // divide by 2
  {
  D2=D1;
  D2-=1;
  D3=D1;
//  D3+=D3;     // not needed since array size correction built in to c++
  //nxtsub
  while (1==1)
   {
   D2+=1;
   if (Size<=D2)
    break;// goto nxtgap
   D5=D2;
//   A1=Array+(D5<<1);  // Not needed since array size correction done in c++
   A1=Array+D5;
//    if (Sorted[Loop]->Vertex[0]->wz<Sorted[Loop+1]->Vertex[0]->wz)
   A3=*A1;
   //nxtptr
   while (1==1)
    {
    D5-=D1;
    if (D5<0)
     break;// goto nxtsub
    A2=A1;
    A1-=D3;
    if ((*A1)->Vertex[0]->wz>A3->Vertex[0]->wz)         // ascending order
     break;// goto nxtsub
    *A2=*A1;
    *A1=A3;
    }// goto nxtptr
   }
  }
 //clnstk
 }

void main()
 {
 char String[50];

 int Rott=0,Rott2=0;

 cout << "\n\nInitialising 3D Engine  -  Design & Code By Xavier / Phobia '96";

 Map=Parse("maps\\test.3do");
// CalculateNormals(&Map->Object[0]); // calculate the normals for the map
 for (int a=1;a<Map->LastDynaObject;a++)        // start at a proper object
  {
  CalculateNormals(&Map->Dyna_Object[a]); // calculate the normals for dynamic stuff
  CalculatePsuedoNormals(&Map->Dyna_Object[a]);
  }

 Map->Dyna_Object[0].VertexList->Nx=0; // object 0 is light
 Map->Dyna_Object[0].VertexList->Ny=0;
 Map->Dyna_Object[0].VertexList->Nz=1;

 MakeTables();	//create sin & cos tables in memory
 BuildLightTables();    // creates a better lighting arrangment

 GetPCXInfo(&HeaderInfo,"gfx\\envmap.PCX");
 GetPCXPicture(&HeaderInfo,"gfx\\envmap.PCX",(unsigned char *)EnvMap2);
 GetPCXPalette(&HeaderInfo,"gfx\\envmap.PCX",(unsigned char *)Map->Palette);

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

 Start=clock();        // Start timer
 int CurFrame=0;

while (1==1)
 {

 for (Loop=0;Loop<2;Loop++)  // rotate scene including light
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

 ShellSort(Sorted,COUNT);       // This is soooo much quicker!

// while (1==1)
//  {
//  Start=clock();        // Start timer

// Only do realtime rotation on light... dont bother with object
// In fact in env mapping the light has no use :)
//   Transform(&Map->Camera[0],&Map->Dyna_Object[0],BankX,BankY,BankZ);

  Rott++;
  if (Rott>359)
   Rott-=360;
  Rott2++;
  if (Rott2>199)
   Rott2-=200;

//  Map->Dyna_Object[0].Ax=0;//Rott;  // object 0 is light
//  Map->Dyna_Object[0].Ay=45;//Rott;
//  Map->Dyna_Object[0].Az=Rott;

  Map->Dyna_Object[1].Ax=Rott;  // object 1 is object
//  Map->Dyna_Object[1].Ay=0;//Rott;
//  Map->Dyna_Object[1].Az=Rott;

  VertexTYPE *Vertex=Map->Dyna_Object[1].VertexList;

  for (int a=0;a<Map->Dyna_Object[1].NumOfVertices;a++)
   {
   // Set up environment map U,V values for this vertex

   Vertex->U=Vertex->Nwx*128+128;
   Vertex->V=Vertex->Nwy*128+128;
   Vertex++;
   }

  for (int p=0;p<256*256;p++)
   EnvMap[p]=EnvMap2[p];

  for (p=Rott2;p<Rott2+30;p++)
   for (int i=Rott2;i<Rott2+30;i++)
    EnvMap[p+i*256]=255;

  DrawWindows();
  for (int i=Rott2;i<Rott2+30;i++)
   if (i<200)
    {
    for (p=320-(Rott2+30);p<320-Rott2;p++)
     VirtualScreen[p+i*320]=255;
    }

  End=clock();          // Get end of time
  CurFrame++;

//  if (CurFrame>100)
//   break;
  sprintf(String,"Ticks = %i [%i Per Second],Frame = %i",End-Start,CLOCKS_PER_SEC,CurFrame);

  PlotText(0,0,String,255);

  UpdateScreen();
  CLS();

  if(kbhit())
   break;

  }
 KillVideo();

 cout << "\n\nCode By Xavier / Phobia '96\n";
 cout << "Ticks = " << End-Start << " Frame = " << CurFrame << "\r\n";
 }
