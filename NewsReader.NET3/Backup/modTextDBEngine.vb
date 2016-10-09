Option Strict Off
Option Explicit On
Module modTextDBEngine
	''*************************************************************************
	''
	'' Coded by Dale Pitman
	''
	
	Private Const FILE_BEGIN As Integer = 0
	Private Const FILE_END As Integer = 2
	Private Const GENERIC_READ_WRITE As Integer = &HC0000000
	Private Const FILE_SHARE_READ_WRITE As Integer = &H3
	Private Const OPEN_EXISTING As Integer = 3
	Private Const FILE_ATTRIBUTE_NORMAL As Integer = &H80
	
	Private Structure SECURITY_ATTRIBUTES
		Dim nLength As Integer
		Dim lpSecurityDescriptor As Integer
		Dim bInheritHandle As Integer
	End Structure
	
	'UPGRADE_WARNING: Structure SECURITY_ATTRIBUTES may require marshalling attributes to be passed as an argument in this Declare statement. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="C429C3A5-5D47-4CD9-8F51-74A1616405DC"'
	Private Declare Function CreateFile Lib "kernel32"  Alias "CreateFileA"(ByVal lpFileName As String, ByVal dwDesiredAccess As Integer, ByVal dwShareMode As Integer, ByRef lpSecurityAttributes As SECURITY_ATTRIBUTES, ByVal dwCreationDisposition As Integer, ByVal dwFlagsAndAttributes As Integer, ByVal hTemplateFile As Integer) As Integer
	
	Private Declare Function SetFilePointer Lib "kernel32" (ByVal hFile As Integer, ByVal lDistanceToMove As Integer, ByRef lpDistanceToMoveHigh As Integer, ByVal dwMoveMethod As Integer) As Integer
	Private Declare Function SetEndOfFile Lib "kernel32" (ByVal hFile As Integer) As Integer
	Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Integer) As Integer
	
	''
	'' FileID storage
	''
	Public gFileIDBase As Integer
	Private gFileHandle As Integer
	Private gDatabasePath As String
	
	Public Structure ArticleType
		Dim ArticleID As Integer
		Dim GroupID As Integer
		Dim FileIndex As Short ' 10 bytes
	End Structure
	
	Public Const cFileGroupSize As Integer = 100
	Private Const cFileCacheSize As Integer = 100
	
	Private m_CacheGroup(205) As ArticleType
	
	'' Get the storage location of the text database and open it
	Public Sub InitFileStorage()
		On Error GoTo ignore
		gFileIDBase = Val(GetServerSetting("FileIDBase", False))
		
		gDatabasePath = FRMOptions.Database
		
		gFileHandle = FreeFile
		FileOpen(gFileHandle, gDatabasePath & "FileID.txt", OpenMode.Binary)
		'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
		If Dir(gDatabasePath & "ext\", FileAttribute.Directory) = "" Then
			MkDir((gDatabasePath & "ext\"))
		End If
ignore: 
	End Sub
	
	'' Close file handle associated with the text database
	Public Sub CloseFileStorage()
		FileClose(gFileHandle)
	End Sub
	
	'' Compress free space at the start of the file and update starting fileid for first entry in file
	Public Sub CompactDB()
		Dim rstemp As ADODB.Recordset
		Dim NewBase As Integer
		Dim LastRec As Integer
		Dim FirstRec As Integer
		Dim NewStart As Integer
		Dim CopyBuffer(1023) As Byte
		Dim FirstBase As Integer
		Dim i As Integer
		
		Call OpenRecordset(rstemp, "SELECT TOP 1  UID FROM [File] ORDER BY UID ASC", dbOpenSnapshot)
		NewBase = rstemp.Fields("UID").Value
		FirstBase = NewBase
		FirstRec = 1 + (NewBase - gFileIDBase) * 10 * cFileGroupSize
		Call OpenRecordset(rstemp, "SELECT TOP 1 UID FROM [File] ORDER BY UID DESC", dbOpenSnapshot)
		NewBase = rstemp.Fields("UID").Value - 2
		If 1 + (NewBase - gFileIDBase) * 10# * cFileGroupSize > 2 ^ 31 Then
			LastRec = 2 ^ 31 - 1
		Else
			LastRec = 1 + (NewBase - gFileIDBase) * 10# * cFileGroupSize
		End If
		
		NewStart = 1
		Do While FirstRec < LastRec
			'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
			FileGet(gFileHandle, CopyBuffer, FirstRec)
			'UPGRADE_WARNING: Put was upgraded to FilePut and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
			FilePut(gFileHandle, CopyBuffer, NewStart)
			FirstRec = FirstRec + 1024
			NewStart = NewStart + 1024
		Loop 
		
		
		Call SetServerSetting("FileIDBase", CStr(FirstBase))
		gFileIDBase = FirstBase
		
		' Clear all old data
		FileClose(gFileHandle)
		Call TruncateFile(gDatabasePath & "FileID.txt", NewStart)
		Call InitFileStorage()
		'    For i = 0 To 1023
		'        CopyBuffer(i) = 0
		'    Next
		'    Do While NewStart < (2 * 1024# * 1024# * 1024#) - 1024
		'        Put #gFileHandle, NewStart, CopyBuffer
		'        'FirstRec = FirstRec + 1024
		'        NewStart = NewStart + 1024
		'    Loop
		'LOF(gFileHandle) = NewStart
		
	End Sub
	
	'' Get all article ids for a given fileid
	Public Sub GetAllArticlesByFileID(ByRef pfileID As Integer, ByRef ids() As ArticleType)
		Dim FirstRec As Integer
		Dim i As Integer
		Dim ExtentID As Integer
		
		Dim tempArticles(4000) As ArticleType
		Dim tempArticlesMax As Integer
		
		FirstRec = 1 + (pfileID - gFileIDBase) * 10 * cFileGroupSize
		
		'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
		FileGet(gFileHandle, tempArticles(tempArticlesMax), FirstRec + i * 10) '.ArticleID,GroupID,FileIndex
		
		'    tempArticlesMax = tempArticlesMax + 1
		Do While tempArticles(tempArticlesMax).ArticleID <> 0 And i < cFileGroupSize - 1
			tempArticlesMax = tempArticlesMax + 1
			i = i + 1
			'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
			FileGet(gFileHandle, tempArticles(tempArticlesMax), FirstRec + i * 10) '.ArticleID,GroupID,FileIndex
			
		Loop 
		
		If i = cFileGroupSize - 1 Then
			' Read ext
			ExtentID = FreeFile
			'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
			If Dir(gDatabasePath & "ext\" & pfileID & ".exd", FileAttribute.Normal) <> "" Then
				FileOpen(ExtentID, gDatabasePath & "ext\" & pfileID & ".exd", OpenMode.Binary)
				i = 0
				'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
				FileGet(ExtentID, tempArticles(tempArticlesMax), 1 + i * 10) '.ArticleID,GroupID,FileIndex
				
				Do While tempArticles(tempArticlesMax).ArticleID <> 0
					tempArticlesMax = tempArticlesMax + 1
					i = i + 1
					'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
					FileGet(ExtentID, tempArticles(tempArticlesMax), 1 + i * 10) '.ArticleID,GroupID,FileIndex
				Loop 
				FileClose(ExtentID)
			End If
		End If
		
		' Copy Array
		If tempArticlesMax = 0 Then
			tempArticlesMax = 1
		End If
		ReDim ids(tempArticlesMax - 1)
		For i = 0 To tempArticlesMax - 1
			'UPGRADE_WARNING: Couldn't resolve default property of object ids(i). Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			ids(i) = tempArticles(i) '.ArticleID,GroupID,FileIndex
		Next 
	End Sub
	
	'' Add/update the article id associated with a fileid
	Public Sub UpdateFileIDs(ByRef pfileID As Integer, ByRef pArticleID As Integer, ByRef pGroupID As Integer, ByRef pFileIndex As Short)
		Static ExtendID As Integer
		Static FirstRec As Integer
		Static ArticleID As Integer
		Static i As Integer
		Static t As Integer
		
		Static FreeFileCache(cFileCacheSize, 2) As Integer
		Static FreeFileCachePos As Integer
		Static FoundCache As Boolean
		
		Static WriteBuffer As ArticleType
		
		If (pfileID - gFileIDBase) > 0 Then
			'If (pfileID - gFileIDBase) >= 1047556 Then
			'    Call CompactDB
			'End If
			FirstRec = 1 + (pfileID - gFileIDBase) * 10 * cFileGroupSize
			
			i = 0
			FoundCache = False
			For t = 0 To cFileCacheSize
				If FreeFileCache(t, 0) = pfileID Then
					i = FreeFileCache(t, 1)
					FoundCache = True
					Exit For
				End If
			Next 
			
			'Get #gFileHandle, FirstRec, m_CacheGroup
			
			' Locate next free block
			'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
			FileGet(gFileHandle, ArticleID, FirstRec + i * 10)
			'ArticleID = m_CacheGroup(0).ArticleID
			Do While ArticleID > 0 And ArticleID <> pArticleID And i < cFileGroupSize - 1
				i = i + 1
				'ArticleID = m_CacheGroup(i).ArticleID
				'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
				FileGet(gFileHandle, ArticleID, FirstRec + i * 10)
			Loop 
			If FoundCache = False Then
				If FreeFileCachePos = cFileCacheSize + 1 Then
					FreeFileCachePos = 0
				End If
				FreeFileCache(FreeFileCachePos, 0) = pfileID
				FreeFileCache(FreeFileCachePos, 1) = i
				FreeFileCachePos = FreeFileCachePos + 1
			Else
				FreeFileCache(t, 0) = pfileID
				FreeFileCache(t, 1) = i
			End If
			
			
			WriteBuffer.ArticleID = pArticleID
			WriteBuffer.GroupID = pGroupID
			WriteBuffer.FileIndex = pFileIndex
			If i < cFileGroupSize - 1 And ArticleID = 0 Then
				
				'UPGRADE_WARNING: Put was upgraded to FilePut and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
				FilePut(gFileHandle, WriteBuffer, FirstRec + i * 10) 'pArticleID,pGroupID,pFileIndex
			Else
				If i = cFileGroupSize - 1 Then
					' Add article id to extend file
					ExtendID = FreeFile
					FileOpen(ExtendID, gDatabasePath & "ext\" & pfileID & ".exd", OpenMode.Binary)
					i = 0
					'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
					FileGet(ExtendID, ArticleID, 1 + i * 10)
					Do While ArticleID <> 0 And ArticleID <> pArticleID And i < 500
						i = i + 1
						'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
						FileGet(ExtendID, ArticleID, 1 + i * 10)
					Loop 
					'UPGRADE_WARNING: Put was upgraded to FilePut and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
					FilePut(ExtendID, WriteBuffer, 1 + i * 10)
					FileClose(ExtendID)
				End If
			End If
			
		End If
	End Sub
	
	
	Private Function TruncateFile(ByVal FileName As String, ByVal FileSize As Integer) As Boolean
		Dim SA As SECURITY_ATTRIBUTES
		Dim FHandle, Ret As Integer
		
		FHandle = CreateFile(FileName, GENERIC_READ_WRITE, FILE_SHARE_READ_WRITE, SA, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
		
		If FHandle <> -1 Then
			Ret = SetFilePointer(FHandle, FileSize, 0, FILE_BEGIN)
			
			If Ret <> -1 Then
				TruncateFile = SetEndOfFile(FHandle) <> 0
			End If
			
			CloseHandle(FHandle)
		End If
	End Function
End Module