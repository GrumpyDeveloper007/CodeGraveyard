////////////////////////////////////////////////////////////////////////////
//
// coded by Dark Elf 
//

// RenderScreen16a() defines Buffer1B as absolute ref
// CacheCode uses SourceVal from RenderWindow16...

// Features -
// - Flipping XY
// - Window ColourAddition / Subtraction
// - TileCache (4col/16col\Sprites)
// - Alised screen mode
// - Scrolled and layouted screens (tile clipping ,
//    y&7 scroll vals not added)

// Cache Implemtation note-
// - TileValid cleared on refresh, Base address set to tile address on
// - start of first rendering screen
// - TileValid cleared if -
// - - Colour depth of window changes (from window1 to 2 to 3..)
// - - Tile base address different to CacheBase

// mario blue- COLDATA,CGADD,CGDATA
// alters pal table index0

// window - effects any number of planes,and maybe all sprite
// render clipped to 256*256
// sprites clipped to 256*256
// windowing done by 1 of 2 methods-
// 1- post clipping of view area 
// 2- span drawing of render functions/line by line clipped sprites

#include <fstream.h>
#include <iostream.h>
#include <conio.h>
#include <stdlib.h>

#include <allegro.h>
extern BITMAP *Allegro_Bitmap;

unsigned char *ScreenDestnationDest;
unsigned char *ScreenDestnationBuffer; //source
extern "C" void PlotSNESScreenASM();
extern "C" void PlotTileA();
extern "C" void PlotTileA_F00_M0();
extern "C" void PlotTileA_FX0_M0();
extern "C" void PlotTileA_F0Y_M0();
extern "C" void PlotTileA_FXY_M0();
extern "C" void ChunkyToPlanar16();
extern "C" void ChunkyToPlanar4();

unsigned char *VESAScreenPtr;
unsigned char *VESAScreenDestnation;
unsigned char VESAScreenPixel;
//extern "C" void E_PlotPixel();
 int i,t;

// debug
fstream dale;

// Snes Video Ram 128K
unsigned char *SNESVRAM;//[65536*2];
unsigned char *SpriteRAM;//[1024+32]; not allocated
short *SNESREGS;//[1024]; not allocated
unsigned char SNESPAL[256*4];
unsigned char *E_SNESPAL=SNESPAL;
unsigned short *temppal;


// Screen data
unsigned short Layout0[(64)*(64)];
unsigned short Layout1[(64)*(64)];
unsigned short Layout2[(64)*(64)];
unsigned short Layout3[(64)*(64)];
unsigned short *LayoutPtr;
long LayoutCenter=(64)*32+32;
// -1,-1 / 1,-1  -- screen offset matrix
// -1,1  / 1,1

// Sprites
unsigned char *SpriteSize1Ptr;
unsigned char *SpriteSize2Ptr;

unsigned char *SpriteSize1Ptr00;
unsigned char *SpriteSize1PtrX0;
unsigned char *SpriteSize1Ptr0Y;
unsigned char *SpriteSize1PtrXY;
unsigned char *SpriteSize2Ptr00;
unsigned char *SpriteSize2PtrX0;
unsigned char *SpriteSize2Ptr0Y;
unsigned char *SpriteSize2PtrXY;

//////////////////////////////////////////////////////////////////

unsigned char *ScreenAddress1;
unsigned char *ScreenAddress2;
unsigned char *ScreenAddress3;
unsigned char *ScreenAddress4;
unsigned char *TileAddress1;
unsigned char *TileAddress2;
unsigned char *TileAddress3;
unsigned char *TileAddress4;

unsigned char *O_ScreenAddress1;
unsigned char *O_ScreenAddress2;
unsigned char *O_ScreenAddress3;
unsigned char *O_ScreenAddress4;
unsigned char *O_TileAddress1;
unsigned char *O_TileAddress2;
unsigned char *O_TileAddress3;
unsigned char *O_TileAddress4;

unsigned char ScreenValid1;
unsigned char ScreenValid2;
unsigned char ScreenValid3;
unsigned char ScreenValid4;

unsigned char *TileAddressA1;
unsigned char *TileAddressA2;
unsigned char *TileAddressA3;
unsigned char *TileAddressA4;
unsigned char *Tile0,*TileX,*TileY;// Mosaic'ed pointers

// Snes Registers
unsigned char E_INIDISP;   /*2100 x000bbbb	x=screen on/off,bbbb=Brightness */
unsigned char E_OBSEL;     /*2101 sssnnbbb  sss=sprite size,nn=upper 4k address,bbb=offset */
/* sss 0=8,16 1=8,32 2=8,64 3=16,32 4=16,64 5=32,64 */
/* 256*4 byte = x,y,tileAddress, YXppNNNt t=tileaddress msb,pp=plane priority,NNN=colourbase,Y=flip Y,X=Flip X */
/* 256*2 bits(32) = xs= ,x=msb,s=size 1/2 */
/*extern unsigned char E_OAMAddress;*/   /*2102w*/
unsigned char E_OAMAddressP1; /*2102w*/
unsigned char E_OAMDATA;      /*2104*/
unsigned char E_BGMODE;     /*2105 abcdefff a-d=tile size bg4-1 (8/16),e=priority bg3,fff=mode */
unsigned char E_MOSAIC;     /*2106 xxxxabcd  xxxx=0-F pixel size,a-d = affect BG4-1 */
unsigned char E_BG1SC;        /*2107 xxxxxxab  xxxxxx=base address, ab=SC Size */
unsigned char E_BG2SC;        /*2108 xxxxxxab  xxxxxx=base address, ab=SC Size */
unsigned char E_BG3SC;        /*2109 xxxxxxab  xxxxxx=base address, ab=SC Size */
unsigned char E_BG4SC;        /*210a xxxxxxab  xxxxxx=base address, ab=SC Size */
unsigned char E_BG12NBA;   /*210b aaaabbbb  aaaa=base address 2, bbbb=base address 1 */
unsigned char E_BG34NBA;   /*210c aaaabbbb  aaaa=base address 2, bbbb=base address 1 */
short E_BG1HScrollData;       /*210dw BG1HOFS*/
short E_BG1VScrollData;
short E_BG2HScrollData;
short E_BG2VScrollData;
short E_BG3HScrollData;
short E_BG3VScrollData;
short E_BG4HScrollData;
short E_BG4VScrollData;
unsigned char E_VMAIN;  /*2115*/
/*unsigned char E_VMADDL; 2116*/
/*unsigned char E_VMADDH; 2117*/
/*unsigned char E_VMDATAL; 2118*/
/*unsigned char E_VMDATAH; 2119*/

