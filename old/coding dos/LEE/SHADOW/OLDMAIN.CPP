/*

  3d Engine (DUKE,QUAKE - if unoptimised) - Uses ...

  Fast FLOORS and WALLS by disallowing head tilting.

  SpanLists and VertLists to ensure that no polygon draws over another
  ... This will be updated for sprites which work a little different!

  Design & Code By Xavier / SCUDD '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <conio.h>
#include <stdio.h>
#include <process.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#include <math.h>	// using floating point cos newer stuff is COPRO!!!

//#include "joystick.h"

#include "..\..\leechinc\FIXDMath.h"	// include FIXED format maths functions

//#include "..\..\leechinc\COSTABLE.H"	// include maths tables in FIXED format
//#include "..\..\leechinc\SINTABLE.H"

#include "..\leechinc\GFXPrims.h"	// include GFX primitives to draw to 320*200*256

#include "Mouse.cpp"	// include mouse handler

struct TextureTYPE
 {
 int Graphic;		// Index into GFXList of graphic in memory
 int Width,Height;
 int CurrentFrame;
 int FrameMask;		// Frames can be 0,2,4,8,16,32,64 etc long!
 };

#include "3dstruct.cpp"

//void Transform(ObjectTYPE *Object);	// Takes a pointer to the object

#include "Tree.CPP"	// include tree implementation

#include "spanlist.cpp"

#include "pcx.h"
#include "chars.h"

#define HCENTER    (243)	// Defines Center of display
#define VCENTER    (47)
#define WINLEFT    (166)
#define WINRIGHT   (319)
#define WINTOP     (0)
#define WINBOTTOM  (93)

#define ACCURACY   (16) // 16 pixels to plot then adjust for perspective!

List ScanLine[200];   // This is used to determine free screen positions
List SpanList[200];   // This is used to state which poly is where on screen
List VertLine[320];   // This is used to determine free screen positions
List TreeAlter[100];	// enough for 100 objects inserted into the BSP tree

int ScanBufferTop[320],ScanBufferBottom[320];	// For converting polygons!
char LightBufferLeft[320],LightBufferRight[320];	// For converting polygons!
int XMin=199,XMax=0;	// To allow for faster drawing of polygons

void TexturePlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void WallPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void FloorPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void TextureQPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);

unsigned char GFX1[(64*64)];
unsigned char GFX2[(128*128)];
unsigned char GFX3[(64*64)];
unsigned char GFX4[(64*64)];
unsigned char GFX5[(64*64)];
unsigned char GFX6[(64*64)];

unsigned char far *GFXList[]={GFX1,GFX2,GFX3,GFX4,GFX5,GFX6};

unsigned char LightTables[32][256];	// NB last 32 cols are reserved

float Perspective=WINBOTTOM-WINTOP;
float InvPerspective=-Perspective;

float Sin[360],Cos[360];	// sin & cos based on degrees not rads!

void MakeTables()	// Creates the Sin & Cos tables
 {
 for (int Loop=0;Loop<360;Loop++)
  {
  Sin[Loop]=sin((Loop*M_PI)/180);
  Cos[Loop]=cos((Loop*M_PI)/180);
  }
 }


struct NodeData
 {
 int Type;	// 0 - is divisor  1 - is box
 ObjectTYPE *Ptr;
 int Plane;	// 0 - X   1 - Y   2 - Z
 float Position;
 };

#define NUMGFX 3

TextureTYPE Graphics[NUMGFX]={
			     {0,64,64,0,0},
			     {1,128,128,0,0},
			     {2,64,64,0,3},
			     };

#include "room.3do"	// 3D Room Description TEMP using structs from BKRTRE

//#include "newroom.3do"	// ROOM description based on polygon method

/*NodeData TempStore[14]={{0,NULL,0,39},
			{0,NULL,1,1},
			{1,&Objects[2],0,0},
			{1,&Objects[1],0,0},
			{0,NULL,0,1},
			{1,&Objects[6],0,0},
			{0,NULL,1,11},
			{1,&Objects[5],0,0},
			{0,NULL,0,21},
			{1,&Objects[4],0,0},
			{0,NULL,1,39},
			{1,&Objects[3],0,0},

			{0,NULL,0,21},	// This is used to store the new node
			{1,&Objects[7],0,0},	// that is inserted for the sprite
			};*/

NodeData TempStore[7]={{0,NULL,1,10},
			{1,&Objects[1],0,0},
			{0,NULL,0,25},
			{1,&Objects[2],0,0},
			{1,&Objects[3],0,0}};

Tree BSP(&TempStore[0]);	// create a BSP tree

struct
 {
 float XPos,YPos,ZPos;
 } Player={10,5,5};

struct
 {
 int Ax,Ay,Az;		// rotate eye using these values
 float Ox,Oy,Oz;	// origin of Eye in world coords
 float Xx,Xy,Xz;	// Eye X vector (unit) original
 float Yx,Yy,Yz;	// Eye Y vector (unit) original
 float Zx,Zy,Zz;	// Eye Z vector (unit) original
 float Xwx,Xwy,Xwz;	// Eye X vector (unit) working
 float Ywx,Ywy,Ywz;	// Eye Y vector (unit) working
 float Zwx,Zwy,Zwz;	// Eye Z vector (unit) working
 } Eye={0,0,0,
	5,5,5,
	1,0,0,
	0,1,0,
	0,0,1};

void ZClip(VertexTYPE *Vertex1,VertexTYPE *Vertex2)
 {
 float R;

 R=(1-Vertex1->wz)/(Vertex2->wz-Vertex1->wz);
 Vertex1->wx=Vertex1->wx+(Vertex2->wx-Vertex1->wx)*R;
 Vertex1->wy=Vertex1->wy+(Vertex2->wy-Vertex1->wy)*R;
 Vertex1->light=Vertex1->light+(Vertex2->light-Vertex1->light)*R;
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
    Count++;
    }
   else				// Last Point is invisible
    {
    VertStore[Count].wx=Last->wx;
    VertStore[Count].wy=Last->wy;
    VertStore[Count].wz=Last->wz;
    VertStore[Count].light=Last->light;
    ZClip(&VertStore[Count],Next);
    Count++;
    VertStore[Count].wx=Next->wx;
    VertStore[Count].wy=Next->wy;
    VertStore[Count].wz=Next->wz;
    VertStore[Count].light=Next->light;
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
    ZClip(&VertStore[Count],Next);
    Count++;
    }
   }

  Last=Next;	// Next Point
  }

 return Count;
 }

void ScanConvEdgeWin(long x1,long y1,long x2,long y2)	// To convert standard poly
 {
 long mx;   // slope of x
 long temp; // for swapping
 long x,y;  // source x and y screen coordinates

 if(y1 > y2) // make sure that edge goes from top to bottom
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;
  }

 if (y1<YMin)
  YMin=y1;
 if (y2>YMax)
  YMax=y2;

 if((y2-y1) != 0) // initialize the slopes for stepping the edges
  mx = ((x2-x1) << 16) / (y2-y1); // dx/dy
 else
  mx = ((x2-x1) << 16); // dx

 x=x1<<16;
 for(y=y1;y<=y2;y++)
  {
  if (y>=WINTOP && y<=WINBOTTOM)
   {
   if ((x>>16)<ScanBufferLeft[y])
//    if ((x>>16)>=WINLEFT)
     ScanBufferLeft[y]=(x>>16);
//    else
//     ScanBufferLeft[y]=WINLEFT;
   if ((x>>16)>ScanBufferRight[y])
//    if ((x>>16)<=WINRIGHT)
     ScanBufferRight[y]=(x>>16);
//    else
//     ScanBufferRight[y]=WINRIGHT;
   }
  x+=mx;
  }
 }

// this one is for real light sourcing  ( KEWL HUH! )

void ScanConvEdgeWinG(long x1,long y1,long light1,long x2,long y2,long light2)	// To convert standard poly
 {
 long mx,ml;   // slope of x and light
 long temp;    // for swapping
 long x,y,l;   // source x and y screen coordinates, and light

 if(y1 > y2) // make sure that edge goes from top to bottom
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;

  temp=light1;
  light1=light2;
  light2=temp;
  }

 if (y1<YMin)
  YMin=y1;
 if (y2>YMax)
  YMax=y2;

 if((y2-y1) != 0) // initialize the slopes for stepping the edges
  {
  mx = ((x2-x1) << 16) / (y2-y1); // dx/dy
  ml = ((light2-light1) << 16) / (y2-y1); //dl/dy
  }
 else
  {
  mx = ((x2-x1) << 16); // dx
  ml = ((light2-light1) << 16); // dl
  }

 x=x1<<16;
 l=light1<<16;

 for(y=y1;y<=y2;y++)
  {
  if (y>=WINTOP && y<=WINBOTTOM)
   {
   if ((x>>16)<ScanBufferLeft[y])
    {
//    if ((x>>16)>=WINLEFT)
     ScanBufferLeft[y]=(x>>16);
//    else
//     ScanBufferLeft[y]=WINLEFT;
    LightBufferLeft[y]=(l>>16);
    }
   if ((x>>16)>ScanBufferRight[y])
    {
//    if ((x>>16)<=WINRIGHT)
     ScanBufferRight[y]=(x>>16);
//    else
//     ScanBufferRight[y]=WINRIGHT;
    LightBufferRight[y]=(l>>16);
    }
   }
  x+=mx;
  l+=ml;
  }
 }

