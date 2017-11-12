
/*

 Real Voxel Landscape Drawing Doobry - Code By Xavier / Phobia '97

 o  Based on a tip I was given about how real voxels are done, instead
   of the obvious cone scan.... ray casting is employed. Cheers to who ever it
   was I was chatting to on DC... (I cant remember your name.. sorry!)
   Ray casting involves working out the point of intersection of a line from
   the eye through a vision window and onto a surface, using this you can
   build up a voxel easily by simply finding the intersection, getting
   the height and with this computing the distance from the eye to the point.

 o  The above method produced a noticable glitch.. in fact a big glitch,
   holes began to appear where intersection occured with a surface that was
   higher than the surround pixels producing holes. To deal with the
   problem I had to draw a line from the point of height intersection for
   the current distance to the bottom of the screen.Sloooooooow, this is
   unbelievable slow.. assembler may help.

 o  Fixed the shitty problem above by drawing the voxel from closest to
   furthest distance. A buffer is used similar to in voxel 1 to keep track
   of the heights of the previous line. When the previous line does not hide
   the new one, the new one is drawn from the intersected height to the old
   height and the buffer is updated.

 o  What the hell I have bunged in a simple background picture of size...
   512*200, now as the camera rotates the background will slide too! NICE :)

 o  Added small adjustment to BK pic, now as the camera height alters so will
   the view of the bk pic. Bkpic is now 512*400.!

*/

#define M_PI       (3.1415278)

#include <conio.h>
#include <math.h>

#include "..\XavStuff\h\pcx.h"
#include "..\XavStuff\h\video.h"

char BackGround[(512*400)];     // Bkg pic
char HeightMap[(256*256)];      // Height Field Here
char ColourMap[(256*256)];      // Colour Map Here

#define VIEWWINLEFT  -100
#define VIEWWINRIGHT 100
#define VIEWDISTANCE 80

int ViewHeight;
float ViewAngle=0;
long ViewX=0,ViewY=0;
long TextDx,TextDy,TextX,TextY;
int Distance;
unsigned int HeightBuffer[320];

int bk=0;

void VoxelScan(int y)
 {
 unsigned int ScanLine=(y+120+bk)*320;
 unsigned int OldScan;
 int a=0;
 int TextAddr;
 unsigned int ScanLine2;

 while(a<320)
  {
  TextAddr=((TextX>>8)&0xff)+(TextY&0xff00);
  TextX+=TextDx;
  TextY+=TextDy;

  char Colour=ColourMap[TextAddr];
  int Height=(HeightMap[TextAddr]+128)*2;

  y=(Height*VIEWDISTANCE)/Distance;

  y*=320;

  ScanLine2=ScanLine-y;

  OldScan=HeightBuffer[a];

  if (ScanLine2<OldScan)
   HeightBuffer[a]=ScanLine2;    // Store this height

 while (ScanLine2<OldScan)      // If new height is visible draw
  {
  *(VirtualScreen+ScanLine2+a)=Colour;
  ScanLine2+=320;
  }
  a++;
  }
 }

void DrawVoxel()        // It raycasts :)
 {                                        
 // The following two lines are constants they just show how the angle
 // of view is computed.. I will comment these out and alter the code
 // to use 100% fixed point when I get a chance!

 float RayCastLeft=atan(VIEWWINLEFT/VIEWDISTANCE);
 float RayCastRight=atan(VIEWWINRIGHT/VIEWDISTANCE);

 for (int a=0;a<320;a++)
  HeightBuffer[a]=320*200;      // BOTTOM OF SCREEN (APPROX)

 for (int y=99;y>=30;y--)
  {
  float RayLength=(float)VIEWDISTANCE/(y+1)*ViewHeight;
  Distance=RayLength+1600;

  float TextXStart=RayLength*sin(RayCastLeft+ViewAngle)*120;
  float TextYStart=RayLength*cos(RayCastLeft+ViewAngle)*120;

  float TextXEnd=RayLength*sin(RayCastRight+ViewAngle)*120;
  float TextYEnd=RayLength*cos(RayCastRight+ViewAngle)*120;

  TextDx=(TextXEnd-TextXStart)/320;
  TextDy=(TextYEnd-TextYStart)/320;

  TextX=TextXStart+ViewX;
  TextY=TextYStart+ViewY;

  VoxelScan(y);  // Draw a scanline
  }

 }


PCXHeader HeaderInfo;
unsigned char Palette[256*3];

void main()
 {
 GetPCXInfo(&HeaderInfo,"Colour.PCX");
 GetPCXPicture(&HeaderInfo,"Colour.PCX",(unsigned char *)ColourMap);
 GetPCXPalette(&HeaderInfo,"Colour.PCX",Palette);
 GetPCXInfo(&HeaderInfo,"Height.PCX");
 GetPCXPicture(&HeaderInfo,"Height.PCX",(unsigned char *)HeightMap);
 GetPCXInfo(&HeaderInfo,"Back.PCX");
 GetPCXPicture(&HeaderInfo,"Back.PCX",(unsigned char *)BackGround);

 InitVideo();
 SetPalette(Palette,0,256);

 float BKAngle=0,BKAngleD=(1.0/360.0)*512.0;
 unsigned int Temp1,Temp2,Temp3;

 while (!kbhit())
  {
  ViewHeight=sin(ViewAngle)*200+210;//HeightMap[((ViewX>>8)&0xff)+(ViewY&0xff00)];
  DrawVoxel();
  for (int x=0;x<320;x++)
   {
   Temp1=(((int)BKAngle+x)&0x1ff)+(ViewHeight/2)*512;
   Temp2=HeightBuffer[x];
   Temp3=x;
   while (Temp3<Temp2)
    {
    *(VirtualScreen+Temp3)=BackGround[Temp1];
    Temp1+=512;
    Temp3+=320;
    }
   }
  UpdateScreen();
  BKAngle+=BKAngleD;
  ViewAngle+=(1.0*M_PI)/180.0;      // Turn by 1 degree per frame
  ViewX+=512*sin(ViewAngle);
  ViewY+=512*cos(ViewAngle);
  }

 float ViewAdd=(1.0*M_PI)/180.0;      // Turn by 1 degree per frame

 for (int a=ViewHeight;bk<100;a+=1,bk++)
  {
  if(a/2<200)
   ViewHeight=a;
  DrawVoxel();
  for (int x=0;x<320;x++)
   {
   Temp1=(((int)BKAngle+x)&0x1ff)+(ViewHeight/2)*512;
   Temp2=HeightBuffer[x];
   Temp3=x;
   while (Temp3<Temp2)
    {
    *(VirtualScreen+Temp3)=BackGround[Temp1];
    Temp1+=512;
    Temp3+=320;
    }
   }
  UpdateScreen();
  BKAngle+=BKAngleD;
  ViewAngle+=ViewAdd;      // Turn by 1 degree per frame
  ViewAdd-=0.0002;
  ViewX+=512*sin(ViewAngle);
  ViewY+=512*cos(ViewAngle);
  }

 KillVideo();
 }
