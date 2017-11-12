// CoLoggerClient.h : Declaration of the CCoLoggerClient

#ifndef __COLOGGERCLIENT_H_
#define __COLOGGERCLIENT_H_

#include "resource.h"       // main symbols
#import "..\ATLLogApp.tlb" no_namespace named_guids

/////////////////////////////////////////////////////////////////////////////
// CCoLoggerClient
class ATL_NO_VTABLE CCoLoggerClient : 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CCoLoggerClient, &CLSID_CoLoggerClient>,
	public ICoLoggerClient
{
public:
	CCoLoggerClient()
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_COLOGGERCLIENT)
DECLARE_NOT_AGGREGATABLE(CCoLoggerClient)

DECLARE_PROTECT_FINAL_CONSTRUCT()

BEGIN_COM_MAP(CCoLoggerClient)
	COM_INTERFACE_ENTRY(ICoLoggerClient)
END_COM_MAP()

// ICoLoggerClient
public:
	STDMETHOD(Log)(/*[in]*/ BSTR str);
	STDMETHOD(UnInitialize)();
	STDMETHOD(Initialize)();
private:
	ICoLoggerPtr m_Log;

};

#endif //__COLOGGERCLIENT_H_
