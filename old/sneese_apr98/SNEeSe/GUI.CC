/*

 GUI.CC - Contains all gui interface code, some stuff from helper will be moved here!

  Severly improved in terms of removing crap! Allegro now performs most of the stupid
 boring tasks, and because of this the GUI is independant of the screen layout,
 removing the need for various different checks etc.

*/

#include <fstream.h>
#include <dpmi.h>
#include <go32.h>
#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

#include <allegro.h>

#define PATH_MAX 255    // I doubt it will be any bigger

/* ------------------------- DIRECTORY STUFF ------------------------- */

#include <dir.h>
#include <unistd.h>
#include <string.h>

// This fills an array of FILELIST with file information
// from the path given, starting at file number Offset
// and with a maximum number of files of MaxLen

struct FILELIST
 {
 char Name[13];
 long Size;
 int Directory; // if 1 this is a directory
 };

FILELIST DirList[15];

int GetDirList(char *Path,FILELIST *Files,int MaxLen,int Offset)
 {
 ffblk FileInfo;
 int FilesRead=0;

 int done=findfirst(Path,&FileInfo,FA_ARCH|FA_DIREC|FA_RDONLY);
 if (done) // invalid dir ? returns -1
  return -1;

 for (int a=0;a<Offset;a++)
  {
  done=findnext(&FileInfo);
  if (done)
   return 0;
  }

 while (!done && FilesRead<MaxLen) // while more files and more wanted
  {
  strcpy(Files[FilesRead].Name,FileInfo.ff_name);
  Files[FilesRead].Size=FileInfo.ff_fsize;
  if ((FileInfo.ff_attrib&FA_DIREC)==FA_DIREC)
   Files[FilesRead].Directory=1;
  else
   Files[FilesRead].Directory=0;
  FilesRead++;
  done=findnext(&FileInfo);
  }

 return FilesRead;
 }

/* ------------------------- GUI STUFF ------------------------- */


#include "font4.h"

extern "C" char *rom_romname;
extern "C" char *rom_romfile;
extern "C" char *rom_romsize;
extern "C" char *rom_romtype;
extern "C" char *rom_romhilo;
extern "C" char *rom_sram;
extern "C" char *rom_country;

extern "C" unsigned char JOYSTICK_ENABLED;
extern "C" unsigned char JOYSTICK_ENABLED2;
extern "C" unsigned char SPC_ENABLED;
extern "C" unsigned short PC_SCREEN_MODE;
extern "C" unsigned long FRAME_SKIP; // Frames waited until refresh
extern "C" char palettechanged;

extern "C" void CopyGUIScreen();
extern "C" unsigned char *GUI_Screen;
extern "C" void Reset_CPU();
extern "C" void Reset_SPC();
extern "C" BITMAP *Allegro_Bitmap;
extern "C" BITMAP *Allegro_Bitmap_GUI;

extern "C" unsigned short ScreenX;
extern "C" unsigned short ScreenY;

extern "C" unsigned long SNES_KEY_A;
extern "C" unsigned long SNES_KEY_B;
extern "C" unsigned long SNES_KEY_X;
extern "C" unsigned long SNES_KEY_Y;
extern "C" unsigned long SNES_KEY_L;
extern "C" unsigned long SNES_KEY_R;
extern "C" unsigned long SNES_KEY_UP;
extern "C" unsigned long SNES_KEY_DOWN;
extern "C" unsigned long SNES_KEY_LEFT;
extern "C" unsigned long SNES_KEY_RIGHT;
extern "C" unsigned long SNES_KEY_START;
extern "C" unsigned long SNES_KEY_SELECT;

extern "C" unsigned long SNES2_KEY_A;
extern "C" unsigned long SNES2_KEY_B;
extern "C" unsigned long SNES2_KEY_X;
extern "C" unsigned long SNES2_KEY_Y;
extern "C" unsigned long SNES2_KEY_L;
extern "C" unsigned long SNES2_KEY_R;
extern "C" unsigned long SNES2_KEY_UP;
extern "C" unsigned long SNES2_KEY_DOWN;
extern "C" unsigned long SNES2_KEY_LEFT;
extern "C" unsigned long SNES2_KEY_RIGHT;
extern "C" unsigned long SNES2_KEY_START;
extern "C" unsigned long SNES2_KEY_SELECT;