unsigned char E_M7SEL;/* 211A ab000yx ab= y=vertical flip,x=horiz flip*/
unsigned short E__M7A_DATA;
unsigned short E__M7B_DATA;
unsigned short E__M7C_DATA;
unsigned short E__M7D_DATA;
unsigned short E__M7X_DATA;
unsigned short E__M7Y_DATA;
unsigned char E_CGADD;/*2121*/
unsigned char E_CGDATA;/*2122*/
/*unsigned char E_W12SEL; 2123 windowing reg*/
/*unsigned char E_W34SEL; 2124 windowing reg*/
/*unsigned char E_WOBJSEL; 2125 */
/*unsigned char E_WH0; 2126 */
/*unsigned char E_WH1; 2127 */
/*unsigned char E_WH2; 2128 */
/*unsigned char E_WH3; 2129 */

unsigned char E_TM;/* 212c 000abcde  a=OBJ/OAM(sprites) on/off,b-e=BG4-1 */
unsigned char E_TD;/* 212d (i think)000abcde  a=OBJ/OAM on/off,b-e=BG4-1 */

///////////////////////////////////////////////////////////////////

//SpritePlottingTables/tiletables
#include "StatData.cc"
                                  
// TileCache
unsigned char *CacheBaseSprite=(unsigned char *)0xffffffff; // Base Address of Tiles
unsigned char *CacheBase16=(unsigned char *)0xffffffff; // Base Address of Tiles
unsigned char *CacheBase4=(unsigned char *)0xffffffff; // Base Address of Tiles
unsigned char *TileCacheSprite;//[64*1024]; // Cache Data
unsigned char TileValidSprite[1024];        // Array containing valid tiles
unsigned char *TileCache16;//[64*1024]; // Cache Data
unsigned char TileValid16[1024];        // Array containing valid tiles
unsigned char *TileCache4;//[64*1024];  // Cache Data
unsigned char TileValid4[1024];         // Array containing valid tiles
unsigned char TempTile[8*8];

unsigned char *SNESBuffer1Back;
unsigned char *SNESBuffer2Back;
unsigned char *SNESBuffer3Back;
unsigned char *SNESBuffer4Back;

unsigned char *Buffer1TileHigh;
unsigned char *Buffer2TileHigh;
unsigned char *Buffer3TileHigh;
unsigned char *Buffer4TileHigh;

unsigned char *RealBufferStart; // The start of all memory
unsigned char *Buffer1A;
unsigned char *Buffer1B;
unsigned char *Buffer1C;
unsigned char *Buffer1D;

unsigned char *Buffer2A;
unsigned char *Buffer2B;
unsigned char *Buffer2C;
unsigned char *Buffer2D;

unsigned char *Buffer3A;
unsigned char *Buffer3B;
unsigned char *Buffer3C;
unsigned char *Buffer3D;

unsigned char *Buffer4A;
unsigned char *Buffer4B;
unsigned char *Buffer4C;
unsigned char *Buffer4D;

unsigned char *MergeBuffer;

// Render ID
unsigned char Buffer1AClear; // 1 set if window clear, 2 set if 1 set on previous frame
unsigned char Buffer2AClear;
unsigned char Buffer3AClear;
unsigned char Buffer4AClear;

// Planar to chunky varibles
unsigned char *SNESTileSource;       // call param,source tile on snes window
unsigned char *ChunkyTileDestnation; // call param,temp buffer for conversion or cache cell

// Render/sprite/cache varibles
unsigned char *ScreenAddr;          // call param,to render,source window
unsigned char *ScreenDestnation;    // call param,to render,destnation window
unsigned char *TileFetch;           // call param,to render,tile base / set by sprite,tile base
int LayoutReg;                      // call param,to render,layout for window
short WindowXScroll, WindowYScroll; // call param,to render,current scroll values
unsigned char *DestnationFetch;     // internal render,current tile position on window
unsigned short *SourceFetch;        // internal render,current tile position on window(only used once)
unsigned short SourceVal;	    // internal render

unsigned short TileNum;      // internal render/sprite,used by cache

unsigned char *TileDestnation;     // call param,to plot tile,used by render/sprite
unsigned char *TileSource;         // call param,to plot tile,used by cache/render 256col
unsigned long TileYPos;		   // call param,to plot tile,current y position in tile 
unsigned char *TileYTable;  // call param,to plot tile,flipping
unsigned char *TileXTable;  // call param,to plot tile,flipping
unsigned char ColourBase;   // call param,to plot tile,

// sprite
unsigned char *TileFetch2;       // internal sprite,start tile of each sprite
unsigned char *SpriteDestnation; // internal sprite,top left point of each sprite
int SpriteNum,SpriteX,SpriteY;   // internal sprite

// HDMA/IRQ function -
// generates lists for various features 
unsigned long RegisterNumber;
unsigned char RegisterValue;
unsigned short VertNumber;
unsigned char RegisterCount=0;
unsigned short RegisterBuffer;

// Feature 1 - Alter palette of horiz line
//format 1.b,Horiz pos of write,1.b -col index,1.b*3 -newval
unsigned short Feature1Index;
const unsigned long Feature1Max=512;
unsigned char Feature1BufferA[Feature1Max*8];
unsigned char *Feature1Buffer=Feature1BufferA;
unsigned char *Feature1BufferEnd;

// Assembler Varibles
unsigned long Feature1YVal;
unsigned long Feature1YScreenMax;

