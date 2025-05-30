/*

  SCREEN Emulation Core - For SNEeSe

 Code By Savoury SnaX + Dark Elf

   Supports 		8x8 Tiles only (NB: 16x16 tiles can be set using 0x2105)
		Mode 0	// 4/4/4/4
		Mode 1	// 16/16/4
		Mode 3	// 256/16

*/

#include <iostream.h>

#include "romload.h"
#include "cpu.h"
#include "mem.h"

 #include "main.h"

extern "C" void MergeMode1A();

extern "C" void Plot4BplTileA(unsigned char*,unsigned char *);
#pragma aux     Plot4BplTileA parm [edi] [esi];

extern unsigned char *VirtualScreen;
//////////////////////////////////////
// Local globals

// Used by all plot functions
unsigned char Bp0,Bp1,Bp2,Bp3,Bp4,Bp5,Bp6,Bp7;
unsigned char Shift,Pixel;
// Used by render functions
 unsigned long ScreenAddress1T,TileAddress1T;
 unsigned char *ScreenAddress1,*TileAddress1;
 unsigned long ScreenAddress2T,TileAddress2T;
 unsigned char *ScreenAddress2,*TileAddress2;
 unsigned long ScreenAddress3T,TileAddress3T;
 unsigned char *ScreenAddress3,*TileAddress3;
 unsigned long ScreenAddress4T,TileAddress4T;
 unsigned char *ScreenAddress4,*TileAddress4;
// MergeMode0()
 unsigned char BK;
 int bk1x,bk1y;		// allows scrolling to occur
 int bk2x,bk2y;		// allows scrolling to occur
 int bk3x,bk3y;		// allows scrolling to occur
 int bk4x,bk4y;		// allows scrolling to occur

// MergeMode3()
// unsigned char BK;
// int bk1x,bk1y;         // allows scrolling to occur
// int bk2x,bk2y;         // allows scrolling to occur
 int currents1,currentd1;
 int currents2,currentd2;
 int currentss1,currentss2;



////////////////////////////////////////////////////////////////////////////
// 4 Tile plotters are needed (for xy flipping !)

void Plot2BplTile(unsigned char *ScreenAddr,unsigned char *TileAddress)	// no mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+0);
  Bp1=*(TileAddress+1);
  Shift=0x80;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)!=0)      // Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)!=0)      // Bit Set
    Pixel+=0x02;
   Shift=Shift>>1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress+=2;
  }
 }

void Plot2BplTileX(unsigned char *ScreenAddr,unsigned char *TileAddress)	// X mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+0);
  Bp1=*(TileAddress+1);
  Shift=0x01;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   Shift=Shift<<1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress+=2;
  }
 }

void Plot2BplTileY(unsigned char *ScreenAddr,unsigned char *TileAddress)	// Y mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+14);
  Bp1=*(TileAddress+15);
  Shift=0x80;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   Shift=Shift>>1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress-=2;
  }
 }

void Plot2BplTileXY(unsigned char *ScreenAddr,unsigned char *TileAddress)	// X,Y mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+14);
  Bp1=*(TileAddress+15);
  Shift=0x01;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   Shift=Shift<<1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress-=2;
  }
 }

////////////////////////////////////////////////////////////////////////////
// 4 Tile plotters are needed (for xy flipping !)

void Plot4BplTileX(unsigned char *ScreenAddr,unsigned char *TileAddress)	// X mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+0);
  Bp1=*(TileAddress+1);
  Bp2=*(TileAddress+16);
  Bp3=*(TileAddress+17);
  Shift=0x01;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)!=0)      // Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)!=0)      // Bit Set
    Pixel+=0x02;
   if ((Bp2&Shift)!=0)      // Bit Set
    Pixel+=0x04;
   if ((Bp3&Shift)!=0)      // Bit Set
    Pixel+=0x08;
   Shift=Shift<<1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress+=2;
  }
 }

