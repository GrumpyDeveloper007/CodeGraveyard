namespace MJsniffer
{
    partial class frmDammageViewer
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
            this.lstDates = new System.Windows.Forms.ListBox();
            this.lstDates2 = new System.Windows.Forms.ListBox();
            this.txtData = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // lstDates
            // 
            this.lstDates.FormattingEnabled = true;
            this.lstDates.Location = new System.Drawing.Point(12, 3);
            this.lstDates.Name = "lstDates";
            this.lstDates.ScrollAlwaysVisible = true;
            this.lstDates.Size = new System.Drawing.Size(120, 212);
            this.lstDates.TabIndex = 0;
            this.lstDates.SelectedIndexChanged += new System.EventHandler(this.lstDates_SelectedIndexChanged);
            // 
            // lstDates2
            // 
            this.lstDates2.FormattingEnabled = true;
            this.lstDates2.Location = new System.Drawing.Point(12, 221);
            this.lstDates2.Name = "lstDates2";
            this.lstDates2.ScrollAlwaysVisible = true;
            this.lstDates2.Size = new System.Drawing.Size(120, 212);
            this.lstDates2.TabIndex = 1;
            this.lstDates2.SelectedIndexChanged += new System.EventHandler(this.lstDates2_SelectedIndexChanged);
            // 
            // txtData
            // 
            this.txtData.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtData.Location = new System.Drawing.Point(138, 3);
            this.txtData.Multiline = true;
            this.txtData.Name = "txtData";
            this.txtData.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtData.Size = new System.Drawing.Size(431, 432);
            this.txtData.TabIndex = 2;
            this.txtData.TextChanged += new System.EventHandler(this.txtData_TextChanged);
            // 
            // frmDammageViewer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(577, 444);
            this.Controls.Add(this.txtData);
            this.Controls.Add(this.lstDates2);
            this.Controls.Add(this.lstDates);
            this.Name = "frmDammageViewer";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmDammageViewer";
            this.Load += new System.EventHandler(this.frmDammageViewer_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox lstDates;
        private System.Windows.Forms.ListBox lstDates2;
        private System.Windows.Forms.TextBox txtData;
    }
}