#include "working.cc"

void WriteRegisterHoriz()
 {

 if (RegisterCount==0)
  {
  RegisterCount++;
  RegisterBuffer=0;
  }
 else
  if (RegisterCount==1)
   {
   RegisterCount++;
   RegisterBuffer=RegisterValue;
   }
  else
   if (RegisterCount==2)
    {
    RegisterCount=0;
    if (Feature1Index<Feature1Max) 
     {
     RegisterBuffer+=RegisterValue<<8;
     Feature1Buffer[Feature1Index*8]=VertNumber;
     Feature1Buffer[Feature1Index*8+1]=0;
     Feature1Buffer[Feature1Index*8+2]=((RegisterBuffer&(0x1f<<10))>>10)<<3;
     Feature1Buffer[Feature1Index*8+3]=((RegisterBuffer&(0x1f<<5))>>5)<<3;
     Feature1Buffer[Feature1Index*8+4]=(RegisterBuffer&0x001f)<<3;
 //    Feature1Index++;
     }
    else
     dale <<"overflow"<<endl;

  char String[16];
  itoa((long)RegisterNumber,String,16);

//  dale <<"Feature ns REG:"<<String<<" Value:"<<(int)RegisterBuffer
//  <<" ycount:"<<VertNumber<<endl;
  }
 }

// Plot tile
 int ix,iy;
 unsigned char Val;
 int PlotTileLoopTemp;
void PlotTile()
 {
 for (iy=0;iy<8;iy++)
  {
  PlotTileLoopTemp=(*(TileYTable+iy))<<3;//*8
  for (ix=0;ix<8;ix++)
   {
   Val=*(TileSource+PlotTileLoopTemp+*(TileXTable+ix));
   if (Val!=0)
    Val+=ColourBase;
   *TileDestnation++=Val;
   }
  TileDestnation=TileDestnation-8+256;
  }
 }

void PlotTileClippedLeft(int MinX)
 {
 for (iy=0;iy<8;iy++)
  {
  PlotTileLoopTemp=(*(TileYTable+iy))<<3;//*8
  for (ix=MinX;ix<8;ix++)
   {
   Val=*(TileSource+PlotTileLoopTemp+*(TileXTable+ix));
   if (Val!=0)
    Val+=ColourBase;
   *TileDestnation++=Val;
   }
  TileDestnation+=MinX;
  TileDestnation=TileDestnation+256-8;
  }
 }

void PlotTileClippedRight(int MaxX)
 {
 for (iy=0;iy<8;iy++)
  {
  PlotTileLoopTemp=(*(TileYTable+iy))<<3;//*8
  for (ix=0;ix<MaxX;ix++)
   {
   Val=*(TileSource+PlotTileLoopTemp+*(TileXTable+ix));
   if (Val!=0)
    Val+=ColourBase;
   *TileDestnation++=Val;
   }
  TileDestnation=TileDestnation-MaxX+256;
  }
 }
void PlotTileSprite()
 {
 for (iy=0;iy<8;iy++)
  {
  PlotTileLoopTemp=(*(TileYTable+iy))<<3;//*8
  for (ix=0;ix<8;ix++)
   {
   Val=*(TileSource+PlotTileLoopTemp+*(TileXTable+ix));
   if (Val!=0)
    {
    Val+=ColourBase;
    *TileDestnation++=Val;
    }
   else
    TileDestnation++;
   }
  TileDestnation=TileDestnation-8+256;
  }
 }


void InitCache16(unsigned char *TileAddress)
 {
 if ((unsigned long)CacheBase16!=(unsigned long)TileAddress)
  {
  CacheBase16=TileAddress;
  int i;
  for (i=0;i<1024;i++)
   {
   TileValid16[i]=0; // Clear Cache Address
   }
  }
 }

void CacheConvert16()
 {
 if (TileValid16[TileNum]==0)
  {
  ChunkyTileDestnation=TileCache16+(TileNum<<6);//*64
//  PlanarToChunky16Col();
  ChunkyToPlanar16();
  TileValid16[TileNum]=1;
  }
 TileSource=TileCache16+(TileNum<<6); //*64
 }

void InitCacheSprite(unsigned char *TileAddress)
 {
 if ((unsigned long)CacheBaseSprite!=(unsigned long)TileAddress)
  {
  CacheBaseSprite=TileAddress;
  int i;
  for (i=0;i<1024;i++)
   {
   TileValidSprite[i]=0; // Clear Cache Address
   }
  }
 }

void CacheConvertSprite()
 {
 if (TileValidSprite[TileNum]==0)
  {
  ChunkyTileDestnation=TileCacheSprite+(TileNum<<6);//*64
//  PlanarToChunky16Col();
  ChunkyToPlanar16();
  TileValid16[TileNum]=1;
  }
 TileSource=TileCacheSprite+(TileNum<<6); //*64
 }

void InitCache4(unsigned char *TileAddress)
 {
 if ((unsigned long)CacheBase4!=(unsigned long)TileAddress)
  {
  CacheBase4=TileAddress;
  int i;
  for (i=0;i<1024;i++)
   {
   TileValid4[i]=0; // Clear Cache Address
   }
  }
 }

void CacheConvert4()
 {
 if (TileValid4[TileNum]==0)
  {
  ChunkyTileDestnation=TileCache4+(TileNum<<6);
//  PlanarToChunky4Col();
ChunkyToPlanar4();
  TileValid4[TileNum]=1;
  }
 TileSource=TileCache4+(TileNum<<6);
 }

/////////////////////////////////////////
unsigned short *SNESScreenBack;
unsigned short SourceValBack;

