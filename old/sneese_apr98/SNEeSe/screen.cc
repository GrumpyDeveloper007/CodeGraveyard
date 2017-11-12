// Mode0- 4col,4col,4col,4col
// Mode1- 16col,16col,4col
// Mode2- 16col,16col
// Mode3- 256col,4col
// Mode4- 256col,16col
// Mode5- 16col,4col(512 width(16wide tiles))
// Mode6- 16col(16wide tiles)
// Mode7- 256col(special)

void ClearBuffer(unsigned char *Buffer)
 {
 unsigned long *BufferTemp=(unsigned long *)Buffer;
 int i;
 for (i=0;i<65536/4;i++)
  *BufferTemp++=0;
 }

void DoMosaicX(unsigned char *Buffer)
 {
 unsigned char TempVal;
 TempVal=E_MOSAIC>>4;
 int i,t;
 unsigned char CurrentPixel;
 CurrentPixel=*(Buffer++);
 for (i=0;i<256/TempVal;i++)
  {
  for (t=0;t<TempVal-1;t++)
   {
   *(Buffer++)=CurrentPixel;
   }
  CurrentPixel=*(Buffer++);
  }
 for (t=0;t<(256%TempVal)-1;t++)
  {
  *(Buffer++)=CurrentPixel;
  }
 }

void SetMosaic(unsigned short Mask) // Mask is screen ID
 {
 unsigned char TempVal;
 Mask+=1;
  TempVal=E_MOSAIC>>4;
  if (TempVal==1)
   {
   Tile0=TileXTableF0M1;
   TileX=TileXTableF1M1;
   TileY=TileXTableF1M1;
   }
  else
   {
   if (TempVal==3)
    {
    Tile0=TileXTableF0M3;
    TileX=TileXTableF1M3;
    TileY=TileXTableF1M3;
    }          
   else
    {
    if (TempVal==7)
     {
     Tile0=TileXTableF0M7;
     TileX=TileXTableF1M7;
     TileY=TileXTableF1M7;
     }
   else
     {
     Tile0=TileXTableF0M0;
     TileX=TileXTableF1M0;
     TileY=TileXTableF1M0;
     }
    }
   }

 }

void SetLayoutPtr()
 {
 if ((LayoutReg&0x3)==0)
  LayoutPtr=Layout0;
 if ((LayoutReg&0x3)==1)
  LayoutPtr=Layout1;
 if ((LayoutReg&0x3)==2)
  LayoutPtr=Layout2;
 if ((LayoutReg&0x3)==3)
  LayoutPtr=Layout3;
 }

void RenderMode0()
 {
 if ((E_TM&1)==1)
  {
  SetMosaic(0x1);
  ScreenDestnation=Buffer1A;
  ScreenAddr=ScreenAddress1;
  TileFetch=TileAddress1;
  InitCache4(TileFetch);
  LayoutReg=E_BG1SC;
  SetLayoutPtr();
  WindowXScroll=E_BG1HScrollData;
  WindowYScroll=E_BG1VScrollData;
  RenderWindow4();
  Buffer1AClear=0;
  }
 else
  {
  ClearBuffer(Buffer1A);
  Buffer1AClear|=1;
  }

 if ((E_TM&2)==2)
  {
  SetMosaic(2);
  ScreenDestnation=Buffer2A;
  ScreenAddr=ScreenAddress2;
  TileFetch=TileAddress2;
  InitCache4(TileFetch);
  LayoutReg=E_BG2SC;
  WindowXScroll=E_BG2HScrollData;
  WindowYScroll=E_BG2VScrollData;
  RenderWindow4();
  Buffer2AClear=0;
  }
 else
  {
  ClearBuffer(Buffer2A);
  Buffer2AClear|=1;
  }

 if ((E_TM&4)==4)
  {
  SetMosaic(4);
  ScreenDestnation=Buffer3A;
  ScreenAddr=ScreenAddress3;
  TileFetch=TileAddress3;
  InitCache4(TileFetch);
  LayoutReg=E_BG3SC;
  SetLayoutPtr();
  WindowXScroll=E_BG3HScrollData;
  WindowYScroll=E_BG3VScrollData;
  RenderWindow4();
  Buffer3AClear=0;
  }
 else
  {
  ClearBuffer(Buffer3A);
  Buffer3AClear|=1;
  }

 if ((E_TM&8)==8)
  {
  SetMosaic(8);
  ScreenDestnation=Buffer4A;
  ScreenAddr=ScreenAddress4;
  TileFetch=TileAddress4;
  InitCache4(TileFetch);
  LayoutReg=E_BG4SC;
  SetLayoutPtr();
  WindowXScroll=E_BG4HScrollData;
  WindowYScroll=E_BG4VScrollData;
  RenderWindow4();
  Buffer4AClear=0;
  }
 else
  {
  ClearBuffer(Buffer4A);
  Buffer4AClear|=1;
  }
 }

