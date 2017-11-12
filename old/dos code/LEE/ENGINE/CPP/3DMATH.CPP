/*

 Math Routines (Seperated for faster compile!)

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <math.h>
#include "h\3dEngine.h"

float Perspective=WINBOTTOM-WINTOP;  
float InvPerspective=-Perspective;

Fixed Sin[512],Cos[512];        // sin & cos based on degrees not rads!

void MakeTables()	// Creates the Sin & Cos tables
 {
 for (int Loop=0;Loop<512;Loop++)
  {
  Sin[Loop]=Float2Fixed(sin((((Loop/512.0)*360.0)*M_PI)/180));   // computes angle 0-511
  Cos[Loop]=Float2Fixed(cos((((Loop/512.0)*360.0)*M_PI)/180));
  }
 }

void CalculatePerspective(VertexTYPE *Vertex,int NumVerts)
 {
 float ZStore;

 for (int n=0;n<NumVerts;n++)     // Perspectivate the coords
  {
  ZStore=Perspective/Vertex->wz;
  Vertex->sx=Vertex->wx*ZStore+HCENTER;
  Vertex->sy=Vertex->wy*(-ZStore)+VCENTER;
  Vertex++;
  }
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

void Transform(CameraTYPE *Camera,ObjectTYPE *Object) // Takes a pointer to the object
 {
 float SS,CS,XX,XY,XZ,YX,YY,YZ,ZX,ZY,ZZ;
 float SA1,SA2,SA3,CA1,CA2,CA3;
 float SS2,CS2,XX2,XY2,XZ2,YX2,YY2,YZ2,ZX2,ZY2,ZZ2;
 float SA12,SA22,SA32,CA12,CA22,CA32;
 int A1,A2,A3,count;
 float Ox,Oy,Oz;
 VertexTYPE *VertexPointer;

 if (Object->ObjectType!=OBJECT_SECTOR) // prepare own rotate matrix
  {     // This rotates a sprite type object about its origin (not world!)
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

 A3=Camera->Az;     // Get rotate Z angle (e.g. 3 degrees)
 A2=Camera->Ay;     // Get rotate Y angle
 A1=Camera->Ax;     // Get rotate X angle

 SA3=Fixed2Float(Sin[A3]);      // indexing on arrays... <NOT A LOT THO!>
 CA3=Fixed2Float(Cos[A3]);
 SA2=Fixed2Float(Sin[A2]);      // indexing on arrays... <NOT A LOT THO!>
 CA2=Fixed2Float(Cos[A2]);
 SA1=Fixed2Float(Sin[A1]);      // indexing on arrays... <NOT A LOT THO!>
 CA1=Fixed2Float(Cos[A1]);

 float Xwx1,Xwy1,Xwz1,Ywx1,Ywy1,Ywz1,Zwx1,Zwy1,Zwz1;
 float Xwx2,Xwy2,Xwz2,Ywx2,Ywy2,Ywz2,Zwx2,Zwy2,Zwz2;

 Xwx1=SA2*Camera->Xz+CA2*Camera->Xx;    // About Y (up/down)
 Xwy1=Camera->Xy;
 Xwz1=CA2*Camera->Xz-SA2*Camera->Xx;
 Camera->Xwx=CA3*Xwx1-SA3*Xwy1;         // About Z (left/right)
 Camera->Xwy=SA3*Xwx1+CA3*Xwy1;
 Camera->Xwz=Xwz1;
// Xwx2=CA3*Xwx1-SA3*Xwy1;                // About Z (left/right)
// Xwy2=SA3*Xwx1+CA3*Xwy1;
// Xwz2=Xwz1;
// Camera->Xwx=Xwx2;                      // About X(bank head) (wrong order!)
// Camera->Xwy=CA1*Xwy2-SA1*Xwz2;
// Camera->Xwz=SA1*Xwy2+CA1*Xwz2;
 Ywx1=SA2*Camera->Yz+CA2*Camera->Yx;
 Ywy1=Camera->Yy;
 Ywz1=CA2*Camera->Yz-SA2*Camera->Yx;
 Camera->Ywx=CA3*Ywx1-SA3*Ywy1;
 Camera->Ywy=SA3*Ywx1+CA3*Ywy1;
 Camera->Ywz=Ywz1;
// Ywx2=CA3*Ywx1-SA3*Ywy1;
// Ywy2=SA3*Ywx1+CA3*Ywy1;
// Ywz2=Ywz1;
// Camera->Ywx=Ywx2;
// Camera->Ywy=CA1*Ywy2-SA1*Ywz2;
// Camera->Ywz=SA1*Ywy2+CA1*Ywz2;
 Zwx1=SA2*Camera->Zz+CA2*Camera->Zx;
 Zwy1=Camera->Zy;
 Zwz1=CA2*Camera->Zz-SA2*Camera->Zx;
 Camera->Zwx=CA3*Zwx1-SA3*Zwy1;
 Camera->Zwy=SA3*Zwx1+CA3*Zwy1;
 Camera->Zwz=Zwz1;
// Zwx2=CA3*Zwx1-SA3*Zwy1;
// Zwy2=SA3*Zwx1+CA3*Zwy1;
// Zwz2=Zwz1;
// Camera->Zwx=Zwx2;
// Camera->Zwy=CA1*Zwy2-SA1*Zwz2;
// Camera->Zwz=SA1*Zwy2+CA1*Zwz2;

 VertexPointer=Object->VertexList;	// Get pointer to make things faster

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

   VertexPointer->wx=Camera->Xwx*(Temp.wx+Ox-Camera->Ox)+Camera->Xwy*(Temp.wy+Oy-Camera->Oy)+Camera->Xwz*(Temp.wz+Oz-Camera->Oz);
   VertexPointer->wy=Camera->Ywx*(Temp.wx+Ox-Camera->Ox)+Camera->Ywy*(Temp.wy+Oy-Camera->Oy)+Camera->Ywz*(Temp.wz+Oz-Camera->Oz);
   VertexPointer->wz=Camera->Zwx*(Temp.wx+Ox-Camera->Ox)+Camera->Zwy*(Temp.wy+Oy-Camera->Oy)+Camera->Zwz*(Temp.wz+Oz-Camera->Oz);

   VertexPointer++;              // Goto next vertex
   }
  }
 else
  {
  for (count=0;count<Object->NumOfVertices;count++)
   {
   // Rotate points by using dot product!!!! ;-)
   // This looks awful but should work in theory!

   VertexPointer->wx=Camera->Xwx*(VertexPointer->ox+Ox-Camera->Ox)+Camera->Xwy*(VertexPointer->oy+Oy-Camera->Oy)+Camera->Xwz*(VertexPointer->oz+Oz-Camera->Oz);
   VertexPointer->wy=Camera->Ywx*(VertexPointer->ox+Ox-Camera->Ox)+Camera->Ywy*(VertexPointer->oy+Oy-Camera->Oy)+Camera->Ywz*(VertexPointer->oz+Oz-Camera->Oz);
   VertexPointer->wz=Camera->Zwx*(VertexPointer->ox+Ox-Camera->Ox)+Camera->Zwy*(VertexPointer->oy+Oy-Camera->Oy)+Camera->Zwz*(VertexPointer->oz+Oz-Camera->Oz);

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

   PolygonPointer->Nwx=Camera->Xwx*Temp.wx+Camera->Xwy*Temp.wy+Camera->Xwz*Temp.wz;
   PolygonPointer->Nwy=Camera->Ywx*Temp.wx+Camera->Ywy*Temp.wy+Camera->Ywz*Temp.wz;
   PolygonPointer->Nwz=Camera->Zwx*Temp.wx+Camera->Zwy*Temp.wy+Camera->Zwz*Temp.wz;

   PolygonPointer++;
   }
  }
 else
  {
  for (count=0;count<Object->NumOfPolygons;count++) // rotate poly normals
   {
   PolygonPointer->Nwx=Camera->Xwx*PolygonPointer->Nx+Camera->Xwy*PolygonPointer->Ny+Camera->Xwz*PolygonPointer->Nz;
   PolygonPointer->Nwy=Camera->Ywx*PolygonPointer->Nx+Camera->Ywy*PolygonPointer->Ny+Camera->Ywz*PolygonPointer->Nz;
   PolygonPointer->Nwz=Camera->Zwx*PolygonPointer->Nx+Camera->Zwy*PolygonPointer->Ny+Camera->Zwz*PolygonPointer->Nz;
 
   PolygonPointer++;
   }
  }
 }

