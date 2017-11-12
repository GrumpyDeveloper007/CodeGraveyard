VERSION 5.00
Begin VB.Form FrmGFXView 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "GFX View"
   ClientHeight    =   10860
   ClientLeft      =   720
   ClientTop       =   1005
   ClientWidth     =   15210
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   724
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1014
   Begin VB.PictureBox PicTextPad 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      Height          =   735
      Left            =   1080
      ScaleHeight     =   45
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   445
      TabIndex        =   5
      Top             =   9240
      Visible         =   0   'False
      Width           =   6735
   End
   Begin VB.CommandButton Command1 
      Caption         =   "test"
      Height          =   495
      Left            =   4920
      TabIndex        =   4
      Top             =   10320
      Width           =   1095
   End
   Begin VB.CommandButton CMDSave 
      Caption         =   "Save"
      Height          =   495
      Left            =   1200
      TabIndex        =   3
      Top             =   10320
      Width           =   1095
   End
   Begin VB.CommandButton CMDPrintGFX 
      Caption         =   "Print"
      Height          =   495
      Left            =   0
      TabIndex        =   2
      Top             =   10320
      Width           =   1095
   End
   Begin VB.CommandButton CMDHideGFX 
      Caption         =   "Hide"
      Height          =   495
      Left            =   10080
      TabIndex        =   1
      Top             =   10320
      Width           =   1095
   End
   Begin VB.PictureBox PicConsole 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   10215
      HelpContextID   =   2
      Left            =   0
      ScaleHeight     =   677
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   1005
      TabIndex        =   0
      Top             =   0
      Width           =   15135
   End
End
Attribute VB_Name = "FrmGFXView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''

''
Private Sub CMDHideGFX_Click()
    Call Frmtest.Show
    Call Frmtest.ZOrder
End Sub

''
Private Sub CMDPrintGFX_Click()
    Call Interface.iPrintGFXToPrinter
End Sub

''
Private Sub CMDSave_Click()
'    FrmMain.FileAccess.InitDir = TargetPath
    FrmMain.FileAccess.Filter = "Bitmap Files (*.BMP)"
    FrmMain.FileAccess.FileName = "*.bmp"
    FrmMain.FileAccess.ShowSave
    If (FrmMain.FileAccess.FileName <> "*.bmp") Then
        Call SavePicture(PicConsole.Image, strings.CheckExtension(FrmMain.FileAccess.FileName, ".bmp"))
    End If
End Sub

Private Sub Command1_Click()
    Dim x1 As Double, y1 As Double
    Dim x2 As Double, y2 As Double
    Dim dx As Double, dy As Double
    Dim cx As Double, cy As Double
    Dim math As New MathClass
    Dim angle As Double
    Dim I As Long, T As Long
    x1 = 50
    y1 = 50
    For angle = 0 To 370
        FrmGFXView.PicConsole.Cls
        Call math.GetDxDy(cx, cy, angle, 100)
        FrmGFXView.PicConsole.Line (x1 * 2, 400 - y1 * 2)-((x1) * 2 + cx, 400 - (y1) * 2 + cy)
        x2 = math.GetAngle(cx, cy)
        I = angle
        T = x2
        If (I <> T) Then
            x1 = x1
        End If
        
'        Call math.GetDxDy(cx, cy, angle + 15, 10)
'        FrmGFXView.PicConsole.Line (x1 * 2, 400 - y1 * 2)-((x1) * 2 + cx, 400 - (y1) * 2 + cy)
        DoEvents
    Next
End Sub

