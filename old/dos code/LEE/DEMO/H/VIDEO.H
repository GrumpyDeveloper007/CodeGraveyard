// Devised for Watcom C++ By Xavier / Phobia

extern "C" void CLS(unsigned char *);
#pragma aux CLS parm [edi];

#define UpdateScreen() (AsmUpdateScreen(VirtualScreen,ScreenPtr))
extern "C" void AsmUpdateScreen(unsigned char *,unsigned char *);
#pragma aux AsmUpdateScreen parm [esi][edi];

/*int outp2(long,long);
#pragma aux outp2 =   \
        "push    ebx     "\
        "push    ecx     "\
        "mov     ebx,eax "\
        "mov     ecx,edx "\
        "mov     edx,eax "\
        "mov     al,cl   "\
        "out     dx,al   "\
        "pop     ecx     "\
        "pop     ebx     "\
		parm caller [eax] [edx] \
                modify [eax edx];
  */


unsigned char *ScreenPtr=(unsigned char *)0xa0000;      // Address of screen

unsigned char ScreenBuffer[(320*200)];  // VGA virtual screen
unsigned char *VirtualScreen=ScreenBuffer;  // Address of virtual screen

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


void SetPalette(unsigned char *PaletteRGB,int StartCol,int NumCols)
  {
  for (int a=StartCol;a<StartCol+NumCols;a++)
   {
   outp2(0x3c8,a);
   outp2(0x3c9,PaletteRGB[a*3+0]);
   outp2(0x3c9,PaletteRGB[a*3+1]);
   outp2(0x3c9,PaletteRGB[a*3+2]);
   }
  }

