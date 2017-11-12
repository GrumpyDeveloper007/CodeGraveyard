// Standard includes for elf productions


void Copy(unsigned char *BufferA,unsigned char *BufferB,int Size);
void Clear(unsigned char *Buffer,int Size);
float GetHyp(float &dx,float &dy,float &Angle);  // Angle = degrees
float Abs(float val);
float GetAngle(float &dx,float &dy);

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
int kbhit2();
#pragma aux kbhit2 =   \
        "mov     ax,0x0B00"\
        "int     0x21"   \
        "cbw"          \
        "cwde"         \
		value [eax]             \
                modify [eax edx];



//#define WaitVBL() (AsmWaitVBL())
//extern "C" void AsmWaitVBL();

//#define Copy(unsigned char*,unsigned char*,int) 
//extern "C" void Copy(unsigned char *,unsigned char *,int);
//#pragma aux ASMSetParam parm [esi][edi][eax];



