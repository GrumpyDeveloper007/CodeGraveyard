#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <direct.h>
#include <string.h>
#include <bios.h>
#include <fstream.h>

#include "h\predefs.h"    // include defs of external funcs + vars
#include "h\macros.h"

unsigned char Pattern[64*5*8];  // pattern size 64 rows of 8 chans
                                // a chan is
                                // Byte 0 - Note
                                // Byte 1 - Instrument
                                // Byte 2 - Volume
                                // Byte 3 - Effect (0-Z) 36 values
                                // Byte 4 - Param
char EffectsList[]="01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";

char NoteList[(12*9)][4]={"C-0","C#0","D-0","D#0","E-0","F-0","F#0","G-0","G#0","A-0","A#0","B-0",
                    "C-1","C#1","D-1","D#1","E-1","F-1","F#1","G-1","G#1","A-1","A#1","B-1",
                    "C-2","C#2","D-2","D#2","E-2","F-2","F#2","G-2","G#2","A-2","A#2","B-2",
                    "C-3","C#3","D-3","D#3","E-3","F-3","F#3","G-3","G#3","A-3","A#3","B-3",
                    "C-4","C#4","D-4","D#4","E-4","F-4","F#4","G-4","G#4","A-4","A#4","B-4",
                    "C-5","C#5","D-5","D#5","E-5","F-5","F#5","G-5","G#5","A-5","A#5","B-5",
                    "C-6","C#6","D-6","D#6","E-6","F-6","F#6","G-6","G#6","A-6","A#6","B-6",
                    "C-7","C#7","D-7","D#7","E-7","F-7","F#7","G-7","G#7","A-7","A#7","B-7",
                    "C-8","C#8","D-8","D#8","E-8","F-8","F#8","G-8","G#8","A-8","A#8","B-8"};

struct Sample
 {
 unsigned long  AweAddress;	// Address of Sample in AWE RAM
 unsigned long  Length;		// Address of Sample End doubles as loop end!
 unsigned long  Start;		// Address of Loop Start
 unsigned long  NoLoop;         // Address of No Loop Start
 unsigned char  Volume;		// Volume
 char Name[23];                 // Instrument name, (FILENAME FOR NOW)
 };

char KeyList[]="zsxdcvgbhnjmq2w3er5t6y7ui9o0p[=]";

int CurrentSample=0;
int FreeRam=512*1024;
long AweAddress=0x200000;

#define MAXINST 153

Sample SampleList[MAXINST]; // 128 instruments maximum

FILELIST DirList[10];

void ClearPattern()
 {
 for (int row=0;row<64;row++)
  for (int chan=0;chan<8;chan++)
   {
   Pattern[chan*5+row*8*5+0]=255; // no note
   Pattern[chan*5+row*8*5+2]=255; // no volume
   Pattern[chan*5+row*8*5+3]=255; // no effect
   }
 }

int Ret,FileListPos;
char FileName[13];      // filename selected in dir
long FileSize;

int CursorY=0,CursorX=0,ScrollOff=0;
int OctaveAdj=2;

