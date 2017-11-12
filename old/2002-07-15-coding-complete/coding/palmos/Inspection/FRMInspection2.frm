VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{54171E73-16D6-4021-A96E-E59C0FE780E9}#2.0#0"; "IngotShapeCtl.dll"
Begin VB.Form FRMInspection2 
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
      OleObjectBlob   =   "FRMInspection2.frx":0000
      TabIndex        =   5
      Top             =   195
      Width           =   2400
   End
   Begin IngotComboBoxCtl.AFComboBox CBOPage 
      Height          =   240
      Left            =   1320
      OleObjectBlob   =   "FRMInspection2.frx":0039
      TabIndex        =   4
      Top             =   -30
      Width           =   1020
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMInspection2.frx":007E
      TabIndex        =   3
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMInspection2.frx":00C9
      TabIndex        =   2
      Top             =   2160
      Width           =   510
   End
   Begin IngotTextBoxCtl.AFTextBox TXTReg 
      Height          =   195
      Left            =   360
      OleObjectBlob   =   "FRMInspection2.frx":0110
      TabIndex        =   0
      Top             =   0
      Width           =   870
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMInspection2.frx":0168
      TabIndex        =   1
      Top             =   0
      Width           =   375
   End
End
Attribute VB_Name = "FRMInspection2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub LBLz_Click(Index As Integer)

End Sub
