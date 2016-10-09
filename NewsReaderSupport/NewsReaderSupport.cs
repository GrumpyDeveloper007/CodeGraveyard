using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NewsReaderSupport
{
    public class NewsReaderSupportClass
    {

        uint[] crc_tab = new uint[256]
{
	0x00000000, 0x77073096, 0xee0e612c, 0x990951ba, 0x076dc419, 0x706af48f, 0xe963a535, 0x9e6495a3,
	0x0edb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988, 0x09b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91,
	0x1db71064, 0x6ab020f2, 0xf3b97148, 0x84be41de, 0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7,
	0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec, 0x14015c4f, 0x63066cd9, 0xfa0f3d63, 0x8d080df5,
	0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172, 0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b,
	0x35b5a8fa, 0x42b2986c, 0xdbbbc9d6, 0xacbcf940, 0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59,
	0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423, 0xcfba9599, 0xb8bda50f,
	0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924, 0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d,
	0x76dc4190, 0x01db7106, 0x98d220bc, 0xefd5102a, 0x71b18589, 0x06b6b51f, 0x9fbfe4a5, 0xe8b8d433,
	0x7807c9a2, 0x0f00f934, 0x9609a88e, 0xe10e9818, 0x7f6a0dbb, 0x086d3d2d, 0x91646c97, 0xe6635c01,
	0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e, 0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457,
	0x65b0d9c6, 0x12b7e950, 0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65,
	0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2, 0x4adfa541, 0x3dd895d7, 0xa4d1c46d, 0xd3d6f4fb,
	0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0, 0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9,
	0x5005713c, 0x270241aa, 0xbe0b1010, 0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f,
	0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17, 0x2eb40d81, 0xb7bd5c3b, 0xc0ba6cad,
	0xedb88320, 0x9abfb3b6, 0x03b6e20c, 0x74b1d29a, 0xead54739, 0x9dd277af, 0x04db2615, 0x73dc1683,
	0xe3630b12, 0x94643b84, 0x0d6d6a3e, 0x7a6a5aa8, 0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1,
	0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb, 0x196c3671, 0x6e6b06e7,
	0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc, 0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5,
	0xd6d6a3e8, 0xa1d1937e, 0x38d8c2c4, 0x4fdff252, 0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b,
	0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55, 0x316e8eef, 0x4669be79,
	0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236, 0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f,
	0xc5ba3bbe, 0xb2bd0b28, 0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d,
	0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x026d930a, 0x9c0906a9, 0xeb0e363f, 0x72076785, 0x05005713,
	0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38, 0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21,
	0x86d3d2d4, 0xf1d4e242, 0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777,
	0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c, 0x8f659eff, 0xf862ae69, 0x616bffd3, 0x166ccf45,
	0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2, 0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db,
	0xaed16a4a, 0xd9d65adc, 0x40df0b66, 0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9,
	0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605, 0xcdd70693, 0x54de5729, 0x23d967bf,
	0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94, 0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d
};

        public int CopyTo(byte[] pBuffer, int Size, byte[] pOutBuffer, ref int WriteMaxPtr, int DataStart)
        {
            int BufferPtr = DataStart;
            int OutBufferPtr = 0;
            int WriteMax;
            int i;
            byte cbyte1, cbyte2, cbyte3, cbyte4, cbyte5, cbyte6, cbyte7;
            bool LastLine = false;

            //OutBufferPtr=(unsigned char*)i;
            WriteMax = 0;

            cbyte1 = pBuffer[DataStart];
            cbyte2 = pBuffer[DataStart+1];
            if (cbyte1 == '.' && cbyte2 == '.')
            {
                pOutBuffer[OutBufferPtr] = cbyte1;
                OutBufferPtr++;
                WriteMax++;
                BufferPtr += 2;
            }

            for (i = DataStart; i < Size; i++)
            {
                cbyte1 = pBuffer[BufferPtr];
                cbyte2 = pBuffer[BufferPtr + 1];
                cbyte3 = pBuffer[BufferPtr + 2];
                cbyte4 = pBuffer[BufferPtr + 3];
                cbyte5 = pBuffer[BufferPtr + 4];
                cbyte6 = pBuffer[BufferPtr + 5];
                cbyte7 = pBuffer[BufferPtr + 6];
                BufferPtr++;

                if (cbyte1 == 13 && cbyte2 == 10 && cbyte3 == '='
                    && cbyte4 == 'y' && cbyte5 == 'e' && cbyte6 == 'n' && cbyte7 == 'd')
                {
                    // This is the last line of text, the one that contains the yenc end section information
                    LastLine = true;
                    break;
                }

                if (LastLine == false)
                {
                    if (cbyte1 == 13 && cbyte2 == 10 && cbyte3 == '.' && cbyte4 == '.')
                    {

                        pOutBuffer[OutBufferPtr++] = cbyte1;
                        WriteMax++;
                        pOutBuffer[OutBufferPtr++] = cbyte2;
                        WriteMax++;
                        pOutBuffer[OutBufferPtr++] = cbyte3;
                        WriteMax++;
                        BufferPtr += 3;
                        i++;
                        i++;
                        i++;
                    }
                    else
                    {
                        pOutBuffer[OutBufferPtr++] = cbyte1;
                        WriteMax++;
                    }
                }

            }


            WriteMaxPtr = WriteMax;

            return i;

        }

        public int Base64(byte[] pInBuffer, byte[] pOutBuffer, int pInIndex, int pOutIndex)
        {
            int BufferPtr = 0;
            int OutBufferPtr = 0;
            int i = 0;
            byte abyte, bbyte, cbyte, dbyte;

            /*	char base64PemCode[] = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
                , 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
                , '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/' };
                unsigned char base64PemConvertCode[255];
	
                for ( i = 0; i < 255; i++ )
                    base64PemConvertCode[i] = 255;
                for ( i = 0; i < 63; i++ )
                    base64PemConvertCode[base64PemCode[i]] =  i;

              abyte=( base64PemConvertCode[*(BufferPtr) ]) & 0x3F;
                bbyte=( base64PemConvertCode[*(BufferPtr+1) ]) & 0x3F;
                cbyte=( base64PemConvertCode[*(BufferPtr+2) ]) & 0x3F;
                dbyte=( base64PemConvertCode[*(BufferPtr+3) ]) & 0x3F;
            */


            abyte = (byte)((pInBuffer[BufferPtr] - 32) & 0x3F);
            bbyte = (byte)((pInBuffer[BufferPtr + 1] - 32) & 0x3F);
            cbyte = (byte)((pInBuffer[BufferPtr + 2] - 32) & 0x3F);
            dbyte = (byte)((pInBuffer[BufferPtr + 3] - 32) & 0x3F);



            pOutBuffer[OutBufferPtr] = (byte)((abyte << 2) + ((bbyte & 0x30) >> 4));
            pOutBuffer[OutBufferPtr + 1] = (byte)(((bbyte & 0xF) << 4) + ((cbyte & 0x3C) >> 2));
            pOutBuffer[OutBufferPtr + 2] = (byte)(((cbyte & 0x3) << 6) + dbyte);


            //( (byte)((line2[i] << 2 & 0xfc | line2[i+1] >> 4 & 0x3) & 0xff) );
            //( (byte)((line2[i+1] << 4 & 0xf0 | line2[i+2] >> 2 & 0xf) & 0xff) );
            //( (byte)((line2[i+2] << 6 & 0xc0 | line2[i+3] & 0x3f) & 0xff) );
            //abyte = (m_BinaryBuffer(i) - 32) And 63
            //bbyte = (m_BinaryBuffer(i + 1) - 32) And 63
            //ccbyte = (m_BinaryBuffer(i + 2) - 32) And 63
            //dbyte = (m_BinaryBuffer(i + 3) - 32) And 63
            //i = i + 4
            //Writebuffer(t) = abyte * 4 + (bbyte And &H30) \ 16& '' shift left2
            //Writebuffer(t + 1) = (bbyte And 15) * 16 + (ccbyte And &H3C) \ 4 '' shift left2
            //Writebuffer(t + 2) = (ccbyte And &H3) * 64 + (dbyte) '' shift left2

            return i;




        }

        public uint GetCRC2(byte[] pBuffer, int Size, byte[] pOutBuffer, int pBufferLength)
        {
            //	unsigned int* longptr;
            int BufferPtr = 0;
            int OutBufferPtr = 0;
            int crc_val;
            int i;
            long crc_anz;
            long ch1, ch2, cc;
            int c;
            byte cbyte;
            uint ad_rescrc;

            int OutCount;

            crc_val = -1;
            crc_anz = 0L;


            /* X^32+X^26+X^23+X^22+X^16+X^12+X^11+X^10+X^8+X^7+X^5+X^4+X^2+X^1+X^0 */
            /* for (i = 0; i < size; i++) */
            /*      crccode = crc32Tab[(int) ((crccode) ^ (buf[i])) & 0xff] ^  */
            /*                (((crccode) >> 8) & 0x00FFFFFFL); */
            /*   return(crccode); */

            bool SkipCRC = false;

            OutCount = 0;
            for (i = 0; i < Size; i++)
            {
                cbyte = pBuffer[BufferPtr++];
                c = cbyte;


                if (c == 13 || c == 10)
                {
                }
                else
                {
                    //	if (c<>9)	// Ignore <=9 chars
                    //	{
                    if (SkipCRC == true)
                    {
                        c = (byte)(c - 64);
                        SkipCRC = false;
                    }
                    else
                    {
                        if (c == 61) //'=' Escape character 
                        {
                            SkipCRC = true;
                            //if (c==0) return(2); // Last char cannot be escape char !
                        }
                    }
                    c = (byte)(c - 42);  // Subtract the secret number



                    if (SkipCRC == false)
                    {

                        if (OutCount <= pBufferLength)
                        {
                            pOutBuffer[OutBufferPtr] = (byte)c;
                            OutBufferPtr++;
                            OutCount++;
                        }

                        cc = (byte)(c & 0xff);
                        ch1 = (crc_val ^ cc) & 0xff;
                        ch1 = crc_tab[ch1];
                        ch2 = (crc_val >> 8) & 0xffffff;  // Correct version
                        crc_val = (int)(ch1 ^ ch2);
                        crc_anz++;
                    }
                }
                //	}
            }


            //	crc32=hex_to_ulong((char*)(cp+7));//crc from file
            ad_rescrc = (uint)crc_val ^ 0xFFFFFFFF;// crc from data

            return ad_rescrc;
        }


        public int ReadLine(byte[] pBinaryBuffer,int pBufferSize,ref int pLineCursorPTR,ref int pString)
{
            /*
	unsigned char* BufferPtr;
	unsigned char* OutBufferPtr;
	char* NewString;
	unsigned char Byte1,Byte2;
	int pLineCursor;
	int i;
//94 FB 03 03
      //  string str = "Sushi";
      //  str.append(" Frito");

       //return SysAllocString((BSTR)str.c_str());

	//i=*(BufferPtr+1);
	i=(pBinaryBuffer);
	i=*(unsigned int*)i;
	i=*(unsigned int*) (i+12);
	BufferPtr=(unsigned char*) (i);

	OutBufferPtr=(unsigned char*) *pString;

	pLineCursor= *(pLineCursorPTR);

	i=0;
	Byte2=0;
	while (pLineCursor <pBufferSize)
	{
		Byte1=Byte2;
		Byte2=*(BufferPtr+pLineCursor);

		*(OutBufferPtr+i) = Byte2;
		pLineCursor++;
		i++;
		if (Byte1==13 && Byte2==10) 
		{
			*(pLineCursorPTR)=pLineCursor;
			return 0;
		}
	}

	
	//NewString = new char[100];

	//NewString = "testing here";
	//*pString = (int) NewString;
             * */
	return 1;
}

    }
}
