namespace MJsniffer
{
    partial class MJsnifferForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.btnStart = new System.Windows.Forms.Button();
            this.cmbInterfaces = new System.Windows.Forms.ComboBox();
            this.txtOriginX = new System.Windows.Forms.TextBox();
            this.txtOriginY = new System.Windows.Forms.TextBox();
            this.cboEnchanceBox = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtGreenCount = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.butReset = new System.Windows.Forms.Button();
            this.chkPage2 = new System.Windows.Forms.CheckBox();
            this.label5 = new System.Windows.Forms.Label();
            this.chkCollectOnly = new System.Windows.Forms.CheckBox();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.txtBusy = new System.Windows.Forms.TextBox();
            this.txtXY = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // btnStart
            // 
            this.btnStart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnStart.Location = new System.Drawing.Point(13, 90);
            this.btnStart.Name = "btnStart";
            this.btnStart.Size = new System.Drawing.Size(91, 33);
            this.btnStart.TabIndex = 1;
            this.btnStart.Text = "&Start";
            this.btnStart.UseVisualStyleBackColor = true;
            this.btnStart.Click += new System.EventHandler(this.btnStart_Click);
            // 
            // cmbInterfaces
            // 
            this.cmbInterfaces.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.cmbInterfaces.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbInterfaces.FormattingEnabled = true;
            this.cmbInterfaces.Location = new System.Drawing.Point(129, 97);
            this.cmbInterfaces.Name = "cmbInterfaces";
            this.cmbInterfaces.Size = new System.Drawing.Size(441, 21);
            this.cmbInterfaces.TabIndex = 2;
            // 
            // txtOriginX
            // 
            this.txtOriginX.Location = new System.Drawing.Point(465, 12);
            this.txtOriginX.Name = "txtOriginX";
            this.txtOriginX.Size = new System.Drawing.Size(41, 20);
            this.txtOriginX.TabIndex = 12;
            // 
            // txtOriginY
            // 
            this.txtOriginY.Location = new System.Drawing.Point(521, 12);
            this.txtOriginY.Name = "txtOriginY";
            this.txtOriginY.Size = new System.Drawing.Size(39, 20);
            this.txtOriginY.TabIndex = 13;
            // 
            // cboEnchanceBox
            // 
            this.cboEnchanceBox.FormattingEnabled = true;
            this.cboEnchanceBox.Items.AddRange(new object[] {
            "263 (1)",
            "291 (2)",
            "309 (3)",
            "341 (4)",
            "366 (5)",
            "392 (6)",
            "416 (7)",
            "447 (8)",
            "472 (9)",
            "499 (10)"});
            this.cboEnchanceBox.Location = new System.Drawing.Point(58, 60);
            this.cboEnchanceBox.Name = "cboEnchanceBox";
            this.cboEnchanceBox.Size = new System.Drawing.Size(61, 21);
            this.cboEnchanceBox.TabIndex = 14;
            this.cboEnchanceBox.SelectedIndexChanged += new System.EventHandler(this.cboEnchanceBox_SelectedIndexChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(26, 61);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(25, 13);
            this.label3.TabIndex = 15;
            this.label3.Text = "Box";
            // 
            // txtGreenCount
            // 
            this.txtGreenCount.Location = new System.Drawing.Point(58, 35);
            this.txtGreenCount.Name = "txtGreenCount";
            this.txtGreenCount.Size = new System.Drawing.Size(38, 20);
            this.txtGreenCount.TabIndex = 17;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(17, 38);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(36, 13);
            this.label4.TabIndex = 18;
            this.label4.Text = "Green";
            // 
            // butReset
            // 
            this.butReset.Location = new System.Drawing.Point(103, 31);
            this.butReset.Name = "butReset";
            this.butReset.Size = new System.Drawing.Size(75, 23);
            this.butReset.TabIndex = 19;
            this.butReset.Text = "Reset";
            this.butReset.UseVisualStyleBackColor = true;
            this.butReset.Click += new System.EventHandler(this.butReset_Click);
            // 
            // chkPage2
            // 
            this.chkPage2.AutoSize = true;
            this.chkPage2.Location = new System.Drawing.Point(125, 62);
            this.chkPage2.Name = "chkPage2";
            this.chkPage2.Size = new System.Drawing.Size(60, 17);
            this.chkPage2.TabIndex = 21;
            this.chkPage2.Text = "Page 2";
            this.chkPage2.UseVisualStyleBackColor = true;
            this.chkPage2.CheckedChanged += new System.EventHandler(this.chkPage2_CheckedChanged);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(375, 13);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(84, 13);
            this.label5.TabIndex = 22;
            this.label5.Text = "TW Window loc";
            // 
            // chkCollectOnly
            // 
            this.chkCollectOnly.AutoSize = true;
            this.chkCollectOnly.Checked = true;
            this.chkCollectOnly.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkCollectOnly.Location = new System.Drawing.Point(191, 63);
            this.chkCollectOnly.Name = "chkCollectOnly";
            this.chkCollectOnly.Size = new System.Drawing.Size(62, 17);
            this.chkCollectOnly.TabIndex = 31;
            this.chkCollectOnly.Text = "col only";
            this.chkCollectOnly.UseVisualStyleBackColor = true;
            // 
            // timer1
            // 
            this.timer1.Enabled = true;
            this.timer1.Interval = 1000;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // txtBusy
            // 
            this.txtBusy.Location = new System.Drawing.Point(522, 38);
            this.txtBusy.Name = "txtBusy";
            this.txtBusy.Size = new System.Drawing.Size(38, 20);
            this.txtBusy.TabIndex = 23;
            // 
            // txtXY
            // 
            this.txtXY.Location = new System.Drawing.Point(103, 5);
            this.txtXY.Name = "txtXY";
            this.txtXY.Size = new System.Drawing.Size(100, 20);
            this.txtXY.TabIndex = 11;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(42, 8);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(55, 13);
            this.label1.TabIndex = 32;
            this.label1.Text = "mouse loc";
            // 
            // MJsnifferForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(582, 130);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.chkCollectOnly);
            this.Controls.Add(this.txtBusy);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.chkPage2);
            this.Controls.Add(this.butReset);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.txtGreenCount);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.cboEnchanceBox);
            this.Controls.Add(this.txtOriginY);
            this.Controls.Add(this.txtOriginX);
            this.Controls.Add(this.txtXY);
            this.Controls.Add(this.cmbInterfaces);
            this.Controls.Add(this.btnStart);
            this.KeyPreview = true;
            this.Name = "MJsnifferForm";
            this.Text = "TWMacro";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.SnifferForm_FormClosing);
            this.Load += new System.EventHandler(this.SnifferForm_Load);
            this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.MJsnifferForm_KeyPress);
            this.MouseEnter += new System.EventHandler(this.MJsnifferForm_MouseEnter);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnStart;
        private System.Windows.Forms.ComboBox cmbInterfaces;
        private System.Windows.Forms.TextBox txtOriginX;
        private System.Windows.Forms.TextBox txtOriginY;
        private System.Windows.Forms.ComboBox cboEnchanceBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtGreenCount;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button butReset;
        private System.Windows.Forms.CheckBox chkPage2;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.CheckBox chkCollectOnly;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.TextBox txtBusy;
        private System.Windows.Forms.TextBox txtXY;
        private System.Windows.Forms.Label label1;
    }
}

