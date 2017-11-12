Attribute VB_Name = "modINSPMakeDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: C:\coding\palmos\Inspection\PCSystem\Copy of BodyWork.mdb
'     Source Table   : INSPMake
'
'     Num Records    : 0
'
'     PDB Table Name : INSPMake
'          CreatorID : ELF1
'          TypeID    : DATA
'
'     Converted Time : 06/06/2002 11:23:48 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const INSPMake_CreatorID As Long = &H454C4631
Public Const INSPMake_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbINSPMake As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tINSPMakeDatabaseFields
	UID_Field = 0
	Name_Field = 1
	ShortName_Field = 2
End Enum

Public Type tINSPMakeRecord
	UID As Long
	Name As String
	ShortName As String
End Type


Public Function OpenINSPMakeDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbINSPMake = PDBOpen(Byfilename, "INSPMake", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbINSPMake = PDBOpen(Byfilename, App.Path & "\INSPMake", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbINSPMake <> 0 Then
		'We successfully opened the database
		OpenINSPMakeDatabase = True

	Else
		'We failed to open the database
		OpenINSPMakeDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - INSPMake", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\INSPMake.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseINSPMakeDatabase()

	' Close the database
	PDBClose dbINSPMake
	dbINSPMake = 0

End Sub


Public Function ReadINSPMakeRecord(MyRecord As tINSPMakeRecord) As Boolean

	ReadINSPMakeRecord = PDBReadRecord(dbINSPMake, VarPtr(MyRecord))

End Function


Public Function WriteINSPMakeRecord(MyRecord As tINSPMakeRecord) As Boolean

	WriteINSPMakeRecord = PDBWriteRecord(dbINSPMake, VarPtr(MyRecord))

End Function
