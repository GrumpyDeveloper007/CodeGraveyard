Attribute VB_Name = "GlobalFunctions"
Option Explicit
''*************************************************************************
''
''
''


Public Const cCurrencySymbol As String = "£"     ' must be 1 char
Public Const cCurrencyFormat As String = cCurrencySymbol & "#####0.00"

''
Public Function ShowForm(pform As Form) As Boolean
    Call pform.Show
    Call pform.ZOrder
End Function

''
Public Function Messagebox(pMessage As String, pParameters As VbMsgBoxStyle, Optional pCaption As String = "-1") As VbMsgBoxResult
    If (pCaption = "-1") Then
        Messagebox = MsgBox(pMessage, pParameters)
    Else
        Messagebox = MsgBox(pMessage, pParameters, pCaption)
    End If
End Function

''
Public Function ErrorCheck(Message As String, Optional pErrorContext As String) As Boolean
    If (Messagebox("ERROR:(" & pErrorContext & ").  " & Error$ & " has occurred.[" & Message & "]", vbRetryCancel) = vbCancel) Then
        ErrorCheck = False
        Screen.MousePointer = vbDefault
    Else
        ErrorCheck = True
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
Public Sub AllFormsShow(pform As Form)

End Sub

''
Public Function SetByItemCBO(pComboBox As ComboBox, pItemName As String) As Boolean
    Dim i As Long
    For i = 0 To pComboBox.ListCount - 1
        If (Left(pComboBox.List(i), Len(pItemName)) = pItemName) Then
            pComboBox.ListIndex = i
            Exit For
        End If
    Next
End Function

''
Public Function SetByItemDataCBO(pComboBox As ComboBox, pID As Long) As Boolean
    Dim i As Long
    For i = 0 To pComboBox.ListCount - 1
        If (pComboBox.ItemData(i) = pID) Then
            pComboBox.ListIndex = i
            Exit For
        End If
    Next
End Function

''
Public Function GetCurrencyFromStringX(pString As String) As Currency
    If (Left$(pString, 1) = cCurrencySymbol) Then
 '    If (Asc(Left$(pString, 1)) < Asc("0") And Asc(Left$(pString, 1)) > Asc("9")) Then
        GetCurrencyFromStringX = Val(Right$(pString, Len(pString) - 1))
    Else
        GetCurrencyFromStringX = Val(pString)
    End If
End Function


''
Public Function RemoveNonNumericCharacters(pString As String) As String
    Dim i As Long
    Dim char As Long
    RemoveNonNumericCharacters = ""
    For i = 1 To Len(pString)
        char = Asc(Mid$(pString, i, 1))
        If ((char >= Asc("0") And char <= Asc("9")) Or char = Asc(".") Or char = Asc("+") Or char = Asc("-")) Then
            RemoveNonNumericCharacters = RemoveNonNumericCharacters & Chr$(char)
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
Public Sub CopyCBOCBO(pSourceComboBox As ComboBox, pDestinationComboBox As ComboBox)
    Dim i As Long
    Call pDestinationComboBox.Clear
    For i = 0 To pSourceComboBox.ListCount - 1
        Call pDestinationComboBox.AddItem(pSourceComboBox.List(i))
    Next
End Sub


Public Function IsNumeric(pString As String) As Boolean
    Dim i As Long
    Dim char As String
    IsNumeric = True
    For i = 1 To Len(pString)
        char = Mid$(pString, i, 1)
        If (char <> "0" And char <> "1" And char <> "2" And char <> "3" And char <> "4" And char <> "5" And char <> "6" And char <> "7" And char <> "8" And char <> "9") Then
            IsNumeric = False
            Exit Function
        End If
    Next
End Function

''
Public Function ValidatePostcode(pPostcode As String) As String
    Dim RightPart As String
    Dim leftpart As String
    pPostcode = Trim$(pPostcode)
    If (Len(pPostcode) = 0) Then
        ValidatePostcode = ""
    Else
        If (Len(pPostcode) < 2 + 3) Then
            ValidatePostcode = "ERROR: Postcode too short"
        Else
            RightPart = Right$(pPostcode, 3)
            If (IsNumeric(Left$(RightPart, 1)) = False) Then
                ValidatePostcode = "ERROR: Incorrect postcode format"
            Else
                leftpart = Trim$(Left$(pPostcode, Len(pPostcode) - 3))
                If (IsNumeric(Right$(leftpart, 1)) = False) Then
                    ValidatePostcode = "ERROR: Incorrect postcode format"
                Else
                    Select Case Len(leftpart)
                        Case 0, 1
                        Case 2
                            ValidatePostcode = leftpart & "  " & RightPart
                        Case 3
                            ValidatePostcode = leftpart & " " & RightPart
                        Case 4
                            ValidatePostcode = leftpart & RightPart
                        Case Else
                    End Select
                End If
            End If
        End If
    End If
End Function

''
Public Function GetFieldSize(pRecordset As Recordset, pName As String) As Long
    Dim i As Long
    pName = UCase$(pName)
    GetFieldSize = 0
    For i = 0 To pRecordset.Fields.Count - 1
        If (UCase$(pRecordset.Fields(i).Name) = pName) Then
            GetFieldSize = pRecordset.Fields(i).DefinedSize
            Exit For
        End If
    Next
    If (GetFieldSize > 64000) Then
        GetFieldSize = 0
    End If
End Function

