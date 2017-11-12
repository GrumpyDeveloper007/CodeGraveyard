VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{B671DAA2-FC97-499C-B9A7-0549F8958881}#2.0#0"; "IngotListBoxCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMSelectPart 
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
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   255
      Left            =   15
      OleObjectBlob   =   "FRMSelectPart.frx":0000
      TabIndex        =   1
      Top             =   2130
      Width           =   615
   End
   Begin IngotListBoxCtl.AFListBox LSTParts 
      Height          =   1215
      Left            =   15
      OleObjectBlob   =   "FRMSelectPart.frx":0047
      TabIndex        =   2
      Top             =   210
      Width           =   1815
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPart 
      Height          =   195
      Left            =   30
      OleObjectBlob   =   "FRMSelectPart.frx":0087
      TabIndex        =   0
      Top             =   0
      Width           =   1695
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   255
      Left            =   1755
      OleObjectBlob   =   "FRMSelectPart.frx":00DF
      TabIndex        =   3
      Top             =   2130
      Width           =   615
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDescription 
      Height          =   195
      Left            =   30
      OleObjectBlob   =   "FRMSelectPart.frx":012A
      TabIndex        =   4
      Top             =   1560
      Width           =   1695
   End
   Begin IngotTextBoxCtl.AFTextBox TXTAdditional 
      Height          =   195
      Left            =   30
      OleObjectBlob   =   "FRMSelectPart.frx":0182
      TabIndex        =   5
      Top             =   1800
      Width           =   1695
   End
End
Attribute VB_Name = "FRMSelectPart"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDCancel_Click()
    Call FRMMain.Show
End Sub

Private Sub CMDOK_Click()
    PartName(MaxPartIndex) = TXTPart.Text
    Description(MaxPartIndex) = TXTDescription.Text
    Additional(MaxPartIndex) = TXTAdditional.Text
    Call FRMPartDetails.Show
    FRMPartDetails.OPTPartType(0).Value = True
    FRMPartDetails.TXTHour(0).SetFocus
End Sub

Private Sub Form_Load()
    Dim i As Integer
    Dim letter As String * 1
    PDBMoveFirst dbParts

'    GRDParts.Cols
    i = 0
    #If APPFORGE Then
    #Else
    Screen.MousePointer = vbHourglass
    #End If

    #If APPFORGE Then
    #Else
    Screen.MousePointer = vbDefault
    #End If
End Sub

Private Sub LSTParts_Click()
    If (LSTParts.ListIndex >= 0) Then
        TXTDescription.Text = Mid$(LSTParts.List(LSTParts.ListIndex), InStr(LSTParts.List(LSTParts.ListIndex), vbTab))
        TXTPart.Text = Left$(LSTParts.List(LSTParts.ListIndex), InStr(LSTParts.List(LSTParts.ListIndex), vbTab) - 1)
        Call TXTPart.SetFocus
    End If
End Sub

Private Sub TXTPart_Change()
    Dim i As Integer
    Dim TextLength As Byte
    TXTPart.Text = UCase$(TXTPart.Text)
    Call LSTParts.Clear
    TextLength = Len(TXTPart.Text)

    
    If (TextLength > 0) Then
        PartsRecord.ShortName = TXTPart.Text
        Call PDBMoveFirst(dbParts)
        Call PDBFindRecordByField(dbParts, tPartsDatabaseFields.ShortName_Field, PartsRecord.ShortName)
        Call PDBReadRecord(dbParts, VarPtr(PartsRecord))
        
        Do While (Left$(PartsRecord.ShortName, TextLength) = TXTPart.Text And PDBEOF(dbParts) = False)
            Call LSTParts.AddItem(PartsRecord.ShortName & vbTab & PartsRecord.LongName)
            Call PDBMoveNext(dbParts)
            Call PDBReadRecord(dbParts, VarPtr(PartsRecord))
        Loop
    End If
End Sub