void Plot4BplTileY(unsigned char *ScreenAddr,unsigned char *TileAddress)	// Y mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+14);
  Bp1=*(TileAddress+15);
  Bp2=*(TileAddress+30);
  Bp3=*(TileAddress+31);
  Shift=0x80;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   if ((Bp2&Shift)==Shift)	// Bit Set
    Pixel+=0x04;
   if ((Bp3&Shift)==Shift)	// Bit Set
    Pixel+=0x08;
   Shift=Shift>>1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress-=2;
  }
 }

void Plot4BplTileXY(unsigned char *ScreenAddr,unsigned char *TileAddress)	// X,Y mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+14);
  Bp1=*(TileAddress+15);
  Bp2=*(TileAddress+30);
  Bp3=*(TileAddress+31);
  Shift=0x01;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   if ((Bp2&Shift)==Shift)	// Bit Set
    Pixel+=0x04;
   if ((Bp3&Shift)==Shift)	// Bit Set
    Pixel+=0x08;
   Shift=Shift<<1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress-=2;
  }
 }

///////////////////////////////////////////////////////////////////////////
// 4 Tile plotters are needed (for xy flipping !)

void Plot8BplTile(unsigned char *ScreenAddr,unsigned char *TileAddress)	// no mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+0);
  Bp1=*(TileAddress+1);
  Bp2=*(TileAddress+16);
  Bp3=*(TileAddress+17);
  Bp4=*(TileAddress+32);
  Bp5=*(TileAddress+33);
  Bp6=*(TileAddress+48);
  Bp7=*(TileAddress+49);
  Shift=0x80;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   if ((Bp2&Shift)==Shift)	// Bit Set
    Pixel+=0x04;
   if ((Bp3&Shift)==Shift)	// Bit Set
    Pixel+=0x08;
   if ((Bp4&Shift)==Shift)	// Bit Set
    Pixel+=0x10;
   if ((Bp5&Shift)==Shift)	// Bit Set
    Pixel+=0x20;
   if ((Bp6&Shift)==Shift)	// Bit Set
    Pixel+=0x40;
   if ((Bp7&Shift)==Shift)	// Bit Set
    Pixel+=0x80;
   Shift=Shift>>1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress+=2;
  }
 }

void Plot8BplTileX(unsigned char *ScreenAddr,unsigned char *TileAddress)	// X mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+0);
  Bp1=*(TileAddress+1);
  Bp2=*(TileAddress+16);
  Bp3=*(TileAddress+17);
  Bp4=*(TileAddress+32);
  Bp5=*(TileAddress+33);
  Bp6=*(TileAddress+48);
  Bp7=*(TileAddress+49);
  Shift=0x01;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   if ((Bp2&Shift)==Shift)	// Bit Set
    Pixel+=0x04;
   if ((Bp3&Shift)==Shift)	// Bit Set
    Pixel+=0x08;
   if ((Bp4&Shift)==Shift)	// Bit Set
    Pixel+=0x10;
   if ((Bp5&Shift)==Shift)	// Bit Set
    Pixel+=0x20;
   if ((Bp6&Shift)==Shift)	// Bit Set
    Pixel+=0x40;
   if ((Bp7&Shift)==Shift)	// Bit Set
    Pixel+=0x80;
   Shift=Shift<<1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress+=2;
  }
 }

void Plot8BplTileY(unsigned char *ScreenAddr,unsigned char *TileAddress)	// Y mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+14);
  Bp1=*(TileAddress+15);
  Bp2=*(TileAddress+30);
  Bp3=*(TileAddress+31);
  Bp4=*(TileAddress+46);
  Bp5=*(TileAddress+47);
  Bp6=*(TileAddress+62);
  Bp7=*(TileAddress+63);
  Shift=0x80;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   if ((Bp2&Shift)==Shift)	// Bit Set
    Pixel+=0x04;
   if ((Bp3&Shift)==Shift)	// Bit Set
    Pixel+=0x08;
   if ((Bp4&Shift)==Shift)	// Bit Set
    Pixel+=0x10;
   if ((Bp5&Shift)==Shift)	// Bit Set
    Pixel+=0x20;
   if ((Bp6&Shift)==Shift)	// Bit Set
    Pixel+=0x40;
   if ((Bp7&Shift)==Shift)	// Bit Set
    Pixel+=0x80;
   Shift=Shift>>1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress-=2;
  }
 }

