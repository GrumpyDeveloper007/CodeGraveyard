// Module - texture
//
// Includes -
//   cTEXTURE
// 
// Coded by Dark Elf

//void LoadTextures(char *FileName);

class cTEXTURE
{
private:
public:
	char *Name;
	unsigned char *TexturePtr;
	long SizeX;
	long SizeY;
	long Type; //1=24bit
	
	~cTEXTURE();
	cTEXTURE();
	
	long Allocate(long sizeX,long sizeY,long type);
	long LoadTGA(char *filename);
	long LoadTGA();
	
};


/*
global texture file format -

NUMTEXTURES 10
-- number of textures

TEXTURE 0 texture.tga
-- texture number,texture file name
-- optional -- texture width,height,bbp (reserved for loading of raw)
*/