
// Main Module
//
//   

// Coded by Dark Elf
//
// Keyboard controls -
// pageup/pagedown - next/prev point on polygon
// cursor/shift cursor - rotate object x,y
// home/end - rotate z +/-
// t - toggle texture mode
// esc - exit

// use mouse to select polygons and move points on texture map
// sliders are adjustable but mono is non-adjustable


#define KEYDOWN(name,key) (name[key] & 0x80) 

#include <windows.h>
#include <windowsx.h>
#include <fstream.h>

#define MFLOAT float

#include "graph.h"
#include "types.h"
#include "object.h"             // Object,Polygon,Vector structures defined here
#include "input.h"
extern long LoadTextures(char *FileName);

long PolyBufferArray[320*400];

// debug file
fstream dale;

// Main
MFLOAT AngleX=(MFLOAT)0.5,AngleY=(MFLOAT)0.7,AngleZ=(MFLOAT)0;
MFLOAT AngleXb=(MFLOAT)0.5,AngleYb=(MFLOAT)0.7,AngleZb=(MFLOAT)0;
long MouseButton;
long CurrentPoly,CurrentPoint;
long altered=1;
long PageUp;
long PageDown;
long MouseState;

long BitmapAltered;
long MouseAltered;
long aobjTextureStatus;
long SlidersAltered;
long PolygonAltered;

long *PolyBuffer=&PolyBufferArray[0];
cOBJECT aobj;
cSCREEN MainWindow;
cINPUT MInput; 
cTEXTURE Mouse,MouseBack;
cTEXTURE *GlobalTextures;
long NumTextures;
unsigned char pal[256*3];
char ObjectName[13]="test.dyn";
long Alpha=1;

long AlphaPressed=0;
long TexturePressed=0;
#
//////////////////////////////////////////////////////////////////////////

