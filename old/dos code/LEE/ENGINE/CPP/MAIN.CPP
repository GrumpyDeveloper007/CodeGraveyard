//#define BENCH 0
// note:: wintop / winbottom are equates in assembler componants
const int arrowup=72;
const int arrowdown=80;
const int arrowleft=75;
const int arrowright=77;
const int escape=27;

/*

  3d Engine (DUKE,QUAKE,DESCENT! - if unoptimised) - Uses ...

  o - In Doom mode - FAST Floor and Wall texturing + gouraud lighting.
     // No longer directly supported due to non implementation of vertlists!

  o - In Quake mode - FAST Floors and Bilinear texture mapped Walls.
                      Real gouraud lighting based on corner shading!

  o - In Descent mode - Bilinear texture mapped Floors and Walls.
                        Real gouraud lighting based on corner shading!

  o - BSP trees are used for fast depth sorting.

  o - Spanning Lists are used to prevent drawing over filled pixels,
     NB : VertLists are used in Doom mode to prevent drawing over walls
         however I feel that this may be overkill and will be removed.

  o - I have finished implementing another texture mapping style
     2d interpolation! NB Quake uses a version of this for the enemies,
     it is very good since you can map parts of a texture to parts of a
     model, the only flaw is that perspective adjustment is not taken
     into account! Also screws drasticly when 3d clipped!

  o - Special 3DO file used to define a level, see 3DOCLASS.DOC for more
     information. A .3DO file is parsed at the beginning of operation and
     this is then used to dynamically build the level, thus there is no
     longer a need to rebuild the program to change the level. The parser
     has some crude error detection built in.

  o - Because of the various formats for polygon output (more to come!) I
     have changed the if else comparisons into a much quicker and smaller
     jump table!

  o - Palette problems have been solved as follows, now when you create a
     map file you must tell the 3DO parser which picture contains the base
     palette, then for every other picture included the parser will convert
     it to the base palette.

  o - Light tables are now implemented for better lighting effects, however
     at present everything seems really dark unless at level 31 (at present
     only 32 levels of light 0-31).

  o - Music support added via SEAL. Note at present it is hard coded.

  o - Added Ticks Per Frame counter in top left of screen.

  o - Angles are handled in 512ths e.g. 0 = 0 degrees  511 = 359.x degrees.

  o - I have fixed that darn transformation routine.. e.g. I have
     made it rotate using only 1 rotation. Before it used to rotate the
     eye then spin the eye... A WASTE! To fix it I needed to use the 12
     multiply calculation to allow me to rotate in the correct order. E.G.
     about Y (left or right) then Z (bank head) then X (up-down).

  o - Added collision with world very approx uses unrotated bounding boxes,
     could be adapted to use rotated ones, also no collision with dynamic,
     static objects only polygons defined in a sector! This causes a problem
     if the player walks towards a corner (I am working on this problem).

  o - Added gravity constant, makes you drop but due to collision routine
     you only drop as close to the floor as the gravity constant allows!

  o - I have removed head banking from the transformation routines, dynamic
     objects can still bank on all 3 axes but the player is limited to Z & Y.
     The full rotation can be put back by removing some comments and
     altering some stuff (JUST IN CASE I NEED IT LATER?).

  o - The player can no longer travel through corners of the map, this bug
     was caused by the fact I was only checking against the current sector
     the player was in, and not the sectors of the bounding box points.

  o - All non game based code moved into a library so I can use the stuff
     from other programs by simply linking it in.

  o - I have just knocked the processing in half for wall textures by
     swapping 4 float values to fixed.

  o - VESA Support now added.. actually now you must have VESA 2.0+ to
     use this engine (I may change it l8r to allow VGA modes). VESA is
     quicker since I no longer need to copy the screen. Max Y Resolution
     is presently 800 lines.. dont use any more cos there is no space
     for all the lines in the buffers used!

  o - New system under development to actually make this engine reasonable.
     To begin with a conversion from float to Fixed will be done, I will
     do this one routine at a time.

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/
#include "assem.h"

#include <math.h>
#include <conio.h>
#include <stdio.h>
#include <dos.h>
#include <iostream.h>
#include <time.h>

#include "h\3dengine.h"

#include "\coding\include\other\seal.h" // Include SEAL library for sound/music

void DrawWindows()
 {
// VESACLS();
 CLS();

 for (int a=WINTOP;a<WINBOTTOM;a++)
  {
  ScanLine[a].Clear(ScanLine[a].Root);	// delete members
  SpanList[a].Clear(SpanList[a].Root);
  ScanLine[a].Create(WINLEFT,WINRIGHT);
  SpanList[a].Create(-1,-1,NULL);
  }

 // Draw The 3D projection
 ShowTree(Map->BSPTree->Root);    // display in correct order for player position
 }

/*PAUDIOMODULE pModule;

void (__interrupt __far *OldInterrupt)();

long ClockTicks,Counter;

void CloseDown()
 {
 outp(0x43,0x34);
 outp(0x40,0);
 outp(0x40,0);

 _dos_setvect(0x08,OldInterrupt);

 // Stop module and close voices
 AStopModule();
 ACloseVoices();

 // Release module file
 AFreeModuleFile(pModule);

 // Close audio device
 ACloseAudio();
 }

void __interrupt __far UpdateSEAL()
 {
 AUpdateAudio();

 ClockTicks+=Counter; // stuff the clock I dont need it anyway :-o
 if (ClockTicks>=0x10000)
  {
  ClockTicks-=0x10000;
  OldInterrupt();
  }
 else
  outp(0x20,0x20);
 }*/

