VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassCreditNote"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - CreditNote
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vInvoiceid As Long
 Private vCreditnotenumber As String
 Private vGoodstotal As Currency
 Private vVattotal As Currency
 Private vHandlingtotal As Currency
 Private vCreditnotedate As Date
 Private vStatus As Long
 Private vAmountpaid As Currency
 Private vPaymentdate As Date
 Private vInvoicetype As Long
 Private vDuedate As Date
 Private vVatbatchnumber As Long
 Private vDisclaimerID As Long
 Private vCustomerOrderNumber As String
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vInvoiceidC As Boolean
 Private vCreditnotenumberC As Boolean
 Private vGoodstotalC As Boolean
 Private vVattotalC As Boolean
 Private vHandlingtotalC As Boolean
 Private vCreditnotedateC As Boolean
 Private vStatusC As Boolean
 Private vAmountpaidC As Boolean
 Private vPaymentdateC As Boolean
 Private vInvoicetypeC As Boolean
 Private vDuedateC As Boolean
 Private vVatbatchnumberC As Boolean
 Private vDisclaimerIDC As Boolean
 Private vCustomerOrderNumberC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vCustomerClass As ClassCustomer

''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vInvoiceidC = False
    vInvoiceid = 0
    vCreditnotenumberC = False
    vCreditnotenumber = ""
    vGoodstotalC = False
    vGoodstotal = 0
    vVattotalC = False
    vVattotal = 0
    vHandlingtotalC = False
    vHandlingtotal = 0
    vCreditnotedateC = False
    vCreditnotedate = 0
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
    vVatbatchnumberC = False
    vVatbatchnumber = 0
    vDisclaimerIDC = False
    vDisclaimerID = 0
    vCustomerOrderNumber = ""
    vCustomerOrderNumberC = False
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    Set vCustomerClass = New ClassCustomer
    ' Subclass initialisation go's here
End Sub

Public Property Get Customer() As ClassCustomer
    Set Customer = vCustomerClass
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

Public Property Get Invoiceid() As Long
    Invoiceid = vInvoiceid
End Property

Public Property Let Invoiceid(ByVal NewValue As Long)
    vInvoiceid = NewValue
    vInvoiceidC = True
End Property

Public Property Get Creditnotenumber() As String
    Creditnotenumber = vCreditnotenumber
End Property

Public Property Let Creditnotenumber(ByVal NewValue As String)
    vCreditnotenumber = NewValue
    vCreditnotenumberC = True
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

Public Property Get Creditnotedate() As Date
    Creditnotedate = vCreditnotedate
End Property

Public Property Let Creditnotedate(ByVal NewValue As Date)
    vCreditnotedate = NewValue
    vCreditnotedateC = True
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

Public Property Get DisclaimerID() As Long
    DisclaimerID = vDisclaimerID
End Property

Public Property Let DisclaimerID(ByVal NewValue As Long)
    vDisclaimerID = NewValue
    vDisclaimerIDC = True
End Property

Public Property Get CustomerOrderNumber() As String
    CustomerOrderNumber = AutoCase(vCustomerOrderNumber, True)
End Property

Public Property Let CustomerOrderNumber(ByVal NewValue As String)
    vCustomerOrderNumber = UCase$(NewValue)
    vCustomerOrderNumberC = True
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
    Dim sql As String
    Dim rsSearch As Recordset

    On Error GoTo GeneralError

