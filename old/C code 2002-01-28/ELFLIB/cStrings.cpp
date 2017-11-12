// cStrings.cpp : Implementation of CELFLIBApp and DLL registration.

#include "stdafx.h"
#include "ELFLIB.h"
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
	*pVal=NumTokens;
	return S_OK;
}



STDMETHODIMP cStrings::get_Tokens(long TokenNumber, BSTR *pVal)
{
	// TODO: Add your implementation code here

	// return error code if requested characters 
	// less than zero, or input string is unassigned 
	// or has too few characters
	
	
//	if (*pbstrArg1 == NULL || 
//		(int)SysStringByteLen(*pbstrArg1) < cch)
//		return -1; 
	
	
	if (*pVal != NULL)  // argument string is already assigned; 
		// we must free before allocating
		SysFreeString(*pVal);
		


	if ((*pVal = SysAllocString(Tokens[TokenNumber]) )== NULL)
		return S_OK;
		

	return S_OK;
}

STDMETHODIMP cStrings::IsOperator(BSTR *pVal, long pPosition)
{
	// TODO: Add your implementation code here

	return S_OK;
}

STDMETHODIMP cStrings::tisoperator(long i, long h)
{
	// TODO: Add your implementation code here

	return S_OK;
}
