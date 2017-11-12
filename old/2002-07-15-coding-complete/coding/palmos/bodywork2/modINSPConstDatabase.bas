Attribute VB_Name = "modINSPConstDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: C:\BodyWork.mdb
'     Source Table   : INSPConst
'
'     Num Records    : 0
'
'     PDB Table Name : INSPConst
'          CreatorID : ELF1
'          TypeID    : DATA
'
'     Converted Time : 12/07/2002 04:00:36 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const INSPConst_CreatorID As Long = &H454C4631
Public Const INSPConst_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbINSPConst As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tINSPConstDatabaseFields
	Name_Field = 0
	Value_Field = 1
End Enum

Public Type tINSPConstRecord
	Name As String
	Value As String
End Type


Public Function OpenINSPConstDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbINSPConst = PDBOpen(Byfilename, "INSPConst", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbINSPConst = PDBOpen(Byfilename, App.Path & "\INSPConst", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbINSPConst <> 0 Then
		'We successfully opened the database
		OpenINSPConstDatabase = True

	Else
		'We failed to open the database
		OpenINSPConstDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - INSPConst", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\INSPConst.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseINSPConstDatabase()

	' Close the database
	PDBClose dbINSPConst
	dbINSPConst = 0

End Sub


Public Function ReadINSPConstRecord(MyRecord As tINSPConstRecord) As Boolean

	ReadINSPConstRecord = PDBReadRecord(dbINSPConst, VarPtr(MyRecord))

End Function


Public Function WriteINSPConstRecord(MyRecord As tINSPConstRecord) As Boolean

	WriteINSPConstRecord = PDBWriteRecord(dbINSPConst, VarPtr(MyRecord))

End Function
