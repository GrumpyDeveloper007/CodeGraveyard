using System;
using System.Runtime.InteropServices;
using System.Runtime;

namespace MyClasses
{

	public class WinService
	{

		public static int SYNCHRONIZE = 0x100000;
		public static int STANDARD_RIGHTS_REQUIRED = 0xF0000;
		public static int STANDARD_RIGHTS_ALL = STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE;
		public static int EVENT_ALL_ACCESS = (  STANDARD_RIGHTS_REQUIRED | 
												SYNCHRONIZE |
												0x3);

		public static uint ERROR_INVALID_HANDLE_VALUE = 6;
		public static uint INVALID_HANDLE_VALUE = 6;
		public static uint ERROR_ALREADY_EXISTS = 183;
		public static uint ERROR_MORE_DATA = 234;
		public static uint ERROR_DEPENDENT_SERVICES_RUNNING = 1051;
		public static uint ERROR_INVALID_SERVICE_CONTROL = 1052;
		public static uint ERROR_SERVICE_REQUEST_TIMEOUT = 1053;
		public static uint ERROR_SERVICE_NO_THREAD = 1054;
		public static uint ERROR_SERVICE_DATABASE_LOCKED = 1055;
		public static uint ERROR_SERVICE_ALREADY_RUNNING = 1056;
		public static uint ERROR_INVALID_SERVICE_ACCOUNT = 1057;
		public static uint ERROR_SERVICE_DISABLED = 1058;
		public static uint ERROR_CIRCULAR_DEPENDENCY = 1059;
		public static uint ERROR_SERVICE_DOES_NOT_EXIST = 1060;
		public static uint ERROR_SERVICE_CANNOT_ACCEPT_CTRL = 1061;
		public static uint ERROR_SERVICE_NOT_ACTIVE = 1062;
		public static uint ERROR_FAILED_SERVICE_CONTROLLER_CONNECT = 1063;
		public static uint ERROR_EXCEPTION_IN_SERVICE = 1064;
		public static uint ERROR_DATABASE_DOES_NOT_EXIST = 1065;
		public static uint ERROR_SERVICE_SPECIFIC_ERROR = 1066;
		public static uint ERROR_PROCESS_ABORTED = 1067;
		public static uint ERROR_SERVICE_DEPENDENCY_FAIL = 1068;
		public static uint ERROR_SERVICE_LOGON_FAILED = 1069;
		public static uint ERROR_SERVICE_START_HANG = 1070;
		public static uint ERROR_INVALID_SERVICE_LOCK = 1071;
		public static uint ERROR_SERVICE_MARKED_FOR_DELETE = 1072;
		public static uint ERROR_SERVICE_EXISTS = 1073;
		public static uint ERROR_ALREADY_RUNNING_LKG = 1074;
		public static uint ERROR_SERVICE_DEPENDENCY_DELETED = 1075;
		public static uint ERROR_BOOT_ALREADY_ACCEPTED = 1076;
		public static uint ERROR_SERVICE_NEVER_STARTED = 1077;
		public static uint ERROR_DUPLICATE_SERVICE_NAME = 1078;
		public static uint ERROR_DIFFERENT_SERVICE_ACCOUNT = 1079;


		//   Standart Service Access
		//public static uint STANDARD_RIGHTS_REQUIRED = 0xF0000;
		public static uint STD_DELETE = 0x10000;
		public static uint STD_READ_CONTROL = 0x20000;
		public static uint STD_WRITE_DAC = 0x40000;
		public static uint STD_WRITE_OWNER = 0x80000;
		

