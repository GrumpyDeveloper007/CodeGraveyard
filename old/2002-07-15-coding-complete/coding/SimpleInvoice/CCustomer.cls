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

'' Fields
 Private vUid As Long
 Private vTitle As String
 Private vTitleID As Long
 Private vName As String
 Private vCompanyName As String
 Private vStreet1 As String
 Private vStreet2 As String
 Private vTown As String
 Private vCounty As String
 Private vCountry As String
 Private vPostCode As String
 Private vContactTelephoneNumber As String
 Private vDueDatePeriod As Long
 Private vPercentageDiscount As Long
' Private vWorktelephone As String
' Private vMobiletelephone As String
 Private vEmail As String
 Private vOneOffCustomer As Long
 Private vDepartment As String

'' Track if varibles are updated, so only changed ones are
'' written on a update
' Private vCustomeridC As Boolean

'' Track if varibles are updated, so only changed ones are
'' written on a update
 Private vUidC As Boolean
 Private vTitleIDC As Boolean
 Private vCompanyNameC As Boolean
 Private vNameC As Boolean
 Private vStreet1C As Boolean
 Private vStreet2C As Boolean
 Private vTownC As Boolean
 Private vCountyC As Boolean
 Private vCountryC As Boolean
 Private vPostcodeC As Boolean
 Private vContactTelephoneNumberC As Boolean
 Private vDueDatePeriodC As Boolean
 Private vPercentageDiscountC As Boolean
' Private vWorktelephoneC As Boolean
' Private vMobiletelephoneC As Boolean
 Private vEmailC As Boolean
 Private vOneOffCustomerC As Boolean
 Private vDepartmentC As Boolean

'' Track if record has been read
Private vFoundC As Boolean


'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select
Private vSearchby As CustomerSearchENUM

Private vSuppressRecordCount As Boolean
Private vHasDataC As Boolean

'' Reset Conditions
Private Sub ClearStatus()
    Call LogEvent("Customer Clear")
    vUidC = False
    vUid = 0
    vTitleIDC = False
    vTitleID = 0
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
    vEmailC = False
    vEmail = ""
    vDueDatePeriod = 0
    vDueDatePeriodC = False
    vOneOffCustomer = 0
    vOneOffCustomerC = False
    vPercentageDiscount = 0
    vPercentageDiscountC = False
    vDepartment = ""
    vDepartmentC = False
    
    vHasDataC = False
    ' Set record to not found
    vFoundC = False
    vSuppressRecordCount = False
End Sub

Private Sub Class_Initialize()
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

'Public Property Get Parent() As
'    Set Parent = vAppliance
'End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
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
    Title = vTitle
End Property

Public Property Let Title(ByVal NewValue As String)
    vTitle = NewValue
    vTitleID = GlobalTitles.GetTitleID(vTitle, True)
    vTitleIDC = True
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

Public Property Get postcode() As String
    postcode = vPostCode
End Property

Public Property Get postcode_V() As String
    postcode = ValidatePostcode(vPostCode)
    If (Left$(postcode, 5) = "ERROR") Then
        postcode = vPostCode
    End If
End Property

Public Property Let postcode(ByVal NewValue As String)
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

'Public Property Get Worktelephone() As String
'    Worktelephone = vWorktelephone
'End Property
'Public Property Let Worktelephone(ByVal NewValue As String)
'    vWorktelephone = NewValue
'    vWorktelephoneC = True
'End Property

'Public Property Get Mobiletelephone() As String
'    Mobiletelephone = vMobiletelephone
'End Property
'Public Property Let Mobiletelephone(ByVal NewValue As String)
'    vMobiletelephone = NewValue
'    vMobiletelephoneC = True
'End Property


Public Property Get Email() As String
    Email = LCase$(vEmail)
End Property

Public Property Let Email(ByVal NewValue As String)
    vEmail = NewValue
    vEmailC = True
    vHasDataC = True
End Property

Public Property Get DueDatePeriod() As Long
    DueDatePeriod = vDueDatePeriod
End Property

Public Property Let DueDatePeriod(ByVal NewValue As Long)
    vDueDatePeriod = NewValue
    vDueDatePeriodC = True
    vHasDataC = True
End Property

Public Property Get OneOffCustomer() As Long
    OneOffCustomer = vOneOffCustomer
End Property

Public Property Let OneOffCustomer(ByVal NewValue As Long)
    vOneOffCustomer = NewValue
    vOneOffCustomerC = True
    vHasDataC = True
End Property

Public Property Get PercentageDiscount() As Long
    PercentageDiscount = vPercentageDiscount
