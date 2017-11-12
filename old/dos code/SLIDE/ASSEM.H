//extern unsigned char *VESAVirtualScreen;  // Address of virtual screen
//extern unsigned char *VESAScreenPtr;      // Address of screen
//extern int VESAScreenLength;              // Length of screen / 4

// table,screen
extern "C" void Slide(unsigned char*,unsigned char*,long,long);
#pragma aux Slide parm [esi][edi][ecx][edx];

#define WaitVBL() (AsmWaitVBL())
extern "C" void AsmWaitVBL();
