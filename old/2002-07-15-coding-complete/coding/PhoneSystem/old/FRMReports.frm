VERSION 5.00
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DATECONTROL.OCX"
Begin VB.Form FRMReports 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Reports"
   ClientHeight    =   6960
   ClientLeft      =   765
   ClientTop       =   1470
   ClientWidth     =   11685
   HelpContextID   =   17
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   6960
   ScaleWidth      =   11685
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   10560
      TabIndex        =   7
      Top             =   6540
      Width           =   1095
   End
   Begin VB.CommandButton CMDPreview 
      Caption         =   "Preview"
      Height          =   375
      Left            =   1440
      TabIndex        =   6
      Top             =   6540
      Width           =   1095
   End
   Begin VB.CommandButton CMDPrint 
      Caption         =   "Print"
      Height          =   375
      Left            =   0
      TabIndex        =   5
      Top             =   6540
      Width           =   1095
   End
   Begin ELFDateControl.DateControl TXTCallDate 
      Height          =   615
      Left            =   3960
      TabIndex        =   2
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
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BeginProperty Font 
         Name            =   "Arial Narrow"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5355
      Left            =   0
      ScaleHeight     =   5295
      ScaleWidth      =   11595
      TabIndex        =   1
      Top             =   1080
      Width           =   11655
   End
   Begin VB.ComboBox CBOreportname 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      ItemData        =   "FRMReports.frx":0000
      Left            =   0
      List            =   "FRMReports.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   0
      ToolTipText     =   "Select report type to be printed."
      Top             =   0
      Width           =   8895
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Call Date"
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
      Left            =   2760
      TabIndex        =   3
      Top             =   660
      Width           =   1095
   End
End
Attribute VB_Name = "FRMReports"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Reports Object
''
''

Private vIsLoaded As Boolean

