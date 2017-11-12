using System;
using System.Drawing;
using System.ComponentModel;
using System.Windows.Forms;
using MyClasses;

namespace Pacanal
{

	public class CaptureOptions : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label LblInterface;
		private System.Windows.Forms.ComboBox CmbAdapter;
		private System.Windows.Forms.CheckBox ChkCaptureLimit;
		private System.Windows.Forms.Label LblBytes;
		private System.Windows.Forms.Label LblFilter;
		private System.Windows.Forms.TextBox TxtEachPacketSize;
		private System.Windows.Forms.CheckBox ChkCaptureMode;
		private System.Windows.Forms.TextBox TxtFilter;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.CheckBox ChkDisplayOptionsAutomaticScroll;
		private System.Windows.Forms.CheckBox ChkDisplayOptionsRealTime;
		private System.Windows.Forms.Panel panel2;
		private System.Windows.Forms.Label LblPackets;
		private System.Windows.Forms.Label LblSeconds;
		private System.Windows.Forms.Label LblKilobytes;
		private System.Windows.Forms.TextBox TxtCaptureLimitsSeconds;
		private System.Windows.Forms.TextBox TxtCaptureLimitsKiloBytes;
		private System.Windows.Forms.TextBox TxtCaptureLimitsPackets;
		private System.Windows.Forms.CheckBox ChkCaptureLimitsSeconds;
		private System.Windows.Forms.CheckBox ChkCaptureLimitsKiloBytes;
		private System.Windows.Forms.CheckBox ChkCaptureLimitsPackets;
		private System.Windows.Forms.Panel panel3;
		private System.Windows.Forms.CheckBox ChkNameResolutionTransport;
		private System.Windows.Forms.CheckBox ChkNameResolutionNetwork;
		private System.Windows.Forms.CheckBox ChkNameResolutionMAC;
		private System.Windows.Forms.Panel panel4;
		private System.Windows.Forms.Panel panel5;
		private System.Windows.Forms.Label LblAdapterBufferSize;
		private System.Windows.Forms.Label LblBufferSize;
		private System.Windows.Forms.Label LblMinBytesToCopy;
		private System.Windows.Forms.Label LblNumWrites;
		private System.Windows.Forms.Label LblReadTimeOut;
		private System.Windows.Forms.Label LblCaptureMode;
		private System.Windows.Forms.Label LblHardwareFilter;
		private System.Windows.Forms.Button BtnOk;
		private System.Windows.Forms.Button BtnCancel;
		private System.Windows.Forms.TextBox TxtAdapterBufferSize;
		private System.Windows.Forms.TextBox TxtBufferSize;
		private System.Windows.Forms.TextBox TxtMinBytesToCopy;
		private System.Windows.Forms.TextBox TxtNumWrites;
		private System.Windows.Forms.TextBox TxtReadTimeOut;
		private System.Windows.Forms.ComboBox CmbCaptureMode;
		private System.Windows.Forms.CheckedListBox ChkBoxHardwareFilter;

		public Packet32 P32;
		public string [] Adapters;
		public Packet32.CAPTURE_LIMITS thisCaptureLimits;
		public Packet32.CAPTURE_OPTIONS thisCaptureOptions;
		public Packet32.DISPLAY_OPTIONS thisDisplayOptions;
		public Packet32.NAME_RESOLUTION thisNameResolution;

		private bool ParamsLoaded = false;
		private System.Windows.Forms.CheckBox ChkManufacturerNameResolution;
		private System.Windows.Forms.Button BtnEditFilter;
		private System.Windows.Forms.Button BtnProtocolOptions;
		private System.Windows.Forms.Button BtnPrintOptions;


		private System.ComponentModel.Container components = null;

