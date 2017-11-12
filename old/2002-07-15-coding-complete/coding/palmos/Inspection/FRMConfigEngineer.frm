VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{B671DAA2-FC97-499C-B9A7-0549F8958881}#2.1#0"; "IngotListBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMConfigEngineer 
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
   Begin IngotTextBoxCtl.AFTextBox TXTUID 
      Height          =   195
      Left            =   780
      OleObjectBlob   =   "FRMConfigEngineer.frx":0000
      TabIndex        =   10
      Top             =   0
      Width           =   555
   End
   Begin IngotButtonCtl.AFButton CMDClear 
      Height          =   240
      Left            =   1440
      OleObjectBlob   =   "FRMConfigEngineer.frx":0058
      TabIndex        =   9
      Top             =   2160
      Width           =   255
   End
   Begin IngotButtonCtl.AFButton CMDDelete 
      Height          =   240
      Left            =   720
      OleObjectBlob   =   "FRMConfigEngineer.frx":009F
      TabIndex        =   8
      Top             =   2160
      Width           =   615
   End
   Begin IngotButtonCtl.AFButton CMDCreate 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMConfigEngineer.frx":00EA
      TabIndex        =   7
      Top             =   2160
      Width           =   615
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1890
      OleObjectBlob   =   "FRMConfigEngineer.frx":0136
      TabIndex        =   6
      Top             =   2160
      Width           =   510
   End
   Begin IngotTextBoxCtl.AFTextBox TXTShortName 
      Height          =   195
      Left            =   780
      OleObjectBlob   =   "FRMConfigEngineer.frx":017F
      TabIndex        =   4
      Top             =   420
      Width           =   555
   End
   Begin IngotTextBoxCtl.AFTextBox TXTName 
      Height          =   195
      Left            =   780
      OleObjectBlob   =   "FRMConfigEngineer.frx":01D7
      TabIndex        =   2
      Top             =   210
      Width           =   1545
   End
   Begin IngotListBoxCtl.AFListBox LSTEngineer 
      Height          =   1230
      Left            =   0
      OleObjectBlob   =   "FRMConfigEngineer.frx":022F
      TabIndex        =   0
      Top             =   885
      Width           =   2055
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMConfigEngineer.frx":0273
      TabIndex        =   1
      Top             =   705
      Width           =   1095
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMConfigEngineer.frx":02C1
      TabIndex        =   3
      Top             =   210
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMConfigEngineer.frx":030A
      TabIndex        =   5
      Top             =   420
      Width           =   825
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMConfigEngineer.frx":0359
      TabIndex        =   11
      Top             =   0
      Width           =   330
   End
End
Attribute VB_Name = "FRMConfigEngineer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private EngineerRecord As tInspEngRecord
Private vNewRecord As Boolean

Private Sub CMDClear_Click()
    TXTName.Text = ""
    TXTShortName.Text = ""
    CMDCreate.Caption = "Create"
    vNewRecord = True
End Sub

Private Sub CMDCreate_Click()
    On Error GoTo UIDFormatError
    EngineerRecord.UID = CLng(TXTUID.Text)
    On Error GoTo 0
    EngineerRecord.Name = TXTName.Text
    EngineerRecord.ShortName = TXTShortName.Text

    If (vNewRecord = True) Then
        Call PDBCreateRecordBySchema(dbInspEng)
        Call PDBWriteRecord(dbInspEng, VarPtr(EngineerRecord))
        Call PDBUpdateRecord(dbInspEng)
    Else
'        Call PDBFindRecordbyID(dbEngineer, vCurrentRecordID)
        Call PDBEditRecord(dbInspEng)
        Call PDBWriteRecord(dbInspEng, VarPtr(EngineerRecord))
        Call PDBUpdateRecord(dbInspEng)
    End If
    Call RefreshScreen
UIDFormatError:
    Call MsgBox("UID must be unique/numeric.")
End Sub

Private Sub CMDDelete_Click()
    If (LSTEngineer.ListIndex >= 0) Then
        Call PDBDeleteRecord(dbInspEng)
    End If
    Call RefreshScreen
End Sub

Private Sub CMDExit_Click()
    Me.Hide
    FRMMain.RefreshScreen
    Call RefreshScreen
End Sub

Public Sub RefreshScreen()
    Call PDBMoveFirst(dbInspEng)
    LSTEngineer.Clear
    TXTUID.Text = ""
    TXTName.Text = ""
    TXTShortName.Text = ""
    vNewRecord = True
    Do While (PDBEOF(dbInspEng) = False)
        Call PDBReadRecord(dbInspEng, VarPtr(EngineerRecord))
        Call LSTEngineer.AddItem(EngineerRecord.Name)
        LSTEngineer.ItemData(LSTEngineer.ListCount - 1) = PDBRecordUniqueID(dbInspEng)
        Call PDBMoveNext(dbInspEng)
    Loop
    CMDCreate.Caption = "Create"
    Call TXTUID.SetFocus
End Sub

Private Sub Form_Load()
'    Call RefreshScreen
End Sub

Private Sub LSTEngineer_Click()
    Call PDBFindRecordbyID(dbInspEng, LSTEngineer.ItemData(LSTEngineer.ListIndex))
    Call PDBReadRecord(dbInspEng, VarPtr(EngineerRecord))
    vNewRecord = False
    CMDCreate.Caption = "Update"
    TXTUID.Text = EngineerRecord.UID
    TXTName.Text = EngineerRecord.Name
    TXTShortName.Text = EngineerRecord.ShortName
    Call TXTName.SetFocus
'    Call RefreshScreen
End Sub

Private Sub TXTName_Change()
    TXTName.Text = UCase$(TXTName.Text)
End Sub

Private Sub TXTShortName_Change()
    TXTShortName.Text = UCase$(TXTShortName.Text)
End Sub