void VertConvEdgeWinG(long x1,long y1,long light1,long x2,long y2,long light2)	// To convert standard poly
 {
 long my,ml;   // slope of y and light level
 long temp;    // for swapping
 long x,y,l;   // source x and y screen coordinates and light level

 if(x1 > x2) // make sure that edge goes from left to right
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;

  temp=light1;
  light1=light2;
  light2=temp;
  }

 if (x1<XMin)
  XMin=x1;
 if (x2>XMax)
  XMax=x2;

 if((x2-x1) != 0) // initialize the slopes for stepping the edges
  {
  my = ((y2-y1) << 16) / (x2-x1); // dy/dx
  ml = ((light2-light1) << 16) / (x2-x1); //dl/dx
  }
 else
  {
  my = ((y2-y1) << 16); // dy
  ml = ((light2-light1) << 16); // dl
  }

 y=y1<<16;
 l=light1<<16;

 for(x=x1;x<=x2;x++)
  {
  if (x>=WINLEFT && x<=WINRIGHT)
   {
   if ((y>>16)<ScanBufferTop[x])
    {
//    if ((x>>16)>=WINLEFT)
     ScanBufferTop[x]=(y>>16);
//    else
//     ScanBufferLeft[y]=WINLEFT;
    LightBufferLeft[x]=(l>>16);
    }
   if ((y>>16)>ScanBufferBottom[x])
    {
//    if ((x>>16)<=WINRIGHT)
     ScanBufferBottom[x]=(y>>16);
//    else
//     ScanBufferRight[y]=WINRIGHT;
    LightBufferRight[x]=(l>>16);
    }
   }
  y+=my;
  l+=ml;
  }
 }

void VertConvEdgeWin(long x1,long y1,long x2,long y2)	// To convert standard poly
 {
 long my;   // slope of y
 long temp; // for swapping
 long x,y;  // source x and y screen coordinates

 if(x1 > x2) // make sure that edge goes from left to right
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;
  }

 if (x1<XMin)
  XMin=x1;
 if (x2>XMax)
  XMax=x2;

 if((x2-x1) != 0) // initialize the slopes for stepping the edges
  my = ((y2-y1) << 16) / (x2-x1); // dy/dx
 else
  my = ((y2-y1) << 16); // dy

 y=y1<<16;
 for(x=x1;x<=x2;x++)
  {
  if (x>=WINLEFT && x<=WINRIGHT)
   {
   if ((y>>16)<ScanBufferTop[x])
//    if ((x>>16)>=WINLEFT)
     ScanBufferTop[x]=(y>>16);
//    else
//     ScanBufferLeft[y]=WINLEFT;
   if ((y>>16)>ScanBufferBottom[x])
//    if ((x>>16)<=WINRIGHT)
     ScanBufferBottom[x]=(y>>16);
//    else
//     ScanBufferRight[y]=WINRIGHT;
   }
  y+=my;
  }
 }

void InsertSpan(int Left,int Right,int Line)
 {
 ListNode *Pointer=ScanLine[Line].Root;
 ListNode *Temp;

// UpdateScreen();

 while(Pointer!=NULL)
  {
   if (Left==Pointer->Left && Right==Pointer->Right)
    {
    Pointer->Left=WINRIGHT+1;
    Pointer->Right=WINLEFT-1;
    Pointer=Pointer->Pointer;
    continue;
    }
   if (Left==Pointer->Left && Right<Pointer->Right)
    {
    Pointer->Left=Right;	// clip left of span
    Pointer=Pointer->Pointer;
    continue;
    }
   if (Left>Pointer->Left && Right==Pointer->Right)
    {
    Pointer->Right=Left;	// clip right of span
    Pointer=Pointer->Pointer;
    continue;
    }
   if (Left>Pointer->Left && Right<Pointer->Right)
    {
    Temp=Pointer->Pointer;	// store current pointer
    ScanLine[Line].Insert(Right,Pointer->Right,Pointer); // add new span
    Pointer->Right=Left;	// clip right of span
    Pointer=Pointer->Pointer;
    Pointer->Pointer=Temp; // point to next span
    continue;
    }
  Pointer=Pointer->Pointer;
  }
 }

void InsertVert(int Top,int Bottom,int Line)
 {
 ListNode *Pointer=VertLine[Line].Root;
 ListNode *Temp;

// UpdateScreen();

 while(Pointer!=NULL)
  {
   if (Top==Pointer->Left && Bottom==Pointer->Right)
    {
    Pointer->Left=WINBOTTOM+1;
    Pointer->Right=WINTOP-1;
    Pointer=Pointer->Pointer;
    continue;
    }
   if (Top==Pointer->Left && Bottom<Pointer->Right)
    {
    Pointer->Left=Bottom;	// clip top of vert
    Pointer=Pointer->Pointer;
    continue;
    }
   if (Top>Pointer->Left && Bottom==Pointer->Right)
    {
    Pointer->Right=Top;		// clip bottom of span
    Pointer=Pointer->Pointer;
    continue;
    }
   if (Top>Pointer->Left && Bottom<Pointer->Right)
    {
    Temp=Pointer->Pointer;	// store current pointer
    VertLine[Line].Insert(Bottom,Pointer->Right,Pointer); // add new span
    Pointer->Right=Top;	// clip right of span
    Pointer=Pointer->Pointer;
    Pointer->Pointer=Temp; // point to next span
    continue;
    }
  Pointer=Pointer->Pointer;
  }
 }

void AddPolyToSpan(int Left,int Right,PolygonTYPE *Polygon,int Line)
 {
 ListNode *Pointer=SpanList[Line].Root;
 ListNode *Temp;

// UpdateScreen();

 Temp=Pointer->Pointer;
 SpanList[Line].Insert(Left,Right,Pointer,Polygon);
 Pointer=Pointer->Pointer;
 Pointer->Pointer=Temp;
 }

PolygonTYPE *WhichPolygon(int X,int Y)
 {
 ListNode *Pointer=SpanList[Y].Root;

 while (Pointer!=NULL)
  {
  if (X>=Pointer->Left && X<=Pointer->Right)
   return Pointer->Polygon;
  Pointer=Pointer->Pointer;
  }

 return NULL;
 }

