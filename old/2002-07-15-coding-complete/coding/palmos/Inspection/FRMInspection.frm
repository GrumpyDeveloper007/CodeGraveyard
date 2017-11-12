VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{54171E73-16D6-4021-A96E-E59C0FE780E9}#2.0#0"; "IngotShapeCtl.dll"
Begin VB.Form FRMInspection1 
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
   Begin IngotTextBoxCtl.AFTextBox TXTFillerRepair 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":0000
      TabIndex        =   39
      Top             =   1740
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTAlignment 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspection.frx":0058
      TabIndex        =   42
      Top             =   1410
      Width           =   255
   End
   Begin IngotTextBoxCtl.AFTextBox TXTFitment 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspection.frx":00B0
      TabIndex        =   43
      Top             =   1245
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      DragMode        =   1  'Automatic
      Height          =   180
      Index           =   19
      Left            =   1155
      OleObjectBlob   =   "FRMInspection.frx":0108
      TabIndex        =   44
      Top             =   1245
      Width           =   915
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   1
      Left            =   1155
      OleObjectBlob   =   "FRMInspection.frx":015A
      TabIndex        =   41
      Top             =   1410
      Width           =   990
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   18
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":01AE
      TabIndex        =   40
      Top             =   1740
      Width           =   885
   End
   Begin IngotButtonCtl.AFButton CMDPageLeft 
      Height          =   210
      Left            =   555
      OleObjectBlob   =   "FRMInspection.frx":0200
      TabIndex        =   37
      Top             =   2190
      Visible         =   0   'False
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDPageRight 
      Height          =   210
      Left            =   810
      OleObjectBlob   =   "FRMInspection.frx":0246
      TabIndex        =   38
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   2
      Left            =   1575
      OleObjectBlob   =   "FRMInspection.frx":028C
      TabIndex        =   36
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   1
      Left            =   1335
      OleObjectBlob   =   "FRMInspection.frx":02D2
      TabIndex        =   35
      Top             =   2190
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDNumbers 
      Height          =   210
      Index           =   0
      Left            =   1080
      OleObjectBlob   =   "FRMInspection.frx":0318
      TabIndex        =   34
      Top             =   2190
      Width           =   225
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPannelOther 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspection.frx":035E
      TabIndex        =   13
      Top             =   1575
      Width           =   255
   End
   Begin IngotShapeCtl.AFShape SHAPE 
      Height          =   30
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":03B6
      TabIndex        =   32
      Top             =   195
      Width           =   2400
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":03EF
      TabIndex        =   14
      Top             =   2160
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMInspection.frx":0436
      TabIndex        =   31
      Top             =   2160
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTROther 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":0481
      TabIndex        =   12
      Top             =   1905
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   17
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":04D9
      TabIndex        =   30
      Top             =   1905
      Width           =   390
   End
   Begin IngotTextBoxCtl.AFTextBox TXTWaterIngress 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":0523
      TabIndex        =   11
      Top             =   1575
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   16
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":057B
      TabIndex        =   29
      Top             =   1575
      Width           =   855
   End
   Begin IngotTextBoxCtl.AFTextBox TXTSealWaxing 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":05CD
      TabIndex        =   10
      Top             =   1410
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   15
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":0625
      TabIndex        =   28
      Top             =   1410
      Width           =   885
   End
   Begin IngotTextBoxCtl.AFTextBox TXTWeldQuality 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":0675
      TabIndex        =   9
      Top             =   1245
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   14
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":06CD
      TabIndex        =   27
      Top             =   1245
      Width           =   810
   End
   Begin IngotTextBoxCtl.AFTextBox TXTEOther 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspection.frx":071E
      TabIndex        =   8
      Top             =   870
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   12
      Left            =   1155
      OleObjectBlob   =   "FRMInspection.frx":0776
      TabIndex        =   25
      Top             =   870
      Width           =   390
   End
   Begin IngotTextBoxCtl.AFTextBox TXTLightBulb 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspection.frx":07C0
      TabIndex        =   7
      Top             =   705
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   11
      Left            =   1155
      OleObjectBlob   =   "FRMInspection.frx":0818
      TabIndex        =   24
      Top             =   705
      Width           =   660
   End
   Begin IngotTextBoxCtl.AFTextBox TXTConnection 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspection.frx":0867
      TabIndex        =   6
      Top             =   540
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   10
      Left            =   1155
      OleObjectBlob   =   "FRMInspection.frx":08BF
      TabIndex        =   23
      Top             =   540
      Width           =   690
   End
   Begin IngotTextBoxCtl.AFTextBox TXTWiring 
      Height          =   180
      Left            =   2145
      OleObjectBlob   =   "FRMInspection.frx":090E
      TabIndex        =   5
      Top             =   375
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   9
      Left            =   1155
      OleObjectBlob   =   "FRMInspection.frx":0966
      TabIndex        =   22
      Top             =   375
      Width           =   405
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   8
      Left            =   1260
      OleObjectBlob   =   "FRMInspection.frx":09B1
      TabIndex        =   21
      Top             =   210
      Width           =   735
   End
   Begin IngotTextBoxCtl.AFTextBox TXTOther 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":0A00
      TabIndex        =   4
      Top             =   870
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   7
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":0A58
      TabIndex        =   20
      Top             =   870
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTNotWorking 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":0AA2
      TabIndex        =   3
      Top             =   705
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   6
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":0AFA
      TabIndex        =   19
      Top             =   705
      Width           =   765
   End
   Begin IngotTextBoxCtl.AFTextBox TXTWrongPart 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":0B4A
      TabIndex        =   2
      Top             =   540
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   5
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":0BA2
      TabIndex        =   18
      Top             =   540
      Width           =   705
   End
   Begin IngotTextBoxCtl.AFTextBox TXTInsecure 
      Height          =   180
      Left            =   870
      OleObjectBlob   =   "FRMInspection.frx":0BF1
      TabIndex        =   1
      Top             =   375
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   4
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":0C49
      TabIndex        =   17
      Top             =   375
      Width           =   510
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":0C96
      TabIndex        =   16
      Top             =   210
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTReg 
      Height          =   195
      Left            =   240
      OleObjectBlob   =   "FRMInspection.frx":0CE0
      TabIndex        =   0
      Top             =   0
      Width           =   870
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":0D38
      TabIndex        =   15
      Top             =   0
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   2
      Left            =   1155
      OleObjectBlob   =   "FRMInspection.frx":0D80
      TabIndex        =   33
      Top             =   1575
      Width           =   885
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   13
      Left            =   0
      OleObjectBlob   =   "FRMInspection.frx":0DD1
      TabIndex        =   26
      Top             =   1080
      Width           =   990
   End
