Option Strict Off
Option Explicit On
Module modTextDBEngine
	''*************************************************************************
	''
	'' Coded by Dale Pitman
    ''
    Public WorkerThread As New System.Threading.Thread(AddressOf FileSaveWorkerThread)
    Dim MyQueue As New Queue

    Dim BF As New System.Runtime.Serialization.Formatters.Binary.BinaryFormatter()
    Dim MS As New System.IO.MemoryStream()

    Dim fastIO As New NewsReaderSupport.WinFileIO


	Private Const FILE_BEGIN As Integer = 0
	Private Const FILE_END As Integer = 2
	Private Const GENERIC_READ_WRITE As Integer = &HC0000000
	Private Const FILE_SHARE_READ_WRITE As Integer = &H3
	Private Const OPEN_EXISTING As Integer = 3
	Private Const FILE_ATTRIBUTE_NORMAL As Integer = &H80

    'BF.Serialize(MS, Program)
    'My.Computer.FileSystem.WriteAllBytes("c:\temp\programs.bin", MS.GetBuffer(), False)

    ' Dim bytes As Byte() = My.Computer.FileSystem.ReadAllBytes("c:\temp\programmi.bin")
    'Program = DirectCast(BF.Deserialize(New System.IO.MemoryStream(bytes)), Software)
	Private Structure SECURITY_ATTRIBUTES
		Dim nLength As Integer
		Dim lpSecurityDescriptor As Integer
		Dim bInheritHandle As Integer
    End Structure

    Public Class threadParamaters
        Public pfileID As Integer
        Public pArticleID As Long
        Public pGroupID As Integer
        Public pFileIndex As Short


        Public Sub New(ByRef afileID As Integer, ByRef aArticleID As Long, ByRef aGroupID As Integer, ByRef aFileIndex As Short)
            pfileID = afileID
            pArticleID = aArticleID
            pGroupID = aGroupID
            pFileIndex = aFileIndex
        End Sub
    End Class

    Public Sub FileSaveWorkerThread(ByVal parameters As threadParamaters)
        gFileHandle = FreeFile()
        FileOpen(gFileHandle, gTextDatabasePath & "FileID.txt", OpenMode.Binary, OpenAccess.ReadWrite, OpenShare.Shared)

        UpdateFileIDs(parameters.pfileID, parameters.pArticleID, parameters.pGroupID, parameters.pFileIndex)

        FileClose(gFileHandle)
    End Sub


    Private Sub filePut2(ByVal FileHandle As Integer, ByVal WriteBuffer As ArticleType, ByVal pos As Long)
        FilePut(gFileHandle, WriteBuffer, pos) 'pArticleID,pGroupID,pFileIndex
    End Sub


    Private Sub FileGet2(ByRef ArticleID As Long, ByVal position As Long)
        Seek(gFileHandle, position)
        If (EOF(gFileHandle) = False) Then
            FileGet(gFileHandle, ArticleID, position)
        Else
            ArticleID = 0
        End If
    End Sub


    '        Dim ArticleID As Long
    'Dim GroupID As Integer
    'Dim FileIndex As Short ' 14 bytes

    Private Sub FileGet2(ByRef Article As ArticleType, ByVal position As Long)
        Seek(gFileHandle, position)
        If (EOF(gFileHandle) = False) Then
            FileGet(gFileHandle, Article, position)
        End If
    End Sub

    Private Sub FileGet2(ByVal FileHandle As Integer, ByRef Article As ArticleType, ByVal position As Long)
        Article.ArticleID = 0
        Article.FileIndex = 0
        Article.GroupID = 0

        Seek(FileHandle, position)
        If (EOF(FileHandle) = False) Then
            On Error GoTo fail
            FileGet(FileHandle, Article, position)
