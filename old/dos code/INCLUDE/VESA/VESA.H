// SVGA Stuff

void SetPalette(unsigned char *PaletteRGB,int StartCol,int NumCols);
void VESAUpdateScreen();
void VESAUpdateScreenMem();
void VESACLSMem();
extern unsigned char *VESAVirtualScreen;  // Address of virtual screen
extern unsigned char *VESAScreenPtr;      // Address of screen
extern int VESAScreenLength;              // Length of screen / 4
#define VESACLS() (AsmVESACLS(VESAVirtualScreen,VESAScreenLength))
extern "C" void AsmVESACLS(unsigned char *,int);
#pragma aux AsmVESACLS parm [edi] [ecx];
#define VESAUpdateScreenMem() (AsmVESAUpdateScreenMem(VESAVirtualScreen,VESAScreenPtr,VESAScreenLength))
extern "C" void AsmVESAUpdateScreenMem(unsigned char *,unsigned char *,int);
#pragma aux AsmVESAUpdateScreenMem parm [esi] [edi] [ecx];

struct ModeInfoBlock
 {
 short ModeAttributes;
 char WinAAttributes;
 char WinBAttributes;
 short WinGranularity;
 short WinSize;
 short WinASegment;
 short WinBSegment;
 long WinFuncPtr;
 short BytesPerScanLine;
 short XResolution;
 short YResolution;
 char XCharSize;
 char YCharSize;
 char NumberOfPlanes;
 char BitsPerPixel;
 char NumberOfBanks;
 char MemoryModel;
 char BankSize;
 char NumberOfImagePages;
 char Reserved;
 char RedMaskSize;
 char RedFieldPosition;
 char GreenMaskSize;
 char GreenFieldPosition;
 char BlueMaskSize;
 char BlueFieldPosition;
 char RsvdMaskSize;
 char RsvdFieldPosition;
 char DirectColorModeInfo;
 long PhysBasePtr;
 long OffScreenMemOffset;
 short OffScreenMemSize;
 char ReservedEnd[206];
 };

extern int VESANumModes;
extern short VESAAvailModes[200];  // Crappy static storage

int InitVESA();
void CloseVideo();
void KillVESA();
int SetVideo(ModeInfoBlock *RequestedMode);

#define MODEL_PACKED 4
#define MODEL_DIRECT 6

