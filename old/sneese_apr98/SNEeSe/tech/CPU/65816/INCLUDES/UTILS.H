void setbit(unsigned short memory,unsigned char bit,unsigned char out);
void flagset(unsigned char flags);
void setflags(unsigned char flags);
void setflag(unsigned char flag,unsigned char what);
void checksetflags(unsigned int check,unsigned char flags);
void checksetflagsindex(unsigned int check,unsigned char flags);
int checkflag(unsigned char flag);
int checkbit(unsigned short number, unsigned char bit);
void readmemory();
void readmemoryword();
void readmemoryindex();
void readmemorybyte();



