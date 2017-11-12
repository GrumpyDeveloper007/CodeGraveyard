// definition file for awetracker

// video defs

extern unsigned char *VirtualScreen;
extern unsigned char *ScreenPtr;
void InitVideo();
void KillVideo();
void SetPalette(unsigned char *PaletteRGB,int StartCol,int NumCols);
void PlotText(int X,int Y,char *String,unsigned char Colour);
void PlotText(int X,int Y,char Character,unsigned char Colour);
#define CLS() (AsmCLS(VirtualScreen))
extern "C" void AsmCLS(unsigned char *);
#pragma aux AsmCLS parm [edi];
#define UpdateScreen() (AsmUpdateScreen(VirtualScreen,ScreenPtr))
extern "C" void AsmUpdateScreen(unsigned char *,unsigned char *);
#pragma aux AsmUpdateScreen parm [esi][edi];

// dirlist defs
struct FILELIST
 {
 char Name[13];
 long Size;
 int Directory; // if 1 this is a directory
 };

int GetDirList(char *Path,FILELIST *Files,int MaxLen,int Offset);

// Hardawe defs
void InitEMU(int);
void ResetEMU();
void Transfer2Awe(unsigned long,short *,unsigned long);

// Mouse defs

struct callback_data
        {
        int mouse_event;
        int right_button;
        unsigned short mouse_code;
        unsigned short mouse_bx;
        unsigned short mouse_cx;
        unsigned short mouse_dx;
        signed short mouse_si;
        signed short mouse_di;
        } extern cbd;

int InitMouse();
void ShowMouse();
void HideMouse();
int KillMouse();
int InZones(int MouseX,int MouseY);
extern int CurrentZone;      // current zone in use by add zone
int AddZone(int X1,int X2,int Y1,int Y2);

