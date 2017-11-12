
// Module object
//
// Includes -
//  cSCREEN  
//   
// 
// Coded by Dark Elf
//
#include <fstream.h>
#include <string.h>

#include "graph.h"
#include "general.h"

extern fstream dale;
#define TITLE "Elf 3DO object mapper"


///////////////////////////////////////////////////////////////////////////
// Sliders

cSLIDER::cSLIDER()
{
	UpdateMeB=0;
	UpdateMeW=0;
	UpdateMeL=0;
}
cSLIDER::~cSLIDER()
{
	
}

void cSLIDER::Check(long MouseX,long MouseY)
{
	if (MouseX>=PositionX && MouseY>=PositionY && MouseX<PositionX+SizeX &&
		MouseY<PositionY+SizeY)
	{
		if (Alignment==1) // horiz
		{
			CurrentValue=(MouseX-PositionX)/ScaleFactor;
			if (UpdateMeB!=0)
				*UpdateMeB=(unsigned char)CurrentValue;
			if (UpdateMeW!=0)
				*UpdateMeW=(unsigned short)CurrentValue;
			if (UpdateMeL!=0)
				*UpdateMeL=(long)CurrentValue;
		}
		if (Alignment==2) // vert
		{
			CurrentValue=(MouseY-PositionY)/ScaleFactor;
			if (UpdateMeB!=0)
				*UpdateMeB=(unsigned char)CurrentValue;
			if (UpdateMeW!=0)
				*UpdateMeW=(unsigned short)CurrentValue;
			if (UpdateMeL!=0)
				*UpdateMeL=(long)CurrentValue;
		}
	}
}
void cSLIDER::Update(cSCREEN *CurrentWindow)
{
	if (CurrentValue!=LastValue)
	{
		LastValue=CurrentValue;
		int i;
		long type;
		char stringbuffer[4];
		type =Type;
		if (type&8)
		{
			CurrentWindow->CLSBox(PositionX-28,PositionY,PositionX+SizeX,PositionY+SizeY+1);
			type=type&(0xfffffff7);
			CurrentWindow->Cout(PositionX-28,PositionY,itoa(CurrentValue,stringbuffer,10));
		}
		else
			CurrentWindow->CLSBox(PositionX,PositionY,PositionX+SizeX,PositionY+SizeY+1);
		switch (type)
		{
		case 1:
			for(i=0;i<256;i++)
			{
				CurrentWindow->Box(PositionX+i,PositionY+1,PositionX+i+1,PositionY+SizeY-1,0,0,i);
			}
			break;
		case 2:
			for(i=0;i<256;i++)
			{
				CurrentWindow->Box(PositionX+i,PositionY+1,PositionX+i+1,PositionY+SizeY-1,0,i,0);
			}
			break;
		case 3:
			for(i=0;i<256;i++)
			{
				CurrentWindow->Box(PositionX+i,PositionY+1,PositionX+i+1,PositionY+SizeY-1,i,0,0);
			}
			break;
		case 4:
			for(i=0;i<256;i++)
			{
				CurrentWindow->Box(PositionX+i,PositionY+1,PositionX+i+1,PositionY+SizeY-1,i,i,i);
			}
			break;
		}
		PlotPosition(CurrentWindow);
	}
}

void cSLIDER::PlotPosition(cSCREEN *CurrentWindow)
{
	if (Alignment==1)
	{
		CurrentWindow->Dot(PositionX+(CurrentValue*ScaleFactor),PositionY,255,255,255);
		CurrentWindow->Dot(PositionX+(CurrentValue*ScaleFactor),PositionY+SizeY,255,255,255);
	}
	
}


//////////////////////////////////////////////////////////////////////////////
// Init

cSCREEN::cSCREEN()
{
	BackBuffer=0;
	Type=0;
//	SizeX=0;
//	SizeY=0;
//	PositionX=0;
//	PositionY=0;
//	SubScreenList=NULL;
//	NumSubScreens=0;
	// Sliders=new cSLIDER[10];
}
cSCREEN::~cSCREEN()
{
	if (FakeID!=0)
	{
		fstream temp;
		temp.open("screen.raw",ios::out|ios::binary);
		temp.write(&BackBuffer[0],SizeX*SizeY*PixelLength);
	}
	
	if (BackBuffer!=0)
		delete BackBuffer;
	if (ZBuffer!=0)
		delete ZBuffer;
	if (AlphaBuffer!=0)
		delete AlphaBuffer;
}

void cSCREEN::CloseScreen( )
{
    if( lpDD != NULL )
    {
		if( lpDDSPrimary != NULL )
		{
			lpDDSPrimary->Release();
			lpDDSPrimary = NULL;
		}
		lpDD->Release();
		lpDD = NULL;
    }
} /* finiObjects */

char szMsg[] = " ";
char szFrontMsg[] = " ";
char szBackMsg[] = " ";

long FAR PASCAL WindowProc( HWND hWnd, UINT message, 
						   WPARAM wParam, LPARAM lParam )
{
    PAINTSTRUCT ps;
    RECT        rc;
    SIZE        size;
    static BYTE phase = 0;
	
    switch( message )
    {
    case WM_ACTIVATEAPP:
		//	bActive = wParam;
		break;
		
    case WM_CREATE:
		break;
		
    case WM_SETCURSOR:
		SetCursor(NULL);
		
		return TRUE;
		
    case WM_TIMER:
		// Flip surfaces
		break;
		
    case WM_KEYDOWN:
		switch( wParam )
		{
		case VK_ESCAPE:
		case VK_F12:
			{
				//		CloseScreen();
				PostMessage(hWnd, WM_CLOSE, 0, 0);
			}
			break;
		}
		break;
		
		case WM_PAINT:
			BeginPaint( hWnd, &ps );
			GetClientRect(hWnd, &rc);
			GetTextExtentPoint( ps.hdc, szMsg, lstrlen(szMsg), &size );
			SetBkColor( ps.hdc, RGB( 0, 0, 255 ) );
			SetTextColor( ps.hdc, RGB( 255, 255, 0 ) );
			TextOut( ps.hdc, (rc.right - size.cx)/2, (rc.bottom - size.cy)/2,
				szMsg, sizeof( szMsg )-1 );
			EndPaint( hWnd, &ps );
			
			break;
			
		case WM_DESTROY:
			PostQuitMessage( 0 );
			break;
	}
    return DefWindowProc(hWnd, message, wParam, lParam);
} /* WindowProc */


long cSCREEN::Open( HINSTANCE hInstance, int nCmdShow,long FakeON )
{
    WNDCLASS            wc;
    DDSCAPS             ddscaps;
    HRESULT             ddrval;
	
	dale <<"Opening Screen"<<endl;
	PixelLength=3;
    /*
	* set up and register window class
	*/
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WindowProc;
    wc.cbClsExtra = 0;
    wc.cbWndExtra = 0;
    wc.hInstance = hInstance;
    wc.hIcon = LoadIcon( hInstance, IDI_APPLICATION );
    wc.hCursor = LoadCursor( NULL, IDC_ARROW );
    wc.hbrBackground = NULL;
    wc.lpszMenuName = "DDExample1";
    wc.lpszClassName = "DDExample1";
    RegisterClass( &wc );
    
    /*
	* create a window
	*/
    hwnd = CreateWindowEx(
		WS_EX_TOPMOST,
		"DDExample1",
		TITLE,
		WS_POPUP,
		0, 0,
		10,
		10,
		NULL,
		NULL,
		hInstance,
		NULL );
	
    if( !hwnd )
		return FALSE;
	
    ShowWindow( hwnd, nCmdShow );
    UpdateWindow( hwnd );
	
	if (FakeON==0)
	{
		FakeID=0;
		/*
		* create the main DirectDraw object
		*/
		ddrval = DirectDrawCreate( NULL, &lpDD, NULL );
		if( ddrval == DD_OK )
		{
			// Get exclusive mode
			ddrval = lpDD->SetCooperativeLevel( hwnd,
				DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN );
			if(ddrval == DD_OK )
			{
				Type=0;
				ddrval = lpDD->SetDisplayMode( 640, 480, 24 );
				PixelLength=3;
				if (ddrval!=DD_OK)
				{
					ddrval = lpDD->SetDisplayMode( 640, 480, 32 );
					PixelLength=4;
					if (ddrval!=DD_OK)
					{
						dale << "ERROR: Cannot Open 640x480 24/32 bit screen mode "<<endl;
						exit(-1);
					}
				}
				dale <<"Screen Opened"<<endl;
				if( ddrval == DD_OK )
				{
					// Create the primary surface with 1 back buffer
					ddsd.dwSize = sizeof( ddsd );
					ddsd.dwFlags = DDSD_CAPS | DDSD_BACKBUFFERCOUNT;
					ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE |
						DDSCAPS_FLIP | 
						DDSCAPS_COMPLEX;
					ddsd.dwBackBufferCount = 1;
					ddrval = lpDD->CreateSurface( &ddsd, (IDirectDrawSurface **)&lpDDSPrimary, NULL );
					if( ddrval == DD_OK )
					{
						// Get a pointer to the back buffer
						ddscaps.dwCaps = DDSCAPS_BACKBUFFER;
						ddrval = lpDDSPrimary->GetAttachedSurface(&ddscaps, 
							&lpDDSBack);
						//					if( ddrval == DD_OK )
						//						return TRUE;
					}
				}
			}
		}
	}
	else
		FakeID=1;
	SizeX=640;
	SizeY=480;
	ZBuffer=new MFLOAT[SizeX*SizeY];
	BackBuffer=new unsigned char[SizeX*SizeY*PixelLength]; 
	AlphaBuffer=new unsigned char [SizeX*SizeY*PixelLength];
	//BackBuffer=new unsigned char[SizeX*SizeY*PixelLength];
	return (1==1);
	//    return FALSE;
}
long cSCREEN::Lock()
{
	if (FakeID==0)
	{
		res=lpDDSBack->Lock(NULL,&ddsd,DDLOCK_SURFACEMEMORYPTR|DDLOCK_WAIT,NULL);
		//		res=lpDDSPrimary->Lock(NULL,&ddsd,DDLOCK_SURFACEMEMORYPTR|DDLOCK_WAIT,NULL);
		if (res==DD_OK)
		{
			Locked=1;
			FrontBuffer=(unsigned char *)ddsd.lpSurface;
			
			return TRUE;
		}
		return FALSE;
	}
	else
	{
		FrontBuffer=BackBuffer;
		return TRUE;
	}
}
long cSCREEN::Unlock()
{
	if (FakeID==0)
	{
		res=lpDDSBack->Unlock(NULL);
		//		res=lpDDSPrimary->Unlock(NULL);
		Locked=0;
		return TRUE;
	}
	else 
		return TRUE;
}

