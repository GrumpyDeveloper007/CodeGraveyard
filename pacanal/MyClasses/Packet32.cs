using System;
using System.Collections;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Threading;
using System.Globalization;
using Microsoft.Win32;
using System.IO;

namespace MyClasses
{

	public class Packet32
	{

		public struct PACKET_FILE_HEADER
		{
			public uint   Magic;			//Libpcap magic number
			public ushort MajorVersion;		//Libpcap major version
			public ushort MinorVersion;		//Libpcap minor version
			public uint   ThisZone;			//Gmt to local correction
			public uint   SigFigs;			//Accuracy of timestamps
			public uint   SnapLen;			//Length of the max saved portion of each packet
			public uint   LinkType;			//Data link type (DLT_*). See win_bpf.h for details.
		};

		public struct PACKET_USAGE_ITEM
		{
			public string Name;
			public double Count;
			public double BandWidth;
			public double TotalByte;
			public double StartTime;
			public double StopTime;
			public double TotalTime;
			public double Percantage;
			public string PercantageStr;
		}


		public struct CAPTURE_OPTIONS
		{
			public int AdapterIndex;
			public bool LimitPackets;
			public int PacketSize;
			public bool PromiscuousMode;
			public string Filter;
			public int AdapterBufferSize;
			public int BufferSize;
			public int NumWrites;
			public int ReadTimeOut;
			public int MinBytesToCopy;
			public int CaptureMode;
			public int HardwareFilter;
		}

		public struct DISPLAY_OPTIONS
		{
			public bool UpdateListInRealTime;
			public bool AutomaticScrollInLiveCapture;
		}

		public struct CAPTURE_LIMITS
		{
			public bool LimitToPackets;
			public int PacketSize;
			public bool LimitToKiloBytes;
			public int KilobyteSize;
			public bool LimitToSeconds;
			public int SecondSize;
		}

		public struct NAME_RESOLUTION
		{
			public bool EnableMAC;
			public bool EnableNetwork;
			public bool EnableTransport;
			public bool EnableManufacturer;
		}

		public struct PROTOCOL_ITEM
		{
			public int Count;
			public string CountStr;
			public double Pct;
			public string PctStr;
		}

		public struct CAPTURE_STATUS
		{
			public PROTOCOL_ITEM Total;
			public PROTOCOL_ITEM SCPT;
			public PROTOCOL_ITEM TCP;
			public PROTOCOL_ITEM UDP;
			public PROTOCOL_ITEM ICMP;
			public PROTOCOL_ITEM ARP;
			public PROTOCOL_ITEM OSPF;
			public PROTOCOL_ITEM GRE;
			public PROTOCOL_ITEM NetBIOS;
			public PROTOCOL_ITEM IPX;
			public PROTOCOL_ITEM VINES;
			public PROTOCOL_ITEM Other;

			public int Seconds;
			public string SecondsStr;

			public int Kilobytes;
			public string KilobytesStr;

		}


		private CAPTURE_OPTIONS mCaptureOptions;
		private DISPLAY_OPTIONS mDisplayOptions;
		private CAPTURE_LIMITS mCaptureLimits;
		private NAME_RESOLUTION mNameResolution;
		private CAPTURE_STATUS mCaptureStatus;
		public PACKET_FILE_HEADER PacketFileHeader;

		private bool mStopCapture;
		private bool mCaptureStopped;
		private int mCaptureMode;
		private int StartTickValue;
		private int CurrentTickValue;
		public uint FirstSeconds;
		public uint FirstMiliSeconds;
		public ulong FirstLongValue;
		public bool PacketOnOff;
		private ListView ThisListView;

		private TreeNode GlobalNode = new TreeNode();

		private ArrayList ReceivedPackets = new ArrayList();
		private ArrayList BandUsage = new ArrayList();
		public PACKET_USAGE_ITEM PacketUsageItem;

		public Packet32h P32h = new Packet32h();
		public PacketParser PParser = new PacketParser();

