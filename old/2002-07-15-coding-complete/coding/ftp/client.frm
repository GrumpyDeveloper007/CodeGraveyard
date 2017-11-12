VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   Caption         =   "Client"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   3000
      TabIndex        =   0
      Top             =   600
      Width           =   975
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   1920
      Top             =   1440
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      Protocol        =   1
      RemoteHost      =   "169.254.1.9"
      RemotePort      =   1024
      LocalPort       =   1026
   End
   Begin MSWinsockLib.Winsock Winsock2 
      Left            =   2520
      Top             =   1440
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      Protocol        =   1
      RemoteHost      =   "169.254.1.9"
      RemotePort      =   1024
      LocalPort       =   1027
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   375
      Left            =   480
      TabIndex        =   2
      Top             =   2400
      Width           =   3375
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   615
      Left            =   360
      TabIndex        =   1
      Top             =   600
      Width           =   2055
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

Private bps As Long
Private lasttime As Date


'

Private Sub Command1_Click()
    Dim datastring As String
    ' send header
    Call StringToByte(DataByte, 1, 64, "Filename.txt")
    Call LongToByte(123, DataByte, 2 + 64)
    Call LongToByte(123, DataByte, 3 + 64 + 4)
    '''
    Call LongToByte(123, DataByte, 1025 - 4)
    
    datastring = Winsock1.LocalIP & ",1027"
    Call Winsock1.SendData(datastring)
End Sub

Private Sub Form_Load()
    Dim i As Long
    i = i
    Winsock1.Bind
    Winsock2.Bind
    Call LongToByte(123456789, DataByte, 1)
    i = ByteToLong(DataByte, 1)
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
'    FileBlockNumber ByteToLong(pdatabyte, 1)

'    FileBlockCRC = ByteToLong(pdatabyte, 1025 - 4)
    
'    For i = 5 To 1024 - 4
'    Print #fileid, pdatabyte(i)
End Function

Private Sub Winsock2_DataArrival(ByVal bytesTotal As Long)
    Dim tempstring As String
    Dim reply As String
    Dim fileid As Long
    fileid = FreeFile
    Open "output.txt" For Append As #fileid
    Call Winsock2.GetData(tempstring)
    DoEvents
    Print #fileid, tempstring
    Close #fileid
    Label1.Caption = tempstring
    If (lasttime <> Now) Then
        lasttime = Now
        Label2.Caption = "bps:" & bps
        bps = 0
    End If
    bps = bps + Len(tempstring)
    reply = "Reply"
    Call Winsock2.SendData(reply)
End Sub

