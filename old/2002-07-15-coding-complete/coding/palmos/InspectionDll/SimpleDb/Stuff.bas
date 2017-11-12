Attribute VB_Name = "Stuff"
Option Explicit
Public vrecord As tELF2InvoiceRecord

Public Type tELF2InvoiceRecord
        Name As String
        CompanyName As String
        Title As String
        WorkNumber As String
        Address1 As String
        Street1 As String
        State As String
        Country As String
        PostCode As String
        PROD1QTY As Long
        PROD1Name As String
        PROD1UnitCost As Single
        PROD1VatPercent As Single
        PROD2QTY As Long
        PROD2Name As String
        PROD2UnitCost As Single
        PROD2VatPercent As Single
        PROD3QTY As Long
        PROD3Name As String
        PROD3UnitCost As Single
        PROD3VatPercent As Single
        PROD4QTY As Long
        PROD4Name As String
        PROD4UnitCost As Single
        PROD4VatPercent As Single
        Carriage As Single
        Comment As String
End Type


