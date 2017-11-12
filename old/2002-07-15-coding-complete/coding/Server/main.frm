VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form FrmServer 
   Caption         =   "Server"
   ClientHeight    =   4140
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9855
   LinkTopic       =   "Form1"
   ScaleHeight     =   4140
   ScaleWidth      =   9855
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton CMDJim 
      Caption         =   "Jim"
      Height          =   375
      Left            =   7800
      TabIndex        =   31
      Top             =   1920
      Width           =   735
   End
   Begin VB.CommandButton CMDStartJim 
      Caption         =   "ST"
      Height          =   375
      Left            =   7440
      TabIndex        =   32
      Top             =   1920
      Width           =   375
   End
   Begin VB.CommandButton CMDPaul 
      Caption         =   "Paul"
      Height          =   375
      Left            =   9120
      TabIndex        =   17
      Top             =   1920
      Width           =   735
   End
   Begin VB.CommandButton CMDStartPaul 
      Caption         =   "ST"
      Height          =   375
      Left            =   8760
      TabIndex        =   30
      Top             =   1920
      Width           =   375
   End
   Begin VB.CommandButton CMDLee 
      Caption         =   "Lee"
      Height          =   375
      Left            =   9120
      TabIndex        =   16
      Top             =   1440
      Width           =   735
   End
   Begin VB.CommandButton CMDStartLee 
      Caption         =   "ST"
      Height          =   375
      Left            =   8760
      TabIndex        =   29
      Top             =   1440
      Width           =   375
   End
   Begin VB.CommandButton CMDRandom 
      Caption         =   "Random"
      Height          =   375
      Left            =   2160
      TabIndex        =   28
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton CmdMouseDisable 
      Caption         =   "D"
      Height          =   375
      Left            =   1440
      TabIndex        =   27
      Top             =   3720
      Width           =   375
   End
   Begin VB.CommandButton CMDEnable 
      Caption         =   "E"
      Height          =   375
      Left            =   1080
      TabIndex        =   26
      Top             =   3720
      Width           =   375
   End
   Begin VB.TextBox TXTMouseInterval 
      Height          =   285
      Left            =   120
      TabIndex        =   25
      Text            =   "100"
      Top             =   3840
      Width           =   855
   End
   Begin VB.Timer MouseTimer 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   8760
      Top             =   0
   End
   Begin VB.CommandButton CmdDale 
      Caption         =   "Dale"
      Height          =   375
      Left            =   9120
      TabIndex        =   14
      Top             =   480
      Width           =   735
   End
   Begin VB.CommandButton CMDStartDale 
      Caption         =   "ST"
      Height          =   375
      Left            =   8760
      TabIndex        =   24
      Top             =   480
      Width           =   375
   End
   Begin VB.CommandButton CMDDean 
      Caption         =   "Dean"
      Height          =   375
      Left            =   9120
      TabIndex        =   15
      Top             =   960
      Width           =   735
   End
   Begin VB.CommandButton CMDStartDean 
      Caption         =   "ST"
      Height          =   375
      Left            =   8760
      TabIndex        =   23
      Top             =   960
      Width           =   375
   End
   Begin VB.CommandButton Command6 
      Caption         =   "LoopBack"
      Height          =   375
      Left            =   8760
      TabIndex        =   22
      Top             =   2400
      Width           =   1095
   End
   Begin VB.CommandButton CmdDisableMouse 
      Caption         =   "Disable"
      Height          =   375
      Left            =   6960
      TabIndex        =   20
      Top             =   3720
      Width           =   1455
   End
   Begin VB.CommandButton CmdMouseEnable 
      Caption         =   "Enable"
      Height          =   375
      Left            =   5400
      TabIndex        =   19
      Top             =   3720
      Width           =   1455
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   8520
      TabIndex        =   13
      Top             =   3720
      Width           =   1335
   End
   Begin VB.ListBox LSTAlbums 
      Height          =   3180
      Left            =   0
      TabIndex        =   10
      Top             =   360
      Width           =   2775
   End
   Begin VB.ListBox LSTSongs 
      Height          =   3180
      Left            =   2880
      TabIndex        =   9
      Top             =   360
      Width           =   2775
   End
   Begin VB.Frame FrmState 
      Caption         =   "Connect Destination Status - XXXX"
      Height          =   1335
      Left            =   5760
      TabIndex        =   4
      Top             =   360
      Width           =   2895
      Begin VB.CommandButton CmdKill 
         Caption         =   "Kill"
         Height          =   375
         Left            =   1080
         TabIndex        =   18
         Top             =   840
         Width           =   735
      End
      Begin VB.CommandButton CMDHide 
         Caption         =   "Hide"
         Height          =   375
         Left            =   120
         TabIndex        =   12
         Top             =   840
         Width           =   855
      End
      Begin VB.CommandButton CMDShow 
         Caption         =   "Show"
         Height          =   375
         Left            =   1920
         TabIndex        =   11
         Top             =   840
         Width           =   855
      End
      Begin VB.Label LBLAddress 
         Caption         =   "Address - XXXXXXXX"
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   240
         Width           =   2535
      End
      Begin VB.Label LBLState 
         Caption         =   "Connection State - XXXXXX"
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   480
         Width           =   2535
      End
   End
   Begin VB.TextBox TxtOutput 
      Height          =   285
      Left            =   7440
      TabIndex        =   1
      Top             =   3240
      Width           =   2295
   End
   Begin VB.TextBox TxtSendData 
      Height          =   285
      Left            =   7440
      TabIndex        =   0
      Top             =   2880
      Width           =   2295
   End
   Begin MSWinsockLib.Winsock tcpServer 
      Left            =   9240
      Top             =   0
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      Protocol        =   1
   End
   Begin VB.Label LblComputer 
      Caption         =   "Label5"
      Height          =   255
      Left            =   5640
      TabIndex        =   21
      Top             =   0
      Width           =   3015
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
      TabIndex        =   8
      Top             =   0
      Width           =   1575
   End
   Begin VB.Label Label3 
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
      TabIndex        =   7
      Top             =   0
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
      Left            =   5760
      TabIndex        =   3
      Top             =   3240
      Width           =   1575
   End
   Begin VB.Label Label1 
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
      Left            =   5760
      TabIndex        =   2
      Top             =   2880
      Width           =   1575
   End
