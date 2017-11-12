VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form FRMResizer 
   Caption         =   "Form1"
   ClientHeight    =   8325
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10770
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   555
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   718
   Begin VB.PictureBox Pic2 
      AutoRedraw      =   -1  'True
      Height          =   9000
      Left            =   2640
      ScaleHeight     =   596
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   796
      TabIndex        =   2
      Top             =   240
      Width           =   12000
   End
   Begin VB.CommandButton CMDBMPResize 
      Caption         =   "BMP resize"
      Height          =   375
      Left            =   240
      TabIndex        =   1
      Top             =   2460
      Width           =   1695
   End
   Begin VB.PictureBox Pic1 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      Height          =   3060
      Left            =   360
      ScaleHeight     =   200
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   200
      TabIndex        =   0
      Top             =   3540
      Width           =   3060
   End
   Begin MSComDlg.CommonDialog FileAccess 
      Left            =   1800
      Top             =   180
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      FileName        =   "*.vbp"
      Filter          =   "Project Files (*.*)"
   End
End
Attribute VB_Name = "FRMResizer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDBMPResize_Click()
    Dim x As Long, y As Long
'    FileAccess.InitDir = App.Path
    FileAccess.FileName = "*.*"
    FileAccess.Filter = "*.*"
    FileAccess.ShowOpen
    If (FileAccess.FileName <> "*.*") Then
        Pic1.Picture = LoadPicture(FileAccess.FileName)
        For x = 0 To 800
            For y = 0 To 600
                Pic2.PSet (x, y), Pic1.Point(x Mod Pic1.ScaleWidth, y Mod Pic1.ScaleHeight)
            Next
        Next
        Call SavePicture(Pic2.Image, Left$(FileAccess.FileName, Len(FileAccess.FileName) - 4) & "800x600.bmp")
    End If
End Sub
