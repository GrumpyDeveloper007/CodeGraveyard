VERSION 5.00
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#3.0#0"; "Flp32a30.ocx"
Begin VB.Form FRMuPartCodeSearch 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Name Here>"
   ClientHeight    =   5340
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7740
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   356
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   516
   Begin LpLib.fpList GRDProduct 
      Height          =   4275
      Left            =   0
      TabIndex        =   0
      Top             =   300
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
      Columns         =   3
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
      ColDesigner     =   "FRMuPartCodeSearch.frx":0000
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   6600
      TabIndex        =   2
      Top             =   4920
      Width           =   1095
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   4920
      Width           =   1095
   End
   Begin VB.OptionButton OPTSearchBy 
      Caption         =   "Part Code"
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
      TabIndex        =   4
      Top             =   0
      Width           =   1215
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
      Left            =   2040
      TabIndex        =   3
      Top             =   0
      Width           =   1575
   End
End
Attribute VB_Name = "FRMuPartCodeSearch"
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
Private vPartCode As ClassPartCode

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
    ChildType = PartCodeSearch
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
    If (vPartCode.Search(ByCode) > 0) Then
        If (vPartCode.RecordCount = 1) Then
            ' only one record
'            vProductID = vPartCode.Uid
            Call vParent.SendChildInactive
        Else
            Call AllFormsShow(Me)
            Me.Visible = True
            Call GRDProduct.Clear
            ' populate list
            Do
                Call GRDProduct.AddItem(vPartCode.Uid & vbTab & vPartCode.Code & vbTab & vPartCode.Name)
            Loop While (vPartCode.NextRecord())
            GRDProduct.Selected(0) = True
            Call GRDProduct.SetFocus
        End If
    Else
        ' not found
        Search = False
    End If
    
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures

''
Public Property Let PartCode(pPartCode As ClassPartCode)
    Set vPartCode = pPartCode
End Property
Public Property Get PartCode() As ClassPartCode
    Set PartCode = vPartCode
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
    vPartCode.ClearDetails
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
    Me.Caption = "Part Code Search [" & vParent.Caption & "]"
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
        Call vPartCode.NextRecord(GRDProduct.ListIndex + 1)
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

