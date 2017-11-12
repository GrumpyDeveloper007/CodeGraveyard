using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using MyClasses;

namespace Pacanal
{

	public class CaptureDisplay : System.Windows.Forms.Form
	{
		private System.Windows.Forms.GroupBox GrpBoxCapture;
		private System.Windows.Forms.Label LblTotal;
		private System.Windows.Forms.Label LblTotalCount;
		private System.Windows.Forms.Label LblTotalPct;
		private System.Windows.Forms.Label LblSCPT;
		private System.Windows.Forms.Label LblSCPTCount;
		private System.Windows.Forms.Label LblTCP;
		private System.Windows.Forms.Label LblSCPTPct;
		private System.Windows.Forms.Label LblTCPCount;
		private System.Windows.Forms.Label LblTCPPct;
		private System.Windows.Forms.Label LblUDP;
		private System.Windows.Forms.Label LblUDPPct;
		private System.Windows.Forms.Label LblICMP;
		private System.Windows.Forms.Label LblUDPCount;
		private System.Windows.Forms.Label LblICMPPct;
		private System.Windows.Forms.Label LblICMPCount;
		private System.Windows.Forms.Label LblOSPF;
		private System.Windows.Forms.Label LblARP;
		private System.Windows.Forms.Label LblOSPFCount;
		private System.Windows.Forms.Label LblARPCount;
		private System.Windows.Forms.Label LblOSPFPct;
		private System.Windows.Forms.Label LblARPPct;
		private System.Windows.Forms.Label LblGRE;
		private System.Windows.Forms.Label LblGRECount;
		private System.Windows.Forms.Label LblNetBIOS;
		private System.Windows.Forms.Label LblGREPct;
		private System.Windows.Forms.Label LblNetBIOSCount;
		private System.Windows.Forms.Label LblNetBIOSPct;
		private System.Windows.Forms.Label LblIPX;
		private System.Windows.Forms.Label LblIPXPct;
		private System.Windows.Forms.Label LblIPXCount;
		private System.Windows.Forms.Label LblVINESCount;
		private System.Windows.Forms.Label LblVINES;
		private System.Windows.Forms.Label LblVINESPct;
		private System.Windows.Forms.Label LblOther;
		private System.Windows.Forms.Label LblOtherPct;
		private System.Windows.Forms.Label LblOtherCount;
		private System.Windows.Forms.GroupBox GrpBoxRunningTime;
		private System.Windows.Forms.Label LblRunningTime;
		private System.Windows.Forms.Button BtnStop;
		public Packet32 P32;
		private System.Windows.Forms.Timer CaptureTimer;
		private System.ComponentModel.IContainer components;
		private System.Windows.Forms.GroupBox GrpBoxReadBytes;
		private System.Windows.Forms.Label LblBytesRead;
		private bool IsTimerRunning = false;
		public ListView LVw;
		public TreeNodeCollection Tnc;
		public RichTextBox Rtx;


