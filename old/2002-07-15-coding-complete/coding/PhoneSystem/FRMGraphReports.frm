VERSION 5.00
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DATECONTROL.OCX"
Object = "{65E121D4-0C60-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCHRT20.OCX"
Begin VB.Form FRMGraphReports 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Graph Reports"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   7290
   ScaleWidth      =   11685
   Begin VB.PictureBox Picture1 
      BackColor       =   &H80000005&
      Height          =   4875
      Left            =   0
      ScaleHeight     =   4815
      ScaleWidth      =   11595
      TabIndex        =   16
      Top             =   1920
      Width           =   11655
      Begin MSChart20Lib.MSChart MSChart1 
         Height          =   4035
         Left            =   120
         OleObjectBlob   =   "FRMGraphReports.frx":0000
         TabIndex        =   17
         Top             =   60
         Width           =   9765
      End
   End
   Begin VB.ComboBox CBOExtension 
      Height          =   315
      Left            =   4200
      Style           =   2  'Dropdown List
      TabIndex        =   15
      Top             =   1560
      Width           =   2295
   End
   Begin VB.ComboBox CBOLineNumber 
      Height          =   315
      Left            =   4200
      Style           =   2  'Dropdown List
      TabIndex        =   14
      Top             =   1080
      Width           =   2295
   End
   Begin VB.CheckBox CHKByExtension 
      Caption         =   "By Extension"
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
      Left            =   600
      TabIndex        =   11
      Top             =   1560
      Width           =   1575
   End
   Begin VB.CheckBox CHKByLine 
      Caption         =   "By Line"
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
      Left            =   600
      TabIndex        =   10
      Top             =   1080
      Width           =   1095
   End
   Begin VB.CheckBox CHKByDate 
      Caption         =   "By Date"
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
      Left            =   600
      TabIndex        =   9
      Top             =   600
      Width           =   1095
   End
   Begin ELFDateControl.DateControl TXTStartDate 
      Height          =   615
      Left            =   3360
      TabIndex        =   4
      Top             =   360
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin VB.CheckBox CHKShowNames 
      Caption         =   "Show Names"
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
      Left            =   7320
      TabIndex        =   3
      Top             =   1560
      Width           =   1455
   End
   Begin VB.ComboBox CBOReportType 
      Height          =   315
      Left            =   1800
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   0
      Width           =   6855
   End
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   10560
      TabIndex        =   0
      Top             =   6900
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
   Begin Threed.SSCommand CMDPrint 
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   6900
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "&Print"
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
   Begin ELFDateControl.DateControl TXTEndDate 
      Height          =   615
      Left            =   6600
      TabIndex        =   7
      Top             =   360
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin Threed.SSCommand CMDPreview 
      Height          =   375
      Left            =   1440
      TabIndex        =   18
      Top             =   6900
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "Preview"
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
      Index           =   4
      Left            =   2520
      TabIndex        =   13
      Top             =   1080
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Extension Number"
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
      Index           =   3
      Left            =   2520
      TabIndex        =   12
      Top             =   1560
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "End Date"
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
      Left            =   5520
      TabIndex        =   8
      Top             =   600
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Start Date"
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
      Left            =   1680
      TabIndex        =   6
      Top             =   600
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Report Name"
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
      Left            =   120
      TabIndex        =   5
      Top             =   0
      Width           =   1575
   End
End
Attribute VB_Name = "FRMGraphReports"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Graph Reports Object
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

