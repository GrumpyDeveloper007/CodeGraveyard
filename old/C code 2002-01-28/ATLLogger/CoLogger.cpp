// CoLogger.cpp : Implementation of CCoLogger
#include "stdafx.h"
#include "ATLLogApp.h"
#include "CoLogger.h"

/////////////////////////////////////////////////////////////////////////////
// CCoLogger

/////////////////////////////////////////////////////////////////////////////
// CCoLogger


STDMETHODIMP CCoLogger::Initialize()
{
	
	m_Dlg = new CCEventDlg(this);
	m_Dlg ->Create(NULL);
	m_bDialogAlive = TRUE;
	return S_OK;
}

STDMETHODIMP CCoLogger::DisplayText()
{
	if(!m_bDialogAlive ) return S_FALSE;
	return S_OK;
}

STDMETHODIMP CCoLogger::Log(BSTR Message)
{
	if(!m_bDialogAlive ) return S_FALSE;
	_bstr_t Msg(Message);
	m_Dlg->AddString(Msg);
	return S_OK;
}

STDMETHODIMP CCoLogger::UnInitialize()
{
	if(!m_bDialogAlive ) return S_FALSE;
	m_Dlg->DestroyWindow();
	return S_OK;
}

