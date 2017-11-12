using System;
using System.Windows.Forms;

namespace MyClasses
{

	using PACKET_INTERNET = Packet32.PACKET_INTERNET;
	using PACKET_TCP = Packet32.PACKET_TCP;
	using PACKET_UDP = Packet32.PACKET_UDP;
	using PACKET_HTTP = Packet32.PACKET_HTTP;
	using PACKET_ICMP = Packet32.PACKET_ICMP;
	using PACKET_EIGRP = Packet32.PACKET_EIGRP;
	using PACKET_FRAME = Packet32.PACKET_FRAME;
	using PACKET_ITEM = Packet32.PACKET_ITEM;
	using PACKET_NETBIOS_SESSION_SERVICE = Packet32.PACKET_NETBIOS_SESSION_SERVICE;
	using PACKET_SMB = Packet32.PACKET_SMB;
	using PACKET_SMB_SSMB_REQUEST = Packet32.PACKET_SMB_SSMB_REQUEST;
	using PACKET_SMB_BODY = Packet32.PACKET_SMB_BODY;
	using PACKET_SMB_HEADER = Packet32.PACKET_SMB_HEADER;

	public class PacketIP
	{


		public static int PACKET_FRAME_LENGTH = 20;
		public static int PACKET_ETHERNET_LENGTH = 14;
		public static int PACKET_INTERNET_LENGTH = 20;
		public static int PACKET_TCP_LENGTH = 20;
		public static int PACKET_NETBIOS_SESSION_SERVICE_LENGTH = 4;
		public static int PACKET_UDP_LENGTH = 8;
		public static int PACKET_ICMP_LENGTH = 8;
		public static int PACKET_EIGRP_LENGTH = 40;
		public static int PACKET_SMB_HEADER_LENGTH = 32;
		public static int PACKET_SMB_BODY_LENGTH = 3;


		public static byte TCP_FLAGS_CWR_CONGESTION_WINDOW_REDUCED = 0x80;
		public static byte TCP_FLAGS_ECN_ECHO = 0x40;
		public static byte TCP_FLAGS_URGENT = 0x20;
		public static byte TCP_FLAGS_ACKNOWLEDGEMENT = 0x10;
		public static byte TCP_FLAGS_PUSH = 0x08;
		public static byte TCP_FLAGS_RESET = 0x04;
		public static byte TCP_FLAGS_SYN = 0x02;
		public static byte TCP_FLAGS_FIN = 0x01;


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

		public const int IPPORT_ECHO             = 7;
		public const int IPPORT_DISCARD          = 9;
		public const int IPPORT_SYSTAT           = 11;
		public const int IPPORT_DAYTIME          = 13;
		public const int IPPORT_NETSTAT          = 15;
		public const int IPPORT_FTP              = 21;
		public const int IPPORT_TELNET           = 23;
		public const int IPPORT_SMTP             = 25;
		public const int IPPORT_TIMESERVER       = 37;
		public const int IPPORT_NAMESERVER       = 42;
		public const int IPPORT_DNS              = 43;
		public const int IPPORT_MTP              = 57;
		public const int IPPORT_TFTP             = 69;
		public const int IPPORT_RJE              = 77;
		public const int IPPORT_FINGER           = 79;
		public const int IPPORT_HTTP             = 80;
		public const int IPPORT_HTTP2            = 8080;
		public const int IPPORT_SSDP             = 1031;
		public const int IPPORT_TTYLINK          = 87;
		public const int IPPORT_SUPDUP           = 95;
		public const int IPPORT_EPMEP			 = 135;
		public const int IPPORT_NETBIOS_NS		 = 137;
		public const int IPPORT_NETBIOS_DATAGRAM = 138;
		public const int IPPORT_NETBIOS_SSN      = 139;
		public const int IPPORT_EXECSERVER       = 512;
		public const int IPPORT_LOGINSERVER      = 513;
		public const int IPPORT_CMDSERVER        = 514;
		public const int IPPORT_WHOSERVER        = 513;
		public const int IPPORT_ROUTESERVER      = 520;

		public const int NORMAL = 0;
		public const int VALUE = 1;

