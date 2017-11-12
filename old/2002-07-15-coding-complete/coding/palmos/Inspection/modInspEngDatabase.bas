Attribute VB_Name = "modInspEngDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: C:\coding\palmos\Inspection\PCSystem\Copy of BodyWork.mdb
'     Source Table   : InspEng
'
'     Num Records    : 0
'
'     PDB Table Name : InspEng
'          CreatorID : ELF1
'          TypeID    : DATA
'
'     Converted Time : 06/06/2002 11:23:38 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const InspEng_CreatorID As Long = &H454C4631
Public Const InspEng_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbInspEng As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tInspEngDatabaseFields
        UID_Field = 0
        Name_Field = 1
        ShortName_Field = 2
        Type_Field = 3
End Enum

Public Type tInspEngRecord
        UID As Long
        Name As String
        ShortName As String
        Type_ As String  'Type Code (PL-Panel beater,PM-Painter)
End Type


Public Function OpenInspEngDatabase() As Boolean

        ' Open the database
        #If APPFORGE Then
        dbInspEng = PDBOpen(Byfilename, "InspEng", 0, 0, 0, 0, afModeReadWrite)
        #Else
        dbInspEng = PDBOpen(Byfilename, App.Path & "\InspEng", 0, 0, 0, 0, afModeReadWrite)
        #End If

        If dbInspEng <> 0 Then
                'We successfully opened the database
                OpenInspEngDatabase = True

        Else
                'We failed to open the database
                OpenInspEngDatabase = False
                #If APPFORGE Then
                MsgBox "Could not open database - InspEng", vbExclamation
                #Else
                MsgBox "Could not open database - " + App.Path + "\InspEng.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
                #End If
        End If

End Function


Public Sub CloseInspEngDatabase()

        ' Close the database
        PDBClose dbInspEng
        dbInspEng = 0

End Sub


Public Function ReadInspEngRecord(MyRecord As tInspEngRecord) As Boolean

        ReadInspEngRecord = PDBReadRecord(dbInspEng, VarPtr(MyRecord))

End Function


Public Function WriteInspEngRecord(MyRecord As tInspEngRecord) As Boolean

        WriteInspEngRecord = PDBWriteRecord(dbInspEng, VarPtr(MyRecord))

End Function
