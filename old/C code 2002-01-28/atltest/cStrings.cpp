// cStrings.cpp : Implementation of CAtltestApp and DLL registration.

#include "stdafx.h"
#include "atltest.h"
#include "cStrings.h"

/////////////////////////////////////////////////////////////////////////////
//

STDMETHODIMP cStrings::InterfaceSupportsErrorInfo(REFIID riid)
{
	static const IID* arr[] = 
	{
		&IID_IcStrings,
	};

	for (int i=0;i<sizeof(arr)/sizeof(arr[0]);i++)
	{
		if (InlineIsEqualGUID(*arr[i],riid))
			return S_OK;
	}
	return S_FALSE;
}

STDMETHODIMP cStrings::get_NumTokens(long *pVal)
{
	// TODO: Add your implementation code here
	*pVal=vNumTokens;
	return S_OK;
}

STDMETHODIMP cStrings::put_NumTokens(long newVal)
{
	// TODO: Add your implementation code here
	vNumTokens=newVal;
	return S_OK;
}

//DEL STDMETHODIMP cStrings::get_strr(BSTR *pparam, BSTR *pVal)
//DEL {
//DEL 	// TODO: Add your implementation code here
//DEL 
//DEL 	BSTR date[]="ddd";
//DEL 	return S_OK;
//DEL }

STDMETHODIMP cStrings::put_strr(pparam, BSTR newVal)
{
	// TODO: Add your implementation code here

	return S_OK;
}
