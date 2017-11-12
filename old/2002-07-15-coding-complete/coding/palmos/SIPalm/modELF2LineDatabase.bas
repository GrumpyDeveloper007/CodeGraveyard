Attribute VB_Name = "modELF2LineDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: D:\coding\SimpleInvoice\PDAStructures.mdb
'     Source Table   : ELF2Line
'
'     Num Records    : 0
'
'     PDB Table Name : ELF2Line
'          CreatorID : ELF2
'          TypeID    : DATA
'
'     Converted Time : 06/02/2002 12:11:45 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const ELF2Line_CreatorID As Long = &H454C4632
Public Const ELF2Line_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbELF2Line As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tELF2LineDatabaseFields
	ELF2InvoiceID_Field = 0
	QTY_Field = 1
	Name_Field = 2
	Description_Field = 3
	UnitCost_Field = 4
	VatPercent_Field = 5
End Enum

Public Type tELF2LineRecord
	ELF2InvoiceID As Long
	QTY As Long
	Name As String
	Description As String
	UnitCost As Long
	VatPercent As Long
End Type


Public Function OpenELF2LineDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbELF2Line = PDBOpen(Byfilename, "ELF2Line", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbELF2Line = PDBOpen(Byfilename, App.Path & "\ELF2Line", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbELF2Line <> 0 Then
		'We successfully opened the database
		OpenELF2LineDatabase = True

	Else
		'We failed to open the database
		OpenELF2LineDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - ELF2Line", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\ELF2Line.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseELF2LineDatabase()

	' Close the database
	PDBClose dbELF2Line
	dbELF2Line = 0

End Sub


Public Function ReadELF2LineRecord(MyRecord As tELF2LineRecord) As Boolean

	ReadELF2LineRecord = PDBReadRecord(dbELF2Line, VarPtr(MyRecord))

End Function


Public Function WriteELF2LineRecord(MyRecord As tELF2LineRecord) As Boolean

	WriteELF2LineRecord = PDBWriteRecord(dbELF2Line, VarPtr(MyRecord))

End Function
