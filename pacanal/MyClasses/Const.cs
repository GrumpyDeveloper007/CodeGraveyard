using System;

namespace MyClasses
{

	public class Const
	{
		public const int LIST_VIEW_PACKET_NO_INDEX = 0;
		public const int LIST_VIEW_TIME_INDEX = 1;
		public const int LIST_VIEW_SOURCE_INDEX = 2;
		public const int LIST_VIEW_DESTINATION_INDEX = 3;
		public const int LIST_VIEW_PROTOCOL_INDEX = 4;
		public const int LIST_VIEW_INFO_INDEX = 5;

		public const int STR_ASCII_NULL_TERM = 0;
		public const int STR_ASCII_NO_NULL_TERM = 1;
		public const int STR_UNICODE_NULL_TERM = 2;
		public const int STR_UNICODE_NO_NULL_TERM = 3;
		public const int STR_NB_NAME_NULL = 4;
		public const int STR_NB_NAME_NORMAL = 5;
		public const int STR_NB_NAME_DECODE = 6;


		public const uint TCPDUMP_MAGIC = 0xa1b2c3d4;	//Libpcap magic number. Used by programs like tcpdump to recognize a driver's generated dump file.
		public const ushort PCAP_VERSION_MAJOR = 2;		//Major libpcap version of the dump file. Used by programs like tcpdump to recognize a driver's generated dump file.
		public const ushort PCAP_VERSION_MINOR = 4;		//Minor libpcap version of the dump file. Used by programs like tcpdump to recognize a driver's generated dump file.

		public const int LENGTH_OF_ARP				= 28;
		public const int LENGTH_OF_DCERPC			= 67;
		public const int LENGTH_OF_EIGRP			= 40;
		public const int LENGTH_OF_ETHERNET			= 14;
		public const int LENGTH_OF_INTERNET			= 20;
		public const int LENGTH_OF_ICMP				= 8;
		public const int LENGTH_OF_IPX				= 30;
		public const int LENGTH_OF_UDP				= 8;
		public const int LENGTH_OF_TCP				= 20;
		public const int LENGTH_OF_STP				= 35;

		public const int PROTOCOL_TYPE_NONE		= 0;
		public const int PROTOCOL_TYPE_ARP			= 1;
		public const int PROTOCOL_TYPE_CDP			= 2;
		public const int PROTOCOL_TYPE_DCERPC		= 3;
		public const int PROTOCOL_TYPE_DLSW		= 4;
		public const int PROTOCOL_TYPE_DNS			= 5;
		public const int PROTOCOL_TYPE_EIGRP		= 6;
		public const int PROTOCOL_TYPE_INTERNET	= 7;
		public const int PROTOCOL_TYPE_IPX			= 8;
		public const int PROTOCOL_TYPE_LLC			= 9;
		public const int PROTOCOL_TYPE_LOOPBACK	= 11;
		public const int PROTOCOL_TYPE_MSWBROWSER	= 11;
		public const int PROTOCOL_TYPE_MSWLOGON	= 12;
		public const int PROTOCOL_TYPE_NBDS		= 13;
		public const int PROTOCOL_TYPE_NBNS		= 14;
		public const int PROTOCOL_TYPE_NBSS		= 15;
		public const int PROTOCOL_TYPE_NETBIOS		= 16;
		public const int PROTOCOL_TYPE_SMB			= 17;
		public const int PROTOCOL_TYPE_SMBMAILSLOT = 18;
		public const int PROTOCOL_TYPE_STP			= 19;
		public const int PROTOCOL_TYPE_TB			= 20;
		public const int PROTOCOL_TYPE_TCP			= 21;
		public const int PROTOCOL_TYPE_UDP			= 22;


		public const int IPPROTO_IP              = 0;               // dummy for IP
		public const int IPPROTO_ICMP            = 1;               // control message protocol
		public const int IPPROTO_IGMP            = 2;               // internet group management protocol
		public const int IPPROTO_GGP             = 3;               // gateway^2 (deprecated)
		public const int IPPROTO_TCP             = 6;               // tcp
		public const int IPPROTO_PUP             = 12;              // pup
		public const int IPPROTO_UDP             = 17;              // user datagram protocol
		public const int IPPROTO_IDP             = 22;              // xns idp
		public const int IPPROTO_IPV6            = 41;              // IPv6
		public const int IPPROTO_ND              = 77;              // UNOFFICIAL net disk proto
		public const int IPPROTO_ICLFXBM         = 78;
		public const int IPPROTO_EIGRP           = 88;              // EIGRP

		public const int IPPROTO_RAW             = 255;             // raw IP packet
		public const int IPPROTO_MAX             = 256;

		public const int IPPORT_TIMESERVER       = 37;
		public const int IPPORT_NAMESERVER       = 42;
		public const int IPPORT_DNS              = 43;
		public const int IPPORT_MTP              = 57;
		public const int IPPORT_RJE              = 77;
		public const int IPPORT_FINGER           = 79;
		public const int IPPORT_HTTP2            = 8080;
		public const int IPPORT_SSDP             = 1031;
		public const int IPPORT_SSDP2            = 1032;
		public const int IPPORT_TTYLINK          = 87;
		public const int IPPORT_SUPDUP           = 95;
		public const int IPPORT_EPMEP			 = 135;
		public const int IPPORT_NBNS			 = 137;
		public const int IPPORT_NBDTGRM			 = 138;
		public const int IPPORT_NBSSN			 = 139;
		public const int IPPORT_EXECSERVER       = 512;
		public const int IPPORT_LOGINSERVER      = 513;
		public const int IPPORT_CMDSERVER        = 514;
		public const int IPPORT_WHOSERVER        = 513;
		public const int IPPORT_ROUTESERVER      = 520;


		public const int IPPORT_ECHO  = 7;// tcp	   udp
		public const int IPPORT_DISCARD  = 9; // tcp	   udp
		public const int IPPORT_SYSTAT  = 11; // tcp
		public const int IPPORT_DAYTIME  = 13; // tcp	   udp
		public const int IPPORT_NETSTAT  = 15; // tcp
		public const int IPPORT_QOTD  = 17; // tcp	   udp
		public const int IPPORT_CHARGEN  = 19; // tcp	   udp
		public const int IPPORT_FTP_DATA  = 20; // tcp
		public const int IPPORT_FTP  = 21; // tcp
		public const int IPPORT_TELNET  = 23; // tcp
		public const int IPPORT_SMTP  = 25; // tcp
		public const int IPPORT_TIME  = 37; // tcp	   udp
		public const int IPPORT_RLP  = 39; // udp
		public const int IPPORT_NAME  = 42; // tcp	   udp
		public const int IPPORT_WHOIS  = 43; // tcp
		public const int IPPORT_DOMAIN  = 53; // tcp	   udp
		public const int IPPORT_BOOTP  = 67; // udp
		public const int IPPORT_TFTP  = 69; // udp
		public const int IPPORT_HTTP  = 80; // tcp
		public const int IPPORT_LINK  = 87; // tcp
		public const int IPPORT_HOSTNAMES = 101; //tcp
		public const int IPPORT_ISP_TSAP = 102; //tcp
		public const int IPPORT_DICTIONARY = 103; //tcp
		public const int IPPORT_X400_SND = 104; //tcp
		public const int IPPORT_CSNET_NS = 105; //tcp
		public const int IPPORT_POP = 109; //tcp
		public const int IPPORT_POP3 = 110; //tcp
		public const int IPPORT_PORTMAP = 111; //tcp	   udp
		public const int IPPORT_AUTH = 113; //tcp
		public const int IPPORT_SFTP = 115; //tcp
		public const int IPPORT_PATH = 117; //tcp
		public const int IPPORT_NNTP = 119; //tcp
		public const int IPPORT_NTP = 123; //udp
		public const int IPPORT_NB_NAME = 137; //udp
		public const int IPPORT_NB_DATAGRAM = 138; //udp
		public const int IPPORT_NB_SESSION = 139; //tcp
		public const int IPPORT_NEWS = 144; //tcp
		public const int IPPORT_SGMP = 153; //udp
		public const int IPPORT_TCPREPO = 158; //tcp
		public const int IPPORT_SNMP = 161; //udp
		public const int IPPORT_SNMP_TRAP = 162; //udp
		public const int IPPORT_PRINT_SRV = 170; //tcp
		public const int IPPORT_VMNET = 175; //tcp
		public const int IPPORT_LOAD = 315; //udp
		public const int IPPORT_VMNET0 = 400; //tcp
		public const int IPPORT_HTTPS = 443; //tcp
		public const int IPPORT_SYTEK = 500; //udp
		public const int IPPORT_EXEC = 512; //tcp
		public const int IPPORT_BIFF = 512; //udp
		public const int IPPORT_LOGIN = 513; //tcp
		public const int IPPORT_WHO = 513; //udp
		public const int IPPORT_SHEL = 514; //tcp
		public const int IPPORT_SYSLOG = 514; //udp
		public const int IPPORT_PRINTER = 515; //tcp
		public const int IPPORT_TALK = 517; //udp
		public const int IPPORT_NTALK = 518; //udp
		public const int IPPORT_EFS = 520; //tcp
		public const int IPPORT_ROUTE = 520; //udp
		public const int IPPORT_TIMED = 525; //udp
		public const int IPPORT_TEMPO = 526; //tcp
		public const int IPPORT_COURIER = 530; //tcp
		public const int IPPORT_CONFERENCE = 531; //tcp
		public const int IPPORT_RVD_CONTROL = 531; //udp
		public const int IPPORT_NETNEWS = 532; //tcp
		public const int IPPORT_NETWALL = 533; //udp
		public const int IPPORT_UUCP = 540; //tcp
		public const int IPPORT_KLOGIN = 543; //tcp
		public const int IPPORT_KSHEL = 544; //tcp
		public const int IPPORT_NEW_RWHO = 550; //udp
		public const int IPPORT_REMOTEFS = 556; //tcp
		public const int IPPORT_RMONITOR = 560; //udp
		public const int IPPORT_MONITOR = 561; //udp
		public const int IPPORT_GARCON = 600; //tcp
		public const int IPPORT_MAITRD = 601; //tcp
		public const int IPPORT_BUSBOY = 602; //tcp
		public const int IPPORT_ACCTMASTER = 700; //udp
		public const int IPPORT_ACCTSLAVE = 701; //udp
		public const int IPPORT_ACCT = 702; //udp
		public const int IPPORT_ACCTLOGIN = 703; //udp
		public const int IPPORT_ACCTPRINTER = 704; //udp
		public const int IPPORT_ACCTINFO = 705; //udp
		public const int IPPORT_ACCTSLAVE2 = 706; //udp
		public const int IPPORT_ACCTDISK = 707; //udp
		public const int IPPORT_KERBEROS = 750; //tcp	   udp
		public const int IPPORT_KERBEROS_MASTER  = 751; //tcp	   udp
		public const int IPPORT_PASSWD_SERVER = 752; //udp
		public const int IPPORT_USERREG_SERVER = 753; //udp
		public const int IPPORT_KRB_PROP = 754; //tcp
		public const int IPPORT_ERRLOGIN = 888; //tcp
		public const int IPPORT_DLSW_UDP		= 2067;
		public const int IPPORT_DLSW_TCP		= 2065;


		public const ushort ETHERTYPE_PUP			= 0x0200;	// PUP protocol
		public const ushort ETHERTYPE_SPRITE		= 0x0500;
		public const ushort ETHERTYPE_NS			= 0x0600;
		public const ushort ETHERTYPE_TRAIL		= 0x1000;
		public const ushort ETHERTYPE_MOPDL		= 0x6001;
		public const ushort ETHERTYPE_MOPRC		= 0x6002;
		public const ushort ETHERTYPE_DN			= 0x6003;
		public const ushort ETHERTYPE_LAT			= 0x6004;
		public const ushort ETHERTYPE_SCA			= 0x6007;
		public const ushort ETHERTYPE_IP			= 0x0800;	// IP protocol
		public const ushort ETHERTYPE_ARP			= 0x0806;	// Addr. resolution protocol
		public const ushort ETHERTYPE_REVARP		= 0x8035;	// reverse Addr. resolution protocol
		public const ushort ETHERTYPE_LANBRIDGE	= 0x8038;
		public const ushort ETHERTYPE_DECDNS		= 0x803c;
		public const ushort ETHERTYPE_DECDTS		= 0x803e;
		public const ushort ETHERTYPE_VEXP		= 0x805b;
		public const ushort ETHERTYPE_VPROD		= 0x805c;
		public const ushort ETHERTYPE_ATALK		= 0x809b;
		public const ushort ETHERTYPE_AARP		= 0x80f3;
		public const ushort ETHERTYPE_8021Q		= 0x8100;
		public const ushort ETHERTYPE_IPX			= 0x8137;
		public const ushort ETHERTYPE_IPV6		= 0x86dd;
		public const ushort ETHERTYPE_LOOPBACK	= 0x9000;

		public const int NORMAL = 0;
		public const int VALUE = 1;

		public const uint PACKET_ALIGNMENT = 4; //sizeof(int);


		public const ushort ARPHRD_NETROM	= 0;		// from KA9Q: NET/ROM pseudo	
		public const ushort ARPHRD_ETHER 	= 1;		// Ethernet 10Mbps		
		public const ushort	ARPHRD_EETHER	= 2;		// Experimental Ethernet	
		public const ushort	ARPHRD_AX25		= 3;		// AX.25 Level 2		
		public const ushort	ARPHRD_PRONET	= 4;		// PROnet token ring		
		public const ushort	ARPHRD_CHAOS	= 5;		// Chaosnet			
		public const ushort	ARPHRD_IEEE802	= 6;		// IEEE 802.2 Ethernet/TR/TB	
		public const ushort	ARPHRD_ARCNET	= 7;		// ARCnet			
		public const ushort	ARPHRD_HYPERCH	= 8;		// Hyperchannel			
		public const ushort	ARPHRD_LANSTAR	= 9;		// Lanstar			
		public const ushort	ARPHRD_AUTONET	= 10;		// Autonet Short Address	
		public const ushort	ARPHRD_LOCALTLK	= 11;		// Localtalk			
		public const ushort	ARPHRD_LOCALNET	= 12;		// LocalNet (IBM PCNet/Sytek LocalNET) 
		public const ushort	ARPHRD_ULTRALNK	= 13;		// Ultra link			
		public const ushort	ARPHRD_SMDS		= 14;		// SMDS				
		public const ushort ARPHRD_DLCI		= 15;		// Frame Relay DLCI		
		public const ushort ARPHRD_ATM		= 16;		// ATM				
		public const ushort ARPHRD_HDLC		= 17;		// HDLC				
		public const ushort ARPHRD_FIBREC	= 18;		// Fibre Channel		
		public const ushort ARPHRD_ATM2225	= 19;		// ATM (RFC 2225)		
		public const ushort ARPHRD_SERIAL	= 20;		// Serial Line			
		public const ushort ARPHRD_ATM2		= 21;		// ATM				
		public const ushort ARPHRD_MS188220	= 22;		// MIL-STD-188-220		
		public const ushort ARPHRD_METRICOM	= 23;		// Metricom STRIP		
		public const ushort ARPHRD_IEEE1394	= 24;		// IEEE 1394.1995		
		public const ushort ARPHRD_MAPOS	= 25;		// MAPOS			
		public const ushort ARPHRD_TWINAX	= 26;		// Twinaxial			
		public const ushort ARPHRD_EUI_64	= 27;		// EUI-64			