void DisplaySector(ObjectTYPE *Object)
 {
 PolygonTYPE *PolygonPointer;
 float ZStore;
 float DX1,DX2,DY1,DY2;
 VertexTYPE VertsTemp[NUMVERTS*2];	// Temp Store For Z Clipping
 int Clipping,n,j;

 PolygonPointer=Object->PolygonList;

 for (int Loop=0;Loop<Object->NumOfPolygons;Loop++,PolygonPointer++)
  {
  Clipping=PolyClipZ(PolygonPointer,VertsTemp);

  if (Clipping>2 && PolygonPointer->TypeOfPolygon==POLY_TEXTUR &&
     (VertsTemp[0].wx*PolygonPointer->Nwx+
      VertsTemp[0].wy*PolygonPointer->Nwy+
      VertsTemp[0].wz*PolygonPointer->Nwz)>0)
   {

   for (n=0;n<Clipping;n++)	// Perspectivate the coords now they are clipped
    {
    ZStore=Perspective/VertsTemp[n].wz;
    VertsTemp[n].sx=VertsTemp[n].wx*ZStore+HCENTER;
    VertsTemp[n].sy=VertsTemp[n].wy*(-ZStore)+VCENTER;
    }

   TexturePlot(VertsTemp,Clipping,PolygonPointer);
   }
  else
  if (Clipping>2 && PolygonPointer->TypeOfPolygon==POLY_QTEXT &&
     (VertsTemp[0].wx*PolygonPointer->Nwx+
      VertsTemp[0].wy*PolygonPointer->Nwy+
      VertsTemp[0].wz*PolygonPointer->Nwz)>0)
   {

   for (n=0;n<Clipping;n++)	// Perspectivate the coords now they are clipped
    {
    ZStore=Perspective/VertsTemp[n].wz;
    VertsTemp[n].sx=VertsTemp[n].wx*ZStore+HCENTER;
    VertsTemp[n].sy=VertsTemp[n].wy*(-ZStore)+VCENTER;
    }

   TextureQPlot(VertsTemp,Clipping,PolygonPointer);
   }
  else
  if (Clipping>2 && PolygonPointer->TypeOfPolygon==POLY_WALL &&
     (VertsTemp[0].wx*PolygonPointer->Nwx+
      VertsTemp[0].wy*PolygonPointer->Nwy+
      VertsTemp[0].wz*PolygonPointer->Nwz)>0)
   {

   for (n=0;n<Clipping;n++)	// Perspectivate the coords now they are clipped
    {
    ZStore=Perspective/VertsTemp[n].wz;
    VertsTemp[n].sx=VertsTemp[n].wx*ZStore+HCENTER;
    VertsTemp[n].sy=VertsTemp[n].wy*(-ZStore)+VCENTER;
    }

   WallPlot(VertsTemp,Clipping,PolygonPointer);
   }
  else
  if (Clipping>2 && PolygonPointer->TypeOfPolygon==POLY_FLOOR &&
     (VertsTemp[0].wx*PolygonPointer->Nwx+
      VertsTemp[0].wy*PolygonPointer->Nwy+
      VertsTemp[0].wz*PolygonPointer->Nwz)>0)
   {

   for (n=0;n<Clipping;n++)	// Perspectivate the coords now they are clipped
    {
    ZStore=Perspective/VertsTemp[n].wz;
    VertsTemp[n].sx=VertsTemp[n].wx*ZStore+HCENTER;
    VertsTemp[n].sy=VertsTemp[n].wy*(-ZStore)+VCENTER;
    }

   FloorPlot(VertsTemp,Clipping,PolygonPointer);
   }
  else
  if (Clipping>2 && PolygonPointer->TypeOfPolygon==POLY_NORMAL &&
     (VertsTemp[0].wx*PolygonPointer->Nwx+
      VertsTemp[0].wy*PolygonPointer->Nwy+
      VertsTemp[0].wz*PolygonPointer->Nwz)>0)
   {
   YMin=WINBOTTOM;	// set up optimal buffers
   YMax=WINTOP;

   for(int i=0;i<200;i++)	// Initialises Scanbuffer
    {
    ScanBufferLeft[i]=WINRIGHT;
    ScanBufferRight[i]=WINLEFT;
    }

   for (n=0;n<Clipping;n++)	// Perspectivate the coords now they are clipped
    {
    ZStore=Perspective/VertsTemp[n].wz;
    VertsTemp[n].sx=VertsTemp[n].wx*ZStore+HCENTER;
    VertsTemp[n].sy=VertsTemp[n].wy*(-ZStore)+VCENTER;
    }

   j=Clipping-1;	// set to last point (draw last to first and round!
   for (n=0;n<Clipping;n++)
    {
    ScanConvEdgeWin(VertsTemp[j].sx,VertsTemp[j].sy,VertsTemp[n].sx,VertsTemp[n].sy);
    j=n;
    }

   if (YMin<WINTOP)
    YMin=WINTOP;
   if (YMax>WINBOTTOM)
    YMax=WINBOTTOM;

   if (YMin!=YMax)
    for (int Y=YMin;Y<=YMax;Y++)
     {
     ListNode *Pointer=ScanLine[Y].Root;

     int ScanLeft,ScanRight;

     while (Pointer!=NULL)
      {
      ScanLeft=ScanBufferLeft[Y];
      ScanRight=ScanBufferRight[Y];

      if (ScanLeft<Pointer->Left) // is poly span left visible
       ScanLeft=Pointer->Left;
      if (ScanRight>Pointer->Right)
       ScanRight=Pointer->Right;
      if (ScanLeft<ScanRight)
       {
       InsertSpan(ScanLeft,ScanRight,Y); // fill in buffer
       AddPolyToSpan(ScanLeft,ScanRight,PolygonPointer,Y);

       DrawHorizontal(ScanLeft,Y,ScanRight-ScanLeft,PolygonPointer->Colour);
       }
      Pointer=Pointer->Pointer;
      }
     }

   }
  }
 }

void ShowTree(TreeNode *Node)	// Use this to draw the screen from the BSP
 {
 NodeData *Element;

 if(Node==NULL)
  return;	// edge of tree

 Element=(NodeData *)Node->Element;
 if(Element->Type==1)	// convex object found
  {
  if (Element->Plane!=0)
   DisplaySector(&Objects[Element->Plane]);// display sprite basicly (HACK VERSION)
  DisplaySector(Element->Ptr);
  return;
  }
 else
  {
  if (Element->Plane==0)
   {
   if (Element->Position>Player.XPos)
    {
    ShowTree(Node->Left);	// go left then right
    ShowTree(Node->Right);
    }
   else
    {
    ShowTree(Node->Right);	// go right then left
    ShowTree(Node->Left);
    }
   return;
   }
  if (Element->Plane==1)
   {
   if (Element->Position>Player.YPos)
    {
    ShowTree(Node->Left);	// go left then right
    ShowTree(Node->Right);
    }
   else
    {
    ShowTree(Node->Right);	// go right then left
    ShowTree(Node->Left);
    }
   return;
   }
  if (Element->Plane==2)
   {
   if (Element->Position>Player.ZPos)
    {
    ShowTree(Node->Left);	// go left then right
    ShowTree(Node->Right);
    }
   else
    {
    ShowTree(Node->Right);	// go right then left
    ShowTree(Node->Left);
    }
   return;
   }
  }
 }

void Transform(ObjectTYPE *Object,int A4,int A5,int A6)	// Takes a pointer to the object
 {
 float SS,CS,XX,XY,XZ,YX,YY,YZ,ZX,ZY,ZZ;
 float SA1,SA2,SA3,CA1,CA2,CA3;
 int A1,A2,A3,count;
 float Ox,Oy,Oz;
 VertexTYPE *VertexPointer;

 Ox=Object->Ox;
 Oy=Object->Oy;
 Oz=Object->Oz;

 A1=Eye.Ax;	// Get rotate X angle (e.g. 3 degrees)
 A2=Eye.Ay;	// Get rotate Y angle
 A3=Eye.Az;	// Get rotate Z angle

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

 // rotate eye to correct angle of incline in 3D space ...
 //
 //                         Y Z
 //                         |/
 //                      Eye.-X

 // Eye is a unit normal so lengths should be 1... but if error sod it!

 Eye.Xwx=XX*Eye.Xx+XY*Eye.Xy+XZ*Eye.Xz;
 Eye.Xwy=YX*Eye.Xx+YY*Eye.Xy+YZ*Eye.Xz;
 Eye.Xwz=ZX*Eye.Xx+ZY*Eye.Xy+ZZ*Eye.Xz;
 Eye.Ywx=XX*Eye.Yx+XY*Eye.Yy+XZ*Eye.Yz;
 Eye.Ywy=YX*Eye.Yx+YY*Eye.Yy+YZ*Eye.Yz;
 Eye.Ywz=ZX*Eye.Yx+ZY*Eye.Yy+ZZ*Eye.Yz;
 Eye.Zwx=XX*Eye.Zx+XY*Eye.Zy+XZ*Eye.Zz;
 Eye.Zwy=YX*Eye.Zx+YY*Eye.Zy+YZ*Eye.Zz;
 Eye.Zwz=ZX*Eye.Zx+ZY*Eye.Zy+ZZ*Eye.Zz;

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

 VertexTYPE Temp;

 for (count=0;count<Object->NumOfVertices;count++)
  {
  // Rotate points by using dot product!!!! ;-)
  // This looks awful but should work in theory!

  Temp.wx=Eye.Xwx*(VertexPointer->ox+Ox-Eye.Ox)+Eye.Xwy*(VertexPointer->oy+Oy-Eye.Oy)+Eye.Xwz*(VertexPointer->oz+Oz-Eye.Oz);
  Temp.wy=Eye.Ywx*(VertexPointer->ox+Ox-Eye.Ox)+Eye.Ywy*(VertexPointer->oy+Oy-Eye.Oy)+Eye.Ywz*(VertexPointer->oz+Oz-Eye.Oz);
  Temp.wz=Eye.Zwx*(VertexPointer->ox+Ox-Eye.Ox)+Eye.Zwy*(VertexPointer->oy+Oy-Eye.Oy)+Eye.Zwz*(VertexPointer->oz+Oz-Eye.Oz);

  VertexPointer->wx=XX*Temp.wx+XY*Temp.wy+XZ*Temp.wz;
  VertexPointer->wy=YX*Temp.wx+YY*Temp.wy+YZ*Temp.wz;
  VertexPointer->wz=ZX*Temp.wx+ZY*Temp.wy+ZZ*Temp.wz;

  // Perspective removed and placed in drawing function to accomodate the
  // Z clipper

  VertexPointer++;		// Goto next vertex
  }

 PolygonTYPE *PolygonPointer=Object->PolygonList;

 for (count=0;count<Object->NumOfPolygons;count++) // rotate poly normals
  {
  Temp.wx=Eye.Xwx*PolygonPointer->Nx+Eye.Xwy*PolygonPointer->Ny+Eye.Xwz*PolygonPointer->Nz;
  Temp.wy=Eye.Ywx*PolygonPointer->Nx+Eye.Ywy*PolygonPointer->Ny+Eye.Ywz*PolygonPointer->Nz;
  Temp.wz=Eye.Zwx*PolygonPointer->Nx+Eye.Zwy*PolygonPointer->Ny+Eye.Zwz*PolygonPointer->Nz;

  PolygonPointer->Nwx=XX*Temp.wx+XY*Temp.wy+XZ*Temp.wz;
  PolygonPointer->Nwy=YX*Temp.wx+YY*Temp.wy+YZ*Temp.wz;
  PolygonPointer->Nwz=ZX*Temp.wx+ZY*Temp.wy+ZZ*Temp.wz;

  PolygonPointer++;
  }

 }

