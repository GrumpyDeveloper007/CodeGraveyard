VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{C4C9371C-9674-41BC-8457-C81D40452EF3}#2.0#0"; "IngotRadioButtonCtl.dll"
Object = "{54171E73-16D6-4021-A96E-E59C0FE780E9}#2.0#0"; "IngotShapeCtl.dll"
Begin VB.Form FRMInspectionPage1 
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
   Begin IngotShapeCtl.AFShape SHAPE 
      Height          =   30
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage1.frx":0000
      TabIndex        =   18
      Top             =   195
      Width           =   2400
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage1.frx":0039
      TabIndex        =   17
      Top             =   1170
      Width           =   360
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCondition 
      Height          =   195
      Index           =   4
      Left            =   750
      OleObjectBlob   =   "FRMInspectionPage1.frx":007F
      TabIndex        =   16
      Top             =   1140
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTSpare 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMInspectionPage1.frx":00D7
      TabIndex        =   15
      Top             =   1140
      Width           =   375
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTWheelAlignment 
      Height          =   180
      Index           =   1
      Left            =   480
      OleObjectBlob   =   "FRMInspectionPage1.frx":012F
      TabIndex        =   14
      Top             =   1680
      Width           =   765
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTWheelAlignment 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage1.frx":0178
      TabIndex        =   13
      Top             =   1680
      Width           =   405
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   7
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage1.frx":01BA
      TabIndex        =   12
      Top             =   1500
      Width           =   1320
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage1.frx":020E
      TabIndex        =   11
      Top             =   960
      Width           =   360
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   4
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage1.frx":0252
      TabIndex        =   10
      Top             =   720
      Width           =   360
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage1.frx":0296
      TabIndex        =   9
      Top             =   510
      Width           =   360
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCondition 
      Height          =   195
      Index           =   3
      Left            =   750
      OleObjectBlob   =   "FRMInspectionPage1.frx":02DA
      TabIndex        =   8
      Top             =   930
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTOSR 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMInspectionPage1.frx":0332
      TabIndex        =   7
      Top             =   930
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCondition 
      Height          =   195
      Index           =   2
      Left            =   750
      OleObjectBlob   =   "FRMInspectionPage1.frx":038A
      TabIndex        =   6
      Top             =   720
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTNSR 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMInspectionPage1.frx":03E2
      TabIndex        =   5
      Top             =   720
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCondition 
      Height          =   195
      Index           =   1
      Left            =   750
      OleObjectBlob   =   "FRMInspectionPage1.frx":043A
      TabIndex        =   4
      Top             =   510
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTOSF 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMInspectionPage1.frx":0492
      TabIndex        =   3
      Top             =   510
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCondition 
      Height          =   195
      Index           =   0
      Left            =   750
      OleObjectBlob   =   "FRMInspectionPage1.frx":04EA
      TabIndex        =   2
      Top             =   300
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTNSF 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMInspectionPage1.frx":0542
      TabIndex        =   1
      Top             =   300
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPage1.frx":059A
      TabIndex        =   0
      Top             =   300
      Width           =   360
   End
End
Attribute VB_Name = "FRMInspectionPage1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