long cSCREEN::Open(long sizex,long sizey,long bbp,long r,long g,long b,long rv)
{
	SizeX=sizex;
	SizeY=sizey;
	//PixelLength=bbp/8;
	//BackBuffer=new unsigned char[SizeX*SizeY*PixelLength];
	return (1==1);
}


void cSCREEN::CopyBackToFront()
{
	Rect.left=0;
	Rect.top=0;
	Rect.right=640;
	Rect.bottom=480;
	if (Locked==1)
	{
		Unlock();
		hr=lpDDSPrimary->BltFast(0,0,lpDDSBack,&Rect,DDBLTFAST_NOCOLORKEY|DDBLTFAST_WAIT);
	}
	else 
		hr=lpDDSPrimary->BltFast(0,0,lpDDSBack,&Rect,DDBLTFAST_NOCOLORKEY|DDBLTFAST_WAIT);
}
//////////////////////////////////////////////////////////////////////////////
// Windows Operations

long cSCREEN::Cout(long PositionX,long PositionY,char *Text)
{
	long status=0;
	if (Locked==1)
	{
		Unlock();
		status=1;
	}
	if (FakeID==0)
	{
		if (lpDDSBack->GetDC(&hdc) == DD_OK)
		{
			SetTextColor( hdc, RGB( TextR, TextG, TextB ) );
			SetBkColor( hdc, RGB( BackTextR, BackTextG, BackTextB ) );
			TextOut( hdc, PositionX, PositionY, Text, lstrlen(Text) );
			lpDDSBack->ReleaseDC(hdc);
			if (status==1)
			{
				return Lock();
			}
			else
				return TRUE;
		}
		else
			if (status==1)
			{
				Lock();
				return FALSE;
			}
			else
				return FALSE;
	}
}


long cSCREEN::Cout(long PositionX,long PositionY,char *Text,long Length)
{
	long status=0;
	if (Locked==1)
	{
		Unlock();
		status=1;
	}
	
	if (FakeID==0)
	{
		if (lpDDSBack->GetDC(&hdc) == DD_OK)
		{
			SetTextColor( hdc, RGB( TextR, TextG, TextB ) );
			SetBkColor( hdc, RGB( BackTextR, BackTextG, BackTextB ) );
			TextOut( hdc, PositionX, PositionY, Text, Length );
			lpDDSBack->ReleaseDC(hdc);
			if (status==1)
			{
				return Lock();
			}
			else
				return TRUE;
		}
		else
			if (status==1)
			{
				Lock();
				return FALSE;
			}
			else
				return FALSE;
	}
}


