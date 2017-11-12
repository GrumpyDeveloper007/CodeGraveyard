VERSION 5.00
Begin VB.Form FRMAbout 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "About"
   ClientHeight    =   3405
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7710
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3405
   ScaleWidth      =   7710
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   6600
      TabIndex        =   0
      Top             =   3000
      Width           =   1095
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "PhoneSystem"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   3
      Left            =   120
      TabIndex        =   4
      Top             =   60
      Width           =   7455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Email : PyroDesign@ntlworld.com"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   2
      Left            =   120
      TabIndex        =   3
      Top             =   1740
      Width           =   7455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "WEB Page : www.PyroDesign.co.uk"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   1320
      Width           =   7455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Designed And Written By PyroDesign"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   435
      Index           =   0
      Left            =   120
      TabIndex        =   1
      Top             =   780
      Width           =   7455
   End
End
Attribute VB_Name = "FRMAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
''  Object
''
'' Coded by Dale Pitman

'' Child objects

Private vIsLoaded As Boolean

Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)


End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)

End Sub
