Attribute VB_Name = "StockControl"
Option Explicit
''*************************************************************************
''
''
''
Private Const cInvalidNumber As Long = -32767


Private Enum ContextENUM
    ReceieveOrder = 1
    MoveLocationToLocation = 2
    MoveFromLocation = 3
End Enum


Private Type SupplierType
    Uid As Long
    Proirity As Long
    Code As String
    Name As String
    Description As String
    Street1 As String
    Street2 As String
    Town As String
    County As String
    Country As String
    Postcode As String
    Phonenumber As String
    Inactive As String 'Logical type
End Type

Private vOrderClass As New ClassOrder
Private vLocationClass As New ClassLocation
Private vProductClass As New ClassProduct
Private vStockClassSource As New ClassStock
Private vStockClass As New ClassStock
Private vStockLogClass As New ClassStockLog

Private vSupplier() As SupplierType
Private vNumSupplier As Long

Private vManufacturer() As SupplierType
Private vNumManufacturer As Long


Private Sub LoadStockLogClass()
    vStockLogClass.Userid = 0
    vStockLogClass.Transferdate = Now
End Sub

'' Modifies stock level, logs transaction
Public Function MoveProductFromOrderToLocation(pProductID As Long, pQty As Long, pOrderLineID As Long, pLocationID As Long) As Boolean
    vOrderClass.OrderLineClass.Uid = pOrderLineID
    MoveProductFromOrderToLocation = False
    If (vOrderClass.OrderLineClass.ReadRecord()) Then
        vOrderClass.OrderLineClass.Qtyreceived = vOrderClass.OrderLineClass.Qtyreceived + pQty
        vStockClass.Locationid = pLocationID
        vStockClass.Productid = pProductID
        If (vStockClass.ReadRecord()) Then
            vStockClass.Qty = vStockClass.Qty + pQty
        
            Call LoadStockLogClass
            vStockLogClass.Sourceid = pOrderLineID
            vStockLogClass.Sourcetypeid = Order
            vStockLogClass.Destinationid = pLocationID
            vStockLogClass.Destinationtypeid = Location
            vStockLogClass.Qty = pQty
            vStockLogClass.Contextid = ContextENUM.ReceieveOrder
            If (vOrderClass.OrderLineClass.WriteRecord()) Then
                Call vStockClass.WriteRecord
                Call vStockLogClass.CreateRecord
                MoveProductFromOrderToLocation = True
            Else
                'error
            End If
        Else
            'error
        End If
    Else
        'error
    End If
End Function

''
Public Function MoveProductFromLocationToLocation(pProductID As Long, pQty As Long, pOrderLineID As Long, pSourceLocationID As Long, pDestinationLocationID As Long) As Boolean
    MoveProductFromLocationToLocation = False
    
    vStockClassSource.Locationid = pSourceLocationID
    vStockClassSource.Productid = pProductID
    If (vStockClassSource.ReadRecord()) Then
        vStockClassSource.Qty = vStockClassSource.Qty - pQty
        Call vStockClassSource.WriteRecord
        
        vStockClass.Locationid = pDestinationLocationID
        vStockClass.Productid = pProductID
        If (vStockClass.ReadRecord()) Then
            vStockClass.Qty = vStockClass.Qty + pQty
        Else
            vStockClass.Locationid = pDestinationLocationID
            vStockClass.Productid = pProductID
            vStockClass.Qty = pQty
        End If
        
        Call LoadStockLogClass
        vStockLogClass.Sourceid = pSourceLocationID
        vStockLogClass.Sourcetypeid = Location
        vStockLogClass.Destinationid = pDestinationLocationID
        vStockLogClass.Destinationtypeid = Location
        vStockLogClass.Qty = pQty
        vStockLogClass.Contextid = ContextENUM.MoveLocationToLocation
        
        Call vStockClass.SyncRecord
        Call vStockLogClass.CreateRecord
        MoveProductFromLocationToLocation = True
    Else
        'error
    End If
End Function

'' Modifies stock level, logs transaction
Public Function MoveProductFromLocation(pProductID As Long, pQty As Long, pLocationID As Long) As Boolean
    MoveProductFromLocation = False
        
    vStockClass.Locationid = pLocationID
    vStockClass.Productid = pProductID
    If (vStockClass.ReadRecord()) Then
        vStockClass.Qty = vStockClass.Qty - pQty
    
        Call LoadStockLogClass
        vStockLogClass.Sourceid = pLocationID
        vStockLogClass.Sourcetypeid = Location
        vStockLogClass.Destinationid = cInvalidNumber
        vStockLogClass.Destinationtypeid = NA
        vStockLogClass.Qty = pQty
        vStockLogClass.Contextid = ContextENUM.MoveFromLocation
        
        Call vStockClass.WriteRecord
        Call vStockLogClass.CreateRecord
        MoveProductFromLocation = True
    Else
        'error
    End If
End Function

Private Sub LoadComboBox(ByRef pComboBox As ComboBox, pName As String, ByRef pArray() As SupplierType, pMaxValue As Long, pShowAll As Boolean)
    Dim i As Long
    If (pShowAll = True) Then
        Call pComboBox.AddItem("N/A - All " & pName)
        pComboBox.ItemData(pComboBox.ListCount - 1) = 0
    End If
    
    For i = 0 To pMaxValue
        Call pComboBox.AddItem(pArray(i).Code & " - " & pArray(i).Name)
        pComboBox.ItemData(pComboBox.ListCount - 1) = pArray(i).Uid
    Next
    If (pComboBox.ListCount = 0) Then
        Call pComboBox.AddItem("N/A - No " & pName & " Setup")
        pComboBox.ItemData(pComboBox.ListCount - 1) = -1
    End If
    pComboBox.ListIndex = 0
