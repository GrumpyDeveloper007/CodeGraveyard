#include <stdio.h>
#include <stdlib.h>
#include <dos.h>
#include <pc.h>
#include <io.h>
#include <fcntl.h>

#include <go32.h>
#include <sys/farptr.h>
#include <dpmi.h>

#define BitSet(x,bits) (x|bits)
#define BitReset(x,bits) (x & ~bits)
#define CLAMPMIN(n,min) if ((n) < (min)) (n) = (min);
#define CLAMPMAX(n,max) if ((n) > (max)) (n) = (max);

//sequencer index port
#define SEQUENCER 0x3C4

#define CRT_CONTROL 0x3D4
#define GFX_CONTROL 0x3CE
#define MAX_SCANLINE 0x09
#define ADDR_MODE 0x14
#define MODE_CONTROL 0x17
#define GFX_WRITE_MODE 0x05
#define GFX_MISC 0x06
#define SEQ_PLANE_ENABLE 0x02
#define SEQ_MEMORY_MODE 0x04
#define INP_STAT_1 0x03DA 
#define VSYNC_MASK (1<<3) 
#define ATTR_CTRL  0x03C0
#define PAL_INDEX  0x03C8
#define PAL_WRITE  0x03C9
#define INP_STAT_1 0x03DA
#define PAS_SET    (1<<5)
#define OVRSCN_CLR 0x0011

#define GAMMA  1.0
//1.2

#define VPAGE1 0xa0000
static char planeMask[320];
static char* VBuffer[4] = 
            {(char *) VPAGE1,(char *) VPAGE1+80,(char *) VPAGE1+(1<<15),(char *) VPAGE1+(1<<15)+80};

// Intensity Range, Intensity Max Value
#define IRANGE 256
#define IMAX ((float)(IRANGE-1))
static unsigned char gtab[IRANGE];
static long gcolors[256];

// 1.0 = no gamma correction
void compGamma(float intensity) 
{
  long i;
  CLAMPMIN(intensity,.01);
  for (i=0; i < IRANGE ; i++) 
  {
    //gtab[i] = IMAX*pow(i/IMAX,1./intensity) + .5;
    gtab[i] = IMAX*(i/IMAX) +0.5;
  } // for
} // compGamma

void setPalette(long * colors,long count,float gamma) 
{
  long i;
  compGamma(gamma);
  CLAMPMAX(count,256);
  outportb(0x3C8,0);   // Reset write color palette index
  for (i=0; i < count; i++) 
  {
    unsigned char r,g,b;
    r = colors[i] & 0xff;
//    r = gtab[r];
    outportb(0x3C9,r); // Write to color palette index: it autoincrements
    g = (colors[i] >> 8) & 0xff;
  //  g = gtab[g];
    outportb(0x3C9,g); // Write to color palette index: it autoincrements
    b = (colors[i] >> 16) & 0xff;
    //b = gtab[b];
    outportb(0x3C9,b); // Write to color palette index: it autoincrements
  } // for
} // setPalette

void setGamma(float gamma) 
{
  setPalette(gcolors,256,gamma);
} // setGamma

void setOverscanColor(long color) 
{
  inportb(INP_STAT_1);
  outportb(ATTR_CTRL,OVRSCN_CLR);
  outportb(ATTR_CTRL,color);
  inportb(INP_STAT_1);
  outportb(ATTR_CTRL,PAS_SET);
} // setOverscanColor


void SetMode(short mode)
{
   __dpmi_regs r;
   r.x.ax =mode;
   __dpmi_int(0x10,&r);
}

void ResetVGAMode()
{
   SetMode(3);
}

void ClearScreen()
{
  int i;
  /*!!! CSL CHANGE */
  _farsetsel(_dos_ds); 
  for (i=0; i < (1<<15); i++) 
  { /* clear all pages ie 320*400 screen*/
    _farnspokel(VPAGE1+i, 0);
  } // for
}
void setViewPageAddr(unsigned long addr) 
{
  unsigned short a,b;
  b = (addr & 0xff00) | 0xc;
  a = ((addr << 8) & 0xff00) | 0xd;
  outportw(CRT_CONTROL,a);
  outportw(CRT_CONTROL,b);

} // setViewPageAddr

void waitVS(void) 
{
  /* If active, wait for inactive */
  if (inportb(INP_STAT_1) & VSYNC_MASK) 
  {
        /* Wait for inactive */
        while (1) 
        {
          if (!(inportb(INP_STAT_1) & VSYNC_MASK)) break;
        } // while
  } // if

  /* Wait for active */
  while (1) 
  {
        if ((inportb(INP_STAT_1) & VSYNC_MASK)) break;
  } // while

} // waitVS