		public CaptureDisplay()
		{
			InitializeComponent();
		}


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
		private  void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.GrpBoxCapture = new System.Windows.Forms.GroupBox();
			this.LblOtherCount = new System.Windows.Forms.Label();
			this.LblOtherPct = new System.Windows.Forms.Label();
			this.LblOther = new System.Windows.Forms.Label();
			this.LblVINESPct = new System.Windows.Forms.Label();
			this.LblVINES = new System.Windows.Forms.Label();
			this.LblVINESCount = new System.Windows.Forms.Label();
			this.LblIPXCount = new System.Windows.Forms.Label();
			this.LblIPXPct = new System.Windows.Forms.Label();
			this.LblIPX = new System.Windows.Forms.Label();
			this.LblNetBIOSPct = new System.Windows.Forms.Label();
			this.LblNetBIOSCount = new System.Windows.Forms.Label();
			this.LblGREPct = new System.Windows.Forms.Label();
			this.LblNetBIOS = new System.Windows.Forms.Label();
			this.LblGRECount = new System.Windows.Forms.Label();
			this.LblGRE = new System.Windows.Forms.Label();
			this.LblARPPct = new System.Windows.Forms.Label();
			this.LblOSPFPct = new System.Windows.Forms.Label();
			this.LblARPCount = new System.Windows.Forms.Label();
			this.LblOSPFCount = new System.Windows.Forms.Label();
			this.LblARP = new System.Windows.Forms.Label();
			this.LblOSPF = new System.Windows.Forms.Label();
			this.LblICMPCount = new System.Windows.Forms.Label();
			this.LblICMPPct = new System.Windows.Forms.Label();
			this.LblUDPCount = new System.Windows.Forms.Label();
			this.LblICMP = new System.Windows.Forms.Label();
			this.LblUDPPct = new System.Windows.Forms.Label();
			this.LblUDP = new System.Windows.Forms.Label();
			this.LblTCPPct = new System.Windows.Forms.Label();
			this.LblTCPCount = new System.Windows.Forms.Label();
			this.LblSCPTPct = new System.Windows.Forms.Label();
			this.LblTCP = new System.Windows.Forms.Label();
			this.LblSCPTCount = new System.Windows.Forms.Label();
			this.LblSCPT = new System.Windows.Forms.Label();
			this.LblTotalPct = new System.Windows.Forms.Label();
			this.LblTotalCount = new System.Windows.Forms.Label();
			this.LblTotal = new System.Windows.Forms.Label();
			this.GrpBoxRunningTime = new System.Windows.Forms.GroupBox();
			this.LblRunningTime = new System.Windows.Forms.Label();
			this.BtnStop = new System.Windows.Forms.Button();
			this.CaptureTimer = new System.Windows.Forms.Timer(this.components);
			this.GrpBoxReadBytes = new System.Windows.Forms.GroupBox();
			this.LblBytesRead = new System.Windows.Forms.Label();
			this.GrpBoxCapture.SuspendLayout();
			this.GrpBoxRunningTime.SuspendLayout();
			this.GrpBoxReadBytes.SuspendLayout();
			this.SuspendLayout();
			// 
			// GrpBoxCapture
			// 
			this.GrpBoxCapture.Controls.AddRange(new System.Windows.Forms.Control[] {
																						this.LblOtherCount,
																						this.LblOtherPct,
																						this.LblOther,
																						this.LblVINESPct,
																						this.LblVINES,
																						this.LblVINESCount,
																						this.LblIPXCount,
																						this.LblIPXPct,
																						this.LblIPX,
																						this.LblNetBIOSPct,
																						this.LblNetBIOSCount,
																						this.LblGREPct,
																						this.LblNetBIOS,
																						this.LblGRECount,
																						this.LblGRE,
																						this.LblARPPct,
																						this.LblOSPFPct,
																						this.LblARPCount,
																						this.LblOSPFCount,
																						this.LblARP,
																						this.LblOSPF,
																						this.LblICMPCount,
																						this.LblICMPPct,
																						this.LblUDPCount,
																						this.LblICMP,
																						this.LblUDPPct,
																						this.LblUDP,
																						this.LblTCPPct,
																						this.LblTCPCount,
																						this.LblSCPTPct,
																						this.LblTCP,
																						this.LblSCPTCount,
																						this.LblSCPT,
																						this.LblTotalPct,
																						this.LblTotalCount,
																						this.LblTotal});
			this.GrpBoxCapture.Location = new System.Drawing.Point(8, 8);
			this.GrpBoxCapture.Name = "GrpBoxCapture";
			this.GrpBoxCapture.Size = new System.Drawing.Size(224, 232);
			this.GrpBoxCapture.TabIndex = 0;
			this.GrpBoxCapture.TabStop = false;
			this.GrpBoxCapture.Text = "   Captured Frames   ";
			// 
			// LblOtherCount
			// 
			this.LblOtherCount.AutoSize = true;
			this.LblOtherCount.Location = new System.Drawing.Point(88, 200);
			this.LblOtherCount.Name = "LblOtherCount";
			this.LblOtherCount.Size = new System.Drawing.Size(11, 13);
			this.LblOtherCount.TabIndex = 35;
			this.LblOtherCount.Text = "0";
			// 
			// LblOtherPct
			// 
			this.LblOtherPct.AutoSize = true;
			this.LblOtherPct.Location = new System.Drawing.Point(136, 200);
			this.LblOtherPct.Name = "LblOtherPct";
			this.LblOtherPct.Size = new System.Drawing.Size(55, 13);
			this.LblOtherPct.TabIndex = 34;
			this.LblOtherPct.Text = "( 0.00 % )";
			// 
			// LblOther
			// 
			this.LblOther.AutoSize = true;
			this.LblOther.Location = new System.Drawing.Point(16, 200);
			this.LblOther.Name = "LblOther";
			this.LblOther.Size = new System.Drawing.Size(34, 13);
			this.LblOther.TabIndex = 33;
			this.LblOther.Text = "Other";
			// 
			// LblVINESPct
			// 
			this.LblVINESPct.AutoSize = true;
			this.LblVINESPct.Location = new System.Drawing.Point(136, 184);
			this.LblVINESPct.Name = "LblVINESPct";
			this.LblVINESPct.Size = new System.Drawing.Size(55, 13);
			this.LblVINESPct.TabIndex = 32;
			this.LblVINESPct.Text = "( 0.00 % )";
			// 
			// LblVINES
			// 
			this.LblVINES.AutoSize = true;
			this.LblVINES.Location = new System.Drawing.Point(16, 184);
			this.LblVINES.Name = "LblVINES";
			this.LblVINES.Size = new System.Drawing.Size(39, 13);
			this.LblVINES.TabIndex = 31;
			this.LblVINES.Text = "VINES";
			// 
			// LblVINESCount
			// 
			this.LblVINESCount.AutoSize = true;
			this.LblVINESCount.Location = new System.Drawing.Point(88, 184);
			this.LblVINESCount.Name = "LblVINESCount";
			this.LblVINESCount.Size = new System.Drawing.Size(11, 13);
			this.LblVINESCount.TabIndex = 30;
			this.LblVINESCount.Text = "0";
			// 
			// LblIPXCount
			// 
			this.LblIPXCount.AutoSize = true;
			this.LblIPXCount.Location = new System.Drawing.Point(88, 168);
			this.LblIPXCount.Name = "LblIPXCount";
			this.LblIPXCount.Size = new System.Drawing.Size(11, 13);
			this.LblIPXCount.TabIndex = 29;
			this.LblIPXCount.Text = "0";
			// 
			// LblIPXPct
			// 
			this.LblIPXPct.AutoSize = true;
			this.LblIPXPct.Location = new System.Drawing.Point(136, 168);
			this.LblIPXPct.Name = "LblIPXPct";
			this.LblIPXPct.Size = new System.Drawing.Size(55, 13);
			this.LblIPXPct.TabIndex = 28;
			this.LblIPXPct.Text = "( 0.00 % )";
			// 
			// LblIPX
			// 
			this.LblIPX.AutoSize = true;
			this.LblIPX.Location = new System.Drawing.Point(16, 168);
			this.LblIPX.Name = "LblIPX";
			this.LblIPX.Size = new System.Drawing.Size(23, 13);
			this.LblIPX.TabIndex = 27;
			this.LblIPX.Text = "IPX";
			// 
			// LblNetBIOSPct
			// 
			this.LblNetBIOSPct.AutoSize = true;
			this.LblNetBIOSPct.Location = new System.Drawing.Point(136, 152);
			this.LblNetBIOSPct.Name = "LblNetBIOSPct";
			this.LblNetBIOSPct.Size = new System.Drawing.Size(55, 13);
			this.LblNetBIOSPct.TabIndex = 26;
			this.LblNetBIOSPct.Text = "( 0.00 % )";
			// 
			// LblNetBIOSCount
			// 
			this.LblNetBIOSCount.AutoSize = true;
			this.LblNetBIOSCount.Location = new System.Drawing.Point(88, 152);
			this.LblNetBIOSCount.Name = "LblNetBIOSCount";
			this.LblNetBIOSCount.Size = new System.Drawing.Size(11, 13);
			this.LblNetBIOSCount.TabIndex = 25;
			this.LblNetBIOSCount.Text = "0";
			// 
			// LblGREPct
			// 
			this.LblGREPct.AutoSize = true;
			this.LblGREPct.Location = new System.Drawing.Point(136, 136);
			this.LblGREPct.Name = "LblGREPct";
			this.LblGREPct.Size = new System.Drawing.Size(55, 13);
			this.LblGREPct.TabIndex = 24;
			this.LblGREPct.Text = "( 0.00 % )";
			// 
			// LblNetBIOS
			// 
			this.LblNetBIOS.AutoSize = true;
			this.LblNetBIOS.Location = new System.Drawing.Point(16, 152);
			this.LblNetBIOS.Name = "LblNetBIOS";
			this.LblNetBIOS.Size = new System.Drawing.Size(50, 13);
			this.LblNetBIOS.TabIndex = 23;
			this.LblNetBIOS.Text = "NetBIOS";
			// 
			// LblGRECount
			// 
			this.LblGRECount.AutoSize = true;
			this.LblGRECount.Location = new System.Drawing.Point(88, 136);
			this.LblGRECount.Name = "LblGRECount";
			this.LblGRECount.Size = new System.Drawing.Size(11, 13);
			this.LblGRECount.TabIndex = 22;
			this.LblGRECount.Text = "0";
			// 
			// LblGRE
			// 
			this.LblGRE.AutoSize = true;
			this.LblGRE.Location = new System.Drawing.Point(16, 136);
			this.LblGRE.Name = "LblGRE";
			this.LblGRE.Size = new System.Drawing.Size(29, 13);
			this.LblGRE.TabIndex = 21;
			this.LblGRE.Text = "GRE";
			// 
			// LblARPPct
			// 
			this.LblARPPct.AutoSize = true;
			this.LblARPPct.Location = new System.Drawing.Point(136, 104);
			this.LblARPPct.Name = "LblARPPct";
			this.LblARPPct.Size = new System.Drawing.Size(55, 13);
			this.LblARPPct.TabIndex = 20;
			this.LblARPPct.Text = "( 0.00 % )";
			// 
			// LblOSPFPct
			// 
			this.LblOSPFPct.AutoSize = true;
			this.LblOSPFPct.Location = new System.Drawing.Point(136, 120);
			this.LblOSPFPct.Name = "LblOSPFPct";
			this.LblOSPFPct.Size = new System.Drawing.Size(55, 13);
			this.LblOSPFPct.TabIndex = 19;
			this.LblOSPFPct.Text = "( 0.00 % )";
			// 
			// LblARPCount
			// 
			this.LblARPCount.AutoSize = true;
			this.LblARPCount.Location = new System.Drawing.Point(88, 104);
			this.LblARPCount.Name = "LblARPCount";
			this.LblARPCount.Size = new System.Drawing.Size(11, 13);
			this.LblARPCount.TabIndex = 18;
			this.LblARPCount.Text = "0";
			// 
			// LblOSPFCount
			// 
			this.LblOSPFCount.AutoSize = true;
			this.LblOSPFCount.Location = new System.Drawing.Point(88, 120);
			this.LblOSPFCount.Name = "LblOSPFCount";
			this.LblOSPFCount.Size = new System.Drawing.Size(11, 13);
			this.LblOSPFCount.TabIndex = 17;
			this.LblOSPFCount.Text = "0";
			// 
			// LblARP
			// 
			this.LblARP.AutoSize = true;
			this.LblARP.Location = new System.Drawing.Point(16, 104);
			this.LblARP.Name = "LblARP";
			this.LblARP.Size = new System.Drawing.Size(28, 13);
			this.LblARP.TabIndex = 16;
			this.LblARP.Text = "ARP";
			// 
			// LblOSPF
			// 
			this.LblOSPF.AutoSize = true;
			this.LblOSPF.Location = new System.Drawing.Point(16, 120);
			this.LblOSPF.Name = "LblOSPF";
			this.LblOSPF.Size = new System.Drawing.Size(36, 13);
			this.LblOSPF.TabIndex = 15;
			this.LblOSPF.Text = "OSPF";
			// 
			// LblICMPCount
			// 
			this.LblICMPCount.AutoSize = true;
			this.LblICMPCount.Location = new System.Drawing.Point(88, 88);
			this.LblICMPCount.Name = "LblICMPCount";
			this.LblICMPCount.Size = new System.Drawing.Size(11, 13);
			this.LblICMPCount.TabIndex = 14;
			this.LblICMPCount.Text = "0";
			// 
			// LblICMPPct
			// 
			this.LblICMPPct.AutoSize = true;
			this.LblICMPPct.Location = new System.Drawing.Point(136, 88);
			this.LblICMPPct.Name = "LblICMPPct";
			this.LblICMPPct.Size = new System.Drawing.Size(55, 13);
			this.LblICMPPct.TabIndex = 13;
			this.LblICMPPct.Text = "( 0.00 % )";
			// 
			// LblUDPCount
			// 
			this.LblUDPCount.AutoSize = true;
			this.LblUDPCount.Location = new System.Drawing.Point(88, 72);
			this.LblUDPCount.Name = "LblUDPCount";
			this.LblUDPCount.Size = new System.Drawing.Size(11, 13);
			this.LblUDPCount.TabIndex = 12;
			this.LblUDPCount.Text = "0";
			// 
			// LblICMP
			// 
			this.LblICMP.AutoSize = true;
			this.LblICMP.Location = new System.Drawing.Point(16, 88);
			this.LblICMP.Name = "LblICMP";
			this.LblICMP.Size = new System.Drawing.Size(33, 13);
			this.LblICMP.TabIndex = 11;
			this.LblICMP.Text = "ICMP";
			// 
			// LblUDPPct
			// 
			this.LblUDPPct.AutoSize = true;
			this.LblUDPPct.Location = new System.Drawing.Point(136, 72);
			this.LblUDPPct.Name = "LblUDPPct";
			this.LblUDPPct.Size = new System.Drawing.Size(55, 13);
			this.LblUDPPct.TabIndex = 10;
			this.LblUDPPct.Text = "( 0.00 % )";
			// 
			// LblUDP
			// 
			this.LblUDP.AutoSize = true;
			this.LblUDP.Location = new System.Drawing.Point(16, 72);
			this.LblUDP.Name = "LblUDP";
			this.LblUDP.Size = new System.Drawing.Size(29, 13);
			this.LblUDP.TabIndex = 9;
			this.LblUDP.Text = "UDP";
			// 
			// LblTCPPct
			// 
			this.LblTCPPct.AutoSize = true;
			this.LblTCPPct.Location = new System.Drawing.Point(136, 56);
			this.LblTCPPct.Name = "LblTCPPct";
			this.LblTCPPct.Size = new System.Drawing.Size(55, 13);
			this.LblTCPPct.TabIndex = 8;
			this.LblTCPPct.Text = "( 0.00 % )";
			// 
			// LblTCPCount
			// 
			this.LblTCPCount.AutoSize = true;
			this.LblTCPCount.Location = new System.Drawing.Point(88, 56);
			this.LblTCPCount.Name = "LblTCPCount";
			this.LblTCPCount.Size = new System.Drawing.Size(11, 13);
			this.LblTCPCount.TabIndex = 7;
			this.LblTCPCount.Text = "0";
			// 
			// LblSCPTPct
			// 
			this.LblSCPTPct.AutoSize = true;
			this.LblSCPTPct.Location = new System.Drawing.Point(136, 40);
			this.LblSCPTPct.Name = "LblSCPTPct";
			this.LblSCPTPct.Size = new System.Drawing.Size(55, 13);
			this.LblSCPTPct.TabIndex = 6;
			this.LblSCPTPct.Text = "( 0.00 % )";
			// 
			// LblTCP
			// 
			this.LblTCP.AutoSize = true;
			this.LblTCP.Location = new System.Drawing.Point(16, 56);
			this.LblTCP.Name = "LblTCP";
			this.LblTCP.Size = new System.Drawing.Size(27, 13);
			this.LblTCP.TabIndex = 5;
			this.LblTCP.Text = "TCP";
			// 
			// LblSCPTCount
			// 
			this.LblSCPTCount.AutoSize = true;
			this.LblSCPTCount.Location = new System.Drawing.Point(88, 40);
			this.LblSCPTCount.Name = "LblSCPTCount";
			this.LblSCPTCount.Size = new System.Drawing.Size(11, 13);
			this.LblSCPTCount.TabIndex = 4;
			this.LblSCPTCount.Text = "0";
			// 
			// LblSCPT
			// 
			this.LblSCPT.AutoSize = true;
			this.LblSCPT.Location = new System.Drawing.Point(16, 40);
			this.LblSCPT.Name = "LblSCPT";
			this.LblSCPT.Size = new System.Drawing.Size(35, 13);
			this.LblSCPT.TabIndex = 3;
			this.LblSCPT.Text = "SCTP";
			// 
			// LblTotalPct
			// 
			this.LblTotalPct.AutoSize = true;
			this.LblTotalPct.Location = new System.Drawing.Point(136, 24);
			this.LblTotalPct.Name = "LblTotalPct";
			this.LblTotalPct.Size = new System.Drawing.Size(55, 13);
			this.LblTotalPct.TabIndex = 2;
			this.LblTotalPct.Text = "( 0.00 % )";
			// 
			// LblTotalCount
			// 
			this.LblTotalCount.AutoSize = true;
			this.LblTotalCount.Location = new System.Drawing.Point(88, 24);
			this.LblTotalCount.Name = "LblTotalCount";
			this.LblTotalCount.Size = new System.Drawing.Size(11, 13);
			this.LblTotalCount.TabIndex = 1;
			this.LblTotalCount.Text = "0";
			// 
			// LblTotal
			// 
			this.LblTotal.AutoSize = true;
			this.LblTotal.Location = new System.Drawing.Point(16, 24);
			this.LblTotal.Name = "LblTotal";
			this.LblTotal.Size = new System.Drawing.Size(31, 13);
			this.LblTotal.TabIndex = 0;
			this.LblTotal.Text = "Total";
			// 
			// GrpBoxRunningTime
			// 
			this.GrpBoxRunningTime.Controls.AddRange(new System.Windows.Forms.Control[] {
																							this.LblRunningTime});
			this.GrpBoxRunningTime.Location = new System.Drawing.Point(8, 296);
			this.GrpBoxRunningTime.Name = "GrpBoxRunningTime";
			this.GrpBoxRunningTime.Size = new System.Drawing.Size(224, 40);
			this.GrpBoxRunningTime.TabIndex = 1;
			this.GrpBoxRunningTime.TabStop = false;
			// 
			// LblRunningTime
			// 
			this.LblRunningTime.Location = new System.Drawing.Point(8, 16);
			this.LblRunningTime.Name = "LblRunningTime";
			this.LblRunningTime.Size = new System.Drawing.Size(208, 16);
			this.LblRunningTime.TabIndex = 0;
			this.LblRunningTime.Text = "00:00:00";
			this.LblRunningTime.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// BtnStop
			// 
			this.BtnStop.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(162)));
			this.BtnStop.Location = new System.Drawing.Point(8, 344);
			this.BtnStop.Name = "BtnStop";
			this.BtnStop.Size = new System.Drawing.Size(224, 32);
			this.BtnStop.TabIndex = 2;
			this.BtnStop.Text = "Start";
			this.BtnStop.Click += new System.EventHandler(this.BtnStop_Click);
			// 
			// CaptureTimer
			// 
			this.CaptureTimer.Interval = 10;
			this.CaptureTimer.Tick += new System.EventHandler(this.CaptureTimer_Tick);
			// 
			// GrpBoxReadBytes
			// 
			this.GrpBoxReadBytes.Controls.AddRange(new System.Windows.Forms.Control[] {
																						  this.LblBytesRead});
			this.GrpBoxReadBytes.Location = new System.Drawing.Point(8, 248);
			this.GrpBoxReadBytes.Name = "GrpBoxReadBytes";
			this.GrpBoxReadBytes.Size = new System.Drawing.Size(224, 40);
			this.GrpBoxReadBytes.TabIndex = 3;
			this.GrpBoxReadBytes.TabStop = false;
			// 
			// LblBytesRead
			// 
			this.LblBytesRead.Location = new System.Drawing.Point(8, 16);
			this.LblBytesRead.Name = "LblBytesRead";
			this.LblBytesRead.Size = new System.Drawing.Size(208, 16);
			this.LblBytesRead.TabIndex = 0;
			this.LblBytesRead.Text = "0 bytes so far";
			this.LblBytesRead.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// CaptureDisplay
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(6, 13);
			this.ClientSize = new System.Drawing.Size(240, 389);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.GrpBoxReadBytes,
																		  this.BtnStop,
																		  this.GrpBoxRunningTime,
																		  this.GrpBoxCapture});
			this.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(162)));
			this.Name = "CaptureDisplay";
			this.Text = "CaptureDisplay - r.ysie.ysse.ysmu.r.bb";
			this.GrpBoxCapture.ResumeLayout(false);
			this.GrpBoxRunningTime.ResumeLayout(false);
			this.GrpBoxReadBytes.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion


		public void InitDisplay()
		{
			LblTotalCount.Text = "0";
			LblTotalPct.Text = "( 0.00 % )";

			LblSCPTCount.Text = "0";
			LblSCPTPct.Text = "( 0.00 % )";

			LblTCPCount.Text = "0";
			LblTCPPct.Text = "( 0.00 % )";

			LblUDPCount.Text = "0";
			LblUDPPct.Text = "( 0.00 % )";

			LblICMPCount.Text = "0";
			LblICMPPct.Text = "( 0.00 % )";

			LblARPCount.Text = "0";
			LblARPPct.Text = "( 0.00 % )";

			LblOSPFCount.Text = "0";
			LblOSPFPct.Text = "( 0.00 % )";

			LblGRECount.Text = "0";
			LblGREPct.Text = "( 0.00 % )";

			LblNetBIOSCount.Text = "0";
			LblNetBIOSPct.Text = "( 0.00 % )";

			LblIPXCount.Text = "0";
			LblIPXPct.Text = "( 0.00 % )";

			LblVINESCount.Text = "0";
			LblVINESPct.Text = "( 0.00 % )";

			LblOtherCount.Text = "0";
			LblOtherPct.Text = "( 0.00 % )";

			LblBytesRead.Text = "0 bytes read so far";
			LblRunningTime.Text = "00:00:00";
		}

		private void BtnStop_Click(object sender, System.EventArgs e)
		{
		
			if( BtnStop.Text == "Start" )
			{
				BtnStop.Text = "Stop";
				IsTimerRunning = false;
				CaptureTimer.Enabled = true;
				P32.Start( LVw , Tnc , Rtx );
			}
			else if( BtnStop.Text == "Stop" )
			{
				P32.StopCapture = true;
				CaptureTimer.Enabled = false;
				BtnStop.Text = "Start";
				this.Hide();
			}

			this.Hide();

		}

		private void CaptureTimer_Tick(object sender, System.EventArgs e)
		{
			if( IsTimerRunning ) return;

			IsTimerRunning = true;

			Application.DoEvents();

			LblTotalCount.Text = P32.CaptureStatus.Total.CountStr;
			LblTotalPct.Text = P32.CaptureStatus.Total.PctStr;

			LblSCPTCount.Text = P32.CaptureStatus.SCPT.CountStr;
			LblSCPTPct.Text = P32.CaptureStatus.SCPT.PctStr;

			Application.DoEvents();

			LblTCPCount.Text = P32.CaptureStatus.TCP.CountStr;
			LblTCPPct.Text = P32.CaptureStatus.TCP.PctStr;

			LblUDPCount.Text = P32.CaptureStatus.UDP.CountStr;
			LblUDPPct.Text = P32.CaptureStatus.UDP.PctStr;

			Application.DoEvents();

			LblICMPCount.Text = P32.CaptureStatus.ICMP.CountStr;
			LblICMPPct.Text = P32.CaptureStatus.ICMP.PctStr;

			LblARPCount.Text = P32.CaptureStatus.ARP.CountStr;
			LblARPPct.Text = P32.CaptureStatus.ARP.PctStr;

			Application.DoEvents();

			LblOSPFCount.Text = P32.CaptureStatus.OSPF.CountStr;
			LblOSPFPct.Text = P32.CaptureStatus.OSPF.PctStr;

			LblGRECount.Text = P32.CaptureStatus.GRE.CountStr;
			LblGREPct.Text = P32.CaptureStatus.GRE.PctStr;

			Application.DoEvents();

			LblNetBIOSCount.Text = P32.CaptureStatus.NetBIOS.CountStr;
			LblNetBIOSPct.Text = P32.CaptureStatus.NetBIOS.PctStr;

			LblIPXCount.Text = P32.CaptureStatus.IPX.CountStr;
			LblIPXPct.Text = P32.CaptureStatus.IPX.PctStr;

			Application.DoEvents();

			LblVINESCount.Text = P32.CaptureStatus.VINES.CountStr;
			LblVINESPct.Text = P32.CaptureStatus.VINES.PctStr;

			LblOtherCount.Text = P32.CaptureStatus.Other.CountStr;
			LblOtherPct.Text = P32.CaptureStatus.Other.PctStr;

			Application.DoEvents();

			LblBytesRead.Text = P32.CaptureStatus.KilobytesStr + "  bytes read so far";
			LblRunningTime.Text = P32.CaptureStatus.SecondsStr;

			if( P32.CaptureStopped )
			{
				CaptureTimer.Enabled = false;
				BtnStop.Text = "Start";
				this.Hide();
			}

			IsTimerRunning = false;
		}

	}
}
