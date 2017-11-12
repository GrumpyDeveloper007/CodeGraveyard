// CEventDlg.cpp : Implementation of CCEventDlg
//copyright ashish dhar Jan 2000
//Use this code as is No Warranty is give...
#include "stdafx.h"
#include "ATLLogApp.h"
#include "CoLogger.h"
#include "CEventDlg.h"
#define lchwnd GetDlgItem(IDC_LISTCTRL)
/////////////////////////////////////////////////////////////////////////////
// CCEventDlg

/////////////////////////////////////////////////////////////////////////////
// CCEventDlg
	LRESULT CCEventDlg::OnInitDialog(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
	{
		//set the Horizontal extent...
		::SendMessage(GetDlgItem(IDC_LOGBOX),LB_SETHORIZONTALEXTENT,100,0);

		const int lTabArray[] = {300};
		//set tab stops...
		::SendMessage( GetDlgItem(IDC_LOGBOX), LB_SETTABSTOPS,1,(LPARAM)lTabArray);

		//set the Horizontal extent...
		::SendMessage(GetDlgItem(IDC_LOGBOX),LB_SETHORIZONTALEXTENT,100,0);

		LVCOLUMN lCol;
		lCol.mask = LVCF_TEXT|LVCF_WIDTH;
		lCol.cx = 350; ;
		lCol.pszText = "Event";
		lCol.cchTextMax  = 7;
		lCol.iSubItem = 0;
		::SendMessage(lchwnd,LVM_INSERTCOLUMN,0,(LPARAM) (const LPLVCOLUMN) &lCol);
		
		lCol.pszText = "TimeStamp";
		
		::SendMessage(lchwnd,LVM_INSERTCOLUMN,1,(LPARAM) (const LPLVCOLUMN) &lCol);
		//send back color
		COLORREF clrBk = RGB(244,217,133);
		lCol.cx = LVSCW_AUTOSIZE_USEHEADER;
		::SendMessage(lchwnd,LVM_SETBKCOLOR,0,(LPARAM) (COLORREF) clrBk);

		COLORREF BkFore = RGB(0,256,256);
		LC_SetTextColor(clrBk ,BkFore);

		return 1;  // Let the system set the focus
	}

	LRESULT CCEventDlg::OnOK(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
	{
		m_pParent->m_bDialogAlive  = FALSE;
		DestroyWindow()	;
		return 0;
	}

	LRESULT CCEventDlg::OnCancel(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
	{
		m_pParent->m_bDialogAlive  = FALSE;
		DestroyWindow()	;
		return 0; 
	}
	LRESULT CCEventDlg::OnDblclkLogbox(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
	{
		long lResult = GetCurSel();
			
		
		return 0;
	}
	LRESULT CCEventDlg::OnErrspaceLogbox(WORD wNotifyCode, WORD wID, HWND hWndCtl, BOOL& bHandled)
	{
		return 0;
	}

	void CCEventDlg::LC_InsertItem(int nItem,int nSubItem,LPTSTR Text,BOOL bFirstTime )
	{
		int lastItem = 0;
		LVITEM	lItem;
		lItem.mask = LVIF_TEXT ;
		if(!bFirstTime)
			lastItem = ::SendMessage(lchwnd,LVM_GETITEMCOUNT,0,0); 

		lItem.iItem =lastItem;
		lItem.iSubItem = nSubItem;
		lItem.state = 0;
		lItem.pszText = Text;
		lItem.cchTextMax = strlen(Text +1);
		if(nSubItem == 0)
			::SendMessage(lchwnd,LVM_INSERTITEM,0,(LPARAM) (const LPLVITEM) &lItem); 
		::SendMessage(lchwnd,LVM_SETITEM,0,(LPARAM) (const LPLVITEM) &lItem); 

	}
	void CCEventDlg::LC_SetTextColor(COLORREF BkClr,COLORREF BkFore)
	{

		::SendMessage(lchwnd,LVM_SETTEXTCOLOR,0,(LPARAM) (LPARAM)(COLORREF)BkFore); 
		::SendMessage(lchwnd,LVM_SETTEXTBKCOLOR,0,(LPARAM) (LPARAM)(COLORREF)BkClr); 

	}

	LRESULT CCEventDlg::OnColumnclickListctrl(int idCtrl, LPNMHDR pnmh, BOOL& bHandled)
	{
		
		return 0;
	}
