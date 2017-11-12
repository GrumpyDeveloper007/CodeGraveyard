VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form MDIMain 
   Caption         =   "PDDirect Tutorial Executable"
   ClientHeight    =   3135
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   4935
   LinkTopic       =   "Form1"
   ScaleHeight     =   3135
   ScaleWidth      =   4935
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog CommonDialogControl 
      Left            =   450
      Top             =   1905
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton btnSearch 
      Caption         =   "Search"
      Height          =   435
      Left            =   1680
      TabIndex        =   2
      Top             =   2370
      Width           =   1485
   End
   Begin VB.TextBox txtSearch 
      Height          =   345
      Left            =   270
      TabIndex        =   1
      Top             =   540
      Width           =   4215
   End
   Begin VB.Label lblCount 
      Caption         =   "0 of 100 records contained the string."
      Height          =   285
      Left            =   270
      TabIndex        =   3
      Top             =   1260
      Width           =   4215
   End
   Begin VB.Label Label1 
      Caption         =   "Search the MemoDB and find this string."
      Height          =   225
      Left            =   300
      TabIndex        =   0
      Top             =   210
      Width           =   2955
   End
End
Attribute VB_Name = "MDIMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


''
Private Function DoTransfer() As Boolean
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
    
    
    
    
    
    
    
    
    
    '   Open the Memo database
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
                
                ' Prod1
                i = pUtility.ByteArrayToDWORD(vData, i, True, vrecord.PROD1QTY) 'load
                vrecord.PROD1Name = ""
                Do While (vData(i) <> 0)
                    vrecord.PROD1Name = vrecord.PROD1Name & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.PROD1UnitCost = Long2Currency / 100
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.PROD1VatPercent = Long2Currency / 100
                
                ' Prod2
                i = pUtility.ByteArrayToDWORD(vData, i, True, vrecord.PROD2QTY) 'load
                vrecord.PROD2Name = ""
                Do While (vData(i) <> 0)
                    vrecord.PROD2Name = vrecord.PROD2Name & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.PROD2UnitCost = Long2Currency / 100
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.PROD2VatPercent = Long2Currency / 100
                
                ' Prod3
                i = pUtility.ByteArrayToDWORD(vData, i, True, vrecord.PROD3QTY) 'load
                vrecord.PROD3Name = ""
                Do While (vData(i) <> 0)
                    vrecord.PROD3Name = vrecord.PROD3Name & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.PROD3UnitCost = Long2Currency / 100
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.PROD3VatPercent = Long2Currency / 100
                
                ' Prod4
                i = pUtility.ByteArrayToDWORD(vData, i, True, vrecord.PROD4QTY) 'load
                vrecord.PROD4Name = ""
                Do While (vData(i) <> 0)
                    vrecord.PROD4Name = vrecord.PROD4Name & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.PROD4UnitCost = Long2Currency / 100
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.PROD4VatPercent = Long2Currency / 100
                
                
                i = pUtility.ByteArrayToDWORD(vData, i, True, Long2Currency)
                vrecord.Carriage = Long2Currency / 100
                vrecord.Comment = ""
                Do While (vData(i) <> 0)
                    vrecord.Comment = vrecord.Comment & Chr$(vData(i))
                    i = i + 1
                Loop
                i = i + 1
                
                rstemp.AddNew
                rstemp!Name = vrecord.Name
                rstemp!CompanyName = vrecord.CompanyName
                rstemp!Title = vrecord.Title
                rstemp!WorkNumber = vrecord.WorkNumber
                rstemp!Address1 = vrecord.Address1
                rstemp!Street1 = vrecord.Street1
                rstemp!State = vrecord.State
                rstemp!Country = vrecord.Country
                rstemp!PostCode = vrecord.PostCode
                rstemp!PROD1QTY = vrecord.PROD1QTY
                rstemp!PROD1Name = vrecord.PROD1Name
                rstemp!PROD1UnitCost = vrecord.PROD1UnitCost
                rstemp!PROD1VatPercent = vrecord.PROD1VatPercent
                
                rstemp!PROD2QTY = vrecord.PROD2QTY
                rstemp!PROD2Name = vrecord.PROD2Name
                rstemp!PROD2UnitCost = vrecord.PROD2UnitCost
                rstemp!PROD2VatPercent = vrecord.PROD2VatPercent
                
                rstemp!PROD3QTY = vrecord.PROD3QTY
                rstemp!PROD3Name = vrecord.PROD3Name
                rstemp!PROD3UnitCost = vrecord.PROD3UnitCost
                rstemp!PROD3VatPercent = vrecord.PROD3VatPercent
                
                rstemp!PROD4QTY = vrecord.PROD4QTY
                rstemp!PROD4Name = vrecord.PROD4Name
                rstemp!PROD4UnitCost = vrecord.PROD4UnitCost
                rstemp!PROD4VatPercent = vrecord.PROD4VatPercent
                rstemp!Carriage = vrecord.Carriage
                rstemp!Comment = vrecord.Comment
                
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



Private Sub btnSearch_Click()
    Dim test As New CNotifyDll
    Call test.DoTransfer
'    Call DoTransfer
End Sub

Private Sub Form_Load()
'    If (ConnectDatabase("Sinvoice.MDB") = True) Then
'    End If

End Sub
