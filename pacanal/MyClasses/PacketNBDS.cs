using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketNBDS
	{

		public struct PACKET_NBDS
		{
			public byte   MessageType;
			public byte   Flags;
			public ushort DatagramId;
			public string SourceIp;
			public ushort SourcePort;
			public ushort DataLength;
			public ushort ErrorCode;
			public ushort PacketOffset;
			public string SourceName;
			public string DestinationName;
		}



		public PacketNBDS()
		{
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			int kk = 0;
			byte NNumber = 0;
			PACKET_NBDS PNbds;
			string [] MessageTypeList = new string[24];
			string [] YesNoList = new string[2];
			string [] NodeTypeList = new string[4];
			string [] ErrorCodeList = new string[3];
			int i = 0;

			for( i = 0; i < 17; i ++ )
				MessageTypeList[i] = "Unknown";


			MessageTypeList[Const.NBDS_DIRECT_UNIQUE] = "Direct_unique datagram";
			MessageTypeList[Const.NBDS_DIRECT_GROUP] = "Direct_group datagram";
			MessageTypeList[Const.NBDS_BROADCAST] = "Broadcast datagram";
			MessageTypeList[Const.NBDS_ERROR] = "Datagram error";
			MessageTypeList[Const.NBDS_QUERY_REQUEST] = "Datagram query request";
			MessageTypeList[Const.NBDS_POS_QUERY_RESPONSE] = "Datagram positive query response";
			MessageTypeList[Const.NBDS_NEG_QUERY_RESPONSE] = "Datagram negative query response";

			YesNoList[1] = "Yes";
			YesNoList[0] = "No";

			NodeTypeList[0] = "B node";
			NodeTypeList[1] = "P node";
			NodeTypeList[2] = "M node";
			NodeTypeList[3] = "NBDD";

			ErrorCodeList[0] = "Destination name not present"; // + 0x82;
			ErrorCodeList[1] = "Invalid source name format";
			ErrorCodeList[2] = "Invalid destination name format";

			mNodex = new TreeNode();
			mNodex.Text = "NBDS ( Netbios Datagram Service )";
			kk = Index;
	

			try
			{
				PNbds.MessageType = PacketData[ Index ++ ];
				Tmp = "Message Type :" + Function.ReFormatString( PNbds.MessageType , MessageTypeList[ PNbds.MessageType ] );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PNbds.Flags = PacketData[ Index ++ ];
				Tmp = "Flags :" + Function.ReFormatString( PNbds.Flags , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				Tmp = "More fragments fallow :" + YesNoList[ PNbds.Flags & 1 ];
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				Tmp = "This is first fragment :" + YesNoList[ ( PNbds.Flags & 2 ) >> 1 ];
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				Tmp = "Node Type :" + NodeTypeList[ ( PNbds.Flags & 12 ) >> 2 ];
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PNbds.DatagramId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Datagram Id :" + Function.ReFormatString( PNbds.DatagramId , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PNbds.SourceIp = Function.GetIpAddress( PacketData , ref Index );
				Tmp = "Source Ip : " + PNbds.SourceIp;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PNbds.SourcePort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Source Port :" + Function.ReFormatString( PNbds.SourcePort , Const.GetPortStr( PNbds.SourcePort ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				switch( PNbds.MessageType ) 
				{
					case Const.NBDS_DIRECT_UNIQUE:
					case Const.NBDS_DIRECT_GROUP:
					case Const.NBDS_BROADCAST:
						PNbds.DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Datagram Length :" + Function.ReFormatString( PNbds.DataLength , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNbds.PacketOffset = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Packet Offset :" + Function.ReFormatString( PNbds.PacketOffset , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNbds.SourceName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						Tmp = "Source Name :" + PNbds.SourceName + " ( " + Const.GetNetBiosNames( NNumber ) + " )";
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 34 , 34 , false );

						PNbds.DestinationName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						Tmp = "Destination Name :" + PNbds.DestinationName + " ( " + Const.GetNetBiosNames( NNumber ) + " )";
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 34 , 34 , false );
						break;

					case Const.NBDS_ERROR:
						PNbds.ErrorCode = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Error Code :" + Function.ReFormatString( PNbds.ErrorCode , ErrorCodeList[ PNbds.ErrorCode - 0x82 ] );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
						break;

					case Const.NBDS_QUERY_REQUEST:
					case Const.NBDS_POS_QUERY_RESPONSE:
					case Const.NBDS_NEG_QUERY_RESPONSE:
						PNbds.DestinationName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						Tmp = "Destination Name :" + PNbds.DestinationName + " ( " + Const.GetNetBiosNames( NNumber ) + " )";
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 34 , 34 , false );
						break;

				}

				Function.SetPosition( ref mNodex , kk , Index - kk , true );
				mNode.Add( mNodex );

				if( ( Index + 4 ) < PacketData.Length )
				{
					if( ( PacketData[ Index  ] == 0xff ) &&
						( PacketData[ Index + 1 ] == 0x53 ) &&
						( PacketData[ Index + 2 ] == 0x4d ) &&
						( PacketData[ Index + 3 ] == 0x42 ) )
					{
						PacketSMB.Parser( ref mNode , PacketData , ref Index , ref LItem );
					}
				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NBDS";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Netbios datagram service";
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed NBDS packet. Remaining bytes don't fit an NBDS packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed NBDS packet. Remaining bytes don't fit an NBDS packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			byte NNumber = 0;
			PACKET_NBDS PNbds;

			try
			{
				PNbds.MessageType = PacketData[ Index ++ ];
				PNbds.Flags = PacketData[ Index ++ ];
				PNbds.DatagramId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PNbds.SourceIp = Function.GetIpAddress( PacketData , ref Index );
				PNbds.SourcePort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				switch( PNbds.MessageType ) 
				{
					case Const.NBDS_DIRECT_UNIQUE:
					case Const.NBDS_DIRECT_GROUP:
					case Const.NBDS_BROADCAST:
						PNbds.DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						PNbds.PacketOffset = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						PNbds.SourceName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						PNbds.DestinationName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						break;

					case Const.NBDS_ERROR:
						PNbds.ErrorCode = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						break;

					case Const.NBDS_QUERY_REQUEST:
					case Const.NBDS_POS_QUERY_RESPONSE:
					case Const.NBDS_NEG_QUERY_RESPONSE:
						PNbds.DestinationName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						break;

				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NBDS";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Netbios datagram service";

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed NBDS packet. Remaining bytes don't fit an NBDS packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