extern "C" volatile unsigned long Timer_Counter_Profile;
extern "C" volatile unsigned long Timer_Counter_FPS;
extern "C" unsigned short PC_SCREEN_MODE;

extern PALETTE sneesepal;
extern BITMAP *sneese;
extern BITMAP *joypad;

RGB GUIPal[4]={{0,0,0,0},{63,63,63,0},{0,0,63,0},{63,63,63,0}};

void RedoBackPic();

void PlotChar(unsigned char Character,int x,int y)
 {
 int v,h;
 unsigned char *Pointer=&FontData[((long)Character)*6*8];

 for (v=0;v<8;v++)
  for (h=0;h<6;h++)
   GUI_Screen[x+h+(v+y)*320]=Pointer[h+v*6]+252;

 h=6;

 if (Character<32)      // Special case stuff (plots right hand line twice)
  {
  for (v=0;v<8;v++)
   GUI_Screen[x+h+(v+y)*320]=Pointer[h-1+v*6]+252;
  }
 else
  for (v=0;v<8;v++)
   GUI_Screen[x+h+(v+y)*320]=252;
 }

void PlotCharBorder(unsigned char Character,int x,int y)
 {
 int v,h;
 unsigned char *Pointer=&FontData[((long)Character)*6*8];

    for (v=0;v<8;v++)
        for (h=0;h<6;h++)
        {
            if(v>0)
                if(Pointer[h+(v-1)*6]==1)
                    GUI_Screen[x+h+(v+y)*320]=252;
            if(v<7)
                if(Pointer[h+(v+1)*6]==1)
                    GUI_Screen[x+h+(v+y)*320]=252;
            if(h>0)
                if(Pointer[(h-1)+v*6]==1)
                    GUI_Screen[x+h+(v+y)*320]=252;
            if(h<5)
                if(Pointer[(h+1)+v*6]==1)
                    GUI_Screen[x+h+(v+y)*320]=252;
            if(v>=0 && v<=7 && h>=0 && h<=5)
                if(Pointer[h+v*6]==1)
                    GUI_Screen[x+h+(v+y)*320]=253;
        }
}

void PlotCharBK(unsigned char Character,int x,int y)
 {
 int v,h;
 unsigned char *Pointer=&FontData[((long)Character)*6*8];

 for (v=0;v<8;v++)
  for (h=0;h<6;h++)
   GUI_Screen[x+h+(v+y)*320]=Pointer[h+v*6]+254;

 h=6;

 if (Character<32)      // Special case stuff (plots right hand line twice)
  {
  for (v=0;v<8;v++)
   GUI_Screen[x+h+(v+y)*320]=Pointer[h-1+v*6]+254;
  }
 else
  for (v=0;v<8;v++)
   GUI_Screen[x+h+(v+y)*320]=254;
 }

void PlotString(char *String,int x,int y)
 {
 while (*String!=0)
  {
  PlotChar(*String++,x,y);
  x+=7;
  }
 }

void PlotStringBorderC(char *String,int x,int y)
{
    int len;

    len=strlen(String);

    x=x-((len*5)>>1);

    while (*String!=0)
    {
        PlotCharBorder(*String++,x,y);
        x+=5;
    }
}

void PlotStringBK(char *String,int x,int y)
 {
 while (*String!=0)
  {
  PlotCharBK(*String++,x,y);
  x+=7;
  }
 }

void PlotWindow(int x,int y,int w,int h)
 {
 int a=0,b=0;

 PlotChar(1,x,y);       // Plot Top Left Tile
 for (a=1;a<=w;a++)
  PlotChar(2,x+a*7,y);      // Plot Top Middle Tiles
 PlotChar(3,x+(w+1)*7,y);   // Plot Top Right Tile

 y+=8;

 for (b=0;b<h;b++)
  {
  PlotChar(4,x,y);      // Plot Middle Left Tile
  for (a=1;a<=w;a++)
   PlotChar(' ',x+a*7,y);       // Plot Space
  PlotChar(5,x+(w+1)*7,y);  // Plot Middle Right Tile
  y+=8;
  }

 PlotChar(6,x,y);       // Plot Bottom Left Tile
 for (a=1;a<=w;a++)
  PlotChar(7,x+a*7,y);      // Plot Bottom Middle Tiles
 PlotChar(8,x+(w+1)*7,y);   // Plot Bottom Right Tile
 }

