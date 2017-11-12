VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TXTBOX.OCX"
Begin VB.Form FRMOptions 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Options"
   ClientHeight    =   4530
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5835
   HelpContextID   =   1
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4530
   ScaleWidth      =   5835
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   4680
      TabIndex        =   16
      Top             =   4080
      Width           =   1095
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   0
      TabIndex        =   17
      Top             =   4140
      Width           =   1095
   End
   Begin VB.ComboBox CBOPort 
      Height          =   315
      Left            =   1920
      Style           =   2  'Dropdown List
      TabIndex        =   12
      Top             =   120
      Width           =   1455
   End
   Begin VB.ComboBox CBOPhoneSystem 
      Height          =   315
      Left            =   1920
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   3120
      Width           =   2775
   End
   Begin VB.ComboBox CBOFlowControl 
      Height          =   315
      Left            =   1920
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   2520
      Width           =   1455
   End
   Begin VB.ComboBox CBOStopBits 
      Height          =   315
      Left            =   1920
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   2040
      Width           =   1455
   End
   Begin VB.ComboBox CBOParity 
      Height          =   315
      Left            =   1920
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   1560
      Width           =   1455
   End
   Begin VB.ComboBox CBODataBits 
      Height          =   315
      Left            =   1920
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   1080
      Width           =   1455
   End
   Begin VB.ComboBox CBOLineSpeed 
      Height          =   315
      Left            =   1920
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   600
      Width           =   1455
   End
   Begin ELFTxtBox.TxtBox1 TXTRemoteAddress 
      Height          =   285
      Left            =   1920
      TabIndex        =   15
      Top             =   3600
      Visible         =   0   'False
      Width           =   2175
      _ExtentX        =   3836
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
      Text            =   ""
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Remote Address"
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
      Index           =   7
      Left            =   240
      TabIndex        =   14
      Top             =   3630
      Visible         =   0   'False
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Port"
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
      Index           =   6
      Left            =   480
      TabIndex        =   13
      Top             =   150
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Phone System"
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
      Index           =   5
      Left            =   480
      TabIndex        =   10
      Top             =   3150
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Flow Control"
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
      Index           =   4
      Left            =   480
      TabIndex        =   8
      Top             =   2550
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Stop Bits"
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
      Index           =   3
      Left            =   480
      TabIndex        =   6
      Top             =   2070
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Parity"
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
      Index           =   2
      Left            =   480
      TabIndex        =   4
      Top             =   1590
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Data Bits"
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
      Left            =   480
      TabIndex        =   2
      Top             =   1110
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Line Speed"
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
      Left            =   480
      TabIndex        =   0
      Top             =   630
      Width           =   1335
   End
End
Attribute VB_Name = "FRMOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Options Object
''
'' Coded by Dale Pitman
Private vPhoneSystem As String

Private vIsLoaded As Boolean

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

''
Public Property Get PhoneSystem() As String
    PhoneSystem = vPhoneSystem
End Property

''
Private Sub CMDok_Click()
    Call SetServerSetting("PORT", CBOPort.Text)
    Call SetServerSetting("LINESPEED", CBOLineSpeed.Text)
    Call SetServerSetting("DATABITS", CBODataBits.Text)
    Call SetServerSetting("PARITY", CBOParity.Text)
    Call SetServerSetting("STOPBITS", CBOStopBits.Text)
    Call SetServerSetting("FLOWCONTROL", CBOFlowControl.Text)

    Call SetServerSetting("PHONESYSTEM", CBOPhoneSystem.Text)
    Call SetServerSetting("REMOTEHOST", TXTRemoteAddress.Text)
    
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub Form_Load()
    vIsLoaded = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)

    ' Port
    Call CBOPort.AddItem("COM1")
    Call CBOPort.AddItem("COM2")
    
    ' Port Speeds
    Call CBOLineSpeed.AddItem("1200")
    Call CBOLineSpeed.AddItem("2400")
    Call CBOLineSpeed.AddItem("4800")
    Call CBOLineSpeed.AddItem("9600")
    Call CBOLineSpeed.AddItem("19200")
    Call CBOLineSpeed.AddItem("38400")
    Call CBOLineSpeed.AddItem("57600")
    
    ' Data bits
    Call CBODataBits.AddItem("4")
    Call CBODataBits.AddItem("5")
    Call CBODataBits.AddItem("6")
    Call CBODataBits.AddItem("7")
    Call CBODataBits.AddItem("8")
    
    ' Parity
    Call CBOParity.AddItem("Even")
    Call CBOParity.AddItem("Odd")
    Call CBOParity.AddItem("None")
    Call CBOParity.AddItem("Mark")
    Call CBOParity.AddItem("Space")
    
    ' Stop Bits
    Call CBOStopBits.AddItem("1")
    Call CBOStopBits.AddItem("1.5")
    Call CBOStopBits.AddItem("2")
    
    ' Flow Control
    Call CBOFlowControl.AddItem("Xon / Xoff")
    Call CBOFlowControl.AddItem("Hardware")
    Call CBOFlowControl.AddItem("None")

    ' Phone System
    Call CBOPhoneSystem.AddItem("PANASONIC_KXTD")
    
    Call SetByItemCBO(CBOPort, GetServerSetting("PORT"))
    Call SetByItemCBO(CBOLineSpeed, GetServerSetting("LINESPEED"))
    Call SetByItemCBO(CBODataBits, GetServerSetting("DATABITS"))
    Call SetByItemCBO(CBOParity, GetServerSetting("PARITY"))
    Call SetByItemCBO(CBOStopBits, GetServerSetting("STOPBITS"))
    Call SetByItemCBO(CBOFlowControl, GetServerSetting("FLOWCONTROL"))

    Call SetByItemCBO(CBOPhoneSystem, GetServerSetting("PHONESYSTEM"))
End Sub

''
Public Sub LoadSettings()
    vPhoneSystem = GetServerSetting("PHONESYSTEM")
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
End Sub

