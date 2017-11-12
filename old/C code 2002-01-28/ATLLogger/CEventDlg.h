// CEventDlg.h : Declaration of the CCEventDlg

#ifndef __CEVENTDLG_H_
#define __CEVENTDLG_H_

#include <comutil.h>
#include <commctrl.h>

#include "resource.h"       // main symbols
#include <atlhost.h>


class CCoLogger ;
/////////////////////////////////////////////////////////////////////////////
// CCEventDlg
class CCEventDlg : 
	public CAxDialogImpl<CCEventDlg>
{
public:
	CCoLogger *m_pParent;
	CCEventDlg(CCoLogger *parent)
	{
		m_bLogHalted = FALSE;
		m_pParent = parent ;
		m_bFirstTime = TRUE;
	}

	~CCEventDlg()
	{
	}
private:BOOL m_bLogHalted;

public:	enum { IDD = IDD_CEVENTDLG };


BEGIN_MSG_MAP(CCEventDlg)
	MESSAGE_HANDLER(WM_INITDIALOG, OnInitDialog)
	COMMAND_ID_HANDLER(IDOK, OnOK)
	COMMAND_ID_HANDLER(IDCANCEL, OnCancel)
	COMMAND_HANDLER(IDC_LOGBOX, LBN_DBLCLK, OnDblclkLogbox)
	COMMAND_HANDLER(IDC_LOGBOX, LBN_ERRSPACE, OnErrspaceLogbox)
	COMMAND_HANDLER(IDC_HALT, BN_CLICKED, OnClickedHalt)
	COMMAND_HANDLER(IDC_RESUME, BN_CLICKED, OnClickedResume)
	COMMAND_HANDLER(IDC_CLEARSCR, BN_CLICKED, OnClickedClearscr)
	NOTIFY_HANDLER(IDC_LISTCTRL, LVN_COLUMNCLICK, OnColumnclickListctrl)
END_MSG_MAP()
// Handler prototypes:
//  LRESULT MessageHandler(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
//  LRESULT CommandHandler(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled);
//  LRESULT NotifyHandler(int idCtrl, LPNMHDR pnmh, BOOL& bHandled);

	LRESULT OnInitDialog(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);

	LRESULT OnOK(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled);
	
	LRESULT OnCancel(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled);
	LRESULT OnDblclkLogbox(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled);
	LRESULT OnErrspaceLogbox(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled);
	long GetCurSel()
	{
		return ::SendMessage(GetDlgItem(IDC_LOGBOX),LB_GETCURSEL,0,0);
	}
	BOOL m_bFirstTime;
	void AddString(LPCTSTR DisplayStr)
	{

		if(m_bLogHalted) return;
		SYSTEMTIME lSysTime;
		::GetSystemTime(&lSysTime);
		char DisplayBfr[255];
		sprintf(DisplayBfr,"%d/%d/%d...%d::%d::%d::%d",
								lSysTime.wMonth,
								lSysTime.wDay,
								lSysTime.wYear,
								lSysTime.wHour,
								lSysTime.wMinute,
								lSysTime.wSecond,
								lSysTime.wMilliseconds);

		//add string to list box...
		if(m_bFirstTime)
		{
			LC_InsertItem(0,0,const_cast<char*>(DisplayStr));
			LC_InsertItem(1,1,const_cast<char*>(DisplayBfr));
			m_bFirstTime =FALSE;
		}
		else
		{
			LC_InsertItem(0,0,const_cast<char*>(DisplayStr),1);
			LC_InsertItem(1,1,const_cast<char*>(DisplayBfr),1);
		}

		//::SendMessage(GetDlgItem(IDC_LOGBOX),LB_ADDSTRING,0,(LPARAM)DisplayBfr);
		

	}

	LRESULT OnClickedHalt(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
	{
		m_bLogHalted= TRUE;
		return 0;
	}
	LRESULT OnClickedResume(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
	{
		m_bLogHalted = FALSE;
		return 0;
	}
	LRESULT OnClickedClearscr(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
	{
		//reset contents of list box...
		::SendMessage(GetDlgItem(IDC_LOGBOX),LB_RESETCONTENT,0,0);

		return 0;
	}
	void LC_InsertItem(int nItem,int nSubItem,LPTSTR Text,BOOL bFirstTime = TRUE);
	void CCEventDlg::LC_SetTextColor(COLORREF BkClr,COLORREF BkFore);
	LRESULT OnColumnclickListctrl(int idCtrl, LPNMHDR pnmh, BOOL& bHandled);
	
};

#endif //__CEVENTDLG_H_