#define NUM_OPTIONS 6

char Options[NUM_OPTIONS][17]={"Resume emulation",
                               "Reset emulation ",
                               "Load rom        ",
                               "Configure       ",
                               "Rom information ",
                               "Exit SNEeSe :(  "};

void UpdateGUI(int Selected)
 {
 clear(Allegro_Bitmap_GUI);
 PlotWindow(0,0,16,NUM_OPTIONS);
 for (int a=0;a<NUM_OPTIONS;a++)
  PlotString(Options[a],7,(a+1)*8);
 PlotStringBK(Options[Selected],7,(Selected+1)*8);
 PlotWindow(10,160,32,3);
 PlotString(" Code by  Lee Hammerton (SnaX) ",17,168);
 PlotString("          Charles Bilyue       ",17,176);
 PlotString("          Santeri Saarimaa     ",17,184);

 vsync();
  if (sneese!=NULL)
   stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
 draw_sprite(Allegro_Bitmap,Allegro_Bitmap_GUI,0,0);
 }

void UpdateFileWindow(int SelFile,int NumFiles)
 {
 char TempString[15];

 PlotWindow(85,0,14,15);
 for (int a=0;a<NumFiles;a++)
  {
  strcpy(TempString,"[");
  strcat(TempString,DirList[a].Name);
  strcat(TempString,"]");
  if (DirList[a].Directory==1)
   {
   if (a==SelFile)
    PlotStringBK(TempString,92,(a+1)*8);
   else
    PlotString(TempString,92,(a+1)*8);
   }
  else
   {
   if (a==SelFile)
    PlotStringBK(DirList[a].Name,92,(a+1)*8);
   else
    PlotString(DirList[a].Name,92,(a+1)*8);
   }
  }

 vsync();
  if (sneese!=NULL)
   stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
 draw_sprite(Allegro_Bitmap,Allegro_Bitmap_GUI,0,0);
 CopyGUIScreen();
 }

extern char *SRAMFileName;
extern unsigned int SaveRamLength;

int SaveSRAM(char *FileName);
int LoadSRAM(char *FileName);
int LoadROM(char *FileName);
void CreateSRAMFileName(char *FileName);

int FileWindow()
 {
 int FileListPos=0;
 int NumFiles,SelFile=0;

 NumFiles=GetDirList("*.*",&DirList[0],15,FileListPos);

 UpdateFileWindow(SelFile,NumFiles);

 while (1==1)
  {
  if (key[KEY_UP]!=0 && SelFile>0)
   {
   SelFile--;
   UpdateFileWindow(SelFile,NumFiles);
   while (key[KEY_UP]!=0);
   }
  if (key[KEY_UP]!=0 && SelFile==0 && FileListPos>0)
   {
   FileListPos--;
   NumFiles=GetDirList("*.*",&DirList[0],15,FileListPos);
   UpdateFileWindow(SelFile,NumFiles);
   while (key[KEY_UP]!=0);
   }
  if (key[KEY_DOWN]!=0 && SelFile<NumFiles-1)
   {
   SelFile++;
   UpdateFileWindow(SelFile,NumFiles);
   while (key[KEY_DOWN]!=0);
   }
  if (key[KEY_DOWN]!=0 && SelFile==14)
   {
   FileListPos++;
   NumFiles=GetDirList("*.*",&DirList[0],15,FileListPos);
   if (NumFiles<15)
    {
    FileListPos--;
    NumFiles=GetDirList("*.*",&DirList[0],15,FileListPos);
    }
   UpdateFileWindow(SelFile,NumFiles);
   while (key[KEY_DOWN]!=0);
   }
  if (key[KEY_ESC]!=0)
   {
   while (key[KEY_ESC]!=0);
   return -1;
   }
  if (key[KEY_ENTER]!=0 && DirList[SelFile].Directory==1)
   {
   chdir(DirList[SelFile].Name);
   FileListPos=0;
   SelFile=0;
   NumFiles=GetDirList("*.*",&DirList[0],15,FileListPos);
   UpdateFileWindow(SelFile,NumFiles);
   while (key[KEY_ENTER]!=0);
   }
  if (key[KEY_ENTER]!=0 && DirList[SelFile].Directory==0)
   {
   if (SRAMFileName!=NULL && SaveRamLength!=0)
    SaveSRAM(SRAMFileName);     // Ensures ram saved before loading new rom

   if (!LoadROM(DirList[SelFile].Name))
    {
    cout << "Failed To Load Cartridge Rom....Sorry!";
    return -1;
    }

   CreateSRAMFileName(DirList[SelFile].Name);

   if (SRAMFileName!=NULL && SaveRamLength!=0)
    LoadSRAM(SRAMFileName);     // This loads in the Save Ram

   while (key[KEY_ENTER]!=0);
   return 0;
   }
  }
 return -1;
 }

