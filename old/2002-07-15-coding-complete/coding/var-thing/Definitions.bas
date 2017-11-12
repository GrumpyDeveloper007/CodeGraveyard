Attribute VB_Name = "Definitions"
Option Explicit
''*************************************************************************
''
''
'' Coded by Dale Pitman

Public AppPath As String
Public db As Database

Public Const dRecordSet As Long = 20
Public Const dField As Long = 21
Public Const dNode As Long = 22

Public Const cGlobal As Long = 1
Public Const cLocal As Long = 2
Public Const cUnknown As Long = 3

Public Type PropertyType
    Name As String
    Value As String
End Type

Public Type VaribleType
    Name As String
    Type As Long
    Used As Long
    Scope As Long           ' Only used in form level declares
End Type

Public Type ProcedureType
    Name As String
    FirstLine As Long
    LastLine As Long
    Varibles() As VaribleType
    NumVaribles As Long
    Used As Boolean             ' =False if any sub-objects contain unused varibles
End Type

Public Type ControlType
    Name As String
    Left As Long
    Top As Long
    Width As Long
    Height As Long
    Child As Long
    Next As Long
    index As Long
    Caption As String
    LineNumber As Long ' Line Number for caption field
    OtherProperties() As PropertyType
    NumOtherPropties As Long
End Type

Public Type TargetObjectType
    Name As String
    Lines() As String                   ' Stores the entire contence of the object
    NumberOfLines As Long               ' Number if lines in object
    Procedures() As ProcedureType       ' Provides information of all procedures/functions/propertys in object
    NumProcedures As Long
    GlobalVaribles() As VaribleType     ' Varibles defined at the top of the object
    NumGlobalVaribles As Long
    Used As Boolean                     ' =False if any sub-objects contain unused varibles
    Firstcontrol As Long
End Type

Public ControlStore(32767) As ControlType
Public NextFreeControl As Long

Public TargetObjects() As TargetObjectType
Public NumTargetObjects As Long

Public strings As New StringClass

Dim CurrentSection As String    ' text file stuff

Public Function GetScopeString(vScope As Long) As String
    Select Case vScope
        Case cGlobal
            GetScopeString = "Global"
        Case cLocal
            GetScopeString = "Local"
        Case cUnknown
            GetScopeString = "Unknown"
        Case Else
            Call MsgBox("ERROR")
    End Select
End Function

Public Function GetVarTypeString(vType As Long) As String
    Select Case vType
        Case vbInteger
            GetVarTypeString = "Integer"
        Case vbLong
            GetVarTypeString = "Long"
        Case vbSingle
            GetVarTypeString = "Single"
        Case vbDouble
            GetVarTypeString = "Double"
        Case vbCurrency
            GetVarTypeString = "Currency"
        Case vbDate
            GetVarTypeString = "Date"
        Case vbString
            GetVarTypeString = "String"
        Case vbObject
            GetVarTypeString = "Object"
        Case vbError
            GetVarTypeString = "Error"
        Case vbBoolean
            GetVarTypeString = "Boolean"
        Case vbVariant
            GetVarTypeString = "Variant"
        Case vbDataObject
            GetVarTypeString = "DataObject"
        Case vbDecimal
            GetVarTypeString = "Decimal"
        Case vbByte
            GetVarTypeString = "Byte"
        Case vbUserDefinedType
            GetVarTypeString = "UserDefinedType"
        Case vbArray
            GetVarTypeString = "Array"
        
        Case dRecordSet
            GetVarTypeString = "Recordset"
        Case dField
            GetVarTypeString = "Field"
        Case dNode
            GetVarTypeString = "Node"
        Case Else
            GetVarTypeString = "Unknown"
    End Select
End Function


Private Function ReadNextLine(FileID As Integer)
    Dim CurrentLine As String
    Dim IgnoreLine As Boolean
    If (EOF(FileID) = False) Then
        Line Input #FileID, CurrentLine
        CurrentLine = Trim(CurrentLine)
        
        IgnoreLine = False
        If (Left$(CurrentLine, 1) = "[" Or Left$(CurrentLine, 1) = ";" Or Len(CurrentLine) = 0) Then
            IgnoreLine = True
        End If
        Do While (IgnoreLine = True And EOF(FileID) = False)
            
            
            If (Left$(CurrentLine, 1) = "[") Then
                CurrentSection = Right$(Left$(CurrentLine, Len(CurrentLine) - 1), Len(CurrentLine) - 1)
            End If
            
            Line Input #FileID, CurrentLine
            CurrentLine = Trim$(CurrentLine)
            
            IgnoreLine = False
            If (Left$(CurrentLine, 1) = "[" Or Left$(CurrentLine, 1) = ";" Or Len(CurrentLine) = 0) Then
                IgnoreLine = True
            End If
        Loop
        
        'Change section
        ReadNextLine = Trim$(CurrentLine)
    Else
        ReadNextLine = ""
    End If
End Function



' NOTES:
'   problem fields -
'      field="Date"

'' Get field type name
Public Function GetFieldString(FieldNum As Long) As String
    Select Case FieldNum
        Case 10, 12
            GetFieldString = "String"
        Case 7, 4
            GetFieldString = "Long"
        Case 1
            GetFieldString = "String"
        Case 8
            GetFieldString = "Date"
        Case 5
            GetFieldString = "Currency"
    End Select
End Function

'' Get type field name (when declaired)
Public Function GetFieldStringDim(FieldNum As Long) As String
    Select Case FieldNum
        Case 10
            GetFieldStringDim = "String"
        Case 7, 4
            GetFieldStringDim = "Long"
        Case 8
            GetFieldStringDim = "Date"
        Case 1
            GetFieldStringDim = "String 'Logical type"
        Case 12
            GetFieldStringDim = "String 'Memo type"
        Case 5
            GetFieldStringDim = "Currency"
    End Select
End Function

