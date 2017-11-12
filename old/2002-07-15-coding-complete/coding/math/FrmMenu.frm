VERSION 5.00
Begin VB.Form FrmMenu 
   Caption         =   "Menu"
   ClientHeight    =   2415
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5955
   LinkTopic       =   "Form1"
   ScaleHeight     =   2415
   ScaleWidth      =   5955
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdExit 
      Caption         =   "Exit"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   4560
      TabIndex        =   2
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CommandButton CmdAllocate 
      Caption         =   "Allocate"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1440
      TabIndex        =   1
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CommandButton CmdNewJob 
      Caption         =   "New job"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   0
      TabIndex        =   0
      Top             =   1560
      Width           =   1335
   End
End
Attribute VB_Name = "FrmMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdAllocate_Click()
    Call FrmStatus.Show(1)
End Sub

Private Sub CmdExit_Click()
    Call Unload(Me)
End Sub

Private Sub CmdNewJob_Click()
    Call FrmEditJob.Show(1)
End Sub

Private Sub Form_Load()
    Set db = DBEngine.OpenDatabase("\\ntserver2\c\jobDB.mdb", False, False)
End Sub
