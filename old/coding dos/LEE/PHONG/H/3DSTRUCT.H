/*
    Design & Code By Xavier / SCUDD '96
*/

#define NUMVERTS (20)	// max verts per polygon

#define POLY_NORMAL (0) // SINGLE COLOUR FILLED POLYGON
#define POLY_GSHADE (1) // GOURAUD SHADED (not by light source though!)
#define POLY_TEXTUR (2) // FULL BLOWN COMPLEX TEXTURE MAPPING
#define POLY_WALL   (3)	// special properties... e.g. ALLWAYS VERTICAL PLOTTING :)
#define POLY_FLOOR  (4)	// special properties... e.g. ALLWAYS HORIZONTAL PLOTTING :)
#define POLY_QTEXT  (5) // FULL BLOWN BILINEAR TEXTURE MAPPING (Faster than POLY_TEXTUR)
#define POLY_FRONT  (6) // 2d interpolated polygon (use front map of pixels)
#define POLY_REAR   (7) // 2d interpolated polygon (use rear map of pixels)

#define OBJECT_SECTOR (0) // somewhere fixed in the tree
#define OBJECT_SPRITE (1) // can move freely (in moving list)
#define OBJECT_STATIC (2) // fixed at position in map (dead?)

struct TextureTYPE
 {
 short Graphic;           // Index into GFXList of graphic in memory
 short Width,Height;
 short CurrentFrame;
 short FrameMask;         // Frames can be 0,2,4,8,16,32,64 etc long!
 };

struct VertexTYPE
 {
 float ox,oy,oz; // vertex original coordinates
 float light;   // light level at this point
 float TextFX,TextFY; // Pixel offset to texture (FOR MDL TYPE STUFF) (FRONT)
 float TextRX,TextRY; // Pixel offset to texture (FROM REAR)
 float wx,wy,wz; // vertex working  coordinates
 float Nx,Ny,Nz;        // vertex psuedo normals
 float Nwx,Nwy,Nwz; 
 short sx,sy; // vertex screen coordinates
 };

// structure of one polygon
struct PolygonTYPE
 {
 short NumVertices;
 VertexTYPE *Vertex[NUMVERTS]; // Pointer to the vertices in the list
 float Nx,Ny,Nz; // polygon normals
 float Nwx,Nwy,Nwz; // polygon normals
 short TypeOfPolygon;     // 0 - Normal, 1 - Gshade, 2 - Textured
 short Colour;
 VertexTYPE *TxtP,*TxtM,*TxtN;  // point to the 3 coords used to tmap poly
 TextureTYPE *Texture;		// address of texture to plot
 float TextureModX,TextureModY; // changes the X,Y size of texture on poly
 short TextOffX,TextOffY;
 };

// object structure
struct ObjectTYPE
 {
 float Ox,Oy,Oz; // coordinates of object in scene
 short Ax,Ay,Az; // object's rotation angles
 short NumOfVertices; // number of vertices in object
 VertexTYPE *VertexList; // first vertex in object
 short NumOfPolygons; // number of polygons in object
 PolygonTYPE *PolygonList; // first polygon in object
 short ObjectType;
 };

// camera structure
struct CameraTYPE
 {
 int Ax,Ay,Az;          // rotate camera using these values
 float Ox,Oy,Oz;        // origin of camera in world coords
 float Xx,Xy,Xz;        // camera X vector (unit) original
 float Yx,Yy,Yz;        // camera Y vector (unit) original
 float Zx,Zy,Zz;        // camera Z vector (unit) original
 float Xwx,Xwy,Xwz;     // camera X vector (unit) working
 float Ywx,Ywy,Ywz;     // camera Y vector (unit) working
 float Zwx,Zwy,Zwz;     // camera Z vector (unit) working
 };

// Node structure for BSP tree
struct NodeData
 {
 int Type;      // 1 - is object 0 - divisor
 ObjectTYPE *Ptr;
 int Plane;	// 0 - X   1 - Y   2 - Z
 float Position;
 };

// Used for parsing 3DO files
struct ParseBlock
 {
 ObjectTYPE *Object;
 PolygonTYPE *Polygon;
 VertexTYPE *Vertex;
 ObjectTYPE *Dyna_Object;
 PolygonTYPE *Dyna_Polygon;
 VertexTYPE *Dyna_Vertex;
 NodeData *TreeNode;
 Tree *BSPTree;
 unsigned char **Graphic;
 TextureTYPE *Texture;
 CameraTYPE *Camera;
 unsigned char Palette[256*3];
 int MaxTreeNode;
 int MaxObject;
 int MaxPolygon;
 int MaxVertex;
 int MaxGraphic;
 int MaxTexture;
 int MaxCamera;
 int MaxDynaObject;
 int MaxDynaPolygon;
 int MaxDynaVertex;
 int LastDynaObject;
 };
