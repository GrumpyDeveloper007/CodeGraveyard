Attribute VB_Name = "Module1"
Option Explicit

Public Const cRegistoryName As String = "StockFTSE"
''
Public Function ErrorCheck(Message As String, Optional pErrorContext As String) As Boolean
    If (Messagebox("ERROR:(" & pErrorContext & ").  " & Error$ & " has occurred.[" & Message & "]", vbRetryCancel) = vbCancel) Then
        ErrorCheck = False
        Screen.MousePointer = vbDefault
    Else
        ErrorCheck = True
    End If
End Function

''
Public Function Messagebox(pMessage As String, pParameters As VbMsgBoxStyle, Optional pCaption As String = "-1") As VbMsgBoxResult
    If (pCaption = "-1") Then
        Messagebox = MsgBox(pMessage, pParameters)
    Else
        Messagebox = MsgBox(pMessage, pParameters, pCaption)
    End If
End Function
