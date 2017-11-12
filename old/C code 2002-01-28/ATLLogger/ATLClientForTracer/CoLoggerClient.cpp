// CoLoggerClient.cpp : Implementation of CCoLoggerClient
#include "stdafx.h"
#include "ATLClientForTracer.h"
#include "CoLoggerClient.h"

/////////////////////////////////////////////////////////////////////////////
// CCoLoggerClient


STDMETHODIMP CCoLoggerClient::Initialize()
{
	const HRESULT hrCreate = m_Log.CreateInstance(__uuidof(CoLogger));
	if(FAILED(hrCreate)) return E_FAIL;
	const HRESULT hrInit = m_Log->Initialize();	
	return hrInit;
	
	
}

STDMETHODIMP CCoLoggerClient::UnInitialize()
{
	return m_Log->UnInitialize();	

}

STDMETHODIMP CCoLoggerClient::Log(BSTR str)
{
	return m_Log->Log(str);

}
