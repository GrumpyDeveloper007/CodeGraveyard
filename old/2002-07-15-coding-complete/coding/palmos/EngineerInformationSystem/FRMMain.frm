VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{447880A9-6A37-43B3-A92E-F125FFBE2493}#2.0#0"; "IngotGridCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMMain 
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
   Begin IngotButtonCtl.AFButton CMDEngineer 
      Height          =   240
      Left            =   1560
      OleObjectBlob   =   "FRMMain.frx":0000
      TabIndex        =   8
      Top             =   2160
      Width           =   300
   End
   Begin IngotButtonCtl.AFButton CMDSummary 
      Height          =   240
      Left            =   720
      OleObjectBlob   =   "FRMMain.frx":0046
      TabIndex        =   7
      Top             =   2160
      Width           =   735
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMMain.frx":0092
      TabIndex        =   6
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDEdit 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":00DB
      TabIndex        =   5
      Top             =   2160
      Width           =   615
   End
   Begin IngotGridCtl.AFGrid GRDJobs 
      Height          =   1095
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":0128
      TabIndex        =   4
      Top             =   600
      Width           =   2055
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDate 
      Height          =   195
      Left            =   720
      OleObjectBlob   =   "FRMMain.frx":016E
      TabIndex        =   3
      Top             =   300
      Width           =   855
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   1
      Left            =   120
      OleObjectBlob   =   "FRMMain.frx":01C6
      TabIndex        =   2
      Top             =   300
      Width           =   555
   End
   Begin IngotComboBoxCtl.AFComboBox CBOEngineer 
      Height          =   240
      Left            =   720
      OleObjectBlob   =   "FRMMain.frx":020B
      TabIndex        =   1
      Top             =   60
      Width           =   1215
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   0
      Left            =   120
      OleObjectBlob   =   "FRMMain.frx":0250
      TabIndex        =   0
      Top             =   60
      Width           =   555
   End
End
Attribute VB_Name = "FRMMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDEdit_Click()
    Call FRMEditJob.Show
End Sub

Private Sub CMDEngineer_Click()
    Call FRMEditEngineer.Show
End Sub

Private Sub CMDExit_Click()
    End
End Sub

Private Sub CMDSummary_Click()
    Call FRMSummary.Show
End Sub
