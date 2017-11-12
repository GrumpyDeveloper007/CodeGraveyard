using System;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;
using System.Collections;

namespace MyClasses
{
	using SECURITY_DESCRIPTOR = System.Int32;

	public class Function
	{


		public static uint FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x100;
		public static uint FORMAT_MESSAGE_ARGUMENT_ARRAY = 0x2000;
		public static uint FORMAT_MESSAGE_FROM_HMODULE = 0x800;
		public static uint FORMAT_MESSAGE_FROM_STRING = 0x400;
		public static uint FORMAT_MESSAGE_FROM_SYSTEM = 0x1000;
		public static uint FORMAT_MESSAGE_IGNORE_INSERTS = 0x200;
		public static uint FORMAT_MESSAGE_MAX_WIDTH_MASK = 0xFF;
		public static uint LANG_BULGARIAN = 0x2;
		public static uint LANG_CHINESE = 0x4;
		public static uint LANG_CROATIAN = 0x1A;
		public static uint LANG_CZECH = 0x5;
		public static uint LANG_DANISH = 0x6;
		public static uint LANG_DUTCH = 0x13;
		public static uint LANG_ENGLISH = 0x9;
		public static uint LANG_FINNISH = 0xB;
		public static uint LANG_FRENCH = 0xC;
		public static uint LANG_GERMAN = 0x7;
		public static uint LANG_GREEK = 0x8;
		public static uint LANG_HUNGARIAN = 0xE;
		public static uint LANG_ICELANDIC = 0xF;
		public static uint LANG_ITALIAN = 0x10;
		public static uint LANG_JAPANESE = 0x11;
		public static uint LANG_KOREAN = 0x12;
		public static uint LANG_NEUTRAL = 0x0;
		public static uint LANG_NORWEGIAN = 0x14;
		public static uint LANG_POLISH = 0x15;
		public static uint LANG_PORTUGUESE = 0x16;
		public static uint LANG_ROMANIAN = 0x18;
		public static uint LANG_RUSSIAN = 0x19;
		public static uint LANG_SLOVAK = 0x1B;
		public static uint LANG_SLOVENIAN = 0x24;
		public static uint LANG_SPANISH = 0xA;
		public static uint LANG_SWEDISH = 0x1D;
		public static uint LANG_TURKISH = 0x1F;
		public static uint SUBLANG_CHINESE_HONGKONG = 0x3;
		public static uint SUBLANG_CHINESE_SIMPLIFIED = 0x2;
		public static uint SUBLANG_CHINESE_SINGAPORE = 0x4;
		public static uint SUBLANG_CHINESE_TRADITIONAL = 0x1;
		public static uint SUBLANG_DEFAULT = 0x1;
		public static uint SUBLANG_DUTCH = 0x1;
		public static uint SUBLANG_DUTCH_BELGIAN = 0x2;
		public static uint SUBLANG_ENGLISH_AUS = 0x3;
		public static uint SUBLANG_ENGLISH_CAN = 0x4;
		public static uint SUBLANG_ENGLISH_EIRE = 0x6;
		public static uint SUBLANG_ENGLISH_NZ = 0x5;
		public static uint SUBLANG_ENGLISH_UK = 0x2;
		public static uint SUBLANG_ENGLISH_US = 0x1;
		public static uint SUBLANG_FRENCH = 0x1;
		public static uint SUBLANG_FRENCH_BELGIAN = 0x2;
		public static uint SUBLANG_FRENCH_CANADIAN = 0x3;
		public static uint SUBLANG_FRENCH_SWISS = 0x4;
		public static uint SUBLANG_GERMAN = 0x1;
		public static uint SUBLANG_GERMAN_AUSTRIAN = 0x3;
		public static uint SUBLANG_GERMAN_SWISS = 0x2;
		public static uint SUBLANG_ITALIAN = 0x1;
		public static uint SUBLANG_ITALIAN_SWISS = 0x2;
		public static uint SUBLANG_NEUTRAL = 0x0;
		public static uint SUBLANG_NORWEGIAN_BOKMAL = 0x1;
		public static uint SUBLANG_NORWEGIAN_NYNORSK = 0x2;
		public static uint SUBLANG_PORTUGUESE = 0x2;
		public static uint SUBLANG_PORTUGUESE_BRAZILIAN = 0x1;
		public static uint SUBLANG_SPANISH = 0x1;
		public static uint SUBLANG_SPANISH_MEXICAN = 0x2;
		public static uint SUBLANG_SPANISH_MODERN = 0x3;
		public static uint SUBLANG_SYS_DEFAULT = 0x2;
		public static uint SUCCESSFUL_ACCESS_ACE_FLAG = 0x40;

		public static uint LMEM_ZEROINIT = 0x40;
		public static uint LOAD_LIBRARY_AS_DATAFILE = 0x2;

		public static uint RT_ACCELERATOR = 9;
		public static uint RT_BITMAP = 2;
		public static uint RT_CURSOR = 1;
		public static uint RT_DIALOG = 5;
		public static uint RT_FONT = 8;
		public static uint RT_FONTDIR = 7;
		public static uint RT_ICON = 3;
		public static uint RT_MENU = 4;
		public static uint RT_RCDATA = 10;
		public static uint RT_STRING = 6;
		public static uint RT_MESSAGETABLE = 11;

		public static uint ERROR_ALREADY_EXISTS = 183;
		public static uint INFINITE = 0xFFFF;

		public static uint MOVEFILE_REPLACE_EXISTING = 0x1;
		public static uint FILE_ATTRIBUTE_TEMPORARY = 0x100;
		public static uint FILE_BEGIN = 0;
		public static uint FILE_SHARE_READ = 0x1;
		public static uint FILE_SHARE_WRITE = 0x2;
		public static uint CREATE_NEW = 1;
		public static uint OPEN_EXISTING = 3;
		public static uint GENERIC_READ = 0x80000000;
		public static uint GENERIC_WRITE = 0x40000000;


		public const int ANSI_CHARSET = 0;
		public const int ANSI_FIXED_FONT = 11;
		public const int OEM_CHARSET = 255;
		public const int OEM_FIXED_FONT = 10;
		public const int OUT_CHARACTER_PRECIS = 2;
		public const int OUT_DEFAULT_PRECIS = 0;
		public const int OUT_DEVICE_PRECIS = 5;
		public const int OUT_OUTLINE_PRECIS = 8;
		public const int OUT_PS_ONLY_PRECIS = 10;
		public const int OUT_RASTER_PRECIS = 6;
		public const int OUT_SCREEN_OUTLINE_PRECIS = 9;
		public const int OUT_STRING_PRECIS = 1;
		public const int OUT_STROKE_PRECIS = 3;
		public const int OUT_TT_ONLY_PRECIS = 7;
		public const int OUT_TT_PRECIS = 4;
		public const int CLIP_CHARACTER_PRECIS = 1;
		public const int CLIP_DEFAULT_PRECIS = 0;
		public const int CLIP_EMBEDDED = 128;
		public const int CLIP_LH_ANGLES = 16;
		public const int CLIP_MASK = 0xF;
		public const int CLIP_NOT = 0x0;
		public const int CLIP_STROKE_PRECIS = 2;
		public const int CLIP_SUS = 0x20;
		public const int CLIP_TO_PATH = 4097;
		public const int CLIP_TT_ALWAYS = 32;
		public const int DEFAULT_PRECIS = 0;
		public const int DEFAULT_QUALITY = 0;
		public const int FIXED_PITCH = 1;
		public const int FF_DECORATIVE = 80;
		public const int FF_DONTCARE = 0;
		public const int FF_MODERN = 48;
		public const int FF_ROMAN = 16;
		public const int FF_SCRIPT = 64;
		public const int FF_SWISS = 32;
		public const int LOGPIXELSX = 88;
		public const int LOGPIXELSY = 90;
		public const int WM_SETFONT = 0x30;
		public const int WM_GETFONT = 0x31;
		public const int EM_SETSEL = 0xB1;

		public const int NORMAL = 0;
		public const int VALUE = 1;


		public struct TEXTMETRIC 
		{ // tm  
			public int tmHeight; 
			public int tmAscent; 
			public int tmDescent; 
			public int tmInternalLeading; 
			public int tmExternalLeading; 
			public int tmAveCharWidth; 
			public int tmMaxCharWidth; 
			public int tmWeight; 
			public int tmOverhang; 
			public int tmDigitizedAspectX; 
			public int tmDigitizedAspectY; 
			public byte tmFirstChar; 
			public byte tmLastChar; 
			public byte tmDefaultChar; 
			public byte tmBreakChar; 
			public byte tmItalic; 
			public byte tmUnderlined; 
			public byte tmStruckOut; 
			public byte tmPitchAndFamily; 
			public byte tmCharSet; 
		};

		public struct SECURITY_ATTRIBUTES 
		{
			public ulong nLength; 
			public SECURITY_DESCRIPTOR lpSecurityDescriptor; 
			public int bInheritHandle; 
		};

		public struct LARGE_INTEGER
		{
			public long LowPart; // long
			public long HighPart; // long
		}


		public struct PACKET_OID_DATA
		{
			public ulong Oid;					///< OID code. See the Microsoft DDK documentation or the file ntddndis.h
			///< for a complete list of valid codes.
			public ulong Length;				///< Length of the data field
			public byte [] Data; //[1];				///< variable-lenght field that contains the information passed to or received 
			///< from the adapter.
		}; 

		//**********************************************************************
		[DllImport("gdi32.dll")] public extern static int
			GetTextMetrics(
			int hdc,	// handle of device context 
			ref TEXTMETRIC Tm 	// address of text metrics structure 
			);
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			WaitForSingleObject( int hHandle, uint dwMilliseconds );
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			QueryPerformanceFrequency(ref LARGE_INTEGER lpFrequency );
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			QueryPerformanceCounter( ref LARGE_INTEGER lpPerformanceCount ); 	// address of current counter value
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			SetEvent( int hEvent ); 	// handle of event object 
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			CloseHandle( int hObject ); 	// handle to object to close  
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			GetLastError();
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static void
			SetLastError( ulong dwErrCode ); // per-thread error code  