#define NUM_SCREEN_OPTIONS 9

char Screen_Options[NUM_SCREEN_OPTIONS][21]={"320x200x256 VGA     ",
                                             "320x200x256 VGA  FIT",
                                             "320x240x256 MODE-X  ",
                                             "256x256x256 MODE-X  ",
                                             "320x200x16b SVGA    ",
                                             "320x240x16b SVGA    ",
                                             "640x480x16b SVGA    ",
                                             "640x480x16b SVGA FIT",
					     "800x600x24b MENTAL  "};

void UpdateScreenWindow(int Selected)
 {
 PlotWindow(100,30,20,NUM_SCREEN_OPTIONS);
 for (int a=0;a<NUM_SCREEN_OPTIONS;a++)
  PlotString(Screen_Options[a],107,(a+1)*8+30);
 PlotStringBK(Screen_Options[Selected],107,(Selected+1)*8+30);
 vsync();
  if (sneese!=NULL)
   stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
 draw_sprite(Allegro_Bitmap,Allegro_Bitmap_GUI,0,0);
 CopyGUIScreen();
 }

int ScreenWindow()
{
    int CursorAt;

    CursorAt = PC_SCREEN_MODE;
    UpdateScreenWindow(CursorAt);

    while (1==1)
    {
        if (key[KEY_UP]!=0)
        {
            CursorAt--;
            if(CursorAt == -1) // so it wraps
                CursorAt = NUM_SCREEN_OPTIONS-1;
            UpdateScreenWindow(CursorAt);
            while (key[KEY_UP]!=0);
        }
        if (key[KEY_DOWN]!=0)
        {
            CursorAt++;
            if(CursorAt == NUM_SCREEN_OPTIONS) // so it wraps
                CursorAt=0;
            UpdateScreenWindow(CursorAt);
            while (key[KEY_DOWN]!=0);
        }
        if (key[KEY_ESC]!=0)
        {
            while (key[KEY_ESC]!=0);
            return -1;
        }
        if (key[KEY_ENTER]!=0)
        {
            while (key[KEY_ENTER]!=0);
            return CursorAt;
        }
    }
    return -1;         // Signify normal exit
}

#define NUM_CONFIG_OPTIONS 7

char Config_Options[NUM_CONFIG_OPTIONS][25]={"320x200x256 VGA         ",
                                             "Frameskip: ?            ",
                                             "Keyboard on player 1    ",
                                             "Keyboard on player 2    ",
                                             "Define keys for player 1",
                                             "Define keys for player 2",
                                             "Emulate SPC             "};

void UpdateConfigWindow(int Selected)
{
        PlotWindow(70,15,24,NUM_CONFIG_OPTIONS);
        for (int a=0;a<NUM_CONFIG_OPTIONS;a++)
                PlotString(Config_Options[a],77,15+(a+1)*8);
        PlotStringBK(Config_Options[Selected],77,15+(Selected+1)*8);
        vsync();
        if (sneese!=NULL)
                stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
        draw_sprite(Allegro_Bitmap,Allegro_Bitmap_GUI,0,0);
        CopyGUIScreen();
}

void SetupScreen(int);

int WaitForKeyPress()
{
    int keynum;

    while(1)
    {
        for(keynum=0;keynum<128;keynum++)
        {
            if(key[keynum])
            {
                while (key[keynum]!=0);
                return keynum;
            }
        }
    }
}