		public const ushort ARPOP_REQUEST  = 1;       /* ARP request.  */
		public const ushort ARPOP_REPLY    = 2;       /* ARP reply.  */
		public const ushort ARPOP_RREQUEST = 3;       /* RARP request.  */
		public const ushort ARPOP_RREPLY   = 4;       /* RARP reply.  */
		public const ushort ARPOP_IREQUEST = 8;       /* Inverse ARP (RFC 1293) request.  */
		public const ushort ARPOP_IREPLY   = 9;       /* Inverse ARP reply.  */
		public const ushort ATMARPOP_NAK   = 10;      /* ATMARP NAK.  */


		public const string ETHERTYPE_PUP_STR		 = "PUP";
		public const string ETHERTYPE_IP_STR		 = "IP ( Internet Protocol )";
		public const string ETHERTYPE_ARP_STR		 = "ARP ( Address Resolution Protocol )";
		public const string ETHERTYPE_REVARP_STR	 = "RARP ( Reverse Address Resolution Protocol )";
		public const string ETHERTYPE_NS_STR		 = "NS ";
		public const string ETHERTYPE_SPRITE_STR	 = "SPRITE ";
		public const string ETHERTYPE_TRAIL_STR	 = "TRAIL ";
		public const string ETHERTYPE_MOPDL_STR	 = "MOPDL ";
		public const string ETHERTYPE_MOPRC_STR	 = "MOPRC ";
		public const string ETHERTYPE_DN_STR		 = "DN ";
		public const string ETHERTYPE_LAT_STR		 = "LAT ";
		public const string ETHERTYPE_SCA_STR		 = "SCA ";
		public const string ETHERTYPE_LANBRIDGE_STR = "LAN BRIDGE ";
		public const string ETHERTYPE_DECDNS_STR	 = "DEC DNS ";
		public const string ETHERTYPE_DECDTS_STR	 = "DEC TS ";
		public const string ETHERTYPE_VEXP_STR		 = "VEXP ";
		public const string ETHERTYPE_VPROD_STR	 = "VPROD ";
		public const string ETHERTYPE_ATALK_STR	 = "ATALK ( Apple Talk )";
		public const string ETHERTYPE_AARP_STR		 = "AARP ";
		public const string ETHERTYPE_8021Q_STR	 = "8021Q ";
		public const string ETHERTYPE_IPX_STR		 = "IPX ( Internet Packet Excahge )";
		public const string ETHERTYPE_IPV6_STR		 = "IPV6 ";
		public const string ETHERTYPE_LOOPBACK_STR	 = "LOOPBACK ";

		public const ushort TYPE_DEVICE_ID			= 0x0001;
		public const ushort TYPE_ADDRESS			= 0x0002;
		public const ushort TYPE_PORT_ID			= 0x0003;
		public const ushort TYPE_CAPABILITIES		= 0x0004;
		public const ushort TYPE_IOS_VERSION		= 0x0005;
		public const ushort TYPE_PLATFORM			= 0x0006;
		public const ushort TYPE_IP_PREFIX			= 0x0007;
		public const ushort TYPE_VTP_MGMT_DOMAIN    = 0x0009; // Guessed, from tcpdump
		public const ushort TYPE_NATIVE_VLAN        = 0x000a; // Guessed, from tcpdump
		public const ushort TYPE_DUPLEX             = 0x000b; // Guessed, from tcpdump


		public const byte PROTO_TYPE_NLPID	= 1;
		public const byte PROTO_TYPE_IEEE_802_2	= 2;


		public const byte NLPID_NULL			= 0x00;
		public const byte NLPID_IPI_T_70		= 0x01;	// T.70, when an IPI
		public const byte NLPID_SPI_X_29		= 0x01;	// X.29, when an SPI
		public const byte NLPID_X_633			= 0x03;	// X.633
		public const byte NLPID_Q_931			= 0x08;	// Q.931, Q.932, Q.933, X.36, ISO 11572, ISO 11582
		public const byte NLPID_Q_2931			= 0x09;	// Q.2931
		public const byte NLPID_Q_2119			= 0x0c;	// Q.2119
		public const byte NLPID_SNAP			= 0x80;
		public const byte NLPID_ISO8473_CLNP	= 0x81;	// X.233
		public const byte NLPID_ISO9542_ESIS	= 0x82;
		public const byte NLPID_ISO10589_ISIS	= 0x83;
		public const byte NLPID_ISO10747_IDRP   = 0x85;
		public const byte NLPID_ISO9542X25_ESIS	= 0x8a;
		public const byte NLPID_ISO10030		= 0x8c;
		public const byte NLPID_ISO11577		= 0x8d;	// X.273
		public const byte NLPID_IP6				= 0x8e;
		public const byte NLPID_COMPRESSED		= 0xb0;	// "Data compression protocol"
		public const byte NLPID_SNDCF			= 0xc1;	// "SubNetwork Dependent Convergence Function
		public const byte NLPID_IP				= 0xcc;
		public const byte NLPID_PPP				= 0xcf;


		public const ushort FLAGS_RESPONSE = 0x8000;
		public const ushort FLAGS_TRUNCATED = 0x0200;
		public const ushort FLAGS_RECURSION_DESIRED = 0x0100;
		public const ushort FLAGS_BROADCAST = 0x0010;
		public const ushort FLAGS_AUTHORITATIVE = 0x0400;
		public const ushort FLAGS_RECURSION_AVAILABLE = 0x0080;

		public const int IPPORT_NETBIOS_NS		 = 137;
		public const int IPPORT_NETBIOS_DATAGRAM = 138;
		public const int IPPORT_NETBIOS_SSN      = 139;

		public const ushort SOCKET_TYPE_SAP = 0x0452;

		public const byte PACKET_TYPE_SPX = 5;
		public const byte PACKET_TYPE_NCP = 17;

		public const int UDP_PORT_LLC1    = 12000;
		public const int UDP_PORT_LLC2    = 12001;
		public const int UDP_PORT_LLC3    = 12002;
		public const int UDP_PORT_LLC4    = 12003;
		public const int UDP_PORT_LLC5    = 12004;


		public const byte SAP_MASK	 = 0xFE;
		public const byte DSAP_GI_BIT	= 0x01;
		public const byte SSAP_CR_BIT	= 0x01;


		public const byte XDLC_I		= 0x00;	// Information frames
		public const byte XDLC_S		= 0x01; // Supervisory frames
		public const byte XDLC_U		= 0x03;	// Unnumbered frames

		 // U-format modifiers.
		public const byte XDLC_U_MODIFIER_MASK	= 0xEC;

		public const byte XDLC_UI		= 0x00	; // Unnumbered Information 
		public const byte XDLC_UP		= 0x20	; // Unnumbered Poll 
		public const byte XDLC_DISC	= 0x40	; // Disconnect (command) 
		public const byte XDLC_RD		= 0x40	; // Request Disconnect (response) 
		public const byte XDLC_UA		= 0x60	; // Unnumbered Acknowledge 
		public const byte XDLC_SNRM	= 0x80	; // Set Normal Response Mode 
		public const byte XDLC_TEST	= 0xE0	; // Test 
		public const byte XDLC_SIM	= 0x04	; // Set Initialization Mode (command) 
		public const byte XDLC_RIM	= 0x04	; // Request Initialization Mode (response) 
		public const byte XDLC_FRMR	= 0x84	; // Frame reject 
		public const byte XDLC_CFGR	= 0xC4	; // Configure 
		public const byte XDLC_SARM	= 0x0C	; // Set Asynchronous Response Mode (command) 
		public const byte XDLC_DM		= 0x0C	; // Disconnected mode (response) 
		public const byte XDLC_SABM	= 0x2C	; // Set Asynchronous Balanced Mode 
		public const byte XDLC_SARME	= 0x4C	; // Set Asynchronous Response Mode Extended 
		public const byte XDLC_SABME	= 0x6C	; // Set Asynchronous Balanced Mode Extended 
		public const byte XDLC_RESET	= 0x8C	; // Reset 
		public const byte XDLC_XID	= 0xAC	; // Exchange identification 
		public const byte XDLC_SNRME	= 0xCC	; // Set Normal Response Mode Extended 
		public const byte XDLC_BCN	= 0xEC	; // Beacon 


		//N(S) and N(R) fields, in basic and extended operation.
		public const ushort XDLC_N_R_MASK		= 0xE0;	// basic
		public const ushort XDLC_N_R_SHIFT		= 5;
		public const ushort XDLC_N_R_EXT_MASK	= 0xFE00;	// extended
		public const ushort XDLC_N_R_EXT_SHIFT	= 9;
		public const ushort XDLC_N_S_MASK		= 0x0E;	// basic
		public const ushort XDLC_N_S_SHIFT		= 1;
		public const ushort XDLC_N_S_EXT_MASK	= 0x00FE;	// extended
		public const ushort XDLC_N_S_EXT_SHIFT	= 1;

		//Poll/Final bit, in basic and extended operation.
		public const ushort XDLC_P_F	= 0x10;	// basic
		public const ushort XDLC_P_F_EXT	= 0x0100;	// extended

		//S-format frame types.
		public const ushort XDLC_S_FTYPE_MASK	= 0x0C;
		public const ushort XDLC_RR			= 0x00;	// Receiver ready
		public const ushort XDLC_RNR		= 0x04;	// Receiver not ready
		public const ushort XDLC_REJ		= 0x08;	// Reject
		public const ushort XDLC_SREJ		= 0x0C;	// Selective reject

		public const uint OUI_ENCAP_ETHER	= 0x000000;	// encapsulated Ethernet
		public const uint OUI_CISCO	= 0x00000C;	// Cisco (future use)
		public const uint OUI_CISCO_90	= 0x0000F8;	// Cisco (IOS 9.0 and above?)
		public const uint OUI_BRIDGED	= 0x0080C2;	// Bridged Frame-Relay, RFC 2427 and Bridged ATM, RFC 2684
		public const uint OUI_ATM_FORUM	 = 0x00A03E;	// ATM Foru
		public const uint OUI_CABLE_BPDU	= 0x00E02F;	// DOCSIS spanning tree BPDU
		public const uint OUI_APPLE_ATALK	= 0x080007;	// Appletalk

		public const byte LLCSAP_NULL	= 0x00;
		public const byte LLCSAP_GLOBAL	= 0xff;
		public const byte LLCSAP_8021B_I	= 0x02;
		public const byte LLCSAP_8021B_G	= 0x03;
		public const byte LLCSAP_IP	= 0x06;
		public const byte LLCSAP_PROWAYNM	= 0x0e;
		public const byte LLCSAP_8021D	= 0x42;
		public const byte LLCSAP_RS511	= 0x4e;
		public const byte LLCSAP_ISO8208	= 0x7e;
		public const byte LLCSAP_PROWAY	= 0x8e;
		public const byte LLCSAP_SNAP	= 0xaa;
		public const byte LLCSAP_IPX	= 0xe0;
		public const byte LLCSAP_NETBEUI	= 0xf0;
		public const byte LLCSAP_ISONS	= 0xfe;

		public const byte LLC_TYPE_LSAP = 0x00;
		public const byte LLC_TYPE_SMAN_FUNCTION_I = 0x02;
		public const byte LLC_TYPE_SMAN_FUNCTION_G = 0x03;
		public const byte LLC_TYPE_IBM_SNA_PATH_CTRL_I = 0x04;
		public const byte LLC_TYPE_IBM_SNA_PATH_CTRL_G = 0x05;
		public const byte LLC_TYPE_ARPANET_IP = 0x06;
		public const byte LLC_TYPE_SNA_CSNA_EPROWAY = 0x08;
		public const byte LLC_TYPE_TEXAS_INSTRUMENTS = 0x18;
		public const byte LLC_TYPE_STP = 0x42;
		public const byte LLC_TYPE_EIA_MMS = 0x4E;
		public const byte LLC_TYPE_X25_OVER_LLC2 = 0x7E;
		public const byte LLC_TYPE_XNS = 0x80;
		public const byte LLC_TYPE_NESTAR = 0x86;
		public const byte LLC_TYPE_PROWAY = 0x8E;
		public const byte LLC_TYPE_ARPANET_ARP = 0x98;
		public const byte LLC_TYPE_BANYAN_VINES = 0xBC;
		public const byte LLC_TYPE_SNAP = 0xAA;
		public const byte LLC_TYPE_NOVELL_NETWARE = 0xE0;
		public const byte LLC_TYPE_IBM_NETBIOS = 0xF0;
		public const byte LLC_TYPE_IBM_LANMAN_I = 0xF4;
		public const byte LLC_TYPE_IBM_LANMAN_G = 0xF5;
		public const byte LLC_TYPE_IBM_RPL = 0xF8;
		public const byte LLC_TYPE_UNGERMANN_BASS = 0xFA;
		public const byte LLC_TYPE_ISO_NLP = 0xFE;
		public const byte LLC_TYPE_GLOBAL_LSAP = 0xFF;

		public const int PACKET_ORGANIZATION_CISCO = 0x0000000C;

		public const byte NBDS_DIRECT_UNIQUE	= 0x10;
		public const byte NBDS_DIRECT_GROUP	= 0x11;
		public const byte NBDS_BROADCAST		= 0x12;
		public const byte NBDS_ERROR		= 0x13;
		public const byte NBDS_QUERY_REQUEST	= 0x14;
		public const byte NBDS_POS_QUERY_RESPONSE	= 0x15;
		public const byte NBDS_NEG_QUERY_RESPONSE	= 0x16;


		public const ushort UDP_PORT_NBNS	= 137;
		public const ushort UDP_PORT_NBDGM	= 138;
		public const ushort TCP_PORT_NBSS	= 139;
		public const ushort TCP_PORT_CIFS	= 445;

		// Bit fields in the flags 
		public const ushort FLAGS_OP_CODE				= (0xF<<11);       // query opcode 
		public const ushort OPCODE_SHIFT				= 11;
		public const ushort FLAGS_REPLY_CODE			= (0xF<<0);        // reply code 

		// type values  
		public const ushort TYPE_NB	= 0x0020; // NetBIOS name service RR 
		public const ushort TYPE_NBSTAT = 0x0021; // NetBIOS node status RR 

		public const ushort CLASS_INET	 = 1;		// the Internet
		public const ushort CLASS_CSNET	 = 2;		// CSNET (obsolete)
		public const ushort CLASS_CHAOS	 = 3;		// CHAOS
		public const ushort CLASS_HESIOD = 4;		// Hesiod
		public const ushort CLASS_NONE	 = 254;		// none
		public const ushort CLASS_ANY	 = 255;		// any
		public const ushort CLASS_FLUSH  = 0x8000;  // High bit is set for MDNS cache flush

		// Opcodes 
		public const byte OPCODE_QUERY          = 0;         // standard query
		public const byte OPCODE_REGISTRATION   = 5;         // registration
		public const byte OPCODE_RELEASE        = 6;         // release name
		public const byte OPCODE_WACK           = 7;         // wait for acknowledgement
		public const byte OPCODE_REFRESH        = 8;         // refresh registration
		public const byte OPCODE_REFRESHALT     = 9;         // refresh registration (alternate opcode)
		public const byte OPCODE_MHREGISTRATION = 15;        // multi-homed registration

