VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMSummary 
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
      Height          =   210
      Index           =   13
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":0000
      TabIndex        =   29
      Top             =   1920
      Width           =   570
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPassword 
      Height          =   195
      Left            =   645
      OleObjectBlob   =   "FRMSummary.frx":0049
      TabIndex        =   28
      Top             =   1920
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTNoLabour 
      Height          =   195
      Left            =   2145
      OleObjectBlob   =   "FRMSummary.frx":00A1
      TabIndex        =   26
      Top             =   900
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPartsOrders 
      Height          =   195
      Left            =   2145
      OleObjectBlob   =   "FRMSummary.frx":00F9
      TabIndex        =   24
      Top             =   1140
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   12
      Left            =   1335
      OleObjectBlob   =   "FRMSummary.frx":0151
      TabIndex        =   27
      Top             =   900
      Width           =   630
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   11
      Left            =   1335
      OleObjectBlob   =   "FRMSummary.frx":019B
      TabIndex        =   25
      Top             =   1140
      Width           =   795
   End
   Begin IngotTextBoxCtl.AFTextBox TXTFirstTimeFix 
      Height          =   195
      Left            =   975
      OleObjectBlob   =   "FRMSummary.frx":01E8
      TabIndex        =   22
      Top             =   1290
      Width           =   240
   End
   Begin IngotTextBoxCtl.AFTextBox TXTEstimates 
      Height          =   195
      Left            =   975
      OleObjectBlob   =   "FRMSummary.frx":0240
      TabIndex        =   20
      Top             =   1500
      Width           =   240
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMSummary.frx":0298
      TabIndex        =   5
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDEdit 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":02E1
      TabIndex        =   4
      Top             =   2160
      Width           =   615
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   10
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":032A
      TabIndex        =   23
      Top             =   1290
      Width           =   825
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   9
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":0379
      TabIndex        =   21
      Top             =   1500
      Width           =   600
   End
   Begin IngotTextBoxCtl.AFTextBox TXTExpected 
      Height          =   195
      Left            =   1560
      OleObjectBlob   =   "FRMSummary.frx":03C3
      TabIndex        =   18
      Top             =   0
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTActual 
      Height          =   195
      Left            =   1560
      OleObjectBlob   =   "FRMSummary.frx":041B
      TabIndex        =   16
      Top             =   210
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   8
      Left            =   960
      OleObjectBlob   =   "FRMSummary.frx":0473
      TabIndex        =   19
      Top             =   0
      Width           =   570
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   7
      Left            =   960
      OleObjectBlob   =   "FRMSummary.frx":04BC
      TabIndex        =   17
      Top             =   210
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTMiles 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMSummary.frx":0503
      TabIndex        =   14
      Top             =   0
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTNAH 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMSummary.frx":055B
      TabIndex        =   12
      Top             =   210
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   6
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":05B3
      TabIndex        =   15
      Top             =   0
      Width           =   315
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   4
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":05F9
      TabIndex        =   13
      Top             =   210
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTIssuedJobs 
      Height          =   195
      Left            =   975
      OleObjectBlob   =   "FRMSummary.frx":063D
      TabIndex        =   10
      Top             =   870
      Width           =   240
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCompletedJobs 
      Height          =   195
      Left            =   975
      OleObjectBlob   =   "FRMSummary.frx":0695
      TabIndex        =   8
      Top             =   1080
      Width           =   240
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":06ED
      TabIndex        =   11
      Top             =   870
      Width           =   675
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":0739
      TabIndex        =   9
      Top             =   1080
      Width           =   960
   End
   Begin IngotComboBoxCtl.AFComboBox CBOEngineer 
      Height          =   240
      Left            =   840
      OleObjectBlob   =   "FRMSummary.frx":0788
      TabIndex        =   7
      Top             =   1710
      Width           =   1335
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":07CD
      TabIndex        =   6
      Top             =   1710
      Width           =   735
   End
   Begin IngotTextBoxCtl.AFTextBox TXTTotalCheque 
      Height          =   195
      Left            =   840
      OleObjectBlob   =   "FRMSummary.frx":0819
      TabIndex        =   3
      Top             =   660
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":0871
      TabIndex        =   2
      Top             =   660
      Width           =   810
   End
   Begin IngotTextBoxCtl.AFTextBox TXTTotalCash 
      Height          =   195
      Left            =   840
      OleObjectBlob   =   "FRMSummary.frx":08BE
      TabIndex        =   1
      Top             =   450
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":0916
      TabIndex        =   0
      Top             =   450
      Width           =   645
   End
End
Attribute VB_Name = "FRMSummary"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDExit_Click()
    Me.Hide
    FRMMain.Show
End Sub
