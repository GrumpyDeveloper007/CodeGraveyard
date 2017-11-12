// cStrings.h: Definition of the cStrings class
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CSTRINGS_H__BD9DD030_CF3C_11D3_B60F_93EEA1CC2573__INCLUDED_)
#define AFX_CSTRINGS_H__BD9DD030_CF3C_11D3_B60F_93EEA1CC2573__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "resource.h"       // main symbols
//#include <comdef.h>




/////////////////////////////////////////////////////////////////////////////
// cStrings

class cStrings : 
	public IDispatchImpl<IcStrings, &IID_IcStrings, &LIBID_ELFLIBLib>, 
	public ISupportErrorInfo,
	public CComObjectRoot,
	public CComCoClass<cStrings,&CLSID_cStrings>
{
private:
	long NumTokens;
	BSTR Tokens[100];
//	BSTR *TestString=_T("Dale Test");
public:
	cStrings() 
	{
		NumTokens=1;
		Tokens[0]=L"Fuck Sake";
		Tokens[1]=L"Testing";
	}
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
	STDMETHOD(tisoperator)(long i,long h);
	STDMETHOD(IsOperator)(BSTR *pVal,long pPosition);
	STDMETHOD(get_Tokens)(long TokenNumber, /*[out, retval]*/ BSTR *pVal);
	STDMETHOD(get_NumTokens)(/*[out, retval]*/ long *pVal);
};

#endif // !defined(AFX_CSTRINGS_H__BD9DD030_CF3C_11D3_B60F_93EEA1CC2573__INCLUDED_)
