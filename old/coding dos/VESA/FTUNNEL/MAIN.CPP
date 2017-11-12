// Fire V1.2 - Coded by Dark Elf of Phobia
//
// Shit fire + Shit tunnel
#include <fstream.h>  // cout
#include <conio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

#include "\coding\lee\xavstuff\h\video.h"
#include "assem.h"

const float MaxX=320;
const float MaxY=200;
unsigned char *physical=(unsigned char *)0x0a0000;
unsigned char *fire, *fire2;
unsigned char *source;
unsigned char *destnation;
unsigned char *swap;
int startx,step;
int i,t;

const float _PI=3.141592654;
const float CenterX=MaxX/2;
const float CenterY=MaxY/2;
unsigned char *picture,*circle;
const float ScaleHyp=2096;
const int Memory=MaxX*MaxY*2;
const int CopySize=MaxX*MaxY/4;

   // Used in angle and hyp calcaulation routines
float dx,dy;
float Angle;
float Temp,Temp2;

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

//float GetHyp2(float &dx,float &dy,float &Angle)  // Angle = degrees
// {
//  return sqrt(dy*dy+dx*dx);
// }

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
 for (i=0;i<MaxY;i++)
  {
  dy=abs(i-CenterY);
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
   Temp2=ScaleHyp/GetHyp(dx,dy,Angle);
   Temp=Temp*256/360;
   *Table++=(unsigned char) Temp2;
   *Table++=(unsigned char) Temp;
   }
  }
 }



const firespot=128;
const firespot2=255;
void plotfirespot()
 {
 int tt;
 for (i=0;i<40;i++)
  {
  tt=(rand()*2)%(64000-256)+256;
  source[tt+256]=firespot;
  source[tt+1+256]=firespot;
  source[tt-1+256]=firespot;
  source[tt]=firespot2;
  source[tt+1]=firespot;
  source[tt-1]=firespot;
  source[tt-256]=firespot;
  source[tt+1-256]=firespot;
  source[tt-1-256]=firespot;
  }
 }
void clear(unsigned char *Buffer,int Size)
 {
 for(i=0;i<Size;i++)
 Buffer[i]=0;
 }

void main(int argc,char **argv)
  {
 clock_t Start,End;
 int Frame=0;
 step=256-1;
 unsigned char pal[256*3];

  if (argc>1)
   step=strtol( (char*)argv[1],NULL,10 ) ;
 picture =new unsigned char[65536*2];
 circle = new unsigned char[Memory]; // wont let me do MaxX*MaxY SHIT

 MakeTable(circle);


 fire =new unsigned char[65536*2+4048];
 fire2 = new unsigned char[65536*2+4048];
 clear(fire,65536*2+2024+2024);
 clear(fire2,65536*2+2024+2024);
 source=fire+2024;
 destnation=fire2+2024;

 // Reinstall doskey
 //system("doskey/reinstall >nul");
  //system("logout >nul");


 InitVideo();

  for (i=0;i<256;i++)
   {
   pal[i*3]=0;
   pal[i*3+1]=0;
   pal[i*3+2]=0;
   }
  for (i=0;i<256;i++)
   {
   pal[i*3]=i/4;
   pal[i*3+1]=0;
   pal[i*3+2]=0;
   }

 SetPalette(pal,0,256);

 startx=0;
 Start=clock();

  while (!kbhit())
    {
    plotfirespot();
    PlotFire();
    CopyPic();

    PlotTable();

    // swap source/destnation
    swap=source;
    source=destnation;
    destnation=swap;

    startx-=step;
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
