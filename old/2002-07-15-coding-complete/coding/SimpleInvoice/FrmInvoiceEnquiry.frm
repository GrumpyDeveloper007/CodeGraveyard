VERSION 5.00
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#3.0#0"; "Flp32a30.ocx"
Begin VB.Form FrmInvoiceEnquiry 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Invoice Enquiry"
   ClientHeight    =   6870
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10980
   ControlBox      =   0   'False
   HelpContextID   =   8
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   458
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   732
   Begin LpLib.fpList GrdInvoice 
      Height          =   5115
      Left            =   0
      TabIndex        =   1
      Top             =   1200
      Width           =   10935
      _Version        =   196608
      _ExtentX        =   19288
      _ExtentY        =   9022
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      MousePointer    =   0
      Object.TabStop         =   0   'False
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Columns         =   10
      Sorted          =   0
      LineWidth       =   1
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   1
      SearchMethod    =   0
      VirtualMode     =   0   'False
      VRowCount       =   0
      DataSync        =   3
      ThreeDInsideStyle=   1
      ThreeDInsideHighlightColor=   -2147483633
      ThreeDInsideShadowColor=   -2147483642
      ThreeDInsideWidth=   1
      ThreeDOutsideStyle=   1
      ThreeDOutsideHighlightColor=   16777215
      ThreeDOutsideShadowColor=   -2147483632
      ThreeDOutsideWidth=   1
      ThreeDFrameWidth=   0
      BorderStyle     =   0
      BorderColor     =   -2147483642
      BorderWidth     =   1
      ThreeDOnFocusInvert=   0   'False
      ThreeDFrameColor=   -2147483633
      Appearance      =   0
      BorderDropShadow=   0
      BorderDropShadowColor=   -2147483632
      BorderDropShadowWidth=   3
      ScrollHScale    =   2
      ScrollHInc      =   0
      ColsFrozen      =   0
      ScrollBarV      =   2
      NoIntegralHeight=   0   'False
      HighestPrecedence=   0
      AllowColResize  =   0
      AllowColDragDrop=   0
      ReadOnly        =   0   'False
      VScrollSpecial  =   0   'False
      VScrollSpecialType=   0
      EnableKeyEvents =   -1  'True
      EnableTopChangeEvent=   -1  'True
      DataAutoHeadings=   -1  'True
      DataAutoSizeCols=   2
      SearchIgnoreCase=   -1  'True
      ScrollBarH      =   3
      VirtualPageSize =   0
      VirtualPagesAhead=   0
      ExtendCol       =   0
      ColumnLevels    =   1
      ListGrayAreaColor=   -2147483637
      GroupHeaderHeight=   -1
      GroupHeaderShow =   -1  'True
      AllowGrpResize  =   0
      AllowGrpDragDrop=   0
      MergeAdjustView =   0   'False
      ColumnHeaderShow=   -1  'True
      ColumnHeaderHeight=   -1
      GrpsFrozen      =   0
      BorderGrayAreaColor=   -2147483637
      ExtendRow       =   0
      DataField       =   ""
      OLEDragMode     =   0
      OLEDropMode     =   0
      Redraw          =   -1  'True
      ResizeRowToFont =   0   'False
      TextTipMultiLine=   0
      ColDesigner     =   "FrmInvoiceEnquiry.frx":0000
   End
   Begin VB.OptionButton OPTSearchBy 
      Caption         =   "Due Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Index           =   2
      Left            =   6960
      TabIndex        =   10
      Top             =   960
      Width           =   1215
   End
   Begin VB.OptionButton OPTSearchBy 
      Caption         =   "Invoice Number"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Index           =   0
      Left            =   0
      TabIndex        =   9
      Top             =   960
      Value           =   -1  'True
      Width           =   1695
   End
   Begin VB.OptionButton OPTSearchBy 
      Caption         =   "Name"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Index           =   1
      Left            =   4440
      TabIndex        =   8
      Top             =   960
      Width           =   855
   End
   Begin VB.CommandButton CMDEnterPayment 
      Caption         =   "Enter Payment"
      Height          =   375
      Left            =   4680
      TabIndex        =   7
      Top             =   6480
      Width           =   1215
   End
   Begin VB.CommandButton CMDPrintStatement 
      Caption         =   "Print Statement"
      Height          =   375
      Left            =   3000
      TabIndex        =   6
      Top             =   6480
      Width           =   1335
   End
   Begin VB.CommandButton CMDShowInvoice 
      Caption         =   "Show Invoice"
      Height          =   375
      Left            =   1440
      TabIndex        =   5
      Top             =   6480
      Width           =   1215
   End
   Begin VB.CommandButton CMDPrintList 
      Caption         =   "Print List"
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   6480
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   9840
      TabIndex        =   3
      Top             =   6480
      Width           =   1095
   End
   Begin VB.CheckBox CHKShowArchived 
      Caption         =   "Show Archived"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   0
      TabIndex        =   2
      Top             =   480
      Visible         =   0   'False
      Width           =   1695
   End
   Begin VB.ComboBox CBOSearchType 
      Height          =   315
      Left            =   0
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   60
      Width           =   7575
   End
