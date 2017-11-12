VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassOrderLine"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - OrderLine
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vProductid As Long
 Private vOrderid As Long
 Private vQty As Long
 Private vQtyreceived As Long
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vProductidC As Boolean
 Private vOrderidC As Boolean
 Private vQtyC As Boolean
 Private vQtyreceivedC As Boolean
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
    vProductidC = False
    vProductid = 0
    vOrderidC = False
    vOrderid = 0
    vQtyC = False
    vQty = 0
    vQtyreceivedC = False
    vQtyreceived = 0
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

Public Property Get Productid() As Long
    Productid = vProductid
End Property

Public Property Let Productid(ByVal NewValue As Long)
    vProductid = NewValue
    vProductidC = True
End Property

Public Property Get Orderid() As Long
    Orderid = vOrderid
End Property

Public Property Let Orderid(ByVal NewValue As Long)
    vOrderid = NewValue
    vOrderidC = True
End Property

Public Property Get Qty() As Long
    Qty = vQty
End Property

Public Property Let Qty(ByVal NewValue As Long)
    vQty = NewValue
    vQtyC = True
End Property

Public Property Get Qtyreceived() As Long
    Qtyreceived = vQtyreceived
End Property

Public Property Let Qtyreceived(ByVal NewValue As Long)
    vQtyreceived = NewValue
    vQtyreceivedC = True
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
        Sql = "SELECT * FROM OrderLine WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM OrderLine WHERE "
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vProductid = Val(rsSearch!Productid & "")
        vOrderid = Val(rsSearch!Orderid & "")
        vQty = Val(rsSearch!Qty & "")
        vQtyreceived = Val(rsSearch!Qtyreceived & "")
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
    Sql = "UPDATE OrderLine SET "
'' %^13
    If (vProductidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Productid=" & vProductid
    End If
    If (vOrderidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Orderid=" & vOrderid
    End If
    If (vQtyC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Qty=" & vQty
    End If
    If (vQtyreceivedC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Qtyreceived=" & vQtyreceived
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
    Sql = "INSERT INTO OrderLine ("
'' %^15
    Sql = Sql & "Uid"
    If (vProductidC = True) Then
        Sql = Sql & ",Productid"
    End If
    If (vOrderidC = True) Then
        Sql = Sql & ",Orderid"
    End If
    If (vQtyC = True) Then
        Sql = Sql & ",Qty"
    End If
    If (vQtyreceivedC = True) Then
        Sql = Sql & ",Qtyreceived"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & vUid
    If (vProductidC = True) Then
        Sql = Sql & "," & vProductid
    End If
    If (vOrderidC = True) Then
        Sql = Sql & "," & vOrderid
    End If
    If (vQtyC = True) Then
        Sql = Sql & "," & vQty
    End If
    If (vQtyreceivedC = True) Then
        Sql = Sql & "," & vQtyreceived
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

    Sql = "DELETE * FROM OrderLine where Uid=" & vUid

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
Private Sub SetDefaultValues()
    ' if value not written into database field then write default,
    ' used when creating new record
'' %^17
    If (vUidC = False) Then
        vUid = 0
    End If
    If (vProductidC = False) Then
        vProductid = 0
    End If
    If (vOrderidC = False) Then
        vOrderid = 0
    End If
    If (vQtyC = False) Then
        vQty = 0
    End If
    If (vQtyreceivedC = False) Then
        vQtyreceived = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vProductid = Val(vrsSearch!Productid & "")
        vOrderid = Val(vrsSearch!Orderid & "")
        vQty = Val(vrsSearch!Qty & "")
        vQtyreceived = Val(vrsSearch!Qtyreceived & "")
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
    Exit Function
End Function


''
Public Function NewRecord()
    ' resets all data, so ready for new call (including children)
    Call ClearStatus
End Function


