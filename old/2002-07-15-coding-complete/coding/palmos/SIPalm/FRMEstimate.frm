VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMEstimate 
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
   Begin IngotTextBoxCtl.AFTextBox TXTPONumber 
      Height          =   195
      Left            =   720
      OleObjectBlob   =   "FRMEstimate.frx":0000
      TabIndex        =   41
      Top             =   1545
      Width           =   810
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   6
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":0058
      TabIndex        =   40
      Top             =   1545
      Width           =   705
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDescription 
      Height          =   195
      Index           =   3
      Left            =   915
      OleObjectBlob   =   "FRMEstimate.frx":00A2
      TabIndex        =   38
      Top             =   1080
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDescription 
      Height          =   195
      Index           =   2
      Left            =   915
      OleObjectBlob   =   "FRMEstimate.frx":00FA
      TabIndex        =   37
      Top             =   870
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDescription 
      Height          =   195
      Index           =   1
      Left            =   915
      OleObjectBlob   =   "FRMEstimate.frx":0152
      TabIndex        =   36
      Top             =   660
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDescription 
      Height          =   195
      Index           =   0
      Left            =   915
      OleObjectBlob   =   "FRMEstimate.frx":01AA
      TabIndex        =   35
      Top             =   450
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDPagePLus 
      Height          =   210
      Left            =   195
      OleObjectBlob   =   "FRMEstimate.frx":0202
      TabIndex        =   34
      Top             =   1305
      Width           =   180
   End
   Begin IngotButtonCtl.AFButton CMDPageMinus 
      Height          =   210
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":0248
      TabIndex        =   33
      Top             =   1305
      Width           =   180
   End
   Begin IngotButtonCtl.AFButton CMDFindProduct 
      Height          =   210
      Index           =   3
      Left            =   1425
      OleObjectBlob   =   "FRMEstimate.frx":028E
      TabIndex        =   32
      Top             =   1080
      Width           =   120
   End
   Begin IngotButtonCtl.AFButton CMDFindProduct 
      Height          =   210
      Index           =   2
      Left            =   1425
      OleObjectBlob   =   "FRMEstimate.frx":02D4
      TabIndex        =   31
      Top             =   870
      Width           =   120
   End
   Begin IngotButtonCtl.AFButton CMDFindProduct 
      Height          =   210
      Index           =   1
      Left            =   1425
      OleObjectBlob   =   "FRMEstimate.frx":031A
      TabIndex        =   30
      Top             =   660
      Width           =   120
   End
   Begin IngotButtonCtl.AFButton CMDFindProduct 
      Height          =   210
      Index           =   0
      Left            =   1425
      OleObjectBlob   =   "FRMEstimate.frx":0360
      TabIndex        =   29
      Top             =   450
      Width           =   120
   End
   Begin IngotTextBoxCtl.AFTextBox TXTUnitCost 
      Height          =   195
      Index           =   3
      Left            =   1560
      OleObjectBlob   =   "FRMEstimate.frx":03A6
      TabIndex        =   14
      Top             =   1080
      Width           =   480
   End
   Begin IngotTextBoxCtl.AFTextBox TXTProduct 
      Height          =   195
      Index           =   3
      Left            =   360
      OleObjectBlob   =   "FRMEstimate.frx":03FE
      TabIndex        =   13
      Top             =   1080
      Width           =   570
   End
   Begin IngotTextBoxCtl.AFTextBox TXTQty 
      Height          =   195
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":0456
      TabIndex        =   12
      Top             =   1080
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTVAT 
      Height          =   195
      Index           =   3
      Left            =   2025
      OleObjectBlob   =   "FRMEstimate.frx":04AE
      TabIndex        =   15
      Top             =   1080
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTVAT 
      Height          =   195
      Index           =   2
      Left            =   2025
      OleObjectBlob   =   "FRMEstimate.frx":0506
      TabIndex        =   11
      Top             =   870
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTVAT 
      Height          =   195
      Index           =   1
      Left            =   2025
      OleObjectBlob   =   "FRMEstimate.frx":055E
      TabIndex        =   7
      Top             =   660
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   5
      Left            =   1590
      OleObjectBlob   =   "FRMEstimate.frx":05B6
      TabIndex        =   28
      Top             =   1755
      Width           =   210
   End
   Begin IngotTextBoxCtl.AFTextBox TXTHandling 
      Height          =   195
      Left            =   1980
      OleObjectBlob   =   "FRMEstimate.frx":05FA
      TabIndex        =   16
      Top             =   1755
      Width           =   420
   End
   Begin IngotTextBoxCtl.AFTextBox TXTQty 
      Height          =   195
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":0652
      TabIndex        =   8
      Top             =   870
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTProduct 
      Height          =   195
      Index           =   2
      Left            =   360
      OleObjectBlob   =   "FRMEstimate.frx":06AA
      TabIndex        =   9
      Top             =   870
      Width           =   570
   End
   Begin IngotTextBoxCtl.AFTextBox TXTUnitCost 
      Height          =   195
      Index           =   2
      Left            =   1560
      OleObjectBlob   =   "FRMEstimate.frx":0702
      TabIndex        =   10
      Top             =   870
      Width           =   480
   End
   Begin IngotTextBoxCtl.AFTextBox TXTQty 
      Height          =   195
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":075A
      TabIndex        =   4
      Top             =   660
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTProduct 
      Height          =   195
      Index           =   1
      Left            =   360
      OleObjectBlob   =   "FRMEstimate.frx":07B2
      TabIndex        =   5
      Top             =   660
      Width           =   570
   End
   Begin IngotTextBoxCtl.AFTextBox TXTUnitCost 
      Height          =   195
      Index           =   1
      Left            =   1560
      OleObjectBlob   =   "FRMEstimate.frx":080A
      TabIndex        =   6
      Top             =   660
      Width           =   480
   End
   Begin IngotLabelCtl.AFLabel LBLGrandTotal 
      Height          =   180
      Left            =   1590
      OleObjectBlob   =   "FRMEstimate.frx":0862
      TabIndex        =   27
      Top             =   1935
      Width           =   810
   End
   Begin IngotLabelCtl.AFLabel LBLVATTotal 
      Height          =   180
      Left            =   1590
      OleObjectBlob   =   "FRMEstimate.frx":08AB
      TabIndex        =   26
      Top             =   1575
      Width           =   810
   End
   Begin IngotLabelCtl.AFLabel LBLNetTotal 
      Height          =   180
      Left            =   1590
      OleObjectBlob   =   "FRMEstimate.frx":08F4
      TabIndex        =   25
      Top             =   1395
      Width           =   810
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "FRMEstimate.frx":093D
      TabIndex        =   18
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":0988
      TabIndex        =   17
      Top             =   2160
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLStreet1 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":09CF
      TabIndex        =   24
      Top             =   120
      Width           =   2400
   End
   Begin IngotTextBoxCtl.AFTextBox TXTVAT 
      Height          =   195
      Index           =   0
      Left            =   2025
      OleObjectBlob   =   "FRMEstimate.frx":0A25
      TabIndex        =   3
      Top             =   450
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   3
      Left            =   2040
      OleObjectBlob   =   "FRMEstimate.frx":0A7D
      TabIndex        =   23
      Top             =   285
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTUnitCost 
      Height          =   195
      Index           =   0
      Left            =   1560
      OleObjectBlob   =   "FRMEstimate.frx":0AC2
      TabIndex        =   2
      Top             =   450
      Width           =   480
   End
   Begin IngotTextBoxCtl.AFTextBox TXTProduct 
      Height          =   195
      Index           =   0
      Left            =   360
      OleObjectBlob   =   "FRMEstimate.frx":0B1A
      TabIndex        =   1
      Top             =   450
      Width           =   570
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   2
      Left            =   1440
      OleObjectBlob   =   "FRMEstimate.frx":0B72
      TabIndex        =   22
      Top             =   285
      Width           =   540
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   1
      Left            =   375
      OleObjectBlob   =   "FRMEstimate.frx":0BBC
      TabIndex        =   21
      Top             =   285
      Width           =   480
   End
   Begin IngotTextBoxCtl.AFTextBox TXTQty 
      Height          =   195
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":0C04
      TabIndex        =   0
      Top             =   450
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLName 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":0C5C
      TabIndex        =   19
      Top             =   -15
      Width           =   2400
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMEstimate.frx":0CAE
      TabIndex        =   20
      Top             =   285
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   180
      Index           =   4
      Left            =   930
      OleObjectBlob   =   "FRMEstimate.frx":0CF2
      TabIndex        =   39
      Top             =   285
      Width           =   285
   End
