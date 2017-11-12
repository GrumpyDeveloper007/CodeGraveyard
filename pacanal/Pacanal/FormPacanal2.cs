using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace Pacanal
{
	/// <summary>
	/// Summary description for FormPacanal2.
	/// </summary>
	public class FormPacanal2 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.ToolBar toolBar1;
		private System.Windows.Forms.StatusBar StatusBar;
		private System.Windows.Forms.MainMenu MenuMain;
		private System.Windows.Forms.ImageList ImageList;
		private System.ComponentModel.IContainer components;

		public FormPacanal2()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.MenuMain = new System.Windows.Forms.MainMenu();
			this.toolBar1 = new System.Windows.Forms.ToolBar();
			this.StatusBar = new System.Windows.Forms.StatusBar();
			this.ImageList = new System.Windows.Forms.ImageList(this.components);
			this.SuspendLayout();
			// 
			// toolBar1
			// 
			this.toolBar1.DropDownArrows = true;
			this.toolBar1.Name = "toolBar1";
			this.toolBar1.ShowToolTips = true;
			this.toolBar1.Size = new System.Drawing.Size(728, 39);
			this.toolBar1.TabIndex = 0;
			// 
			// StatusBar
			// 
			this.StatusBar.Location = new System.Drawing.Point(0, 559);
			this.StatusBar.Name = "StatusBar";
			this.StatusBar.Size = new System.Drawing.Size(728, 22);
			this.StatusBar.TabIndex = 1;
			this.StatusBar.Text = "statusBar1";
			// 
			// ImageList
			// 
			this.ImageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit;
			this.ImageList.ImageSize = new System.Drawing.Size(16, 16);
			this.ImageList.TransparentColor = System.Drawing.Color.Transparent;
			// 
			// FormPacanal2
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(728, 581);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.StatusBar,
																		  this.toolBar1});
			this.Menu = this.MenuMain;
			this.Name = "FormPacanal2";
			this.Text = "Pacanal v1.0 - r.ysie.ysse.ysmu.r.bb";
			this.ResumeLayout(false);

		}
		#endregion
	}
}