		public Packet32()
		{
			mStopCapture = false;
			mCaptureStopped = true;
			mCaptureMode = ( int )Packet32h.PACKET_MODE_CAPT;
			StartTickValue = 0;
			CurrentTickValue = 0;
			FirstSeconds = 0;
			FirstMiliSeconds = 0;
			FirstLongValue = 0;
			PacketOnOff = true;

			mCaptureOptions.AdapterIndex = 0;
			mCaptureOptions.Filter = "";
			mCaptureOptions.LimitPackets = false;
			mCaptureOptions.PacketSize = 68;
			mCaptureOptions.PromiscuousMode = true;
			mCaptureOptions.AdapterBufferSize = 512000;
			mCaptureOptions.BufferSize = 256000;
			mCaptureOptions.CaptureMode = ( int )Packet32h.PACKET_MODE_CAPT;
			mCaptureOptions.HardwareFilter = Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS;
			mCaptureOptions.MinBytesToCopy = 4096;
			mCaptureOptions.NumWrites = 1;
			mCaptureOptions.ReadTimeOut = 1000;

			mDisplayOptions.AutomaticScrollInLiveCapture = false;
			mDisplayOptions.UpdateListInRealTime = false;

			mCaptureLimits.LimitToKiloBytes = false;
			mCaptureLimits.KilobyteSize = 1;
			mCaptureLimits.LimitToPackets = false;
			mCaptureLimits.PacketSize = 1;
			mCaptureLimits.LimitToSeconds = false;
			mCaptureLimits.SecondSize = 1;

			mNameResolution.EnableMAC = false;
			mNameResolution.EnableNetwork = false;
			mNameResolution.EnableTransport = false;
			mNameResolution.EnableManufacturer = false;

			InitCaptureStatus();

			mCaptureStatus.Seconds = 0;
			mCaptureStatus.SecondsStr = "00:00:00";

			mCaptureStatus.Kilobytes = 0;
			mCaptureStatus.KilobytesStr = "0.0 Kb";

			PacketUsageItem.BandWidth = 2 * 1024 * 1024;
			PacketUsageItem.Count = 0;
			PacketUsageItem.Name = "HTTP";
			PacketUsageItem.Percantage = 0;
			PacketUsageItem.TotalByte = 0;
			PacketUsageItem.StartTime = 0;
			PacketUsageItem.StopTime = 0;
			PacketUsageItem.TotalTime = 0;

			PacketFileHeader.Magic = Const.TCPDUMP_MAGIC;
			PacketFileHeader.MajorVersion = Const.PCAP_VERSION_MAJOR;
			PacketFileHeader.MinorVersion = Const.PCAP_VERSION_MINOR;
			PacketFileHeader.ThisZone = 0;
			PacketFileHeader.SigFigs = 0;
			PacketFileHeader.SnapLen = 0xffff;
			PacketFileHeader.LinkType = 1;

			ReadSettings();

		}



		public static int Packet_WORDALIGN( int x )
		{ return ( int) ( ((x) + (Const.PACKET_ALIGNMENT - 1))&~(Const.PACKET_ALIGNMENT - 1) ); }


		public CAPTURE_OPTIONS CaptureOptions
		{
			get { return mCaptureOptions; }
			set { mCaptureOptions = value; }
		}

		public DISPLAY_OPTIONS DisplayOptions
		{
			get { return mDisplayOptions; }
			set { mDisplayOptions = value; }
		}

		public CAPTURE_LIMITS CaptureLimits
		{
			get { return mCaptureLimits; }
			set { mCaptureLimits = value; }
		}

		public NAME_RESOLUTION NameResolution
		{
			get { return mNameResolution; }
			set { mNameResolution = value; }
		}

		public CAPTURE_STATUS CaptureStatus
		{
			get { return mCaptureStatus; }
			set { mCaptureStatus = value; }
		}

		public bool StopCapture
		{
			get { return mStopCapture; }
			set 
			{
				if( mStopCapture != value )
					mStopCapture = value;
			}

		}

		public bool CaptureStopped
		{
			get { return mCaptureStopped; }
		}

		public string [] InstalledAdapters
		{
			get { return P32h.AdapterNames; }
		}

		public string [] InstalledAdapterDescs
		{
			get { return P32h.AdapterDescriptions; }
		}


		private void InitProtocolItem( ref PROTOCOL_ITEM pi )
		{
			pi.Count = 0;
			pi.CountStr = "0";
			pi.Pct = 0.00;
			pi.PctStr = "( 0.00 % )";
		}


		private void InitCaptureStatus()
		{

			InitProtocolItem( ref mCaptureStatus.Total );
			InitProtocolItem( ref mCaptureStatus.SCPT );
			InitProtocolItem( ref mCaptureStatus.TCP );
			InitProtocolItem( ref mCaptureStatus.UDP );
			InitProtocolItem( ref mCaptureStatus.ICMP );
			InitProtocolItem( ref mCaptureStatus.ARP );
			InitProtocolItem( ref mCaptureStatus.OSPF );
			InitProtocolItem( ref mCaptureStatus.GRE );
			InitProtocolItem( ref mCaptureStatus.NetBIOS );
			InitProtocolItem( ref mCaptureStatus.IPX );
			InitProtocolItem( ref mCaptureStatus.VINES );
			InitProtocolItem( ref mCaptureStatus.Other );

			mCaptureStatus.Seconds = 0;
			mCaptureStatus.SecondsStr = "00:00:00";

			mCaptureStatus.Kilobytes = 0;
			mCaptureStatus.KilobytesStr = "0.0 Kb";

		}

