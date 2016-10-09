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
    Public WithEvents TXTrx As System.Windows.Forms.TextBox
    Public WithEvents _LSTTx_0 As System.Windows.Forms.ListBox
    Public WithEvents lblFilename1 As System.Windows.Forms.Label
    Public WithEvents lblFilename0 As System.Windows.Forms.Label
    Public WithEvents Label4 As System.Windows.Forms.Label
    Public WithEvents LBLWinsockState As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.cmdPar = New System.Windows.Forms.Button()
        Me.chkautofix = New System.Windows.Forms.CheckBox()
        Me._LSTTx_7 = New System.Windows.Forms.ListBox()
        Me._LSTTx_6 = New System.Windows.Forms.ListBox()
        Me._LSTTx_5 = New System.Windows.Forms.ListBox()
        Me._LSTTx_4 = New System.Windows.Forms.ListBox()
        Me._LSTTx_3 = New System.Windows.Forms.ListBox()
        Me.CBONewsGroup = New System.Windows.Forms.ComboBox()
        Me._LSTTx_2 = New System.Windows.Forms.ListBox()
        Me._LSTTx_1 = New System.Windows.Forms.ListBox()
        Me.CMDClear = New System.Windows.Forms.Button()
        Me.Frame1 = New System.Windows.Forms.GroupBox()
        Me.FRADownloadOptions = New System.Windows.Forms.GroupBox()
        Me.CMDDownloadFiles = New System.Windows.Forms.Button()
        Me.CMDViewFiles = New System.Windows.Forms.Button()
        Me.CMDGetAllGroups = New System.Windows.Forms.Button()
        Me.Tmr = New System.Windows.Forms.Timer(Me.components)
        Me.CMDGetNewArticles = New System.Windows.Forms.Button()
        Me.TXTrx = New System.Windows.Forms.TextBox()
        Me._LSTTx_0 = New System.Windows.Forms.ListBox()
        Me.lblFilename1 = New System.Windows.Forms.Label()
        Me.lblFilename0 = New System.Windows.Forms.Label()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.LBLWinsockState = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'cmdPar
        '
        Me.cmdPar.BackColor = System.Drawing.SystemColors.Control
        Me.cmdPar.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdPar.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdPar.Location = New System.Drawing.Point(8, 248)
        Me.cmdPar.Name = "cmdPar"
        Me.cmdPar.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdPar.Size = New System.Drawing.Size(57, 17)
        Me.cmdPar.TabIndex = 24
        Me.cmdPar.Text = "Par"
        Me.cmdPar.UseVisualStyleBackColor = False
        '
        'chkautofix
        '
        Me.chkautofix.BackColor = System.Drawing.SystemColors.Control
        Me.chkautofix.Cursor = System.Windows.Forms.Cursors.Default
        Me.chkautofix.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkautofix.Location = New System.Drawing.Point(272, 104)
        Me.chkautofix.Name = "chkautofix"
        Me.chkautofix.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chkautofix.Size = New System.Drawing.Size(81, 25)
        Me.chkautofix.TabIndex = 23
        Me.chkautofix.Text = "autofix"
        Me.chkautofix.UseVisualStyleBackColor = False
        '
        '_LSTTx_7
        '
        Me._LSTTx_7.BackColor = System.Drawing.SystemColors.Window
        Me._LSTTx_7.Cursor = System.Windows.Forms.Cursors.Default
        Me._LSTTx_7.ForeColor = System.Drawing.SystemColors.WindowText
        Me._LSTTx_7.Location = New System.Drawing.Point(824, 428)
        Me._LSTTx_7.Name = "_LSTTx_7"
        Me._LSTTx_7.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._LSTTx_7.Size = New System.Drawing.Size(129, 186)
        Me._LSTTx_7.TabIndex = 19
        '
        '_LSTTx_6
        '
        Me._LSTTx_6.BackColor = System.Drawing.SystemColors.Window
        Me._LSTTx_6.Cursor = System.Windows.Forms.Cursors.Default
        Me._LSTTx_6.ForeColor = System.Drawing.SystemColors.WindowText
        Me._LSTTx_6.Location = New System.Drawing.Point(688, 428)
        Me._LSTTx_6.Name = "_LSTTx_6"
        Me._LSTTx_6.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._LSTTx_6.Size = New System.Drawing.Size(129, 186)
        Me._LSTTx_6.TabIndex = 18
        '
        '_LSTTx_5
        '
        Me._LSTTx_5.BackColor = System.Drawing.SystemColors.Window
        Me._LSTTx_5.Cursor = System.Windows.Forms.Cursors.Default
        Me._LSTTx_5.ForeColor = System.Drawing.SystemColors.WindowText
        Me._LSTTx_5.Location = New System.Drawing.Point(552, 428)
        Me._LSTTx_5.Name = "_LSTTx_5"
        Me._LSTTx_5.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._LSTTx_5.Size = New System.Drawing.Size(129, 186)
        Me._LSTTx_5.TabIndex = 17
        '
        '_LSTTx_4
        '
        Me._LSTTx_4.BackColor = System.Drawing.SystemColors.Window
        Me._LSTTx_4.Cursor = System.Windows.Forms.Cursors.Default
        Me._LSTTx_4.ForeColor = System.Drawing.SystemColors.WindowText
        Me._LSTTx_4.Location = New System.Drawing.Point(416, 428)
        Me._LSTTx_4.Name = "_LSTTx_4"
        Me._LSTTx_4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._LSTTx_4.Size = New System.Drawing.Size(129, 186)
        Me._LSTTx_4.TabIndex = 16
        '
        '_LSTTx_3
        '
        Me._LSTTx_3.BackColor = System.Drawing.SystemColors.Window
        Me._LSTTx_3.Cursor = System.Windows.Forms.Cursors.Default
        Me._LSTTx_3.ForeColor = System.Drawing.SystemColors.WindowText
        Me._LSTTx_3.Location = New System.Drawing.Point(280, 428)
        Me._LSTTx_3.Name = "_LSTTx_3"
        Me._LSTTx_3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._LSTTx_3.Size = New System.Drawing.Size(129, 186)
        Me._LSTTx_3.TabIndex = 15
        '
        'CBONewsGroup
        '
        Me.CBONewsGroup.BackColor = System.Drawing.SystemColors.Window
        Me.CBONewsGroup.Cursor = System.Windows.Forms.Cursors.Default
        Me.CBONewsGroup.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.CBONewsGroup.Enabled = False
        Me.CBONewsGroup.ForeColor = System.Drawing.SystemColors.WindowText
        Me.CBONewsGroup.Location = New System.Drawing.Point(140, 248)
        Me.CBONewsGroup.Name = "CBONewsGroup"
        Me.CBONewsGroup.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.CBONewsGroup.Size = New System.Drawing.Size(209, 21)
        Me.CBONewsGroup.TabIndex = 13
        '
        '_LSTTx_2
        '
        Me._LSTTx_2.BackColor = System.Drawing.SystemColors.Window
        Me._LSTTx_2.Cursor = System.Windows.Forms.Cursors.Default
        Me._LSTTx_2.ForeColor = System.Drawing.SystemColors.WindowText
        Me._LSTTx_2.Location = New System.Drawing.Point(144, 428)
        Me._LSTTx_2.Name = "_LSTTx_2"
        Me._LSTTx_2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._LSTTx_2.Size = New System.Drawing.Size(129, 186)
        Me._LSTTx_2.TabIndex = 12
        '
        '_LSTTx_1
        '
        Me._LSTTx_1.BackColor = System.Drawing.SystemColors.Window
        Me._LSTTx_1.Cursor = System.Windows.Forms.Cursors.Default
        Me._LSTTx_1.ForeColor = System.Drawing.SystemColors.WindowText
        Me._LSTTx_1.Location = New System.Drawing.Point(8, 428)
        Me._LSTTx_1.Name = "_LSTTx_1"
        Me._LSTTx_1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._LSTTx_1.Size = New System.Drawing.Size(129, 186)
        Me._LSTTx_1.TabIndex = 11
        '
        'CMDClear
        '
        Me.CMDClear.BackColor = System.Drawing.SystemColors.Control
        Me.CMDClear.Cursor = System.Windows.Forms.Cursors.Default
        Me.CMDClear.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CMDClear.Location = New System.Drawing.Point(8, 272)
        Me.CMDClear.Name = "CMDClear"
        Me.CMDClear.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.CMDClear.Size = New System.Drawing.Size(57, 17)
        Me.CMDClear.TabIndex = 8
        Me.CMDClear.Text = "Clear"
        Me.CMDClear.UseVisualStyleBackColor = False
        '
        'Frame1
        '
        Me.Frame1.BackColor = System.Drawing.SystemColors.Control
        Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame1.Location = New System.Drawing.Point(8, 228)
        Me.Frame1.Name = "Frame1"
        Me.Frame1.Padding = New System.Windows.Forms.Padding(0)
        Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame1.Size = New System.Drawing.Size(369, 17)
        Me.Frame1.TabIndex = 7
        Me.Frame1.TabStop = False
        Me.Frame1.Text = "Debug"
        '
        'FRADownloadOptions
        '
        Me.FRADownloadOptions.BackColor = System.Drawing.SystemColors.Control
        Me.FRADownloadOptions.ForeColor = System.Drawing.SystemColors.ControlText
        Me.FRADownloadOptions.Location = New System.Drawing.Point(8, 164)
        Me.FRADownloadOptions.Name = "FRADownloadOptions"
        Me.FRADownloadOptions.Padding = New System.Windows.Forms.Padding(0)
        Me.FRADownloadOptions.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.FRADownloadOptions.Size = New System.Drawing.Size(369, 17)
        Me.FRADownloadOptions.TabIndex = 6
        Me.FRADownloadOptions.TabStop = False
        Me.FRADownloadOptions.Text = "Download Options"
        '
        'CMDDownloadFiles
        '
        Me.CMDDownloadFiles.BackColor = System.Drawing.SystemColors.Control
        Me.CMDDownloadFiles.Cursor = System.Windows.Forms.Cursors.Default
        Me.CMDDownloadFiles.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CMDDownloadFiles.Location = New System.Drawing.Point(104, 196)
        Me.CMDDownloadFiles.Name = "CMDDownloadFiles"
        Me.CMDDownloadFiles.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.CMDDownloadFiles.Size = New System.Drawing.Size(97, 25)
        Me.CMDDownloadFiles.TabIndex = 4
        Me.CMDDownloadFiles.Text = "Download Files"
        Me.CMDDownloadFiles.UseVisualStyleBackColor = False
        '
        'CMDViewFiles
        '
        Me.CMDViewFiles.BackColor = System.Drawing.SystemColors.Control
        Me.CMDViewFiles.Cursor = System.Windows.Forms.Cursors.Default
        Me.CMDViewFiles.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CMDViewFiles.Location = New System.Drawing.Point(208, 196)
        Me.CMDViewFiles.Name = "CMDViewFiles"
        Me.CMDViewFiles.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.CMDViewFiles.Size = New System.Drawing.Size(73, 25)
        Me.CMDViewFiles.TabIndex = 3
        Me.CMDViewFiles.Text = "View Files"
        Me.CMDViewFiles.UseVisualStyleBackColor = False
        '
        'CMDGetAllGroups
        '
        Me.CMDGetAllGroups.BackColor = System.Drawing.SystemColors.Control
        Me.CMDGetAllGroups.Cursor = System.Windows.Forms.Cursors.Default
        Me.CMDGetAllGroups.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CMDGetAllGroups.Location = New System.Drawing.Point(296, 196)
        Me.CMDGetAllGroups.Name = "CMDGetAllGroups"
        Me.CMDGetAllGroups.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.CMDGetAllGroups.Size = New System.Drawing.Size(81, 25)
        Me.CMDGetAllGroups.TabIndex = 1
        Me.CMDGetAllGroups.Text = "Get All Groups"
        Me.CMDGetAllGroups.UseVisualStyleBackColor = False
        '
        'Tmr
        '
        Me.Tmr.Enabled = True
        Me.Tmr.Interval = 500
        '
        'CMDGetNewArticles
        '
        Me.CMDGetNewArticles.BackColor = System.Drawing.SystemColors.Control
        Me.CMDGetNewArticles.Cursor = System.Windows.Forms.Cursors.Default
        Me.CMDGetNewArticles.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CMDGetNewArticles.Location = New System.Drawing.Point(8, 196)
        Me.CMDGetNewArticles.Name = "CMDGetNewArticles"
        Me.CMDGetNewArticles.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.CMDGetNewArticles.Size = New System.Drawing.Size(89, 25)
        Me.CMDGetNewArticles.TabIndex = 0
        Me.CMDGetNewArticles.Text = "Get New Articles"
        Me.CMDGetNewArticles.UseVisualStyleBackColor = False
        '
        'TXTrx
        '
        Me.TXTrx.AcceptsReturn = True
        Me.TXTrx.BackColor = System.Drawing.SystemColors.Window
        Me.TXTrx.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.TXTrx.ForeColor = System.Drawing.SystemColors.WindowText
        Me.TXTrx.Location = New System.Drawing.Point(8, 292)
        Me.TXTrx.MaxLength = 0
        Me.TXTrx.Multiline = True
        Me.TXTrx.Name = "TXTrx"
        Me.TXTrx.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.TXTrx.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.TXTrx.Size = New System.Drawing.Size(377, 129)
        Me.TXTrx.TabIndex = 2
        Me.TXTrx.WordWrap = False
        '
        '_LSTTx_0
        '
        Me._LSTTx_0.BackColor = System.Drawing.SystemColors.Window
        Me._LSTTx_0.Cursor = System.Windows.Forms.Cursors.Default
        Me._LSTTx_0.ForeColor = System.Drawing.SystemColors.WindowText
        Me._LSTTx_0.Location = New System.Drawing.Point(8, 20)
        Me._LSTTx_0.Name = "_LSTTx_0"
        Me._LSTTx_0.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me._LSTTx_0.Size = New System.Drawing.Size(369, 134)
        Me._LSTTx_0.TabIndex = 10
        '
        'lblFilename1
        '
        Me.lblFilename1.BackColor = System.Drawing.SystemColors.Control
        Me.lblFilename1.Cursor = System.Windows.Forms.Cursors.Default
        Me.lblFilename1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.lblFilename1.Location = New System.Drawing.Point(768, 4)
        Me.lblFilename1.Name = "lblFilename1"
        Me.lblFilename1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblFilename1.Size = New System.Drawing.Size(321, 17)
        Me.lblFilename1.TabIndex = 22
        Me.lblFilename1.Text = "<Filename>"
        '
        'lblFilename0
        '
        Me.lblFilename0.BackColor = System.Drawing.SystemColors.Control
        Me.lblFilename0.Cursor = System.Windows.Forms.Cursors.Default
        Me.lblFilename0.ForeColor = System.Drawing.SystemColors.ControlText
        Me.lblFilename0.Location = New System.Drawing.Point(392, 4)
        Me.lblFilename0.Name = "lblFilename0"
        Me.lblFilename0.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblFilename0.Size = New System.Drawing.Size(361, 17)
        Me.lblFilename0.TabIndex = 21
        Me.lblFilename0.Text = "<Filename>"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.BackColor = System.Drawing.SystemColors.Control
        Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(72, 252)
        Me.Label4.Name = "Label4"
        Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label4.Size = New System.Drawing.Size(61, 13)
        Me.Label4.TabIndex = 14
        Me.Label4.Text = "Ne&wsgroup"
        '
        'LBLWinsockState
        '
        Me.LBLWinsockState.BackColor = System.Drawing.SystemColors.Control
        Me.LBLWinsockState.Cursor = System.Windows.Forms.Cursors.Default
        Me.LBLWinsockState.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LBLWinsockState.Location = New System.Drawing.Point(72, 272)
        Me.LBLWinsockState.Name = "LBLWinsockState"
        Me.LBLWinsockState.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LBLWinsockState.Size = New System.Drawing.Size(169, 17)
        Me.LBLWinsockState.TabIndex = 5
        Me.LBLWinsockState.Text = "<Winsock State>"
        '
        'FRMMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(1094, 631)
        Me.Controls.Add(Me.cmdPar)
        Me.Controls.Add(Me.chkautofix)
        Me.Controls.Add(Me._LSTTx_7)
        Me.Controls.Add(Me._LSTTx_6)
        Me.Controls.Add(Me._LSTTx_5)
        Me.Controls.Add(Me._LSTTx_4)
        Me.Controls.Add(Me._LSTTx_3)
        Me.Controls.Add(Me.CBONewsGroup)
        Me.Controls.Add(Me._LSTTx_2)
        Me.Controls.Add(Me._LSTTx_1)
        Me.Controls.Add(Me.CMDClear)
        Me.Controls.Add(Me.Frame1)
        Me.Controls.Add(Me.FRADownloadOptions)
        Me.Controls.Add(Me.CMDDownloadFiles)
        Me.Controls.Add(Me.CMDViewFiles)
        Me.Controls.Add(Me.CMDGetAllGroups)
        Me.Controls.Add(Me.CMDGetNewArticles)
        Me.Controls.Add(Me.TXTrx)
        Me.Controls.Add(Me._LSTTx_0)
        Me.Controls.Add(Me.lblFilename1)
        Me.Controls.Add(Me.lblFilename0)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.LBLWinsockState)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "FRMMain"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultBounds
        Me.Text = "Debug Window"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
#End Region 
End Class