void VGA400Mode (void)
{
  int data,i;
  for (i=0; i < 320; i++) planeMask[i] = (1<<(i&3));
  SetMode(0x13);

  outportb(CRT_CONTROL, MAX_SCANLINE);
  data=inportb(CRT_CONTROL+1);
  outportb(CRT_CONTROL+1, BitReset(data,0x0f));

  outportb(CRT_CONTROL, ADDR_MODE);
  data=inportb(CRT_CONTROL+1);
  outportb(CRT_CONTROL+1, BitReset(data,0x40));

  outportb(CRT_CONTROL, MODE_CONTROL);
  data=inportb(CRT_CONTROL+1);
  outportb(CRT_CONTROL+1, BitSet(data,0x40));

  outportb(GFX_CONTROL, GFX_WRITE_MODE);
  data=inportb(GFX_CONTROL+1);
  outportb(GFX_CONTROL+1, BitReset(data,0x10));

  outportb(GFX_CONTROL, GFX_MISC);
  data=inportb(GFX_CONTROL+1);
  outportb(GFX_CONTROL+1, BitReset(data,0x02));

  outportb(SEQUENCER, SEQ_MEMORY_MODE);
  data=inportb(SEQUENCER+1);
  data=BitReset(data,0x08);
  data=BitSet(data,0x04);
  outportb(SEQUENCER+1,data);

  outportb(SEQUENCER, SEQ_PLANE_ENABLE);
  outportb(SEQUENCER+1,0x0f);

  for (i=0; i < 256; i++) 
  {
    unsigned char r,g,b;
    
    /* scaled colours 
    r = (i&7)*63/7;
    g = ((i>>3)&7)*63/7;
    b = (i>>6)*63/3;  
    */    
    
    /* grey scale instead?  */
    r=g=b=(i>>1)&(0x7f);
    
    gcolors[i] = (b<<16)|(g<<8)|r;
    
  } // for

  setPalette(gcolors,256,GAMMA);

  setOverscanColor(0);

  /* Clear the screen ie 320*400/4 planes */
  ClearScreen();
} /* end VGA400Mode */

void WritePix (int x, int y, int col)
{
  outportb(SEQUENCER, SEQ_PLANE_ENABLE);
  outportb(SEQUENCER+1,planeMask[x]);

  _farpokeb(_dos_ds, VPAGE1+(y<<6)+(y<<4)+(x>>2), (unsigned char) col);

} /* end WritePix */

void ClearPage400 (long PageAddr, long col)
{
   register long p = (long) VBuffer[PageAddr];
   long i;
   
   outportb(SEQUENCER, SEQ_PLANE_ENABLE);
   outportb(SEQUENCER+1,0x0f);
   col = (col<<24)|(col<<16)|(col<<8)|col;
   _farsetsel(_dos_ds);
   for (i=0; i<320*400/4/4; i++)
   {
      _farnspokel(p++, col);  
      _farnspokel(p++, col);
      _farnspokel(p++, col);
      _farnspokel(p++, col);
   } 
} /* end ClearPage400 */

void CopyPage400 (long DestPage, char* SrcPage)
{
   long * DestAddr;
   long i,j;
   outportb (SEQUENCER, SEQ_PLANE_ENABLE);
   _farsetsel(_dos_ds);
   for (j=0; j<4; j++)
   {
      outportb(SEQUENCER+1, 1<<j);
      DestAddr=(long *) VBuffer[DestPage];
      for (i=0; i<320*400;i+=16)
      {
         long ij = i+j;
         _farnspokel((long)(DestAddr++),
                     SrcPage[ij]|(SrcPage[ij+4]<<8)|(SrcPage[ij+8]<<16)|(SrcPage[ij+12]<<24));
         
      } /* end loop i */
   } /* end loop j */
} /* end CopyPage400 */

static void InterleavePage (long DestPage, char* SrcPage)
{
   unsigned long *DestAddr;
   long i,j,k;
   outportb (SEQUENCER, SEQ_PLANE_ENABLE); 
   for (j=0; j<4; j++)
   {
      outportb(SEQUENCER+1, 1<<j); 
      DestAddr=(unsigned long *) VBuffer[DestPage]; 
      for (k=0; k<320*200; k+=320)
      {
         long jk = j+k;
         for (i=0; i<320; i+=16)
         {
            long ijk = i+jk;
            _farnspokel((unsigned long)(DestAddr++),
                     SrcPage[ijk]|(SrcPage[ijk+4]<<8)|(SrcPage[ijk+8]<<16)|(SrcPage[ijk+12]<<24));

         } //end i loop over x direction
         DestAddr +=20; // 80/4 skip next scanline
      } // end k loop 200 lines
   } // end j loop over planes

} /* end InterleavePage */

void RenderStereo (long DestPage, char * srcL, char * srcR)
{
   InterleavePage(DestPage, srcL);
   InterleavePage(DestPage+1, srcR);
} /* end RenderStereo */