		public static uint SERVICE_ACCEPT_PAUSE_CONTINUE = 0x2;
		public static uint SERVICE_ACCEPT_SHUTDOWN = 0x4;
		public static uint SERVICE_ACCEPT_STOP = 0x1;
		public static uint SERVICE_ACTIVE = 0x1;
		public static uint SERVICE_CHANGE_CONFIG = 0x2;
		public static uint SERVICE_CONTINUE_PENDING = 0x5;
		public static uint SERVICE_CONTROL_CONTINUE = 0x3;
		public static uint SERVICE_CONTROL_INTERROGATE = 0x4;
		public static uint SERVICE_CONTROL_PAUSE = 0x2;
		public static uint SERVICE_CONTROL_SHUTDOWN = 0x5;
		public static uint SERVICE_CONTROL_STOP = 0x1;
		public static uint SERVICE_ENUMERATE_DEPENDENTS = 0x8;
		public static uint SERVICE_INACTIVE = 0x2;
		public static uint SERVICE_INTERROGATE = 0x80;
		public static uint SERVICE_NO_CHANGE = 0xFFFF;
		public static uint SERVICE_PAUSE_CONTINUE = 0x40;
		public static uint SERVICE_QUERY_CONFIG = 0x1;
		public static uint SERVICE_QUERY_STATUS = 0x4;
		public static uint SERVICE_START = 0x10;
		public static uint SERVICE_STATE_ALL = (SERVICE_ACTIVE | SERVICE_INACTIVE);
		public static uint SERVICE_STOP = 0x20;


		public static uint SERVICE_USER_DEFINED_CONTROL = 0x100;
		public static string SERVICES_ACTIVE_DATABASE = "ServicesActive";
		public static string SERVICES_FAILED_DATABASE = "ServicesFailed";
		public static uint SERVICE_ALL_ACCESS = ((uint)STANDARD_RIGHTS_REQUIRED | SERVICE_QUERY_CONFIG | 
			SERVICE_CHANGE_CONFIG | SERVICE_QUERY_STATUS |
			SERVICE_ENUMERATE_DEPENDENTS | SERVICE_START | SERVICE_STOP |
			SERVICE_PAUSE_CONTINUE | SERVICE_INTERROGATE |
			SERVICE_USER_DEFINED_CONTROL);


		public static uint SERVICE_STOPPED = 0x1;
		public static uint SERVICE_START_PENDING = 0x2;
		public static uint SERVICE_STOP_PENDING = 0x3;
		public static uint SERVICE_RUNNING = 0x4;
		public static uint SERVICE_PAUSE_PENDING = 0x6;
		public static uint SERVICE_PAUSED = 0x7;

		//   Service Type
		public static uint SERVICE_WIN32_OWN_PROCESS = 0x10;
		public static uint SERVICE_WIN32_SHARE_PROCESS = 0x20;
		public static uint SERVICE_KERNEL_DRIVER = 0x1;
		public static uint SERVICE_FILE_SYSTEM_DRIVER = 0x2;
		public static uint SERVICE_INTERACTIVE_PROCESS = 0x100;
		public static uint SERVICE_WIN32 = SERVICE_WIN32_OWN_PROCESS + SERVICE_WIN32_SHARE_PROCESS;
		public static uint SERVICE_DRIVER = SERVICE_KERNEL_DRIVER + SERVICE_FILE_SYSTEM_DRIVER;

		//   Service Start Type
		public static uint SERVICE_BOOT_START = 0x0;
		public static uint SERVICE_SYSTEM_START = 0x1;
		public static uint SERVICE_AUTO_START = 0x2;
		public static uint SERVICE_DEMAND_START = 0x3;
		public static uint SERVICE_DISABLED = 0x4;

		//   Service Error Control
		public static uint SERVICE_ERROR_NORMAL = 0x0;
		public static uint SERVICE_ERROR_IGNORE = 0x1;
		public static uint SERVICE_ERROR_SEVERE = 0x3;
		public static uint SERVICE_ERROR_CRITICAL = 0x4;


		// Service Control Manager Access
		public static uint SC_MANAGER_CONNECT = 0x1;
		public static uint SC_MANAGER_CREATE_SERVICE = 0x2;
		public static uint SC_MANAGER_ENUMERATE_SERVICE = 0x4;
		public static uint SC_MANAGER_LOCK = 0x8;
		public static uint SC_MANAGER_QUERY_LOCK_STATUS = 0x10;
		public static uint SC_MANAGER_MODIFY_BOOT_CONFIG = 0x20;
		public static uint SC_MANAGER_ALL_ACCESS = ((uint)STANDARD_RIGHTS_REQUIRED | SC_MANAGER_CONNECT |
			SC_MANAGER_CREATE_SERVICE | SC_MANAGER_ENUMERATE_SERVICE |
			SC_MANAGER_LOCK | SC_MANAGER_QUERY_LOCK_STATUS |
			SC_MANAGER_MODIFY_BOOT_CONFIG);

