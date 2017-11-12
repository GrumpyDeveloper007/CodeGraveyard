/*---------------------------------------------------------------------------*/
/*- As this is likely to be the last prt of the code tutorial series, i -----*/
/*- thought i'd give you an insight into an effect, which few people in the -*/
/*- demo scene know how to do - how to create a really cool 3D coral effect -*/
/*---------------------------------------------------------------------------*/
/*- Hope you've enjoyed the series ! (Pete Jones, aka Sandman / Valhalla) ---*/
/*---------------------------------------------------------------------------*/

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <conio.h>
#include <graph.h>
#include <stdlib.h>

#define SPEEDCOMP 0.6
#define CORAL_POINTS2D  8000
#define CORAL_POINTS3D  8000
#define GROWTH 8

/*---------------------------------------------------------------------------*/

char palette[256][3], zoompic[256][256], scrbuf[200][320];
long  i,j, x,y;
float fx,fy;
float zoomfactor=1.25;

typedef struct 
{
	long x,y,z;
} point3d;				// create our own 3d point structure.

point3d coral[CORAL_POINTS3D];
point3d rotated[CORAL_POINTS3D];

long xpos=0,ypos=0,zpos=0;		// 3d position of particle
long lastxpos,lastypos,lastzpos;
long randval;

char ScreenBuffer[200][320];
char xbuffer[128], ybuffer[128];
char texture[256][256];
long growthoffset=0;
unsigned char RadTable[200][320];
unsigned char AngTable[200][320];

float	angle1=0, angle2=0, angle3=0;
float	angle1bak=0, angle2bak=0, angle3bak=0;
float	angle4=0, angle5=0;
float	angle4bak=0, angle5bak=0;

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

void DrawRealPlasma(void)
{
	long i,j;
	char	value;

	angle1bak=angle1;
	angle2bak=angle2;
	angle3bak=angle3;
	for (i=0; i<128; i++)
	{
		xbuffer[i]=8.0*sin(angle1) + 6.0*sin(angle2) + 4.0*sin(angle3);
		angle1+=6.284/128;
		angle2+=2*6.284/128;
		angle3+=4*6.284/128;
	}							
	angle1=angle1bak-((2*1*6.284/320)*SPEEDCOMP*4);
	angle2=angle2bak+((2*3*6.284/320)*SPEEDCOMP*4);
	angle3=angle3bak+((2*2*6.284/320)*SPEEDCOMP*4);

	angle4bak=angle4;
	angle5bak=angle5;
	for (i=0; i<128; i++)
	{	   
		ybuffer[i]=8.0*sin(angle4) + 6.0*sin(angle5);
		angle4+=6.284/128;
		angle5+=2*6.284/128;
	}							
	angle4=angle1bak+((2*3*6.284/320)*SPEEDCOMP*4);
	angle5=angle2bak+((2*5*6.284/320)*SPEEDCOMP*4);
		
	for (j=0; j<128; j++)
	{
		value=ybuffer[j];
		for (i=0; i<128; i++)
		{
			texture[j][i] = (32+value+xbuffer[i]);
			texture[j+128][i] = (32+value+xbuffer[i]);
			texture[j][i+128] = (32+value+xbuffer[i]);
			texture[j+128][i+128] = (32+value+xbuffer[i]);
		}			
	}		
}

/*---------------------------------------------------------------------------*/

void CalcRadiusTable_Perspect(void)
{
	long i,j,rad;

	for (j=-100; j<100; j++)
	{
		for (i=-160; i<160; i++)
		{
			rad=sqrt((i*i) + (j*j));
         rad=8*32*pow((float) (256*1024*rad), 0.1);
			RadTable[j+100][i+160]=rad & 255;
		}		
	}		
}	

void CalcAngleTable(void)
{
	float x,y, angle;
	long i,j;

	for (j=-100; j<100; j++)
	{
		for (i=-160; i<160; i++)
		{
			x=i;
			y=j;
			angle=atan2(y,x);
			angle*=(256/6.284);
			AngTable[j+100][i+160]=((long) angle) & 255;			
		}		
	}		
}	

void DoTunnel(unsigned char radoff, unsigned char angoff)
{
   long i,j;
   unsigned char radius,angle;

   angoff&=255;
   radoff&=255;

   for (j=0; j<200; j++)
	{
		for (i=0; i<320; i++)
		{
         radius=(radoff+RadTable[j][i]) & 255;
         angle=radius+(angoff+AngTable[j][i]) & 255;
         ScreenBuffer[j][i]=texture[radius][angle];
		}		
	}
}	

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

