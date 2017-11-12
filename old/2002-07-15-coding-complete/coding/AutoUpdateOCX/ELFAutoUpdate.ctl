VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.UserControl UserControl1 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   Begin VB.TextBox Text1 
      Height          =   1335
      Left            =   840
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   2
      Text            =   "ELFAutoUpdate.ctx":0000
      Top             =   2040
      Width           =   2655
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   1440
      Top             =   1440
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin VB.Label lblStat 
      Alignment       =   1  'Right Justify
      Caption         =   "Bytes Received:"
      Height          =   195
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   2730
   End
   Begin VB.Label lblBR 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   2820
      TabIndex        =   0
      Top             =   0
      Width           =   1005
   End
End
Attribute VB_Name = "UserControl1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Declare Function GetShortPathName Lib "kernel32" Alias "GetShortPathNameA" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal cchBuffer As Long) As Long
Private Const MAX_PATH = 260

Dim aCmd As String, aPath As String, lBytes As Long, lBuf As Long, aFile As String
Dim files(200) As String
Dim numfiles As Long
Dim filenumber As Long
Dim pause As Long


Private Sub Inet1_StateChanged(ByVal State As Integer)
    Dim adata As String, a As String, k As Long, aStat As String
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
                    GetData adata
                    lstData.AddItem ".."
                    Do While Len(adata)
                        k = InStr(adata, vbCrLf)
                        If k Then
                            a = Left$(adata, k - 1)
                            adata = Mid$(adata, k + 2)
                        Else
                            a = adata
                            adata = ""
                        End If
                        If Len(Trim$(a)) Then lstData.AddItem Trim$(a)
                    Loop
                Case "SIZE"
                    lblStat.Caption = "Bytes To Go:"
                    GetData adata
                    lblBR.Caption = Trim$(adata)
                    lBytes = Val(adata)
                Case "GET"
                    lblGET.Caption = "File Retrieved: " & vbCrLf & aFile
                    Text1.Text = Inet1.GetHeader
                    Text1.Text = Text1.Text & GetData2()
                    ' download file
                    Timer1.Enabled = True
                Case "PUT"
                    lblGET.Caption = "File Sent: " & vbCrLf & aFile
            End Select
            MousePointer = vbDefault
            Exit Sub
    End Select
    lblStat.Caption = aStat
End Sub

Public Function Go()
    With Inet1
        .Cancel
        .Protocol = icFTP
        .URL = txt(0).Text
        .UserName = txt(1).Text
        .Password = txt(2).Text
    End With
    MousePointer = vbHourglass
    aCmd = "DIR"
    lblBR.Caption = "": lblStat.ForeColor = vbRed
'    aCmd = "GET"
    Inet1.Execute , aCmd

End Function

Public Function Quit()
    aCmd = "QUIT"
    Inet1.Execute , aCmd
End Function

