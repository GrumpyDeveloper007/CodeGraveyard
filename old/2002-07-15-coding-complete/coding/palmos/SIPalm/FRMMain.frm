VERSION 5.00
Object = "{447880A9-6A37-43B3-A92E-F125FFBE2493}#2.0#0"; "IngotGridCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form frmMain 
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
   Begin IngotGridCtl.AFGrid GRDAddress 
      Height          =   1875
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":0000
      TabIndex        =   5
      Top             =   0
      Width           =   2400
   End
   Begin IngotButtonCtl.AFButton CMDInvoice 
      Height          =   240
      Left            =   720
      OleObjectBlob   =   "FRMMain.frx":0046
      TabIndex        =   4
      Top             =   2160
      Width           =   615
   End
   Begin IngotButtonCtl.AFButton CMDEstimate 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":0092
      TabIndex        =   3
      Top             =   2160
      Width           =   615
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMMain.frx":00DF
      TabIndex        =   2
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton btnDetails 
      Height          =   210
      Left            =   1695
      OleObjectBlob   =   "FRMMain.frx":0128
      TabIndex        =   0
      Top             =   1920
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton btnNew 
      Height          =   210
      Left            =   1170
      OleObjectBlob   =   "FRMMain.frx":0174
      TabIndex        =   1
      Top             =   1920
      Width           =   495
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit
Private Dirtyitem As Long

Private Sub btnDetails_Click()
    Dim IntCounter As Integer

    Dirtyitem = GRDAddress.Row
    PDBFindRecordbyID AddressDB, GRDAddress.ItemData(GRDAddress.Row, 0)
    ReadAddressRecord DetailsRecord
    
    frmDetails.btnEdit.Visible = True
    frmDetails.btnSave.Visible = False
    For IntCounter = 1 To 3
        frmDetails.cmbPhoneType(IntCounter).Enabled = False
    Next IntCounter
    
    Me.Hide
    frmDetails.Initialize
    frmDetails.Show

End Sub

Private Sub btnNew_Click()
    Dirtyitem = -1
    bNewRecord = True
    Me.Hide
    Load frmNew
    frmNew.Show

End Sub


Private Sub CMDEstimate_Click()
    Call FRMEstimate.Search(1)
End Sub

Private Sub CMDExit_Click()
    End
End Sub

Private Sub CMDInvoice_Click()
    Call FRMEstimate.Search(0)
End Sub

Private Sub Form_Load()
    'Open the database
    vLastInvoiceID = 1
    Call OpenProductDatabase
    Call OpenELF2InvoiceDatabase
    Call OpenELF2LineDatabase
    Call OpenELF2StaticDatabase
    Call OpenAddressDB
    
    GRDAddress.ColWidth(0) = 49
    GRDAddress.ColWidth(1) = 100
    GRDAddress.RowHeight(0) = 12
    
    Call PDBSetSortFields(dbProduct, 2) 'tProductDatabaseFields.Name_Field
    Call PDBSetSortFields(dbProduct, 1) 'tProductDatabaseFields.Name_Field
    
'    Do While (PDBEOF(dbELF2Invoice) = False)
'        Call PDBReadRecord(dbELF2Invoice, VarPtr(InvoiceRecord))
'        If (vLastInvoiceID < InvoiceRecord.UID) Then
'            vLastInvoiceID = InvoiceRecord.UID
'        End If
'        Call PDBMoveNext(dbELF2Invoice)
'    Loop
    Dirtyitem = -2
    Call Initialize
End Sub

Public Sub Initialize()
    If Dirtyitem = -2 Then
        GRDAddress.Rows = 0
    
        ' Goto to the first record and read it
        PDBMoveFirst AddressDB
    
        While Not PDBEOF(AddressDB)
            'Read record
            ReadAddressRecord DetailsRecord
    
            'Display Name, First Name, and PhoneType1
            GRDAddress.AddItem DetailsRecord.FirstName & " " & DetailsRecord.Name & Chr(9) & DetailsRecord.Company & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & DetailsRecord.Phone1, -1
            GRDAddress.ItemData(GRDAddress.Rows - 1, 0) = PDBRecordUniqueID(AddressDB)
            GRDAddress.RowHeight(GRDAddress.Rows - 1) = 12
            PDBMoveNext AddressDB
        Wend
    Else
        If Dirtyitem <> -1 Then
            GRDAddress.RemoveItem Dirtyitem
        End If
        'Read record
        ReadAddressRecord DetailsRecord
    
        'Display Name, First Name, and PhoneType1
        GRDAddress.AddItem DetailsRecord.FirstName & " " & DetailsRecord.Name & Chr(9) & DetailsRecord.Company & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & Chr(9) & DetailsRecord.Phone1, -1
        GRDAddress.ItemData(GRDAddress.Rows - 1, 0) = PDBRecordUniqueID(AddressDB)
        GRDAddress.RowHeight(GRDAddress.Rows - 1) = 12
    End If
End Sub

Private Sub grdAddress_Click()
    If (GRDAddress.Row >= 0) Then
        Call PDBFindRecordbyID(AddressDB, GRDAddress.ItemData(GRDAddress.Row, 0))
        ReadAddressRecord DetailsRecord
    End If
End Sub