End
Attribute VB_Name = "FRMEstimate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Const cCurrencySymbol As String = "£"     ' must be 1 char
Const cCurrencyFormat As String = cCurrencySymbol & "#####0.00"

Private vPragmaticChange As Boolean
Private vScrollChange As Boolean
Private vLastProductIndex As Long

Private vLineIndex(5) As Long

Private Type LineTYPE
    QTY As Long
    product As String
    Description As String
    UnitCost As Single
    VatPercent As Single
End Type

Private DataStore(100) As LineTYPE
Private vInvoiceType As Long

''
Private Sub RedrawGrid()
    Dim i As Long
    vScrollChange = True
    For i = 0 To 3
        If (DataStore(vLineIndex(i)).QTY <> -1) Then
            TXTQty(i).Text = DataStore(vLineIndex(i)).QTY
        Else
            TXTQty(i).Text = ""
        End If
        TXTProduct(i).Text = DataStore(vLineIndex(i)).product
        TXTDescription(i).Text = DataStore(vLineIndex(i)).Description
        If (DataStore(vLineIndex(i)).UnitCost <> -1) Then
            TXTUnitCost(i).Text = DataStore(vLineIndex(i)).UnitCost
        Else
            TXTUnitCost(i).Text = ""
        End If
        If (DataStore(vLineIndex(i)).VatPercent <> -1) Then
            TXTVAT(i).Text = DataStore(vLineIndex(i)).VatPercent
        Else
            TXTVAT(i).Text = ""
        End If
    Next
    vScrollChange = False
