/*
  ---------------------- Phobia - Intro 1 - We exist -----------------------
  ------ Coded by
  ---------- Xavier / Dark Elf
  ------ GfX by
  ---------- Dark Claw / Xavier
  ------ Music by
  ---------- Kone

  // Slide(maybe) pic 1
  // Pic 1 to mono colour
  // Cross fade to Pic 2
  // Fade to black Pic 2
  // Set palette to 0
  // Z rotate activate
  // Fade2Col Z rotate picture - makes demo flow better
  // Slide or scroll 2 col Phobia logo into bitplane 8 (vertically )
  // wait
  // start some text stuff
  // small delay
  // Slide or scroll 2 col Phobia logo off screen
  // finish text stuff
  // exit ? with dos text output
*/


extern "C" void CLS(unsigned char *);
#pragma aux CLS parm [edi];

#define UpdateScreen() (AsmUpdateScreen(VirtualScreen,ScreenPtr))
extern "C" void AsmUpdateScreen(unsigned char *,unsigned char *);
#pragma aux AsmUpdateScreen parm [esi][edi];

void InitVideo();
#pragma aux InitVideo =   \
        "mov     eax,0x013 "\
        "int     0x010     "\
          modify [eax edx];

void KillVideo();
#pragma aux KillVideo =   \
        "mov     eax,0x003 "\
        "int     0x010     "\
          modify [eax edx];


//Slide picture - Picture, screen address, Stepnumber,maxstep
extern "C" void Slide(unsigned char*,unsigned char*,long,long);
#pragma aux Slide parm [esi][edi][ecx][edx];

// Picture mix
extern "C" void UpdateScreen2(unsigned char *,unsigned char *,unsigned char *);
#pragma aux UpdateScreen2 parm [esi][edi][edx];

// font address,screen address, character
extern "C" void PlotFont(unsigned char*,unsigned char *,long);
#pragma aux     PlotFont parm [esi] [edi] [eax];

// a-,b-,c-,FVa-,FVb,FVc
extern "C" void TextPlot2(long,long,long,long,long,long);
#pragma aux     TextPlot2 parm [eax] [ebx] [ecx] [edx] [esi] [edi];

// AlignedPointer-,VirtualScreen-,FHa,FHb
extern "C" void InitParamsT(unsigned char*,unsigned char*);
#pragma aux     InitParamsT parm [eax] [ebx];

extern "C" void InitParamsT2(long,long);
#pragma aux     InitParamsT2 parm [ecx] [edx];

extern "C" void TextPlot(long,long,long,long,long,long);
#pragma aux     TextPlot parm [edi] [esi] [edx] [ebx] [ecx] [eax];

#define WaitVBL() (AsmWaitVBL())
extern "C" void AsmWaitVBL();

// table,screen
#define UpdateFade() (AsmUpdateFade(para,parb,parc,pard) )
extern "C" void AsmUpdateFade(unsigned char *,unsigned char *,unsigned char*,unsigned char*);
#pragma aux AsmUpdateFade parm [esi][ebx][ecx][edx];

// edi - screen address
// esi - length of screen
// edx - TTVU  - texture address - whole V - whole U
// ebx - u0Vv  - fraction u - 0 - whole V - fraction v
// ecx - amBb  - fraction du - 0 or FF - whole dv - fraction dv
// eax - 000A  - 0 - 0 - 0 - whole du

// Mono-cross fade constants 
 const int MaxAngle=90;
 const int PictureSize=64000;
 unsigned char *Screen=(unsigned char*)0x0a0000;
//
#define M_PI 3.1415278
#define WINTOP    0    // These come from my 3d engine
#define WINBOTTOM 199
#define WINLEFT   0
#define WINRIGHT  319
#define VCENTER   100
#define HCENTER   160

#include <dos.h>

#include "\coding\include\other\std.h"
#include "\coding\include\other\seal.h"
#include "h\sincos.h"

 #include "font.h"

