VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Location"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Location
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vLocationgroupid As Long
 Private vName As String
 Private vAdditonaltext As String 'Memo type
 Private vSubpriority As Long
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vLocationgroupidC As Boolean
 Private vNameC As Boolean
 Private vAdditonaltextC As Boolean
 Private vSubpriorityC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset		' Multi-record selection storage
Private vRecordNumber As Long		' Currently selected record in multiselect
Private vRecordCount As Long		' Number of records found in a multi-record select

Private vSearchby As Long
Private vSuppressRecordCount As Boolean

''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vLocationgroupidC = False
    vLocationgroupid = 0
    vNameC = False
    vName = ""
    vAdditonaltextC = False
    vAdditonaltext = ""
    vSubpriorityC = False
    vSubpriority = 0
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

''*************************************************************************
Public Property Get SuppressRecordCount() As Boolean
    SuppressRecordCount = vSuppressRecordCount
End Property

Public Property Let SuppressRecordCount(ByVal NewValue As Boolean)
    vSuppressRecordCount = NewValue
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

Public Property Get Locationgroupid() As Long
    Locationgroupid = vLocationgroupid
End Property

Public Property Let Locationgroupid(ByVal NewValue As Long)
    vLocationgroupid = NewValue
    vLocationgroupidC = True
End Property

Public Property Get Name() As String
    Name = vName
End Property

Public Property Let Name(ByVal NewValue As String)
    vName = NewValue
    vNameC = True
End Property

Public Property Get Additonaltext() As String
    Additonaltext = vAdditonaltext
End Property

Public Property Let Additonaltext(ByVal NewValue As String)
    vAdditonaltext = NewValue
    vAdditonaltextC = True
End Property

Public Property Get Subpriority() As Long
    Subpriority = vSubpriority
End Property

Public Property Let Subpriority(ByVal NewValue As Long)
    vSubpriority = NewValue
    vSubpriorityC = True
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
    If (vUidC=true) then   ' If key field written to then use that,
        sql = "SELECT * FROM Location WHERE Uid=" & vUid 
    Else  ' otherwise use specified fields
        sql = "SELECT * FROM Location WHERE "
    End If

    If (OpenRecordset(rsSearch,sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vLocationgroupid = Val(rsSearch!Locationgroupid & "")
        vName = rsSearch!Name & ""
        vAdditonaltext = rsSearch!Additonaltext & ""
        vSubpriority = Val(rsSearch!Subpriority & "")
'' %^12
            ' Sub-class resync
        End If
    Else
	VfoundC = False
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
    Dim sql As String
    Dim AddComma As Boolean
    On Error GoTo GeneralError

    AddComma = False
    sql = "UPDATE Location SET "
'' %^13
    If (vLocationgroupidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Locationgroupid=" & vLocationgroupid 
    End If
    If (vNameC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Name=" & chr$(34) & vName & chr$(34)
    End If
    If (vAdditonaltextC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Additonaltext=" & chr$(34) & vAdditonaltext & chr$(34)
    End If
    If (vSubpriorityC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Subpriority=" & vSubpriority 
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

Public Function CreateRecord() as Boolean
    Dim sql As String
    Dim FieldData as String 
    On Error GoTo GeneralError

    'Call SetDefaultValues
    sql = "INSERT INTO Location ("
'' %^15
    sql = sql & "Uid"
    FieldData = FieldData &  vUid
    If (vLocationgroupidC= True) Then
        sql = sql & ",Locationgroupid"
        FieldData = FieldData & "," & vLocationgroupid
    End if
    If (vNameC= True) Then
        sql = sql & ",Name"
        FieldData = FieldData & "," & Chr(34) & vName & Chr(34) 
    End if
    If (vAdditonaltextC= True) Then
        sql = sql & ",Additonaltext"
        FieldData = FieldData & "," & Chr(34) & vAdditonaltext & Chr(34) 
    End if
    If (vSubpriorityC= True) Then
        sql = sql & ",Subpriority"
        FieldData = FieldData & "," & vSubpriority
    End if
'' %^16


'    Sql = Left$(Sql, Len(Sql) - 1)
'    FieldData = Left$(FieldData, Len(FieldData) - 1)
    vUid = CreateRecordWithSQL(Sql & ") VALUES " & FieldData & ")")
    If (vUid > 0) Then
        CreateRecord = True
        vFoundC = True

    Else
        CreateRecord = False
        vFoundC = False
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
Public Function DeleteRecord() as Boolean
    Dim Sql As String

    sql = "DELETE * FROM Location where Uid=" & vUid

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
    If (vLocationgroupidC = False) Then
	vLocationgroupid = 0
    End If
    If (vNameC = False) Then
	vName = ""
    End If
    If (vAdditonaltextC = False) Then
	vAdditonaltext = ""
    End If
    If (vSubpriorityC = False) Then
	vSubpriority = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vLocationgroupid = Val(vrsSearch!Locationgroupid & "")
        vName = vrsSearch!Name & ""
        vAdditonaltext = vrsSearch!Additonaltext & ""
        vSubpriority = Val(vrsSearch!Subpriority & "")
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
Public Function NextRecord(Optional pRecordNumber As Long=-100) As Boolean
    ' sets properties to next record in search operation
    ' or sets to a specified record (pRecordNumber)
    
    ' returns false for fail(eof)
    If (pRecordNumber=-100) Then
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


