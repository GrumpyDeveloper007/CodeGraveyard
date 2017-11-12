VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.MDIForm MDIMain 
   BackColor       =   &H8000000C&
   Caption         =   "MDIForm1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   2  'CenterScreen
   WindowState     =   2  'Maximized
   Begin VB.PictureBox PICBackGround 
      Align           =   1  'Align Top
      Height          =   495
      Left            =   0
      ScaleHeight     =   435
      ScaleWidth      =   4620
      TabIndex        =   0
      Top             =   0
      Visible         =   0   'False
      Width           =   4680
   End
   Begin MSComDlg.CommonDialog CommonDialogControl 
      Left            =   960
      Top             =   1200
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
End
Attribute VB_Name = "MDIMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub MDIForm_Load()
    Call ConnectDatabase("StockSystem.mdb")
    Call LoadConstantData
    
    Call FrmProductEnquiry.Show
    Call FrmCreateProduct.Show
End Sub
