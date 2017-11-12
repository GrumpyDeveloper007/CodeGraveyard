using System;

namespace MyClasses
{

	// This is the type of an NDIS OID value.
	using NDIS_OID = System.UInt64;
	//using PNDIS_OID = System.UInt64 *;
	using Priority_802_3 = System.UInt64;	// 0-7 priority levels
	using UINT = System.UInt32;
	using HANDLE = System.IntPtr;
	using WW_OPERATION_MODE = System.Int32;	//  0 = Normal mode
	//  1 = Power saving mode
	// -1 = mode unknown
	//
	// OID_WW_GEN_LOCK_STATUS
	using WW_LOCK_STATUS =System.Int32;	//  0 = unlocked
	//  1 = locked
	// -1 = unknown lock status
	//
	// OID_WW_GEN_DISABLE_TRANSMITTER
	using WW_DISABLE_TRANSMITTER = System.Int32;	//  0 = transmitter enabled
	//  1 = transmitter disabled
	// -1 = unknown value
	//
	// OID_WW_GEN_NETWORK_ID
	using WW_NETWORK_ID = NtddNDish.NDIS_VAR_DATA_DESC;
	// OID_WW_GEN_PERMANENT_ADDRESS 
	using WW_PERMANENT_ADDRESS = NtddNDish.NDIS_VAR_DATA_DESC;
	// OID_WW_GEN_SUSPEND_DRIVER
	using WW_SUSPEND_DRIVER = System.Int32;	// 0 = driver operational
	// 1 = driver suspended
	//
	// OID_WW_GEN_BASESTATION_ID
	using WW_BASESTATION_ID =NtddNDish.NDIS_VAR_DATA_DESC ;
	//
	// OID_WW_GEN_CHANNEL_ID
	using WW_CHANNEL_ID = NtddNDish.NDIS_VAR_DATA_DESC;
	//
	// OID_WW_GEN_ENCRYPTION_STATE
	using WW_ENCRYPTION_STATE = System.Int32;	// 0 = if encryption is disabled
	// 1 = if encryption is enabled
	//
	// OID_WW_GEN_CHANNEL_QUALITY
	using WW_CHANNEL_QUALITY = System.Int32;	//  0 = Not in network contact,
	// 1-100 = Quality of Channel (100 is highest quality).
	// -1 = channel quality is unknown
	//
	// OID_WW_GEN_REGISTRATION_STATUS
	using WW_REGISTRATION_STATUS = System.Int32;	//  0 = Registration denied
	//  1 = Registration pending
	//  2 = Registered
	// -1 = unknown registration status
	//
	// OID_WW_GEN_RADIO_LINK_SPEED
	using WW_RADIO_LINK_SPEED = System.Int32;	// Bits per second.
	//
	// OID_WW_GEN_LATENCY
	using WW_LATENCY = System.Int32;	//  milliseconds
	//
	// OID_WW_GEN_BATTERY_LEVEL
	using WW_BATTERY_LEVEL = System.Int32;	//  0-100 = battery level in percentage
	//      (100=fully charged)
	// -1 = unknown battery level.
	//
	// OID_WW_GEN_EXTERNAL_POWER
	using WW_EXTERNAL_POWER = System.Int32;	//   0 = no external power connected
	//   1 = external power connected
	//  -1 = unknown
	//
	// OID_WW_MET_FUNCTION
	using WW_MET_FUNCTION = NtddNDish.NDIS_VAR_DATA_DESC;
	// OID_WW_TAC_COMPRESSION
	using WW_TAC_COMPRESSION = System.Int32;	// Determines whether or not network level compression
	// is being used.


	// OID_WW_TAC_USER_HEADER
	using WW_TAC_USERHEADER = NtddNDish.NDIS_VAR_DATA_DESC;	// This will hold the user header - Max. 64 octets.
	// OID_WW_ARD_TMLY_MSG
	using WW_ARD_CHANNEL_STATUS = System.Int32;	// The current status of the inbound RF Channel.
	// OID_WW_CDPD_AREA_COLOR
	using WW_CDPD_AREA_COLOR = System.Int32;
	// OID_WW_CDPD_TX_POWER_LEVEL
	using WW_CDPD_TX_POWER_LEVEL = System.UInt32;
	// OID_WW_CDPD_EID
	using WW_CDPD_EID = NtddNDish.NDIS_VAR_DATA_DESC;
	// OID_WW_CDPD_HEADER_COMPRESSION
	using WW_CDPD_HEADER_COMPRESSION = System.Int32;		//  0 = no header compression,
	//  1 = always compress headers,
	//  2 = compress headers if MD-IS does
	// -1 = unknown
	// OID_WW_CDPD_DATA_COMPRESSION
	using WW_CDPD_DATA_COMPRESSION = System.Int32;	// 0  = no data compression,
	// 1  = data compression enabled
	// -1 =  unknown
	// OID_WW_CDPD_SLEEP_MODE
	using WW_CDPD_SLEEP_MODE = System.Int32;
	// OID_WW_CDPD_TEI
	using WW_CDPD_TEI = System.UInt64;
	using WW_CDPD_RSSI = System.UInt32;
	// OID_WW_PIN_LOC_AUTHORIZE
	using WW_PIN_AUTHORIZED = System.Int32;	// 0  = unauthorized
	// 1  = authorized
	// -1 = unknown
	// The following is set on a per-packet basis as OOB data with NdisClassWirelessWanMbxMailbox
	using WW_MBX_MAILBOX_FLAG = System.UInt64;	// 1 = set mailbox flag, 0 = do not set mailbox flag
	// OID_WW_MBX_LIVE_DIE
	using WW_MBX_LIVE_DIE = System.Int32;	//  0 = DIE last received       
	//  1 = LIVE last received
	// -1 = unknown
	
	public class NtddNDish
	{

		// Device Name - this string is the name of the device.  It is the name
		// that should be passed to NtOpenFile when accessing the device.
		//
		// Note:  For devices that support multiple units, it should be suffixed
		//                with the Ascii representation of the unit number.
		public string DD_NDIS_DEVICE_NAME  = "\\Device\\UNKNOWN";
		//
		// NtDeviceIoControlFile IoControlCode values for this device.
		//
		// Warning:  Remember that the low two bits of the code specify how the
		//                       buffers are passed to the driver!
		//

		public static uint IOCTL_NDIS_QUERY_GLOBAL_STATS	= NDIS_CONTROL_CODE( 0, DeviceIOCtlh.METHOD_OUT_DIRECT );
		public static uint IOCTL_NDIS_QUERY_ALL_STATS		= NDIS_CONTROL_CODE( 1, DeviceIOCtlh.METHOD_OUT_DIRECT );
		public static uint IOCTL_NDIS_ADD_DEVICE			= NDIS_CONTROL_CODE( 2, DeviceIOCtlh.METHOD_BUFFERED );
		public static uint IOCTL_NDIS_DELETE_DEVICE			= NDIS_CONTROL_CODE( 3, DeviceIOCtlh.METHOD_BUFFERED );
		public static uint IOCTL_NDIS_TRANSLATE_NAME		= NDIS_CONTROL_CODE( 4, DeviceIOCtlh.METHOD_BUFFERED );
		public static uint IOCTL_NDIS_ADD_TDI_DEVICE		= NDIS_CONTROL_CODE( 5, DeviceIOCtlh.METHOD_BUFFERED );
		public static uint IOCTL_NDIS_NOTIFY_PROTOCOL		= NDIS_CONTROL_CODE( 6, DeviceIOCtlh.METHOD_BUFFERED );
		public static uint IOCTL_NDIS_GET_LOG_DATA			= NDIS_CONTROL_CODE( 7, DeviceIOCtlh.METHOD_OUT_DIRECT );

		// NtDeviceIoControlFile InputBuffer/OutputBuffer record structures for
		// this device.
		// IOCTL_NDIS_QUERY_ALL_STATS returns a sequence of these, packed
		// together (no padding is required since statistics all have
		// four or eight bytes of data).
		//
		public struct NDIS_STATISTICS_VALUE 
		{
			public NDIS_OID Oid;
			public ulong DataLength;
			public char [] Data;		// variable length
		};

		//
		// Structure used by TRANSLATE_NAME IOCTL
		//
		public struct NET_PNP_ID 
		{
			public ulong ClassId;
			public ulong Token;
		};

		public struct NET_PNP_TRANSLATE_LIST 
		{
			public ulong BytesNeeded;
			public NET_PNP_ID [] IdArray; //ANYSIZE_ARRAY is the length of the array
		};

		//
		// Structure used to define a self-contained variable data structure
		//
		public struct NDIS_VAR_DATA_DESC 
		{
			public ushort Length;		// # of octects of data
			public ushort MaximumLength;	// # of octects available
			public long Offset;		// Offset of data relative to the descriptor

		};

		// Object Identifiers used by NdisRequest Query/Set Information
		// General Objects