End Sub

''
Private Sub ClearDetails()
    Dim i As Long
    
    vScrollChange = True
    CMDPageMinus.Enabled = False
    For i = 0 To 3
        vLineIndex(i) = i
    Next
    
    For i = 0 To 100
        DataStore(i).QTY = -1
        DataStore(i).product = ""
        DataStore(i).Description = ""
        DataStore(i).UnitCost = -1
        DataStore(i).VatPercent = -1
    Next
    
    For i = 0 To 3
        TXTQty(i).Text = ""
        TXTProduct(i).Text = ""
        TXTUnitCost(i).Text = ""
        TXTDescription(i).Text = ""
        TXTVAT(i).Text = ""
    Next
    vScrollChange = False
    Call CalculateTotals
End Sub

''
Public Sub SendChildInactive()
    ' load product details
    vScrollChange = True
    If (TXTQty(vLastProductIndex).Text = "") Then
        TXTQty(vLastProductIndex).Text = 1
    End If
    TXTProduct(vLastProductIndex).Text = ProductRecord.Name
    TXTDescription(vLastProductIndex).Text = ProductRecord.Description
    TXTUnitCost(vLastProductIndex).Text = CSng(ProductRecord.NetCost) / 100
    TXTVAT(vLastProductIndex).Text = CSng(ProductRecord.VatPercent) / 100
    vScrollChange = False
    Call CalculateTotals
    
    If (vLastProductIndex < 3) Then
        Call TXTQty(vLastProductIndex + 1).SetFocus
    Else
        Call TXTHandling.SetFocus
    End If
End Sub

''
Public Function Search(pTYPE As Long) As Boolean
    '0-invoice
    '1-estimate
    vInvoiceType = pTYPE
    Me.Show
    Call ClearDetails
    LBLName.Caption = "Name: " & DetailsRecord.Company
    LBLStreet1.Caption = "Street: " & DetailsRecord.Address
    Call TXTQty(0).SetFocus
    
    Call PDBMoveFirst(dbELF2Static)
    Call PDBReadRecord(dbELF2Static, VarPtr(StaticRecord))
    
End Function

''
Private Sub CMDCancel_Click()
    Call Me.Hide
    Call frmMain.Show
End Sub

''
Private Sub CMDFindProduct_Click(Index As Integer)
    vLastProductIndex = Index
    Call FRMFindProduct.Search(TXTProduct(Index).Text, TXTDescription(Index).Text)