		public static uint GENERIC_READ = 0x80000000;
		public static uint GENERIC_WRITE = 0x40000000;
		public static uint GENERIC_EXECUTE = 0x20000000;
		public static uint GENERIC_ALL = 0x10000000;

		//   Service Security Information
		public static uint OWNER_SECURITY_INFORMATION = 0x1;
		public static uint GROUP_SECURITY_INFORMATION = 0x2;
		public static uint DACL_SECURITY_INFORMATION = 0x4;
		public static uint SACL_SECURITY_INFORMATION = 0x8;


		//   Service Bits
		public static uint SV_TYPE_WORKSTATION = 0x1;
		public static uint SV_TYPE_SERVER = 0x2;
		public static uint SV_TYPE_DOMAIN_CTRL = 0x8;
		public static uint SV_TYPE_DOMAIN_BAKCTRL = 0x10;
		public static uint SV_TYPE_TIME_SOURCE = 0x20;
		public static uint SV_TYPE_AFP = 0x40;
		public static uint SV_TYPE_DOMAIN_MEMBER = 0x100;
		public static uint SV_TYPE_PRINTQ_SERVER = 0x200;
		public static uint SV_TYPE_DIALIN_SERVER = 0x400;
		public static uint SV_TYPE_XENIX_SERVER = 0x800;
		public static uint SV_TYPE_SERVER_UNIX = 0x800;
		public static uint SV_TYPE_NT = 0x1000;
		public static uint SV_TYPE_WFW = 0x2000;
		public static uint SV_TYPE_POTENTIAL_BROWSER = 0x10000;
		public static uint SV_TYPE_BACKUP_BROWSER = 0x20000;
		public static uint SV_TYPE_MASTER_BROWSER = 0x40000;
		public static uint SV_TYPE_DOMAIN_MASTER = 0x80000;
		public static uint SV_TYPE_LOCAL_LIST_ONLY = 0x40000000;
		public static uint SV_TYPE_DOMAIN_ENUM = 0x80000000;

		public static uint SV_TYPE_SV_TYPE_SQLSERVER = 0x4;
		public static uint SV_TYPE_NOVELL = 0x80;

		public static uint SV_TYPE_USER1 = 0x4000;
		public static uint SV_TYPE_USER2 = 0x8000;
		public static uint SV_TYPE_USER3 = 0x400000;
		public static uint SV_TYPE_USER4 = 0x800000;
		public static uint SV_TYPE_USER5 = 0x1000000;
		public static uint SV_TYPE_USER6 = 0x2000000;
		public static uint SV_TYPE_USER7 = 0x4000000;
		public static uint SV_TYPE_USER8 = 0x8000000;
		public static uint SV_TYPE_USER9 = 0x10000000;
		public static uint SV_TYPE_USER10 = 0x20000000;

		//******************************************************************************
		//******************************************************************************
		//******************************************************************************

