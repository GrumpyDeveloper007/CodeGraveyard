#include <fstream.h>

#include <go32.h>
#include <dpmi.h>
#include <sys/movedata.h>


#include <dos.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
//Some key definitions if you want to control it in real time

#define CR 13
#define UP    328
#define DOWN  336
#define LEFT  331
#define RIGHT 333


#define SCRX 320
#define SCRY 400
#define HSCRX (SCRX/2)
#define HSCRY (SCRY/2)  
int colour;
int starti,startj;
const centerx=160;
const centery=200;

typedef struct 
 {
 int x1,y1;
 int x2,y2;
 int x3,y3;
 char colour;
 } Poly;

int x1x,y1y;
int x2x,y2y;
int x3x,y3y;
float angle;

long Hex[8*2];
long HexPoints;
long HexT[8*2];

long NumVectors;
float VectorList[200*3];
float VectorListR[200*3];
long VectorListT[200*3];
long NumFaces;
long FaceList[200*6]; // space for 200 4 sided objects
// face list (really object list) format
// -num points
// -points(n*)
// -colour

Poly aa,bb,cc;
char *ScreenPtr;

//  Cm=(currenty-Ytop)/(Yright-Ytop) * (Zright-Ztop)+Ztop;
//  Cn=(currenty-Ytop)/(Yleft-Ytop) * (Zleft-Ztop)+Ztop;
//  for (int i=ScanBuffer[j*3+1];i<=ScanBuffer[j*3+2];i++,vidoffset++)
//   {
//   CP=((long double)(i-start)/(end-start)) * (Cm-Cn)+Cn;
//
////////////////////////////////////////////////////////////////////////////////////////////////
void ReadData()
 {
 fstream DataFile;
 long numfaces;
 long x,y,z;
 long colour;
 DataFile.open("box.dat",ios::in);
 DataFile >> numfaces;
 while (numfaces!=0)
  { 
  FaceList[NumFaces]=numfaces;
  NumFaces++;
  while (numfaces!=0)
   {
   DataFile >> x >> y >> z;
   VectorList[NumVectors*3]=x;
   VectorList[NumVectors*3+1]=y;
   VectorList[NumVectors*3+2]=z;
   FaceList[NumFaces]=NumVectors;
   NumFaces++;
   NumVectors++;
   numfaces--;
   }
  DataFile >> colour;
  FaceList[NumFaces]=colour;
  NumFaces++;
  DataFile >> numfaces;
  }
 }

void DrawPoly(char *screenptr,int numpoints,long *points,char pix);

void PlotData(long *VectorListA )
 {
 int i=0,tempfaces,t,colour;
 long Points2D[20*2];

 while (i<NumFaces)
  {
  tempfaces=FaceList[i];
  i++;

  for(t=0;t<tempfaces;t++)
   {
   Points2D[t*2]=VectorListA[FaceList[i]*3];
   Points2D[t*2+1]=VectorListA[FaceList[i]*3+1];
   i++;
   }
  colour=FaceList[i];
  i++;
  DrawPoly(ScreenPtr,tempfaces,Points2D,colour);
  }

 }

//************************************************************************
// Your initialisation routine
// Will be called before switch to graphics mode so you can use 
// text input for setup
void initialise()
{
ReadData();
Hex[0]=30;Hex[1]=0;
Hex[2]=50;Hex[3]=0;
Hex[4]=70;Hex[5]=20;
Hex[6]=70;Hex[7]=40;
Hex[8]=50;Hex[9]=60;
Hex[10]=30;Hex[11]=60;
Hex[12]=10;Hex[13]=40;
Hex[14]=10;Hex[15]=20;
HexPoints=8;

bb.x1=100;bb.y1=10;
bb.x2=71;bb.y2=80;
bb.x3=50;bb.y3=50;
bb.colour=64;

aa.x1=100;aa.y1=10;
aa.x2=70;aa.y2=80;
aa.x3=50;aa.y3=50;
aa.colour=64;
x1x=1;y1y=1;
x2x=1;y2y=1;
x3x=1;y3y=1;
angle=0;

starti=10;
startj=10;
colour=60;
	starti+=288;
	startj+=347;
	startj%=347;//Keep it on the screen
	starti%=288;

	colour+=128; //keep colour positive
	colour%=128;  //and in range
	

}
//********************************************************************************************************

void DrawSpan(int startx,int endx,int y,char pix)
 {
 static char *SpanPtr;
 int x;
 SpanPtr=ScreenPtr+y*320;
  if (startx>endx)
   {
   *(char *)(SpanPtr)=pix;
   for (x=endx;x<=startx;x++)
     *(char *)(SpanPtr+x)=pix;
   }
  
 for (x=startx;x<=endx;x++)
   *(char *)(SpanPtr+x)=pix;

 }

