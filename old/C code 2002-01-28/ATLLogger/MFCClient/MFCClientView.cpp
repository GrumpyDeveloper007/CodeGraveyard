// MFCClientView.cpp : implementation of the CMFCClientView class
//

#include "stdafx.h"
#include "MFCClient.h"

#include "MFCClientDoc.h"
#include "MFCClientView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMFCClientView

IMPLEMENT_DYNCREATE(CMFCClientView, CView)

BEGIN_MESSAGE_MAP(CMFCClientView, CView)
	//{{AFX_MSG_MAP(CMFCClientView)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
	// Standard printing commands
	ON_COMMAND(ID_FILE_PRINT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_DIRECT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, CView::OnFilePrintPreview)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMFCClientView construction/destruction

CMFCClientView::CMFCClientView()
{
	// TODO: add construction code here

}

CMFCClientView::~CMFCClientView()
{
}

BOOL CMFCClientView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CMFCClientView drawing

void CMFCClientView::OnDraw(CDC* pDC)
{
	CMFCClientDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);
	// TODO: add draw code for native data here
}

/////////////////////////////////////////////////////////////////////////////
// CMFCClientView printing

BOOL CMFCClientView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// default preparation
	return DoPreparePrinting(pInfo);
}

void CMFCClientView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add extra initialization before printing
}

void CMFCClientView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add cleanup after printing
}

/////////////////////////////////////////////////////////////////////////////
// CMFCClientView diagnostics

#ifdef _DEBUG
void CMFCClientView::AssertValid() const
{
	CView::AssertValid();
}

void CMFCClientView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CMFCClientDoc* CMFCClientView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CMFCClientDoc)));
	return (CMFCClientDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CMFCClientView message handlers
