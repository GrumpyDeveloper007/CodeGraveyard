VERSION 5.00
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "Flp32x20.ocx"
Begin VB.Form FRMPDAInterface 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "PDA Control Panel"
   ClientHeight    =   4380
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10605
   ControlBox      =   0   'False
   HelpContextID   =   7
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4380
   ScaleWidth      =   10605
   Begin LpLib.fpList GRDInvoice 
      Height          =   3645
      Left            =   0
      TabIndex        =   0
      Top             =   240
      Width           =   10575
      _Version        =   131073
      _ExtentX        =   18653
      _ExtentY        =   6429
      _StockProps     =   68
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Text            =   ""
      Columns         =   6
      Sorted          =   0
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   0
      SearchMethod    =   0
      VirtualMode     =   0   'False
      VRowCount       =   0
      DataSync        =   3
      ThreeDInsideStyle=   1
      ThreeDInsideHighlightColor=   -2147483633
      ThreeDInsideShadowColor=   -2147483642
      ThreeDInsideWidth=   1
      ThreeDOutsideStyle=   1
      ThreeDOutsideHighlightColor=   16777215
      ThreeDOutsideShadowColor=   -2147483632
      ThreeDOutsideWidth=   1
      ThreeDFrameWidth=   0
      BorderStyle     =   0
      BorderColor     =   -2147483642
      BorderWidth     =   1
      ThreeDOnFocusInvert=   0   'False
      ThreeDFrameColor=   -2147483633
      Appearance      =   0
      BorderDropShadow=   0
      BorderDropShadowColor=   -2147483632
      BorderDropShadowWidth=   3
      ScrollHScale    =   2
      ScrollHInc      =   0
      ColsFrozen      =   0
      ScrollBarV      =   2
      NoIntegralHeight=   0   'False
      HighestPrecedence=   0
      AllowColResize  =   0
      AllowColDragDrop=   0
      ReadOnly        =   0   'False
      VScrollSpecial  =   0   'False
      VScrollSpecialType=   0
      EnableKeyEvents =   -1  'True
      EnableTopChangeEvent=   -1  'True
      DataAutoHeadings=   -1  'True
      DataAutoSizeCols=   2
      SearchIgnoreCase=   -1  'True
      ColDesigner     =   "FRMPDAInterface.frx":0000
      ScrollBarH      =   3
      DataFieldList   =   ""
      ColumnEdit      =   0
      ColumnBound     =   0
      Style           =   0
      MaxDrop         =   0
      ListWidth       =   0
      EditHeight      =   0
      GrayAreaColor   =   0
      ListLeftOffset  =   0
      ComboGap        =   0
      MaxEditLen      =   0
      VirtualPageSize =   0
      VirtualPagesAhead=   0
      ExtendCol       =   0
      ColumnLevels    =   1
      ListGrayAreaColor=   -2147483637
      GroupHeaderHeight=   -1
      GroupHeaderShow =   -1  'True
      AllowGrpResize  =   0
      AllowGrpDragDrop=   0
      MergeAdjustView =   0   'False
      ColumnHeaderShow=   -1  'True
      ColumnHeaderHeight=   -1
      GrpsFrozen      =   0
      BorderGrayAreaColor=   -2147483637
      ExtendRow       =   0
   End
   Begin VB.CommandButton CMDInstallConduit 
      Caption         =   "Install Conduit"
      Height          =   375
      Left            =   2640
      TabIndex        =   4
      Top             =   3960
      Width           =   1215
   End
   Begin VB.CheckBox CHKDontPrint 
      Caption         =   "Dont Print"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   5760
      TabIndex        =   3
      Top             =   4020
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.CommandButton CMDShowInvoice 
      Caption         =   "Create Estimate/Invoice"
      Height          =   375
      Left            =   0
      TabIndex        =   2
      Top             =   3960
      Width           =   2175
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   9480
      TabIndex        =   1
      Top             =   3960
      Width           =   1095
   End
End
Attribute VB_Name = "FRMPDAInterface"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Object
''
'' Coded by Dale Pitman

Private vIsLoaded As Boolean

Private vParent As Form                 ' The parent that this form belongs to
Private vInvoiceForm As FRMInvoice
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one

Private vSale As New ClassSale

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
End Sub


