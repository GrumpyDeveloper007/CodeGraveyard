VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassPricing"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Pricing
''
'' Code by Dale Pitman

Public Enum PriceTypeENUM
    Value = 1
    Net = 2
End Enum

Public Enum PricingSearchENUM
    byProductID = 1
    byTypeP = 2
    byScale = 3
    byStartDate = 4
End Enum
'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vProductid As Long
 Private vSupplierid As Long
 Private vCost As Currency
 Private vVatpercent As Currency
 Private vStartdate As Date
 Private vTypep As PriceTypeENUM
 Private vScale As Long
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vProductidC As Boolean
 Private vSupplieridC As Boolean
 Private vCostC As Boolean
 Private vVatpercentC As Boolean
 Private vStartdateC As Boolean
 Private vTypepC As Boolean
 Private vScaleC As Boolean
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
    vProductidC = False
    vProductid = 0
    vSupplieridC = False
    vSupplierid = 0
    vCostC = False
    vCost = 0
    vVatpercentC = False
    vVatpercent = 0
    vStartdateC = False
    vStartdate = 0
    vTypepC = False
    vTypep = 0
    vScaleC = False
    vScale = 0
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

Public Property Get Productid() As Long
    Productid = vProductid
End Property

Public Property Let Productid(ByVal NewValue As Long)
    vProductid = NewValue
    vProductidC = True
End Property

Public Property Get Supplierid() As Long
    Supplierid = vSupplierid
End Property

Public Property Let Supplierid(ByVal NewValue As Long)
    vSupplierid = NewValue
    vSupplieridC = True
End Property

Public Property Get Cost() As Currency
    Cost = vCost
End Property

Public Property Let Cost(ByVal NewValue As Currency)
    vCost = NewValue
    vCostC = True
End Property

Public Property Get Vatpercent() As Currency
    Vatpercent = vVatpercent
End Property

Public Property Let Vatpercent(ByVal NewValue As Currency)
    vVatpercent = NewValue
    vVatpercentC = True
End Property

Public Property Get Startdate() As Date
    Startdate = vStartdate
End Property

Public Property Let Startdate(ByVal NewValue As Date)
    vStartdate = NewValue
    vStartdateC = True
End Property

Public Property Get Typep() As PriceTypeENUM
    Typep = vTypep
End Property

Public Property Let Typep(ByVal NewValue As PriceTypeENUM)
    vTypep = NewValue
    vTypepC = True
End Property

Public Property Get Scale1() As Long
    Scale1 = vScale
End Property

Public Property Let Scale1(ByVal NewValue As Long)
    vScale = NewValue
    vScaleC = True
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
        Sql = "SELECT * FROM Pricing WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM Pricing WHERE "
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vProductid = Val(rsSearch!Productid & "")
        vSupplierid = Val(rsSearch!Supplierid & "")
        vCost = Val(rsSearch!Cost & "")
        vVatpercent = Val(rsSearch!Vatpercent & "")
        If (IsDate(rsSearch!Startdate)) Then
            vStartdate = rsSearch!Startdate & ""
        End If
        vTypep = Val(rsSearch!Typep & "")
        vScale = Val(rsSearch!Scale & "")
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
    Sql = "UPDATE Pricing SET "
