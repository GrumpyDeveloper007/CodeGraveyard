VERSION 5.00
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FRMReports 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Reports"
   ClientHeight    =   4365
   ClientLeft      =   765
   ClientTop       =   1470
   ClientWidth     =   8895
   HelpContextID   =   17
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   4365
   ScaleWidth      =   8895
   Begin ELFDateControl.DateControl TXTStartDate 
      Height          =   615
      Left            =   3240
      TabIndex        =   6
      Top             =   840
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
   Begin VB.CommandButton CMDExit 
      Caption         =   "Exit"
      Height          =   375
      Left            =   7800
      TabIndex        =   5
      Top             =   3960
      Width           =   1095
   End
   Begin VB.CommandButton CMDPrint 
      Caption         =   "&Print"
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   3960
      Width           =   1095
   End
   Begin VB.OptionButton optScreen 
      Caption         =   "Screen"
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
      Left            =   1080
      TabIndex        =   3
      Top             =   3240
      Value           =   -1  'True
      Width           =   1095
   End
   Begin VB.OptionButton optPrinter 
      Caption         =   "Printer"
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
      Left            =   2160
      TabIndex        =   2
      Top             =   3240
      Width           =   1095
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
      Top             =   60
      Width           =   8895
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
      Index           =   0
      Left            =   2040
      TabIndex        =   7
      Top             =   1140
      Width           =   1095
   End
   Begin VB.Label LBLReportComments 
      BackStyle       =   0  'Transparent
      Caption         =   "<Reports Comments>"
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
      Left            =   0
      TabIndex        =   1
      Top             =   2760
      Width           =   8895
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
    LBLReportComments.Caption = ""
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CBOreportname_Click()
    ' Hide all options here
    Call DisableAll
    Select Case CBOreportname.ListIndex
        Case 0 ' User Report
        Case 1 ' User Time Report
        Case 2
        Case 3
        Case 4
        Case 5
        Case 6
        Case 7
        Case 8
    End Select
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Function IsEventStart(pEventType As Long, pEventSubType As Long) As Boolean
    Dim rstemp As Recordset
    If (OpenRecordset(rstemp, "SELECT * FROM e_EventAction", dbOpenSnapshot)) Then
        Do While (rstemp.EOF = False)
'            if (rstemp!eventtype=
        
        Loop
    
    End If

End Function

''
Private Sub CMDPrint_Click()
    Dim Starttime As Date
    Dim Endtime As Date
    Dim UserName As String
    Dim EventStart As Boolean
    Dim sql As String
    Dim rstemp As Recordset
    Dim rstemp2 As Recordset
    Dim duration As Long
    
    Screen.MousePointer = vbHourglass
    Call FRMSPrinterForm.Initialize
    
    Select Case CBOreportname.ListIndex
        Case 0 ' User Report
            sql = "SELECT *" 'em.name,ev.eventtime
            sql = sql & " FROM ([Events] ev INNER JOIN E_Employee em ON ev.USERID=em.USERID) INNER JOIN E_EventAction ea ON ev.Eventtype=ea.eventtype AND ev.eventsubtype=ea.eventsubtype"
            sql = sql & " WHERE em.Include=True "
            'AND (ev.Eventtype=" & FRMOptions.StartEventType & " AND ev.EventSubType=" & FRMOptions.StartEventSubType & ") OR (ev.Eventtype=" & FRMOptions.EndEventType & " AND ev.EventSubType=" & FRMOptions.EndEventSubType & ")  "
            sql = sql & " AND ev.eventtime>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar
            sql = sql & " AND ev.eventtime<=" & cDateChar & Format(DateAdd("d", 8, TXTStartDate.Text), "mm/dd/yyyy") & cDateChar
            
            sql = sql & " ORDER BY ev.userid,ev.eventtime"
            
            Call Execute("DROP TABLE [report1]", True)
            Call Execute("CREATE TABLE [report1] (Name TEXT (50),starttime TEXT (20), endtime  TEXT (20),duration LONG )", True)
            Call Execute("DELETE FROM [report1] ", True)
            EventStart = False
            duration = 0
            
            If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
                Do While (rstemp.EOF = False)
                    UserName = rstemp!Name
                    If (rstemp!action = 1) Then
'                    If (rstemp!eventsubtype = FRMOptions.StartEventSubType And rstemp!eventtype = FRMOptions.StartEventType) Then
                        Starttime = rstemp!eventtime
                        If (EventStart = True) Then
                            ' start without end
                            duration = 0
                            Call Execute("INSERT INTO [report1] (name,starttime,endtime,duration) VALUES (" & cTextField & UserName & cTextField & "," & cTextField & Format(Starttime, "dd/mm/yyyy hh:mm") & cTextField & "," & cTextField & "***" & cTextField & "," & duration & ")", False)
                        Else
                        End If
                        EventStart = True
                    End If
                    If (rstemp!action = 2) Then
'                    If (rstemp!eventsubtype = FRMOptions.EndEventSubType And rstemp!eventtype = FRMOptions.EndEventType) Then
                        Endtime = rstemp!eventtime
                        If (EventStart = True) Then
                            duration = DateDiff("s", Starttime, Endtime)
                            Call Execute("INSERT INTO [report1] (name,starttime,endtime,duration) VALUES (" & cTextField & UserName & cTextField & "," & cTextField & Format(Starttime, "dd/mm/yyyy hh:mm") & cTextField & "," & cTextField & Format(Endtime, "dd/mm/yyyy hh:mm") & cTextField & "," & duration & ")", False)
                            
                        Else
                            ' end without start
                            duration = 0
                            Call Execute("INSERT INTO [report1] (name,starttime,endtime,duration) VALUES (" & cTextField & UserName & cTextField & "," & cTextField & "***" & cTextField & "," & cTextField & Format(Endtime, "dd/mm/yyyy hh:mm") & cTextField & "," & duration & ")", False)
                        End If
                        EventStart = False
                    End If
                    Call rstemp.MoveNext
                Loop
            End If
            
            sql = "SELECT Name,starttime AS [Start Time],endtime AS [End Time],Duration  FROM [report1] r"
            If (optScreen.Value = True) Then
                Call FRMSPrinterForm.PreviewSQL(sql, "User Report", "", "0LLT")
            Else
                Call FRMSPrinterForm.PrintSQL(sql, "User Report", "", "0LLT")
            End If
            '551=in
            '550=out
        Case 1 ' User Time Sheet
            Call UserTimeSheet(TXTStartDate.Text)
        Case 2 '
        Case 3 '
        Case 4 '
        Case 5 '
        Case 6 '
        Case 7 '
        Case 8 '
    End Select
    
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub Form_Load()
    Dim rst As Recordset
    Dim i As Long
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call DisableAll
    Call CBOreportname.AddItem("User Report")
    Call CBOreportname.AddItem("User Time Sheet")
    CBOreportname.ListIndex = 0
    
    TXTStartDate.Text = Format(Now, "dd/mm/yyyy")
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub optPrinter_Click()
'    vCrystalReport.Destination = 1
End Sub

''
Private Sub optScreen_Click()
'    vCrystalReport.Destination = 0
End Sub
