using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketDNS
	{

		/*public struct PACKET_DNS_QUERY
		{
			public string Name;
			public ushort Type;
			public string TypeStr;
			public ushort Class;
			public string ClassStr;
		}*/

		public struct QUESTION_ITEM
		{
			public string Name;
			public ushort Type;
			public string TypeStr;
			public ushort Class;
			public string ClassStr;
		}

		public struct ANSWER_ITEM
		{
			public string Name;
			public string NameStr;
			public ushort Type;
			public string TypeStr;
			public ushort Class;
			public string ClassStr;
			public uint TimeToLive;
			public ushort DataLength;
			public string IpAddress;
		}

		/*public struct ANSWER_ITEM
		{
			public string Name;
			public ushort Type;
			public string TypeStr;
			public ushort Class;
			public string ClassStr;
			public uint TimeToLive;
			public string TimeToLiveStr;
			public ushort DataLength;
			public ushort Flags;
			public string FlagsStr;
			public uint Address;
			public string AddressStr;
		}*/

		public struct AUTHORITY_ITEM
		{
			public string Name;
			public ushort Type;
			public string TypeStr;
			public ushort Class;
			public string ClassStr;
			public uint TimeToLive;
			public ushort DataLength;
			public string PrimaryNameServer;
			public string ResponsibleAuthoritysMailBox;
			public uint SerialNumber;
			public uint RefreshInterval;
			public uint RetryInterval;
			public uint ExpirationLimit;
			public uint MinimumTTL;
		}


		public struct ADDITIONAL_ITEM
		{
			public string Name;
			public ushort Type;
			public string TypeStr;
			public ushort Class;
			public string ClassStr;
			public uint TimeToLive;
			public string TimeToLiveStr;
			public ushort DataLength;
			public ushort Flags;
			public string FlagsStr;
			public uint Address;
			public string AddressStr;
		}



		public struct PACKET_DNS
		{
			public ushort TransactionId;
			public ushort Flags;
			public string FlagsStr;
			public ushort Questions;
			public ushort AnswerRRS;
			public ushort AuthorityRRS;
			public ushort AdditionalRRS;
			public QUESTION_ITEM [] QuestionObject;
			public ANSWER_ITEM [] AnswerObject;
			public AUTHORITY_ITEM [] AuthorityObject;
			public ADDITIONAL_ITEM [] AdditionalObject;

		}


		private PACKET_DNS PDns;
		private string [] FlagsArray = new string[8];
		private string [] Flags2Array = new string[2];

		public PacketDNS()
		{

		}


		private void InitStruct()
		{
			PDns.AdditionalRRS = 0;
			PDns.AnswerRRS = 0;
			PDns.AuthorityRRS = 0;
			PDns.Flags = 0;
			PDns.FlagsStr = "";
			PDns.Questions = 0;
			PDns.TransactionId = 0;

		}

		public string GetTypeString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case Const.TYPE_NB	: Tmp = "NB"; break;
			}

			return Tmp;
		}


		public string GetClassString( ushort u )
		{
			string Tmp = "";

			switch( u )
			{
				case Const.CLASS_INET	: Tmp = "inet"; break;
			}

			return Tmp;
		}

		private string GetOpcodeString( ushort b )
		{
			string Tmp = "", Tmp2 = "";
			int bb = (int) b;
			byte bbb;

			bb >>= 11;
			bb &= 0x0000000f;

			bbb = (byte) bb;

			switch( bb )
			{
				case	0	: Tmp = "Name query"; break;
				case	5	: Tmp = "Registration"; break;
			}

			Tmp += "( " + bb.ToString() + " )";

			if( ( bbb & 8 ) == 8 ) Tmp2 += ".1"; else Tmp2 += ".0";
			if( ( bbb & 4 ) == 4 ) Tmp2 += "1"; else Tmp2 += "0";
			if( ( bbb & 2 ) == 2 ) Tmp2 += "1"; else Tmp2 += "0";
			if( ( bbb & 1 ) == 1 ) Tmp2 += " 1"; else Tmp2 += " 0";

			Tmp = Tmp2 + "... .... .... = Opcode : " + Tmp;

			return Tmp;
		}

		private string GetReplayCodeString( ushort b )
		{
			string Tmp = "", Tmp2 = "";
			byte bb = (byte) b;

			bb &= 0x0f;

			switch( bb )
			{
				case	0	: Tmp = "No Error"; break;
			}

			Tmp += "( " + bb.ToString() + " )";

			if( ( bb & 8 ) == 8 ) Tmp2 += "1"; else Tmp2 += "0";
			if( ( bb & 4 ) == 4 ) Tmp2 += "1"; else Tmp2 += "0";
			if( ( bb & 2 ) == 2 ) Tmp2 += "1"; else Tmp2 += "0";
			if( ( bb & 1 ) == 1 ) Tmp2 += "1"; else Tmp2 += "0";

			Tmp = ".... .... .... " + Tmp2 + " = Reply Code : " + Tmp;

			return Tmp;
		}

		private void GetFlagsString( ushort u )
		{
			string Tmp = "";

			if( ( u & Const.FLAGS_RESPONSE ) == Const.FLAGS_RESPONSE )
				Tmp = "1... .... .... .... = Response : Message is a response";
			else
				Tmp = "0... .... .... .... = Response : Message is a query";

			FlagsArray[0] = Tmp;

			Tmp = GetOpcodeString( u );
			FlagsArray[1] = Tmp;

			if( ( u & Const.FLAGS_AUTHORITATIVE ) == Const.FLAGS_AUTHORITATIVE )
				Tmp = ".... .1.. .... .... = Authoritative : Server is an authority for domain";
			else
				Tmp = ".... .0.. .... .... = Authoritative : Server is not an authority for domain";

			FlagsArray[2] = Tmp;

			if( ( u & Const.FLAGS_TRUNCATED ) == Const.FLAGS_TRUNCATED )
				Tmp = ".... ..1. .... .... = Truncated : Message is truncated";
			else
				Tmp = ".... ..0. .... .... = Truncated : Message is not truncated";

			FlagsArray[3] = Tmp;

			if( ( u & Const.FLAGS_RECURSION_DESIRED ) == Const.FLAGS_RECURSION_DESIRED )
				Tmp = ".... ...1 .... .... = Recursion Desired : Do query recursively";
			else
				Tmp = ".... ...0 .... .... = Recursion Desired : Don't do query recursively";

			FlagsArray[4] = Tmp;

			if( ( u & Const.FLAGS_RECURSION_AVAILABLE ) == Const.FLAGS_RECURSION_AVAILABLE )
				Tmp = ".... .... 1... .... = Recursion Available : Server can do recursive queries";
			else
				Tmp = ".... .... 0... .... = Recursion Available : Server cann't do recursive queries";

			FlagsArray[5] = Tmp;

			if( ( u & Const.FLAGS_BROADCAST ) == Const.FLAGS_BROADCAST )
				Tmp = ".... .... ...1 .... = Broadcast : Packet is broadcast";
			else
				Tmp = ".... .... ...0 .... = Broadcast : Packet is not broadcast";

			FlagsArray[6] = Tmp;

			Tmp = GetReplayCodeString( u );
			FlagsArray[7] = Tmp;

		}

		private void GetFlags2String( ushort u )
		{
			string Tmp = "";
			byte b;

			if( ( u & (ushort) 0x80 ) == 0x80 )
				Tmp = "1... .... .... .... = Not unique name";
			else
				Tmp = "0... .... .... .... = Unique name";

			Flags2Array[0] = Tmp;

			int uu = (int) u;

			uu >>= 13;
			uu &= 0x00000003;
			b = (byte) uu;

			if( b == 0 ) Tmp = ".00. .... .... .... = B-node";
			else if( b == 1 ) Tmp = ".01. .... .... .... = ?";
			else if( b == 2 ) Tmp = ".10. .... .... .... = ?";
			else if( b == 3 ) Tmp = ".11. .... .... .... = ?";

			Flags2Array[1] = Tmp;

		}


		public TreeNode GetDNSNode( PACKET_DNS PDns )
		{
			TreeNode mNode;
			TreeNode mNode1;
			TreeNode mNode2;
			string Tmp = "";
			int i = 0;

			mNode = new TreeNode();
			mNode.Text = "DOMAIN NAME SERVICE";

			Tmp = "Transaction Id :" + Function.ReFormatString( PDns.TransactionId , null );
			mNode.Nodes.Add( Tmp );

			mNode1 = new TreeNode();
			mNode1.Text = "Flags :" + Function.ReFormatString( PDns.Flags , null );
			GetFlagsString( PDns.Flags );
			for( i = 0; i < 8; i ++ )
				mNode1.Nodes.Add( FlagsArray[ i ] );
			mNode.Nodes.Add( mNode1 );

			Tmp = "Questions :" + Function.ReFormatString( PDns.Questions , null );
			mNode.Nodes.Add( Tmp );

			Tmp = "Answer RRS :" + Function.ReFormatString( PDns.AnswerRRS , null );
			mNode.Nodes.Add( Tmp );

			Tmp = "Authority RRS :" + Function.ReFormatString( PDns.AuthorityRRS , null );
			mNode.Nodes.Add( Tmp );

			Tmp = "Additional RRS :" + Function.ReFormatString( PDns.AdditionalRRS , null );
			mNode.Nodes.Add( Tmp );

			if( PDns.Questions > 0 )
			{
				mNode1 = new TreeNode();
				mNode1.Text = "QUERIES";

				for( i = 1; i <= PDns.Questions; i ++ )
				{
					mNode2 = new TreeNode();
					mNode2.Text = "Query Record " + i.ToString();

					Tmp = "Name :" + PDns.QuestionObject[i-1].Name;
					mNode2.Nodes.Add( Tmp );

					Tmp = "Type : " + Function.ReFormatString( PDns.QuestionObject[i-1].Type , PDns.QuestionObject[i-1].TypeStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Class : " + Function.ReFormatString( PDns.QuestionObject[i-1].Class , PDns.QuestionObject[i-1].ClassStr );
					mNode2.Nodes.Add( Tmp );

					mNode1.Nodes.Add( mNode2 );

				}

				mNode.Nodes.Add( mNode1 );
			}

			if( PDns.AnswerRRS > 0 )
			{
				mNode1 = new TreeNode();
				mNode1.Text = "ANSWER RECORDS";

				for( i = 1; i <= PDns.AnswerRRS; i ++ )
				{
					mNode2 = new TreeNode();
					mNode2.Text = "Answer Record " + i.ToString();

					Tmp = "Name :" + PDns.AnswerObject[i-1].Name;
					mNode2.Nodes.Add( Tmp );

					Tmp = "Type : " + Function.ReFormatString( PDns.AnswerObject[i-1].Type , PDns.AnswerObject[i-1].TypeStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Class : " + Function.ReFormatString( PDns.AnswerObject[i-1].Class , PDns.AnswerObject[i-1].ClassStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Time to Live : " + Function.ReFormatString( PDns.AnswerObject[i-1].TimeToLive , null );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Data Length : " + Function.ReFormatString( PDns.AnswerObject[i-1].DataLength , null );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Ip Address :" + PDns.AnswerObject[i-1].IpAddress;
					mNode2.Nodes.Add( Tmp );

					mNode1.Nodes.Add( mNode2 );
				}

				mNode.Nodes.Add( mNode1 );
			}

			if( PDns.AuthorityRRS > 0 )
			{
				mNode1 = new TreeNode();
				mNode1.Text = "AUTHORITY RECORDS";

				for( i = 1; i <= PDns.AuthorityRRS; i ++ )
				{
					mNode2 = new TreeNode();
					mNode2.Text = "Authority Record " + i.ToString();

					Tmp = "Name :" + PDns.AuthorityObject[i-1].Name;
					mNode2.Nodes.Add( Tmp );

					Tmp = "Type : " + Function.ReFormatString( PDns.AuthorityObject[i-1].Type , PDns.AuthorityObject[i-1].TypeStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Class : " + Function.ReFormatString( PDns.AuthorityObject[i-1].Class , PDns.AuthorityObject[i-1].ClassStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Time to Live : " + Function.ReFormatString( PDns.AuthorityObject[i-1].TimeToLive , null );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Data Length : " + Function.ReFormatString( PDns.AuthorityObject[i-1].DataLength , null );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Primary Name Server : " + PDns.AuthorityObject[i-1].PrimaryNameServer;
					mNode2.Nodes.Add( Tmp );

					Tmp = "Responsible Authority's Mailbox : " + PDns.AuthorityObject[i-1].ResponsibleAuthoritysMailBox;
					mNode2.Nodes.Add( Tmp );

					Tmp = "Serial Number : " + Function.ReFormatString( PDns.AuthorityObject[i-1].SerialNumber , null );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Refresh Interval : " + Function.ReFormatString( PDns.AuthorityObject[i-1].RefreshInterval , null );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Retry Interval : " + Function.ReFormatString( PDns.AuthorityObject[i-1].RetryInterval , null );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Expiration Limit : " + Function.ReFormatString( PDns.AuthorityObject[i-1].ExpirationLimit , null );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Minimum TTL : " + Function.ReFormatString( PDns.AuthorityObject[i-1].MinimumTTL , null );
					mNode2.Nodes.Add( Tmp );

					mNode1.Nodes.Add( mNode2 );

				}

				mNode.Nodes.Add( mNode1 );
			}

			if( PDns.AdditionalRRS > 0 )
			{
				mNode1 = new TreeNode();
				mNode1.Text = "Additional Records";

				for( i = 1; i <= PDns.AdditionalRRS; i ++ )
				{
					mNode2 = new TreeNode();
					mNode2.Text = "Additional Record " + i.ToString();

					Tmp = "Name :" + PDns.AdditionalObject[i-1].Name;
					mNode2.Nodes.Add( Tmp );

					Tmp = "Type : " + Function.ReFormatString( PDns.AdditionalObject[i-1].Type , PDns.AdditionalObject[i-1].TypeStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Class : " + Function.ReFormatString( PDns.AdditionalObject[i-1].Class , PDns.AdditionalObject[i-1].ClassStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Time to Live : " + Function.ReFormatString( PDns.AdditionalObject[i-1].TimeToLive , PDns.AdditionalObject[i-1].TimeToLiveStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Data Length : " + Function.ReFormatString( PDns.AdditionalObject[i-1].DataLength , null );
					mNode2.Nodes.Add( Tmp );

					mNode2 = new TreeNode();
					mNode2.Text = "Flags :" + Function.ReFormatString( PDns.AdditionalObject[i-1].Flags , null );
					for( i = 0; i < 2; i ++ )
						mNode2.Nodes.Add( Flags2Array[ i ] );
					mNode1.Nodes.Add( mNode2 );

					Tmp = "Flags : " + Function.ReFormatString( PDns.AdditionalObject[i-1].Class , PDns.AdditionalObject[i-1].ClassStr );
					mNode2.Nodes.Add( Tmp );

					Tmp = "Address : " + Function.ReFormatString( PDns.AdditionalObject[i-1].Address , PDns.AdditionalObject[i-1].AddressStr );
					mNode2.Nodes.Add( Tmp );

					mNode1.Nodes.Add( mNode2 );

				}

				mNode.Nodes.Add( mNode1 );
			}

			return mNode;

		}

		public PACKET_DNS GetDNSPart( byte [] PacketData , ref int Index )
		{
			int i = 0;

			PDns.TransactionId = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
			PDns.Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
			PDns.Questions = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
			PDns.AnswerRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
			PDns.AuthorityRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
			PDns.AdditionalRRS = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

			if( PDns.Questions > 0 )
			{
				PDns.QuestionObject = new QUESTION_ITEM[ PDns.Questions ];
				for( i = 0; i < PDns.Questions; i ++ )
				{
					PDns.QuestionObject[i].Name = "";
					while( PacketData[ Index ] != 0 )
						PDns.QuestionObject[i].Name += (char) PacketData[ Index ++ ];

					Index ++;
					PDns.QuestionObject[i].Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.QuestionObject[i].TypeStr = GetTypeString( PDns.QuestionObject[i].Type );

					PDns.QuestionObject[i].Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.QuestionObject[i].ClassStr = GetClassString( PDns.QuestionObject[i].Class );
				}
			}

			if( PDns.AnswerRRS > 0 )
			{
				PDns.AnswerObject = new ANSWER_ITEM[ PDns.AnswerRRS ];
				for( i = 0; i < PDns.AnswerRRS; i ++ )
				{
					PDns.AnswerObject[i].Name = "";
					while( PacketData[ Index ] != 0 )
						PDns.AnswerObject[i].Name += (char) PacketData[ Index ++ ];

					Index ++;
					PDns.AnswerObject[i].Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AnswerObject[i].TypeStr = GetTypeString( PDns.AnswerObject[i].Type );

					PDns.AnswerObject[i].Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AnswerObject[i].ClassStr = GetClassString( PDns.AnswerObject[i].Class );

					PDns.AnswerObject[i].TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
					PDns.AnswerObject[i].DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

					PDns.AnswerObject[i].IpAddress = "";
					PDns.AnswerObject[i].IpAddress += PacketData[ Index ++ ].ToString() + ".";
					PDns.AnswerObject[i].IpAddress += PacketData[ Index ++ ].ToString() + ".";
					PDns.AnswerObject[i].IpAddress += PacketData[ Index ++ ].ToString() + ".";
					PDns.AnswerObject[i].IpAddress += PacketData[ Index ++ ].ToString();

				}
			}

			if( PDns.AuthorityRRS > 0 )
			{
				PDns.AuthorityObject = new AUTHORITY_ITEM[ PDns.AuthorityRRS ];
				for( i = 0; i < PDns.AuthorityRRS; i ++ )
				{
					PDns.AuthorityObject[i].Name = "";
					while( PacketData[ Index ] != 0 )
						PDns.AuthorityObject[i].Name += (char) PacketData[ Index ++ ];

					Index ++;
					PDns.AuthorityObject[i].Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AuthorityObject[i].TypeStr = GetTypeString( PDns.AuthorityObject[i].Type );

					PDns.AuthorityObject[i].Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AuthorityObject[i].ClassStr = GetClassString( PDns.AuthorityObject[i].Class );

					PDns.AuthorityObject[i].TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AuthorityObject[i].DataLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );

					PDns.AuthorityObject[i].PrimaryNameServer = "";
					while( PacketData[ Index ] != 0 )
						PDns.AuthorityObject[i].PrimaryNameServer += (char) PacketData[ Index ++ ];

					PDns.AuthorityObject[i].ResponsibleAuthoritysMailBox = "";
					while( PacketData[ Index ] != 0 )
						PDns.AuthorityObject[i].ResponsibleAuthoritysMailBox += (char) PacketData[ Index ++ ];

					PDns.AuthorityObject[i].SerialNumber = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AuthorityObject[i].RefreshInterval = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AuthorityObject[i].RetryInterval = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AuthorityObject[i].ExpirationLimit = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AuthorityObject[i].MinimumTTL = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );

				}
			}

			if( PDns.AdditionalRRS > 0 )
			{
				PDns.AdditionalObject = new ADDITIONAL_ITEM[ PDns.AdditionalRRS ];
				for( i = 0; i < PDns.AdditionalRRS; i ++ )
				{
					PDns.AdditionalObject [i].Name = "";
					while( PacketData[ Index ] != 0 )
						PDns.AdditionalObject[i].Name += (char) PacketData[ Index ++ ];

					Index ++;
					PDns.AdditionalObject[i].Type = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AdditionalObject[i].TypeStr = GetTypeString( PDns.AdditionalObject[i].Type );

					PDns.AdditionalObject[i].Class = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AdditionalObject[i].ClassStr = GetClassString( PDns.AdditionalObject[i].Class );

					PDns.AdditionalObject[i].TimeToLive = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
					PDns.AdditionalObject[i].TimeToLiveStr = PDns.AdditionalObject[i].TimeToLive.ToString() + " sn";

					PDns.AdditionalObject[i].Flags = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					PDns.AdditionalObject[i].FlagsStr = "";

					PDns.AdditionalObject[i].Address = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
					Index -= 4;
					PDns.AdditionalObject[i].AddressStr = "";
					PDns.AdditionalObject[i].AddressStr += (char) PacketData[ Index ++ ] + ".";
					PDns.AdditionalObject[i].AddressStr += (char) PacketData[ Index ++ ] + ".";
					PDns.AdditionalObject[i].AddressStr += (char) PacketData[ Index ++ ] + ".";
					PDns.AdditionalObject[i].AddressStr += (char) PacketData[ Index ++ ];

				}
			}

			return PDns;
		}


	}
}