void RenderWindow32x32()
 {
 int x,y;
 SourceFetch=(unsigned short*) 2(unsigned char*)ScreenAddr;
 DestnationFetch=ScreenDestnation;
 for(y=0;y<31;y++)
  {
  for(x=0;x<31;x++)
   {

   SourceVal=*SourceFetch;
   SourceValBack=*SNESScreenBack;

   if (SourceVal!=SourceValBack)
    {

    TileNum=(SourceVal&0x03ff); // 2*8
    ColourBase=((SourceVal>>8)&0x1c);
    //Call PlotTile
    SNESTileSource=(unsigned char*)TileFetch+(TileNum<<4);

    CacheConvert4();
    TileDestnation=DestnationFetch;

    if ((SourceVal&0x4000)==0)
     {
     if ((SourceVal&0x8000)==0)
       PlotTileA_F00_M0();
     else
       PlotTileA_F0Y_M0();
     }
    else
     {
     if ((SourceVal&0x8000)==0)
       PlotTileA_FX0_M0();
     else
       PlotTileA_FXY_M0();
     (*SNESScreenBack)=*SourceFetch; // update back buffer
     }
    }

   DestnationFetch+=8;
   }
  DestnationFetch+=512-256; // next line
  }
 }










void PlotSprite()
 {
 unsigned char OBSELTemp;

 OBSELTemp=E_OBSEL&(0x7>>5);
 if (OBSELTemp==0)
  {
  SpriteSize1Ptr00=SpriteS08F00;
  SpriteSize2Ptr00=SpriteS16F00;
  SpriteSize1PtrX0=SpriteS08FX0;
  SpriteSize2PtrX0=SpriteS16FX0;
  SpriteSize1Ptr0Y=SpriteS08F0Y;
  SpriteSize2Ptr0Y=SpriteS16F0Y;
  SpriteSize1PtrXY=SpriteS08FXY;
  SpriteSize2PtrXY=SpriteS16FXY;
  }
 if (OBSELTemp==1)
  {
  SpriteSize1Ptr00=SpriteS08F00;
  SpriteSize2Ptr00=SpriteS32F00;
  SpriteSize1PtrX0=SpriteS08FX0;
  SpriteSize2PtrX0=SpriteS32FX0;
  SpriteSize1Ptr0Y=SpriteS08F0Y;
  SpriteSize2Ptr0Y=SpriteS32F0Y;
  SpriteSize1PtrXY=SpriteS08FXY;
  SpriteSize2PtrXY=SpriteS32FXY;
  }
 if (OBSELTemp==2)
  {
  SpriteSize1Ptr00=SpriteS08F00;
  SpriteSize2Ptr00=SpriteS64F00;
  SpriteSize1PtrX0=SpriteS08FX0;
  SpriteSize2PtrX0=SpriteS64FX0;
  SpriteSize1Ptr0Y=SpriteS08F0Y;
  SpriteSize2Ptr0Y=SpriteS64F0Y;
  SpriteSize1PtrXY=SpriteS08FXY;
  SpriteSize2PtrXY=SpriteS64FXY;
  }
 if (OBSELTemp==3)
  {
  SpriteSize1Ptr00=SpriteS16F00;
  SpriteSize2Ptr00=SpriteS32F00;
  SpriteSize1PtrX0=SpriteS16FX0;
  SpriteSize2PtrX0=SpriteS32FX0;
  SpriteSize1Ptr0Y=SpriteS16F0Y;
  SpriteSize2Ptr0Y=SpriteS32F0Y;
  SpriteSize1PtrXY=SpriteS16FXY;
  SpriteSize2PtrXY=SpriteS32FXY;
  }
 if (OBSELTemp==4)
  {
  SpriteSize1Ptr00=SpriteS16F00;
  SpriteSize2Ptr00=SpriteS64F00;
  SpriteSize1PtrX0=SpriteS16FX0;
  SpriteSize2PtrX0=SpriteS64FX0;
  SpriteSize1Ptr0Y=SpriteS16F0Y;
  SpriteSize2Ptr0Y=SpriteS64F0Y;
  SpriteSize1PtrXY=SpriteS16FXY;
  SpriteSize2PtrXY=SpriteS64FXY;
  }
 if (OBSELTemp==5)
  {
  SpriteSize1Ptr00=SpriteS32F00;
  SpriteSize2Ptr00=SpriteS64F00;
  SpriteSize1PtrX0=SpriteS32FX0;
  SpriteSize2PtrX0=SpriteS64FX0;
  SpriteSize1Ptr0Y=SpriteS32F0Y;
  SpriteSize2Ptr0Y=SpriteS64F0Y;
  SpriteSize1PtrXY=SpriteS32FXY;
  SpriteSize2PtrXY=SpriteS64FXY;
  }

/* 128*4 byte = x,y,tileAddress, YXppNNNt t=tileaddress msb,pp=plane priority,NNN=colourbase,Y=flip Y,X=Flip X */
/* 128*2 bits(32) = xs= ,x=msb,s=size 1/2 pp= 0-plane0,1=plane1,2=plane2...*/

 TileFetch=SNESVRAM+((E_OBSEL&0x03)<<14);
 InitCacheSprite(TileFetch);
 unsigned char *SpriteSizePtr;
 int Siy,Six;
 unsigned char val;
 unsigned char SpriteByte3;
 unsigned char PlaneP;
 short RealSpriteX;
 unsigned short SpriteNumIndex;

 for(SpriteNum=0;SpriteNum<128;SpriteNum++)
  {
  if ( ((SpriteRAM[512+SpriteNum>>2]) & (0x01 << ((SpriteNum&3)<<1)))==0)
   {
     
  SpriteNumIndex=(SpriteNum<<2);
   SpriteY=SpriteRAM[SpriteNumIndex+1];
   // Check if sprite on screen y
   if (SpriteY<240)
    {
//    if ( ((SpriteRAM[512+SpriteNum>>2]) & (0x01 << ((SpriteNum&3)<<1)))==0)
//      RealSpriteX=SpriteRAM[SpriteNumIndex];
//    else
//      RealSpriteX=SpriteRAM[SpriteNumIndex]-256; // 255=-1
//    if (RealSpriteX>0 && RealSpriteX<256 )
//     {
     SpriteX=SpriteRAM[SpriteNumIndex];
     SpriteByte3=SpriteRAM[SpriteNumIndex+3];
     TileNum=( SpriteRAM[SpriteNumIndex+2]+((SpriteByte3&1)<<8) ); // lsb8+msb
     ColourBase=((SpriteByte3&0x0E)<<3)+0x80;
     TileFetch2=(unsigned char*)TileFetch;
     PlaneP=((SpriteByte3&030)>>4);
     if (PlaneP==0)
       ScreenDestnation=Buffer1A;
     if (PlaneP==1)
       ScreenDestnation=Buffer2A;
     if (PlaneP==2)
       ScreenDestnation=Buffer3A;
     if (PlaneP==3)
       ScreenDestnation=Buffer4A;
     SpriteDestnation=ScreenDestnation+SpriteX+(SpriteY<<8); 


     // Set sprite flipping and tile flipping
     if ((SpriteByte3&0x40)==0)
      {
      TileXTable=TileXTableF0M0;
      if ((SpriteByte3&0x80)==0) //y
        {
        SpriteSize1Ptr=SpriteSize1Ptr00;
        SpriteSize2Ptr=SpriteSize2Ptr00;
        TileYTable=TileXTableF0M0;
        }
      else
        {
        SpriteSize1Ptr=SpriteSize1Ptr0Y;
        SpriteSize2Ptr=SpriteSize2Ptr0Y;
        TileYTable=TileXTableF1M0;
        }
      }
     else
      {
      TileXTable=TileXTableF1M0;
       if ((SpriteByte3&0x80)==0)
        {
        SpriteSize1Ptr=SpriteSize1PtrX0;
        SpriteSize2Ptr=SpriteSize2PtrX0;
        TileYTable=TileXTableF0M0;
        }
       else
        {
        SpriteSize1Ptr=SpriteSize1PtrXY;
        SpriteSize2Ptr=SpriteSize2PtrXY;
        TileYTable=TileXTableF1M0;
        }
      } 

     val=( (SpriteRAM[512+(SpriteNum>>2)]) & (0x02 << ((SpriteNum&3)<<1)));
     if (val==0)
       SpriteSizePtr=SpriteSize1Ptr;
     else
       SpriteSizePtr=SpriteSize2Ptr;

     int ttt;
     for (Siy=0;Siy<8;Siy++)
      {
      Six=0;
      val=SpriteSizePtr[Six+(Siy<<3)];
      while (Six<8 & val!=0)
       {
       val--;
       ttt=TileNum;
       TileNum+=val;

       SNESTileSource=(unsigned char*)TileFetch2+(TileNum<<5);
       CacheConvertSprite();
       TileDestnation=SpriteDestnation+(Six<<3)+(Siy<<11);
       PlotTileSprite();
       TileNum=ttt;
       Six++;
       val=SpriteSizePtr[Six+(Siy<<3)];
       }
      }

//     }
    }
   }
  }
 }

