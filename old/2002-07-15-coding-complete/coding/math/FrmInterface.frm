VERSION 5.00
Begin VB.Form FrmInterface 
   Caption         =   "Interface"
   ClientHeight    =   5430
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7470
   LinkTopic       =   "Form1"
   ScaleHeight     =   5430
   ScaleWidth      =   7470
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox TxtAnswer 
      Height          =   375
      Index           =   0
      Left            =   4320
      TabIndex        =   1
      Top             =   120
      Width           =   3015
   End
   Begin VB.Label LblQuestion 
      Caption         =   "Label1"
      Height          =   495
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4095
   End
End
Attribute VB_Name = "FrmInterface"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private VarNames(100) As String


Private Sub Form_Load()
    Dim Question As String
    Dim VarName As String
    Dim i As Long
    ' Read interface
    i = 1
    If (Interface.GetQuestion(Question, VarName) = True) Then
        LblQuestion(0).Caption = Question
        VarNames(0) = VarName
    
        Do While (Interface.GetQuestion(Question, VarName) = True)
            Load LblQuestion(i)
            Load TxtAnswer(i)
            LblQuestion(i).Caption = Question
            VarNames(i) = VarName
            LblQuestion(i).Top = LblQuestion(i - 1).Top + LblQuestion(i - 1).Height + 100
            LblQuestion(i).Left = LblQuestion(i - 1).Left
            LblQuestion(i).Visible = True
            
            TxtAnswer(i).Top = TxtAnswer(i - 1).Top + TxtAnswer(i - 1).Height + 100
            TxtAnswer(i).Left = TxtAnswer(i - 1).Left
            TxtAnswer(i).Visible = True
            i = i + 1
        Loop
    End If
End Sub
