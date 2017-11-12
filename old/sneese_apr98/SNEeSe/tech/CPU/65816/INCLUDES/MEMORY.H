int INITMEMORY(int banks);

unsigned char getbyte(unsigned int location);
/*unsigned long getbyte(unsigned char bank,unsigned int location);*/
unsigned short getword(unsigned int location);

unsigned long getmemory(long location,unsigned char size);
unsigned long putword(unsigned int location,unsigned short data);
unsigned long putbyte(unsigned int location,unsigned char data);
unsigned long putmemory(unsigned int location,unsigned int data,unsigned char size);
 
 void writememory(unsigned int location,unsigned short data);
 void push(unsigned char data);
 void pushword(unsigned short data);
 unsigned char pull();
 unsigned short pullword();
 
 
 
 