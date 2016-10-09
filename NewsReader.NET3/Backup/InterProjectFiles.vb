Option Strict Off
Option Explicit On
Imports Microsoft.VisualBasic.PowerPacks.Printing.Compatibility.VB6
Module InterProjectFiles
	''*************************************************************************
	''
	'' Coded by Dale Pitman
	''
	
	
	Public Structure InlineSQLTYPE
		Dim Name As String
		Dim Value As String
		Dim Index As Integer
	End Structure
	
	Public Const cDisabledColour As Integer = &HC0C0C0
	Public Const cEnabledColour As Integer = &H80000005
	
	Public GlobalUserNumber As Integer
	
	Private Structure LocalElementTYPE
		Dim Name As String
		Dim Text As String
	End Structure
	
	Private vLocalElements(10000) As LocalElementTYPE
	Private vNumLocalElements As Integer
	Private vIsLocalLoaded As Boolean
	
	Public Function IsLocalLoaded() As Boolean
		IsLocalLoaded = vIsLocalLoaded
	End Function
	
	''
	Public Sub LoadLocaleFiles()
		Dim fileid As Integer
		Dim i As Integer
		Dim tempstring As String
		vIsLocalLoaded = False
		fileid = FreeFile
		On Error GoTo filenotfound
		FileOpen(fileid, cProjectNameConst & ".locale", OpenMode.Input)
		Do While (EOF(fileid) = False And i < 10000)
			tempstring = LineInput(fileid)
			If (Left(tempstring, 1) <> ";") Then
				If (InStr(tempstring, "=") = 0) Then
					Call Messagebox("Error in locale", MsgBoxStyle.Information)
				Else
					vLocalElements(i).Name = Left(tempstring, InStr(tempstring, "=") - 1)
					vLocalElements(i).Text = Mid(tempstring, InStr(tempstring, "=") + 1)
				End If
			Else
				' comment line, ignore
			End If
			i = i + 1
		Loop 
		vNumLocalElements = i - 1
		vIsLocalLoaded = True
		FileClose(fileid)
