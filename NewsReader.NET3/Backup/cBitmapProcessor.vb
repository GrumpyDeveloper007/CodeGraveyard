Option Strict Off
Option Explicit On
Friend Class cBitmapProcessor
	''*************************************************************************
	'' Bitmap Processor Object
	''
	'' Designed to indicate what parts of a file have been downloaded
	
	'' Coded by Dale Pitman - PyroDesign
	
	Private Bitmap(20000) As Integer
	Private NewBitmap(20000) As Integer
	Private LastFilename As String
	
	'' Check to see a section of a file has been downloaded
	Public Function CheckFileBitmap(ByRef pfilename As String, ByRef pFileIndex As Integer, ByRef pTotalArticles As Integer) As Integer
		Dim fileid As Integer
		Dim OldBitmapSize As Integer
		Dim tempstring As String
		Dim SearchStop As Double
		Dim i As Integer
		Dim t As Integer
		Dim row As Integer
		
		If LastFilename <> pfilename Then
			LastFilename = pfilename
		End If
		On Error GoTo shit
		fileid = FreeFile
		row = 0
		'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
		If (Dir(FRMOptions.TempDownloadPath & pfilename & ".txt", FileAttribute.Normal) <> "") Then
			FileOpen(fileid, FRMOptions.TempDownloadPath & pfilename & ".txt", OpenMode.Input)
			If (EOF(fileid) = False) Then
				tempstring = LineInput(fileid) ' number of articles
			End If
			
			If (pTotalArticles = 0) Then
				pTotalArticles = Val(tempstring)
			End If
			OldBitmapSize = Val(tempstring)
			Do While (EOF(fileid) = False)
				tempstring = LineInput(fileid)
				For i = 0 To 9
					Bitmap(row * 10 + i) = Val(Mid(tempstring, i + 1, 1))
				Next 
				row = row + 1
			Loop 
			FileClose(fileid)
			
			If pTotalArticles <> OldBitmapSize Then
				' Recalculate bitmap
				For i = 0 To pTotalArticles
					NewBitmap(i + 1) = 1
					SearchStop = (i + 1) * OldBitmapSize / pTotalArticles
					If SearchStop > System.Math.Round(SearchStop) Then
						SearchStop = SearchStop + 1
					End If
					
					For t = i * OldBitmapSize / pTotalArticles To SearchStop
						If Bitmap(t + 1) = 0 Then
							NewBitmap(i + 1) = 0
						End If
					Next 
				Next 
				pTotalArticles = pTotalArticles
				For i = 0 To pTotalArticles
					Bitmap(i) = NewBitmap(i)
				Next 
			End If
			
			' Update the number of articles
			fileid = FreeFile
			row = 0
			FileOpen(fileid, FRMOptions.TempDownloadPath & pfilename & ".txt", OpenMode.Output)
			PrintLine(fileid, pTotalArticles)
			For row = 0 To pTotalArticles / 10 + 1
				tempstring = ""
				For i = 0 To 9
					tempstring = tempstring & Bitmap(row * 10 + i)
				Next 
				PrintLine(fileid, tempstring)
			Next 
			FileClose(fileid)
		Else
			For i = 0 To pTotalArticles
				Bitmap(i) = 0
			Next 
		End If
		
		
		CheckFileBitmap = Bitmap(pFileIndex)
		Exit Function
