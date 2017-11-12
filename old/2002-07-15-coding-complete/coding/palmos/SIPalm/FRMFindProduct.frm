VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{B671DAA2-FC97-499C-B9A7-0549F8958881}#2.1#0"; "IngotListBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMFindProduct 
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
   Begin IngotLabelCtl.AFLabel LBLVAT 
      Height          =   180
      Left            =   1245
      OleObjectBlob   =   "FRMFindProduct.frx":0000
      TabIndex        =   6
      Top             =   2175
      Width           =   570
   End
   Begin IngotLabelCtl.AFLabel LBLUnitCost 
      Height          =   180
      Left            =   525
      OleObjectBlob   =   "FRMFindProduct.frx":004A
      TabIndex        =   5
      Top             =   2175
      Width           =   690
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMFindProduct.frx":0094
      TabIndex        =   4
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMFindProduct.frx":00DB
      TabIndex        =   3
      Top             =   2160
      Width           =   495
   End
   Begin IngotListBoxCtl.AFListBox LSTProduct 
      Height          =   1530
      Left            =   0
      OleObjectBlob   =   "FRMFindProduct.frx":0126
      TabIndex        =   2
      Top             =   570
      Width           =   2400
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDescription 
      Height          =   315
      Left            =   0
      OleObjectBlob   =   "FRMFindProduct.frx":016A
      TabIndex        =   1
      Top             =   225
      Width           =   2400
   End
   Begin IngotTextBoxCtl.AFTextBox TXTProduct 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "FRMFindProduct.frx":01C2
      TabIndex        =   0
      Top             =   0
      Width           =   2400
   End
End
Attribute VB_Name = "FRMFindProduct"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

''
Public Sub Search(pProduct As String, pDescription As String)
    TXTDescription.Text = pDescription
    LBLUnitCost.Caption = "Unit Cost: "
    LBLVAT.Caption = "VAT: "
    
    Me.Show
    Dim LocalProductRecord As tProductRecord
    Dim i As Integer
    
    TXTProduct.Text = ""
    Call LSTProduct.Clear
    Call PDBMoveFirst(dbProduct)
    Call PDBReadRecord(dbProduct, VarPtr(LocalProductRecord))
    Do While (PDBEOF(dbProduct) = False)
        Call LSTProduct.AddItem(LocalProductRecord.Name & vbTab & LocalProductRecord.Description)
        Call PDBMoveNext(dbProduct)
        Call PDBReadRecord(dbProduct, VarPtr(LocalProductRecord))
    Loop
    
    TXTProduct.Text = pProduct
    Call TXTProduct.SetFocus
End Sub

''
Private Sub CMDCancel_Click()
    Call Me.Hide
    Call FRMEstimate.Show
End Sub

''
Private Sub CMDOK_Click()
    ProductRecord.Name = TXTProduct.Text
    ProductRecord.Description = TXTDescription.Text
    Call Me.Hide
    Call FRMEstimate.Show
    Call FRMEstimate.SendChildInactive
End Sub

Private Sub Form_Load()

End Sub

''
Private Sub LSTProduct_Click()
    If (LSTProduct.ListIndex >= 0) Then
        ProductRecord.Name = Left$(LSTProduct.List(LSTProduct.ListIndex), InStr(LSTProduct.List(LSTProduct.ListIndex), vbTab) - 1)
        TXTProduct.Text = ProductRecord.Name
        
        'tProductDatabaseFields.Name_Field
        Call PDBFindRecordByField(dbProduct, 1, ProductRecord.Name)
'        Call PDBMoveNext(dbProduct)
        Call PDBReadRecord(dbProduct, VarPtr(ProductRecord))
        
        TXTDescription.Text = ProductRecord.Description
        LBLUnitCost.Caption = "Unit:" & ProductRecord.NetCost / 100
        LBLVAT.Caption = "VAT:" & ProductRecord.VatPercent / 100
        Call TXTProduct.SetFocus
    End If
End Sub

''
Private Sub TXTProduct_Change()
    Dim LocalProductRecord As tProductRecord
    Dim i As Integer
    Dim TextLength As Byte
    Dim ProductName As String
    
    TXTProduct.Text = UCase$(TXTProduct.Text)
    
    ProductName = TXTProduct.Text
    Call LSTProduct.Clear
    TextLength = Len(ProductName)

    
    If (TextLength > 0) Then
        Call PDBMoveFirst(dbProduct)
        'tProductDatabaseFields.Name_Field
        Call PDBFindRecordByField(dbProduct, 2, ProductName)
        Call PDBReadRecord(dbProduct, VarPtr(LocalProductRecord))
        Do While (Left$(LocalProductRecord.Name, TextLength) < ProductName And PDBEOF(dbProduct) = False)
            Call PDBMoveNext(dbProduct)
            Call PDBReadRecord(dbProduct, VarPtr(LocalProductRecord))
        Loop
        
        Do While (PDBEOF(dbProduct) = False And Left$(LocalProductRecord.Name, TextLength) = ProductName)
            If (Left$(LocalProductRecord.Name, TextLength) = ProductName) Then
                Call LSTProduct.AddItem(LocalProductRecord.Name & vbTab & LocalProductRecord.Description)
            End If
            Call PDBMoveNext(dbProduct)
            Call PDBReadRecord(dbProduct, VarPtr(LocalProductRecord))
        Loop
    End If
End Sub