void Loop()
{
	long i,x,y;
	
	////////////////////////////////////////////////////////////////
	// Check If Any Keys Have Been Pressed
	if (!MInput.CheckKey(DIK_RSHIFT) &&!MInput.CheckKey(DIK_LSHIFT))
	{
		if (MInput.CheckKey(DIK_LEFT) )
			AngleX+=(MFLOAT)0.05;
		if (MInput.CheckKey(DIK_RIGHT))
			AngleX-=(MFLOAT)0.05;
		if (MInput.CheckKey(DIK_UP))
			AngleY+=(MFLOAT)0.05;
		if (MInput.CheckKey(DIK_DOWN))
			AngleY-=(MFLOAT)0.05;
		if (MInput.CheckKey(DIK_HOME))
			AngleZ+=(MFLOAT)0.05;
		if (MInput.CheckKey(DIK_END))
			AngleZ-=(MFLOAT)0.05;
	}
	if (MInput.CheckKey(DIK_RSHIFT) || MInput.CheckKey(DIK_LSHIFT))
	{
		if (MInput.CheckKey(DIK_LEFT))
			AngleX+=0.50;
		if (MInput.CheckKey(DIK_RIGHT))
			AngleX-=0.50;
		if (MInput.CheckKey(DIK_UP))
			AngleY+=0.50;
		if (MInput.CheckKey(DIK_DOWN))
			AngleY-=0.50;
		if (MInput.CheckKey(DIK_HOME))
			AngleZ+=0.50;
		if (MInput.CheckKey(DIK_END))
			AngleZ-=0.50;
   	}
	
	if (MInput.CheckKey(DIK_INSERT))
	{
		altered=1;
		BitmapAltered=1;
		if (aobj.Polygons[CurrentPoly].TextureID<NumTextures)
			aobj.Polygons[CurrentPoly].TextureID++;
//		aobj.ScaleFactor*=(MFLOAT)1.2;
	}
	if (MInput.CheckKey(DIK_DELETE))
	{
		altered=1;
		BitmapAltered=1;
//		aobj.ScaleFactor/=(MFLOAT)1.2;
		if (aobj.Polygons[CurrentPoly].TextureID>0)
			aobj.Polygons[CurrentPoly].TextureID--;
	}
	
	if (MInput.CheckKey(DIK_PRIOR) && 
		CurrentPoint<aobj.Polygons[CurrentPoly].NumVectors-1)
	{
		if(PageUp==0)
		{
			altered=1;
			BitmapAltered=1;
			SlidersAltered=1;
			CurrentPoint++;
		}
		PageUp=1;
	}
	else
		PageUp=0;
	
	if ( MInput.CheckKey(DIK_NEXT) && CurrentPoint>0)
	{
		if(PageDown==0)
		{
			altered=1;
			BitmapAltered=1;
			SlidersAltered=1;
			CurrentPoint--;
		}
		PageDown=1;
	}
	else
		PageDown=0;
	
	if (MInput.CheckKey(DIK_T))
	{
		if (TexturePressed==0) 
		{
			TexturePressed=1;
			altered=1;
			if ( aobjTextureStatus==0)
				aobjTextureStatus=1;
			else
				aobjTextureStatus=0;
		}
	}
	else
		TexturePressed=0;

	if (MInput.CheckKey(DIK_A))
	{
		if (AlphaPressed==0)
		{
			AlphaPressed=1;
			altered=1;
			if ( Alpha==0)
				Alpha=1;
			else
				Alpha=0;
		}
	}
	else 
		AlphaPressed=0;
	
//	dale <<"Keys checked "<<endl;
	
	MouseButton=MInput.MouseButton;
	
	/////////////////////////////////////////////////////////
	// Check Display window
	
	// Check Object Area, 0,0,320*400
	if (AngleX!=AngleXb ||AngleY!=AngleYb ||AngleZ!=AngleZb)
	{
		AngleXb=AngleX;
		AngleYb=AngleY;
		AngleZb=AngleZ;
		aobj.RotateXYZ(AngleX,AngleY,AngleZ,INIT);
		aobj.TranslateVectors(160,200);
		altered=1;

	}
//	dale <<"Object translated"<<endl;
	if (altered==1 )
	{
		MouseAltered=1;
		MainWindow.BlitArea(MouseBack.TexturePtr,MInput.MouseX,MInput.MouseY,MouseBack.SizeX,MouseBack.SizeY);
//		dale <<"Mouse back copied"<<endl;

		altered=0;
		
		MainWindow.CLSBox(0,0,320,400);
//		dale <<"Cls'ed"<<endl;

		for(i=0;i<320*400;i++)
		{
			PolyBuffer[i]=0;
		}
//		dale <<"Ploybuffer cleared"<<endl;

		MainWindow.ClearZBufferArea(0,0,320,400);
//		dale <<"Zbuffer cleared"<<endl;

		if (aobjTextureStatus==0)
		{
			Alpha=0;
//			dale <<"Object shaded24"<<endl;
			aobj.PlotObjectShaded24();
		}
		else
		{
			if (Alpha==1)
			{
//				dale <<"Object textured + alpha"<<endl;

				aobj.PlotObjectTexture();
				MainWindow.ClearZBufferArea(0,0,320,400);
				aobj.PlotObjectShaded24();
				unsigned char *Dest,*Front,*Alpha;
				long ModuloD=(MainWindow.SizeX-320)*MainWindow.PixelLength;
				Dest=&MainWindow.FrontBuffer[0];
				Front=&MainWindow.FrontBuffer[0];
				Alpha=&MainWindow.AlphaBuffer[0];

				for (y=0;y<400;y++)
				{
					for (x=0;x<320*MainWindow.PixelLength;x++)
						*Dest++=( *Front++**Alpha++)>>8;
					Dest+=ModuloD;
					Front+=ModuloD;
					Alpha+=ModuloD;
				}
			}
			else
			{
//				dale <<"Object textured"<<endl;
				aobj.PlotObjectTexture();
			}
		}
		
		MainWindow.LargeDot((long)aobj.TVectors[aobj.Polygons[CurrentPoly].VectorIndex[CurrentPoint]].x,
			(long)aobj.TVectors[aobj.Polygons[CurrentPoly].VectorIndex[CurrentPoint]].y,255,0,0);
		
		MainWindow.CopyBack(MInput.MouseX,MInput.MouseY,&MouseBack);
	}
	
	// Check Bitmap window 350,0,256*256
//	dale <<"Object plotted"<<endl;
	if (BitmapAltered==1)
	{
		MouseAltered=1;
		MainWindow.BlitArea(MouseBack.TexturePtr,MInput.MouseX,MInput.MouseY,MouseBack.SizeX,MouseBack.SizeY);
		
		BitmapAltered=0;
		MainWindow.CLSBox(350,
			GlobalTextures[aobj.Polygons[CurrentPoly].TextureID].SizeY,350+256,256);
		MainWindow.BlitArea(GlobalTextures[aobj.Polygons[CurrentPoly].TextureID].TexturePtr,350,0,
			GlobalTextures[aobj.Polygons[CurrentPoly].TextureID].SizeX,
			GlobalTextures[aobj.Polygons[CurrentPoly].TextureID].SizeY);
		long numt;
		numt=aobj.Polygons[CurrentPoly].NumVectors;
		
		for(y=0;y<numt-1;y++)
		{
			MainWindow.DrawLine(350+aobj.Polygons[CurrentPoly].TexturePoints[y].TX,
				aobj.Polygons[CurrentPoly].TexturePoints[y].TY,
				350+aobj.Polygons[CurrentPoly].TexturePoints[y+1].TX,
				aobj.Polygons[CurrentPoly].TexturePoints[y+1].TY);
		}
		
		MainWindow.LargeDot(aobj.Polygons[CurrentPoly].TexturePoints[CurrentPoint].TX+350,
			aobj.Polygons[CurrentPoly].TexturePoints[CurrentPoint].TY);
		
		MainWindow.CopyBack(MInput.MouseX,MInput.MouseY,&MouseBack);
	}
	
	// Check Sliders
//	dale <<"Bitmap plotted"<<endl;
	if (SlidersAltered==1)
	{
		MouseAltered=1;
		MainWindow.BlitArea(MouseBack.TexturePtr,MInput.MouseX,MInput.MouseY,MouseBack.SizeX,MouseBack.SizeY);

		MainWindow.Sliders[0].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].B;
		MainWindow.Sliders[1].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].G;
		MainWindow.Sliders[2].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].R;
		MainWindow.Sliders[3].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].M;
		
		MainWindow.Sliders[0].UpdateMeB=&aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].B;
		MainWindow.Sliders[1].UpdateMeB=&aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].G;
		MainWindow.Sliders[2].UpdateMeB=&aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].R;
		
		MainWindow.Sliders[3].UpdateMeB=&aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].M;

		SlidersAltered=0;
		MainWindow.Sliders[0].Update(&MainWindow);
		MainWindow.Sliders[1].Update(&MainWindow);
		MainWindow.Sliders[2].Update(&MainWindow);
		MainWindow.Sliders[3].Update(&MainWindow);
		MainWindow.CopyBack(MInput.MouseX,MInput.MouseY,&MouseBack);
	}
