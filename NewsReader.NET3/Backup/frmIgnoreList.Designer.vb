<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmIgnoreList
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
	Public WithEvents cmdAdd As System.Windows.Forms.Button
	Public WithEvents cmdDelete As System.Windows.Forms.Button
	Public WithEvents cmdTempPath As System.Windows.Forms.Button
	Public WithEvents txtPath As AxELFTxtBox.AxTxtBox1
	Public WithEvents _LBLZ1_4 As System.Windows.Forms.Label
	Public WithEvents fraAlternateServer As System.Windows.Forms.GroupBox
	Public WithEvents lstIgnore As System.Windows.Forms.ListBox
	Public WithEvents _LBLZ1_8 As System.Windows.Forms.Label
	Public WithEvents LBLZ1 As Microsoft.VisualBasic.Compatibility.VB6.LabelArray
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmIgnoreList))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.fraAlternateServer = New System.Windows.Forms.GroupBox
		Me.cmdAdd = New System.Windows.Forms.Button
		Me.cmdDelete = New System.Windows.Forms.Button
		Me.cmdTempPath = New System.Windows.Forms.Button
		Me.txtPath = New AxELFTxtBox.AxTxtBox1
		Me._LBLZ1_4 = New System.Windows.Forms.Label
		Me.lstIgnore = New System.Windows.Forms.ListBox
		Me._LBLZ1_8 = New System.Windows.Forms.Label
		Me.LBLZ1 = New Microsoft.VisualBasic.Compatibility.VB6.LabelArray(components)
		Me.fraAlternateServer.SuspendLayout()
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		CType(Me.txtPath, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.LBLZ1, System.ComponentModel.ISupportInitialize).BeginInit()
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
		Me.Text = "Picture Ignore list"
		Me.ClientSize = New System.Drawing.Size(456, 373)
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
		Me.Name = "frmIgnoreList"
		Me.fraAlternateServer.Text = "Add / Edit"
		Me.fraAlternateServer.Font = New System.Drawing.Font("Arial Narrow", 9!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.fraAlternateServer.Size = New System.Drawing.Size(441, 49)
		Me.fraAlternateServer.Location = New System.Drawing.Point(8, 320)
		Me.fraAlternateServer.TabIndex = 2
		Me.fraAlternateServer.BackColor = System.Drawing.SystemColors.Control
		Me.fraAlternateServer.Enabled = True
		Me.fraAlternateServer.ForeColor = System.Drawing.SystemColors.ControlText
		Me.fraAlternateServer.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.fraAlternateServer.Visible = True
		Me.fraAlternateServer.Padding = New System.Windows.Forms.Padding(0)
		Me.fraAlternateServer.Name = "fraAlternateServer"
		Me.cmdAdd.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdAdd.Text = "Add"
		Me.cmdAdd.Size = New System.Drawing.Size(57, 21)
		Me.cmdAdd.Location = New System.Drawing.Point(312, 16)
		Me.cmdAdd.TabIndex = 7
		Me.cmdAdd.BackColor = System.Drawing.SystemColors.Control
		Me.cmdAdd.CausesValidation = True
		Me.cmdAdd.Enabled = True
		Me.cmdAdd.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdAdd.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdAdd.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdAdd.TabStop = True
		Me.cmdAdd.Name = "cmdAdd"
		Me.cmdDelete.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdDelete.Text = "Delete"
		Me.cmdDelete.Size = New System.Drawing.Size(57, 21)
		Me.cmdDelete.Location = New System.Drawing.Point(376, 16)
		Me.cmdDelete.TabIndex = 6
		Me.cmdDelete.BackColor = System.Drawing.SystemColors.Control
		Me.cmdDelete.CausesValidation = True
		Me.cmdDelete.Enabled = True
		Me.cmdDelete.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdDelete.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdDelete.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdDelete.TabStop = True
		Me.cmdDelete.Name = "cmdDelete"
		Me.cmdTempPath.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdTempPath.Text = ".."
		Me.cmdTempPath.Size = New System.Drawing.Size(17, 21)
		Me.cmdTempPath.Location = New System.Drawing.Point(288, 16)
		Me.cmdTempPath.TabIndex = 5
		Me.cmdTempPath.BackColor = System.Drawing.SystemColors.Control
		Me.cmdTempPath.CausesValidation = True
		Me.cmdTempPath.Enabled = True
		Me.cmdTempPath.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdTempPath.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdTempPath.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdTempPath.TabStop = True
		Me.cmdTempPath.Name = "cmdTempPath"
		txtPath.OcxState = CType(resources.GetObject("txtPath.OcxState"), System.Windows.Forms.AxHost.State)
		Me.txtPath.Size = New System.Drawing.Size(225, 21)
		Me.txtPath.Location = New System.Drawing.Point(56, 16)
		Me.txtPath.TabIndex = 3
		Me.txtPath.Name = "txtPath"
		Me._LBLZ1_4.TextAlign = System.Drawing.ContentAlignment.TopRight
		Me._LBLZ1_4.Text = "Path"
		Me._LBLZ1_4.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_4.Size = New System.Drawing.Size(33, 17)
		Me._LBLZ1_4.Location = New System.Drawing.Point(16, 16)
		Me._LBLZ1_4.TabIndex = 4
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
		Me.lstIgnore.Size = New System.Drawing.Size(441, 293)
		Me.lstIgnore.Location = New System.Drawing.Point(8, 20)
		Me.lstIgnore.TabIndex = 0
		Me.lstIgnore.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.lstIgnore.BackColor = System.Drawing.SystemColors.Window
		Me.lstIgnore.CausesValidation = True
		Me.lstIgnore.Enabled = True
		Me.lstIgnore.ForeColor = System.Drawing.SystemColors.WindowText
		Me.lstIgnore.IntegralHeight = True
		Me.lstIgnore.Cursor = System.Windows.Forms.Cursors.Default
		Me.lstIgnore.SelectionMode = System.Windows.Forms.SelectionMode.One
		Me.lstIgnore.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.lstIgnore.Sorted = False
		Me.lstIgnore.TabStop = True
		Me.lstIgnore.Visible = True
		Me.lstIgnore.MultiColumn = False
		Me.lstIgnore.Name = "lstIgnore"
		Me._LBLZ1_8.Text = "If a picture exists in one of these paths it will not be downloaded"
		Me._LBLZ1_8.Font = New System.Drawing.Font("Arial Narrow", 8.25!, System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me._LBLZ1_8.Size = New System.Drawing.Size(361, 33)
		Me._LBLZ1_8.Location = New System.Drawing.Point(8, 4)
		Me._LBLZ1_8.TabIndex = 1
		Me._LBLZ1_8.TextAlign = System.Drawing.ContentAlignment.TopLeft
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
		Me.LBLZ1.SetIndex(_LBLZ1_4, CType(4, Short))
		Me.LBLZ1.SetIndex(_LBLZ1_8, CType(8, Short))
		CType(Me.LBLZ1, System.ComponentModel.ISupportInitialize).EndInit()
		CType(Me.txtPath, System.ComponentModel.ISupportInitialize).EndInit()
		Me.Controls.Add(fraAlternateServer)
		Me.Controls.Add(lstIgnore)
		Me.Controls.Add(_LBLZ1_8)
		Me.fraAlternateServer.Controls.Add(cmdAdd)
		Me.fraAlternateServer.Controls.Add(cmdDelete)
		Me.fraAlternateServer.Controls.Add(cmdTempPath)
		Me.fraAlternateServer.Controls.Add(txtPath)
		Me.fraAlternateServer.Controls.Add(_LBLZ1_4)
		Me.fraAlternateServer.ResumeLayout(False)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class