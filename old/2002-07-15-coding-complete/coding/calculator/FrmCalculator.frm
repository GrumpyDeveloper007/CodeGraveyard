VERSION 5.00
Begin VB.Form FrmCalculator 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Calculator"
   ClientHeight    =   5805
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6090
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   387
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   406
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton CmdExit 
      Caption         =   "Exit"
      Height          =   495
      Left            =   4800
      TabIndex        =   13
      Top             =   5280
      Width           =   1215
   End
   Begin VB.TextBox TxtExpression 
      Height          =   375
      Left            =   1560
      TabIndex        =   0
      Text            =   "sin(x)*90"
      Top             =   120
      Width           =   3015
   End
   Begin VB.TextBox TxtResult 
      Height          =   375
      Left            =   1560
      TabIndex        =   6
      Top             =   720
      Width           =   3015
   End
   Begin VB.PictureBox PicGraph 
      AutoRedraw      =   -1  'True
      Height          =   3735
      Left            =   0
      ScaleHeight     =   245
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   397
      TabIndex        =   5
      Top             =   1440
      Width           =   6015
   End
   Begin VB.TextBox TxtYMax 
      Height          =   285
      Left            =   5280
      TabIndex        =   4
      Top             =   0
      Width           =   735
   End
   Begin VB.TextBox TxtYMin 
      Height          =   285
      Left            =   5280
      TabIndex        =   3
      Top             =   360
      Width           =   735
   End
   Begin VB.TextBox TxtXMax 
      Height          =   285
      Left            =   5280
      TabIndex        =   2
      Top             =   720
      Width           =   735
   End
   Begin VB.TextBox TxtXMin 
      Height          =   285
      Left            =   5280
      TabIndex        =   1
      Top             =   1080
      Width           =   735
   End
   Begin VB.Label Label1 
      Caption         =   "Y max -"
      Height          =   255
      Left            =   4680
      TabIndex        =   12
      Top             =   0
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "Y min -"
      Height          =   255
      Left            =   4680
      TabIndex        =   11
      Top             =   360
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "X max -"
      Height          =   255
      Left            =   4680
      TabIndex        =   10
      Top             =   720
      Width           =   615
   End
   Begin VB.Label Label4 
      Caption         =   "X min -"
      Height          =   255
      Left            =   4680
      TabIndex        =   9
      Top             =   1080
      Width           =   495
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      Caption         =   "Expression"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   0
      TabIndex        =   8
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Right Justify
      Caption         =   "Result"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   0
      TabIndex        =   7
      Top             =   720
      Width           =   1455
   End
End
Attribute VB_Name = "FrmCalculator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private YMax As Long
Private YMin As Long
Private XMax As Long
Private XMin As Long

Private Sub update()
    Call PicGraph.Cls
    Dim i As Long
    For i = 0 To XMax
        PicGraph.PSet (i, YMax), &H7F
    Next
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
Private Sub Command1_Click()
    Call Unload(Me)
End Sub

Private Sub CmdExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub Form_Load()
    YMax = PicGraph.Height / 2
    YMin = -PicGraph.Height / 2
    XMax = PicGraph.Width
    XMin = 0
    TxtYMax.Text = YMax
    TxtYMin.Text = YMin
    TxtXMax.Text = XMax
    TxtXMin.Text = XMin
End Sub

''
Private Sub TxtExpression_KeyPress(KeyAscii As Integer)
    Dim value As Double
    Dim i As Long
    If (KeyAscii = 13) Then
        TxtResult.Text = Format(Expression.Evaluate(TxtExpression.Text), "#######0.0000000")
        
        Call update
        If (IsNumeric(Expression.Evaluate(TxtExpression.Text))) Then
            For i = XMin To XMax
                value = Expression.Evaluate(TxtExpression.Text)
                Call Varibles.SetVarible("x", i)
                If (value < YMax And value > YMin) Then
                
                    PicGraph.PSet (i, YMax - value), &HFF00000
                End If
            Next
        End If
    End If
End Sub