void LineClip(int X1,int Y1,int X2,int Y2,int Colour,int WindLeft,int WindRight,int WindTop,int WindBottom)
 {
 if (X1<WindLeft)
  X1=WindLeft;
 if (X1>WindRight)
  X1=WindRight;
 if (Y1<WindTop)
  Y1=WindTop;
 if (Y1>WindBottom)
  Y1=WindBottom;
 if (X2<WindLeft)
  X2=WindLeft;
 if (X2>WindRight)
  X2=WindRight;
 if (Y2<WindTop)
  Y2=WindTop;
 if (Y2>WindBottom)
  Y2=WindBottom;

 DrawLine(X1,Y1,X2,Y2,Colour);
 }

void DrawXY()
 {
 int j;
 ObjectTYPE *ObjectPointer;
 PolygonTYPE *PolyPointer;

 ObjectPointer=&Objects[0];

 for (int a=0;a<NumberObjects;a++)
  {
  if (ObjectPointer->ObjectType==OBJECT_SECTOR)
   {
   PolyPointer=ObjectPointer->PolygonList;
   for (int b=0;b<ObjectPointer->NumOfPolygons;b++)
    {
    j=PolyPointer->NumVertices-1;	// set to last point (draw last to first and round!
    for (int n=0;n<PolyPointer->NumVertices;n++)
     {
     LineClip(PolyPointer->Vertex[j]->ox+77,
	     PolyPointer->Vertex[j]->oy+153,
	     PolyPointer->Vertex[n]->ox+77,
	     PolyPointer->Vertex[n]->oy+153,
	     PolyPointer->Colour,0,154,106,199);
     j=n;
     }
    PolyPointer++;
    }
   }
  if (ObjectPointer->ObjectType==OBJECT_SPRITE)
   {
   if (ObjectPointer->Ox+77>=0 && ObjectPointer->Ox+77<=154 &&
     ObjectPointer->Oy+153>=106 && ObjectPointer->Oy+153<=199)
    PutPixel((int)ObjectPointer->Ox+77,(int)ObjectPointer->Oy+153,255);
   }

  ObjectPointer++;
  }
 }

void DrawYZ()
 {
 int j;
 ObjectTYPE *ObjectPointer;
 PolygonTYPE *PolyPointer;

 ObjectPointer=&Objects[0];

 for (int a=0;a<NumberObjects;a++)
  {
  if (ObjectPointer->ObjectType==OBJECT_SECTOR)
   {
   PolyPointer=ObjectPointer->PolygonList;
   for (int b=0;b<ObjectPointer->NumOfPolygons;b++)
    {
    j=PolyPointer->NumVertices-1;	// set to last point (draw last to first and round!
    for (int n=0;n<PolyPointer->NumVertices;n++)
     {
     LineClip(PolyPointer->Vertex[j]->oz+243,
	     PolyPointer->Vertex[j]->oy+153,
	     PolyPointer->Vertex[n]->oz+243,
	     PolyPointer->Vertex[n]->oy+153,
	     PolyPointer->Colour,166,319,106,199);
     j=n;
     }
    PolyPointer++;
    }
   }
  if (ObjectPointer->ObjectType==OBJECT_SPRITE)
   {
   if (ObjectPointer->Oz+243>=166 && ObjectPointer->Oz+243<=319 &&
     ObjectPointer->Oy+153>=106 && ObjectPointer->Oy+153<=199)
    PutPixel((int)ObjectPointer->Oz+243,(int)ObjectPointer->Oy+153,255);
   }

  ObjectPointer++;
  }
 }

void DrawXZ()
 {
 int j;
 ObjectTYPE *ObjectPointer;
 PolygonTYPE *PolyPointer;

 ObjectPointer=&Objects[0];

 for (int a=0;a<NumberObjects;a++)
  {
  if (ObjectPointer->ObjectType==OBJECT_SECTOR)
   {
   PolyPointer=ObjectPointer->PolygonList;
   for (int b=0;b<ObjectPointer->NumOfPolygons;b++)
    {
    j=PolyPointer->NumVertices-1;	// set to last point (draw last to first and round!
    for (int n=0;n<PolyPointer->NumVertices;n++)
     {
     LineClip(PolyPointer->Vertex[j]->ox+77,
	     PolyPointer->Vertex[j]->oz+47,
	     PolyPointer->Vertex[n]->ox+77,
	     PolyPointer->Vertex[n]->oz+47,
	     PolyPointer->Colour,0,154,0,93);
     j=n;
     }
    PolyPointer++;
    }
   }
  if (ObjectPointer->ObjectType==OBJECT_SPRITE)
   {
   if (ObjectPointer->Ox+77>=0 && ObjectPointer->Ox+77<=154 &&
     ObjectPointer->Oz+47>=0 && ObjectPointer->Oz+47<=93)
    PutPixel((int)ObjectPointer->Ox+77,(int)ObjectPointer->Oz+47,255);
   }

  ObjectPointer++;
  }
 }

void DrawWindows()
 {
 CLS();

 for (int a=0;a<200;a++)
  {
  ScanLine[a].Clear(ScanLine[a].Root);	// delete members
  SpanList[a].Clear(SpanList[a].Root);
  ScanLine[a].Create(WINLEFT,WINRIGHT);
  SpanList[a].Create(-1,-1,NULL);
  }
 for (a=0;a<320;a++)
  {
  VertLine[a].Clear(VertLine[a].Root);	// delete members
  VertLine[a].Create(WINTOP,WINBOTTOM);
  }

 // Draw Dividing Lines
 DrawLine(160,0,160,199,15);
 DrawLine(0,100,319,100,15);

// DisplaySprites();	// This loops through all sprites per sector :(

 // Draw The 3D projection
 ShowTree(BSP.Root);	// display in correct order for player position


// for (int n=0;n<3;n++)
//  DrawBox(Boxes[n]);

// PutPixel(Fixed2Int(Player.XPos),Fixed2Int(Player.YPos),15);

 // Draw the X-Y view

 DrawXY();
 DrawLine(Eye.Zwx*20+30,
	  Eye.Zwy*20+156,30,156,5);
 PutPixel(30,156,15);
 if (Eye.Ox+77>=0 && Eye.Ox+77<=154 &&
     Eye.Oy+153>=106 && Eye.Oy+153<=199)
  PutPixel((int)Eye.Ox+77,(int)Eye.Oy+153,15);

 // Draw the X-Z view

 DrawXZ();
 DrawLine(Eye.Zwx*20+30,
	  Eye.Zwz*20+50,30,50,5);
 PutPixel(30,50,15);
 if (Eye.Ox+77>=0 && Eye.Ox+77<=154 &&
     Eye.Oz+47>=0 && Eye.Oz+47<=93)
  PutPixel((int)Eye.Ox+77,(int)Eye.Oz+47,15);

 // Draw the Y-Z view

 DrawYZ();
 DrawLine(Eye.Zwz*20+190,
	  Eye.Zwy*20+156,190,156,5);
 PutPixel(190,156,15);
 if (Eye.Oz+243>=166 && Eye.Oz+243<=319 &&
     Eye.Oy+153>=106 && Eye.Oy+153<=199)
  PutPixel((int)Eye.Oz+243,(int)Eye.Oy+153,15);
 }

PCXHeader HeaderInfo;

unsigned char Palette[256*3];

