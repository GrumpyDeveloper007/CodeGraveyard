#define ScreenX 640
#define ScreenY 480
unsigned char *Screen=(unsigned char *)0x0a0000;
char Path[]="gfx\\";

// Ground Fire V1.3
//
// Coded by Dark Elf / Phobia

// GFX engine
//
// pipelined -
// MainScreenB -- Back buffer updated when screen location changes
// MainScreen -- Virtual buffer updated when backbuffer changes, and
//               when any object changes (moving/nonmoving) (the backbuffer
//               is copyied and objects are plot on

// Keyboard Constants -
#define arrowup 72
#define arrowdown 80
#define arrowleft 75
#define arrowright 77
#define escape 27

//#include <i86.h>
//#include <bios.h>
#include <conio.h>
//#include <fstream.h>
#include <iostream.h>
#include <stdlib.h>
#include <time.h>

 clock_t Start,End;
 float Frame=0;


#include "\coding\include\vesa\vesa.h"
#include "\coding\include\other\file.h"   // My own direct and fast file io
#include "\coding\include\other\pcx.h"
#include "\coding\include\std\std.h"
extern unsigned char Font1Set[];
extern unsigned char Font1Data[];
extern unsigned char Font2Data[];
#include "GRAPHICS.h"
//#include "MEM.CPP"

//#include "assem.h"

unsigned char Pal[256*3];
unsigned char *TextScreen=(unsigned char *) 0x0b8000;
unsigned char *Arr;
int Key;

// Collision map
unsigned long *CollisionList;
// size is total map size(backX*MapX) /8
//unsigned char *CollisionTable; // allocated in map reader
//int CollisionX,CollisionY; // not really needed
//int collX=8; // Number of pixels per collision entry
//int collY=8;

int MapX,MapY,OMapX,OMapY;
// list of pointers
unsigned char *MapBackList[255];    // all the background blocks
int EndBack=0;                      // the number of back gfx loaded
int MapSizeX,MapSizeY;

// Non-moving object list
MovePlotObject *NonMoveObjectList[255];
int MaxNMoveObject=0;
int NMoveObjectFlag=0;

int BackX=32;
int BackY=32;



// WIN -- destnation (Back Buffer win)
void PlotObjectM(MovePlotObject *OBJ,WindowType *WIN)
 {
 unsigned char  *Source=OBJ->GFXPointer;
 if (OBJ->MaxFrames!=1)
  {
  long *TempArray=(long*)Source;
  Source=(unsigned char *)TempArray[OBJ->Frame];
  }
 // Check if on screen
 if ( OBJ->XPos+OBJ->SizeX<0 || OBJ->XPos>WIN->SizeX ||
      OBJ->YPos+OBJ->SizeY<0 || OBJ->YPos>WIN->SizeY )
   return;
 unsigned char  *Destnation=WIN->Virtual+OBJ->XPos+OBJ->YPos*WIN->SizeX;
 long            DModulo=WIN->SizeX-OBJ->SizeX;
 long            SModulo=0;
 long SizeX=OBJ->SizeX;
 long SizeY=OBJ->SizeY;
 unsigned char Byte;

 int i,t;
 // Check for clipping
 if ( OBJ->XPos<0 || OBJ->XPos+OBJ->SizeX>WIN->SizeX ||
      OBJ->YPos<0 || OBJ->YPos+OBJ->SizeY>WIN->SizeY )
  {
  if (OBJ->XPos<0)
    {
    SizeX=SizeX+OBJ->XPos;
    Source=Source-OBJ->XPos;
    Destnation-=OBJ->XPos;
    }
   if (OBJ->XPos+OBJ->SizeX>WIN->SizeX )
    SizeX=SizeX- ((OBJ->XPos+OBJ->SizeX)-WIN->SizeX);
  if (OBJ->YPos<0)
    {
    SizeY=SizeY+OBJ->YPos;
    Source=Source- (OBJ->YPos*OBJ->SizeX);
    Destnation-=(OBJ->YPos*WIN->SizeX);
    }
   if (OBJ->YPos+OBJ->SizeY>WIN->SizeY)
    SizeY=SizeY- ((OBJ->YPos+OBJ->SizeY)-WIN->SizeY);
  SModulo=OBJ->SizeX-SizeX;
  DModulo=WIN->SizeX-SizeX;
  }
 WIN->Changed=1;
 for(i=0;i<SizeY;i++)
  {
  for(t=0;t<SizeX;t++)
   {
   Byte=*Source++;
   if (Byte!=0)
     *Destnation=Byte;
   Destnation++;
   }
  Destnation+=DModulo;
  Source+=SModulo;
  }
 }







