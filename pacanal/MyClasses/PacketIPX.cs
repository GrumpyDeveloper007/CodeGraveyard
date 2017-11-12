using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketIPX
	{

		public struct PACKET_IPX
		{
			public ushort  Checksum; // if 0xffff, it is not used
			public ushort  PacketLength;
			public byte    TransparentControl;
			public byte    PacketType;
			public string  DestinationNetwork;
			public string  DestinationNode; // 6 bytes
			public ushort  DestinationSocket;
			public string  SourceNetwork;
			public string  SourceNode; // 6 bytes
			public ushort  SourceSocket;
			public byte [] Data;
		}


		public PacketIPX()
		{

		}

		public static string GetSocketString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case Const.SOCKET_TYPE_SAP	:	Tmp = "SAP"; break;
			}

			return Tmp;
		}

		public static string GetPacketTypeString( byte b )
		{
			string Tmp = "";

			switch( b )
			{
				case Const.PACKET_TYPE_NCP	:	Tmp = "NetWare Core Protocol ( NCP )"; break;
				case Const.PACKET_TYPE_SPX	:	Tmp = "Packet Exchange Protocol ( SPX )"; break;
			}

			return Tmp;
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			int i = 0;
			PACKET_IPX PIpx;

			mNodex = new TreeNode();
			mNodex.Text = "IPX ( Internet Packet Exchange Protocol )";
			Function.SetPosition( ref mNodex , Index , PacketData.Length - Index - 1 , true );
	
			if( ( Index + Const.LENGTH_OF_IPX ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed IPX packet. Remaining bytes don't fit an IPX packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PIpx.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Checksum : " + Function.ReFormatString( PIpx.Checksum , PIpx.Checksum == 0xffff ? "Checksum is not used" : null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PIpx.PacketLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Packet Length :" + Function.ReFormatString( PIpx.PacketLength , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PIpx.TransparentControl = PacketData [ Index ++ ];
				Tmp = "Transparent Control :" + Function.ReFormatString( PIpx.TransparentControl , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PIpx.PacketType = PacketData [ Index ++ ];
				Tmp = "Packet Type :" + Function.ReFormatString( PIpx.PacketType , GetPacketTypeString( PIpx.PacketType ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PIpx.DestinationNetwork = Function.GetIpAddress( PacketData , ref Index );
				Tmp = "Destination Network : " + PIpx.DestinationNetwork;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PIpx.DestinationNode = Function.GetMACAddress( PacketData , ref Index );
				Tmp = "Destination Node : " + PIpx.DestinationNode;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 6 , 6 , false );

				PIpx.DestinationSocket = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Destination Socket :" + Function.ReFormatString( PIpx.DestinationSocket , GetSocketString( PIpx.DestinationSocket ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PIpx.SourceNetwork = Function.GetIpAddress( PacketData , ref Index );
				Tmp = "Source Network : " + PIpx.SourceNetwork;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PIpx.SourceNode = Function.GetMACAddress( PacketData , ref Index );
				Tmp = "Source Node : " + PIpx.SourceNode;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 6 , 6 , false );

				PIpx.SourceSocket = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Source Socket :" + Function.ReFormatString( PIpx.SourceSocket , GetSocketString( PIpx.SourceSocket ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				int MoreData = PacketData.GetLength( 0 ) - Index - 1;

				if( MoreData > 0 )
				{
					PIpx.Data = new byte[ MoreData ];
					for( i = 0; i < MoreData; i ++ )
						PIpx.Data[ i ] = PacketData[ Index ++ ];
					Tmp = "IPX Data :";
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - MoreData , MoreData , false );
				}
				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "IPX";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PIpx.SourceNetwork;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PIpx.DestinationNetwork;
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Ipx protocol";

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed IPX packet. Remaining bytes don't fit an IPX packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed IPX packet. Remaining bytes don't fit an IPX packet. Possibly due to bad decoding ]";

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
			PACKET_IPX PIpx;

			if( ( Index + Const.LENGTH_OF_IPX ) > PacketData.Length )
			{
				Tmp = "[ Malformed IPX packet. Remaining bytes don't fit an IPX packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PIpx.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PIpx.PacketLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PIpx.TransparentControl = PacketData [ Index ++ ];
				PIpx.PacketType = PacketData [ Index ++ ];
				PIpx.DestinationNetwork = Function.GetIpAddress( PacketData , ref Index );
				PIpx.DestinationNode = Function.GetMACAddress( PacketData , ref Index );
				PIpx.DestinationSocket = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PIpx.SourceNetwork = Function.GetIpAddress( PacketData , ref Index );
				PIpx.SourceNode = Function.GetMACAddress( PacketData , ref Index );
				PIpx.SourceSocket = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				int MoreData = PacketData.GetLength( 0 ) - Index - 1;

				if( MoreData > 0 )
				{
					PIpx.Data = new byte[ MoreData ];
					for( i = 0; i < MoreData; i ++ )
						PIpx.Data[ i ] = PacketData[ Index ++ ];
				}
				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "IPX";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PIpx.SourceNetwork;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PIpx.DestinationNetwork;
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Ipx protocol";

				
			}
			catch
			{
				Tmp = "[ Malformed IPX packet. Remaining bytes don't fit an IPX packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed IPX packet. Remaining bytes don't fit an IPX packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