End Sub

''
Private Sub CMDOK_Click()
    Dim i As Long
    Dim LineRecord As tELF2LineRecord
    
    StaticRecord.LastInvoice = StaticRecord.LastInvoice + 1
    InvoiceRecord.UID = StaticRecord.LastInvoice
    Call PDBEditRecord(dbELF2Static)
    Call PDBWriteRecord(dbELF2Static, VarPtr(StaticRecord))
    Call PDBUpdateRecord(dbELF2Static)
    
    InvoiceRecord.Name = DetailsRecord.Name
    InvoiceRecord.CompanyName = DetailsRecord.Company
    InvoiceRecord.Title = DetailsRecord.Title
    
    ' get work number
    If (DetailsRecord.PhoneType5 = 0) Then
        InvoiceRecord.WorkNumber = DetailsRecord.Phone5
    Else
        If (DetailsRecord.PhoneType4 = 0) Then
            InvoiceRecord.WorkNumber = DetailsRecord.Phone4
        Else
            If (DetailsRecord.PhoneType3 = 0) Then
                InvoiceRecord.WorkNumber = DetailsRecord.Phone3
            Else
                If (DetailsRecord.PhoneType2 = 0) Then
                    InvoiceRecord.WorkNumber = DetailsRecord.Phone2
                Else
'                    If (DetailsRecord.PhoneType1 = 0) Then
                        InvoiceRecord.WorkNumber = DetailsRecord.Phone1
'                    End If
                End If
            End If
        End If
    End If
    InvoiceRecord.Address1 = DetailsRecord.Address
    InvoiceRecord.Street1 = DetailsRecord.City
    InvoiceRecord.State = DetailsRecord.State
    InvoiceRecord.Country = DetailsRecord.Country
    InvoiceRecord.PostCode = DetailsRecord.ZipCode
    
    InvoiceRecord.Carriage = CSng("0" & TXTHandling.Text) * 100
    InvoiceRecord.PONumber = TXTPONumber.Text
    InvoiceRecord.InvoiceType = vInvoiceType
    
    For i = 0 To 100
        If (DataStore(i).product <> "") Then
            LineRecord.ELF2InvoiceID = InvoiceRecord.UID
            LineRecord.Name = DataStore(i).product
            LineRecord.Description = DataStore(i).Description
            LineRecord.QTY = DataStore(i).QTY
            LineRecord.UnitCost = DataStore(i).UnitCost * 100
            LineRecord.VatPercent = DataStore(i).VatPercent * 100
            Call PDBCreateRecordBySchema(dbELF2Line)
            Call PDBWriteRecord(dbELF2Line, VarPtr(LineRecord))
            Call PDBUpdateRecord(dbELF2Line)
        End If
    Next
    
    Call PDBCreateRecordBySchema(dbELF2Invoice)
    Call PDBWriteRecord(dbELF2Invoice, VarPtr(InvoiceRecord))
    Call PDBUpdateRecord(dbELF2Invoice)
        
    Call Me.Hide
    Call frmMain.Show
End Sub

''
Private Sub CMDPageMinus_Click()
    If (vLineIndex(0) > 0) Then
        vLineIndex(0) = vLineIndex(0) - 1
        vLineIndex(1) = vLineIndex(1) - 1
        vLineIndex(2) = vLineIndex(2) - 1
        vLineIndex(3) = vLineIndex(3) - 1
        vLineIndex(4) = vLineIndex(4) - 1
        CMDPagePLus.Enabled = True
        If (vLineIndex(0) = 0) Then
            CMDPageMinus.Enabled = False
        End If
    End If
    Call RedrawGrid
    Call TXTQty(0).SetFocus
End Sub

''
Private Sub CMDPagePLus_Click()
    If (vLineIndex(0) < 100 - 4) Then
        CMDPageMinus.Enabled = True
        vLineIndex(0) = vLineIndex(0) + 1
        vLineIndex(1) = vLineIndex(1) + 1
        vLineIndex(2) = vLineIndex(2) + 1
        vLineIndex(3) = vLineIndex(3) + 1
        vLineIndex(4) = vLineIndex(4) + 1
        If (vLineIndex(0) = 100 - 4) Then
            CMDPagePLus.Enabled = False
        End If
    End If
    Call RedrawGrid
    Call TXTQty(0).SetFocus