''
Private Sub LoadGrid()
    Dim rstemp As Recordset
    Dim rsLine As Recordset
    Dim Address As String
    Dim ProductName As String
    
    CMDShowInvoice.Enabled = False
    GRDInvoice.Clear
    If (OpenRecordset(rstemp, "SELECT * FROM ELF2Invoice i ", dbOpenSnapshot)) Then
        
        Do While (rstemp.EOF = False)
            If (OpenRecordset(rsLine, "SELECT * FROM ELF2Line WHERE ELF2invoiceId=" & rstemp!Uid, dbOpenSnapshot)) Then
                If (rsLine.EOF = False) Then
                    ProductName = rsLine!Name & "," & rsLine!Description
                End If
            End If
            Address = rstemp!address1 & ""
            If (rstemp!Street1 & "" <> "") Then
                Address = Address & ", " & rstemp!Street1
            End If
            If (rstemp!State & "" <> "") Then
                Address = Address & ", " & rstemp!State
            End If
            If (rstemp!Country & "" <> "") Then
                Address = Address & ", " & rstemp!Country
            End If
            Address = AutoCase(Address, True)
            
            Call GRDInvoice.AddItem(rstemp!CompanyName & vbTab & Address & vbTab _
            & rstemp!postcode & vbTab & rstemp!Name & vbTab & ProductName & vbTab & rstemp!Uid)
            Call rstemp.MoveNext
        Loop
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub WriteLine(pSaleID As Long, pName As String, pDescription As String, pQty As Long, pNetAmount As Double, pVatPercent As Double)
    Dim rsSaleLine As Recordset
    Dim rsProduct As Recordset
    Dim ProductID As Long
    Dim Sql As String
    Sql = "SELECT * FROM SaleLine WHERE SaleID=-1"
    If (OpenRecordset(rsSaleLine, Sql, dbOpenDynaset)) Then
        If (rsSaleLine.EOF = False) Then
            'Call rsSaleLine.Edit
        Else
            Call rsSaleLine.AddNew
        End If
        rsSaleLine!SaleID = pSaleID
        rsSaleLine!Product = Trim$(UCase$(pName))
        ProductID = -1
        If (pName <> "") Then
            If (OpenRecordset(rsProduct, "SELECT * FROM Product WHERE [name] like " & cTextField & pName & cWildCard & cTextField, dbOpenSnapshot)) Then
                If (rsProduct.EOF = False) Then
                    ProductID = rsProduct!Uid
                End If
            End If
        End If
        rsSaleLine!ProductID = ProductID
        rsSaleLine!Description = Trim$(UCase$(pDescription))
        rsSaleLine!NetAmount = pNetAmount
        rsSaleLine!VatAmount = pNetAmount / 100 * (pVatPercent)
'        If (DataStore(i).VAT = "Z") Then
'            rsSaleLine!VatPercent = -1
'        Else
        rsSaleLine!VatPercent = pVatPercent
'        End If
        rsSaleLine!Qty = pQty
        Call rsSaleLine.Update
    End If
    Call rsSaleLine.Close
End Sub

''
Private Sub CMDInstallConduit_Click()
'    Call Shell("regsvr32 ELF2Dll.dll", vbNormalFocus)

    If (InstallConduit() = True) Then
        Call Messagebox("Please close and re-open hotsync manager", vbInformation)
    End If
End Sub