// XAVIER KB NASTY
 volatile int KEYPRESSED=(1==0);
 volatile SKode=0;
 volatile long ClockTicks,Counter;
 volatile int TIMETICK=0;
 PAUDIOMODULE pModule;
 unsigned char *FontBuffer;
 const NumberOfLetters=200;
 unsigned char *ScreenPtr=(unsigned char *)0xa0000;      // Address of screen
 unsigned char ScreenBuffer[64000];
 unsigned char *VirtualScreen=ScreenBuffer;  // Address of virtual screen
 unsigned char GFX1[(256*256)*2];        // must be 64k aligned
 extern unsigned char *GFX2;        // must be 64k aligned

 extern  unsigned char *Buffer1;          // Picture A
 extern  unsigned char *Buffer2;          // Picture B
 extern  unsigned char *Picture2; // Back Picture
 unsigned char *AlignedPointer;   // Z rotate Picture

 unsigned char RefTableAA[65536+256];
 unsigned char RefTableAB[65536+256];

 int Bounce=0;
 unsigned char *BouncePointer=Picture2+320*(int)((Cos[0]+1)*(100));
 int FadeFlag=1;
 int FadeStep=2;
 float Perspective=100;
 long FHa,FHb,FVa,FVb,FVc;         // texture Map
 long a,b,c;                       // texture Map
 float Px,Py,Pz,Mx,My,Mz,Nx,Ny,Nz; // texture Map
 float Oa,Ha,Va,Ob,Hb,Vb,Oc,Hc,Vc; // texture Map
 float SA2,SA3,CA2,CA3,TempF;      // Rotation
// Main -Z Rotate
 short Rotate1=180;
 short BankZ=0;
 float Direc=-2;
 short XRot=0,Bank=0;
 float ZTrans=-120;
 short Trigger=0;
// Palettes
 extern  unsigned char *Palette;
 unsigned char MonoPal[256*3];
 extern unsigned char *PictureAPal;
 extern unsigned char *PictureBPal;
 unsigned char DestnationPal[256*3];  // Destnation Palette for fade
 unsigned char MixPal[256*3];         // Current palette for fade  
// Cross fade varibles
 int Angle=0;
 unsigned char *RefTableA,*RefTableB;   // Precalc buffers for fast div
 unsigned char *para,*parb,*parc,*pard; // Assembler parameters
// Loop varibles
 int i,t;
// Constant font format
 char CharSet16[]="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
// 3d stuff
 struct VertexTYPE
  {
  float ox,oy,oz; // vertex original coordinates
  float wx,wy,wz; // vertex working  coordinates
  };
 VertexTYPE *VertexPointer;
 VertexTYPE  FloorVerts[]=        // These are the points from the MODE 7 floor
	{
        {0,0,0},
        {255,0,0},
        {0,255,0},
	};

char Message[]={"     PHOBIA"};


void (__interrupt __far *OldInterrupt)();
void (__interrupt __far *OldKInterrupt)();

void __interrupt __far NewKB()
 {
 // Do nothing
 SKode=inp2(0x060);
 if (SKode==0x01)               // ESCAPE pressed
  KEYPRESSED=(1==1);
 outp2(0x20,0x20);
 }


////////////////////////////////////////////////////////////////////////////
//
// 
void InitElf()
 {
 RefTableA=RefTableAA;
 RefTableB=RefTableAB;
 RefTableA=(unsigned char*)( ((long)RefTableA+256)&0x0ffffff00 );
 RefTableB=(unsigned char*)( ((long)RefTableB+256)&0x0ffffff00 );

 // Cross fade precalc tables
 float temp1,temp2,aa,bb;
 unsigned char tempa,tempb;
 unsigned char *tablea=RefTableA;
 unsigned char *tableb=RefTableB;
 for (i=0;i<MaxAngle;i++)
  {
  aa=(90-i)*255/90;bb=i*255/90;
  aa=255/aa;bb=255/bb;
  for (t=0;t<256;t++)
   {
   temp1=t/aa;temp2=t/bb;
   *tablea++=(unsigned char) temp1;
   *tableb++=(unsigned char) temp2;
   }
  }
 for(i=0;i<256;i++)
  {
  MonoPal[i*3]=i/4;MonoPal[i*3+1]=i/4;MonoPal[i*3+2]=i/4;
  }
 }

///////////////////////////////////////////////////////////////////////////
// 
// Palette routines

void SetPalette(unsigned char *PaletteRGB,int StartCol,int NumCols)
  {
  for (int a=StartCol;a<StartCol+NumCols;a++)
   {
   outp2(0x3c8,a);
   outp2(0x3c9,PaletteRGB[a*3+0]);
   outp2(0x3c9,PaletteRGB[a*3+1]);
   outp2(0x3c9,PaletteRGB[a*3+2]);
   }
  }


void CopyPal(unsigned char * pall)
 {
 for (i=0;i<256;i++)
  {
  MixPal[i*3]=pall[i*3];
  MixPal[i*3+1]=pall[i*3+1];
  MixPal[i*3+2]=pall[i*3+2];
  }
 }