void scantotext(unsigned long scanc, char *text)
{
    text[0]=SCANCODE_TO_CAPS(scanc);
    text[1]=0;
    if(scanc==KEY_ALT) strcpy(text,"Alt");
    if(scanc==KEY_ALTGR) strcpy(text,"AltG");
    if(scanc==KEY_BACKSPACE) strcpy(text,"Bksp");
    if(scanc==KEY_CAPSLOCK) strcpy(text,"Caps");
    if(scanc==KEY_DEL) strcpy(text,"Del");
    if(scanc==KEY_DOWN) strcpy(text,"Down");
    if(scanc==KEY_END) strcpy(text,"End");
    if(scanc==KEY_ENTER) strcpy(text,"Ent");
    if(scanc==KEY_HOME) strcpy(text,"Home");
    if(scanc==KEY_INSERT) strcpy(text,"Ins");
    if(scanc==KEY_LCONTROL) strcpy(text,"LCtl");
    if(scanc==KEY_LEFT) strcpy(text,"Left");
    if(scanc==KEY_LSHIFT) strcpy(text,"LShf");
    if(scanc==KEY_LWIN) strcpy(text,"LWin");
    if(scanc==KEY_MENU) strcpy(text,"Menu");
    if(scanc==KEY_PGDN) strcpy(text,"PgDn");
    if(scanc==KEY_PGUP) strcpy(text,"PgUp");
    if(scanc==KEY_RCONTROL) strcpy(text,"RCtl");
    if(scanc==KEY_RIGHT) strcpy(text,"Rght");
    if(scanc==KEY_RSHIFT) strcpy(text,"RShf");
    if(scanc==KEY_RWIN) strcpy(text,"RWin");
    if(scanc==KEY_SPACE) strcpy(text,"Spc");
    if(scanc==KEY_TAB) strcpy(text,"Tab");
    if(scanc==KEY_UP) strcpy(text,"Up");
}

void UpdateController1Screen()
{
    char tempch[5];

    PlotWindow(25,30,24,13);

    draw_sprite(Allegro_Bitmap_GUI,joypad,39,50);

    scantotext(SNES_KEY_UP,tempch); PlotStringBorderC(tempch,70,70);
    scantotext(SNES_KEY_DOWN,tempch); PlotStringBorderC(tempch,70,104);
    scantotext(SNES_KEY_LEFT,tempch); PlotStringBorderC(tempch,52,87);
    scantotext(SNES_KEY_RIGHT,tempch); PlotStringBorderC(tempch,87,87);
    scantotext(SNES_KEY_A,tempch); PlotStringBorderC(tempch,183,85);
    scantotext(SNES_KEY_B,tempch); PlotStringBorderC(tempch,162,108);
    scantotext(SNES_KEY_X,tempch); PlotStringBorderC(tempch,159,64);
    scantotext(SNES_KEY_Y,tempch); PlotStringBorderC(tempch,136,88);
    scantotext(SNES_KEY_L,tempch); PlotStringBorderC(tempch,72,40);
    scantotext(SNES_KEY_R,tempch); PlotStringBorderC(tempch,159,40);
    scantotext(SNES_KEY_START,tempch); PlotStringBorderC(tempch,123,79);
    scantotext(SNES_KEY_SELECT,tempch); PlotStringBorderC(tempch,100,79);
}

void UpdateController2Screen()
{
    char tempch[5];

    PlotWindow(25,30,24,13);
    draw_sprite(Allegro_Bitmap_GUI,joypad,39,50);

    scantotext(SNES2_KEY_UP,tempch); PlotStringBorderC(tempch,70,70);
    scantotext(SNES2_KEY_DOWN,tempch); PlotStringBorderC(tempch,70,104);
    scantotext(SNES2_KEY_LEFT,tempch); PlotStringBorderC(tempch,52,87);
    scantotext(SNES2_KEY_RIGHT,tempch); PlotStringBorderC(tempch,87,87);
    scantotext(SNES2_KEY_A,tempch); PlotStringBorderC(tempch,183,85);
    scantotext(SNES2_KEY_B,tempch); PlotStringBorderC(tempch,162,108);
    scantotext(SNES2_KEY_X,tempch); PlotStringBorderC(tempch,159,64);
    scantotext(SNES2_KEY_Y,tempch); PlotStringBorderC(tempch,136,88);
    scantotext(SNES2_KEY_L,tempch); PlotStringBorderC(tempch,72,40);
    scantotext(SNES2_KEY_R,tempch); PlotStringBorderC(tempch,159,40);
    scantotext(SNES2_KEY_START,tempch); PlotStringBorderC(tempch,123,79);
    scantotext(SNES2_KEY_SELECT,tempch); PlotStringBorderC(tempch,100,79);
}


