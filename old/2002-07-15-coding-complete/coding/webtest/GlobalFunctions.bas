Attribute VB_Name = "GlobalFunctions"
Option Explicit
''*************************************************************************
''
''
''

Public RecordsAffected As Long

''
Public Function ShowForm(pform As Form) As Boolean
    Call pform.Show
    Call pform.ZOrder
End Function

'' Used by all recordset functions, allows error check to be in one place
Public Function OpenRecordset(pRecordset As Recordset, pName As String, pType As Long, Optional pOption = 0, Optional pRunServerSide As Boolean = False) As Boolean
    On Error GoTo TableError
    ' DAO
    If (pRunServerSide = True) Then
        If (pOption = 0) Then
            Set pRecordset = db.OpenRecordset(pName, pType)
        Else
            Set pRecordset = db.OpenRecordset(pName, pType, pOption)
        End If
    Else
        If (pOption = 0) Then
            Set pRecordset = db.OpenRecordset(pName, pType)
        Else
            Set pRecordset = db.OpenRecordset(pName, pType, pOption)
        End If
    End If

    OpenRecordset = True
    Exit Function

TableError:
    If Err = 94 Then
        Resume 'next
    Else
        If (ErrorCheck(pName, "OpenRecordset")) Then
            Resume
        End If
        OpenRecordset = False
    End If
End Function



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Registory stuff



''
Public Sub AllFormsLoad(pform As Form)

End Sub

''
Public Sub AllFormsUnLoad(pform As Form)

End Sub

''
Public Sub AllFormsHide(pform As Form)

End Sub

''
Public Function GetCurrencyFromString(pString As String) As Currency
    If (Left$(pString, 1) = "£") Then
        GetCurrencyFromString = Val(Right$(pString, Len(pString) - 1))
    Else
        GetCurrencyFromString = Val(pString)
    End If
End Function


Public Function Execute(pSQL As String, Optional SuppressWarnings As Boolean = False) As Long
    On Error GoTo TableError

    Call db.Execute(pSQL)
    RecordsAffected = db.RecordsAffected
    Execute = RecordsAffected
    If (RecordsAffected = 0) Then
        If (SuppressWarnings = False) Then
            Call Messagebox("No recordset effected [" & pSQL & "]", vbExclamation)
        End If
    Else
    End If
    Exit Function
    
TableError:
    If (ErrorCheck(pSQL, "Execute")) Then
        Resume
    End If
    Execute = False
End Function


''
Public Function FormatCurrency(pNumber As Currency) As String
    FormatCurrency = Format(pNumber, cCurrencyFormat)
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
Public Function ProcessString(pString As String) As String
    ProcessString = Replace(pString, "'", "''")
    ProcessString = Replace(ProcessString, Chr$(124), "")
End Function
