VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "Flp32x20.ocx"
Begin VB.Form FrmHandlingSetup 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Handling Setup"
   ClientHeight    =   4590
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9165
   ControlBox      =   0   'False
   HelpContextID   =   29
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4590
   ScaleWidth      =   9165
   Begin LpLib.fpList GRDHandling 
      Height          =   3015
      Left            =   840
      TabIndex        =   9
      Top             =   1140
      Width           =   5655
      _Version        =   131073
      _ExtentX        =   9975
      _ExtentY        =   5318
      _StockProps     =   68
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Text            =   ""
      Columns         =   5
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
      ColDesigner     =   "FrmHandlingSetup.frx":0000
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
   Begin VB.CommandButton CMDAddNew 
      Caption         =   "<Add New>"
      Height          =   375
      Left            =   840
      TabIndex        =   3
      Top             =   4200
      Width           =   1095
   End
   Begin VB.CommandButton CMDDelete 
      Caption         =   "Delete"
      Height          =   375
      Left            =   5160
      TabIndex        =   4
      Top             =   4200
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      Height          =   375
      Left            =   6600
      TabIndex        =   5
      Top             =   4200
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   8040
      TabIndex        =   6
      Top             =   4200
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   285
      Left            =   1560
      TabIndex        =   0
      Top             =   60
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCost 
      Height          =   285
      Left            =   1560
      TabIndex        =   2
      Top             =   780
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTDescription 
      Height          =   285
      Left            =   1560
      TabIndex        =   1
      Top             =   420
      Width           =   2895
      _ExtentX        =   5106
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Height          =   255
      Index           =   1
      Left            =   300
      TabIndex        =   10
      Top             =   450
      Width           =   1155
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Cost"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   945
      TabIndex        =   8
      Top             =   810
      Width           =   510
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Height          =   255
      Index           =   14
      Left            =   780
      TabIndex        =   7
      Top             =   90
      Width           =   675
   End
End
Attribute VB_Name = "FrmHandlingSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Handling Config Object
''
'' Coded by Dale Pitman

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
    Dim SaveIndex As Long
        
    vUid = -1
    CMDAddNew.Caption = "Add New"
    TXTName.Text = ""
    TXTDescription.Text = ""
    TXTCost.Text = ""
    
    If (OpenRecordset(rstemp, "SELECT * FROM Handling ORDER BY [Name]", dbOpenSnapshot)) Then
        SaveIndex = GRDHandling.TopIndex
        Call GRDHandling.Clear
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call GRDHandling.AddItem(rstemp!Uid & vbTab & Trim$(rstemp!Name & "") & vbTab & Trim$(rstemp!Description & "") & vbTab & FormatCurrency(rstemp!cost))
                Call rstemp.MoveNext
            Loop
        End If
        Call rstemp.Close
        GRDHandling.TopIndex = SaveIndex
    End If
'    vShiftStatus = False
End Sub

''
Private Sub SetupFieldSizes()
    Dim rstemp As Recordset
    Dim i As Long
    If (OpenRecordset(rstemp, "Handling", dbOpenTable)) Then
        TXTName.MaxLength = GetFieldSize(rstemp, "name")
        TXTDescription.MaxLength = GetFieldSize(rstemp, "description")
    End If
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDAddNew_Click()
    If (TXTName.Text <> "") Then
        If (vUid > 0) Then
            ' update
            If (Execute("UPDATE Handling Set [name]=" & cTextField & Trim$(TXTName.Text) & cTextField & ",description=" & cTextField & Trim$(TXTDescription.Text) & cTextField & ",cost=" & Val(RemoveNonNumericCharacters(TXTCost.Text)) & " WHERE UID=" & vUid) > 0) Then
                Call ClearDetails
            End If
        Else
            ' add new
            If (Execute("INSERT INTO Handling (Name,description,cost) VALUES (" & cTextField & Trim$(TXTName.Text) & cTextField & "," & cTextField & Trim$(TXTDescription.Text) & cTextField & "," & Val(RemoveNonNumericCharacters(TXTCost.Text)) & ")") > 0) Then
                Call ClearDetails
            End If
        End If
        
        ' Update invoice screen
        Call LoadHandling
    Else
        Call Messagebox("Product must have a name.", vbInformation)
    End If
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

''
Private Sub CMDDelete_Click()
    If (GRDHandling.ListIndex >= 0) Then
        GRDHandling.Col = 0
        If (Execute("DELETE FROM Handling WHERE UID=" & GRDHandling.ColText) > 0) Then
            Call GRDHandling.RemoveItem(GRDHandling.ListIndex)
            
            ' Update invoice screen
            Call LoadHandling
        End If
    End If
End Sub

''
Private Sub CMDExit_Click()
'    Call vParent.SendChildInactive
    vIsLoaded = False
    Call Unload(Me)
    Call AllFormsHide(Me)
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
'    Me.Caption = "<NAME HERE> [" & vParent.Caption & "]"
    Call SetupFieldSizes
    Call ClearDetails
    
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub GRDhandling_Click()
    If (GRDHandling.ListIndex >= 0) Then
        ' Load item
        GRDHandling.Col = 0
        vUid = GRDHandling.ColText
        GRDHandling.Col = 1
        TXTName.Text = GRDHandling.ColText
        GRDHandling.Col = 2
        TXTDescription.Text = GRDHandling.ColText
        GRDHandling.Col = 3
        TXTCost.Text = GRDHandling.ColText
        CMDAddNew.Caption = "Update"
    End If
End Sub