End Sub

Private Sub LoadListBox(ByRef pListboxBox As fpList, pName As String, ByRef pArray() As SupplierType, pMaxValue As Long, pShowAll As Boolean)
    Dim i As Long
    If (pShowAll = True) Then
        Call pListboxBox.AddItem(0 & vbTab & "N/A " & vbTab & "All " & pName)
    End If
    
    For i = 0 To pMaxValue
        Call pListboxBox.AddItem(pArray(i).Uid & vbTab & pArray(i).Code & vbTab & pArray(i).Name)
    Next
    If (pListboxBox.ListCount = 0) Then
        Call pListboxBox.AddItem(-1 & vbTab & "N/A" & vbTab & "No " & pName & " Setup")
    End If
End Sub

Public Sub GetSuppliersCBO(ByRef pComboBox As ComboBox, pShowAll As Boolean)
    Call LoadComboBox(pComboBox, "Suppliers", vSupplier(), vNumSupplier, pShowAll)
End Sub

Public Sub GetManufacturersCBO(ByRef pComboBox As ComboBox, pShowAll As Boolean)
    Call LoadComboBox(pComboBox, "Manufacturers", vManufacturer(), vNumManufacturer, pShowAll)
End Sub

Public Sub GetSuppliersGRD(ByRef pComboBox As fpList)
    Call LoadListBox(pComboBox, "Suppliers", vSupplier(), vNumSupplier, False)
End Sub

Public Sub GetManufacturerGRD(ByRef pListBox As fpList)
    Call LoadListBox(pListBox, "Manufacturers", vManufacturer(), vNumManufacturer, False)
End Sub

Public Sub LoadConstantData()
    Dim SupplierClass As New ClassSupplier
    Dim ManufacturerClass As New ClassManufacturer
    
    vNumSupplier = -1
    If (SupplierClass.Search(SupplierSearchENUM.byALL) > 0) Then
        
        vNumSupplier = SupplierClass.RecordCount - 1
        ReDim vSupplier(vNumSupplier)
        Do
            vSupplier(SupplierClass.RecordNumber - 2).Uid = SupplierClass.Uid
            vSupplier(SupplierClass.RecordNumber - 2).Code = SupplierClass.Code
            vSupplier(SupplierClass.RecordNumber - 2).Inactive = SupplierClass.Inactive
            vSupplier(SupplierClass.RecordNumber - 2).Name = SupplierClass.Name
            vSupplier(SupplierClass.RecordNumber - 2).Description = SupplierClass.Description
            vSupplier(SupplierClass.RecordNumber - 2).Phonenumber = SupplierClass.Phonenumber
            vSupplier(SupplierClass.RecordNumber - 2).Postcode = SupplierClass.Postcode
            vSupplier(SupplierClass.RecordNumber - 2).Proirity = SupplierClass.Proirity
            vSupplier(SupplierClass.RecordNumber - 2).Street1 = SupplierClass.Street1
            vSupplier(SupplierClass.RecordNumber - 2).Street2 = SupplierClass.Street2
            vSupplier(SupplierClass.RecordNumber - 2).Town = SupplierClass.Town
            vSupplier(SupplierClass.RecordNumber - 2).County = SupplierClass.County
            vSupplier(SupplierClass.RecordNumber - 2).Country = SupplierClass.Country
        Loop While (SupplierClass.NextRecord())
    Else
    End If

    vNumManufacturer = -1
    If (ManufacturerClass.Search(ManufacturerSearchENUM.byALL) > 0) Then
        
        vNumManufacturer = ManufacturerClass.RecordCount - 1
        ReDim vManufacturer(vNumManufacturer)
        Do
            vManufacturer(ManufacturerClass.RecordNumber - 2).Uid = ManufacturerClass.Uid
            vManufacturer(ManufacturerClass.RecordNumber - 2).Code = ManufacturerClass.Code
            vManufacturer(ManufacturerClass.RecordNumber - 2).Inactive = ManufacturerClass.Inactive
            vManufacturer(ManufacturerClass.RecordNumber - 2).Name = ManufacturerClass.Name
            vManufacturer(ManufacturerClass.RecordNumber - 2).Phonenumber = ManufacturerClass.Phonenumber
            vManufacturer(ManufacturerClass.RecordNumber - 2).Postcode = ManufacturerClass.Postcode
            vManufacturer(ManufacturerClass.RecordNumber - 2).Description = ManufacturerClass.Description
            vManufacturer(ManufacturerClass.RecordNumber - 2).Street1 = ManufacturerClass.Street1
            vManufacturer(ManufacturerClass.RecordNumber - 2).Street2 = ManufacturerClass.Street2
            vManufacturer(ManufacturerClass.RecordNumber - 2).Town = ManufacturerClass.Town
            vManufacturer(ManufacturerClass.RecordNumber - 2).County = ManufacturerClass.County
            vManufacturer(ManufacturerClass.RecordNumber - 2).Country = ManufacturerClass.Country
        Loop While (ManufacturerClass.NextRecord())
    Else
    End If
End Sub