void RedrawScreen()
 {
 int a;
 char InfoLine[200+1+PATH_MAX];       // space for info line text
 char *DirName;

 CLS();

 for (int row=0;row<16;row++)
  {
  sprintf(InfoLine,"%02i",row+ScrollOff);
  PlotText(0,100+6*row,InfoLine,15);
  PlotText(8+16*4+4*15*4,100+6*row,InfoLine,15);
  for (int chan=0;chan<5;chan++)
   {
   if (Pattern[chan*5+(row+ScrollOff)*8*5+0]==255)
    sprintf(InfoLine," --- -- ");
   else
    sprintf(InfoLine," %s %02i ",NoteList[Pattern[chan*5+(row+ScrollOff)*8*5+0]],(int)Pattern[chan*5+(row+ScrollOff)*8*5+1]);
   if (row==CursorY && CursorX==chan*3)
    PlotText(9+4*15*chan,100+6*row,InfoLine,13);
   else
    PlotText(9+4*15*chan,100+6*row,InfoLine,15);
   if (Pattern[chan*5+(row+ScrollOff)*8*5+2]=255)
    sprintf(InfoLine,"-- ");
   else
    sprintf(InfoLine,"%02i",(int)Pattern[chan*5+(row+ScrollOff)*8*5+2]);
   if (row==CursorY && CursorX==chan*3+1)
    PlotText(6+9*4+4*15*chan,100+6*row,InfoLine,13);
   else
    PlotText(6+9*4+4*15*chan,100+6*row,InfoLine,15);
   if (Pattern[chan*5+(row+ScrollOff)*8*5+3]=255)
    sprintf(InfoLine,"---");
   else
    sprintf(InfoLine,"%c%02i",EffectsList[Pattern[chan*5+(row+ScrollOff)*8*5+3]],(int)Pattern[chan*5+(row+ScrollOff)*8*5+4]);
   if (row==CursorY && CursorX==chan*3+2)
    PlotText(6+12*4+4*15*chan,100+6*row,InfoLine,13);
   else
    PlotText(6+12*4+4*15*chan,100+6*row,InfoLine,15);
   }
  }

 for (a=0;a<Ret;a++)
  {
  if (DirList[a].Directory)
   sprintf(InfoLine,"[%-13s %10li]",DirList[a].Name,DirList[a].Size);
  else
   sprintf(InfoLine," %-13s %10li ",DirList[a].Name,DirList[a].Size);
  PlotText(0,a*6,InfoLine,15);
  }

 PlotText(4*27,0,"|",15);       // Arrow UP
 PlotText(4*27,6,"`",15);       // Arrow DOWN

 DirName=getcwd(NULL,0);
 if (DirName!=NULL)
  {
  sprintf(InfoLine,"DIRECTORY : %s",DirName);
  PlotText(0,64,InfoLine,15);
  free (DirName);
  }
 else
  PlotText(0,64,"DIRECTORY :",15);
 PlotText(0,70,"FILENAME  : ",15);

 PlotText(0,78,"<LOAD MODULE>",13);
 PlotText(0,84,"<LOAD SAMPLE>",15);

 sprintf(InfoLine,"FREE RAM : %i",FreeRam);
 PlotText(130,0,InfoLine,15);

 sprintf(InfoLine,"Current Instrument %i,%s",CurrentSample,SampleList[CurrentSample].Name);
 PlotText(130,6,InfoLine,15);

 HideMouse();
 UpdateScreen();
 ShowMouse();
 }

void TestPlay(Sample *,int,int);
int LoadSamples(Sample *,int);