End
Attribute VB_Name = "FrmInvoiceEnquiry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Invoice Enquiry Class
''
'' Coded by Dale Pitman

''
Private vParent As Form                 ' The parent that this form belongs to
Private vInvoiceForm As FRMInvoice
Private vPaymentForm As FRMPayment
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one
Private vIsLoaded As Boolean

'' This property indicates if this form is currently visible
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

'' General function to make currently active form visible (if a child is active then that form should be made visible),Hierarchical function
Public Sub SetFormFocus()
    If (Me.Enabled = False) Then
        Call vCurrentActiveChild.SetFormFocus
    Else
        Me.ZOrder
    End If
End Sub

'' A simple additional property to indicate form type
Public Property Get ChildType() As ChildTypesENUM
'    ChildType =
End Property

'' Used to attach this form to parent, for callback/context knowledge
Public Sub SetParent(pform As Form)
    Set vParent = pform
End Sub

'' Hierarchical function, used to clear all details within any sub-classes
Public Sub ResetForm()
    Call ClearDetails
End Sub

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
    Call CBOSearchType_Click
End Sub

'' A 'Show' type function used to activate/trigger any functionality on a per-operation basis
Public Function Search() As Boolean
    
    Screen.MousePointer = vbHourglass
    Call AllFormsShow(Me)
    Me.Visible = True
    
    Search = False
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' reset all class details
Private Sub ClearDetails()
    CMDShowInvoice.Enabled = False
'    CMDRePrintInvoice.Enabled = False
    CMDPrintStatement.Enabled = False
    CMDEnterPayment.Enabled = False
End Sub


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CBOSearchType_Click()
    Dim rstemp As Recordset
    Dim sql As String
    Dim AddAnd As Boolean
    Dim StatementCount As Long
    Dim StatementDate As String
    Dim rsStatement As Recordset
    
    Call ClearDetails
    sql = "SELECT S.Uid as SaleID,c.uid as CustomerID,i.paymentdate,i.uid as invoiceid,i.invoicenumber,i.GoodsTotal,i.vattotal,i.handlingtotal,c.companyname,i.duedate,i.Amountpaid FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid "
    Select Case CBOSearchType.ListIndex
        Case 0  ' Unpaid invoices
            sql = sql & "WHERE i.invoicetype=0 AND i.amountpaid<i.goodstotal+i.vattotal+i.handlingtotal"
            AddAnd = True
        Case 1  ' Paid Invoices
            sql = sql & "WHERE i.invoicetype=0 AND i.amountpaid=i.goodstotal+i.vattotal+i.handlingtotal"
            AddAnd = True
        Case 2  ' Overdue Unpaid Invoices
            sql = sql & "WHERE i.invoicetype=0 AND i.amountpaid<i.goodstotal+i.vattotal+i.handlingtotal AND DueDate<" & cDateChar & Format(Now, "dd/mm/yyyy") & cDateChar
            AddAnd = True
        Case 3  ' All Invoices
            sql = sql & "WHERE i.invoicetype=0 " 'i.invoicetype=0
            AddAnd = True
    End Select
    If (CHKShowArchived.Value = vbChecked) Then