void RenderMode1()
 {
 if ((E_TM&1)==1)
  {
  SetMosaic(1);
  ScreenDestnation=Buffer1A;
  ScreenAddr=ScreenAddress1;
  TileFetch=TileAddress1;
  InitCache16(TileFetch);
  LayoutReg=E_BG1SC;
  SetLayoutPtr();
  WindowXScroll=E_BG1HScrollData;
  WindowYScroll=E_BG1VScrollData;
  RenderWindow16();
  Buffer1AClear=0;
  }
 else
  {
  ClearBuffer(Buffer1A);
  Buffer1AClear|=1;
  }

// if ((E_TM&2)==2)
  {
  SetMosaic(2);
  ScreenDestnation=Buffer2A;
  ScreenAddr=ScreenAddress2;
  TileFetch=TileAddress2;
  InitCache16(TileFetch);
  LayoutReg=E_BG2SC;
  SetLayoutPtr();
  WindowXScroll=E_BG2HScrollData;
  WindowYScroll=E_BG2VScrollData;
  RenderWindow16();
  Buffer2AClear=0;
  }
//  }
// else
//  {
//  ClearBuffer(Buffer2A);
//  Buffer2AClear|=1;
//  }

 if ((E_TM&4)==4)
  {
  SetMosaic(4);
  ScreenDestnation=Buffer3A;
  ScreenAddr=ScreenAddress3;
  TileFetch=TileAddress3;
  InitCache4(TileFetch);
  LayoutReg=E_BG3SC;
  SetLayoutPtr();
  WindowXScroll=E_BG3HScrollData;
  WindowYScroll=E_BG3VScrollData;
  RenderWindow4();
  Buffer3AClear=0;
  }
 else
  {
  ClearBuffer(Buffer3A);
  Buffer3AClear|=1;
  }
 }

void RenderMode2()
 {
 if ((E_TM&1)==1)
  {
  SetMosaic(1);
  ScreenDestnation=Buffer1A;
  ScreenAddr=ScreenAddress1;
  TileFetch=TileAddress1;
  InitCache16(TileFetch);
  LayoutReg=E_BG1SC;
  SetLayoutPtr();
  WindowXScroll=E_BG1HScrollData;
  WindowYScroll=E_BG1VScrollData;
  RenderWindow16();
  Buffer1AClear=0;
  }
 else
  {
  ClearBuffer(Buffer1A);
  Buffer1AClear|=1;
  }

 if ((E_TM&2)==2)
  {
  SetMosaic(2);
  ScreenDestnation=Buffer2A;
  ScreenAddr=ScreenAddress2;
  TileFetch=TileAddress2;
  InitCache16(TileFetch);
  LayoutReg=E_BG2SC;
  SetLayoutPtr();
  WindowXScroll=E_BG2HScrollData;
  WindowYScroll=E_BG2VScrollData;
  RenderWindow16();
  Buffer2AClear=0;
  }
 else
  {
  ClearBuffer(Buffer2A);
  Buffer2AClear|=1;
  }
 }

