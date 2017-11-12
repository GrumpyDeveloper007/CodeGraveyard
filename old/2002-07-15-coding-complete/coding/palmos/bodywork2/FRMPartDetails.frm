VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{C4C9371C-9674-41BC-8457-C81D40452EF3}#2.0#0"; "IngotRadioButtonCtl.dll"
Begin VB.Form FRMPartDetails 
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
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   23
      Left            =   720
      OleObjectBlob   =   "FRMPartDetails.frx":0000
      TabIndex        =   45
      Top             =   1740
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   22
      Left            =   480
      OleObjectBlob   =   "FRMPartDetails.frx":0047
      TabIndex        =   44
      Top             =   1740
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   21
      Left            =   240
      OleObjectBlob   =   "FRMPartDetails.frx":008E
      TabIndex        =   43
      Top             =   1740
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   20
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":00D5
      TabIndex        =   42
      Top             =   1740
      Width           =   225
   End
   Begin IngotTextBoxCtl.AFTextBox TXTFraction 
      Height          =   195
      Index           =   0
      Left            =   1185
      OleObjectBlob   =   "FRMPartDetails.frx":011C
      TabIndex        =   8
      Top             =   240
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTFraction 
      Height          =   195
      Index           =   1
      Left            =   1185
      OleObjectBlob   =   "FRMPartDetails.frx":0175
      TabIndex        =   23
      Top             =   480
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTFraction 
      Height          =   195
      Index           =   2
      Left            =   1185
      OleObjectBlob   =   "FRMPartDetails.frx":01CE
      TabIndex        =   27
      Top             =   720
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTFraction 
      Height          =   195
      Index           =   3
      Left            =   1185
      OleObjectBlob   =   "FRMPartDetails.frx":0227
      TabIndex        =   31
      Top             =   960
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLItem 
      Height          =   195
      Index           =   0
      Left            =   1110
      OleObjectBlob   =   "FRMPartDetails.frx":0280
      TabIndex        =   3
      Top             =   240
      Width           =   135
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":02C3
      TabIndex        =   4
      Top             =   240
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTHour 
      Height          =   195
      Index           =   0
      Left            =   600
      OleObjectBlob   =   "FRMPartDetails.frx":0309
      TabIndex        =   5
      Top             =   240
      Width           =   495
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTPartType 
      Height          =   180
      Index           =   0
      Left            =   15
      OleObjectBlob   =   "FRMPartDetails.frx":0362
      TabIndex        =   0
      Top             =   15
      Width           =   450
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTPartType 
      Height          =   180
      Index           =   1
      Left            =   510
      OleObjectBlob   =   "FRMPartDetails.frx":03A5
      TabIndex        =   1
      Top             =   15
      Width           =   585
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTPartType 
      Height          =   180
      Index           =   2
      Left            =   1170
      OleObjectBlob   =   "FRMPartDetails.frx":03EB
      TabIndex        =   2
      Top             =   15
      Width           =   540
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   255
      Left            =   1890
      OleObjectBlob   =   "FRMPartDetails.frx":0430
      TabIndex        =   6
      Top             =   2145
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":047B
      TabIndex        =   7
      Top             =   2145
      Width           =   510
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTPartType 
      Height          =   180
      Index           =   3
      Left            =   1770
      OleObjectBlob   =   "FRMPartDetails.frx":04C2
      TabIndex        =   9
      Top             =   15
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":0507
      TabIndex        =   10
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   1
      Left            =   240
      OleObjectBlob   =   "FRMPartDetails.frx":054D
      TabIndex        =   11
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   2
      Left            =   480
      OleObjectBlob   =   "FRMPartDetails.frx":0593
      TabIndex        =   12
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   3
      Left            =   720
      OleObjectBlob   =   "FRMPartDetails.frx":05D9
      TabIndex        =   13
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   4
      Left            =   960
      OleObjectBlob   =   "FRMPartDetails.frx":061F
      TabIndex        =   14
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   5
      Left            =   1200
      OleObjectBlob   =   "FRMPartDetails.frx":0665
      TabIndex        =   15
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   6
      Left            =   1440
      OleObjectBlob   =   "FRMPartDetails.frx":06AB
      TabIndex        =   16
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   7
      Left            =   1680
      OleObjectBlob   =   "FRMPartDetails.frx":06F1
      TabIndex        =   17
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   8
      Left            =   1920
      OleObjectBlob   =   "FRMPartDetails.frx":0737
      TabIndex        =   18
      Top             =   1260
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   9
      Left            =   2160
      OleObjectBlob   =   "FRMPartDetails.frx":077D
      TabIndex        =   19
      Top             =   1260
      Width           =   225
   End
   Begin IngotLabelCtl.AFLabel LBLItem 
      Height          =   195
      Index           =   1
      Left            =   1110
      OleObjectBlob   =   "FRMPartDetails.frx":07C3
      TabIndex        =   20
      Top             =   480
      Width           =   135
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":0806
      TabIndex        =   21
      Top             =   480
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTHour 
      Height          =   195
      Index           =   1
      Left            =   600
      OleObjectBlob   =   "FRMPartDetails.frx":084D
      TabIndex        =   22
      Top             =   480
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLItem 
      Height          =   195
      Index           =   2
      Left            =   1110
      OleObjectBlob   =   "FRMPartDetails.frx":08A6
      TabIndex        =   24
      Top             =   720
      Width           =   135
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":08E9
      TabIndex        =   25
      Top             =   720
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTHour 
      Height          =   195
      Index           =   2
      Left            =   600
      OleObjectBlob   =   "FRMPartDetails.frx":092F
      TabIndex        =   26
      Top             =   720
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLItem 
      Height          =   195
      Index           =   3
      Left            =   1110
      OleObjectBlob   =   "FRMPartDetails.frx":0988
      TabIndex        =   28
      Top             =   960
      Width           =   135
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   7
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":09CB
      TabIndex        =   29
      Top             =   960
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTHour 
      Height          =   195
      Index           =   3
      Left            =   600
      OleObjectBlob   =   "FRMPartDetails.frx":0A11
      TabIndex        =   30
      Top             =   960
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   10
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":0A6A
      TabIndex        =   32
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   11
      Left            =   240
      OleObjectBlob   =   "FRMPartDetails.frx":0AB1
      TabIndex        =   33
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   12
      Left            =   480
      OleObjectBlob   =   "FRMPartDetails.frx":0AF8
      TabIndex        =   34
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   13
      Left            =   720
      OleObjectBlob   =   "FRMPartDetails.frx":0B3F
      TabIndex        =   35
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   14
      Left            =   960
      OleObjectBlob   =   "FRMPartDetails.frx":0B86
      TabIndex        =   36
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   15
      Left            =   1200
      OleObjectBlob   =   "FRMPartDetails.frx":0BCD
      TabIndex        =   37
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   16
      Left            =   1440
      OleObjectBlob   =   "FRMPartDetails.frx":0C14
      TabIndex        =   38
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   17
      Left            =   1680
      OleObjectBlob   =   "FRMPartDetails.frx":0C5B
      TabIndex        =   39
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   18
      Left            =   1920
      OleObjectBlob   =   "FRMPartDetails.frx":0CA2
      TabIndex        =   40
      Top             =   1500
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   19
      Left            =   2160
      OleObjectBlob   =   "FRMPartDetails.frx":0CE9
      TabIndex        =   41
      Top             =   1500
      Width           =   225
   End
