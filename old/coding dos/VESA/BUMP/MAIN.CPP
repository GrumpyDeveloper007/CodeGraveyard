////////////////////////////////////////////////////////////////////////////
//
// Bump Mapping - phong ball version
//
// coded by Dark Elf / Phobia
//
//
// Table intensive version


#include <fstream.h>
#include <iostream.h>
#include <time.h>
#include <math.h>
#include "\coding\include\vesa\vesa.h"
#include "\coding\include\std\std.h"
#include "\coding\include\other\pcx.h"
// #include "assem.h"
 const MaxAngle=256; // must be 256
 const PictureSize=640*480;

 const ScreenX=640;
 const ScreenY=480;
 const ScreenSize=ScreenX*ScreenY;


 const BumpMem=640*480;
 const BumpSizeX=640;
 const BumpSizeY=350;

 const CopyMem=640*350;
 const CopySizeX=640;
 const CopySizeY=350;

 unsigned char Buffer[BumpMem];
 unsigned char *Screen=(unsigned char *)0x0a0000;
 unsigned char pal[256*3];

 unsigned char PictureAPal[256*3];
 unsigned char Buffer1[PictureSize*3];
 unsigned char *RefTableA;
 unsigned char *RefTableB;
 unsigned char Table[64000];
 unsigned char LightBuffer[640*400]; // Max table size
 unsigned char Buffer3[PictureSize];
 long Angle,AngleStep;
 int i,t;

 clock_t Start,End;
 float Frame=0;

void PlotPixel(unsigned char *Offset,char Col);
#pragma aux PlotPixel = \
            "mov fs:[edi],al" \
            parm caller [edi] [al];


// Generate tablea/tableb used in update
void InitCrossFade()
 {
 float temp1,aa,temp2,bb,cc,dd;
 unsigned char tempa;
 unsigned char *tablea=RefTableA;
 unsigned char *tableb=RefTableB;
 int i,t;
 for (i=0;i<MaxAngle;i++)
  {
  cc=(255- ((float)i) )/512;// divisior = light spot step(256=small)
  dd=(i);
  dd=256/dd;
  temp2=cc;
  for (t=0;t<256;t++)
   {
   temp1=t+i;
   if (temp1>255)
     temp1=255;
   *tablea++=(unsigned char) temp1;
   *tableb++=(unsigned char) ((float)t/dd);
   }
  }
 }

void MakeLightArea()
 {
 int i,t;
 const cx=160,cy=120;
 float cal,ox,oy;
 unsigned char *Temp=LightBuffer;
 for (i=0;i<240;i++)
  {
  oy=(cy-i)*(cy-i);
  for (t=0;t<320;t++)
   {
   ox=(cx-t)*(cx-t);
     // calc hyp (distance from center)
   cal = sqrt(ox+oy)*2+32; // multiplyer = Size of spot (256=small spot)
   if (cal>255)
    cal=255;
   *Temp++=255-cal;
   }
  }
 }


void Setup()
 {
 unsigned char *Source=Buffer1;
 unsigned char *Destnation=VESAScreenPtr;
 for(i=0;i<ScreenY;i++)
  {
  for(t=0;t<ScreenX;t++)
   {
   PlotPixel(Destnation++,*Source++);
   PlotPixel(Destnation++,*Source++);
   PlotPixel(Destnation++,*Source++);
   Destnation++;
   }
  }
 }
///////////////////////////////////////////////////////////////////
void DoBump()
 {
 int x,y,vlx,vly,lx,ly,nx,ny;
 int difx,dify,l,dif,tt;
 unsigned char *Destnation;
 unsigned char *Source;
 unsigned char *Source2;
 unsigned char *Dest1;
 unsigned char *BumpMap;
 unsigned char *ttemp;
 unsigned char *pic;
 unsigned char c;
 int ymul;

 l=0;
 while(!kbhit2())
  {
  lx=cos((float)l/13)*160+160;
  ly=sin((float)l/23)*120+120;
  Frame++;
  l++;

  Destnation=Table;
  Dest1=VESAScreenPtr+lx*4+ly*640*4;
  BumpMap=Buffer+lx+ly*640;
  Source=LightBuffer;
  pic=Buffer1+lx*3+ly*640*3;

  for(y=0;y<240;y++)
   {
   vly=(y-120);
   ymul=y*640;
   for (x=0;x<320;x++)
    {
    vlx=(x-160);
    // Get angle x , y of bumpmap
    nx=(BumpMap[x+ymul+1]-BumpMap[x+ymul-1]); 
    ny=(BumpMap[x+ymul+640]-BumpMap[x+ymul-640]);

    // Calculate intensity by adjusting for direction
    difx=((vlx)-nx);
    if (difx<0)
      difx=-difx;
    dify=(vly-ny);
    if (dify<0)
      dify=-dify;

    tt=(*Source++);
    ttemp=RefTableB+(tt<<8);
    dif=difx+dify/2;
    if (dif>255)
       dif=255;
    dif=255-dif;
//    PlotPixel(Dest1,ttemp[dif]); // Test
//    Dest1+=4;

    ///////// Scale Picture
    Source2=RefTableB+(ttemp[dif]<<8);
    c=*pic++;
    c=Source2[c];
    PlotPixel(Dest1,c);

    c=*pic++;
    c=Source2[c];
    PlotPixel(Dest1+1,c);

    c=*pic++;
    c=Source2[c];
    PlotPixel(Dest1+2,c);
    Dest1+=4;

    }
   Destnation+=320;
   Dest1+=320*4;
   pic+=320*3;
   }
// MakeLightArea();
//  CopyScr();
  } // end while
 }

