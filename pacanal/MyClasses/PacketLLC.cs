using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketLLC
	{

		public struct PACKET_LLC
		{
			public byte DSAP;
			public byte SSAP;
			public ushort ControlField;
			public uint OrganizationCode;
			public ushort ProtocolId;
		}

		public PacketLLC()
		{
		}

		public static string GetLLCControlTypeString( byte Type )
		{
			int TType = (int) Type;
			string Tmp = "";
			byte b1 = (byte) ( TType & 0xe0 ); // UI Part
			byte b2 = (byte) ( TType & 0x10 ); // P/F Part
			byte b3 = (byte) ( TType & 0x0c ); // Command Part
			byte b4 = (byte) ( TType & 0x03 ); // Command Part

			if( b4 != 0x03 ) return "";

			switch( b1 )
			{
				case 0	: Tmp = "UI- Unnumbered information"; break;
				case 1	: Tmp = "DISC- Disconnect"; break;
				case 2	: Tmp = "SABME- Set Asynchronous Balanced Mode Extended"; break;
				case 3	: Tmp = "XID- Exchange IDs"; break;
				case 4	: Tmp = "TEST- Test the link"; break;
				case 5	: Tmp = "UA- Unnumbered Acknowledgement"; break;
				case 6	: Tmp = "DM- Disconnect Mode"; break;
				case 7	: Tmp = "FRMR- Frame Reject"; break;
			}

			if( b2 == 0 ) Tmp += ", Poll";
			else if( b2 == 1 ) Tmp += ", Final";

			if( b3 == 1 ) Tmp += ", Command";
			else if( b3 == 2 ) Tmp += ", Response";
			else if( b3 == 3 ) Tmp += ", Data";

			return Tmp;
		}

		public static string GetLLCControlTypeString( ushort Type )
		{
			string Tmp = "";
			ushort b1;
			ushort b2;
			ushort b3;

			if( ( (int) Type & 0x0001 ) == 0x0001 ) // Supervisory frame
			{
				b1 = (ushort) ( (int) Type & 0xe000 ); // Received PDU Number
				b1 = (ushort) ( b1 >> 13 );
				b2 = (ushort) ( (int) Type & 0x1000 ); // P/F Poll / Final bit
				b2 = (ushort) ( b2 >> 12 );
				b3 = (ushort) ( (int) Type & 0x00c0 ); // Supervisory function bits
				b3 = (ushort) ( b3 >> 2 );

				Tmp = "Received Pdu Number : " + b1.ToString();
				if( b2 == 1 )
					Tmp += ", Final, ";
				else
					Tmp += ", Poll, ";

				if( b3 == 0 )
					Tmp += "Receiver is ready";
				else if( b3 == 1 )
					Tmp += "Receiver is not ready";
				else if( b3 == 2 )
					Tmp += "Rejected";

			}
			else // Information frame
			{
				b1 = (ushort)( (int) Type & 0xe000 ); // Received PDU Number
				b1 = (ushort) ( b1 >> 13 );
				b2 = (ushort)( (int) Type & 0x1000 ); // P/F Poll / Final bit
				b2 = (ushort) ( b2 >> 12 );
				b3 = (ushort)( (int) Type & 0x0e00 ); // Sent PDU Number
				b3 = (ushort) ( b3 >> 1 );

				Tmp = "Received Pdu Number : " + b1.ToString();
				if( b2 == 1 )
					Tmp += ", Final, ";
				else
					Tmp += ", Poll, ";

				Tmp += ", Sent Pdu Number : " + b3.ToString();

			}

			return Tmp;
		}


		public static string GetLLCTypeString( byte Type )
		{
			string Tmp = "";

			switch( Type )
			{
				case 0x00	: Tmp = "LSAP"; break;
				case 0x02	: Tmp = "LLC Sublayer Management Function ( Individual )"; break;
				case 0x03	: Tmp = "LLC Sublayer Management Function ( Group )"; break;
				case 0x04	: Tmp = "IBM Sna Path Control ( Individual )"; break;
				case 0x05	: Tmp = "IBM Sna Path Control ( Group )"; break;
				case 0x06	: Tmp = "ARPANET Internet Protocol ( IP )"; break;
				case 0x08	: Tmp = "SNA CSNA EPROWAY (IEC955 ) Network Management & Initialization"; break;
				case 0x18	: Tmp = "Texas Instruments"; break;
				case 0x42	: Tmp = "IEEE 802.1 Bridge Spannning Tree Protocol"; break;
				case 0x4E	: Tmp = "EIA RS-511 Manufacturing Message Service"; break;
				case 0x7E	: Tmp = "ISO 8208 (X.25 over IEEE 802.2 Type 2 LLC)"; break;
				case 0x80	: Tmp = "Xerox Network Systems (XNS)"; break;
				case 0x86	: Tmp = "Nestar"; break;
				case 0x8E	: Tmp = "PROWAY (IEC 955) Active Station List Maintenance"; break;
				case 0x98	: Tmp = "ARPANET Address Resolution Protocol (ARP)"; break;
				case 0xBC	: Tmp = "Banyan VINES"; break;
				case 0xAA	: Tmp = "SubNetwork Access Protocl (SNAP)"; break;
				case 0xE0	: Tmp = "Novell NetWare"; break;
				case 0xF0	: Tmp = "IBM NetBIOS"; break;
				case 0xF4	: Tmp = "IBM LAN Management ( Individual )"; break;
				case 0xF5	: Tmp = "IBM LAN Management ( Group )"; break;
				case 0xF8	: Tmp = "IBM Remote Program Load (RPL)"; break;
				case 0xFA	: Tmp = "Ungermann-Bass"; break;
				case 0xFE	: Tmp = "ISO Network Layer Protocol"; break;
				case 0xFF	: Tmp = "Global LSAP"; break;
			}

			return Tmp;
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem ,
			ref uint PreviousHttpSequence , 
			ref ushort LastTftpPort )

		{
			TreeNode mNodex;
			string Tmp = "";
			PACKET_LLC PLlc;
			bool UNFrame, IsSnap = false;
			int kk = 0;


			mNodex = new TreeNode();
			mNodex.Text = "LLC ( Logical Link Control Protocol )";
			kk = Index;
	
			try
			{
				PLlc.DSAP = PacketData[ Index++ ];
				Tmp = "DSAP : " + Function.ReFormatString( PLlc.DSAP , GetLLCTypeString( PLlc.DSAP ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PLlc.SSAP = PacketData[ Index++ ];
				Tmp = "SSAP : " + Function.ReFormatString( PLlc.SSAP , GetLLCTypeString( PLlc.SSAP ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				IsSnap = ( PLlc.DSAP == Const.LLC_TYPE_SNAP ) && ( PLlc.SSAP == Const.LLC_TYPE_SNAP ) ? true : false;

				PLlc.ControlField = (ushort) PacketData[ Index ++ ];
				UNFrame = true;

				if( ( PLlc.ControlField & Const.XDLC_U ) != Const.XDLC_U )
				{
					PLlc.ControlField *= 256;
					PLlc.ControlField += (ushort) PacketData[ Index ++ ];
					UNFrame = false;

				}

				Tmp = "Control Field : " + Function.ReFormatString( PLlc.ControlField , null );
				mNodex.Nodes.Add( Tmp );
				if( UNFrame )
				{
					Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
				}
				else
				{
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
				}

				PLlc.OrganizationCode = 0;

				if( IsSnap )
				{
					PLlc.OrganizationCode = Function.Get3Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Organization Code : " + Function.ReFormatString( PLlc.OrganizationCode , null );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 3 , 3 , false );

					PLlc.ProtocolId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Protocol Id : " + Function.ReFormatString( PLlc.ProtocolId , null );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
				}

				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "LLC";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Logical link control protocol";

				Function.SetPosition( ref mNodex , kk , Index - kk , true );
				mNode.Add( mNodex );

				if( IsSnap )
				{
					switch( PLlc.OrganizationCode ) 
					{

						case Const.OUI_ENCAP_ETHER:
						case Const.OUI_CISCO_90:
						case Const.OUI_APPLE_ATALK:
							//capture_ethertype(etype, pd, offset+8, len, ld);
							//PacketETHERNET.Parser( ref mNode , PacketData , ref LItem , ref PreviousHttpSequence , ref LastTftpPort );
							break;
						case Const.OUI_CISCO:
							PacketCDP.Parser( ref mNode , PacketData , ref Index , ref LItem );
							break;

						default: break;
					}
				}
				else 
				{
					// non-SNAP
					switch( PLlc.DSAP ) 
					{
						case Const.LLCSAP_IP:
							PacketINTERNET.Parser( ref mNode , PacketData , ref Index , ref LItem , ref PreviousHttpSequence , ref LastTftpPort );
							break;

						case Const.LLC_TYPE_NOVELL_NETWARE:
							PacketIPX.Parser( ref mNode , PacketData , ref Index , ref LItem );
							break;

						case Const.LLC_TYPE_IBM_NETBIOS:
							PacketNETBIOS.Parser( ref mNode , PacketData , ref Index , ref LItem );
							break;

						case Const.LLC_TYPE_STP :
							PacketSTP.Parser( ref mNode , PacketData , ref Index , ref LItem );
							break;

						default:
							break;
					}

				}


			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed LLC packet. Remaining bytes don't fit an LLC packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed LLC packet. Remaining bytes don't fit an LLC packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , ref string TypeInfo ,
			ref uint PreviousHttpSequence , 
			ref ushort LastTftpPort )
		{
			PACKET_LLC PLlc;
			bool IsSnap = false;

			try
			{
				PLlc.DSAP = PacketData[ Index++ ];
				PLlc.SSAP = PacketData[ Index++ ];
				IsSnap = ( PLlc.DSAP == Const.LLC_TYPE_SNAP ) && ( PLlc.SSAP == Const.LLC_TYPE_SNAP ) ? true : false;

				PLlc.ControlField = (ushort) PacketData[ Index ++ ];

				if( ( PLlc.ControlField & 0xfc ) != Const.XDLC_U )
				{
					PLlc.ControlField *= 256;
					PLlc.ControlField += (ushort) PacketData[ Index ++ ];
				}

				if( IsSnap )
				{
					PLlc.OrganizationCode = Function.Get3Bytes( PacketData , ref Index , Const.NORMAL );
					PLlc.ProtocolId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "LLC";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Logical link control protocol";

				PLlc.OrganizationCode = 0;

				if( IsSnap )
				{
					switch( PLlc.OrganizationCode ) 
					{

						case Const.OUI_ENCAP_ETHER:
						case Const.OUI_CISCO_90:
						case Const.OUI_APPLE_ATALK:
							//capture_ethertype(etype, pd, offset+8, len, ld);
							//PacketETHERNET.Parser( PacketData , ref Index , ref LItem , ref PreviousHttpSequence , ref LastTftpPort );
							break;
						case Const.OUI_CISCO:
							PacketCDP.Parser( PacketData , ref Index , ref LItem );
							break;

						default: break;
					}
				}
				else 
				{
					// non-SNAP
					switch( PLlc.DSAP ) 
					{
						case Const.LLCSAP_IP:
							PacketINTERNET.Parser( PacketData , ref Index , ref LItem , ref TypeInfo , ref PreviousHttpSequence , ref LastTftpPort);
							break;

						case Const.LLC_TYPE_NOVELL_NETWARE:
							TypeInfo = "IPX";
							PacketIPX.Parser( PacketData , ref Index , ref LItem );
							break;

						case Const.LLC_TYPE_IBM_NETBIOS:
							TypeInfo = "NetBIOS";
							PacketNETBIOS.Parser( PacketData , ref Index , ref LItem );
							break;

						case Const.LLC_TYPE_STP :
							PacketSTP.Parser( PacketData , ref Index , ref LItem );
							break;

						default:
							break;
					}

				}


			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed LLC packet. Remaining bytes don't fit an LLC packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

	}
}