		private void UpdateProtocolItem( ref PROTOCOL_ITEM pi )
		{
			pi.CountStr = pi.Count.ToString();
			pi.Pct = ( double ) pi.Count / (double) mCaptureStatus.Total.Count;
			pi.Pct *= 100;
			pi.PctStr = "( "  + pi.Pct.ToString("F") + " % )";
		}


		private void GetLatestCounts()
		{
			PacketParser.PACKET_ITEM PItem;
			int i = 0;
			string Str = "";

			mCaptureStatus.Total.Count = PParser.PacketCollection.Count;

			mCaptureStatus.SCPT.Count  = 0;
			mCaptureStatus.TCP.Count  = 0;
			mCaptureStatus.UDP.Count  = 0;
			mCaptureStatus.ICMP.Count  = 0;
			mCaptureStatus.ARP.Count  = 0;
			mCaptureStatus.OSPF.Count  = 0;
			mCaptureStatus.GRE.Count  = 0;
			mCaptureStatus.NetBIOS.Count  = 0;
			mCaptureStatus.IPX.Count  = 0;
			mCaptureStatus.VINES.Count  = 0;
			mCaptureStatus.Other.Count  = 0;

			for( i = 0; i < PParser.PacketCollection.Count; i ++ )
			{
				PItem = ( PacketParser.PACKET_ITEM ) PParser.PacketCollection[i];
				Str = PItem.TypeInfo;

				if( Str == "SCPT" )
					mCaptureStatus.SCPT.Count ++;
				else if( Str == "TCP" )
					mCaptureStatus.TCP.Count ++;
				else if( Str == "UDP" )
					mCaptureStatus.UDP.Count ++;
				else if( Str == "ICMP" )
					mCaptureStatus.ICMP.Count ++;
				else if( Str == "ARP" )
					mCaptureStatus.ARP.Count ++;
				else if( Str == "OSPF" )
					mCaptureStatus.OSPF.Count ++;
				else if( Str == "GRE" )
					mCaptureStatus.GRE.Count ++;
				else if( Str == "NetBIOS" )
					mCaptureStatus.NetBIOS.Count ++;
				else if( Str == "IPX" )
					mCaptureStatus.IPX.Count ++;
				else if( Str == "VINES" )
					mCaptureStatus.VINES.Count ++;
				else 
					mCaptureStatus.Other.Count ++;
			}

		}

		private void GetCaptureStatistics()
		{
			int TCount = 0;
			int hour = 0;
			int minute = 0;
			int second = 0;
			string Tmp = "";
			int i = 0;

			GetLatestCounts();
			UpdateProtocolItem( ref mCaptureStatus.Total );
			UpdateProtocolItem( ref mCaptureStatus.SCPT );
			UpdateProtocolItem( ref mCaptureStatus.TCP );
			UpdateProtocolItem( ref mCaptureStatus.UDP );
			UpdateProtocolItem( ref mCaptureStatus.ICMP );
			UpdateProtocolItem( ref mCaptureStatus.ARP );
			UpdateProtocolItem( ref mCaptureStatus.OSPF );
			UpdateProtocolItem( ref mCaptureStatus.GRE );
			UpdateProtocolItem( ref mCaptureStatus.NetBIOS );
			UpdateProtocolItem( ref mCaptureStatus.IPX );
			UpdateProtocolItem( ref mCaptureStatus.VINES );
			UpdateProtocolItem( ref mCaptureStatus.Other );

			TCount = ( CurrentTickValue - StartTickValue ) / 1000;
			mCaptureStatus.Seconds = TCount;
			minute = TCount / 60;
			second = TCount - minute * 60;
			hour = minute / 60;
			minute = minute - hour * 60;
			Tmp = hour.ToString("d2") + ":" + minute.ToString("d2") + ":" + second.ToString("d2");
			mCaptureStatus.SecondsStr = Tmp;

			TCount = 0;
			for( i = 0; i < P32h.CapturedPacketArray.Count; i++ )
			{
				TCount += ( (byte [] ) P32h.CapturedPacketArray[i] ).GetLength(0);
			}

			mCaptureStatus.Kilobytes = TCount;
			mCaptureStatus.KilobytesStr = TCount.ToString();

		}

		public void InitBandUsage()
		{
			//PacketUsageItem.BandWidth = 19.2 * 1024 / 8;
			PacketUsageItem.BandWidth = 2 * 1024 * 1024 / 8;
			PacketUsageItem.Count = 0;
			PacketUsageItem.Name = "HTTP";
			PacketUsageItem.Percantage = 0;
			PacketUsageItem.TotalByte = 0;
			PacketUsageItem.StartTime = 0;
			PacketUsageItem.StopTime = 0;
			PacketUsageItem.TotalTime = 0;
		}

