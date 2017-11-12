#include <i86.h>
#include <fstream.h>
#include <conio.h>
#include <iostream.h>
#include <time.h>
#include "\coding\lee\xavstuff\h\video.h"
#include "assem.h"

#include "\coding\lee\XavStuff\h\pcx.h"
PCXHeader HeaderInfo;

const PictAName[]="PICTA.PCX";
const PictBName[]="PICTB.PCX";
const BackName[]="BACK.PCX";
const ZPictName[]="ZPICT.PCX";

unsigned char Buffer[65536];
unsigned char Pal[256*3];

const EndData=1024*512;
unsigned char DataBuffer[EndData];
unsigned char *DataBufferEnd=DataBuffer+EndData;

struct FileHeader
 {
 char Name[8]="";         // Name of file
 long Pointer;            // Pointer to file (Seek( Pointer-FileSize, End) )
 long Size;               // Size of file
 };


struct Header
 {
 char ID[8]="HEAD0000";   // Identy string
 long Version;            // Version of header

 long FileSize;           // Size of file
 long HeaderLength;       // Size of header
 };
// structure -  ...{FILEHEADER2}-{FILEHEADER1}-{HEADER}

void Copy(unsigned char *Source,unsigned char *Destnation,int Size)
 {
 for (int i=0;i<Size;i++)
  Destnation[i]=Source[i];
 }

void main()
 {
 Header File={"HEAD0000",1,0,20};
 Copy((unsigned char*)File,DataBufferEnd-20,20);

 GetPCXPicture2(&HeaderInfo,PictAName,Buffer,Pal);
 FileHeader File1={"PICTA000",0,64000};
 FileHeader File2={"PICTAPAL",0,256*3};
  

 GetPCXPicture2(&HeaderInfo,PictBName,Buffer,Pal);
 FileHeader File3={"PICTB000",0,64000};
 FileHeader File4={"PICTBPAL",0,256*3};
 
 GetPCXPicture2(&HeaderInfo,BackName,Buffer,Pal);
 FileHeader File5={"BACK0000",0,64000};

 GetPCXPicture2(&HeaderInfo,ZPictBName,Buffer,Pal);
 FileHeader File6={"ZPICT000",0,64000};
 FileHeader File7={"ZPICTPAL",0,256*3};

 }
