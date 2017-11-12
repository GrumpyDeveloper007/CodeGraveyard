////////////////////////////////////////////////////////////////////////////
//
// coded by Dark Elf 
//

// Blend on x only (easier) x,(x+y)/2,y
/*
void PlotAlised(long Position,unsigned char *Buffer)
 {
 unsigned long p1,p2,p3,c1,c2,c3;
 int x,y;

 for(y=0;y<256;y++)
  {
  // Plot first pixel on X
  p1=E_SNESPAL[Buffer[(y<<8)]*3];
  p2=E_SNESPAL[Buffer[(y<<8)]*3+1];
  p3=E_SNESPAL[Buffer[(y<<8)]*3+2];
//  E_PlotPixel(VESAScreenPtr+Position+y*800*3,p1);
//  E_PlotPixel(VESAScreenPtr+Position+y*800*3+1,p2);
//  E_PlotPixel(VESAScreenPtr+Position+y*800*3+2,p3);

  for(x=1;x<256;x++)
   {
   c1=E_SNESPAL[Buffer[x+(y<<8)]*3];
   c2=E_SNESPAL[Buffer[x+(y<<8)]*3+1];
   c3=E_SNESPAL[Buffer[x+(y<<8)]*3+2];
//   E_PlotPixel(VESAScreenPtr+Position+(x*2-1)*3+y*800*3,(c1+p1)/2);
//   E_PlotPixel(VESAScreenPtr+Position+(x*2-1)*3+y*800*3+1,(c2+p2)/2);
//   E_PlotPixel(VESAScreenPtr+Position+(x*2-1)*3+y*800*3+2,(c3+p3)/2);

//   E_PlotPixel(VESAScreenPtr+Position+(x*2)*3+y*800*3,c1);
//   E_PlotPixel(VESAScreenPtr+Position+(x*2)*3+y*800*3+1,c2);
//   E_PlotPixel(VESAScreenPtr+Position+(x*2)*3+y*800*3+2,c3);

   p1=c1;
   p2=c2;
   p3=c3;
   }
  }

 }

void PlotSNESScreenColourAddition(long Position,unsigned char *Buffer,
                unsigned char *ColourBuffer)
 {
 unsigned long p1,p2,p3,a1,a2,a3,v1,v2,v3;
 int x,y;
 for(y=0;y<256;y++)
  {
  for(x=0;x<256;x++)
   {
   p1=E_SNESPAL[Buffer[x+y*256]*3];
   p2=E_SNESPAL[Buffer[x+y*256]*3+1];
   p3=E_SNESPAL[Buffer[x+y*256]*3+2];
   a1=E_SNESPAL[ColourBuffer[x+y*256]*3];
   a2=E_SNESPAL[ColourBuffer[x+y*256]*3+1];
   a3=E_SNESPAL[ColourBuffer[x+y*256]*3+2];
   v1=p1+a1;
   v2=p2+a2;
   v3=p3+a3;
   if (v1>255)
    v1=255;
   if (v2>255)
    v2=255;
   if (v3>255)
    v3=255;
//   E_PlotPixel(VESAScreenPtr+Position+x*3+y*800*3,v1);
//   E_PlotPixel(VESAScreenPtr+Position+x*3+y*800*3+1,v2);
//   E_PlotPixel(VESAScreenPtr+Position+x*3+y*800*3+2,v3);
   }
  }
 }
*/
void PlotSNESScreenColourSubtraction(long Position,unsigned char *Buffer,
                unsigned char *ColourBuffer)
 {
 unsigned long p1,p2,p3,a1,a2,a3,v1,v2,v3;
 int x,y;
 unsigned char *ScreenDestnation=VESAScreenPtr+Position;
 unsigned short BufferReadA,BufferReadB;
 for(y=0;y<256;y++)
  {
  for(x=0;x<256;x++)
   {
   BufferReadA=*(Buffer++)*3;
   BufferReadB=*(ColourBuffer++)*3;
   p1=E_SNESPAL[BufferReadA];
   p2=E_SNESPAL[BufferReadA+1];
   p3=E_SNESPAL[BufferReadA+2];
   a1=E_SNESPAL[BufferReadB];
   a2=E_SNESPAL[BufferReadB+1];
   a3=E_SNESPAL[BufferReadB+2];
   v1=p1-a1;
   v2=p2-a2;
   v3=p3-a3;
   if (v1>255)
    v1=255;
   if (v2>255)
    v2=255;
   if (v3>255)
    v3=255;
   *(ScreenDestnation++)=v1;
   *(ScreenDestnation++)=v2;
   *(ScreenDestnation++)=v3;
//   E_PlotPixel(VESAScreenPtr+Position+x*3+y*800*3,v1);
   }
  ScreenDestnation+=(800-256)*3;
  }
 }

