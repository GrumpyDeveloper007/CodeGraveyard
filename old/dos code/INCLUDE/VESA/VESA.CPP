// At present this entire library is a complete cock up.. SORRY
//
//  SVGA modes are not double buffered .... yet
//  Access to SVGA screen is via FS  .. so ensure compiler does not use it!

/*
  VESA 2.0+ Compatable Screen Routines (Simple PMode Interface)

  Design, Code & Effort By Xavier / Phobia '96

 Example of setting mode to 320*200*256  :

    ModeToSet.NumberOfPlanes=1;
    ModeToSet.BitsPerPixel=8;
    ModeToSet.XResolution=320;
    ModeToSet.YResolution=200;
    ModeToSet.MemoryModel=MODEL_PACKED;
    SetVideo(&ModeToSet);

 Example of setting mode to 320*200*8:8:8:8

    ModeToSet.NumberOfPlanes=1;
    ModeToSet.BitsPerPixel=32;
    ModeToSet.XResolution=320;
    ModeToSet.YResolution=200;
    ModeToSet.MemoryModel=MODEL_DIRECT;
    ModeToSet.RedMaskSize=8;
    ModeToSet.GreenMaskSize=8;
    ModeToSet.BlueMaskSize=8;
    ModeToSet.RsvdMaskSize=8;
    SetVideo(&ModeToSet);

 TO DO :

        Add linked list rather than static 200 element storage for mode
       numbers.
        Add VESA Set palette routine ? Currently uses standard VGA Ports.


  Please note that at present there is no longer a fallback to VGA mode if
 VESA cannot be used. If this is required I advise writing the fallback
 code yourself.

  This, once finalised, will be part of the Xavier library. It will be
 used to initialise all screen code. The following functions are created
 to allow use of this new include. The SetVideo() routine assumes that
 the user is trying to open a colour graphics screen with a linear
 frame buffer in packed pixel mode.


 WARNING : FS will point to the selector for the screen, ensure that the
          compiler does not use FS in its code. (DEFAULT WITH WATCOM).

   InitVESA()        // call this first it checks for VESA 2.0 and gets
                     // a local copy of the available mode numbers.
                     // if it returns false then VESA is not available.

   SetVideo(ModeInfoBlock)
                     // This function actually puts the video card into
                     // the specified mode if one can be found. Otherwise
                     // the function returns false. It only allows switching
                     // to Linear Frame Buffer Modes! This function also
                     // sets up the descriptor and FS for this screen.
                     // DO NOT set the video mode using any other method!!!
                     // If this call fails and you where in a previous
                     // video mode you MUST re call the function to
                     // continue using the function. (SORRY)

   KillVESA()        // Returns the video into the state it was in when
                     // InitVESA() was called. Also deallocates any
                     // descriptors etc. that may have been initialised.
*/

#include <i86.h>
#include <conio.h>
#include <string.h>

// The following is for access to stuff in <1MEG area!!!!

#define RealModeToProtected(x) (((((x)&0xffff0000)>>12)+((x)&0xffff)))

unsigned char *VESAScreenPtr=0;
unsigned char *VESAVirtualScreen=0;
int VESAScreenLength=0;
int VESAScreenY,VESAVirtualY;

void SetupFS(long selector);    // loads FS with selector to screen mem!
#pragma aux SetupFS = \
           "mov fs,ax" \
           parm caller [eax];

static struct rminfo
 {
 long EDI;
 long ESI;
 long EBP;
 long reserved_by_system;
 long EBX;
 long EDX;
 long ECX;
 long EAX;
 short flags;
 short ES,DS,FS,GS,IP,CS,SP,SS;
 } RMI;

struct VbeInfoBlock
 {
 char VESA[4];
 short Version;
 long OEMString;
 unsigned char Capabilities[4];
 long VideoModePtr;
 short TotalMemory;
 short SoftwareRevision;
 long VenderName;
 long ProductName;
 long ProductRevision;
 char Reserved[222];
 char OEMData[256];
 };

struct ModeInfoBlock
 {
 short ModeAttributes;
 char WinAAttributes;
 char WinBAttributes;
 short WinGranularity;
 short WinSize;
 short WinASegment;
 short WinBSegment;
 long WinFuncPtr;
 short BytesPerScanLine;
 short XResolution;
 short YResolution;
 char XCharSize;
 char YCharSize;
 char NumberOfPlanes;
 char BitsPerPixel;
 char NumberOfBanks;
 char MemoryModel;
 char BankSize;
 char NumberOfImagePages;
 char Reserved;
 char RedMaskSize;
 char RedFieldPosition;
 char GreenMaskSize;
 char GreenFieldPosition;
 char BlueMaskSize;
 char BlueFieldPosition;
 char RsvdMaskSize;
 char RsvdFieldPosition;
 char DirectColorModeInfo;
 long PhysBasePtr;
 long OffScreenMemOffset;
 short OffScreenMemSize;
 char ReservedEnd[206];
 };

