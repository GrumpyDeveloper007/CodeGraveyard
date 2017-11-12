// VBTest1.h: Definition of the VBTest1 class
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_VBTEST1_H__2F6E4233_2A8F_11D1_A988_002018349816__INCLUDED_)
#define AFX_VBTEST1_H__2F6E4233_2A8F_11D1_A988_002018349816__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// VBTest1

class VBTest1 : 
	public CComDualImpl<IBase, &IID_IBase, &LIBID_VBTESTLib>, 
	public ISupportErrorInfo,
	public CComObjectRoot,
	public CComCoClass<VBTest1,&CLSID_VBTest1>
{
public:
	VBTest1() {}
BEGIN_COM_MAP(VBTest1)
	COM_INTERFACE_ENTRY(IDispatch)
	COM_INTERFACE_ENTRY(IBase)
	COM_INTERFACE_ENTRY(ISupportErrorInfo)
END_COM_MAP()
//DECLARE_NOT_AGGREGATABLE(VBTest1) 
// Remove the comment from the line above if you don't want your object to 
// support aggregation. 

DECLARE_REGISTRY_RESOURCEID(IDR_VBTest1)
// ISupportsErrorInfo
	STDMETHOD(InterfaceSupportsErrorInfo)(REFIID riid);

// IBase
public:
	STDMETHOD(MethodBase)();
};

#endif // !defined(AFX_VBTEST1_H__2F6E4233_2A8F_11D1_A988_002018349816__INCLUDED_)
