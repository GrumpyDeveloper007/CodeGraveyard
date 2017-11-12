VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ErrorClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''
'' Utility class - Error
''
'' Description -
''   Provides simple way of logging/reporting/supressing error messages
''  from other classes/modules...


Private vLineNumber As String

''
Public Property Get LineNumber() As String
    LineNumber = vLineNumber
End Property

''
Public Property Let LineNumber(Line As String)
    vLineNumber = Line
End Property

''
Public Function DoError(Description As String) As Boolean
    Call MsgBox(vLineNumber & ":" & Description)
End Function