Private Sub PrintCallsByExtension()
    Dim SQl As String
    Dim rsExtensions As Recordset
    Dim rsCalls As Recordset
    Dim RowCounter As Long
    Dim rsExt As Recordset
    
    MSChart1.ColumnCount = 2
    MSChart1.ShowLegend = True
    SQl = "select * from extension order by UID"
    If (OpenRecordset(rsExtensions, SQl, dbOpenSnapshot)) Then
        If (rsExtensions.EOF = False) Then
            Call rsExtensions.MoveLast
            Call rsExtensions.MoveFirst
        End If
        MSChart1.RowCount = rsExtensions.RecordCount
        Do While (rsExtensions.EOF = False)
            RowCounter = RowCounter + 1
            MSChart1.Row = RowCounter
            
            SQl = "SELECT * FROM calls WHERE [direction]=2 AND extensionid=" & rsExtensions!Uid
            If (CHKByDate.Value = vbChecked) Then
                SQl = SQl & " AND calldate>=#" & Format(TXTStartDate.Text, "mm/dd/yyyy") & "# AND calldate<=#" & Format(TXTEndDate.Text, "mm/dd/yyyy") & "#"
            End If
            If (CHKByLine.Value = vbChecked) Then
                SQl = SQl & " AND lineid=" & CBOLineNumber.ItemData(CBOLineNumber.ListIndex)
            End If
            If (CHKByExtension.Value = vbChecked) Then
                SQl = SQl & " AND extensionid=" & CBOExtension.ItemData(CBOExtension.ListIndex)
            End If
            If (OpenRecordset(rsCalls, SQl, dbOpenSnapshot)) Then
            
                MSChart1.Column = 1
                MSChart1.ColumnLabel = "Outgoing"
                If (CHKShowNames.Value = vbChecked) Then
                    MSChart1.RowLabel = rsExtensions!Uid & " (" & rsExtensions!Name & ")"
                Else
                    MSChart1.RowLabel = rsExtensions!Uid
                End If
                
                If (rsCalls.EOF = False) Then
                    Call rsCalls.MoveLast
                    Call rsCalls.MoveFirst
                End If
                MSChart1.Data = rsCalls.RecordCount
            End If
            
            
            SQl = "select * from calls where direction=1 AND extensionid=" & rsExtensions!Uid
            If (OpenRecordset(rsCalls, SQl, dbOpenSnapshot)) Then
                MSChart1.Row = RowCounter
                MSChart1.Column = 2
                MSChart1.ColumnLabel = "Incoming"
                If (CHKShowNames.Value = vbChecked) Then
                    MSChart1.RowLabel = rsExtensions!Uid & " (" & rsExtensions!Name & ")"
                Else
                    MSChart1.RowLabel = rsExtensions!Uid
                End If
                
                If rsCalls.EOF = False Then
                    rsCalls.MoveLast
                    rsCalls.MoveFirst
                End If
                MSChart1.Data = rsCalls.RecordCount
                Call rsExtensions.MoveNext
            End If
        Loop
    End If
End Sub


Public Sub PrintCallsByPhoneNumber()
    Dim SQl As String
    Dim rsExtensions As Recordset
    Dim rsCalls As Recordset
    Dim RowCounter As Long
    Dim rstemp As Recordset
    
    MSChart1.ShowLegend = False
    MSChart1.ColumnCount = 1
'    MSChart1.Column = 1
'    MSChart1.ColumnLabel = "Extension"
    SQl = "select distinct phonenumber from calls order by phonenumber"
    If (OpenRecordset(rsExtensions, SQl, dbOpenSnapshot)) Then
        If (rsExtensions.EOF = False) Then
            Call rsExtensions.MoveLast
            Call rsExtensions.MoveFirst
        End If
        MSChart1.RowCount = rsExtensions.RecordCount
        Do While (rsExtensions.EOF = False)
            RowCounter = RowCounter + 1
            SQl = "select * from calls where phonenumber='" & rsExtensions!PhoneNumber & "'"
            If (CHKByDate.Value = vbChecked) Then
                SQl = SQl & " AND calldate>=#" & Format(TXTStartDate.Text, "mm/dd/yyyy") & "# AND calldate<=#" & Format(TXTEndDate.Text, "mm/dd/yyyy") & "#"
            End If
            If (CHKByLine.Value = vbChecked) Then
                SQl = SQl & " AND lineid=" & CBOLineNumber.ItemData(CBOLineNumber.ListIndex)
            End If
            If (CHKByExtension.Value = vbChecked) Then
                SQl = SQl & " AND extensionid=" & CBOExtension.ItemData(CBOExtension.ListIndex)
            End If
            If (OpenRecordset(rsCalls, SQl, dbOpenSnapshot)) Then
                MSChart1.Row = RowCounter
                If (CHKShowNames.Value = vbChecked) Then
                    If (OpenRecordset(rstemp, "SELECT * FROM numbers WHERE telephonenumber='" & rsExtensions!PhoneNumber & "'", dbOpenSnapshot)) Then
                        If (rstemp.EOF = False) Then
                            MSChart1.RowLabel = rsExtensions!PhoneNumber & " (" & rstemp!Name & ")"
                        Else
                            MSChart1.RowLabel = rsExtensions!PhoneNumber
                        End If
                    End If
                Else
                    MSChart1.RowLabel = rsExtensions!PhoneNumber & ""
                End If
                MSChart1.Column = 1
                If (rsCalls.EOF = False) Then
                    Call rsCalls.MoveLast
                    Call rsCalls.MoveFirst
                End If
                MSChart1.Data = rsCalls.RecordCount
            End If
            Call rsExtensions.MoveNext
        Loop
    End If
End Sub

