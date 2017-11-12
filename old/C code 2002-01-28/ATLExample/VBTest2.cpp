// VBTest2.cpp : Implementation of CVBTestApp and DLL registration.

#include "stdafx.h"
#include "VBTest.h"
#include "VBTest2.h"

/////////////////////////////////////////////////////////////////////////////
//

STDMETHODIMP VBTest2::InterfaceSupportsErrorInfo(REFIID riid)
{
	static const IID* arr[] = 
	{
		&IID_IBase,
		&IID_IDerived,
	};

	for (int i=0;i<sizeof(arr)/sizeof(arr[0]);i++)
	{
		if (InlineIsEqualGUID(*arr[i],riid))
			return S_OK;
	}
	return S_FALSE;
}

STDMETHODIMP VBTest2::MethodBase()
{
	// TODO: Add your implementation code here
	MessageBox(NULL, "MethodBase - 2", "MethodBase - 2", MB_OK);
	return S_OK;
}

STDMETHODIMP VBTest2::MethodDerived()
{
	// TODO: Add your implementation code here
	MessageBox(NULL, "MethodDerived", "MethodDerived", MB_OK);
	return S_OK;
}
