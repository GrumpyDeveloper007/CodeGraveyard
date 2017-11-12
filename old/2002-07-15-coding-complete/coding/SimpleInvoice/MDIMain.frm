VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.MDIForm MDIMain 
   BackColor       =   &H8000000C&
   Caption         =   "<Project name is stored in global declarations> <Version Number>"
   ClientHeight    =   6075
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   8910
   HelpContextID   =   13
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
      Begin VB.Menu MNUAbout 
         Caption         =   "About"
      End
      Begin VB.Menu MNUExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu MNUSales 
      Caption         =   "Sales"
      Begin VB.Menu MNUInvoice 
         Caption         =   "Create Invoice / Estimate"
         Shortcut        =   {F2}
      End
      Begin VB.Menu MNUInvoiceEnquiry 
         Caption         =   "Invoice Enquiry"
         Shortcut        =   {F3}
      End
      Begin VB.Menu MNUBlank1 
         Caption         =   "-"
      End
      Begin VB.Menu MNUOverdueReminder 
         Caption         =   "Overdue Invoice Reminder"
      End
      Begin VB.Menu MNUBlank3 
         Caption         =   "-"
      End
      Begin VB.Menu MNUCreateInvoiceOnly 
         Caption         =   "Create Invoice (Only)"
      End
      Begin VB.Menu MNUCreateEstimateOnly 
         Caption         =   "Create Estimate"
      End
      Begin VB.Menu MNUBlank2 
         Caption         =   "-"
      End
      Begin VB.Menu MNUCreditNote 
         Caption         =   "Credit Note"
         Shortcut        =   {F4}
      End
      Begin VB.Menu MNUBlank8 
         Caption         =   "-"
      End
      Begin VB.Menu MNUPDAInterface 
         Caption         =   "PDA Interface"
         Shortcut        =   {F5}
      End
      Begin VB.Menu MNUBlank6 
         Caption         =   "-"
      End
      Begin VB.Menu MNUPayment 
         Caption         =   "Enter Payment"
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
      Begin VB.Menu MNUProductConfig 
         Caption         =   "Manage Products"
      End
      Begin VB.Menu MNUHandlingConfig 
         Caption         =   "Handling Config"
      End
      Begin VB.Menu MNUAccountConfig 
         Caption         =   "Manage Accounts"
      End
      Begin VB.Menu MNUBlank4 
         Caption         =   "-"
      End
      Begin VB.Menu MNUDatabaseView 
         Caption         =   "Database View"
      End
      Begin VB.Menu MNUPrinterSetup 
         Caption         =   "Printer Setup"
      End
      Begin VB.Menu MNUBlank5 
         Caption         =   "-"
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
'                MNUConfig.Visible = True
'                If (rstemp!MNUSystemDetails = True) Then
'                    MNUOptions.Visible = True
'                Else
'                    MNUOptions.Visible = False
'                End If
'                If (rstemp!MNUPrinterSetup = True) Then
'                    MNUPrinterSetup.Visible = True
'                Else
'                    MNUPrinterSetup.Visible = False
'                End If
'                If (rstemp!MNUUserManager = True) Then
'                    MNUUserManager.Visible = True
'                Else
'                    MNUUserManager.Visible = False
'                End If
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
    PICBackground.Picture = LoadPicture(App.Path & "\SInvoice.bmp")
    Me.Picture = LoadPicture(App.Path & "\SInvoiceBack.bmp")
    On Error GoTo 0
PictureContinue:
    Call SetWindowPosition(Me)
'    Me.Picture = Nothing
    Me.Caption = cProjectName & cVersionNumber
    
    '' Hide all menus here
'    MNUReports.Visible = False
'    MNUConfig.Visible = False
'    MNUWindow.Visible = False
    '' Connnect to database
    If (ConnectDatabase("SInvoice.MDB") = True) Then
        Call Startup
'        Call SetLicenceTo("Rawding Electronic Services")
        FRMAbout.vLicencedTo = GetLicenceTo
'        If (FRMAbout.vLicencedTo = "* Unlicensed *") Then
'            Call FRMAbout.Show
'        End If
'        Call ShowForm(FRMLogin)
        Call FRMOptions.LoadSettings
    Else
        End
    End If
    If (GetServerSetting("SERIALNUMBER", False) = GenerateSerialNumber(FRMOptions.GenerateProductKeyFromLocal)) Then
        ' serial valid
        i = i
    Else
'        i = 2002
'        If (Now > CDate("08/08/" & i)) Then
'            Call Messagebox("This program has expired. Please Update.", vbCritical)
'            Me.MNUSales.Visible = False
'            Me.MNUReports.Visible = False
'            Me.MNUHandlingConfig.Visible = False
'            Me.MNUProductConfig.Visible = False
'            Me.MNUPrinterSetup.Visible = False
'        End If
        
'        Dim rstemp As Recordset
'        If (OpenRecordset(rstemp, "SELECT max(uid) as test from invoice", dbOpenSnapshot)) Then
'            If (rstemp.EOF = False) Then
'                If (Val(rstemp!test & "") > 3000) Then
'                    Call Messagebox("This program has expired or serial number is invalid. Please Update.", vbCritical)
'                    Me.MNUSales.Visible = False
'                    Me.MNUReports.Visible = False
'                    Me.MNUHandlingConfig.Visible = False
'                    Me.MNUProductConfig.Visible = False
'                    Me.MNUPrinterSetup.Visible = False
'                End If
'            End If
'        End If
    End If
    
    
    Call FRMOverdueReminder.CheckForStatements
    
    Exit Sub
loadpictureerror:
    If (ErrorCheck("", "MDI Main Load, Picture Load") = False) Then
        End
    Else
        Resume Next
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

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Menu functions

''
Private Sub MNUAccountConfig_Click()
    Call ShowForm(FRMAccountConfig)
End Sub

Private Sub MNUCreateEstimateOnly_Click()
    Call FRMInvoice.Search(0, Estmaite)
End Sub

Private Sub MNUCreateInvoiceOnly_Click()
    Call FRMInvoice.Search(0, Invoice)

End Sub

''
Private Sub MNUCreditNote_Click()
    Call FRMCreditNote.Search(0)
End Sub

Private Sub MNUDatabaseView_Click()
    Call ShowForm(FRMDatabaseView)
End Sub

Private Sub MNUExit_Click()
    Call Unload(Me)
End Sub

Private Sub MNUHandlingConfig_Click()
    Call ShowForm(FrmHandlingSetup)
End Sub

Private Sub MNUInvoice_Click()
    Call FRMInvoice.Search(0, dual)
End Sub

Private Sub MNUInvoiceEnquiry_Click()
    Call ShowForm(FrmInvoiceEnquiry)
End Sub

''
Private Sub MNULogin_Click()
    Call ShowForm(FRMLogin)
End Sub

Private Sub MNUOptions_Click()
    Call ShowForm(FRMOptions)
End Sub

Private Sub MNUOverdueReminder_Click()
    Call ShowForm(FRMOverdueReminder)
End Sub

Private Sub MNUPayment_Click()
    Call ShowForm(FRMPayment)
End Sub

Private Sub MNUPDAInterface_Click()
    Call ShowForm(FRMPDAInterface)
End Sub

Private Sub MNUPrinterSetup_Click()
    Call ShowForm(FRMPrinterSetup)
End Sub

Private Sub MNUProductConfig_Click()
    Call ShowForm(FrmProductConfig)
End Sub

Private Sub MNUReport_Click()
    Call ShowForm(FRMReports)
End Sub

'Private Sub MNUUserManager_Click()
'    Call ShowForm(FRMUserManager)
'End Sub

