VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassVehicle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Vehicle
''
'' Code by Dale Pitman


Public Enum VehicleSearchENUM
    ByCustomerID = 1
End Enum

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vReg As String
 Private vColourid As Long
 Private vVehicleconditiontypeid As Long
 Private vCustomerid As Long
 Private vModelID As Long
 Private vLastinspectiondate As Date
 Private vYear As Long
 Private vVin As String
 Private vEnginenumber As String
 Private vLampnumber As String
 Private vRadiocode As String
 Private vColourcode As String
 Private vDriveable As String 'Logical type
 Private vOptions As String 'Memo type
 Private vTrimcode As String
 Private vPaintsystem As String
 Private vRegistereddate As Date
 Private vMotdate As Date
'' %^04
 Private vMake As String
 Private vModel As String
 Private vColour As String
 

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vRegC As Boolean
 Private vColouridC As Boolean
 Private vVehicleconditiontypeidC As Boolean
 Private vCustomeridC As Boolean
 Private vModelidC As Boolean
 Private vLastinspectiondateC As Boolean
 Private vYearC As Boolean
 Private vVinC As Boolean
 Private vEnginenumberC As Boolean
 Private vLampnumberC As Boolean
 Private vRadiocodeC As Boolean
 Private vColourcodeC As Boolean
 Private vDriveableC As Boolean
 Private vOptionsC As Boolean
 Private vTrimcodeC As Boolean
 Private vPaintsystemC As Boolean
 Private vRegistereddateC As Boolean
 Private vMotdateC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

Private vSearchby As VehicleSearchENUM

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vSuppressRecordCount As Boolean

Private vCustomer As ClassCustomer

Private vjob As ClassJOB
''*************************************************************************

Public Sub SetJobClass(pJob As ClassJOB)
    Set vjob = pJob
End Sub

Public Property Set Customer(pCustomer As ClassCustomer)
    Set vCustomer = pCustomer
End Property

Public Property Get Customer() As ClassCustomer
    Set Customer = vCustomer
End Property

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vRegC = False
    vReg = ""
    vColouridC = False
    vColourid = 0
    vVehicleconditiontypeidC = False
    vVehicleconditiontypeid = 0
    vCustomeridC = False
    vCustomerid = 0
    vModelidC = False
    vModelID = 0
    vLastinspectiondateC = False
    vLastinspectiondate = 0
    vYearC = False
    vYear = 0
    vVinC = False
    vVin = ""
    vEnginenumberC = False
    vEnginenumber = ""
    vLampnumberC = False
    vLampnumber = ""
    vRadiocodeC = False
    vRadiocode = ""
    vColourcodeC = False
    vColourcode = ""
    vDriveableC = False
    vDriveable = 0
    vOptionsC = False
    vOptions = ""
    vTrimcodeC = False
    vTrimcode = ""
    vPaintsystemC = False
    vPaintsystem = ""
    vRegistereddateC = False
    vRegistereddate = 0
    vMotdateC = False
    vMotdate = 0
'' %^08
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    ' Subclass initialisation go's here
    Set vCustomer = New ClassCustomer
    Call vCustomer.SetVehicle(Me)
End Sub

'''''''''''''''''''''''''''''''''''''

Public Property Get Make() As String
    Make = vMake
End Property
Public Property Get Model() As String
    Model = vModel
End Property
Public Property Get Colour() As String
    Colour = vColour
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

Public Property Get Reg() As String
    Reg = vReg
End Property

Public Property Let Reg(ByVal NewValue As String)
    vReg = NewValue
    vRegC = True
End Property

Public Property Get Colourid() As Long
    Colourid = vColourid
End Property

Public Property Let Colourid(ByVal NewValue As Long)
    vColourid = NewValue
    vColouridC = True
End Property

Public Property Get Vehicleconditiontypeid() As Long
    Vehicleconditiontypeid = vVehicleconditiontypeid
End Property

Public Property Let Vehicleconditiontypeid(ByVal NewValue As Long)
    vVehicleconditiontypeid = NewValue
    vVehicleconditiontypeidC = True
End Property

Public Property Get Customerid() As Long
    Customerid = vCustomerid
End Property

Public Property Let Customerid(ByVal NewValue As Long)
    vCustomerid = NewValue
    vCustomeridC = True
End Property

Public Property Get Modelid() As Long
    Modelid = vModelID
End Property

Public Property Let Modelid(ByVal NewValue As Long)
    vModelID = NewValue
    vModelidC = True
End Property

