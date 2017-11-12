extern unsigned char *circle;  // Address of pre-calc table
extern unsigned char *picture;      // Address of picture
extern unsigned char *ScreenB;
extern int startx;
extern int Copysize;
// table,screen
#define PlotTable2() (AsmPlotTable(circle,picture,startx,CopySize,ScreenB) )
extern "C" void AsmPlotTable(unsigned char *,unsigned char *,unsigned int,int,unsigned char *);
#pragma aux AsmPlotTable parm [esi][edx][eax][ecx][edi];


//#define UpdateScreen() (AsmUpdateScreen(VirtualScreen,ScreenPtr))
//extern "C" void AsmUpdateScreen(unsigned char *,unsigned char *);
//#pragma aux AsmUpdateScreen parm [esi][edi];


