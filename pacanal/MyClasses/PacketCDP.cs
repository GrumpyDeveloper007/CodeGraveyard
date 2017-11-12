using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketCDP
	{

		public struct PACKET_CDP_ADDRESS
		{
			public byte ProtocolType;
			public string ProtocolTypeStr;
			public byte ProtocolLength;
			public byte Protocol;
			public string ProtocolStr;
			public ushort AddressLength;
			public string IpAddress;
		}

		public struct PACKET_CDP_ADDRESSES
		{
			public ushort Type;
			public ushort Length;
			public uint AddressCount;
			public PACKET_CDP_ADDRESS [] IpAddresses;
		}


		public struct PACKET_CDP_CONTENTS
		{
			public ushort Type;
			public ushort Length;
			public string Name;
		}

		public struct PACKET_CDP
		{
			public byte Version;
			public byte TTL;
			public ushort Checksum;
			public PACKET_CDP_CONTENTS DeviceId;
			public PACKET_CDP_CONTENTS SoftwareVersion;
			public PACKET_CDP_CONTENTS Platform;
			public PACKET_CDP_ADDRESSES Addresses;
			public PACKET_CDP_CONTENTS PortId;
			public ushort CapabilitiesType;
			public ushort CapabilitiesLength;
			public uint CapabilitiesFlag;
			public string CapabilitiesFlagStr;
			public PACKET_CDP_CONTENTS VTP;
			public PACKET_CDP_CONTENTS Duplex;
		}


		
		public PacketCDP()
		{
		}


		public static string GetTypeList( ushort b )
		{
			int i = 0;
			string [] TypeList = new string[256];

			for( i = 0; i < 256; i ++ )
				TypeList[i] = "Unknown";

			TypeList[Const.TYPE_DEVICE_ID] = "Device ID";
			TypeList[Const.TYPE_ADDRESS] = "Addresses";
			TypeList[Const.TYPE_PORT_ID] = "Port ID";
			TypeList[Const.TYPE_CAPABILITIES] = "Capabilities";
			TypeList[Const.TYPE_IOS_VERSION] = "Software version";
			TypeList[Const.TYPE_PLATFORM] = "Platform";
			TypeList[Const.TYPE_IP_PREFIX] = "IP Prefix (used for ODR)";
			TypeList[Const.TYPE_VTP_MGMT_DOMAIN] = "VTP Management Domain";
			TypeList[Const.TYPE_NATIVE_VLAN] = "Native VLAN";
			TypeList[Const.TYPE_DUPLEX] = "Duplex";

			return TypeList[b];

		}

		public static string GetProtocolSubTypeList( byte b )
		{
			int i = 0;
			string [] ProtocolSubTypeList = new string[256];

			for( i = 0; i < 256; i ++ )
				ProtocolSubTypeList[i] = "Unknown";

			ProtocolSubTypeList[Const.NLPID_NULL] = "NULL";
			ProtocolSubTypeList[Const.NLPID_IPI_T_70] = "IP T.70";
			ProtocolSubTypeList[Const.NLPID_SPI_X_29] = "SPI X.29";
			ProtocolSubTypeList[Const.NLPID_X_633] = "X.633";
			ProtocolSubTypeList[Const.NLPID_Q_931] = "Q931";
			ProtocolSubTypeList[Const.NLPID_Q_2931] = "Q2931";
			ProtocolSubTypeList[Const.NLPID_Q_2119] = "Q2119";
			ProtocolSubTypeList[Const.NLPID_SNAP] = "SNAP";
			ProtocolSubTypeList[Const.NLPID_ISO8473_CLNP] = "ISO 8473 CLNP";
			ProtocolSubTypeList[Const.NLPID_ISO9542_ESIS] = "ISO 9542 ESIS";
			ProtocolSubTypeList[Const.NLPID_ISO10589_ISIS] = "ISO 10589 ISIS";
			ProtocolSubTypeList[Const.NLPID_ISO10747_IDRP] = " ISO 10747 IDRP";
			ProtocolSubTypeList[Const.NLPID_ISO9542X25_ESIS] = "ISO 9542 X.25 ESIS";
			ProtocolSubTypeList[Const.NLPID_ISO10030] = "ISO 10030";
			ProtocolSubTypeList[Const.NLPID_ISO11577] = "ISO 11577";
			ProtocolSubTypeList[Const.NLPID_IP6] = "IP.6";
			ProtocolSubTypeList[Const.NLPID_COMPRESSED] = "COMPRESSED";
			ProtocolSubTypeList[Const.NLPID_SNDCF] = "SNDCF";
			ProtocolSubTypeList[Const.NLPID_IP] = "IP";
			ProtocolSubTypeList[Const.NLPID_PPP] = "PPP";

			return ProtocolSubTypeList[b];

		}

		public static string GetProtocolTypeList( byte b )
		{
			int i = 0;
			string [] ProtocolTypeList = new string[256];

			for( i = 0; i < 256; i ++ )
				ProtocolTypeList[i] = "Unknown";

			ProtocolTypeList[Const.PROTO_TYPE_NLPID] = "NLPID";
			ProtocolTypeList[Const.PROTO_TYPE_IEEE_802_2] = "802.2";

			return ProtocolTypeList[b];

		}

		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			TreeNode mNode1;
			TreeNode mNode2;
			string Tmp = "";
			int i = 0;
			int kk = 0;
			PACKET_CDP PCdp;


			mNodex = new TreeNode();
			mNodex.Text = "CDP ( Cisco Discovery Protocol )";
			kk = Index;

			try
			{
				PCdp.Version = PacketData[ Index++ ];
				Tmp = "Version :" + Function.ReFormatString( PCdp.Version , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PCdp.TTL = PacketData[ Index++ ];
				Tmp = "TTL :" + Function.ReFormatString( PCdp.TTL , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PCdp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Checksum :" + Function.ReFormatString( PCdp.Checksum , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				// Device Id Section ................
				mNode1 = new TreeNode();
				mNode1.Text = "Device Id";

				PCdp.DeviceId.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type :" + Function.ReFormatString( PCdp.DeviceId.Type , GetTypeList(PCdp.DeviceId.Type) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.DeviceId.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length :" + Function.ReFormatString( PCdp.DeviceId.Length , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.DeviceId.Name = "";
				for( i = 0; i < PCdp.DeviceId.Length - 4; i ++ )
					PCdp.DeviceId.Name += (char) PacketData[ Index++ ];

				Tmp = "Name : " + PCdp.DeviceId.Name;
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - PCdp.DeviceId.Length + 4 , PCdp.DeviceId.Length - 4 , false );

				Function.SetPosition( ref mNode1 , Index - PCdp.DeviceId.Length , PCdp.DeviceId.Length , true );

				mNodex.Nodes.Add( mNode1 );

				// Software Version Section ................
				mNode1 = new TreeNode();
				mNode1.Text = "Software Version";

				PCdp.SoftwareVersion.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type :" + Function.ReFormatString( PCdp.SoftwareVersion.Type , GetTypeList(PCdp.SoftwareVersion.Type) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.SoftwareVersion.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length :" + Function.ReFormatString( PCdp.SoftwareVersion.Length , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.SoftwareVersion.Name = "";
				for( i = 0; i < PCdp.SoftwareVersion.Length - 4; i ++ )
					PCdp.SoftwareVersion.Name += (char) PacketData[ Index++ ];

				Tmp = "Name : " + PCdp.SoftwareVersion.Name;
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - PCdp.SoftwareVersion.Length + 4 , PCdp.SoftwareVersion.Length - 4 , false );

				Function.SetPosition( ref mNode1 , Index - PCdp.SoftwareVersion.Length , PCdp.SoftwareVersion.Length , true );

				mNodex.Nodes.Add( mNode1 );

				// Platform Section ................
				mNode1 = new TreeNode();
				mNode1.Text = "Platform";

				PCdp.Platform.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type :" + Function.ReFormatString( PCdp.Platform.Type , GetTypeList(PCdp.Platform.Type) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.Platform.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length :" + Function.ReFormatString( PCdp.Platform.Length , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.Platform.Name = "";
				for( i = 0; i < PCdp.Platform.Length - 4; i ++ )
					PCdp.Platform.Name += (char) PacketData[ Index++ ];

				Tmp = "Name : " + PCdp.Platform.Name;
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - PCdp.Platform.Name.Length , PCdp.Platform.Name.Length , false );

				Function.SetPosition( ref mNode1 , Index - PCdp.Platform.Name.Length - 4 , PCdp.Platform.Name.Length + 4 , true );

				mNodex.Nodes.Add( mNode1 );

				// Addresses Section ................
				mNode1 = new TreeNode();
				mNode1.Text = "Addresses";

				PCdp.Addresses.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type :" + Function.ReFormatString( PCdp.Addresses.Type , GetTypeList(PCdp.Addresses.Type) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.Addresses.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length :" + Function.ReFormatString( PCdp.Addresses.Length , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.Addresses.AddressCount = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Number of Addresses :" + Function.ReFormatString( PCdp.Addresses.AddressCount , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

				Function.SetPosition( ref mNode1 , Index - 8 , 8 + (int) PCdp.Addresses.AddressCount * 9 , true );

				if( PCdp.Addresses.AddressCount > 0 )
				{
					PCdp.Addresses.IpAddresses = new PACKET_CDP_ADDRESS[PCdp.Addresses.AddressCount];
					for( i = 0; i < PCdp.Addresses.AddressCount; i ++ )
					{
						mNode2 = new TreeNode();
						Function.SetPosition( ref mNode2 , Index , 9 , true );

						PCdp.Addresses.IpAddresses[i].ProtocolType = PacketData[ Index++ ];
						Tmp = "Protocol Type :" + Function.ReFormatString( PCdp.Addresses.IpAddresses[i].ProtocolType , GetProtocolTypeList(PCdp.Addresses.IpAddresses[i].ProtocolType) );
						mNode2.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode2 , Index - 1 , 1 , false );

						if( PCdp.Addresses.IpAddresses[i].ProtocolType == 1 ) PCdp.Addresses.IpAddresses[i].ProtocolTypeStr = "NLPID";

						PCdp.Addresses.IpAddresses[i].ProtocolLength = PacketData[ Index++ ];
						Tmp = "Protocol Length :" + Function.ReFormatString( PCdp.Addresses.IpAddresses[i].ProtocolLength , null );
						mNode2.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode2 , Index - 1 , 1 , false );

						PCdp.Addresses.IpAddresses[i].Protocol = PacketData[ Index++ ];
						if( PCdp.Addresses.IpAddresses[i].ProtocolType == Const.PROTO_TYPE_NLPID )
							Tmp = "Protocol :" + Function.ReFormatString( PCdp.Addresses.IpAddresses[i].Protocol , GetProtocolSubTypeList( PCdp.Addresses.IpAddresses[i].Protocol ) );
						else
							Tmp = "Protocol :" + Function.ReFormatString( PCdp.Addresses.IpAddresses[i].Protocol , PCdp.Addresses.IpAddresses[i].ProtocolStr );
						mNode2.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode2 , Index - 1 , 1 , false );

						if( PCdp.Addresses.IpAddresses[i].Protocol == 0xcc ) PCdp.Addresses.IpAddresses[i].ProtocolStr = "IP";

						PCdp.Addresses.IpAddresses[i].AddressLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Address Length :" + Function.ReFormatString( PCdp.Addresses.IpAddresses[i].AddressLength , null );
						mNode2.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );

						PCdp.Addresses.IpAddresses[i].IpAddress = Function.GetIpAddress( PacketData , ref Index , (int) PCdp.Addresses.IpAddresses[i].AddressLength );
						Tmp = "IP Address :" + PCdp.Addresses.IpAddresses[i].IpAddress;
						mNode2.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode2 , Index - 4 , 4 , false );

						mNode2.Text = PCdp.Addresses.IpAddresses[i].IpAddress;
						mNode1.Nodes.Add( mNode2 );

					}

				}

				mNodex.Nodes.Add( mNode1 );

				// Port Id Section ................
				mNode1 = new TreeNode();
				mNode1.Text = "Port Id";

				PCdp.PortId.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type :" + Function.ReFormatString( PCdp.PortId.Type , GetTypeList(PCdp.PortId.Type) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.PortId.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length :" + Function.ReFormatString( PCdp.PortId.Length , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.PortId.Name = "";
				for( i = 0; i < PCdp.PortId.Length - 4; i ++ )
					PCdp.PortId.Name += (char) PacketData[ Index++ ];

				Tmp = "Name : " + PCdp.PortId.Name;
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - PCdp.PortId.Name.Length , PCdp.PortId.Name.Length , false );

				Function.SetPosition( ref mNode1 , Index - PCdp.PortId.Name.Length - 4 , PCdp.PortId.Name.Length + 4 , true );

				mNodex.Nodes.Add( mNode1 );

				// Capabilities Section ................
				mNode1 = new TreeNode();
				mNode1.Text = "Capabilities";

				PCdp.CapabilitiesType = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type :" + Function.ReFormatString( PCdp.CapabilitiesType , GetTypeList(PCdp.CapabilitiesType) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.CapabilitiesLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length :" + Function.ReFormatString( PCdp.CapabilitiesLength , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.CapabilitiesFlag = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				mNode2 = new TreeNode();
				mNode2.Text = "Flags : " + Function.ReFormatString( PCdp.CapabilitiesFlag , null );
				Function.SetPosition( ref mNode2 , Index - 4 , 4 , true );

				mNode2.Nodes.Add( Function.DecodeBitField( PCdp.CapabilitiesFlag , 0x00000001 , "Performs level 3 routing" , "Doesn't perform level 3 routing" ) );
				Function.SetPosition( ref mNode2 , Index - 4 , 4 , false );
				mNode2.Nodes.Add( Function.DecodeBitField( PCdp.CapabilitiesFlag , 0x00000002 , "Performs level 2 transparent routing" , "Doesn't perform level 2 transparent routing" ) );
				Function.SetPosition( ref mNode2 , Index - 4 , 4 , false );
				mNode2.Nodes.Add( Function.DecodeBitField( PCdp.CapabilitiesFlag , 0x00000004 , "Performs level 2 source-route bridging" , "Doesn't perform Level 2 source-route bridging" ) );
				Function.SetPosition( ref mNode2 , Index - 4 , 4 , false );
				mNode2.Nodes.Add( Function.DecodeBitField( PCdp.CapabilitiesFlag , 0x00000008 , "Performs level 2 switching" , "Doesn't perform level 2 switching" ) );
				Function.SetPosition( ref mNode2 , Index - 4 , 4 , false );
				mNode2.Nodes.Add( Function.DecodeBitField( PCdp.CapabilitiesFlag , 0x00000010 , "Sends or receives packets for network layer protocols" , "Doesn't send or receive packets for network layer protocols" ) );
				Function.SetPosition( ref mNode2 , Index - 4 , 4 , false );
				mNode2.Nodes.Add( Function.DecodeBitField( PCdp.CapabilitiesFlag , 0x00000020 , "Doesn't forward IGMP report packets on nonrouter ports" , "Forwards IGMP report packets on nonrouter ports" ) );
				Function.SetPosition( ref mNode2 , Index - 4 , 4 , false );
				mNode2.Nodes.Add( Function.DecodeBitField( PCdp.CapabilitiesFlag , 0x00000040 , "Performs level 1 functionality" , "Doesn't perform level 1 functionality" ) );
				Function.SetPosition( ref mNode2 , Index - 4 , 4 , false );

				mNode1.Nodes.Add( mNode2 );

				Function.SetPosition( ref mNode1 , Index - 8 , 8 , true );

				mNodex.Nodes.Add( mNode1 );

				// VTP Section ................
				mNode1 = new TreeNode();
				mNode1.Text = "VTP";

				PCdp.VTP.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type :" + Function.ReFormatString( PCdp.VTP.Type , GetTypeList(PCdp.VTP.Type) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.VTP.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length :" + Function.ReFormatString( PCdp.VTP.Length , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.VTP.Name = "";
				if( PCdp.VTP.Length > 4 )
				{
					for( i = 0; i < PCdp.VTP.Length - 4; i ++ )
						PCdp.VTP.Name += (char) PacketData[ Index++ ];
				}
				else PCdp.VTP.Name = "Null";

				Tmp = "VTP Management Domain : " + PCdp.VTP.Name;
				mNode1.Nodes.Add( Tmp );
				if( PCdp.VTP.Length > 4 )
					Function.SetPosition( ref mNode1 , Index - PCdp.VTP.Name.Length , PCdp.VTP.Name.Length , false );

				Function.SetPosition( ref mNode1 , Index - PCdp.VTP.Name.Length - 4 , PCdp.VTP.Name.Length + 4, true );

				mNodex.Nodes.Add( mNode1 );

				// Duplex Section ................
				mNode1 = new TreeNode();
				mNode1.Text = "Duplex";

				PCdp.Duplex.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type :" + Function.ReFormatString( PCdp.Duplex.Type , GetTypeList(PCdp.Duplex.Type) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.Duplex.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length :" + Function.ReFormatString( PCdp.Duplex.Length , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PCdp.Duplex.Name = "Null";
				if( PacketData[ Index++ ] == 1 ) PCdp.Duplex.Name = "Full";

				Tmp = "Name : " + PCdp.Duplex.Name;
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - PCdp.Duplex.Length + 4 , PCdp.Duplex.Length + 4 , false );

				Function.SetPosition( ref mNode1 , Index - PCdp.Duplex.Length , PCdp.Duplex.Length , true );

				mNodex.Nodes.Add( mNode1 );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "CDP/VTP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Cisco Discovery Protocol";

				Function.SetPosition( ref mNodex , kk , Index - kk , true );

				mNode.Add( mNodex );

			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed CDP packet. Remaining bytes don't fit an CDP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;
		}

		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			string Tmp = "";
			int i = 0;
			PACKET_CDP PCdp;


			try
			{
				PCdp.Version = PacketData[ Index++ ];
				PCdp.TTL = PacketData[ Index++ ];
				PCdp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				// Device Id Section ................
				PCdp.DeviceId.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.DeviceId.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.DeviceId.Name = "";
				for( i = 0; i < PCdp.DeviceId.Length - 4; i ++ )
					PCdp.DeviceId.Name += (char) PacketData[ Index++ ];

				// Software Version Section ................
				PCdp.SoftwareVersion.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.SoftwareVersion.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.SoftwareVersion.Name = "";
				for( i = 0; i < PCdp.SoftwareVersion.Length - 4; i ++ )
					PCdp.SoftwareVersion.Name += (char) PacketData[ Index++ ];

				// Platform Section ................
				PCdp.Platform.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.Platform.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.Platform.Name = "";
				for( i = 0; i < PCdp.Platform.Length - 4; i ++ )
					PCdp.Platform.Name += (char) PacketData[ Index++ ];

				// Addresses Section ................
				PCdp.Addresses.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.Addresses.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.Addresses.AddressCount = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );

				if( PCdp.Addresses.AddressCount > 0 )
				{
					PCdp.Addresses.IpAddresses = new PACKET_CDP_ADDRESS[PCdp.Addresses.AddressCount];
					for( i = 0; i < PCdp.Addresses.AddressCount; i ++ )
					{
						PCdp.Addresses.IpAddresses[i].ProtocolType = PacketData[ Index++ ];
						if( PCdp.Addresses.IpAddresses[i].ProtocolType == 1 ) PCdp.Addresses.IpAddresses[i].ProtocolTypeStr = "NLPID";
						PCdp.Addresses.IpAddresses[i].ProtocolLength = PacketData[ Index++ ];
						PCdp.Addresses.IpAddresses[i].Protocol = PacketData[ Index++ ];
						if( PCdp.Addresses.IpAddresses[i].Protocol == 0xcc ) PCdp.Addresses.IpAddresses[i].ProtocolStr = "IP";

						PCdp.Addresses.IpAddresses[i].AddressLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						PCdp.Addresses.IpAddresses[i].IpAddress = Function.GetIpAddress( PacketData , ref Index , (int) PCdp.Addresses.IpAddresses[i].AddressLength );
					}

				}

				// Port Id Section ................
				PCdp.PortId.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.PortId.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				PCdp.PortId.Name = "";
				for( i = 0; i < PCdp.PortId.Length - 4; i ++ )
					PCdp.PortId.Name += (char) PacketData[ Index++ ];

				// Capabilities Section ................
				PCdp.CapabilitiesType = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.CapabilitiesLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.CapabilitiesFlag = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				// VTP Section ................
				PCdp.VTP.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.VTP.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.VTP.Name = "";
				for( i = 0; i < PCdp.VTP.Length - 4; i ++ )
					PCdp.VTP.Name += (char) PacketData[ Index++ ];

				// Duplex Section ................
				PCdp.Duplex.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.Duplex.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PCdp.Duplex.Name = "Null";
				if( PacketData[ Index++ ] == 1 ) PCdp.Duplex.Name = "Full";

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "CDP/VTP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Cisco Discovery Protocol";

			}
			catch
			{
				Tmp = "[ Malformed CDP packet. Remaining bytes don't fit an CDP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;
		}


	}
}
