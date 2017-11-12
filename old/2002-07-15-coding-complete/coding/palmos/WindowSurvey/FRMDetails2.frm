VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMDetails2 
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
   Begin IngotTextBoxCtl.AFTextBox AFTextBox2 
      Height          =   330
      Left            =   660
      OleObjectBlob   =   "FRMDetails2.frx":0000
      TabIndex        =   29
      Top             =   1800
      Width           =   1740
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   14
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":0058
      TabIndex        =   28
      Top             =   1800
      Width           =   660
   End
   Begin IngotComboBoxCtl.AFComboBox CBOHandleType 
      Height          =   240
      Left            =   1530
      OleObjectBlob   =   "FRMDetails2.frx":00A1
      TabIndex        =   27
      Top             =   495
      Width           =   840
   End
   Begin IngotComboBoxCtl.AFComboBox CBOLetterBox 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMDetails2.frx":00F1
      TabIndex        =   26
      Top             =   1410
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   9
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":0141
      TabIndex        =   25
      Top             =   1440
      Width           =   420
   End
   Begin IngotComboBoxCtl.AFComboBox CBOBoardColour 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMDetails2.frx":0188
      TabIndex        =   24
      Top             =   1230
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":01D8
      TabIndex        =   23
      Top             =   1260
      Width           =   420
   End
   Begin IngotComboBoxCtl.AFComboBox CBOPanelDetail 
      Height          =   240
      Left            =   1530
      OleObjectBlob   =   "FRMDetails2.frx":021E
      TabIndex        =   22
      Top             =   1050
      Width           =   840
   End
   Begin IngotComboBoxCtl.AFComboBox CBOPanelColour 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMDetails2.frx":026E
      TabIndex        =   21
      Top             =   1050
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":02BE
      TabIndex        =   20
      Top             =   1080
      Width           =   420
   End
   Begin IngotButtonCtl.AFButton CMDLeft 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":0304
      TabIndex        =   19
      Top             =   2160
      Width           =   255
   End
   Begin IngotButtonCtl.AFButton CMDRight 
      Height          =   240
      Left            =   360
      OleObjectBlob   =   "FRMDetails2.frx":034A
      TabIndex        =   18
      Top             =   2160
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   11
      Left            =   1755
      OleObjectBlob   =   "FRMDetails2.frx":0390
      TabIndex        =   17
      Top             =   -15
      Width           =   390
   End
   Begin IngotComboBoxCtl.AFComboBox CBOCillDetal 
      Height          =   240
      Left            =   1530
      OleObjectBlob   =   "FRMDetails2.frx":03D5
      TabIndex        =   16
      Top             =   870
      Width           =   840
   End
   Begin IngotComboBoxCtl.AFComboBox CBOCillColour 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMDetails2.frx":0425
      TabIndex        =   15
      Top             =   870
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   10
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":0475
      TabIndex        =   14
      Top             =   900
      Width           =   165
   End
   Begin IngotComboBoxCtl.AFComboBox CBOBeadType 
      Height          =   240
      Left            =   1545
      OleObjectBlob   =   "FRMDetails2.frx":04BA
      TabIndex        =   13
      Top             =   300
      Width           =   840
   End
   Begin IngotComboBoxCtl.AFComboBox CBOFrameType 
      Height          =   240
      Left            =   1545
      OleObjectBlob   =   "FRMDetails2.frx":050A
      TabIndex        =   12
      Top             =   105
      Width           =   840
   End
   Begin IngotComboBoxCtl.AFComboBox CBOGlazing 
      Height          =   240
      Left            =   1530
      OleObjectBlob   =   "FRMDetails2.frx":055A
      TabIndex        =   11
      Top             =   690
      Width           =   840
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   7
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":05AA
      TabIndex        =   10
      Top             =   690
      Width           =   435
   End
   Begin IngotComboBoxCtl.AFComboBox CBOHandleColour 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMDetails2.frx":05F2
      TabIndex        =   9
      Top             =   495
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   6
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":0642
      TabIndex        =   8
      Top             =   510
      Width           =   420
   End
   Begin IngotComboBoxCtl.AFComboBox CBOBeadColour 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMDetails2.frx":0689
      TabIndex        =   7
      Top             =   300
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":06D9
      TabIndex        =   6
      Top             =   330
      Width           =   300
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   4
      Left            =   690
      OleObjectBlob   =   "FRMDetails2.frx":071E
      TabIndex        =   5
      Top             =   -15
      Width           =   390
   End
   Begin IngotComboBoxCtl.AFComboBox CBOFrameColour 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMDetails2.frx":0765
      TabIndex        =   4
      Top             =   105
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":07B5
      TabIndex        =   3
      Top             =   135
      Width           =   390
   End
   Begin IngotComboBoxCtl.AFComboBox CBOGlass 
      Height          =   240
      Left            =   570
      OleObjectBlob   =   "FRMDetails2.frx":07FB
      TabIndex        =   2
      Top             =   1590
      Width           =   1755
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMDetails2.frx":084B
      TabIndex        =   1
      Top             =   1620
      Width           =   720
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1890
      OleObjectBlob   =   "FRMDetails2.frx":0894
      TabIndex        =   0
      Top             =   2160
      Width           =   510
   End