int AskKey(char *msg, unsigned long *whatkey, int jp)
{
    unsigned long tmp;

    PlotString(msg,39,130);

    if (sneese!=NULL)
        stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
    draw_sprite(Allegro_Bitmap,Allegro_Bitmap_GUI,0,0);
    CopyGUIScreen();

    tmp=(unsigned long)(WaitForKeyPress());

    if(tmp==KEY_ESC) return FALSE;

    *whatkey=tmp;

    if(jp==1)
        UpdateController1Screen();
    else
        UpdateController2Screen();

    return TRUE;
}

int ConfigWindow()
{
    int temp;

    strcpy(Config_Options[0],Screen_Options[PC_SCREEN_MODE]);
    Config_Options[0][20]=' ';  // Stupid thing, but who cares
    Config_Options[0][21]=' ';
    Config_Options[0][22]=' ';
    Config_Options[0][23]=' ';
    Config_Options[0][24]=0;

    if (JOYSTICK_ENABLED==0)
        strcpy(Config_Options[2],"Keyboard on player 1    ");
    else
        strcpy(Config_Options[2],"Joystick on player 1    ");

    if (JOYSTICK_ENABLED2==0)
        strcpy(Config_Options[3],"Keyboard on player 2    ");
    else
        strcpy(Config_Options[3],"Joystick on player 2    ");

    if (SPC_ENABLED==0)
        strcpy(Config_Options[6],"Skip SPC                ");
    else
        strcpy(Config_Options[6],"Emulate SPC             ");

    sprintf(Config_Options[1],"Frameskip: %ld            ",FRAME_SKIP);

    UpdateConfigWindow(0);
    int CursorAt=0;

    while (1==1)
    {
        if (key[KEY_UP]!=0)
        {
            CursorAt--;
            if(CursorAt == -1) // so it wraps
                CursorAt = NUM_CONFIG_OPTIONS-1;
            UpdateConfigWindow(CursorAt);
            while (key[KEY_UP]!=0);
        }
        if (key[KEY_DOWN]!=0)
        {
            CursorAt++;
            if(CursorAt == NUM_CONFIG_OPTIONS) // so it wraps
                CursorAt=0;
            UpdateConfigWindow(CursorAt);
            while (key[KEY_DOWN]!=0);
        }

        // For frameskip!

        if (CursorAt==1)
        {
            if (key[KEY_LEFT] && FRAME_SKIP>1)
            {
                FRAME_SKIP--;
                sprintf(Config_Options[1],"Frameskip: %ld            ",FRAME_SKIP);
                UpdateConfigWindow(CursorAt);
                while (key[KEY_LEFT]);
            }
            if (key[KEY_RIGHT] && FRAME_SKIP<9)
            {
                FRAME_SKIP++;
                sprintf(Config_Options[1],"Frameskip: %ld            ",FRAME_SKIP);
                UpdateConfigWindow(CursorAt);
                while (key[KEY_RIGHT]);
            }
        }

        if (key[KEY_ESC]!=0)
        {
            while (key[KEY_ESC]!=0);
            return -1;
        }
        if (key[KEY_ENTER]!=0)
        {
            while (key[KEY_ENTER]!=0);
            if (CursorAt==0)
            {
                while((temp=ScreenWindow())!=-1)
                {
                    SetupScreen(temp);  // Setup screen mode (PC_SCREEN_MODE is set here so following works)

                    strcpy(Config_Options[0],Screen_Options[PC_SCREEN_MODE]);
                    Config_Options[0][20]=' ';  // Stupid thing, but who cares
                    Config_Options[0][21]=' ';
                    Config_Options[0][22]=' ';
                    Config_Options[0][23]=' ';
                    Config_Options[0][24]=0;
                    if (sneese!=NULL)    // Prevent a crash if file not found!
                    {
                        set_palette(sneesepal);
                        stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
                    }
                    set_palette_range(&GUIPal[-252],252,255,1);    // Set the GUI palette up.
                    UpdateConfigWindow(0);
                }
                UpdateGUI(3);
            }
            if (CursorAt==2)
            {
                if (JOYSTICK_ENABLED!=0)
                {
                    strcpy(Config_Options[2],"Keyboard on player 1    ");
                    JOYSTICK_ENABLED=0;
                }
                else
                {
                    strcpy(Config_Options[2],"Joystick on player 1    ");
                    JOYSTICK_ENABLED=1;
                }
            }
            if (CursorAt==3)
            {
                if (JOYSTICK_ENABLED2!=0)
                {
                    strcpy(Config_Options[3],"Keyboard on player 2    ");
                    JOYSTICK_ENABLED2=0;
                }
                else
                {
                    strcpy(Config_Options[3],"Joystick on player 2    ");
                    JOYSTICK_ENABLED2=1;
                }
            }
            if (CursorAt==4)
            {
                while (key[KEY_ENTER]!=0);
                clear_keybuf();

                UpdateController1Screen();

                if(AskKey("Press key for UP    ",&SNES_KEY_UP,1)==TRUE)
                if(AskKey("Press key for DOWN  ",&SNES_KEY_DOWN,1)==TRUE)
                if(AskKey("Press key for LEFT  ",&SNES_KEY_LEFT,1)==TRUE) // this is what I call optimization :)
                if(AskKey("Press key for RIGHT ",&SNES_KEY_RIGHT,1)==TRUE)
                if(AskKey("Press key for A     ",&SNES_KEY_A,1)==TRUE)
                if(AskKey("Press key for B     ",&SNES_KEY_B,1)==TRUE)
                if(AskKey("Press key for X     ",&SNES_KEY_X,1)==TRUE)
                if(AskKey("Press key for Y     ",&SNES_KEY_Y,1)==TRUE)
                if(AskKey("Press key for L     ",&SNES_KEY_L,1)==TRUE)
                if(AskKey("Press key for R     ",&SNES_KEY_R,1)==TRUE)
                if(AskKey("Press key for START ",&SNES_KEY_START,1)==TRUE)
                if(AskKey("Press key for SELECT",&SNES_KEY_SELECT,1)==TRUE)
                {
                    PlotString("Press ESC to exit   ",39,130);
                    if (sneese!=NULL)
                        stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
                    draw_sprite(Allegro_Bitmap,Allegro_Bitmap_GUI,0,0);
                    CopyGUIScreen();

                    while (!key[KEY_ESC]);   // :)
                }
                while (key[KEY_ESC]);

                UpdateGUI(3);
                UpdateConfigWindow(CursorAt);
            }
            if (CursorAt==5)
            {
                while (key[KEY_ENTER]!=0);
                clear_keybuf();

                UpdateController2Screen();

                if(AskKey("Press key for UP    ",&SNES2_KEY_UP,2)==TRUE)
                if(AskKey("Press key for DOWN  ",&SNES2_KEY_DOWN,2)==TRUE)
                if(AskKey("Press key for LEFT  ",&SNES2_KEY_LEFT,2)==TRUE) // this is what I call optimization :)
                if(AskKey("Press key for RIGHT ",&SNES2_KEY_RIGHT,2)==TRUE)
                if(AskKey("Press key for A     ",&SNES2_KEY_A,2)==TRUE)
                if(AskKey("Press key for B     ",&SNES2_KEY_B,2)==TRUE)
                if(AskKey("Press key for X     ",&SNES2_KEY_X,2)==TRUE)
                if(AskKey("Press key for Y     ",&SNES2_KEY_Y,2)==TRUE)
                if(AskKey("Press key for L     ",&SNES2_KEY_L,2)==TRUE)
                if(AskKey("Press key for R     ",&SNES2_KEY_R,2)==TRUE)
                if(AskKey("Press key for START ",&SNES2_KEY_START,2)==TRUE)
                if(AskKey("Press key for SELECT",&SNES2_KEY_SELECT,2)==TRUE)
                {
                    PlotString("Press ESC to exit   ",39,130);
                    if (sneese!=NULL)
                        stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
                    draw_sprite(Allegro_Bitmap,Allegro_Bitmap_GUI,0,0);
                    CopyGUIScreen();

                    while (!key[KEY_ESC]);
                }
                while (key[KEY_ESC]);

                UpdateGUI(3);
                UpdateConfigWindow(CursorAt);
            }
            if (CursorAt==6)
            {
                if (SPC_ENABLED!=0)
                {
                    strcpy(Config_Options[6],"Skip SPC                ");
                    SPC_ENABLED=0;
                }
                else
                {
                    strcpy(Config_Options[6],"Emulate SPC             ");
                    SPC_ENABLED=1;
                }
            }
            UpdateConfigWindow(CursorAt);
        }
    }
    return 1;          // Signify normal exit
}

