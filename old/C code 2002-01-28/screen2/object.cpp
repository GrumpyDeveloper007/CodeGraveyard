
// Module - object
//
// Includes -
//   
//   
// 
// Coded by Dark Elf
//

#include <math.h>
#include <string.h>

#include "types.h"
#include "general.h"
#include "object.h"
#include "graph.h"

const ReadScale=40;
const cMaxVectors=2500;          // Maximum allowed vectors
const cMaxFaces=2500;            // Maximum polygons
const cMaxSides=50;              // Maximum sides of a polygon
const cMaxComponentTypes=100;

extern fstream dale;
extern long *PolyBuffer;
extern MFLOAT *ZBuffer;
extern cSCREEN MainWindow;
extern cTEXTURE *GlobalTextures;
MFLOAT ZZ;

#include "leecode.h"

extern long Alpha;

////////////////////////////////////////////////////////////////////////////////////////////////
// Scan conversion code, Span plotting code
// DrawPoly - Gouraud shaded polygon / ZBuffer
// DrawPolyZShade - Gouraud shaded polygon using z as shading value / ZBuffer

void cOBJECT::DrawSpan(int startx,int endx,MFLOAT z1,MFLOAT z2,int y)
{
	static unsigned char *SpanPtr,pixt;
	static int x;
	static MFLOAT z,incz;
	static MFLOAT *zbuffer;
	static long *PolyBufferTemp;
	
	z=z1;
	if (y>=0/* && startx<endx*/)
	{
		PolyBufferTemp=&PolyBuffer[startx+y*320];
		zbuffer=&MainWindow.ZBuffer[y*MainWindow.SizeX+startx];
		SpanPtr=(unsigned char *)MainWindow.FrontBuffer+(y*MainWindow.SizeX+startx)*MainWindow.PixelLength;
		incz=(z2-z1)/(endx-startx);
		for(x=startx;x<endx;x++)
		{
			if (*zbuffer<z)
			{
				*PolyBufferTemp=(long)CurrentPolyNum;
				pixt=(unsigned char) ( (MFLOAT) (z*65536*2) )-100;
				*(SpanPtr)= pixt;
				*(SpanPtr+1)= pixt;
				*(SpanPtr+2)= pixt;
				*zbuffer=z;
			}
			SpanPtr+=MainWindow.PixelLength;
			zbuffer++;
			PolyBufferTemp++;
			z+=incz;
		}
	}
}


void cOBJECT::DrawSpan2(int startx,int endx,MFLOAT z1,MFLOAT z2,int y,
						MFLOAT pix,MFLOAT pix2)
{
	static unsigned char *SpanPtr;
	static int x;
	static MFLOAT z,incz;
	static MFLOAT *zbuffer;
	static MFLOAT incshade,shade;
	static long *PolyBufferTemp;
	
	if (y>=0/* && startx<endx*/)
	{
		z=z1;
		shade=pix;
		PolyBufferTemp=&PolyBuffer[startx+y*320];
		zbuffer=&MainWindow.ZBuffer[y*MainWindow.SizeX+startx];
		SpanPtr=(unsigned char *)MainWindow.FrontBuffer
			+(y*MainWindow.SizeX+startx)*MainWindow.PixelLength;
		
		incshade=((MFLOAT)pix2-pix)/(endx-startx);
		incz=(z2-z1)/(endx-startx);
		
		for (x=startx;x<endx;x++)
		{
			shade+=incshade;
			z+=incz;
			if (z<(*zbuffer))
			{
				*PolyBufferTemp=(long)CurrentPolyNum;
				*(SpanPtr)=(unsigned char )(shade);
				*(SpanPtr+1)=(unsigned char )(shade);
				*(SpanPtr+2)=(unsigned char )(shade);
				
				*zbuffer=z;
			}
			zbuffer++;
			PolyBufferTemp++;
			SpanPtr+=MainWindow.PixelLength;
		}
	}
}

void cOBJECT::DrawSpan3(int startx,int endx,MFLOAT z1,MFLOAT z2,int y,
	MFLOAT pixa,MFLOAT pixa2,MFLOAT pixb,MFLOAT pixb2,MFLOAT pixc,MFLOAT pixc2)
{
	static unsigned char *SpanPtr;
	static int x;
	static MFLOAT z,incz;
	static MFLOAT *zbuffer;
	static MFLOAT incshadea,shadea;
	static MFLOAT incshadeb,shadeb;
	static MFLOAT incshadec,shadec;
	static long *PolyBufferTemp;
	
	if (y>=0/* && startx<endx*/)
	{
		z=z1;
		shadea=pixa;
		shadeb=pixb;
		shadec=pixc;
		PolyBufferTemp=&PolyBuffer[startx+y*320];
		zbuffer=&MainWindow.ZBuffer[y*MainWindow.SizeX+startx];
		SpanPtr=(unsigned char *)MainWindow.FrontBuffer
			+(y*MainWindow.SizeX+startx)*MainWindow.PixelLength;
		
		incshadea=((MFLOAT)pixa2-pixa)/(endx-startx);
		incshadeb=((MFLOAT)pixb2-pixb)/(endx-startx);
		incshadec=((MFLOAT)pixc2-pixc)/(endx-startx);
		incz=(z2-z1)/(endx-startx);
		
		for (x=startx;x<endx;x++)
		{
			shadea+=incshadea;
			shadeb+=incshadeb;
			shadec+=incshadec;
			z+=incz;
			if (z<(*zbuffer))
			{
				*PolyBufferTemp=(long)CurrentPolyNum;
				*(SpanPtr)=(unsigned char )(shadea);
				*(SpanPtr+1)=(unsigned char )(shadeb);
				*(SpanPtr+2)=(unsigned char )(shadec);
				
				*zbuffer=z;
			}
			zbuffer++;
			PolyBufferTemp++;
			SpanPtr+=MainWindow.PixelLength;
		}
	}
}

