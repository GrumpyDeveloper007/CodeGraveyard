// Tunnel V1.1 - Coded by Dark Elf of Phobia
//
//
#include <fstream.h>  // cout
//#include <conio.h>
#include <math.h>
#include <time.h>

#include "\coding\include\video\video.h"
#include "\coding\include\std\std.h"
#include "assem.h"
#include "\coding\include\other\pcx.h"

const float MaxX=320;
const float MaxY=200;
const float ScaleHyp=4096;
const int Memory=MaxX*MaxY*2;
const int CopySize=MaxX*MaxY/4;
int i;

int cm,cmod;

const float _PI=3.141592654;
float CenterX=MaxX/2;
float CenterY=MaxY/2;
char *file="other.pcx";
unsigned char *picture,*circle;
int startx;

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

void MakeTable(unsigned char* Table)
 {
 float dx,dy;
 float Temp4;
 float Angle;
 int i,t;
 float Temp,Temp2;
 float ScaleD=MaxX/2;
 for (i=0;i<MaxY;i++)
  {
  dy=abs(i-CenterY);
  for (t=0;t<MaxX;t++)
   {
   dx=abs(t-CenterX);

   Temp=0;
   Temp2=0;
   if (dx>dy)
    {
    Angle=GetAngle(dy,dx);
//    ScaleD=(CenterX*(90-Angle)+CenterY*(Angle))/45;
    }
   else
    {
    Angle=GetAngle(dx,dy);
//    ScaleD=(CenterX*(Angle)+CenterY*(90-Angle))/45;
    }
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
   Temp2=GetHyp(dx,dy,Angle)/1.4;//*ScaleD;
   Temp=Temp*256/360;
   if (Temp>25 && Temp<75)
    {
    Temp4=(cm/abs((Temp-50)));
    Temp2=Temp4;
    }
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

void PlotTable()
 {
// GenerateSineTable(startx % 256);
 unsigned char *screenT=(unsigned char*)0x0a0000;
 unsigned char *CircleT=(unsigned char*) circle;
 unsigned char *PictureT=(unsigned char *)picture+startx;
 unsigned char *temp;
 for(i=0;i<64000;i++)
  {
  temp=PictureT+*CircleT;
  CircleT++;
  temp+=SinTable[*CircleT]+*CircleT*256;
  CircleT++;
  *screenT++=*temp;
  }
 }

void AdjustTable()
 {
 unsigned char *screenT=(unsigned char*)0x0a0000;
 unsigned char *CircleT=(unsigned char*) circle;
 unsigned char *PictureT=(unsigned char *)picture+startx;
 unsigned char temp;
 for(i=0;i<64000;i++)
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
// cout << "no:" <<argc<<" pt:"<<(char *)argv[1];
// cin >>c;

 picture =new unsigned char[65536*2];
 circle = new unsigned char[Memory]; // wont let me do MaxX*MaxY SHIT

 // Reinstall doskey
 //system("doskey/reinstall >nul");

 // Load picture / palette
 GetPCXPicture(file,picture);
 GetPCXPicture2(file,picture+65536,pal);

 MakeSine();
  //system("logout >nul");


 MakeTable(circle);
// AdjustTable();
 InitVideo();

 SetPalette(pal,0,256);
 unsigned char *Screen=(unsigned char* )0x0a0000;

 cm=1;
  startx=0;
 Start=clock();
  while (!kbhit2())
    {
    cm+=cmod;
    if (cm>25)
      cmod=-1;
     if (cm==0)
       cmod=1;
 MakeTable(circle);
    PlotTable2();
    CenterX++;
    startx+=-1;
    if (startx>=65536)
     startx-=65536;
    if (startx<0)
     startx+=65536;
    Frame++;
    }
 End=clock();
  KillVideo();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }
