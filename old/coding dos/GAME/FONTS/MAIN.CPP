#include <conio.h>
#include <fstream.h>
#include "\coding\include\video\video.h"
#include "\coding\include\other\pcx.h"


 const int MaxAngle=90;
 const int PictureSize=64000;

 unsigned char Buffer[640*480];
 unsigned char *Screen=(unsigned char *)0x0a0000;
 int i,t,j,x,y;
 const FontX=6;
 const FontY=8;

 const CharactersX=16;
 const CharactersY=16;

 const PictureX=320;

void main ()
 {
 GetPCXPicture("thinpaz.PCX",Buffer);
 InitVideo();
// SetPalette(pal,0,256);
 GetPCXPicture("thinpaz.PCX",Screen);

 fstream file;
 file.open("font4.cpp",ios::binary|ios::out);

 file << "unsigned char Font2Data[]={";
 file << (int) FontX << "," <<FontY <<"," << endl; // FontSize

 // Output 32 blank spaces ( store as ascii)
 for (i=0;i<32;i++)
  {
  file << FontX<<"," <<endl; // Letter width
  for (t=0;t<FontY;t++)
   {
   for (j=0;j<FontX;j++)
    {
    file << "0,";
    }
   file << endl;
   }
  }

 for(t=0;t<CharactersY;t++)
  {
  for(i=0;i<CharactersX;i++)
   {
   file << FontX <<"," <<endl;
   for (y=0;y<FontY;y++)
    {
    for (x=0;x<FontX;x++)
     {
     if (Buffer[x+(y*PictureX)+(i*FontX)+(t*PictureX*FontY)]==1)
       file << "1,";
     else
       file << "0,";
     }
    file<<endl;
    }
   }
  }
 file << "};" <<endl;
 while (!kbhit());
 KillVideo();
 }