		public static uint  OID_GEN_BROADCAST_BYTES_RCV = 0x2020B;
		public static uint  OID_GEN_BROADCAST_BYTES_XMIT = 0x20205;
		public static uint  OID_GEN_BROADCAST_FRAMES_RCV = 0x2020C;
		public static uint  OID_GEN_BROADCAST_FRAMES_XMIT = 0x20206;
		public static uint  OID_GEN_DIRECTED_BYTES_RCV = 0x20207;
		public static uint  OID_GEN_DIRECTED_BYTES_XMIT = 0x20201;
		public static uint  OID_GEN_DRIVER_VERSION = 0x10110;
		public static uint  OID_GEN_GET_NETCARD_TIME = 0x20210;
		public static uint  OID_GEN_GET_TIME_CAPS = 0x2020F;
		public static uint  OID_GEN_HARDWARE_STATUS = 0x10102;
		public static uint  OID_GEN_LINK_SPEED = 0x10107;
		public static uint  OID_GEN_MAC_OPTIONS = 0x10113;
		public static uint  OID_GEN_MEDIA_CONNECT_STATUS = 0x10114;
		public static uint  OID_GEN_MEDIA_IN_USE = 0x10104;
		public static uint  OID_GEN_MEDIA_SUPPORTED = 0x10103;
		public static uint  OID_GEN_PROTOCOL_OPTIONS = 0x10112;
		public static uint  OID_GEN_RCV_CRC_ERROR = 0x2020D;
		public static uint  OID_GEN_RCV_ERROR = 0x20104;
		public static uint  OID_GEN_RCV_NO_BUFFER = 0x20105;
		public static uint  OID_GEN_RCV_OK = 0x20102;
		public static uint  OID_GEN_SUPPORTED_LIST = 0x10101;
		public static uint  OID_GEN_TRANSMIT_QUEUE_LENGTH = 0x2020E;
		public static uint  OID_GEN_VENDOR_DESCRIPTION = 0x1010D;
		public static uint  OID_GEN_VENDOR_DRIVER_VERSION = 0x10116;
		public static uint  OID_GEN_VENDOR_ID = 0x1010C;
		public static uint  OID_GEN_XMIT_ERROR = 0x20103;
		public static uint  OID_GEN_XMIT_OK = 0x20101;
		public static uint  OID_GEN_CURRENT_LOOKAHEAD = 0x1010F;
		public static uint  OID_GEN_CURRENT_PACKET_FILTER = 0x1010E;
		public static uint  OID_GEN_DIRECTED_FRAMES_RCV = 0x20208;
		public static uint  OID_GEN_DIRECTED_FRAMES_XMIT = 0x20202;
		public static uint  OID_GEN_MAXIMUM_FRAME_SIZE = 0x10106;
		public static uint  OID_GEN_MAXIMUM_LOOKAHEAD = 0x10105;
		public static uint  OID_GEN_MAXIMUM_SEND_PACKETS = 0x10115;
		public static uint  OID_GEN_MAXIMUM_TOTAL_SIZE = 0x10111;
		public static uint  OID_GEN_MULTICAST_BYTES_RCV = 0x20209;
		public static uint  OID_GEN_MULTICAST_BYTES_XMIT = 0x20203;
		public static uint  OID_GEN_MULTICAST_FRAMES_RCV = 0x2020A;
		public static uint  OID_GEN_MULTICAST_FRAMES_XMIT = 0x20204;
		public static uint  OID_GEN_RECEIVE_BLOCK_SIZE = 0x1010B;
		public static uint  OID_GEN_RECEIVE_BUFFER_SPACE = 0x10109;
		public static uint  OID_GEN_RESET_COUNTS = 0x20214; // ?
		public static uint  OID_GEN_TRANSMIT_BLOCK_SIZE = 0x1010A;
		public static uint  OID_GEN_TRANSMIT_BUFFER_SPACE = 0x10108;

		public static uint  OID_GEN_DEVICE_PROFILE = 0x20212; // ?
		public static uint  OID_GEN_NETCARD_LOAD = 0x20211; // ?
		public static uint  OID_GEN_SUPPORTED_GUIDS = 0x10117; // ?
		public static uint  OID_GEN_FRIENDLY_NAME = 0x20216; // ?
		public static uint  OID_GEN_INIT_TIME_MS = 0x20213; // ?
		public static uint  OID_GEN_MEDIA_CAPABILITIES = 0x10201; // ?
		public static uint  OID_GEN_MEDIA_SENSE_COUNTS = 0x20215; // ?
		public static uint  OID_GEN_NETWORK_LAYER_ADDRESSES = 0x10118; // ?
		public static uint  OID_GEN_PHYSICAL_MEDIUM = 0x10202; // ?
		public static uint  OID_GEN_TRANSPORT_HEADER_OFFSET = 0x10119; // ?


