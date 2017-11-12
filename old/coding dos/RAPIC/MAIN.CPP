#include <i86.h>
#include <math.h>
#include <conio.h>
#include <fstream.h>
#include <iostream.h>
#include <time.h>
#include "\coding\include\video\video.h"
#include "\coding\include\other\pcx.h"
//#include "assem.h"
 clock_t Start,End;
 float Frame=0;


 const int MaxAngle=90;
 const int PictureSize=64000;

 char c;
 unsigned char Buffer[640*700];
 unsigned char *Screen=(unsigned char *)0x0a0000;
 unsigned char pal[256*3*2];
 unsigned char pal2[4096*2];
 long Angle;
 int i,t;

void main ()
 {
int a;


 InitVideo();

 GetPCXPicture("raedita.PCX",Buffer);
 for (int i=0;i<64000;i++)
  Screen[i]=Buffer[i];
 fstream file;
 a=0;
 file.open("temp_vtx.pal",ios::in);
 file.read(pal2,4096);
 file.close();

 while (!kbhit())
  {
  for(int i=0;i<256;i++)
   {
   pal[i*3]=pal2[i*4+1];
   pal[i*3+1]=pal2[i*4+2];
   pal[i*3+2]=pal2[i*4+3];
   }
 SetPalette(pal,0,256);
  }
 KillVideo();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }
