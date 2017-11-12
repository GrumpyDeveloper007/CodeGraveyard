VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TXTBOX.OCX"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FRMReports 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Reports"
   ClientHeight    =   4365
   ClientLeft      =   765
   ClientTop       =   1470
   ClientWidth     =   8895
   HelpContextID   =   4
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   4365
   ScaleWidth      =   8895
   Begin VB.ComboBox CBODirection 
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
      Left            =   3120
      List            =   "FRMReports.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   15
      ToolTipText     =   "Select report type to be printed."
      Top             =   1980
      Width           =   2055
   End
   Begin VB.ComboBox CBOExtension 
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
      ItemData        =   "FRMReports.frx":0004
      Left            =   3120
      List            =   "FRMReports.frx":0006
      Style           =   2  'Dropdown List
      TabIndex        =   8
      ToolTipText     =   "Select report type to be printed."
      Top             =   1560
      Width           =   2055
   End
   Begin VB.CommandButton CMDPrint 
      Caption         =   "Print"
      Height          =   375
      Left            =   0
      TabIndex        =   6
      Top             =   3960
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   7800
      TabIndex        =   5
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
      TabIndex        =   2
      Top             =   3240
      Value           =   -1  'True
      Visible         =   0   'False
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
      TabIndex        =   1
      Top             =   3240
      Visible         =   0   'False
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
      ItemData        =   "FRMReports.frx":0008
      Left            =   1800
      List            =   "FRMReports.frx":000A
      Style           =   2  'Dropdown List
      TabIndex        =   0
      ToolTipText     =   "Select report type to be printed."
      Top             =   0
      Width           =   7095
   End
   Begin ELFDateControl.DateControl TXTDate 
      Height          =   615
      Left            =   6000
      TabIndex        =   3
      Top             =   600
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
   Begin ELFTxtBox.TxtBox1 TXTUnansweredCallsVoice 
      Height          =   285
      Left            =   6000
      TabIndex        =   10
      Top             =   1380
      Visible         =   0   'False
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   503
      BackColor       =   -2147483633
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
   Begin ELFTxtBox.TxtBox1 TXTUnansweredCallsDDI 
      Height          =   285
      Left            =   6000
      TabIndex        =   11
      Top             =   1740
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   503
      BackColor       =   -2147483633
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
   Begin ELFTxtBox.TxtBox1 TXTUnansweredCallsDDIIngaged 
      Height          =   285
      Left            =   6000
      TabIndex        =   13
      Top             =   2100
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   503
      BackColor       =   -2147483633
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
   Begin ELFDateControl.DateControl TXTStartDate 
      Height          =   615
      Left            =   1725
      TabIndex        =   17
      Top             =   2475
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
   Begin ELFDateControl.DateControl TXTEndDate 
      Height          =   615
      Left            =   5280
      TabIndex        =   19
      Top             =   2520
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
   Begin VB.Label LBLEndDate 
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
      Left            =   3960
      TabIndex        =   20
      Top             =   2850
      Width           =   1215
   End
   Begin VB.Label LBLStartDate 
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
      Left            =   405
      TabIndex        =   18
      Top             =   2805
      Width           =   1215
   End
   Begin VB.Label LBLDirection 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Direction"
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
      Left            =   1800
      TabIndex        =   16
      Top             =   2040
      Width           =   1215
   End
   Begin VB.Label LBLUnansweredCallsDDIIngaged 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Unanswered Calls (DDI Engaged)"
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
      Left            =   3000
      TabIndex        =   14
      Top             =   2130
      Width           =   2895
   End
   Begin VB.Label LBLUnansweredCallsDDI 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Unanswered Calls (DDI)"
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
      Left            =   3000
      TabIndex        =   12
      Top             =   1770
      Width           =   2895
   End
   Begin VB.Label LBLUnansweredCallsVoice 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Unanswered Calls (voice Mail)"
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
      Left            =   3000
      TabIndex        =   9
      Top             =   1410
      Visible         =   0   'False
      Width           =   2895
   End
   Begin VB.Label LBLExtension 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Extension"
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
      Left            =   1800
      TabIndex        =   7
      Top             =   1620
      Width           =   1215
   End
   Begin VB.Label LBLDate 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Date"
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
      Left            =   4680
      TabIndex        =   4
      Top             =   930
      Width           =   1215
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
'' Coded By Dale Pitman