void RenderClipped4Left()
 {
   SourceFetch=(unsigned short*) ((unsigned char*)ScreenAddr+(
   LayoutPtr[ (((WindowXScroll>>3))&63 )
   + ( (((WindowYScroll>>3))&63) <<6) ]));

   WindowXScroll+=8;

   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>8)&0x1c;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<4);
   CacheConvert4();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)==0)
    TileXTable=Tile0;
   else
    TileXTable=TileX;
   if ((SourceVal&0x8000)==0)
    TileYTable=Tile0;
   else
    TileYTable=TileY;
        
   PlotTileClippedLeft((WindowXScroll&7));
  DestnationFetch+=8-(WindowXScroll&7);
 }

void RenderClipped4Right()
 {
   SourceFetch=(unsigned short*) ((unsigned char*)ScreenAddr+(
   LayoutPtr[ (((WindowXScroll>>3))&63 )
   + ( (((WindowYScroll>>3))&63) <<6) ]));

   WindowXScroll+=8;

   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>8)&0x1c;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<4);
   CacheConvert4();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)==0)
    TileXTable=Tile0;
   else
    TileXTable=TileX;
   if ((SourceVal&0x8000)==0)
    TileYTable=Tile0;
   else
    TileYTable=TileY;
 if (        (((unsigned long)DestnationFetch)&0x7)!=0 )
   PlotTileClippedRight(8-(((unsigned long)DestnationFetch)&0x7));

 }


void RenderWindow4()
 {
 int x,y,tn;
 for(y=0;y<30;y++)
  {
  DestnationFetch=ScreenDestnation+(y<<11); //(WindowXScroll&7);  // shl 11,
  tn=WindowXScroll;
  RenderClipped4Left();
  for(x=0;x<31;x++)
   {
   SourceFetch=(unsigned short*) ((unsigned char*)ScreenAddr+(
   LayoutPtr[ (((WindowXScroll>>3))&63 )
   + ( (((WindowYScroll>>3))&63) <<6) ]));
   WindowXScroll+=8;
   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=((SourceVal>>8)&0x1c);
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<4);

   CacheConvert4();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)==0)
    {
    if ((SourceVal&0x8000)==0)
     {
     PlotTileA_F00_M0();
     }
    else
     {
     PlotTileA_F0Y_M0();
     }
    }
   else
    {
    if ((SourceVal&0x8000)==0)
     {
     PlotTileA_FX0_M0();
     }
    else
     {
     PlotTileA_FXY_M0();
     }
    }

   DestnationFetch+=8;
   }
  RenderClipped4Right();
  WindowXScroll=tn;
  WindowYScroll+=8;
  }
 }

void RenderClipped16Left()
 {
   SourceFetch=(unsigned short*) ((unsigned char*)ScreenAddr+(
   LayoutPtr[ (((WindowXScroll>>3))&63 )
   + ( (((WindowYScroll>>3))&63) <<6) ]));

   WindowXScroll+=8;

   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>6)&0x70;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<5);
   CacheConvert16();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)==0)
    TileXTable=Tile0;
   else
    TileXTable=TileX;
   if ((SourceVal&0x8000)==0)
    TileYTable=Tile0;
   else
    TileYTable=TileY;
        
   PlotTileClippedLeft((WindowXScroll&7));
  DestnationFetch+=8-(WindowXScroll&7);
 }

