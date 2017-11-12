VERSION 5.00
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
Private Sub CMDPrint_Click()
    Dim Startdate As String
    Dim EndDate As String
    
    Screen.MousePointer = vbHourglass
    
    
    Select Case CBOreportname.ListIndex
        Case 0 '"\OrderType.rpt"
        Case 1 '
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
