#define ButtonCol1 64
#define ButtonCol2 128
#define ButtonFontCol 56

///////////////////////////////////
//
// Graphic routines -


// D - at end is for direct output (screen plot)


// PutPCX(WindowType,BitMapType) -- Copys bitmap to window
//// function supports loading of PCX if not in memory

// CopyWindow(WindowType,WindowType) (source,dest) -- 
// ClearWindow(WindowType) -- Clears window
// NewWindow(SizeX,SizeY,Changed,Virtual,Destnation);
// PlotWindow(WindowType)  -- Plot window to viewport (non cliped)
// PlotWindows() -- Plot all windows in list

// PlotObjectM(ObjectType,WindowType) -- Plots masked objects (move/non-move)

// PlotObjectCLIP(ObjectType,WindowType) -- Plot any sized object (overwrite)
// BoxCLIP(WindowType,x1,y1,x2,y2,col) -- Plot box Cliped******* fucked******
// Box(WindowType,x1,y1,x2,y2,col) -- Plot box
// FillBox(WindowType,x1,y1,x2,y2,col) -- Filled box (non cliped)
// ButtonBox(WindowType,x1,y1,x2,y2,col1,col2) -- Plot box, button type
// ButtonBoxD(x1,y1,x2,y2,col1,col2) -- Plot box, button type (Direct)

// PlotLetterD(Destnation,SizeX,SizeY,Source) -- plots colour font character
// PlotLetterD(Destnation,SizeX,SizeY,Source,Colour) -- plots mono font char
// PlotStringD2(X,Y,String) -- Plots zero terminated string/////old
// PlotStringD(X,Y,String,fontaddress) -- Plots zero terminated string
// PlotButtonD2(int x,int y,char *String) -- Draws box as well
// PlotButtonD(int x,int y,char *String,fontAddress) -- Draws box as well

// Window operations
// PlotLetter(WindowType,Destnation,SizeX,SizeY,modulo,dmodulo,Source)
// PlotLetter(WindowType,Destnation,SizeX,SizeY,modulo,dmodulo,Source,Colour)
// PlotString(WindowType,X,Y,String,fontaddress) -- Plots zero terminated string
// PlotButton(WindowType,int x,int y,char *String,fontAddress) -- Draws box as well

///////////////////////////////////

void PlotPixel(unsigned char *Offset,unsigned char Col);
void PlotPixel2(unsigned char *Offset,unsigned char Col);
void SetPalette(unsigned char *PaletteRGB,int StartCol,int NumCols);

// Anim Stuff
// 
// Anim structure used to define anim
struct AnimFrameType
 {
 unsigned char *GFXPointer;
 AnimFrameType *Next;
 };

// Header for anim
struct AnimHeader
 {
 long SizeX,SizeY;
 long Frames;
 AnimFrameType *Next;
 };

// Anim Structure to define anim in effect
struct AnimType
 {
 long XPos,YPos;
 long CurrentFrame; 
 AnimHeader *Anim; // Pointer to anim to use
 };


// Graphic stuff
struct BitMapType
 {
 long XPos,YPos;
 long SizeX,SizeY;
 char *Name;
 unsigned char *GFXPointer;
 };

struct BackPlotObject
 {
 long XPos,YPos;
 long SizeX,SizeY;
 unsigned char *GFXPointer;
 };

struct MovePlotObject
 {
 long XPos,YPos;
 long SizeX,SizeY;
 long MaxFrames;
 long Frame;
 long OFrame;
 unsigned long Type;
 unsigned char *GFXPointer; // or anim list pointer
 unsigned char *BackPointer;
 long OXPos,OYPos;
 };
// TYPE -
//  Bit
//   0000 - Overwrite // Back textures
//   0001 - BackCopy  // Non-moving objects
//   0010 - 0 Mask    
//   0100 - Moving (use old x,y to put background back )
//   1000 - ClearBack (backbuffer not read yet)
struct ButtonType
 {
 long XPos,YPos;         // Window offset of button
 long SizeX,SizeY;       // The size of the button
 char *String;           // The string to plot with the button
 unsigned char *Effect;  // This points to a byte to set if button is pressed
 ButtonType *Next;       // Next pointer
 };

struct HitType
 {
 long XPos,YPos;         // Window offset of button
 long SizeX,SizeY;       // The area that this pressable area covers
 unsigned char *Effect;  // Byte pointer to set if clicked on
 };

struct WindowType
 {
 unsigned char *Virtual;   // Screen Pointer
 long SizeX,SizeY;
 long Changed;                  // Should this window be updated
 unsigned char *Destnation;
 ButtonType *ButtonPointer; // Pointer to linked list of buttons in window
 HitType *HitPointer;
 WindowType *Next;         // All windows are in a linked list 
 };

extern WindowType *FirstWindow;


void PutBitMap(WindowType *WIN,BitMapType *BitMap);
void PlotWindow(WindowType *WIN);
void PlotWindows();
void CopyWindow(WindowType *WIN1,WindowType *WIN2);
void ClearWindow(WindowType *WIN);
void RemoveWindow(WindowType *WIN);
WindowType* NewWindow(int SizeX,int SizeY,int Changed,
                unsigned char *Virtual,unsigned char *Destnation);
void PlotObjectCLIP(BackPlotObject *OBJ,WindowType *WIN);
void BoxCLIP(WindowType *WIN,int x1,int y1,int x2,int y2,unsigned char col);
void Box(WindowType *WIN,int x1,int y1,int x2,int y2,unsigned char col);
void FillBox(WindowType *WIN,int x1,int y1,int x2,int y2,unsigned char col);
void ButtonBox(WindowType *WIN,int x1,int y1,int x2,int y2,
                unsigned char col1,unsigned char col2);
void ButtonBoxD(int x1,int y1,int x2,int y2,
                unsigned char col1,unsigned char col2);
void PlotLetterD(unsigned char *Destnation,int SizeX,int SizeY,int Modulo,
                unsigned char *Source);
void PlotLetterD(unsigned char *Destnation,int SizeX,int SizeY,int Modulo,
                unsigned char *Source, unsigned char col);
void PlotStringD2(int x,int y,char *String);
void PlotStringD(int x,int y,char *String,unsigned char *Source);
void PlotButtonD2(int x,int y,char *String);
void PlotButtonD(int x,int y,char *String,unsigned char *FontAddress);
void PlotLetter(unsigned char *Destnation,int SizeX,int SizeY,int Modulo,
                int DModulo,unsigned char *Source);
void PlotLetter(unsigned char *Destnation,int SizeX,int SizeY,int Modulo,
                int DModulo,unsigned char *Source, unsigned char col);
void PlotString(WindowType *WIN,int x,int y,char *String,unsigned char *Source);
void PlotButton(WindowType *WIN,int x,int y,char *String,unsigned char *FontAddress);
