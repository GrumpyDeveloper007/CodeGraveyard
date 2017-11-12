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
 Private vSalutation As String
 Private vName As String
 Private vInitials As String
 Private vStreet1 As String
 Private vStreet2 As String
 Private vTown As String
 Private vCounty As String
 Private vPostCode As String
 Private vHometelephone As String
 Private vWorktelephone As String
 Private vMobiletelephone As String
 Private vWorktelephonextension As String
 Private vCreditname As String
 Private vExpirydate As Date
 Private vStartdate As Date
 Private vCreditnumber As String
 Private vIssueNumber As String
 Private vEmail As String

 Private vDeliveryName As String
 Private vDeliveryStreet1 As String
 Private vDeliveryStreet2 As String
 Private vDeliveryTown As String
 Private vDeliveryCounty As String
 Private vDeliveryPostcode As String

'' Customer Comments Fields
 Private vCustomerID As Long
 Private vComments As String 'Memo type
 Private vDirection As String 'Memo type

'' Track if varibles are updated, so only changed ones are
'' written on a update
' Private vCustomeridC As Boolean
 Private vCommentsC As Boolean
 Private vDirectionC As Boolean

 Private vCustomerCommentsRead As Boolean
 Private vCustomerCommentsExists As Boolean

'' Track if varibles are updated, so only changed ones are
'' written on a update
 Private vUidC As Boolean
 Private vSalutationC As Boolean
 Private vNameC As Boolean
 Private vInitialsC As Boolean
 Private vStreet1C As Boolean
 Private vStreet2C As Boolean
 Private vTownC As Boolean
 Private vCountyC As Boolean
 Private vPostcodeC As Boolean
 Private vHometelephoneC As Boolean
 Private vWorktelephoneC As Boolean
 Private vMobiletelephoneC As Boolean
 Private vWorktelephonextensionC As Boolean
 Private vCreditnameC As Boolean
 Private vExpirydateC As Boolean
 Private vStartdateC As Boolean
 Private vCreditnumberC As Boolean
 Private vIssueNumberC As Boolean
 Private vEmailC As Boolean

 Private vDeliveryNameC As Boolean
 Private vDeliveryStreet1C As Boolean
 Private vDeliveryStreet2C As Boolean
 Private vDeliveryTownC As Boolean
 Private vDeliveryCountyC As Boolean
 Private vDeliveryPostcodeC As Boolean

'' Track if record has been read
Private vFoundC As Boolean


'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select
Private vSearchby As CustomerSearchENUM

Private vSuppressRecordCount As Boolean

Private vAppliance As ClassAppliance
Private vApplianceC As Boolean

'' Reset Conditions
Private Sub ClearStatus()
    vUidC = False
    vUid = 0
    vSalutationC = False
    vSalutation = ""
    vNameC = False
    vName = ""
    vInitialsC = False
    vInitials = ""
    vStreet1C = False
    vStreet1 = ""
    vStreet2C = False
    vStreet2 = ""
    vTownC = False
    vTown = ""
    vCountyC = False
    vCounty = ""
    vPostcodeC = False
    vPostCode = ""
    vHometelephoneC = False
    vHometelephone = ""
    vWorktelephoneC = False
    vWorktelephone = ""
    vWorktelephonextensionC = False
    vWorktelephonextension = ""
    vCreditnameC = False
    vCreditname = ""
    vExpirydateC = False
    vExpirydate = 0
    vStartdateC = False
    vStartdate = 0
    vCreditnumberC = False
    vCreditnumber = ""
    vEmailC = False
    vEmail = ""
    
    vComments = ""
    vCommentsC = False
    vDirection = ""
    vDirectionC = False
    
    vDeliveryNameC = False
    vDeliveryStreet1C = False
    vDeliveryStreet2C = False
    vDeliveryTownC = False
    vDeliveryCountyC = False
    vDeliveryPostcodeC = False
    
    vDeliveryName = ""
    vDeliveryStreet1 = ""
    vDeliveryStreet2 = ""
    vDeliveryTown = ""
    vDeliveryCounty = ""
    vDeliveryPostcode = ""
    
    ' Set record to not found
    vFoundC = False
    vCustomerCommentsRead = False
    vCustomerCommentsExists = False
    vSuppressRecordCount = False
End Sub

Private Sub Class_Initialize()
    Set vAppliance = New ClassAppliance
    
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

