VERSION 5.00
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{F9885939-2FBB-491F-8EC3-DBC61CCFA7DB}#2.0#0"; "IngotGraphicCtl.dll"
Begin VB.Form FRMSelectTemplate 
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
   Begin IngotGraphicCtl.AFGraphic Pic 
      Height          =   330
      Index           =   0
      Left            =   120
      OleObjectBlob   =   "FRMSelectTemplate.frx":0000
      TabIndex        =   4
      Top             =   240
      Width           =   360
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMSelectTemplate.frx":0026
      TabIndex        =   3
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1890
      OleObjectBlob   =   "FRMSelectTemplate.frx":006D
      TabIndex        =   2
      Top             =   2160
      Width           =   510
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "FRMSelectTemplate.frx":00B6
      TabIndex        =   1
      Top             =   0
      Width           =   615
   End
   Begin IngotComboBoxCtl.AFComboBox CBOTemplate 
      Height          =   240
      Left            =   720
      OleObjectBlob   =   "FRMSelectTemplate.frx":00FF
      TabIndex        =   0
      Top             =   0
      Width           =   1215
   End
End
Attribute VB_Name = "FRMSelectTemplate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub DrawBox(pIndex As Long, px1 As Long, py1 As Long, px2 As Long, py2 As Long)
    px1 = px1 / FRMDesigner.Pic.Width * Pic(pIndex).Width
    py1 = py1 / FRMDesigner.Pic.Height * Pic(pIndex).Height
    px2 = px2 / FRMDesigner.Pic.Width * Pic(pIndex).Width
    py2 = py2 / FRMDesigner.Pic.Height * Pic(pIndex).Height
    Call Pic(pIndex).DrawRectangle(px1, py1, px2 - 1, py2 - 1, 0, False)
End Sub

Private Sub CMDExit_Click()
    Call Unload(Me)
    FRMDesigner.Show
End Sub



Private Sub CMDOK_Click()
    Select Case CBOTemplate.ListIndex
        Case 0
            FRMDesigner.ClearRegions
            Call FRMDesigner.AddRegion(0, 0, 80, 99, 0)
            Call FRMDesigner.AddRegion(80, 0, 139, 30, 4)
            Call FRMDesigner.AddRegion(80, 30, 139, 99, 0)
        Case 1
        Case 2
    End Select
    
    Call FRMDesigner.CompleteRegion
    Me.Hide
    FRMDesigner.Show
    FRMDesigner.ReDraw
End Sub

Private Sub Form_Load()
    CBOTemplate.AddItem ("Window")
    CBOTemplate.ItemData(CBOTemplate.ListCount - 1) = 1
    
    CBOTemplate.AddItem ("2")
    CBOTemplate.ItemData(CBOTemplate.ListCount - 1) = 1
    
    Call DrawBox(0, 0, 0, 80, 99)
    Call DrawBox(0, 80, 0, 139, 30)
    Call DrawBox(0, 80, 30, 139, 99)
End Sub

Private Sub Pic_Click(Index As Integer)
    CBOTemplate.ListIndex = 0
End Sub