End
Attribute VB_Name = "FrmServer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'' Program - Redundancy Checker
''
'' Searches .frm files for unused localy dimension varibles and comments
''
Option Explicit
Dim CurrentHeader As TCPHeader
Dim Random As Long

Public Function Kill() As Long
'    oComm1.setquit
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

Private Sub CmdDale_Click()
    On Error Resume Next
    FrmState.Caption = "Disconnected"
If tcpServer.State <> sckClosed Then tcpServer.Close
tcpServer.LocalPort = 1002

tcpServer.RemoteHost = "Dark Elf"
tcpServer.RemotePort = 1002    ' Port to connect to.
'tcpServer.Bind 1001                ' Bind to the local port.
LBLAddress.Caption = "Address - " & tcpServer.LocalIP & " - " & tcpServer.LocalHostName
LBLState.Caption = "Connection State - " & GetStateString(tcpServer.State)
    If (tcpServer.State <> 0) Then
    
'    Dim PacketType As Long
'    PacketType = 6
'    Call tcpServer.SendData(PacketType)
End If
'FrmState.Caption = "Connect Destination Status - Dale"
End Sub

Private Sub CMDDean_Click()
    On Error Resume Next
    FrmState.Caption = "Disconnected"
    If tcpServer.State <> sckClosed Then tcpServer.Close
    tcpServer.LocalPort = 1002

    tcpServer.RemoteHost = "Dean"
    tcpServer.RemotePort = 1002    ' Port to connect to.
'tcpServer.Bind 1001                ' Bind to the local port.
    LBLAddress.Caption = "Address - " & tcpServer.LocalIP & " - " & tcpServer.LocalHostName
    LBLState.Caption = "Connection State - " & GetStateString(tcpServer.State)
    If (tcpServer.State <> 0) Then
    Dim PacketType As Long
    PacketType = 6
    Call tcpServer.SendData(PacketType)
    End If
'FrmState.Caption = "Connect Destination Status - Dale"
End Sub

Private Sub CmdDisableMouse_Click()
    FrmStatus.MouseTimer.Interval = 0
End Sub

Private Sub CMDEnable_Click()
    MouseTimer.Enabled = True
End Sub

Private Sub CMDHide_Click()
    CurrentHeader.DataItems = 0
    CurrentHeader.HeaderID = 1
    CurrentHeader.PacketType = 4
    Call SendHeader(tcpServer, CurrentHeader)
End Sub

Private Sub CMDJim_Click()
    On Error Resume Next
    FrmState.Caption = "Disconnected"
If tcpServer.State <> sckClosed Then tcpServer.Close
tcpServer.LocalPort = 1002

