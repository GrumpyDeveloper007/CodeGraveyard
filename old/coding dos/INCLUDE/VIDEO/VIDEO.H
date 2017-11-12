// Defines for Video.cpp



extern unsigned char *VirtualScreen;  // Address of virtual screen
extern unsigned char *ScreenPtr;      // Address of screen

//  VideoMacros
void InitVideo();
#pragma aux InitVideo =   \
        "mov     eax,0x013 "\
        "int     0x010     "\
        modify [eax edx];

void KillVideo();
#pragma aux KillVideo =   \
        "mov     eax,0x003 "\
        "int     0x010     "\
          modify [eax edx];



void PutPixel(int x,int y,unsigned char Col);
#pragma aux PutPixel="mov edi,eax"           \
                     "shl edi,8"             \
                     "shl eax,6"             \  
                     "add edi,eax"           \   
                     "add edi,VirtualScreen" \
                     "add edi,ebx"           \
                     "mov [edi],cl"          \
                     parm [ebx] [eax] [cl]   \
                     modify [edi];


void SetPalette(unsigned char *PaletteRGB,int StartCol,int NumCols);
void PlotText(int X,int Y,char *String,unsigned char Colour);
void PlotText(int X,int Y,char Character,unsigned char Colour);


#define CLS() (AsmCLS(VirtualScreen))
extern "C" void AsmCLS(unsigned char *);
#pragma aux AsmCLS parm [edi];

#define UpdateScreen() (AsmUpdateScreen(VirtualScreen,ScreenPtr))
extern "C" void AsmUpdateScreen(unsigned char *,unsigned char *);
#pragma aux AsmUpdateScreen parm [esi][edi];

