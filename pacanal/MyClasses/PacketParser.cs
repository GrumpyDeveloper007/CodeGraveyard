using System;
using System.Windows.Forms;
using System.Collections;
using System.IO;
using System.Runtime.InteropServices;

namespace MyClasses
{

	public class PacketParser
	{

		public struct PACKET_ITEM
		{
			public uint Seconds;         // seconds 
			public uint MicroSeconds;        // and microseconds 
			public uint CaptureLength;	// length of portion present
			public string CaptureTimeStr;
			public uint PacketLength;	// length this packet (off wire)
			public uint Reserved;
			public string TypeInfo;
			public byte [] FrameData;
			public byte [] Data;

		}

		public struct PACKET_STATISTIC
		{
			public int Count;
			public string CaptureTimeStr;
			public int CaptureLength;
		}

		public ArrayList PacketCollection;
		public ListView LVw;
		public TreeNodeCollection mNode;
		public RichTextBox Rtx;
		public byte [] PacketBufferData;
		public bool StopCapture;
		public bool PacketOnOff;
		public Packet32.CAPTURE_OPTIONS mCaptureOptions;
		public Packet32.DISPLAY_OPTIONS mDisplayOptions;
		public int CurrentPacketBufferDataIndex;
		public PACKET_ITEM PItem;
		private ulong FirstSeconds = 0;
		private ulong FirstMiliSeconds = 0;
		private ulong FirstLongValue = 0;
		public uint PreviousHttpSequence = 0;
		public ushort LastTftpPort;


		public PacketParser()
		{
			PacketCollection = new ArrayList();
		}

		public static int Packet_WORDALIGN( int x )
		{ return ( int) ( ((x) + (Const.PACKET_ALIGNMENT - 1))&~(Const.PACKET_ALIGNMENT - 1) ); }

		public void Parse()
		{
			if( PacketOnOff )
				ParseOn();
			else 
			{
				LVw.Items.Clear();
				mNode.Clear();
				Rtx.Text = "";

				ParseOff();
			}
		}

		private void ParseOn()
		{
			int ByteOffset = 0; //, i = 0;
			int CurrentIndex = 0;
			bool UseThisPacket = false;
			uint tu = 0, tl = 0;
			bool IsMessageShowed = false;
			ulong LongVal1 = 0, LongVal2 = 0, TmpValue = 0;
			ListViewItem LItem;
			int ListViewIndex = 0;
			int PacketItemIndex = PacketCollection.Count;

			CurrentIndex = 0;

			do
			{
				if( StopCapture )
				{
					if( !IsMessageShowed )
					{
						if( MessageBox.Show("There are packet to be edited. Stop after processing packets in quiue ?", "Confirmations" , MessageBoxButtons.YesNo ) == DialogResult.No )
							break;

						IsMessageShowed = true;
					}

				}

				UseThisPacket = false;
				if( mCaptureOptions.LimitPackets )
				{
					if ( PItem.CaptureLength > mCaptureOptions.PacketSize )
						UseThisPacket = false;
					else
						UseThisPacket = true;
				}
				else
					UseThisPacket = true;

				if( UseThisPacket )
				{
					LItem = LVw.Items.Add( ListViewIndex.ToString() );
					LItem.Text = PacketItemIndex.ToString(); // SubItems 0 - No
					LItem.SubItems.Add(""); // SubItems 1 - Time
					LItem.SubItems.Add(""); // SubItems 2 - Source
					LItem.SubItems.Add(""); // SubItems 3 - Destination
					LItem.SubItems.Add(""); // SubItems 4 - Protocol
					LItem.SubItems.Add(""); // SubItems 5 - Info
					ListViewIndex = LVw.Items.Count - 1;
				
					if( mDisplayOptions.UpdateListInRealTime )
					{
						LVw.EnsureVisible( ListViewIndex );
					}

					FRAMEParser( PacketBufferData , ref CurrentIndex , ref LItem ); 

					if( PacketCollection.Count == 0 )
					{
						FirstSeconds = PItem.Seconds;
						FirstMiliSeconds = PItem.MicroSeconds;
						FirstLongValue = ( ulong ) FirstSeconds;
						FirstLongValue *= 1000000;
						FirstLongValue += FirstMiliSeconds;
						PItem.CaptureTimeStr = "0.000000";
						LItem.SubItems[1].Text = PItem.CaptureTimeStr;
					}
					else
					{
						LongVal1 = ( ulong ) PItem.Seconds;
						LongVal1 *= 1000000;
						LongVal1 += ( ulong ) PItem.MicroSeconds;
						LongVal2 = LongVal1 - FirstLongValue;
						TmpValue = LongVal2 / 1000000;
						tu = ( uint ) TmpValue;
						TmpValue *= 1000000;
						TmpValue = LongVal2 - TmpValue;
						tl = ( uint ) TmpValue;
						PItem.CaptureTimeStr = tu.ToString() + "." + tl.ToString("d6");
						LItem.SubItems[1].Text = PItem.CaptureTimeStr;
					}

					PItem.TypeInfo = "Other";
					PacketETHERNET.Parser( PItem.Data , ref LItem, ref PItem.TypeInfo , ref PreviousHttpSequence , ref LastTftpPort);

					PacketCollection.Add( PItem );
					PacketItemIndex = PacketCollection.Count;
						
				}

			
				ByteOffset = 20 + (int) PItem.CaptureLength;
				ByteOffset = Packet_WORDALIGN( ByteOffset );
				ByteOffset -= ( 20 + (int) PItem.CaptureLength );
				CurrentIndex += ByteOffset;

			}while( CurrentIndex < PacketBufferData.Length );

		}

