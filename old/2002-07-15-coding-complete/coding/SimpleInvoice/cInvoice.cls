VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassInvoice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Invoice
''
'' Code by Dale Pitman

''
Public Enum InvoiceSearchENUM
    ByInvoiceType = 1
End Enum

Public Enum InvoiceOrderByENUM
    OrderNone = 1
End Enum

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vInvoiceCustomerID As Long
 Private vInvoicenumber As String
 Private vGoodstotal As Currency
 Private vVattotal As Currency
 Private vHandlingtotal As Currency
 Private vInvoicedate As Date
 Private vStatus As Long
 Private vAmountpaid As Currency
 Private vPaymentdate As Date
 Private vInvoicetype As Long
 Private vDuedate As Date
 Private vVatbatchnumber As Long
 Private vVATPaid As Currency
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vInvoiceCustomerIDC As Boolean
 Private vInvoicenumberC As Boolean
 Private vGoodstotalC As Boolean
 Private vVattotalC As Boolean
 Private vHandlingtotalC As Boolean
 Private vInvoicedateC As Boolean
 Private vStatusC As Boolean
 Private vAmountpaidC As Boolean
 Private vPaymentdateC As Boolean
 Private vInvoicetypeC As Boolean
 Private vDuedateC As Boolean
 Private vVatbatchnumberC As Boolean
 Private vVATPaidC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vSearchby As InvoiceSearchENUM
Private vSuppressRecordCount As Boolean

''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vInvoiceCustomerIDC = False
    vInvoiceCustomerID = 0
    vInvoicenumberC = False
    vInvoicenumber = ""
    vGoodstotalC = False
    vGoodstotal = 0
    vVattotalC = False
    vVattotal = 0
    vHandlingtotalC = False
    vHandlingtotal = 0
    vInvoicedateC = False
    vInvoicedate = 0
    vStatusC = False
    vStatus = 0
    vAmountpaidC = False
    vAmountpaid = 0
    vPaymentdateC = False
    vPaymentdate = 0
    vInvoicetypeC = False
    vInvoicetype = 0
    vDuedateC = False
    vDuedate = 0
    vVatbatchnumber = 0
    vVatbatchnumberC = False
    vVATPaid = 0
    vVATPaidC = False
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Property Get SuppressRecordCount() As Boolean
    SuppressRecordCount = vSuppressRecordCount
End Property

Public Property Let SuppressRecordCount(ByVal NewValue As Boolean)
    vSuppressRecordCount = NewValue
End Property

''*************************************************************************
'' Update Property Procedures

Public Property Get RecordNumber() As Long
    RecordNumber = vRecordNumber
End Property

Public Property Get RecordCount() As Long
    RecordCount = vRecordCount
End Property

'' %^09
Public Property Get Uid() As Long
    Uid = vUid
End Property

Public Property Let Uid(ByVal NewValue As Long)
    vUid = NewValue
    vUidC = True
End Property


Public Property Get InvoiceCustomerID() As Long
    InvoiceCustomerID = vInvoiceCustomerID
End Property

Public Property Let InvoiceCustomerID(ByVal NewValue As Long)
    vInvoiceCustomerID = NewValue
    vInvoiceCustomerIDC = True
End Property

Public Property Get InvoiceNumber() As String
    InvoiceNumber = vInvoicenumber
End Property

Public Property Let InvoiceNumber(ByVal NewValue As String)
    vInvoicenumber = NewValue
    vInvoicenumberC = True
End Property

Public Property Get Goodstotal() As Currency
    Goodstotal = vGoodstotal
End Property

Public Property Let Goodstotal(ByVal NewValue As Currency)
    vGoodstotal = NewValue
    vGoodstotalC = True
End Property

Public Property Get Vattotal() As Currency
    Vattotal = vVattotal
End Property

Public Property Let Vattotal(ByVal NewValue As Currency)
    vVattotal = NewValue
    vVattotalC = True
End Property

Public Property Get Handlingtotal() As Currency
    Handlingtotal = vHandlingtotal
End Property

Public Property Let Handlingtotal(ByVal NewValue As Currency)
    vHandlingtotal = NewValue
    vHandlingtotalC = True
End Property

Public Property Get Invoicedate() As Date
    Invoicedate = vInvoicedate
End Property

Public Property Let Invoicedate(ByVal NewValue As Date)
    vInvoicedate = NewValue
    vInvoicedateC = True
End Property

Public Property Get Status() As Long
    Status = vStatus
End Property

