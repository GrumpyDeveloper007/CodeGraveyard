<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class FRMMain
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
	Public WithEvents GRDBitmap As fpList
	Public WithEvents grdBitmapSmall As fpList
	Public WithEvents cmdPar As System.Windows.Forms.Button
	Public WithEvents chkautofix As System.Windows.Forms.CheckBox
	Public WithEvents _LSTTx_7 As System.Windows.Forms.ListBox
	Public WithEvents _LSTTx_6 As System.Windows.Forms.ListBox
	Public WithEvents _LSTTx_5 As System.Windows.Forms.ListBox
	Public WithEvents _LSTTx_4 As System.Windows.Forms.ListBox
	Public WithEvents _LSTTx_3 As System.Windows.Forms.ListBox
	Public WithEvents CBONewsGroup As System.Windows.Forms.ComboBox
	Public WithEvents _LSTTx_2 As System.Windows.Forms.ListBox
	Public WithEvents _LSTTx_1 As System.Windows.Forms.ListBox
	Public WithEvents CMDClear As System.Windows.Forms.Button
	Public WithEvents Frame1 As System.Windows.Forms.GroupBox
	Public WithEvents FRADownloadOptions As System.Windows.Forms.GroupBox
	Public WithEvents CMDDownloadFiles As System.Windows.Forms.Button
	Public WithEvents CMDViewFiles As System.Windows.Forms.Button
	Public WithEvents CMDGetAllGroups As System.Windows.Forms.Button
	Public WithEvents Tmr As System.Windows.Forms.Timer
	Public WithEvents CMDGetNewArticles As System.Windows.Forms.Button
	Public WithEvents _TXTrx_0 As System.Windows.Forms.TextBox
	Public WithEvents _LSTTx_0 As System.Windows.Forms.ListBox
	Public WithEvents Winsock1 As Winsock
	Public WithEvents _lblFilename_1 As System.Windows.Forms.Label
	Public WithEvents _lblFilename_0 As System.Windows.Forms.Label
	Public WithEvents Label4 As System.Windows.Forms.Label
	Public WithEvents LBLWinsockState As System.Windows.Forms.Label
	Public WithEvents LSTTx As Microsoft.VisualBasic.Compatibility.VB6.ListBoxArray
	Public WithEvents TXTrx As Microsoft.VisualBasic.Compatibility.VB6.TextBoxArray
	Public WithEvents lblFilename As Microsoft.VisualBasic.Compatibility.VB6.LabelArray
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(FRMMain))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.GRDBitmap = New fpList
		Me.grdBitmapSmall = New fpList
		Me.cmdPar = New System.Windows.Forms.Button
		Me.chkautofix = New System.Windows.Forms.CheckBox
		Me._LSTTx_7 = New System.Windows.Forms.ListBox
		Me._LSTTx_6 = New System.Windows.Forms.ListBox
		Me._LSTTx_5 = New System.Windows.Forms.ListBox
		Me._LSTTx_4 = New System.Windows.Forms.ListBox
		Me._LSTTx_3 = New System.Windows.Forms.ListBox
		Me.CBONewsGroup = New System.Windows.Forms.ComboBox
		Me._LSTTx_2 = New System.Windows.Forms.ListBox
		Me._LSTTx_1 = New System.Windows.Forms.ListBox
		Me.CMDClear = New System.Windows.Forms.Button
		Me.Frame1 = New System.Windows.Forms.GroupBox
		Me.FRADownloadOptions = New System.Windows.Forms.GroupBox
		Me.CMDDownloadFiles = New System.Windows.Forms.Button
		Me.CMDViewFiles = New System.Windows.Forms.Button
		Me.CMDGetAllGroups = New System.Windows.Forms.Button
		Me.Tmr = New System.Windows.Forms.Timer(components)
		Me.CMDGetNewArticles = New System.Windows.Forms.Button
		Me._TXTrx_0 = New System.Windows.Forms.TextBox
		Me._LSTTx_0 = New System.Windows.Forms.ListBox
		Me.Winsock1 = New Winsock
		Me._lblFilename_1 = New System.Windows.Forms.Label
		Me._lblFilename_0 = New System.Windows.Forms.Label
		Me.Label4 = New System.Windows.Forms.Label
		Me.LBLWinsockState = New System.Windows.Forms.Label
		Me.LSTTx = New Microsoft.VisualBasic.Compatibility.VB6.ListBoxArray(components)
		Me.TXTrx = New Microsoft.VisualBasic.Compatibility.VB6.TextBoxArray(components)
		Me.lblFilename = New Microsoft.VisualBasic.Compatibility.VB6.LabelArray(components)
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		CType(Me.LSTTx, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.TXTrx, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.lblFilename, System.ComponentModel.ISupportInitialize).BeginInit()
		Me.Text = "Debug Window"
		Me.ClientSize = New System.Drawing.Size(1094, 631)
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
		Me.Name = "FRMMain"
		Me.GRDBitmap.Size = New System.Drawing.Size(185, 401)
		Me.GRDBitmap.Location = New System.Drawing.Point(392, 20)
		Me.GRDBitmap.TabIndex = 9
		Me.GRDBitmap.Enabled = -1
		Me.GRDBitmap.MousePointer = 0
		Me.GRDBitmap.TabStop = 0
		Me.GRDBitmap.BackColor = -2147483643
		Me.GRDBitmap.ForeColor = -2147483640
		Me.GRDBitmap.Columns = 10
		Me.GRDBitmap.Sorted = 0
		Me.GRDBitmap.LineWidth = 1
		Me.GRDBitmap.SelDrawFocusRect = -1
		Me.GRDBitmap.ColumnSeparatorChar = 9
		Me.GRDBitmap.ColumnSearch = -1
		Me.GRDBitmap.ColumnWidthScale = 0
		Me.GRDBitmap.RowHeight = -1
		Me.GRDBitmap.MultiSelect = 2
		Me.GRDBitmap.WrapList = 0
		Me.GRDBitmap.WrapWidth = 0
		Me.GRDBitmap.SelMax = -1
		Me.GRDBitmap.AutoSearch = 0
		Me.GRDBitmap.SearchMethod = 0
		Me.GRDBitmap.VirtualMode = 0
		Me.GRDBitmap.VRowCount = 0
		Me.GRDBitmap.DataSync = 3
		Me.GRDBitmap.ThreeDInsideStyle = 1
		Me.GRDBitmap.ThreeDInsideHighlightColor = -2147483633
		Me.GRDBitmap.ThreeDInsideShadowColor = -2147483642
		Me.GRDBitmap.ThreeDInsideWidth = 1
		Me.GRDBitmap.ThreeDOutsideStyle = 1
		Me.GRDBitmap.ThreeDOutsideHighlightColor = 16777215
		Me.GRDBitmap.ThreeDOutsideShadowColor = -2147483632
		Me.GRDBitmap.ThreeDOutsideWidth = 1
		Me.GRDBitmap.ThreeDFrameWidth = 0
		Me.GRDBitmap.BorderStyle = 0
		Me.GRDBitmap.BorderColor = -2147483642
		Me.GRDBitmap.BorderWidth = 1
		Me.GRDBitmap.ThreeDOnFocusInvert = 0
		Me.GRDBitmap.ThreeDFrameColor = -2147483633
		Me.GRDBitmap.Appearance = 0
		Me.GRDBitmap.BorderDropShadow = 0
		Me.GRDBitmap.BorderDropShadowColor = -2147483632
		Me.GRDBitmap.BorderDropShadowWidth = 0
		Me.GRDBitmap.ScrollHScale = 2
		Me.GRDBitmap.ScrollHInc = 0
		Me.GRDBitmap.ColsFrozen = 0
		Me.GRDBitmap.ScrollBarV = 2
		Me.GRDBitmap.NoIntegralHeight = 0
		Me.GRDBitmap.HighestPrecedence = 0
		Me.GRDBitmap.AllowColResize = 1
		Me.GRDBitmap.AllowColDragDrop = 0
		Me.GRDBitmap.ReadOnly = 0
		Me.GRDBitmap.VScrollSpecial = 0
		Me.GRDBitmap.VScrollSpecialType = 0
		Me.GRDBitmap.EnableKeyEvents = -1
		Me.GRDBitmap.EnableTopChangeEvent = -1
		Me.GRDBitmap.DataAutoHeadings = -1
		Me.GRDBitmap.DataAutoSizeCols = 2
		Me.GRDBitmap.SearchIgnoreCase = -1
		Me.GRDBitmap.ScrollBarH = 3
		Me.GRDBitmap.VirtualPageSize = 0
		Me.GRDBitmap.VirtualPagesAhead = 0
		Me.GRDBitmap.ExtendCol = 0
		Me.GRDBitmap.ColumnLevels = 1
		Me.GRDBitmap.ListGrayAreaColor = -2147483637
		Me.GRDBitmap.GroupHeaderHeight = -1
		Me.GRDBitmap.GroupHeaderShow = -1
		Me.GRDBitmap.AllowGrpResize = 0
		Me.GRDBitmap.AllowGrpDragDrop = 0
		Me.GRDBitmap.MergeAdjustView = 0
		Me.GRDBitmap.ColumnHeaderShow = -1
		Me.GRDBitmap.ColumnHeaderHeight = -1
		Me.GRDBitmap.GrpsFrozen = 0
		Me.GRDBitmap.BorderGrayAreaColor = -2147483637
		Me.GRDBitmap.ExtendRow = 0
		Me.GRDBitmap.DataField = ""
		Me.GRDBitmap.OLEDragMode = 0
		Me.GRDBitmap.OLEDropMode = 0
		Me.GRDBitmap.Redraw = -1
		Me.GRDBitmap.ResizeRowToFont = 0
		Me.GRDBitmap.TextTipMultiLine = 0
		Me.GRDBitmap.Name = "GRDBitmap"
		Me.grdBitmapSmall.Size = New System.Drawing.Size(129, 269)
		Me.grdBitmapSmall.Location = New System.Drawing.Point(768, 20)
		Me.grdBitmapSmall.TabIndex = 20
		Me.grdBitmapSmall.Enabled = -1
		Me.grdBitmapSmall.MousePointer = 0
		Me.grdBitmapSmall.TabStop = 0
		Me.grdBitmapSmall.BackColor = -2147483643
		Me.grdBitmapSmall.ForeColor = -2147483640
		Me.grdBitmapSmall.Columns = 10
		Me.grdBitmapSmall.Sorted = 0
		Me.grdBitmapSmall.LineWidth = 1
		Me.grdBitmapSmall.SelDrawFocusRect = -1
		Me.grdBitmapSmall.ColumnSeparatorChar = 9
		Me.grdBitmapSmall.ColumnSearch = -1
		Me.grdBitmapSmall.ColumnWidthScale = 0
		Me.grdBitmapSmall.RowHeight = -1
		Me.grdBitmapSmall.MultiSelect = 2
		Me.grdBitmapSmall.WrapList = 0
		Me.grdBitmapSmall.WrapWidth = 0
		Me.grdBitmapSmall.SelMax = -1
		Me.grdBitmapSmall.AutoSearch = 0
		Me.grdBitmapSmall.SearchMethod = 0
		Me.grdBitmapSmall.VirtualMode = 0
		Me.grdBitmapSmall.VRowCount = 0
		Me.grdBitmapSmall.DataSync = 3
		Me.grdBitmapSmall.ThreeDInsideStyle = 1
		Me.grdBitmapSmall.ThreeDInsideHighlightColor = -2147483633
		Me.grdBitmapSmall.ThreeDInsideShadowColor = -2147483642
		Me.grdBitmapSmall.ThreeDInsideWidth = 1
		Me.grdBitmapSmall.ThreeDOutsideStyle = 1
		Me.grdBitmapSmall.ThreeDOutsideHighlightColor = 16777215
		Me.grdBitmapSmall.ThreeDOutsideShadowColor = -2147483632
		Me.grdBitmapSmall.ThreeDOutsideWidth = 1
		Me.grdBitmapSmall.ThreeDFrameWidth = 0
		Me.grdBitmapSmall.BorderStyle = 0
		Me.grdBitmapSmall.BorderColor = -2147483642
		Me.grdBitmapSmall.BorderWidth = 1
		Me.grdBitmapSmall.ThreeDOnFocusInvert = 0
		Me.grdBitmapSmall.ThreeDFrameColor = -2147483633
		Me.grdBitmapSmall.Appearance = 0
		Me.grdBitmapSmall.BorderDropShadow = 0
		Me.grdBitmapSmall.BorderDropShadowColor = -2147483632
		Me.grdBitmapSmall.BorderDropShadowWidth = 0
		Me.grdBitmapSmall.ScrollHScale = 2
		Me.grdBitmapSmall.ScrollHInc = 0
		Me.grdBitmapSmall.ColsFrozen = 0
		Me.grdBitmapSmall.ScrollBarV = 2
		Me.grdBitmapSmall.NoIntegralHeight = 0
		Me.grdBitmapSmall.HighestPrecedence = 0
		Me.grdBitmapSmall.AllowColResize = 1
		Me.grdBitmapSmall.AllowColDragDrop = 0
		Me.grdBitmapSmall.ReadOnly = 0
		Me.grdBitmapSmall.VScrollSpecial = 0
		Me.grdBitmapSmall.VScrollSpecialType = 0
		Me.grdBitmapSmall.EnableKeyEvents = -1
		Me.grdBitmapSmall.EnableTopChangeEvent = -1
		Me.grdBitmapSmall.DataAutoHeadings = -1
		Me.grdBitmapSmall.DataAutoSizeCols = 2
		Me.grdBitmapSmall.SearchIgnoreCase = -1
		Me.grdBitmapSmall.ScrollBarH = 3
		Me.grdBitmapSmall.VirtualPageSize = 0
		Me.grdBitmapSmall.VirtualPagesAhead = 0
		Me.grdBitmapSmall.ExtendCol = 0
		Me.grdBitmapSmall.ColumnLevels = 1
		Me.grdBitmapSmall.ListGrayAreaColor = -2147483637
		Me.grdBitmapSmall.GroupHeaderHeight = -1
		Me.grdBitmapSmall.GroupHeaderShow = -1
		Me.grdBitmapSmall.AllowGrpResize = 0
		Me.grdBitmapSmall.AllowGrpDragDrop = 0
		Me.grdBitmapSmall.MergeAdjustView = 0
		Me.grdBitmapSmall.ColumnHeaderShow = -1
		Me.grdBitmapSmall.ColumnHeaderHeight = -1
		Me.grdBitmapSmall.GrpsFrozen = 0
		Me.grdBitmapSmall.BorderGrayAreaColor = -2147483637
		Me.grdBitmapSmall.ExtendRow = 0
		Me.grdBitmapSmall.DataField = ""
		Me.grdBitmapSmall.OLEDragMode = 0
		Me.grdBitmapSmall.OLEDropMode = 0
		Me.grdBitmapSmall.Redraw = -1
		Me.grdBitmapSmall.ResizeRowToFont = 0
		Me.grdBitmapSmall.TextTipMultiLine = 0
		Me.grdBitmapSmall.Name = "grdBitmapSmall"
		Me.cmdPar.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdPar.Text = "Par"
		Me.cmdPar.Size = New System.Drawing.Size(57, 17)
		Me.cmdPar.Location = New System.Drawing.Point(8, 248)
		Me.cmdPar.TabIndex = 24
		Me.cmdPar.BackColor = System.Drawing.SystemColors.Control
		Me.cmdPar.CausesValidation = True
		Me.cmdPar.Enabled = True
		Me.cmdPar.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdPar.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdPar.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdPar.TabStop = True
		Me.cmdPar.Name = "cmdPar"
		Me.chkautofix.Text = "autofix"
		Me.chkautofix.Size = New System.Drawing.Size(81, 25)
		Me.chkautofix.Location = New System.Drawing.Point(272, 104)
		Me.chkautofix.TabIndex = 23
		Me.chkautofix.CheckAlign = System.Drawing.ContentAlignment.MiddleLeft
		Me.chkautofix.FlatStyle = System.Windows.Forms.FlatStyle.Standard
		Me.chkautofix.BackColor = System.Drawing.SystemColors.Control
		Me.chkautofix.CausesValidation = True
		Me.chkautofix.Enabled = True
		Me.chkautofix.ForeColor = System.Drawing.SystemColors.ControlText
		Me.chkautofix.Cursor = System.Windows.Forms.Cursors.Default
		Me.chkautofix.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.chkautofix.Appearance = System.Windows.Forms.Appearance.Normal
		Me.chkautofix.TabStop = True
		Me.chkautofix.CheckState = System.Windows.Forms.CheckState.Unchecked
		Me.chkautofix.Visible = True
		Me.chkautofix.Name = "chkautofix"
		Me._LSTTx_7.Size = New System.Drawing.Size(129, 189)
		Me._LSTTx_7.Location = New System.Drawing.Point(824, 428)
		Me._LSTTx_7.TabIndex = 19
		Me._LSTTx_7.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._LSTTx_7.BackColor = System.Drawing.SystemColors.Window
		Me._LSTTx_7.CausesValidation = True
		Me._LSTTx_7.Enabled = True
		Me._LSTTx_7.ForeColor = System.Drawing.SystemColors.WindowText
		Me._LSTTx_7.IntegralHeight = True
		Me._LSTTx_7.Cursor = System.Windows.Forms.Cursors.Default
		Me._LSTTx_7.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me._LSTTx_7.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LSTTx_7.Sorted = False
		Me._LSTTx_7.TabStop = True
		Me._LSTTx_7.Visible = True
		Me._LSTTx_7.MultiColumn = False
		Me._LSTTx_7.Name = "_LSTTx_7"
		Me._LSTTx_6.Size = New System.Drawing.Size(129, 189)
		Me._LSTTx_6.Location = New System.Drawing.Point(688, 428)
		Me._LSTTx_6.TabIndex = 18
		Me._LSTTx_6.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._LSTTx_6.BackColor = System.Drawing.SystemColors.Window
		Me._LSTTx_6.CausesValidation = True
		Me._LSTTx_6.Enabled = True
		Me._LSTTx_6.ForeColor = System.Drawing.SystemColors.WindowText
		Me._LSTTx_6.IntegralHeight = True
		Me._LSTTx_6.Cursor = System.Windows.Forms.Cursors.Default
		Me._LSTTx_6.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me._LSTTx_6.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LSTTx_6.Sorted = False
		Me._LSTTx_6.TabStop = True
		Me._LSTTx_6.Visible = True
		Me._LSTTx_6.MultiColumn = False
		Me._LSTTx_6.Name = "_LSTTx_6"
		Me._LSTTx_5.Size = New System.Drawing.Size(129, 189)
		Me._LSTTx_5.Location = New System.Drawing.Point(552, 428)
		Me._LSTTx_5.TabIndex = 17
		Me._LSTTx_5.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._LSTTx_5.BackColor = System.Drawing.SystemColors.Window
		Me._LSTTx_5.CausesValidation = True
		Me._LSTTx_5.Enabled = True
		Me._LSTTx_5.ForeColor = System.Drawing.SystemColors.WindowText
		Me._LSTTx_5.IntegralHeight = True
		Me._LSTTx_5.Cursor = System.Windows.Forms.Cursors.Default
		Me._LSTTx_5.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me._LSTTx_5.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LSTTx_5.Sorted = False
		Me._LSTTx_5.TabStop = True
		Me._LSTTx_5.Visible = True
		Me._LSTTx_5.MultiColumn = False
		Me._LSTTx_5.Name = "_LSTTx_5"
		Me._LSTTx_4.Size = New System.Drawing.Size(129, 189)
		Me._LSTTx_4.Location = New System.Drawing.Point(416, 428)
		Me._LSTTx_4.TabIndex = 16
		Me._LSTTx_4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._LSTTx_4.BackColor = System.Drawing.SystemColors.Window
		Me._LSTTx_4.CausesValidation = True
		Me._LSTTx_4.Enabled = True
		Me._LSTTx_4.ForeColor = System.Drawing.SystemColors.WindowText
		Me._LSTTx_4.IntegralHeight = True
		Me._LSTTx_4.Cursor = System.Windows.Forms.Cursors.Default
		Me._LSTTx_4.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me._LSTTx_4.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LSTTx_4.Sorted = False
		Me._LSTTx_4.TabStop = True
		Me._LSTTx_4.Visible = True
		Me._LSTTx_4.MultiColumn = False
		Me._LSTTx_4.Name = "_LSTTx_4"
		Me._LSTTx_3.Size = New System.Drawing.Size(129, 189)
		Me._LSTTx_3.Location = New System.Drawing.Point(280, 428)
		Me._LSTTx_3.TabIndex = 15
		Me._LSTTx_3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._LSTTx_3.BackColor = System.Drawing.SystemColors.Window
		Me._LSTTx_3.CausesValidation = True
		Me._LSTTx_3.Enabled = True
		Me._LSTTx_3.ForeColor = System.Drawing.SystemColors.WindowText
		Me._LSTTx_3.IntegralHeight = True
		Me._LSTTx_3.Cursor = System.Windows.Forms.Cursors.Default
		Me._LSTTx_3.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me._LSTTx_3.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LSTTx_3.Sorted = False
		Me._LSTTx_3.TabStop = True
		Me._LSTTx_3.Visible = True
		Me._LSTTx_3.MultiColumn = False
		Me._LSTTx_3.Name = "_LSTTx_3"
		Me.CBONewsGroup.Enabled = False
		Me.CBONewsGroup.Size = New System.Drawing.Size(209, 21)
		Me.CBONewsGroup.Location = New System.Drawing.Point(140, 248)
		Me.CBONewsGroup.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
		Me.CBONewsGroup.TabIndex = 13
		Me.CBONewsGroup.BackColor = System.Drawing.SystemColors.Window
		Me.CBONewsGroup.CausesValidation = True
		Me.CBONewsGroup.ForeColor = System.Drawing.SystemColors.WindowText
		Me.CBONewsGroup.IntegralHeight = True
		Me.CBONewsGroup.Cursor = System.Windows.Forms.Cursors.Default
		Me.CBONewsGroup.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CBONewsGroup.Sorted = False
		Me.CBONewsGroup.TabStop = True
		Me.CBONewsGroup.Visible = True
		Me.CBONewsGroup.Name = "CBONewsGroup"
		Me._LSTTx_2.Size = New System.Drawing.Size(129, 189)
		Me._LSTTx_2.Location = New System.Drawing.Point(144, 428)
		Me._LSTTx_2.TabIndex = 12
		Me._LSTTx_2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._LSTTx_2.BackColor = System.Drawing.SystemColors.Window
		Me._LSTTx_2.CausesValidation = True
		Me._LSTTx_2.Enabled = True
		Me._LSTTx_2.ForeColor = System.Drawing.SystemColors.WindowText
		Me._LSTTx_2.IntegralHeight = True
		Me._LSTTx_2.Cursor = System.Windows.Forms.Cursors.Default
		Me._LSTTx_2.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me._LSTTx_2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LSTTx_2.Sorted = False
		Me._LSTTx_2.TabStop = True
		Me._LSTTx_2.Visible = True
		Me._LSTTx_2.MultiColumn = False
		Me._LSTTx_2.Name = "_LSTTx_2"
		Me._LSTTx_1.Size = New System.Drawing.Size(129, 189)
		Me._LSTTx_1.Location = New System.Drawing.Point(8, 428)
		Me._LSTTx_1.TabIndex = 11
		Me._LSTTx_1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._LSTTx_1.BackColor = System.Drawing.SystemColors.Window
		Me._LSTTx_1.CausesValidation = True
		Me._LSTTx_1.Enabled = True
		Me._LSTTx_1.ForeColor = System.Drawing.SystemColors.WindowText
		Me._LSTTx_1.IntegralHeight = True
		Me._LSTTx_1.Cursor = System.Windows.Forms.Cursors.Default
		Me._LSTTx_1.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me._LSTTx_1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LSTTx_1.Sorted = False
		Me._LSTTx_1.TabStop = True
		Me._LSTTx_1.Visible = True
		Me._LSTTx_1.MultiColumn = False
		Me._LSTTx_1.Name = "_LSTTx_1"
		Me.CMDClear.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDClear.Text = "Clear"
		Me.CMDClear.Size = New System.Drawing.Size(57, 17)
		Me.CMDClear.Location = New System.Drawing.Point(8, 272)
		Me.CMDClear.TabIndex = 8
		Me.CMDClear.BackColor = System.Drawing.SystemColors.Control
		Me.CMDClear.CausesValidation = True
		Me.CMDClear.Enabled = True
		Me.CMDClear.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDClear.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDClear.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDClear.TabStop = True
		Me.CMDClear.Name = "CMDClear"
		Me.Frame1.Text = "Debug"
		Me.Frame1.Size = New System.Drawing.Size(369, 17)
		Me.Frame1.Location = New System.Drawing.Point(8, 228)
		Me.Frame1.TabIndex = 7
		Me.Frame1.BackColor = System.Drawing.SystemColors.Control
		Me.Frame1.Enabled = True
		Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Frame1.Visible = True
		Me.Frame1.Padding = New System.Windows.Forms.Padding(0)
		Me.Frame1.Name = "Frame1"
		Me.FRADownloadOptions.Text = "Download Options"
		Me.FRADownloadOptions.Size = New System.Drawing.Size(369, 17)
		Me.FRADownloadOptions.Location = New System.Drawing.Point(8, 164)
		Me.FRADownloadOptions.TabIndex = 6
		Me.FRADownloadOptions.BackColor = System.Drawing.SystemColors.Control
		Me.FRADownloadOptions.Enabled = True
		Me.FRADownloadOptions.ForeColor = System.Drawing.SystemColors.ControlText
		Me.FRADownloadOptions.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.FRADownloadOptions.Visible = True
		Me.FRADownloadOptions.Padding = New System.Windows.Forms.Padding(0)
		Me.FRADownloadOptions.Name = "FRADownloadOptions"
		Me.CMDDownloadFiles.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDDownloadFiles.Text = "Download Files"
		Me.CMDDownloadFiles.Size = New System.Drawing.Size(97, 25)
		Me.CMDDownloadFiles.Location = New System.Drawing.Point(104, 196)
		Me.CMDDownloadFiles.TabIndex = 4
		Me.CMDDownloadFiles.BackColor = System.Drawing.SystemColors.Control
		Me.CMDDownloadFiles.CausesValidation = True
		Me.CMDDownloadFiles.Enabled = True
		Me.CMDDownloadFiles.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDDownloadFiles.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDDownloadFiles.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDDownloadFiles.TabStop = True
		Me.CMDDownloadFiles.Name = "CMDDownloadFiles"
		Me.CMDViewFiles.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDViewFiles.Text = "View Files"
		Me.CMDViewFiles.Size = New System.Drawing.Size(73, 25)
		Me.CMDViewFiles.Location = New System.Drawing.Point(208, 196)
		Me.CMDViewFiles.TabIndex = 3
		Me.CMDViewFiles.BackColor = System.Drawing.SystemColors.Control
		Me.CMDViewFiles.CausesValidation = True
		Me.CMDViewFiles.Enabled = True
		Me.CMDViewFiles.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDViewFiles.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDViewFiles.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDViewFiles.TabStop = True
		Me.CMDViewFiles.Name = "CMDViewFiles"
		Me.CMDGetAllGroups.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDGetAllGroups.Text = "Get All Groups"
		Me.CMDGetAllGroups.Size = New System.Drawing.Size(81, 25)
		Me.CMDGetAllGroups.Location = New System.Drawing.Point(296, 196)
		Me.CMDGetAllGroups.TabIndex = 1
		Me.CMDGetAllGroups.BackColor = System.Drawing.SystemColors.Control
		Me.CMDGetAllGroups.CausesValidation = True
		Me.CMDGetAllGroups.Enabled = True
		Me.CMDGetAllGroups.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDGetAllGroups.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDGetAllGroups.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDGetAllGroups.TabStop = True
		Me.CMDGetAllGroups.Name = "CMDGetAllGroups"
		Me.Tmr.Interval = 500
		Me.Tmr.Enabled = True
		Me.CMDGetNewArticles.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.CMDGetNewArticles.Text = "Get New Articles"
		Me.CMDGetNewArticles.Size = New System.Drawing.Size(89, 25)
		Me.CMDGetNewArticles.Location = New System.Drawing.Point(8, 196)
		Me.CMDGetNewArticles.TabIndex = 0
		Me.CMDGetNewArticles.BackColor = System.Drawing.SystemColors.Control
		Me.CMDGetNewArticles.CausesValidation = True
		Me.CMDGetNewArticles.Enabled = True
		Me.CMDGetNewArticles.ForeColor = System.Drawing.SystemColors.ControlText
		Me.CMDGetNewArticles.Cursor = System.Windows.Forms.Cursors.Default
		Me.CMDGetNewArticles.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.CMDGetNewArticles.TabStop = True
		Me.CMDGetNewArticles.Name = "CMDGetNewArticles"
		Me._TXTrx_0.AutoSize = False
		Me._TXTrx_0.Size = New System.Drawing.Size(377, 129)
		Me._TXTrx_0.Location = New System.Drawing.Point(8, 292)
		Me._TXTrx_0.MultiLine = True
		Me._TXTrx_0.ScrollBars = System.Windows.Forms.ScrollBars.Both
		Me._TXTrx_0.WordWrap = False
		Me._TXTrx_0.TabIndex = 2
		Me._TXTrx_0.AcceptsReturn = True
		Me._TXTrx_0.TextAlign = System.Windows.Forms.HorizontalAlignment.Left
		Me._TXTrx_0.BackColor = System.Drawing.SystemColors.Window
		Me._TXTrx_0.CausesValidation = True
		Me._TXTrx_0.Enabled = True
		Me._TXTrx_0.ForeColor = System.Drawing.SystemColors.WindowText
		Me._TXTrx_0.HideSelection = True
		Me._TXTrx_0.ReadOnly = False
		Me._TXTrx_0.Maxlength = 0
		Me._TXTrx_0.Cursor = System.Windows.Forms.Cursors.IBeam
		Me._TXTrx_0.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._TXTrx_0.TabStop = True
		Me._TXTrx_0.Visible = True
		Me._TXTrx_0.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._TXTrx_0.Name = "_TXTrx_0"
		Me._LSTTx_0.Size = New System.Drawing.Size(369, 137)
		Me._LSTTx_0.Location = New System.Drawing.Point(8, 20)
		Me._LSTTx_0.TabIndex = 10
		Me._LSTTx_0.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me._LSTTx_0.BackColor = System.Drawing.SystemColors.Window
		Me._LSTTx_0.CausesValidation = True
		Me._LSTTx_0.Enabled = True
		Me._LSTTx_0.ForeColor = System.Drawing.SystemColors.WindowText
		Me._LSTTx_0.IntegralHeight = True
		Me._LSTTx_0.Cursor = System.Windows.Forms.Cursors.Default
		Me._LSTTx_0.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me._LSTTx_0.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._LSTTx_0.Sorted = False
		Me._LSTTx_0.TabStop = True
		Me._LSTTx_0.Visible = True
		Me._LSTTx_0.MultiColumn = False
		Me._LSTTx_0.Name = "_LSTTx_0"
		Me.Winsock1.Location = New System.Drawing.Point(360, 256)
		Me.Winsock1.Name = "Winsock1"
		Me._lblFilename_1.Text = "<Filename>"
		Me._lblFilename_1.Size = New System.Drawing.Size(321, 17)
		Me._lblFilename_1.Location = New System.Drawing.Point(768, 4)
		Me._lblFilename_1.TabIndex = 22
		Me._lblFilename_1.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._lblFilename_1.BackColor = System.Drawing.SystemColors.Control
		Me._lblFilename_1.Enabled = True
		Me._lblFilename_1.ForeColor = System.Drawing.SystemColors.ControlText
		Me._lblFilename_1.Cursor = System.Windows.Forms.Cursors.Default
		Me._lblFilename_1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._lblFilename_1.UseMnemonic = True
		Me._lblFilename_1.Visible = True
		Me._lblFilename_1.AutoSize = False
		Me._lblFilename_1.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._lblFilename_1.Name = "_lblFilename_1"
		Me._lblFilename_0.Text = "<Filename>"
		Me._lblFilename_0.Size = New System.Drawing.Size(361, 17)
		Me._lblFilename_0.Location = New System.Drawing.Point(392, 4)
		Me._lblFilename_0.TabIndex = 21
		Me._lblFilename_0.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me._lblFilename_0.BackColor = System.Drawing.SystemColors.Control
		Me._lblFilename_0.Enabled = True
		Me._lblFilename_0.ForeColor = System.Drawing.SystemColors.ControlText
		Me._lblFilename_0.Cursor = System.Windows.Forms.Cursors.Default
		Me._lblFilename_0.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me._lblFilename_0.UseMnemonic = True
		Me._lblFilename_0.Visible = True
		Me._lblFilename_0.AutoSize = False
		Me._lblFilename_0.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me._lblFilename_0.Name = "_lblFilename_0"
		Me.Label4.Text = "Ne&wsgroup"
		Me.Label4.Size = New System.Drawing.Size(54, 13)
		Me.Label4.Location = New System.Drawing.Point(72, 252)
		Me.Label4.TabIndex = 14
		Me.Label4.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label4.BackColor = System.Drawing.SystemColors.Control
		Me.Label4.Enabled = True
		Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label4.UseMnemonic = True
		Me.Label4.Visible = True
		Me.Label4.AutoSize = True
		Me.Label4.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label4.Name = "Label4"
		Me.LBLWinsockState.Text = "<Winsock State>"
		Me.LBLWinsockState.Size = New System.Drawing.Size(169, 17)
		Me.LBLWinsockState.Location = New System.Drawing.Point(72, 272)
		Me.LBLWinsockState.TabIndex = 5
		Me.LBLWinsockState.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.LBLWinsockState.BackColor = System.Drawing.SystemColors.Control
		Me.LBLWinsockState.Enabled = True
		Me.LBLWinsockState.ForeColor = System.Drawing.SystemColors.ControlText
		Me.LBLWinsockState.Cursor = System.Windows.Forms.Cursors.Default
		Me.LBLWinsockState.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.LBLWinsockState.UseMnemonic = True
		Me.LBLWinsockState.Visible = True
		Me.LBLWinsockState.AutoSize = False
		Me.LBLWinsockState.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.LBLWinsockState.Name = "LBLWinsockState"
		Me.LSTTx.SetIndex(_LSTTx_7, CType(7, Short))
		Me.LSTTx.SetIndex(_LSTTx_6, CType(6, Short))
		Me.LSTTx.SetIndex(_LSTTx_5, CType(5, Short))
		Me.LSTTx.SetIndex(_LSTTx_4, CType(4, Short))
		Me.LSTTx.SetIndex(_LSTTx_3, CType(3, Short))
		Me.LSTTx.SetIndex(_LSTTx_2, CType(2, Short))
		Me.LSTTx.SetIndex(_LSTTx_1, CType(1, Short))
		Me.LSTTx.SetIndex(_LSTTx_0, CType(0, Short))
		Me.TXTrx.SetIndex(_TXTrx_0, CType(0, Short))
		Me.lblFilename.SetIndex(_lblFilename_1, CType(1, Short))
		Me.lblFilename.SetIndex(_lblFilename_0, CType(0, Short))
		CType(Me.lblFilename, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.TXTrx, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.LSTTx, System.ComponentModel.ISupportInitialize).EndInit()
		Me.Controls.Add(GRDBitmap)
		Me.Controls.Add(grdBitmapSmall)
		Me.Controls.Add(cmdPar)
		Me.Controls.Add(chkautofix)
		Me.Controls.Add(_LSTTx_7)
		Me.Controls.Add(_LSTTx_6)
		Me.Controls.Add(_LSTTx_5)
		Me.Controls.Add(_LSTTx_4)
		Me.Controls.Add(_LSTTx_3)
		Me.Controls.Add(CBONewsGroup)
		Me.Controls.Add(_LSTTx_2)
		Me.Controls.Add(_LSTTx_1)
		Me.Controls.Add(CMDClear)
		Me.Controls.Add(Frame1)
		Me.Controls.Add(FRADownloadOptions)
		Me.Controls.Add(CMDDownloadFiles)
		Me.Controls.Add(CMDViewFiles)
		Me.Controls.Add(CMDGetAllGroups)
		Me.Controls.Add(CMDGetNewArticles)
		Me.Controls.Add(_TXTrx_0)
		Me.Controls.Add(_LSTTx_0)
		Me.Controls.Add(Winsock1)
		Me.Controls.Add(_lblFilename_1)
		Me.Controls.Add(_lblFilename_0)
		Me.Controls.Add(Label4)
		Me.Controls.Add(LBLWinsockState)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class