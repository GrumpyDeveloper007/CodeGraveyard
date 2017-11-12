VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.MDIForm MDIMain 
   BackColor       =   &H8000000C&
   Caption         =   "<Project name is stored in global declarations> <Version Number>"
   ClientHeight    =   6075
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   9270
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
      Height          =   495
      Left            =   0
      ScaleHeight     =   435
      ScaleWidth      =   9210
      TabIndex        =   0
      Top             =   0
      Visible         =   0   'False
      Width           =   9270
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
      Begin VB.Menu MNUInterface 
         Caption         =   "Interface"
      End
      Begin VB.Menu MNUBlank0 
         Caption         =   "-"
      End
      Begin VB.Menu MNUAbout 
         Caption         =   "About"
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
      Begin VB.Menu MNUExtensions 
         Caption         =   "Extensions"
      End
      Begin VB.Menu MNULines 
         Caption         =   "Lines"
         Visible         =   0   'False
      End
      Begin VB.Menu MNUPhoneBook 
         Caption         =   "Phone Book"
         Visible         =   0   'False
      End
      Begin VB.Menu MNUBlank 
         Caption         =   "-"
      End
      Begin VB.Menu MNUOptions 
         Caption         =   "Options"
         Shortcut        =   {F7}
      End
      Begin VB.Menu MNUBlank6 
         Caption         =   "-"
      End
      Begin VB.Menu MNUHide 
         Caption         =   "Hide Screen"
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
'' Main (PhoneSystem) Object
''
'' Coded by Dale Pitman

Private vLastUserID As Long

Private vBuffer As String



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
Public Function ConnectDatabase(pName As String) As Boolean
    Dim SystemPath As String
    Dim KeepChecking As Boolean
    KeepChecking = True
    ConnectDatabase = True
    
    SystemPath = GetSetting(cRegistoryName, "Settings", pName, "****")
    Do While (KeepChecking = True)
        If (Dir(SystemPath) = "" Or SystemPath = "****") Then
            SystemPath = LocateDatabase(pName)
            If (SystemPath = "****") Then
                If (MsgBox("You cannot run this program without the database.  Do you want to look again?", vbQuestion + vbYesNo, "Unable to Continue") = vbNo) Then
                    ConnectDatabase = False
                    KeepChecking = False
                End If
            End If
        Else
            KeepChecking = False
        End If
    Loop
    If (ConnectDatabase = True) Then
'ado
        db.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & SystemPath & ";Persist Security Info=False"
'        db.ConnectionString = "Provider=MS Access;Data Source=" & SystemPath & ";Persist Security Info=False"
        
        db.Mode = adModeReadWrite
        db.Open
    End If
End Function

''
Private Sub MDIForm_Load()
'    Call ReadDataFile
    Dim i As Long
    On Error GoTo loadpictureerror
    PICBackground.Picture = LoadPicture("PhoneSystem.bmp")
loadpictureerror:
    On Error GoTo 0
    
    Call SetWindowPosition(Me)
    Me.Picture = Nothing
    Me.Caption = cProjectName & cVersionNumber
    
    '' Hide all menus here
    '' Connnect to database
    If (ConnectDatabase(cDatabaseName) = True) Then
        Call Startup
'        Call ShowForm(FRMLogin)
        Call FRMOptions.LoadSettings
    Else
        End
    End If
     
    i = 2002
'    If (Now > CDate("06/06/" & i)) Then
'        Call Messagebox("This program has expired. Please Update.", vbCritical)
'        End
'    End If
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    Call Shutdown
End Sub

Private Sub MNUAbout_Click()
    Call ShowForm(FRMAbout)
End Sub

Private Sub MNUExit_Click()
    Call Unload(Me)
End Sub

Private Sub MNUExtensions_Click()
    Call ShowForm(FRMCreateAmendExtensions)
End Sub

Private Sub MNUHide_Click()
    Call Me.Hide
End Sub

Private Sub MNUInterface_Click()
    Call ShowForm(FRMInterface)
End Sub

Private Sub MNULines_Click()
    Call ShowForm(FRMCreateAmendLines)
End Sub

Private Sub MNUOptions_Click()
    Call ShowForm(FRMOptions)
End Sub

Private Sub MNUPhoneBook_Click()
    Call ShowForm(FRMCreateAmendPhoneBook)
End Sub

Private Sub MNUReport_Click()
    Call ShowForm(FRMReports)
End Sub

Private Sub VerticalMenu1_MenuItemClick(MenuNumber As Long, MenuItem As Long)

End Sub

Private Sub VerticalMenu1_Show()

End Sub