End
Attribute VB_Name = "FRMPartDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private vHourFocus As Boolean
Private vFocusIndex As Integer

Private Sub CMDCancel_Click()
    Call FRMSelectPart.Show
End Sub

Private Sub CMDNumbers_Click(Index As Integer)
    If (vHourFocus = True) Then
        TXTHour(vFocusIndex).Text = CMDNumbers(Index).Caption
    Else
        TXTFraction(vFocusIndex).Text = CMDNumbers(Index).Caption
    End If
End Sub

Private Sub CMDOK_Click()
'    RepairType(MaxPartIndex) = Index
    Times(MaxPartIndex, 0) = CByte(TXTHour(0).Text)
    Times(MaxPartIndex, 1) = CByte(TXTFraction(0).Text)
    Times(MaxPartIndex, 2) = CByte(TXTHour(1).Text)
    Times(MaxPartIndex, 3) = CByte(TXTFraction(1).Text)
    Times(MaxPartIndex, 4) = CByte(TXTHour(2).Text)
    Times(MaxPartIndex, 5) = CByte(TXTFraction(2).Text)
    Times(MaxPartIndex, 6) = CByte(TXTHour(3).Text)
    Times(MaxPartIndex, 7) = CByte(TXTFraction(3).Text)
    MaxPartIndex = MaxPartIndex + 1
    Call FRMMain.Show
    Call FRMMain.RefreshGRD
    Call Unload(Me)
