VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassJOB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - JOB
''
'' Code by Dale Pitman

Public Enum JobSearchENUM
    ByVehicleID = 1
End Enum

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vVehicleid As Long
 Private vInsurnacecompanyid As Long
 Private vEngineerid As Long
 Private vEstimatorid As Long
 Private vCourtesycarid As Long
 Private vJobsourceid As Long
 Private vStartdate As Date
 Private vCompletedate As Date
 Private vEstimatedcompletedate As Date
 Private vComment As String 'Memo type
 Private vInsurancerefernece As String
 Private vInsurancepolicynumber As String
 Private vFinalinspectiondate As Date
 Private vStatus As String
 Private vAgreedlabour As Long
 Private vExcess As Long
 Private vContribution As Long
 Private vBetterment As String
 Private vExcesspaid As String 'Logical type
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vVehicleidC As Boolean
 Private vInsurnacecompanyidC As Boolean
 Private vEngineeridC As Boolean
 Private vEstimatoridC As Boolean
 Private vCourtesycaridC As Boolean
 Private vJobsourceidC As Boolean
 Private vStartdateC As Boolean
 Private vCompletedateC As Boolean
 Private vEstimatedcompletedateC As Boolean
 Private vCommentC As Boolean
 Private vInsurancereferneceC As Boolean
 Private vInsurancepolicynumberC As Boolean
 Private vFinalinspectiondateC As Boolean
 Private vStatusC As Boolean
 Private vAgreedlabourC As Boolean
 Private vExcessC As Boolean
 Private vContributionC As Boolean
 Private vBettermentC As Boolean
 Private vExcesspaidC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vVehicle As New ClassVehicle

Private vSearchby As JobSearchENUM

Private vSuppressRecordCount As Boolean

''*************************************************************************

Public Property Get Vehicle() As ClassVehicle
    Set Vehicle = vVehicle
End Property

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vVehicleidC = False
    vVehicleid = 0
    vInsurnacecompanyidC = False
    vInsurnacecompanyid = 0
    vEngineeridC = False
    vEngineerid = 0
    vEstimatoridC = False
    vEstimatorid = 0
    vCourtesycaridC = False
    vCourtesycarid = 0
    vJobsourceidC = False
    vJobsourceid = 0
    vStartdateC = False
    vStartdate = 0
    vCompletedateC = False
    vCompletedate = 0
    vEstimatedcompletedateC = False
    vEstimatedcompletedate = 0
    vCommentC = False
    vComment = ""
    vInsurancereferneceC = False
    vInsurancerefernece = ""
    vInsurancepolicynumberC = False
    vInsurancepolicynumber = ""
    vFinalinspectiondateC = False
    vFinalinspectiondate = 0
    vStatusC = False
    vStatus = ""
    vAgreedlabourC = False
    vAgreedlabour = 0
    vExcessC = False
    vExcess = 0
    vContributionC = False
    vContribution = 0
    vBettermentC = False
    vBetterment = ""
    vExcesspaidC = False
    vExcesspaid = 0
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    ' Subclass initialisation go's here
    Call vVehicle.SetJobClass(Me)
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

Public Property Get Vehicleid() As Long
    Vehicleid = vVehicleid
End Property

Public Property Let Vehicleid(ByVal NewValue As Long)
    vVehicleid = NewValue
    vVehicleidC = True
End Property

Public Property Get Insurnacecompanyid() As Long
    Insurnacecompanyid = vInsurnacecompanyid
End Property

Public Property Let Insurnacecompanyid(ByVal NewValue As Long)
    vInsurnacecompanyid = NewValue
    vInsurnacecompanyidC = True
End Property

Public Property Get Engineerid() As Long
    Engineerid = vEngineerid
End Property

Public Property Let Engineerid(ByVal NewValue As Long)
    vEngineerid = NewValue
    vEngineeridC = True
End Property

Public Property Get Estimatorid() As Long
    Estimatorid = vEstimatorid
End Property

Public Property Let Estimatorid(ByVal NewValue As Long)
    vEstimatorid = NewValue
    vEstimatoridC = True
End Property

Public Property Get Courtesycarid() As Long
    Courtesycarid = vCourtesycarid
End Property

Public Property Let Courtesycarid(ByVal NewValue As Long)
    vCourtesycarid = NewValue
    vCourtesycaridC = True
End Property

Public Property Get Jobsourceid() As Long
    Jobsourceid = vJobsourceid
End Property

Public Property Let Jobsourceid(ByVal NewValue As Long)
    vJobsourceid = NewValue
    vJobsourceidC = True
End Property

Public Property Get Startdate() As Date
    Startdate = vStartdate
End Property

Public Property Let Startdate(ByVal NewValue As Date)
    vStartdate = NewValue
    vStartdateC = True
End Property