''
Private Sub CMDShowInvoice_Click()
    Dim rsInvoice As Recordset
    Dim rsSaleLine As Recordset
    Dim rsDisclaimer As Recordset
    Dim PaymentClass As New ClassPayment
    Dim OldPaymentTotal As Currency
    Dim Invoiceid As Long
    Dim SaleID As Long
    Dim DisclaimerID As Long
    Dim i As Long
    Dim InvoiceNumber As Long
    Dim Sql As String
    Dim VatLine As Double
    
    
    Dim rstemp As Recordset
    Dim rsLine As Recordset
    Dim Address As String
    Dim postcode As String
    
    GRDInvoice.Col = 5
    Screen.MousePointer = vbHourglass
    If (OpenRecordset(rstemp, "SELECT * FROM ELF2Invoice WHERE uid=" & GRDInvoice.ColText, dbOpenDynaset)) Then
    
        Do While (rstemp.EOF = False)
    
            'Look for customer
            Call vSale.NewRecord
            Call vSale.Invoice.ClearDetails
            Call vSale.Customer.ClearDetails
            
            vSale.Customer.CompanyName = UCase$(rstemp!CompanyName & "")
            postcode = ValidatePostcode(rstemp!postcode & "")
            If (Left$(postcode, 5) = "ERROR") Then
                postcode = rstemp!postcode & ""
            Else
            End If
            vSale.Customer.postcode = postcode
            If (vSale.Customer.CompanyName = "" And vSale.Customer.postcode = "") Then
                vSale.Customer.CompanyName = "þþxxxxxxxzzzzzzzz"
            End If
            If (vSale.Customer.Search(ByCompanyName + ByPostcode) > 0) Then
                If (vSale.Customer.RecordCount = 1) Then
                    ' single match (simple)
                Else
                    ' mutiple match
                End If
            Else
                ' Create new record
                vSale.Customer.ClearDetails
                vSale.Customer.CompanyName = UCase$(rstemp!CompanyName & "")
                vSale.Customer.Name = UCase$(rstemp!Name & "")
                vSale.Customer.ContactTelephoneNumber = Left$(rstemp!worknumber & "", 13)
                vSale.Customer.Street1 = UCase$(rstemp!address1 & "")
                vSale.Customer.Street2 = UCase$(rstemp!Street1 & "")
                vSale.Customer.Town = UCase$(rstemp!State & "")
                vSale.Customer.Country = UCase$(rstemp!Country & "")
                vSale.Customer.postcode = ValidatePostcode(rstemp!postcode & "")
                vSale.Customer.DueDatePeriod = FRMOptions.DefaultDuePeriod
            End If
            
            vSale.Invoice.Invoicetype = rstemp!Invoicetype
            If (vSale.Invoice.Invoicetype <> 1) Then
                ' Create invoice
                InvoiceNumber = Val(GetServerSetting("NEXTINVOICENUMBER-" & FRMOptions.InvoiceNumberPreFix, True))
                vSale.Invoice.InvoiceNumber = FRMOptions.InvoiceNumberPreFix & InvoiceNumber
                Call SetServerSetting("NEXTINVOICENUMBER-" & FRMOptions.InvoiceNumberPreFix, InvoiceNumber + 1)
            Else
                ' estimate
                InvoiceNumber = Val(GetServerSetting("NEXTESTIMATENUMBER", True))
                vSale.Invoice.InvoiceNumber = "E" & InvoiceNumber
                Call SetServerSetting("NEXTESTIMATENUMBER", InvoiceNumber + 1)
            End If
            
            
            vSale.Invoice.Goodstotal = 0
            vSale.Invoice.Vattotal = 0
            If (OpenRecordset(rsLine, "SELECT * FROM ELF2Line WHERE ELF2invoiceId=" & rstemp!Uid, dbOpenSnapshot)) Then
                Do While (rsLine.EOF = False)
                    vSale.Invoice.Goodstotal = vSale.Invoice.Goodstotal + (rsLine!UnitCost * rsLine!Qty)
                    VatLine = (rsLine!UnitCost * rsLine!Qty) / 100 * rsLine!VatPercent
                    vSale.Invoice.Vattotal = vSale.Invoice.Vattotal + VatLine
                    Call rsLine.MoveNext
                Loop
            End If
            
            
            vSale.Invoice.Handlingtotal = rstemp!carriage
            vSale.Invoice.Invoicedate = CDate(Now)
            vSale.Invoice.Amountpaid = 0
            
            vSale.Invoice.Duedate = DateAdd("d", vSale.Customer.DueDatePeriod, Now)
            
            Call vSale.Customer.SyncRecord
            vSale.Customerid = vSale.Customer.Uid
            
            Call vSale.Customer.CreateRecord(True)
            vSale.Invoice.InvoiceCustomerID = vSale.Customer.Uid
            Call vSale.Invoice.SyncRecord
            
            ' IF a payment has been made, log it
        '    If (vSaleClass.Invoice.Amountpaid > OldPaymentTotal) Then
        '        ' Log payment
        '        PaymentClass.Amountpaid = vSaleClass.Invoice.Amountpaid - OldPaymentTotal
        '        PaymentClass.Paymentdate = CDate(TXTInvoiceDate.Text)
        '        PaymentClass.Invoiceid = vSaleClass.Invoice.Uid
        '        Call PaymentClass.CreateRecord
        '    End If
                    
            
            If (OpenRecordset(rsDisclaimer, "SELECT * FROM Disclaimer WHERE message=" & cTextField & FRMOptions.InvoiceComments & cTextField, dbOpenDynaset)) Then
                If (rsDisclaimer.EOF = False) Then
                Else
                    Call rsDisclaimer.AddNew
                End If
                DisclaimerID = rsDisclaimer!Uid
                rsDisclaimer!Message = rsDisclaimer!Message
                Call rsDisclaimer.Update
            End If
            
            vSale.DisclaimerID = DisclaimerID
            vSale.Invoiceid = vSale.Invoice.Uid
            vSale.CustomerOrderNumber = ""
            Call vSale.SyncRecord
            SaleID = vSale.Uid
            
            If (OpenRecordset(rsLine, "SELECT * FROM ELF2Line WHERE ELF2invoiceId=" & rstemp!Uid, dbOpenSnapshot)) Then
                Do While (rsLine.EOF = False)
                    Call WriteLine(SaleID, rsLine!Name & "", rsLine!Description & "", rsLine!Qty, (rsLine!UnitCost * rsLine!Qty), rsLine!VatPercent)
                    Call rsLine.MoveNext
                Loop
            End If
