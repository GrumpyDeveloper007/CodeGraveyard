VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{899CE9D8-3C9F-48DF-B418-E338294B00E3}#2.0#0"; "IngotCheckBoxCtl.dll"
Begin VB.Form FRMDetails1 
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
   Begin IngotComboBoxCtl.AFComboBox CBOConversion 
      Height          =   240
      Left            =   660
      OleObjectBlob   =   "FRMDetails1.frx":0000
      TabIndex        =   34
      Top             =   1650
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   15
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":0050
      TabIndex        =   35
      Top             =   1680
      Width           =   750
   End
   Begin IngotComboBoxCtl.AFComboBox CBORoofDetail 
      Height          =   240
      Left            =   660
      OleObjectBlob   =   "FRMDetails1.frx":009B
      TabIndex        =   32
      Top             =   1470
      Width           =   1020
   End
   Begin IngotComboBoxCtl.AFComboBox CBOPoleDetail 
      Height          =   240
      Left            =   660
      OleObjectBlob   =   "FRMDetails1.frx":00EB
      TabIndex        =   30
      Top             =   1290
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   14
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":013B
      TabIndex        =   33
      Top             =   1500
      Width           =   750
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   11
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":0187
      TabIndex        =   31
      Top             =   1320
      Width           =   750
   End
   Begin IngotCheckBoxCtl.AFCheckBox CHKBayWindow 
      Height          =   195
      Left            =   1320
      OleObjectBlob   =   "FRMDetails1.frx":01D3
      TabIndex        =   29
      Top             =   420
      Width           =   975
   End
   Begin IngotComboBoxCtl.AFComboBox CBOPatioDoor 
      Height          =   240
      Left            =   660
      OleObjectBlob   =   "FRMDetails1.frx":0227
      TabIndex        =   28
      Top             =   1110
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   10
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":0277
      TabIndex        =   27
      Top             =   1140
      Width           =   750
   End
   Begin IngotComboBoxCtl.AFComboBox CBOResiDoor 
      Height          =   240
      Left            =   660
      OleObjectBlob   =   "FRMDetails1.frx":02C2
      TabIndex        =   26
      Top             =   930
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   7
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":0312
      TabIndex        =   25
      Top             =   960
      Width           =   870
   End
   Begin IngotComboBoxCtl.AFComboBox CBOWindow 
      Height          =   240
      Left            =   660
      OleObjectBlob   =   "FRMDetails1.frx":035C
      TabIndex        =   24
      Top             =   750
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   6
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":03AC
      TabIndex        =   23
      Top             =   780
      Width           =   510
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox6 
      Height          =   180
      Left            =   810
      OleObjectBlob   =   "FRMDetails1.frx":03F3
      TabIndex        =   22
      Top             =   585
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox5 
      Height          =   180
      Left            =   810
      OleObjectBlob   =   "FRMDetails1.frx":044B
      TabIndex        =   21
      Top             =   390
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   5
      Left            =   720
      OleObjectBlob   =   "FRMDetails1.frx":04A3
      TabIndex        =   20
      Top             =   585
      Width           =   165
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   4
      Left            =   705
      OleObjectBlob   =   "FRMDetails1.frx":04E5
      TabIndex        =   19
      Top             =   390
      Width           =   135
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox4 
      Height          =   180
      Left            =   120
      OleObjectBlob   =   "FRMDetails1.frx":0527
      TabIndex        =   18
      Top             =   585
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox3 
      Height          =   180
      Left            =   120
      OleObjectBlob   =   "FRMDetails1.frx":057F
      TabIndex        =   17
      Top             =   390
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":05D7
      TabIndex        =   16
      Top             =   585
      Width           =   165
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":0619
      TabIndex        =   15
      Top             =   390
      Width           =   150
   End
   Begin IngotButtonCtl.AFButton CMDLeft 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":065B
      TabIndex        =   14
      Top             =   2160
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox AFTextBox1 
      Height          =   180
      Left            =   1110
      OleObjectBlob   =   "FRMDetails1.frx":06A1
      TabIndex        =   2
      Top             =   2175
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   13
      Left            =   1020
      OleObjectBlob   =   "FRMDetails1.frx":06F9
      TabIndex        =   13
      Top             =   0
      Width           =   855
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   12
      Left            =   1020
      OleObjectBlob   =   "FRMDetails1.frx":0747
      TabIndex        =   12
      Top             =   195
      Width           =   870
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPlasterWidth 
      Height          =   180
      Left            =   1905
      OleObjectBlob   =   "FRMDetails1.frx":0796
      TabIndex        =   11
      Top             =   0
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPlasterHeight 
      Height          =   180
      Left            =   1905
      OleObjectBlob   =   "FRMDetails1.frx":07EE
      TabIndex        =   10
      Top             =   195
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1890
      OleObjectBlob   =   "FRMDetails1.frx":0846
      TabIndex        =   9
      Top             =   2160
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDRight 
      Height          =   240
      Left            =   360
      OleObjectBlob   =   "FRMDetails1.frx":088F
      TabIndex        =   8
      Top             =   2160
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":08D5
      TabIndex        =   7
      Top             =   0
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":091B
      TabIndex        =   6
      Top             =   195
      Width           =   405
   End
   Begin IngotTextBoxCtl.AFTextBox TXTWidth 
      Height          =   180
      Left            =   480
      OleObjectBlob   =   "FRMDetails1.frx":0962
      TabIndex        =   5
      Top             =   0
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTHeight 
      Height          =   180
      Left            =   480
      OleObjectBlob   =   "FRMDetails1.frx":09BA
      TabIndex        =   4
      Top             =   195
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   8
      Left            =   750
      OleObjectBlob   =   "FRMDetails1.frx":0A12
      TabIndex        =   3
      Top             =   2175
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   9
      Left            =   0
      OleObjectBlob   =   "FRMDetails1.frx":0A58
      TabIndex        =   1
      Top             =   1860
      Width           =   525
   End
   Begin IngotTextBoxCtl.AFTextBox TXTLocation 
      Height          =   180
      Left            =   660
      OleObjectBlob   =   "FRMDetails1.frx":0AA1
      TabIndex        =   0
      Top             =   1860
      Width           =   945
   End
