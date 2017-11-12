using System;
using System.Runtime.InteropServices;
using System.Text;
using Microsoft.Win32;
using System.Collections;
using System.Windows.Forms;
using System.Security.Permissions;

namespace MyClasses
{

	public class Packet32h
	{

		// Working modes
		public static uint PACKET_MODE_CAPT  = 0x0; ///< Capture mode
		public static uint PACKET_MODE_STAT  = 0x1; ///< Statistical mode
		public static uint PACKET_MODE_DUMP  = 0x10; ///< Dump mode
		 ///< Statistical dump Mode
		public static uint PACKET_MODE_STAT_DUMP = PACKET_MODE_DUMP | PACKET_MODE_STAT;

		// ioctls
		public static uint FILE_DEVICE_PROTOCOL        = 0x8000;
		public static uint IOCTL_PROTOCOL_QUERY_OID    = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 0 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);
		public static uint IOCTL_PROTOCOL_SET_OID      = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 1 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);
		public static uint IOCTL_PROTOCOL_STATISTICS   = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 2 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);
		public static uint IOCTL_PROTOCOL_RESET        = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 3 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);
		public static uint IOCTL_PROTOCOL_READ         = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 4 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);
		public static uint IOCTL_PROTOCOL_WRITE        = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 5 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);
		public static uint IOCTL_PROTOCOL_MACNAME      = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 6 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);
		public static uint IOCTL_OPEN                  = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 7 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);
		public static uint IOCTL_CLOSE                 = DeviceIOCtlh.CTL_CODE(FILE_DEVICE_PROTOCOL, 8 , DeviceIOCtlh.METHOD_BUFFERED, DeviceIOCtlh.FILE_ANY_ACCESS);

		///< IOCTL code: set kernel buffer size.
		public static uint 	pBIOCSETBUFFERSIZE = 9592;
		///< IOCTL code: set packet filtering program.
		public static uint 	pBIOCSETF = 9030;
		///< IOCTL code: get the capture stats.
		public static uint  pBIOCGSTATS = 9031;
		///< IOCTL code: set the read timeout.
		public static uint 	pBIOCSRTIMEOUT = 7416;
		///< IOCTL code: set working mode.
		public static uint 	pBIOCSMODE = 7412;
		///< IOCTL code: set number of physical repetions of every packet written by the app.
		public static uint 	pBIOCSWRITEREP = 7413;
		///< IOCTL code: set minimum amount of data in the kernel buffer that unlocks a read call.
		public static uint 	pBIOCSMINTOCOPY = 7414;
		///< IOCTL code: set an OID value.
		public static uint 	pBIOCSETOID = 2147483648;
		///< IOCTL code: get an OID value.
		public static uint 	pBIOCQUERYOID = 2147483652;
		///< IOCTL code: attach a process to the driver. Used in Win9x only.
		public static uint 	pATTACHPROCESS = 7117;
		///< IOCTL code: detach a process from the driver. Used in Win9x only.
		public static uint 	pDETACHPROCESS = 7118;
		///< IOCTL code: set the name of a the file used by kernel dump mode.
		public static uint  pBIOCSETDUMPFILENAME = 9029;
		///< IOCTL code: get the name of the event that the driver signals when some data is present in the buffer.
		public static uint  pBIOCEVNAME = 7415;
		///< IOCTL code: Send a buffer containing multiple packets to the network, ignoring the timestamps associated with the packets.
		public static uint  pBIOCSENDPACKETSNOSYNC = 9032;
		///< IOCTL code: Send a buffer containing multiple packets to the network, respecting the timestamps associated with the packets.
		public static uint  pBIOCSENDPACKETSSYNC = 9033;
		///< IOCTL code: Set the dump file limits. See the PacketSetDumpLimits() function.
		public static uint  pBIOCSETDUMPLIMITS = 9034;
		///< IOCTL code: Get the status of the kernel dump process. See the PacketIsDumpEnded() function.
		public static uint  pBIOCISDUMPENDED = 7411;
		///< IOCTL code: set time zone. Used in Win9x only.
		public static uint   pBIOCSTIMEZONE = 7471;

		public static uint GMEM_MOVEABLE = 0x2;
		public static uint GMEM_ZEROINIT = 0x40;
		public static uint GHND = (GMEM_MOVEABLE | GMEM_ZEROINIT);
		public static uint GMEM_STANDARD = (GMEM_MOVEABLE | GMEM_ZEROINIT);

		public static uint ERROR_ALREADY_EXISTS = 183;
		public static uint INFINITE = 0xFFFF;

		public static uint MOVEFILE_REPLACE_EXISTING = 0x1;
		public static uint FILE_ATTRIBUTE_TEMPORARY = 0x100;
		public static uint FILE_BEGIN = 0;
		public static uint FILE_SHARE_READ = 0x1;
		public static uint FILE_SHARE_WRITE = 0x2;
		public static uint CREATE_NEW = 1;
		public static uint OPEN_EXISTING = 3;
		public static uint GENERIC_READ = 0x80000000;
		public static uint GENERIC_WRITE = 0x40000000;

		public const int NDIS_PACKET_TYPE_DIRECTED				= 0x0001;
		public const int NDIS_PACKET_TYPE_MULTICAST				= 0x0002;
		public const int NDIS_PACKET_TYPE_ALL_MULTICAST			= 0x0004;
		public const int NDIS_PACKET_TYPE_BROADCAST				= 0x0008;
		public const int NDIS_PACKET_TYPE_SOURCE_ROUTING		= 0x0010;
		public const int NDIS_PACKET_TYPE_PROMISCUOUS			= 0x0020;
		public const int NDIS_PACKET_TYPE_SMT					= 0x0040;
		public const int NDIS_PACKET_TYPE_ALL_LOCAL				= 0x0080;
		public const int NDIS_PACKET_TYPE_GROUP					= 0x1000;
		public const int NDIS_PACKET_TYPE_ALL_FUNCTIONAL		= 0x2000;
		public const int NDIS_PACKET_TYPE_FUNCTIONAL			= 0x4000;
		public const int NDIS_PACKET_TYPE_MAC_FRAME				= 0x8000;
		

		public static uint Packet_ALIGNMENT = 4; //sizeof(int);
		public static uint AF_INET = 2; //internetwork: UDP, TCP, etc.

		public struct LARGE_INTEGER		{			public long LowPart; // long			public long HighPart; // long		}
		public struct ADAPTERINFO
		{
			public int SupportedList;
			public int HardwareStatus;
			public string HardwareStatusStr;
			public int MediaSupported;
			public int MediaInUse;
			public string MediaInUseStr;
			public int MaximumLookAhead;
			public int MaximumFrameSize;
			public int LinkSpeed;
			public int TransmitBufferSpace;
			public int ReceiveBufferSpace;
			public int TransmitBlockSize;
			public int ReceiveBlockSize;
			public int VendorId;
			public string VendorDescription;
			public int CurrentPacketFilter;
			public string CurrentPacketFilterStr;
			public int CurrentLookAhead;
			public int DriverVersion;
			public int MaximumTotalSize;
			public int ProtocolOptions;
			public string ProtocolOptionsStr;
			public int MacOptions;
			public string MacOptionsStr;
			public int MediaConnectStatus;
			public string MediaConnectStatusStr;
			public int MaximumSendPackets;
			public int VendorDriverVersion;
			public int XmitOk;
			public int RcvOk;
			public int XmitError;
			public int RcvError;
			public int RcvNoBuffer;
			public int DirectedBytesXmit;
			public int DirectedFramesXmit;
			public int MulticastBytesXmit;
			public int MulticastFramesXmit;
			public int BroadcastBytesXmit;
			public int BroadcastFramesXmit;
			public int DirectedBytesRcv;
			public int DirectedFramesRcv;
			public int MulticastBytesRcv;
			public int MulticastFramesRcv;
			public int BroadcastBytesRcv;
			public int BroadcastFramesRcv;
			public int RcvCrcError;
			public int TransmitQueueLength;
			public int TimeCaps;
			public string TimeCapsStr;
			public int NetCardTime;
			public int TransportHeaderOffset;
			public int PhysicalMedium;
			public int NetworkLayerAddress;
			public int MediaSenseCount;
			public int MediaCapabilities;
			public int InitTimeMs;
			public string FriendlyName;
			public int SupportedGuids;
			public int NetCardLoad;
			public int DeviceProfile;

		}


		public struct ADAPTERINFO_STR
		{
			public string SupportedList;
			public string HardwareStatus;
			public string HardwareStatusStr;
			public string MediaSupported;
			public string MediaInUse;
			public string MediaInUseStr;
			public string MaximumLookAhead;
			public string MaximumFrameSize;
			public string LinkSpeed;
			public string TransmitBufferSpace;
			public string ReceiveBufferSpace;
			public string TransmitBlockSize;
			public string ReceiveBlockSize;
			public string VendorId;
			public string VendorDescription;
			public string CurrentPacketFilter;
			public string CurrentPacketFilterStr;
			public string CurrentLookAhead;
			public string DriverVersion;
			public string MaximumTotalSize;
			public string ProtocolOptions;
			public string ProtocolOptionsStr;
			public string MacOptions;
			public string MacOptionsStr;
			public string MediaConnectStatus;
			public string MediaConnectStatusStr;
			public string MaximumSendPackets;
			public string VendorDriverVersion;
			public string XmitOk;
			public string RcvOk;
			public string XmitError;
			public string RcvError;
			public string RcvNoBuffer;
			public string DirectedBytesXmit;
			public string DirectedFramesXmit;
			public string MulticastBytesXmit;
			public string MulticastFramesXmit;
			public string BroadcastBytesXmit;
			public string BroadcastFramesXmit;
			public string DirectedBytesRcv;
			public string DirectedFramesRcv;
			public string MulticastBytesRcv;
			public string MulticastFramesRcv;
			public string BroadcastBytesRcv;
			public string BroadcastFramesRcv;
			public string RcvCrcError;
			public string TransmitQueueLength;
			public string TimeCaps;
			public string TimeCapsStr;
			public string NetCardTime;
			public string TransportHeaderOffset;
			public string PhysicalMedium;
			public string NetworkLayerAddress;
			public string MediaSenseCount;
			public string MediaCapabilities;
			public string InitTimeMs;
			public string FriendlyName;
			public string SupportedGuids;
			public string NetCardLoad;
			public string DeviceProfile;

		}


		public const int WSADESCRIPTION_LEN = 256;
		public const int WSASYS_STATUS_LEN  = 128;

		public struct WSADATA 
		{
			public int wVersion;
			public int wHighVersion;
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=WSADESCRIPTION_LEN+1)] public char [] szDescription;
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=WSASYS_STATUS_LEN+1)] public char [] szSystemStatus;
			public ushort iMaxSockets;
			public ushort iMaxUdpDg;
			public IntPtr lpVendorInfo;
		}

		public struct NETTYPE
		{
			///< The MAC of the current network adapter (see function PacketGetNetType() for more information)
			public uint LinkType;
			///< The speed of the network in bits per second
			public uint LinkSpeed;
		};

		public struct PNETTYPE
		{
			public uint LinkType;
			public uint LinkSpeed;
		};

		//brief A BPF pseudo-assembly program.
		//The program will be injected in the kernel by the PacketSetBPF() function and applied to every incoming packet.
		public struct PBPF_PROGRAM
		{
			///< Indicates the number of instructions of the program, 
			///i.e. the number of struct bpf_insn that will follow.
			public uint bf_len;
			///< A pointer to the first instruction of the program.
			public int bf_insns;
		};

		public struct BPF_PROGRAM
		{
			public uint bf_len;
			public int bf_insns;
		};

		public struct BPF_INSN
		{
			public ushort code;	///< Instruction type and addressing mode.
			public byte jt;		///< Jump if true
			public byte jf;		///< Jump if false
			public int k;		///< Generic field used for various purposes.
		};

		public struct PBPF_INSN
		{
			public ushort code;
			public byte jt;
			public byte jf;
			public int k;
		};

		public struct BPF_STAT
		{
			public uint bs_recv;		///< Number of packets that the driver received from the network adapter 
			///< from the beginning of the current capture. This value includes the packets 
			///< lost by the driver.
			public uint bs_drop;		///< number of packets that the driver lost from the beginning of a capture. 
			///< Basically, a packet is lost when the the buffer of the driver is full. 
			///< In this situation the packet cannot be stored and the driver rejects it.
			public uint ps_ifdrop;		///< drops by interface. XXX not yet supported
			public uint bs_capt;		///< number of packets that pass the filter, find place in the kernel buffer and
			///< thus reach the application.
		};

		public struct PBPF_STAT
		{
			public uint bs_recv;		///< Number of packets that the driver received from the network adapter 
			///< from the beginning of the current capture. This value includes the packets 
			///< lost by the driver.
			public uint bs_drop;		///< number of packets that the driver lost from the beginning of a capture. 
			///< Basically, a packet is lost when the the buffer of the driver is full. 
			///< In this situation the packet cannot be stored and the driver rejects it.
			public uint ps_ifdrop;		///< drops by interface. XXX not yet supported
			public uint bs_capt;		///< number of packets that pass the filter, find place in the kernel buffer and
			///< thus reach the application.
		};

		public struct BPF_HDR
		{
			public TIMEVAL	bh_tstamp;	///< The timestamp associated with the captured packet. 
			///< It is stored in a TimeVal structure.
			public uint	bh_caplen;			
			///< Length of captured portion. The captured portion can be different
			///< from the original packet, because it is possible (with a proper filter)
			///< to instruct the driver to capture only a portion of the packets.
			public uint	bh_datalen;			///< Original length of packet
			public ushort bh_hdrlen;		
			///< Length of bpf header (this struct plus alignment padding). 
			///In some cases, a padding could be added between the end of this 
			///structure and the packet data for performance reasons. This filed 
			///can be used to retrieve the actual data of the packet.
		};

		public struct DUMP_BPF_HDR
		{
			public TIMEVAL ts;			///< Time stamp of the packet
			public uint caplen;		///< Length of captured portion. The captured portion can smaller than the 
			///< the original packet, because it is possible (with a proper filter) to 
			///< instruct the driver to capture only a portion of the packets. 
			public uint len;		///< Length of the original packet (off wire).
		};



		public static string DOSNAMEPREFIX   = "Packet_";	///< Prefix added to the adapters device names to create the WinPcap devices
		public static uint MAX_LINK_NAME_LENGTH	= 64;			//< Maximum length of the devices symbolic links
		public static uint NMAX_PACKET = 65535;


		public struct OVERLAPPED
		{
			public ulong Internal; 
			public ulong InternalHigh; 
			public ulong Offset; 
			public ulong OffsetHigh; 
			public int hEvent; 
		};

		public struct TIMEVAL
		{
			public uint tv_sec;         // seconds 
			public uint tv_usec;        // and microseconds 
		};

		public struct ADAPTER
		{ 
			public int hFile;
			public int NumWrites;
			public int ReadEvent;
			public int ReadTimeOut;
		};

		public struct PADAPTER
		{ 
			public int hFile;
			public int NumWrites;
			public int ReadEvent;
			public int ReadTimeOut;
		};


		public struct PACKET
		{  
			public int Buffer;
			public int Length;
			public int ulBytesReceived;
		};


		public struct PPACKET
		{  
			public int Buffer;
			public int Length;
			public int ulBytesReceived;
		};

		public struct PPACKET_OID_DATA
		{
			public uint Oid;
			public int Length;
			public int Data;
		}; 

		public struct PACKET_OID_DATA
		{
			public uint Oid; 
			public int Length;
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=1024)] public byte [] Data;
		}; 

		public struct SOCKADDR_IN
		{
			public short sin_family;
			public ushort sin_port;
			public uint sin_addr;
			public byte [] sin_zero; // [8];
		};

		public struct SOCKADDR
		{
			public short sin_family;
			public ushort sin_port;
			public uint sin_addr;
			public byte [] sin_zero; // [8];
		};


		public struct NPF_IF_ADDR
		{
			public SOCKADDR [] IPAddress;	///< IP address.
			public SOCKADDR [] SubnetMask;	///< Netmask for that address.
			public SOCKADDR [] Broadcast;	///< Broadcast address.
		};


		public static uint SOCK_STREAM     = 1;               // stream socket
		public static uint SOCK_DGRAM      = 2;               // datagram socket
		public static uint SOCK_RAW        = 3;               // raw-protocol interface
		public static uint SOCK_RDM        = 4;               // reliably-delivered message
		public static uint SOCK_SEQPACKET  = 5;               // sequenced packet stream

		public static uint SO_DEBUG        = 0x0001;          // turn on debugging info recording
		public static uint SO_ACCEPTCONN   = 0x0002;          // socket has had listen()
		public static uint SO_REUSEADDR    = 0x0004;          // allow local address reuse
		public static uint SO_KEEPALIVE    = 0x0008;          // keep connections alive
		public static uint SO_DONTROUTE    = 0x0010;          // just use interface addresses
		public static uint SO_BROADCAST    = 0x0020;          // permit sending of broadcast msgs
		public static uint SO_USELOOPBACK  = 0x0040;          // bypass hardware when possible
		public static uint SO_LINGER       = 0x0080;          // linger on close if data present
		public static uint SO_OOBINLINE    = 0x0100;          // leave received OOB data in line

		public static uint SO_DONTLINGER   = (uint)(~SO_LINGER);
		public static uint SO_EXCLUSIVEADDRUSE = ((uint)(~SO_REUSEADDR)); // disallow local address reuse
		public static uint SO_SNDBUF       = 0x1001;          // send buffer size
		public static uint SO_RCVBUF       = 0x1002;          // receive buffer size
		public static uint SO_SNDLOWAT     = 0x1003;          // send low-water mark
		public static uint SO_RCVLOWAT     = 0x1004;          // receive low-water mark
		public static uint SO_SNDTIMEO     = 0x1005;          // send timeout
		public static uint SO_RCVTIMEO     = 0x1006;          // receive timeout
		public static uint SO_ERROR        = 0x1007;          // get error status and clear
		public static uint SO_TYPE         = 0x1008;          // get socket type

		public static uint SO_GROUP_ID       = 0x2001;      // ID of a socket group
		public static uint SO_GROUP_PRIORITY = 0x2002;      // the relative priority within a group
		public static uint SO_MAX_MSG_SIZE   = 0x2003;      // maximum message size
		public static uint SO_PROTOCOL_INFOA = 0x2004;      // WSAPROTOCOL_INFOA structure
		public static uint SO_PROTOCOL_INFOW = 0x2005;      // WSAPROTOCOL_INFOW structure
		public static uint PVD_CONFIG        = 0x3001;       // configuration info for service provider
		public static uint SO_CONDITIONAL_ACCEPT = 0x3002;   // enable true conditional accept:

		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			DeviceIoControl( int hDevice, uint dwIoControlCode, 
			ref int lpInBuffer, int nInBufferSize, 
			int lpOutBuffer, int nOutBufferSize, 
			ref int lpBytesReturned, int lpOverlapped );

		[DllImport("kernel32.dll")] public extern static int
			DeviceIoControl( int hDevice, uint dwIoControlCode, 
			int lpInBuffer, int nInBufferSize, 
			ref int lpOutBuffer, int nOutBufferSize, 
			ref int lpBytesReturned, int lpOverlapped );

		[DllImport("kernel32.dll")] public extern static int
			DeviceIoControl( int hDevice, uint dwIoControlCode, 
			int lpInBuffer, int nInBufferSize, 
			int lpOutBuffer, int nOutBufferSize, 
			ref int lpBytesReturned, int lpOverlapped );

		[DllImport("kernel32.dll")] public extern static int
			DeviceIoControl( int hDevice, uint dwIoControlCode, 
			ref PPACKET_OID_DATA lpInBuffer, int nInBufferSize, 
			byte [] lpOutBuffer, int nOutBufferSize, 
			ref int lpBytesReturned, int lpOverlapped );

		[DllImport("kernel32.dll")] public extern static int
			DeviceIoControl( int hDevice, uint dwIoControlCode, 
			byte [] lpInBuffer, int nInBufferSize, 
			byte [] lpOutBuffer, int nOutBufferSize, 
			ref int lpBytesReturned, int lpOverlapped );

		[DllImport("kernel32.dll")] public extern static int
			DeviceIoControl( int hDevice, uint dwIoControlCode, 
			int lpInBuffer, int nInBufferSize, 
			ref BPF_STAT lpOutBuffer, int nOutBufferSize, 
			ref int lpBytesReturned, int lpOverlapped );

		[DllImport("kernel32.dll")] public extern static int
			DeviceIoControl( int hDevice, uint dwIoControlCode, 
			char [] lpInBuffer, int nInBufferSize, 
			int lpOutBuffer, int nOutBufferSize, 
			ref int lpBytesReturned, int lpOverlapped );

		[DllImport("kernel32.dll")] public extern static int
			DeviceIoControl( int hDevice, uint dwIoControlCode, 
			uint [] lpInBuffer, int nInBufferSize, 
			int lpOutBuffer, int nOutBufferSize, 
			ref int lpBytesReturned, int lpOverlapped );

		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			ReadFile( int hFile, int lpBuffer, int nNumberOfBytesToRead, 
			ref int lpNumberOfBytesRead, int lpOverlapped );

		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			WriteFile( int hFile, int lpBuffer, int nNumberOfBytesToWrite, 
			ref int lpNumberOfBytesWritten, int lpOverlapped );

		[DllImport("kernel32.dll")] public extern static int
			WriteFile( int hFile, int lpBuffer, uint nNumberOfBytesToWrite, 
			ref int lpNumberOfBytesWritten, int lpOverlapped );

		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			WaitForSingleObject( int hHandle, uint dwMilliseconds );

		[DllImport("kernel32.dll")] public extern static int
			WaitForSingleObject( int hHandle, int dwMilliseconds );
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			QueryPerformanceFrequency(ref LARGE_INTEGER lpFrequency );

		[DllImport("kernel32.dll")] public extern static int
			QueryPerformanceFrequency(ref long lpFrequency );
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			QueryPerformanceCounter( ref LARGE_INTEGER lpPerformanceCount ); 	// address of current counter value

		[DllImport("kernel32.dll")] public extern static int
			QueryPerformanceCounter( ref long lpPerformanceCount ); 	// address of current counter value
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			SetEvent( int hEvent ); 	// handle of event object 
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			CloseHandle( int hObject ); 	// handle to object to close  
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			GetFullPathName(
			int lpFileName,	// address of name of file to find path for 
			int nBufferLength,	// size, in characters, of path buffer 
			int lpBuffer,	// address of path buffer 
			ref int lpFilePart 	// address of filename in path 
			);

		[DllImport("kernel32.dll")] public extern static int
			GetFullPathName(
			ref char [] lpFileName,	// address of name of file to find path for 
			int nBufferLength,	// size, in characters, of path buffer 
			ref char [] lpBuffer,	// address of path buffer 
			ref int lpFilePart 	// address of filename in path 
			);
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			CreateFile(
			int lpFileName,	// pointer to name of the file 
			int dwDesiredAccess,	// access (read-write) mode 
			int dwShareMode,	// share mode 
			int lpSecurityAttributes,	// pointer to security attributes 
			int dwCreationDistribution,	// how to create 
			int dwFlagsAndAttributes,	// file attributes 
			int hTemplateFile 	// handle to file with attributes to copy  
			);

		[DllImport("kernel32.dll")] public extern static int
			CreateFile(
			char [] lpFileName,	// pointer to name of the file 
			int dwDesiredAccess,	// access (read-write) mode 
			int dwShareMode,	// share mode 
			int lpSecurityAttributes,	// pointer to security attributes 
			int dwCreationDistribution,	// how to create 
			int dwFlagsAndAttributes,	// file attributes 
			int hTemplateFile 	// handle to file with attributes to copy  
			);
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			CreateEvent( int lpEventAttributes,	// pointer to security attributes  
			int bManualReset,	// flag for manual-reset event 
			int bInitialState,	// flag for initial state 
			int lpName 	// pointer to event-object name  
			);
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			OpenEvent(
					int dwDesiredAccess,	// access flag 
					int bInheritHandle,	// inherit flag 
					int lpName ); 	// pointer to event-object name  

		//**********************************************************************
		[DllImport("ws2_32.dll")] public extern static int
			WSAStartup ( int wVersionRequested,	 ref WSADATA lpWSAData );
		//**********************************************************************

		private ArrayList mCapturedPacketArray = new ArrayList();
		private ADAPTERINFO mAdapterInfo;
		private ADAPTERINFO_STR mAdapterInfoEx;
		private PACKET mPacket;
		private ADAPTER mAdapter;
		private PACKET_OID_DATA mPacketOidData;
		private BPF_STAT mBpfStat;
		private BPF_PROGRAM mBpfProgram;
		private NETTYPE mNetType;
		private NPF_IF_ADDR mNpfIfAddr;
		private int mPacketBufferSize;
		private int mReadEvent;
		private string mAdapterVersion;
		private string [] mAdapterNames;
		private string [] mAdapterDescriptions;
		private int mPacketErrorCode;
		private string mPacketErrorMessage;
		private string mPacketLibraryVersion;
		private int mScmHandle;
		private int mSrvHandle;
		private string mNPFServiceName;
		private string mNPFServiceDesc;
		private string mNPFRegistryLocation;
		private string mNPFDriverPath;

		//****************************************************************
		//
		//****************************************************************

		public Packet32h()
		{
			mPacketLibraryVersion = "3.0 alpha3"; 
			mPacketOidData.Data = new byte[1024];
			mPacket.Buffer = 0;
			mPacket.Length = 0;
			mPacket.ulBytesReceived = 0;
			mAdapter.hFile = 0;
			mAdapter.NumWrites = 1;
			mAdapter.ReadEvent = 0;
			mAdapter.ReadTimeOut = 1000;
			mPacketBufferSize = 0;
			mReadEvent = 0;
			mPacketErrorMessage = "";
			mScmHandle = 0;
			mSrvHandle = 0;
			mNPFServiceName = "NPF";
			mNPFServiceDesc = "Netgroup Packet Filter";
			mNPFRegistryLocation = "SYSTEM\\CurrentControlSet\\Services\\NPF";
			mNPFDriverPath = "system32\\drivers\\npf.sys";

			mAdapterNames = new string[1];
			mAdapterDescriptions = new string[1];
			mAdapterVersion = "";

			mNpfIfAddr.Broadcast = new SOCKADDR[10];
			mNpfIfAddr.IPAddress = new SOCKADDR[10];
			mNpfIfAddr.SubnetMask = new SOCKADDR[10];

			mPacketErrorCode = 0;
			mPacketErrorMessage = "";
			//PacketCheckRegistry();
			PacketGetAdapterNames();
			GetAdapterInfo();
			GetAdapterInfoEx();
			WinSockInit();
		}

		//****************************************************************
		//
		//****************************************************************

		public ArrayList CapturedPacketArray
		{
			get { return mCapturedPacketArray; }
		}

		public ADAPTERINFO AdapterInfo
		{ get { return mAdapterInfo; } }

		public ADAPTERINFO_STR AdapterInfoEx
		{ get { return mAdapterInfoEx; } }


		public PACKET Packet
		{ get { return mPacket; } }

		public ADAPTER Adapter
		{ get { return mAdapter; } }

		public BPF_STAT BpfStat
		{ get { return mBpfStat; } }

		public BPF_PROGRAM BpfProgram
		{
			get { return mBpfProgram; }
			set { mBpfProgram = value; }
		}

		public NETTYPE NetType
		{ get { return mNetType; } }

		public NPF_IF_ADDR NpfIfAddr
		{ get { return mNpfIfAddr; } }

		public int ReadEvent
		{ get { return mReadEvent; } }

		public string AdapterVersion
		{ get { return mAdapterVersion; } }

		public string [] AdapterNames
		{ get { return mAdapterNames; } }

		public string [] AdapterDescriptions
		{ get { return mAdapterDescriptions; } }

		public int PacketErrorCode
		{ get { return mPacketErrorCode; } }

		public string PacketErrorMessage
		{ get { return mPacketErrorMessage; } }

		public string PacketGetVersion()
		{ return mPacketLibraryVersion; }

		public void PacketGetReadEvent()
		{ mReadEvent = mAdapter.ReadEvent; }

		//****************************************************************
		//
		//****************************************************************

		public bool PacketAllocatePacket( int newBufferSize )
		{
			if( mPacket.Buffer != 0 )
			{
				Marshal.FreeCoTaskMem( (IntPtr) mPacket.Buffer );
				mPacket.Buffer = 0;
				mPacket.Length = 0;
			}

			mPacketBufferSize = newBufferSize; 
			mPacket.Buffer = (int) Marshal.AllocCoTaskMem( mPacketBufferSize );
			mPacket.Length = mPacketBufferSize;
			mPacket.ulBytesReceived = 0;

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketAllocatePacket()
		{
			if( mPacket.Buffer != 0 )
			{
				Marshal.FreeCoTaskMem( (IntPtr) mPacket.Buffer );
				mPacket.Buffer = 0;
				mPacket.Length = 0;
			}

			mPacketBufferSize = 4096; 
			mPacket.Buffer = (int) Marshal.AllocCoTaskMem( mPacketBufferSize );
			mPacket.Length = mPacketBufferSize;
			mPacket.ulBytesReceived = 0;

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public void PacketFreePacket()
		{
			if( mPacket.Buffer == 0 ) return;
			
			Marshal.FreeCoTaskMem( (IntPtr) mPacket.Buffer );
			mPacket.Buffer = 0;
			mPacket.Length = 0;
			mPacket.ulBytesReceived = 0;

		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketCloseAdapter()
		{
			PacketFreePacket();
			CloseHandle( mAdapter.hFile );
			SetEvent( mAdapter.ReadEvent );
			CloseHandle( mAdapter.ReadEvent );
			mAdapter.hFile = 0;
			mAdapter.NumWrites = 0;
			mAdapter.ReadEvent = 0;
			mAdapter.ReadTimeOut = 0;

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public void GetAdapterInfo()
		{
			mAdapterInfo.BroadcastBytesRcv = GetBroadcastBytesRcv();
			mAdapterInfo.BroadcastBytesXmit = GetBroadcastBytesXmit();
			mAdapterInfo.BroadcastFramesRcv = GetBroadcastFramesRcv();
			mAdapterInfo.BroadcastFramesXmit = GetBroadcastFramesXmit();
			mAdapterInfo.CurrentLookAhead = GetCurrentLookAhead();
			mAdapterInfo.CurrentPacketFilter = GetCurrentPacketFilter();
			mAdapterInfo.CurrentPacketFilterStr = NtddNDish.GetCurrentPacketFilterString(mAdapterInfo.CurrentPacketFilter);
			mAdapterInfo.DirectedBytesRcv = GetDirectedBytesRcv();
			mAdapterInfo.DirectedBytesXmit = GetDirectedBytesXmit();
			mAdapterInfo.DirectedFramesRcv = GetDirectedFramesRcv();
			mAdapterInfo.DirectedFramesXmit = GetDirectedFramesXmit();
			mAdapterInfo.DriverVersion = GetDriverVersion();
			mAdapterInfo.HardwareStatus = GetHardwareStatus();
			mAdapterInfo.HardwareStatusStr = NtddNDish.GetHardwareStatusString(mAdapterInfo.HardwareStatus);
			mAdapterInfo.LinkSpeed = GetLinkSpeed();
			mAdapterInfo.MacOptions = GetMacOptions();
			mAdapterInfo.MacOptionsStr = NtddNDish.GetMacOptionsString(mAdapterInfo.MacOptions);
			mAdapterInfo.MaximumFrameSize = GetMaximumFrameSize();
			mAdapterInfo.MaximumLookAhead = GetMaximumLookAhead();
			mAdapterInfo.MaximumSendPackets = GetMaximumSendPackets();
			mAdapterInfo.MaximumTotalSize = GetMaximumTotalSize();
			mAdapterInfo.MediaConnectStatus = GetMediaConnectStatus();
			mAdapterInfo.MediaConnectStatusStr = NtddNDish.GetMediaStateString(mAdapterInfo.MediaConnectStatus);
			mAdapterInfo.MediaInUse = GetMediaInUse();
			mAdapterInfo.MediaInUseStr = NtddNDish.GetMediaInUseString(mAdapterInfo.MediaInUse);
			mAdapterInfo.MediaSupported = GetMediaSupported();
			mAdapterInfo.MulticastBytesRcv = GetMulticastBytesRcv();
			mAdapterInfo.MulticastBytesXmit = GetMulticastBytesXmit();
			//mAdapterInfo.MulticastFramesRcv = GetMulticastFramesRcv();
			//mAdapterInfo.MulticastFramesXmit = GetMulticastFramesXmit();
			//mAdapterInfo.NetCardTime = GetNetCardTime();
			mAdapterInfo.ProtocolOptions = GetProtocolOptions();
			mAdapterInfo.ProtocolOptionsStr = NtddNDish.GetProtocolOptionsString(mAdapterInfo.ProtocolOptions);
			mAdapterInfo.RcvCrcError = GetRcvCrcError();
			mAdapterInfo.RcvError = GetRcvError();
			mAdapterInfo.RcvNoBuffer = GetRcvNoBuffer();
			mAdapterInfo.RcvOk = GetRcvOk();
			mAdapterInfo.ReceiveBlockSize = GetReceiveBlockSize();
			mAdapterInfo.ReceiveBufferSpace = GetReceiveBufferSpace();
			//mAdapterInfo.SupportedList = GetSupportedList(); // Check this line
			//mAdapterInfo.TimeCaps = GetTimeCaps();
			//mAdapterInfo.TimeCapsStr = NtddNDish.GetTimeCapsString(mAdapterInfo.TimeCaps);
			mAdapterInfo.TransmitBlockSize = GetTransmitBlockSize();
			mAdapterInfo.TransmitBufferSpace = GetTransmitBufferSpace();
			mAdapterInfo.TransmitQueueLength = GetTransmitQueueLength();
			mAdapterInfo.VendorDescription = GetVendorDescription();
			mAdapterInfo.VendorDriverVersion = GetVendorDriverVersion();
			mAdapterInfo.VendorId = GetVendorId();
			mAdapterInfo.XmitError = GetXmitError();
			mAdapterInfo.XmitOk = GetXmitOk();

			mAdapterInfo.TransportHeaderOffset = GetTransportHeaderOffset();
			mAdapterInfo.PhysicalMedium = GetPhysicalMedium();
			mAdapterInfo.NetworkLayerAddress = GetNetworkLayerAddress();
			mAdapterInfo.MediaSenseCount = GetMediaSenseCount();
			mAdapterInfo.MediaCapabilities = GetMediaCapabilities();
			mAdapterInfo.InitTimeMs = GetInitTimeMs();
			mAdapterInfo.FriendlyName = GetFriendlyName();
			mAdapterInfo.SupportedGuids = GetSupportedGuids();
			mAdapterInfo.NetCardLoad = GetNetCardLoad();
			mAdapterInfo.DeviceProfile = GetDeviceProfile();

		}

		public void GetAdapterInfoEx()
		{
			mAdapterInfoEx.BroadcastBytesRcv = mAdapterInfo.BroadcastBytesRcv.ToString();
			mAdapterInfoEx.BroadcastBytesXmit = mAdapterInfo.BroadcastBytesXmit.ToString();
			mAdapterInfoEx.BroadcastFramesRcv = mAdapterInfo.BroadcastFramesRcv.ToString();
			mAdapterInfoEx.BroadcastFramesXmit = mAdapterInfo.BroadcastFramesXmit.ToString();
			mAdapterInfoEx.CurrentLookAhead = mAdapterInfo.CurrentLookAhead.ToString();
			mAdapterInfoEx.CurrentPacketFilter = mAdapterInfo.CurrentPacketFilter.ToString();
			mAdapterInfoEx.DirectedBytesRcv = mAdapterInfo.DirectedBytesRcv.ToString();
			mAdapterInfoEx.DirectedBytesXmit = mAdapterInfo.DirectedBytesXmit.ToString();
			mAdapterInfoEx.DirectedFramesRcv = mAdapterInfo.DirectedFramesRcv.ToString();
			mAdapterInfoEx.DirectedFramesXmit = mAdapterInfo.DirectedFramesXmit.ToString();
			mAdapterInfoEx.DriverVersion = mAdapterInfo.DriverVersion.ToString();
			mAdapterInfoEx.HardwareStatus = mAdapterInfo.HardwareStatus.ToString();
			mAdapterInfoEx.LinkSpeed = mAdapterInfo.LinkSpeed.ToString();
			mAdapterInfoEx.MacOptions = mAdapterInfo.MacOptions.ToString();
			mAdapterInfoEx.MacOptionsStr = mAdapterInfo.MacOptionsStr.ToString();
			mAdapterInfoEx.MaximumFrameSize = mAdapterInfo.MaximumFrameSize.ToString();
			mAdapterInfoEx.MaximumLookAhead = mAdapterInfo.MaximumLookAhead.ToString();
			mAdapterInfoEx.MaximumSendPackets = mAdapterInfo.MaximumSendPackets.ToString();
			mAdapterInfoEx.MaximumTotalSize = mAdapterInfo.MaximumTotalSize.ToString();
			mAdapterInfoEx.MediaConnectStatus = mAdapterInfo.MediaConnectStatus.ToString();
			mAdapterInfoEx.MediaInUse = mAdapterInfo.MediaInUse.ToString();
			mAdapterInfoEx.MediaInUseStr = mAdapterInfo.MediaInUseStr.ToString();
			mAdapterInfoEx.MediaSupported = mAdapterInfo.MediaSupported.ToString();
			mAdapterInfoEx.MulticastBytesRcv = mAdapterInfo.MulticastBytesRcv.ToString();
			mAdapterInfoEx.MulticastBytesXmit = mAdapterInfo.MulticastBytesXmit.ToString();
			//mAdapterInfoEx.MulticastFramesRcv = mAdapterInfo.MulticastFramesRcv.ToString();
			//mAdapterInfoEx.MulticastFramesXmit = mAdapterInfo.MulticastFramesXmit.ToString();
			//mAdapterInfoEx.NetCardTime = mAdapterInfo.NetCardTime.ToString();
			mAdapterInfoEx.ProtocolOptions = mAdapterInfo.ProtocolOptions.ToString();
			mAdapterInfoEx.RcvCrcError = mAdapterInfo.RcvCrcError.ToString();
			mAdapterInfoEx.RcvError = mAdapterInfo.RcvError.ToString();
			mAdapterInfoEx.RcvNoBuffer = mAdapterInfo.RcvNoBuffer.ToString();
			mAdapterInfoEx.RcvOk = mAdapterInfo.RcvOk.ToString();
			mAdapterInfoEx.ReceiveBlockSize = mAdapterInfo.ReceiveBlockSize.ToString();
			mAdapterInfoEx.ReceiveBufferSpace = mAdapterInfo.ReceiveBufferSpace.ToString();
			//mAdapterInfoEx.SupportedList = mAdapterInfo.SupportedList.ToString(); // Check this line
			//mAdapterInfoEx.TimeCaps = mAdapterInfo.TimeCaps.ToString();
			mAdapterInfoEx.TransmitBlockSize = mAdapterInfo.TransmitBlockSize.ToString();
			mAdapterInfoEx.TransmitBufferSpace = mAdapterInfo.TransmitBufferSpace.ToString();
			mAdapterInfoEx.TransmitQueueLength = mAdapterInfo.TransmitQueueLength.ToString();
			mAdapterInfoEx.VendorDescription = mAdapterInfo.VendorDescription.ToString();
			mAdapterInfoEx.VendorDriverVersion = mAdapterInfo.VendorDriverVersion.ToString();
			mAdapterInfoEx.VendorId = mAdapterInfo.VendorId.ToString();
			mAdapterInfoEx.XmitError = mAdapterInfo.XmitError.ToString();
			mAdapterInfoEx.XmitOk = mAdapterInfo.XmitOk.ToString();

			mAdapterInfoEx.TransportHeaderOffset = mAdapterInfo.TransportHeaderOffset.ToString();
			mAdapterInfoEx.PhysicalMedium = mAdapterInfo.PhysicalMedium.ToString();
			mAdapterInfoEx.NetworkLayerAddress = mAdapterInfo.NetworkLayerAddress.ToString();
			mAdapterInfoEx.MediaSenseCount = mAdapterInfo.MediaSenseCount.ToString();
			mAdapterInfoEx.MediaCapabilities = mAdapterInfo.MediaCapabilities.ToString();
			mAdapterInfoEx.InitTimeMs = mAdapterInfo.InitTimeMs.ToString();
			mAdapterInfoEx.FriendlyName = GetFriendlyName().ToString();
			mAdapterInfoEx.SupportedGuids = mAdapterInfo.SupportedGuids.ToString();
			mAdapterInfoEx.NetCardLoad = mAdapterInfo.NetCardLoad.ToString();
			mAdapterInfoEx.DeviceProfile = mAdapterInfo.DeviceProfile.ToString();

		}

		//****************************************************************
		//
		//****************************************************************

		private int GetSupportedList()
		{ return GetOidInt( NtddNDish.OID_GEN_SUPPORTED_LIST ); }

		private int GetHardwareStatus()
		{ return GetOidInt( NtddNDish.OID_GEN_HARDWARE_STATUS ); }

		private int GetMediaSupported()
		{ return GetOidInt( NtddNDish.OID_GEN_MEDIA_SUPPORTED ); }

		private int GetMediaInUse()
		{ return GetOidInt( NtddNDish.OID_GEN_MEDIA_IN_USE ); }

		private int GetMaximumLookAhead()
		{ return GetOidInt( NtddNDish.OID_GEN_MAXIMUM_LOOKAHEAD ); }

		private int GetMaximumFrameSize()
		{ return GetOidInt( NtddNDish.OID_GEN_MAXIMUM_FRAME_SIZE ); }

		private int GetLinkSpeed()
		{ return GetOidInt( NtddNDish.OID_GEN_LINK_SPEED ); }

		private int GetTransmitBufferSpace()
		{ return GetOidInt( NtddNDish.OID_GEN_TRANSMIT_BUFFER_SPACE ); }

		private int GetReceiveBufferSpace()
		{ return GetOidInt( NtddNDish.OID_GEN_RECEIVE_BUFFER_SPACE ); }

		private int GetTransmitBlockSize()
		{ return GetOidInt( NtddNDish.OID_GEN_TRANSMIT_BLOCK_SIZE ); }

		private int GetReceiveBlockSize()
		{ return GetOidInt( NtddNDish.OID_GEN_RECEIVE_BLOCK_SIZE ); }

		private int GetVendorId()
		{ return GetOidInt( NtddNDish.OID_GEN_VENDOR_ID ); }

		private string GetVendorDescription()
		{ return GetOidStr( NtddNDish.OID_GEN_VENDOR_DESCRIPTION ); }

		private int GetCurrentPacketFilter()
		{ return GetOidInt( NtddNDish.OID_GEN_CURRENT_PACKET_FILTER ); }

		private int GetCurrentLookAhead()
		{ return GetOidInt( NtddNDish.OID_GEN_CURRENT_LOOKAHEAD ); }

		private int GetMaximumTotalSize()
		{ return GetOidInt( NtddNDish.OID_GEN_MAXIMUM_TOTAL_SIZE ); }

		private int GetProtocolOptions()
		{ return GetOidInt( NtddNDish.OID_GEN_PROTOCOL_OPTIONS ); }

		private int GetMacOptions()
		{ return GetOidInt( NtddNDish.OID_GEN_MAC_OPTIONS ); }

		private int GetMediaConnectStatus()
		{ return GetOidInt( NtddNDish.OID_GEN_MEDIA_CONNECT_STATUS ); }

		private int GetMaximumSendPackets()
		{ return GetOidInt( NtddNDish.OID_GEN_MAXIMUM_SEND_PACKETS ); }

		private int GetDriverVersion()
		{ return GetOidInt( NtddNDish.OID_GEN_DRIVER_VERSION ); }

		private int GetVendorDriverVersion()
		{ return GetOidInt( NtddNDish.OID_GEN_VENDOR_DRIVER_VERSION ); }

		private int GetXmitOk()
		{ return GetOidInt( NtddNDish.OID_GEN_XMIT_OK ); }

		private int GetRcvOk()
		{ return GetOidInt( NtddNDish.OID_GEN_RCV_OK ); }

		private int GetXmitError()
		{ return GetOidInt( NtddNDish.OID_GEN_XMIT_ERROR ); }

		private int GetRcvError()
		{ return GetOidInt( NtddNDish.OID_GEN_RCV_ERROR ); }

		private int GetRcvNoBuffer()
		{ return GetOidInt( NtddNDish.OID_GEN_RCV_NO_BUFFER ); }

		private int GetDirectedBytesXmit()
		{ return GetOidInt( NtddNDish.OID_GEN_DIRECTED_BYTES_XMIT ); }

		private int GetDirectedFramesXmit()
		{ return GetOidInt( NtddNDish.OID_GEN_DIRECTED_FRAMES_XMIT ); }

		private int GetMulticastBytesXmit()
		{ return GetOidInt( NtddNDish.OID_GEN_MULTICAST_BYTES_XMIT ); }

		private int GetMulticastFramesXmit()
		{ return GetOidInt( NtddNDish.OID_GEN_MULTICAST_FRAMES_XMIT ); }

		private int GetBroadcastBytesXmit()
		{ return GetOidInt( NtddNDish.OID_GEN_BROADCAST_BYTES_XMIT ); }

		private int GetBroadcastFramesXmit()
		{ return GetOidInt( NtddNDish.OID_GEN_BROADCAST_FRAMES_XMIT ); }

		private int GetDirectedBytesRcv()
		{ return GetOidInt( NtddNDish.OID_GEN_DIRECTED_BYTES_RCV ); }

		private int GetDirectedFramesRcv()
		{ return GetOidInt( NtddNDish.OID_GEN_DIRECTED_FRAMES_RCV ); }

		private int GetMulticastBytesRcv()
		{ return GetOidInt( NtddNDish.OID_GEN_MULTICAST_BYTES_RCV ); }

		private int GetMulticastFramesRcv()
		{ return GetOidInt( NtddNDish.OID_GEN_MULTICAST_FRAMES_RCV ); }

		private int GetBroadcastBytesRcv()
		{ return GetOidInt( NtddNDish.OID_GEN_BROADCAST_BYTES_RCV ); }

		private int GetBroadcastFramesRcv()
		{ return GetOidInt( NtddNDish.OID_GEN_BROADCAST_FRAMES_RCV ); }

		private int GetRcvCrcError()
		{ return GetOidInt( NtddNDish.OID_GEN_RCV_CRC_ERROR ); }

		private int GetTransmitQueueLength()
		{ return GetOidInt( NtddNDish.OID_GEN_TRANSMIT_QUEUE_LENGTH ); }

		private int GetTimeCaps()
		{ return GetOidInt( NtddNDish.OID_GEN_GET_TIME_CAPS ); }

		private int GetNetCardTime()
		{ return GetOidInt( NtddNDish.OID_GEN_GET_NETCARD_TIME ); }

		private int GetDeviceProfile()
		{ return GetOidInt( NtddNDish.OID_GEN_DEVICE_PROFILE ); }

		private int GetNetCardLoad()
		{ return GetOidInt( NtddNDish.OID_GEN_NETCARD_LOAD ); }

		private int GetSupportedGuids()
		{ return GetOidInt( NtddNDish.OID_GEN_SUPPORTED_GUIDS ); }

		private string GetFriendlyName()
		{ return GetOidStr( NtddNDish.OID_GEN_FRIENDLY_NAME ); }

		private int GetInitTimeMs()
		{ return GetOidInt( NtddNDish.OID_GEN_INIT_TIME_MS ); }

		private int GetMediaCapabilities()
		{ return GetOidInt( NtddNDish.OID_GEN_MEDIA_CAPABILITIES ); }

		private int GetMediaSenseCount()
		{ return GetOidInt( NtddNDish.OID_GEN_MEDIA_SENSE_COUNTS ); }

		private int GetNetworkLayerAddress()
		{ return GetOidInt( NtddNDish.OID_GEN_NETWORK_LAYER_ADDRESSES ); }

		private int GetPhysicalMedium()
		{ return GetOidInt( NtddNDish.OID_GEN_PHYSICAL_MEDIUM ); }

		private int GetTransportHeaderOffset()
		{ return GetOidInt( NtddNDish.OID_GEN_TRANSPORT_HEADER_OFFSET ); }

		//****************************************************************
		//
		//****************************************************************

		public bool GetOid( uint Oid )
		{
			int BytesReturned = 0, i = 0;
			byte [] MyData = new byte[1032];
			int Result;
			int Size1 = 12 - 1 + 1032;
			int Size2 = 12 - 1 + 1032;
			PPACKET_OID_DATA mpData;
			IntPtr IPtr = Marshal.AllocCoTaskMem( 1032 );

			mpData.Oid = Oid;
			mpData.Data = ( int ) IPtr;
			mpData.Length = 1032;

			Result = DeviceIoControl( mAdapter.hFile ,
				pBIOCQUERYOID ,
				ref mpData ,
				Size1 ,
				MyData ,
				Size2 ,
				ref BytesReturned ,
				0);

			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				Marshal.FreeCoTaskMem( IPtr );
				return false;
			}

			Marshal.FreeCoTaskMem( IPtr );
			int index = 4;
			int Size = (int) Function.Get4Bytes( MyData , ref index , 1 );
			mPacketOidData.Oid = Oid;
			mPacketOidData.Length = Size;

			for( i = 0; i < 1024; i ++ )
				mPacketOidData.Data[i] = MyData[ 8 + i ];

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public string GetOidStr( uint Oid )
		{
			string Tmp = "";

			if( !GetOid( Oid ) ) return "";
			if( mPacketOidData.Data[1] != 0 )
				Tmp = Encoding.ASCII.GetString( mPacketOidData.Data , 0 , mPacketOidData.Length );
			else
				Tmp = Encoding.Unicode.GetString( mPacketOidData.Data , 0 , mPacketOidData.Length );

			return Tmp;
		}

		//****************************************************************
		//
		//****************************************************************

		public byte GetOidByte( uint Oid )
		{
			byte Tmp = 0;

			if( !GetOid( Oid ) ) return 0;
			Tmp = mPacketOidData.Data[0];

			return Tmp;
		}

		//****************************************************************
		//
		//****************************************************************

		public char GetOidChar( uint Oid )
		{
			char Tmp = (char) 0;

			if( !GetOid( Oid ) ) return (char) 0;
			Tmp = (char) mPacketOidData.Data[0];

			return Tmp;
		}

		//****************************************************************
		//
		//****************************************************************

		public int GetOidInt( uint Oid )
		{ return ( ( int ) GetOidUInt( Oid ) ); }

		//****************************************************************
		//
		//****************************************************************

		public uint GetOidUInt( uint Oid )
		{
			uint Tmp = 0;

			if( !GetOid( Oid ) ) return 0;
			Tmp = ( ( uint ) mPacketOidData.Data[3] ) << 24;
			Tmp += ( ( uint ) mPacketOidData.Data[2] ) << 16;
			Tmp += ( ( uint ) mPacketOidData.Data[1] ) << 8;
			Tmp += ( uint ) mPacketOidData.Data[0];

			return Tmp;
		}

		//****************************************************************
		//
		//****************************************************************

		public long GetOidLong( uint Oid )
		{ return ( ( long ) GetOidULong( Oid ) ); }

		//****************************************************************
		//
		//****************************************************************

		public ulong GetOidULong( uint Oid )
		{
			ulong Tmp = 0;

			if( !GetOid( Oid ) ) return 0;

			Tmp = ( ( ulong ) mPacketOidData.Data[7] ) << 56;
			Tmp += ( ( ulong ) mPacketOidData.Data[6] ) << 48;
			Tmp += ( ( ulong ) mPacketOidData.Data[5] ) << 40;
			Tmp += ( ( ulong ) mPacketOidData.Data[4] ) << 32;
			Tmp += ( ( ulong ) mPacketOidData.Data[3] ) << 24;
			Tmp += ( ( ulong ) mPacketOidData.Data[2] ) << 16;
			Tmp += ( ( ulong ) mPacketOidData.Data[1] ) << 8;
			Tmp += ( ulong ) mPacketOidData.Data[0];

			return Tmp;
		}

		//****************************************************************
		//
		//****************************************************************
		public bool SetOid( uint Oid , object NewValue )
		{
			int BytesReturned = 0, i = 0;
			int Result = 0;
			byte [] MyData = new byte[1024];
			int Size1 = MyData.GetLength(0);

			Function.Set4Bytes( ref MyData , 0 , Oid , Const.VALUE );

			if( NewValue.GetType().ToString() == "System.Byte" )
			{
				Function.Set4Bytes( ref MyData , 4 , 1 , Const.VALUE );
				MyData[ 8 ] = (byte) NewValue;
			}
			else if( NewValue.GetType().ToString() == "System.Char" )
			{
				Function.Set4Bytes( ref MyData , 4 , 1 , Const.VALUE );
				MyData[ 8 ] = (byte)( (char)  NewValue );
			}
			else if( NewValue.GetType().ToString() == "System.Int16" )
			{
				Function.Set4Bytes( ref MyData , 4 , 2 , Const.VALUE );
				Function.Set4Bytes( ref MyData , 8 , (ushort) NewValue , Const.VALUE );
			}
			else if( NewValue.GetType().ToString() == "System.UInt16" )
			{
				Function.Set4Bytes( ref MyData , 4 , 2 , Const.VALUE );
				Function.Set4Bytes( ref MyData , 8 , (ushort) NewValue , Const.VALUE );
			}
			else if( NewValue.GetType().ToString() == "System.Int32" )
			{
				Function.Set4Bytes( ref MyData , 4 , 4 , Const.VALUE );
				Function.Set4Bytes( ref MyData , 8 , (uint) NewValue , Const.VALUE );
			}
			else if( NewValue.GetType().ToString() == "System.UInt32" )
			{
				Function.Set4Bytes( ref MyData , 4 , 4 , Const.VALUE );
				Function.Set4Bytes( ref MyData , 8 , (uint) NewValue , Const.VALUE );
			}
			else if( NewValue.GetType().ToString() == "System.Int64" )
			{
				Function.Set4Bytes( ref MyData , 8 , 8 , Const.VALUE );
				Function.Set8Bytes( ref MyData , 8 , (ulong) NewValue , Const.VALUE );
			}
			else if( NewValue.GetType().ToString() == "System.UInt64" )
			{
				Function.Set4Bytes( ref MyData , 8 , 8 , Const.VALUE );
				Function.Set8Bytes( ref MyData , 8 , (ulong) NewValue , Const.VALUE );
			}
			else if( NewValue.GetType().ToString() == "System.String")
			{
				Function.Set4Bytes( ref MyData , 4 , (uint) ( (string) NewValue ).Length , Const.VALUE );
				for( i = 0; i < ( (string) NewValue ).Length; i ++ )
					MyData[ 8 + i ] = (byte) ( (string) NewValue )[i];
			}


			Result = DeviceIoControl( mAdapter.hFile ,
				pBIOCSETOID ,
				MyData ,
				Size1 ,
				MyData ,
				Size1 ,
				ref BytesReturned ,
				0);

			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetMaxLookAheadSize()
		{
			//set the size of the lookahead buffer to the maximum available by the the NIC driver
			uint uintValue2 = GetOidUInt( NtddNDish.OID_GEN_MAXIMUM_LOOKAHEAD );
			SetOid( NtddNDish.OID_GEN_CURRENT_LOOKAHEAD , uintValue2 );
			
			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public int SendDeviceCommand( uint DvcCmd , int Value )
		{
			int BytesReturned = 0;
			int newValue = Value;

			return DeviceIoControl( mAdapter.hFile,
				DvcCmd,
				ref newValue,
				4,
				0,
				0,
				ref BytesReturned,
				0);
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetMinToCopy( int nbytes )
		{
			int Result = 0;

			Result = SendDeviceCommand( pBIOCSMINTOCOPY, nbytes );
			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;

		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetNumWrites( int nwrites )
		{
			int Result = 0;

			Result = SendDeviceCommand( pBIOCSWRITEREP, nwrites );
			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetMode( int mode )
		{
			int Result = 0;

			Result = SendDeviceCommand( pBIOCSMODE, mode );
			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetReadTimeout( int timeout)
		{
			int Result = 0;
			int DriverTimeOut = -1;

			mAdapter.ReadTimeOut = timeout;
			Result = SendDeviceCommand( pBIOCSRTIMEOUT, DriverTimeOut );
			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetBpf()
		{
			int Result = 0;

			//Result = SendDeviceCommand( pBIOCSETF, mBpfProgram );
			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketGetStats()
		{
			int Res = 0;
			int BytesReturned = 0;
			// We use a support structure to avoid kernel-level inconsistencies with old or malicious applications
			BPF_STAT tmpstat; // = ( PBPF_STAT * ) Function.AddressOf( new byte[ sizeof( PBPF_STAT ) ] );	

			tmpstat.bs_capt = 0;
			tmpstat.bs_drop = 0;
			tmpstat.bs_recv = 0;
			tmpstat.ps_ifdrop = 0;

			Res = DeviceIoControl( mAdapter.hFile,
				pBIOCGSTATS,
				0,
				0,
				ref tmpstat,
				16, //sizeof( PBPF_STAT ),
				ref BytesReturned,
				0);

			if( Res == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			// Copy only the first two values retrieved from the driver
			mBpfStat.bs_recv = tmpstat.bs_recv;
			mBpfStat.bs_drop = tmpstat.bs_drop;

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketGetStatsEx()
		{
			int Res = 0;
			int BytesReturned = 0;
			// We use a support structure to avoid kernel-level inconsistencies with old or malicious applications
			//PBPF_STAT * tmpstat = ( PBPF_STAT * ) Function.AddressOf( new byte[ sizeof( PBPF_STAT ) ] );
			BPF_STAT tmpstat; // = ( PBPF_STAT * ) Function.AddressOf( new byte[ sizeof( PBPF_STAT ) ] );	

			tmpstat.bs_capt = 0;
			tmpstat.bs_drop = 0;
			tmpstat.bs_recv = 0;
			tmpstat.ps_ifdrop = 0;

			Res = DeviceIoControl( mAdapter.hFile,
				pBIOCGSTATS,
				0,
				0,
				ref tmpstat,
				16, //sizeof( PBPF_STAT ),
				ref BytesReturned,
				0);
			if( Res == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			mBpfStat.bs_recv = tmpstat.bs_recv;
			mBpfStat.bs_drop = tmpstat.bs_drop;
			mBpfStat.ps_ifdrop = tmpstat.ps_ifdrop;
			mBpfStat.bs_capt = tmpstat.bs_capt;

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetBuff( int dim )
		{
			int Result = 0;

			Result = SendDeviceCommand( pBIOCSETBUFFERSIZE, dim );
			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketGetNetType()
		{
			//get the link-layer type
			mNetType.LinkType = ( uint ) GetMediaInUse();
			//get the link-layer speed
			mNetType.LinkSpeed = ( uint ) GetLinkSpeed();

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSendPacket()
		{
			int BytesTransfered = 0;
			int Result = 0;
    
			Result = WriteFile( mAdapter.hFile,
				mPacket.Buffer,
				(int) mPacket.Length,
				ref BytesTransfered,
				0);
			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public int PacketSendPackets( bool Sync )
		{
			int Result = 0;
			int BytesTransfered = 0, TotBytesTransfered = 0;
			TIMEVAL BufStartTime;
			TIMEVAL LocalTime;
			long StartTicks = 0, CurTicks = 0, TargetTicks = 0, TimeFreq = 0;
			long Val1 = 0, Val2 = 0, Val3 = 0;


			// Obtain starting timestamp of the buffer
			BufStartTime = ( TIMEVAL ) Marshal.PtrToStructure( ( IntPtr ) mPacket.Buffer , typeof( TIMEVAL ) );

			// Retrieve the reference time counters
			QueryPerformanceCounter( ref StartTicks );
			QueryPerformanceFrequency( ref TimeFreq );

			CurTicks = StartTicks;

			do
			{
				// Send the data to the driver
				if( Sync )
					Result = DeviceIoControl( mAdapter.hFile,
						pBIOCSENDPACKETSSYNC,
						mPacket.Buffer + TotBytesTransfered,
						mPacket.Length - TotBytesTransfered,
						0,
						0,
						ref BytesTransfered,
						0);
				else
					Result = DeviceIoControl( mAdapter.hFile,
						pBIOCSENDPACKETSNOSYNC,
						mPacket.Buffer + TotBytesTransfered,
						mPacket.Length - TotBytesTransfered,
						0,
						0,
						ref BytesTransfered,
						0);


				TotBytesTransfered += BytesTransfered;

				// calculate the time interval to wait before sending the next packet
				LocalTime = ( TIMEVAL ) Marshal.PtrToStructure( ( IntPtr ) ( mPacket.Buffer + TotBytesTransfered ) , typeof( TIMEVAL ) );
				Val1 = ( LocalTime.tv_sec - BufStartTime.tv_sec ) * 1000000;
				Val2 = LocalTime.tv_usec - BufStartTime.tv_usec;
				Val3 = TimeFreq / 1000000;
				TargetTicks = StartTicks + Val1 + Val2 * Val3;

				// Exit from the loop on termination or error
				if( TotBytesTransfered >= mPacketBufferSize || Result == 0 )
					break;
		
				// Wait until the time interval has elapsed
			while( CurTicks <= TargetTicks )
				QueryPerformanceCounter( ref CurTicks );

			}while( true );

			return TotBytesTransfered;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketReceivePacket( bool Sync )
		{
			int Result = 0;
			byte [] ReadBytes;

			Result = SetEvent( mAdapter.ReadEvent );

			if( mAdapter.ReadTimeOut != -1 )
			{
				if( mAdapter.ReadTimeOut == 0 )
					Result = WaitForSingleObject( mAdapter.ReadEvent, INFINITE );
				else
					Result = WaitForSingleObject( mAdapter.ReadEvent, mAdapter.ReadTimeOut );

			}

			if( Result != mAdapter.ReadEvent )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );

			}
			

			Result = ReadFile(  mAdapter.hFile, 
								mPacket.Buffer, 
								mPacket.Length, 
								ref mPacket.ulBytesReceived,
								0);

			mPacketErrorCode = Function.GetLastError();
			if( mPacketErrorCode > 0 )
				mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
			Function.SetLastError( 0 );

			if( mPacket.ulBytesReceived > 0 )
			{
				ReadBytes = new byte[ (int) mPacket.ulBytesReceived ];
				Marshal.Copy( ( IntPtr ) mPacket.Buffer , ReadBytes , 0 , (int) mPacket.ulBytesReceived );
				mCapturedPacketArray.Add ( ReadBytes );
			}

			if( Result == 0 ) return false;


			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetHwFilter( uint Filter )
		{
			SetOid( NtddNDish.OID_GEN_CURRENT_PACKET_FILTER, Filter );

			return true;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketGetNetInfoEx( string AdapterName, ref int NEntries )
		{
			RegistryKey SystemKey;
			RegistryKey InterfaceKey;
			RegistryKey ParametersKey;
			RegistryKey TcpIpKey;
			RegistryKey UnderTcpKey;
			char [] StrArr = new char[1024+1];//WCHAR	String[1024+1];
			int DHCPEnabled = 0;
			int ZeroBroadcast = 0;
			string StrAdapterName = AdapterName;

			StrAdapterName = StrAdapterName.Replace("Device" , "" );
			StrAdapterName = StrAdapterName.Replace("\\" , "" );
			StrAdapterName = StrAdapterName.Replace("NPF_" , "" );

			UnderTcpKey = Registry.LocalMachine.OpenSubKey("SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters\\Interfaces");
			if( UnderTcpKey != null )
			{
				TcpIpKey = UnderTcpKey.OpenSubKey( StrAdapterName );
				if( TcpIpKey == null )
				{
					UnderTcpKey.Close();
					goto fail;
				}
			}
			else
			{
				// Query the registry key with the interface's adresses
				SystemKey = Registry.LocalMachine.OpenSubKey("SYSTEM\\CurrentControlSet\\Services");
				if( SystemKey == null )
					goto fail;

				InterfaceKey = SystemKey.OpenSubKey( StrAdapterName );
				if( InterfaceKey == null )
				{
					SystemKey.Close();
					goto fail;
				}

				SystemKey.Close();
				ParametersKey = InterfaceKey.OpenSubKey("Parameters");
				if( ParametersKey == null )
				{
					InterfaceKey.Close();
					goto fail;
				}
	
				InterfaceKey.Close();
				TcpIpKey = ParametersKey.OpenSubKey("TcpIp");
				if( TcpIpKey == null )
				{
					ParametersKey.Close();
					goto fail;
				}
				ParametersKey.Close();
			}

			object oUseZeroBroadcast = TcpIpKey.GetValue("UseZeroBroadcast");
			if( oUseZeroBroadcast == null )
				ZeroBroadcast = 0;
			else
				ZeroBroadcast = (int) oUseZeroBroadcast;
	
			object oEnableDHCP = TcpIpKey.GetValue("EnableDHCP");
			if( oEnableDHCP == null )
				DHCPEnabled = 0;
			else
				DHCPEnabled = (int) oEnableDHCP;
	
	
			// Retrieve the adrresses 
			if( DHCPEnabled > 0)
			{
				// Open the key with the addresses
				object oDhcpIPAddress = TcpIpKey.GetValue("DhcpIPAddress");
				if( oDhcpIPAddress == null )
				{
					TcpIpKey.Close();
					goto fail;
				}

				string strDhcpIPAddress = (string) oDhcpIPAddress;
				mNpfIfAddr.Broadcast[0].sin_family = (short) AF_INET;
				mNpfIfAddr.IPAddress[0].sin_family = (short) AF_INET;
				mNpfIfAddr.IPAddress[0].sin_addr = (uint)Function.IpAddressToInt( strDhcpIPAddress );
				if( ZeroBroadcast == 0 )
					mNpfIfAddr.Broadcast[0].sin_addr = 0xffffffff; // 255.255.255.255
				else
					mNpfIfAddr.Broadcast[0].sin_addr = 0; // 0.0.0.0

		
				
				// Open the key with the netmasks
				object oDhcpSubnetMask = TcpIpKey.GetValue("DhcpSubnetMask");
				if( oDhcpSubnetMask == null ) 
				{
					TcpIpKey.Close();
					goto fail;
				}

				string strDhcpSubnetMask = (string) oDhcpSubnetMask;
				mNpfIfAddr.SubnetMask[0].sin_family = (short) AF_INET;
				mNpfIfAddr.SubnetMask[0].sin_addr = (uint)Function.IpAddressToInt( strDhcpSubnetMask );
			}		
			else
			{

				// Open the key with the addresses
				object oDhcpIPAddress = TcpIpKey.GetValue("IPAddress");
				if( oDhcpIPAddress == null )
				{
					TcpIpKey.Close();
					goto fail;
				}

				string strDhcpIPAddress = (string) oDhcpIPAddress;
				mNpfIfAddr.Broadcast[0].sin_family = (short) AF_INET;
				mNpfIfAddr.IPAddress[0].sin_family = (short) AF_INET;
				mNpfIfAddr.IPAddress[0].sin_addr = (uint)Function.IpAddressToInt( strDhcpIPAddress );
				if( ZeroBroadcast == 0 )
					mNpfIfAddr.Broadcast[0].sin_addr = 0xffffffff; // 255.255.255.255
				else
					mNpfIfAddr.Broadcast[0].sin_addr = 0; // 0.0.0.0

		
				
				// Open the key with the netmasks
				object oDhcpSubnetMask = TcpIpKey.GetValue("SubnetMask");
				if( oDhcpSubnetMask == null ) 
				{
					TcpIpKey.Close();
					goto fail;
				}

				string strDhcpSubnetMask = (string) oDhcpSubnetMask;
				mNpfIfAddr.SubnetMask[0].sin_family = (short) AF_INET;
				mNpfIfAddr.SubnetMask[0].sin_addr = (uint) Function.IpAddressToInt( strDhcpSubnetMask );
			}
	
			NEntries = 1;

			TcpIpKey.Close();
			return true;
	
			fail:

				return false;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetDumpName( string Name )
		{
			int BytesReturned = 0;

			string FileName;
			char [] FileNameArray;
			int len = 0;

			int Res;
			char [] NameWithPathArray = new char[1024];
			int TStrLen = 0;
			int NamePos = 0;

			FileName = Name;
			FileNameArray = FileName.ToCharArray();
			TStrLen = GetFullPathName( ref FileNameArray , 1024 , ref NameWithPathArray , ref NamePos );

			len = TStrLen * 2 + 2;  //add the terminating null character

			Res = DeviceIoControl(mAdapter.hFile,
							pBIOCSETDUMPFILENAME,
							NameWithPathArray,
							len,
							0,
							0,	
							ref BytesReturned,
							0);

			if( Res == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;

		}

		/*public bool PacketSetDumpName( string Name )
		{
			int BytesReturned = 0;

			string FileName;
			char [] FileNameArray;
			int FileNameAddr;
			int len = 0;

			int Res;
			char [] NameWithPathArray = new char[1024];
			int NameWithPathAddr = Function.AddressOf( NameWithPathArray );
			int TStrLen = 0;
			int NamePos = 0;

			FileName = Name;
			FileNameArray = FileName.ToCharArray();
			FileNameAddr = Function.AddressOf( FileNameArray );

			TStrLen = GetFullPathName( FileNameAddr , 1024 , NameWithPathAddr , ref NamePos );

			len = TStrLen * 2 + 2;  //add the terminating null character

			Res = DeviceIoControl(mAdapter.hFile,
				pBIOCSETDUMPFILENAME,
				NameWithPathArray,
				len,
				0,
				0,	
				ref BytesReturned,
				0);

			if( Res == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;

		}*/

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetDumpLimits( uint maxfilesize, uint maxnpacks )
		{
			int BytesReturned = 0;
			int Result;
			uint [] valbuff = new uint[2];

			valbuff[0] = maxfilesize;
			valbuff[1] = maxnpacks;

			Result = DeviceIoControl(mAdapter.hFile,
				pBIOCSETDUMPLIMITS,
				valbuff,
				4 * 2, //sizeof( uint ) * 2,
				0,
				0,
				ref BytesReturned,
				0);	
			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return false;
			}

			return true;

		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketIsDumpEnded( bool Sync )
		{
			int BytesReturned = 0;
			int IsDumpEnded = 0;
			int Result = 0;

			if(Sync)
				WaitForSingleObject(mAdapter.ReadEvent, INFINITE);

			Result = DeviceIoControl(mAdapter.hFile,
				pBIOCISDUMPENDED,
				0,
				0,
				ref IsDumpEnded,
				4,
				ref BytesReturned,
				0);

			if( Result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				Function.SetLastError( 0 );
				return true; // supposing that the dump is finished;
			}

			if( IsDumpEnded > 0 ) return true;
			return false;

		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketStopDriver()
		{
			int ScmHandle = 0;
			int SchService = 0;
			int Result = 0;
			WinService.SERVICE_STATUS ServiceStatus;

			ServiceStatus.dwCheckPoint = 0;
			ServiceStatus.dwControlsAccepted = 0;
			ServiceStatus.dwCurrentState = 0;
			ServiceStatus.dwServiceSpecificExitCode = 0;
			ServiceStatus.dwServiceType = 0;
			ServiceStatus.dwWaitHint = 0;
			ServiceStatus.dwWin32ExitCode = 0;

			ScmHandle = WinService.OpenSCManager(0 , 0 , WinService.SC_MANAGER_ALL_ACCESS );
	
			if( ScmHandle > 0 )
			{
		
				SchService = WinService.OpenService( ScmHandle,
					mNPFServiceName,
					WinService.SERVICE_ALL_ACCESS );
		
				if( SchService > 0 )
				{
			
					Result = WinService.ControlService( SchService,
						WinService.SERVICE_CONTROL_STOP,
						ref ServiceStatus );
			
					WinService.CloseServiceHandle( SchService );
					WinService.CloseServiceHandle( ScmHandle );
			
					return true;
				}
			}
	
			return false;

		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketGetAdapterNames()
		{
			RegistryKey LinkageKey;
			RegistryKey AdapKey;
			RegistryKey OneAdapKey;
			int i = 0, k = 0;
			string [] AllAdapterNames;
			string [] AllDescriptions;
			int [] AdapterExist;
			string [] SubKeys;
			object oExport;
			object oValue;
			object oUpperBindStr;
			Array Arr;
			string DevName = "";


			try
			{
				AdapKey = Registry.LocalMachine.OpenSubKey("SYSTEM\\CurrentControlSet\\Control\\Class\\{4D36E972-E325-11CE-BFC1-08002BE10318}", false );

				if( AdapKey == null )
				{
					mPacketErrorMessage = "PacketGetAdapterNames: RegOpenKeyEx ( Class\\{networkclassguid} ) Failed";
					return false;
				}

				SubKeys = AdapKey.GetSubKeyNames();
				AllAdapterNames = new string[ SubKeys.GetLength(0) ];
				AllDescriptions = new string[ SubKeys.GetLength(0) ];
				AdapterExist = new int[ SubKeys.GetLength(0) ];
				for( i = 0; i < SubKeys.GetLength(0); i ++ )
				{
					OneAdapKey = AdapKey.OpenSubKey( SubKeys[i] , false );
					if( OneAdapKey == null )
					{
						AdapKey.Close();
						mPacketErrorMessage = "PacketGetAdapterNames: RegOpenKeyEx ( OneAdapKey ) Failed";
						return false;
					}
    
					LinkageKey = OneAdapKey.OpenSubKey("Linkage", false );
					if( LinkageKey == null )
					{
						OneAdapKey.Close();
						AdapKey.Close();
						mPacketErrorMessage = "PacketGetAdapterNames: RegOpenKeyEx ( LinkageKey ) Failed";
						return false;
					}

					Arr = ( Array ) LinkageKey.GetValue( "UpperBind" );
					oUpperBindStr = LinkageKey.GetValue( "UpperBind" );
					if( oUpperBindStr != null )
						AllDescriptions[i] = (string) Arr.GetValue(0);

					Arr = ( Array ) LinkageKey.GetValue( "Export" );
					oExport = LinkageKey.GetValue( "Export" );
					if( oExport == null )
					{
						OneAdapKey.Close();
						LinkageKey.Close();
						mPacketErrorMessage = "Name = SKIPPED (error reading the key)";
						continue;
					}
					else
						AllAdapterNames[i] = (string) Arr.GetValue(0);

					OneAdapKey.Close();
					LinkageKey.Close();

					DevName = AllAdapterNames[i].Substring(0,8) + 
						"NPF_" +
						AllAdapterNames[i].Substring(8,AllAdapterNames[i].Length - 8);

					MessageBox.Show( DevName );
					PacketOpenAdapter( DevName );
					if( mAdapter.hFile == 0 )
					{
						MessageBox.Show( DevName + " failed" );
						AllAdapterNames[i] = "";
						continue;
					}

					MessageBox.Show( DevName + " successed" );
					AllDescriptions[i] = GetVendorDescription();
					PacketCloseAdapter();

				}
	
				AdapKey.Close();

				if( SubKeys == null ) k = 0;
				k = SubKeys.GetLength(0);
				
				if( k == 0 )
				{
					LinkageKey = Registry.LocalMachine.OpenSubKey("SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Linkage", false );
					if( LinkageKey != null )
					{
						oValue = LinkageKey.GetValue( "bind" );
						LinkageKey.Close();
					}
					else
					{
						mPacketErrorMessage = "Can not find TCP/IP bindings.\nIn order to run the packet capture driver you must install TCP/IP.";;
						return false;
					}
				}

				int cnt = 0;
				for( i = 0; i < AllAdapterNames.GetLength(0); i ++ )
					if( AllAdapterNames[i] != "" ) cnt ++;

				mAdapterNames = new string[ cnt ];
				mAdapterDescriptions = new string[ cnt ];
			
				cnt = 0;
				for( i = 0; i < AllAdapterNames.GetLength(0); i ++ )
				{
					if( AllAdapterNames[i] != "" )
					{
						mAdapterNames[cnt] = AllAdapterNames[i];
						mAdapterDescriptions[cnt] = AllDescriptions[i];
						cnt ++;
					}
				}

			}
			catch( Exception Ex )
			{
				mPacketErrorMessage = Function.ReturnErrorMessage( Ex );
				return false;
			}

			mPacketErrorMessage = "";
			return true;

		}

		//****************************************************************
		//
		//****************************************************************

		private string CheckAdapterName( string pAdapterName )
		{
			string AdapterName = "";

			if( pAdapterName.IndexOf("NPF_") <= 0 )
			{
				AdapterName = pAdapterName.Substring(0,8) + 
					"NPF_" +
					pAdapterName.Substring(8,pAdapterName.Length - 8);	
			}
			else
				AdapterName = pAdapterName;

			return AdapterName;
		}

		//****************************************************************
		//
		//****************************************************************

		private int CheckDriverInstallStatus()
		{
			RegistryKey PathKey;
			int Result = 0;

			// check if the NPF registry key is already present
			// this means that the driver is already installed and that we don't need to call PacketInstallDriver
			PathKey = Registry.LocalMachine.OpenSubKey(	mNPFRegistryLocation );
			if( PathKey == null )
			{
				Result = PacketInstallDriver() ? 1 : 0;
			}
			else
			{
				Result = 1;
				PathKey.Close();
			}

			return Result;
		}

		//****************************************************************
		//
		//****************************************************************

		private void InitAdapter()
		{
			mAdapter.hFile = 0;
			mAdapter.NumWrites = 0;
			mAdapter.ReadEvent = 0;
			mAdapter.ReadTimeOut = 0;
		}

		//****************************************************************
		//
		//****************************************************************

		public bool PacketOpenAdapter( string pAdapterName )
		{
			int Result = 0;
			int error = 0;
			RegistryKey PathKey;
			WinService.SERVICE_STATUS SStat;
			int QuerySStat = 0;
			char [] SymbolicLink = new char[128];
			string AdapterName = "";


			SStat.dwCheckPoint = 0;
			SStat.dwControlsAccepted = 0;
			SStat.dwCurrentState = 0;
			SStat.dwServiceSpecificExitCode = 0;
			SStat.dwServiceType = 0;
			SStat.dwWaitHint = 0;
			SStat.dwWin32ExitCode = 0;

			AdapterName = CheckAdapterName( pAdapterName );

			mScmHandle = WinService.OpenSCManager( 0, 0, WinService.SC_MANAGER_ALL_ACCESS );
	
			if( mScmHandle == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
			}
			else
			{
				//Result = CheckDriverInstallStatus();
				// check if the NPF registry key is already present
				// this means that the driver is already installed and that we don't need to call PacketInstallDriver
				PathKey = Registry.LocalMachine.OpenSubKey(	mNPFRegistryLocation );
				if( PathKey == null )
				{
					Result = PacketInstallDriver() ? 1 : 0;
				}
				else
				{
					Result = 1;
					PathKey.Close();
				}
		
				if( Result > 0 ) 
				{
					IntPtr IPtr = Marshal.StringToCoTaskMemUni( mNPFServiceName );
					int mNPFServiceNamePtr = ( int  ) IPtr;
					mSrvHandle = WinService.OpenService( mScmHandle, mNPFServiceNamePtr , WinService.SERVICE_START | WinService.SERVICE_QUERY_STATUS );
					Marshal.FreeCoTaskMem( IPtr );
					if( mSrvHandle != 0 )
					{
						QuerySStat = WinService.QueryServiceStatus( mSrvHandle, ref SStat );
						if( QuerySStat == 0 || SStat.dwCurrentState != WinService.SERVICE_RUNNING)
						{
							if( WinService.StartService( mSrvHandle, 0, 0) == 0 )
							{ 
								mPacketErrorCode = Function.GetLastError();
								if( mPacketErrorCode > 0 )
									mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
								if( error != WinService.ERROR_SERVICE_ALREADY_RUNNING && error != ERROR_ALREADY_EXISTS )
								{
									Function.SetLastError( error );
									if( mScmHandle != 0 ) 
										WinService.CloseServiceHandle( mScmHandle );
									mPacketErrorCode = Function.GetLastError();
									if( mPacketErrorCode > 0 )
										mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
									return false;
								}
							}				
						}

						WinService.CloseServiceHandle( mSrvHandle );
						mSrvHandle = 0;

					}
					else
					{
						mPacketErrorCode = Function.GetLastError();
						if( mPacketErrorCode > 0 )
							mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
					}
				}
				else
				{
					if( PathKey != null )
						Result = PacketInstallDriver() ? 1 : 0;
					else
						Result = 1;
			
					if( Result > 0 )
					{
						IntPtr IPtr = Marshal.StringToCoTaskMemUni( mNPFServiceName );
						int mNPFServiceNamePtr = ( int  ) IPtr;
						mSrvHandle = WinService.OpenService( mScmHandle, mNPFServiceNamePtr , WinService.SERVICE_START );
						if( mSrvHandle != 0 )
						{
							QuerySStat = WinService.QueryServiceStatus( mSrvHandle, ref SStat);
							if( QuerySStat == 0 || SStat.dwCurrentState != WinService.SERVICE_RUNNING )
							{
								if( WinService.StartService( mSrvHandle, 0, 0 ) == 0 )
								{ 
									mPacketErrorCode = Function.GetLastError();
									if( mPacketErrorCode > 0 )
										mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
									if( error != WinService.ERROR_SERVICE_ALREADY_RUNNING && error != ERROR_ALREADY_EXISTS )
									{
										Function.SetLastError(error);
										if( mScmHandle != 0) WinService.CloseServiceHandle( mScmHandle );
										return false;
									}
								}
							}
				    
							WinService.CloseServiceHandle( mSrvHandle );
							mSrvHandle = 0;

						}
						else
						{
							mPacketErrorCode = Function.GetLastError();
							if( mPacketErrorCode > 0 )
								mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
						}
					}
				}
			}

			if( mScmHandle != 0) WinService.CloseServiceHandle( mScmHandle );

			mAdapter.NumWrites = 1;

			string Symb = "\\\\.\\" + AdapterName.Substring( 8 , AdapterName.Length - 8 );
			SymbolicLink = Symb.ToCharArray();
			//try if it is possible to open the adapter immediately
			int RetHandle = CreateFile( SymbolicLink , 
										(int) ( GENERIC_WRITE | GENERIC_READ ),
										0,
										0,
										(int) OPEN_EXISTING,
										0,
										0 );
	
			mPacketErrorCode = Function.GetLastError();
			if( mPacketErrorCode > 0 )
				mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );

			if( ( RetHandle != WinService.INVALID_HANDLE_VALUE ) || ( RetHandle > 0 )) 
			{
				mAdapter.hFile = RetHandle;
				if( PacketSetReadEvt() == false )
				{
					mPacketErrorCode = Function.GetLastError();
					if( mPacketErrorCode > 0 )
						mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
					//set the error to the one on which we failed
					Function.SetLastError(error);
					InitAdapter();
					return false;
				}		
		
				PacketSetMaxLookAheadSize();
				return true;
			}


			mPacketErrorCode = Function.GetLastError();
			if( mPacketErrorCode > 0 )
				mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
			//set the error to the one on which we failed
			Function.SetLastError( error );
			InitAdapter();
			return false;

		}

		//****************************************************************
		//
		//****************************************************************

		/*public void PacketCheckRegistry()
		{
			RegistryKey RKey;
			RegistryKey RKey2;
			RegistryKey RKey3;
			int ServiceManager = 0;
			int ServiceHandle = 0;
			int result = 0;
			IntPtr IPtr1 = Marshal.StringToCoTaskMemUni( mNPFServiceName );
			IntPtr IPtr2 = Marshal.StringToCoTaskMemUni( mNPFServiceDesc );
			IntPtr IPtr3 = Marshal.StringToCoTaskMemUni( mNPFDriverPath );
			int mNPFServiceNamePtr = ( int ) IPtr1;
			int mNPFServiceDescPtr = ( int ) IPtr2;
			int mNPFDriverPathPtr = ( int ) IPtr3;
			string mLegacyNPFRegistryLocation = "SYSTEM\\CurrentControlSet\\Enum\\Root\\LEGACY_NPF";


			RKey = Registry.LocalMachine.CreateSubKey( mNPFRegistryLocation );
			if( RKey != null )
			{
				if( RKey.GetValue("DisplayName") == null )
					RKey.SetValue( "DisplayName" , mNPFServiceDesc );

				if( RKey.GetValue("ErrorControl") == null )
					RKey.SetValue( "ErrorControl" , 1 );

				if( RKey.GetValue("ImagePath") == null )
					RKey.SetValue( "ImagePath" , mNPFDriverPath );

				if( RKey.GetValue("Start") == null )
					RKey.SetValue( "Start" , 3 );

				if( RKey.GetValue("Type") == null )
					RKey.SetValue( "Type" , 1 );

				RKey2 = RKey.CreateSubKey( "Enum" );
				if( RKey2 != null )
				{
					if( RKey2.GetValue("0") == null )
						RKey2.SetValue( "0" , "Root\\LEGACY_NPF\\0000" );

					if( RKey2.GetValue("Count") == null )
						RKey2.SetValue( "Count" , 1 );

					if( RKey2.GetValue("NextInstance") == null )
						RKey2.SetValue( "NextInstance" , 1 );

					RKey2.Close();
				}

				RKey.Close();
				RKey = null;
			}

			try
			{
				RegistryPermission f = new RegistryPermission(
					RegistryPermissionAccess.AllAccess , 
					mLegacyNPFRegistryLocation );
				RKey = Registry.LocalMachine.CreateSubKey( mLegacyNPFRegistryLocation );
			}
			catch( Exception Ex )
			{
				MessageBox.Show( Function.ReturnErrorMessage( Ex ) );
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				MessageBox.Show( mPacketErrorMessage );
				RKey = null;
			}

			if( RKey != null )
			{
				if( RKey.GetValue("NextInstance") == null )
					RKey.SetValue( "NextInstance" , 1 );

				RKey2 = RKey.CreateSubKey( "0000" );
				if( RKey2 != null )
				{
					MessageBox.Show("Registry key was created ( 0000 ) ... " );
					if( RKey2.GetValue("Capabilities") == null )
						RKey2.SetValue( "Capabilities" , 0 );

					if( RKey2.GetValue("Class") == null )
						RKey2.SetValue( "Class" , "LegacyDriver" );

					if( RKey2.GetValue("ClassGUID") == null )
						RKey2.SetValue( "ClassGUID" , "{8ECC055D-047F-11D1-A537-0000F8753ED1}" );

					if( RKey2.GetValue("ConfigFlags") == null )
						RKey2.SetValue( "ConfigFlags" , 0 );

					if( RKey2.GetValue("DeviceDesc") == null )
						RKey2.SetValue( "DeviceDesc" , mNPFServiceDesc );

					if( RKey2.GetValue("Legacy") == null )
						RKey2.SetValue( "Legacy" , 1 );

					if( RKey2.GetValue("Service") == null )
						RKey2.SetValue( "Service" , "NPF" );

					RKey3 = RKey2.CreateSubKey( "Control" );
					if( RKey3 != null )
					{
						MessageBox.Show("Registry key was created ( control ) ... " );
						if( RKey3.GetValue("ActiveService") == null )
							RKey3.SetValue( "ActiveService" , "NPF" );

						if( RKey3.GetValue("DeviceReference") == null )
							RKey3.SetValue( "DeviceReference" , 0xfcdb7d10 );

						RKey3.Close();
					}

					RKey2.Close();

				}

				RKey.Close();
			}


			ServiceManager = WinService.OpenSCManager( 0, 0, WinService.SC_MANAGER_ALL_ACCESS );

			if( ServiceManager != 0 )
			{
				ServiceHandle = WinService.CreateService( ServiceManager,
					mNPFServiceNamePtr,
					mNPFServiceDescPtr,
					WinService.SERVICE_ALL_ACCESS,
					WinService.SERVICE_KERNEL_DRIVER,
					WinService.SERVICE_DEMAND_START,
					WinService.SERVICE_ERROR_NORMAL,
					mNPFDriverPathPtr,
					0, 0, 0, 0, 0);

				if( ServiceHandle == 0 ) 
				{
					if( Function.GetLastError() == WinService.ERROR_SERVICE_EXISTS ) 
					{
						//npf.sys already existed
						result = 1;
					}
				}
				else 
				{
					//Created service for npf.sys
					result = 1;
				}
				if( result == 1 ) 
					if( ServiceHandle != 0 )
						WinService.CloseServiceHandle( ServiceHandle );

				if( result == 0 )
				{
					mPacketErrorCode = Function.GetLastError();
					if( mPacketErrorCode > 0 )
						mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				}

				WinService.CloseServiceHandle( ServiceManager );
			}
			
			Marshal.FreeCoTaskMem( IPtr1 );
			Marshal.FreeCoTaskMem( IPtr2 );
			Marshal.FreeCoTaskMem( IPtr3 );

		}*/


		public bool PacketInstallDriver()
		{
			int result = 0;
			IntPtr IPtr1 = Marshal.StringToCoTaskMemUni( mNPFServiceName );
			IntPtr IPtr2 = Marshal.StringToCoTaskMemUni( mNPFServiceDesc );
			IntPtr IPtr3 = Marshal.StringToCoTaskMemUni( mNPFDriverPath );
			int mNPFServiceNamePtr = ( int ) IPtr1;
			int mNPFServiceDescPtr = ( int ) IPtr2;
			int mNPFDriverPathPtr = ( int ) IPtr3;

			//PacketCheckRegistry();

			mSrvHandle = WinService.CreateService( mScmHandle,
				mNPFServiceNamePtr,
				mNPFServiceDescPtr,
				WinService.SERVICE_ALL_ACCESS,
				WinService.SERVICE_KERNEL_DRIVER,
				WinService.SERVICE_DEMAND_START,
				WinService.SERVICE_ERROR_NORMAL,
				mNPFDriverPathPtr,
				0, 0, 0, 0, 0);
			if( mSrvHandle == 0 ) 
			{
				if( Function.GetLastError() == WinService.ERROR_SERVICE_EXISTS ) 
				{
					//npf.sys already existed
					result = 1;
				}
			}
			else 
			{
				//Created service for npf.sys
				result = 1;
			}
			if( result == 1 ) 
				if( mSrvHandle != 0 )
					WinService.CloseServiceHandle( mSrvHandle );

			if( result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
			}
			
			Marshal.FreeCoTaskMem( IPtr1 );
			Marshal.FreeCoTaskMem( IPtr2 );
			Marshal.FreeCoTaskMem( IPtr3 );

			return ( result > 0 ? true : false );
	
		}

		/*public bool PacketInstallDriver()
		{
			int result = 0;
			int mNPFServiceNamePtr = Function.AddressOf( mNPFServiceName );
			int mNPFServiceDescPtr = Function.AddressOf( mNPFServiceDesc );
			int mNPFDriverPathPtr = Function.AddressOf( mNPFDriverPath );
	
	
			mSrvHandle = WinService.CreateService( mScmHandle, //ascmHandle, 
				mNPFServiceNamePtr,
				mNPFServiceDescPtr,
				WinService.SERVICE_ALL_ACCESS,
				WinService.SERVICE_KERNEL_DRIVER,
				WinService.SERVICE_DEMAND_START,
				WinService.SERVICE_ERROR_NORMAL,
				mNPFDriverPathPtr,
				0, 0, 0, 0, 0);
			if( mSrvHandle == 0 ) 
			{
				if( Function.GetLastError() == WinService.ERROR_SERVICE_EXISTS ) 
				{
					//npf.sys already existed
					result = 1;
				}
			}
			else 
			{
				//Created service for npf.sys
				result = 1;
			}
			if( result == 1 ) 
				if( mSrvHandle != 0 )
					WinService.CloseServiceHandle( mSrvHandle );

			if( result == 0 )
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
			}
			
			return ( result > 0 ? true : false );
	
		}*/

		//****************************************************************
		//
		//****************************************************************

		public bool PacketSetReadEvt()
		{
			int BytesReturned = 0, ReturnHandle = 0;
			byte [] EventName = new byte[39], EventArray = new byte[21] ;
			string EvName = "";
			int Result = 0, EvNamePtr = 0, i = 0;

			// retrieve the name of the shared event from the driver
			Result = DeviceIoControl( mAdapter.hFile,
									pBIOCEVNAME,
									EventName,
									EventName.GetLength(0),
									EventName,
									EventName.GetLength(0),
									ref BytesReturned,
									0 );

			if( Result == 0 ) 
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				return false;
			}

			EvName = Encoding.Unicode.GetString( EventName );
			EvName = "Global\\" + EvName; // NPF0000000XXX EventName
			for( i = 0; i < 20; i ++ )
				EventArray[i] = (byte) EvName[i];
			EventArray[20] = 0;
			IntPtr IPtr = Marshal.AllocCoTaskMem( 22 );
			Marshal.Copy( EventArray , 0 , IPtr , 21 );
			EvNamePtr = ( int ) IPtr;
			Function.SetLastError( 0 );
			// open the shared event
			ReturnHandle = CreateEvent(  0, 0, 1, EvNamePtr );

			mPacketErrorCode = Function.GetLastError();
			if( mPacketErrorCode > 0 )
				mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );

			// in NT4 "Global\" is not automatically ignored: try to use simply the event name
			if( mPacketErrorCode != ERROR_ALREADY_EXISTS )
			{
				if( mAdapter.ReadEvent != 0 )
					CloseHandle( ReturnHandle );
		
				mAdapter.ReadEvent = 0;
				// open the shared event
				ReturnHandle = CreateEvent( 0, 0, 1, EvNamePtr + 7 );

				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );

				if( mPacketErrorCode != ERROR_ALREADY_EXISTS )
				{
					if( mAdapter.ReadEvent != 0 )
						CloseHandle( ReturnHandle );

					mAdapter.ReadEvent = 0;
					Marshal.FreeCoTaskMem( IPtr );
					return false;
				}
				
				mAdapter.ReadEvent = ReturnHandle;
				mAdapter.ReadTimeOut = 0;

				Marshal.FreeCoTaskMem( IPtr );

				return false;

			}	

			mAdapter.ReadTimeOut = 0;
			mAdapter.ReadEvent = ReturnHandle;

			Marshal.FreeCoTaskMem( IPtr );

			return true;
		}


		/*public bool PacketSetReadEvt()
		{
			int BytesReturned = 0, ReturnHandle = 0;
			byte [] EventName = new byte[39], EventArray = new byte[21] ;
			string EvName = "";
			int Result = 0, EvNamePtr = 0, EventNamePtr = 0, i = 0;

			// retrieve the name of the shared event from the driver
			EventNamePtr = Function.AddressOf( EventName );
			Result = DeviceIoControl( mAdapter.hFile,
				pBIOCEVNAME,
				EventName,
				EventName.GetLength(0),
				EventName,
				EventName.GetLength(0),
				ref BytesReturned,
				0 );

			if( Result == 0 ) 
			{
				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );
				return false;
			}

			EvName = Encoding.Unicode.GetString( EventName );
			EvName = "Global\\" + EvName; // NPF0000000XXX EventName
			for( i = 0; i < 20; i ++ )
				EventArray[i] = (byte) EvName[i];
			EventArray[20] = 0;
			EvNamePtr = Function.AddressOf( EventArray );
			Function.SetLastError( 0 );
			// open the shared event
			ReturnHandle = CreateEvent(  0, 0, 1, EvNamePtr );

			mPacketErrorCode = Function.GetLastError();
			if( mPacketErrorCode > 0 )
				mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );

			// in NT4 "Global\" is not automatically ignored: try to use simply the event name
			if( mPacketErrorCode != ERROR_ALREADY_EXISTS )
			{
				if( mAdapter.ReadEvent != 0 )
					CloseHandle( ReturnHandle );
		
				mAdapter.ReadEvent = 0;
				// open the shared event
				ReturnHandle = CreateEvent( 0, 0, 1, EvNamePtr + 7 );

				mPacketErrorCode = Function.GetLastError();
				if( mPacketErrorCode > 0 )
					mPacketErrorMessage = Function.GetSystemErrorMessage( mPacketErrorCode );

				if( mPacketErrorCode != ERROR_ALREADY_EXISTS )
				{
					if( mAdapter.ReadEvent != 0 )
						CloseHandle( ReturnHandle );

					mAdapter.ReadEvent = 0;
					return false;
				}
				
				mAdapter.ReadEvent = ReturnHandle;
				mAdapter.ReadTimeOut = 0;

				return false;

			}	

			mAdapter.ReadTimeOut = 0;
			mAdapter.ReadEvent = ReturnHandle;

			return true;
		}*/

		//****************************************************************
		//
		//****************************************************************

		public int MAKEWORD( int low , int high)
		{
			return ((int)(((byte)(low)) | ((int)((byte)(high))) << 8));
		}

		//****************************************************************
		//
		//****************************************************************

		public int WinSockInit()
		{
			int wVersionRequested;
			WSADATA wsaData;
			int err;

			wsaData.iMaxSockets = 0;
			wsaData.iMaxUdpDg = 0;
			wsaData.lpVendorInfo = IntPtr.Zero;
			wsaData.szDescription = new char[ WSADESCRIPTION_LEN + 1 ];
			wsaData.szSystemStatus = new char[ WSASYS_STATUS_LEN + 1 ];
			wsaData.wHighVersion = 0;
			wsaData.wVersion = 0;

			wVersionRequested = MAKEWORD( 1, 1); 
			err = WSAStartup( wVersionRequested, ref wsaData );
			if ( err != 0 )
			{
				return -1;
			}

			return 0;
		}

		//****************************************************************
		//
		//****************************************************************

		/// Alignment macro. Rounds up to the next even multiple of Packet_ALIGNMENT. 
		public static int Packet_WORDALIGN( int x )
		{ return (int) ( ((x) + (Packet_ALIGNMENT - 1))&~(Packet_ALIGNMENT - 1) ); }

		//****************************************************************
		//
		//****************************************************************


	}
}
