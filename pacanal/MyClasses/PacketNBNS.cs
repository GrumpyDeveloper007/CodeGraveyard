using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketNBNS
	{

		public struct QUESTION_ITEM
		{
			public string Name;
			public ushort Type;
			public ushort Class;
		}

		public struct QUESTIONS
		{
			public QUESTION_ITEM [] Items;
		}

		public struct ANSWER_ITEM
		{
			public string Name;
			public ushort Flags;
		}

		
		public struct ANSWERS
		{
			public string Name;
			public ushort Type;
			public ushort Class;
			public uint TimeToLive;
			public ushort DataLength;
			public ushort Flags;
			public string IpAddress;
			public byte NumberOfNames;
			public ANSWER_ITEM [] Items;
			public string UnitId;
			public byte Jumpers;
			public byte TestResult;
			public ushort VersionNumber;
			public ushort PeriodOfStatistics;
			public ushort CRCs;
			public ushort NumberOfAlignmentErrors;
			public ushort NumberOfCollisions;
			public ushort NumberOfSendAborts;
			public uint NumberOfGoodSends;
			public uint NumberOfReceives;
			public ushort NumberOfRetransmits;
			public ushort NumberOfNoResourceConditions;
			public ushort NumberOfCommandBlocks;
			public ushort NumberOfPendingSessions;
			public ushort MaxNumberOfPendingSessions;
			public ushort MaxTotalSessionPossible;
			public ushort SessionDataPacketSize;
		}

		public struct AUTHORITY_ITEM
		{
			public string Name;
			public ushort Type;
			public ushort Class;
		}

		public struct AUTHORITIES
		{
			public AUTHORITY_ITEM [] Items;
		}

		public struct ADDITIONAL_ITEM
		{
			public string Name;
			public ushort Type;
			public ushort Class;
			public uint TimeToLive;
			public ushort DataLength;
			public ushort Flags;
			public string Address;
		}

		public struct ADDITIONALS
		{
			public ADDITIONAL_ITEM [] Items;
		}


		public struct PACKET_NBNS
		{
			public ushort TransactionId;
			public ushort Flags;
			public ushort QuestionRRS;
			public ushort AnswerRRS;
			public ushort AuthorityRRS;
			public ushort AdditionalRRS;
			public QUESTIONS Questions;
			public ANSWERS Answers;
			public AUTHORITIES Authorities;
			public ADDITIONALS Additionals;

		}


		public PacketNBNS()
		{
		}


		public static string GetTypeString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case Const.TYPE_NB	 : Tmp = "NB"; break;
				case Const.TYPE_NBSTAT :  Tmp = "NBSTAT"; break;
				default : Tmp = "Unknown"; break;
			}

			return Tmp;
		}


		public static string GetClassString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case Const.CLASS_INET	: Tmp = "inet"; break;
				case ( Const.CLASS_INET | Const.CLASS_FLUSH ) : Tmp = "inet ( data flush )"; break;
				case Const.CLASS_CSNET : Tmp = "Csnet"; break;
				case Const.CLASS_CHAOS : Tmp = "Chaos"; break;
				case Const.CLASS_HESIOD : Tmp = "Hesiod"; break;
				case Const.CLASS_NONE	 : Tmp = "None"; break;
				case Const.CLASS_ANY	 : Tmp = "Any"; break;
			}

			return Tmp;
		}


		public static string GetErrorCodeString( byte b )
		{
			int i = 0;
			string [] ErrorCodeList = new string[16];

			for( i = 0; i < 16; i ++ )
				ErrorCodeList[i] = "Unknown";

			ErrorCodeList[0x00] = "Not listening on called name";
			ErrorCodeList[0x01] = "Not listening for called name";
			ErrorCodeList[0x02] = "Called name not present";
			ErrorCodeList[0x03] = "Called name present, but insufficient resources";
			ErrorCodeList[0x0F] = "Unspecified error";

			return ErrorCodeList[ b - 0x80 ];
		}

		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			TreeNode mNode1;
			TreeNode mNode2;
			string Tmp = "";
			int kk = 0 , kkk = 0;
			int i = 0;
			byte NNumber = 0;
			PACKET_NBNS PNbns;
			string [] NBFlagsNodeTypeList = new string[4];
			string [] NameFlagsNodeTypeList = new string[3];
			string [] OpCodeList = new string[16];
			string [] ReplyList = new string[8];
			int OpCode = 0 , ReplyCode = 0;
			int DataLength = 0;

			for( i = 0; i < 8; i ++ )
				ReplyList[i] = "Unknown";

			for( i = 0; i < 16; i ++ )
				OpCodeList[i] = "Unknown";

			NBFlagsNodeTypeList[0] = "B-mode node";
			NBFlagsNodeTypeList[1] = "P-mode node";
			NBFlagsNodeTypeList[2] = "M-mode node";
			NBFlagsNodeTypeList[3] = "H-mode node";

			NameFlagsNodeTypeList[Const.NAME_FLAGS_B_NODE] = "B-mode node";
			NameFlagsNodeTypeList[Const.NAME_FLAGS_P_NODE] = "P-mode node";
			NameFlagsNodeTypeList[Const.NAME_FLAGS_M_NODE] = "M-mode node";

			OpCodeList[Const.OPCODE_QUERY] = "Name query";
			OpCodeList[Const.OPCODE_REGISTRATION] = "Registration";
			OpCodeList[Const.OPCODE_RELEASE] = "Release";
			OpCodeList[Const.OPCODE_WACK] = "Wait for acknowledgment";
			OpCodeList[Const.OPCODE_REFRESH] = "Refresh";
			OpCodeList[Const.OPCODE_REFRESHALT] = "Refresh (alternate opcode)";
			OpCodeList[Const.OPCODE_MHREGISTRATION] = "Multi-homed registration";

			ReplyList[Const.RCODE_NOERROR] = "No error";
			ReplyList[Const.RCODE_FMTERROR] = "Request was invalidly formatted";
			ReplyList[Const.RCODE_SERVFAIL] = "Server failure";
			ReplyList[Const.RCODE_NAMEERROR] = "Requested name does not exist";
			ReplyList[Const.RCODE_NOTIMPL] = "Request is not implemented";
			ReplyList[Const.RCODE_REFUSED] = "Request was refused";
			ReplyList[Const.RCODE_ACTIVE] = "Name is owned by another node";
			ReplyList[Const.RCODE_CONFLICT] = "Name is in conflict";

			mNodex = new TreeNode();
			mNodex.Text = "NBNS ( Netbios Name Service )";
			kkk = Index;

			try
			{
				PNbns.TransactionId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Transaction Id :" + Function.ReFormatString( PNbns.TransactionId , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PNbns.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				OpCode = ( ushort ) ( ( int ) ( PNbns.Flags & 0x7800 ) >> 11 );
				ReplyCode = ( PNbns.Flags & 0xf );

				mNode1 = new TreeNode();
				mNode1.Text = "Flags :" + Function.ReFormatString( PNbns.Flags , null );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , true );
				mNode1.Nodes.Add( Function.DecodeBitField( PNbns.Flags , 0x8000 , "Message is a response", "Message is a query" ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PNbns.Flags , 0x7800 , OpCodeList ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PNbns.Flags , 0x0400 , "Authoritative : Server is an authority for domain", "Authoritative : Server is not an authority for domain" ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PNbns.Flags , 0x0200 , "Truncated : Message is truncated", "Truncated : Message is not truncated" ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PNbns.Flags , 0x0100 , "Recursion Desired : Do query recursively", "Recursion Desired : Don't do query recursively" ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PNbns.Flags , 0x0080 , "Recursion Available : Server can do recursive queries", "Recursion Available : Server cann't do recursive queries" ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PNbns.Flags , 0x0010 , "Broadcast : Packet is broadcast", "Broadcast : Packet is not broadcast" ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNode1.Nodes.Add( Function.DecodeBitField( PNbns.Flags , 0x000f , ReplyList ) );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );
				mNodex.Nodes.Add( mNode1 );

				PNbns.QuestionRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Question RRS :" + Function.ReFormatString( PNbns.QuestionRRS , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PNbns.AnswerRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Answer RRS :" + Function.ReFormatString( PNbns.AnswerRRS , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PNbns.AuthorityRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Authority RRS :" + Function.ReFormatString( PNbns.AuthorityRRS , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PNbns.AdditionalRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Additional RRS :" + Function.ReFormatString( PNbns.AdditionalRRS , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				if( PNbns.QuestionRRS > 0 )
				{
					mNode1 = new TreeNode();
					mNode1.Text = "Queries";
					Function.SetPosition( ref mNode1 , Index , PNbns.QuestionRRS * 38 , true );

					PNbns.Questions.Items = new QUESTION_ITEM[ PNbns.QuestionRRS ];
					for( i = 0; i < PNbns.QuestionRRS; i ++ )
					{
						mNode2 = new TreeNode();
						Function.SetPosition( ref mNode2 , Index , 38 , true );

						PNbns.Questions.Items[i].Name = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						Tmp = "Name :" + PNbns.Questions.Items[i].Name;
						mNode2.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode2 , Index - 34 , 34 , false );

						PNbns.Questions.Items[i].Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Type : " + Function.ReFormatString( PNbns.Questions.Items[i].Type , GetTypeString( PNbns.Questions.Items[i].Type ) );
						mNode2.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );

						PNbns.Questions.Items[i].Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Class : " + Function.ReFormatString( PNbns.Questions.Items[i].Class , GetClassString( PNbns.Questions.Items[i].Class ) );
						mNode2.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );

						mNode2.Text = PNbns.Questions.Items[i].Name + " , " + GetTypeString( PNbns.Questions.Items[i].Type ) + " , " + GetClassString( PNbns.Questions.Items[i].Class );
						mNode1.Nodes.Add( mNode2 );

					}

					mNodex.Nodes.Add( mNode1 );

				}

				if( PNbns.AnswerRRS > 0 )
				{
					mNode1 = new TreeNode();
					mNode1.Text = "Answers";
					kkk = Index;

					PNbns.Answers.Name = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
					Tmp = "Name :" + PNbns.Answers.Name;
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 34 , 34 , false );

					PNbns.Answers.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Type : " + Function.ReFormatString( PNbns.Answers.Type , GetTypeString( PNbns.Answers.Type ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					PNbns.Answers.Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Class : " + Function.ReFormatString( PNbns.Answers.Class , GetClassString( PNbns.Answers.Class ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					PNbns.Answers.TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Time to Live : " + Function.ReFormatString( PNbns.Answers.TimeToLive , Function.GetTimeStr( PNbns.Answers.TimeToLive ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

					PNbns.Answers.DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Data Length : " + Function.ReFormatString( PNbns.Answers.DataLength , null );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					switch( PNbns.Answers.Type )
					{
						case Const.T_NB :
							DataLength = PNbns.Answers.DataLength;
							while( DataLength > 0 )
							{
								if( OpCode == Const.OPCODE_WACK )
								{
									if( DataLength < 2 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}
								}
			
								PNbns.Answers.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								mNode2 = new TreeNode();
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , true );
								mNode2.Text = "Name Flags : " + Function.ReFormatString( PNbns.Answers.Flags , null );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x8000 , "Group name", "Unique name" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x6000 , NBFlagsNodeTypeList ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x1000 , "Name is being deregistered", "Name is not being deregistered" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0800 , "Name is in conflict", "Name is not in conflict" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0400 , "Name is active", "Name is not active" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0200 , "Permanent node name", "Not permanent node name" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x000f , ReplyList ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode1.Nodes.Add( mNode2 );
								DataLength -= 2;
								if( DataLength < 2 )
								{
									Tmp = "Incomplete entry detected ...";
									LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
									mNode1.Nodes.Add( Tmp );
									break;
								}

								PNbns.Answers.IpAddress = Function.GetIpAddress( PacketData , ref Index );
								Tmp = "Ip Address : " + PNbns.Answers.IpAddress;
								mNode1.Nodes.Add( Tmp );
								Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );
								DataLength -= 4;

							}
							break;

						case Const.T_NBSTAT :
							DataLength = PNbns.Answers.DataLength;
							if( DataLength < 1 )
							{
								Tmp = "Incomplete entry detected ...";
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
								mNode1.Nodes.Add( Tmp );
								break;
							}

							PNbns.Answers.NumberOfNames = PacketData[ Index ++ ];
							Tmp = "Number of Names : " + Function.ReFormatString( PNbns.Answers.NumberOfNames , null );
							mNode1.Nodes.Add( Tmp );
							Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

							if( PNbns.Answers.NumberOfNames > 0 )
							{
								PNbns.Answers.Items = new ANSWER_ITEM[PNbns.Answers.NumberOfNames];

								for( i = 0; i < PNbns.Answers.NumberOfNames; i ++ )
								{
									if( DataLength < 16 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}
									PNbns.Answers.Items[i].Name = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
									PNbns.Answers.Items[i].Name += " ( " + Const.GetNetBiosNames( NNumber ) + " )";
									Tmp = "Name : " + PNbns.Answers.Items[i].Name;
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 16 , 16 , false );
									DataLength -= 16;
									if( DataLength < 2 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}

									PNbns.Answers.Items[i].Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									mNode2 = new TreeNode();
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , true );
									mNode2.Text = "Name Flags : " + Function.ReFormatString( PNbns.Answers.Items[i].Flags , null );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x8000 , "Group name", "Unique name" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x6000 , NBFlagsNodeTypeList ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x1000 , "Name is being deregistered", "Name is not being deregistered" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0800 , "Name is in conflict", "Name is not in conflict" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0400 , "Name is active", "Name is not active" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0200 , "Permanent node name", "Not permanent node name" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode1.Nodes.Add( mNode2 );
									DataLength -= 2;

									if( DataLength < 6 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}

									PNbns.Answers.UnitId = Function.GetMACAddress( PacketData , ref Index );
									Tmp = "Unit Id : " + PNbns.Answers.UnitId;
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 6 , 6 , false );

									PNbns.Answers.Jumpers = PacketData[ Index ++ ];
									Tmp = "Jumpers : " + Function.ReFormatString( PNbns.Answers.Jumpers , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

									PNbns.Answers.TestResult = PacketData[ Index ++ ];
									Tmp = "Test Result : " + Function.ReFormatString( PNbns.Answers.TestResult , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

									PNbns.Answers.VersionNumber = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Version Number : " + Function.ReFormatString( PNbns.Answers.VersionNumber , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.PeriodOfStatistics = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Period of statistics : " + Function.ReFormatString( PNbns.Answers.PeriodOfStatistics , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.CRCs = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of CRCs : " + Function.ReFormatString( PNbns.Answers.CRCs , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfAlignmentErrors = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of alignment errors : " + Function.ReFormatString( PNbns.Answers.NumberOfAlignmentErrors , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfCollisions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of collisions : " + Function.ReFormatString( PNbns.Answers.NumberOfCollisions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfSendAborts = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of send aborts : " + Function.ReFormatString( PNbns.Answers.NumberOfSendAborts , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfGoodSends = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of good sends : " + Function.ReFormatString( PNbns.Answers.NumberOfGoodSends , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

									PNbns.Answers.NumberOfReceives = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of good receives : " + Function.ReFormatString( PNbns.Answers.NumberOfReceives , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

									PNbns.Answers.NumberOfRetransmits = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of retransmits : " + Function.ReFormatString( PNbns.Answers.NumberOfRetransmits , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfNoResourceConditions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of no resource conditions : " + Function.ReFormatString( PNbns.Answers.NumberOfNoResourceConditions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfCommandBlocks = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of command blocks : " + Function.ReFormatString( PNbns.Answers.NumberOfCommandBlocks , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of pending sessions : " + Function.ReFormatString( PNbns.Answers.NumberOfPendingSessions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.MaxNumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Max number of pending sessions : " + Function.ReFormatString( PNbns.Answers.MaxNumberOfPendingSessions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.MaxTotalSessionPossible = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Max total sessions possible : " + Function.ReFormatString( PNbns.Answers.MaxTotalSessionPossible , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.SessionDataPacketSize = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Session data packet size : " + Function.ReFormatString( PNbns.Answers.SessionDataPacketSize , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

								}
							}
							break;

						default :
							Tmp = "Data";
							mNode1.Nodes.Add( Tmp );
							Function.SetPosition( ref mNode1 , Index , PacketData.Length - Index , false );
							break;
					}

					Function.SetPosition( ref mNode1 , kk , Index - kk , true );
					mNodex.Nodes.Add( mNode1 );

				}

				if( PNbns.AuthorityRRS > 0 )
				{
					mNode1 = new TreeNode();
					mNode1.Text = "Authority Records";
					kkk = Index;

					PNbns.Answers.Name = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
					Tmp = "Name :" + PNbns.Answers.Name;
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 34 , 34 , false );

					PNbns.Answers.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Type : " + Function.ReFormatString( PNbns.Answers.Type , GetTypeString( PNbns.Answers.Type ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					PNbns.Answers.Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Class : " + Function.ReFormatString( PNbns.Answers.Class , GetClassString( PNbns.Answers.Class ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					PNbns.Answers.TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Time to Live : " + Function.ReFormatString( PNbns.Answers.TimeToLive , Function.GetTimeStr( PNbns.Answers.TimeToLive ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

					PNbns.Answers.DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Data Length : " + Function.ReFormatString( PNbns.Answers.DataLength , null );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					switch( PNbns.Answers.Type )
					{
						case Const.T_NB :
							DataLength = PNbns.Answers.DataLength;
							while( DataLength > 0 )
							{
								if( OpCode == Const.OPCODE_WACK )
								{
									if( DataLength < 2 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}
								}
			
								PNbns.Answers.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								mNode2 = new TreeNode();
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , true );
								mNode2.Text = "Name Flags : " + Function.ReFormatString( PNbns.Answers.Flags , null );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x8000 , "Group name", "Unique name" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x6000 , NBFlagsNodeTypeList ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x1000 , "Name is being deregistered", "Name is not being deregistered" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0800 , "Name is in conflict", "Name is not in conflict" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0400 , "Name is active", "Name is not active" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0200 , "Permanent node name", "Not permanent node name" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x000f , ReplyList ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode1.Nodes.Add( mNode2 );
								DataLength -= 2;
								if( DataLength < 2 )
								{
									Tmp = "Incomplete entry detected ...";
									LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
									mNode1.Nodes.Add( Tmp );
									break;
								}

								PNbns.Answers.IpAddress = Function.GetIpAddress( PacketData , ref Index );
								Tmp = "Ip Address : " + PNbns.Answers.IpAddress;
								mNode1.Nodes.Add( Tmp );
								Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );
								DataLength -= 4;

							}
							break;

						case Const.T_NBSTAT :
							DataLength = PNbns.Answers.DataLength;
							if( DataLength < 1 )
							{
								Tmp = "Incomplete entry detected ...";
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
								mNode1.Nodes.Add( Tmp );
								break;
							}

							PNbns.Answers.NumberOfNames = PacketData[ Index ++ ];
							Tmp = "Number of Names : " + Function.ReFormatString( PNbns.Answers.NumberOfNames , null );
							mNode1.Nodes.Add( Tmp );
							Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

							if( PNbns.Answers.NumberOfNames > 0 )
							{
								PNbns.Answers.Items = new ANSWER_ITEM[PNbns.Answers.NumberOfNames];

								for( i = 0; i < PNbns.Answers.NumberOfNames; i ++ )
								{
									if( DataLength < 16 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}
									PNbns.Answers.Items[i].Name = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
									PNbns.Answers.Items[i].Name += " ( " + Const.GetNetBiosNames( NNumber ) + " )";
									Tmp = "Name : " + PNbns.Answers.Items[i].Name;
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 16 , 16 , false );
									DataLength -= 16;
									if( DataLength < 2 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}

									PNbns.Answers.Items[i].Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									mNode2 = new TreeNode();
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , true );
									mNode2.Text = "Name Flags : " + Function.ReFormatString( PNbns.Answers.Items[i].Flags , null );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x8000 , "Group name", "Unique name" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x6000 , NBFlagsNodeTypeList ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x1000 , "Name is being deregistered", "Name is not being deregistered" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0800 , "Name is in conflict", "Name is not in conflict" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0400 , "Name is active", "Name is not active" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0200 , "Permanent node name", "Not permanent node name" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode1.Nodes.Add( mNode2 );
									DataLength -= 2;

									if( DataLength < 6 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}

									PNbns.Answers.UnitId = Function.GetMACAddress( PacketData , ref Index );
									Tmp = "Unit Id : " + PNbns.Answers.UnitId;
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 6 , 6 , false );

									PNbns.Answers.Jumpers = PacketData[ Index ++ ];
									Tmp = "Jumpers : " + Function.ReFormatString( PNbns.Answers.Jumpers , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

									PNbns.Answers.TestResult = PacketData[ Index ++ ];
									Tmp = "Test Result : " + Function.ReFormatString( PNbns.Answers.TestResult , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

									PNbns.Answers.VersionNumber = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Version Number : " + Function.ReFormatString( PNbns.Answers.VersionNumber , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.PeriodOfStatistics = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Period of statistics : " + Function.ReFormatString( PNbns.Answers.PeriodOfStatistics , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.CRCs = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of CRCs : " + Function.ReFormatString( PNbns.Answers.CRCs , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfAlignmentErrors = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of alignment errors : " + Function.ReFormatString( PNbns.Answers.NumberOfAlignmentErrors , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfCollisions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of collisions : " + Function.ReFormatString( PNbns.Answers.NumberOfCollisions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfSendAborts = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of send aborts : " + Function.ReFormatString( PNbns.Answers.NumberOfSendAborts , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfGoodSends = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of good sends : " + Function.ReFormatString( PNbns.Answers.NumberOfGoodSends , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

									PNbns.Answers.NumberOfReceives = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of good receives : " + Function.ReFormatString( PNbns.Answers.NumberOfReceives , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

									PNbns.Answers.NumberOfRetransmits = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of retransmits : " + Function.ReFormatString( PNbns.Answers.NumberOfRetransmits , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfNoResourceConditions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of no resource conditions : " + Function.ReFormatString( PNbns.Answers.NumberOfNoResourceConditions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfCommandBlocks = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of command blocks : " + Function.ReFormatString( PNbns.Answers.NumberOfCommandBlocks , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of pending sessions : " + Function.ReFormatString( PNbns.Answers.NumberOfPendingSessions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.MaxNumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Max number of pending sessions : " + Function.ReFormatString( PNbns.Answers.MaxNumberOfPendingSessions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.MaxTotalSessionPossible = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Max total sessions possible : " + Function.ReFormatString( PNbns.Answers.MaxTotalSessionPossible , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.SessionDataPacketSize = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Session data packet size : " + Function.ReFormatString( PNbns.Answers.SessionDataPacketSize , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

								}
							}
							break;

						default :
							Tmp = "Data";
							mNode1.Nodes.Add( Tmp );
							Function.SetPosition( ref mNode1 , Index , PacketData.Length - Index , false );
							break;
					}

					Function.SetPosition( ref mNode1 , kk , Index - kk , true );
					mNodex.Nodes.Add( mNode1 );
				}

				if( PNbns.AdditionalRRS > 0 )
				{
					mNode1 = new TreeNode();
					mNode1.Text = "Additional Records";
					kkk = Index;

					PNbns.Answers.Name = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
					Tmp = "Name :" + PNbns.Answers.Name;
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 34 , 34 , false );

					PNbns.Answers.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Type : " + Function.ReFormatString( PNbns.Answers.Type , GetTypeString( PNbns.Answers.Type ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					PNbns.Answers.Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Class : " + Function.ReFormatString( PNbns.Answers.Class , GetClassString( PNbns.Answers.Class ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					PNbns.Answers.TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Time to Live : " + Function.ReFormatString( PNbns.Answers.TimeToLive , Function.GetTimeStr( PNbns.Answers.TimeToLive ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

					PNbns.Answers.DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Data Length : " + Function.ReFormatString( PNbns.Answers.DataLength , null );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					switch( PNbns.Answers.Type )
					{
						case Const.T_NB :
							DataLength = PNbns.Answers.DataLength;
							while( DataLength > 0 )
							{
								if( OpCode == Const.OPCODE_WACK )
								{
									if( DataLength < 2 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}
								}
			
								PNbns.Answers.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								mNode2 = new TreeNode();
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , true );
								mNode2.Text = "Name Flags : " + Function.ReFormatString( PNbns.Answers.Flags , null );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x8000 , "Group name", "Unique name" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x6000 , NBFlagsNodeTypeList ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x1000 , "Name is being deregistered", "Name is not being deregistered" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0800 , "Name is in conflict", "Name is not in conflict" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0400 , "Name is active", "Name is not active" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x0200 , "Permanent node name", "Not permanent node name" ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Flags , 0x000f , ReplyList ) );
								Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
								mNode1.Nodes.Add( mNode2 );
								DataLength -= 2;
								if( DataLength < 2 )
								{
									Tmp = "Incomplete entry detected ...";
									LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
									mNode1.Nodes.Add( Tmp );
									break;
								}

								PNbns.Answers.IpAddress = Function.GetIpAddress( PacketData , ref Index );
								Tmp = "Ip Address : " + PNbns.Answers.IpAddress;
								mNode1.Nodes.Add( Tmp );
								Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );
								DataLength -= 4;

							}
							break;

						case Const.T_NBSTAT :
							DataLength = PNbns.Answers.DataLength;
							if( DataLength < 1 )
							{
								Tmp = "Incomplete entry detected ...";
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
								mNode1.Nodes.Add( Tmp );
								break;
							}

							PNbns.Answers.NumberOfNames = PacketData[ Index ++ ];
							Tmp = "Number of Names : " + Function.ReFormatString( PNbns.Answers.NumberOfNames , null );
							mNode1.Nodes.Add( Tmp );
							Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

							if( PNbns.Answers.NumberOfNames > 0 )
							{
								PNbns.Answers.Items = new ANSWER_ITEM[PNbns.Answers.NumberOfNames];

								for( i = 0; i < PNbns.Answers.NumberOfNames; i ++ )
								{
									if( DataLength < 16 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}
									PNbns.Answers.Items[i].Name = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
									PNbns.Answers.Items[i].Name += " ( " + Const.GetNetBiosNames( NNumber ) + " )";
									Tmp = "Name : " + PNbns.Answers.Items[i].Name;
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 16 , 16 , false );
									DataLength -= 16;
									if( DataLength < 2 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}

									PNbns.Answers.Items[i].Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									mNode2 = new TreeNode();
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , true );
									mNode2.Text = "Name Flags : " + Function.ReFormatString( PNbns.Answers.Items[i].Flags , null );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x8000 , "Group name", "Unique name" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x6000 , NBFlagsNodeTypeList ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x1000 , "Name is being deregistered", "Name is not being deregistered" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0800 , "Name is in conflict", "Name is not in conflict" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0400 , "Name is active", "Name is not active" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode2.Nodes.Add( Function.DecodeBitField( PNbns.Answers.Items[i].Flags , 0x0200 , "Permanent node name", "Not permanent node name" ) );
									Function.SetPosition( ref mNode2 , Index - 2 , 2 , false );
									mNode1.Nodes.Add( mNode2 );
									DataLength -= 2;

									if( DataLength < 6 )
									{
										Tmp = "Incomplete entry detected ...";
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										mNode1.Nodes.Add( Tmp );
										break;
									}

									PNbns.Answers.UnitId = Function.GetMACAddress( PacketData , ref Index );
									Tmp = "Unit Id : " + PNbns.Answers.UnitId;
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 6 , 6 , false );

									PNbns.Answers.Jumpers = PacketData[ Index ++ ];
									Tmp = "Jumpers : " + Function.ReFormatString( PNbns.Answers.Jumpers , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

									PNbns.Answers.TestResult = PacketData[ Index ++ ];
									Tmp = "Test Result : " + Function.ReFormatString( PNbns.Answers.TestResult , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

									PNbns.Answers.VersionNumber = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Version Number : " + Function.ReFormatString( PNbns.Answers.VersionNumber , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.PeriodOfStatistics = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Period of statistics : " + Function.ReFormatString( PNbns.Answers.PeriodOfStatistics , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.CRCs = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of CRCs : " + Function.ReFormatString( PNbns.Answers.CRCs , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfAlignmentErrors = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of alignment errors : " + Function.ReFormatString( PNbns.Answers.NumberOfAlignmentErrors , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfCollisions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of collisions : " + Function.ReFormatString( PNbns.Answers.NumberOfCollisions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfSendAborts = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of send aborts : " + Function.ReFormatString( PNbns.Answers.NumberOfSendAborts , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfGoodSends = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of good sends : " + Function.ReFormatString( PNbns.Answers.NumberOfGoodSends , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

									PNbns.Answers.NumberOfReceives = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of good receives : " + Function.ReFormatString( PNbns.Answers.NumberOfReceives , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

									PNbns.Answers.NumberOfRetransmits = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of retransmits : " + Function.ReFormatString( PNbns.Answers.NumberOfRetransmits , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfNoResourceConditions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of no resource conditions : " + Function.ReFormatString( PNbns.Answers.NumberOfNoResourceConditions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfCommandBlocks = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of command blocks : " + Function.ReFormatString( PNbns.Answers.NumberOfCommandBlocks , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.NumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Number of pending sessions : " + Function.ReFormatString( PNbns.Answers.NumberOfPendingSessions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.MaxNumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Max number of pending sessions : " + Function.ReFormatString( PNbns.Answers.MaxNumberOfPendingSessions , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.MaxTotalSessionPossible = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Max total sessions possible : " + Function.ReFormatString( PNbns.Answers.MaxTotalSessionPossible , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

									PNbns.Answers.SessionDataPacketSize = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									Tmp = "Session data packet size : " + Function.ReFormatString( PNbns.Answers.SessionDataPacketSize , null );
									mNode1.Nodes.Add( Tmp );
									Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

								}
							}
							break;

						default :
							Tmp = "Data";
							mNode1.Nodes.Add( Tmp );
							Function.SetPosition( ref mNode1 , Index , PacketData.Length - Index , false );
							break;
					}

					Function.SetPosition( ref mNode1 , kk , Index - kk , true );
					mNodex.Nodes.Add( mNode1 );
				}

				Function.SetPosition( ref mNodex , kkk , Index - kkk , true );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NBNS";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Netbios name service";

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed NBNS packet. Remaining bytes don't fit an NBNS packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed NBNS packet. Remaining bytes don't fit an NBNS packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			int i = 0;
			byte NNumber = 0;
			PACKET_NBNS PNbns;
			int OpCode = 0 , ReplyCode = 0;
			int DataLength = 0;


			try
			{

				PNbns.TransactionId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PNbns.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				OpCode = ( ushort ) ( ( int ) ( PNbns.Flags & 0x7800 ) >> 11 );
				ReplyCode = ( PNbns.Flags & 0xf );
				PNbns.QuestionRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PNbns.AnswerRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PNbns.AuthorityRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				PNbns.AdditionalRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

				if( PNbns.QuestionRRS > 0 )
				{
					PNbns.Questions.Items = new QUESTION_ITEM[ PNbns.QuestionRRS ];
					for( i = 0; i < PNbns.QuestionRRS; i ++ )
					{
						PNbns.Questions.Items[i].Name = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						PNbns.Questions.Items[i].Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						PNbns.Questions.Items[i].Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

					}

				}

				if( PNbns.AnswerRRS > 0 )
				{
					PNbns.Answers.Name = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
					PNbns.Answers.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

					switch( PNbns.Answers.Type )
					{
						case Const.T_NB :
							DataLength = PNbns.Answers.DataLength;
							while( DataLength > 0 )
							{
								if( OpCode == Const.OPCODE_WACK )
								{
									if( DataLength < 2 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}
								}
			
								PNbns.Answers.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								DataLength -= 2;
								if( DataLength < 2 )
								{
									LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
									break;
								}

								PNbns.Answers.IpAddress = Function.GetIpAddress( PacketData , ref Index );
								DataLength -= 4;

							}
							break;

						case Const.T_NBSTAT :
							DataLength = PNbns.Answers.DataLength;
							if( DataLength < 1 )
							{
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
								break;
							}

							PNbns.Answers.NumberOfNames = PacketData[ Index ++ ];

							if( PNbns.Answers.NumberOfNames > 0 )
							{
								PNbns.Answers.Items = new ANSWER_ITEM[PNbns.Answers.NumberOfNames];

								for( i = 0; i < PNbns.Answers.NumberOfNames; i ++ )
								{
									if( DataLength < 16 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}
									PNbns.Answers.Items[i].Name = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
									DataLength -= 16;
									if( DataLength < 2 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}

									PNbns.Answers.Items[i].Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									DataLength -= 2;

									if( DataLength < 6 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}

									PNbns.Answers.UnitId = Function.GetMACAddress( PacketData , ref Index );
									PNbns.Answers.Jumpers = PacketData[ Index ++ ];
									PNbns.Answers.TestResult = PacketData[ Index ++ ];
									PNbns.Answers.VersionNumber = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.PeriodOfStatistics = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.CRCs = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfAlignmentErrors = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfCollisions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfSendAborts = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfGoodSends = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfReceives = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfRetransmits = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfNoResourceConditions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfCommandBlocks = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.MaxNumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.MaxTotalSessionPossible = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.SessionDataPacketSize = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								}
							}
							break;

						default :
							break;
					}


				}

				if( PNbns.AuthorityRRS > 0 )
				{
					PNbns.Answers.Name = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
					PNbns.Answers.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

					switch( PNbns.Answers.Type )
					{
						case Const.T_NB :
							DataLength = PNbns.Answers.DataLength;
							while( DataLength > 0 )
							{
								if( OpCode == Const.OPCODE_WACK )
								{
									if( DataLength < 2 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}
								}
			
								PNbns.Answers.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								DataLength -= 2;
								if( DataLength < 2 )
								{
									LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
									break;
								}

								PNbns.Answers.IpAddress = Function.GetIpAddress( PacketData , ref Index );
								DataLength -= 4;

							}
							break;

						case Const.T_NBSTAT :
							DataLength = PNbns.Answers.DataLength;
							if( DataLength < 1 )
							{
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
								break;
							}

							PNbns.Answers.NumberOfNames = PacketData[ Index ++ ];

							if( PNbns.Answers.NumberOfNames > 0 )
							{
								PNbns.Answers.Items = new ANSWER_ITEM[PNbns.Answers.NumberOfNames];

								for( i = 0; i < PNbns.Answers.NumberOfNames; i ++ )
								{
									if( DataLength < 16 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}
									PNbns.Answers.Items[i].Name = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
									DataLength -= 16;
									if( DataLength < 2 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}

									PNbns.Answers.Items[i].Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									DataLength -= 2;

									if( DataLength < 6 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}

									PNbns.Answers.UnitId = Function.GetMACAddress( PacketData , ref Index );
									PNbns.Answers.Jumpers = PacketData[ Index ++ ];
									PNbns.Answers.TestResult = PacketData[ Index ++ ];
									PNbns.Answers.VersionNumber = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.PeriodOfStatistics = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.CRCs = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfAlignmentErrors = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfCollisions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfSendAborts = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfGoodSends = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfReceives = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfRetransmits = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfNoResourceConditions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfCommandBlocks = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.MaxNumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.MaxTotalSessionPossible = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.SessionDataPacketSize = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								}
							}
							break;

						default :
							break;
					}
				}

				if( PNbns.AdditionalRRS > 0 )
				{
					PNbns.Answers.Name = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
					PNbns.Answers.Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					PNbns.Answers.DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

					switch( PNbns.Answers.Type )
					{
						case Const.T_NB :
							DataLength = PNbns.Answers.DataLength;
							while( DataLength > 0 )
							{
								if( OpCode == Const.OPCODE_WACK )
								{
									if( DataLength < 2 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}
								}
			
								PNbns.Answers.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								DataLength -= 2;
								if( DataLength < 2 )
								{
									LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
									break;
								}

								PNbns.Answers.IpAddress = Function.GetIpAddress( PacketData , ref Index );
								DataLength -= 4;

							}
							break;

						case Const.T_NBSTAT :
							DataLength = PNbns.Answers.DataLength;
							if( DataLength < 1 )
							{
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
								break;
							}

							PNbns.Answers.NumberOfNames = PacketData[ Index ++ ];

							if( PNbns.Answers.NumberOfNames > 0 )
							{
								PNbns.Answers.Items = new ANSWER_ITEM[PNbns.Answers.NumberOfNames];

								for( i = 0; i < PNbns.Answers.NumberOfNames; i ++ )
								{
									if( DataLength < 16 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}
									PNbns.Answers.Items[i].Name = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
									DataLength -= 16;
									if( DataLength < 2 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}

									PNbns.Answers.Items[i].Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									DataLength -= 2;

									if( DataLength < 6 )
									{
										LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Incomplete entry detected ...";
										break;
									}

									PNbns.Answers.UnitId = Function.GetMACAddress( PacketData , ref Index );
									PNbns.Answers.Jumpers = PacketData[ Index ++ ];
									PNbns.Answers.TestResult = PacketData[ Index ++ ];
									PNbns.Answers.VersionNumber = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.PeriodOfStatistics = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.CRCs = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfAlignmentErrors = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfCollisions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfSendAborts = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfGoodSends = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfReceives = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfRetransmits = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfNoResourceConditions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfCommandBlocks = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.NumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.MaxNumberOfPendingSessions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.MaxTotalSessionPossible = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
									PNbns.Answers.SessionDataPacketSize = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
								}
							}
							break;

						default :
							break;
					}

				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NBNS";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Netbios name service";

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed NBNS packet. Remaining bytes don't fit an NBNS packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

	}
}