Public Property Get Appliance() As ClassAppliance
    Set Appliance = vAppliance
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Property Get SuppressRecordCount() As Boolean
    SuppressRecordCount = vSuppressRecordCount
End Property

Public Property Let SuppressRecordCount(ByVal NewValue As Boolean)
    vSuppressRecordCount = NewValue
End Property

''*************************************************************************
'' Update Property Procedures
Public Property Get DeliveryName() As String
    DeliveryName = vDeliveryName
End Property

Public Property Let DeliveryName(ByVal NewValue As String)
    vDeliveryName = NewValue
    vDeliveryNameC = True
End Property

Public Property Get DeliveryStreet1() As String
    DeliveryStreet1 = vDeliveryStreet1
End Property

Public Property Let DeliveryStreet1(ByVal NewValue As String)
    vDeliveryStreet1 = NewValue
    vDeliveryStreet1C = True
End Property

Public Property Get DeliveryStreet2() As String
    DeliveryStreet2 = vDeliveryStreet2
End Property

Public Property Let DeliveryStreet2(ByVal NewValue As String)
    vDeliveryStreet2 = NewValue
    vDeliveryStreet2C = True
End Property

Public Property Get DeliveryTown() As String
    DeliveryTown = vDeliveryTown
End Property

Public Property Let DeliveryTown(ByVal NewValue As String)
    vDeliveryTown = NewValue
    vDeliveryTownC = True
End Property

Public Property Get DeliveryCounty() As String
    DeliveryCounty = vDeliveryCounty
End Property

Public Property Let DeliveryCounty(ByVal NewValue As String)
    vDeliveryCounty = NewValue
    vDeliveryCountyC = True
End Property

Public Property Get DeliveryPostcode() As String
    DeliveryPostcode = vDeliveryPostcode
End Property

Public Property Let DeliveryPostcode(ByVal NewValue As String)
    vDeliveryPostcode = NewValue
    vDeliveryPostcodeC = True
End Property
''*************************************************************************

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

Public Property Get Salutation() As String
    Salutation = vSalutation
End Property

Public Property Let Salutation(ByVal NewValue As String)
    vSalutation = NewValue
    vSalutationC = True
End Property

Public Property Get Name() As String
    Name = vName
End Property

Public Property Let Name(ByVal NewValue As String)
    vName = NewValue
    vNameC = True
End Property

Public Property Get Initials() As String
    Initials = vInitials
End Property

Public Property Let Initials(ByVal NewValue As String)
    vInitials = NewValue
    vInitialsC = True
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

Public Property Get Postcode() As String
    Postcode = vPostCode
End Property

Public Property Let Postcode(ByVal NewValue As String)
    vPostCode = NewValue
    vPostcodeC = True
End Property

Public Property Get Hometelephone() As String
    Hometelephone = vHometelephone
End Property

Public Property Let Hometelephone(ByVal NewValue As String)
    vHometelephone = NewValue
    vHometelephoneC = True
End Property

Public Property Get Worktelephone() As String
    Worktelephone = vWorktelephone
End Property

Public Property Let Worktelephone(ByVal NewValue As String)
    vWorktelephone = NewValue
    vWorktelephoneC = True
End Property

Public Property Get Mobiletelephone() As String
    Mobiletelephone = vMobiletelephone
End Property

Public Property Let Mobiletelephone(ByVal NewValue As String)
    vMobiletelephone = NewValue
    vMobiletelephoneC = True
End Property

Public Property Get Worktelephonextension() As String
    Worktelephonextension = vWorktelephonextension
End Property

Public Property Let Worktelephonextension(ByVal NewValue As String)
    vWorktelephonextension = NewValue
    vWorktelephonextensionC = True
End Property

Public Property Get Creditname() As String
    Creditname = vCreditname
End Property

Public Property Let Creditname(ByVal NewValue As String)
    vCreditname = NewValue
    vCreditnameC = True
End Property

Public Property Get Expirydate() As Date
    Expirydate = vExpirydate
End Property

Public Property Let Expirydate(ByVal NewValue As Date)
    vExpirydate = NewValue
    vExpirydateC = True
End Property

Public Property Get Startdate() As Date
    Startdate = vStartdate
End Property

Public Property Let Startdate(ByVal NewValue As Date)
    vStartdate = NewValue
    vStartdateC = True
End Property

Public Property Get Creditnumber() As String
    Creditnumber = vCreditnumber
End Property

Public Property Let Creditnumber(ByVal NewValue As String)
    vCreditnumber = NewValue
    vCreditnumberC = True
