/*

 Texture Routines & Scan Conversion (Seperated for faster compile!)

  Design & Code By Xavier / Phobia '96

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include "h\3dengine.h"

unsigned char LightTables[32][256];

short ScanBufferLeft[200],ScanBufferRight[200];   // For converting polygons!
short YMin,YMax;
char LightBufferLeft[200],LightBufferRight[200];        // For converting polygons!
Fixed ULeft[200],URight[200];   // For converting 2d polygons!
Fixed VLeft[200],VRight[200];   // For converting 2d polygons!

//  The following 2 colour based functions are put in here because they
// are to do with the correction of textures

short FindClosestRGB(short Red,short Green,short Blue,unsigned char *Palette)
 {
 long DiffPal,Val1,Val2,Val3;                           
 unsigned long ClosestDif,ClosestCol;

 ClosestDif=-1;      // furthest away possible!

 for (int a=0;a<256;a++)
  {
  Val1=Red-Palette[a*3+0];
  if (Val1<0)
   Val1*=-1;
  Val2=Green-Palette[a*3+1];
  if (Val2<0)
   Val2*=-1;
  Val3=Blue-Palette[a*3+2];
  if (Val3<0)
   Val3*=-1;
  DiffPal=Val1+Val2+Val3;
  if (DiffPal<ClosestDif)
   {
   ClosestDif=DiffPal;
   ClosestCol=a;
   }
  }
 return ClosestCol;
 }

void BuildLightTables()
 {
 int red,green,blue,col;
 for (int a=0;a<32;a++)
  {
  for (int b=0;b<256;b++)       // for all colours
   {
   red=Map->Palette[b*3+0]-(31-a)*2;   // reduce colour intensity
   green=Map->Palette[b*3+1]-(31-a)*2;
   blue=Map->Palette[b*3+2]-(31-a)*2;
   if (red<0)
    red=0;
   if (green<0)
    green=0;
   if (blue<0)
    blue=0;
   col=FindClosestRGB(red,green,blue,Map->Palette);
   LightTables[a][b]=col;
   }
  }
 }


void ScanConvEdgeWin(Fixed x1,Fixed y1,Fixed x2,Fixed y2)   // To convert standard poly
 {
 Fixed mx;   // slope of x
 Fixed temp; // for swapping
 Fixed x,y;  // source x and y screen coordinates

 if(y1 > y2) // make sure that edge goes from top to bottom
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;
  }

 if (y1<YMin)
  YMin=y1;
 if (y2>YMax)
  YMax=y2;

 if((y2-y1) != 0) // initialize the slopes for stepping the edges
  mx = (Int2Fixed(x2-x1)) / (y2-y1); // dx/dy
 else
  mx = (Int2Fixed(x2-x1)); // dx

 x=Int2Fixed(x1);
 for(y=y1;y<=y2;y++)
  {
  if (y>=WINTOP && y<=WINBOTTOM)
   {
   if (Fixed2Int(x)<ScanBufferLeft[y])
     ScanBufferLeft[y]=(Fixed2Int(x));
   if (Fixed2Int(x)>ScanBufferRight[y])
     ScanBufferRight[y]=(Fixed2Int(x));
   }
  x+=mx;
  }
 }

// this one is for real light sourcing  ( KEWL HUH! )

void ScanConvEdgeWinG(Fixed x1,Fixed y1,Fixed light1,Fixed x2,Fixed y2,Fixed light2)  // To convert standard poly
 {
 Fixed mx,ml;   // slope of x and light
 Fixed temp;    // for swapping
 Fixed x,y,l;   // source x and y screen coordinates, and light

 if(y1 > y2) // make sure that edge goes from top to bottom
  {
  temp=x1;  // we need to swap the coordinates around
  x1=x2;
  x2=temp;

  temp=y1;
  y1=y2;
  y2=temp;

  temp=light1;
  light1=light2;
  light2=temp;
  }

 if (y1<YMin)
  YMin=y1;
 if (y2>YMax)
  YMax=y2;

 if((y2-y1) != 0) // initialize the slopes for stepping the edges
  {
  mx = (Int2Fixed(x2-x1)) / (y2-y1); // dx/dy
  ml = (Int2Fixed(light2-light1)) / (y2-y1); //dl/dy
  }
 else
  {
  mx = (Int2Fixed(x2-x1)); // dx
  ml = (Int2Fixed(light2-light1)); // dl
  }

 x=Int2Fixed(x1);
 l=Int2Fixed(light1);

 for(y=y1;y<=y2;y++)
  {
  if (y>=WINTOP && y<=WINBOTTOM)
   {
   if ((Fixed2Int(x))<ScanBufferLeft[y])
    {
    ScanBufferLeft[y]=Fixed2Int(x);
    LightBufferLeft[y]=Fixed2Int(l);
    }
   if ((Fixed2Int(x))>ScanBufferRight[y])
    {
    ScanBufferRight[y]=Fixed2Int(x);
    LightBufferRight[y]=Fixed2Int(l);
    }
   }
  x+=mx;
  l+=ml;
  }
 }

void ScanConvEdgeWin2d(Fixed x1,Fixed y1,Fixed tx1,Fixed ty1,Fixed x2,Fixed y2,Fixed tx2,Fixed ty2)   // To convert standard poly
 {
 Fixed mx;   // slope of x
 Fixed mtx,mty; // slope of u,v
 Fixed temp; // for swapping
 Fixed x,y;  // source x and y screen coordinates
 Fixed tx,ty; // source u,v coordinates

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
   if (Fixed2Int(x)<ScanBufferLeft[y])
     {
     ScanBufferLeft[y]=(Fixed2Int(x));
     ULeft[y]=tx;
     VLeft[y]=ty;
     }
   if (Fixed2Int(x)>ScanBufferRight[y])
     {
     ScanBufferRight[y]=(Fixed2Int(x));
     URight[y]=tx;
     VRight[y]=ty;
     }
   }
  x+=mx;
  tx+=mtx;
  ty+=mty;
  }
 }


void TexturePlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float Px,Py,Pz,Mx,My,Mz,Nx,Ny,Nz;
 float Oa,Ha,Va,Ob,Hb,Vb,Oc,Hc,Vc;
 float a,b,c;
 float u,v;
 int j,n,i;

 Px=Perspective*Polygon->TxtP->wx;	// In my coords 0 is the origin of the square
 Py=InvPerspective*Polygon->TxtP->wy;     // Remember the Coords are being swapped here! (Z & Y)
 Pz=Polygon->TxtP->wz;

 Mx=(Perspective*Polygon->TxtM->wx-Px)*Polygon->TextureModX; // Create Vector M
 My=(InvPerspective*Polygon->TxtM->wy-Py)*Polygon->TextureModX;
 Mz=(Polygon->TxtM->wz-Pz)*Polygon->TextureModX;

 Nx=(Perspective*Polygon->TxtN->wx-Px)*Polygon->TextureModY; // Create Vector N
 Ny=(InvPerspective*Polygon->TxtN->wy-Py)*Polygon->TextureModY;
 Nz=(Polygon->TxtN->wz-Pz)*Polygon->TextureModY;

 Oa=Ny*Px-Nx*Py;	// Compute magic numbers
 Ha=Nz*Py-Ny*Pz;
 Va=Nx*Pz-Nz*Px;

 Ob=Mx*Py-My*Px;
 Hb=My*Pz-Mz*Py;
 Vb=Mz*Px-Mx*Pz;

 Oc=My*Nx-Mx*Ny;
 Hc=Mz*Ny-My*Nz;
 Vc=Mx*Nz-Mz*Nx;

 unsigned char *GFXPointer=Map->Graphic[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

 for(i=0;i<200;i++)	// Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWin(Vertices[j].sx,Vertices[j].sy,Vertices[n].sx,Vertices[n].sy);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 int Cu,Cv;
 int THeight=Polygon->Texture->Height;
 int TWidth=Polygon->Texture->Width;
 int XMask=Polygon->Texture->Width-1;
 int YMask=Polygon->Texture->Height-1;
 int OffX=Polygon->TextOffX;
 int OffY=Polygon->TextOffY;

 for (j=YMin;j<=YMax;j++)	// set to YMin+1 for now as avoids an error!
  {
// The following tests are to determine if a drawing span is visible

  ListNode *Pointer=ScanLine[j].Root;

  int ScanLeft,ScanRight;

  while (Pointer!=NULL)
   {
   ScanLeft=ScanBufferLeft[j];
   ScanRight=ScanBufferRight[j];

   if (ScanLeft<Pointer->Left) // is poly span left visible
    ScanLeft=Pointer->Left;
   if (ScanRight>Pointer->Right)
    ScanRight=Pointer->Right;

   // Only draws if the span is valid e.g. Left - Right

   if (ScanLeft<ScanRight)
    {
    a = Oa+(j-VCENTER)*Va;	// Intermediate values
    b = Ob+(j-VCENTER)*Vb;
    c = Oc+(j-VCENTER)*Vc;


    a+= (ScanLeft-HCENTER)*Ha;
    b+= (ScanLeft-HCENTER)*Hb;
    c+= (ScanLeft-HCENTER)*Hc;

    for (i=ScanLeft;i<ScanRight;i++)
     {
     u = OffX+THeight*a/c;  // Texture coordinates
     v = OffY+TWidth*b/c;

     Cu=((int)u)&XMask;	// Should allow wraparound textures
     Cv=((int)v)&YMask;

     VirtualScreen[i+j*320]=GFXPointer[Cu+Cv*TWidth];

     a+= Ha;	// Intermediate values
     b+= Hb;
     c+= Hc;
     }
    InsertSpan(ScanLeft,ScanRight,j); // fill in buffer
    AddPolyToSpan(ScanLeft,ScanRight,Polygon,j);
    }

   Pointer=Pointer->Pointer;
   }
  }
 }

void FloorPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float Px,Py,Pz,Mx,My,Mz,Nx,Ny,Nz;
 float Oa,Ha,Va,Ob,Hb,Vb,Oc,Hc,Vc;
 float a,b,c;
 Fixed u,v,du,dv;
 int j,n,i;

 Px=Perspective*Polygon->TxtP->wx;	// In my coords 0 is the origin of the square
 Py=InvPerspective*Polygon->TxtP->wy;     // Remember the Coords are being swapped here! (Z & Y)
 Pz=Polygon->TxtP->wz;

 Mx=(Perspective*Polygon->TxtM->wx-Px)*Polygon->TextureModX; // Create Vector M
 My=(InvPerspective*Polygon->TxtM->wy-Py)*Polygon->TextureModX;
 Mz=(Polygon->TxtM->wz-Pz)*Polygon->TextureModX;

 Nx=(Perspective*Polygon->TxtN->wx-Px)*Polygon->TextureModY; // Create Vector N
 Ny=(InvPerspective*Polygon->TxtN->wy-Py)*Polygon->TextureModY;
 Nz=(Polygon->TxtN->wz-Pz)*Polygon->TextureModY;

 Oa=Ny*Px-Nx*Py;	// Compute magic numbers
 Ha=Nz*Py-Ny*Pz;
 Va=Nx*Pz-Nz*Px;

 Ob=Mx*Py-My*Px;
 Hb=My*Pz-Mz*Py;
 Vb=Mz*Px-Mx*Pz;

 Oc=My*Nx-Mx*Ny;
 Hc=Mz*Ny-My*Nz;
 Vc=Mx*Nz-Mz*Nx;

 unsigned char *GFXPointer=Map->Graphic[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

 for(i=0;i<200;i++)	// Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWinG(Vertices[j].sx,Vertices[j].sy,Vertices[j].light,Vertices[n].sx,Vertices[n].sy,Vertices[n].light);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 Fixed ml,l;
 int Cu,Cv;
 int THeight=Polygon->Texture->Height;
 int TWidth=Polygon->Texture->Width;
 int XMask=Polygon->Texture->Width-1;
 int YMask=(Polygon->Texture->Height-1)*TWidth;
 int OffX=Polygon->TextOffX;
 int OffY=Polygon->TextOffY;
// int light=Polygon->Colour;

 unsigned char *TempScreen;

 for (j=YMin;j<=YMax;j++)	// set to YMin+1 for now as avoids an error!
  {
// The following tests are to determine if a drawing span is visible

  ListNode *Pointer=ScanLine[j].Root;

  int ScanLeft,ScanRight;

  ScanLeft=ScanBufferLeft[j];
  ScanRight=ScanBufferRight[j];

  if( (ScanRight-ScanLeft)!=0)
   ml=(Int2Fixed(LightBufferRight[j]-LightBufferLeft[j]))/(ScanRight-ScanLeft);
  else
   ml=Int2Fixed(LightBufferRight[j]-LightBufferLeft[j]);

  while (Pointer!=NULL)
   {
   l=Int2Fixed(LightBufferLeft[j]);
   ScanLeft=ScanBufferLeft[j];
   ScanRight=ScanBufferRight[j];

   if (ScanLeft<Pointer->Left) // is poly span left visible
    {
    l+=FixedMul(ml,Int2Fixed(Pointer->Left-ScanLeft));     // adjust light level (clipped!)
    ScanLeft=Pointer->Left;
    }
   if (ScanRight>Pointer->Right)
    ScanRight=Pointer->Right;

   // Only draws if the span is valid e.g. Left - Right

   if (ScanLeft<ScanRight)
    {
    a = Oa+(j-VCENTER)*Va;	// Intermediate values
    b = Ob+(j-VCENTER)*Vb;
    c = Oc+(j-VCENTER)*Vc;

    a+= (ScanLeft-HCENTER)*Ha;
    b+= (ScanLeft-HCENTER)*Hb;
    c+= (ScanLeft-HCENTER)*Hc;

    u = Float2Fixed(OffX+THeight*a/c);  // Texture coordinates
    v = Float2Fixed(OffY+TWidth*b/c)*TWidth;

    du=Float2Fixed(THeight*Ha/c);	// LOOOK NO INNER DIVIDES COS FLOOR IS CONST Z in X
    dv=Float2Fixed(TWidth*Hb/c)*TWidth;

    TempScreen=VirtualScreen+ScanLeft+j*320;

    // Set lighting levels for current span!

//    UpdateScreen();

    for (i=ScanLeft;i<ScanRight;i++)
     {
     Cu=(Fixed2Int(u))&XMask;	// Should allow wraparound textures
     Cv=(Fixed2Int(v))&YMask;

     *TempScreen++=LightTables[l>>16][GFXPointer[Cu+Cv]];

     u+=du;
     v+=dv;
     l+=ml;
     }
    InsertSpan(ScanLeft,ScanRight,j); // fill in buffer
    AddPolyToSpan(ScanLeft,ScanRight,Polygon,j);
    }

   Pointer=Pointer->Pointer;
   }
  }
 }

//NB The following function has been altered drastically, I am
//  attempting to use linear or possibly quadratic texture mapping.
//
//
//  linear    => u(x) = r+s*x	      - a straight line
//  quadratic => u(x) = r+s*x+t*x^2   - a curved line (better)(more awkward)
//
//   To use linear the following is done
//
//  Do this per row (j) - thus only unknown is i
//
// compute u(i=0) = OffX+THeight*(Oa+(j-VCENTER)*Va+(i-HCENTER)*Ha)/
//                               (Oc+(j-VCENTER)*Vc+(i-HCENTER)*Hc)
// compute u(i=end-start) = OffX+THeight*(Oa+(j-VCENTER)*Va+(i-HCENTER)*Ha)/
//                                       (Oc+(j-VCENTER)*Vc+(i-HCENTER)*Hc)
//
// u1=u(i=0)  u2=u(i=end-start)
// linear function is equal to  u(x)=r+s*x
// Therefor r=u1 s=(u2-u1)/(end-start)
//  this is then also done for v(x)!
//
//  To correct the visible curvature of textures.. and I mean VISIBLE!, I am
// going to split up a horizontal run of pixels into blocks of X pixels,
// the more pixels the lower the texture mapping accuracy!

void TextureQPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float Px,Py,Pz,Mx,My,Mz,Nx,Ny,Nz;
 float Oa,Ha,Va,Ob,Hb,Vb,Oc,Hc,Vc;
 float a,b,c;
 int j,n,i;

 Px=Perspective*Polygon->TxtP->wx;	// In my coords 0 is the origin of the square
 Py=InvPerspective*Polygon->TxtP->wy;     // Remember the Coords are being swapped here! (Z & Y)
 Pz=Polygon->TxtP->wz;

 Mx=(Perspective*Polygon->TxtM->wx-Px)*Polygon->TextureModX; // Create Vector M
 My=(InvPerspective*Polygon->TxtM->wy-Py)*Polygon->TextureModX;
 Mz=(Polygon->TxtM->wz-Pz)*Polygon->TextureModX;

 Nx=(Perspective*Polygon->TxtN->wx-Px)*Polygon->TextureModY; // Create Vector N
 Ny=(InvPerspective*Polygon->TxtN->wy-Py)*Polygon->TextureModY;
 Nz=(Polygon->TxtN->wz-Pz)*Polygon->TextureModY;

 Oa=Ny*Px-Nx*Py;	// Compute magic numbers
 Ha=Nz*Py-Ny*Pz;
 Va=Nx*Pz-Nz*Px;

 Ob=Mx*Py-My*Px;
 Hb=My*Pz-Mz*Py;
 Vb=Mz*Px-Mx*Pz;

 Oc=My*Nx-Mx*Ny;
 Hc=Mz*Ny-My*Nz;
 Vc=Mx*Nz-Mz*Nx;

 unsigned char *GFXPointer=Map->Graphic[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

 for(i=0;i<200;i++)	// Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWinG(Vertices[j].sx,Vertices[j].sy,Vertices[j].light,Vertices[n].sx,Vertices[n].sy,Vertices[n].light);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 Fixed ml,l;
 int Cu,Cv;
 int THeight=Polygon->Texture->Height;
 int TWidth=Polygon->Texture->Width;
 int XMask=Polygon->Texture->Width-1;
 int YMask=Polygon->Texture->Height-1;
 int OffX=Polygon->TextOffX;
 int OffY=Polygon->TextOffY;

 for (j=YMin;j<=YMax;j++)	// set to YMin+1 for now as avoids an error!
  {
// The following tests are to determine if a drawing span is visible

  ListNode *Pointer=ScanLine[j].Root;

  int ScanLeft,ScanRight;

  ScanLeft=ScanBufferLeft[j];
  ScanRight=ScanBufferRight[j];

  // Calculate lighting functions

  if( (ScanRight-ScanLeft)!=0)
   ml=((LightBufferRight[j]-LightBufferLeft[j])<<8)/(ScanRight-ScanLeft);
  else
   ml=(LightBufferRight[j]-LightBufferLeft[j])<<8;

  while (Pointer!=NULL)
   {
   l=(LightBufferLeft[j])<<8;
   ScanLeft=ScanBufferLeft[j];
   ScanRight=ScanBufferRight[j];

   if (ScanLeft<Pointer->Left) // is poly span left visible
    {
    l+=(ml*(Pointer->Left-ScanLeft));     // adjust light level (clipped!)
    ScanLeft=Pointer->Left;
    }
   if (ScanRight>Pointer->Right)
    ScanRight=Pointer->Right;

   // Only draws if the span is valid e.g. Left - Right

   if (ScanLeft<ScanRight)
    {
    Fixed u,v,su,sv;
    float u1,u2,u3,v1,v2,v3,u4,v4,u5,v5,ru,rv,len,ku,kv,tu,tv;
    float RU,RV,SU,SV,TU,TV;
    float Consta,Constb,Constc;
    int Constd;
    int Length;

    unsigned char *ScreenTemp=&VirtualScreen[ScanLeft+j*320]; // set up screen pos

    Length=ScanRight-ScanLeft;

    int Whole=Length>>ACCSHIFT;
    int Remain=Length&ACCMASK;

    Consta=Oa+(j-VCENTER)*Va;
    Constb=Ob+(j-VCENTER)*Vb;
    Constc=Oc+(j-VCENTER)*Vc;
    Constd=ScanLeft-HCENTER;

    a = Consta+(Constd)*Ha;        // Intermediate values
    b = Constb+(Constd)*Hb;
    c = Constc+(Constd)*Hc;

    u1=OffX+THeight*(a/c);	// compute u(0)
    v1=OffY+TWidth*(b/c);	// compute v(0)

    u=Float2Fixed(u1);
    v=Float2Fixed(v1);

    for (int t1=0;t1<Whole;t1++)
     {
     Constd+=ACCURACY;
     a = Consta+(Constd)*Ha;        // Intermediate values
     b = Constb+(Constd)*Hb;
     c = Constc+(Constd)*Hc;

     u2=OffX+THeight*(a/c);	// compute u(1)
     v2=OffY+TWidth*(b/c);	// compute v(1)

     su=(Float2Fixed(u2-u1))>>ACCSHIFT;
     sv=(Float2Fixed(v2-v1))>>ACCSHIFT;

     for (i=0;i<ACCURACY;i++)
      {
      Cu=(Fixed2Int(u))&XMask;        // Should allow wraparound textures
      Cv=(Fixed2Int(v))&YMask;
      *ScreenTemp++=LightTables[l>>8][GFXPointer[Cu+Cv*TWidth]];
//      UpdateScreen();
      u+=su;
      v+=sv;
      l+=ml;
      }
     u1=u2;
     v1=v2;
     }

    if (Remain!=0)
     {
     a = Consta+((ScanRight)-HCENTER)*Ha;    // Intermediate values
     b = Constb+((ScanRight)-HCENTER)*Hb;
     c = Constc+((ScanRight)-HCENTER)*Hc;

     u2=OffX+THeight*(a/c);	// compute u(1)
     v2=OffY+TWidth*(b/c);	// compute v(1)

     su=Float2Fixed((u2-u1)/Remain);
     sv=Float2Fixed((v2-v1)/Remain);
     }
    for (i=0;i<Remain;i++)
     {
     Cu=(Fixed2Int(u))&XMask; // Should allow wraparound textures
     Cv=(Fixed2Int(v))&YMask;
     *ScreenTemp++=LightTables[l>>8][GFXPointer[Cu+Cv*TWidth]];
//     UpdateScreen();
     u+=su;
     v+=sv;
     l+=ml;
     }
    InsertSpan(ScanLeft,ScanRight,j); // fill in buffer
    AddPolyToSpan(ScanLeft,ScanRight,Polygon,j);
    }
   Pointer=Pointer->Pointer;
   }
  }
 }

void TextureFacePlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 VertexTYPE *Last,*Next;
 Fixed u,v,du,dv;
 unsigned char *TempScreen;
 int j,n,i;

 YMin=WINBOTTOM;        // set up optimal buffers
 YMax=WINTOP;

 for(j=0;j<200;j++)     // Initialises Scanbuffer
  {
  ScanBufferLeft[j]=WINRIGHT;
  ScanBufferRight[j]=WINLEFT;
  }               

 if (Polygon->TypeOfPolygon==POLY_FRONT)
  {
  j=NumSides-1;  // set to last point (draw last to first and round!
  for (n=0;n<NumSides;n++)
   {
   ScanConvEdgeWin2d(Vertices[j].sx,Vertices[j].sy,Float2Fixed(Vertices[j].TextFX),Float2Fixed(Vertices[j].TextFY),Vertices[n].sx,Vertices[n].sy,Float2Fixed(Vertices[n].TextFX),Float2Fixed(Vertices[n].TextFY));
   j=n;
   }
  }
 else
  {
  j=NumSides-1;  // set to last point (draw last to first and round!
  for (n=0;n<NumSides;n++)
   {
   ScanConvEdgeWin2d(Vertices[j].sx,Vertices[j].sy,Float2Fixed(Vertices[j].TextRX),Float2Fixed(Vertices[j].TextRY),Vertices[n].sx,Vertices[n].sy,Float2Fixed(Vertices[n].TextRX),Float2Fixed(Vertices[n].TextRY));
   j=n;
   }
  }

 unsigned char *GFXPointer=Map->Graphic[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];
 int TWidth=Polygon->Texture->Width;

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 for (j=YMin;j<=YMax;j++)       // set to YMin+1 for now as avoids an error!
  {
// The following tests are to determine if a drawing span is visible

  ListNode *Pointer=ScanLine[j].Root;

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
 
  while (Pointer!=NULL)
   {
   u=ULeft[j];
   v=VLeft[j];
   ScanLeft=ScanBufferLeft[j];
   ScanRight=ScanBufferRight[j];

   if (ScanLeft<Pointer->Left) // is poly span left visible
    {
    u+=FixedMul(du,Int2Fixed(Pointer->Left-ScanLeft));     // adjust u (clipped!)
    v+=FixedMul(dv,Int2Fixed(Pointer->Left-ScanLeft));     // adjust v (clipped!)
    ScanLeft=Pointer->Left;
    }
   if (ScanRight>Pointer->Right)
    ScanRight=Pointer->Right;

   if (ScanLeft<ScanRight)
    {
    TempScreen=VirtualScreen+ScanLeft+j*320;

    for (i=ScanLeft;i<ScanRight;i++)
     {
     *TempScreen++=GFXPointer[(u>>16)+(v>>16)*TWidth];
  
     u+=du;
     v+=dv;
     }
    InsertSpan(ScanLeft,ScanRight,j); // fill in buffer
    AddPolyToSpan(ScanLeft,ScanRight,Polygon,j);
    }
   Pointer=Pointer->Pointer;
   }
  }
 }

void GouraudPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 int i,j,n,Y,a;
 Fixed ml,l;
 unsigned char *TempScreen;

 YMin=WINBOTTOM;      // set up optimal buffers
 YMax=WINTOP;

 for(i=0;i<200;i++)       // Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 j=NumSides-1;        // set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWinG(Vertices[j].sx,Vertices[j].sy,Vertices[j].light,Vertices[n].sx,Vertices[n].sy,Vertices[n].light);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 if (YMin!=YMax)
  for (Y=YMin;Y<=YMax;Y++)
   {
   ListNode *Pointer=ScanLine[Y].Root;
   int ScanLeft,ScanRight;

   ScanLeft=ScanBufferLeft[Y];
   ScanRight=ScanBufferRight[Y];

   if( (ScanRight-ScanLeft)!=0)
    ml=(Int2Fixed(LightBufferRight[Y]-LightBufferLeft[Y]))/(ScanRight-ScanLeft);
   else
    ml=Int2Fixed(LightBufferRight[Y]-LightBufferLeft[Y]);

   while (Pointer!=NULL)
    {
    l=Int2Fixed(LightBufferLeft[Y]);
    ScanLeft=ScanBufferLeft[Y];
    ScanRight=ScanBufferRight[Y];

    if (ScanLeft<Pointer->Left) // is poly span left visible
     {
     l+=FixedMul(ml,Int2Fixed(Pointer->Left-ScanLeft));     // adjust light level (clipped!)
     ScanLeft=Pointer->Left;
     }
    if (ScanRight>Pointer->Right)
     ScanRight=Pointer->Right;
    if (ScanLeft<ScanRight)
     {
     TempScreen=VirtualScreen+ScanLeft+Y*320;

     for (a=ScanLeft;a<ScanRight;a++)
      {
      *TempScreen++=Polygon->Colour+l>>16;
      l+=ml;
      }
     InsertSpan(ScanLeft,ScanRight,Y); // fill in buffer
     AddPolyToSpan(ScanLeft,ScanRight,Polygon,Y);
     }
    Pointer=Pointer->Pointer;
    }
   }
 }

void PolygonPlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 int i,j,n,Y,a;
 unsigned char *TempScreen;

 YMin=WINBOTTOM;      // set up optimal buffers
 YMax=WINTOP;

 j=NumSides-1;        // set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWin(Vertices[j].sx,Vertices[j].sy,Vertices[n].sx,Vertices[n].sy);
  j=n;
  }

 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 if (YMin!=YMax)
  for (Y=YMin;Y<=YMax;Y++)
   {
   ListNode *Pointer=ScanLine[Y].Root;
   int ScanLeft,ScanRight;

   while (Pointer!=NULL)
    {
    ScanLeft=ScanBufferLeft[Y];
    ScanRight=ScanBufferRight[Y];

    if (ScanLeft<Pointer->Left) // is poly span left visible
     ScanLeft=Pointer->Left;
    if (ScanRight>Pointer->Right)
     ScanRight=Pointer->Right;
    if (ScanLeft<ScanRight)
     {
     TempScreen=VirtualScreen+ScanLeft+Y*320;

     for (a=ScanLeft;a<ScanRight;a++)
      {
      *TempScreen++=Polygon->Colour;
      }
     InsertSpan(ScanLeft,ScanRight,Y); // fill in buffer
     AddPolyToSpan(ScanLeft,ScanRight,Polygon,Y);
     }
    Pointer=Pointer->Pointer;
    }
   }
 }

void ElfTexturePlot(VertexTYPE *Vertices,int NumSides,PolygonTYPE *Polygon)
 {
 float a,b,c;
 float u,v;
 int j,n,i;

 float Ax,Ay,Bx,By,Cx,Cy,Dx,Dy;
 int IAx,IAy,IBx,IBy,ICx,ICy,IDx,IDy;
 unsigned char *ScreenT=VirtualScreen;
 unsigned char *ScreenB=VirtualScreen;
 int  t;
 int YMul;
 char TYPE,TYPE2;
 int A, B, C, D; // Y values of points (Orded)
 short StartX, EndX;
 float SX, SY, DX, DY;
 int DXStep;
 Fixed GXF,GYF,MGXF,MGYF;
 float MSX, MSY, MDX, MDY;
 int TextureX,TextureY;

 for(i=0;i<200;i++)       // Initialises Scanbuffer
  {
  ScanBufferLeft[i]=WINRIGHT;
  ScanBufferRight[i]=WINLEFT;
  }

 unsigned char *GFXPointer=Map->Graphic[Polygon->Texture->Graphic+Polygon->Texture->CurrentFrame];

 YMin=WINBOTTOM;	// set up optimal buffers
 YMax=WINTOP;

// ClearScanBuffer(); // Initiate scanbuffers

 j=NumSides-1;	// set to last point (draw last to first and round!
 for (n=0;n<NumSides;n++)
  {
  ScanConvEdgeWin(Vertices[j].sx,Vertices[j].sy,Vertices[n].sx,Vertices[n].sy);
  if (n==0)
   { Ax=Vertices[j].sx;Ay=Vertices[j].sy;Bx=Vertices[n].sx;By=Vertices[n].sy;}
  if (n==2)
   { Cx=Vertices[j].sx;Cy=Vertices[j].sy;Dx=Vertices[n].sx;Dy=Vertices[n].sy;}
  j=n;
  }

 IAx=Ax;IAy=Ay;
 IBx=Bx;IBy=By;
 ICx=Cx;ICy=Cy;
 IDx=Dx;IDy=Dy;
 
 if (YMin<WINTOP)
  YMin=WINTOP;
 if (YMax>WINBOTTOM)
  YMax=WINBOTTOM;

 int Cu,Cv;
 int THeight=Polygon->Texture->Height;
 int TWidth=Polygon->Texture->Width;
 int XMask=Polygon->Texture->Width-1;
 int YMask=Polygon->Texture->Height-1;
 int OffX=Polygon->TextOffX;
 int OffY=Polygon->TextOffY;

 TextureX=TWidth;
 TextureY=THeight;

 unsigned char *Buffer1=GFXPointer;
 A=IAy;B=IBy;C=ICy;D=IDy;
 if (A>B)
  { i=A;A=B;B=i;}
 if (B>C)
  { i=B;B=C;C=i;}
 if (C>D)
  { i=C;C=D;D=i;}
 if (A>B)
  { i=A;A=B;B=i;}
 if (B>C)
  { i=B;B=C;C=i;}
 if (A>B)
  { i=A;A=B;B=i;}
 TYPE2=0;
 if (IAy<=IBy && IAy<=ICy && IAy<=IDy)
  { SX=0;SY=0;TYPE=1;
  MSX=TextureX/(float)(IBy-IAy); // Source in source gradient
  MSY=0;
  MDX=0;                // Destnation in source gradient
  MDY=TextureY/(float)(IDy-IAy);
  if (IBy==D)
    TYPE2=1;
  if (IDy==D)
    TYPE2=2;
  }
 else
   if (ICy<=IAy && ICy<=IBy && ICy<=IDy)
    { SX=TextureX; SY=TextureY; TYPE=2;
    MSX=-(TextureX/(float)(IDy-ICy)); // Source in source gradient
    MSY=0;
    MDX=0;                // Destnation in source gradient
    MDY=-(TextureY/(float)(IBy-ICy));
  if (IDy==D)
    TYPE2=1;
  if (IBy==D)
    TYPE2=2;
    }
   else
     if (IBy<IAy && IBy<ICy && IBy<IDy)
      { SX=TextureX; SY=0; TYPE=3;
  MSX=0; // Source in source gradient
  MSY=(TextureY/(float)(ICy-IBy));
  MDX=-(TextureX/(float)(IAy-IBy));                // Destnation in source gradient
  MDY=0;
  if (ICy==D)
    TYPE2=1;
  if (IAy==D)
    TYPE2=2;
      }
      else
//      if (IDy<IAy && IDy<IBy && IDy<ICy)
        { SX=0; SY=TextureY;TYPE=4;
  MSX=0; // Source in source gradient
  MSY=-(TextureY/(float)(IAy-IDy));
  MDX=(TextureX/(float)(ICy-IDy));                // Destnation in source gradient
  MDY=0;
  if (IAy==D)
    TYPE2=1;
  if (ICy==D)
    TYPE2=2;
        }
 DX=SX;DY=SY;

 YMul=(int)A*320;
// SXF=Float2Fixed(SX);
// SYF=Float2Fixed(SY);
// DXF=Float2Fixed(DX);
// DYF=Float2Fixed(SY);

// MSXF=Float2Fixed(MSX);
// MSYF=Float2Fixed(MSY);
// MDXF=Float2Fixed(MDX);
// MDYF=Float2Fixed(MSY);

 for(i=A;i<B;i++)
   {
   StartX=ScanBufferLeft[i];
   EndX=ScanBufferRight[i];
   DXStep=EndX-StartX; // M1=length of line in destnation
   GXF=Float2Fixed(DX);
   GYF=Float2Fixed(DY);
   MGXF=Float2Fixed(((SX-DX)/DXStep));
   MGYF=Float2Fixed(((SY-DY)/DXStep));
   ScreenT=ScreenB+YMul+StartX;
   for(t=0;t<DXStep;t++)
     {
     *ScreenT++=Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )];//&16383];
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=320;
   SX+=MSX; // Next X line in source
   SY+=MSY; // Next Y line in source
   DX+=MDX;
   DY+=MDY;
   }

  if (TYPE==1)
   {
   if (B==IBy)  // Check right edge
    { SX=TextureX;SY=0;MSX=0;MSY=(TextureY/(Cy-By)); }
   if (B==IDy)  // Check left edge
    { DX=0;DY=TextureY;MDX=(TextureX/(Cy-Dy));MDY=0; }
   }

  if (TYPE==2)
   {
   if (B==IDy)
    { SX=0;SY=TextureY;MSX=0;MSY=-(TextureY/(Ay-Dy)); }
   if (B==IBy)
    { DX=TextureX;DY=0;MDX=-(TextureX/(Ay-By));MDY=0; }
   }

  if (TYPE==3)
   {
   if (B==ICy)
    { SX=TextureX;SY=TextureY;MSX=-(TextureY/(Dy-Cy));MSY=0; }
   if (B==IAy)
    { DX=0;DY=0;MDX=0;MDY=TextureY/(Dy-Ay); }
   }

  if (TYPE==4)
   {
   if (B==IAy)
    { SX=0;SY=0;MSX=TextureX/(By-Ay);MSY=0;}
   if (B==ICy)
    { DX=TextureX;DY=TextureY;MDX=0;MDY=-(TextureX/(By-Cy)); }
   }
 for(i=B;i<C;i++)
   {
   StartX=ScanBufferLeft[i];
   EndX=ScanBufferRight[i];
   DXStep=EndX-StartX; // M1=length of line in destnation
   GXF=Float2Fixed(DX);
   GYF=Float2Fixed(DY);
   MGXF=Float2Fixed(((SX-DX)/DXStep));
   MGYF=Float2Fixed(((SY-DY)/DXStep));
   ScreenT=ScreenB+YMul+StartX;
   for(t=0;t<DXStep;t++)
     {
     *ScreenT++=Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )];//&16383];
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=320;
   SX+=MSX; // Next X line in source
   SY+=MSY; // Next Y line in source
   DX+=MDX;
   DY+=MDY;
   }
// If type2==0 regular polygon
// IF type2==1 DX= all change in gradients
// If type2==2 SX= all change in gradients

 if (TYPE2==1)
  {
  if (TYPE==1)
   {
    DX=TextureX;DY=TextureY;MDX=0;MDY=-TextureY/(By-Cy);
   }
 
  if (TYPE==2)
   {
     DX=0;DY=0;MDX=0;MDY=(TextureY/(Dy-Ay));
   }
 
  if (TYPE==3)
   {
     DX=0;DY=TextureY;MDX=(TextureY/(Cy-Dy));MDY=0;
   }
 
  if (TYPE==4)
   {
    DX=TextureX;DY=0;MDX=-TextureX/(Ay-By);MDY=0;
   }
  }


 if (TYPE2==2)
  {
  if (TYPE==1)
   {
     SX=TextureX;SY=TextureY;MSX=-TextureX/(Dy-Cy);MSY=0;
   }
 
  if (TYPE==2)
   {
     SX=0;SY=0;MSX=(TextureX/(By-Ay));MSY=0;
   }
 
  if (TYPE==3)
   {
     SX=0;SY=TextureY;MSX=0;MSY=-TextureY/(Ay-Dy);
   }
 
  if (TYPE==4)
   {
     SX=TextureX;SY=0;MSX=0;MSY=(TextureX/(Cy-By));
   }
  }


 if (TYPE2==0)
  {
  if (TYPE==1)
   {
   if (C==IBy)  // Check right edge
    { SX=TextureX;SY=0;MSX=0;MSY=TextureY/(Cy-By);}
   if (C==IDy)  // Check left edge
    { DX=0;DY=TextureY;MDX=TextureX/(Cy-Dy);MDY=0;}
   }
 
  if (TYPE==2)
   {
   if (C==IDy)
    { SX=0;SY=TextureY;MSX=0;MSY=-(TextureY/(Ay-Dy));}
   if (C==IBy)
    { DX=TextureX;DY=0;MDX=-(TextureX/(Ay-By));MDY=0;}
   }
 
  if (TYPE==3)
   {
   if (C==ICy)
    { SX=TextureX;SY=TextureY;MSX=-(TextureY/(Dy-Cy));MSY=0;}
   if (C==IAy)
    { DX=0;DY=0;MDX=0;MDY=TextureY/(Dy-Ay);}
   }
 
  if (TYPE==4)
   {
   if (C==IAy)
    { SX=0;SY=0;MSX=TextureX/(By-Ay);MSY=0;}
   if (C==ICy)
    { DX=TextureX;DY=TextureY;MDX=0;MDY=-(TextureX/(By-Cy));}
   }
  }

 for(i=C;i<D;i++)
   {
   StartX=ScanBufferLeft[i];
   EndX=ScanBufferRight[i];
   DXStep=EndX-StartX; // M1=length of line in destnation
   GXF=Float2Fixed(DX);
   GYF=Float2Fixed(DY);
   MGXF=Float2Fixed(((SX-DX)/DXStep));
   MGYF=Float2Fixed(((SY-DY)/DXStep));
   ScreenT=ScreenB+YMul+StartX;
   for(t=0;t<DXStep;t++)
     {
     *ScreenT++=Buffer1[(int) ( Fixed2Int(GXF)+Fixed2Int(GYF)*TextureX )];//&16383];
     GXF+=MGXF;
     GYF+=MGYF;
     }
   YMul+=320;
   SX+=MSX; // Next X line in source
   SY+=MSY; // Next Y line in source
   DX+=MDX;
   DY+=MDY;
   }
 }