////////////////////////////////
void AddNMoveObjects()
 {
 int i=MaxNMoveObject;
 unsigned char *TempP;
 NonMoveObjectList[i]=(MovePlotObject *) calloc(sizeof(MovePlotObject),1);
 NonMoveObjectList[i]->XPos=128;
 NonMoveObjectList[i]->YPos=128;
 NonMoveObjectList[i]->SizeX=32;
 NonMoveObjectList[i]->SizeY=32;
 NonMoveObjectList[i]->MaxFrames=7;
 long *TempArray=(long*)calloc(8,4);

 TempP=(unsigned char *)calloc(32*32,1);
 TempArray[0]=(long)TempP;
 GetPCXPicture("gfx\\peon000.PCX", TempP);

 TempP=(unsigned char *)calloc(32*32,1);
 TempArray[1]=(long)TempP;
 GetPCXPicture("gfx\\peon001.PCX", TempP);

 TempP=(unsigned char *)calloc(32*32,1);
 TempArray[2]=(long)TempP;
 GetPCXPicture("gfx\\peon002.PCX", TempP);

 TempP=(unsigned char *)calloc(32*32,1);
 TempArray[3]=(long)TempP;
 GetPCXPicture("gfx\\peon003.PCX", TempP);

 TempP=(unsigned char *)calloc(32*32,1);
 TempArray[4]=(long)TempP;
 GetPCXPicture("gfx\\peon004.PCX", TempP);

 TempP=(unsigned char *)calloc(32*32,1);
 TempArray[5]=(long)TempP;
 GetPCXPicture("gfx\\peon005.PCX", TempP);

 TempP=(unsigned char *)calloc(32*32,1);
 TempArray[6]=(long)TempP;
 GetPCXPicture("gfx\\peon006.PCX", TempP);

 TempP=(unsigned char *)calloc(32*32,1);
 TempArray[7]=(long)TempP;
 GetPCXPicture("gfx\\peon007.PCX", TempP);

 NonMoveObjectList[i]->GFXPointer=(unsigned char *)TempArray;
 MaxNMoveObject++;

 unsigned char *TempP2;
 i=MaxNMoveObject;
 NonMoveObjectList[i]=(MovePlotObject *)calloc(sizeof(MovePlotObject),1);
 NonMoveObjectList[i]->XPos=128;
 NonMoveObjectList[i]->YPos=256;
 NonMoveObjectList[i]->SizeX=128;
 NonMoveObjectList[i]->SizeY=128;
 NonMoveObjectList[i]->MaxFrames=2;

 long *TempArray2=(long*)calloc(3,4);


 TempP2=(unsigned char *)calloc(128*128,1);
 TempArray2[0]=(long)TempP2;
 GetPCXPicture("gfx\\castle.PCX", TempP2);

 TempP2=(unsigned char *)calloc(128*128,1);
 TempArray2[1]=(long)TempP2;
 GetPCXPicture("gfx\\town000.PCX", TempP2);

 TempP2=(unsigned char *)calloc(128*128,1);
 TempArray2[2]=(long)TempP2;
 GetPCXPicture("gfx\\town001.PCX", TempP2);

 NonMoveObjectList[i]->GFXPointer=(unsigned char *)TempArray2;
 MaxNMoveObject++;
 }



