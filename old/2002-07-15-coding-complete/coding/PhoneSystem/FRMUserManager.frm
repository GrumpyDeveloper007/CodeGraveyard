VERSION 5.00
Object = "{DB0F9920-E84B-11D3-B834-009027603F96}#3.0#0"; "TXTBOX.OCX"
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Begin VB.Form FRMUserManager 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "User Manager"
   ClientHeight    =   4710
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9105
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4710
   ScaleWidth      =   9105
   Begin VB.CheckBox CHKPrinterSetup 
      Caption         =   "Printer Setup"
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
      Left            =   6000
      TabIndex        =   13
      Top             =   3120
      Width           =   1575
   End
   Begin VB.CheckBox CHKReport 
      Caption         =   "Reports"
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
      Left            =   4440
      TabIndex        =   12
      Top             =   1200
      Width           =   1095
   End
   Begin VB.CheckBox CHKUserManager 
      Caption         =   "User Manager"
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
      Left            =   6000
      TabIndex        =   11
      Top             =   3660
      Width           =   1575
   End
   Begin VB.CheckBox CHKSystemDetails 
      Caption         =   "System Details"
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
      Left            =   6000
      TabIndex        =   10
      Top             =   1200
      Width           =   1575
   End
   Begin VB.CheckBox CHKConfig 
      Caption         =   "Config"
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
      Left            =   5880
      TabIndex        =   4
      Top             =   840
      Width           =   1095
   End
   Begin VB.CheckBox CHKReports 
      Caption         =   "Reports"
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
      Left            =   4320
      TabIndex        =   3
      Top             =   840
      Width           =   1095
   End
   Begin Threed.SSCommand CMDClear 
      Height          =   375
      Left            =   6480
      TabIndex        =   7
      Top             =   4200
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "&Clear"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDDelete 
      Height          =   375
      Left            =   5040
      TabIndex        =   6
      Top             =   4200
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "&Delete"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   7920
      TabIndex        =   8
      Top             =   4200
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "E&xit"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin ELFTxtBox.TxtBox1 TXTUserName 
      Height          =   285
      Left            =   1920
      TabIndex        =   1
      Top             =   0
      Width           =   1695
      _ExtentX        =   2990
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
      BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
         Type            =   0
         Format          =   ""
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   2057
         SubFormatType   =   0
      EndProperty
      Text            =   ""
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPassword 
      Height          =   285
      Left            =   1920
      TabIndex        =   2
      Top             =   360
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
      BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
         Type            =   0
         Format          =   ""
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   2057
         SubFormatType   =   0
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin Threed.SSCommand CMDCommit 
      Height          =   375
      Left            =   0
      TabIndex        =   5
      Top             =   4200
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "C&ommit"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Password"
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
      Index           =   1
      Left            =   480
      TabIndex        =   9
      Top             =   360
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "User Name"
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
      Left            =   480
      TabIndex        =   0
      Top             =   0
      Width           =   1335
   End
End
Attribute VB_Name = "FRMUserManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' User Manager Object
''
'' Coded by Dale Pitman

''
Private vIsLoaded As Boolean

Private vCurrentUserID As Long

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

''
Private Sub ClearDetails()
    ' Reset all details here
    CHKReports.Value = vbUnchecked          '
    CHKReport.Value = vbUnchecked
    CHKConfig.Value = vbUnchecked           '
    CHKSystemDetails.Value = vbUnchecked
    CHKUserManager.Value = vbUnchecked
    
    CHKReport.Visible = False
    CHKSystemDetails.Visible = False
    CHKUserManager.Visible = False
    
    TXTUserName.Text = ""
    TXTPassword.Text = ""
End Sub


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CHKConfig_Click()
    If (CHKConfig.Value = vbUnchecked) Then
        CHKSystemDetails.Visible = False
        CHKPrinterSetup.Visible = False
        CHKUserManager.Visible = False
        
        CHKSystemDetails.Value = vbUnchecked
        CHKPrinterSetup.Value = vbUnchecked
        CHKUserManager.Value = vbUnchecked
    Else
        CHKSystemDetails.Visible = True
        CHKPrinterSetup.Visible = True
        CHKUserManager.Visible = True
    End If

End Sub

''
Private Sub CHKReports_Click()
    If (CHKReports.Value = vbUnchecked) Then
        CHKReport.Visible = False
        CHKReport.Value = vbUnchecked
    Else
        CHKReport.Visible = True
    End If
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

''
Private Sub CMDCommit_Click()
    ' Save details here
    Dim rstemp As Recordset
    If (OpenRecordset(rstemp, "SELECT * FROM [users] WHERE [uid]=" & vCurrentUserID, dbOpenDynaset) = True) Then
        If (rstemp.EOF = False) Then
            Call rstemp.Edit
        Else
            Call rstemp.AddNew
        End If
            
        rstemp!Name = TXTUserName.Text
        rstemp!Password = TXTPassword.Text
        rstemp!MNUReports = CHKReports.Value
        rstemp!MNUReport = CHKReport.Value
        rstemp!MNUConfig = CHKConfig.Value
        rstemp!MNUSystemDetails = CHKSystemDetails.Value
        rstemp!MNUPrinterSetup = CHKPrinterSetup.Value
        rstemp!MNUUserManager = CHKUserManager.Value
        Call rstemp.Update
        Call rstemp.Close
        Call ClearDetails
        Call TXTUserName.SetFocus
    End If
End Sub

Private Sub CMDDelete_Click()
    If (vCurrentUserID > 0) Then
        If (Messagebox("Delete user, are you sure ?", vbQuestion) = vbYes) Then
            Call Execute("DELETE FROM [Users] WHERE UID=" & vCurrentUserID)
        End If
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call ClearDetails
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub TXTUserName_KeyPress(KeyAscii As Integer)
    Dim rstemp As Recordset
    If (KeyAscii = 13) Then
        ' Load details here
        If (OpenRecordset(rstemp, "SELECT * FROM [users] WHERE [name]='" & TXTUserName.Text & "'", dbOpenDynaset) = True) Then
            If (rstemp.EOF = False) Then
                TXTPassword.Text = rstemp!Password & ""
                vCurrentUserID = rstemp!Uid
                If (rstemp!MNUReports = True) Then
                    CHKReports.Value = vbChecked
                Else
                    CHKReports.Value = vbUnchecked
                End If
                If (rstemp!MNUReport = True) Then
                    CHKReport.Value = vbChecked
                Else
                    CHKReport.Value = vbUnchecked
                End If
                If (rstemp!MNUConfig = True) Then
                    CHKConfig.Value = vbChecked
                Else
                    CHKConfig.Value = vbUnchecked
                End If
                If (rstemp!MNUSystemDetails = True) Then
                    CHKSystemDetails.Value = vbChecked
                Else
                    CHKSystemDetails.Value = vbUnchecked
                End If
                If (rstemp!MNUPrinterSetup = True) Then
                    CHKPrinterSetup.Value = vbChecked
                Else
                    CHKPrinterSetup.Value = vbUnchecked
                End If
                If (rstemp!MNUUserManager = True) Then
                    CHKUserManager.Value = vbChecked
                Else
                    CHKUserManager.Value = vbUnchecked
                End If
            Else
                Call Messagebox("User name not found!", vbInformation)
            End If
            Call rstemp.Close
        End If
        KeyAscii = 0
        Call TXTPassword.SetFocus
    End If
End Sub
