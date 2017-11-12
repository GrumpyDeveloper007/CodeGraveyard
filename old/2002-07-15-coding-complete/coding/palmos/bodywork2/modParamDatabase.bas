Attribute VB_Name = "modParamDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: D:\coding\palmos\bodywork2\carparts.mdb
'     Source Table   : Param
'
'     Num Records    : 0
'
'     PDB Table Name : Param
'          CreatorID : 0001
'          TypeID    : DATA
'
'     Converted Time : 16/11/2001 02:38:46 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const Param_CreatorID As Long = &H30303031
Public Const Param_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbParam As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tParamDatabaseFields
        UID_Field = 0
        pName_Field = 1
        pValue_Field = 2
End Enum

Public Type tParamRecord
        UID As Long
        pName As String
        pValue As String
End Type

Public ParamRecord As tParamRecord

Public Function OpenParamDatabase() As Boolean

        ' Open the database
        #If APPFORGE Then
        dbParam = PDBOpen(Byfilename, "Param", 0, 0, 0, 0, afModeReadWrite)
        #Else
        dbParam = PDBOpen(Byfilename, App.Path & "\Param", 0, 0, 0, 0, afModeReadWrite)
        #End If

        If dbParam <> 0 Then
                'We successfully opened the database
                OpenParamDatabase = True

        Else
                'We failed to open the database
                OpenParamDatabase = False
                #If APPFORGE Then
                MsgBox "Could not open database - Param", vbExclamation
                #Else
                MsgBox "Could not open database - " + App.Path + "\Param.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
                #End If
        End If

End Function


Public Sub CloseParamDatabase()

        ' Close the database
        PDBClose dbParam
        dbParam = 0

End Sub


Public Function ReadParamRecord(MyRecord As tParamRecord) As Boolean

        ReadParamRecord = PDBReadRecord(dbParam, VarPtr(MyRecord))

End Function


Public Function WriteParamRecord(MyRecord As tParamRecord) As Boolean

        WriteParamRecord = PDBWriteRecord(dbParam, VarPtr(MyRecord))

End Function