void UpdateNonMoveObject(WindowType *WIN,int MapX,int MapY)
 {
 MovePlotObject Temp;
 int i=0,t;
 while (i<MaxNMoveObject)
  {
  if (NonMoveObjectList[i]!=0)
   {
   Temp.XPos=NonMoveObjectList[i]->XPos-MapX;
   Temp.YPos=NonMoveObjectList[i]->YPos-MapY;
   Temp.SizeX=NonMoveObjectList[i]->SizeX;
   Temp.SizeY=NonMoveObjectList[i]->SizeY;
   Temp.MaxFrames=NonMoveObjectList[i]->MaxFrames;
   Temp.Frame=NonMoveObjectList[i]->Frame;

   Temp.GFXPointer=NonMoveObjectList[i]->GFXPointer;
   PlotObjectM(&Temp,WIN);
   NonMoveObjectList[i]->OFrame=NonMoveObjectList[i]->Frame;
   i++;
   }
  }
 }


//////////////////////////////////////////////////////////////////////////

// Find next numeric string
int ScanNext(void *StringP)
 {
 unsigned char *String=(unsigned char *)StringP;
 int i=0;
 // Get Length of number
 while (String[i]>='0' && String[i]<='9')
   i++;
 while (String[i]<'0' || String[i]>'9')
   i++;
 return i;
 }

// Convert numeric string to int
int GetNumber(void *StringP)
 {
 char *String=(char *)StringP;
 int i=0,t,num=0;
 // Get Length of number
 while (String[i]>='0' && String[i]<='9')
   i++;
 for (t=0;t<i;t++)
  {
  num=num*10;
  num=num+(String[t]-48);
  }
  return num;
 }
// Read upto 0x0a hex into buffer  
int ReadLine(int FileHandle,unsigned char *LineBuffer)
 {
 int i=0,length=0;
 unsigned char *Byte,ByteX;
 Byte=&ByteX;

 ReadFile(FileHandle,1,Byte);
 LineBuffer[i]=*Byte;
 i++;
 while (ByteX!=0x0d)
  {
  ReadFile(FileHandle,1,Byte);
  LineBuffer[i]=*Byte;
  length++;
  i++;
  }
 ReadFile(FileHandle,1,Byte); // This will be 0a
 LineBuffer[i]=*Byte;
 return length;
 }
// 
int CheckValidLine(char *FileBuffer,int Length)
 {
 int i=0,flag=0;
 while(i<Length && flag<2)
  {
  if (FileBuffer[i]=='[')
    flag++;
  if (FileBuffer[i]=='[')
    flag++;
  }
 if (flag==2)
  return (0==0);
 else
  return (1==0);
 }


unsigned char *MapPointer;
void ReadMap()
 {
 int FileHandle,CurrentX;
 int Length;
 int Line=1;
 unsigned char FileBuffer[1024];
 FileHandle=OpenFile("MAP.DAT",FRead);
 if (!FileHandle)
  {
  cout << "Error reading file"<<endl;
  }
 else
  {
//  cout << "Reading map file" <<endl;
  // Get map size
  ReadLine(FileHandle,FileBuffer);
  if (strncmp((char *)FileBuffer,"MapSize",7)==0) // Line should be MapSize xxxx,xxxx
   {
   CurrentX=8;
   MapSizeX=GetNumber(FileBuffer+CurrentX);
   //Scan Next
   CurrentX+=ScanNext(FileBuffer+CurrentX);
   MapSizeY=GetNumber(FileBuffer+CurrentX);
   // Alloc Map
   MapPointer=(unsigned char*)calloc(MapSizeX*MapSizeY,1);

//   CollisionX=MapSizeX*BackX/8;
//   CollisionY=MapSizeY*BackY/8;
//   CollisionTable=(unsigned char*)calloc(CollisionX*CollisionY,1);

   //////////////////////////////////////////// Read Map data
   int Cx=0,Cy=0,i;
   Length=ReadLine(FileHandle,FileBuffer);
   Line++;
   while (strncmp( (char*)FileBuffer,"EndMap",6)!=0 && FileBuffer[0]!=0x0d)
    {
    if (FileBuffer[0]='[')
     { // If Valid line
     //cout << "Line " <<Line << " Processed ";
     CurrentX=1;
     Cx=0;
     while (Cx<MapSizeX && FileBuffer[CurrentX]!=']'&& Length>CurrentX)
      {
      MapPointer[Cx+Cy*MapSizeX]=GetNumber(FileBuffer+CurrentX);
      Cx++;
      CurrentX+=ScanNext(FileBuffer+CurrentX);
      }
     Cy++;
     }
    //cout <<" X Size:" <<Cx << endl;
    Length=ReadLine(FileHandle,FileBuffer);
    Line++;
    }
   }
  else
   {
   //cout << "Invalid Map Line " <<Line <<" (Header)"<<endl;
   }
  }
 CloseFile(FileHandle);
 }

