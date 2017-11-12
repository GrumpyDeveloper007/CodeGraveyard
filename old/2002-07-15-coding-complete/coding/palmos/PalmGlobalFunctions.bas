Attribute VB_Name = "PalmGlobalFunctions"
Option Explicit

Public Const cCurrencySymbol As String = "£"     ' must be 1 char
Public Const cCurrencyFormat As String = cCurrencySymbol & "#####0.00"

''
Public Function RemoveNonNumericCharacters(pString As String, pMaxLength As Long) As String
    Dim i As Long
    Dim char As Long
    RemoveNonNumericCharacters = ""
    For i = 1 To Len(pString)
        char = Asc(Mid$(pString, i, 1))
        If ((char >= Asc("0") And char <= Asc("9")) Or char = Asc(".") Or char = Asc("+") Or char = Asc("-")) Then
            RemoveNonNumericCharacters = RemoveNonNumericCharacters & Chr$(char)
        End If
    Next
    RemoveNonNumericCharacters = Left$(RemoveNonNumericCharacters, pMaxLength)
End Function

''
Public Function FormatCurrency(pNumber As Single) As String
    FormatCurrency = cCurrencySymbol & CStr(pNumber)
End Function