		private PACKET_INTERNET PInternet;
		private PACKET_TCP PTcp;
		private PACKET_UDP PUdp;
		private PACKET_HTTP PHttp;
		private PACKET_ICMP PIcmp;
		private PACKET_EIGRP PEigrp;
		private PACKET_NETBIOS_SESSION_SERVICE PNBSessionService;
		private PACKET_SMB PSmb;
		private PACKET_SMB_SSMB_REQUEST PSsmbRequest;
		private PACKET_SMB_BODY PSmbBody;
		private PACKET_SMB_HEADER PSmbHeader;

		public PacketIP()
		{

		}


		unsafe public string GetProtocolStr( int Prtcl )
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

		unsafe public string GetPortStr( int Prt )
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

		unsafe static string GetTCPFLAGSStr( byte Flg )
		{
			string Tmp = "";

			if( ( ( Flg & 0x80 ) >> 7 ) == 1 )
				Tmp += "Congestion window reduced ( CWR ),";

			if( ( ( Flg & 0x40 ) >> 6 ) == 1 )
				Tmp += "ECN-Echo,";

			if( ( ( Flg & 0x20 ) >> 5 ) == 1 )
				Tmp += "Urgent,";

			if( ( ( Flg & 0x10 ) >> 4 ) == 1 )
				Tmp += "Acknowldegement,";

			if( ( ( Flg & 0x08 ) >> 3 ) == 1 )
				Tmp += "Push,";

			if( ( ( Flg & 0x04 ) >> 2 ) == 1 )
				Tmp += "Reset,";

			if( ( ( Flg & 0x02 ) >> 1 ) == 1 )
				Tmp += "Sync,";

			if( ( Flg & 0x01 ) == 1 )
				Tmp += "Fin,";

			if( Tmp != "" )
				Tmp = Tmp.Substring( 0 , Tmp.Length - 1 );

			return Tmp;
		}

		public unsafe int GetPNBSSPart( int CurrentPtr )
		{
			byte * ptr = ( byte * ) CurrentPtr;
			byte b = 0;
			ushort u = 0;

			b = *( ptr );
			PNBSessionService.MessageType = b;
			b = *( ptr + 1 );
			PNBSessionService.Flags = b;
			u = AllFunctions.Get2Bytes( ptr + 2 , NORMAL );
			PNBSessionService.Length = u;

			return ( CurrentPtr + PACKET_NETBIOS_SESSION_SERVICE_LENGTH );

		}

		public unsafe void GetSMBPart( int CurrentPtr )
		{
			byte * ptr = ( byte * ) CurrentPtr;
			byte b = 0;
			ushort u = 0;
			int i = 0;

			PSmbHeader.ServerComponent = ""; ptr++;
			PSmbHeader.ServerComponent += (char) *( ptr++ );
			PSmbHeader.ServerComponent += (char) *( ptr++ );
			PSmbHeader.ServerComponent += (char) *( ptr++ );

			b = *( ptr++ );
			PSmbHeader.Command = b;

			b = *( ptr++ );
			PSmbHeader.ErrorClass = b;

			b = *( ptr++ );
			PSmbHeader.Reserved1 = b;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PSmbHeader.ErrorCode = u;

			b = *( ptr++ );
			PSmbHeader.Flags = b;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PSmbHeader.Flags2 = u;

			PSmbHeader.Reserved2 = new byte[12];
			for( i = 0; i < 12; i ++ )
				PSmbHeader.Reserved2[i] = *( ptr++ );

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PSmbHeader.TreeId = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PSmbHeader.ProcessId = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PSmbHeader.UserId = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PSmbHeader.MultiplexId = u;

			if( PSmbHeader.Command == 0x0d )
			{
				PSmbBody.WordCount = *( ptr++ );
				PSmbBody.ByteCount = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
				if( PSmbBody.ByteCount > 0 )
				{
					PSsmbRequest.OriginatorBufferFormat = *( ptr++ );
					i = 0;
					PSsmbRequest.OriginatorName = "";
					while( *( ptr++ ) != 0 )
						PSsmbRequest.OriginatorName += (char) *( ptr );

					ptr++;
					PSsmbRequest.DestinationBufferFormat = *( ptr++ );
					PSsmbRequest.DestinationName = "";
					while( *( ptr++ ) != 0 )
						PSsmbRequest.DestinationName += (char) *( ptr );
					
					ptr++;
					PSsmbRequest.MessageBufferFormat = *( ptr++ );
					PSsmbRequest.MessageLen = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
					PSsmbRequest.Message = "";
					for( i = 0; i < PSsmbRequest.MessageLen; i ++ )
						PSsmbRequest.Message += (char) *( ptr++ );

					PSmb.ConnectedObject = PSsmbRequest;
				}

				PSmb.SmbHeader = PSmbHeader;
				PSmb.SmbBody = PSmbBody;

			}

		}

