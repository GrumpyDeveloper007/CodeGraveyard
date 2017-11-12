using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketARP
	{

		public struct PACKET_ARP
		{
			public ushort HardwareType;
			public ushort ProtocolType;
			public byte HardwareSize;
			public byte ProtocolSize;
			public ushort OpCode;
			public string SenderMACAddress;
			public string SenderIpAddress;
			public string TargetMACAddress;
			public string TargetIpAddress;
		}


		public PacketARP()
		{
		}

		public static string GetOpCodeList( ushort u )
		{
			int i = 0;
			string [] OpCodeList = new string[16];

			for( i = 0; i < 16; i ++ )
				OpCodeList[i] = "";

			OpCodeList[Const.ARPOP_REQUEST] = "Request";
			OpCodeList[Const.ARPOP_REPLY] = "Reply";
			OpCodeList[Const.ARPOP_RREQUEST] = "Reverse request";
			OpCodeList[Const.ARPOP_RREPLY] = "Reverse reply";
			OpCodeList[Const.ARPOP_IREQUEST] = "Inverse request";
			OpCodeList[Const.ARPOP_IREPLY] = "Inverse reply";
		
			return OpCodeList[u];

		}

		public static string GetAtmOpCodeList( ushort u )
		{
			int i = 0;
			string [] AtmOpCodeList = new string[16];

			for( i = 0; i < 16; i ++ )
				AtmOpCodeList[i] = "";

			AtmOpCodeList[Const.ARPOP_REQUEST] = "Request";
			AtmOpCodeList[Const.ARPOP_REPLY] = "Reply";
			AtmOpCodeList[Const.ARPOP_IREQUEST] = "Inverse request";
			AtmOpCodeList[Const.ARPOP_IREPLY] = "Inverse reply";
			AtmOpCodeList[Const.ATMARPOP_NAK] = "Nak";

			return AtmOpCodeList[u];
		}

		public static string GetHardwareList( ushort u )
		{
			int i = 0;
			string [] HardwareList = new string[255];

			for( i = 0; i < 255; i ++ )
				HardwareList[i] = "";


			HardwareList[Const.ARPHRD_NETROM] = "NET/ROM pseudo";
			HardwareList[Const.ARPHRD_ETHER] = "Ethernet";
			HardwareList[Const.ARPHRD_EETHER] = "Experimental Ethernet";
			HardwareList[Const.ARPHRD_AX25] = "AX.25";
			HardwareList[Const.ARPHRD_PRONET] = "ProNET";
			HardwareList[Const.ARPHRD_CHAOS] = "Chaos";
			HardwareList[Const.ARPHRD_IEEE802] = "IEEE 802";
			HardwareList[Const.ARPHRD_ARCNET] = "ARCNET";
			HardwareList[Const.ARPHRD_HYPERCH] = "Hyperchannel";
			HardwareList[Const.ARPHRD_LANSTAR] = "Lanstar";
			HardwareList[Const.ARPHRD_AUTONET] = "Autonet Short Address";
			HardwareList[Const.ARPHRD_LOCALTLK] = "Localtalk";
			HardwareList[Const.ARPHRD_LOCALNET] = "LocalNet";
			HardwareList[Const.ARPHRD_ULTRALNK] = "Ultra link";
			HardwareList[Const.ARPHRD_SMDS] = "SMDS";
			HardwareList[Const.ARPHRD_DLCI] = "Frame Relay DLCI";
			HardwareList[Const.ARPHRD_ATM] = "ATM";
			HardwareList[Const.ARPHRD_HDLC] = "HDLC";
			HardwareList[Const.ARPHRD_FIBREC] = "Fibre Channel";
			HardwareList[Const.ARPHRD_ATM2225] = "ATM (RFC 2225)";
			HardwareList[Const.ARPHRD_SERIAL] = "Serial Line";
			HardwareList[Const.ARPHRD_ATM2] = "ATM";
			HardwareList[Const.ARPHRD_MS188220] = "MIL-STD-188-220";
			HardwareList[Const.ARPHRD_METRICOM] = "Metricom STRIP";
			HardwareList[Const.ARPHRD_IEEE1394] = "IEEE 1394.1995";
			HardwareList[Const.ARPHRD_MAPOS] = "MAPOS";
			HardwareList[Const.ARPHRD_TWINAX] = "Twinaxial";
			HardwareList[Const.ARPHRD_EUI_64] = "EUI-64";

			return HardwareList[u];

		}

		public static string GetInfoARP( PACKET_ARP PArp )
		{
			string Tmp = "";

			switch( PArp.OpCode ) 
			{
				case Const.ARPOP_REQUEST:
					Tmp = "Who has " + PArp.TargetIpAddress + " ?  Tell " + PArp.SenderIpAddress;
					break;
				case Const.ARPOP_REPLY:
					Tmp = PArp.SenderIpAddress + " is at " + PArp.SenderMACAddress;
					break;
				case Const.ARPOP_RREQUEST:
					Tmp = "Who has " + PArp.TargetIpAddress + " ?  Tell " + PArp.SenderIpAddress;
					break;
				case Const.ARPOP_IREQUEST:
					Tmp = "Who has " + PArp.TargetMACAddress + " ?  Tell " + PArp.TargetIpAddress;
					break;
				case Const.ARPOP_RREPLY:
					Tmp = PArp.TargetIpAddress + " is at " + PArp.TargetMACAddress;
					break;
				case Const.ARPOP_IREPLY:
					Tmp = PArp.SenderMACAddress + " is at " + PArp.SenderIpAddress;
					break;
				default:
					Tmp = "Unknown ARP opcode " +  PArp.OpCode.ToString("x04");
					break;
			}

			return Tmp;
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
							   byte [] PacketData , ref int Index,
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			PACKET_ARP PArp;

			mNodex = new TreeNode();
			mNodex.Text = "ARP ( Address Resolution Protocol )";
			Function.SetPosition( ref mNodex , Index , Const.LENGTH_OF_ARP , true );
	
			if( ( Index + Const.LENGTH_OF_ARP ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed ARP packet. Remaining bytes don't fit an ARP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PArp.HardwareType = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Hardware Type : " + Function.ReFormatString( PArp.HardwareType , GetHardwareList(PArp.HardwareType) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PArp.ProtocolType = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Protocol Type : " + Function.ReFormatString( PArp.ProtocolType , Const.GetETHERTYPEStr( PArp.ProtocolType ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PArp.HardwareSize = PacketData[ Index++ ];
				Tmp = "Hardware Size : " + Function.ReFormatString( PArp.HardwareSize , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PArp.ProtocolSize = PacketData[ Index++ ];
				Tmp = "Protocol Size : " + Function.ReFormatString( PArp.ProtocolSize , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PArp.OpCode = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Opcode : " + Function.ReFormatString( PArp.OpCode , GetOpCodeList(PArp.OpCode) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PArp.SenderMACAddress = Function.GetMACAddress( PacketData , ref Index );
				Tmp = "Sender MAC Address : " + PArp.SenderMACAddress;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 6 , 6 , false );

				PArp.SenderIpAddress = Function.GetIpAddress( PacketData , ref Index );
				Tmp = "Sender Ip Address : " + PArp.SenderIpAddress;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PArp.TargetMACAddress = Function.GetMACAddress( PacketData , ref Index );
				Tmp = "Target MAC Address : " + PArp.TargetMACAddress;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 6 , 6 , false );

				PArp.TargetIpAddress = Function.GetIpAddress( PacketData , ref Index );
				Tmp = "Target Ip Address : " + PArp.TargetIpAddress;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );
				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "ARP";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PArp.SenderIpAddress;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PArp.TargetIpAddress;
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = GetInfoARP( PArp );

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed ARP packet. Remaining bytes don't fit an ARP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;

		}

		public static bool Parser( byte [] PacketData , ref int Index,
			ref ListViewItem LItem )
		{
			string Tmp = "";
			PACKET_ARP PArp;

			if( ( Index + Const.LENGTH_OF_ARP ) > PacketData.Length )
			{
				Tmp = "[ Malformed ARP packet. Remaining bytes don't fit an ARP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PArp.HardwareType = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PArp.ProtocolType = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PArp.HardwareSize = PacketData[ Index++ ];
				PArp.ProtocolSize = PacketData[ Index++ ];
				PArp.OpCode = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PArp.SenderMACAddress = Function.GetMACAddress( PacketData , ref Index );
				PArp.SenderIpAddress = Function.GetIpAddress( PacketData , ref Index );
				PArp.TargetMACAddress = Function.GetMACAddress( PacketData , ref Index );
				PArp.TargetIpAddress = Function.GetIpAddress( PacketData , ref Index );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "ARP";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PArp.SenderIpAddress;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PArp.TargetIpAddress;
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = GetInfoARP( PArp );

			}
			catch
			{
				Tmp = "[ Malformed ARP packet. Remaining bytes don't fit an ARP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;

		}

	}
}
