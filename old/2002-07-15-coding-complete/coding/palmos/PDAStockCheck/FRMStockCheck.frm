VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMStockCheck 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   2400
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2400
   BeginProperty Font 
      Name            =   "AFPalm"
      Size            =   9
      Charset         =   2
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   160
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   160
   StartUpPosition =   2  'CenterScreen
   Begin IngotButtonCtl.AFButton CMDRightLocation 
      Height          =   210
      Left            =   1080
      OleObjectBlob   =   "FRMStockCheck.frx":0000
      TabIndex        =   32
      Top             =   0
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDLeftLocation 
      Height          =   210
      Left            =   840
      OleObjectBlob   =   "FRMStockCheck.frx":0046
      TabIndex        =   31
      Top             =   0
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDRightPartNumber 
      Height          =   210
      Left            =   1080
      OleObjectBlob   =   "FRMStockCheck.frx":008C
      TabIndex        =   30
      Top             =   420
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDLeftPartNumber 
      Height          =   210
      Left            =   840
      OleObjectBlob   =   "FRMStockCheck.frx":00D2
      TabIndex        =   29
      Top             =   420
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDRightQty 
      Height          =   210
      Left            =   1080
      OleObjectBlob   =   "FRMStockCheck.frx":0118
      TabIndex        =   28
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDLeftQty 
      Height          =   210
      Left            =   840
      OleObjectBlob   =   "FRMStockCheck.frx":015E
      TabIndex        =   27
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":01A4
      TabIndex        =   26
      Top             =   2160
      Visible         =   0   'False
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   255
      Left            =   1890
      OleObjectBlob   =   "FRMStockCheck.frx":01EB
      TabIndex        =   25
      Top             =   2160
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   10
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":0236
      TabIndex        =   24
      Top             =   1920
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   9
      Left            =   2160
      OleObjectBlob   =   "FRMStockCheck.frx":027D
      TabIndex        =   23
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   8
      Left            =   1920
      OleObjectBlob   =   "FRMStockCheck.frx":02C3
      TabIndex        =   22
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   7
      Left            =   1680
      OleObjectBlob   =   "FRMStockCheck.frx":0309
      TabIndex        =   21
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   6
      Left            =   1440
      OleObjectBlob   =   "FRMStockCheck.frx":034F
      TabIndex        =   20
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   5
      Left            =   1200
      OleObjectBlob   =   "FRMStockCheck.frx":0395
      TabIndex        =   19
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   4
      Left            =   960
      OleObjectBlob   =   "FRMStockCheck.frx":03DB
      TabIndex        =   18
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   3
      Left            =   720
      OleObjectBlob   =   "FRMStockCheck.frx":0421
      TabIndex        =   17
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   2
      Left            =   480
      OleObjectBlob   =   "FRMStockCheck.frx":0467
      TabIndex        =   16
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   1
      Left            =   240
      OleObjectBlob   =   "FRMStockCheck.frx":04AD
      TabIndex        =   15
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":04F3
      TabIndex        =   14
      Top             =   1680
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   20
      Left            =   240
      OleObjectBlob   =   "FRMStockCheck.frx":0539
      TabIndex        =   13
      Top             =   1920
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   21
      Left            =   480
      OleObjectBlob   =   "FRMStockCheck.frx":0580
      TabIndex        =   12
      Top             =   1920
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   22
      Left            =   720
      OleObjectBlob   =   "FRMStockCheck.frx":05C7
      TabIndex        =   11
      Top             =   1920
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   23
      Left            =   960
      OleObjectBlob   =   "FRMStockCheck.frx":060E
      TabIndex        =   10
      Top             =   1920
      Width           =   225
   End
   Begin IngotTextBoxCtl.AFTextBox TXTOldQty 
      Height          =   195
      Left            =   2040
      OleObjectBlob   =   "FRMStockCheck.frx":0655
      TabIndex        =   9
      Top             =   1260
      Width           =   360
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   4
      Left            =   1440
      OleObjectBlob   =   "FRMStockCheck.frx":06AD
      TabIndex        =   8
      Top             =   1260
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTQTY 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMStockCheck.frx":06F5
      TabIndex        =   7
      Top             =   1260
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":074D
      TabIndex        =   6
      Top             =   1260
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDescription 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":0791
      TabIndex        =   5
      Top             =   1020
      Width           =   2400
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":07E9
      TabIndex        =   4
      Top             =   840
      Width           =   735
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPartNumber 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":0835
      TabIndex        =   3
      Top             =   600
      Width           =   2400
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":088D
      TabIndex        =   2
      Top             =   420
      Width           =   855
   End
   Begin IngotTextBoxCtl.AFTextBox TXTLocation 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":08D9
      TabIndex        =   1
      Top             =   180
      Width           =   2400
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   135
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMStockCheck.frx":0931
      TabIndex        =   0
      Top             =   0
      Width           =   735
   End
End
Attribute VB_Name = "FRMStockCheck"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDCancel_Click()
    Me.Hide
    FRMMain.Show
End Sub

Private Sub CMDLeftQty_Click()
    On Error GoTo defaulterror
    If (CLng(TXTQTY.Text) > 0) Then
        TXTQTY.Text = CLng(TXTQTY.Text) - 1
    End If
    Exit Sub
defaulterror:
    TXTQTY.Text = 0
End Sub

Private Sub CMDNumbers_Click(Index As Integer)
    TXTQTY.Text = CMDNumbers(Index).Caption
End Sub

Private Sub CMDRightQty_Click()
    On Error GoTo defaulterror
    TXTQTY.Text = CLng(TXTQTY.Text) + 1
    Exit Sub
defaulterror:
    TXTQTY.Text = 1
End Sub
