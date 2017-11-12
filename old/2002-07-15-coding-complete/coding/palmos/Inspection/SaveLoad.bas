Attribute VB_Name = "SaveLoad"
Option Explicit

Private vNewRecord As Boolean
Public vDate As Date
Private vCurrentRecordID As Long

Public Sub LoadCBO()
    Dim EngineerRecord As tInspEngRecord
    Dim MakeRecord As tINSPMakeRecord
    
    FRMInspection3.CBOPL.Clear
    FRMInspection3.CBOPM.Clear
    FRMInspection3.CBOMake.Clear
    FRMInspection3.CBOModel.Clear

    Call PDBMoveFirst(dbInspEng)
    Do While (PDBEOF(dbInspEng) = False)
        Call PDBReadRecord(dbInspEng, VarPtr(EngineerRecord))
        If (EngineerRecord.Type_ = "PL" Or EngineerRecord.Type_ = "PP") Then
            Call FRMInspection3.CBOPL.AddItem(EngineerRecord.Name)
            FRMInspection3.CBOPL.ItemData(FRMInspection3.CBOPL.ListCount - 1) = EngineerRecord.UID 'PDBRecordUniqueID(dbInspEng)
        End If
        
        If (EngineerRecord.Type_ = "PM" Or EngineerRecord.Type_ = "PP") Then
            Call FRMInspection3.CBOPM.AddItem(EngineerRecord.Name)
            FRMInspection3.CBOPM.ItemData(FRMInspection3.CBOPL.ListCount - 1) = EngineerRecord.UID 'PDBRecordUniqueID(dbInspEng)
        End If
        Call PDBMoveNext(dbInspEng)
        
    Loop

    Call FRMInspection3.CBOMake.AddItem("N/A")
    FRMInspection3.CBOMake.ItemData(FRMInspection3.CBOMake.ListCount - 1) = 0
    
    Call FRMInspection3.CBOModel.AddItem("N/A")
    FRMInspection3.CBOModel.ItemData(FRMInspection3.CBOMake.ListCount - 1) = 0
    
    Call PDBMoveFirst(dbINSPMake)
    Do While (PDBEOF(dbINSPMake) = False)
        Call PDBReadRecord(dbINSPMake, VarPtr(MakeRecord))
        Call FRMInspection3.CBOMake.AddItem(MakeRecord.Name)
        FRMInspection3.CBOMake.ItemData(FRMInspection3.CBOMake.ListCount - 1) = MakeRecord.UID 'PDBRecordUniqueID(dbInspEng)
        Call PDBMoveNext(dbINSPMake)
    Loop
End Sub

Public Sub LoadModelCBO()
    Dim ModelRecord As tINSPModelRecord
    Dim MakeID As Long
    MakeID = FRMInspection3.CBOMake.ItemData(FRMInspection3.CBOMake.ListIndex)
    
    Call FRMInspection3.CBOModel.Clear
    Call PDBMoveFirst(dbINSPModel)
    
    Call PDBFindRecordByField(dbINSPModel, tINSPModelDatabaseFields.MakeID_Field, MakeID)
    Call PDBReadRecord(dbINSPModel, VarPtr(ModelRecord))
    
    Do While (PDBEOF(dbINSPModel) = False And ModelRecord.MakeID = MakeID)
        Call PDBReadRecord(dbINSPModel, VarPtr(ModelRecord))
        If (ModelRecord.MakeID = MakeID) Then
            Call FRMInspection3.CBOModel.AddItem(ModelRecord.Name)
            FRMInspection3.CBOModel.ItemData(FRMInspection3.CBOModel.ListCount - 1) = ModelRecord.UID 'PDBRecordUniqueID(dbInspEng)
        End If
        Call PDBMoveNext(dbINSPModel)
    Loop
End Sub

