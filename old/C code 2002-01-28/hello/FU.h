#if !defined(AFX_FU_H__8DA05901_CF47_11D3_B60F_93EEA1CC2573__INCLUDED_)
#define AFX_FU_H__8DA05901_CF47_11D3_B60F_93EEA1CC2573__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// FU.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// FU dialog

class FU : public CDialog
{
// Construction
public:
	FU(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(FU)
	enum { IDD = IDD_FU };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(FU)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(FU)
		// NOTE: the ClassWizard will add member functions here
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FU_H__8DA05901_CF47_11D3_B60F_93EEA1CC2573__INCLUDED_)
