<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class FRMOptions
#Region "Windows Form Designer generated code "
	<System.Diagnostics.DebuggerNonUserCode()> Public Sub New()
		MyBase.New()
		'This call is required by the Windows Form Designer.
		InitializeComponent()
		'This form is an MDI child.
		'This code simulates the VB6 
		' functionality of automatically
		' loading and showing an MDI
		' child's parent.
		Me.MDIParent = NewsReader.MDIMain
		NewsReader.MDIMain.Show
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
	Public WithEvents chkStatusVisible As System.Windows.Forms.CheckBox
	Public WithEvents txtMaxArticleAge As AxELFTxtBox.AxTxtBox1
	Public WithEvents txtConnectionAttempts As AxELFTxtBox.AxTxtBox1
	Public WithEvents _LBLZ1_8 As System.Windows.Forms.Label
	Public WithEvents _LBLZ1_10 As System.Windows.Forms.Label
	Public WithEvents fraMisc As System.Windows.Forms.GroupBox
	Public WithEvents _chkDownload_22 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_21 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_20 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_19 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_18 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_17 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_16 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_15 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_14 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_13 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_12 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_11 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_10 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_0 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_1 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_2 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_3 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_4 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_5 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_6 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_7 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_8 As System.Windows.Forms.CheckBox
	Public WithEvents _chkDownload_9 As System.Windows.Forms.CheckBox
	Public WithEvents fraDownloading As System.Windows.Forms.GroupBox
	Public WithEvents chkFilterSVCD As System.Windows.Forms.CheckBox
	Public WithEvents chkFilterXVID As System.Windows.Forms.CheckBox
	Public WithEvents chkDownloadNfo As System.Windows.Forms.CheckBox
	Public WithEvents chkAutoDownloadJPG As System.Windows.Forms.CheckBox
	Public WithEvents fraAutoFeatures As System.Windows.Forms.GroupBox
	Public WithEvents chkUseAlternateServer As System.Windows.Forms.CheckBox
	Public WithEvents txtBackupServer As AxELFTxtBox.AxTxtBox1
	Public WithEvents txtBackupUsername As AxELFTxtBox.AxTxtBox1
	Public WithEvents txtBackupPassword As AxELFTxtBox.AxTxtBox1
	Public WithEvents _LBLZ1_7 As System.Windows.Forms.Label
	Public WithEvents _LBLZ1_5 As System.Windows.Forms.Label
	Public WithEvents _LBLZ1_4 As System.Windows.Forms.Label
	Public WithEvents fraAlternateServer As System.Windows.Forms.GroupBox
	Public WithEvents TXTServerName As AxELFTxtBox.AxTxtBox1
	Public WithEvents TXTUserName As AxELFTxtBox.AxTxtBox1
	Public WithEvents TXTPassword As AxELFTxtBox.AxTxtBox1
	Public WithEvents _LBLZ1_3 As System.Windows.Forms.Label
	Public WithEvents _LBLZ1_1 As System.Windows.Forms.Label
	Public WithEvents _LBLZ1_2 As System.Windows.Forms.Label
	Public WithEvents fraPrimaryServer As System.Windows.Forms.GroupBox
	Public WithEvents _chkSchedule_9 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_8 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_7 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_6 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_5 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_4 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_3 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_2 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_1 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_0 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_10 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_11 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_12 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_13 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_14 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_15 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_16 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_17 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_18 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_19 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_20 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_21 As System.Windows.Forms.CheckBox
	Public WithEvents _chkSchedule_22 As System.Windows.Forms.CheckBox
	Public WithEvents chkStartPars As System.Windows.Forms.CheckBox
	Public WithEvents fraSchedule As System.Windows.Forms.GroupBox
	Public WithEvents cmdDatabasePath As System.Windows.Forms.Button
	Public WithEvents cmdPicturePath As System.Windows.Forms.Button
	Public WithEvents cmdTempPath As System.Windows.Forms.Button
	Public WithEvents TXTTempDownloadPath As AxELFTxtBox.AxTxtBox1
	Public WithEvents txtPicturePath As AxELFTxtBox.AxTxtBox1
	Public WithEvents txtDatabasePath As AxELFTxtBox.AxTxtBox1
	Public WithEvents _LBLZ1_9 As System.Windows.Forms.Label
	Public WithEvents _LBLZ1_6 As System.Windows.Forms.Label
	Public WithEvents _LBLZ1_0 As System.Windows.Forms.Label
	Public WithEvents fraDownloadPaths As System.Windows.Forms.GroupBox
	Public WithEvents CMDOK As System.Windows.Forms.Button
	Public WithEvents CMDExit As System.Windows.Forms.Button
	Public WithEvents lblDBInfo As System.Windows.Forms.Label
	Public WithEvents LBLZ1 As Microsoft.VisualBasic.Compatibility.VB6.LabelArray
	Public WithEvents chkDownload As Microsoft.VisualBasic.Compatibility.VB6.CheckBoxArray
	Public WithEvents chkSchedule As Microsoft.VisualBasic.Compatibility.VB6.CheckBoxArray
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(FRMOptions))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.fraMisc = New System.Windows.Forms.GroupBox
		Me.chkStatusVisible = New System.Windows.Forms.CheckBox
		Me.txtMaxArticleAge = New AxELFTxtBox.AxTxtBox1
		Me.txtConnectionAttempts = New AxELFTxtBox.AxTxtBox1
		Me._LBLZ1_8 = New System.Windows.Forms.Label
		Me._LBLZ1_10 = New System.Windows.Forms.Label
		Me.fraDownloading = New System.Windows.Forms.GroupBox
		Me._chkDownload_22 = New System.Windows.Forms.CheckBox
		Me._chkDownload_21 = New System.Windows.Forms.CheckBox
		Me._chkDownload_20 = New System.Windows.Forms.CheckBox
		Me._chkDownload_19 = New System.Windows.Forms.CheckBox
		Me._chkDownload_18 = New System.Windows.Forms.CheckBox
		Me._chkDownload_17 = New System.Windows.Forms.CheckBox
		Me._chkDownload_16 = New System.Windows.Forms.CheckBox
		Me._chkDownload_15 = New System.Windows.Forms.CheckBox
		Me._chkDownload_14 = New System.Windows.Forms.CheckBox
		Me._chkDownload_13 = New System.Windows.Forms.CheckBox
		Me._chkDownload_12 = New System.Windows.Forms.CheckBox
		Me._chkDownload_11 = New System.Windows.Forms.CheckBox
		Me._chkDownload_10 = New System.Windows.Forms.CheckBox
		Me._chkDownload_0 = New System.Windows.Forms.CheckBox
		Me._chkDownload_1 = New System.Windows.Forms.CheckBox
		Me._chkDownload_2 = New System.Windows.Forms.CheckBox
		Me._chkDownload_3 = New System.Windows.Forms.CheckBox
		Me._chkDownload_4 = New System.Windows.Forms.CheckBox
		Me._chkDownload_5 = New System.Windows.Forms.CheckBox
		Me._chkDownload_6 = New System.Windows.Forms.CheckBox
		Me._chkDownload_7 = New System.Windows.Forms.CheckBox
		Me._chkDownload_8 = New System.Windows.Forms.CheckBox
		Me._chkDownload_9 = New System.Windows.Forms.CheckBox
		Me.fraAutoFeatures = New System.Windows.Forms.GroupBox
		Me.chkFilterSVCD = New System.Windows.Forms.CheckBox
		Me.chkFilterXVID = New System.Windows.Forms.CheckBox
		Me.chkDownloadNfo = New System.Windows.Forms.CheckBox
		Me.chkAutoDownloadJPG = New System.Windows.Forms.CheckBox
		Me.fraAlternateServer = New System.Windows.Forms.GroupBox
		Me.chkUseAlternateServer = New System.Windows.Forms.CheckBox
		Me.txtBackupServer = New AxELFTxtBox.AxTxtBox1
		Me.txtBackupUsername = New AxELFTxtBox.AxTxtBox1
		Me.txtBackupPassword = New AxELFTxtBox.AxTxtBox1
		Me._LBLZ1_7 = New System.Windows.Forms.Label
		Me._LBLZ1_5 = New System.Windows.Forms.Label
		Me._LBLZ1_4 = New System.Windows.Forms.Label
		Me.fraPrimaryServer = New System.Windows.Forms.GroupBox
		Me.TXTServerName = New AxELFTxtBox.AxTxtBox1
		Me.TXTUserName = New AxELFTxtBox.AxTxtBox1
		Me.TXTPassword = New AxELFTxtBox.AxTxtBox1
		Me._LBLZ1_3 = New System.Windows.Forms.Label
		Me._LBLZ1_1 = New System.Windows.Forms.Label
		Me._LBLZ1_2 = New System.Windows.Forms.Label
		Me.fraSchedule = New System.Windows.Forms.GroupBox
		Me._chkSchedule_9 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_8 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_7 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_6 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_5 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_4 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_3 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_2 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_1 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_0 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_10 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_11 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_12 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_13 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_14 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_15 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_16 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_17 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_18 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_19 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_20 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_21 = New System.Windows.Forms.CheckBox
		Me._chkSchedule_22 = New System.Windows.Forms.CheckBox
		Me.chkStartPars = New System.Windows.Forms.CheckBox
		Me.fraDownloadPaths = New System.Windows.Forms.GroupBox
		Me.cmdDatabasePath = New System.Windows.Forms.Button
		Me.cmdPicturePath = New System.Windows.Forms.Button
		Me.cmdTempPath = New System.Windows.Forms.Button
		Me.TXTTempDownloadPath = New AxELFTxtBox.AxTxtBox1
		Me.txtPicturePath = New AxELFTxtBox.AxTxtBox1
		Me.txtDatabasePath = New AxELFTxtBox.AxTxtBox1
		Me._LBLZ1_9 = New System.Windows.Forms.Label
		Me._LBLZ1_6 = New System.Windows.Forms.Label
		Me._LBLZ1_0 = New System.Windows.Forms.Label
		Me.CMDOK = New System.Windows.Forms.Button
		Me.CMDExit = New System.Windows.Forms.Button
		Me.lblDBInfo = New System.Windows.Forms.Label
		Me.LBLZ1 = New Microsoft.VisualBasic.Compatibility.VB6.LabelArray(components)
		Me.chkDownload = New Microsoft.VisualBasic.Compatibility.VB6.CheckBoxArray(components)
		Me.chkSchedule = New Microsoft.VisualBasic.Compatibility.VB6.CheckBoxArray(components)
		Me.fraMisc.SuspendLayout()
		Me.fraDownloading.SuspendLayout()
		Me.fraAutoFeatures.SuspendLayout()
		Me.fraAlternateServer.SuspendLayout()
		Me.fraPrimaryServer.SuspendLayout()
		Me.fraSchedule.SuspendLayout()
		Me.fraDownloadPaths.SuspendLayout()
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		CType(Me.txtMaxArticleAge, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.txtConnectionAttempts, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.txtBackupServer, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.txtBackupUsername, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.txtBackupPassword, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.TXTServerName, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.TXTUserName, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.TXTPassword, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.TXTTempDownloadPath, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.txtPicturePath, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.txtDatabasePath, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.LBLZ1, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.chkDownload, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.chkSchedule, System.ComponentModel.ISupportInitialize).BeginInit()
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
		Me.Text = "Options"
		Me.ClientSize = New System.Drawing.Size(503, 614)
		Me.Location = New System.Drawing.Point(3, 22)
		Me.MaximizeBox = False
		Me.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultBounds
		Me.MinimizeBox = False
		Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		Me.BackColor = System.Drawing.SystemColors.Control
		Me.ControlBox = True
		Me.Enabled = True
		Me.KeyPreview = False
		Me.Cursor = System.Windows.Forms.Cursors.Default
		Me.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.ShowInTaskbar = True
		Me.HelpButton = False
		Me.WindowState = System.Windows.Forms.FormWindowState.Normal
		Me.Name = "FRMOptions"
		Me.fraMisc.Text = "Misc"
		Me.fraMisc.Font = New System.Drawing.Font("Arial Narrow", 9!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.fraMisc.Size = New System.Drawing.Size(489, 73)
		Me.fraMisc.Location = New System.Drawing.Point(8, 336)
		Me.fraMisc.TabIndex = 82
		Me.fraMisc.BackColor = System.Drawing.SystemColors.Control
		Me.fraMisc.Enabled = True
		Me.fraMisc.ForeColor = System.Drawing.SystemColors.ControlText
		Me.fraMisc.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.fraMisc.Visible = True
		Me.fraMisc.Padding = New System.Windows.Forms.Padding(0)
		Me.fraMisc.Name = "fraMisc"
		Me.chkStatusVisible.Text = "Status Visible"
		Me.chkStatusVisible.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.chkStatusVisible.Size = New System.Drawing.Size(129, 21)
		Me.chkStatusVisible.Location = New System.Drawing.Point(248, 20)
		Me.chkStatusVisible.TabIndex = 87
		Me.chkStatusVisible.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.chkStatusVisible.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.chkStatusVisible.BackColor = System.Drawing.SystemColors.Control
		Me.chkStatusVisible.CausesValidation = True
		Me.chkStatusVisible.Enabled = True
		Me.chkStatusVisible.ForeColor = System.Drawing.SystemColors.ControlText
		Me.chkStatusVisible.Cursor = System.Windows.Forms.Cursors.Default
		Me.chkStatusVisible.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.chkStatusVisible.Appearance = System.Windows.Forms.Appearance.Normal
		Me.chkStatusVisible.TabStop = True
		Me.chkStatusVisible.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.chkStatusVisible.Visible = True
		Me.chkStatusVisible.Name = "chkStatusVisible"
		txtMaxArticleAge.OcxState = CType(resources.GetObject("txtMaxArticleAge.OcxState"), System.Windows.Forms.AxHost.State)
		Me.txtMaxArticleAge.Size = New System.Drawing.Size(41, 21)
		Me.txtMaxArticleAge.Location = New System.Drawing.Point(112, 20)
		Me.txtMaxArticleAge.TabIndex = 83
		Me.txtMaxArticleAge.Name = "txtMaxArticleAge"
		txtConnectionAttempts.OcxState = CType(resources.GetObject("txtConnectionAttempts.OcxState"), System.Windows.Forms.AxHost.State)
		Me.txtConnectionAttempts.Size = New System.Drawing.Size(73, 21)
		Me.txtConnectionAttempts.Location = New System.Drawing.Point(112, 44)
		Me.txtConnectionAttempts.TabIndex = 85
		Me.txtConnectionAttempts.Name = "txtConnectionAttempts"
		Me._LBLZ1_8.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_8.Text = "Connection Attempts"
		Me._LBLZ1_8.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_8.Size = New System.Drawing.Size(105, 17)
		Me._LBLZ1_8.Location = New System.Drawing.Point(0, 48)
		Me._LBLZ1_8.TabIndex = 86
		Me._LBLZ1_8.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_8.Enabled = True
		Me._LBLZ1_8.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_8.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_8.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_8.UseMnemonic = True
		Me._LBLZ1_8.Visible = True
		Me._LBLZ1_8.AutoSize = False
		Me._LBLZ1_8.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_8.Name = "_LBLZ1_8"
		Me._LBLZ1_10.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_10.Text = "Max Article age %"
		Me._LBLZ1_10.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_10.Size = New System.Drawing.Size(97, 17)
		Me._LBLZ1_10.Location = New System.Drawing.Point(8, 24)
		Me._LBLZ1_10.TabIndex = 84
		Me._LBLZ1_10.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_10.Enabled = True
		Me._LBLZ1_10.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_10.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_10.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_10.UseMnemonic = True
		Me._LBLZ1_10.Visible = True
		Me._LBLZ1_10.AutoSize = False
		Me._LBLZ1_10.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_10.Name = "_LBLZ1_10"
		Me.fraDownloading.Text = "Downloading"
		Me.fraDownloading.Font = New System.Drawing.Font("Arial Narrow", 9!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.fraDownloading.Size = New System.Drawing.Size(489, 65)
		Me.fraDownloading.Location = New System.Drawing.Point(8, 500)
		Me.fraDownloading.TabIndex = 54
		Me.fraDownloading.BackColor = System.Drawing.SystemColors.Control
		Me.fraDownloading.Enabled = True
		Me.fraDownloading.ForeColor = System.Drawing.SystemColors.ControlText
		Me.fraDownloading.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.fraDownloading.Visible = True
		Me.fraDownloading.Padding = New System.Windows.Forms.Padding(0)
		Me.fraDownloading.Name = "fraDownloading"
		Me._chkDownload_22.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_22.Text = "22-23"
		Me._chkDownload_22.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_22.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_22.Location = New System.Drawing.Point(408, 40)
		Me._chkDownload_22.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_22.TabIndex = 77
		Me._chkDownload_22.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_22.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_22.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_22.CausesValidation = True
		Me._chkDownload_22.Enabled = True
		Me._chkDownload_22.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_22.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_22.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_22.TabStop = True
		Me._chkDownload_22.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_22.Visible = True
		Me._chkDownload_22.Name = "_chkDownload_22"
		Me._chkDownload_21.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_21.Text = "21-22"
		Me._chkDownload_21.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_21.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_21.Location = New System.Drawing.Point(368, 40)
		Me._chkDownload_21.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_21.TabIndex = 76
		Me._chkDownload_21.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_21.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_21.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_21.CausesValidation = True
		Me._chkDownload_21.Enabled = True
		Me._chkDownload_21.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_21.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_21.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_21.TabStop = True
		Me._chkDownload_21.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_21.Visible = True
		Me._chkDownload_21.Name = "_chkDownload_21"
		Me._chkDownload_20.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_20.Text = "20-21"
		Me._chkDownload_20.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_20.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_20.Location = New System.Drawing.Point(328, 40)
		Me._chkDownload_20.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_20.TabIndex = 75
		Me._chkDownload_20.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_20.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_20.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_20.CausesValidation = True
		Me._chkDownload_20.Enabled = True
		Me._chkDownload_20.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_20.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_20.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_20.TabStop = True
		Me._chkDownload_20.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_20.Visible = True
		Me._chkDownload_20.Name = "_chkDownload_20"
		Me._chkDownload_19.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_19.Text = "19-20"
		Me._chkDownload_19.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_19.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_19.Location = New System.Drawing.Point(288, 40)
		Me._chkDownload_19.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_19.TabIndex = 74
		Me._chkDownload_19.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_19.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_19.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_19.CausesValidation = True
		Me._chkDownload_19.Enabled = True
		Me._chkDownload_19.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_19.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_19.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_19.TabStop = True
		Me._chkDownload_19.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_19.Visible = True
		Me._chkDownload_19.Name = "_chkDownload_19"
		Me._chkDownload_18.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_18.Text = "18-19"
		Me._chkDownload_18.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_18.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_18.Location = New System.Drawing.Point(248, 40)
		Me._chkDownload_18.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_18.TabIndex = 73
		Me._chkDownload_18.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_18.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_18.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_18.CausesValidation = True
		Me._chkDownload_18.Enabled = True
		Me._chkDownload_18.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_18.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_18.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_18.TabStop = True
		Me._chkDownload_18.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_18.Visible = True
		Me._chkDownload_18.Name = "_chkDownload_18"
		Me._chkDownload_17.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_17.Text = "17-18"
		Me._chkDownload_17.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_17.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_17.Location = New System.Drawing.Point(208, 40)
		Me._chkDownload_17.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_17.TabIndex = 72
		Me._chkDownload_17.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_17.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_17.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_17.CausesValidation = True
		Me._chkDownload_17.Enabled = True
		Me._chkDownload_17.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_17.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_17.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_17.TabStop = True
		Me._chkDownload_17.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_17.Visible = True
		Me._chkDownload_17.Name = "_chkDownload_17"
		Me._chkDownload_16.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_16.Text = "16-17"
		Me._chkDownload_16.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_16.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_16.Location = New System.Drawing.Point(168, 40)
		Me._chkDownload_16.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_16.TabIndex = 71
		Me._chkDownload_16.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_16.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_16.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_16.CausesValidation = True
		Me._chkDownload_16.Enabled = True
		Me._chkDownload_16.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_16.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_16.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_16.TabStop = True
		Me._chkDownload_16.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_16.Visible = True
		Me._chkDownload_16.Name = "_chkDownload_16"
		Me._chkDownload_15.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_15.Text = "15-16"
		Me._chkDownload_15.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_15.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_15.Location = New System.Drawing.Point(128, 40)
		Me._chkDownload_15.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_15.TabIndex = 70
		Me._chkDownload_15.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_15.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_15.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_15.CausesValidation = True
		Me._chkDownload_15.Enabled = True
		Me._chkDownload_15.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_15.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_15.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_15.TabStop = True
		Me._chkDownload_15.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_15.Visible = True
		Me._chkDownload_15.Name = "_chkDownload_15"
		Me._chkDownload_14.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_14.Text = "14-15"
		Me._chkDownload_14.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_14.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_14.Location = New System.Drawing.Point(88, 40)
		Me._chkDownload_14.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_14.TabIndex = 69
		Me._chkDownload_14.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_14.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_14.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_14.CausesValidation = True
		Me._chkDownload_14.Enabled = True
		Me._chkDownload_14.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_14.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_14.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_14.TabStop = True
		Me._chkDownload_14.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_14.Visible = True
		Me._chkDownload_14.Name = "_chkDownload_14"
		Me._chkDownload_13.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_13.Text = "13-14"
		Me._chkDownload_13.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_13.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_13.Location = New System.Drawing.Point(48, 40)
		Me._chkDownload_13.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_13.TabIndex = 68
		Me._chkDownload_13.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_13.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_13.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_13.CausesValidation = True
		Me._chkDownload_13.Enabled = True
		Me._chkDownload_13.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_13.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_13.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_13.TabStop = True
		Me._chkDownload_13.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_13.Visible = True
		Me._chkDownload_13.Name = "_chkDownload_13"
		Me._chkDownload_12.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_12.Text = "12-13"
		Me._chkDownload_12.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_12.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_12.Location = New System.Drawing.Point(8, 40)
		Me._chkDownload_12.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_12.TabIndex = 67
		Me._chkDownload_12.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_12.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_12.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_12.CausesValidation = True
		Me._chkDownload_12.Enabled = True
		Me._chkDownload_12.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_12.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_12.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_12.TabStop = True
		Me._chkDownload_12.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_12.Visible = True
		Me._chkDownload_12.Name = "_chkDownload_12"
		Me._chkDownload_11.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_11.Text = "11-12"
		Me._chkDownload_11.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_11.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_11.Location = New System.Drawing.Point(448, 20)
		Me._chkDownload_11.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_11.TabIndex = 66
		Me._chkDownload_11.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_11.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_11.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_11.CausesValidation = True
		Me._chkDownload_11.Enabled = True
		Me._chkDownload_11.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_11.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_11.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_11.TabStop = True
		Me._chkDownload_11.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_11.Visible = True
		Me._chkDownload_11.Name = "_chkDownload_11"
		Me._chkDownload_10.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_10.Text = "10-11"
		Me._chkDownload_10.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_10.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_10.Location = New System.Drawing.Point(408, 20)
		Me._chkDownload_10.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_10.TabIndex = 65
		Me._chkDownload_10.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_10.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_10.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_10.CausesValidation = True
		Me._chkDownload_10.Enabled = True
		Me._chkDownload_10.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_10.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_10.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_10.TabStop = True
		Me._chkDownload_10.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_10.Visible = True
		Me._chkDownload_10.Name = "_chkDownload_10"
		Me._chkDownload_0.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_0.Text = "0-1"
		Me._chkDownload_0.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_0.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_0.Location = New System.Drawing.Point(8, 20)
		Me._chkDownload_0.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_0.TabIndex = 64
		Me._chkDownload_0.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_0.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_0.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_0.CausesValidation = True
		Me._chkDownload_0.Enabled = True
		Me._chkDownload_0.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_0.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_0.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_0.TabStop = True
		Me._chkDownload_0.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_0.Visible = True
		Me._chkDownload_0.Name = "_chkDownload_0"
		Me._chkDownload_1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_1.Text = "1-2"
		Me._chkDownload_1.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_1.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_1.Location = New System.Drawing.Point(48, 20)
		Me._chkDownload_1.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_1.TabIndex = 63
		Me._chkDownload_1.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_1.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_1.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_1.CausesValidation = True
		Me._chkDownload_1.Enabled = True
		Me._chkDownload_1.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_1.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_1.TabStop = True
		Me._chkDownload_1.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_1.Visible = True
		Me._chkDownload_1.Name = "_chkDownload_1"
		Me._chkDownload_2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_2.Text = "2-3"
		Me._chkDownload_2.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_2.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_2.Location = New System.Drawing.Point(88, 20)
		Me._chkDownload_2.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_2.TabIndex = 62
		Me._chkDownload_2.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_2.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_2.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_2.CausesValidation = True
		Me._chkDownload_2.Enabled = True
		Me._chkDownload_2.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_2.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_2.TabStop = True
		Me._chkDownload_2.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_2.Visible = True
		Me._chkDownload_2.Name = "_chkDownload_2"
		Me._chkDownload_3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_3.Text = "3-4"
		Me._chkDownload_3.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_3.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_3.Location = New System.Drawing.Point(128, 20)
		Me._chkDownload_3.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_3.TabIndex = 61
		Me._chkDownload_3.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_3.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_3.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_3.CausesValidation = True
		Me._chkDownload_3.Enabled = True
		Me._chkDownload_3.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_3.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_3.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_3.TabStop = True
		Me._chkDownload_3.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_3.Visible = True
		Me._chkDownload_3.Name = "_chkDownload_3"
		Me._chkDownload_4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_4.Text = "4-5"
		Me._chkDownload_4.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_4.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_4.Location = New System.Drawing.Point(168, 20)
		Me._chkDownload_4.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_4.TabIndex = 60
		Me._chkDownload_4.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_4.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_4.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_4.CausesValidation = True
		Me._chkDownload_4.Enabled = True
		Me._chkDownload_4.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_4.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_4.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_4.TabStop = True
		Me._chkDownload_4.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_4.Visible = True
		Me._chkDownload_4.Name = "_chkDownload_4"
		Me._chkDownload_5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_5.Text = "5-6"
		Me._chkDownload_5.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_5.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_5.Location = New System.Drawing.Point(208, 20)
		Me._chkDownload_5.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_5.TabIndex = 59
		Me._chkDownload_5.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_5.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_5.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_5.CausesValidation = True
		Me._chkDownload_5.Enabled = True
		Me._chkDownload_5.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_5.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_5.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_5.TabStop = True
		Me._chkDownload_5.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_5.Visible = True
		Me._chkDownload_5.Name = "_chkDownload_5"
		Me._chkDownload_6.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_6.Text = "6-7"
		Me._chkDownload_6.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_6.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_6.Location = New System.Drawing.Point(248, 20)
		Me._chkDownload_6.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_6.TabIndex = 58
		Me._chkDownload_6.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_6.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_6.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_6.CausesValidation = True
		Me._chkDownload_6.Enabled = True
		Me._chkDownload_6.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_6.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_6.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_6.TabStop = True
		Me._chkDownload_6.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_6.Visible = True
		Me._chkDownload_6.Name = "_chkDownload_6"
		Me._chkDownload_7.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_7.Text = "7-8"
		Me._chkDownload_7.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_7.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_7.Location = New System.Drawing.Point(288, 20)
		Me._chkDownload_7.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_7.TabIndex = 57
		Me._chkDownload_7.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_7.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_7.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_7.CausesValidation = True
		Me._chkDownload_7.Enabled = True
		Me._chkDownload_7.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_7.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_7.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_7.TabStop = True
		Me._chkDownload_7.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_7.Visible = True
		Me._chkDownload_7.Name = "_chkDownload_7"
		Me._chkDownload_8.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_8.Text = "8-9"
		Me._chkDownload_8.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_8.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_8.Location = New System.Drawing.Point(328, 20)
		Me._chkDownload_8.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_8.TabIndex = 56
		Me._chkDownload_8.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_8.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_8.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_8.CausesValidation = True
		Me._chkDownload_8.Enabled = True
		Me._chkDownload_8.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_8.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_8.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_8.TabStop = True
		Me._chkDownload_8.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_8.Visible = True
		Me._chkDownload_8.Name = "_chkDownload_8"
		Me._chkDownload_9.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkDownload_9.Text = "9-10"
		Me._chkDownload_9.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkDownload_9.Size = New System.Drawing.Size(37, 17)
		Me._chkDownload_9.Location = New System.Drawing.Point(368, 20)
		Me._chkDownload_9.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkDownload_9.TabIndex = 55
		Me._chkDownload_9.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkDownload_9.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkDownload_9.BackColor = System.Drawing.SystemColors.Control
		Me._chkDownload_9.CausesValidation = True
		Me._chkDownload_9.Enabled = True
		Me._chkDownload_9.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkDownload_9.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkDownload_9.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkDownload_9.TabStop = True
		Me._chkDownload_9.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkDownload_9.Visible = True
		Me._chkDownload_9.Name = "_chkDownload_9"
		Me.fraAutoFeatures.Text = "Auto Features"
		Me.fraAutoFeatures.Font = New System.Drawing.Font("Arial Narrow", 9!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.fraAutoFeatures.Size = New System.Drawing.Size(153, 121)
		Me.fraAutoFeatures.Location = New System.Drawing.Point(344, 104)
		Me.fraAutoFeatures.TabIndex = 48
		Me.fraAutoFeatures.BackColor = System.Drawing.SystemColors.Control
		Me.fraAutoFeatures.Enabled = True
		Me.fraAutoFeatures.ForeColor = System.Drawing.SystemColors.ControlText
		Me.fraAutoFeatures.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.fraAutoFeatures.Visible = True
		Me.fraAutoFeatures.Padding = New System.Windows.Forms.Padding(0)
		Me.fraAutoFeatures.Name = "fraAutoFeatures"
		Me.chkFilterSVCD.Text = "Filter .SVCD in DVDr"
		Me.chkFilterSVCD.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.chkFilterSVCD.Size = New System.Drawing.Size(129, 21)
		Me.chkFilterSVCD.Location = New System.Drawing.Point(8, 84)
		Me.chkFilterSVCD.TabIndex = 53
		Me.chkFilterSVCD.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.chkFilterSVCD.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.chkFilterSVCD.BackColor = System.Drawing.SystemColors.Control
		Me.chkFilterSVCD.CausesValidation = True
		Me.chkFilterSVCD.Enabled = True
		Me.chkFilterSVCD.ForeColor = System.Drawing.SystemColors.ControlText
		Me.chkFilterSVCD.Cursor = System.Windows.Forms.Cursors.Default
		Me.chkFilterSVCD.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.chkFilterSVCD.Appearance = System.Windows.Forms.Appearance.Normal
		Me.chkFilterSVCD.TabStop = True
		Me.chkFilterSVCD.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.chkFilterSVCD.Visible = True
		Me.chkFilterSVCD.Name = "chkFilterSVCD"
		Me.chkFilterXVID.Text = "Filter .XVID in DVDr"
		Me.chkFilterXVID.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.chkFilterXVID.Size = New System.Drawing.Size(129, 21)
		Me.chkFilterXVID.Location = New System.Drawing.Point(8, 64)
		Me.chkFilterXVID.TabIndex = 52
		Me.chkFilterXVID.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.chkFilterXVID.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.chkFilterXVID.BackColor = System.Drawing.SystemColors.Control
		Me.chkFilterXVID.CausesValidation = True
		Me.chkFilterXVID.Enabled = True
		Me.chkFilterXVID.ForeColor = System.Drawing.SystemColors.ControlText
		Me.chkFilterXVID.Cursor = System.Windows.Forms.Cursors.Default
		Me.chkFilterXVID.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.chkFilterXVID.Appearance = System.Windows.Forms.Appearance.Normal
		Me.chkFilterXVID.TabStop = True
		Me.chkFilterXVID.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.chkFilterXVID.Visible = True
		Me.chkFilterXVID.Name = "chkFilterXVID"
		Me.chkDownloadNfo.Text = "Download NFO's First"
		Me.chkDownloadNfo.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.chkDownloadNfo.Size = New System.Drawing.Size(129, 21)
		Me.chkDownloadNfo.Location = New System.Drawing.Point(8, 44)
		Me.chkDownloadNfo.TabIndex = 50
		Me.chkDownloadNfo.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.chkDownloadNfo.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.chkDownloadNfo.BackColor = System.Drawing.SystemColors.Control
		Me.chkDownloadNfo.CausesValidation = True
		Me.chkDownloadNfo.Enabled = True
		Me.chkDownloadNfo.ForeColor = System.Drawing.SystemColors.ControlText
		Me.chkDownloadNfo.Cursor = System.Windows.Forms.Cursors.Default
		Me.chkDownloadNfo.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.chkDownloadNfo.Appearance = System.Windows.Forms.Appearance.Normal
		Me.chkDownloadNfo.TabStop = True
		Me.chkDownloadNfo.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.chkDownloadNfo.Visible = True
		Me.chkDownloadNfo.Name = "chkDownloadNfo"
		Me.chkAutoDownloadJPG.Text = "Auto Download JPG"
		Me.chkAutoDownloadJPG.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.chkAutoDownloadJPG.Size = New System.Drawing.Size(129, 21)
		Me.chkAutoDownloadJPG.Location = New System.Drawing.Point(8, 24)
		Me.chkAutoDownloadJPG.TabIndex = 49
		Me.chkAutoDownloadJPG.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.chkAutoDownloadJPG.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.chkAutoDownloadJPG.BackColor = System.Drawing.SystemColors.Control
		Me.chkAutoDownloadJPG.CausesValidation = True
		Me.chkAutoDownloadJPG.Enabled = True
		Me.chkAutoDownloadJPG.ForeColor = System.Drawing.SystemColors.ControlText
		Me.chkAutoDownloadJPG.Cursor = System.Windows.Forms.Cursors.Default
		Me.chkAutoDownloadJPG.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.chkAutoDownloadJPG.Appearance = System.Windows.Forms.Appearance.Normal
		Me.chkAutoDownloadJPG.TabStop = True
		Me.chkAutoDownloadJPG.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.chkAutoDownloadJPG.Visible = True
		Me.chkAutoDownloadJPG.Name = "chkAutoDownloadJPG"
		Me.fraAlternateServer.Text = "Alternate Server"
		Me.fraAlternateServer.Font = New System.Drawing.Font("Arial Narrow", 9!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.fraAlternateServer.Size = New System.Drawing.Size(329, 121)
		Me.fraAlternateServer.Location = New System.Drawing.Point(8, 104)
		Me.fraAlternateServer.TabIndex = 41
		Me.fraAlternateServer.Visible = False
		Me.fraAlternateServer.BackColor = System.Drawing.SystemColors.Control
		Me.fraAlternateServer.Enabled = True
		Me.fraAlternateServer.ForeColor = System.Drawing.SystemColors.ControlText
		Me.fraAlternateServer.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.fraAlternateServer.Padding = New System.Windows.Forms.Padding(0)
		Me.fraAlternateServer.Name = "fraAlternateServer"
		Me.chkUseAlternateServer.Text = "Use Alternate Server"
		Me.chkUseAlternateServer.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.chkUseAlternateServer.Size = New System.Drawing.Size(129, 21)
		Me.chkUseAlternateServer.Location = New System.Drawing.Point(96, 96)
		Me.chkUseAlternateServer.TabIndex = 51
		Me.chkUseAlternateServer.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.chkUseAlternateServer.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.chkUseAlternateServer.BackColor = System.Drawing.SystemColors.Control
		Me.chkUseAlternateServer.CausesValidation = True
		Me.chkUseAlternateServer.Enabled = True
		Me.chkUseAlternateServer.ForeColor = System.Drawing.SystemColors.ControlText
		Me.chkUseAlternateServer.Cursor = System.Windows.Forms.Cursors.Default
		Me.chkUseAlternateServer.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.chkUseAlternateServer.Appearance = System.Windows.Forms.Appearance.Normal
		Me.chkUseAlternateServer.TabStop = True
		Me.chkUseAlternateServer.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.chkUseAlternateServer.Visible = True
		Me.chkUseAlternateServer.Name = "chkUseAlternateServer"
		txtBackupServer.OcxState = CType(resources.GetObject("txtBackupServer.OcxState"), System.Windows.Forms.AxHost.State)
		Me.txtBackupServer.Size = New System.Drawing.Size(225, 21)
		Me.txtBackupServer.Location = New System.Drawing.Point(96, 16)
		Me.txtBackupServer.TabIndex = 42
		Me.txtBackupServer.Name = "txtBackupServer"
		txtBackupUsername.OcxState = CType(resources.GetObject("txtBackupUsername.OcxState"), System.Windows.Forms.AxHost.State)
		Me.txtBackupUsername.Size = New System.Drawing.Size(225, 21)
		Me.txtBackupUsername.Location = New System.Drawing.Point(96, 44)
		Me.txtBackupUsername.TabIndex = 43
		Me.txtBackupUsername.Name = "txtBackupUsername"
		txtBackupPassword.OcxState = CType(resources.GetObject("txtBackupPassword.OcxState"), System.Windows.Forms.AxHost.State)
		Me.txtBackupPassword.Size = New System.Drawing.Size(225, 21)
		Me.txtBackupPassword.Location = New System.Drawing.Point(96, 72)
		Me.txtBackupPassword.TabIndex = 44
		Me.txtBackupPassword.Name = "txtBackupPassword"
		Me._LBLZ1_7.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_7.Text = "Password"
		Me._LBLZ1_7.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_7.Size = New System.Drawing.Size(73, 17)
		Me._LBLZ1_7.Location = New System.Drawing.Point(16, 74)
		Me._LBLZ1_7.TabIndex = 47
		Me._LBLZ1_7.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_7.Enabled = True
		Me._LBLZ1_7.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_7.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_7.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_7.UseMnemonic = True
		Me._LBLZ1_7.Visible = True
		Me._LBLZ1_7.AutoSize = False
		Me._LBLZ1_7.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_7.Name = "_LBLZ1_7"
		Me._LBLZ1_5.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_5.Text = "Username"
		Me._LBLZ1_5.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_5.Size = New System.Drawing.Size(81, 17)
		Me._LBLZ1_5.Location = New System.Drawing.Point(8, 48)
		Me._LBLZ1_5.TabIndex = 46
		Me._LBLZ1_5.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_5.Enabled = True
		Me._LBLZ1_5.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_5.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_5.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_5.UseMnemonic = True
		Me._LBLZ1_5.Visible = True
		Me._LBLZ1_5.AutoSize = False
		Me._LBLZ1_5.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_5.Name = "_LBLZ1_5"
		Me._LBLZ1_4.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_4.Text = "Server Name"
		Me._LBLZ1_4.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_4.Size = New System.Drawing.Size(81, 17)
		Me._LBLZ1_4.Location = New System.Drawing.Point(8, 18)
		Me._LBLZ1_4.TabIndex = 45
		Me._LBLZ1_4.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_4.Enabled = True
		Me._LBLZ1_4.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_4.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_4.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_4.UseMnemonic = True
		Me._LBLZ1_4.Visible = True
		Me._LBLZ1_4.AutoSize = False
		Me._LBLZ1_4.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_4.Name = "_LBLZ1_4"
		Me.fraPrimaryServer.Text = "Primary Server"
		Me.fraPrimaryServer.Font = New System.Drawing.Font("Arial Narrow", 9!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.fraPrimaryServer.Size = New System.Drawing.Size(329, 97)
		Me.fraPrimaryServer.Location = New System.Drawing.Point(8, 4)
		Me.fraPrimaryServer.TabIndex = 34
		Me.fraPrimaryServer.BackColor = System.Drawing.SystemColors.Control
		Me.fraPrimaryServer.Enabled = True
		Me.fraPrimaryServer.ForeColor = System.Drawing.SystemColors.ControlText
		Me.fraPrimaryServer.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.fraPrimaryServer.Visible = True
		Me.fraPrimaryServer.Padding = New System.Windows.Forms.Padding(0)
		Me.fraPrimaryServer.Name = "fraPrimaryServer"
		TXTServerName.OcxState = CType(resources.GetObject("TXTServerName.OcxState"), System.Windows.Forms.AxHost.State)
		Me.TXTServerName.Size = New System.Drawing.Size(225, 21)
		Me.TXTServerName.Location = New System.Drawing.Point(96, 12)
		Me.TXTServerName.TabIndex = 35
		Me.TXTServerName.Name = "TXTServerName"
		TXTUserName.OcxState = CType(resources.GetObject("TXTUserName.OcxState"), System.Windows.Forms.AxHost.State)
		Me.TXTUserName.Size = New System.Drawing.Size(225, 21)
		Me.TXTUserName.Location = New System.Drawing.Point(96, 40)
		Me.TXTUserName.TabIndex = 36
		Me.TXTUserName.Name = "TXTUserName"
		TXTPassword.OcxState = CType(resources.GetObject("TXTPassword.OcxState"), System.Windows.Forms.AxHost.State)
		Me.TXTPassword.Size = New System.Drawing.Size(225, 21)
		Me.TXTPassword.Location = New System.Drawing.Point(96, 68)
		Me.TXTPassword.TabIndex = 37
		Me.TXTPassword.Name = "TXTPassword"
		Me._LBLZ1_3.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_3.Text = "Server Name"
		Me._LBLZ1_3.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_3.Size = New System.Drawing.Size(81, 17)
		Me._LBLZ1_3.Location = New System.Drawing.Point(8, 14)
		Me._LBLZ1_3.TabIndex = 40
		Me._LBLZ1_3.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_3.Enabled = True
		Me._LBLZ1_3.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_3.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_3.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_3.UseMnemonic = True
		Me._LBLZ1_3.Visible = True
		Me._LBLZ1_3.AutoSize = False
		Me._LBLZ1_3.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_3.Name = "_LBLZ1_3"
		Me._LBLZ1_1.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_1.Text = "Username"
		Me._LBLZ1_1.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_1.Size = New System.Drawing.Size(81, 17)
		Me._LBLZ1_1.Location = New System.Drawing.Point(8, 44)
		Me._LBLZ1_1.TabIndex = 39
		Me._LBLZ1_1.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_1.Enabled = True
		Me._LBLZ1_1.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_1.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_1.UseMnemonic = True
		Me._LBLZ1_1.Visible = True
		Me._LBLZ1_1.AutoSize = False
		Me._LBLZ1_1.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_1.Name = "_LBLZ1_1"
		Me._LBLZ1_2.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_2.Text = "Password"
		Me._LBLZ1_2.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_2.Size = New System.Drawing.Size(73, 17)
		Me._LBLZ1_2.Location = New System.Drawing.Point(16, 70)
		Me._LBLZ1_2.TabIndex = 38
		Me._LBLZ1_2.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_2.Enabled = True
		Me._LBLZ1_2.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_2.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_2.UseMnemonic = True
		Me._LBLZ1_2.Visible = True
		Me._LBLZ1_2.AutoSize = False
		Me._LBLZ1_2.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_2.Name = "_LBLZ1_2"
		Me.fraSchedule.Text = "Schedule"
		Me.fraSchedule.Font = New System.Drawing.Font("Arial Narrow", 9!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.fraSchedule.Size = New System.Drawing.Size(489, 81)
		Me.fraSchedule.Location = New System.Drawing.Point(8, 412)
		Me.fraSchedule.TabIndex = 9
		Me.fraSchedule.BackColor = System.Drawing.SystemColors.Control
		Me.fraSchedule.Enabled = True
		Me.fraSchedule.ForeColor = System.Drawing.SystemColors.ControlText
		Me.fraSchedule.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.fraSchedule.Visible = True
		Me.fraSchedule.Padding = New System.Windows.Forms.Padding(0)
		Me.fraSchedule.Name = "fraSchedule"
		Me._chkSchedule_9.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_9.Text = "9-10"
		Me._chkSchedule_9.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_9.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_9.Location = New System.Drawing.Point(368, 36)
		Me._chkSchedule_9.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_9.TabIndex = 32
		Me._chkSchedule_9.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_9.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_9.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_9.CausesValidation = True
		Me._chkSchedule_9.Enabled = True
		Me._chkSchedule_9.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_9.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_9.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_9.TabStop = True
		Me._chkSchedule_9.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_9.Visible = True
		Me._chkSchedule_9.Name = "_chkSchedule_9"
		Me._chkSchedule_8.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_8.Text = "8-9"
		Me._chkSchedule_8.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_8.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_8.Location = New System.Drawing.Point(328, 36)
		Me._chkSchedule_8.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_8.TabIndex = 31
		Me._chkSchedule_8.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_8.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_8.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_8.CausesValidation = True
		Me._chkSchedule_8.Enabled = True
		Me._chkSchedule_8.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_8.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_8.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_8.TabStop = True
		Me._chkSchedule_8.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_8.Visible = True
		Me._chkSchedule_8.Name = "_chkSchedule_8"
		Me._chkSchedule_7.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_7.Text = "7-8"
		Me._chkSchedule_7.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_7.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_7.Location = New System.Drawing.Point(288, 36)
		Me._chkSchedule_7.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_7.TabIndex = 30
		Me._chkSchedule_7.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_7.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_7.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_7.CausesValidation = True
		Me._chkSchedule_7.Enabled = True
		Me._chkSchedule_7.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_7.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_7.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_7.TabStop = True
		Me._chkSchedule_7.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_7.Visible = True
		Me._chkSchedule_7.Name = "_chkSchedule_7"
		Me._chkSchedule_6.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_6.Text = "6-7"
		Me._chkSchedule_6.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_6.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_6.Location = New System.Drawing.Point(248, 36)
		Me._chkSchedule_6.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_6.TabIndex = 29
		Me._chkSchedule_6.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_6.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_6.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_6.CausesValidation = True
		Me._chkSchedule_6.Enabled = True
		Me._chkSchedule_6.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_6.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_6.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_6.TabStop = True
		Me._chkSchedule_6.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_6.Visible = True
		Me._chkSchedule_6.Name = "_chkSchedule_6"
		Me._chkSchedule_5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_5.Text = "5-6"
		Me._chkSchedule_5.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_5.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_5.Location = New System.Drawing.Point(208, 36)
		Me._chkSchedule_5.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_5.TabIndex = 28
		Me._chkSchedule_5.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_5.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_5.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_5.CausesValidation = True
		Me._chkSchedule_5.Enabled = True
		Me._chkSchedule_5.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_5.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_5.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_5.TabStop = True
		Me._chkSchedule_5.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_5.Visible = True
		Me._chkSchedule_5.Name = "_chkSchedule_5"
		Me._chkSchedule_4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_4.Text = "4-5"
		Me._chkSchedule_4.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_4.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_4.Location = New System.Drawing.Point(168, 36)
		Me._chkSchedule_4.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_4.TabIndex = 27
		Me._chkSchedule_4.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_4.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_4.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_4.CausesValidation = True
		Me._chkSchedule_4.Enabled = True
		Me._chkSchedule_4.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_4.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_4.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_4.TabStop = True
		Me._chkSchedule_4.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_4.Visible = True
		Me._chkSchedule_4.Name = "_chkSchedule_4"
		Me._chkSchedule_3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_3.Text = "3-4"
		Me._chkSchedule_3.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_3.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_3.Location = New System.Drawing.Point(128, 36)
		Me._chkSchedule_3.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_3.TabIndex = 26
		Me._chkSchedule_3.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_3.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_3.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_3.CausesValidation = True
		Me._chkSchedule_3.Enabled = True
		Me._chkSchedule_3.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_3.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_3.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_3.TabStop = True
		Me._chkSchedule_3.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_3.Visible = True
		Me._chkSchedule_3.Name = "_chkSchedule_3"
		Me._chkSchedule_2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_2.Text = "2-3"
		Me._chkSchedule_2.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_2.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_2.Location = New System.Drawing.Point(88, 36)
		Me._chkSchedule_2.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_2.TabIndex = 25
		Me._chkSchedule_2.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_2.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_2.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_2.CausesValidation = True
		Me._chkSchedule_2.Enabled = True
		Me._chkSchedule_2.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_2.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_2.TabStop = True
		Me._chkSchedule_2.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_2.Visible = True
		Me._chkSchedule_2.Name = "_chkSchedule_2"
		Me._chkSchedule_1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_1.Text = "1-2"
		Me._chkSchedule_1.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_1.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_1.Location = New System.Drawing.Point(48, 36)
		Me._chkSchedule_1.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_1.TabIndex = 24
		Me._chkSchedule_1.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_1.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_1.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_1.CausesValidation = True
		Me._chkSchedule_1.Enabled = True
		Me._chkSchedule_1.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_1.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_1.TabStop = True
		Me._chkSchedule_1.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_1.Visible = True
		Me._chkSchedule_1.Name = "_chkSchedule_1"
		Me._chkSchedule_0.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_0.Text = "0-1"
		Me._chkSchedule_0.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_0.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_0.Location = New System.Drawing.Point(8, 36)
		Me._chkSchedule_0.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_0.TabIndex = 23
		Me._chkSchedule_0.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_0.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_0.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_0.CausesValidation = True
		Me._chkSchedule_0.Enabled = True
		Me._chkSchedule_0.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_0.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_0.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_0.TabStop = True
		Me._chkSchedule_0.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_0.Visible = True
		Me._chkSchedule_0.Name = "_chkSchedule_0"
		Me._chkSchedule_10.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_10.Text = "10-11"
		Me._chkSchedule_10.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_10.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_10.Location = New System.Drawing.Point(408, 36)
		Me._chkSchedule_10.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_10.TabIndex = 22
		Me._chkSchedule_10.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_10.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_10.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_10.CausesValidation = True
		Me._chkSchedule_10.Enabled = True
		Me._chkSchedule_10.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_10.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_10.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_10.TabStop = True
		Me._chkSchedule_10.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_10.Visible = True
		Me._chkSchedule_10.Name = "_chkSchedule_10"
		Me._chkSchedule_11.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_11.Text = "11-12"
		Me._chkSchedule_11.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_11.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_11.Location = New System.Drawing.Point(448, 36)
		Me._chkSchedule_11.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_11.TabIndex = 21
		Me._chkSchedule_11.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_11.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_11.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_11.CausesValidation = True
		Me._chkSchedule_11.Enabled = True
		Me._chkSchedule_11.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_11.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_11.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_11.TabStop = True
		Me._chkSchedule_11.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_11.Visible = True
		Me._chkSchedule_11.Name = "_chkSchedule_11"
		Me._chkSchedule_12.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_12.Text = "12-13"
		Me._chkSchedule_12.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_12.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_12.Location = New System.Drawing.Point(8, 56)
		Me._chkSchedule_12.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_12.TabIndex = 20
		Me._chkSchedule_12.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_12.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_12.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_12.CausesValidation = True
		Me._chkSchedule_12.Enabled = True
		Me._chkSchedule_12.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_12.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_12.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_12.TabStop = True
		Me._chkSchedule_12.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_12.Visible = True
		Me._chkSchedule_12.Name = "_chkSchedule_12"
		Me._chkSchedule_13.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_13.Text = "13-14"
		Me._chkSchedule_13.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_13.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_13.Location = New System.Drawing.Point(48, 56)
		Me._chkSchedule_13.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_13.TabIndex = 19
		Me._chkSchedule_13.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_13.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_13.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_13.CausesValidation = True
		Me._chkSchedule_13.Enabled = True
		Me._chkSchedule_13.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_13.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_13.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_13.TabStop = True
		Me._chkSchedule_13.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_13.Visible = True
		Me._chkSchedule_13.Name = "_chkSchedule_13"
		Me._chkSchedule_14.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_14.Text = "14-15"
		Me._chkSchedule_14.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_14.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_14.Location = New System.Drawing.Point(88, 56)
		Me._chkSchedule_14.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_14.TabIndex = 18
		Me._chkSchedule_14.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_14.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_14.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_14.CausesValidation = True
		Me._chkSchedule_14.Enabled = True
		Me._chkSchedule_14.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_14.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_14.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_14.TabStop = True
		Me._chkSchedule_14.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_14.Visible = True
		Me._chkSchedule_14.Name = "_chkSchedule_14"
		Me._chkSchedule_15.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_15.Text = "15-16"
		Me._chkSchedule_15.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_15.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_15.Location = New System.Drawing.Point(128, 56)
		Me._chkSchedule_15.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_15.TabIndex = 17
		Me._chkSchedule_15.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_15.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_15.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_15.CausesValidation = True
		Me._chkSchedule_15.Enabled = True
		Me._chkSchedule_15.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_15.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_15.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_15.TabStop = True
		Me._chkSchedule_15.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_15.Visible = True
		Me._chkSchedule_15.Name = "_chkSchedule_15"
		Me._chkSchedule_16.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_16.Text = "16-17"
		Me._chkSchedule_16.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_16.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_16.Location = New System.Drawing.Point(168, 56)
		Me._chkSchedule_16.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_16.TabIndex = 16
		Me._chkSchedule_16.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_16.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_16.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_16.CausesValidation = True
		Me._chkSchedule_16.Enabled = True
		Me._chkSchedule_16.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_16.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_16.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_16.TabStop = True
		Me._chkSchedule_16.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_16.Visible = True
		Me._chkSchedule_16.Name = "_chkSchedule_16"
		Me._chkSchedule_17.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_17.Text = "17-18"
		Me._chkSchedule_17.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_17.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_17.Location = New System.Drawing.Point(208, 56)
		Me._chkSchedule_17.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_17.TabIndex = 15
		Me._chkSchedule_17.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_17.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_17.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_17.CausesValidation = True
		Me._chkSchedule_17.Enabled = True
		Me._chkSchedule_17.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_17.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_17.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_17.TabStop = True
		Me._chkSchedule_17.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_17.Visible = True
		Me._chkSchedule_17.Name = "_chkSchedule_17"
		Me._chkSchedule_18.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_18.Text = "18-19"
		Me._chkSchedule_18.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_18.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_18.Location = New System.Drawing.Point(248, 56)
		Me._chkSchedule_18.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_18.TabIndex = 14
		Me._chkSchedule_18.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_18.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_18.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_18.CausesValidation = True
		Me._chkSchedule_18.Enabled = True
		Me._chkSchedule_18.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_18.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_18.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_18.TabStop = True
		Me._chkSchedule_18.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_18.Visible = True
		Me._chkSchedule_18.Name = "_chkSchedule_18"
		Me._chkSchedule_19.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_19.Text = "19-20"
		Me._chkSchedule_19.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_19.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_19.Location = New System.Drawing.Point(288, 56)
		Me._chkSchedule_19.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_19.TabIndex = 13
		Me._chkSchedule_19.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_19.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_19.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_19.CausesValidation = True
		Me._chkSchedule_19.Enabled = True
		Me._chkSchedule_19.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_19.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_19.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_19.TabStop = True
		Me._chkSchedule_19.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_19.Visible = True
		Me._chkSchedule_19.Name = "_chkSchedule_19"
		Me._chkSchedule_20.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_20.Text = "20-21"
		Me._chkSchedule_20.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_20.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_20.Location = New System.Drawing.Point(328, 56)
		Me._chkSchedule_20.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_20.TabIndex = 12
		Me._chkSchedule_20.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_20.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_20.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_20.CausesValidation = True
		Me._chkSchedule_20.Enabled = True
		Me._chkSchedule_20.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_20.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_20.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_20.TabStop = True
		Me._chkSchedule_20.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_20.Visible = True
		Me._chkSchedule_20.Name = "_chkSchedule_20"
		Me._chkSchedule_21.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_21.Text = "21-22"
		Me._chkSchedule_21.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_21.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_21.Location = New System.Drawing.Point(368, 56)
		Me._chkSchedule_21.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_21.TabIndex = 11
		Me._chkSchedule_21.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_21.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_21.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_21.CausesValidation = True
		Me._chkSchedule_21.Enabled = True
		Me._chkSchedule_21.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_21.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_21.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_21.TabStop = True
		Me._chkSchedule_21.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_21.Visible = True
		Me._chkSchedule_21.Name = "_chkSchedule_21"
		Me._chkSchedule_22.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me._chkSchedule_22.Text = "22-23"
		Me._chkSchedule_22.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._chkSchedule_22.Size = New System.Drawing.Size(37, 17)
		Me._chkSchedule_22.Location = New System.Drawing.Point(408, 56)
		Me._chkSchedule_22.Appearance = System.Windows.Forms.Appearance.Button
		Me._chkSchedule_22.TabIndex = 10
		Me._chkSchedule_22.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me._chkSchedule_22.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me._chkSchedule_22.BackColor = System.Drawing.SystemColors.Control
		Me._chkSchedule_22.CausesValidation = True
		Me._chkSchedule_22.Enabled = True
		Me._chkSchedule_22.ForeColor = System.Drawing.SystemColors.ControlText
		Me._chkSchedule_22.Cursor = System.Windows.Forms.Cursors.Default
		Me._chkSchedule_22.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._chkSchedule_22.TabStop = True
		Me._chkSchedule_22.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me._chkSchedule_22.Visible = True
		Me._chkSchedule_22.Name = "_chkSchedule_22"
		Me.chkStartPars.Text = "Start par2's / Refresh article list"
		Me.chkStartPars.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.chkStartPars.Size = New System.Drawing.Size(201, 21)
		Me.chkStartPars.Location = New System.Drawing.Point(16, 16)
		Me.chkStartPars.TabIndex = 33
		Me.chkStartPars.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.chkStartPars.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.chkStartPars.BackColor = System.Drawing.SystemColors.Control
		Me.chkStartPars.CausesValidation = True
		Me.chkStartPars.Enabled = True
		Me.chkStartPars.ForeColor = System.Drawing.SystemColors.ControlText
		Me.chkStartPars.Cursor = System.Windows.Forms.Cursors.Default
		Me.chkStartPars.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.chkStartPars.Appearance = System.Windows.Forms.Appearance.Normal
		Me.chkStartPars.TabStop = True
		Me.chkStartPars.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.chkStartPars.Visible = True
		Me.chkStartPars.Name = "chkStartPars"
		Me.fraDownloadPaths.Text = "Download Paths"
		Me.fraDownloadPaths.Font = New System.Drawing.Font("Arial Narrow", 9!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.fraDownloadPaths.Size = New System.Drawing.Size(489, 105)
		Me.fraDownloadPaths.Location = New System.Drawing.Point(8, 228)
		Me.fraDownloadPaths.TabIndex = 2
		Me.fraDownloadPaths.BackColor = System.Drawing.SystemColors.Control
		Me.fraDownloadPaths.Enabled = True
		Me.fraDownloadPaths.ForeColor = System.Drawing.SystemColors.ControlText
		Me.fraDownloadPaths.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.fraDownloadPaths.Visible = True
		Me.fraDownloadPaths.Padding = New System.Windows.Forms.Padding(0)
		Me.fraDownloadPaths.Name = "fraDownloadPaths"
		Me.cmdDatabasePath.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdDatabasePath.Text = ".."
		Me.cmdDatabasePath.Size = New System.Drawing.Size(17, 21)
		Me.cmdDatabasePath.Location = New System.Drawing.Point(464, 72)
		Me.cmdDatabasePath.TabIndex = 79
		Me.cmdDatabasePath.BackColor = System.Drawing.SystemColors.Control
		Me.cmdDatabasePath.CausesValidation = True
		Me.cmdDatabasePath.Enabled = True
		Me.cmdDatabasePath.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdDatabasePath.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdDatabasePath.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdDatabasePath.TabStop = True
		Me.cmdDatabasePath.Name = "cmdDatabasePath"
		Me.cmdPicturePath.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdPicturePath.Text = ".."
		Me.cmdPicturePath.Size = New System.Drawing.Size(17, 21)
		Me.cmdPicturePath.Location = New System.Drawing.Point(464, 44)
		Me.cmdPicturePath.TabIndex = 8
		Me.cmdPicturePath.BackColor = System.Drawing.SystemColors.Control
		Me.cmdPicturePath.CausesValidation = True
		Me.cmdPicturePath.Enabled = True
		Me.cmdPicturePath.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdPicturePath.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdPicturePath.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdPicturePath.TabStop = True
		Me.cmdPicturePath.Name = "cmdPicturePath"
		Me.cmdTempPath.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdTempPath.Text = ".."
		Me.cmdTempPath.Size = New System.Drawing.Size(17, 21)
		Me.cmdTempPath.Location = New System.Drawing.Point(464, 16)
		Me.cmdTempPath.TabIndex = 7
		Me.cmdTempPath.BackColor = System.Drawing.SystemColors.Control
		Me.cmdTempPath.CausesValidation = True
		Me.cmdTempPath.Enabled = True
		Me.cmdTempPath.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdTempPath.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdTempPath.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdTempPath.TabStop = True
		Me.cmdTempPath.Name = "cmdTempPath"
		TXTTempDownloadPath.OcxState = CType(resources.GetObject("TXTTempDownloadPath.OcxState"), System.Windows.Forms.AxHost.State)
		Me.TXTTempDownloadPath.Size = New System.Drawing.Size(337, 21)
		Me.TXTTempDownloadPath.Location = New System.Drawing.Point(120, 16)
		Me.TXTTempDownloadPath.TabIndex = 3
		Me.TXTTempDownloadPath.Name = "TXTTempDownloadPath"
		txtPicturePath.OcxState = CType(resources.GetObject("txtPicturePath.OcxState"), System.Windows.Forms.AxHost.State)
		Me.txtPicturePath.Size = New System.Drawing.Size(337, 21)
		Me.txtPicturePath.Location = New System.Drawing.Point(120, 44)
		Me.txtPicturePath.TabIndex = 5
		Me.txtPicturePath.Name = "txtPicturePath"
		txtDatabasePath.OcxState = CType(resources.GetObject("txtDatabasePath.OcxState"), System.Windows.Forms.AxHost.State)
		Me.txtDatabasePath.Size = New System.Drawing.Size(337, 21)
		Me.txtDatabasePath.Location = New System.Drawing.Point(120, 72)
		Me.txtDatabasePath.TabIndex = 80
		Me.txtDatabasePath.Name = "txtDatabasePath"
		Me._LBLZ1_9.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_9.Text = "Article Database"
		Me._LBLZ1_9.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_9.Size = New System.Drawing.Size(81, 17)
		Me._LBLZ1_9.Location = New System.Drawing.Point(32, 74)
		Me._LBLZ1_9.TabIndex = 81
		Me._LBLZ1_9.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_9.Enabled = True
		Me._LBLZ1_9.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_9.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_9.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_9.UseMnemonic = True
		Me._LBLZ1_9.Visible = True
		Me._LBLZ1_9.AutoSize = False
		Me._LBLZ1_9.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_9.Name = "_LBLZ1_9"
		Me._LBLZ1_6.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_6.Text = "Picture"
		Me._LBLZ1_6.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_6.Size = New System.Drawing.Size(57, 17)
		Me._LBLZ1_6.Location = New System.Drawing.Point(56, 46)
		Me._LBLZ1_6.TabIndex = 6
		Me._LBLZ1_6.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_6.Enabled = True
		Me._LBLZ1_6.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_6.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_6.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_6.UseMnemonic = True
		Me._LBLZ1_6.Visible = True
		Me._LBLZ1_6.AutoSize = False
		Me._LBLZ1_6.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_6.Name = "_LBLZ1_6"
		Me._LBLZ1_0.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_0.Text = "Temp"
		Me._LBLZ1_0.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_0.Size = New System.Drawing.Size(73, 17)
		Me._LBLZ1_0.Location = New System.Drawing.Point(40, 18)
		Me._LBLZ1_0.TabIndex = 4
		Me._LBLZ1_0.BackColor = System.Drawing.Color.Transparent
		Me._LBLZ1_0.Enabled = True
		Me._LBLZ1_0.ForeColor = System.Drawing.SystemColors.ControlText
		Me._LBLZ1_0.Cursor = System.Windows.Forms.Cursors.Default
		Me._LBLZ1_0.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LBLZ1_0.UseMnemonic = True
		Me._LBLZ1_0.Visible = True
		Me._LBLZ1_0.AutoSize = False
		Me._LBLZ1_0.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._LBLZ1_0.Name = "_LBLZ1_0"
		Me.CMDOK.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDOK.Text = "&OK"
		Me.CMDOK.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.CMDOK.Size = New System.Drawing.Size(73, 25)
		Me.CMDOK.Location = New System.Drawing.Point(8, 580)
		Me.CMDOK.TabIndex = 0
		Me.CMDOK.BackColor = System.Drawing.SystemColors.Control
		Me.CMDOK.CausesValidation = True
		Me.CMDOK.Enabled = True
		Me.CMDOK.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDOK.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDOK.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDOK.TabStop = True
		Me.CMDOK.Name = "CMDOK"
		Me.CMDExit.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDExit.Text = "E&xit"
		Me.CMDExit.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.CMDExit.Size = New System.Drawing.Size(73, 25)
		Me.CMDExit.Location = New System.Drawing.Point(424, 580)
		Me.CMDExit.TabIndex = 1
		Me.CMDExit.BackColor = System.Drawing.SystemColors.Control
		Me.CMDExit.CausesValidation = True
		Me.CMDExit.Enabled = True
		Me.CMDExit.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDExit.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDExit.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDExit.TabStop = True
		Me.CMDExit.Name = "CMDExit"
		Me.lblDBInfo.Size = New System.Drawing.Size(233, 17)
		Me.lblDBInfo.Location = New System.Drawing.Point(152, 572)
		Me.lblDBInfo.TabIndex = 78
		Me.lblDBInfo.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.lblDBInfo.BackColor = System.Drawing.SystemColors.Control
		Me.lblDBInfo.Enabled = True
		Me.lblDBInfo.ForeColor = System.Drawing.SystemColors.ControlText
		Me.lblDBInfo.Cursor = System.Windows.Forms.Cursors.Default
		Me.lblDBInfo.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.lblDBInfo.UseMnemonic = True
		Me.lblDBInfo.Visible = True
		Me.lblDBInfo.AutoSize = False
		Me.lblDBInfo.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.lblDBInfo.Name = "lblDBInfo"
		Me.LBLZ1.SetIndex(_LBLZ1_8, CType(8, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_10, CType(10, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_7, CType(7, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_5, CType(5, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_4, CType(4, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_3, CType(3, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_1, CType(1, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_2, CType(2, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_9, CType(9, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_6, CType(6, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_0, CType(0, Short))
		Me.chkDownload.SetIndex(_chkDownload_22, CType(22, Short))
		Me.chkDownload.SetIndex(_chkDownload_21, CType(21, Short))
		Me.chkDownload.SetIndex(_chkDownload_20, CType(20, Short))
		Me.chkDownload.SetIndex(_chkDownload_19, CType(19, Short))
		Me.chkDownload.SetIndex(_chkDownload_18, CType(18, Short))
		Me.chkDownload.SetIndex(_chkDownload_17, CType(17, Short))
		Me.chkDownload.SetIndex(_chkDownload_16, CType(16, Short))
		Me.chkDownload.SetIndex(_chkDownload_15, CType(15, Short))
		Me.chkDownload.SetIndex(_chkDownload_14, CType(14, Short))
		Me.chkDownload.SetIndex(_chkDownload_13, CType(13, Short))
		Me.chkDownload.SetIndex(_chkDownload_12, CType(12, Short))
		Me.chkDownload.SetIndex(_chkDownload_11, CType(11, Short))
		Me.chkDownload.SetIndex(_chkDownload_10, CType(10, Short))
		Me.chkDownload.SetIndex(_chkDownload_0, CType(0, Short))
		Me.chkDownload.SetIndex(_chkDownload_1, CType(1, Short))
		Me.chkDownload.SetIndex(_chkDownload_2, CType(2, Short))
		Me.chkDownload.SetIndex(_chkDownload_3, CType(3, Short))
		Me.chkDownload.SetIndex(_chkDownload_4, CType(4, Short))
		Me.chkDownload.SetIndex(_chkDownload_5, CType(5, Short))
		Me.chkDownload.SetIndex(_chkDownload_6, CType(6, Short))
		Me.chkDownload.SetIndex(_chkDownload_7, CType(7, Short))
		Me.chkDownload.SetIndex(_chkDownload_8, CType(8, Short))
		Me.chkDownload.SetIndex(_chkDownload_9, CType(9, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_9, CType(9, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_8, CType(8, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_7, CType(7, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_6, CType(6, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_5, CType(5, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_4, CType(4, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_3, CType(3, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_2, CType(2, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_1, CType(1, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_0, CType(0, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_10, CType(10, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_11, CType(11, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_12, CType(12, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_13, CType(13, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_14, CType(14, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_15, CType(15, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_16, CType(16, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_17, CType(17, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_18, CType(18, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_19, CType(19, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_20, CType(20, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_21, CType(21, Short))
		Me.chkSchedule.SetIndex(_chkSchedule_22, CType(22, Short))
		CType(Me.chkSchedule, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.chkDownload, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.LBLZ1, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.txtDatabasePath, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.txtPicturePath, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.TXTTempDownloadPath, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.TXTPassword, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.TXTUserName, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.TXTServerName, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.txtBackupPassword, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.txtBackupUsername, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.txtBackupServer, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.txtConnectionAttempts, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.txtMaxArticleAge, System.ComponentModel.ISupportInitialize).EndInit()
		Me.Controls.Add(fraMisc)
		Me.Controls.Add(fraDownloading)
		Me.Controls.Add(fraAutoFeatures)
		Me.Controls.Add(fraAlternateServer)
		Me.Controls.Add(fraPrimaryServer)
		Me.Controls.Add(fraSchedule)
		Me.Controls.Add(fraDownloadPaths)
		Me.Controls.Add(CMDOK)
		Me.Controls.Add(CMDExit)
		Me.Controls.Add(lblDBInfo)
		Me.fraMisc.Controls.Add(chkStatusVisible)
		Me.fraMisc.Controls.Add(txtMaxArticleAge)
		Me.fraMisc.Controls.Add(txtConnectionAttempts)
		Me.fraMisc.Controls.Add(_LBLZ1_8)
		Me.fraMisc.Controls.Add(_LBLZ1_10)
		Me.fraDownloading.Controls.Add(_chkDownload_22)
		Me.fraDownloading.Controls.Add(_chkDownload_21)
		Me.fraDownloading.Controls.Add(_chkDownload_20)
		Me.fraDownloading.Controls.Add(_chkDownload_19)
		Me.fraDownloading.Controls.Add(_chkDownload_18)
		Me.fraDownloading.Controls.Add(_chkDownload_17)
		Me.fraDownloading.Controls.Add(_chkDownload_16)
		Me.fraDownloading.Controls.Add(_chkDownload_15)
		Me.fraDownloading.Controls.Add(_chkDownload_14)
		Me.fraDownloading.Controls.Add(_chkDownload_13)
		Me.fraDownloading.Controls.Add(_chkDownload_12)
		Me.fraDownloading.Controls.Add(_chkDownload_11)
		Me.fraDownloading.Controls.Add(_chkDownload_10)
		Me.fraDownloading.Controls.Add(_chkDownload_0)
		Me.fraDownloading.Controls.Add(_chkDownload_1)
		Me.fraDownloading.Controls.Add(_chkDownload_2)
		Me.fraDownloading.Controls.Add(_chkDownload_3)
		Me.fraDownloading.Controls.Add(_chkDownload_4)
		Me.fraDownloading.Controls.Add(_chkDownload_5)
		Me.fraDownloading.Controls.Add(_chkDownload_6)
		Me.fraDownloading.Controls.Add(_chkDownload_7)
		Me.fraDownloading.Controls.Add(_chkDownload_8)
		Me.fraDownloading.Controls.Add(_chkDownload_9)
		Me.fraAutoFeatures.Controls.Add(chkFilterSVCD)
		Me.fraAutoFeatures.Controls.Add(chkFilterXVID)
		Me.fraAutoFeatures.Controls.Add(chkDownloadNfo)
		Me.fraAutoFeatures.Controls.Add(chkAutoDownloadJPG)
		Me.fraAlternateServer.Controls.Add(chkUseAlternateServer)
		Me.fraAlternateServer.Controls.Add(txtBackupServer)
		Me.fraAlternateServer.Controls.Add(txtBackupUsername)
		Me.fraAlternateServer.Controls.Add(txtBackupPassword)
		Me.fraAlternateServer.Controls.Add(_LBLZ1_7)
		Me.fraAlternateServer.Controls.Add(_LBLZ1_5)
		Me.fraAlternateServer.Controls.Add(_LBLZ1_4)
		Me.fraPrimaryServer.Controls.Add(TXTServerName)
		Me.fraPrimaryServer.Controls.Add(TXTUserName)
		Me.fraPrimaryServer.Controls.Add(TXTPassword)
		Me.fraPrimaryServer.Controls.Add(_LBLZ1_3)
		Me.fraPrimaryServer.Controls.Add(_LBLZ1_1)
		Me.fraPrimaryServer.Controls.Add(_LBLZ1_2)
		Me.fraSchedule.Controls.Add(_chkSchedule_9)
		Me.fraSchedule.Controls.Add(_chkSchedule_8)
		Me.fraSchedule.Controls.Add(_chkSchedule_7)
		Me.fraSchedule.Controls.Add(_chkSchedule_6)
		Me.fraSchedule.Controls.Add(_chkSchedule_5)
		Me.fraSchedule.Controls.Add(_chkSchedule_4)
		Me.fraSchedule.Controls.Add(_chkSchedule_3)
		Me.fraSchedule.Controls.Add(_chkSchedule_2)
		Me.fraSchedule.Controls.Add(_chkSchedule_1)
		Me.fraSchedule.Controls.Add(_chkSchedule_0)
		Me.fraSchedule.Controls.Add(_chkSchedule_10)
		Me.fraSchedule.Controls.Add(_chkSchedule_11)
		Me.fraSchedule.Controls.Add(_chkSchedule_12)
		Me.fraSchedule.Controls.Add(_chkSchedule_13)
		Me.fraSchedule.Controls.Add(_chkSchedule_14)
		Me.fraSchedule.Controls.Add(_chkSchedule_15)
		Me.fraSchedule.Controls.Add(_chkSchedule_16)
		Me.fraSchedule.Controls.Add(_chkSchedule_17)
		Me.fraSchedule.Controls.Add(_chkSchedule_18)
		Me.fraSchedule.Controls.Add(_chkSchedule_19)
		Me.fraSchedule.Controls.Add(_chkSchedule_20)
		Me.fraSchedule.Controls.Add(_chkSchedule_21)
		Me.fraSchedule.Controls.Add(_chkSchedule_22)
		Me.fraSchedule.Controls.Add(chkStartPars)
		Me.fraDownloadPaths.Controls.Add(cmdDatabasePath)
		Me.fraDownloadPaths.Controls.Add(cmdPicturePath)
		Me.fraDownloadPaths.Controls.Add(cmdTempPath)
		Me.fraDownloadPaths.Controls.Add(TXTTempDownloadPath)
		Me.fraDownloadPaths.Controls.Add(txtPicturePath)
		Me.fraDownloadPaths.Controls.Add(txtDatabasePath)
		Me.fraDownloadPaths.Controls.Add(_LBLZ1_9)
		Me.fraDownloadPaths.Controls.Add(_LBLZ1_6)
		Me.fraDownloadPaths.Controls.Add(_LBLZ1_0)
		Me.fraMisc.ResumeLayout(False)
		Me.fraDownloading.ResumeLayout(False)
		Me.fraAutoFeatures.ResumeLayout(False)
		Me.fraAlternateServer.ResumeLayout(False)
		Me.fraPrimaryServer.ResumeLayout(False)
		Me.fraSchedule.ResumeLayout(False)
		Me.fraDownloadPaths.ResumeLayout(False)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class