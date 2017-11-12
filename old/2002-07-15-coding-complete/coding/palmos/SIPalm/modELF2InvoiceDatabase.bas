Attribute VB_Name = "modELF2InvoiceDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: D:\coding\SimpleInvoice\PDAStructures.mdb
'     Source Table   : ELF2Invoice
'
'     Num Records    : 0
'
'     PDB Table Name : ELF2Invoice
'          CreatorID : ELF2
'          TypeID    : DATA
'
'     Converted Time : 06/02/2002 11:32:10 AM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const ELF2Invoice_CreatorID As Long = &H454C4632
Public Const ELF2Invoice_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbELF2Invoice As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tELF2InvoiceDatabaseFields
	UID_Field = 0
	Name_Field = 1
	CompanyName_Field = 2
	Title_Field = 3
	WorkNumber_Field = 4
	Address1_Field = 5
	Street1_Field = 6
	State_Field = 7
	Country_Field = 8
	PostCode_Field = 9
	Carriage_Field = 10
	PONumber_Field = 11
	InvoiceType_Field = 12
End Enum

Public Type tELF2InvoiceRecord
	UID As Long
	Name As String
	CompanyName As String
	Title As String
	WorkNumber As String
	Address1 As String
	Street1 As String
	State As String
	Country As String
	PostCode As String
	Carriage As Long
	PONumber As String
	InvoiceType As Long
End Type


Public Function OpenELF2InvoiceDatabase() As Boolean

	' Open the database
	#If APPFORGE Then
	dbELF2Invoice = PDBOpen(Byfilename, "ELF2Invoice", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbELF2Invoice = PDBOpen(Byfilename, App.Path & "\ELF2Invoice", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbELF2Invoice <> 0 Then
		'We successfully opened the database
		OpenELF2InvoiceDatabase = True

	Else
		'We failed to open the database
		OpenELF2InvoiceDatabase = False
		#If APPFORGE Then
		MsgBox "Could not open database - ELF2Invoice", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\ELF2Invoice.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub CloseELF2InvoiceDatabase()

	' Close the database
	PDBClose dbELF2Invoice
	dbELF2Invoice = 0

End Sub


Public Function ReadELF2InvoiceRecord(MyRecord As tELF2InvoiceRecord) As Boolean

	ReadELF2InvoiceRecord = PDBReadRecord(dbELF2Invoice, VarPtr(MyRecord))

End Function


Public Function WriteELF2InvoiceRecord(MyRecord As tELF2InvoiceRecord) As Boolean

	WriteELF2InvoiceRecord = PDBWriteRecord(dbELF2Invoice, VarPtr(MyRecord))

End Function
