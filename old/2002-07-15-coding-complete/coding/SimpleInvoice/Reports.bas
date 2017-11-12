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


'' requires fully loaded sale,invoice,customer class
Public Sub PrintInvoice(pInvoiceHeading As String, ByRef pSaleClass As ClassSale, pPrintQutation As Boolean)
    Dim rstemp As Recordset
    Dim InvoiceCommentString As String
    Dim ItemCount As Long
    Dim VatAmount As String
    Dim TotalPages As Long
    Dim Tempstring As String
    Dim TotalDetailLines As Long
    Dim i As Long
    
    Dim LineStore(2000) As PrintLineTYPE
    
    Const LinesPerPage As Long = 20
    Printer.Orientation = vbPRORPortrait
    Printer.FontName = "Arial"
    Printer.ScaleMode = vbMillimeters
    
    If (OpenRecordset(rstemp, "SELECT * FROM SaleLine WHERE Saleid=" & pSaleClass.Uid, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Call SetPrinter(GetWorkstationSetting("INVOICEPRINTER"))
            ItemCount = 1
            TotalDetailLines = 0
'            Call rstemp.MoveLast
'            Call rstemp.MoveFirst
            Do While (rstemp.EOF = False)
                
                LineStore(TotalDetailLines).ItemCount = ItemCount
                If (rstemp!Qty >= 0) Then
                    LineStore(TotalDetailLines).Qty = rstemp!Qty
                End If
                LineStore(TotalDetailLines).Product = AutoCase(rstemp!Product, True)
                If (rstemp!Qty > 1) Then
                    LineStore(TotalDetailLines).UnitCost = FormatCurrency(rstemp!NetAmount / rstemp!Qty)
                Else
                    LineStore(TotalDetailLines).UnitCost = FormatCurrency(rstemp!NetAmount)
                End If
                LineStore(TotalDetailLines).NetAmount = FormatCurrency(rstemp!NetAmount)
                If (rstemp!VatPercent = -1) Then
                    VatAmount = "Z"
                Else
                    VatAmount = rstemp!VatPercent
                End If
                LineStore(TotalDetailLines).VAT = FormatPercent(Val(VatAmount))
                
                Printer.fontsize = 10
                Tempstring = FormatContext(Printer, 85, AutoCase(rstemp!Description, False))
                If (InStr(Tempstring, vbCrLf) > 0) Then
                    ' Multiline description
                    
                    Do While (InStr(Tempstring, vbCrLf) > 0)
                        LineStore(TotalDetailLines).Description = Left$(Tempstring, InStr(Tempstring, vbCrLf) - 1)
                            
                        
                        TotalDetailLines = TotalDetailLines + 1
                        Tempstring = Right$(Tempstring, Len(Tempstring) - InStr(Tempstring, vbCrLf) - 1)
                    Loop
                    LineStore(TotalDetailLines).Description = Tempstring
                    TotalDetailLines = TotalDetailLines + 1
                Else
                    ' Single Line description
                    LineStore(TotalDetailLines).Description = Tempstring
                    TotalDetailLines = TotalDetailLines + 1
                End If
                ItemCount = ItemCount + 1
                Call rstemp.MoveNext
            Loop
'            Call rstemp.MoveLast
'            Call rstemp.MoveFirst
    
            i = 0
            Do While (i < TotalDetailLines)
                ' Page Headings
                Printer.fontsize = 20
                Printer.Print pInvoiceHeading
            
                ' Do Company Details
                Printer.fontsize = 16
                Printer.Print ""
                Call PrintX(22, FRMOptions.CompanyName, True)
                Printer.fontsize = 10
                Call PrintX(22, FRMOptions.CompanyStreet1, True)
                If (FRMOptions.CompanyStreet2 <> "") Then
                    Call PrintX(22, FRMOptions.CompanyStreet2, True)
                End If
                If (FRMOptions.CompanyTown <> "") Then
                    Call PrintX(22, FRMOptions.CompanyTown, True)
                End If
                If (FRMOptions.CompanyCounty <> "") Then
                    Call PrintX(22, FRMOptions.CompanyCounty, True)
                End If
                If (FRMOptions.CompanyCountry <> "") Then
                    Call PrintX(22, FRMOptions.CompanyCountry, True)
                End If
                If (FRMOptions.CompanyPostCode <> "") Then
                    Call PrintX(22, FRMOptions.CompanyPostCode, True)
                End If
                Call PrintX(22, "V.A.T. No. " & FRMOptions.CompanyVATNumber, True)
                
                Printer.Print ""
                ' Customer Address
                Printer.fontsize = 10
                Printer.CurrentY = 52
                If (pSaleClass.Customer.Department <> "") Then
                    Call PrintX(22, pSaleClass.Customer.Department, True)
                End If
                Call PrintX(22, pSaleClass.Customer.CompanyName, True)
                Call PrintX(22, pSaleClass.Customer.Street1, True)
                If (pSaleClass.Customer.Street2 <> "") Then
                    Call PrintX(22, pSaleClass.Customer.Street2, True)
                End If
                If (pSaleClass.Customer.Town <> "") Then
                    Call PrintX(22, pSaleClass.Customer.Town, True)
                End If
                If (pSaleClass.Customer.County <> "") Then
                    Call PrintX(22, pSaleClass.Customer.County, True)
                End If
                If (pSaleClass.Customer.Country <> "") Then
                    Call PrintX(22, pSaleClass.Customer.Country, True)
                End If
                If (pSaleClass.Customer.postcode <> "") Then
                    Call PrintX(22, pSaleClass.Customer.postcode, True)
                End If
            '    Printer.Print vSaleClass.Customer.
            
                ' Do right hand side
                Printer.fontsize = 12
                Printer.CurrentY = 10
                Printer.CurrentX = 120
                If (pPrintQutation = True) Then
                    Call PrintX(130, "Quotation Number")
                Else
                    Call PrintX(130, "Invoice Number")
                End If
                Call PrintX(180, pSaleClass.Invoice.InvoiceNumber, True)
                If (pPrintQutation = True) Then
                    Call PrintX(130, "Quotation Date")
                Else
                    Call PrintX(130, "Invoice Date")
                End If
                Call PrintX(180, Format(pSaleClass.Invoice.Invoicedate, "dd/mm/yyyy"), True)
                Call PrintX(130, "PO Number")
                Call PrintX(180, pSaleClass.CustomerOrderNumber, True)
                Call PrintX(130, "Due Date")
                Call PrintX(180, Format(pSaleClass.Invoice.Duedate, "dd/mm/yyyy"), True)
                Call PrintX(130, "Customer Number")
                Call PrintX(180, pSaleClass.Customer.Uid, True)
                TotalPages = TotalDetailLines \ LinesPerPage
                If (TotalPages = 0) Then
                    TotalPages = 1
                End If
                Call PrintX(130, "Page ")
                Call PrintX(180, Printer.Page & " of " & TotalPages, True)
                
                
                ' Do Custom Headings
                Printer.CurrentY = 50
                Call PrintX(120, FRMOptions.InvoiceExtraFieldA(0) & FRMOptions.InvoiceExtraFieldB(0), True)
                Call PrintX(120, FRMOptions.InvoiceExtraFieldA(1) & FRMOptions.InvoiceExtraFieldB(1), True)
                Call PrintX(120, FRMOptions.InvoiceExtraFieldA(2) & FRMOptions.InvoiceExtraFieldB(2), True)
                
                ' Do Details
                Printer.CurrentY = 90
                Printer.fontsize = 10
                
                ' Do Detail Headings
                Printer.FontBold = True
                Call PrintX(5, "Item")
                Call PrintX(15, "Qty")
'                Call PrintX(25, "Product")
                Call PrintX(55, "Description")
                Call PrintX(145, "Unit Cost")
                Call PrintX(165, "Net Amount")
                Call PrintX(190, "VAT %", True)
                Printer.Print ""
                
                Printer.FontBold = False
                
                Do While (i < TotalDetailLines And Printer.CurrentY < (235))
                    Call PrintX(5, LineStore(i).ItemCount)
                    Call PrintX(15, LineStore(i).Qty)
'                    Call PrintX(25, LineStore(i).Product)
                    Call PrintX(145, LineStore(i).UnitCost)
                    Call PrintX(165, LineStore(i).NetAmount)
                    Call PrintX(190, LineStore(i).VAT)
                    Call PrintX(55, LineStore(i).Description, True)
                    'rstemp.MoveNext
                    i = i + 1
                Loop
                
                ' Draw some lines
                Printer.Line (4, 90)-(4, 235)
                Printer.Line (202, 90)-(202, 235)
                Printer.Line (4, 90)-(202, 90)
                Printer.Line (4, 235)-(202, 235)
                
                If (i < TotalDetailLines) Then
                    Call Printer.NewPage
                End If
            
            Loop
            
            ' Do Summary
            ' Do Comments
            
            Printer.CurrentY = 245
            Printer.fontsize = 12
            If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE Uid=" & pSaleClass.DisclaimerID, dbOpenSnapshot)) Then
                InvoiceCommentString = rstemp!Message
            End If
            Call PrintX(0, InvoiceCommentString, True)
            
            ' Do Totals
            Printer.fontsize = 14
            Printer.CurrentY = 245
            Call PrintX(120, "Net")
            Call PrintX(170, FormatCurrency(pSaleClass.Invoice.Goodstotal), True)
            Call PrintX(120, "VAT")
            Call PrintX(170, FormatCurrency(pSaleClass.Invoice.Vattotal), True)
            Call PrintX(120, "Handling/Carriage")
            Call PrintX(170, FormatCurrency(pSaleClass.Invoice.Handlingtotal), True)
            Call PrintX(120, "Total")
            Call PrintX(170, FormatCurrency(pSaleClass.Invoice.Goodstotal + pSaleClass.Invoice.Vattotal + pSaleClass.Invoice.Handlingtotal), True)
            
            
            Call Printer.EndDoc
            Call Printer.KillDoc
        End If
    End If
End Sub

Private Function GetNumberOfLines(pContext As Object, pWidth As Double, pText As String) As Long
    Dim Tempstring As String
    Dim i As Long
    Dim c As String
    
    i = 1
    GetNumberOfLines = 1
    
    Tempstring = ""
    Do While (i < Len(pText))
        c = Mid$(pText, i, 1)
        If (Printer.TextWidth(Tempstring & c) < pWidth) Then
            Tempstring = Tempstring & c
        Else
            GetNumberOfLines = GetNumberOfLines + 1
            Tempstring = ""
        End If
        i = i + 1
    Loop
End Function

'' Wordwrap, font size sensitive
Private Function FormatContext(pContext As Object, pWidth As Double, pText As String) As String
    Dim Tempstring As String
    Dim i As Long
    Dim c As String
    
    i = 1
    
    Tempstring = ""
    Do While (i <= Len(pText))
        c = Mid$(pText, i, 1)
        If (pContext.TextWidth(Tempstring & c) < pWidth) Then
            Tempstring = Tempstring & c
        Else
            If (InStrRev(Tempstring, " ") > 0) Then
                FormatContext = FormatContext & Left$(Tempstring, InStrRev(Tempstring, " ")) & vbCrLf
                Tempstring = Right$(Tempstring, Len(Tempstring) - InStrRev(Tempstring, " ")) & c
            Else
                Tempstring = Tempstring & vbCrLf & c
            End If
        End If
        i = i + 1
    Loop
    
    FormatContext = FormatContext & Tempstring
End Function



'' requires fully loaded sale,invoice,customer class
Public Sub PrintStatement(pCustomerID As Long)
    Dim CustomerClass As New ClassCustomer
    Dim rstemp As Recordset
    Dim GrandTotalSum As Double
    
'    Printer.Orientation = vbPRORPortrait
    Printer.FontName = "Arial"
    Printer.ScaleMode = vbMillimeters
    GrandTotalSum = 0
    
    CustomerClass.Uid = pCustomerID
    Call CustomerClass.ReadRecord(False)
    
    If (OpenRecordset(rstemp, "SELECT * FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid WHERE amountpaid<goodstotal+vattotal+handlingtotal AND c.uid=" & pCustomerID, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
'            Call SetPrinter(GetWorkstationSetting("INVOICEPRINTER"))
    
            Do While (rstemp.EOF = False)
                ' Page Headings
                Printer.fontsize = 20
                Printer.CurrentX = (Printer.ScaleWidth - Printer.TextWidth("Customer Statement")) / 2
                Printer.Print "Customer Statement"
            
                ' Do Company Details
                Printer.fontsize = 16
                Printer.Print ""
                Call PrintX(22, FRMOptions.CompanyName, True)
                Printer.fontsize = 10
                Call PrintX(22, FRMOptions.CompanyStreet1, True)
                If (FRMOptions.CompanyStreet2 <> "") Then
                    Call PrintX(22, FRMOptions.CompanyStreet2, True)
                End If
                If (FRMOptions.CompanyTown <> "") Then
                    Call PrintX(22, FRMOptions.CompanyTown, True)
                End If
                If (FRMOptions.CompanyCounty <> "") Then
                    Call PrintX(22, FRMOptions.CompanyCounty, True)
                End If
                If (FRMOptions.CompanyCountry <> "") Then
                    Call PrintX(22, FRMOptions.CompanyCountry, True)
                End If
                If (FRMOptions.CompanyPostCode <> "") Then
                    Call PrintX(22, FRMOptions.CompanyPostCode, True)
                End If
                Call PrintX(22, "V.A.T. No. " & FRMOptions.CompanyVATNumber, True)
                
                Printer.Print ""
                ' Customer Address
                Printer.fontsize = 10
                Printer.CurrentY = 52
                If (CustomerClass.Department <> "") Then
                    Call PrintX(22, CustomerClass.Department, True)
                End If
                Call PrintX(22, AutoCase(CustomerClass.CompanyName, True), True)
                Call PrintX(22, CustomerClass.Street1, True)
                If (CustomerClass.Street2 <> "") Then
                    Call PrintX(22, CustomerClass.Street2, True)
                End If
                If (CustomerClass.Town <> "") Then
                    Call PrintX(22, CustomerClass.Town, True)
                End If
                If (CustomerClass.County <> "") Then
                    Call PrintX(22, CustomerClass.County, True)
                End If
                If (CustomerClass.Country <> "") Then
                    Call PrintX(22, CustomerClass.Country, True)
                End If
                If (CustomerClass.postcode_V <> "ERROR") Then
                    Call PrintX(22, CustomerClass.postcode_V, True)
                End If
            
                Call PrintX(0, "", True)
                
                ' Do Detail Headings
                Printer.FontBold = True
                Call PrintX(5, "Invoice Number")
                Call PrintX(35, "Invoice Date")
                Call PrintX(60, "Goods Total")
                Call PrintX(90, "VAT Total")
                Call PrintX(120, "Grand Total")
                Call PrintX(150, "Days Overdue", True)
                Printer.Print ""
                
                Printer.FontBold = False
                
                Do While (rstemp.EOF = False And Printer.CurrentY < (235))
                    Call PrintX(5, rstemp!InvoiceNumber)
                    Call PrintX(35, rstemp!Invoicedate)
                    Call PrintX(60, FormatCurrency(rstemp!Goodstotal))
                    Call PrintX(90, FormatCurrency(rstemp!Vattotal))
                    Call PrintX(120, FormatCurrency(rstemp!Goodstotal + rstemp!Vattotal + rstemp!Handlingtotal))
                    GrandTotalSum = GrandTotalSum + rstemp!Goodstotal + rstemp!Vattotal + rstemp!Handlingtotal
                    Call PrintX(150, DateDiff("d", rstemp!Duedate, Now), True)
                    If (DateDiff("d", rstemp!Duedate, Now) > 0) Then
                        Call Execute("INSERT INTO statement (InvoiceID,StatementDate) VALUES (" & rstemp!Invoiceid & "," & cDateChar & Format(Now, "mm/dd/yyyy") & cDateChar & ")")
                    End If
                    
                    Call rstemp.MoveNext
                Loop
                
                If (rstemp.EOF = False) Then
                    Call Printer.NewPage
                End If
            
            Loop
            
            Printer.FontBold = True
            ' Do Summary
            Call PrintX(120, FormatCurrency(Val(GrandTotalSum)))
            ' Do Comments
            
            Printer.CurrentY = 245
            Printer.fontsize = 12
            
            
            Call Printer.EndDoc
            
        End If
    End If
End Sub