		public void ParseOff()
		{
			int CurrentIndex = 0;
			uint tu = 0, tl = 0;
			ulong LongVal1 = 0, LongVal2 = 0, TmpValue = 0;
			ListViewItem LItem;
			int ListViewIndex = 0;

			PacketCollection.Clear();
			LVw.Items.Clear();
			int PacketItemIndex = PacketCollection.Count;
			CurrentIndex = 0;

			do
			{

				LItem = LVw.Items.Add( ListViewIndex.ToString() );
				LItem.Text = PacketItemIndex.ToString(); // SubItems 0 - No
				LItem.SubItems.Add(""); // SubItems 1 - Time
				LItem.SubItems.Add(""); // SubItems 2 - Source
				LItem.SubItems.Add(""); // SubItems 3 - Destination
				LItem.SubItems.Add(""); // SubItems 4 - Protocol
				LItem.SubItems.Add(""); // SubItems 5 - Info
				ListViewIndex = LVw.Items.Count - 1;

				FRAMEParser( PacketBufferData , ref CurrentIndex , ref LItem ); 

				if( mDisplayOptions.UpdateListInRealTime )
				{
					LVw.EnsureVisible( ListViewIndex );
				}

				if( PacketCollection.Count == 0 )
				{
					FirstSeconds = PItem.Seconds;
					FirstMiliSeconds = PItem.MicroSeconds;
					FirstLongValue = ( ulong ) FirstSeconds;
					FirstLongValue *= 1000000;
					FirstLongValue += FirstMiliSeconds;
					PItem.CaptureTimeStr = "0.000000";
					LItem.SubItems[1].Text = PItem.CaptureTimeStr;
				}
				else
				{
					LongVal1 = ( ulong ) PItem.Seconds;
					LongVal1 *= 1000000;
					LongVal1 += ( ulong ) PItem.MicroSeconds;
					LongVal2 = LongVal1 - FirstLongValue;
					TmpValue = LongVal2 / 1000000;
					tu = ( uint ) TmpValue;
					TmpValue *= 1000000;
					TmpValue = LongVal2 - TmpValue;
					tl = ( uint ) TmpValue;
					PItem.CaptureTimeStr = tu.ToString() + "." + tl.ToString("d6");
					LItem.SubItems[1].Text = PItem.CaptureTimeStr;
				}

				PItem.TypeInfo = "Other";

				PacketETHERNET.Parser( PItem.Data , ref LItem, ref PItem.TypeInfo , ref PreviousHttpSequence , ref LastTftpPort );
				ListViewIndex ++;

				PacketCollection.Add( PItem );
				PacketItemIndex = PacketCollection.Count;
						
			}while( CurrentIndex < PacketBufferData.Length );

		}

