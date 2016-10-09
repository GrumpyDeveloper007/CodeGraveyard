Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class frmReaderHolder
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' ReaderHolder - holds all winsock \ newsreader controls and provides 'all thread' commands
	''
	'' Coded by Dale Pitman - PyroDesign
	
	Public WithEvents m_cNewsReader As cNewsReader
	Private WithEvents m_cNewsReaderB As cNewsReader
	Public WithEvents m_cNewsReaderC As cNewsReader
	Public WithEvents m_cNewsReaderD As cNewsReader
	Public WithEvents m_cNewsReaderE As cNewsReader
	Public WithEvents m_cNewsReaderF As cNewsReader
	Public WithEvents m_cNewsReaderG As cNewsReader
	Public WithEvents m_cNewsReaderH As cNewsReader
	Public A_StillRunning As Boolean
	
	Private m_PacketNumberMax As Integer
	
	Private m_lngNumberOfThread As Integer
	
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''
	''
	
	Public WriteOnly Property DownloadingMp3() As Boolean
		Set(ByVal Value As Boolean)
			m_cNewsReader.m_blnDownloadingMp3 = Value
			m_cNewsReaderB.m_blnDownloadingMp3 = Value
			m_cNewsReaderC.m_blnDownloadingMp3 = Value
			m_cNewsReaderD.m_blnDownloadingMp3 = Value
			m_cNewsReaderE.m_blnDownloadingMp3 = Value
			m_cNewsReaderF.m_blnDownloadingMp3 = Value
			m_cNewsReaderG.m_blnDownloadingMp3 = Value
			m_cNewsReaderH.m_blnDownloadingMp3 = Value
		End Set
	End Property
	
	Public WriteOnly Property GetMissingArticles() As Boolean
		Set(ByVal Value As Boolean)
			m_cNewsReader.GetMissingArticles = Value
			m_cNewsReaderB.GetMissingArticles = Value
			m_cNewsReaderC.GetMissingArticles = Value
			m_cNewsReaderD.GetMissingArticles = Value
			m_cNewsReaderE.GetMissingArticles = Value
			m_cNewsReaderF.GetMissingArticles = Value
			m_cNewsReaderG.GetMissingArticles = Value
			m_cNewsReaderH.GetMissingArticles = Value
		End Set
	End Property
	
	Public ReadOnly Property NumberOfThreads() As Integer
		Get
			NumberOfThreads = m_lngNumberOfThread
		End Get
	End Property
	
	Public Sub Disconnect()
		m_cNewsReader.Disconnect()
		m_cNewsReaderB.Disconnect()
		m_cNewsReaderC.Disconnect()
		m_cNewsReaderD.Disconnect()
		m_cNewsReaderE.Disconnect()
		m_cNewsReaderF.Disconnect()
		m_cNewsReaderG.Disconnect()
		m_cNewsReaderH.Disconnect()
		Call ResetLastDownloadedID()
	End Sub
	
	Public Sub CheckFileNameOverride(ByRef pclsNewsreader As cNewsReader)
		If m_cNewsReader.m_LastFileID = pclsNewsreader.m_LastFileID And m_cNewsReader.index <> pclsNewsreader.index Then
			pclsNewsreader.m_LastFileName = m_cNewsReader.m_LastFileName
		End If
		If m_cNewsReaderB.m_LastFileID = pclsNewsreader.m_LastFileID And m_cNewsReaderB.index <> pclsNewsreader.index Then
			pclsNewsreader.m_LastFileName = m_cNewsReaderB.m_LastFileName
		End If
		If m_cNewsReaderC.m_LastFileID = pclsNewsreader.m_LastFileID And m_cNewsReaderC.index <> pclsNewsreader.index Then
			pclsNewsreader.m_LastFileName = m_cNewsReaderC.m_LastFileName
		End If
		If m_cNewsReaderD.m_LastFileID = pclsNewsreader.m_LastFileID And m_cNewsReaderD.index <> pclsNewsreader.index Then
			pclsNewsreader.m_LastFileName = m_cNewsReaderD.m_LastFileName
		End If
		If m_cNewsReaderE.m_LastFileID = pclsNewsreader.m_LastFileID And m_cNewsReaderE.index <> pclsNewsreader.index Then
			pclsNewsreader.m_LastFileName = m_cNewsReaderE.m_LastFileName
		End If
		If m_cNewsReaderF.m_LastFileID = pclsNewsreader.m_LastFileID And m_cNewsReaderF.index <> pclsNewsreader.index Then
			pclsNewsreader.m_LastFileName = m_cNewsReaderF.m_LastFileName
		End If
		If m_cNewsReaderG.m_LastFileID = pclsNewsreader.m_LastFileID And m_cNewsReaderG.index <> pclsNewsreader.index Then
			pclsNewsreader.m_LastFileName = m_cNewsReaderG.m_LastFileName
		End If
		If m_cNewsReaderH.m_LastFileID = pclsNewsreader.m_LastFileID And m_cNewsReaderH.index <> pclsNewsreader.index Then
			pclsNewsreader.m_LastFileName = m_cNewsReaderH.m_LastFileName
		End If
	End Sub
	
	Public Sub RefreshThreads(ByRef pNumberOfThreads As Integer)
		m_lngNumberOfThread = pNumberOfThreads
		If m_lngNumberOfThread < 2 Then
			m_cNewsReaderB.m_AutoAction = cNewsReader.AutoActionENUM.None
		End If
		If m_lngNumberOfThread < 3 Then
			m_cNewsReaderC.m_AutoAction = cNewsReader.AutoActionENUM.None
		End If
		
		If m_lngNumberOfThread > 1 And m_cNewsReaderB.m_AutoAction = cNewsReader.AutoActionENUM.None And m_cNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.DownloadFiles Then
			m_cNewsReaderB.dDownloadFiles()
		End If
		
		If m_lngNumberOfThread > 2 And m_cNewsReaderC.m_AutoAction = cNewsReader.AutoActionENUM.None And m_cNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.DownloadFiles Then
			m_cNewsReaderC.dDownloadFiles()
		End If
		
		If m_lngNumberOfThread > 3 And m_cNewsReaderD.m_AutoAction = cNewsReader.AutoActionENUM.None And m_cNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.DownloadFiles Then
			m_cNewsReaderD.dDownloadFiles()
		End If
		
		If m_lngNumberOfThread > 4 And m_cNewsReaderE.m_AutoAction = cNewsReader.AutoActionENUM.None And m_cNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.DownloadFiles Then
			m_cNewsReaderE.dDownloadFiles()
		End If
		
		If m_lngNumberOfThread > 5 And m_cNewsReaderF.m_AutoAction = cNewsReader.AutoActionENUM.None And m_cNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.DownloadFiles Then
			m_cNewsReaderF.dDownloadFiles()
		End If
		
		If m_lngNumberOfThread > 6 And m_cNewsReaderG.m_AutoAction = cNewsReader.AutoActionENUM.None And m_cNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.DownloadFiles Then
			m_cNewsReaderG.dDownloadFiles()
		End If
		
		If m_lngNumberOfThread > 7 And m_cNewsReaderH.m_AutoAction = cNewsReader.AutoActionENUM.None And m_cNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.DownloadFiles Then
			m_cNewsReaderH.dDownloadFiles()
		End If
		
		
	End Sub
	
	Public Sub ResetLastDownloadedID()
		If (m_cNewsReader.m_LastFileID > 0) Then
			Call Execute("UPDATE  File SET downloading=false WHERE UID=" & m_cNewsReader.m_LastFileID, True)
		End If
		If (m_cNewsReaderB.m_LastFileID > 0) Then
			Call Execute("UPDATE  File SET downloading=false WHERE UID=" & m_cNewsReaderB.m_LastFileID, True)
		End If
		If (m_cNewsReaderC.m_LastFileID > 0) Then
			Call Execute("UPDATE  File SET downloading=false WHERE UID=" & m_cNewsReaderC.m_LastFileID, True)
		End If
		If (m_cNewsReaderD.m_LastFileID > 0) Then
			Call Execute("UPDATE  File SET downloading=false WHERE UID=" & m_cNewsReaderD.m_LastFileID, True)
		End If
		If (m_cNewsReaderE.m_LastFileID > 0) Then
			Call Execute("UPDATE  File SET downloading=false WHERE UID=" & m_cNewsReaderE.m_LastFileID, True)
		End If
		If (m_cNewsReaderF.m_LastFileID > 0) Then
			Call Execute("UPDATE  File SET downloading=false WHERE UID=" & m_cNewsReaderF.m_LastFileID, True)
		End If
		If (m_cNewsReaderG.m_LastFileID > 0) Then
			Call Execute("UPDATE  File SET downloading=false WHERE UID=" & m_cNewsReaderG.m_LastFileID, True)
		End If
		If (m_cNewsReaderH.m_LastFileID > 0) Then
			Call Execute("UPDATE  File SET downloading=false WHERE UID=" & m_cNewsReaderH.m_LastFileID, True)
		End If
	End Sub
	
	Public Function CheckCurrentlyDownloadingIndex(ByRef pfileID As Integer, ByRef pFileIndex As Short, ByRef pReaderIndex As Integer) As Boolean
		CheckCurrentlyDownloadingIndex = False
		If (m_cNewsReader.m_LastFileID = pfileID And m_cNewsReader.FileIndex = pFileIndex) Then
			CheckCurrentlyDownloadingIndex = True
			pReaderIndex = m_cNewsReader.index
		End If
		If (m_cNewsReaderB.m_LastFileID = pfileID And m_cNewsReaderB.FileIndex = pFileIndex) Then
			CheckCurrentlyDownloadingIndex = True
			pReaderIndex = m_cNewsReaderB.index
		End If
		If (m_cNewsReaderC.m_LastFileID = pfileID And m_cNewsReaderC.FileIndex = pFileIndex) Then
			CheckCurrentlyDownloadingIndex = True
			pReaderIndex = m_cNewsReaderC.index
		End If
		If (m_cNewsReaderD.m_LastFileID = pfileID And m_cNewsReaderD.FileIndex = pFileIndex) Then
			CheckCurrentlyDownloadingIndex = True
			pReaderIndex = m_cNewsReaderD.index
		End If
		If (m_cNewsReaderE.m_LastFileID = pfileID And m_cNewsReaderE.FileIndex = pFileIndex) Then
			CheckCurrentlyDownloadingIndex = True
			pReaderIndex = m_cNewsReaderE.index
		End If
		If (m_cNewsReaderF.m_LastFileID = pfileID And m_cNewsReaderF.FileIndex = pFileIndex) Then
			CheckCurrentlyDownloadingIndex = True
			pReaderIndex = m_cNewsReaderF.index
		End If
		If (m_cNewsReaderG.m_LastFileID = pfileID And m_cNewsReaderG.FileIndex = pFileIndex) Then
			CheckCurrentlyDownloadingIndex = True
			pReaderIndex = m_cNewsReaderG.index
		End If
		If (m_cNewsReaderH.m_LastFileID = pfileID And m_cNewsReaderH.FileIndex = pFileIndex) Then
			CheckCurrentlyDownloadingIndex = True
			pReaderIndex = m_cNewsReaderH.index
		End If
	End Function
	
	Public Sub DownloadFiles()
		m_cNewsReader.dDownloadFiles()
		If m_lngNumberOfThread > 1 Then
			m_cNewsReaderB.dDownloadFiles()
		End If
		If m_lngNumberOfThread > 2 Then
			m_cNewsReaderC.dDownloadFiles()
		End If
		If m_lngNumberOfThread > 3 Then
			m_cNewsReaderD.dDownloadFiles()
		End If
		If m_lngNumberOfThread > 4 Then
			m_cNewsReaderE.dDownloadFiles()
		End If
		If m_lngNumberOfThread > 5 Then
			m_cNewsReaderF.dDownloadFiles()
		End If
		If m_lngNumberOfThread > 6 Then
			m_cNewsReaderG.dDownloadFiles()
		End If
		If m_lngNumberOfThread > 7 Then
			m_cNewsReaderH.dDownloadFiles()
		End If
		
	End Sub
	
	
	Public Sub Init()
		m_cNewsReader = New cNewsReader
		'UPGRADE_WARNING: Untranslated statement in Init. Please check source code.
		m_cNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.None
		m_cNewsReader.index = 0
		
		m_cNewsReaderB = New cNewsReader
		'UPGRADE_WARNING: Untranslated statement in Init. Please check source code.
		m_cNewsReaderB.m_AutoAction = cNewsReader.AutoActionENUM.None
		m_cNewsReaderB.index = 1
		
		m_cNewsReaderC = New cNewsReader
		'UPGRADE_WARNING: Untranslated statement in Init. Please check source code.
		m_cNewsReaderC.m_AutoAction = cNewsReader.AutoActionENUM.None
		m_cNewsReaderC.index = 2
		
		m_cNewsReaderD = New cNewsReader
		'UPGRADE_WARNING: Untranslated statement in Init. Please check source code.
		m_cNewsReaderD.m_AutoAction = cNewsReader.AutoActionENUM.None
		m_cNewsReaderD.index = 3
		
		m_cNewsReaderE = New cNewsReader
		'UPGRADE_WARNING: Untranslated statement in Init. Please check source code.
		m_cNewsReaderE.m_AutoAction = cNewsReader.AutoActionENUM.None
		m_cNewsReaderE.index = 4
		
		m_cNewsReaderF = New cNewsReader
		'UPGRADE_WARNING: Untranslated statement in Init. Please check source code.
		m_cNewsReaderF.m_AutoAction = cNewsReader.AutoActionENUM.None
		m_cNewsReaderF.index = 5
		
		m_cNewsReaderG = New cNewsReader
		'UPGRADE_WARNING: Untranslated statement in Init. Please check source code.
		m_cNewsReaderG.m_AutoAction = cNewsReader.AutoActionENUM.None
		m_cNewsReaderG.index = 6
		
		m_cNewsReaderH = New cNewsReader
		'UPGRADE_WARNING: Untranslated statement in Init. Please check source code.
		m_cNewsReaderH.m_AutoAction = cNewsReader.AutoActionENUM.None
		m_cNewsReaderH.index = 7
		
	End Sub
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''
	
	Private Sub GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer)
		Dim rstemp As ADODB.Recordset
		If (OpenRecordset(rstemp, "SELECT * FROM [file] WHERE uid=" & pLastFileID, dbOpenSnapshot)) Then
			If (rstemp.EOF = False) Then
				If (rstemp.Fields("FileName").Value <> "") Then
					pfilename = rstemp.Fields("FileName").Value
					If (pLastArticleIndex <> 1) Then
						pOutputSegSize = Val(rstemp.Fields("OutputSegmentSize").Value & "")
					End If
				Else
				End If
			End If
		End If
	End Sub
	
	
	Private Sub ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer)
		Execute("INSERT INTO MissingArticle (GroupID,ArticleNumber) VALUES (" & pGroupID & "," & pArticleNumber & ")")
	End Sub
	
	Private Sub ProcessAllArticleList(ByRef pNewsReader As cNewsReader)
		' check to see if there is more work to do
		If (FRMMain.CBONewsGroup.SelectedIndex < FRMMain.CBONewsGroup.Items.Count - 1) Then
			FRMMain.CBONewsGroup.SelectedIndex = FRMMain.CBONewsGroup.SelectedIndex + 1
			pNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.GetNewArticles
			pNewsReader.m_GroupName = FRMMain.CBONewsGroup.Text
			Call pNewsReader.SelectGroup()
		Else
			pNewsReader.m_AutoAction = cNewsReader.AutoActionENUM.None
			MDIMain.LBLProgress(0).Text = "Done"
			A_StillRunning = False
			'If B_StillRunning = False And C_StillRunning = False Then
			'            Call m_rsArticle.UpdateBatch
			'            m_rsArticle.Close
			' Link articles to files
			Call FRMMain.ScanForFiles()
			
			Call ProcessAutoHide((FRMMain.m_GroupTypeID))
			' Look for IMDB tags
			'Call frmIMDBHolder.CMDGetIMDBTags_Click
			MDIMain.LBLAction.Text = "All Done :), switching to download"
			Call FRMMain.CMDDownloadFiles_Click(Nothing, New System.EventArgs())
			'End If
			' Reset back to normal download
			pNewsReader.GetMissingArticles = False
			
			pNewsReader.FileIndex = -1
			'pNewsReader.dDownloadFiles
		End If
	End Sub
	
	Private Sub UpdateLastFileName(ByRef pNewsReader As cNewsReader, ByRef pfilename As String, ByRef pLastFileID As Integer)
		'UPGRADE_NOTE: FileSystem was upgraded to FileSystem_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim FileSystem_Renamed As New Scripting.FileSystemObject
		If m_cNewsReader.m_LastFileName <> pfilename Then
			
			On Error GoTo fileerror
			Call FileSystem_Renamed.MoveFile(FRMOptions.TempDownloadPath & pNewsReader.m_LastFileName, FRMOptions.TempDownloadPath & pfilename)
			Call FileSystem_Renamed.MoveFile(FRMOptions.TempDownloadPath & pNewsReader.m_LastFileName & ".txt", FRMOptions.TempDownloadPath & pfilename & ".txt")