Public Sub SaveDetails()
    Dim InspectionRecord As tInspdataRecord
    Dim result As Boolean
    
    'Validate
    If (Len(FRMInspection1.TXTReg.Text) > 0) Then
    
        InspectionRecord.Completed = True
        InspectionRecord.InspectionDate = vDate
        InspectionRecord.Registration = FRMInspection1.TXTReg.Text
        
        If (FRMInspection3.OPTInspectionType(0).Value = True) Then
            InspectionRecord.Internal = True
        Else
            InspectionRecord.Internal = False
        End If
        
        InspectionRecord.PartInsecure = CheckBlank(FRMInspection1.TXTInsecure.Text)
        InspectionRecord.PartWongPart = CheckBlank(FRMInspection1.TXTWrongPart.Text)
        InspectionRecord.PartNotWorking = CheckBlank(FRMInspection1.TXTNotWorking.Text)
        InspectionRecord.PartOther = CheckBlank(FRMInspection1.TXTOther.Text)
        InspectionRecord.ElectricalWiring = CheckBlank(FRMInspection1.TXTWiring.Text)
        InspectionRecord.ElectricalConnection = CheckBlank(FRMInspection1.TXTConnection.Text)
        InspectionRecord.ElectricalLight = CheckBlank(FRMInspection1.TXTLightBulb.Text)
        InspectionRecord.ElectricalOther = CheckBlank(FRMInspection1.TXTEOther.Text)
        InspectionRecord.RepairWeld = CheckBlank(FRMInspection1.TXTWeldQuality.Text)
        InspectionRecord.RepairSealWaxing = CheckBlank(FRMInspection1.TXTSealWaxing.Text)
        InspectionRecord.RepairWaterIngress = CheckBlank(FRMInspection1.TXTWaterIngress.Text)
        InspectionRecord.RepairOther = CheckBlank(FRMInspection1.TXTROther.Text)
        InspectionRecord.PannelOther = CheckBlank(FRMInspection1.TXTPannelOther.Text)
        InspectionRecord.RepairFillerRepair = CheckBlank(FRMInspection1.TXTFillerRepair.Text)
    
        InspectionRecord.PanelFitment = CheckBlank(FRMInspection1.TXTFitment.Text)
        InspectionRecord.PanelAlighment = CheckBlank(FRMInspection1.TXTAlignment.Text)
    
    
        InspectionRecord.PolishingThrough = CheckBlank(FRMInspectionPaint.TXTThrough.Text)
        InspectionRecord.PolishingFlattingMarks = CheckBlank(FRMInspectionPaint.TXTFlattingMarks.Text)
        InspectionRecord.PolishingOverSpray = CheckBlank(FRMInspectionPaint.TXTOverspray.Text)
        InspectionRecord.PolishingOther = CheckBlank(FRMInspectionPaint.TXTOther.Text)
        InspectionRecord.FinishingTouchingUp = CheckBlank(FRMInspectionPaint.TXTTouchingUp.Text)
        InspectionRecord.FinishingPaint = CheckBlank(FRMInspectionPaint.TXTPaint.Text)
        InspectionRecord.FinishingBlackingOff = CheckBlank(FRMInspectionPaint.TXTBlackingOff.Text)
        InspectionRecord.FinishingOther = CheckBlank(FRMInspectionPaint.TXTFOther.Text)
        InspectionRecord.PaintingSandingMarks = CheckBlank(FRMInspectionPaint.TXTSandingMarks.Text)
        InspectionRecord.PaintingBareCorrosion = CheckBlank(FRMInspectionPaint.TXTBareCorrosion.Text)
        InspectionRecord.PaintingPaintRuns = CheckBlank(FRMInspectionPaint.TXTPaintRuns.Text)
        InspectionRecord.PaintingColourMatch = CheckBlank(FRMInspectionPaint.TXTColourMatch.Text)
        InspectionRecord.PaintingShrinkage = CheckBlank(FRMInspectionPaint.TXTShrinkage.Text)
        InspectionRecord.PaintingMaskingLines = CheckBlank(FRMInspectionPaint.TXTMaskingLines.Text)
        InspectionRecord.PaintingPaintEdge = CheckBlank(FRMInspectionPaint.TXTPaintEdge.Text)
        InspectionRecord.PaintingBlowins = CheckBlank(FRMInspectionPaint.TXTBlowins.Text)
        InspectionRecord.PaintingCleaning = CheckBlank(FRMInspectionPaint.TXTCleaning.Text)
        InspectionRecord.PaintingOther = CheckBlank(FRMInspectionPaint.TXTPOther.Text)
        InspectionRecord.PaintingDirtInPaint = CheckBlank(FRMInspectionPaint.TXTDirtInPaint.Text)
        
        
        If (FRMInspection3.TXTAdditional.Text <> "") Then
            InspectionRecord.AdditionalText = FRMInspection3.TXTAdditional.Text
        End If
        InspectionRecord.PanelEngineer = FRMInspection3.CBOPL.ItemData(FRMInspection3.CBOPL.ListIndex)
        InspectionRecord.PainterEngineer = FRMInspection3.CBOPM.ItemData(FRMInspection3.CBOPM.ListIndex)
        InspectionRecord.INSPMakeID = FRMInspection3.CBOMake.ItemData(FRMInspection3.CBOMake.ListIndex)
        InspectionRecord.INSPModelID = FRMInspection3.CBOModel.ItemData(FRMInspection3.CBOModel.ListIndex)
        
        If (FRMInspection3.CHKPartProblem.Value = afCheckBoxValueChecked) Then
            InspectionRecord.PartProblem = "Y"
        Else
            InspectionRecord.PartProblem = "N"
        End If
        If (FRMInspection3.CHKCleaningProblem.Value = afCheckBoxValueChecked) Then
            InspectionRecord.CleaningProblem = "Y"
        Else
            InspectionRecord.CleaningProblem = "N"
        End If
        
        
        If (vNewRecord = True) Then
            Call PDBCreateRecordBySchema(dbInspdata)
            Call PDBWriteRecord(dbInspdata, VarPtr(InspectionRecord))
            Call PDBUpdateRecord(dbInspdata)
        Else
            Call PDBFindRecordbyID(dbInspdata, vCurrentRecordID)
            Call PDBEditRecord(dbInspdata)
            Call PDBWriteRecord(dbInspdata, VarPtr(InspectionRecord))
            Call PDBUpdateRecord(dbInspdata)
        End If
        
        FRMMain.RefreshScreen
    Else
        Call MsgBox("No Reg Entered", vbExclamation)
    End If
End Sub

Public Sub ViewInspection(pReg As String)
    Dim InspectionRecord As tInspdataRecord
    Dim i As Long
    vNewRecord = False
    Call PDBSetSort(dbInspdata, tInspdataDatabaseFields.Registration_Field)
    Call PDBFindRecordByField(dbInspdata, tInspdataDatabaseFields.Registration_Field, pReg)
    Call PDBReadRecord(dbInspdata, VarPtr(InspectionRecord))
    
    FRMInspection1.TXTReg.Text = InspectionRecord.Registration
    If (InspectionRecord.Internal = True) Then
        FRMInspection3.OPTInspectionType(0).Value = True
    Else
        FRMInspection3.OPTInspectionType(1).Value = True
    End If
    
    
    vCurrentRecordID = PDBRecordUniqueID(dbInspdata)
    
    FRMInspection1.TXTInsecure.Text = RemoveZero(InspectionRecord.PartInsecure)
    FRMInspection1.TXTWrongPart.Text = RemoveZero(InspectionRecord.PartWongPart)
    FRMInspection1.TXTNotWorking.Text = RemoveZero(InspectionRecord.PartNotWorking)
    FRMInspection1.TXTOther.Text = RemoveZero(InspectionRecord.PartOther)
    FRMInspection1.TXTWiring.Text = RemoveZero(InspectionRecord.ElectricalWiring)
    FRMInspection1.TXTConnection.Text = RemoveZero(InspectionRecord.ElectricalConnection)
    FRMInspection1.TXTLightBulb.Text = RemoveZero(InspectionRecord.ElectricalLight)
    FRMInspection1.TXTEOther.Text = RemoveZero(InspectionRecord.ElectricalOther)
    FRMInspection1.TXTWeldQuality.Text = RemoveZero(InspectionRecord.RepairWeld)
    FRMInspection1.TXTSealWaxing.Text = RemoveZero(InspectionRecord.RepairSealWaxing)
    FRMInspection1.TXTWaterIngress.Text = RemoveZero(InspectionRecord.RepairWaterIngress)
    FRMInspection1.TXTROther.Text = RemoveZero(InspectionRecord.RepairOther)
    FRMInspection1.TXTPannelOther.Text = RemoveZero(InspectionRecord.PannelOther)
    FRMInspection1.TXTFillerRepair.Text = RemoveZero(InspectionRecord.RepairFillerRepair)
    
    FRMInspection1.TXTFitment.Text = RemoveZero(InspectionRecord.PanelFitment)
    FRMInspection1.TXTAlignment.Text = RemoveZero(InspectionRecord.PanelAlighment)
    
    Call LoadDetails(InspectionRecord.AdditionalText, InspectionRecord.PolishingThrough, InspectionRecord.PolishingFlattingMarks, InspectionRecord.PolishingOverSpray, InspectionRecord.PolishingOther, InspectionRecord.FinishingTouchingUp, InspectionRecord.FinishingPaint, InspectionRecord.FinishingBlackingOff, InspectionRecord.FinishingOther, InspectionRecord.PaintingSandingMarks, InspectionRecord.PaintingBareCorrosion, InspectionRecord.PaintingPaintRuns, InspectionRecord.PaintingColourMatch, InspectionRecord.PaintingShrinkage, InspectionRecord.PaintingMaskingLines, InspectionRecord.PaintingPaintEdge, InspectionRecord.PaintingBlowins, InspectionRecord.PaintingCleaning, InspectionRecord.PaintingOther)
    FRMInspectionPaint.TXTDirtInPaint.Text = RemoveZero(InspectionRecord.PaintingDirtInPaint)
    
    FRMInspection3.TXTAdditional.Text = InspectionRecord.AdditionalText
    If (InspectionRecord.PartProblem = "Y") Then
        FRMInspection3.CHKPartProblem.Value = afCheckBoxValueChecked
    Else
        FRMInspection3.CHKPartProblem.Value = afCheckBoxValueUnchecked
    End If
    If (InspectionRecord.CleaningProblem = "Y") Then
        FRMInspection3.CHKCleaningProblem.Value = afCheckBoxValueChecked
    Else
        FRMInspection3.CHKCleaningProblem.Value = afCheckBoxValueUnchecked
    End If
    
    For i = 0 To FRMInspection3.CBOPL.ListCount - 1
        If (FRMInspection3.CBOPL.ItemData(i) = InspectionRecord.PanelEngineer) Then
            FRMInspection3.CBOPL.ListIndex = i
            Exit For
        End If
    Next
    For i = 0 To FRMInspection3.CBOPM.ListCount - 1
        If (FRMInspection3.CBOPM.ItemData(i) = InspectionRecord.PainterEngineer) Then
            FRMInspection3.CBOPM.ListIndex = i
            Exit For
        End If
    Next
    
    For i = 0 To FRMInspection3.CBOMake.ListCount - 1
        If (FRMInspection3.CBOMake.ItemData(i) = InspectionRecord.PanelEngineer) Then
            FRMInspection3.CBOMake.ListIndex = i
            Exit For
        End If
    Next
    For i = 0 To FRMInspection3.CBOModel.ListCount - 1
        If (FRMInspection3.CBOModel.ItemData(i) = InspectionRecord.PainterEngineer) Then
            FRMInspection3.CBOModel.ListIndex = i
            Exit For
        End If
    Next
    
    
    FRMInspection1.Show
    Call FRMInspection1.TXTReg.SetFocus
End Sub


Public Sub NewInspection()
    vNewRecord = True
    FRMInspection1.TXTReg.Text = ""
    FRMInspection3.OPTInspectionType(0).Value = True
    FRMInspection1.TXTInsecure.Text = ""
    FRMInspection1.TXTWrongPart.Text = ""
    FRMInspection1.TXTNotWorking.Text = ""
    FRMInspection1.TXTOther.Text = ""
    FRMInspection1.TXTWiring.Text = ""
    FRMInspection1.TXTConnection.Text = ""
    FRMInspection1.TXTLightBulb.Text = ""
    FRMInspection1.TXTEOther.Text = ""
    FRMInspection1.TXTWeldQuality.Text = ""
    FRMInspection1.TXTSealWaxing.Text = ""
    FRMInspection1.TXTWaterIngress.Text = ""
    FRMInspection1.TXTROther.Text = ""
    FRMInspection1.TXTPannelOther.Text = ""
    FRMInspection1.TXTFillerRepair.Text = ""
    
    FRMInspection1.TXTFitment.Text = ""
    FRMInspection1.TXTAlignment.Text = ""
    
    FRMInspectionPaint.TXTThrough.Text = ""
    FRMInspectionPaint.TXTFlattingMarks.Text = ""
    FRMInspectionPaint.TXTOverspray.Text = ""
    FRMInspectionPaint.TXTOther.Text = ""
    FRMInspectionPaint.TXTTouchingUp.Text = ""
    FRMInspectionPaint.TXTPaint.Text = ""
    FRMInspectionPaint.TXTBlackingOff.Text = ""
    FRMInspectionPaint.TXTFOther.Text = ""
    FRMInspectionPaint.TXTSandingMarks.Text = ""
    FRMInspectionPaint.TXTBareCorrosion.Text = ""
    FRMInspectionPaint.TXTPaintRuns.Text = ""
    FRMInspectionPaint.TXTColourMatch.Text = ""
    FRMInspectionPaint.TXTShrinkage.Text = ""
    FRMInspectionPaint.TXTMaskingLines.Text = ""
    FRMInspectionPaint.TXTPaintEdge.Text = ""
    FRMInspectionPaint.TXTBlowins.Text = ""
    FRMInspectionPaint.TXTCleaning.Text = ""
    FRMInspectionPaint.TXTPOther.Text = ""
    FRMInspectionPaint.TXTDirtInPaint.Text = ""
    
    FRMInspection3.CBOMake.ListIndex = 0
    FRMInspection3.CBOModel.ListIndex = 0
    FRMInspection3.CBOPL.ListIndex = 0
    FRMInspection3.CBOPM.ListIndex = 0
    FRMInspection3.TXTAdditional.Text = ""
    
    FRMInspection1.Show
    Call FRMInspection1.TXTReg.SetFocus