void AnimateTextures()
 {
 for (int a=0;a<NUMGFX;a++)
  {
  Graphics[a].CurrentFrame++;
  if (Graphics[a].CurrentFrame>=Graphics[a].FrameMask)
   Graphics[a].CurrentFrame=0;
//  Graphics[a].CurrentFrame&=Graphics[a].FrameMask; // make in anim range
  }
 }

void InsertSprite(TreeNode *Node,ObjectTYPE *Object,int Plane=0,int Position=0)
 {
 NodeData *Temp;
 NodeData *Element;

 Element=(NodeData *)Node->Element;

 if(Element->Type==1)	// object found (End of search - Insert here)
  {
  TempStore[12].Type=0;
  TempStore[12].Ptr=NULL;

  if (Plane==0)
   {
   TempStore[12].Plane=0;
   TempStore[12].Position=Object->Ox;
   TempStore[13].Type=1;
   TempStore[13].Ptr=Object;
   Temp=Element;
   Node->Element=&TempStore[12];

   if (Position>Object->Ox)
    {
    BSP.InsertLeft(Temp,Node);
    BSP.InsertRight(&TempStore[13],Node);
    }
   else
    {
    BSP.InsertRight(Temp,Node);
    BSP.InsertLeft(&TempStore[13],Node);
    }
   }
  if (Plane==1)
   {
   TempStore[12].Plane=1;
   TempStore[12].Position=Object->Oy;
   TempStore[13].Type=1;
   TempStore[13].Ptr=Object;
   Temp=Element;
   Node->Element=&TempStore[12];

   if (Position<Object->Oy)
    {
    BSP.InsertLeft(Temp,Node);
    BSP.InsertRight(&TempStore[13],Node);
    }
   else
    {
    BSP.InsertRight(Temp,Node);
    BSP.InsertLeft(&TempStore[13],Node);
    }
   }
  if (Plane==2)
   {
   TempStore[12].Plane=2;
   TempStore[12].Position=Object->Oz;
   TempStore[13].Type=1;
   TempStore[13].Ptr=Object;
   Temp=Element;
   Node->Element=&TempStore[12];

   if (Position>Object->Oz)
    {
    BSP.InsertLeft(Temp,Node);
    BSP.InsertRight(&TempStore[13],Node);
    }
   else
    {
    BSP.InsertRight(Temp,Node);
    BSP.InsertLeft(&TempStore[13],Node);
    }
   }

  return;
  }
 else
  {
  if (Element->Plane==0)
   {
   if (Element->Position>Object->Ox)
    {
    InsertSprite(Node->Left,Object,Element->Plane,Element->Position);	// go left then right
    }
   else
    {
    InsertSprite(Node->Right,Object,Element->Plane,Element->Position);	// go right then left
    }            
   return;
   }
  if (Element->Plane==1)
   {
   if (Element->Position>Object->Oy)
    {
    InsertSprite(Node->Left,Object,Element->Plane,Element->Position);	// go left then right
    }
   else
    {
    InsertSprite(Node->Right,Object,Element->Plane,Element->Position);	// go right then left
    }
   return;
   }
  if (Element->Plane==2)
   {
   if (Element->Position>Object->Oz)
    {
    InsertSprite(Node->Left,Object,Element->Plane,Element->Position);	// go left then right
    }
   else
    {
    InsertSprite(Node->Right,Object,Element->Plane,Element->Position);	// go right then left
    }
   return;
   }
  }
 }

void BuildTree()	// This is a quick hack to rebuild the tree slowly
 {
/* BSP.Clear(BSP.Root->Left);
 BSP.Clear(BSP.Root->Right);

 BSP.InsertLeft(&TempStore[1],BSP.Root);

 BSP.InsertRight(&TempStore[2],BSP.Root);

 TreeNode *Branch;

 Branch=BSP.Root->Left;

 BSP.InsertLeft(&TempStore[3],Branch);

 BSP.InsertRight(&TempStore[4],Branch);

 Branch=Branch->Right;

 BSP.InsertLeft(&TempStore[5],Branch);

 BSP.InsertRight(&TempStore[6],Branch);

 Branch=Branch->Right;

 BSP.InsertLeft(&TempStore[7],Branch);

 BSP.InsertRight(&TempStore[8],Branch);

 Branch=Branch->Right;

 BSP.InsertLeft(&TempStore[9],Branch);

 BSP.InsertRight(&TempStore[10],Branch);

 Branch=Branch->Right;

 BSP.InsertLeft(&TempStore[11],Branch);

 InsertSprite(BSP.Root,&Objects[7]);	// Insert sprite into Tree*/

 BSP.InsertLeft(&TempStore[1],BSP.Root);

 BSP.InsertRight(&TempStore[2],BSP.Root);

 TreeNode *RightBranch;

 RightBranch=BSP.Root->Right;

 BSP.InsertLeft(&TempStore[3],RightBranch);

 BSP.InsertRight(&TempStore[4],RightBranch);

 }

void BuildLightTables()	// this is fixed shoddy knackered code :)
 {
 int col,block;
 for (int a=15;a>=0;a--)
  {
  for (int b=0;b<256;b++)	// for all colours (note last 32 are wrong!)
   {
   block=b/16;			// which block is b in
   col=b-a;
   if (col/16!=block)
    col=block*16;
   LightTables[a][b]=col;
   }
  }

/* for (int a=31;a>=0;a--)
  {
  for (int b=0;b<256;b++)	// for all colours (note last 32 are wrong!)
   {
   LightTables[a][b]=b;
   }
  }*/

 }

