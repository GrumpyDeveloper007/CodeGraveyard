using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketDCERPC
	{

		public struct PACKET_DCE_RPC
		{
			public byte Version;
			public byte VersionMinor;
			public byte PacketType;
			public byte PacketFlags;
			public uint DataRepesantation;
			public ushort FragLength;
			public ushort AuthLength;
			public uint CallId;
			public ushort MaxXmitFrag;
			public ushort MaxRecvFrag;
			public uint AssocGroup;
			public byte NumCtx;
			public ushort ContextId;
			public ushort NumTransItems;
			public string InterfaceUUIDStr;
			public ushort InterfaceVersion;
			public ushort InterfaceMinorVersion;
			public ushort TransferSyntax;
			public string SyntaxVersionStr;
		}



		public PacketDCERPC()
		{
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			PACKET_DCE_RPC PDceRpc;

			mNodex = new TreeNode();
			mNodex.Text = "DCE/RPC (  )";
			Function.SetPosition( ref mNodex , Index , Const.LENGTH_OF_DCERPC , true );
	
			if( ( Index + Const.LENGTH_OF_DCERPC ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				
				PDceRpc.Version = PacketData[ Index++ ];
				Tmp = "Version :" + Function.ReFormatString( PDceRpc.Version , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PDceRpc.VersionMinor = PacketData[ Index++ ];
				Tmp = "Version ( Minor ) :" + Function.ReFormatString( PDceRpc.VersionMinor , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PDceRpc.PacketType = PacketData[ Index++ ]; // 11 = Bind
				Tmp = "Packet Type :" + Function.ReFormatString( PDceRpc.PacketType , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PDceRpc.PacketFlags = PacketData[ Index++ ];
				Tmp = "Packet Flags :" + Function.ReFormatString( PDceRpc.PacketFlags , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PDceRpc.DataRepesantation = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Data Represantation :" + Function.ReFormatString( PDceRpc.DataRepesantation , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PDceRpc.FragLength = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Frag Length :" + Function.ReFormatString( PDceRpc.FragLength , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PDceRpc.AuthLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Auth Length :" + Function.ReFormatString( PDceRpc.AuthLength , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PDceRpc.CallId = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Call Id :" + Function.ReFormatString( PDceRpc.CallId , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PDceRpc.MaxXmitFrag = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Max Xmit Frag :" + Function.ReFormatString( PDceRpc.MaxXmitFrag , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PDceRpc.MaxRecvFrag = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Max Recv Frag :" + Function.ReFormatString( PDceRpc.MaxRecvFrag , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PDceRpc.AssocGroup = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Assoc Group :" + Function.ReFormatString( PDceRpc.AssocGroup , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PDceRpc.NumCtx = PacketData[ Index++ ];
				Tmp = "Num Ctx :" + Function.ReFormatString( PDceRpc.NumCtx , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PDceRpc.ContextId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Context Id :" + Function.ReFormatString( PDceRpc.ContextId , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PDceRpc.NumTransItems = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Num Trans Items :" + Function.ReFormatString( PDceRpc.NumTransItems , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
			
				PDceRpc.InterfaceUUIDStr = PacketData[ Index + 3 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 2 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 1 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 0 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 5 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 4 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 7 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 6 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 8 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 9 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 10 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 11 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 12 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 13 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 14 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 15 ].ToString("x02");
				Index += 16;
				Tmp = "Interface UUID :" + Function.ReFormatString( PDceRpc.InterfaceUUIDStr , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

				PDceRpc.InterfaceVersion = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Interface Version :" + Function.ReFormatString( PDceRpc.InterfaceVersion , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PDceRpc.InterfaceMinorVersion = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Interface Version ( Minor ) :" + Function.ReFormatString( PDceRpc.InterfaceMinorVersion , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PDceRpc.TransferSyntax = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Transfer Syntax :" + Function.ReFormatString( PDceRpc.TransferSyntax , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PDceRpc.SyntaxVersionStr = PacketData[ Index + 3 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 2 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 1 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 0 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 5 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 4 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 7 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 6 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 8 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 9 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 10 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 11 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 12 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 13 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 14 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 15 ].ToString("x02");
				Index += 16;
				Tmp = "Syntax Version :" + Function.ReFormatString( PDceRpc.SyntaxVersionStr , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "DCE/RPC";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "DCE/RPC";

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

		public static bool Parser( ref TreeNode mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			string Tmp = "";
			PACKET_DCE_RPC PDceRpc;

			mNode = new TreeNode();
			mNode.Text = "DCE/RPC (  )";
			Function.SetPosition( ref mNode , Index , Const.LENGTH_OF_DCERPC , true );
	
			if( ( Index + Const.LENGTH_OF_DCERPC ) > PacketData.Length )
			{
				Tmp = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";
				mNode.Nodes.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				
				PDceRpc.Version = PacketData[ Index++ ];
				Tmp = "Version :" + Function.ReFormatString( PDceRpc.Version , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 1 , 1 , false );

				PDceRpc.VersionMinor = PacketData[ Index++ ];
				Tmp = "Version ( Minor ) :" + Function.ReFormatString( PDceRpc.VersionMinor , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 1 , 1 , false );

				PDceRpc.PacketType = PacketData[ Index++ ]; // 11 = Bind
				Tmp = "Packet Type :" + Function.ReFormatString( PDceRpc.PacketType , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 1 , 1 , false );

				PDceRpc.PacketFlags = PacketData[ Index++ ];
				Tmp = "Packet Flags :" + Function.ReFormatString( PDceRpc.PacketFlags , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 1 , 1 , false );

				PDceRpc.DataRepesantation = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Data Represantation :" + Function.ReFormatString( PDceRpc.DataRepesantation , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 4 , 4 , false );

				PDceRpc.FragLength = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Frag Length :" + Function.ReFormatString( PDceRpc.FragLength , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );

				PDceRpc.AuthLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Auth Length :" + Function.ReFormatString( PDceRpc.AuthLength , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );

				PDceRpc.CallId = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Call Id :" + Function.ReFormatString( PDceRpc.CallId , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 4 , 4 , false );

				PDceRpc.MaxXmitFrag = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Max Xmit Frag :" + Function.ReFormatString( PDceRpc.MaxXmitFrag , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );

				PDceRpc.MaxRecvFrag = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Max Recv Frag :" + Function.ReFormatString( PDceRpc.MaxRecvFrag , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );

				PDceRpc.AssocGroup = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Assoc Group :" + Function.ReFormatString( PDceRpc.AssocGroup , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 4 , 4 , false );

				PDceRpc.NumCtx = PacketData[ Index++ ];
				Tmp = "Num Ctx :" + Function.ReFormatString( PDceRpc.NumCtx , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 1 , 1 , false );

				PDceRpc.ContextId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Context Id :" + Function.ReFormatString( PDceRpc.ContextId , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );

				PDceRpc.NumTransItems = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Num Trans Items :" + Function.ReFormatString( PDceRpc.NumTransItems , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );
			
				PDceRpc.InterfaceUUIDStr = PacketData[ Index + 3 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 2 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 1 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 0 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 5 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 4 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 7 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 6 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 8 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 9 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 10 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 11 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 12 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 13 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 14 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 15 ].ToString("x02");
				Index += 16;
				Tmp = "Interface UUID :" + Function.ReFormatString( PDceRpc.InterfaceUUIDStr , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 16 , 16 , false );

				PDceRpc.InterfaceVersion = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Interface Version :" + Function.ReFormatString( PDceRpc.InterfaceVersion , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );

				PDceRpc.InterfaceMinorVersion = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Interface Version ( Minor ) :" + Function.ReFormatString( PDceRpc.InterfaceMinorVersion , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );

				PDceRpc.TransferSyntax = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Transfer Syntax :" + Function.ReFormatString( PDceRpc.TransferSyntax , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 2 , 2 , false );

				PDceRpc.SyntaxVersionStr = PacketData[ Index + 3 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 2 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 1 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 0 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 5 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 4 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 7 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 6 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 8 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 9 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 10 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 11 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 12 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 13 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 14 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 15 ].ToString("x02");
				Index += 16;
				Tmp = "Syntax Version :" + Function.ReFormatString( PDceRpc.SyntaxVersionStr , null );
				mNode.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode , Index - 16 , 16 , false );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "DCE/RPC";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "DCE/RPC";

			}
			catch( Exception Ex )
			{
				Tmp = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";
				mNode.Nodes.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Nodes.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			string Tmp = "";
			PACKET_DCE_RPC PDceRpc;

			if( ( Index + Const.LENGTH_OF_DCERPC ) > PacketData.Length )
			{
				Tmp = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				
				PDceRpc.Version = PacketData[ Index++ ];
				PDceRpc.VersionMinor = PacketData[ Index++ ];
				PDceRpc.PacketType = PacketData[ Index++ ]; // 11 = Bind
				PDceRpc.PacketFlags = PacketData[ Index++ ];
				PDceRpc.DataRepesantation = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				PDceRpc.FragLength = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PDceRpc.AuthLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PDceRpc.CallId = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				PDceRpc.MaxXmitFrag = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PDceRpc.MaxRecvFrag = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PDceRpc.AssocGroup = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				PDceRpc.NumCtx = PacketData[ Index++ ];
				PDceRpc.ContextId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PDceRpc.NumTransItems = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PDceRpc.InterfaceUUIDStr = PacketData[ Index + 3 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 2 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 1 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 0 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 5 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 4 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 7 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 6 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 8 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 9 ].ToString("x02") + "-";
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 10 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 11 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 12 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 13 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 14 ].ToString("x02");
				PDceRpc.InterfaceUUIDStr += PacketData[ Index + 15 ].ToString("x02");
				Index += 16;
				PDceRpc.InterfaceVersion = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PDceRpc.InterfaceMinorVersion = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PDceRpc.TransferSyntax = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PDceRpc.SyntaxVersionStr = PacketData[ Index + 3 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 2 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 1 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 0 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 5 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 4 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 7 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 6 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 8 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 9 ].ToString("x02") + "-";
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 10 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 11 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 12 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 13 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 14 ].ToString("x02");
				PDceRpc.SyntaxVersionStr += PacketData[ Index + 15 ].ToString("x02");
				Index += 16;

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "DCE/RPC";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "DCE/RPC";

			}
			catch
			{
				Tmp = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed DCE/RPC packet. Remaining bytes don't fit an DCE/RPC packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
