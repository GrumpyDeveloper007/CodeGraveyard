VERSION 5.00
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "FLP32X20.OCX"
Begin VB.Form FrmProductSearch 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Name Here>"
   ClientHeight    =   6150
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5715
   ControlBox      =   0   'False
   HelpContextID   =   29
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   6150
   ScaleWidth      =   5715
   Begin LpLib.fpList GrdProduct 
      Height          =   5115
      Left            =   0
      TabIndex        =   0
      Top             =   240
      Width           =   5655
      _Version        =   131073
      _ExtentX        =   9975
      _ExtentY        =   9022
      _StockProps     =   68
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Text            =   ""
      Columns         =   2
      Sorted          =   0
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
      ColDesigner     =   "FrmProductSearch.frx":0000
      ScrollBarH      =   3
      DataFieldList   =   ""
      ColumnEdit      =   0
      ColumnBound     =   0
      Style           =   0
      MaxDrop         =   0
      ListWidth       =   0
      EditHeight      =   0
      GrayAreaColor   =   0
      ListLeftOffset  =   0
      ComboGap        =   0
      MaxEditLen      =   0
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
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   4560
      TabIndex        =   4
      Top             =   5760
      Width           =   1095
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   0
      TabIndex        =   3
      Top             =   5760
      Width           =   1095
   End
   Begin VB.Label LBLNumberOfRecords 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "<number of records here>"
      Height          =   255
      Left            =   3000
      TabIndex        =   2
      Top             =   5460
      Width           =   2655
   End
   Begin VB.Label LBLTime 
      BackStyle       =   0  'Transparent
      Caption         =   "<Debug only>"
      Height          =   255
      Left            =   1200
      TabIndex        =   1
      Top             =   5880
      Width           =   3375
   End
End
Attribute VB_Name = "FrmProductSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Product Search Class
''
'' Coded by Dale Pitman

'' Search criteria(Input Parameters)

'' Output parameters

''
Private vShiftStatus As Boolean ' True=down
''
Private vProductClass As New ClassProduct

''
Private vParent As Form

Private vIsLoaded As Boolean

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

''
Public Property Get ChildType() As ChildTypesENUM
    ChildType = ProductSearch
End Property

''
Public Sub SetParent(pform As Form)
    Set vParent = pform
End Sub

''
Public Sub SetProductObject(pProductObject As ClassProduct)
    Set vProductClass = pProductObject
End Sub

''
Public Sub ResetForm()
    Call ClearDetails
End Sub

'' Search
Public Function Search(pSearchType As ProductSearchENUM) As Boolean
    Dim i As Long
    Dim StartTime As Date
    Dim EndTime As Date
    
    Screen.MousePointer = vbHourglass
    
    StartTime = Now     ' Speed testing
    If (vProductClass.Search(pSearchType) > 0) Then
    
        ' Debug
        EndTime = Now   ' Speed testing
        If (vProductClass.RecordCount > 1) Then
            LBLTime.Caption = Format(EndTime - StartTime, "ss")  ' Speed testing
        End If
        
        ' If only one Product found then there is no need to show search screen
        If (vProductClass.RecordCount = 1) Then
            Search = True
        Else
            Call Me.Show
            i = 1
            Call GrdProduct.Clear
            
'            If (SystemDetails.MaxProductsOnSearch < vProductClass.RecordCount) Then
'                LBLNumberOfRecords.Caption = cNumberOfRecordsLabel & vProductClass.RecordCount & "(" & SystemDetails.MaxProductsOnSearch & ")"
'            Else
'                LBLNumberOfRecords.Caption = cNumberOfRecordsLabel & vProductClass.RecordCount
'            End If
            Call LBLNumberOfRecords.Refresh
            
            ' show matches
            Do
                GrdProduct.AddItem (vProductClass.Name & vbTab & vProductClass.Description)
            Loop While vProductClass.NextRecord()
        End If
    Else
        ' No records found
        Call vProductClass.CloseSearch
        Search = False
    End If
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local


'' reset class ready to receive search criteria
Private Sub ClearDetails()
    Call GrdProduct.Clear
    vShiftStatus = False
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDAlternate_Click()
    vShiftStatus = True
    Call cmdOK_Click
End Sub

''
Private Sub cmdExit_Click()
    vProductClass.Uid = 0
    Call vProductClass.CloseSearch
    Call vParent.SendChildInactive(True)
    vIsLoaded = False
    Call Me.Hide
    Call AllFormsHide(Me)
End Sub

''
Private Sub cmdOK_Click()

    vIsLoaded = False
    Call Me.Hide
    Call AllFormsHide(Me)
    Call vParent.SendChildInactive(False)
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


''
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Me.Caption = "Product Search [" & vParent.Caption & "]"
    Call ClearDetails
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub GrdProduct_Click()
    If (GrdProduct.ListIndex >= 0) Then
        Call vProductClass.NextRecord(GrdProduct.ListIndex + 1)
    End If
End Sub

'' Double click to escape
Private Sub GrdProducts_DblClick()
    Call cmdOK_Click
End Sub

'' Allows user to use cursor and enter to SELECT a Product
Private Sub GRDProduct_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
        GrdProduct.Col = 0
        Call GrdProduct_Click
        Call cmdOK_Click
        KeyAscii = 0
    End If
End Sub

''
Private Sub GrdProducts_KeyUp(KeyCode As Integer, Shift As Integer)
    If (Shift = 1) Then 'pressed
        vShiftStatus = True
    Else
        vShiftStatus = False
    End If
End Sub