void Plot8BplTileXY(unsigned char *ScreenAddr,unsigned char *TileAddress)	// X,Y mirror
 {
 for (int a=0;a<8;a++)
  {
  Bp0=*(TileAddress+14);
  Bp1=*(TileAddress+15);
  Bp2=*(TileAddress+30);
  Bp3=*(TileAddress+31);
  Bp4=*(TileAddress+46);
  Bp5=*(TileAddress+47);
  Bp6=*(TileAddress+62);
  Bp7=*(TileAddress+63);
  Shift=0x01;
  for (int b=0;b<8;b++)
   {
   Pixel=0;
   if ((Bp0&Shift)==Shift)	// Bit Set
    Pixel+=0x01;
   if ((Bp1&Shift)==Shift)	// Bit Set
    Pixel+=0x02;
   if ((Bp2&Shift)==Shift)	// Bit Set
    Pixel+=0x04;
   if ((Bp3&Shift)==Shift)	// Bit Set
    Pixel+=0x08;
   if ((Bp4&Shift)==Shift)	// Bit Set
    Pixel+=0x10;
   if ((Bp5&Shift)==Shift)	// Bit Set
    Pixel+=0x20;
   if ((Bp6&Shift)==Shift)	// Bit Set
    Pixel+=0x40;
   if ((Bp7&Shift)==Shift)	// Bit Set
    Pixel+=0x80;
   Shift=Shift<<1;
   *ScreenAddr++=Pixel;
   }
  ScreenAddr+=256-8;
  TileAddress-=2;
  }
 }
////////////////////////////////////////////////////////////////////////////

unsigned short GetVRAMWord(unsigned char *Ptr)
 {
 return (*Ptr+((*(Ptr+1))<<8));
 }

