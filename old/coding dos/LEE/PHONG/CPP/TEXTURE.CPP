/*

 Texture Routines & Scan Conversion (Seperated for faster compile!)

   This version is a quick hack... pulled all texture stuff and any
  references to spans.. basicly this is a polygon drawer

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <mem.h>

#include "..\XavStuff\h\tree.h"
#include "h\3dstruct.h"
#include "h\defines.h"
#include "..\XavStuff\h\video.h"
#include "..\XavStuff\h\fixed32.h"

extern ParseBlock *Map;
extern unsigned char *VirtualScreen;
extern float Perspective;

short ScanBufferLeft[200],ScanBufferRight[200];   // For converting polygons!
short YMin,YMax;

void ScanConvEdgeWin(Fixed x1,Fixed y1,Fixed x2,Fixed y2)   // To convert standard poly
 {
 Fixed mx;   // slope of x
 Fixed temp; // for swapping
 Fixed x,y;  // source x and y screen coordinates

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
  mx = (Int2Fixed(x2-x1)) / (y2-y1); // dx/dy
 else
  mx = (Int2Fixed(x2-x1)); // dx

 x=Int2Fixed(x1);
 for(y=y1;y<=y2;y++)
  {
  if (y>=WINTOP && y<=WINBOTTOM)
   {
   if (Fixed2Int(x)<ScanBufferLeft[y])
     ScanBufferLeft[y]=(Fixed2Int(x));
   if (Fixed2Int(x)>ScanBufferRight[y])
     ScanBufferRight[y]=(Fixed2Int(x));
   }
  x+=mx;
  }
 }

void PolygonPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
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

 j=NumSides-1;        // set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWin(Vertices[j].sx,Vertices[j].sy,Vertices[n].sx,Vertices[n].sy);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 if (YMin!=YMax)
  for (Y=YMin;Y<=YMax;Y++)
   {
   ScanLeft=ScanBufferLeft[Y];
   ScanRight=ScanBufferRight[Y];

   if (ScanLeft<WINLEFT) // is poly span left visible
    ScanLeft=WINLEFT;
   if (ScanRight>WINRIGHT)
    ScanRight=WINRIGHT;
   if (ScanLeft<ScanRight)
    {
    TempScreen=VirtualScreen+ScanLeft+Y*320;

    for (a=ScanLeft;a<ScanRight;a++)
     {
     *TempScreen++=Polygon->Colour;
     }
    }
   }
 }
