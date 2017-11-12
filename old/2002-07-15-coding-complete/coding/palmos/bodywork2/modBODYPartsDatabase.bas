Attribute VB_Name = "modBODYPartsDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: D:\coding\palmos\bodywork2\carparts.mdb
'     Source Table   : BODYParts
'
'     Num Records    : 640
'
'     PDB Table Name : BODYParts
'          CreatorID : BODY
'          TypeID    : DATA
'
'     Converted Time : 07/12/2001 01:09:01 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const BODYParts_CreatorID As Long = &H424F4459
Public Const BODYParts_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbBODYParts As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tBODYPartsDatabaseFields
	UID_Field = 0
	ShortName_Field = 1
	LongName_Field = 2
End Enum

Public Type tBODYPartsRecord
	UID As Long
	ShortName As String
	LongName As String
End Type


Public Function OpenBODYPartsDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbBODYParts = PDBOpen(Byfilename, "BODYParts", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbBODYParts = PDBOpen(Byfilename, App.Path & "\BODYParts", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbBODYParts <> 0 Then
		'We successfully opened the database
		OpenBODYPartsDatabase = True

	Else
		'We failed to open the database
		OpenBODYPartsDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - BODYParts", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\BODYParts.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseBODYPartsDatabase()

	' Close the database
	PDBClose dbBODYParts
	dbBODYParts = 0

End Sub


Public Function ReadBODYPartsRecord(MyRecord As tBODYPartsRecord) As Boolean

	ReadBODYPartsRecord = PDBReadRecord(dbBODYParts, VarPtr(MyRecord))

End Function


Public Function WriteBODYPartsRecord(MyRecord As tBODYPartsRecord) As Boolean

	WriteBODYPartsRecord = PDBWriteRecord(dbBODYParts, VarPtr(MyRecord))

End Function
