Attribute VB_Name = "GlobalFunctions"
Option Explicit
''*************************************************************************
''
''
''
Private Type SystemSettingsTYPE
    Name As String
    Value As String
End Type


Public Const cCurrencySymbol As String = "£"     ' must be 1 char
Public Const cCurrencyFormat As String = cCurrencySymbol & "#####0.00"

Private vSystemSettings() As SystemSettingsTYPE
Private vNumSystemSettings As Long

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
Public Function FormatCurrency(pNumber As Currency) As String
    FormatCurrency = Format(pNumber, cCurrencyFormat)
End Function

Public Function FormatPercent(pNumber As Double) As String
    FormatPercent = Format(pNumber, "#####0.00")
End Function

''
Public Sub CopyCBOCBO(pSourceComboBox As ComboBox, pDestinationComboBox As ComboBox)
    Dim i As Long
    Call pDestinationComboBox.Clear
    For i = 0 To pSourceComboBox.ListCount - 1
        Call pDestinationComboBox.AddItem(pSourceComboBox.List(i))
    Next
End Sub

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


''
Public Function GetServerSetting(pName As String, pMultiUserEnable As Boolean) As String
    Dim i As Long
    Dim rstemp As Recordset
    GetServerSetting = ""
    For i = 0 To vNumSystemSettings
        If (vSystemSettings(i).Name = pName) Then
            GetServerSetting = vSystemSettings(i).Value
            If (OpenRecordset(rstemp, "SELECT * FROM setting WHERE rname=" & cTextField & pName & cTextField, dbOpenDynaset)) Then
                If (rstemp.EOF = False) Then
                    GetServerSetting = Trim$(rstemp!rValue & "")
                End If
            End If
            Exit For
        End If
    Next
End Function

''
Public Sub SetServerSetting(pName As String, pValue As String)
    Dim i As Long
    Dim Found As Boolean
    For i = 0 To vNumSystemSettings
        If (vSystemSettings(i).Name = pName) Then
            vSystemSettings(i).Value = pValue
            Found = True
            Exit For
        End If
    Next
    
    If (Found = False) Then
        Call Execute("INSERT INTO setting (rname,rvalue) VALUES (" & cTextField & pName & cTextField & "," & cTextField & pValue & cTextField & ")")
        'add to list
        Call LoadServerSettings
    Else
        Call Execute("UPDATE setting SET rvalue=" & cTextField & pValue & cTextField & " WHERE rname=" & cTextField & pName & cTextField)
    End If
End Sub

''
Public Sub LoadServerSettings()
    Dim rstemp As Recordset
    Dim i As Long
    ' Load system setting
    If (OpenRecordset(rstemp, "SELECT * FROM setting", dbOpenSnapshot) = True) Then
        If (rstemp.EOF = False) Then
            Call rstemp.MoveLast
            Call rstemp.MoveFirst
            ReDim vSystemSettings(rstemp.RecordCount)
            i = 0
            Do While (rstemp.EOF = False)
                vSystemSettings(i).Name = Trim$(rstemp!rName & "")
                vSystemSettings(i).Value = Trim$(rstemp!rValue & "")
                i = i + 1
                Call rstemp.MoveNext
            Loop
            vNumSystemSettings = i - 1
            Call rstemp.Close
        Else
            vNumSystemSettings = -1
        End If
    End If
End Sub

