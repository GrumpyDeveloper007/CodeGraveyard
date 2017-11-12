VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form FRMControlServer 
   Caption         =   "Form2"
   ClientHeight    =   6285
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9810
   LinkTopic       =   "Form2"
   ScaleHeight     =   6285
   ScaleWidth      =   9810
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox TXTLog 
      Height          =   1155
      Index           =   1
      Left            =   4920
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   21
      Top             =   3540
      Width           =   4815
   End
   Begin VB.TextBox TXTLog 
      Height          =   1155
      Index           =   0
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   20
      Top             =   3540
      Width           =   4815
   End
   Begin VB.CommandButton CMDList 
      Caption         =   "List"
      Height          =   315
      Index           =   0
      Left            =   1560
      TabIndex        =   19
      Top             =   360
      Width           =   975
   End
   Begin VB.CommandButton CMDList 
      Caption         =   "List"
      Height          =   315
      Index           =   1
      Left            =   6480
      TabIndex        =   18
      Top             =   360
      Width           =   975
   End
   Begin VB.TextBox TXTPath 
      Height          =   315
      Index           =   1
      Left            =   4920
      TabIndex        =   17
      Text            =   "/"
      Top             =   360
      Width           =   1455
   End
   Begin VB.TextBox TXTPath 
      Height          =   315
      Index           =   0
      Left            =   0
      TabIndex        =   16
      Text            =   "/"
      Top             =   360
      Width           =   1455
   End
   Begin VB.ListBox LSTLocalFiles 
      Height          =   1035
      Left            =   2520
      TabIndex        =   14
      Top             =   5220
      Width           =   4815
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   2880
      Top             =   660
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      LocalPort       =   100
   End
   Begin VB.TextBox TXTBytes 
      Height          =   315
      Index           =   1
      Left            =   4920
      TabIndex        =   13
      Top             =   900
      Width           =   1575
   End
   Begin VB.TextBox TXTSpeed 
      Height          =   315
      Index           =   1
      Left            =   6600
      TabIndex        =   12
      Top             =   900
      Width           =   855
   End
   Begin VB.CommandButton CMDConnect 
      Caption         =   "Connect"
      Height          =   315
      Index           =   1
      Left            =   8520
      TabIndex        =   11
      Top             =   0
      Width           =   975
   End
   Begin VB.ComboBox CBOIP 
      Height          =   315
      Index           =   1
      Left            =   4920
      TabIndex        =   10
      Top             =   0
      Width           =   2775
   End
   Begin VB.TextBox TXTPort 
      Height          =   315
      Index           =   1
      Left            =   7800
      TabIndex        =   9
      Text            =   "21"
      Top             =   0
      Width           =   495
   End
   Begin VB.CommandButton CMDDisConnect 
      Caption         =   "Disconnect"
      Height          =   315
      Index           =   1
      Left            =   8520
      TabIndex        =   8
      Top             =   360
      Width           =   975
   End
   Begin VB.ListBox LSTBrowser 
      Height          =   2205
      Index           =   1
      Left            =   4920
      TabIndex        =   7
      Top             =   1260
      Width           =   4815
   End
   Begin VB.TextBox TXTBytes 
      Height          =   315
      Index           =   0
      Left            =   0
      TabIndex        =   6
      Top             =   900
      Width           =   1575
   End
   Begin VB.TextBox TXTSpeed 
      Height          =   315
      Index           =   0
      Left            =   1680
      TabIndex        =   5
      Top             =   900
      Width           =   855
   End
   Begin VB.CommandButton CMDConnect 
      Caption         =   "Connect"
      Height          =   315
      Index           =   0
      Left            =   3600
      TabIndex        =   4
      Top             =   0
      Width           =   975
   End
   Begin VB.ComboBox CBOIP 
      Height          =   315
      Index           =   0
      Left            =   0
      TabIndex        =   3
      Top             =   0
      Width           =   2775
   End
   Begin VB.TextBox TXTPort 
      Height          =   315
      Index           =   0
      Left            =   2880
      TabIndex        =   2
      Text            =   "21"
      Top             =   0
      Width           =   495
   End
   Begin VB.CommandButton CMDDisConnect 
      Caption         =   "Disconnect"
      Height          =   315
      Index           =   0
      Left            =   3600
      TabIndex        =   1
      Top             =   360
      Width           =   975
   End
   Begin VB.ListBox LSTBrowser 
      Height          =   2205
      Index           =   0
      Left            =   0
      TabIndex        =   0
      Top             =   1260
      Width           =   4815
   End
   Begin VB.Label LBLStatus 
      Caption         =   "Label1"
      Height          =   255
      Left            =   7440
      TabIndex        =   15
      Top             =   5280
      Width           =   2055
   End
End
Attribute VB_Name = "FRMControlServer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private vSendComplete As Boolean

Private Sub SendCommand(pName As String)
    Call Winsock1.SendData(pName & vbCrLf)
    Do While (vSendComplete = False)
        DoEvents
    Loop
End Sub