tcpServer.RemoteHost = "konelius"
tcpServer.RemotePort = 1002    ' Port to connect to.
tcpServer.Bind 1002                ' Bind to the local port.
LBLAddress.Caption = "Address - " & tcpServer.LocalIP & " - " & tcpServer.LocalHostName
LBLState.Caption = "Connection State - " & GetStateString(tcpServer.State)
    If (tcpServer.State <> 0) Then
    
'    Dim PacketType As Long
'    PacketType = 6
'    Call tcpServer.SendData(PacketType)
End If
'FrmState.Caption = "Connect Destination Status - Dale"
End Sub

Private Sub CmdKill_Click()
    CurrentHeader.DataItems = 0
    CurrentHeader.HeaderID = 1
    CurrentHeader.PacketType = 8
    Call SendHeader(tcpServer, CurrentHeader)
End Sub

Private Sub CMDLee_Click()
    On Error Resume Next
    FrmState.Caption = "Disconnected"
    If tcpServer.State <> sckClosed Then tcpServer.Close
    tcpServer.LocalPort = 1002

    tcpServer.RemoteHost = "Darren"
    tcpServer.RemotePort = 1002    ' Port to connect to.
    'tcpServer.Bind 1002                ' Bind to the local port.
    LBLAddress.Caption = "Address - " & tcpServer.LocalIP & " - " & tcpServer.LocalHostName
    LBLState.Caption = "Connection State - " & GetStateString(tcpServer.State)
    If (tcpServer.State <> 0) Then
 '       Dim PacketType As Long
 '       PacketType = 6
 '       Call tcpServer.SendData(PacketType)
    End If
'FrmState.Caption = "Connect Destination Status - Dale"
End Sub

Private Sub CmdMouseDisable_Click()
    MouseTimer.Enabled = False
End Sub

Private Sub CmdMouseEnable_Click()
    FrmStatus.MouseTimer.Interval = 10 '1000=1second
    Call FrmStatus.Show(1)
End Sub

Private Sub CMDPaul_Click()
    On Error Resume Next
    FrmState.Caption = "Disconnected"
    If tcpServer.State <> sckClosed Then tcpServer.Close
    tcpServer.LocalPort = 1002

    tcpServer.RemoteHost = "Paul"
    tcpServer.RemotePort = 1002    ' Port to connect to.
    'tcpServer.Bind 1002                ' Bind to the local port.
    LBLAddress.Caption = "Address - " & tcpServer.LocalIP & " - " & tcpServer.LocalHostName
    LBLState.Caption = "Connection State - " & GetStateString(tcpServer.State)
    If (tcpServer.State <> 0) Then
'        Dim PacketType As Long
'        PacketType = 6
'        Call tcpServer.SendData(PacketType)
    End If
'FrmState.Caption = "Connect Destination Status - Dale"
End Sub

Private Sub CMDRandom_Click()
    If (Random <> 0) Then
        Random = 0
    Else
        Random = 1
    End If
End Sub

Private Sub CMDShow_Click()
    CurrentHeader.DataItems = 0
    CurrentHeader.HeaderID = 1
    CurrentHeader.PacketType = 5
    Call SendHeader(tcpServer, CurrentHeader)
End Sub

Private Sub CMDStartDale_Click()
    Set oComm1 = CreateObject("daleclasses.comm1", "Dark Elf")
    Call oComm1.clientexecute("c:\coding\server\darren2")
End Sub

Private Sub CMDStartDean_Click()
    Set oComm1 = CreateObject("daleclasses.comm1", "Dean")
    Call oComm1.clientexecute("c:\coding\server\darren2")
End Sub

Private Sub CMDStartJim_Click()
    Set oComm1 = CreateObject("daleclasses.comm1", "konelius")
    Call oComm1.clientexecute("c:\program files\client\darren2")
End Sub

Private Sub CMDStartLee_Click()
    Set oComm1 = CreateObject("daleclasses.comm1", "Dean")
    Call oComm1.clientexecute("c:\coding\server\darren2")
End Sub

Private Sub CMDStartPaul_Click()
    Set oComm1 = CreateObject("daleclasses.comm1", "Paul")
    Call oComm1.clientexecute("c:\coding\server\darren2")
End Sub

Private Sub Command6_Click()
   On Error Resume Next
    FrmState.Caption = "Disconnected"
    If tcpServer.State <> sckClosed Then tcpServer.Close
    tcpServer.LocalPort = 1002

    tcpServer.RemoteHost = "Dale"
    tcpServer.RemotePort = 1002    ' Port to connect to.
    'tcpServer.Bind 1002                ' Bind to the local port.
    LBLAddress.Caption = "Address - " & tcpServer.LocalIP & " - " & tcpServer.LocalHostName
    LBLState.Caption = "Connection State - " & GetStateString(tcpServer.State)
    If (tcpServer.State <> 0) Then
