// Mouse Handler from Watcom C++ <saves writing my own :)>

// Mouse Zoning functions by Xavier

#include <stdio.h>
#include <dos.h>
#include <i86.h>
#include <graph.h>

/* Data touched at mouse callback time -- they are in a structure to
        simplify calculating the size of the region to lock.
*/

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
        } cbd = { 0 };

/* Set up data buffer for mouse cursor bitmap */
unsigned short cursor[] =
        {
        0x0000, 0x0001, 0x0003, 0x0007,
        0x000f, 0x001f, 0x003f, 0x007f,
        0x00ff, 0x01ff, 0x03ff, 0x07ff,
        0x0fff, 0x1fff, 0x3fff, 0x7fff,
        0xffff, 0xfffe, 0xfffc, 0xfff8,
        0xfff0, 0xffe0, 0xffc0, 0xff80,
        0xff00, 0xfe00, 0xfc00, 0xf800,
        0xf000, 0xe000, 0xc000, 0x8000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000
        };

struct SREGS sregs;
union REGS inregs, outregs;

int lock_region (void *address, unsigned length)
        {
        union REGS regs;
        unsigned linear;

        /* Thanks to DOS/4GW's zero-based flat memory model, converting
                a pointer of any type to a linear address is trivial.
        */
        linear = (unsigned) address;

        regs.w.ax = 0x600;                                              /* DPMI Lock Linear Region */
        regs.w.bx = (linear >> 16);                     /* Linear address in BX:CX */
        regs.w.cx = (linear & 0xFFFF);
        regs.w.si = (length >> 16);                     /* Length in SI:DI */
        regs.w.di = (length & 0xFFFF);
        int386 (0x31, &regs, &regs);
        return (! regs.w.cflag);                                /* Return 0 if can't lock */
        }

#pragma off (check_stack)
void _loadds far click_handler (int max, int mbx, int mcx, int mdx, int msi, int mdi)
        {
#pragma aux click_handler parm [EAX] [EBX] [ECX] [EDX] [ESI] [EDI]
        cbd.mouse_event=1;

        cbd.mouse_code = (unsigned short) max;
        cbd.mouse_bx = (unsigned short) mbx;
        cbd.mouse_cx = (unsigned short) mcx/2;  // 640 - 320 conv
        cbd.mouse_dx = (unsigned short) mdx;
        cbd.mouse_si = (signed short) msi;
        cbd.mouse_di = (signed short) mdi;
        if (cbd.mouse_code & 8) cbd.right_button = 1;
        }
void cbc_end (void)  /* Dummy function so we can */
        {            /* calculate size of code to lock */
        }            /* (cbc_end - click_handler) */
#pragma on (check_stack)

void SetMouseShape()
 {
 unsigned short *ptr;

 /* set mouse cursor form */

 segread(&sregs);

 inregs.w.ax = 0x9;
 inregs.w.bx = 0x0;
 inregs.w.cx = 0x0;
 ptr = cursor;
 inregs.x.edx = FP_OFF (ptr);
 sregs.es        = FP_SEG (ptr);
 int386x (0x33, &inregs, &outregs, &sregs);
 }

int InitMouse()        // Implemented by Xavier by glueing bits
 {                     // returns 0 for mouse installed successfully 
 short Temp;

 inregs.w.ax = 0;
 int386 (0x33, &inregs, &outregs);
 if ((Temp=outregs.w.ax) == -1)        // mouse installed
  {
  /* lock callback code and data (essential under VMM!)
     note that click_handler, although it does a far return and
     is installed using a full 48-bit pointer, is really linked
     into the flat model code segment -- so we can use a regular
     (near) pointer in the lock_region() call.
  */
  if ((! lock_region (&cbd, sizeof(cbd))) ||
      (! lock_region ((void near *) click_handler,
       (char *) cbc_end - (char near *) click_handler)))
   {
//   printf ("locks failed\n");
   return 1;
   }

// setup click handler

  segread(&sregs);

  int (far *function_ptr)();

  inregs.w.ax = 0xC;
  inregs.w.cx = 0x0002 + 0x0008;      
  function_ptr = (int (far *)())click_handler;
  inregs.x.edx = FP_OFF (function_ptr);
  sregs.es        = FP_SEG (function_ptr);
  int386x (0x33, &inregs, &outregs, &sregs);

  SetMouseShape();

//  printf ("Mouse installed...\n");
  return 0;
  }
 else
  {
//  printf ("Mouse NOT installed...\n");
  return 1;
  }
 }

int KillMouse() // returns 0 for mouse still installed (NOT IMPORTANT)
 {
 /* check installation again (to clear watcher) */

 inregs.w.ax = 0;
 int386 (0x33, &inregs, &outregs);
 if (outregs.w.ax == -1)
  return 0;
 else
  return 1;
 }

void ShowMouse()
 {
 inregs.w.ax = 0x1;
 int386 (0x33, &inregs, &outregs);
 }

void HideMouse()
 {
 inregs.w.ax = 0x2;
 int386 (0x33, &inregs, &outregs);
 }

// Mouse Zone stuff

#define MAXZONES 100    // this is a big number but for now it dont matter

class MouseZone
 {
 private:
  int Left,Right,Top,Bottom;
  int InUse;

 public:

  MouseZone()
   {
   InUse=0;
   }

  void SetZone(int X1,int X2,int Y1,int Y2)
   {
   Left=X1;
   Right=X2;
   Top=Y1;
   Bottom=Y2;
   InUse=1;
   }

  int InZone(int MouseX,int MouseY)
   {
   if (InUse==1)
    {
    if (MouseX>=Left && MouseX<=Right && MouseY>Top && MouseY<Bottom)
     return 1;
    }
   return 0;
   }
 };

MouseZone Zones[MAXZONES];

// returns zone number or -1 for not in zone

int InZones(int MouseX,int MouseY)
 {
 for (int a=0;a<MAXZONES;a++)
  if (Zones[a].InZone(MouseX,MouseY)==1)
   return a;

 return -1;
 }

int CurrentZone=0;	// current zone in use by add zone

int AddZone(int X1,int X2,int Y1,int Y2)
 {
 if (CurrentZone<MAXZONES)
  {
  Zones[CurrentZone++].SetZone(X1,X2,Y1,Y2);
  return CurrentZone-1;
  }
 return -1;
 }

