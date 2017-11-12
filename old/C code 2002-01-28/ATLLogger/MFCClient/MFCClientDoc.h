// MFCClientDoc.h : interface of the CMFCClientDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_MFCCLIENTDOC_H__D97E8A62_C220_11D3_9739_0050047D51FB__INCLUDED_)
#define AFX_MFCCLIENTDOC_H__D97E8A62_C220_11D3_9739_0050047D51FB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class CMFCClientDoc : public CDocument
{
protected: // create from serialization only
	CMFCClientDoc();
	DECLARE_DYNCREATE(CMFCClientDoc)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMFCClientDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CMFCClientDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CMFCClientDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MFCCLIENTDOC_H__D97E8A62_C220_11D3_9739_0050047D51FB__INCLUDED_)
