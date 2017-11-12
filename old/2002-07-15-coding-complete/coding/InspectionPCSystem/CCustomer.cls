VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassCustomer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Customer
''
'' Code by Dale Pitman

'' Used by customer Class
Public Enum CustomerSearchENUM
    BySurname = 1
    ByPostcode = 2
    ByHomeTelphoneNumber = 4
    ByStreet1 = 8
    ByUid = 16
    ByCompanyName = 32
End Enum

Public Enum CustomerOrderByENUM
    OrderSurname = 1
    OrderPostcode = 2
    OrderHomeTelphoneNumber = 4
    OrderStreet1 = 8
    OrderNone = 16
End Enum

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vTitleID As Long
 Private vRateid As Long
 Private vCompanyName As String
 Private vName As String
 Private vStreet1 As String
 Private vStreet2 As String
 Private vTown As String
 Private vCounty As String
 Private vCountry As String
 Private vPostCode As String
 Private vContactTelephoneNumber As String
 Private vFaxnumber As String
 Private vContactmobilenumber As String
 Private vContactprivatenumber As String
 Private vEmailaddress As String
 Private vDrivinglicencenumber As String
 Private vCreatedate As Date
 Private vVatnumber As String
'' %^04
 Private vTitle As String
'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vTitleIDC As Boolean
 Private vRateidC As Boolean
 Private vCompanyNameC As Boolean
 Private vNameC As Boolean
 Private vStreet1C As Boolean
 Private vStreet2C As Boolean
 Private vTownC As Boolean
 Private vCountyC As Boolean
 Private vCountryC As Boolean
 Private vPostcodeC As Boolean
 Private vContactTelephoneNumberC As Boolean
 Private vFaxnumberC As Boolean
 Private vContactmobilenumberC As Boolean
 Private vContactprivatenumberC As Boolean
 Private vEmailaddressC As Boolean
 Private vDrivinglicencenumberC As Boolean
 Private vCreatedateC As Boolean
 Private vVatnumberC As Boolean
'' %^06

'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vSearchby As CustomerSearchENUM

Private vSuppressRecordCount As Boolean
Private vHasDataC As Boolean

Private vVehicle As ClassVehicle

''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vTitleIDC = False
    vTitleID = 0
    vRateidC = False
    vRateid = 0
    vCompanyNameC = False
    vCompanyName = ""
    vNameC = False
    vName = ""
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
    vPostCode = ""
    vContactTelephoneNumberC = False
    vContactTelephoneNumber = ""
    vFaxnumberC = False
    vFaxnumber = ""
    vContactmobilenumberC = False
    vContactmobilenumber = ""
    vContactprivatenumberC = False
    vContactprivatenumber = ""
    vEmailaddressC = False
    vEmailaddress = ""
    vDrivinglicencenumberC = False
    vDrivinglicencenumber = ""
    vCreatedateC = False
    vCreatedate = 0
    vVatnumberC = False
    vVatnumber = ""
'' %^08
    ' Set record to not found
    vFoundC = False

    vHasDataC = False
    vSuppressRecordCount = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    ' Subclass initialisation go's here
'    vVehicle.Customer = Me
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Property Get SuppressRecordCount() As Boolean
    SuppressRecordCount = vSuppressRecordCount
End Property

Public Property Let SuppressRecordCount(ByVal NewValue As Boolean)
    vSuppressRecordCount = NewValue
End Property

Public Property Get HasData() As Boolean
    HasData = vHasDataC
End Property

Public Property Get Vehicle() As ClassVehicle
    Set Vehicle = vVehicle
End Property

Public Sub SetVehicle(pVehicle As ClassVehicle)
    Set vVehicle = pVehicle
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
    vHasDataC = True
End Property

Public Property Get TitleID() As Long
    TitleID = vTitleID
End Property

Public Property Let TitleID(ByVal NewValue As Long)
    vTitleID = NewValue
    vTitleIDC = True
    vHasDataC = True
End Property

Public Property Get Title() As String
    Title = AutoCase(vTitle, True)
End Property

Public Property Let Title(ByVal NewValue As String)
    vTitle = UCase$(NewValue)
    vTitleID = GlobalTitles.GetTitleID(vTitle, True)
    vTitleIDC = True
    vHasDataC = True
