VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassProduct"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''***********************************************************************
'' Class file for accessing table - Product
''
'' Code by Dale Pitman

Public Enum ProductSearchENUM
    byName = 1
    byDescription = 2
End Enum

'' String field size definitions
'' %^01
'' %^02

'' Fields
'' %^03
 Private vUid As Long
 Private vEquivalentid As Long
 Private vReplacementid As Long
 Private vName As String
 Private vDescription As String
 Private vNetprice As Currency
 Private vVatpercent As Currency
 Private vNetvalue As Currency
 Private vPriority As Long
 Private vInactive As String 'Logical type
'' %^04

'' Track if varibles are updated, so only changed ones are
'' written on a update
'' %^05
 Private vUidC As Boolean
 Private vEquivalentidC As Boolean
 Private vReplacementidC As Boolean
 Private vNameC As Boolean
 Private vDescriptionC As Boolean
 Private vNetpriceC As Boolean
 Private vVatpercentC As Boolean
 Private vNetvalueC As Boolean
 Private vPriorityC As Boolean
 Private vInactiveC As Boolean
'' %^06

 Private vReplacementName As String
 
'' Track if record has been read
Private vFoundC As Boolean

'' Used for multiple record selection
Private vrsSearch As Recordset          ' Multi-record selection storage
Private vRecordNumber As Long           ' Currently selected record in multiselect
Private vRecordCount As Long            ' Number of records found in a multi-record select

Private vStockClass As ClassStock
Private vPricingClass As ClassPricing
Private vStockLogClass As ClassStockLog
Private vManufacturerClass As ClassManufacturer
Private vSupplierClass As ClassSupplier

''*************************************************************************

'' Reset Conditions
Private Sub ClearStatus()
'' %^07
    vUidC = False
    vUid = 0
    vEquivalentidC = False
    vEquivalentid = 0
    vReplacementidC = False
    vReplacementid = 0
    vReplacementName = ""
    vNameC = False
    vName = ""
    vDescriptionC = False
    vDescription = ""
    vNetpriceC = False
    vNetprice = 0
    vVatpercentC = False
    vVatpercent = 0
    vNetvalueC = False
    vNetvalue = 0
    vPriorityC = False
    vPriority = 0
    vInactiveC = False
    vInactive = 0
'' %^08
    Call vStockClass.ClearDetails
    Call vPricingClass.ClearDetails
    Call vStockLogClass.ClearDetails
    Call vManufacturerClass.ClearDetails
    Call vSupplierClass.ClearDetails
    ' Set record to not found
    vFoundC = False
End Sub

Private Sub Class_Initialize()
    Set vStockClass = New ClassStock
    Set vPricingClass = New ClassPricing
    Set vStockLogClass = New ClassStockLog
    Set vManufacturerClass = New ClassManufacturer
    Set vSupplierClass = New ClassSupplier
    Call ClearStatus
    ' Subclass initialisation go's here
End Sub

''*************************************************************************
'' Update Property Procedures

Public Property Get Stock() As ClassStock
    Stock = vStockClass
End Property

Public Property Get Pricing() As ClassPricing
    Pricing = vPricingClass
End Property

Public Property Get StockLog() As ClassStockLog
    StockLog = vStockLogClass
End Property

Public Property Get Manufacturer() As ClassManufacturer
    Manufacturer = vManufacturerClass
End Property

Public Property Get Supplier() As ClassSupplier
    Supplier = vSupplierClass
End Property


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

Public Property Get Equivalentid() As Long
    Equivalentid = vEquivalentid
End Property

Public Property Let Equivalentid(ByVal NewValue As Long)
    vEquivalentid = NewValue
    vEquivalentidC = True
End Property

Public Property Get Replacementid() As Long
    Replacementid = vReplacementid
End Property

Public Property Let Replacementid(ByVal NewValue As Long)
    vReplacementid = NewValue
    vReplacementidC = True
End Property

Public Property Get ReplacementName() As String
    Dim rstemp As Recordset
    If (vReplacementName = "") Then
        ' load replacement
        If (OpenRecordset(rstemp, "SELECT * FROM Product p WHERE p.UID=" & vReplacementid, dbOpenSnapshot)) Then
            If (rstemp.EOF = False) Then
                vReplacementName = rstemp!Name & ""
            End If
        End If
    End If
    ReplacementName = vReplacementName
End Property


Public Property Get Name() As String
    Name = vName
End Property

Public Property Let Name_P(ByVal NewValue As String)
    vName = UCase$(Trim$(NewValue))
    vNameC = True
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

Public Property Get Netprice() As Currency
    Netprice = vNetprice
End Property

Public Property Let Netprice(ByVal NewValue As Currency)
    vNetprice = NewValue
    vNetpriceC = True
End Property

Public Property Get Vatpercent() As Currency
    Vatpercent = vVatpercent
End Property

Public Property Let Vatpercent(ByVal NewValue As Currency)
    vVatpercent = NewValue
    vVatpercentC = True
End Property

Public Property Get Netvalue() As Currency
    Netvalue = vNetvalue
End Property

Public Property Let Netvalue(ByVal NewValue As Currency)
    vNetvalue = NewValue
    vNetvalueC = True
End Property

Public Property Get Priority() As Long
    Priority = vPriority
End Property

Public Property Let Priority(ByVal NewValue As Long)
    vPriority = NewValue
    vPriorityC = True
End Property

Public Property Get Inactive() As String
    Inactive = vInactive
End Property

Public Property Let Inactive(ByVal NewValue As String)
    vInactive = NewValue
    vInactiveC = True
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
        Sql = "SELECT * FROM Product WHERE Uid=" & vUid
    Else  ' otherwise use specified fields
        Sql = "SELECT * FROM Product WHERE "
    End If

    If (OpenRecordset(rsSearch, Sql, dbOpenSnapshot)) Then
        If (rsSearch.EOF = True) Then
