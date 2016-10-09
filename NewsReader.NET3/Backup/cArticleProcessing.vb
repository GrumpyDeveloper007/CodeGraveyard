Option Strict Off
Option Explicit On
Friend Class cArticleProcessing
	''*************************************************************************
	''
	'' Coded by Dale Pitman
	''
	
	'' Article name processing here, this class attempts to recongise the numerious and inconstant way
	'' files are named by different people
	
	Private m_TotalArticles As Integer
	Private m_ArticleNumber As Integer
	
	Private m_TotalFiles As Integer
	Private m_FileNumber As Integer
	
	Private m_CDNumber As Integer
	
	Private m_FileName As String
	Private m_GroupName As String
	
	Private m_mp3Mode As Boolean
	
	
	Public WriteOnly Property Mp3Mode() As Boolean
		Set(ByVal Value As Boolean)
			m_mp3Mode = Value
		End Set
	End Property
	
	Public ReadOnly Property TotalArticles() As Integer
		Get
			TotalArticles = m_TotalArticles
		End Get
	End Property
	
	Public ReadOnly Property ArticleNumber() As Integer
		Get
			ArticleNumber = m_ArticleNumber
		End Get
	End Property
	
	Public ReadOnly Property TotalFiles() As Integer
		Get
			TotalFiles = m_TotalFiles
		End Get
	End Property
	Public ReadOnly Property FileNumber() As Integer
		Get
			FileNumber = m_FileNumber
		End Get
	End Property
	Public ReadOnly Property FileName() As String
		Get
			FileName = m_FileName
		End Get
	End Property
	Public ReadOnly Property GroupName() As String
		Get
			GroupName = m_GroupName
		End Get
	End Property
	
	Private Function SubString(ByRef pString As String, ByRef pStart As Integer, ByRef pEnd As Integer) As String
		SubString = Mid(pString, pStart, pEnd - pStart)
	End Function
	
	Private Function IsNumber(ByRef pString As String) As Boolean
		Dim i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As Integer
		
		IsNumber = True
		For i = 1 To Len(pString)
			char_Renamed = Asc(Mid(pString, i, 1))
			If char_Renamed < 48 Or char_Renamed > 57 Or char_Renamed = 46 Then
				IsNumber = False
				Exit For
			End If
		Next 
	End Function
	
	Private Function IsCharNumber(ByRef pChar As Integer) As Boolean
		If pChar < 48 Or pChar > 59 Then
			IsCharNumber = False
		Else
			IsCharNumber = True
		End If
	End Function
	
	
	Private Function RemoveFileSystemChars(ByRef pString As String) As String
		Dim Tempstring As String
		Dim TempString2 As String
		Dim a As String
		Dim i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As String
		
		Tempstring = Replace(Tempstring, "_", " ")
		Tempstring = Replace(pString, "!", "")
		Tempstring = Replace(Tempstring, Chr(34), "")
		Tempstring = Replace(Tempstring, "/", "")
		Tempstring = Replace(Tempstring, "\", "")
		Tempstring = Replace(Tempstring, "#", "")
		Tempstring = Replace(Tempstring, ":", "")
		Tempstring = Replace(Tempstring, "<", "")
		Tempstring = Replace(Tempstring, ">", "")
		Tempstring = Replace(Tempstring, "*", "")
		Tempstring = Replace(Tempstring, "?", "")
		Tempstring = Replace(Tempstring, "=", "")
		Tempstring = Replace(Tempstring, "|", "")
		Tempstring = Replace(Tempstring, vbCr, "")
		Tempstring = Replace(Tempstring, vbLf, "")
		Tempstring = Replace(Tempstring, "&", "")
		
		TempString2 = ""
		For i = 1 To Len(Tempstring)
			char_Renamed = Mid(Tempstring, i, 1)
			If Asc(char_Renamed) < 20 Then
			Else
				TempString2 = TempString2 & char_Renamed
			End If
		Next 
		Tempstring = TempString2
		
		RemoveFileSystemChars = Tempstring
	End Function
	
	Private Function IsArticleIndex(ByRef pStart As Integer, ByRef pEnd As Integer, ByRef pString As String, ByRef pSlashPos As Integer) As Boolean
		Dim i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As Integer
		IsArticleIndex = True
		
		pStart = pStart + 1
		pEnd = pEnd - 1
		pSlashPos = 0
		
		For i = pStart To pEnd
			char_Renamed = Asc(Mid(pString, i, 1))
			If char_Renamed = Asc("/") Then
				If pSlashPos = 0 Then
					pSlashPos = i - pStart
				Else
					' Invalid string
					IsArticleIndex = False
					Exit For
				End If
			Else
				If char_Renamed = Asc("\") Then
					If pSlashPos = 0 Then
						pSlashPos = i - pStart
					Else
						' Invalid string
						IsArticleIndex = False
						Exit For
					End If
				Else
					If IsCharNumber(char_Renamed) = False Then
						' Invalid string
						IsArticleIndex = False
						Exit For
					End If
				End If
			End If
		Next 
		
		If pSlashPos = 0 Then
			IsArticleIndex = False
		End If
	End Function
	
	Private Function LocateBrackets(ByRef pString As String, ByRef pLeft As String, ByRef pRight As String, ByRef pLeftBracket As Integer, ByRef pRightBracket As Integer, ByRef pSlashPos As Integer) As Boolean
		Dim i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As String
		Dim SlashPos As Integer
		
		pLeftBracket = 0
		For i = Len(pString) To 1 Step -1
			char_Renamed = Mid(pString, i, 1)
			If char_Renamed = pRight Then
				pRightBracket = i
			End If
			
			If pRightBracket > 0 Then
				If char_Renamed = pLeft Then
					pLeftBracket = i
					If IsArticleIndex(pLeftBracket, pRightBracket, pString, pSlashPos) = True Then
						' Found!
						Exit For
					Else
						' Failed
						pLeftBracket = 0
						pRightBracket = 0
					End If
				End If
			End If
		Next 
		
	End Function
	
	Private Function GetArticleIndex(ByRef psubject As String, ByRef pLeftBracketPos As Integer, ByRef pRightBracketPos As Integer, ByRef pArticleNumber As Integer, ByRef pTotalArticles As Integer, ByRef pAlternateBrackets As Boolean) As Boolean
		Dim LeftBracket As Integer
		Dim RightBracket As Integer
		Dim SlashPos As Integer
		Dim i As Integer
		
		pArticleNumber = -1
		pTotalArticles = 0
		GetArticleIndex = False
		LeftBracket = 0
		RightBracket = 0
		
		Call LocateBrackets(psubject, "(", ")", LeftBracket, RightBracket, SlashPos)
		
		If LeftBracket > 0 And RightBracket > 0 Then
			pArticleNumber = CInt(Mid(psubject, LeftBracket, SlashPos))
			pTotalArticles = CInt(Mid(psubject, LeftBracket + SlashPos + 1, RightBracket - (LeftBracket + SlashPos)))
			If pArticleNumber = -1 Or pTotalArticles = 0 Then
			Else
				GetArticleIndex = True
			End If
		Else
			
			Call LocateBrackets(psubject, "[", "]", LeftBracket, RightBracket, SlashPos)
			
			If LeftBracket > 0 And RightBracket > 0 Then
				pArticleNumber = CInt(Mid(psubject, LeftBracket, SlashPos))
				If RightBracket - (LeftBracket + SlashPos) > 0 Then
					pTotalArticles = CInt(Mid(psubject, LeftBracket + SlashPos + 1, RightBracket - (LeftBracket + SlashPos)))
					If pArticleNumber = -1 Or pTotalArticles = 0 Then
					Else
						GetArticleIndex = True
					End If
				End If
			Else
				If pAlternateBrackets = True Then
					Call LocateBrackets(psubject, "(", "]", LeftBracket, RightBracket, SlashPos)
					
					If LeftBracket > 0 And RightBracket > 0 Then
						pArticleNumber = CInt(Mid(psubject, LeftBracket, SlashPos))
						pTotalArticles = CInt(Mid(psubject, LeftBracket + SlashPos + 1, RightBracket - (LeftBracket + SlashPos)))
						If pArticleNumber = -1 Or pTotalArticles = 0 Then
						Else
							GetArticleIndex = True
						End If
					Else
						Call LocateBrackets(psubject, "<", ">", LeftBracket, RightBracket, SlashPos)
						
						If LeftBracket > 0 And RightBracket > 0 Then
							pArticleNumber = CInt(Mid(psubject, LeftBracket, SlashPos))
							pTotalArticles = CInt(Mid(psubject, LeftBracket + SlashPos + 1, RightBracket - (LeftBracket + SlashPos)))
							If pArticleNumber = -1 Or pTotalArticles = 0 Then
							Else
								GetArticleIndex = True
							End If
						End If
					End If
				End If
				
			End If
		End If
		
		pLeftBracketPos = LeftBracket
		pRightBracketPos = RightBracket
	End Function
	
	Private Function GetNofN(ByRef pString As String, ByRef pFileNumber As Integer, ByRef pTotalFiles As Integer, ByRef pReplaceString As String) As Boolean
		Dim i As Integer
		Dim Char4 As String
		Dim NumberStart As Integer
		Dim NumberLen As Integer
		Dim LeftStart As Integer
		Dim Tempstring As String
		GetNofN = False
		pFileNumber = 0
		pTotalFiles = 0
		
		Tempstring = UCase(pString)
		
		'UPGRADE_NOTE: Continue was upgraded to Continue_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim Continue_Renamed As Boolean
		Dim FoundLeftNum As Boolean
		Dim FoundRightNum As Boolean
		For i = 1 To Len(pString)
			
			FoundLeftNum = False
			FoundRightNum = False
			Char4 = Mid(Tempstring, i, 4)
			If Left(Char4, 2) = "OF" Then
				
				' Looks like 00of00
				NumberStart = i - 1
				NumberLen = 1
				FoundLeftNum = False
				Continue_Renamed = True
				Do While (NumberStart > 1 And NumberStart < Len(pString) And Continue_Renamed = True)
					Continue_Renamed = False
					If IsNumber(Mid(pString, NumberStart, 1)) = True Then
						Continue_Renamed = True
						FoundLeftNum = True
					End If
					If Mid(pString, NumberStart, 1) = " " And FoundLeftNum = False Then
						Continue_Renamed = True
					End If
					
					If FoundLeftNum = False Or Continue_Renamed = True Then
						NumberStart = NumberStart - 1
						NumberLen = NumberLen + 1
					End If
				Loop 
				If FoundLeftNum = True Then
					pFileNumber = CInt(Mid(pString, NumberStart + 1, NumberLen - 1))
					LeftStart = NumberStart + 1
					
					NumberStart = i + 2
					NumberLen = 1
					Continue_Renamed = True
					FoundRightNum = False
					Do While (NumberStart > 1 And NumberStart < Len(pString) And Continue_Renamed = True)
						Continue_Renamed = False
						If IsNumber(Mid(pString, NumberStart, 1)) = True Then
							Continue_Renamed = True
							FoundRightNum = True
						End If
						If Mid(pString, NumberStart, 1) = " " And FoundRightNum = False Then
							Continue_Renamed = True
						End If
						
						If FoundRightNum = False Or Continue_Renamed = True Then
							NumberStart = NumberStart + 1
							NumberLen = NumberLen + 1
						End If
					Loop 
					
					If FoundLeftNum = True And FoundRightNum = True Then
						If NumberLen > 1 Then
							pTotalFiles = CInt(Mid(pString, i + 2, NumberLen - 1))
						Else
							pTotalFiles = CInt(Mid(pString, i + 2, NumberLen))
						End If
						
						If LeftStart > 5 Then
							If Mid(pString, LeftStart - 5, 4) = "File" Then
								pReplaceString = Mid(pString, LeftStart - 5, NumberStart - LeftStart + 5)
							Else
								pReplaceString = Mid(pString, LeftStart, NumberStart - LeftStart)
							End If
						End If
						
						GetNofN = True
						Exit Function
					End If
				End If
			End If
			
		Next 
		
	End Function
	
	Private Function SearchForTrackIndexes(ByRef pString As String, ByRef pEnd As Integer, ByRef pStart As Integer) As Boolean
		Dim i As Integer
		Dim TrackIndex As String
		Dim TrackIndexLong As Integer
		Dim Found As Boolean
		Dim Number2 As Integer
		Dim Number2Dash As Integer
		Dim Number2DashSpace As Integer
		Dim Next2Chars As String
		Dim t As Integer
		SearchForTrackIndexes = False
		pStart = 0
		Number2 = 0
		Number2Dash = 0
		Number2DashSpace = 0
		
		For i = pEnd - 3 To 1 Step -1
			
			TrackIndex = Mid(pString, i, 1)
			t = i + 1
			Do While t < Len(pString)
				If IsNumeric_Renamed(Mid(pString, t, 1)) = True Then
					TrackIndex = TrackIndex & Mid(pString, t, 1)
				Else
					Exit Do
				End If
				t = t + 1
			Loop 
			
			TrackIndexLong = Val(TrackIndex)
			If IsNumber(TrackIndex) = True Then
				Found = False
				If i = 1 Then
					Found = True
				Else
					If IsNumber(Mid(pString, i - 1, 1)) = False Then
						Found = True
					End If
				End If
				
				If Found = True Then
					If IsNumber(Mid(pString, i + Len(TrackIndex), 1)) = False Then
						If TrackIndexLong < 40 Or TrackIndexLong >= 100 Then
							If Number2 = 0 Then
								Number2 = i
							End If
							
							SearchForTrackIndexes = True
							
							Next2Chars = Mid(pString, i + Len(TrackIndex), 3)
							If Next2Chars = " - " Then
								Number2DashSpace = i
								Exit For
							End If
							
							If Mid(pString, t, 1) = "-" Then
								
								Number2Dash = i
								'Exit For
							End If
						End If
					End If
				End If
			End If
		Next 
		If Number2DashSpace > 0 Then
			pStart = Number2DashSpace
		Else
			If Number2Dash > 0 Then
				pStart = Number2Dash
			Else
				pStart = Number2
			End If
		End If
		
	End Function
	
	Private Function StripCDIndexes(ByRef psubject As String) As String
		Dim CDStart As Integer
		Dim Tempstring As String
		Dim ReplaceString As String
		Dim i As Integer
		Tempstring = UCase(psubject)
		ReplaceString = ""
		
		CDStart = InStr(1, Tempstring, "DISC", CompareMethod.Text)
		Do While CDStart > 0
			If CDStart > 0 Then
				If Mid(Tempstring, CDStart, 5) = "DISC " And IsNumber(Mid(Tempstring, CDStart + 5, 1)) = True And Len(Mid(Tempstring, CDStart + 5, 1)) > 0 Then
					m_CDNumber = CInt(Mid(Tempstring, CDStart + 5, 1))
					ReplaceString = Mid(psubject, CDStart, 6)
					Exit Do
				Else
					If Mid(Tempstring, CDStart, 4) = "DISC" And IsNumber(Mid(Tempstring, CDStart + 4, 1)) = True And Len(Mid(Tempstring, CDStart + 4, 1)) > 0 Then
						m_CDNumber = CInt(Mid(Tempstring, CDStart + 4, 1))
						ReplaceString = Mid(psubject, CDStart, 5)
						Exit Do
					End If
				End If
			End If
			i = CDStart + 1
			CDStart = InStr(i, Tempstring, "DISC", CompareMethod.Text)
		Loop 
		
		CDStart = InStr(1, Tempstring, "CD", CompareMethod.Text)
		Do While CDStart > 0
			If CDStart > 0 And CDStart + 3 < Len(Tempstring) Then
				If Mid(Tempstring, CDStart, 3) = "CD " And IsNumber(Mid(Tempstring, CDStart + 3, 1)) = True Then
					m_CDNumber = CInt(Mid(Tempstring, CDStart + 3, 1))
					ReplaceString = Mid(psubject, CDStart, 4)
					Exit Do
				Else
					If Mid(Tempstring, CDStart, 2) = "CD" And IsNumber(Mid(Tempstring, CDStart + 2, 1)) = True Then
						m_CDNumber = CInt(Mid(Tempstring, CDStart + 2, 1))
						ReplaceString = Mid(psubject, CDStart, 3)
						Exit Do
					End If
				End If
			End If
			i = CDStart + 1
			CDStart = InStr(i, Tempstring, "CD", CompareMethod.Text)
		Loop 
		
		
		CDStart = InStr(1, Tempstring, "CD#", CompareMethod.Text)
		Do While CDStart > 0
			If CDStart > 0 Then
				If Mid(Tempstring, CDStart, 3) = "CD# " And IsNumber(Mid(Tempstring, CDStart + 4, 1)) = True Then
					m_CDNumber = CInt(Mid(Tempstring, CDStart + 4, 1))
					ReplaceString = Mid(psubject, CDStart, 5)
					Exit Do
				Else
					If Mid(Tempstring, CDStart, 3) = "CD#" And IsNumber(Mid(Tempstring, CDStart + 3, 1)) = True Then
						m_CDNumber = CInt(Mid(Tempstring, CDStart + 3, 1))
						ReplaceString = Mid(psubject, CDStart, 4)
						Exit Do
					End If
				End If
			End If
			i = CDStart + 1
			CDStart = InStr(i, Tempstring, "CD#", CompareMethod.Text)
		Loop 
		
		StripCDIndexes = Replace(psubject, ReplaceString, "")
	End Function
	
	Private Function RemoveFromTo(ByRef pString As String) As String
		Dim pos As Integer
		Dim pos2 As Integer
		Dim Tempstring As String
		
		Tempstring = pString
		
		pos = InStr(1, Tempstring, " posts ", CompareMethod.Text)
		If pos > 0 Then
			Tempstring = Mid(Tempstring, pos + 7)
		End If
		
		pos = InStr(1, Tempstring, "heres-", CompareMethod.Text)
		pos2 = InStr(1, Tempstring, "my-req-", CompareMethod.Text)
		If pos > 0 And pos2 > 0 Then
			pos = pos
			
		End If
		
		pos = InStr(1, Tempstring, "req ", CompareMethod.Text)
		pos2 = InStr(1, Tempstring, "here  is", CompareMethod.Text)
		If pos > 0 And pos2 > 0 Then
			pos = pos
			
		End If
		
		pos = InStr(1, Tempstring, "my req ", CompareMethod.Text)
		If pos > 0 And pos2 > 0 Then
			pos = pos
			
		End If
		
		pos = InStr(1, Tempstring, "attn ", CompareMethod.Text)
		If pos > 0 And pos2 > 0 Then
			pos = pos
			
		End If
		
		
		RemoveFromTo = Tempstring
	End Function
	
	
	Private Function RemoveWords(ByRef pString As String) As String
		Dim Tempstring As String
		
		Tempstring = pString
		
		Tempstring = Replace(Tempstring, "DEFTONES_FLOOD--=FTPNETWORK.COM_CptSpAnKy=--", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "mp3freak post", "", 1, -1, CompareMethod.Text)
		
		Tempstring = Replace(Tempstring, "(yenc)", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "yenc", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "REPOST - ", "", 1, -1, CompareMethod.Text)
		'tempstring = Replace(tempstring, "PER REQ - ", "", 1, -1, vbTextCompare)
		
		'tempstring = Replace(tempstring, "here's ", "", 1, -1, vbTextCompare)
		'tempstring = Replace(tempstring, "filling req ", "", 1, -1, vbTextCompare)
		Tempstring = Replace(Tempstring, "(<>manuforever<>)", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "(reddevil)", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "(repost)", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "(repost_sorry)", "", 1, -1, CompareMethod.Text)
		
		Tempstring = Replace(Tempstring, "[- neoclassical -]", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "[john5ice] ", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "[requested] ", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "{newage}", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "misery", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "repost", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "(wtb)", "", 1, -1, CompareMethod.Text)
		
		Tempstring = Replace(Tempstring, "as requested", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "as req", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "posting", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "here's", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "here is ", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "filling req", "", 1, -1, CompareMethod.Text)
		Tempstring = Replace(Tempstring, "tia here is", "", 1, -1, CompareMethod.Text)
		
		RemoveWords = Tempstring
	End Function
	
	Private Function ScanLeft(ByRef pString As String, ByRef pNumberStart As Integer) As String
		Dim NumberStart As Integer
		Dim NumberLen As Integer
		'UPGRADE_NOTE: Continue was upgraded to Continue_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim Continue_Renamed As Boolean
		Dim FoundNumeric As Boolean
		
		NumberStart = pNumberStart - 1
		NumberLen = 1
		Continue_Renamed = True
		FoundNumeric = False
		Do While (NumberStart > 1 And NumberStart <= Len(pString) And Continue_Renamed = True)
			Continue_Renamed = False
			If IsNumber(Mid(pString, NumberStart, 1)) = True Then
				Continue_Renamed = True
				FoundNumeric = True
			End If
			If Mid(pString, NumberStart, 1) = " " And FoundNumeric = False Then
				Continue_Renamed = True
			End If
			
			If FoundNumeric = False Or Continue_Renamed = True Then
				NumberStart = NumberStart - 1
				NumberLen = NumberLen + 1
			End If
		Loop 
		
		If FoundNumeric = True Then
			ScanLeft = Mid(pString, NumberStart + 1, NumberLen - 1)
		Else
			ScanLeft = ""
		End If
		
	End Function
	
	Private Function GetNBytes(ByRef pString As String) As String
		Dim BytesPos As Integer
		Dim ReplaceString As String
		Dim Tempstring As String
		Tempstring = pString
		
		BytesPos = InStr(1, Tempstring, "BYTES", CompareMethod.Text)
		If BytesPos > 0 Then
			ReplaceString = ScanLeft(Tempstring, BytesPos)
			If ReplaceString <> "" Then
				Tempstring = Replace(Tempstring, ReplaceString & "bytes", "", 1, -1, CompareMethod.Text)
			End If
		End If
		
		BytesPos = InStr(1, Tempstring, "mbytes", CompareMethod.Text)
		If BytesPos > 0 Then
			ReplaceString = ScanLeft(Tempstring, BytesPos)
			If ReplaceString <> "" Then
				Tempstring = Replace(Tempstring, ReplaceString & "mbytes", "", 1, -1, CompareMethod.Text)
			End If
		End If
		
		BytesPos = InStr(1, Tempstring, "kbyte", CompareMethod.Text)
		If BytesPos > 0 Then
			ReplaceString = ScanLeft(Tempstring, BytesPos)
			If ReplaceString <> "" Then
				Tempstring = Replace(Tempstring, ReplaceString & "kbyte", "", 1, -1, CompareMethod.Text)
			End If
		End If
		
		BytesPos = InStr(1, Tempstring, "kb", CompareMethod.Text)
		If BytesPos > 0 Then
			ReplaceString = ScanLeft(Tempstring, BytesPos)
			If ReplaceString <> "" Then
				Tempstring = Replace(Tempstring, ReplaceString & "kb", "", 1, -1, CompareMethod.Text)
			End If
		End If
		
		BytesPos = InStr(1, Tempstring, " k", CompareMethod.Text)
		If BytesPos > 0 Then
			ReplaceString = ScanLeft(Tempstring, BytesPos)
			If ReplaceString <> "" Then
				Tempstring = Replace(Tempstring, ReplaceString & " k", "", 1, -1, CompareMethod.Text)
			End If
		End If
		
		BytesPos = InStr(1, Tempstring, "k", CompareMethod.Text)
		Do While BytesPos > 0
			ReplaceString = ScanLeft(Tempstring, BytesPos)
			If ReplaceString <> "" Then
				Tempstring = Replace(Tempstring, ReplaceString & "k", "", 1, -1, CompareMethod.Text)
			End If
			BytesPos = InStr(BytesPos + 1, Tempstring, "k", CompareMethod.Text)
		Loop 
		
		GetNBytes = Tempstring
	End Function
	
	Private Function TrimDash(ByRef pString As String) As String
		Dim i As Integer
		'UPGRADE_NOTE: char was upgraded to char_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim char_Renamed As String
		
		i = Len(pString)
		Do While i > 0
			char_Renamed = Mid(pString, i, 1)
			If char_Renamed <> "-" And char_Renamed <> " " Then
				Exit Do
			End If
			i = i - 1
		Loop 
		
		TrimDash = Mid(pString, 1, i)
	End Function
	
	Public Function ProcessSubject(ByRef psubject As String) As Boolean
		Dim LeftBracket As Integer
		Dim RightBracket As Integer
		Dim ProcessedSubject As String
		Dim FileNameEnd As Integer
		Dim FileNameStart As Integer
		Dim nnOfnn As String
		Dim i As Integer
		Dim Tempstring As String
		Dim FileStartCursor As Integer
		ProcessSubject = False
		
		Dim SpacePos As Integer
		Dim DashPos As Integer
		Dim IndexPos As Integer
		
		m_FileName = ""
		m_GroupName = ""
		m_CDNumber = -1
		
		If GetArticleIndex(psubject, LeftBracket, RightBracket, m_ArticleNumber, m_TotalArticles, False) = True Then
			ProcessedSubject = Replace(psubject, Mid(psubject, LeftBracket - 1, RightBracket - LeftBracket + 3), "")
			
			If m_mp3Mode = True Then
				ProcessedSubject = RemoveFromTo(ProcessedSubject)
			End If
			
			' Remove yenc etc
			ProcessedSubject = RemoveWords(ProcessedSubject)
			
			
			' Use Brackets to get file numbers
			LeftBracket = 0
			RightBracket = 0
			If GetArticleIndex(ProcessedSubject, LeftBracket, RightBracket, m_FileNumber, m_TotalFiles, True) = True Then
				ProcessedSubject = Replace(ProcessedSubject, Mid(ProcessedSubject, LeftBracket - 1, RightBracket - LeftBracket + 3), "")
			Else
				' No filenumbers
			End If
			
			m_TotalFiles = 0
			m_FileNumber = 0
			If GetNofN(ProcessedSubject, m_FileNumber, m_TotalFiles, nnOfnn) = True Then
				ProcessedSubject = Replace(ProcessedSubject, nnOfnn, "", 1, -1, CompareMethod.Text)
			Else
			End If
			
			
			FileNameEnd = FindFileNameExtension(ProcessedSubject, False)
			If FileNameEnd > 0 Then
				If Mid(ProcessedSubject, FileNameEnd + 1, 1) = Chr(34) And InStrRev(ProcessedSubject, Chr(34), FileNameEnd) > 0 Then
					' Use chr$34
					FileNameStart = InStrRev(ProcessedSubject, Chr(34), FileNameEnd)
					m_FileName = SubString(ProcessedSubject, FileNameStart + 1, FileNameEnd + 1)
					m_GroupName = Replace(ProcessedSubject, Chr(34) & m_FileName & Chr(34), "")
				Else
					
					FileStartCursor = FileNameEnd
					Tempstring = UCase(ProcessedSubject)
					
					
					If m_mp3Mode = False Then
						For i = 8 To 10
							If FileNameEnd > i Then
								If Mid(Tempstring, FileNameEnd - i, 4) = "PART" Then
									FileStartCursor = FileNameEnd - i
									Exit For
								End If
							End If
						Next 
						IndexPos = 0
					Else
						' Search for track indexs
						If SearchForTrackIndexes(ProcessedSubject, FileStartCursor, IndexPos) Then
						End If
						
					End If
					
					
					SpacePos = InStrRev(Tempstring, " ", FileStartCursor)
					DashPos = InStrRev(Tempstring, " - ", FileStartCursor)
					
					If IndexPos <> 0 Then
						m_FileName = SubString(ProcessedSubject, IndexPos, FileNameEnd + 1)
					Else
						If SpacePos = 0 And DashPos = 0 Then
							m_FileName = SubString(ProcessedSubject, 1, FileNameEnd + 1)
						Else
							If SpacePos > DashPos And DashPos <> 0 Then
								m_FileName = SubString(ProcessedSubject, DashPos + 3, FileNameEnd + 1)
							Else
								m_FileName = SubString(ProcessedSubject, SpacePos + 1, FileNameEnd + 1)
							End If
							
						End If
					End If
					
					
					ProcessedSubject = Replace(ProcessedSubject, m_FileName, "")
					
					
					
					m_GroupName = ProcessedSubject
					m_FileName = MakeLegalFolderName(m_FileName)
				End If
				
				
				' Strip CD indexes
				m_GroupName = StripCDIndexes(m_GroupName)
				
				If m_CDNumber > 0 And m_mp3Mode = True Then
					m_FileName = m_CDNumber & m_FileName
				End If
				
				m_GroupName = TrimDash(m_GroupName)
				m_GroupName = GetNBytes(m_GroupName)
				m_GroupName = MakeLegalFolderName(m_GroupName)
			Else
				' No filename found
			End If
			
			' Remove speech marks from filename
			m_FileName = Trim(Replace(m_FileName, Chr(34), ""))
			m_FileName = Trim(Replace(m_FileName, "|", ""))
			
			
			
			ProcessSubject = True
		End If
		
	End Function
	
	''inuse
	Private Function Find3Extension(ByRef pString As String) As Integer
		Dim pos As Integer
		Find3Extension = 0
		pString = LCase(pString)
		
		If (Find3Extension < InStrRev(pString, ".ogg",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".ogg",  , CompareMethod.Text)
		End If
		
		' Try and search for longer extensions
		If (Find3Extension < InStrRev(pString, ".zip",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".zip",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".mp3",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".mp3",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".jpg",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".jpg",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".gif",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".gif",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".m3u",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".m3u",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".sfv",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".sfv",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".log",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".log",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".txt",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".txt",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".doc",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".doc",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".bmp",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".bmp",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".wma",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".wma",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".htm",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".htm",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".wav",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".wav",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".vob",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".vob",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".mpg",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".mpg",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".rar",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".rar",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".par",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".par",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".exe",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".exe",  , CompareMethod.Text)
		End If
		
		If (Find3Extension < InStrRev(pString, ".wmv",  , CompareMethod.Text)) Then
			Find3Extension = InStrRev(pString, ".wmv",  , CompareMethod.Text)
		End If
		
		
		pos = 0
		pos = InStrRev(pString, ".0", pos - 1, CompareMethod.Text)
		Do While pos > 1
			If (Find3Extension < pos And IsNumeric_Renamed(Mid(pString, pos + 2, 2))) Then
				Find3Extension = pos
				Exit Do
			End If
			pos = InStrRev(pString, ".0", pos - 1, CompareMethod.Text)
		Loop 
		
		If Find3Extension = 0 Then
			pos = InStrRev(pString, ".1", -1, CompareMethod.Text)
			Do While pos > 1
				If (Find3Extension < pos And IsNumeric_Renamed(Mid(pString, pos + 2, 2))) Then
					Find3Extension = pos
					Exit Do
				End If
				pos = InStrRev(pString, ".1", pos - 1, CompareMethod.Text)
			Loop 
			
			If Find3Extension = 0 Then
				
				pos = InStrRev(pString, ".r", -1, CompareMethod.Text)
				Do While pos > 1
					If (Find3Extension < pos And IsNumeric_Renamed(Mid(pString, pos + 2, 2))) Then
						Find3Extension = pos
						Exit Do
					End If
					pos = InStrRev(pString, ".r", pos - 1, CompareMethod.Text)
				Loop 
				
				If Find3Extension = 0 Then
					pos = InStrRev(pString, ".2", -1, CompareMethod.Text)
					Do While pos > 1
						If (Find3Extension < pos And IsNumeric_Renamed(Mid(pString, pos + 2, 2))) Then
							Find3Extension = pos
							Exit Do
						End If
						pos = InStrRev(pString, ".2", pos - 1, CompareMethod.Text)
					Loop 
					If Find3Extension = 0 Then
						pos = InStrRev(pString, ".s", -1, CompareMethod.Text)
						Do While pos > 0
							If (Find3Extension < pos And IsNumeric_Renamed(Mid(pString, pos + 2, 2))) Then
								Find3Extension = pos
								Exit Do
							End If
							If pos > 1 Then
								pos = InStrRev(pString, ".s", pos - 1, CompareMethod.Text)
							Else
								pos = 0
							End If
						Loop 
						If Find3Extension = 0 Then
							
							If (Find3Extension < InStrRev(pString, ".p",  , CompareMethod.Text)) Then
								Find3Extension = InStrRev(pString, ".p",  , CompareMethod.Text)
							End If
							
						End If
					End If
					
					If (Find3Extension < InStrRev(pString, ".nfo",  , CompareMethod.Text)) Then
						Find3Extension = InStrRev(pString, ".nfo",  , CompareMethod.Text)
					End If
				End If
			End If
			
		End If
	End Function
	
	
	Private Function FindFileNameExtension(ByRef pString As String, ByRef pIgnoreError As Boolean) As Integer
		
		If (FindFileNameExtension < InStrRev(pString, ".jpeg",  , CompareMethod.Text)) Then
			FindFileNameExtension = InStrRev(pString, ".jpeg",  , CompareMethod.Text) + 4
		End If
		
		If (FindFileNameExtension < InStrRev(pString, ".mpeg",  , CompareMethod.Text)) Then
			FindFileNameExtension = InStrRev(pString, ".mpeg",  , CompareMethod.Text) + 4
		End If
		
		If (FindFileNameExtension < InStrRev(pString, ".par2",  , CompareMethod.Text)) Then
			FindFileNameExtension = InStrRev(pString, ".par2",  , CompareMethod.Text) + 4
		End If
		
		If FindFileNameExtension = 0 Then
			' OK try and get the filename using .rXX or .PXX
			FindFileNameExtension = Find3Extension(pString)
			If (FindFileNameExtension > 0) Then
				FindFileNameExtension = FindFileNameExtension + 3
			End If
			pString = LCase(pString)
		End If
		
	End Function
	
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Filename processing
	
	
	Private Function MakeLegalFolderName2(ByRef pString As String) As String
		Dim Tempstring As String
		Dim TempString2 As String
		Dim a As String
		Dim i As Integer
		
		
		Tempstring = Replace(pString, "!", "")
		Tempstring = Replace(Tempstring, "()", "")
		Tempstring = Replace(Tempstring, "thnx", "")
		Tempstring = Replace(Tempstring, Chr(34), "")
		Tempstring = Replace(Tempstring, "/", "")
		Tempstring = Replace(Tempstring, "\", "")
		Tempstring = Replace(Tempstring, "#", "")
		Tempstring = Replace(Tempstring, ":", "")
		Tempstring = Replace(Tempstring, "<", "")
		Tempstring = Replace(Tempstring, ">", "")
		Tempstring = Replace(Tempstring, "*", "")
		Tempstring = Replace(Tempstring, "?", "")
		Tempstring = Replace(Tempstring, "=", "")
		Tempstring = Replace(Tempstring, "|", "")
		Tempstring = Replace(Tempstring, vbCr, "")
		Tempstring = Replace(Tempstring, vbLf, "")
		Tempstring = Replace(Tempstring, "&", "")
		
		TempString2 = ""
		For i = 1 To Len(Tempstring)
			If (Asc(Mid(Tempstring, i, 1)) < 20) Then
			Else
				TempString2 = TempString2 & Mid(Tempstring, i, 1)
			End If
		Next 
		Tempstring = TempString2
		
		MakeLegalFolderName2 = Tempstring
	End Function
	
	Public Function MakeLegalFolderName(ByRef pString As String) As String
		Dim Tempstring As String
		Dim a As String
		Tempstring = MakeLegalFolderName2(pString)
		
		' Remove <n> bytes
		If (InStr(1, Tempstring, "bytes", CompareMethod.Text) > 1) Then
			a = Mid(Tempstring, 1, InStr(1, Tempstring, "bytes", CompareMethod.Text) - 2)
			Do While (IsNumeric_Renamed(Right(a, 1)) = True And a <> "")
				a = Left(a, Len(a) - 1)
			Loop 
			Tempstring = a
		End If
		
		' Remove <n>K
		If (InStrRev(Tempstring & " ", "K ", CompareMethod.Text) > 0) Then
			a = Mid(Tempstring, 1, InStrRev(Tempstring, "k", CompareMethod.Text) - 2)
			Do While (IsNumeric_Renamed(Right(a, 1)) = True Or Right(a, 1) = "(" Or Right(a, 1) = ")" Or Right(a, 1) = "[" Or Right(a, 1) = "]")
				a = Left(a, Len(a) - 1)
			Loop 
			Tempstring = a
		End If
		
		Tempstring = Replace(Tempstring, "]", "")
		
		' Remove file <n> of <m>
		Dim ofpos As Integer
		If (InStr(1, Tempstring, "File", CompareMethod.Text) > 0) Then
			ofpos = InStr(1, Tempstring, "File", CompareMethod.Text)
			If (Mid(Tempstring, InStr(1, Tempstring, "File", CompareMethod.Text) + 8, 2) = "of") Then
				a = Replace(Tempstring, Mid(Tempstring, ofpos, 13), "")
			Else
				a = Tempstring
			End If
			Tempstring = a
		End If
		
		Tempstring = Trim(Tempstring)
		If (Right(Tempstring, 2) = " -") Then
			Tempstring = Left(Tempstring, Len(Tempstring) - 2)
		End If
		
		If (UCase(Left(Tempstring, 6)) = "AS REQ") Then
			Tempstring = Mid(Tempstring, 7)
		End If
		
		If (Left(Tempstring, 1) = "(" And Right(Tempstring, 1) = ")") Then
			Tempstring = Mid(Tempstring, 2, Len(Tempstring) - 2)
		End If
		
		MakeLegalFolderName = Tempstring
	End Function
	
	
	''inuse
	Public Function GetFileNameWithNoExtenstion(ByRef pName As String) As String
		Dim ExtensionStart As Integer
		Dim Tempstring As String
		ExtensionStart = Find3Extension(pName) - 1
		
		If (ExtensionStart <> -1) Then
			Tempstring = Mid(pName, 1, ExtensionStart)
			
			If (InStr(Tempstring, ".part") > 0) Then
				Tempstring = Mid(Tempstring, 1, InStr(Tempstring, ".part") - 1)
			End If
			
			GetFileNameWithNoExtenstion = Tempstring
		Else
			GetFileNameWithNoExtenstion = ""
		End If
	End Function
End Class