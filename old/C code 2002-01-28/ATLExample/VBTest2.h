// VBTest2.h: Definition of the VBTest2 class
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_VBTEST2_H__2F6E4230_2A8F_11D1_A988_002018349816__INCLUDED_)
#define AFX_VBTEST2_H__2F6E4230_2A8F_11D1_A988_002018349816__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// VBTest2

class VBTest2 : 
	public CComDualImpl<IDerived, &IID_IDerived, &LIBID_VBTESTLib>, 
	public ISupportErrorInfo,
	public CComObjectRoot,
	public CComCoClass<VBTest2,&CLSID_VBTest2>
{
public:
	VBTest2() {}
BEGIN_COM_MAP(VBTest2)
	COM_INTERFACE_ENTRY2(IDispatch, IDerived)
	COM_INTERFACE_ENTRY2(IBase, IDerived)
	COM_INTERFACE_ENTRY(IDerived)
	COM_INTERFACE_ENTRY(ISupportErrorInfo)
END_COM_MAP()
//DECLARE_NOT_AGGREGATABLE(VBTest2) 
// Remove the comment from the line above if you don't want your object to 
// support aggregation. 

DECLARE_REGISTRY_RESOURCEID(IDR_VBTest2)
// ISupportsErrorInfo
	STDMETHOD(InterfaceSupportsErrorInfo)(REFIID riid);

// IBase

// IDerived
public:
	STDMETHOD(MethodDerived)();
	STDMETHOD(MethodBase)();
};

#endif // !defined(AFX_VBTEST2_H__2F6E4230_2A8F_11D1_A988_002018349816__INCLUDED_)
