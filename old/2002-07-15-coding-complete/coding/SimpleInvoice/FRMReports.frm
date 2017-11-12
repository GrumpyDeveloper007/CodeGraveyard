VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FRMReports 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Reports"
   ClientHeight    =   4365
   ClientLeft      =   765
   ClientTop       =   1470
   ClientWidth     =   8895
   HelpContextID   =   4
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   4365
   ScaleWidth      =   8895
   Begin VB.CheckBox CHKUseStartDate 
      Caption         =   "Use Start Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   960
      TabIndex        =   15
      Top             =   1320
      Width           =   1695
   End
   Begin VB.CommandButton CMDCreateBatch 
      Caption         =   "Create Batch"
      Height          =   315
      Left            =   3000
      TabIndex        =   10
      Top             =   900
      Width           =   1215
   End
   Begin VB.CommandButton CMDPrint 
      Caption         =   "&Print"
      Height          =   375
      Left            =   0
      TabIndex        =   3
      Top             =   3960
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   7800
      TabIndex        =   4
      Top             =   3960
      Width           =   1095
   End
   Begin VB.OptionButton optScreen 
      Caption         =   "Screen"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   1080
      TabIndex        =   7
      Top             =   3240
      Value           =   -1  'True
      Width           =   1095
   End
   Begin VB.OptionButton optPrinter 
      Caption         =   "Printer"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   2160
      TabIndex        =   6
      Top             =   3240
      Width           =   1095
   End
   Begin VB.ComboBox CBOreportname 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      ItemData        =   "FRMReports.frx":0000
      Left            =   1800
      List            =   "FRMReports.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   0
      ToolTipText     =   "Select report type to be printed."
      Top             =   0
      Width           =   7095
   End
   Begin ELFTxtBox.TxtBox1 TXTBatchNumber 
      Height          =   285
      Left            =   1680
      TabIndex        =   1
      Top             =   900
      Width           =   1215
      _ExtentX        =   2143
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFDateControl.DateControl TXTCuttOffDate 
      Height          =   615
      Left            =   5640
      TabIndex        =   2
      Top             =   600
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin ELFDateControl.DateControl TXTStartDate 
      Height          =   615
      Left            =   1920
      TabIndex        =   11
      Top             =   1680
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin ELFDateControl.DateControl TXTEndDate 
      Height          =   615
      Left            =   5475
      TabIndex        =   12
      Top             =   1680
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin VB.Label LBLStartDate 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Start Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   600
      TabIndex        =   14
      Top             =   2010
      Width           =   1215
   End
   Begin VB.Label LBLEndDate 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "End Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   4155
      TabIndex        =   13
      Top             =   2055
      Width           =   1215
   End
   Begin VB.Label LBLCuttOffDate 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Cutt-off Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   4320
      TabIndex        =   9
      Top             =   900
      Width           =   1215
   End
   Begin VB.Label LBLBatchNumber 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Batch Number"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   8
      Top             =   900
      Width           =   1335
   End
   Begin VB.Label LBLReportComments 
      BackStyle       =   0  'Transparent
      Caption         =   "<Reports Comments>"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   0
      TabIndex        =   5
      Top             =   2760
      Width           =   8895
   End
End
Attribute VB_Name = "FRMReports"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Reports Object
''
''

Private vIsLoaded As Boolean

Private printerobject As New FRMSPrinterForm

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

''
Private Sub DisableAll()
    LBLBatchNumber.Visible = False
    TXTBatchNumber.Visible = False
    CMDCreateBatch.Visible = False
    LBLCuttOffDate.Visible = False
    TXTCuttOffDate.Visible = False

    LBLStartDate.Visible = False
    TXTStartDate.Visible = False
    LBLEndDate.Visible = False
    TXTEndDate.Visible = False
    
    CHKUseStartDate.Visible = False
    
    LBLReportComments.Caption = ""
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CBOreportname_Click()
    ' Hide all options here
    Call DisableAll
    Select Case CBOreportname.ListIndex
        Case 0 ' Show used options here, (depending on type of report)
            LBLBatchNumber.Visible = True
            TXTBatchNumber.Visible = True
            CMDCreateBatch.Visible = True
            LBLCuttOffDate.Visible = True
            TXTCuttOffDate.Visible = True
        Case 1 ' Unpaid Invoices
        Case 2 ' VAT Preview
            LBLCuttOffDate.Visible = True
            TXTCuttOffDate.Visible = True
            
            CHKUseStartDate.Visible = True
            LBLStartDate.Visible = True
            TXTStartDate.Visible = True
        Case 3 ' Invoice Report
            LBLStartDate.Visible = True
            TXTStartDate.Visible = True
            LBLEndDate.Visible = True
            TXTEndDate.Visible = True
        Case 4 ' Customer Export Report
        Case 5
        Case 6
        Case 7
        Case 8
    End Select
