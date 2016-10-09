Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class FRMOptions
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' Settings form, loads / save and stores all program settings
	''
	'' Coded by Dale Pitman
	
	Private vIsLoaded As Boolean
	
	Private m_CompanyName As String
	
	Private m_TempDownloadPath As String
	Private m_ServerName As String
	Private m_UserName As String
	Private m_Password As String
	
	Private m_BackupServerName As String
	Private m_BackupUserName As String
	Private m_BackupPassword As String
	
	Private m_StartPars As Boolean
	
	Private m_jpgPath As String
	
	Private m_schedule(23) As Boolean
	Private m_Download(23) As Boolean
	
	Private m_Report2ndServer As Boolean
	Private m_UseAlternateServer As Boolean
	Private m_ConnectionAttempts As Integer
	Private m_StatusVisible As Boolean
	
	Private m_AutoDownloadJPG As Boolean
	Private m_FilterXVID As Boolean
	Private m_FilterSVCD As Boolean
	Private m_Database As String
	Private m_DatabaseOLD As String
	Private m_MaxArticleAge As Integer
	
	
	Public WriteOnly Property Report2ndServer() As Boolean
		Set(ByVal Value As Boolean)
			m_Report2ndServer = Value
		End Set
	End Property
	
	
	'UPGRADE_NOTE: CompanyName was upgraded to CompanyName_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
	Public ReadOnly Property CompanyName_Renamed() As String
		Get
			CompanyName_Renamed = m_CompanyName
		End Get
	End Property
	
	
	Public ReadOnly Property TempDownloadPath() As String
		Get
			TempDownloadPath = m_TempDownloadPath
		End Get
	End Property
	
	Public ReadOnly Property BackupServerName() As String
		Get
			BackupServerName = m_BackupServerName
		End Get
	End Property
	
	Public ReadOnly Property BackupUsername() As String
		Get
			BackupUsername = m_BackupUserName
		End Get
	End Property
	
	Public ReadOnly Property BackupPassword() As String
		Get
			BackupPassword = m_BackupPassword
		End Get
	End Property
	
	
	Public ReadOnly Property ServerName() As String
		Get
			If m_Report2ndServer = False Then
				ServerName = m_ServerName
			Else
				ServerName = m_BackupServerName
			End If
		End Get
	End Property
	
	Public ReadOnly Property Username() As String
		Get
			If m_Report2ndServer = False Then
				Username = m_UserName
			Else
				Username = m_BackupUserName
			End If
		End Get
	End Property
	
	Public ReadOnly Property Password() As String
		Get
			If m_Report2ndServer = False Then
				Password = m_Password
			Else
				Password = m_BackupPassword
			End If
		End Get
	End Property
	
	Public ReadOnly Property StartPars() As Boolean
		Get
			'UPGRADE_ISSUE: App property App.PrevInstance was not upgraded. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="076C26E5-B7A9-4E77-B69C-B4448DF39E58"'
            'If App.PrevInstance = False Then
            StartPars = m_StartPars
            'Else
            'StartPars = False
            'End If
		End Get
	End Property
	
	Public ReadOnly Property JPGPath() As String
		Get
			JPGPath = m_jpgPath
		End Get
	End Property
	
	Public ReadOnly Property Schedule(ByVal Index As Integer) As Boolean
		Get
			Schedule = m_schedule(Index)
		End Get
	End Property
	
	Public ReadOnly Property Download(ByVal Index As Integer) As Boolean
		Get
			Download = m_Download(Index)
		End Get
	End Property
	
	Public ReadOnly Property UseAlternateServer() As Boolean
		Get
			UseAlternateServer = m_UseAlternateServer
		End Get
	End Property
	
	Public ReadOnly Property ConnectionAttempts() As Integer
		Get
			ConnectionAttempts = m_ConnectionAttempts
		End Get
	End Property
	
	Public ReadOnly Property StatusVisible() As Boolean
		Get
			StatusVisible = m_StatusVisible
		End Get
	End Property
	
	Public ReadOnly Property AutoDownloadJPG() As Boolean
		Get
			AutoDownloadJPG = m_AutoDownloadJPG
		End Get
	End Property
	
	Public ReadOnly Property FilterXVID() As Boolean
		Get
			FilterXVID = m_FilterXVID
		End Get
	End Property
	
	Public ReadOnly Property FilterSVCD() As Boolean
		Get
			FilterSVCD = m_FilterSVCD
		End Get
	End Property
	
	Public ReadOnly Property Database() As String
		Get
			Database = m_Database
		End Get
	End Property
	
	Public ReadOnly Property MaxArticleAge() As Integer
		Get
			MaxArticleAge = m_MaxArticleAge
		End Get
	End Property
	
	''
	Public Function IsNotLoaded() As Boolean
		IsNotLoaded = Not vIsLoaded
	End Function
	
	''
	Public Sub SetFormFocus()
		'UPGRADE_WARNING: Form method FRMOptions.ZOrder has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		Me.BringToFront()
	End Sub
	
	Private Function SetServerSettingchk(ByRef pchk As System.Windows.Forms.CheckState, ByRef pstrName As String) As Boolean
		If pchk = System.Windows.Forms.CheckState.Checked Then
			Call SetServerSetting(pstrName, "True")
			SetServerSettingchk = True
		Else
			Call SetServerSetting(pstrName, "False")
			SetServerSettingchk = False
		End If
	End Function
	
	Private Function GetServerSettingchk(ByRef pstrName As String) As System.Windows.Forms.CheckState
		If GetServerSetting(pstrName, False) = "True" Then
			GetServerSettingchk = System.Windows.Forms.CheckState.Checked
		Else
			GetServerSettingchk = System.Windows.Forms.CheckState.Unchecked
		End If
	End Function
	
	'UPGRADE_WARNING: Event chkSchedule.CheckStateChanged may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub chkSchedule_CheckStateChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles chkSchedule.CheckStateChanged
		Dim Index As Short = chkSchedule.GetIndex(eventSender)
		If Index < 22 Then
			chkSchedule(Index + 1).CheckState = System.Windows.Forms.CheckState.Unchecked
		End If
	End Sub
	
	
	Private Sub cmdDatabase_Click()
		
	End Sub
	
	Private Sub cmdDatabasePath_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdDatabasePath.Click
		Dim path As String
		On Error GoTo fin
		
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.InitDir. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
        'MDIMain.CommonDialogControl.InitDir = txtDatabasePath.CtlText
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.ShowSave. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        'MDIMain.CommonDialogControl.ShowSave()
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.FileName. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        'path = VB.Left(MDIMain.CommonDialogControl.FileName, InStrRev(MDIMain.CommonDialogControl.FileName, "\"))
		If path <> "" Then
			'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
			txtDatabasePath.CtlText = path
		End If
fin: 
		
	End Sub
	
	''
	Private Sub CMDOK_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDOK.Click
		Dim i As Integer
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("TempDownloadPath", (TXTTempDownloadPath.CtlText))
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("NewsServer", (TXTServerName.CtlText))
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("UserName", (TXTUserName.CtlText))
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("Password", (TXTPassword.CtlText))
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("BackupNewsServer", (txtBackupServer.CtlText))
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("BackupUserName", (txtBackupUsername.CtlText))
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("BackupPassword", (txtBackupPassword.CtlText))
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("JPGPath", (txtPicturePath.CtlText))
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("DatabasePath", (txtDatabasePath.CtlText))
		
		
		m_StartPars = SetServerSettingchk((chkStartPars.CheckState), "StartPars")
		Call SetServerSettingchk((chkUseAlternateServer.CheckState), "UseAlternateServer")
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("ConnectionAttempts", (txtConnectionAttempts.CtlText))
		Call SetServerSettingchk((chkStatusVisible.CheckState), "StatusVisible")
		
		Call SetServerSettingchk((chkAutoDownloadJPG.CheckState), "AutoDownloadJPG")
		Call SetServerSettingchk((chkDownloadNfo.CheckState), "DownloadNFOsFirst")
		Call SetServerSettingchk((chkFilterXVID.CheckState), "FilterXVID")
		Call SetServerSettingchk((chkFilterSVCD.CheckState), "FilterSVCD")
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call SetServerSetting("MaxArticleAge", (txtMaxArticleAge.CtlText))
		
		For i = 0 To 22
			Call SetServerSetting("Schedule" & i, CStr(chkSchedule(i).CheckState))
		Next 
		
		For i = 0 To 22
			Call SetServerSetting("Download" & i, CStr(chkDownload(i).CheckState))
		Next 
		
		' Refresh Program settings
		Call LoadSettings()
		
		MDIMain.PicStatusBar.Visible = Me.StatusVisible
		Call MsgBox("Settings Saved", MsgBoxStyle.Information + MsgBoxStyle.OKOnly, "Options")
		If m_DatabaseOLD <> m_Database Then
			Call MsgBox("The ArticleDB path has changed, please restart the application.", MsgBoxStyle.Exclamation, "Save Settings")
			End
		End If
	End Sub
	
	''
	Private Sub CMDExit_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDExit.Click
		Call Me.Close()
	End Sub
	
	Private Sub cmdPicturePath_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdPicturePath.Click
		Dim path As String
		On Error GoTo fin
		
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.InitDir. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
        'MDIMain.CommonDialogControl.InitDir = txtPicturePath.CtlText
        ''UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.ShowSave. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        'MDIMain.CommonDialogControl.ShowSave()
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.FileName. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        'path = VB.Left(MDIMain.CommonDialogControl.FileName, InStrRev(MDIMain.CommonDialogControl.FileName, "\"))
		If path <> "" Then
			'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
			txtPicturePath.CtlText = path
		End If
