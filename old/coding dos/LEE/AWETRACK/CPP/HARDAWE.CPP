// InitEMU must be called with the AWE32 base address, before any other
// function or a crash will probably ensue... the sound wont work either ;-)
//
// After Init, call ResetEMU to set the audio ready for use!

// WARNING  :  This is not the best method of implementation because of the
//	      high chance of the wrong function etc being used, however it
//	      should be much quicker this way.

#include <i86.h>
#include <conio.h>
#include <fstream.h>

#include "C:\awe\dos\emuinc\emu8000.h"

#define CPF     0	//Data 0
#define PTRX    1
#define CVCF    2
#define VTFT    3
#define PSST    4
#define CSL     5
#define CCCA    6	//Data 1
#define HWCF4   7
#define HWCF5   8
#define HWCF6   9
#define SMALR   10
#define SMARR   11
#define SMALW   12
#define SMARW   13
#define SMLD    14
#define SMRD    15	//Data 2
#define WC      16
#define HWCF1   17	//Data 1
#define HWCF2   18
#define HWCF3   19
#define INIT1   20
#define INIT2   21	//Data 2
#define INIT3   22	//Data 1
#define INIT4   23	//Data 2
#define ENVVOL  24	//Data 1
#define DCYSUSV 25
#define ENVVAL  26
#define DCYSUS  27
#define ATKHLDV 28	//Data 2
#define LFO1VAL 29
#define ATKHLD  30
#define LFO2VAL 31
#define IP      32	//Data 3
#define IFATN   33
#define PEFE    34
#define FMMOD   35
#define TREMFRQ 36
#define FM2FRQ2 37

struct
 {
 short RegNum;    // RegisterNumber (preshifted ready for ORING with channel)
 short Address;   // IO Address (this will be altered by BLASTER ENV E variable
 } EMUReg[38]={
	      {0<<5,0x000},	//Data 0
	      {1<<5,0x000},
	      {2<<5,0x000},
	      {3<<5,0x000},
	      {6<<5,0x000},
	      {7<<5,0x000},
	      {0<<5,0x400},	//Data 1
	      {1<<5,0x400},
	      {1<<5,0x400},
	      {1<<5,0x400},
	      {1<<5,0x400},
	      {1<<5,0x400},
	      {1<<5,0x400},
	      {1<<5,0x400},
	      {1<<5,0x400},
	      {1<<5,0x402},	//Data 2
	      {1<<5,0x402},
	      {1<<5,0x400},	//Data 1
	      {1<<5,0x400},
	      {1<<5,0x400},
	      {2<<5,0x400},
	      {2<<5,0x402},	//Data 2
	      {3<<5,0x400},	//Data 1
	      {3<<5,0x402},	//Data 2
	      {4<<5,0x400},	//Data 1
	      {5<<5,0x400},
	      {6<<5,0x400},
	      {7<<5,0x400},
	      {4<<5,0x402},	//Data 2
	      {5<<5,0x402},
	      {6<<5,0x402},
	      {7<<5,0x402},
	      {0<<5,0x800},	//Data 3
	      {1<<5,0x800},
	      {2<<5,0x800},
	      {3<<5,0x800},
	      {4<<5,0x800},
	      {5<<5,0x800}};

short PointerPort=0x802;  // altered by init routine to BLASTER ENV E value

void InitEMU(int BasePort)	// WARNING CALL ONLY ONCE!!!!!
 {
 PointerPort+=BasePort;

 for (int a=0;a<38;a++)
  EMUReg[a].Address+=BasePort;
 }

void RegSetW(int Channel,int Register,short Value)
 {
 outpw(PointerPort,Channel|EMUReg[Register].RegNum); // set register to use

 outpw(EMUReg[Register].Address,Value);
 }

void RegSetD(int Channel,int Register,long Value)
 {
 outpw(PointerPort,Channel|EMUReg[Register].RegNum); // set register to use

 outpw(EMUReg[Register].Address,Value);       // Double word transfer
 outpw(EMUReg[Register].Address+2,Value>>16);
 }

int RegGetW(int Channel,int Register)
 {
 outpw(PointerPort,Channel|EMUReg[Register].RegNum); // set register to use

 return inpw(EMUReg[Register].Address);
 }

long RegGetD(int Channel,int Register)
 {
 outpw(PointerPort,Channel|EMUReg[Register].RegNum); // set register to use

 return inpw(EMUReg[Register].Address)+(inpw(EMUReg[Register].Address+2)<<16);
 }

