Option Strict Off
Option Explicit On
Friend Class StringClass
	''*************************************************************************
	''
	'' Coded by Dale Pitman
	''
	
	'' Utility class - Strings
	
	''
	
	Private vTokens(100) As String '' Current statement split into tokens
	Private vNumTokens As Integer
	
	''
	ReadOnly Property Tokens(ByVal index As Integer) As String
		Get
			Tokens = vTokens(index)
		End Get
	End Property
	
	''
	ReadOnly Property TokensProcess(ByVal index As Integer) As String
		Get
			TokensProcess = Replace(vTokens(index), Chr(34), "")
		End Get
	End Property
	
	''
	ReadOnly Property NumTokens() As Integer
		Get
			NumTokens = vNumTokens
		End Get
	End Property
	
	'' Returns position of the first space or comma, or 0 if not found
	Private Function CheckForTokens(ByRef SourceString As String, ByRef pSpaceDelimiter As Boolean) As Integer
		Static Tempstring As String
		Static i As Integer
		Static ignoreon As Boolean
		Static ignoreon2 As Boolean
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Static char_Renamed As New VB6.FixedLengthString(1)
		
		Tempstring = SourceString
		
		' Ignore strings constants
		'    If (Left$(tempstring, 1) = Chr$(34)) Then
		i = 1
		ignoreon = False
		ignoreon2 = False
		Do While (i < Len(Tempstring))
			char_Renamed.Value = Mid(Tempstring, i, 1)
			If (ignoreon = False And ignoreon2 = False) Then
				If ((char_Renamed.Value = " " And pSpaceDelimiter = True) Or char_Renamed.Value = ",") Then
					Exit Do
				End If
			End If
			If (char_Renamed.Value = Chr(34)) Then
				ignoreon = Not ignoreon
			End If
			If (char_Renamed.Value = "'") Then
				ignoreon = Not ignoreon
			End If
			
			' Move to next character(if brackets are found then find closing bracket)
			If (char_Renamed.Value = "(") Then
				i = GetCloseBracketPos(Tempstring, i)
			Else
				i = i + 1
			End If
		Loop 
		If (i = Len(Tempstring)) Then
			i = 0
		End If
		CheckForTokens = i
		'    End If
	End Function
	
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Simple operations
	
	'' hmmm,
	Private Function IsOperator(ByRef param As String, ByRef Position As Integer) As Boolean
		Select Case Mid(param, Position, 1)
			Case "+", "-", "*", "\", "/", "^", "&", "=", "<", ">"
				IsOperator = True
			Case Else
				Select Case UCase(Mid(param, Position, 3))
					Case "MOD", "DIV", "XOR", "IMP", "EQV", "NOT", "AND"
						IsOperator = True
					Case Else
						Select Case (UCase(Mid(param, Position, 2)))
							Case "OR", ">=", "<=", "<>"
								IsOperator = True
							Case Else
								If (UCase(Mid(param, Position, 4)) = "LIKE") Then
									IsOperator = True
								Else
									IsOperator = False
								End If
						End Select
				End Select
		End Select
	End Function
	
	'' Scan for closing bracket
	Private Function GetCloseBracketPos(ByRef param As String, ByRef startpos As Integer) As Integer
		Static bracketCount As Integer
		Static i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Static char_Renamed As String
		
		bracketCount = 1
		i = startpos + 1
		
		' Scan until end of string or the last brackets is found
		Do While (i <= Len(param) And bracketCount > 0)
			char_Renamed = Mid(param, i, 1)
			
			'Check for nesting of brackets
			Select Case char_Renamed
				Case "("
					bracketCount = bracketCount + 1
				Case ")"
					bracketCount = bracketCount - 1
				Case Else
			End Select
			i = i + 1
		Loop 
		GetCloseBracketPos = i - 1
	End Function
	
	'' Search for a set of characters within a string
	Private Function ScanForNextChar(ByRef param As String, ByRef SearchParam As String) As Integer
		Static i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Static char_Renamed As String
		Static ignoreon As Boolean
		
		ignoreon = False
		
		i = 1
		Do While (i <= Len(param))
			char_Renamed = Mid(param, i, 1)
			If (ignoreon = False) Then
				If (InStr(SearchParam, char_Renamed) > 0) Then
					Exit Do
				End If
			End If
			
			If (char_Renamed = Chr(34)) Then
				ignoreon = Not ignoreon
			End If
			' Move to next character(if brackets are found then find closing bracket)
			If (char_Renamed = "(") Then
				i = GetCloseBracketPos(param, i)
			Else
				i = i + 1
			End If
		Loop 
		
		' Hack to make sure operation doesent return > length
		If (i >= Len(param)) Then
			i = 0
			'        i = Len(param)
		End If
		ScanForNextChar = i
	End Function
	
	'' Count number of accorances of a character
	'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
	Private Function CountChar(ByRef param As String, ByRef char_Renamed As String) As Integer
		Dim i As Integer
		Dim Count As Integer
		Count = 0
		For i = 1 To Len(param)
			If (Mid(param, i, 1) = char_Renamed) Then
				Count = Count + 1
			End If
		Next i
		CountChar = Count
	End Function
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Public functions
	
	'' Function to allow code to be better parsed
	Public Sub Tokenise(ByRef SourceString As String, ByRef pSpaceDelimiter As Boolean)
		Static CurrentString As String
		Static NextDelimiter As Integer
		
		CurrentString = SourceString
		vNumTokens = 0
		
		Do While (CurrentString <> "")
			NextDelimiter = CheckForTokens(CurrentString, pSpaceDelimiter)
			If (NextDelimiter < 1) Then
				If ((CurrentString = " " And pSpaceDelimiter = True) Or CurrentString = ",") Then
					vTokens(vNumTokens) = ""
					vNumTokens = vNumTokens + 1
					vTokens(vNumTokens) = ""
					CurrentString = ""
				Else
					vTokens(vNumTokens) = CurrentString
					CurrentString = ""
				End If
			Else
				vTokens(vNumTokens) = Left(CurrentString, NextDelimiter - 1)
				CurrentString = Trim(Right(CurrentString, Len(CurrentString) - (NextDelimiter)))
			End If
			vNumTokens = vNumTokens + 1
		Loop 
		vNumTokens = vNumTokens - 1
	End Sub
	
	'' Returns two strings one outside of brackets, one inside
	Public Function DeleteInBrackets(ByRef instring As String, ByRef retstring As String) As String
		Static positionA, positionB As Integer
		positionA = InStr(instring, "(")
		positionB = GetCloseBracketPos(instring, InStr(instring, "("))
		If (positionA > 0 And positionB > 0) Then
			DeleteInBrackets = Left(instring, positionA - 1) & Right(instring, Len(instring) - positionB)
			retstring = Mid(instring, positionA, positionB - positionA + 1)
		Else
			DeleteInBrackets = instring
		End If
	End Function
	
	'' Return operator
	Public Function GetOperator(ByRef pOperator As String, ByRef Position As Integer) As String
		Select Case Mid(pOperator, Position, 1)
			Case "+", "-", "*", "\", "/", "^", "&", "=", "<", ">"
				GetOperator = Mid(pOperator, Position, 1)
			Case Else
				Select Case UCase(Mid(pOperator, Position, 3))
					Case "MOD", "DIV", "XOR", "IMP", "EQV", "NOT", "AND"
						GetOperator = UCase(Mid(pOperator, Position, 3))
					Case Else
						Select Case (UCase(Mid(pOperator, Position, 2)))
							Case "OR", "<=", ">=", "<>"
								GetOperator = UCase(Mid(pOperator, Position, 2))
							Case Else
								If (UCase(Mid(pOperator, Position, 4)) = "LIKE") Then
									GetOperator = UCase(Mid(pOperator, Position, 4))
								Else
									GetOperator = ""
									'UPGRADE_WARNING: Couldn't resolve default property of object Error.DoError. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
                                    'Call ErrorToString().DoError("ERROR: Undefined operator in :" & pOperator)
								End If
						End Select
				End Select
		End Select
	End Function
	
	'' Convert format, like format function except additional features added
	Public Function MyFormat(ByRef param As String, ByRef FormatString As String) As String
		Dim Tempstring As String
		Dim NumberSpaces As String
		' Special format numeric format characters -
		' @ - repersents a number or " "
		If (InStr(FormatString, "!") > 0) Then
			Tempstring = Tempstring
			NumberSpaces = CStr(CountChar(FormatString, "!"))
			FormatString = Replace(FormatString, "!", "")
		Else
			NumberSpaces = CStr(0)
		End If
		
		If (InStr(FormatString, "@") > 0) Then
			FormatString = Replace(FormatString, "@", "#")
			Tempstring = VB6.Format(param, FormatString)
			If (Len(FormatString) > Len(Tempstring)) Then
				Tempstring = Space(Len(FormatString) - Len(Tempstring)) & Tempstring
			End If
		Else
			If (FormatString = "") Then
				Tempstring = param
			Else
				Tempstring = VB6.Format(param, FormatString)
			End If
		End If
		MyFormat = Space(CShort(NumberSpaces)) & Tempstring
	End Function
	
	'' Trims spaces and tabs
	Public Function AllTrim(ByRef instring As String) As String
		Static Tempstring As String
		Tempstring = Replace(instring, vbTab, "") ' Delete tabs
		AllTrim = Trim(Tempstring)
	End Function
	
	''
	Public Function GetNextComma(ByRef param As String) As Integer
		GetNextComma = ScanForNextChar(param, ",")
	End Function
	
	'' Get next string upto a comma, no special checking ("") etc.
	Public Function GetNextParameter(ByRef param As String) As String
		Static i As Integer
		
		i = GetNextComma(param)
		If (i > 0) Then
			'999,66
			GetNextParameter = Left(param, i - 1)
			param = Right(param, Len(param) - i)
		Else
			' 999
			GetNextParameter = param
			param = ""
		End If
	End Function
	
	'' Like get next parameter, but return a double
	Public Function GetNextNumber(ByRef param As String) As Double
		Static pos As Integer
		
		pos = InStr(param, ",")
		If (pos = 0) Then
			GetNextNumber = Val(param)
			param = ""
		Else
			GetNextNumber = Val(Left(param, pos - 1))
			param = Right(param, Len(param) - pos)
		End If
	End Function
	
	'' Returns the position of the next operator '+-*\/' or last position if not found
	Public Function GetOperatorPos(ByRef param As String) As Integer
		Static i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Static char_Renamed As String
		
		i = 1
		Do While (i <= Len(param))
			char_Renamed = Mid(param, i, 1)
			If (IsOperator(param, i) = True) Then
				i = i - 1
				Exit Do
			End If
			
			' Move to next character(if brackets are found then find closing bracket)
			Select Case char_Renamed
				Case "("
					i = GetCloseBracketPos(param, i)
				Case Chr(34)
					If (InStr(i + 1, param, Chr(34)) > 0) Then
						i = InStr(i + 1, param, Chr(34))
					Else
						i = i + 1
					End If
					
				Case Else
					i = i + 1
			End Select
		Loop 
		
		' Hack to make sure operation doesent return > length
		If (i > Len(param)) Then
			i = Len(param)
		End If
		'    GetOperatorPos = ScanForNextChar(param, "+-*/\") - 1
		GetOperatorPos = i
	End Function
	
	'' Simple scan for more operators, shouldent search within brackets
	Public Function IsMoreOperators(ByRef param As String) As Boolean
		Static i As Integer
		
		
		If (GetOperatorPos(param) < Len(param)) Then
			IsMoreOperators = True
		Else
			IsMoreOperators = False
		End If
	End Function
	
	'' Return number of comma in a string
	Public Function CountComma(ByRef param As String) As Integer
		Static i As Integer
		CountComma = CountChar(param, ",")
	End Function
	
	'' Insert a character a number of times
	'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
	Public Function cInsert(ByRef char_Renamed As String, ByRef Times As Integer) As String
		Static i As Integer
		cInsert = ""
		For i = 1 To Times
			cInsert = cInsert & char_Renamed
		Next 
	End Function
	
	'' Gets a string right of a '=' sign
	Public Function GetRightValue(ByRef CurrentLine As String) As String
		GetRightValue = Trim(Right(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, "=")))
	End Function
	
	'' Gets a value right of a '=' sign
	Public Function GetLongValue(ByRef CurrentLine As String) As Integer
		GetLongValue = CInt(Right(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, "=")))
	End Function
	
	'' Get a string left of a '=' sign
	Public Function GetLeftValue(ByRef param As String) As String
		If (InStrRev(param, "=") > 0) Then
			GetLeftValue = Trim(Left(param, InStrRev(param, "=") - 1))
		Else
			GetLeftValue = ""
		End If
	End Function
	
	'' Delete all white space ignoring string literals
	Public Function DeleteWhiteSpace(ByRef pSource As String) As String
		Dim i As Integer
		Dim InSpeech As Boolean
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As New VB6.FixedLengthString(1)
		i = 1
		InSpeech = False
		Do While (i <= Len(pSource))
			char_Renamed.Value = Mid(pSource, i, 1)
			If (char_Renamed.Value = Chr(34)) Then
				InSpeech = Not InSpeech
			End If
			If (InSpeech = False) Then
				If (char_Renamed.Value <> " ") Then
					DeleteWhiteSpace = DeleteWhiteSpace & char_Renamed.Value
				End If
			Else
				DeleteWhiteSpace = DeleteWhiteSpace & char_Renamed.Value
			End If
			i = i + 1
		Loop 
	End Function
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Other useful string operation
	
	'' Ensures a string has an extension
	Public Function CheckExtension(ByRef Name As String, ByRef Extension As String) As String
		If (Right(Name, Len(Extension)) <> Extension) Then
			CheckExtension = Name & Extension
		Else
			CheckExtension = Name
		End If
	End Function
	
	'' Ensure path allways includes a back slash
	Public Function GetPathFromAppPath() As String
		If (Right(My.Application.Info.DirectoryPath, 1) <> "\") Then
			GetPathFromAppPath = My.Application.Info.DirectoryPath & "\"
		Else
			GetPathFromAppPath = My.Application.Info.DirectoryPath
		End If
	End Function
End Class