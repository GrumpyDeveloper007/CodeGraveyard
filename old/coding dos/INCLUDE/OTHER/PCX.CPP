//////////////////////////////////////////////////////////////////////////
//
// WATCOM PCX file handling routines (16K buffer read)

// Version 1.3
// Includes direct file IO
// Includes Read buffer
// Error checking for the existence of the file

// GetPCXInfo(HeaderINFO) reads in the picture information about the file requested
// GetPCXPicture(HeaderINFO) - can be passed to bypass reading of PCX header
// GetPCXPicture(HeaderINFO) loads the picture to the relevant address
// GetPCXPicture() loads the picture to the relevant address
// GetPCXPicture2() loads the picture/palette to the relevant address
// GetPCXPalette(HeaderINFO) loads the palette into the relevant address
// GetPCXPalette() loads the palette into the relevant address

// Direct file IO
#include "File.cpp"

struct PCXHeader
 {
 unsigned char  Manufacturer;
 unsigned char  Version;
 unsigned char  Encoding;
 unsigned char  BitsPerPixel;
 unsigned short Xmin,Ymin,Xmax,Ymax;
 unsigned short Hdpi;
 unsigned short Vdpi;
 unsigned char  ColourMap[48];   // ignored cos I dont know what it is!
 unsigned char  Reserved;
 unsigned char  NPlanes;
 unsigned short BytesPerLine;
 unsigned short PaletteInfo;
 unsigned short HSCreen;
 unsigned short VSCreen;
 unsigned char  Filler[54];      // pad out to 128 bytes in size
 };

const HeaderSize=sizeof(PCXHeader);

////////////////////////////////////////////
const ReadBufferSize=16384;
unsigned char ReadBuffer[ReadBufferSize];

int FilePos;

unsigned char GetBufferedByte(int FileHandle)
 {
 if (FilePos==ReadBufferSize)
  {
  ReadFile(FileHandle,ReadBufferSize,ReadBuffer);
  FilePos=0;
  }
 return ReadBuffer[FilePos++];
 }

////////////////////////////////////////////////////
void GetPCXInfo(PCXHeader *HeaderInfo,char *FileName)
 {
 int FileHandle=OpenFile(FileName,FRead);
 if (FileHandle)
  {
  ReadFile(FileHandle,HeaderSize,(unsigned char *)HeaderInfo);
  CloseFile(FileHandle);
  }
 }

