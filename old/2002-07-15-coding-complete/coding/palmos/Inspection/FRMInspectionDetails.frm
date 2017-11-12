VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{54171E73-16D6-4021-A96E-E59C0FE780E9}#2.0#0"; "IngotShapeCtl.dll"
Begin VB.Form FRMInspectionDetails 
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
   Begin IngotTextBoxCtl.AFTextBox AFTextBox5 
      Height          =   195
      Left            =   855
      OleObjectBlob   =   "FRMInspectionDetails.frx":0000
      TabIndex        =   17
      Top             =   1290
      Width           =   870
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox4 
      Height          =   195
      Left            =   855
      OleObjectBlob   =   "FRMInspectionDetails.frx":0058
      TabIndex        =   15
      Top             =   1080
      Width           =   870
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox3 
      Height          =   195
      Left            =   855
      OleObjectBlob   =   "FRMInspectionDetails.frx":00B0
      TabIndex        =   13
      Top             =   870
      Width           =   870
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox2 
      Height          =   195
      Left            =   855
      OleObjectBlob   =   "FRMInspectionDetails.frx":0108
      TabIndex        =   11
      Top             =   450
      Width           =   870
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox1 
      Height          =   195
      Left            =   855
      OleObjectBlob   =   "FRMInspectionDetails.frx":0160
      TabIndex        =   9
      Top             =   660
      Width           =   870
   End
   Begin IngotTextBoxCtl.AFTextBox TXTReg 
      Height          =   195
      Left            =   855
      OleObjectBlob   =   "FRMInspectionDetails.frx":01B8
      TabIndex        =   7
      Top             =   240
      Width           =   870
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMInspectionDetails.frx":0210
      TabIndex        =   18
      Top             =   1290
      Width           =   810
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   4
      Left            =   0
      OleObjectBlob   =   "FRMInspectionDetails.frx":0259
      TabIndex        =   16
      Top             =   1080
      Width           =   705
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMInspectionDetails.frx":02A5
      TabIndex        =   14
      Top             =   870
      Width           =   765
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMInspectionDetails.frx":02F4
      TabIndex        =   12
      Top             =   450
      Width           =   705
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspectionDetails.frx":0342
      TabIndex        =   10
      Top             =   660
      Width           =   780
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMInspectionDetails.frx":038E
      TabIndex        =   8
      Top             =   240
      Width           =   375
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMInspectionDetails.frx":03D6
      TabIndex        =   6
      Top             =   2160
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   2
      Left            =   1575
      OleObjectBlob   =   "FRMInspectionDetails.frx":041D
      TabIndex        =   5
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   1
      Left            =   1335
      OleObjectBlob   =   "FRMInspectionDetails.frx":0463
      TabIndex        =   4
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   0
      Left            =   1080
      OleObjectBlob   =   "FRMInspectionDetails.frx":04A9
      TabIndex        =   3
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDPageRight 
      Height          =   210
      Left            =   810
      OleObjectBlob   =   "FRMInspectionDetails.frx":04EF
      TabIndex        =   2
      Top             =   2190
      Visible         =   0   'False
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDPageLeft 
      Height          =   210
      Left            =   555
      OleObjectBlob   =   "FRMInspectionDetails.frx":0535
      TabIndex        =   1
      Top             =   2190
      Width           =   225
   End
   Begin IngotShapeCtl.AFShape SHAPE 
      Height          =   30
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspectionDetails.frx":057B
      TabIndex        =   0
      Top             =   195
      Width           =   2400
   End
End
Attribute VB_Name = "FRMInspectionDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