void RenderMode3()
 {
 if ((E_TM&1)==1)
  {
  SetMosaic(1);
  ScreenDestnation=Buffer1A;
  ScreenAddr=ScreenAddress1;
  TileFetch=TileAddress1;
  LayoutReg=E_BG1SC;
  SetLayoutPtr();
  WindowXScroll=E_BG1HScrollData;
  WindowYScroll=E_BG1VScrollData;
  RenderWindow256();
  Buffer1AClear=0;
  }
 else
  {
  ClearBuffer(Buffer1A);
  Buffer1AClear|=1;
  }

 if ((E_TM&2)==2)
  {
  SetMosaic(2);
  ScreenDestnation=Buffer2A;
  ScreenAddr=ScreenAddress2;
  TileFetch=TileAddress2;
  InitCache4(TileFetch);
  LayoutReg=E_BG2SC;
  SetLayoutPtr();
  WindowXScroll=E_BG2HScrollData;
  WindowYScroll=E_BG2VScrollData;
  RenderWindow4();
  Buffer2AClear=0;
  }
 else
  {
  ClearBuffer(Buffer2A);
  Buffer2AClear|=1;
  }
 }

void RenderMode4()
 {
 if ((E_TM&1)==1)
  {
  SetMosaic(1);
  ScreenDestnation=Buffer1A;
  ScreenAddr=ScreenAddress1;
  TileFetch=TileAddress1;
  LayoutReg=E_BG1SC;
  SetLayoutPtr();
  WindowXScroll=E_BG1HScrollData;
  WindowYScroll=E_BG1VScrollData;
  RenderWindow256();
  Buffer1AClear=0;
  }
 else
  {
  ClearBuffer(Buffer1A);
  Buffer1AClear|=1;
  }

 if ((E_TM&2)==2)
  {
  SetMosaic(2);
  ScreenDestnation=Buffer2A;
  ScreenAddr=ScreenAddress2;
  TileFetch=TileAddress2;
  InitCache16(TileFetch);
  LayoutReg=E_BG2SC;
  SetLayoutPtr();
  WindowXScroll=E_BG2HScrollData;
  WindowYScroll=E_BG2VScrollData;
  RenderWindow16();
  Buffer2AClear=0;
  }
 else
  {
  ClearBuffer(Buffer2A);
  Buffer2AClear|=1;
  }
 }

void RenderMode5()
 {
 if ((E_TM&1)==1)
  {
  SetMosaic(1);
  ScreenDestnation=Buffer1A;
  ScreenAddr=ScreenAddress1;
  TileFetch=TileAddress1;
  LayoutReg=E_BG1SC;
  SetLayoutPtr();
  WindowXScroll=E_BG1HScrollData;
  WindowYScroll=E_BG1VScrollData;
  RenderWindow16a();
  Buffer1AClear=0;
  }
 else
  {
  ClearBuffer(Buffer1A);
  Buffer1AClear|=1;
  }


 if ((E_TM&2)==2)
  {
  SetMosaic(2);
  ScreenDestnation=Buffer2A;
  ScreenAddr=ScreenAddress2;
  TileFetch=TileAddress2;
  InitCache4(TileFetch);
  LayoutReg=E_BG2SC;
  SetLayoutPtr();
  WindowXScroll=E_BG2HScrollData;
  WindowYScroll=E_BG2VScrollData;
  RenderWindow4a();
  Buffer2AClear=0;
  }
 else
  {
  ClearBuffer(Buffer2A);
  Buffer2AClear|=1;
  }
 }

void RenderMode6()
 {
 if ((E_TM&1)==1)
  {
  SetMosaic(1);
  ScreenDestnation=Buffer1A;
  ScreenAddr=ScreenAddress1;
  TileFetch=TileAddress1;
  LayoutReg=E_BG1SC;
  SetLayoutPtr();
  WindowXScroll=E_BG1HScrollData;
  WindowYScroll=E_BG1VScrollData;
  RenderWindow16a();
  Buffer1AClear=0;
  }
 else
  {
  ClearBuffer(Buffer1A);
  Buffer1AClear|=1;
  }
 }
