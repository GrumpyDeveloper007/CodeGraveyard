// Assembler functions -- standard functions converted to assembler
// Version 1.1 -- Dark Elf Phobia

void outp2(long,long);
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

long inp2(long);
#pragma aux inp2 = \
       "push edx"\
       "mov edx,eax"\
       "sub eax,eax"\
       "in al,dx"\
       "pop edx"\
       parm caller [eax] \
       value [eax];

int kbhit2();
#pragma aux kbhit2 =   \
        "mov     ax,0x0B00"\
        "int     0x21"   \
        "cbw"          \
        "cwde"         \
		value [eax]             \
                modify [eax edx];
