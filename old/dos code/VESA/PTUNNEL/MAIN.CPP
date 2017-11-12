// Tunnel V1.1B - Coded by Dark Elf of Phobia
//
// Version B - Tunnel with plasma !
//

#include <fstream.h>  // cout
#include <conio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

#include "\coding\lee\xavstuff\h\video.h"
#include "assem.h"

const float MaxX=320;
const float MaxY=200;
const int PicX=256;
const int PicY=256;
const float ScaleHyp=4096;
const int Memory=MaxX*MaxY*2;
const int CopySize=MaxX*MaxY/4;

const float _PI=3.141592654;
const float CenterX=MaxX/2;
const float CenterY=MaxY/2;
unsigned char *physical=(unsigned char *)0x0a0000;
unsigned char *picture,*circle;
int startx,step;

int i,t;
   // Used in sine plasma routine
const float SPEEDCOMP =2.0;// speed compensation factor for moving parts 
float Angle1=0,Angle2=0,Angle3=0,Angle4=0,Angle5=0;
float Angle1Bak=0,Angle2Bak=0,Angle3Bak=0,Angle4Bak=0,Angle5Bak=0;
unsigned char XBuffer[512];
unsigned char YBuffer[512];
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

void Drawplasma()
 {
  Angle1Bak=Angle1;
  Angle2Bak=Angle2;
  Angle3Bak=Angle3;
  for (i=0;i<PicX/2;i++)
   {
   XBuffer[i]=(unsigned char) 16*sin(Angle1) + 8*sin(Angle2) + 4*sin(Angle3);
   Angle1=Angle1+1*6.283/128;
   Angle2=Angle2+2*6.283/128;
   Angle3=Angle3+3*6.283/128;
   }
  Angle1=Angle1Bak-((1*6.283/320)*SPEEDCOMP);
  Angle2=Angle2Bak+((2*6.283/320)*SPEEDCOMP);
  Angle3=Angle3Bak+((3*6.283/320)*SPEEDCOMP);

  Angle4Bak=Angle4;
  Angle5Bak=Angle5;

  for (i=0;i<PicY;i++)
   {
   YBuffer[i]=(unsigned char) 16*sin(Angle4) + 8*sin(Angle5);
   Angle4=Angle4+6.283/128;
   Angle5=Angle5+2*6.283/128;
   }
  Angle4=Angle1Bak+((3*6.283/320)*SPEEDCOMP+1);
  Angle5=Angle2Bak+((4*6.283/320)*SPEEDCOMP-1);


  unsigned char* temp1=picture+(PicX*127)+127;
  unsigned char* temp2=picture+(PicX*127)+128;
  unsigned char* temp3=picture+(PicX*128)+127;
  unsigned char* temp4=picture+(PicX*128)+128;
  unsigned char yy;
  unsigned char xx;
   for (i=0;i<128;i++)
    {
    yy=YBuffer[i];
    for (t=0;t<128;t++)
     {
     xx=yy+XBuffer[t]+64;
     *temp1--=xx;
     *temp2++=xx;
     *temp3--=xx;
     *temp4++=xx;
     }
     temp1-=128;
     temp2-=(PicX+128);
     temp3+=(PicX+128);
     temp4+=128;
    }
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

 // Reinstall doskey
 //system("doskey/reinstall >nul");
  //system("logout >nul");


 MakeTable(circle);
InitVideo();

  for (i=0;i<256;i++)
   {
   pal[i*3]=0;
   pal[i*3+1]=0;
   pal[i*3+2]=0;
   }
  for (i=0;i<128;i++)
   {
   pal[i*3]=0;
   pal[i*3+1]=0;
   pal[i*3+2]=i/2;
   }

 SetPalette(pal,0,256);

  startx=0;
 Start=clock();

  while (!kbhit())
    {
    Drawplasma();
    CopyPic();
    PlotTable2();
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