void RenderClipped16Right()
 {
   SourceFetch=(unsigned short*) ((unsigned char*)ScreenAddr+(
   LayoutPtr[ (((WindowXScroll>>3))&63 )
   + ( (((WindowYScroll>>3))&63) <<6) ]));

   WindowXScroll+=8;

   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>6)&0x70;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<5);
   CacheConvert16();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)==0)
    TileXTable=Tile0;
   else
    TileXTable=TileX;
   if ((SourceVal&0x8000)==0)
    TileYTable=Tile0;
   else
    TileYTable=TileY;
 if (        (((unsigned long)DestnationFetch)&0x7)!=0 )
   PlotTileClippedRight(8-(((unsigned long)DestnationFetch)&0x7));

 }

void RenderWindow16()
 {
 int x,y,tn;
 for(y=0;y<30;y++)
  {
  DestnationFetch=ScreenDestnation+(y<<11); //(WindowXScroll&7);  // shl 11,
  tn=WindowXScroll;
  RenderClipped16Left();
  for(x=0;x<31;x++)
   {
   SourceFetch=(unsigned short*) ((unsigned char*)ScreenAddr+(
   LayoutPtr[ (((WindowXScroll>>3))&63 )
   + ( (((WindowYScroll>>3))&63) <<6) ]));

   WindowXScroll+=8;

   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>6)&0x70;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<5);
   CacheConvert16();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)==0)
    {
    if ((SourceVal&0x8000)==0)
     {
     PlotTileA_F00_M0();
     }
    else
     {
     PlotTileA_F0Y_M0();
     }
    }
   else
    {
    if ((SourceVal&0x8000)==0)
     {
     PlotTileA_FX0_M0();
     }
    else
     {
     PlotTileA_FXY_M0();
     }
    }

        
   DestnationFetch+=8;
   }
  RenderClipped16Right();
  WindowXScroll=tn;
  WindowYScroll+=8;
  }
 }

unsigned char *ScreenAddrB;
unsigned short SourceValB;
void RenderWindow16Offset()
 {
 int x,y,tn;
 for(y=0;y<30;y++)
  {
  DestnationFetch=ScreenDestnation+(y<<11); //(WindowXScroll&7);  // shl 11,
  tn=WindowXScroll;
  RenderClipped16Left();
  for(x=0;x<31;x++)
   {
   SourceValB=*(ScreenAddr++);
   ScreenAddr++;
   SourceFetch=(unsigned short*) ((unsigned char*)ScreenAddr+(
   LayoutPtr[ (((WindowXScroll>>3))&63 )
   + ( (((WindowYScroll>>3))&63) <<6) ]));

   WindowXScroll+=8;

   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>6)&0x70;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<5);
   CacheConvert16();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)==0)
    {
    if ((SourceVal&0x8000)==0)
     {
     PlotTileA_F00_M0();
     }
    else
     {
     PlotTileA_F0Y_M0();
     }
    }
   else
    {
    if ((SourceVal&0x8000)==0)
     {
     PlotTileA_FX0_M0();
     }
    else
     {
     PlotTileA_FXY_M0();
     }
    }

        
   DestnationFetch+=8;
   }
  RenderClipped16Right();
  WindowXScroll=tn;
  WindowYScroll+=8;
  }
 }



void RenderWindow256()
 {
 int x,y,tn;
 for(y=0;y<30;y++)
  {
  tn=WindowXScroll;
  for(x=0;x<32;x++)
   {
   SourceFetch=(unsigned short*) ((unsigned char*)ScreenAddr+(
   LayoutPtr[ (((WindowXScroll>>3))&63 )
   + ( (((WindowYScroll>>3))&63) <<6) ]));
   WindowXScroll+=8;
   DestnationFetch=ScreenDestnation+x*8+y*256*8; // shl 11,
   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=0;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<6);
   ChunkyTileDestnation=TempTile;
   PlanarToChunky256Col();
   TileSource=TempTile;
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)!=0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)!=0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
   PlotTile();
   }
  WindowXScroll=tn;
  WindowYScroll+=8;
  }
 }

void RenderWindow16a()
 {
 int x,y;
 for(y=0;y<30;y++)
  {
  for(x=0;x<16;x+=1)
   {
   SourceFetch=(unsigned short*)ScreenAddr+y*32+x; // shl 6,y
   DestnationFetch=ScreenDestnation+(x<<4)+(y<<11); // shl 11,
   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>6)&0x70;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<5);
   CacheConvert16();

   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)>0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)>0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
        
   PlotTile();

   SNESTileSource=(unsigned char*)TileFetch+TileNum+32;
   CacheConvert16();
   TileDestnation=DestnationFetch+8;

   if ((SourceVal&0x4000)!=0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)!=0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
        
   PlotTile();

   }
  }
 // Do second buffer because screen is 64*32 wide
 for(y=0;y<32;y++)
  {
  for(x=0;x<16;x+=1)
   {
   SourceFetch=(unsigned short*)ScreenAddr+y*32+x+16; // shl 6,y
   DestnationFetch=Buffer1B+(x<<4)+(y<<11); // shl 11,
   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>6)&0x70;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<5);
   CacheConvert16();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)>0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)>0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
        
   PlotTile();

   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<5)+32;
   CacheConvert16();
   TileDestnation=DestnationFetch+8;

   if ((SourceVal&0x4000)!=0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)!=0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
        
   PlotTile();
   }
  }
 }

