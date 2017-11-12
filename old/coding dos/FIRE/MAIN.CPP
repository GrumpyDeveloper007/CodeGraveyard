// Fire V1.1 - Coded by Dark Elf of Phobia
//
// Shit fire
#include <fstream.h>  // cout
#include <conio.h>
#include <time.h>
#include <stdlib.h>

#include "..\lee\xavstuff\h\video.h"
#include "assem.h"
const HighVal=255;

const float MaxX=320;
const float MaxY=200;
unsigned char *physical=(unsigned char *)0x0a0000;
unsigned char *picture, *picture2;
unsigned char *source;
unsigned char *destnation;
unsigned char *swap;
int startx,step;
int i,t;

void fire()
 {
 unsigned char *temp1=source-1,*temp2=source,*temp3=source+1,
               *temp4=source+320-1,*temp5=source+320,*temp6=source+320+1,
               *temp7=source+640-1,*temp8=source+640+1,
               *dest=destnation;
 int tt;
 for (i=0;i<200;i++)
  for (t=0;t<320;t++)
   {
   tt=(int)*temp1+*temp2+*temp3+*temp4+*temp5+*temp6+*temp7+*temp8;
   *dest++=tt/8;
   temp1++;temp2++;temp3++;
   temp4++;temp5++;temp6++;
   temp7++;temp8++;
   }
 }

void plotfirespot()
 {
 int tt;
 for (i=0;i<20;i++)
  {
;  tt=(rand())%(8000-1280)+320*175;
  tt=(rand()*2)%(64000-960)+640;
  source[tt+320]=HighVal;
  source[tt+1+320]=HighVal;
  source[tt-1+320]=HighVal;
  source[tt]=HighVal;
  source[tt+1]=HighVal;
  source[tt-1]=HighVal;
  source[tt-320]=HighVal;
  source[tt+1-320]=HighVal;
  source[tt-1-320]=HighVal;
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

 picture =new unsigned char[960+64000+960];
 picture2 = new unsigned char[960+64000+960];
 clear(picture,64000+960+960);
 clear(picture2,64000+960+960);
 source=picture+960;
 destnation=picture+960;

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
  for (i=0;i<HighVal;i++)
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
    PlotFire2();
    CopyPic();
    // swap source/destnation
    swap=source;
    source=destnation;
    destnation=swap;
    Frame++;
    }
 End=clock();
  KillVideo();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }
