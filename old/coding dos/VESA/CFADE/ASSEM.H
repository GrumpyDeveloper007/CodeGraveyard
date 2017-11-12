extern unsigned char *para;
extern unsigned char *parb;
extern unsigned char *parc;
extern unsigned char *pard;
extern unsigned char *VESAVirtualScreen;  // Address of virtual screen
extern unsigned char *VESAScreenPtr;      // Address of screen
extern int VESAScreenLength;              // Length of screen / 4

// table,screen
#define SetParam() (ASMSetParam(VESAVirtualScreen,VESAScreenPtr,VESAScreenLength) )
extern "C" void ASMSetParam(unsigned char *,unsigned char *,int);
#pragma aux ASMSetParam parm [eax][ebx][ecx];


// table,screen
#define UpdateFade() (AsmUpdateFade(para,parb,parc,pard) )
  extern "C" void AsmUpdateFade(unsigned char *,unsigned char *,unsigned char*,unsigned char*);
#pragma aux AsmUpdateFade parm [esi][ebx][ecx][edx];






