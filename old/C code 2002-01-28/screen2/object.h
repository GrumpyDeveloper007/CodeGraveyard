#define MFLOAT float
// Module - object
//
// Includes -
//   cOBJECT
// 
// Coded by Dark Elf
#define INIT 0001

#include <fstream.h>

struct FRAMECOMPONENT
{
	long NumPolygons;
	unsigned long *PolygonList;
};
struct FRAMECOMPONENTSTATE
{
	MFLOAT ox,oy,oz;
	MFLOAT dx,dy,dz;
};

class cFRAMECOMPONENTTYPE
{
public:
	long CurrentState;		// index for array
	long NumStates;
	long *FrameType;		// Type of operation to be performed on component(list)
	FRAMECOMPONENTSTATE *Start;	// Start state(list)
	FRAMECOMPONENTSTATE *End;	// End state(list)
};

class cOBJECTFRAME
{
public:
	FRAMECOMPONENT *ComponentList; // Contains information for grouping polgons to components
	long NumComponents;
	cFRAMECOMPONENTTYPE *ComponentStates; // Contains animation of component movements
	long FrameNumber;
	//void UpdateFrame()
	//void ResetFrame()
	
};

class cOBJECT
{
private:
	POLYGON *CurrentPoly;
	long CurrentPolyNum;
	
public:
	cOBJECTFRAME Frame;
	MFLOAT ScaleFactor;
	long NumPolygons;
	long NumVectors;
	long NumVectorsT;//used by clipping
	POLYGON *Polygons;
	VECTOR *Vectors;		// 
	VECTOR *RVectors;
	VECTOR *TVectors;		// Transformed vectors
	
	MFLOAT CX,CY,CZ;		// Not used - object center x,y,z
	MFLOAT BR;			// Not used - bounding box Radius
	
	cOBJECT();
	~cOBJECT();
	
	// 3D-Operations
	long InitTransform();
	long RotateXYZ(MFLOAT AngleXZ,MFLOAT AngleYZ,MFLOAT AngleXY,long Status);
	long Scale(MFLOAT factor);
	void TranslateVectors(long centerx, long centery);
	
	// Save / Load 3DO
	long Read3DO(char *filename);
	void Write3DO(char *filename);
	
	// Drawing
	void PlotObjectZShade();
	void PlotObjectTexture();
	void PlotObjectShaded();
	void PlotObjectShaded24();
	
	// Low-level
	void DrawSpan(int startx,int endx,MFLOAT z1,MFLOAT z2,int y);
	void DrawSpan2(int startx,int endx,MFLOAT z1,MFLOAT z2,int y,MFLOAT pix,MFLOAT pix2);
	void DrawSpan3(int startx,int endx,MFLOAT z1,MFLOAT z2,int y,
		MFLOAT pixa,MFLOAT pixa2,MFLOAT pixb,MFLOAT pixb2,MFLOAT pixc,MFLOAT pixc2);
	void DrawSpan4(int startx,int endx,MFLOAT z1,MFLOAT z2,int y,
		MFLOAT pixa,MFLOAT pixa2,MFLOAT pixb,MFLOAT pixb2,MFLOAT pixc,MFLOAT pixc2);

	void DrawPoly(POLYGON *currentpoly);
	void DrawPoly24(POLYGON *currentpoly);
	void DrawPolyZShade(POLYGON *currentpoly);
	void TextureFacePlot(unsigned char *,VertexTYPE *Vertices,int NumSides,int width,MFLOAT Z);
	
	long Clipper2(POLYGON *poly,VECTOR *TVectors, long minx,long maxx,long miny);
	void clipx(POLYGON *poly,VECTOR *TVectors,long v1,long v2,long current,long xclip);
};

/*
Object File Format -

DEFINE DYNA_VERTEX 105
-- Number of Vertex'es
DEFINE DYNA_POLYGON 82
--Number of Polyogns
  
// defines all vectors in object
CLASS DYN_VERTEX 0 4.11729 -8.79704 -0.112494
--Vertex=number,x,y,z
	
// defines all polygons in object
CLASS DYN_POLYGON 71 3 99 96 97 236 79 211 0 63 0 216 79 209 63 63 0 0 0 137 0
--Polygon=number,number of sides
--vertex number *number of sides
--r,g,b,tu,tv *number of sides
--texture number
	  
// links all related polygons into groups
CLASS FRAMECOMPONENT 0 4 1 2 3 4
--FrameComponent=number,number of polygons
--polygon number * number of polygons
		
// repersents all frames in the animation for one 'FRAMECOMPONENT'
CLASS FRAMESTATE 0 1 4 0 0 0 3 3 3 0 0 0 5 5 5
--Framestate=component number,number of frames in animation
--type,ox,oy,oz,dx,dy,dz ,ox2,oy2,oz2,dx2,dy2,dz2 * for all frames in animation
		  
*/