		public void CalculateBandUsage()
		{
			double t = 0, t1 = 0;
			string Tmp = "";

			t = PacketUsageItem.StopTime - PacketUsageItem.StartTime;
			t1 = t;
			t /= 1000;
			t *= PacketUsageItem.BandWidth;
			t = PacketUsageItem.TotalByte / t;
			t *= 100;
			
			PacketUsageItem.PercantageStr = t.ToString("G");
			Tmp ="Packet Processed = " + PacketUsageItem.Name + (char) 13 + (char) 10;
			Tmp +="Band Width = " + PacketUsageItem.BandWidth.ToString("G") + (char) 13 + (char) 10;
			Tmp +="Time Interval in ms = " + t1.ToString("G") + (char) 13 + (char) 10;
			Tmp +="Total Packet Size = " + PacketUsageItem.TotalByte.ToString("G") + (char) 13 + (char) 10;
			Tmp +="Usage Percentage = " + t.ToString("G");

			//MessageBox.Show( "The band usage percentage in a 2MB bandwidth for HTTP is " + PacketUsageItem.PercantageStr );
			//MessageBox.Show( Tmp );
		}


		public void SetParserBuffer()
		{
			PParser.PacketBufferData = ( byte [] ) P32h.CapturedPacketArray[0];
		}

		public void Start( ListView LVw , TreeNodeCollection Tnc , RichTextBox Rtx )
		{

			ThisListView = LVw;
			PacketOnOff = true;
			Thread.CurrentThread.CurrentCulture = new CultureInfo("en-us");

			P32h.PacketOpenAdapter( P32h.AdapterNames[ mCaptureOptions.AdapterIndex ] );
			P32h.PacketAllocatePacket( mCaptureOptions.BufferSize );
			P32h.PacketSetMinToCopy( mCaptureOptions.MinBytesToCopy );
			P32h.PacketSetNumWrites( mCaptureOptions.NumWrites );
			P32h.PacketSetReadTimeout( mCaptureOptions.ReadTimeOut );
			P32h.PacketSetMode( mCaptureOptions.CaptureMode );
			P32h.PacketSetHwFilter( (uint) mCaptureOptions.HardwareFilter );
			P32h.PacketSetBuff( mCaptureOptions.AdapterBufferSize );
			InitCaptureStatus();
			LVw.Items.Clear();
			Tnc.Clear();
			Rtx.Text = "";

			mStopCapture = false;
			mCaptureStopped = false;

			P32h.CapturedPacketArray.Clear();

			PParser.PacketCollection.Add("");
			PParser.PacketCollection.Clear();
			PParser.CurrentPacketBufferDataIndex = 0;
			PParser.LVw = LVw;
			PParser.mCaptureOptions = mCaptureOptions;
			PParser.PacketOnOff = PacketOnOff;
			PParser.Rtx = Rtx;
			PParser.StopCapture = mStopCapture;
			PParser.mNode = Tnc;

			InitBandUsage();
			StartTickValue = Function.GetTickCount();
			CurrentTickValue = StartTickValue;
			PacketUsageItem.StartTime = Function.GetTickCount();

			do
			{
				Application.DoEvents();
				P32h.PacketReceivePacket( true );
				CurrentTickValue = Function.GetTickCount();
				Application.DoEvents();

				if( P32h.CapturedPacketArray != null )
				{
					if( P32h.CapturedPacketArray.Count > 0 )
					{
						if( P32h.Packet.ulBytesReceived > 0 )
						{
							PParser.CurrentPacketBufferDataIndex = P32h.CapturedPacketArray.Count - 1;
							PParser.PacketBufferData = ( byte [] ) P32h.CapturedPacketArray[ P32h.CapturedPacketArray.Count - 1 ];
							PParser.Parse();
							GetCaptureStatistics();
						}
					}
				}

				if( mStopCapture == true ) break;

				if( mCaptureLimits.LimitToPackets )
				{
					if( mCaptureStatus.Total.Count >= mCaptureLimits.PacketSize )
						break;
				}
			
				if( mCaptureLimits.LimitToKiloBytes )
				{
					if( mCaptureStatus.Kilobytes >= mCaptureLimits.KilobyteSize )
						break;
				}
			
				if( mCaptureLimits.LimitToSeconds )
				{
					if( mCaptureStatus.Seconds >= mCaptureLimits.SecondSize )
						break;
				}


			}while( true );

			mCaptureStopped = true;

			PacketUsageItem.StopTime = Function.GetTickCount();
			CalculateBandUsage();

			P32h.PacketFreePacket();
			P32h.PacketCloseAdapter();

		}