End
Attribute VB_Name = "FRMDetails2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDExit_Click()
    FRMMain.Show
    Me.Hide
End Sub

Private Sub CMDLeft_Click()
    Me.Hide
    FRMDetails1.Show
End Sub

Private Sub CMDRight_Click()
    Me.Hide
    FRMDesigner.Show
End Sub

Private Sub Form_Load()
    Call CBOGlass.AddItem("Clear - Queen Anne Lead")
    Call CBOGlass.AddItem("Autumn - Queen Anne Lead")
    CBOGlass.ListIndex = 0
    
    Call CBOFrameColour.AddItem("White")
    Call CBOFrameColour.AddItem("White/Grey")
    Call CBOFrameColour.AddItem("White/Grey-w")
    CBOFrameColour.ListIndex = 0
    
    Call CBOFrameType.AddItem("Slim")
    Call CBOFrameType.AddItem("Int")
    Call CBOFrameType.AddItem("Wide")
    CBOFrameType.ListIndex = 0
    
    Call CBOBeadColour.AddItem("White")
    Call CBOBeadColour.AddItem("White/Grey")
    Call CBOBeadColour.AddItem("White/Grey-w")
    CBOBeadColour.ListIndex = 0

    Call CBOBeadType.AddItem("Bevel")
    Call CBOBeadType.AddItem("Scotia")
    CBOBeadType.ListIndex = 0
    
    Call CBOHandleColour.AddItem("Gold")
    Call CBOHandleColour.AddItem("White")
    CBOHandleColour.ListIndex = 0
    
    Call CBOGlazing.AddItem("External")
    Call CBOGlazing.AddItem("Internal")
    CBOGlazing.ListIndex = 0
    
    Call CBOCillColour.AddItem("White")
    Call CBOCillColour.AddItem("W/g")
    Call CBOCillColour.AddItem("Other")
    CBOCillColour.ListIndex = 0
    
    Call CBOCillDetal.AddItem("150")
    Call CBOCillDetal.AddItem("180")
    Call CBOCillDetal.AddItem("Stub")
    CBOCillDetal.ListIndex = 0
    
    Call CBOPanelColour.AddItem("White")
    Call CBOPanelColour.AddItem("White/Grey")
    Call CBOPanelColour.AddItem("White/Grey-w")
    CBOPanelColour.ListIndex = 0
    
    Call CBOPanelDetail.AddItem("None")
    CBOPanelDetail.ListIndex = 0

    Call CBOBoardColour.AddItem("White")
    Call CBOBoardColour.AddItem("White/Grey")
    Call CBOBoardColour.AddItem("White/Grey-w")
    CBOBoardColour.ListIndex = 0

    Call CBOLetterBox.AddItem("White")
    Call CBOLetterBox.AddItem("White/Grey")
    Call CBOLetterBox.AddItem("White/Grey-w")
    CBOLetterBox.ListIndex = 0

    Call CBOHandleType.AddItem("None")
    Call CBOHandleType.AddItem("Internal Only")
    Call CBOHandleType.AddItem("Internal/External")
    CBOHandleType.ListIndex = 0
End Sub
