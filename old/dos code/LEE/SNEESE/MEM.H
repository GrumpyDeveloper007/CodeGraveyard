/*

 HEADER FILE FOR MEM.CC

 DEFINES SOME MACROS FOR MEMORY ACCESS ETC.

*/

#define SNESAddress(Address) ((unsigned char *)((unsigned long)Address.PCPointer+(unsigned long)RomAddress))

unsigned short GetSNESWord(unsigned char *Ptr);
unsigned char GetSNESByte(unsigned char *Ptr);
unsigned char GetSNESByte_Unmapped(unsigned char *Ptr);
unsigned short GetSNESWord_Unmapped(unsigned char *Ptr);

void SetSNESByte(unsigned char *Ptr,unsigned char Byte);
void SetSNESWord(unsigned char *Ptr,unsigned short Word);
void SetSNESByte_Unmapped(unsigned char *Ptr,unsigned char Byte);
void SetSNESWord_Unmapped(unsigned char *Ptr,unsigned short Word);