Public Property Let Status(ByVal NewValue As Long)
    vStatus = NewValue
    vStatusC = True
End Property

Public Property Get Amountpaid() As Currency
    Amountpaid = vAmountpaid
End Property

Public Property Let Amountpaid(ByVal NewValue As Currency)
    vAmountpaid = NewValue
    vAmountpaidC = True
End Property

Public Property Get Paymentdate() As Date
    Paymentdate = vPaymentdate
End Property

Public Property Let Paymentdate(ByVal NewValue As Date)
    vPaymentdate = NewValue
    vPaymentdateC = True
End Property

'' Invoice type 0=invoice,1=estimate, >1=invoice from different workstation
Public Property Get Invoicetype() As Long
    Invoicetype = vInvoicetype
End Property

Public Property Let Invoicetype(ByVal NewValue As Long)
    vInvoicetype = NewValue
    vInvoicetypeC = True
End Property

Public Property Get Duedate() As Date
    Duedate = vDuedate
End Property

Public Property Let Duedate(ByVal NewValue As Date)
    vDuedate = NewValue
    vDuedateC = True
End Property
Public Property Get Vatbatchnumber() As Long
    Vatbatchnumber = vVatbatchnumber
End Property

Public Property Let Vatbatchnumber(ByVal NewValue As Long)
    vVatbatchnumber = NewValue
    vVatbatchnumberC = True
End Property

Public Property Get VATPaid() As Currency
    VATPaid = vVATPaid
End Property

Public Property Let VATPaid(ByVal NewValue As Currency)
    vVATPaid = NewValue
    vVATPaidC = True
End Property

'' %^10

''*************************************************************************
'' Status of record search
Public Property Get Found() As Boolean
        Found = vFoundC
End Property

'Public Property Let Found(ByVal NewValue As boolean)
'    vFound = NewValue
'End Property

''*************************************************************************
'' Read Record
Public Function ReadRecord() As Boolean
    Dim Sql As String
    Dim rsSearch As Recordset

    On Error GoTo GeneralError

'    MCurrentRecord=-1
    If (vUidC = True) Then ' If key field written to then use that,
        Sql = "SELECT * FROM Invoice WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM Invoice WHERE InvoiceNumber=" & cTextField & vInvoicenumber & cTextField
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vInvoiceCustomerID = Val(rsSearch!InvoiceCustomerID & "")
        vInvoicenumber = rsSearch!InvoiceNumber & ""
        vGoodstotal = Val(rsSearch!Goodstotal & "")
        vVattotal = Val(rsSearch!Vattotal & "")
        vHandlingtotal = Val(rsSearch!Handlingtotal & "")
        If (IsDate(rsSearch!Invoicedate & "")) Then
            vInvoicedate = rsSearch!Invoicedate & ""
        End If
        vStatus = Val(rsSearch!Status & "")
        vAmountpaid = Val(rsSearch!Amountpaid & "")
        If (IsDate(rsSearch!Paymentdate & "")) Then
            vPaymentdate = rsSearch!Paymentdate & ""
        End If
        vInvoicetype = Val(rsSearch!Invoicetype & "")
        If (IsDate(rsSearch!Duedate & "")) Then
            vDuedate = rsSearch!Duedate & ""
        End If
        vVatbatchnumber = Val(rsSearch!Vatbatchnumber & "")
        vVATPaid = Val(rsSearch!VATPaid & "")
'' %^12
            ' Sub-class resync
        End If
    Else
        vFoundC = False
    End If

    ' Return record found
    ReadRecord = vFoundC
    Exit Function
GeneralError:
    If Err = 94 Then
        Resume Next
    Else
        Call ErrorCheck("Error Status (" & Trim(Erl) & ").  " & Error$ & " has occurred.", "ReadRecord, Invoice")
        ReadRecord = False
    End If
End Function

''*************************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim Sql As String
    Dim AddComma As Boolean

    AddComma = False
    Sql = "UPDATE Invoice SET "