void main()
 {
 int a;
 char *InitialDir,*Ptr;

 if (LoadSamples(&SampleList[0],MAXINST)!=1)
  return;

 char InfoLine[200];       // space for info line text

 InitialDir=getcwd(NULL,0);     // get current directory for returning

 FileListPos=0;

 InitEMU(0x620);        // Base Port Fixed Should Be Read From CMDLine (ENV)
 ResetEMU();
 InitVideo();

 if(InitMouse()!=0) // mouse init error
  {
  KillVideo();
  return;
  }

 ClearPattern();

 chdir("C:\\SCR");      // change directory

 Ret=GetDirList("*.*",&DirList[0],10,FileListPos);

 for (a=0;a<10;a++)
  AddZone(0,0+4*26,a*6,a*6+6);  // create file select zones

 AddZone(4*27,4*27+4*1,0*6,0*6+6);  // create arrow up zone
 AddZone(4*27,4*27+4*1,1*6,1*6+6);  // create arrow down zone

 AddZone(0,0+4*13,78,78+6);  // create load module zone
 AddZone(0,0+4*13,84,84+6);  // create load sample zone

 RedrawScreen();

 ShowMouse();

 int FileNum;

 while (!cbd.right_button)
  {
  if (_bios_keybrd(_KEYBRD_READY)!=0)
   {
   int k1=_bios_keybrd(_KEYBRD_READ);
   int k2=k1>>8;
   k1&=255;

   if (k1 == ' ')
    {
    CursorY=0;
    ScrollOff=0;
    RedrawScreen();
    while (_bios_keybrd(_KEYBRD_READY)==0)
     {
     for (int cn=0;cn<5;cn++)
      {
      if (Pattern[cn*5+(CursorY+ScrollOff)*8*5+0]!=255)
       TestPlay(&SampleList[Pattern[cn*5+(CursorY+ScrollOff)*8*5+1]],0xc000+170*(Pattern[cn*5+(CursorY+ScrollOff)*8*5+0]),cn);
      }
     if (CursorY<15)
      CursorY++;
     else
      if (ScrollOff<48)
       ScrollOff++;
      else
       {
       CursorY=0;
       ScrollOff=0;
       }
     RedrawScreen();
     }
    continue;
    }
   if (k1 == '+' && CurrentSample<MAXINST)
    {
    CurrentSample++;
    RedrawScreen();
    }
   if (k1 == '-' && CurrentSample>0)
    {
    CurrentSample--;
    RedrawScreen();
    }
   if (k1 == '{' && OctaveAdj>0)
    {
    OctaveAdj--;
    }
   if (k1 == '}' && CurrentSample<6)
    {
    OctaveAdj++;
    }
   if (k2 == 75 && CursorX>0)        // Left Cursor : Prev Note
    {
    CursorX--;
    RedrawScreen();
    }
   if (k2 == 77 && CursorX<14)        // Right Cursor : Next Note
    {
    CursorX++;
    RedrawScreen();
    }
   if (k2 == 72 && CursorY>0)        // Up Cursor : Up A Row
    {
    CursorY--;
    RedrawScreen();
    continue;
    }
   if (k2 == 72 && CursorY==0 && ScrollOff>0)  // Up Cursor : Scroll up
    {                                                        
    ScrollOff--;
    RedrawScreen();
    }
   if (k2 == 80 && CursorY<15)        // Down Cursor : Down A Row
    {
    CursorY++;
    RedrawScreen();
    continue;
    }
   if (k2 == 80 && CursorY==15 && ScrollOff<48)  // Down Cursor : Scroll Down
    {
    ScrollOff++;
    RedrawScreen();
    }
   if ((Ptr=strchr(KeyList,k1))!=NULL && k1!='\0' && CursorX%3==0) // Key : Enter current note
    {
    Pattern[(CursorX/3)*5+(CursorY+ScrollOff)*8*5+0]=OctaveAdj*12+(int)(Ptr-KeyList);  // pitch
    Pattern[(CursorX/3)*5+(CursorY+ScrollOff)*8*5+1]=CurrentSample; // instrument
    RedrawScreen();
    TestPlay(&SampleList[CurrentSample],0xc000+170*(OctaveAdj*12+(int)(Ptr-KeyList)),CursorX/3);
    }
   }
  if (cbd.mouse_event)
   {
   sprintf(InfoLine,"%i,%i",cbd.mouse_cx,cbd.mouse_dx);
   PlotText(100,100,InfoLine,15);
   HideMouse();
   UpdateScreen();
   ShowMouse();
   cbd.mouse_event=0;
   FileNum=InZones(cbd.mouse_cx,cbd.mouse_dx);  // which file was clicked
   if (FileNum>=0 && FileNum<=9 && FileNum<Ret)
    {
    if (!DirList[FileNum].Directory)
     {
     sprintf(InfoLine,"FILENAME  : %-13s",DirList[FileNum].Name);
     strcpy(FileName,DirList[FileNum].Name);
     FileSize=DirList[FileNum].Size;
     PlotText(0,70,InfoLine,15);
     HideMouse();
     UpdateScreen();
     ShowMouse();
     }
    else
     {
     FileListPos=0;
     FileName[0]='\0';
     FileSize=0;
     chdir(DirList[FileNum].Name);      // change directory
     Ret=GetDirList("*.*",&DirList[0],10,FileListPos);  // and rescan
     RedrawScreen();
     }
    }
   if (FileNum==10 && FileListPos>0)     // file list up
    {
    FileListPos--;
    Ret=GetDirList("*.*",&DirList[0],10,FileListPos);
    if (Ret<10)
     {
     FileListPos++;
     Ret=GetDirList("*.*",&DirList[0],10,FileListPos);
     }
    RedrawScreen();
    }
   if (FileNum==11)     // file list down
    {
    FileListPos++;
    Ret=GetDirList("*.*",&DirList[0],10,FileListPos);
    if (Ret<10)
     {
     FileListPos--;
     Ret=GetDirList("*.*",&DirList[0],10,FileListPos);
     }
    RedrawScreen();
    }
   if (FileNum==12)     // Load Module
    {
    TestPlay(&SampleList[0],0xe000,0);
    // do nothing
    }
   if (FileNum==13)     // Load Sample
    {
    if (FileSize!=0 && FileName[0]!='\0')       // File name valid
     {
     char *TempBuffer=new char[FileSize];

     if (TempBuffer!=NULL)
      {
      short *TempBuffer2=new short[FileSize];

      if (TempBuffer2!=NULL)
       {
       fstream File(FileName,ios::in|ios::binary);
       if (File && FileSize<=FreeRam)
        {
        File.read(TempBuffer,FileSize);
        File.close();
        SampleList[CurrentSample].AweAddress=AweAddress;
        SampleList[CurrentSample].Length=AweAddress+FileSize;
        SampleList[CurrentSample].Start=AweAddress;

        for (long a=0;a<FileSize;a++)
         TempBuffer2[a]=((short)(TempBuffer[a]))<<8;

        Transfer2Awe(FileSize,TempBuffer2,AweAddress);
        AweAddress+=FileSize;
        FreeRam-=FileSize;
        RedrawScreen();
        }
       delete TempBuffer2;
       }
      delete TempBuffer;
      }
     }
    }

   }
  }
 
 HideMouse();

 KillMouse();
 KillVideo();
 ResetEMU();

 if (InitialDir!=NULL)
  {
  chdir(InitialDir);
  free(InitialDir);
  }
 }
