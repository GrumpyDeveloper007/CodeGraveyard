extern unsigned char *circle;  // Address of pre-calc table
extern unsigned char *picture;      // Address of picture
extern int startx;
extern int Copysize;
// table,screen
#define PlotTable2() (AsmPlotTable(circle,picture,startx,CopySize) )
extern "C" void AsmPlotTable(unsigned char *,unsigned char *,unsigned int,int);
#pragma aux AsmPlotTable parm [esi][edx][eax][ecx];


//#define UpdateScreen() (AsmUpdateScreen(VirtualScreen,ScreenPtr))
//extern "C" void AsmUpdateScreen(unsigned char *,unsigned char *);
//#pragma aux AsmUpdateScreen parm [esi][edi];


