VERSION 5.00
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
   Begin VB.TextBox Text2 
      Height          =   690
      Left            =   1245
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   1875
      Width           =   1905
   End
   Begin VB.TextBox Text1 
      Height          =   780
      Left            =   1455
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   660
      Width           =   1695
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim a As New Project1.Class1
    Dim b As New Project1.Class2
    Text1.Text = a.Test1
    Text2.Text = b.Test2(1, "ttt")
End Sub