Private Sub CMDConnect_Click(Index As Integer)
    Call SendCommand(Index & "-CI-" & CBOIP(0).Text)
    Call SendCommand(Index & "-CP-" & TXTPort(0).Text)
    Call SendCommand(Index & "-CO-")
End Sub

Private Sub CMDDisConnect_Click(Index As Integer)
    Call SendCommand(Index & "-CL-")
End Sub

Private Sub CMDList_Click(Index As Integer)
    Call LSTBrowser(Index).Clear
    Call LSTBrowser(Index).AddItem("(Folder)..")
    Call SendCommand(Index & "-LL-" & TXTPath(Index).Text)
End Sub

Private Sub Form_Load()
    Call Winsock1.Listen
    vSendComplete = False
    
    Call CBOIP(0).AddItem("137.43.110.11")
    Call CBOIP(0).AddItem("211.234.43.106")
    Call CBOIP(0).AddItem("64.192.255.13")
    
    Call CBOIP(0).AddItem("160.252.122.191")
    
    Call CBOIP(0).AddItem("195.47.16.130")
    
    Call CBOIP(0).AddItem("205.227.116.117")
    
    Call CBOIP(0).AddItem("211.57.221.162")
    Call CBOIP(0).AddItem("--------------")
    Call CBOIP(0).AddItem("203.250.120.181")

    Call CBOIP(0).AddItem("--------------")
    Call CBOIP(0).AddItem("211.224.231.28")
    Call CBOIP(0).AddItem("216.36.67.12")
    Call CBOIP(0).AddItem("211.224.231.28")
    Call CBOIP(0).AddItem("--------------")

End Sub

Private Sub Form_Unload(Cancel As Integer)
    End
End Sub

Private Sub LSTBrowser_DblClick(Index As Integer)
    Dim FileSize As Long
    Dim tempstring As String
    If (Left$(LSTBrowser(Index).List(LSTBrowser(Index).ListIndex), 8) = "(Folder)") Then
        ' folder
        tempstring = Mid$(LSTBrowser(Index).List(LSTBrowser(Index).ListIndex), 9)
        If (tempstring = "..") Then
            If (TXTPath(Index).Text <> "/") Then
                TXTPath(Index).Text = Left$(TXTPath(Index).Text, InStrRev(TXTPath(Index).Text, "/", Len(TXTPath(Index).Text) - 1))
            End If
        Else
            If (Right$(TXTPath(Index).Text, 1) <> "/") Then
                TXTPath(Index).Text = TXTPath(Index).Text & "/"
            End If
            TXTPath(Index).Text = TXTPath(Index).Text & tempstring
        End If
        Call CMDList_Click(Index)
    Else
        ' file
        tempstring = Mid$(LSTBrowser(Index).List(LSTBrowser(Index).ListIndex), 7)
        FileSize = Mid$(tempstring, InStrRev(tempstring, ",") + 1)
        tempstring = Mid$(tempstring, 1, InStrRev(tempstring, ",") - 1)
'        Call DownloadFile(TXTPath(Index).Text, tempstring)

    End If
End Sub

Private Sub Winsock1_ConnectionRequest(ByVal requestID As Long)
    ' Close the connection if it is currently open
    ' by testing the State property.
    If Winsock1.State <> sckClosed Then Winsock1.Close

    ' Pass the value of the requestID parameter to the
    ' Accept method.
    Winsock1.Accept requestID
    Do While (Winsock1.State <> 7)
        DoEvents
    Loop
    Call SendCommand("0-O-N/A")
    Call SendCommand("0-O-N/A")

End Sub

Private Sub ProcessCommand(pTempstring As String)
    Dim Number As Long
    Dim Command As String
    Dim Parameters As String
    
    Dim Path As String
    Dim FileName As String
    
    Dim tempstring As String
    
    tempstring = pTempstring
    Number = Left$(tempstring, InStr(tempstring, "-") - 1)
    tempstring = Mid$(tempstring, InStr(tempstring, "-") + 1)
    Command = Left$(tempstring, InStr(tempstring, "-") - 1)
    Parameters = Mid$(tempstring, InStr(tempstring, "-") + 1)
    
    Select Case Command
        Case "C" ' List
            Call LSTBrowser(Number).AddItem(Replace(Parameters, vbCrLf, ""))
        Case "S" ' Server feedback
            TXTLog(Number).Text = TXTLog(Number).Text & Parameters
        Case Else
            TXTLog(Number).Text = TXTLog(Number).Text & Parameters
            
    End Select
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    
    Dim tempstring As String
    
    Call Winsock1.GetData(tempstring, vbString)
    
    Do While (tempstring <> "")
        Call ProcessCommand(Left$(tempstring, InStr(tempstring, vbCrLf) - 1))
        tempstring = Mid$(tempstring, InStr(tempstring, vbCrLf) + 2)
    Loop
    
End Sub

Private Sub Winsock1_SendComplete()
    LBLStatus.Caption = "Send Complete"
    vSendComplete = True
End Sub