//	dale <<"Sliders plotted"<<endl;
	
	// Check mouse updates
	if (MouseButton==1)
	{
		
		SlidersAltered=1;
		MainWindow.Sliders[0].Check(MInput.MouseX,MInput.MouseY);
		MainWindow.Sliders[1].Check(MInput.MouseX,MInput.MouseY);
		MainWindow.Sliders[2].Check(MInput.MouseX,MInput.MouseY);
		aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].M=(aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].R
			+aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].G
			+aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].B)/3;
		MainWindow.Sliders[3].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].M;
		
		if (MInput.MouseX>0 && MInput.MouseX<256 &&
			MInput.MouseY>0 && MInput.MouseY<400)
		{
			CurrentPoly=PolyBuffer[MInput.MouseX+MInput.MouseY*320];
			CurrentPoint=0;
			BitmapAltered=1;
			
		}
		
		if (MInput.MouseX>350 && MInput.MouseX<350+	GlobalTextures[aobj.Polygons[CurrentPoly].TextureID].SizeX &&
			MInput.MouseY>0 && MInput.MouseY<0+GlobalTextures[aobj.Polygons[CurrentPoly].TextureID].SizeY)
		{
			BitmapAltered=1;
			aobj.Polygons[CurrentPoly].TexturePoints[CurrentPoint].TX=MInput.MouseX-350;
			aobj.Polygons[CurrentPoly].TexturePoints[CurrentPoint].TY=MInput.MouseY;
			if (MouseState==0)
				altered=1;
		}
		MouseState=1;
	}
	else
	{
		if (MouseState==1)	// Only update window on release of mouse button
		{
			MouseState=0;
			altered=1;
		}
	}