		public bool SaveToFile( string FileName )
		{
			StreamWriter SWriter = new StreamWriter( FileName );
			Stream WStream;
			byte [] WriteArray = new byte[16];
			int i = 0;
			byte [] HeaderData = new byte[24];
			PacketParser.PACKET_ITEM PItem;

			if( P32h.CapturedPacketArray == null ) return false;
			if( P32h.CapturedPacketArray.Count == 0 ) return false;

			WStream = SWriter.BaseStream;

			// To make enable our output file to be read by etheral
			//PacketFileHeader;
			HeaderData[0] = 0xD4; HeaderData[1] = 0xC3; HeaderData[2] = 0xB2; HeaderData[3] = 0xA1;
			HeaderData[4] = 0x02; HeaderData[5] = 0x00; HeaderData[6] = 0x04; HeaderData[7] = 0x00;
			HeaderData[8] = 0x00; HeaderData[9] = 0x00; HeaderData[10] = 0x00; HeaderData[11] = 0x00;
			HeaderData[12] = 0x00; HeaderData[13] = 0x00; HeaderData[14] = 0x00; HeaderData[15] = 0x00;
			HeaderData[16] = 0xFF; HeaderData[17] = 0xFF; HeaderData[18] = 0x00; HeaderData[19] = 0x00;
			HeaderData[20] = 0x01; HeaderData[21] = 0x00; HeaderData[22] = 0x00; HeaderData[23] = 0x00;
			 
			WStream.Write( HeaderData, 0 , 24 );

			for( i = 0; i < PParser.PacketCollection.Count; i ++ )
			{
				PItem = ( PacketParser.PACKET_ITEM ) PParser.PacketCollection[i];
				WStream.Write( PItem.FrameData , 0 , 16 );
				WStream.Write( PItem.Data , 0 , PItem.Data.GetLength(0) );
			}

			SWriter.Close();

			return true;
		}


		public bool SaveSelectedPacket( string FileName , int index )
		{
			StreamWriter SWriter = new StreamWriter( FileName );
			Stream WStream;
			byte [] WriteArray = new byte[16];
			byte [] HeaderData = new byte[24];
			PacketParser.PACKET_ITEM PItem;

			if( P32h.CapturedPacketArray == null ) return false;
			if( P32h.CapturedPacketArray.Count == 0 ) return false;

			WStream = SWriter.BaseStream;

			// To make enable our output file to be read by etheral
			//PacketFileHeader;
			HeaderData[0] = 0xD4; HeaderData[1] = 0xC3; HeaderData[2] = 0xB2; HeaderData[3] = 0xA1;
			HeaderData[4] = 0x02; HeaderData[5] = 0x00; HeaderData[6] = 0x04; HeaderData[7] = 0x00;
			HeaderData[8] = 0x00; HeaderData[9] = 0x00; HeaderData[10] = 0x00; HeaderData[11] = 0x00;
			HeaderData[12] = 0x00; HeaderData[13] = 0x00; HeaderData[14] = 0x00; HeaderData[15] = 0x00;
			HeaderData[16] = 0xFF; HeaderData[17] = 0xFF; HeaderData[18] = 0x00; HeaderData[19] = 0x00;
			HeaderData[20] = 0x01; HeaderData[21] = 0x00; HeaderData[22] = 0x00; HeaderData[23] = 0x00;
			 
			WStream.Write( HeaderData, 0 , 24 );
			PItem = ( PacketParser.PACKET_ITEM ) PParser.PacketCollection[index];
			WStream.Write( PItem.FrameData , 0 , 16 );
			WStream.Write( PItem.Data , 0 , PItem.Data.GetLength(0) );

			SWriter.Close();

			return true;
		}


