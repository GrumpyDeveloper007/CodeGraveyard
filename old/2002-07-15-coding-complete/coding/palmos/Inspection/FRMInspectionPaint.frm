VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{54171E73-16D6-4021-A96E-E59C0FE780E9}#2.0#0"; "IngotShapeCtl.dll"
Begin VB.Form FRMInspectionPaint 
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
   Begin IngotTextBoxCtl.AFTextBox TXTDirtInPaint 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":0000
      TabIndex        =   47
      Top             =   1890
      Width           =   255
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMInspectionPaint.frx":0058
      TabIndex        =   46
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDPageLeft 
      Height          =   210
      Left            =   555
      OleObjectBlob   =   "FRMInspectionPaint.frx":00A3
      TabIndex        =   44
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDPageRight 
      Height          =   210
      Left            =   810
      OleObjectBlob   =   "FRMInspectionPaint.frx":00E9
      TabIndex        =   45
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   0
      Left            =   1080
      OleObjectBlob   =   "FRMInspectionPaint.frx":012F
      TabIndex        =   41
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   1
      Left            =   1335
      OleObjectBlob   =   "FRMInspectionPaint.frx":0175
      TabIndex        =   42
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   2
      Left            =   1575
      OleObjectBlob   =   "FRMInspectionPaint.frx":01BB
      TabIndex        =   43
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0201
      TabIndex        =   18
      Top             =   2160
      Width           =   510
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPOther 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":0248
      TabIndex        =   17
      Top             =   1725
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTMaskingLines 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":02A0
      TabIndex        =   13
      Top             =   1065
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   18
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":02F8
      TabIndex        =   38
      Top             =   1395
      Width           =   855
   End
   Begin IngotTextBoxCtl.AFTextBox TXTBlowins 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":0345
      TabIndex        =   15
      Top             =   1395
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTCleaning 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":039D
      TabIndex        =   16
      Top             =   1560
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPaintRuns 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":03F5
      TabIndex        =   10
      Top             =   1515
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTColourMatch 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":044D
      TabIndex        =   11
      Top             =   1680
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTThrough 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":04A5
      TabIndex        =   0
      Top             =   285
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTFlattingMarks 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":04FD
      TabIndex        =   1
      Top             =   450
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTOverspray 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":0555
      TabIndex        =   2
      Top             =   615
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTOther 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":05AD
      TabIndex        =   3
      Top             =   780
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTTouchingUp 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":0605
      TabIndex        =   4
      Top             =   285
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPaint 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":065D
      TabIndex        =   5
      Top             =   450
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTBlackingOff 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":06B5
      TabIndex        =   6
      Top             =   615
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTFOther 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":070D
      TabIndex        =   7
      Top             =   780
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTSandingMarks 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":0765
      TabIndex        =   8
      Top             =   1185
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTBareCorrosion 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":07BD
      TabIndex        =   9
      Top             =   1350
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTShrinkage 
      Height          =   180
      Left            =   975
      OleObjectBlob   =   "FRMInspectionPaint.frx":0815
      TabIndex        =   12
      Top             =   1845
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPaintEdge 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspectionPaint.frx":086D
      TabIndex        =   14
      Top             =   1230
      Width           =   255
   End
   Begin IngotShapeCtl.AFShape SHAPE 
      Height          =   30
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":08C5
      TabIndex        =   19
      Top             =   195
      Width           =   2400
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   8
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":08FE
      TabIndex        =   29
      Top             =   15
      Width           =   1095
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   13
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0954
      TabIndex        =   24
      Top             =   1020
      Width           =   990
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   14
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":09A9
      TabIndex        =   23
      Top             =   1185
      Width           =   945
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   15
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":09FB
      TabIndex        =   22
      Top             =   1350
      Width           =   1020
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   16
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0A4F
      TabIndex        =   21
      Top             =   1860
      Width           =   855
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   17
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0A9D
      TabIndex        =   20
      Top             =   1230
      Width           =   885
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0AEC
      TabIndex        =   34
      Top             =   15
      Width           =   735
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   4
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0B3A
      TabIndex        =   33
      Top             =   285
      Width           =   930
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0B8D
      TabIndex        =   32
      Top             =   450
      Width           =   945
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   6
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0BE0
      TabIndex        =   31
      Top             =   615
      Width           =   765
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   7
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0C2E
      TabIndex        =   30
      Top             =   780
      Width           =   735
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   9
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0C78
      TabIndex        =   28
      Top             =   285
      Width           =   1005
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   10
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0CC8
      TabIndex        =   27
      Top             =   450
      Width           =   930
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   11
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0D20
      TabIndex        =   26
      Top             =   615
      Width           =   810
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   12
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0D71
      TabIndex        =   25
      Top             =   780
      Width           =   390
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0DBB
      TabIndex        =   35
      Top             =   1680
      Width           =   870
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   2
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0E0C
      TabIndex        =   37
      Top             =   1560
      Width           =   975
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   19
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0E59
      TabIndex        =   39
      Top             =   1050
      Width           =   855
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   20
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0EAB
      TabIndex        =   40
      Top             =   1725
      Width           =   975
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspectionPaint.frx":0EF5
      TabIndex        =   36
      Top             =   1515
      Width           =   855
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   21
      Left            =   1260
      OleObjectBlob   =   "FRMInspectionPaint.frx":0F44
      TabIndex        =   48
      Top             =   1905
      Width           =   975
   End
