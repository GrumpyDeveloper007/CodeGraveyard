Attribute VB_Name = "GlobalDeclarations"
Option Explicit
''
'' Coded by Dale Pitman
''
Public Const TblPriceList As String = "PriceListCSFCMA"
Public Const TblModels As String = "ApplianceProductCSFIMB"

Public Const pi As Double = 3.14159265358979

'' used in user defined controls (TxtBox)
Public Enum NavigationENUM
    NAVNONE = 0
    NAVEnter = 1
    NAVCursor = 2
    NAVCursorEnter = 3
End Enum

Public Enum SMCOLOURS
    SMBlack = 0
    SMBlue = 1
    SMGreen = 2
    SMCyan = 3
    SMRed = 4
    SMMagenta = 5
    SMYellow = 6
    SMWhite = 7
    SMGray = 8
    SMLight_Blue = 9
    SMLight_Green = 10
    SMLight_Cyan = 11
    SMLight_Red = 12
    SMLight_Magenta = 13
    SMLight_Yellow = 14
    SMBright_White = 15
End Enum

Public Enum CallDataEnum
    NoData = 0
    CustomerOnly = 1
    CustomerAndAppliance = 2
    CustomerApplianceAndCall = 3
End Enum


'Main System Database
Global SysDB As Database

'Main Settings Database
Global SetDB As Database


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' API References

'' Graphics operations
'Public Declare Function GetPixel Lib "gdi32" _
'(ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long

'Public Declare Function SetPixelV Lib "gdi32" _
'(ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long