//	dale <<"Mouse plotted"<<endl;
	
	//MainWindow.Cout(10,400,"Coded by Dark Elf");
	
	MInput.ProcessMouse();
	
	// Check Mouse Update
	if (MInput.OldMouseX!=MInput.MouseX ||MInput.OldMouseY!=MInput.MouseY
		||MouseAltered==1 )
	{
		MouseAltered=0;
		MainWindow.BlitArea(MouseBack.TexturePtr,MInput.OldMouseX,MInput.OldMouseY,MouseBack.SizeX,MouseBack.SizeY);
		MainWindow.CopyBack(MInput.MouseX,MInput.MouseY,&MouseBack);
		MainWindow.BlitArea0M(Mouse.TexturePtr,MInput.MouseX,MInput.MouseY,Mouse.SizeX,Mouse.SizeY);
	}
}

////////////////////////////////////////////////////////////////////////////////////
/*#include <time.h>

 clock_t Start,End;
 float Frame=0;
 const long MathSize=65536;
 float MathArray[MathSize];
void TestFPU()
{
	int i,t;
	for (i=0;i<MathSize;i++)
		MathArray[i]=(float)i;
t=400;
 Start=clock();
 float a;
while (t>0)
{
	for (i=0;i<MathSize;i++)
		a/=12;
	for (i=0;i<MathSize;i++)
		a+=i;
	for (i=0;i<MathSize;i++)
		a*=i;
	for (i=0;i<MathSize;i++)
		a-=i;
	t--;
	Frame++;
}
 
 End=clock();


 dale << "Frame number :"<<Frame<<"   start,end :"<<Start<<" : "<<End<<endl;
 dale << "Frames Per Second = " << ((double)Frame*CLOCKS_PER_SEC)/(End-Start)<<endl;

}

*/
int PASCAL WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance,
				   LPSTR lpCmdLine, int nCmdShow)
{
    long	res;
	
	dale.open("g:\\out.txt",ios::out);
//	if (*lpCmdLine>0) 
//	{
		dale<<"test:"<<lpCmdLine<<endl;
//	}
	while(0==0)
	{
		dale<<"                                                                     ";
	}

	//return 0;

	lpCmdLine = lpCmdLine;
    hPrevInstance = hPrevInstance;
	
	LoadTextures("textures.txt");

	Mouse.LoadTGA("mouse.TGA");
	MouseBack.Allocate(Mouse.SizeX,Mouse.SizeY,1);
	
	altered=1;
	BitmapAltered=1;
	PageUp=0;
	PageDown=0;
	MouseState=0;
	aobjTextureStatus=0;
	SlidersAltered=0;
	PolygonAltered=1;
	
	aobj.Read3DO(ObjectName);
	CurrentPoly=0;CurrentPoint=0;
	
	MainWindow.Open( hInstance, nCmdShow,0);



	dale<<"Screen opened."<<endl;
    MainWindow.ClearZBuffer();
	
	
	MainWindow.Sliders[0].PositionX=350;
	MainWindow.Sliders[0].PositionY=270;
	MainWindow.Sliders[0].SizeX=256;
	MainWindow.Sliders[0].SizeY=18;
	MainWindow.Sliders[0].Type=1|8;
	MainWindow.Sliders[0].CurrentValue=10;
	MainWindow.Sliders[0].LastValue=11;
	MainWindow.Sliders[0].ScaleFactor=1;
	MainWindow.Sliders[0].Alignment=1;
	
	MainWindow.Sliders[1].PositionX=350;
	MainWindow.Sliders[1].PositionY=290;
	MainWindow.Sliders[1].SizeX=256;
	MainWindow.Sliders[1].SizeY=18;
	MainWindow.Sliders[1].Type=2|8;
	MainWindow.Sliders[1].CurrentValue=10;
	MainWindow.Sliders[1].LastValue=11;
	MainWindow.Sliders[1].ScaleFactor=1;
	MainWindow.Sliders[1].Alignment=1;
	
	MainWindow.Sliders[2].PositionX=350;
	MainWindow.Sliders[2].PositionY=310;
	MainWindow.Sliders[2].SizeX=256;
	MainWindow.Sliders[2].SizeY=18;
	MainWindow.Sliders[2].Type=3|8;
	MainWindow.Sliders[2].CurrentValue=10;
	MainWindow.Sliders[2].LastValue=11;
	MainWindow.Sliders[2].ScaleFactor=1;
	MainWindow.Sliders[2].Alignment=1;
	
	MainWindow.Sliders[3].PositionX=350;
	MainWindow.Sliders[3].PositionY=330;
	MainWindow.Sliders[3].SizeX=256;
	MainWindow.Sliders[3].SizeY=18;
	MainWindow.Sliders[3].Type=4|8;
	MainWindow.Sliders[3].CurrentValue=10;
	MainWindow.Sliders[3].LastValue=11;
	MainWindow.Sliders[3].ScaleFactor=1;
	MainWindow.Sliders[3].Alignment=1;
	
	MainWindow.TextR=255;
	MainWindow.TextG=255;
	MainWindow.TextB=255;
	
	MainWindow.BackTextR=0;
	MainWindow.BackTextG=0;
	MainWindow.BackTextB=0;
	
	MainWindow.Sliders[0].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].R;
	MainWindow.Sliders[1].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].G;
	MainWindow.Sliders[2].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].B;
	MainWindow.Sliders[3].CurrentValue=aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].M;
	
	MainWindow.Sliders[0].UpdateMeB=&aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].R;
	MainWindow.Sliders[1].UpdateMeB=&aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].G;
	MainWindow.Sliders[2].UpdateMeB=&aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].B;
	
	MainWindow.Sliders[3].UpdateMeB=&aobj.Polygons[CurrentPoly].LightPoints[CurrentPoint].M;
	
	dale <<"Init sliders"<<endl;
	res=MainWindow.Lock();
	if (res==TRUE)
	{
		MainWindow.CLSBox(0,0,640,480);
		MainWindow.Unlock();
	}
	dale <<"screen cleared"<<endl;
	
	MInput.InitDevices(hInstance,MainWindow.hwnd);
    MInput.SetMouseMax(640,480);
	MInput.ProcessKeyboard();	
	dale <<"Init devices success"<<endl;
	res=MainWindow.Lock();
	if (res==TRUE)
	{
		MainWindow.Sliders[0].Update(&MainWindow);
		MainWindow.Sliders[1].Update(&MainWindow);
		MainWindow.Sliders[2].Update(&MainWindow);
		MainWindow.Sliders[3].Update(&MainWindow);
		MainWindow.CopyBack(MInput.MouseX,MInput.MouseY,&MouseBack);
		MainWindow.Unlock();
	}
	dale <<"Plotted mouse"<<endl;

	MainWindow.Consoles=new cCONSOLE[1];
	MainWindow.NumConsoles=1;
	MainWindow.Consoles[0].Open(0,400,40,2);
	dale <<"opened console"<<endl;
