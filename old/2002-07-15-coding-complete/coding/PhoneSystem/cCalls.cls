VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassCalls"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Calls
''
'' Code by Dale Pitman

'' String field size definitions

'' Fields
 Private vUid As Long
 Private vCallDate As Date
 Private vExtensionid As Long
 Private vLineid As Long
 Private vPhonenumber As String
 Private vDuration As Long
 Private vPreviousid As Long

'' Track if varibles are updated, so only changed ones are
'' written on a update
 Private vUidC As Boolean
 Private vCalldateC As Boolean
 Private vExtensionidC As Boolean
 Private vLineidC As Boolean
 Private vPhonenumberC As Boolean
 Private vDurationC As Boolean
 Private vPreviousidC As Boolean

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select


'' Reset Conditions
Private Sub ClearStatus()
    vUidC = False
    vUid = 0
    vCalldateC = False
    vCallDate = 0
    vExtensionidC = False
    vExtensionid = 0
    vLineidC = False
    vLineid = 0
    vPhonenumberC = False
    vPhonenumber = ""
    vDurationC = False
    vDuration = 0
    vPreviousidC = False
    vPreviousid = 0
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

Public Property Get Uid() As Long
    Uid = vUid
End Property

Public Property Let Uid(ByVal NewValue As Long)
    vUid = NewValue
    vUidC = True
End Property

Public Property Get CallDate() As Date
    CallDate = vCallDate
End Property

Public Property Let CallDate(ByVal NewValue As Date)
    vCallDate = NewValue
    vCalldateC = True
End Property

Public Property Get Extensionid() As Long
    Extensionid = vExtensionid
End Property

Public Property Let Extensionid(ByVal NewValue As Long)
    vExtensionid = NewValue
    vExtensionidC = True
End Property

Public Property Get LineID() As Long
    LineID = vLineid
End Property

Public Property Let LineID(ByVal NewValue As Long)
    vLineid = NewValue
    vLineidC = True
End Property

Public Property Get PhoneNumber() As String
    PhoneNumber = vPhonenumber
End Property

Public Property Let PhoneNumber(ByVal NewValue As String)
    vPhonenumber = NewValue
    vPhonenumberC = True
End Property

Public Property Get Duration() As Long
    Duration = vDuration
End Property

Public Property Let Duration(ByVal NewValue As Long)
    vDuration = NewValue
    vDurationC = True
End Property

Public Property Get Previousid() As Long
    Previousid = vPreviousid
End Property

Public Property Let Previousid(ByVal NewValue As Long)
    vPreviousid = NewValue
    vPreviousidC = True
End Property


''*************************************************************
'' Status of record search
Public Property Get found() As Boolean
        found = vFoundC
End Property

'Public Property Let Found(ByVal NewValue As boolean)
'    vFound = NewValue
'End Property

'' **********************************************************************
'' Read Record
Public Function ReadRecord() As Boolean
    Dim SQl As String
    Dim rsSearch As Recordset

