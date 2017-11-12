/*

  3DO File Parser (Parses a 3D Object file FILENAME.3DO)

  o - 3DO file is a simple text file which takes on a structure as follows...

      CLASS type     - type of class e.g. VERTEX,POLYGON,SPRITE etc.
       data...       - Data specific to this class
       data...

  o - The data will be 100 % compatable with the 3DO creation facility
     currently under design. This will include the facility to export BSP
     trees and predescriptive items such as lights which will have no use
     within the engine since they are acted upon at map creation time.

  o - For a complete list of all classes supported please see 3DOCLASS.DOC.

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <fstream.h>
#include <string.h>
#include <process.h>

#include "..\XavStuff\h\tree.h"
#include "..\XavStuff\h\pcx.h"
#include "h\3dstruct.h"

PCXHeader HeaderInfo;

ParseBlock Parsed={NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,{0},0,0,0,0,0,0,0,0,0,0};

void FUNC_DEFINE(fstream &File);
void FUNC_CLASS(fstream &File);
void FUNC_CLASS_TREENODE(fstream &File);
void FUNC_CLASS_TREE(fstream &File);
void FUNC_CLASS_VERTEX(fstream &File);
void FUNC_CLASS_VERTEX_LIGHT(fstream &File);
void FUNC_CLASS_VERTEX_2DMAP(fstream &File);
void FUNC_CLASS_POLYGON(fstream &File);
void FUNC_CLASS_POLYGON_SHADE(fstream &File);
void FUNC_CLASS_POLYGON_TEXTURE(fstream &File);
void FUNC_CLASS_POLYGON_FLOOR(fstream &File);
void FUNC_CLASS_POLYGON_QTEXT(fstream &File);
void FUNC_CLASS_POLYGON_FRONT(fstream &File);
void FUNC_CLASS_POLYGON_REAR(fstream &File);
void FUNC_CLASS_SECTOR(fstream &File);
void FUNC_CLASS_GRAPHIC(fstream &File);
void FUNC_CLASS_TEXTURE(fstream &File);
void FUNC_CLASS_PALETTE(fstream &File);
void FUNC_CLASS_CAMERA(fstream &File);
void FUNC_CLASS_DYNA_VERTEX(fstream &File);
void FUNC_CLASS_DYNA_VERTEX_LIGHT(fstream &File);
void FUNC_CLASS_DYNA_VERTEX_2DMAP(fstream &File);
void FUNC_CLASS_DYNA_POLYGON(fstream &File);
void FUNC_CLASS_DYNA_POLYGON_SHADE(fstream &File);
void FUNC_CLASS_DYNA_POLYGON_TEXTURE(fstream &File);
void FUNC_CLASS_DYNA_POLYGON_FLOOR(fstream &File);
void FUNC_CLASS_DYNA_POLYGON_QTEXT(fstream &File);
void FUNC_CLASS_DYNA_POLYGON_FRONT(fstream &File);
void FUNC_CLASS_DYNA_POLYGON_REAR(fstream &File);
void FUNC_CLASS_INCLUDE_STATIC(fstream &File);

struct
 {
 char Command[50];
 void (*Function)(fstream &File);
 } JUMP_TABLE[]={
               {"DEFINE",FUNC_DEFINE},
               {"CLASS",FUNC_CLASS},
               {"",NULL}};

struct
 {
 char Command[50];
 void (*Function)(fstream &File);
 } CLASS_TABLE[]={
               {"3DO_TREENODE",FUNC_CLASS_TREENODE},
               {"3DO_TREE",FUNC_CLASS_TREE},
               {"3DO_SECTOR",FUNC_CLASS_SECTOR},
               {"3DO_POLYGON",FUNC_CLASS_POLYGON},
               {"3DO_POLYGON_SHADE",FUNC_CLASS_POLYGON_SHADE},
               {"3DO_POLYGON_TEXTURE",FUNC_CLASS_POLYGON_TEXTURE},
               {"3DO_POLYGON_FLOOR",FUNC_CLASS_POLYGON_FLOOR},
               {"3DO_POLYGON_QTEXT",FUNC_CLASS_POLYGON_QTEXT},
               {"3DO_POLYGON_FRONT",FUNC_CLASS_POLYGON_FRONT},
               {"3DO_POLYGON_REAR",FUNC_CLASS_POLYGON_REAR},
               {"3DO_VERTEX",FUNC_CLASS_VERTEX},
               {"3DO_VERTEX_LIGHT",FUNC_CLASS_VERTEX_LIGHT},
               {"3DO_VERTEX_2DMAP",FUNC_CLASS_VERTEX_2DMAP},
               {"3DO_INCLUDE_STATIC",FUNC_CLASS_INCLUDE_STATIC},
               {"3DOD_POLYGON",FUNC_CLASS_DYNA_POLYGON},
               {"3DOD_POLYGON_SHADE",FUNC_CLASS_DYNA_POLYGON_SHADE},
               {"3DOD_POLYGON_TEXTURE",FUNC_CLASS_DYNA_POLYGON_TEXTURE},
               {"3DOD_POLYGON_FLOOR",FUNC_CLASS_DYNA_POLYGON_FLOOR},
               {"3DOD_POLYGON_QTEXT",FUNC_CLASS_DYNA_POLYGON_QTEXT},
               {"3DOD_POLYGON_FRONT",FUNC_CLASS_DYNA_POLYGON_FRONT},
               {"3DOD_POLYGON_REAR",FUNC_CLASS_DYNA_POLYGON_REAR},
               {"3DOD_VERTEX",FUNC_CLASS_DYNA_VERTEX},
               {"3DOD_VERTEX_LIGHT",FUNC_CLASS_DYNA_VERTEX_LIGHT},
               {"3DOD_VERTEX_2DMAP",FUNC_CLASS_DYNA_VERTEX_2DMAP},
               {"3DO_GRAPHIC",FUNC_CLASS_GRAPHIC},
               {"3DO_TEXTURE",FUNC_CLASS_TEXTURE},
               {"3DO_PALETTE",FUNC_CLASS_PALETTE},
               {"3DO_CAMERA",FUNC_CLASS_CAMERA},
               {"",NULL}};

struct
 {
 char Command[50];
 int *Variable;
 } VARS_TABLE[]={
               {"TREENODE",&Parsed.MaxTreeNode},
               {"OBJECT",&Parsed.MaxObject},
               {"POLYGON",&Parsed.MaxPolygon},
               {"VERTEX",&Parsed.MaxVertex},
               {"DYNA_OBJECT",&Parsed.MaxDynaObject},
               {"DYNA_POLYGON",&Parsed.MaxDynaPolygon},
               {"DYNA_VERTEX",&Parsed.MaxDynaVertex},
               {"GRAPHIC",&Parsed.MaxGraphic},
               {"TEXTURE",&Parsed.MaxTexture},
               {"CAMERA",&Parsed.MaxCamera},
               {"",NULL}};

int CurrentDynaObject=0;
int CurrentDynaPolygon=0;
int CurrentDynaVertex=0;

int OffsetDynaObject;
int OffsetDynaPolygon;
int OffsetDynaVertex;
int OffsetTexture;

int Command;

ParseBlock *Parse(char *FileName)
 {
 OffsetDynaObject=CurrentDynaObject;
 OffsetDynaPolygon=CurrentDynaPolygon;
 OffsetDynaVertex=CurrentDynaVertex;

 fstream File;

 char Read[50];
 int a=0;
 Command=0;

 cout << "\n\n3DO Parser Acting On " << FileName;

 File.open(FileName,ios::in);

 if (!File)
  {
  cout << "\n\nERROR 3DO File \"" << FileName << "\" Missing!";
  exit(-1);
  }

 File >> Read;

 while (File)
  {
  Command++;
  while (JUMP_TABLE[a].Function!=NULL)
   {
   if (stricmp(Read,JUMP_TABLE[a].Command)==0)
    {
    JUMP_TABLE[a].Function(File);
    a=0;
    break;
    }
   a++;
   }
  if (a!=0)
   {
   cout << "\n\nERROR Illegal Command \"" << Read << "\" On Command " << Command;
   exit(-1);
   }
  File >> Read;
  }

 Parsed.LastDynaObject=CurrentDynaObject;

 return &Parsed;
 }

void FUNC_DEFINE(fstream &File)
 {
 char Variable[50];
 int Value;

 File >> Variable >> Value;

 int a=0;
 while (VARS_TABLE[a].Variable!=NULL)
  {
  if (stricmp(Variable,VARS_TABLE[a].Command)==0)
   {
   *VARS_TABLE[a].Variable=Value;
   a=0;
   break;
   }
  a++;
  }
 if (a!=0)
  {
  cout << "\n\nERROR Illegal Define \"" << Variable << "\" On Command " << Command;
  exit(-1);
  }
 }

void FUNC_CLASS(fstream &File)
 {
 char Class[50];

 File >> Class;

 int a=0;
 while (CLASS_TABLE[a].Function!=NULL)
  {
  if (stricmp(Class,CLASS_TABLE[a].Command)==0)
   {
   CLASS_TABLE[a].Function(File);
   a=0;
   break;
   }
  a++;
  }
 if (a!=0)
  {
  cout << "\n\nERROR Illegal Class \"" << Class << "\" On Command " << Command;
  exit(-1);
  }
 }

void FUNC_CLASS_TREENODE(fstream &File)
 {
 int Num,Type,Object,Plane;
 float Position;

 if (Parsed.TreeNode==NULL)
  {
  Parsed.TreeNode=new NodeData [Parsed.MaxTreeNode];
  if (Parsed.TreeNode==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Object==NULL)
  {
  cout << "\n\nERROR No Objects Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> Type >> Object >> Plane >> Position;

 if (Num>=Parsed.MaxTreeNode)
  {
  cout << "\n\nERROR Max Tree Node Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.TreeNode[Num].Type=Type;
 Parsed.TreeNode[Num].Ptr=&Parsed.Object[Object];
 Parsed.TreeNode[Num].Plane=Plane;
 Parsed.TreeNode[Num].Position=Position;
 }

void BuildTree(TreeNode *Node,int Element,fstream &File)
 {
 Node->Element=&Parsed.TreeNode[Element]; // set current node to data

 File >> Element;

 if (Element==65535)    // end of current branch
  Node->Left=NULL;      // no left branch
 else
  {
  Parsed.BSPTree->InsertLeft(NULL,Node);
  BuildTree(Node->Left,Element,File);
  }

 File >> Element;

 if (Element==65535)    // end of current branch
  Node->Right=NULL;
 else
  {
  Parsed.BSPTree->InsertRight(NULL,Node);
  BuildTree(Node->Right,Element,File);
  }

 return;
 }

void FUNC_CLASS_TREE(fstream &File)
 {
 int NodeIndex;

 if (Parsed.BSPTree!=NULL)
  {
  cout << "\n\nERROR More Than One Tree Defined In 3DO File On Command " << Command;
  exit(-1);
  }

 Parsed.BSPTree=new Tree;

 File >> NodeIndex;

 BuildTree(Parsed.BSPTree->Root,NodeIndex,File);
 }

void FUNC_CLASS_SECTOR(fstream &File)
 {
 int Num,NumV,NumP,FirstV,FirstP;

 if (Parsed.Object==NULL)
  {
  Parsed.Object=new ObjectTYPE [Parsed.MaxObject];
  if (Parsed.Object==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Polygon==NULL)
  {
  cout << "\n\nERROR No Polygons Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Vertex==NULL)
  {
  cout << "\n\nERROR No Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> NumV >> NumP >> FirstV >> FirstP;

 if (Num>=Parsed.MaxObject)
  {
  cout << "\n\nERROR Max Object Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Object[Num].Ox=0;
 Parsed.Object[Num].Oy=0;
 Parsed.Object[Num].Oz=0;
 Parsed.Object[Num].ObjectType=OBJECT_SECTOR;
 Parsed.Object[Num].NumOfVertices=NumV;
 Parsed.Object[Num].NumOfPolygons=NumP;
 Parsed.Object[Num].VertexList=&Parsed.Vertex[FirstV];
 Parsed.Object[Num].PolygonList=&Parsed.Polygon[FirstP];
 }

void FUNC_CLASS_POLYGON(fstream &File)
 {
 int Num,NumS,Colour,Index;

 if (Parsed.Polygon==NULL)
  {
  Parsed.Polygon=new PolygonTYPE [Parsed.MaxPolygon];
  if (Parsed.Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Vertex==NULL)
  {
  cout << "\n\nERROR No Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> NumS;

 if (Num>=Parsed.MaxPolygon)
  {
  cout << "\n\nERROR Max Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Polygon[Num].NumVertices=NumS;
 Parsed.Polygon[Num].TypeOfPolygon=POLY_NORMAL;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Polygon[Num].Vertex[a]=&Parsed.Vertex[Index];
  }

 File >> Colour;

 Parsed.Polygon[Num].Colour=Colour;
 }

void FUNC_CLASS_POLYGON_SHADE(fstream &File)
 {
 int Num,NumS,Colour,Index;

 if (Parsed.Polygon==NULL)
  {
  Parsed.Polygon=new PolygonTYPE [Parsed.MaxPolygon];
  if (Parsed.Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Vertex==NULL)
  {
  cout << "\n\nERROR No Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> NumS;

 if (Num>=Parsed.MaxPolygon)
  {
  cout << "\n\nERROR Max Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Polygon[Num].NumVertices=NumS;
 Parsed.Polygon[Num].TypeOfPolygon=POLY_GSHADE;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Polygon[Num].Vertex[a]=&Parsed.Vertex[Index];
  }

 File >> Colour;

 Parsed.Polygon[Num].Colour=Colour;
 }

void FUNC_CLASS_POLYGON_TEXTURE(fstream &File)
 {
 int Num,NumS,Colour,txtp,txtn,txtm,texture,offx,offy,Index;
 float sizex,sizey;

 if (Parsed.Polygon==NULL)
  {
  Parsed.Polygon=new PolygonTYPE [Parsed.MaxPolygon];
  if (Parsed.Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Vertex==NULL)
  {
  cout << "\n\nERROR No Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> NumS;

 if (Num>=Parsed.MaxPolygon)
  {
  cout << "\n\nERROR Max Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Polygon[Num].NumVertices=NumS;
 Parsed.Polygon[Num].TypeOfPolygon=POLY_TEXTUR;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Polygon[Num].Vertex[a]=&Parsed.Vertex[Index];
  }

 File >> txtp >> txtm >> txtn >> texture >> sizex >> sizey >> offx >> offy;

 Parsed.Polygon[Num].TxtP=&Parsed.Vertex[txtp];
 Parsed.Polygon[Num].TxtM=&Parsed.Vertex[txtm];
 Parsed.Polygon[Num].TxtN=&Parsed.Vertex[txtn];
 Parsed.Polygon[Num].Texture=&Parsed.Texture[texture];
 Parsed.Polygon[Num].TextureModX=sizex;
 Parsed.Polygon[Num].TextureModY=sizey;
 Parsed.Polygon[Num].TextOffX=offx;
 Parsed.Polygon[Num].TextOffY=offy;
 }

void FUNC_CLASS_POLYGON_FLOOR(fstream &File)
 {
 int Num,NumS,Colour,txtp,txtn,txtm,texture,offx,offy,Index;
 float sizex,sizey;

 if (Parsed.Polygon==NULL)
  {
  Parsed.Polygon=new PolygonTYPE [Parsed.MaxPolygon];
  if (Parsed.Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Vertex==NULL)
  {
  cout << "\n\nERROR No Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> NumS;

 if (Num>=Parsed.MaxPolygon)
  {
  cout << "\n\nERROR Max Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Polygon[Num].NumVertices=NumS;
 Parsed.Polygon[Num].TypeOfPolygon=POLY_FLOOR;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Polygon[Num].Vertex[a]=&Parsed.Vertex[Index];
  }

 File >> txtp >> txtm >> txtn >> texture >> sizex >> sizey >> offx >> offy;

 Parsed.Polygon[Num].TxtP=&Parsed.Vertex[txtp];
 Parsed.Polygon[Num].TxtM=&Parsed.Vertex[txtm];
 Parsed.Polygon[Num].TxtN=&Parsed.Vertex[txtn];
 Parsed.Polygon[Num].Texture=&Parsed.Texture[texture];
 Parsed.Polygon[Num].TextureModX=sizex;
 Parsed.Polygon[Num].TextureModY=sizey;
 Parsed.Polygon[Num].TextOffX=offx;
 Parsed.Polygon[Num].TextOffY=offy;
 }

void FUNC_CLASS_POLYGON_QTEXT(fstream &File)
 {
 int Num,NumS,Colour,txtp,txtn,txtm,texture,offx,offy,Index;
 float sizex,sizey;

 if (Parsed.Polygon==NULL)
  {
  Parsed.Polygon=new PolygonTYPE [Parsed.MaxPolygon];
  if (Parsed.Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Vertex==NULL)
  {
  cout << "\n\nERROR No Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> NumS;

 if (Num>=Parsed.MaxPolygon)
  {
  cout << "\n\nERROR Max Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Polygon[Num].NumVertices=NumS;
 Parsed.Polygon[Num].TypeOfPolygon=POLY_QTEXT;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Polygon[Num].Vertex[a]=&Parsed.Vertex[Index];
  }

 File >> txtp >> txtm >> txtn >> texture >> sizex >> sizey >> offx >> offy;

 Parsed.Polygon[Num].TxtP=&Parsed.Vertex[txtp];
 Parsed.Polygon[Num].TxtM=&Parsed.Vertex[txtm];
 Parsed.Polygon[Num].TxtN=&Parsed.Vertex[txtn];
 Parsed.Polygon[Num].Texture=&Parsed.Texture[texture];
 Parsed.Polygon[Num].TextureModX=sizex;
 Parsed.Polygon[Num].TextureModY=sizey;
 Parsed.Polygon[Num].TextOffX=offx;
 Parsed.Polygon[Num].TextOffY=offy;
 }

void FUNC_CLASS_POLYGON_FRONT(fstream &File)
 {
 int Num,NumS,texture,Index;

 if (Parsed.Polygon==NULL)
  {
  Parsed.Polygon=new PolygonTYPE [Parsed.MaxPolygon];
  if (Parsed.Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Vertex==NULL)
  {
  cout << "\n\nERROR No Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> NumS;

 if (Num>=Parsed.MaxPolygon)
  {
  cout << "\n\nERROR Max Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Polygon[Num].NumVertices=NumS;
 Parsed.Polygon[Num].TypeOfPolygon=POLY_FRONT;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Polygon[Num].Vertex[a]=&Parsed.Vertex[Index];
  }

 File >> texture;

 Parsed.Polygon[Num].Texture=&Parsed.Texture[texture];
 }

void FUNC_CLASS_POLYGON_REAR(fstream &File)
 {
 int Num,NumS,texture,Index;

 if (Parsed.Polygon==NULL)
  {
  Parsed.Polygon=new PolygonTYPE [Parsed.MaxPolygon];
  if (Parsed.Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Vertex==NULL)
  {
  cout << "\n\nERROR No Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> Num >> NumS;

 if (Num>=Parsed.MaxPolygon)
  {
  cout << "\n\nERROR Max Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Polygon[Num].NumVertices=NumS;
 Parsed.Polygon[Num].TypeOfPolygon=POLY_REAR;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Polygon[Num].Vertex[a]=&Parsed.Vertex[Index];
  }

 File >> texture;

 Parsed.Polygon[Num].Texture=&Parsed.Texture[texture];
 }

void FUNC_CLASS_VERTEX(fstream &File)
 {
 int Num;
 float X,Y,Z;

 if (Parsed.Vertex==NULL)
  {
  Parsed.Vertex=new VertexTYPE [Parsed.MaxVertex];
  if (Parsed.Vertex==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 File >> Num >> X >> Y >> Z;

 if (Num>=Parsed.MaxVertex)
  {
  cout << "\n\nERROR Max Vertex Exceeded On Command " << Command;
  exit(-1);
  }

 Parsed.Vertex[Num].ox=X;
 Parsed.Vertex[Num].oy=Y;
 Parsed.Vertex[Num].oz=Z;
 }

void FUNC_CLASS_VERTEX_LIGHT(fstream &File)
 {
 int Num,Light;
 float X,Y,Z;

 if (Parsed.Vertex==NULL)
  {
  Parsed.Vertex=new VertexTYPE [Parsed.MaxVertex];
  if (Parsed.Vertex==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }

 File >> Num >> X >> Y >> Z >> Light;

 if (Num>=Parsed.MaxVertex)
  {
  cout << "\n\nERROR Max Vertex Exceeded On Command " << Command;
  exit(-1);
  }

 Parsed.Vertex[Num].ox=X;
 Parsed.Vertex[Num].oy=Y;
 Parsed.Vertex[Num].oz=Z;
 Parsed.Vertex[Num].light=Light;
 }

void FUNC_CLASS_VERTEX_2DMAP(fstream &File)
 {
 int Num;
 float X,Y,Z,ftx,fty,rtx,rty;

 if (Parsed.Vertex==NULL)
  {
  Parsed.Vertex=new VertexTYPE [Parsed.MaxVertex];
  if (Parsed.Vertex==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }

 File >> Num >> X >> Y >> Z >> ftx >> fty >> rtx >> rty;

 if (Num>=Parsed.MaxVertex)
  {
  cout << "\n\nERROR Max Vertex Exceeded On Command " << Command;
  exit(-1);
  }

 Parsed.Vertex[Num].ox=X;
 Parsed.Vertex[Num].oy=Y;
 Parsed.Vertex[Num].oz=Z;
 Parsed.Vertex[Num].TextFX=ftx;
 Parsed.Vertex[Num].TextFY=fty;
 Parsed.Vertex[Num].TextRX=rtx;
 Parsed.Vertex[Num].TextRY=rty;
 }

void FUNC_CLASS_INCLUDE_STATIC(fstream &File)
 {
 char FileName[600];
 int ax,ay,az,texture;
 float ox,oy,oz;

 if (Parsed.Dyna_Object==NULL)
  {
  Parsed.Dyna_Object=new ObjectTYPE [Parsed.MaxDynaObject];
  if (Parsed.Dyna_Object==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }

 File >> FileName >> texture >> ox >> oy >> oz >> ax >> ay >> az;

 OffsetTexture=texture;

 if (CurrentDynaObject>=Parsed.MaxDynaObject)
  {
  cout << "\n\nERROR Max Dynamic Object Exceeded On Command " << Command;
  exit(-1);
  }

 Parse(FileName);       // a bit of recursive parsing :)

 if (Parsed.Dyna_Polygon==NULL)
  {
  cout << "\n\nERROR No Dynamic Polygons Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Dyna_Vertex==NULL)
  {
  cout << "\n\nERROR No Dynamic Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 Parsed.Dyna_Object[CurrentDynaObject].Ox=ox;
 Parsed.Dyna_Object[CurrentDynaObject].Oy=oy;
 Parsed.Dyna_Object[CurrentDynaObject].Oz=oz;
 Parsed.Dyna_Object[CurrentDynaObject].Ax=ax;
 Parsed.Dyna_Object[CurrentDynaObject].Ay=ay;
 Parsed.Dyna_Object[CurrentDynaObject].Az=az;
 Parsed.Dyna_Object[CurrentDynaObject].ObjectType=OBJECT_STATIC;
 Parsed.Dyna_Object[CurrentDynaObject].NumOfVertices=CurrentDynaVertex-OffsetDynaVertex;
 Parsed.Dyna_Object[CurrentDynaObject].NumOfPolygons=CurrentDynaPolygon-OffsetDynaPolygon;
 Parsed.Dyna_Object[CurrentDynaObject].VertexList=&Parsed.Dyna_Vertex[OffsetDynaVertex];
 Parsed.Dyna_Object[CurrentDynaObject++].PolygonList=&Parsed.Dyna_Polygon[OffsetDynaPolygon];
 }

void FUNC_CLASS_DYNA_POLYGON(fstream &File)
 {
 int NumS,Colour,Index;

 if (Parsed.Dyna_Polygon==NULL)
  {
  Parsed.Dyna_Polygon=new PolygonTYPE [Parsed.MaxDynaPolygon];
  if (Parsed.Dyna_Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Dyna_Vertex==NULL)
  {
  cout << "\n\nERROR No Dynamic Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> NumS;

 if (CurrentDynaPolygon>=Parsed.MaxDynaPolygon)
  {
  cout << "\n\nERROR Max Dynamic Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Dyna_Polygon[CurrentDynaPolygon].NumVertices=NumS;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TypeOfPolygon=POLY_NORMAL;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Dyna_Polygon[CurrentDynaPolygon].Vertex[a]=&Parsed.Dyna_Vertex[Index+OffsetDynaVertex];
  }

 File >> Colour;

 Parsed.Dyna_Polygon[CurrentDynaPolygon++].Colour=Colour;
 }

void FUNC_CLASS_DYNA_POLYGON_SHADE(fstream &File)
 {
 int NumS,Colour,Index;

 if (Parsed.Dyna_Polygon==NULL)
  {
  Parsed.Dyna_Polygon=new PolygonTYPE [Parsed.MaxDynaPolygon];
  if (Parsed.Dyna_Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Dyna_Vertex==NULL)
  {
  cout << "\n\nERROR No Dynamic Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> NumS;

 if (CurrentDynaPolygon>=Parsed.MaxDynaPolygon)
  {
  cout << "\n\nERROR Max Dynamic Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Dyna_Polygon[CurrentDynaPolygon].NumVertices=NumS;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TypeOfPolygon=POLY_GSHADE;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Dyna_Polygon[CurrentDynaPolygon].Vertex[a]=&Parsed.Dyna_Vertex[Index+OffsetDynaVertex];
  }

 File >> Colour;

 Parsed.Dyna_Polygon[CurrentDynaPolygon++].Colour=Colour;
 }

void FUNC_CLASS_DYNA_POLYGON_TEXTURE(fstream &File)
 {
 int NumS,Colour,txtp,txtn,txtm,texture,offx,offy,Index;
 float sizex,sizey;

 if (Parsed.Dyna_Polygon==NULL)
  {
  Parsed.Dyna_Polygon=new PolygonTYPE [Parsed.MaxDynaPolygon];
  if (Parsed.Dyna_Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Dyna_Vertex==NULL)
  {
  cout << "\n\nERROR No Dynamic Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> NumS;

 if (CurrentDynaPolygon>=Parsed.MaxDynaPolygon)
  {
  cout << "\n\nERROR Max Dynamic Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Dyna_Polygon[CurrentDynaPolygon].NumVertices=NumS;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TypeOfPolygon=POLY_TEXTUR;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Dyna_Polygon[CurrentDynaPolygon].Vertex[a]=&Parsed.Dyna_Vertex[Index+OffsetDynaVertex];
  }

 File >> txtp >> txtm >> txtn >> texture >> sizex >> sizey >> offx >> offy;

 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtP=&Parsed.Dyna_Vertex[txtp+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtM=&Parsed.Dyna_Vertex[txtm+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtN=&Parsed.Dyna_Vertex[txtn+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].Texture=&Parsed.Texture[texture+OffsetTexture];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextureModX=sizex;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextureModY=sizey;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextOffX=offx;
 Parsed.Dyna_Polygon[CurrentDynaPolygon++].TextOffY=offy;
 }

void FUNC_CLASS_DYNA_POLYGON_FLOOR(fstream &File)
 {
 int NumS,Colour,txtp,txtn,txtm,texture,offx,offy,Index;
 float sizex,sizey;

 if (Parsed.Dyna_Polygon==NULL)
  {
  Parsed.Dyna_Polygon=new PolygonTYPE [Parsed.MaxDynaPolygon];
  if (Parsed.Dyna_Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Dyna_Vertex==NULL)
  {
  cout << "\n\nERROR No Dynamic Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> NumS;

 if (CurrentDynaPolygon>=Parsed.MaxDynaPolygon)
  {
  cout << "\n\nERROR Max Dynamic Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Dyna_Polygon[CurrentDynaPolygon].NumVertices=NumS;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TypeOfPolygon=POLY_FLOOR;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Dyna_Polygon[CurrentDynaPolygon].Vertex[a]=&Parsed.Dyna_Vertex[Index+OffsetDynaVertex];
  }

 File >> txtp >> txtm >> txtn >> texture >> sizex >> sizey >> offx >> offy;

 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtP=&Parsed.Dyna_Vertex[txtp+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtM=&Parsed.Dyna_Vertex[txtm+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtN=&Parsed.Dyna_Vertex[txtn+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].Texture=&Parsed.Texture[texture+OffsetTexture];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextureModX=sizex;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextureModY=sizey;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextOffX=offx;
 Parsed.Dyna_Polygon[CurrentDynaPolygon++].TextOffY=offy;
 }

void FUNC_CLASS_DYNA_POLYGON_QTEXT(fstream &File)
 {
 int NumS,Colour,txtp,txtn,txtm,texture,offx,offy,Index;
 float sizex,sizey;

 if (Parsed.Dyna_Polygon==NULL)
  {
  Parsed.Dyna_Polygon=new PolygonTYPE [Parsed.MaxDynaPolygon];
  if (Parsed.Dyna_Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Dyna_Vertex==NULL)
  {
  cout << "\n\nERROR No Dynamic Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> NumS;

 if (CurrentDynaPolygon>=Parsed.MaxDynaPolygon)
  {
  cout << "\n\nERROR Max Dynamic Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Dyna_Polygon[CurrentDynaPolygon].NumVertices=NumS;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TypeOfPolygon=POLY_QTEXT;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Dyna_Polygon[CurrentDynaPolygon].Vertex[a]=&Parsed.Dyna_Vertex[Index+OffsetDynaVertex];
  }

 File >> txtp >> txtm >> txtn >> texture >> sizex >> sizey >> offx >> offy;

 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtP=&Parsed.Dyna_Vertex[txtp+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtM=&Parsed.Dyna_Vertex[txtm+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TxtN=&Parsed.Dyna_Vertex[txtn+OffsetDynaVertex];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].Texture=&Parsed.Texture[texture+OffsetTexture];
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextureModX=sizex;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextureModY=sizey;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TextOffX=offx;
 Parsed.Dyna_Polygon[CurrentDynaPolygon++].TextOffY=offy;
 }

void FUNC_CLASS_DYNA_POLYGON_FRONT(fstream &File)
 {
 int NumS,texture,Index;

 if (Parsed.Dyna_Polygon==NULL)
  {
  Parsed.Dyna_Polygon=new PolygonTYPE [Parsed.MaxDynaPolygon];
  if (Parsed.Dyna_Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Dyna_Vertex==NULL)
  {
  cout << "\n\nERROR No Dynamic Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> NumS;

 if (CurrentDynaPolygon>=Parsed.MaxDynaPolygon)
  {
  cout << "\n\nERROR Max Dynamic Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Dyna_Polygon[CurrentDynaPolygon].NumVertices=NumS;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TypeOfPolygon=POLY_FRONT;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Dyna_Polygon[CurrentDynaPolygon].Vertex[a]=&Parsed.Dyna_Vertex[Index+OffsetDynaVertex];
  }

 File >> texture;

 Parsed.Dyna_Polygon[CurrentDynaPolygon++].Texture=&Parsed.Texture[texture+OffsetTexture];
 }

void FUNC_CLASS_DYNA_POLYGON_REAR(fstream &File)
 {
 int NumS,texture,Index;

 if (Parsed.Dyna_Polygon==NULL)
  {
  Parsed.Dyna_Polygon=new PolygonTYPE [Parsed.MaxDynaPolygon];
  if (Parsed.Dyna_Polygon==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 if (Parsed.Dyna_Vertex==NULL)
  {
  cout << "\n\nERROR No Dynamic Vertices Have Been Created Yet On Command " << Command;
  exit(-1);
  }
 if (Parsed.Texture==NULL)
  {
  cout << "\n\nERROR No Textures Have Been Created Yet On Command " << Command;
  exit(-1);
  }

 File >> NumS;

 if (CurrentDynaPolygon>=Parsed.MaxDynaPolygon)
  {
  cout << "\n\nERROR Max Dynamic Polygon Exceeded On Command " << Command;
  exit(-1);
  }
 Parsed.Dyna_Polygon[CurrentDynaPolygon].NumVertices=NumS;
 Parsed.Dyna_Polygon[CurrentDynaPolygon].TypeOfPolygon=POLY_REAR;

 for (int a=0;a<NumS;a++)
  {
  File >> Index;
  Parsed.Dyna_Polygon[CurrentDynaPolygon].Vertex[a]=&Parsed.Dyna_Vertex[Index+OffsetDynaVertex];
  }

 File >> texture;

 Parsed.Dyna_Polygon[CurrentDynaPolygon++].Texture=&Parsed.Texture[texture+OffsetTexture];
 }

void FUNC_CLASS_DYNA_VERTEX(fstream &File)
 {
 float X,Y,Z;

 if (Parsed.Dyna_Vertex==NULL)
  {
  Parsed.Dyna_Vertex=new VertexTYPE [Parsed.MaxDynaVertex];
  if (Parsed.Dyna_Vertex==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 File >> X >> Y >> Z;

 if (CurrentDynaVertex>=Parsed.MaxDynaVertex)
  {
  cout << "\n\nERROR Max Dynamic Vertex Exceeded On Command " << Command;
  exit(-1);
  }

 Parsed.Dyna_Vertex[CurrentDynaVertex].ox=X;
 Parsed.Dyna_Vertex[CurrentDynaVertex].oy=Y;
 Parsed.Dyna_Vertex[CurrentDynaVertex++].oz=Z;
 }

void FUNC_CLASS_DYNA_VERTEX_LIGHT(fstream &File)
 {
 int Light;
 float X,Y,Z;

 if (Parsed.Dyna_Vertex==NULL)
  {
  Parsed.Dyna_Vertex=new VertexTYPE [Parsed.MaxDynaVertex];
  if (Parsed.Dyna_Vertex==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }

 File >> X >> Y >> Z >> Light;

 if (CurrentDynaVertex>=Parsed.MaxDynaVertex)
  {
  cout << "\n\nERROR Max Dynamic Vertex Exceeded On Command " << Command;
  exit(-1);
  }

 Parsed.Dyna_Vertex[CurrentDynaVertex].ox=X;
 Parsed.Dyna_Vertex[CurrentDynaVertex].oy=Y;
 Parsed.Dyna_Vertex[CurrentDynaVertex].oz=Z;
 Parsed.Dyna_Vertex[CurrentDynaVertex++].light=Light;
 }

void FUNC_CLASS_DYNA_VERTEX_2DMAP(fstream &File)
 {
 float X,Y,Z,ftx,fty,rtx,rty;

 if (Parsed.Dyna_Vertex==NULL)
  {
  Parsed.Dyna_Vertex=new VertexTYPE [Parsed.MaxDynaVertex];
  if (Parsed.Dyna_Vertex==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }

 File >> X >> Y >> Z >> ftx >> fty >> rtx >> rty;

 if (CurrentDynaVertex>=Parsed.MaxDynaVertex)
  {
  cout << "\n\nERROR Max Dynamic Vertex Exceeded On Command " << Command;
  exit(-1);
  }

 Parsed.Dyna_Vertex[CurrentDynaVertex].ox=X;
 Parsed.Dyna_Vertex[CurrentDynaVertex].oy=Y;
 Parsed.Dyna_Vertex[CurrentDynaVertex].oz=Z;
 Parsed.Dyna_Vertex[CurrentDynaVertex].TextFX=ftx;
 Parsed.Dyna_Vertex[CurrentDynaVertex].TextFY=fty;
 Parsed.Dyna_Vertex[CurrentDynaVertex].TextRX=rtx;
 Parsed.Dyna_Vertex[CurrentDynaVertex++].TextRY=rty;
 }

short FindClosestRGB(short Red,short Green,short Blue,unsigned char *Palette);

short PalLoaded=0;

void FUNC_CLASS_GRAPHIC(fstream &File)
 {
 int Num;
 char FileName[600];
 fstream check;
 unsigned char Palette[256*3]; // Temp Palette for merging
 unsigned short Convert[256];   // pixel col num conversion

 if (Parsed.Graphic==NULL)
  {
  Parsed.Graphic=new unsigned char * [Parsed.MaxGraphic];
  if (Parsed.Graphic==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  for (int a=0;a<Parsed.MaxGraphic;a++)
   Parsed.Graphic[a]=NULL;
  }

 if (PalLoaded==0)
  {
  cout << "\n\nERROR Palette Not Loaded Cannot Convert Picture On Command " << Command;
  exit(-1);
  }

 File >> Num >> FileName;

 if (Num>=Parsed.MaxGraphic)
  {
  cout << "\n\nERROR Max Graphic Exceeded On Command " << Command;
  exit(-1);
  }
 if (Parsed.Graphic[Num]!=NULL)
  {
  cout << "\n\nERROR Graphic Already Defined On Command " << Command;
  exit(-1);
  }
 check.open(FileName,ios::in);
 if (!check)
  {
  cout << "\n\nERROR File \"" << FileName << "\" Could Not Be Read On Command " << Command;
  exit(-1);
  }
 check.close();

 GetPCXInfo(&HeaderInfo,FileName);
 Parsed.Graphic[Num]=new unsigned char [(HeaderInfo.Ymax-HeaderInfo.Ymin+1)*HeaderInfo.BytesPerLine];
 if (Parsed.Graphic[Num]==NULL)
  {
  cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
  exit(-1);
  }
 GetPCXPicture(&HeaderInfo,FileName,Parsed.Graphic[Num]);
 GetPCXPalette(&HeaderInfo,FileName,Palette);

 int ColNum;

 for (int a=0;a<256;a++)        // convert picture to level palette!
  {
  ColNum=FindClosestRGB(Palette[a*3+0],Palette[a*3+1],Palette[a*3+2],Parsed.Palette);
  Convert[a]=ColNum;
  }

 cout << "\nConverting \"" << FileName << "\" To Current Palette";

 for (int b=0;b<((HeaderInfo.Ymax-HeaderInfo.Ymin+1)*HeaderInfo.BytesPerLine);b++)
  {
  Parsed.Graphic[Num][b]=Convert[Parsed.Graphic[Num][b]];
  }

 }

void FUNC_CLASS_TEXTURE(fstream &File)
 {
 int Num,Graphic,Width,Height,Frame,Mask;

 if (Parsed.Texture==NULL)
  {
  Parsed.Texture=new TextureTYPE [Parsed.MaxTexture];
  if (Parsed.Texture==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }

 File >> Num >> Graphic >> Width >> Height >> Frame >> Mask;

 if (Num>=Parsed.MaxTexture)
  {
  cout << "\n\nERROR Max Texture Exceeded On Command " << Command;
  exit(-1);
  }

 Parsed.Texture[Num].Graphic=Graphic;
 Parsed.Texture[Num].Width=Width;
 Parsed.Texture[Num].Height=Height;
 Parsed.Texture[Num].CurrentFrame=Frame;
 Parsed.Texture[Num].FrameMask=Mask;
 }

void FUNC_CLASS_PALETTE(fstream &File)
 {
 int Num;
 char FileName[600];
 fstream check;

 File >> FileName;

 check.open(FileName,ios::in);
 if (!check)
  {
  cout << "\n\nERROR File \"" << FileName << "\" Could Not Be Read On Command " << Command;
  exit(-1);
  }
 check.close();

 if (PalLoaded==1)
  {
  cout << "\n\nERROR Palette Already Loaded On Command " << Command;
  exit(-1);
  }

 GetPCXInfo(&HeaderInfo,FileName);
 GetPCXPalette(&HeaderInfo,FileName,Parsed.Palette);
 PalLoaded=1;
 }

void FUNC_CLASS_CAMERA(fstream &File)
 {
 int Num,ax,ay,az;
 float X,Y,Z;

 if (Parsed.Camera==NULL)
  {
  Parsed.Camera=new CameraTYPE [Parsed.MaxCamera];
  if (Parsed.Camera==NULL)
   {
   cout << "\n\nERROR Out Of Memory!!!! On Command " << Command;
   exit(-1);
   }
  }
 File >> Num >> X >> Y >> Z >> ax >> ay >> az;

 if (Num>=Parsed.MaxCamera)
  {
  cout << "\n\nERROR Max Camera Exceeded On Command " << Command;
  exit(-1);
  }

 Parsed.Camera[Num].Ox=X;
 Parsed.Camera[Num].Oy=Y;
 Parsed.Camera[Num].Oz=Z;
 Parsed.Camera[Num].Ax=ax;
 Parsed.Camera[Num].Ay=ay;
 Parsed.Camera[Num].Az=az;
 Parsed.Camera[Num].Xx=1;
 Parsed.Camera[Num].Xy=0;
 Parsed.Camera[Num].Xz=0;
 Parsed.Camera[Num].Yx=0;
 Parsed.Camera[Num].Yy=1;
 Parsed.Camera[Num].Yz=0;
 Parsed.Camera[Num].Zx=0;
 Parsed.Camera[Num].Zy=0;
 Parsed.Camera[Num].Zz=1;
 }