void ReadBackList()
 {
 int FileHandle;
 int Current=0;

 unsigned char FileBuffer[1024];
 unsigned char FileName2[14+4];
 unsigned char *FileName=FileName2+4;
 FileName2[0]='g';
 FileName2[1]='f';
 FileName2[2]='x';
 FileName2[3]='\\';
 FileHandle=OpenFile("BACK.DAT",FRead);
 if (!FileHandle)
  {
   //cout << "Error reading file"<<endl;
   }
 else
  {
  // << "Reading back file" <<endl;
  // Get map size
  ReadLine(FileHandle,FileBuffer);
  if (strncmp((char *)FileBuffer,"BackData",8)==0)
   {
   ReadLine(FileHandle,FileBuffer);
   while (strncmp( (char*)FileBuffer,"EndBack",7)!=0 && FileBuffer[0]!=0x0d)
    {
    if (FileBuffer[0]=='[')
     {
     int i=0;
     // Copy file name (no extension allowed)
     while (i<8 && FileBuffer[i+1]!='.' && FileBuffer[i+1]!=']' &&
                   FileBuffer[i+1]!=0x0d)
      {
      FileName[i]=FileBuffer[i+1];
      i++;
      }
     FileName[i]='.'; // Tempory, while graphics are loaded as PCX files
     FileName[i+1]='P';
     FileName[i+2]='C';
     FileName[i+3]='X';
     FileName[i+4]=0;
     // Load graphic in to memory using PCX loader (will use PAK files later)
     // Allocate memory
     MapBackList[Current]=(unsigned char *)calloc(BackX*BackY,1);
     GetPCXPicture((char*)FileName2,MapBackList[Current]);
     EndBack++;
     Current++;
     //cout << "Picture loaded " << endl;
     }
    ReadLine(FileHandle,FileBuffer);
    }
   }
  }
 CloseFile(FileHandle);
 }