filenotfound: 
	End Sub
	
	''
	Public Function GetLocalName(ByRef pName As String, Optional ByRef pDefault As String = "") As String
		Dim i As Integer
		Dim fileid As Integer
		fileid = FreeFile
		
		GetLocalName = ""
		For i = 0 To vNumLocalElements
			If (UCase(pName) = UCase(vLocalElements(i).Name)) Then
				GetLocalName = vLocalElements(i).Text
				Exit For
			End If
		Next 
		If (GetLocalName = "") Then
			FileOpen(fileid, cProjectNameConst & ".locale", OpenMode.Append)
			If (pDefault = "") Then
				PrintLine(fileid, pName & "=" & Mid(pName, InStrRev(pName, ".") + 1))
			Else
				PrintLine(fileid, pName & "=" & pDefault)
				GetLocalName = pDefault
			End If
			FileClose(fileid)
		End If
	End Function
	
	
	'' Checks if all characters are upper case
	Public Function IsUppercase(ByRef pString As String) As Boolean
		Dim i As Integer
		Dim c As Integer
		IsUppercase = True
		For i = 1 To Len(pString)
			c = Asc(Mid(pString, i, 1))
			If (c >= Asc("a") And c <= Asc("Z")) Then
				IsUppercase = False
				Exit For
			End If
		Next 
	End Function
	
	'' Converts seconds to hh:mm:ss format
	Public Function SecondsToTime(ByRef pSeconds As Integer) As String
		If (pSeconds > 60) Then
			If (pSeconds > 60 * 60) Then
				If (pSeconds > 60# * 60# * 99#) Then
					'UPGRADE_WARNING: Mod has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
					SecondsToTime = ">" & VB6.Format((pSeconds Mod 60# * 60# * 99#) \ 60 \ 60, "00") & ":" & VB6.Format((pSeconds Mod 60 * 60) \ 60, "00") & ":" & VB6.Format(pSeconds Mod 60, "00")
				Else
					'UPGRADE_WARNING: Mod has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
					SecondsToTime = VB6.Format((pSeconds Mod 60# * 60# * 99#) \ 60 \ 60, "00") & ":" & VB6.Format((pSeconds Mod 60 * 60) \ 60, "00") & ":" & VB6.Format(pSeconds Mod 60, "00")
				End If
			Else
				SecondsToTime = "00:" & VB6.Format(pSeconds \ 60, "00") & ":" & VB6.Format(pSeconds Mod 60, "00")
			End If
		Else
			SecondsToTime = "00:00:" & VB6.Format(pSeconds, "00")
		End If
	End Function
	
	'' Generic load listbox from table function
	Public Function LoadListCBO(ByRef pCBOBox As System.Windows.Forms.ComboBox, ByRef pTableName As String, ByRef pFieldName As String, ByRef pItemDataField As String, ByRef pIncludeAll As Boolean, ByRef pSetFirstIndex As Boolean) As Boolean
		Dim rstemp As ADODB.Recordset
		On Error GoTo ErrorTrap ' prevent listindex set problems
		If (OpenRecordset(rstemp, pTableName, dbOpenSnapshot)) Then
			If (pIncludeAll = True) Then
				Call pCBOBox.Items.Add("All")
				VB6.SetItemData(pCBOBox, pCBOBox.Items.Count - 1, -1)
			End If
			If (rstemp.EOF = False) Then
				Do While (rstemp.EOF = False)
					Call pCBOBox.Items.Add(Trim(rstemp.Fields(pFieldName).Value & ""))
					VB6.SetItemData(pCBOBox, pCBOBox.Items.Count - 1, rstemp.Fields(pItemDataField).Value)
					Call rstemp.MoveNext()
				Loop 
			End If
			If (pSetFirstIndex = True) Then
				pCBOBox.SelectedIndex = 0
			End If
		End If
ErrorTrap: 
	End Function
	
	'' Sets text to upper/lower case
	Public Function AutoCase(ByRef pString As String, ByRef pSpaceCaps As Boolean) As String
		Dim Uppercase As Boolean
		Dim i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As String
		Dim nextchar As String
		Uppercase = True
		AutoCase = ""
		If (Right(pString, 1) = "²") Then
			AutoCase = Left(pString, Len(pString) - 1)
		Else
			For i = 1 To Len(pString)
				char_Renamed = UCase(Mid(pString, i, 1))
				If (i < Len(pString)) Then
					nextchar = UCase(Mid(pString, i + 1, 1))
				Else
					nextchar = " "
				End If
				If ((char_Renamed = "I") And nextchar = " ") Then
					Uppercase = True
				End If
				If (Uppercase = True) Then
					AutoCase = AutoCase & UCase(char_Renamed)
					Uppercase = False
				Else
					AutoCase = AutoCase & LCase(char_Renamed)
				End If
				If (char_Renamed = Chr(32) And pSpaceCaps = True) Then
					Uppercase = True
				End If
				If (char_Renamed = "." Or char_Renamed = Chr(10) Or char_Renamed = Chr(13)) Then
					' Or char = ","
					Uppercase = True
				End If
			Next 
		End If
	End Function
	
	''
	Public Function GetWorkstationSetting(ByRef pName As String) As String
		GetWorkstationSetting = GetSetting(cRegistoryName, "SETTINGS", pName, "")
	End Function
	
	''
	Public Sub SetWorkstationSetting(ByRef pName As String, ByRef pValue As String)
		Call SaveSetting(cRegistoryName, "SETTINGS", pName, pValue)
	End Sub
	
	'' Generic file selection dialogue
	Public Function OpenDialogue(ByRef pfilename As String, ByRef pFileType As String) As String
		On Error GoTo Dialog_Cancelled
		With MDIMain.CommonDialogControl
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.InitDir. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			.InitDir = My.Application.Info.DirectoryPath
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.Filter. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			.Filter = pFileType & "|" & pFileType
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.CancelError. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			.CancelError = True
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.DialogTitle. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			.DialogTitle = "Locate " & pfilename
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.ShowOpen. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			Call .ShowOpen()
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.FileName. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			OpenDialogue = .FileName
		End With
		Exit Function
Dialog_Cancelled: 
		OpenDialogue = ""
	End Function
	
	'' Used to set textboxs maxlength to field/database maxlength
	Public Function GetFieldSize(ByRef pRecordset As ADODB.Recordset, ByRef pName As String) As Integer
		Dim i As Integer
		pName = UCase(pName)
		GetFieldSize = 0
		For i = 0 To pRecordset.Fields.Count - 1
			If (UCase(pRecordset.Fields(i).Name) = pName) Then
				GetFieldSize = pRecordset.Fields(i).DefinedSize
				Exit For
			End If
		Next 
		If (GetFieldSize > 64000) Then
			GetFieldSize = 0
		End If
	End Function
	
	'' Hight item in combo box by item name
	Public Function SetByItemCBO(ByRef pComboBox As System.Windows.Forms.ComboBox, ByRef pItemName As String) As Boolean
		Dim i As Integer
		For i = 0 To pComboBox.Items.Count - 1
			If (Left(VB6.GetItemString(pComboBox, i), Len(pItemName)) = pItemName) Then
				pComboBox.SelectedIndex = i
				Exit For
			End If
		Next 
	End Function
	
	'' Hight item in combo box by item name
	Public Function SetByItemCBO2(ByRef pComboBox As System.Windows.Forms.ComboBox, ByRef pItemName As String) As Boolean
		Dim i As Integer
		For i = 0 To pComboBox.Items.Count - 1
			If (VB6.GetItemString(pComboBox, i) = pItemName) Then
				pComboBox.SelectedIndex = i
				Exit For
			End If
		Next 
	End Function
	
	''
	Public Function SetByItemDataCBO(ByRef pComboBox As System.Windows.Forms.ComboBox, ByRef pID As Integer) As Boolean
		Dim i As Integer
		For i = 0 To pComboBox.Items.Count - 1
			If (VB6.GetItemData(pComboBox, i) = pID) Then
				pComboBox.SelectedIndex = i
				Exit For
			End If
		Next 
	End Function
	
	''
	Public Function GetCurrencyFromStringX(ByRef pString As String) As Decimal
		If (Left(pString, 1) = cCurrencySymbol) Then
			GetCurrencyFromStringX = Val(Right(pString, Len(pString) - 1))
		Else
			GetCurrencyFromStringX = Val(pString)
		End If
	End Function
	
	''
	Public Function RemoveNonNumericCharacters(ByRef pString As String) As String
		Dim i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As Integer
		RemoveNonNumericCharacters = ""
		For i = 1 To Len(pString)
			char_Renamed = Asc(Mid(pString, i, 1))
			If ((char_Renamed >= Asc("0") And char_Renamed <= Asc("9")) Or char_Renamed = Asc(".") Or char_Renamed = Asc("+") Or char_Renamed = Asc("-")) Then
				RemoveNonNumericCharacters = RemoveNonNumericCharacters & Chr(char_Renamed)
			End If
		Next 
	End Function
	
	'' Binary AND operation, used by classes in search function
	Public Function BAnd(ByRef pValue1 As Integer, ByRef pvalue2 As Integer) As Boolean
		If ((pValue1 And pvalue2) > 0) Then
			BAnd = True
		Else
			BAnd = False
		End If
	End Function
	
	''
	'UPGRADE_NOTE: FormatCurrency was upgraded to FormatCurrency_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
	Public Function FormatCurrency_Renamed(ByRef pNumber As Decimal) As String
		FormatCurrency_Renamed = VB6.Format(pNumber, cCurrencyFormat)
	End Function
	
	''
	'UPGRADE_NOTE: FormatPercent was upgraded to FormatPercent_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
	Public Function FormatPercent_Renamed(ByRef pNumber As Double) As String
		FormatPercent_Renamed = VB6.Format(pNumber, "#####0.00")
	End Function
	
	'' Word wraps text, not font size sensitive
	Public Function AutoWidth(ByRef pString As String, ByRef pWidth As Integer) As String
		pString = Trim(Replace(Trim(pString), vbCrLf, ""))
		Do While (Len(pString) > pWidth)
			If (InStr(pWidth, pString, " ") > 0) Then
				AutoWidth = AutoWidth & Left(pString, InStr(pWidth, pString, " ")) & Chr(13)
				pString = Mid(pString, InStr(pWidth, pString, " "))
			Else
				AutoWidth = AutoWidth & Left(pString, pWidth) & Chr(13)
				pString = Mid(pString, pWidth)
			End If
		Loop 
		AutoWidth = AutoWidth & pString & Chr(13)
	End Function
	
	'' Set printer by name
	Public Function SetPrinter(ByRef pPrinterName As String) As Boolean
		Dim Printer As New Printer
		Dim LocalPrinter As Printer
		SetPrinter = False
		If (Len(pPrinterName) > 0) Then
			For	Each LocalPrinter In Printers
				If (UCase(Trim(LocalPrinter.DeviceName)) = pPrinterName) Then
					Printer = LocalPrinter
					SetPrinter = True
					Exit For
				End If
			Next LocalPrinter
		Else
			' no printer
		End If
	End Function
	
	''
	Public Sub CopyCBOCBO(ByRef pSourceComboBox As System.Windows.Forms.ComboBox, ByRef pDestinationComboBox As System.Windows.Forms.ComboBox)
		Dim i As Integer
		Call pDestinationComboBox.Items.Clear()
		For i = 0 To pSourceComboBox.Items.Count - 1
			Call pDestinationComboBox.Items.Add(VB6.GetItemString(pSourceComboBox, i))
		Next 
	End Sub
	
	''
	'UPGRADE_NOTE: IsNumeric was upgraded to IsNumeric_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
	Public Function IsNumeric_Renamed(ByRef pString As String) As Boolean
		Dim i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As String
		IsNumeric_Renamed = True
		For i = 1 To Len(pString)
			char_Renamed = Mid(pString, i, 1)
			If (char_Renamed <> "0" And char_Renamed <> "1" And char_Renamed <> "2" And char_Renamed <> "3" And char_Renamed <> "4" And char_Renamed <> "5" And char_Renamed <> "6" And char_Renamed <> "7" And char_Renamed <> "8" And char_Renamed <> "9") Then
				IsNumeric_Renamed = False
				Exit Function
			End If
		Next 
	End Function
	
	
	'' Loads last position of window or default position
	Public Sub SetWindowPosition(ByRef pform As System.Windows.Forms.Form)
		'UPGRADE_NOTE: Left was upgraded to Left_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim Left_Renamed As Double
		Dim Top As Double
		Dim WindowState As Integer
		Left_Renamed = CDbl(GetSetting(cRegistoryName, "Forms", pform.Name & ".Left", CStr(0)))
		Top = CDbl(GetSetting(cRegistoryName, "Forms", pform.Name & ".Top", CStr(0)))
		WindowState = CInt(GetSetting(cRegistoryName, "Forms", pform.Name & ".WindowState", CStr(System.Windows.Forms.Cursors.Default)))
		If (CDbl(CObj(pform.BackgroundImage)) = 0) Then
			pform.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None
			pform.BackgroundImage = MDIMain.PICBackground.Image
			pform.Icon = MDIMain.Icon
			
		End If
		If (pform.WindowState = System.Windows.Forms.Cursors.Default) Then
			pform.Left = VB6.TwipsToPixelsX(Left_Renamed)
			pform.Top = VB6.TwipsToPixelsY(Top)
		End If
		pform.WindowState = WindowState
		If (WindowState = System.Windows.Forms.Cursors.Default) Then
			pform.Left = VB6.TwipsToPixelsX(Left_Renamed)
			pform.Top = VB6.TwipsToPixelsY(Top)
		End If
	End Sub
	
	'' Saves last position of window, so it can be restored when opened again
	Public Sub GetWindowPosition(ByRef pform As System.Windows.Forms.Form)
		If (VB6.PixelsToTwipsX(pform.Left) > 0) Then
			Call SaveSetting(cRegistoryName, "Forms", pform.Name & ".Left", CStr(VB6.PixelsToTwipsX(pform.Left)))
		End If
		If (VB6.PixelsToTwipsY(pform.Top) > 0) Then
			Call SaveSetting(cRegistoryName, "Forms", pform.Name & ".Top", CStr(VB6.PixelsToTwipsY(pform.Top)))
		End If
		Call SaveSetting(cRegistoryName, "Forms", pform.Name & ".WindowState", CStr(pform.WindowState))
	End Sub
	
	'' Generic messagebox function, used for easy customisability
	Public Function Messagebox(ByRef pMessage As String, ByRef pParameters As MsgBoxStyle, Optional ByRef pCaption As String = "-1") As MsgBoxResult
		If (pCaption = "-1") Then
			Messagebox = MsgBox(pMessage, pParameters)
		Else
			Messagebox = MsgBox(pMessage, pParameters, pCaption)
		End If
	End Function
	
	'' Tracing
	Public Function LogTraceEvent(ByRef pName As String) As Boolean
		Dim fileid As Integer
		fileid = FreeFile
		FileOpen(fileid, "c:\" & Trim(cProjectName) & "Trace.txt", OpenMode.Append)
		PrintLine(fileid, pName)
		FileClose(fileid)
	End Function
	
	'' Standard error check, centralised
	Public Function ErrorCheck(ByRef Message As String, ByRef pErrorContext As String) As Boolean
		' log errors
		Dim fileid As Integer
		fileid = FreeFile
		FileOpen(fileid, "c:\" & Trim(cProjectName) & ".txt", OpenMode.Append)
		PrintLine(fileid, "ERROR:(" & pErrorContext & ").  " & ErrorToString() & " has occurred.[" & Message & "]")
		FileClose(fileid)
		
		If (Messagebox("ERROR:(" & pErrorContext & ").  " & ErrorToString() & " has occurred.[" & Message & "]", MsgBoxStyle.RetryCancel + MsgBoxStyle.Exclamation) = MsgBoxResult.Cancel) Then
			ErrorCheck = False
			'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
			System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
		Else
			ErrorCheck = True
		End If
	End Function
	
	''
	Function CenterScreen(ByRef MDIChildForm As System.Windows.Forms.Form) As Object
		'function to center an MDIChild in the center of the MDIForm
		MDIChildForm.Left = VB6.TwipsToPixelsX((VB6.PixelsToTwipsX(MDIMain.Width) - VB6.PixelsToTwipsX(MDIChildForm.Width)) / 2)
		MDIChildForm.Top = VB6.TwipsToPixelsY((VB6.PixelsToTwipsY(MDIMain.Height) - VB6.PixelsToTwipsY(MDIChildForm.Height)) / 2)
	End Function
	
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Key generator
	
	''
	Public Function Rotate(ByRef pString As String) As String
		Dim i As Integer
		Dim RotateValue As Integer
		Dim charValue As Integer
		RotateValue = 1
		For i = 1 To Len(pString)
			charValue = Asc(Mid(pString, i, 1))
			If (charValue + RotateValue < 65) Then
				charValue = charValue + 65 - 48
			End If
			If (charValue + RotateValue > Asc("Z")) Then
				Rotate = Rotate & Chr(charValue - RotateValue)
			Else
				Rotate = Rotate & Chr(charValue + RotateValue)
			End If
			RotateValue = RotateValue + 1
		Next 
	End Function
	
	''
	Public Function SumString(ByRef pString As String) As Integer
		Dim i As Integer
		Dim key As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As String
		Dim HiLo As Boolean
		HiLo = False
		For i = 1 To Len(pString)
			char_Renamed = Mid(pString, i, 1)
			If (HiLo = False) Then
				key = key + Asc(char_Renamed)
				HiLo = True
			Else
				key = key + Asc(char_Renamed) * 514#
				HiLo = False
			End If
			If (key > 400000000) Then
				key = key - 200000000
			End If
		Next 
		SumString = key
	End Function
	
	''
	Public Function GenerateSerialNumber(ByRef pProductKey As String) As String
		pProductKey = Replace(pProductKey, "-", "")
		GenerateSerialNumber = Rotate(pProductKey)
	End Function
	
	''
	Public Function GetLicenceTo() As String
		Dim fileid As Integer
		Dim tempstring As String
		Dim Name As String
		Dim key As String
		Dim ProductName As String
		
		On Error GoTo failed
		GetLicenceTo = "* Unlicensed *"
		tempstring = GetSetting(cRegistoryName, "Settings", cDatabaseName, "NODATABASE")
		If (tempstring <> "") Then
			tempstring = Left(tempstring, Len(tempstring) - 4) & ".KEY"
			fileid = FreeFile
			FileOpen(fileid, tempstring, OpenMode.Input)
			Name = LineInput(fileid)
			key = LineInput(fileid)
			ProductName = LineInput(fileid)
			tempstring = LineInput(fileid)
			GlobalUserNumber = Val(tempstring)
			
			
			If (key = Rotate(Name)) Then
				If (Rotate(cProjectNameConst) = ProductName) Then
					If (FRMOptions.CompanyName_Renamed = Name) Then
						GetLicenceTo = Name
					End If
				End If
			Else
			End If
			FileClose(fileid)
			
		End If
failed: 
	End Function
	
	''
	Public Function SetLicenceTo(ByRef pName As String, ByRef pUserNumber As Integer) As String
		Dim fileid As Integer
		Dim tempstring As String
		Dim Name As String
		'On Error GoTo failed
		tempstring = GetSetting(cRegistoryName, "Settings", cDatabaseName, "NODATABASE")
		If (tempstring <> "") Then
			tempstring = Left(tempstring, Len(tempstring) - 4) & ".KEY"
			fileid = FreeFile
			FileOpen(fileid, tempstring, OpenMode.Output)
			PrintLine(fileid, pName)
			PrintLine(fileid, Rotate(pName))
			PrintLine(fileid, Rotate(cProjectNameConst))
			PrintLine(fileid, pUserNumber)
			FileClose(fileid)
			
		End If
failed: 
	End Function
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	''
	
	Public Sub StripTags(ByRef pSql As String, ByRef Tokens() As InlineSQLTYPE)
		Dim tempstring As String
		Dim temptoken As String
		Dim GlobalTags As String
		Dim TempStore(100) As InlineSQLTYPE
		Dim i As Integer
		Dim MaxToken As Integer
		Dim Index As Integer
		Dim commacountString As String
		Dim OutSQL As String
		
		MaxToken = 0
		pSql = UCase(pSql)
		GlobalTags = Mid(pSql, 1, InStr(pSql, "SELECT") - 1)
		
		' Do globals tags
		Do While (GlobalTags <> "")
			temptoken = Mid(GlobalTags, InStr(GlobalTags, "<") + 1)
			temptoken = Mid(temptoken, 1, InStr(temptoken, ">") - 1)
			TempStore(MaxToken).Index = 0
			TempStore(MaxToken).Name = Mid(temptoken, 1, InStr(temptoken, "=") - 1)
			TempStore(MaxToken).Value = Mid(temptoken, InStr(temptoken, "=") + 1)
			MaxToken = MaxToken + 1
			GlobalTags = Mid(GlobalTags, InStr(GlobalTags, ">") + 1)
		Loop 
		tempstring = Mid(pSql, InStr(pSql, "SELECT") + 6)
		tempstring = Mid(tempstring, 1, InStr(tempstring, "FROM"))
		
		' remove globaltags
		OutSQL = Mid(pSql, InStr(pSql, "SELECT"))
		
		' Do Field tags
		Index = 0
		Do While (tempstring <> "")
			commacountString = Mid(tempstring, 1, InStr(tempstring, "<") + 1)
			Do While (InStr(commacountString, ",") > 0)
				Index = Index + 1
				commacountString = Mid(commacountString, InStr(commacountString, ",") + 1)
			Loop 
			If (InStr(tempstring, ">") > 0) Then
				temptoken = Mid(tempstring, InStr(tempstring, "<") + 1)
				temptoken = Mid(temptoken, 1, InStr(temptoken, ">") - 1)
				If (IsNumeric_Renamed(Left(temptoken, 2)) = False) Then
					TempStore(MaxToken).Index = Index
				Else
					TempStore(MaxToken).Index = CInt(Left(temptoken, 2))
					temptoken = Mid(temptoken, 3)
				End If
				TempStore(MaxToken).Name = Mid(temptoken, 1, InStr(temptoken, "=") - 1)
				TempStore(MaxToken).Value = Mid(temptoken, InStr(temptoken, "=") + 1)
				MaxToken = MaxToken + 1
			Else
				tempstring = ""
			End If
			tempstring = Mid(tempstring, InStr(tempstring, ">") + 1)
		Loop 
		
		' Prcess sql
		OutSQL = Mid(OutSQL, 1, InStr(OutSQL, "FROM") - 1)
		Do While (InStr(OutSQL, "<") > 0)
			OutSQL = Mid(OutSQL, 1, InStr(OutSQL, "<") - 1) & Mid(OutSQL, InStr(OutSQL, ">") + 1)
		Loop 
		OutSQL = OutSQL & Mid(pSql, InStr(pSql, "FROM") - 1)
		
		' Copy Temp To return criteria
		If (MaxToken > 0) Then
			ReDim Tokens(MaxToken - 1)
			For i = 0 To MaxToken - 1
				Tokens(i).Index = TempStore(i).Index
				Tokens(i).Name = TempStore(i).Name
				Tokens(i).Value = TempStore(i).Value
			Next 
		Else
			ReDim Tokens(0)
			Tokens(0).Index = 0
			Tokens(0).Name = ""
			Tokens(0).Value = ""
		End If
		pSql = OutSQL
	End Sub
End Module