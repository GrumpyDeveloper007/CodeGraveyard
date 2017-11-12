VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassManufacturer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Manufacturer
''
'' Code by Dale Pitman

Public Enum ManufacturerSearchENUM
    byALL = 1
End Enum

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vName As String
 Private vDescription As String
 Private vCode As String
 Private vStreet1 As String
 Private vStreet2 As String
 Private vTown As String
 Private vCounty As String
 Private vCountry As String
 Private vPostcode As String
 Private vPhonenumber As String
 Private vInactive As String 'Logical type
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vNameC As Boolean
 Private vDescriptionC As Boolean
 Private vCodeC As Boolean
 Private vStreet1C As Boolean
 Private vStreet2C As Boolean
 Private vTownC As Boolean
 Private vCountyC As Boolean
 Private vCountryC As Boolean
 Private vPostcodeC As Boolean
 Private vPhonenumberC As Boolean
 Private vInactiveC As Boolean
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
    vNameC = False
    vName = ""
    vDescriptionC = False
    vDescription = ""
    vCodeC = False
    vCode = ""
    vStreet1C = False
    vStreet1 = ""
    vStreet2C = False
    vStreet2 = ""
    vTownC = False
    vTown = ""
    vCountyC = False
    vCounty = ""
    vCountryC = False
    vCountry = ""
    vPostcodeC = False
    vPostcode = ""
    vPhonenumberC = False
    vPhonenumber = ""
    vInactiveC = False
    vInactive = 0
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

Public Property Get Name() As String
    Name = vName
End Property

Public Property Let Name(ByVal NewValue As String)
    vName = NewValue
    vNameC = True
End Property

Public Property Get Description() As String
    Description = vDescription
End Property

Public Property Let Description(ByVal NewValue As String)
    vDescription = NewValue
    vDescriptionC = True
End Property

Public Property Get Code() As String
    Code = vCode
End Property

Public Property Let Code(ByVal NewValue As String)
    vCode = NewValue
    vCodeC = True
End Property

Public Property Get Street1() As String
    Street1 = vStreet1
End Property

Public Property Let Street1(ByVal NewValue As String)
    vStreet1 = NewValue
    vStreet1C = True
End Property

Public Property Get Street2() As String
    Street2 = vStreet2
End Property

Public Property Let Street2(ByVal NewValue As String)
    vStreet2 = NewValue
    vStreet2C = True
End Property

Public Property Get Town() As String
    Town = vTown
End Property

Public Property Let Town(ByVal NewValue As String)
    vTown = NewValue
    vTownC = True
End Property

Public Property Get County() As String
    County = vCounty
End Property

Public Property Let County(ByVal NewValue As String)
    vCounty = NewValue
    vCountyC = True
End Property

Public Property Get Country() As String
    Country = vCountry
End Property

Public Property Let Country(ByVal NewValue As String)
    vCountry = NewValue
    vCountryC = True
End Property

Public Property Get Postcode() As String
    Postcode = vPostcode
End Property

Public Property Let Postcode(ByVal NewValue As String)
    vPostcode = NewValue
    vPostcodeC = True
End Property

Public Property Get Phonenumber() As String
    Phonenumber = vPhonenumber
End Property

Public Property Let Phonenumber(ByVal NewValue As String)
    vPhonenumber = NewValue
    vPhonenumberC = True
End Property

Public Property Get Inactive() As String
    Inactive = vInactive
End Property

Public Property Let Inactive(ByVal NewValue As String)
    vInactive = NewValue
    vInactiveC = True
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
        Sql = "SELECT * FROM Manufacturer WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM Manufacturer WHERE "
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vName = rsSearch!Name & ""
        vDescription = rsSearch!Description & ""
        vCode = rsSearch!Code & ""
        vStreet1 = rsSearch!Street1 & ""
        vStreet2 = rsSearch!Street2 & ""
        vTown = rsSearch!Town & ""
        vCounty = rsSearch!County & ""
        vCountry = rsSearch!Country & ""
        vPostcode = rsSearch!Postcode & ""
        vPhonenumber = rsSearch!Phonenumber & ""
        vInactive = Val(rsSearch!Inactive & "")
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
    Sql = "UPDATE Manufacturer SET "