long cSCREEN::Cout(long PositionX,long PositionY,char *Text,unsigned char r,
				   unsigned char g,unsigned char b)
{
	long status=0;
	if (Locked==1)
	{
		Unlock();
		status=1;
	}
	
	if (lpDDSBack->GetDC(&hdc) == DD_OK)
	{
		SetTextColor( hdc, RGB( r, g, b ) );
		SetBkColor( hdc, RGB( BackTextR, BackTextG, BackTextB ) );
		TextOut( hdc, PositionX, PositionY, Text, lstrlen(Text) );
		lpDDSBack->ReleaseDC(hdc);
		if (status==1)
		{
			return Lock();
		}
		else
			return TRUE;
	}
	else
		if (status==1)
		{
			Lock();
			return FALSE;
		}
		else
			return FALSE;
}



////////////////////////////////////////////////////////////////////////////////

void cSCREEN::CLSBoxLong(long x1,long y1,long x2,long y2)
{
	unsigned char *temp=FrontBuffer+(y1*SizeX+x1)*PixelLength;
	int moduloX=(SizeX-(x2-x1))*PixelLength;
	int width=((x2-x1)*PixelLength)/4;
	int x,y;
	for (y=y1;y<y2;y++)
	{
		for(x=0;x<width;x++)
		{
			*(unsigned long *)temp=0;
			temp+=4;
		}
		temp+=moduloX;
	}
}


void cSCREEN::CLSBox(int x1,int y1,int x2,int y2)
{
	if (((x2-x1)*PixelLength%4)==0)
	{
		CLSBoxLong(x1,y1,x2,y2);
		return;
	}
	unsigned char *temp=FrontBuffer+(y1*SizeX+x1)*PixelLength;
	int moduloX=(SizeX-(x2-x1))*PixelLength;
	int x,y;
	for (y=y1;y<y2;y++)
	{
		for(x=x1;x<x2;x++)
		{
			*temp++=0;
			*temp++=0;
			*temp++=0;
			temp+=PixelLength-3;
		}
		temp+=moduloX;
	}
}
void cSCREEN::Dot(long x,long y,unsigned char r,unsigned char g,unsigned char b)
{
	FrontBuffer[(y*SizeX+x)*PixelLength+2]=r;
	FrontBuffer[(y*SizeX+x)*PixelLength+1]=g;
	FrontBuffer[(y*SizeX+x)*PixelLength]=b;
}

void cSCREEN::LargeDot(long x,long y)
{
	if (x>0&&y>0)
	{
		FrontBuffer[(y*SizeX+x-SizeX-1)*PixelLength+2]=0;
		FrontBuffer[(y*SizeX+x-SizeX-1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x-SizeX-1)*PixelLength]=0;
	}
	if (x<SizeX&&y>0)
	{
		FrontBuffer[(y*SizeX+x-SizeX+1)*PixelLength+2]=0;
		FrontBuffer[(y*SizeX+x-SizeX+1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x-SizeX+1)*PixelLength]=0;
	}
	if (x>0&&y<SizeY)
	{
		FrontBuffer[(y*SizeX+x+SizeX-1)*PixelLength+2]=0;
		FrontBuffer[(y*SizeX+x+SizeX-1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x+SizeX-1)*PixelLength]=0;
	}
	if (x<SizeX&&y<SizeY)
	{
		FrontBuffer[(y*SizeX+x+SizeX+1)*PixelLength+2]=0;
		FrontBuffer[(y*SizeX+x+SizeX+1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x+SizeX+1)*PixelLength]=0;
	}
	if (y>0)
	{
		FrontBuffer[(y*SizeX+x-SizeX)*PixelLength+2]=255;
		FrontBuffer[(y*SizeX+x-SizeX)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x-SizeX)*PixelLength]=0;
	}
	if (x>0)
	{
		FrontBuffer[(y*SizeX+x-1)*PixelLength+2]=255;
		FrontBuffer[(y*SizeX+x-1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x-1)*PixelLength]=0;
	}
	if (y<SizeY)
	{
		FrontBuffer[(y*SizeX+x+SizeX)*PixelLength+2]=255;
		FrontBuffer[(y*SizeX+x+SizeX)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x+SizeX)*PixelLength]=0;
	}
	if (x<SizeX)
	{
		FrontBuffer[(y*SizeX+x+1)*PixelLength+2]=255;
		FrontBuffer[(y*SizeX+x+1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x+1)*PixelLength]=0;
	}
}