		//
		//      These are connection-oriented general OIDs.
		//      These replace the above OIDs for connection-oriented media.
		//
		public static uint  OID_GEN_CO_SUPPORTED_LIST			  	= 0x00010101;
		public static uint  OID_GEN_CO_HARDWARE_STATUS			 	= 0x00010102;
		public static uint  OID_GEN_CO_MEDIA_SUPPORTED			 	= 0x00010103;
		public static uint  OID_GEN_CO_MEDIA_IN_USE					= 0x00010104;
		public static uint  OID_GEN_CO_LINK_SPEED				  	= 0x00010105;
		public static uint  OID_GEN_CO_VENDOR_ID				   	= 0x00010106;
		public static uint  OID_GEN_CO_VENDOR_DESCRIPTION		  	= 0x00010107;
		public static uint  OID_GEN_CO_DRIVER_VERSION			  	= 0x00010108;
		public static uint  OID_GEN_CO_PROTOCOL_OPTIONS				= 0x00010109;
		public static uint  OID_GEN_CO_MAC_OPTIONS				 	= 0x0001010A;
		public static uint  OID_GEN_CO_MEDIA_CONNECT_STATUS			= 0x0001010B;
		public static uint  OID_GEN_CO_VENDOR_DRIVER_VERSION		= 0x0001010C;
		public static uint  OID_GEN_CO_MINIMUM_LINK_SPEED			= 0x0001010D;
		public static uint  OID_GEN_CO_GET_TIME_CAPS				= 0x00010201;
		public static uint  OID_GEN_CO_GET_NETCARD_TIME				= 0x00010202;
		//
		//      These are connection-oriented statistics OIDs.
		//
		public static uint 	OID_GEN_CO_XMIT_PDUS_OK					= 0x00020101;
		public static uint 	OID_GEN_CO_RCV_PDUS_OK					= 0x00020102;
		public static uint 	OID_GEN_CO_XMIT_PDUS_ERROR				= 0x00020103;
		public static uint 	OID_GEN_CO_RCV_PDUS_ERROR				= 0x00020104;
		public static uint 	OID_GEN_CO_RCV_PDUS_NO_BUFFER			= 0x00020105;
		public static uint 	OID_GEN_CO_RCV_CRC_ERROR				= 0x00020201;
		public static uint  OID_GEN_CO_TRANSMIT_QUEUE_LENGTH		= 0x00020202;
		public static uint 	OID_GEN_CO_BYTES_XMIT					= 0x00020203;
		public static uint  OID_GEN_CO_BYTES_RCV					= 0x00020204;
		public static uint 	OID_GEN_CO_BYTES_XMIT_OUTSTANDING		= 0x00020205;
		public static uint 	OID_GEN_CO_NETCARD_LOAD					= 0x00020206;
		//
		// These are objects for Connection-oriented media call-managers and are not
		// valid for ndis drivers. Under construction.
		//
		public static uint  OID_CO_ADD_PVC							= 0xFF000001;
		public static uint  OID_CO_DELETE_PVC						= 0xFF000002;
		public static uint  OID_CO_GET_CALL_INFORMATION				= 0xFF000003;
		public static uint  OID_CO_ADD_ADDRESS						= 0xFF000004;
		public static uint  OID_CO_DELETE_ADDRESS					= 0xFF000005;
		public static uint  OID_CO_GET_ADDRESSES					= 0xFF000006;
		public static uint  OID_CO_ADDRESS_CHANGE					= 0xFF000007;
		public static uint  OID_CO_SIGNALING_ENABLED				= 0xFF000008;
		public static uint  OID_CO_SIGNALING_DISABLED				= 0xFF000009;
		//
		// 802.3 Objects (Ethernet)
		//
		public static uint  OID_802_3_PERMANENT_ADDRESS		 		= 0x01010101;
		public static uint  OID_802_3_CURRENT_ADDRESS		   		= 0x01010102;
		public static uint  OID_802_3_MULTICAST_LIST				= 0x01010103;
		public static uint  OID_802_3_MAXIMUM_LIST_SIZE		 		= 0x01010104;
		public static uint  OID_802_3_MAC_OPTIONS				 	= 0x01010105;
		//
		//
		public static uint 	NDIS_802_3_MAC_OPTION_PRIORITY			= 0x00000001;
		public static uint  OID_802_3_RCV_ERROR_ALIGNMENT	   		= 0x01020101;
		public static uint  OID_802_3_XMIT_ONE_COLLISION			= 0x01020102;
		public static uint  OID_802_3_XMIT_MORE_COLLISIONS	  		= 0x01020103;
		public static uint  OID_802_3_XMIT_DEFERRED			 		= 0x01020201;
		public static uint  OID_802_3_XMIT_MAX_COLLISIONS	   		= 0x01020202;
		public static uint  OID_802_3_RCV_OVERRUN			   		= 0x01020203;
		public static uint  OID_802_3_XMIT_UNDERRUN			 		= 0x01020204;
		public static uint  OID_802_3_XMIT_HEARTBEAT_FAILURE		= 0x01020205;
		public static uint  OID_802_3_XMIT_TIMES_CRS_LOST	   		= 0x01020206;
		public static uint  OID_802_3_XMIT_LATE_COLLISIONS	  		= 0x01020207;
		//
		// 802.5 Objects (Token-Ring)
		//
		public static uint  OID_802_5_PERMANENT_ADDRESS		 		= 0x02010101;
		public static uint  OID_802_5_CURRENT_ADDRESS		   		= 0x02010102;
		public static uint  OID_802_5_CURRENT_FUNCTIONAL			= 0x02010103;
		public static uint  OID_802_5_CURRENT_GROUP			 		= 0x02010104;
		public static uint  OID_802_5_LAST_OPEN_STATUS		  		= 0x02010105;
		public static uint  OID_802_5_CURRENT_RING_STATUS	   		= 0x02010106;
		public static uint  OID_802_5_CURRENT_RING_STATE			= 0x02010107;
		public static uint  OID_802_5_LINE_ERRORS			   		= 0x02020101;
		public static uint  OID_802_5_LOST_FRAMES			   		= 0x02020102;
		public static uint  OID_802_5_BURST_ERRORS			  		= 0x02020201;
		public static uint  OID_802_5_AC_ERRORS				 		= 0x02020202;
		public static uint  OID_802_5_ABORT_DELIMETERS		  		= 0x02020203;
		public static uint  OID_802_5_FRAME_COPIED_ERRORS	   		= 0x02020204;
		public static uint  OID_802_5_FREQUENCY_ERRORS		  		= 0x02020205;
		public static uint  OID_802_5_TOKEN_ERRORS			  		= 0x02020206;
		public static uint  OID_802_5_INTERNAL_ERRORS		   		= 0x02020207;
		//
		// FDDI Objects
		//
		public static uint  OID_FDDI_LONG_PERMANENT_ADDR			= 0x03010101;
		public static uint  OID_FDDI_LONG_CURRENT_ADDR		  		= 0x03010102;
		public static uint  OID_FDDI_LONG_MULTICAST_LIST			= 0x03010103;
		public static uint  OID_FDDI_LONG_MAX_LIST_SIZE		 		= 0x03010104;
		public static uint  OID_FDDI_SHORT_PERMANENT_ADDR	   		= 0x03010105;
		public static uint  OID_FDDI_SHORT_CURRENT_ADDR		 		= 0x03010106;
		public static uint  OID_FDDI_SHORT_MULTICAST_LIST	   		= 0x03010107;
		public static uint  OID_FDDI_SHORT_MAX_LIST_SIZE			= 0x03010108;
		public static uint  OID_FDDI_ATTACHMENT_TYPE				= 0x03020101;
		public static uint  OID_FDDI_UPSTREAM_NODE_LONG		 		= 0x03020102;
		public static uint  OID_FDDI_DOWNSTREAM_NODE_LONG	   		= 0x03020103;
		public static uint  OID_FDDI_FRAME_ERRORS			   		= 0x03020104;
		public static uint  OID_FDDI_FRAMES_LOST					= 0x03020105;
		public static uint  OID_FDDI_RING_MGT_STATE			 		= 0x03020106;
		public static uint  OID_FDDI_LCT_FAILURES			   		= 0x03020107;
		public static uint  OID_FDDI_LEM_REJECTS					= 0x03020108;
		public static uint  OID_FDDI_LCONNECTION_STATE		  		= 0x03020109;
		public static uint  OID_FDDI_SMT_STATION_ID			 		= 0x03030201;
		public static uint  OID_FDDI_SMT_OP_VERSION_ID		  		= 0x03030202;
		public static uint  OID_FDDI_SMT_HI_VERSION_ID		  		= 0x03030203;
		public static uint  OID_FDDI_SMT_LO_VERSION_ID		  		= 0x03030204;
		public static uint  OID_FDDI_SMT_MANUFACTURER_DATA	  		= 0x03030205;
		public static uint  OID_FDDI_SMT_USER_DATA			  		= 0x03030206;
		public static uint  OID_FDDI_SMT_MIB_VERSION_ID		 		= 0x03030207;
		public static uint  OID_FDDI_SMT_MAC_CT				 		= 0x03030208;
		public static uint  OID_FDDI_SMT_NON_MASTER_CT		  		= 0x03030209;
		public static uint  OID_FDDI_SMT_MASTER_CT			  		= 0x0303020A;
		public static uint  OID_FDDI_SMT_AVAILABLE_PATHS			= 0x0303020B;
		public static uint  OID_FDDI_SMT_CONFIG_CAPABILITIES		= 0x0303020C;
		public static uint  OID_FDDI_SMT_CONFIG_POLICY		  		= 0x0303020D;
		public static uint  OID_FDDI_SMT_CONNECTION_POLICY	  		= 0x0303020E;
		public static uint  OID_FDDI_SMT_T_NOTIFY			   		= 0x0303020F;
		public static uint  OID_FDDI_SMT_STAT_RPT_POLICY			= 0x03030210;
		public static uint  OID_FDDI_SMT_TRACE_MAX_EXPIRATION   	= 0x03030211;
		public static uint  OID_FDDI_SMT_PORT_INDEXES		   		= 0x03030212;
		public static uint  OID_FDDI_SMT_MAC_INDEXES				= 0x03030213;
		public static uint  OID_FDDI_SMT_BYPASS_PRESENT		 		= 0x03030214;
		public static uint  OID_FDDI_SMT_ECM_STATE			  		= 0x03030215;
		public static uint  OID_FDDI_SMT_CF_STATE			   		= 0x03030216;
		public static uint  OID_FDDI_SMT_HOLD_STATE			 		= 0x03030217;
		public static uint  OID_FDDI_SMT_REMOTE_DISCONNECT_FLAG 	= 0x03030218;
		public static uint  OID_FDDI_SMT_STATION_STATUS		 		= 0x03030219;
		public static uint  OID_FDDI_SMT_PEER_WRAP_FLAG		 		= 0x0303021A;
		public static uint  OID_FDDI_SMT_MSG_TIME_STAMP		 		= 0x0303021B;
		public static uint  OID_FDDI_SMT_TRANSITION_TIME_STAMP  	= 0x0303021C;
		public static uint  OID_FDDI_SMT_SET_COUNT			  		= 0x0303021D;
		public static uint  OID_FDDI_SMT_LAST_SET_STATION_ID		= 0x0303021E;
		public static uint  OID_FDDI_MAC_FRAME_STATUS_FUNCTIONS 	= 0x0303021F;
		public static uint  OID_FDDI_MAC_BRIDGE_FUNCTIONS	   		= 0x03030220;
		public static uint  OID_FDDI_MAC_T_MAX_CAPABILITY	   		= 0x03030221;
		public static uint  OID_FDDI_MAC_TVX_CAPABILITY		 		= 0x03030222;
		public static uint  OID_FDDI_MAC_AVAILABLE_PATHS			= 0x03030223;
		public static uint  OID_FDDI_MAC_CURRENT_PATH		   		= 0x03030224;
		public static uint  OID_FDDI_MAC_UPSTREAM_NBR		   		= 0x03030225;
		public static uint  OID_FDDI_MAC_DOWNSTREAM_NBR		 		= 0x03030226;
		public static uint  OID_FDDI_MAC_OLD_UPSTREAM_NBR	   		= 0x03030227;
		public static uint  OID_FDDI_MAC_OLD_DOWNSTREAM_NBR	 		= 0x03030228;
		public static uint  OID_FDDI_MAC_DUP_ADDRESS_TEST	   		= 0x03030229;
		public static uint  OID_FDDI_MAC_REQUESTED_PATHS			= 0x0303022A;
		public static uint  OID_FDDI_MAC_DOWNSTREAM_PORT_TYPE   	= 0x0303022B;
		public static uint  OID_FDDI_MAC_INDEX				  		= 0x0303022C;
		public static uint  OID_FDDI_MAC_SMT_ADDRESS				= 0x0303022D;
		public static uint  OID_FDDI_MAC_LONG_GRP_ADDRESS	   		= 0x0303022E;
		public static uint  OID_FDDI_MAC_SHORT_GRP_ADDRESS	  		= 0x0303022F;
		public static uint  OID_FDDI_MAC_T_REQ				  		= 0x03030230;
		public static uint  OID_FDDI_MAC_T_NEG				  		= 0x03030231;
		public static uint  OID_FDDI_MAC_T_MAX				  		= 0x03030232;
		public static uint  OID_FDDI_MAC_TVX_VALUE			  		= 0x03030233;
		public static uint  OID_FDDI_MAC_T_PRI0				 		= 0x03030234;
		public static uint  OID_FDDI_MAC_T_PRI1				 		= 0x03030235;
		public static uint  OID_FDDI_MAC_T_PRI2				 		= 0x03030236;
		public static uint  OID_FDDI_MAC_T_PRI3				 		= 0x03030237;
		public static uint  OID_FDDI_MAC_T_PRI4				 		= 0x03030238;
		public static uint  OID_FDDI_MAC_T_PRI5				 		= 0x03030239;
		public static uint  OID_FDDI_MAC_T_PRI6				 		= 0x0303023A;
		public static uint  OID_FDDI_MAC_FRAME_CT			   		= 0x0303023B;
		public static uint  OID_FDDI_MAC_COPIED_CT			  		= 0x0303023C;
		public static uint  OID_FDDI_MAC_TRANSMIT_CT				= 0x0303023D;
		public static uint  OID_FDDI_MAC_TOKEN_CT			   		= 0x0303023E;
		public static uint  OID_FDDI_MAC_ERROR_CT			   		= 0x0303023F;
		public static uint  OID_FDDI_MAC_LOST_CT					= 0x03030240;
		public static uint  OID_FDDI_MAC_TVX_EXPIRED_CT		 		= 0x03030241;
		public static uint  OID_FDDI_MAC_NOT_COPIED_CT		  		= 0x03030242;
		public static uint  OID_FDDI_MAC_LATE_CT					= 0x03030243;
		public static uint  OID_FDDI_MAC_RING_OP_CT			 		= 0x03030244;
		public static uint  OID_FDDI_MAC_FRAME_ERROR_THRESHOLD  	= 0x03030245;
		public static uint  OID_FDDI_MAC_FRAME_ERROR_RATIO	  		= 0x03030246;
		public static uint  OID_FDDI_MAC_NOT_COPIED_THRESHOLD   	= 0x03030247;
		public static uint  OID_FDDI_MAC_NOT_COPIED_RATIO	   		= 0x03030248;
		public static uint  OID_FDDI_MAC_RMT_STATE			  		= 0x03030249;
		public static uint  OID_FDDI_MAC_DA_FLAG					= 0x0303024A;
		public static uint  OID_FDDI_MAC_UNDA_FLAG			  		= 0x0303024B;
		public static uint  OID_FDDI_MAC_FRAME_ERROR_FLAG	   		= 0x0303024C;
		public static uint  OID_FDDI_MAC_NOT_COPIED_FLAG			= 0x0303024D;
		public static uint  OID_FDDI_MAC_MA_UNITDATA_AVAILABLE  	= 0x0303024E;
		public static uint  OID_FDDI_MAC_HARDWARE_PRESENT	   		= 0x0303024F;
		public static uint  OID_FDDI_MAC_MA_UNITDATA_ENABLE	 		= 0x03030250;
		public static uint  OID_FDDI_PATH_INDEX				 		= 0x03030251;
		public static uint  OID_FDDI_PATH_RING_LATENCY		  		= 0x03030252;
		public static uint  OID_FDDI_PATH_TRACE_STATUS		  		= 0x03030253;
		public static uint  OID_FDDI_PATH_SBA_PAYLOAD		   		= 0x03030254;
		public static uint  OID_FDDI_PATH_SBA_OVERHEAD		  		= 0x03030255;
		public static uint  OID_FDDI_PATH_CONFIGURATION		 		= 0x03030256;
		public static uint  OID_FDDI_PATH_T_R_MODE			  		= 0x03030257;
		public static uint  OID_FDDI_PATH_SBA_AVAILABLE		 		= 0x03030258;
		public static uint  OID_FDDI_PATH_TVX_LOWER_BOUND	   		= 0x03030259;
		public static uint  OID_FDDI_PATH_T_MAX_LOWER_BOUND	 		= 0x0303025A;
		public static uint  OID_FDDI_PATH_MAX_T_REQ			 		= 0x0303025B;
		public static uint  OID_FDDI_PORT_MY_TYPE			   		= 0x0303025C;
		public static uint  OID_FDDI_PORT_NEIGHBOR_TYPE		 		= 0x0303025D;
		public static uint  OID_FDDI_PORT_CONNECTION_POLICIES   	= 0x0303025E;
		public static uint  OID_FDDI_PORT_MAC_INDICATED		 		= 0x0303025F;
		public static uint  OID_FDDI_PORT_CURRENT_PATH		  		= 0x03030260;
		public static uint  OID_FDDI_PORT_REQUESTED_PATHS	   		= 0x03030261;
		public static uint  OID_FDDI_PORT_MAC_PLACEMENT		 		= 0x03030262;
		public static uint  OID_FDDI_PORT_AVAILABLE_PATHS	   		= 0x03030263;
		public static uint  OID_FDDI_PORT_MAC_LOOP_TIME		 		= 0x03030264;
		public static uint  OID_FDDI_PORT_PMD_CLASS			 		= 0x03030265;
		public static uint  OID_FDDI_PORT_CONNECTION_CAPABILITIES	= 0x03030266;
		public static uint  OID_FDDI_PORT_INDEX				 		= 0x03030267;
		public static uint  OID_FDDI_PORT_MAINT_LS			  		= 0x03030268;
		public static uint  OID_FDDI_PORT_BS_FLAG			   		= 0x03030269;
		public static uint  OID_FDDI_PORT_PC_LS				 		= 0x0303026A;
		public static uint  OID_FDDI_PORT_EB_ERROR_CT		   		= 0x0303026B;
		public static uint  OID_FDDI_PORT_LCT_FAIL_CT		   		= 0x0303026C;
		public static uint  OID_FDDI_PORT_LER_ESTIMATE		  		= 0x0303026D;
		public static uint  OID_FDDI_PORT_LEM_REJECT_CT		 		= 0x0303026E;
		public static uint  OID_FDDI_PORT_LEM_CT					= 0x0303026F;
		public static uint  OID_FDDI_PORT_LER_CUTOFF				= 0x03030270;
		public static uint  OID_FDDI_PORT_LER_ALARM			 		= 0x03030271;
		public static uint  OID_FDDI_PORT_CONNNECT_STATE			= 0x03030272;
		public static uint  OID_FDDI_PORT_PCM_STATE			 		= 0x03030273;
		public static uint  OID_FDDI_PORT_PC_WITHHOLD		   		= 0x03030274;
		public static uint  OID_FDDI_PORT_LER_FLAG			  		= 0x03030275;
		public static uint  OID_FDDI_PORT_HARDWARE_PRESENT	  		= 0x03030276;
		public static uint  OID_FDDI_SMT_STATION_ACTION		 		= 0x03030277;
		public static uint  OID_FDDI_PORT_ACTION					= 0x03030278;
		public static uint  OID_FDDI_IF_DESCR				   		= 0x03030279;
		public static uint  OID_FDDI_IF_TYPE						= 0x0303027A;
		public static uint  OID_FDDI_IF_MTU					 		= 0x0303027B;
		public static uint  OID_FDDI_IF_SPEED				   		= 0x0303027C;
		public static uint  OID_FDDI_IF_PHYS_ADDRESS				= 0x0303027D;
		public static uint  OID_FDDI_IF_ADMIN_STATUS				= 0x0303027E;
		public static uint  OID_FDDI_IF_OPER_STATUS			 		= 0x0303027F;
		public static uint  OID_FDDI_IF_LAST_CHANGE			 		= 0x03030280;
		public static uint  OID_FDDI_IF_IN_OCTETS			   		= 0x03030281;
		public static uint  OID_FDDI_IF_IN_UCAST_PKTS		   		= 0x03030282;
		public static uint  OID_FDDI_IF_IN_NUCAST_PKTS		  		= 0x03030283;
		public static uint  OID_FDDI_IF_IN_DISCARDS			 		= 0x03030284;
		public static uint  OID_FDDI_IF_IN_ERRORS			   		= 0x03030285;
		public static uint  OID_FDDI_IF_IN_UNKNOWN_PROTOS	   		= 0x03030286;
		public static uint  OID_FDDI_IF_OUT_OCTETS			  		= 0x03030287;
		public static uint  OID_FDDI_IF_OUT_UCAST_PKTS		  		= 0x03030288;
		public static uint  OID_FDDI_IF_OUT_NUCAST_PKTS		 		= 0x03030289;
		public static uint  OID_FDDI_IF_OUT_DISCARDS				= 0x0303028A;
		public static uint  OID_FDDI_IF_OUT_ERRORS			  		= 0x0303028B;
		public static uint  OID_FDDI_IF_OUT_QLEN					= 0x0303028C;
		public static uint  OID_FDDI_IF_SPECIFIC					= 0x0303028D;
		//
		// WAN objects
		//
		public static uint  OID_WAN_PERMANENT_ADDRESS		   		= 0x04010101;
		public static uint  OID_WAN_CURRENT_ADDRESS			 		= 0x04010102;
		public static uint  OID_WAN_QUALITY_OF_SERVICE		  		= 0x04010103;
		public static uint  OID_WAN_PROTOCOL_TYPE			   		= 0x04010104;
		public static uint  OID_WAN_MEDIUM_SUBTYPE			  		= 0x04010105;
		public static uint  OID_WAN_HEADER_FORMAT			   		= 0x04010106;
		public static uint  OID_WAN_GET_INFO						= 0x04010107;
		public static uint  OID_WAN_SET_LINK_INFO			   		= 0x04010108;
		public static uint  OID_WAN_GET_LINK_INFO			   		= 0x04010109;
		public static uint  OID_WAN_LINE_COUNT				  		= 0x0401010A;
		public static uint  OID_WAN_GET_BRIDGE_INFO			 		= 0x0401020A;
		public static uint  OID_WAN_SET_BRIDGE_INFO			 		= 0x0401020B;
		public static uint  OID_WAN_GET_COMP_INFO			   		= 0x0401020C;
		public static uint  OID_WAN_SET_COMP_INFO			   		= 0x0401020D;
		public static uint  OID_WAN_GET_STATS_INFO			  		= 0x0401020E;
		//
		// LocalTalk objects
		//
		public static uint  OID_LTALK_CURRENT_NODE_ID		   		= 0x05010102;
		public static uint  OID_LTALK_IN_BROADCASTS			 		= 0x05020101;
		public static uint  OID_LTALK_IN_LENGTH_ERRORS		  		= 0x05020102;
		public static uint  OID_LTALK_OUT_NO_HANDLERS		   		= 0x05020201;
		public static uint  OID_LTALK_COLLISIONS					= 0x05020202;
		public static uint  OID_LTALK_DEFERS						= 0x05020203;
		public static uint  OID_LTALK_NO_DATA_ERRORS				= 0x05020204;
		public static uint  OID_LTALK_RANDOM_CTS_ERRORS		 		= 0x05020205;
		public static uint  OID_LTALK_FCS_ERRORS					= 0x05020206;
		//
		// Arcnet objects
		//
		public static uint  OID_ARCNET_PERMANENT_ADDRESS			= 0x06010101;
		public static uint  OID_ARCNET_CURRENT_ADDRESS		  		= 0x06010102;
		public static uint  OID_ARCNET_RECONFIGURATIONS		 		= 0x06020201;
		//
		// TAPI objects
		//
		public static uint  OID_TAPI_ACCEPT					 		= 0x07030101;
		public static uint  OID_TAPI_ANSWER					 		= 0x07030102;
		public static uint  OID_TAPI_CLOSE					  		= 0x07030103;
		public static uint  OID_TAPI_CLOSE_CALL				 		= 0x07030104;
		public static uint  OID_TAPI_CONDITIONAL_MEDIA_DETECTION	= 0x07030105;
		public static uint  OID_TAPI_CONFIG_DIALOG			  		= 0x07030106;
		public static uint  OID_TAPI_DEV_SPECIFIC			   		= 0x07030107;
		public static uint  OID_TAPI_DIAL					   		= 0x07030108;
		public static uint  OID_TAPI_DROP					   		= 0x07030109;
		public static uint  OID_TAPI_GET_ADDRESS_CAPS		   		= 0x0703010A;
		public static uint  OID_TAPI_GET_ADDRESS_ID			 		= 0x0703010B;
		public static uint  OID_TAPI_GET_ADDRESS_STATUS		 		= 0x0703010C;
		public static uint  OID_TAPI_GET_CALL_ADDRESS_ID			= 0x0703010D;
		public static uint  OID_TAPI_GET_CALL_INFO			  		= 0x0703010E;
		public static uint  OID_TAPI_GET_CALL_STATUS				= 0x0703010F;
		public static uint  OID_TAPI_GET_DEV_CAPS			   		= 0x07030110;
		public static uint  OID_TAPI_GET_DEV_CONFIG			 		= 0x07030111;
		public static uint  OID_TAPI_GET_EXTENSION_ID		   		= 0x07030112;
		public static uint  OID_TAPI_GET_ID					 		= 0x07030113;
		public static uint  OID_TAPI_GET_LINE_DEV_STATUS			= 0x07030114;
		public static uint  OID_TAPI_MAKE_CALL				  		= 0x07030115;
		public static uint  OID_TAPI_NEGOTIATE_EXT_VERSION	  		= 0x07030116;
		public static uint  OID_TAPI_OPEN					   		= 0x07030117;
		public static uint  OID_TAPI_PROVIDER_INITIALIZE			= 0x07030118;
		public static uint  OID_TAPI_PROVIDER_SHUTDOWN		  		= 0x07030119;
		public static uint  OID_TAPI_SECURE_CALL					= 0x0703011A;
		public static uint  OID_TAPI_SELECT_EXT_VERSION		 		= 0x0703011B;
		public static uint  OID_TAPI_SEND_USER_USER_INFO			= 0x0703011C;
		public static uint  OID_TAPI_SET_APP_SPECIFIC		   		= 0x0703011D;
		public static uint  OID_TAPI_SET_CALL_PARAMS				= 0x0703011E;
		public static uint  OID_TAPI_SET_DEFAULT_MEDIA_DETECTION	= 0x0703011F;
		public static uint  OID_TAPI_SET_DEV_CONFIG			 		= 0x07030120;
		public static uint  OID_TAPI_SET_MEDIA_MODE			 		= 0x07030121;
		public static uint  OID_TAPI_SET_STATUS_MESSAGES			= 0x07030122;
		//
		// ATM Connection Oriented Ndis
		//
		public static uint  OID_ATM_SUPPORTED_VC_RATES				= 0x08010101;
		public static uint  OID_ATM_SUPPORTED_SERVICE_CATEGORY		= 0x08010102;
		public static uint  OID_ATM_SUPPORTED_AAL_TYPES				= 0x08010103;
		public static uint  OID_ATM_HW_CURRENT_ADDRESS				= 0x08010104;
		public static uint  OID_ATM_MAX_ACTIVE_VCS					= 0x08010105;
		public static uint  OID_ATM_MAX_ACTIVE_VCI_BITS				= 0x08010106;
		public static uint  OID_ATM_MAX_ACTIVE_VPI_BITS				= 0x08010107;
		public static uint  OID_ATM_MAX_AAL0_PACKET_SIZE			= 0x08010108;
		public static uint  OID_ATM_MAX_AAL1_PACKET_SIZE			= 0x08010109;
		public static uint  OID_ATM_MAX_AAL34_PACKET_SIZE			= 0x0801010A;
		public static uint  OID_ATM_MAX_AAL5_PACKET_SIZE			= 0x0801010B;
		public static uint  OID_ATM_SIGNALING_VPIVCI				= 0x08010201;
		public static uint  OID_ATM_ASSIGNED_VPI					= 0x08010202;
		public static uint  OID_ATM_ACQUIRE_ACCESS_NET_RESOURCES	= 0x08010203;
		public static uint  OID_ATM_RELEASE_ACCESS_NET_RESOURCES	= 0x08010204;
		public static uint  OID_ATM_ILMI_VPIVCI						= 0x08010205;
		public static uint  OID_ATM_DIGITAL_BROADCAST_VPIVCI		= 0x08010206;
		public static uint 	OID_ATM_GET_NEAREST_FLOW				= 0x08010207;
		public static uint  OID_ATM_ALIGNMENT_REQUIRED				= 0x08010208;
		//
		//      ATM specific statistics OIDs.
		//
		public static uint 	OID_ATM_RCV_CELLS_OK					= 0x08020101;
		public static uint 	OID_ATM_XMIT_CELLS_OK					= 0x08020102;
		public static uint 	OID_ATM_RCV_CELLS_DROPPED				= 0x08020103;
		public static uint 	OID_ATM_RCV_INVALID_VPI_VCI				= 0x08020201;
		public static uint 	OID_ATM_CELLS_HEC_ERROR					= 0x08020202;
		public static uint 	OID_ATM_RCV_REASSEMBLY_ERROR			= 0x08020203;
		//
		// PCCA (Wireless) object
		//
		//
		// All WirelessWAN devices must support the following OIDs
		//
		public static uint  OID_WW_GEN_NETWORK_TYPES_SUPPORTED		= 0x09010101;
		public static uint  OID_WW_GEN_NETWORK_TYPE_IN_USE			= 0x09010102;
		public static uint  OID_WW_GEN_HEADER_FORMATS_SUPPORTED		= 0x09010103;
		public static uint  OID_WW_GEN_HEADER_FORMAT_IN_USE			= 0x09010104;
		public static uint  OID_WW_GEN_INDICATION_REQUEST			= 0x09010105;
		public static uint  OID_WW_GEN_DEVICE_INFO					= 0x09010106;
		public static uint  OID_WW_GEN_OPERATION_MODE				= 0x09010107;
		public static uint  OID_WW_GEN_LOCK_STATUS					= 0x09010108;
		public static uint  OID_WW_GEN_DISABLE_TRANSMITTER			= 0x09010109;
		public static uint  OID_WW_GEN_NETWORK_ID					= 0x0901010A;
		public static uint  OID_WW_GEN_PERMANENT_ADDRESS			= 0x0901010B;
		public static uint  OID_WW_GEN_CURRENT_ADDRESS				= 0x0901010C;
		public static uint  OID_WW_GEN_SUSPEND_DRIVER				= 0x0901010D;
		public static uint  OID_WW_GEN_BASESTATION_ID				= 0x0901010E;
		public static uint  OID_WW_GEN_CHANNEL_ID					= 0x0901010F;
		public static uint  OID_WW_GEN_ENCRYPTION_SUPPORTED			= 0x09010110;
		public static uint  OID_WW_GEN_ENCRYPTION_IN_USE			= 0x09010111;
		public static uint  OID_WW_GEN_ENCRYPTION_STATE				= 0x09010112;
		public static uint  OID_WW_GEN_CHANNEL_QUALITY				= 0x09010113;
		public static uint  OID_WW_GEN_REGISTRATION_STATUS			= 0x09010114;
		public static uint  OID_WW_GEN_RADIO_LINK_SPEED				= 0x09010115;
		public static uint  OID_WW_GEN_LATENCY						= 0x09010116;
		public static uint  OID_WW_GEN_BATTERY_LEVEL				= 0x09010117;
		public static uint  OID_WW_GEN_EXTERNAL_POWER				= 0x09010118;
		//
		// Network Dependent OIDs - Mobitex:
		//
		public static uint  OID_WW_MBX_SUBADDR						= 0x09050101;
		// OID = 0x09050102 is reserved and may not be used
		public static uint  OID_WW_MBX_FLEXLIST						= 0x09050103;
		public static uint  OID_WW_MBX_GROUPLIST					= 0x09050104;
		public static uint  OID_WW_MBX_TRAFFIC_AREA					= 0x09050105;
		public static uint  OID_WW_MBX_LIVE_DIE						= 0x09050106;
		public static uint  OID_WW_MBX_TEMP_DEFAULTLIST				= 0x09050107;
		//
		// Network Dependent OIDs - Pinpoint:
		//
		public static uint  OID_WW_PIN_LOC_AUTHORIZE				= 0x09090101;
		public static uint  OID_WW_PIN_LAST_LOCATION				= 0x09090102;
		public static uint  OID_WW_PIN_LOC_FIX						= 0x09090103;
		//
		// Network Dependent - CDPD:
		//
		public static uint  OID_WW_CDPD_SPNI						= 0x090D0101;
		public static uint  OID_WW_CDPD_WASI						= 0x090D0102;
		public static uint  OID_WW_CDPD_AREA_COLOR					= 0x090D0103;
		public static uint  OID_WW_CDPD_TX_POWER_LEVEL				= 0x090D0104;
		public static uint  OID_WW_CDPD_EID							= 0x090D0105;
		public static uint  OID_WW_CDPD_HEADER_COMPRESSION			= 0x090D0106;
		public static uint  OID_WW_CDPD_DATA_COMPRESSION			= 0x090D0107;
		public static uint  OID_WW_CDPD_CHANNEL_SELECT				= 0x090D0108;
		public static uint  OID_WW_CDPD_CHANNEL_STATE				= 0x090D0109;
		public static uint  OID_WW_CDPD_NEI							= 0x090D010A;
		public static uint  OID_WW_CDPD_NEI_STATE					= 0x090D010B;
		public static uint  OID_WW_CDPD_SERVICE_PROVIDER_IDENTIFIER	= 0x090D010C;
		public static uint  OID_WW_CDPD_SLEEP_MODE					= 0x090D010D;
		public static uint  OID_WW_CDPD_CIRCUIT_SWITCHED			= 0x090D010E;
		public static uint 	OID_WW_CDPD_TEI							= 0x090D010F;
		public static uint 	OID_WW_CDPD_RSSI						= 0x090D0110;
		//
		// Network Dependent - Ardis:
		//
		public static uint  OID_WW_ARD_SNDCP						= 0x09110101;
		public static uint  OID_WW_ARD_TMLY_MSG						= 0x09110102;
		public static uint  OID_WW_ARD_DATAGRAM						= 0x09110103;
		//
		// Network Dependent - DataTac:
		//
		public static uint  OID_WW_TAC_COMPRESSION					= 0x09150101;
		public static uint  OID_WW_TAC_SET_CONFIG					= 0x09150102;
		public static uint  OID_WW_TAC_GET_STATUS					= 0x09150103;
		public static uint  OID_WW_TAC_USER_HEADER					= 0x09150104;
		//
		// Network Dependent - Metricom:
		//
		public static uint  OID_WW_MET_FUNCTION						= 0x09190101;
		//
		// IRDA objects
		//
		public static uint  OID_IRDA_RECEIVING						= 0x0A010100;
		public static uint  OID_IRDA_TURNAROUND_TIME				= 0x0A010101;
		public static uint  OID_IRDA_SUPPORTED_SPEEDS				= 0x0A010102;
		public static uint  OID_IRDA_LINK_SPEED						= 0x0A010103;
		public static uint  OID_IRDA_MEDIA_BUSY						= 0x0A010104;
		public static uint  OID_IRDA_EXTRA_RCV_BOFS					= 0x0A010200;
		public static uint  OID_IRDA_RATE_SNIFF						= 0x0A010201;
		public static uint  OID_IRDA_UNICAST_LIST					= 0x0A010202;
		public static uint  OID_IRDA_MAX_UNICAST_LIST_SIZE			= 0x0A010203;
		public static uint  OID_IRDA_MAX_RECEIVE_WINDOW_SIZE		= 0x0A010204;
		public static uint  OID_IRDA_MAX_SEND_WINDOW_SIZE			= 0x0A010205;
		//
		// Medium the Ndis Driver is running on (OID_GEN_MEDIA_SUPPORTED/
		// OID_GEN_MEDIA_IN_USE).
		//
		public enum NDIS_MEDIUM 
		{
			NdisMedium802_3,
			NdisMedium802_5,
			NdisMediumFddi,
			NdisMediumWan,
			NdisMediumLocalTalk,
			NdisMediumDix,		// defined for convenience, not a real medium
			NdisMediumArcnetRaw,
			NdisMediumArcnet878_2,
			NdisMediumAtm,
			NdisMediumWirelessWan,
			NdisMediumIrda,
			NdisMediumMax		// Not a real medium, defined as an upper-bound
		};