void CopyPalD(unsigned char * pall)
 {
 for (i=0;i<256;i++)
  {
  DestnationPal[i*3]=pall[i*3];
  DestnationPal[i*3+1]=pall[i*3+1];
  DestnationPal[i*3+2]=pall[i*3+2];
  }
 }

void ClearPal()
 {
 for(i=0;i<256*3;i++)
  MixPal[i]=0;
 }

void CalcDestnationMono()
 {
 for (i=0;i<256;i++)
  {
  DestnationPal[(i*3)]=  (int)(MixPal[(i*3)]+MixPal[(i*3)+1]+MixPal[(i*3)+2])/3;
  DestnationPal[(i*3)+1]=(int)(MixPal[(i*3)]+MixPal[(i*3)+1]+MixPal[(i*3)+2])/3;
  DestnationPal[(i*3)+2]=(int)(MixPal[(i*3)]+MixPal[(i*3)+1]+MixPal[(i*3)+2])/3;
  }
 }

// returns 0 when finished
int Fade2Col()
 {
 int tempd=(0==0);
 for (i=0;i<256;i++)
  {
  if (MixPal[(i*3)]>DestnationPal[(i*3)])
   { MixPal[(i*3)]-=1; tempd=(1==0); }
  if (MixPal[(i*3)]<DestnationPal[(i*3)])
   { MixPal[(i*3)]+=1; tempd=(1==0); }

  if (MixPal[(i*3)+1]>DestnationPal[(i*3)+1])
   { MixPal[(i*3)+1]-=1; tempd=(1==0); }
  if (MixPal[(i*3)+1]<DestnationPal[(i*3)+1])
   { MixPal[(i*3)+1]+=1; tempd=(1==0); }

  if (MixPal[(i*3)+2]>DestnationPal[(i*3)+2])
   { MixPal[(i*3)+2]-=1; tempd=(1==0); }
  if (MixPal[(i*3)+2]<DestnationPal[(i*3)+2])
   { MixPal[(i*3)+2]+=1; tempd=(1==0); }
  }
  return tempd;
 }

int Black2Col()
 {
 int tempd=(0==1);
 for (i=0;i<256;i++)
  {
  if (MixPal[(i*3)]!=DestnationPal[(i*3)])
   { MixPal[(i*3)]+=1; tempd=(0==0); }

  if (MixPal[(i*3)+1]!=DestnationPal[(i*3)+1])
   { MixPal[(i*3)+1]+=1; tempd=(0==0); }

  if (MixPal[(i*3)+2]!=DestnationPal[(i*3)+2])
   { MixPal[(i*3)+2]+=1; tempd=(0==0); }
  }
  return tempd;
 }

// returns 0 when finished
int Fade2Black()
 {
 int tempd=(0==0);
 for (i=0;i<256;i++)
  {
  if (MixPal[(i*3)]>0)
   { MixPal[(i*3)]-=1; tempd=(1==0); }

  if (MixPal[(i*3)+1]>0)
   { MixPal[(i*3)+1]-=1; tempd=(1==0); }

  if (MixPal[(i*3)+2]>0)
   { MixPal[(i*3)+2]-=1; tempd=(1==0); }
  }
  return tempd;
 }

// Convert colour pictures to b/w
void Convert2Mono(unsigned char *Btemp,unsigned char *PPal)
 {
 int Varr;
 for(i=0;i<65536;i++)
  {
  Varr=*Btemp;
  *Btemp=PPal[(int)Varr*3]*4;
  Btemp++;
  }
 }

////////////////////////////////////////////////////////////////////////////
//
// 3D - Much smaller... erm, Why was it so big ?
void Transform(long AZ,long AX) // Takes a pointer to the object
 {
 VertexPointer=FloorVerts;

 SA3=Sin[AZ];      // indexing on arrays... <NOT A LOT THO!>
 CA3=Cos[AZ];
 SA2=Sin[AX];      // indexing on arrays... <NOT A LOT THO!>
 CA2=Cos[AX];

 for (i=0;i<3;i++)
  {
  VertexPointer->wx=CA3*VertexPointer->ox-SA3*VertexPointer->oy;         // About Z (left/right)
  TempF=SA3*VertexPointer->ox+CA3*VertexPointer->oy;
  VertexPointer->wy=CA2*TempF-SA2*(VertexPointer->oz-ZTrans);
  VertexPointer->wz=(SA2*TempF+CA2*(VertexPointer->oz-ZTrans));

  VertexPointer++;
  }
 }

