// cStrings.h: Definition of the cStrings class
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CSTRINGS_H__9BBD6DB2_CEBD_11D3_B60F_D39622D2A572__INCLUDED_)
#define AFX_CSTRINGS_H__9BBD6DB2_CEBD_11D3_B60F_D39622D2A572__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// cStrings

class cStrings : 
	public IDispatchImpl<IcStrings, &IID_IcStrings, &LIBID_ATLTESTLib>, 
	public ISupportErrorInfo,
	public CComObjectRoot,
	public CComCoClass<cStrings,&CLSID_cStrings>
{
private:
	long vNumTokens;
public:
	cStrings() {}
BEGIN_COM_MAP(cStrings)
	COM_INTERFACE_ENTRY(IDispatch)
	COM_INTERFACE_ENTRY(IcStrings)
	COM_INTERFACE_ENTRY(ISupportErrorInfo)
END_COM_MAP()
//DECLARE_NOT_AGGREGATABLE(cStrings) 
// Remove the comment from the line above if you don't want your object to 
// support aggregation. 

DECLARE_REGISTRY_RESOURCEID(IDR_cStrings)
// ISupportsErrorInfo
	STDMETHOD(InterfaceSupportsErrorInfo)(REFIID riid);

// IcStrings
public:
	STDMETHOD(get_NumTokens)(/*[out, retval]*/ long *pVal);
	STDMETHOD(put_NumTokens)(/*[in]*/ long newVal);
};

#endif // !defined(AFX_CSTRINGS_H__9BBD6DB2_CEBD_11D3_B60F_D39622D2A572__INCLUDED_)
