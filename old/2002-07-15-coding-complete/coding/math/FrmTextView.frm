VERSION 5.00
Begin VB.Form FrmTextView 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Text View"
   ClientHeight    =   4845
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10875
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4845
   ScaleWidth      =   10875
   Begin VB.CommandButton CMDHide 
      Caption         =   "Hide"
      Height          =   495
      Left            =   9720
      TabIndex        =   2
      Top             =   4320
      Width           =   1095
   End
   Begin VB.CommandButton CmdPrintText 
      Caption         =   "Print Text"
      Height          =   495
      Left            =   0
      TabIndex        =   1
      Top             =   4320
      Width           =   1095
   End
   Begin VB.TextBox TxtPrinterWindow 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4170
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   120
      Width           =   10815
   End
End
Attribute VB_Name = "FrmTextView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDHide_Click()
    Call Frmtest.Show
    Call Frmtest.ZOrder
End Sub

Private Sub CmdPrintText_Click()
    Call Interface.iPrintTextToPrinter
End Sub