//////////////////////////////
		AngleXb=AngleX;
		AngleYb=AngleY;
		AngleZb=AngleZ;
		aobj.RotateXYZ(AngleX,AngleY,AngleZ,INIT);
		aobj.TranslateVectors(160,200);
		altered=1;
//////////////////////////////
	while (!MInput.CheckKey(DIK_ESCAPE))
    {
//		dale <<"In loop"<<endl;
		res=MainWindow.Lock();
		if (res==TRUE)
		{
//			dale <<"Do loop"<<endl;
			Loop();
//			dale <<"Done loop"<<endl;

			MainWindow.Unlock();
			MainWindow.Consoles[0].Update(&MainWindow);
			MainWindow.CopyBackToFront();
//			dale <<"Copy back"<<endl;

		}
//		dale <<"Process keyboard"<<endl;

		MInput.ProcessKeyboard();
		MInput.KeyboardInterupt();		
//		dale <<"Processed keyboard"<<endl;
		//	hr = lpDDSPrimary->Flip( NULL, DDFLIP_WAIT );
	}	

//	TestFPU();

	dale <<"Close down"<<endl;
	MInput.CloseKeyboard();
	MInput.CloseMouse();
	MainWindow.CloseScreen();
	aobj.Write3DO(ObjectName);
	return 0;
	
} /* WinMain */