End
Attribute VB_Name = "FRMInspection1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Enum CurrentSelectionENUM
    Reg = 0
    Part_Insecure = 1
    Part_WrongPart = 2
    Part_NotWorking = 3
    Part_Other = 4
    Electrical_Wiring = 5
    Electrical_Connection = 6
    Electrical_LightBulb = 7
    Electrical_Other = 8
    RepairQuality_WeldQuality = 9
    RepairQuality_SealWaxing = 10
    RepairQuality_WaterIngress = 11
    RepairQuality_Other = 12
    Panel_Other = 13
    Filler_Repair = 14
    Panel_fitment = 15
    Panel_alignment = 16
End Enum

Private vSelectedItem As CurrentSelectionENUM

''
Private Sub CMDCancel_Click()
    FRMInspection1.Hide
    FRMInspectionPaint.Hide
    FRMInspection3.Hide
    FRMMain.RefreshScreen
End Sub

''
Private Sub CMDNumbers_Click(Index As Integer)
    Select Case vSelectedItem
        Case Reg
            TXTReg.Text = TXTReg.Text & Index
            Call TXTReg.SetFocus
        Case Part_Insecure
            TXTInsecure.Text = Index
            TXTInsecure.SetFocus
        Case Part_WrongPart
            TXTWrongPart.Text = Index
            TXTWrongPart.SetFocus
        Case Part_NotWorking
            TXTNotWorking.Text = Index
            TXTNotWorking.SetFocus
        Case Part_Other
            TXTOther.Text = Index
            TXTOther.SetFocus
        Case Electrical_Wiring
            TXTWiring.Text = Index
            TXTWiring.SetFocus
        Case Electrical_Connection
            TXTConnection.Text = Index
            TXTConnection.SetFocus
        Case Electrical_LightBulb
            TXTLightBulb.Text = Index
            TXTLightBulb.SetFocus
        Case Electrical_Other
            TXTEOther.Text = Index
            TXTEOther.SetFocus
        Case RepairQuality_WeldQuality
            TXTWeldQuality.Text = Index
            TXTWeldQuality.SetFocus
        Case RepairQuality_SealWaxing
            TXTSealWaxing.Text = Index
            TXTSealWaxing.SetFocus
        Case RepairQuality_WaterIngress
            TXTWaterIngress.Text = Index
            TXTWaterIngress.SetFocus
        Case RepairQuality_Other
            TXTROther.Text = Index
            TXTROther.SetFocus
        Case Panel_Other
            TXTPannelOther.Text = Index
            TXTPannelOther.SetFocus
        Case Filler_Repair
            TXTFillerRepair.Text = Index
            TXTFillerRepair.SetFocus
        Case Panel_fitment
            TXTFitment.Text = Index
            TXTFitment.SetFocus
        Case Panel_alignment
            TXTAlignment.Text = Index
            TXTAlignment.SetFocus
    End Select