		// Reply codes
		public const byte RCODE_NOERROR   = 0;
		public const byte RCODE_FMTERROR  = 1;
		public const byte RCODE_SERVFAIL  = 2;
		public const byte RCODE_NAMEERROR = 3;
		public const byte RCODE_NOTIMPL   = 4;
		public const byte RCODE_REFUSED   = 5;
		public const byte RCODE_ACTIVE    = 6;
		public const byte RCODE_CONFLICT  = 7;


		public const ushort	NB_FLAGS_MASK		= 0x6000;	// bits for node type 
		public const ushort	NB_FLAGS_B_NODE	= 0;	// B-mode node 
		public const ushort	NB_FLAGS_P_NODE	= 1;	// P-mode node 
		public const ushort	NB_FLAGS_M_NODE	= 2;	// M-mode node 
		public const ushort	NB_FLAGS_H_NODE	= 3;	// H-mode node 

		public const ushort	NB_FLAGS_G		= 0x8000;	// group name 

		public const ushort	NAME_FLAGS_PRM		= 0x0200;	// name is permanent node name 
		public const ushort	NAME_FLAGS_ACT		= 0x0400;	// name is active 
		public const ushort	NAME_FLAGS_CNF		= 0x0800;	// name is in conflict 
		public const ushort	NAME_FLAGS_DRG		= 0x1000;	// name is being deregistered 

		public const ushort	NAME_FLAGS_MASK		= 0x6000;	// bits for node type 
		public const ushort	NAME_FLAGS_B_NODE	= 0;	// B-mode node 
		public const ushort	NAME_FLAGS_P_NODE	= 1;	// P-mode node 
		public const ushort	NAME_FLAGS_M_NODE	= 2;	// M-mode node 

		public const ushort	NAME_FLAGS_G		= 0x8000;	// group name 


		public const byte SESSION_MESSAGE			= 0x00;
		public const byte SESSION_REQUEST			= 0x81;
		public const byte POSITIVE_SESSION_RESPONSE	= 0x82;
		public const byte NEGATIVE_SESSION_RESPONSE	= 0x83;
		public const byte RETARGET_SESSION_RESPONSE	= 0x84;
		public const byte SESSION_KEEP_ALIVE		= 0x85;

		public const byte NBSS_FLAGS_E			= 0x1;

		public const byte T_NB            = 32; // NetBIOS name service RR
		public const byte T_NBSTAT        = 33; // NetBIOS node status RR

		public const int F_OPCODE        = 0x7800; //0xF << 11 ); // query opcode


		/* Netbios command numbers */
		public const byte NB_ADD_GROUP		= 0x00;
		public const byte NB_ADD_NAME		= 0x01;
		public const byte NB_NAME_IN_CONFLICT	= 0x02;
		public const byte NB_STATUS_QUERY		= 0x03;
		public const byte NB_TERMINATE_TRACE_R	= 0x07;
		public const byte NB_DATAGRAM		= 0x08;
		public const byte NB_DATAGRAM_BCAST	= 0x09;
		public const byte NB_NAME_QUERY		= 0x0a;
		public const byte NB_ADD_NAME_RESP	= 0x0d;
		public const byte NB_NAME_RESP 		= 0x0e;
		public const byte NB_STATUS_RESP 		= 0x0f;
		public const byte NB_TERMINATE_TRACE_LR	= 0x13;
		public const byte NB_DATA_ACK		= 0x14;
		public const byte NB_DATA_FIRST_MIDDLE	= 0x15;
		public const byte NB_DATA_ONLY_LAST	= 0x16;
		public const byte NB_SESSION_CONFIRM	= 0x17;
		public const byte NB_SESSION_END		= 0x18;
		public const byte NB_SESSION_INIT		= 0x19;
		public const byte NB_NO_RECEIVE		= 0x1a;
		public const byte NB_RECEIVE_OUTSTANDING	= 0x1b;
		public const byte NB_RECEIVE_CONTINUE	= 0x1c;
		public const byte NB_KEEP_ALIVE		= 0x1f;


		public const byte SMB_CMD_CREATE_DIR = 0x00; // Create directory 
		public const byte SMB_CMD_DELETE_DIR =  0x01; //  Delete directory 
		public const byte SMB_CMD_OPEN_FILE = 0x02; //  Open file 
		public const byte SMB_CMD_CREATE_FILE = 0x03; //  Create file 
		public const byte SMB_CMD_CLOSE_FILE = 0x04; //  Close file 
		public const byte SMB_CMD_COMMIT_ALL_FILES = 0x05; //  Commit all files 
		public const byte SMB_CMD_DELETE_FILE = 0x06; //  Delete file 
		public const byte SMB_CMD_RENAME_FILE = 0x07; //  Rename file 
		public const byte SMB_CMD_GET_FILE_ATTRIBUTE = 0x08; //  Get file attribute 
		public const byte SMB_CMD_SET_FILE_ATTRIBUTE = 0x09; //  Set file attribute 
		public const byte SMB_CMD_READ_BYTE_BLOCK = 0x0a; //  Read byte block 
		public const byte SMB_CMD_WRITE_BYTE_BLOCK = 0x0b; //  Write byte block 
		public const byte SMB_CMD_LOCK_BYTE_BLOCK = 0x0c; //  Lock byte block 
		public const byte SMB_CMD_UNLOCK_BYTE_BLOCK = 0x0d; //  Unlock byte block 
		public const byte SMB_CMD_CREATE_NEW_FILE = 0x0f; //  Create new file 
		public const byte SMB_CMD_CHECK_DIR = 0x10; //  Check directory 
		public const byte SMB_CMD_END_OF_PROCESS = 0x11; //  End of process 
		public const byte SMB_CMD_LSEEK = 0x12; //  LSEEK 
		public const byte SMB_CMD_START_CONNECTION = 0x70; //  Start connection 
		public const byte SMB_CMD_END_CONNECTION = 0x71; //  End connection 
		public const byte SMB_CMD_VERIFY_DIALECT = 0x72; //  Verify dialect 
		public const byte SMB_CMD_GET_DISK_ATTRIBUTES = 0x80; //  Get disk attributes 
		public const byte SMB_CMD_SEARCH_MULTIPLE_FILES = 0x81; //  Search multiple files 
		public const byte SMB_CMD_CREATE_SPOOL_FILE = 0xc0; //  Create spool file 
		public const byte SMB_CMD_SPOOL_BYTE_BLOCK = 0xc1; //  Spool byte block 
		public const byte SMB_CMD_CLOSE_SPOOL_FILE = 0xc2; //  Close spool file 
		public const byte SMB_CMD_RETURN_PRINT_QUEUE = 0xc3; //  Return print queue 
		public const byte SMB_CMD_SEND_MESSAGE = 0xd0; //  Send message 
		public const byte SMB_CMD_SEND_BROADCAST = 0xd1; //  Send broadcast 
		public const byte SMB_CMD_FORWARD_USER_NAME = 0xd2; //  Forward user name 
		public const byte SMB_CMD_CANCEL_FORWARD = 0xd3; //  Cancel forward 
		public const byte SMB_CMD_GET_MACHINE_NAME = 0xd4; //  Get machine name 
		public const byte SMB_CMD_START_MULTI_BLOCK_MESSAGE = 0xd5; //  Start multi-block message 
		public const byte SMB_CMD_END_MULTI_BLOCK_MESSAGE = 0xd6; //  End multi-block message 
		public const byte SMB_CMD_MULTI_BLOCK_MESSAGE_TEXT = 0xd7; //  Multi-block message text 
		public const byte SMB_CMD_INVALID = 0xfe; //  Invalid 
		public const byte SMB_CMD_IMPLEMENTATION_DEPENDENT = 0xff; //  Implementation-dependant 

		// SMB Core Plus Commands

		public const byte SMB_CMD_LOCAK_THEN_READ_DATA = 0x13; // Lock then read data 
		public const byte SMB_CMD_WRITE_THEN_UNLOCK_DATA = 0x14; // Write then unlock data 
		public const byte SMB_CMD_READ_BLOCK_RAW = 0x1a; // Read block raw 
		public const byte SMB_CMD_WRITE_BLOCK_RAW = 0x1d; // Write block raw 

		//

		//LANMAN 1.0 SMB Commands
		public const byte SMB_CMD_READ_BLOCK_MULTIPLEXED = 0x1b; // Read block multiplexed 
		public const byte SMB_CMD_READ_BLOCK_SR = 0x1c; // Read block (secondary response) 
		public const byte SMB_CMD_WRITE_BLOCK_MULTIPLEXED = 0x1e; // Write block multiplexed 
		public const byte SMB_CMD_WRITE_BLOCK_SR = 0x1f; // Write block (secondary response) 
		public const byte SMB_CMD_WRITE_COMPLETE_RESPONSE = 0x20; // Write complete response 
		public const byte SMB_CMD_SET_FILE_ATTRIBUTES_EXPANDED = 0x22; // Set file attributes expanded 
		public const byte SMB_CMD_GET_FILE_ATTRIBUTES_EXPANDED = 0x23; // Get file attributes expanded 
		public const byte SMB_CMD_LOCK_UNLOCK_BYTE_RANGES_AND_X = 0x24; // Lock/unlock byte ranges and X 
		public const byte SMB_CMD_TRANSACTION = 0x25; // Transaction (name, bytes in/out) 
		public const byte SMB_CMD_TRANSACTION_SECONDARY = 0x26; // Transaction (secondary request/response) 
		public const byte SMB_CMD_PASS_IOCTL_TO_SERVER = 0x27; // Passes the IOCTL to the server 
		public const byte SMB_CMD_IOCTL = 0x28; // IOCTL (secondary request/response) 
		public const byte SMB_CMD_COPY = 0x29; // Copy 
		public const byte SMB_CMD_MOVE = 0x2a; // Move 
		public const byte SMB_CMD_ECHO = 0x2b; // Echo 
		public const byte SMB_CMD_WRITE_AND_CLOSE = 0x2c; // Write and Close 
		public const byte SMB_CMD_OPEN_AND_X = 0x2d; // Open and X 
		public const byte SMB_CMD_READ_AND_X = 0x2e; // Read and X 
		public const byte SMB_CMD_WRITE_AND_X = 0x2f; // Write and X 
		public const byte SMB_CMD_SESSION_SETUP_AND_X = 0x73; // Session Set Up and X (including User Logon) 
		public const byte SMB_CMD_TREE_CONNECT_AND_X = 0x75; // Tree connect and X 
		public const byte SMB_CMD_FIND_FIRST = 0x82; // Find first 
		public const byte SMB_CMD_FIND_UNIQUE = 0x83; // Find unique 
		public const byte SMB_CMD_FIND_CLOSE = 0x84; // Find close 
		//public const byte SMB_CMD_INVALID = 0xfe; // Invalid command 

		// SMB Error Class Codes
		public const byte SMB_ERROR_CLASS_SUCCESS  = 0x00; // The request was successful 
		public const byte SMB_ERROR_CLASS_ERRSRV =  0x02; // Error generated by the LMX server 

		// SMB Return Codes for Error class 0x00 
		public const byte SMB_ERROR_CLASS_SUCCESS_BUFFERED = 0x54; // The Message was buffered 
		public const byte SMB_ERROR_CLASS_SUCCESS_LOGGED = 0x55; // The Message was logged 
		public const byte SMB_ERROR_CLASS_SUCCESS_DISPLAYED = 0x56; // The Message was displayed 


		// SMB Return Codes for Error class 0x02 
		public const byte SMB_ERROR_CLASS_ERRSRV_ERRerror = 0x01; // Non-specific error code 
		public const byte SMB_ERROR_CLASS_ERRSRV_ERRbadpw = 0x02; // Bad password 
		public const byte SMB_ERROR_CLASS_ERRSRV_ERRbadtype = 0x03; // Reserved 



		public const byte SMB_COMMAND_SEND_SINGLE_BLOCK_MESSAGE = 0xd0;
		public const byte SMB_COMMAND_TRANSACTION_REQUEST = 0x25;

		public const ushort  FLAGS_TRANSACTION_ONEWAY = 0x0002;
		public const ushort  FLAGS_TRANSACTION_DISCONNECT = 0x0001;

		public const byte FLAGS_REQUEST_RESPONSE = 0x80;
		public const byte FLAGS_NOTIFY = 0x40;
		public const byte FLAGS_OPLOCKS = 0x20;
		public const byte FLAGS_CANONICALIZED_PATH_NAMES = 0x10;
		public const byte FLAGS_CASE_SENSITIVITY = 0x08;
		public const byte FLAGS_RECEIVE_BUFFER_POSTED = 0x02;
		public const byte FLAGS_LOCK_AND_READ = 0x01;

		public const ushort FLAGS2_UNICODE_STRINGS = 0x8000;
		public const ushort FLAGS2_ERROR_CODE_TYPE = 0x4000;
		public const ushort FLAGS2_EXECUTE_ONLY_READS = 0x2000;
		public const ushort FLAGS2_DFS = 0x1000;
		public const ushort FLAGS2_EXTENDED_SECURITY_NEGOTIATION = 0x0800;
		public const ushort FLAGS2_LONG_NAMES_USED = 0x0040;
		public const ushort FLAGS2_SECUTIRY_SIGNATURES = 0x0004;
		public const ushort FLAGS2_EXTENDED_ATTRIBUTES = 0x0002;
		public const ushort FLAGS2_LONG_NAMES_ALLOWED = 0x0001;

		public const byte FORMAT_TYPE_ASCII = 0x04;
		public const byte FORMAT_TYPE_DATA_BLOCK = 0x01;

		public const byte RAWMODE_READ   = 0x01;
		public const byte RAWMODE_WRITE  = 0x02;

		public const byte SECURITY_MODE_MODE             = 0x01;
		public const byte SECURITY_MODE_PASSWORD         = 0x02;
		public const byte SECURITY_MODE_SIGNATURES       = 0x04;
		public const byte SECURITY_MODE_SIG_REQUIRED     = 0x08;

		public const ushort SMB_SIF_TID_IS_IPC	= 0x0001;

		public const uint SMB_FILE_ATTRIBUTE_READ_ONLY				= 0x00000001;
		public const uint SMB_FILE_ATTRIBUTE_HIDDEN					= 0x00000002;
		public const uint SMB_FILE_ATTRIBUTE_SYSTEM					= 0x00000004;
		public const uint SMB_FILE_ATTRIBUTE_VOLUME					= 0x00000008;
		public const uint SMB_FILE_ATTRIBUTE_DIRECTORY				= 0x00000010;
		public const uint SMB_FILE_ATTRIBUTE_ARCHIVE				= 0x00000020;
		public const uint SMB_FILE_ATTRIBUTE_DEVICE					= 0x00000040;
		public const uint SMB_FILE_ATTRIBUTE_NORMAL					= 0x00000080;
		public const uint SMB_FILE_ATTRIBUTE_TEMPORARY				= 0x00000100;
		public const uint SMB_FILE_ATTRIBUTE_SPARSE					= 0x00000200;
		public const uint SMB_FILE_ATTRIBUTE_REPARSE				= 0x00000400;
		public const uint SMB_FILE_ATTRIBUTE_COMPRESSED				= 0x00000800;
		public const uint SMB_FILE_ATTRIBUTE_OFFLINE				= 0x00001000;
		public const uint SMB_FILE_ATTRIBUTE_NOT_CONTENT_INDEXED	= 0x00002000;
		public const uint SMB_FILE_ATTRIBUTE_ENCRYPTED				= 0x00004000;


