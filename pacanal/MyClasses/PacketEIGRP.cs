using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketEIGRP
	{


		public struct PACKET_EIGRP_SOFTWARE
		{
			public ushort Type;
			public ushort Size;
			public string IOS;
			public string EigrpRelease;
		}

		public struct PACKET_EIGRP_PARAMETERS
		{
			public ushort Type;
			public ushort Size;
			public byte K1;
			public byte K2;
			public byte K3;
			public byte K4;
			public byte K5;
			public byte Reserved;
			public ushort HoldTime;
		}

		public struct PACKET_EIGRP
		{
			public byte Version;
			public byte OpCode;
			public ushort Checksum;
			public uint Flags;
			public uint Sequence;
			public uint Acknowledge;
			public uint AutonomousSystem;
			public PACKET_EIGRP_PARAMETERS Parameters;
			public PACKET_EIGRP_SOFTWARE Software;

		}


		public PacketEIGRP()
		{

		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			TreeNode mNode1;
			string Tmp = "";
			PACKET_EIGRP PEigrp;

			mNodex = new TreeNode();
			mNodex.Text = "EIGRP ( Extended Interior Gateway Routing Protocol )";
			Function.SetPosition( ref mNodex , Index , Const.LENGTH_OF_EIGRP , true );
	
			if( ( Index + Const.LENGTH_OF_EIGRP ) > PacketData.Length )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed EIGRP packet. Remaining bytes don't fit an EIGRP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PEigrp.Version = PacketData[ Index++ ];
				Tmp = "Version : " + Function.ReFormatString( PEigrp.Version ,  null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PEigrp.OpCode = PacketData[ Index++ ];
				Tmp = "Opcode : " + Function.ReFormatString( PEigrp.OpCode ,  null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				PEigrp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Checksum : " + Function.ReFormatString( PEigrp.Checksum ,  null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PEigrp.Flags = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Flags : " + Function.ReFormatString( PEigrp.Flags ,  null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PEigrp.Sequence = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Sequence : " + Function.ReFormatString( PEigrp.Sequence ,  null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PEigrp.Acknowledge = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Acknowledgement Number : " + Function.ReFormatString( PEigrp.Acknowledge ,  null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				PEigrp.AutonomousSystem = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Autonomous Number : " + Function.ReFormatString( PEigrp.AutonomousSystem ,  null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

				mNode1 = new TreeNode();
				mNode1.Text = "EIGRP PARAMETERS";
				Function.SetPosition( ref mNode1 , Index , 12 , true );

				PEigrp.Parameters.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type : " + Function.ReFormatString( PEigrp.Parameters.Type ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PEigrp.Parameters.Size = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Size : " + Function.ReFormatString( PEigrp.Parameters.Size ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PEigrp.Parameters.K1 = PacketData[ Index++ ];
				Tmp = "K1 : " + Function.ReFormatString( PEigrp.Parameters.K1 ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

				PEigrp.Parameters.K2 = PacketData[ Index++ ];
				Tmp = "K2 : " + Function.ReFormatString( PEigrp.Parameters.K2 ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

				PEigrp.Parameters.K3 = PacketData[ Index++ ];
				Tmp = "K3 : " + Function.ReFormatString( PEigrp.Parameters.K3 ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

				PEigrp.Parameters.K4 = PacketData[ Index++ ];
				Tmp = "K4 : " + Function.ReFormatString( PEigrp.Parameters.K4 ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

				PEigrp.Parameters.K5 = PacketData[ Index++ ];
				Tmp = "K5 : " + Function.ReFormatString( PEigrp.Parameters.K5 ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

				PEigrp.Parameters.Reserved = PacketData[ Index++ ];
				Tmp = "Reserved : " + Function.ReFormatString( PEigrp.Parameters.Reserved ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

				PEigrp.Parameters.HoldTime = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Hold Time : " + Function.ReFormatString( PEigrp.Parameters.HoldTime ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				
				mNodex.Nodes.Add( mNode1 );

				mNode1 = new TreeNode();
				mNode1.Text = "EIGRP SOFTWARE VERSION";
				Function.SetPosition( ref mNode1 , Index , 8 , true );

				PEigrp.Software.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Type : " + Function.ReFormatString( PEigrp.Software.Type ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PEigrp.Software.Size = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Size : " + Function.ReFormatString( PEigrp.Software.Size ,  null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PEigrp.Software.IOS = PacketData[ Index++ ].ToString() + "." + PacketData[ Index++ ].ToString();
				Tmp = "IOS : " + PEigrp.Software.IOS.ToString();
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PEigrp.Software.EigrpRelease = PacketData[ Index++ ].ToString() + "." + PacketData[ Index++ ].ToString();
				Tmp = "EIGRP Release : " + PEigrp.Software.EigrpRelease.ToString();
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				mNodex.Nodes.Add( mNode1 );
			
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "EIGRP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Extended Interior Gateway Routing Protocol";

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed EIGRP packet. Remaining bytes don't fit an EIGRP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed EIGRP packet. Remaining bytes don't fit an EIGRP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			string Tmp = "";
			PACKET_EIGRP PEigrp;

			if( ( Index + Const.LENGTH_OF_EIGRP ) > PacketData.Length )
			{
				Tmp = "[ Malformed EIGRP packet. Remaining bytes don't fit an EIGRP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;
				
				return false;
			}

			try
			{
				PEigrp.Version = PacketData[ Index++ ];
				PEigrp.OpCode = PacketData[ Index++ ];
				PEigrp.Checksum = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Flags = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Sequence = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Acknowledge = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.AutonomousSystem = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Parameters.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Parameters.Size = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Parameters.K1 = PacketData[ Index++ ];
				PEigrp.Parameters.K2 = PacketData[ Index++ ];
				PEigrp.Parameters.K3 = PacketData[ Index++ ];
				PEigrp.Parameters.K4 = PacketData[ Index++ ];
				PEigrp.Parameters.K5 = PacketData[ Index++ ];
				PEigrp.Parameters.Reserved = PacketData[ Index++ ];
				PEigrp.Parameters.HoldTime = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Software.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Software.Size = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PEigrp.Software.IOS = PacketData[ Index++ ].ToString() + "." + PacketData[ Index++ ].ToString();
				PEigrp.Software.EigrpRelease = PacketData[ Index++ ].ToString() + "." + PacketData[ Index++ ].ToString();
			
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "EIGRP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Extended Interior Gateway Routing Protocol";

			}
			catch
			{
				Tmp = "[ Malformed EIGRP packet. Remaining bytes don't fit an EIGRP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed EIGRP packet. Remaining bytes don't fit an EIGRP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

	}
}