End Sub

''
Public Sub CMDOK_Click()
    Call SaveDetails
End Sub

''
Private Sub CMDPageRight_Click()
    Me.Hide
    FRMInspectionPaint.Show
'    FRMInspection.TXTAdditional.SetFocus
End Sub

Private Sub Form_Load()

End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Input validatation
Private Sub TXTAlignment_Change()
    TXTAlignment.Text = RemoveNonNumericCharacters(TXTAlignment.Text, 2)
End Sub
Private Sub TXTFillerRepair_Change()
    TXTFillerRepair.Text = RemoveNonNumericCharacters(TXTFillerRepair.Text, 2)
End Sub
Private Sub TXTFitment_Change()
    TXTFitment.Text = RemoveNonNumericCharacters(TXTFitment.Text, 2)
End Sub
Private Sub TXTReg_Change()
    TXTReg.Text = UCase$(TXTReg.Text)
End Sub
Private Sub TXTConnection_Change()
    TXTConnection.Text = RemoveNonNumericCharacters(TXTConnection.Text, 2)
End Sub
Private Sub TXTEOther_Change()
    TXTEOther.Text = RemoveNonNumericCharacters(TXTEOther.Text, 2)
End Sub
Private Sub TXTInsecure_Change()
    TXTInsecure.Text = RemoveNonNumericCharacters(TXTInsecure.Text, 2)
End Sub
Private Sub TXTLightBulb_Change()
    TXTLightBulb.Text = RemoveNonNumericCharacters(TXTLightBulb.Text, 2)
End Sub
Private Sub TXTNotWorking_Change()
    TXTNotWorking.Text = RemoveNonNumericCharacters(TXTNotWorking.Text, 2)
End Sub
Private Sub TXTOther_Change()
    TXTOther.Text = RemoveNonNumericCharacters(TXTOther.Text, 2)
End Sub
Private Sub TXTPannelOther_Change()
    TXTPannelOther.Text = RemoveNonNumericCharacters(TXTPannelOther.Text, 2)
End Sub
Private Sub TXTROther_Change()
    TXTROther.Text = RemoveNonNumericCharacters(TXTROther.Text, 2)
End Sub
Private Sub TXTSealWaxing_Change()
    TXTSealWaxing.Text = RemoveNonNumericCharacters(TXTSealWaxing.Text, 2)
End Sub
Private Sub TXTWaterIngress_Change()
    TXTWaterIngress.Text = RemoveNonNumericCharacters(TXTWaterIngress.Text, 2)
End Sub
Private Sub TXTWeldQuality_Change()
    TXTWeldQuality.Text = RemoveNonNumericCharacters(TXTWeldQuality.Text, 2)
End Sub
Private Sub TXTWiring_Change()
    TXTWiring.Text = RemoveNonNumericCharacters(TXTWiring.Text, 2)
End Sub
Private Sub TXTWrongPart_Change()
    TXTWrongPart.Text = RemoveNonNumericCharacters(TXTWrongPart.Text, 2)
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Focus change 2
Private Sub TXTAlignment_Click()
    vSelectedItem = Panel_alignment
End Sub
Private Sub TXTConnection_Click()
    vSelectedItem = Electrical_Connection
End Sub

Private Sub TXTEOther_Click()
    vSelectedItem = Electrical_Other
End Sub
Private Sub TXTFillerRepair_Click()
    vSelectedItem = Filler_Repair
End Sub
Private Sub TXTFitment_Click()
    vSelectedItem = Panel_fitment
End Sub
Private Sub TXTInsecure_Click()
    vSelectedItem = Part_Insecure
End Sub
Private Sub TXTLightBulb_Click()
    vSelectedItem = Electrical_LightBulb
End Sub
Private Sub TXTNotWorking_Click()
    vSelectedItem = Part_NotWorking
End Sub
Private Sub TXTOther_Click()
    vSelectedItem = Part_Other
End Sub
Private Sub TXTPannelOther_Click()
    vSelectedItem = Panel_Other
End Sub
Private Sub TXTReg_Click()
    vSelectedItem = Reg
End Sub
Private Sub TXTROther_Click()
    vSelectedItem = RepairQuality_Other
End Sub
Private Sub TXTSealWaxing_Click()
    vSelectedItem = RepairQuality_SealWaxing
End Sub
Private Sub TXTWaterIngress_Click()
    vSelectedItem = RepairQuality_WaterIngress
End Sub
Private Sub TXTWeldQuality_Click()
    vSelectedItem = RepairQuality_WeldQuality
End Sub
Private Sub TXTWiring_Click()
    vSelectedItem = Electrical_Wiring
End Sub
Private Sub TXTWrongPart_Click()
    vSelectedItem = Part_WrongPart
End Sub