Public Property Get Lastinspectiondate() As Date
    Lastinspectiondate = vLastinspectiondate
End Property

Public Property Let Lastinspectiondate(ByVal NewValue As Date)
    vLastinspectiondate = NewValue
    vLastinspectiondateC = True
End Property

Public Property Get Year() As Long
    Year = vYear
End Property

Public Property Let Year(ByVal NewValue As Long)
    vYear = NewValue
    vYearC = True
End Property

Public Property Get Vin() As String
    Vin = vVin
End Property

Public Property Let Vin(ByVal NewValue As String)
    vVin = NewValue
    vVinC = True
End Property

Public Property Get Enginenumber() As String
    Enginenumber = vEnginenumber
End Property

Public Property Let Enginenumber(ByVal NewValue As String)
    vEnginenumber = NewValue
    vEnginenumberC = True
End Property

Public Property Get Lampnumber() As String
    Lampnumber = vLampnumber
End Property

Public Property Let Lampnumber(ByVal NewValue As String)
    vLampnumber = NewValue
    vLampnumberC = True
End Property

Public Property Get Radiocode() As String
    Radiocode = vRadiocode
End Property

Public Property Let Radiocode(ByVal NewValue As String)
    vRadiocode = NewValue
    vRadiocodeC = True
End Property

Public Property Get Colourcode() As String
    Colourcode = vColourcode
End Property

Public Property Let Colourcode(ByVal NewValue As String)
    vColourcode = NewValue
    vColourcodeC = True
End Property

Public Property Get Driveable() As String
    Driveable = vDriveable
End Property

Public Property Let Driveable(ByVal NewValue As String)
    vDriveable = NewValue
    vDriveableC = True
End Property

Public Property Get Options() As String
    Options = vOptions
End Property

Public Property Let Options(ByVal NewValue As String)
    vOptions = NewValue
    vOptionsC = True
End Property

Public Property Get Trimcode() As String
    Trimcode = vTrimcode
End Property

Public Property Let Trimcode(ByVal NewValue As String)
    vTrimcode = NewValue
    vTrimcodeC = True
End Property

Public Property Get Paintsystem() As String
    Paintsystem = vPaintsystem
End Property

Public Property Let Paintsystem(ByVal NewValue As String)
    vPaintsystem = NewValue
    vPaintsystemC = True
End Property

Public Property Get Registereddate() As Date
    Registereddate = vRegistereddate
End Property

Public Property Let Registereddate(ByVal NewValue As Date)
    vRegistereddate = NewValue
    vRegistereddateC = True
End Property

Public Property Get Motdate() As Date
    Motdate = vMotdate
End Property

