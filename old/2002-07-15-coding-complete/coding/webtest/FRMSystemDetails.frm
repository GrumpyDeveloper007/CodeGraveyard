VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Begin VB.Form FRMSystemDetails 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "System Details"
   ClientHeight    =   3360
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4860
   HelpContextID   =   7
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3360
   ScaleWidth      =   4860
   Begin VB.CommandButton CMDExit 
      Caption         =   "Exit"
      Height          =   375
      Left            =   3720
      TabIndex        =   10
      Top             =   2940
      Width           =   1095
   End
   Begin VB.CommandButton COMOK 
      Caption         =   "OK"
      Height          =   375
      Left            =   0
      TabIndex        =   9
      Top             =   2940
      Width           =   1095
   End
   Begin VB.CheckBox CHKEnableGBMailing 
      Caption         =   "Enable GBMailing"
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
      Left            =   480
      TabIndex        =   6
      Top             =   2040
      Width           =   2295
   End
   Begin ELFTxtBox.TxtBox1 TXTRexID 
      Height          =   285
      Left            =   2640
      TabIndex        =   0
      Top             =   120
      Width           =   975
      _ExtentX        =   1720
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
   Begin ELFTxtBox.TxtBox1 TXTDefaultHandlingValue 
      Height          =   285
      Left            =   2640
      TabIndex        =   2
      Top             =   1080
      Width           =   975
      _ExtentX        =   1720
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
   Begin ELFTxtBox.TxtBox1 TXTREXAccount 
      Height          =   285
      Left            =   2640
      TabIndex        =   4
      Top             =   480
      Visible         =   0   'False
      Width           =   975
      _ExtentX        =   1720
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
   Begin ELFTxtBox.TxtBox1 TXTBACSPath 
      Height          =   285
      Left            =   2640
      TabIndex        =   7
      Top             =   1500
      Width           =   1935
      _ExtentX        =   3413
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
      Caption         =   "BACS Path"
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
      TabIndex        =   8
      Top             =   1500
      Width           =   2055
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Rex Account"
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
      TabIndex        =   5
      Top             =   480
      Visible         =   0   'False
      Width           =   2055
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Default Handling Value "
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
      TabIndex        =   3
      Top             =   1080
      Width           =   2055
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Rex ID"
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
      Left            =   1200
      TabIndex        =   1
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "FRMSystemDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Create / Amend Models Object
''
'' Coded by Dale Pitman
Private vRexID As String

Private vIsLoaded As Boolean

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

Public Property Get RexID() As String
    RexID = vRexID
End Property

Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub COMOK_Click()
    Call SetServerSetting("REXID", TXTRexID.Text)
    vRexID = TXTRexID.Text
    Call SetServerSetting("REXACCOUNT", TXTREXAccount.Text)
    Call SetServerSetting("DEFAULT_HANDLING_VALUE", TXTDefaultHandlingValue.Text)
    Call SetServerSetting("BACS_PATH", TXTBACSPath.Text)
    Call SetServerSetting("ENABLE_GBMAILING", CHKEnableGBMailing.Value)
End Sub

Private Sub Form_Load()
    vIsLoaded = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)

    TXTRexID.Text = GetServerSetting("REXID")
    TXTREXAccount.Text = GetServerSetting("REXACCOUNT")
    TXTDefaultHandlingValue.Text = GetServerSetting("DEFAULT_HANDLING_VALUE")
    TXTBACSPath.Text = GetServerSetting("BACS_PATH")

    CHKEnableGBMailing.Value = Val(GetServerSetting("ENABLE_GBMAILING"))
End Sub

Public Sub LoadSettings()
    vRexID = GetServerSetting("REXID")
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
End Sub