'' %^13

    If (vInvoiceCustomerIDC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " InvoiceCustomerID=" & vInvoiceCustomerID
    End If
    If (vInvoicenumberC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Invoicenumber=" & cTextField & vInvoicenumber & cTextField
    End If
    If (vGoodstotalC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Goodstotal=" & vGoodstotal
    End If
    If (vVattotalC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Vattotal=" & vVattotal
    End If
    If (vHandlingtotalC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Handlingtotal=" & vHandlingtotal
    End If
    If (vInvoicedateC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Invoicedate=" & cTextField & vInvoicedate & cTextField
    End If
    If (vStatusC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Status=" & vStatus
    End If
    If (vAmountpaidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Amountpaid=" & vAmountpaid
    End If
    If (vPaymentdateC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Paymentdate=" & cTextField & vPaymentdate & cTextField
    End If
    If (vInvoicetypeC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Invoicetype=" & vInvoicetype
    End If
    If (vDuedateC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Duedate=" & cTextField & vDuedate & cTextField
    End If
    If (vVatbatchnumberC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " VatBatchNumber=" & vVatbatchnumber
    End If
    If (vVATPaidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " VATPaid=" & vVATPaid
    End If
    
'' %^14

    Sql = Sql & " WHERE Uid =" & vUid
    
    If (Execute(Sql) > 0) Then
    ' this should return the result from updating the database
'        Call ClearStatus
        WriteRecord = True
    Else
        'error
        WriteRecord = False
    End If
End Function

''*************************************************************************
'' Create Record

Public Function CreateRecord() As Boolean
    Dim Sql As String
    Dim FieldData As String
    On Error GoTo GeneralError

    Sql = "INSERT INTO Invoice ("
    FieldData = "("
        
    
        Sql = Sql & "Invoicenumber,"
        FieldData = FieldData & "'" & vInvoicenumber & "',"
'        rstemp!Invoicenumber = vInvoicenumber

        If (vInvoiceCustomerIDC = True) Then
            Sql = Sql & "InvoiceCustomerID,"
            FieldData = FieldData & "" & vInvoiceCustomerID & ","
        End If
        If (vGoodstotalC = True) Then
            Sql = Sql & "Goodstotal,"
            FieldData = FieldData & "" & vGoodstotal & ","
'            rstemp!Goodstotal = vGoodstotal
        End If
        If (vVattotalC = True) Then
            Sql = Sql & "Vattotal,"
            FieldData = FieldData & "" & vVattotal & ","
'            rstemp!Vattotal = vVattotal
        End If
        If (vHandlingtotalC = True) Then
            Sql = Sql & "Handlingtotal,"
            FieldData = FieldData & "" & vHandlingtotal & ","
'            rstemp!Handlingtotal = vHandlingtotal
        End If
        If (vInvoicedateC = True) Then
            Sql = Sql & "Invoicedate,"
            FieldData = FieldData & "'" & vInvoicedate & "',"
'            rstemp!Invoicedate = vInvoicedate
        End If
        If (vStatusC = True) Then
            Sql = Sql & "Status,"
            FieldData = FieldData & "" & vStatus & ","
'            rstemp!Status = vStatus
        End If
        If (vAmountpaidC = True) Then
            Sql = Sql & "Amountpaid,"
            FieldData = FieldData & "" & vAmountpaid & ","
'            rstemp!Amountpaid = vAmountpaid
        End If
        If (vPaymentdateC = True) Then
            Sql = Sql & "Paymentdate,"
            FieldData = FieldData & "'" & vPaymentdate & "',"
'            rstemp!Paymentdate = vPaymentdate
        End If
        If (vInvoicetypeC = True) Then
            Sql = Sql & "Invoicetype,"
            FieldData = FieldData & "" & vInvoicetype & ","
'            rstemp!Invoicetype = vInvoicetype
        End If
        If (vDuedateC = True) Then
            Sql = Sql & "Duedate,"
            FieldData = FieldData & "'" & vDuedate & "',"
'            rstemp!Duedate = vDuedate
        End If
        If (vDuedateC = True) Then
            Sql = Sql & "Vatbatchnumber,"
            FieldData = FieldData & "'" & vVatbatchnumber & "',"
'            rstemp!Vatbatchnumber = vVatbatchnumber
        End If
        If (vVATPaidC = True) Then
            Sql = Sql & "VATPaid,"
            FieldData = FieldData & "'" & vVATPaid & "',"
'            rstemp!VATPaid= vVATPaid
        End If

    Sql = Left$(Sql, Len(Sql) - 1)
    FieldData = Left$(FieldData, Len(FieldData) - 1)
    vUid = CreateRecordWithSQL(Sql & ") VALUES " & FieldData & ")")
    If (vUid > 0) Then
        CreateRecord = True
        vFoundC = True

    Else
        CreateRecord = False
        vFoundC = False
    End If
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Exit Function
GeneralError:
    If (ErrorCheck(Error$, "CreateRecord, Invoice")) Then
        Resume
    End If
End Function

''*************************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim Sql As String

    Sql = "DELETE * FROM Invoice where Uid=" & vUid

    If (Execute(Sql) > 0) Then
    ' If no records effected then Fail
        Call ClearStatus
        DeleteRecord = True
    Else
        'error
        DeleteRecord = False
    End If
End Function

''*************************************************************************
'' Clear local data
Public Function ClearDetails()
    ' Clear all internal data
    ' Sets object ready for new record
    Call ClearStatus
End Function

''*************************************************************************
'' Local Functions

''

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vInvoiceCustomerID = Val(vrsSearch!InvoiceCustomerID & "")
        vInvoicenumber = vrsSearch!InvoiceNumber & ""
        vGoodstotal = Val(vrsSearch!Goodstotal & "")
        vVattotal = Val(vrsSearch!Vattotal & "")
        vHandlingtotal = Val(vrsSearch!Handlingtotal & "")
        If (IsDate(vrsSearch!Invoicedate)) Then
            vInvoicedate = vrsSearch!Invoicedate & ""
        End If
        vStatus = Val(vrsSearch!Status & "")
        vAmountpaid = Val(vrsSearch!Amountpaid & "")
        If (IsDate(vrsSearch!Paymentdate)) Then
            vPaymentdate = vrsSearch!Paymentdate & ""
        End If
        vInvoicetype = Val(vrsSearch!Invoicetype & "")
        If (IsDate(vrsSearch!Duedate)) Then
            vDuedate = vrsSearch!Duedate & ""
        End If
        vVatbatchnumber = Val(vrsSearch!Vatbatchnumber & "")
        vVATPaid = Val(vrsSearch!VATPaid & "")
'' %^20

        vFoundC = True
    ' Set sub-class resync -

    ' Move to next record
    vrsSearch.MoveNext
    vRecordNumber = vRecordNumber + 1
End Sub

''*************************************************************************
'' Multiple Record Selection

'' Copy data from search recordset and move cursor to next record
Public Function NextRecord(Optional pRecordNumber As Long = -100) As Boolean
    ' sets properties to next record in search operation
    ' or sets to a specified record (pRecordNumber)
    
    ' returns false for fail(eof)
    If (pRecordNumber = -100) Then
        ' Get next record
    Else
        ' Set position then get record
        Call vrsSearch.Move(pRecordNumber - vRecordNumber)
        vRecordNumber = pRecordNumber
    End If
    
    ' returns false for fail(eof)
    If (vrsSearch.EOF() = True) Then
        NextRecord = False
    Else
        ' read record
        Call LoadFromSearch
        NextRecord = True
    End If
End Function


''
Public Function NewRecord()
    ' resets all data, so ready for new call (including children)
    Call ClearStatus
End Function

''
Public Function SyncRecord() As Long
    If (vFoundC = False) Then
        Call CreateRecord
    Else
        Call WriteRecord
    End If
    SyncRecord = vUid
End Function

''
Public Function Search(pSearchType As InvoiceSearchENUM, Optional pOrderBy As InvoiceOrderByENUM = OrderNone) As Long
    Dim Sql As String
    Dim AddAnd As Boolean
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    ' to support mutiple matches, see
    vSearchby = pSearchType
    
    ' returns number of matches, -1 error
    Sql = "SELECT * FROM Invoice WHERE "
    AddAnd = False
    
    
    If (BAnd(pSearchType, ByInvoiceType)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " InvoiceType LIKE " & vInvoicetype
        AddAnd = True
    End If
'    If (BAnd(pSearchType, ByPostcode)) Then
'        If (AddAnd = True) Then
'            Sql = Sql & " AND "
'        End If
'        Sql = Sql & " Postcode LIKE " & cTextField & vPostCode & cWildCard & cTextField
'        AddAnd = True
'    End If
    
    Select Case pOrderBy
'        Case OrderSurname
'            Sql = Sql & " ORDER BY name"
        Case OrderNone
            Sql = Sql
    End Select
    
    If (OpenRecordset(vrsSearch, Sql, dbOpenSnapshot)) Then
        ' Read first record, get numRecords, init position
        vRecordNumber = 1
        If (vrsSearch.EOF = False) Then
            vFoundC = True
            If (vSuppressRecordCount = False) Then
                Call MoveLastFirst(vrsSearch)
                vRecordCount = vrsSearch.RecordCount
                Search = vRecordCount
            Else
                Search = 2
            End If
            Call LoadFromSearch
        Else
            ' No records found
            Search = 0
            vFoundC = False
        End If
    Else
        Search = 0
        vFoundC = False
    End If
End Function

