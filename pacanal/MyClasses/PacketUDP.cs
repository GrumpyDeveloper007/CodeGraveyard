using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketUDP
	{

		public struct PACKET_UDP
		{
			public ushort SourcePort;
			public ushort DestinationPort;
			public ushort Length;
			public ushort Checksum;
		}


		public PacketUDP()
		{
		}




		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , 
			ref ushort LastTftpPort )
		{
			TreeNode mNodex;
			string Tmp = "";
			PACKET_UDP PUdp;

			mNodex = new TreeNode();
			mNodex.Text = "UDP ( Unary Datagram Protocol )";
			Function.SetPosition( ref mNodex , Index , Const.LENGTH_OF_UDP , true );
	
			if( ( Index + Const.LENGTH_OF_UDP ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed UDP packet. Remaining bytes don't fit an UDP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PUdp.SourcePort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Source Port : " + Function.ReFormatString( PUdp.SourcePort , Const.GetPortStr( PUdp.SourcePort ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PUdp.DestinationPort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Destination Port : " + Function.ReFormatString( PUdp.DestinationPort , Const.GetPortStr( PUdp.DestinationPort ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PUdp.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Length : " + Function.ReFormatString( PUdp.Length , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PUdp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Checksum : " + Function.ReFormatString( PUdp.Checksum , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "UDP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Source Port = " + PUdp.SourcePort.ToString() + " ( " + Const.GetPortStr( PUdp.SourcePort ) + " ) , Destination Port = " + PUdp.DestinationPort.ToString() + " ( " + Const.GetPortStr( PUdp.DestinationPort ) + " )";

				mNode.Add( mNodex );

				if( ( PUdp.SourcePort == Const.IPPORT_SSDP ) || 
					( PUdp.DestinationPort == Const.IPPORT_SSDP ) ||
					( PUdp.SourcePort == Const.IPPORT_SSDP2 ) ||
					( PUdp.DestinationPort == Const.IPPORT_SSDP2 ) )
				{
					PacketHTTP.Parser( ref mNode , PacketData , ref Index , ref LItem , true );
				}
				else if( ( PUdp.SourcePort == Const.IPPORT_DOMAIN ) || 
					( PUdp.DestinationPort == Const.IPPORT_DOMAIN ) )
				{
					//PacketDNS.Parser( ref mNode , PacketData , ref Index , ref LItem );
				}
				else if( ( PUdp.SourcePort == Const.IPPORT_NBNS ) ||( PUdp.DestinationPort == Const.IPPORT_NBNS ) )
				{
					PacketNBNS.Parser( ref mNode , PacketData , ref Index , ref LItem );
				}
				else if( ( PUdp.SourcePort == Const.IPPORT_NBDTGRM ) ||( PUdp.DestinationPort == Const.IPPORT_NBDTGRM ) )
				{
					PacketNBDS.Parser( ref mNode , PacketData , ref Index , ref LItem );
				}
				else if( ( PUdp.SourcePort == Const.IPPORT_TFTP ) ||( PUdp.DestinationPort == Const.IPPORT_TFTP ) )
				{
					if( PUdp.SourcePort == Const.IPPORT_TFTP ) 
						LastTftpPort = PUdp.DestinationPort;
					else if( PUdp.DestinationPort == Const.IPPORT_TFTP ) 
						LastTftpPort = PUdp.SourcePort;

					PacketTFTP.Parser( ref mNode , PacketData , ref Index , ref LItem );
				}
				else if( ( PUdp.SourcePort == LastTftpPort ) ||( PUdp.DestinationPort == LastTftpPort ) )
				{
					PacketTFTP.Parser( ref mNode , PacketData , ref Index , ref LItem );
				}


			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed UDP packet. Remaining bytes don't fit an UDP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed UDP packet. Remaining bytes don't fit an UDP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , 
			ref ushort LastTftpPort )
		{
			string Tmp = "";
			PACKET_UDP PUdp;

			if( ( Index + Const.LENGTH_OF_UDP ) > PacketData.Length )
			{
				Tmp = "[ Malformed UDP packet. Remaining bytes don't fit an UDP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PUdp.SourcePort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PUdp.DestinationPort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PUdp.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PUdp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "UDP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Source Port = " + PUdp.SourcePort.ToString() + " ( " + Const.GetPortStr( PUdp.SourcePort ) + " ) , Destination Port = " + PUdp.DestinationPort.ToString() + " ( " + Const.GetPortStr( PUdp.DestinationPort ) + " )";

				if( ( PUdp.SourcePort == Const.IPPORT_SSDP ) || 
					( PUdp.DestinationPort == Const.IPPORT_SSDP ) ||
					( PUdp.SourcePort == Const.IPPORT_SSDP2 ) ||
					( PUdp.DestinationPort == Const.IPPORT_SSDP2 ) )
				{
					PacketHTTP.Parser( PacketData , ref Index , ref LItem , true );
				}
				else if( ( PUdp.SourcePort == Const.IPPORT_DOMAIN ) || 
					( PUdp.DestinationPort == Const.IPPORT_DOMAIN ) )
				{
					//PacketDNS.Parser( PacketData , ref Index , ref LItem );
				}
				else if( ( PUdp.SourcePort == Const.IPPORT_NBNS ) ||( PUdp.DestinationPort == Const.IPPORT_NBNS ) )
				{
					PacketNBNS.Parser( PacketData , ref Index , ref LItem );
				}
				else if( ( PUdp.SourcePort == Const.IPPORT_NBDTGRM ) ||( PUdp.DestinationPort == Const.IPPORT_NBDTGRM ) )
				{
					PacketNBDS.Parser( PacketData , ref Index , ref LItem );
				}
				else if( ( PUdp.SourcePort == Const.IPPORT_TFTP ) ||( PUdp.DestinationPort == Const.IPPORT_TFTP ) )
				{
					if( PUdp.SourcePort == Const.IPPORT_TFTP ) 
						LastTftpPort = PUdp.DestinationPort;
					else if( PUdp.DestinationPort == Const.IPPORT_TFTP ) 
						LastTftpPort = PUdp.SourcePort;

					PacketTFTP.Parser( PacketData , ref Index , ref LItem );
				}
				else if( ( PUdp.SourcePort == LastTftpPort ) ||( PUdp.DestinationPort == LastTftpPort ) )
				{
					PacketTFTP.Parser( PacketData , ref Index , ref LItem );
				}


			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed UDP packet. Remaining bytes don't fit an UDP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