fail:
        End If
    End Sub
    Private Sub FileGet2(ByVal FileHandle As Integer, ByRef ArticleID As Long, ByVal position As Long)
        ArticleID = 0


        Seek(FileHandle, position)
        If (EOF(FileHandle) = False) Then
            FileGet(gFileHandle, ArticleID, position)
        End If
    End Sub

	
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
    Private gTextDatabasePath As String = "G:\Database\"
	
    <Serializable()>
 Public Structure ArticleType
        Dim ArticleID As Long
        Dim GroupID As Integer
        Dim FileIndex As Short ' 14 bytes
    End Structure

    Public Const cFileGroupSize As Integer = 100
    Private Const cFileCacheSize As Integer = 100

    Private m_CacheGroup(205) As ArticleType

    '' Get the storage location of the text database and open it
    Public Sub InitFileStorage()
        On Error GoTo ignore
        gFileIDBase = Val(GetServerSetting("FileIDBase", False))

        gDatabasePath = FRMOptions.Database

        gFileHandle = FreeFile()
        FileOpen(gFileHandle, gTextDatabasePath & "FileID.txt", OpenMode.Binary, OpenAccess.ReadWrite, OpenShare.Shared)

        'Dim gfile As System.IO.FileStream

        'gfile = System.IO.File.Open("", System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.ReadWrite, OpenShare.Shared)

        'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        'If Dir(gDatabasePath & "ext\", FileAttribute.Directory) = "" Then
        ' MkDir((gDatabasePath & "ext\"))
        'End If
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
        FirstRec = 1 + (NewBase - gFileIDBase) * 14 * cFileGroupSize
        Call OpenRecordset(rstemp, "SELECT TOP 1 UID FROM [File] ORDER BY UID DESC", dbOpenSnapshot)
        NewBase = rstemp.Fields("UID").Value - 2
        If 1 + (NewBase - gFileIDBase) * 14.0# * cFileGroupSize > 2 ^ 31 Then
            LastRec = 2 ^ 31 - 1
        Else
            LastRec = 1 + (NewBase - gFileIDBase) * 14.0# * cFileGroupSize
        End If

        NewStart = 1
        Do While FirstRec < LastRec
            'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
            FileGet(gFileHandle, CopyBuffer, FirstRec)
            FilePut(gFileHandle, CopyBuffer, NewStart)
            FirstRec = FirstRec + 1024
            NewStart = NewStart + 1024
        Loop


        Call SetServerSetting("FileIDBase", CStr(FirstBase))
        gFileIDBase = FirstBase

        ' Clear all old data
        FileClose(gFileHandle)
        Call TruncateFile(gTextDatabasePath & "FileID.txt", NewStart)
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

        FirstRec = 1 + (pfileID - gFileIDBase) * 14 * cFileGroupSize

        'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        FileGet2(tempArticles(tempArticlesMax), FirstRec + i * 14) '.ArticleID,GroupID,FileIndex

        '    tempArticlesMax = tempArticlesMax + 1
        Do While tempArticles(tempArticlesMax).ArticleID <> 0 And i < cFileGroupSize - 1
            tempArticlesMax = tempArticlesMax + 1
            i = i + 1
            'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
            FileGet2(tempArticles(tempArticlesMax), FirstRec + i * 14) '.ArticleID,GroupID,FileIndex

        Loop

        If i = cFileGroupSize - 1 Then
            ' Read ext
            ExtentID = FreeFile()
            'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
            If Dir(gTextDatabasePath & "ext\" & pfileID & ".exd", FileAttribute.Normal) <> "" Then
                FileOpen(ExtentID, gTextDatabasePath & "ext\" & pfileID & ".exd", OpenMode.Binary)
                i = 0
                'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
                FileGet2(ExtentID, tempArticles(tempArticlesMax), 1 + i * 14) '.ArticleID,GroupID,FileIndex

                Do While tempArticles(tempArticlesMax).ArticleID <> 0
                    tempArticlesMax = tempArticlesMax + 1
                    i = i + 1
                    'UPGRADE_WARNING: Get was upgraded to FileGet and has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
                    FileGet2(ExtentID, tempArticles(tempArticlesMax), 1 + i * 14) '.ArticleID,GroupID,FileIndex
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
            ids(i) = tempArticles(i) '.ArticleID,GroupID,FileIndex
        Next
    End Sub

    '' Add/update the article id associated with a fileid
    Public Sub UpdateFileIDs(ByRef pfileID As Integer, ByRef pArticleID As Long, ByRef pGroupID As Integer, ByRef pFileIndex As Short)
        Static ExtendID As Integer
        Static FirstRec As Integer
        Static ArticleID As Long
        Static i As Integer
        Static t As Integer

        Static FreeFileCache(cFileCacheSize, 3) As Integer
        Static FreeFileCachePos As Integer
        Static FoundCache As Boolean

        Static WriteBuffer As ArticleType
        Static ReadBuffer As ArticleType

        If (pfileID - gFileIDBase) > 0 Then
            FirstRec = 1 + (pfileID - gFileIDBase) * 14 * cFileGroupSize

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
            FileGet2(ArticleID, FirstRec + i * 14)
            'ArticleID = m_CacheGroup(0).ArticleID
            Do While ArticleID > 0 And ArticleID <> pArticleID And i < cFileGroupSize - 1
                i = i + 1
                'ArticleID = m_CacheGroup(i).ArticleID
                FileGet2(ArticleID, FirstRec + i * 14)
            Loop
            If FoundCache = False Then
                If FreeFileCachePos = cFileCacheSize + 1 Then
                    FreeFileCachePos = 0
                End If
                FreeFileCache(FreeFileCachePos, 0) = pfileID
                FreeFileCache(FreeFileCachePos, 1) = i
                FreeFileCache(FreeFileCachePos, 2) = 0
                t = FreeFileCachePos
                FreeFileCachePos = FreeFileCachePos + 1
            Else
                FreeFileCache(t, 0) = pfileID
                FreeFileCache(t, 1) = i
                FreeFileCache(t, 2) = 0
            End If


            WriteBuffer.ArticleID = pArticleID
            WriteBuffer.GroupID = pGroupID
            WriteBuffer.FileIndex = pFileIndex
            If i < cFileGroupSize - 1 And ArticleID = 0 Then

                filePut2(gFileHandle, WriteBuffer, FirstRec + i * 14) 'pArticleID,pGroupID,pFileIndex
            Else
                If i = cFileGroupSize - 1 Then
                    ' Add article id to extend file
                    ExtendID = FreeFile()
                    FileOpen(ExtendID, gTextDatabasePath & "ext\" & pfileID & ".exd", OpenMode.Binary)
                    i = 0
                    If (FoundCache = True) Then
                        i = FreeFileCache(t, 2)
                    End If

                    FileGet2(ExtendID, ReadBuffer, 1 + i * 14)
                    Do While ReadBuffer.ArticleID <> 0 And ReadBuffer.ArticleID <> pArticleID And i < 500
                        i = i + 1
                        FileGet2(ExtendID, ReadBuffer, 1 + i * 14)
                    Loop
                    FreeFileCache(t, 2) = i

                    FilePut(ExtendID, WriteBuffer, 1 + i * 14)
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