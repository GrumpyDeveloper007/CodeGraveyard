VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{B671DAA2-FC97-499C-B9A7-0549F8958881}#2.1#0"; "IngotListBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{54171E73-16D6-4021-A96E-E59C0FE780E9}#2.0#0"; "IngotShapeCtl.dll"
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
   Begin IngotButtonCtl.AFButton CMDConfigEngineer 
      Height          =   210
      Left            =   2100
      OleObjectBlob   =   "Main.frx":0000
      TabIndex        =   11
      Top             =   1560
      Visible         =   0   'False
      Width           =   225
   End
   Begin IngotButtonCtl.AFButton CMDDelete 
      Height          =   210
      Left            =   2100
      OleObjectBlob   =   "Main.frx":0046
      TabIndex        =   10
      Top             =   1275
      Width           =   225
   End
   Begin IngotShapeCtl.AFShape SHAPE 
      Height          =   30
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "Main.frx":008C
      TabIndex        =   9
      Top             =   225
      Width           =   2400
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDate 
      Height          =   195
      Left            =   345
      OleObjectBlob   =   "Main.frx":00C5
      TabIndex        =   8
      Top             =   0
      Width           =   960
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "Main.frx":011D
      TabIndex        =   7
      Top             =   0
      Width           =   375
   End
   Begin IngotListBoxCtl.AFListBox LSTCompletedInspections 
      Height          =   795
      Left            =   0
      OleObjectBlob   =   "Main.frx":0166
      TabIndex        =   6
      Top             =   1260
      Width           =   2055
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "Main.frx":01AA
      TabIndex        =   5
      Top             =   1065
      Width           =   1455
   End
   Begin IngotListBoxCtl.AFListBox LSTNewInspections 
      Height          =   615
      Left            =   0
      OleObjectBlob   =   "Main.frx":0204
      TabIndex        =   4
      Top             =   435
      Width           =   2055
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "Main.frx":0248
      TabIndex        =   3
      Top             =   255
      Width           =   1095
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1890
      OleObjectBlob   =   "Main.frx":029C
      TabIndex        =   0
      Top             =   2160
      Width           =   510
   End
   Begin IngotButtonCtl.AFButton CMDViewInspection 
      Height          =   240
      Left            =   705
      OleObjectBlob   =   "Main.frx":02E5
      TabIndex        =   1
      Top             =   2160
      Width           =   615
   End
   Begin IngotButtonCtl.AFButton CMDNewInspection 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "Main.frx":0333
      TabIndex        =   2
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

Private Sub CMDConfigEngineer_Click()
'    FRMConfigEngineer.Show
'    FRMConfigEngineer.RefreshScreen
End Sub

Private Sub CMDDelete_Click()
    Call PDBFindRecordbyID(dbInspdata, LSTCompletedInspections.ItemData(LSTCompletedInspections.ListIndex))
    Call PDBDeleteRecord(dbInspdata)
    Call RefreshScreen
End Sub

Private Sub CMDExit_Click()
    End
End Sub

Private Sub CMDNewPart_Click()
End Sub

Private Sub CMDNewInspection_Click()
    vDate = CDate(TXTDate.Text)
    Call NewInspection
End Sub

Private Sub CMDViewInspection_Click()
    If (LSTCompletedInspections.ListIndex >= 0) Then
        vDate = CDate(TXTDate.Text)
        Call ViewInspection(LSTCompletedInspections.List(LSTCompletedInspections.ListIndex))
    End If
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
    Dim Reply As Boolean
    
    FRMMain.Show
    
    Call OpenInspdataDatabase
    Call OpenInspEngDatabase
    Call OpenINSPMakeDatabase
    Call OpenINSPModelDatabase
    Call PDBSetSort(dbInspEng, tInspEngDatabaseFields.Name_Field)
    Call PDBSetSort(dbINSPMake, tINSPMakeDatabaseFields.UID_Field)
    Call PDBSetSort(dbINSPMake, tINSPMakeDatabaseFields.Name_Field)
    Call PDBSetSort(dbINSPModel, tINSPModelDatabaseFields.MakeID_Field)
    
    Call FRMMain.RefreshScreen
    Call LoadCBO
    
    FRMMain.TXTDate.Text = Date
'    Call OpenParamDatabase
    
    ' Load screens
    FRMInspection1.Show
    FRMInspection1.Hide
    FRMInspectionPaint.Show
    FRMInspectionPaint.Hide
    FRMInspection3.Show
    FRMInspection3.Hide
    
End Sub

Private Sub LBLLoading_Click()

End Sub

Private Sub LBLLoading_GotFocus()

End Sub
