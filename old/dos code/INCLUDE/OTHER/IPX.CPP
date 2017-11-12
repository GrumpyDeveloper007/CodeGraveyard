// IPX routines V1.0
//

#include <i86.h>
#include <string.h>

#include "h\ipx.h"

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

int AllocatePacket(LowMemBlockPacket *MemPacketP)
 {
 union REGS regs;
 struct SREGS sregs;

 // DPMI call 100h allocates DOS memory for VBEINFOBLOCK
 // I use the same memory for the MODEINFOBLOCK and why not?
 memset(&sregs,0,sizeof(sregs));
 regs.w.ax=0x0100;
 regs.w.bx=sizeof(Packet)/16+1;
 int386x( 0x31, &regs, &regs, &sregs);
 if (regs.x.cflag!=0)
  return 1==0;        // not enough memory

 MemPacketP->PacketSeg=regs.w.ax;
 MemPacketP->PacketSel=regs.w.dx;    // Get the information of where the mem block is!

 MemPacketP->PacketP=(Packet far *)MK_FP(MemPacketP->PacketSel,0);
 return 1==1;
 }

void KillPacket(LowMemBlockPacket *MemPacketP)
 {
 union REGS regs;

 // DPMI call 101h deallocates DOS memory
// if (MemPacketP->PacketSel!=0)
//  {
  regs.w.ax=0x0101;
  regs.w.dx=MemPacketP->PacketSel;
  int386(0x31,&regs,&regs);  // FREE MEMORY
//  }
 }

int ListenForPacket(LowMemBlockPacket *PacketP)
 {
 union REGS regs;
 struct SREGS sregs;

 memset(&sregs,0,sizeof(sregs));
 memset(&RMI,0,sizeof(RMI));
 RMI.ESI=0;          // Offset to ECB is 0 when you allocate lowmem...
 RMI.ES=PacketP->PacketSeg;
 RMI.EBX=4;
 RMI.EAX=0;

 // Use DMPI call 300h to issue the DOS interrupt -  God this is awkward
 regs.w.ax = 0x0300;
 regs.h.bl = 0x7a;      
 regs.h.bh = 0;
 regs.w.cx = 0;
 sregs.es = FP_SEG(&RMI);
 regs.x.edi = FP_OFF(&RMI);
 int386x( 0x31, &regs, &regs, &sregs );

 if (RMI.EAX&255)
  return (1==0);
 return (1==1); 
 }

int InitIPX()
 {  
 union REGS regs;
 struct SREGS sregs;

 memset(&sregs,0,sizeof(sregs));
 memset(&RMI,0,sizeof(RMI));
 RMI.EAX=0x7A00; // call IPX INIT

 // Use DMPI call 300h to issue the DOS interrupt -  God this is awkward
 regs.w.ax = 0x0300;
 regs.h.bl = 0x2f;      // video services
 regs.h.bh = 0;
 regs.w.cx = 0;
 sregs.es = FP_SEG(&RMI);
 regs.x.edi = FP_OFF(&RMI);
 int386x( 0x31, &regs, &regs, &sregs );

 if ((RMI.EAX&255)!=255)
  return (1==0);
 return (1==1);
 }

NetworkAddress far *LocalAddress; // The local address...
short LAddressSegment;
short LAddressSelector=0;

int GetLocalAddress()
 {
 union REGS regs;
 struct SREGS sregs;

 // DPMI call 100h allocates DOS memory for VBEINFOBLOCK
 // I use the same memory for the MODEINFOBLOCK and why not?
 memset(&sregs,0,sizeof(sregs));
 regs.w.ax=0x0100;
 regs.w.bx=sizeof(NetworkAddress)/16+1;
 int386x( 0x31, &regs, &regs, &sregs);
 if (regs.x.cflag!=0)
  return 1==0;        // not enough memory

 LAddressSegment=regs.w.ax;
 LAddressSelector=regs.w.dx;    // Get the information of where the mem block is!

 LocalAddress=(NetworkAddress far *)MK_FP(LAddressSelector,0);

 memset(&sregs,0,sizeof(sregs));
 memset(&RMI,0,sizeof(RMI));

 RMI.EBX=9; // call IPX INIT
 RMI.ES=LAddressSegment;
 RMI.ESI=0;

 // Use DMPI call 300h to issue the DOS interrupt -  God this is awkward
 regs.w.ax = 0x0300;
 regs.h.bl = 0x7a;      
 regs.h.bh = 0;
 regs.w.cx = 0;
 sregs.es = FP_SEG(&RMI);
 regs.x.edi = FP_OFF(&RMI);
 int386x( 0x31, &regs, &regs, &sregs );

 return (1==1);
 }

