VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Begin VB.Form FRMInspectionPage2 
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
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   7
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage2.frx":0000
      TabIndex        =   15
      Top             =   1710
      Width           =   600
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox2 
      Height          =   195
      Left            =   600
      OleObjectBlob   =   "FRMInspectionPage2.frx":004A
      TabIndex        =   14
      Top             =   1710
      Width           =   870
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   6
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage2.frx":00A2
      TabIndex        =   13
      Top             =   1500
      Width           =   840
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox1 
      Height          =   195
      Left            =   840
      OleObjectBlob   =   "FRMInspectionPage2.frx":00EE
      TabIndex        =   12
      Top             =   1500
      Width           =   870
   End
   Begin IngotTextBoxCtl.AFTextBox TXTModel 
      Height          =   195
      Left            =   480
      OleObjectBlob   =   "FRMInspectionPage2.frx":0146
      TabIndex        =   10
      Top             =   1080
      Width           =   1455
   End
   Begin IngotTextBoxCtl.AFTextBox TXTMake 
      Height          =   195
      Left            =   480
      OleObjectBlob   =   "FRMInspectionPage2.frx":019E
      TabIndex        =   8
      Top             =   870
      Width           =   1215
   End
   Begin IngotTextBoxCtl.AFTextBox TXTStreet 
      Height          =   195
      Left            =   480
      OleObjectBlob   =   "FRMInspectionPage2.frx":01F6
      TabIndex        =   6
      Top             =   660
      Width           =   1815
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDriverName 
      Height          =   195
      Left            =   840
      OleObjectBlob   =   "FRMInspectionPage2.frx":024E
      TabIndex        =   4
      Top             =   450
      Width           =   1455
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage2.frx":02A6
      TabIndex        =   3
      Top             =   240
      Width           =   705
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCompany 
      Height          =   195
      Left            =   720
      OleObjectBlob   =   "FRMInspectionPage2.frx":02EE
      TabIndex        =   2
      Top             =   240
      Width           =   1575
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage2.frx":0346
      TabIndex        =   1
      Top             =   1290
      Width           =   480
   End
   Begin IngotTextBoxCtl.AFTextBox TXTMileage 
      Height          =   195
      Left            =   600
      OleObjectBlob   =   "FRMInspectionPage2.frx":038E
      TabIndex        =   0
      Top             =   1290
      Width           =   870
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage2.frx":03E6
      TabIndex        =   5
      Top             =   450
      Width           =   945
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage2.frx":0432
      TabIndex        =   7
      Top             =   660
      Width           =   945
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   4
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage2.frx":0479
      TabIndex        =   9
      Top             =   870
      Width           =   945
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage2.frx":04BE
      TabIndex        =   11
      Top             =   1080
      Width           =   945
   End
End
Attribute VB_Name = "FRMInspectionPage2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

