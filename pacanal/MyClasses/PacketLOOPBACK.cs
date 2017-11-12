using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketLOOPBACK
	{

		public struct PACKET_LOOPBACK
		{
			public byte [] Data;
		}


		public PacketLOOPBACK()
		{

		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			int i = 0, Size = 0;
			PACKET_LOOPBACK PLoopback;

			mNodex = new TreeNode();
			mNodex.Text = "LOOPBACK ( Loopback Protocol )";
			Function.SetPosition( ref mNodex , Index , PacketData.Length - Index - 1 , true );
	

			try
			{
				Size = PacketData.GetLength(0) - Index;
				PLoopback.Data = new byte[Size];
				for( i = 0; i < Size; i ++ )
					PLoopback.Data[i] = PacketData[ Index++ ];

				Tmp = "Data : ";
				mNodex.Nodes.Add( Tmp );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "LOOPBACK";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Loopback protocol";

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed LOOPBACK packet. Remaining bytes don't fit an LOOPBACK packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed LOOPBACK packet. Remaining bytes don't fit an LOOPBACK packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			int i = 0, Size = 0;
			PACKET_LOOPBACK PLoopback;

			try
			{
				Size = PacketData.GetLength(0) - Index;
				PLoopback.Data = new byte[Size];
				for( i = 0; i < Size; i ++ )
					PLoopback.Data[i] = PacketData[ Index++ ];

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "LOOPBACK";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Loopback protocol";

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed LOOPBACK packet. Remaining bytes don't fit an LOOPBACK packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
