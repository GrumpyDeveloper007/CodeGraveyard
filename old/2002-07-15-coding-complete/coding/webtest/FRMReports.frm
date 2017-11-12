VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Begin VB.Form FRMReports 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Sales Reports"
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
   Begin VB.CommandButton CMDExit 
      Caption         =   "Exit"
      Height          =   375
      Left            =   7800
      TabIndex        =   16
      Top             =   3960
      Width           =   1095
   End
   Begin VB.CommandButton CMDPrint 
      Caption         =   "&Print"
      Height          =   375
      Left            =   0
      TabIndex        =   15
      Top             =   3960
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 txtStartMonth 
      Height          =   285
      Left            =   6840
      TabIndex        =   11
      Top             =   1680
      Width           =   975
      _ExtentX        =   1720
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
      MaxLength       =   6
      Text            =   ""
      NavigationMode  =   0
      Mask            =   "##/##"
   End
   Begin VB.Frame Frame1 
      BorderStyle     =   0  'None
      Caption         =   "Frame1"
      Height          =   255
      Left            =   6120
      TabIndex        =   4
      Top             =   1080
      Width           =   2055
      Begin VB.OptionButton optDetail 
         Caption         =   "Detail"
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
         TabIndex        =   6
         Top             =   0
         Value           =   -1  'True
         Width           =   855
      End
      Begin VB.OptionButton optSummary 
         BackColor       =   &H80000004&
         Caption         =   "Summary"
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
         Left            =   960
         TabIndex        =   5
         Top             =   0
         Width           =   1095
      End
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
      Top             =   0
      Width           =   8895
   End
   Begin ELFTxtBox.TxtBox1 txtEndMonth 
      Height          =   285
      Left            =   6840
      TabIndex        =   12
      Top             =   2160
      Width           =   975
      _ExtentX        =   1720
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
      MaxLength       =   6
      Text            =   ""
      NavigationMode  =   0
      Mask            =   "##/##"
   End
   Begin ELFTxtBox.TxtBox1 TXTMonth 
      Height          =   285
      Left            =   1320
      TabIndex        =   13
      Top             =   1560
      Width           =   975
      _ExtentX        =   1720
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
      MaxLength       =   6
      Text            =   ""
      NavigationMode  =   0
      Mask            =   "##/##"
   End
   Begin VB.Label LBLMonth 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Month"
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
      Left            =   120
      TabIndex        =   14
      Top             =   1560
      Width           =   1095
   End
   Begin VB.Label lblMMYY2 
      BackStyle       =   0  'Transparent
      Caption         =   "MM/YY"
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
      Left            =   7920
      TabIndex        =   10
      Top             =   2160
      Width           =   735
   End
   Begin VB.Label lblMMYY1 
      BackStyle       =   0  'Transparent
      Caption         =   "MM/YY"
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
      Left            =   7920
      TabIndex        =   9
      Top             =   1680
      Width           =   735
   End
   Begin VB.Label lblEndMonth 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "End Month"
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
      Left            =   5640
      TabIndex        =   8
      Top             =   2160
      Width           =   1095
   End
   Begin VB.Label lblStartMonth 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Start Month"
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
      Left            =   5640
      TabIndex        =   7
      Top             =   1680
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
    TXTMonth.Visible = False
    LBLMonth.Visible = False
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CBOreportname_Click()
    ' Hide all options here
    Call DisableAll
    txtStartMonth.Visible = True
    txtEndMonth.Visible = True
    lblStartMonth.Visible = True
    lblEndMonth.Visible = True
    lblMMYY1.Visible = True
    lblMMYY2.Visible = True
    Select Case CBOreportname.ListIndex
        Case 0 ' Show used options here, (depending on type of report)
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

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub cmdPrint_Click()
    Dim Startdate As String
    Dim EndDate As String
    Dim s As String
    Dim rst As Recordset
    Dim rst2 As Recordset
    Dim db2 As Database
    
    Screen.MousePointer = vbHourglass
    
'    Call FileCopy(vDataPath & "ztAfterSales.mdb", vDataPath & "xtAfterSales.mdb")
'    Set db2 = DBEngine.OpenDatabase(vDataPath & "xtAfterSales.mdb", False, False)
    
    Select Case CBOreportname.ListIndex
        Case 0 '"\OrderType.rpt"
            If optSummary = True Then
'                vCrystalReport.ReportFileName = App.Path & "\OrderTypeSummary.rpt"
            Else
'                vCrystalReport.ReportFileName = App.Path & "\OrderType.rpt"
            End If
        Case 1 '
        Case 2 '
        Case 3 '
        Case 4 '
        Case 5 '
        Case 6 '
        Case 7 '
        Case 8 '
    End Select
    
'    vCrystalReport.SelectionFormula = ""
    
'    vCrystalReport.SectionFormat(0) = ""
    
    If optSummary = True Then
'        vCrystalReport.SectionFormat(0) = "DETAIL;F;F;F;X;X;X;X;X;"
    End If
    
' vCrystalReport.SelectionFormula = vCrystalReport.SelectionFormula & "{AutoReorder.NextDate} <= Date(" & Format(EndDate, "yyyy,mm,dd)")
    
'    Call vCrystalReport.PrintReport
'    vCrystalReport.ReportFileName = ""
'    Set db2 = Nothing
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
    Call CBOreportname.AddItem(".Report Name Here.")
    CBOreportname.ListIndex = 0
    
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