End Property

Public Property Get IssueNumber() As String
    IssueNumber = vIssueNumber
End Property

Public Property Let IssueNumber(ByVal NewValue As String)
    vIssueNumber = NewValue
    vIssueNumberC = True
End Property

Public Property Get Email() As String
    Email = vEmail
End Property

Public Property Let Email(ByVal NewValue As String)
    vEmail = NewValue
    vEmailC = True
End Property

''*************************************************************
'' Properties FROM customerComments table

Public Property Get Comments() As String
    Comments = vComments
End Property

Public Property Let Comments(ByVal NewValue As String)
    vComments = NewValue
    vCommentsC = True
End Property

Public Property Get Direction() As String
    Direction = vDirection
End Property

Public Property Let Direction(ByVal NewValue As String)
    vDirection = NewValue
    vDirectionC = True
End Property

''*************************************************************
'' Status of record search
Public Property Get Found() As Boolean
        Found = vFoundC
End Property

'Public Property Let Found(ByVal NewValue As boolean)
'    vFound = NewValue
'End Property

'' **********************************************************************
'' Read Record
Public Function ReadRecord() As Boolean
    Dim SQL As String
    Dim rsSearch As Recordset

    On Error GoTo GeneralError
'    MCurrentRecord=-1
    If (vUid > 0) Then
        If (vUidC = True) Then ' If key field written to then use that,
            SQL = "SELECT * FROM Customer WHERE Uid=" & vUid
        Else  ' otherwise use specified fields
    '        Sql = "SELECT * FROM Customer WHERE "
        End If
    
        If (OpenRecordset(rsSearch, SQL, dbOpenSnapshot)) Then
            If (rsSearch.EOF = True) Then
    '            Call ClearStatus
                vFoundC = False
            Else
                vFoundC = True
                vUid = Val(rsSearch!Uid & "")
                vSalutation = Trim$(rsSearch!Salutation & "")
                vName = Trim$(rsSearch!Name & "")
                vInitials = Trim$(rsSearch!Initials & "")
                vStreet1 = Trim$(rsSearch!Street1 & "")
                vStreet2 = Trim$(rsSearch!Street2 & "")
                vTown = Trim$(rsSearch!Town & "")
                vCounty = Trim$(rsSearch!County & "")
                vPostCode = Trim$(rsSearch!Postcode & "")
                vHometelephone = Trim$(rsSearch!Hometelephone & "")
                vWorktelephone = Trim$(rsSearch!Worktelephone & "")
                vMobiletelephone = Trim$(rsSearch!Mobiletelephone & "")
                vWorktelephonextension = Trim$(rsSearch!Worktelephonextension & "")
                vCreditname = Trim$(rsSearch!Creditname & "")
                vIssueNumber = Trim$(rsSearch!IssueNumber & "")
                If (IsDate(rsSearch!Expirydate)) Then
                    vExpirydate = rsSearch!Expirydate & ""
                End If
                If (IsDate(rsSearch!Startdate)) Then
                    vStartdate = rsSearch!Startdate & ""
                End If
                vCreditnumber = rsSearch!Creditnumber & ""
                vEmail = Trim$(rsSearch!Email & "")
                
                vDeliveryName = Trim$(rsSearch!DeliveryName & "")
                vDeliveryStreet1 = Trim$(rsSearch!DeliveryStreet1 & "")
                vDeliveryStreet2 = Trim$(rsSearch!DeliveryStreet2 & "")
                vDeliveryTown = Trim$(rsSearch!DeliveryTown & "")
                vDeliveryCounty = Trim$(rsSearch!DeliveryCounty & "")
                vDeliveryPostcode = Trim$(rsSearch!DeliveryPostcode & "")
                ' Sub-class resync
                
                ' read customercomments
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
    If (ErrorCheck(Error$)) Then
        Resume
    End If
    ReadRecord = False
End Function

