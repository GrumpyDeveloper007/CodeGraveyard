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
   Begin IngotGridCtl.AFGrid GRDWindow 
      Height          =   870
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":0000
      TabIndex        =   10
      Top             =   1200
      Width           =   2400
   End
   Begin IngotComboBoxCtl.AFComboBox CBOSurveyorName 
      Height          =   240
      Left            =   1080
      OleObjectBlob   =   "FRMMain.frx":0046
      TabIndex        =   7
      Top             =   420
      Width           =   1020
   End
   Begin IngotComboBoxCtl.AFComboBox CBOCustomerName 
      Height          =   240
      Left            =   1080
      OleObjectBlob   =   "FRMMain.frx":0096
      TabIndex        =   9
      Top             =   660
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":00E6
      TabIndex        =   8
      Top             =   720
      Width           =   1215
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":0134
      TabIndex        =   6
      Top             =   480
      Width           =   1215
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox1 
      Height          =   195
      Left            =   795
      OleObjectBlob   =   "FRMMain.frx":0182
      TabIndex        =   4
      Top             =   210
      Width           =   960
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":01DA
      TabIndex        =   5
      Top             =   210
      Width           =   795
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDate 
      Height          =   195
      Left            =   795
      OleObjectBlob   =   "FRMMain.frx":0226
      TabIndex        =   2
      Top             =   0
      Width           =   840
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":027E
      TabIndex        =   3
      Top             =   0
      Width           =   375
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1890
      OleObjectBlob   =   "FRMMain.frx":02C3
      TabIndex        =   1
      Top             =   2160
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDDetails 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":030C
      TabIndex        =   0
      Top             =   2160
      Width           =   615
   End
End
Attribute VB_Name = "FRMMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub CMDDetails_Click()
    FRMDetails1.Show
    Me.Hide
End Sub

Private Sub CMDExit_Click()
    End
End Sub

Private Sub Form_Load()
    TXTDate.Text = Date

    GRDWindow.ColWidth(0) = 41
    GRDWindow.ColWidth(1) = 108

    GRDWindow.Rows = 0
    Call GRDWindow.AddItem("Location" & vbTab & "Description")
    GRDWindow.RowHeight(0) = 12
    
    Call CBOSurveyorName.AddItem("Steve")
    Call CBOSurveyorName.AddItem("Sean")
    
    Call CBOCustomerName.AddItem("Chris")
End Sub
