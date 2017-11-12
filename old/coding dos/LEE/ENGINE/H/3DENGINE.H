/*

 3D Engine Include File

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <mem.h>        // defines NULL

#include "\coding\include\other\tree.h"
//#include "\coding\include\vesa\vesa.h"
#include "\coding\include\video\video.h"
#include "\coding\include\other\mouse.h"
#include "\coding\include\other\fixed32.h"
#include "\coding\include\other\pcx.h"
#include "\coding\lee\engine\h\3dstruct.h"
#include "\coding\lee\engine\h\spanlist.h"

// MACROS USED IN ENGINE

#define M_PI      (3.1415278)
#define ACCSHIFT  (4)  // shift constant to speed up calculations!
#define ACCURACY  (1<<ACCSHIFT) // num pixels drawn before perspective adjust
#define ACCMASK   (ACCURACY-1)

// TEXTURE FILE INCLUDES

extern unsigned char LightTables[32][256];

extern short ScanBufferLeft[800],ScanBufferRight[800];
extern short YMin,YMax;
extern char LightBufferLeft[800],LightBufferRight[800];
extern Fixed ULeft[800],URight[800];
extern Fixed VLeft[800],VRight[800];

short FindClosestRGB(short Red,short Green,short Blue,unsigned char *Palette);
void BuildLightTables();
void ASMScanConvEdgeWin(Fixed x1,Fixed y1,Fixed x2,Fixed y2);
void ASMScanConvEdgeWinG(Fixed x1,Fixed y1,Fixed light1,Fixed x2,Fixed y2,Fixed light2);
void ScanConvEdgeWin2d(Fixed x1,Fixed y1,Fixed tx1,Fixed ty1,Fixed x2,Fixed y2,Fixed tx2,Fixed ty2);
void TexturePlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void TexturePlot2(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void FloorPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void TextureQPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void TextureFacePlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void GouraudPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void PolygonPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);
void AffinePlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon);

// PARSE FILE INCLUDES

extern PCXHeader HeaderInfo;

ParseBlock *Parse(char *FileName);

// MATH FILE INCLUDES

extern float Perspective;  
extern float InvPerspective;

extern Fixed Sin[512],Cos[512];

void MakeTables();
void CalculatePerspective(VertexTYPE *Vertex,int NumVerts);
void CalculateNormals(ObjectTYPE *Object);
void Transform(CameraTYPE *Camera,ObjectTYPE *Object);

// DISPLAY FILE INCLUDES

extern int SCRNWIDTH;
extern int HCENTER;
extern int VCENTER;
extern int WINLEFT;
extern int WINRIGHT;
extern int WINTOP;
extern int WINBOTTOM;

extern List ScanLine[800];
extern List SpanList[800];

void ZClip(VertexTYPE *Vertex1,VertexTYPE *Vertex2);
int PolyClipZ(PolygonTYPE *Polygon,VertexTYPE VertStore[]);
void DisplaySector(ObjectTYPE *Object);
void ShowTree(TreeNode *Node);
void InsertSpan(Fixed Left,Fixed Right,short Line);
void AddPolyToSpan(Fixed Left,Fixed Right,PolygonTYPE *Polygon,short Line);

// WORLD FILE INCLUDES

extern ParseBlock *Map;
extern float GRAVITY;

void AnimateTextures();
PolygonTYPE *WhichPolygon(int X,int Y);
ObjectTYPE* WhichSector(float X,float Y,float Z);
void UpdatePlayer(float Dx,float Dy,float Dz);