End Property

Public Property Let PercentageDiscount(ByVal NewValue As Long)
    vPercentageDiscount = NewValue
    vPercentageDiscountC = True
    vHasDataC = True
End Property

Public Property Get Department() As String
    Department = vDepartment
End Property

Public Property Let Department(ByVal NewValue As String)
    vDepartment = NewValue
    vDepartmentC = True
    vHasDataC = True
End Property

''*************************************************************
'' Status of record search
Public Property Get Found() As Boolean
        Found = vFoundC
End Property

Public Property Get HasData() As Boolean
        HasData = vHasDataC
End Property

'' **********************************************************************
'' Read Record
Public Function ReadRecord(pUseInvoice As Boolean) As Boolean
    Dim Sql As String
    Dim rsSearch As Recordset

    On Error GoTo GeneralError
'    MCurrentRecord=-1
    If (vUid > 0) Then
        If (vUidC = True) Then ' If key field written to then use that,
            If (pUseInvoice = True) Then
                Sql = "SELECT c.*,t.title FROM (Invoicecustomer c LEFT OUTER JOIN title t ON c.Titleid=t.uid) WHERE c.Uid=" & vUid
            Else
                Sql = "SELECT c.*,t.title FROM (customer c LEFT OUTER JOIN title t ON c.Titleid=t.uid) WHERE c.Uid=" & vUid
            End If
        Else  ' otherwise use specified fields
    '        Sql = "SELECT * FROM Customer WHERE "
        End If
    
        If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
            If (rsSearch.EOF = True) Then
    '            Call ClearStatus
                vFoundC = False
            Else
                Call LogEvent("Customer ReadRecord")
                vHasDataC = True
                vFoundC = True
                vUid = Val(rsSearch!Uid & "")
                vTitle = Trim$(rsSearch!Title & "")
                vCompanyName = Trim$(rsSearch!CompanyName & "")
                vName = Trim$(rsSearch!Name & "")
                vStreet1 = Trim$(rsSearch!Street1 & "")
                vStreet2 = Trim$(rsSearch!Street2 & "")
                vTown = Trim$(rsSearch!Town & "")
                vCounty = Trim$(rsSearch!County & "")
                vCountry = Trim$(rsSearch!Country & "")
                vPostCode = Trim$(rsSearch!postcode & "")
                vContactTelephoneNumber = Trim$(rsSearch!ContactTelephoneNumber & "")
                vEmail = Trim$(rsSearch!Email & "")
                vDueDatePeriod = Val(rsSearch!DueDatePeriod & "")
                vOneOffCustomer = Val(rsSearch!OneOffCustomer & "")
                vPercentageDiscount = Val(rsSearch!PercentageDiscount & "")
                vDepartment = rsSearch!Department & ""
                
                ' Sub-class resync
                
            End If
        Else
            vFoundC = False
        End If
    Else
        vFoundC = False
    End If
    ' Return record found
    ReadRecord = vFoundC
    Exit Function
GeneralError:
    If (ErrorCheck(Error$, "ReadRecord,customer")) Then
        Resume
    End If
    ReadRecord = False
End Function

'' **********************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim Sql As String
    Call LogEvent("Customer Write")

        WriteRecord = True
    Sql = "UPDATE Customer SET "
    If (vTitleID < 1) Then
        ' create new title
        vTitleID = GlobalTitles.GetTitleID(vTitle, True)
    End If
    Sql = Sql & " TitleID=" & vTitleID
    If (vNameC = True) Then
        Sql = Sql & " ,Name=" & cTextField & vName & cTextField
    End If
    If (vNameC = True) Then
        Sql = Sql & " ,CompanyName=" & cTextField & vCompanyName & cTextField
    End If
    If (vStreet1C = True) Then
        Sql = Sql & " ,Street1=" & cTextField & vStreet1 & cTextField
    End If
    If (vStreet2C = True) Then
        Sql = Sql & " ,Street2=" & cTextField & vStreet2 & cTextField
    End If
    If (vTownC = True) Then
        Sql = Sql & " ,Town=" & cTextField & vTown & cTextField
    End If
    If (vCountyC = True) Then
        Sql = Sql & " ,County=" & cTextField & vCounty & cTextField
    End If
    If (vCountryC = True) Then
        Sql = Sql & " ,Country=" & cTextField & vCountry & cTextField
    End If
    If (vPostcodeC = True) Then
        Sql = Sql & " ,Postcode=" & cTextField & vPostCode & cTextField
    End If
    If (vContactTelephoneNumberC = True) Then
        Sql = Sql & " ,ContactTelephoneNumber=" & cTextField & vContactTelephoneNumber & cTextField
    End If
    If (vEmailC = True) Then
        Sql = Sql & " ,Email=" & cTextField & vEmail & cTextField
    End If
    If (vDueDatePeriodC = True) Then
        Sql = Sql & " ,DueDatePeriod=" & vDueDatePeriod
    End If
    If (vOneOffCustomerC = True) Then
        Sql = Sql & " ,OneOffCustomer=" & vOneOffCustomer
    End If
    If (vPercentageDiscountC = True) Then
        Sql = Sql & " ,PercentageDiscount=" & vPercentageDiscount
    End If
    If (vDepartmentC = True) Then
        Sql = Sql & " ,Department=" & cTextField & vDepartment & cTextField
    End If

    Sql = Sql & " WHERE Uid =" & vUid
    
    WriteRecord = True
    
    If (Execute(Sql, True) = 1) Then
    ' this should return the result FROM updating the database
    Else
        'error
        WriteRecord = False
    End If
