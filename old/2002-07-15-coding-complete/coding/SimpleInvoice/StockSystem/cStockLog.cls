VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassStockLog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - StockLog
''
'' Code by Dale Pitman

Public Enum StockLocationTypeENUM
    Order = 1
    Location = 2
    NA = 3
End Enum

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vSourceid As Long
 Private vSourcetypeid As StockLocationTypeENUM
 Private vDestinationid As Long
 Private vDestinationtypeid As StockLocationTypeENUM
 Private vContextid As Long
 Private vUserid As Long
 Private vQty As Long
 Private vTransferdate As Date
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vSourceidC As Boolean
 Private vSourcetypeidC As Boolean
 Private vDestinationidC As Boolean
 Private vDestinationtypeidC As Boolean
 Private vContextidC As Boolean
 Private vUseridC As Boolean
 Private vQtyC As Boolean
 Private vTransferdateC As Boolean
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
    vSourceidC = False
    vSourceid = 0
    vSourcetypeidC = False
    vSourcetypeid = 0
    vDestinationidC = False
    vDestinationid = 0
    vDestinationtypeidC = False
    vDestinationtypeid = 0
    vContextidC = False
    vContextid = 0
    vUseridC = False
    vUserid = 0
    vQtyC = False
    vQty = 0
    vTransferdateC = False
    vTransferdate = 0
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

Public Property Get Sourceid() As Long
    Sourceid = vSourceid
End Property

Public Property Let Sourceid(ByVal NewValue As Long)
    vSourceid = NewValue
    vSourceidC = True
End Property

Public Property Get Sourcetypeid() As StockLocationTypeENUM
    Sourcetypeid = vSourcetypeid
End Property

Public Property Let Sourcetypeid(ByVal NewValue As StockLocationTypeENUM)
    vSourcetypeid = NewValue
    vSourcetypeidC = True
End Property

Public Property Get Destinationid() As Long
    Destinationid = vDestinationid
End Property

Public Property Let Destinationid(ByVal NewValue As Long)
    vDestinationid = NewValue
    vDestinationidC = True
End Property

Public Property Get Destinationtypeid() As StockLocationTypeENUM
    Destinationtypeid = vDestinationtypeid
End Property

Public Property Let Destinationtypeid(ByVal NewValue As StockLocationTypeENUM)
    vDestinationtypeid = NewValue
    vDestinationtypeidC = True
End Property

Public Property Get Contextid() As Long
    Contextid = vContextid
End Property

Public Property Let Contextid(ByVal NewValue As Long)
    vContextid = NewValue
    vContextidC = True
End Property

Public Property Get Userid() As Long
    Userid = vUserid
End Property

Public Property Let Userid(ByVal NewValue As Long)
    vUserid = NewValue
    vUseridC = True
End Property

Public Property Get Qty() As Long
    Qty = vQty
End Property

Public Property Let Qty(ByVal NewValue As Long)
    vQty = NewValue
    vQtyC = True
End Property

Public Property Get Transferdate() As Date
    Transferdate = vTransferdate
End Property

Public Property Let Transferdate(ByVal NewValue As Date)
    vTransferdate = NewValue
    vTransferdateC = True
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
        Sql = "SELECT * FROM StockLog WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM StockLog WHERE "
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vSourceid = Val(rsSearch!Sourceid & "")
        vSourcetypeid = Val(rsSearch!Sourcetypeid & "")
        vDestinationid = Val(rsSearch!Destinationid & "")
        vDestinationtypeid = Val(rsSearch!Destinationtypeid & "")
        vContextid = Val(rsSearch!Contextid & "")
        vUserid = Val(rsSearch!Userid & "")
        vQty = Val(rsSearch!Qty & "")
        If (IsDate(rsSearch!Transferdate)) Then
            vTransferdate = rsSearch!Transferdate & ""
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
    Sql = "UPDATE StockLog SET "
'' %^13
    If (vSourceidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Sourceid=" & vSourceid
    End If
    If (vSourcetypeidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Sourcetypeid=" & vSourcetypeid
    End If
    If (vDestinationidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Destinationid=" & vDestinationid
    End If
    If (vDestinationtypeidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Destinationtypeid=" & vDestinationtypeid
    End If
    If (vContextidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Contextid=" & vContextid
    End If
    If (vUseridC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Userid=" & vUserid
    End If
    If (vQtyC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Qty=" & vQty
    End If
    If (vTransferdateC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Transferdate=" & vTransferdate
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
    Sql = "INSERT INTO StockLog ("
'' %^15
    Sql = Sql & "Uid"
    If (vSourceidC = True) Then
        Sql = Sql & ",Sourceid"
    End If
    If (vSourcetypeidC = True) Then
        Sql = Sql & ",Sourcetypeid"
    End If
    If (vDestinationidC = True) Then
        Sql = Sql & ",Destinationid"
    End If
    If (vDestinationtypeidC = True) Then
        Sql = Sql & ",Destinationtypeid"
    End If
    If (vContextidC = True) Then
        Sql = Sql & ",Contextid"
    End If
    If (vUseridC = True) Then
        Sql = Sql & ",Userid"
    End If
    If (vQtyC = True) Then
        Sql = Sql & ",Qty"
    End If
    If (vTransferdateC = True) Then
        Sql = Sql & ",Transferdate"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & vUid
    If (vSourceidC = True) Then
        Sql = Sql & "," & vSourceid
    End If
    If (vSourcetypeidC = True) Then
        Sql = Sql & "," & vSourcetypeid
    End If
    If (vDestinationidC = True) Then
        Sql = Sql & "," & vDestinationid
    End If
    If (vDestinationtypeidC = True) Then
        Sql = Sql & "," & vDestinationtypeid
    End If
    If (vContextidC = True) Then
        Sql = Sql & "," & vContextid
    End If
    If (vUseridC = True) Then
        Sql = Sql & "," & vUserid
    End If
    If (vQtyC = True) Then
        Sql = Sql & "," & vQty
    End If
    If (vTransferdateC = True) Then
        Sql = Sql & "," & vTransferdate
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

    Sql = "DELETE * FROM StockLog where Uid=" & vUid

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
    If (vSourceidC = False) Then
        vSourceid = 0
    End If
    If (vSourcetypeidC = False) Then
        vSourcetypeid = 0
    End If
    If (vDestinationidC = False) Then
        vDestinationid = 0
    End If
    If (vDestinationtypeidC = False) Then
        vDestinationtypeid = 0
    End If
    If (vContextidC = False) Then
        vContextid = 0
    End If
    If (vUseridC = False) Then
        vUserid = 0
    End If
    If (vQtyC = False) Then
        vQty = 0
    End If
    If (vTransferdateC = False) Then
        vTransferdate = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vSourceid = Val(vrsSearch!Sourceid & "")
        vSourcetypeid = Val(vrsSearch!Sourcetypeid & "")
        vDestinationid = Val(vrsSearch!Destinationid & "")
        vDestinationtypeid = Val(vrsSearch!Destinationtypeid & "")
        vContextid = Val(vrsSearch!Contextid & "")
        vUserid = Val(vrsSearch!Userid & "")
        vQty = Val(vrsSearch!Qty & "")
        If (IsDate(vrsSearch!Transferdate)) Then
            vTransferdate = vrsSearch!Transferdate & ""
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
    Exit Function
End Function


''
Public Function NewRecord()
    ' resets all data, so ready for new call (including children)
    Call ClearStatus
End Function