void RenderMode0()	// Update Mode 0 Display	4/4/4/4 (BKG 1-4)!!!
 {
 ScreenAddress1T=GetSNESByte_Unmapped((unsigned char *)(0x2107+(unsigned long)RomAddress))&0xFC;
 ScreenAddress1=(unsigned char *)(ScreenAddress1T*(1024>>2));	// shift due to address skew
 ScreenAddress1=(unsigned char *)((long)ScreenAddress1+(long)VRamAddress);
 TileAddress1T=GetSNESByte_Unmapped((unsigned char *)(0x210b+(unsigned long)RomAddress))&0x0F;
 TileAddress1=(unsigned char *)(TileAddress1T*(4096));
 TileAddress1=(unsigned char *)((long)TileAddress1+(long)VRamAddress);

 ScreenAddress2T=GetSNESByte_Unmapped((unsigned char *)(0x2108+(unsigned long)RomAddress))&0xFC;
 ScreenAddress2=(unsigned char *)(ScreenAddress2T*(1024>>2));	// shift due to address skew
 ScreenAddress2=(unsigned char *)((long)ScreenAddress2+(long)VRamAddress);
 TileAddress2T=GetSNESByte_Unmapped((unsigned char *)(0x210b+(unsigned long)RomAddress))&0xF0;
 TileAddress2=(unsigned char *)((TileAddress2T>>4)*(4096));
 TileAddress2=(unsigned char *)((long)TileAddress2+(long)VRamAddress);

 ScreenAddress3T=GetSNESByte_Unmapped((unsigned char *)(0x2109+(unsigned long)RomAddress))&0xFC;
 ScreenAddress3=(unsigned char *)(ScreenAddress3T*(1024>>2));	// shift due to address skew
 ScreenAddress3=(unsigned char *)((long)ScreenAddress3+(long)VRamAddress);
 TileAddress3T=GetSNESByte_Unmapped((unsigned char *)(0x210c+(unsigned long)RomAddress))&0x0F;
 TileAddress3=(unsigned char *)(TileAddress3T*(4096));
 TileAddress3=(unsigned char *)((long)TileAddress3+(long)VRamAddress);

 ScreenAddress4T=GetSNESByte_Unmapped((unsigned char *)(0x210a+(unsigned long)RomAddress))&0xFC;
 ScreenAddress4=(unsigned char *)(ScreenAddress4T*(1024>>2));	// shift due to address skew
 ScreenAddress4=(unsigned char *)((long)ScreenAddress4+(long)VRamAddress);
 TileAddress4T=GetSNESByte_Unmapped((unsigned char *)(0x210c+(unsigned long)RomAddress))&0xF0;
 TileAddress4=(unsigned char *)((TileAddress4T>>4)*(4096));
 TileAddress4=(unsigned char *)((long)TileAddress4+(long)VRamAddress);

 unsigned long TileNum=0,PlotVer;

 for (int y=0;y<32;y++)
  {
  for (int x=0;x<32;x++)
   {
   TileNum=GetVRAMWord(&ScreenAddress1[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot2BplTile(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(2*8)]);
     break;
    case 0x4000:
     Plot2BplTileX(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(2*8)]);
     break;
    case 0x8000:
     Plot2BplTileY(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(2*8)]);
     break;
    case 0xc000:
     Plot2BplTileXY(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(2*8)]);
     break;
    }

   TileNum=GetVRAMWord(&ScreenAddress2[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot2BplTile(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(2*8)]);
     break;
    case 0x4000:
     Plot2BplTileX(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(2*8)]);
     break;
    case 0x8000:
     Plot2BplTileY(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(2*8)]);
     break;
    case 0xc000:
     Plot2BplTileXY(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(2*8)]);
     break;
    }

   TileNum=GetVRAMWord(&ScreenAddress3[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot2BplTile(&BKG3[(x<<3)+(y<<11)],&TileAddress3[TileNum*(2*8)]);
     break;
    case 0x4000:
     Plot2BplTileX(&BKG3[(x<<3)+(y<<11)],&TileAddress3[TileNum*(2*8)]);
     break;
    case 0x8000:
     Plot2BplTileY(&BKG3[(x<<3)+(y<<11)],&TileAddress3[TileNum*(2*8)]);
     break;
    case 0xc000:
     Plot2BplTileXY(&BKG3[(x<<3)+(y<<11)],&TileAddress3[TileNum*(2*8)]);
     break;
    }


   TileNum=GetVRAMWord(&ScreenAddress4[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot2BplTile(&BKG4[(x<<3)+(y<<11)],&TileAddress4[TileNum*(2*8)]);
     break;
    case 0x4000:
     Plot2BplTileX(&BKG4[(x<<3)+(y<<11)],&TileAddress4[TileNum*(2*8)]);
     break;
    case 0x8000:
     Plot2BplTileY(&BKG4[(x<<3)+(y<<11)],&TileAddress4[TileNum*(2*8)]);
     break;
    case 0xc000:
     Plot2BplTileXY(&BKG4[(x<<3)+(y<<11)],&TileAddress4[TileNum*(2*8)]);
     break;
    }

   }
  }
   
 }

