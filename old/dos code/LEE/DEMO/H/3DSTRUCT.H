/*
    Design & Code By Xavier / SCUDD '96
*/

#define NUMVERTS (20)	// max verts per polygon

#define POLY_NORMAL (0) // SINGLE COLOUR FILLED POLYGON
#define POLY_GSHADE (1) // GOURAUD SHADED (not used any more at present)
#define POLY_TEXTUR (2) // FULL BLOWN COMPLEX TEXTURE MAPPING
#define POLY_WALL   (3)	// special properties... e.g. ALLWAYS VERTICAL PLOTTING :)
#define POLY_FLOOR  (4)	// special properties... e.g. ALLWAYS HORIZONTAL PLOTTING :)

#define OBJECT_SECTOR (0)
#define OBJECT_SPRITE (1)
#define OBJECT_GLOBAL (255)	// used for first object (LISTS ALL POINTS)

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
 float wx,wy,wz; // vertex working  coordinates
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

// structure of light source at present unused
struct LightSourceTYPE
  {
  float x,y,z; // coodinates of light source
  float wx,wy,wz; // working (intermediate) coordinates
  short ax,ay,az; // rotation angles
  };