'' **********************************************************************
'' Update Record
Public Function WriteRecord() As Boolean
    Dim SQL As String

        WriteRecord = True
    SQL = "UPDATE Customer SET "
    SQL = SQL & " Salutation=" & Chr(34) & vSalutation & Chr(34)
    If (vNameC = True) Then
        SQL = SQL & " ,Name=" & Chr(34) & vName & Chr(34)
    End If
    If (vInitialsC = True) Then
        SQL = SQL & " ,Initials=" & Chr(34) & vInitials & Chr(34)
    End If
    If (vStreet1C = True) Then
        SQL = SQL & " ,Street1=" & Chr(34) & vStreet1 & Chr(34)
    End If
    If (vStreet2C = True) Then
        SQL = SQL & " ,Street2=" & Chr(34) & vStreet2 & Chr(34)
    End If
    If (vTownC = True) Then
        SQL = SQL & " ,Town=" & Chr(34) & vTown & Chr(34)
    End If
    If (vCountyC = True) Then
        SQL = SQL & " ,County=" & Chr(34) & vCounty & Chr(34)
    End If
    If (vPostcodeC = True) Then
        SQL = SQL & " ,Postcode=" & Chr(34) & vPostCode & Chr(34)
    End If
    If (vHometelephoneC = True) Then
        SQL = SQL & " ,Hometelephone=" & Chr(34) & vHometelephone & Chr(34)
    End If
    If (vWorktelephoneC = True) Then
        SQL = SQL & " ,Worktelephone=" & Chr(34) & vWorktelephone & Chr(34)
    End If
    If (vMobiletelephoneC = True) Then
        SQL = SQL & " ,Mobiletelephone=" & Chr(34) & vMobiletelephone & Chr(34)
    End If
    If (vWorktelephonextensionC = True) Then
        SQL = SQL & " ,Worktelephonextension=" & Chr(34) & vWorktelephonextension & Chr(34)
    End If
    If (vCreditnameC = True) Then
        SQL = SQL & " ,Creditname=" & Chr(34) & vCreditname & Chr(34)
    End If
    If (vExpirydateC = True) Then
        SQL = SQL & " ,Expirydate=" & Chr(34) & vExpirydate & Chr(34)
    End If
    If (vStartdateC = True) Then
        SQL = SQL & " ,Startdate=" & Chr(34) & vStartdate & Chr(34)
    End If
    
    If (vCreditnumberC = True) Then
        SQL = SQL & " ,Creditnumber=" & Chr(34) & vCreditnumber & Chr(34)
    End If
    If (vIssueNumberC = True) Then
        SQL = SQL & " ,issuenumber=" & Chr(34) & vIssueNumber & Chr(34)
    End If
    If (vEmailC = True) Then
        SQL = SQL & " ,Email=" & Chr(34) & vEmail & Chr(34)
    End If

    If (vDeliveryNameC = True) Then
        SQL = SQL & " ,DeliveryName=" & Chr(34) & vDeliveryName & Chr(34)
    End If
    If (vDeliveryStreet1C = True) Then
        SQL = SQL & " ,DeliveryStreet1=" & Chr(34) & vDeliveryStreet1 & Chr(34)
    End If
    If (vDeliveryStreet2C = True) Then
        SQL = SQL & " ,DeliveryStreet2=" & Chr(34) & vDeliveryStreet2 & Chr(34)
    End If
    If (vDeliveryTownC = True) Then
        SQL = SQL & " ,DeliveryTown=" & Chr(34) & vDeliveryTown & Chr(34)
    End If
    If (vDeliveryCountyC = True) Then
        SQL = SQL & " ,DeliveryCounty=" & Chr(34) & vDeliveryCounty & Chr(34)
    End If
    If (vDeliveryPostcodeC = True) Then
        SQL = SQL & " ,DeliveryPostcode=" & Chr(34) & vDeliveryPostcode & Chr(34)
    End If

    SQL = SQL & " WHERE Uid =" & vUid
    
'    WriteRecord = SyncCustomerContact() ' get feed back FROM subclass update
    
    If (Execute(SQL, True) = 1) Then
    ' this should return the result FROM updating the database
    Else
        'error
        WriteRecord = False
    End If
End Function

'' **********************************************************************
'' Create Record