End Property

Public Property Get Rateid() As Long
    Rateid = vRateid
End Property

Public Property Let Rateid(ByVal NewValue As Long)
    vRateid = NewValue
    vRateidC = True
    vHasDataC = True
End Property

Public Property Get CompanyName() As String
    CompanyName = vCompanyName
End Property

Public Property Let CompanyName(ByVal NewValue As String)
    vCompanyName = NewValue
    vCompanyNameC = True
    vHasDataC = True
End Property

Public Property Get Name() As String
    Name = vName
End Property

Public Property Let Name(ByVal NewValue As String)
    vName = NewValue
    vNameC = True
    vHasDataC = True
End Property

Public Property Get Street1() As String
    Street1 = vStreet1
End Property

Public Property Let Street1(ByVal NewValue As String)
    vStreet1 = NewValue
    vStreet1C = True
    vHasDataC = True
End Property

Public Property Get Street2() As String
    Street2 = vStreet2
End Property

Public Property Let Street2(ByVal NewValue As String)
    vStreet2 = NewValue
    vStreet2C = True
    vHasDataC = True
End Property

Public Property Get Town() As String
    Town = vTown
End Property

Public Property Let Town(ByVal NewValue As String)
    vTown = NewValue
    vTownC = True
    vHasDataC = True
End Property

Public Property Get County() As String
    County = vCounty
End Property

Public Property Let County(ByVal NewValue As String)
    vCounty = NewValue
    vCountyC = True
    vHasDataC = True
End Property

Public Property Get Country() As String
    Country = vCountry
End Property

Public Property Let Country(ByVal NewValue As String)
    vCountry = NewValue
    vCountryC = True
    vHasDataC = True
End Property

Public Property Get Postcode() As String
    Postcode = vPostCode
End Property

Public Property Let Postcode(ByVal NewValue As String)
    vPostCode = NewValue
    vPostcodeC = True
    vHasDataC = True
End Property

Public Property Get ContactTelephoneNumber() As String
    ContactTelephoneNumber = vContactTelephoneNumber
End Property

Public Property Let ContactTelephoneNumber(ByVal NewValue As String)
    vContactTelephoneNumber = NewValue
    vContactTelephoneNumberC = True
    vHasDataC = True
End Property

Public Property Get Faxnumber() As String
    Faxnumber = vFaxnumber
End Property

Public Property Let Faxnumber(ByVal NewValue As String)
    vFaxnumber = NewValue
    vFaxnumberC = True
    vHasDataC = True
End Property

Public Property Get Contactmobilenumber() As String
    Contactmobilenumber = vContactmobilenumber
End Property

Public Property Let Contactmobilenumber(ByVal NewValue As String)
    vContactmobilenumber = NewValue
    vContactmobilenumberC = True
    vHasDataC = True
End Property

Public Property Get Contactprivatenumber() As String
    Contactprivatenumber = vContactprivatenumber
End Property

Public Property Let Contactprivatenumber(ByVal NewValue As String)
    vContactprivatenumber = NewValue
    vContactprivatenumberC = True
    vHasDataC = True
End Property

Public Property Get Emailaddress() As String
    Emailaddress = vEmailaddress
End Property

Public Property Let Emailaddress(ByVal NewValue As String)
    vEmailaddress = NewValue
    vEmailaddressC = True
    vHasDataC = True
End Property

Public Property Get Drivinglicencenumber() As String
    Drivinglicencenumber = vDrivinglicencenumber
End Property

Public Property Let Drivinglicencenumber(ByVal NewValue As String)
    vDrivinglicencenumber = NewValue
    vDrivinglicencenumberC = True
    vHasDataC = True
End Property

Public Property Get Createdate() As Date
    Createdate = vCreatedate
End Property

Public Property Let Createdate(ByVal NewValue As Date)
    vCreatedate = NewValue
    vCreatedateC = True
    vHasDataC = True
End Property

Public Property Get Vatnumber() As String
    Vatnumber = vVatnumber
End Property

Public Property Let Vatnumber(ByVal NewValue As String)
    vVatnumber = NewValue
    vVatnumberC = True
    vHasDataC = True
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
        sql = "SELECT c.*,t.title FROM (customer c LEFT OUTER JOIN title t ON c.Titleid=t.uid) WHERE c.Uid=" & vUid