'' %^13
    If (vNameC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Name=" & Chr$(34) & vName & Chr$(34)
    End If
    If (vDescriptionC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Description=" & Chr$(34) & vDescription & Chr$(34)
    End If
    If (vCodeC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Code=" & Chr$(34) & vCode & Chr$(34)
    End If
    If (vStreet1C = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Street1=" & Chr$(34) & vStreet1 & Chr$(34)
    End If
    If (vStreet2C = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Street2=" & Chr$(34) & vStreet2 & Chr$(34)
    End If
    If (vTownC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Town=" & Chr$(34) & vTown & Chr$(34)
    End If
    If (vCountyC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " County=" & Chr$(34) & vCounty & Chr$(34)
    End If
    If (vCountryC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Country=" & Chr$(34) & vCountry & Chr$(34)
    End If
    If (vPostcodeC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Postcode=" & Chr$(34) & vPostcode & Chr$(34)
    End If
    If (vPhonenumberC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Phonenumber=" & Chr$(34) & vPhonenumber & Chr$(34)
    End If
    If (vInactiveC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Inactive=" & vInactive
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
    Sql = "INSERT INTO Manufacturer ("
'' %^15
    Sql = Sql & "Uid"
    If (vNameC = True) Then
        Sql = Sql & ",Name"
    End If
    If (vDescriptionC = True) Then
        Sql = Sql & ",Description"
    End If
    If (vCodeC = True) Then
        Sql = Sql & ",Code"
    End If
    If (vStreet1C = True) Then
        Sql = Sql & ",Street1"
    End If
    If (vStreet2C = True) Then
        Sql = Sql & ",Street2"
    End If
    If (vTownC = True) Then
        Sql = Sql & ",Town"
    End If
    If (vCountyC = True) Then
        Sql = Sql & ",County"
    End If
    If (vCountryC = True) Then
        Sql = Sql & ",Country"
    End If
    If (vPostcodeC = True) Then
        Sql = Sql & ",Postcode"
    End If
    If (vPhonenumberC = True) Then
        Sql = Sql & ",Phonenumber"
    End If
    If (vInactiveC = True) Then
        Sql = Sql & ",Inactive"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & vUid
    If (vNameC = True) Then
        Sql = Sql & "," & Chr(34) & vName & Chr(34)
    End If
    If (vDescriptionC = True) Then
        Sql = Sql & "," & Chr(34) & vDescription & Chr(34)
    End If
    If (vCodeC = True) Then
        Sql = Sql & "," & Chr(34) & vCode & Chr(34)
    End If
    If (vStreet1C = True) Then
        Sql = Sql & "," & Chr(34) & vStreet1 & Chr(34)
    End If
    If (vStreet2C = True) Then
        Sql = Sql & "," & Chr(34) & vStreet2 & Chr(34)
    End If
    If (vTownC = True) Then
        Sql = Sql & "," & Chr(34) & vTown & Chr(34)
    End If
    If (vCountyC = True) Then
        Sql = Sql & "," & Chr(34) & vCounty & Chr(34)
    End If
    If (vCountryC = True) Then
        Sql = Sql & "," & Chr(34) & vCountry & Chr(34)
    End If
    If (vPostcodeC = True) Then
        Sql = Sql & "," & Chr(34) & vPostcode & Chr(34)
    End If
    If (vPhonenumberC = True) Then
        Sql = Sql & "," & Chr(34) & vPhonenumber & Chr(34)
    End If
    If (vInactiveC = True) Then
        Sql = Sql & "," & vInactive
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

    Sql = "DELETE * FROM Manufacturer where Uid=" & vUid

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
    If (vNameC = False) Then
        vName = ""
    End If
    If (vDescriptionC = False) Then
        vDescription = ""
    End If
    If (vCodeC = False) Then
        vCode = ""
    End If
    If (vStreet1C = False) Then
        vStreet1 = ""
    End If
    If (vStreet2C = False) Then
        vStreet2 = ""
    End If
    If (vTownC = False) Then
        vTown = ""
    End If
    If (vCountyC = False) Then
        vCounty = ""
    End If
    If (vCountryC = False) Then
        vCountry = ""
    End If
    If (vPostcodeC = False) Then
        vPostcode = ""
    End If
    If (vPhonenumberC = False) Then
        vPhonenumber = ""
    End If
    If (vInactiveC = False) Then
        vInactive = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vName = vrsSearch!Name & ""
        vDescription = vrsSearch!Description & ""
        vCode = vrsSearch!Code & ""
        vStreet1 = vrsSearch!Street1 & ""
        vStreet2 = vrsSearch!Street2 & ""
        vTown = vrsSearch!Town & ""
        vCounty = vrsSearch!County & ""
        vCountry = vrsSearch!Country & ""
        vPostcode = vrsSearch!Postcode & ""
        vPhonenumber = vrsSearch!Phonenumber & ""
        vInactive = Val(vrsSearch!Inactive & "")
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



Public Function Search(pSearchType As ManufacturerSearchENUM) As Long
    Dim Sql As String
    Dim AddAnd As Boolean
    
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    AddAnd = False
    Sql = "SELECT * FROM Manufacturer WHERE "
    If (BAnd(pSearchType, ManufacturerSearchENUM.byALL)) Then
        Sql = "SELECT * FROM Manufacturer "
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