void main()
 {
 char String[50];

// AUDIOINFO info;
// AUDIOCAPS caps;

 InitParams(); // Dark
// InitParams2(); // Dark
 int Rott=0;

 cout << "\n\nInitialising 3D Engine  -  Design & Code By Xavier / Phobia '96";

 Map=Parse("maps\\test.3do");
 CalculateNormals(&Map->Object[0]); // calculate the normals for the map
 for (int a=0;a<Map->LastDynaObject;a++)
  CalculateNormals(&Map->Dyna_Object[a]); // calculate the normals for dynamic stuff

/* // Initialize SEAL audio library

 cout << "\n\nInitialising Audio Device - Implemented Using SEAL !!";

 AInitialize();

 // Open audio device
 info.nDeviceId = AUDIO_DEVICE_MAPPER;
 info.wFormat = AUDIO_FORMAT_16BITS | AUDIO_FORMAT_STEREO;
 info.nSampleRate = 44100;
 AOpenAudio(&info);

 // Display audio device information

 AGetAudioDevCaps(info.nDeviceId, &caps);

 cout << "\n\nUsing For Audio : " << caps.szProductName << " at ";
 if (info.wFormat&AUDIO_FORMAT_16BITS)
  cout << "16-bits ";
 else
  cout << "8-bits ";
 if (info.wFormat&AUDIO_FORMAT_STEREO)
  cout << "Stereo ";
 else
  cout << "Mono ";
 cout << info.nSampleRate << " Hz";

 // Load module file
 ALoadModuleFile("heroes.xm", &pModule);

 // Open voices and play module
 AOpenVoices(pModule->nTracks);
 APlayModule(pModule);

 OldInterrupt=_dos_getvect(0x08);
 _dos_setvect(0x08,UpdateSEAL);

 ClockTicks=0;
 Counter=(0x9000); //frequency;

// Set the PIT channel 0 frequency
 outp(0x43,0x34);
 outp(0x40,Counter%256);
 outp(0x40,Counter/256);*/

 MakeTables();	//create sin & cos tables in memory
 BuildLightTables();    // creates a better lighting arrangment

 short MouseX,MouseY;

 char Key;
 int Loop,Loop2,Engine=0;

 InitVideo();
// if (!InitVESA())
//  return;

// ModeInfoBlock SetMode;

// SetMode.XResolution=320;//800;
// SetMode.YResolution=200;//600;
// SetMode.NumberOfPlanes=1;
// SetMode.BitsPerPixel=8;
// SetMode.MemoryModel=MODEL_PACKED;
//
 SCRNWIDTH=320;//800;
 HCENTER=160;//400;        // Defines Center of display
 VCENTER=100;//300;
 WINLEFT=0;
 WINRIGHT=319;//799;
 WINTOP=0; 
 WINBOTTOM=199;//599;
 Perspective=WINBOTTOM-WINTOP;  
 InvPerspective=-Perspective;

// if (!SetVideo(&SetMode))
//  {
//  KillVESA();
//  return;
//  }

 unsigned char Byte,Count;

 SetPalette(Map->Palette,0,256);

 int light=0;

 if(initmouse())
  {
//  CloseDown();
  return;
  }

 show_mouse();

// VESACLS();
 CLS();

 clock_t Start,End;     // Start,End time to draw a frame!
 int frame=0;

 while (1==1)
  {
//  for (int yp=0;yp<Map->Texture[0].Height;yp++)
//   for (int xp=0;xp<Map->Texture[0].Width;xp++)
//    PutPixel(xp,yp,LightTables[light][Map->Graphic[Map->Texture[0].Graphic][xp+yp*(Map->Texture[0].Width)]]);
//
//  for (int ColY=0;ColY<16;ColY++)
//   for (int ColX=0;ColX<64;ColX++)
//    for (int Con=0;Con<5;Con++)
//     PutPixel(ColX*5+Con,199-ColY,LightTables[light][ColX+(ColY/4)*64]);

  sprintf(String,"Texture Width = %i, Height = %i",
         Map->Texture[3].Width,
         Map->Texture[3].Height
         );

//  PlotText(0,150,String,255);

//  hide_mouse();
//  VESAUpdateScreen();
 UpdateScreen();
//  show_mouse();

  char ch;
  ch=getch();

  if (ch==' ')
   break;
  if (ch=='+' && light<31)
   light++;
  if (ch=='-' && light>0)
   light--;
  }

// int Rotate1=0,Rotate2=(90/360.0)*512.0,Rotate3=(270/360.0)*512.0;
 int Rotate1=0,Rotate2=0,Rotate3=50;

 float Direc=-1;

 Map->Camera[0].Ax=Rotate1;               // Initial position setting
 Map->Camera[0].Ay=Rotate2;
 Map->Camera[0].Az=Rotate3;

 int Frame=0;

 Start=clock();        // Start timer
#ifdef BENCH

 while (frame<100)      // do 100 frames then show time taken
  {
#else
 while (1==1)
  {
#endif
  Transform(&Map->Camera[0],&Map->Object[0]);     // Rotate scene & translate to world pos etc.
  for (Loop=0;Loop<Map->LastDynaObject;Loop++)
   Transform(&Map->Camera[0],&Map->Dyna_Object[Loop]);

  int ttc=0;

  for (int tt=0;tt<Map->Object[0].NumOfVertices;tt++)
   {
   if (Map->Vertex[tt].wz<1)
    ttc++;
   }

  AnimateTextures();    // Goto Next Frame for textures
  DrawWindows();
  frame++;

#ifdef BENCH
  Rotate3+=10;  // ultra rotate to give true impression of engine
  Rotate3&=511;
#endif

  sprintf(String,"Num clipped points = %i      ",
         ttc
         );

  PlotText(0,0,String,255);

//  sprintf(String,"Ticks Per Frame = %i [%i Per Second]",End-Start,CLOCKS_PER_SEC);

//  PlotText(0,0,String,255);

//  hide_mouse();
//  VESAUpdateScreen();
 UpdateScreen();
//  show_mouse();

  Map->Camera[0].Ax=Rotate1;               // rotate Eye as follows
  Map->Camera[0].Ay=Rotate2;
  Map->Camera[0].Az=Rotate3;

//  UpdatePlayer(0,0,GRAVITY);

  Rott+=5;
  Rott&=511;    // limits angles to 0-511 (or 0-360 degrees)

//  Map->Dyna_Object[0].Ax=Rott;
//  Map->Dyna_Object[0].Ay=Rott;
//  Map->Dyna_Object[0].Az=0;//Rott;

//  Map->Dyna_Object[1].Az=Rott;

//  Map->Dyna_Object[1].Ox+=Direc;
//  if (Map->Dyna_Object[1].Ox>50)
//   {
//   Direc*=-1;
//   Map->Dyna_Object[1].Ox+=Direc*2;
//   }
//  if (Map->Dyna_Object[1].Ox<20)
//   {
//   Direc*=-1;
//   Map->Dyna_Object[1].Ox+=Direc*2;
//   }

// check for mouse press within 3d window

  PolygonTYPE *Poly;

  getmousedata(MouseX,MouseY);

  Poly=WhichPolygon(MouseX,MouseY);
  int TextureNum;

  if (Engine==1)        // are we going somewhere?
   {
   UpdatePlayer(Map->Camera[0].Zwx,Map->Camera[0].Zwy,0);
   }

  if(kbhit())
   {
   Key=getch();
   if (Key==0)
    {
    Key=getch();
    if (Key==arrowup)
      UpdatePlayer(Map->Camera[0].Zwx,Map->Camera[0].Zwy,0);
    if (Key==arrowdown)
      UpdatePlayer(-Map->Camera[0].Zwx,-Map->Camera[0].Zwy,0);
    if (Key==arrowleft)
     {
     Rotate3-=10;
     Rotate3&=511;
     }
    if (Key==arrowright)
     {
     Rotate3+=10;
     Rotate3&=511;
     }
    }
   if (Poly!=NULL)
    {
    if (Poly->TypeOfPolygon==POLY_NORMAL)
     {
     if (Key=='+')
      {
      Poly->Colour++;
      Poly->Colour&=0xff;
      }
     if (Key=='-')
      {
      Poly->Colour--;
      Poly->Colour&=0xff;
      }
     }
    if (Poly->TypeOfPolygon!=POLY_NORMAL)
     {
     if (Key=='+')
      {
      TextureNum=(Poly->Texture-&Map->Texture[0]);
      TextureNum++;
      if (TextureNum>=Map->MaxTexture)
       TextureNum=0;
      Poly->Texture=&Map->Texture[TextureNum];
      }
     if (Key=='-')
      {
      TextureNum=(Poly->Texture-&Map->Texture[0]);
      TextureNum--;
      if (TextureNum<0)
       TextureNum=Map->MaxTexture-1;
      Poly->Texture=&Map->Texture[TextureNum];
      }
     if (Key=='.')
      Poly->TextureModX+=0.01;
     if (Key==',')
      if (Poly->TextureModX>.01)
       Poly->TextureModX-=0.01;
     if (Key=='/')
      if (Poly->TextureModY>.01)
       Poly->TextureModY-=0.01;
     if (Key=='\'')
      Poly->TextureModY+=0.01;
     if (Key=='<')
      Poly->TextOffX--;
     if (Key=='>')
      Poly->TextOffX++;
     if (Key=='?')
      Poly->TextOffY--;
     if (Key=='@')
      Poly->TextOffY++;
     }
    }

   if (Key=='9')
    {
    Rotate3+=10;
    Rotate3&=511;
    }
   if (Key=='7')
    {
    Rotate3-=10;
    Rotate3&=511;
    }
   if (Key=='6')
    {
    Rotate2+=10;
    Rotate2&=511;
    }
   if (Key=='4')
    {
    Rotate2-=10;
    Rotate2&=511;
    }
   if (Key=='3')
    {
    Rotate1+=10;
    Rotate1&=511;
    }
   if (Key=='1')
    {
    Rotate1-=10;
    Rotate1&=511;
    }
   if (Key=='8')
     Rotate3=0;
   if (Key=='5')
    Rotate2=0;
   if (Key=='2')
    Rotate1=0;
   if (Key=='q')
    {
    UpdatePlayer(Map->Camera[0].Zwx,Map->Camera[0].Zwy,0);
    }
   if (Key=='a')
    {
    UpdatePlayer(-Map->Camera[0].Zwx,-Map->Camera[0].Zwy,0);
    }
   if (Key==13)	// turn on/off engine
    {
    if (Engine==0)
     Engine=1;
    else
     Engine=0;
    }
   if (Key==27)
    break;
   if (Key==' ')
    {
    if (WINLEFT==0)
     {
//     SetMode.XResolution=320;
//     SetMode.YResolution=200;
//     SetMode.NumberOfPlanes=1;
//     SetMode.BitsPerPixel=8;
//     SetMode.MemoryModel=MODEL_PACKED;
//     if (!SetVideo(&SetMode))
//      {
//      KillVESA();
//      return;
//      }
     SetPalette(Map->Palette,0,256);

     SCRNWIDTH=320;
     HCENTER=160;        // Defines Center of display
     VCENTER=100;
     WINLEFT=80;
     WINRIGHT=240;
     WINTOP=40;
     WINBOTTOM=160;
     }
    else
     {
//     SetMode.XResolution=320;
//     SetMode.YResolution=200;
//     SetMode.NumberOfPlanes=1;
//     SetMode.BitsPerPixel=8;
//     SetMode.MemoryModel=MODEL_PACKED;
//     if (!SetVideo(&SetMode))
//      {
//      KillVESA();
//      return;
//      }
     SetPalette(Map->Palette,0,256);

     SCRNWIDTH=320;
     HCENTER=160;        // Defines Center of display
     VCENTER=100;
     WINLEFT=0;
     WINRIGHT=319;
     WINTOP=0;
     WINBOTTOM=199;
     }
    Perspective=WINBOTTOM-WINTOP;  
    InvPerspective=-Perspective;
    }
   }
  Frame++;
  }
 End=clock();          // Get end of time

// KillVESA();
 KillVideo();
// CloseDown();

 cout << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 cout << "Frames Per Second = " << (Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;
 cout << "\nCode By / Phobia"<<endl;
 }
