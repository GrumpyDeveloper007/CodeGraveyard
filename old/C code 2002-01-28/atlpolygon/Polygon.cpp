// Polygon.cpp : Implementation of DLL Exports.


// Note: Proxy/Stub Information
//      To build a separate proxy/stub DLL,
//      run nmake -f Polygonps.mk in the project directory.

#include "stdafx.h"
#include "resource.h"
#include <initguid.h>
#include "Polygon.h"

#include "Polygon_i.c"
#include "PolyCtl.h"
#include "PolyProp.h"
#include "dada.h"


CComModule _Module;

BEGIN_OBJECT_MAP(ObjectMap)
OBJECT_ENTRY(CLSID_PolyCtl, CPolyCtl)
OBJECT_ENTRY(CLSID_PolyProp, CPolyProp)
OBJECT_ENTRY(CLSID_dada, Cdada)
END_OBJECT_MAP()

/////////////////////////////////////////////////////////////////////////////
// DLL Entry Point

extern "C"
BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID /*lpReserved*/)
{
	if (dwReason == DLL_PROCESS_ATTACH)
	{
		_Module.Init(ObjectMap, hInstance, &LIBID_POLYGONLib);
		DisableThreadLibraryCalls(hInstance);
	}
	else if (dwReason == DLL_PROCESS_DETACH)
		_Module.Term();
	return TRUE;    // ok
}

/////////////////////////////////////////////////////////////////////////////
// Used to determine whether the DLL can be unloaded by OLE

STDAPI DllCanUnloadNow(void)
{
	return (_Module.GetLockCount()==0) ? S_OK : S_FALSE;
}

/////////////////////////////////////////////////////////////////////////////
// Returns a class factory to create an object of the requested type

STDAPI DllGetClassObject(REFCLSID rclsid, REFIID riid, LPVOID* ppv)
{
	return _Module.GetClassObject(rclsid, riid, ppv);
}

/////////////////////////////////////////////////////////////////////////////
// DllRegisterServer - Adds entries to the system registry

STDAPI DllRegisterServer(void)
{
	// registers object, typelib and all interfaces in typelib
	return _Module.RegisterServer(TRUE);
}

/////////////////////////////////////////////////////////////////////////////
// DllUnregisterServer - Removes entries from the system registry

STDAPI DllUnregisterServer(void)
{
	HRESULT hr = _Module.UnregisterServer();

#if _WIN32_WINNT >= 0x0400
	if (FAILED(hr))
		return hr;
	// Following assumes that the type library version is 1.0
	hr = UnRegisterTypeLib(LIBID_POLYGONLib, 1, 0, LOCALE_NEUTRAL, SYS_WIN32);
#endif

	return hr;
}