End
Attribute VB_Name = "FRMInspectionPaint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Enum CurrentSelectionENUM
    Additional = 20
    Polishing_Through = 21
    Polishing_FlattingMarks = 22
    Polishing_OverSpray = 23
    Polishing_Other = 24
    Finishing_TouchingUp = 25
    Finishing_Paint = 26
    Finishing_BlackingOff = 27
    Finishing_Other = 28
    PaintingQuality_SandingMarks = 29
    PaintingQuality_BareCorrosion = 30
    PaintingQuality_PaintRuns = 31
    PaintingQuality_ColourMatch = 32
    PaintingQuality_Shrinkage = 33
    PaintingQuality_MaskingLines = 34
    PaintingQuality_PaintEdge = 35
    PaintingQuality_Blowins = 36
    PaintingQuality_Cleaning = 37
    PaintingQuality_Other = 38
    PaintingQuality_DirtInPaint = 39
End Enum

Private vSelectedItem As CurrentSelectionENUM

''
Private Sub CMDCancel_Click()
    FRMInspection1.Hide
    FRMInspectionPaint.Hide
    FRMInspection3.Hide
    FRMMain.RefreshScreen
End Sub

'' Set text box depending on focus
Private Sub CMDNumbers_Click(Index As Integer)
    Select Case vSelectedItem
        Case Additional
'            TXTAdditional.Text = TXTAdditional.Text & Index
'            Call TXTAdditional.SetFocus
        Case Polishing_Through
            TXTThrough.Text = Index
            Call TXTThrough.SetFocus
        Case Polishing_FlattingMarks
            TXTFlattingMarks.Text = Index
            Call TXTFlattingMarks.SetFocus
        Case Polishing_OverSpray
            TXTOverspray.Text = Index
            TXTOverspray.SetFocus
        Case Polishing_Other
            TXTOther.Text = Index
            TXTOther.SetFocus
        Case Finishing_TouchingUp
            TXTTouchingUp.Text = Index
            TXTTouchingUp.SetFocus
        Case Finishing_Paint
            TXTPaint.Text = Index
            TXTPaint.SetFocus
        Case Finishing_BlackingOff
            TXTBlackingOff.Text = Index
            TXTBlackingOff.SetFocus
        Case Finishing_Other
            TXTFOther.Text = Index
            TXTFOther.SetFocus
        Case PaintingQuality_SandingMarks
            TXTSandingMarks.Text = Index
            TXTSandingMarks.SetFocus
        Case PaintingQuality_BareCorrosion
            TXTBareCorrosion.Text = Index
            TXTBareCorrosion.SetFocus
        Case PaintingQuality_PaintRuns
            TXTPaintRuns.Text = Index
            TXTPaintRuns.SetFocus
        Case PaintingQuality_ColourMatch
            TXTColourMatch.Text = Index
            TXTColourMatch.SetFocus
        Case PaintingQuality_Shrinkage
            TXTShrinkage.Text = Index
            TXTShrinkage.SetFocus
        Case PaintingQuality_MaskingLines
            TXTMaskingLines.Text = Index
            TXTMaskingLines.SetFocus
        Case PaintingQuality_PaintEdge
            TXTPaintEdge.Text = Index
            TXTPaintEdge.SetFocus
        Case PaintingQuality_Blowins
            TXTBlowins.Text = Index
            TXTBlowins.SetFocus
        Case PaintingQuality_Cleaning
            TXTCleaning.Text = Index
            TXTCleaning.SetFocus
        Case PaintingQuality_Other
            TXTPOther.Text = Index
            TXTPOther.SetFocus
        Case PaintingQuality_DirtInPaint
            TXTDirtInPaint.Text = Index
            TXTDirtInPaint.SetFocus

        End Select
End Sub

'' create/update new inspection
Private Sub CMDOK_Click()
    Call FRMInspection1.CMDOK_Click
End Sub

''
Private Sub CMDPageLeft_Click()
    Me.Hide
    FRMInspection1.Show
End Sub

''
Private Sub CMDPageRight_Click()
    Me.Hide
    Call FRMInspection3.Show
End Sub

Private Sub Form_Load()

End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Input validatation
Private Sub TXTBareCorrosion_Change()
    TXTBareCorrosion.Text = RemoveNonNumericCharacters(TXTBareCorrosion.Text, 2)
End Sub
Private Sub TXTBlackingOff_Change()
    TXTBlackingOff.Text = RemoveNonNumericCharacters(TXTBlackingOff.Text, 2)
