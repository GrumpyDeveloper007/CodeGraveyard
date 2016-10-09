<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class FRMViewFiles
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
	Public WithEvents GRDFile As fpList
	Public WithEvents PICFileExists As System.Windows.Forms.PictureBox
	Public WithEvents PICFileInQueue As System.Windows.Forms.PictureBox
	Public WithEvents PICDownloadComplete As System.Windows.Forms.PictureBox
	Public WithEvents PICIncompleteFile As System.Windows.Forms.PictureBox
	Public WithEvents PICPaused As System.Windows.Forms.PictureBox
	Public WithEvents CBOOrderBy As System.Windows.Forms.ComboBox
	Public WithEvents CBOShowMethod As System.Windows.Forms.ComboBox
	Public WithEvents CHKShowAll As System.Windows.Forms.CheckBox
	Public WithEvents CMDShowAllFiles As System.Windows.Forms.Button
	Public WithEvents CMDExit As System.Windows.Forms.Button
	Public WithEvents PICDownloading As System.Windows.Forms.PictureBox
	Public WithEvents LBLRecordCount As System.Windows.Forms.Label
	Public WithEvents Label1 As System.Windows.Forms.Label
	Public WithEvents Label2 As System.Windows.Forms.Label
	Public WithEvents Label3 As System.Windows.Forms.Label
	Public WithEvents Label4 As System.Windows.Forms.Label
	Public WithEvents Label6 As System.Windows.Forms.Label
	Public WithEvents Label5 As System.Windows.Forms.Label
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(FRMViewFiles))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.GRDFile = New fpList
		Me.PICFileExists = New System.Windows.Forms.PictureBox
		Me.PICFileInQueue = New System.Windows.Forms.PictureBox
		Me.PICDownloadComplete = New System.Windows.Forms.PictureBox
		Me.PICIncompleteFile = New System.Windows.Forms.PictureBox
		Me.PICPaused = New System.Windows.Forms.PictureBox
		Me.CBOOrderBy = New System.Windows.Forms.ComboBox
		Me.CBOShowMethod = New System.Windows.Forms.ComboBox
		Me.CHKShowAll = New System.Windows.Forms.CheckBox
		Me.CMDShowAllFiles = New System.Windows.Forms.Button
		Me.CMDExit = New System.Windows.Forms.Button
		Me.PICDownloading = New System.Windows.Forms.PictureBox
		Me.LBLRecordCount = New System.Windows.Forms.Label
		Me.Label1 = New System.Windows.Forms.Label
		Me.Label2 = New System.Windows.Forms.Label
		Me.Label3 = New System.Windows.Forms.Label
		Me.Label4 = New System.Windows.Forms.Label
		Me.Label6 = New System.Windows.Forms.Label
		Me.Label5 = New System.Windows.Forms.Label
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		Me.Text = "View Files"
		Me.ClientSize = New System.Drawing.Size(1013, 573)
		Me.Location = New System.Drawing.Point(4, 23)
		Me.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultBounds
		Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
		Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		Me.BackColor = System.Drawing.SystemColors.Control
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
		Me.ControlBox = True
		Me.Enabled = True
		Me.KeyPreview = False
		Me.MaximizeBox = True
		Me.MinimizeBox = True
		Me.Cursor = System.Windows.Forms.Cursors.Default
		Me.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.ShowInTaskbar = True
		Me.HelpButton = False
		Me.Name = "FRMViewFiles"
		Me.GRDFile.Size = New System.Drawing.Size(1009, 495)
		Me.GRDFile.Location = New System.Drawing.Point(0, 24)
		Me.GRDFile.TabIndex = 1
		Me.GRDFile.Enabled = -1
		Me.GRDFile.MousePointer = 0
		Me.GRDFile.TabStop = 0
		Me.GRDFile.BackColor = -2147483643
		Me.GRDFile.ForeColor = -2147483640
		Me.GRDFile.Columns = 8
		Me.GRDFile.Sorted = 0
		Me.GRDFile.LineWidth = 1
		Me.GRDFile.SelDrawFocusRect = -1
		Me.GRDFile.ColumnSeparatorChar = 9
		Me.GRDFile.ColumnSearch = 2
		Me.GRDFile.ColumnWidthScale = 0
		Me.GRDFile.RowHeight = -1
		Me.GRDFile.MultiSelect = 2
		Me.GRDFile.WrapList = 0
		Me.GRDFile.WrapWidth = 0
		Me.GRDFile.SelMax = -1
		Me.GRDFile.AutoSearch = 2
		Me.GRDFile.SearchMethod = 0
		Me.GRDFile.VirtualMode = 0
		Me.GRDFile.VRowCount = 0
		Me.GRDFile.DataSync = 3
		Me.GRDFile.ThreeDInsideStyle = 1
		Me.GRDFile.ThreeDInsideHighlightColor = -2147483633
		Me.GRDFile.ThreeDInsideShadowColor = -2147483642
		Me.GRDFile.ThreeDInsideWidth = 1
		Me.GRDFile.ThreeDOutsideStyle = 1
		Me.GRDFile.ThreeDOutsideHighlightColor = 16777215
		Me.GRDFile.ThreeDOutsideShadowColor = -2147483632
		Me.GRDFile.ThreeDOutsideWidth = 1
		Me.GRDFile.ThreeDFrameWidth = 0
		Me.GRDFile.BorderStyle = 0
		Me.GRDFile.BorderColor = -2147483642
		Me.GRDFile.BorderWidth = 1
		Me.GRDFile.ThreeDOnFocusInvert = 0
		Me.GRDFile.ThreeDFrameColor = -2147483633
		Me.GRDFile.Appearance = 0
		Me.GRDFile.BorderDropShadow = 0
		Me.GRDFile.BorderDropShadowColor = -2147483632
		Me.GRDFile.BorderDropShadowWidth = 3
		Me.GRDFile.ScrollHScale = 2
		Me.GRDFile.ScrollHInc = 0
		Me.GRDFile.ColsFrozen = 0
		Me.GRDFile.ScrollBarV = 2
		Me.GRDFile.NoIntegralHeight = 0
		Me.GRDFile.HighestPrecedence = 0
		Me.GRDFile.AllowColResize = 1
		Me.GRDFile.AllowColDragDrop = 0
		Me.GRDFile.ReadOnly = 0
		Me.GRDFile.VScrollSpecial = 0
		Me.GRDFile.VScrollSpecialType = 0
		Me.GRDFile.EnableKeyEvents = -1
		Me.GRDFile.EnableTopChangeEvent = -1
		Me.GRDFile.DataAutoHeadings = -1
		Me.GRDFile.DataAutoSizeCols = 2
		Me.GRDFile.SearchIgnoreCase = -1
		Me.GRDFile.ScrollBarH = 3
		Me.GRDFile.VirtualPageSize = 0
		Me.GRDFile.VirtualPagesAhead = 0
		Me.GRDFile.ExtendCol = 0
		Me.GRDFile.ColumnLevels = 1
		Me.GRDFile.ListGrayAreaColor = -2147483637
		Me.GRDFile.GroupHeaderHeight = -1
		Me.GRDFile.GroupHeaderShow = -1
		Me.GRDFile.AllowGrpResize = 0
		Me.GRDFile.AllowGrpDragDrop = 0
		Me.GRDFile.MergeAdjustView = 0
		Me.GRDFile.ColumnHeaderShow = -1
		Me.GRDFile.ColumnHeaderHeight = -1
		Me.GRDFile.GrpsFrozen = 0
		Me.GRDFile.BorderGrayAreaColor = -2147483637
		Me.GRDFile.ExtendRow = 0
		Me.GRDFile.DataField = ""
		Me.GRDFile.OLEDragMode = 0
		Me.GRDFile.OLEDropMode = 0
		Me.GRDFile.Redraw = -1
		Me.GRDFile.ResizeRowToFont = 0
		Me.GRDFile.TextTipMultiLine = 0
		Me.GRDFile.Name = "GRDFile"
		Me.PICFileExists.BackColor = System.Drawing.Color.FromARGB(127, 127, 0)
		Me.PICFileExists.Size = New System.Drawing.Size(17, 17)
		Me.PICFileExists.Location = New System.Drawing.Point(400, 0)
		Me.PICFileExists.TabIndex = 13
		Me.PICFileExists.Dock = System.Windows.Forms.DockStyle.None
		Me.PICFileExists.CausesValidation = True
		Me.PICFileExists.Enabled = True
		Me.PICFileExists.ForeColor = System.Drawing.SystemColors.ControlText
		Me.PICFileExists.Cursor = System.Windows.Forms.Cursors.Default
		Me.PICFileExists.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.PICFileExists.TabStop = True
		Me.PICFileExists.Visible = True
		Me.PICFileExists.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
		Me.PICFileExists.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.PICFileExists.Name = "PICFileExists"
		Me.PICFileInQueue.BackColor = System.Drawing.Color.Yellow
		Me.PICFileInQueue.Size = New System.Drawing.Size(17, 17)
		Me.PICFileInQueue.Location = New System.Drawing.Point(464, 0)
		Me.PICFileInQueue.TabIndex = 12
		Me.PICFileInQueue.Dock = System.Windows.Forms.DockStyle.None
		Me.PICFileInQueue.CausesValidation = True
		Me.PICFileInQueue.Enabled = True
		Me.PICFileInQueue.ForeColor = System.Drawing.SystemColors.ControlText
		Me.PICFileInQueue.Cursor = System.Windows.Forms.Cursors.Default
		Me.PICFileInQueue.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.PICFileInQueue.TabStop = True
		Me.PICFileInQueue.Visible = True
		Me.PICFileInQueue.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
		Me.PICFileInQueue.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.PICFileInQueue.Name = "PICFileInQueue"
		Me.PICDownloadComplete.BackColor = System.Drawing.Color.FromARGB(192, 192, 255)
		Me.PICDownloadComplete.Size = New System.Drawing.Size(17, 17)
		Me.PICDownloadComplete.Location = New System.Drawing.Point(544, 0)
		Me.PICDownloadComplete.TabIndex = 11
		Me.PICDownloadComplete.Dock = System.Windows.Forms.DockStyle.None
		Me.PICDownloadComplete.CausesValidation = True
		Me.PICDownloadComplete.Enabled = True
		Me.PICDownloadComplete.ForeColor = System.Drawing.SystemColors.ControlText
		Me.PICDownloadComplete.Cursor = System.Windows.Forms.Cursors.Default
		Me.PICDownloadComplete.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.PICDownloadComplete.TabStop = True
		Me.PICDownloadComplete.Visible = True
		Me.PICDownloadComplete.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
		Me.PICDownloadComplete.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.PICDownloadComplete.Name = "PICDownloadComplete"
		Me.PICIncompleteFile.BackColor = System.Drawing.Color.Red
		Me.PICIncompleteFile.Size = New System.Drawing.Size(17, 17)
		Me.PICIncompleteFile.Location = New System.Drawing.Point(656, 0)
		Me.PICIncompleteFile.TabIndex = 10
		Me.PICIncompleteFile.Dock = System.Windows.Forms.DockStyle.None
		Me.PICIncompleteFile.CausesValidation = True
		Me.PICIncompleteFile.Enabled = True
		Me.PICIncompleteFile.ForeColor = System.Drawing.SystemColors.ControlText
		Me.PICIncompleteFile.Cursor = System.Windows.Forms.Cursors.Default
		Me.PICIncompleteFile.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.PICIncompleteFile.TabStop = True
		Me.PICIncompleteFile.Visible = True
		Me.PICIncompleteFile.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
		Me.PICIncompleteFile.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.PICIncompleteFile.Name = "PICIncompleteFile"
		Me.PICPaused.BackColor = System.Drawing.Color.FromARGB(127, 127, 127)
		Me.PICPaused.Size = New System.Drawing.Size(17, 17)
		Me.PICPaused.Location = New System.Drawing.Point(736, 0)
		Me.PICPaused.TabIndex = 6
		Me.PICPaused.Dock = System.Windows.Forms.DockStyle.None
		Me.PICPaused.CausesValidation = True
		Me.PICPaused.Enabled = True
		Me.PICPaused.ForeColor = System.Drawing.SystemColors.ControlText
		Me.PICPaused.Cursor = System.Windows.Forms.Cursors.Default
		Me.PICPaused.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.PICPaused.TabStop = True
		Me.PICPaused.Visible = True
		Me.PICPaused.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
		Me.PICPaused.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.PICPaused.Name = "PICPaused"
		Me.CBOOrderBy.Size = New System.Drawing.Size(73, 21)
		Me.CBOOrderBy.Location = New System.Drawing.Point(260, 0)
		Me.CBOOrderBy.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
		Me.CBOOrderBy.TabIndex = 5
		Me.CBOOrderBy.BackColor = System.Drawing.SystemColors.Window
		Me.CBOOrderBy.CausesValidation = True
		Me.CBOOrderBy.Enabled = True
		Me.CBOOrderBy.ForeColor = System.Drawing.SystemColors.WindowText
		Me.CBOOrderBy.IntegralHeight = True
		Me.CBOOrderBy.Cursor = System.Windows.Forms.Cursors.Default
		Me.CBOOrderBy.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CBOOrderBy.Sorted = False
		Me.CBOOrderBy.TabStop = True
		Me.CBOOrderBy.Visible = True
		Me.CBOOrderBy.Name = "CBOOrderBy"
		Me.CBOShowMethod.Size = New System.Drawing.Size(177, 21)
		Me.CBOShowMethod.Location = New System.Drawing.Point(82, 0)
		Me.CBOShowMethod.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
		Me.CBOShowMethod.TabIndex = 4
		Me.CBOShowMethod.BackColor = System.Drawing.SystemColors.Window
		Me.CBOShowMethod.CausesValidation = True
		Me.CBOShowMethod.Enabled = True
		Me.CBOShowMethod.ForeColor = System.Drawing.SystemColors.WindowText
		Me.CBOShowMethod.IntegralHeight = True
		Me.CBOShowMethod.Cursor = System.Windows.Forms.Cursors.Default
		Me.CBOShowMethod.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CBOShowMethod.Sorted = False
		Me.CBOShowMethod.TabStop = True
		Me.CBOShowMethod.Visible = True
		Me.CBOShowMethod.Name = "CBOShowMethod"
		Me.CHKShowAll.Text = "Show All"
		Me.CHKShowAll.Size = New System.Drawing.Size(65, 17)
		Me.CHKShowAll.Location = New System.Drawing.Point(336, 0)
		Me.CHKShowAll.TabIndex = 3
		Me.CHKShowAll.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.CHKShowAll.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.CHKShowAll.BackColor = System.Drawing.SystemColors.Control
		Me.CHKShowAll.CausesValidation = True
		Me.CHKShowAll.Enabled = True
		Me.CHKShowAll.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CHKShowAll.Cursor = System.Windows.Forms.Cursors.Default
		Me.CHKShowAll.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CHKShowAll.Appearance = System.Windows.Forms.Appearance.Normal
		Me.CHKShowAll.TabStop = True
		Me.CHKShowAll.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.CHKShowAll.Visible = True
		Me.CHKShowAll.Name = "CHKShowAll"
		Me.CMDShowAllFiles.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDShowAllFiles.Text = "Refresh"
		Me.CMDShowAllFiles.Size = New System.Drawing.Size(81, 21)
		Me.CMDShowAllFiles.Location = New System.Drawing.Point(0, 0)
		Me.CMDShowAllFiles.TabIndex = 2
		Me.CMDShowAllFiles.BackColor = System.Drawing.SystemColors.Control
		Me.CMDShowAllFiles.CausesValidation = True
		Me.CMDShowAllFiles.Enabled = True
		Me.CMDShowAllFiles.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDShowAllFiles.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDShowAllFiles.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDShowAllFiles.TabStop = True
		Me.CMDShowAllFiles.Name = "CMDShowAllFiles"
		Me.CMDExit.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDExit.Text = "E&xit"
		Me.CMDExit.Size = New System.Drawing.Size(65, 17)
		Me.CMDExit.Location = New System.Drawing.Point(944, 0)
		Me.CMDExit.TabIndex = 0
		Me.CMDExit.BackColor = System.Drawing.SystemColors.Control
		Me.CMDExit.CausesValidation = True
		Me.CMDExit.Enabled = True
		Me.CMDExit.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDExit.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDExit.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDExit.TabStop = True
		Me.CMDExit.Name = "CMDExit"
		Me.PICDownloading.BackColor = System.Drawing.Color.FromARGB(255, 128, 255)
		Me.PICDownloading.Size = New System.Drawing.Size(17, 17)
		Me.PICDownloading.Location = New System.Drawing.Point(808, 0)
		Me.PICDownloading.TabIndex = 8
		Me.PICDownloading.Dock = System.Windows.Forms.DockStyle.None
		Me.PICDownloading.CausesValidation = True
		Me.PICDownloading.Enabled = True
		Me.PICDownloading.ForeColor = System.Drawing.SystemColors.ControlText
		Me.PICDownloading.Cursor = System.Windows.Forms.Cursors.Default
		Me.PICDownloading.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.PICDownloading.TabStop = True
		Me.PICDownloading.Visible = True
		Me.PICDownloading.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
		Me.PICDownloading.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.PICDownloading.Name = "PICDownloading"
		Me.LBLRecordCount.Size = New System.Drawing.Size(41, 17)
		Me.LBLRecordCount.Location = New System.Drawing.Point(896, 0)
		Me.LBLRecordCount.TabIndex = 18
		Me.LBLRecordCount.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.LBLRecordCount.BackColor = System.Drawing.SystemColors.Control
		Me.LBLRecordCount.Enabled = True
		Me.LBLRecordCount.ForeColor = System.Drawing.SystemColors.ControlText
		Me.LBLRecordCount.Cursor = System.Windows.Forms.Cursors.Default
		Me.LBLRecordCount.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.LBLRecordCount.UseMnemonic = True
		Me.LBLRecordCount.Visible = True
		Me.LBLRecordCount.AutoSize = False
		Me.LBLRecordCount.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.LBLRecordCount.Name = "LBLRecordCount"
		Me.Label1.Text = "File Exits"
		Me.Label1.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Label1.Size = New System.Drawing.Size(41, 21)
		Me.Label1.Location = New System.Drawing.Point(420, 0)
		Me.Label1.TabIndex = 17
		Me.Label1.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label1.BackColor = System.Drawing.SystemColors.Control
		Me.Label1.Enabled = True
		Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label1.UseMnemonic = True
		Me.Label1.Visible = True
		Me.Label1.AutoSize = False
		Me.Label1.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label1.Name = "Label1"
		Me.Label2.Text = "File In queue"
		Me.Label2.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Label2.Size = New System.Drawing.Size(57, 21)
		Me.Label2.Location = New System.Drawing.Point(484, 0)
		Me.Label2.TabIndex = 16
		Me.Label2.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label2.BackColor = System.Drawing.SystemColors.Control
		Me.Label2.Enabled = True
		Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label2.UseMnemonic = True
		Me.Label2.Visible = True
		Me.Label2.AutoSize = False
		Me.Label2.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label2.Name = "Label2"
		Me.Label3.Text = "Download Complete"
		Me.Label3.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Label3.Size = New System.Drawing.Size(89, 21)
		Me.Label3.Location = New System.Drawing.Point(564, 0)
		Me.Label3.TabIndex = 15
		Me.Label3.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label3.BackColor = System.Drawing.SystemColors.Control
		Me.Label3.Enabled = True
		Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label3.UseMnemonic = True
		Me.Label3.Visible = True
		Me.Label3.AutoSize = False
		Me.Label3.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label3.Name = "Label3"
		Me.Label4.Text = "Incomplete"
		Me.Label4.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Label4.Size = New System.Drawing.Size(49, 21)
		Me.Label4.Location = New System.Drawing.Point(680, 0)
		Me.Label4.TabIndex = 14
		Me.Label4.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label4.BackColor = System.Drawing.SystemColors.Control
		Me.Label4.Enabled = True
		Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label4.UseMnemonic = True
		Me.Label4.Visible = True
		Me.Label4.AutoSize = False
		Me.Label4.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label4.Name = "Label4"
		Me.Label6.Text = "Downloading"
		Me.Label6.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Label6.Size = New System.Drawing.Size(57, 21)
		Me.Label6.Location = New System.Drawing.Point(832, 0)
		Me.Label6.TabIndex = 9
		Me.Label6.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label6.BackColor = System.Drawing.SystemColors.Control
		Me.Label6.Enabled = True
		Me.Label6.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label6.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label6.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label6.UseMnemonic = True
		Me.Label6.Visible = True
		Me.Label6.AutoSize = False
		Me.Label6.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label6.Name = "Label6"
		Me.Label5.Text = "Paused"
		Me.Label5.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Label5.Size = New System.Drawing.Size(41, 21)
		Me.Label5.Location = New System.Drawing.Point(760, 0)
		Me.Label5.TabIndex = 7
		Me.Label5.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label5.BackColor = System.Drawing.SystemColors.Control
		Me.Label5.Enabled = True
		Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label5.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label5.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label5.UseMnemonic = True
		Me.Label5.Visible = True
		Me.Label5.AutoSize = False
		Me.Label5.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label5.Name = "Label5"
		Me.Controls.Add(GRDFile)
		Me.Controls.Add(PICFileExists)
		Me.Controls.Add(PICFileInQueue)
		Me.Controls.Add(PICDownloadComplete)
		Me.Controls.Add(PICIncompleteFile)
		Me.Controls.Add(PICPaused)
		Me.Controls.Add(CBOOrderBy)
		Me.Controls.Add(CBOShowMethod)
		Me.Controls.Add(CHKShowAll)
		Me.Controls.Add(CMDShowAllFiles)
		Me.Controls.Add(CMDExit)
		Me.Controls.Add(PICDownloading)
		Me.Controls.Add(LBLRecordCount)
		Me.Controls.Add(Label1)
		Me.Controls.Add(Label2)
		Me.Controls.Add(Label3)
		Me.Controls.Add(Label4)
		Me.Controls.Add(Label6)
		Me.Controls.Add(Label5)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class