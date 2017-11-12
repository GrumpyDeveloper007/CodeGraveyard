using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketSMBMAILSLOT
	{

		public struct PACKET_SMB_MAIL_SLOT
		{
			public ushort OpCode;
			public ushort Priority;
			public ushort Class;
			public string ClassStr;
			public ushort Size;
			public string MailSlotName;
		}



		public PacketSMBMAILSLOT()
		{

		}


		public static string GetOpCodeString( ushort cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				case	1	: Tmp = "Write Mail Slot"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetClassString( ushort cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				case	1	: Tmp = "Reliable"; break;
				case	2	: Tmp = "Unreliable & Broadcast"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem ,
			bool IsRequest,
			string MailSlotName )
		{
			TreeNode mNodex;
			PACKET_SMB_MAIL_SLOT PSmbMailSlot;
			string Tmp = "";
			int k = 0 , kk = 0 , kkk = 0;
			byte SubCmd = 0;

			mNodex = new TreeNode();
			mNodex.Text = "SMB Mail Slot ( SMB Mail Slot Protocol )";
			kk = Index;

			try
			{
				if( Index == PacketData.Length )
				{
					Tmp = "Interim Reply";
					mNodex.Nodes.Add( Tmp );
				}
				else
				{
					SubCmd = Const.MAILSLOT_UNKNOWN;

					if( IsRequest )
					{
						if( MailSlotName.Substring( 0 , 6 ) ==  "BROWSE" )
						{
							SubCmd = Const.MAILSLOT_BROWSE;
						} 
						else if( MailSlotName.Substring( 0 , 6 ) ==  "LANMAN" ) 
						{
							SubCmd = Const.MAILSLOT_LANMAN;
						} 
						else if( MailSlotName.Substring( 0 , 3 ) ==  "NET" )
						{
							SubCmd = Const.MAILSLOT_NET;
						} 
						else if( MailSlotName.Substring( 0 , 13 ) ==  "TEMP\\NETLOGON" )
						{
							SubCmd = Const.MAILSLOT_TEMP_NETLOGON;
						} 
						else if( MailSlotName.Substring( 0 , 4 ) ==  "MSSP" )
						{
							SubCmd = Const.MAILSLOT_MSSP;
						}
					} 

					PSmbMailSlot.OpCode = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					Tmp = "OpCode :" + Function.ReFormatString( PSmbMailSlot.OpCode , GetOpCodeString( PSmbMailSlot.OpCode ) );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					PSmbMailSlot.Priority = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					Tmp = "Priority :" + Function.ReFormatString( PSmbMailSlot.Priority , null );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					PSmbMailSlot.Class = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					Tmp = "Class :" + Function.ReFormatString( PSmbMailSlot.Class , GetClassString( PSmbMailSlot.Class ) );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					PSmbMailSlot.Size = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					Tmp = "Size :" + Function.ReFormatString( PSmbMailSlot.Size , null );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					k = Index;
					PSmbMailSlot.MailSlotName = "";
					while( PacketData[ Index ] != 0 )
						PSmbMailSlot.MailSlotName += (char) PacketData[ Index ++ ];

					Tmp = "Mail Slot Name :" + PSmbMailSlot.MailSlotName;
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , k , Index - k , false );

					mNode.Add( mNodex );
					Function.SetPosition( ref mNodex , kk , Index - kk , false );
				}

				mNode.Add( mNodex );
				Function.SetPosition( ref mNodex , kkk , Index - kkk , true );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "SMB MAIL SLOT";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "SMB Mail Slot Protocol";

				switch( SubCmd )
				{
					case Const.MAILSLOT_BROWSE:
						//PacketMSWBROWSER( ref mNode , PacketData , ref Index , ref LItem );
						break;

					case Const.MAILSLOT_LANMAN:
						//PacketLANMAN( ref mNode , PacketData , ref Index , ref LItem );
						break;

					case Const.MAILSLOT_NET:
					case Const.MAILSLOT_TEMP_NETLOGON:
					case Const.MAILSLOT_MSSP:
						//PacketMSWLOGON( ref mNode , PacketData , ref Index , ref LItem );
						break;
				}


			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed SMB Mail Slot packet. Remaining bytes don't fit an SMB Mail Slot packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;

		}


		public static bool Parser( ref TreeNode mNode, 
			ref TreeNode mNodeSubNode,
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem ,
			bool IsRequest,
			string MailSlotName )
		{
			TreeNode mNodex;
			PACKET_SMB_MAIL_SLOT PSmbMailSlot;
			string Tmp = "";
			int k = 0 , kk = 0 , kkk = 0;
			byte SubCmd = 0;

			mNodex = new TreeNode();
			mNodex.Text = "SMB Mail Slot ( Server Message Block Mail Slot Resolution Protocol )";
			kk = Index;

			try
			{
				if( Index == PacketData.Length )
				{
					Tmp = "Interim Reply";
					mNodex.Nodes.Add( Tmp );
				}
				else
				{
					SubCmd = Const.MAILSLOT_UNKNOWN;

					if( IsRequest )
					{
						if( MailSlotName.Substring( 0 , 6 ) ==  "BROWSE" )
						{
							SubCmd = Const.MAILSLOT_BROWSE;
						} 
						else if( MailSlotName.Substring( 0 , 6 ) ==  "LANMAN" ) 
						{
							SubCmd = Const.MAILSLOT_LANMAN;
						} 
						else if( MailSlotName.Substring( 0 , 3 ) ==  "NET" )
						{
							SubCmd = Const.MAILSLOT_NET;
						} 
						else if( MailSlotName.Substring( 0 , 13 ) ==  "TEMP\\NETLOGON" )
						{
							SubCmd = Const.MAILSLOT_TEMP_NETLOGON;
						} 
						else if( MailSlotName.Substring( 0 , 4 ) ==  "MSSP" )
						{
							SubCmd = Const.MAILSLOT_MSSP;
						}
					} 

					PSmbMailSlot.OpCode = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					Tmp = "OpCode :" + Function.ReFormatString( PSmbMailSlot.OpCode , GetOpCodeString( PSmbMailSlot.OpCode ) );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					PSmbMailSlot.Priority = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					Tmp = "Priority :" + Function.ReFormatString( PSmbMailSlot.Priority , null );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					PSmbMailSlot.Class = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					Tmp = "Class :" + Function.ReFormatString( PSmbMailSlot.Class , GetClassString( PSmbMailSlot.Class ) );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					PSmbMailSlot.Size = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					Tmp = "Size :" + Function.ReFormatString( PSmbMailSlot.Size , null );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					k = Index;
					PSmbMailSlot.MailSlotName = "";
					while( PacketData[ Index ] != 0 )
						PSmbMailSlot.MailSlotName += (char) PacketData[ Index ++ ];

					Tmp = "Mail Slot Name :" + PSmbMailSlot.MailSlotName;
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , k , Index - k , false );

					//mNode.Add( mNodex );
					//Function.SetPosition( ref mNodex , kk , Index - kk , false );
				}

				mNode = mNodex;
				Function.SetPosition( ref mNode , kkk , Index - kkk , true );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "SMB MAIL SLOT";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "SMB Mail Slot protocol";

				switch( SubCmd )
				{
					case Const.MAILSLOT_BROWSE:
						//PacketMSWBROWSER( ref mNodeSubNode , PacketData , ref Index , ref LItem );
						break;

					case Const.MAILSLOT_LANMAN:
						//PacketLANMAN( ref mNodeSubNode , PacketData , ref Index , ref LItem );
						break;

					case Const.MAILSLOT_NET:
					case Const.MAILSLOT_TEMP_NETLOGON:
					case Const.MAILSLOT_MSSP:
						//PacketMSWLOGON( ref mNodeSubNode , PacketData , ref Index , ref LItem );
						break;
				}


			}
			catch( Exception Ex )
			{
				mNode = mNodex;
				Tmp = "[ Malformed SMB Mail Slot packet. Remaining bytes don't fit an SMB Mail Slot packet. Possibly due to bad decoding ]";
				mNode.Nodes.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Nodes.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;

		}

		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem ,
			bool IsRequest,
			string MailSlotName )
		{
			PACKET_SMB_MAIL_SLOT PSmbMailSlot;
			string Tmp = "";
			byte SubCmd = 0;

			try
			{
				if( Index == PacketData.Length )
				{
				}
				else
				{
					SubCmd = Const.MAILSLOT_UNKNOWN;

					if( IsRequest )
					{
						if( MailSlotName.Substring( 0 , 6 ) ==  "BROWSE" )
						{
							SubCmd = Const.MAILSLOT_BROWSE;
						} 
						else if( MailSlotName.Substring( 0 , 6 ) ==  "LANMAN" ) 
						{
							SubCmd = Const.MAILSLOT_LANMAN;
						} 
						else if( MailSlotName.Substring( 0 , 3 ) ==  "NET" )
						{
							SubCmd = Const.MAILSLOT_NET;
						} 
						else if( MailSlotName.Substring( 0 , 13 ) ==  "TEMP\\NETLOGON" )
						{
							SubCmd = Const.MAILSLOT_TEMP_NETLOGON;
						} 
						else if( MailSlotName.Substring( 0 , 4 ) ==  "MSSP" )
						{
							SubCmd = Const.MAILSLOT_MSSP;
						}
					} 

					PSmbMailSlot.OpCode = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					PSmbMailSlot.Priority = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					PSmbMailSlot.Class = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					PSmbMailSlot.Size = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
					PSmbMailSlot.MailSlotName = "";
					while( PacketData[ Index ] != 0 )
						PSmbMailSlot.MailSlotName += (char) PacketData[ Index ++ ];

				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "SMB MAIL SLOT";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "SMB Mail Slot protocol";

				switch( SubCmd )
				{
					case Const.MAILSLOT_BROWSE:
						//PacketMSWBROWSER( PacketData , ref Index , ref LItem );
						break;

					case Const.MAILSLOT_LANMAN:
						//PacketLANMAN( PacketData , ref Index , ref LItem );
						break;

					case Const.MAILSLOT_NET:
					case Const.MAILSLOT_TEMP_NETLOGON:
					case Const.MAILSLOT_MSSP:
						//PacketMSWLOGON( PacketData , ref Index , ref LItem );
						break;
				}


			}
			catch
			{
				Tmp = "[ Malformed SMB Mail Slot packet. Remaining bytes don't fit an SMB Mail Slot packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;

		}




	}
}
