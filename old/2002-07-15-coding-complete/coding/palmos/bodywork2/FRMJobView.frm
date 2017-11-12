VERSION 5.00
Object = "{447880A9-6A37-43B3-A92E-F125FFBE2493}#2.1#0"; "IngotGridCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMJobView 
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
   Begin IngotLabelCtl.AFLabel LBLReg 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMJobView.frx":0000
      TabIndex        =   9
      Top             =   0
      Width           =   2175
   End
   Begin IngotLabelCtl.AFLabel LBLYear 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMJobView.frx":0054
      TabIndex        =   8
      Top             =   720
      Width           =   2295
   End
   Begin IngotLabelCtl.AFLabel LBLColour 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMJobView.frx":00AD
      TabIndex        =   7
      Top             =   900
      Width           =   2295
   End
   Begin IngotLabelCtl.AFLabel LBLModel 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMJobView.frx":010A
      TabIndex        =   6
      Top             =   540
      Width           =   2295
   End
   Begin IngotButtonCtl.AFButton CMDShowCosts 
      Height          =   255
      Left            =   600
      OleObjectBlob   =   "FRMJobView.frx":0165
      TabIndex        =   5
      Top             =   2145
      Width           =   750
   End
   Begin IngotButtonCtl.AFButton CMDNewPart 
      Height          =   255
      Left            =   1455
      OleObjectBlob   =   "FRMJobView.frx":01B4
      TabIndex        =   4
      Top             =   2145
      Width           =   645
   End
   Begin IngotButtonCtl.AFButton CMDSave 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "FRMJobView.frx":0201
      TabIndex        =   3
      Top             =   2145
      Width           =   510
   End
   Begin IngotLabelCtl.AFLabel LBLMake 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMJobView.frx":024A
      TabIndex        =   2
      Top             =   360
      Width           =   2295
   End
   Begin IngotGridCtl.AFGrid AFGrid1 
      Height          =   735
      Left            =   0
      OleObjectBlob   =   "FRMJobView.frx":02A3
      TabIndex        =   1
      Top             =   1275
      Width           =   2400
   End
   Begin IngotLabelCtl.AFLabel LBLName 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMJobView.frx":02E9
      TabIndex        =   0
      Top             =   180
      Width           =   2175
   End
End
Attribute VB_Name = "FRMJobView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Public Sub RefreshGRD()
    Dim i As Integer
    GRDParts.Rows = 0
    Call GRDParts.AddItem("Code" & vbTab & "Description")
    GRDParts.RowHeight(0) = 12
    For i = 0 To MaxPartIndex - 1
        Call GRDParts.AddItem(PartName(i) & vbTab & Description(i))
        GRDParts.RowHeight(GRDParts.Rows - 1) = 12
    Next
End Sub



Private Sub CMDNewPart_Click()
    Call FRMSelectPart.Show
    FRMSelectPart.TXTPart.Text = ""
    FRMSelectPart.TXTDescription.Text = ""
    FRMSelectPart.TXTPart.SetFocus
End Sub

Private Sub CMDShowCosts_Click()
    Call FRMSummary.Show
    Call FRMSummary.CalculateCosts
End Sub

Private Sub Form_Load()
    Dim Reply As Boolean
    Call OpenBODYPartsDatabase
    Call PDBSetSort(dbBODYParts, tBODYPartsDatabaseFields.ShortName_Field)
    
    Call OpenParamDatabase
    GRDParts.ColWidth(0) = 41
    GRDParts.ColWidth(1) = 108
    Call RefreshGRD
'    ParamRecord.pName = "MODEL"
'    ParamRecord.pValue = "Fiesta"
'    Call PDBCreateRecordBySchema(dbParam)
'    Call PDBWriteRecord(dbParam, VarPtr(ParamRecord))
'    Call PDBUpdateRecord(dbParam)
    Call PDBMoveFirst(dbParam)


    #If APPFORGE Then
    #Else
    Screen.MousePointer = vbHourglass
    #End If
    
    Do While Not PDBEOF(dbParam)
        'Read record
        Call PDBReadRecord(dbParam, VarPtr(ParamRecord))
        If (ParamRecord.pName = "NAME") Then
            LBLName.Caption = "Name: " & ParamRecord.pValue
        Else
            If (ParamRecord.pName = "MAKE") Then
                LBLMake.Caption = "Make: " & ParamRecord.pValue
            Else
                If (ParamRecord.pName = "MODEL") Then
                    LBLModel.Caption = "Model: " & ParamRecord.pValue
                Else
                    If (ParamRecord.pName = "YEAR") Then
                        LBLYear.Caption = "Year: " & ParamRecord.pValue
                    Else
                        If (ParamRecord.pName = "COLOUR") Then
                            LBLColour.Caption = "Colour: " & ParamRecord.pValue
                        Else
                        
                        End If
                    
                    End If
                
                End If
            
            End If
        
        End If
        PDBMoveNext dbParam
    Loop

    #If APPFORGE Then
    #Else
    Screen.MousePointer = vbDefault
    #End If
    
'    BODYPartsRecord.LongName = "longname"
'    BODYPartsRecord.ShortName = "test"
'    Call PDBCreateRecordBySchema(dbBODYParts)
'    Reply = PDBWriteRecord(dbBODYParts, VarPtr(BODYPartsRecord))
'    Call PDBUpdateRecord(dbBODYParts)
'    MsgBox "ReadRecord Error = " & CStr(PDBGetLastError(dbBODYParts))
    'read data
End Sub