		//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
		public struct SERVICE_STATUS
		{
			public uint dwServiceType;
			public uint dwCurrentState;
			public uint dwControlsAccepted;
			public uint dwWin32ExitCode;
			public uint dwServiceSpecificExitCode;
			public uint dwCheckPoint;
			public uint dwWaitHint;
		}
		//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
		public struct ENUM_SERVICE_STATUS
		{
			public string lpServiceName; // Pointer to LPTSTR
			public string lpDisplayName; // Pointer to LPTSTR
			public SERVICE_STATUS ServiceStatus;
		}
		//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
		public struct QUERY_SERVICE_CONFIG
		{
			public uint dwServiceType;
			public uint dwStartType;
			public uint dwErrorControl;
			public string lpBinaryPathName; // Pointer to LPTSTR
			public string lpLoadOrderGroup ;// Pointer to LPTSTR
			public uint dwTagId;
			public string lpDependencies; // Pointer to LPTSTR
			public string lpServiceStartName; // Pointer to LPTSTR
			public string lpDisplayName; // Pointer to LPTSTR
			[MarshalAs(UnmanagedType.ByValArray, SizeConst = 2048)] public byte [] reserved;
		}
		//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
		public struct QUERY_SERVICE_LOCK_STATUS
		{
			public uint fIsLocked;
			public string lpLockOwner; // Pointer to LPTSTR
			public uint dwLockDuration;
		}
		//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
		public struct SERVICE_TABLE_ENTRY
		{
			public string lpServiceName; // Pointer to LPTSTR
			public string lpServiceProc; // Points to ServiceMain Function
		}
		//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
		public struct EXTENDED_SERVICE_CONFIG
		{
			public string lpServiceName;
			public string lpDisplayName;
			public string lpServiceStartName;
			public string lpDependencies;
			public string lpBinaryPathName;
			public string lpLoadOrderGroup;
			public uint dwServiceType;
			public uint dwCurrentState;
			public uint dwControlsAccepted;
			public uint dwWin32ExitCode;
			public uint dwServiceSpecificExitCode;
			public uint dwCheckPoint;
			public uint dwWaitHint;
			public uint dwStartType;
			public uint dwErrorControl;
			public uint dwTagId;
		}
		//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


		public delegate void ServiceHandler( uint fdwControl );


		[DllImport("advapi32.dll", EntryPoint="OpenSCManagerW")] public static extern int
			OpenSCManager( string lpMachineName, string lpDatabaseName, uint dwDesiredAccess );

		[DllImport("advapi32.dll", EntryPoint="OpenSCManagerW")] public static extern int
			OpenSCManager( ref string lpMachineName, string lpDatabaseName, uint dwDesiredAccess );

		[DllImport("advapi32.dll", EntryPoint="OpenSCManagerW")] public static extern int
			OpenSCManager( ref string lpMachineName, ref string lpDatabaseName, uint dwDesiredAccess );

		[DllImport("advapi32.dll", EntryPoint="OpenSCManagerW")] public static extern int
			OpenSCManager( int lpMachineName, int lpDatabaseName, uint dwDesiredAccess );


		//******************************************************************************
		//BOOL ChangeServiceConfig(
		//
		//    SC_HANDLE hService, // handle to service
		//    DWORD dwServiceType,    // type of service
		//    DWORD dwStartType,  // when to start service
		//    DWORD dwErrorControl,   // severity if service fails to start
		//    LPCTSTR lpBinaryPathName,   // pointer to service binary file name
		//    LPCTSTR lpLoadOrderGroup,   // pointer to load ordering group name
		//    LPDWORD lpdwTagId,  // pointer to variable to get tag identifier
		//    LPCTSTR lpDependencies, // pointer to array of dependency names
		//    LPCTSTR lpServiceStartName, // pointer to account name of service
		//    LPCTSTR lpPassword, // pointer to password for service account
		//    LPCTSTR lpDisplayName   // pointer to display name
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			ChangeServiceConfigW(
			int hService,
			uint dwServiceType,
			uint dwStartType,
			uint dwErrorControl,
			string lpBinaryPathName,
			string lpLoadOrderGroup,
			ref uint lpdwTagId,
			string lpDependencies,
			string lpServiceStartName,
			string lpPassword,
			string lpDisplayName );
		//******************************************************************************
		//BOOL CloseServiceHandle(
		//
		//    SC_HANDLE hSCObject     // handle to service or service control manager database
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			CloseServiceHandle( int hSCObject );
		//******************************************************************************
		//BOOL ControlService(
		//
		//    SC_HANDLE hService, // handle to service
		//    DWORD dwControl,    // control code
		//    LPSERVICE_STATUS lpServiceStatus    // pointer to service status structure
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			ControlService( int hService,
			uint dwControl,
			ref SERVICE_STATUS lpServiceStatus);
		//******************************************************************************
		//SC_HANDLE CreateService(
		//
		//    SC_HANDLE hSCManager,   // handle to service control manager database
		//    LPCTSTR lpServiceName,  // pointer to name of service to start
		//    LPCTSTR lpDisplayName,  // pointer to display name
		//    DWORD dwDesiredAccess,  // type of access to service
		//    DWORD dwServiceType,    // type of service
		//    DWORD dwStartType,  // when to start service
		//    DWORD dwErrorControl,   // severity if service fails to start
		//    LPCTSTR lpBinaryPathName,   // pointer to name of binary file
		//    LPCTSTR lpLoadOrderGroup,   // pointer to name of load ordering group
		//    LPDWORD lpdwTagId,  // pointer to variable to get tag identifier
		//    LPCTSTR lpDependencies, // pointer to array of dependency names
		//    LPCTSTR lpServiceStartName, // pointer to account name of service
		//    LPCTSTR lpPassword  // pointer to password for service account
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			CreateService(int hSCManager,
			string lpServiceName,
			string lpDisplayName,
			uint dwDesiredAccess,
			uint dwServiceType,
			uint dwStartType,
			uint dwErrorControl,
			string lpBinaryPathName,
			string lpLoadOrderGroup,
			ref uint lpdwTagId,
			string lpDependencies,
			string lpServiceStartName,
			string lpPassword );

