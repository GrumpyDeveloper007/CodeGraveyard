#include <i86.h>
#include <conio.h>
#include <fstream.h>
#include <iostream.h>
#include <time.h>
#include "\coding\watcom\xavstuff\h\video.h"
#include "assem.h"

float DistanceTable[65536];
unsigned short ScanBufferLeft[200];
unsigned short ScanBufferRight[200];
unsigned char *Screen=(unsigned char *)0x0a0000;
unsigned char *Texture;
short ChangeX1,ChangeY1;
short ChangeX2,ChangeY2;
short MinY,MaxY;
float HypAB,HypAC,HypBD,HypCD;
float Ax,Ay,Bx,By,Cx,Cy,Dx,Dy;


 unsigned char *Buffer1,*Buffer2,*Screen;
 unsigned char *btemp;
 unsigned char *RefTableA,*RefTableB,*MixTable;
 unsigned char CurrentPal[256*3];
 int i,t;

#include "..\XavStuff\h\pcx.h"
PCXHeader HeaderInfo;


void MakeDistanceTable()
 {
 int i,t;
 for (i=0;i<256;i++)
  for (t=0;t<256;t++)
   DistanceTable[i*256+t]=(float) sqrt(i*i+t*t);
 }

void TexturePlot()
 {
 int i,t;
 float TextureX=256,TextureY=256;
 float cn1,dn1,XStep=0,YStep=0,XStepT,StartX,EndX,m,m1,an=0,SX=0,SY=0;
 float DXStep;
 float AB,AC,BD,CD;
 AB=TextureY/(By-Ay); // Step in X of source
 AC=TextureX/(Cy-Ay); // Step in Y of source
 for(i=MinY;i<=MaxY;i++)
  {
  StartX=ScanBufferLeft[i];
  EndX=ScanBufferRight[i];
  XStepT=XStep;
  m=sqrt((XStep*XStep)+(YStep*YStep)); // M=length of line in source
  m1=EndX-StartX; // M1=length of line in destnation
  DXStep=m/m1; // Number of pixels to move in source per destnation pixel
  for(t=StartX;t<=EndX;t++)
   {
   Screen[(int)t+i*320]=Texture[(float)DXStep*(t-StartX)+SX+(SY*TextureX)];
   }
  SX+=AB; // Next X line in source
  SY+=AC; // Next Y line in source
  }
 }






void main ()
 {
 clock_t Start,End;
 int Frame=0;


 RefTableA=new unsigned char[256*MaxAngle+256];
 RefTableB=new unsigned char[256*MaxAngle+256];
 int wank=((long)RefTableA+256)&0xffffff00;
 int wank2=((long)RefTableB+256)&0xffffff00;
 RefTableA=(unsigned char*)wank;
 RefTableB=(unsigned char*)wank2;
 MixTable=new unsigned char[65536*4];
 wank=((long)MixTable+65536)&0xffff0000; // 64 K align
 MixTable=(unsigned char *)wank;
 pare=MixTable;
 InitCrossFade();

 Screen=(unsigned char*)0x0a0000;
 Buffer1=new unsigned char[PictureSize];
 Buffer2=new unsigned char[PictureSize];

 GetPCXInfo(&HeaderInfo,"north.PCX");
 GetPCXPicture(&HeaderInfo,"north.PCX",Buffer1);
 GetPCXPalette(&HeaderInfo,"north.PCX",PictureAPal);

 GetPCXPalette(&HeaderInfo,"north.PCX",CurrentPal);

 InitVideo();
 SetPalette(CurrentPal,0,256);

 Start=clock();


 while(!kbhit())
 {
    Frame++;
  }

 End=clock();
 KillVideo();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }
