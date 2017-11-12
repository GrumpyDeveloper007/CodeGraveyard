VERSION 5.00
Object = "{DB0F9920-E84B-11D3-B834-009027603F96}#3.0#0"; "TXTBOX.OCX"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "FLP32X20.OCX"
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Begin VB.Form FRMConfigGroups 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config Groups"
   ClientHeight    =   5310
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7470
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   5310
   ScaleWidth      =   7470
   Begin LpLib.fpList GRDGroups 
      Height          =   3435
      Left            =   0
      TabIndex        =   1
      Top             =   720
      Width           =   3375
      _Version        =   131073
      _ExtentX        =   5953
      _ExtentY        =   6059
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
      ColDesigner     =   "FRMConfigGroups.frx":0000
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
   Begin VB.ListBox LSTLines 
      Height          =   3435
      Left            =   3840
      Style           =   1  'Checkbox
      TabIndex        =   2
      Top             =   720
      Width           =   3495
   End
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   6360
      TabIndex        =   0
      Top             =   4920
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
   Begin Threed.SSCommand CMDAddGroup 
      Height          =   375
      Left            =   4320
      TabIndex        =   3
      Top             =   240
      Width           =   1695
      _Version        =   65536
      _ExtentX        =   2990
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "<Add Group>"
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
   Begin Threed.SSCommand CMDDelteGroup 
      Height          =   375
      Left            =   1800
      TabIndex        =   4
      Top             =   4200
      Width           =   1575
      _Version        =   65536
      _ExtentX        =   2778
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "Delete Group"
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
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   285
      Left            =   1680
      TabIndex        =   5
      Top             =   360
      Width           =   2175
      _ExtentX        =   3836
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
   Begin Threed.SSCommand CMDCommit 
      Height          =   375
      Left            =   0
      TabIndex        =   7
      Top             =   4920
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "C&ommit"
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
      Index           =   1
      Left            =   0
      TabIndex        =   6
      Top             =   360
      Width           =   1575
   End
End
Attribute VB_Name = "FRMConfigGroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Config Groups Object
''
''

Private Type GroupLinesTYPE
    GroupID As Long
    LineID As Long
    Deleted As Boolean
    newrecord As Boolean
End Type

Private vIsLoaded As Boolean
Private vDeleteList(100) As Long
Private vMaxDelete As Long

Private vGroupLines(500) As GroupLinesTYPE
Private vMaxGroupLines As Long

Private vCurrentNumber As Long
Private vPragmaticChange As Boolean

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

''
Private Sub DisableAll()
End Sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CMDAddGroup_Click()
    If (vCurrentNumber >= 0) Then
        GRDGroups.Row = IsInGrid(GRDGroups, vCurrentNumber, 0)
        GRDGroups.Col = 0
        Call Execute("UPDATE groups SET [name]=" & Chr$(34) & TXTName.Text & Chr$(34) & " WHERE UID=" & GRDGroups.ColList)
        GRDGroups.Col = 1
        GRDGroups.ColList = TXTName.Text
    Else
        Dim rstemp As Recordset
        If (OpenRecordset(rstemp, "SELECT * FROM groups", dbOpenDynaset)) Then
            Call rstemp.AddNew
            rstemp!Name = TXTName.Text
            vCurrentNumber = rstemp!Uid
            Call rstemp.Update
            Call GRDGroups.AddItem(vCurrentNumber & vbTab & TXTName.Text)
        End If
    End If
    TXTName.Text = ""
    Call GRDGroups.SetFocus
End Sub

''
Private Sub CMDCommit_Click()
    Dim t As Long
    Screen.MousePointer = vbHourglass
    For t = 0 To vMaxGroupLines - 1
        If (vGroupLines(t).Deleted = True) Then
            If (vGroupLines(t).newrecord = True) Then
                ' do nothing
            Else
                ' delete record
                Call Execute("DELETE FROM grouplines WHERE lineid=" & vGroupLines(t).LineID & " AND groupid=" & vGroupLines(t).GroupID)
            End If
        Else
            If (vGroupLines(t).newrecord = True) Then
                ' Create record
                Call Execute("INSERT INTO grouplines (lineid,groupid) VALUES (" & vGroupLines(t).LineID & "," & vGroupLines(t).GroupID & ")")
                vGroupLines(t).newrecord = False
            Else
                ' do nothing
            End If
        End If
    Next
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub CMDDelteGroup_Click()
    If (GRDGroups.ListIndex >= 0) Then
        Call Execute("DELETE FROM groups WHERE UID=" & GRDGroups.ColText)