		public bool SaveSelectedPacket( string FileName , int [] indexArray )
		{
			StreamWriter SWriter = new StreamWriter( FileName );
			Stream WStream;
			byte [] WriteArray = new byte[16];
			byte [] HeaderData = new byte[24];
			PacketParser.PACKET_ITEM PItem;
			int i = 0;

			if( P32h.CapturedPacketArray == null ) return false;
			if( P32h.CapturedPacketArray.Count == 0 ) return false;

			WStream = SWriter.BaseStream;

			// To make enable our output file to be read by etheral
			//PacketFileHeader;
			HeaderData[0] = 0xD4; HeaderData[1] = 0xC3; HeaderData[2] = 0xB2; HeaderData[3] = 0xA1;
			HeaderData[4] = 0x02; HeaderData[5] = 0x00; HeaderData[6] = 0x04; HeaderData[7] = 0x00;
			HeaderData[8] = 0x00; HeaderData[9] = 0x00; HeaderData[10] = 0x00; HeaderData[11] = 0x00;
			HeaderData[12] = 0x00; HeaderData[13] = 0x00; HeaderData[14] = 0x00; HeaderData[15] = 0x00;
			HeaderData[16] = 0xFF; HeaderData[17] = 0xFF; HeaderData[18] = 0x00; HeaderData[19] = 0x00;
			HeaderData[20] = 0x01; HeaderData[21] = 0x00; HeaderData[22] = 0x00; HeaderData[23] = 0x00;
			 
			WStream.Write( HeaderData, 0 , 24 );
			for( i = 0; i < indexArray.Length; i ++ )
			{
				PItem = ( PacketParser.PACKET_ITEM ) PParser.PacketCollection[ indexArray[i] ];
				WStream.Write( PItem.FrameData , 0 , 16 );
				WStream.Write( PItem.Data , 0 , PItem.Data.GetLength(0) );
			}

			SWriter.Close();

			return true;
		}

		public bool LoadFromFile( string FileName )
		{
			StreamReader SReader = new StreamReader( FileName );
			Stream RStream;
			byte [] ReadArray;
			byte [] HeaderData = new byte[24];

			PacketOnOff = false;

			P32h.CapturedPacketArray.Clear();
			ReceivedPackets.Clear();

			RStream = SReader.BaseStream;
			ReadArray = new byte[(int) RStream.Length - 24 ];
			RStream.Read( HeaderData , 0 , 24 );
			RStream.Read( ReadArray , 0 , (int) RStream.Length - 24 );
			SReader.Close();
			P32h.CapturedPacketArray.Add( ReadArray );
			PParser.PacketBufferData = ReadArray;

			return true;

		}