void cls(int start,int Size)
 {
 unsigned char *Destnation=VESAScreenPtr+start;
 for(i=0;i<Size;i++)
  PlotPixel(Destnation++,0);
 }


void main ()
 {

 RefTableA=(unsigned char *)( ( (long)(new unsigned char[256*256*2])+65536)&0xffff0000);
 RefTableB=(unsigned char *)( ( (long)(new unsigned char[256*256*2])+65536)&0xffff0000);
 InitCrossFade();
 MakeLightArea();


 GetPCXPicture2("north.PCX",Buffer3,PictureAPal);
 GetPCXPicture("pic3.PCX",Buffer);
 for (i=0;i<PictureSize;i++)
  {
  t=i*3;
  Buffer1[t]=PictureAPal[Buffer3[i]*3+2]*4;
  Buffer1[t+1]=PictureAPal[Buffer3[i]*3+1]*4;
  Buffer1[t+2]=PictureAPal[Buffer3[i]*3]*4;
  }


 InitVESA();
 ModeInfoBlock SetMode;
   SetMode.NumberOfPlanes=1;
   SetMode.BitsPerPixel=32;
   SetMode.XResolution=ScreenX;
   SetMode.YResolution=ScreenY;
   SetMode.MemoryModel=MODEL_DIRECT;
   SetMode.RedMaskSize=8;
   SetMode.GreenMaskSize=8;
   SetMode.BlueMaskSize=8;
   SetMode.RsvdMaskSize=8;
 if (!SetVideo(&SetMode))
   {
   cout << "Error with video ";
   return;
   }

 Start=clock();
 Angle=0;AngleStep=1;
// VESACLS();
// VESAUpdateScreen();
 cls(0,ScreenX*ScreenY*4);
// Setup();
// cls(0,ScreenX*40*4);
// cls(ScreenX*(ScreenY-40)*4,ScreenX*40*4);
 DoBump();
// while(!kbhit2())
//  {
//  Angle+=AngleStep;
//  if (Angle==MaxAngle-1)
//   AngleStep=-1;
//  if (Angle==0)
//   AngleStep=1;

//  Frame++;
//  }

 End=clock();
 KillVESA();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }

void CopyScr()
 {
 unsigned char *Source=Table;
 unsigned char *Destnation=VESAScreenPtr;//+(160*4+640*40*4);
 unsigned char *pic=Buffer1;//+(160*3+640*40*3);
 unsigned char *Source2;
 int y,c;
 unsigned char x;
 for(i=0;i<240;i++)
  {
  for(t=0;t<320;t++)
   {
   y=(*Source);
   Source2=RefTableA+(y*256);

   x=*pic;
   c=Source2[x];
   PlotPixel(Destnation,c);
   Destnation++;
   pic++;

   x=*pic;
   c=Source2[x];
   PlotPixel(Destnation,c);
   Destnation++;
   pic++;

   x=*pic;
   c=Source2[x];
   PlotPixel(Destnation,c);
   Destnation++;
   pic++;

   Source++;
   Destnation++;
   }
  Destnation+=320*4;
  pic+=320*3;
  }
 }

void LightSpotB(int ox,int oy)
 {
 int i,t,c,x,y;
 unsigned char *Source=LightBuffer;
 unsigned char *Destnation=VESAScreenPtr+(ox*4+640*oy*4);
 unsigned char *pic=Buffer1+(ox*3+640*oy*3);
 unsigned char *Source2;

 for (i=0;i<240;i++)
  {
  for (t=0;t<320;t++)
   {
   y=*Source;
   Source2=RefTableB+(y*256);

   x=*pic;
   c=Source2[x];
   PlotPixel(Destnation,c);
   Destnation++;
   pic++;

   pic+=2;
   Destnation+=2;

   Source++;
   Destnation++;
   }
  Destnation+=(640-320)*4;
  pic+=(640-320)*3;
  }
 }
void LightSpotR(int ox,int oy)
 {
 int i,t,c,x,y;
 unsigned char *Source=LightBuffer;
 unsigned char *Destnation=VESAScreenPtr+(ox*4+640*oy*4);
 unsigned char *pic=Buffer1+(ox*3+640*oy*3);
 unsigned char *Source2;

 for (i=0;i<240;i++)
  {
  for (t=0;t<320;t++)
   {
   y=*Source;
   Source2=RefTableB+(y*256);

   pic+=2;
   Destnation+=2;
//   x=*pic;
//   c=Source2[x];
//   PlotPixel(Destnation,c);
//   Destnation++;
//   pic++;

//   x=*pic;
//   c=Source2[x];
//   c=x;
//   PlotPixel(Destnation,c);
//   Destnation++;
//   pic++;

   x=*pic;
   c=Source2[x];
//   c=x;
   PlotPixel(Destnation,c);
   Destnation++;
   pic++;

   Source++;
   Destnation++;
   }
  Destnation+=(640-320)*4;
  pic+=(640-320)*3;
  }
 }

void LightSpotG(int ox,int oy)
 {
 int i,t,c,x,y;
 unsigned char *Source=LightBuffer;
 unsigned char *Destnation=VESAScreenPtr+(ox*4+640*oy*4);
 unsigned char *pic=Buffer1+(ox*3+640*oy*3);
 unsigned char *Source2;

 for (i=0;i<240;i++)
  {
  for (t=0;t<320;t++)
   {
   y=*Source;
   Source2=RefTableB+(y*256);

   Destnation++;
   pic++;

   x=*pic;
   c=Source2[x];
//   c=x;
   PlotPixel(Destnation,c);
   Destnation++;
   pic++;

   Destnation++;
   pic++;

   Source++;
   Destnation++;
   }
  Destnation+=(640-320)*4;
  pic+=(640-320)*3;
  }
 }