End Function

'' **********************************************************************
'' Create Record

Public Function CreateRecord(pUseInvoice As Boolean) As Boolean
    Dim Sql As String
    Dim FieldData As String
    On Error GoTo GeneralError

    If (pUseInvoice = True) Then
        Call LogEvent("Customer Create (InvoiceCustomer)")
        Sql = "INSERT INTO InvoiceCustomer ("
        vTitleIDC = True
        vCompanyNameC = True
        vNameC = True
        vStreet1C = True
        vStreet2C = True
        vTownC = True
        vCountyC = True
        vCountryC = True
        vPostcodeC = True
        vContactTelephoneNumberC = True
        vEmailC = True
        vDueDatePeriodC = True
        vOneOffCustomerC = True
        vPercentageDiscountC = True
        vDepartmentC = True
    Else
        Sql = "INSERT INTO Customer ("
        Call LogEvent("Customer Create (Customer)")
    End If
    FieldData = "("
        
    If (vTitleIDC = True) Then
        If (TitleID < 1) Then
            ' create new title
            vTitleID = GlobalTitles.GetTitleID(vTitle, True)
        End If
        Sql = Sql & "TitleID,"
        FieldData = FieldData & vTitleID & ","
    End If
    If (vNameC = True) Then
        Sql = Sql & "Name,"
        FieldData = FieldData & "'" & vName & "',"
    End If
    If (vNameC = True) Then
        Sql = Sql & "CompanyName,"
        FieldData = FieldData & "'" & vCompanyName & "',"
    End If
    If (vStreet1C = True) Then
        Sql = Sql & "Street1,"
        FieldData = FieldData & "'" & vStreet1 & "',"
    End If
    If (vStreet2C = True) Then
        Sql = Sql & "Street2,"
        FieldData = FieldData & "'" & vStreet2 & "',"
    End If
    If (vTownC = True) Then
        Sql = Sql & "Town,"
        FieldData = FieldData & "'" & vTown & "',"
    End If
    If (vCountyC = True) Then
        Sql = Sql & "County,"
        FieldData = FieldData & "'" & vCounty & "',"
    End If
    If (vCountryC = True) Then
        Sql = Sql & "Country,"
        FieldData = FieldData & "'" & vCountry & "',"
    End If
    If (vPostcodeC = True) Then
        Sql = Sql & "PostCode,"
        FieldData = FieldData & "'" & vPostCode & "',"
    End If
    If (vContactTelephoneNumberC = True) Then
        Sql = Sql & "ContactTelephoneNumber,"
        FieldData = FieldData & "'" & vContactTelephoneNumber & "',"
    End If
    If (vEmailC = True) Then
        Sql = Sql & "Email,"
        FieldData = FieldData & "'" & vEmail & "',"
    End If
    If (vDueDatePeriodC = True) Then
        Sql = Sql & "DueDatePeriod,"
        FieldData = FieldData & vDueDatePeriod & ","
    End If
    If (vOneOffCustomerC = True) Then
        Sql = Sql & "OneOffCustomer,"
        FieldData = FieldData & vOneOffCustomer & ","
    End If
    If (vPercentageDiscountC = True) Then
        Sql = Sql & "PercentageDiscount,"
        FieldData = FieldData & vPercentageDiscount & ","
    End If
    If (vDepartmentC = True) Then
        Sql = Sql & "Department,"
        FieldData = FieldData & "'" & vDepartment & "',"
    End If


    Sql = Left$(Sql, Len(Sql) - 1)
    FieldData = Left$(FieldData, Len(FieldData) - 1)
    vUid = CreateRecordWithSQL(Sql & ") VALUES " & FieldData & ")")
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
    If (ErrorCheck(Error$, "Create record,Customer")) Then
        Resume
    End If
