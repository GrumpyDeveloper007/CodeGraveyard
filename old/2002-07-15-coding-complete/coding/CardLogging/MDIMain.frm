VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
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
   ScrollBars      =   0   'False
   Begin VB.Timer Timer1 
      Left            =   960
      Top             =   1800
   End
   Begin VB.PictureBox PICBackground 
      Align           =   1  'Align Top
      Height          =   975
      Left            =   0
      ScaleHeight     =   915
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
      Begin VB.Menu MNUAbout 
         Caption         =   "About"
      End
      Begin VB.Menu MNULogin 
         Caption         =   "Login"
      End
      Begin VB.Menu MNUBlank1 
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
      Begin VB.Menu MNUEmployees 
         Caption         =   "Employees"
      End
      Begin VB.Menu MNUEvents 
         Caption         =   "Events"
      End
      Begin VB.Menu MNUDatabaseView 
         Caption         =   "Database View"
      End
      Begin VB.Menu MNUOptions 
         Caption         =   "Options"
         Shortcut        =   {F7}
      End
      Begin VB.Menu MNUBlank4 
         Caption         =   "-"
         Visible         =   0   'False
      End
      Begin VB.Menu MNUPrinterSetup 
         Caption         =   "Printer Setup"
      End
      Begin VB.Menu MNUBlank5 
         Caption         =   "-"
         Visible         =   0   'False
      End
      Begin VB.Menu MNUUserManager 
         Caption         =   "User Manager"
         Visible         =   0   'False
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

''
Public Sub LogOnUser(pUserID As Long, pUserName As String)
    Dim rstemp As Recordset
    Call GlobalLogOnUser(pUserID)
    
    'Show menus here, depending on user access
    MNUReports.Visible = True
    MNUConfig.Visible = True
    MNUWindow.Visible = True

    If (OpenRecordset(rstemp, "SELECT * FROM [USERS] WHERE [name]=" & Chr$(34) & Trim$(pUserName) & Chr$(34), dbOpenSnapshot) = True) Then
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
                MNUConfig.Visible = True
                If (rstemp!MNUOptions = True) Then
                    MNUOptions.Visible = True
                Else
                    MNUOptions.Visible = False
                End If
                If (rstemp!MNUPrinterSetup = True) Then
                    MNUPrinterSetup.Visible = True
                Else
                    MNUPrinterSetup.Visible = False
                End If
                If (rstemp!MNUUserManager = True) Then
                    MNUUserManager.Visible = True
                Else
                    MNUUserManager.Visible = False
                End If
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


''function to locate and save a specified database
Private Function LocateDatabase(DatabaseName As String) As String
    On Error GoTo Dialog_Cancelled
    'setup the common dialog control
    With MDIMain.CommonDialogControl
        .Filter = DatabaseName & "|" & DatabaseName
        .CancelError = True
        .DialogTitle = "Locate " & DatabaseName & " database"
        'Show the open dialog
        .ShowOpen
        'save the returned setting
        SaveSetting cRegistoryName, "Settings", DatabaseName, .filename
        'return the path
        LocateDatabase = .filename
    End With
    Exit Function
Dialog_Cancelled:
    'if there was an error or the user cancelled the function, return "****"
    LocateDatabase = "****"
    Exit Function
End Function

''
Private Sub MDIForm_Load()
    Call SetWindowPosition(Me)
    On Error GoTo loadpictureerror
    PICBackground.Picture = LoadPicture(App.Path & "\" & cProjectName & ".bmp")
loadpictureerror:
    On Error GoTo 0
    Me.Caption = cProjectName & cVersionNumber
'    Set vCrystalReport = CrystalReportControl
    
    '' Hide all menus here
'    MNUReports.Visible = False
'    MNUConfig.Visible = False
'    MNUWindow.Visible = False
    '' Connnect to database
    If (ConnectDatabase("Net2System.mdb") = True) Then
        Call CreateDBStructures
        Call Startup
'        Call SetLicenceTo("PyroDesign")
        FRMAbout.vLicencedTo = GetLicenceTo
'        If (FRMAbout.vLicencedTo = "*Unlicenced*") Then
'            Call FRMAbout.Show
'        End If
'        Call ShowForm(FRMLogin)
        Call FRMOptions.LoadSettings
    Else
        End
    End If
     
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    Call Shutdown
End Sub

Private Sub MNUAbout_Click()
    Call ShowForm(FRMAbout)
End Sub

Private Sub MNUDatabaseView_Click()
    Call ShowForm(FRMDatabaseView)
End Sub

Private Sub MNUEmployees_Click()
    Call ShowForm(FRMConfigEmployee)
End Sub

Private Sub MNUEvents_Click()
    Call ShowForm(FRMConfigEvents)
End Sub

Private Sub MNUExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub MNULogin_Click()
    Call ShowForm(FRMLogin)
End Sub

Private Sub MNUOptions_Click()
    Call ShowForm(FRMOptions)
End Sub

Private Sub MNUPrinterSetup_Click()
    Call ShowForm(FRMPrinterSetup)
End Sub

Private Sub MNUReport_Click()
    Call ShowForm(FRMReports)
End Sub

Private Sub MNUUserManager_Click()
    Call ShowForm(FRMUserManager)
End Sub