'            If (CHKDontPrint.Value = vbUnchecked) Then
'                Call PrintInvoice("QUOTATION", vSale)
'                For i = 0 To FRMOptions.InvoiceCopies - 1
'                    Call PrintInvoice("QUOTATION COPY", vSale)
''                Next
'            End If

            Call rstemp.Delete
            Call rstemp.MoveNext
            
        Loop
    End If

    Call LoadGrid
    Screen.MousePointer = vbDefault

End Sub

Private Function InstallConduit() As Boolean
    Dim CondData As New PALMCNTLLib.ConduitData
    Dim CondMgr As New PALMCNTLLib.ConduitManager
    Dim ConduitID As Long
    Dim Retval As Long
    '"ELF2"
    'ELF2DLL.CNotifyDll
    
    InstallConduit = False
    ' Used to report an error during the Conduit Configuration
    Const ConfigError = vbObjectError + 513
    On Error GoTo ErrorHandler
    
    ' Convert the CreatorID to a long value.
    ConduitID = CondMgr.GetCreatorIDNumberFromString("ELF2")
    ' Pass the CreatorID to install the conduit.
    Retval = CondMgr.InstallConduit(ConduitID, True)
    If Retval <> 0 Then
        If (Retval = -1005) Then
            Call Messagebox("Conduit Allready installed.", vbInformation)
            
        Else
            Call ErrorCheck("InstallConduit Failed with Error " & Retval, "Conduit Installer")
        End If
    Else
        Retval = CondData.AssignCreator(ConduitID)
        If Retval <> 0 Then
            Call ErrorCheck("AssignCreator Failed with Error " & Retval, "Conduit Installer")
        Else
            CondData.ConduitName = "ComConduit.dll"
            ' You should provide ComConduit.dll with full path. In that case, your conduit
            ' will run with any HotSync 'if user upgrades and moves Hotsync to another
            ' directory. Keep in mind that for any version of Hotsync to 'run your COM
            ' conduits, it should find ComConduit.Dll in the same directory (from where
            ' Hotsync is 'running) or in the PATH.
            CondData.Priority = 2
            CondData.RemoteDb = ""
            CondData.Directory = ""
            CondData.filename = ""
            CondData.Title = "PyroDesign SInvoice PDA Conduit"
            ' The Valuestring is set to the Notification class of the conduit.
            CondData.ValueString("COMClient", "") = "ELF2DLL.CNotifyDll"
            InstallConduit = True
        End If
    End If
    
    
    
    '************Use the following code to remove your conduit***************
    ' This returns 1 if it was removed successfully.
'    Retval = (CondMgr.RemoveConduit(ConduitID))
'    If Retval <> 1 Then
'        Call ErrorCheck("RemoveConduit Failed", "Conduit Installer")
'    End If
Exit Function
ErrorHandler:
    If Err.Number = ConfigError Then
        Call ErrorCheck("Conduit Configuration Failed." & vbCr & "Conduit Configuration Error : " & Retval, "Conduit Installer")
    Else
        Call ErrorCheck("Conduit Configuration Failed.", "Conduit Installer")
    End If
End Function


''
Private Sub Form_Load()
    vIsLoaded = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)
    
    Set vInvoiceForm = New FRMInvoice
    Call vInvoiceForm.SetParent(Me)
    
    Call LoadGrid
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
End Sub

Private Sub GRDInvoice_Click()
    If (GRDInvoice.ListIndex >= 0) Then
        CMDShowInvoice.Enabled = True
    End If
End Sub
