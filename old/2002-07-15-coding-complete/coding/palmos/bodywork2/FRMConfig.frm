VERSION 5.00
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMConfig 
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
      Left            =   1875
      OleObjectBlob   =   "FRMConfig.frx":0000
      TabIndex        =   3
      Top             =   2145
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "FRMConfig.frx":004B
      TabIndex        =   2
      Top             =   2145
      Width           =   510
   End
   Begin IngotComboBoxCtl.AFComboBox CBOEng 
      Height          =   240
      Left            =   480
      OleObjectBlob   =   "FRMConfig.frx":0092
      TabIndex        =   1
      Top             =   240
      Width           =   1815
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMConfig.frx":00D7
      TabIndex        =   0
      Top             =   270
      Width           =   345
   End
End
Attribute VB_Name = "FRMConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDCancel_Click()
    Call Unload(Me)
    Call FRMMain.Show
End Sub

Private Sub CMDOK_Click()
    Dim ConstRecord As tINSPConstRecord
    ConstRecord.Name = "INSPECTIONEMPLOYEE"
    ConstRecord.Value = vInspectionEmpolyee
    If (vInspectionEmpolyeeFound = True) Then
        Call PDBCreateRecordBySchema(dbINSPConst)
        Call PDBWriteRecord(dbINSPConst, VarPtr(ConstRecord))
        Call PDBUpdateRecord(dbINSPConst)
    Else
        Call PDBFindRecordbyID(dbINSPConst, vInspectionEmpolyeeRecordID)
        Call PDBEditRecord(dbINSPConst)
        Call PDBWriteRecord(dbINSPConst, VarPtr(ConstRecord))
        Call PDBUpdateRecord(dbINSPConst)
    End If
End Sub

Private Sub Form_Load()
    Dim i As Long
    Dim EngineerRecord As tInspEngRecord
    FRMConfig.CBOEng.Clear

    Call PDBMoveFirst(dbInspEng)
    Do While (PDBEOF(dbInspEng) = False)
        Call PDBReadRecord(dbInspEng, VarPtr(EngineerRecord))
        If (EngineerRecord.Type_ = "ES") Then
            Call FRMConfig.CBOEng.AddItem(EngineerRecord.Name)
            FRMConfig.CBOEng.ItemData(FRMConfig.CBOEng.ListCount - 1) = EngineerRecord.UID 'PDBRecordUniqueID(dbInspEng)
        End If
        Call PDBMoveNext(dbInspEng)
    Loop
    
    
    For i = 0 To FRMConfig.CBOEng.ListCount - 1
        If (FRMConfig.CBOEng.ItemData(i) = vInspectionEmpolyee) Then
            FRMConfig.CBOEng.ListIndex = i
            Exit For
        End If
    Next

End Sub
