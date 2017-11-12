VERSION 5.00
Begin VB.Form FrmProgramSelect 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Program selector"
   ClientHeight    =   2415
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   1830
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   2415
   ScaleWidth      =   1830
   Begin VB.CommandButton CmdCutDiagram 
      Caption         =   "Cut Diagram"
      Height          =   1455
      Left            =   0
      Picture         =   "FrmProgramSelect.frx":0000
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   0
      Width           =   1815
   End
End
Attribute VB_Name = "FrmProgramSelect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub ResetProgram()
    Call Syntax.SetProgram(FrmOptions.ProgramName)
    Call Interface.LoadInputs(FrmOptions.ProgramOptionName)
    Call Syntax.ResetProcessor
    Call FrmMain.Update
    Call Frmtest.Update
    Call Me.Hide
End Sub

Private Sub CmdCutDiagram_Click()
    FrmOptions.ProgramName = "Cut Diagram.Txt"
    Call ResetProgram
End Sub

Private Sub Form_Load()
    Call MDICenterScreen(Me)
End Sub
