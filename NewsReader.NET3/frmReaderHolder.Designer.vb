<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmReaderHolder
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmReaderHolder))
        Me.AWinsock = New AxMSWinsockLib.AxWinsock()
        Me.BWinsock = New AxMSWinsockLib.AxWinsock()
        Me.CWinsock = New AxMSWinsockLib.AxWinsock()
        Me.DWinsock = New AxMSWinsockLib.AxWinsock()
        Me.EWinsock = New AxMSWinsockLib.AxWinsock()
        Me.FWinsock = New AxMSWinsockLib.AxWinsock()
        Me.GWinsock = New AxMSWinsockLib.AxWinsock()
        Me.HWinsock = New AxMSWinsockLib.AxWinsock()
        CType(Me.AWinsock, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.BWinsock, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.CWinsock, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DWinsock, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EWinsock, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.FWinsock, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GWinsock, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.HWinsock, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'AWinsock
        '
        Me.AWinsock.Enabled = True
        Me.AWinsock.Location = New System.Drawing.Point(43, 12)
        Me.AWinsock.Name = "AWinsock"
        Me.AWinsock.OcxState = CType(resources.GetObject("AWinsock.OcxState"), System.Windows.Forms.AxHost.State)
        Me.AWinsock.Size = New System.Drawing.Size(28, 28)
        Me.AWinsock.TabIndex = 0
        '
        'BWinsock
        '
        Me.BWinsock.Enabled = True
        Me.BWinsock.Location = New System.Drawing.Point(89, 12)
        Me.BWinsock.Name = "BWinsock"
        Me.BWinsock.OcxState = CType(resources.GetObject("BWinsock.OcxState"), System.Windows.Forms.AxHost.State)
        Me.BWinsock.Size = New System.Drawing.Size(28, 28)
        Me.BWinsock.TabIndex = 1
        '
        'CWinsock
        '
        Me.CWinsock.Enabled = True
        Me.CWinsock.Location = New System.Drawing.Point(123, 12)
        Me.CWinsock.Name = "CWinsock"
        Me.CWinsock.OcxState = CType(resources.GetObject("CWinsock.OcxState"), System.Windows.Forms.AxHost.State)
        Me.CWinsock.Size = New System.Drawing.Size(28, 28)
        Me.CWinsock.TabIndex = 2
        '
        'DWinsock
        '
        Me.DWinsock.Enabled = True
        Me.DWinsock.Location = New System.Drawing.Point(171, 12)
        Me.DWinsock.Name = "DWinsock"
        Me.DWinsock.OcxState = CType(resources.GetObject("DWinsock.OcxState"), System.Windows.Forms.AxHost.State)
        Me.DWinsock.Size = New System.Drawing.Size(28, 28)
        Me.DWinsock.TabIndex = 3
        '
        'EWinsock
        '
        Me.EWinsock.Enabled = True
        Me.EWinsock.Location = New System.Drawing.Point(43, 57)
        Me.EWinsock.Name = "EWinsock"
        Me.EWinsock.OcxState = CType(resources.GetObject("EWinsock.OcxState"), System.Windows.Forms.AxHost.State)
        Me.EWinsock.Size = New System.Drawing.Size(28, 28)
        Me.EWinsock.TabIndex = 4
        '
        'FWinsock
        '
        Me.FWinsock.Enabled = True
        Me.FWinsock.Location = New System.Drawing.Point(89, 57)
        Me.FWinsock.Name = "FWinsock"
        Me.FWinsock.OcxState = CType(resources.GetObject("FWinsock.OcxState"), System.Windows.Forms.AxHost.State)
        Me.FWinsock.Size = New System.Drawing.Size(28, 28)
        Me.FWinsock.TabIndex = 5
        '
        'GWinsock
        '
        Me.GWinsock.Enabled = True
        Me.GWinsock.Location = New System.Drawing.Point(123, 57)
        Me.GWinsock.Name = "GWinsock"
        Me.GWinsock.OcxState = CType(resources.GetObject("GWinsock.OcxState"), System.Windows.Forms.AxHost.State)
        Me.GWinsock.Size = New System.Drawing.Size(28, 28)
        Me.GWinsock.TabIndex = 6
        '
        'HWinsock
        '
        Me.HWinsock.Enabled = True
        Me.HWinsock.Location = New System.Drawing.Point(171, 57)
        Me.HWinsock.Name = "HWinsock"
        Me.HWinsock.OcxState = CType(resources.GetObject("HWinsock.OcxState"), System.Windows.Forms.AxHost.State)
        Me.HWinsock.Size = New System.Drawing.Size(28, 28)
        Me.HWinsock.TabIndex = 7
        '
        'frmReaderHolder
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(292, 266)
        Me.Controls.Add(Me.HWinsock)
        Me.Controls.Add(Me.GWinsock)
        Me.Controls.Add(Me.FWinsock)
        Me.Controls.Add(Me.EWinsock)
        Me.Controls.Add(Me.DWinsock)
        Me.Controls.Add(Me.CWinsock)
        Me.Controls.Add(Me.BWinsock)
        Me.Controls.Add(Me.AWinsock)
        Me.Name = "frmReaderHolder"
        Me.Text = "frmReaderHolder2"
        CType(Me.AWinsock, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.BWinsock, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.CWinsock, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DWinsock, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EWinsock, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.FWinsock, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GWinsock, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.HWinsock, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents AWinsock As AxMSWinsockLib.AxWinsock
    Friend WithEvents BWinsock As AxMSWinsockLib.AxWinsock
    Friend WithEvents CWinsock As AxMSWinsockLib.AxWinsock
    Friend WithEvents DWinsock As AxMSWinsockLib.AxWinsock
    Friend WithEvents EWinsock As AxMSWinsockLib.AxWinsock
    Friend WithEvents FWinsock As AxMSWinsockLib.AxWinsock
    Friend WithEvents GWinsock As AxMSWinsockLib.AxWinsock
    Friend WithEvents HWinsock As AxMSWinsockLib.AxWinsock
End Class