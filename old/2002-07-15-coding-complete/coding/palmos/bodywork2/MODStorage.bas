Attribute VB_Name = "MODStorage"

Option Explicit

Public PartName(100) As String
Public Description(100) As String
Public Additional(100) As String
Public RepairType(100) As Byte
Public Times(100, 8) As Byte
Public MaxPartIndex As Integer

Public PartsRecord As tBODYPartsRecord

Public vInspectionEmpolyee As Long
Public vInspectionEmpolyeeRecordID As Long
Public vInspectionEmpolyeeFound As Boolean

