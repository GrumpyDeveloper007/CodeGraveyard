using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketSTP
	{

		public struct PACKET_STP
		{
			public ushort ProtocolIdentifier;
			public string ProtocolIdentifierStr;
			public byte   ProtocolVersionIdentifier;
			public string ProtocolVersionIdentifierStr;
			public byte   BPDUType;
			public string BPDUTypeStr;
			public byte   BPDUFlags;
			public ushort RootIdentifier;
			public string RootIdentifierStr;
			public uint   RootPathCost;
			public ushort BridgeIdentifier;
			public string BridgeIdentifierStr;
			public ushort PortIdentifier;
			public ushort MessageAge;
			public ushort MaxAge;
			public ushort HelloTime;
			public ushort ForwardDelay;
		}


		public PacketSTP()
		{
		}

		public static string GetProtocolIdString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case	Const.PROTOCOL_ID_STP	: Tmp = "Spanning Tree Protocol"; break;
			}

			return Tmp;
		}

		public static string GetProtocolVersionIdString( byte u )
		{
			string Tmp = "";

			switch( u )
			{
				case	Const.PROTOCOL_VERSION_ID_ST	: Tmp = "Spanning Tree"; break;
			}

			return Tmp;
		}

		public static string GetBPDUTypeString( byte u )
		{
			string Tmp = "";

			switch( u )
			{
				case	Const.BPDU_TYPE_CONFIGURATION	: Tmp = "Configuration"; break;
			}

			return Tmp;
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			TreeNode mNode1;
			string Tmp = "";
			PACKET_STP PStp;

			mNodex = new TreeNode();
			mNodex.Text = "STP ( Spanning Tree Protocol )";
			Function.SetPosition( ref mNodex , Index , Const.LENGTH_OF_STP , true );
	
			if( ( Index + Const.LENGTH_OF_STP ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed STP packet. Remaining bytes don't fit an STP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PStp.ProtocolIdentifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Protocol Identifier :" + Function.ReFormatString( PStp.ProtocolIdentifier , GetProtocolIdString(PStp.ProtocolIdentifier ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PStp.ProtocolVersionIdentifier = PacketData[ Index ++ ];
				Tmp = "Protocol Version Identifier :" + Function.ReFormatString( PStp.ProtocolVersionIdentifier , GetProtocolVersionIdString(PStp.ProtocolVersionIdentifier ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PStp.BPDUType = PacketData[ Index ++ ];
				Tmp = "BPDU Type :" + Function.ReFormatString( PStp.BPDUType , GetBPDUTypeString(PStp.BPDUType ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PStp.BPDUFlags = PacketData[ Index ++ ];
				mNode1 = new TreeNode();
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , true );
				mNode1.Text = "BPDU Flags :" + Function.ReFormatString( PStp.BPDUFlags , null );
				mNode1.Nodes.Add( Function.DecodeBitField( PStp.BPDUFlags , 0x80 , "Topology Change Acknowledgment : Yes" , "Topology Change Acknowledgment : No" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PStp.BPDUFlags , 0x01 , "Topology Change : Yes" , "Topology Change : No" ) );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
				mNodex.Nodes.Add( mNode1 );

				PStp.RootIdentifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PStp.RootIdentifierStr = Function.GetMACAddress( PacketData , ref Index );
				Tmp = "Root Identifier :" + PStp.RootIdentifier.ToString() + " , " + PStp.RootIdentifierStr;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 8 , 8 , false );

				PStp.RootPathCost = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Root Path Cost :" + Function.ReFormatString( PStp.RootPathCost , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PStp.BridgeIdentifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PStp.BridgeIdentifierStr = Function.GetMACAddress( PacketData , ref Index );
				Tmp = "Bridge Identifier :" + PStp.BridgeIdentifier.ToString() + " , " + PStp.BridgeIdentifierStr;
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 8 , 8 , false );

				PStp.PortIdentifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Port Identifier :" + Function.ReFormatString( PStp.PortIdentifier , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PStp.MessageAge = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Message Age :" + Function.ReFormatString( PStp.MessageAge , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PStp.MaxAge = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Max Age :" + Function.ReFormatString( PStp.MaxAge , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PStp.HelloTime = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Hello Time :" + Function.ReFormatString( PStp.HelloTime , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PStp.ForwardDelay = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Forward Delay :" + Function.ReFormatString( PStp.ForwardDelay , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "STP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "STP protocol";

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed STP packet. Remaining bytes don't fit an STP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed STP packet. Remaining bytes don't fit an STP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			string Tmp = "";
			PACKET_STP PStp;

			if( ( Index + Const.LENGTH_OF_STP ) > PacketData.Length )
			{
				Tmp = "[ Malformed STP packet. Remaining bytes don't fit an STP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PStp.ProtocolIdentifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PStp.ProtocolVersionIdentifier = PacketData[ Index ++ ];
				PStp.BPDUType = PacketData[ Index ++ ];
				PStp.BPDUFlags = PacketData[ Index ++ ];
				PStp.RootIdentifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PStp.RootIdentifierStr = Function.GetMACAddress( PacketData , ref Index );
				PStp.RootPathCost = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				PStp.BridgeIdentifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PStp.BridgeIdentifierStr = Function.GetMACAddress( PacketData , ref Index );
				PStp.PortIdentifier = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PStp.MessageAge = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PStp.MaxAge = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PStp.HelloTime = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PStp.ForwardDelay = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "STP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "STP protocol";

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed STP packet. Remaining bytes don't fit an STP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

	}
}
