// Defines for Mouse.cpp

typedef unsigned char BYTE;

unsigned char getmousedata(short &rx,short &ry);
int initmouse();
void setmouserange(short x1,short y1,short x2,short y2);

unsigned char getmousepos(long &x,long &y);
#pragma aux getmousepos =       \
        "mov     eax,0x03      "\
        "int     0x033         "\
        "shr     ecx,1         "\
        parm caller [ecx] [edx] \
        value  [ebx]            \
        modify [eax edx];

void hide_mouse();
#pragma aux hide_mouse =        \
        "mov     eax,0x02      "\
        "int     0x033         "\
        modify [eax edx];

void show_mouse();
#pragma aux show_mouse =        \
        "mov     eax,0x01      "\
        "int     0x033         "\
        modify [eax edx];

void setmousepos(long x,long y);
#pragma aux setmousepos =       \
        "shl     ecx,1         "\
        "mov     eax,0x04      "\
        "int     0x033         "\
        parm caller [ecx] [edx] \
        modify [eax edx];
