// MFCClientDoc.cpp : implementation of the CMFCClientDoc class
//

#include "stdafx.h"
#include "MFCClient.h"

#include "MFCClientDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMFCClientDoc

IMPLEMENT_DYNCREATE(CMFCClientDoc, CDocument)

BEGIN_MESSAGE_MAP(CMFCClientDoc, CDocument)
	//{{AFX_MSG_MAP(CMFCClientDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMFCClientDoc construction/destruction

CMFCClientDoc::CMFCClientDoc()
{
	// TODO: add one-time construction code here

}

CMFCClientDoc::~CMFCClientDoc()
{
}

BOOL CMFCClientDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CMFCClientDoc serialization

void CMFCClientDoc::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{
		// TODO: add storing code here
	}
	else
	{
		// TODO: add loading code here
	}
}

/////////////////////////////////////////////////////////////////////////////
// CMFCClientDoc diagnostics

#ifdef _DEBUG
void CMFCClientDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CMFCClientDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CMFCClientDoc commands