// Please note the Mode7Plot is optimised
void Mode7Plot(VertexTYPE *Vertices)
 {
 Px=Perspective*FloorVerts[0].wx;      // In my coords 0 is the origin of the square
 Py=-Perspective*FloorVerts[0].wy;     // Remember the Coords are being swapped here! (Z & Y)
 Pz=FloorVerts[0].wz;

 Mx=Perspective*FloorVerts[1].wx-Px; // Create Vector M
 My=-Perspective*FloorVerts[1].wy-Py;
 Mz=FloorVerts[1].wz-Pz;

 Nx=Perspective*FloorVerts[2].wx-Px; // Create Vector N
 Ny=-Perspective*FloorVerts[2].wy-Py;
 Nz=FloorVerts[2].wz-Pz;

 Oa=Ny*Px-Nx*Py;        // Compute magic numbers
 Ha=Nz*Py-Ny*Pz;
 Va=Nx*Pz-Nz*Px;

 Ob=Mx*Py-My*Px;
 Hb=My*Pz-Mz*Py;
 Vb=Mz*Px-Mx*Pz;

 Oc=My*Nx-Mx*Ny;
 Hc=Mz*Ny-My*Nz;
 Vc=Mx*Nz-Mz*Nx;

 a=(Oa+Va+Ha)/128;
 b=(Ob+Vb+Hb)/128;
 c=(Oc+Vc+Hc)/128;
                
 FVa=Va/128;
 FVb=Vb/128;
 FVc=Vc/128;

 FHa=Ha;
 FHb=Hb;

 InitParamsT2(FHa,FHb);
 TextPlot2(a,b,c,FVa,FVb,FVc);
 }       

///////////////////////////////////////////////////////////////////////////
// audio 

void CloseDown()
 {
 outp2(0x43,0x34);
 outp2(0x40,0);
 outp2(0x40,0);

 _dos_setvect(0x08,OldInterrupt);

 AStopModule(); // Stop module and close voices
 ACloseVoices();

 ACloseAudio(); // Close audio device
 AFreeModuleFile(pModule); // Release module file
 }

void __interrupt __far UpdateSEAL()
 {
 AUpdateAudio();

 ClockTicks+=Counter; // stuff the clock I dont need it anyway :-o
 if (ClockTicks>=0x10000)
  {
  TIMETICK++;
  ClockTicks-=0x10000;
  OldInterrupt();
  }
 else
  outp2(0x20,0x20);
 }
///////////////////////////////////////////
void PlotString(unsigned char *Address,char *String)
 {
 int x=0;

 while (*String!=0)
  {
  if (*String!=32)
   PlotFont(FONT16,Address+x,*String-'A');
  x+=16;
  String++;
  }
 }

void PlotString2(char *String)
 {
 int x=0,i,t,letter,c;

 while (*String!=0)
  {
  letter=*String-'A';
  for (t=0;t<16;t++)
   {
   for (i=0;i<16;i++)
    {
    c=FONT16[i+t*16+(letter*16*16)];
    FontBuffer[x+i+(t*NumberOfLetters*16)]=c;
    }
   }
  x+=16;
  String++;
  }
 }

void CopyFont(int x)
 {
 unsigned char *TempScreen=VirtualScreen+320*100;
 int c;
 for (t=0;t<16;t++)
  {
  for (i=0;i<320;i++)
   {
   c=FontBuffer[i+x+(t*NumberOfLetters*16)];
   if (c!=0)
     *TempScreen=c;
   TempScreen++;
   }
  }
 }