void KillIPX()
 {
 union REGS regs;

 // DPMI call 101h deallocates DOS memory
 if (LAddressSelector!=0)
  {
  regs.w.ax=0x0101;
  regs.w.dx=LAddressSelector;
  int386(0x31,&regs,&regs);  // FREE MEMORY
  }
 }

unsigned short SwapHiLo(unsigned short SwapMe)
 {
 // swap the low and high order byte of a word...
 return (SwapMe<<8)+((SwapMe&65280)>>8);
 }

int OpenSocket(unsigned short Socket)
 {
 union REGS regs;
 struct SREGS sregs;
 // Open up a socket.. Returns true if everything went fine..

 //Set up real-mode call structure
 memset(&sregs,0,sizeof(sregs));
 memset(&RMI,0,sizeof(RMI));

 RMI.EBX=0;
 RMI.EAX=0;             // 1 would indicate do not close on quit... not likely!
 RMI.EDX=SwapHiLo(Socket);

 // Use DMPI call 300h to issue the DOS interrupt -  God this is awkward
 regs.w.ax = 0x0300;
 regs.h.bl = 0x7a;      
 regs.h.bh = 0;
 regs.w.cx = 0;
 sregs.es = FP_SEG(&RMI);
 regs.x.edi = FP_OFF(&RMI);
 int386x( 0x31, &regs, &regs, &sregs );

 if (SwapHiLo(RMI.EDX)!=Socket)
  return (1==0);        // Socket does not match error ?
  
 if ((unsigned char)(RMI.EAX)==0)
  return (1==1);
 return (1==0);
 }

void CloseSocket(unsigned short Socket)
 {
 union REGS regs;
 struct SREGS sregs;
 // Closes an open socket.. Do not forget to call this routine!!

 memset(&sregs,0,sizeof(sregs));
 memset(&RMI,0,sizeof(RMI));
 RMI.EBX=0x1;
 RMI.EDX=SwapHiLo(Socket);

 // Use DMPI call 300h to issue the DOS interrupt -  God this is awkward
 regs.w.ax = 0x0300;
 regs.h.bl = 0x7a;      
 regs.h.bh = 0;
 regs.w.cx = 0;
 sregs.es = FP_SEG(&RMI);
 regs.x.edi = FP_OFF(&RMI);
 int386x( 0x31, &regs, &regs, &sregs );
 }

void InitRecievePacket(LowMemBlockPacket *PacketP)
 {
 _fmemset(PacketP->PacketP,0,sizeof(Packet));

 PacketP->PacketP->ECB.InUse=0x1d;
 PacketP->PacketP->ECB.Socket=SwapHiLo(PacketP->Socket);
 PacketP->PacketP->ECB.FragCount=1;
 PacketP->PacketP->ECB.FragData[0]=sizeof(ECBType);

 PacketP->PacketP->ECB.FragData[1]=PacketP->PacketSeg;
  
 PacketP->PacketP->ECB.FragSize=sizeof(Packet)-sizeof(ECBType);
 ListenForPacket(PacketP);
 }

