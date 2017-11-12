VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   2400
      Width           =   4455
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   1680
      Top             =   1080
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      Protocol        =   1
      LocalPort       =   1024
   End
   Begin MSWinsockLib.Winsock Winsock2 
      Left            =   1680
      Top             =   1680
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      Protocol        =   1
      LocalPort       =   1025
   End
   Begin VB.Label LBLData 
      Caption         =   "Label1"
      Height          =   615
      Left            =   360
      TabIndex        =   0
      Top             =   240
      Width           =   2415
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private DataByte(1024) As Byte

Private Enum BlockENUM
    Unknown = 0
    FileHeader = 1
    FileData = 2
End Enum

'' File Header
Private FileName As String
Private FileLength As Long
Private FileCRC As Long
Private FileHeaderCRC As Long

Private fileid As Long

'' File Block
Private FileBlockNumber As Long
Private FileBlockCRC As Long

Private Buffer(1024) As Byte


Private currentposition As Long

Private Sub Form_Load()
    Winsock1.Bind
End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
    Dim tempstring As String
    If (KeyAscii = 13) Then
        tempstring = Text1.Text
        Call Winsock2.SendData(tempstring)
    End If
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim DataString As String
    Dim RemoteIP As String
    Dim RemotePort As String
    Dim tempstring As String
    
    Call Winsock1.GetData(DataString)
    LBLData.Caption = DataString
    If (Len(DataString) > 0) Then
        RemoteIP = Left$(DataString, InStr(DataString, ",") - 1)
        RemotePort = Right$(DataString, Len(DataString) - InStr(DataString, ","))
    '    Call Winsock1.GetData(Buffer(), vbArray + vbByte)
    '    LBLData.Caption = Buffer
        Winsock2.RemoteHost = RemoteIP
        Winsock2.RemotePort = RemotePort
        If (Winsock2.State <> 1) Then
            Call Winsock2.Bind
        End If
        fileid = FreeFile
'        Open "servicemanager.mdb" For Input As #fileid
        Open "input.txt" For Input As #fileid
        Line Input #fileid, tempstring
        Call Winsock2.SendData(tempstring)
        currentposition = Len(tempstring)
    End If
End Sub

Private Function ProcessBlock(pdatabyte() As Byte) As Boolean
    Select Case pdatabyte(0)
        Case 0
            ProcessBlock = ProcessFileHeader(pdatabyte)
        Case 1
            ProcessBlock = ProcessFileBlock(pdatabyte)
        Case 2
    End Select
End Function

Private Function ProcessFileHeader(pdatabyte() As Byte) As Boolean
    FileName = ByteToString(pdatabyte, 2, 64)
    FileLength = ByteToLong(pdatabyte, 2 + 64)
    FileCRC = ByteToLong(pdatabyte, 3 + 64 + 4)
    '''
    FileHeaderCRC = ByteToLong(pdatabyte, 1025 - 4)
    
    fileid = FreeFile
    Open FileName For Output As #fileid
End Function

Private Function ProcessFileBlock(pdatabyte() As Byte) As Boolean
    Dim i As Long
    FileBlockNumber = ByteToLong(pdatabyte, 1)

    FileBlockCRC = ByteToLong(pdatabyte, 1025 - 4)
    
    For i = 5 To 1024 - 4
        Print #fileid, pdatabyte(i)
    Next
End Function

Private Sub Winsock2_DataArrival(ByVal bytesTotal As Long)
    Dim tempstring As String
'    Dim fileid As Long
    Call Winsock2.GetData(tempstring)
'    fileid = FreeFile
    
'    Open "isfedi.mod" For Input As #fileid
'    Seek #fileid, currentposition + 2
    If (EOF(fileid) = False) Then
        Line Input #fileid, tempstring
        DoEvents
        Call Winsock2.SendData(tempstring)
        currentposition = currentposition + Len(tempstring)
    Else
        tempstring = tempstring
    End If
'    Close #fileid
End Sub

