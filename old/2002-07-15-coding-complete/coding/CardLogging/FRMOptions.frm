VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Begin VB.Form FRMOptions 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Options"
   ClientHeight    =   7185
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10005
   ControlBox      =   0   'False
   HelpContextID   =   1
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7185
   ScaleWidth      =   10005
   Begin VB.Frame FRAEndLog 
      Caption         =   "End Log Event"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1035
      Left            =   4800
      TabIndex        =   7
      Top             =   420
      Width           =   2415
      Begin ELFTxtBox.TxtBox1 TXTEndEventType 
         Height          =   315
         Left            =   1680
         TabIndex        =   8
         Top             =   180
         Width           =   615
         _ExtentX        =   1085
         _ExtentY        =   556
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
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTEndEventSubType 
         Height          =   315
         Left            =   1680
         TabIndex        =   10
         Top             =   600
         Width           =   615
         _ExtentX        =   1085
         _ExtentY        =   556
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
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Event Sub Type"
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
         Left            =   120
         TabIndex        =   11
         Top             =   630
         Width           =   1455
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Event Type"
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
         Left            =   360
         TabIndex        =   9
         Top             =   210
         Width           =   1215
      End
   End
   Begin VB.Frame FRAStartLog 
      Caption         =   "Start Log Event"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1035
      Left            =   2160
      TabIndex        =   2
      Top             =   420
      Width           =   2415
      Begin ELFTxtBox.TxtBox1 TXTStartEventType 
         Height          =   315
         Left            =   1680
         TabIndex        =   3
         Top             =   180
         Width           =   615
         _ExtentX        =   1085
         _ExtentY        =   556
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
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTStartEventSubType 
         Height          =   315
         Left            =   1680
         TabIndex        =   5
         Top             =   600
         Width           =   615
         _ExtentX        =   1085
         _ExtentY        =   556
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
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Event Sub Type"
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
         Left            =   120
         TabIndex        =   6
         Top             =   630
         Width           =   1455
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Event Type"
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
         Left            =   360
         TabIndex        =   4
         Top             =   210
         Width           =   1215
      End
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   6780
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   8880
      TabIndex        =   1
      Top             =   6780
      Width           =   1095
   End
End
Attribute VB_Name = "FRMOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' System Details Object
''
'' Coded by Dale Pitman

Private vIsLoaded As Boolean


Private vStartEventType As String
Private vStartEventSubType As String

Private vEndEventType As String
Private vEndEventSubType As String

Public Property Get StartEventType() As String
    StartEventType = vStartEventType
End Property

Public Property Get StartEventSubType() As String
    StartEventSubType = vStartEventSubType
End Property

Public Property Get EndEventType() As String
    EndEventType = vEndEventType
End Property

Public Property Get EndEventSubType() As String
    EndEventSubType = vEndEventSubType
End Property


''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

''
Private Sub CMDOK_Click()
    Dim rstemp As Recordset
    Dim i As Long
        
    Call SetServerSetting("STARTEVENTTYPE", TXTStartEventType.Text)
    Call SetServerSetting("STARTEVENTSUBTYPE", TXTStartEventSubType.Text)

    Call SetServerSetting("ENDEVENTTYPE", TXTEndEventType.Text)
    Call SetServerSetting("ENDEVENTSUBTYPE", TXTEndEventSubType.Text)
        
    vStartEventType = TXTStartEventType.Text
    vStartEventSubType = TXTStartEventSubType.Text

    vEndEventType = TXTEndEventType.Text
    vEndEventSubType = TXTEndEventSubType.Text
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub Form_Load()
    Dim DefaultDisclaimerID As Long
    Dim rstemp As Recordset
    Dim i As Long
    vIsLoaded = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)

    TXTStartEventType.Text = GetServerSetting("STARTEVENTTYPE", False)
    TXTStartEventSubType.Text = GetServerSetting("STARTEVENTSUBTYPE", False)

    TXTEndEventType.Text = GetServerSetting("ENDEVENTTYPE", False)
    TXTEndEventSubType.Text = GetServerSetting("ENDEVENTSUBTYPE", False)
End Sub

''
Public Sub LoadSettings()
    Dim DefaultDisclaimerID As Long
    Dim rstemp As Recordset
    Dim i As Long
    
    vStartEventType = GetServerSetting("STARTEVENTTYPE", False)
    vStartEventSubType = GetServerSetting("STARTEVENTSUBTYPE", False)

    vEndEventType = GetServerSetting("ENDEVENTTYPE", False)
    vEndEventSubType = GetServerSetting("ENDEVENTSUBTYPE", False)
   
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
End Sub