		public unsafe int GetICMPPart( int CurrentPtr , int PacketSize )
		{
			byte * ptr = ( byte * ) CurrentPtr;
			int Size = 0;
			byte b;
			ushort val = 0;
			int i = 0;

			b = *( ptr++ );
			PIcmp.Type = b;

			b = *( ptr++ );
			PIcmp.Code = b;

			val = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PIcmp.Checksum = val;

			val = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PIcmp.Identifier = val;

			val = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PIcmp.SequenceNumber = val;

			Size = PacketSize - PACKET_ETHERNET_LENGTH - PACKET_INTERNET_LENGTH - PACKET_ICMP_LENGTH;

			PIcmp.Data = new byte[Size];
			for( i = 0; i < Size; i ++ )
				PIcmp.Data[i] = *( ptr++ );

			return ( CurrentPtr + Size + PACKET_ICMP_LENGTH );
		}

		unsafe public int GetHTTPPart( int CurrentPtr , int PacketSize )
		{
			byte * ptr = ( byte * ) CurrentPtr;
			int Size = PacketSize - PACKET_ETHERNET_LENGTH - PACKET_INTERNET_LENGTH;
			string Tmp = "";
			int i = 0;
			char [] seperator = new char[2];

			seperator[0] = (char) 13;
			seperator[1] = (char) 10;

			for( i = 0; i < Size; i ++ )
			{
				if( ( *( ptr + i ) > 31 ) | 
					( *( ptr + i ) < 129 ) | 
					( *( ptr + i ) == 13 ) | 
					( *( ptr + i ) == 10 ) )
					Tmp += (char) *( ptr );
				else
					Tmp += " ";

				ptr++;
			}
				
			PHttp.Contents = Tmp.Split( seperator );

			/*if( PHttp.Contents != null )
			{
				for( i = 0; i < PHttp.Contents.GetLength(0); i ++ )
					PHttp.Contents[i] += "\\r\\n";
			}*/

			return ( CurrentPtr + Size );
		}

		unsafe public int GetTCPPart( int CurrentPtr )
		{
			ushort u = 0;
			uint ui = 0;
			byte b = 0;
			ushort * usptr = ( ushort * ) CurrentPtr;
			uint * uiptr = ( uint * ) CurrentPtr;
			byte * ptr = ( byte * ) CurrentPtr;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PTcp.SourcePort = u;
			PTcp.SourcePortStr = GetPortStr( (int) u );

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PTcp.DestinationPort = u;
			PTcp.DestinationPortStr = GetPortStr( (int) u );

			ui = AllFunctions.Get4Bytes( ptr , NORMAL ); ptr += 4;
			PTcp.SequenceNumber = ui; // ?

			ui = AllFunctions.Get4Bytes( ptr , NORMAL ); ptr += 4;
			PTcp.Acknowledgement = ui;

			b = *( ptr++ );
			PTcp.HeaderLength = (byte) ( ( (int) b >> 4 ) * 4 );

			b = *( ptr++ );
			PTcp.Falgs = b;
			PTcp.FalgsStr = GetTCPFLAGSStr( b );

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PTcp.WindowSize = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PTcp.Checksum = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PTcp.Options = u;

			return ( CurrentPtr + PACKET_TCP_LENGTH );

		}

		public unsafe int GetUDPPart( int CurrentPtr )
		{
			byte * ptr = ( byte * ) CurrentPtr;
			ushort u = 0;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PUdp.SourcePort = u;
			PUdp.SourcePortStr = GetPortStr( (int) u );

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PUdp.DestinationPort = u;
			PUdp.DestinationPortStr = GetPortStr( (int) u );

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PUdp.Length = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PUdp.Checksum = u;

			return ( CurrentPtr + PACKET_UDP_LENGTH );
		}


