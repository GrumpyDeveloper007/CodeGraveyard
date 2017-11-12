VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassLocationGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - LocationGroup
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vGroupid As Long
 Private vPriority As Long
 Private vName As String
 Private vDescription As String
 Private vParentgroup As Long
 Private vTransferparent As String 'Logical type
 Private vTransfergroup As String 'Logical type
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vGroupidC As Boolean
 Private vPriorityC As Boolean
 Private vNameC As Boolean
 Private vDescriptionC As Boolean
 Private vParentgroupC As Boolean
 Private vTransferparentC As Boolean
 Private vTransfergroupC As Boolean
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
    vGroupidC = False
    vGroupid = 0
    vPriorityC = False
    vPriority = 0
    vNameC = False
    vName = ""
    vDescriptionC = False
    vDescription = ""
    vParentgroupC = False
    vParentgroup = 0
    vTransferparentC = False
    vTransferparent = 0
    vTransfergroupC = False
    vTransfergroup = 0
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

Public Property Get Groupid() As Long
    Groupid = vGroupid
End Property

Public Property Let Groupid(ByVal NewValue As Long)
    vGroupid = NewValue
    vGroupidC = True
End Property

Public Property Get Priority() As Long
    Priority = vPriority
End Property

Public Property Let Priority(ByVal NewValue As Long)
    vPriority = NewValue
    vPriorityC = True
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

Public Property Get Parentgroup() As Long
    Parentgroup = vParentgroup
End Property

Public Property Let Parentgroup(ByVal NewValue As Long)
    vParentgroup = NewValue
    vParentgroupC = True
End Property

Public Property Get Transferparent() As String
    Transferparent = vTransferparent
End Property

Public Property Let Transferparent(ByVal NewValue As String)
    vTransferparent = NewValue
    vTransferparentC = True
End Property

Public Property Get Transfergroup() As String
    Transfergroup = vTransfergroup
End Property

Public Property Let Transfergroup(ByVal NewValue As String)
    vTransfergroup = NewValue
    vTransfergroupC = True
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
        Sql = "SELECT * FROM LocationGroup WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM LocationGroup WHERE "
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vGroupid = Val(rsSearch!Groupid & "")
        vPriority = Val(rsSearch!Priority & "")
        vName = rsSearch!Name & ""
        vDescription = rsSearch!Description & ""
        vParentgroup = Val(rsSearch!Parentgroup & "")
        vTransferparent = Val(rsSearch!Transferparent & "")
        vTransfergroup = Val(rsSearch!Transfergroup & "")
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
    Sql = "UPDATE LocationGroup SET "
'' %^13
    If (vGroupidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Groupid=" & vGroupid
    End If
    If (vPriorityC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Priority=" & vPriority
    End If
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
    If (vParentgroupC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Parentgroup=" & vParentgroup
    End If
    If (vTransferparentC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Transferparent=" & vTransferparent
    End If
    If (vTransfergroupC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Transfergroup=" & vTransfergroup
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
    Sql = "INSERT INTO LocationGroup ("
'' %^15
    Sql = Sql & "Uid"
    If (vGroupidC = True) Then
        Sql = Sql & ",Groupid"
    End If
    If (vPriorityC = True) Then
        Sql = Sql & ",Priority"
    End If
    If (vNameC = True) Then
        Sql = Sql & ",Name"
    End If
    If (vDescriptionC = True) Then
        Sql = Sql & ",Description"
    End If
    If (vParentgroupC = True) Then
        Sql = Sql & ",Parentgroup"
    End If
    If (vTransferparentC = True) Then
        Sql = Sql & ",Transferparent"
    End If
    If (vTransfergroupC = True) Then
        Sql = Sql & ",Transfergroup"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & vUid
    If (vGroupidC = True) Then
        Sql = Sql & "," & vGroupid
    End If
    If (vPriorityC = True) Then
        Sql = Sql & "," & vPriority
    End If
    If (vNameC = True) Then
        Sql = Sql & "," & Chr(34) & vName & Chr(34)
    End If
    If (vDescriptionC = True) Then
        Sql = Sql & "," & Chr(34) & vDescription & Chr(34)
    End If
    If (vParentgroupC = True) Then
        Sql = Sql & "," & vParentgroup
    End If
    If (vTransferparentC = True) Then
        Sql = Sql & "," & vTransferparent
    End If
    If (vTransfergroupC = True) Then
        Sql = Sql & "," & vTransfergroup
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

    Sql = "DELETE * FROM LocationGroup where Uid=" & vUid

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
    If (vGroupidC = False) Then
        vGroupid = 0
    End If
    If (vPriorityC = False) Then
        vPriority = 0
    End If
    If (vNameC = False) Then
        vName = ""
    End If
    If (vDescriptionC = False) Then
        vDescription = ""
    End If
    If (vParentgroupC = False) Then
        vParentgroup = 0
    End If
    If (vTransferparentC = False) Then
        vTransferparent = 0
    End If
    If (vTransfergroupC = False) Then
        vTransfergroup = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vGroupid = Val(vrsSearch!Groupid & "")
        vPriority = Val(vrsSearch!Priority & "")
        vName = vrsSearch!Name & ""
        vDescription = vrsSearch!Description & ""
        vParentgroup = Val(vrsSearch!Parentgroup & "")
        vTransferparent = Val(vrsSearch!Transferparent & "")
        vTransfergroup = Val(vrsSearch!Transfergroup & "")
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


