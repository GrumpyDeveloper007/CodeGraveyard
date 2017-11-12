VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmServer 
   Caption         =   "Server Form"
   ClientHeight    =   1665
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4260
   LinkTopic       =   "Form2"
   ScaleHeight     =   1665
   ScaleWidth      =   4260
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtFileName 
      Height          =   285
      Left            =   1080
      TabIndex        =   1
      Text            =   "C:\Windows\System\User32.dll"
      Top             =   120
      Width           =   3135
   End
   Begin VB.CommandButton btnSendFile 
      Caption         =   "Send File"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   855
   End
   Begin MSWinsockLib.Winsock WinS 
      Left            =   120
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   327681
   End
   Begin VB.Label lblinfo1 
      AutoSize        =   -1  'True
      Caption         =   "For more demonstration Visual Basic Projects, please visit:"
      Height          =   195
      Left            =   120
      TabIndex        =   5
      Top             =   600
      Width           =   4080
   End
   Begin VB.Label lblurl 
      AutoSize        =   -1  'True
      Caption         =   "http://www.vb-world.net"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   195
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   1740
   End
   Begin VB.Label lblemail 
      AutoSize        =   -1  'True
      Caption         =   "john@vb-world.net"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   195
      Left            =   120
      TabIndex        =   3
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label lblinfo2 
      AutoSize        =   -1  'True
      Caption         =   "To contact us, please send email to:"
      Height          =   195
      Left            =   120
      TabIndex        =   2
      Top             =   1080
      Width           =   2565
   End
End
Attribute VB_Name = "frmServer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub btnSendFile_Click()
SendFile txtFileName.Text, WinS
End Sub

Private Sub Form_Load()
WinS.LocalPort = 1001
WinS.Listen
lblemail = email
lblurl = URL
End Sub

Private Sub lblemail_Click()
sendemail
End Sub

Private Sub lblurl_Click()
gotoweb
End Sub

Private Sub WinS_ConnectionRequest(ByVal requestID As Long)
If WinS.State <> sckClosed Then WinS.Close
WinS.Accept requestID
End Sub