		unsafe public int GetEIGRPPart( int CurrentPtr )
		{
			byte * ptr = ( byte * ) CurrentPtr;
			ushort u = 0;
			uint ui = 0;
			byte b = 0;

			b = *( ptr++ );
			PEigrp.Version = b;
	
			b = *( ptr++ );
			PEigrp.OpCode = b;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PEigrp.Checksum = u;

			ui = AllFunctions.Get4Bytes( ptr , NORMAL ); ptr += 4;
			PEigrp.Flags = ui;

			ui = AllFunctions.Get4Bytes( ptr , NORMAL ); ptr += 4;
			PEigrp.Sequence = ui;

			ui = AllFunctions.Get4Bytes( ptr , NORMAL ); ptr += 4;
			PEigrp.Acknowledge = ui;

			ui = AllFunctions.Get4Bytes( ptr , NORMAL ); ptr += 4;
			PEigrp.AutonomousSystem = ui;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PEigrp.Parameters.Type = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PEigrp.Parameters.Size = u;

			b = *( ptr++ );
			PEigrp.Parameters.K1 = b;

			b = *( ptr++ );
			PEigrp.Parameters.K2 = b;

			b = *( ptr++ );
			PEigrp.Parameters.K3 = b;

			b = *( ptr++ );
			PEigrp.Parameters.K4 = b;

			b = *( ptr++ );
			PEigrp.Parameters.K5 = b;

			b = *( ptr++ );
			PEigrp.Parameters.Reserved = b;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PEigrp.Parameters.HoldTime = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PEigrp.Software.Type = u;

			u = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PEigrp.Software.Size = u;

			b = *( ptr++ );
			PEigrp.Software.IOS = b.ToString() + ".";
			b = *( ptr++ );
			PEigrp.Software.IOS += b.ToString(); 

			b = *( ptr++ );
			PEigrp.Software.EigrpRelease = b.ToString() + ".";
			b = *( ptr++ );
			PEigrp.Software.EigrpRelease += b.ToString(); 

			return ( CurrentPtr + PACKET_EIGRP_LENGTH );

		}

		unsafe public int GetINTERNETPart( int CurrentPtr )
		{
			byte b = 0;
			ushort  us = 0;
			byte * ptr = ( byte * ) CurrentPtr;
			ushort * usptr = ( ushort * ) CurrentPtr;

			b = *( ptr++ );
			PInternet.Version = (byte) ( (int) b >> 4 );
			PInternet.HeaderLength = (byte) ( ( (int) b & 0x0f ) * 4 );

			b = *( ptr++ );
			PInternet.DifferentiatedServicesField = b;
			PInternet.DifferentiatedServicesFieldStr = "";
			if( ( b & 0x0d ) > 0 )
				PInternet.DifferentiatedServicesFieldStr += "Differentiated Services Codepoint ( Default : 0x00 ),";
			if( ( b & 0x02 ) > 0 )
				PInternet.DifferentiatedServicesFieldStr += "ECN Capable Transport ( ECT ),";
			if( ( b & 0x01 ) > 0 )
				PInternet.DifferentiatedServicesFieldStr += "ECN-CE,";

			if( PInternet.DifferentiatedServicesFieldStr != "" )
				PInternet.DifferentiatedServicesFieldStr = PInternet.DifferentiatedServicesFieldStr.Substring( 0 , PInternet.DifferentiatedServicesFieldStr.Length - 1 );

			us = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PInternet.Length = us;

			us = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PInternet.Identification = us;

			us = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PInternet.Flags = (byte)( (int) us >> 12 );
			if( ( PInternet.Flags & 0x04 ) > 0 )
				PInternet.FlagsStr = "Dont fragment";
			if( ( PInternet.Flags & 0x02 ) > 0 )
				PInternet.FlagsStr = "More fragments";

			PInternet.FragmentOffset = (ushort) ( (int) us & 0x0f );
			
			b = *( ptr++ );
			PInternet.TimeToLive = b;

			b = *( ptr++ );
			PInternet.Protocol = b;
			PInternet.ProtocolStr = GetProtocolStr( (int) b );

			us = AllFunctions.Get2Bytes( ptr , NORMAL ); ptr += 2;
			PInternet.HeaderChecksum = us;

			PInternet.SourceStr = "";
			b = *( ptr++ );
			PInternet.SourceStr += b.ToString() + ".";
			b = *( ptr++ );
			PInternet.SourceStr += b.ToString() + ".";
			b = *( ptr++ );
			PInternet.SourceStr += b.ToString() + ".";
			b = *( ptr++ );
			PInternet.SourceStr += b.ToString();
			PInternet.Source = (uint) AllFunctions.IpAddressToInt( PInternet.SourceStr );

			PInternet.DestinationStr = "";
			b = *( ptr++ );
			PInternet.DestinationStr += b.ToString() + ".";
			b = *( ptr++ );
			PInternet.DestinationStr += b.ToString() + ".";
			b = *( ptr++ );
			PInternet.DestinationStr += b.ToString() + ".";
			b = *( ptr++ );
			PInternet.DestinationStr += b.ToString();
			PInternet.Destination = (uint) AllFunctions.IpAddressToInt( PInternet.DestinationStr );

			return ( CurrentPtr + PACKET_INTERNET_LENGTH );

		}