ModeInfoBlock VESAModeInfo;     // Global for user to view
VbeInfoBlock far *Info;
ModeInfoBlock far *ModeInfo;
int VESANumModes;
short VESAAvailModes[200];  // Crappy static storage
short DOSSelector;
short DOSSegment;
short OldMode;
long LinearAddress;
short LinearSelector;  // Selector to the linear frame buffer
short Num64Ks;          // Number of blocks of 64k for video memory

int InitVESA()  // Gets all available VESA modes and bungs em in a table
 {              // returns false if VESA not supported!
 union REGS regs;
 struct SREGS sregs;
 short num=0;
 short *ModeList;

 LinearAddress=0;       // Ensure empty before we begin
 LinearSelector=0;

 regs.x.eax = 0x4f03;
 regs.x.edx = 0;
 regs.x.ecx = 0xf;
 int386(0x10,&regs,&regs);
 if ((regs.x.eax&0xff)!=0x4f)
  return 1==0;
 OldMode=regs.w.bx;

 // DPMI call 100h allocates DOS memory for VBEINFOBLOCK
 // I use the same memory for the MODEINFOBLOCK and why not?
 memset(&sregs,0,sizeof(sregs));
 regs.w.ax=0x0100;
 regs.w.bx=sizeof(VbeInfoBlock)/16+1;
 int386x( 0x31, &regs, &regs, &sregs);
 if (regs.x.cflag!=0)
  return 1==0;        // not enough memory

 DOSSegment=regs.w.ax;
 DOSSelector=regs.w.dx;    // Get the information of where the mem block is!

 Info=(VbeInfoBlock far *)MK_FP(DOSSelector,0);
 ModeInfo=(ModeInfoBlock far *)MK_FP(DOSSelector,0);

 Info->VESA[0]='V';      // We want information for VESA 2.0 and above
 Info->VESA[1]='B';
 Info->VESA[2]='E';
 Info->VESA[3]='2';

 // Set up real-mode call structure
 memset(&RMI,0,sizeof(RMI));
 RMI.EAX=0x00004f00; // call service 4fh ah=0x4f  GET VESA INFO
 RMI.ES=DOSSegment;     // put DOS seg:off into ES:DI
 RMI.EDI=0;          // DOS ignores EDI high word

 // Use DMPI call 300h to issue the DOS interrupt -  God this is awkward
 regs.w.ax = 0x0300;
 regs.h.bl = 0x10;      // video services
 regs.h.bh = 0;
 regs.w.cx = 0;
 sregs.es = FP_SEG(&RMI);
 regs.x.edi = FP_OFF(&RMI);
 int386x( 0x31, &regs, &regs, &sregs );

 if (Info->VESA[0]!='V' || Info->VESA[1]!='E' ||
     Info->VESA[2]!='S' || Info->VESA[3]!='A' ||
     (RMI.EAX&0xff)!=0x4f)
  return 1==0;          // VESA 2.0+ not supported

 if (Info->Version<0x0200)
  return 1==0;          // VESA Version < 2.0

 Num64Ks=Info->TotalMemory;     // Total Memory of video card

 VESANumModes=0;
 ModeList=(short *)RealModeToProtected(Info->VideoModePtr);
 num=*ModeList;
 while (ModeList!=NULL && num!=-1)      // Get list of Modes Available on card
  {
  ModeList++;
  VESAAvailModes[VESANumModes]=num;
  VESANumModes++;
  num=*ModeList;
  }

 return 1==1;
 }

void CloseVideo()
 {
 union REGS regs;

 if (LinearAddress!=0)
  {
  regs.x.eax = 0x801;
  regs.x.ebx = (LinearAddress>>16)&0xffff;
  regs.x.ecx = (LinearAddress)&0xffff;
  int386(0x31,&regs,&regs);            // Free physical mapping
  LinearAddress=0;
  }

 if (LinearSelector!=0)
  {
  regs.x.eax = 1;
  regs.x.ebx = LinearSelector;
  int386(0x31,&regs,&regs);            // Free Local Descriptor
  LinearSelector=0;
  }
 }

void KillVESA()
 {
 union REGS regs;

 CloseVideo();  // Release stuff allocated for video mode if active

 regs.x.eax = 0x4f02;
 regs.x.ebx = OldMode;
 int386( 0x10, &regs, &regs);         // Set VBE mode

 // DPMI call 101h deallocates DOS memory for VBEINFOBLOCK
 regs.w.ax=0x0101;
 regs.w.dx=DOSSelector;
 int386(0x31,&regs,&regs);  // FREE MEMORY
 }