		[DllImport("advapi32.dll")] public static extern int
			CreateService(int hSCManager,
			ref string lpServiceName,
			ref string lpDisplayName,
			uint dwDesiredAccess,
			uint dwServiceType,
			uint dwStartType,
			uint dwErrorControl,
			ref string lpBinaryPathName,
			ref string lpLoadOrderGroup,
			ref uint lpdwTagId,
			ref string lpDependencies,
			ref string lpServiceStartName,
			ref string lpPassword );


		[DllImport("advapi32.dll")] public static extern int
			CreateService(int hSCManager,
			int lpServiceName,
			int lpDisplayName,
			uint dwDesiredAccess,
			uint dwServiceType,
			uint dwStartType,
			uint dwErrorControl,
			int lpBinaryPathName,
			int lpLoadOrderGroup,
			ref uint lpdwTagId,
			int lpDependencies,
			int lpServiceStartName,
			int lpPassword );

		[DllImport("advapi32.dll")] public static extern int
			CreateService(int hSCManager,
			int lpServiceName,
			int lpDisplayName,
			uint dwDesiredAccess,
			uint dwServiceType,
			uint dwStartType,
			uint dwErrorControl,
			int lpBinaryPathName,
			int lpLoadOrderGroup,
			int lpdwTagId,
			int lpDependencies,
			int lpServiceStartName,
			int lpPassword );

		//******************************************************************************
		//BOOL DeleteService(
		//
		//    SC_HANDLE hService  // handle to service
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			DeleteService( int hService );