		public const uint SERVER_CAP_RAW_MODE            = 0x00000001;
		public const uint SERVER_CAP_MPX_MODE            = 0x00000002;
		public const uint SERVER_CAP_UNICODE             = 0x00000004;
		public const uint SERVER_CAP_LARGE_FILES         = 0x00000008;
		public const uint SERVER_CAP_NT_SMBS             = 0x00000010;
		public const uint SERVER_CAP_RPC_REMOTE_APIS     = 0x00000020;
		public const uint SERVER_CAP_STATUS32            = 0x00000040;
		public const uint SERVER_CAP_LEVEL_II_OPLOCKS    = 0x00000080;
		public const uint SERVER_CAP_LOCK_AND_READ       = 0x00000100;
		public const uint SERVER_CAP_NT_FIND             = 0x00000200;
		public const uint SERVER_CAP_DFS                 = 0x00001000;
		public const uint SERVER_CAP_INFOLEVEL_PASSTHRU  = 0x00002000;
		public const uint SERVER_CAP_LARGE_READX         = 0x00004000;
		public const uint SERVER_CAP_LARGE_WRITEX        = 0x00008000;
		public const uint SERVER_CAP_UNIX                = 0x00800000;
		public const uint SERVER_CAP_RESERVED            = 0x02000000;
		public const uint SERVER_CAP_BULK_TRANSFER       = 0x20000000;
		public const uint SERVER_CAP_COMPRESSED_DATA     = 0x40000000;
		public const uint SERVER_CAP_EXTENDED_SECURITY   = 0x80000000;


		public const ushort PROTOCOL_ID_STP = 0x0000;

		public const byte PROTOCOL_VERSION_ID_ST = 0x00;

		public const byte BPDU_TYPE_CONFIGURATION = 0x00;


		public const byte FLAGS_TOPOLOGY_CHANGE = 0x01;
		public const byte FLAGS_TOPOLOGY_CHANGE_ACKNOWLEDGMENT = 0x81;


		public Const()
		{

		}

		public static string GetETHERTYPEStr( uint EType )
		{
			string Tmp = "";

			switch ( EType )
			{
				case ETHERTYPE_PUP		 : Tmp = ETHERTYPE_PUP_STR; break;
				case ETHERTYPE_IP			 : Tmp = ETHERTYPE_IP_STR; break;
				case ETHERTYPE_ARP		 : Tmp = ETHERTYPE_ARP_STR; break;
				case ETHERTYPE_REVARP		 : Tmp = ETHERTYPE_REVARP_STR; break;
				case ETHERTYPE_NS			 : Tmp = ETHERTYPE_NS_STR; break;
				case ETHERTYPE_SPRITE		 : Tmp = ETHERTYPE_SPRITE_STR; break;
				case ETHERTYPE_TRAIL		 : Tmp = ETHERTYPE_TRAIL_STR; break;
				case ETHERTYPE_MOPDL		 : Tmp = ETHERTYPE_MOPDL_STR; break;
				case ETHERTYPE_MOPRC		 : Tmp = ETHERTYPE_MOPRC_STR; break;
				case ETHERTYPE_DN			 : Tmp = ETHERTYPE_DN_STR; break;
				case ETHERTYPE_LAT		 : Tmp = ETHERTYPE_LAT_STR; break;
				case ETHERTYPE_SCA		 : Tmp = ETHERTYPE_SCA_STR; break;
				case ETHERTYPE_LANBRIDGE   : Tmp = ETHERTYPE_LANBRIDGE_STR; break;
				case ETHERTYPE_DECDNS		 : Tmp = ETHERTYPE_DECDNS_STR; break;
				case ETHERTYPE_DECDTS		 : Tmp = ETHERTYPE_DECDTS_STR; break;
				case ETHERTYPE_VEXP		 : Tmp = ETHERTYPE_VEXP_STR; break;
				case ETHERTYPE_VPROD		 : Tmp = ETHERTYPE_VPROD_STR; break;
				case ETHERTYPE_ATALK		 : Tmp = ETHERTYPE_ATALK_STR; break;
				case ETHERTYPE_AARP		 : Tmp = ETHERTYPE_AARP_STR; break;
				case ETHERTYPE_8021Q		 : Tmp = ETHERTYPE_8021Q_STR; break;
				case ETHERTYPE_IPX		 : Tmp = ETHERTYPE_IPX_STR; break;
				case ETHERTYPE_IPV6		 : Tmp = ETHERTYPE_IPV6_STR; break;
				case ETHERTYPE_LOOPBACK	 : Tmp = ETHERTYPE_LOOPBACK_STR; break;
				default : Tmp = "Unkwon"; break;

			}

			return Tmp;
		}


		public static string GetProtocolStr( int Prtcl )
		{
			string Tmp = "";

			switch( Prtcl )
			{
				case IPPROTO_IP			: Tmp = "IP Protocol" ; break;
				case IPPROTO_ICMP       : Tmp = "ICMP Protocol" ; break;
				case IPPROTO_IGMP       : Tmp = "IGMP Protocol" ; break;
				case IPPROTO_GGP        : Tmp = "GGP Protocol" ; break;
				case IPPROTO_TCP        : Tmp = "TCP Protocol" ; break;
				case IPPROTO_PUP        : Tmp = "PUP Protocol" ; break;
				case IPPROTO_UDP        : Tmp = "UDP Protocol" ; break;
				case IPPROTO_IDP        : Tmp = "IDP Protocol" ; break;
				case IPPROTO_IPV6       : Tmp = "IPV6 Protocol" ; break;
				case IPPROTO_ND         : Tmp = "ND Protocol" ; break;
				case IPPROTO_ICLFXBM	: Tmp = "ICLFXBM Protocol" ; break;
				case IPPROTO_EIGRP      : Tmp = "EIGRP Protocol" ; break;
				case IPPROTO_RAW        : Tmp = "RAW Protocol" ; break;
				case IPPROTO_MAX        : Tmp = "MAX Protocol" ; break;
				default					: Tmp = "Unknown Protocol" ; break;
			}

			return Tmp;

		}


		public static string GetPortStr( int Prt )
		{
			string Tmp = "";

			switch( Prt )
			{

				case IPPORT_ECHO             : Tmp = "ECHO"; break;
				case IPPORT_DISCARD          : Tmp = "DISCARD"; break;
				case IPPORT_SYSTAT           : Tmp = "SYSTAT"; break;
				case IPPORT_DAYTIME          : Tmp = "DAYTIME"; break;
				case IPPORT_NETSTAT          : Tmp = "NETSTAT"; break;
				case IPPORT_FTP              : Tmp = "FTP"; break;
				case IPPORT_TELNET           : Tmp = "TELNET"; break;
				case IPPORT_SMTP             : Tmp = "SMPTP"; break;
				case IPPORT_TIMESERVER       : Tmp = "TIMESERVER"; break;
				case IPPORT_NAMESERVER       : Tmp = "NAMESERVER"; break;
				case IPPORT_DNS              : Tmp = "DNS"; break;
				case IPPORT_MTP              : Tmp = "MTP"; break;
				case IPPORT_TFTP             : Tmp = "TFTP"; break;
				case IPPORT_RJE              : Tmp = "RJE"; break;
				case IPPORT_FINGER           : Tmp = "FINGER"; break;
				case IPPORT_HTTP             : Tmp = "HTTP"; break;
				case IPPORT_HTTP2            : Tmp = "HTTP"; break;
				case IPPORT_SSDP             : Tmp = "SSDP"; break;
				case IPPORT_TTYLINK          : Tmp = "TTYLINK"; break;
				case IPPORT_SUPDUP           : Tmp = "SUPDUP"; break;
				case IPPORT_EPMEP			 : Tmp = "EPMEP"; break;
				case IPPORT_NETBIOS_NS		 : Tmp = "NETBIOS NAME SERVICE"; break;
				case IPPORT_NETBIOS_DATAGRAM : Tmp = "NETBIOS DATAGRAM"; break;
				case IPPORT_NETBIOS_SSN      : Tmp = "NETBIOS SSN"; break;
				case IPPORT_EXECSERVER       : Tmp = "EXECSERVER"; break;
				case IPPORT_CMDSERVER        : Tmp = "CMDSERVER"; break;
				case IPPORT_WHOSERVER        : Tmp = "WHOSERVER"; break;
				case IPPORT_ROUTESERVER      : Tmp = "ROUTESERVER"; break;
				default						 : Tmp = "Unknown Port"; break;
			}

			return Tmp;

		}

		public static string GetNetBiosNames( byte b )
		{
			int i = 0;
			string [] NetBiosName = new string[256];

			for( i = 0; i < 256; i ++ )
				NetBiosName[i] = "Unknown";

			NetBiosName[0x00] = "Workstation Service or base computer name";
			NetBiosName[0x20] = "Server Service";
			NetBiosName[0x1B] = "Domain Master Browser";
			NetBiosName[0x03] = "Messenger Service";
			NetBiosName[0x03] = "Messenger Service";
			NetBiosName[0x1D] = "Master Browser";
			NetBiosName[0x06] = "Remote Access Server Service";
			NetBiosName[0x1F] = "NetDDE Service";
			NetBiosName[0x21] = "RAS Client Service";
			NetBiosName[0xBE] = "Network Monitor Agent";
			NetBiosName[0xBF] = "Network Monitor Application";
			NetBiosName[0x00] = "Domain Name";
			NetBiosName[0x1C] = "Domain Controller";
			NetBiosName[0x1B] = "Domain Controller";
			NetBiosName[0x1E] = "Browser Service Elections";

			return NetBiosName[ b ];
		}


		public static bool XDLC_IS_INFORMATION( byte control )
		{
			if( ( ( control & 0x1 ) == XDLC_I ) || 
				    ( control == ( XDLC_UI | XDLC_U ) ) )
				return true;

			return false;
		}


		public static int GetXdlcControlLegth( byte control, bool is_extended )
		{
			if( ( ( control & 0x3 ) == XDLC_U ) ||  !( is_extended ) )
				return 1;

			return 2;
		}


		public static ushort GetXdlcControl( byte Value , byte Value2 , ref bool IsExtended )
		{
			int Control = 0;

			switch( Value & 0x03 ) 
			{

				case XDLC_S: break;
				default:
				// Supervisory or Information frame.
				if( IsExtended )
					Control = (ushort) Value * 256 + (ushort) Value2;
				else
					Control = Value;
				break;

				case XDLC_U:
				// Unnumbered frame.
				Control = Value;
				break;
			}
	
			return (ushort) Control;
		}


