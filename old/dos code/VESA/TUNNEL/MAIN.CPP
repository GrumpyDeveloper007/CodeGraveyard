// Tunnel V1.1 - Coded by Dark Elf of Phobia
//
//
#include <fstream.h>  // cout
#include <conio.h>
#include <math.h>
#include <dos.h>
#include <time.h>

#include "\coding\include\vesa\vesa.h"
#include "assem.h"
#include "\coding\include\other\pcx.h"
PCXHeader HeaderInfo;

const float MaxX=640;//320-640
const float MaxY=480;//240-480
const float ScaleHyp=4096;
const int Memory=MaxX*MaxY*2;
const Memory2=MaxX*MaxY;
const int CopySize=MaxX*MaxY/4;
int i;

const float _PI=3.141592654;
const float CenterX=MaxX/2;
const float CenterY=MaxY/2;
char *file="mess.pcx";
unsigned char *picture,*circle;
long *DistanceTable; // (MaxX/2)*(MaxY/2)
int startx;
REGS Registers2;

float GetAngle(float &dx,float &dy)
 {
 if (dx==0)
  return 0;
 if (dy==0)
  return 45;
 if (dx>=dy)             // adj > opp
  return (180*atan(dy/dx))/_PI;
 return (180*atan(dx/dy))/_PI;
 }

// opp/Sin (a) = hyp

float GetHyp2(float &dx,float &dy,float &Angle)  // Angle = degrees
 {
  return sqrt(dy*dy+dx*dx);
 }

float GetHyp(float &dx,float &dy,float &Angle)  // Angle = degrees
 {
 if (dx==0)
  return dy;
 if (dy==0)
  return dx;
 if (dx>=dy)
  return dy/sin(( Angle*_PI/180 ));
 return dx/sin(( Angle*_PI/180 ));
 }

float abs(float val)
 {
 if (val<0)
  return -val;
 return val;
 }

void MakeDistance()
 {
 long *Table=DistanceTable;
 int i,t;
 float Temp;
 for (i=0;i<=MaxY/2;i++)
  for (t=0;t<=MaxX/2;t++)
   {
   Temp=sqrt( (i*i)+(t*t) );
   *Table++=(long) Temp;
   }
 }

void MakeTable(unsigned char* Table)
 {
 float dx,dy;
 float Angle;
 int i,t,ymul;
 float Temp,Temp2;
 cout << "\nMaking table :";
 for (i=0;i<MaxY;i++)
  {
  dy=abs(i-CenterY);
  ymul=dy*(MaxX/2+1);
  for (t=0;t<MaxX;t++)
   {
   dx=abs(t-CenterX);

   if (dx>dy)
    Angle=GetAngle(dy,dx);
   else
    Angle=GetAngle(dx,dy);

   if (t>=CenterX && i>=CenterY)
    {
    if (dx>dy)
     Temp=(90+Angle);
    else
     Temp=135+(45-Angle);
    }            
   if (t>CenterX && i<CenterY)
    {
    if (dx>dy)
     Temp=90-(Angle);
    else
     Temp=45-(45-Angle);
    }
   if (t<CenterX && i>CenterY)
    {
    if (dx>dy)
     Temp=180+45+(45-Angle);
    else
     Temp=180+(Angle);
    }
   if (t<=CenterX && i<=CenterY)
    {
    if (dx>dy)
     Temp=270+(Angle);
    else
     Temp=315+(45-Angle);
    }
   Temp2=ScaleHyp/DistanceTable[(int)(dx+ymul)];
   Temp=Temp*256/360;
   *Table++=(unsigned char) Temp2;
   *Table++=(unsigned char) Temp;
   }
  }
 }

//
unsigned char SinTable[256];
unsigned char YTable[256];
void GenerateSineTable(int Start)
 {
 float scale=SinTable[Start]/32;
 for (i=0;i<256;i++)
  {
  YTable[i]=SinTable[256]/scale;
  }
 }
void MakeSine()
 {
 float Step=0;
 for (i=0;i<256;i++)
  {
  SinTable[i]=(abs(sin(Step)))*256;
  Step+=_PI/256;
  }
 }

void AdjustTable()
 {
 unsigned char *screenT=(unsigned char*)0x0a0000;
 unsigned char *CircleT=(unsigned char*) circle;
 unsigned char *PictureT=(unsigned char *)picture+startx;
 unsigned char temp;
 for(i=0;i<MaxX*MaxY;i++)
  {
  CircleT++;
  temp=SinTable[*CircleT];
  CircleT--;
  *CircleT=temp+*CircleT;
  CircleT++;
  CircleT++;
  }
 }


void main(int argc,char **argv)
 {
 clock_t Start,End;
 float Frame=0;

 char n=0;
 unsigned char c;
 unsigned char pal[256*3];
 int x,y,r;

 if (argc>1)
  file=(char*)argv[1];

 picture =new unsigned char[65536*2];
 DistanceTable =new long[Memory2];
 circle = new unsigned char[Memory]; // wont let me do MaxX*MaxY SHIT

 // Reinstall doskey
 //system("doskey/reinstall >nul");

 // Load picture / palette
 GetPCXInfo(&HeaderInfo,file);
 GetPCXPicture(&HeaderInfo,file,picture);
 GetPCXPicture(&HeaderInfo,file,picture+65536);
 GetPCXPalette(&HeaderInfo,file,pal);

 MakeSine();
 //system("logout >nul");

 MakeDistance();
 MakeTable(circle);
// AdjustTable();
 InitVESA();
 ModeInfoBlock SetMode;
  SetMode.NumberOfPlanes=1;
  SetMode.BitsPerPixel=8;
  SetMode.XResolution=MaxX;
  SetMode.YResolution=MaxY;
  SetMode.MemoryModel=MODEL_PACKED;
 SetVideo(&SetMode);
 SetParam();

 SetPalette(pal,0,256);
 unsigned char *Screen=(unsigned char* )0x0a0000;

 startx=0;
 Start=clock();
  while (!kbhit())
    {
    PlotTable2();
    VESAUpdateScreen();
    startx-=256-2;
    if (startx>=65536)
     startx-=65536;
    if (startx<0)
     startx+=65536;
    Frame++;
    }
 End=clock();
 n=getch();
 KillVESA();

 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (int) ((Frame*(float)CLOCKS_PER_SEC)/((float)End-Start))<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }
