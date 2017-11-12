Attribute VB_Name = "modReturnDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: D:\coding\palmos\bodywork2\carparts.mdb
'     Source Table   : Return
'
'     Num Records    : 0
'
'     PDB Table Name : Return
'          CreatorID : 0001
'          TypeID    : DATA
'
'     Converted Time : 16/11/2001 02:38:56 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const Return_CreatorID As Long = &H30303031
Public Const Return_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbReturn As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tReturnDatabaseFields
	UID_Field = 0
	PartCode_Field = 1
	PartComment_Field = 2
	PartType_Field = 3
	HourNew_Field = 4
	FractionNew_Field = 5
	HourRepair_Field = 6
	FractionRepair_Field = 7
	HourPaint_Field = 8
	FractionPaint_Field = 9
	HourRefit_Field = 10
	FractionRefit_Field = 11
End Enum

Public Type tReturnRecord
	UID As Long
	PartCode As String
	PartComment As String
	PartType As Long	'0=new,1=repair,2=paint,3=refit
	HourNew As Long
	FractionNew As Long
	HourRepair As Long
	FractionRepair As Long
	HourPaint As Long
	FractionPaint As Long
	HourRefit As Long
	FractionRefit As Long
End Type


Public Function OpenReturnDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbReturn = PDBOpen(Byfilename, "Return", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbReturn = PDBOpen(Byfilename, App.Path & "\Return", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbReturn <> 0 Then
		'We successfully opened the database
		OpenReturnDatabase = True

	Else
		'We failed to open the database
		OpenReturnDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - Return", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\Return.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseReturnDatabase()

	' Close the database
	PDBClose dbReturn
	dbReturn = 0

End Sub


Public Function ReadReturnRecord(MyRecord As tReturnRecord) As Boolean

	ReadReturnRecord = PDBReadRecord(dbReturn, VarPtr(MyRecord))

End Function


Public Function WriteReturnRecord(MyRecord As tReturnRecord) As Boolean

	WriteReturnRecord = PDBWriteRecord(dbReturn, VarPtr(MyRecord))

End Function