End Sub
Private Sub TXTBlowins_Change()
    TXTBlowins.Text = RemoveNonNumericCharacters(TXTBlowins.Text, 2)
End Sub
Private Sub TXTCleaning_Change()
    TXTCleaning.Text = RemoveNonNumericCharacters(TXTCleaning.Text, 2)
End Sub
Private Sub TXTColourMatch_Change()
    TXTColourMatch.Text = RemoveNonNumericCharacters(TXTColourMatch.Text, 2)
End Sub
Private Sub TXTDirtInPaint_Change()
    TXTDirtInPaint.Text = RemoveNonNumericCharacters(TXTDirtInPaint.Text, 2)
End Sub
Private Sub TXTFlattingMarks_Change()
    TXTFlattingMarks.Text = RemoveNonNumericCharacters(TXTFlattingMarks.Text, 2)
End Sub
Private Sub TXTFOther_Change()
    TXTFOther.Text = RemoveNonNumericCharacters(TXTFOther.Text, 2)
End Sub
Private Sub TXTMaskingLines_Change()
    TXTMaskingLines.Text = RemoveNonNumericCharacters(TXTMaskingLines.Text, 2)
End Sub
Private Sub TXTOther_Change()
    TXTOther.Text = RemoveNonNumericCharacters(TXTOther.Text, 2)
End Sub
Private Sub TXTOverspray_Change()
    TXTOverspray.Text = RemoveNonNumericCharacters(TXTOverspray.Text, 2)
End Sub
Private Sub TXTPaint_Change()
    TXTPaint.Text = RemoveNonNumericCharacters(TXTPaint.Text, 2)
End Sub
Private Sub TXTPaintEdge_Change()
    TXTPaintEdge.Text = RemoveNonNumericCharacters(TXTPaintEdge.Text, 2)
End Sub
Private Sub TXTPaintRuns_Change()
    TXTPaintRuns.Text = RemoveNonNumericCharacters(TXTPaintRuns.Text, 2)
End Sub
Private Sub TXTPOther_Change()
    TXTPOther.Text = RemoveNonNumericCharacters(TXTPOther.Text, 2)
End Sub
Private Sub TXTSandingMarks_Change()
    TXTSandingMarks.Text = RemoveNonNumericCharacters(TXTSandingMarks.Text, 2)
End Sub
Private Sub TXTShrinkage_Change()
    TXTShrinkage.Text = RemoveNonNumericCharacters(TXTShrinkage.Text, 2)
End Sub
Private Sub TXTThrough_Change()
    TXTThrough.Text = RemoveNonNumericCharacters(TXTThrough.Text, 2)
End Sub
Private Sub TXTTouchingUp_Change()
    TXTTouchingUp.Text = RemoveNonNumericCharacters(TXTTouchingUp.Text, 2)
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Focus change 2
Private Sub TXTAdditional_Click()
    vSelectedItem = Additional
End Sub
Private Sub TXTDirtInPaint_Click()
    vSelectedItem = PaintingQuality_DirtInPaint
End Sub
Private Sub TXTBareCorrosion_Click()
    vSelectedItem = PaintingQuality_BareCorrosion
End Sub
Private Sub TXTBlackingOff_Click()
    vSelectedItem = Finishing_BlackingOff
End Sub
Private Sub TXTBlowins_Click()
    vSelectedItem = PaintingQuality_Blowins
End Sub
Private Sub TXTCleaning_Click()
    vSelectedItem = PaintingQuality_Cleaning
End Sub
Private Sub TXTColourMatch_Click()
    vSelectedItem = PaintingQuality_ColourMatch
End Sub
Private Sub TXTFlattingMarks_Click()
    vSelectedItem = Polishing_FlattingMarks
End Sub
Private Sub TXTFOther_Click()
    vSelectedItem = Finishing_Other
End Sub
Private Sub TXTMaskingLines_Click()
    vSelectedItem = PaintingQuality_MaskingLines
End Sub
Private Sub TXTOther_Click()
    vSelectedItem = Polishing_Other
End Sub
Private Sub TXTOverspray_Click()
    vSelectedItem = Polishing_OverSpray
End Sub
Private Sub TXTPaint_Click()
    vSelectedItem = Finishing_Paint
End Sub
Private Sub TXTPaintEdge_Click()
    vSelectedItem = PaintingQuality_PaintEdge
End Sub
Private Sub TXTPaintRuns_Click()
    vSelectedItem = PaintingQuality_PaintRuns
End Sub
Private Sub TXTPOther_Click()
    vSelectedItem = PaintingQuality_Other
End Sub
Private Sub TXTSandingMarks_Click()
    vSelectedItem = PaintingQuality_SandingMarks
End Sub
Private Sub TXTShrinkage_Click()
    vSelectedItem = PaintingQuality_Shrinkage
End Sub
Private Sub TXTThrough_Click()
    vSelectedItem = Polishing_Through
End Sub
Private Sub TXTTouchingUp_Click()
    vSelectedItem = Finishing_TouchingUp
End Sub

