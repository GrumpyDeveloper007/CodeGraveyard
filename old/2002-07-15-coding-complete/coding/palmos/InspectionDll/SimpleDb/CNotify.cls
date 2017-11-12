VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CNotifyDll"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Simple Invoice Conduit (ELF2)
''
'' Coded By Dale Pitman


'D:\Program Files\coding\VB98\vb6.exe
Implements IPDClientNotify


Private vrecord As tELF2InvoiceRecord
Private vLineRecord As tELF2LineRecord

Private Type tELF2InvoiceRecord
        UID As Long
        Name As String
        CompanyName As String
        Title As String
        WorkNumber As String
        Address1 As String
        Street1 As String
        State As String
        Country As String
        PostCode As String
        Carriage As Long
        PONumber As String
        InvoiceType As Long
End Type

Private Type tELF2LineRecord
        ELF2InvoiceID As Long
        QTY As Long
        Name As String
        Description As String
        UnitCost As Long
        VatPercent As Long
End Type



''
Private Sub Class_Initialize()
    If (ConnectDatabase("SInvoice.MDB") = True) Then
    Else
        Call MsgBox("Failed to open database")
    End If
End Sub

''
Private Sub Class_Terminate()
    Call DisConnectDatabase
End Sub

''
Public Function DoTransfer() As Boolean
    Dim pDbQuery As New PDDatabaseQuery
    Dim pMemo As PDRecordAdapter
    Dim pUtility As New PDUtility
    Dim nIndex As Long
    Dim vUniqueId As Variant
    Dim nCategory As Long
    Dim eAttributes As ERecordAttributes
    Dim vData As Variant
    Dim nCount As Long
    Dim nTest As Variant
    
    Dim DeleteIDList(5000) As Long
    Dim DeleteIDMax As Long
    
    Dim DateTemp As Long
    Dim TempDate As Date
    Dim rstemp As Recordset
    Dim rsInvoiceLine As Recordset
    Dim i As Long
    
    Dim UpdateProduct As Boolean
    Dim ProductRecord As Variant
    Dim ProductID As Long
    Dim TempLong As Long
    Dim Found As Boolean
    Dim Long2Currency As Long

    Dim TempString As String
    DeleteIDMax = 0
    On Error GoTo Handler
    
    UpdateProduct = True
    If (UpdateProduct = True) Then
        Set pMemo = pDbQuery.OpenRecordDatabase("Product", "PDDirect.PDRecordAdapter", eRead Or eWrite Or eShowSecret)
'        nTest = pDbQuery.ReadDbNameList(True)
        If (OpenRecordset(rstemp, "SELECT * FROM Product ", dbOpenDynaset)) Then
            Do While (rstemp.EOF = False)
                pMemo.IterationIndex = 0
                nIndex = 0
                Found = False
                Do While (pMemo.EOF = False)
                    vData = pMemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
                    
                    If (pMemo.EOF = False) Then
                        TempString = ""
                        For i = 0 To UBound(vData)
                            If (vData(i) <> 0) Then
                                TempString = TempString & Chr(vData(i))
                            End If
                        Next
                    
                    
                    Call pUtility.ByteArrayToDWORD(vData, 0, True, ProductID)
                    
                    If (ProductID = rstemp!UID) Then
                        TempLong = 4 + Len(rstemp!Name & "") + Len(rstemp!Description & "") + 2 + 8
                        ReDim ProductRecord(TempLong - 1) As Byte
                        
