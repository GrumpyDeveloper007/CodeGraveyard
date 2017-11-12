VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmClient 
   Caption         =   "Client Form"
   ClientHeight    =   1620
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4350
   LinkTopic       =   "Form1"
   ScaleHeight     =   1620
   ScaleWidth      =   4350
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtFileName 
      Height          =   285
      Left            =   1080
      TabIndex        =   1
      Text            =   "C:\TestFile.exe"
      Top             =   120
      Width           =   3135
   End
   Begin VB.CommandButton btnConnect 
      Caption         =   "Connect"
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
Attribute VB_Name = "frmClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub btnConnect_Click()
On Error Resume Next
WinS.Connect "127.0.0.1", 1001

Open txtFileName.Text For Binary As #1

End Sub

Private Sub Form_Load()
frmServer.Show , Me
lblemail = email
lblurl = URL
End Sub

Private Sub lblemail_Click()
sendemail
End Sub

Private Sub lblurl_Click()
gotoweb
End Sub

Private Sub WinS_DataArrival(ByVal bytesTotal As Long)

Dim StrData() As Byte

WinS.GetData StrData, vbString
Debug.Print StrData

Put #1, , StrData

End Sub