Private vDirection As String
Private vYContext As String
Private vGraphType As String
Private vZGroup As String
Private vStartHour As String
Private vFinishHour As String
Private vBothGraphTypes As String
Private vTotals As String
Private vWeek As String

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
'    LBLReportComments.Caption = ""
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CBOreportname_Click()
    Dim rstemp As Recordset
    
    If (OpenRecordset(rstemp, "SELECT * FROM reportDetails WHERE ReportID=" & CBOreportname.ItemData(CBOreportname.ListIndex), dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Select Case rstemp!Name
                    Case "Direction"
                        vDirection = rstemp!Value
                    Case "YContext"
                        vYContext = rstemp!Value
                    Case "GraphType"
                        vGraphType = rstemp!Value
                    Case "ZGroup"
                        vZGroup = rstemp!Value
                    Case "StartHour"
                        vStartHour = rstemp!Value
                    Case "FinishHour"
                        vFinishHour = rstemp!Value
                    Case "BothGraphTypes"
                        vBothGraphTypes = rstemp!Value
                    Case "Totals"
                        vTotals = rstemp!Value
                    Case "Week"
                        vWeek = rstemp!Value

                    Case Else
                End Select
                Call rstemp.MoveNext
            Loop
            Call CMDPreview_Click
        End If
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub


''
Private Sub CMDPrint_Click()
    Dim Startdate As String
    Dim EndDate As String
    Dim StartY As Long
    Dim Days As Long
    
    Screen.MousePointer = vbHourglass
    
    Dim StartHour As Long
    Dim FinishHour As Long
    Dim ByColourGraph As Boolean
    StartHour = Val(Left$(vStartHour, 2))
    FinishHour = Val(Left$(vFinishHour, 2))
    Printer.Orientation = vbPRORLandscape
'    Call Picture1.Cls
    Printer.ScaleMode = vbMillimeters
    Printer.ScaleHeight = Picture1.Height / 10
    Printer.ScaleWidth = Picture1.Width
    If (vGraphType = "Bar") Then
        ByColourGraph = False
    Else
        ByColourGraph = True
    End If
    If (vWeek = vbChecked) Then
        Days = 7
    Else
        Days = 1
    End If
    If (vBothGraphTypes <> "0") Then
        Call UsageReport(Printer, TXTCallDate.Text, StartHour, FinishHour, StartY, True, vZGroup, vYContext, vGraphType, vDirection, Days)
        StartY = StartY + 5
        Call UsageReport(Printer, TXTCallDate.Text, StartHour, FinishHour, StartY, False, vZGroup, vYContext, vGraphType, vDirection, Days)
    Else
        Call UsageReport(Printer, TXTCallDate.Text, StartHour, FinishHour, 1, ByColourGraph, vZGroup, vYContext, vGraphType, vDirection, Days)
    End If
    If (vTotals <> "0") Then
    Else
        Call UsageReportTotals(Picture1, TXTCallDate.Text, StartHour, FinishHour, 1, ByColourGraph, vZGroup, vYContext, vGraphType, vDirection)
    End If
    Call Printer.EndDoc

'    Set db2 = Nothing
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub Form_Load()
    Dim i As Long
    Dim rstemp As Recordset
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call DisableAll
    
    TXTCallDate.Text = Format(Now, "dd/mm/yyyy")
   
    If (OpenRecordset(rstemp, "SELECT * FROM Reports", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call CBOreportname.AddItem(rstemp!Name)
                CBOreportname.ItemData(CBOreportname.ListCount - 1) = rstemp!Uid
                Call rstemp.MoveNext
            Loop
            CBOreportname.ListIndex = 0
        End If
    End If
End Sub

Private Sub Form_Resize()
    CMDExit.Top = Me.ScaleHeight - (CMDExit.Height + 45)
    CMDPreview.Top = Me.ScaleHeight - CMDPreview.Height - 45
    CMDPrint.Top = Me.ScaleHeight - CMDPrint.Height - 45
    
    Picture1.Height = Me.ScaleHeight - (CMDExit.Height + 45 + 45 + Picture1.Top)
    Picture1.Width = Me.ScaleWidth - (Picture1.Left + 45)
    
    CMDExit.Left = Me.ScaleWidth - CMDExit.Width - 45
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Public Function UsageReportText(pTarget As Object, pDate As Date, pStartHour As Long, pFinishHour As Long, ByRef pstarty As Long, pByColourGraph As Boolean) As Boolean
    Dim rstemp As Recordset
    Dim rsLines As Recordset
    Dim LineName As String
    Dim HoursInDay(60 * 24, 128) As Long
    Dim StartPos As Long
    Dim Units As Long
    Dim i As Long, t As Long
    Dim LineID As Long
    Dim ScaleX As Double
'    Dim StartY As Long
    Dim StartX As Long
    Dim SQl As String
    Dim YContext As String
    Dim TotalHours As Long
    Dim SecondWidth As Long
    Dim BarHeight As Long
    Dim peek As Long
    Dim MarginLeft As Long
    
    Dim a As Double, b As Double, c As Double, d As Double
    
'    Dim ByColourGraph As Boolean
    Dim ByDirection As Boolean
    
    Screen.MousePointer = vbHourglass
    
    If (vZGroup = "Direction") Then
        ByDirection = True
    Else
        ByDirection = False
    End If
    
    YContext = vYContext
    
    TotalHours = pFinishHour - pStartHour
'    StartY = pStartY
    peek = 0
    StartX = 100
    StartX = (pTarget.ScaleWidth / 8)
    pTarget.FontSize = 8
    MarginLeft = (pTarget.ScaleWidth / 64)

    ScaleX = (60 * TotalHours) / (pTarget.ScaleWidth - StartX - (pTarget.ScaleWidth / 32))
    SecondWidth = (pTarget.ScaleWidth - StartX - 20) / (60 * TotalHours)
    
    LineID = 0
    If (OpenRecordset(rsLines, "SELECT * FROM " & YContext, dbOpenSnapshot)) Then
        If (rsLines.EOF = False) Then
            Call PrintText(pTarget, CDbl(MarginLeft), CDbl(pstarty), vGraphType & " Graph Report, using " & vZGroup & " as zvalue for " & Format(pDate, "dddd dd/mm/yyyy"), pTarget.FontSize)
            pstarty = pstarty + 16
            Call PrintText(pTarget, CDbl(MarginLeft), CDbl(pstarty), YContext, pTarget.FontSize)
            For i = 0 To TotalHours
                Call PrintText(pTarget, StartX + i * 60 / ScaleX - 1, CDbl(pstarty), Val(i + pStartHour), pTarget.FontSize)
            Next
            pstarty = pstarty + 13
            Do While (rsLines.EOF = False)
                
                LineName = rsLines!Name
                LineID = LineID + 1
                
                If (YContext = "Groups") Then
                    SQl = "SELECT c.* FROM calls c INNER JOIN grouplines g ON c.lineid=g.lineid WHERE groupID=" & rsLines!Uid & " AND calldate>=#" & Format(pDate, "mm/dd/yyyy") & "# AND calldate<#" & Format(DateAdd("d", 1, pDate), "mm/dd/yyyy") & "# "
                Else
                    SQl = "SELECT * FROM calls WHERE " & YContext & "ID=" & rsLines!Uid & " AND calldate>=#" & Format(pDate, "mm/dd/yyyy") & "# AND calldate<#" & Format(DateAdd("d", 1, pDate), "mm/dd/yyyy") & "# "
                End If
                Select Case vDirection
                    Case 0 ' ALL
                    Case "Incoming" ' incoming
                        SQl = SQl & " AND direction=1"
                    Case "Outgoing" ' Outgoing
                        SQl = SQl & " AND direction=2"
                    Case Else
                End Select
                
                If (OpenRecordset(rstemp, SQl, dbOpenSnapshot)) Then
                    If (rstemp.EOF = False) Then
                        Do While (rstemp.EOF = False)
                            StartPos = Val(Hour(rstemp!CallDate) * 60 + Minute(rstemp!CallDate))
                            Units = rstemp!Duration / 60
                            For i = StartPos To StartPos + Units
                                If (ByDirection = True) Then
                                    If (rstemp!Direction = 1) Then
                                        HoursInDay(i, LineID) = HoursInDay(i, LineID) Or &HFF0000
                                    Else
                                        HoursInDay(i, LineID) = HoursInDay(i, LineID) Or &HFF
                                    End If
                                Else
                                    ' Accumulate
                                    HoursInDay(i, rstemp!LineID) = 1
                                End If
                            Next
                            Call rstemp.MoveNext
                        Loop
                        
                        For i = 0 To 60 * TotalHours
                        Next
                    Else
                        pstarty = pstarty + 10

                    End If
                End If
                
                Call rsLines.MoveNext
            Loop
        End If
    End If
    Screen.MousePointer = vbDefault
End Function



''
Private Sub CMDPreview_Click()
    Dim StartHour As Long
    Dim FinishHour As Long
    Dim ByColourGraph As Boolean
    Dim StartY As Long
    Dim Days As Long
    StartHour = Val(Left$(vStartHour, 2))
    FinishHour = Val(Left$(vFinishHour, 2))
'    Printer.Orientation = vbPRORLandscape
    Call Picture1.Cls
    Picture1.ScaleMode = vbPixels
    If (vGraphType = "Bar") Then
        ByColourGraph = False
    Else
        ByColourGraph = True
    End If
    StartY = 1
    If (vWeek = "") Then
        Days = 1
    Else
        Days = 7
    End If
    If (vBothGraphTypes <> "0") Then
        Call UsageReport(Picture1, TXTCallDate.Text, StartHour, FinishHour, StartY, True, vZGroup, vYContext, vGraphType, vDirection, Days)
        StartY = StartY + 5
        Call UsageReport(Picture1, TXTCallDate.Text, StartHour, FinishHour, StartY, False, vZGroup, vYContext, vGraphType, vDirection, Days)
    Else
        Call UsageReport(Picture1, TXTCallDate.Text, StartHour, FinishHour, StartY, ByColourGraph, vZGroup, vYContext, vGraphType, vDirection, Days)
    End If
    If (vTotals <> "0") Then
    Else
        Call UsageReportTotals(Picture1, TXTCallDate.Text, StartHour, FinishHour, StartY, ByColourGraph, vZGroup, vYContext, vGraphType, vDirection)
    End If
'    Call pTarget.EndDoc
End Sub

Private Sub TXTCallDate_Click()
    Call CMDPreview_Click
End Sub
