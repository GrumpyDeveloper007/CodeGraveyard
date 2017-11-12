// table,screen
extern "C" void PlotTable2(unsigned char *,unsigned char *,unsigned int,int,unsigned char*);
#pragma aux PlotTable2 parm [esi][edx][eax][ecx][edi];


extern "C" void UpdateScreen2(unsigned char *,unsigned char *,unsigned char *);
#pragma aux UpdateScreen2 parm [esi][edi][edx];

#define WaitVBL() (AsmWaitVBL())
extern "C" void AsmWaitVBL();