Public Sub PrintTotalCallByContext(pContextName As String)
    Dim SQl As String
    Dim rsExtensions As Recordset
    Dim rsCalls As Recordset
    Dim RowCounter As Long
    Dim rsExt As Recordset
    
    MSChart1.ColumnCount = 1
    MSChart1.ShowLegend = True
    MSChart1.Column = 1
    MSChart1.ColumnLabel = pContextName
    RowCounter = 0
    SQl = "select * from " & pContextName & " order by UID"
    If (OpenRecordset(rsExtensions, SQl, dbOpenSnapshot)) Then
        If (rsExtensions.EOF = False) Then
            Call rsExtensions.MoveLast
            Call rsExtensions.MoveFirst
        End If
        MSChart1.RowCount = rsExtensions.RecordCount
        Do While (rsExtensions.EOF = False)
            RowCounter = RowCounter + 1
            MSChart1.Row = RowCounter
            
            SQl = "SELECT Count(*) AS tt FROM calls WHERE " & pContextName & "id=" & rsExtensions!Uid
            If (CHKByDate.Value = vbChecked) Then
                SQl = SQl & " AND calldate>=#" & Format(TXTStartDate.Text, "mm/dd/yyyy") & "# AND calldate<=#" & Format(TXTEndDate.Text, "mm/dd/yyyy") & "#"
            End If
            If (CHKByLine.Value = vbChecked) Then
                SQl = SQl & " AND lineid=" & CBOLineNumber.ItemData(CBOLineNumber.ListIndex)
            End If
            If (CHKByExtension.Value = vbChecked) Then
                SQl = SQl & " AND extensionid=" & CBOExtension.ItemData(CBOExtension.ListIndex)
            End If
            If (OpenRecordset(rsCalls, SQl, dbOpenSnapshot)) Then
            
                MSChart1.Column = 1
'                MSChart1.ColumnLabel = ""
                If (CHKShowNames.Value = vbChecked) Then
                    MSChart1.RowLabel = rsExtensions!Uid & " (" & rsExtensions!Name & ")"
                Else
                    MSChart1.RowLabel = rsExtensions!Uid
                End If
                
                MSChart1.Data = rsCalls!tt
            End If
            Call rsExtensions.MoveNext
        Loop
    End If
End Sub

Public Sub PrintTotalCallDurationByContext(pContextName As String)
    Dim SQl As String
    Dim rsExtensions As Recordset
    Dim rsCalls As Recordset
    Dim RowCounter As Long
    Dim rsExt As Recordset
    
    MSChart1.ColumnCount = 1
    MSChart1.ShowLegend = True
    MSChart1.Column = 1
    MSChart1.ColumnLabel = pContextName
    RowCounter = 0
    SQl = "select * from " & pContextName & " order by UID"
    If (OpenRecordset(rsExtensions, SQl, dbOpenSnapshot)) Then
        If (rsExtensions.EOF = False) Then
            Call rsExtensions.MoveLast
            Call rsExtensions.MoveFirst
        End If
        MSChart1.RowCount = rsExtensions.RecordCount
        Do While (rsExtensions.EOF = False)
            RowCounter = RowCounter + 1
            MSChart1.Row = RowCounter
            
            SQl = "SELECT sum(duration) AS tt FROM calls WHERE " & pContextName & "id=" & rsExtensions!Uid
            If (CHKByDate.Value = vbChecked) Then
                SQl = SQl & " AND calldate>=#" & Format(TXTStartDate.Text, "mm/dd/yyyy") & "# AND calldate<=#" & Format(TXTEndDate.Text, "mm/dd/yyyy") & "#"
            End If
            If (CHKByLine.Value = vbChecked) Then
                SQl = SQl & " AND lineid=" & CBOLineNumber.ItemData(CBOLineNumber.ListIndex)
            End If
            If (CHKByExtension.Value = vbChecked) Then
                SQl = SQl & " AND extensionid=" & CBOExtension.ItemData(CBOExtension.ListIndex)
            End If
            If (OpenRecordset(rsCalls, SQl, dbOpenSnapshot)) Then
            
                MSChart1.Column = 1
'                MSChart1.ColumnLabel = ""
                If (CHKShowNames.Value = vbChecked) Then
                    MSChart1.RowLabel = rsExtensions!Uid & " (" & rsExtensions!Name & ")"
                Else
                    MSChart1.RowLabel = rsExtensions!Uid
                End If
                
                MSChart1.Data = Val(rsCalls!tt & "")
            End If
            Call rsExtensions.MoveNext
        Loop
    End If
End Sub

