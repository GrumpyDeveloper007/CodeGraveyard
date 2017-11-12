VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{899CE9D8-3C9F-48DF-B418-E338294B00E3}#2.0#0"; "IngotCheckBoxCtl.dll"
Object = "{C4C9371C-9674-41BC-8457-C81D40452EF3}#2.0#0"; "IngotRadioButtonCtl.dll"
Object = "{54171E73-16D6-4021-A96E-E59C0FE780E9}#2.0#0"; "IngotShapeCtl.dll"
Begin VB.Form FRMInspection3 
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
   Begin IngotRadioButtonCtl.AFRadioButton OPTInspectionType 
      Height          =   180
      Index           =   1
      Left            =   1680
      OleObjectBlob   =   "FRMInspection3.frx":0000
      TabIndex        =   21
      Top             =   495
      Width           =   690
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTInspectionType 
      Height          =   180
      Index           =   0
      Left            =   1680
      OleObjectBlob   =   "FRMInspection3.frx":0048
      TabIndex        =   20
      Top             =   300
      Width           =   645
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":0090
      TabIndex        =   19
      Top             =   450
      Width           =   270
   End
   Begin IngotComboBoxCtl.AFComboBox CBOPL 
      Height          =   240
      Left            =   240
      OleObjectBlob   =   "FRMInspection3.frx":00D7
      TabIndex        =   18
      Top             =   420
      Width           =   1335
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":011C
      TabIndex        =   17
      Top             =   285
      Width           =   270
   End
   Begin IngotComboBoxCtl.AFComboBox CBOPM 
      Height          =   240
      Left            =   240
      OleObjectBlob   =   "FRMInspection3.frx":0163
      TabIndex        =   16
      Top             =   255
      Width           =   1335
   End
   Begin IngotCheckBoxCtl.AFCheckBox CHKCleaningProblem 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":01A8
      TabIndex        =   15
      Top             =   1170
      Width           =   1275
   End
   Begin IngotCheckBoxCtl.AFCheckBox CHKPartProblem 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":0202
      TabIndex        =   14
      Top             =   1005
      Width           =   1035
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   21
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":0258
      TabIndex        =   13
      Top             =   0
      Width           =   600
   End
   Begin IngotTextBoxCtl.AFTextBox TXTAdditional 
      Height          =   195
      Left            =   615
      OleObjectBlob   =   "FRMInspection3.frx":02A7
      TabIndex        =   12
      Top             =   0
      Width           =   1785
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":02FF
      TabIndex        =   11
      Top             =   795
      Width           =   375
   End
   Begin IngotComboBoxCtl.AFComboBox CBOModel 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMInspection3.frx":0349
      TabIndex        =   10
      Top             =   765
      Width           =   1815
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":038E
      TabIndex        =   9
      Top             =   630
      Width           =   345
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMInspection3.frx":03D7
      TabIndex        =   7
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":0422
      TabIndex        =   6
      Top             =   2160
      Width           =   510
   End
   Begin IngotShapeCtl.AFShape SHAPE 
      Height          =   30
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspection3.frx":0469
      TabIndex        =   5
      Top             =   225
      Width           =   2400
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   0
      Left            =   1080
      OleObjectBlob   =   "FRMInspection3.frx":04A2
      TabIndex        =   4
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   1
      Left            =   1335
      OleObjectBlob   =   "FRMInspection3.frx":04E8
      TabIndex        =   3
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   2
      Left            =   1575
      OleObjectBlob   =   "FRMInspection3.frx":052E
      TabIndex        =   2
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDPageRight 
      Height          =   210
      Left            =   810
      OleObjectBlob   =   "FRMInspection3.frx":0574
      TabIndex        =   1
      Top             =   2190
      Visible         =   0   'False
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDPageLeft 
      Height          =   210
      Left            =   555
      OleObjectBlob   =   "FRMInspection3.frx":05BA
      TabIndex        =   0
      Top             =   2190
      Width           =   225
   End
   Begin IngotComboBoxCtl.AFComboBox CBOMake 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMInspection3.frx":0600
      TabIndex        =   8
      Top             =   600
      Width           =   1815
   End
End
Attribute VB_Name = "FRMInspection3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Enum CurrentSelectionENUM
    test = 39
End Enum


Private vSelectedItem As CurrentSelectionENUM

Private Sub CBOMake_Click()
    Call LoadModelCBO
End Sub

''
Private Sub CMDCancel_Click()
    FRMInspection1.Hide
    FRMInspectionPaint.Hide
    FRMInspection3.Hide
    FRMMain.RefreshScreen
End Sub

Private Sub CMDNumbers_Click(Index As Integer)
    Select Case vSelectedItem
        Case test
    End Select
End Sub

Public Sub CMDOK_Click()
    Call FRMInspection1.CMDOK_Click
End Sub

Private Sub CMDPageLeft_Click()
    Me.Hide
    FRMInspectionPaint.Show
'    FRMInspectionPaint.TXTAdditional.SetFocus
End Sub



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Input validatation


