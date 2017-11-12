#include <fstream.h>
#include <iostream.h>
#include <time.h>
#include "\coding\lee\xavstuff\h\vesa.h"
#include "\coding\lee\xavstuff\h\std.h"
#include "\coding\lee\XavStuff\h\pcx.h"
#include "assem.h"


// Buffer - pointer to 320*200*256 - value from 0-256 col
// Buffer 1-Start picture
// Buffer 2-End pciture

 const int MaxAngle=128;
 const int PictureSize=640*350;
 unsigned char PictureAPal[256*3];
 unsigned char PictureBPal[256*3];
 unsigned char Buffer3[PictureSize];
 unsigned char *Buffer1,*Buffer2;
 unsigned char *RefTableA,*RefTableB,*MixTable;
 unsigned char *para,*parb,*parc,*pard;
 long Angle,AngleStep;
 int i,t;

PCXHeader HeaderInfo;

// Generate tablea/tableb used in update
void InitCrossFade()
 {
 float temp1,temp2,aa,bb;
 unsigned char tempa,tempb;
 unsigned char *tablea=RefTableA;
 unsigned char *tableb=RefTableB;
 for (i=0;i<MaxAngle;i++)
  {
  aa=(MaxAngle-i)*255/MaxAngle;bb=i*255/MaxAngle;
  aa=255/aa;bb=255/bb;
  for (int t=0;t<256;t++)
   {
   temp1=t/aa;temp2=t/bb;
   *tablea++=(unsigned char) temp1;
   *tableb++=(unsigned char) temp2;
   }
  }
 }

void main ()
 {
 clock_t Start,End;
 float Frame=0;

 RefTableA=new unsigned char[256*MaxAngle+256];
 RefTableB=new unsigned char[256*MaxAngle+256];
 int wank=((long)RefTableA+256)&0xffffff00;
 int wank2=((long)RefTableB+256)&0xffffff00;
 RefTableA=(unsigned char*)wank;
 RefTableB=(unsigned char*)wank2;
 InitCrossFade();

 Buffer1=new unsigned char[PictureSize*3];
 Buffer2=new unsigned char[PictureSize*3];

 GetPCXInfo(&HeaderInfo,"north.PCX");
 GetPCXPicture(&HeaderInfo,"north.PCX",Buffer3);
 GetPCXPalette(&HeaderInfo,"north.PCX",PictureAPal);
 for (i=0;i<PictureSize;i++)
  {
  t=i*3;
  Buffer1[t]=PictureAPal[Buffer3[i]*3+2]*4;
  Buffer1[t+1]=PictureAPal[Buffer3[i]*3+1]*4;
  Buffer1[t+2]=PictureAPal[Buffer3[i]*3]*4;
  }

 GetPCXInfo(&HeaderInfo,"east.PCX");
 GetPCXPicture(&HeaderInfo,"east.PCX",Buffer3);
 GetPCXPalette(&HeaderInfo,"east.PCX",PictureBPal);
 for (i=0;i<PictureSize;i++)
  {
  t=i*3;
  Buffer2[t]=PictureBPal[Buffer3[i]*3+2]*4;
  Buffer2[t+1]=PictureBPal[Buffer3[i]*3+1]*4;
  Buffer2[t+2]=PictureBPal[Buffer3[i]*3]*4;
  }


 InitVESA();
 ModeInfoBlock SetMode;
   SetMode.NumberOfPlanes=1;
   SetMode.BitsPerPixel=32;
   SetMode.XResolution=640;
   SetMode.YResolution=350;
   SetMode.MemoryModel=MODEL_DIRECT;
   SetMode.RedMaskSize=8;
   SetMode.GreenMaskSize=8;
   SetMode.BlueMaskSize=8;
   SetMode.RsvdMaskSize=8;
 SetVideo(&SetMode);
 SetParam();

 Start=clock();
 Angle=0;AngleStep=1;
 para=Buffer1;parb=Buffer2;

 while(!kbhit2())
  {
  Angle+=AngleStep;
  if (Angle==MaxAngle-1)
   AngleStep=-1;
  if (Angle==0)
   AngleStep=1;

  parc=RefTableA+(Angle<<8);pard=RefTableB+(Angle<<8);
  UpdateFade();
  Frame++;
  }

 End=clock();
 KillVESA();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }
