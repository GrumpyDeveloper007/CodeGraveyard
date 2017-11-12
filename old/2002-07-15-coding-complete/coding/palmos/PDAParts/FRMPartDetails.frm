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
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   255
      Left            =   1770
      OleObjectBlob   =   "FRMPartDetails.frx":0000
      TabIndex        =   0
      Top             =   2130
      Width           =   615
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "FRMPartDetails.frx":004B
      TabIndex        =   1
      Top             =   2130
      Width           =   615
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
        TXTHour(vFocusIndex).Text = Index
    Else
        TXTFraction(vFocusIndex).Text = Index
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
    Call FRMMain.refreshGRD
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
