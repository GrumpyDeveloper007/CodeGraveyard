extern unsigned char *destnation;
extern unsigned char *source;

extern unsigned char *circle;  // Address of pre-calc table
extern unsigned char *picture;      // Address of picture
extern int startx;
extern int Copysize;

#define PlotTable() (AsmPlotTable(circle,destnation,startx,CopySize) )
extern "C" void AsmPlotTable(unsigned char *,unsigned char *,unsigned int,int);
#pragma aux AsmPlotTable parm [esi][edx][eax][ecx];
// table,screen

// fire
#define PlotFire() (AsmPlotFire(source,destnation) )
extern "C" void AsmPlotFire(unsigned char *,unsigned char *);
#pragma aux AsmPlotFire parm [esi][edi];

#define PlotFire2() (AsmPlotFire2(source,destnation) )
extern "C" void AsmPlotFire2(unsigned char *,unsigned char *);
#pragma aux AsmPlotFire2 parm [esi][edi];

#define CopyPic() (AsmCopyPic(destnation) )
extern "C" void AsmCopyPic(unsigned char *);
#pragma aux AsmCopyPic parm [esi];