End Sub

Private Sub Form_Load()
    TXTHour(0).Visible = True
    TXTHour(1).Visible = False
    TXTHour(2).Visible = True
    TXTHour(3).Visible = True
    TXTFraction(0).Visible = True
    TXTFraction(1).Visible = False
    TXTFraction(2).Visible = True
    TXTFraction(3).Visible = True
    LBLItem(0).Visible = True
    LBLItem(1).Visible = False
    LBLItem(2).Visible = True
    LBLItem(3).Visible = True
    TXTHour(0).Text = 0
    TXTHour(1).Text = 0
    TXTHour(2).Text = 0
    TXTHour(3).Text = 0
    TXTFraction(0).Text = 0
    TXTFraction(1).Text = 0
    TXTFraction(2).Text = 0
    TXTFraction(3).Text = 0
    vHourFocus = True
End Sub

Private Sub OPTPartType_Click(Index As Integer)
    RepairType(MaxPartIndex) = Index
    Select Case Index
        Case 0
            'new
            TXTHour(0).Visible = True
            TXTHour(1).Visible = False
            TXTHour(2).Visible = True
            TXTHour(3).Visible = True
            TXTFraction(0).Visible = True
            TXTFraction(1).Visible = False
            TXTFraction(2).Visible = True
            TXTFraction(3).Visible = True
            LBLItem(0).Visible = True
            LBLItem(1).Visible = False
            LBLItem(2).Visible = True
            LBLItem(3).Visible = True
        Case 1
            'repair
            TXTHour(0).Visible = True
            TXTHour(1).Visible = True
            TXTHour(2).Visible = True
            TXTHour(3).Visible = False
            TXTFraction(0).Visible = True
            TXTFraction(1).Visible = True
            TXTFraction(2).Visible = True
            TXTFraction(3).Visible = False
            LBLItem(0).Visible = True
            LBLItem(1).Visible = True
            LBLItem(2).Visible = True
            LBLItem(3).Visible = False
        Case 2
            'paint
            TXTHour(0).Visible = True
            TXTHour(1).Visible = False
            TXTHour(2).Visible = True
            TXTHour(3).Visible = False
            TXTFraction(0).Visible = True
            TXTFraction(1).Visible = False
            TXTFraction(2).Visible = True
            TXTFraction(3).Visible = False
            LBLItem(0).Visible = True
            LBLItem(1).Visible = False
            LBLItem(2).Visible = True
            LBLItem(3).Visible = False
        Case 3
            'refit
            TXTHour(0).Visible = True
            TXTHour(1).Visible = False
            TXTHour(2).Visible = False
            TXTHour(3).Visible = False
            TXTFraction(0).Visible = True
            TXTFraction(1).Visible = False
            TXTFraction(2).Visible = False
            TXTFraction(3).Visible = False
            LBLItem(0).Visible = True
            LBLItem(1).Visible = False
            LBLItem(2).Visible = False
            LBLItem(3).Visible = False
        Case Else
    End Select
End Sub

Private Sub TXTFraction_Click(Index As Integer)
    vHourFocus = False
    vFocusIndex = Index
End Sub

Private Sub TXTHour_Click(Index As Integer)
    vHourFocus = True
    vFocusIndex = Index
End Sub
