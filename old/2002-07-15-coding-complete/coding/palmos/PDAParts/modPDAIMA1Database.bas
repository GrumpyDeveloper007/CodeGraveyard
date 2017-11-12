Attribute VB_Name = "modPDAIMA1Database"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: D:\coding\palmos\PDAParts\parts.mdb
'     Source Table   : PDAIMA1
'
'     Num Records    : 65001
'
'     PDB Table Name : PDAIMA1
'          CreatorID : dale
'          TypeID    : DATA
'
'     Converted Time : 02/12/2001 04:02:39 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const PDAIMA1_CreatorID As Long = &H64616C65
Public Const PDAIMA1_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbPDAIMA1 As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tPDAIMA1DatabaseFields
	UID_Field = 0
	ManCode_Field = 1
	PartNumber_Field = 2
	PartDescription_Field = 3
	ReplacementPartNumber_Field = 4
	Retailprice1_Field = 5
	RetailPrice2_Field = 6
	RetailPrice3_Field = 7
	RetailPrice4_Field = 8
	RetailPrice5_Field = 9
	RetailDate1_Field = 10
	RetailDate2_Field = 11
	RetailDate3_Field = 12
	RetailDate4_Field = 13
	RetailDate5_Field = 14
End Enum

Public Type tPDAIMA1Record
	UID As Long
	ManCode As String
	PartNumber As String
	PartDescription As String
	ReplacementPartNumber As String	'Only allows replacement partnumbers with the same manufacturer as the current partnumber
	Retailprice1 As Currency
	RetailPrice2 As Currency
	RetailPrice3 As Currency
	RetailPrice4 As Currency
	RetailPrice5 As Currency
	RetailDate1 As Date
	RetailDate2 As Date
	RetailDate3 As Date
	RetailDate4 As Date
	RetailDate5 As Date
End Type


Public Function OpenPDAIMA1Database() As Boolean

	' Open the database
	#If APPFORGE Then
	dbPDAIMA1 = PDBOpen(Byfilename, "PDAIMA1", 0, 0, 0, 0, afModeReadWrite)
	#Else
	dbPDAIMA1 = PDBOpen(Byfilename, App.Path & "\PDAIMA1", 0, 0, 0, 0, afModeReadWrite)
	#End If

	If dbPDAIMA1 <> 0 Then
		'We successfully opened the database
		OpenPDAIMA1Database = True

	Else
		'We failed to open the database
		OpenPDAIMA1Database = False
		#If APPFORGE Then
		MsgBox "Could not open database - PDAIMA1", vbExclamation
		#Else
		MsgBox "Could not open database - " + App.Path + "\PDAIMA1.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
		#End If
	End If

End Function


Public Sub ClosePDAIMA1Database()

	' Close the database
	PDBClose dbPDAIMA1
	dbPDAIMA1 = 0

End Sub


Public Function ReadPDAIMA1Record(MyRecord As tPDAIMA1Record) As Boolean

	ReadPDAIMA1Record = PDBReadRecord(dbPDAIMA1, VarPtr(MyRecord))

End Function


Public Function WritePDAIMA1Record(MyRecord As tPDAIMA1Record) As Boolean

	WritePDAIMA1Record = PDBWriteRecord(dbPDAIMA1, VarPtr(MyRecord))

End Function
