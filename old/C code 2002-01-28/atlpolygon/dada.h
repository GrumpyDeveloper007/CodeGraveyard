// dada.h : Declaration of the Cdada

#ifndef __DADA_H_
#define __DADA_H_

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// Cdada
class ATL_NO_VTABLE Cdada : 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<Cdada, &CLSID_dada>,
	public IDispatchImpl<Idada, &IID_Idada, &LIBID_POLYGONLib>
{
public:
	Cdada()
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_DADA)

DECLARE_PROTECT_FINAL_CONSTRUCT()

BEGIN_COM_MAP(Cdada)
	COM_INTERFACE_ENTRY(Idada)
	COM_INTERFACE_ENTRY(IDispatch)
END_COM_MAP()

// Idada
public:
};

#endif //__DADA_H_