		public CaptureOptions()
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
		private void InitializeComponent()
		{
			this.LblInterface = new System.Windows.Forms.Label();
			this.CmbAdapter = new System.Windows.Forms.ComboBox();
			this.ChkCaptureLimit = new System.Windows.Forms.CheckBox();
			this.TxtEachPacketSize = new System.Windows.Forms.TextBox();
			this.LblBytes = new System.Windows.Forms.Label();
			this.ChkCaptureMode = new System.Windows.Forms.CheckBox();
			this.LblFilter = new System.Windows.Forms.Label();
			this.TxtFilter = new System.Windows.Forms.TextBox();
			this.panel1 = new System.Windows.Forms.Panel();
			this.ChkDisplayOptionsRealTime = new System.Windows.Forms.CheckBox();
			this.ChkDisplayOptionsAutomaticScroll = new System.Windows.Forms.CheckBox();
			this.panel2 = new System.Windows.Forms.Panel();
			this.ChkCaptureLimitsPackets = new System.Windows.Forms.CheckBox();
			this.ChkCaptureLimitsKiloBytes = new System.Windows.Forms.CheckBox();
			this.ChkCaptureLimitsSeconds = new System.Windows.Forms.CheckBox();
			this.TxtCaptureLimitsPackets = new System.Windows.Forms.TextBox();
			this.TxtCaptureLimitsKiloBytes = new System.Windows.Forms.TextBox();
			this.TxtCaptureLimitsSeconds = new System.Windows.Forms.TextBox();
			this.LblPackets = new System.Windows.Forms.Label();
			this.LblSeconds = new System.Windows.Forms.Label();
			this.LblKilobytes = new System.Windows.Forms.Label();
			this.panel3 = new System.Windows.Forms.Panel();
			this.ChkNameResolutionMAC = new System.Windows.Forms.CheckBox();
			this.ChkNameResolutionNetwork = new System.Windows.Forms.CheckBox();
			this.ChkNameResolutionTransport = new System.Windows.Forms.CheckBox();
			this.panel4 = new System.Windows.Forms.Panel();
			this.panel5 = new System.Windows.Forms.Panel();
			this.LblAdapterBufferSize = new System.Windows.Forms.Label();
			this.LblBufferSize = new System.Windows.Forms.Label();
			this.LblMinBytesToCopy = new System.Windows.Forms.Label();
			this.LblNumWrites = new System.Windows.Forms.Label();
			this.LblReadTimeOut = new System.Windows.Forms.Label();
			this.LblCaptureMode = new System.Windows.Forms.Label();
			this.LblHardwareFilter = new System.Windows.Forms.Label();
			this.TxtAdapterBufferSize = new System.Windows.Forms.TextBox();
			this.TxtBufferSize = new System.Windows.Forms.TextBox();
			this.TxtMinBytesToCopy = new System.Windows.Forms.TextBox();
			this.TxtNumWrites = new System.Windows.Forms.TextBox();
			this.TxtReadTimeOut = new System.Windows.Forms.TextBox();
			this.CmbCaptureMode = new System.Windows.Forms.ComboBox();
			this.BtnOk = new System.Windows.Forms.Button();
			this.BtnCancel = new System.Windows.Forms.Button();
			this.ChkBoxHardwareFilter = new System.Windows.Forms.CheckedListBox();
			this.ChkManufacturerNameResolution = new System.Windows.Forms.CheckBox();
			this.BtnEditFilter = new System.Windows.Forms.Button();
			this.BtnProtocolOptions = new System.Windows.Forms.Button();
			this.BtnPrintOptions = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// LblInterface
			// 
			this.LblInterface.AutoSize = true;
			this.LblInterface.Location = new System.Drawing.Point(8, 16);
			this.LblInterface.Name = "LblInterface";
			this.LblInterface.Size = new System.Drawing.Size(48, 13);
			this.LblInterface.TabIndex = 0;
			this.LblInterface.Text = "Interface";
			// 
			// CmbAdapter
			// 
			this.CmbAdapter.Location = new System.Drawing.Point(64, 8);
			this.CmbAdapter.MaxDropDownItems = 4;
			this.CmbAdapter.Name = "CmbAdapter";
			this.CmbAdapter.Size = new System.Drawing.Size(656, 21);
			this.CmbAdapter.TabIndex = 1;
			// 
			// ChkCaptureLimit
			// 
			this.ChkCaptureLimit.Location = new System.Drawing.Point(8, 40);
			this.ChkCaptureLimit.Name = "ChkCaptureLimit";
			this.ChkCaptureLimit.Size = new System.Drawing.Size(128, 24);
			this.ChkCaptureLimit.TabIndex = 2;
			this.ChkCaptureLimit.Text = "Limit each packet to ";
			this.ChkCaptureLimit.CheckStateChanged += new System.EventHandler(this.ChkCaptureLimit_CheckStateChanged);
			// 
			// TxtEachPacketSize
			// 
			this.TxtEachPacketSize.Location = new System.Drawing.Point(136, 40);
			this.TxtEachPacketSize.Name = "TxtEachPacketSize";
			this.TxtEachPacketSize.Size = new System.Drawing.Size(48, 20);
			this.TxtEachPacketSize.TabIndex = 3;
			this.TxtEachPacketSize.Text = "68";
			// 
			// LblBytes
			// 
			this.LblBytes.AutoSize = true;
			this.LblBytes.Location = new System.Drawing.Point(200, 48);
			this.LblBytes.Name = "LblBytes";
			this.LblBytes.Size = new System.Drawing.Size(31, 13);
			this.LblBytes.TabIndex = 4;
			this.LblBytes.Text = "bytes";
			// 
			// ChkCaptureMode
			// 
			this.ChkCaptureMode.Location = new System.Drawing.Point(248, 40);
			this.ChkCaptureMode.Name = "ChkCaptureMode";
			this.ChkCaptureMode.Size = new System.Drawing.Size(232, 24);
			this.ChkCaptureMode.TabIndex = 5;
			this.ChkCaptureMode.Text = "Capture packets in promiscuous mode";
			this.ChkCaptureMode.CheckStateChanged += new System.EventHandler(this.ChkCaptureMode_CheckStateChanged);
			// 
			// LblFilter
			// 
			this.LblFilter.AutoSize = true;
			this.LblFilter.Location = new System.Drawing.Point(8, 80);
			this.LblFilter.Name = "LblFilter";
			this.LblFilter.Size = new System.Drawing.Size(29, 13);
			this.LblFilter.TabIndex = 6;
			this.LblFilter.Text = "Filter";
			// 
			// TxtFilter
			// 
			this.TxtFilter.Location = new System.Drawing.Point(40, 72);
			this.TxtFilter.Name = "TxtFilter";
			this.TxtFilter.Size = new System.Drawing.Size(648, 20);
			this.TxtFilter.TabIndex = 7;
			this.TxtFilter.Text = "";
			// 
			// panel1
			// 
			this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
			this.panel1.Location = new System.Drawing.Point(8, 104);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(712, 4);
			this.panel1.TabIndex = 8;
			// 
			// ChkDisplayOptionsRealTime
			// 
			this.ChkDisplayOptionsRealTime.Location = new System.Drawing.Point(8, 120);
			this.ChkDisplayOptionsRealTime.Name = "ChkDisplayOptionsRealTime";
			this.ChkDisplayOptionsRealTime.Size = new System.Drawing.Size(216, 16);
			this.ChkDisplayOptionsRealTime.TabIndex = 11;
			this.ChkDisplayOptionsRealTime.Text = "Update the list of packets in real time";
			// 
			// ChkDisplayOptionsAutomaticScroll
			// 
			this.ChkDisplayOptionsAutomaticScroll.Location = new System.Drawing.Point(8, 144);
			this.ChkDisplayOptionsAutomaticScroll.Name = "ChkDisplayOptionsAutomaticScroll";
			this.ChkDisplayOptionsAutomaticScroll.Size = new System.Drawing.Size(192, 16);
			this.ChkDisplayOptionsAutomaticScroll.TabIndex = 12;
			this.ChkDisplayOptionsAutomaticScroll.Text = "Automatic scrolling in live capture";
			// 
			// panel2
			// 
			this.panel2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
			this.panel2.Location = new System.Drawing.Point(8, 168);
			this.panel2.Name = "panel2";
			this.panel2.Size = new System.Drawing.Size(360, 4);
			this.panel2.TabIndex = 13;
			// 
			// ChkCaptureLimitsPackets
			// 
			this.ChkCaptureLimitsPackets.Location = new System.Drawing.Point(8, 192);
			this.ChkCaptureLimitsPackets.Name = "ChkCaptureLimitsPackets";
			this.ChkCaptureLimitsPackets.Size = new System.Drawing.Size(120, 16);
			this.ChkCaptureLimitsPackets.TabIndex = 14;
			this.ChkCaptureLimitsPackets.Text = "Stop capture after ";
			this.ChkCaptureLimitsPackets.CheckStateChanged += new System.EventHandler(this.ChkCaptureLimitsPackets_CheckStateChanged);
			// 
			// ChkCaptureLimitsKiloBytes
			// 
			this.ChkCaptureLimitsKiloBytes.Location = new System.Drawing.Point(8, 216);
			this.ChkCaptureLimitsKiloBytes.Name = "ChkCaptureLimitsKiloBytes";
			this.ChkCaptureLimitsKiloBytes.Size = new System.Drawing.Size(120, 16);
			this.ChkCaptureLimitsKiloBytes.TabIndex = 15;
			this.ChkCaptureLimitsKiloBytes.Text = "Stop capture after ";
			this.ChkCaptureLimitsKiloBytes.CheckStateChanged += new System.EventHandler(this.ChkCaptureLimitsKiloBytes_CheckStateChanged);
			// 
			// ChkCaptureLimitsSeconds
			// 
			this.ChkCaptureLimitsSeconds.Location = new System.Drawing.Point(8, 240);
			this.ChkCaptureLimitsSeconds.Name = "ChkCaptureLimitsSeconds";
			this.ChkCaptureLimitsSeconds.Size = new System.Drawing.Size(120, 16);
			this.ChkCaptureLimitsSeconds.TabIndex = 16;
			this.ChkCaptureLimitsSeconds.Text = "Stop capture after ";
			this.ChkCaptureLimitsSeconds.CheckStateChanged += new System.EventHandler(this.ChkCaptureLimitsSeconds_CheckStateChanged);
			// 
			// TxtCaptureLimitsPackets
			// 
			this.TxtCaptureLimitsPackets.Location = new System.Drawing.Point(128, 184);
			this.TxtCaptureLimitsPackets.Name = "TxtCaptureLimitsPackets";
			this.TxtCaptureLimitsPackets.Size = new System.Drawing.Size(64, 20);
			this.TxtCaptureLimitsPackets.TabIndex = 17;
			this.TxtCaptureLimitsPackets.Text = "100";
			// 
			// TxtCaptureLimitsKiloBytes
			// 
			this.TxtCaptureLimitsKiloBytes.Location = new System.Drawing.Point(128, 208);
			this.TxtCaptureLimitsKiloBytes.Name = "TxtCaptureLimitsKiloBytes";
			this.TxtCaptureLimitsKiloBytes.Size = new System.Drawing.Size(64, 20);
			this.TxtCaptureLimitsKiloBytes.TabIndex = 18;
			this.TxtCaptureLimitsKiloBytes.Text = "10000";
			// 
			// TxtCaptureLimitsSeconds
			// 
			this.TxtCaptureLimitsSeconds.Location = new System.Drawing.Point(128, 232);
			this.TxtCaptureLimitsSeconds.Name = "TxtCaptureLimitsSeconds";
			this.TxtCaptureLimitsSeconds.Size = new System.Drawing.Size(64, 20);
			this.TxtCaptureLimitsSeconds.TabIndex = 19;
			this.TxtCaptureLimitsSeconds.Text = "20";
			// 
			// LblPackets
			// 
			this.LblPackets.AutoSize = true;
			this.LblPackets.Location = new System.Drawing.Point(200, 192);
			this.LblPackets.Name = "LblPackets";
			this.LblPackets.Size = new System.Drawing.Size(98, 13);
			this.LblPackets.TabIndex = 20;
			this.LblPackets.Text = "packet(s) captured";
			// 
			// LblSeconds
			// 
			this.LblSeconds.AutoSize = true;
			this.LblSeconds.Location = new System.Drawing.Point(200, 240);
			this.LblSeconds.Name = "LblSeconds";
			this.LblSeconds.Size = new System.Drawing.Size(101, 13);
			this.LblSeconds.TabIndex = 21;
			this.LblSeconds.Text = "second(s) captured";
			// 
			// LblKilobytes
			// 
			this.LblKilobytes.AutoSize = true;
			this.LblKilobytes.Location = new System.Drawing.Point(200, 216);
			this.LblKilobytes.Name = "LblKilobytes";
			this.LblKilobytes.Size = new System.Drawing.Size(103, 13);
			this.LblKilobytes.TabIndex = 22;
			this.LblKilobytes.Text = "kilobyte(s) captured";
			// 
			// panel3
			// 
			this.panel3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
			this.panel3.Location = new System.Drawing.Point(8, 264);
			this.panel3.Name = "panel3";
			this.panel3.Size = new System.Drawing.Size(360, 4);
			this.panel3.TabIndex = 23;
			// 
			// ChkNameResolutionMAC
			// 
			this.ChkNameResolutionMAC.Location = new System.Drawing.Point(8, 280);
			this.ChkNameResolutionMAC.Name = "ChkNameResolutionMAC";
			this.ChkNameResolutionMAC.Size = new System.Drawing.Size(192, 16);
			this.ChkNameResolutionMAC.TabIndex = 24;
			this.ChkNameResolutionMAC.Text = "Enable MAC name resolution";
			// 
			// ChkNameResolutionNetwork
			// 
			this.ChkNameResolutionNetwork.Location = new System.Drawing.Point(8, 304);
			this.ChkNameResolutionNetwork.Name = "ChkNameResolutionNetwork";
			this.ChkNameResolutionNetwork.Size = new System.Drawing.Size(192, 16);
			this.ChkNameResolutionNetwork.TabIndex = 25;
			this.ChkNameResolutionNetwork.Text = "Enable network name resolution";
			// 
			// ChkNameResolutionTransport
			// 
			this.ChkNameResolutionTransport.Location = new System.Drawing.Point(8, 328);
			this.ChkNameResolutionTransport.Name = "ChkNameResolutionTransport";
			this.ChkNameResolutionTransport.Size = new System.Drawing.Size(192, 16);
			this.ChkNameResolutionTransport.TabIndex = 26;
			this.ChkNameResolutionTransport.Text = "Enable transport name resolution";
			// 
			// panel4
			// 
			this.panel4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
			this.panel4.Location = new System.Drawing.Point(8, 376);
			this.panel4.Name = "panel4";
			this.panel4.Size = new System.Drawing.Size(360, 4);
			this.panel4.TabIndex = 27;
			// 
			// panel5
			// 
			this.panel5.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
			this.panel5.Location = new System.Drawing.Point(366, 106);
			this.panel5.Name = "panel5";
			this.panel5.Size = new System.Drawing.Size(4, 274);
			this.panel5.TabIndex = 28;
			// 
			// LblAdapterBufferSize
			// 
			this.LblAdapterBufferSize.AutoSize = true;
			this.LblAdapterBufferSize.Location = new System.Drawing.Point(384, 120);
			this.LblAdapterBufferSize.Name = "LblAdapterBufferSize";
			this.LblAdapterBufferSize.Size = new System.Drawing.Size(102, 13);
			this.LblAdapterBufferSize.TabIndex = 29;
			this.LblAdapterBufferSize.Text = "Adapter Buffer Size";
			// 
			// LblBufferSize
			// 
			this.LblBufferSize.AutoSize = true;
			this.LblBufferSize.Location = new System.Drawing.Point(384, 144);
			this.LblBufferSize.Name = "LblBufferSize";
			this.LblBufferSize.Size = new System.Drawing.Size(60, 13);
			this.LblBufferSize.TabIndex = 30;
			this.LblBufferSize.Text = "Buffer Size";
			// 
			// LblMinBytesToCopy
			// 
			this.LblMinBytesToCopy.AutoSize = true;
			this.LblMinBytesToCopy.Location = new System.Drawing.Point(384, 168);
			this.LblMinBytesToCopy.Name = "LblMinBytesToCopy";
			this.LblMinBytesToCopy.Size = new System.Drawing.Size(120, 13);
			this.LblMinBytesToCopy.TabIndex = 31;
			this.LblMinBytesToCopy.Text = "Minimum bytes to copy";
			// 
			// LblNumWrites
			// 
			this.LblNumWrites.AutoSize = true;
			this.LblNumWrites.Location = new System.Drawing.Point(384, 192);
			this.LblNumWrites.Name = "LblNumWrites";
			this.LblNumWrites.Size = new System.Drawing.Size(90, 13);
			this.LblNumWrites.TabIndex = 32;
			this.LblNumWrites.Text = "Number of writes";
			// 
			// LblReadTimeOut
			// 
			this.LblReadTimeOut.AutoSize = true;
			this.LblReadTimeOut.Location = new System.Drawing.Point(384, 216);
			this.LblReadTimeOut.Name = "LblReadTimeOut";
			this.LblReadTimeOut.Size = new System.Drawing.Size(106, 13);
			this.LblReadTimeOut.TabIndex = 33;
			this.LblReadTimeOut.Text = "Read time out ( ms )";
			// 
			// LblCaptureMode
			// 
			this.LblCaptureMode.AutoSize = true;
			this.LblCaptureMode.Location = new System.Drawing.Point(384, 240);
			this.LblCaptureMode.Name = "LblCaptureMode";
			this.LblCaptureMode.Size = new System.Drawing.Size(76, 13);
			this.LblCaptureMode.TabIndex = 34;
			this.LblCaptureMode.Text = "Capture Mode";
			// 
			// LblHardwareFilter
			// 
			this.LblHardwareFilter.AutoSize = true;
			this.LblHardwareFilter.Location = new System.Drawing.Point(384, 264);
			this.LblHardwareFilter.Name = "LblHardwareFilter";
			this.LblHardwareFilter.Size = new System.Drawing.Size(82, 13);
			this.LblHardwareFilter.TabIndex = 35;
			this.LblHardwareFilter.Text = "Hardware Filter";
			// 
			// TxtAdapterBufferSize
			// 
			this.TxtAdapterBufferSize.Location = new System.Drawing.Point(512, 112);
			this.TxtAdapterBufferSize.Name = "TxtAdapterBufferSize";
			this.TxtAdapterBufferSize.Size = new System.Drawing.Size(208, 20);
			this.TxtAdapterBufferSize.TabIndex = 36;
			this.TxtAdapterBufferSize.Text = "512000";
			// 
			// TxtBufferSize
			// 
			this.TxtBufferSize.Location = new System.Drawing.Point(512, 136);
			this.TxtBufferSize.Name = "TxtBufferSize";
			this.TxtBufferSize.Size = new System.Drawing.Size(208, 20);
			this.TxtBufferSize.TabIndex = 37;
			this.TxtBufferSize.Text = "256000";
			// 
			// TxtMinBytesToCopy
			// 
			this.TxtMinBytesToCopy.Location = new System.Drawing.Point(512, 160);
			this.TxtMinBytesToCopy.Name = "TxtMinBytesToCopy";
			this.TxtMinBytesToCopy.Size = new System.Drawing.Size(208, 20);
			this.TxtMinBytesToCopy.TabIndex = 38;
			this.TxtMinBytesToCopy.Text = "4096";
			// 
			// TxtNumWrites
			// 
			this.TxtNumWrites.Location = new System.Drawing.Point(512, 184);
			this.TxtNumWrites.Name = "TxtNumWrites";
			this.TxtNumWrites.Size = new System.Drawing.Size(208, 20);
			this.TxtNumWrites.TabIndex = 39;
			this.TxtNumWrites.Text = "1";
			// 
			// TxtReadTimeOut
			// 
			this.TxtReadTimeOut.Location = new System.Drawing.Point(512, 208);
			this.TxtReadTimeOut.Name = "TxtReadTimeOut";
			this.TxtReadTimeOut.Size = new System.Drawing.Size(208, 20);
			this.TxtReadTimeOut.TabIndex = 40;
			this.TxtReadTimeOut.Text = "1000";
			// 
			// CmbCaptureMode
			// 
			this.CmbCaptureMode.Items.AddRange(new object[] {
																"CAPTURE MODE",
																"STATISTICAL MODE",
																"DUMP MODE",
																"STATISTICAL & DUMP MODE"});
			this.CmbCaptureMode.Location = new System.Drawing.Point(512, 232);
			this.CmbCaptureMode.Name = "CmbCaptureMode";
			this.CmbCaptureMode.Size = new System.Drawing.Size(208, 21);
			this.CmbCaptureMode.TabIndex = 41;
			// 
			// BtnOk
			// 
			this.BtnOk.Location = new System.Drawing.Point(8, 432);
			this.BtnOk.Name = "BtnOk";
			this.BtnOk.Size = new System.Drawing.Size(120, 23);
			this.BtnOk.TabIndex = 43;
			this.BtnOk.Text = "&Ok";
			this.BtnOk.Click += new System.EventHandler(this.BtnOk_Click);
			// 
			// BtnCancel
			// 
			this.BtnCancel.Location = new System.Drawing.Point(136, 432);
			this.BtnCancel.Name = "BtnCancel";
			this.BtnCancel.Size = new System.Drawing.Size(120, 23);
			this.BtnCancel.TabIndex = 44;
			this.BtnCancel.Text = "&Cancel";
			this.BtnCancel.Click += new System.EventHandler(this.BtnCancel_Click);
			// 
			// ChkBoxHardwareFilter
			// 
			this.ChkBoxHardwareFilter.Items.AddRange(new object[] {
																	  "DIRECTED",
																	  "MULTICAST",
																	  "ALL_MULTICAST",
																	  "BROADCAST",
																	  "SOURCE_ROUTING",
																	  "PROMISCUOUS",
																	  "SMT",
																	  "ALL_LOCAL",
																	  "MAC_FRAME",
																	  "FUNCTIONAL",
																	  "ALL_FUNCTIONAL",
																	  "GROUP"});
			this.ChkBoxHardwareFilter.Location = new System.Drawing.Point(512, 256);
			this.ChkBoxHardwareFilter.Name = "ChkBoxHardwareFilter";
			this.ChkBoxHardwareFilter.Size = new System.Drawing.Size(208, 199);
			this.ChkBoxHardwareFilter.TabIndex = 45;
			this.ChkBoxHardwareFilter.SelectedValueChanged += new System.EventHandler(this.ChkBoxHardwareFilter_SelectedValueChanged);
			// 
			// ChkManufacturerNameResolution
			// 
			this.ChkManufacturerNameResolution.Location = new System.Drawing.Point(8, 352);
			this.ChkManufacturerNameResolution.Name = "ChkManufacturerNameResolution";
			this.ChkManufacturerNameResolution.Size = new System.Drawing.Size(224, 16);
			this.ChkManufacturerNameResolution.TabIndex = 46;
			this.ChkManufacturerNameResolution.Text = "Enable Manufacturer Name Resolution";
			// 
			// BtnEditFilter
			// 
			this.BtnEditFilter.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(162)));
			this.BtnEditFilter.Location = new System.Drawing.Point(696, 72);
			this.BtnEditFilter.Name = "BtnEditFilter";
			this.BtnEditFilter.Size = new System.Drawing.Size(25, 23);
			this.BtnEditFilter.TabIndex = 47;
			this.BtnEditFilter.Text = "...";
			// 
			// BtnProtocolOptions
			// 
			this.BtnProtocolOptions.Location = new System.Drawing.Point(8, 392);
			this.BtnProtocolOptions.Name = "BtnProtocolOptions";
			this.BtnProtocolOptions.Size = new System.Drawing.Size(120, 23);
			this.BtnProtocolOptions.TabIndex = 48;
			this.BtnProtocolOptions.Text = "&Protocol Options";
			// 
			// BtnPrintOptions
			// 
			this.BtnPrintOptions.Location = new System.Drawing.Point(136, 392);
			this.BtnPrintOptions.Name = "BtnPrintOptions";
			this.BtnPrintOptions.Size = new System.Drawing.Size(120, 23);
			this.BtnPrintOptions.TabIndex = 49;
			this.BtnPrintOptions.Text = "P&rint Options";
			// 
			// CaptureOptions
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(728, 461);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.BtnPrintOptions,
																		  this.BtnProtocolOptions,
																		  this.BtnEditFilter,
																		  this.ChkManufacturerNameResolution,
																		  this.ChkBoxHardwareFilter,
																		  this.BtnCancel,
																		  this.BtnOk,
																		  this.CmbCaptureMode,
																		  this.TxtReadTimeOut,
																		  this.TxtNumWrites,
																		  this.TxtMinBytesToCopy,
																		  this.TxtBufferSize,
																		  this.TxtAdapterBufferSize,
																		  this.LblHardwareFilter,
																		  this.LblCaptureMode,
																		  this.LblReadTimeOut,
																		  this.LblNumWrites,
																		  this.LblMinBytesToCopy,
																		  this.LblBufferSize,
																		  this.LblAdapterBufferSize,
																		  this.LblKilobytes,
																		  this.LblSeconds,
																		  this.LblPackets,
																		  this.LblFilter,
																		  this.LblBytes,
																		  this.LblInterface,
																		  this.panel5,
																		  this.panel4,
																		  this.ChkNameResolutionTransport,
																		  this.ChkNameResolutionNetwork,
																		  this.ChkNameResolutionMAC,
																		  this.panel3,
																		  this.TxtCaptureLimitsSeconds,
																		  this.TxtCaptureLimitsKiloBytes,
																		  this.TxtCaptureLimitsPackets,
																		  this.ChkCaptureLimitsSeconds,
																		  this.ChkCaptureLimitsKiloBytes,
																		  this.ChkCaptureLimitsPackets,
																		  this.panel2,
																		  this.ChkDisplayOptionsAutomaticScroll,
																		  this.ChkDisplayOptionsRealTime,
																		  this.panel1,
																		  this.TxtFilter,
																		  this.ChkCaptureMode,
																		  this.TxtEachPacketSize,
																		  this.ChkCaptureLimit,
																		  this.CmbAdapter});
			this.Name = "CaptureOptions";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Capture Options - r.ysie.ysse.ysmu.r.bb";
			this.Activated += new System.EventHandler(this.CaptureOptions_Activated);
			this.Enter += new System.EventHandler(this.CaptureOptions_Enter);
			this.ResumeLayout(false);

		}
		#endregion

		private void BtnOk_Click(object sender, System.EventArgs e)
		{
			string str = "";
		
			str = TxtEachPacketSize.Text;
			thisCaptureOptions.PacketSize = int.Parse( str );

			thisCaptureOptions.LimitPackets = ChkCaptureLimit.Checked;

			thisCaptureOptions.PromiscuousMode = ChkCaptureMode.Checked;
			thisCaptureOptions.Filter = TxtFilter.Text;
			thisCaptureOptions.AdapterIndex = CmbAdapter.SelectedIndex;

			str = TxtAdapterBufferSize.Text;
			thisCaptureOptions.AdapterBufferSize = int.Parse( str );
			str = TxtBufferSize.Text;
			thisCaptureOptions.BufferSize = int.Parse( str );
			str = TxtMinBytesToCopy.Text;
			thisCaptureOptions.MinBytesToCopy = int.Parse( str );
			str = TxtNumWrites.Text;
			thisCaptureOptions.NumWrites = int.Parse( str );
			str = TxtReadTimeOut.Text;
			thisCaptureOptions.ReadTimeOut = int.Parse( str );

			if( CmbCaptureMode.SelectedIndex == 0 )
				thisCaptureOptions.CaptureMode = (int) Packet32h.PACKET_MODE_CAPT;
			if( CmbCaptureMode.SelectedIndex == 1 )
				thisCaptureOptions.CaptureMode = (int) Packet32h.PACKET_MODE_STAT;
			if( CmbCaptureMode.SelectedIndex == 2 )
				thisCaptureOptions.CaptureMode = (int) Packet32h.PACKET_MODE_DUMP;
			if( CmbCaptureMode.SelectedIndex == 3 )
				thisCaptureOptions.CaptureMode = (int) Packet32h.PACKET_MODE_STAT_DUMP;

			thisCaptureOptions.HardwareFilter = 0;

			if( ChkBoxHardwareFilter.GetItemChecked(0) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_DIRECTED;
			if( ChkBoxHardwareFilter.GetItemChecked(1) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_MULTICAST;
			if( ChkBoxHardwareFilter.GetItemChecked(2) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_ALL_MULTICAST;
			if( ChkBoxHardwareFilter.GetItemChecked(3) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_BROADCAST;
			if( ChkBoxHardwareFilter.GetItemChecked(4) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_SOURCE_ROUTING;
			if( ChkBoxHardwareFilter.GetItemChecked(5) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS;
			if( ChkBoxHardwareFilter.GetItemChecked(6) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_SMT;
			if( ChkBoxHardwareFilter.GetItemChecked(7) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_ALL_LOCAL;
			if( ChkBoxHardwareFilter.GetItemChecked(8) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_MAC_FRAME;
			if( ChkBoxHardwareFilter.GetItemChecked(9) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_FUNCTIONAL;
			if( ChkBoxHardwareFilter.GetItemChecked(10) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_ALL_FUNCTIONAL;
			if( ChkBoxHardwareFilter.GetItemChecked(11) )
				thisCaptureOptions.HardwareFilter |= Packet32h.NDIS_PACKET_TYPE_GROUP;


			thisDisplayOptions.UpdateListInRealTime = ChkDisplayOptionsRealTime.Checked;
			thisDisplayOptions.AutomaticScrollInLiveCapture = ChkDisplayOptionsAutomaticScroll.Checked;

			thisCaptureLimits.LimitToPackets = ChkCaptureLimitsPackets.Checked;
			thisCaptureLimits.LimitToKiloBytes = ChkCaptureLimitsKiloBytes.Checked;
			thisCaptureLimits.LimitToSeconds = ChkCaptureLimitsSeconds.Checked;
			str = TxtCaptureLimitsPackets.Text;
			thisCaptureLimits.PacketSize = int.Parse( str );
			str = TxtCaptureLimitsKiloBytes.Text;
			thisCaptureLimits.KilobyteSize = int.Parse( str );
			str = TxtCaptureLimitsSeconds.Text;
			thisCaptureLimits.SecondSize = int.Parse( str );

			thisNameResolution.EnableMAC = ChkNameResolutionMAC.Checked;
			thisNameResolution.EnableNetwork = ChkNameResolutionNetwork.Checked;
			thisNameResolution.EnableTransport = ChkNameResolutionTransport.Checked;
			thisNameResolution.EnableManufacturer = ChkManufacturerNameResolution.Checked;

			P32.CaptureLimits = thisCaptureLimits;
			P32.CaptureOptions = thisCaptureOptions;
			P32.DisplayOptions = thisDisplayOptions;
			P32.NameResolution = thisNameResolution;

			P32.SaveSettings();

			ParamsLoaded = false;

			this.Hide();
		
		}

		private void BtnCancel_Click(object sender, System.EventArgs e)
		{
			this.Hide();
		}

		private void CaptureOptions_Enter(object sender, System.EventArgs e)
		{
			int i = 0;

			P32.ReadSettings();

			thisCaptureLimits = P32.CaptureLimits;
			thisCaptureOptions = P32.CaptureOptions;
			thisDisplayOptions = P32.DisplayOptions;
			thisNameResolution = P32.NameResolution;
			Adapters = P32.InstalledAdapters;

			CmbAdapter.Items.Clear();
			if( Adapters != null )
			{
				if( Adapters.Length != 0 )
				{
					for( i = 0; i < Adapters.GetLength(0); i ++ )
						CmbAdapter.Items.Add( Adapters[i] );
				}
			}

			if( CmbAdapter.Items.Count > 0 )
				CmbAdapter.SelectedIndex = 0;

			TxtEachPacketSize.Text = thisCaptureOptions.PacketSize.ToString();
			ChkCaptureLimit.Checked = thisCaptureOptions.LimitPackets;
			TxtEachPacketSize.Enabled = thisCaptureOptions.LimitPackets;
			ChkCaptureMode.Checked = thisCaptureOptions.PromiscuousMode;
			TxtFilter.Text = thisCaptureOptions.Filter;

			TxtAdapterBufferSize.Text = thisCaptureOptions.AdapterBufferSize.ToString();
			TxtBufferSize.Text = thisCaptureOptions.BufferSize.ToString();
			TxtMinBytesToCopy.Text = thisCaptureOptions.MinBytesToCopy.ToString();
			TxtNumWrites.Text = thisCaptureOptions.NumWrites.ToString();
			TxtReadTimeOut.Text = thisCaptureOptions.ReadTimeOut.ToString();

			if( thisCaptureOptions.CaptureMode == Packet32h.PACKET_MODE_CAPT )
				CmbCaptureMode.SelectedIndex = 0;
			else if( thisCaptureOptions.CaptureMode == Packet32h.PACKET_MODE_STAT )
				CmbCaptureMode.SelectedIndex = 1;
			else if( thisCaptureOptions.CaptureMode == Packet32h.PACKET_MODE_DUMP )
				CmbCaptureMode.SelectedIndex = 2;
			else if( thisCaptureOptions.CaptureMode == Packet32h.PACKET_MODE_STAT_DUMP )
				CmbCaptureMode.SelectedIndex = 3;

			TxtMinBytesToCopy.Text = thisCaptureOptions.MinBytesToCopy.ToString();
			TxtMinBytesToCopy.Text = thisCaptureOptions.MinBytesToCopy.ToString();

			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_DIRECTED ) == Packet32h.NDIS_PACKET_TYPE_DIRECTED )
				ChkBoxHardwareFilter.SetItemChecked( 0 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_MULTICAST ) == Packet32h.NDIS_PACKET_TYPE_MULTICAST )
				ChkBoxHardwareFilter.SetItemChecked( 1 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_ALL_MULTICAST ) == Packet32h.NDIS_PACKET_TYPE_ALL_MULTICAST )
				ChkBoxHardwareFilter.SetItemChecked( 2 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_BROADCAST ) == Packet32h.NDIS_PACKET_TYPE_BROADCAST )
				ChkBoxHardwareFilter.SetItemChecked( 3 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_SOURCE_ROUTING ) == Packet32h.NDIS_PACKET_TYPE_SOURCE_ROUTING )
				ChkBoxHardwareFilter.SetItemChecked( 4 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS ) == Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS )
				ChkBoxHardwareFilter.SetItemChecked( 5 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_SMT ) == Packet32h.NDIS_PACKET_TYPE_SMT )
				ChkBoxHardwareFilter.SetItemChecked( 6 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_ALL_LOCAL ) == Packet32h.NDIS_PACKET_TYPE_ALL_LOCAL )
				ChkBoxHardwareFilter.SetItemChecked( 7 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_MAC_FRAME ) == Packet32h.NDIS_PACKET_TYPE_MAC_FRAME )
				ChkBoxHardwareFilter.SetItemChecked( 8 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_FUNCTIONAL ) == Packet32h.NDIS_PACKET_TYPE_FUNCTIONAL )
				ChkBoxHardwareFilter.SetItemChecked( 9 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_ALL_FUNCTIONAL ) == Packet32h.NDIS_PACKET_TYPE_ALL_FUNCTIONAL )
				ChkBoxHardwareFilter.SetItemChecked( 10 , true );
			if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_GROUP ) == Packet32h.NDIS_PACKET_TYPE_GROUP )
				ChkBoxHardwareFilter.SetItemChecked( 11 , true );

			ChkDisplayOptionsRealTime.Checked = thisDisplayOptions.UpdateListInRealTime;
			ChkDisplayOptionsAutomaticScroll.Checked = thisDisplayOptions.AutomaticScrollInLiveCapture;

			ChkCaptureLimitsPackets.Checked = thisCaptureLimits.LimitToPackets;
			ChkCaptureLimitsKiloBytes.Checked = thisCaptureLimits.LimitToKiloBytes;
			ChkCaptureLimitsSeconds.Checked = thisCaptureLimits.LimitToSeconds;
			TxtCaptureLimitsPackets.Text = thisCaptureLimits.PacketSize.ToString();
			TxtCaptureLimitsKiloBytes.Text = thisCaptureLimits.KilobyteSize.ToString();
			TxtCaptureLimitsSeconds.Text = thisCaptureLimits.SecondSize.ToString();
			TxtCaptureLimitsPackets.Enabled = ChkCaptureLimitsPackets.Checked;
			TxtCaptureLimitsKiloBytes.Enabled = ChkCaptureLimitsKiloBytes.Checked;
			TxtCaptureLimitsSeconds.Enabled = ChkCaptureLimitsSeconds.Checked;

			ChkNameResolutionMAC.Checked = thisNameResolution.EnableMAC;
			ChkNameResolutionNetwork.Checked = thisNameResolution.EnableNetwork;
			ChkNameResolutionTransport.Checked = thisNameResolution.EnableTransport;
			ChkManufacturerNameResolution.Checked = thisNameResolution.EnableManufacturer;
		
		}

		private void ChkCaptureMode_CheckStateChanged(object sender, System.EventArgs e)
		{
			if( ChkCaptureMode.Checked )
				ChkBoxHardwareFilter.SetItemChecked( 5 , true );
			else
				ChkBoxHardwareFilter.SetItemChecked( 5 , false );
		}

		private void ChkBoxHardwareFilter_SelectedValueChanged(object sender, System.EventArgs e)
		{
			ChkCaptureMode.Checked = ChkBoxHardwareFilter.GetItemChecked( 5 );
		}

		private void CaptureOptions_Activated(object sender, System.EventArgs e)
		{
			int i = 0;

			if( ! ParamsLoaded )
			{
				P32.ReadSettings();

				thisCaptureLimits = P32.CaptureLimits;
				thisCaptureOptions = P32.CaptureOptions;
				thisDisplayOptions = P32.DisplayOptions;
				thisNameResolution = P32.NameResolution;
				Adapters = P32.InstalledAdapters;

				CmbAdapter.Items.Clear();
				if( Adapters != null )
				{
					if( Adapters.Length != 0 )
					{
						for( i = 0; i < Adapters.GetLength(0); i ++ )
							CmbAdapter.Items.Add( Adapters[i] );
					}
				}

				if( CmbAdapter.Items.Count > 0 )
					CmbAdapter.SelectedIndex = 0;

				TxtEachPacketSize.Text = thisCaptureOptions.PacketSize.ToString();
				ChkCaptureLimit.Checked = thisCaptureOptions.LimitPackets;
				TxtEachPacketSize.Enabled = thisCaptureOptions.LimitPackets;
				ChkCaptureMode.Checked = thisCaptureOptions.PromiscuousMode;
				TxtFilter.Text = thisCaptureOptions.Filter;

				TxtAdapterBufferSize.Text = thisCaptureOptions.AdapterBufferSize.ToString();
				TxtBufferSize.Text = thisCaptureOptions.BufferSize.ToString();
				TxtMinBytesToCopy.Text = thisCaptureOptions.MinBytesToCopy.ToString();
				TxtNumWrites.Text = thisCaptureOptions.NumWrites.ToString();
				TxtReadTimeOut.Text = thisCaptureOptions.ReadTimeOut.ToString();

				if( thisCaptureOptions.CaptureMode == Packet32h.PACKET_MODE_CAPT )
					CmbCaptureMode.SelectedIndex = 0;
				else if( thisCaptureOptions.CaptureMode == Packet32h.PACKET_MODE_STAT )
					CmbCaptureMode.SelectedIndex = 1;
				else if( thisCaptureOptions.CaptureMode == Packet32h.PACKET_MODE_DUMP )
					CmbCaptureMode.SelectedIndex = 2;
				else if( thisCaptureOptions.CaptureMode == Packet32h.PACKET_MODE_STAT_DUMP )
					CmbCaptureMode.SelectedIndex = 3;

				TxtMinBytesToCopy.Text = thisCaptureOptions.MinBytesToCopy.ToString();
				TxtMinBytesToCopy.Text = thisCaptureOptions.MinBytesToCopy.ToString();

				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_DIRECTED ) == Packet32h.NDIS_PACKET_TYPE_DIRECTED )
					ChkBoxHardwareFilter.SetItemChecked( 0 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_MULTICAST ) == Packet32h.NDIS_PACKET_TYPE_MULTICAST )
					ChkBoxHardwareFilter.SetItemChecked( 1 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_ALL_MULTICAST ) == Packet32h.NDIS_PACKET_TYPE_ALL_MULTICAST )
					ChkBoxHardwareFilter.SetItemChecked( 2 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_BROADCAST ) == Packet32h.NDIS_PACKET_TYPE_BROADCAST )
					ChkBoxHardwareFilter.SetItemChecked( 3 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_SOURCE_ROUTING ) == Packet32h.NDIS_PACKET_TYPE_SOURCE_ROUTING )
					ChkBoxHardwareFilter.SetItemChecked( 4 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS ) == Packet32h.NDIS_PACKET_TYPE_PROMISCUOUS )
					ChkBoxHardwareFilter.SetItemChecked( 5 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_SMT ) == Packet32h.NDIS_PACKET_TYPE_SMT )
					ChkBoxHardwareFilter.SetItemChecked( 6 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_ALL_LOCAL ) == Packet32h.NDIS_PACKET_TYPE_ALL_LOCAL )
					ChkBoxHardwareFilter.SetItemChecked( 7 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_MAC_FRAME ) == Packet32h.NDIS_PACKET_TYPE_MAC_FRAME )
					ChkBoxHardwareFilter.SetItemChecked( 8 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_FUNCTIONAL ) == Packet32h.NDIS_PACKET_TYPE_FUNCTIONAL )
					ChkBoxHardwareFilter.SetItemChecked( 9 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_ALL_FUNCTIONAL ) == Packet32h.NDIS_PACKET_TYPE_ALL_FUNCTIONAL )
					ChkBoxHardwareFilter.SetItemChecked( 10 , true );
				if( ( thisCaptureOptions.HardwareFilter & Packet32h.NDIS_PACKET_TYPE_GROUP ) == Packet32h.NDIS_PACKET_TYPE_GROUP )
					ChkBoxHardwareFilter.SetItemChecked( 11 , true );

				ChkDisplayOptionsRealTime.Checked = thisDisplayOptions.UpdateListInRealTime;
				ChkDisplayOptionsAutomaticScroll.Checked = thisDisplayOptions.AutomaticScrollInLiveCapture;

				ChkCaptureLimitsPackets.Checked = thisCaptureLimits.LimitToPackets;
				ChkCaptureLimitsKiloBytes.Checked = thisCaptureLimits.LimitToKiloBytes;
				ChkCaptureLimitsSeconds.Checked = thisCaptureLimits.LimitToSeconds;
				TxtCaptureLimitsPackets.Text = thisCaptureLimits.PacketSize.ToString();
				TxtCaptureLimitsKiloBytes.Text = thisCaptureLimits.KilobyteSize.ToString();
				TxtCaptureLimitsSeconds.Text = thisCaptureLimits.SecondSize.ToString();
				TxtCaptureLimitsPackets.Enabled = ChkCaptureLimitsPackets.Checked;
				TxtCaptureLimitsKiloBytes.Enabled = ChkCaptureLimitsKiloBytes.Checked;
				TxtCaptureLimitsSeconds.Enabled = ChkCaptureLimitsSeconds.Checked;

				ChkNameResolutionMAC.Checked = thisNameResolution.EnableMAC;
				ChkNameResolutionNetwork.Checked = thisNameResolution.EnableNetwork;
				ChkNameResolutionTransport.Checked = thisNameResolution.EnableTransport;
				ChkManufacturerNameResolution.Checked = thisNameResolution.EnableManufacturer;

				ParamsLoaded = true;
			}

		}

		private void ChkCaptureLimit_CheckStateChanged(object sender, System.EventArgs e)
		{
			TxtEachPacketSize.Enabled = ChkCaptureLimit.Checked;
		}

		private void ChkCaptureLimitsKiloBytes_CheckStateChanged(object sender, System.EventArgs e)
		{
			TxtCaptureLimitsKiloBytes.Enabled = ChkCaptureLimitsKiloBytes.Checked;
		}

		private void ChkCaptureLimitsSeconds_CheckStateChanged(object sender, System.EventArgs e)
		{
			TxtCaptureLimitsSeconds.Enabled = ChkCaptureLimitsSeconds.Checked;
		}

		private void ChkCaptureLimitsPackets_CheckStateChanged(object sender, System.EventArgs e)
		{
			TxtCaptureLimitsPackets.Enabled = ChkCaptureLimitsPackets.Checked;
		}
	}
}
