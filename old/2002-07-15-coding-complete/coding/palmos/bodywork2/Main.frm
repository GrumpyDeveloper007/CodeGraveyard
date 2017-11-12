VERSION 5.00
Object = "{B671DAA2-FC97-499C-B9A7-0549F8958881}#2.1#0"; "IngotListBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
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
   Begin IngotListBoxCtl.AFListBox LSTCompletedInspections 
      Height          =   795
      Left            =   0
      OleObjectBlob   =   "Main.frx":0000
      TabIndex        =   4
      Top             =   1305
      Width           =   2055
   End
   Begin IngotListBoxCtl.AFListBox LSTNewInspections 
      Height          =   615
      Left            =   0
      OleObjectBlob   =   "Main.frx":0044
      TabIndex        =   6
      Top             =   480
      Width           =   2055
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "Main.frx":0088
      TabIndex        =   7
      Top             =   300
      Width           =   1095
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "Main.frx":00DC
      TabIndex        =   5
      Top             =   1110
      Width           =   1455
   End
   Begin IngotLabelCtl.AFLabel LBLEngineer 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "Main.frx":0136
      TabIndex        =   3
      Top             =   0
      Width           =   2175
   End
   Begin IngotButtonCtl.AFButton CMDView 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "Main.frx":0184
      TabIndex        =   2
      Top             =   2145
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDConfig 
      Height          =   255
      Left            =   855
      OleObjectBlob   =   "Main.frx":01CD
      TabIndex        =   1
      Top             =   2145
      Width           =   285
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   255
      Left            =   1890
      OleObjectBlob   =   "Main.frx":0213
      TabIndex        =   0
      Top             =   2145
      Width           =   510
   End
End
Attribute VB_Name = "FRMMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit


Private Sub CMDConfig_Click()
    Call FRMConfig.Show
End Sub

Private Sub CMDExit_Click()
    End
End Sub


Public Sub RefreshScreen()
    Dim InspectionRecord As tInspdataRecord
    Call PDBSetSort(dbInspdata, tInspdataDatabaseFields.Registration_Field)
    
    Call PDBMoveFirst(dbInspdata)
    LSTCompletedInspections.Clear
    Do While (PDBEOF(dbInspdata) = False)
        Call PDBReadRecord(dbInspdata, VarPtr(InspectionRecord))
        If (InspectionRecord.Completed = True) Then
            Call LSTCompletedInspections.AddItem(InspectionRecord.Registration)
            LSTCompletedInspections.ItemData(LSTCompletedInspections.ListCount - 1) = PDBRecordUniqueID(dbInspdata)
        Else
            Call LSTNewInspections.AddItem(InspectionRecord.Registration)
            LSTNewInspections.ItemData(LSTNewInspections.ListCount - 1) = PDBRecordUniqueID(dbInspdata)
        End If
        Call PDBMoveNext(dbInspdata)
    Loop
    Me.Show
End Sub

Private Sub Form_Load()
    Dim ConstRecord As tINSPConstRecord
    Call OpenInspEngDatabase
    Call OpenINSPConstDatabase
    Call OpenELF3EstimateDatabase
    Call OpenELF3EstimatePartDatabase

    Call PDBMoveFirst(dbINSPConst)
    Call PDBReadRecord(dbINSPConst, VarPtr(ConstRecord))
    vInspectionEmpolyeeFound = False
    Do While (PDBEOF(dbINSPConst) = False)
        If (ConstRecord.Name = "INSPECTIONEMPLOYEE") Then
            vInspectionEmpolyeeRecordID = PDBRecordUniqueID(dbINSPConst)
            vInspectionEmpolyee = CLng(ConstRecord.Value)
            vInspectionEmpolyeeFound = True
        End If
        Call PDBMoveNext(dbINSPConst)
        Call PDBReadRecord(dbINSPConst, VarPtr(ConstRecord))
    Loop

End Sub
