const int FRead=0;
const int FWrite=1;
const int FReadWrite=2;
const int FSpecial=3;

const int SeekStart=0;
const int SeekCurrent=1;
const int SeekEnd=2;

int OpenFile(char *Name, int Mode);
int ReadFile(int Handle,int Length,unsigned char *Buffer);
int WriteFile(int Handle,int Length,unsigned char *Buffer);
int CloseFile(int Handle);
int SetFilePointer(int Handle,int Pos,int type);