void LoadTarga(char *filename)
{       
	FILE *in;

	if ( (in=fopen(filename, "rb")) == NULL )
	{
		printf("Ooops cannot open %s :(\n", filename);
		exit(1);                
	}

	fseek(in, 18, SEEK_SET);                
	fread(palette, 768, 1, in);
	fclose(in);
}       

/*---------------------------------------------------------------------------*/

void SetPal(void)
{
	long i;

	outp(0x3c8,0);
	for (i=0; i<256; i++)
	{
		outp(0x3c9, palette[i][2]/4);   
		outp(0x3c9, palette[i][1]/4);   
		outp(0x3c9, palette[i][0]/4);   
	}       
}       

/*---------------------------------------------------------------------------*/

void SetgreyPal(void)
{
	long i;

	outp(0x3c8,0);
	for (i=0; i<255; i++)
	{
		outp(0x3c9, i/4);   
		outp(0x3c9, i/4);   
		outp(0x3c9, i/4);   
	}       
	outp(0x3c9, 63);   
	outp(0x3c9, 0);   
	outp(0x3c9, 0);   
}       

void SetgreyPal2(void)
{
	long i;

	outp(0x3c8,0);
	for (i=0; i<64; i++)
	{
		outp(0x3c9, i);   
		outp(0x3c9, i);   
		outp(0x3c9, i);   
	}       
}       

/*---------------------------------------------------------------------------*/

void ShowBrownianTrail(void)
{
	char pixel;
	long i;
	char *screenpointer;

	#define PIXELSTOPLOT 8

	_setcolor(255);	
	for (i=0; i<PIXELSTOPLOT; i++)
	{
		randval=rand();			// rand returns a number between 0 and 32767 (watcom)
		randval=randval/8192;	// we want an integer number 0-3;

		if (randval==0)	xpos=xpos+1;	// move the point dependant on the random number.
		else if (randval==1) xpos=xpos-1;	
		else if (randval==2) ypos=ypos+1;	
		else if (randval==3) ypos=ypos-1;	

		_setpixel(xpos+160, ypos+100);	// plot the new pixel !		
	}
			
	screenpointer=(char*) 0xa0000;
	for (i=0; i<(320*200); i++)
	{
		pixel=*screenpointer;		// darken each pixel on the screen
		if (pixel!=0) 				// unless they are already black !
		{
			pixel=pixel-1;
			*screenpointer=pixel;
		}
		screenpointer++;
	}	
}	

/*---------------------------------------------------------------------------*/

void Display2DBrownian(void)
{
	long i;

	xpos=0;
	ypos=0;
	
	_setcolor(254);	
	for (i=0; i<CORAL_POINTS2D; i++)	
	{
		randval=rand();			// rand returns a number between 0 and 32767 (watcom)
		randval=randval/8192;	// we want an integer number 0-3;

		if (randval==0)	xpos=xpos+1;	// move the point dependant on the random number.
		else if (randval==1) xpos=xpos-1;	
		else if (randval==2) ypos=ypos+1;	
		else if (randval==3) ypos=ypos-1;	

		_setpixel(xpos+160, ypos+100);	// plot the new pixel !				
		_setpixel(-xpos+160, -ypos+100);	// plot the new pixel !				
	}		
}	

/*---------------------------------------------------------------------------*/

void Create3DBrownian(void)
{
	long i;

	xpos=0;
	ypos=0;
	zpos=0;
	
	for (i=0; i<CORAL_POINTS3D; i++)	
	{
		randval=rand();			// rand returns a number between 0 and 32767 (watcom)
		randval=randval/5462;	// we want an integer number 0-5;

		if (randval==0)	xpos=xpos+1;	// move the point dependant on the random number.
		else if (randval==1) xpos=xpos-1;	
		else if (randval==2) ypos=ypos+1;	
		else if (randval==3) ypos=ypos-1;	
		else if (randval==4) zpos=zpos+1;	
		else if (randval==5) zpos=zpos-1;	
		coral[i].x=xpos;
		coral[i].y=ypos;
		coral[i].z=zpos;		// store the points in an array
	}		
	lastxpos=xpos;
	lastypos=ypos;
	lastzpos=zpos;
}	

/*---------------------------------------------------------------------------*/

Display3DBrownian(void)
{
	long i,x,y;
	char pixel;
	long *scrpt;

	for (i=0; i<CORAL_POINTS3D; i++) 	
	{
		x=rotated[i].x;	
		y=rotated[i].y;
		
		if (abs(x)<156 && abs(y)<96) 
		{
			scrpt=(long *) &ScreenBuffer[y+99][x+159];	
			*scrpt+=0x00010000; scrpt+=80;
			*scrpt+=0x01020100; scrpt+=80;
			*scrpt+=0x00010000; 
			scrpt=(long *) &ScreenBuffer[-y+99][-x+159];		
			*scrpt+=0x00010000; scrpt+=80;
			*scrpt+=0x01020100; scrpt+=80;
			*scrpt+=0x00010000;
		}		
	}		
	
	memcpy((char*) 0xa0000, ScreenBuffer, 64000);
}	

