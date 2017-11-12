// Module - texture
//
// Includes -
//   
//   
// 
// Coded by Dark Elf
//

#include <fstream.h>
#include <string.h>
#include <windows.h>
//#include <windowsx.h>

#include "texture.h"
//unsigned char bug[256*256*3];

#define TRUE 0
#define FALSE 1

extern cTEXTURE *GlobalTextures;
extern long NumTextures;
extern fstream dale;

long LoadTextures(char *FileName)
{
	fstream reader;
	char buffer[500];
	char *bufferptr=&buffer[0];
	long TextureNum;
	long i;
	reader.open(FileName,ios::in);
	if (!reader)
		return FALSE;
	reader >> buffer;
	while (1==1)
	{
		if (strcmp(bufferptr,(char *)"NUMTEXTURES")==0 )
		{
			reader >> NumTextures;
			NumTextures=NumTextures-1;
			GlobalTextures=new cTEXTURE[NumTextures+1];
		}
		if (strcmp(bufferptr,(char *)"TEXTURE")==0 )
		{
			reader >> TextureNum;
			if (TextureNum<=NumTextures)
			{
				reader >> buffer;
				GlobalTextures[TextureNum].Name=new char[lstrlen(buffer)+1];
				for (i=0;i<lstrlen(buffer);i++)
				{
					GlobalTextures[TextureNum].Name[i]=buffer[i];
				}
				GlobalTextures[TextureNum].Name[i]=0;
				
				dale << "te:"<<TextureNum<<endl;
				GlobalTextures[TextureNum].LoadTGA();
			}
		}

		reader >>buffer;
		if (!reader)
			break;
	}

}

struct TGAHEADERTYPE
{
	unsigned short Zero1;//0
	unsigned char val1; // 02
	unsigned char Zero2; //0
	long Zero3;//0
	long Zero4;//0
	unsigned short SizeX;
	unsigned short SizeY;
	unsigned char val2;//0x18
	unsigned char Zero5;//0
};
#define TGAHEADERLENGTH 2+1+1+4+4+2+2+1+1

extern fstream dale;


cTEXTURE::cTEXTURE()
{
	TexturePtr=NULL;
	SizeX=0;
	SizeY=0;
}

cTEXTURE::~cTEXTURE()
{
	if (TexturePtr!=NULL)
		delete TexturePtr;
}
long cTEXTURE::Allocate(long sizeX,long sizeY,long type)
{
	SizeX=sizeX;
	SizeY=sizeY;
	Type=type;
	if (Type==1)
		TexturePtr=new unsigned char [SizeX*SizeY*3];
	
	if (TexturePtr!=NULL)
		return TRUE;
	else
		return FALSE;
}

long cTEXTURE::LoadTGA(char *filename)
{
	TGAHEADERTYPE TGAHeader;
	fstream file;
	int i;
	
	file.open(filename,ios::in|ios::binary|ios::nocreate);
	
	file.read((char*)&TGAHeader,TGAHEADERLENGTH);
	if (TGAHeader.Zero1!=0 || TGAHeader.Zero2!=0 ||
		TGAHeader.Zero3!=0 || TGAHeader.Zero4!=0 ||
		/*TGAHeader.Zero5!=0 ||*/ TGAHeader.val1!=0x02 ||
		TGAHeader.val2!=0x18)
	{
		dale << "Error Loading Texture (only 24bit uncompressed supported)"<<endl;
		return (1==0);
	}
	SizeX=TGAHeader.SizeX;
	SizeY=TGAHeader.SizeY;
	Type=1;
	TexturePtr=new unsigned char[SizeX*SizeY*3];
	for (i=SizeY-1;i>=0;i--)
		file.read((char*)TexturePtr+i*SizeX*3,SizeX*3);
	
	//file.read((char*)TexturePtr,SizeX*SizeY*3);
	unsigned char r,b,g;
/*	for (i=0;i<SizeX*SizeY;i++)
	{
		r=TexturePtr[i*3];
		g=TexturePtr[i*3+1];
		b=TexturePtr[i*3+2];
		
		TexturePtr[i*3]=b;
		TexturePtr[i*3+1]=g;
		TexturePtr[i*3+2]=r;
	}
	*/
	file.close();
	return (1==1);
}

long cTEXTURE::LoadTGA()
{
	TGAHEADERTYPE TGAHeader;
	fstream file;
	int i;
	
	file.open(Name,ios::in|ios::binary|ios::nocreate);
	
	file.read((char*)&TGAHeader,TGAHEADERLENGTH);
	if (TGAHeader.Zero1!=0 || TGAHeader.Zero2!=0 ||
		TGAHeader.Zero3!=0 || TGAHeader.Zero4!=0 ||
		/*TGAHeader.Zero5!=0 ||*/ TGAHeader.val1!=0x02 ||
		TGAHeader.val2!=0x18)
	{
		dale << "Error Loading Texture (only 24bit uncompressed supported)"<<endl;
		return (1==0);
	}
	SizeX=TGAHeader.SizeX;
	SizeY=TGAHeader.SizeY;
	Type=1;

	TexturePtr=new unsigned char[SizeX*SizeY*3];
	for (i=SizeY-1;i>=0;i--)
		file.read((char*)TexturePtr+i*SizeX*3,SizeX*3);
	
//file.read((char*)TexturePtr,SizeX*SizeY*3);

	unsigned char r,b,g;
/*	for (i=0;i<SizeX*SizeY;i++)
	{
		r=TexturePtr[i*3];
		g=TexturePtr[i*3+1];
		b=TexturePtr[i*3+2];
		
		TexturePtr[i*3]=g;
		TexturePtr[i*3+1]=b;
		TexturePtr[i*3+2]=r;
	}
	*/
	file.close();
	return (1==1);
}
