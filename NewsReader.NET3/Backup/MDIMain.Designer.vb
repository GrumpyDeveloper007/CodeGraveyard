<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class MDIMain
#Region "Windows Form Designer generated code "
	<System.Diagnostics.DebuggerNonUserCode()> Public Sub New()
		MyBase.New()
		'This call is required by the Windows Form Designer.
		InitializeComponent()
	End Sub
	'Form overrides dispose to clean up the component list.
	<System.Diagnostics.DebuggerNonUserCode()> Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
		If Disposing Then
			If Not components Is Nothing Then
				components.Dispose()
			End If
		End If
		MyBase.Dispose(Disposing)
	End Sub
	'Required by the Windows Form Designer
	Private components As System.ComponentModel.IContainer
	Public ToolTip1 As System.Windows.Forms.ToolTip
	Public WithEvents MNUCompactDB As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuCompactStore As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUAbout As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNULogin As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUBlank1 As System.Windows.Forms.ToolStripSeparator
	Public WithEvents MNUExit As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUFile As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUGetAllGroups As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUAddRemoveGroups As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUBlank3 As System.Windows.Forms.ToolStripSeparator
	Public WithEvents _mnuGroupType_0 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuSelectedGroupType As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuSelected_0 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuSelectedGroups As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUBlank2 As System.Windows.Forms.ToolStripSeparator
	Public WithEvents mnuAutoHine As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUGetNewArticles As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUViewFiles As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUDownloadFiles As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUClearDownloading As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuBlank6 As System.Windows.Forms.ToolStripSeparator
	Public WithEvents _mnuThreads_0 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_1 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_2 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_3 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_4 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_5 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_6 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_7 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_8 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_9 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_10 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_11 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_12 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_13 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents _mnuThreads_14 As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuThreadsGroup As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuBlank7 As System.Windows.Forms.ToolStripSeparator
	Public WithEvents mnuGetAlternateServerArticles As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuGetAlternateServerFiles As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUNewsReader As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUOptions As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuPictureIgnoreList As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUConfig As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MNUWindow As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MainMenu1 As System.Windows.Forms.MenuStrip
	Public WithEvents CBOGroupType As System.Windows.Forms.ComboBox
	Public WithEvents _LBLProgress_7 As System.Windows.Forms.Label
	Public WithEvents _LBLProgress_6 As System.Windows.Forms.Label
	Public WithEvents _LBLProgress_5 As System.Windows.Forms.Label
	Public WithEvents _LBLProgress_4 As System.Windows.Forms.Label
	Public WithEvents _LBLProgress_3 As System.Windows.Forms.Label
	Public WithEvents lblBytesTotal As System.Windows.Forms.Label
	Public WithEvents _LBLPacketNumber_2 As System.Windows.Forms.Label
	Public WithEvents _LBLProgress_2 As System.Windows.Forms.Label
	Public WithEvents _LBLPacketNumber_1 As System.Windows.Forms.Label
	Public WithEvents _LBLProgress_1 As System.Windows.Forms.Label
	Public WithEvents _LBLPacketNumber_0 As System.Windows.Forms.Label
	Public WithEvents LBLTransfer As System.Windows.Forms.Label
	Public WithEvents _LBLProgress_0 As System.Windows.Forms.Label
	Public WithEvents LBLAction As System.Windows.Forms.Label
	Public WithEvents PicStatusBar As System.Windows.Forms.Panel
	Public WithEvents PICBackground As System.Windows.Forms.PictureBox
	Public WithEvents CommonDialogControl As CommonDialog
	Public WithEvents Picture2 As System.Windows.Forms.PictureBox
	Public WithEvents LBLPacketNumber As Microsoft.VisualBasic.Compatibility.VB6.LabelArray
	Public WithEvents LBLProgress As Microsoft.VisualBasic.Compatibility.VB6.LabelArray
	Public WithEvents mnuGroupType As Microsoft.VisualBasic.Compatibility.VB6.ToolStripMenuItemArray
	Public WithEvents mnuSelected As Microsoft.VisualBasic.Compatibility.VB6.ToolStripMenuItemArray
	Public WithEvents mnuThreads As Microsoft.VisualBasic.Compatibility.VB6.ToolStripMenuItemArray
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(MDIMain))
		Me.IsMDIContainer = True
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.MainMenu1 = New System.Windows.Forms.MenuStrip
		Me.MNUFile = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUCompactDB = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuCompactStore = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUAbout = New System.Windows.Forms.ToolStripMenuItem
		Me.MNULogin = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUBlank1 = New System.Windows.Forms.ToolStripSeparator
		Me.MNUExit = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUNewsReader = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUGetAllGroups = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUAddRemoveGroups = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUBlank3 = New System.Windows.Forms.ToolStripSeparator
		Me.mnuSelectedGroupType = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuGroupType_0 = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuSelectedGroups = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuSelected_0 = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUBlank2 = New System.Windows.Forms.ToolStripSeparator
		Me.mnuAutoHine = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUGetNewArticles = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUViewFiles = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUDownloadFiles = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUClearDownloading = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuBlank6 = New System.Windows.Forms.ToolStripSeparator
		Me.mnuThreadsGroup = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_0 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_1 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_2 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_3 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_4 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_5 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_6 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_7 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_8 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_9 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_10 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_11 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_12 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_13 = New System.Windows.Forms.ToolStripMenuItem
		Me._mnuThreads_14 = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuBlank7 = New System.Windows.Forms.ToolStripSeparator
		Me.mnuGetAlternateServerArticles = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuGetAlternateServerFiles = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUConfig = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUOptions = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuPictureIgnoreList = New System.Windows.Forms.ToolStripMenuItem
		Me.MNUWindow = New System.Windows.Forms.ToolStripMenuItem
		Me.PicStatusBar = New System.Windows.Forms.Panel
		Me.CBOGroupType = New System.Windows.Forms.ComboBox
		Me._LBLProgress_7 = New System.Windows.Forms.Label
		Me._LBLProgress_6 = New System.Windows.Forms.Label
		Me._LBLProgress_5 = New System.Windows.Forms.Label
		Me._LBLProgress_4 = New System.Windows.Forms.Label
		Me._LBLProgress_3 = New System.Windows.Forms.Label
		Me.lblBytesTotal = New System.Windows.Forms.Label
		Me._LBLPacketNumber_2 = New System.Windows.Forms.Label
		Me._LBLProgress_2 = New System.Windows.Forms.Label
		Me._LBLPacketNumber_1 = New System.Windows.Forms.Label
		Me._LBLProgress_1 = New System.Windows.Forms.Label
		Me._LBLPacketNumber_0 = New System.Windows.Forms.Label
		Me.LBLTransfer = New System.Windows.Forms.Label
		Me._LBLProgress_0 = New System.Windows.Forms.Label
		Me.LBLAction = New System.Windows.Forms.Label
		Me.PICBackground = New System.Windows.Forms.PictureBox
		Me.CommonDialogControl = New CommonDialog
		Me.Picture2 = New System.Windows.Forms.PictureBox
		Me.LBLPacketNumber = New Microsoft.VisualBasic.Compatibility.VB6.LabelArray(components)
		Me.LBLProgress = New Microsoft.VisualBasic.Compatibility.VB6.LabelArray(components)
		Me.mnuGroupType = New Microsoft.VisualBasic.Compatibility.VB6.ToolStripMenuItemArray(components)
		Me.mnuSelected = New Microsoft.VisualBasic.Compatibility.VB6.ToolStripMenuItemArray(components)
		Me.mnuThreads = New Microsoft.VisualBasic.Compatibility.VB6.ToolStripMenuItemArray(components)
		Me.MainMenu1.SuspendLayout()
		Me.PicStatusBar.SuspendLayout()
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		CType(Me.LBLPacketNumber, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.LBLProgress, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.mnuGroupType, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.mnuSelected, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.mnuThreads, System.ComponentModel.ISupportInitialize).BeginInit()
		Me.BackColor = System.Drawing.SystemColors.AppWorkspace
		Me.Text = "<Project name is stored in global declarations> <Version Number>"
		Me.ClientSize = New System.Drawing.Size(1016, 533)
		Me.Location = New System.Drawing.Point(11, 30)
		Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
		Me.Enabled = True
		Me.Cursor = System.Windows.Forms.Cursors.Default
		Me.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.WindowState = System.Windows.Forms.FormWindowState.Normal
		Me.Name = "MDIMain"
		Me.MNUFile.Name = "MNUFile"
		Me.MNUFile.Text = "File"
		Me.MNUFile.Checked = False
		Me.MNUFile.Enabled = True
		Me.MNUFile.Visible = True
		Me.MNUCompactDB.Name = "MNUCompactDB"
		Me.MNUCompactDB.Text = "Compact DB"
		Me.MNUCompactDB.Checked = False
		Me.MNUCompactDB.Enabled = True
		Me.MNUCompactDB.Visible = True
		Me.mnuCompactStore.Name = "mnuCompactStore"
		Me.mnuCompactStore.Text = "Compact Article Store"
		Me.mnuCompactStore.Checked = False
		Me.mnuCompactStore.Enabled = True
		Me.mnuCompactStore.Visible = True
		Me.MNUAbout.Name = "MNUAbout"
		Me.MNUAbout.Text = "About"
		Me.MNUAbout.Visible = False
		Me.MNUAbout.Checked = False
		Me.MNUAbout.Enabled = True
		Me.MNULogin.Name = "MNULogin"
		Me.MNULogin.Text = "Login"
		Me.MNULogin.Visible = False
		Me.MNULogin.Checked = False
		Me.MNULogin.Enabled = True
		Me.MNUBlank1.Enabled = True
		Me.MNUBlank1.Visible = True
		Me.MNUBlank1.Name = "MNUBlank1"
		Me.MNUExit.Name = "MNUExit"
		Me.MNUExit.Text = "E&xit"
		Me.MNUExit.Checked = False
		Me.MNUExit.Enabled = True
		Me.MNUExit.Visible = True
		Me.MNUNewsReader.Name = "MNUNewsReader"
		Me.MNUNewsReader.Text = "News Reader"
		Me.MNUNewsReader.Checked = False
		Me.MNUNewsReader.Enabled = True
		Me.MNUNewsReader.Visible = True
		Me.MNUGetAllGroups.Name = "MNUGetAllGroups"
		Me.MNUGetAllGroups.Text = "Get All Groups"
		Me.MNUGetAllGroups.Checked = False
		Me.MNUGetAllGroups.Enabled = True
		Me.MNUGetAllGroups.Visible = True
		Me.MNUAddRemoveGroups.Name = "MNUAddRemoveGroups"
		Me.MNUAddRemoveGroups.Text = "Add/Remove Groups"
		Me.MNUAddRemoveGroups.Checked = False
		Me.MNUAddRemoveGroups.Enabled = True
		Me.MNUAddRemoveGroups.Visible = True
		Me.MNUBlank3.Enabled = True
		Me.MNUBlank3.Visible = True
		Me.MNUBlank3.Name = "MNUBlank3"
		Me.mnuSelectedGroupType.Name = "mnuSelectedGroupType"
		Me.mnuSelectedGroupType.Text = "<>"
		Me.mnuSelectedGroupType.Checked = False
		Me.mnuSelectedGroupType.Enabled = True
		Me.mnuSelectedGroupType.Visible = True
		Me._mnuGroupType_0.Name = "_mnuGroupType_0"
		Me._mnuGroupType_0.Text = "<Availible Group Types>"
		Me._mnuGroupType_0.Checked = False
		Me._mnuGroupType_0.Enabled = True
		Me._mnuGroupType_0.Visible = True
		Me.mnuSelectedGroups.Name = "mnuSelectedGroups"
		Me.mnuSelectedGroups.Text = "Selected Groups"
		Me.mnuSelectedGroups.Checked = False
		Me.mnuSelectedGroups.Enabled = True
		Me.mnuSelectedGroups.Visible = True
		Me._mnuSelected_0.Name = "_mnuSelected_0"
		Me._mnuSelected_0.Text = "<Availible News Groups>"
		Me._mnuSelected_0.Checked = False
		Me._mnuSelected_0.Enabled = True
		Me._mnuSelected_0.Visible = True
		Me.MNUBlank2.Enabled = True
		Me.MNUBlank2.Visible = True
		Me.MNUBlank2.Name = "MNUBlank2"
		Me.mnuAutoHine.Name = "mnuAutoHine"
		Me.mnuAutoHine.Text = "AutoHide"
		Me.mnuAutoHine.Checked = False
		Me.mnuAutoHine.Enabled = True
		Me.mnuAutoHine.Visible = True
		Me.MNUGetNewArticles.Name = "MNUGetNewArticles"
		Me.MNUGetNewArticles.Text = "Get New Articles"
		Me.MNUGetNewArticles.Checked = False
		Me.MNUGetNewArticles.Enabled = True
		Me.MNUGetNewArticles.Visible = True
		Me.MNUViewFiles.Name = "MNUViewFiles"
		Me.MNUViewFiles.Text = "View Files"
		Me.MNUViewFiles.Checked = False
		Me.MNUViewFiles.Enabled = True
		Me.MNUViewFiles.Visible = True
		Me.MNUDownloadFiles.Name = "MNUDownloadFiles"
		Me.MNUDownloadFiles.Text = "Download Files"
		Me.MNUDownloadFiles.Checked = False
		Me.MNUDownloadFiles.Enabled = True
		Me.MNUDownloadFiles.Visible = True
		Me.MNUClearDownloading.Name = "MNUClearDownloading"
		Me.MNUClearDownloading.Text = "Clear Downloading"
		Me.MNUClearDownloading.Checked = False
		Me.MNUClearDownloading.Enabled = True
		Me.MNUClearDownloading.Visible = True
		Me.mnuBlank6.Enabled = True
		Me.mnuBlank6.Visible = True
		Me.mnuBlank6.Name = "mnuBlank6"
		Me.mnuThreadsGroup.Name = "mnuThreadsGroup"
		Me.mnuThreadsGroup.Text = "Threads"
		Me.mnuThreadsGroup.Checked = False
		Me.mnuThreadsGroup.Enabled = True
		Me.mnuThreadsGroup.Visible = True
		Me._mnuThreads_0.Name = "_mnuThreads_0"
		Me._mnuThreads_0.Text = "1"
		Me._mnuThreads_0.Checked = False
		Me._mnuThreads_0.Enabled = True
		Me._mnuThreads_0.Visible = True
		Me._mnuThreads_1.Name = "_mnuThreads_1"
		Me._mnuThreads_1.Text = "2"
		Me._mnuThreads_1.Checked = False
		Me._mnuThreads_1.Enabled = True
		Me._mnuThreads_1.Visible = True
		Me._mnuThreads_2.Name = "_mnuThreads_2"
		Me._mnuThreads_2.Text = "3"
		Me._mnuThreads_2.Checked = True
		Me._mnuThreads_2.Enabled = True
		Me._mnuThreads_2.Visible = True
		Me._mnuThreads_3.Name = "_mnuThreads_3"
		Me._mnuThreads_3.Text = "4"
		Me._mnuThreads_3.Checked = False
		Me._mnuThreads_3.Enabled = True
		Me._mnuThreads_3.Visible = True
		Me._mnuThreads_4.Name = "_mnuThreads_4"
		Me._mnuThreads_4.Text = "5"
		Me._mnuThreads_4.Checked = False
		Me._mnuThreads_4.Enabled = True
		Me._mnuThreads_4.Visible = True
		Me._mnuThreads_5.Name = "_mnuThreads_5"
		Me._mnuThreads_5.Text = "6"
		Me._mnuThreads_5.Checked = False
		Me._mnuThreads_5.Enabled = True
		Me._mnuThreads_5.Visible = True
		Me._mnuThreads_6.Name = "_mnuThreads_6"
		Me._mnuThreads_6.Text = "7"
		Me._mnuThreads_6.Checked = False
		Me._mnuThreads_6.Enabled = True
		Me._mnuThreads_6.Visible = True
		Me._mnuThreads_7.Name = "_mnuThreads_7"
		Me._mnuThreads_7.Text = "8"
		Me._mnuThreads_7.Checked = False
		Me._mnuThreads_7.Enabled = True
		Me._mnuThreads_7.Visible = True
		Me._mnuThreads_8.Name = "_mnuThreads_8"
		Me._mnuThreads_8.Text = "9"
		Me._mnuThreads_8.Visible = False
		Me._mnuThreads_8.Checked = False
		Me._mnuThreads_8.Enabled = True
		Me._mnuThreads_9.Name = "_mnuThreads_9"
		Me._mnuThreads_9.Text = "10"
		Me._mnuThreads_9.Visible = False
		Me._mnuThreads_9.Checked = False
		Me._mnuThreads_9.Enabled = True
		Me._mnuThreads_10.Name = "_mnuThreads_10"
		Me._mnuThreads_10.Text = "11"
		Me._mnuThreads_10.Visible = False
		Me._mnuThreads_10.Checked = False
		Me._mnuThreads_10.Enabled = True
		Me._mnuThreads_11.Name = "_mnuThreads_11"
		Me._mnuThreads_11.Text = "12"
		Me._mnuThreads_11.Visible = False
		Me._mnuThreads_11.Checked = False
		Me._mnuThreads_11.Enabled = True
		Me._mnuThreads_12.Name = "_mnuThreads_12"
		Me._mnuThreads_12.Text = "13"
		Me._mnuThreads_12.Visible = False
		Me._mnuThreads_12.Checked = False
		Me._mnuThreads_12.Enabled = True
		Me._mnuThreads_13.Name = "_mnuThreads_13"
		Me._mnuThreads_13.Text = "14"
		Me._mnuThreads_13.Visible = False
		Me._mnuThreads_13.Checked = False
		Me._mnuThreads_13.Enabled = True
		Me._mnuThreads_14.Name = "_mnuThreads_14"
		Me._mnuThreads_14.Text = "15"
		Me._mnuThreads_14.Visible = False
		Me._mnuThreads_14.Checked = False
		Me._mnuThreads_14.Enabled = True
		Me.mnuBlank7.Visible = False
		Me.mnuBlank7.Enabled = True
		Me.mnuBlank7.Name = "mnuBlank7"
		Me.mnuGetAlternateServerArticles.Name = "mnuGetAlternateServerArticles"
		Me.mnuGetAlternateServerArticles.Text = "Get Alternate Server Articles"
		Me.mnuGetAlternateServerArticles.Visible = False
		Me.mnuGetAlternateServerArticles.Checked = False
		Me.mnuGetAlternateServerArticles.Enabled = True
		Me.mnuGetAlternateServerFiles.Name = "mnuGetAlternateServerFiles"
		Me.mnuGetAlternateServerFiles.Text = "Get Alternate Server Files"
		Me.mnuGetAlternateServerFiles.Visible = False
		Me.mnuGetAlternateServerFiles.Checked = False
		Me.mnuGetAlternateServerFiles.Enabled = True
		Me.MNUConfig.Name = "MNUConfig"
		Me.MNUConfig.Text = "&Config"
		Me.MNUConfig.Checked = False
		Me.MNUConfig.Enabled = True
		Me.MNUConfig.Visible = True
		Me.MNUOptions.Name = "MNUOptions"
		Me.MNUOptions.Text = "Options"
		Me.MNUOptions.ShortcutKeys = CType(System.Windows.Forms.Keys.F7, System.Windows.Forms.Keys)
		Me.MNUOptions.Checked = False
		Me.MNUOptions.Enabled = True
		Me.MNUOptions.Visible = True
		Me.mnuPictureIgnoreList.Name = "mnuPictureIgnoreList"
		Me.mnuPictureIgnoreList.Text = "Picture Ignore List"
		Me.mnuPictureIgnoreList.Checked = False
		Me.mnuPictureIgnoreList.Enabled = True
		Me.mnuPictureIgnoreList.Visible = True
		Me.MNUWindow.Name = "MNUWindow"
		Me.MNUWindow.Text = "&Window"
		Me.MNUWindow.Checked = False
		Me.MNUWindow.Enabled = True
		Me.MNUWindow.Visible = True
		Me.PicStatusBar.Dock = System.Windows.Forms.DockStyle.Top
		Me.PicStatusBar.Size = New System.Drawing.Size(1016, 65)
		Me.PicStatusBar.Location = New System.Drawing.Point(0, 24)
		Me.PicStatusBar.TabIndex = 1
		Me.PicStatusBar.BackColor = System.Drawing.SystemColors.Control
		Me.PicStatusBar.CausesValidation = True
		Me.PicStatusBar.Enabled = True
		Me.PicStatusBar.ForeColor = System.Drawing.SystemColors.ControlText
		Me.PicStatusBar.Cursor = System.Windows.Forms.Cursors.Default
		Me.PicStatusBar.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.PicStatusBar.TabStop = True
		Me.PicStatusBar.Visible = True
		Me.PicStatusBar.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.PicStatusBar.Name = "PicStatusBar"
		Me.CBOGroupType.Size = New System.Drawing.Size(169, 21)
		Me.CBOGroupType.Location = New System.Drawing.Point(776, 28)
		Me.CBOGroupType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
		Me.CBOGroupType.TabIndex = 11
		Me.CBOGroupType.Visible = False
		Me.CBOGroupType.BackColor = System.Drawing.SystemColors.Window
		Me.CBOGroupType.CausesValidation = True
		Me.CBOGroupType.Enabled = True
		Me.CBOGroupType.ForeColor = System.Drawing.SystemColors.WindowText
		Me.CBOGroupType.IntegralHeight = True
		Me.CBOGroupType.Cursor = System.Windows.Forms.Cursors.Default
		Me.CBOGroupType.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CBOGroupType.Sorted = False
		Me.CBOGroupType.TabStop = True
		Me.CBOGroupType.Name = "CBOGroupType"
		Me._LBLProgress_7.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLProgress_7.Text = "<Progress>"
		Me._LBLProgress_7.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLProgress_7.Size = New System.Drawing.Size(240, 16)
		Me._LBLProgress_7.Location = New System.Drawing.Point(744, 44)
		Me._LBLProgress_7.TabIndex = 17
		Me._LBLProgress_7.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLProgress_7.Enabled = True
		Me._LBLProgress_7.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLProgress_7.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLProgress_7.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLProgress_7.UseMnemonic = True
		Me._LBLProgress_7.Visible = True
		Me._LBLProgress_7.AutoSize = False
		Me._LBLProgress_7.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLProgress_7.Name = "_LBLProgress_7"
		Me._LBLProgress_6.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLProgress_6.Text = "<Progress>"
		Me._LBLProgress_6.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLProgress_6.Size = New System.Drawing.Size(240, 16)
		Me._LBLProgress_6.Location = New System.Drawing.Point(496, 44)
		Me._LBLProgress_6.TabIndex = 16
		Me._LBLProgress_6.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLProgress_6.Enabled = True
		Me._LBLProgress_6.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLProgress_6.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLProgress_6.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLProgress_6.UseMnemonic = True
		Me._LBLProgress_6.Visible = True
		Me._LBLProgress_6.AutoSize = False
		Me._LBLProgress_6.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLProgress_6.Name = "_LBLProgress_6"
		Me._LBLProgress_5.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLProgress_5.Text = "<Progress>"
		Me._LBLProgress_5.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLProgress_5.Size = New System.Drawing.Size(240, 16)
		Me._LBLProgress_5.Location = New System.Drawing.Point(248, 44)
		Me._LBLProgress_5.TabIndex = 15
		Me._LBLProgress_5.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLProgress_5.Enabled = True
		Me._LBLProgress_5.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLProgress_5.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLProgress_5.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLProgress_5.UseMnemonic = True
		Me._LBLProgress_5.Visible = True
		Me._LBLProgress_5.AutoSize = False
		Me._LBLProgress_5.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLProgress_5.Name = "_LBLProgress_5"
		Me._LBLProgress_4.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLProgress_4.Text = "<Progress>"
		Me._LBLProgress_4.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLProgress_4.Size = New System.Drawing.Size(240, 16)
		Me._LBLProgress_4.Location = New System.Drawing.Point(0, 44)
		Me._LBLProgress_4.TabIndex = 14
		Me._LBLProgress_4.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLProgress_4.Enabled = True
		Me._LBLProgress_4.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLProgress_4.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLProgress_4.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLProgress_4.UseMnemonic = True
		Me._LBLProgress_4.Visible = True
		Me._LBLProgress_4.AutoSize = False
		Me._LBLProgress_4.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLProgress_4.Name = "_LBLProgress_4"
		Me._LBLProgress_3.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLProgress_3.Text = "<Progress>"
		Me._LBLProgress_3.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLProgress_3.Size = New System.Drawing.Size(240, 16)
		Me._LBLProgress_3.Location = New System.Drawing.Point(744, 21)
		Me._LBLProgress_3.TabIndex = 13
		Me._LBLProgress_3.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLProgress_3.Enabled = True
		Me._LBLProgress_3.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLProgress_3.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLProgress_3.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLProgress_3.UseMnemonic = True
		Me._LBLProgress_3.Visible = True
		Me._LBLProgress_3.AutoSize = False
		Me._LBLProgress_3.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLProgress_3.Name = "_LBLProgress_3"
		Me.lblBytesTotal.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me.lblBytesTotal.Text = "<Bytes Total>"
		Me.lblBytesTotal.Font = New System.Drawing.Font("Arial", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.lblBytesTotal.Size = New System.Drawing.Size(121, 16)
		Me.lblBytesTotal.Location = New System.Drawing.Point(752, 0)
		Me.lblBytesTotal.TabIndex = 12
		Me.lblBytesTotal.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.lblBytesTotal.Enabled = True
		Me.lblBytesTotal.ForeColor = System.Drawing.SystemColors.ControlText
		Me.lblBytesTotal.Cursor = System.Windows.Forms.Cursors.Default
		Me.lblBytesTotal.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.lblBytesTotal.UseMnemonic = True
		Me.lblBytesTotal.Visible = True
		Me.lblBytesTotal.AutoSize = False
		Me.lblBytesTotal.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.lblBytesTotal.Name = "lblBytesTotal"
		Me._LBLPacketNumber_2.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLPacketNumber_2.Text = "<Packet Number>"
		Me._LBLPacketNumber_2.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLPacketNumber_2.Size = New System.Drawing.Size(88, 15)
		Me._LBLPacketNumber_2.Location = New System.Drawing.Point(657, 2)
		Me._LBLPacketNumber_2.TabIndex = 10
		Me._LBLPacketNumber_2.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLPacketNumber_2.Enabled = True
		Me._LBLPacketNumber_2.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLPacketNumber_2.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLPacketNumber_2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLPacketNumber_2.UseMnemonic = True
		Me._LBLPacketNumber_2.Visible = True
		Me._LBLPacketNumber_2.AutoSize = False
		Me._LBLPacketNumber_2.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLPacketNumber_2.Name = "_LBLPacketNumber_2"
		Me._LBLProgress_2.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLProgress_2.Text = "<Progress>"
		Me._LBLProgress_2.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLProgress_2.Size = New System.Drawing.Size(240, 16)
		Me._LBLProgress_2.Location = New System.Drawing.Point(496, 21)
		Me._LBLProgress_2.TabIndex = 9
		Me._LBLProgress_2.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLProgress_2.Enabled = True
		Me._LBLProgress_2.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLProgress_2.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLProgress_2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLProgress_2.UseMnemonic = True
		Me._LBLProgress_2.Visible = True
		Me._LBLProgress_2.AutoSize = False
		Me._LBLProgress_2.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLProgress_2.Name = "_LBLProgress_2"
		Me._LBLPacketNumber_1.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLPacketNumber_1.Text = "<Packet Number>"
		Me._LBLPacketNumber_1.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLPacketNumber_1.Size = New System.Drawing.Size(88, 15)
		Me._LBLPacketNumber_1.Location = New System.Drawing.Point(560, 2)
		Me._LBLPacketNumber_1.TabIndex = 8
		Me._LBLPacketNumber_1.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLPacketNumber_1.Enabled = True
		Me._LBLPacketNumber_1.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLPacketNumber_1.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLPacketNumber_1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLPacketNumber_1.UseMnemonic = True
		Me._LBLPacketNumber_1.Visible = True
		Me._LBLPacketNumber_1.AutoSize = False
		Me._LBLPacketNumber_1.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLPacketNumber_1.Name = "_LBLPacketNumber_1"
		Me._LBLProgress_1.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLProgress_1.Text = "<Progress>"
		Me._LBLProgress_1.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLProgress_1.Size = New System.Drawing.Size(240, 16)
		Me._LBLProgress_1.Location = New System.Drawing.Point(248, 21)
		Me._LBLProgress_1.TabIndex = 6
		Me._LBLProgress_1.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLProgress_1.Enabled = True
		Me._LBLProgress_1.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLProgress_1.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLProgress_1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLProgress_1.UseMnemonic = True
		Me._LBLProgress_1.Visible = True
		Me._LBLProgress_1.AutoSize = False
		Me._LBLProgress_1.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLProgress_1.Name = "_LBLProgress_1"
		Me._LBLPacketNumber_0.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLPacketNumber_0.Text = "<Packet Number>"
		Me._LBLPacketNumber_0.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLPacketNumber_0.Size = New System.Drawing.Size(88, 15)
		Me._LBLPacketNumber_0.Location = New System.Drawing.Point(464, 2)
		Me._LBLPacketNumber_0.TabIndex = 5
		Me._LBLPacketNumber_0.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLPacketNumber_0.Enabled = True
		Me._LBLPacketNumber_0.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLPacketNumber_0.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLPacketNumber_0.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLPacketNumber_0.UseMnemonic = True
		Me._LBLPacketNumber_0.Visible = True
		Me._LBLPacketNumber_0.AutoSize = False
		Me._LBLPacketNumber_0.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLPacketNumber_0.Name = "_LBLPacketNumber_0"
		Me.LBLTransfer.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me.LBLTransfer.Text = "<Transfer>"
		Me.LBLTransfer.Font = New System.Drawing.Font("Arial", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.LBLTransfer.Size = New System.Drawing.Size(129, 16)
		Me.LBLTransfer.Location = New System.Drawing.Point(883, 2)
		Me.LBLTransfer.TabIndex = 4
		Me.LBLTransfer.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.LBLTransfer.Enabled = True
		Me.LBLTransfer.ForeColor = System.Drawing.SystemColors.ControlText
		Me.LBLTransfer.Cursor = System.Windows.Forms.Cursors.Default
		Me.LBLTransfer.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.LBLTransfer.UseMnemonic = True
		Me.LBLTransfer.Visible = True
		Me.LBLTransfer.AutoSize = False
		Me.LBLTransfer.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.LBLTransfer.Name = "LBLTransfer"
		Me._LBLProgress_0.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me._LBLProgress_0.Text = "<Progress>"
		Me._LBLProgress_0.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLProgress_0.Size = New System.Drawing.Size(240, 16)
		Me._LBLProgress_0.Location = New System.Drawing.Point(0, 21)
		Me._LBLProgress_0.TabIndex = 3
		Me._LBLProgress_0.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._LBLProgress_0.Enabled = True
		Me._LBLProgress_0.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLProgress_0.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLProgress_0.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLProgress_0.UseMnemonic = True
		Me._LBLProgress_0.Visible = True
		Me._LBLProgress_0.AutoSize = False
		Me._LBLProgress_0.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLProgress_0.Name = "_LBLProgress_0"
		Me.LBLAction.BackColor = System.Drawing.Color.FromARGB(192, 192, 192)
		Me.LBLAction.Text = "<Action>"
		Me.LBLAction.Font = New System.Drawing.Font("Arial", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.LBLAction.Size = New System.Drawing.Size(464, 15)
		Me.LBLAction.Location = New System.Drawing.Point(0, 2)
		Me.LBLAction.TabIndex = 2
		Me.LBLAction.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.LBLAction.Enabled = True
		Me.LBLAction.ForeColor = System.Drawing.SystemColors.ControlText
		Me.LBLAction.Cursor = System.Windows.Forms.Cursors.Default
		Me.LBLAction.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.LBLAction.UseMnemonic = True
		Me.LBLAction.Visible = True
		Me.LBLAction.AutoSize = False
		Me.LBLAction.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.LBLAction.Name = "LBLAction"
		Me.PICBackground.Dock = System.Windows.Forms.DockStyle.Bottom
		Me.PICBackground.Size = New System.Drawing.Size(1016, 65)
		Me.PICBackground.Location = New System.Drawing.Point(0, 468)
		Me.PICBackground.TabIndex = 0
		Me.PICBackground.Visible = False
		Me.PICBackground.BackColor = System.Drawing.SystemColors.Control
		Me.PICBackground.CausesValidation = True
		Me.PICBackground.Enabled = True
		Me.PICBackground.ForeColor = System.Drawing.SystemColors.ControlText
		Me.PICBackground.Cursor = System.Windows.Forms.Cursors.Default
		Me.PICBackground.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.PICBackground.TabStop = True
		Me.PICBackground.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
		Me.PICBackground.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.PICBackground.Name = "PICBackground"
		Me.CommonDialogControl.Name = "CommonDialogControl"
		Me.Picture2.Dock = System.Windows.Forms.DockStyle.Top
		Me.Picture2.Size = New System.Drawing.Size(1016, 0)
		Me.Picture2.Location = New System.Drawing.Point(0, 89)
		Me.Picture2.TabIndex = 7
		Me.Picture2.BackColor = System.Drawing.SystemColors.Control
		Me.Picture2.CausesValidation = True
		Me.Picture2.Enabled = True
		Me.Picture2.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Picture2.Cursor = System.Windows.Forms.Cursors.Default
		Me.Picture2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Picture2.TabStop = True
		Me.Picture2.Visible = True
		Me.Picture2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
		Me.Picture2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.Picture2.Name = "Picture2"
		Me.Controls.Add(PicStatusBar)
		Me.Controls.Add(PICBackground)
		Me.Controls.Add(CommonDialogControl)
		Me.Controls.Add(Picture2)
		Me.PicStatusBar.Controls.Add(CBOGroupType)
		Me.PicStatusBar.Controls.Add(_LBLProgress_7)
		Me.PicStatusBar.Controls.Add(_LBLProgress_6)
		Me.PicStatusBar.Controls.Add(_LBLProgress_5)
		Me.PicStatusBar.Controls.Add(_LBLProgress_4)
		Me.PicStatusBar.Controls.Add(_LBLProgress_3)
		Me.PicStatusBar.Controls.Add(lblBytesTotal)
		Me.PicStatusBar.Controls.Add(_LBLPacketNumber_2)
		Me.PicStatusBar.Controls.Add(_LBLProgress_2)
		Me.PicStatusBar.Controls.Add(_LBLPacketNumber_1)
		Me.PicStatusBar.Controls.Add(_LBLProgress_1)
		Me.PicStatusBar.Controls.Add(_LBLPacketNumber_0)
		Me.PicStatusBar.Controls.Add(LBLTransfer)
		Me.PicStatusBar.Controls.Add(_LBLProgress_0)
		Me.PicStatusBar.Controls.Add(LBLAction)
		Me.LBLPacketNumber.SetIndex(_LBLPacketNumber_2, CType(2, Short))
		Me.LBLPacketNumber.SetIndex(_LBLPacketNumber_1, CType(1, Short))
		Me.LBLPacketNumber.SetIndex(_LBLPacketNumber_0, CType(0, Short))
		Me.LBLProgress.SetIndex(_LBLProgress_7, CType(7, Short))
		Me.LBLProgress.SetIndex(_LBLProgress_6, CType(6, Short))
		Me.LBLProgress.SetIndex(_LBLProgress_5, CType(5, Short))
		Me.LBLProgress.SetIndex(_LBLProgress_4, CType(4, Short))
		Me.LBLProgress.SetIndex(_LBLProgress_3, CType(3, Short))
		Me.LBLProgress.SetIndex(_LBLProgress_2, CType(2, Short))
		Me.LBLProgress.SetIndex(_LBLProgress_1, CType(1, Short))
		Me.LBLProgress.SetIndex(_LBLProgress_0, CType(0, Short))
		Me.mnuGroupType.SetIndex(_mnuGroupType_0, CType(0, Short))
		Me.mnuSelected.SetIndex(_mnuSelected_0, CType(0, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_0, CType(0, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_1, CType(1, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_2, CType(2, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_3, CType(3, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_4, CType(4, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_5, CType(5, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_6, CType(6, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_7, CType(7, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_8, CType(8, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_9, CType(9, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_10, CType(10, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_11, CType(11, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_12, CType(12, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_13, CType(13, Short))
		Me.mnuThreads.SetIndex(_mnuThreads_14, CType(14, Short))
		CType(Me.mnuThreads, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.mnuSelected, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.mnuGroupType, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.LBLProgress, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.LBLPacketNumber, System.ComponentModel.ISupportInitialize).EndInit()
		Me.MNUFile.MergeAction = System.Windows.Forms.MergeAction.Remove
		Me.MNUNewsReader.MergeAction = System.Windows.Forms.MergeAction.Remove
		Me.MNUConfig.MergeAction = System.Windows.Forms.MergeAction.Remove
		Me.MNUWindow.MergeAction = System.Windows.Forms.MergeAction.Remove
		MainMenu1.Items.AddRange(New System.Windows.Forms.ToolStripItem(){Me.MNUFile, Me.MNUNewsReader, Me.MNUConfig, Me.MNUWindow})
		MNUFile.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem(){Me.MNUCompactDB, Me.mnuCompactStore, Me.MNUAbout, Me.MNULogin, Me.MNUBlank1, Me.MNUExit})
		MNUNewsReader.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem(){Me.MNUGetAllGroups, Me.MNUAddRemoveGroups, Me.MNUBlank3, Me.mnuSelectedGroupType, Me.mnuSelectedGroups, Me.MNUBlank2, Me.mnuAutoHine, Me.MNUGetNewArticles, Me.MNUViewFiles, Me.MNUDownloadFiles, Me.MNUClearDownloading, Me.mnuBlank6, Me.mnuThreadsGroup, Me.mnuBlank7, Me.mnuGetAlternateServerArticles, Me.mnuGetAlternateServerFiles})
		mnuSelectedGroupType.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem(){Me._mnuGroupType_0})
		mnuSelectedGroups.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem(){Me._mnuSelected_0})
		mnuThreadsGroup.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem(){Me._mnuThreads_0, Me._mnuThreads_1, Me._mnuThreads_2, Me._mnuThreads_3, Me._mnuThreads_4, Me._mnuThreads_5, Me._mnuThreads_6, Me._mnuThreads_7, Me._mnuThreads_8, Me._mnuThreads_9, Me._mnuThreads_10, Me._mnuThreads_11, Me._mnuThreads_12, Me._mnuThreads_13, Me._mnuThreads_14})
		MNUConfig.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem(){Me.MNUOptions, Me.mnuPictureIgnoreList})
		Me.Controls.Add(MainMenu1)
		Me.MainMenu1.ResumeLayout(False)
		Me.PicStatusBar.ResumeLayout(False)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class