'            Call ClearStatus
            vFoundC = False
        Else
            vFoundC = True
'' %^11
        vUid = Val(rsSearch!Uid & "")
        vEquivalentid = Val(rsSearch!Equivalentid & "")
        vReplacementid = Val(rsSearch!Replacementid & "")
        vName = rsSearch!Name & ""
        vDescription = rsSearch!Description & ""
        vNetprice = Val(rsSearch!Netprice & "")
        vVatpercent = Val(rsSearch!Vatpercent & "")
        vNetvalue = Val(rsSearch!Netvalue & "")
        vPriority = Val(rsSearch!Priority & "")
        vInactive = Val(rsSearch!Inactive & "")
'' %^12
            ' Sub-class resync
            vStockClass.Productid = vUid
            vPricingClass.Productid = vUid
'            vStockLogClass.Productid = vUid
'            vManufacturerClass.Productid = vUid
'            vSupplierClass.Productid = vUid
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
    Sql = "UPDATE Product SET "
'' %^13
    If (vEquivalentidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Equivalentid=" & vEquivalentid
    End If
    If (vReplacementidC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Replacementid=" & vReplacementid
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
    If (vNetpriceC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Netprice=" & vNetprice
    End If
    If (vVatpercentC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Vatpercent=" & vVatpercent
    End If
    If (vNetvalueC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Netvalue=" & vNetvalue
    End If
    If (vPriorityC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Priority=" & vPriority
    End If
    If (vInactiveC = True) Then
        If (AddComma = True) Then
            Sql = Sql & ","
        End If
        AddComma = True
        Sql = Sql & " Inactive=" & vInactive
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
    Sql = "INSERT INTO Product ("
'' %^15
    Sql = Sql & "Uid"
    If (vEquivalentidC = True) Then
        Sql = Sql & ",Equivalentid"
    End If
    If (vReplacementidC = True) Then
        Sql = Sql & ",Replacementid"
    End If
    If (vNameC = True) Then
        Sql = Sql & ",Name"
    End If
    If (vDescriptionC = True) Then
        Sql = Sql & ",Description"
    End If
    If (vNetpriceC = True) Then
        Sql = Sql & ",Netprice"
    End If
    If (vVatpercentC = True) Then
        Sql = Sql & ",Vatpercent"
    End If
    If (vNetvalueC = True) Then
        Sql = Sql & ",Netvalue"
    End If
    If (vPriorityC = True) Then
        Sql = Sql & ",Priority"
    End If
    If (vInactiveC = True) Then
        Sql = Sql & ",Inactive"
    End If
    Sql = Sql & ") VALUES ("
    Sql = Sql & "," & Chr(34) & vUid & Chr(34)
    If (vEquivalentidC = True) Then
        Sql = Sql & "," & vEquivalentid
    End If
    If (vReplacementidC = True) Then
        Sql = Sql & "," & vReplacementid
    End If
    If (vNameC = True) Then
        Sql = Sql & "," & Chr(34) & vName & Chr(34)
    End If
    If (vDescriptionC = True) Then
        Sql = Sql & "," & Chr(34) & vDescription & Chr(34)
    End If
    If (vNetpriceC = True) Then
        Sql = Sql & "," & vNetprice
    End If
    If (vVatpercentC = True) Then
        Sql = Sql & "," & vVatpercent
    End If
    If (vNetvalueC = True) Then
        Sql = Sql & "," & vNetvalue
    End If
    If (vPriorityC = True) Then
        Sql = Sql & "," & vPriority
    End If
    If (vInactiveC = True) Then
        Sql = Sql & "," & vInactive
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

    Sql = "DELETE * FROM Product where Uid=" & vUid

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


'' Copy data from recordset to local storage
Private Sub LoadFromSearch()
'    Call ClearStatus
'' %^19
        vUid = Val(vrsSearch!Uid & "")
        vEquivalentid = Val(vrsSearch!Equivalentid & "")
        vReplacementid = Val(vrsSearch!Replacementid & "")
        vName = vrsSearch!Name & ""
        vDescription = vrsSearch!Description & ""
        vNetprice = Val(vrsSearch!Netprice & "")
        vVatpercent = Val(vrsSearch!Vatpercent & "")
        vNetvalue = Val(vrsSearch!Netvalue & "")
        vPriority = Val(vrsSearch!Priority & "")
        vInactive = Val(vrsSearch!Inactive & "")
'' %^20

        vFoundC = True
    ' Set sub-class resync -
    vStockClass.Productid = vUid
    vPricingClass.Productid = vUid
'    vStockLogClass.Productid = vUid
'    vManufacturerClass.Productid = vUid
'    vSupplierClass.Productid = vUid

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


Public Function Search(pSearchType As ProductSearchENUM) As Long
    Dim Sql As String
    Dim AddAnd As Boolean
    
    'if searchtype is specified then search on specified field
    ' if not, check field set flags, and do a search on set fields
    
    AddAnd = False
    Sql = "SELECT p.* FROM Product p WHERE "
    If (BAnd(pSearchType, ProductSearchENUM.byName)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " [name]=" & Chr$(34) & vName & Chr$(34)
        AddAnd = True
    End If

    If (BAnd(pSearchType, ProductSearchENUM.byDescription)) Then
        If (AddAnd = True) Then
            Sql = Sql & " AND "
        End If
        Sql = Sql & " [Description]=" & Chr$(34) & vDescription & Chr$(34)
        AddAnd = True
    End If


'    If (BAnd(pSearchType, n)) Then
'        sql = sql & " ORDER BY c.UID"
'    Else
'        sql = sql & " " & vOrderBy
'    End If
    
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