void main()
 {
 MakeTables();	//create sin & cos tables in memory

 int MouseX,MouseY;

 char Key;
 int Loop,Loop2,Engine=0;

 InitialiseGFX();

 unsigned char Byte,Count;

 GetPCXInfo(&HeaderInfo,"capt0000.PCX");
 GetPCXPicture(&HeaderInfo,"capt0000.PCX",GFX1);
 GetPCXInfo(&HeaderInfo,"capt0003.PCX");
 GetPCXPicture(&HeaderInfo,"capt0003.PCX",GFX2);

 GetPCXInfo(&HeaderInfo,"capt0004.PCX");
 GetPCXPicture(&HeaderInfo,"capt0004.PCX",GFX3);
 GetPCXPicture(&HeaderInfo,"capt0004.PCX",GFX6);
 GetPCXPalette(&HeaderInfo,"capt0004.PCX",Palette);
 SetPalette(Palette,0,256);

 GetPCXInfo(&HeaderInfo,"capt0005.PCX");
 GetPCXPicture(&HeaderInfo,"capt0005.PCX",GFX4);

 GetPCXInfo(&HeaderInfo,"capt0006.PCX");
 GetPCXPicture(&HeaderInfo,"capt0006.PCX",GFX5);

 int light=0;

 BuildLightTables();

 while (1==1)
  {
  for (int yp=0;yp<64;yp++)
   for (int xp=0;xp<64;xp++)
    PutPixel(xp,yp,LightTables[light][GFX3[xp+yp*64]]);

  for (int ColY=0;ColY<16;ColY++)
   for (int ColX=0;ColX<64;ColX++)
    for (int Con=0;Con<5;Con++)
     PutPixel(ColX*5+Con,199-ColY,LightTables[light][ColX+(ColY/4)*64]);

  char String[50];

  sprintf(String,"Texture Width = %i, Height = %i",
	 HeaderInfo.Xmax-HeaderInfo.Xmin+1,
	 HeaderInfo.Ymax-HeaderInfo.Ymin+1);

  PlotText(0,150,String,255);

  UpdateScreen();

  char ch=getch();

  if (ch==' ')
   break;
  if (ch=='+' && light<7)
   light++;
  if (ch=='-' && light>0)
   light--;
  }

 if(initmouse())
  exit(0);

 show_mouse();

 BuildTree();

 int Rotate1=0,Rotate2=90,Rotate3=270;
 int BankX=0,BankY=0,BankZ=0;

 float Direc=-.25;

 while (1==1)
  {
  Eye.Ax=Rotate1;		// rotate Eye as follows
  Eye.Ay=Rotate2;
  Eye.Az=Rotate3;

  Eye.Ox=Player.XPos;
  Eye.Oy=Player.YPos;
  Eye.Oz=Player.ZPos;

//  Objects[4].Ox+=Direc;
  if (Objects[4].Ox<10)
   Direc=.25;
  if (Objects[4].Ox>55)
   Direc=-.25;

//  BuildTree();	// BSP Tree is built and rebuilt at this point

//  for (Loop=0;Loop<1;Loop++)
  Transform(&Objects[0],BankX,BankY,BankZ);	// Rotate scene & translate to world pos etc.

  for (Loop=1;Loop<NumberObjects;Loop++)
   if (Objects[Loop].ObjectType==OBJECT_SPRITE)
    Transform(&Objects[Loop],BankX,BankY,BankZ);

  AnimateTextures();	// Goto Next Frame for textures

  DrawWindows();

  hide_mouse();
  UpdateScreen();
  show_mouse();

  if (getmousedata(MouseX,MouseY)!=0 && MouseX>=166 && MouseX<=319
      && MouseY>=106 && MouseY<=199)
   {
   Player.ZPos=MouseX-243;
   Player.YPos=MouseY-153;
   }
  if (getmousedata(MouseX,MouseY)!=0 && MouseX>=0 && MouseX<=154
      && MouseY>=106 && MouseY<=199)
   {
   Player.XPos=MouseX-77;
   Player.YPos=MouseY-153;
   }
  if (getmousedata(MouseX,MouseY)!=0 && MouseX>=0 && MouseX<=154
      && MouseY>=0 && MouseY<=93)
   {
   Player.XPos=MouseX-77;
   Player.ZPos=MouseY-47;
   }

// check for mouse press within 3d window

  PolygonTYPE *Poly;

  Poly=WhichPolygon(MouseX,MouseY);
  int TextureNum;

  if(kbhit())
   {
   Key=getch();

   if (Poly!=NULL)
    {
    if (Poly->TypeOfPolygon==POLY_NORMAL)
     {
     if (Key=='+')
      {
      Poly->Colour++;
      Poly->Colour&=0xff;
      }
     if (Key=='-')
      {
      Poly->Colour--;
      Poly->Colour&=0xff;
      }
     }
    if (Poly->TypeOfPolygon!=POLY_NORMAL)
     {
     if (Key=='+')
      {
      TextureNum=(Poly->Texture-&Graphics[0]);
      TextureNum++;
      if (TextureNum>=NUMGFX)
       TextureNum=0;
      Poly->Texture=&Graphics[TextureNum];
      }
     if (Key=='-')
      {
      TextureNum=(Poly->Texture-&Graphics[0]);
      TextureNum--;
      if (TextureNum<0)
       TextureNum=NUMGFX-1;
      Poly->Texture=&Graphics[TextureNum];
      }
     if (Key=='.')
      Poly->TextureModX+=0.01;
     if (Key==',')
      if (Poly->TextureModX>.01)
       Poly->TextureModX-=0.01;
     if (Key=='/')
      if (Poly->TextureModY>.01)
       Poly->TextureModY-=0.01;
     if (Key=='\'')
      Poly->TextureModY+=0.01;
     if (Key=='<')
      Poly->TextOffX--;
     if (Key=='>')
      Poly->TextOffX++;
     if (Key=='?')
      Poly->TextOffY--;
     if (Key=='@')
      Poly->TextOffY++;
     }
    }

   if (Key=='9')
    {
    BankX+=5;
    if (BankX>359)
     BankX-=360;
    }
   if (Key=='7')
    {
    BankX-=5;
    if (BankX<0)
     BankX+=360;
    }
   if (Key=='6')
    {
    Rotate2+=5;
    if (Rotate2>359)
     Rotate2-=360;
    }
   if (Key=='4')
    {
    Rotate2-=5;
    if (Rotate2<0)
     Rotate2+=360;
    }
//   if (Key=='6')
//    {
//    BankY+=5;
//    if (BankY>359)
//     BankY-=360;
//    }
//   if (Key=='4')
//    {
//    BankY-=5;
//    if (BankY<0)
//     BankY+=360;
//    }
   if (Key=='3')
    {
    BankZ+=5;
    if (BankZ>359)
     BankZ-=360;
    }
   if (Key=='1')
    {
    BankZ-=5;
    if (BankZ<0)
     BankZ+=360;
    }
   if (Key=='8')
     BankX=0;
   if (Key=='5')
    Rotate2=0;
//   if (Key=='5')
//    BankY=0;
   if (Key=='2')
    BankZ=0;
//   if (Key=='+')		// alter perspective (just a theory test)
//    Perspective+=5;
//   if (Key=='-')
//    Perspective-=5;
   if (Key=='q')
    {
    Player.XPos+=Eye.Zwx;
    Player.YPos+=Eye.Zwy;
    Player.ZPos+=Eye.Zwz;
    }
   if (Key=='a')
    {
    Player.XPos-=Eye.Zwx;
    Player.YPos-=Eye.Zwy;
    Player.ZPos-=Eye.Zwz;
    }
   if (Key==13)	// turn on/off engine
    {
    if (Engine==0)
     Engine=1;
    else
     Engine=0;
    }
   if (Key==' ')
    break;
   }

  }

 KillGFX();
 }

void TexturePlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float Px,Py,Pz,Mx,My,Mz,Nx,Ny,Nz;
 float Oa,Ha,Va,Ob,Hb,Vb,Oc,Hc,Vc;
 float a,b,c;
 float u,v;
 int j,n,i;

 Px=Perspective*Polygon->TxtP->wx;	// In my coords 0 is the origin of the square
 Py=-Perspective*Polygon->TxtP->wy;	// Remember the Coords are being swapped here! (Z & Y)
 Pz=Polygon->TxtP->wz;

 Mx=(Perspective*Polygon->TxtM->wx-Px)*Polygon->TextureModX; // Create Vector M
 My=(-Perspective*Polygon->TxtM->wy-Py)*Polygon->TextureModX;
 Mz=(Polygon->TxtM->wz-Pz)*Polygon->TextureModX;

 Nx=(Perspective*Polygon->TxtN->wx-Px)*Polygon->TextureModY; // Create Vector N
 Ny=(-Perspective*Polygon->TxtN->wy-Py)*Polygon->TextureModY;
 Nz=(Polygon->TxtN->wz-Pz)*Polygon->TextureModY;

 Oa=Ny*Px-Nx*Py;	// Compute magic numbers
 Ha=Nz*Py-Ny*Pz;
 Va=Nx*Pz-Nz*Px;

 Ob=Mx*Py-My*Px;
 Hb=My*Pz-Mz*Py;
 Vb=Mz*Px-Mx*Pz;

 Oc=My*Nx-Mx*Ny;
 Hc=Mz*Ny-My*Nz;
 Vc=Mx*Nz-Mz*Nx;

 char *GFXPointer=GFXList[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

 for(i=0;i<200;i++)	// Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWin(Vertices[j].sx,Vertices[j].sy,Vertices[n].sx,Vertices[n].sy);
  j=n;
  }

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

 for (j=YMin;j<=YMax;j++)	// set to YMin+1 for now as avoids an error!
  {
// The following tests are to determine if a drawing span is visible

  ListNode *Pointer=ScanLine[j].Root;

  int ScanLeft,ScanRight;

  while (Pointer!=NULL)
   {
   ScanLeft=ScanBufferLeft[j];
   ScanRight=ScanBufferRight[j];

   if (ScanLeft<Pointer->Left) // is poly span left visible
    ScanLeft=Pointer->Left;
   if (ScanRight>Pointer->Right)
    ScanRight=Pointer->Right;

   // Only draws if the span is valid e.g. Left - Right

   if (ScanLeft<ScanRight)
    {
    a = Oa+(j-VCENTER)*Va;	// Intermediate values
    b = Ob+(j-VCENTER)*Vb;
    c = Oc+(j-VCENTER)*Vc;


    a+= (ScanLeft-HCENTER)*Ha;
    b+= (ScanLeft-HCENTER)*Hb;
    c+= (ScanLeft-HCENTER)*Hc;

    for (i=ScanLeft;i<ScanRight;i++)
     {
     u = OffX+THeight*a/c;  // Texture coordinates
     v = OffY+TWidth*b/c;

     Cu=((int)u)&XMask;	// Should allow wraparound textures
     Cv=((int)v)&YMask;

     ScreenPtr[i+j*320]=GFXPointer[Cu+Cv*TWidth];

     a+= Ha;	// Intermediate values
     b+= Hb;
     c+= Hc;
     }
    InsertSpan(ScanLeft,ScanRight,j); // fill in buffer
    AddPolyToSpan(ScanLeft,ScanRight,Polygon,j);
    }

   Pointer=Pointer->Pointer;
   }
  }
 }

void WallPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float Px,Py,Pz,Mx,My,Mz,Nx,Ny,Nz;
 float Oa,Ha,Va,Ob,Hb,Vb,Oc,Hc,Vc;
 float a,b,c;
 Fixed u,v,du,dv;
 int j,n,i;

 Px=Perspective*Polygon->TxtP->wx;	// In my coords 0 is the origin of the square
 Py=-Perspective*Polygon->TxtP->wy;	// Remember the Coords are being swapped here! (Z & Y)
 Pz=Polygon->TxtP->wz;

 Mx=(Perspective*Polygon->TxtM->wx-Px)*Polygon->TextureModX; // Create Vector M
 My=(-Perspective*Polygon->TxtM->wy-Py)*Polygon->TextureModX;
 Mz=(Polygon->TxtM->wz-Pz)*Polygon->TextureModX;

 Nx=(Perspective*Polygon->TxtN->wx-Px)*Polygon->TextureModY; // Create Vector N
 Ny=(-Perspective*Polygon->TxtN->wy-Py)*Polygon->TextureModY;
 Nz=(Polygon->TxtN->wz-Pz)*Polygon->TextureModY;

 Oa=Ny*Px-Nx*Py;	// Compute magic numbers
 Ha=Nz*Py-Ny*Pz;
 Va=Nx*Pz-Nz*Px;

 Ob=Mx*Py-My*Px;
 Hb=My*Pz-Mz*Py;
 Vb=Mz*Px-Mx*Pz;

 Oc=My*Nx-Mx*Ny;
 Hc=Mz*Ny-My*Nz;
 Vc=Mx*Nz-Mz*Nx;

 char *GFXPointer=GFXList[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

 XMin=WINRIGHT;		// set up optimal buffers
 XMax=WINLEFT;

 for(i=0;i<200;i++)	// Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 for(i=0;i<320;i++)	// Initialises Scanbuffer
  {
  ScanBufferTop[i]=WINBOTTOM;
  ScanBufferBottom[i]=WINTOP;
  }

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  VertConvEdgeWinG(Vertices[j].sx,Vertices[j].sy,Vertices[j].light,Vertices[n].sx,Vertices[n].sy,Vertices[n].light);
  ScanConvEdgeWin(Vertices[j].sx,Vertices[j].sy,Vertices[n].sx,Vertices[n].sy);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;
 if (XMin<WINLEFT)
  XMin=WINLEFT;
 if (XMax>WINRIGHT)
  XMax=WINRIGHT;

 int ScanLeft,ScanRight;
 ListNode *Pointer2=ScanLine[YMin].Root;

 for (i=YMin;i<YMax;i++)
  {
  Pointer2=ScanLine[i].Root;
  while (Pointer2!=NULL)
   {
   ScanLeft=ScanBufferLeft[i];
   ScanRight=ScanBufferRight[i];

   if (ScanLeft<Pointer2->Left) // is poly span left visible
    ScanLeft=Pointer2->Left;
   if (ScanRight>Pointer2->Right)
    ScanRight=Pointer2->Right;
   if (ScanLeft<ScanRight)
    {
    InsertSpan(ScanLeft,ScanRight,i); // fill in buffer
    AddPolyToSpan(ScanLeft,ScanRight,Polygon,i);
    }
   Pointer2=Pointer2->Pointer;
   }
  }

 Fixed ml,l;
 int Cu,Cv;
 int THeight=Polygon->Texture->Height;
 int TWidth=Polygon->Texture->Width;
 int XMask=Polygon->Texture->Width-1;
 int YMask=(Polygon->Texture->Height-1)*TWidth;
 int OffX=Polygon->TextOffX;
 int OffY=Polygon->TextOffY;
 int light=Polygon->Colour;

 char *TempScreen,*TempGFX;

 for (j=XMin;j<=XMax;j++)	// set to XMin+1 for now as avoids an error!
  {
// The following tests are to determine if a drawing span is visible

  ListNode *Pointer=VertLine[j].Root;

  int VertTop,VertBottom;

  while (Pointer!=NULL)
   {
   VertTop=ScanBufferTop[j];
   VertBottom=ScanBufferBottom[j];

   if (VertTop<Pointer->Left) // is poly span left visible
    VertTop=Pointer->Left;
   if (VertBottom>Pointer->Right)
    VertBottom=Pointer->Right;

   // Only draws if the span is valid e.g. Left - Right

   if (VertTop<VertBottom)
    {
    a = Oa+(j-HCENTER)*Ha;	// Intermediate values
    b = Ob+(j-HCENTER)*Hb;
    c = Oc+(j-HCENTER)*Hc;

//    UpdateScreen();

    a+= (VertTop-VCENTER)*Va;
    b+= (VertTop-VCENTER)*Vb;
    c+= (VertTop-VCENTER)*Vc;

    u = Float2Fixed(OffX+THeight*a/c);  // Texture coordinates
    v = Float2Fixed(OffY+TWidth*b/c)*TWidth;

    du=Float2Fixed(THeight*Va/c);	// LOOOK NO INNER DIVIDES COS FLOOR IS CONST Z in X
    dv=Float2Fixed(TWidth*Vb/c)*TWidth;

    TempScreen=ScreenPtr+j+VertTop*320;

    // Set lighting levels for current vert!

    if( (VertBottom-VertTop)!=0)
     ml=(Int2Fixed(LightBufferRight[j]-LightBufferLeft[j]))/(VertBottom-VertTop);
    else
     ml=Int2Fixed(LightBufferRight[j]-LightBufferLeft[j]);

    l=Int2Fixed(LightBufferLeft[j]);

    Cv=(Fixed2Int(v))&YMask;	// Should allow wraparound textures
    TempGFX=GFXPointer+Cv;

    for (i=VertTop;i<VertBottom;i++)
     {
     Cu=(Fixed2Int(u))&XMask;	// Should allow wraparound textures
//     Cv=((int)v)&YMask;

     *TempScreen=TempGFX[Cu]+(l>>16);

     TempScreen+=320;

     u+=du;
     l+=ml;
//     v+=dv;
     }
    InsertVert(VertTop,VertBottom,j); // fill in buffer
    }

   Pointer=Pointer->Pointer;
   }
  }
 }

void FloorPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float Px,Py,Pz,Mx,My,Mz,Nx,Ny,Nz;
 float Oa,Ha,Va,Ob,Hb,Vb,Oc,Hc,Vc;
 float a,b,c;
 Fixed u,v,du,dv;
 int j,n,i;

 Px=Perspective*Polygon->TxtP->wx;	// In my coords 0 is the origin of the square
 Py=-Perspective*Polygon->TxtP->wy;	// Remember the Coords are being swapped here! (Z & Y)
 Pz=Polygon->TxtP->wz;

 Mx=(Perspective*Polygon->TxtM->wx-Px)*Polygon->TextureModX; // Create Vector M
 My=(-Perspective*Polygon->TxtM->wy-Py)*Polygon->TextureModX;
 Mz=(Polygon->TxtM->wz-Pz)*Polygon->TextureModX;

 Nx=(Perspective*Polygon->TxtN->wx-Px)*Polygon->TextureModY; // Create Vector N
 Ny=(-Perspective*Polygon->TxtN->wy-Py)*Polygon->TextureModY;
 Nz=(Polygon->TxtN->wz-Pz)*Polygon->TextureModY;

 Oa=Ny*Px-Nx*Py;	// Compute magic numbers
 Ha=Nz*Py-Ny*Pz;
 Va=Nx*Pz-Nz*Px;

 Ob=Mx*Py-My*Px;
 Hb=My*Pz-Mz*Py;
 Vb=Mz*Px-Mx*Pz;

 Oc=My*Nx-Mx*Ny;
 Hc=Mz*Ny-My*Nz;
 Vc=Mx*Nz-Mz*Nx;

 char *GFXPointer=GFXList[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

 for(i=0;i<200;i++)	// Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWinG(Vertices[j].sx,Vertices[j].sy,Vertices[j].light,Vertices[n].sx,Vertices[n].sy,Vertices[n].light);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 Fixed ml,l;
 int Cu,Cv;
 int THeight=Polygon->Texture->Height;
 int TWidth=Polygon->Texture->Width;
 int XMask=Polygon->Texture->Width-1;
 int YMask=(Polygon->Texture->Height-1)*TWidth;
 int OffX=Polygon->TextOffX;
 int OffY=Polygon->TextOffY;
 int light=Polygon->Colour;

 char *TempScreen;

 for (j=YMin;j<=YMax;j++)	// set to YMin+1 for now as avoids an error!
  {
// The following tests are to determine if a drawing span is visible

  ListNode *Pointer=ScanLine[j].Root;

  int ScanLeft,ScanRight;

  while (Pointer!=NULL)
   {
   ScanLeft=ScanBufferLeft[j];
   ScanRight=ScanBufferRight[j];

   if (ScanLeft<Pointer->Left) // is poly span left visible
    ScanLeft=Pointer->Left;
   if (ScanRight>Pointer->Right)
    ScanRight=Pointer->Right;

   // Only draws if the span is valid e.g. Left - Right

   if (ScanLeft<ScanRight)
    {
    a = Oa+(j-VCENTER)*Va;	// Intermediate values
    b = Ob+(j-VCENTER)*Vb;
    c = Oc+(j-VCENTER)*Vc;

    a+= (ScanLeft-HCENTER)*Ha;
    b+= (ScanLeft-HCENTER)*Hb;
    c+= (ScanLeft-HCENTER)*Hc;

    u = Float2Fixed(OffX+THeight*a/c);  // Texture coordinates
    v = Float2Fixed(OffY+TWidth*b/c)*TWidth;

    du=Float2Fixed(THeight*Ha/c);	// LOOOK NO INNER DIVIDES COS FLOOR IS CONST Z in X
    dv=Float2Fixed(TWidth*Hb/c)*TWidth;

    TempScreen=ScreenPtr+ScanLeft+j*320;

    // Set lighting levels for current span!

    if( (ScanRight-ScanLeft)!=0)
     ml=(Int2Fixed(LightBufferRight[j]-LightBufferLeft[j]))/(ScanRight-ScanLeft);
    else
     ml=Int2Fixed(LightBufferRight[j]-LightBufferLeft[j]);

    l=Int2Fixed(LightBufferLeft[j]);

    for (i=ScanLeft;i<ScanRight;i++)
     {
     Cu=(Fixed2Int(u))&XMask;	// Should allow wraparound textures
     Cv=(Fixed2Int(v))&YMask;

     *TempScreen++=GFXPointer[Cu+Cv]+(l>>16);

     u+=du;
     v+=dv;
     l+=ml;
     }
    InsertSpan(ScanLeft,ScanRight,j); // fill in buffer
    AddPolyToSpan(ScanLeft,ScanRight,Polygon,j);
    }

   Pointer=Pointer->Pointer;
   }
  }
 }

