VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CNotifyDll"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Inspection Form Conduit
''
'' Coded By Dale Pitman


'D:\Program Files\coding\VB98\vb6.exe
Implements IPDClientNotify

Private vID(65535) As Long
Private vIDMax As Long

''
Private Sub Class_Initialize()
    If (ConnectDatabase("BodyWork.MDB") = True) Then
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
    Dim pmemo As PDRecordAdapter
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
    
    Dim datetemp As Long
    Dim tempdate As Date
    Dim rstemp As Recordset
    Dim i As Long
    Dim EngineerID As Long
    Dim EngineerRecord As Variant
    Dim templong As Long
    Dim Found As Boolean
    

    Dim UpdateEngineer As Boolean
    Dim UpdateMake As Boolean
    Dim UpdateModel As Boolean
    DeleteIDMax = 0
'    On Error GoTo Handler
    
    UpdateEngineer = False
    If (OpenRecordset(rstemp, "SELECT * FROM inspFlags ", dbOpenDynaset)) Then
        If (rstemp.EOF = False) Then
            UpdateEngineer = rstemp!UpdateEngineer
            UpdateMake = rstemp!UpdateMake
            UpdateModel = rstemp!UpdateModel
            
            rstemp!UpdateEngineer = False
            rstemp!UpdateMake = False
            rstemp!UpdateModel = False
            rstemp.Update
        End If
        Call rstemp.Close
    End If
    
    
    If (UpdateEngineer = True) Then
        Set pmemo = pDbQuery.OpenRecordDatabase("InspEng", "PDDirect.PDRecordAdapter", eRead Or eWrite Or eShowSecret)
        If (OpenRecordset(rstemp, "SELECT * FROM inspEng ", dbOpenDynaset)) Then
            Do While (rstemp.EOF = False)
                pmemo.IterationIndex = 0
                Found = False
                Do While (pmemo.EOF = False)
                    vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
                    If (pmemo.EOF = False) Then
                    Call pUtility.ByteArrayToDWORD(vData, 0, True, EngineerID)
                    
                    If (EngineerID = rstemp!UID) Then
                        templong = 4 + Len(rstemp!Name & "") + Len(rstemp!ShortName & "") + Len(rstemp!Type & "") + 3
                        ReDim EngineerRecord(templong - 1) As Byte
                        Call pUtility.DWORDToByteArray(EngineerRecord, 0, True, rstemp!UID)
                        templong = pUtility.BSTRToByteArray(EngineerRecord, 4, rstemp!Name & "")
                        templong = pUtility.BSTRToByteArray(EngineerRecord, templong, rstemp!ShortName & "")
                        templong = pUtility.BSTRToByteArray(EngineerRecord, templong, rstemp!Type & "")
                        
                        Call pmemo.Write(vUniqueId, nCategory, 0, EngineerRecord)
                        Found = True
                        Exit Do
                    End If
                    End If
                Loop
                If (Found = False) Then
                    templong = 4 + Len(rstemp!Name & "") + Len(rstemp!ShortName & "") + Len(rstemp!Type & "") + 3
                    ReDim EngineerRecord(templong - 1) As Byte
                    Call pUtility.DWORDToByteArray(EngineerRecord, 0, True, rstemp!UID)
                    templong = pUtility.BSTRToByteArray(EngineerRecord, 4, rstemp!Name & "")
                    templong = pUtility.BSTRToByteArray(EngineerRecord, templong, rstemp!ShortName & "")
                    templong = pUtility.BSTRToByteArray(EngineerRecord, templong, rstemp!Type & "")
                    Call pmemo.Write(vbEmpty, nCategory, 0, EngineerRecord)
                
                End If
                Call rstemp.MoveNext
            Loop
            Call rstemp.Close
        End If
        
        pmemo.IterationIndex = 0
        DeleteIDMax = 0
        Found = False
        Do While (pmemo.EOF = False)
            vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
            If (pmemo.EOF = False) Then
                Call pUtility.ByteArrayToDWORD(vData, 0, True, EngineerID)
                If (OpenRecordset(rstemp, "SELECT * FROM inspEng WHERE UID=" & EngineerID, dbOpenDynaset)) Then
                    If (rstemp.EOF = True) Then
                        DeleteIDList(DeleteIDMax) = vUniqueId
                        DeleteIDMax = DeleteIDMax + 1
                    End If
                    rstemp.Close
                End If
            End If
        Loop
        For i = 0 To DeleteIDMax - 1
            Call pmemo.Remove(DeleteIDList(i))
        Next
        DeleteIDMax = 0
    End If
    
    ' Update Make
    If (UpdateMake = True) Then
        Set pmemo = pDbQuery.OpenRecordDatabase("INSPMake", "PDDirect.PDRecordAdapter", eRead Or eWrite Or eShowSecret)
        Call GetIDs(pmemo)
        If (OpenRecordset(rstemp, "SELECT * FROM InspMake ", dbOpenDynaset)) Then
            Do While (rstemp.EOF = False)
                If (FindIndexByID(rstemp!UID) > 0) Then
                    pmemo.IterationIndex = FindIndexByID(rstemp!UID) - 1
                    
