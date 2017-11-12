Attribute VB_Name = "modINSPModelDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: C:\coding\palmos\Inspection\PCSystem\Copy of BodyWork.mdb
'     Source Table   : INSPModel
'
'     Num Records    : 0
'
'     PDB Table Name : INSPModel
'          CreatorID : ELF1
'          TypeID    : DATA
'
'     Converted Time : 06/06/2002 11:23:58 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const INSPModel_CreatorID As Long = &H454C4631
Public Const INSPModel_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbINSPModel As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tINSPModelDatabaseFields
	UID_Field = 0
	MakeID_Field = 1
	StartYear_Field = 2
	EndYear_Field = 3
	Name_Field = 4
	ShortName_Field = 5
End Enum

Public Type tINSPModelRecord
	UID As Long
	MakeID As Long
	StartYear As Long
	EndYear As Long
	Name As String
	ShortName As String
End Type


Public Function OpenINSPModelDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbINSPModel = PDBOpen(Byfilename, "INSPModel", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbINSPModel = PDBOpen(Byfilename, App.Path & "\INSPModel", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbINSPModel <> 0 Then
		'We successfully opened the database
		OpenINSPModelDatabase = True

	Else
		'We failed to open the database
		OpenINSPModelDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - INSPModel", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\INSPModel.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseINSPModelDatabase()

	' Close the database
	PDBClose dbINSPModel
	dbINSPModel = 0

End Sub


Public Function ReadINSPModelRecord(MyRecord As tINSPModelRecord) As Boolean

	ReadINSPModelRecord = PDBReadRecord(dbINSPModel, VarPtr(MyRecord))

End Function


Public Function WriteINSPModelRecord(MyRecord As tINSPModelRecord) As Boolean

	WriteINSPModelRecord = PDBWriteRecord(dbINSPModel, VarPtr(MyRecord))

End Function
