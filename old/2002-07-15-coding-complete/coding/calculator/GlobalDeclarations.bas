Attribute VB_Name = "GlobalDeclarations"
Option Explicit
''*************************************************************************
''
'' Coded by Dale Pitman

Public Const pi As Double = 3.14159265358979

'' used in user defined controls (TxtBox)
Public Enum NavigationENUM
    NAVNONE = 0
    NAVEnter = 1
    NAVCursor = 2
    NAVCursorEnter = 3
End Enum

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' API References

'' Graphics operations
'Public Declare Function GetPixel Lib "gdi32" _
'(ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long

'Public Declare Function SetPixelV Lib "gdi32" _
'(ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long



