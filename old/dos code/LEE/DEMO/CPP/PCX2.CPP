// WATCOM PCX file handling routines V1.0
// DataFile Loader Version - whoops

// GetInfo() reads in the picture information about the file requested
// GetPicture() loads the picture to the relevant address
// GetPalette() loads the palette into the relevant address

#include <fstream.h>    // for file handling etc...

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
 unsigned char Filler[54];	// pad out to 128 bytes in size
 };

void GetPCXInfo(PCXHeader *HeaderInfo,char *FileName)
 {
// ifstream PCX(FileName,ios::in|ios::binary);
// PCX.read((unsigned char *)HeaderInfo,sizeof(PCXHeader));
// PCX.close();
 LoadDataFile(FileName,(unsigned char *)HeaderInfo,sizeof(PCXHeader));
 }

void GetPCXPicture(PCXHeader *HeaderInfo,char *FileName,unsigned char *Buffer)
 {
 int TotalBytes=HeaderInfo->NPlanes*HeaderInfo->BytesPerLine;
 int PixelsDone=0;
 int StartPos;
 unsigned char Byte,Count;

 ifstream PCX(FileName,ios::in|ios::binary);
 PCX.seekg(sizeof(PCXHeader));	// goto picture position

 for (int YSize=0;YSize<HeaderInfo->Ymax-HeaderInfo->Ymin+1;YSize++)
  {
  while(PixelsDone<TotalBytes)
   {
   PCX.read(&Byte,1);
   if ((Byte&0xC0)==0xC0)	// compressed data follows
    {
    Count=Byte&0x3F;
    PCX.read(&Byte,1);
    for (int Loop=0;Loop<Count;Loop++)
     {
     Buffer[PixelsDone+YSize*HeaderInfo->BytesPerLine]=Byte;
     PixelsDone++;
     }
    }
   else
    {
    Buffer[PixelsDone+YSize*HeaderInfo->BytesPerLine]=Byte;
    PixelsDone++;
    }
   }
  PixelsDone=0;
  }
 PCX.close();
 }

void GetPCXPalette(PCXHeader *HeaderInfo,char *FileName,unsigned char *Palette)
 {
 unsigned char Byte;

 ifstream PCX(FileName,ios::in|ios::binary);

 if (HeaderInfo->Version==5)	// has a pallete
  {
  PCX.seekg(-769,ios::end);	// goto pallete position (hopefully)
  PCX.read(&Byte,1);
  if (Byte==12)			// VGA palette
   for (int Cols=0;Cols<256;Cols++)	// read in palette 256 cols
    {
    PCX.read(&Byte,1);
    Palette[Cols*3+0]=Byte/4;	// Red
    PCX.read(&Byte,1);
    Palette[Cols*3+1]=Byte/4;	// Green
    PCX.read(&Byte,1);
    Palette[Cols*3+2]=Byte/4;	// Blue
    }
  }
 PCX.close();
 }
