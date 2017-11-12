VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassAllocate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Allocate
''
'' Code by Dale Pitman

'' String field size definitions
'' %^01
'' %^02
''
Private Type DeleteRecordTYPE
    AllocateID As Long
End Type

Private vDelete() As Boolean
Private vNewRecord() As Boolean
Private vToDelete(20) As DeleteRecordTYPE
Private vMaxToDelete As Long
'' Fields
'' %^03
 Private vJobid As Long
 
 Private vPartCode() As ClassPartCode
 
 Private vUid() As Long
 Private vPartCodeID() As Long
 Private vAllocatestatusid() As Long
 Private vQty() As Long
 Private vHour() As Single
 Private vAdditionalcomment() As String
 Private vOperation() As Long
 Private vRefittime() As Long
 Private vRepairtime() As Long
 Private vPainttime() As Long
 Private vPaneltime() As Long
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vPartcodeidC As Boolean
 Private vJobidC As Boolean
 Private vAllocatestatusidC As Boolean
 Private vQtyC As Boolean
 Private vHourC As Boolean
 Private vAdditionalcommentC As Boolean
 Private vOperationC As Boolean
 Private vRefittimeC As Boolean
 Private vRepairtimeC As Boolean
 Private vPainttimeC As Boolean
 Private vPaneltimeC As Boolean
'' %^06
Private vIndex As Long
Private vMaxIndex As Long

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vSearchby As Long
Private vSuppressRecordCount As Boolean

''*************************************************************************

Private Sub RedimPreserve(pSize As Long)
    ReDim Preserve vPartCode(pSize) As ClassPartCode
    ReDim Preserve vDelete(pSize) As Boolean
    ReDim Preserve vUid(pSize) As Long
    ReDim Preserve vPartCodeID(pSize) As Long
    ReDim Preserve vAllocatestatusid(pSize) As Long
    ReDim Preserve vQty(pSize) As Long
    ReDim Preserve vHour(pSize) As Single
    ReDim Preserve vAdditionalcomment(pSize) As String
    ReDim Preserve vOperation(pSize) As Long
    ReDim Preserve vRefittime(pSize) As Long
    ReDim Preserve vRepairtime(pSize) As Long
    ReDim Preserve vPainttime(pSize) As Long
    ReDim Preserve vPaneltime(pSize) As Long
    ReDim Preserve vNewRecord(pSize) As Boolean
End Sub

Private Sub ClearRecord(pIndex As Long)
    vUid(pIndex) = 0
    vPartCodeID(pIndex) = 0
    vAllocatestatusid(pIndex) = 0
    vQty(pIndex) = 0
    vHour(pIndex) = 0
    vAdditionalcomment(pIndex) = ""
    vOperation(pIndex) = 0
    vRefittime(pIndex) = 0
    vRepairtime(pIndex) = 0
    vPainttime(pIndex) = 0
    vPaneltime(pIndex) = 0
    vNewRecord(pIndex) = False
End Sub

Private Sub ClearPartDetails()
    Dim i As Long
    
    ReDim vPartCode(20) As ClassPartCode
    ReDim vDelete(20) As Boolean
    ReDim vUid(20) As Long
    ReDim vPartCodeID(20) As Long
    ReDim vAllocatestatusid(20) As Long
    ReDim vQty(20) As Long
    ReDim vHour(20) As Single
    ReDim vAdditionalcomment(20) As String
    ReDim vOperation(20) As Long
    ReDim vRefittime(20) As Long
    ReDim vRepairtime(20) As Long
    ReDim vPainttime(20) As Long
    ReDim vPaneltime(20) As Long
    ReDim vNewRecord(20) As Boolean
    
    vUidC = False
    vPartcodeidC = False
    
    vAllocatestatusidC = False
    vQtyC = False
    vHourC = False
    vAdditionalcommentC = False
    vOperationC = False
    vRefittimeC = False
    vRepairtimeC = False
    vPainttimeC = False
    vPaneltimeC = False
    
    For i = 0 To 20
        Call ClearRecord(i)
    Next

End Sub

'' Reset Conditions
Private Sub ClearStatus()
    Dim i As Long
'' %^07
    vJobidC = False
    vJobid = 0
    
    Call ClearPartDetails
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

Public Property Get MaxIndex() As Long
    MaxIndex = vMaxIndex
End Property

Public Property Get Index() As Long
    Index = vIndex
End Property

Public Property Let Index(pValue As Long)
    vIndex = pValue
End Property

Public Function SetIndexByUID(pUID As Long) As Boolean
    Dim i As Long
    SetIndexByUID = False
    For i = 0 To vMaxIndex
        If (vUid(i) = pUID) Then
            vIndex = i
            SetIndexByUID = True
            Exit For
        End If
    Next
