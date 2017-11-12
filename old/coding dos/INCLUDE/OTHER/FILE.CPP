////////////////////////////////////////////////////////////////////////////
// File IO library V1.1
//
// Coded by Dark Elf / Phobia
//
// Note: There may be problems with reading more than 64K at a time
//
// Error reporting on all routines except setfilepointer

#include <i86.h>
const int FRead=0;
const int FWrite=1;
const int FReadWrite=2;
const int FSpecial=3;

const int SeekStart=0;
const int SeekCurrent=1;
const int SeekEnd=2;

 union REGS Fregs;
 struct SREGS Fsregs;

int OpenFile(char* Name, int mode)
 {
 Fregs.x.eax = 0x3d00|(mode&3);
 Fregs.x.edx = (int)Name;
 Fregs.x.ecx = 0x0;
 int386(0x21,&Fregs,&Fregs);
 if (Fregs.x.cflag==-1) 
   return (0==1); // If carry set then error in reading file
 else return Fregs.x.eax;
 }

int ReadFile(int Handle,int Length,unsigned char *Buffer)
 {
 Fregs.x.eax = 0x3f00;
 Fregs.x.ebx = Handle;
 Fregs.x.edx = (int)Buffer;
 Fregs.x.ecx = Length;
 int386(0x21,&Fregs,&Fregs);
 if (Fregs.x.cflag==-1) 
   return (0==1); // If carry set then error in reading file
 else return (0==0);
 }

int WriteFile(int Handle,int Length,unsigned char *Buffer)
 {
 Fregs.x.eax = 0x4000;
 Fregs.x.ebx = Handle;
 Fregs.x.edx = (int)Buffer;
 Fregs.x.ecx = Length;
 int386(0x21,&Fregs,&Fregs);
 if (Fregs.x.cflag==-1) 
   return (0==1); // If carry set then error in reading file
 else return (0==0);
 }

int CloseFile(int Handle)
 {
 Fregs.x.eax = 0x3e00;
 Fregs.x.ebx = Handle;
 int386(0x21,&Fregs,&Fregs);
 if (Fregs.x.cflag==-1) 
   return (0==1); // If carry set then error in reading file
 else return (0==0);
 }

// Position = offset from type, see Seek const for types
int SetFilePointer(int Handle,int Pos,int type)
 {
 Fregs.x.eax = 0x4200|(type&3);
 Fregs.x.ebx = Handle;
 Fregs.x.edx = Pos;
 Fregs.x.ecx = Pos>>16;            // CX:DX
 int386(0x21,&Fregs,&Fregs);
 return (Fregs.x.eax);
 }


