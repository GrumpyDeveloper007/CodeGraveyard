VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassSale"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit
''***********************************************************************
'' Class file for accessing table - Sale
''
'' Code by Dale Pitman

'' Used by appliance Class
Public Enum SaleSearchENUM
    ByCustomerID = 1
End Enum

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vInvoiceid As Long
 Private vCustomerid As Long
 Private vDisclaimerID As Long
 Private vCustomerOrderNumber As String
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vInvoiceidC As Boolean
 Private vCustomeridC As Boolean
 Private vDisclaimerIDC As Boolean
 Private vCustomerOrderNumberC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vInvoiceClass As ClassInvoice
Private vCustomerClass As ClassCustomer

''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
    Call LogEvent("Sale Class, Clear")
'' %^07
    vUidC = False
    vUid = 0
    vInvoiceidC = False
    vInvoiceid = 0
    vCustomeridC = False
    vCustomerid = 0
    vDisclaimerIDC = False
    vDisclaimerID = 0
    vCustomerOrderNumber = ""
    vCustomerOrderNumberC = False
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Set vInvoiceClass = New ClassInvoice
    Set vCustomerClass = New ClassCustomer
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

Public Property Get Invoice() As ClassInvoice
    Set Invoice = vInvoiceClass
End Property
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

Public Property Get Customerid() As Long
    Customerid = vCustomerid
End Property

Public Property Let Customerid(ByVal NewValue As Long)
    vCustomerid = NewValue
    vCustomeridC = True
End Property

Public Property Get DisclaimerID() As Long
    DisclaimerID = vDisclaimerID
End Property

Public Property Let DisclaimerID(ByVal NewValue As Long)
    vDisclaimerID = NewValue
    vDisclaimerIDC = True
End Property

Public Property Get CustomerOrderNumber() As String
    CustomerOrderNumber = vCustomerOrderNumber
End Property

Public Property Let CustomerOrderNumber(ByVal NewValue As String)
    vCustomerOrderNumber = NewValue
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
        sql = "SELECT * FROM Sale WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        sql = "SELECT * FROM Sale WHERE InvoiceID= " & vInvoiceid
    End If

    If (OpenRecordset(rsSearch, sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
    Call LogEvent("Sale Class, Read Record")
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vInvoiceid = Val(rsSearch!Invoiceid & "")
        vCustomerid = Val(rsSearch!Customerid & "")
        vDisclaimerID = rsSearch!DisclaimerID & ""
        vCustomerOrderNumber = rsSearch!CustomerOrderNumber & ""
'' %^12
            ' Sub-class resync
            vInvoiceClass.Uid = vInvoiceid
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
        Call ErrorCheck("Error Status (" & Trim(Erl) & ").  " & Error$ & " has occurred.", "ReadRecord, Sale")
        ReadRecord = False
    End If
End Function

''*************************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim sql As String
    Dim AddComma As Boolean

    Call LogEvent("Sale Class, Write Record")
    AddComma = False
    sql = "UPDATE Sale SET "
'' %^13
    If (vInvoiceidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Invoiceid=" & vInvoiceid
    End If
    If (vCustomeridC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Customerid=" & vCustomerid
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

    Call LogEvent("Sale Class, Create Record")
    sql = "INSERT INTO Sale ("
    FieldData = "("
        
    
        If (vInvoiceidC = True) Then
            sql = sql & "Invoiceid,"
            FieldData = FieldData & "'" & vInvoiceid & "',"
'            rstemp!Invoiceid = vInvoiceid
        End If
        If (vCustomeridC = True) Then
            sql = sql & "Customerid,"
            FieldData = FieldData & "'" & vCustomerid & "',"
'            rstemp!Customerid = vCustomerid
        End If
        If (vDisclaimerIDC = True) Then
            sql = sql & "DisclaimerID,"
            FieldData = FieldData & "'" & vDisclaimerID & "',"
'            rstemp!DisclaimerID = vDisclaimerID
        End If
        If (vCustomerOrderNumberC = True) Then
            sql = sql & "CustomerOrderNumber,"
            FieldData = FieldData & "'" & vCustomerOrderNumber & "',"
'            rstemp!CustomerOrderNumber = vCustomerOrderNumber
        End If
    
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
    If (ErrorCheck(Error$, "CreateRecord, Sale")) Then
        Resume
    End If
End Function

''*************************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim sql As String

    sql = "DELETE * FROM Sale where Uid=" & vUid

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
        vCustomerid = Val(vrsSearch!Customerid & "")
        vDisclaimerID = Val(vrsSearch!DisclaimerID & "")
        vCustomerOrderNumber = vrsSearch!CustomerOrderNumber & ""
'' %^20

        vFoundC = True
    ' Set sub-class resync -
            vInvoiceClass.Uid = vInvoiceid

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
Public Function Search(pSearchType As SaleSearchENUM) As Long
    Dim sql As String
    Dim AddAnd As Boolean
    
    ' to support mutiple matches, see
'    vSearchby = pSearchType
    AddAnd = False
    sql = "SELECT * from Sale WHERE "
    ' returns number of matches, -1 error
    If (BAnd(pSearchType, ByCustomerID)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & " customerid=" & vCustomerid
        AddAnd = True
    End If
    
    If (OpenRecordset(vrsSearch, sql, dbOpenSnapshot)) Then
        ' Read first record, get numRecords, init position
        vRecordNumber = 1
        If (vrsSearch.EOF = False) Then
            vFoundC = True
            Call MoveLastFirst(vrsSearch)
            vRecordCount = vrsSearch.RecordCount
            Search = vRecordCount
            Call LoadFromSearch
        Else
            ' No records found
            vFoundC = False
            Search = 0
        End If
    Else
        vFoundC = False
        Search = 0
    End If
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


