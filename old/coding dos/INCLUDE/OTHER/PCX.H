// Defines for PCX.cpp

struct PCXHeader
 {
 unsigned char Manufacturer;
 unsigned char Version;
 unsigned char Encoding;
 unsigned char BitsPerPixel;
 unsigned short Xmin,Ymin,Xmax,Ymax;
 unsigned short Hdpi;
 unsigned short Vdpi;
 unsigned char ColourMap[48];	// ignored cos I dont know what it is!
 unsigned char Reserved;
 unsigned char NPlanes;
 unsigned short BytesPerLine;
 unsigned short PaletteInfo;
 unsigned short HSCreen;
 unsigned short VSCreen;
 unsigned char Filler[54];     // pad out to 128 bytes in size
 };

void GetPCXInfo(PCXHeader *HeaderInfo,char *FileName);
void GetPCXPicture(char *FileName,unsigned char *Buffer);
void GetPCXPicture(PCXHeader *HeaderInfo,char *FileName,unsigned char *Buffer);
void GetPCXPicture2(char *FileName,unsigned char *Buffer,unsigned char *Palette);
void GetPCXPalette(char *FileName,unsigned char *Pal);
void GetPCXPalette(PCXHeader *HeaderInfo,char *FileName,unsigned char *Pal);
void GetPCXPalette(char *FileName,unsigned char *Palette);
