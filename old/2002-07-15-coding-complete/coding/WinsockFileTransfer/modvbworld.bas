Attribute VB_Name = "modvbworld"
Option Explicit
' VB-World.net global support library for demo projects
' John Percival, Feb '99


Public Const URL = "http://www.vb-world.net"
Public Const email = "john@vb-world.net"

Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Public Const SW_SHOWNORMAL = 1

Public Sub gotoweb()
Dim Success As Long

Success = ShellExecute(0&, vbNullString, URL, vbNullString, "C:\", SW_SHOWNORMAL)

End Sub

Public Sub sendemail()
Dim Success As Long

Success = ShellExecute(0&, vbNullString, "mailto:" & email, vbNullString, "C:\", SW_SHOWNORMAL)

End Sub

