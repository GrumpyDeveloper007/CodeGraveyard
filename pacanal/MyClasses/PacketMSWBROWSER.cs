using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketMSWBROWSER
	{

		public struct PACKET_MSW_BROWSER
		{
			public byte Command;
			public string CommandStr;
			public byte UpdateCount;
			public uint ServerType;
			public string ServerTypeStr;
			public byte OSMajorVersion;
			public byte OSMinorVersion;
			public ushort UpdatePeriodicity;
			public string ServerName;
			public string HostComment;
		}

		private PACKET_MSW_BROWSER PMswBrowser;

		public PacketMSWBROWSER()
		{

		}

		public TreeNode GetMSWBROWSERNode( PACKET_MSW_BROWSER PMswBrowser )
		{
			TreeNode mNode;
			string Tmp = "";

			mNode = new TreeNode();
			mNode.Text = "Microsoft Windows Browser Protocol";
			Tmp = "Command            :" + Function.ReFormatString( PMswBrowser.Command , PMswBrowser.CommandStr );
			mNode.Nodes.Add( Tmp );
			Tmp = "Update Count       :" + Function.ReFormatString( PMswBrowser.UpdateCount , null );
			mNode.Nodes.Add( Tmp );
			Tmp = "Server Type        :" + Function.ReFormatString( PMswBrowser.ServerType , PMswBrowser.ServerTypeStr );
			mNode.Nodes.Add( Tmp );
			Tmp = "OS Major Version   :" + Function.ReFormatString( PMswBrowser.OSMajorVersion , null );
			mNode.Nodes.Add( Tmp );
			Tmp = "OS Minor Version   :" + Function.ReFormatString( PMswBrowser.OSMinorVersion , null );
			mNode.Nodes.Add( Tmp );
			Tmp = "Update Peridiocity :" + Function.ReFormatString( PMswBrowser.UpdatePeriodicity , null );
			mNode.Nodes.Add( Tmp );
			Tmp = "Server Name        : " + PMswBrowser.ServerName;
			mNode.Nodes.Add( Tmp );
			Tmp = "Host Comment       : " + PMswBrowser.HostComment;
			mNode.Nodes.Add( Tmp );


			return mNode;
		}


		private string GetCommandString( byte cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				case	1	: Tmp = "Announcemnet & Broadcast"; break;
			}

			return Tmp;
		}

		public PACKET_MSW_BROWSER GetMSWBROWSERPart( byte [] PacketData , ref int Index )
		{
			PMswBrowser.Command = PacketData[ Index++ ];
			PMswBrowser.UpdateCount = PacketData[ Index++ ];
			PMswBrowser.ServerType = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
			PMswBrowser.OSMajorVersion = PacketData[ Index++ ];
			PMswBrowser.OSMinorVersion = PacketData[ Index++ ];
			PMswBrowser.UpdatePeriodicity = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );

			PMswBrowser.ServerName = "";
			while( PacketData[ Index ] != 0 )
				PMswBrowser.ServerName += (char) PacketData[ Index++ ];
			Index++;

			PMswBrowser.HostComment = "";
			if( Index >= PacketData.GetLength(0) )
				PMswBrowser.HostComment = "Null";
			else
			{
				while( PacketData[ Index ] != 0 )
					PMswBrowser.HostComment += (char) PacketData[ Index++ ];
			}

			return PMswBrowser;

		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			//PACKET_MSW_BROWSER PMswBrowser;

			mNodex = new TreeNode();
			mNodex.Text = "LLC ( Logical Link Control Protocol )";
	
			try
			{
				//Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "LLC";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Logical link control protocol";

				mNode.Add( mNodex );

			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed LLC packet. Remaining bytes don't fit an LLC packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed LLC packet. Remaining bytes don't fit an LLC packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			//PACKET_MSW_BROWSER PMswBrowser;

			try
			{
				//k = Index - 2; mNodex.Nodes[ mNodex.Nodes.Count - 1 ].Tag = k.ToString() + ",2";

				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "LLC";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Logical link control protocol";

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed MSW BROWSER packet. Remaining bytes don't fit an MSW BROWSER packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

	}
}
