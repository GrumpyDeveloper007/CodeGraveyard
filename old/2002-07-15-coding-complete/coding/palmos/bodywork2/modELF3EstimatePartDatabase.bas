Attribute VB_Name = "modELF3EstimatePartDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: C:\BodyWork.mdb
'     Source Table   : ELF3EstimatePart
'
'     Num Records    : 0
'
'     PDB Table Name : ELF3EstimatePart
'          CreatorID : ELF3
'          TypeID    : DATA
'
'     Converted Time : 12/07/2002 04:49:48 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const ELF3EstimatePart_CreatorID As Long = &H454C4633
Public Const ELF3EstimatePart_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbELF3EstimatePart As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tELF3EstimatePartDatabaseFields
	JobID_Field = 0
	PartCodeID_Field = 1
	RefitTime_Field = 2
	RepairTime_Field = 3
	PaintTime_Field = 4
	PanelTime_Field = 5
	Operation_Field = 6
End Enum

Public Type tELF3EstimatePartRecord
	JobID As Long
	PartCodeID As Long
	RefitTime As Long
	RepairTime As Long
	PaintTime As Long
	PanelTime As Long
	Operation As Long	'1-New,2-Repair,3-Paint,4-Refit
End Type


Public Function OpenELF3EstimatePartDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbELF3EstimatePart = PDBOpen(Byfilename, "ELF3EstimatePart", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbELF3EstimatePart = PDBOpen(Byfilename, App.Path & "\ELF3EstimatePart", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbELF3EstimatePart <> 0 Then
		'We successfully opened the database
		OpenELF3EstimatePartDatabase = True

	Else
		'We failed to open the database
		OpenELF3EstimatePartDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - ELF3EstimatePart", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\ELF3EstimatePart.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseELF3EstimatePartDatabase()

	' Close the database
	PDBClose dbELF3EstimatePart
	dbELF3EstimatePart = 0

End Sub


Public Function ReadELF3EstimatePartRecord(MyRecord As tELF3EstimatePartRecord) As Boolean

	ReadELF3EstimatePartRecord = PDBReadRecord(dbELF3EstimatePart, VarPtr(MyRecord))

End Function


Public Function WriteELF3EstimatePartRecord(MyRecord As tELF3EstimatePartRecord) As Boolean

	WriteELF3EstimatePartRecord = PDBWriteRecord(dbELF3EstimatePart, VarPtr(MyRecord))

End Function