void RenderMode1()	// Update Mode 1 Display	16/16/4 (BKG 1-3)
 {
 ScreenAddress1T=GetSNESByte_Unmapped((unsigned char *)(0x2107+(unsigned long)RomAddress))&0xFC;
 ScreenAddress1=(unsigned char *)(ScreenAddress1T*(1024>>2));	// shift due to address skew
 ScreenAddress1=(unsigned char *)((long)ScreenAddress1+(long)VRamAddress);
 TileAddress1T=GetSNESByte_Unmapped((unsigned char *)(0x210b+(unsigned long)RomAddress))&0x0F;
 TileAddress1=(unsigned char *)(TileAddress1T*(4096));
 TileAddress1=(unsigned char *)((long)TileAddress1+(long)VRamAddress);

 ScreenAddress2T=GetSNESByte_Unmapped((unsigned char *)(0x2108+(unsigned long)RomAddress))&0xFC;
 ScreenAddress2=(unsigned char *)(ScreenAddress2T*(1024>>2));	// shift due to address skew
 ScreenAddress2=(unsigned char *)((long)ScreenAddress2+(long)VRamAddress);
 TileAddress2T=GetSNESByte_Unmapped((unsigned char *)(0x210b+(unsigned long)RomAddress))&0xF0;
 TileAddress2=(unsigned char *)((TileAddress2T>>4)*(4096));
 TileAddress2=(unsigned char *)((long)TileAddress2+(long)VRamAddress);

 ScreenAddress3T=GetSNESByte_Unmapped((unsigned char *)(0x2109+(unsigned long)RomAddress))&0xFC;
 ScreenAddress3=(unsigned char *)(ScreenAddress3T*(1024>>2));	// shift due to address skew
 ScreenAddress3=(unsigned char *)((long)ScreenAddress3+(long)VRamAddress);
 TileAddress3T=GetSNESByte_Unmapped((unsigned char *)(0x210c+(unsigned long)RomAddress))&0x0F;
 TileAddress3=(unsigned char *)(TileAddress3T*(4096));
 TileAddress3=(unsigned char *)((long)TileAddress3+(long)VRamAddress);

 unsigned long TileNum=0,PlotVer;

 for (int y=0;y<32;y++)
  {
  for (int x=0;x<32;x++)
   {
   TileNum=GetVRAMWord(&ScreenAddress1[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot4BplTileA(&BKG1[x*8+y*8*256],&TileAddress1[TileNum*(4*8)]);
     break;
    case 0x4000:
     Plot4BplTileX(&BKG1[x*8+y*8*256],&TileAddress1[TileNum*(4*8)]);
     break;
    case 0x8000:
     Plot4BplTileY(&BKG1[x*8+y*8*256],&TileAddress1[TileNum*(4*8)]);
     break;
    case 0xc000:
     Plot4BplTileXY(&BKG1[x*8+y*8*256],&TileAddress1[TileNum*(4*8)]);
     break;
    }

   TileNum=GetVRAMWord(&ScreenAddress2[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot4BplTileA(&BKG2[x*8+y*8*256],&TileAddress2[TileNum*(4*8)]);
     break;
    case 0x4000:
     Plot4BplTileX(&BKG2[x*8+y*8*256],&TileAddress2[TileNum*(4*8)]);
     break;
    case 0x8000:
     Plot4BplTileY(&BKG2[x*8+y*8*256],&TileAddress2[TileNum*(4*8)]);
     break;
    case 0xc000:
     Plot4BplTileXY(&BKG2[x*8+y*8*256],&TileAddress2[TileNum*(4*8)]);
     break;
    }

   TileNum=GetVRAMWord(&ScreenAddress3[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot2BplTile(&BKG3[x*8+y*8*256],&TileAddress3[TileNum*(2*8)]);
     break;
    case 0x4000:
     Plot2BplTileX(&BKG3[x*8+y*8*256],&TileAddress3[TileNum*(2*8)]);
     break;
    case 0x8000:
     Plot2BplTileY(&BKG3[x*8+y*8*256],&TileAddress3[TileNum*(2*8)]);
     break;
    case 0xc000:
     Plot2BplTileXY(&BKG3[x*8+y*8*256],&TileAddress3[TileNum*(2*8)]);
     break;
    }

   }
  }
   
 }

/*
void RenderMode1()	// Update Mode 1 Display	16/16/4 (BKG 1-3)
 {
 ScreenAddress1T=GetSNESByte_Unmapped((unsigned char *)(0x2107+(unsigned long)RomAddress))&0xFC;
 ScreenAddress1=(unsigned char *)(ScreenAddress1T*(1024>>2));	// shift due to address skew
 ScreenAddress1=(unsigned char *)((long)ScreenAddress1+(long)VRamAddress);
 TileAddress1T=GetSNESByte_Unmapped((unsigned char *)(0x210b+(unsigned long)RomAddress))&0x0F;
 TileAddress1=(unsigned char *)(TileAddress1T*(4096));
 TileAddress1=(unsigned char *)((long)TileAddress1+(long)VRamAddress);

 ScreenAddress2T=GetSNESByte_Unmapped((unsigned char *)(0x2108+(unsigned long)RomAddress))&0xFC;
 ScreenAddress2=(unsigned char *)(ScreenAddress2T*(1024>>2));	// shift due to address skew
 ScreenAddress2=(unsigned char *)((long)ScreenAddress2+(long)VRamAddress);
 TileAddress2T=GetSNESByte_Unmapped((unsigned char *)(0x210b+(unsigned long)RomAddress))&0xF0;
 TileAddress2=(unsigned char *)((TileAddress2T>>4)*(4096));
 TileAddress2=(unsigned char *)((long)TileAddress2+(long)VRamAddress);

 ScreenAddress3T=GetSNESByte_Unmapped((unsigned char *)(0x2109+(unsigned long)RomAddress))&0xFC;
 ScreenAddress3=(unsigned char *)(ScreenAddress3T*(1024>>2));	// shift due to address skew
 ScreenAddress3=(unsigned char *)((long)ScreenAddress3+(long)VRamAddress);
 TileAddress3T=GetSNESByte_Unmapped((unsigned char *)(0x210c+(unsigned long)RomAddress))&0x0F;
 TileAddress3=(unsigned char *)(TileAddress3T*(4096));
 TileAddress3=(unsigned char *)((long)TileAddress3+(long)VRamAddress);

 unsigned long TileNum=0,PlotVer;

 for (int y=0;y<32;y++)
  {
  for (int x=0;x<32;x++)
   {
   TileNum=GetVRAMWord(&ScreenAddress1[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot4BplTileA(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(4<<3)]);
     break;
    case 0x4000:
     Plot4BplTileX(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(4<<3)]);
     break;
    case 0x8000:
     Plot4BplTileY(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(4<<3)]);
     break;
    case 0xc000:
     Plot4BplTileXY(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(4<<3)]);
     break;
    }

   TileNum=GetVRAMWord(&ScreenAddress2[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot4BplTileA(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(4<<3)]);
     break;
    case 0x4000:
     Plot4BplTileX(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(4<<3)]);
     break;
    case 0x8000:
     Plot4BplTileY(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(4<<3)]);
     break;
    case 0xc000:
     Plot4BplTileXY(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(4<<3)]);
     break;
    }

   TileNum=GetVRAMWord(&ScreenAddress3[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot2BplTile(&BKG3[(x<<3)+(y<<11)],&TileAddress3[TileNum*(2<<3)]);
     break;
    case 0x4000:
     Plot2BplTileX(&BKG3[(x<<3)+(y<<11)],&TileAddress3[TileNum*(2<<3)]);
     break;
    case 0x8000:
     Plot2BplTileY(&BKG3[(x<<3)+(y<<11)],&TileAddress3[TileNum*(2<<3)]);
     break;
    case 0xc000:
     Plot2BplTileXY(&BKG3[(x<<3)+(y<<11)],&TileAddress3[TileNum*(2<<3)]);
     break;
    }

   }
  }
   
 }
  */
void RenderMode3()	// Update Mode 3 Display	256/16 (BKG 1-2)
 {
 ScreenAddress1T=GetSNESByte_Unmapped((unsigned char *)(0x2107+(unsigned long)RomAddress))&0xFC;
 ScreenAddress1=(unsigned char *)(ScreenAddress1T*(1024>>2));	// shift due to address skew
 ScreenAddress1=(unsigned char *)((long)ScreenAddress1+(long)VRamAddress);
 TileAddress1T=GetSNESByte_Unmapped((unsigned char *)(0x210b+(unsigned long)RomAddress))&0x0F;
 TileAddress1=(unsigned char *)(TileAddress1T*(4096));
 TileAddress1=(unsigned char *)((long)TileAddress1+(long)VRamAddress);

 ScreenAddress2T=GetSNESByte_Unmapped((unsigned char *)(0x2108+(unsigned long)RomAddress))&0xFC;
 ScreenAddress2=(unsigned char *)(ScreenAddress2T*(1024>>2));	// shift due to address skew
 ScreenAddress2=(unsigned char *)((long)ScreenAddress2+(long)VRamAddress);
 TileAddress2T=GetSNESByte_Unmapped((unsigned char *)(0x210b+(unsigned long)RomAddress))&0xF0;
 TileAddress2=(unsigned char *)((TileAddress2T>>4)*(4096));
 TileAddress2=(unsigned char *)((long)TileAddress2+(long)VRamAddress);

 unsigned long TileNum=0,PlotVer;

 for (int y=0;y<32;y++)
  {
  for (int x=0;x<32;x++)
   {
   TileNum=GetVRAMWord(&ScreenAddress1[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot8BplTile(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(8*8)]);
     break;
    case 0x4000:
     Plot8BplTileX(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(8*8)]);
     break;
    case 0x8000:
     Plot8BplTileY(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(8*8)]);
     break;
    case 0xc000:
     Plot8BplTileXY(&BKG1[(x<<3)+(y<<11)],&TileAddress1[TileNum*(8*8)]);
     break;
    }

   TileNum=GetVRAMWord(&ScreenAddress2[x*2+y*32*2]);
   PlotVer=(TileNum&0xc000);
   TileNum&=0x03ff;
   switch(PlotVer)
    {
    case 0x0000:
     Plot4BplTileA(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(4*8)]);
     break;
    case 0x4000:
     Plot4BplTileX(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(4*8)]);
     break;
    case 0x8000:
     Plot4BplTileY(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(4*8)]);
     break;
    case 0xc000:
     Plot4BplTileXY(&BKG2[(x<<3)+(y<<11)],&TileAddress2[TileNum*(4*8)]);
     break;
    }
   }
  }
   
 }