fileerror: 
			Call Execute("UPDATE [file] SET filename=" & Chr(34) & pfilename & Chr(34) & " WHERE uid=" & pLastFileID, True)
			If m_cNewsReader.m_LastFileID = pLastFileID Then
				m_cNewsReader.m_LastFileName = pfilename
			End If
			If m_cNewsReaderB.m_LastFileID = pLastFileID Then
				m_cNewsReaderB.m_LastFileName = pfilename
			End If
			If m_cNewsReaderC.m_LastFileID = pLastFileID Then
				m_cNewsReaderC.m_LastFileName = pfilename
			End If
			If m_cNewsReaderD.m_LastFileID = pLastFileID Then
				m_cNewsReaderD.m_LastFileName = pfilename
			End If
			If m_cNewsReaderE.m_LastFileID = pLastFileID Then
				m_cNewsReaderE.m_LastFileName = pfilename
			End If
			If m_cNewsReaderF.m_LastFileID = pLastFileID Then
				m_cNewsReaderF.m_LastFileName = pfilename
			End If
			If m_cNewsReaderG.m_LastFileID = pLastFileID Then
				m_cNewsReaderG.m_LastFileName = pfilename
			End If
			If m_cNewsReaderH.m_LastFileID = pLastFileID Then
				m_cNewsReaderH.m_LastFileName = pfilename
			End If
		End If
	End Sub
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' A
	
	Private Sub m_cNewsReader_AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Double, ByRef pHighArticle As Double, ByRef pPostability As String) Handles m_cNewsReader.AddUpdateGroup
		' Store groups for update later
		m_Groups(m_MaxGroup).Name = pName
		'm_Groups(m_MaxGroup).LowArticle = pLowArticle
		'    m_Groups(m_MaxGroup).HighArticle = pHighArticle
		m_Groups(m_MaxGroup).Postability = pPostability
		m_MaxGroup = m_MaxGroup + 1
	End Sub
	
	Private Sub m_cNewsReader_CancelDownloadArticleExpired() Handles m_cNewsReader.CancelDownloadArticleExpired
		Call FRMMain.LogEvent("Article expired", 0)
		Call FRMMain.DownloadFile(m_cNewsReader)
	End Sub
	
	Private Sub m_cNewsReader_FileDownloadedSuccessfully(ByRef pLastFileID As Integer) Handles m_cNewsReader.FileDownloadedSuccessfully
		Call Execute("UPDATE [file] SET DownloadedSuccessfully=true WHERE uid=" & pLastFileID, True)
		FRMMain.m_lngLastCompleteFile = pLastFileID
	End Sub
	
	Private Sub m_cNewsReader_GetLastArticleForGroup(ByRef pLastArticleID As Integer, ByRef pGroupID As Integer, ByRef pServerID As Integer) Handles m_cNewsReader.GetLastArticleForGroup
		Static rstemp As ADODB.Recordset
		
		If pServerID = 0 Then
			pLastArticleID = Val(GetServerSetting("GroupMax-" & pGroupID, False))
			
		Else
			If (OpenRecordset(rstemp, "SELECT Max(ArticleNumber) AS maxx FROM [Article2] WHERE GroupID=" & pGroupID, dbOpenSnapshot)) Then
				If (Val(rstemp.Fields("maxx").Value & "") <> 0) Then
					pLastArticleID = Val(rstemp.Fields("maxx").Value & "")
				End If
			End If
		End If
	End Sub
	
	Private Sub m_cNewsReader_GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer) Handles m_cNewsReader.GetOutputSegmentSize
		Call GetOutputSegmentSize(pOutputSegSize, pfilename, pLastFileID, pLastArticleIndex)
	End Sub
	
	Private Sub m_cNewsReader_LogEvent(ByRef pName As String) Handles m_cNewsReader.LogEvent
		Call FRMMain.LogEvent(pName, 0)
	End Sub
	
	Private Sub m_cNewsReader_MoveFile(ByRef pfilename As String, ByRef psubject As String) Handles m_cNewsReader.MoveFile
		Call FRMMain.LogEvent("File Complete -" & pfilename, 0)
		
		Call FRMMain.MoveFile(pfilename, psubject)
	End Sub
	
	Private Sub m_cNewsReader_PacketRecieved(ByRef pNumber As Integer) Handles m_cNewsReader.PacketRecieved
		If (pNumber > m_PacketNumberMax) Then
			m_PacketNumberMax = pNumber
		End If
		MDIMain.LBLPacketNumber(0).Text = "Packet =" & pNumber & "(" & m_PacketNumberMax & ")"
	End Sub
	
	Private Sub m_cNewsReader_ProcessAllArticleList() Handles m_cNewsReader.ProcessAllArticleList
		Call ProcessAllArticleList(m_cNewsReader)
	End Sub
	
	Private Sub m_cNewsReader_ProcessAllGroupsList() Handles m_cNewsReader.ProcessAllGroupsList
		Static i As Integer
		Static rstemp As ADODB.Recordset
		Static server As Integer
		Static NewGroups As Integer
		Static maxlen As Integer
		
		server = 0
		
		' Update record
		For i = 0 To m_MaxGroup - 1
			If (OpenRecordset(rstemp, "SELECT * FROM [Group] WHERE groupname='" & Replace(VB.Left(m_Groups(i).Name, 128), "'", "''") & "' AND server=" & server, dbOpenDynaset)) Then
				If (rstemp.EOF = True) Then
					rstemp.AddNew()
					NewGroups = NewGroups + 1
				End If
				
				If (Len(m_Groups(i).Name) > maxlen) Then
					maxlen = Len(m_Groups(i).Name)
				End If
				rstemp.Fields("GroupName").Value = VB.Left(m_Groups(i).Name, 128)
				rstemp.Fields("LowArticle").Value = m_Groups(i).LowArticle
				rstemp.Fields("HighArticle").Value = m_Groups(i).HighArticle
				rstemp.Fields("Postability").Value = m_Groups(i).Postability
				rstemp.Fields("server").Value = server
				rstemp.Update()
				
			End If
			
			If (i Mod 20 = 0) Then
				MDIMain.LBLProgress(0).Text = i & "-" & m_MaxGroup & "(" & NewGroups & ")"
				System.Windows.Forms.Application.DoEvents()
			End If
		Next 
		m_MaxGroup = 0
		MDIMain.LBLProgress(0).Text = "Done"
	End Sub
	
	Private Sub m_cNewsReader_ProcessArticle(ByRef pArticleNumber As Integer, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer) Handles m_cNewsReader.ProcessArticle
		Call FRMMain.ProcessArticle(pArticleNumber, psubject, pLineCount, pPostDate, pGroupID, pLinesExpected, 0)
	End Sub
	
	Private Sub m_cNewsReader_ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer) Handles m_cNewsReader.ProcessMissingArticle
		Call ProcessMissingArticle(pArticleNumber, pGroupID)
	End Sub
	
	Private Sub m_cNewsReader_TriggerDownloadFile(ByRef pNextRecord As Boolean) Handles m_cNewsReader.TriggerDownloadFile
		Call FRMMain.DownloadFile(m_cNewsReader)
	End Sub
	
	Private Sub m_cNewsReader_UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer) Handles m_cNewsReader.UpdateLastFileName
		Call UpdateLastFileName(m_cNewsReader, pfilename, pLastFileID)
	End Sub
	
	Private Sub m_cNewsReader_UpdateRx(ByRef pData As String) Handles m_cNewsReader.UpdateRx
		FRMMain.TXTrx(0).Text = FRMMain.TXTrx(0).Text & pData
		FRMMain.TXTrx(0).SelectionStart = Len(FRMMain.TXTrx(0).Text)
	End Sub
	
	'''''''''''''''''''''''''''''
	'' B
	
	Private Sub m_cNewsReaderb_AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Double, ByRef pHighArticle As Double, ByRef pPostability As String) Handles m_cNewsReaderb.AddUpdateGroup
		' Store groups for update later
		m_Groups(m_MaxGroup).Name = pName
		m_Groups(m_MaxGroup).LowArticle = pLowArticle
		m_Groups(m_MaxGroup).HighArticle = pHighArticle
		m_Groups(m_MaxGroup).Postability = pPostability
		m_MaxGroup = m_MaxGroup + 1
	End Sub
	
	Private Sub m_cNewsReaderb_CancelDownloadArticleExpired() Handles m_cNewsReaderb.CancelDownloadArticleExpired
		Call FRMMain.LogEvent("Article expired", 1)
		Call FRMMain.DownloadFile(m_cNewsReaderB)
	End Sub
	
	Private Sub m_cNewsReaderb_FileDownloadedSuccessfully(ByRef pLastFileID As Integer) Handles m_cNewsReaderb.FileDownloadedSuccessfully
		Call Execute("UPDATE [file] SET DownloadedSuccessfully=true WHERE uid=" & pLastFileID, True)
		FRMMain.m_lngLastCompleteFile = pLastFileID
	End Sub
	
	Private Sub m_cNewsReaderb_GetLastArticleForGroup(ByRef pLastArticleID As Integer, ByRef pGroupID As Integer, ByRef pServerID As Integer) Handles m_cNewsReaderb.GetLastArticleForGroup
		Dim rstemp As ADODB.Recordset
		If pServerID = 0 Then
			pLastArticleID = Val(GetServerSetting("GroupMax-" & pGroupID, False))
		Else
			If (OpenRecordset(rstemp, "SELECT Max(ArticleNumber) AS maxx FROM [Article2] WHERE GroupID=" & pGroupID, dbOpenSnapshot)) Then
				If (Val(rstemp.Fields("maxx").Value & "") <> 0) Then
					pLastArticleID = Val(rstemp.Fields("maxx").Value & "")
				End If
			End If
		End If
	End Sub
	
	Private Sub m_cNewsReaderb_GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer) Handles m_cNewsReaderb.GetOutputSegmentSize
		Call GetOutputSegmentSize(pOutputSegSize, pfilename, pLastFileID, pLastArticleIndex)
	End Sub
	
	Private Sub m_cNewsReaderb_LogEvent(ByRef pName As String) Handles m_cNewsReaderb.LogEvent
		Call FRMMain.LogEvent(pName, 1)
	End Sub
	
	Private Sub m_cNewsReaderb_MoveFile(ByRef pfilename As String, ByRef psubject As String) Handles m_cNewsReaderb.MoveFile
		Call FRMMain.LogEvent("File Complete -" & pfilename, 1)
		
		Call FRMMain.MoveFile(pfilename, psubject)
	End Sub
	
	Private Sub m_cNewsReaderb_PacketRecieved(ByRef pNumber As Integer) Handles m_cNewsReaderb.PacketRecieved
		If (pNumber > m_PacketNumberMax) Then
			m_PacketNumberMax = pNumber
		End If
		MDIMain.LBLPacketNumber(1).Text = "Packet =" & pNumber & "(" & m_PacketNumberMax & ")"
	End Sub
	
	Private Sub m_cNewsReaderb_ProcessAllArticleList() Handles m_cNewsReaderb.ProcessAllArticleList
		Call ProcessAllArticleList(m_cNewsReaderB)
	End Sub
	
	Private Sub m_cNewsReaderB_ProcessArticle(ByRef pArticleNumber As Integer, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer) Handles m_cNewsReaderB.ProcessArticle
		Call FRMMain.ProcessArticle(pArticleNumber, psubject, pLineCount, pPostDate, pGroupID, pLinesExpected, 1)
	End Sub
	
	Private Sub m_cNewsReaderB_ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer) Handles m_cNewsReaderB.ProcessMissingArticle
		Call ProcessMissingArticle(pArticleNumber, pGroupID)
	End Sub
	
	Private Sub m_cNewsReaderb_TriggerDownloadFile(ByRef pNextRecord As Boolean) Handles m_cNewsReaderb.TriggerDownloadFile
		Call FRMMain.DownloadFile(m_cNewsReaderB)
	End Sub
	
	Private Sub m_cNewsReaderb_UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer) Handles m_cNewsReaderb.UpdateLastFileName
		Call UpdateLastFileName(m_cNewsReaderB, pfilename, pLastFileID)
	End Sub
	
	Private Sub m_cNewsReaderb_UpdateRx(ByRef pData As String) Handles m_cNewsReaderb.UpdateRx
		Call FRMMain.UpdateRx((m_cNewsReaderB.index), pData)
	End Sub
	
	
	'''''''''''''''''''''''''''''
	'' C
	
	Private Sub m_cNewsReaderc_AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Double, ByRef pHighArticle As Double, ByRef pPostability As String) Handles m_cNewsReaderc.AddUpdateGroup
		' Store groups for update later
		m_Groups(m_MaxGroup).Name = pName
		m_Groups(m_MaxGroup).LowArticle = pLowArticle
		m_Groups(m_MaxGroup).HighArticle = pHighArticle
		m_Groups(m_MaxGroup).Postability = pPostability
		m_MaxGroup = m_MaxGroup + 1
	End Sub
	
	Private Sub m_cNewsReaderc_CancelDownloadArticleExpired() Handles m_cNewsReaderc.CancelDownloadArticleExpired
		Call FRMMain.LogEvent("Article expired", 2)
		Call FRMMain.DownloadFile(m_cNewsReaderC)
	End Sub
	
	Private Sub m_cNewsReaderc_FileDownloadedSuccessfully(ByRef pLastFileID As Integer) Handles m_cNewsReaderc.FileDownloadedSuccessfully
		Call Execute("UPDATE [file] SET DownloadedSuccessfully=true WHERE uid=" & pLastFileID, True)
		FRMMain.m_lngLastCompleteFile = pLastFileID
		'If m_blnGettingMissingArticles = True Then
		'    Set rsArticle = Nothing ' Force get next file, adjust later to use flag to move in downloadfile function
		'End If
	End Sub
	
	Private Sub m_cNewsReaderc_GetLastArticleForGroup(ByRef pLastArticleID As Integer, ByRef pGroupID As Integer, ByRef pServerID As Integer) Handles m_cNewsReaderc.GetLastArticleForGroup
		Dim rstemp As ADODB.Recordset
		If pServerID = 0 Then
			pLastArticleID = Val(GetServerSetting("GroupMax-" & pGroupID, False))
		Else
			If (OpenRecordset(rstemp, "SELECT Max(ArticleNumber) AS maxx FROM [Article2] WHERE GroupID=" & pGroupID, dbOpenSnapshot)) Then
				If (Val(rstemp.Fields("maxx").Value & "") <> 0) Then
					pLastArticleID = Val(rstemp.Fields("maxx").Value & "")
				End If
			End If
		End If
	End Sub
	
	Private Sub m_cNewsReaderc_GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer) Handles m_cNewsReaderc.GetOutputSegmentSize
		Call GetOutputSegmentSize(pOutputSegSize, pfilename, pLastFileID, pLastArticleIndex)
	End Sub
	
	Private Sub m_cNewsReaderc_LogEvent(ByRef pName As String) Handles m_cNewsReaderc.LogEvent
		Call FRMMain.LogEvent(pName, 2)
	End Sub
	
	Private Sub m_cNewsReaderc_MoveFile(ByRef pfilename As String, ByRef psubject As String) Handles m_cNewsReaderc.MoveFile
		Call FRMMain.LogEvent("File Complete -" & pfilename, 2)
		
		Call FRMMain.MoveFile(pfilename, psubject)
	End Sub
	
	Private Sub m_cNewsReaderc_PacketRecieved(ByRef pNumber As Integer) Handles m_cNewsReaderc.PacketRecieved
		If (pNumber > m_PacketNumberMax) Then
			m_PacketNumberMax = pNumber
		End If
		MDIMain.LBLPacketNumber(2).Text = "Packet =" & pNumber & "(" & m_PacketNumberMax & ")"
	End Sub
	
	Private Sub m_cNewsReaderc_ProcessAllArticleList() Handles m_cNewsReaderc.ProcessAllArticleList
		Call ProcessAllArticleList(m_cNewsReaderC)
	End Sub
	
	Private Sub m_cNewsReaderC_ProcessArticle(ByRef pArticleNumber As Integer, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer) Handles m_cNewsReaderC.ProcessArticle
		Call FRMMain.ProcessArticle(pArticleNumber, psubject, pLineCount, pPostDate, pGroupID, pLinesExpected, 2)
	End Sub
	
	Private Sub m_cNewsReaderC_ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer) Handles m_cNewsReaderC.ProcessMissingArticle
		Call ProcessMissingArticle(pArticleNumber, pGroupID)
	End Sub
	
	Private Sub m_cNewsReaderc_TriggerDownloadFile(ByRef pNextRecord As Boolean) Handles m_cNewsReaderc.TriggerDownloadFile
		Call FRMMain.DownloadFile(m_cNewsReaderC)
	End Sub
	
	Private Sub m_cNewsReaderc_UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer) Handles m_cNewsReaderc.UpdateLastFileName
		Call UpdateLastFileName(m_cNewsReaderC, pfilename, pLastFileID)
	End Sub
	
	Private Sub m_cNewsReaderC_UpdateRx(ByRef pData As String) Handles m_cNewsReaderC.UpdateRx
		Call FRMMain.UpdateRx((m_cNewsReaderC.index), pData)
	End Sub
	
	'''''''''''''''''''''''''''''
	'' D
	
	Private Sub m_cNewsReaderd_AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Double, ByRef pHighArticle As Double, ByRef pPostability As String) Handles m_cNewsReaderd.AddUpdateGroup
		' Store groups for update later
		m_Groups(m_MaxGroup).Name = pName
		m_Groups(m_MaxGroup).LowArticle = pLowArticle
		m_Groups(m_MaxGroup).HighArticle = pHighArticle
		m_Groups(m_MaxGroup).Postability = pPostability
		m_MaxGroup = m_MaxGroup + 1
	End Sub
	
	Private Sub m_cNewsReaderd_CancelDownloadArticleExpired() Handles m_cNewsReaderd.CancelDownloadArticleExpired
		Call FRMMain.DownloadFile(m_cNewsReaderD)
	End Sub
	
	Private Sub m_cNewsReaderd_FileDownloadedSuccessfully(ByRef pLastFileID As Integer) Handles m_cNewsReaderd.FileDownloadedSuccessfully
		Call Execute("UPDATE [file] SET DownloadedSuccessfully=true WHERE uid=" & pLastFileID, True)
		FRMMain.m_lngLastCompleteFile = pLastFileID
		'If m_blnGettingMissingArticles = True Then
		'    Set rsArticle = Nothing ' Force get next file, adjust later to use flag to move in downloadfile function
		'End If
	End Sub
	
	Private Sub m_cNewsReaderd_GetLastArticleForGroup(ByRef pLastArticleID As Integer, ByRef pGroupID As Integer, ByRef pServerID As Integer) Handles m_cNewsReaderd.GetLastArticleForGroup
		Dim rstemp As ADODB.Recordset
		If pServerID = 0 Then
			pLastArticleID = Val(GetServerSetting("GroupMax-" & pGroupID, False))
		Else
			If (OpenRecordset(rstemp, "SELECT Max(ArticleNumber) AS maxx FROM [Article2] WHERE GroupID=" & pGroupID, dbOpenSnapshot)) Then
				If (Val(rstemp.Fields("maxx").Value & "") <> 0) Then
					pLastArticleID = Val(rstemp.Fields("maxx").Value & "")
				End If
			End If
		End If
	End Sub
	
	Private Sub m_cNewsReaderd_GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer) Handles m_cNewsReaderd.GetOutputSegmentSize
		Call GetOutputSegmentSize(pOutputSegSize, pfilename, pLastFileID, pLastArticleIndex)
	End Sub
	
	Private Sub m_cNewsReaderd_LogEvent(ByRef pName As String) Handles m_cNewsReaderd.LogEvent
		Call FRMMain.LogEvent(pName, (m_cNewsReaderD.index))
	End Sub
	
	Private Sub m_cNewsReaderd_MoveFile(ByRef pfilename As String, ByRef psubject As String) Handles m_cNewsReaderd.MoveFile
		Call FRMMain.LogEvent("File Complete -" & pfilename, (m_cNewsReaderD.index))
		
		Call FRMMain.MoveFile(pfilename, psubject)
	End Sub
	
	Private Sub m_cNewsReaderd_ProcessAllArticleList() Handles m_cNewsReaderd.ProcessAllArticleList
		Call ProcessAllArticleList(m_cNewsReaderD)
	End Sub
	
	Private Sub m_cNewsReaderd_ProcessArticle(ByRef pArticleNumber As Integer, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer) Handles m_cNewsReaderd.ProcessArticle
		Call FRMMain.ProcessArticle(pArticleNumber, psubject, pLineCount, pPostDate, pGroupID, pLinesExpected, 2)
	End Sub
	
	Private Sub m_cNewsReaderd_ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer) Handles m_cNewsReaderd.ProcessMissingArticle
		Call ProcessMissingArticle(pArticleNumber, pGroupID)
	End Sub
	
	Private Sub m_cNewsReaderd_TriggerDownloadFile(ByRef pNextRecord As Boolean) Handles m_cNewsReaderd.TriggerDownloadFile
		Call FRMMain.DownloadFile(m_cNewsReaderD)
	End Sub
	
	Private Sub m_cNewsReaderd_UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer) Handles m_cNewsReaderd.UpdateLastFileName
		Call UpdateLastFileName(m_cNewsReaderD, pfilename, pLastFileID)
	End Sub
	
	Private Sub m_cNewsReaderD_UpdateRx(ByRef pData As String) Handles m_cNewsReaderD.UpdateRx
		Call FRMMain.UpdateRx((m_cNewsReaderC.index), pData)
	End Sub
	
	'''''''''''''''''''''''''''''
	'' e
	
	Private Sub m_cNewsReadere_AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Double, ByRef pHighArticle As Double, ByRef pPostability As String) Handles m_cNewsReadere.AddUpdateGroup
		' Store groups for update later
		m_Groups(m_MaxGroup).Name = pName
		m_Groups(m_MaxGroup).LowArticle = pLowArticle
		m_Groups(m_MaxGroup).HighArticle = pHighArticle
		m_Groups(m_MaxGroup).Postability = pPostability
		m_MaxGroup = m_MaxGroup + 1
	End Sub
	
	Private Sub m_cNewsReadere_CancelDownloadArticleExpired() Handles m_cNewsReadere.CancelDownloadArticleExpired
		Call FRMMain.DownloadFile(m_cNewsReaderE)
	End Sub
	
	Private Sub m_cNewsReadere_FileDownloadedSuccessfully(ByRef pLastFileID As Integer) Handles m_cNewsReadere.FileDownloadedSuccessfully
		Call Execute("UPDATE [file] SET DownloadedSuccessfully=true WHERE uid=" & pLastFileID, True)
		FRMMain.m_lngLastCompleteFile = pLastFileID
		'If m_blnGettingMissingArticles = True Then
		'    Set rsArticle = Nothing ' Force get next file, adjust later to use flag to move in downloadfile function
		'End If
	End Sub
	
	Private Sub m_cNewsReadere_GetLastArticleForGroup(ByRef pLastArticleID As Integer, ByRef pGroupID As Integer, ByRef pServerID As Integer) Handles m_cNewsReadere.GetLastArticleForGroup
		Dim rstemp As ADODB.Recordset
		If pServerID = 0 Then
			pLastArticleID = Val(GetServerSetting("GroupMax-" & pGroupID, False))
		Else
			If (OpenRecordset(rstemp, "SELECT Max(ArticleNumber) AS maxx FROM [Article2] WHERE GroupID=" & pGroupID, dbOpenSnapshot)) Then
				If (Val(rstemp.Fields("maxx").Value & "") <> 0) Then
					pLastArticleID = Val(rstemp.Fields("maxx").Value & "")
				End If
			End If
		End If
	End Sub
	
	Private Sub m_cNewsReadere_GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer) Handles m_cNewsReadere.GetOutputSegmentSize
		Call GetOutputSegmentSize(pOutputSegSize, pfilename, pLastFileID, pLastArticleIndex)
	End Sub
	
	Private Sub m_cNewsReaderE_LogEvent(ByRef pName As String) Handles m_cNewsReaderE.LogEvent
		Call FRMMain.LogEvent(pName, (m_cNewsReaderE.index))
	End Sub
	
	Private Sub m_cNewsReadere_MoveFile(ByRef pfilename As String, ByRef psubject As String) Handles m_cNewsReadere.MoveFile
		Call FRMMain.MoveFile(pfilename, psubject)
	End Sub
	
	Private Sub m_cNewsReadere_ProcessAllArticleList() Handles m_cNewsReadere.ProcessAllArticleList
		Call ProcessAllArticleList(m_cNewsReaderE)
	End Sub
	
	Private Sub m_cNewsReadere_ProcessArticle(ByRef pArticleNumber As Integer, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer) Handles m_cNewsReadere.ProcessArticle
		Call FRMMain.ProcessArticle(pArticleNumber, psubject, pLineCount, pPostDate, pGroupID, pLinesExpected, 2)
	End Sub
	
	Private Sub m_cNewsReadere_ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer) Handles m_cNewsReadere.ProcessMissingArticle
		Call ProcessMissingArticle(pArticleNumber, pGroupID)
	End Sub
	
	Private Sub m_cNewsReadere_TriggerDownloadFile(ByRef pNextRecord As Boolean) Handles m_cNewsReadere.TriggerDownloadFile
		Call FRMMain.DownloadFile(m_cNewsReaderE)
	End Sub
	
	Private Sub m_cNewsReadere_UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer) Handles m_cNewsReadere.UpdateLastFileName
		Call UpdateLastFileName(m_cNewsReaderE, pfilename, pLastFileID)
	End Sub
	
	Private Sub m_cNewsReaderE_UpdateRX(ByRef pData As String) Handles m_cNewsReaderE.UpdateRX
		Call FRMMain.UpdateRx((m_cNewsReaderE.index), pData)
	End Sub
	
	'''''''''''''''''''''''''''''
	'' f
	
	Private Sub m_cNewsReaderf_AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Double, ByRef pHighArticle As Double, ByRef pPostability As String) Handles m_cNewsReaderf.AddUpdateGroup
		' Store groups for update later
		m_Groups(m_MaxGroup).Name = pName
		m_Groups(m_MaxGroup).LowArticle = pLowArticle
		m_Groups(m_MaxGroup).HighArticle = pHighArticle
		m_Groups(m_MaxGroup).Postability = pPostability
		m_MaxGroup = m_MaxGroup + 1
	End Sub
	
	Private Sub m_cNewsReaderf_CancelDownloadArticleExpired() Handles m_cNewsReaderf.CancelDownloadArticleExpired
		Call FRMMain.DownloadFile(m_cNewsReaderF)
	End Sub
	
	Private Sub m_cNewsReaderf_FileDownloadedSuccessfully(ByRef pLastFileID As Integer) Handles m_cNewsReaderf.FileDownloadedSuccessfully
		Call Execute("UPDATE [file] SET DownloadedSuccessfully=true WHERE uid=" & pLastFileID, True)
		FRMMain.m_lngLastCompleteFile = pLastFileID
		'If m_blnGettingMissingArticles = True Then
		'    Set rsArticle = Nothing ' Force get next file, adjust later to use flag to move in downloadfile function
		'End If
	End Sub
	
	Private Sub m_cNewsReaderf_GetLastArticleForGroup(ByRef pLastArticleID As Integer, ByRef pGroupID As Integer, ByRef pServerID As Integer) Handles m_cNewsReaderf.GetLastArticleForGroup
		Dim rstemp As ADODB.Recordset
		If pServerID = 0 Then
			pLastArticleID = Val(GetServerSetting("GroupMax-" & pGroupID, False))
		Else
			If (OpenRecordset(rstemp, "SELECT Max(ArticleNumber) AS maxx FROM [Article2] WHERE GroupID=" & pGroupID, dbOpenSnapshot)) Then
				If (Val(rstemp.Fields("maxx").Value & "") <> 0) Then
					pLastArticleID = Val(rstemp.Fields("maxx").Value & "")
				End If
			End If
		End If
	End Sub
	
	Private Sub m_cNewsReaderf_GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer) Handles m_cNewsReaderf.GetOutputSegmentSize
		Call GetOutputSegmentSize(pOutputSegSize, pfilename, pLastFileID, pLastArticleIndex)
	End Sub
	
	Private Sub m_cNewsReaderF_LogEvent(ByRef pName As String) Handles m_cNewsReaderF.LogEvent
		Call FRMMain.LogEvent(pName, (m_cNewsReaderF.index))
	End Sub
	
	Private Sub m_cNewsReaderf_MoveFile(ByRef pfilename As String, ByRef psubject As String) Handles m_cNewsReaderf.MoveFile
		Call FRMMain.MoveFile(pfilename, psubject)
	End Sub
	
	Private Sub m_cNewsReaderf_ProcessAllArticleList() Handles m_cNewsReaderf.ProcessAllArticleList
		Call ProcessAllArticleList(m_cNewsReaderF)
	End Sub
	
	Private Sub m_cNewsReaderf_ProcessArticle(ByRef pArticleNumber As Integer, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer) Handles m_cNewsReaderf.ProcessArticle
		Call FRMMain.ProcessArticle(pArticleNumber, psubject, pLineCount, pPostDate, pGroupID, pLinesExpected, 2)
	End Sub
	
	Private Sub m_cNewsReaderf_ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer) Handles m_cNewsReaderf.ProcessMissingArticle
		Call ProcessMissingArticle(pArticleNumber, pGroupID)
	End Sub
	
	Private Sub m_cNewsReaderf_TriggerDownloadFile(ByRef pNextRecord As Boolean) Handles m_cNewsReaderf.TriggerDownloadFile
		Call FRMMain.DownloadFile(m_cNewsReaderF)
	End Sub
	
	Private Sub m_cNewsReaderf_UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer) Handles m_cNewsReaderf.UpdateLastFileName
		Call UpdateLastFileName(m_cNewsReaderF, pfilename, pLastFileID)
	End Sub
	
	Private Sub m_cNewsReaderF_UpdateRX(ByRef pData As String) Handles m_cNewsReaderF.UpdateRX
		Call FRMMain.UpdateRx((m_cNewsReaderF.index), pData)
	End Sub
	
	'''''''''''''''''''''''''''''
	'' g
	
	Private Sub m_cNewsReaderg_AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Double, ByRef pHighArticle As Double, ByRef pPostability As String) Handles m_cNewsReaderg.AddUpdateGroup
		' Store groups for update later
		m_Groups(m_MaxGroup).Name = pName
		m_Groups(m_MaxGroup).LowArticle = pLowArticle
		m_Groups(m_MaxGroup).HighArticle = pHighArticle
		m_Groups(m_MaxGroup).Postability = pPostability
		m_MaxGroup = m_MaxGroup + 1
	End Sub
	
	Private Sub m_cNewsReaderg_CancelDownloadArticleExpired() Handles m_cNewsReaderg.CancelDownloadArticleExpired
		Call FRMMain.DownloadFile(m_cNewsReaderG)
	End Sub
	
	Private Sub m_cNewsReaderg_FileDownloadedSuccessfully(ByRef pLastFileID As Integer) Handles m_cNewsReaderg.FileDownloadedSuccessfully
		Call Execute("UPDATE [file] SET DownloadedSuccessfully=true WHERE uid=" & pLastFileID, True)
		FRMMain.m_lngLastCompleteFile = pLastFileID
		'If m_blnGettingMissingArticles = True Then
		'    Set rsArticle = Nothing ' Force get next file, adjust later to use flag to move in downloadfile function
		'End If
	End Sub
	
	Private Sub m_cNewsReaderg_GetLastArticleForGroup(ByRef pLastArticleID As Integer, ByRef pGroupID As Integer, ByRef pServerID As Integer) Handles m_cNewsReaderg.GetLastArticleForGroup
		Dim rstemp As ADODB.Recordset
		If pServerID = 0 Then
			pLastArticleID = Val(GetServerSetting("GroupMax-" & pGroupID, False))
		Else
			If (OpenRecordset(rstemp, "SELECT Max(ArticleNumber) AS maxx FROM [Article2] WHERE GroupID=" & pGroupID, dbOpenSnapshot)) Then
				If (Val(rstemp.Fields("maxx").Value & "") <> 0) Then
					pLastArticleID = Val(rstemp.Fields("maxx").Value & "")
				End If
			End If
		End If
	End Sub
	
	Private Sub m_cNewsReaderg_GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer) Handles m_cNewsReaderg.GetOutputSegmentSize
		Call GetOutputSegmentSize(pOutputSegSize, pfilename, pLastFileID, pLastArticleIndex)
	End Sub
	
	Private Sub m_cNewsReaderG_LogEvent(ByRef pName As String) Handles m_cNewsReaderG.LogEvent
		Call FRMMain.LogEvent(pName, (m_cNewsReaderG.index))
	End Sub
	
	Private Sub m_cNewsReaderg_MoveFile(ByRef pfilename As String, ByRef psubject As String) Handles m_cNewsReaderg.MoveFile
		Call FRMMain.MoveFile(pfilename, psubject)
	End Sub
	
	Private Sub m_cNewsReaderg_ProcessAllArticleList() Handles m_cNewsReaderg.ProcessAllArticleList
		Call ProcessAllArticleList(m_cNewsReaderG)
	End Sub
	
	
	Private Sub m_cNewsReaderg_ProcessArticle(ByRef pArticleNumber As Integer, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer) Handles m_cNewsReaderg.ProcessArticle
		Call FRMMain.ProcessArticle(pArticleNumber, psubject, pLineCount, pPostDate, pGroupID, pLinesExpected, 2)
	End Sub
	
	Private Sub m_cNewsReaderg_ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer) Handles m_cNewsReaderg.ProcessMissingArticle
		Call ProcessMissingArticle(pArticleNumber, pGroupID)
	End Sub
	
	Private Sub m_cNewsReaderg_TriggerDownloadFile(ByRef pNextRecord As Boolean) Handles m_cNewsReaderg.TriggerDownloadFile
		Call FRMMain.DownloadFile(m_cNewsReaderG)
	End Sub
	
	Private Sub m_cNewsReaderg_UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer) Handles m_cNewsReaderg.UpdateLastFileName
		Call UpdateLastFileName(m_cNewsReaderG, pfilename, pLastFileID)
	End Sub
	
	Private Sub m_cNewsReaderG_UpdateRX(ByRef pData As String) Handles m_cNewsReaderG.UpdateRX
		Call FRMMain.UpdateRx((m_cNewsReaderG.index), pData)
	End Sub
	
	'''''''''''''''''''''''''''''
	'' h
	
	Private Sub m_cNewsReaderh_AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Double, ByRef pHighArticle As Double, ByRef pPostability As String) Handles m_cNewsReaderh.AddUpdateGroup
		' Store groups for update later
		m_Groups(m_MaxGroup).Name = pName
		m_Groups(m_MaxGroup).LowArticle = pLowArticle
		m_Groups(m_MaxGroup).HighArticle = pHighArticle
		m_Groups(m_MaxGroup).Postability = pPostability
		m_MaxGroup = m_MaxGroup + 1
	End Sub
	
	Private Sub m_cNewsReaderh_CancelDownloadArticleExpired() Handles m_cNewsReaderh.CancelDownloadArticleExpired
		Call FRMMain.DownloadFile(m_cNewsReaderH)
	End Sub
	
	Private Sub m_cNewsReaderh_FileDownloadedSuccessfully(ByRef pLastFileID As Integer) Handles m_cNewsReaderh.FileDownloadedSuccessfully
		Call Execute("UPDATE [file] SET DownloadedSuccessfully=true WHERE uid=" & pLastFileID, True)
		FRMMain.m_lngLastCompleteFile = pLastFileID
		'If m_blnGettingMissingArticles = True Then
		'    Set rsArticle = Nothing ' Force get next file, adjust later to use flag to move in downloadfile function
		'End If
	End Sub
	
	Private Sub m_cNewsReaderh_GetLastArticleForGroup(ByRef pLastArticleID As Integer, ByRef pGroupID As Integer, ByRef pServerID As Integer) Handles m_cNewsReaderh.GetLastArticleForGroup
		Dim rstemp As ADODB.Recordset
		If pServerID = 0 Then
			pLastArticleID = Val(GetServerSetting("GroupMax-" & pGroupID, False))
		Else
			If (OpenRecordset(rstemp, "SELECT Max(ArticleNumber) AS maxx FROM [Article2] WHERE GroupID=" & pGroupID, dbOpenSnapshot)) Then
				If (Val(rstemp.Fields("maxx").Value & "") <> 0) Then
					pLastArticleID = Val(rstemp.Fields("maxx").Value & "")
				End If
			End If
		End If
	End Sub
	
	Private Sub m_cNewsReaderh_GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer) Handles m_cNewsReaderh.GetOutputSegmentSize
		Call GetOutputSegmentSize(pOutputSegSize, pfilename, pLastFileID, pLastArticleIndex)
	End Sub
	
	Private Sub m_cNewsReaderH_LogEvent(ByRef pName As String) Handles m_cNewsReaderH.LogEvent
		Call FRMMain.LogEvent(pName, (m_cNewsReaderH.index))
	End Sub
	
	Private Sub m_cNewsReaderh_MoveFile(ByRef pfilename As String, ByRef psubject As String) Handles m_cNewsReaderh.MoveFile
		Call FRMMain.MoveFile(pfilename, psubject)
	End Sub
	
	Private Sub m_cNewsReaderh_ProcessAllArticleList() Handles m_cNewsReaderh.ProcessAllArticleList
		Call ProcessAllArticleList(m_cNewsReaderH)
	End Sub
	
	Private Sub m_cNewsReaderh_ProcessArticle(ByRef pArticleNumber As Integer, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer) Handles m_cNewsReaderh.ProcessArticle
		Call FRMMain.ProcessArticle(pArticleNumber, psubject, pLineCount, pPostDate, pGroupID, pLinesExpected, 2)
	End Sub
	
	Private Sub m_cNewsReaderh_ProcessMissingArticle(ByRef pArticleNumber As Integer, ByRef pGroupID As Integer) Handles m_cNewsReaderh.ProcessMissingArticle
		Call ProcessMissingArticle(pArticleNumber, pGroupID)
	End Sub
	
	Private Sub m_cNewsReaderh_TriggerDownloadFile(ByRef pNextRecord As Boolean) Handles m_cNewsReaderh.TriggerDownloadFile
		Call FRMMain.DownloadFile(m_cNewsReaderH)
	End Sub
	
	
	Private Sub m_cNewsReaderh_UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer) Handles m_cNewsReaderh.UpdateLastFileName
		Call UpdateLastFileName(m_cNewsReaderH, pfilename, pLastFileID)
	End Sub
	
	Private Sub m_cNewsReaderH_UpdateRX(ByRef pData As String) Handles m_cNewsReaderH.UpdateRX
		Call FRMMain.UpdateRx((m_cNewsReaderH.index), pData)
	End Sub
	
	'''''''''''''''''''''''''''''
End Class