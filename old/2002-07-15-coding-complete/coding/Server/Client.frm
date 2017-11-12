VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form FrmClient 
   Caption         =   "Client"
   ClientHeight    =   2580
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8970
   LinkTopic       =   "Form1"
   ScaleHeight     =   2580
   ScaleWidth      =   8970
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Pic1 
      Height          =   495
      Left            =   2640
      ScaleHeight     =   29
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   37
      TabIndex        =   13
      Top             =   1800
      Visible         =   0   'False
      Width           =   615
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   7440
      TabIndex        =   12
      Top             =   1920
      Width           =   1455
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Wait for next Message"
      Height          =   375
      Left            =   0
      TabIndex        =   11
      Top             =   1920
      Width           =   1815
   End
   Begin VB.Frame FrmState 
      Caption         =   "State"
      Height          =   855
      Left            =   5760
      TabIndex        =   4
      Top             =   600
      Width           =   2895
      Begin VB.Label LBLState 
         Caption         =   "Connection State - XXXXXX"
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   480
         Width           =   2535
      End
      Begin VB.Label LBLAddress 
         Caption         =   "Address - XXXXXXXX"
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   240
         Width           =   2535
      End
   End
   Begin VB.TextBox TxtAlbums 
      Height          =   375
      Left            =   0
      TabIndex        =   3
      Top             =   360
      Width           =   2775
   End
   Begin VB.TextBox TxtSongs 
      Height          =   375
      Left            =   2880
      TabIndex        =   2
      Top             =   360
      Width           =   2775
   End
   Begin VB.TextBox TXTOutput 
      Height          =   285
      Left            =   1680
      TabIndex        =   1
      Top             =   1320
      Width           =   3975
   End
   Begin VB.TextBox TxtSendData 
      Height          =   285
      Left            =   1680
      TabIndex        =   0
      Top             =   960
      Width           =   3975
   End
   Begin MSWinsockLib.Winsock tcpClient 
      Left            =   8520
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      Protocol        =   1
   End
   Begin VB.Label Label5 
      Caption         =   "Center"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   0
      TabIndex        =   10
      Top             =   0
      Width           =   1575
   End
   Begin VB.Label Label4 
      Caption         =   "Employee"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   2880
      TabIndex        =   9
      Top             =   0
      Width           =   1575
   End
   Begin VB.Label Label3 
      Caption         =   "Data to send"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   0
      TabIndex        =   8
      Top             =   960
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "Data received"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   0
      TabIndex        =   7
      Top             =   1320
      Width           =   1575
   End
End
Attribute VB_Name = "FrmClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'' Program - Redundancy Checker
''
'' Searches .frm files for unused localy dimension varibles and comments
''

Option Explicit

Dim db As Database
Dim ClientName As String
Dim MouseCurrentX As Long
Dim MouseCurrentY As Long
Dim currentheader As TCPHeader
Dim oComm1 As Object

Public Function Kill() As Long
    oComm1.setquit
End Function

Private Function GetStateString(StateValue As Long) As String
    Select Case StateValue
        Case 0
            GetStateString = "Closed"
        Case 1
            GetStateString = "Open"
        Case 2
            GetStateString = "Listening"
        Case 3
            GetStateString = "Connection pending"
        Case 4
            GetStateString = "Resolving host"
        Case 5
            GetStateString = "Host resolved"
        Case 6
            GetStateString = "Connecting"
        Case 7
            GetStateString = "Connected"
        Case 8
            GetStateString = "Peer is closing the connection"
        Case 9
            GetStateString = "Error"
    End Select
End Function

Private Sub CmdCancel_Click()
     Call Unload(Me)
End Sub

Private Sub Command1_Click()
    TxtAlbums.Text = ""
    TxtSongs.Text = ""
    TxtSendData.Text = ""
    TXTOutput.Text = ""
    Me.Hide
End Sub

Private Sub Form_Load()
'    Set CurrentForm = Me
'Set oComm1 = CreateObject("daleclasses.comm1")
'    Call oComm1.resetquit
'Set oComm1 = GetObject("project1.exe") ', "daleclasses.comm1")
'    Dim hw As Long, pix As Long
'    Dim pointer As POINTAPI
'    pix = GetCursorPos(pointer)
'    pointer.x = pix
'    pointer.y = pix
     
'    hw = GetDesktopWindow()
 
ClientName = "Darren"
tcpClient.LocalPort = 1002
tcpClient.Bind
LastPacketType = -1
'With udpPeerB ' IMPORTANT: be sure to change the RemoteHost
' value to the name of your computer.
tcpClient.RemoteHost = "Dark Elf"
tcpClient.RemotePort = 1002   ' Port to connect to.
'tcpClient.Bind 1001                ' Bind to the local port.
'Call tcpClient.SendData("dale")
LBLAddress.Caption = "Address - " & tcpClient.LocalIP & " - " & tcpClient.LocalHostName
'    Call Me.Hide
End Sub



Private Sub LBLAddress_Click()
   oComm1.setquit
End Sub

Private Sub Pic1_Click()
'    GetData (Pic1.Picture.Handle)
    
End Sub



Private Sub tcpClient_Connect()
    LBLState.Caption = "Connection State - " & GetStateString(tcpClient.State)
End Sub

Private Sub tcpClient_DataArrival(ByVal bytesTotal As Long)
    Set CurrentForm = Me
    Call ProcessPacket2(tcpClient, bytesTotal)
    LBLAddress.Caption = "Address - " & tcpClient.LocalIP & " - " & tcpClient.LocalHostName
    LBLState.Caption = "Connection State - " & GetStateString(tcpClient.State)
End Sub



'Private Sub Timer1_Timer()
'    Dim i As Long
'    Call oComm1.incb
'    If (oComm1.getb() > 3) Then
'        Call Shell("restore.exe")
'    End If
'    Call oComm1.reseta
'    If (oComm1.setstaticA(0) = -1) Then
'        Call oComm1.setstaticA(-1)
'    Else
'        i = i
'    End If
'    Call oComm1.setstaticb(1)
'End Sub

Private Sub TxtSendData_Change()
    currentheader.DataItems = 0
    currentheader.HeaderID = 1
    currentheader.PacketType = 1
    Call SendHeader(tcpClient, currentheader)
    Call sendString(tcpClient, TxtSendData.Text)
End Sub