void DrawPoly3(char *screenptr,int x1,int y1,int x2,int y2,int x3,int y3,char pix)
 {
 int signL,xL,yL,numeratorL,denominatorL,incrementL;
 int signR,xR,yR,numeratorR,denominatorR,incrementR;

 // determine point order

 if (y2<y1 && y3>y2)
  {
  xL=x1;yL=y1;
  x1=x2;y1=y2;
  x2=x3;y2=y3;
  x3=xL;y3=yL;
  }
 if (y3<y1 && y2>=y3)
  {
  xL=x1;yL=y1;
  x1=x3;y1=y3;
  x3=x2;y3=y2;
  x2=xL;y2=yL;
  }

  xL=x1;
  numeratorL=x3-x1;
  signL=1;
  denominatorL=y3-y1;
  incrementL=denominatorL;

  xR=x1;
  numeratorR=x2-x1;
  signR=1;
  denominatorR=y2-y1;
  incrementR=denominatorR;

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

 // determine if left finish first or  right finish first

 if (y3<y2)
  { // left first

  for (yL=y1;yL<y3;yL++)
   {
   DrawSpan(xL,xR,yL,pix);

   incrementL+=numeratorL;
   incrementR+=numeratorR;

   while (incrementL>denominatorL)
    {
    xL+=signL;
    incrementL-=denominatorL;
    } 

   while (incrementR>denominatorR)
    {
    xR+=signR;
    incrementR-=denominatorR;
    }
   }

  // draw 2-3 and second segment of 1-3 
  xL=x3;
  numeratorL=x2-x3;
  signL=1;
  denominatorL=y2-y3;
  incrementL=denominatorL;

  if (numeratorL<0)
   {
   numeratorL=-numeratorL;
   signL=-signL;
   }

  for (yL=y3;yL<y2;yL++)
   {
   DrawSpan(xL,xR,yL,pix);
   incrementL+=numeratorL;
   incrementR+=numeratorR;

   while (incrementL>denominatorL)
    {
    xL+=signL;
    incrementL-=denominatorL;
    } 

   while (incrementR>denominatorR)
    {
    xR+=signR;
    incrementR-=denominatorR;
    }
   }

  }
 else
  { // right first

  for (yL=y1;yL<y2;yL++)
   {
   DrawSpan(xL,xR,yL,pix);
   incrementL+=numeratorL;
   incrementR+=numeratorR;

   while (incrementL>denominatorL)
    {
    xL+=signL;
    incrementL-=denominatorL;
    } 

   while (incrementR>denominatorR)
    {
    xR+=signR;
    incrementR-=denominatorR;
    }
   }

  // draw 2-3 and second segment of 1-3 

  xR=x2;
  numeratorR=x3-x2;
  signR=1;
  denominatorR=y3-y2;
  incrementR=denominatorR;

  if (numeratorR<0)
   {
   numeratorR=-numeratorR;
   signR=-signR;
   }

  for (yL=y2;yL<y3;yL++)
   {
   DrawSpan(xL,xR,yL,pix);
   incrementL+=numeratorL;
   incrementR+=numeratorR;

   while (incrementL>denominatorL)
    {
    xL+=signL;
    incrementL-=denominatorL;
    } 
   while (incrementR>denominatorR)
    {
    xR+=signR;
    incrementR-=denominatorR;
    }
   }
  }
 }


void DrawPoly(char *screenptr,int numpoints,long *points,char pix)
 {
 int signL,xL1,yL1,numeratorL,denominatorL,incrementL;
 int signR,xR1,yR1,numeratorR,denominatorR,incrementR;
 int i,top,yval,currentL,currentR,xL2,yL2,xR2,yR2,ystart,yend,yend1;


 // determine bottom point
 yend1=points[0+1];
 for (i=1;i<numpoints;i++)
  {
  if (points[i*2+1]>yend1)
    {
    yend1=points[i*2+1];
    }
  }
 if (yend1>400)
  yend1=400;

 // determine top point
 top=0;
 yval=points[0+1];
 for (i=1;i<numpoints;i++)
  {
  if (points[i*2+1]<yval)
    {
    yval=points[i*2+1];
    top=i;
    }
  }

 currentL=top;
 currentR=top;

 // check bounds of array
 if (currentL<0)
   currentL=numpoints-1;
 xL1=points[currentL*2]; // start line left
 yL1=points[currentL*2+1];

 currentL--;
 if (currentL<0)
   currentL=numpoints-1;
 xL2=points[currentL*2]; // end line left
 yL2=points[currentL*2+1];

  numeratorL=xL2-xL1;
  signL=1;
  denominatorL=yL2-yL1;
  incrementL=denominatorL;

 if (currentR>numpoints-1)
   currentR=0;
 xR1=points[currentR*2]; // start line right
 yR1=points[currentR*2+1];

 currentR++;
 if (currentR>numpoints-1)
   currentR=0;
 xR2=points[currentR*2]; // end line right
 yR2=points[currentR*2+1];

  numeratorR=xR2-xR1;
  signR=1;
  denominatorR=yR2-yR1;
  incrementR=denominatorR;

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

  while (ystart<yend)
   {
   DrawSpan(xL1,xR1,ystart,pix);

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

   currentL--;
   if (currentL<0)
     currentL=numpoints-1;
   xL2=points[currentL*2]; // end line left
   yL2=points[currentL*2+1];

   numeratorL=xL2-xL1;
   signL=1;
   denominatorL=yL2-yL1;
   incrementL=denominatorL;

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

   currentR++;
   if (currentR>numpoints-1)
     currentR=0;
   xR2=points[currentR*2]; // end line right
   yR2=points[currentR*2+1];

   numeratorR=xR2-xR1;
   signR=1;
   denominatorR=yR2-yR1;
   incrementR=denominatorR;
   if (numeratorR<0)
    {
    numeratorR=-numeratorR;
    signR=-signR;
    } 

   }
   }

  }
 }


