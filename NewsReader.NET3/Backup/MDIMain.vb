Option Strict Off
Option Explicit On
Friend Class MDIMain
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' Main MDI Object
	''
	'' Coded by Dale Pitman
	
	''
	Public Sub LogOnUser(ByRef pUserID As Integer, ByRef pUserName As String)
		Dim rstemp As ADODB.Recordset
		Call GlobalLogOnUser(pUserID)
		
		'Show menus here, depending on user access
		MNUConfig.Visible = True
		MNUWindow.Visible = True
		
	End Sub
	
	''
	Public Sub LogOffUser()
		Call Me.Close()
	End Sub
	
	''function to locate and save a specified database
	Private Function LocateDatabase(ByRef DatabaseName As String) As String
		On Error GoTo Dialog_Cancelled
		'setup the common dialog control
		With Me.CommonDialogControl
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.Filter. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			.Filter = DatabaseName & "|" & DatabaseName
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.CancelError. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			.CancelError = True
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.DialogTitle. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			.DialogTitle = "Locate " & DatabaseName & " database"
			'Show the open dialog
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.ShowOpen. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			.ShowOpen()
			'save the returned setting
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.FileName. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			SaveSetting(cRegistoryName, "Settings", DatabaseName, .FileName)
			'return the path
			'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.FileName. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			LocateDatabase = .FileName
		End With
		Exit Function
Dialog_Cancelled: 
		'if there was an error or the user cancelled the function, return "****"
		LocateDatabase = "****"
		Exit Function
	End Function
	
	Private Sub ReDoFileNames()
		Dim rstemp As ADODB.Recordset
		Dim te As New cArticleProcessing
		If OpenRecordset(rstemp, "SELECT * FROM [File]", dbOpenDynaset) = True Then
			Do While rstemp.EOF = False
				If rstemp.Fields("GroupTypeID").Value = 2 Then
					te.Mp3Mode = True
				Else
					te.Mp3Mode = False
				End If
				Call te.ProcessSubject(rstemp.Fields("debug").Value)
				rstemp.Fields("FileName").Value = te.FileName
				rstemp.Fields("Name").Value = te.GroupName
				rstemp.Update()
				rstemp.MoveNext()
			Loop 
		End If
	End Sub
	
	Private Sub testnameprocessing()
		Dim rstemp As ADODB.Recordset
		Dim te As New cArticleProcessing
		Dim Subject As String
		Dim i As Integer
		
		Call OpenRecordset(rstemp, "SELECT * FROM [File] WHERE GroupTypeID=2", dbOpenDynaset)
		Do While rstemp.EOF = False
			te.Mp3Mode = True
			
			Call te.ProcessSubject(rstemp.Fields("debug").Value)
			
			
			rstemp.Fields("FileName").Value = te.FileName
			rstemp.Fields("Name").Value = te.GroupName
			rstemp.MoveNext()
		Loop 
	End Sub
	
	Private Sub InitScreen()
		Dim i As Integer
		LBLAction.Text = "Ready"
		For i = 0 To LBLProgress.Count - 1
			LBLProgress(i).Text = "Ready"
			If i < 3 Then
				LBLPacketNumber(i).Text = ""
			End If
		Next 
		LBLTransfer.Text = ""
		
	End Sub
	
	'UPGRADE_WARNING: Event CBOGroupType.SelectedIndexChanged may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub CBOGroupType_SelectedIndexChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CBOGroupType.SelectedIndexChanged
		Call FRMMain.ChangeGroupType(CBOGroupType)
	End Sub
	
	''
	Private Sub MDIMain_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		Dim te As New cArticleProcessing
		Dim threads As Integer
		
		Dim DatabaseName As String
		'    Call SetWindowPosition(Me)
		
		On Error GoTo loadpictureerror
		'    PICBackground.Picture = LoadPicture(App.Path & "\" & cProjectName & ".bmp")