void PlanarToChunky4Col()
 {
 unsigned char *DestTemp=ChunkyTileDestnation;
 unsigned char *SourceTemp=SNESTileSource;
 unsigned char BitMask;

 unsigned char S1,S2,Val;
 long py;

 for (py=0;py<8;py++)
  {
  S1=*(SourceTemp);
  S2=*(SourceTemp+1);

  BitMask=0x80;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  *DestTemp++=Val;
  BitMask=0x40;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  *DestTemp++=Val;
  BitMask=0x20;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  *DestTemp++=Val;
  BitMask=0x10;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  *DestTemp++=Val;
  BitMask=0x08;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  *DestTemp++=Val;
  BitMask=0x04;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  *DestTemp++=Val;
  BitMask=0x02;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  *DestTemp++=Val;
  BitMask=0x01;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  *DestTemp++=Val;

//  DestTemp=DestTemp+256-8;
  SourceTemp+=2;
  }
 }


void PlanarToChunky16Col()
 {
 unsigned char *DestTemp=ChunkyTileDestnation;
 unsigned char *SourceTemp=SNESTileSource;
 unsigned char BitMask;
 unsigned char S1,S2,S3,S4,Val;
 long py;

 for (py=0;py<8;py++)
  {
  S1=*(SourceTemp);
  S2=*(SourceTemp+1);
  S3=*(SourceTemp+16);
  S4=*(SourceTemp+17);

  BitMask=0x80;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  *DestTemp++=Val;
  BitMask=0x40;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  *DestTemp++=Val;
  BitMask=0x20;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  *DestTemp++=Val;
  BitMask=0x10;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  *DestTemp++=Val;
  BitMask=0x08;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  *DestTemp++=Val;
  BitMask=0x04;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  *DestTemp++=Val;
  BitMask=0x02;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  *DestTemp++=Val;
  BitMask=0x01;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  *DestTemp++=Val;

//  DestTemp=DestTemp+256-8;
  SourceTemp+=2;
  }
 }

