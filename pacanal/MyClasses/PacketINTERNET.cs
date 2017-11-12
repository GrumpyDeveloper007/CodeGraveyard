using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketINTERNET
	{

		public struct PACKET_INTERNET
		{
			public byte Version;
			public byte HeaderLength;
			public byte DifferentiatedServicesField;
			public ushort Length;
			public ushort Identification;
			public byte Flags;
			public ushort FragmentOffset;
			public ushort TimeToLive;
			public byte Protocol;
			public ushort HeaderChecksum;
			public string Source;
			public string Destination;
		}


		public PacketINTERNET()
		{

		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , 
			ref uint PreviousHttpSequence , 
			ref ushort LastTftpPort )
		{
			TreeNode mNodex;
			TreeNode mNode1;
			string Tmp = "";
			PACKET_INTERNET PInternet;

			mNodex = new TreeNode();
			mNodex.Text = "INTERNET";
			Function.SetPosition( ref mNodex , Index , Const.LENGTH_OF_INTERNET , true );
	
			if( ( Index + Const.LENGTH_OF_INTERNET ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed INTERNET packet. Remaining bytes don't fit an INTERNET packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{

				PInternet.Version = PacketData[ Index++ ];
				PInternet.HeaderLength = (byte) ( ( (int) PInternet.Version & 0x0f ) * 4 );
				PInternet.Version = (byte) ( (int) PInternet.Version >> 4 );
				Tmp = "Version : " + Function.ReFormatString( PInternet.Version , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				Tmp = "Length : " + Function.ReFormatString( PInternet.HeaderLength , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PInternet.DifferentiatedServicesField = PacketData[ Index++ ];
				mNode1 = new TreeNode();
				mNode1.Text = "Differentiated Services Field : " + Function.ReFormatString( PInternet.DifferentiatedServicesField , null );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , true );
				mNode1.Nodes.Add( Function.DecodeBitField( PInternet.DifferentiatedServicesField , 0xfc , "Differentiated Services Codepoint ( Default : 0 )" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PInternet.DifferentiatedServicesField , 0x02 , "ECN Capable Transport ( ECT ) : Yes" , "ECN Capable Transport ( ECT ) : No" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PInternet.DifferentiatedServicesField , 0x01 , "ECN-CE : Yes" , "ECN-CE : No" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNodex.Nodes.Add( mNode1 );

				PInternet.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Total Length : " + Function.ReFormatString( PInternet.Length , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PInternet.Identification = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Identification : " + Function.ReFormatString( PInternet.Identification , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PInternet.FragmentOffset = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PInternet.Flags = (byte)( (int) PInternet.FragmentOffset >> 12 );
				mNode1 = new TreeNode();
				mNode1.Text = "Flags : " + Function.ReFormatString( PInternet.Flags , null );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , true );
				mNode1.Nodes.Add( Function.DecodeBitField( PInternet.Flags , 0x04 , "Dont fragment : Yes" , "Dont fragment : No" ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PInternet.Flags , 0x02 , "More fragments : Yes" , "More fragments : No" ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNodex.Nodes.Add( mNode1 );

				PInternet.FragmentOffset = (ushort) ( (int) PInternet.FragmentOffset & 0x0f );
				Tmp = "Fragment Offset : " + Function.ReFormatString( PInternet.FragmentOffset , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PInternet.TimeToLive = PacketData[ Index++ ];
				Tmp = "Time To Live : " + Function.ReFormatString( PInternet.TimeToLive , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PInternet.Protocol = PacketData[ Index++ ];
				Tmp = "Protocol : " + Function.ReFormatString( PInternet.Protocol , Const.GetProtocolStr( PInternet.Protocol ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PInternet.HeaderChecksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Header Checksum : " + Function.ReFormatString( PInternet.HeaderChecksum , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PInternet.Source = Function.GetIpAddress( PacketData , ref Index );
				Tmp = "Source : " + PInternet.Source;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PInternet.Destination = Function.GetIpAddress( PacketData , ref Index );
				Tmp = "Destination : " + PInternet.Destination;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );
				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "INTERNET";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PInternet.Source;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PInternet.Destination;
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Internet packet";

				mNode.Add( mNodex );

				if( PInternet.Protocol == Const.IPPROTO_TCP )
				{
					PacketTCP.Parser( ref mNode , PacketData , ref Index , ref LItem , ref PreviousHttpSequence );
				}
				else if( PInternet.Protocol == Const.IPPROTO_UDP )
				{
					PacketUDP.Parser( ref mNode , PacketData , ref Index , ref LItem , ref LastTftpPort);
				}
				else if( PInternet.Protocol == Const.IPPROTO_ICMP )
				{
					PacketICMP.Parser( ref mNode , PacketData , ref Index , ref LItem );
				}
				else if( PInternet.Protocol == Const.IPPROTO_EIGRP )
				{
					PacketEIGRP.Parser( ref mNode , PacketData , ref Index , ref LItem );
				}


			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed INTERNET packet. Remaining bytes don't fit an INTERNET packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed INTERNET packet. Remaining bytes don't fit an INTERNET packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , 
			ref string TypeInfo , 
			ref uint PreviousHttpSequence , 
			ref ushort LastTftpPort )
		{
			string Tmp = "";
			PACKET_INTERNET PInternet;

			if( ( Index + Const.LENGTH_OF_INTERNET ) > PacketData.Length )
			{
				Tmp = "[ Malformed INTERNET packet. Remaining bytes don't fit an INTERNET packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{

				PInternet.Version = PacketData[ Index++ ];
				PInternet.HeaderLength = (byte) ( ( (int) PInternet.Version & 0x0f ) * 4 );
				PInternet.Version = (byte) ( (int) PInternet.Version >> 4 );
				PInternet.DifferentiatedServicesField = PacketData[ Index++ ];
				PInternet.Length = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PInternet.Identification = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PInternet.FragmentOffset = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PInternet.Flags = (byte)( (int) PInternet.FragmentOffset >> 12 );
				PInternet.FragmentOffset = (ushort) ( (int) PInternet.FragmentOffset & 0x0f );
				PInternet.TimeToLive = PacketData[ Index++ ];
				PInternet.Protocol = PacketData[ Index++ ];
				PInternet.HeaderChecksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PInternet.Source = Function.GetIpAddress( PacketData , ref Index );
				PInternet.Destination = Function.GetIpAddress( PacketData , ref Index );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "INTERNET";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PInternet.Source;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PInternet.Destination;
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Internet packet";

				if( PInternet.Protocol == Const.IPPROTO_TCP )
				{
					TypeInfo = "TCP";
					PacketTCP.Parser( PacketData , ref Index , ref LItem , ref PreviousHttpSequence );
				}
				else if( PInternet.Protocol == Const.IPPROTO_UDP )
				{
					TypeInfo = "UDP";
					PacketUDP.Parser( PacketData , ref Index , ref LItem , ref LastTftpPort );
				}
				else if( PInternet.Protocol == Const.IPPROTO_ICMP )
				{
					TypeInfo = "ICMP";
					PacketICMP.Parser( PacketData , ref Index , ref LItem );
				}
				else if( PInternet.Protocol == Const.IPPROTO_EIGRP )
				{
					PacketEIGRP.Parser( PacketData , ref Index , ref LItem );
				}


			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed INTERNET packet. Remaining bytes don't fit an INTERNET packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

	}
}
