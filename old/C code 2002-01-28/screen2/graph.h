// Module Graphics system
//		DirectX Version
//
// Includes -
//   cSCREEN
//   cBUTTON
//
// Coded by Dark Elf
//
#include <ddraw.h>
#include <windows.h>
#include <windowsx.h>

#include "texture.h"
#define MFLOAT float

#define TEXTURE24 1
#define TEXTURE16 2
#define TEXTURE8 4

class cSCREEN;

class cBUTTON
{
public:
	long PositionX;				// position relative to window
	long PositionY;
	long SizeX;
	long SizeY;
	cTEXTURE *Pressed;		// bitmap pointers
	cTEXTURE *NotPressed;
	long TextureType;		// 24bit,8bit...
};

class cSLIDER
{
public:
	long PositionX;
	long PositionY;
	long SizeX;
	long SizeY;
	long CurrentValue;
	long LastValue;
	long ScaleFactor; // mouse coord to value
	long Alignment;//1-horiz, 2-vert
	long Type; // 1-Colour bar horiz red,2-green,3-blue,4-mono (or) 8 display value
	
	unsigned char *UpdateMeB;	// Pointers Set to varable attached to slider value
	unsigned short *UpdateMeW;	// if ptr==0 then none attached
	long *UpdateMeL;
	
	cSLIDER();
	~cSLIDER();
	
	void Check(long MouseX,long MouseY);	// update slider value if mouse in bounds
	void PlotPosition(cSCREEN *CurrentWindow); // plots 2 dots at the moment
	void Update(cSCREEN *CurrentWindow);	// If slider has changed then update
};

class cCONSOLE
{
public:
	long PositionX;
	long PositionY;
	long SizeX;
	long SizeY;
	long FontSizeX;	// un-supported
	long FontSizeY;
	unsigned char *FrontBuffer;

	cCONSOLE();
	~cCONSOLE();

	long Open(long positionX,long positionY,long sizeX,long sizeY);
	long Update(cSCREEN *);
	void Cout(char *StringOut);

};


class cSCREEN
{
private:
	unsigned char MouseBuffer[4*3];
	
public:
	RECT Rect;
	LPDIRECTDRAW			lpDD;           // DirectDraw object
	LPDIRECTDRAWSURFACE		lpDDSPrimary;   // DirectDraw primary surface
	LPDIRECTDRAWSURFACE		lpDDSBack;      // DirectDraw back surface
	BOOL                    bActive;        // is application active?
	DDSURFACEDESC			ddsd;
	HWND					hwnd;
	HRESULT				    hr;
    HRESULT					res;
	long FakeID;	// debug mode, direct x screen not enabled, all rendering 
	// done to backbuffer, and outputed to screen.raw at exit
	
    HDC		hdc;//text output
	long	Locked; //0=unlocked,1=locked
	
	unsigned char TextR,TextG,TextB;
	unsigned char BackTextR,BackTextG,BackTextB;
	
	long PositionX;
	long PositionY;
	long SizeX;
	long SizeY;
	unsigned char *BackBuffer;
	unsigned char *FrontBuffer;
	unsigned char *AlphaBuffer;	// hack for 24bit gouraud shading
	MFLOAT *ZBuffer;		// Software Zbuffer
	MFLOAT *ZBufferBack;
	cSCREEN *SubScreenList;
	long NumSubScreens;
	cCONSOLE *Consoles;
	long NumConsoles;
	long Type; // 0=24bit
	long PixelLength;
	
	long NumButtons;//unsuported
	cBUTTON *Buttons;
	long NumSliders;
	cSLIDER Sliders[10];
	long MouseX;		// Current Mouse Position relative to screen,unsuported
	long MouseY;
	
	~cSCREEN();
	cSCREEN();
	
	// Init
	long Open(HINSTANCE hInstance, int nCmdShow ,long FakeON);
	long Open(long sizex,long sizey,long bbp,long r,long g,long b,long rv);
	void CloseScreen();
	long Lock();
	long Unlock();
	
	// Windows Graphic Operations
	long Cout(long PositionX,long PositionY,char *Text);
	long Cout(long PositionX,long PositionY,char *Text,long Length);
	long Cout(long PositionX,long PositionY,char *Text,unsigned char r,unsigned char g,unsigned char b);
	void CopyBackToFront();
	
	
	
	// Bitmap copy
	void BlitAreaMono(unsigned char *SourcePtr,int OffsetX,
		int OffsetY,int SourceX,int SourceY);
	void BlitArea(unsigned char *SourcePtr,int OffsetX,
		int OffsetY,int SourceX,int SourceY);
	void BlitAreaM(unsigned char *SourcePtr,int OffsetX,
		int OffsetY,int SourceX,int SourceY,unsigned char Mask);
	void BlitAreaLong(unsigned char *SourcePtr,int OffsetX,
		int OffsetY,int SourceX,int SourceY);
	void CopyBack(long PositionX,long PositionY,cTEXTURE *Destnation); 
	void CopyBack0M(long PositionX,long PositionY,cTEXTURE *Destnation); //ut
	void BlitArea0M(unsigned char *SourcePtr,int OffsetX,
		int OffsetY,int SourceX,int SourceY);
	
	// Line drawing
	void DrawLine(long x1,long y1,long x2,long y2);
	
	// Pixel 
	void LargeDot(long x,long y);
	void LargeDot(long x,long y,unsigned char r,unsigned char g,unsigned char b);
	void Dot(long x,long y,unsigned char r,unsigned char g,unsigned char b);
	
	// Clear
	void CLSAreaL(int start,int Size);
	void CLSBox(int x1,int y1,int x2,int y2);
	void CLSBoxLong(long x1,long y1,long x2,long y2);
	
	// Mouse Cursor
	void MousePlot(long x,long y,unsigned char r,unsigned char g,unsigned char b);
	void MouseRemove(long x,long y);
	
	// ZBuffer
	void ClearZBuffer();
	void ClearZBufferFast();
	void ClearZBufferArea(long x1,long y1,long x2,long y2);
	
	// Filled Boxes
	void Box(long x1,long y1,long x2,long y2,unsigned char r,
		unsigned char g,unsigned char b);
	
};