// Load Anim
void ReadAnim()
 {
 int FileHandle;
 long *TempArray;
 unsigned char *TempP;
 int CurrentX=0;
 int AnimX,AnimY;
 int i=0,t;
 AnimFrameType *Current;

 unsigned char FileBuffer[1024];
 unsigned char FileName2[13+4];
 unsigned char *FileName=FileName2+4;
 FileName2[0]='G';
 FileName2[1]='F';
 FileName2[2]='X';
 FileName2[3]='\\';
 FileHandle=OpenFile("ANIM.DAT",FRead);
 if (!FileHandle)
  {
   //cout << "Error reading file"<<endl;
  }
 else
  {
  //cout << "Reading Anim file" <<endl;
  // Read header
  ReadLine(FileHandle,FileBuffer);
  while (strncmp( (char*)FileBuffer,"EndAnim",7)!=0 && FileBuffer[0]!=0x0d)
   {
   if (strncmp((char *)FileBuffer,"AnimData",8)==0)
    {
    NonMoveObjectList[i]=(MovePlotObject*) calloc(sizeof(MovePlotObject),1);
//    NonMoveObjectList[i]=new MovePlotObject;

    //cout << "Reading Anim " <<i <<endl;
    CurrentX=9;
    AnimX=GetNumber(FileBuffer+CurrentX);
    NonMoveObjectList[i]->SizeX=AnimX;

    CurrentX+=ScanNext(FileBuffer+CurrentX);
    AnimY=GetNumber(FileBuffer+CurrentX);
    NonMoveObjectList[i]->SizeY=AnimY;

    CurrentX+=ScanNext(FileBuffer+CurrentX);
    NonMoveObjectList[i]->XPos=GetNumber(FileBuffer+CurrentX);

    CurrentX+=ScanNext(FileBuffer+CurrentX);
    NonMoveObjectList[i]->YPos=GetNumber(FileBuffer+CurrentX);

    CurrentX+=ScanNext(FileBuffer+CurrentX);
    NonMoveObjectList[i]->MaxFrames=GetNumber(FileBuffer+CurrentX)-1;

    TempArray=(long*)calloc(NonMoveObjectList[i]->MaxFrames+1,4);
    NonMoveObjectList[i]->GFXPointer=(unsigned char *)TempArray;

    // Read Anim frames
    ReadLine(FileHandle,FileBuffer);
    int FileCount=0;
    while (FileBuffer[0]=='[' && FileCount<=NonMoveObjectList[i]->MaxFrames)
     {
     t=0;
     // Copy file name (no extension allowed)
     while (t<8 && FileBuffer[t+1]!='.' && FileBuffer[t+1]!=']' &&
                    FileBuffer[t+1]!=0x0d)
      {
      FileName[t]=FileBuffer[t+1];
      t++;
      }
     FileName[t]='.'; // Tempory, while graphics are loaded as PCX files
     FileName[t+1]='P';
     FileName[t+2]='C';
     FileName[t+3]='X';
     FileName[t+4]=0;
     // Load graphic in to memory using PCX loader (will use PAK files later)

     // Allocate memory
     TempP=(unsigned char*) calloc(AnimX*AnimY,1);
     TempArray[FileCount]=(long)TempP;


     GetPCXPicture((char*)FileName2,TempP);
     //cout << "Frame done" <<endl;
     ReadLine(FileHandle,FileBuffer);
     FileCount++;
     }
    i++;
    }
   else
    {
     ReadLine(FileHandle,FileBuffer);
    }
   }
  }
 MaxNMoveObject=i;
 CloseFile(FileHandle);
 }



// Plot All back objects to current Map coords
void PlotBackToScreen(WindowType &WIN,int x,int y)
 {
 BackPlotObject OBJ;
 BackPlotObject *OBJP=&OBJ;

 OBJ.SizeX=BackX;
 OBJ.SizeY=BackY;
 int Cx2=0,Cy=0,Cx;
 int Sx,Sy,Sx2;
 Sx2=x/BackX;Sy=y/BackY; // Get Map address

 if ( (x%BackX) >0)
  Cx2=Cx2-(x%BackX);
 if ( (y%BackY) >0)
   Cy=Cy-(y%BackY);
 int i,t;

 while(Cy<WIN.SizeX)
  {
  OBJ.YPos=Cy;
  Cx=Cx2;
  Sx=Sx2;
  while (Cx<WIN.SizeX)
   {
   OBJ.XPos=Cx;
   OBJ.GFXPointer= MapBackList[ (MapPointer[Sx+Sy*MapSizeX]) ];
   PlotObjectCLIP(OBJP,&WIN);
   Sx++;
   Cx+=BackX;
   }
  Sy++;
  Cy+=BackX;
  }

 }


///////////////////////////////////////////////////////////////////////////

