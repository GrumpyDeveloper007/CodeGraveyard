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
            this.txtXY = new System.Windows.Forms.TextBox();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.txtOriginX = new System.Windows.Forms.TextBox();
            this.txtOriginY = new System.Windows.Forms.TextBox();
            this.cboEnchanceBox = new System.Windows.Forms.ComboBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtGreenCount = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.butReset = new System.Windows.Forms.Button();
            this.butPillar = new System.Windows.Forms.Button();
            this.chkPage2 = new System.Windows.Forms.CheckBox();
            this.label5 = new System.Windows.Forms.Label();
            this.txtBusy = new System.Windows.Forms.TextBox();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.chkAH = new System.Windows.Forms.CheckBox();
            this.txtItemInEquip = new System.Windows.Forms.TextBox();
            this.chkCollectOnly = new System.Windows.Forms.CheckBox();
            this.chkCycleGalaxy = new System.Windows.Forms.CheckBox();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.auctionBindingSource1 = new System.Windows.Forms.BindingSource(this.components);
            this.butClicky = new System.Windows.Forms.Button();
            this.butAttach = new System.Windows.Forms.Button();
            this.butVisit = new System.Windows.Forms.Button();
            this.butDaily = new System.Windows.Forms.Button();
            this.butPirate = new System.Windows.Forms.Button();
            this.chkAutoPirate = new System.Windows.Forms.CheckBox();
            this.chkP10 = new System.Windows.Forms.CheckBox();
            this.butEnhanceBlues = new System.Windows.Forms.Button();
            this.chkDoPurples = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.auctionBindingSource1)).BeginInit();
            this.SuspendLayout();
            // 
            // btnStart
            // 
            this.btnStart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnStart.Location = new System.Drawing.Point(12, 398);
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
            this.cmbInterfaces.Location = new System.Drawing.Point(128, 405);
            this.cmbInterfaces.Name = "cmbInterfaces";
            this.cmbInterfaces.Size = new System.Drawing.Size(906, 21);
            this.cmbInterfaces.TabIndex = 2;
            // 
            // txtXY
            // 
            this.txtXY.Location = new System.Drawing.Point(316, 9);
            this.txtXY.Name = "txtXY";
            this.txtXY.Size = new System.Drawing.Size(100, 20);
            this.txtXY.TabIndex = 11;
            // 
            // timer1
            // 
            this.timer1.Interval = 1000;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // txtOriginX
            // 
            this.txtOriginX.Location = new System.Drawing.Point(107, 7);
            this.txtOriginX.Name = "txtOriginX";
            this.txtOriginX.Size = new System.Drawing.Size(41, 20);
            this.txtOriginX.TabIndex = 12;
            // 
            // txtOriginY
            // 
            this.txtOriginY.Location = new System.Drawing.Point(163, 7);
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
            // butPillar
            // 
            this.butPillar.Location = new System.Drawing.Point(422, 6);
            this.butPillar.Name = "butPillar";
            this.butPillar.Size = new System.Drawing.Size(75, 23);
            this.butPillar.TabIndex = 20;
            this.butPillar.Text = "Pillar";
            this.butPillar.UseVisualStyleBackColor = true;
            this.butPillar.Click += new System.EventHandler(this.butPillar_Click);
            // 
            // chkPage2
            // 
            this.chkPage2.AutoSize = true;
            this.chkPage2.Location = new System.Drawing.Point(250, 31);
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
            this.label5.Location = new System.Drawing.Point(17, 8);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(84, 13);
            this.label5.TabIndex = 22;
            this.label5.Text = "TW Window loc";
            // 
            // txtBusy
            // 
            this.txtBusy.Location = new System.Drawing.Point(272, 8);
            this.txtBusy.Name = "txtBusy";
            this.txtBusy.Size = new System.Drawing.Size(38, 20);
            this.txtBusy.TabIndex = 23;
            // 
            // dataGridView1
            // 
            this.dataGridView1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
            | System.Windows.Forms.AnchorStyles.Left)
            | System.Windows.Forms.AnchorStyles.Right)));
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(13, 116);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(1002, 276);
            this.dataGridView1.TabIndex = 24;
            this.dataGridView1.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellContentClick);
            // 
            // chkAH
            // 
            this.chkAH.AutoSize = true;
            this.chkAH.Checked = true;
            this.chkAH.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkAH.Location = new System.Drawing.Point(403, 33);
            this.chkAH.Name = "chkAH";
            this.chkAH.Size = new System.Drawing.Size(38, 17);
            this.chkAH.TabIndex = 26;
            this.chkAH.Text = "ah";
            this.chkAH.UseVisualStyleBackColor = true;
            // 
            // txtItemInEquip
            // 
            this.txtItemInEquip.BackColor = System.Drawing.Color.Red;
            this.txtItemInEquip.Location = new System.Drawing.Point(125, 61);
            this.txtItemInEquip.Name = "txtItemInEquip";
            this.txtItemInEquip.Size = new System.Drawing.Size(572, 20);
            this.txtItemInEquip.TabIndex = 27;
            // 
            // chkCollectOnly
            // 
            this.chkCollectOnly.AutoSize = true;
            this.chkCollectOnly.Location = new System.Drawing.Point(316, 31);
            this.chkCollectOnly.Name = "chkCollectOnly";
            this.chkCollectOnly.Size = new System.Drawing.Size(62, 17);
            this.chkCollectOnly.TabIndex = 31;
            this.chkCollectOnly.Text = "col only";
            this.chkCollectOnly.UseVisualStyleBackColor = true;
            // 
            // chkCycleGalaxy
            // 
            this.chkCycleGalaxy.AutoSize = true;
            this.chkCycleGalaxy.Location = new System.Drawing.Point(447, 31);
            this.chkCycleGalaxy.Name = "chkCycleGalaxy";
            this.chkCycleGalaxy.Size = new System.Drawing.Size(84, 17);
            this.chkCycleGalaxy.TabIndex = 33;
            this.chkCycleGalaxy.Text = "cycle galaxy";
            this.chkCycleGalaxy.UseVisualStyleBackColor = true;
            this.chkCycleGalaxy.CheckedChanged += new System.EventHandler(this.chkCycleGalaxy_CheckedChanged);
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new System.Drawing.Point(184, 33);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(60, 17);
            this.checkBox1.TabIndex = 34;
            this.checkBox1.Text = "Page 3";
            this.checkBox1.UseVisualStyleBackColor = true;
            this.checkBox1.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // butClicky
            // 
            this.butClicky.Location = new System.Drawing.Point(764, 42);
            this.butClicky.Name = "butClicky";
            this.butClicky.Size = new System.Drawing.Size(75, 23);
            this.butClicky.TabIndex = 35;
            this.butClicky.Text = "Clichy";
            this.butClicky.UseVisualStyleBackColor = true;
            this.butClicky.Click += new System.EventHandler(this.ButClicky_Click);
            // 
            // butAttach
            // 
            this.butAttach.Location = new System.Drawing.Point(764, 9);
            this.butAttach.Name = "butAttach";
            this.butAttach.Size = new System.Drawing.Size(75, 23);
            this.butAttach.TabIndex = 36;
            this.butAttach.Text = "attack";
            this.butAttach.UseVisualStyleBackColor = true;
            this.butAttach.Click += new System.EventHandler(this.butAttach_Click);
            // 
            // butVisit
            // 
            this.butVisit.Location = new System.Drawing.Point(845, 42);
            this.butVisit.Name = "butVisit";
            this.butVisit.Size = new System.Drawing.Size(75, 23);
            this.butVisit.TabIndex = 37;
            this.butVisit.Text = "Visit";
            this.butVisit.UseVisualStyleBackColor = true;
            this.butVisit.Click += new System.EventHandler(this.butVisit_Click);
            // 
            // butDaily
            // 
            this.butDaily.Location = new System.Drawing.Point(845, 9);
            this.butDaily.Name = "butDaily";
            this.butDaily.Size = new System.Drawing.Size(75, 23);
            this.butDaily.TabIndex = 38;
            this.butDaily.Text = "Daily";
            this.butDaily.UseVisualStyleBackColor = true;
            this.butDaily.Click += new System.EventHandler(this.butDaily_Click);
            // 
            // butPirate
            // 
            this.butPirate.Location = new System.Drawing.Point(942, 8);
            this.butPirate.Name = "butPirate";
            this.butPirate.Size = new System.Drawing.Size(75, 23);
            this.butPirate.TabIndex = 39;
            this.butPirate.Text = "pirate";
            this.butPirate.UseVisualStyleBackColor = true;
            this.butPirate.Click += new System.EventHandler(this.butPirate_Click);
            // 
            // chkAutoPirate
            // 
            this.chkAutoPirate.AutoSize = true;
            this.chkAutoPirate.Location = new System.Drawing.Point(942, 42);
            this.chkAutoPirate.Name = "chkAutoPirate";
            this.chkAutoPirate.Size = new System.Drawing.Size(76, 17);
            this.chkAutoPirate.TabIndex = 40;
            this.chkAutoPirate.Text = "auto priate";
            this.chkAutoPirate.UseVisualStyleBackColor = true;
            // 
            // chkP10
            // 
            this.chkP10.AutoSize = true;
            this.chkP10.Location = new System.Drawing.Point(890, 87);
            this.chkP10.Name = "chkP10";
            this.chkP10.Size = new System.Drawing.Size(44, 17);
            this.chkP10.TabIndex = 41;
            this.chkP10.Text = "p10";
            this.chkP10.UseVisualStyleBackColor = true;
            // 
            // butEnhanceBlues
            // 
            this.butEnhanceBlues.Location = new System.Drawing.Point(940, 87);
            this.butEnhanceBlues.Name = "butEnhanceBlues";
            this.butEnhanceBlues.Size = new System.Drawing.Size(75, 23);
            this.butEnhanceBlues.TabIndex = 42;
            this.butEnhanceBlues.Text = "Enha Blue";
            this.butEnhanceBlues.UseVisualStyleBackColor = true;
            this.butEnhanceBlues.Click += new System.EventHandler(this.butEnhanceBlues_Click);
            // 
            // chkDoPurples
            // 
            this.chkDoPurples.AutoSize = true;
            this.chkDoPurples.Location = new System.Drawing.Point(808, 87);
            this.chkDoPurples.Name = "chkDoPurples";
            this.chkDoPurples.Size = new System.Drawing.Size(76, 17);
            this.chkDoPurples.TabIndex = 43;
            this.chkDoPurples.Text = "do Purples";
            this.chkDoPurples.UseVisualStyleBackColor = true;
            // 
            // MJsnifferForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1047, 437);
            this.Controls.Add(this.chkDoPurples);
            this.Controls.Add(this.butEnhanceBlues);
            this.Controls.Add(this.chkP10);
            this.Controls.Add(this.chkAutoPirate);
            this.Controls.Add(this.butPirate);
            this.Controls.Add(this.butDaily);
            this.Controls.Add(this.butVisit);
            this.Controls.Add(this.txtItemInEquip);
            this.Controls.Add(this.butAttach);
            this.Controls.Add(this.butClicky);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.chkCycleGalaxy);
            this.Controls.Add(this.chkCollectOnly);
            this.Controls.Add(this.chkAH);
            this.Controls.Add(this.txtBusy);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.chkPage2);
            this.Controls.Add(this.butPillar);
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
            this.Controls.Add(this.dataGridView1);
            this.KeyPreview = true;
            this.Name = "MJsnifferForm";
            this.Text = "MJsniffer";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.SnifferForm_FormClosing);
            this.Load += new System.EventHandler(this.SnifferForm_Load);
            this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.MJsnifferForm_KeyPress);
            this.MouseEnter += new System.EventHandler(this.MJsnifferForm_MouseEnter);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.auctionBindingSource1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Button btnStart;
        private System.Windows.Forms.ComboBox cmbInterfaces;
        private System.Windows.Forms.TextBox txtXY;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.TextBox txtOriginX;
        private System.Windows.Forms.TextBox txtOriginY;
        private System.Windows.Forms.ComboBox cboEnchanceBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtGreenCount;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button butReset;
        private System.Windows.Forms.Button butPillar;
        private System.Windows.Forms.CheckBox chkPage2;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txtBusy;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.BindingSource auctionBindingSource1;
        private System.Windows.Forms.CheckBox chkAH;
        private System.Windows.Forms.TextBox txtItemInEquip;
        private System.Windows.Forms.CheckBox chkCollectOnly;
        private System.Windows.Forms.CheckBox chkCycleGalaxy;
        private System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.Button butClicky;
        private System.Windows.Forms.Button butAttach;
        private System.Windows.Forms.Button butVisit;
        private System.Windows.Forms.Button butDaily;
        private System.Windows.Forms.Button butPirate;
        private System.Windows.Forms.CheckBox chkAutoPirate;
        private System.Windows.Forms.CheckBox chkP10;
        private System.Windows.Forms.Button butEnhanceBlues;
        private System.Windows.Forms.CheckBox chkDoPurples;
    }
}