void PlanarToChunky256Col()
 {
 unsigned char *DestTemp=ChunkyTileDestnation;
 unsigned char *SourceTemp=SNESTileSource;
 unsigned char BitMask;
 unsigned char S1,S2,S3,S4,S5,S6,S7,S8,Val;
 long py;

 for (py=0;py<8;py++)
  {
  S1=*(SourceTemp);
  S2=*(SourceTemp+1);
  S3=*(SourceTemp+16);
  S4=*(SourceTemp+17);
  S5=*(SourceTemp+32);
  S6=*(SourceTemp+33);
  S7=*(SourceTemp+48);
  S8=*(SourceTemp+49);
 
  BitMask=0x80;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;

  if ((S5&BitMask)>0)
   Val=Val+16;
  if ((S6&BitMask)>0)
   Val=Val+32;
  if ((S7&BitMask)>0)
   Val=Val+64;
  if ((S8&BitMask)>0)
   Val=Val+128;


  *DestTemp++=Val;
  BitMask=0x40;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  if ((S5&BitMask)>0)
   Val=Val+16;
  if ((S6&BitMask)>0)
   Val=Val+32;
  if ((S7&BitMask)>0)
   Val=Val+64;
  if ((S8&BitMask)>0)
   Val=Val+128;
  *DestTemp++=Val;
  BitMask=0x20;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  if ((S5&BitMask)>0)
   Val=Val+16;
  if ((S6&BitMask)>0)
   Val=Val+32;
  if ((S7&BitMask)>0)
   Val=Val+64;
  if ((S8&BitMask)>0)
   Val=Val+128;
  *DestTemp++=Val;
  BitMask=0x10;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  if ((S5&BitMask)>0)
   Val=Val+16;
  if ((S6&BitMask)>0)
   Val=Val+32;
  if ((S7&BitMask)>0)
   Val=Val+64;
  if ((S8&BitMask)>0)
   Val=Val+128;
  *DestTemp++=Val;
  BitMask=0x08;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  if ((S5&BitMask)>0)
   Val=Val+16;
  if ((S6&BitMask)>0)
   Val=Val+32;
  if ((S7&BitMask)>0)
   Val=Val+64;
  if ((S8&BitMask)>0)
   Val=Val+128;
  *DestTemp++=Val;
  BitMask=0x04;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  if ((S5&BitMask)>0)
   Val=Val+16;
  if ((S6&BitMask)>0)
   Val=Val+32;
  if ((S7&BitMask)>0)
   Val=Val+64;
  if ((S8&BitMask)>0)
   Val=Val+128;
  *DestTemp++=Val;
  BitMask=0x02;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  if ((S5&BitMask)>0)
   Val=Val+16;
  if ((S6&BitMask)>0)
   Val=Val+32;
  if ((S7&BitMask)>0)
   Val=Val+64;
  if ((S8&BitMask)>0)
   Val=Val+128;
  *DestTemp++=Val;
  BitMask=0x01;
  Val=0;
  if ((S1&BitMask)>0)
   Val=Val+1;
  if ((S2&BitMask)>0)
   Val=Val+2;
  if ((S3&BitMask)>0)
   Val=Val+4;
  if ((S4&BitMask)>0)
   Val=Val+8;
  if ((S5&BitMask)>0)
   Val=Val+16;
  if ((S6&BitMask)>0)
   Val=Val+32;
  if ((S7&BitMask)>0)
   Val=Val+64;
  if ((S8&BitMask)>0)
   Val=Val+128;
  *DestTemp++=Val;

//  DestTemp=DestTemp+256-8;
  SourceTemp+=2;
  }
 }



