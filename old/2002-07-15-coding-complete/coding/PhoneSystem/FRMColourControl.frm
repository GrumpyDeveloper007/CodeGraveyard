VERSION 5.00
Object = "{DB0F9920-E84B-11D3-B834-009027603F96}#3.0#0"; "TXTBOX.OCX"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "FLP32X20.OCX"
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Begin VB.Form FRMColourControl 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Colour Control"
   ClientHeight    =   6225
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8730
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   6225
   ScaleWidth      =   8730
   Begin LpLib.fpList GRDDirectionColours 
      Height          =   1545
      Left            =   5400
      TabIndex        =   7
      Top             =   480
      Width           =   1575
      _Version        =   131073
      _ExtentX        =   2778
      _ExtentY        =   2725
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
      ScrollBarV      =   3
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
      ColDesigner     =   "FRMColourControl.frx":0000
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
   Begin LpLib.fpList GRDUsageColours 
      Height          =   4905
      Left            =   2040
      TabIndex        =   2
      Top             =   480
      Width           =   1575
      _Version        =   131073
      _ExtentX        =   2778
      _ExtentY        =   8652
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
      ColDesigner     =   "FRMColourControl.frx":02C9
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
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   7560
      TabIndex        =   0
      Top             =   5760
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "E&xit"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDSave 
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   5820
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "Save"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin ELFTxtBox.TxtBox1 TXTUsageMax 
      Height          =   285
      Left            =   2040
      TabIndex        =   4
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
      BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
         Type            =   0
         Format          =   ""
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   2057
         SubFormatType   =   0
      EndProperty
      Text            =   ""
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Direction Colours"
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
      Left            =   3720
      TabIndex        =   6
      Top             =   480
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Usage Max"
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
      Left            =   360
      TabIndex        =   5
      Top             =   0
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Usage Colours"
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
      Left            =   360
      TabIndex        =   3
      Top             =   480
      Width           =   1575
   End
End
Attribute VB_Name = "FRMColourControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Reports Designer Object
''
''

Private vIsLoaded As Boolean

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects


Private Sub CMDCreate_Click()
    MDIMain.CommonDialogControl.ShowColor
End Sub

Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub CMDSave_Click()
    Dim rstemp As Recordset
    Dim i As Long
    
    Call Execute("DELETE FROM [colours] WHERE [Group]=1", True)
    For i = 0 To GRDUsageColours.ListCount - 1
        GRDUsageColours.Col = 1
        GRDUsageColours.ListApplyTo = ListApplyToIndividual
        GRDUsageColours.Row = i
        Call Execute("INSERT INTO [colours] (value,colour) VALUES (" & GRDUsageColours.ColList & "," & GRDUsageColours.BackColor & ")")
    Next
    
    For i = 0 To GRDDirectionColours.ListCount - 1
        GRDDirectionColours.Row = i
        GRDDirectionColours.Col = 0
        GRDDirectionColours.ListApplyTo = ListApplyToIndividual
        If (OpenRecordset(rstemp, "SELECT * FROM [colours] WHERE [Group]=2 and [value]=" & GRDDirectionColours.ColList, dbOpenDynaset)) Then
            If (rstemp.EOF = False) Then
                Call rstemp.Edit
            Else
                Call rstemp.AddNew
            End If
            GRDDirectionColours.Col = 1
            rstemp!Value = i
            rstemp!colour = GRDDirectionColours.BackColor
            rstemp!Group = 2
            Call rstemp.Update
        End If
    Next
End Sub

Private Sub Form_Load()
    Dim rstemp As Recordset
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    
    TXTUsageMax.Text = 0
    If (OpenRecordset(rstemp, "SELECT * FROM [colours] WHERE [Group]=1", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Call GRDUsageColours.Clear
            Do While (rstemp.EOF = False)
                Call GRDUsageColours.AddItem(rstemp!Uid & vbTab & rstemp!Value)
                TXTUsageMax.Text = Val(TXTUsageMax.Text) + 1
                GRDUsageColours.ListApplyTo = ListApplyToIndividual
                GRDUsageColours.Col = 1
                GRDUsageColours.Row = GRDUsageColours.ListCount - 1
                GRDUsageColours.BackColor = Val(rstemp!colour & "")
                Call rstemp.MoveNext
            Loop
        End If
    End If
    
    Call GRDDirectionColours.Clear
    Call GRDDirectionColours.AddItem("1" & vbTab & "Incoming")
    Call GRDDirectionColours.AddItem("2" & vbTab & "Outgoing")
    Call GRDDirectionColours.AddItem("3" & vbTab & "Both")
    If (OpenRecordset(rstemp, "SELECT * FROM [colours] WHERE [Group]=2", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                GRDDirectionColours.Row = IsInGrid(GRDDirectionColours, rstemp!Value, 0)
                
                GRDDirectionColours.Text = rstemp!Uid & vbTab & rstemp!Value
                GRDDirectionColours.ListApplyTo = ListApplyToIndividual
                GRDDirectionColours.Col = 1
                GRDDirectionColours.BackColor = Val(rstemp!colour & "")
                Call rstemp.MoveNext
            Loop
        End If
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

Private Sub GRDDirectionColours_Click()
    If (GRDDirectionColours.ListIndex >= 0) Then
        On Error GoTo error
        MDIMain.CommonDialogControl.CancelError = True
        Call MDIMain.CommonDialogControl.ShowColor
        GRDDirectionColours.ListApplyTo = ListApplyToIndividual
        GRDDirectionColours.Col = 1
        GRDDirectionColours.Row = GRDDirectionColours.ListIndex
        GRDDirectionColours.BackColor = MDIMain.CommonDialogControl.Color
    End If
error:
End Sub

Private Sub GRDUsageColours_Click()
    If (GRDUsageColours.ListIndex >= 0) Then
        On Error GoTo error
        MDIMain.CommonDialogControl.CancelError = True
        Call MDIMain.CommonDialogControl.ShowColor
        GRDUsageColours.ListApplyTo = ListApplyToIndividual
        GRDUsageColours.Col = 1
        GRDUsageColours.Row = GRDUsageColours.ListIndex
        GRDUsageColours.BackColor = MDIMain.CommonDialogControl.Color
    End If
error:
End Sub

Private Sub TXTUsageMax_KeyPress(KeyAscii As Integer)
    Dim i As Long
    Dim NumtoAdd As Long
    Dim base As Long
    If (KeyAscii = 13) Then
        If (GRDUsageColours.ListCount > Val(TXTUsageMax.Text)) Then
            ' remove stuff
            GRDUsageColours.ListCount = Val(TXTUsageMax.Text)
        Else
            ' add stuff
            NumtoAdd = Val(TXTUsageMax.Text) - GRDUsageColours.ListCount
            base = GRDUsageColours.ListCount
            For i = 0 To NumtoAdd
                Call GRDUsageColours.AddItem("0" & vbTab & i + base)
            Next
'            GRDUsageColours.ListCount = Val(TXTUsageMax.Text)
        End If
    End If
End Sub
