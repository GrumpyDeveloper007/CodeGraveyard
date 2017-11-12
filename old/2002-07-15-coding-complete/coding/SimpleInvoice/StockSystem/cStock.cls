VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassStock"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Stock
''
'' Code by Dale Pitman


Public Enum StockSearchENUM
    byProduct = 1
End Enum
'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vProductid As Long
 Private vLocationid As Long
 Private vQty As Long
'' %^04
 Private vMinstocklevel As Long
 Private vMinorderqty As Long

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vProductidC As Boolean
 Private vLocationidC As Boolean
 Private vQtyC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vLocationClass As ClassLocation
'Private vStockMinClass As ClassStockMin

''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vProductidC = False
    vProductid = 0
    vLocationidC = False
    vLocationid = 0
    vMinstocklevel = 0
    vMinorderqty = 0
    vQtyC = False
    vQty = 0
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Set vLocationClass = New ClassLocation
'    Set vStockMinClass = New ClassStockMin
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

''*************************************************************************
'' Update Property Procedures

'Public Property Get StockMin() As ClassStockMin
'    StockMin = vStockMinClass
'End Property

Public Property Get Location() As ClassLocation
    Location = vLocationClass
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

Public Property Get Productid() As Long
    Productid = vProductid
End Property

Public Property Let Productid(ByVal NewValue As Long)
    vProductid = NewValue
    vProductidC = True
End Property

Public Property Get Locationid() As Long
    Locationid = vLocationid
End Property

Public Property Let Locationid(ByVal NewValue As Long)
    vLocationid = NewValue
    vLocationidC = True
End Property

Public Property Get Qty() As Long
    Qty = vQty
End Property

Public Property Let Qty(ByVal NewValue As Long)
    vQty = NewValue
    vQtyC = True
End Property

'' %^10
Public Property Get Minstocklevel() As Long
    Minstocklevel = vMinstocklevel
End Property

Public Property Get Minorderqty() As Long
    Minorderqty = vMinorderqty
End Property

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
        Sql = "SELECT s.*,m.Minorderqty,m.Minstocklevel FROM Stock s LEFT OUTER JOIN StockMin m ON s.uid=m.stockid WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM Stock WHERE "
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
        vLocationid = Val(rsSearch!Locationid & "")
        vQty = Val(rsSearch!Qty & "")
'' %^12
        vMinstocklevel = Val(rsSearch!Minstocklevel & "")
        vMinorderqty = Val(rsSearch!Minorderqty & "")
            ' Sub-class resync
            vLocationClass.Uid = vLocationid
'            vStockMinClass.Stockid = vUid
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
    Sql = "UPDATE Stock SET "
'' %^13
    If (vProductidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Productid=" & vProductid
    End If
    If (vLocationidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Locationid=" & vLocationid
    End If
    If (vQtyC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Qty=" & vQty
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
    Sql = "INSERT INTO Stock ("
'' %^15
    Sql = Sql & "Uid"
    If (vProductidC = True) Then
        Sql = Sql & ",Productid"
    End If
    If (vLocationidC = True) Then
        Sql = Sql & ",Locationid"
    End If
    If (vQtyC = True) Then
        Sql = Sql & ",Qty"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & "," & Chr(34) & vUid & Chr(34)
    If (vProductidC = True) Then
        Sql = Sql & "," & vProductid
    End If
    If (vLocationidC = True) Then
        Sql = Sql & "," & vLocationid
    End If
    If (vQtyC = True) Then
        Sql = Sql & "," & vQty
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

    Sql = "DELETE * FROM Stock where Uid=" & vUid

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
        vProductid = Val(vrsSearch!Productid & "")
        vLocationid = Val(vrsSearch!Locationid & "")
        vQty = Val(vrsSearch!Qty & "")
'' %^20
        vMinstocklevel = Val(vrsSearch!Minstocklevel & "")
        vMinorderqty = Val(vrsSearch!Minorderqty & "")

        vFoundC = True
    ' Set sub-class resync -
            vLocationClass.Uid = vLocationid
'            vStockMinClass.Stockid = vUid

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


Public Function Search(pSearchType As StockSearchENUM) As Long
    Dim Sql As String
    Dim AddAnd As Boolean
    
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    AddAnd = False
    Sql = "SELECT s.*,m.Minorderqty,m.Minstocklevel FROM Stock s LEFT OUTER JOIN StockMin m ON s.uid=m.stockid WHERE "
    If (BAnd(pSearchType, StockSearchENUM.byProduct)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " s.Productid=" & vProductid
        AddAnd = True
    End If

'    If (BAnd(pSearchType, n)) Then
'        sql = sql & " ORDER BY c.UID"
'    Else
'        sql = sql & " " & vOrderBy
'    End If
    
    If (OpenRecordset(vrsSearch, Sql, dbOpenSnapshot)) Then
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
            Search = 0
            vFoundC = False
        End If
    Else
        Search = 0
        vFoundC = False
    End If
End Function


''
Public Function CloseSearch() As Boolean
    Call vrsSearch.Close
    CloseSearch = True
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


