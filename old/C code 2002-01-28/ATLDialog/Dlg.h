// Dlg.h : Declaration of the CDlg

#ifndef __DLG_H_
#define __DLG_H_

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CDlg
class CDlg : 
	public CDialogImpl<CDlg>
{
public:
	CDlg();
	~CDlg();

	enum { IDD = IDD_DLG };

BEGIN_MSG_MAP(CDlg)
	MESSAGE_HANDLER(WM_INITDIALOG, OnInitDialog)
	COMMAND_ID_HANDLER(IDOK, OnOK)
	COMMAND_ID_HANDLER(IDCANCEL, OnCancel)
END_MSG_MAP()

	LRESULT OnInitDialog(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
	LRESULT OnOK(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled);
	LRESULT OnCancel(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled);
};

#endif //__DLG_H_
