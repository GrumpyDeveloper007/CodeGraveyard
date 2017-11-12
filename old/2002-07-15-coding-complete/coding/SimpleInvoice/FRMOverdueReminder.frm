VERSION 5.00
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#3.0#0"; "Flp32a30.ocx"
Begin VB.Form FRMOverdueReminder 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Overdue Reminder"
   ClientHeight    =   5565
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11010
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   371
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   734
   Begin LpLib.fpList GrdInvoice 
      Height          =   4695
      Left            =   0
      TabIndex        =   1
      Top             =   360
      Width           =   10935
      _Version        =   196608
      _ExtentX        =   19288
      _ExtentY        =   8281
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
      ColDesigner     =   "FRMOverdueReminder.frx":0000
   End
   Begin VB.CommandButton CMDShowInvoice 
      Caption         =   "Show Invoice"
      Height          =   375
      Left            =   1320
      TabIndex        =   4
      Top             =   5160
      Width           =   1215
   End
   Begin VB.CommandButton CMDPrintStatements 
      Caption         =   "Print Statements"
      Height          =   375
      Left            =   2880
      TabIndex        =   2
      Top             =   5160
      Width           =   1335
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   9840
      TabIndex        =   0
      Top             =   5160
      Width           =   1095
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Overdue Invoices"
      Height          =   255
      Index           =   11
      Left            =   0
      TabIndex        =   3
      Top             =   120
      Width           =   1695
   End
End
Attribute VB_Name = "FRMOverdueReminder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' <Sample> Object
''
'' Coded by Dale Pitman - PyroDesign

Private vUid As Long
'' Search criteria(Input Parameters)


'' Output parameters
'Private vPartid As Long ' *This is a sample parameter


''
'Private vShiftStatus As Boolean ' True=down

''
'Private vParent As Form                 ' The parent that this form belongs to
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one
Private vIsLoaded As Boolean

Private vDataChanged As Boolean

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
'Public Sub SetParent(pform As Form)
'    Set vParent = pform
'End Sub

'' Hierarchical function, used to clear all details within any sub-classes
Public Sub ResetForm()
    Call ClearDetails
End Sub

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
    Call UpdateGrid
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
    Dim rstemp As Recordset
    Dim VatPercent As String
    Dim NetCost As String
    Dim SaveIndex As Long
        
    
'    vShiftStatus = False
End Sub

''
Private Sub SetupFieldSizes()
    Dim rstemp As Recordset
    Dim i As Long
'    If (OpenRecordset(rstemp, "Employee", dbOpenTable)) Then
'        TXTName.MaxLength = GetFieldSize(rstemp, "name")
'        TXTShortName.MaxLength = GetFieldSize(rstemp, "shortname")
'    End If
End Sub

Public Sub CheckForStatements()
    Dim rstemp As Recordset
    Dim sql As String
    Dim Show As Boolean
    Dim StatementCount As Long
    Dim StatementDate As Date
    Dim rsStatement As Recordset
    sql = "SELECT S.Uid as SaleID,c.uid as CustomerID,i.paymentdate,i.uid as invoiceid,i.invoicenumber,i.GoodsTotal,i.vattotal,i.handlingtotal,c.companyname,i.duedate,i.Amountpaid FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid "
    sql = sql & "WHERE i.invoicetype=0 AND i.amountpaid<i.goodstotal+i.vattotal+i.handlingtotal AND DueDate<" & cDateChar & Format(Now, "mm/dd/yyyy") & cDateChar
    
    If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            StatementCount = 0
            If (OpenRecordset(rsStatement, "SELECT Count(*) AS cout FROM Statement WHERE InvoiceID=" & rstemp!Invoiceid, dbOpenSnapshot)) Then
                StatementCount = Val(rsStatement!cout)
                rsStatement.Close
            End If
            StatementDate = 0
            If (OpenRecordset(rsStatement, "SELECT MAX(StatementDate) AS cout FROM Statement WHERE InvoiceID=" & rstemp!Invoiceid, dbOpenSnapshot)) Then
                StatementDate = rsStatement!cout & ""
                rsStatement.Close
            End If
            ' records
            Show = False
            If (StatementCount > 0) Then
                If (StatementDate > DateAdd("d", FRMOptions.NextStatement, Now)) Then
                    Show = True
                End If
            Else
                '
                If (rstemp!Duedate > DateAdd("d", FRMOptions.FirstStatement, Now)) Then
                    Show = True
                End If
            End If
            
            If (Show = True) Then
                Call Me.Show
            End If
        End If
    End If


