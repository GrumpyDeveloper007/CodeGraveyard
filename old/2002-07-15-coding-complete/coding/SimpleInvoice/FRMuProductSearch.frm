VERSION 5.00
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#3.0#0"; "Flp32a30.ocx"
Begin VB.Form FRMuProductSearch 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Product Search>"
   ClientHeight    =   5385
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7725
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   5385
   ScaleWidth      =   7725
   Begin LpLib.fpList GRDProduct 
      Height          =   4275
      Left            =   0
      TabIndex        =   0
      Top             =   360
      Width           =   7695
      _Version        =   196608
      _ExtentX        =   13573
      _ExtentY        =   7541
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
      Columns         =   5
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
      AutoSearch      =   0
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
      ColDesigner     =   "FRMuProductSearch.frx":0000
   End
   Begin VB.OptionButton OPTSearchBy 
      Caption         =   "Description"
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
      Left            =   2400
      TabIndex        =   4
      Top             =   60
      Width           =   1575
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
      Index           =   0
      Left            =   720
      TabIndex        =   3
      Top             =   60
      Width           =   1575
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   0
      TabIndex        =   2
      Top             =   4980
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   6600
      TabIndex        =   1
      Top             =   4980
      Width           =   1095
   End
End
Attribute VB_Name = "FRMuProductSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Product Class
''
'' Coded by Dale Pitman

'' Search criteria(Input Parameters)

'' Output/Input parameters
Private vProductID As Long
Private vProductName As String '
Private vProductDescription As String '
Private vNetCost As Currency
Private vVATPercent As Currency

''
Private vShiftStatus As Boolean ' True=down

''
Private vParent As Form                 ' The parent that this form belongs to
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
    ChildType = ProductSearch
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
End Sub

'' A 'Show' type function used to activate/trigger any functionality on a per-operation basis
Public Function Search() As Boolean
    Dim rstemp As Recordset
    
    Screen.MousePointer = vbHourglass

    
    Search = True
    If (OpenRecordset(rstemp, "SELECT * FROM Product WHERE [name] like " & cTextField & vProductName & cWildCard & cTextField, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Call rstemp.MoveNext
            If (rstemp.EOF = True) Then
                ' only one record
                Call rstemp.MoveFirst
                vProductID = rstemp!Uid
                vProductName = rstemp!Name & ""
                vProductDescription = rstemp!Description & ""
                vNetCost = rstemp!NetCost
                vVATPercent = rstemp!VatPercent
                Call vParent.SendChildInactive
            Else
                Call rstemp.MoveFirst
                Call AllFormsShow(Me)
                Me.Visible = True
                Call GRDProduct.Clear
                Call GRDProduct.SetFocus
                ' populate list
                Do While (rstemp.EOF = False)
                    Call GRDProduct.AddItem(rstemp!Uid & vbTab & rstemp!Name & vbTab & rstemp!Description & vbTab & FormatCurrency(rstemp!NetCost) & vbTab & FormatPercent(rstemp!VatPercent))
                    Call rstemp.MoveNext
                Loop
                GRDProduct.Selected(0) = True
            End If
        Else
            ' not found
            Search = False
        End If
        Call rstemp.Close
    Else
        ' error
        Search = False
    End If
    
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures

''
Public Property Get ProductID() As String
    ProductID = vProductID
End Property

''
Public Property Let ProductName(pProductName As String)
    vProductName = Trim$(pProductName)
End Property
Public Property Get ProductName() As String
    ProductName = Trim$(vProductName)
End Property

''
Public Property Let ProductDescription(pProductDescription As String)
    vProductDescription = pProductDescription
End Property
Public Property Get ProductDescription() As String
    ProductDescription = vProductDescription
End Property

''
Public Property Let NetCost(pNetCost As Currency)
    vNetCost = pNetCost
End Property
Public Property Get NetCost() As Currency
    NetCost = vNetCost
End Property

''
Public Property Let VatPercent(pVatPercent As Currency)
    vVATPercent = pVatPercent
End Property
Public Property Get VatPercent() As Currency
    VatPercent = vVATPercent
End Property


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' reset all class details
Private Sub ClearDetails()
    vShiftStatus = False
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDExit_Click()
    Call vParent.SendChildInactive
    vIsLoaded = False
    Call Me.Hide
    Call AllFormsHide(Me)
End Sub

''
Private Sub CMDOK_Click()
    Dim SelectedItem As String
    If (GRDProduct.ListIndex >= 0) Then
        SelectedItem = GRDProduct.List(GRDProduct.ListIndex)
        GRDProduct.Col = 0
        vProductID = GRDProduct.ColText
        GRDProduct.Col = 1
        vProductName = GRDProduct.ColText
        GRDProduct.Col = 2
        vProductDescription = GRDProduct.ColText
        GRDProduct.Col = 3
        vNetCost = GRDProduct.ColText
        GRDProduct.Col = 4
        vVATPercent = GRDProduct.ColText
        vIsLoaded = False
        Call Me.Hide
        Call AllFormsHide(Me)
        Call vParent.SendChildInactive
    End If
End Sub

''
Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    If (Shift = 1) Then 'pressed
        vShiftStatus = True
    Else
        vShiftStatus = False
    End If
End Sub

''
Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)
    If (Shift = 1) Then 'pressed
        vShiftStatus = True
    Else
        vShiftStatus = False
    End If
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Me.Caption = "Product Search [" & vParent.Caption & "]"
    Call ClearDetails
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub GRDProduct_Click()
    If (GRDProduct.ListIndex >= 0) Then
        
    End If
End Sub

''
Private Sub GRDProduct_DblClick()
    Call CMDOK_Click
End Sub

''
Private Sub GRDProduct_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
        Call CMDOK_Click
    End If
End Sub

Private Sub OPTSearchBy_Click(index As Integer)
    Dim i As Long
    For i = 0 To GRDProduct.Columns - 1
        GRDProduct.Col = i
        GRDProduct.ColSortSeq = -1
        GRDProduct.ColSorted = SortedNone
    Next

    If (index = 0) Then
        GRDProduct.Col = 1 ' name
    Else
        GRDProduct.Col = 2
    End If
    GRDProduct.ColSortSeq = 0
    GRDProduct.ColSorted = SortedAscending
    Call GRDProduct.Refresh
End Sub
