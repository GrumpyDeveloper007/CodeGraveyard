
typedef long Fixed;          // 16.16 range +/- 32768 int +/-32768 floaty

#define Int2Fixed(x) ((x) << 16)
#define Fixed2Int(x) ((x) >> 16)
#define Float2Fixed(x) ((Fixed)((x) * 65536.0))
#define Fixed2Float(x) ((float)((x) / 65536.0))

Fixed FixedMul(Fixed num1, Fixed num2)
{
 return (Float2Fixed(Fixed2Float(num1)*Fixed2Float(num2)));
}

Fixed FixedDiv(Fixed numer, Fixed denom)  // No rounding!
{
 return (Float2Fixed(Fixed2Float(numer)/Fixed2Float(denom)));
}

#define SCR_HEIGHT 600
#define WINTOP 0
#define WINLEFT 0
#define WINRIGHT 320
#define WINBOTTOM 400

short ScanBufferLeft[SCR_HEIGHT],ScanBufferRight[SCR_HEIGHT];   // For converting polygons!
long YMin,YMax;

Fixed ULeft[SCR_HEIGHT],URight[SCR_HEIGHT];
Fixed VLeft[SCR_HEIGHT],VRight[SCR_HEIGHT];

void ScanConvEdgeWin2d(Fixed x1,Fixed y1,Fixed tx1,Fixed ty1,Fixed x2,Fixed y2,Fixed tx2,Fixed ty2)   // To convert standard poly
 {
 Fixed mx;   // slope of x
 Fixed mtx,mty; // slope of u,v
 Fixed temp; // for swapping
 Fixed x,y;  // source x and y screen coordinates
 Fixed tx,ty; // source u,v coordinates
 long xint;

 if(y1 > y2) // make sure that edge goes from top to bottom
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;

  temp=tx1;
  tx1=tx2;
  tx2=temp;

  temp=ty1;
  ty1=ty2;
  ty2=temp;
  }

 if (y1<YMin)
  YMin=y1;
 if (y2>YMax)
  YMax=y2;

 if((y2-y1) != 0) // initialize the slopes for stepping the edges
  {
  mx = (Int2Fixed(x2-x1)) / (y2-y1); // dx/dy
  mtx = (tx2-tx1) / (y2-y1); // Fixed(dtx)/dy
  mty = (ty2-ty1) / (y2-y1); // Fixed(dty)/dy
  }
 else
  {
  mx = (Int2Fixed(x2-x1)); // dx
  mtx = tx2-tx1; // Fixed(dtx)
  mty = ty2-ty1; // Fixed(dty)
  }

 x=Int2Fixed(x1);
 tx=tx1;
 ty=ty1;
 for(y=y1;y<=y2;y++)
  {
  if (y>=WINTOP && y<=WINBOTTOM)
   {
	  xint=Fixed2Int(x);
   if (xint<ScanBufferLeft[y])
     {
     ScanBufferLeft[y]=(short)xint;
     ULeft[y]=tx;
     VLeft[y]=ty;
     }
   if (xint>ScanBufferRight[y])
     {
     ScanBufferRight[y]=(short)xint;
     URight[y]=tx;
     VRight[y]=ty;
     }
   }
  x+=mx;
  tx+=mtx;
  ty+=mty;
  }
 }

void cOBJECT::TextureFacePlot(unsigned char *TextureBuffer,VertexTYPE *Vertices,int NumSides,int width,MFLOAT Z)
 {
 Fixed u,v,du,dv;
 int j,n,i;
 long jmul;
 int calc;
 long *PolyBufferPtr;
 MFLOAT *ZBufferPtr;
 unsigned char *ScreenPtr;

 YMin=WINBOTTOM;        // set up optimal buffers
 YMax=WINTOP;

 for(j=0;j<SCR_HEIGHT;j++)     // Initialises Scanbuffer
  {
  ScanBufferLeft[j]=WINRIGHT;
  ScanBufferRight[j]=WINLEFT;
  }               

 j=NumSides-1;  // set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWin2d((long)Vertices[j].sx,(long)Vertices[j].sy,(long)Float2Fixed(Vertices[j].u),Float2Fixed(Vertices[j].v),(long)Vertices[n].sx,(long)Vertices[n].sy,(long)Float2Fixed(Vertices[n].u),(long)Float2Fixed(Vertices[n].v));
  j=n;
  }

 int TWidth=width;

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 if (YMin!=YMax)
  for (j=YMin;j<=YMax;j++)       // set to YMin+1 for now as avoids an error!
   {
   int ScanLeft,ScanRight;

   ScanLeft=ScanBufferLeft[j];
   ScanRight=ScanBufferRight[j];

   // Set texture look ups for current span!

   if( (ScanRight-ScanLeft)!=0)
    {
    du=FixedDiv((URight[j]-ULeft[j]),Int2Fixed(ScanRight-ScanLeft));
    dv=FixedDiv((VRight[j]-VLeft[j]),Int2Fixed(ScanRight-ScanLeft));
    }
   else
    {
    du=URight[j]-ULeft[j];
    dv=VRight[j]-VLeft[j];
    }
 
   u=ULeft[j];
   v=VLeft[j];

   if (ScanLeft<WINLEFT) // is poly span left visible
    {
    u+=FixedMul(du,Int2Fixed(WINLEFT-ScanLeft));     // adjust u (clipped!)
    v+=FixedMul(dv,Int2Fixed(WINLEFT-ScanLeft));     // adjust v (clipped!)
    ScanLeft=WINLEFT;
    }
   if (ScanRight>WINRIGHT)
    ScanRight=WINRIGHT;

//   if (ScanLeft<ScanRight)
    {
	   jmul=j*320+ScanLeft;
	   PolyBufferPtr=&PolyBuffer[jmul];
	   ZBufferPtr=&MainWindow.ZBuffer[j*MainWindow.SizeX+ScanLeft];
	   ScreenPtr=&MainWindow.FrontBuffer[(ScanLeft+j*MainWindow.SizeX)*MainWindow.PixelLength];

    for (i=ScanLeft;i<ScanRight;i++)
     {
		calc=((u>>16)+((v>>8)&0xffffff00)/* *TWidth*/)*3;
	   
		if (*ZBufferPtr>Z)
		{
		//MainWindow.Dot(i,j,TextureBuffer[calc+2],TextureBuffer[calc+1],
		//	TextureBuffer[calc]);
		*ScreenPtr=TextureBuffer[calc];
		*(ScreenPtr+1)=TextureBuffer[calc+1];
		*(ScreenPtr+2)=TextureBuffer[calc+2];

		*PolyBufferPtr=(long)CurrentPolyNum;
		*ZBufferPtr=Z;
		}
		ScreenPtr+=MainWindow.PixelLength;
		PolyBufferPtr++;
		ZBufferPtr++;
     u+=du;
     v+=dv;
     }
    }
   }
  
 }