'    MCurrentRecord=-1
    If (vUidC = True) Then ' If key field written to then use that,
        SQl = "SELECT * FROM Calls WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        SQl = "SELECT * FROM Calls WHERE "
    End If

    If (OpenRecordset(rsSearch, SQl, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
            vFoundC = False
        Else
            vFoundC = True
        vUid = Val(rsSearch!Uid & "")
        If (IsDate(rsSearch!CallDate)) Then
            vCallDate = rsSearch!CallDate & ""
        End If
        vExtensionid = Val(rsSearch!Extensionid & "")
        vLineid = Val(rsSearch!LineID & "")
        vPhonenumber = rsSearch!PhoneNumber & ""
        vDuration = Val(rsSearch!Duration & "")
        vPreviousid = Val(rsSearch!Previousid & "")
            ' Sub-class resync
        End If
    Else
        vFoundC = False
    End If

    ' Return record found
    ReadRecord = vFoundC
End Function

'' **********************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim SQl As String

    SQl = "UPDATE Calls SET "
    SQl = SQl & "Uid = " & vUid
    If (vCalldateC = True) Then
        SQl = SQl & " ,Calldate=" & vCallDate
    End If
    If (vExtensionidC = True) Then
        SQl = SQl & " ,Extensionid=" & vExtensionid
    End If
    If (vLineidC = True) Then
        SQl = SQl & " ,Lineid=" & vLineid
    End If
    If (vPhonenumberC = True) Then
        SQl = SQl & " ,Phonenumber=" & Chr(34) & vPhonenumber & Chr(34)
    End If
    If (vDurationC = True) Then
        SQl = SQl & " ,Duration=" & vDuration
    End If
    If (vPreviousidC = True) Then
        SQl = SQl & " ,Previousid=" & vPreviousid
    End If

    SQl = SQl & " WHERE Uid =" & vUid
    
    If (Execute(SQl) > 0) Then
    ' this should return the result from updating the database
        Call ClearStatus
        WriteRecord = True
    Else
        'error
        WriteRecord = False
    End If
End Function

'' **********************************************************************
'' Create Record

Public Function CreateRecord() As Boolean
    Dim SQl As String

    'Call SetDefaultValues
    SQl = "INSERT INTO Calls ("
    SQl = SQl & "Uid"
    If (vCalldateC = True) Then
        SQl = SQl & ",Calldate"
    End If
    If (vExtensionidC = True) Then
        SQl = SQl & ",Extensionid"
    End If
    If (vLineidC = True) Then
        SQl = SQl & ",Lineid"
    End If
    If (vPhonenumberC = True) Then
        SQl = SQl & ",Phonenumber"
    End If
    If (vDurationC = True) Then
        SQl = SQl & ",Duration"
    End If
    If (vPreviousidC = True) Then
        SQl = SQl & ",Previousid"
    End If
    SQl = SQl & ") VALUES ("
    SQl = SQl & vUid
    If (vCalldateC = True) Then
        SQl = SQl & "," & vCallDate
    End If
    If (vExtensionidC = True) Then
        SQl = SQl & "," & vExtensionid
    End If
    If (vLineidC = True) Then
        SQl = SQl & "," & vLineid
    End If
    If (vPhonenumberC = True) Then
        SQl = SQl & "," & Chr(34) & vPhonenumber & Chr(34)
    End If
    If (vDurationC = True) Then
        SQl = SQl & "," & vDuration
    End If
    If (vPreviousidC = True) Then
        SQl = SQl & "," & vPreviousid
    End If
    SQl = SQl & ") "
        
    If (Execute(SQl) > 0) Then
        CreateRecord = True
    Else
        'error
        CreateRecord = False
    End If
    
End Function

Public Function CreateFromTYPE(pCallDate As Date, pExtensionID As Long, pLineID As Long, pPhoneNumber As String, pDuration As Long, pContinuedCall As Boolean, pDirection As Long, pAnswerTime As Long, pUnanseredCall As Boolean) As Long
    Dim SQl As String
    Dim rstemp As Recordset
    Dim rsCalls As Recordset
    
    If (OpenRecordset(rsCalls, "CALLS", dbOpenTable)) Then
    rsCalls.AddNew
    SQl = "INSERT INTO Calls ("
        rsCalls!CallDate = pCallDate
        rsCalls!Extensionid = pExtensionID
        rsCalls!LineID = pLineID
        rsCalls!PhoneNumber = pPhoneNumber
        rsCalls!Duration = pDuration
        rsCalls!Direction = pDirection
        rsCalls!AnswerTime = pAnswerTime
        rsCalls!UnanseredCall = pUnanseredCall
        rsCalls!Previousid = -1
        If (pContinuedCall) Then
            ' Find last call on this line
            If (OpenRecordset(rstemp, "SELECT * FROM calls WHERE LineID=" & pLineID & " ORDER BY UID DESC", dbOpenSnapshot)) Then
                If (rstemp.EOF = False) Then
                    rsCalls!Previousid = rstemp!Uid
                Else
                'na
                End If
            Else
                'na
            End If
        Else
            'na
        End If
        CreateFromTYPE = rsCalls!Uid
        
        Call rsCalls.Update
    End If
End Function



'' *********************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim SQl As String

    SQl = "DELETE * FROM Calls where Uid=" & vUid

    If (Execute(SQl) > 0) Then
    ' If no records effected then Fail
        Call ClearStatus
        DeleteRecord = True
    Else
        'error
        DeleteRecord = False
    End If
End Function

'' *********************************************************************
'' Clear local data
Public Function ClearDetails()
    ' Clear all internal data
    ' Sets object ready for new record
    Call ClearStatus
End Function



'' *********************************************************************
'' Local Functions


'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
    Call ClearStatus
        vUid = Val(vrsSearch!Uid & "")
        If (IsDate(vrsSearch!CallDate)) Then
            vCallDate = vrsSearch!CallDate & ""
        End If
        vExtensionid = Val(vrsSearch!Extensionid & "")
        vLineid = Val(vrsSearch!LineID & "")
        vPhonenumber = vrsSearch!PhoneNumber & ""
        vDuration = Val(vrsSearch!Duration & "")
        vPreviousid = Val(vrsSearch!Previousid & "")

        vFoundC = True
    ' Set sub-class resync -

    ' Move to next record
    vrsSearch.MoveNext
    vRecordNumber = vRecordNumber + 1
End Sub

'' *********************************************************************
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
Public Function newrecord()
    ' resets all data, so ready for new call (including children)
End Function

''
Public Function CloseSearch()
    Call vrsSearch.Close
End Function