'        UID As Long
'        Name As String
'        Description As String
'        NetCost As Currency     'Default Net Cost
'        VATPercent As Currency  'Default VAT Cost
                        Call pUtility.DWORDToByteArray(ProductRecord, 0, True, rstemp!UID)
                        TempLong = pUtility.BSTRToByteArray(ProductRecord, 4, UCase$(rstemp!Name & ""))
                        TempLong = pUtility.BSTRToByteArray(ProductRecord, TempLong, UCase$(rstemp!Description & ""))
                        
                        Long2Currency = rstemp!netcost * 100
                        TempLong = pUtility.DWORDToByteArray(ProductRecord, TempLong, True, Long2Currency)
                        Long2Currency = rstemp!VatPercent * 100
                        TempLong = pUtility.DWORDToByteArray(ProductRecord, TempLong, True, Long2Currency)
                        Call pMemo.Write(vUniqueId, nCategory, eDirty, ProductRecord)
                        Found = True
                        Exit Do
                    End If
                    End If
                Loop
                If (Found = False) Then
                    TempLong = 4 + Len(rstemp!Name & "") + Len(rstemp!Description & "") + 2 + 8
                    ReDim ProductRecord(TempLong) As Byte
                    
                    Call pUtility.DWORDToByteArray(ProductRecord, 0, True, rstemp!UID)
                    TempLong = pUtility.BSTRToByteArray(ProductRecord, 4, UCase$(rstemp!Name & ""))
                    TempLong = pUtility.BSTRToByteArray(ProductRecord, TempLong, UCase$(rstemp!Description & ""))
                    
                    Long2Currency = rstemp!netcost * 100
                    TempLong = pUtility.DWORDToByteArray(ProductRecord, TempLong, True, Long2Currency)
                    Long2Currency = rstemp!VatPercent * 100
                    TempLong = pUtility.DWORDToByteArray(ProductRecord, TempLong, True, Long2Currency)
                    Call pMemo.Write(vbEmpty, nCategory, eDirty, ProductRecord)
                
                End If
                Call rstemp.MoveNext
            Loop
            Call rstemp.Close
        End If
        
        pMemo.IterationIndex = 0
        DeleteIDMax = 0
        Found = False
        Do While (pMemo.EOF = False)
            vData = pMemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
            If (pMemo.EOF = False) Then
                Call pUtility.ByteArrayToDWORD(vData, 0, True, ProductID)
                If (OpenRecordset(rstemp, "SELECT * FROM Product WHERE UID=" & ProductID, dbOpenDynaset)) Then
                    If (rstemp.EOF = True) Then
                        DeleteIDList(DeleteIDMax) = vUniqueId
                        DeleteIDMax = DeleteIDMax + 1
                    End If
                    rstemp.Close
                End If
            End If
        Loop
        For i = 0 To DeleteIDMax - 1
            Call pMemo.Remove(DeleteIDList(i))
        Next
        Set pMemo = Nothing
    End If
    
    
    '   Open the Elf2Invoice database
    Set pMemo = pDbQuery.OpenRecordDatabase("ELF2Invoice", "PDDirect.PDRecordAdapter", eRead Or eWrite Or eShowSecret)
    nTest = pDbQuery.ReadDbNameList(True)
    pMemo.IterationIndex = 0
    DeleteIDMax = 0
    If (pMemo.EOF = False) Then
        vData = pMemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
        
        If (OpenRecordset(rstemp, "SELECT * FROM ELF2Invoice", dbOpenDynaset)) Then
            'ok
        
            Do While Not pMemo.EOF
                i = 0
                i = pUtility.ByteArrayToDWORD(vData, i, True, vrecord.UID)  'load
                vrecord.Name = ""
                Do While (vData(i) <> 0)
                    vrecord.Name = vrecord.Name & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                vrecord.CompanyName = ""
                Do While (vData(i) <> 0)
                    vrecord.CompanyName = vrecord.CompanyName & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                vrecord.Title = ""
                Do While (vData(i) <> 0)
                    vrecord.Title = vrecord.Title & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                vrecord.WorkNumber = ""
                Do While (vData(i) <> 0)
                    vrecord.WorkNumber = vrecord.WorkNumber & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                vrecord.Address1 = ""
                Do While (vData(i) <> 0)
                    vrecord.Address1 = vrecord.Address1 & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                vrecord.Street1 = ""
                Do While (vData(i) <> 0)
                    vrecord.Street1 = vrecord.Street1 & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                vrecord.State = ""
                Do While (vData(i) <> 0)
                    vrecord.State = vrecord.State & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                vrecord.Country = ""
                Do While (vData(i) <> 0)
                    vrecord.Country = vrecord.Country & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                vrecord.PostCode = ""
                Do While (vData(i) <> 0)
                    vrecord.PostCode = vrecord.PostCode & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.Carriage = Long2Currency / 100
                
                vrecord.PONumber = ""
                Do While (vData(i) <> 0)
                    vrecord.PONumber = vrecord.PONumber & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                i = pUtility.ByteArrayToDWORD(vData, i, True, vrecord.InvoiceType)   'load
                
                rstemp.AddNew
                rstemp!UID = vrecord.UID
                rstemp!Name = vrecord.Name
                rstemp!CompanyName = vrecord.CompanyName
                rstemp!Title = vrecord.Title
                rstemp!WorkNumber = vrecord.WorkNumber
                rstemp!Address1 = vrecord.Address1
                rstemp!Street1 = vrecord.Street1
                rstemp!State = vrecord.State
                rstemp!Country = vrecord.Country
                rstemp!PostCode = vrecord.PostCode
                rstemp!Carriage = vrecord.Carriage
                rstemp!PONumber = vrecord.PONumber
                rstemp!InvoiceType = vrecord.InvoiceType

                
                rstemp.Update
                
                DeleteIDList(DeleteIDMax) = vUniqueId
                DeleteIDMax = DeleteIDMax + 1
                vData = pMemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
            Loop
        
            For i = 0 To DeleteIDMax - 1
                Call pMemo.Remove(DeleteIDList(i))
            Next
            Call rstemp.Close
        Else
            Call Messagebox("Failed To Sync with database, aborting", vbExclamation)
        End If
    End If
    
    
    
    '   Open the Elf2Invoice database
    Set pMemo = pDbQuery.OpenRecordDatabase("ELF2Line", "PDDirect.PDRecordAdapter", eRead Or eWrite Or eShowSecret)
    nTest = pDbQuery.ReadDbNameList(True)
    pMemo.IterationIndex = 0
    DeleteIDMax = 0
    If (pMemo.EOF = False) Then
        vData = pMemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
        
        If (OpenRecordset(rstemp, "SELECT * FROM ELF2line", dbOpenDynaset)) Then
            'ok
        
            Do While Not pMemo.EOF
                i = 0
                i = pUtility.ByteArrayToDWORD(vData, i, True, vLineRecord.ELF2InvoiceID)  'load
                i = pUtility.ByteArrayToDWORD(vData, i, True, vLineRecord.QTY)  'load
                vLineRecord.Name = ""
                Do While (vData(i) <> 0)
                    vLineRecord.Name = vLineRecord.Name & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vLineRecord.UnitCost = Long2Currency / 100
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vLineRecord.VatPercent = Long2Currency / 100
                
                rstemp.AddNew
                
                rstemp!ELF2InvoiceID = vLineRecord.ELF2InvoiceID
                rstemp!QTY = vLineRecord.QTY
                rstemp!Name = vLineRecord.Name
                rstemp!UnitCost = vLineRecord.UnitCost
                rstemp!VatPercent = vLineRecord.VatPercent
                
                rstemp.Update
                
                DeleteIDList(DeleteIDMax) = vUniqueId
                DeleteIDMax = DeleteIDMax + 1
                vData = pMemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
            Loop
        
            For i = 0 To DeleteIDMax - 1
                Call pMemo.Remove(DeleteIDList(i))
            Next
            Call rstemp.Close
        Else
            Call Messagebox("Failed To Sync with database, aborting", vbExclamation)
        End If
    End If
    
    
    Set pDbQuery = Nothing
    Set pMemo = Nothing
    Set pUtility = Nothing
    
    Exit Function