		//******************************************************************************
		//BOOL EnumDependentServices(
		//
		//    SC_HANDLE hService, // handle to service
		//    DWORD dwServiceState,   // state of services to enumerate
		//    LPENUM_SERVICE_STATUS lpServices,   // pointer to service status buffer
		//    DWORD cbBufSize,    // size of service status buffer
		//    LPDWORD pcbBytesNeeded, // pointer to variable for bytes needed
		//    LPDWORD lpServicesReturned  // pointer to variable for number returned
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			EnumDependentServicesW( int hService,
			uint dwServiceState,
			ref ENUM_SERVICE_STATUS [] lpServices,
			uint cbBuffSize,
			ref uint pcbBytesNeeded,
			ref uint lpServicesReturned );
		//******************************************************************************
		//BOOL EnumServicesStatus(
		//
		//    SC_HANDLE hSCManager,   // handle to service control manager database
		//    DWORD dwServiceType,    // type of services to enumerate
		//    DWORD dwServiceState,   // state of services to enumerate
		//    LPENUM_SERVICE_STATUS lpServices,   // pointer to service status buffer
		//    DWORD cbBufSize,    // size of service status buffer
		//    LPDWORD pcbBytesNeeded, // pointer to variable for bytes needed
		//    LPDWORD lpServicesReturned, // pointer to variable for number returned
		//    LPDWORD lpResumeHandle  // pointer to variable for next entry
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			EnumServicesStatusW(int hSCManager,
			uint dwServiceType,
			uint dwServiceState,
			ref ENUM_SERVICE_STATUS lpServices,
			uint cbBufSize,
			ref uint pcbBytesNeeded,
			ref uint lpServicesReturned,
			ref uint lpResumeHandle );
		//******************************************************************************
		//BOOL GetServiceDisplayName(
		//
		//    SC_HANDLE hSCManager,   // handle to a service control manager database
		//    LPCTSTR lpServiceName,  // the service name
		//    LPTSTR lpDisplayName,   // buffer to receive the service//s display name
		//    LPDWORD lpcchBuffer     // size of display name buffer and display name
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			GetServiceDisplayNameW( int hSCManager,
			string lpServiceName,
			string lpDisplayName,
			ref uint lpcchBuffer );
		//******************************************************************************
		//BOOL GetServiceKeyName(
		//
		//    SC_HANDLE hSCManager,   // handle to a service control manager database
		//    LPCTSTR lpDisplayName,  // the service//s display name
		//    LPTSTR lpServiceName,   // buffer to receive the service name
		//    LPDWORD lpcchBuffer     // size of service name buffer and service name
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			GetServiceKeyNameW( int hSCManager,
			string lpDisplayName,
			string lpServiceName,
			ref uint lpcchBuffer );
		//******************************************************************************
		//VOID WINAPI Handler(
		//
		//    DWORD fdwControl    // requested control code
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			Handler( uint fdwControl );
		//******************************************************************************
		//SC_LOCK LockServiceDatabase(
		//
		//    SC_HANDLE hSCManager    // handle of service control manager database
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			LockServiceDatabase( int hSCManager );
		//******************************************************************************
		//BOOL NotifyBootConfigStatus(
		//
		//    BOOL BootAcceptable     // indicates acceptability of boot configuration
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			NotifyBootConfigStatus( uint BootAcceptable );
		//******************************************************************************
		//SC_HANDLE OpenSCManager(
		//
		//    LPCTSTR lpMachineName,  // pointer to machine name string
		//    LPCTSTR lpDatabaseName, // pointer to database name string
		//    DWORD dwDesiredAccess   // type of access
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			OpenSCManagerW( string lpMachineName,
			string lpDatabaseName,
			uint dwDesiredAccess );
		//******************************************************************************
		//SC_HANDLE OpenService(
		//
		//    SC_HANDLE hSCManager,   // handle to service control manager database
		//    LPCTSTR lpServiceName,  // pointer to name of service to start
		//    DWORD dwDesiredAccess   // type of access to service
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll", EntryPoint="OpenServiceW")] public static extern int
			OpenService(int hSCManager,
			string lpServiceName,
			uint dwDesiredAccess );

		[DllImport("advapi32.dll", EntryPoint="OpenServiceW")] public static extern int
			OpenService(int hSCManager,
			int lpServiceName,
			uint dwDesiredAccess );

		//******************************************************************************
		//BOOL QueryServiceConfig(
		//
		//    SC_HANDLE hService, // handle of service
		//    LPQUERY_SERVICE_CONFIG lpServiceConfig, // address of service config. structure
		//    DWORD cbBufSize,    // size of service configuration buffer
		//    LPDWORD pcbBytesNeeded  // address of variable for bytes needed
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			QueryServiceConfigW(int hService,
			ref QUERY_SERVICE_CONFIG lpServiceConfig,
			uint cbBufSize,
			ref uint pcbBytesNeeded );
		//******************************************************************************
		//BOOL QueryServiceLockStatus(
		//
		//    SC_HANDLE hSCManager,   // handle of svc. ctrl. mgr. database
		//    LPQUERY_SERVICE_LOCK_STATUS lpLockStatus,   // address of lock status structure
		//    DWORD cbBufSize,    // size of service configuration buffer
		//    LPDWORD pcbBytesNeeded  // address of variable for bytes needed
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			QueryServiceLockStatusW(int hSCManager,
			uint lpLockStatus,
			uint cbBufSize,
			ref uint pcbBytesNeeded );
		//******************************************************************************
		//BOOL QueryServiceObjectSecurity(
		//
		//    SC_HANDLE hService, // handle of service
		//    SECURITY_INFORMATION dwSecurityInformation, // type of security information requested
		//    PSECURITY_DESCRIPTOR lpSecurityDescriptor,  // address of security descriptor
		//    DWORD cbBufSize,    // size of security descriptor buffer
		//    LPDWORD pcbBytesNeeded  // address of variable for bytes needed
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			QueryServiceObjectSecurity(	int hService,
			uint dwSecurityInformation,
			uint lpSecurityDiscriptor,
			uint cbBufSize,
			ref uint pcbBytesNeeded );
		//******************************************************************************
		//BOOL QueryServiceStatus(