void InitMem()
 {
 int i;
 RealBufferStart=(unsigned char *)malloc((23+1)*65536);
 for(i=0;i<65536*17;i++)
  RealBufferStart[i]=0;
 Buffer1A=(unsigned char *)((long)(RealBufferStart+0x10000*1)&0xffff0000); // Allocate at 64K+ and align
 Buffer1B=(unsigned char *)((long)(RealBufferStart+0x10000*2)&0xffff0000); // Allocate at 128K+ and align
 Buffer1C=(unsigned char *)((long)(RealBufferStart+0x10000*3)&0xffff0000); // Allocate at 192K+ and align
 Buffer1D=(unsigned char *)((long)(RealBufferStart+0x10000*4)&0xffff0000); // Allocate at 256K+ and align

 Buffer2A=(unsigned char *)((long)(RealBufferStart+0x10000*5)&0xffff0000); // Allocate at 64K+ and align
 Buffer2B=(unsigned char *)((long)(RealBufferStart+0x10000*6)&0xffff0000); // Allocate at 128K+ and align
 Buffer2C=(unsigned char *)((long)(RealBufferStart+0x10000*7)&0xffff0000); // Allocate at 192K+ and align
 Buffer2D=(unsigned char *)((long)(RealBufferStart+0x10000*8)&0xffff0000); // Allocate at 256K+ and align

 Buffer3A=(unsigned char *)((long)(RealBufferStart+0x10000*9)&0xffff0000); // Allocate at 64K+ and align
 Buffer3B=(unsigned char *)((long)(RealBufferStart+0x10000*10)&0xffff0000); // Allocate at 128K+ and align
 Buffer3C=(unsigned char *)((long)(RealBufferStart+0x10000*11)&0xffff0000); // Allocate at 192K+ and align
 Buffer3D=(unsigned char *)((long)(RealBufferStart+0x10000*12)&0xffff0000); // Allocate at 256K+ and align

 Buffer4A=(unsigned char *)((long)(RealBufferStart+0x10000*13)&0xffff0000); // Allocate at 64K+ and align
 Buffer4B=(unsigned char *)((long)(RealBufferStart+0x10000*14)&0xffff0000); // Allocate at 128K+ and align
 Buffer4C=(unsigned char *)((long)(RealBufferStart+0x10000*15)&0xffff0000); // Allocate at 192K+ and align
 Buffer4D=(unsigned char *)((long)(RealBufferStart+0x10000*16)&0xffff0000); // Allocate at 256K+ and align

 MergeBuffer=(unsigned char *)((long)(RealBufferStart+0x10000*17)&0xffff0000); // Allocate at 256K+ and align

 SNESVRAM=(unsigned char *)((long)(RealBufferStart+0x10000*18)&0xffff0000); // Allocate at 256K+ and align
 TileCache4=(unsigned char *)((long)(RealBufferStart+0x10000*20)&0xffff0000); // Allocate at 256K+ and align
 TileCache16=(unsigned char *)((long)(RealBufferStart+0x10000*21)&0xffff0000); // Allocate at 256K+ and align
 TileCacheSprite=(unsigned char *)((long)(RealBufferStart+0x10000*22)&0xffff0000); // Allocate at 256K+ and align


 // Align to 8K blocks
 SNESBuffer1Back=(unsigned char *)((long)(RealBufferStart+0x10000*23)&0xffff0000);
 SNESBuffer2Back=SNESBuffer1Back+8192; // 8192
 SNESBuffer3Back=SNESBuffer1Back+8192*2;
 SNESBuffer4Back=SNESBuffer1Back+8192*3;// 32K total

 Buffer1TileHigh=SNESBuffer1Back+8192*4; 
 Buffer2TileHigh=SNESBuffer1Back+8192*5; 
 Buffer3TileHigh=SNESBuffer1Back+8192*6; 
 Buffer4TileHigh=SNESBuffer1Back+8192*7; // 64K 
 }

void PlotSNESScreen(long Position,unsigned char *Buffer)
 {
 ScreenDestnationDest=VESAScreenPtr+Position;
 ScreenDestnationBuffer=Buffer;
 PlotSNESScreenASM();
 }


void PlotMerged3(long Position,unsigned char *Buffer0,
        unsigned char *Buffer1,unsigned char *Buffer2)
 {
 int x,y;
 unsigned char temp;
 for(y=0;y<256;y++)
  {
  for(x=0;x<256;x++)
   {          
   temp=Buffer0[x+(y<<8)];
   if (temp==0)
    temp=Buffer1[x+(y<<8)];
   if (temp==0)
    temp=Buffer2[x+(y<<8)];
   MergeBuffer[x+(y<<8)]=temp;
   }
  }

 PlotSNESScreen(Position,MergeBuffer);

 }



void PlotSNESScreen1A()
 {
 PlotSNESScreen(0,Buffer1A);
 }
void PlotSNESScreen2A()
 {
 PlotSNESScreen(260*3,Buffer2A);
 }
void PlotSNESScreen3A()
 {
 PlotSNESScreen(520*3,Buffer3A);
 }
void PlotSNESScreen4A()
 {
 PlotSNESScreen(800*3*260,Buffer4A);
 }

void PlotSNESScreen1B()
 {
 PlotSNESScreen(800*3+260,Buffer1B);
 }
void PlotSNESScreen2B()
 {
 PlotSNESScreen(3*260,Buffer2B);
 }
void PlotSNESScreen3B()
 {
 PlotSNESScreen(3*520,Buffer4A);
 }
void PlotSNESScreen4B()
 {
 PlotSNESScreen(800*3*260,Buffer4B);
 }


void SetScreenAddress1()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG1SC;
 ctemp=ctemp&0x00fc;
 ltemp=SNESVRAM+(((long)ctemp)<<9) ; // *1024 >>2 <<1
 ScreenAddress1=ltemp;
 }

