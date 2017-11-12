using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketTCP
	{

		public struct PACKET_TCP
		{
			public ushort SourcePort;
			public ushort DestinationPort;
			public uint SequenceNumber;
			public uint Acknowledgement;
			public byte HeaderLength;
			public byte Falgs;
			public ushort WindowSize;
			public ushort Checksum;
			public ushort Options;
		}


		public PacketTCP()
		{
		}

		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , ref uint PreviousHttpSequence )
		{
			TreeNode mNodex;
			TreeNode mNode1;
			string Tmp = "";
			PACKET_TCP PTcp;

			mNodex = new TreeNode();
			mNodex.Text = "TCP ( Transmission Control Protocol )";
			Function.SetPosition( ref mNodex , Index , Const.LENGTH_OF_TCP , true );
	
			if( ( Index + Const.LENGTH_OF_TCP ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed TCP packet. Remaining bytes don't fit an TCP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PTcp.SourcePort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Source Port : " + Function.ReFormatString( PTcp.SourcePort , Const.GetPortStr( PTcp.SourcePort ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PTcp.DestinationPort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Destination Port : " + Function.ReFormatString( PTcp.DestinationPort , Const.GetPortStr( PTcp.DestinationPort ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PTcp.SequenceNumber = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Sequence Number : " + Function.ReFormatString( PTcp.SequenceNumber , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PTcp.Acknowledgement = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Acknowledgement : " + Function.ReFormatString( PTcp.Acknowledgement , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PTcp.HeaderLength = PacketData[ Index++ ];
				PTcp.HeaderLength = (byte) ( ( (int) PTcp.HeaderLength >> 4 ) * 4 );
				Tmp = "Length : " + Function.ReFormatString( PTcp.HeaderLength , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PTcp.Falgs = PacketData[ Index++ ];
				mNode1 = new TreeNode();
				mNode1.Text = "Flags : " + Function.ReFormatString( PTcp.Falgs , null );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , true );
				mNode1.Nodes.Add( Function.DecodeBitField( PTcp.Falgs , 0x80 , "Congestion window reduced ( CWR ) : Set" , "Congestion window reduced ( CWR ) : Not set" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PTcp.Falgs , 0x40 , "ECN-Echo : Set" , "ECN-Echo : Not set" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PTcp.Falgs , 0x20 , "Urgent : Set" , "Urgent : Not set" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PTcp.Falgs , 0x10 , "Acknowldegement : Set" , "Acknowldegement : Not set" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PTcp.Falgs , 0x08 , "Push : Set" , "Push : Not set" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PTcp.Falgs , 0x04 , "Reset : Set" , "Reset : Not set" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PTcp.Falgs , 0x02 , "Sync : Set" , "Sync : Not set" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PTcp.Falgs , 0x01 , "Fin : Set" , "Fin : Not set" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNodex.Nodes.Add( mNode1 );

				PTcp.WindowSize = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Window Size : " + Function.ReFormatString( PTcp.WindowSize , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PTcp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Checksum : " + Function.ReFormatString( PTcp.Checksum , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PTcp.Options = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Options : " + Function.ReFormatString( PTcp.Options , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "TCP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Source Port = " + PTcp.SourcePort.ToString() + " ( " + Const.GetPortStr( PTcp.SourcePort ) + " ) , Destination Port = " + PTcp.DestinationPort.ToString() + " ( " + Const.GetPortStr( PTcp.DestinationPort ) + " )";

				mNode.Add( mNodex );

				bool IsCifs = false;

				if( ( PTcp.SourcePort == Const.IPPORT_HTTP ) ||
					( PTcp.DestinationPort == Const.IPPORT_HTTP ) ||
					( PTcp.SourcePort == Const.IPPORT_HTTP2 ) ||
					( PTcp.DestinationPort == Const.IPPORT_HTTP2 ) )
				{
					if( PreviousHttpSequence == ( PTcp.SequenceNumber - ( PacketData.Length - 54 ) ) )
					{
						PreviousHttpSequence = PTcp.SequenceNumber;
						PacketHTTP.Parser( ref mNode , PacketData , ref Index , ref LItem , false );
					}
					else
					{
						PreviousHttpSequence = 0;
						PacketHTTP.Parser( ref mNode , PacketData , ref Index , ref LItem , true );
					}

				}
				else if( ( PTcp.SourcePort == Const.IPPORT_NBSSN ) ||
					( PTcp.DestinationPort == Const.IPPORT_NBSSN ) )
				{
					if( ( PTcp.SourcePort == Const.TCP_PORT_CIFS ) || ( PTcp.DestinationPort == Const.TCP_PORT_CIFS ) )
						IsCifs = true;
					else
						IsCifs = false;

					PacketNBSS.Parser( ref mNode , PacketData , ref Index , ref LItem , IsCifs );
				}


			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed TCP packet. Remaining bytes don't fit an TCP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed TCP packet. Remaining bytes don't fit an TCP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , ref uint PreviousHttpSequence )
		{
			string Tmp = "";
			PACKET_TCP PTcp;

			if( ( Index + Const.LENGTH_OF_TCP ) > PacketData.Length )
			{
				Tmp = "[ Malformed TCP packet. Remaining bytes don't fit an TCP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PTcp.SourcePort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PTcp.DestinationPort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PTcp.SequenceNumber = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				PTcp.Acknowledgement = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				PTcp.HeaderLength = PacketData[ Index++ ];
				PTcp.HeaderLength = (byte) ( ( (int) PTcp.HeaderLength >> 4 ) * 4 );
				PTcp.Falgs = PacketData[ Index++ ];
				PTcp.WindowSize = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PTcp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PTcp.Options = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "TCP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Source Port = " + PTcp.SourcePort.ToString() + " ( " + Const.GetPortStr( PTcp.SourcePort ) + " ) , Destination Port = " + PTcp.DestinationPort.ToString() + " ( " + Const.GetPortStr( PTcp.DestinationPort ) + " )";

				bool IsCifs = false;

				if( ( PTcp.SourcePort == Const.IPPORT_HTTP ) ||
					( PTcp.DestinationPort == Const.IPPORT_HTTP ) ||
					( PTcp.SourcePort == Const.IPPORT_HTTP2 ) ||
					( PTcp.DestinationPort == Const.IPPORT_HTTP2 ) )
				{
					if( PreviousHttpSequence == ( PTcp.SequenceNumber - ( PacketData.Length - 54 ) ) )
					{
						PreviousHttpSequence = PTcp.SequenceNumber;
						PacketHTTP.Parser( PacketData , ref Index , ref LItem , false );
					}
					else
					{
						PreviousHttpSequence = 0;
						PacketHTTP.Parser( PacketData , ref Index , ref LItem , true );
					}
				}
				else if( ( PTcp.SourcePort == Const.IPPORT_NBSSN ) ||
					( PTcp.DestinationPort == Const.IPPORT_NBSSN ) )
				{
					if( ( PTcp.SourcePort == Const.TCP_PORT_CIFS ) || ( PTcp.DestinationPort == Const.TCP_PORT_CIFS ) )
						IsCifs = true;
					else
						IsCifs = false;

					PacketNBSS.Parser( PacketData , ref Index , ref LItem , IsCifs );
				}


			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed TCP packet. Remaining bytes don't fit an TCP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