fin: 
	End Sub
	
	Private Sub cmdTempPath_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdTempPath.Click
		Dim path As String
		On Error GoTo fin
		
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.InitDir. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
        'MDIMain.CommonDialogControl.InitDir = TXTTempDownloadPath.CtlText
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.ShowSave. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        'MDIMain.CommonDialogControl.ShowSave()
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.FileName. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        'path = VB.Left(MDIMain.CommonDialogControl.FileName, InStrRev(MDIMain.CommonDialogControl.FileName, "\"))
		If path <> "" Then
			'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
			TXTTempDownloadPath.CtlText = path
		End If
fin: 
	End Sub
	
	''
	Private Sub FRMOptions_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		Dim i As Integer
		vIsLoaded = True
		Call SetWindowPosition(Me)
		Call AllFormsLoad(Me)
		Dim rstemp As ADODB.Recordset
		
		Call OpenRecordset(rstemp, "SELECT TOP 1 UID FROM [File] ORDER BY UID ASC", dbOpenSnapshot)
		
		lblDBInfo.Text = "Free Space = " & VB6.Format(((rstemp.Fields("UID").Value - gFileIDBase) * 10 * cFileGroupSize) / 1024 / 1024, "###,###,##0.00") & "MB"
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		TXTServerName.CtlText = GetServerSetting("NewsServer", False)
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		TXTUserName.CtlText = GetServerSetting("UserName", False)
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		TXTPassword.CtlText = GetServerSetting("Password", False)
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtBackupServer.CtlText = GetServerSetting("BackupNewsServer", False)
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtBackupUsername.CtlText = GetServerSetting("BackupUserName", False)
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtBackupPassword.CtlText = GetServerSetting("BackupPassword", False)
		chkUseAlternateServer.CheckState = GetServerSettingchk("UseAlternateServer")
		
		chkStartPars.CheckState = GetServerSettingchk("StartPars")
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		TXTTempDownloadPath.CtlText = GetServerSetting("TempDownloadPath", False)
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtPicturePath.CtlText = GetServerSetting("JPGPath", False)
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtDatabasePath.CtlText = GetServerSetting("DatabasePath", False)
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		m_DatabaseOLD = txtDatabasePath.CtlText
		
		
		chkStatusVisible.CheckState = GetServerSettingchk("StatusVisible")
		
		chkAutoDownloadJPG.CheckState = GetServerSettingchk("AutoDownloadJPG")
		chkDownloadNfo.CheckState = GetServerSettingchk("DownloadNFOsFirst")
		chkFilterXVID.CheckState = GetServerSettingchk("FilterXVID")
		chkFilterSVCD.CheckState = GetServerSettingchk("FilterSVCD")
		
		'    lblPreviousInstance.Caption = "Previous Instance - " & App.PrevInstance
		
		For i = 0 To 22
			chkSchedule(i).CheckState = Val(GetServerSetting("Schedule" & i, False))
		Next 
		
		For i = 0 To 22
			chkDownload(i).CheckState = Val(GetServerSetting("Download" & i, False))
		Next 
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtConnectionAttempts.CtlText = GetServerSetting("ConnectionAttempts", False)
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtMaxArticleAge.CtlText = m_MaxArticleAge
		If m_MaxArticleAge = 0 Then
			m_MaxArticleAge = 30
		End If
		
	End Sub
	
	''
	Public Sub LoadSettings()
		Dim i As Integer
		
		m_TempDownloadPath = GetServerSetting("TempDownloadPath", False)
		
		m_ServerName = GetServerSetting("NewsServer", False)
		m_UserName = GetServerSetting("UserName", False)
		m_Password = GetServerSetting("Password", False)
		
		m_BackupServerName = GetServerSetting("BackupNewsServer", False)
		m_BackupUserName = GetServerSetting("BackupUserName", False)
		m_BackupPassword = GetServerSetting("BackupPassword", False)
		
		If GetServerSetting("StartPars", False) = "True" Then
			m_StartPars = System.Windows.Forms.CheckState.Checked
		Else
			m_StartPars = System.Windows.Forms.CheckState.Unchecked
		End If
		
		If GetServerSetting("UseAlternateServer", False) = "True" Then
			m_UseAlternateServer = True
		Else
			m_UseAlternateServer = False
		End If
		
		If GetServerSetting("StatusVisible", False) = "True" Then
			m_StatusVisible = True
		Else
			m_StatusVisible = False
		End If
		
		If GetServerSetting("AutoDownloadJPG", False) = "True" Then
			m_AutoDownloadJPG = True
		Else
			m_AutoDownloadJPG = False
		End If
		If GetServerSetting("FilterXVID", False) = "True" Then
			m_FilterXVID = True
		Else
			m_FilterXVID = False
		End If
		If GetServerSetting("FilterSVCD", False) = "True" Then
			m_FilterSVCD = True
		Else
			m_FilterSVCD = False
		End If
		
		
		m_jpgPath = GetServerSetting("JPGPath", False)
		m_Database = GetServerSetting("DatabasePath", False)
		
		For i = 0 To 22
			If Val(GetServerSetting("Schedule" & i, False)) = 1 Then
				m_schedule(i) = True
			Else
				m_schedule(i) = False
			End If
		Next 
		
		For i = 0 To 22
			If Val(GetServerSetting("Download" & i, False)) = 1 Then
				m_Download(i) = True
			Else
				m_Download(i) = False
			End If
		Next 
		
		m_ConnectionAttempts = Val(GetServerSetting("ConnectionAttempts", False))
		m_MaxArticleAge = Val(GetServerSetting("MaxArticleAge", False))
		If m_MaxArticleAge = 0 Then
			m_MaxArticleAge = 30
		End If
		
	End Sub
	
	''
	Private Sub FRMOptions_FormClosed(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
		Call GetWindowPosition(Me)
	End Sub
End Class