Public Function CreateRecord() As Boolean
'    Dim Sql As String

    Dim rstemp As Recordset
    
        CreateRecord = True
        
    If (OpenRecordset(rstemp, "Customer", dbOpenTable)) Then
        Call rstemp.AddNew
        vUid = rstemp!Uid
        
        If (vSalutationC = True) Then
            rstemp!Salutation = vSalutation
        End If
        If (vNameC = True) Then
            rstemp!Name = vName
        End If
        If (vInitialsC = True) Then
            rstemp!Initials = vInitials
        End If
        If (vStreet1C = True) Then
            rstemp!Street1 = vStreet1
        End If
        If (vStreet2C = True) Then
            rstemp!Street2 = vStreet2
        End If
        If (vTownC = True) Then
            rstemp!Town = vTown
        End If
        If (vCountyC = True) Then
            rstemp!County = vCounty
        End If
        If (vPostcodeC = True) Then
            rstemp!Postcode = vPostCode
        End If
        If (vHometelephoneC = True) Then
            rstemp!Hometelephone = vHometelephone
        End If
        If (vWorktelephoneC = True) Then
            rstemp!Worktelephone = vWorktelephone
        End If
        If (vMobiletelephoneC = True) Then
            rstemp!Mobiletelephone = vMobiletelephone
        End If
        If (vWorktelephonextensionC = True) Then
            rstemp!Worktelephonextension = vWorktelephonextension
        End If
        If (vCreditnameC = True) Then
            rstemp!Creditname = vCreditname
        End If
        If (vExpirydateC = True) Then
            rstemp!Expirydate = vExpirydate
        End If
        If (vIssueNumberC = True) Then
            rstemp!IssueNumber = vIssueNumber
        End If
        
        If (vStartdateC = True) Then
            rstemp!Startdate = vStartdate
        End If
        If (vCreditnumberC = True) Then
            rstemp!Creditnumber = vCreditnumber
        End If
        If (vEmailC = True) Then
            rstemp!Email = vEmail
        End If
        
        If (vDeliveryNameC = True) Then
            rstemp!DeliveryName = vDeliveryName
        End If
        If (vDeliveryStreet1C = True) Then
            rstemp!DeliveryStreet1 = vDeliveryStreet1
        End If
        If (vDeliveryStreet2C = True) Then
            rstemp!DeliveryStreet2 = vDeliveryStreet2
        End If
        If (vDeliveryTownC = True) Then
            rstemp!DeliveryTown = vDeliveryTown
        End If
        If (vDeliveryCountyC = True) Then
            rstemp!DeliveryCounty = vDeliveryCounty
        End If
        If (vDeliveryPostcodeC = True) Then
            rstemp!DeliveryPostcode = vDeliveryPostcode
        End If
        
        Call rstemp.Update
    '    CreateRecord = True
        vFoundC = True
        '' Sync CustomerContact
        CreateRecord = True
    Else
        vFoundC = False
        CreateRecord = False
    End If
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
End Function

'' *********************************************************************
'' Delete Record
Public Function DeleteRecord() As Boolean
    Dim SQL As String

    DeleteRecord = True
    SQL = "DELETE * FROM Customer WHERE Uid=" & vUid

    If (Execute(SQL, True) = 1) Then
        ' delete any CustomerComments attached to customer
        SQL = "DELETE * FROM CustmonerComments WHERE Customerid=" & vUid
    
        Call Execute(SQL, True)
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
    Call ClearStatus
        vUid = Val(vrsSearch!Uid & "")
        vSalutation = vrsSearch!Salutation & ""
        vName = vrsSearch!Name & ""
        vInitials = vrsSearch!Initials & ""
        vStreet1 = vrsSearch!Street1 & ""
        vStreet2 = vrsSearch!Street2 & ""
        vTown = vrsSearch!Town & ""
        vCounty = vrsSearch!County & ""
        vPostCode = vrsSearch!Postcode & ""
        vHometelephone = vrsSearch!Hometelephone & ""
        vWorktelephone = vrsSearch!Worktelephone & ""
        vMobiletelephone = vrsSearch!Mobiletelephone & ""
        vWorktelephonextension = vrsSearch!Worktelephonextension & ""
        vCreditname = vrsSearch!Creditname & ""
        If (IsDate(vrsSearch!Expirydate)) Then
            vExpirydate = vrsSearch!Expirydate & ""
        End If
        If (IsDate(vrsSearch!Startdate)) Then
            vStartdate = vrsSearch!Startdate & ""
        End If
        vCreditnumber = vrsSearch!Creditnumber & ""
        vIssueNumber = vrsSearch!IssueNumber & ""
        vEmail = vrsSearch!Email & ""

        
        vDeliveryName = vrsSearch!DeliveryName & ""
        vDeliveryStreet1 = vrsSearch!DeliveryStreet1 & ""
        vDeliveryStreet2 = vrsSearch!DeliveryStreet2 & ""
        vDeliveryTown = vrsSearch!DeliveryTown & ""
        vDeliveryCounty = vrsSearch!DeliveryCounty & ""
        vDeliveryPostcode = vrsSearch!DeliveryPostcode & ""
        
        vFoundC = True
    ' Set appliance number in appliance file here -
