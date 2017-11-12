#include "c:\coding\watcom\xavstuff\h\video.h"

#include <fstream.h>
#include <conio.h>
#include <math.h>
#include <dos.h>


const float MaxX=320;
const float MaxY=200;
const float _PI=3.141592654;
const float CenterX=160;
const float CenterY=100;
const float Height=128;
const int SineSize=1024;
unsigned char *physical=(unsigned char *)0x0a0000;
int A,B;
unsigned short sine[SineSize];

const float SPEEDCOMP =3.0;// speed compensation factor for moving parts 
unsigned char XBuffer[320];
unsigned char YBuffer[200];

REGS Registers2;
void InitVideo2(int ax,int bx)        // Attempts to latch an SVGA mode 320*200*256
 {                      //if unavailable, it will use standard MODE 0x13
 Registers2.x.eax=ax;
 Registers2.x.ebx=bx;
 int386(0x10,&Registers2,&Registers2);
 }

void GetSine()
 {
 int i;
 float iF;
 float temp;
 for (i=0;i<SineSize;i++)
  {
  iF=i;
  temp=sin( ((iF *360/512)*(_PI/180)) )*Height;
  sine[i]=(short) temp;
  }
 }

void Drawplasma()
 {
 int i,t;
 float Angle1=0,Angle2=0,Angle3=0,Angle4=0,Angle5=0;
 float Angle1Bak=0,Angle2Bak=0,Angle3Bak=0,Angle4Bak=0,Angle5Bak=0;
 while (!kbhit())
  {
  Angle1Bak=Angle1;
  Angle2Bak=Angle2;
  Angle3Bak=Angle3;
  for (i=0;i<160;i++)
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

  for (i=0;i<100;i++)
   {
   YBuffer[i]=(unsigned char) 16*sin(Angle4) + 8*sin(Angle5);
   Angle4=Angle4+6.283/128;
   Angle5=Angle5+2*6.283/128;
   }
  Angle4=Angle1Bak+((3*6.283/320)*SPEEDCOMP+1);
  Angle5=Angle2Bak+((4*6.283/320)*SPEEDCOMP-1);


  unsigned char* temp1=physical+320*100+160;
  unsigned char* temp2=physical+320*100+160;
  unsigned char* temp3=physical+320*100+160;
  unsigned char* temp4=physical+320*100+160;
  unsigned char yy;
   for (i=0;i<100;i++)
    {
    yy=YBuffer[i];
    for (t=0;t<160;t++)
     {
     *temp1--=yy+XBuffer[t]+64;
     *temp2++=yy+XBuffer[t]+64;
     *temp3--=yy+XBuffer[t]+64;
     *temp4++=yy+XBuffer[t]+64;
     }
     temp1-=160;
     temp2-=(320+160);
     temp3+=(320+160);
     temp4+=160;
    }
  }
 }

void PlotSine()
 {
 unsigned char *temp=physical;
 int x,y;
 for (y=0;y<200;y++)
  for (x=0;x<320;x++)
   {
   *temp++=sine[x+A]+sine[y+B]+1;
   }
 }

void main()
 {
 unsigned char pal[256*3];
 unsigned char c,d;
 int vid=0x0153;
 char n=0  ;

 int i; 
 InitVideo();
// InitVideo2(0x04f02,vid);
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
 A=0;
 B=10;
 GetSine();
 SetPalette(pal,0,256);
 Drawplasma();
 /*
 while (!kbhit())
  {
  A++;
  if (A>512)
   A-=512;
  if (B>512)
   B-=512;
  PlotSine();
  }
  */
 KillVideo();
 }
