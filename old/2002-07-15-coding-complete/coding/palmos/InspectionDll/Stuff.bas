Attribute VB_Name = "Stuff"
Option Explicit
Public vrecord As tInspdataRecord


Public Type tINSPMakeRecord
        UID As Long
        Name As String
        ShortName As String
End Type


Public Type tINSPModelRecord
        UID As Long
        MakeID As Long
        StartYear As Long
        EndYear As Long
        Name As String
        ShortName As String
End Type


Public Type tInspdataRecord
        UID As Long
        INSPJobID As Long
        Registration As String
        INSPMakeID As Long      'Make
        INSPModelID As Long     'Model Number
        PartInsecure As Long
        PartWongPart As Long
        PartNotWorking As Long
        PartOther As Long
        ElectricalWiring As Long
        ElectricalConnection As Long
        ElectricalLight As Long
        ElectricalOther As Long
        RepairWeld As Long
        RepairSealWaxing As Long
        RepairWaterIngress As Long
        RepairOther As Long
        RepairFillerRepair As Long
        PannelOther As Long
        Internal As Boolean
        Completed As Boolean
        InspectionDate As Date
        PolishingThrough As Long
        PolishingFlattingMarks As Long
        PolishingOverSpray As Long
        PolishingOther As Long
        FinishingTouchingUp As Long
        FinishingPaint As Long
        FinishingBlackingOff As Long
        FinishingOther As Long
        PaintingSandingMarks As Long
        PaintingBareCorrosion As Long
        PaintingPaintRuns As Long
        PaintingColourMatch As Long
        PaintingShrinkage As Long
        PaintingMaskingLines As Long
        PaintingPaintEdge As Long
        PaintingBlowins As Long
        PaintingCleaning As Long
        PaintingOther As Long
        PaintingDirtInPaint As Long
        AdditionalText As String
        PanelEngineer As Long
        PainterEngineer As Long
        PartProblem As String   '(Y-Yes,N-No)
        CleaningProblem As String       '(Y-Yes,N-No)
        PanelFitment As Long
        PanelAlighment As Long
End Type

Public Function ReadLong(pData As Variant, ByRef pIndex As Long) As Long
    Dim templong As Long
    Dim pUtility As New PDUtility
    Call pUtility.ByteArrayToDWORD(pData, pIndex, True, templong)
    pIndex = pIndex + 4
    ReadLong = templong
End Function

Public Function ReadString(pData As Variant, ByRef pIndex As Long) As String
    Do While (pData(pIndex) <> 0)
        ReadString = ReadString & Chr$(pData(pIndex))
        pIndex = pIndex + 1
    Loop
    pIndex = pIndex + 1
End Function

Public Function ReadDate(pData As Variant, ByRef pIndex As Long) As Date
    Dim tempdate As Date
    Dim datetemp As Long
    Dim pUtility As New PDUtility
    Call pUtility.ByteArrayToDWORD(pData, pIndex, True, datetemp)
    tempdate = "01/01/1904"
    If (datetemp < 0) Then
        tempdate = DateAdd("s", 2 ^ 31# - 1, tempdate)
        datetemp = (2 ^ 31# - 1) + datetemp
        datetemp = datetemp + 2
    End If
    pIndex = pIndex + 4
    tempdate = DateAdd("s", datetemp, tempdate)
    ReadDate = tempdate
End Function

Public Function ReadBoolean(pData As Variant, ByRef pIndex As Long) As Boolean
    If (pData(pIndex) = 0) Then
        vrecord.Completed = False
    Else
        vrecord.Completed = True
    End If
    pIndex = pIndex + 1
End Function