End Sub

''
Private Sub CMDCreateBatch_Click()
    Dim rstemp As Recordset
    Dim NextBatchNumber As Long
    Dim InvoicesInBatch As Long
    Dim CreditNotesInBatch As Long
    If (OpenRecordset(rstemp, "SELECT Max(VatBatchNumber) as ttt FROM Invoice", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            NextBatchNumber = rstemp!ttt + 1
        Else
            NextBatchNumber = 1
        End If
    End If
    
    ' By Payment Date
    If (FRMOptions.UsePaymentDateForVAT = True) Then
        InvoicesInBatch = Execute("UPDATE Invoice SET vatBatchNumber=" & NextBatchNumber & " WHERE Status=0 AND VatBatchNumber=0 AND AmountPaid>0 AND Paymentdate<=" & cDateChar & Format(TXTCuttOffDate.Text, "mm/dd/yyyy") & cDateChar, True)
        ' Calculate VAT Paid
        Call Execute("UPDATE Invoice SET VATPaid=AmountPaid/100*17.5 WHERE VATBatchNumber=" & NextBatchNumber)
    
    Else
        ' By Invoice Date
        InvoicesInBatch = Execute("UPDATE Invoice SET VATPayed=VATAmount, vatBatchNumber=" & NextBatchNumber & " WHERE Status=0 AND VatBatchNumber=0 AND AmountPaid>0 AND Invoicedate<=" & cDateChar & Format(TXTCuttOffDate.Text, "mm/dd/yyyy") & cDateChar, True)
    End If
    
    ' Process credit notes
    CreditNotesInBatch = Execute("UPDATE CreditNote SET vatBatchNumber=" & NextBatchNumber & " WHERE Status=0 AND VatBatchNumber=0 AND AmountPaid=goodstotal+vattotal+handlingtotal AND Paymentdate<=" & cDateChar & Format(TXTCuttOffDate.Text, "mm/dd/yyyy") & cDateChar, True)
    
    If (InvoicesInBatch = 0 And CreditNotesInBatch = 0) Then
        Call Messagebox("No Invoices/Credit Notes found to be processed.", vbInformation)
        TXTBatchNumber.Text = ""
    Else
        Call Messagebox("(" & InvoicesInBatch & ") Invoices And (" & CreditNotesInBatch & ") Credit notes processed in batch " & NextBatchNumber, vbInformation)
        TXTBatchNumber.Text = NextBatchNumber
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub CMDPrint_Click()
    Dim sql As String
    Screen.MousePointer = vbHourglass
    Call printerobject.Initialize
    
    Select Case CBOreportname.ListIndex
        Case 0 ' Show used options here, (depending on type of report)
            If (TXTBatchNumber.Text <> "") Then
                sql = "SELECT i.InvoiceNumber AS [Invoice Number],c.CompanyName AS [Company Name],i.InvoiceDate AS [Invoice Date],i.amountpaid AS [Amount Paid],i.Paymentdate AS [Payment Date],i.VATTotal AS [VAT Total],i.goodstotal+VATTotal+HandlingTotal AS [Invoice Total] FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid  WHERE VatBatchNumber=" & TXTBatchNumber.Text
                If (optScreen.Value = True) Then
                    Call printerobject.PreviewSQL(sql, "VAT Batch Report " & TXTBatchNumber.Text, "000X0XX")
                Else
                    Call printerobject.PrintSQL(sql, "VAT Batch Report " & TXTBatchNumber.Text, "000X0XX")
                End If
            Else
                Call Messagebox("A Batch Number is required.", vbInformation)
                Call TXTBatchNumber.SetFocus
            End If
        Case 1 ' Unpaid invoices
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL("SELECT i.InvoiceNumber,c.CompanyName,i.InvoiceDate,i.GoodsTotal,i.HandlingTotal,i.VATTotal,i.goodstotal+VATTotal+HandlingTotal AS GrandTotal FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid WHERE amountpaid<goodstotal+vattotal+handlingtotal AND invoicetype=0", "UnPaid Invoice Report", "000XXXX")
            Else
                Call printerobject.PrintSQL("SELECT i.InvoiceNumber,c.CompanyName,i.InvoiceDate,i.GoodsTotal,i.HandlingTotal,i.VATTotal,i.goodstotal+VATTotal+HandlingTotal AS GrandTotal FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid  WHERE amountpaid<goodstotal+vattotal+handlingtotal AND invoicetype=0", "UnPaid Invoice Report", "000XXXX")
            End If
        Case 2 ' VAT Preview
            'Paymentdate<=" & cDateChar & TXTCuttOffDate.Text & cDateChar & "
            'i.GoodsTotal,i.HandlingTotal,
            sql = "SELECT i.InvoiceNumber AS [Invoice Number],c.CompanyName AS [Company Name],i.InvoiceDate AS [Invoice Date],i.amountpaid AS [Amount Paid],i.Paymentdate AS [Payment Date],i.VATTotal AS [VAT Total],i.goodstotal+VATTotal+HandlingTotal AS [Invoice Total] FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid  WHERE VatBatchNumber=0 AND AmountPaid>0 AND invoicetype=0 AND Paymentdate<=" & cDateChar & Format(TXTCuttOffDate.Text, "mm/dd/yyyy") & cDateChar
            If (CHKUseStartDate.Value = vbChecked) Then
                sql = sql & " AND Paymentdate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar
            End If
            
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL(sql, "VAT Preview Report", "000X0XX")
            Else
                Call printerobject.PrintSQL(sql, "VAT Preview Report", "000X0XX")
            End If
        Case 3 ' Invoice Report
            sql = "SELECT i.InvoiceNumber,i.InvoiceDate,i.GoodsTotal,i.HandlingTotal,i.VATTotal,i.goodstotal+VATTotal+HandlingTotal AS GrandTotal FROM Invoice i WHERE invoicetype=0 AND invoiceDate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar & " AND invoicedate<" & cDateChar & Format(DateAdd("d", 1, TXTEndDate.Text), "mm/dd/yyyy") & cDateChar & " ORDER BY InvoiceDate, InvoiceNumber"
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL(sql, "Invoice Report " & TXTStartDate.Text & "-" & TXTEndDate.Text, "00XXXX")
            Else
                Call printerobject.PrintSQL(sql, "Invoice Report " & TXTStartDate.Text & "-" & TXTEndDate.Text, "00XXXX")
            End If
        Case 4 ' Customer Export Report
            sql = "SELECT t.title + ' ' + c.name, c.companyname,c.street1,c.street2,c.town,c.county,c.country,c.postcode,c.contacttelephonenumber,c.department,c.email,c.percentagediscount,c.duedateperiod"
            sql = sql & " FROM Customer c INNER JOIN title t ON c.titleid=t.uid"
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL(sql, "Customer Export Report")
            Else
                Call printerobject.PrintSQL(sql, "Customer Export Report")
            End If
        Case 5
        Case 6
        Case 7
        Case 8
    End Select
    
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub Form_Load()
'    Call WebBrowser1.Navigate("www.pyrodesign.co.uk/searchproducts.htm")
'    WebBrowser1.set
    
    Dim i As Long
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call DisableAll
    TXTCuttOffDate.Text = Format(Now, "dd/mm/yyyy")
    Call CBOreportname.AddItem("VAT Report")
    Call CBOreportname.AddItem("UnPaid Invoice Report")
    Call CBOreportname.AddItem("VAT Preview")
    Call CBOreportname.AddItem("Invoice Report")
    Call CBOreportname.AddItem("Customer Export Report")
    
    CBOreportname.ListIndex = 0
    Call SetPrinter(GetWorkstationSetting("REPORTPRINTER"))
    TXTStartDate.Text = Format(Now, "dd/mm/yyyy")
    TXTEndDate.Text = Format(DateAdd("d", 7, Now), "dd/mm/yyyy")
    
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub
