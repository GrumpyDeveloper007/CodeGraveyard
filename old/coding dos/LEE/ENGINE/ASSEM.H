//extern short *ScanBufferLeft;
//extern short *ScanBufferRight;
extern short YMin,YMax;
extern unsigned char *ScreenTemp;
extern unsigned char *GFXPointer;
//extern unsigned char *LightTables;

//extern short ScanBufferLeft[200],ScanBufferRight[200];   // For converting polygons!

#define ClearScanBuffer() (AsmClearScanBuffer(ScanBufferLeft,ScanBufferRight) )
  extern "C" void AsmClearScanBuffer(short *,short *);
#pragma aux AsmClearScanBuffer parm [esi][edi];

#define InitParams() (AsmInitParams(ScanBufferLeft,ScanBufferRight,YMin,YMax,ScreenTemp,GFXPointer) )
  extern "C" void AsmInitParams(short *,short *,short&,short&,unsigned char *,unsigned char *);
#pragma aux AsmInitParams parm [eax][ebx][ecx][edx][esi][edi];

//#define InitParams2() (AsmInitParams2(LightTables) )
//  extern "C" void AsmInitParams2(unsigned char *);
//#pragma aux AsmInitParams2 parm [eax];

#define ASMScanConvEdgeWin(x1,y1,x2,y2) (ASMScanConvEdgeWin(x1,y1,x2,y2) )
extern "C" void ASMScanConvEdgeWin(int,int,int,int);
#pragma aux ASMScanConvEdgeWin parm [eax][ebx][ecx][edx];

#define ASMScanConvEdgeWinG(x1,y1,Light1,x2,y2,Light2) (ASMScanConvEdgeWinG(x1,y1,Light1,x2,y2,Light2) )
extern "C" void ASMScanConvEdgeWinG(int,int,int,int,int,int);
#pragma aux ASMScanConvEdgeWinG parm [eax][ebx][esi][ecx][edx][edi];




