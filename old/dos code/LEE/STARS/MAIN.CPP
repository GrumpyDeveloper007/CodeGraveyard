/*

  3d Starfield.. full camera rotational star field.

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <math.h>
#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <dos.h>
#include <iostream.h>
#include <time.h>

#include "..\engine\h\3dengine.h"

#define NUMSTARS 15000   // Number of stars in starfield

VertexTYPE StarField[NUMSTARS]; // generated randomly
CameraTYPE Camera={150*5,0,0,0,0,0,0,1,0,0,0,-1,1,0,0};
ObjectTYPE Scene={0,0,0,0,0,0,NUMSTARS,&StarField[0],0,NULL};

void MakeStars()
 {
 for (int t=0;t<NUMSTARS;t++)
  {
  StarField[t].ox=(float(rand())/32767)*700-350;
  StarField[t].oy=(float(rand())/32767)*700-350;
  StarField[t].oz=(float(rand())/32767)*300*5;
  }
 }

unsigned char Palette[3*256];

void main()
 {
 char String[50];

 MakeTables();	//create sin & cos tables in memory
 MakeStars();

 Palette[0+0]=0;
 Palette[0+1]=0;
 Palette[0+2]=0;

 Palette[3+0]=15;
 Palette[3+1]=15;
 Palette[3+2]=15;

 Palette[6+0]=30;
 Palette[6+1]=30;
 Palette[6+2]=30;

 Palette[9+0]=45;
 Palette[9+1]=45;
 Palette[9+2]=45;

 Palette[12+0]=60;
 Palette[12+1]=60;
 Palette[12+2]=60;

 InitVideo();

 SetPalette(Palette,0,256);

 CLS();

 Camera.Ox=0;
 Camera.Oy=200;
 Camera.Oz=200;

///////// Camera.Ax=0;               // Initial position setting
 Camera.Ay=256+128;
 Camera.Az=0;

 int Rott=0;

 while (1==1)
  {
/////////  Camera.Ax=Rott;               // Initial position setting

  Camera.Ay=Rott;//128+256;
  Camera.Az=0;


  Rott++;
  Rott&=511;

  Transform(&Camera,&Scene);     // Rotate scene & translate to world pos etc.
  CalculatePerspective(Scene.VertexList,NUMSTARS);

  UpdateScreen();
  CLS();

  for (int a=0;a<NUMSTARS;a++)
   {
   StarField[a].oz-=5;
   if (StarField[a].oz<0)
    StarField[a].oz+=300*5;
   if (StarField[a].sx>0 && StarField[a].sx<320 &&
       StarField[a].sy>0 && StarField[a].sy<200 &&
       StarField[a].wz>0)
    PutPixel(StarField[a].sx,StarField[a].sy,4-(StarField[a].oz/(120*5)));
   }

  if (kbhit())
   break;
  }
 KillVideo();
 }
