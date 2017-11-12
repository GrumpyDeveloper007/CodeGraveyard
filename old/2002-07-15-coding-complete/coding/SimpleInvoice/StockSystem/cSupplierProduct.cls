VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassSupplierProduct"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - SupplierProduct
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vSupplierid As Long
 Private vProductid As Long
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vSupplieridC As Boolean
 Private vProductidC As Boolean
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
    vSupplieridC = False
    vSupplierid = 0
    vProductidC = False
    vProductid = 0
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
Public Property Get Supplierid() As Long
    Supplierid = vSupplierid
End Property

Public Property Let Supplierid(ByVal NewValue As Long)
    vSupplierid = NewValue
    vSupplieridC = True
End Property

Public Property Get Productid() As Long
    Productid = vProductid
End Property

Public Property Let Productid(ByVal NewValue As Long)
    vProductid = NewValue
    vProductidC = True
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
    If (vSupplieridC = True) Then ' If key field written to then use that,
        Sql = "SELECT * FROM SupplierProduct WHERE Supplierid=" & vSupplierid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM SupplierProduct WHERE "
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vSupplierid = Val(rsSearch!Supplierid & "")
        vProductid = Val(rsSearch!Productid & "")
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
    Sql = "UPDATE SupplierProduct SET "
'' %^13
    If (vProductidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Productid=" & vProductid
    End If
'' %^14

    Sql = Sql & " WHERE Supplierid =" & vSupplierid
    
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
    Sql = "INSERT INTO SupplierProduct ("
'' %^15
    Sql = Sql & "Supplierid"
    If (vProductidC = True) Then
        Sql = Sql & ",Productid"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & vSupplierid
    If (vProductidC = True) Then
        Sql = Sql & "," & vProductid
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

    Sql = "DELETE * FROM SupplierProduct where Supplierid=" & vSupplierid

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
    If (vSupplieridC = False) Then
        vSupplierid = 0
    End If
    If (vProductidC = False) Then
        vProductid = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vSupplierid = Val(vrsSearch!Supplierid & "")
        vProductid = Val(vrsSearch!Productid & "")
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


