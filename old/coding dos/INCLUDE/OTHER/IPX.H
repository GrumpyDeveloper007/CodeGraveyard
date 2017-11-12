// IPX implementation by Xavier / Phobia 97
//

struct NetworkAddress
 {
 unsigned char Network[4];
 unsigned char Node[6];
 unsigned short Socket;
 };

struct ECBType
 {
 unsigned short Link[2];
 unsigned short ESR[2];
 unsigned char InUse;
 unsigned char Complete;
 unsigned short Socket;
 unsigned char IPXWork[4];
 unsigned char DWork[12];
 unsigned char ImmedAddr[6];
 unsigned short FragCount;
 unsigned short FragData[2];
 unsigned short FragSize;
 };

struct IPXHeader
 {
 unsigned short Check;
 unsigned short Length;
 unsigned char TC;
 unsigned char PType;
 NetworkAddress Dest;
 NetworkAddress Src;
 };

struct Packet
 {
 ECBType ECB;
 IPXHeader IPX;
 char Data[256];
 };

struct LowMemBlockPacket
 {
 Packet far *PacketP;
 unsigned short PacketSeg,PacketSel;
 unsigned short Socket;
 NetworkAddress ServerAddress;
 };

extern NetworkAddress far *LocalAddress; // The local address...

int InitIPX();
int GetLocalAddress();
void KillIPX();
int OpenSocket(unsigned short Socket);
void CloseSocket(unsigned short Socket);
int AllocatePacket(LowMemBlockPacket *MemPacketP);
void KillPacket(LowMemBlockPacket *MemPacketP);
int ListenForPacket(LowMemBlockPacket *PacketP);
void InitRecievePacket(LowMemBlockPacket *PacketP);
void InitSendPacket(LowMemBlockPacket *PacketP);
int SendPacket(LowMemBlockPacket *PacketP);
