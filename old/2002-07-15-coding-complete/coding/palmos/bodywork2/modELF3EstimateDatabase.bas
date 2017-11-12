Attribute VB_Name = "modELF3EstimateDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: C:\BodyWork.mdb
'     Source Table   : ELF3Estimate
'
'     Num Records    : 0
'
'     PDB Table Name : ELF3Estimate
'          CreatorID : ELF3
'          TypeID    : DATA
'
'     Converted Time : 12/07/2002 04:49:35 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const ELF3Estimate_CreatorID As Long = &H454C4633
Public Const ELF3Estimate_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbELF3Estimate As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tELF3EstimateDatabaseFields
	JobID_Field = 0
	EmployeeID_Field = 1
	Reg_Field = 2
	Name_Field = 3
	Make_Field = 4
	Model_Field = 5
	Year_Field = 6
	Colour_Field = 7
	TotalRefitTime_Field = 8
	TotalRepairTime_Field = 9
	TotalPaintTime_Field = 10
	TotalPanelTime_Field = 11
	TotalTime_Field = 12
	LabourRate_Field = 13
	PaintMaterialCost_Field = 14
	RecoveryCost_Field = 15
	AdditionalCost_Field = 16
End Enum

Public Type tELF3EstimateRecord
	JobID As Long
	EmployeeID As Long
	Reg As String
	Name As String
	Make As String
	Model As String
	Year As String
	Colour As String
	TotalRefitTime As Long
	TotalRepairTime As Long
	TotalPaintTime As Long
	TotalPanelTime As Long
	TotalTime As Long
	LabourRate As Long
	PaintMaterialCost As Long
	RecoveryCost As Long
	AdditionalCost As Long
End Type


Public Function OpenELF3EstimateDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbELF3Estimate = PDBOpen(Byfilename, "ELF3Estimate", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbELF3Estimate = PDBOpen(Byfilename, App.Path & "\ELF3Estimate", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbELF3Estimate <> 0 Then
		'We successfully opened the database
		OpenELF3EstimateDatabase = True

	Else
		'We failed to open the database
		OpenELF3EstimateDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - ELF3Estimate", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\ELF3Estimate.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseELF3EstimateDatabase()

	' Close the database
	PDBClose dbELF3Estimate
	dbELF3Estimate = 0

End Sub


Public Function ReadELF3EstimateRecord(MyRecord As tELF3EstimateRecord) As Boolean

	ReadELF3EstimateRecord = PDBReadRecord(dbELF3Estimate, VarPtr(MyRecord))

End Function


Public Function WriteELF3EstimateRecord(MyRecord As tELF3EstimateRecord) As Boolean

	WriteELF3EstimateRecord = PDBWriteRecord(dbELF3Estimate, VarPtr(MyRecord))

End Function