void PlotPoly(Poly aa)
 {
 DrawPoly3(ScreenPtr,aa.x1,aa.y1, aa.x2,aa.y2, aa.x3,aa.y3, aa.colour);
 *(char *)(ScreenPtr+aa.x1+aa.y1*320)=127;
 *(char *)(ScreenPtr+aa.x2+aa.y2*320)=127;
 *(char *)(ScreenPtr+aa.x3+aa.y3*320)=127;
 }



void TranslateVectors()
 {
 int i;
 
 for(i=0;i<NumVectors;i++)
  {
  VectorListT[i*3+2]=(long) ( (float)(VectorListR[i*3+2]/90) );
  VectorListT[i*3]=(long) ( (float)centerx+(VectorListR[i*3]*VectorListT[i*3+2]) ); //x+256/z
  VectorListT[i*3+1]=(long) ( (float)centery+(VectorListR[i*3+1]*-VectorListT[i*3+2]) ); //x+256/z
  }
 }

void PlotFaces()
 {
 long i,t,index,Colour;
 long PloyTemp[20*2];
 long NumPloyFaces;
 
 index=0;
 for(i=0;i<NumFaces;i++)
  {
  NumPloyFaces=FaceList[index];
  index++;
  for(t=0;t<NumPloyFaces;t++)
   {
   PloyTemp[t*2]=VectorListT[ FaceList[index]*3 ]+centerx;
   PloyTemp[t*2+1]=VectorListT[ FaceList[index]*3+1 ]+centery;
   index++;
   }
  Colour=FaceList[index];
  index++;
  DrawPoly(ScreenPtr,NumPloyFaces,&PloyTemp[0],Colour);
  }
 }



////////////////////////////////////////////////////////////////////////////////////////////////

int DrawImage(char *screenptr,int width,int height)
 {
 int i,j,c;
 int x,y;

 ScreenPtr=screenptr;
 //Draw a square

 for(i=0;i<8*2;i+=2)
  {
  HexT[i]=(long) ((float)Hex[i]*cos(angle)+Hex[i+1]*sin(angle)+centerx);
  HexT[i+1]=(long) ((float)-Hex[i]*sin(angle)+Hex[i+1]*cos(angle)+centery);
  }
DrawPoly(ScreenPtr,8,&HexT[0],100);
// DrawSpan(screenptr,100,10,200,200,200,210,64);

// PlotData(&VectorList[0]);
 for(i=0;i<NumVectors;i++)
  {
  VectorListR[i*3]=VectorList[i*3];
  VectorListR[i*3+1]=VectorList[i*3+1];
  VectorListR[i*3+2]=VectorList[i*3+2];
//  VectorListR[i*3]=VectorList[i*3]*cos(angle)+VectorList[i*3+1]*sin(angle);
//  VectorListR[i*3+1]=-VectorList[i*3]*sin(angle)+VectorList[i*3+1]*cos(angle);

  VectorListR[i*3+1]=VectorList[i*3+1]*cos(angle)+(VectorList[i*3+2]-35)*sin(angle);
  VectorListR[i*3+2]=-VectorList[i*3+1]*sin(angle)+(VectorList[i*3+2]-35)*cos(angle)+35;
  }

 TranslateVectors();
 PlotData(&VectorListT[0]);


angle+=0.01;

 
 //some simple keyboard controls
 if (kbhit()) 
  {
  c=getkey();
  if (c==UP) 
   {
   startj--;
   if (startj<0)startj=0;
   }
  if (c==LEFT) 
   {
   starti--;
   if (starti<0)starti=0;
   }
  if (c==DOWN) startj++;
  if (c==RIGHT) starti++;
  if (c=='B')colour++;  //Brighter
  if (c=='D')colour--;  //Darker
  }
 else 
  {
  c=0;
  }
	
 startj%=347;//Keep it on the screen
 starti%=288;

 colour+=128; //keep colour positive
 colour%=128;  //and in range
	
 if (c==CR) return 0; else return 1; //stop on <CR>

 }
//end of square drawing program 
//********************************************************************************************************
