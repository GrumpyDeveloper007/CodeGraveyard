<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class FRMContextMenu
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
	Public WithEvents mnuDownloadFiles As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuDownloadAutoHide As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuSpacer1 As System.Windows.Forms.ToolStripSeparator
	Public WithEvents mnuHide As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuHideAll As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuSpacer2 As System.Windows.Forms.ToolStripSeparator
	Public WithEvents mnuDownloadFirst As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuPauseFiles As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuMoveToAutoHide As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuHide2Day As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnublank3 As System.Windows.Forms.ToolStripSeparator
	Public WithEvents mnuRefresh As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents mnuFilesMenu As System.Windows.Forms.ToolStripMenuItem
	Public WithEvents MainMenu1 As System.Windows.Forms.MenuStrip
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(FRMContextMenu))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.MainMenu1 = New System.Windows.Forms.MenuStrip
		Me.mnuFilesMenu = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuDownloadFiles = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuDownloadAutoHide = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuSpacer1 = New System.Windows.Forms.ToolStripSeparator
		Me.mnuHide = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuHideAll = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuSpacer2 = New System.Windows.Forms.ToolStripSeparator
		Me.mnuDownloadFirst = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuPauseFiles = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuMoveToAutoHide = New System.Windows.Forms.ToolStripMenuItem
		Me.mnuHide2Day = New System.Windows.Forms.ToolStripMenuItem
		Me.mnublank3 = New System.Windows.Forms.ToolStripSeparator
		Me.mnuRefresh = New System.Windows.Forms.ToolStripMenuItem
		Me.MainMenu1.SuspendLayout()
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		Me.ControlBox = False
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
		Me.ClientSize = New System.Drawing.Size(322, 84)
		Me.Location = New System.Drawing.Point(1, 20)
		Me.MaximizeBox = False
		Me.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultBounds
		Me.MinimizeBox = False
		Me.Visible = False
		Me.WindowState = System.Windows.Forms.FormWindowState.Minimized
		Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		Me.BackColor = System.Drawing.SystemColors.Control
		Me.Enabled = True
		Me.KeyPreview = False
		Me.Cursor = System.Windows.Forms.Cursors.Default
		Me.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.ShowInTaskbar = True
		Me.HelpButton = False
		Me.Name = "FRMContextMenu"
		Me.mnuFilesMenu.Name = "mnuFilesMenu"
		Me.mnuFilesMenu.Text = "Files Menu"
		Me.mnuFilesMenu.Checked = False
		Me.mnuFilesMenu.Enabled = True
		Me.mnuFilesMenu.Visible = True
		Me.mnuDownloadFiles.Name = "mnuDownloadFiles"
		Me.mnuDownloadFiles.Text = "Download Files"
		Me.mnuDownloadFiles.Checked = False
		Me.mnuDownloadFiles.Enabled = True
		Me.mnuDownloadFiles.Visible = True
		Me.mnuDownloadAutoHide.Name = "mnuDownloadAutoHide"
		Me.mnuDownloadAutoHide.Text = "Download / AutoHide"
		Me.mnuDownloadAutoHide.Checked = False
		Me.mnuDownloadAutoHide.Enabled = True
		Me.mnuDownloadAutoHide.Visible = True
		Me.mnuSpacer1.Enabled = True
		Me.mnuSpacer1.Visible = True
		Me.mnuSpacer1.Name = "mnuSpacer1"
		Me.mnuHide.Name = "mnuHide"
		Me.mnuHide.Text = "Hide"
		Me.mnuHide.Checked = False
		Me.mnuHide.Enabled = True
		Me.mnuHide.Visible = True
		Me.mnuHideAll.Name = "mnuHideAll"
		Me.mnuHideAll.Text = "Hide All"
		Me.mnuHideAll.Checked = False
		Me.mnuHideAll.Enabled = True
		Me.mnuHideAll.Visible = True
		Me.mnuSpacer2.Enabled = True
		Me.mnuSpacer2.Visible = True
		Me.mnuSpacer2.Name = "mnuSpacer2"
		Me.mnuDownloadFirst.Name = "mnuDownloadFirst"
		Me.mnuDownloadFirst.Text = "Download First"
		Me.mnuDownloadFirst.Visible = False
		Me.mnuDownloadFirst.Checked = False
		Me.mnuDownloadFirst.Enabled = True
		Me.mnuPauseFiles.Name = "mnuPauseFiles"
		Me.mnuPauseFiles.Text = "Pause Files"
		Me.mnuPauseFiles.Checked = False
		Me.mnuPauseFiles.Enabled = True
		Me.mnuPauseFiles.Visible = True
		Me.mnuMoveToAutoHide.Name = "mnuMoveToAutoHide"
		Me.mnuMoveToAutoHide.Text = "Move to Auto hide"
		Me.mnuMoveToAutoHide.Checked = False
		Me.mnuMoveToAutoHide.Enabled = True
		Me.mnuMoveToAutoHide.Visible = True
		Me.mnuHide2Day.Name = "mnuHide2Day"
		Me.mnuHide2Day.Text = "Hide >2 Day"
		Me.mnuHide2Day.Checked = False
		Me.mnuHide2Day.Enabled = True
		Me.mnuHide2Day.Visible = True
		Me.mnublank3.Enabled = True
		Me.mnublank3.Visible = True
		Me.mnublank3.Name = "mnublank3"
		Me.mnuRefresh.Name = "mnuRefresh"
		Me.mnuRefresh.Text = "Refresh"
		Me.mnuRefresh.Checked = False
		Me.mnuRefresh.Enabled = True
		Me.mnuRefresh.Visible = True
		MainMenu1.Items.AddRange(New System.Windows.Forms.ToolStripItem(){Me.mnuFilesMenu})
		mnuFilesMenu.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem(){Me.mnuDownloadFiles, Me.mnuDownloadAutoHide, Me.mnuSpacer1, Me.mnuHide, Me.mnuHideAll, Me.mnuSpacer2, Me.mnuDownloadFirst, Me.mnuPauseFiles, Me.mnuMoveToAutoHide, Me.mnuHide2Day, Me.mnublank3, Me.mnuRefresh})
		Me.Controls.Add(MainMenu1)
		Me.MainMenu1.ResumeLayout(False)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class