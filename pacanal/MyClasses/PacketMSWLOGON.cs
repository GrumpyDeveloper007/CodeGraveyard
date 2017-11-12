using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketMSWLOGON
	{

		public struct PACKET_MSW_LOGON
		{
			public byte Command;
			public string CommandStr;
			public string ComputerName;
			public string MailSlotName;
			public string UnicodeComputerName;
			public uint NTVersion;
			public ushort LMNTToken;
			public string LMNTTokenStr;
			public ushort LM20Token;
			public string LM20TokenStr;
		}

		private PACKET_MSW_LOGON PMswLogon;

		public PacketMSWLOGON()
		{

		}

		public TreeNode GetMSWLOGONNode( PACKET_MSW_LOGON PMswLogon )
		{
			TreeNode mNode;
			string Tmp = "";

			mNode = new TreeNode();
			mNode.Text = "Microsoft Windows Browser Protocol";
			Tmp = "Command               :" + Function.ReFormatString( PMswLogon.Command , PMswLogon.CommandStr );
			mNode.Nodes.Add( Tmp );
			Tmp = "Computer Name         :" + PMswLogon.ComputerName;
			mNode.Nodes.Add( Tmp );
			Tmp = "Mailslot Name         :" + PMswLogon.MailSlotName;
			mNode.Nodes.Add( Tmp );
			Tmp = "Unicode Computer Name :" + PMswLogon.UnicodeComputerName;
			mNode.Nodes.Add( Tmp );
			Tmp = "NT Version            :" + Function.ReFormatString( PMswLogon.NTVersion , null );
			mNode.Nodes.Add( Tmp );
			Tmp = "LM NT Token           :" + Function.ReFormatString( PMswLogon.LMNTToken , PMswLogon.LMNTTokenStr );
			mNode.Nodes.Add( Tmp );
			Tmp = "LM 20 Token           : " + Function.ReFormatString( PMswLogon.LM20Token , PMswLogon.LM20TokenStr );
			mNode.Nodes.Add( Tmp );

			return mNode;
		}


		private string GetCommandString( byte cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				case	0x07	: Tmp = "Query for PDC ( Primary Domain Controller )"; break;
			}

			return Tmp;
		}

		private string GetLMNTTOKENString( uint cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				case	0xffff	: Tmp = "Windows NT Networking"; break;
			}

			return Tmp;
		}

		private string GetLM20TOKENString( uint cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				case	0xffff	: Tmp = "Lan Man 2.0 Or Higer"; break;
			}

			return Tmp;
		}

		public PACKET_MSW_LOGON GetMSWLOGONPart( byte [] PacketData , ref int Index )
		{

			PMswLogon.Command = PacketData[ Index++ ];

			while( PacketData[ Index ] == 0 ) Index ++;

			PMswLogon.ComputerName = "";
			while( PacketData[ Index ] != 0 )
				PMswLogon.ComputerName += (char) PacketData[ Index++ ];
			Index++;

			PMswLogon.MailSlotName = "";
			while( PacketData[ Index ] != 0 )
				PMswLogon.MailSlotName += (char) PacketData[ Index++ ];
			Index++;

			PMswLogon.UnicodeComputerName = "";
			while( ( PacketData[ Index ] != 0 ) && ( PacketData[ Index + 1 ] != 0 ) )
				PMswLogon.UnicodeComputerName += (char) PacketData[ Index++ ]; Index++;
			Index += 3;

			PMswLogon.NTVersion = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
			PMswLogon.LMNTToken = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
			PMswLogon.LM20Token = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );

			return PMswLogon;

		}

	}
}