int SetVideo(ModeInfoBlock *RequestedMode)
 {                      // set video mode, returns false if mode not found
 union REGS regs;
 struct SREGS sregs;

 CloseVideo();  // Ensure old video mode is deallocated

 for (int a=0;a<VESANumModes;a++)
  {
  // Set up real-mode call structure for get mode info
  memset(&sregs,0,sizeof(sregs));
  memset(&RMI,0,sizeof(RMI));
  RMI.EAX=0x00004f01; // call service 4fh ah=0x4f  GET VESA MODE INFO
  RMI.ES=DOSSegment;     // put DOS seg:off into ES:DI
  RMI.EDI=0;          // DOS ignores EDI high word
  RMI.ECX=VESAAvailModes[a];          // mode we want info on

  // Use DMPI call 300h to issue the DOS interrupt -  God this is awkward
  regs.w.ax = 0x0300;
  regs.h.bl = 0x10;      // video services
  regs.h.bh = 0;
  regs.w.cx = 0;
  sregs.es = FP_SEG(&RMI);
  regs.x.edi = FP_OFF(&RMI);
  int386x( 0x31, &regs, &regs, &sregs );

  if ((RMI.EAX&0xff)!=0x4f)
   return 1==0;

  if (((ModeInfo->ModeAttributes&0x80)==0x80) &&    // Linear frame buffer
      ((ModeInfo->ModeAttributes&0x10)==0x10) &&    // graphic mode
      ((ModeInfo->ModeAttributes&0x01)==0x01) &&    // mode available
      ((ModeInfo->ModeAttributes&0x08)==0x08) &&    // colour mode
      ((ModeInfo->NumberOfPlanes==RequestedMode->NumberOfPlanes)) &&
      ((ModeInfo->BitsPerPixel==RequestedMode->BitsPerPixel)) &&
      ((ModeInfo->XResolution==RequestedMode->XResolution)) &&
      ((ModeInfo->YResolution==RequestedMode->YResolution)) &&
      ((ModeInfo->MemoryModel==RequestedMode->MemoryModel)))
   {
   if ((ModeInfo->MemoryModel==6 &&      // Direct colour so need mask bits!
       ModeInfo->RedMaskSize==RequestedMode->RedMaskSize &&
       ModeInfo->GreenMaskSize==RequestedMode->GreenMaskSize &&
       ModeInfo->BlueMaskSize==RequestedMode->BlueMaskSize &&
       ModeInfo->RsvdMaskSize==RequestedMode->RsvdMaskSize) ||
       ModeInfo->MemoryModel!=6)
    {           // Mode is one requested I think

    // Allocate a descriptor for the LDT (This is where Pmode nightmares occur)

    regs.x.eax = 0;
    regs.x.ecx = 1;
    int386(0x31,&regs,&regs);            // Allocate Local Descriptor
    LinearSelector=regs.w.ax;            // Get selector to linear frame buffer

    regs.x.eax = 0x800;
    regs.x.ebx = ((ModeInfo->PhysBasePtr)>>16)&0xffff;
    regs.x.ecx = (ModeInfo->PhysBasePtr)&0xffff;
    regs.w.si = 0x003f;
    regs.w.di = 0xffff;
    int386(0x31,&regs,&regs);            // Get linear address from physical
    LinearAddress=((regs.w.bx<<16)&0xffff0000)+(regs.w.cx&0xffff);

    regs.x.eax = 7;
    regs.x.ecx = (LinearAddress>>16)&0xffff;  // start address of screen (frame buffer)
    regs.x.edx = (LinearAddress)&0xffff;
    regs.x.ebx = LinearSelector;
    int386(0x31,&regs,&regs);            // Set descriptor base address

    regs.x.eax = 8;
    regs.x.ecx = Num64Ks-1;         // CX:DX = limit of selector
    regs.x.edx = 0xffff;          // 64K limit
    regs.x.ebx = LinearSelector;
    int386(0x31,&regs,&regs);            // Set descriptor limit

    regs.x.eax = 0x4f02;
    regs.x.ebx = VESAAvailModes[a]|0xC000;
    int386( 0x10, &regs, &regs);         // Set VBE mode

    SetupFS(LinearSelector);

    VESAScreenPtr=0;                    // offset from FS to screen
    VESAScreenLength=(ModeInfo->BytesPerScanLine*ModeInfo->YResolution)/4;
    VESAVirtualScreen=VESAScreenPtr+VESAScreenLength*4;
    VESAScreenY=0;
    VESAVirtualY=ModeInfo->YResolution;

    return 1==1;        // mode set
    }
   }
  }
 return 1==0;   // could not set up mode
 }

void VESAUpdateScreen()         // Miles faster than VGA update due to
 {                              // display swapping - This could be made
 unsigned char *TempSwap;       // faster still by using direct calls
 TempSwap=VESAScreenPtr;        // rather than BIOS.
 VESAScreenPtr=VESAVirtualScreen;
 VESAVirtualScreen=TempSwap;    // Screen now swapped for drawing
 int Temp;
 Temp=VESAScreenY;
 VESAScreenY=VESAVirtualY;
 VESAVirtualY=Temp;

 union REGS regs;

 regs.x.eax = 0x4f07;
 regs.x.ebx = 0x80;        // NB bit 7 could be set to swap at vert retrace!
 regs.x.ecx = 0;
 regs.x.edx = VESAScreenY;
 int386( 0x10, &regs, &regs);         // Set Scan Line Start
 }

void VESACLSMem()      // Uses computer memory for virtual screen
 {                     
 unsigned long *VirtualPtr=(unsigned long *)VESAVirtualScreen;

 for (int a=0;a<VESAScreenLength;a++)
  *VirtualPtr++=0;
 }

