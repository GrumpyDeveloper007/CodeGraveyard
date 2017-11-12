//#define BENCH 0

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
     into account!

  o - Special 3DO file used to define a level, see 3DOCLASS.DOC for more
     information. A .3DO file is parsed at the beginning of operation and
     this is then used to dynamically build the level, thus there is no
     longer a need to rebuild the program to change the level. The parser
     has some crude error detection built in.

  o - Because of the varios formats for polygon output (more to come!) I
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

  o - SEAL routines placed into seperate .cpp file. SEAL Music and SFX
     are now in use. SEAL module and sounds are loaded as requested in the
     3DO file.

  o - New system under development to actually make this engine reasonable.
     To begin with a conversion from float to Fixed will be done, I will
     do this one routine at a time.

  Design & Code By Xavier / Phobia '96-97

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <math.h>
#include <conio.h>
#include <stdio.h>
#include <iostream.h>
#include <process.h>
#include <time.h>

#include "h\3dengine.h"

// FATAL ERROR TERMINATION

void Bomb(int Result)
 {
 KillSEAL();    // Kill off SEAL
 exit(Result);
 }

void DrawWindows()
 {
 CLS();

 for (int a=0;a<200;a++)
  {
  ScanLine[a].Clear(ScanLine[a].Root);	// delete members
  SpanList[a].Clear(SpanList[a].Root);
  ScanLine[a].Create(WINLEFT,WINRIGHT);
  SpanList[a].Create(-1,-1,NULL);
  }

 // Draw The 3D projection
 ShowTree(Map->BSPTree->Root);    // display in correct order for player position
 }

void main()
 {
 char String[50];

 int Rott=0;

 cout << "\n\nInitialising 3D Engine  -  Design & Code By Xavier / Phobia '96-97";

 InitialiseSEAL();      // Set up SEAL for current sound card etc.

 Map=Parse("maps\\test.3do");
 CalculateNormals(&Map->Object[0]); // calculate the normals for the map
 for (int a=0;a<Map->LastDynaObject;a++)
  CalculateNormals(&Map->Dyna_Object[a]); // calculate the normals for dynamic stuff

 MakeTables();	//create sin & cos tables in memory
 BuildLightTables();    // creates a better lighting arrangment

 short MouseX,MouseY;

 char Key;
 int Loop,Loop2,Engine=0;

 InitVideo();

 unsigned char Byte,Count;

 SetPalette(Map->Palette,0,256);

 int light=0;

 if(initmouse())
  Bomb(-1);

 show_mouse();

 CLS();

 clock_t Start,End;     // Start,End time to draw a frame!

 while (1==1)
  {
  for (int yp=0;yp<Map->Texture[0].Height;yp++)
   for (int xp=0;xp<Map->Texture[0].Width;xp++)
    PutPixel(xp,yp,LightTables[light][Map->Graphic[Map->Texture[0].Graphic][xp+yp*(Map->Texture[0].Width)]]);

  for (int ColY=0;ColY<16;ColY++)
   for (int ColX=0;ColX<64;ColX++)
    for (int Con=0;Con<5;Con++)
     PutPixel(ColX*5+Con,199-ColY,LightTables[light][ColX+(ColY/4)*64]);

  sprintf(String,"Texture Width = %i, Height = %i",
         Map->Texture[3].Width,
         Map->Texture[3].Height
         );

  PlotText(0,150,String,255);

  hide_mouse();
  UpdateScreen();
  show_mouse();

  char ch;
  ch=getch();

  if (ch==' ')
   break;
  if (ch=='+' && light<31)
   light++;
  if (ch=='-' && light>0)
   light--;
  }

 int Rotate1=0,Rotate2=0,Rotate3=0;

 float Direc=-1;

 Map->Camera[0].Ax=Rotate1;               // Initial position setting
 Map->Camera[0].Ay=Rotate2;
 Map->Camera[0].Az=Rotate3;

 int frame=0;

 StartModule();

#ifdef BENCH
 Start=clock();        // Start timer

 while (frame<100)      // do 100 frames then show time taken
  {
#else
 while (1==1)
  {
#endif
  Transform(&Map->Camera[0],&Map->Object[0]);     // Rotate scene & translate to world pos etc.
  for (Loop=0;Loop<Map->LastDynaObject;Loop++)
   Transform(&Map->Camera[0],&Map->Dyna_Object[Loop]);

  AnimateTextures();	// Goto Next Frame for textures
  DrawWindows();
  frame++;

#ifdef BENCH
  Rotate3+=10;  // ultra rotate to give true impression of engine
  Rotate3&=511;
#endif

//  sprintf(String,"Ticks Per Frame = %i [%i Per Second]",End-Start,CLOCKS_PER_SEC);
//
//  PlotText(0,0,String,255);

  hide_mouse();
  UpdateScreen();
  show_mouse();

  Map->Camera[0].Ax=Rotate1;               // rotate Eye as follows
  Map->Camera[0].Ay=Rotate2;
  Map->Camera[0].Az=Rotate3;

  UpdatePlayer(0,0,GRAVITY);

  Rott+=5;
  Rott&=511;    // limits angles to 0-511 (or 0-360 degrees)

  Map->Dyna_Object[0].Ax=Rott;
  Map->Dyna_Object[0].Ay=Rott;
  Map->Dyna_Object[0].Az=0;//Rott;

  Map->Dyna_Object[1].Az=Rott;

  Map->Dyna_Object[2].Ax=Rott;
  Map->Dyna_Object[2].Ay=Rott;


  Map->Dyna_Object[1].Ox+=Direc;
  if (Map->Dyna_Object[1].Ox>50)
   {
   Direc*=-1;
   Map->Dyna_Object[1].Ox+=Direc*2;
   }
  if (Map->Dyna_Object[1].Ox<20)
   {
   Direc*=-1;
   Map->Dyna_Object[1].Ox+=Direc*2;
   }

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

   if (Poly!=NULL)
    {
    // Place stuff based on underlying polygon here, e.g. if user was to
    // shoot a test could be made to see what polygon he is aiming at!
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
     WINLEFT=80;
     WINRIGHT=240;
     WINTOP=40; 
     WINBOTTOM=160;
     }
    else
     {
     WINLEFT=0;
     WINRIGHT=319;
     WINTOP=0; 
     WINBOTTOM=199;
     }
    Perspective=WINBOTTOM-WINTOP;  
    InvPerspective=-Perspective;
    }
   }
  }
#ifdef BENCH
 End=clock();          // Get end of time
#endif

 KillVideo();
 KillSEAL();

#ifdef BENCH
 cout << "Ticks " << (End-Start) << " For 100 frames!";
#endif
 }