void cSCREEN::LargeDot(long x,long y,unsigned char r,unsigned char g,unsigned char b)
{
	if (x>0&&y>0)
	{
		FrontBuffer[(y*SizeX+x-SizeX-1)*PixelLength+2]=0;
		FrontBuffer[(y*SizeX+x-SizeX-1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x-SizeX-1)*PixelLength]=0;
	}
	if (x<SizeX&&y>0)
	{
		FrontBuffer[(y*SizeX+x-SizeX+1)*PixelLength+2]=0;
		FrontBuffer[(y*SizeX+x-SizeX+1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x-SizeX+1)*PixelLength]=0;
	}
	if (x>0&&y<SizeY)
	{
		FrontBuffer[(y*SizeX+x+SizeX-1)*PixelLength+2]=0;
		FrontBuffer[(y*SizeX+x+SizeX-1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x+SizeX-1)*PixelLength]=0;
	}
	if (x<SizeX&&y<SizeY)
	{
		FrontBuffer[(y*SizeX+x+SizeX+1)*PixelLength+2]=0;
		FrontBuffer[(y*SizeX+x+SizeX+1)*PixelLength+1]=0;
		FrontBuffer[(y*SizeX+x+SizeX+1)*PixelLength]=0;
	}
	if (y>0)
	{
		FrontBuffer[(y*SizeX+x-SizeX)*PixelLength+2]=r;
		FrontBuffer[(y*SizeX+x-SizeX)*PixelLength+1]=g;
		FrontBuffer[(y*SizeX+x-SizeX)*PixelLength]=b;
	}
	if (x>0)
	{
		FrontBuffer[(y*SizeX+x-1)*PixelLength+2]=r;
		FrontBuffer[(y*SizeX+x-1)*PixelLength+1]=g;
		FrontBuffer[(y*SizeX+x-1)*PixelLength]=b;
	}
	if (y<SizeY)
	{
		FrontBuffer[(y*SizeX+x+SizeX)*PixelLength+2]=r;
		FrontBuffer[(y*SizeX+x+SizeX)*PixelLength+1]=g;
		FrontBuffer[(y*SizeX+x+SizeX)*PixelLength]=b;
	}
	if (x<SizeX)
	{
		FrontBuffer[(y*SizeX+x+1)*PixelLength+2]=r;
		FrontBuffer[(y*SizeX+x+1)*PixelLength+1]=g;
		FrontBuffer[(y*SizeX+x+1)*PixelLength]=b;
	}
}

void cSCREEN::DrawLine(long x1,long y1,long x2,long y2)
{
	MFLOAT x,y;
	MFLOAT XStep,YStep;
	long xi,yi;
	long xd,yd;
	long NextPixel;
	unsigned char *ScreenPtrTemp=FrontBuffer;
	
	xd=abs(x1-x2);
	yd=abs(y1-y2);
	if (xd>=yd)
	{
		NextPixel=PixelLength;
		if (x2>x1)
		{
			y=(MFLOAT)y1;
			ScreenPtrTemp+=x1*PixelLength;
			YStep=(MFLOAT)(y2-y1)/xd;
		}
		else
		{
			y=(MFLOAT)y2;
			ScreenPtrTemp+=x2*PixelLength;
			YStep=((MFLOAT)y1-y2)/xd;
		}
		
		for(xi=0;xi<xd;xi++)
		{
			yi=(int)y;
			ScreenPtrTemp[(yi*SizeX)*PixelLength+2]=0;
			ScreenPtrTemp[(yi*SizeX)*PixelLength+1]=0;
			ScreenPtrTemp[(yi*SizeX)*PixelLength]=0;
			ScreenPtrTemp+=NextPixel;
			y+=YStep;
		}
		
	}
	else
	{
		NextPixel=(SizeX)*PixelLength;
		if (y2>y1)
		{
			ScreenPtrTemp+=(y1*SizeX)*PixelLength;
			x=(MFLOAT)x1;
			XStep=(MFLOAT)(x2-x1)/yd;
		}
		else
		{
			ScreenPtrTemp+=(y2*SizeX)*PixelLength;
			x=(MFLOAT)x2;
			XStep=(MFLOAT)(x1-x2)/yd;
		}
		for(yi=0;yi<yd;yi++)
		{
			xi=(int)x;
			ScreenPtrTemp[(xi)*PixelLength+2]=0;
			ScreenPtrTemp[(xi)*PixelLength+1]=0;
			ScreenPtrTemp[(xi)*PixelLength]=0;
			ScreenPtrTemp+=NextPixel;
			x+=XStep;
		}
	}
}