		//    SC_HANDLE hService, // handle of service
		//    LPSERVICE_STATUS lpServiceStatus    // address of service status structure
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			QueryServiceStatus( int hService,
			ref SERVICE_STATUS lpServiceStatus );
		//******************************************************************************
		//SERVICE_STATUS_HANDLE RegisterServiceCtrlHandler(
		//
		//    LPCTSTR lpServiceName,  // address of name of service
		//    LPHANDLER_FUNCTION lpHandlerProc    // address of handler function
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			RegisterServiceCtrlHandlerW( string lpServiceName,
			ServiceHandler lpHandlerProc );
		//******************************************************************************
		//VOID WINAPI ServiceMain(
		//
		//    DWORD dwArgc,   // number of arguments
		//    LPTSTR *lpszArgv    // address of array of argument string pointers
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			ServiceMain( uint dwArgc,
			uint lpszArgv );
		//******************************************************************************
		//BOOL SetServiceBits(
		//
		//    SERVICE_STATUS_HANDLE hServiceStatus,   // service status handle
		//    DWORD dwServiceBits,    // service type bits to set or clear
		//    BOOL bSetBitsOn,    // flag to set or clear the service type bits
		//    BOOL bUpdateImmediately // flag to announce server type immediately
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			SetServiceBits( int hServiceStatus,
			uint dwServiceBits,
			uint bSetBitsOn,
			uint bUpdateImmediately );
		//******************************************************************************
		//BOOL SetServiceObjectSecurity(
		//
		//    SC_HANDLE hService, // handle of service
		//    SECURITY_INFORMATION dwSecurityInformation, // type of security information requested
		//    PSECURITY_DESCRIPTOR lpSecurityDescriptor   // address of security descriptor
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			SetServiceObjectSecurity( int hService,
			uint dwSecurityInformation,
			uint lpSecurityDescriptor );
		//******************************************************************************
		//BOOL SetServiceStatus(
		//
		//    SERVICE_STATUS_HANDLE hServiceStatus~,  // service status handle
		//    LPSERVICE_STATUS lpServiceStatus    // address of status structure
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			SetServiceStatus( int hServiceStatus,
			ref SERVICE_STATUS lpServiceStatus );
		//******************************************************************************
		//BOOL StartService(
		//
		//    SC_HANDLE hService, // handle of service
		//    DWORD dwNumServiceArgs, // number of arguments
		//    LPCTSTR *lpServiceArgVectors    // address of array of argument string pointers
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll", EntryPoint="StartServiceW")] public static extern int
			StartService(  int hService,
			uint dwNumServiceArgs,
			ref string lpServiceArgVectors );

		[DllImport("advapi32.dll", EntryPoint="StartServiceW")] public static extern int
			StartService(  int hService,
			uint dwNumServiceArgs,
			int lpServiceArgVectors );

		//******************************************************************************
		//BOOL StartServiceCtrlDispatcher(
		//
		//    LPSERVICE_TABLE_ENTRY lpServiceStartTable   // address of service table
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			StartServiceCtrlDispatcherW( uint lpServiceStartTable );
		//******************************************************************************
		//BOOL UnlockServiceDatabase(
		//
		//    SC_LOCK ScLock  // service control manager database lock to be released
		//   );
		//------------------------------------------------------------------------------
		[DllImport("advapi32.dll")] public static extern int
			UnlockServiceDatabase( uint ScLock );
		//******************************************************************************


		public WinService()
		{

		}
	}
}
