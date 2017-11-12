
#define NUMSYMBOLS 26
#define FONTSIZEX 16
#define FONTSIZEY 16
#define FONTBORDER 1
#define FONTSPACE 6
#define FONTCHARSX 6

#include <fstream.h>

#include "..\xavstuff\h\pcx.h"

unsigned char TempBuffer[320*200];

PCXHeader PCXFile;

void main()
 {
 GetPCXPicture(&PCXFile,"fontcut.pcx",TempBuffer);

 // CUT FONT

 fstream FONTFILE("..\\demo\\FONT.H",ios::out|ios::binary|ios::trunc);

 FONTFILE << "// FONT INCLUDE FILE ;-)" << endl;

 FONTFILE << "\n\nunsigned char FONT16[]={\n";

 char Chars[]="ABCDEFGHIJKLMNOPQRSTUVWXYZ";

 for (int a=0;a<NUMSYMBOLS;a++)
  {
  for (int y=0;y<FONTSIZEY;y++)
   {
   for (int x=0;x<FONTSIZEX;x++)
    {
    FONTFILE << (int)TempBuffer[FONTBORDER+x+(y+FONTBORDER)*320+((FONTBORDER*2)+FONTSIZEX+
                                FONTSPACE)*(a%FONTCHARSX)+
                                ((FONTBORDER*2)+FONTSIZEY+FONTSPACE)*
                                (a/FONTCHARSX)*320] << ",";
    }
   }
  FONTFILE << "\n";
  }


 FONTFILE << "};";

 }