End
Attribute VB_Name = "FRMDetails1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDDesigner_Click()
    Call Me.Hide
    Call FRMDesigner.Show
End Sub

Private Sub CHKBayWindow_Click()
    If (CHKBayWindow.Value = afCheckBoxValueChecked) Then
        CBORoofDetail.Visible = True
        CBOConversion.Visible = True
    Else
        CBORoofDetail.Visible = False
        CBOConversion.Visible = False
    End If
End Sub

Private Sub CMDExit_Click()
    FRMMain.Show
    Me.Hide
End Sub

Private Sub CMDLeft_Click()
    Me.Hide
    FRMMain.Show
End Sub

Private Sub CMDRight_Click()
    Me.Hide
    FRMDetails2.Show
End Sub

Private Sub Form_Load()
    Call CBOWindow.AddItem("None")
    Call CBOWindow.AddItem("Casement")
    Call CBOWindow.AddItem("T/Turn")
    CBOWindow.ListIndex = 0

    Call CBOResiDoor.AddItem("None")
    Call CBOResiDoor.AddItem("Open In")
    Call CBOResiDoor.AddItem("Open Out")
    CBOResiDoor.ListIndex = 0

    Call CBOPatioDoor.AddItem("None")
    Call CBOPatioDoor.AddItem("In - Line")
    Call CBOPatioDoor.AddItem("Tilt & Slide")
    CBOPatioDoor.ListIndex = 0

    Call CBOPoleDetail.AddItem("Bay Pole")
    Call CBOPoleDetail.AddItem("Fixed Angle Post")
    Call CBOPoleDetail.AddItem("90* Post")
    Call CBOPoleDetail.AddItem("Load Bearing")
    CBOPoleDetail.ListIndex = 0

    Call CBORoofDetail.AddItem("None")
    Call CBORoofDetail.AddItem("Pvc Canopy")
    Call CBORoofDetail.AddItem("Timber & Lead")
    Call CBORoofDetail.AddItem("Head Of Frame Left in")
    CBORoofDetail.ListIndex = 0
    
    
    Call CBOConversion.AddItem("None")
    Call CBOConversion.AddItem("Bay Conversion")
    Call CBOConversion.AddItem("Gallows Bracket(s)")
    Call CBOConversion.AddItem("Number Req")
    CBOConversion.ListIndex = 0
    
    Call CHKBayWindow_Click
End Sub

