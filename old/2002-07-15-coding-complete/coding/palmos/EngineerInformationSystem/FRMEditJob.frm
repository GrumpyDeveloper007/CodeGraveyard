VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{899CE9D8-3C9F-48DF-B418-E338294B00E3}#2.0#0"; "IngotCheckBoxCtl.dll"
Begin VB.Form FRMEditJob 
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
   Begin IngotTextBoxCtl.AFTextBox TXTComments 
      Height          =   195
      Left            =   720
      OleObjectBlob   =   "FRMEditJob.frx":0000
      TabIndex        =   18
      Top             =   1920
      Width           =   1575
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   7
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":0058
      TabIndex        =   17
      Top             =   1920
      Width           =   735
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMEditJob.frx":00A1
      TabIndex        =   16
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDUpdate 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":00EA
      TabIndex        =   15
      Top             =   2160
      Width           =   615
   End
   Begin IngotTextBoxCtl.AFTextBox TXTActual 
      Height          =   195
      Left            =   600
      OleObjectBlob   =   "FRMEditJob.frx":0135
      TabIndex        =   14
      Top             =   1680
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   6
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":018D
      TabIndex        =   13
      Top             =   1680
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTExpected 
      Height          =   195
      Left            =   600
      OleObjectBlob   =   "FRMEditJob.frx":01D4
      TabIndex        =   12
      Top             =   1440
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":022C
      TabIndex        =   11
      Top             =   1440
      Width           =   735
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCheque 
      Height          =   195
      Left            =   480
      OleObjectBlob   =   "FRMEditJob.frx":0275
      TabIndex        =   10
      Top             =   720
      Width           =   1215
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCash 
      Height          =   195
      Left            =   480
      OleObjectBlob   =   "FRMEditJob.frx":02CD
      TabIndex        =   9
      Top             =   480
      Width           =   1215
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   4
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":0325
      TabIndex        =   8
      Top             =   720
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":036C
      TabIndex        =   7
      Top             =   480
      Width           =   435
   End
   Begin IngotComboBoxCtl.AFComboBox CBOActionCode 
      Height          =   240
      Left            =   720
      OleObjectBlob   =   "FRMEditJob.frx":03B1
      TabIndex        =   6
      Top             =   1200
      Width           =   1575
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":03F6
      TabIndex        =   5
      Top             =   1200
      Width           =   675
   End
   Begin IngotCheckBoxCtl.AFCheckBox AFCheckBox1 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":0440
      TabIndex        =   4
      Top             =   960
      Width           =   855
   End
   Begin IngotCheckBoxCtl.AFCheckBox CHKFTF 
      Height          =   195
      Left            =   1080
      OleObjectBlob   =   "FRMEditJob.frx":0492
      TabIndex        =   3
      Top             =   240
      Width           =   495
   End
   Begin IngotCheckBoxCtl.AFCheckBox CHKTimedCall 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":04DF
      TabIndex        =   2
      Top             =   240
      Width           =   975
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   1
      Left            =   1680
      OleObjectBlob   =   "FRMEditJob.frx":0533
      TabIndex        =   1
      Top             =   0
      Width           =   675
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMEditJob.frx":057D
      TabIndex        =   0
      Top             =   0
      Width           =   555
   End
End
Attribute VB_Name = "FRMEditJob"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDExit_Click()
    Me.Hide
    FRMMain.Show
End Sub