End Sub


''
Private Sub TXTDescription_Change(Index As Integer)
    DataStore(vLineIndex(Index)).Description = TXTDescription(Index).Text
End Sub

''
Private Sub TXTHandling_Change()
    TXTHandling.Text = RemoveNonNumericCharacters(TXTHandling.Text)
    Call CalculateTotals
End Sub

Private Sub TXTPONumber_Change()
    TXTPONumber.Text = UCase(TXTPONumber.Text)
End Sub

''
Private Sub TXTProduct_Change(Index As Integer)
    DataStore(vLineIndex(Index)).product = TXTProduct(Index).Text
End Sub

''
Private Sub TXTQty_Change(Index As Integer)
    TXTQty(Index).Text = RemoveNonNumericCharacters(TXTQty(Index).Text)
    If (TXTQty(Index).Text = "") Then
        DataStore(vLineIndex(Index)).QTY = -1
        Call CalculateTotals
    Else
        If (DataStore(vLineIndex(Index)).QTY <> CLng(TXTQty(Index).Text)) Then
            DataStore(vLineIndex(Index)).QTY = CLng(TXTQty(Index).Text)
            Call CalculateTotals
        End If
    End If
End Sub

''
Private Sub TXTUnitCost_Change(Index As Integer)
    TXTUnitCost(Index).Text = RemoveNonNumericCharacters(TXTUnitCost(Index).Text)
    If (TXTUnitCost(Index).Text = "") Then
        DataStore(vLineIndex(Index)).UnitCost = -1
        Call CalculateTotals
    Else
        If (DataStore(vLineIndex(Index)).UnitCost <> CSng(TXTUnitCost(Index).Text)) Then
            DataStore(vLineIndex(Index)).UnitCost = CSng(TXTUnitCost(Index).Text)
            Call CalculateTotals
        End If
    End If
End Sub

''
Private Sub TXTVAT_Change(Index As Integer)
    TXTVAT(Index).Text = RemoveNonNumericCharacters(TXTVAT(Index).Text)
    If (TXTVAT(Index).Text = "") Then
        DataStore(vLineIndex(Index)).VatPercent = -1
        Call CalculateTotals
    Else
        If (DataStore(vLineIndex(Index)).VatPercent <> CSng(TXTVAT(Index).Text)) Then
            DataStore(vLineIndex(Index)).VatPercent = CSng(TXTVAT(Index).Text)
            Call CalculateTotals
        End If
    End If
End Sub

''
Private Sub CalculateTotals()
    Dim i As Long
    Dim Goodstotal As Single
    Dim GoodsTotalItem As Single
    Dim Vattotal As Single
    Dim Vatgrandtotal As Single
    Dim VatPercent As Single
    
    ' Sync Screen data
    If (vScrollChange = False) Then

        Vattotal = 0
        Goodstotal = 0
        Vatgrandtotal = 0
        If (vPragmaticChange = False) Then
            vPragmaticChange = True
            
            For i = 0 To 100
                If (DataStore(i).VatPercent <> -1) Then
                    VatPercent = DataStore(i).VatPercent
                Else
                    VatPercent = 0
                End If
                If (DataStore(i).UnitCost <> -1 And DataStore(i).QTY <> -1) Then
                    GoodsTotalItem = DataStore(i).UnitCost * DataStore(i).QTY
                Else
                    GoodsTotalItem = 0
                End If
                Goodstotal = Goodstotal + GoodsTotalItem
                If (DataStore(i).VatPercent <> -1) Then
                    Vattotal = GoodsTotalItem / 100 * (DataStore(i).VatPercent)
                Else
                    Vattotal = 0
                End If
                Vatgrandtotal = Vatgrandtotal + Vattotal
            Next
            
            LBLNetTotal.Caption = "Net: " & FormatCurrency(Goodstotal)
            LBLVATTotal.Caption = "VAT:" & FormatCurrency(Vatgrandtotal)
            LBLGrandTotal.Caption = "Tot:" & FormatCurrency((Goodstotal + Vatgrandtotal + CSng("0" & TXTHandling.Text)))
            vPragmaticChange = False
        End If
    End If
End Sub