void main()
 {
  OMapX=-1,OMapY=-1;
  MapX=0;MapY=0;

 ReadBackList();
 ReadMap();
 ReadAnim();
// AddNMoveObjects();


 InitVESA();
 ModeInfoBlock SetMode;
  SetMode.NumberOfPlanes=1;
  SetMode.BitsPerPixel=8;
  SetMode.XResolution=ScreenX;
  SetMode.YResolution=ScreenY;
  SetMode.MemoryModel=MODEL_PACKED;
 if (!SetVideo(&SetMode))
   {
   //cout << "Error with video ";
   return;
   }
  Screen=VESAScreenPtr;

 GetPCXPalette("gfx\\pic.pcx",Pal);
 SetPalette(Pal,0,256);

 WindowType *MenuScreen=NewWindow(ScreenX,ScreenY,1,
        (unsigned char *)calloc(ScreenX*ScreenY,1),Screen);
//  WindowType *MenuScreen=new WindowType;
// MenuScreen->SizeX=ScreenX;
// MenuScreen->SizeY=ScreenY;
// MenuScreen->Changed=1;
// MenuScreen->Virtual=(unsigned char *)calloc((ScreenX)*(ScreenY),1);
// MenuScreen->Destnation=Screen;
  ClearWindow(MenuScreen);
  PlotWindow(MenuScreen); // Clears video buffer
 RemoveWindow(MenuScreen);

 WindowType *MainScreen=NewWindow(192*2,192*2,1,
        (unsigned char *)calloc((192*2)*(192*2),1),Screen);

 WindowType *MainScreenB=new WindowType;
 MainScreenB->SizeX=192*2;
 MainScreenB->SizeY=192*2;
 MainScreenB->Changed=1;
 MainScreenB->Virtual=(unsigned char *)calloc((192*2)*(192*2),1);
 MainScreenB->Destnation=MainScreen->Virtual;


 WindowType *MenuBar=NewWindow(200,480,1,
        (unsigned char *)calloc(200*480,1),Screen+400);
 ClearWindow(MenuBar);

 BitMapType PictureA;
 PictureA.XPos=10;
 PictureA.YPos=10;
 PictureA.Name="gfx\\memu.pcx";
 PictureA.GFXPointer=0;

 Key='a';
 Start=clock();
 Frame=0;
  PutBitMap(MenuBar,&PictureA);
  PlotButton(MenuBar,10,10,"This is a string",Font2Data);



 while (Key!=escape)
  {

  if (kbhit())
   {
   Key=getch();
   if ( (Key=='q' || Key=='Q') && NonMoveObjectList[0]->Frame<
                NonMoveObjectList[0]->MaxFrames)
     {
     NonMoveObjectList[0]->Frame++;
     NMoveObjectFlag=1;
     }
   if ( (Key=='a' || Key=='A') && NonMoveObjectList[0]->Frame>0)
     {
     NonMoveObjectList[0]->Frame--;
     NMoveObjectFlag=1;
     }

   if ( (Key=='w' || Key=='W') && NonMoveObjectList[1]->Frame<
                NonMoveObjectList[1]->MaxFrames)
     {
     NonMoveObjectList[1]->Frame++;
     NMoveObjectFlag=1;
     }

   if ( (Key=='s' || Key=='S') && NonMoveObjectList[1]->Frame>0)
     {
     NonMoveObjectList[1]->Frame--;
     NMoveObjectFlag=1;
     }
     
   if (Key==0)
    {
    Key=getch();
    if (Key==arrowup && MapY>0)
      MapY--;
    if (Key==arrowdown)
      MapY++;
    if (Key==arrowleft && MapX>0)
      MapX--;
    if (Key==arrowright)
      MapX++;
    }
   }
//  ClearWindow(MainScreen);
  if (MapX!=OMapX || MapY!=OMapY || NMoveObjectFlag==1)
    {
    NMoveObjectFlag=0;
    PlotBackToScreen(*MainScreenB,MapX,MapY);
    UpdateNonMoveObject(MainScreenB,MapX,MapY);
    FillBox(MainScreenB,50,50,70,76,245);
    BoxCLIP(MainScreenB,0,0,MapX+10,MapY+10,255);
    CopyWindow(MainScreenB,MainScreen);
    MainScreen->Changed=1;
    OMapX=MapX;
    OMapY=MapY;
    }

//  PlotWindows();
  PlotWindow(MainScreen);
  PlotWindow(MenuBar);
  Frame++;
  }
 End=clock();

 KillVESA();
 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By Dark Elf / Phobia"<<endl;
 }