Handler:
    Call Messagebox("There was an error." & vbNewLine & Err.Description & vbNewLine & "Number = " & Hex(Err.Number), vbCritical)
    Resume
    Set pDbQuery = Nothing
    Set pMemo = Nothing
    Set pUtility = Nothing
End Function

''
Private Function IPDClientNotify_BeginProcess() As Boolean
    Call DoTransfer
    
    '   Return false because we're done with PDServer
    IPDClientNotify_BeginProcess = False
End Function

''
Private Sub IPDClientNotify_CfgConduit(ByVal nCreatorId As Long, ByVal nUserId As Long, ByVal bstrUserName As String, ByVal bstrPathName As String, nSyncPerm As Long, nSyncTemp As Long, nSyncNew As Long, nSyncPref As Long)
    '   Set up the configuration dialog
    FConfigure.nSyncType = nSyncPerm
       
    '   Get the user preferences
    FConfigure.Show vbModal
    
    '   Reset the preferences
    If Not FConfigure.bCancel Then
        nSyncNew = FConfigure.nSyncType
        nSyncPref = FConfigure.nSyncPref
    End If
End Sub

''
Private Sub IPDClientNotify_ConfigureConduit(ByVal pPathName As String, ByVal pRegistry As String, nSyncPref As Long, nSyncType As Long)
    '   Set up the configuration dialog
    FConfigure.pPath = pPathName
    FConfigure.pRegistry = pRegistry
    FConfigure.nSyncType = nSyncType
    
    '   Get the user preferences
    FConfigure.Show vbModal
    
    '   Reset the preferences
    If Not FConfigure.bCancel Then
        nSyncType = FConfigure.nSyncType
        nSyncPref = FConfigure.nSyncPref
    End If
End Sub

''
Private Function IPDClientNotify_GetConduitInfo(ByVal infoType As PDDirectLib.EGetConduitInfo, ByVal dwCreatorId As Long, ByVal dwUserId As Long, ByVal bstrUserName As String) As Variant
    If infoType = eGetConduitName Then
        IPDClientNotify_GetConduitInfo = "INSPDLL"
    End If
    
    If infoType = eGetDefaultAction Then
        IPDClientNotify_GetConduitInfo = PDDirectLib.eFast
    End If
    
   If infoType = eGetMfcVersion Then
        IPDClientNotify_GetConduitInfo = PDDirectLib.ePDMFC_NOT_USED
   End If

   If infoType = eGetConduitVersion Then
        IPDClientNotify_GetConduitInfo = 1#
   End If
End Function