Public Property Get Completedate() As Date
    Completedate = vCompletedate
End Property

Public Property Let Completedate(ByVal NewValue As Date)
    vCompletedate = NewValue
    vCompletedateC = True
End Property

Public Property Get Estimatedcompletedate() As Date
    Estimatedcompletedate = vEstimatedcompletedate
End Property

Public Property Let Estimatedcompletedate(ByVal NewValue As Date)
    vEstimatedcompletedate = NewValue
    vEstimatedcompletedateC = True
End Property

Public Property Get Comment() As String
    Comment = vComment
End Property

Public Property Let Comment(ByVal NewValue As String)
    vComment = NewValue
    vCommentC = True
End Property

Public Property Get Insurancerefernece() As String
    Insurancerefernece = vInsurancerefernece
End Property

Public Property Let Insurancerefernece(ByVal NewValue As String)
    vInsurancerefernece = NewValue
    vInsurancereferneceC = True
End Property

Public Property Get Insurancepolicynumber() As String
    Insurancepolicynumber = vInsurancepolicynumber
End Property

Public Property Let Insurancepolicynumber(ByVal NewValue As String)
    vInsurancepolicynumber = NewValue
    vInsurancepolicynumberC = True
End Property

Public Property Get Finalinspectiondate() As Date
    Finalinspectiondate = vFinalinspectiondate
End Property

Public Property Let Finalinspectiondate(ByVal NewValue As Date)
    vFinalinspectiondate = NewValue
    vFinalinspectiondateC = True
End Property

Public Property Get Status() As String
    Status = vStatus
End Property

Public Property Let Status(ByVal NewValue As String)
    vStatus = NewValue
    vStatusC = True
End Property

Public Property Get Agreedlabour() As Long
    Agreedlabour = vAgreedlabour
End Property

Public Property Let Agreedlabour(ByVal NewValue As Long)
    vAgreedlabour = NewValue
    vAgreedlabourC = True
End Property

Public Property Get Excess() As Long
    Excess = vExcess
End Property

Public Property Let Excess(ByVal NewValue As Long)
    vExcess = NewValue
    vExcessC = True
End Property

Public Property Get Contribution() As Long
    Contribution = vContribution
End Property

Public Property Let Contribution(ByVal NewValue As Long)
    vContribution = NewValue
    vContributionC = True
End Property

Public Property Get Betterment() As String
    Betterment = vBetterment
End Property

Public Property Let Betterment(ByVal NewValue As String)
    vBetterment = NewValue
    vBettermentC = True
End Property

Public Property Get Excesspaid() As String
    Excesspaid = vExcesspaid
End Property

Public Property Let Excesspaid(ByVal NewValue As String)
    vExcesspaid = NewValue
    vExcesspaidC = True
End Property

'' %^10

