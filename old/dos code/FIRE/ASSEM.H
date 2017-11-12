extern unsigned char *destnation;
extern unsigned char *source;


// table,screen
#define PlotFire() (AsmPlotFire(source,destnation) )
extern "C" void AsmPlotFire(unsigned char *,unsigned char *);
#pragma aux AsmPlotFire parm [esi][edi];

#define PlotFire2() (AsmPlotFire2(source,destnation) )
extern "C" void AsmPlotFire2(unsigned char *,unsigned char *);
#pragma aux AsmPlotFire2 parm [esi][edi];

#define CopyPic() (AsmCopyPic(destnation) )
extern "C" void AsmCopyPic(unsigned char *);
#pragma aux AsmCopyPic parm [esi];