		[DllImport("kernel32.dll")] public extern static void
			SetLastError( int dwErrCode ); // per-thread error code  
		//**********************************************************************
		[DllImport("kernel32.dll", EntryPoint="GlobalAlloc")] public extern static char *
			GlobalAllocPtr( uint wFlags, uint dwBytes );
		//**********************************************************************
		[DllImport("kernel32.dll", EntryPoint="lstrcpyA", CharSet=CharSet.Ansi)] public extern static int
			StrCpy( int lpString1, int lpString2);
		//**********************************************************************
		[DllImport("kernel32.dll", EntryPoint="RtlMoveMemory")] public extern static int
			CopyIntToInt( int DstAddr, int SrcAddr , int length );
		//**********************************************************************
		[DllImport("kernel32.dll", EntryPoint="RtlMoveMemory")] public extern static int
			CopyIntToByte( ref byte Value , int DstAddr, int length );

		//**********************************************************************
		[DllImport("kernel32")] public static extern void
			Sleep(int dwMilliseconds);
		//**********************************************************************
		[DllImport("kernel32")] public static extern int
			GetTickCount();
		//**********************************************************************
		[DllImport("Kernel32", EntryPoint="RtlMoveMemory")] public static extern int 
			CopyMemory(int dest, int src, int length);
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			FormatMessage(
			int dwFlags,	// source and processing options 
			int lpSource,	// pointer to  message source 
			int dwMessageId,	// requested message identifier 
			int dwLanguageId,	// language identifier for requested message 
			int lpBuffer,	// pointer to message buffer 
			int nSize,	// maximum size of message buffer 
			int Arguments 	// address of array of message inserts 
			);

		[DllImport("kernel32.dll")] public extern static int
			FormatMessage(
			int dwFlags,	// source and processing options 
			int lpSource,	// pointer to  message source 
			int dwMessageId,	// requested message identifier 
			int dwLanguageId,	// language identifier for requested message 
			ref int lpBuffer,	// pointer to message buffer 
			int nSize,	// maximum size of message buffer 
			int Arguments 	// address of array of message inserts 
			);
		//**********************************************************************
		[DllImport("kernel32.dll")] public extern static int
			LocalFree( int hMem ); 	// handle of local memory object 
		//**********************************************************************
		[DllImport("user32.dll")] public static extern int
			ReleaseDC(
			int hWnd,	// handle of window 
			int hDC 	// handle of device context  
			);
		//**********************************************************************
		[DllImport("gdi32.dll")] public static extern int
			DeleteObject(
			int hObject 	// handle to graphic object  
			);
		//**********************************************************************
		[DllImport("user32.dll")] public static extern int
			GetDC(
			int hWnd 	// handle of window  
			);
		//**********************************************************************
		[DllImport("gdi32.dll")] public static extern int
			GetDeviceCaps(
			int hdc,	// device-context handle 
			int nIndex 	// index of capability to query  
			);	
		//**********************************************************************
		[DllImport("gdi32.dll")] public static extern int
			CreateFont(
			int nHeight,	// logical height of font 
			int nWidth,	// logical average character width 
			int nEscapement,	// angle of escapement 
			int nOrientation,	// base-line orientation angle 
			int fnWeight,	// font weight 
			uint fdwItalic,	// italic attribute flag 
			uint fdwUnderline,	// underline attribute flag 
			uint fdwStrikeOut,	// strikeout attribute flag 
			uint fdwCharSet,	// character set identifier 
			uint fdwOutputPrecision,	// output precision 
			uint fdwClipPrecision,	// clipping precision 
			uint fdwQuality,	// output quality 
			uint fdwPitchAndFamily,	// pitch and family 
			int lpszFace 	// pointer to typeface name string 
			);
		//**********************************************************************
		[DllImport("kernel32.dll")] public static extern int
			MulDiv(
			int nNumber,	// 32-bit signed multiplicand  
			int nNumerator,	// 32-bit signed multiplier 
			int nDenominator 	// 32-bit signed divisor 
			);
		//**********************************************************************
		[DllImport("user32.dll")] public static extern int
			SendMessage(
			int hWnd,	// handle of destination window
			uint Msg,	// message to send
			int wParam,	// first message parameter
			int lParam 	// second message parameter
			);
		//**********************************************************************

		public Function()
		{

		}


		public static byte PtrToByte( int Ptr )
		{
			byte b = Marshal.ReadByte( ( IntPtr ) Ptr );

			return b;
		}

		public static char PtrToChar( int Ptr )
		{
			byte b = Marshal.ReadByte( ( IntPtr ) Ptr );

			return ( char ) b;
		}

		public static short PtrToShort( int Ptr )
		{
			short b = Marshal.ReadInt16( ( IntPtr ) Ptr );

			return b;
		}

		public static ushort PtrToUShort( int Ptr )
		{
			ushort b = ( ushort ) Marshal.ReadInt16( ( IntPtr ) Ptr );

			return b;
		}

		public static int PtrToInt( int Ptr )
		{
			int b = Marshal.ReadInt32( ( IntPtr ) Ptr );

			return b;
		}

		public static uint PtrToUInt( int Ptr )
		{
			uint b = ( uint ) Marshal.ReadInt32( ( IntPtr ) Ptr );

			return b;
		}

		public static long PtrToLong( int Ptr )
		{
			long b = Marshal.ReadInt64( ( IntPtr ) Ptr );

			return b;
		}

		public static ulong PtrToULong( int Ptr )
		{
			ulong b = ( ulong ) Marshal.ReadInt64( ( IntPtr ) Ptr );

			return b;
		}

		public static string GetIpAddress( string SrvName )
		{
			IPHostEntry ipEntry = new IPHostEntry();
			IPAddress Ip = new IPAddress(0);

			if( SrvName.Trim() == "" )
			{
				ipEntry = Dns.Resolve( Dns.GetHostName() );
			}
			else
			{
				ipEntry = Dns.Resolve( SrvName );
			}

			Ip = ipEntry.AddressList[0];

			return Ip.ToString();

		}


		public static string GetHostName( string IpAddr )
		{
			IPHostEntry iphEntry = new IPHostEntry();

			if( IpAddr.Trim() == "" )
			{
				return Dns.GetHostName();
			}
			else
			{
				iphEntry = Dns.GetHostByAddress(IpAddr );
			}

			return iphEntry.HostName;

		}


		// Converting dotted ip address to equivalent integer value
		// Snmp
		public static int IpAddressToInt( string ipaddr )
		{

			int Rslt = 0;
			string[] strarr = new string[4];

			strarr = ipaddr.Split((char)46); // split ip address into 4 pieces
			// and make a 32 bit value
			Rslt = ( int.Parse( strarr[3] ) << 24 ) + 
				( int.Parse(strarr[2]) << 16 ) + 
				( int.Parse(strarr[1]) << 8 ) + 
				int.Parse(strarr[0]);

			return Rslt;

		}

		public static void IpAddressToByteArray( ref byte [] Data , int Index , string ipaddr )
		{

			string[] strarr = new string[4];

			strarr = ipaddr.Split((char)46); // split ip address into 4 pieces
			// and make a 32 bit value
			Data[ Index ] = byte.Parse( strarr[0] );
			Data[ Index + 1 ] = byte.Parse( strarr[1] );
			Data[ Index + 2 ] = byte.Parse( strarr[2] );
			Data[ Index + 3 ] = byte.Parse( strarr[3] );

		}


		// Convert an ip address stored an address to equivalent string value
		public static string GetPtrToIpAddr(int intPtr, int varlen)
		{
			int i = 0;
			string tmp = "";
			byte[] byx = new byte[varlen];

			// ip address cann't have zero value
			// ip address cann't have zero length
			if( ( intPtr == 0 ) || ( varlen == 0 ) ) return "";
			Marshal.Copy( ( IntPtr ) intPtr , byx , 0 , varlen );
			for( i = 0; i < varlen - 1; i ++ )
			{ tmp = tmp + byx[i].ToString() + "."; }
			tmp = tmp + byx[ varlen - 1 ].ToString();

			return tmp;

		}


		// convert a string value stored in an address to equilavent string format
		public static string GetPtrToString(int intPtr, int varlen)
		{

			int i = 0;
			string tmp = "";
			byte[] cyx = new byte[varlen];

			// string value cann't have zero value
			// string value cann't have zero length
			if( ( intPtr == 0 ) || ( varlen == 0 ) ) return "";
			Marshal.Copy( ( IntPtr ) intPtr , cyx , 0 , varlen );
			for( i = 0; i < varlen; i ++ )
			{ tmp = tmp + (char)cyx[i]; }

			return tmp;
		}

		public static void StringToBytearray( ref byte [] Data , int Index , string Str , bool AddNull )
		{
			for( int i = 0; i < Str.Length; i ++ )
				Data[ Index + i ] = (byte) Str[i];

			if( AddNull )
				Data[ Index + Str.Length ] = 0;
		}


		public static string Space( int num )
		{
			string tmp = "";
			for( int i = 0; i < num; i ++ )
				tmp += " ";

			return tmp;

		}


		public static string StrReverse( string ReverseStr )
		{
			int i;
			string Tmp = "";

			for( i = ReverseStr.Length - 1; i >= 0; i -- )
			{
				Tmp += ReverseStr[i];
			}

			return Tmp;
		}

		public static string RemovePossibleIpAddress( string strCheck )
		{
			int i,ttt;
			string Tmp = "";
			string [] Tmps;
			char [] seperator = new char[1];

			seperator[0] = (char) 46;
			Tmps = strCheck.Split(seperator);
			ttt = Tmps.GetUpperBound(0);
			if( ttt > 4 )
			{
				for( i = 0; i < ttt - 4; i ++ )
				{ Tmp += Tmps[i] + "."; }
				Tmp = Tmp.Substring(0,Tmp.Length - 1 );
			}
			else
				Tmp = strCheck;

			return Tmp;
		}