Private vIsLoaded As Boolean

Private printerobject As New FRMSPrinterForm

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
    LBLDate.Visible = False
    TXTDate.Visible = False
    LBLExtension.Visible = False
    CBOExtension.Visible = False
    optPrinter.Visible = False
    optScreen.Visible = False
    
    LBLStartDate.Visible = False
    TXTStartDate.Visible = False
    LBLEndDate.Visible = False
    TXTEndDate.Visible = False
    
    
    TXTUnansweredCallsDDI.Visible = False
    LBLUnansweredCallsDDI.Visible = False
    TXTUnansweredCallsDDIIngaged.Visible = False
    LBLUnansweredCallsDDIIngaged.Visible = False
    
    CBODirection.Visible = False
    LBLDirection.Visible = False
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CBOreportname_Click()
    ' Hide all options here
    Call DisableAll
    Select Case CBOreportname.ListIndex
        Case 0 ' Show used options here, (depending on type of report)
            LBLDate.Visible = True
            TXTDate.Visible = True
            TXTUnansweredCallsDDI.Visible = True
            LBLUnansweredCallsDDI.Visible = True
            TXTUnansweredCallsDDIIngaged.Visible = True
            LBLUnansweredCallsDDIIngaged.Visible = True
        Case 1 ' Calls by extension (daily)
            LBLDate.Visible = True
            TXTDate.Visible = True
            LBLExtension.Visible = True
            CBOExtension.Visible = True
            optPrinter.Visible = True
            optScreen.Visible = True
            CBODirection.Visible = True
            LBLDirection.Visible = True
        Case 2 ' Calls by extension (period)
            LBLStartDate.Visible = True
            TXTStartDate.Visible = True
            LBLEndDate.Visible = True
            TXTEndDate.Visible = True
            LBLExtension.Visible = True
            CBOExtension.Visible = True
            optPrinter.Visible = True
            optScreen.Visible = True
            CBODirection.Visible = True
            LBLDirection.Visible = True
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
Private Sub CMDPrint_Click()
    Dim Sql As String
    
    Screen.MousePointer = vbHourglass
    Select Case CBOreportname.ListIndex
        Case 0 ' Show used options here, (depending on type of report)
            Call DailyReport(TXTDate.Text)
        Case 1 ' Calls by extension (daily)
            If (CBODirection.ListIndex = 0) Then
                Sql = " AND Direction=1"
            Else
                If (CBODirection.ListIndex = 1) Then
                    Sql = " AND Direction=2"
                Else
                    Sql = " "
                End If
            End If
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL("SELECT c.calldate AS [Date / Time   ],c.Phonenumber AS [Phone Number],c.Duration AS [Duration] FROM Calls c WHERE ExtensionID=" & CBOExtension.ItemData(CBOExtension.ListIndex) & " AND callDate>=" & cDateChar & Format(TXTDate.Text, "mm/dd/yyyy") & cDateChar & " AND calldate<" & cDateChar & Format(DateAdd("d", 1, TXTDate.Text), "mm/dd/yyyy") & cDateChar & Sql, "Calls By User/Date, " & CBOExtension.Text & "," & TXTDate.Text, "00X", "L T")
            Else
                Call printerobject.PrintSQL("SELECT c.calldate AS [Date / Time  ],c.Phonenumber AS [Phone Number],c.Duration AS [Duration] FROM Calls c WHERE ExtensionID=" & CBOExtension.ItemData(CBOExtension.ListIndex) & " AND callDate>=" & cDateChar & Format(TXTDate.Text, "mm/dd/yyyy") & cDateChar & " AND calldate<" & cDateChar & Format(DateAdd("d", 1, TXTDate.Text), "mm/dd/yyyy") & cDateChar & Sql, "Calls By User/Date, " & CBOExtension.Text & "," & TXTDate.Text, "00X", "L T")
            End If
        Case 2 ' Calls by extension (period)
            If (CBODirection.ListIndex = 0) Then
                Sql = " AND Direction=1"
            Else
                If (CBODirection.ListIndex = 1) Then
                    Sql = " AND Direction=2"
                Else
                    Sql = " "
                End If
            End If
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL("SELECT c.calldate AS [Date / Time   ],c.Phonenumber AS [Phone Number],c.Duration AS [Duration] FROM Calls c WHERE ExtensionID=" & CBOExtension.ItemData(CBOExtension.ListIndex) & " AND callDate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar & " AND calldate<" & cDateChar & Format(DateAdd("d", 1, TXTEndDate.Text), "mm/dd/yyyy") & cDateChar & Sql, "Calls By User/Date, " & CBOExtension.Text & "," & TXTStartDate.Text & "-" & TXTEndDate.Text, "00X", "L T")
            Else
                Call printerobject.PrintSQL("SELECT c.calldate AS [Date / Time  ],c.Phonenumber AS [Phone Number],c.Duration AS [Duration] FROM Calls c WHERE ExtensionID=" & CBOExtension.ItemData(CBOExtension.ListIndex) & " AND callDate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar & " AND calldate<" & cDateChar & Format(DateAdd("d", 1, TXTEndDate.Text), "mm/dd/yyyy") & cDateChar & Sql, "Calls By User/Date, " & CBOExtension.Text & "," & TXTStartDate.Text & "-" & TXTEndDate.Text, "00X", "L T")
            End If
        Case 3
        Case 4
        Case 5
        Case 6
        Case 7
        Case 8
    End Select
    
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub Form_Load()
    Dim i As Long
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call DisableAll
    TXTDate.Text = Format(Now, "dd/mm/yyyy")
    Call CBOreportname.AddItem("Daily Report")
    Call CBOreportname.AddItem("Calls By Extension(Daily)")
    Call CBOreportname.AddItem("Calls By Extension(Period)")
    CBOreportname.ListIndex = 0
    
    TXTStartDate.Text = Format(Now, "dd/mm/yyyy")
    TXTEndDate.Text = Format(DateAdd("d", 7, Now), "dd/mm/yyyy")
    
    Call CBODirection.AddItem("Incoming")
    Call CBODirection.AddItem("Outgoing")
    Call CBODirection.AddItem("Both")
    CBODirection.ListIndex = 0
    
    Call LoadListCBO(CBOExtension, "Extensions", "Name", "UID", False, True)
    
    printerobject.Initialize
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

Private Sub TXTDate_Click()
    Dim rstemp As Recordset
    Dim Sql As String
    Dim UnansweredCount As Long
    
    
    Select Case CBOreportname.ListIndex
        Case 0 ' Show used options here, (depending on type of report)
            Screen.MousePointer = vbHourglass
            UnansweredCount = 0
            Sql = "SELECT count(c.uid) as test FROM calls AS c inner join extensions e on c.extensionid=e.uid Where c.CallDate > #" & Format(DateAdd("d", 0, TXTDate.Text), "mm/dd/yyyy") & "# And c.CallDate < #" & Format(DateAdd("d", 1, TXTDate.Text), "mm/dd/yyyy") & "#  And c.Unanseredcall = -1 and c.answertime>0 "
            If (OpenRecordset(rstemp, Sql, dbOpenSnapshot)) Then
                Call rstemp.MoveLast
                UnansweredCount = Val(rstemp!test & "")
            End If
            TXTUnansweredCallsDDI.Text = UnansweredCount
            
            UnansweredCount = 0
            Sql = "SELECT count(c.uid) as test FROM calls AS c inner join extensions e on c.extensionid=e.uid  Where c.CallDate > #" & Format(DateAdd("d", 0, TXTDate.Text), "mm/dd/yyyy") & "# And c.CallDate < #" & Format(DateAdd("d", 1, TXTDate.Text), "mm/dd/yyyy") & "#  And c.Unanseredcall = -1 and c.answertime=0"
            If (OpenRecordset(rstemp, Sql, dbOpenSnapshot)) Then
                Call rstemp.MoveLast
                UnansweredCount = Val(rstemp!test & "")
            End If
            TXTUnansweredCallsDDIIngaged.Text = UnansweredCount
            Screen.MousePointer = vbDefault
        
        Case 1
        Case 2
        Case 3
        Case 4
        Case 5
        Case 6
        Case 7
        Case 8
    End Select
End Sub
