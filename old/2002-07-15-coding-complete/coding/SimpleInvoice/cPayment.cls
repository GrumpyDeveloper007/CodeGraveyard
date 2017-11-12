VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassPayment"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Payment
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vInvoiceid As Long
 Private vAccountid As Long
 Private vAmountpaid As Currency
 Private vPaymentdate As Date
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vInvoiceidC As Boolean
 Private vAccountidC As Boolean
 Private vAmountpaidC As Boolean
 Private vPaymentdateC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vInvoiceidC = False
    vInvoiceid = 0
    vAccountidC = False
    vAccountid = 0
    vAmountpaidC = False
    vAmountpaid = 0
    vPaymentdateC = False
    vPaymentdate = 0
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

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

Public Property Get AccountID() As Long
    AccountID = vAccountid
End Property

Public Property Let AccountID(ByVal NewValue As Long)
    vAccountid = NewValue
    vAccountidC = True
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
        sql = "SELECT * FROM Payment WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        sql = "SELECT * FROM Payment WHERE "
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
        vAccountid = Val(rsSearch!AccountID & "")
        vAmountpaid = Val(rsSearch!Amountpaid & "")
        If (IsDate(vPaymentdate)) Then
            vPaymentdate = rsSearch!Paymentdate & ""
        End If
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
        Call ErrorCheck("Error Status (" & Trim(Erl) & ").  " & Error$ & " has occurred.", "Readrecord, Payment")
        ReadRecord = False
    End If
End Function

''*************************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim sql As String
    Dim AddComma As Boolean

    AddComma = False
    sql = "UPDATE Payment SET "
'' %^13
    If (vInvoiceidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Invoiceid=" & vInvoiceid
    End If
    If (vAccountidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Accountid=" & vAccountid
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

    'Call SetDefaultValues
    sql = "INSERT INTO Payment ("
'' %^15
        sql = sql & "Invoiceid"
        sql = sql & ",Accountid"
    If (vAmountpaidC = True) Then
        sql = sql & ",Amountpaid"
    End If
    If (vPaymentdateC = True) Then
        sql = sql & ",Paymentdate"
    End If
    sql = sql & ") VALUES ("
        sql = sql & vInvoiceid
        sql = sql & "," & AccountID
    If (vAmountpaidC = True) Then
        sql = sql & "," & vAmountpaid
    End If
    If (vPaymentdateC = True) Then
        sql = sql & ",'" & vPaymentdate & "'"
    End If
    sql = sql & ") "
'' %^16


    If (Execute(sql) > 0) Then
'        Call ClearStatus
        CreateRecord = True
    Else
        'error
        CreateRecord = False
    End If
    
End Function

''*************************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim sql As String

    sql = "DELETE * FROM Payment where Uid=" & vUid

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

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vInvoiceid = Val(vrsSearch!Invoiceid & "")
        vAccountid = Val(vrsSearch!AccountID & "")
        vAmountpaid = Val(vrsSearch!Amountpaid & "")
        If (IsDate(vrsSearch!Paymentdate)) Then
            vPaymentdate = vrsSearch!Paymentdate & ""
        End If
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