Public Property Let Motdate(ByVal NewValue As Date)
    vMotdate = NewValue
    vMotdateC = True
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
        sql = "SELECT v.*,c.Name AS COLOUR,mo.Name AS MODEL,ma.Name AS Make FROM ((Vehicle v LEFT OUTER JOIN Colour c ON v.colourID=c.uid) LEFT OUTER JOIN Model mo ON v.ModelID=mo.UID) LEFT OUTER JOIN Make ma ON mo.MakeID=ma.uid  WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        sql = "SELECT v.*,c.Name AS COLOUR,mo.Name AS MODEL,ma.Name AS Make FROM ((Vehicle v LEFT OUTER JOIN Colour c ON v.colourID=c.uid) LEFT OUTER JOIN Model mo ON v.ModelID=mo.UID) LEFT OUTER JOIN Make ma ON mo.MakeID=ma.uid  WHERE "
    End If

    If (OpenRecordset(rsSearch, sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vReg = rsSearch!Reg & ""
        vColourid = Val(rsSearch!Colourid & "")
        vVehicleconditiontypeid = Val(rsSearch!Vehicleconditiontypeid & "")
        vCustomerid = Val(rsSearch!Customerid & "")
        vModelID = Val(rsSearch!Modelid & "")
        If (IsDate(rsSearch!Lastinspectiondate)) Then
            vLastinspectiondate = rsSearch!Lastinspectiondate & ""
        End If
        vYear = Val(rsSearch!Year & "")
        vVin = rsSearch!Vin & ""
        vEnginenumber = rsSearch!Enginenumber & ""
        vLampnumber = rsSearch!Lampnumber & ""
        vRadiocode = rsSearch!Radiocode & ""
        vColourcode = rsSearch!Colourcode & ""
        vDriveable = Val(rsSearch!Driveable & "")
        vOptions = rsSearch!Options & ""
        vTrimcode = rsSearch!Trimcode & ""
        vPaintsystem = rsSearch!Paintsystem & ""
        If (IsDate(rsSearch!Registereddate)) Then
            vRegistereddate = rsSearch!Registereddate & ""
        End If
        If (IsDate(rsSearch!Motdate)) Then
            vMotdate = rsSearch!Motdate & ""
        End If
'' %^12
        vColour = rsSearch!Colour & ""
        vModel = rsSearch!Model & ""
        vMake = rsSearch!Make & ""
            ' Sub-class resync
            
            vjob.Vehicleid = vUid
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
    sql = "UPDATE Vehicle SET "
'' %^13
    If (vRegC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Reg=" & Chr$(34) & vReg & Chr$(34)
    End If
    If (vColouridC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Colourid=" & vColourid
    End If
    If (vVehicleconditiontypeidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Vehicleconditiontypeid=" & vVehicleconditiontypeid
    End If
    If (vCustomeridC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Customerid=" & vCustomerid
    End If
    If (vModelidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Modelid=" & vModelID
    End If
    If (vLastinspectiondateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Lastinspectiondate=" & vLastinspectiondate
    End If
    If (vYearC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Year=" & vYear
    End If
    If (vVinC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Vin=" & Chr$(34) & vVin & Chr$(34)
    End If
    If (vEnginenumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Enginenumber=" & Chr$(34) & vEnginenumber & Chr$(34)
    End If
    If (vLampnumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Lampnumber=" & Chr$(34) & vLampnumber & Chr$(34)
    End If
    If (vRadiocodeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Radiocode=" & Chr$(34) & vRadiocode & Chr$(34)
    End If
    If (vColourcodeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Colourcode=" & Chr$(34) & vColourcode & Chr$(34)
    End If
    If (vDriveableC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Driveable=" & vDriveable
    End If
    If (vOptionsC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Options=" & Chr$(34) & vOptions & Chr$(34)
    End If
    If (vTrimcodeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Trimcode=" & Chr$(34) & vTrimcode & Chr$(34)
    End If
    If (vPaintsystemC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Paintsystem=" & Chr$(34) & vPaintsystem & Chr$(34)
    End If
    If (vRegistereddateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Registereddate=" & vRegistereddate
    End If
    If (vMotdateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Motdate=" & vMotdate
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
    sql = "INSERT INTO Vehicle ("
'' %^15
    sql = sql & "Uid"
    FieldData = FieldData & vUid
    If (vRegC = True) Then
        sql = sql & ",Reg"
        FieldData = FieldData & "," & Chr(34) & vReg & Chr(34)
    End If
    If (vColouridC = True) Then
        sql = sql & ",Colourid"
        FieldData = FieldData & "," & vColourid
    End If
    If (vVehicleconditiontypeidC = True) Then
        sql = sql & ",Vehicleconditiontypeid"
        FieldData = FieldData & "," & vVehicleconditiontypeid
    End If
    If (vCustomeridC = True) Then
        sql = sql & ",Customerid"
        FieldData = FieldData & "," & vCustomerid
    End If
    If (vModelidC = True) Then
        sql = sql & ",Modelid"
        FieldData = FieldData & "," & vModelID
    End If
    If (vLastinspectiondateC = True) Then
        sql = sql & ",Lastinspectiondate"
        FieldData = FieldData & "," & vLastinspectiondate
    End If
    If (vYearC = True) Then
        sql = sql & ",Year"
        FieldData = FieldData & "," & vYear
    End If
    If (vVinC = True) Then
        sql = sql & ",Vin"
        FieldData = FieldData & "," & Chr(34) & vVin & Chr(34)
    End If
    If (vEnginenumberC = True) Then
        sql = sql & ",Enginenumber"
        FieldData = FieldData & "," & Chr(34) & vEnginenumber & Chr(34)
    End If
    If (vLampnumberC = True) Then
        sql = sql & ",Lampnumber"
        FieldData = FieldData & "," & Chr(34) & vLampnumber & Chr(34)
    End If
    If (vRadiocodeC = True) Then
        sql = sql & ",Radiocode"
        FieldData = FieldData & "," & Chr(34) & vRadiocode & Chr(34)
    End If
    If (vColourcodeC = True) Then
        sql = sql & ",Colourcode"
        FieldData = FieldData & "," & Chr(34) & vColourcode & Chr(34)
    End If
    If (vDriveableC = True) Then
        sql = sql & ",Driveable"
        FieldData = FieldData & "," & vDriveable
    End If
    If (vOptionsC = True) Then
        sql = sql & ",Options"
        FieldData = FieldData & "," & Chr(34) & vOptions & Chr(34)
    End If
    If (vTrimcodeC = True) Then
        sql = sql & ",Trimcode"
        FieldData = FieldData & "," & Chr(34) & vTrimcode & Chr(34)
    End If
    If (vPaintsystemC = True) Then
        sql = sql & ",Paintsystem"
        FieldData = FieldData & "," & Chr(34) & vPaintsystem & Chr(34)
    End If
    If (vRegistereddateC = True) Then
        sql = sql & ",Registereddate"
        FieldData = FieldData & "," & vRegistereddate
    End If
    If (vMotdateC = True) Then
        sql = sql & ",Motdate"
        FieldData = FieldData & "," & vMotdate
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

    sql = "DELETE * FROM Vehicle where Uid=" & vUid

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
    If (vRegC = False) Then
        vReg = ""
    End If
    If (vColouridC = False) Then
        vColourid = 0
    End If
    If (vVehicleconditiontypeidC = False) Then
        vVehicleconditiontypeid = 0
    End If
    If (vCustomeridC = False) Then
        vCustomerid = 0
    End If
    If (vModelidC = False) Then
        vModelID = 0
    End If
    If (vLastinspectiondateC = False) Then
        vLastinspectiondate = 0
    End If
    If (vYearC = False) Then
        vYear = 0
    End If
    If (vVinC = False) Then
        vVin = ""
    End If
    If (vEnginenumberC = False) Then
        vEnginenumber = ""
    End If
    If (vLampnumberC = False) Then
        vLampnumber = ""
    End If
    If (vRadiocodeC = False) Then
        vRadiocode = ""
    End If
    If (vColourcodeC = False) Then
        vColourcode = ""
    End If
    If (vDriveableC = False) Then
        vDriveable = 0
    End If
    If (vOptionsC = False) Then
        vOptions = ""
    End If
    If (vTrimcodeC = False) Then
        vTrimcode = ""
    End If
    If (vPaintsystemC = False) Then
        vPaintsystem = ""
    End If
    If (vRegistereddateC = False) Then
        vRegistereddate = 0
    End If
    If (vMotdateC = False) Then
        vMotdate = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vReg = vrsSearch!Reg & ""
        vColourid = Val(vrsSearch!Colourid & "")
        vVehicleconditiontypeid = Val(vrsSearch!Vehicleconditiontypeid & "")
        vCustomerid = Val(vrsSearch!Customerid & "")
        vModelID = Val(vrsSearch!Modelid & "")
        If (IsDate(vrsSearch!Lastinspectiondate)) Then
            vLastinspectiondate = vrsSearch!Lastinspectiondate & ""
        End If
        vYear = Val(vrsSearch!Year & "")
        vVin = vrsSearch!Vin & ""
'        vEnginenumber = vrsSearch!Enginenumber & ""
        vLampnumber = vrsSearch!Lampnumber & ""
        vRadiocode = vrsSearch!Radiocode & ""
        vColourcode = vrsSearch!Colourcode & ""
        vDriveable = Val(vrsSearch!Driveable & "")
        vOptions = vrsSearch!Specifications & ""
        vTrimcode = vrsSearch!Trimcode & ""
        vPaintsystem = vrsSearch!Paintsystem & ""
        If (IsDate(vrsSearch!Registereddate)) Then
            vRegistereddate = vrsSearch!Registereddate & ""
        End If
        If (IsDate(vrsSearch!Motdate)) Then
            vMotdate = vrsSearch!Motdate & ""
        End If
'' %^20
        vColour = vrsSearch!Colour & ""
        vModel = vrsSearch!Model & ""
        vMake = vrsSearch!Make & ""

            vjob.Vehicleid = vUid

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
Public Function Search(pSearchType As VehicleSearchENUM) As Long
    Dim sql As String
    Dim AddAnd As Boolean
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    ' to support mutiple matches, see
    vSearchby = pSearchType
    
    ' returns number of matches, -1 error
    sql = "SELECT v.*,c.Name AS COLOUR,mo.Name AS MODEL,ma.Name AS Make FROM ((Vehicle v LEFT OUTER JOIN Colour c ON v.colourID=c.uid) LEFT OUTER JOIN Model mo ON v.ModelID=mo.UID) LEFT OUTER JOIN Make ma ON mo.MakeID=ma.uid  WHERE "
    AddAnd = False
    
    If (BAnd(pSearchType, VehicleSearchENUM.ByCustomerID)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & " v.CustomerID =" & vCustomerid
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

