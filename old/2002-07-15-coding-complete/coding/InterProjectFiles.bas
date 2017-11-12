Attribute VB_Name = "InterProjectFiles"
Option Explicit

Public GlobalUserNumber As Long

'' Checks if all characters are upper case
Public Function IsUppercase(pString As String) As Boolean
    Dim i As Long
    Dim c As Long
    IsUppercase = True
    For i = 1 To Len(pString)
        c = Asc(Mid$(pString, i, 1))
        If (c >= Asc("a") And c <= Asc("Z")) Then
            IsUppercase = False
            Exit For
        End If
    Next
End Function

'' Converts seconds to hh:mm:ss format
Public Function SecondsToTime(pSeconds As Long) As String
    If (pSeconds > 60) Then
        If (pSeconds > 60 * 60) Then
            If (pSeconds > 60# * 60# * 99#) Then
                SecondsToTime = ">" & Format((pSeconds Mod 60# * 60# * 99#) \ 60 \ 60, "00") & ":" & Format((pSeconds Mod 60 * 60) \ 60, "00") & ":" & Format(pSeconds Mod 60, "00")
            Else
                SecondsToTime = Format((pSeconds Mod 60# * 60# * 99#) \ 60 \ 60, "00") & ":" & Format((pSeconds Mod 60 * 60) \ 60, "00") & ":" & Format(pSeconds Mod 60, "00")
            End If
        Else
            SecondsToTime = "00:" & Format(pSeconds \ 60, "00") & ":" & Format(pSeconds Mod 60, "00")
        End If
    Else
        SecondsToTime = "00:00:" & Format(pSeconds, "00")
    End If
End Function

'' Generic load listbox from table function
Public Function LoadListCBO(pCBOBox As ComboBox, pTableName As String, pFieldName As String, pItemDataField As String, pIncludeAll As Boolean, pSetFirstIndex As Boolean) As Boolean
    Dim rstemp As Recordset
    On Error GoTo ErrorTrap ' prevent listindex set problems
    If (OpenRecordset(rstemp, pTableName, dbOpenSnapshot)) Then
        If (pIncludeAll = True) Then
            Call pCBOBox.AddItem("All")
            pCBOBox.ItemData(pCBOBox.ListCount - 1) = -1
        End If
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call pCBOBox.AddItem(Trim$(rstemp(pFieldName) & ""))
                pCBOBox.ItemData(pCBOBox.ListCount - 1) = rstemp(pItemDataField)
                Call rstemp.MoveNext
            Loop
        End If
        If (pSetFirstIndex = True) Then
            pCBOBox.ListIndex = 0
        End If
    End If
ErrorTrap:
End Function

'' Sets text to upper/lower case
Public Function AutoCase(pString As String, pSpaceCaps As Boolean) As String
    Dim Uppercase As Boolean
    Dim i As Long
    Dim char As String
    Dim nextchar As String
    Uppercase = True
    AutoCase = ""
    If (Right(pString, 1) = "²") Then
        AutoCase = Left$(pString, Len(pString) - 1)
    Else
        For i = 1 To Len(pString)
            char = UCase$(Mid$(pString, i, 1))
            If (i < Len(pString)) Then
                nextchar = UCase$(Mid$(pString, i + 1, 1))
            Else
                nextchar = " "
            End If
            If ((char = "I") And nextchar = " ") Then
                Uppercase = True
            End If
            If (Uppercase = True) Then
                AutoCase = AutoCase & UCase$(char)
                Uppercase = False
            Else
                AutoCase = AutoCase & LCase$(char)
            End If
            If (char = Chr$(32) And pSpaceCaps = True) Then
                Uppercase = True
            End If
            If (char = "." Or char = Chr$(10) Or char = Chr$(13)) Then
            ' Or char = ","
                Uppercase = True
            End If
        Next
    End If
End Function

''
Public Function GetWorkstationSetting(pName As String) As String
    GetWorkstationSetting = GetSetting(cRegistoryName, "SETTINGS", pName, "")
End Function

''
Public Sub SetWorkstationSetting(pName As String, pValue As String)
    Call SaveSetting(cRegistoryName, "SETTINGS", pName, pValue)
End Sub

'' Generic file selection dialogue
Public Function OpenDialogue(pFileName As String, pFileType As String) As String
    On Error GoTo Dialog_Cancelled
    With MDIMain.CommonDialogControl
        .InitDir = App.Path
        .Filter = pFileType & "|" & pFileType
        .CancelError = True
        .DialogTitle = "Locate " & pFileName
        Call .ShowOpen
        OpenDialogue = .filename
    End With
    Exit Function
Dialog_Cancelled:
    OpenDialogue = ""
End Function

'' Used to set textboxs maxlength to field/database maxlength
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

'' Hight item in combo box by item name
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

''
Public Function FormatPercent(pNumber As Double) As String
    FormatPercent = Format(pNumber, "#####0.00")
End Function

'' Word wraps text, not font size sensitive
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

'' Set printer by name
Public Function SetPrinter(pPrinterName As String) As Boolean
    Dim LocalPrinter As Printer
    SetPrinter = False
    If (Len(pPrinterName) > 0) Then
        For Each LocalPrinter In Printers
            If (UCase$(Trim$(LocalPrinter.DeviceName)) = pPrinterName) Then
                Set Printer = LocalPrinter
                SetPrinter = True
                Exit For
            End If
        Next
    Else
        ' no printer
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

''
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


'' Loads last position of window or default position
Public Sub SetWindowPosition(pform As Form)
    Dim Left As Double
    Dim Top As Double
    Dim Width As Double
    Dim Height As Double
    Dim WindowState As Long
    Left = GetSetting(cRegistoryName, "Forms", pform.Name & ".Left", 0)
    Top = GetSetting(cRegistoryName, "Forms", pform.Name & ".Top", 0)
    WindowState = GetSetting(cRegistoryName, "Forms", pform.Name & ".WindowState", vbDefault)
    If (pform.Picture = 0) Then
        pform.Picture = MDIMain.PICBackground.Picture
        pform.Icon = MDIMain.Icon
        
    End If
    If (pform.WindowState = vbDefault) Then
            pform.Left = Left
            pform.Top = Top
    End If
    pform.WindowState = WindowState
    If (WindowState = vbDefault) Then
            pform.Left = Left
            pform.Top = Top
    End If
End Sub

'' Saves last position of window, so it can be restored when opened again
Public Sub GetWindowPosition(pform As Form)
    If (pform.Left > 0) Then
        Call SaveSetting(cRegistoryName, "Forms", pform.Name & ".Left", pform.Left)
    End If
    If (pform.Top > 0) Then
        Call SaveSetting(cRegistoryName, "Forms", pform.Name & ".Top", pform.Top)
    End If
    Call SaveSetting(cRegistoryName, "Forms", pform.Name & ".WindowState", pform.WindowState)
End Sub

'' Generic messagebox function, used for easy customisability
Public Function Messagebox(pMessage As String, pParameters As VbMsgBoxStyle, Optional pCaption As String = "-1") As VbMsgBoxResult
    If (pCaption = "-1") Then
        Messagebox = MsgBox(pMessage, pParameters)
    Else
        Messagebox = MsgBox(pMessage, pParameters, pCaption)
    End If
End Function

'' Tracing
Public Function LogEvent(pName As String) As Boolean
'    Dim fileid As Long
'    fileid = FreeFile
'    Open "c:\" & Trim$(cProjectName) & "Trace.txt" For Append As #fileid
'    Print #fileid, pName
'    Close #fileid
End Function

'' Standard error check, centralised
Public Function ErrorCheck(Message As String, pErrorContext As String) As Boolean
    ' log errors
    Dim fileid As Long
    fileid = FreeFile
    Open "c:\" & Trim$(cProjectName) & ".txt" For Append As #fileid
    Print #fileid, "ERROR:(" & pErrorContext & ").  " & Error$ & " has occurred.[" & Message & "]"
    Close #fileid
    
    If (Messagebox("ERROR:(" & pErrorContext & ").  " & Error$ & " has occurred.[" & Message & "]", vbRetryCancel + vbExclamation) = vbCancel) Then
        ErrorCheck = False
        Screen.MousePointer = vbDefault
    Else
        ErrorCheck = True
    End If
End Function

''
Function CenterScreen(MDIChildForm As Form)
    'function to center an MDIChild in the center of the MDIForm
    MDIChildForm.Left = (MDIMain.Width - MDIChildForm.Width) / 2
    MDIChildForm.Top = (MDIMain.Height - MDIChildForm.Height) / 2
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Key generator

'' frmoptions.TXTSerialNumber.Text  =frmoptions.GenerateSerialNumber (frmoptions.TXTProductKey.Text  )

''
Public Function Rotate(pString As String) As String
    Dim i As Long
    Dim RotateValue As Long
    Dim charValue As Long
    RotateValue = 1
    For i = 1 To Len(pString)
        charValue = Asc(Mid$(pString, i, 1))
        If (charValue + RotateValue < 65) Then
            charValue = charValue + 65 - 48
        End If
        If (charValue + RotateValue > Asc("Z")) Then
            Rotate = Rotate & Chr$(charValue - RotateValue)
        Else
            Rotate = Rotate & Chr$(charValue + RotateValue)
        End If
        RotateValue = RotateValue + 1
    Next
End Function

''
Public Function SumString(pString As String) As Long
    Dim i As Long
    Dim key As Long
    Dim char As String
    Dim HiLo As Boolean
    HiLo = False
    For i = 1 To Len(pString)
        char = Mid$(pString, i, 1)
        If (HiLo = False) Then
            key = key + Asc(char)
            HiLo = True
        Else
            key = key + Asc(char) * 514#
            HiLo = False
        End If
        If (key > 400000000) Then
            key = key - 200000000
        End If
    Next
    SumString = key
End Function

''
Public Function GenerateSerialNumber(pProductKey As String) As String
    pProductKey = Replace(pProductKey, "-", "")
    GenerateSerialNumber = Rotate(pProductKey)
End Function

''
Public Function GetLicenceTo() As String
    Dim fileid As Long
    Dim Tempstring As String
    Dim Name As String
    Dim key As String
    Dim ProductName As String
    
    On Error GoTo failed
    GetLicenceTo = "*Unlicenced*"
    Tempstring = GetSetting(cRegistoryName, "Settings", cDatabaseName, "NODATABASE")
    If (Tempstring <> "") Then
        Tempstring = Left$(Tempstring, Len(Tempstring) - 4) & ".KEY"
        fileid = FreeFile
        Open Tempstring For Input As #fileid
        Line Input #fileid, Name
        Line Input #fileid, key
        Line Input #fileid, ProductName
        Line Input #fileid, Tempstring
        GlobalUserNumber = Val(Tempstring)
        
        
        If (key = Rotate(Name)) Then
            If (Rotate(cProjectNameConst) = ProductName) Then
                GetLicenceTo = Name
            End If
        Else
        End If
        Close #fileid
        
    End If
failed:
End Function

''
Public Function SetLicenceTo(pName As String, pUserNumber As Long) As String
    Dim fileid As Long
    Dim Tempstring As String
    Dim Name As String
    Dim key As String
    'On Error GoTo failed
    Tempstring = GetSetting(cRegistoryName, "Settings", cDatabaseName, "NODATABASE")
    If (Tempstring <> "") Then
        Tempstring = Left$(Tempstring, Len(Tempstring) - 4) & ".KEY"
        fileid = FreeFile
        Open Tempstring For Output As #fileid
        Print #fileid, pName
        Print #fileid, Rotate(pName)
        Print #fileid, Rotate(cProjectNameConst)
        Print #fileid, pUserNumber
        Close #fileid
        
    End If
failed:
End Function

