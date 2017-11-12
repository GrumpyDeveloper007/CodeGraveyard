using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketTFTP
	{

		public struct PACKET_TFTP
		{
			public ushort OpCode;
			public ushort Bytes;
			public ushort ErrorNo;
			public ushort BlockNo;
			public string ErrorMessage;
			public string SourceFile;
			public string DestinationFile;
			public string TransferType;
		}

		public PacketTFTP()
		{
		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			int kk = 0;
			PACKET_TFTP PTftp;
			string ColumnInfo = "";
			string OptionName = "", OptionValue = "";

			mNodex = new TreeNode();
			mNodex.Text = "TFTP ( Trivial File Transfer Protocol )";
			kk = Index;
	
			try
			{
				PTftp.OpCode = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Operation Code : " + Function.ReFormatString( PTftp.OpCode , Const.GetTftpOpCodeString( PTftp.OpCode ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				ColumnInfo = Const.GetTftpOpCodeString( PTftp.OpCode );

				switch( PTftp.OpCode )
				{
					case Const.TFTP_RRQ	:
						PTftp.SourceFile = Function.FindString( PacketData , ref Index );
						Tmp = "Source File Name : " + PTftp.SourceFile;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - PTftp.SourceFile.Length - 1 , PTftp.SourceFile.Length + 1 , false );
						
						ColumnInfo += ", Source File Name : " + PTftp.SourceFile;

						PTftp.TransferType = Function.FindString( PacketData , ref Index );
						Tmp = "Transfer Type : " + PTftp.TransferType;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - PTftp.TransferType.Length - 1 , PTftp.TransferType.Length + 1 , false );
						
						ColumnInfo += ", Transfer Type : " + PTftp.TransferType;

						while( Index < PacketData.Length )
						{
							OptionName = Function.FindString( PacketData , ref Index );
							OptionValue = Function.FindString( PacketData , ref Index );
							Tmp = "Option : " + OptionName + " = " + OptionValue;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - OptionName.Length - 1 - OptionValue.Length - 1 , OptionName.Length + 1 + OptionValue.Length + 1 , false );
							
							ColumnInfo += ", " + Tmp;
						}
						break;

					case Const.TFTP_WRQ	:
						PTftp.DestinationFile = Function.FindString( PacketData , ref Index );
						Tmp = "Destination File Name : " + PTftp.DestinationFile;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - PTftp.DestinationFile.Length - 1 , PTftp.DestinationFile.Length + 1 , false );
						
						ColumnInfo += ", Destination File Name : " + PTftp.DestinationFile;

						PTftp.TransferType = Function.FindString( PacketData , ref Index );
						Tmp = "Transfer Type : " + PTftp.TransferType;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - PTftp.TransferType.Length - 1 , PTftp.TransferType.Length + 1 , false );
						
						ColumnInfo += ", Transfer Type : " + PTftp.TransferType;

						while( Index < PacketData.Length )
						{
							OptionName = Function.FindString( PacketData , ref Index );
							OptionValue = Function.FindString( PacketData , ref Index );
							Tmp = "Option : " + OptionName + " = " + OptionValue;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - OptionName.Length - 1 - OptionValue.Length - 1 , OptionName.Length + 1 + OptionValue.Length + 1 , false );
							
							ColumnInfo += ", " + Tmp;

						}
						break;

					case Const.TFTP_DATA	:
						PTftp.BlockNo = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Block No : " + Function.ReFormatString( PTftp.BlockNo , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
						ColumnInfo += ", Block " + PTftp.BlockNo.ToString();

						PTftp.Bytes = (ushort) ( PacketData.Length - Index );
						Tmp = "Data : " + Function.ReFormatString( PTftp.Bytes , null ) + " bytes(s)";
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index , PTftp.Bytes , false );
						
						if( PTftp.Bytes < 512 ) 
							ColumnInfo += " ( Last )";

						break;

					case Const.TFTP_ACK	:
						PTftp.BlockNo = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Block No : " + Function.ReFormatString( PTftp.BlockNo , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						ColumnInfo += ", Block " + PTftp.BlockNo.ToString();
						break;

					case Const.TFTP_ERROR	:
						PTftp.ErrorNo = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Error No : " + Function.ReFormatString( PTftp.ErrorNo , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						ColumnInfo += ", Error No : " + PTftp.ErrorNo.ToString();

						PTftp.ErrorMessage = Function.FindString( PacketData , ref Index );
						Tmp = "Error Message : " + PTftp.ErrorMessage;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - PTftp.ErrorMessage.Length - 1 , PTftp.ErrorMessage.Length + 1 , false );
						
						ColumnInfo += ", ErrorMessage : " + PTftp.ErrorMessage;
						break;

					case Const.TFTP_OACK	:
						while( Index < PacketData.Length )
						{
							OptionName = Function.FindString( PacketData , ref Index );
							OptionValue = Function.FindString( PacketData , ref Index );
							Tmp = "Option : " + OptionName + " = " + OptionValue;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - OptionName.Length - 1 - OptionValue.Length - 1 , OptionName.Length + 1 + OptionValue.Length + 1 , false );
							
							ColumnInfo += ", " + Tmp;

						}
						break;

					default :
						PTftp.Bytes = (ushort) ( PacketData.Length - Index );
						Tmp = "Data : " + Function.ReFormatString( PTftp.Bytes , " bytes(s)" );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index , PTftp.Bytes , false );
						
						break;

				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "TFTP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = ColumnInfo;

				Function.SetPosition( ref mNodex , kk , Index - kk , true );
				mNode.Add( mNodex );


			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed TFTP packet. Remaining bytes don't fit an TFTP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed TFTP packet. Remaining bytes don't fit an TFTP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			PACKET_TFTP PTftp;
			string ColumnInfo = "";

			try
			{
				PTftp.OpCode = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				ColumnInfo = Const.GetTftpOpCodeString( PTftp.OpCode );

				switch( PTftp.OpCode )
				{
					case Const.TFTP_RRQ	:
						PTftp.SourceFile = Function.FindString( PacketData , ref Index );
						ColumnInfo += ", Source File Name : " + PTftp.SourceFile;
						PTftp.TransferType = Function.FindString( PacketData , ref Index );
						ColumnInfo += ", Transfer Type : " + PTftp.TransferType;

						break;

					case Const.TFTP_WRQ	:
						PTftp.DestinationFile = Function.FindString( PacketData , ref Index );
						ColumnInfo += ", Destination File Name : " + PTftp.DestinationFile;

						PTftp.TransferType = Function.FindString( PacketData , ref Index );
						ColumnInfo += ", Transfer Type : " + PTftp.TransferType;

						break;

					case Const.TFTP_DATA	:
						PTftp.BlockNo = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						ColumnInfo += ", Block " + PTftp.BlockNo.ToString();

						PTftp.Bytes = (ushort) ( PacketData.Length - Index );
						if( PTftp.Bytes < 512 ) 
							ColumnInfo += " ( Last )";

						break;

					case Const.TFTP_ACK	:
						PTftp.BlockNo = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						ColumnInfo += ", Block " + PTftp.BlockNo.ToString();
						break;

					case Const.TFTP_ERROR	:
						PTftp.ErrorNo = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						ColumnInfo += ", Error No : " + PTftp.ErrorNo.ToString();

						PTftp.ErrorMessage = Function.FindString( PacketData , ref Index );
						ColumnInfo += ", ErrorMessage : " + PTftp.ErrorMessage;
						break;

					case Const.TFTP_OACK	:
						break;

					default :
						PTftp.Bytes = (ushort) ( PacketData.Length - Index );
						break;

				}

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "TFTP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = ColumnInfo;

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed TFTP packet. Remaining bytes don't fit an TFTP packet. Possibly due to bad decoding ]";
				return false;
			}

			return true;

		}

	}
}