		public static string GetMediaInUseString( int Value )
		{
			string Tmp = "";

			switch( Value )
			{
				case (int) NDIS_MEDIUM.NdisMedium802_3 : 
					Tmp = "Medium in use is 802.3 : Ethernet";
					break;
				case (int) NDIS_MEDIUM.NdisMedium802_5 :
					Tmp = "Medium in use is 802.5 : Token Ring";
					break;
				case (int) NDIS_MEDIUM.NdisMediumArcnet878_2 :
					Tmp = "Medium in use is Arcnet 878.2";
					break;
				case (int) NDIS_MEDIUM.NdisMediumArcnetRaw :
					Tmp = "Medium in use is Arcnet Raw";
					break;
				case (int) NDIS_MEDIUM.NdisMediumAtm :
					Tmp = "Medium in use is Atm";
					break;
				case (int) NDIS_MEDIUM.NdisMediumDix :
					Tmp = "Medium in use is Dix";
					break;
				case (int) NDIS_MEDIUM.NdisMediumFddi :
					Tmp = "Medium in use is Fddi";
					break;
				case (int) NDIS_MEDIUM.NdisMediumIrda :
					Tmp = "Medium in use is Irda";
					break;
				case (int) NDIS_MEDIUM.NdisMediumLocalTalk :
					Tmp = "Medium in use is Local Talk";
					break;
				case (int) NDIS_MEDIUM.NdisMediumMax :
					Tmp = "Medium in use is Max";
					break;
				case (int) NDIS_MEDIUM.NdisMediumWan :
					Tmp = "Medium in use is Wan";
					break;
				case (int) NDIS_MEDIUM.NdisMediumWirelessWan :
					Tmp = "Medium in use is Wireless Wan";
					break;
			}

			return Tmp;

		}
		//
		// Hardware status codes (OID_GEN_HARDWARE_STATUS).
		//
		public enum NDIS_HARDWARE_STATUS 
		{
			NdisHardwareStatusReady,
			NdisHardwareStatusInitializing,
			NdisHardwareStatusReset,
			NdisHardwareStatusClosing,
			NdisHardwareStatusNotReady
		};

