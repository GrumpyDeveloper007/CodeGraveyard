using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketICMP
	{

		public struct PACKET_ICMP
		{
			public byte Type;
			public byte Code;
			public ushort Checksum;
			public ushort Identifier;
			public ushort SequenceNumber;
			public byte [] Data;
		}


		public PacketICMP()
		{
		}

		public static string GetTypeCodeString( byte b )
		{
			string [] IcmpTypeCodes = new string[32];

			int i = 0;

			for( i = 0; i < 32; i ++ )
				IcmpTypeCodes[ i ] = "Not defined";

			IcmpTypeCodes[ 0 ] = "Echo Reply";
			IcmpTypeCodes[ 3 ] = "Destination Unreachable";
			IcmpTypeCodes[ 4 ] = "Source Quench";
			IcmpTypeCodes[ 5 ] = "Redirect";
			IcmpTypeCodes[ 8 ] = "Echo";
			IcmpTypeCodes[ 9 ] = "Router Advertisement";
			IcmpTypeCodes[ 10 ] = "Router Selection";
			IcmpTypeCodes[ 11 ] = "Time Exceeded";
			IcmpTypeCodes[ 12 ] = "Parameter Problem";
			IcmpTypeCodes[ 13 ] = "Timestamp";
			IcmpTypeCodes[ 14 ] = "Timestamp Reply";
			IcmpTypeCodes[ 15 ] = "Information Request";
			IcmpTypeCodes[ 16 ] = "Information Reply";
			IcmpTypeCodes[ 17 ] = "Address Mask Request";
			IcmpTypeCodes[ 18 ] = "Address Mask Reply";
			IcmpTypeCodes[ 30 ] = "Traceroute";
			IcmpTypeCodes[ 31 ] = "Datagram Conversion Error";

			if( b > 31 ) return "Not defined";

			return IcmpTypeCodes[ b ];
			
		}



		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			int i = 0, Size = 0;
			PACKET_ICMP PIcmp;

			mNodex = new TreeNode();
			mNodex.Text = "ICMP ( Internet Control Message Protocol )";
			Function.SetPosition( ref mNodex , Index , PacketData.Length - Index , true );
	
			if( ( Index + Const.LENGTH_OF_ICMP ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed ICMP packet. Remaining bytes don't fit an ICMP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{

				PIcmp.Type = PacketData[ Index++ ];
				Tmp = "Type : " + Function.ReFormatString( PIcmp.Type , GetTypeCodeString( PIcmp.Type ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PIcmp.Code = PacketData[ Index++ ];
				Tmp = "Code : " + Function.ReFormatString( PIcmp.Code , GetTypeCodeString( PIcmp.Code ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PIcmp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Checksum : " + Function.ReFormatString( PIcmp.Checksum , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PIcmp.Identifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Identifier : " + Function.ReFormatString( PIcmp.Identifier , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PIcmp.SequenceNumber = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Sequence Number : " + Function.ReFormatString( PIcmp.SequenceNumber , null ) ;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				Size = PacketData.GetLength(0) - Index;
				PIcmp.Data = new byte[Size];

				for( i = 0; i < Size; i ++ )
					PIcmp.Data[i] = PacketData[ Index++ ];

				Tmp = "Data : ";
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index , Size , false );
				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "ICMP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = GetTypeCodeString( PIcmp.Type );

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed ICMP packet. Remaining bytes don't fit an ICMP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed ICMP packet. Remaining bytes don't fit an ICMP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			string Tmp = "";
			int i = 0, Size = 0;
			PACKET_ICMP PIcmp;

			if( ( Index + Const.LENGTH_OF_ICMP ) > PacketData.Length )
			{
				Tmp = "[ Malformed ICMP packet. Remaining bytes don't fit an ICMP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{

				PIcmp.Type = PacketData[ Index++ ];
				PIcmp.Code = PacketData[ Index++ ];
				PIcmp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PIcmp.Identifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PIcmp.SequenceNumber = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Size = PacketData.GetLength(0) - Index;
				PIcmp.Data = new byte[Size];

				for( i = 0; i < Size; i ++ )
					PIcmp.Data[i] = PacketData[ Index++ ];

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "ICMP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = GetTypeCodeString( PIcmp.Type );

			}
			catch
			{
				Tmp = "[ Malformed ICMP packet. Remaining bytes don't fit an ICMP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed ICMP packet. Remaining bytes don't fit an ICMP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
