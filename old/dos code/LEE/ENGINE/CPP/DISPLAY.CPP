/*

 Display Routines (Seperated for faster compile!)

   This is basicly all stuff needed to draw a level from a 3d map without
  the texture processing and scan converters which are in a seperate file.

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include "h\3dEngine.h"

int SCRNWIDTH=320;
int HCENTER=160;        // Defines Center of display
int VCENTER=100;
int WINLEFT=0;//80;
int WINRIGHT=319;//240;
int WINTOP=0;//40; 
int WINBOTTOM=199;//160;

List ScanLine[800];   // This is used to determine free screen positions
List SpanList[800];   // This is used to state which poly is where on screen

void (*DrawTable[])(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)=
               {TexturePlot2,   // Note these must be in the same order
               TexturePlot2,    // and position as their respective defines!
               TexturePlot2,
               TexturePlot2,    // This used to be Wall Plot before removed!
               TexturePlot2,
               TexturePlot2,
               TexturePlot2,       // Front pixels
               TexturePlot2,       // Rear pixels
               TexturePlot2,
               };

//void (*DrawTable[])(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)=
//               {PolygonPlot,   // Note these must be in the same order
//               GouraudPlot,    // and position as their respective defines!
//               TexturePlot,
//               TexturePlot,    // This used to be Wall Plot before removed!
//               FloorPlot,
//               TextureQPlot,
//               TextureFacePlot,       // Front pixels
//               TextureFacePlot,       // Rear pixels
//               AffinePlot,
//               };

void InsertSpan(Fixed Left,Fixed Right,short Line)
 {
 ListNode *Pointer=ScanLine[Line].Root;
 ListNode *Temp;

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

void AddPolyToSpan(Fixed Left,Fixed Right,PolygonTYPE *Polygon,short Line)
 {
 ListNode *Pointer=SpanList[Line].Root;
 ListNode *Temp;

 Temp=Pointer->Pointer;
 SpanList[Line].Insert(Left,Right,Pointer,Polygon);
 Pointer=Pointer->Pointer;
 Pointer->Pointer=Temp;
 }

void ZClip(AffineTYPE *Aff1,AffineTYPE *Aff2,VertexTYPE *Vertex1,VertexTYPE *Vertex2)
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
 Aff1->TxtX=Aff1->TxtX+(Aff2->TxtX-Aff1->TxtX)*R;
 Aff1->TxtY=Aff1->TxtY+(Aff2->TxtY-Aff1->TxtY)*R;
 }

int PolyClipZ(PolygonTYPE *Polygon,VertexTYPE VertStore[])
 {
 VertexTYPE *Last,*Next;
 AffineTYPE *ALast,*ANext;

 int Count=0;	// count of polygons in output buffer

 Last = Polygon->Vertex[Polygon->NumVertices-1];
 ALast = Polygon->Affine[Polygon->NumVertices-1];
 for (int J=0;J<Polygon->NumVertices;J++)
  {
  Next = Polygon->Vertex[J];
  ANext = Polygon->Affine[J];
  if (Next->wz>=1) // If Next Point is visible
   {
   if (Last->wz>=1)	// If Last Point is visible
    {
    Map->AffineMap[Count].TxtX=ANext->TxtX;
    Map->AffineMap[Count].TxtY=ANext->TxtY;
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
    Map->AffineMap[Count].TxtX=ALast->TxtX;
    Map->AffineMap[Count].TxtY=ALast->TxtY;
    VertStore[Count].wx=Last->wx;
    VertStore[Count].wy=Last->wy;
    VertStore[Count].wz=Last->wz;
    VertStore[Count].light=Last->light;
    VertStore[Count].TextFX=Last->TextFX;
    VertStore[Count].TextFY=Last->TextFY;
    VertStore[Count].TextRX=Last->TextRX;
    VertStore[Count].TextRY=Last->TextRY;
    ZClip(&Map->AffineMap[Count],ANext,&VertStore[Count],Next);
    Map->AffineMap[Count].TxtX=5;//ALast->TxtX;
    Map->AffineMap[Count].TxtY=5;//ALast->TxtY;
    Count++;
    Map->AffineMap[Count].TxtX=ANext->TxtX;
    Map->AffineMap[Count].TxtY=ANext->TxtY;
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
    Map->AffineMap[Count].TxtX=ANext->TxtX;
    Map->AffineMap[Count].TxtY=ANext->TxtY;
    VertStore[Count].wx=Next->wx;
    VertStore[Count].wy=Next->wy;
    VertStore[Count].wz=Next->wz;
    VertStore[Count].light=Next->light;
    VertStore[Count].TextFX=Next->TextFX;
    VertStore[Count].TextFY=Next->TextFY;
    VertStore[Count].TextRX=Next->TextRX;
    VertStore[Count].TextRY=Next->TextRY;
    ZClip(&Map->AffineMap[Count],ALast,&VertStore[Count],Last);
    Map->AffineMap[Count].TxtX=5;//ALast->TxtX;
    Map->AffineMap[Count].TxtY=5;//ALast->TxtY;
    Count++;
    }
   }
  Last=Next;	// Next Point
  ALast=ANext;
  }
 return Count;
 }

void DisplaySector(ObjectTYPE *Object)
 {
 PolygonTYPE *PolygonPointer;
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
   CalculatePerspective(VertsTemp,Clipping);
   DrawTable[PolygonPointer->TypeOfPolygon](VertsTemp,Clipping,PolygonPointer);
//   TexturePlot2(VertsTemp,Clipping,PolygonPointer);

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
  if (Element->PlaneX!=0)
   DisplaySector(&Map->Dyna_Object[(int)Element->PlaneX-1]);// display sprite basicly (HACK VERSION)
  DisplaySector(Element->Ptr);
  return;
  }
 else
  {
  if (((Element->PlaneX-Map->Camera[0].Ox)*Element->Nx+
       (Element->PlaneY-Map->Camera[0].Oy)*Element->Ny+
       (Element->PlaneZ-Map->Camera[0].Oz)*Element->Nz) <0)
   {
   ShowTree(Node->Left);       // go left then right
   ShowTree(Node->Right);
   }
  else
   {
   ShowTree(Node->Right);      // go right then left
   ShowTree(Node->Left);
   }
  return;
  }
 }