		public static string GetHardwareStatusString( int Value )
		{
			string Tmp = "";

			switch( Value )
			{
				case (int) NDIS_HARDWARE_STATUS.NdisHardwareStatusReady :
					Tmp = "Hardware is Ready";
					break;
				case (int) NDIS_HARDWARE_STATUS.NdisHardwareStatusInitializing :
					Tmp = "Hardware is Initializing";
					break;
				case (int) NDIS_HARDWARE_STATUS.NdisHardwareStatusReset :
					Tmp = "Hardware is Reset";
					break;
				case (int) NDIS_HARDWARE_STATUS.NdisHardwareStatusClosing :
					Tmp = "Hardware is Closing";
					break;
				case (int) NDIS_HARDWARE_STATUS.NdisHardwareStatusNotReady :
					Tmp = "Hardware is Not Ready";
					break;
			}

			return Tmp;
		}

		//
		// this is the type passed in the OID_GEN_GET_TIME_CAPS request
		//
		public struct GEN_GET_TIME_CAPS 
		{
			public ulong Flags;		// Bits defined below
			public ulong ClockPrecision;
		};

		public static int READABLE_LOCAL_CLOCK					= 0x000000001;
		public static int CLOCK_NETWORK_DERIVED					= 0x000000002;
		public static int CLOCK_PRECISION							= 0x000000004;
		public static int RECEIVE_TIME_INDICATION_CAPABLE			= 0x000000008;
		public static int TIMED_SEND_CAPABLE						= 0x000000010;
		public static int TIME_STAMP_CAPABLE						= 0x000000020;

