#include <iostream.h>
#include <time.h>
#include "\coding\include\video\video.h"
#include "\coding\include\other\pcx.h"
PCXHeader HeaderInfo;
//#include "\coding\include\vesa\vesa.h"

int kbhit2();
#pragma aux kbhit2 =   \
        "mov     ax,0x0B00"\
        "int     0x21"   \
        "cbw"          \
        "cwde"         \
                value [eax]             \
                modify [eax edx];


 const long MaxAngle=512;
 unsigned char *Buffer1,*Buffer2,*Screen=(unsigned char*) 0x0a0000;
 long Angle,AngleStep;
 long i,t;

#include "assem.h"



unsigned char PictureAPal[256*3];

void main ()
 {
 clock_t Start,End;
 int Frame=0;

 Buffer1=new unsigned char[65536];
 GetPCXPicture2(&HeaderInfo,"east.PCX",Buffer1,PictureAPal);


//  InitVESA();
 InitVideo();
// ModeInfoBlock SetMode;
// SetMode.XResolution=320;
// SetMode.YResolution=200;
// SetMode.NumberOfPlanes=1;
// SetMode.BitsPerPixel=8;
// SetMode.MemoryModel=MODEL_PACKED;
// SetVideo(&SetMode);

// SetParam2();

 SetPalette(PictureAPal,0,256);

 Start=clock();

 Angle=0;AngleStep=1;
 int ydif,xdif,ymul;
 while(!kbhit2())
  {

  Angle+=AngleStep;
  if (Angle==MaxAngle-1)
    AngleStep=-1;
  if (Angle==0)
    AngleStep=1;
  Slide(Buffer1,Screen,Angle,MaxAngle);
  WaitVBL();
   Frame++;

  }
  
 End=clock();
 KillVideo();
// KillVESA();
 if (Frame!=0)
  {
  cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
  cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
  cout << "\nCode By Dark Elf / Phobia"<<endl;
  }
 }
