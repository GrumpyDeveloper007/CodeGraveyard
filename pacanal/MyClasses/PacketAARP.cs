using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketAARP
	{
		public struct PACKET_AARP
		{
			public ushort HardwareType;
			public ushort ProtocolType;
			public byte HardwareLength;
			public byte ProtocolLength;
			public ushort OpCode;
			public string SourceHardwareAddress;
			public string SourceIpAddress;
			public string DestinationHardwareAddress;
			public string DestinationIpAddress;

		}

		public PacketAARP()
		{
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , ref int Index,
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			int k = 0, kk = 0;
			PACKET_AARP PAarp;

			mNodex = new TreeNode();
			mNodex.Text = "AARP ( Apple Talk Address Resolution Protocol )";
			kk = Index;
	
			try
			{
				PAarp.HardwareType = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Hardware Type : " + Function.ReFormatString( PAarp.HardwareType , Const.GetAarpHardwareString(PAarp.HardwareType) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PAarp.ProtocolType = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Protocol Type : " + Function.ReFormatString( PAarp.ProtocolType  , Const.GetAarpHardwareString(PAarp.HardwareType) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PAarp.HardwareLength = PacketData[ Index ++ ];
				Tmp = "Hardware Length : " + Function.ReFormatString( PAarp.HardwareLength , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PAarp.ProtocolLength = PacketData[ Index ++ ];
				Tmp = "Protocol Length : " + Function.ReFormatString( PAarp.ProtocolLength , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PAarp.OpCode = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Operation Code : " + Function.ReFormatString( PAarp.OpCode , Const.GetAarpOptionString( PAarp.OpCode ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PAarp.SourceHardwareAddress = Const.GetAarpHardwareAddress( PacketData , ref Index , PAarp.HardwareLength , PAarp.HardwareType );
				Tmp = "Source MAC Address : " + Function.ReFormatString( PAarp.SourceHardwareAddress , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - PAarp.HardwareLength , PAarp.HardwareLength , false );

				PAarp.SourceIpAddress = Const.GetAarpIpAddress( PacketData , ref Index , PAarp.ProtocolLength , PAarp.ProtocolType );
				Tmp = "source Ip Address : " + Function.ReFormatString( PAarp.SourceIpAddress , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - PAarp.ProtocolLength , PAarp.ProtocolLength , false );
				
				PAarp.DestinationHardwareAddress = Const.GetAarpHardwareAddress( PacketData , ref Index , PAarp.HardwareLength , PAarp.HardwareType );
				Tmp = "Destination MAC Address : " + Function.ReFormatString( PAarp.DestinationHardwareAddress , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - PAarp.HardwareLength , PAarp.HardwareLength , false );
				
				PAarp.DestinationIpAddress = Const.GetAarpIpAddress( PacketData , ref Index , PAarp.ProtocolLength , PAarp.ProtocolType );
				Tmp = "Destination Ip Address : " + Function.ReFormatString( PAarp.DestinationIpAddress , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - PAarp.ProtocolLength , PAarp.ProtocolLength , false );
				
				switch( PAarp.OpCode ) 
				{
					case Const.AARP_REQUEST:
					case Const.AARP_REQUEST_SWAPPED:
						LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Who has " + PAarp.DestinationIpAddress + " ?  Tell " + PAarp.SourceIpAddress;
						break;
					case Const.AARP_REPLY:
					case Const.AARP_REPLY_SWAPPED:
						LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = PAarp.SourceIpAddress + " is at " + PAarp.SourceHardwareAddress;
						break;
					case Const.AARP_PROBE:
					case Const.AARP_PROBE_SWAPPED:
						LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Is there a " + PAarp.DestinationIpAddress + " ?";
						break;
					default:
						LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Unknown AARP opcode " + PAarp.OpCode.ToString("x04");
						break;
				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "AARP";
				LItem.SubItems[ Const.LIST_VIEW_SOURCE_INDEX ].Text = PAarp.SourceHardwareAddress;
				LItem.SubItems[ Const.LIST_VIEW_DESTINATION_INDEX ].Text = PAarp.DestinationHardwareAddress;

				k = kk; kk = Index - k;
				Function.SetPosition( ref mNodex , k , kk , true );
				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed AARP packet. Remaining bytes don't fit an AARP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;

		}



	}
}