'    If (vUidC = True) Then
'    End If

    ' Set sub-class resync -

    ' Move to next record
    vrsSearch.MoveNext
    vRecordNumber = vRecordNumber + 1
    Exit Function
GeneralError:
    If (ErrorCheck(Error$)) Then
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
    Dim SQL As String
    Dim AddAnd As Boolean
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    ' to support mutiple matches, see
    vSearchby = pSearchType
    
    ' returns number of matches, -1 error
    SQL = "SELECT * FROM customer WHERE "
    AddAnd = False
    
    If (BAnd(pSearchType, ByPostcode)) Then
        If (AddAnd = True) Then
            SQL = SQL & " AND "
        End If
        SQL = SQL & " Postcode LIKE " & Chr$(34) & vPostCode & cWildCard & Chr$(34)
        AddAnd = True
    End If
    If (BAnd(pSearchType, BySurname)) Then
        If (AddAnd = True) Then
            SQL = SQL & " AND "
        End If
        SQL = SQL & "name LIKE " & Chr$(34) & vName & cWildCard & Chr$(34)
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByHomeTelphoneNumber)) Then
        If (AddAnd = True) Then
            SQL = SQL & " AND "
        End If
        SQL = SQL & "Hometelephone LIKE " & Chr$(34) & vHometelephone & cWildCard & Chr$(34)
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByStreet1)) Then
        If (AddAnd = True) Then
            SQL = SQL & " AND "
        End If
        SQL = SQL & " street1 LIKE " & Chr$(34) & vStreet1 & cWildCard & Chr$(34)
        AddAnd = True
    End If
    If (BAnd(pSearchType, ByUid)) Then
        If (AddAnd = True) Then
            SQL = SQL & " AND "
        End If
        SQL = SQL & " uid=" & vUid
        AddAnd = True
    End If
    
    Select Case pOrderBy
        Case OrderSurname
            SQL = SQL & " ORDER BY name"
        Case OrderPostcode
            SQL = SQL & "order by postcode"
        Case OrderHomeTelphoneNumber
            SQL = SQL & "ORDER BY hometelephone"
        Case OrderStreet1
            SQL = SQL & "ORDER BY street1"
        Case OrderNone
'            Sql = Sql
    End Select
    
    If (OpenRecordset(vrsSearch, SQL, dbOpenSnapshot)) Then
        ' Read first record, get numRecords, init position
        vRecordNumber = 1
        If (vrsSearch.EOF = False) Then
            vFoundC = True
            If (vSuppressRecordCount = False) Then
                Call vrsSearch.MoveLast
                Call vrsSearch.MoveFirst
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
    vSalutationC = False
    vSalutation = ""
    If (vSearchby <> BySurname) Then
        vNameC = False
        vName = ""
    End If
    vInitialsC = False
    vInitials = ""
    vStreet1C = False
    vStreet1 = ""
    vStreet2C = False
    vStreet2 = ""
    vTownC = False
    vTown = ""
    vCountyC = False
    vCounty = ""
    If (vSearchby <> ByPostcode) Then
        vPostcodeC = False
        vPostCode = ""
    End If
    If (vSearchby <> ByHomeTelphoneNumber) Then
        vHometelephoneC = False
        vHometelephone = ""
    End If
    vWorktelephoneC = False
    vWorktelephone = ""
    vMobiletelephoneC = False
    vMobiletelephone = ""
    vWorktelephonextensionC = False
    vWorktelephonextension = ""
    vCreditnameC = False
    vCreditname = ""
    vExpirydateC = False
    vExpirydate = 0
    vStartdateC = False
    vStartdate = 0
    vCreditnumberC = False
    vCreditnumber = ""
    vIssueNumberC = False
    vIssueNumber = ""
'    vEastingsC = False
'    vEastings = 0
'    vNorthingsC = False
'    vNorthings = 0
'    vDirectionsC = False
'    vDirections = ""
    vEmailC = False
    vEmail = ""
    ' Set record to not found
    vFoundC = False
End Function

''
Public Function SetAppliance(ByRef pApplianceClass As ClassAppliance) As Boolean
    ' Set sibling appliance class, so when a customer has been
    ' found, their appliance can be found
    
    ' returns true
    vApplianceC = True
    Set vAppliance = pApplianceClass
'    vContact.ApplianceClass = pApplianceClass
End Function

''
Public Function NewRecord()
    ' resets all data, so ready for new call (including children)
    Call ClearStatus
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