void InitSendPacket(LowMemBlockPacket *PacketP)
 {
 _fmemset(PacketP->PacketP,0,sizeof(Packet));
  
 PacketP->PacketP->ECB.Socket=SwapHiLo(PacketP->Socket);
 PacketP->PacketP->ECB.FragCount=1;
 PacketP->PacketP->ECB.FragData[0]=sizeof(ECBType);
 PacketP->PacketP->ECB.FragData[1]=PacketP->PacketSeg;
 PacketP->PacketP->ECB.FragSize=sizeof(Packet)-sizeof(ECBType);

 PacketP->PacketP->ECB.ImmedAddr[0]=0xff;
 PacketP->PacketP->ECB.ImmedAddr[1]=0xff;
 PacketP->PacketP->ECB.ImmedAddr[2]=0xff;
 PacketP->PacketP->ECB.ImmedAddr[3]=0xff;
 PacketP->PacketP->ECB.ImmedAddr[4]=0xff;
 PacketP->PacketP->ECB.ImmedAddr[5]=0xff;
 PacketP->PacketP->IPX.Dest.Node[0]=0xff;
 PacketP->PacketP->IPX.Dest.Node[1]=0xff;
 PacketP->PacketP->IPX.Dest.Node[2]=0xff;
 PacketP->PacketP->IPX.Dest.Node[3]=0xff;
 PacketP->PacketP->IPX.Dest.Node[4]=0xff;
 PacketP->PacketP->IPX.Dest.Node[5]=0xff;

 PacketP->PacketP->IPX.Check=0xffff;
 PacketP->PacketP->IPX.PType=0x00;
 PacketP->PacketP->IPX.Dest.Network[0]=0x00;
 PacketP->PacketP->IPX.Dest.Network[1]=0x00;
 PacketP->PacketP->IPX.Dest.Network[2]=0x00;
 PacketP->PacketP->IPX.Dest.Network[3]=0x00;
 PacketP->PacketP->IPX.Dest.Socket=SwapHiLo(PacketP->Socket);
 PacketP->PacketP->IPX.Src.Network[0]=LocalAddress->Network[0];
 PacketP->PacketP->IPX.Src.Network[1]=LocalAddress->Network[1];
 PacketP->PacketP->IPX.Src.Network[2]=LocalAddress->Network[2];
 PacketP->PacketP->IPX.Src.Network[3]=LocalAddress->Network[3];
 PacketP->PacketP->IPX.Src.Node[0]=LocalAddress->Node[0];
 PacketP->PacketP->IPX.Src.Node[1]=LocalAddress->Node[1];
 PacketP->PacketP->IPX.Src.Node[2]=LocalAddress->Node[2];
 PacketP->PacketP->IPX.Src.Node[3]=LocalAddress->Node[3];
 PacketP->PacketP->IPX.Src.Node[4]=LocalAddress->Node[4];
 PacketP->PacketP->IPX.Src.Node[5]=LocalAddress->Node[5];
 PacketP->PacketP->IPX.Src.Socket=SwapHiLo(PacketP->Socket);
 }

int SendPacket(LowMemBlockPacket *PacketP)
 {
 union REGS regs;
 struct SREGS sregs;

 int q;
 memset(&sregs,0,sizeof(sregs));
 memset(&RMI,0,sizeof(RMI));

 for (q=0;q<4;q++)
  PacketP->PacketP->IPX.Dest.Network[q]=PacketP->ServerAddress.Network[q];
 for (q=0;q<6;q++)
  PacketP->PacketP->ECB.ImmedAddr[q]=PacketP->PacketP->IPX.Dest.Node[q]=PacketP->ServerAddress.Node[q];
      
 RMI.ESI=0;
 RMI.ES=PacketP->PacketSeg;
 RMI.EBX=3;

 // Use DMPI call 300h to issue the DOS interrupt -  God this is awkward
 regs.w.ax = 0x0300;
 regs.h.bl = 0x7a;      
 regs.h.bh = 0;
 regs.w.cx = 0;
 sregs.es = FP_SEG(&RMI);
 regs.x.edi = FP_OFF(&RMI);
 int386x( 0x31, &regs, &regs, &sregs );

 if (RMI.EAX&255)
  return (1==0);
 return (1==1);
 }

                              
