VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TXTBOX.OCX"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "Flp32x20.ocx"
Begin VB.Form FRMCreateAmendLines 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Create / Amend Lines"
   ClientHeight    =   7125
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6900
   HelpContextID   =   3
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7125
   ScaleWidth      =   6900
   Begin LpLib.fpList GRDLines 
      Height          =   5535
      Left            =   0
      TabIndex        =   4
      Top             =   1080
      Width           =   6855
      _Version        =   131073
      _ExtentX        =   12091
      _ExtentY        =   9763
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
      AutoSearch      =   2
      SearchMethod    =   2
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
      ColDesigner     =   "FRMCreateAmendLines.frx":0000
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
   Begin VB.CommandButton CMDOK 
      Caption         =   "<OK>"
      Height          =   375
      Left            =   0
      TabIndex        =   5
      Top             =   6720
      Width           =   1095
   End
   Begin VB.CommandButton CMDDelete 
      Caption         =   "Delete"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   2880
      TabIndex        =   8
      Top             =   6720
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "Clear"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   4320
      TabIndex        =   7
      Top             =   6720
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   5760
      TabIndex        =   6
      Top             =   6720
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTLineNumber 
      Height          =   285
      Left            =   1920
      TabIndex        =   0
      Top             =   0
      Width           =   615
      _ExtentX        =   1085
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   285
      Left            =   1920
      TabIndex        =   1
      Top             =   360
      Width           =   3855
      _ExtentX        =   6800
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
      AutoSelect      =   -1  'True
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
      Index           =   2
      Left            =   120
      TabIndex        =   3
      Top             =   390
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Line Number"
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
      Left            =   240
      TabIndex        =   2
      Top             =   30
      Width           =   1575
   End
End
Attribute VB_Name = "FRMCreateAmendLines"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Create / Amend Lines Object
''
'' Coded by Dale Pitman

'' Child objects
Private vCurrentActiveChild As Form

Private vIsLoaded As Boolean
Private rstemp As Recordset

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    If (Me.Enabled = True) Then
        Me.ZOrder
    Else
        Call vCurrentActiveChild.SetFormFocus
    End If
End Sub

'' Call back
Public Sub SendChildInactive()
    Me.Enabled = True
    Call SetWindowPosition(Me)
End Sub

''
Private Sub ClearDetails()
    TXTLineNumber.Text = ""
    TXTName.Text = ""
    CMDOK.Caption = "OK"
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects


''
Private Sub CMDClear_Click()
    Call ClearDetails
    Call TXTLineNumber.SetFocus
End Sub

Private Sub CMDDelete_Click()
    If (Val(TXTLineNumber.Text) > 0) Then
        If (Messagebox("Delete line, are you sure ?", vbQuestion + vbYesNo) = vbYes) Then
            Call Execute("DELETE FROM lines WHERE uid=" & Val(TXTLineNumber.Text))
        End If
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call GetWindowPosition(Me)
    Call Unload(Me)
End Sub

''
Private Sub CMDok_Click()
    If (OpenRecordset(rstemp, "SELECT * FROM lines WHERE uid=" & Val(TXTLineNumber.Text), dbOpenDynaset)) Then
        If (rstemp.EOF = False) Then
            'rstemp.Edit
        Else
            rstemp.AddNew
        End If
        rstemp!Uid = Val(TXTLineNumber.Text)
        rstemp!Name = TXTName.Text
        Call rstemp.Update
    End If
    
    Call TXTLineNumber.SetFocus
End Sub

''
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    
    ' Show all lines
    Dim rstemp As Recordset
    If (OpenRecordset(rstemp, "SELECT * FROM lines", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call GRDLines.AddItem(rstemp!Uid & vbTab & rstemp!Name)
                Call rstemp.MoveNext
            Loop
        End If
    End If

    Call ClearDetails
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

Private Sub GRDLines_Click()
    If (GRDLines.ListIndex >= 0) Then
        GRDLines.Col = 0
        TXTLineNumber.Text = GRDLines.ColText
        Call TXTLineNumber_Validate(False)
    End If
End Sub

''
Private Sub TXTLineNumber_Validate(Cancel As Boolean)
    If (Len(Trim$(TXTLineNumber.Text)) > 0) Then
        If (OpenRecordset(rstemp, "SELECT * FROM lines WHERE uid=" & Val(TXTLineNumber.Text), dbOpenSnapshot)) Then
            If (rstemp.EOF = False) Then
                TXTLineNumber.Text = rstemp!Uid
                TXTName.Text = rstemp!Name
                CMDOK.Caption = "Update"
            End If
        End If
    End If
End Sub