shit: 
		CheckFileBitmap = 0
	End Function
	
	'' Update a grid that represents the download bitmap
	Public Sub RefreshDownloadBitmap(ByRef pGrid As fpList, ByRef pfileID As Integer, ByRef pArticles As Integer)
		Dim ListApplyToIndividual As Object 'pIndex As Long,
		Static LastTotalArticles As Integer
		Dim i As Integer
		Dim t As Integer
		Dim NewsReadersId As Integer
		
		'If LastTotalArticles <> pArticles Then
		'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.Clear. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		pGrid.Clear()
		For i = 1 To pArticles / 10
			'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.AddItem. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			Call pGrid.AddItem("")
		Next 
		LastTotalArticles = pArticles
		'End If
		
		'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.ListApplyTo. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		'UPGRADE_WARNING: Couldn't resolve default property of object ListApplyToIndividual. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		pGrid.ListApplyTo = ListApplyToIndividual
		For i = 0 To pArticles - 1
			'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			pGrid.Col = i Mod 10
			'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			pGrid.row = i \ 10
			'If i = pIndex Then
			'    pGrid.BackColor = &HFF9F9F
			'Else
			NewsReadersId = -1
			If frmReaderHolder.CheckCurrentlyDownloadingIndex(pfileID, i + 1, NewsReadersId) = True Then
				'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.ColList. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				pGrid.ColList = NewsReadersId
			End If
			
			If NewsReadersId <> -1 Then
				'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				pGrid.BackColor = &HFF9F9F
			Else
				If Bitmap(i + 1) > 0 Then
					'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					pGrid.BackColor = &HFF6F00
				Else
					'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					pGrid.BackColor = &HFFFFFF
				End If
			End If
			'End If
		Next 
		Do While i Mod 10 > 0
			'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			pGrid.Col = i Mod 10
			'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			pGrid.row = i \ 10
			'UPGRADE_WARNING: Couldn't resolve default property of object pGrid.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			pGrid.BackColor = &H9F9F9F
			i = i + 1
		Loop 
		'pGrid.Refresh
	End Sub
	
	'' Check to see if a file is complete (all bitmap elements set)
	Public Function IsCompleteFileBitmap(ByRef pfilename As String, ByRef pTotalArticles As Integer) As Boolean
		Dim fileid As Integer
		Dim Bitmap(2000) As Integer
		Dim tempstring As String
		Dim i As Integer
		Dim row As Integer
		
		fileid = FreeFile
		row = 0
		'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
		If (Dir(FRMOptions.TempDownloadPath & pfilename & ".txt", FileAttribute.Normal) <> "") Then
			FileOpen(fileid, FRMOptions.TempDownloadPath & pfilename & ".txt", OpenMode.Input)
			If (EOF(fileid) = False) Then
				tempstring = LineInput(fileid) ' number of articles
			End If
			If (pTotalArticles = 0) Then
				pTotalArticles = Val(tempstring)
			End If
			Do While (EOF(fileid) = False)
				tempstring = LineInput(fileid)
				For i = 0 To 9
					Bitmap(row * 10 + i) = Val(Mid(tempstring, i + 1, 1))
				Next 
				row = row + 1
			Loop 
			FileClose(fileid)
		End If
		
		
		
		IsCompleteFileBitmap = True
		For i = 1 To pTotalArticles
			If (Bitmap(i) = 0) Then
				IsCompleteFileBitmap = False
				Exit For
			End If
		Next 
	End Function
	
	'' Called whenever a section of a file has been downloaded
	Public Sub UpdateFileBitmap(ByRef pfilename As String, ByRef pFileIndex As Integer, ByRef pTotalArticles As Integer)
		Dim fileid As Integer
		'Dim Bitmap(2000) As Long
		Dim tempstring As String
		Dim i As Integer
		Dim row As Integer
		'Dim TotalArticles As Long
		fileid = FreeFile
		row = 0
		If (pFileIndex = 0) Then
			pFileIndex = 1
		End If
		
		If pTotalArticles <> 421 Then
			i = i
		End If
		
		'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
		If (Dir(FRMOptions.TempDownloadPath & pfilename & ".txt") <> "") Then
			FileOpen(fileid, FRMOptions.TempDownloadPath & pfilename & ".txt", OpenMode.Input)
			tempstring = LineInput(fileid)
			If pTotalArticles = 0 Then
				pTotalArticles = Val(tempstring)
			End If
			Do While (EOF(fileid) = False)
				tempstring = LineInput(fileid)
				For i = 0 To 9
					Bitmap(row * 10 + i) = Val(Mid(tempstring, i + 1, 1))
				Next 
				row = row + 1
			Loop 
			FileClose(fileid)
		Else
			For i = 0 To 2000
				Bitmap(i) = 0
			Next 
		End If
		
		Bitmap(pFileIndex) = Bitmap(pFileIndex) + 1
		
		fileid = FreeFile
		row = 0
		FileOpen(fileid, FRMOptions.TempDownloadPath & pfilename & ".txt", OpenMode.Output)
		If pTotalArticles = 0 Then
			tempstring = tempstring
		End If
		PrintLine(fileid, pTotalArticles)
		For row = 0 To pTotalArticles / 10 + 1
			tempstring = ""
			For i = 0 To 9
				tempstring = tempstring & Bitmap(row * 10 + i)
			Next 
			PrintLine(fileid, tempstring)
		Next 
		FileClose(fileid)
		
	End Sub
End Class