		public static string GetTimeCapsString( GEN_GET_TIME_CAPS Value )
		{
			string Tmp = "";

			if( ( (int) Value.Flags & READABLE_LOCAL_CLOCK ) == READABLE_LOCAL_CLOCK )
				Tmp += "Readable local clock,";
			if( ( (int) Value.Flags & CLOCK_NETWORK_DERIVED ) == CLOCK_NETWORK_DERIVED )
				Tmp += "Clock network derived,";
			if( ( (int) Value.Flags & CLOCK_PRECISION ) == CLOCK_PRECISION )
				Tmp += "Clock precision,";
			if( ( (int) Value.Flags & RECEIVE_TIME_INDICATION_CAPABLE ) == RECEIVE_TIME_INDICATION_CAPABLE )
				Tmp += "Receive time indication capable,";
			if( ( (int) Value.Flags & TIMED_SEND_CAPABLE ) == TIMED_SEND_CAPABLE )
				Tmp += "Timed send capable,";
			if( ( (int) Value.Flags & TIME_STAMP_CAPABLE ) == TIME_STAMP_CAPABLE )
				Tmp += "Time stamp capable,";

			if( Tmp.Length > 0 )
				Tmp = Tmp.Substring( 0 , Tmp.Length - 1 );

			return Tmp;
		}

		//
		//
		// this is the type passed in the OID_GEN_GET_NETCARD_TIME request
		//
		public struct GEN_GET_NETCARD_TIME 
		{
			public ulong ReadTime;
		};

		//
		// Defines the attachment types for FDDI (OID_FDDI_ATTACHMENT_TYPE).
		//
		public enum NDIS_FDDI_ATTACHMENT_TYPE 
		{
			NdisFddiTypeIsolated = 1,
			NdisFddiTypeLocalA,
			NdisFddiTypeLocalB,
			NdisFddiTypeLocalAB,
			NdisFddiTypeLocalS,
			NdisFddiTypeWrapA,
			NdisFddiTypeWrapB,
			NdisFddiTypeWrapAB,
			NdisFddiTypeWrapS,
			NdisFddiTypeCWrapA,
			NdisFddiTypeCWrapB,
			NdisFddiTypeCWrapS,
			NdisFddiTypeThrough
		};

		//
		// Defines the ring management states for FDDI (OID_FDDI_RING_MGT_STATE).
		//
		public enum NDIS_FDDI_RING_MGT_STATE 
		{
			NdisFddiRingIsolated = 1,
			NdisFddiRingNonOperational,
			NdisFddiRingOperational,
			NdisFddiRingDetect,
			NdisFddiRingNonOperationalDup,
			NdisFddiRingOperationalDup,
			NdisFddiRingDirected,
			NdisFddiRingTrace
		};

		//
		// Defines the Lconnection state for FDDI (OID_FDDI_LCONNECTION_STATE).
		//
		public enum NDIS_FDDI_LCONNECTION_STATE 
		{
			NdisFddiStateOff = 1,
			NdisFddiStateBreak,
			NdisFddiStateTrace,
			NdisFddiStateConnect,
			NdisFddiStateNext,
			NdisFddiStateSignal,
			NdisFddiStateJoin,
			NdisFddiStateVerify,
			NdisFddiStateActive,
			NdisFddiStateMaintenance
		};

		//
		// Defines the medium subtypes for WAN medium (OID_WAN_MEDIUM_SUBTYPE).
		//
		public enum NDIS_WAN_MEDIUM_SUBTYPE 
		{
			NdisWanMediumHub,
			NdisWanMediumX_25,
			NdisWanMediumIsdn,
			NdisWanMediumSerial,
			NdisWanMediumFrameRelay,
			NdisWanMediumAtm,
			NdisWanMediumSonet,
			NdisWanMediumSW56K
		};

		//
		// Defines the header format for WAN medium (OID_WAN_HEADER_FORMAT).
		//
		public enum NDIS_WAN_HEADER_FORMAT 
		{
			NdisWanHeaderNative,	// src/dest based on subtype, followed by NLPID
			NdisWanHeaderEthernet	// emulation of ethernet header
		};

		//
		// Defines the line quality on a WAN line (OID_WAN_QUALITY_OF_SERVICE).
		//
		public enum NDIS_WAN_QUALITY 
		{
			NdisWanRaw,
			NdisWanErrorControl,
			NdisWanReliable
		};

		//
		// Defines the state of a token-ring adapter (OID_802_5_CURRENT_RING_STATE).
		//
		public enum NDIS_802_5_RING_STATE 
		{
			NdisRingStateOpened = 1,
			NdisRingStateClosed,
			NdisRingStateOpening,
			NdisRingStateClosing,
			NdisRingStateOpenFailure,
			NdisRingStateRingFailure
		};

		//
		// Defines the state of the LAN media
		//
		public enum NDIS_MEDIA_STATE 
		{
			NdisMediaStateConnected,
			NdisMediaStateDisconnected
		};

		public static string GetMediaStateString( int Value )
		{
			string Tmp = "";

			switch( Value )
			{
				case (int) NDIS_MEDIA_STATE.NdisMediaStateConnected :
					Tmp = "Media is connected";
					break;

				case (int) NDIS_MEDIA_STATE.NdisMediaStateDisconnected :
					Tmp = "Media is disconnected";
					break;
			}

			return Tmp;
		}


		//      The following structure is used to query OID_GEN_CO_LINK_SPEED and
		//      OID_GEN_CO_MINIMUM_LINK_SPEED.  The first OID will return the current
		//      link speed of the adapter.  The second will return the minimum link speed
		//      the adapter is capable of.
		//

		public struct NDIS_CO_LINK_SPEED 
		{
			public ulong Outbound;
			public ulong Inbound;
		};

		//
		// Ndis Packet Filter Bits (OID_GEN_CURRENT_PACKET_FILTER).
		//
		public static uint  NDIS_PACKET_TYPE_DIRECTED				= 0x0001;
		public static uint  NDIS_PACKET_TYPE_MULTICAST				= 0x0002;
		public static uint  NDIS_PACKET_TYPE_ALL_MULTICAST			= 0x0004;
		public static uint  NDIS_PACKET_TYPE_BROADCAST				= 0x0008;
		public static uint  NDIS_PACKET_TYPE_SOURCE_ROUTING			= 0x0010;
		public static uint  NDIS_PACKET_TYPE_PROMISCUOUS			= 0x0020;
		public static uint  NDIS_PACKET_TYPE_SMT					= 0x0040;
		public static uint  NDIS_PACKET_TYPE_ALL_LOCAL				= 0x0080;
		public static uint  NDIS_PACKET_TYPE_MAC_FRAME				= 0x8000;
		public static uint  NDIS_PACKET_TYPE_FUNCTIONAL				= 0x4000;
		public static uint  NDIS_PACKET_TYPE_ALL_FUNCTIONAL			= 0x2000;
		public static uint  NDIS_PACKET_TYPE_GROUP					= 0x1000;

