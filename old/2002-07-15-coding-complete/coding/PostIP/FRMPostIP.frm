VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form FRMPostIP 
   Caption         =   "Form1"
   ClientHeight    =   5175
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5835
   LinkTopic       =   "Form1"
   ScaleHeight     =   5175
   ScaleWidth      =   5835
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox TxtConnection 
      Height          =   285
      Left            =   3240
      TabIndex        =   5
      Text            =   "Text1"
      Top             =   840
      Width           =   1815
   End
   Begin VB.TextBox TxtIP 
      Height          =   615
      Left            =   3240
      TabIndex        =   4
      Text            =   "Text1"
      Top             =   120
      Width           =   1575
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   2280
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      Protocol        =   1
      LocalPort       =   1025
   End
   Begin VB.ListBox lstData 
      Height          =   2790
      Left            =   0
      MultiSelect     =   2  'Extended
      OLEDropMode     =   1  'Manual
      TabIndex        =   1
      Top             =   2160
      Width           =   5415
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   3000
      TabIndex        =   0
      Top             =   1320
      Width           =   1095
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   720
      Top             =   1440
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      AccessType      =   1
      RemotePort      =   21
      URL             =   "http://"
   End
   Begin VB.Label lblStat 
      Alignment       =   1  'Right Justify
      Caption         =   "Bytes Received:"
      Height          =   195
      Left            =   1440
      TabIndex        =   3
      Top             =   1800
      Width           =   2730
   End
   Begin VB.Label lblBR 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   4320
      TabIndex        =   2
      Top             =   1800
      Width           =   1005
   End
End
Attribute VB_Name = "FRMPostIP"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function GetShortPathName Lib "kernel32" Alias "GetShortPathNameA" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal cchBuffer As Long) As Long
Private Const MAX_PATH = 260

Dim aCmd As String, aPath As String, lBytes As Long, lBuf As Long, aFile As String


Private Sub GetData(aData As String)
    Dim vData As Variant
    Do
        vData = Inet1.GetChunk(512, icString)
        DoEvents
        If Len(vData) = 0 Then Exit Do
        aData = aData & vData
        lblBR.Caption = CStr(Len(aData))
    Loop
End Sub

Private Sub Command1_Click()
With Inet1
    .Cancel
    .Protocol = icFTP
    .URL = "ftp.linhill.co.uk"
    .UserName = "access3-15525-usr"
    .Password = "15525"
End With

'    Call Inet1.Execute("PASS 15525")
'    Call Inet1.Execute(, "CDUP")
    Call Inet1.Execute(, "PUT d:\coding\postip\dale.txt /www/dale2.txt")
End Sub

Private Sub Form_Load()
    Call SocketsInitialize
    TxtIP.Text = GetTheIP()
    TxtConnection.Text = Connected_To_ISP
    Dim fileid As Long
    fileid = FreeFile
    Open App.Path & "\dale.txt" For Output As #fileid
    Print #fileid, TxtIP.Text
    Close #fileid
'    TxtIP.Text = Winsock1.LocalIP
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call SocketsCleanup
End Sub

Private Sub Inet1_StateChanged(ByVal State As Integer)
    Dim aData As String, a As String, k As Long, aStat As String
    Select Case State
        Case icNone
            aStat = ""
        Case icResolvingHost
            aStat = "Resolving Host"
        Case icHostResolved
            aStat = "Host Resolved"
        Case icConnecting
            aStat = "Connecting"
        Case icConnected
            aStat = "Connected"
        Case icRequesting
            aStat = "Sending Request"
        Case icRequestSent
            aStat = "Request Sent"
        Case icReceivingResponse
            aStat = "Receiving Response"
        Case icResponseReceived
            aStat = "Response Received"
        Case icDisconnecting
            aStat = "Disconnecting"
        Case icDisconnected
            aStat = "Disconnected"
        Case icError
            aStat = "Remote Error"
            MousePointer = vbDefault
        Case icResponseCompleted
            lblStat.ForeColor = vbButtonText
            lblStat.Caption = "Response Completed": DoEvents
            Select Case aCmd
                Case "DIR"
                    lblStat.Caption = "Bytes Received:"
                    lstData.Clear
                    GetData aData
                    lstData.AddItem ".."
                    Do While Len(aData)
                        k = InStr(aData, vbCrLf)
                        If k Then
                            a = Left$(aData, k - 1)
                            aData = Mid$(aData, k + 2)
                        Else
                            a = aData
                            aData = ""
                        End If
                        If Len(Trim$(a)) Then lstData.AddItem Trim$(a)
                    Loop
                Case "SIZE"
                    lblStat.Caption = "Bytes To Go:"
                    GetData aData
                    lblBR.Caption = Trim$(aData)
                    lBytes = Val(aData)
                Case "GET"
                  '  lblGET.Caption = "File Retrieved: " & vbCrLf & aFile
                Case "PUT"
                  '  lblGET.Caption = "File Sent: " & vbCrLf & aFile
            End Select
            MousePointer = vbDefault
            Exit Sub
    End Select
    lblStat.Caption = aStat
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim command As String
    Call Winsock1.GetData(command, vbString)
End Sub