/*---------------------------------------------------------------------------*/

void RotatePoints(float anglex, float angley)
{
	long i,x,y,z;
	float sinX, sinY, cosX, cosY;
	float newx,newy,newz;
	
	sinX=sin(anglex);
	cosX=cos(anglex);
	sinY=sin(angley);
	cosY=cos(angley);		

	for (i=0; i<CORAL_POINTS3D; i++)
	{
		x=coral[i].x;	
		y=coral[i].y;
		z=coral[i].z;
		
		newx=x;
		newy=y*cosX + z*sinX;
		newz=z*cosX - y*sinX;

		rotated[i].x=newx*cosY + newz*sinY;
		rotated[i].y=newy;
		rotated[i].z=newz*cosY - newx*sinY;				
	}		 	
}	

/*---------------------------------------------------------------------------*/

void FakeBlur(void)
{
	long i,j;
	char *screenpt;
	unsigned char pixel;

	screenpt=(char*) ScreenBuffer;
	
	for (j=0; j<200; j++)
	{
		for(i=0; i<320; i++)
		{
			pixel=*screenpt;
			if (pixel>63) *screenpt=63;
			else if (pixel>1) *screenpt-=2;
			else *screenpt=0;
			screenpt++;
		}	
	}		
}	

/*---------------------------------------------------------------------------*/

void BrownianGrowth(void)
{
	long i,j;

	xpos=lastxpos;
	ypos=lastypos;
	zpos=lastzpos;

	j=growthoffset;		
	for (i=0; i<GROWTH; i++)	
	{
		randval=rand();			// rand returns a number between 0 and 32767 (watcom)
		randval=randval/5462;	// we want an integer number 0-5;

		if (randval==0)	xpos=xpos+1;	// move the point dependant on the random number.
		else if (randval==1) xpos=xpos-1;	
		else if (randval==2) ypos=ypos+1;	
		else if (randval==3) ypos=ypos-1;	
		else if (randval==4) zpos=zpos+1;	
		else if (randval==5) zpos=zpos-1;	
		coral[j].x=xpos;
		coral[j].y=ypos;
		coral[j].z=zpos;		// store the points in an array
		j++;
		if (j>CORAL_POINTS3D) j=0;
	}		
	growthoffset=j;
	lastxpos=xpos;
	lastypos=ypos;
	lastzpos=zpos;
}	

/*---------------------------------------------------------------------------*/

int main(void)
{
   float rotate_angle=0;
   long fc;

//	LoadTarga("pal1.tga");
        LoadTarga("pal1.tga");
	_setvideomode(_MRES256COLOR);

	SetgreyPal();

	while (!kbhit())
   	{
   		ShowBrownianTrail();
   	}
   	getch();

   while (!kbhit()) {
		memset((char*) 0xa0000, 0, 64000);
	 	Display2DBrownian();		
   }
   	getch();

	Create3DBrownian();	
	SetPal();
	while (!kbhit()) 
	{
		rotate_angle+=6.284/512;
		RotatePoints(rotate_angle, rotate_angle*2.72);
	 	Display3DBrownian();						
		memset(ScreenBuffer, 0, 64000);
	}
   	getch();

	while (!kbhit()) 
	{
		rotate_angle+=6.284/512;
		RotatePoints(rotate_angle, rotate_angle*2.72);
	 	Display3DBrownian();		
	 	BrownianGrowth();				
		memset(ScreenBuffer, 0, 64000);
	}
   	getch();

	while (!kbhit()) 
	{
		rotate_angle+=6.284/1024;
		RotatePoints(rotate_angle, rotate_angle*2.72);
	 	Display3DBrownian();						
		FakeBlur();
	}
   	getch();

	fc=0;
	CalcRadiusTable_Perspect();
	CalcAngleTable();	
        LoadTarga("pal2.tga");
	SetPal();
	while (!kbhit()) 
	{
		rotate_angle+=6.284/512;
		RotatePoints(rotate_angle, rotate_angle*2.72);
		DrawRealPlasma();
		DoTunnel(-fc*4, fc/2);
	 	Display3DBrownian();
	 	fc++;						
	}
   	getch();

	_setvideomode(_TEXTC80);
	return(0);
}       

/*---------------------------------------------------------------------------*/