		public static string GetCurrentPacketFilterString( int Value )
		{
			string Tmp = "";

			if( ( Value & NDIS_PACKET_TYPE_DIRECTED ) == NDIS_PACKET_TYPE_DIRECTED )
				Tmp += "Directed,";
			if( ( Value & NDIS_PACKET_TYPE_MULTICAST ) == NDIS_PACKET_TYPE_MULTICAST )
				Tmp += "Multicast,";
			if( ( Value & NDIS_PACKET_TYPE_ALL_MULTICAST ) == NDIS_PACKET_TYPE_ALL_MULTICAST )
				Tmp += "All multicast,";
			if( ( Value & NDIS_PACKET_TYPE_BROADCAST ) == NDIS_PACKET_TYPE_BROADCAST )
				Tmp += "Broadcast,";
			if( ( Value & NDIS_PACKET_TYPE_SOURCE_ROUTING ) == NDIS_PACKET_TYPE_SOURCE_ROUTING )
				Tmp += "Source routing,";
			if( ( Value & NDIS_PACKET_TYPE_PROMISCUOUS ) == NDIS_PACKET_TYPE_PROMISCUOUS )
				Tmp += "Promiscous,";
			if( ( Value & NDIS_PACKET_TYPE_SMT ) == NDIS_PACKET_TYPE_SMT )
				Tmp += "Smt,";
			if( ( Value & NDIS_PACKET_TYPE_ALL_LOCAL ) == NDIS_PACKET_TYPE_ALL_LOCAL )
				Tmp += "All local,";
			if( ( Value & NDIS_PACKET_TYPE_MAC_FRAME ) == NDIS_PACKET_TYPE_MAC_FRAME )
				Tmp += "Mac frame,";
			if( ( Value & NDIS_PACKET_TYPE_FUNCTIONAL ) == NDIS_PACKET_TYPE_FUNCTIONAL )
				Tmp += "Functional,";
			if( ( Value & NDIS_PACKET_TYPE_ALL_FUNCTIONAL ) == NDIS_PACKET_TYPE_ALL_FUNCTIONAL )
				Tmp += "All functional,";
			if( ( Value & NDIS_PACKET_TYPE_GROUP ) == NDIS_PACKET_TYPE_GROUP )
				Tmp += "Group,";

			if( Tmp.Length > 0 )
				Tmp = Tmp.Substring( 0 , Tmp.Length - 1 );

			return Tmp;
		}

		//
		// Ndis Token-Ring Ring Status Codes (OID_802_5_CURRENT_RING_STATUS).
		//
		public static uint  NDIS_RING_SIGNAL_LOSS					= 0x00008000;
		public static uint  NDIS_RING_HARD_ERROR					= 0x00004000;
		public static uint  NDIS_RING_SOFT_ERROR					= 0x00002000;
		public static uint  NDIS_RING_TRANSMIT_BEACON				= 0x00001000;
		public static uint  NDIS_RING_LOBE_WIRE_FAULT				= 0x00000800;
		public static uint  NDIS_RING_AUTO_REMOVAL_ERROR			= 0x00000400;
		public static uint  NDIS_RING_REMOVE_RECEIVED				= 0x00000200;
		public static uint  NDIS_RING_COUNTER_OVERFLOW				= 0x00000100;
		public static uint  NDIS_RING_SINGLE_STATION				= 0x00000080;
		public static uint  NDIS_RING_RING_RECOVERY					= 0x00000040;
		//
		// Ndis protocol option bits (OID_GEN_PROTOCOL_OPTIONS).
		//
		public static uint  NDIS_PROT_OPTION_ESTIMATED_LENGTH   	= 0x00000001;
		public static uint  NDIS_PROT_OPTION_NO_LOOPBACK			= 0x00000002;
		public static uint  NDIS_PROT_OPTION_NO_RSVD_ON_RCVPKT		= 0x00000004;

		public static string GetProtocolOptionsString( int Value )
		{
			string Tmp = "";

			if( ( Value & NDIS_PROT_OPTION_ESTIMATED_LENGTH ) == NDIS_PROT_OPTION_ESTIMATED_LENGTH )
				Tmp += "Estimated length,";
			if( ( Value & NDIS_PROT_OPTION_NO_LOOPBACK ) == NDIS_PROT_OPTION_NO_LOOPBACK )
				Tmp += "No loopback,";
			if( ( Value & NDIS_PROT_OPTION_NO_RSVD_ON_RCVPKT ) == NDIS_PROT_OPTION_NO_RSVD_ON_RCVPKT )
				Tmp += "No reserved on receive packet,";

			if( Tmp.Length > 0 )
				Tmp = Tmp.Substring( 0 , Tmp.Length - 1 );

			return Tmp;

		}

		//
		// Ndis MAC option bits (OID_GEN_MAC_OPTIONS).
		//
		public static int NDIS_MAC_OPTION_COPY_LOOKAHEAD_DATA 	= 0x00000001;
		public static int NDIS_MAC_OPTION_RECEIVE_SERIALIZED  	= 0x00000002;
		public static int NDIS_MAC_OPTION_TRANSFERS_NOT_PEND  	= 0x00000004;
		public static int NDIS_MAC_OPTION_NO_LOOPBACK			= 0x00000008;
		public static int NDIS_MAC_OPTION_FULL_DUPLEX			= 0x00000010;
		public static int NDIS_MAC_OPTION_EOTX_INDICATION		= 0x00000020;
		public static uint NDIS_MAC_OPTION_RESERVED				= 0x80000000;

		public static string GetMacOptionsString( int Value )
		{
			string Tmp = "";

			if( ( Value & NDIS_MAC_OPTION_COPY_LOOKAHEAD_DATA ) == NDIS_MAC_OPTION_COPY_LOOKAHEAD_DATA )
				Tmp += "Copy lookahead data,";
			if( ( Value & NDIS_MAC_OPTION_RECEIVE_SERIALIZED ) == NDIS_MAC_OPTION_RECEIVE_SERIALIZED )
				Tmp += "Receive serialized,";
			if( ( Value & NDIS_MAC_OPTION_TRANSFERS_NOT_PEND ) == NDIS_MAC_OPTION_TRANSFERS_NOT_PEND )
				Tmp += "Transfers not pend,";
			if( ( Value & NDIS_MAC_OPTION_NO_LOOPBACK ) == NDIS_MAC_OPTION_NO_LOOPBACK )
				Tmp += "no loopback,";
			if( ( Value & NDIS_MAC_OPTION_FULL_DUPLEX ) == NDIS_MAC_OPTION_FULL_DUPLEX )
				Tmp += "full duplex,";
			if( ( Value & NDIS_MAC_OPTION_EOTX_INDICATION ) == NDIS_MAC_OPTION_EOTX_INDICATION )
				Tmp += "End of transmit indication,";
			if( ( Value & NDIS_MAC_OPTION_RESERVED ) == NDIS_MAC_OPTION_RESERVED )
				Tmp += "reserved,";

			if( Tmp.Length > 0 )
				Tmp = Tmp.Substring( 0 , Tmp.Length - 1 );

			return Tmp;
		}

		//
		//      NDIS MAC option bits for OID_GEN_CO_MAC_OPTIONS.
		//
		public static uint 	NDIS_CO_MAC_OPTION_DYNAMIC_LINK_SPEED	= 0x00000001;

		// The following is set on a per-packet basis as OOB data with NdisClassIrdaPacketInfo
		// This is the per-packet info specified on a per-packet basis
		//
		public struct NDIS_IRDA_PACKET_INFO 
		{
			public uint ExtraBOFs;
			public uint MinTurnAroundTime;
		}

		// Wireless WAN structure definitions
		// currently defined Wireless network subtypes

		public enum NDIS_WW_NETWORK_TYPE 
		{
			NdisWWGeneric,
			NdisWWMobitex,
			NdisWWPinpoint,
			NdisWWCDPD,
			NdisWWArdis,
			NdisWWDataTAC,
			NdisWWMetricom,
			NdisWWGSM,
			NdisWWCDMA,
			NdisWWTDMA,
			NdisWWAMPS,
			NdisWWInmarsat,
			NdisWWpACT
		};

		//
		// currently defined header formats
		//
		public enum NDIS_WW_HEADER_FORMAT 
		{
			NdisWWDIXEthernetFrames,
			NdisWWMPAKFrames,
			NdisWWRDLAPFrames,
			NdisWWMDC4800Frames
		};

		//
		// currently defined encryption types
		//
		public enum NDIS_WW_ENCRYPTION_TYPE 
		{
			NdisWWUnknownEncryption = -1,
			NdisWWNoEncryption,
			NdisWWDefaultEncryption
		};

		//
		// OID_WW_GEN_INDICATION_REQUEST
		//
		public struct NDIS_WW_INDICATION_REQUEST 
		{
			public NDIS_OID Oid;		// IN
			public uint uIndicationFlag;	// IN
			public uint uApplicationToken;	// IN OUT
			public HANDLE hIndicationHandle;	// IN OUT
			public int iPollingInterval;	// IN OUT
			public NDIS_VAR_DATA_DESC InitialValue;	// IN OUT
			public NDIS_VAR_DATA_DESC OIDIndicationValue;	// OUT - only valid after indication
			public NDIS_VAR_DATA_DESC TriggerValue;	// IN
		};

		public static uint  OID_INDICATION_REQUEST_ENABLE			= 0x0000;
		public static uint  OID_INDICATION_REQUEST_CANCEL			= 0x0001;
		//
		// OID_WW_GEN_DEVICE_INFO
		//
		public struct WW_DEVICE_INFO 
		{
			public NDIS_VAR_DATA_DESC Manufacturer;
			public NDIS_VAR_DATA_DESC ModelNum;
			public NDIS_VAR_DATA_DESC SWVersionNum;
			public NDIS_VAR_DATA_DESC SerialNum;
		};

		// OID_WW_GEN_CURRENT_ADDRESS   
		//
		public struct WW_CURRENT_ADDRESS 
		{
			public NDIS_WW_HEADER_FORMAT Format;
			public NDIS_VAR_DATA_DESC Address;
		};

		//
		// OID_WW_TAC_SET_CONFIG
		public struct WW_TAC_SETCONFIG 
		{
			public NDIS_VAR_DATA_DESC RCV_MODE;
			public NDIS_VAR_DATA_DESC TX_CONTROL;
			public NDIS_VAR_DATA_DESC RX_CONTROL;
			public NDIS_VAR_DATA_DESC FLOW_CONTROL;
			public NDIS_VAR_DATA_DESC RESET_CNF;
			public NDIS_VAR_DATA_DESC READ_CNF;
		};

		//
		// OID_WW_TAC_GET_STATUS
		public struct WW_TAC_GETSTATUS 
		{
			public int Action;		// Set = Execute command.
			public NDIS_VAR_DATA_DESC Command;
			public NDIS_VAR_DATA_DESC Option;
			public NDIS_VAR_DATA_DESC Response;	// The response to the requested command
			// - max. length of string is 256 octets.
		};


		public struct WW_ARD_SNDCP 
		{
			public NDIS_VAR_DATA_DESC Version;	// The version of SNDCP protocol supported.
			public int BlockSize;		// The block size used for SNDCP
			public int Window;			// The window size used in SNDCP

		};