'' %^13
    If (vProductidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Productid=" & vProductid
    End If
    If (vSupplieridC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Supplierid=" & vSupplierid
    End If
    If (vCostC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Cost=" & vCost
    End If
    If (vVatpercentC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Vatpercent=" & vVatpercent
    End If
    If (vStartdateC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Startdate=" & vStartdate
    End If
    If (vTypepC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Typep=" & vTypep
    End If
    If (vScaleC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Scale=" & vScale
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
    Sql = "INSERT INTO Pricing ("
'' %^15
    Sql = Sql & "Uid"
    If (vProductidC = True) Then
        Sql = Sql & ",Productid"
    End If
    If (vSupplieridC = True) Then
        Sql = Sql & ",Supplierid"
    End If
    If (vCostC = True) Then
        Sql = Sql & ",Cost"
    End If
    If (vVatpercentC = True) Then
        Sql = Sql & ",Vatpercent"
    End If
    If (vStartdateC = True) Then
        Sql = Sql & ",Startdate"
    End If
    If (vTypepC = True) Then
        Sql = Sql & ",Typep"
    End If
    If (vScaleC = True) Then
        Sql = Sql & ",Scale"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & vUid
    If (vProductidC = True) Then
        Sql = Sql & "," & vProductid
    End If
    If (vSupplieridC = True) Then
        Sql = Sql & "," & vSupplierid
    End If
    If (vCostC = True) Then
        Sql = Sql & "," & vCost
    End If
    If (vVatpercentC = True) Then
        Sql = Sql & "," & vVatpercent
    End If
    If (vStartdateC = True) Then
        Sql = Sql & "," & vStartdate
    End If
    If (vTypepC = True) Then
        Sql = Sql & "," & vTypep
    End If
    If (vScaleC = True) Then
        Sql = Sql & "," & vScale
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

    Sql = "DELETE * FROM Pricing where Uid=" & vUid

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
    If (vProductidC = False) Then
        vProductid = 0
    End If
    If (vSupplieridC = False) Then
        vSupplierid = 0
    End If
    If (vCostC = False) Then
        vCost = 0
    End If
    If (vVatpercentC = False) Then
        vVatpercent = 0
    End If
    If (vStartdateC = False) Then
        vStartdate = 0
    End If
    If (vTypepC = False) Then
        vTypep = 0
    End If
    If (vScaleC = False) Then
        vScale = 0
    End If
'' %^18
End Sub

'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vProductid = Val(vrsSearch!Productid & "")
        vSupplierid = Val(vrsSearch!Supplierid & "")
        vCost = Val(vrsSearch!Cost & "")
        vVatpercent = Val(vrsSearch!Vatpercent & "")
        If (IsDate(vrsSearch!Startdate)) Then
            vStartdate = vrsSearch!Startdate & ""
        End If
        vTypep = Val(vrsSearch!Typep & "")
        vScale = Val(vrsSearch!Scale & "")
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


'ProductID=" & vProductid & " AND typep=" & Typep & " AND vstartdate<" & cdatechar & Format(vStartdate, "mm/dd/yyyy") & cdatechar & " AND scale<

Public Function Search(pSearchType As PricingSearchENUM) As Long
    Dim Sql As String
    Dim AddAnd As Boolean
    
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    AddAnd = False
    Sql = "SELECT pr.* FROM Pricing pr WHERE "
    If (BAnd(pSearchType, PricingSearchENUM.byProductID)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " Productid=" & vProductid
        AddAnd = True
    End If

    If (BAnd(pSearchType, PricingSearchENUM.byScale)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " scale<" & vScale
        AddAnd = True
    End If

    If (BAnd(pSearchType, PricingSearchENUM.byStartDate)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " startdate<=" & cDateChar & Format(vStartdate, "mm/dd/yyyy") & cDateChar
        AddAnd = True
    End If

    If (BAnd(pSearchType, PricingSearchENUM.byTypeP)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " typep<" & vTypep
        AddAnd = True
    End If

    If (BAnd(pSearchType, PricingSearchENUM.byScale)) Then
        If (BAnd(pSearchType, PricingSearchENUM.byStartDate)) Then
            Sql = Sql & " ORDER BY pr.scale DESC,pr.startdate DESC"
        Else
            Sql = Sql & " ORDER BY pr.scale DESC"
        End If
    Else
    End If
    
    If (OpenRecordset(vrsSearch, Sql, dbOpenSnapshot)) Then
        ' Read first record, get numRecords, init position
        vRecordNumber = 1
        If (vrsSearch.EOF = False) Then
            vFoundC = True
            Call MoveLastFirst(vrsSearch)
            vRecordCount = vrsSearch.RecordCount
            Search = vRecordCount
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


