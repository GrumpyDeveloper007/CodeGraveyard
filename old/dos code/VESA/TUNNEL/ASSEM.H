extern unsigned char *circle;  // Address of pre-calc table
extern unsigned char *picture;      // Address of picture
extern int startx;
extern int Copysize;

extern unsigned char *VESAVirtualScreen;  // Address of virtual screen
extern unsigned char *VESAScreenPtr;      // Address of screen
extern int VESAScreenLength;              // Length of screen / 4

// table,screen
#define SetParam() (ASMSetParam(VESAVirtualScreen,VESAScreenPtr,VESAScreenLength) )
extern "C" void ASMSetParam(unsigned char *,unsigned char *,int);
#pragma aux ASMSetParam parm [eax][ebx][ecx];


// table,screen
#define PlotTable2() (AsmPlotTable(circle,picture,startx,CopySize) )
extern "C" void AsmPlotTable(unsigned char *,unsigned char *,unsigned int,int);
#pragma aux AsmPlotTable parm [esi][edx][eax][ecx];


//#define UpdateScreen() (AsmUpdateScreen(VirtualScreen,ScreenPtr))
//extern "C" void AsmUpdateScreen(unsigned char *,unsigned char *);
//#pragma aux AsmUpdateScreen parm [esi][edi];