		public bool ReadSettings()
		{
			RegistryKey RKey;
			RegistryKey PacanalKey;
			object o;


			RKey = Registry.CurrentUser.OpenSubKey("MSAV");
			if( RKey == null )
			{
				SaveSettings();
				return false;
			}

			PacanalKey = RKey.OpenSubKey("Pacanal", true );
			if( PacanalKey == null )
			{
				RKey.Close();
				SaveSettings();
				return false;
			}

			RKey.Close();

			o = PacanalKey.GetValue("CaptureLimit", 1 );
			try { mCaptureOptions.LimitPackets = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mCaptureOptions.LimitPackets = false;
				PacanalKey.SetValue("CaptureLimit" , 0 );
			}

			o = PacanalKey.GetValue("EachPacketSize", 68 );
			try { mCaptureOptions.PacketSize = (int) o; }
			catch 
			{ 
				mCaptureOptions.PacketSize = 68;
				PacanalKey.SetValue("EachPacketSize" , 68 );
			}

			o = PacanalKey.GetValue("PromiscuousMode", 1 );
			try { mCaptureOptions.PromiscuousMode = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mCaptureOptions.PromiscuousMode = true;
				PacanalKey.SetValue("PromiscuousMode" , 1 );
			}

			o = PacanalKey.GetValue("Filter", "" );
			try { mCaptureOptions.Filter = (string) o; }
			catch 
			{ 
				mCaptureOptions.Filter = "";
				PacanalKey.SetValue("Filter" , "" );
			}

			o = PacanalKey.GetValue("UpdateListInRealTime", 0 );
			try { mDisplayOptions.UpdateListInRealTime = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mDisplayOptions.UpdateListInRealTime = false;
				PacanalKey.SetValue("UpdateListInRealTime" , 0 );
			}

			o = PacanalKey.GetValue("AutomaticScrollInLiveCapture", 0 );
			try { mDisplayOptions.AutomaticScrollInLiveCapture = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mDisplayOptions.AutomaticScrollInLiveCapture = false;
				PacanalKey.SetValue("AutomaticScrollInLiveCapture" , 0 );
			}

			o = PacanalKey.GetValue("LimitToPackets", 0 );
			try { mCaptureLimits.LimitToPackets = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mCaptureLimits.LimitToPackets = false;
				PacanalKey.SetValue("LimitToPackets" , 0 );
			}

			o = PacanalKey.GetValue("PacketSize", 1 );
			try { mCaptureLimits.PacketSize = (int) o; }
			catch 
			{ 
				mCaptureLimits.PacketSize = 1;
				PacanalKey.SetValue("PacketSize" , 1 );
			}

			o = PacanalKey.GetValue("LimitToKiloBytes", 0 );
			try { mCaptureLimits.LimitToKiloBytes = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mCaptureLimits.LimitToKiloBytes = false;
				PacanalKey.SetValue("LimitToKiloBytes" , 0 );
			}

			o = PacanalKey.GetValue("KilobyteSize", 1 );
			try { mCaptureLimits.KilobyteSize = (int) o; }
			catch 
			{ 
				mCaptureLimits.KilobyteSize = 1;
				PacanalKey.SetValue("KilobyteSize" , 1 );
			}

			o = PacanalKey.GetValue("LimitToSeconds", 0 );
			try { mCaptureLimits.LimitToSeconds = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mCaptureLimits.LimitToSeconds = false;
				PacanalKey.SetValue("LimitToSeconds" , 0 );
			}

			o = PacanalKey.GetValue("SecondSize", 1 );
			try { mCaptureLimits.SecondSize = (int) o; }
			catch 
			{ 
				mCaptureLimits.SecondSize = 1;
				PacanalKey.SetValue("SecondSize" , 1 );
			}

			o = PacanalKey.GetValue("EnableMAC", 0 );
			try { mNameResolution.EnableMAC = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mNameResolution.EnableMAC = false;
				PacanalKey.SetValue("EnableMAC" , 0 );
			}

			o = PacanalKey.GetValue("EnableNetwork", 0 );
			try { mNameResolution.EnableNetwork = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mNameResolution.EnableNetwork = false;
				PacanalKey.SetValue("EnableNetwork" , 0 );
			}

			o = PacanalKey.GetValue("EnableTransport", 0 );
			try { mNameResolution.EnableTransport = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mNameResolution.EnableTransport = false;
				PacanalKey.SetValue("EnableTransport" , 0 );
			}

			o = PacanalKey.GetValue("EnableManufacturer", 0 );
			try { mNameResolution.EnableManufacturer = ( (int) o ) == 0 ? false : true; }
			catch 
			{ 
				mNameResolution.EnableManufacturer = false;
				PacanalKey.SetValue("EnableManufacturer" , 0 );
			}

			o = PacanalKey.GetValue("AdapterBufferSize", 512000 );
			try { mCaptureOptions.AdapterBufferSize = (int) o; }
			catch 
			{ 
				mCaptureOptions.AdapterBufferSize = 512000;
				PacanalKey.SetValue("AdapterBufferSize" , 512000 );
			}

			o = PacanalKey.GetValue("BufferSize", 256000 );
			try { mCaptureOptions.BufferSize = (int) o; }
			catch 
			{ 
				mCaptureOptions.BufferSize = 256000;
				PacanalKey.SetValue("BufferSize" , 256000 );
			}

			o = PacanalKey.GetValue("MinBytesToCopy", 4096);
			try { mCaptureOptions.MinBytesToCopy = (int) o; }
			catch 
			{ 
				mCaptureOptions.MinBytesToCopy = 4096;
				PacanalKey.SetValue("MinBytesToCopy" , 4096 );
			}

			o = PacanalKey.GetValue("NumWrites", 1 );
			try { mCaptureOptions.NumWrites = (int) o; }
			catch 
			{ 
				mCaptureOptions.NumWrites = 1;
				PacanalKey.SetValue("NumWrites" , 1 );
			}

			o = PacanalKey.GetValue("ReadTimeOut", 1000 );
			try { mCaptureOptions.ReadTimeOut = (int) o; }
			catch 
			{ 
				mCaptureOptions.ReadTimeOut = 1000;
				PacanalKey.SetValue("ReadTimeOut" , 1000 );
			}

			o = PacanalKey.GetValue("CaptureMode", Packet32h.PACKET_MODE_CAPT );
			try { mCaptureOptions.CaptureMode = (int) o; }
			catch 
			{ 
				mCaptureOptions.CaptureMode = (int) Packet32h.PACKET_MODE_CAPT;
				PacanalKey.SetValue("CaptureMode" , Packet32h.PACKET_MODE_CAPT );
			}

			if( ( mCaptureOptions.CaptureMode != (int) Packet32h.PACKET_MODE_CAPT ) &&
				( mCaptureOptions.CaptureMode != (int) Packet32h.PACKET_MODE_DUMP ) &&
				( mCaptureOptions.CaptureMode != (int) Packet32h.PACKET_MODE_STAT ) &&
				( mCaptureOptions.CaptureMode != (int) Packet32h.PACKET_MODE_STAT_DUMP ) )
			{
				mCaptureOptions.CaptureMode = (int) Packet32h.PACKET_MODE_CAPT;
				PacanalKey.SetValue("CaptureMode" , Packet32h.PACKET_MODE_CAPT );
			}

			o = PacanalKey.GetValue("HardwareFilter", Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS );
			try { mCaptureOptions.HardwareFilter = (int) o; }
			catch 
			{ 
				mCaptureOptions.HardwareFilter = Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS;
				PacanalKey.SetValue("HardwareFilter" , Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS );
			}

			PacanalKey.Close();
			return true;

		}