'                    nIndex = FindIndexByID(rstemp!UID) - 1
                    vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
                    Call pUtility.ByteArrayToDWORD(vData, 0, True, EngineerID)
                    
                    If (EngineerID = rstemp!UID) Then
                        templong = 4 + Len(rstemp!Name & "") + Len(rstemp!ShortName & "") + 2
                        ReDim EngineerRecord(templong - 1) As Byte
                        Call pUtility.DWORDToByteArray(EngineerRecord, 0, True, rstemp!UID)
                        templong = pUtility.BSTRToByteArray(EngineerRecord, 4, rstemp!Name & "")
                        templong = pUtility.BSTRToByteArray(EngineerRecord, templong, rstemp!ShortName & "")
                        
                        Call pmemo.Write(vUniqueId, nCategory, 0, EngineerRecord)
                        Found = True
'                        Exit Do
                    End If
                    Found = True
                Else
                    Found = False
                End If
'                pMemo.IterationIndex = 0
'                Found = False
'                Do While (pMemo.EOF = False)
'                    If (pMemo.EOF = False) Then
                    
'                    End If
'                Loop
                If (Found = False) Then
                    templong = 4 + Len(rstemp!Name & "") + Len(rstemp!ShortName & "") + 2
                    ReDim EngineerRecord(templong - 1) As Byte
                    Call pUtility.DWORDToByteArray(EngineerRecord, 0, True, rstemp!UID)
                    templong = pUtility.BSTRToByteArray(EngineerRecord, 4, rstemp!Name & "")
                    templong = pUtility.BSTRToByteArray(EngineerRecord, templong, rstemp!ShortName & "")
                    Call pmemo.Write(vbEmpty, nCategory, 0, EngineerRecord)
                
                End If
                Call rstemp.MoveNext
            Loop
            Call rstemp.Close
        End If
        
        pmemo.IterationIndex = 0
        DeleteIDMax = 0
        Found = False
        Do While (pmemo.EOF = False)
            vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
            If (pmemo.EOF = False) Then
                Call pUtility.ByteArrayToDWORD(vData, 0, True, EngineerID)
                If (OpenRecordset(rstemp, "SELECT * FROM INSPMake WHERE UID=" & EngineerID, dbOpenDynaset)) Then
                    If (rstemp.EOF = True) Then
                        DeleteIDList(DeleteIDMax) = vUniqueId
                        DeleteIDMax = DeleteIDMax + 1
                    End If
                    rstemp.Close
                End If
            End If
        Loop
        For i = 0 To DeleteIDMax - 1
            Call pmemo.Remove(DeleteIDList(i))
        Next
        DeleteIDMax = 0
    End If
    
    ' Update Model
    If (UpdateModel = True) Then
        Set pmemo = pDbQuery.OpenRecordDatabase("INSPModel", "PDDirect.PDRecordAdapter", eRead Or eWrite Or eShowSecret)
        Call GetIDs(pmemo)
        If (OpenRecordset(rstemp, "SELECT * FROM InspModel ", dbOpenDynaset)) Then
            Do While (rstemp.EOF = False)
                
                If (FindIndexByID(rstemp!UID) > 0) Then
                    pmemo.IterationIndex = FindIndexByID(rstemp!UID) - 1
                    
                    vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
                    Call pUtility.ByteArrayToDWORD(vData, 0, True, EngineerID)
                    
                    If (EngineerID = rstemp!UID) Then
                        templong = 16 + Len(rstemp!Name & "") + Len(rstemp!ShortName & "") + 2
                        ReDim EngineerRecord(templong - 1) As Byte
                        Call pUtility.DWORDToByteArray(EngineerRecord, 0, True, rstemp!UID)
                        Call pUtility.DWORDToByteArray(EngineerRecord, 4, True, rstemp!MakeID)
                        Call pUtility.DWORDToByteArray(EngineerRecord, 8, True, rstemp!StartYear)
                        Call pUtility.DWORDToByteArray(EngineerRecord, 12, True, rstemp!EndYear)
                        templong = pUtility.BSTRToByteArray(EngineerRecord, 16, rstemp!Name & "")
                        templong = pUtility.BSTRToByteArray(EngineerRecord, templong, rstemp!ShortName & "")
                        
                        Call pmemo.Write(vUniqueId, nCategory, 0, EngineerRecord)
                        Found = True
