using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketNBSS
	{

		public struct PACKET_NBSS
		{
			public byte MessageType;
			public byte Flags;
			public uint Length;
			public byte ErrorCode;
			public string ReTargetIpAddress;
			public ushort ReTargetPort;
			public string CalledName; // char 20 + str + null
			public byte CalledNameNumber;
			public string CallingName; // char 20 + str + null
			public byte CallingNameNumber;
			public object NextPacket;
		}

		public static string GetMessageTypeString( byte b )
		{
			int i = 0;
			string [] MessageTypeList = new string[256];

			for( i = 0; i < 256; i ++ )
				MessageTypeList[i] = "Unknown";

			MessageTypeList[Const.SESSION_MESSAGE] = "Session message";
			MessageTypeList[Const.SESSION_REQUEST] = "Session request";
			MessageTypeList[Const.POSITIVE_SESSION_RESPONSE] = "Positive session response";
			MessageTypeList[Const.NEGATIVE_SESSION_RESPONSE] = "Negative session response";
			MessageTypeList[Const.RETARGET_SESSION_RESPONSE] = "Retarget session response";
			MessageTypeList[Const.SESSION_KEEP_ALIVE] = "Session keep-alive";

			return MessageTypeList[ b ];
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

			if( b < 0x80 ) return "Invalid Error Code !!!";

			return ErrorCodeList[ b - 0x80 ];
		}


		public PacketNBSS()
		{
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem,
			bool IsCifs )
		{
			TreeNode mNodex;
			TreeNode mNode1;
			string Tmp = "";
			int kk = 0;
			byte NNumber = 0;
			PACKET_NBSS PNbss;

			mNodex = new TreeNode();
			mNodex.Text = "NBSS ( Netbios Session Service )";
			kk = Index;
	
			try
			{
				if( Index >= PacketData.Length )
				{
					Tmp = "Continuation message";
					mNodex.Nodes.Add( Tmp );
					LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NBSS";
					LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
					mNode.Add( mNodex );
				}
				else
				{
					PNbss.MessageType = PacketData[ Index++ ];
					Tmp = "Message Type :" + Function.ReFormatString( PNbss.MessageType , GetMessageTypeString( PNbss.MessageType ) );
					mNodex.Nodes.Add( Tmp );
					Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

					if( IsCifs )
					{
						PNbss.Flags = 0;
						mNode1 = new TreeNode();
						Tmp = "Flags        :" + Function.ReFormatString( PNbss.Flags , null );
						mNode1.Text = Tmp;
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , true );
						mNode1.Nodes.Add( Function.DecodeBitField( PNbss.Flags , 0x1 ,"Add 65536 to length" , "Add 0 to length" ) );
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
						mNodex.Nodes.Add( mNode1 );
						Index ++;

						PNbss.Length = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Length       :" + Function.ReFormatString( PNbss.Length , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

					}
					else
					{
						PNbss.Flags = PacketData[ Index ++ ];
						mNode1 = new TreeNode();
						Tmp = "Flags        :" + Function.ReFormatString( PNbss.Flags , null );
						mNode1.Text = Tmp;
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , true );
						mNode1.Nodes.Add( Function.DecodeBitField( PNbss.Flags , 0x1 ,"Add 65536 to length" , "Add 0 to length" ) );
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
						mNodex.Nodes.Add( mNode1 );

						PNbss.Length = (uint) Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						if( ( PNbss.Flags & Const.NBSS_FLAGS_E ) > 0 )
							PNbss.Length += 65536;
						Tmp = "Length       :" + Function.ReFormatString( PNbss.Length , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

					}

					if( ( PNbss.Flags & ( ~ Const.NBSS_FLAGS_E ) ) != 0 ) 
					{
						// A bogus flag was set; assume it's a continuation.
						Tmp = "Continuation Message";
						mNodex.Nodes.Add( Tmp );
						LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
						goto LabelMe;
					}


					switch( PNbss.MessageType )
					{

						case Const.SESSION_REQUEST:

							if( ( PNbss.Length < 2 ) || ( PNbss.Length > 256 ) )
							{
								Tmp = "Continuation Message";
								mNodex.Nodes.Add( Tmp );
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
								goto LabelMe;
							}

							PNbss.CalledName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
							Tmp = "Called Name :" + PNbss.CalledName + " ( " + Const.GetNetBiosNames( NNumber ) + " )";
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 34 , 34 , false );

							PNbss.CallingName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
							Tmp = "Calling Name :" + PNbss.CallingName + " ( " + Const.GetNetBiosNames( NNumber ) + " )";
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 34 , 34 , false );
							break;

						case Const.POSITIVE_SESSION_RESPONSE:

							if( PNbss.Length != 0 )
							{
								Tmp = "Continuation Message";
								mNodex.Nodes.Add( Tmp );
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
								goto LabelMe;
							}
							break;

						case Const.NEGATIVE_SESSION_RESPONSE:

							if( PNbss.Length != 1 )
							{
								Tmp = "Continuation Message";
								mNodex.Nodes.Add( Tmp );
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
								goto LabelMe;
							}

							PNbss.ErrorCode = PacketData[ Index ++ ];
							Tmp = "Error Code       :" + Function.ReFormatString( PNbss.ErrorCode , GetErrorCodeString( PNbss.ErrorCode ) );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
							break;

						case Const.SESSION_KEEP_ALIVE :

							if( PNbss.Length != 0 )
							{
								Tmp = "Continuation Message";
								mNodex.Nodes.Add( Tmp );
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
								goto LabelMe;
							}

							break;

						case Const.RETARGET_SESSION_RESPONSE:

							if( PNbss.Length != 6 )
							{
								Tmp = "Continuation Message";
								mNodex.Nodes.Add( Tmp );
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
								goto LabelMe;
							}

							PNbss.ReTargetIpAddress = Function.GetIpAddress( PacketData , ref Index );
							Tmp = "Retarget Ip Address :" + PNbss.ReTargetIpAddress;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 4 , 4 , false );

							PNbss.ReTargetPort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
							Tmp = "Retarget Port :" + Function.ReFormatString( PNbss.ReTargetPort , Const.GetPortStr( PNbss.ReTargetPort ) );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

							break;

						case Const.SESSION_MESSAGE:

							if( PNbss.Length == 0 ) 
							{
								Tmp = "Continuation Message";
								mNodex.Nodes.Add( Tmp );
								LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
								goto LabelMe;
							}

							break;

					}

				LabelMe:;

					Function.SetPosition( ref mNodex , kk , Index - kk , true );

					mNode.Add( mNodex );

					LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NBSS";

					if( PNbss.MessageType == Const.SESSION_MESSAGE )
					{
						if( ( Index + 4 ) < PacketData.Length )
						{
							if( ( PacketData[ Index  ] == 0xff ) &&
								( PacketData[ Index + 1 ] == 0x53 ) &&
								( PacketData[ Index + 2 ] == 0x4d ) &&
								( PacketData[ Index + 3 ] == 0x42 ) )
							{
								PacketSMB.Parser( ref mNode , PacketData , ref Index , ref LItem );
							}
						}
					}

				}

			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed NBSS packet. Remaining bytes don't fit an NBSS packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed NBSS packet. Remaining bytes don't fit an NBSS packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem,
			bool IsCifs )
		{
			byte NNumber = 0;
			PACKET_NBSS PNbss;

			try
			{
				if( Index >= PacketData.Length )
				{
					LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NBSS";
					LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Continuation message";
					return true;
				}

				PNbss.MessageType = PacketData[ Index++ ];

				if( IsCifs )
				{
					PNbss.Flags = 0;
					PNbss.Length = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				}
				else
				{
					PNbss.Flags = PacketData[ Index ++ ];
					PNbss.Length = (uint) Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					if( ( PNbss.Flags & Const.NBSS_FLAGS_E ) > 0 )
						PNbss.Length += 65536;
				}


				switch( PNbss.MessageType )
				{

					case Const.SESSION_REQUEST:
						PNbss.CalledName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						PNbss.CallingName = Function.GetNetBiosName( PacketData , ref Index , ref NNumber );
						break;

					case Const.NEGATIVE_SESSION_RESPONSE:
						PNbss.ErrorCode = PacketData[ Index ++ ];
						break;

					case Const.RETARGET_SESSION_RESPONSE:
						PNbss.ReTargetIpAddress = Function.GetIpAddress( PacketData , ref Index );
						PNbss.ReTargetPort = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						break;

					case Const.SESSION_MESSAGE:
						break;

				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NBSS";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Netbios session service";

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed NBSS packet. Remaining bytes don't fit an NBSS packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
