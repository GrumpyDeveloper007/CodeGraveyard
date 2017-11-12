using System;

namespace MyClasses
{

	using DEVICE_TYPE  = System.UInt32;

	public class DeviceIOCtlh
	{

		public static uint FILE_DEVICE_BEEP                = 0x00000001;
		public static uint FILE_DEVICE_CD_ROM              = 0x00000002;
		public static uint FILE_DEVICE_CD_ROM_FILE_SYSTEM  = 0x00000003;
		public static uint FILE_DEVICE_CONTROLLER          = 0x00000004;
		public static uint FILE_DEVICE_DATALINK            = 0x00000005;
		public static uint FILE_DEVICE_DFS                 = 0x00000006;
		public static uint FILE_DEVICE_DISK                = 0x00000007;
		public static uint FILE_DEVICE_DISK_FILE_SYSTEM    = 0x00000008;
		public static uint FILE_DEVICE_FILE_SYSTEM         = 0x00000009;
		public static uint FILE_DEVICE_INPORT_PORT         = 0x0000000a;
		public static uint FILE_DEVICE_KEYBOARD            = 0x0000000b;
		public static uint FILE_DEVICE_MAILSLOT            = 0x0000000c;
		public static uint FILE_DEVICE_MIDI_IN             = 0x0000000d;
		public static uint FILE_DEVICE_MIDI_OUT            = 0x0000000e;
		public static uint FILE_DEVICE_MOUSE               = 0x0000000f;
		public static uint FILE_DEVICE_MULTI_UNC_PROVIDER  = 0x00000010;
		public static uint FILE_DEVICE_NAMED_PIPE          = 0x00000011;
		public static uint FILE_DEVICE_NETWORK             = 0x00000012;
		public static uint FILE_DEVICE_NETWORK_BROWSER     = 0x00000013;
		public static uint FILE_DEVICE_NETWORK_FILE_SYSTEM = 0x00000014;
		public static uint FILE_DEVICE_NULL                = 0x00000015;
		public static uint FILE_DEVICE_PARALLEL_PORT       = 0x00000016;
		public static uint FILE_DEVICE_PHYSICAL_NETCARD    = 0x00000017;
		public static uint FILE_DEVICE_PRINTER             = 0x00000018;
		public static uint FILE_DEVICE_SCANNER             = 0x00000019;
		public static uint FILE_DEVICE_SERIAL_MOUSE_PORT   = 0x0000001a;
		public static uint FILE_DEVICE_SERIAL_PORT         = 0x0000001b;
		public static uint FILE_DEVICE_SCREEN              = 0x0000001c;
		public static uint FILE_DEVICE_SOUND               = 0x0000001d;
		public static uint FILE_DEVICE_STREAMS             = 0x0000001e;
		public static uint FILE_DEVICE_TAPE                = 0x0000001f;
		public static uint FILE_DEVICE_TAPE_FILE_SYSTEM    = 0x00000020;
		public static uint FILE_DEVICE_TRANSPORT           = 0x00000021;
		public static uint FILE_DEVICE_UNKNOWN             = 0x00000022;
		public static uint FILE_DEVICE_VIDEO               = 0x00000023;
		public static uint FILE_DEVICE_VIRTUAL_DISK        = 0x00000024;
		public static uint FILE_DEVICE_WAVE_IN             = 0x00000025;
		public static uint FILE_DEVICE_WAVE_OUT            = 0x00000026;
		public static uint FILE_DEVICE_8042_PORT           = 0x00000027;
		public static uint FILE_DEVICE_NETWORK_REDIRECTOR  = 0x00000028;
		public static uint FILE_DEVICE_BATTERY             = 0x00000029;
		public static uint FILE_DEVICE_BUS_EXTENDER        = 0x0000002a;
		public static uint FILE_DEVICE_MODEM               = 0x0000002b;
		public static uint FILE_DEVICE_VDM                 = 0x0000002c;
		public static uint FILE_DEVICE_MASS_STORAGE        = 0x0000002d;

		public static uint METHOD_BUFFERED                 = 0;
		public static uint METHOD_IN_DIRECT                = 1;
		public static uint METHOD_OUT_DIRECT               = 2;
		public static uint METHOD_NEITHER                  = 3;

		public static uint FILE_ANY_ACCESS                 = 0;
		public static uint FILE_READ_ACCESS          = 0x0001;	// file & pipe
		public static uint FILE_WRITE_ACCESS         = 0x0002;	// file & pipe

		public DeviceIOCtlh()
		{

		}

		//
		// Macro definition for defining IOCTL and FSCTL function control codes.  Note
		// that function codes 0-2047 are reserved for Microsoft Corporation, and
		// 2048-4095 are reserved for customers.
		//
		public static uint CTL_CODE( uint DeviceType, uint Function, uint Method, uint Access )
		{
			return ( ( DeviceType ) << 16 ) | ( ( Access ) << 14 ) | 
				( (Function ) << 2 ) | ( Method );
		}

	}
}
