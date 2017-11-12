Attribute VB_Name = "GlobalFunctions"
Option Explicit
''*************************************************************************
''
''
''

Public RecordsAffected As Long

Public Const cThickLine As Long = 4
Public Const cThinLine As Long = 1

Public Const cCurrencySymbol As String = "£"     ' must be 1 char
'Public Const cCurrencyFormat As String = cCurrencySymbol & "#####0.00"



''
Public Function ShowForm(pForm As Form) As Boolean
    Call pForm.Show
    Call pForm.ZOrder
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Registory stuff


''
Public Sub AllFormsLoad(pForm As Form)

End Sub

''
Public Sub AllFormsUnLoad(pForm As Form)

End Sub

''
Public Sub AllFormsHide(pForm As Form)

End Sub

''
Public Function GetCurrencyFromString(pString As String) As Currency
    If (Left$(pString, 1) = "£") Then
        GetCurrencyFromString = Val(Right$(pString, Len(pString) - 1))
    Else
        GetCurrencyFromString = Val(pString)
    End If
End Function

''
Public Function IsInGrid(pGrdName As fpList, pMatchVal As Long, pColoumn As Long) As Long
    Dim i As Long

    IsInGrid = -1
    pGrdName.Col = pColoumn
    For i = 0 To pGrdName.ListCount - 1
        pGrdName.row = i
        If (pMatchVal = pGrdName.ColList) Then
            IsInGrid = i
            Exit For
        End If
    Next
End Function

''
Public Function IsInGridString(pGrdName As fpList, pMatchVal As String, pColoumn As Long) As Long
    Dim i As Long

    IsInGridString = -1
    pGrdName.Col = pColoumn
    For i = 0 To pGrdName.ListCount - 1
        pGrdName.row = i
        If (pMatchVal = pGrdName.ColList) Then
            IsInGridString = i
            Exit For
        End If
    Next
End Function

'' Binary AND operation, used by classes in search function
Public Function BAnd(pValue1 As Long, pvalue2 As Long) As Boolean
    If ((pValue1 And pvalue2) > 0) Then
        BAnd = True
    Else
        BAnd = False
    End If
End Function



''
Public Function FilterString(pString As String) As String
    Dim pos As Long
    pos = InStr(pString, Chr$(34))
    FilterString = ""
    Do While (pos > 0)
        FilterString = FilterString & Left$(pString, pos) & Chr$(34)
        pString = Right$(pString, Len(pString) - pos)
        pos = InStr(pString, Chr$(34))
    Loop
    FilterString = FilterString & pString
End Function

''
Public Function AutoWidth(pString As String, pWidth As Long) As String
        pString = Trim$(Replace(Trim$(pString), vbCrLf, ""))
        Do While (Len(pString) > pWidth)
            If (InStr(pWidth, pString, " ") > 0) Then
                AutoWidth = AutoWidth & Left(pString, InStr(pWidth, pString, " ")) & Chr$(13)
                pString = Mid(pString, InStr(pWidth, pString, " "))
            Else
                AutoWidth = AutoWidth & Left$(pString, pWidth) & Chr$(13)
                pString = Mid(pString, pWidth)
            End If
        Loop
        AutoWidth = AutoWidth & pString & Chr$(13)
End Function

''
Public Function SecondsToTime2(pSeconds As Long) As String
    If (pSeconds > 60) Then
        SecondsToTime2 = Format(pSeconds \ 60, "00") & ":" & Format(pSeconds Mod 60, "00")
    Else
        SecondsToTime2 = "00:" & Format(pSeconds, "00")
    End If
End Function

''
Public Function Pad(pString As String, pSpaces As Long) As String
    Dim i As Long
    Dim TempString As String
    For i = 1 To pSpaces
        TempString = TempString & "@"
    Next
    Pad = Format(pString, TempString)
End Function
    

''
Public Function CenterString(pString As String) As Long
    'A4 page = 210mm (width x 58) = 12180
    CenterString = (Printer.Width - (Len(pString) * (Printer.FontSize * 13))) / 2
End Function

''
Public Sub PrintX(pXPos As Long, pString As String, Optional NewLine As Boolean = False)
    Printer.CurrentX = pXPos
    If (NewLine = False) Then
        Printer.Print pString;
    Else
        Printer.Print pString
    End If
End Sub