'        Dim PacketType As Long
'        PacketType = 6
'        Call tcpServer.SendData(PacketType)
    End If
'FrmState.Caption = "Connect Destination Status - Dale"
End Sub

Private Sub Form_Load()
    Set CurrentForm = Me
    Dim computername As String * 50
    Call GetComputerName(computername, 50)
    LblComputer.Caption = "This Computer Name - " & computername
'    Dim ff As TCPHeader
'    Call SendHeader(tcpServer, ff)
 '    FrmStatus.Show
 Dim a As String
'    Set wrkJet = CreateWorkspace("ODBCWorkspace", "admin", "", dbUseODBC)

 '   Set db = wrkJet.OpenDatabase("", False, False, "ODBC;DSN=data;UID=;PWD=;")
 '   Dim rsAlbums As Recordset
 '   Set rsAlbums = db.OpenRecordset("select * from MPEGAlbums", dbOpenSnapshot)
 '   If (rsAlbums.EOF() = False) Then
 '       rsAlbums.MoveFirst
 '       Do While (rsAlbums.EOF() = False)
 '           Call LSTAlbums.AddItem(rsAlbums!albumName)
 '           rsAlbums.MoveNext
 '       Loop
 '   End If

' Set the LocalPort property to an integer.' Then invoke the Listen method.
    tcpServer.LocalPort = 1002

tcpServer.Bind 1002                ' Bind to the local port.
'Dim bytestring As Object
'Dim po As POINTAPI
'bytestring = po
'Call tcpServer.SendData(po)
 'tcpServer.Listen
'frmClient.Show ' Show the client form.
End Sub


Private Sub LSTAlbums_Click()
   Dim rsSongs As Recordset
    Dim sql As String
    LSTSongs.Clear
    sql = "select * from MPEGsongs where albumnum=" & (LSTAlbums.ListIndex + 1)
    Set rsSongs = db.OpenRecordset(sql, dbOpenSnapshot)
    If (rsSongs.EOF() = False) Then
        rsSongs.MoveFirst
        Do While (rsSongs.EOF() = False)
            Call LSTSongs.AddItem(rsSongs!songName)
            rsSongs.MoveNext
        Loop
    End If
    If (tcpServer.State <> 0) Then
    
    CurrentHeader.DataItems = 1
    CurrentHeader.HeaderID = 1
    CurrentHeader.PacketType = 2
    Call SendHeader(tcpServer, CurrentHeader)
    Call sendString(tcpServer, LSTAlbums.List(LSTAlbums.ListIndex))
    End If
End Sub

Private Sub LSTSongs_Click()
    CurrentHeader.DataItems = 1
    CurrentHeader.HeaderID = 1
    CurrentHeader.PacketType = 3
    Call SendHeader(tcpServer, CurrentHeader)
    Call sendString(tcpServer, LSTSongs.List(LSTSongs.ListIndex))
End Sub

Private Sub MouseTimer_Timer()
    Dim point As POINTAPI
    If (Random = 1) Then
        point.X = Rnd() * 800
        point.Y = Rnd() * 600
    Else
        Call GetCursorPos(point)
    End If
    On Error Resume Next
    Call oComm1.setmousepos(point.X + 1, point.Y + 1)
End Sub

Private Sub tcpServer_ConnectionRequest(ByVal requestID As Long)
' Check if the control's State is closed. If not,
' close the connection before accepting the new' connection.
If tcpServer.State <> sckClosed Then tcpServer.Close
' Accept the request with the requestID ' parameter.tcpServer.Accept requestID
End Sub

Private Sub TXTMouseInterval_Change()
    If (IsNumeric(TXTMouseInterval.Text)) Then
        MouseTimer.Interval = TXTMouseInterval.Text
    End If
End Sub

Private Sub txtSendData_Change()
    CurrentHeader.DataItems = 1
    CurrentHeader.HeaderID = 1
    CurrentHeader.PacketType = 1
    Call SendHeader(tcpServer, CurrentHeader)
    Call sendString(tcpServer, TxtSendData.Text)
    LBLState.Caption = "Connection State - " & GetStateString(tcpServer.State)
End Sub

Private Sub tcpServer_DataArrival(ByVal bytesTotal As Long)
    Set CurrentForm = Me
    Call ProcessPacket2(tcpServer, bytesTotal)
    LBLState.Caption = "Connection State - " & GetStateString(tcpServer.State)
End Sub