		public bool WriteFRAMENode( ref TreeNodeCollection mNode , PACKET_ITEM PItem , ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";

			mNode.Clear();

			mNodex = new TreeNode();
	
			try
			{
				Tmp = " Seconds : " + PItem.Seconds.ToString();
				mNodex.Nodes.Add( Tmp );
				Tmp = " Microseconds : " + PItem.MicroSeconds.ToString();
				mNodex.Nodes.Add( Tmp );
				Tmp = " Captured Length : " + PItem.CaptureLength.ToString();
				mNodex.Nodes.Add( Tmp );
				Tmp = " Packet Length : " + PItem.PacketLength.ToString();
				mNodex.Nodes.Add( Tmp );
				Tmp = "FRAME ( Captured : " + PItem.CaptureLength.ToString() +
					" , Original : " + PItem.PacketLength.ToString() + " )";
				mNodex.Text = Tmp;
				mNodex.Tag = "0," + PItem.CaptureLength.ToString();
				mNode.Add( mNodex );

			}
			catch
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed FRAME packet. Remaining bytes don't fit an FRAME packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed FRAME packet. Remaining bytes don't fit an FRAME packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public void ParseSingle( ref ListViewItem LItem )
		{
			PACKET_ITEM PItem;
		
			if( PacketCollection == null ) return;
			if( PacketCollection.Count == 0 ) return;

			PItem = ( PACKET_ITEM ) PacketCollection[ Function.FindListIndex( LItem ) ];

			Rtx.Text = "";
			Rtx.AppendText( Function.GetHexString( PItem.Data ) );
			WriteFRAMENode( ref mNode , PItem , ref LItem );
			PacketETHERNET.Parser( ref mNode , PItem.Data , ref LItem , ref PreviousHttpSequence , ref LastTftpPort );
			Function.ArrangeText( ref mNode , ":" );

		}

		public bool FRAMEParser( ref TreeNodeCollection mNode , byte [] PacketData , ref int Index , ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			int i = 0;

			mNode.Clear();

			mNodex = new TreeNode();
	
			try
			{
				PItem.Seconds = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = " Seconds : " + PItem.Seconds.ToString();
				mNodex.Nodes.Add( Tmp );

				PItem.MicroSeconds = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = " Microseconds : " + PItem.MicroSeconds.ToString();
				mNodex.Nodes.Add( Tmp );

				PItem.CaptureLength = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = " Captured Length : " + PItem.CaptureLength.ToString();
				mNodex.Nodes.Add( Tmp );

				PItem.PacketLength = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = " Packet Length : " + PItem.PacketLength.ToString();
				mNodex.Nodes.Add( Tmp );

				PItem.Reserved = 0;
				if( PacketOnOff )
					PItem.Reserved = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );

				Tmp = "FRAME ( Captured : " + PItem.CaptureLength.ToString() +
					" , Original : " + PItem.PacketLength.ToString() + " )";
				mNodex.Text = Tmp;
				mNodex.Tag = "0," + PItem.CaptureLength.ToString();

				PItem.CaptureTimeStr = "";

				if( !PacketOnOff )
				{
					Index -= 16;
					PItem.FrameData = new byte[16];
					for( i = 0; i < 16; i ++ )
						PItem.FrameData[i] = PacketData[ Index ++ ];
				}
				else
				{
					Index -= 20;
					PItem.FrameData = new byte[20];
					for( i = 0; i < 20; i ++ )
						PItem.FrameData[i] = PacketData[ Index ++ ];
				}

				PItem.Data = new byte[ PItem.CaptureLength ];

				for( i = 0; i < PItem.CaptureLength; i ++ )
					PItem.Data[i] = PacketData[ Index++ ];

				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Fram Data";

				mNode.Add( mNodex );

			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed FRAME packet. Remaining bytes don't fit an FRAME packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed FRAME packet. Remaining bytes don't fit an FRAME packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public bool FRAMEParser( byte [] PacketData , ref int Index , ref ListViewItem LItem )
		{
			int i = 0;

			try
			{
				PItem.Seconds = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				PItem.MicroSeconds = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				PItem.CaptureLength = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );
				PItem.PacketLength = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );

				PItem.Reserved = 0;
				if( PacketOnOff )
					PItem.Reserved = Function.Get4Bytes( PacketData , ref Index , Const.VALUE );

				PItem.CaptureTimeStr = "";

				if( !PacketOnOff )
				{
					Index -= 16;
					PItem.FrameData = new byte[16];
					for( i = 0; i < 16; i ++ )
						PItem.FrameData[i] = PacketData[ Index ++ ];
				}
				else
				{
					Index -= 20;
					PItem.FrameData = new byte[20];
					for( i = 0; i < 20; i ++ )
						PItem.FrameData[i] = PacketData[ Index ++ ];
				}

				PItem.Data = new byte[ PItem.CaptureLength ];

				for( i = 0; i < PItem.CaptureLength; i ++ )
					PItem.Data[i] = PacketData[ Index++ ];

				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Fram Data";

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed FRAME packet. Remaining bytes don't fit an FRAME packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public string ReadManufacturer( string Srch )
		{
			StreamReader Sr = new StreamReader("WellKnown.txt");
			string str = "", str2 = "", str3 = "" , str4 = "";
			int FirstPos = 0;

			while( Sr.Peek() != -1 )
			{
				str = Sr.ReadLine();
				if( str.IndexOf( Srch ) >= 0 )
				{
					FirstPos = Srch.Length;
					str2 = str.Substring( FirstPos , str.Length - FirstPos );
					Sr.Close();
					return str2;
				}
			}

			Sr.Close();

			if( str2 == "" )
			{
				str3 = Srch.Substring( 0 , 8 );
				str4 = Srch.Substring( 9 , 8 );
				Sr = new StreamReader("Manufacturers.txt");

				while( Sr.Peek() != -1 )
				{
					str = Sr.ReadLine();
					if( str.IndexOf( str3 ) >= 0 )
					{
						FirstPos = str.IndexOf("#");
						if( FirstPos > 0 ) FirstPos -= 9;
						else FirstPos = str.Length - 9;
						str2 = str.Substring( 9 , FirstPos );
						str2 += "_" + str4;
						Sr.Close();
						return str2;
					}
				}
			}

			Sr.Close();

			str2 = Srch;

			return str2;
		}

	}
}