		public bool SaveSettings()
		{
			RegistryKey RKey = null;
			RegistryKey PacanalKey = null;


			try
			{
				RKey = Registry.CurrentUser.CreateSubKey("MSAV");
			}
			catch( Exception Ex )
			{
				MessageBox.Show( Function.ReturnErrorMessage( Ex ) );
			}

			if( RKey == null )
				return false;

			PacanalKey = RKey.CreateSubKey("Pacanal");
			if( PacanalKey == null )
			{
				RKey.Close();
				return false;
			}

			PacanalKey.CreateSubKey( "CaptureLimit" );
			PacanalKey.SetValue("CaptureLimit", mCaptureOptions.LimitPackets ? 1 : 0 );

			PacanalKey.CreateSubKey( "EachPacketSize" );
			PacanalKey.SetValue("EachPacketSize", mCaptureOptions.PacketSize );

			PacanalKey.CreateSubKey( "PromiscuousMode" );
			PacanalKey.SetValue("PromiscuousMode", mCaptureOptions.PromiscuousMode ? 1 : 0 );

			PacanalKey.CreateSubKey( "Filter" );
			PacanalKey.SetValue("Filter", mCaptureOptions.Filter );

			PacanalKey.CreateSubKey( "UpdateListInRealTime" );
			PacanalKey.SetValue("UpdateListInRealTime", mDisplayOptions.UpdateListInRealTime ? 1 : 0 );

			PacanalKey.CreateSubKey( "AutomaticScrollInLiveCapture" );
			PacanalKey.SetValue("AutomaticScrollInLiveCapture", mDisplayOptions.AutomaticScrollInLiveCapture ? 1 : 0 );

			PacanalKey.CreateSubKey( "LimitToPackets" );
			PacanalKey.SetValue("LimitToPackets", mCaptureLimits.LimitToPackets ? 1 : 0 );

			PacanalKey.CreateSubKey( "PacketSize" );
			PacanalKey.SetValue("PacketSize", mCaptureLimits.PacketSize );

			PacanalKey.CreateSubKey( "LimitToKiloBytes" );
			PacanalKey.SetValue("LimitToKiloBytes", mCaptureLimits.LimitToKiloBytes ? 1 : 0 );

			PacanalKey.CreateSubKey( "KilobyteSize" );
			PacanalKey.SetValue("KilobyteSize", mCaptureLimits.KilobyteSize );

			PacanalKey.CreateSubKey( "LimitToSeconds" );
			PacanalKey.SetValue("LimitToSeconds", mCaptureLimits.LimitToSeconds ? 1 : 0 );

			PacanalKey.CreateSubKey( "SecondSize" );
			PacanalKey.SetValue("SecondSize", mCaptureLimits.SecondSize );

			PacanalKey.CreateSubKey( "EnableMAC" );
			PacanalKey.SetValue("EnableMAC", mNameResolution.EnableMAC ? 1 : 0 );

			PacanalKey.CreateSubKey( "EnableNetwork" );
			PacanalKey.SetValue("EnableNetwork", mNameResolution.EnableNetwork ? 1 : 0 );

			PacanalKey.CreateSubKey( "EnableTransport" );
			PacanalKey.SetValue("EnableTransport", mNameResolution.EnableTransport ? 1 : 0 );

			PacanalKey.CreateSubKey( "EnableManufacturer" );
			PacanalKey.SetValue("EnableManufacturer", mNameResolution.EnableManufacturer ? 1 : 0 );

			PacanalKey.CreateSubKey( "AdapterBufferSize" );
			PacanalKey.SetValue("AdapterBufferSize", mCaptureOptions.AdapterBufferSize );

			PacanalKey.CreateSubKey( "BufferSize" );
			PacanalKey.SetValue("BufferSize", mCaptureOptions.BufferSize );

			PacanalKey.CreateSubKey( "MinBytesToCopy" );
			PacanalKey.SetValue("MinBytesToCopy", mCaptureOptions.MinBytesToCopy );

			PacanalKey.CreateSubKey( "NumWrites" );
			PacanalKey.SetValue("NumWrites", mCaptureOptions.NumWrites );

			PacanalKey.CreateSubKey( "ReadTimeOut" );
			PacanalKey.SetValue("ReadTimeOut", mCaptureOptions.ReadTimeOut );

			PacanalKey.CreateSubKey( "CaptureMode" );
			PacanalKey.SetValue("CaptureMode", mCaptureOptions.CaptureMode );

			PacanalKey.CreateSubKey( "HardwareFilter" );
			PacanalKey.SetValue("HardwareFilter", mCaptureOptions.HardwareFilter );
			
			PacanalKey.Close();

			return true;

		}

	}
}