End Sub

Private Function RemoveZero(pNumber As Long) As String
    If (pNumber > 0) Then
        RemoveZero = pNumber
    Else
        RemoveZero = ""
    End If
End Function

Private Function CheckBlank(pNumber As String) As Long
    If (pNumber <> "") Then
        CheckBlank = CLng(pNumber)
    End If
End Function


'' Used to populate details from first form
Public Sub LoadDetails(pAdditional As String, pThrough As Long, pFlattingMarks As Long _
, pOverSpray As Long, pOther As Long, pTouchingUp As Long, pPaint As Long, pBlackingoff As Long _
, pFOther As Long, pSandingMarks As Long, pBareCorrosion As Long, pPaintRuns As Long _
, pColourMatch As Long, pShrinkage As Long, pMaskingLines As Long, pPaintEdge As Long _
, pBlowins As Long, pCleaning As Long, ppOther As Long)

    FRMInspectionPaint.TXTThrough.Text = RemoveZero(pThrough)
    FRMInspectionPaint.TXTFlattingMarks.Text = RemoveZero(pFlattingMarks)
    FRMInspectionPaint.TXTOverspray.Text = RemoveZero(pOverSpray)
    FRMInspectionPaint.TXTOther.Text = RemoveZero(pOther)
    FRMInspectionPaint.TXTTouchingUp.Text = RemoveZero(pTouchingUp)
    FRMInspectionPaint.TXTPaint.Text = RemoveZero(pPaint)
    FRMInspectionPaint.TXTBlackingOff.Text = RemoveZero(pBlackingoff)
    FRMInspectionPaint.TXTFOther.Text = RemoveZero(pFOther)
    FRMInspectionPaint.TXTSandingMarks.Text = RemoveZero(pSandingMarks)
    FRMInspectionPaint.TXTBareCorrosion.Text = RemoveZero(pBareCorrosion)
    FRMInspectionPaint.TXTPaintRuns.Text = RemoveZero(pPaintRuns)
    FRMInspectionPaint.TXTColourMatch.Text = RemoveZero(pColourMatch)
    FRMInspectionPaint.TXTShrinkage.Text = RemoveZero(pShrinkage)
    FRMInspectionPaint.TXTMaskingLines.Text = RemoveZero(pMaskingLines)
    FRMInspectionPaint.TXTPaintEdge.Text = RemoveZero(pPaintEdge)
    FRMInspectionPaint.TXTBlowins.Text = RemoveZero(pBlowins)
    FRMInspectionPaint.TXTCleaning.Text = RemoveZero(pCleaning)
    FRMInspectionPaint.TXTPOther.Text = RemoveZero(ppOther)
End Sub