void RenderWindow4a()
 {
 int x,y;
 for(y=0;y<30;y++)
  {
  for(x=0;x<16;x+=1)
   {
   SourceFetch=(unsigned short*)ScreenAddr+y*32+x; // shl 6,y
   DestnationFetch=ScreenDestnation+(x<<4)+(y<<11); // shl 11,
   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>6)&0x70;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<4);
   CacheConvert4();

   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)!=0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)!=0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
        
   PlotTile();

   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<4)+16;
   CacheConvert4();
   TileDestnation=DestnationFetch+8;

   if ((SourceVal&0x4000)>0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)>0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
        
   PlotTile();

   }
  }
 // Do second buffer because screen is 64*32 wide
 for(y=0;y<30;y++)
  {
  for(x=0;x<16;x+=1)
   {
   SourceFetch=(unsigned short*)ScreenAddr+y*32+x+16; // shl 6,y
   DestnationFetch=Buffer2B+(x<<4)+(y<<11); // shl 11,
   SourceVal=*SourceFetch;
   TileNum=(SourceVal&0x03ff); // 2*8
   ColourBase=(SourceVal>>6)&0x70;
   //Call PlotTile
   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<4);
   CacheConvert4();
   TileDestnation=DestnationFetch;

   if ((SourceVal&0x4000)>0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)>0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
        
   PlotTile();

   SNESTileSource=(unsigned char*)TileFetch+(TileNum<<4)+16;
   CacheConvert4();
   TileDestnation=DestnationFetch+8;

   if ((SourceVal&0x4000)!=0)
    TileXTable=TileX;
   else
    TileXTable=Tile0;
   if ((SourceVal&0x8000)!=0)
    TileYTable=TileY;
   else
    TileYTable=Tile0;
        
   PlotTile();
   }
  }

 }

#include "screen.cc"

// Mode0- 4col,4col,4col,4col
// Mode1- 16col,16col,4col
// Mode2- 16col,16col
// Mode3- 256col,4col
// Mode4- 256col,16col
// Mode5- 16col,4col(512 width(16wide tiles))
// Mode6- 16col(16wide tiles)
// Mode7- 256col(special)
void DisplayMode0()
 {
 if (Buffer1AClear!=3)
  {
  PlotSNESScreen1A();
  if (Buffer1AClear==1)
    Buffer1AClear|=2;
  }

 if (Buffer2AClear!=3)
  {
  PlotSNESScreen2A();
  if (Buffer2AClear==1)
    Buffer2AClear|=2;
  }

 if (Buffer3AClear!=3)
  {
  PlotSNESScreen3A();
  if (Buffer3AClear==1)
    Buffer3AClear|=2;
  }

 if (Buffer4AClear!=3)
  {
  PlotSNESScreen4A();
  if (Buffer4AClear==1)
    Buffer4AClear|=2;
  }
 }

void DisplayMode1()
 {
 if (Buffer1AClear!=3)
  {
  PlotSNESScreen1A();
  if (Buffer1AClear==1)
    Buffer1AClear|=2;
  }

 if (Buffer2AClear!=3)
  {
  PlotSNESScreen2A();
  if (Buffer2AClear==1)
    Buffer2AClear|=2;
  }

 if (Buffer3AClear!=3)
  {
  PlotSNESScreen3A();
  if (Buffer3AClear==1)
    Buffer3AClear|=2;
  }
// PlotAlised(800*3*250,Buffer2A);

// PlotSNESScreenColourAddition(542*3+800*3*250,Buffer2A,Buffer1A);
// PlotSNESScreenColourSubtraction(510*3+800*3*270,Buffer2A,Buffer1A);

// PlotMerged3(800*3*250,Buffer3A,Buffer1A,Buffer2A);
 }

void DisplayMode2()
 {
 if (Buffer1AClear!=3)
  {
  PlotSNESScreen1A();
  if (Buffer1AClear==1)
    Buffer1AClear|=2;
  }

 if (Buffer2AClear!=3)
  {
  PlotSNESScreen2A();
  if (Buffer2AClear==1)
    Buffer2AClear|=2;
  }
 }

void DisplayMode3()
 {
 if (Buffer1AClear!=3)
  {
  PlotSNESScreen1A();
  if (Buffer1AClear==1)
    Buffer1AClear|=2;
  }

 if (Buffer2AClear!=3)
  {
  PlotSNESScreen2A();
  if (Buffer2AClear==1)
    Buffer2AClear|=2;
  }
 }

void DisplayMode4()
 {
 if (Buffer1AClear!=3)
  {
  PlotSNESScreen1A();
  if (Buffer1AClear==1)
    Buffer1AClear|=2;
  }

 if (Buffer2AClear!=3)
  {
  PlotSNESScreen2A();
  if (Buffer2AClear==1)
    Buffer2AClear|=2;
  }
 }

void DisplayMode5()
 {
 PlotSNESScreen(10*3,Buffer1A);
 PlotSNESScreen(10*3+256*3,Buffer1B);

 PlotSNESScreen(270*800*3+10*3,Buffer2A);
 PlotSNESScreen(270*800*3+10*3+256*3,Buffer2B);
 }

void DisplayMode6()
 {
 PlotSNESScreen1A();
 PlotSNESScreen1B();
 }

void UpdateSNESScreen()
 {
 if ((E_INIDISP&0x80)==0)
  {
  InitCache16(NULL);
  InitCache4(NULL);
  InitCacheSprite(NULL);
  SetScreenAddress1();
  SetScreenAddress2();
  SetScreenAddress3();
  SetScreenAddress4();
  unsigned short ScreenMode;

  SetTileLow1();
  SetTileHigh2();
  SetTileLow3();
  SetTileHigh4();

  ScreenMode=(E_BGMODE&0x7);
  if (ScreenMode==0)
     RenderMode0();
  if (ScreenMode==1)
     RenderMode1();
  if (ScreenMode==2)
     RenderMode2();
  if (ScreenMode==3)
     RenderMode3();
  if (ScreenMode==4)
     RenderMode4();
  if (ScreenMode==5)
     RenderMode5();
  if (ScreenMode==6)
     RenderMode6();
  if (ScreenMode==7)
     RenderMode1();
  }
 if (((E_TM|E_TD)&0x10)!=0)
   {
   PlotSprite();
   }
 }