'        Sql = "SELECT * FROM Customer WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        sql = "SELECT * FROM Customer WHERE "
    End If

    If (OpenRecordset(rsSearch, sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vTitleID = Val(rsSearch!TitleID & "")
        vRateid = Val(rsSearch!Rateid & "")
        vCompanyName = rsSearch!CompanyName & ""
        vName = rsSearch!Name & ""
        vStreet1 = rsSearch!Street1 & ""
        vStreet2 = rsSearch!Street2 & ""
        vTown = rsSearch!Town & ""
        vCounty = rsSearch!County & ""
        vCountry = rsSearch!Country & ""
        vPostCode = rsSearch!Postcode & ""
        vContactTelephoneNumber = rsSearch!ContactTelephoneNumber & ""
        vFaxnumber = rsSearch!Faxnumber & ""
        vContactmobilenumber = rsSearch!Contactmobilenumber & ""
        vContactprivatenumber = rsSearch!Contactprivatenumber & ""
        vEmailaddress = rsSearch!Emailaddress & ""
        vDrivinglicencenumber = rsSearch!Drivinglicencenumber & ""
        If (IsDate(rsSearch!Createdate)) Then
            vCreatedate = rsSearch!Createdate & ""
        End If
        vVatnumber = rsSearch!Vatnumber & ""
        
'' %^12
        vVehicle = vUid
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
    sql = "UPDATE Customer SET "
    If (vTitleID < 1) Then
        ' create new title
        vTitleID = GlobalTitles.GetTitleID(vTitle, True)
    End If
'' %^13
    If (vTitleIDC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Titleid=" & vTitleID
    End If
    If (vRateidC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Rateid=" & vRateid
    End If
    If (vCompanyNameC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Companyname=" & Chr$(34) & vCompanyName & Chr$(34)
    End If
    If (vNameC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Name=" & Chr$(34) & vName & Chr$(34)
    End If
    If (vStreet1C = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Street1=" & Chr$(34) & vStreet1 & Chr$(34)
    End If
    If (vStreet2C = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Street2=" & Chr$(34) & vStreet2 & Chr$(34)
    End If
    If (vTownC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Town=" & Chr$(34) & vTown & Chr$(34)
    End If
    If (vCountyC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " County=" & Chr$(34) & vCounty & Chr$(34)
    End If
    If (vCountryC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Country=" & Chr$(34) & vCountry & Chr$(34)
    End If
    If (vPostcodeC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Postcode=" & Chr$(34) & vPostCode & Chr$(34)
    End If
    If (vContactTelephoneNumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Contacttelephonenumber=" & Chr$(34) & vContactTelephoneNumber & Chr$(34)
    End If
    If (vFaxnumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Faxnumber=" & Chr$(34) & vFaxnumber & Chr$(34)
    End If
    If (vContactmobilenumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Contactmobilenumber=" & Chr$(34) & vContactmobilenumber & Chr$(34)
    End If
    If (vContactprivatenumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Contactprivatenumber=" & Chr$(34) & vContactprivatenumber & Chr$(34)
    End If
    If (vEmailaddressC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Emailaddress=" & Chr$(34) & vEmailaddress & Chr$(34)
    End If
    If (vDrivinglicencenumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Drivinglicencenumber=" & Chr$(34) & vDrivinglicencenumber & Chr$(34)
    End If
    If (vCreatedateC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Createdate=" & vCreatedate
    End If
    If (vVatnumberC = True) Then
        If (AddComma = True) Then
            sql = sql & ","
        End If
        AddComma = True
        sql = sql & " Vatnumber=" & Chr$(34) & vVatnumber & Chr$(34)
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
    sql = "INSERT INTO Customer ("
'' %^15
    sql = sql & "Uid"
    If (TitleID < 1) Then
        ' create new title
        vTitleID = GlobalTitles.GetTitleID(vTitle, True)
    End If
    If (vTitleIDC = True) Then
        sql = sql & ",Titleid"
    End If
    If (vRateidC = True) Then
        sql = sql & ",Rateid"
    End If
    If (vCompanyNameC = True) Then
        sql = sql & ",Companyname"
    End If
    If (vNameC = True) Then
        sql = sql & ",Name"
    End If
    If (vStreet1C = True) Then
        sql = sql & ",Street1"
    End If
    If (vStreet2C = True) Then
        sql = sql & ",Street2"
    End If
    If (vTownC = True) Then
        sql = sql & ",Town"
    End If
    If (vCountyC = True) Then
        sql = sql & ",County"
    End If
    If (vCountryC = True) Then
        sql = sql & ",Country"
    End If
    If (vPostcodeC = True) Then
        sql = sql & ",Postcode"
    End If
    If (vContactTelephoneNumberC = True) Then
        sql = sql & ",Contacttelephonenumber"
    End If
    If (vFaxnumberC = True) Then
        sql = sql & ",Faxnumber"
    End If
    If (vContactmobilenumberC = True) Then
        sql = sql & ",Contactmobilenumber"
    End If
    If (vContactprivatenumberC = True) Then
        sql = sql & ",Contactprivatenumber"
    End If
    If (vEmailaddressC = True) Then
        sql = sql & ",Emailaddress"
    End If
    If (vDrivinglicencenumberC = True) Then
        sql = sql & ",Drivinglicencenumber"
    End If
    If (vCreatedateC = True) Then
        sql = sql & ",Createdate"
    End If
    If (vVatnumberC = True) Then
        sql = sql & ",Vatnumber"
    End If
    sql = sql & ") VALUES ("
    FieldData = FieldData & vUid
    If (vTitleIDC = True) Then
        FieldData = FieldData & "," & vTitleID
    End If
    If (vRateidC = True) Then
        FieldData = FieldData & "," & vRateid
    End If
    If (vCompanyNameC = True) Then
        FieldData = FieldData & "," & Chr(34) & vCompanyName & Chr(34)
    End If
    If (vNameC = True) Then
        FieldData = FieldData & "," & Chr(34) & vName & Chr(34)
    End If
    If (vStreet1C = True) Then
        FieldData = FieldData & "," & Chr(34) & vStreet1 & Chr(34)
    End If
    If (vStreet2C = True) Then
        FieldData = FieldData & "," & Chr(34) & vStreet2 & Chr(34)
    End If
    If (vTownC = True) Then
        FieldData = FieldData & "," & Chr(34) & vTown & Chr(34)
    End If
    If (vCountyC = True) Then
        FieldData = FieldData & "," & Chr(34) & vCounty & Chr(34)
    End If
    If (vCountryC = True) Then
        FieldData = FieldData & "," & Chr(34) & vCountry & Chr(34)
    End If
    If (vPostcodeC = True) Then
        FieldData = FieldData & "," & Chr(34) & vPostCode & Chr(34)
    End If
    If (vContactTelephoneNumberC = True) Then
        FieldData = FieldData & "," & Chr(34) & vContactTelephoneNumber & Chr(34)
    End If
    If (vFaxnumberC = True) Then
        FieldData = FieldData & "," & Chr(34) & vFaxnumber & Chr(34)
    End If
    If (vContactmobilenumberC = True) Then
        FieldData = FieldData & "," & Chr(34) & vContactmobilenumber & Chr(34)
    End If
    If (vContactprivatenumberC = True) Then
        FieldData = FieldData & "," & Chr(34) & vContactprivatenumber & Chr(34)
    End If
    If (vEmailaddressC = True) Then
        FieldData = FieldData & "," & Chr(34) & vEmailaddress & Chr(34)
    End If
    If (vDrivinglicencenumberC = True) Then
        FieldData = FieldData & "," & Chr(34) & vDrivinglicencenumber & Chr(34)
    End If
    If (vCreatedateC = True) Then
        FieldData = FieldData & "," & vCreatedate
    End If
    If (vVatnumberC = True) Then
        FieldData = FieldData & "," & Chr(34) & vVatnumber & Chr(34)
    End If
    sql = sql & ") "
'' %^16


    If (Execute(sql) > 0) Then
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
    Dim sql As String

    sql = "DELETE * FROM Customer where Uid=" & vUid

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


'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
        vHasDataC = True
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vTitleID = Val(vrsSearch!TitleID & "")
        vRateid = Val(vrsSearch!Rateid & "")
        vCompanyName = vrsSearch!CompanyName & ""
        vName = vrsSearch!Name & ""
        vStreet1 = vrsSearch!Street1 & ""
        vStreet2 = vrsSearch!Street2 & ""
        vTown = vrsSearch!Town & ""
        vCounty = vrsSearch!County & ""
        vCountry = vrsSearch!Country & ""
        vPostCode = vrsSearch!Postcode & ""
        vContactTelephoneNumber = vrsSearch!ContactTelephoneNumber & ""
        vFaxnumber = vrsSearch!Faxnumber & ""
        vContactmobilenumber = vrsSearch!Contactmobilenumber & ""
        vContactprivatenumber = vrsSearch!Contactprivatenumber & ""
        vEmailaddress = vrsSearch!Emailaddress & ""
        vDrivinglicencenumber = vrsSearch!Drivinglicencenumber & ""
        If (IsDate(vrsSearch!Createdate)) Then
            vCreatedate = vrsSearch!Createdate & ""
        End If
        vVatnumber = vrsSearch!Vatnumber & ""
'' %^20
        vVehicle.Customerid = vUid

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
Public Function Search(pSearchType As CustomerSearchENUM, Optional pOrderBy As CustomerOrderByENUM = ByUid) As Long
    Dim sql As String
    Dim AddAnd As Boolean
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    ' to support mutiple matches, see
    vSearchby = pSearchType
    
    ' returns number of matches, -1 error
    sql = "SELECT c.*,t.title FROM (customer c LEFT JOIN title t ON c.Titleid=t.uid) WHERE "
    AddAnd = False
    
    If (BAnd(pSearchType, ByPostcode)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & " Postcode LIKE " & cTextField & vPostCode & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, BySurname)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & "name LIKE " & cTextField & vName & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByCompanyName)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & "companyname LIKE " & cTextField & vCompanyName & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByHomeTelphoneNumber)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & "ContactTelephoneNumber LIKE " & cTextField & vContactTelephoneNumber & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByStreet1)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & " street1 LIKE " & cTextField & vStreet1 & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByUid)) Then
        If (AddAnd = True) Then
            sql = sql & " AND "
        End If
        sql = sql & " c.uid=" & vUid
        AddAnd = True
    End If
    
    Select Case pOrderBy
        Case OrderSurname
            sql = sql & " ORDER BY name"
        Case OrderPostcode
            sql = sql & "order by postcode"
        Case OrderHomeTelphoneNumber
            sql = sql & "ORDER BY ContactTelephoneNumber"
        Case OrderStreet1
            sql = sql & "ORDER BY street1"
        Case OrderNone
'            Sql = Sql
    End Select
    
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

''
Public Function CloseSearch() As Boolean
    Call vrsSearch.Close
    CloseSearch = True
End Function

''
Public Function ClearSearchDetails() As Boolean
    vUidC = False
    vTitleIDC = False
    vTitle = ""
    vCompanyNameC = False
    vCompanyName = ""
    If (vSearchby <> BySurname) Then
        vNameC = False
        vName = ""
    End If
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
    If (vSearchby <> ByPostcode) Then
        vPostcodeC = False
        vPostCode = ""
    End If
    If (vSearchby <> ByHomeTelphoneNumber) Then
        vContactTelephoneNumberC = False
        vContactTelephoneNumber = ""
    End If
'    vWorktelephoneC = False
'    vWorktelephone = ""
'    vMobiletelephoneC = False
'    vMobiletelephone = ""
    ' Set record to not found
    vFoundC = False
End Function

''
Public Function SyncRecord() As Long
    Dim rstemp As Recordset
    If (vFoundC = False) Then
        Call CreateRecord
    Else
        Call WriteRecord
    End If
    SyncRecord = vUid
    ' Update Call LOG
'    If (OpenRecordsetCHistory(rstemp, "SELECT * FROM CustomerLog WHERE customerid=" & vUid, dbOpenDynaset)) Then
'        If (rstemp.EOF = False) Then
'            Call rstemp.Edit
'        Else
'            Call rstemp.AddNew
'        End If
'        rstemp!CustomerID = vUid
'        rstemp!logdate = Now
'        rstemp!Name = vName
'        rstemp!Postcode = vPostCode
'        rstemp!UserID = CurrentUser.Uid
'        Call rstemp.Update
'    End If
End Function