///////////////////////////////////////////////////////////////////////////
void main(int argc,char **argv)
 {
 InitElf();    // do dale setup

 AlignedPointer=(unsigned char *)(((long)GFX1+65536)&0xffff0000); // 64k aligned
 // Allocate font buffer
 FontBuffer=new unsigned char[16*16*NumberOfLetters];
 PlotString2("         THIS IS A SCROLL TEXT");


 for (i=0;i<256*256;i++)
  AlignedPointer[i]=GFX2[i];

 // Generate 8 bit plane mix col
 for(i=0;i<128;i++)
  {
    Palette[(i+128)*3]=Palette[i*3];
    Palette[(i+128)*3+1]=Palette[i*3+1];
    Palette[(i+128)*3+2]=Palette[i*3+2];
  if (Palette[i*3]<63-4)
    Palette[(i+128)*3]=Palette[i*3]+4;
   else Palette[(i+128)*3]=63;
  if (Palette[i*3+1]<63-4)
    Palette[(i+128)*3+1]=Palette[i*3+1]+4;
   else Palette[(i+128)*3+1]=63;
  if (Palette[i*3+2]<63-4)
    Palette[(i+128)*3+2]=Palette[i*3+2]+4;
   else Palette[(i+128)*3+2]=63;
  }

 for (int a=320*200;a<320*400;a++)
  Picture2[a]=0;

  
 AUDIOINFO info;
 AInitialize();
 info.nDeviceId = AUDIO_DEVICE_MAPPER;
 info.wFormat = AUDIO_FORMAT_16BITS | AUDIO_FORMAT_STEREO;
 info.nSampleRate = 44100;
 AOpenAudio(&info);
 // Load module file
 ALoadModuleFile("future2.xm", &pModule);
 // Open voices and play module
 AOpenVoices(pModule->nTracks);
 APlayModule(pModule);   


 InitVideo();
 // Setparameters for z rotate
 InitParamsT(AlignedPointer,VirtualScreen); 

// Start SEAL Interrupts
 OldInterrupt=_dos_getvect(0x08);
 _dos_setvect(0x08,UpdateSEAL);

// PATCH KB

 OldKInterrupt=_dos_getvect(0x09);
 _dos_setvect(0x09,NewKB);

 ClockTicks=0;
 Counter=(0x9000); //frequency;

// Set the PIT channel 0 frequency
 outp2(0x43,0x34);
 outp2(0x40,Counter%256);
 outp2(0x40,Counter/256);
///////////////////////////
  

// Slide picture A
  SetPalette(PictureAPal,0,256);
 while(Angle<512)
  {
  Angle++;
  Slide(Buffer1,Screen,Angle,512);
  WaitVBL();
  }

// Convert pictures to fade palette (mono)
 CopyPal(PictureAPal);
 CalcDestnationMono();

 while (!Fade2Col())
  {
  WaitVBL();
  SetPalette(MixPal,0,256);
  int plib=TIMETICK;
  while (TIMETICK==plib);
  }

 // Convert picture bytes to mono scale
 Convert2Mono(Buffer1,DestnationPal);
 CopyPal(PictureBPal);                  // Picture 2
 CalcDestnationMono();
 Convert2Mono(Buffer2,DestnationPal);

 // Set parameters for cross-fade
 para=Buffer1;parb=Buffer2;
 parc=RefTableA;pard=RefTableB;
 WaitVBL();
 UpdateFade();
 SetPalette(MonoPal,0,256);
 CopyPal(MonoPal);

 Angle=0;
 while (Angle<90)
  {
  int plib=TIMETICK;
  while (TIMETICK==plib);
  parc=RefTableA+((Angle%90)<<8);pard=RefTableB+((Angle%90)<<8);
  UpdateFade();
  WaitVBL();
  Angle++;
  }
 while (!Fade2Black())
  {
  WaitVBL();
  SetPalette(MixPal,0,256);
  int plib=TIMETICK;
  while (TIMETICK==plib);
  }
  
/////////////////////////////    
 CLS(Screen);
 UpdateScreen();
 ClearPal();
 CopyPalD(Palette);  // set destnation
 WaitVBL();
 SetPalette(MixPal,0,256);

 while (!KEYPRESSED)
  {  
  if (FadeFlag==1)
   {
   FadeStep--;
   if (FadeStep==0)
    {
    FadeStep=2;
    FadeFlag=Black2Col();
    SetPalette(MixPal,0,256);
    }
   }
  Transform(Rotate1,BankZ);     // Rotate scene & translate to world pos etc.

  Mode7Plot(FloorVerts);

  PlotString(VirtualScreen+32,Message);

  PlotString(VirtualScreen+32+320*20,"DARK ELF");
  CopyFont(BankZ);
  WaitVBL();
  // Copy memory buffer to video card using back filter
  UpdateScreen2(VirtualScreen,Screen,BouncePointer);

  if (Trigger>2)
   {
   if (Bounce!=180)
    {
    Bounce++;
    BouncePointer=Picture2+320*(int)((Cos[Bounce]+1)*(100));
    }
   }

  BankZ+=Bank;
  if (BankZ>=360)
   BankZ-=360;
  Rotate1+=XRot;
  if (Rotate1>=360)
   Rotate1-=360;
  ZTrans+=Direc;
  if (ZTrans<=-280 && Trigger==0)
   {
   XRot=1;
   Trigger=1;
   }
  if (Rotate1==0 && Trigger==1)
   {
   XRot=3;
   Direc=2;
   Trigger=2;
   }
  if (ZTrans>=-5 && Trigger==2)
   {
   Direc=-2;
   Trigger=3;
   }
  if (ZTrans<=-120 && Trigger==3)
   {
   Direc=0;
   Bank=1;
   }
  }

 KillVideo();
 _dos_setvect(0x09,OldKInterrupt);
 CloseDown();
 }