		unsafe public object EditIPPacket( int CurrentAddr , int PacketSize , ref string TypeStr )
		{
			int CurrentPtr = CurrentAddr;
			
			TypeStr = "IP";
			CurrentPtr = GetINTERNETPart( CurrentPtr );

			if( PInternet.Protocol == IPPROTO_TCP )
			{
				TypeStr = "TCP";
				CurrentPtr = GetTCPPart( CurrentPtr );

				if( ( PTcp.SourcePort == IPPORT_HTTP ) ||
					( PTcp.DestinationPort == IPPORT_HTTP ) ||
					( PTcp.SourcePort == IPPORT_HTTP2 ) ||
					( PTcp.DestinationPort == IPPORT_HTTP2 ) )
				{
					TypeStr = "HTTP";
					CurrentPtr = GetHTTPPart( CurrentPtr, PacketSize );
					PTcp.ConnectedObject = PHttp;
				}
				else if( ( PTcp.SourcePort == IPPORT_NETBIOS_SSN ) ||( PTcp.DestinationPort == IPPORT_NETBIOS_SSN ) )
				{
					TypeStr = "NBSS";
					CurrentPtr = GetPNBSSPart( CurrentPtr );
					if( PNBSessionService.Length != 0 )
					{
						if( PNBSessionService.MessageType == 0 )
						{
							TypeStr = "SMB";
							GetSMBPart( CurrentPtr );
							PNBSessionService.ConnectedObject = PSmb;
						}
						else
						{
							PNBSessionService.ConnectedObject = null;
						}
					}
					else
						PNBSessionService.ConnectedObject = null;

					PTcp.ConnectedObject = PNBSessionService;
				}

				PInternet.ConnectedObject = PTcp;
			}
			else if( PInternet.Protocol == IPPROTO_UDP )
			{
				TypeStr = "UDP";
				CurrentPtr = GetUDPPart( CurrentPtr);
				PInternet.ConnectedObject = PUdp;

				if( ( PUdp.SourcePort == IPPORT_SSDP ) || ( PUdp.DestinationPort == IPPORT_SSDP ) )
				{
					TypeStr = "HTTP";
					CurrentPtr = GetHTTPPart( CurrentPtr, PacketSize );
					PUdp.ConnectedObject = PHttp;
				}
			}
			else if( PInternet.Protocol == IPPROTO_ICMP )
			{
				TypeStr = "ICMP";
				CurrentPtr = GetICMPPart( CurrentPtr , PacketSize );
				PInternet.ConnectedObject = PIcmp;
			}
			else if( PInternet.Protocol == IPPROTO_EIGRP )
			{
				TypeStr = "EIGRP";
				CurrentPtr = GetEIGRPPart( CurrentPtr );
				PInternet.ConnectedObject = PEigrp;
			}

			return PInternet;
		}


	}
}