void DisplaySNESScreen()
 {
 unsigned short ScreenMode;
// if ((E_INIDISP&0x80)==0)
  {
  ScreenMode=(E_BGMODE&0x7);
  if (ScreenMode==0)
     DisplayMode0();
  if (ScreenMode==1)
     DisplayMode1();
  if (ScreenMode==2)
     DisplayMode2();
  if (ScreenMode==3)
     DisplayMode3();
  if (ScreenMode==4)
     DisplayMode4();
  if (ScreenMode==5)
     DisplayMode5();
  if (ScreenMode==6)
     DisplayMode6();
  if (ScreenMode==7)
     DisplayMode1();
  }
 }


void SetLayout()
 {
 int x,y;
 for(y=0;y<32;y++)
  {
  for(x=0;x<32;x++)
   {
   Layout0[x+y*64]=x*2+y*32*2;
   Layout1[x+y*64]=x*2+y*32*2;
   Layout2[x+y*64]=x*2+y*32*2;
   Layout3[x+y*64]=x*2+y*32*2 ;

   Layout0[x+y*64+32]=x*2+y*32*2;
   Layout1[x+y*64+32]=x*2+y*32*2 +32*32*2;
   Layout2[x+y*64+32]=x*2+y*32*2;
   Layout3[x+y*64+32]=x*2+y*32*2 +32*32*2;

   Layout0[x+y*64+(32*64)]=x*2+y*32*2;
   Layout1[x+y*64+(32*64)]=x*2+y*32*2;
   Layout2[x+y*64+(32*64)]=x*2+y*32*2 +32*32*2;
   Layout3[x+y*64+(32*64)]=x*2+y*32*2 +32*32*2*2;

   Layout0[x+y*64+(32*64)+32]=x*2+y*32*2;
   Layout1[x+y*64+(32*64)+32]=x*2+y*32*2 +32*32*2;
   Layout2[x+y*64+(32*64)+32]=x*2+y*32*2 +32*32*2;
   Layout3[x+y*64+(32*64)+32]=x*2+y*32*2 +32*32*2*3;
   }
  }
 }


int StartScreen()
 {
 Feature1Index=0;
 dale.open("out.txt",ios::out|ios::binary);
 SetLayout();
 InitMem();
 if (RealBufferStart==NULL)
  return (0==1);

 return (1==1);
 }

void UpdateScreenPre()
 {
 Feature1Index=0; // Disable
 }

void UpdateScreen()
 {
 int i;
 unsigned short palval;

 for (i=0;i<256;i++)
  {
  palval=temppal[i];// b5,g5,r5
  E_SNESPAL[i*4]=((palval&(0x1f<<10))>>10)<<3;
  E_SNESPAL[i*4+1]=((palval&(0x1f<<5))>>5)<<3;
  E_SNESPAL[i*4+2]=(palval&0x001f)<<3;
  }

// for (i=0;i<256;i++)
//   {
//   box(i*3+800*570,E_SNESPAL[i*4],E_SNESPAL[i*4+1],E_SNESPAL[i*4+2]);
//   }
 E_TM|=E_TD;
  Feature1BufferEnd=Feature1Buffer+(Feature1Index*8);

  UpdateSNESScreen();
  DisplaySNESScreen();
  blit(Allegro_Bitmap,screen,0,0,0,0,800,300);
  Feature1Index=0;

if (TileAddress1!=TileAddressA1)
 {
 TileAddressA1=TileAddress1;
 dale << "Tile address change 1:"<<(unsigned int )TileAddress1<<endl;
 }
if (TileAddress2!=TileAddressA2)
 {
 TileAddressA2=TileAddress2;
 dale << "Tile address change 2:"<<(unsigned int )TileAddress2<<endl;
 }
if (TileAddress3!=TileAddressA3)
 {
 TileAddressA3=TileAddress3;
 dale << "Tile address change 3:"<<(unsigned int )TileAddress3<<endl;
 }
if (TileAddress4!=TileAddressA4)
 {
 TileAddressA4=TileAddress4;
 dale << "Tile address change 4:"<<(unsigned int )TileAddress4<<endl;
 }
 }

void EndScreen()
 {
 char String[16];
 cout << "Screen Mode :" <<(long)(E_BGMODE&0x7)<<endl;
 itoa((long)SNESVRAM,String,16);
 cout << "SNES VRAM address :"<<String<<endl;
 cout << "Screen1 address :"<<(unsigned long)(ScreenAddress1-SNESVRAM)<<endl;
 cout << "Tile1 address :"<<(unsigned long)(TileAddress1-SNESVRAM)<<endl;
 cout << "Screen 1 BG(layout) :"<<(long)(E_BG1SC&3)<<endl;
 cout << "BG12NBA :"<<(long)E_BG12NBA<<endl;
 cout <<"TD:"<<(long)E_TD<<endl;
 itoa((long)E_BG1HScrollData,String,16);
 cout <<"Screen1 HScroll:"<<String;
 itoa((long)E_BG1VScrollData,String,16);
 cout <<" VScroll:"<<String<<" Layout:"<<(long)(E_BG1SC&3)<<endl;

 itoa((long)E_BG2HScrollData,String,16);
 cout <<"Screen2 HScroll:"<<String;
 itoa((long)E_BG2VScrollData,String,16);
 cout <<" VScroll:"<<String<<" Layout:"<<(long)(E_BG2SC&3)<<endl;
 itoa((long)E_BG3HScrollData,String,16);
 cout <<"Screen3 HScroll:"<<String;
 itoa((long)E_BG3VScrollData,String,16);
 cout <<" VScroll:"<<String<<" Layout:"<<(long)(E_BG3SC&3)<<endl;
 itoa((long)E_BG4HScrollData,String,16);
 cout <<"Screen4 HScroll:"<<String;
 itoa((long)E_BG4VScrollData,String,16);
 cout <<" VScroll:"<<String<<" Layout:"<<(long)(E_BG4SC&3)<<endl;

 cout <<"\nMosaic :"<<(long)E_MOSAIC<<endl;

 cout<< "sprite size:"<< (int)(E_OBSEL&(0x7>>5))<<endl;

 cout << "mem:" << (int)RealBufferStart<<endl;
 cout << "\nCode By Dark Elf"<<endl;
 }


