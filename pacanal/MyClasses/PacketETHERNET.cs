using System;
using System.Windows.Forms;
using System.Collections;

namespace MyClasses
{

	public class PacketETHERNET
	{

		public struct PACKET_ETHERNET
		{
			public string Destination;
			public string Source;
			public ushort Type;
		}


		public PacketETHERNET()
		{

		}

		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref ListViewItem LItem , 
			ref uint PreviousHttpSequence, 
			ref ushort LastTftpPort)
		{
			TreeNode mNodex;
			string Tmp = "";
			int Index = 0;
			PACKET_ETHERNET PEthernet;

			mNodex = new TreeNode();
			mNodex.Text = "ETHERNET";
			Function.SetPosition( ref mNodex , Index  , Const.LENGTH_OF_ETHERNET , true );
	
			if( ( Index + Const.LENGTH_OF_ETHERNET ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed ETHERNET packet. Remaining bytes don't fit an ETHERNET packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{

				PEthernet.Destination = Function.GetMACAddress( PacketData , ref Index );;
				Tmp = "Destination : " + PEthernet.Destination;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 6 , 6 , false );

				PEthernet.Source = Function.GetMACAddress( PacketData , ref Index );;
				Tmp = "Source : " + PEthernet.Source;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 6 , 6 , false );

				PEthernet.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				if( PEthernet.Type <= 1500 )
				{
					Tmp = "Length : " + Function.ReFormatString( PEthernet.Type , null );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
				}
				else
				{
					Tmp = "Type : " + Function.ReFormatString( PEthernet.Type , Const.GetETHERTYPEStr( PEthernet.Type ) );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "ETHERNET";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PEthernet.Source;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PEthernet.Destination;
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Ethernet protocol";

				mNode.Add( mNodex );

				if( PEthernet.Type <= 1500 )
				{
					PacketLLC.Parser( ref mNode , PacketData , ref Index , ref LItem , ref PreviousHttpSequence , ref LastTftpPort );
				}
				else
				{
					switch( PEthernet.Type )
					{
						case Const.ETHERTYPE_PUP	: 
							break;

						case Const.ETHERTYPE_SPRITE 	: 
							break;

						case Const.ETHERTYPE_NS :
							break;

						case Const.ETHERTYPE_TRAIL	: 
							break;

						case Const.ETHERTYPE_MOPDL	: 
							break;

						case Const.ETHERTYPE_MOPRC	: 
							break;

						case Const.ETHERTYPE_DN	: 
							break;

						case Const.ETHERTYPE_LAT	: 
							break;

						case Const.ETHERTYPE_SCA	: 
							break;

						case Const.ETHERTYPE_IP	: 
							PacketINTERNET.Parser( ref mNode , PacketData , ref Index , ref LItem , ref PreviousHttpSequence , ref LastTftpPort );
							break;

						case Const.ETHERTYPE_ARP	: 
							PacketARP.Parser( ref mNode , PacketData , ref Index , ref LItem );
							break;

						case Const.ETHERTYPE_REVARP	: 
							break;

						case Const.ETHERTYPE_LANBRIDGE	: 
							break;

						case Const.ETHERTYPE_DECDNS	: 
							break;

						case Const.ETHERTYPE_DECDTS	: 
							break;

						case Const.ETHERTYPE_VEXP	: 
							break;

						case Const.ETHERTYPE_VPROD	: 
							break;

						case Const.ETHERTYPE_ATALK	: 
							break;

						case Const.ETHERTYPE_AARP	: 
							break;

						case Const.ETHERTYPE_8021Q	: 
							break;

						case Const.ETHERTYPE_IPX	: 
							PacketIPX.Parser( ref mNode , PacketData , ref Index , ref LItem );
							break;

						case Const.ETHERTYPE_IPV6	: 
							break;

						case Const.ETHERTYPE_LOOPBACK	: 
							PacketLOOPBACK.Parser( ref mNode , PacketData , ref Index , ref LItem );
							break;
					}
				}

			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed ETHERNET packet. Remaining bytes don't fit an ETHERNET packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed ETHERNET packet. Remaining bytes don't fit an ETHERNET packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref ListViewItem LItem , 
			ref string TypeInfo , 
			ref uint PreviousHttpSequence , 
			ref ushort LastTftpPort )
		{
			string Tmp = "";
			int Index = 0;
			PACKET_ETHERNET PEthernet;

			if( ( Index + Const.LENGTH_OF_ETHERNET ) > PacketData.Length )
			{
				Tmp = "[ Malformed ETHERNET packet. Remaining bytes don't fit an ETHERNET packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{

				PEthernet.Destination = Function.GetMACAddress( PacketData , ref Index );;
				PEthernet.Source = Function.GetMACAddress( PacketData , ref Index );;
				PEthernet.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "ETHERNET";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PEthernet.Source;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PEthernet.Destination;
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Ethernet protocol";

				if( PEthernet.Type <= 1500 )
				{
					PacketLLC.Parser( PacketData , ref Index , ref LItem , ref TypeInfo , ref PreviousHttpSequence , ref LastTftpPort );
				}
				else
				{
					switch( PEthernet.Type )
					{
						case Const.ETHERTYPE_PUP	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_SPRITE 	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_NS :
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_TRAIL	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_MOPDL	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_MOPRC	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_DN	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_LAT	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_SCA	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_IP	: 
							TypeInfo = "Other";
							PacketINTERNET.Parser( PacketData , ref Index , ref LItem , ref TypeInfo , ref PreviousHttpSequence , ref LastTftpPort );
							break;

						case Const.ETHERTYPE_ARP	: 
							TypeInfo = "Other";
							PacketARP.Parser( PacketData , ref Index , ref LItem  );
							break;

						case Const.ETHERTYPE_REVARP	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_LANBRIDGE	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_DECDNS	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_DECDTS	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_VEXP	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_VPROD	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_ATALK	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_AARP	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_8021Q	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_IPX	: 
							TypeInfo = "IPX";
							PacketIPX.Parser( PacketData , ref Index , ref LItem );
							break;

						case Const.ETHERTYPE_IPV6	: 
							TypeInfo = "Other";
							break;

						case Const.ETHERTYPE_LOOPBACK	: 
							TypeInfo = "Other";
							PacketLOOPBACK.Parser( PacketData , ref Index , ref LItem );
							break;
					}
				}

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed ETHERNET packet. Remaining bytes don't fit an ETHERNET packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
