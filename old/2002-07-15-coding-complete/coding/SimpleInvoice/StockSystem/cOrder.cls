VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassOrder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Order
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vSupplierid As Long
 Private vOrderdate As Date
 Private vDeliverydate As Date
 Private vStatus As String
 Private vBatchnumber As Long
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vSupplieridC As Boolean
 Private vOrderdateC As Boolean
 Private vDeliverydateC As Boolean
 Private vStatusC As Boolean
 Private vBatchnumberC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vOrderLineClass As ClassOrderLine
''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vSupplieridC = False
    vSupplierid = 0
    vOrderdateC = False
    vOrderdate = 0
    vDeliverydateC = False
    vDeliverydate = 0
    vStatusC = False
    vStatus = ""
    vBatchnumberC = False
    vBatchnumber = 0
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Set vOrderLineClass = New ClassOrderLine
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

''*************************************************************************
'' Update Property Procedures


Public Property Get OrderLineClass() As ClassOrderLine
    OrderLineClass = vOrderLineClass
End Property

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

Public Property Get Supplierid() As Long
    Supplierid = vSupplierid
End Property

Public Property Let Supplierid(ByVal NewValue As Long)
    vSupplierid = NewValue
    vSupplieridC = True
End Property

Public Property Get Orderdate() As Date
    Orderdate = vOrderdate
End Property

Public Property Let Orderdate(ByVal NewValue As Date)
    vOrderdate = NewValue
    vOrderdateC = True
End Property

Public Property Get Deliverydate() As Date
    Deliverydate = vDeliverydate
End Property

Public Property Let Deliverydate(ByVal NewValue As Date)
    vDeliverydate = NewValue
    vDeliverydateC = True
End Property

Public Property Get Status() As String
    Status = vStatus
End Property

Public Property Let Status(ByVal NewValue As String)
    vStatus = NewValue
    vStatusC = True
End Property

Public Property Get Batchnumber() As Long
    Batchnumber = vBatchnumber
End Property

Public Property Let Batchnumber(ByVal NewValue As Long)
    vBatchnumber = NewValue
    vBatchnumberC = True
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
        Sql = "SELECT * FROM Order WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM Order WHERE "
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vSupplierid = Val(rsSearch!Supplierid & "")
        If (IsDate(rsSearch!Orderdate & "")) Then
            vOrderdate = rsSearch!Orderdate & ""
        End If
        If (IsDate(rsSearch!Deliverydate & "")) Then
            vDeliverydate = rsSearch!Deliverydate & ""
        End If
        vStatus = rsSearch!Status & ""
        vBatchnumber = Val(rsSearch!Batchnumber & "")
'' %^12
            ' Sub-class resync
            vOrderLineClass.Orderid = vUid
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
        Call Messagebox("Error (" & Trim(Erl) & ").  " & Error$ & " has occurred.", vbExclamation)
        ReadRecord = False
    End If
End Function

''*************************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim Sql As String
    Dim AddComma As Boolean
    On Error GoTo GeneralError

    AddComma = False
    Sql = "UPDATE Order SET "
'' %^13
    If (vSupplieridC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Supplierid=" & vSupplierid
    End If
    If (vOrderdateC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Orderdate=" & vOrderdate
    End If
    If (vDeliverydateC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Deliverydate=" & vDeliverydate
    End If
    If (vStatusC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Status=" & Chr(34) & vStatus & Chr(34)
    End If
    If (vBatchnumberC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Batchnumber=" & vBatchnumber
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
    Exit Function
GeneralError:
    If Err = 94 Then
        Resume Next
    Else
        Call Messagebox("Error (" & Trim(Erl) & ").  " & Error$ & " has occurred.", vbExclamation)
        WriteRecord = False
    End If
End Function

''*************************************************************************
'' Create Record

Public Function CreateRecord() As Boolean
    Dim Sql As String
    On Error GoTo GeneralError

    'Call SetDefaultValues
    Sql = "INSERT INTO Order ("
'' %^15
    Sql = Sql & "Uid"
    If (vSupplieridC = True) Then
        Sql = Sql & ",Supplierid"
    End If
    If (vOrderdateC = True) Then
        Sql = Sql & ",Orderdate"
    End If
    If (vDeliverydateC = True) Then
        Sql = Sql & ",Deliverydate"
    End If
    If (vStatusC = True) Then
        Sql = Sql & ",Status"
    End If
    If (vBatchnumberC = True) Then
        Sql = Sql & ",Batchnumber"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & vUid
    If (vSupplieridC = True) Then
        Sql = Sql & "," & vSupplierid
    End If
    If (vOrderdateC = True) Then
        Sql = Sql & "," & vOrderdate
    End If
    If (vDeliverydateC = True) Then
        Sql = Sql & "," & vDeliverydate
    End If
    If (vStatusC = True) Then
        Sql = Sql & "," & Chr(34) & vStatus & Chr(34)
    End If
    If (vBatchnumberC = True) Then
        Sql = Sql & "," & vBatchnumber
    End If
    Sql = Sql & ") "
'' %^16


    If (Execute(Sql) > 0) Then
'        Call ClearStatus
        CreateRecord = True
    Else
        'error
        CreateRecord = False
    End If
    
    Exit Function
GeneralError:
    If Err = 94 Then
        Resume Next
    Else
        Call Messagebox("Error (" & Trim(Erl) & ").  " & Error$ & " has occurred.", vbExclamation)
        CreateRecord = False
    End If
End Function

''*************************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim Sql As String

    Sql = "DELETE * FROM Order where Uid=" & vUid

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


'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vSupplierid = Val(vrsSearch!Supplierid & "")
        If (IsDate(vrsSearch!Orderdate)) Then
            vOrderdate = vrsSearch!Orderdate & ""
        End If
        If (IsDate(vrsSearch!Deliverydate)) Then
            vDeliverydate = vrsSearch!Deliverydate & ""
        End If
        vStatus = vrsSearch!Status & ""
        vBatchnumber = Val(vrsSearch!Batchnumber & "")
'' %^20

        vFoundC = True
    ' Set sub-class resync -
        vOrderLineClass.Orderid = vUid

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


