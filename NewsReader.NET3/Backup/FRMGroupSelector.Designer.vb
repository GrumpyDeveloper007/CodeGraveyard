<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class FRMAddRemoveGroups
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
	Public WithEvents GRDGroup As fpList
	Public WithEvents cmdSetDownloadPath As System.Windows.Forms.Button
	Public WithEvents CBOGroupType As System.Windows.Forms.ComboBox
	Public WithEvents CHKBinaries As System.Windows.Forms.CheckBox
	Public WithEvents CMDExit As System.Windows.Forms.Button
	Public WithEvents TXTFilter As AxELFTxtBox.AxTxtBox1
	Public WithEvents _LBLZ1_0 As System.Windows.Forms.Label
	Public WithEvents _LBLZ1_3 As System.Windows.Forms.Label
	Public WithEvents LBLZ1 As Microsoft.VisualBasic.Compatibility.VB6.LabelArray
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(FRMAddRemoveGroups))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.GRDGroup = New fpList
		Me.cmdSetDownloadPath = New System.Windows.Forms.Button
		Me.CBOGroupType = New System.Windows.Forms.ComboBox
		Me.CHKBinaries = New System.Windows.Forms.CheckBox
		Me.CMDExit = New System.Windows.Forms.Button
		Me.TXTFilter = New AxELFTxtBox.AxTxtBox1
		Me._LBLZ1_0 = New System.Windows.Forms.Label
		Me._LBLZ1_3 = New System.Windows.Forms.Label
		Me.LBLZ1 = New Microsoft.VisualBasic.Compatibility.VB6.LabelArray(components)
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		CType(Me.TXTFilter, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.LBLZ1, System.ComponentModel.ISupportInitialize).BeginInit()
		Me.Text = "Add / Remove groups"
		Me.ClientSize = New System.Drawing.Size(612, 595)
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
		Me.Name = "FRMAddRemoveGroups"
		Me.GRDGroup.Size = New System.Drawing.Size(601, 509)
		Me.GRDGroup.Location = New System.Drawing.Point(8, 56)
		Me.GRDGroup.TabIndex = 2
		Me.GRDGroup.Enabled = -1
		Me.GRDGroup.MousePointer = 0
		Me.GRDGroup.TabStop = 0
		Me.GRDGroup.BackColor = -2147483643
		Me.GRDGroup.ForeColor = -2147483640
		Me.GRDGroup.Columns = 2
		Me.GRDGroup.Sorted = 0
		Me.GRDGroup.LineWidth = 1
		Me.GRDGroup.SelDrawFocusRect = -1
		Me.GRDGroup.ColumnSeparatorChar = 9
		Me.GRDGroup.ColumnSearch = -1
		Me.GRDGroup.ColumnWidthScale = 0
		Me.GRDGroup.RowHeight = -1
		Me.GRDGroup.MultiSelect = 2
		Me.GRDGroup.WrapList = 0
		Me.GRDGroup.WrapWidth = 0
		Me.GRDGroup.SelMax = -1
		Me.GRDGroup.AutoSearch = 0
		Me.GRDGroup.SearchMethod = 0
		Me.GRDGroup.VirtualMode = 0
		Me.GRDGroup.VRowCount = 0
		Me.GRDGroup.DataSync = 3
		Me.GRDGroup.ThreeDInsideStyle = 1
		Me.GRDGroup.ThreeDInsideHighlightColor = -2147483633
		Me.GRDGroup.ThreeDInsideShadowColor = -2147483642
		Me.GRDGroup.ThreeDInsideWidth = 1
		Me.GRDGroup.ThreeDOutsideStyle = 1
		Me.GRDGroup.ThreeDOutsideHighlightColor = 16777215
		Me.GRDGroup.ThreeDOutsideShadowColor = -2147483632
		Me.GRDGroup.ThreeDOutsideWidth = 1
		Me.GRDGroup.ThreeDFrameWidth = 0
		Me.GRDGroup.BorderStyle = 0
		Me.GRDGroup.BorderColor = -2147483642
		Me.GRDGroup.BorderWidth = 1
		Me.GRDGroup.ThreeDOnFocusInvert = 0
		Me.GRDGroup.ThreeDFrameColor = -2147483633
		Me.GRDGroup.Appearance = 0
		Me.GRDGroup.BorderDropShadow = 0
		Me.GRDGroup.BorderDropShadowColor = -2147483632
		Me.GRDGroup.BorderDropShadowWidth = 3
		Me.GRDGroup.ScrollHScale = 2
		Me.GRDGroup.ScrollHInc = 0
		Me.GRDGroup.ColsFrozen = 0
		Me.GRDGroup.ScrollBarV = 2
		Me.GRDGroup.NoIntegralHeight = 0
		Me.GRDGroup.HighestPrecedence = 0
		Me.GRDGroup.AllowColResize = 1
		Me.GRDGroup.AllowColDragDrop = 0
		Me.GRDGroup.ReadOnly = 0
		Me.GRDGroup.VScrollSpecial = 0
		Me.GRDGroup.VScrollSpecialType = 0
		Me.GRDGroup.EnableKeyEvents = -1
		Me.GRDGroup.EnableTopChangeEvent = -1
		Me.GRDGroup.DataAutoHeadings = -1
		Me.GRDGroup.DataAutoSizeCols = 2
		Me.GRDGroup.SearchIgnoreCase = -1
		Me.GRDGroup.ScrollBarH = 3
		Me.GRDGroup.VirtualPageSize = 0
		Me.GRDGroup.VirtualPagesAhead = 0
		Me.GRDGroup.ExtendCol = 0
		Me.GRDGroup.ColumnLevels = 1
		Me.GRDGroup.ListGrayAreaColor = -2147483637
		Me.GRDGroup.GroupHeaderHeight = -1
		Me.GRDGroup.GroupHeaderShow = -1
		Me.GRDGroup.AllowGrpResize = 0
		Me.GRDGroup.AllowGrpDragDrop = 0
		Me.GRDGroup.MergeAdjustView = 0
		Me.GRDGroup.ColumnHeaderShow = -1
		Me.GRDGroup.ColumnHeaderHeight = -1
		Me.GRDGroup.GrpsFrozen = 0
		Me.GRDGroup.BorderGrayAreaColor = -2147483637
		Me.GRDGroup.ExtendRow = 0
		Me.GRDGroup.DataField = ""
		Me.GRDGroup.OLEDragMode = 0
		Me.GRDGroup.OLEDropMode = 0
		Me.GRDGroup.Redraw = -1
		Me.GRDGroup.ResizeRowToFont = 0
		Me.GRDGroup.TextTipMultiLine = 0
		Me.GRDGroup.Name = "GRDGroup"
		Me.cmdSetDownloadPath.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdSetDownloadPath.Text = "Set Download Path"
		Me.cmdSetDownloadPath.Size = New System.Drawing.Size(105, 21)
		Me.cmdSetDownloadPath.Location = New System.Drawing.Point(304, 4)
		Me.cmdSetDownloadPath.TabIndex = 6
		Me.cmdSetDownloadPath.BackColor = System.Drawing.SystemColors.Control
		Me.cmdSetDownloadPath.CausesValidation = True
		Me.cmdSetDownloadPath.Enabled = True
		Me.cmdSetDownloadPath.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdSetDownloadPath.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdSetDownloadPath.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdSetDownloadPath.TabStop = True
		Me.cmdSetDownloadPath.Name = "cmdSetDownloadPath"
		Me.CBOGroupType.Size = New System.Drawing.Size(241, 21)
		Me.CBOGroupType.Location = New System.Drawing.Point(48, 4)
		Me.CBOGroupType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
		Me.CBOGroupType.TabIndex = 5
		Me.CBOGroupType.BackColor = System.Drawing.SystemColors.Window
		Me.CBOGroupType.CausesValidation = True
		Me.CBOGroupType.Enabled = True
		Me.CBOGroupType.ForeColor = System.Drawing.SystemColors.WindowText
		Me.CBOGroupType.IntegralHeight = True
		Me.CBOGroupType.Cursor = System.Windows.Forms.Cursors.Default
		Me.CBOGroupType.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CBOGroupType.Sorted = False
		Me.CBOGroupType.TabStop = True
		Me.CBOGroupType.Visible = True
		Me.CBOGroupType.Name = "CBOGroupType"
		Me.CHKBinaries.Text = "Only Binaries"
		Me.CHKBinaries.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.CHKBinaries.Size = New System.Drawing.Size(81, 21)
		Me.CHKBinaries.Location = New System.Drawing.Point(528, 32)
		Me.CHKBinaries.TabIndex = 4
		Me.CHKBinaries.CheckState = System.Windows.Forms.CheckState.Checked
		Me.CHKBinaries.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.CHKBinaries.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.CHKBinaries.BackColor = System.Drawing.SystemColors.Control
		Me.CHKBinaries.CausesValidation = True
		Me.CHKBinaries.Enabled = True
		Me.CHKBinaries.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CHKBinaries.Cursor = System.Windows.Forms.Cursors.Default
		Me.CHKBinaries.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CHKBinaries.Appearance = System.Windows.Forms.Appearance.Normal
		Me.CHKBinaries.TabStop = True
		Me.CHKBinaries.Visible = True
		Me.CHKBinaries.Name = "CHKBinaries"
		Me.CMDExit.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDExit.Text = "E&xit"
		Me.CMDExit.Size = New System.Drawing.Size(73, 25)
		Me.CMDExit.Location = New System.Drawing.Point(536, 568)
		Me.CMDExit.TabIndex = 1
		Me.CMDExit.BackColor = System.Drawing.SystemColors.Control
		Me.CMDExit.CausesValidation = True
		Me.CMDExit.Enabled = True
		Me.CMDExit.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDExit.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDExit.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDExit.TabStop = True
		Me.CMDExit.Name = "CMDExit"
		TXTFilter.OcxState = CType(resources.GetObject("TXTFilter.OcxState"), System.Windows.Forms.AxHost.State)
		Me.TXTFilter.Size = New System.Drawing.Size(473, 21)
		Me.TXTFilter.Location = New System.Drawing.Point(48, 28)
		Me.TXTFilter.TabIndex = 0
		Me.TXTFilter.Name = "TXTFilter"
		Me._LBLZ1_0.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_0.Text = "Type"
		Me._LBLZ1_0.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_0.Size = New System.Drawing.Size(33, 17)
		Me._LBLZ1_0.Location = New System.Drawing.Point(8, 8)
		Me._LBLZ1_0.TabIndex = 7
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
		Me._LBLZ1_3.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_3.Text = "Filter"
		Me._LBLZ1_3.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_3.Size = New System.Drawing.Size(33, 17)
		Me._LBLZ1_3.Location = New System.Drawing.Point(8, 30)
		Me._LBLZ1_3.TabIndex = 3
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
		Me.LBLZ1.SetIndex(_LBLZ1_0, CType(0, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_3, CType(3, Short))
		CType(Me.LBLZ1, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.TXTFilter, System.ComponentModel.ISupportInitialize).EndInit()
		Me.Controls.Add(GRDGroup)
		Me.Controls.Add(cmdSetDownloadPath)
		Me.Controls.Add(CBOGroupType)
		Me.Controls.Add(CHKBinaries)
		Me.Controls.Add(CMDExit)
		Me.Controls.Add(TXTFilter)
		Me.Controls.Add(_LBLZ1_0)
		Me.Controls.Add(_LBLZ1_3)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class