Public Sub PrintCallSpreadAnalysis(vCallDate As String, StartTime As String, EndTime As String)
    Dim SQl As String
    Dim rsCalls As Recordset
    Dim TotalRows As Long
    Dim TempTime As Date
    Dim RowCount As Long
    Dim Counter As Long
    MSChart1.ShowLegend = False
    MSChart1.ColumnCount = 1
    MSChart1.Column = 1
    MSChart1.ColumnLabel = "Extension"
    If Format(StartTime, "hh:mm:ss") >= Format(EndTime, "hh:mm:ss") Then
        MsgBox "Invalid Times Entered"
        Exit Sub
    End If
    TempTime = Format(StartTime, "hh:mm:ss")
    Do
        TotalRows = TotalRows + 1
        TempTime = DateAdd("n", 15, TempTime)
    Loop While Format(TempTime, "hh:mm:ss") < Format(EndTime, "hh:mm:ss")
    MSChart1.RowCount = TotalRows
    TempTime = Format(StartTime, "hh:mm")
    
    For Counter = 1 To TotalRows
        MSChart1.Row = Counter
        MSChart1.RowLabel = Format(TempTime, "hh:mm")
        
        SQl = "select * from calls where calldate=#" & Format(vCallDate, "mm/dd/yyyy") & "# and calltime>=#" & Format(TempTime, "hh:mm") & "# and calltime<#" & Format(DateAdd("n", 15, TempTime), "hh:mm") & "#"
        Set rsCalls = db.OpenRecordset(SQl)
        If rsCalls.EOF = False Then
            rsCalls.MoveLast
            rsCalls.MoveFirst
        End If
        MSChart1.Data = rsCalls.RecordCount
        TempTime = DateAdd("n", 15, TempTime)
    Next Counter
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CBOReportType_Click()
    Call CMDPreview_Click
End Sub

''
Private Sub CHKShowNames_Click()
    Call CBOReportType_Click
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub CMDPreview_Click()
    Select Case CBOReportType.ListIndex
        Case 0
            Call PrintCallsByExtension
        Case 1
            Call PrintCallsByPhoneNumber
        Case 2
            Call PrintTotalCallByContext("Extension")
        Case 3
            Call PrintTotalCallByContext("Line")
        Case 4
            Call PrintTotalCallDurationByContext("Extension")
        Case 5
            Call PrintTotalCallDurationByContext("Line")
    End Select
End Sub

''
Private Sub CMDPrint_Click()
    Call Me.PrintForm
End Sub

''
Private Sub Form_Load()
    Dim rstemp As Recordset
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    

    Call CBOReportType.AddItem("Calls By Extension")
    Call CBOReportType.AddItem("Calls By Phone Number")
    Call CBOReportType.AddItem("Print Total Calls By Extension")
    Call CBOReportType.AddItem("Print Total Calls By Line")
    Call CBOReportType.AddItem("Print Total Call Duration By Extension")
    Call CBOReportType.AddItem("Print Total Call Duration By Line")
    
    TXTStartDate.Text = Format(Now, "dd/mm/yyyy")
    TXTEndDate.Text = Format(Now, "dd/mm/yyyy")
    
    If (OpenRecordset(rstemp, "SELECT * FROM Line", dbOpenSnapshot)) Then
        Do While (rstemp.EOF = False)
            Call CBOLineNumber.AddItem(rstemp!Name)
            CBOLineNumber.ItemData(CBOLineNumber.ListCount - 1) = rstemp!Uid
            Call rstemp.MoveNext
        Loop
    End If
    
    If (OpenRecordset(rstemp, "SELECT * FROM Extension", dbOpenSnapshot)) Then
        Do While (rstemp.EOF = False)
            Call CBOExtension.AddItem(rstemp!Name)
            CBOExtension.ItemData(CBOExtension.ListCount - 1) = rstemp!Uid
            Call rstemp.MoveNext
        Loop
    End If
    
End Sub

Private Sub Form_Resize()
    CMDExit.Top = Me.ScaleHeight - (CMDExit.Height + 45)
    CMDPreview.Top = Me.ScaleHeight - CMDPreview.Height - 45
    CMDPrint.Top = Me.ScaleHeight - CMDPrint.Height - 45
'    CMDCreate.Top = Me.ScaleHeight - CMDCreate.Height - 45
    
    Picture1.Height = Me.ScaleHeight - (CMDExit.Height + 45 + 45 + Picture1.Top)
    Picture1.Width = Me.ScaleWidth - (Picture1.Left + 45)
    MSChart1.Height = Picture1.ScaleHeight
    MSChart1.Width = Picture1.ScaleWidth
    
    CMDExit.Left = Me.ScaleWidth - CMDExit.Width - 45
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub
