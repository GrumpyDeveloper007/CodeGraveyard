VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.MDIForm MDIMain 
   BackColor       =   &H8000000C&
   Caption         =   "<Project name is stored in global declarations> <Version Number>"
   ClientHeight    =   6075
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   8910
   HelpContextID   =   11
   Icon            =   "MDIMain.frx":0000
   LinkTopic       =   "MDIForm1"
   NegotiateToolbars=   0   'False
   ScrollBars      =   0   'False
   Begin VB.Timer Timer1 
      Left            =   960
      Top             =   1800
   End
   Begin VB.PictureBox PICBackground 
      Align           =   1  'Align Top
      Height          =   495
      Left            =   0
      ScaleHeight     =   435
      ScaleWidth      =   8850
      TabIndex        =   0
      Top             =   0
      Visible         =   0   'False
      Width           =   8910
   End
   Begin MSComDlg.CommonDialog CommonDialogControl 
      Left            =   360
      Top             =   1740
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Menu MNUFile 
      Caption         =   "File"
      Begin VB.Menu MNUtest 
         Caption         =   "Test"
      End
      Begin VB.Menu MNUTest2 
         Caption         =   "test2"
      End
      Begin VB.Menu MNUtest3 
         Caption         =   "test allocate"
      End
      Begin VB.Menu MNUCall 
         Caption         =   "Call"
         Visible         =   0   'False
      End
      Begin VB.Menu MNUBlank1 
         Caption         =   "-"
      End
      Begin VB.Menu MNUAbout 
         Caption         =   "About"
      End
      Begin VB.Menu MNUBlank2 
         Caption         =   "-"
      End
      Begin VB.Menu MNUExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu MNUReports 
      Caption         =   "&Reports"
      Begin VB.Menu MNUReport 
         Caption         =   "Reports"
         Shortcut        =   {F6}
      End
   End
   Begin VB.Menu MNUConfig 
      Caption         =   "&Config"
      Begin VB.Menu MNUOptions 
         Caption         =   "Options"
         Shortcut        =   {F7}
      End
      Begin VB.Menu MNUEmployeeConfig 
         Caption         =   "Employee Config"
      End
      Begin VB.Menu MNUMakeConfig 
         Caption         =   "Make Config"
      End
      Begin VB.Menu MNUPartCodeConfig 
         Caption         =   "Part Code Config"
      End
      Begin VB.Menu MNUDatabaseView 
         Caption         =   "Database View"
      End
      Begin VB.Menu MNUBlank4 
         Caption         =   "-"
      End
      Begin VB.Menu MNUPrinterSetup 
         Caption         =   "Printer Setup"
      End
   End
   Begin VB.Menu MNUWindow 
      Caption         =   "&Window"
      WindowList      =   -1  'True
   End
End
Attribute VB_Name = "MDIMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Main MDI Object
''
'' Coded by Dale Pitman
' msstdfmt.dll


''
Public Sub LogOnUser(pUserID As Long, pUserName As String)
    Dim rstemp As Recordset
    Call GlobalLogOnUser(pUserID)
    
    'Show menus here, depending on user access
    MNUReports.Visible = True
    MNUConfig.Visible = True
    MNUWindow.Visible = True

    If (OpenRecordset(rstemp, "SELECT * FROM [user] WHERE [name]=" & cTextField & Trim$(pUserName) & cTextField, dbOpenSnapshot) = True) Then
        If (rstemp.EOF = False) Then

            If (rstemp!MNUReports = True) Then
                MNUReports.Visible = True
                If (rstemp!MNUReport = True) Then
                    MNUReport.Visible = True
                Else
                    MNUReport.Visible = False
                End If
            Else
                MNUReports.Visible = False
            End If
            
            If (rstemp!MNUConfig = True) Then
            
            Else
                MNUConfig.Visible = False
            End If
        End If
    End If
End Sub

''
Public Sub LogOffUser()
    Call Unload(Me)
End Sub


''
Private Sub MDIForm_Load()
    Dim i As Long
    On Error GoTo loadpictureerror
    PICBackground.Picture = LoadPicture(App.Path & "\BodyWork.bmp")
loadpictureerror:
    On Error GoTo 0
    
    Call SetWindowPosition(Me)
    Me.Picture = Nothing
    Me.Caption = cProjectName & cVersionNumber
    
    '' Hide all menus here
'    MNUReports.Visible = False
'    MNUConfig.Visible = False
'    MNUWindow.Visible = False
    '' Connnect to database
    If (ConnectDatabase(cDatabaseName) = True) Then
'        Call SetLicenceTo("Brooklands", 1)
        FRMAbout.vLicencedTo = GetLicenceTo
'        If (FRMAbout.vLicencedTo = "* Unlicensed *") Then
'            Call FRMAbout.Show
'        End If
        
        Call Startup
'        Call ShowForm(FRMLogin)
        Call FRMOptions.LoadSettings
    Else
        End
    End If

End Sub

''
Private Sub MDIForm_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    Call Shutdown
End Sub

Private Sub MNUAbout_Click()
    Call ShowForm(FRMAbout)
End Sub

Private Sub MNUCall_Click()
    Call FRMJobDetails.Search
End Sub

Private Sub MNUDatabaseView_Click()
    Call ShowForm(FRMDatabaseView)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Menu functions

''
Private Sub MNUEmployeeConfig_Click()
    Call ShowForm(FRMConfigEmployee)
End Sub

Private Sub MNUExit_Click()
    Call Unload(Me)
End Sub



''
Private Sub MNULogin_Click()
'    Call ShowForm(FRMLogin)
End Sub

Private Sub MNUMakeConfig_Click()
    Call ShowForm(FRMConfigMake)
End Sub

Private Sub MNUOptions_Click()
    Call ShowForm(FRMOptions)
End Sub

Private Sub MNUPartCodeConfig_Click()
    Call ShowForm(FRMConfigPartCodes)
End Sub

Private Sub MNUPrinterSetup_Click()
    Call ShowForm(FRMPrinterSetup)
End Sub


Private Sub MNURegisterOCX_Click()
    Call Shell("regsvr32 txtbox.ocx", vbNormalFocus)
    Call Shell("regsvr32 datecontrol.ocx", vbNormalFocus)
End Sub

Private Sub MNUReport_Click()
    Call ShowForm(FRMReports)
End Sub

Private Sub MNUTest_Click()
    Call ShowForm(FRMProjectWindow)
End Sub

Private Sub MNUTest2_Click()
    Call FRMJobDetails.Search
End Sub

Private Sub MNUtest3_Click()
    FRMAllocateCourtesyCar.Show
End Sub

'Private Sub MNUUserManager_Click()
'    Call ShowForm(FRMUserManager)
'End Sub

Private Sub MNUWindow_Click()

End Sub
