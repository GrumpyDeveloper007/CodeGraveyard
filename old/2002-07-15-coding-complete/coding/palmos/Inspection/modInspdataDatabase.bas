Attribute VB_Name = "modInspdataDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: C:\coding\palmos\Inspection\PCSystem\Copy of BodyWork.mdb
'     Source Table   : Inspdata
'
'     Num Records    : 0
'
'     PDB Table Name : Inspdata
'          CreatorID : ELF1
'          TypeID    : DATA
'
'     Converted Time : 06/06/2002 11:23:27 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const Inspdata_CreatorID As Long = &H454C4631
Public Const Inspdata_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbInspdata As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tInspdataDatabaseFields
	UID_Field = 0
	INSPJobID_Field = 1
	Registration_Field = 2
	INSPMakeID_Field = 3
	INSPModelID_Field = 4
	PartInsecure_Field = 5
	PartWongPart_Field = 6
	PartNotWorking_Field = 7
	PartOther_Field = 8
	ElectricalWiring_Field = 9
	ElectricalConnection_Field = 10
	ElectricalLight_Field = 11
	ElectricalOther_Field = 12
	RepairWeld_Field = 13
	RepairSealWaxing_Field = 14
	RepairWaterIngress_Field = 15
	RepairOther_Field = 16
	RepairFillerRepair_Field = 17
	PannelOther_Field = 18
	Internal_Field = 19
	Completed_Field = 20
	InspectionDate_Field = 21
	PolishingThrough_Field = 22
	PolishingFlattingMarks_Field = 23
	PolishingOverSpray_Field = 24
	PolishingOther_Field = 25
	FinishingTouchingUp_Field = 26
	FinishingPaint_Field = 27
	FinishingBlackingOff_Field = 28
	FinishingOther_Field = 29
	PaintingSandingMarks_Field = 30
	PaintingBareCorrosion_Field = 31
	PaintingPaintRuns_Field = 32
	PaintingColourMatch_Field = 33
	PaintingShrinkage_Field = 34
	PaintingMaskingLines_Field = 35
	PaintingPaintEdge_Field = 36
	PaintingBlowins_Field = 37
	PaintingCleaning_Field = 38
	PaintingOther_Field = 39
	PaintingDirtInPaint_Field = 40
	AdditionalText_Field = 41
	PanelEngineer_Field = 42
	PainterEngineer_Field = 43
	PartProblem_Field = 44
	CleaningProblem_Field = 45
	PanelFitment_Field = 46
	PanelAlighment_Field = 47
End Enum

Public Type tInspdataRecord
	UID As Long
	INSPJobID As Long
	Registration As String
	INSPMakeID As Long	'Make
	INSPModelID As Long	'Model Number
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
	PartProblem As String	'(Y-Yes,N-No)
	CleaningProblem As String	'(Y-Yes,N-No)
	PanelFitment As Long
	PanelAlighment As Long
End Type


Public Function OpenInspdataDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbInspdata = PDBOpen(Byfilename, "Inspdata", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbInspdata = PDBOpen(Byfilename, App.Path & "\Inspdata", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbInspdata <> 0 Then
		'We successfully opened the database
		OpenInspdataDatabase = True

	Else
		'We failed to open the database
		OpenInspdataDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - Inspdata", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\Inspdata.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseInspdataDatabase()

	' Close the database
	PDBClose dbInspdata
	dbInspdata = 0

End Sub


Public Function ReadInspdataRecord(MyRecord As tInspdataRecord) As Boolean

	ReadInspdataRecord = PDBReadRecord(dbInspdata, VarPtr(MyRecord))

End Function


Public Function WriteInspdataRecord(MyRecord As tInspdataRecord) As Boolean

	WriteInspdataRecord = PDBWriteRecord(dbInspdata, VarPtr(MyRecord))

End Function
