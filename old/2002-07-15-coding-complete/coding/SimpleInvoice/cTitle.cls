VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassTitle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Title
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vTitle As String
'' %^04

 Private vTitles() As String
 Private vUids() As Long
 Private vMaxTitles As Long

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vTitleC As Boolean
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
    vTitleC = False
    vTitle = ""
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

Public Property Get Title() As String
    Title = AutoCase(vTitle, True)
End Property

Public Property Let Title(ByVal NewValue As String)
    vTitle = UCase$(NewValue)
    vTitleC = True
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
        sql = "SELECT * FROM Title WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        sql = "SELECT * FROM Title WHERE "
    End If

    If (OpenRecordset(rsSearch, sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vTitle = rsSearch!Title & ""
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
        Call ErrorCheck("Error Status (" & Trim(Erl) & ").  " & Error$ & " has occurred.", "RecordRecord, Title")
        ReadRecord = False
    End If
End Function

''*************************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim sql As String
    Dim AddComma As Boolean

    AddComma = False
    sql = "UPDATE Title SET "
'' %^13
    If (vTitleC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Title=" & cTextField & vTitle & cTextField
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

    sql = "INSERT INTO Invoice ("
    FieldData = "("
        
    
'        If (vTitleC = True) Then
            sql = sql & "Title,"
            FieldData = FieldData & "'" & vTitle & "',"
'            rstemp!Title = vTitle
'        End If

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
    If (ErrorCheck(Error$, "Title, Create Record")) Then
        Resume
    End If
End Function

''*************************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim sql As String

    sql = "DELETE * FROM Title where Uid=" & vUid

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
Private Sub SetDefaultValues()
    ' if value not written into database field then write default,
    ' used when creating new record
'' %^17
    If (vUidC = False) Then
        vUid = 0
    End If
    If (vTitleC = False) Then
        vTitle = ""
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vTitle = vrsSearch!Title & ""
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


Public Function LoadTitles() As Boolean
    Dim rstemp As Recordset
    Dim i As Long
    If (OpenRecordset(rstemp, "SELECT * FROM title", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Call rstemp.MoveLast
            Call rstemp.MoveFirst
            ReDim vUids(rstemp.RecordCount)
            ReDim vTitles(rstemp.RecordCount)
            vMaxTitles = rstemp.RecordCount
            Do While (rstemp.EOF = False)
                vUids(i) = rstemp!Uid
                vTitles(i) = Trim$(rstemp!Title & "")
                Call rstemp.MoveNext
                i = i + 1
            Loop
        End If
    End If
End Function

''
Public Function GetTitleID(pTitle As String, pAddTitle As Boolean) As Long
    Dim i As Long
    Dim rstemp As Recordset
    GetTitleID = -1
    For i = 0 To vMaxTitles - 1
        If (vTitles(i) = pTitle) Then
            GetTitleID = vUids(i)
            Exit For
        End If
    Next
    If (GetTitleID = -1 And pAddTitle = True) Then
        ' Add title
        ReDim Preserve vTitles(vMaxTitles + 1)
        ReDim Preserve vUids(vMaxTitles + 1)
        vTitles(vMaxTitles) = pTitle
        If (OpenRecordset(rstemp, "title", dbOpenDynaset)) Then
            Call rstemp.AddNew
            vUids(vMaxTitles) = rstemp!Uid
            GetTitleID = vUids(vMaxTitles)
            rstemp!Title = pTitle
            Call rstemp.Update
        Else
            ' panic
        End If
        vMaxTitles = vMaxTitles + 1
    End If
End Function

''
Public Function GetTitle(pUID As String) As String
    Dim i As Long
'    Dim rstemp As Recordset
    GetTitle = -1
    For i = 0 To vMaxTitles
        If (vUids(i) = pUID) Then
            GetTitle = vTitles(i)
            Exit For
        End If
    Next
End Function