void SetScreenAddress2()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG2SC;
 ctemp=ctemp&0x00fc;
 ltemp=SNESVRAM+(((long)ctemp)<<9) ; // *1024 >>2 <<1
 ScreenAddress2=ltemp;
 }
void SetScreenAddress3()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG3SC;
 ctemp=ctemp&0x00fc;
 ltemp=SNESVRAM+(((long)ctemp)<<9) ; // *1024 >>2 <<1
 ScreenAddress3=ltemp;
 }
void SetScreenAddress4()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG4SC;
 ctemp=ctemp&0x00fc;
 ltemp=SNESVRAM+(((long)ctemp)<<9) ; // *1024 >>2 <<1
 ScreenAddress4=ltemp;
 }

void SetTileLow1()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG12NBA;
 ltemp=SNESVRAM+((((long)ctemp)&0x000f) <<13);
 TileAddress1=ltemp;
 }

void SetTileHigh1()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG12NBA;
 ltemp=SNESVRAM+((((long)ctemp)&0x00f0) <<9);
 TileAddress1=ltemp;
 }
void SetTileLow2()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG12NBA;
 ltemp=SNESVRAM+((((long)ctemp)&0x000f) <<13);
 TileAddress2=ltemp;
 }

void SetTileHigh2()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG12NBA;
 ltemp=SNESVRAM+((((long)ctemp)&0x00f0) <<9);
 TileAddress2=ltemp;
 }
void SetTileLow3()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG34NBA;
 ltemp=SNESVRAM+((((long)ctemp)&0x000f) <<13);
 TileAddress3=ltemp;
 }

void SetTileHigh3()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG34NBA;
 ltemp=SNESVRAM+((((long)ctemp)&0x00f0) <<9);
 TileAddress3=ltemp;
 }
void SetTileLow4()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG34NBA;
 ltemp=SNESVRAM+((((long)ctemp)&0x000f) <<13);
 TileAddress4=ltemp;
 }

void SetTileHigh4()
 {
 static unsigned char ctemp;
 static unsigned char *ltemp;
 ctemp=E_BG34NBA;
 ltemp=SNESVRAM+((((long)ctemp)&0x00f0) <<9);
 TileAddress4=ltemp;
 }

void PlotPixel(unsigned char *Offset,char Col)
 {
 *Offset=Col;
 }

void box(long pos,unsigned char cola,unsigned char colb,unsigned char colc)
 {

 PlotPixel(VESAScreenPtr+pos*3+1-800*6,0xff);
 PlotPixel(VESAScreenPtr+pos*3+2-800*6,0xff);
 PlotPixel(VESAScreenPtr+pos*3-800*6,0xff);

 PlotPixel(VESAScreenPtr+pos*3+2,cola);
 PlotPixel(VESAScreenPtr+pos*3+1,colb);
 PlotPixel(VESAScreenPtr+pos*3,colc);

 PlotPixel(VESAScreenPtr+pos*3+3+2,cola);
 PlotPixel(VESAScreenPtr+pos*3+3+1,colb);
 PlotPixel(VESAScreenPtr+pos*3+3,colc);

 PlotPixel(VESAScreenPtr+pos*3+800*3+1,cola);
 PlotPixel(VESAScreenPtr+pos*3+800*3+2,colb);
 PlotPixel(VESAScreenPtr+pos*3+800*3,colc);

 PlotPixel(VESAScreenPtr+pos*3+800*3+3+2,cola);
 PlotPixel(VESAScreenPtr+pos*3+800*3+3+1,colb);
 PlotPixel(VESAScreenPtr+pos*3+800*3+3,colc);

 PlotPixel(VESAScreenPtr+pos*3+800*3*2+2,cola);
 PlotPixel(VESAScreenPtr+pos*3+800*3*2+1,colb);
 PlotPixel(VESAScreenPtr+pos*3+800*3*2,colc);

 PlotPixel(VESAScreenPtr+pos*3+800*3*2+3+2,cola);
 PlotPixel(VESAScreenPtr+pos*3+800*3*2+3+1,colb);
 PlotPixel(VESAScreenPtr+pos*3+800*3*2+3,colc);
 }