		public struct WW_ARD_DATAGRAM 
		{
			public int LoadLevel;		// Byte that contains the load level info.
			public int SessionTime;		// Datagram session time remaining.
			public NDIS_VAR_DATA_DESC HostAddr;	// Host address.
			public NDIS_VAR_DATA_DESC THostAddr;	// Test host address.

		};

		//
		// OID_WW_CDPD_SPNI

		public struct WW_CDPD_SPNI 
		{
			public uint [] SPNI;		//size = 10 16-bit service provider network IDs
			public int OperatingMode;		// 0 = ignore SPNI,
			// 1 = require SPNI from list,
			// 2 = prefer SPNI from list.
			// 3 = exclude SPNI from list.
		};

		//
		// OID_WW_CDPD_WASI
		//
		public struct WW_CDPD_WIDE_AREA_SERVICE_ID 
		{
			public int [] WASI;		//10 16-bit wide area service IDs
			public int OperatingMode;		// 0 = ignore WASI,
			// 1 = Require WASI from list,
			// 2 = prefer WASI from list
			// 3 = exclude WASI from list.
		};


		public struct WW_CDPD_CHANNEL_SELECT 
		{
			public uint ChannelID;		// channel number
			public uint fixedDuration;		// duration in seconds
		};

		//
		// OID_WW_CDPD_CHANNEL_STATE
		//
		public enum WW_CDPD_CHANNEL_STATE 
		{
			CDPDChannelNotAvail,
			CDPDChannelScanning,
			CDPDChannelInitAcquired,
			CDPDChannelAcquired,
			CDPDChannelSleeping,
			CDPDChannelWaking,
			CDPDChannelCSDialing,
			CDPDChannelCSRedial,
			CDPDChannelCSAnswering,
			CDPDChannelCSConnected,
			CDPDChannelCSSuspended
		};

		//
		// OID_WW_CDPD_NEI
		//
		public enum WW_CDPD_NEI_FORMAT 
		{
			CDPDNeiIPv4,
			CDPDNeiCLNP,
			CDPDNeiIPv6
		};

		public enum WW_CDPD_NEI_TYPE 
		{
			CDPDNeiIndividual,
			CDPDNeiMulticast,
			CDPDNeiBroadcast
		};

		public struct WW_CDPD_NEI 
		{
			public uint uNeiIndex;
			public WW_CDPD_NEI_FORMAT NeiFormat;
			public WW_CDPD_NEI_TYPE NeiType;
			public uint NeiGmid;		// group member identifier, only
			// meaningful if NeiType ==
			// CDPDNeiMulticast
			public NDIS_VAR_DATA_DESC NeiAddress;
		};

		//
		// OID_WW_CDPD_NEI_STATE
		//
		public enum WW_CDPD_NEI_STATE 
		{
			CDPDUnknown,
			CDPDRegistered,
			CDPDDeregistered
		};

		public enum WW_CDPD_NEI_SUB_STATE 
		{
			CDPDPending,		// Registration pending
			CDPDNoReason,		// Registration denied - no reason given
			CDPDMDISNotCapable,	// Registration denied - MD-IS not capable of
			//  handling M-ES at this time
			CDPDNEINotAuthorized,	// Registration denied - NEI is not authorized to
			//  use this subnetwork
			CDPDInsufficientAuth,	// Registration denied - M-ES gave insufficient
			//  authentication credentials
			CDPDUnsupportedAuth,	// Registration denied - M-ES gave unsupported
			//  authentication credentials
			CDPDUsageExceeded,		// Registration denied - NEI has exceeded usage
			//  limitations
			CDPDDeniedThisNetwork	// Registration denied on this network, service
			//  may be obtained on alternate Service Provider
			//  network
		};

		public struct WW_CDPD_NEI_REG_STATE 
		{
			public uint uNeiIndex;
			public WW_CDPD_NEI_STATE NeiState;
			public WW_CDPD_NEI_SUB_STATE NeiSubState;
		};

		//
		// OID_WW_CDPD_SERVICE_PROVIDER_IDENTIFIER
		//
		public struct WW_CDPD_SERVICE_PROVIDER_ID 
		{
			public uint [] SPI;		//10 16-bit service provider IDs
			public int OperatingMode;		// 0 = ignore SPI,
			// 1 = require SPI from list,
			// 2 = prefer SPI from list.
			// 3 = exclude SPI from list.
		};

		//
		// OID_WW_CDPD_CIRCUIT_SWITCHED
		//
		public struct WW_CDPD_CIRCUIT_SWITCHED 
		{
			public int service_preference;	// -1 = unknown,
			//  0 = always use packet switched CDPD,
			//  1 = always use CS CDPD via AMPS,
			//  2 = always use CS CDPD via PSTN,
			//  3 = use circuit switched via AMPS only
			//      when packet switched is not available.
			//  4 = use packet switched only when circuit
			//   switched via AMPS is not available.
			//  5 = device manuf. defined service
			//   preference.
			//  6 = device manuf. defined service
			//   preference.
			public int service_status;		// -1 = unknown,
			//  0 = packet switched CDPD,
			//  1 = circuit switched CDPD via AMPS,
			//  2 = circuit switched CDPD via PSTN.
			public int connect_rate;		//  CS connection bit rate (bits per second).
			//  0 = no active connection,
			// -1 = unknown
			//  Dial code last used to dial.
			public NDIS_VAR_DATA_DESC [] dial_code; // 20;
			public uint sid;			//  Current AMPS system ID
			public int a_b_side_selection;	// -1 = unknown,
			//  0 = no AMPS service
			//  1 = AMPS "A" side channels selected
			//  2 = AMPS "B" side channels selected
			public int AMPS_channel;		// -1= unknown
			//  0 = no AMPS service.
			//  1-1023 = AMPS channel number in use
			public uint action;		//  0 = no action
			//  1 = suspend (hangup)
			//  2 = dial
			//  Default dial code for CS CDPD service
			//  encoded as specified in the CS CDPD
			//  implementor guidelines.
			public NDIS_VAR_DATA_DESC [] default_dial; // 20;
			//  Number for the CS CDPD network to call
			//   back the mobile, encoded as specified in
			//   the CS CDPD implementor guidelines.
			public NDIS_VAR_DATA_DESC [] call_back; // 20;
			public uint [] sid_list; // 10;		//  List of 10 16-bit preferred AMPS
			//   system IDs for CS CDPD.
			public uint inactivity_timer;	//  Wait time after last data before dropping
			//   call.
			//  0-65535 = inactivity time limit (seconds).
			public uint receive_timer;		//  secs. per CS-CDPD Implementor Guidelines.
			public uint conn_resp_timer;	//  secs. per CS-CDPD Implementor Guidelines.
			public uint reconn_resp_timer;	//  secs. per CS-CDPD Implementor Guidelines.
			public uint disconn_timer;		//  secs. per CS-CDPD Implementor Guidelines.
			public uint NEI_reg_timer;		//  secs. per CS-CDPD Implementor Guidelines.
			public uint reconn_retry_timer;	//  secs. per CS-CDPD Implementor Guidelines.
			public uint link_reset_timer;	//  secs. per CS-CDPD Implementor Guidelines.
			public uint link_reset_ack_timer;	//  secs. per CS-CDPD Implementor Guidelines.
			public uint n401_retry_limit;	//  per CS-CDPD Implementor Guidelines.
			public uint n402_retry_limit;	//  per CS-CDPD Implementor Guidelines.
			public uint n404_retry_limit;	//  per CS-CDPD Implementor Guidelines.
			public uint n405_retry_limit;	//  per CS-CDPD Implementor Guidelines.
		};

		public struct WW_PIN_LOCATION 
		{
			public int Latitude;		// Latitude in hundredths of a second
			public int Longitude;		// Longitude in hundredths of a second
			public int Altitude;		// Altitude in feet
			public int FixTime;		// Time of the location fix, since midnight,  local time (of the
			// current day), in tenths of a second
			public int NetTime;		// Current local network time of the current day, since midnight,
			// in tenths of a second
			public int LocQuality;		// 0-100 = location quality
			public int LatReg;			// Latitude registration offset, in hundredths of a second
			public int LongReg;		// Longitude registration offset, in hundredths of a second
			public int GMTOffset;		// Offset in minutes of the local time zone from GMT
		};

		//
		// OID_WW_MBX_SUBADDR
		//

		public struct WW_MBX_PMAN 
		{
			public int ACTION;		// 0 = Login PMAN,  1 = Logout PMAN
			public uint MAN;
			public char [] PASSWORD; // [8];		// Password should be null for Logout and indications.
			// Maximum length of password is 8 chars.
		};

		//
		// OID_WW_MBX_FLEXLIST
		//
		public struct WW_MBX_FLEXLIST 
		{
			public int count;			//  Number of MAN entries used.
			// -1=unknown.
			public uint [] MAN; //[7];		//  List of MANs.
		};

		//
		// OID_WW_MBX_GROUPLIST
		//
		public struct WW_MBX_GROUPLIST 
		{
			public int count;			//  Number of MAN entries used.
			// -1=unknown.
			public uint [] MAN; // [15];		//  List of MANs.
		};

		//
		// OID_WW_MBX_TRAFFIC_AREA
		//
		public enum WW_MBX_TRAFFIC_AREA 
		{
			unknown_traffic_area,	// The driver has no information about the current traffic area.
			in_traffic_area,		// Mobile unit has entered a subscribed traffic area.
			in_auth_traffic_area,	// Mobile unit is outside traffic area but is authorized.
			unauth_traffic_area	// Mobile unit is outside traffic area but is un-authorized.
		};

		//
		// OID_WW_MBX_TEMP_DEFAULTLIST
		//

		public struct WW_MBX_CHANNEL_PAIR 
		{
			public uint Mobile_Tx;
			public uint Mobile_Rx;
		};

		public struct WW_MBX_TEMPDEFAULTLIST 
		{
			public uint Length;
			public WW_MBX_CHANNEL_PAIR [] ChannelPair; // [1];
		};


		public NtddNDish()
		{

		}

		public static uint NDIS_CONTROL_CODE( uint request, uint method)
		{
			return DeviceIOCtlh.CTL_CODE( DeviceIOCtlh.FILE_DEVICE_PHYSICAL_NETCARD, request, method, DeviceIOCtlh.FILE_ANY_ACCESS);
		}
	}
}
