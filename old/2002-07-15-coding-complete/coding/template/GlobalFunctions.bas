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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Registory stuff

Private Function SetFormPicture(pFormname As Form)
End Function

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
                            ValidatePostcode = leftpart & " " & RightPart
                        Case Else
                    End Select
                End If
            End If
        End If
    End If
    ValidatePostcode = UCase$(ValidatePostcode)
End Function
