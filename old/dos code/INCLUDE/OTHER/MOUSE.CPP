// Mouse handling stuff.. for VGA screens.. dunno if it`ll work on
// VESA stuff, not done in editor yet anyway :)
/////////////////////////////////////////////////////////////////

#include <i86.h>

typedef unsigned char BYTE;

struct SREGS sregs;
union REGS inregs, outregs;
BYTE ppbX = 1,ppbY = 0; // divisor for smooth correct mouse position calcs


BYTE getmousedata(short &rx,short &ry)
 {
 int ReturnVal,x,y;

 inregs.w.ax = 0x03;
 int386 (0x33, &inregs, &outregs);
 ReturnVal=outregs.w.bx;
 rx=outregs.w.cx >> ppbX;
 ry=outregs.w.dx >> ppbY;
 return(ReturnVal);
 }

int initmouse()
 {
 inregs.w.ax = 0x00;
 int386 (0x33, &inregs, &outregs);
 if (outregs.w.ax == 0xFFFF)
  return 0;
 return -1;
 }

void hide_mouse()
 {
 inregs.w.ax = 0x02;
 int386 (0x33, &inregs, &outregs);
 }

void show_mouse()
 {
 inregs.w.ax = 0x01;
 int386 (0x33, &inregs, &outregs);
 }

void setmousepos(short x,short y)
 {
 inregs.w.ax = 0x04;
 inregs.w.cx = x << ppbX;
 inregs.w.dx = y << ppbY;
 int386 (0x33, &inregs, &outregs);
 }

void setmouserange(int x1,int y1,int x2,int y2)
 {
 inregs.w.ax = 0x07;
 inregs.w.cx = x2 << ppbX;
 inregs.w.dx = x1 << ppbY;
 int386 (0x33, &inregs, &outregs);
 inregs.w.ax = 0x08;
 inregs.w.cx = y2 << ppbX;
 inregs.w.dx = y1 << ppbY;
 int386 (0x33, &inregs, &outregs);
 }

void GetMouseMovement(short &rx,short &ry)
 {
 inregs.w.ax = 0x0b;
 int386 (0x33, &inregs, &outregs);
 rx=outregs.w.cx;               // Return amount moved information
 ry=outregs.w.dx;
 }

BYTE GetButton()
 {
 inregs.w.ax = 0x03;
 int386 (0x33, &inregs, &outregs);
 return(outregs.w.bx);
 }