		public static string Cisco7LevelDecrypt(string encrypted, ref string ErrMessage)
		{
			int seed, i,j,k, val = 0;
			byte[] dec_pw = new byte[512];
			byte[] enc_pw = new Byte[512];
			string res;
			byte[] xlat = {0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53 , 0x55, 0x42};

			encrypted = encrypted.ToUpper();
			encrypted = encrypted.Trim();

			if( encrypted.Substring(0,2) == "7 " )
			{
				encrypted = encrypted.Substring( 2 , encrypted.Length - 2 );
			}

			res = "";
			ErrMessage = "";
			k = 0;

			for(i = 0; i < encrypted.Length; i++)
			{
				//
				enc_pw[i] = (byte) encrypted[i];
			}

			if((encrypted.Length & 1) > 0 )
			{
				ErrMessage = "Encrypted Text length cann't have odd values !!!";
				return "";
			}

			seed = (enc_pw[0] - 48) * 10 + enc_pw[1] - 48;

			if (seed > 15 || ( enc_pw[0] < 48 || enc_pw[0] > 57 ) || ( enc_pw[1] < 48 || enc_pw[1] > 57 ))
			{
				ErrMessage = "Encrypted Text has some invalid characters !!!";
				return "";
			}

			for (i = 2 ; i <= encrypted.Length; i++) 
			{
				if( i != 2 && ( ( i & 1 ) == 0 ) ) 
				{
					k = i / 2 - 2;
					if( k < 0 ) k = 0;
					dec_pw[k] = (byte) (val ^ xlat[seed++]);
					val = 0;
				}

				val *= 16;

				if(enc_pw[i] >= 48 && enc_pw[i] <= 57) 
				{
					val += enc_pw[i] - 48;
					continue;
				}

				if((enc_pw[i] >= 65) && (enc_pw[i] <= 70)) 
				{
					val += enc_pw[i] - 65 + 10;
					continue;
				}

				if(enc_pw.Length != i)
				{
					k = ( ++i / 2 ) - 1;
					dec_pw[k] = 0;
					for( j = 0; j < i + 1; j ++ )
						res += (char) dec_pw[j];

				}
			}

			return res;

		}


		public static string Cisco7LevelDecrypt( string encrypted )
		{
			int seed, i,j,k, val = 0;
			byte[] dec_pw = new byte[512];
			byte[] enc_pw = new Byte[512];
			string res;
			byte[] xlat = {0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53 , 0x55, 0x42};

			encrypted = encrypted.ToUpper();
			encrypted = encrypted.Trim();

			if( encrypted.Substring(0,2) == "7 " )
			{
				encrypted = encrypted.Substring( 2 , encrypted.Length - 2 );
			}

			res = "";
			k = 0;

			for(i = 0; i < encrypted.Length; i++)
			{ enc_pw[i] = (byte) encrypted[i]; }

			if((encrypted.Length & 1) > 0 )
			{ return ""; }

			seed = (enc_pw[0] - 48) * 10 + enc_pw[1] - 48;

			if (seed > 15 || ( enc_pw[0] < 48 || enc_pw[0] > 57 ) || ( enc_pw[1] < 48 || enc_pw[1] > 57 ))
			{ return ""; }

			for (i = 2 ; i <= encrypted.Length; i++) 
			{
				if( i != 2 && ( ( i & 1 ) == 0 ) ) 
				{
					k = i / 2 - 2;
					if( k < 0 ) k = 0;
					dec_pw[k] = (byte) (val ^ xlat[seed++]);
					val = 0;
				}

				val *= 16;

				if(enc_pw[i] >= 48 && enc_pw[i] <= 57) 
				{
					val += enc_pw[i] - 48;
					continue;
				}

				if((enc_pw[i] >= 65) && (enc_pw[i] <= 70)) 
				{
					val += enc_pw[i] - 65 + 10;
					continue;
				}

				if(enc_pw.Length != i)
				{
					k = ( ++i / 2 ) - 1;
					dec_pw[k] = 0;
					for( j = 0; j < i + 1; j ++ )
						res += (char) dec_pw[j];

				}
			}

			return res;

		}

		public static bool IsDigit( char xxx )
		{
			char[] yyy = {'0','1','2','3','4','5','6','7','8','9'};
			int i;

			for(i = 0; i < 10; i++ )
			{
				if( xxx == yyy[i] )
				{
					return true;
				}
			}

			return false;

		}


		public static string ReturnErrorMessage( Exception Ex )
		{
			string Err = "";

			Err = "Error Type is " + Ex.GetType().ToString() + (char) 13 + (char) 10;
			Err += "Error Source is " + Ex.Source + (char) 13 + (char) 10;
			Err += "Error Trace is " + Ex.StackTrace + (char) 13 + (char) 10;
			Err += "Error Message is " + Ex.Message;

			return Err;
		}


		public static bool CheckTFTPServer()
		{
			bool IsTftpServerRunning = false;

			try
			{
				IPHostEntry ipHostEntry = new IPHostEntry();
				ipHostEntry = Dns.Resolve( Dns.GetHostName() );

				IPEndPoint ipEndPoint = new IPEndPoint( ipHostEntry.AddressList[0] , 69 );
				Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram,ProtocolType.Udp );
				socket.Bind( ipEndPoint );
				socket.Connect( ipEndPoint );
				socket.Close();
			}
			catch
			{
				IsTftpServerRunning = true;
			}

			return IsTftpServerRunning;

		}

		public static int CharPos(string SrchStr, char SrchChr , int StartIndex )
		{
			int i;

			if( SrchStr == "" )
			{ return (-1); }

			for( i = StartIndex; i <= SrchStr.Length; i ++ )
			{
				if( SrchStr[i] == SrchChr )
					return i;
			}

			return (-1);

		}

		public static void CopyStrToChr( string Src, ref char [] Dst )
		{
			for( int i = 0; i < Src.Length; i ++ )
				Dst[i] = Src[i];
		}

		public static string [] ReFormatGetStrings( byte [] Unformatted )
		{
			int i = 0;
			int Size = Unformatted.GetLength(0);
			byte [] NewArray;
			int RealLength = 0;
			string FullNames = "";
			string [] Names;
			char [] separator = new char[1];
		
			separator[0] = (char) 59;

			for( i = Size - 1; i >=0 ; i -- )
			{
				if( Unformatted[i] != 0 )
				{
					RealLength = i + 1;
					break;
				}
			}

			if( RealLength == 0 ) RealLength = Size;

			NewArray = new byte[ RealLength ];

			for( i = 0; i < RealLength; i ++ )
			{
				if( Unformatted[i] == 0 )
					NewArray[i] = 35;
				else
					NewArray[i] = Unformatted[i];

			}

			FullNames = Encoding.ASCII.GetString( NewArray );
			FullNames = FullNames.Replace( "####" , ";" );
			FullNames = FullNames.Replace( "##" , ";" );
			FullNames = FullNames.Replace( "#" , "" );
			FullNames = FullNames.Trim();
			Names = FullNames.Split( separator );

			return Names;

		}

		public static int MakeLangId( uint p, uint s)
		{ return (int) ( s * 1024 + p ); }


