/*************************************************************************
 **  Graphics Updating Template
 **
Known to work if compiled by DJGPP v2.0 
Runs under DOS v 6.22 or Windows 3.1 and Windows NT in Full screen DOS mode

 */  
/*#define DEBUG */
#undef DEBUG 

#include <go32.h>
#include <dpmi.h>
#include <sys/movedata.h>
#include "graflib.h"



#include <dos.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>


#define SCRX 320
#define SCRY 400
#define HSCRX (SCRX/2)
#define HSCRY (SCRY/2)  


char *tmpscr;//THE SCREEN  
void initialise();
int DrawImage(char *screenptr,int width,int height);

main()
{ 
	int dpage, vpage; // for screen control
	int i,j,k;//for screen clearing and demo square drawing program
	int frames;
	initialise();
	tmpscr =(char *) malloc(2*SCRX*SCRY*sizeof(char));// setup the screen 
	
	VGA400Mode(); 
	ClearPage400(0, 50);
	vpage =1;
	dpage = 0;
	while(1)
	{
		
	//set up double buffering page
		_disable();
		setViewPageAddr(vpage<<15);
		_enable();


				waitVS();
		
		/* Clear Screen Buffer*/
		//offset =dpage*SCRX*SCRY;
		for (j=0;j<SCRY;j++)
			for (i=0;i<SCRX;i++)
				*(char *)(tmpscr+i+j*SCRX)=0 ; 

		  // tmpscr is a char buffer where you write the data
		if (!DrawImage(tmpscr,SCRX,SCRY))break;

		CopyPage400(dpage, &tmpscr[0]);//Copy the local buffer to the real screen

	//Swap actual screen pages - this is the double buffer bit!
		vpage += 1;
		if (vpage == 2) vpage = 0;
		dpage += 2;
		if (dpage == 4) dpage = 0;
		
 }                                                                
 ResetVGAMode();  
}
