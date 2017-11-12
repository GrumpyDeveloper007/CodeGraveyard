// Dlg.cpp : Implementation of CDlg
#include "stdafx.h"
#include "Dlg.h"

/////////////////////////////////////////////////////////////////////////////
// CDlg

CDlg::CDlg()
{
}

CDlg::~CDlg()
{
}

LRESULT CDlg::OnInitDialog(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
{
	return 1;  // Let the system set the focus
}

LRESULT CDlg::OnOK(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
{
	DestroyWindow();
	PostQuitMessage(0);
	return 0;
}

LRESULT CDlg::OnCancel(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
{
	DestroyWindow();
	PostQuitMessage(0);
	return 0;
}