		public static string GetSystemErrorMessage( int ErrorNo )
		{
			string Tmp = "";
			int error = 0;
			int Buffer = 0;
			byte b = 0;

			int Result = FormatMessage( 
				(int) ( FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM ),
				0,
				ErrorNo,
				MakeLangId( LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				ref Buffer,
				4096,
				0 
				);

			if( Result == 0 )
			{
				error = GetLastError();
				return "";
			}

			b = Marshal.ReadByte( ( IntPtr ) ( Buffer + 1 ) );
			if( b == 0 )
				Tmp = Marshal.PtrToStringUni( ( IntPtr ) Buffer );
			else
				Tmp = Marshal.PtrToStringAnsi( ( IntPtr ) Buffer );

			LocalFree( Buffer );

			return Tmp;

		}

		public static ushort Get2Bytes( byte [] ptr , ref int Index , int Type )
		{
			ushort u = 0;

			if( Type == NORMAL )
			{
				u = ( ushort ) ptr[ Index++ ];
				u *= 256;
				u += ( ushort ) ptr[ Index++ ];
			}
			else if( Type == VALUE )
			{
				u = ( ushort ) ptr[ ++Index ];
				u *= 256; Index--;
				u += ( ushort ) ptr[ Index++ ]; Index++;
			}

			return u;
		}

		public static void Set2Bytes( ref byte [] ptr , ref int Index , ushort NewValue , int Type )
		{

			if( Type == NORMAL )
			{
				ptr[ Index ] = (byte) ( NewValue >> 8 );
				ptr[ Index + 1 ] = (byte) NewValue ;
			}
			else if( Type == VALUE )
			{
				ptr[ Index + 0 ] = (byte) NewValue;
				ptr[ Index + 1 ] = (byte) ( NewValue >> 8 );
				Index += 2;
			}

		}


		public static uint Get3Bytes( byte [] ptr , ref int Index , int Type )
		{
			uint ui = 0;

			if( Type == NORMAL )
			{
				ui = ( (uint) ptr[ Index++ ] ) << 16;
				ui += ( (uint) ptr[ Index++ ] ) << 8;
				ui += (uint) ptr[ Index++ ];
			}

			return ui;
		}


		public static uint Get4Bytes( byte [] ptr , ref int Index , int Type )
		{
			uint ui = 0;

			if( Type == NORMAL )
			{
				ui = ( (uint) ptr[ Index++ ] ) << 24; 
				ui += ( (uint) ptr[ Index++ ] ) << 16;
				ui += ( (uint) ptr[ Index++ ] ) << 8;
				ui += (uint) ptr[ Index++ ];
			}
			else if( Type == VALUE )
			{
				ui = ( (uint) ptr[ Index + 3 ] ) << 24; 
				ui += ( (uint) ptr[ Index + 2 ] ) << 16;
				ui += ( (uint) ptr[ Index + 1 ] ) << 8;
				ui += (uint) ptr[ Index ]; Index += 4;
			}

			return ui;
		}

		public static void Set4Bytes( ref byte [] ptr , int Index , uint NewValue , int Type )
		{

			if( Type == NORMAL )
			{
				ptr[ Index + 1 ] = (byte) ( NewValue >> 24 );
				ptr[ Index + 2 ] = (byte) ( NewValue >> 16 );
				ptr[ Index + 3 ] = (byte) ( NewValue >> 8 );
				ptr[ Index + 4 ] = (byte) NewValue ;
			}
			else if( Type == VALUE )
			{
				ptr[ Index + 0 ] = (byte) NewValue;
				ptr[ Index + 1 ] = (byte) ( NewValue >> 8 );
				ptr[ Index + 2 ] = (byte) ( NewValue >> 16 );
				ptr[ Index + 3 ] = (byte) ( NewValue >> 24 );
			}

		}

		public static ulong Get8Bytes( byte [] ptr , ref int Index , int Type )
		{
			ulong ui = 0;

			if( Type == NORMAL )
			{
				ui =  ( (uint) ptr[ Index++ ] ) << 56; 
				ui += ( (uint) ptr[ Index++ ] ) << 48; 
				ui += ( (uint) ptr[ Index++ ] ) << 40; 
				ui += ( (uint) ptr[ Index++ ] ) << 32; 
				ui += ( (uint) ptr[ Index++ ] ) << 24; 
				ui += ( (uint) ptr[ Index++ ] ) << 16;
				ui += ( (uint) ptr[ Index++ ] ) << 8;
				ui += (uint) ptr[ Index++ ];
			}
			else if( Type == VALUE )
			{
				ui =  ( (uint) ptr[ Index + 7 ] ) << 56; 
				ui += ( (uint) ptr[ Index + 6 ] ) << 48; 
				ui += ( (uint) ptr[ Index + 5 ] ) << 40; 
				ui += ( (uint) ptr[ Index + 4 ] ) << 32; 
				ui += ( (uint) ptr[ Index + 3 ] ) << 24; 
				ui += ( (uint) ptr[ Index + 2 ] ) << 16;
				ui += ( (uint) ptr[ Index + 1 ] ) << 8;
				ui += (uint) ptr[ Index ]; Index += 8;
			}

			return ui;
		}

		public static void Set8Bytes( ref byte [] ptr , int Index , ulong NewValue , int Type )
		{
			if( Type == NORMAL )
			{
				ptr[ Index ] =  (byte) ( NewValue >> 56 ); 
				ptr[ Index + 1 ] =  (byte) ( NewValue >> 48 ); 
				ptr[ Index + 2 ] =  (byte) ( NewValue >> 40 ); 
				ptr[ Index + 3 ] =  (byte) ( NewValue >> 32 ); 
				ptr[ Index + 4 ] =  (byte) ( NewValue >> 24 ); 
				ptr[ Index + 5 ] =  (byte) ( NewValue >> 16 ); 
				ptr[ Index + 6 ] =  (byte) ( NewValue >> 8 ); 
				ptr[ Index + 7 ] =  (byte) NewValue;
			}
			else if( Type == VALUE )
			{
				ptr[ Index + 7 ] =  (byte) ( NewValue >> 56 ); 
				ptr[ Index + 6 ] =  (byte) ( NewValue >> 48 ); 
				ptr[ Index + 5 ] =  (byte) ( NewValue >> 40 ); 
				ptr[ Index + 4 ] =  (byte) ( NewValue >> 32 ); 
				ptr[ Index + 3 ] =  (byte) ( NewValue >> 24 ); 
				ptr[ Index + 2 ] =  (byte) ( NewValue >> 16 ); 
				ptr[ Index + 1 ] =  (byte) ( NewValue >> 8 ); 
				ptr[ Index ] =  (byte) NewValue;
			}

		}

		public static string GetIpAddress( byte [] ptr , ref int Index )
		{
			string str = "";

			str += ptr[ Index++ ].ToString() + ".";
			str += ptr[ Index++ ].ToString() + ".";
			str += ptr[ Index++ ].ToString() + ".";
			str += ptr[ Index++ ].ToString();

			return str;
		}

		public static string GetIpAddress( byte [] ptr , ref int Index , int Length )
		{
			string str = "";
			int i = 0;

			for( i = 0; i < Length - 1; i ++ )
				str += ptr[ Index++ ].ToString() + ".";

			str += ptr[ Index++ ].ToString();

			return str;
		}

		public static int MakeFont( int Handle )
		{
			int iFontSize = 10;
			int hFont = 0;
			int CurrentFont = 0;
			int hdc = GetDC( Handle );

			int nHeight = -MulDiv( iFontSize, GetDeviceCaps(hdc, LOGPIXELSY), 72 ); //72);
			ReleaseDC( Handle , hdc );
			int cset;
			cset = ANSI_CHARSET;
			CurrentFont = SendMessage( Handle , WM_GETFONT , 0 , 0 );
			hFont = CreateFont( nHeight,0,0,0,700,0,0,0,(uint)cset,OUT_DEFAULT_PRECIS,
				CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FIXED_PITCH | FF_DONTCARE,0);

			SendMessage( Handle , WM_SETFONT , hFont , 0x00010000 );
			if( CurrentFont > 0 )
				DeleteObject( CurrentFont );

			return 1;
		}


		private static string PadZeros( int inInt )
		{
			StringBuilder TextField = new StringBuilder();

			string hex = Convert.ToString( inInt , 16 );

			if( hex.Length < 8 )
			{
				int ix = 8-hex.Length;
				for( int i = 0; i < ix; ++i )
				{
					TextField.Append( "0" );
				}
			}
			TextField.Append( hex );
			return TextField.ToString().ToUpper();
		}


		private static string ConvertByteToHexString( byte inByte )
		{
			StringBuilder TextField = new StringBuilder();

			string hex = Convert.ToString( inByte , 16 );

			if( hex.Length == 1 )
				TextField.Append( "0" );

			TextField.Append( hex );

			return TextField.ToString().ToLower();
		}


		public static string GetHexString( byte [] mData )
		{
			StringBuilder HexField = new StringBuilder();
			StringBuilder TextField = new StringBuilder();
			string HeaderStr = "";
			string HeaderStr2 = "";
			byte [] Data;
			int i = 0;

			int newrow = 0;
			int global = 0;
			string hex = " ";
			string numb = " ";
			string Tmp = "";
			int LastRow = mData.GetLength(0) / 16;
			int RemainingBytes = ( LastRow * 16 ) - mData.GetLength(0);

			if( RemainingBytes < 0 ) 
			{
				LastRow++;
				RemainingBytes += 16;
			}

			Data = new byte[ LastRow * 16 ];
			for (i = 0; i < mData.Length; ++i )
			{
				Data[i] = mData[i];
			}

			HeaderStr =  " Offset   ";
			HeaderStr2 = " ---------";
			for( i = 0; i < 16; i ++ )
			{
				HeaderStr += " " + i.ToString("d02");
				HeaderStr2 += "---";
			}

			HexField.Append( HeaderStr + "                  \n" );
			HexField.Append( HeaderStr2 + "-------------------\n" );

			for (i = 0; i < Data.Length; ++i )
			{
				if( newrow == 0 )
				{
					numb = PadZeros( global );
					HexField.Append( " " + numb + " " );
					global += 16;
				}

				hex = ConvertByteToHexString( Data[i] );

				HexField.Append( " " + hex );	// 3 characters

				int g = Data[i];
				if( g > 31 && g < 127 )
				{
					TextField.Append( (char) Data[i] );
				}
				else
				{
					TextField.Append( "." );
				}

				++newrow;

				if( newrow >= 16 )
				{
					HexField.Append( "   " + TextField.ToString() + "\n" );
					TextField = new StringBuilder();
					newrow = 0;
				}
			}

			HexField.Append( "\n\n" );
			Tmp = HexField.ToString();

			return Tmp;
		}


		public static string ReFormatString( object Value , object AdditionalValue )
		{
			string tmp = Value.GetType().ToString();
			string ret = "", Ad = "";
			byte b = 0;
			ushort u = 0;
			short s = 0;
			uint ui = 0;
			int i = 0;
			ulong ul = 0;
			long l = 0;
			
			if( AdditionalValue != null )
				Ad = (string) AdditionalValue;

			if( tmp == "System.Byte" )
			{
				b = (byte) Value;
				ret = " 0x" + b.ToString("x02") + "( " + b.ToString() + " ) ";
			}
			else if( tmp == "System.UInt16" )
			{
				u = (ushort) Value;
				ret = " 0x" + u.ToString("x04") + "( " + u.ToString() + " ) ";
			}
			else if( tmp == "System.Int16" )
			{
				s = (short) Value;
				ret = " 0x" + s.ToString("x04") + "( " + s.ToString() + " ) ";
			}
			else if( tmp == "System.UInt32" )
			{
				ui = (uint) Value;
				ret = " 0x" + ui.ToString("x08") + "( " + ui.ToString() + " ) ";
			}
			else if( tmp == "System.Int32" )
			{
				i = (int) Value;
				ret = " 0x" + i.ToString("x08") + "( " + i.ToString() + " ) ";
			}
			else if( tmp == "System.UInt64" )
			{
				ul = (ulong) Value;
				ret = " 0x" + ul.ToString("x16") + "( " + ul.ToString() + " ) ";
			}
			else if( tmp == "System.Int64" )
			{
				l = (long) Value;
				ret = " 0x" + l.ToString("x16") + "( " + l.ToString() + " ) ";
			}

			if( Ad != "" )
				ret += Ad;

			return ret;
		}


		public static string GetObjectType( object o )
		{
			string tmp = o.GetType().ToString();
			int pluspos = tmp.IndexOf( "+" );

			if( pluspos >= 0 )
				tmp = tmp.Substring( pluspos + 1 , tmp.Length - pluspos - 1 );

			return tmp;
		}


		public static string GetNetBiosName( byte [] Data , ref int Index , ref byte NameNumber )
		{
			string Tmp = "";
			byte b1 = 0, b2 = 0;
			int i = 0;

			while( Data[ Index ] == 0 ) Index ++;
			if( Data[ Index ] == 32 ) Index ++;

			for( i = 0; i < 15; i ++ )
			{
				b1 = Data[ Index ++ ]; b2 = Data[ Index ++ ];
				b1 &= 0x0f; b2 &= 0x0f;
				b1 <<= 4; b1 += b2; b1 -= 17;
				Tmp += (char) b1;
			}

			Tmp = Tmp.Trim();

			b1 = Data[ Index ++ ]; b2 = Data[ Index ++ ];
			b1 &= 0x0f; b2 &= 0x0f;
			b1 <<= 4; b1 += b2; b1 -= 17;
			Tmp += "<" + b1.ToString("x02") + ":" + b1.ToString() + ">";
			Index ++;

			NameNumber = b1;

			return Tmp;

		}

		public static string GetNetBiosNameSerial( byte [] Data , ref int Index , ref byte NameNumber )
		{
			string Tmp = "";
			byte b1 = 0;
			int i = 0;

			while( Data[ Index ] == 0 ) Index ++;

			for( i = 0; i < 15; i ++ )
			{
				Tmp += (char) Data[ Index ++ ];
			}

			Tmp = Tmp.Trim();

			b1 = Data[ Index ++ ];
			Tmp += "<" + b1.ToString("x02") + ":" + b1.ToString() + ">";

			NameNumber = b1;

			return Tmp;

		}

		public static string DecodeBitField( byte Value , uint Mask , string TrueText , string FalseText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			byte b = 0, mb = 0, tb = 0;
			string ExpStr = "";
			string ReturnStr = "";
			int iii = 0, k = 0;

			GroupLength = 2;
			b = Value;
			mb = (byte) Mask;
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			if( ( b & mb ) > 0 ) ExpStr = TrueText;
			else ExpStr = FalseText;

			iii = 0;
			tb = mb;
			while( tb > 0 ) { iii ++; tb >>= 1; }
			MyArray[ MyArray.GetLength(0) - iii ] = ( b & mb ) > 0 ? (byte) 49 : (byte) 48;
			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + ExpStr;

			return ReturnStr;

		}

		public static string DecodeBitField( byte Value , int Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( Value , (uint) Mask , TrueText , FalseText );
		}

		public static string DecodeBitField( ushort Value , uint Mask , string TrueText , string FalseText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			ushort b = 0, mb = 0, tb = 0;
			string ExpStr = "";
			string ReturnStr = "";
			int iii = 0, k = 0;

			GroupLength = 4;
			b = Value;
			mb = (ushort) Mask;
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			if( ( b & mb ) > 0 ) ExpStr = TrueText;
			else ExpStr = FalseText;

			iii = 0;
			tb = mb;
			while( tb != 0 ) { iii ++; tb >>= 1; }
			MyArray[ MyArray.GetLength(0) - iii ] = ( b & mb ) > 0 ? (byte) 49 : (byte) 48;
			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + ExpStr;

			return ReturnStr;

		}


		public static string DecodeBitField( short Value , uint Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( (ushort) Value , Mask , TrueText , FalseText );
		}

		public static string DecodeBitField( short Value , int Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( (ushort) Value , (uint) Mask , TrueText , FalseText );
		}

		public static string DecodeBitField( ushort Value , int Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( Value , (uint) Mask , TrueText , FalseText );
		}


		public static string DecodeBitField( uint Value , uint Mask , string TrueText , string FalseText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			uint b = 0, mb = 0, tb = 0;
			string ExpStr = "";
			string ReturnStr = "";
			int iii = 0, k = 0;

			GroupLength = 8;
			b = Value;
			mb = Mask;
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			if( ( b & mb ) > 0 ) ExpStr = TrueText;
			else ExpStr = FalseText;

			iii = 0;
			tb = mb;
			while( tb > 0 ) { iii ++; tb >>= 1; }
			MyArray[ MyArray.GetLength(0) - iii ] = ( b & mb ) > 0 ? (byte) 49 : (byte) 48;
			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + ExpStr;

			return ReturnStr;

		}

		public static string DecodeBitField( int Value , uint Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( (uint) Value , Mask , TrueText , FalseText );
		}

		public static string DecodeBitField( int Value , int Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( (uint) Value , (uint) Mask , TrueText , FalseText );
		}

		public static string DecodeBitField( uint Value , int Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( (uint) Value , (uint) Mask , TrueText , FalseText );
		}

		public static string DecodeBitField( ulong Value , ulong Mask , string TrueText , string FalseText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			ulong b = 0, mb = 0, tb = 0;
			string ExpStr = "";
			string ReturnStr = "";
			int iii = 0, k = 0;

			GroupLength = 16;
			b = Value;
			mb = Mask;
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			if( ( b & mb ) > 0 ) ExpStr = TrueText;
			else ExpStr = FalseText;

			iii = 0;
			tb = mb;
			while( tb > 0 ) { iii ++; tb >>= 1; }
			MyArray[ MyArray.GetLength(0) - iii ] = ( b & mb ) > 0 ? (byte) 49 : (byte) 48;
			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + ExpStr;

			return ReturnStr;

		}

		public static string DecodeBitField( long Value , ulong Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( (ulong) Value , Mask , TrueText , FalseText );
		}

		public static string DecodeBitField( long Value , long Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( (ulong) Value , (ulong) Mask , TrueText , FalseText );
		}

		public static string DecodeBitField( ulong Value , long Mask , string TrueText , string FalseText )
		{
			return DecodeBitField( (ulong) Value , (ulong) Mask , TrueText , FalseText );
		}


		public static string DecodeBitField( byte Value , uint Mask , string ValueText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			byte s = 0, ms = 0, ts = 0;
			string ReturnStr = "";
			int iii = 0, k = 0;
			byte [] BitArray;

			GroupLength = 2;
			s = Value;
			ms = (byte) Mask;
			s &= ms;
			BitArray = GetBytes( ms );
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			iii = 0;
			ts = ms;
			for( iii = 0; iii < 8; iii ++ )
			{
				if( BitArray[iii] == 1 )
				{
					ts = (byte) ( 1 << iii );
					if( ( ts & s ) > 0 ) 
						MyArray[ iii ] = (byte) 49;
					else
						MyArray[ iii ] = (byte) 48;
				}
			}
			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + s.ToString();

			ReturnStr += " ( " + ValueText + " )";

			return ReturnStr;

		}

		public static string DecodeBitField( byte Value , int Mask , string ValueText )
		{
			return DecodeBitField( Value , (uint) Mask , ValueText );
		}

		public static string DecodeBitField( ushort Value , uint Mask , string ValueText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			ushort s = 0, ms = 0, ts = 0;
			string ReturnStr = "";
			int iii = 0, k = 0;
			byte [] BitArray;

			GroupLength = 4;
			s = Value;
			ms = (ushort) Mask;
			s &= ms;
			BitArray = GetBytes( ms );
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			iii = 0;
			ts = ms;
			for( iii = 0; iii < 16; iii ++ )
			{
				if( BitArray[iii] == 1 )
				{
					ts = (ushort) ( 1 << iii );
					if( ( ts & s ) > 0 ) 
						MyArray[ iii ] = (byte) 49;
					else
						MyArray[ iii ] = (byte) 48;
				}
			}
			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + s.ToString();

			ReturnStr += " ( " + ValueText + " )";

			return ReturnStr;

		}


		public static string DecodeBitField( short Value , uint Mask , string ValueText )
		{
			return DecodeBitField( (ushort) Value , Mask , ValueText );
		}

		public static string DecodeBitField( short Value , int Mask , string ValueText )
		{
			return DecodeBitField( (ushort) Value , (uint) Mask , ValueText );
		}

		public static string DecodeBitField( ushort Value , int Mask , string ValueText )
		{
			return DecodeBitField( Value , (uint) Mask , ValueText );
		}


		public static string DecodeBitField( uint Value , uint Mask , string ValueText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			uint s = 0, ms = 0, ts = 0;
			string ReturnStr = "";
			int iii = 0, k = 0;
			byte [] BitArray;

			GroupLength = 8;
			s = Value;
			ms = Mask;
			s &= ms;
			BitArray = GetBytes( ms );
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			iii = 0;
			ts = ms;
			for( iii = 0; iii < 32; iii ++ )
			{
				if( BitArray[iii] == 1 )
				{
					ts = (uint) ( 1 << iii );
					if( ( ts & s ) > 0 ) 
						MyArray[ iii ] = (byte) 49;
					else
						MyArray[ iii ] = (byte) 48;
				}
			}
			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + s.ToString();

			ReturnStr += " ( " + ValueText + " )";

			return ReturnStr;

		}


		public static string DecodeBitField( int Value , uint Mask , string ValueText )
		{
			return DecodeBitField( (uint) Value , Mask , ValueText );
		}

		public static string DecodeBitField( int Value , int Mask , string ValueText )
		{
			return DecodeBitField( (uint) Value , (uint) Mask , ValueText );
		}

		public static string DecodeBitField( uint Value , int Mask , string ValueText )
		{
			return DecodeBitField( Value , (uint) Mask , ValueText );
		}


		public static string DecodeBitField( ulong Value , ulong Mask , string ValueText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			ulong s = 0, ms = 0, ts = 0;
			string ReturnStr = "";
			int iii = 0, k = 0;
			byte [] BitArray;

			GroupLength = 16;
			s = Value;
			ms = Mask;
			s &= ms;
			BitArray = GetBytes( ms );
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			iii = 0;
			ts = ms;
			for( iii = 0; iii < 64; iii ++ )
			{
				if( BitArray[iii] == 1 )
				{
					ts = (ulong) ( 1 << iii );
					if( ( ts & s ) > 0 ) 
						MyArray[ iii ] = (byte) 49;
					else
						MyArray[ iii ] = (byte) 48;
				}
			}
			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + s.ToString();

			ReturnStr += " ( " + ValueText + " )";

			return ReturnStr;

		}

		public static string DecodeBitField( long Value , ulong Mask , string ValueText )
		{
			return DecodeBitField( (ulong) Value , Mask , ValueText );
		}

		public static string DecodeBitField( long Value , long Mask , string ValueText )
		{
			return DecodeBitField( (ulong) Value , (ulong) Mask , ValueText );
		}

		public static string DecodeBitField( ulong Value , long Mask , string ValueText )
		{
			return DecodeBitField( Value , (ulong) Mask , ValueText );
		}

		public static string DecodeBitField( byte Value , uint Mask , string [] ValueText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			byte b = 0, mb = 0, tb = 0;
			string ReturnStr = "";
			int iii = 0, k = 0;
			byte [] BitArray;
			int ShiftCount = 0;

			GroupLength = 2;
			b = Value;
			mb = ( byte ) Mask;
			b &= mb;
			k = (int) mb;
			while( ( k & 0x1 ) == 0 )
			{
				ShiftCount ++;
				k >>= 1;
			}
			BitArray = GetBytes( mb );
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			iii = 0;
			tb = mb;
			for( iii = 0; iii < 8; iii ++ )
			{
				if( BitArray[iii] == 1 )
				{
					tb = (byte) ( 1 << iii );
					if( ( tb & b ) > 0 ) 
						MyArray[ iii ] = (byte) 49;
					else
						MyArray[ iii ] = (byte) 48;
				}
			}

			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + b.ToString() + " ( " + ValueText[ b >> ShiftCount ] + " )";

			return ReturnStr;

		}

		public static string DecodeBitField( byte Value , int Mask , string [] ValueText )
		{
			return DecodeBitField( Value , (uint) Mask , ValueText );
		}


		public static string DecodeBitField( ushort Value , uint Mask , string [] ValueText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			ushort b = 0, mb = 0, tb = 0;
			string ReturnStr = "";
			int iii = 0, k = 0;
			byte [] BitArray;
			int ShiftCount = 0;

			GroupLength = 4;
			b = Value;
			mb = (ushort) Mask;
			b &= mb;
			k = (int) mb;
			while( ( k & 0x1 ) == 0 )
			{
				ShiftCount ++;
				k >>= 1;
			}
			BitArray = GetBytes( mb );
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			iii = 0;
			tb = mb;
			for( iii = 0; iii < 16; iii ++ )
			{
				if( BitArray[iii] == 1 )
				{
					tb = (ushort) ( 1 << iii );
					if( ( tb & b ) > 0 ) 
						MyArray[ iii ] = (byte) 49;
					else
						MyArray[ iii ] = (byte) 48;
				}
			}

			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + b.ToString() + " ( " + ValueText[ b >> ShiftCount ] + " )";

			return ReturnStr;

		}

		public static string DecodeBitField( short Value , uint Mask , string [] ValueText )
		{
			return DecodeBitField( (ushort) Value , Mask , ValueText );
		}

		public static string DecodeBitField( short Value , int Mask , string [] ValueText )
		{
			return DecodeBitField( (ushort) Value , (uint) Mask , ValueText );
		}

		public static string DecodeBitField( ushort Value , int Mask , string [] ValueText )
		{
			return DecodeBitField( Value , (uint) Mask , ValueText );
		}


		public static string DecodeBitField( uint Value , uint Mask , string [] ValueText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			uint b = 0, mb = 0, tb = 0;
			string ReturnStr = "";
			int iii = 0;
			uint k = 0;
			byte [] BitArray;
			int ShiftCount = 0;

			GroupLength = 8;
			b = Value;
			mb = Mask;
			b &= mb;
			k = (uint) mb;
			while( ( k & 0x1 ) == 0 )
			{
				ShiftCount ++;
				k >>= 1;
			}
			BitArray = GetBytes( mb );
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			iii = 0;
			tb = mb;
			for( iii = 0; iii < 32; iii ++ )
			{
				if( BitArray[iii] == 1 )
				{
					tb = (uint) ( 1 << iii );
					if( ( tb & b ) > 0 ) 
						MyArray[ iii ] = (byte) 49;
					else
						MyArray[ iii ] = (byte) 48;
				}
			}

			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + b.ToString() + " ( " + ValueText[ b >> ShiftCount ] + " )";

			return ReturnStr;

		}

		public static string DecodeBitField( int Value , uint Mask , string [] ValueText )
		{
			return DecodeBitField( (uint) Value , Mask , ValueText );
		}

		public static string DecodeBitField( int Value , int Mask , string [] ValueText )
		{
			return DecodeBitField( (uint) Value , (uint) Mask , ValueText );
		}

		public static string DecodeBitField( uint Value , int Mask , string [] ValueText )
		{
			return DecodeBitField( Value , (uint) Mask , ValueText );
		}

		public static string DecodeBitField( ulong Value , ulong Mask , string [] ValueText )
		{
			byte [] MyArray;
			int GroupLength = 0;
			ulong b = 0, mb = 0, tb = 0;
			string ReturnStr = "";
			int iii = 0;
			ulong k = 0;
			byte [] BitArray;
			int ShiftCount = 0;

			GroupLength = 16;
			b = Value;
			mb = Mask;
			b &= mb;
			k = (ulong) mb;
			while( ( k & 0x1 ) == 0 )
			{
				ShiftCount ++;
				k >>= 1;
			}
			BitArray = GetBytes( mb );
			MyArray = new byte[ GroupLength * 4 ];
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
				MyArray[ iii  ] = 46;

			iii = 0;
			tb = mb;
			for( iii = 0; iii < 64; iii ++ )
			{
				if( BitArray[iii] == 1 )
				{
					tb = (ulong) ( 1 << iii );
					if( ( tb & b ) > 0 ) 
						MyArray[ iii ] = (byte) 49;
					else
						MyArray[ iii ] = (byte) 48;
				}
			}

			k = 0;
			ReturnStr = "";
			for( iii = 0; iii < MyArray.GetLength(0); iii ++ )
			{
				if( k == 3 )
				{
					ReturnStr += (char) MyArray[ iii ] + " ";
					k = 0;
				}
				else
				{
					ReturnStr += (char) MyArray[ iii ];
					k ++;
				}
			}

			ReturnStr += "= " + b.ToString() + " ( " + ValueText[ b >> ShiftCount ] + " )";

			return ReturnStr;

		}

		public static string DecodeBitField( long Value , ulong Mask , string [] ValueText )
		{
			return DecodeBitField( (ulong) Value , Mask , ValueText );
		}

		public static string DecodeBitField( long Value , long Mask , string [] ValueText )
		{
			return DecodeBitField( (ulong) Value , (ulong) Mask , ValueText );
		}

		public static string DecodeBitField( ulong Value , long Mask , string [] ValueText )
		{
			return DecodeBitField( Value , (ulong) Mask , ValueText );
		}

		public static short Swap( short s )
		{
			short b1 = 0, b2 = 0;
			short rs;

			b1 = (short) ( ( s >> 8 ) & 0x00ff );
			b2 = (short) ( ( s & 0x00ff ) << 8 );
			rs = (short) ( b1 + b2 );

			return rs;
		}

		public static ushort Swap( ushort us )
		{
			ushort b1 = 0, b2 = 0;
			ushort rus;

			b1 = (ushort) ( ( us >> 8 ) & 0x00ff );
			b2 = (ushort) ( ( us & 0x00ff ) << 8 );
			rus = (ushort) ( b1 + b2 );

			return rus;
		}

		public static int Swap( int i )
		{
			int b1 = 0, b2 = 0, b3 = 0, b4 = 0;
			int ri;

			b1 = ( i >> 24 ) & 0x000000ff;
			b2 = ( ( i >> 16 ) & 0x000000ff ) << 8;
			b3 = ( ( i >> 8 ) & 0x000000ff ) << 16;
			b4 = ( i & 0x000000ff ) << 24;

			ri = b1 + b2 + b3 + b4;

			return ri;
		}

		public static uint Swap( uint ui )
		{
			uint b1 = 0, b2 = 0, b3 = 0, b4 = 0;
			uint rui;

			b1 = ( ui >> 24 ) & 0x000000ff;
			b2 = ( ( ui >> 16 ) & 0x000000ff ) << 8;
			b3 = ( ( ui >> 8 ) & 0x000000ff ) << 16;
			b4 = ( ui & 0x000000ff ) << 24;

			rui = b1 + b2 + b3 + b4;

			return rui;
		}

		public static long Swap( long l )
		{
			long b1 = 0, b2 = 0, b3 = 0, b4 = 0;
			long b5 = 0, b6 = 0, b7 = 0, b8 = 0;
			long rl;

			b1 = ( ( l >> 56 ) & 0x00000000000000ff );
			b2 = ( ( l >> 48 ) & 0x00000000000000ff ) << 8;
			b3 = ( ( l >> 40 ) & 0x00000000000000ff ) << 16;
			b4 = ( ( l  >> 32 ) & 0x00000000000000ff ) << 24;
			b5 = ( ( l >> 24 ) & 0x00000000000000ff ) << 32;
			b6 = ( ( l >> 16 ) & 0x00000000000000ff ) << 40;
			b7 = ( ( l >> 8 ) & 0x00000000000000ff ) << 48;
			b8 = ( l & 0x00000000000000ff ) << 56;

			rl = b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8;

			return rl;
		}

		public static ulong Swap( ulong ul )
		{
			ulong b1 = 0, b2 = 0, b3 = 0, b4 = 0;
			ulong b5 = 0, b6 = 0, b7 = 0, b8 = 0;
			ulong url;

			b1 = ( ( ul >> 56 ) & 0x00000000000000ff );
			b2 = ( ( ul >> 48 ) & 0x00000000000000ff ) << 8;
			b3 = ( ( ul >> 40 ) & 0x00000000000000ff ) << 16;
			b4 = ( ( ul  >> 32 ) & 0x00000000000000ff ) << 24;
			b5 = ( ( ul >> 24 ) & 0x00000000000000ff ) << 32;
			b6 = ( ( ul >> 16 ) & 0x00000000000000ff ) << 40;
			b7 = ( ( ul >> 8 ) & 0x00000000000000ff ) << 48;
			b8 = ( ul & 0x00000000000000ff ) << 56;

			url = b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8;

			return url;
		}

		public static byte [] GetBytes( byte val )
		{
			byte [] retbyte = new byte[8];
			int i = 0;
			int tmp = ( (int) val ) & 0xff;

			for( i = 0; i < 8; i ++ )
			{
				if( ( ( tmp >> i ) & 0x1 ) > 0 ) retbyte[7-i] = 1;
				else retbyte[7-i] = 0;
			}

			return retbyte;
		}

		public static byte [] GetBytes( short val )
		{
			byte [] retbyte = new byte[16];
			int i = 0;
			int tmp = ( (int) val ) & 0xffff;

			for( i = 0; i < 16; i ++ )
			{
				if( ( ( tmp >> i ) & 0x1 ) > 0 ) retbyte[15-i] = 1;
				else retbyte[15-i] = 0;
			}

			return retbyte;
		}

		public static byte [] GetBytes( ushort val )
		{
			return GetBytes( (short) val );
		}

		public static byte [] GetBytes( int val )
		{
			byte [] retbyte = new byte[32];
			int i = 0;
			int tmp = (int) ( val & 0xffffffff );

			for( i = 0; i < 32; i ++ )
			{
				if( ( ( tmp >> i ) & 0x1 ) > 0 ) retbyte[31-i] = 1;
				else retbyte[31-i] = 0;
			}

			return retbyte;
		}

		public static byte [] GetBytes( uint val )
		{
			return GetBytes( (int) val );
		}

		public static byte [] GetBytes( long val )
		{
			byte [] retbyte = new byte[64];
			int i = 0;
			long tmp = (long) ( ( (ulong) val ) & 0xffffffffffffffff );

			for( i = 0; i < 32; i ++ )
			{
				if( ( ( tmp >> i ) & 0x1 ) > 0 ) retbyte[63-i] = 1;
				else retbyte[63-i] = 0;
			}

			return retbyte;
		}


		public static byte [] GetBytes( ulong val )
		{
			return GetBytes( (long) val );
		}


		public static string GetMACAddress( byte [] PacketData , ref int Index )
		{
			string Tmp = "";
			int i = 0;

			for( i = 0; i < 5; i ++ )
			{
				Tmp += PacketData[ Index ++ ].ToString("x02") + ":";
			}

			Tmp += PacketData[ Index ++ ].ToString("x02");

			return Tmp;
		}


		public static void HighlightText( RichTextBox Rtx , TreeNode MNode , ref StatusBar SBar )
		{
			int i = 0;
			int StartX = 0, EndX = 0;
			int StartY = 0, EndY = 0;
			int [] intArray;

			Rtx.SelectionStart = 0;
			Rtx.SelectionLength = Rtx.Text.Length;
			Rtx.SelectionColor = System.Drawing.Color.Black;

			try
			{
				intArray = ( int [] ) MNode.Tag;
				if( intArray == null ) return;
			}
			catch
			{
				return;
			}

			SBar.Panels[1].Text = "Index : " + intArray[ 0 ].ToString() + " , Length : " + intArray[ 1 ].ToString();

			for( i = 2; i < intArray.Length; i += 4 )
			{
				StartX = intArray[ i ];
				EndX = intArray[ i + 1 ];
				StartY = intArray[ i + 2 ];
				EndY = intArray[ i + 3 ];

				Rtx.SelectionStart = StartX;
				Rtx.SelectionLength = EndX;
				Rtx.SelectionColor = System.Drawing.Color.Blue;

				Rtx.SelectionStart = StartY;
				Rtx.SelectionLength = EndY;
				Rtx.SelectionColor = System.Drawing.Color.Red;
			}

		}


		public static void AddNodeToTheList( TreeNode mNode , ref ArrayList aList )
		{
			TreeNode PNode;
			int i = 0;

			for( i = 0; i < mNode.Nodes.Count; i ++ )
			{
				PNode = mNode.Nodes[ i ];
				aList.Add( PNode );
				if( PNode.Nodes.Count > 0 )
					AddNodeToTheList( PNode , ref aList );
			}

		}

		public static void ReverseHighlightText( RichTextBox Rtx , TreeView Tnc , System.Drawing.Point Pt , ref StatusBar SBar )
		{
			int i = 0;
			TreeNode PNode = null;
			int CharIndex = 0;
			int [] intArray;
			int ModeX = 0, ModeY = 0;
			ArrayList aList = new ArrayList();

			CharIndex = Rtx.GetCharIndexFromPosition( Pt );

			if( CharIndex < 167 ) return;

			ModeX = CharIndex / 78;
			ModeY = CharIndex - ( ModeX * 78 );
			ModeY -= 11;
			if( ModeY > 48 )
			{
				ModeY -= 48;
				CharIndex = ModeX * 78 + 11 + ModeY * 3 - 1;
			}

			for( i = 1; i < Tnc.Nodes.Count; i ++ )
			{
				PNode = Tnc.Nodes[ i ];
				aList.Add( PNode );
				if( PNode.Nodes.Count > 0 )
					AddNodeToTheList( PNode , ref aList );
			}

			for( i = 0; i < aList.Count; i ++ )
			{
				PNode = ( TreeNode ) aList[ i ];

				try
				{
					intArray = ( int [] ) PNode.Tag;
					if( intArray != null )
					{
						if( ( CharIndex >= intArray[2] ) && ( CharIndex <= ( intArray[ intArray.Length - 4 ] + intArray[intArray.Length - 3 ] ) ) && ( PNode.Nodes.Count == 0 ) )
						{
							Tnc.SelectedNode = PNode;
							HighlightText( Rtx , PNode , ref SBar );
							return;
						}
					}
				}
				catch( Exception Ex )
				{
						MessageBox.Show( ReturnErrorMessage( Ex ) );
					return; }
			}

		}


		public static int [] FindHighlightPos( int SPos , int SLen )
		{
			int FieldX = 0, FieldY = 0;
			int i = 0;
			int Val = 0;
			int StartX = 0, EndX = 0;
			int StartY = 0, EndY = 0;
			int ModeX = 0, ModeY = 0;
			int ModeXX = 0, ModeYY = 0;
			int CurrentIndex = 0;
			ArrayList aList = new ArrayList();
			int [] ReturnArray;


			FieldX = SPos;
			FieldY = SLen;

			aList.Add( SPos );
			aList.Add( SLen );

			ModeX = FieldX / 16;
			ModeY = FieldX  - ( ModeX * 16 );
			
			StartX = 166 + 78 * ModeX + ModeY * 3;
			StartY = 216 + 78 * ModeX + ModeY;

			CurrentIndex = ModeX;

			Val = ModeY + FieldY;

			if( Val <= 16 )
			{
				EndX = FieldY * 3;
				EndY = FieldY;

				aList.Add( StartX );
				aList.Add( EndX );
				aList.Add( StartY );
				aList.Add( EndY );

			}
			else
			{
				Val = 16 - ModeY;
				FieldY -= Val;
				EndX = Val * 3;
				EndY = Val;

				aList.Add( StartX );
				aList.Add( EndX );
				aList.Add( StartY );
				aList.Add( EndY );

				CurrentIndex ++;

				ModeXX = FieldY / 16;
				ModeYY = FieldY - ( ModeXX * 16 );
				
				for( i = 0; i < ModeXX; i ++ )
				{
					StartX = 166 + 78 * CurrentIndex;
					StartY = 216 + 78 * CurrentIndex;
					EndX = 16 * 3;
					EndY = 16;

					aList.Add( StartX );
					aList.Add( EndX );
					aList.Add( StartY );
					aList.Add( EndY );

					CurrentIndex ++;
				}

				if( ModeYY > 0 )
				{
					StartX = 166 + 78 * CurrentIndex;
					StartY = 216 + 78 * CurrentIndex;
					EndX = ModeYY * 3;
					EndY = ModeYY;

					aList.Add( StartX );
					aList.Add( EndX );
					aList.Add( StartY );
					aList.Add( EndY );

				}

			}

			ReturnArray = new int[ aList.Count ];

			for( i = 0; i < aList.Count; i ++ )
				ReturnArray[ i ] = ( int ) aList[ i ];

			return ReturnArray;

		}

		public static bool CheckBytesForZero( byte [] PacketData , int Index , int len )
		{
			bool RetVal = true;
			int i = 0;

			for( i = 0; i < 10; i ++ )
			{
				if( PacketData[ Index + i ] != 0 ) return false;
			}

			return RetVal;
		}

		public static int FindListIndex( ListView LVw , ListViewItem LItem )
		{
			int i = 0;
			int Index = -1;

			for( i = 0; i < LVw.Items.Count; i++ )
			{
				if( LItem.Text == LVw.Items[i].Text )
				{
					Index = i;
					break;
				}
			}

			return Index;
		}


		public static int FindListIndex( ListViewItem LItem )
		{
			int Index = -1;
			string str = "";

			str = LItem.Text;
			Index = int.Parse( str );

			return Index;
		}

		public static string FindString( byte [] PacketData , ref int Index )
		{
			string Tmp = "";
			
			while( PacketData[ Index ] != 0 )
			{
				Tmp += (char) PacketData[ Index ++ ];
			}

			Index ++;

			return Tmp;
		}


		public static string GetString( byte [] PacketData , ref int Index , int len )
		{
			string Tmp = "";
			int i = 0;
			
			for( i = 0; i < len; i ++ )
			{
				Tmp += (char) PacketData[ Index ++ ];
			}

			return Tmp;
		}

		public static string GetString( byte [] PacketData , ref int Index )
		{
			string Tmp = "";
			
			while( PacketData[ Index ] != 0 )
			{
				Tmp += (char) PacketData[ Index ++ ];
			}

			Index ++;

			return Tmp;
		}

		public static string GetString( byte [] PacketData , ref int Index , bool IsUnicode )
		{
			string Tmp = "";
		
			if( IsUnicode )
			{
				while( ( PacketData[ Index ] != 0 ) && ( PacketData[ Index + 1 ] != 0 ) )
				{
					Tmp += (char) PacketData[ Index ++ ]; Index ++;
				}

				Index += 2;
			}
			else
			{
				while( PacketData[ Index ] != 0 )
				{
					Tmp += (char) PacketData[ Index ++ ];
				}

				Index ++;
			}

			return Tmp;
		}


		public static string GetUnicodeOrAscii( byte [] PacketData , ref int Index )
		{
			string Tmp = "";

			if( PacketData[ Index + 1 ] == 0 )
				Tmp = GetString( PacketData , ref Index , true );
			else
				Tmp = GetString( PacketData , ref Index , false );

			return Tmp;

		}

		public static void SetPosition( ref TreeNode mNode , int Start , int Len , bool BaseOrSub )
		{
			if( BaseOrSub )
				mNode.Tag = FindHighlightPos( Start , Len );
			else
				mNode.Nodes[ mNode.Nodes.Count - 1 ].Tag = FindHighlightPos( Start , Len );

		}


		public static void ArrangeText( ref TreeNode mNode , string ArrangeToThis )
		{
			int i = 0 , j = 0;
			int MaxLength = 0, PreviousMaxLength = 0;
			string Tmp = "" , Tmp2 = "";;
			TreeNode PNode;

			for( i = 0; i < mNode.Nodes.Count; i ++ )
			{
				PNode = mNode.Nodes[ i ];
				Tmp = PNode.Text;
				MaxLength = Tmp.IndexOf( ArrangeToThis , 0 );
				if( PreviousMaxLength < MaxLength ) PreviousMaxLength = MaxLength;
				if( PNode.Nodes.Count > 0 )
					ArrangeText( ref PNode , ArrangeToThis );
			}

			if( PreviousMaxLength > 0 )
			{
				for( i = 0; i < mNode.Nodes.Count; i ++ )
				{
					PNode = mNode.Nodes[ i ];
					Tmp = PNode.Text;
					MaxLength = Tmp.IndexOf( ArrangeToThis , 0 );
					if( MaxLength > 0 )
					{
						Tmp2 = Tmp.Substring( 0 , MaxLength );
						Tmp2 = Tmp2.Trim();
						for( j = Tmp2.Length; j < PreviousMaxLength; j ++ )
							Tmp2 += " ";
						Tmp2 += ": ";
						Tmp = Tmp.Substring( MaxLength + 1 , Tmp.Length - MaxLength - 1 );
						Tmp2 += Tmp.Trim();
						PNode.Text = Tmp2;
					}
				}

			}

		}


		public static void ArrangeText( ref TreeNodeCollection Tnc , string ArrangeToThis )
		{
			int i = 0;
			TreeNode PNode;

			for( i = 0; i < Tnc.Count; i ++ )
			{
				PNode = Tnc[ i ];
				if( PNode.Nodes.Count > 0 )
					ArrangeText( ref PNode , ArrangeToThis );
			}

		}


		public static string GetTimeStr( uint TimeValue )
		{
			string Tmp = "";
			uint Second , Minute , Hour , Day , Month , Year;

			Second = TimeValue;
			Minute = Second / 60;
			Hour = Minute / 60;
			Day = Hour / 24;
			Month = Day / 30;
			Year = Month / 12;

			Second -= Minute * 60;
			Minute -= Hour * 60;
			Hour -= Day * 24;
			Day -= Month * 30;
			Month = Year * 12;

			if( Year == 1 )
				Tmp += Year.ToString() + " years , ";
			else if( Year > 1 )
				Tmp += Year.ToString() + " years , ";

			if( Month  == 1 )
				Tmp += Month.ToString() + " month , ";
			else if( Month > 1 )
				Tmp += Month.ToString() + " months , ";

			if( Day  == 1 )
				Tmp += Day.ToString() + " day , ";
			else if( Day > 1 )
				Tmp += Day.ToString() + " days , ";

			if( Hour  == 1 )
				Tmp += Hour.ToString() + " hour , ";
			else if( Hour > 1 )
				Tmp += Hour.ToString() + " hours , ";

			if( Minute == 1 )
				Tmp += Minute.ToString() + " minute , ";
			else if( Minute > 1 )
				Tmp += Minute.ToString() + " minutes , ";

			if( Second == 1 )
				Tmp += Second.ToString() + " second , ";
			else if( Second > 1 )
				Tmp += Second.ToString() + " seconds , ";


			Tmp = Tmp.Trim();
			if( Tmp[ Tmp.Length - 1 ] == ","[0] )
				Tmp = Tmp.Substring( 0 , Tmp.Length - 1 );

			return Tmp;
		}


		public static string AnalyzeSmbMessage( string AStr )
		{
			string Tmp = "";
			byte b = 0;
			int i = 0;

			for( i = 0; i < AStr.Length; i ++ )
			{
				b = ( byte ) AStr[i];
				if( ( b < 32 ) || ( b > 128 ) )
					Tmp += "\\" + b.ToString() + "\\";
				else
					Tmp += AStr[i];
			}

			return Tmp;
		}


		public static string ByteToString( Packet32 P32 , int ItemIndex , int Index , int Len )
		{
			string Tmp = "";
			int i = 0;
			PacketParser.PACKET_ITEM PItem;

			PItem = ( PacketParser.PACKET_ITEM ) P32.PParser.PacketCollection[ ItemIndex ];
			
			for( i = 0; i < Len; i ++ )
				Tmp += PItem.Data[ Index + i ].ToString("x02");

			return Tmp;
		}


		public static bool FindDataSizeAndLength( RichTextBox Rtx , int X1 , int X2 , ref int ClickedIndex )
		{
			int CharIndex = 0;
			int ModeX = 0, ModeY = 0;
			System.Drawing.Point Pt = new System.Drawing.Point( X1 , X2 );

			CharIndex = Rtx.GetCharIndexFromPosition( Pt );

			if( CharIndex < 167 ) 
			{
				ClickedIndex = -1;
				return false;
			}

			CharIndex -= 166;
			ModeX = CharIndex / 78;
			ModeY = CharIndex - ( ModeX * 78 );
			if( ModeY > 48 )
			{
				ClickedIndex = -1;
				return false;
			}

			ModeY /= 3;

			ClickedIndex = ModeX * 16 + ModeY;

			return true;
		}


		public static string TreeNodeToByteString( PacketParser PParser , TreeView TVw , ListView LVw )
		{
			int [] intArray;
			int Index = -1 , i = 0;
			string Tmp = "";
			PacketParser.PACKET_ITEM PItem;

			try
			{
				Index = int.Parse( LVw.SelectedItems[0].Text );
				PItem = ( PacketParser.PACKET_ITEM ) PParser.PacketCollection[ Index ];
				intArray = ( int [] ) TVw.SelectedNode.Tag;

				for( i = 0; i < intArray[1]; i ++ )
					Tmp += PItem.Data[ intArray[0] + i ].ToString("x02");
			}
			catch
			{
				return "";
			}

			return Tmp;

		}

		public static void DecreaseIndexTextAndRemove( PacketParser PParser , ref ListView LVw , int IndexStart )
		{
			int i = 0;
			string Tmp = "";
			int IndexInPacketCollection = -1;

			IndexInPacketCollection = int.Parse( LVw.Items[ IndexStart ].Text );

			for( i = IndexStart + 1; i < LVw.Items.Count; i ++ )
			{
				Tmp = LVw.Items[i].Text;
				int b = int.Parse( Tmp );
				b --;
				LVw.Items[i].Text = b.ToString();
			}

			PParser.PacketCollection.RemoveAt( IndexInPacketCollection );
			LVw.Items.RemoveAt( IndexStart );
			LVw.Refresh();

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			byte NodeValue,
			object NodeOptionalValue,
			int IndexOfNode,
			int LengthOfNode,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			Function.SetPosition( ref mNode , IndexOfNode , LengthOfNode , IsBaseNode );

			return mNode;

		}

		public static TreeNode AddNodeItem(
			string NodeName,
			char NodeValue,
			object NodeOptionalValue,
			int IndexOfNode,
			int LengthOfNode,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			Function.SetPosition( ref mNode , IndexOfNode , LengthOfNode , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			short NodeValue,
			object NodeOptionalValue,
			int IndexOfNode,
			int LengthOfNode,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			Function.SetPosition( ref mNode , IndexOfNode , LengthOfNode , IsBaseNode );

			return mNode;

		}

		public static TreeNode AddNodeItem(
			string NodeName,
			ushort NodeValue,
			object NodeOptionalValue,
			int IndexOfNode,
			int LengthOfNode,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			Function.SetPosition( ref mNode , IndexOfNode , LengthOfNode , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			int NodeValue,
			object NodeOptionalValue,
			int IndexOfNode,
			int LengthOfNode,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			Function.SetPosition( ref mNode , IndexOfNode , LengthOfNode , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			uint NodeValue,
			object NodeOptionalValue,
			int IndexOfNode,
			int LengthOfNode,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			Function.SetPosition( ref mNode , IndexOfNode , LengthOfNode , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			long NodeValue,
			object NodeOptionalValue,
			int IndexOfNode,
			int LengthOfNode,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			Function.SetPosition( ref mNode , IndexOfNode , LengthOfNode , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			ulong NodeValue,
			object NodeOptionalValue,
			int IndexOfNode,
			int LengthOfNode,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			Function.SetPosition( ref mNode , IndexOfNode , LengthOfNode , IsBaseNode );

			return mNode;

		}

		//-----------------------------------------------------------------------

		/*public static TreeNode AddNodeItem(
			string NodeName,
			ref string NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			int ReadType,
			int ReadLength,
			bool PassNullBytes,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = Data[ Index ++ ];
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 1 , 1 , IsBaseNode );

			return mNode;

		}*/

		public static TreeNode AddNodeItem(
			string NodeName,
			ref byte NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = Data[ Index ++ ];
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 1 , 1 , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			ref char NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = (char) Data[ Index ++ ];
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 1 , 1 , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			ref short NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			int Type,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = (short) Get2Bytes( Data , ref Index , Type );
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 2 , 2 , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			ref ushort NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			int Type,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = Get2Bytes( Data , ref Index , Type );
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 2 , 2 , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			ref int NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			int Type,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = (int) Get4Bytes( Data , ref Index , Type );
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 4 , 4 , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			ref uint NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			int Type,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = Get4Bytes( Data , ref Index , Type );
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 4 , 4 , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			ref long NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			int Type,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = (long) Get8Bytes( Data , ref Index , Type );
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 8 , 8 , IsBaseNode );

			return mNode;

		}


		public static TreeNode AddNodeItem(
			string NodeName,
			ref ulong NodeValue,
			object NodeOptionalValue,
			byte [] Data,
			ref int Index,
			int Type,
			bool IsBaseNode
			)
		{
			TreeNode mNode = new TreeNode();
			string Tmp = "";

			NodeValue = Get8Bytes( Data , ref Index , Type );
			Tmp = NodeName + " : " + ReFormatString( NodeValue , NodeOptionalValue );
			if( IsBaseNode )
				mNode.Text = Tmp;
			else
				mNode.Nodes.Add( Tmp );
			SetPosition( ref mNode , Index - 8 , 8 , IsBaseNode );

			return mNode;

		}

		//------------------------------------------------------------------------

	}
}
