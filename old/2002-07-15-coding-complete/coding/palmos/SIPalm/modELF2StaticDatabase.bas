Attribute VB_Name = "modELF2StaticDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: D:\coding\SimpleInvoice\PDAStructures.mdb
'     Source Table   : ELF2Static
'
'     Num Records    : 0
'
'     PDB Table Name : ELF2Static
'          CreatorID : ELF2
'          TypeID    : DATA
'
'     Converted Time : 06/02/2002 12:58:17 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const ELF2Static_CreatorID As Long = &H454C4632
Public Const ELF2Static_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbELF2Static As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tELF2StaticDatabaseFields
	LastInvoice_Field = 0
End Enum

Public Type tELF2StaticRecord
	LastInvoice As Long
End Type


Public Function OpenELF2StaticDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbELF2Static = PDBOpen(Byfilename, "ELF2Static", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbELF2Static = PDBOpen(Byfilename, App.Path & "\ELF2Static", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbELF2Static <> 0 Then
		'We successfully opened the database
		OpenELF2StaticDatabase = True

	Else
		'We failed to open the database
		OpenELF2StaticDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - ELF2Static", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\ELF2Static.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseELF2StaticDatabase()

	' Close the database
	PDBClose dbELF2Static
	dbELF2Static = 0

End Sub


Public Function ReadELF2StaticRecord(MyRecord As tELF2StaticRecord) As Boolean

	ReadELF2StaticRecord = PDBReadRecord(dbELF2Static, VarPtr(MyRecord))

End Function


Public Function WriteELF2StaticRecord(MyRecord As tELF2StaticRecord) As Boolean

	WriteELF2StaticRecord = PDBWriteRecord(dbELF2Static, VarPtr(MyRecord))

End Function
