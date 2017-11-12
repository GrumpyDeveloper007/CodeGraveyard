#include <conio.h>
#include <fstream.h>
////////////////////////////////////////////////////////////////////////////
// File IO library
//
// Coded by Dark Elf / Phobia
//
// Note: There may be problems with reading more than 64K at a time
//       There are no error checking !!

#include <i86.h>
const int FRead=0;
const int FWrite=1;
const int FReadWrite=2;
const int FSpecial=3;

const int SeekStart=0;
const int SeekCurrent=1;
const int SeekEnd=2;

 union REGS regs;
 struct SREGS sregs;

int OpenFile(char* Name, int mode)
 {
 regs.x.eax = 0x3d00|(mode&3);
 regs.x.edx = (int)Name;
 regs.x.ecx = 0x0;
 int386(0x21,&regs,&regs);
 cout << (int)regs.w.cflag;
 return regs.x.eax;
 }

int ReadFile(int Handle,int Length,unsigned char *Buffer)
 {
 regs.x.eax = 0x3f00;
 regs.x.ebx = Handle;
 regs.x.edx = (int)Buffer;
 regs.x.ecx = Length;
 int386(0x21,&regs,&regs);
 return (0==0);
 }

int CloseFile(int Handle)
 {
 regs.x.eax = 0x3e00;
 regs.x.ebx = Handle;
 int386(0x21,&regs,&regs);
 return (0==0);
 }

// Position = offset from type, see Seek const for types
int SetFilePointer(int Handle,int Pos,int type)
 {
 regs.x.eax = 0x4200|(type&3);
 regs.x.ebx = Handle;
 regs.x.edx = Pos;            // CX:DX
 int386(0x21,&regs,&regs);
 return (regs.x.eax);
 }


void main()
 {
 OpenFile("main.cpp",FRead);



// cout <<"input :"<< (int) ios::in<< endl;
// cout <<"output :"<< (int) ios::out<< endl;
// cout <<"at end :"<< (int) ios::ate<<endl;
// cout <<"noreplace :"<< (int) ios::noreplace <<endl;
// cout <<"binary :"<<(int) ios::binary <<endl;
while(!kbhit());
 }