void RomInfo(void)
{
    PlotWindow(10,70,33,7);
    PlotString(rom_romfile,17,78);
    PlotString(rom_romname,17,86);
    PlotString(rom_romtype,17,94);
    PlotString(rom_romhilo,17,102);
    PlotString(rom_romsize,17,110);
    PlotString(rom_sram,17,118);
    PlotString(rom_country,17,126);
    vsync();
    if (sneese!=NULL)
        stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
    draw_sprite(Allegro_Bitmap,Allegro_Bitmap_GUI,0,0);
    CopyGUIScreen();

    while (!key[KEY_ESC]);   // :)
    while (key[KEY_ESC]);
}

int GUI()
{
#ifdef DEBUG
    unsigned long Timer_Value,Timer_Value2;
#endif
    unsigned char Old_SPC=SPC_ENABLED;

#ifdef DEBUG
    Timer_Value=Timer_Counter_Profile;
    Timer_Value2=Timer_Counter_FPS;
#endif

    if (sneese!=NULL)          // Prevent a crash if file not found!
    {
        set_palette(sneesepal);
        stretch_blit(sneese,Allegro_Bitmap,0,0,320,240,0,0,SCREEN_W,SCREEN_H);
    }
    while (key[KEY_ESC]!=0);

    char TempBufferP[PATH_MAX+1];          // For saving the current directory to use!

    set_palette_range(&GUIPal[-252],252,255,1);    // Set the GUI palette up.

    UpdateGUI(0);
    CopyGUIScreen();

    int CursorAt=0;

    while (1==1)
    {
        if (key[KEY_UP]!=0)
        {
            CursorAt--;
            if(CursorAt == -1) // so it wraps
                CursorAt = NUM_OPTIONS-1;
            UpdateGUI(CursorAt);
            CopyGUIScreen();
            while (key[KEY_UP]!=0);
        }
        if (key[KEY_DOWN]!=0)
        {
            CursorAt++;
            if(CursorAt == NUM_OPTIONS) // so it wraps
                CursorAt=0;
            UpdateGUI(CursorAt);
            CopyGUIScreen();
            while (key[KEY_DOWN]!=0);
        }
        if (key[KEY_ESC]!=0)
        {
            while (key[KEY_ESC]!=0);
            break;
        }
        if (key[KEY_ENTER]!=0)
        {
            while (key[KEY_ENTER]!=0);
            if (CursorAt==0)
                break;
            if (CursorAt==1)
            {
                Reset_CPU();
                Reset_SPC();
                break;
            }
            if (CursorAt==2)
            {
                getcwd(TempBufferP,PATH_MAX);
                if (FileWindow()==0)
                {
                    chdir(TempBufferP);
                    Reset_CPU();
                    Reset_SPC();
                    break;
                }
                chdir(TempBufferP);
            }
            if (CursorAt==3)
                ConfigWindow();
            if (CursorAt==4)
                RomInfo();
            if (CursorAt==5)
            {
#ifdef DEBUG
                Timer_Counter_Profile=Timer_Value;
                Timer_Counter_FPS=Timer_Value2;
#endif
                return 0;
            }
            UpdateGUI(CursorAt);
            CopyGUIScreen();
        }
    }

    if (SPC_ENABLED!=0 && SPC_ENABLED!=Old_SPC)
    {
        Reset_CPU();          // Must be done to ensure rom works ok!
        Reset_SPC();
    }

#ifdef DEBUG
    Timer_Counter_Profile=Timer_Value;
    Timer_Counter_FPS=Timer_Value2;
#endif

    clear(screen);
    clear(Allegro_Bitmap);
    palettechanged=TRUE;

    return 1;          // Signify normal exit
}