End Function



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


Public Property Get PartCode() As ClassPartCode
    Set PartCode = vPartCode(vIndex)
End Property

'Public Property Let PartCode(ByVal NewValue As ClassPartCode)
'    Set vPartCode(vIndex) = NewValue
'End Property

'' %^09
Public Property Get Uid() As Long
    Uid = vUid(vIndex)
End Property

Public Property Let Uid(ByVal NewValue As Long)
    vUid(vIndex) = NewValue
    vUidC = True
End Property

Public Property Get Partcodeid() As Long
    Partcodeid = vPartCodeID(vIndex)
End Property

Public Property Let Partcodeid(ByVal NewValue As Long)
    vPartCodeID(vIndex) = NewValue
    vPartcodeidC = True
End Property

Public Property Get Jobid() As Long
    Jobid = vJobid
End Property

Public Property Let Jobid(ByVal NewValue As Long)
    vJobid = NewValue
    vJobidC = True
End Property

Public Property Get Allocatestatusid() As Long
    Allocatestatusid = vAllocatestatusid(vIndex)
End Property

Public Property Let Allocatestatusid(ByVal NewValue As Long)
    vAllocatestatusid(vIndex) = NewValue
    vAllocatestatusidC = True
End Property

Public Property Get Qty() As Long
    Qty = vQty(vIndex)
End Property

Public Property Let Qty(ByVal NewValue As Long)
    vQty(vIndex) = NewValue
    vQtyC = True
End Property

Public Property Get Hour() As Single
    Hour = vHour(vIndex)
End Property

Public Property Let Hour(ByVal NewValue As Single)
    vHour(vIndex) = NewValue
    vHourC = True
End Property

Public Property Get Additionalcomment() As String
    Additionalcomment = vAdditionalcomment(vIndex)
End Property

Public Property Let Additionalcomment(ByVal NewValue As String)
    vAdditionalcomment(vIndex) = NewValue
    vAdditionalcommentC = True
End Property

Public Property Get Operation() As Long
    Operation = vOperation(vIndex)
End Property

Public Property Let Operation(ByVal NewValue As Long)
    vOperation(vIndex) = NewValue
    vOperationC = True
End Property

Public Property Get Refittime() As Long
    Refittime = vRefittime(vIndex)
End Property

Public Property Let Refittime(ByVal NewValue As Long)
    vRefittime(vIndex) = NewValue
    vRefittimeC = True
End Property

Public Property Get Repairtime() As Long
    Repairtime = vRepairtime(vIndex)
End Property

Public Property Let Repairtime(ByVal NewValue As Long)
    vRepairtime(vIndex) = NewValue
    vRepairtimeC = True
End Property

Public Property Get Painttime() As Long
    Painttime = vPainttime(vIndex)
End Property

Public Property Let Painttime(ByVal NewValue As Long)
    vPainttime(vIndex) = NewValue
    vPainttimeC = True
End Property

Public Property Get Paneltime() As Long
    Paneltime = vPaneltime(vIndex)
End Property

Public Property Let Paneltime(ByVal NewValue As Long)
    vPaneltime(vIndex) = NewValue
    vPaneltimeC = True
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
''*************************************************************************
'' Update Record
Private Function l_WriteRecord(pIndex As Long) As Boolean
    Dim sql As String
    Dim AddComma As Boolean
    On Error GoTo GeneralError

    AddComma = False
    sql = "UPDATE [allocate] SET "
