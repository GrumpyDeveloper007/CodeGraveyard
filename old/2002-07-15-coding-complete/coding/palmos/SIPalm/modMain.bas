Attribute VB_Name = "modMain"

Option Explicit
Public DetailsRecord As tAddressRec
Public bNewRecord As Boolean
Public CurrentIdx As Long

Public ProductRecord As tProductRecord
Public InvoiceRecord As tELF2InvoiceRecord
Public StaticRecord As tELF2StaticRecord

Public vLastInvoiceID As Long


Public Sub main()
    
    Load frmMain
    frmMain.Show

End Sub




