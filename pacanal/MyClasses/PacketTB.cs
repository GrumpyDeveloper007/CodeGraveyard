using System;
using System.Windows.Forms;

namespace MyClasses
{

	// Transparent Bridging Protocol
	public class PacketTB
	{


		public struct PACKET_TRANSPARENT_BRIDGE
		{
			public ushort ProtocolIdentifier; // contains 0
			public byte Version; // contains 0
			// contains 0. if this value is 128 then this is a topology
			//change message. Because topology change messages has a 4 byte value
			//so further data processing must be stopped at this point.
			public byte MessageType; 
			public byte Flags;
			public ushort RootPriority;
			public string RootId; // 6 Bytes
			public uint RootPathCost;
			public ushort BridgePriority;
			public string BrifgeId; // 6 Bytes
			public ushort PortId;
			public ushort MessageAge;
			public ushort MaximumAge;
			public ushort HelloTime;
			public ushort ForwardDelay;
		}

		public PacketTB()
		{

		}

		public bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			//int k = 0;

			mNodex = new TreeNode();
			mNodex.Text = "TB ( Trans Bridging Protocol )";
			//mNodex.Tag = Index.ToString() + "," + Const.LENGTH_OF_ARP.ToString();
			//Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
	
			/*if( ( Index + Const.LENGTH_OF_ARP ) >= PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed TB packet. Remaining bytes don't fit an TB packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}*/

			try
			{
				//k = Index - 2; mNodex.Nodes[ mNodex.Nodes.Count - 1 ].Tag = k.ToString() + ",2";

				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "TB";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "TB protocol";

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed TB packet. Remaining bytes don't fit an TB packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed TB packet. Remaining bytes don't fit an TB packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

	}
}