'' %^13
    If (vPartcodeidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Partcodeid=" & vPartCodeID(pIndex)
    End If
    If (vJobidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Jobid=" & vJobid
    End If
    If (vAllocatestatusidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Allocatestatusid=" & vAllocatestatusid(pIndex)
    End If
    If (vQtyC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Qty=" & vQty(pIndex)
    End If
    If (vHourC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Hour=" & vHour(pIndex)
    End If
    If (vAdditionalcommentC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Additionalcomment=" & Chr$(34) & vAdditionalcomment(pIndex) & Chr$(34)
    End If
    If (vOperationC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Operation=" & vOperation(pIndex)
    End If
    If (vRefittimeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Refittime=" & vRefittime(pIndex)
    End If
    If (vRepairtimeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Repairtime=" & vRepairtime(pIndex)
    End If
    If (vPainttimeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Painttime=" & vPainttime(pIndex)
    End If
    If (vPaneltimeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Paneltime=" & vPaneltime(pIndex)
    End If
'' %^14

    sql = sql & " WHERE Uid =" & vUid(pIndex)
    
    If (Execute(sql, True) > 0) Then
    ' this should return the result from updating the database
'        Call ClearStatus
        l_WriteRecord = True
    Else
        'error
        l_WriteRecord = False
    End If
    Exit Function
GeneralError:
    If Err = 94 Then
        Resume Next
    Else
        Call Messagebox("Error (" & Trim(Erl) & ").  " & Error$ & " has occurred.", vbExclamation)
        l_WriteRecord = False
    End If
End Function

''*************************************************************************
'' Create Record

Public Function l_CreateRecord(pIndex As Long) As Boolean
    Dim sql As String
    Dim FieldData As String
    On Error GoTo GeneralError

    'Call SetDefaultValues
    sql = "INSERT INTO [allocate] ("
'' %^15
'    sql = sql & "Uid"
'    FieldData = FieldData & vUid(pIndex)
'    If (vPartcodeidC = True) Then
        sql = sql & "Partcodeid"
        FieldData = FieldData & vPartCodeID(pIndex)
'    End If
    If (vJobidC = True) Then
        sql = sql & ",Jobid"
        FieldData = FieldData & "," & vJobid
    End If
    If (vAllocatestatusidC = True) Then
        sql = sql & ",Allocatestatusid"
        FieldData = FieldData & "," & vAllocatestatusid(pIndex)
    End If
    If (vQtyC = True) Then
        sql = sql & ",Qty"
        FieldData = FieldData & "," & vQty(pIndex)
    End If
    If (vHourC = True) Then
        sql = sql & ",Hour"
        FieldData = FieldData & "," & vHour(pIndex)
    End If
    If (vAdditionalcommentC = True) Then
        sql = sql & ",Additionalcomment"
        FieldData = FieldData & "," & Chr(34) & vAdditionalcomment(pIndex) & Chr(34)
    End If
    If (vOperationC = True) Then
        sql = sql & ",Operation"
        FieldData = FieldData & "," & vOperation(pIndex)
    End If
    If (vRefittimeC = True) Then
        sql = sql & ",Refittime"
        FieldData = FieldData & "," & vRefittime(pIndex)
    End If
    If (vRepairtimeC = True) Then
        sql = sql & ",Repairtime"
        FieldData = FieldData & "," & vRepairtime(pIndex)
    End If
    If (vPainttimeC = True) Then
        sql = sql & ",Painttime"
        FieldData = FieldData & "," & vPainttime(pIndex)
    End If
    If (vPaneltimeC = True) Then
        sql = sql & ",Paneltime"
        FieldData = FieldData & "," & vPaneltime(pIndex)
    End If
'' %^16


'    Sql = Left$(Sql, Len(Sql) - 1)
'    FieldData = Left$(FieldData, Len(FieldData) - 1)
    vUid(pIndex) = CreateRecordWithSQL(sql & ") VALUES (" & FieldData & ")")
    If (vUid(pIndex) > 0) Then
        l_CreateRecord = True
        vFoundC = True
    Else
        l_CreateRecord = False
        vFoundC = False
    End If

    
    Exit Function
GeneralError:
    If Err = 94 Then
        Resume Next
    Else
        Call Messagebox("Error (" & Trim(Erl) & ").  " & Error$ & " has occurred.", vbExclamation)
        l_CreateRecord = False
    End If
End Function

''*************************************************************************
'' Delete Record

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
Private Sub LoadFromSearch(pIndex As Long)
'    Call ClearStatus
'' %^19
        vUid(pIndex) = Val(vrsSearch!Uid & "")
        vPartCodeID(pIndex) = Val(vrsSearch!Partcodeid & "")
        vJobid = Val(vrsSearch!Jobid & "")
        vAllocatestatusid(pIndex) = Val(vrsSearch!Allocatestatusid & "")
        vQty(pIndex) = Val(vrsSearch!Qty & "")
        vHour(pIndex) = Val(vrsSearch!Hour & "")
        vAdditionalcomment(pIndex) = vrsSearch!Additionalcomment & ""
        vOperation(pIndex) = Val(vrsSearch!Operation & "")
        vRefittime(pIndex) = Val(vrsSearch!Refittime & "")
        vRepairtime(pIndex) = Val(vrsSearch!Repairtime & "")
        vPainttime(pIndex) = Val(vrsSearch!Painttime & "")
        vPaneltime(pIndex) = Val(vrsSearch!Paneltime & "")
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
        Call LoadFromSearch(0)
        NextRecord = True
    End If
    Exit Function
End Function


''
Public Function NewRecord()
    ' resets all data, so ready for new call (including children)
    Call ClearStatus
End Function



'' Adds new part, returns new index and sets internal index to new pointer
Public Function AddRecord(Optional pIndex As Long = -1) As Long
    If (pIndex = -1) Then
        vMaxIndex = vMaxIndex + 1
        
        vNewRecord(vMaxIndex - 1) = True
        
        vUid(vMaxIndex - 1) = 0
        Set vPartCode(vMaxIndex - 1) = New ClassPartCode
        vDelete(vMaxIndex - 1) = False
        AddRecord = vMaxIndex - 1
        vIndex = vMaxIndex - 1
    Else
        vNewRecord(pIndex) = True
        vUid(pIndex) = 0
        vDelete(pIndex) = False
        AddRecord = pIndex
        vIndex = pIndex
    End If
End Function

Public Function DeleteRecord(Optional pIndex As Long = -1) As Boolean
    Dim i As Long
    If (pIndex = -1) Then
        pIndex = vIndex
    End If
    vToDelete(vMaxToDelete).AllocateID = vUid(pIndex)
    vMaxToDelete = vMaxToDelete + 1
    
    Call ClearRecord(pIndex)
    
    vDelete(pIndex) = True
    DeleteRecord = True
End Function

Public Function WriteRecord() As Boolean
    Dim sql As String
    Dim i As Long
    Dim DirectDelivery As Boolean
    Dim WriteRecordFlag As Boolean

    WriteRecordFlag = True
    DirectDelivery = False
    For i = 0 To vMaxIndex
        If (vDelete(i) = False) Then
        
            If (vNewRecord(i) = False) Then
                ' Update old record
                WriteRecordFlag = l_WriteRecord(i)
            Else
                ' Create new record
                WriteRecordFlag = l_CreateRecord(i)
                vNewRecord(i) = False
            End If
        Else
        End If
    Next
    
    For i = 0 To vMaxToDelete - 1
        ' Record deleted
        If (vToDelete(i).AllocateID > 0) Then
            sql = "DELETE * FROM Allocate WHERE Uid=" & vToDelete(i).AllocateID

            If (Execute(sql, True) = 0) Then
                'error
                WriteRecordFlag = False
            Else
                ' Process any actions that need to be done when a part code is removed
            
            End If
            vToDelete(i).AllocateID = 0
        End If
    Next
    
    WriteRecord = WriteRecordFlag
    If (WriteRecordFlag = True) Then
'        Call ClearDetails
    End If
End Function

Public Function ReadRecord() As Boolean
    Dim sql As String
    Dim rsSearch As Recordset
    Dim i As Long

    On Error GoTo GeneralError
    
'    MCurrentRecord=-1
    If (vJobidC = True) Then ' If key field written to then use that,
        sql = "SELECT a.* FROM [allocate] a WHERE Jobid=" & vJobid
    Else  ' otherwise use specified fields
        sql = "SELECT a.* FROM [allocate] a WHERE uid=" & vUid(vIndex)
    End If

    Call ClearPartDetails
    If (OpenRecordset(rsSearch, sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
            vFoundC = False
        Else
            vFoundC = True
            vJobid = Val(rsSearch!Jobid & "")
            rsSearch.MoveLast
            rsSearch.MoveFirst
            vMaxIndex = rsSearch.RecordCount
            
            i = 0
            
            Do While (rsSearch.EOF = False)
                If (i > 20) Then
                
                End If
                
                
                vUid(i) = Val(rsSearch!Uid & "")
                
                vPartCodeID(i) = Val(rsSearch!Partcodeid & "")
'                vJobid(i) = Val(rsSearch!Jobid & "")
                vAllocatestatusid(i) = Val(rsSearch!Allocatestatusid & "")
                vQty(i) = Val(rsSearch!Qty & "")
                vHour(i) = Val(rsSearch!Hour & "")
                vAdditionalcomment(i) = rsSearch!Additionalcomment & ""
                vOperation(i) = Val(rsSearch!Operation & "")
                vRefittime(i) = Val(rsSearch!Refittime & "")
                vRepairtime(i) = Val(rsSearch!Repairtime & "")
                vPainttime(i) = Val(rsSearch!Painttime & "")
                vPaneltime(i) = Val(rsSearch!Paneltime & "")
                
                ' sub-class
                Set vPartCode(i) = New ClassPartCode
                vPartCode(i).Uid = vPartCodeID(i)
                Call vPartCode(i).ReadRecord
                
                vNewRecord(i) = False
                vDelete(i) = False
                rsSearch.MoveNext
                i = i + 1
            Loop
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




Public Property Get NumberOfParts() As Long
    Dim i As Long
    NumberOfParts = 0
    For i = 0 To vMaxIndex
        If (vDelete(i) = False) Then
            NumberOfParts = NumberOfParts + 1
        End If
    Next
End Property

Public Property Get Deleted() As Boolean
    Deleted = vDelete(vIndex)
End Property

''
Public Property Get IsNewParts() As Boolean
    Dim i As Long
    IsNewParts = False
    For i = 0 To 20
        If (vDelete(i) = False And vNewRecord(i) = True) Then
            IsNewParts = True
            Exit For
        End If
    Next
End Property