End Sub


Private Sub UpdateGrid()
    Dim rstemp As Recordset
    Dim sql As String
    Dim AddAnd As Boolean
    Dim StatementCount As Long
    Dim StatementDate As String
    Dim rsStatement As Recordset
    Dim Show As Boolean
    
    Call ClearDetails
    sql = "SELECT S.Uid as SaleID,c.uid as CustomerID,i.paymentdate,i.uid as invoiceid,i.invoicenumber,i.GoodsTotal,i.vattotal,i.handlingtotal,c.companyname,i.duedate,i.Amountpaid FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid "
    sql = sql & "WHERE i.invoicetype=0 AND i.amountpaid<i.goodstotal+i.vattotal+i.handlingtotal AND DueDate<" & cDateChar & Format(Now, "mm/dd/yyyy") & cDateChar
    AddAnd = True
    
    Call GrdInvoice.Clear
    If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
        
        Do While (rstemp.EOF = False)
            StatementCount = 0
            If (OpenRecordset(rsStatement, "SELECT Count(*) AS cout FROM Statement WHERE InvoiceID=" & rstemp!Invoiceid, dbOpenSnapshot)) Then
                StatementCount = Val(rsStatement!cout)
                rsStatement.Close
            End If
            StatementDate = 0
            If (OpenRecordset(rsStatement, "SELECT MAX(StatementDate) AS cout FROM Statement WHERE InvoiceID=" & rstemp!Invoiceid, dbOpenSnapshot)) Then
                StatementDate = rsStatement!cout & ""
                rsStatement.Close
            End If
            
            Show = False
            If (StatementCount > 0) Then
                If (StatementDate > DateAdd("d", FRMOptions.NextStatement, Now)) Then
                    Show = True
                End If
            Else
                '
                If (rstemp!Duedate > DateAdd("d", FRMOptions.FirstStatement, Now)) Then
                    Show = True
                End If
            End If
            
            If (Show = True) Then
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
            End If
            Call rstemp.MoveNext
        Loop
    End If
End Sub


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDAddNew_Click()
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

''
Private Sub CMDDelete_Click()
End Sub

''
Private Sub CMDExit_Click()
'    Call vParent.SendChildInactive
    vIsLoaded = False
    Call Unload(Me)
    Call AllFormsHide(Me)
End Sub

Private Function IsInGrid(pID As Long, pCol As Long, pMax As Long) As Boolean
    Dim i As Long
    IsInGrid = False
    GrdInvoice.Col = pCol
    For i = 0 To pMax
        GrdInvoice.row = i
        If (pID = GrdInvoice.ColList) Then
            IsInGrid = True
            Exit For
        End If
    Next
End Function

Private Sub CMDPrintStatements_Click()
    Dim i As Long
    Dim id As Long
    GrdInvoice.Col = 6 ' customer id
    For i = 0 To GrdInvoice.ListCount - 1
        GrdInvoice.row = i
        id = GrdInvoice.ColList
        If (IsInGrid(id, 6, i - 1) = False) Then
            Call PrintStatement(id)
        Else
            i = i
        End If
    Next
    Call UpdateGrid
End Sub

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
'    Me.Caption = "<NAME HERE> [" & vParent.Caption & "]"
    Call SetupFieldSizes
    Call ClearDetails
    Call UpdateGrid
    vDataChanged = False
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
   
End Sub

