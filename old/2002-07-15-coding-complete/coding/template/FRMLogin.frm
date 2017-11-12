VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Begin VB.Form FRMLogin 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Login"
   ClientHeight    =   1185
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   HelpContextID   =   5
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   1185
   ScaleWidth      =   4680
   Begin ELFTxtBox.TxtBox1 TXTUserName 
      Height          =   375
      Left            =   1680
      TabIndex        =   1
      Top             =   120
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   661
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
   Begin ELFTxtBox.TxtBox1 TXTPassword 
      Height          =   375
      Left            =   1680
      TabIndex        =   2
      Top             =   720
      Visible         =   0   'False
      Width           =   1815
      _ExtentX        =   3201
      _ExtentY        =   661
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      PasswordChar    =   "*"
      Text            =   ""
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLPassword 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Password"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   720
      Visible         =   0   'False
      Width           =   1335
   End
   Begin VB.Label LBLz 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "User Name"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "FRMLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Login Object
''
'' Coded by Dale Pitman


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    If (KeyCode = 27) Then
        Call MDIMain.LogOffUser
        Call Unload(Me)
    End If
End Sub

''
Private Sub Form_Load()
    Call CenterScreen(Me)
'    Call SetFormPicture(Me)
End Sub


''
Private Sub TXTPassword_KeyPress(KeyAscii As Integer)
    Dim rstemp As Recordset
    If (KeyAscii = 13) Then
        If (OpenRecordset(rstemp, "SELECT * FROM [USERS] WHERE [name]=" & Chr$(34) & Trim$(TXTUserName.Text) & Chr$(34), dbOpenSnapshot) = True) Then
            If (rstemp.EOF = False) Then
                If (rstemp!Password & "" = Trim$(TXTPassword.Text)) Then
                    Call MDIMain.LogOnUser(rstemp!Uid, TXTUserName.Text)
                    Call Unload(Me)
                End If
            Else
                Call Messagebox("Incorrect password.", vbExclamation)
                Call TXTPassword.SetFocus
            End If
            Call rstemp.Close
        Else
            ' Panic
        End If
        KeyAscii = 0
    End If
End Sub

Private Sub TXTUserName_GotFocus()
    Call CenterScreen(Me)
End Sub

''
Private Sub TXTUserName_KeyPress(KeyAscii As Integer)
    Dim rstemp As Recordset
    If (KeyAscii = 13) Then
        If (OpenRecordset(rstemp, "SELECT * FROM [USERS] WHERE [name]=" & Chr$(34) & Trim$(TXTUserName.Text) & Chr$(34), dbOpenSnapshot) = True) Then
            If (rstemp.EOF = False) Then
                If (Len(rstemp!Password & "") > 0) Then
                    LBLPassword.Visible = True
                    TXTPassword.Visible = True
                    Call TXTPassword.SetFocus
                Else
                    Call MDIMain.LogOnUser(rstemp!Uid, TXTUserName.Text)
                    Call Unload(Me)
                End If
            Else
                Call Messagebox("User not found.", vbExclamation)
                Call TXTUserName.SetFocus
            End If
            Call rstemp.Close
        Else
            ' Panic
        End If
        KeyAscii = 0
    End If
End Sub