////////////////////////////////////////////////////////////////////////
// Bitmap operations

void cSCREEN::BlitAreaLong(unsigned char *SourcePtr,int OffsetX,
						   int OffsetY,int SourceX,int SourceY)
{
	int moduloD;
	int width;
	moduloD=(SizeX-SourceX)*PixelLength;
	unsigned char *Dest=FrontBuffer+(OffsetX+OffsetY*SizeX)*PixelLength;
	unsigned long *source=(unsigned long *)SourcePtr;
	width=(SourceX*PixelLength)/4;
	int x,y;
	
	for(y=0;y<SourceY;y++)
	{
		for(x=0;x<width;x++)
		{
			*(unsigned long *)Dest=*source++;
			Dest+=4;
		}
		Dest+=moduloD;
	}
}

void cSCREEN::BlitArea(unsigned char *SourcePtr,int OffsetX,
					   int OffsetY,int SourceX,int SourceY)
{
	if ((SourceX*PixelLength%4)==0 )
	{
		BlitAreaLong(SourcePtr,OffsetX,OffsetY,SourceX,SourceY);
		return;
	}
	
	int moduloD;
	moduloD=(SizeX-SourceX)*PixelLength;
	unsigned char *Dest=FrontBuffer+(OffsetX+OffsetY*SizeX)*PixelLength;
	
	int x,y;
	
	for(y=0;y<SourceY;y++)
	{
		for(x=0;x<SourceX;x++)
		{
			*Dest++=*SourcePtr++;
			*Dest++=*SourcePtr++;
			*Dest++=*SourcePtr++;
			Dest+=PixelLength-3;
		}
		Dest+=moduloD;
	}
}

void cSCREEN::BlitAreaMono(unsigned char *SourcePtr,int OffsetX,
						   int OffsetY,int SourceX,int SourceY)
{
	int moduloD;
	moduloD=(SizeX-SourceX)*PixelLength;
	unsigned char *Dest=FrontBuffer+(OffsetX+OffsetY*SizeX)*PixelLength;
	
	int x,y;
	unsigned char c;
	for(y=0;y<SourceY;y++)
	{
		for(x=0;x<SourceX;x++)
		{
			c=*SourcePtr++;
			*Dest++=c;
			*Dest++=c;
			*Dest++=c;
			Dest+=PixelLength-3;
		}
		Dest+=moduloD;
	}
}

void cSCREEN::BlitAreaM(unsigned char *SourcePtr,int OffsetX,
						int OffsetY,int SourceX,int SourceY,unsigned char Mask)
{
	int moduloD;
	moduloD=(SizeX-SourceX)*PixelLength;
	unsigned char *Dest=FrontBuffer+(OffsetX+OffsetY*SizeX)*PixelLength;
	
	int x,y;
	
	for(y=0;y<SourceY;y++)
	{
		for(x=0;x<SourceX;x++)
		{
			if (*SourcePtr!=Mask)
			{
				*Dest++=*SourcePtr++;
				*Dest++=*SourcePtr++;
				*Dest++=*SourcePtr++;
				Dest+=PixelLength-3;
			}
			else
			{
				Dest+=PixelLength;
				SourcePtr+=3;
			}
		}
		Dest+=moduloD;
	}
}


void cSCREEN::CLSAreaL(int start,int Size)
{
	//unsigned char *Destnation=VESAScreenPtr+start;
	//for(i=0;i<Size;i++)
	//PlotPixel(Destnation++,0);
}

void cSCREEN::CopyBack(long PositionX,long PositionY,cTEXTURE *Destnation)
{
	int moduloS;
	int x,y;
	
	moduloS=(SizeX-Destnation->SizeX)*PixelLength;
	unsigned char *SourcePtr=FrontBuffer+(PositionX+PositionY*SizeX)*PixelLength;
	unsigned char *DestPtr=Destnation->TexturePtr;
	
	for(y=0;y<Destnation->SizeY;y++)
	{
		for(x=0;x<Destnation->SizeX;x++)
		{
			*DestPtr++=*SourcePtr++;
			*DestPtr++=*SourcePtr++;
			*DestPtr++=*SourcePtr++;
			SourcePtr+=PixelLength-3;
		}
		SourcePtr+=moduloS;
	}
}