//NB The following function is going to be altered drastically, I am
//  attempting to use linear or possibly quadratic texture mapping.
//
//
//  linear    => u(x) = r+s*x	      - a straight line
//  quadratic => u(x) = r+s*x+t*x^2   - a curved line (better)
//
//
//   To use linear the following is done
//
//  Do this per row (j) - thus only unknown is i
//
// compute u(i=0) = OffX+THeight*(Oa+(j-VCENTER)*Va+(i-HCENTER)*Ha)/
//                               (Oc+(j-VCENTER)*Vc+(i-HCENTER)*Hc)
// compute u(i=end-start) = OffX+THeight*(Oa+(j-VCENTER)*Va+(i-HCENTER)*Ha)/
//                                       (Oc+(j-VCENTER)*Vc+(i-HCENTER)*Hc)
//
// u1=u(i=0)  u2=u(i=end-start)
//
// linear function is equal to  u(x)=r+s*x
//
// Therefor r=u1 s=(u2-u1)/(end-start)
//
//
//  this is then also done for v(x)!
//
// This routine is slow as fuck... why???????????????????????
//
//
//  To correct the visible curvature of textures.. and I mean VISIBLE!, I am
// going to split up a horizontal run of pixels into blocks of X pixels,
// the more pixels the lower the texture mapping accuracy!

void TextureQPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float Px,Py,Pz,Mx,My,Mz,Nx,Ny,Nz;
 float Oa,Ha,Va,Ob,Hb,Vb,Oc,Hc,Vc;
 float a,b,c;
 float u,v;
 int j,n,i;

 Px=Perspective*Polygon->TxtP->wx;	// In my coords 0 is the origin of the square
 Py=-Perspective*Polygon->TxtP->wy;	// Remember the Coords are being swapped here! (Z & Y)
 Pz=Polygon->TxtP->wz;

 Mx=(Perspective*Polygon->TxtM->wx-Px)*Polygon->TextureModX; // Create Vector M
 My=(-Perspective*Polygon->TxtM->wy-Py)*Polygon->TextureModX;
 Mz=(Polygon->TxtM->wz-Pz)*Polygon->TextureModX;

 Nx=(Perspective*Polygon->TxtN->wx-Px)*Polygon->TextureModY; // Create Vector N
 Ny=(-Perspective*Polygon->TxtN->wy-Py)*Polygon->TextureModY;
 Nz=(Polygon->TxtN->wz-Pz)*Polygon->TextureModY;

 Oa=Ny*Px-Nx*Py;	// Compute magic numbers
 Ha=Nz*Py-Ny*Pz;
 Va=Nx*Pz-Nz*Px;

 Ob=Mx*Py-My*Px;
 Hb=My*Pz-Mz*Py;
 Vb=Mz*Px-Mx*Pz;

 Oc=My*Nx-Mx*Ny;
 Hc=Mz*Ny-My*Nz;
 Vc=Mx*Nz-Mz*Nx;

 char *GFXPointer=GFXList[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

 for(i=0;i<200;i++)	// Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWin(Vertices[j].sx,Vertices[j].sy,Vertices[n].sx,Vertices[n].sy);
  j=n;
  }

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

 for (j=YMin;j<=YMax;j++)	// set to YMin+1 for now as avoids an error!
  {
// The following tests are to determine if a drawing span is visible

  ListNode *Pointer=ScanLine[j].Root;

  int ScanLeft,ScanRight;

  while (Pointer!=NULL)
   {
   ScanLeft=ScanBufferLeft[j];
   ScanRight=ScanBufferRight[j];

   if (ScanLeft<Pointer->Left) // is poly span left visible
    ScanLeft=Pointer->Left;
   if (ScanRight>Pointer->Right)
    ScanRight=Pointer->Right;

   // Only draws if the span is valid e.g. Left - Right

   if (ScanLeft<ScanRight)
    {
    float u1,u2,u3,v1,v2,v3,u4,v4,u5,v5,ru,rv,su,sv,len,ku,kv,tu,tv;
    float RU,RV,SU,SV,TU,TV;
    int Length;

    unsigned char *ScreenTemp=&ScreenPtr[ScanLeft+j*320]; // set up screen pos

    Length=ScanRight-ScanLeft;

    int Whole=Length/ACCURACY;
    int Remain=Length%ACCURACY;

    a = Oa+(j-VCENTER)*Va+(ScanLeft-HCENTER)*Ha;	// Intermediate values
    b = Ob+(j-VCENTER)*Vb+(ScanLeft-HCENTER)*Hb;
    c = Oc+(j-VCENTER)*Vc+(ScanLeft-HCENTER)*Hc;

    u1=OffX+THeight*(a/c);	// compute u(0)
    v1=OffY+TWidth*(b/c);	// compute v(0)

    u=u1;
    v=v1;

    for (int t1=0;t1<Whole;t1++)
     {
     a = Oa+(j-VCENTER)*Va+((ScanLeft+ACCURACY+ACCURACY*t1)-HCENTER)*Ha;	// Intermediate values
     b = Ob+(j-VCENTER)*Vb+((ScanLeft+ACCURACY+ACCURACY*t1)-HCENTER)*Hb;
     c = Oc+(j-VCENTER)*Vc+((ScanLeft+ACCURACY+ACCURACY*t1)-HCENTER)*Hc;

     u2=OffX+THeight*(a/c);	// compute u(1)
     v2=OffY+TWidth*(b/c);	// compute v(1)

     su=(u2-u1)/ACCURACY;
     sv=(v2-v1)/ACCURACY;

     for (i=0;i<ACCURACY;i++)
      {
      Cu=((int)u)&XMask;	// Should allow wraparound textures
      Cv=((int)v)&YMask;

      *ScreenTemp++=GFXPointer[Cu+Cv*TWidth];

//      UpdateScreen();

      u+=su;
      v+=sv;
      }

     u1=u2;
     v1=v2;
     }

    if (Remain!=0)
     {
     a = Oa+(j-VCENTER)*Va+((ScanRight)-HCENTER)*Ha;	// Intermediate values
     b = Ob+(j-VCENTER)*Vb+((ScanRight)-HCENTER)*Hb;
     c = Oc+(j-VCENTER)*Vc+((ScanRight)-HCENTER)*Hc;

     u2=OffX+THeight*(a/c);	// compute u(1)
     v2=OffY+TWidth*(b/c);	// compute v(1)

     su=(u2-u1)/Remain;
     sv=(v2-v1)/Remain;
     }

//    u=u1;
//    v=v1;

    for (i=0;i<Remain;i++)
     {
     Cu=((int)u)&XMask;	// Should allow wraparound textures
     Cv=((int)v)&YMask;

     *ScreenTemp++=GFXPointer[Cu+Cv*TWidth];

//     UpdateScreen();

     u+=su;
     v+=sv;
     }


    InsertSpan(ScanLeft,ScanRight,j); // fill in buffer
    AddPolyToSpan(ScanLeft,ScanRight,Polygon,j);
    }

   Pointer=Pointer->Pointer;
   }
  }
 }