// pass 2: alpha blend shading
void cOBJECT::DrawSpan4(int startx,int endx,MFLOAT z1,MFLOAT z2,int y,
	MFLOAT pixa,MFLOAT pixa2,MFLOAT pixb,MFLOAT pixb2,MFLOAT pixc,MFLOAT pixc2)
{
	static unsigned char *SpanPtr;
	static int x;
	static MFLOAT z,incz;
	static MFLOAT *zbuffer;
	static MFLOAT incshadea,shadea;
	static MFLOAT incshadeb,shadeb;
	static MFLOAT incshadec,shadec;
	static long *PolyBufferTemp;
	//static long r,g,b;
	
	if (y>=0/* && startx<endx*/)
	{
		z=z1;
		shadea=pixa;
		shadeb=pixb;
		shadec=pixc;
		PolyBufferTemp=&PolyBuffer[startx+y*320];
		zbuffer=&MainWindow.ZBuffer[y*MainWindow.SizeX+startx];
		SpanPtr=(unsigned char *)MainWindow.AlphaBuffer
			+(y*MainWindow.SizeX+startx)*MainWindow.PixelLength;
		
		incshadea=((MFLOAT)pixa2-pixa)/(endx-startx);
		incshadeb=((MFLOAT)pixb2-pixb)/(endx-startx);
		incshadec=((MFLOAT)pixc2-pixc)/(endx-startx);
		incz=(z2-z1)/(endx-startx);
		
		for (x=startx;x<endx;x++)
		{
			shadea+=incshadea;
			shadeb+=incshadeb;
			shadec+=incshadec;
			z+=incz;
			if (z<(*zbuffer))
			{
				*PolyBufferTemp=(long)CurrentPolyNum;
				*(SpanPtr)=(unsigned char )((shadea));
				*(SpanPtr+1)=(unsigned char )((shadeb));
				*(SpanPtr+2)=(unsigned char )((shadec));
				
				*zbuffer=z;
			}
			zbuffer++;
			PolyBufferTemp++;
			SpanPtr+=MainWindow.PixelLength;
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////
// DrawPoly - plots polygon 

void cOBJECT::DrawPoly(POLYGON *currentpoly)
{
	long signL,xL1,yL1,numeratorL,denominatorL,incrementL;
	long signR,xR1,yR1,numeratorR,denominatorR,incrementR;
	long i,top,yval,currentL,currentR,xL2,yL2,xR2,yR2,ystart,yend,yend1;
	MFLOAT zL1,zR1,zL2,zR2,inczL,inczR; // Z values for left and right point (used for z buffer)
	MFLOAT cL1,cR1,cL2,cR2,inccL,inccR; // light values ,current light left
	
	long numpoints=currentpoly->ClippedNumVectors;
	
	inccL=0;inccR=0;
	inczL=0;inczR=0;
	
	// determine bottom point
	yend1=(long)TVectors[currentpoly->ClippedVectorIndex[0]].y;
	for (i=1;i<numpoints;i++)
	{
		if ((long)TVectors[currentpoly->ClippedVectorIndex[i]].y>yend1)
		{
			yend1=(long)TVectors[currentpoly->ClippedVectorIndex[i]].y;
		}
	}
	
	// Clip to bottom of screen (line 400)
	if (yend1>400)
		yend1=400;
	
	// determine top point
	top=0;
	yval=(long)TVectors[currentpoly->ClippedVectorIndex[0]].y;
	for (i=1;i<numpoints;i++)
	{
		if ((long)TVectors[currentpoly->ClippedVectorIndex[i]].y<yval)
		{
			yval=(long)TVectors[currentpoly->ClippedVectorIndex[i]].y;
			top=i;
		}
	}
	
	currentL=top;
	currentR=top;
	
	xL1=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // start line left
	yL1=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
	zL1=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
	cL1=currentpoly->ClippedLightPoints[currentL].M;
	
	currentL++;
	if (currentL>numpoints-1)
		currentL=0;
	xL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // end line left
	yL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
	zL2=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
	cL2=currentpoly->ClippedLightPoints[currentL].M;
	
	numeratorL=xL2-xL1;
	signL=1;
	denominatorL=yL2-yL1;
	incrementL=denominatorL;
	if (denominatorL!=0)
	{
		inczL=(zL2-zL1)/(MFLOAT)(denominatorL);
		inccL=(cL2-cL1)/denominatorL;
	}
	
	xR1=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // start line right
	yR1=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
	zR1=TVectors[currentpoly->ClippedVectorIndex[currentR]].z;
	cR1=currentpoly->ClippedLightPoints[currentR].M;
	
	currentR--;
	if (currentR<0)
		currentR=numpoints-1;
	xR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // end line right
	yR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
	zR2=TVectors[currentpoly->ClippedVectorIndex[currentR]].z;
	cR2=currentpoly->ClippedLightPoints[currentR].M;
	
	numeratorR=xR2-xR1;
	signR=1;
	denominatorR=yR2-yR1;
	incrementR=denominatorR;
	if (denominatorR!=0)
	{
		inczR=(zR2-zR1)/(MFLOAT)(denominatorR);
		inccR=(cR2-cR1)/denominatorR;
	}
	
	if (numeratorL<0)
	{
		numeratorL=-numeratorL;
		signL=-signL;
	}
	
	if (numeratorR<0)
	{
		numeratorR=-numeratorR;
		signR=-signR;
	} 
	if (yL1<yR1)
		ystart=yL1;
	else
		ystart=yR1;
	
	
	
	while (ystart<yend1)
	{
		
		if (yL2<yR2)
			yend=yL2;
		else
			yend=yR2;
		if (yend>yend1)	// y clipping at maxY(400)
			yend=yend1;
		
		while (ystart<yend)
		{
			DrawSpan2(xL1,xR1,zL1,zR1,ystart,cL1,cR1);
			
			zL1+=inczL;
			zR1+=inczR;
			cL1+=inccL;
			cR1+=inccR;
			incrementL+=numeratorL;
			incrementR+=numeratorR;
			
			while (incrementL>denominatorL)
			{
				xL1+=signL;
				incrementL-=denominatorL;
			} 
			
			while (incrementR>denominatorR)
			{
				xR1+=signR;
				incrementR-=denominatorR;
			}
			ystart++;
		}
		
		if (yend==yL2) // end of left segment, get next line from list
		{
			xL1=xL2;
			yL1=yL2;
			zL1=zL2;
			cL1=cL2;
			
			currentL++;
			if (currentL>numpoints-1)
				currentL=0;
			xL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // end line left
			yL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
			zL2=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
			cL2=currentpoly->ClippedLightPoints[currentL].M;
			
			numeratorL=xL2-xL1;
			signL=1;
			denominatorL=yL2-yL1;
			incrementL=denominatorL;
			if (denominatorL!=0)
			{
				inczL=(zL2-zL1)/(MFLOAT)(denominatorL);
				inccL=(cL2-cL1)/denominatorL;
			}
			else 
			{
				inczL=0;
				inccL=0;
			}
			
			if (numeratorL<0)
			{
				numeratorL=-numeratorL;
				signL=-signL;
			}
		}
		else
		{
			if (yend==yR2)
			{
				xR1=xR2;
				yR1=yR2;
				zR1=zR2;
				cR1=cR2;
				
				
				currentR--;
				if (currentR<0)
					currentR=numpoints-1;
				xR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // end line right
				yR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
				zR2=TVectors[currentpoly->ClippedVectorIndex[currentR]].z;
				cR2=currentpoly->ClippedLightPoints[currentR].M;
				
				numeratorR=xR2-xR1;
				signR=1;
				denominatorR=yR2-yR1;
				incrementR=denominatorR;
				if (denominatorR!=0)
				{
					inczR=(zR2-zR1)/(MFLOAT)(denominatorR);
					inccR=(cR2-cR1)/denominatorR;
				}
				else 
				{
					inczR=0;
					inccR=0;
				}
				
				
				if (numeratorR<0)
				{
					numeratorR=-numeratorR;
					signR=-signR;
				} 
				
			}
		}
 }
}
////////////////////////////////////////////////////////////////////////////////////////////////

void cOBJECT::DrawPoly24(POLYGON *currentpoly)
{
	long signL,xL1,yL1,numeratorL,denominatorL,incrementL;
	long signR,xR1,yR1,numeratorR,denominatorR,incrementR;
	long i,top,yval,currentL,currentR,xL2,yL2,xR2,yR2,ystart,yend,yend1;
	MFLOAT zL1,zR1,zL2,zR2,inczL,inczR; // Z values for left and right point (used for z buffer)

	MFLOAT cLa1,cRa1,cLa2,cRa2,inccaL,inccaR; // light values ,current light left
	MFLOAT cLb1,cRb1,cLb2,cRb2,inccbL,inccbR; // light values ,current light left
	MFLOAT cLc1,cRc1,cLc2,cRc2,incccL,incccR; // light values ,current light left
	
	long numpoints=currentpoly->ClippedNumVectors;
	
	inccaL=0;inccaR=0;
	inccbL=0;inccbR=0;
	incccL=0;incccR=0;

	inczL=0;inczR=0;
	
	// determine bottom point
	yend1=(long)TVectors[currentpoly->ClippedVectorIndex[0]].y;
	for (i=1;i<numpoints;i++)
	{
		if ((long)TVectors[currentpoly->ClippedVectorIndex[i]].y>yend1)
		{
			yend1=(long)TVectors[currentpoly->ClippedVectorIndex[i]].y;
		}
	}
	
	// Clip to bottom of screen (line 400)
	if (yend1>400)
		yend1=400;
	
	// determine top point
	top=0;
	yval=(long)TVectors[currentpoly->ClippedVectorIndex[0]].y;
	for (i=1;i<numpoints;i++)
	{
		if ((long)TVectors[currentpoly->ClippedVectorIndex[i]].y<yval)
		{
			yval=(long)TVectors[currentpoly->ClippedVectorIndex[i]].y;
			top=i;
		}
	}
	
	currentL=top;
	currentR=top;
	
	xL1=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // start line left
	yL1=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
	zL1=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
	cLa1=currentpoly->ClippedLightPoints[currentL].R;
	cLb1=currentpoly->ClippedLightPoints[currentL].G;
	cLc1=currentpoly->ClippedLightPoints[currentL].B;
	
	currentL++;
	if (currentL>numpoints-1)
		currentL=0;
	xL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // end line left
	yL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
	zL2=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
	cLa2=currentpoly->ClippedLightPoints[currentL].R;
	cLb2=currentpoly->ClippedLightPoints[currentL].G;
	cLc2=currentpoly->ClippedLightPoints[currentL].B;
	
	numeratorL=xL2-xL1;
	signL=1;
	denominatorL=yL2-yL1;
	incrementL=denominatorL;
	if (denominatorL!=0)
	{
		inczL=(zL2-zL1)/(MFLOAT)(denominatorL);
		inccaL=(cLa2-cLa1)/denominatorL;
		inccbL=(cLb2-cLb1)/denominatorL;
		incccL=(cLc2-cLc1)/denominatorL;
	}
	
	xR1=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // start line right
	yR1=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
	zR1=TVectors[currentpoly->ClippedVectorIndex[currentR]].z;
	cRa1=currentpoly->ClippedLightPoints[currentR].R;
	cRb1=currentpoly->ClippedLightPoints[currentR].G;
	cRc1=currentpoly->ClippedLightPoints[currentR].B;
	
	currentR--;
	if (currentR<0)
		currentR=numpoints-1;
	xR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // end line right
	yR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
	zR2=TVectors[currentpoly->ClippedVectorIndex[currentR]].z;
	cRa2=currentpoly->ClippedLightPoints[currentR].R;
	cRb2=currentpoly->ClippedLightPoints[currentR].G;
	cRc2=currentpoly->ClippedLightPoints[currentR].B;
	
	numeratorR=xR2-xR1;
	signR=1;
	denominatorR=yR2-yR1;
	incrementR=denominatorR;
	if (denominatorR!=0)
	{
		inczR=(zR2-zR1)/(MFLOAT)(denominatorR);
		inccaR=(cRa2-cRa1)/denominatorR;
		inccbR=(cRb2-cRb1)/denominatorR;
		incccR=(cRc2-cRc1)/denominatorR;
	}
	
	if (numeratorL<0)
	{
		numeratorL=-numeratorL;
		signL=-signL;
	}
	
	if (numeratorR<0)
	{
		numeratorR=-numeratorR;
		signR=-signR;
	} 
	if (yL1<yR1)
		ystart=yL1;
	else
		ystart=yR1;
	
	
	
	while (ystart<yend1)
	{
		
		if (yL2<yR2)
			yend=yL2;
		else
			yend=yR2;
		if (yend>yend1)	// y clipping at maxY(400)
			yend=yend1;
		
		while (ystart<yend)
		{
			if (Alpha==1)
				DrawSpan4(xL1,xR1,zL1,zR1,ystart,cLa1,cRa1,cLb1,cRb1,cLc1,cRc1);
			else
				DrawSpan3(xL1,xR1,zL1,zR1,ystart,cLa1,cRa1,cLb1,cRb1,cLc1,cRc1);
			
			zL1+=inczL;
			zR1+=inczR;

			cLa1+=inccaL;
			cRa1+=inccaR;
			cLb1+=inccbL;
			cRb1+=inccbR;
			cLc1+=incccL;
			cRc1+=incccR;
			incrementL+=numeratorL;
			incrementR+=numeratorR;
			
			while (incrementL>denominatorL)
			{
				xL1+=signL;
				incrementL-=denominatorL;
			} 
			
			while (incrementR>denominatorR)
			{
				xR1+=signR;
				incrementR-=denominatorR;
			}
			ystart++;
		}
		
		if (yend==yL2) // end of left segment, get next line from list
		{
			xL1=xL2;
			yL1=yL2;
			zL1=zL2;
			cLa1=cLa2;
			cLb1=cLb2;
			cLc1=cLc2;
			
			currentL++;
			if (currentL>numpoints-1)
				currentL=0;
			xL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // end line left
			yL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
			zL2=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
			cLa2=currentpoly->ClippedLightPoints[currentL].R;
			cLb2=currentpoly->ClippedLightPoints[currentL].G;
			cLc2=currentpoly->ClippedLightPoints[currentL].B;
			
			numeratorL=xL2-xL1;
			signL=1;
			denominatorL=yL2-yL1;
			incrementL=denominatorL;
			if (denominatorL!=0)
			{
				inczL=(zL2-zL1)/(MFLOAT)(denominatorL);
				inccaL=(cLa2-cLa1)/denominatorL;
				inccbL=(cLb2-cLb1)/denominatorL;
				incccL=(cLc2-cLc1)/denominatorL;
			}
			else 
			{
				inczL=0;
				inccaL=0;
				inccbL=0;
				incccL=0;
			}
			
			if (numeratorL<0)
			{
				numeratorL=-numeratorL;
				signL=-signL;
			}
		}
		else
		{
			if (yend==yR2)
			{
				xR1=xR2;
				yR1=yR2;
				zR1=zR2;
				cRa1=cRa2;
				cRb1=cRb2;
				cRc1=cRc2;
				
				
				currentR--;
				if (currentR<0)
					currentR=numpoints-1;
				xR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // end line right
				yR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
				zR2=TVectors[currentpoly->ClippedVectorIndex[currentR]].z;
				cRa2=currentpoly->ClippedLightPoints[currentR].R;
				cRb2=currentpoly->ClippedLightPoints[currentR].G;
				cRc2=currentpoly->ClippedLightPoints[currentR].B;
				
				numeratorR=xR2-xR1;
				signR=1;
				denominatorR=yR2-yR1;
				incrementR=denominatorR;
				if (denominatorR!=0)
				{
					inczR=(zR2-zR1)/(MFLOAT)(denominatorR);
					inccaR=(cRa2-cRa1)/denominatorR;
					inccbR=(cRb2-cRb1)/denominatorR;
					incccR=(cRc2-cRc1)/denominatorR;
				}
				else 
				{
					inczR=0;
					inccaR=0;
					inccbR=0;
					incccR=0;
				}
				
				
				if (numeratorR<0)
				{
					numeratorR=-numeratorR;
					signR=-signR;
				} 
				
			}
		}
 }
}

////////////////////////////////////////////////////////////////////////////////////////////////


void cOBJECT::DrawPolyZShade(POLYGON *currentpoly)
{
	long signL,xL1,yL1,numeratorL,denominatorL,incrementL;
	long signR,xR1,yR1,numeratorR,denominatorR,incrementR;
	long i,top,yval,currentL,currentR,xL2,yL2,xR2,yR2,ystart,yend,yend1;
	MFLOAT zL1,zR1,zL2,zR2,inczL,inczR; // Z values for left and right point (used for z buffer)
	
	long numpoints=currentpoly->ClippedNumVectors;
	
	inczL=0;inczR=0;
	
	// determine bottom point
	yend1=(long)TVectors[currentpoly->ClippedVectorIndex[0]].y;
	for (i=1;i<numpoints;i++)
	{
		if ((long)TVectors[currentpoly->ClippedVectorIndex[i]].y>yend1)
		{
			yend1=(long)TVectors[currentpoly->ClippedVectorIndex[i]].y;
		}
	}
	// Clip to bottom of screen (line 400)
	if (yend1>400)
		yend1=400;
	
	// determine top point
	top=0;
	yval=(long)TVectors[currentpoly->ClippedVectorIndex[0]].y;
	for (i=1;i<numpoints;i++)
	{
		if ((long)TVectors[currentpoly->ClippedVectorIndex[i]].y<yval)
		{
			yval=(long)TVectors[currentpoly->ClippedVectorIndex[i]].y;
			top=i;
		}
	}
	
	currentL=top;
	currentR=top;
	
	xL1=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // start line left
	yL1=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
	zL1=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
	
	currentL++;
	if (currentL>numpoints-1)
		currentL=0;
	xL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // end line left
	yL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
	zL2=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
	
	numeratorL=xL2-xL1;
	signL=1;
	denominatorL=yL2-yL1;
	incrementL=denominatorL;
	if (denominatorL!=0)
	{
		inczL=(zL2-zL1)/(MFLOAT)(denominatorL);
	}
	
	xR1=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // start line right
	yR1=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
	zR1=TVectors[currentpoly->ClippedVectorIndex[currentR]].z;
	
	currentR--;
	if (currentR<0)
		currentR=numpoints-1;
	xR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // end line right
	yR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
	zR2=TVectors[currentpoly->ClippedVectorIndex[currentR]].z;
	
	numeratorR=xR2-xR1;
	signR=1;
	denominatorR=yR2-yR1;
	incrementR=denominatorR;
	if (denominatorR!=0)
	{
		inczR=(zR2-zR1)/(MFLOAT)(denominatorR);
	}
	
	if (numeratorL<0)
	{
		numeratorL=-numeratorL;
		signL=-signL;
	}
	
	if (numeratorR<0)
	{
		numeratorR=-numeratorR;
		signR=-signR;
	} 
	if (yL1<yR1)
		ystart=yL1;
	else
		ystart=yR1;
	
	
	
	while (ystart<yend1)
	{
		
		if (yL2<yR2)
			yend=yL2;
		else
			yend=yR2;
		if (yend>yend1)	// y clipping at maxY(400)
			yend=yend1;
		
		while (ystart<yend)
		{
			DrawSpan(xL1,xR1,zL1,zR1,ystart);
			
			zL1+=inczL;
			zR1+=inczR;
			incrementL+=numeratorL;
			incrementR+=numeratorR;
			
			while (incrementL>denominatorL)
			{
				xL1+=signL;
				incrementL-=denominatorL;
			} 
			
			while (incrementR>denominatorR)
			{
				xR1+=signR;
				incrementR-=denominatorR;
			}
			ystart++;
		}
		
		if (yend==yL2) // end of left segment, get next line from list
		{
			xL1=xL2;
			yL1=yL2;
			zL1=zL2;
			
			currentL++;
			if (currentL>numpoints-1)
				currentL=0;
			xL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].x; // end line left
			yL2=(long)TVectors[currentpoly->ClippedVectorIndex[currentL]].y;
			zL2=TVectors[currentpoly->ClippedVectorIndex[currentL]].z;
			
			numeratorL=xL2-xL1;
			signL=1;
			denominatorL=yL2-yL1;
			incrementL=denominatorL;
			if (denominatorL!=0)
			{
				inczL=(zL2-zL1)/(MFLOAT)(denominatorL);
			}
			else 
			{
				inczL=0;
			}
			
			if (numeratorL<0)
			{
				numeratorL=-numeratorL;
				signL=-signL;
			}
		}
		else
		{
			if (yend==yR2)
			{
				xR1=xR2;
				yR1=yR2;
				zR1=zR2;
				
				
				currentR--;
				if (currentR<0)
					currentR=numpoints-1;
				xR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].x; // end line right
				yR2=(long)TVectors[currentpoly->ClippedVectorIndex[currentR]].y;
				zR2=TVectors[currentpoly->ClippedVectorIndex [currentR]].z;
				
				numeratorR=xR2-xR1;
				signR=1;
				denominatorR=yR2-yR1;
				incrementR=denominatorR;
				if (denominatorR!=0)
				{
					inczR=(zR2-zR1)/(MFLOAT)(denominatorR);
				}
				else 
				{
					inczR=0;
				}
				
				
				if (numeratorR<0)
				{
					numeratorR=-numeratorR;
					signR=-signR;
				} 
				
			}
		}
		
 }
}



////////////////////////////////////////////////////////////////////////////////////////////////
// Clipping routine 

void cOBJECT::clipx(POLYGON *poly,VECTOR *TVectors,long v1,long v2,long current,long xclip)
{
	MFLOAT x1=TVectors[poly->VectorIndex[v1]].x,y1=TVectors[poly->VectorIndex[v1]].y;
	MFLOAT x2=TVectors[poly->VectorIndex[v2]].x,y2=TVectors[poly->VectorIndex[v2]].y;
	MFLOAT z1=TVectors[poly->VectorIndex[v1]].z,z2=TVectors[poly->VectorIndex[v2]].z;
	long  l1=poly->LightPoints[v1].M,l2=poly->LightPoints[v2].M;
	
	// Adjust light value
	poly->ClippedLightPoints[current].M=(unsigned char) ((MFLOAT)l1+(xclip-x1)*(l2-l1)/(x2-x1));
	
	// Allocate new temp vector for clipping
	poly->ClippedVectorIndex[current]=NumVectorsT;
	TVectors[NumVectorsT].x=(MFLOAT)xclip;
	TVectors[NumVectorsT].y=(MFLOAT)y1+(xclip-x1)*(y2-y1)/(x2-x1);
	TVectors[NumVectorsT].z=(MFLOAT)z1+(xclip-x1)*(z2-z1)/(x2-x1);
	NumVectorsT++;
}

long cOBJECT::Clipper2(POLYGON *poly,VECTOR *TVectors, long minx,long maxx,long miny)
{
	long v1,v2;
	int i;
	long current=0;
	
	v1=poly->NumVectors-1;
	v2=0;
	for (i=0;i<poly->NumVectors;i++)
	{
		if (TVectors[poly->VectorIndex[v1]].x>minx)
		{
			if (TVectors[poly->VectorIndex[v2]].x>minx)
			{
				
				if (TVectors[poly->VectorIndex[v1]].x<maxx)
				{
					if (TVectors[poly->VectorIndex[v2]].x<maxx)
					{
						poly->ClippedVectorIndex[current]=poly->VectorIndex[v1];
						poly->ClippedLightPoints[current]=poly->LightPoints[v1];
						current++;
					}
					else
					{
						poly->ClippedVectorIndex[current]=poly->VectorIndex[v1];
						poly->ClippedLightPoints[current]=poly->LightPoints[v1];
						current++;
						clipx(poly,TVectors,v1,v2,current,maxx);
						current++;
					}
				}
				else
				{
					if (TVectors[poly->VectorIndex[v2]].x<maxx)
					{
						clipx(poly,TVectors,v1,v2,current,maxx);
						current++;
					}
				}  
				
			}
			else
			{
				poly->ClippedVectorIndex[current]=poly->VectorIndex[v1];
				poly->ClippedLightPoints[current]=poly->LightPoints[v1];
				current++;
				clipx(poly,TVectors,v1,v2,current,0);
				current++;
			}
		}
		else
		{
			if (TVectors[poly->VectorIndex[v2]].x>minx)
			{
				if (TVectors[poly->VectorIndex[v2]].x>maxx)
				{
					clipx(poly,TVectors,v1,v2,current,maxx);
					current++;
				}
				clipx(poly,TVectors,v1,v2,current,0);
				current++;
				
			}
		}  
		
		v1=v2;
		v2++;
	}
	
	
	poly->ClippedNumVectors=current;
	return 0;
}
////////////////////////////////////////////////////////////////////////////////////////////////

cOBJECT::cOBJECT()
{
	NumPolygons=0;
	NumVectors=0;
	Polygons=NULL;
	Vectors=NULL;
	RVectors=NULL;
	TVectors=NULL;
	CX=0;CY=0;CZ=0;BR=0;
	ScaleFactor=1;
}

long cOBJECT::InitTransform()
{
	int i;
	for(i=0;i<NumVectors;i++)
	{
		RVectors[i].x=0;
		RVectors[i].y=0;
		RVectors[i].z=0;
	}
	return 0;
}

long cOBJECT::RotateXYZ(MFLOAT AngleXZ,MFLOAT AngleYZ,MFLOAT AngleXY,long Status)
{
	int i;
	MFLOAT sinXZ,cosXZ,sinYZ,cosYZ,sinXY,cosXY,
		TX,TY,TZ,TZ2,TX3,TY3;
	
	if (Status==INIT)
	{
		sinXZ=(MFLOAT)sin(AngleXZ);
		cosXZ=(MFLOAT)cos(AngleXZ);
		sinYZ=(MFLOAT)sin(AngleYZ);
		cosYZ=(MFLOAT)cos(AngleYZ);
		sinXY=(MFLOAT)sin(AngleXY);
		cosXY=(MFLOAT)cos(AngleXY);
		
		for(i=0;i<NumVectors;i++)
		{
			TX=Vectors[i].x*ScaleFactor*cosXZ+Vectors[i].z*ScaleFactor*sinXZ;
			TZ=-Vectors[i].x*ScaleFactor*sinXZ+Vectors[i].z*ScaleFactor*cosXZ;
			
			TY=Vectors[i].y*ScaleFactor*cosYZ+TZ*sinYZ;
			TZ2=-Vectors[i].y*ScaleFactor*sinYZ+TZ*cosYZ;
			
			TX3=TX*cosXY+TY*sinXY;
			TY3=-TX*sinXY+TY*cosXY;
			RVectors[i].x=TX3;
			RVectors[i].y=TY3;
			RVectors[i].z=TZ2;
		}
	}
	return 0;
}

long cOBJECT::Read3DO(char *filename)
{
	char buffer[500];		// temp field buffer
	char *bufferptr=&buffer[0];
	POLYGON *polylist;              // temp object buffer 
	long currentpoly=0;              // current polygon number
	long *vectorindexlist;
	long TextureID;
	FRAMECOMPONENT *FrameComponentList;
	cFRAMECOMPONENTTYPE *FrameComponentTypeList;
	VECTOR *tempvectorlist;
	fstream reader;
	int i=0,num,polynum,t,vect;
	MFLOAT x,y,z;
	long NumComponents;
	
	long NumStates;
	long ComponentNum,NumPolygonsComponent;
	
	// Allocate a large amount of tempory memory for loading of object
	vectorindexlist=new long[cMaxSides];
	tempvectorlist=new VECTOR[cMaxVectors];
	polylist=new POLYGON[cMaxFaces];
	FrameComponentList=new FRAMECOMPONENT[cMaxFaces];
	FrameComponentTypeList=new cFRAMECOMPONENTTYPE[cMaxComponentTypes];
	
	// Open File, read ahead
	reader.open(filename,ios::in);
	reader >>buffer;
	
	// Read vectors (allways stored at begining of file)
	while (i<cMaxVectors && strcmp(bufferptr,(char *)"DYN_POLYGON")!=0 )
	{
		if (strcmp(bufferptr,(char *)"DYN_VERTEX")==0 )	// Ignore unwanted information
		{
			reader >> num;
			reader >> x;
			reader >> y;
			reader >> z;
			tempvectorlist[i].x=x*ReadScale;
			tempvectorlist[i].y=y*ReadScale;
			tempvectorlist[i].z=z*ReadScale;
			i++;
		}
		reader >>buffer;
		if (!reader)
			break;
	}
	
	NumVectors=i;	// Store total number of vectors
	
	i=0;
	polynum=0;
	int sides;
	NumComponents=0;
	
	// Read polygon information
	while (i<cMaxFaces)     // Get polygon information
	{
		
		if (strcmp(bufferptr,(char *)"FRAMESTATE")==0)
		{
			reader>>ComponentNum;
			reader>>NumStates;
			FrameComponentTypeList[ComponentNum].CurrentState=0;
			FrameComponentTypeList[ComponentNum].FrameType=new long[NumStates];
			FrameComponentTypeList[ComponentNum].NumStates=NumStates;
			FrameComponentTypeList[ComponentNum].Start=new FRAMECOMPONENTSTATE[NumStates];
			FrameComponentTypeList[ComponentNum].End=new FRAMECOMPONENTSTATE[NumStates];
			for (t=0;t<NumStates;t++)
			{
				reader >>FrameComponentTypeList[ComponentNum].FrameType[t];
				reader >>FrameComponentTypeList[ComponentNum].Start[t].ox;
				reader >>FrameComponentTypeList[ComponentNum].Start[t].oy;
				reader >>FrameComponentTypeList[ComponentNum].Start[t].oz;
				reader >>FrameComponentTypeList[ComponentNum].Start[t].dx;
				reader >>FrameComponentTypeList[ComponentNum].Start[t].dy;
				reader >>FrameComponentTypeList[ComponentNum].Start[t].dz;
				
				reader >>FrameComponentTypeList[ComponentNum].End[t].ox;
				reader >>FrameComponentTypeList[ComponentNum].End[t].oy;
				reader >>FrameComponentTypeList[ComponentNum].End[t].oz;
				reader >>FrameComponentTypeList[ComponentNum].End[t].dx;
				reader >>FrameComponentTypeList[ComponentNum].End[t].dy;
				reader >>FrameComponentTypeList[ComponentNum].End[t].dz;
			}
		}
		if (strcmp(bufferptr,(char *)"FRAMECOMPONENT")==0)
		{
			NumComponents++;
			reader >>ComponentNum;
			reader >>NumPolygonsComponent;
			
			FrameComponentList[ComponentNum].PolygonList=new unsigned long[NumPolygonsComponent];
			FrameComponentList[ComponentNum].NumPolygons=NumPolygonsComponent;
			for (t=0;t<NumPolygonsComponent;t++)
			{
				reader>>FrameComponentList[ComponentNum].PolygonList[t];
			}
		}
		
		// Load polygon data	
		if (strcmp(bufferptr,(char *)"DYN_POLYGON")==0 )
		{
			
			reader >> num;		// FORMAT: poly number,number of sides(n),vector*n,
			// RGB lighting values+texture coordinates*n 
			reader >> sides;
			
			polylist[currentpoly].NumVectors=sides;
			polylist[currentpoly].VectorIndex=new long[sides];
			polylist[currentpoly].ClippedVectorIndex=new long[sides*2];
			
			for (t=0;t<sides;t++)
			{
				reader >> vect;
				polylist[currentpoly].VectorIndex[t]=vect;
			}
			
			polylist[currentpoly].LightPoints=new LIGHT[sides];
			polylist[currentpoly].TexturePoints=new TEXTUREXY[sides];
			polylist[currentpoly].ClippedLightPoints=new LIGHT[sides*2];
			polylist[currentpoly].ClippedTexturePoints=new TEXTUREXY[sides*2];
			
			for (t=0;t<sides;t++)
			{			// read RGB/Texture value for each vertex, convert and store mono value
				
				// colour information
				long r,g,b;
				reader >> r;
				reader >> g;
				reader >> b;
				polylist[currentpoly].LightPoints[t].R=(unsigned char)r;
				polylist[currentpoly].LightPoints[t].G=(unsigned char)g;
				polylist[currentpoly].LightPoints[t].B=(unsigned char)b;
				polylist[currentpoly].LightPoints[t].M=( (polylist[currentpoly].LightPoints[t].R +
					polylist[currentpoly].LightPoints[t].G + polylist[currentpoly].LightPoints[t].B)/3);
				
				// Texture coordinates for each vertex
				reader >> polylist[currentpoly].TexturePoints[t].TX;
				reader >> polylist[currentpoly].TexturePoints[t].TY;
				
			}
			
			// Load texture number for that polygon
			reader >> TextureID;
			polylist[currentpoly].TextureID=TextureID;
			currentpoly++;
		}
		reader >> buffer;
		if (!reader)		// If end of file --
			break;
	}
	
	// Allocate using list to the exact static size and copy from loader memory
	NumPolygons=currentpoly;
	Polygons= new POLYGON[currentpoly];
	TVectors= new VECTOR[NumVectors+NumVectors];
	RVectors= new VECTOR[NumVectors];
	Vectors= new VECTOR[NumVectors];
	for (t=0;t<NumVectors;t++)
		Vectors[t]=tempvectorlist[t];
	
	for (t=0;t<currentpoly;t++)
		Polygons[t]=polylist[t];
	
	Frame.ComponentList=new FRAMECOMPONENT[NumComponents];
	Frame.ComponentStates=new cFRAMECOMPONENTTYPE[NumComponents];
	Frame.NumComponents=NumComponents;
	for (t=0;t<NumComponents;t++)
	{
		Frame.ComponentStates[t]=FrameComponentTypeList[t];
		Frame.ComponentList[t]=FrameComponentList[t];
	}
	
	
	
	// De-allocate memory
	delete FrameComponentList;
	delete FrameComponentTypeList;
	delete vectorindexlist;
	delete tempvectorlist;
	delete polylist;
	
	return 0; // No error checking yet
}

void cOBJECT::Write3DO(char *filename)
{
	fstream reader;
	int i=0,t;
	POLYGON *currentpoly=NULL;
	
	reader.open(filename,ios::out);
	
	// Write unnessary define data
	reader <<"DEFINE DYNA_VERTEX "<<NumVectors<<endl;
	reader <<"DEFINE DYNA_POLYGON "<<NumPolygons<<endl;
	
	// Write all Vectors
	for (i=0;i<NumVectors;i++)
	{
		reader << "CLASS DYN_VERTEX ";
		reader << i<< " ";
		reader << Vectors[i].x/ReadScale << " ";
		reader << Vectors[i].y/ReadScale << " ";
		reader << Vectors[i].z/ReadScale << endl;
	}
	
	// Write All polygon information
	for(i=0;i<NumPolygons;i++)
	{
		reader << "CLASS DYN_POLYGON " << i << " ";
		currentpoly=&Polygons[i];
		reader << currentpoly->NumVectors ;
		for(t=0;t<currentpoly->NumVectors;t++)
		{
			reader <<" "<< currentpoly->VectorIndex[t];
		}
		
		for(t=0;t<currentpoly->NumVectors;t++)
		{
			reader <<" "<< (long)currentpoly->LightPoints[t].R
				<<" "<< (long)currentpoly->LightPoints[t].G
				<<" "<< (long)currentpoly->LightPoints[t].B
				<<" "<< currentpoly->TexturePoints[t].TX 
				<<" "<< currentpoly->TexturePoints[t].TY ;
		}
		reader <<" "<<currentpoly->TextureID<<endl; // Texture number 
	}
	
	// Write Component information
	for(t=0;t<Frame.NumComponents;t++)
	{
		reader <<"CLASS FRAMECOMPONENT "<<t
			<<" "<<Frame.ComponentList[t].NumPolygons;
		for(i=0;i<Frame.ComponentList[t].NumPolygons;i++)
		{
			reader << " "<<Frame.ComponentList[t].PolygonList[i];
		}
		reader <<endl;
	}
	
	// Write component animation data
	for(i=0;i<Frame.NumComponents;i++)
	{
		reader <<"CLASS FRAMESTATE "<<i
			<<" "<<Frame.ComponentStates[i].NumStates;
		for(t=0;t<Frame.ComponentStates[i].NumStates;t++)
		{
			reader<<" "<<Frame.ComponentStates[i].FrameType[t]
				<<" "<<Frame.ComponentStates[i].Start[t].ox
				<<" "<<Frame.ComponentStates[i].Start[t].oy
				<<" "<<Frame.ComponentStates[i].Start[t].oz
				<<" "<<Frame.ComponentStates[i].Start[t].dx
				<<" "<<Frame.ComponentStates[i].Start[t].dy
				<<" "<<Frame.ComponentStates[i].Start[t].dz
				
				<<" "<<Frame.ComponentStates[i].End[t].ox
				<<" "<<Frame.ComponentStates[i].End[t].oy
				<<" "<<Frame.ComponentStates[i].End[t].oz
				<<" "<<Frame.ComponentStates[i].End[t].dx
				<<" "<<Frame.ComponentStates[i].End[t].dy
				<<" "<<Frame.ComponentStates[i].End[t].dz;
		}
		reader <<endl;
	}
	
	reader.close();
}

void cOBJECT::PlotObjectZShade()
{
	MFLOAT DX1,DX2,DY1,DY2;
	CurrentPolyNum=0;
	// POLYGON *currentpoly;
	
	NumVectorsT=NumVectors;
	while (CurrentPolyNum<NumPolygons)
	{
		CurrentPoly=&Polygons[CurrentPolyNum];
		
		// Determine if vieable by clockwise/anitclockwise detection (back face culling)
		DX1=TVectors[CurrentPoly->VectorIndex[1]].x-TVectors[CurrentPoly->VectorIndex[0]].x;
		DX2=TVectors[CurrentPoly->VectorIndex[2]].x-TVectors[CurrentPoly->VectorIndex[1]].x;
		DY1=TVectors[CurrentPoly->VectorIndex[1]].y-TVectors[CurrentPoly->VectorIndex[0]].y;
		DY2=TVectors[CurrentPoly->VectorIndex[2]].y-TVectors[CurrentPoly->VectorIndex[1]].y;
		if( (DX1*DY2-DX2*DY1) <0) 					// If visible then display
		{
			Clipper2(CurrentPoly,TVectors,0,320,0);
			if(CurrentPoly->ClippedNumVectors>2)
			{
				DrawPolyZShade(CurrentPoly);
			}
		}
		
		CurrentPolyNum++;
	}
	
}

// Do perspective translation
void cOBJECT::TranslateVectors(long centerx, long centery)
{
	MFLOAT Z;
	long i;
	
	for(i=0;i<NumVectors;i++)
	{
		Z=( (MFLOAT)(400/(RVectors[i].z-1024)) );
		TVectors[i].x= ( (MFLOAT)centerx+(RVectors[i].x*Z) ); //x+256/z
		TVectors[i].y= ( (MFLOAT)centery+(RVectors[i].y*Z) ); //x+256/z
		TVectors[i].z=1/((MFLOAT)RVectors[i].z-1024);
	}
}

void cOBJECT::PlotObjectTexture()
{
	MFLOAT DX1,DX2,DY1,DY2;
	MFLOAT Z;
	int t;
	VertexTYPE *tempver;
	NumVectorsT=NumVectors;
	
	CurrentPolyNum=0;
	while (CurrentPolyNum<NumPolygons)
	{
		CurrentPoly=&Polygons[CurrentPolyNum];
		
		// Determine if vieable by clockwise/anitclockwise detection (back face culling)
		DX1=TVectors[CurrentPoly->VectorIndex[1]].x-TVectors[CurrentPoly->VectorIndex[0]].x;
		DX2=TVectors[CurrentPoly->VectorIndex[2]].x-TVectors[CurrentPoly->VectorIndex[1]].x;
		DY1=TVectors[CurrentPoly->VectorIndex[1]].y-TVectors[CurrentPoly->VectorIndex[0]].y;
		DY2=TVectors[CurrentPoly->VectorIndex[2]].y-TVectors[CurrentPoly->VectorIndex[1]].y;
		if( (DX1*DY2-DX2*DY1) <0) 					// If visible then display
		{
			Clipper2(CurrentPoly,TVectors,0,320,0);
			if(CurrentPoly->ClippedNumVectors>2)
			{
				tempver= new VertexTYPE[CurrentPoly->ClippedNumVectors];
				for(t=0;t<CurrentPoly->ClippedNumVectors;t++)
				{
					tempver[t].sx=TVectors[CurrentPoly->ClippedVectorIndex[t]].x;
					tempver[t].sy=TVectors[CurrentPoly->ClippedVectorIndex[t]].y;
					tempver[t].u=CurrentPoly->TexturePoints[t].TX;
					tempver[t].v=CurrentPoly->TexturePoints[t].TY;
				}
				Z=TVectors[CurrentPoly->ClippedVectorIndex[0]].z;
				TextureFacePlot(GlobalTextures[CurrentPoly->TextureID].TexturePtr,&tempver[0],CurrentPoly->ClippedNumVectors,256,Z);
			}
		}
		
		CurrentPolyNum++;
	}
	
}


void cOBJECT::PlotObjectShaded()
{
	MFLOAT DX1,DX2,DY1,DY2;
	int currentvectors;
	//POLYGON *currentpoly;
	
	CurrentPolyNum=0;
	NumVectorsT=NumVectors;
	while (CurrentPolyNum<NumPolygons)
	{
		CurrentPoly=&Polygons[CurrentPolyNum];
		currentvectors=CurrentPoly->NumVectors;
		
		// Determine if vieable by clockwise/anitclockwise detection (back face culling)
		DX1=TVectors[CurrentPoly->VectorIndex[1]].x-TVectors[CurrentPoly->VectorIndex[0]].x;
		DX2=TVectors[CurrentPoly->VectorIndex[2]].x-TVectors[CurrentPoly->VectorIndex[1]].x;
		DY1=TVectors[CurrentPoly->VectorIndex[1]].y-TVectors[CurrentPoly->VectorIndex[0]].y;
		DY2=TVectors[CurrentPoly->VectorIndex[2]].y-TVectors[CurrentPoly->VectorIndex[1]].y;
		if( (DX1*DY2-DX2*DY1) <0) 					// If visible then display
		{
			// copy vectors for clipping
			
			Clipper2(CurrentPoly,TVectors,0,320,0);
			// Ignore lines+points
			if(CurrentPoly->ClippedNumVectors>2)
			{
				ZZ=TVectors[CurrentPoly->ClippedVectorIndex[0]].z;
				DrawPoly(CurrentPoly);
			}
		}
		
		CurrentPolyNum++;
	}
}

void cOBJECT::PlotObjectShaded24()
{
	MFLOAT DX1,DX2,DY1,DY2;
	int currentvectors;
	//POLYGON *currentpoly;
	
	CurrentPolyNum=0;
	NumVectorsT=NumVectors;
	while (CurrentPolyNum<NumPolygons)
	{
		CurrentPoly=&Polygons[CurrentPolyNum];
		currentvectors=CurrentPoly->NumVectors;
		
		// Determine if vieable by clockwise/anitclockwise detection (back face culling)
		DX1=TVectors[CurrentPoly->VectorIndex[1]].x-TVectors[CurrentPoly->VectorIndex[0]].x;
		DX2=TVectors[CurrentPoly->VectorIndex[2]].x-TVectors[CurrentPoly->VectorIndex[1]].x;
		DY1=TVectors[CurrentPoly->VectorIndex[1]].y-TVectors[CurrentPoly->VectorIndex[0]].y;
		DY2=TVectors[CurrentPoly->VectorIndex[2]].y-TVectors[CurrentPoly->VectorIndex[1]].y;
		if( (DX1*DY2-DX2*DY1) <0) 					// If visible then display
		{
			// copy vectors for clipping
//			dale <<"Clipper"<<endl;
			Clipper2(CurrentPoly,TVectors,0,320,0);
			// Ignore lines+points
			if(CurrentPoly->ClippedNumVectors>2)
			{
				ZZ=TVectors[CurrentPoly->ClippedVectorIndex[0]].z;
				DrawPoly24(CurrentPoly);
			}
		}
		
		CurrentPolyNum++;
	}
}


long cOBJECT::Scale(MFLOAT factor)
{
	int i;
	for(i=0;i<NumVectors;i++)
	{
		Vectors[i].x=Vectors[i].x*factor;
		Vectors[i].y=Vectors[i].y*factor;
		Vectors[i].z=Vectors[i].z*factor;
	}
	return 0;
}

cOBJECT::~cOBJECT()
{
	if (Vectors!=NULL)
		delete Vectors;
	if (RVectors!=NULL)
		delete RVectors;
	if (TVectors!=NULL)
		delete TVectors;
}