'    MCurrentRecord=-1
    If (vUidC = True) Then ' If key field written to then use that,
        sql = "SELECT * FROM CreditNote WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        sql = "SELECT * FROM CreditNote WHERE "
    End If

    If (OpenRecordset(rsSearch, sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vInvoiceid = Val(rsSearch!Invoiceid & "")
        vCreditnotenumber = rsSearch!Creditnotenumber & ""
        vGoodstotal = Val(rsSearch!Goodstotal & "")
        vVattotal = Val(rsSearch!Vattotal & "")
        vHandlingtotal = Val(rsSearch!Handlingtotal & "")
        If (IsDate(rsSearch!Creditnotedate & "")) Then
            vCreditnotedate = rsSearch!Creditnotedate & ""
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
        vDisclaimerID = rsSearch!DisclaimerID & ""
        vCustomerOrderNumber = rsSearch!CustomerOrderNumber & ""
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
        Call ErrorCheck("Error Status (" & Trim(Erl) & ").  " & Error$ & " has occurred.", "ReadRecord, CreditNote")
        ReadRecord = False
    End If
End Function

''*************************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim sql As String
    Dim AddComma As Boolean

    AddComma = False
    sql = "UPDATE CreditNote SET "
'' %^13
    If (vInvoiceidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Invoiceid=" & vInvoiceid
    End If
    If (vCreditnotenumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Creditnotenumber=" & cTextField & vCreditnotenumber & cTextField
    End If
    If (vGoodstotalC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Goodstotal=" & vGoodstotal
    End If
    If (vVattotalC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Vattotal=" & vVattotal
    End If
    If (vHandlingtotalC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Handlingtotal=" & vHandlingtotal
    End If
    If (vCreditnotedateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Creditnotedate=" & vCreditnotedate
    End If
    If (vStatusC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Status=" & vStatus
    End If
    If (vAmountpaidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Amountpaid=" & vAmountpaid
    End If
    If (vPaymentdateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Paymentdate=" & vPaymentdate
    End If
    If (vInvoicetypeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Invoicetype=" & vInvoicetype
    End If
    If (vDuedateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Duedate=" & vDuedate
    End If
    If (vVatbatchnumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Vatbatchnumber=" & vVatbatchnumber
    End If
    If (vDisclaimerIDC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " DisclaimerID=" & cTextField & vDisclaimerID & cTextField
    End If
    If (vCustomerOrderNumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " CustomerOrderNumber=" & cTextField & vCustomerOrderNumber & cTextField
    End If
'' %^14

    sql = sql & " WHERE Uid =" & vUid
    
    If (Execute(sql) > 0) Then
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
    Dim sql As String
    Dim FieldData As String
    On Error GoTo GeneralError

    sql = "INSERT INTO CreditNote ("
    FieldData = "("
        
    
'' %^15
    If (vInvoiceidC = True) Then
        sql = sql & "Invoiceid,"
        FieldData = FieldData & vInvoiceid & ","
'            rstemp!Invoiceid = vInvoiceid
    End If
    If (vCreditnotenumberC = True) Then
        sql = sql & "Creditnotenumber,"
        FieldData = FieldData & "'" & vCreditnotenumber & "',"
'            rstemp!Creditnotenumber = vCreditnotenumber
    End If
    If (vGoodstotalC = True) Then
        sql = sql & "Goodstotal,"
        FieldData = FieldData & vGoodstotal & ","
'            rstemp!Goodstotal = vGoodstotal
    End If
    If (vVattotalC = True) Then
        sql = sql & "Vattotal,"
        FieldData = FieldData & "" & vVattotal & ","
'            rstemp!Vattotal = vVattotal
    End If
    If (vHandlingtotalC = True) Then
        sql = sql & "Handlingtotal,"
        FieldData = FieldData & "" & vHandlingtotal & ","
'            rstemp!Handlingtotal = vHandlingtotal
    End If
    If (vCreditnotedateC = True) Then
        sql = sql & "Creditnotedate,"
        FieldData = FieldData & "'" & vCreditnotedate & "',"
'            rstemp!Creditnotedate = vCreditnotedate
    End If
    If (vStatusC = True) Then
        sql = sql & "Status,"
        FieldData = FieldData & "'" & vStatus & "',"
'            rstemp!Status = vStatus
    End If
    If (vAmountpaidC = True) Then
        sql = sql & "Amountpaid,"
        FieldData = FieldData & "" & vAmountpaid & ","
'            rstemp!Amountpaid = vAmountpaid
    End If
    If (vPaymentdateC = True) Then
        sql = sql & "Paymentdate,"
        FieldData = FieldData & "'" & vPaymentdate & "',"
'            rstemp!Paymentdate = vPaymentdate
    End If
    If (vInvoicetypeC = True) Then
        sql = sql & "Invoicetype,"
        FieldData = FieldData & "" & vInvoicetype & ","
'            rstemp!Invoicetype = vInvoicetype
    End If
    If (vDuedateC = True) Then
        sql = sql & "Duedate,"
        FieldData = FieldData & "'" & vDuedate & "',"
'            rstemp!Duedate = vDuedate
    End If
    If (vVatbatchnumberC = True) Then
        sql = sql & "Vatbatchnumber,"
        FieldData = FieldData & "" & vVatbatchnumber & ","
'            rstemp!Vatbatchnumber = vVatbatchnumber
    End If
    If (vDisclaimerIDC = True) Then
        sql = sql & "DisclaimerID,"
        FieldData = FieldData & "" & vDisclaimerID & ","
'            rstemp!DisclaimerID = vDisclaimerID
    End If
    If (vCustomerOrderNumberC = True) Then
        sql = sql & "CustomerOrderNumber,"
        FieldData = FieldData & "'" & vCustomerOrderNumber & "',"
'            rstemp!CustomerOrderNumber = vCustomerOrderNumber
    End If
'' %^16
    
    sql = Left$(sql, Len(sql) - 1)
    FieldData = Left$(FieldData, Len(FieldData) - 1)
    vUid = CreateRecordWithSQL(sql & ") VALUES " & FieldData & ")")
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
    If (ErrorCheck(Error$, "CreateRecord, CreditNote")) Then
        Resume
    End If
End Function

''*************************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim sql As String

    sql = "DELETE * FROM CreditNote where Uid=" & vUid

    If (Execute(sql) > 0) Then
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
        vInvoiceid = Val(vrsSearch!Invoiceid & "")
        vCreditnotenumber = vrsSearch!Creditnotenumber & ""
        vGoodstotal = Val(vrsSearch!Goodstotal & "")
        vVattotal = Val(vrsSearch!Vattotal & "")
        vHandlingtotal = Val(vrsSearch!Handlingtotal & "")
        If (IsDate(vrsSearch!Creditnotedate)) Then
            vCreditnotedate = vrsSearch!Creditnotedate & ""
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
        vDisclaimerID = Val(vrsSearch!DisclaimerID & "")
        vCustomerOrderNumber = vrsSearch!CustomerOrderNumber & ""
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