void cSCREEN::CopyBack0M(long PositionX,long PositionY,cTEXTURE *Destnation)
{
	int moduloS;
	int x,y;
	
	moduloS=(SizeX-Destnation->SizeX)*PixelLength;
	unsigned char *SourcePtr=FrontBuffer+(PositionX+PositionY*SizeX)*PixelLength;
	unsigned char *DestPtr=Destnation->TexturePtr;
	
	for(y=0;y<Destnation->SizeY;y++)
	{
		for(x=0;x<Destnation->SizeX;x++)
		{
			if (*SourcePtr!=0 && *(SourcePtr+1)!=0 && *(SourcePtr+2)!=0)
			{
				*DestPtr++=*SourcePtr++;
				*DestPtr++=*SourcePtr++;
				*DestPtr++=*SourcePtr++;
				SourcePtr+=PixelLength-3;
			}
			else 
				SourcePtr+=PixelLength;
		}
		SourcePtr+=moduloS;
	}
}
void cSCREEN::BlitArea0M(unsigned char *SourcePtr,int OffsetX,
						 int OffsetY,int SourceX,int SourceY)
{
	int moduloD;
	moduloD=(SizeX-SourceX)*PixelLength;
	unsigned char *DestPtr=FrontBuffer+(OffsetX+OffsetY*SizeX)*PixelLength;
	
	int x,y;
	
	for(y=0;y<SourceY;y++)
	{
		for(x=0;x<SourceX;x++)
		{
			if ((*SourcePtr)!=0 ||(*(SourcePtr+1))!=0 || (*(SourcePtr+2))!=0)
			{
				*DestPtr++=*SourcePtr++;
				*DestPtr++=*SourcePtr++;
				*DestPtr++=*SourcePtr++;
				DestPtr+=PixelLength-3;
			}
			else
			{
				DestPtr+=PixelLength;
				SourcePtr+=3;
			}
		}
		DestPtr+=moduloD;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Mouse Cursor

void cSCREEN::MousePlot(long x,long y,unsigned char r,unsigned char g,unsigned char b)
{
	long temp=(y*SizeX+x);
	if (y>0)
	{
		MouseBuffer[0]=FrontBuffer[(temp-SizeX)*PixelLength+2];
		MouseBuffer[1]=FrontBuffer[(temp-SizeX)*PixelLength+1];
		MouseBuffer[2]=FrontBuffer[(temp-SizeX)*PixelLength];
		
		FrontBuffer[(temp-SizeX)*PixelLength]=~MouseBuffer[0];
		FrontBuffer[(temp-SizeX)*PixelLength+1]=~MouseBuffer[1];
		FrontBuffer[(temp-SizeX)*PixelLength+2]=~MouseBuffer[2];
	}
	if (x>0)
	{
		MouseBuffer[3]=FrontBuffer[(temp-1)*PixelLength+2];
		MouseBuffer[4]=FrontBuffer[(temp-1)*PixelLength+1];
		MouseBuffer[5]=FrontBuffer[(temp-1)*PixelLength];
		
		FrontBuffer[(temp-1)*PixelLength+2]=~MouseBuffer[3];
		FrontBuffer[(temp-1)*PixelLength+1]=~MouseBuffer[4];
		FrontBuffer[(temp-1)*PixelLength]=~MouseBuffer[5];
	}
	if (y<SizeY)
	{
		MouseBuffer[6]=FrontBuffer[(temp+SizeX)*PixelLength+2];
		MouseBuffer[7]=FrontBuffer[(temp+SizeX)*PixelLength+1];
		MouseBuffer[8]=FrontBuffer[(temp+SizeX)*PixelLength];
		
		FrontBuffer[(temp+SizeX)*PixelLength+2]=~MouseBuffer[6];
		FrontBuffer[(temp+SizeX)*PixelLength+1]=~MouseBuffer[7];
		FrontBuffer[(temp+SizeX)*PixelLength]=~MouseBuffer[8];
	}
	if (x<SizeX)
	{
		MouseBuffer[9]=FrontBuffer[(temp+1)*PixelLength+2];
		MouseBuffer[10]=FrontBuffer[(temp+1)*PixelLength+1];
		MouseBuffer[11]=FrontBuffer[(temp+1)*PixelLength];
		
		FrontBuffer[(temp+1)*PixelLength+2]=~MouseBuffer[9];
		FrontBuffer[(temp+1)*PixelLength+1]=~MouseBuffer[10];
		FrontBuffer[(temp+1)*PixelLength]=~MouseBuffer[11];
	}
}

void cSCREEN::MouseRemove(long x,long y)
{
	long temp=(y*SizeX+x);
	if (y>0)
	{
		FrontBuffer[(temp-SizeX)*PixelLength+2]=MouseBuffer[0];
		FrontBuffer[(temp-SizeX)*PixelLength+1]=MouseBuffer[1];
		FrontBuffer[(temp-SizeX)*PixelLength]=MouseBuffer[2];
	}
	if (x>0)
	{
		FrontBuffer[(temp-1)*PixelLength+2]=MouseBuffer[3];
		FrontBuffer[(temp-1)*PixelLength+1]=MouseBuffer[4];
		FrontBuffer[(temp-1)*PixelLength]=MouseBuffer[5];
	}
	if (y<SizeY)
	{
		FrontBuffer[(temp+SizeX)*PixelLength+2]=MouseBuffer[6];
		FrontBuffer[(temp+SizeX)*PixelLength+1]=MouseBuffer[7];
		FrontBuffer[(temp+SizeX)*PixelLength]=MouseBuffer[8];
	}
	if (x<SizeX)
	{
		FrontBuffer[(temp+1)*PixelLength+2]=MouseBuffer[9];
		FrontBuffer[(temp+1)*PixelLength+1]=MouseBuffer[10];
		FrontBuffer[(temp+1)*PixelLength]=MouseBuffer[11];
	}
}


/////////////////////////////////////////////////////////////////////////////
// ZBuffer

void cSCREEN::ClearZBuffer()
{
	int i;
	MFLOAT *ZBufferPtrTemp=&ZBuffer[0];
	for (i=0;i<SizeX*SizeY;i++)
		*ZBufferPtrTemp++=0;
}
void cSCREEN::ClearZBufferFast()
{
	int i;
	unsigned long *ZBufferClear=(unsigned long*) &ZBuffer[0];
	for(i=0;i<SizeX*SizeY;i++)
		*ZBufferClear++=0;	// Floating point 0.0=0x00000000
}
void cSCREEN::ClearZBufferArea(long x1,long y1,long x2,long y2)
{
	long moduloD;
	moduloD=(SizeX-(x2-x1));
	MFLOAT *Dest=ZBuffer+x1+y1*SizeX;
	
	long x,y;
	
	for(y=0;y<y2-y1;y++)
	{
		for(x=0;x<x2-x1;x++)
		{
			*Dest++=0;
		}
		Dest+=moduloD;
	}
}

///////////////////////////////////////////////////////////////////////////
// Filled Boxes

void cSCREEN::Box(long x1,long y1,long x2,long y2,unsigned char r,
				  unsigned char g,unsigned char b)
{
	long moduloD;
	moduloD=(SizeX-(x2-x1))*PixelLength;
	unsigned char *Dest=FrontBuffer+(x1+y1*SizeX)*PixelLength;
	
	long x,y;
	
	for(y=0;y<y2-y1;y++)
	{
		for(x=0;x<x2-x1;x++)
		{
			*Dest++=r;
			*Dest++=g;
			*Dest++=b;
			Dest+=PixelLength-3;
		}
		Dest+=moduloD;
	}
}

///////////////////////////////////////////////////////////////////////////
// Console 
cCONSOLE::cCONSOLE()
{
}

cCONSOLE::~cCONSOLE()
{
}


long cCONSOLE::Open(long positionX,long positionY,long sizeX,long sizeY)
{
	PositionX=positionX;
	PositionY=positionY;
	SizeX=sizeX;
	SizeY=sizeY;
	FrontBuffer=new unsigned char[SizeX*SizeY];	// Stored as chars
	FontSizeX=8;
	FontSizeY=8;
	return TRUE;
}

long cCONSOLE::Update(cSCREEN *DestnationScreen)
{
	int t;
	DestnationScreen->CLSBox(PositionX,PositionY,PositionX+SizeX*FontSizeX,
		PositionY+SizeY*FontSizeY);

	for (t=0;t<SizeY;t++)
	{
		DestnationScreen->Cout(PositionX,PositionY+t*FontSizeY,
			(char*)FrontBuffer+t*SizeX,SizeX);
	}
		
	return TRUE;
}

void cCONSOLE::Cout(char *StringOut)
{
}