loadpictureerror: 
		On Error GoTo 0
		
		Me.Text = cProjectName & cVersionNumber
		
		'' Connnect to database
		DatabaseName = cDatabaseName
		'If (Command = "testing") Then
		'        DatabaseName = "Testing.mdb"
		'End If
		DatabaseName = "NewsReader.MDB"
		If (ConnectDatabase(DatabaseName) = True) Then
			'        FRMAbout.vLicencedTo = GetLicenceTo
			'        If (FRMAbout.vLicencedTo = "*Unlicenced*") Then
			'            Call FRMAbout.Show
			'        End If
			Call Startup()
			Call FRMOptions.LoadSettings()
			PicStatusBar.Visible = FRMOptions.StatusVisible
			Call InitFileStorage()
		Else
			End
		End If
		
		'    Dim rstemp As Recordset
		
		'    Call SetServerSetting("FileIDBase", 97272)
		'    Call OpenRecordset(rstemp, "SELECT * FROM article ORDER BY [FileID]", dbOpenSnapshot)
		'    Do While rstemp.EOF = False
		'        Call UpdateFileIDs(rstemp![FileID], rstemp![ArticleNumber], rstemp!GroupID, rstemp!FileIndex)
		'        rstemp.MoveNext
		'    Loop
		'    rstemp.MoveFirst
		lblBytesTotal.Text = ""
		
		Call InitScreen()
		Call ShowForm(frmReaderHolder)
		frmReaderHolder.Visible = False
		Call ShowForm(frmIMDBHolder)
		frmIMDBHolder.Visible = False
		Call ShowForm(FRMMain)
		Call FRMMain.GetIgnorePaths()
		'    Call ShowForm(FRMViewFiles)
		
		FRMContextMenu.Show()
		FRMContextMenu.Visible = False
	End Sub
	
	Private Sub MDIMain_FormClosed(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
		Call GetWindowPosition(Me)
		Call CloseFileStorage()
		Call Shutdown()
	End Sub
	
	Public Sub MNUAbout_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUAbout.Click
		'    Call ShowForm(FRMAbout)
	End Sub
	
	Public Sub MNUAddRemoveGroups_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUAddRemoveGroups.Click
		Call FRMAddRemoveGroups.Show()
	End Sub
	
	Public Sub mnuAutoHine_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuAutoHine.Click
		ProcessAutoHide((FRMMain.m_GroupTypeID))
	End Sub
	
	Public Sub MNUClearDownloading_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUClearDownloading.Click
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		Call Execute("UPDATE [FILE] SET Downloading=false WHERE [downloadFile] = True", True)
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Sub
	
	Public Sub MNUCompactDB_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUCompactDB.Click
		'UPGRADE_NOTE: FileSystem was upgraded to FileSystem_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim FileSystem_Renamed As New Scripting.FileSystemObject
		
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		db.Close()
		
		Dim a As JRO.JetEngine
		a = New JRO.JetEngine
		Dim databasePath As String
		databasePath = GetSetting(cRegistoryName, "Settings", cDatabaseName, "NODATABASE")
		'"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & SystemPath
		On Error GoTo filenotExits
		Call FileSystem_Renamed.DeleteFile("C:\temp.mdb")
filenotExits: 
		a.CompactDatabase(db.ConnectionString, "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\temp.mdb;Jet OLEDB:Engine Type=4")
		
		Call FileSystem_Renamed.MoveFile(databasePath, databasePath & ".old")
		Call FileSystem_Renamed.MoveFile("c:\temp.mdb", databasePath)
		'1 JET10
		'2 JET11
		'3 JET2X
		'4 JET3X
		'5 JET4X
		
		db.Open()
		Call FileSystem_Renamed.DeleteFile(databasePath & ".old")
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Sub
	
	
	Public Sub mnuCompactStore_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuCompactStore.Click
		CompactDB()
	End Sub
	
	Public Sub mnuDownloadFiles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuDownloadFiles.Click
		FRMMain.CMDDownloadFiles_Click(Nothing, New System.EventArgs())
	End Sub
	
	Public Sub MNUExit_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUExit.Click
		Call Me.Close()
	End Sub
	
	Public Sub MNUGetAllGroups_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUGetAllGroups.Click
		FRMMain.CMDGetAllGroups_Click(Nothing, New System.EventArgs())
	End Sub
	
	Public Sub mnuGetAlternateServerArticles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuGetAlternateServerArticles.Click
		'Call FRMMain.DownloadAlternateServerArticles
	End Sub
	
	Public Sub mnuGetAlternateServerFiles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuGetAlternateServerFiles.Click
		'Call FRMMain.DownloadAlternateServerFiles
	End Sub
	
	Public Sub MNUGetNewArticles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUGetNewArticles.Click
		FRMMain.cmdGetNewArticles_Click(Nothing, New System.EventArgs())
	End Sub
	
	Public Sub mnuGroupType_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuGroupType.Click
		Dim Index As Short = mnuGroupType.GetIndex(eventSender)
		CBOGroupType.SelectedIndex = Index
		Call FRMMain.ChangeGroupType(CBOGroupType)
	End Sub
	
	''
	Public Sub MNULogin_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNULogin.Click
		'    Call ShowForm(FRMLogin)
	End Sub
	
	Public Sub MNUOptions_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUOptions.Click
		Call ShowForm(FRMOptions)
	End Sub
	
	Public Sub mnuPictureIgnoreList_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuPictureIgnoreList.Click
		Call ShowForm(frmIgnoreList)
	End Sub
	
	Public Sub mnuThreads_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuThreads.Click
		Dim Index As Short = mnuThreads.GetIndex(eventSender)
		Dim i As Integer
		Call frmReaderHolder.RefreshThreads(Index + 1)
		For i = 0 To mnuThreads.Count - 1
			mnuThreads(i).Checked = False
		Next 
		mnuThreads(Index).Checked = True
		Call SaveSetting(cRegistoryName, "Settings", "Threads", CStr(Index + 1))
		
	End Sub
	
	Public Sub MNUViewFiles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MNUViewFiles.Click
		FRMMain.CMDViewFiles_Click(Nothing, New System.EventArgs())
	End Sub
End Class