/////////////////////////////////////////////////////////////////////////////
void MergeMode0()
 {
 for (int y=0;y<200;y++)	// (only 200 lines in mode 13 -- EEK SNES NEEDS MORE!)
  {
  bk1y=(y+BG1VScrollData)%256;
  bk2y=(y+BG2VScrollData)%256;
  bk3y=(y+BG3VScrollData)%256;
  bk4y=(y+BG4VScrollData)%256;
  for (int x=0;x<256;x++)
   {
   bk1x=(x+BG1HScrollData)%256;
   bk2x=(x+BG2HScrollData)%256;
   bk3x=(x+BG3HScrollData)%256;
   bk4x=(x+BG4HScrollData)%256;

   BK=BKG4[bk4x+(bk4y<<8)];                      // OH SHIT THIS IS SLOW (HEEEEELLLLP!)
   if (BK==0 || (GetSNESByte_Unmapped(0x212c+RomAddress)&0x08)==0x00)	// Next Plane
    {
    BK=BKG3[bk3x+(bk3y<<8)];
    if (BK==0 || (GetSNESByte_Unmapped(0x212c+RomAddress)&0x04)==0x00)	// Next Plane
     {
     BK=BKG2[bk2x+(bk2y<<8)];
     if (BK==0 || (GetSNESByte_Unmapped(0x212c+RomAddress)&0x02)==0x00)	// Next Plane
      {
      BK=BKG1[bk1x+(bk1y<<8)];
      if ((GetSNESByte_Unmapped(0x212c+RomAddress)&0x01)==0x00)
       BK=0;
      }
     }
    }
   VirtualScreen[x+y*320]=BK;
   }
  }
 }