		public static string GetSTypeString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case XDLC_RR : Tmp = "Receiver ready"; break;
				case XDLC_RNR : Tmp = "Receiver not ready"; break;
				case XDLC_REJ : Tmp = "Selective reject"; break;
			}
			return Tmp;
		}

		public static string GetShortValueCommandString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case XDLC_UI : Tmp = "UI"; break;
				case XDLC_UP : Tmp = "UP"; break;
				case XDLC_DISC : Tmp = "DISC"; break;
				case XDLC_UA : Tmp = "UA"; break;
				case XDLC_SNRM : Tmp = "SNRM"; break;
				case XDLC_SNRME : Tmp = "SNRME"; break;
				case XDLC_TEST : Tmp = "TEST"; break;
				case XDLC_SIM : Tmp = "SIM"; break;
				case XDLC_FRMR : Tmp = "FRMR"; break;
				case XDLC_CFGR : Tmp = "CFGR"; break;
				case XDLC_SARM : Tmp = "SARM"; break;
				case XDLC_SABM : Tmp = "SABM"; break;
				case XDLC_SARME : Tmp = "SARME"; break;
				case XDLC_SABME : Tmp = "SABME"; break;
				case XDLC_RESET : Tmp = "RESET"; break;
				case XDLC_XID : Tmp = "XID"; break;
				case XDLC_BCN : Tmp = "BCN"; break;

			}

			return Tmp;
		}

		public static string GetShortValueResponseString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case XDLC_UI : Tmp = "UI"; break;
				case XDLC_UP : Tmp = "UP"; break;
				case XDLC_DISC : Tmp = "DISC"; break;
				case XDLC_UA : Tmp = "UA"; break;
				case XDLC_SNRM : Tmp = "SNRM"; break;
				case XDLC_SNRME : Tmp = "SNRME"; break;
				case XDLC_TEST : Tmp = "TEST"; break;
				case XDLC_SIM : Tmp = "SIM"; break;
				case XDLC_FRMR : Tmp = "FRMR"; break;
				case XDLC_CFGR : Tmp = "CFGR"; break;
				case XDLC_SARM : Tmp = "SARM"; break;
				case XDLC_SABM : Tmp = "SABM"; break;
				case XDLC_SARME : Tmp = "SARME"; break;
				case XDLC_SABME : Tmp = "SABME"; break;
				case XDLC_RESET : Tmp = "RESET"; break;
				case XDLC_XID : Tmp = "XID"; break;
				case XDLC_BCN : Tmp = "BCN"; break;

			}

			return Tmp;
		}

		public static string GetValueCommandString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case XDLC_UI : Tmp = "Unnumbered Information"; break;
				case XDLC_UP : Tmp = "Unnumbered Poll"; break;
				case XDLC_DISC : Tmp = "Disconnect"; break;
				case XDLC_UA : Tmp = "Unnumbered Acknowledge"; break;
				case XDLC_SNRM : Tmp = "Set Normal Response Mode"; break;
				case XDLC_SNRME : Tmp = "Set Normal Response Mode Extended"; break;
				case XDLC_TEST : Tmp = "Test"; break;
				case XDLC_SIM : Tmp = "Set Initialization Mode"; break;
				case XDLC_FRMR : Tmp = "Frame reject"; break;
				case XDLC_CFGR : Tmp = "Configure"; break;
				case XDLC_SARM : Tmp = "Set Asynchronous Response Mode"; break;
				case XDLC_SABM : Tmp = "Set Asynchronous Balanced Mode"; break;
				case XDLC_SARME : Tmp = "Set Asynchronous Response Mode Extended"; break;
				case XDLC_SABME : Tmp = "Set Asynchronous Balanced Mode Extended"; break;
				case XDLC_RESET : Tmp = "Reset"; break;
				case XDLC_XID : Tmp = "Exchange identification"; break;
				case XDLC_BCN : Tmp = "Beacon"; break;

			}

			return Tmp;
		}

		public static string GetValueResponseString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case XDLC_UI : Tmp = "Unnumbered Information"; break;
				case XDLC_UP : Tmp = "Unnumbered Poll"; break;
				case XDLC_DISC : Tmp = "Disconnect"; break;
				case XDLC_UA : Tmp = "Unnumbered Acknowledge"; break;
				case XDLC_SNRM : Tmp = "Set Normal Response Mode"; break;
				case XDLC_SNRME : Tmp = "Set Normal Response Mode Extended"; break;
				case XDLC_TEST : Tmp = "Test"; break;
				case XDLC_SIM : Tmp = "Set Initialization Mode"; break;
				case XDLC_FRMR : Tmp = "Frame reject"; break;
				case XDLC_CFGR : Tmp = "Configure"; break;
				case XDLC_SARM : Tmp = "Set Asynchronous Response Mode"; break;
				case XDLC_SABM : Tmp = "Set Asynchronous Balanced Mode"; break;
				case XDLC_SARME : Tmp = "Set Asynchronous Response Mode Extended"; break;
				case XDLC_SABME : Tmp = "Set Asynchronous Balanced Mode Extended"; break;
				case XDLC_RESET : Tmp = "Reset"; break;
				case XDLC_XID : Tmp = "Exchange identification"; break;
				case XDLC_BCN : Tmp = "Beacon"; break;

			}

			return Tmp;
		}


		public static string GetOUIString( uint Value )
		{
			string Tmp = "";

			switch( Value )
			{
				case OUI_CISCO : Tmp = "Cisco"; break;
				case OUI_CISCO_90 : Tmp = "Cisco IOS 9.0 Compatible"; break;
				case OUI_BRIDGED : Tmp = "Frame Relay or ATM bridged frames"; break;
				case OUI_ATM_FORUM : Tmp = "ATM Forum"; break;
				case OUI_CABLE_BPDU : Tmp = "DOCSIS Spanning Tree"; break;
				case OUI_APPLE_ATALK : Tmp = "Apple (AppleTalk)"; break;
	
			}

			return Tmp;

		}


		public static string GetMaxFrameSizeList( byte b )
		{
			string [] MaxFrameSizeList = new string[8];

			MaxFrameSizeList[0] = "516";
			MaxFrameSizeList[1] = "1500";
			MaxFrameSizeList[2] = "2052";
			MaxFrameSizeList[3] = "4472";
			MaxFrameSizeList[4] = "8144";
			MaxFrameSizeList[5] = "11407";
			MaxFrameSizeList[6] = "17800";	// 17800 in TR spec, 17749 in NBF spec
			MaxFrameSizeList[7] = "65535";

			return MaxFrameSizeList[ b ];
		}

		public static string GetStatusList( byte b)
		{
			string [] StatusList = new string[2];

			StatusList[0] = "Add name not in process";
			StatusList[1] = "Add name in process";

			return StatusList[ b ];
		}

		public static string GetTerminationIndicatorList( byte b )
		{
			string [] TerminationIndicatorList = new string[2];

			TerminationIndicatorList[0x0000] = "Normal session end";
			TerminationIndicatorList[0x0001] = "Abnormal session end";

			return TerminationIndicatorList[ b ];

		}

		public static string NbVersionList( byte b )
		{
			string [] NbVersionList = new string[2];

			NbVersionList[0] = "2.00 or higher";
			NbVersionList[1] = "1.xx";

			return NbVersionList [ b ];
		}

		public static string GetFlagsYesNoList( byte b )
		{
			string [] FlagsYesNoList = new string[2];

			FlagsYesNoList[0] = "Yes";
			FlagsYesNoList[1] = "No";

			return FlagsYesNoList[ b ];
		}

		public static string GetFlagsAllowedList( byte b )
		{
			string [] FlagsAllowedList = new string[2];

			FlagsAllowedList[0] = "Allowed";
			FlagsAllowedList[1] = "Not allowed";

			return FlagsAllowedList[ b ];
		}

		public static string GetFlagsSetList( byte b )
		{
			string [] FlagsSetList = new string[2];

			FlagsSetList[0] = "Set";
			FlagsSetList[1] = "Not set";

			return FlagsSetList[ b ];

		}

		public static string GetNameTypeList( byte b )
		{
			string [] NameTypeList = new string[2];

			NameTypeList[0] = "Unique name";
			NameTypeList[1] = "Group name";

			return NameTypeList[b];
		}


		public static string GetCommandList( byte b )
		{
			int i = 0;
			string [] CommandList = new string[256];

			for( i = 0; i < 256; i ++ )
				CommandList[i] = "Unkbown";

			CommandList[Const.NB_ADD_GROUP] = "Add Group Name Query";
			CommandList[Const.NB_ADD_NAME] = "Add Name Query";
			CommandList[Const.NB_NAME_IN_CONFLICT] = "Name In Conflict";
			CommandList[Const.NB_STATUS_QUERY] = "Status Query";
			CommandList[Const.NB_TERMINATE_TRACE_R] = "Terminate Trace";
			CommandList[Const.NB_DATAGRAM] = "Datagram";
			CommandList[Const.NB_DATAGRAM_BCAST] = "Broadcast Datagram";
			CommandList[Const.NB_NAME_QUERY] = "Name Query";
			CommandList[Const.NB_ADD_NAME_RESP] = "Add Name Response";
			CommandList[Const.NB_NAME_RESP] = "Name Recognized";
			CommandList[Const.NB_STATUS_RESP] = "Status Response";
			CommandList[Const.NB_TERMINATE_TRACE_LR] = "Terminate Trace";
			CommandList[Const.NB_DATA_ACK] = "Data Ack";
			CommandList[Const.NB_DATA_FIRST_MIDDLE] = "Data First Middle";
			CommandList[Const.NB_DATA_ONLY_LAST] = "Data Only Last";
			CommandList[Const.NB_SESSION_CONFIRM] = "Session Confirm";
			CommandList[Const.NB_SESSION_END] = "Session End";
			CommandList[Const.NB_SESSION_INIT] = "Session Initialize";
			CommandList[Const.NB_NO_RECEIVE] = "No Receive";
			CommandList[Const.NB_RECEIVE_OUTSTANDING] = "Receive Outstanding";
			CommandList[Const.NB_RECEIVE_CONTINUE] = "Receive Continue";
			CommandList[Const.NB_KEEP_ALIVE] = "Session Alive";

			return CommandList[ b ];

		}

		public static string GetNbNameTypeList( byte b )
		{
			string [] NbNameTypeList = new string[256];
			int i = 0;

			for( i = 0; i < 256; i ++ )
			{
				NbNameTypeList[i] = "Unknown";
			}

			NbNameTypeList[0x00] = "Workstation/Redirector";
			NbNameTypeList[0x01] = "Browser";
			NbNameTypeList[0x02] = "Workstation/Redirector";
			NbNameTypeList[0x03] = "Messenger service/Main name";
			NbNameTypeList[0x05] = "Forwarded name";
			NbNameTypeList[0x06] = "RAS Server service";
			NbNameTypeList[0x1b] = "Domain Master Browser";
			NbNameTypeList[0x1c] = "Domain Controllers";
			NbNameTypeList[0x1d] = "Local Master Browser";
			NbNameTypeList[0x1e] = "Browser Election Service";
			NbNameTypeList[0x1f] = "Net DDE Service";
			NbNameTypeList[0x20] = "Server service";
			NbNameTypeList[0x21] = "RAS client service";
			NbNameTypeList[0x22] = "Exchange Interchange (MSMail Connector)";
			NbNameTypeList[0x23] = "Exchange Store";
			NbNameTypeList[0x24] = "Exchange Directory";
			NbNameTypeList[0x2b] = "Lotus Notes Server service";
			NbNameTypeList[0x30] = "Modem sharing server service";
			NbNameTypeList[0x31] = "Modem sharing client service";
			NbNameTypeList[0x43] = "SMS Clients Remote Control";
			NbNameTypeList[0x44] = "SMS Administrators Remote Control Tool";
			NbNameTypeList[0x45] = "SMS Clients Remote Chat";
			NbNameTypeList[0x46] = "SMS Clients Remote Transfer";
			NbNameTypeList[0x4c] = "DEC Pathworks TCP/IP Service on Windows NT";
			NbNameTypeList[0x52] = "DEC Pathworks TCP/IP Service on Windows NT";
			NbNameTypeList[0x6a] = "Microsoft Exchange IMC";
			NbNameTypeList[0x87] = "Microsoft Exchange MTA";
			NbNameTypeList[0xbe] = "Network Monitor Agent";
			NbNameTypeList[0xbf] = "Network Monitor Analyzer";

			return NbNameTypeList[ b ];

		}


		public static string GetSmbCommandString( byte b )
		{
			string [] SmbCmd = new string[256];
			int i = 0;

			for( i = 0; i < 256; i ++ )
			{
				SmbCmd[i] = "Unknown-" + i.ToString("x02");
			}

			SmbCmd[0x00] = "Create Directory";
			SmbCmd[0x01] = "Delete Directory";
			SmbCmd[0x02] = "Open";
			SmbCmd[0x03] = "Create";
			SmbCmd[0x04] = "Close";
			SmbCmd[0x05] = "Flush";
			SmbCmd[0x06] = "Delete";
			SmbCmd[0x07] = "Rename";
			SmbCmd[0x08] = "Query Information";
			SmbCmd[0x09] = "Set Information";
			SmbCmd[0x0A] = "Read";
			SmbCmd[0x0B] = "Write";
			SmbCmd[0x0C] = "Lock Byte Range";
			SmbCmd[0x0D] = "Unlock Byte Range";
			SmbCmd[0x0E] = "Create Temp";
			SmbCmd[0x0F] = "Create New";
			SmbCmd[0x10] = "Check Directory";
			SmbCmd[0x11] = "Process Exit";
			SmbCmd[0x12] = "Seek";
			SmbCmd[0x13] = "Lock And Read";
			SmbCmd[0x14] = "Write And Unlock";
			SmbCmd[0x1A] = "Read Raw";
			SmbCmd[0x1B] = "Read MPX";
			SmbCmd[0x1C] = "Read MPX Secondary";
			SmbCmd[0x1D] = "Write Raw";
			SmbCmd[0x1E] = "Write MPX";
			SmbCmd[0x1F] = "Write MPX Secondary";
			SmbCmd[0x20] = "Write Complete";
			SmbCmd[0x22] = "Set Information2";
			SmbCmd[0x23] = "Query Information2";
			SmbCmd[0x24] = "Locking AndX";
			SmbCmd[0x25] = "Transaction";
			SmbCmd[0x26] = "Transaction Secondary";
			SmbCmd[0x27] = "IOCTL";
			SmbCmd[0x28] = "IOCTL Secondary";
			SmbCmd[0x29] = "Copy";
			SmbCmd[0x2A] = "Move";
			SmbCmd[0x2B] = "Echo";
			SmbCmd[0x2C] = "Write And Close";
			SmbCmd[0x2D] = "Open AndX";
			SmbCmd[0x2E] = "Read AndX";
			SmbCmd[0x2F] = "Write AndX";
			SmbCmd[0x31] = "Close And Tree Disconnect";
			SmbCmd[0x32] = "Transaction2";
			SmbCmd[0x33] = "Transaction2 Secondary";
			SmbCmd[0x34] = "Find Close2";
			SmbCmd[0x35] = "Find Notify Close";
			SmbCmd[0x70] = "Tree Connect";
			SmbCmd[0x71] = "Tree Disconnect";
			SmbCmd[0x72] = "Negotiate Protocol";
			SmbCmd[0x73] = "Session Setup AndX";
			SmbCmd[0x74] = "Logoff AndX";
			SmbCmd[0x75] = "Tree Connect AndX";
			SmbCmd[0x80] = "Query Information Disk";
			SmbCmd[0x81] = "Search";
			SmbCmd[0x82] = "Find";
			SmbCmd[0x83] = "Find Unique";
			SmbCmd[0x84] = "Find Close";
			SmbCmd[0xA0] = "NT Transact";
			SmbCmd[0xA1] = "NT Transact Secondary";
			SmbCmd[0xA2] = "NT Create AndX";
			SmbCmd[0xA4] = "NT Cancel";
			SmbCmd[0xA5] = "NT Rename";
			SmbCmd[0xC0] = "Open Print File";
			SmbCmd[0xC1] = "Write Print File";
			SmbCmd[0xC2] = "Close Print File";
			SmbCmd[0xC3] = "Get Print Queue";
			SmbCmd[0xD0] = "Send Single Block Message";
			SmbCmd[0xD1] = "Send Broadcast Message";
			SmbCmd[0xD2] = "Forward User Name";
			SmbCmd[0xD3] = "Cancel Forward";
			SmbCmd[0xD4] = "Get Machine Name";
			SmbCmd[0xD5] = "Send Start of Multi-block Message";
			SmbCmd[0xD6] = "Send End of Multi-block Message";
			SmbCmd[0xD7] = "Send Text of Multi-block Message";
			SmbCmd[0xD8] = "SMBreadbulk";
			SmbCmd[0xD9] = "SMBwritebulk";
			SmbCmd[0xDA] = "SMBwritebulkdata";
			SmbCmd[0xFE] = "SMBinvalid";

			return SmbCmd[ b ];

		}

		public static string GetSmbBufferFormatString( byte b )
		{
			string [] BufferFormat = new string[6];

			BufferFormat[0] = "Unknown";
			BufferFormat[1] = "Data Block";
			BufferFormat[2] = "Dialect";
			BufferFormat[3] = "Pathname";
			BufferFormat[4] = "ASCII";
			BufferFormat[5] = "Variable Block";

			if( b > 5 ) return "Unknown";

			return BufferFormat[ b ];
		}


		public static string GetSmbDaAccessString( byte b )
		{
			string [] DaAccess = new string[4];

			DaAccess[0] = "Open for reading";
			DaAccess[1] = "Open for writing";
			DaAccess[2] = "Open for reading and writing";
			DaAccess[3] = "Open for execute";

			if( b > 3 ) return "Unknown";

			return DaAccess[ b ];
		}


		public static string GetSmbDaSharingString( byte b )
		{
			string [] DaSharing = new string[5];

			DaSharing[0] = "Compatibility mode";
			DaSharing[1] = "Deny read/write/execute (exclusive)";
			DaSharing[2] = "Deny write";
			DaSharing[3] = "Deny read/execute";
			DaSharing[4] = "Deny none";

			if( b > 4 ) return "Unknown";

			return DaSharing[ b ];
		}


		public static string GetSmbDaLocalityString( byte b )
		{
			string [] DaLocality = new string[4];

			DaLocality[0] = "Locality of reference unknown";
			DaLocality[1] = "Mainly sequential access";
			DaLocality[2] = "Mainly random access";
			DaLocality[3] = "Random access with some locality";

			if( b > 3 ) return "Unknown";

			return DaLocality[ b ];
		}



		public const byte NT_TRANS_CREATE			= 1;
		public const byte NT_TRANS_IOCTL			= 2;
		public const byte NT_TRANS_SSD				= 3;
		public const byte NT_TRANS_NOTIFY			= 4;
		public const byte NT_TRANS_RENAME			= 5;
		public const byte NT_TRANS_QSD				= 6;
		public const byte NT_TRANS_GET_USER_QUOTA	= 7;
		public const byte NT_TRANS_SET_USER_QUOTA	= 8;


		public static string GetSmbNtCommandString( byte b )
		{
			string [] NtCmd = new string[9];

			NtCmd[NT_TRANS_CREATE] = "NT CREATE";
			NtCmd[NT_TRANS_IOCTL] = "NT IOCTL";
			NtCmd[NT_TRANS_SSD] = "NT SET SECURITY DESC";
			NtCmd[NT_TRANS_NOTIFY] = "NT NOTIFY";
			NtCmd[NT_TRANS_RENAME] = "NT RENAME";
			NtCmd[NT_TRANS_QSD] = "NT QUERY SECURITY DESC";
			NtCmd[NT_TRANS_GET_USER_QUOTA] = "NT GET USER QUOTA";
			NtCmd[NT_TRANS_SET_USER_QUOTA] = "NT SET USER QUOTA";

			if( b > 8 ) return "Unknown";

			return NtCmd[ b ];
		}


		public static string GetSmbNtIoctlString( byte b )
		{
			string [] NtIoctl = new string[2];

			NtIoctl[0] = "Device IOCTL";
			NtIoctl[1] = "FS control : FSCTL";

			if( b > 1 ) return "Unknown";

			return NtIoctl[ b ];
		}


		public const byte NT_IOCTL_FLAGS_ROOT_HANDLE	= 0x01;


		public static string GetSmbNtNotifyActionString( byte b )
		{
			string [] NotifyAction = new string[9];

			NotifyAction[1] = "ADDED (object was added";
			NotifyAction[2] = "REMOVED (object was removed)";
			NotifyAction[3] = "MODIFIED (object was modified)";
			NotifyAction[4] = "RENAMED_OLD_NAME (this is the old name of object)";
			NotifyAction[5] = "RENAMED_NEW_NAME (this is the new name of object)";
			NotifyAction[6] = "ADDED_STREAM (a stream was added)";
			NotifyAction[7] = "REMOVED_STREAM (a stream was removed)";
			NotifyAction[8] = "MODIFIED_STREAM (a stream was modified)";

			if( ( b == 0 ) || ( b > 9 ) ) return "Unknown";

			return NotifyAction[ b ];
		}


		public static string GetSmbWatchTreeString( byte b )
		{
			string [] WatchTree = new string[3];

			WatchTree[1] = "Current directory only";
			WatchTree[2] = "Subdirectories also";

			if( ( b == 0 ) || ( b > 2 ) ) return "Unknown";

			return WatchTree[ b ];
		}


		public const uint NT_NOTIFY_STREAM_WRITE	= 0x00000800;
		public const uint NT_NOTIFY_STREAM_SIZE	= 0x00000400;
		public const uint NT_NOTIFY_STREAM_NAME	= 0x00000200;
		public const uint NT_NOTIFY_SECURITY	= 0x00000100;
		public const uint NT_NOTIFY_EA		= 0x00000080;
		public const uint NT_NOTIFY_CREATION	= 0x00000040;
		public const uint NT_NOTIFY_LAST_ACCESS	= 0x00000020;
		public const uint NT_NOTIFY_LAST_WRITE	= 0x00000010;
		public const uint NT_NOTIFY_SIZE		= 0x00000008;
		public const uint NT_NOTIFY_ATTRIBUTES	= 0x00000004;
		public const uint NT_NOTIFY_DIR_NAME	= 0x00000002;
		public const uint NT_NOTIFY_FILE_NAME	= 0x00000001;



		public static string GetSmbCreateDispositionString( byte b )
		{
			string [] CreateDisposition = new string[6];

			CreateDisposition[0] = "Supersede (supersede existing file (if it exists))";
			CreateDisposition[1] = "Open (if file exists open it, else fail)";
			CreateDisposition[2] = "Create (if file exists fail, else create it)";
			CreateDisposition[3] = "Open If (if file exists open it, else create it)";
			CreateDisposition[4] = "Overwrite (if file exists overwrite, else fail)";
			CreateDisposition[5] = "Overwrite If (if file exists overwrite, else create it)";

			if( b > 5 ) return "Unknown";

			return CreateDisposition[ b ];
		}


		public static string GetSmbImpersonationLevelString( byte b )
		{
			string [] ImpersonationLevel = new string[4];

			ImpersonationLevel[0] = "Anonymous";
			ImpersonationLevel[1] = "Identification";
			ImpersonationLevel[2] = "Impersonation";
			ImpersonationLevel[3] = "Delegation";

			if( b > 3 ) return "Unknown";

			return ImpersonationLevel[ b ];
		}



		public static string GetSmbOplockLevelString( byte b )
		{
			string [] OplockLevel = new string[4];

			OplockLevel[0] = "No oplock granted";
			OplockLevel[1] = "Exclusive oplock granted";
			OplockLevel[2] = "Batch oplock granted";
			OplockLevel[3] = "Level II oplock granted";

			if( b > 3 ) return "Unknown";

			return OplockLevel[ b ];
		}


		public static string GetSmbDeviceTypeString( uint b )
		{
			string [] DeviceType = new string[0x2d];

			DeviceType[0x00000001] = "Beep";
			DeviceType[0x00000002] = "CDROM";
			DeviceType[0x00000003] = "CDROM Filesystem";
			DeviceType[0x00000004] = "Controller";
			DeviceType[0x00000005] = "Datalink";
			DeviceType[0x00000006] = "Dfs";
			DeviceType[0x00000007] = "Disk";
			DeviceType[0x00000008] = "Disk Filesystem";
			DeviceType[0x00000009] = "Filesystem";
			DeviceType[0x0000000a] = "Inport Port";
			DeviceType[0x0000000b] = "Keyboard";
			DeviceType[0x0000000c] = "Mailslot";
			DeviceType[0x0000000d] = "MIDI-In";
			DeviceType[0x0000000e] = "MIDI-Out";
			DeviceType[0x0000000f] = "Mouse";
			DeviceType[0x00000010] = "Multi UNC Provider";
			DeviceType[0x00000011] = "Named Pipe";
			DeviceType[0x00000012] = "Network";
			DeviceType[0x00000013] = "Network Browser";
			DeviceType[0x00000014] = "Network Filesystem";
			DeviceType[0x00000015] = "NULL";
			DeviceType[0x00000016] = "Parallel Port";
			DeviceType[0x00000017] = "Physical card";
			DeviceType[0x00000018] = "Printer";
			DeviceType[0x00000019] = "Scanner";
			DeviceType[0x0000001a] = "Serial Mouse port";
			DeviceType[0x0000001b] = "Serial port";
			DeviceType[0x0000001c] = "Screen";
			DeviceType[0x0000001d] = "Sound";
			DeviceType[0x0000001e] = "Streams";
			DeviceType[0x0000001f] = "Tape";
			DeviceType[0x00000020] = "Tape Filesystem";
			DeviceType[0x00000021] = "Transport";
			DeviceType[0x00000022] = "Unknown";
			DeviceType[0x00000023] = "Video";
			DeviceType[0x00000024] = "Virtual Disk";
			DeviceType[0x00000025] = "WAVE-In";
			DeviceType[0x00000026] = "WAVE-Out";
			DeviceType[0x00000027] = "8042 Port";
			DeviceType[0x00000028] = "Network Redirector";
			DeviceType[0x00000029] = "Battery";
			DeviceType[0x0000002a] = "Bus Extender";
			DeviceType[0x0000002b] = "Modem";
			DeviceType[0x0000002c] = "VDM";

			if( b > 0x2c ) return "Unknown";

			return DeviceType[ b ];
		}


		public const uint NT_QSD_OWNER	= 0x00000001;
		public const uint NT_QSD_GROUP	= 0x00000002;
		public const uint NT_QSD_DACL	= 0x00000004;
		public const uint NT_QSD_SACL	= 0x00000008;



		public static string GetSmbPrintModeString( byte b )
		{
			string [] PrintMode = new string[2];

			PrintMode[0] = "Text Mode";
			PrintMode[1] = "Graphics Mode";

			if( b > 1 ) return "Unknown";

			return PrintMode[ b ];
		}


		public static string GetSmbPrintStatusString( byte b )
		{
			string [] PrintStatus = new string[7];

			PrintStatus[1] = "Held or Stopped";
			PrintStatus[2] = "Printing";
			PrintStatus[3] = "Awaiting print";
			PrintStatus[4] = "In intercept";
			PrintStatus[5] = "File had error";
			PrintStatus[6] = "Printer error";

			if( ( b == 0 ) || ( b > 6 ) ) return "Unknown";

			return PrintStatus[ b ];
		}



		public static string GetSmbTrans2CommandString( ushort b )
		{
			string [] Trans2Command = new string[18];

			Trans2Command[0x00] = "OPEN2";
			Trans2Command[0x01] = "FIND_FIRST2";
			Trans2Command[0x02] = "FIND_NEXT2";
			Trans2Command[0x03] = "QUERY_FS_INFORMATION";
			Trans2Command[0x04] = "SET_FS_QUOTA";
			Trans2Command[0x05] = "QUERY_PATH_INFORMATION";
			Trans2Command[0x06] = "SET_PATH_INFORMATION";
			Trans2Command[0x07] = "QUERY_FILE_INFORMATION";
			Trans2Command[0x08] = "SET_FILE_INFORMATION";
			Trans2Command[0x09] = "FSCTL";
			Trans2Command[0x0A] = "IOCTL2";
			Trans2Command[0x0B] = "FIND_NOTIFY_FIRST";
			Trans2Command[0x0C] = "FIND_NOTIFY_NEXT";
			Trans2Command[0x0D] = "CREATE_DIRECTORY";
			Trans2Command[0x0E] = "SESSION_SETUP";
			Trans2Command[0x10] = "GET_DFS_REFERRAL";
			Trans2Command[0x11] = "REPORT_DFS_INCONSISTENCY";

			if( b > 17 ) return "Unknown";

			return Trans2Command[ b ];
		}


		public static string GetSmbFf2IlString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{
				case 1 : Tmp = "Info Standard  (4.3.4.1)"; break;
				case 2 : Tmp = "Info Query EA Size  (4.3.4.2)"; break;
				case 3 : Tmp = "Info Query EAs From List  (4.3.4.2)"; break;
				case 0x0101 : Tmp = "Find File Directory Info  (4.3.4.4)"; break;
				case 0x0102 : Tmp = "Find File Full Directory Info  (4.3.4.5)"; break;
				case 0x0103 : Tmp = "Find File Names Info  (4.3.4.7)"; break;
				case 0x0104 : Tmp = "Find File Both Directory Info  (4.3.4.6)"; break;
				case 0x0202 : Tmp = "Find File UNIX  (4.3.4.8)"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetSmbQpiLoiString( ushort b )
		{
			string [] QpiLoi = new string[1038];

			QpiLoi[1] = "Info Standard  (4.2.14.1)";
			QpiLoi[2] = "Info Query EA Size  (4.2.14.1)";
			QpiLoi[3] = "Info Query EAs From List  (4.2.14.2)";
			QpiLoi[4] = "Info Query All EAs  (4.2.14.2)";
			QpiLoi[6] = "Info Is Name Valid  (4.2.14.3)";
			QpiLoi[0x0101] = "Query File Basic Info  (4.2.14.4)";
			QpiLoi[0x0102] = "Query File Standard Info  (4.2.14.5)";
			QpiLoi[0x0103] = "Query File EA Info  (4.2.14.6)";
			QpiLoi[0x0104] = "Query File Name Info  (4.2.14.7)";
			QpiLoi[0x0107] = "Query File All Info  (4.2.14.8)";
			QpiLoi[0x0108] = "Query File Alt Name Info  (4.2.14.7)";
			QpiLoi[0x0109] = "Query File Stream Info  (4.2.14.10)";
			QpiLoi[0x010b] = "Query File Compression Info  (4.2.14.11)";
			QpiLoi[0x0200] = "Set File Unix Basic";
			QpiLoi[0x0201] = "Set File Unix Link";
			QpiLoi[0x0202] = "Set File Unix HardLink";
			QpiLoi[1004] = "Query File Basic Info  (4.2.14.4)";
			QpiLoi[1005] = "Query File Standard Info  (4.2.14.5)";
			QpiLoi[1006] = "Query File Internal Info  (4.2.14.?)";
			QpiLoi[1007] = "Query File EA Info  (4.2.14.6)";
			QpiLoi[1009] = "Query File Name Info  (4.2.14.7)";
			QpiLoi[1010] = "Query File Rename Info  (4.2.14.?)";
			QpiLoi[1011] = "Query File Link Info  (4.2.14.?)";
			QpiLoi[1012] = "Query File Names Info  (4.2.14.?)";
			QpiLoi[1013] = "Query File Disposition Info  (4.2.14.?)";
			QpiLoi[1014] = "Query File Position Info  (4.2.14.?)";
			QpiLoi[1015] = "Query File Full EA Info  (4.2.14.?)";
			QpiLoi[1016] = "Query File Mode Info  (4.2.14.?)";
			QpiLoi[1017] = "Query File Alignment Info  (4.2.14.?)";
			QpiLoi[1018] = "Query File All Info  (4.2.14.8)";
			QpiLoi[1019] = "Query File Allocation Info  (4.2.14.?)";
			QpiLoi[1020] = "Query File End of File Info  (4.2.14.?)";
			QpiLoi[1021] = "Query File Alt Name Info  (4.2.14.7)";
			QpiLoi[1022] = "Query File Stream Info  (4.2.14.10)";
			QpiLoi[1023] = "Query File Pipe Info  (4.2.14.?)";
			QpiLoi[1024] = "Query File Pipe Local Info  (4.2.14.?)";
			QpiLoi[1025] = "Query File Pipe Remote Info  (4.2.14.?)";
			QpiLoi[1026] = "Query File Mailslot Query Info  (4.2.14.?)";
			QpiLoi[1027] = "Query File Mailslot Set Info  (4.2.14.?)";
			QpiLoi[1028] = "Query File Compression Info  (4.2.14.11)";
			QpiLoi[1029] = "Query File ObjectID Info  (4.2.14.?)";
			QpiLoi[1030] = "Query File Completion Info  (4.2.14.?)";
			QpiLoi[1031] = "Query File Move Cluster Info  (4.2.14.?)";
			QpiLoi[1032] = "Query File Quota Info  (4.2.14.?)";
			QpiLoi[1033] = "Query File Reparsepoint Info  (4.2.14.?)";
			QpiLoi[1034] = "Query File Network Open Info  (4.2.14.?)";
			QpiLoi[1035] = "Query File Attribute Tag Info  (4.2.14.?)";
			QpiLoi[1036] = "Query File Tracking Info  (4.2.14.?)";
			QpiLoi[1037] = "Query File Maximum Info  (4.2.14.?)";

			if( ( b == 0 ) || ( b > 1037 ) ) return "Unknown";

			return QpiLoi[ b ];
		}


		public static string GetSmbQfsiString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{
				case 1 : Tmp = "Info Allocation"; break;
				case 2 : Tmp = "Info Volume"; break;
				case 0x0101 : Tmp = "Query FS Label Info"; break;
				case 0x0102 : Tmp = "Query FS Volume Info"; break;
				case 0x0103 : Tmp = "Query FS Size Info"; break;
				case 0x0104 : Tmp = "Query FS Device Info"; break;
				case 0x0105 : Tmp = "Query FS Attribute Info"; break;
				case 0x0301 : Tmp = "Mac Query FS INFO"; break;
				case 1001 : Tmp = "Query FS Label Info"; break;
				case 1002 : Tmp = "Query FS Volume Info"; break;
				case 1003 : Tmp = "Query FS Size Info"; break;
				case 1004 : Tmp = "Query FS Device Info"; break;
				case 1005 : Tmp = "Query FS Attribute Info"; break;
				case 1006 : Tmp = "Query FS Quota Info"; break;
				case 1007 : Tmp = "Query Full FS Size Info"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetSmbNtRenameString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{
				case 0x0103 : Tmp = "Create Hard Link"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetSmbAlignmentString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{
				case 0 : Tmp = "Byte alignment"; break;
				case 1 : Tmp = "Word (16bit) alignment"; break;
				case 3 : Tmp = "Long (32bit) alignment"; break;
				case 7 : Tmp = "8 byte boundary alignment"; break;
				case 0x0f : Tmp = "16 byte boundary alignment"; break;
				case 0x1f : Tmp = "32 byte boundary alignment"; break;
				case 0x3f : Tmp = "64 byte boundary alignment"; break;
				case 0x7f : Tmp = "128 byte boundary alignment"; break;
				case 0xff : Tmp = "256 byte boundary alignment"; break;
				case 0x1ff : Tmp = "512 byte boundary alignment"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetSmbDfsReferralServerTypeString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{
				case 0 : Tmp = "Don't know"; break;
				case 1 : Tmp = "SMB Server"; break;
				case 2 : Tmp = "Netware Server"; break;
				case 3 : Tmp = "Domain Server"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}



		public const byte SMB_COM_CREATE_DIRECTORY		= 0x00;
		public const byte SMB_COM_DELETE_DIRECTORY		= 0x01;
		public const byte SMB_COM_OPEN				= 0x02;
		public const byte SMB_COM_CREATE				= 0x03;
		public const byte SMB_COM_CLOSE				= 0x04;
		public const byte SMB_COM_FLUSH				= 0x05;
		public const byte SMB_COM_DELETE				= 0x06;
		public const byte SMB_COM_RENAME				= 0x07;
		public const byte SMB_COM_QUERY_INFORMATION		= 0x08;
		public const byte SMB_COM_SET_INFORMATION			= 0x09;
		public const byte SMB_COM_READ				= 0x0A;
		public const byte SMB_COM_WRITE				= 0x0B;
		public const byte SMB_COM_LOCK_BYTE_RANGE			= 0x0C;
		public const byte SMB_COM_UNLOCK_BYTE_RANGE		= 0x0D;
		public const byte SMB_COM_CREATE_TEMPORARY		= 0x0E;
		public const byte SMB_COM_CREATE_NEW			= 0x0F;
		public const byte SMB_COM_CHECK_DIRECTORY			= 0x10;
		public const byte SMB_COM_PROCESS_EXIT			= 0x11;
		public const byte SMB_COM_SEEK				= 0x12;
		public const byte SMB_COM_LOCK_AND_READ			= 0x13;
		public const byte SMB_COM_WRITE_AND_UNLOCK		= 0x14;
		public const byte SMB_COM_READ_RAW			= 0x1A;
		public const byte SMB_COM_READ_MPX			= 0x1B;
		public const byte SMB_COM_READ_MPX_SECONDARY		= 0x1C;
		public const byte SMB_COM_WRITE_RAW			= 0x1D;
		public const byte SMB_COM_WRITE_MPX			= 0x1E;
		public const byte SMB_COM_WRITE_MPX_SECONDARY		= 0x1F;
		public const byte SMB_COM_WRITE_COMPLETE			= 0x20;
		public const byte SMB_COM_QUERY_SERVER			= 0x21;
		public const byte SMB_COM_SET_INFORMATION2		= 0x22;
		public const byte SMB_COM_QUERY_INFORMATION2		= 0x23;
		public const byte SMB_COM_LOCKING_ANDX			= 0x24;
		public const byte SMB_COM_TRANSACTION			= 0x25;
		public const byte SMB_COM_TRANSACTION_SECONDARY		= 0x26;
		public const byte SMB_COM_IOCTL				= 0x27;
		public const byte SMB_COM_IOCTL_SECONDARY			= 0x28;
		public const byte SMB_COM_COPY				= 0x29;
		public const byte SMB_COM_MOVE				= 0x2A;
		public const byte SMB_COM_ECHO				= 0x2B;
		public const byte SMB_COM_WRITE_AND_CLOSE			= 0x2C;
		public const byte SMB_COM_OPEN_ANDX			= 0x2D;
		public const byte SMB_COM_READ_ANDX			= 0x2E;
		public const byte SMB_COM_WRITE_ANDX			= 0x2F;
		public const byte SMB_COM_NEW_FILE_SIZE			= 0x30;
		public const byte SMB_COM_CLOSE_AND_TREE_DISC		= 0x31;
		public const byte SMB_COM_TRANSACTION2			= 0x32;
		public const byte SMB_COM_TRANSACTION2_SECONDARY		= 0x33;
		public const byte SMB_COM_FIND_CLOSE2			= 0x34;
		public const byte SMB_COM_FIND_NOTIFY_CLOSE		= 0x35;
		//Used by Xenix/Unix		= 0x60-= 0x6E
		public const byte SMB_COM_TREE_CONNECT			= 0x70;
		public const byte SMB_COM_TREE_DISCONNECT			= 0x71;
		public const byte SMB_COM_NEGOTIATE			= 0x72;
		public const byte SMB_COM_SESSION_SETUP_ANDX		= 0x73;
		public const byte SMB_COM_LOGOFF_ANDX			= 0x74;
		public const byte SMB_COM_TREE_CONNECT_ANDX		= 0x75;
		public const byte SMB_COM_QUERY_INFORMATION_DISK		= 0x80;
		public const byte SMB_COM_SEARCH				= 0x81;
		public const byte SMB_COM_FIND				= 0x82;
		public const byte SMB_COM_FIND_UNIQUE			= 0x83;
		public const byte SMB_COM_FIND_CLOSE			= 0x84;
		public const byte SMB_COM_NT_TRANSACT			= 0xA0;
		public const byte SMB_COM_NT_TRANSACT_SECONDARY		= 0xA1;
		public const byte SMB_COM_NT_CREATE_ANDX			= 0xA2;
		public const byte SMB_COM_NT_CANCEL			= 0xA4;
		public const byte SMB_COM_NT_RENAME			= 0xA5;
		public const byte SMB_COM_OPEN_PRINT_FILE			= 0xC0;
		public const byte SMB_COM_WRITE_PRINT_FILE		= 0xC1;
		public const byte SMB_COM_CLOSE_PRINT_FILE		= 0xC2;
		public const byte SMB_COM_GET_PRINT_QUEUE			= 0xC3;
		public const byte SMB_SEND_SINGLE_BLOCK_MESSAGE = 0xd0;
		public const byte SMB_SEND_BROADCAST_MESSAGE = 0xd1;
		public const byte SMB_FORWARD_USER_NAME = 0xd2;
		public const byte SMB_CANCEL_FORWARD = 0xd3;
		public const byte SMB_GET_MACHINE_NAME = 0xd4;
		public const byte SMB_SEND_START_MULTI_BLOCK_MESSAGE = 0xd5;
		public const byte SMB_SEND_END_MULTI_BLOCK_MESSAGE = 0xd6;
		public const byte SMB_SEND_TEXT_MULTI_BLOCK_MESSAGE = 0xd7;
		public const byte SMB_COM_READ_BULK			= 0xD8;
		public const byte SMB_COM_WRITE_BULK			= 0xD9;
		public const byte SMB_COM_WRITE_BULK_DATA			= 0xDA;

		//Error codes

		public const byte SMB_SUCCESS = 0x00;  //All OK
		public const byte SMB_ERRDOS  = 0x01;  //DOS based error
		public const byte SMB_ERRSRV  = 0x02;  //server error, network file manager
		public const byte SMB_ERRHRD  = 0x03;  //Hardware style error
		public const byte SMB_ERRCMD  = 0x04;  //Not an SMB format command

		//SMB X/Open error codes for the ERRDOS error class
		public const ushort SMBE_badfunc = 1           ;  //Invalid function (or system call)
		public const ushort SMBE_badfile = 2           ;  //File not found (pathname error)
		public const ushort SMBE_badpath = 3           ;  //Directory not found
		public const ushort SMBE_nofids = 4            ;  //Too many open files
		public const ushort SMBE_noaccess = 5          ;  //Access denied
		public const ushort SMBE_badfid = 6            ;  //Invalid fid
		public const ushort SMBE_badmcb = 7            ;  //Memory control blocks destroyed
		public const ushort SMBE_nomem = 8             ;  //Out of memory
		public const ushort SMBE_badmem = 9            ;  //Invalid memory block address
		public const ushort SMBE_badenv = 10           ;  //Invalid environment
		public const ushort SMBE_badformat = 11        ;  //Invalid format
		public const ushort SMBE_badaccess = 12        ;  //Invalid open mode
		public const ushort SMBE_baddata = 13          ;  //Invalid data (only from ioctl call)
		public const ushort SMBE_res = 14;
		public const ushort SMBE_baddrive = 15         ;  //Invalid drive
		public const ushort SMBE_remcd = 16            ;  //Attempt to delete current directory
		public const ushort SMBE_diffdevice = 17       ;  //rename/move across different filesystems
		public const ushort SMBE_nofiles = 18          ;  //no more files found in file search
		public const ushort SMBE_badshare = 32         ;  //Share mode on file conflict with open mode
		public const ushort SMBE_lock = 33             ;  //Lock request conflicts with existing lock
		public const ushort SMBE_unsup = 50            ;  //Request unsupported, returned by Win 95, RJS 20Jun98
		public const ushort SMBE_nosuchshare = 67      ;  //Share does not exits
		public const ushort SMBE_filexists = 80        ;  //File in operation already exists
		public const ushort SMBE_invalidparam = 87	 ;  //Invalid parameter
		public const ushort SMBE_cannotopen = 110      ;  //Cannot open the file specified
		public const ushort SMBE_insufficientbuffer = 122;//Insufficient buffer size
		public const ushort SMBE_invalidname = 123     ;  //Invalid name
		public const ushort SMBE_unknownlevel = 124    ;  //Unknown info level
		public const ushort SMBE_alreadyexists = 183   ;  //File already exists
		public const ushort SMBE_badpipe = 230         ;  //Named pipe invalid
		public const ushort SMBE_pipebusy = 231        ;  //All instances of pipe are busy
		public const ushort SMBE_pipeclosing = 232     ;  //named pipe close in progress
		public const ushort SMBE_notconnected = 233    ;  //No process on other end of named pipe
		public const ushort SMBE_moredata = 234        ;  //More data to be returned
		public const ushort SMBE_nomoreitems = 259     ;  //No more items
		public const ushort SMBE_baddirectory = 267    ;  //Invalid directory name in a path.
		public const ushort SMBE_eas_didnt_fit = 275   ;  //Extended attributes didn't fit
		public const ushort SMBE_eas_nsup = 282        ;  //Extended attributes not supported
		public const ushort SMBE_notify_buf_small = 1022;//Buffer too small to return change notify.
		public const ushort SMBE_serverunavailable = 1722;//Server unavailable
		public const ushort SMBE_unknownipc = 2142;
		public const ushort SMBE_noipc = 66            ;  //don't support ipc

		//These errors seem to be only returned by the NT printer driver system

		public const ushort SMBE_invalidowner = 1307;	//Invalid security descriptor owner
		public const ushort SMBE_invalidsecuritydescriptor = 1338; //Invalid security descriptor
		public const ushort SMBE_unknownprinterdriver = 1797; //Unknown printer driver
		public const ushort SMBE_invalidprintername = 1801 ;  //Invalid printer name
		public const ushort SMBE_printeralreadyexists = 1802; //Printer already exists
		public const ushort SMBE_invaliddatatype = 1804    ;  //Invalid datatype
		public const ushort SMBE_invalidenvironment = 1805 ;  //Invalid environment
		public const ushort SMBE_invalidformsize    = 1903 ;  //Invalid form size
		public const ushort SMBE_printerdriverinuse = 3001 ;  //Printer driver in use

		//Error codes for the ERRSRV class

		public const ushort  SMBE_error = 1             ;  //Non specific error code
		public const ushort  SMBE_badpw = 2             ;  //Bad password
		public const ushort  SMBE_badtype = 3           ;  //reserved
		public const ushort  SMBE_access = 4            ;  //No permissions to do the requested operation
		public const ushort  SMBE_invnid = 5            ;  //tid invalid
		public const ushort  SMBE_invnetname = 6        ;  //Invalid servername
		public const ushort  SMBE_invdevice = 7         ;  //Invalid device
		public const ushort  SMBE_qfull = 49            ;  //Print queue full
		public const ushort  SMBE_qtoobig = 50          ;  //Queued item too big
		public const ushort  SMBE_qeof = 51             ;  //EOF in print queue dump
		public const ushort  SMBE_invpfid = 52          ;  //Invalid print file in smb_fid
		public const ushort  SMBE_smbcmd = 64           ;  //Unrecognised command
		public const ushort  SMBE_srverror = 65         ;  //smb server internal error
		public const ushort  SMBE_filespecs = 67        ;  //fid and pathname invalid combination
		public const ushort  SMBE_badlink = 68;
		public const ushort  SMBE_badpermits = 69       ;  //Access specified for a file is not valid
		public const ushort  SMBE_badpid = 70;
		public const ushort  SMBE_setattrmode = 71      ;  //attribute mode invalid
		public const ushort  SMBE_paused = 81           ;  //Message server paused
		public const ushort  SMBE_msgoff = 82           ;  //Not receiving messages
		public const ushort  SMBE_noroom = 83           ;  //No room for message
		public const ushort  SMBE_rmuns = 87            ;  //too many remote usernames
		public const ushort  SMBE_timeout = 88          ;  //operation timed out
		public const ushort  SMBE_noresource  = 89      ;  //No resources currently available for request.
		public const ushort  SMBE_toomanyuids = 90      ;  //too many userids
		public const ushort  SMBE_baduid = 91           ;  //bad userid
		public const ushort  SMBE_useMPX = 250          ;  //temporarily unable to use raw mode, use MPX mode
		public const ushort  SMBE_useSTD = 251          ;  //temporarily unable to use raw mode, use standard mode
		public const ushort  SMBE_contMPX = 252         ;  //resume MPX mode
		public const ushort  SMBE_badPW = 253           ;  //Check this out ...
		public const ushort  SMBE_nosupport = 0xFFFF;
		public const ushort  SMBE_unknownsmb = 22       ;  //from NT 3.5 response

		//Error codes for the ERRHRD class

		public const byte SMBE_nowrite = 19   ;  //read only media
		public const byte SMBE_badunit = 20   ;  //Unknown device
		public const byte SMBE_notready = 21  ;  //Drive not ready
		public const byte SMBE_badcmd = 22    ;  //Unknown command
		public const byte SMBE_data = 23      ;  //Data (CRC) error
		public const byte SMBE_badreq = 24    ;  //Bad request structure length
		public const byte SMBE_seek = 25      ;  //Seek error
		public const byte SMBE_badmedia = 26  ;  //Unknown media type
		public const byte SMBE_badsector = 27 ;  //Sector not found
		public const byte SMBE_nopaper = 28   ;  //Printer out of paper
		public const byte SMBE_write = 29     ;  //Write fault
		public const byte SMBE_read = 30      ;  //Read fault
		public const byte SMBE_general = 31   ;  //General failure
		//public const byte SMBE_badshare = 32  ;  //An open conflicts with an existing open
		//public const byte SMBE_lock = 33      ;  //Lock conflict or invalid mode, or unlock of
		//lock held by another process
		public const byte SMBE_wrongdisk = 34 ;  //The wrong disk was found in a drive
		public const byte SMBE_FCBunavail = 35;  //No FCBs are available to process request
		public const byte SMBE_sharebufexc = 36;//A sharing buffer has been exceeded
		public const byte SMBE_diskfull = 39;



		public const byte TRANSACTION_PIPE	= 0;
		public const byte TRANSACTION_MAILSLOT	= 1;
		// these are defines used to represent different types of TIDs.
		// dont use the value 0 for any of these
		public const byte TID_NORMAL	= 1;
		public const byte TID_IPC		= 2;


		public const uint GENERIC_RIGHTS_MASK    = 0xF0000000;
		public const uint GENERIC_ALL_ACCESS     = 0x10000000;
		public const uint GENERIC_EXECUTE_ACCESS = 0x20000000;
		public const uint GENERIC_WRITE_ACCESS   = 0x40000000;
		public const uint GENERIC_READ_ACCESS    = 0x80000000;
		public const uint ACCESS_SACL_ACCESS     = 0x00800000;
		public const uint SYSTEM_SECURITY_ACCESS = 0x01000000;
		public const uint MAXIMUM_ALLOWED_ACCESS = 0x02000000;
		public const uint STANDARD_RIGHTS_MASK = 0x00FF0000;
		public const uint DELETE_ACCESS        = 0x00010000;
		public const uint READ_CONTROL_ACCESS  = 0x00020000;
		public const uint WRITE_DAC_ACCESS     = 0x00040000;
		public const uint WRITE_OWNER_ACCESS   = 0x00080000;
		public const uint SYNCHRONIZE_ACCESS   = 0x00100000;
		public const uint SPECIFIC_RIGHTS_MASK = 0x0000FFFF; // Specific rights defined per-object



		public const ushort TFTP_RRQ	= 1;
		public const ushort TFTP_WRQ	= 2;
		public const ushort TFTP_DATA	= 3;
		public const ushort TFTP_ACK	= 4;
		public const ushort TFTP_ERROR	= 5;
		public const ushort TFTP_OACK	= 6;


		public static string GetTftpOpCodeString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{

				case TFTP_RRQ : Tmp = "Read Request"; break;
				case TFTP_WRQ : Tmp = "Write Request"; break;
				case TFTP_DATA : Tmp = "Data Packet"; break;
				case TFTP_ACK : Tmp = "Acknowledgement"; break;
				case TFTP_ERROR : Tmp = "Error Code"; break;
				case TFTP_OACK : Tmp = "Option Acknowledgement"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetTftpErrorCodeString( byte b )
		{
			string Tmp = "";

			switch( b )
			{
				case 0 : Tmp = "Not defined"; break;
				case 1 : Tmp = "File not found"; break;
				case 2 : Tmp = "Access violation"; break;
				case 3 : Tmp = "Disk full or allocation exceeded"; break;
				case 4 : Tmp = "Illegal TFTP Operation"; break;
				case 5 : Tmp = "Unknown transfer ID"; break;
				case 6 : Tmp = "File already exists"; break;
				case 7 : Tmp = "No such user"; break;
				case 8 : Tmp = "Option negotiation failed"; break;
				default : Tmp = "Unknown"; break;

			}

			return Tmp;
		}


		public const byte AR_HRD		= 0;
		public const byte AR_PRO		= 2;
		public const byte AR_HLN		= 4;
		public const byte AR_PLN		= 5;
		public const byte AR_OP		= 6;
		public const byte MIN_AARP_HEADER_SIZE	= 8;

		public const ushort AARP_REQUEST 	= 0x0001;
		public const ushort AARP_REPLY	= 0x0002;
		public const ushort AARP_PROBE	= 0x0003;
		public const ushort AARP_REQUEST_SWAPPED    = 0x0100;
		public const ushort AARP_REPLY_SWAPPED  = 0x0200;
		public const ushort AARP_PROBE_SWAPPED  = 0x0300;

		public const ushort AARPHRD_ETHER 	= 1;		// Ethernet 10Mbps
		public const ushort AARPHRD_TR	= 2;		// Token Ring

		public static string GetAarpOptionString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{
				case AARP_REQUEST : Tmp = "request"; break;
				case AARP_REPLY : Tmp = "reply"; break;
				case AARP_PROBE : Tmp = "probe"; break;
				case AARP_REQUEST_SWAPPED : Tmp = "request"; break;
				case AARP_REPLY_SWAPPED : Tmp = "reply"; break;
				case AARP_PROBE_SWAPPED : Tmp = "probe"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetAarpHardwareString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{
				case AARPHRD_ETHER : Tmp = "Ethernet"; break;
				case AARPHRD_TR : Tmp = "Token Ring"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static bool AARP_HW_IS_ETHER( ushort ar_hrd, byte ar_hln)
		{
			if( ( ar_hrd == AARPHRD_ETHER ) || ( ( ar_hrd == AARPHRD_TR ) && ( ar_hln == 6 ) ) )
				return true;

			return false;
		}


		public static bool AARP_PRO_IS_ATALK( ushort ar_pro, byte ar_pln )
		{
			if( ( ar_pro == ETHERTYPE_ATALK )  && ( ar_pln == 4 ) )
				return true;

			return false;
		}


		public static string GetAarpHardwareAddress( byte [] PacketData , ref int Index , byte Len , ushort Type ) 
		{
			int i = 0;
			string Tmp = "";

			if( AARP_HW_IS_ETHER( Type, Len ) ) 
			{
				// Ethernet address (or Token Ring address, which is the same type of address).
				return Function.GetMACAddress( PacketData , ref Index );
			}
			
			for( i = 0; i < Len; i ++ )
				Tmp += (char) PacketData[ Index ++ ];

			return Tmp;
		}


		public static string GetAarpIpAddress( byte [] PacketData , ref int Index , byte Len , ushort Type ) 
		{
			int i = 0;
			string Tmp = "";

			if( AARP_PRO_IS_ATALK( Type , Len ) ) 
			{
				// Appletalk address.
				//return atalkid_to_str(ad);
				return Function.GetMACAddress( PacketData , ref Index );
			}

			for( i = 0; i < Len; i ++ )
				Tmp += (char) PacketData[ Index ++ ];

			return Tmp;
		}



		public const byte DLSW_CANUREACH               = 0x03;
		public const byte DLSW_ICANREACH               = 0x04;
		public const byte DLSW_REACH_ACK               = 0x05;
		public const byte DLSW_DGRMFRAME               = 0x06;
		public const byte DLSW_XIDFRAME                = 0x07;
		public const byte DLSW_CONTACT                 = 0x08;
		public const byte DLSW_CONTACTED               = 0x09;
		public const byte DLSW_RESTART_DL              = 0x10;
		public const byte DLSW_DL_RESTARTED            = 0x11;
		public const byte DLSW_ENTER_BUSY              = 0x0C;
		public const byte DLSW_EXIT_BUSY               = 0x0D;
		public const byte DLSW_INFOFRAME               = 0x0A;
		public const byte DLSW_HALT_DL                 = 0x0E;
		public const byte DLSW_DL_HALTED               = 0x0F;
		public const byte DLSW_NETBIOS_NQ              = 0x12;
		public const byte DLSW_NETBIOS_NR              = 0x13;
		public const byte DLSW_DATAFRAME               = 0x14;
		public const byte DLSW_HALT_DL_NOACK           = 0x19;
		public const byte DLSW_NETBIOS_ANQ             = 0x1A;
		public const byte DLSW_NETBIOS_ANR             = 0x1B;
		public const byte DLSW_KEEPALIVE               = 0x1D;
		public const byte DLSW_CAP_EXCHANGE            = 0x20;
		public const byte DLSW_IFCM                    = 0x21;
		public const byte DLSW_TEST_CIRCUIT_REQ        = 0x7A;
		public const byte DLSW_TEST_CIRCUIT_RSP        = 0x7B;

		public const byte DLSW_INFO_HEADER	= 16;
		public const byte DLSW_CMD_HEADER	= 72;

		public static string GetDlswTypeString( byte b )
		{
			string [] DlswType = new string[256];
			int i = 0;

			for( i = 0; i < 256; i ++ )
				DlswType[i] = "Unknown";
			

			DlswType[DLSW_CANUREACH] = "Can U Reach Station-circuit start";
			DlswType[DLSW_ICANREACH] = "I Can Reach Station-circuit start";
			DlswType[DLSW_REACH_ACK] = "Reach Acknowledgment";
			DlswType[DLSW_DGRMFRAME] = "Datagram Frame";
			DlswType[DLSW_XIDFRAME] = "XID Frame";
			DlswType[DLSW_CONTACT] = "Contact Remote Station";
			DlswType[DLSW_CONTACTED] = "Remote Station Contacted";
			DlswType[DLSW_RESTART_DL] = "Restart Data Link";
			DlswType[DLSW_DL_RESTARTED] = "Data Link Restarted";
			DlswType[DLSW_ENTER_BUSY] = "Enter Busy";
			DlswType[DLSW_EXIT_BUSY] = "Exit Busy";
			DlswType[DLSW_INFOFRAME] = "Information (I) Frame";
			DlswType[DLSW_HALT_DL] = "Halt Data Link";
			DlswType[DLSW_DL_HALTED] = "Data Link Halted";
			DlswType[DLSW_NETBIOS_NQ] = "NETBIOS Name Query-circuit setup";
			DlswType[DLSW_NETBIOS_NR] = "NETBIOS Name Recog-circuit setup";
			DlswType[DLSW_DATAFRAME] = "Data Frame";
			DlswType[DLSW_HALT_DL_NOACK] = "Halt Data Link with no Ack";
			DlswType[DLSW_NETBIOS_ANQ] = "NETBIOS Add Name Query";
			DlswType[DLSW_NETBIOS_ANR] = "NETBIOS Add Name Response";
			DlswType[DLSW_KEEPALIVE] = "Transport Keepalive Message";
			DlswType[DLSW_CAP_EXCHANGE] = "Capabilities Exchange";
			DlswType[DLSW_IFCM] = "Independent Flow Control Message";
			DlswType[DLSW_TEST_CIRCUIT_REQ] = "Test Circuit Request";
			DlswType[DLSW_TEST_CIRCUIT_RSP] = "Test Circuit Response";

			return DlswType[ b ];
		}

		public static string GetDlswVersionString( byte b )
		{
			string Tmp = "";

			switch( b )
			{
				case 0x31 : Tmp = "Version 1 (RFC 1795)"; break;
				case 0x32 : Tmp = "Version 2 (RFC 2166)"; break;
				case 0x33 : Tmp = "Vendor Specific"; break;
				case 0x34 : Tmp = "Vendor Specific"; break;
				case 0x35 : Tmp = "Vendor Specific"; break;
				case 0x36 : Tmp = "Vendor Specific"; break;
				case 0x37 : Tmp = "Vendor Specific"; break;
				case 0x38 : Tmp = "Vendor Specific"; break;
				case 0x39 : Tmp = "Vendor Specific"; break;
				case 0x3A : Tmp = "Vendor Specific"; break;
				case 0x3B : Tmp = "Vendor Specific"; break;
				case 0x3C : Tmp = "Vendor Specific"; break;
				case 0x3D : Tmp = "Vendor Specific"; break;
				case 0x3E : Tmp = "Vendor Specific"; break;
				case 0x3F : Tmp = "Vendor Specific"; break;
				case 0x4B : Tmp = "Pre 1 (RFC 1434)"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetDlswVectorString( byte b )
		{
			string Tmp = "";

			switch( b )
			{
				case 0x81 : Tmp = "Vendor ID Control Vector"; break;
				case 0x82 : Tmp = "DLSw Version Control Vector"; break;
				case 0x83 : Tmp = "Initial Pacing Window Control Vector"; break;
				case 0x84 : Tmp = "Version String Control Vector"; break;
				case 0x85 : Tmp = "Mac Address Exclusivity Control Vector"; break;
				case 0x86 : Tmp = "Supported SAP List Control Vector"; break;
				case 0x87 : Tmp = "TCP Connections Control Vector"; break;
				case 0x88 : Tmp = "NetBIOS Name Exclusivity Control Vector"; break;
				case 0x89 : Tmp = "MAC Address List Control Vector"; break;
				case 0x8a : Tmp = "NetBIOS Name List Control Vector"; break;
				case 0x8b : Tmp = "Vendor Context Control Vector"; break;
				case 0x8c : Tmp = "Multicast Capabilities Control Vector"; break;
				case 0x8d : Tmp = "Reserved for future use"; break;
				case 0x8e : Tmp = "Reserved for future use"; break;
				case 0x8f : Tmp = "Reserved for future use"; break;
				case 0x90 : Tmp = "Reserved for future use"; break;
				case 0x91 : Tmp = " Control Vector"; break;
				case 0x92 : Tmp = " Control Vector"; break;
				case 0x93 : Tmp = " Control Vector"; break;
				case 0x94 : Tmp = " Control Vector"; break;
				case 0x95 : Tmp = " Control Vector"; break;
				case 0x96 : Tmp = " Control Vector"; break;
				default : Tmp = "Unknown"; break;
			}
	
			return Tmp;
		}


		public static string GetDlswPriorityString( byte b )
		{
			string Tmp = "";

			switch( b )
			{
				case 0 : Tmp = "Unsupported"; break;
				case 1 : Tmp = "Low Priority"; break;
				case 2 : Tmp = "Medium Priority"; break;
				case 3 : Tmp = "High Priority"; break;
				case 4 : Tmp = "Highest Priority"; break;
				case 5 : Tmp = "Reserved"; break;
				case 6 : Tmp = "Reserved"; break;
				case 7 : Tmp = "Reserved"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public const ushort DLSW_GDSID_SEND		= 0x1520;
		public const ushort DLSW_GDSID_ACK		= 0x1521;
		public const ushort DLSW_GDSID_REF		= 0x1522;


		public static string GetDlswGdSidString( ushort b )
		{
			string Tmp = "";

			switch( b )
			{
				case DLSW_GDSID_SEND : Tmp = "Request Capabilities GDS"; break;
				case DLSW_GDSID_ACK : Tmp = "Response Capabilities GDS"; break;
				case DLSW_GDSID_REF : Tmp = "Refuse Capabilities GDS"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetDlswRefuseString( byte b )
		{
			string Tmp = "";

			switch( b )
			{

				case 0x1 : Tmp = "invalid GDS length for a DLWs Capabilities Exchange Request"; break;
				case 0x2 : Tmp = "invalid GDS id for a DLSw Capabilities Exchange Request"; break;
				case 0x3 : Tmp = "vendor Id control vector is missing"; break;
				case 0x4 : Tmp = "DLSw Version control vector is missing"; break;
				case 0x5 : Tmp = "initial Pacing Window control vector is missing"; break;
				case 0x6 : Tmp = "length of control vectors doewn't correlate to the length of the GDS variable"; break;
				case 0x7 : Tmp = "invalid control vector id"; break;
				case 0x8 : Tmp = "length of control vector invalid"; break;
				case 0x9 : Tmp = "invalid control vector data value"; break;
				case 0xa : Tmp = "duplicate control vector"; break;
				case 0xb : Tmp = "out-of-sequence control vector"; break;
				case 0xc : Tmp = "DLSw Supported SAP List control vector is missing"; break;
				case 0xd : Tmp = "inconsistent DLSw Version, Multicast Capabilities,and TCP Connections CV received on the inbound Capabilities exchange"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public const byte MAILSLOT_UNKNOWN              = 0;
		public const byte MAILSLOT_BROWSE               = 1;
		public const byte MAILSLOT_LANMAN               = 2;
		public const byte MAILSLOT_NET                  = 3;
		public const byte MAILSLOT_TEMP_NETLOGON        = 4;
		public const byte MAILSLOT_MSSP                 = 5;




	}
}
