VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.MDIForm FrmMain 
   BackColor       =   &H8000000C&
   Caption         =   "HP Project"
   ClientHeight    =   8955
   ClientLeft      =   60
   ClientTop       =   630
   ClientWidth     =   11985
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   2  'CenterScreen
   WindowState     =   2  'Maximized
   Begin VB.PictureBox Picture1 
      Align           =   1  'Align Top
      BorderStyle     =   0  'None
      Height          =   375
      Left            =   0
      ScaleHeight     =   375
      ScaleWidth      =   11985
      TabIndex        =   0
      Top             =   0
      Width           =   11985
      Begin VB.CommandButton CMDSelectProgram 
         Caption         =   "Select PRG"
         Height          =   375
         Left            =   2400
         TabIndex        =   6
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton CmdReset 
         Caption         =   "Reset"
         Height          =   375
         Left            =   1200
         TabIndex        =   5
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton CMDOptions 
         Caption         =   "Options"
         Height          =   375
         Left            =   6960
         TabIndex        =   3
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton CmdRun 
         Caption         =   "Run"
         Height          =   375
         Left            =   0
         TabIndex        =   2
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton CMDExit 
         Caption         =   "Exit"
         Height          =   375
         Left            =   8160
         TabIndex        =   1
         Top             =   0
         Width           =   1095
      End
      Begin VB.Label LblProgramName 
         Alignment       =   2  'Center
         Caption         =   "Program Name here"
         Height          =   195
         Left            =   9360
         TabIndex        =   4
         Top             =   60
         Width           =   2535
      End
   End
   Begin MSComDlg.CommonDialog FileAccess 
      Left            =   120
      Top             =   480
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Menu MNUProgram 
      Caption         =   "Program"
      Begin VB.Menu MNURun 
         Caption         =   "Run"
      End
      Begin VB.Menu MNUReset 
         Caption         =   "Reset"
      End
      Begin VB.Menu MNUPause 
         Caption         =   "Pause"
      End
      Begin VB.Menu MNUSelectProgram 
         Caption         =   "Select Program"
      End
      Begin VB.Menu MNUOptions 
         Caption         =   "Options"
      End
      Begin VB.Menu MNUExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu MNUGFXView 
      Caption         =   "GFX View"
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''
''
'' Limitations -
''
'' Program max number of lines set in syntaxClass (currently 10000)
''

''
Private Sub AlignControls()
    Dim I As Long
    I = FrmMain.ScaleWidth - LblProgramName.Width
    LblProgramName.Left = I
    I = I - (CMDExit.Width + 100)
    CMDExit.Left = I
    I = I - (CMDOptions.Width + 100)
    CMDOptions.Left = I
End Sub

''
Public Sub Update()
    If (FrmOptions.ProgramName = "") Then
        LblProgramName.Caption = "<NONE>"
    Else
        LblProgramName.Caption = FrmOptions.ProgramName
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call MNUExit_Click
End Sub

''
Private Sub CMDOptions_Click()
    Call MNUOptions_Click
End Sub

''
Private Sub CmdReset_Click()
    Call MNUReset_Click
End Sub

''
Private Sub CmdRun_Click()
    Call MNURun_Click
End Sub

''
Private Sub CMDSelectProgram_Click()
    Call MNUSelectProgram_Click
End Sub

''
Private Sub MDIForm_Load()
    ProgPath = strings.GetPathFromAppPath()
    Call AlignControls
'    Call UpdateDateTime
    Call FrmOptions.InitOptions
    Call FrmTextView.Show
    Call Update
    ' Load default program
    Call Syntax.SetProgram(FrmOptions.ProgramName)
    Call Interface.LoadInputs(FrmOptions.ProgramOptionName)
    Call Frmtest.Show
    Call Frmtest.Update
End Sub

''
Private Sub MDIForm_Resize()
    Call AlignControls
End Sub

''
Private Sub MDIForm_Unload(Cancel As Integer)
    Call FrmOptions.SaveOptions
End Sub

Private Sub MNUExit_Click()
    Call Unload(Me)
End Sub

Private Sub MNUOptions_Click()
    Call FrmOptions.Show
    Call FrmOptions.ZOrder
End Sub

Private Sub MNUPause_Click()
    Syntax.Finished = True
End Sub

Private Sub MNUReset_Click()
    Call Syntax.ResetProcessor
    Call Frmtest.Update
End Sub

Private Sub MNURun_Click()
    Call Frmtest.Show
    Call Frmtest.ZOrder
    Call Frmtest.DoProgram
End Sub

Private Sub MNUSelectProgram_Click()
    Call FrmProgramSelect.Show
End Sub