End Function

'' *********************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim Sql As String

    DeleteRecord = True
    Sql = "DELETE * FROM Customer WHERE Uid=" & vUid

    If (Execute(Sql, True) = 1) Then
        Call ClearStatus
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

'' Copy data FROM recordset to local storage
Private Function LoadFromSearch() As Boolean
    LoadFromSearch = True
    On Error GoTo GeneralError
'    Call ClearStatus
        vHasDataC = True
        vUid = Val(vrsSearch!Uid & "")
        vTitle = vrsSearch!Title & ""
        vTitleID = Val(vrsSearch!TitleID & "")
        vName = vrsSearch!Name & ""
        vCompanyName = vrsSearch!CompanyName & ""
        vStreet1 = vrsSearch!Street1 & ""
        vStreet2 = vrsSearch!Street2 & ""
        vTown = vrsSearch!Town & ""
        vCounty = vrsSearch!County & ""
        vCountry = vrsSearch!Country & ""
        vPostCode = vrsSearch!postcode & ""
        vContactTelephoneNumber = vrsSearch!ContactTelephoneNumber & ""
'        vWorktelephone = vrsSearch!Worktelephone & ""
'        vMobiletelephone = vrsSearch!Mobiletelephone & ""
'        vEmail = vrsSearch!Email & ""
        vDueDatePeriod = Val(vrsSearch!DueDatePeriod & "")
        vOneOffCustomer = Val(vrsSearch!OneOffCustomer & "")
        vPercentageDiscount = Val(vrsSearch!PercentageDiscount & "")
        vDepartment = vrsSearch!Department & ""
        vFoundC = True
    ' Set sub-class resync -

    ' Move to next record
    vrsSearch.MoveNext
    vRecordNumber = vRecordNumber + 1
    Exit Function
GeneralError:
    If (ErrorCheck(Error$, "LoadFromSearch, Customer")) Then
        Resume
    End If
    LoadFromSearch = False
End Function

'' *********************************************************************
'' Multiple Record Selection

'' Copy data FROM search recordset and move cursor to next record
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
        NextRecord = LoadFromSearch
    End If
End Function

''
Public Function Search(pSearchType As CustomerSearchENUM, Optional pOrderBy As CustomerOrderByENUM = ByUid) As Long
    Dim Sql As String
    Dim AddAnd As Boolean
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    ' to support mutiple matches, see
    vSearchby = pSearchType
    
    ' returns number of matches, -1 error
    Sql = "SELECT c.*,t.title FROM (customer c LEFT JOIN title t ON c.Titleid=t.uid) WHERE "
    AddAnd = False
    
    If (BAnd(pSearchType, ByPostcode)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " Postcode LIKE " & cTextField & vPostCode & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, BySurname)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & "name LIKE " & cTextField & vName & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByCompanyName)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & "companyname LIKE " & cTextField & vCompanyName & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByHomeTelphoneNumber)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & "ContactTelephoneNumber LIKE " & cTextField & vContactTelephoneNumber & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByStreet1)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " street1 LIKE " & cTextField & vStreet1 & cWildCard & cTextField
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByUid)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " c.uid=" & vUid
        AddAnd = True
    End If
    
    Select Case pOrderBy
        Case OrderSurname
            Sql = Sql & " ORDER BY name"
        Case OrderPostcode
            Sql = Sql & "order by postcode"
        Case OrderHomeTelphoneNumber
            Sql = Sql & "ORDER BY ContactTelephoneNumber"
        Case OrderStreet1
            Sql = Sql & "ORDER BY street1"
        Case OrderNone
'            Sql = Sql
    End Select
    
    If (OpenRecordset(vrsSearch, Sql, dbOpenSnapshot)) Then
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
    vEmailC = False
    vEmail = ""
    vDueDatePeriod = 0
    vDueDatePeriodC = False
    vOneOffCustomer = 0
    vOneOffCustomerC = False
    vPercentageDiscount = 0
    vPercentageDiscountC = False
    vDepartment = ""
    vDepartmentC = False
    ' Set record to not found
    vFoundC = False
End Function

''
Public Function NewRecord()
    ' resets all data, so ready for new call (including children)
    Call ClearStatus
End Function

''
Public Function SyncRecord() As Long
    Dim rstemp As Recordset
    If (vFoundC = False) Then
        Call CreateRecord(False)
    Else
        Call WriteRecord
    End If
    SyncRecord = vUid
End Function

