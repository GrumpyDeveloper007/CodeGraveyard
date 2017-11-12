// VBTest1.cpp : Implementation of CVBTestApp and DLL registration.

#include "stdafx.h"
#include "VBTest.h"
#include "VBTest1.h"

/////////////////////////////////////////////////////////////////////////////
//

STDMETHODIMP VBTest1::InterfaceSupportsErrorInfo(REFIID riid)
{
	static const IID* arr[] = 
	{
		&IID_IBase,
	};

	for (int i=0;i<sizeof(arr)/sizeof(arr[0]);i++)
	{
		if (InlineIsEqualGUID(*arr[i],riid))
			return S_OK;
	}
	return S_FALSE;
}

STDMETHODIMP VBTest1::MethodBase()
{
	// TODO: Add your implementation code here
	MessageBox(NULL, "MethodBase - 1", "MethodBase - 1", MB_OK);
	return S_OK;
}
