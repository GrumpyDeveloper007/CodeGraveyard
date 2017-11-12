VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{447880A9-6A37-43B3-A92E-F125FFBE2493}#2.0#0"; "IngotGridCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{899CE9D8-3C9F-48DF-B418-E338294B00E3}#2.0#0"; "IngotCheckBoxCtl.dll"
Begin VB.Form FRMEditEngineer 
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
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMEditEngineer.frx":0000
      TabIndex        =   7
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDUpdate 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMEditEngineer.frx":0049
      TabIndex        =   6
      Top             =   2160
      Width           =   615
   End
   Begin IngotGridCtl.AFGrid GRDJobs 
      Height          =   675
      Left            =   0
      OleObjectBlob   =   "FRMEditEngineer.frx":0094
      TabIndex        =   5
      Top             =   1440
      Width           =   2055
   End
   Begin IngotCheckBoxCtl.AFCheckBox CHKTimedCall 
      Height          =   195
      Left            =   120
      OleObjectBlob   =   "FRMEditEngineer.frx":00DA
      TabIndex        =   4
      Top             =   540
      Width           =   1335
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox1 
      Height          =   195
      Left            =   720
      OleObjectBlob   =   "FRMEditEngineer.frx":0131
      TabIndex        =   2
      Top             =   300
      Width           =   1215
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMEditEngineer.frx":0189
      TabIndex        =   3
      Top             =   300
      Width           =   555
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   210
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMEditEngineer.frx":01CE
      TabIndex        =   1
      Top             =   0
      Width           =   315
   End
   Begin IngotTextBoxCtl.AFTextBox TXTMiles 
      Height          =   195
      Left            =   480
      OleObjectBlob   =   "FRMEditEngineer.frx":0212
      TabIndex        =   0
      Top             =   0
      Width           =   495
   End
End
Attribute VB_Name = "FRMEditEngineer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDExit_Click()
    Me.Hide
    FRMMain.Show
End Sub
