VERSION 5.00
Object = "{DB0F9920-E84B-11D3-B834-009027603F96}#3.0#0"; "TXTBOX.OCX"
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form FRMRemote 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox TXTOutput 
      Height          =   315
      Left            =   1680
      TabIndex        =   0
      Top             =   840
      Width           =   1215
   End
   Begin MSWinsockLib.Winsock Remote 
      Left            =   1680
      Top             =   360
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      RemotePort      =   20001
      LocalPort       =   101
   End
   Begin Threed.SSCommand CMDConnect 
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   1560
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "Connect"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin ELFTxtBox.TxtBox1 TXTState 
      Height          =   285
      Left            =   1680
      TabIndex        =   2
      Top             =   0
      Width           =   615
      _ExtentX        =   1085
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
         Type            =   0
         Format          =   ""
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   2057
         SubFormatType   =   0
      EndProperty
      Text            =   ""
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin Threed.SSCommand CMDClose 
      Height          =   375
      Left            =   1440
      TabIndex        =   3
      Top             =   1560
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "Close"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   3480
      TabIndex        =   4
      Top             =   1560
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "E&xit"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "State"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   1
      Left            =   720
      TabIndex        =   6
      Top             =   0
      Width           =   855
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Test"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   960
      TabIndex        =   5
      Top             =   840
      Width           =   615
   End
End
Attribute VB_Name = "FRMRemote"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Reports Designer Object
''
''

Private vIsLoaded As Boolean

Private Sub CMDClose_Click()
    Remote.Close
    CMDConnect.Enabled = True
End Sub

Private Sub CMDConnect_Click()
    CMDConnect.Enabled = False
    Call Remote.Connect("laptop")
End Sub

Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
'    Call Remote.Listen
'    Winsock1.RemoteHost = GetServerSetting("REMOTEHOST")
'    If (Winsock1.RemoteHost <> "") Then
'        Call Winsock1.Connect
'    End If

End Sub


Private Sub Form_Unload(Cancel As Integer)
    vIsLoaded = False
    Call GetWindowPosition(Me)
    Call CMDClose_Click
End Sub

Private Sub Remote_Close()
    TXTState.Text = Remote.State
End Sub

Private Sub Remote_Connect()
    TXTState.Text = Remote.State
End Sub

Private Sub Remote_ConnectionRequest(ByVal requestID As Long)
' Check if the control's State is closed. If not,
' close the connection before accepting the new
' connection.
If Remote.State <> sckClosed Then
    Remote.Close
End If
' Accept the request with the requestID
' parameter.
Remote.Accept requestID
    TXTState.Text = Remote.State
End Sub

Private Sub Remote_DataArrival(ByVal bytesTotal As Long)
' Declare a variable for the incoming data.
' Invoke the GetData method and set the Text
' property of a TextBox named txtOutput to
' the data.
Dim strData As String
Remote.GetData strData
TXTOutput.Text = strData
End Sub

Private Sub Remote_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    If (Number = 10061) Then 'Connection is forcefully rejected
    
    End If
    
    If (Number = 10048) Then ' port in use
        Remote.Close
'        Remote.LocalPort = 101
        Remote.LocalPort = Remote.LocalPort + 1
        Call CMDConnect_Click
    End If
    TXTState.Text = Remote.State
End Sub

Private Sub Remote_SendComplete()
    TXTState.Text = Remote.State
End Sub

Private Sub Remote_SendProgress(ByVal bytesSent As Long, ByVal bytesRemaining As Long)
    TXTState.Text = Remote.State
End Sub


Private Function GetStateName(pState As Long) As String
    'sckClosed 0
    'sckOpen 1
    'sckListening 2
    'sckConnectionPending 3
    'sckResolvingHost 4
    'sckHostResolved 5
    'sckConnecting 6
    'sckConnected 7
    'sckClosing 8
    'sckError 9
    Select Case pState
        Case 0
            GetStateName = "Default.Closed"
        Case 1
            GetStateName = "Open"
        Case 2
            GetStateName = "Listening"
        Case 3
            GetStateName = "Connection pending"
        Case 4
            GetStateName = "Resolving host"
        Case 5
            GetStateName = "Host resolved"
        Case 6
            GetStateName = "Connecting"
        Case 7
            GetStateName = "Connected"
        Case 8
            GetStateName = "Peer is closing the connection"
        Case 9
            GetStateName = "Error"
    End Select
End Function