''*************************************************************************
'' Status of record search
Public Property Get found() As Boolean
        found = vFoundC
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
        sql = "SELECT * FROM JOB WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        sql = "SELECT * FROM JOB WHERE "
    End If

    If (OpenRecordset(rsSearch, sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vVehicleid = Val(rsSearch!Vehicleid & "")
        vInsurnacecompanyid = Val(rsSearch!Insurnacecompanyid & "")
        vEngineerid = Val(rsSearch!Engineerid & "")
        vEstimatorid = Val(rsSearch!Estimatorid & "")
        vCourtesycarid = Val(rsSearch!Courtesycarid & "")
        vJobsourceid = Val(rsSearch!Jobsourceid & "")
        If (IsDate(rsSearch!Startdate)) Then
            vStartdate = rsSearch!Startdate & ""
        End If
        If (IsDate(rsSearch!Completedate)) Then
            vCompletedate = rsSearch!Completedate & ""
        End If
        If (IsDate(rsSearch!Estimatedcompletedate)) Then
            vEstimatedcompletedate = rsSearch!Estimatedcompletedate & ""
        End If
        vComment = rsSearch!Comment & ""
        vInsurancerefernece = rsSearch!Insurancerefernece & ""
        vInsurancepolicynumber = rsSearch!Insurancepolicynumber & ""
        If (IsDate(rsSearch!Finalinspectiondate)) Then
            vFinalinspectiondate = rsSearch!Finalinspectiondate & ""
        End If
        vStatus = rsSearch!Status & ""
        vAgreedlabour = Val(rsSearch!Agreedlabour & "")
        vExcess = Val(rsSearch!Excess & "")
        vContribution = Val(rsSearch!Contribution & "")
        vBetterment = rsSearch!Betterment & ""
        vExcesspaid = Val(rsSearch!Excesspaid & "")
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
    Dim sql As String
    Dim AddComma As Boolean
    On Error GoTo GeneralError

    AddComma = False
    sql = "UPDATE JOB SET "
'' %^13
    If (vVehicleidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Vehicleid=" & vVehicleid
    End If
    If (vInsurnacecompanyidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Insurnacecompanyid=" & vInsurnacecompanyid
    End If
    If (vEngineeridC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Engineerid=" & vEngineerid
    End If
    If (vEstimatoridC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Estimatorid=" & vEstimatorid
    End If
    If (vCourtesycaridC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Courtesycarid=" & vCourtesycarid
    End If
    If (vJobsourceidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Jobsourceid=" & vJobsourceid
    End If
    If (vStartdateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Startdate=" & vStartdate
    End If
    If (vCompletedateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Completedate=" & vCompletedate
    End If
    If (vEstimatedcompletedateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Estimatedcompletedate=" & vEstimatedcompletedate
    End If
    If (vCommentC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Comment=" & Chr$(34) & vComment & Chr$(34)
    End If
    If (vInsurancereferneceC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Insurancerefernece=" & Chr$(34) & vInsurancerefernece & Chr$(34)
    End If
    If (vInsurancepolicynumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Insurancepolicynumber=" & Chr$(34) & vInsurancepolicynumber & Chr$(34)
    End If
    If (vFinalinspectiondateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Finalinspectiondate=" & vFinalinspectiondate
    End If
    If (vStatusC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Status=" & Chr$(34) & vStatus & Chr$(34)
    End If
    If (vAgreedlabourC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Agreedlabour=" & vAgreedlabour
    End If
    If (vExcessC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Excess=" & vExcess
    End If
    If (vContributionC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Contribution=" & vContribution
    End If
    If (vBettermentC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Betterment=" & Chr$(34) & vBetterment & Chr$(34)
    End If
    If (vExcesspaidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Excesspaid=" & vExcesspaid
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

Public Function CreateRecord() As Boolean
    Dim sql As String
    Dim FieldData As String
    On Error GoTo GeneralError

    'Call SetDefaultValues
    sql = "INSERT INTO JOB ("
'' %^15
    sql = sql & "Uid"
    FieldData = FieldData & vUid
    If (vVehicleidC = True) Then
        sql = sql & ",Vehicleid"
        FieldData = FieldData & "," & vVehicleid
    End If
    If (vInsurnacecompanyidC = True) Then
        sql = sql & ",Insurnacecompanyid"
        FieldData = FieldData & "," & vInsurnacecompanyid
    End If
    If (vEngineeridC = True) Then
        sql = sql & ",Engineerid"
        FieldData = FieldData & "," & vEngineerid
    End If
    If (vEstimatoridC = True) Then
        sql = sql & ",Estimatorid"
        FieldData = FieldData & "," & vEstimatorid
    End If
    If (vCourtesycaridC = True) Then
        sql = sql & ",Courtesycarid"
        FieldData = FieldData & "," & vCourtesycarid
    End If
    If (vJobsourceidC = True) Then
        sql = sql & ",Jobsourceid"
        FieldData = FieldData & "," & vJobsourceid
    End If
    If (vStartdateC = True) Then
        sql = sql & ",Startdate"
        FieldData = FieldData & "," & vStartdate
    End If
    If (vCompletedateC = True) Then
        sql = sql & ",Completedate"
        FieldData = FieldData & "," & vCompletedate
    End If
    If (vEstimatedcompletedateC = True) Then
        sql = sql & ",Estimatedcompletedate"
        FieldData = FieldData & "," & vEstimatedcompletedate
    End If
    If (vCommentC = True) Then
        sql = sql & ",Comment"
        FieldData = FieldData & "," & Chr(34) & vComment & Chr(34)
    End If
    If (vInsurancereferneceC = True) Then
        sql = sql & ",Insurancerefernece"
        FieldData = FieldData & "," & Chr(34) & vInsurancerefernece & Chr(34)
    End If
    If (vInsurancepolicynumberC = True) Then
        sql = sql & ",Insurancepolicynumber"
        FieldData = FieldData & "," & Chr(34) & vInsurancepolicynumber & Chr(34)
    End If
    If (vFinalinspectiondateC = True) Then
        sql = sql & ",Finalinspectiondate"
        FieldData = FieldData & "," & vFinalinspectiondate
    End If
    If (vStatusC = True) Then
        sql = sql & ",Status"
        FieldData = FieldData & "," & Chr(34) & vStatus & Chr(34)
    End If
    If (vAgreedlabourC = True) Then
        sql = sql & ",Agreedlabour"
        FieldData = FieldData & "," & vAgreedlabour
    End If
    If (vExcessC = True) Then
        sql = sql & ",Excess"
        FieldData = FieldData & "," & vExcess
    End If
    If (vContributionC = True) Then
        sql = sql & ",Contribution"
        FieldData = FieldData & "," & vContribution
    End If
    If (vBettermentC = True) Then
        sql = sql & ",Betterment"
        FieldData = FieldData & "," & Chr(34) & vBetterment & Chr(34)
    End If
    If (vExcesspaidC = True) Then
        sql = sql & ",Excesspaid"
        FieldData = FieldData & "," & vExcesspaid
    End If
'' %^16


'    Sql = Left$(Sql, Len(Sql) - 1)
'    FieldData = Left$(FieldData, Len(FieldData) - 1)
    vUid = CreateRecordWithSQL(sql & ") VALUES " & FieldData & ")")
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
Public Function DeleteRecord() As Boolean
    Dim sql As String

    sql = "DELETE * FROM JOB where Uid=" & vUid

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
    If (vVehicleidC = False) Then
        vVehicleid = 0
    End If
    If (vInsurnacecompanyidC = False) Then
        vInsurnacecompanyid = 0
    End If
    If (vEngineeridC = False) Then
        vEngineerid = 0
    End If
    If (vEstimatoridC = False) Then
        vEstimatorid = 0
    End If
    If (vCourtesycaridC = False) Then
        vCourtesycarid = 0
    End If
    If (vJobsourceidC = False) Then
        vJobsourceid = 0
    End If
    If (vStartdateC = False) Then
        vStartdate = 0
    End If
    If (vCompletedateC = False) Then
        vCompletedate = 0
    End If
    If (vEstimatedcompletedateC = False) Then
        vEstimatedcompletedate = 0
    End If
    If (vCommentC = False) Then
        vComment = ""
    End If
    If (vInsurancereferneceC = False) Then
        vInsurancerefernece = ""
    End If
    If (vInsurancepolicynumberC = False) Then
        vInsurancepolicynumber = ""
    End If
    If (vFinalinspectiondateC = False) Then
        vFinalinspectiondate = 0
    End If
    If (vStatusC = False) Then
        vStatus = ""
    End If
    If (vAgreedlabourC = False) Then
        vAgreedlabour = 0
    End If
    If (vExcessC = False) Then
        vExcess = 0
    End If
    If (vContributionC = False) Then
        vContribution = 0
    End If
    If (vBettermentC = False) Then
        vBetterment = ""
    End If
    If (vExcesspaidC = False) Then
        vExcesspaid = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vVehicleid = Val(vrsSearch!Vehicleid & "")
        vInsurnacecompanyid = Val(vrsSearch!Insurnacecompanyid & "")
        vEngineerid = Val(vrsSearch!Engineerid & "")
        vEstimatorid = Val(vrsSearch!Estimatorid & "")
'        vCourtesycarid = Val(vrsSearch!Courtesycarid & "")
        vJobsourceid = Val(vrsSearch!Jobsourceid & "")
        If (IsDate(vrsSearch!Startdate)) Then
            vStartdate = vrsSearch!Startdate & ""
        End If
        If (IsDate(vrsSearch!Completedate)) Then
            vCompletedate = vrsSearch!Completedate & ""
        End If
        If (IsDate(vrsSearch!Estimatedcompletedate)) Then
            vEstimatedcompletedate = vrsSearch!Estimatedcompletedate & ""
        End If
        vComment = vrsSearch!Comment & ""
        vInsurancerefernece = vrsSearch!Insurancerefernece & ""
        vInsurancepolicynumber = vrsSearch!Insurancepolicynumber & ""
        If (IsDate(vrsSearch!Finalinspectiondate)) Then
            vFinalinspectiondate = vrsSearch!Finalinspectiondate & ""
        End If
'        vStatus = vrsSearch!Statusid & ""
        vAgreedlabour = Val(vrsSearch!Agreedlabour & "")
        vExcess = Val(vrsSearch!Excess & "")
        vContribution = Val(vrsSearch!Contribution & "")
        vBetterment = vrsSearch!Betterment & ""
        vExcesspaid = Val(vrsSearch!Excesspaid & "")
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


''
Public Function Search(pSearchType As JobSearchENUM) As Long
    Dim sql As String
    Dim AddAnd As Boolean
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    ' to support mutiple matches, see
'    vSearchby = pSearchType
    
    ' returns number of matches, -1 error
    sql = "SELECT * FROM Job WHERE "
    AddAnd = False
    
    If (BAnd(pSearchType, JobSearchENUM.ByVehicleID)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & " VehicleID =" & vVehicleid
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByUid)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & " c.uid=" & vUid
        AddAnd = True
    End If
    
    
    If (OpenRecordset(vrsSearch, sql, dbOpenSnapshot)) Then
        ' Read first record, get numRecords, init position
        vRecordNumber = 1
        If (vrsSearch.EOF = False) Then
            vFoundC = True
            If (vSuppressRecordCount = False) Then
                Call MoveLastFirst(vrsSearch)
                vRecordCount = vrsSearch.RecordCount
                Search = vRecordCount
            Else
                Search = 2
            End If
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


