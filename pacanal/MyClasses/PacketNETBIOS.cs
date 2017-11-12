using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketNETBIOS
	{


		public struct PACKET_NETBIOS
		{
			public ushort Length;
			public ushort Delimeter;
			public string DelimeterStr;
			public byte Command;
			public string CommandStr;

			public ushort ResponseCorrelator;
			public string NameToAdd;

			public string ReceiversName;
			public string SendersName;

			public string NameInConflict;
			public string QueryName;

			public byte StatusRequest;
			public byte StatusResponse;
			public ushort Data2;
			public byte Data1;
			public byte LocalSessionNumber;
			public byte RemoteSessionNumber;
			public byte CallNameType;
			public ushort XmitCorrelator;
			public byte DataFirstMidleFlags;
			public byte ResyncIndicator;
			public byte DataOnlyFlags;
			public byte SessionConfirmFlags;
			public byte SessionInitFlags;
			public byte NoReceiveFlags;

		}


		public PacketNETBIOS()
		{
		}


		public static string GetCommandString( byte cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				case	0x01	: Tmp = "Add Name Query"; break;
				case	0x08	: Tmp = "Datagram"; break;
			}

			return Tmp;
		}

		public static string GetDelimeterString( ushort cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				case	0xefff	: Tmp = "Netbios"; break;
			}

			return Tmp;
		}

		public static string GetNameNumberString( byte cmd )
		{
			string Tmp = "";

			switch( cmd )
			{
				default	: Tmp = ""; break;
			}

			return Tmp;
		}



		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			string Tmp = "";
			int kk = 0;
			byte NNumber = 0;
			PACKET_NETBIOS PNetBios;

			mNodex = new TreeNode();
			mNodex.Text = "NETBIOS ( Netbios Protocol )";
			kk = Index;
	
			try
			{
				PNetBios.Length = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Length     :" + Function.ReFormatString( PNetBios.Length , null );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PNetBios.Delimeter = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				Tmp = "Delimeter  :" + Function.ReFormatString( PNetBios.Delimeter , GetDelimeterString( PNetBios.Delimeter ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

				PNetBios.Command = PacketData[ Index++ ];
				Tmp = "Command    :" + Function.ReFormatString( PNetBios.Command , GetCommandString( PNetBios.Command ) );
				mNodex.Nodes.Add( Tmp );
				Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

				switch( PNetBios.Command )
				{
					case Const.NB_ADD_GROUP : 
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.NameToAdd = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Name to Add : " + PNetBios.NameToAdd;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						break;

					case Const.NB_ADD_NAME :
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.NameToAdd = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Name To Add : " + PNetBios.NameToAdd;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						break;

					case Const.NB_NAME_IN_CONFLICT :
						PNetBios.NameInConflict = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Name in Conflict : " + PNetBios.NameInConflict;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

						PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Sender's Name : " + PNetBios.SendersName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						break;

					case Const.NB_STATUS_QUERY :
						PNetBios.StatusRequest = PacketData[ Index ++ ];
						Tmp = "Status Request : " + Function.ReFormatString( PNetBios.StatusRequest , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Data 2 : " + Function.ReFormatString( PNetBios.Data2 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Receiver's Name : " + PNetBios.ReceiversName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

						PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Sender's Name : " + PNetBios.SendersName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						break;

					case Const.NB_TERMINATE_TRACE_R :
						break;

					case Const.NB_DATAGRAM :

						while( PacketData[ Index ] == 0 ) Index ++;

						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Receiver's Name : " + PNetBios.ReceiversName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

						if( Function.CheckBytesForZero( PacketData , Index , 10 ) )
						{
							Index += 10;
							PNetBios.SendersName = Function.GetMACAddress( PacketData , ref Index );
							Tmp = "Sender's MAC Address : " + PNetBios.SendersName;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 6 , 6 , false );
						}
						else
						{
							PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
							Tmp = "Sender's Name : " + PNetBios.SendersName;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						}
						break;

					case Const.NB_DATAGRAM_BCAST :
						if( Function.CheckBytesForZero( PacketData , Index , 10 ) )
						{
							Index += 10;
							PNetBios.SendersName = Function.GetMACAddress( PacketData , ref Index );
							Tmp = "Sender's MAC Address : " + PNetBios.SendersName;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 6 , 6 , false );
						}
						else
						{
							PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
							Tmp = "Sender's Name : " + PNetBios.SendersName;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						}
						break;

					case Const.NB_NAME_QUERY :
						Index ++;
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.CallNameType = PacketData[ Index ++ ];
						Tmp = "Call Name Type : " + Function.ReFormatString( PNetBios.CallNameType , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						Index += 2;
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.QueryName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Query Name : " + PNetBios.QueryName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

						if( PNetBios.LocalSessionNumber != 0 )
						{
							PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
							Tmp = "Sender's Name : " + PNetBios.SendersName;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						}

						break;

					case Const.NB_ADD_NAME_RESP :
						PNetBios.Data1 = PacketData[ Index ++ ];
						Tmp = "Data 1 : " + Function.ReFormatString( PNetBios.Data1 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.Data2 = PacketData[ Index ++ ];
						Tmp = "Data 2 : " + Function.ReFormatString( PNetBios.Data2 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						Index ++;
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						Index += 2;
						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Receiver's Name : " + PNetBios.ReceiversName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

						PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Sender's Name : " + PNetBios.SendersName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						break;

					case Const.NB_NAME_RESP :
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.CallNameType = PacketData[ Index ++ ];
						Tmp = "Call Name Type : " + Function.ReFormatString( PNetBios.CallNameType , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						if( PNetBios.LocalSessionNumber != 0x00 && PNetBios.LocalSessionNumber != 0xFF)
						{
							PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
							Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 2 , 2 , false );
						}
						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Receiver's Name : " + PNetBios.ReceiversName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

						if( PNetBios.LocalSessionNumber != 0x00 && PNetBios.LocalSessionNumber != 0xFF) 
						{
							PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
							Tmp = "Sender's Name : " + PNetBios.SendersName;
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						}

						break;

					case Const.NB_STATUS_RESP :
						PNetBios.StatusResponse = PacketData[ Index ++ ];
						Tmp = "Status Response : " + Function.ReFormatString( PNetBios.StatusResponse , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Data 2 : " + Function.ReFormatString( PNetBios.Data2 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						Index --;
						PNetBios.CallNameType = PacketData[ Index ++ ];
						Tmp = "Call Name Type : " + Function.ReFormatString( PNetBios.CallNameType , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						Index += 2;
						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Receiver's Name : " + PNetBios.ReceiversName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );

						PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						Tmp = "Sender's Name : " + PNetBios.SendersName;
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 16 , 16 , false );
						break;

					case Const.NB_TERMINATE_TRACE_LR :
						break;

					case Const.NB_DATA_ACK :
						Index += 5;
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						break;

					case Const.NB_DATA_FIRST_MIDDLE :
						PNetBios.DataFirstMidleFlags = PacketData[ Index ++ ];
						Tmp = "Data First Midle Flags : " + Function.ReFormatString( PNetBios.DataFirstMidleFlags , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.ResyncIndicator = PacketData[ Index ++ ];
						Tmp = "Resync Indicator : " + Function.ReFormatString( PNetBios.ResyncIndicator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						Index ++;
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

					case Const.NB_DATA_ONLY_LAST :
						PNetBios.DataOnlyFlags = PacketData[ Index ++ ];
						Tmp = "Data Only Flags : " + Function.ReFormatString( PNetBios.DataOnlyFlags , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.ResyncIndicator = PacketData[ Index ++ ];
						Tmp = "Resync Indicator : " + Function.ReFormatString( PNetBios.ResyncIndicator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						Index ++;
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

					case Const.NB_SESSION_CONFIRM :
						PNetBios.SessionConfirmFlags = PacketData[ Index ++ ];
						Tmp = "Session Confirm Flags : " + Function.ReFormatString( PNetBios.SessionConfirmFlags , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Data 2 : " + Function.ReFormatString( PNetBios.Data2 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

					case Const.NB_SESSION_END :
						Index ++;
						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Data 2 : " + Function.ReFormatString( PNetBios.Data2 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						Index += 4;
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

					case Const.NB_SESSION_INIT :
						PNetBios.SessionInitFlags = PacketData[ Index ++ ];
						Tmp = "Session Init Number : " + Function.ReFormatString( PNetBios.SessionInitFlags , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Data 2 : " + Function.ReFormatString( PNetBios.Data2 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Response Correlator : " + Function.ReFormatString( PNetBios.ResponseCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

					case Const.NB_NO_RECEIVE :
						PNetBios.NoReceiveFlags = PacketData[ Index ++ ];
						Tmp = "No Receive Flags : " + Function.ReFormatString( PNetBios.NoReceiveFlags , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Data 2 : " + Function.ReFormatString( PNetBios.Data2 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						Index += 2;
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

					case Const.NB_RECEIVE_OUTSTANDING :
						Index ++;
						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Data 2 : " + Function.ReFormatString( PNetBios.Data2 , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						Index += 2;
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

					case Const.NB_RECEIVE_CONTINUE :
						Index += 5;
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Tmp = "Xmit Correlator : " + Function.ReFormatString( PNetBios.XmitCorrelator , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 2 , 2 , false );

						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

					case Const.NB_KEEP_ALIVE :
						Index += 7;
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						Tmp = "Remote Session Number : " + Function.ReFormatString( PNetBios.RemoteSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						Tmp = "Local Session Number : " + Function.ReFormatString( PNetBios.LocalSessionNumber , null );
						mNodex.Nodes.Add( Tmp );
						Function.SetPosition( ref mNodex , Index - 1 , 1 , false );
						break;

				}

				Function.SetPosition( ref mNodex , kk , Index - kk , true );
				mNode.Add( mNodex );

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

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NETBIOS";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Netbios";
			
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed NETBIOS packet. Remaining bytes don't fit an NETBIOS packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed NETBIOS packet. Remaining bytes don't fit an NETBIOS packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem )
		{
			byte NNumber = 0;
			PACKET_NETBIOS PNetBios;

			try
			{
				PNetBios.Length = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PNetBios.Delimeter = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
				PNetBios.Command = PacketData[ Index++ ];


				switch( PNetBios.Command )
				{
					case Const.NB_ADD_GROUP : 
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.NameToAdd = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						break;

					case Const.NB_ADD_NAME :
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.NameToAdd = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						break;

					case Const.NB_NAME_IN_CONFLICT :
						PNetBios.NameInConflict = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						break;

					case Const.NB_STATUS_QUERY :
						PNetBios.StatusRequest = PacketData[ Index ++ ];
						//???nb_data2( hf_netb_status_buffer_len, tvb, offset, tree);
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						break;

					case Const.NB_TERMINATE_TRACE_R :
						break;

					case Const.NB_DATAGRAM :
						while( PacketData[ Index ] == 0 ) Index ++;
						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						if( Function.CheckBytesForZero( PacketData , Index , 10 ) )
						{
							Index += 10;
							PNetBios.SendersName = Function.GetMACAddress( PacketData , ref Index );
						}
						else
							PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						break;

					case Const.NB_DATAGRAM_BCAST :
						if( Function.CheckBytesForZero( PacketData , Index , 10 ) )
						{
							Index += 10;
							PNetBios.SendersName = Function.GetMACAddress( PacketData , ref Index );
						}
						else
							PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						break;

					case Const.NB_NAME_QUERY :
						Index ++;
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						PNetBios.CallNameType = PacketData[ Index ++ ];
						Index += 2;
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.QueryName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						if( PNetBios.LocalSessionNumber != 0 )
							PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );

						break;

					case Const.NB_ADD_NAME_RESP :
						PNetBios.Data1 = PacketData[ Index ++ ];
						PNetBios.Data2 = PacketData[ Index ++ ];
						Index ++;
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Index += 2;
						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						break;

					case Const.NB_NAME_RESP :
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						PNetBios.CallNameType = PacketData[ Index ++ ];
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						if( PNetBios.LocalSessionNumber != 0x00 && PNetBios.LocalSessionNumber != 0xFF)
							PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						if( PNetBios.LocalSessionNumber != 0x00 && PNetBios.LocalSessionNumber != 0xFF) 
							PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );

						break;

					case Const.NB_STATUS_RESP :
						PNetBios.StatusResponse = PacketData[ Index ++ ];
						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Index --;
						PNetBios.CallNameType = PacketData[ Index ++ ];
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Index += 2;
						PNetBios.ReceiversName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						PNetBios.SendersName = Function.GetNetBiosNameSerial( PacketData , ref Index , ref NNumber );
						break;

					case Const.NB_TERMINATE_TRACE_LR :
						break;

					case Const.NB_DATA_ACK :
						Index += 5;
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_DATA_FIRST_MIDDLE :
						PNetBios.DataFirstMidleFlags = PacketData[ Index ++ ];
						PNetBios.ResyncIndicator = PacketData[ Index ++ ];
						Index ++;
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_DATA_ONLY_LAST :
						PNetBios.DataOnlyFlags = PacketData[ Index ++ ];
						PNetBios.ResyncIndicator = PacketData[ Index ++ ];
						Index ++;
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_SESSION_CONFIRM :
						PNetBios.SessionConfirmFlags = PacketData[ Index ++ ];
						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_SESSION_END :
						Index ++;
						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Index += 4;
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_SESSION_INIT :
						PNetBios.SessionInitFlags = PacketData[ Index ++ ];
						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.ResponseCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_NO_RECEIVE :
						PNetBios.NoReceiveFlags = PacketData[ Index ++ ];
						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Index += 2;
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_RECEIVE_OUTSTANDING :
						Index ++;
						PNetBios.Data2 = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						Index += 2;
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_RECEIVE_CONTINUE :
						Index += 5;
						PNetBios.XmitCorrelator = Function.Get2Bytes( PacketData , ref Index , Const.VALUE );
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

					case Const.NB_KEEP_ALIVE :
						Index += 7;
						PNetBios.RemoteSessionNumber = PacketData[ Index ++ ];
						PNetBios.LocalSessionNumber = PacketData[ Index ++ ];
						break;

				}


				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "NETBIOS";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "Netbios";

			}
			catch
			{
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed NETBIOS packet. Remaining bytes don't fit an NETBIOS packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


	}
}
