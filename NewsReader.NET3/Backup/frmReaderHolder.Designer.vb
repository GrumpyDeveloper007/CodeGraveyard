<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmReaderHolder
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
	Public WithEvents BWinsock As Winsock
	Public WithEvents AWinsock As Winsock
	Public WithEvents CWinsock As Winsock
	Public WithEvents DWinsock As Winsock
	Public WithEvents FWinsock As Winsock
	Public WithEvents EWinsock As Winsock
	Public WithEvents GWinsock As Winsock
	Public WithEvents HWinsock As Winsock
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmReaderHolder))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.BWinsock = New Winsock
		Me.AWinsock = New Winsock
		Me.CWinsock = New Winsock
		Me.DWinsock = New Winsock
		Me.FWinsock = New Winsock
		Me.EWinsock = New Winsock
		Me.GWinsock = New Winsock
		Me.HWinsock = New Winsock
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
		Me.Text = "Form1"
		Me.ClientSize = New System.Drawing.Size(312, 213)
		Me.Location = New System.Drawing.Point(3, 22)
		Me.MaximizeBox = False
		Me.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultBounds
		Me.MinimizeBox = False
		Me.Visible = False
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
		Me.Name = "frmReaderHolder"
		Me.BWinsock.Location = New System.Drawing.Point(8, 40)
		Me.BWinsock.Name = "BWinsock"
		Me.AWinsock.Location = New System.Drawing.Point(8, 8)
		Me.AWinsock.Name = "AWinsock"
		Me.CWinsock.Location = New System.Drawing.Point(8, 76)
		Me.CWinsock.Name = "CWinsock"
		Me.DWinsock.Location = New System.Drawing.Point(8, 108)
		Me.DWinsock.Name = "DWinsock"
		Me.FWinsock.Location = New System.Drawing.Point(48, 40)
		Me.FWinsock.Name = "FWinsock"
		Me.EWinsock.Location = New System.Drawing.Point(48, 8)
		Me.EWinsock.Name = "EWinsock"
		Me.GWinsock.Location = New System.Drawing.Point(48, 76)
		Me.GWinsock.Name = "GWinsock"
		Me.HWinsock.Location = New System.Drawing.Point(48, 108)
		Me.HWinsock.Name = "HWinsock"
		Me.Controls.Add(BWinsock)
		Me.Controls.Add(AWinsock)
		Me.Controls.Add(CWinsock)
		Me.Controls.Add(DWinsock)
		Me.Controls.Add(FWinsock)
		Me.Controls.Add(EWinsock)
		Me.Controls.Add(GWinsock)
		Me.Controls.Add(HWinsock)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class