void MergeMode3()
 {
 if ( (GetSNESByte_Unmapped(0x212c+RomAddress)&0x02)==0x00)
  { // no bpl 1
  if ( (GetSNESByte_Unmapped(0x212c+RomAddress)&0x01)==0x00)  // Next Plane
   { // no source
   }
  else
   { // bpl 2 but no bpl 1
   currents1=(BG2VScrollData&0x0ff)*256;
   currentd1=0;
   for (int y=0;y<200;y++)      
    {
    currentss1=(BG2HScrollData&256)+currents1;
    for (int x=0;x<256;x++)
     {
     BK=BKG2[currentss1];
     VirtualScreen[currentd1]=BK;
     currentss1++;
     currentd1++;
     }
    currents1+=256;
    currentd1+=320-256;
    }
   }
  }
 else
  { // bpl 1
  if ( (GetSNESByte_Unmapped(0x212c+RomAddress)&0x01)==0x00)  // Next Plane
   { // bpl 1 but no bpl 2
   currents1=(BG1VScrollData&0x0ff)*256;
   currentd1=0;
   for (int y=0;y<200;y++)      
    {
    currentss1=(BG1HScrollData&256)+currents1;
    for (int x=0;x<256;x++)
     {
     BK=BKG1[currentss1];
     VirtualScreen[currentd1]=BK;
     currentss1++;
     currentd1++;
     }
    currents1+=256;
    currentd1+=320-256;
    }
   }
  else
   { // bpl 1 && bpl 2
   // mov edi,SNES_Screen
   // mov ecx,BKG1  // 64K align
   // mov eax,BG1VScrollData
   // mov ch,al
   // mov eax,BG1HScrollData
   // mov cl,al
   // mov ebx,BKG2  // 64K align
   // mov eax,BG2VScrollData
   // mov bh,al
   // mov eax,BG2HScrollData
   // mov bl,al
   // mov edx,200
   // OuterLoop:
   //
   // mov esi,256  // Xsize
   // InnerLoop:
   // mov al,[ebx]
   // jne NonZero:
   // mov al,[ecx]
   // NonZero:
   // mov [edi],al
   // inc cl
   // inc bl
   // inc edi
   // dec esi
   // jnz InnerLoop
   // add edi, 320-256 // destnation modulo
   // inc ch
   // inc bh
   // dec edx
   // jnz OuterLoop
   // ret

   currents1=(BG1VScrollData&0x0ff)*256;
   currentd1=0;
   currents2=(BG2VScrollData&0x0ff)*256;
   currentd2=0;
   for (int y=0;y<200;y++)      
    {
    currentss2=(BG2HScrollData&256)+currents1;
    currentss1=(BG1HScrollData&256)+currents1;
    for (int x=0;x<256;x++)
     {
     BK=BKG2[currentss2];    
     if ( BK==0 )   // Next Plane
      {
      BK=BKG1[currentss1];
      }
     VirtualScreen[currentd1]=BK;
     currentss1++;
     currentss2++;
     currentd1++;
     }
    currents1+=256;
    currents2+=256;
    currentd1+=320-256;
    }
   }
  }
 }

void UpdateSNESScreen()
 {
 unsigned char Temp=GetSNESByte_Unmapped((unsigned char *)(0x2105+(unsigned long)RomAddress))&0x07;

 switch (Temp)
  {
  case 0x00:
   RenderMode0();
   MergeMode0();
   return;
  case 0x01:
   RenderMode1();
   MergeMode1A();
   return;
  case 0x03:
   RenderMode3();
   MergeMode3();
   return;
  default:
   cout << "\nScreen Mode Not Supported !!";
   cout.flush();
   return;
  }
 }