void ResetEMU()
 {
 int a;

 RegSetW(29,HWCF1,0x0059);
 RegSetW(30,HWCF2,0x0020);

 for (a=0;a<32;a++)
  RegSetW(a,DCYSUSV,0x0080);

 for (a=0;a<32;a++)
  {
  RegSetW(a,ENVVOL,0);
  RegSetW(a,ENVVAL,0);
  RegSetW(a,DCYSUS,0);
  RegSetW(a,ATKHLDV,0);
  RegSetW(a,LFO1VAL,0);
  RegSetW(a,ATKHLD,0);
  RegSetW(a,LFO2VAL,0);
  RegSetW(a,IP,0);
  RegSetW(a,IFATN,0);
  RegSetW(a,PEFE,0);
  RegSetW(a,FMMOD,0);
  RegSetW(a,TREMFRQ,0);
  RegSetW(a,FM2FRQ2,0);
  RegSetD(a,PTRX,0);
  RegSetD(a,VTFT,0);
  RegSetD(a,PSST,0);
  RegSetD(a,CSL,0);
  RegSetD(a,CCCA,0);
  RegSetD(a,CPF,0);
  RegSetD(a,CVCF,0);
  }

 RegSetD(20,SMALR,0);
 RegSetD(21,SMARR,0);
 RegSetD(22,SMALW,0);
 RegSetD(23,SMARW,0);

 for (a=0;a<32;a++)
  RegSetW(a,INIT1,init1_1[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT2,init1_2[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT3,init1_3[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT4,init1_4[a]);

 delay(24);

 for (a=0;a<32;a++)
  RegSetW(a,INIT1,init2_1[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT2,init2_2[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT3,init2_3[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT4,init2_4[a]);

 delay(24);

 for (a=0;a<32;a++)
  RegSetW(a,INIT1,init3_1[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT2,init3_2[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT3,init3_3[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT4,init3_4[a]);

 RegSetD(9,HWCF4,0);
 RegSetD(10,HWCF5,0x00000083);
 RegSetD(13,HWCF6,0x00008000);

 for (a=0;a<32;a++)
  RegSetW(a,INIT1,init4_1[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT2,init4_2[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT3,init4_3[a]);

 for (a=0;a<32;a++)
  RegSetW(a,INIT4,init4_4[a]);

 RegSetW(31,HWCF3,0x0004);	// Enable audio
 }

void Transfer2Awe(unsigned long Length,short *Sample,unsigned long AweAddress)
 {
 RegSetW(0,DCYSUSV,0x0080);	// prepare chan 0 for write
 RegSetD(0,VTFT,0);
 RegSetD(0,CVCF,0);
 RegSetD(0,PTRX,0x40000000);
 RegSetD(0,CPF,0x40000000);
 RegSetD(0,PSST,0);
 RegSetD(0,CSL,0);
 RegSetD(0,CCCA,0x06000000);
 RegSetD(22,SMALW,AweAddress);

 while((RegGetD(22,SMALW)&0x80000000)==0x80000000); // wait for bit to clear

 for (unsigned long a=0;a<Length;a++)
  {
  RegSetW(26,SMLD,Sample[a]);	// copy sample 1 word at a time :-(
  while((RegGetD(22,SMALW)&0x80000000)==0x80000000); // wait for bit to clear
  }

 while((RegGetD(20,SMALW)&0x80000000)==0x80000000); // wait for bit to clear

 RegSetD(0,CCCA,0);
 }

struct Sample
 {
 unsigned long  AweAddress;	// Address of Sample in AWE RAM
 unsigned long  Length;		// Address of Sample End doubles as loop end!
 unsigned long  Start;		// Address of Loop Start
 unsigned long  NoLoop;         // Address of No Loop Start
 unsigned char  Volume;		// Volume
 char Name[23];                 // Instrument name, (FILENAME FOR NOW)
 };

void TestPlay(Sample *Sample,int Pitch,int Chn)
 {
 RegSetW(Chn,ENVVOL,0x8000);
 RegSetW(Chn,ENVVAL,0x8000);
 RegSetW(Chn,DCYSUS,0x7f7f);
 RegSetW(Chn,ATKHLDV,0x7f7f);
 RegSetW(Chn,LFO1VAL,0x8000);
 RegSetW(Chn,ATKHLD,0x7f7f);
 RegSetW(Chn,LFO2VAL,0x8000);
 RegSetW(Chn,IP,Pitch);          // Pitch
 RegSetW(Chn,PEFE,0);
 RegSetW(Chn,FMMOD,0);
 RegSetW(Chn,TREMFRQ,0x0010);
 RegSetW(Chn,FM2FRQ2,0x0010);

 RegSetD(Chn,PSST,Sample->Start); // loop start
 RegSetD(Chn,CSL,Sample->Length); // loop end
 RegSetD(Chn,CCCA,Sample->AweAddress);    // start

 RegSetD(Chn,VTFT,0x0000ffff);
 RegSetD(Chn,CVCF,0x0000ffff);
 RegSetW(Chn,DCYSUSV,0x7f7f);
 RegSetD(Chn,PTRX,0x40000000);
 RegSetD(Chn,CPF,0x40000000);
 }

// This is used to load in SFBANK General midi bank.
//
//  Its rather crude and very useless, but should be able to load in a
// complete set of addressing information for each of the instruments.

struct SBK		// So far
 {
 char IdentRiff[4];	// ALWAYS "RIFF"
 long FileLength;	// Length of remaining file or total length-8
 char IdentSfbk[8];	// ALWAYS "sfbkLIST"
 long sfbkHeader;	// Length of header (varies)
 };

// Following the header comes

struct SBK2
 {
 char Ident[4]; 	// ALWAYS "LIST"
 long ListLength;	// Length of List stuff (samples etc) (I THINK)
 };

// Following that chunk which contained the sample data too, comes

struct SBK3
 {
 char Ident[4]; 	// ALWAYS "LIST"
 long ListLength;	// Length of List stuff
 char Identpdta[8];	// ALWAYS "pdtaphdr"
 long pdtaLength;	// Length of pdta
 };

SBK Sbk1;
SBK2 Sbk21;
SBK3 Sbk31;

long ConvertNumber(long Number)
 {
 return Number&0xff000000>>24+Number&0xff0000>>8+Number&0xff00<<8+Number&0xff<<24;
 }

int LoadSamples(Sample *Samples,int NumIns) // points to first sample position
 {
 long OldPos;
 int a;

 fstream File1("C:\\sb16\\sfbank\\synthgm.sbk",ios::in|ios::binary);
 if (!File1)
  {
  cerr << "Cant Sound Font Bank File : synthgm.sbk";
  return 0;
  }

 File1.read((unsigned char *)&Sbk1,sizeof(SBK));
 File1.seekg(Sbk1.sfbkHeader,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));
 File1.seekg(Sbk21.ListLength,ios::cur);
 File1.read((unsigned char *)&Sbk31,sizeof(SBK3));
 File1.seekg(Sbk31.pdtaLength,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));
 File1.seekg(Sbk21.ListLength,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));
 File1.seekg(Sbk21.ListLength,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));
 File1.seekg(Sbk21.ListLength,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));

// Get names of instruments

 cout << Sbk21.ListLength/22 << "\n";   // number of instrument names

 if (NumIns>Sbk21.ListLength/22)
  return 0;

 OldPos=File1.tellg();

 for (a=0;a<NumIns;a++)     // loop round till no more instruments
  {
  File1.read((unsigned char *)&Samples[a].Name,22);
  Samples[a].Name[19]='\0';
  }

 File1.seekg(OldPos,ios::beg);
 File1.seekg(Sbk21.ListLength,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));
 File1.seekg(Sbk21.ListLength,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));
 File1.seekg(Sbk21.ListLength,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));
 File1.seekg(Sbk21.ListLength,ios::cur);
 File1.read((unsigned char *)&Sbk21,sizeof(SBK2));
 cout << Sbk21.ListLength/16 << "\n";   // number of instruments

 if (NumIns>Sbk21.ListLength/16)
  return 0;

 long Address;

 for (a=0;a<NumIns;a++)     // loop round till no more instruments
  {
  File1.read((unsigned char *)&Address,sizeof(long));     // read in an address
  Samples->AweAddress=(Address);
  File1.read((unsigned char *)&Address,sizeof(long));     // read in an address
  Samples->Length=(Address);
  File1.read((unsigned char *)&Address,sizeof(long));     // read in an address
  Samples->Start=(Address);
  File1.read((unsigned char *)&Address,sizeof(long));     // read in an address
  Samples->NoLoop=(Address);
  Samples++;    // next sample
  }

 return 1;
 }