void GetPCXPicture(PCXHeader *HeaderInfo,char *FileName,unsigned char *Buffer)
 {
 FilePos=ReadBufferSize;
 int FileHandle;
 FileHandle=OpenFile(FileName,FRead);
 if (FileHandle)
  {
  SetFilePointer(FileHandle,HeaderSize,SeekStart);
 
  int TotalBytes=HeaderInfo->NPlanes*HeaderInfo->BytesPerLine;
  int PixelsDone=0;
  int StartPos;
  unsigned char Byte,Count;


  for (int YSize=0;YSize<HeaderInfo->Ymax-HeaderInfo->Ymin+1;YSize++)
   {
   while(PixelsDone<TotalBytes)
    {
    Byte=GetBufferedByte(FileHandle);
 
    if ((Byte&0xC0)==0xC0)       // compressed data follows
     {
     Count=Byte&0x3F;
    Byte=GetBufferedByte(FileHandle);
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
  CloseFile(FileHandle);
  }
 }


void GetPCXPicture(char *FileName,unsigned char *Buffer)
 {
 PCXHeader *HeaderInfo=new PCXHeader;
 FilePos=ReadBufferSize;
 int FileHandle;
 FileHandle=OpenFile(FileName,FRead);
 if (FileHandle)
  {
  ReadFile(FileHandle,HeaderSize,(unsigned char *)HeaderInfo);

  int TotalBytes=HeaderInfo->NPlanes*HeaderInfo->BytesPerLine;
  int PixelsDone=0;
  int StartPos;
  unsigned char Byte,Count;


  for (int YSize=0;YSize<HeaderInfo->Ymax-HeaderInfo->Ymin+1;YSize++)
   {
   while(PixelsDone<TotalBytes)
    {
    Byte=GetBufferedByte(FileHandle);

    if ((Byte&0xC0)==0xC0)       // compressed data follows
     {
     Count=Byte&0x3F;
     Byte=GetBufferedByte(FileHandle);
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
  CloseFile(FileHandle);
  }
 }

///////////////////////

void GetPCXPicture2(char *FileName,
                    unsigned char *Buffer,unsigned char *Palette)
 {
 PCXHeader *HeaderInfo=new PCXHeader;
 FilePos=ReadBufferSize;
 int FileHandle;
 FileHandle=OpenFile(FileName,FRead);
 if (FileHandle)
  {
  ReadFile(FileHandle,HeaderSize,(unsigned char *)HeaderInfo);

  int TotalBytes=HeaderInfo->NPlanes*HeaderInfo->BytesPerLine;
  int PixelsDone=0;
  int StartPos;
  unsigned char Byte,Count;


  for (int YSize=0;YSize<HeaderInfo->Ymax-HeaderInfo->Ymin+1;YSize++)
   {
   while(PixelsDone<TotalBytes)
    {
    Byte=GetBufferedByte(FileHandle);
    if ((Byte&0xC0)==0xC0)       // compressed data follows
     {
     Count=Byte&0x3F;
     Byte=GetBufferedByte(FileHandle);
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

  if (HeaderInfo->Version==5)    // has a pallete
   {
   SetFilePointer(FileHandle,-769,SeekEnd);
 
   ReadFile(FileHandle,1,(unsigned char*)&Byte);
   if (Byte==12)                 // VGA palette
    {
    ReadFile(FileHandle,256*3,Palette);
    for (int i=0;i<256;i++)     // read in palette 256 cols
     {
     Palette[i*3]=Palette[i*3]/4;   // Red
     Palette[i*3+1]=Palette[i*3+1]/4;   // Green
     Palette[i*3+2]=Palette[i*3+2]/4;   // Blue
     }
    }
   }
  CloseFile(FileHandle);
  }
 }

void GetPCXPalette(PCXHeader *HeaderInfo,char *FileName,unsigned char *Palette)
 {
 int FileHandle;
 unsigned char Byte;
 FileHandle=OpenFile(FileName,FRead);
 if (FileHandle)
  {

  if (HeaderInfo->Version==5)    // has a pallete
   {
   SetFilePointer(FileHandle,-769,SeekEnd);

   ReadFile(FileHandle,1,(unsigned char*)&Byte);
   if (Byte==12)                 // VGA palette
    {
    ReadFile(FileHandle,256*3,Palette);
    for (int i=0;i<256;i++)     // read in palette 256 cols
     {
     Palette[i*3]=Palette[i*3]/4;   // Red
     Palette[i*3+1]=Palette[i*3+1]/4;   // Green
     Palette[i*3+2]=Palette[i*3+2]/4;   // Blue
     }
    }
   }
  CloseFile(FileHandle);
  }
 }

void GetPCXPalette(char *FileName,unsigned char *Palette)
 {
 PCXHeader *HeaderInfo=new PCXHeader;
 int FileHandle;
 unsigned char Byte;
 FileHandle=OpenFile(FileName,FRead);
 if (FileHandle)
  {
  ReadFile(FileHandle,HeaderSize,(unsigned char *)HeaderInfo);

  if (HeaderInfo->Version==5)    // has a pallete
   {
   SetFilePointer(FileHandle,-769,SeekEnd);

   ReadFile(FileHandle,1,(unsigned char*)&Byte);
   if (Byte==12)                 // VGA palette
    {
    ReadFile(FileHandle,256*3,Palette);
    for (int i=0;i<256;i++)     // read in palette 256 cols
     {
     Palette[i*3]=Palette[i*3]/4;   // Red
     Palette[i*3+1]=Palette[i*3+1]/4;   // Green
     Palette[i*3+2]=Palette[i*3+2]/4;   // Blue
     }
    }
   }
  CloseFile(FileHandle);
  }
 }