'                        Exit Do
                    End If
                    Found = True
                Else
                    Found = False
                End If
                
                
                If (Found = False) Then
                    templong = 16 + Len(rstemp!Name & "") + Len(rstemp!ShortName & "") + 2
                    ReDim EngineerRecord(templong - 1) As Byte
                    Call pUtility.DWORDToByteArray(EngineerRecord, 0, True, rstemp!UID)
                    Call pUtility.DWORDToByteArray(EngineerRecord, 4, True, rstemp!MakeID)
                    Call pUtility.DWORDToByteArray(EngineerRecord, 8, True, rstemp!StartYear)
                    Call pUtility.DWORDToByteArray(EngineerRecord, 12, True, rstemp!EndYear)
                    templong = pUtility.BSTRToByteArray(EngineerRecord, 16, rstemp!Name & "")
                    templong = pUtility.BSTRToByteArray(EngineerRecord, templong, rstemp!ShortName & "")
                    Call pmemo.Write(vbEmpty, nCategory, 0, EngineerRecord)
                
                End If
                Call rstemp.MoveNext
            Loop
            Call rstemp.Close
        End If
        
        pmemo.IterationIndex = 0
        DeleteIDMax = 0
        Found = False
        Do While (pmemo.EOF = False)
            vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
            If (pmemo.EOF = False) Then
                Call pUtility.ByteArrayToDWORD(vData, 0, True, EngineerID)
                If (OpenRecordset(rstemp, "SELECT * FROM INSPModel WHERE UID=" & EngineerID, dbOpenDynaset)) Then
                    If (rstemp.EOF = True) Then
                        DeleteIDList(DeleteIDMax) = vUniqueId
                        DeleteIDMax = DeleteIDMax + 1
                    End If
                    rstemp.Close
                End If
            End If
        Loop
        For i = 0 To DeleteIDMax - 1
            Call pmemo.Remove(DeleteIDList(i))
        Next
        DeleteIDMax = 0
    End If
    
    '   Open the Memo database
    Set pmemo = pDbQuery.OpenRecordDatabase("Inspdata", "PDDirect.PDRecordAdapter", eRead Or eWrite Or eShowSecret)
    nTest = pDbQuery.ReadDbNameList(True)
    pmemo.IterationIndex = 0
    If (pmemo.EOF = False) Then
        vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
        
        If (OpenRecordset(rstemp, "SELECT * FROM inspdata", dbOpenDynaset)) Then
            'ok
        
            Do While Not pmemo.EOF
                i = 0
    '            Call pUtility.ByteArrayToBSTR(vData, 0, 32767, VarPtr(vrecord))
                vrecord.UID = ReadLong(vData, i)
                
                vrecord.INSPJobID = ReadLong(vData, i)
                
                vrecord.Registration = ReadString(vData, i)
                
                vrecord.INSPMakeID = ReadLong(vData, i)
                vrecord.INSPModelID = ReadLong(vData, i)
                
                vrecord.PartInsecure = ReadLong(vData, i)
                vrecord.PartWongPart = ReadLong(vData, i)
                vrecord.PartNotWorking = ReadLong(vData, i)
                vrecord.PartOther = ReadLong(vData, i)
                vrecord.ElectricalWiring = ReadLong(vData, i)
                vrecord.ElectricalConnection = ReadLong(vData, i)
                vrecord.ElectricalLight = ReadLong(vData, i)
                vrecord.ElectricalOther = ReadLong(vData, i)
                vrecord.RepairWeld = ReadLong(vData, i)
                vrecord.RepairSealWaxing = ReadLong(vData, i)
                vrecord.RepairWaterIngress = ReadLong(vData, i)
                vrecord.RepairOther = ReadLong(vData, i)
                vrecord.RepairFillerRepair = ReadLong(vData, i)
                vrecord.PannelOther = ReadLong(vData, i)
                
                vrecord.Internal = ReadBoolean(vData, i)
                vrecord.Completed = ReadBoolean(vData, i)
                
                vrecord.InspectionDate = ReadDate(vData, i)
                
                ' Paint fields
                vrecord.PolishingThrough = ReadLong(vData, i)
                vrecord.PolishingFlattingMarks = ReadLong(vData, i)
                vrecord.PolishingOverSpray = ReadLong(vData, i)
                vrecord.PolishingOther = ReadLong(vData, i)
                vrecord.FinishingTouchingUp = ReadLong(vData, i)
                vrecord.FinishingPaint = ReadLong(vData, i)
                vrecord.FinishingBlackingOff = ReadLong(vData, i)
                vrecord.FinishingOther = ReadLong(vData, i)
                vrecord.PaintingSandingMarks = ReadLong(vData, i)
                vrecord.PaintingBareCorrosion = ReadLong(vData, i)
                vrecord.PaintingPaintRuns = ReadLong(vData, i)
                vrecord.PaintingColourMatch = ReadLong(vData, i)
                vrecord.PaintingShrinkage = ReadLong(vData, i)
                vrecord.PaintingMaskingLines = ReadLong(vData, i)
                vrecord.PaintingPaintEdge = ReadLong(vData, i)
                vrecord.PaintingBlowins = ReadLong(vData, i)
                vrecord.PaintingCleaning = ReadLong(vData, i)
                vrecord.PaintingOther = ReadLong(vData, i)
                vrecord.PaintingDirtInPaint = ReadLong(vData, i)
                
                vrecord.AdditionalText = ReadString(vData, i)
                
                vrecord.PanelEngineer = ReadLong(vData, i)
                vrecord.PainterEngineer = ReadLong(vData, i)
                
                vrecord.PartProblem = ReadString(vData, i)
                vrecord.CleaningProblem = ReadString(vData, i)
                
                vrecord.PanelFitment = ReadLong(vData, i)
                vrecord.PanelAlighment = ReadLong(vData, i)
                
                '''''''
                rstemp.AddNew
                
                rstemp!INSPJobID = vrecord.INSPJobID
                
                rstemp!Registration = vrecord.Registration
                rstemp!InspectionDate = vrecord.InspectionDate
                
                rstemp!PanelEngineer = vrecord.PanelEngineer
                rstemp!PainterEngineer = vrecord.PainterEngineer
                
                rstemp!INSPMakeID = vrecord.INSPMakeID
                rstemp!INSPModelID = vrecord.INSPModelID
                rstemp!PartInsecure = vrecord.PartInsecure
                rstemp!PartWongPart = vrecord.PartWongPart
                rstemp!PartNotWorking = vrecord.PartNotWorking
                rstemp!PartOther = vrecord.PartOther
                rstemp!ElectricalWiring = vrecord.ElectricalWiring
                rstemp!ElectricalConnection = vrecord.ElectricalConnection
                rstemp!ElectricalLight = vrecord.ElectricalLight
                rstemp!ElectricalOther = vrecord.ElectricalOther
                rstemp!RepairWeld = vrecord.RepairWeld
                rstemp!RepairSealWaxing = vrecord.RepairSealWaxing
                rstemp!RepairWaterIngress = vrecord.RepairWaterIngress
                rstemp!RepairOther = vrecord.RepairOther
                rstemp!PannelOther = vrecord.PannelOther
                rstemp!Internal = vrecord.Internal
                rstemp!Completed = vrecord.Completed
                rstemp!RepairFillerRepair = vrecord.RepairFillerRepair
                
                rstemp!PolishingThrough = vrecord.PolishingThrough
                rstemp!PolishingFlattingMarks = vrecord.PolishingFlattingMarks
                rstemp!PolishingOverSpray = vrecord.PolishingOverSpray
                rstemp!PolishingOther = vrecord.PolishingOther
                rstemp!FinishingTouchingUp = vrecord.FinishingTouchingUp
                rstemp!FinishingPaint = vrecord.FinishingPaint
                rstemp!FinishingBlackingOff = vrecord.FinishingBlackingOff
                rstemp!FinishingOther = vrecord.FinishingOther
                rstemp!PaintingSandingMarks = vrecord.PaintingSandingMarks
                rstemp!PaintingBareCorrosion = vrecord.PaintingBareCorrosion
                rstemp!PaintingPaintRuns = vrecord.PaintingPaintRuns
                rstemp!PaintingColourMatch = vrecord.PaintingColourMatch
                rstemp!PaintingShrinkage = vrecord.PaintingShrinkage
                rstemp!PaintingMaskingLines = vrecord.PaintingMaskingLines
                rstemp!PaintingPaintEdge = vrecord.PaintingPaintEdge
                rstemp!PaintingBlowins = vrecord.PaintingBlowins
                rstemp!PaintingCleaning = vrecord.PaintingCleaning
                rstemp!PaintingOther = vrecord.PaintingOther
                
                rstemp!AdditionalText = vrecord.AdditionalText
                rstemp!PaintingDirtInPaint = vrecord.PaintingDirtInPaint
                
                rstemp!PanelFitment = vrecord.PanelFitment
                rstemp!PanelAlighment = vrecord.PanelAlighment
                
                rstemp!CleaningProblem = vrecord.CleaningProblem
                rstemp!PartProblem = vrecord.PartProblem
                rstemp.Update
                
                DeleteIDList(DeleteIDMax) = vUniqueId
                DeleteIDMax = DeleteIDMax + 1
                vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
            Loop
        
            For i = 0 To DeleteIDMax - 1
                Call pmemo.Remove(DeleteIDList(i))
            Next
            Call rstemp.Close
        Else
            Call Messagebox("Failed To Sync with database, aborting", vbExclamation)
        End If
    Else
    End If
    Set pDbQuery = Nothing
    Set pmemo = Nothing
    Set pUtility = Nothing
    
    Exit Function
Handler:
    Call Messagebox("There was an error performing the search." & vbNewLine & Err.Description & vbNewLine & "Number = " & Hex(Err.Number), vbCritical)
    Set pDbQuery = Nothing
    Set pmemo = Nothing
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


Private Sub GetIDs(pmemo As PDRecordAdapter)
    Dim vData As Variant
    Dim ID As Long
    Dim i As Long
    
    Dim pUtility As New PDUtility
    Dim nIndex As Long
    Dim vUniqueId As Variant
    Dim nCategory As Long
    Dim eAttributes As ERecordAttributes
    
    For i = 0 To 65535
        vID(i) = -1
    Next
    pmemo.IterationIndex = 0
    Do While (pmemo.EOF = False)
        vData = pmemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
        If (pmemo.EOF = False) Then
            Call pUtility.ByteArrayToDWORD(vData, 0, True, ID)
            vID(pmemo.IterationIndex) = ID
            vIDMax = pmemo.IterationIndex
        End If
    Loop

End Sub

Private Function FindIndexByID(pID As Long) As Long
    Dim i As Long
    For i = 0 To vIDMax
        If (vID(i) = pID) Then
            FindIndexByID = i
            Exit For
        End If
    Next
End Function
