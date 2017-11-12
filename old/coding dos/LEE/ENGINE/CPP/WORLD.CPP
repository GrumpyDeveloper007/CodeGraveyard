/*

 3D World Upkeep (Seperated for faster compile!)

   This file contains functions used in the upkeep of the world such as
  animating the textures and also functions that can return information
  about the current world.

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include "h\3dengine.h"

ParseBlock *Map;        // Map pointer for 3d world
float GRAVITY=1;

// The following represents the size of the player as a bounding box (CUBE!)
VertexTYPE BoundBox[8]={
                       {-2,-2,-2},
                       {2,-2,-2},
                       {-2,2,-2},
                       {2,2,-2},
                       {-2,-2,4},
                       {2,-2,4},
                       {-2,2,4},
                       {2,2,4},
                       };
VertexTYPE PointToFind; // coordinates of point to be found in MAP COORDS
                        // This is global to cut down on stack usage

void AnimateTextures()
 {
 for (int a=0;a<Map->MaxTexture;a++)
  {
  Map->Texture[a].CurrentFrame++;
  if (Map->Texture[a].CurrentFrame>=Map->Texture[a].FrameMask)
   Map->Texture[a].CurrentFrame=0;
  }
 }

// The following returns which polygon is under screen pos x,y or NULL

PolygonTYPE *WhichPolygon(int X,int Y)
 {
 ListNode *Pointer=SpanList[Y].Root;

 while (Pointer!=NULL)
  {
  if (X>=Pointer->Left && X<=Pointer->Right)
   return (PolygonTYPE *)Pointer->Polygon;
  Pointer=Pointer->Pointer;
  }
 return NULL;
 }

//  This function should be used on a balanced tree since it only scans
// to the first leaf.

ObjectTYPE *FindSector(TreeNode *Node)   // Find which sector a point is in
 {
 NodeData *Element;

 if(Node==NULL)
  return NULL;       // edge of tree no sector found

 Element=(NodeData *)Node->Element;
 if(Element->Type==1)	// convex object found
  return Element->Ptr;
 else
  {
  if (((Element->PlaneX-Map->Camera[0].Ox)*Element->Nx+
       (Element->PlaneY-Map->Camera[0].Oy)*Element->Ny+
       (Element->PlaneZ-Map->Camera[0].Oz)*Element->Nz) <0)
   return FindSector(Node->Left);       // go left then right
  else
   return FindSector(Node->Right);      // go right then left
  }
 return NULL;   // if this occurs error in BSP definition!
 }

// The following returns which sector a point is in

ObjectTYPE* WhichSector(float X,float Y,float Z)
 {
 PointToFind.ox=X;
 PointToFind.oy=Y;
 PointToFind.oz=Z;

 return FindSector(Map->BSPTree->Root);
 }

void UpdatePlayer(float Dx,float Dy,float Dz) // Updates player position if possible
 {
 PolygonTYPE *PolygonPointer;
 ObjectTYPE *CurrentSector;
 float Ox,Oy,Oz,Nx,Ny,Nz,Px,Py,Pz;

// Make Dx,Dy,Dz Relative to player (Since movement is based on map coords!)

 Dx+=Map->Camera[0].Ox;
 Dy+=Map->Camera[0].Oy;
 Dz+=Map->Camera[0].Oz;
/*
 for (int c=0;c<8;c++)
  {
  // First locate which sector the bounding box is in.

  CurrentSector=WhichSector(Dx+BoundBox[c].ox,Dy+BoundBox[c].oy,Dz+BoundBox[c].oz);

  if (CurrentSector==NULL)
   return;      // if this occurs bounding box outside map

  PolygonPointer=CurrentSector->PolygonList;

// Distance of point from plane is (p-a).n where n is unit normal,
//   p is point on plane and a is point we are interested in.

  for (int a=0;a<CurrentSector->NumOfPolygons;a++)
   {
   Ox=PolygonPointer->Vertex[0]->ox;    // This saves a little indexing
   Oy=PolygonPointer->Vertex[0]->oy;
   Oz=PolygonPointer->Vertex[0]->oz;
   Nx=PolygonPointer->Nx;
   Ny=PolygonPointer->Ny;
   Nz=PolygonPointer++->Nz;
   for (int b=0;b<8;b++) // Bounding box for player
    {
// (p-a)=P

    Px=Ox-(Dx+BoundBox[b].ox);
    Py=Oy-(Dy+BoundBox[b].oy);
    Pz=Oz-(Dz+BoundBox[b].oz);

// if (P.n > 0) point on side of normal

    if ((Px*Nx+Py*Ny+Pz*Nz) <=0)
     return;       // collision
    }
   }
  }*/
 Map->Camera[0].Ox=Dx;
 Map->Camera[0].Oy=Dy;
 Map->Camera[0].Oz=Dz;
 }