'        GRDGroups.Col = 0
'        vDeleteList(vMaxDelete) = GRDGroups.ColText
'        vMaxDelete = vMaxDelete + 1
        Call GRDGroups.RemoveItem(GRDGroups.ListIndex)
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub Form_Load()
    Dim rstemp As Recordset
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call DisableAll
    
    vMaxDelete = 0
    vMaxGroupLines = 0
    CMDAddGroup.Caption = "Add Group"
    vCurrentNumber = -1
    
    If (OpenRecordset(rstemp, "SELECT * FROM groups", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call GRDGroups.AddItem(rstemp!Uid & vbTab & rstemp!Name)
                Call rstemp.MoveNext
            Loop
        End If
    End If
    
    ' Load Lines
    If (OpenRecordset(rstemp, "SELECT * FROM Line", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call LSTLines.AddItem(rstemp!Name)
                LSTLines.ItemData(LSTLines.ListCount - 1) = rstemp!Uid
                Call rstemp.MoveNext
            Loop
        End If
    End If
    
    vMaxGroupLines = 0
    If (OpenRecordset(rstemp, "SELECT * FROM grouplines", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                vGroupLines(vMaxGroupLines).Deleted = False
                vGroupLines(vMaxGroupLines).GroupID = rstemp!GroupID
                vGroupLines(vMaxGroupLines).LineID = rstemp!LineID
                vGroupLines(vMaxGroupLines).newrecord = False
                vMaxGroupLines = vMaxGroupLines + 1
                Call rstemp.MoveNext
            Loop
        End If
    End If
    
    
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub GRDGroups_Click()
    Dim rstemp As Recordset
    Dim i As Long
    Dim t As Long
    If (GRDGroups.ListIndex >= 0) Then
        GRDGroups.Col = 0
        vCurrentNumber = GRDGroups.ColText
        GRDGroups.Col = 1
        TXTName.Text = GRDGroups.ColText
        CMDAddGroup.Caption = "Update Group"
        
        ' Load links
        vPragmaticChange = True
        For i = 0 To LSTLines.ListCount - 1
            LSTLines.Selected(i) = False
        Next
        
        For t = 0 To vMaxGroupLines - 1
            If (vGroupLines(t).GroupID = vCurrentNumber) Then
                For i = 0 To LSTLines.ListCount - 1
                    If (LSTLines.ItemData(i) = vGroupLines(t).LineID) Then
                        LSTLines.Selected(i) = True
                    End If
                Next
            End If
        Next
        vPragmaticChange = False
    End If
End Sub

''
Private Sub LSTLines_Click()
    Dim i As Long
    Dim t As Long
    Dim found As Boolean
    
    If (vPragmaticChange = False) Then
        ' Update state
        GRDGroups.Col = 0
        For i = 0 To LSTLines.ListCount - 1
            found = False
            For t = 0 To vMaxGroupLines - 1
                If (LSTLines.ItemData(i) = vGroupLines(t).LineID And GRDGroups.ColText = vGroupLines(t).GroupID) Then
                    found = True
                    Exit For
                End If
            Next
            If (found = False) Then
                If (LSTLines.Selected(i) = True) Then
                    vGroupLines(vMaxGroupLines).GroupID = GRDGroups.ColText
                    vGroupLines(vMaxGroupLines).LineID = LSTLines.ItemData(i)
                    vGroupLines(vMaxGroupLines).Deleted = False
                    vGroupLines(vMaxGroupLines).newrecord = True
                    vMaxGroupLines = vMaxGroupLines + 1
                Else
                End If
            Else
                ' found
                If (LSTLines.Selected(i) = True) Then
                    vGroupLines(t).GroupID = GRDGroups.ColText
                    vGroupLines(t).LineID = LSTLines.ItemData(i)
                    vGroupLines(t).Deleted = False
'                    vGroupLines(t).newrecord = False
                Else
                    vGroupLines(t).Deleted = True
                End If
            End If
        Next
    End If
End Sub
