Attribute VB_Name = "Reports"
Option Explicit


Private Type PrintLineTYPE
    ItemCount As String
    Qty As String
    Product As String
    Description As String
    UnitCost As String
    NetAmount As String
    VAT As String
End Type

''
Public Sub PrintX(pXPos As Long, pString As String, Optional NewLine As Boolean = False)
    Printer.CurrentX = pXPos
    If (NewLine = False) Then
        Printer.Print pString;
    Else
        Printer.Print pString
    End If
End Sub