'        sql = sql & " AND i.status=1"
    Else
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & " i.status=0"
    End If
    
    Call GrdInvoice.Clear
    If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
        
        Do While (rstemp.EOF = False)
            StatementCount = 0
            If (OpenRecordset(rsStatement, "SELECT Count(*) AS cout FROM Statement WHERE InvoiceID=" & rstemp!Invoiceid, dbOpenSnapshot)) Then
                StatementCount = rsStatement!cout
                rsStatement.Close
            End If
            StatementDate = 0
            If (OpenRecordset(rsStatement, "SELECT MAX(StatementDate) AS cout FROM Statement WHERE InvoiceID=" & rstemp!Invoiceid, dbOpenSnapshot)) Then
                StatementDate = rsStatement!cout & ""
                rsStatement.Close
            End If
            Call GrdInvoice.AddItem(rstemp!Invoiceid & vbTab & rstemp!InvoiceNumber & vbTab & FormatCurrency(rstemp!Goodstotal + rstemp!Vattotal + rstemp!Handlingtotal) & vbTab & FormatCurrency(rstemp!Amountpaid) & vbTab & AutoCase(rstemp!CompanyName & "", True) & vbTab & Format(rstemp!Duedate, "dd/mm/yyyy") & vbTab & rstemp!Customerid & vbTab & StatementCount & vbTab & Format(rstemp!Paymentdate, "dd/mm/yyyy") & vbTab & StatementDate)
            If (rstemp!Duedate < Now) Then
                GrdInvoice.Col = -1
                If (rstemp!Amountpaid = rstemp!Goodstotal + rstemp!Vattotal + rstemp!Handlingtotal) Then
                    GrdInvoice.ListApplyTo = ListApplyToIndividual
                    GrdInvoice.row = GrdInvoice.ListCount - 1
                    GrdInvoice.BackColor = &HFF00&
                Else
                    GrdInvoice.ListApplyTo = ListApplyToIndividual
                    GrdInvoice.row = GrdInvoice.ListCount - 1
                    GrdInvoice.BackColor = &HFF&
                End If
            Else
                GrdInvoice.ListApplyTo = ListApplyToIndividual
                GrdInvoice.row = GrdInvoice.ListCount - 1
                GrdInvoice.BackColor = &HFFFFFF
            End If
            Call rstemp.MoveNext
        Loop
    End If
End Sub

Private Sub CMDEnterPayment_Click()
    GrdInvoice.Col = 0
    If (vPaymentForm.Search(GrdInvoice.ColText)) Then
        Me.Enabled = False
    Else
    End If
End Sub

''
Private Sub CMDExit_Click()
'    Call vParent.SendChildInactive
    vIsLoaded = False
    Call Me.Hide
    Call AllFormsHide(Me)
End Sub

''
Private Sub CMDPrintStatement_Click()
    GrdInvoice.Col = 6 ' customer id
    Call PrintStatement(GrdInvoice.ColText)
'    Call FRMSPrinterForm.Initialize
    
    Call CBOSearchType_Click
End Sub

Private Sub CMDRePrintInvoice_Click()

End Sub

''
Private Sub CMDShowInvoice_Click()
    GrdInvoice.Col = 0
    If (vInvoiceForm.Search(GrdInvoice.ColText, dual)) Then
        Me.Enabled = False
    Else
    End If
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    'Me.Caption = "<NAME HERE> [" & vParent.Caption & "]"
    Set vInvoiceForm = New FRMInvoice
    Set vPaymentForm = New FRMPayment
    Call vPaymentForm.SetParent(Me)
    Call vInvoiceForm.SetParent(Me)
    Call CBOSearchType.AddItem("Unpaid Invoices")
    Call CBOSearchType.AddItem("Paid Invoices")
    Call CBOSearchType.AddItem("Overdue Unpaid Invoices")
    Call CBOSearchType.AddItem("All Invoices")
    CBOSearchType.ListIndex = 0
    Call ClearDetails
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub GRDInvoice_Click()
    If (GrdInvoice.SelCount > 0) Then
        CMDShowInvoice.Enabled = True
'        CMDRePrintInvoice.Enabled = True
        CMDPrintStatement.Enabled = True
        CMDEnterPayment.Enabled = True
    End If
End Sub

Private Sub OPTSearchBy_Click(index As Integer)
    Dim i As Long
    For i = 0 To GrdInvoice.Columns - 1
        GrdInvoice.Col = i
        GrdInvoice.ColSortSeq = -1
        GrdInvoice.ColSorted = SortedNone
    Next

    If (index = 0) Then
        GrdInvoice.Col = 1 ' number
    Else
        If (index = 1) Then
            GrdInvoice.Col = 4
        Else
            GrdInvoice.Col = 5
        End If
    End If
    GrdInvoice.ColSortSeq = 0
    GrdInvoice.ColSorted = SortedAscending
    Call GrdInvoice.Refresh
End Sub
