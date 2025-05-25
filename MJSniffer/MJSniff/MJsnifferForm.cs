using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Net.Sockets;
using System.Net;

using System.Xml;
using System.Xml.Linq;

using System.IO;
using FluorineFx.IO;

namespace MJsniffer
{

    public enum Protocol
    {
        TCP = 6,
        UDP = 17,
        Unknown = -1
    };

    public partial class MJsnifferForm : Form
    {
        //private PacketInjector inject = new PacketInjector();
        private NodeHelper nodeHelper = new NodeHelper();
        private clsDataManager dataManager = new clsDataManager();
        private Color defaultcol;

        private Socket mainSocket;                          //The socket which captures all incoming packets
        private byte[] byteData = new byte[packetBufferSize];
        private bool bContinueCapturing = false;            //A flag to check if packets are to be captured or not
        const int packetBufferSize = 65536;
        const int buffersize = 1024 * 1024 * 10;
        //bool packetInBuffer = false;
        int bufferIndex = 0;

        int clickIndex = 0;
        int clickCount = 0;
        int WhiteOrGreenCount = 0;
        int blueOrPurpleCount = 0;
        int enhanceCount = 0;
        bool maxSpirits = false;
        int spiritSelectedY;

        Clicker clicker = new Clicker();
        Dictionary<string, object> lastMessage;
        bool MessageReady = false;
        System.Threading.Thread clickerThread;
        bool running = true;
        bool Page2 = false;
        bool Page3 = false;
        bool PageSelectDone = false;

        DateTime LastEnhance;


        byte[] dataBuffer = new byte[buffersize];


        private delegate void AddTreeNode(TreeNode node);



        public MJsnifferForm()
        {
            InitializeComponent();
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            if (cmbInterfaces.Text == "")
            {
                MessageBox.Show("Select an Interface to capture the packets.", "MJsniffer",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            try
            {
                if (!bContinueCapturing)
                {
                    //Start capturing the packets...

                    btnStart.Text = "&Stop";

                    bContinueCapturing = true;

                    //For sniffing the socket to capture the packets has to be a raw socket, with the
                    //address family being of type internetwork, and protocol being IP
                    mainSocket = new Socket(System.Net.Sockets.AddressFamily.InterNetwork,
                        SocketType.Raw, ProtocolType.IP);

                    mainSocket.ReceiveBufferSize = 1024 * 1024 * 10;
                    mainSocket.SendBufferSize = 1024 * 1024 * 10;

                    //Bind the socket to the selected IP address
                    mainSocket.Bind(new IPEndPoint(IPAddress.Parse(cmbInterfaces.Text), 0));

                    //Set the socket  options
                    mainSocket.SetSocketOption(SocketOptionLevel.IP,            //Applies only to IP packets
                                               SocketOptionName.HeaderIncluded, //Set the include the header
                                              true);                           //option to true


                    byte[] byTrue = new byte[4] { 1, 0, 0, 0 };
                    byte[] byOut = new byte[4] { 255, 0, 0, 0 }; //Capture outgoing packets

                    //Socket.IOControl is analogous to the WSAIoctl method of Winsock 2
                    //mainSocket.RemoteEndPoint = 6100;
                    mainSocket.IOControl(IOControlCode.ReceiveAll,              //Equivalent to SIO_RCVALL constant of Winsock 2
                                         byTrue,
                                         null); // byOut

                    //Start receiving the packets asynchronously
                    mainSocket.BeginReceive(byteData, 0, byteData.Length, SocketFlags.None,
                        new AsyncCallback(OnReceive), null);

                }
                else
                {
                    btnStart.Text = "&Start";
                    bContinueCapturing = false;
                    //To stop capturing the packets close the socket
                    mainSocket.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "MJsniffer", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void OnReceive(IAsyncResult ar)
        {
            try
            {

                int nReceived = mainSocket.EndReceive(ar);

                //Analyze the bytes received...
                byte[] localByte = new byte[byteData.Length];
                byteData.CopyTo(localByte, 0);
                if (bContinueCapturing)
                {
                    byteData = new byte[packetBufferSize];

                    //Another call to BeginReceive so that we continue to receive the incoming
                    //packets
                    mainSocket.BeginReceive(byteData, 0, byteData.Length, SocketFlags.None,
                        new AsyncCallback(OnReceive), null);
                }
                int i = localByte[12];
                if (i == 50)
                {
                    i = i;
                }
                //54.221.214.0
                //FB = 157.240.8.35 
                //if (localByte[12] == 50 && localByte[13] == 16 && localByte[14] == 190 && localByte[15] == 195)
                //if (localByte[12] == 54 && localByte[13] == 221 && localByte[14] == 214 && localByte[15] == 0)
                //if (localByte[12] == 157 && localByte[13] == 240 && localByte[14] == 8 && localByte[15] == 35)
                {
                    ParseData(localByte, nReceived);
                }

            }
            catch (ObjectDisposedException)
            {
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "MJsniffer", MessageBoxButtons.OK, MessageBoxIcon.Error);
                //   mainSocket.BeginReceive(byteData, 0, byteData.Length, SocketFlags.None,
                //       new AsyncCallback(OnReceive), null);
            }
        }



        private void AddListItem(byte[] data, int packetLength, bool outgoing)
        {
            string text = "";
            int dataLength2 = 0;
            string message = "";

            if (packetLength > 4)
            {
                Buffer.BlockCopy(data, 0, dataBuffer, bufferIndex, packetLength);
                bufferIndex += packetLength;


                dataLength2 = (dataBuffer[0] << 24) + (dataBuffer[1] << 16) + (dataBuffer[2] << 8) + dataBuffer[3];
                if (dataBuffer[0] > 0)
                {
                    //string rawData = Encoding.UTF8.GetString(data, 0, packetLength).Replace("\0", "");
                    //message = "unknown packet form :" + rawData + "\r\n";
                    bufferIndex = 0;
                    //<policy-file-request/>
                    //<?xml version="1.0" encoding="utf-8"?><!DOCTYPE cross-domain-policy SYSTEM "http://www.adobe.com/xml/dtds/cross-domain-policy.dtd"><cross-domain-policy><site-control permitted-cross-domain-policies="all"/><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>
                }
                else
                {

                    if (dataLength2 <= bufferIndex)
                    {

                        MemoryStream memStream = new MemoryStream(dataBuffer, 4, dataLength2);
                        int len = 0;

                        byte[] theImageDecompressed = new byte[buffersize];

                        //MemoryStream ms = new MemoryStream();
                        //Stream s = new ComponentAce.Compression.Libs.zlib.ZOutputStream(ms);
                        ComponentAce.Compression.Libs.zlib.ZInputStream test = new ComponentAce.Compression.Libs.zlib.ZInputStream(memStream);

                        try
                        {
                            int offset = 0;
                            len = 1;
                            while (len > 0)
                            {
                                len = test.read(theImageDecompressed, offset, buffersize);
                                if (len > 0)
                                {
                                    offset += len;
                                }
                            }
                            len = offset;
                        }
                        catch (Exception ex)
                        {
                            message = "Decompress error :" + ex.Message + "\r\n";
                            len = 0;
                            bufferIndex = 0;
                        }


                        if (len > 0)
                        {
                            try
                            {

                                MemoryStream decompressed = new MemoryStream(theImageDecompressed, 0, len);
                                decompressed.Position = 0;
                                var sr = new StreamReader(decompressed);
                                var myStr = sr.ReadToEnd();
                                decompressed.Position = 0;
                                AMFDeserializer amfDeserializer = new FluorineFx.IO.AMFDeserializer(decompressed);

                                Dictionary<string, object> tmp = (Dictionary<string, object>)amfDeserializer.ReadAMF3Data();

                                if (outgoing == false)
                                {
                                    lastMessage = tmp;
                                    MessageReady = true;
                                    //ProcessMessage();
                                }

                            }
                            catch (Exception ex)
                            {
                                string rawData = Encoding.UTF8.GetString(dataBuffer, 0, dataLength2).Replace("\0", "");
                                message = "decode error" + ex.Message + "::" + rawData + "\r\n";
                            }
                            bufferIndex = 0;
                        }
                    }
                    else
                    {
                        message = "delayed, incomplete packet \r\n";
                    }
                }

            }
            else
            {
                message = "(" + text.Length.ToString().PadRight(4) + ")" + text + "::" + "ack" + "\r\n";
            }

        }

        void UpdateBusy(string busyText)
        {

            if (this.txtBusy.InvokeRequired)
            {
                this.txtBusy.BeginInvoke((MethodInvoker)delegate ()
                {
                    if (busyText == "OK")
                    {
                        this.BackColor = defaultcol;
                    }
                    else
                    {
                        this.BackColor = Color.Red;
                    }
                    this.txtBusy.Text = busyText;
                });
            }
            else
            {
                this.txtBusy.Text = busyText;
            }
        }


        void UpdateXY()
        {
            MouseOperations.MousePoint aa;
            aa = MouseOperations.GetCursorPosition();
            if (this.txtXY.InvokeRequired)
            {
                this.txtXY.BeginInvoke((MethodInvoker)delegate ()
                {
                    txtXY.Text = (aa.X - clicker.OriginX).ToString() + ":" + (aa.Y - clicker.OriginY).ToString();
                });
            }
            else
            {
                txtXY.Text = (aa.X - clicker.OriginX).ToString() + ":" + (aa.Y - clicker.OriginY).ToString();
            }
        }


        private void ParseData(byte[] byteData, int nReceived)
        {
            //Since all protocol packets are encapsulated in the IP datagram
            //so we start by parsing the IP header and see what protocol data
            //is being carried by it
            IPHeader ipHeader = new IPHeader(byteData, nReceived);
            //if (!(ipHeader.SourceAddress.ToString() == "54.221.214.0"))
            if (!(ipHeader.SourceAddress.ToString() == "157.240.8.35"))
            //157.240.8.35
            {
                return;
            }

            //Now according to the protocol being carried by the IP datagram we parse 
            //the data field of the datagram
            switch (ipHeader.ProtocolType)
            {
                case Protocol.TCP:

                    TCPHeader tcpHeader = new TCPHeader(ipHeader.Data,              //IPHeader.Data stores the data being 
                                                                                    //carried by the IP datagram
                                                        ipHeader.MessageLength);//Length of the data field                    
                    if (tcpHeader.SourcePort != "6100" && tcpHeader.DestinationPort != "6100")
                    {
                        return;
                    }

                    if (tcpHeader.MessageLength > 0)
                    {
                        AddListItem(tcpHeader.Data, tcpHeader.MessageLength, tcpHeader.DestinationPort == "6100");
                    }
                    break;
            }
        }


        private void SnifferForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            running = false;
            try
            {
                if (bContinueCapturing)
                {
                    mainSocket.Close();
                }
                if (ghk != null) ghk.Unregiser();
            }
            catch
            {
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            UpdateXY();
            CheckForIdle();
            if (dataManager.dataLayer.auctionUpdated)
            {
                if (chkAH.Checked)
                {
                    dataGridView1.DataSource = dataManager.dataLayer.GetAuction();
                }
            }
            if (maxSpirits && LastEnhance < DateTime.Now.AddSeconds(-30))
            {
                LastEnhance = DateTime.Now;
                sendClick();
            }
        }

        private void MJsnifferForm_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 'o')
            {
                MouseOperations.MousePoint cc;
                cc = MouseOperations.GetCursorPosition();
                clicker.OriginX = cc.X;
                clicker.OriginY = cc.Y;
                txtOriginX.Text = cc.X.ToString();
                txtOriginY.Text = cc.Y.ToString();
            }
        }

        private void ProcessMessage()
        {
            while (running)
            {
                try
                {
                    System.Threading.Thread.Sleep(10);
                    if (MessageReady == true)
                    {
                        bool processed = false;
                        MessageReady = false;

                        if (lastMessage["cmd"].ToString() == "createSoul")
                        {
                            processed = true;
                            maxSpirits = false;
                            clickCount++;
                            if (clickIndex == 0 || clickIndex == 1)
                            { WhiteOrGreenCount++; }

                            if (((FluorineFx.ASObject)lastMessage["data"]).ContainsKey("openNext"))
                                if (((FluorineFx.ASObject)lastMessage["data"])["openNext"].ToString() == "True")
                                {
                                    clickIndex++;

                                }
                                else
                                {
                                    clickIndex = 0;
                                }
                            else
                            {
                                clickIndex = 0;
                            }
                            sendClick();
                        }

                        if (lastMessage["cmd"].ToString() == "comfirmInfo")
                        {
                            processed = true;
                            if (lastMessage["data"].ToString() == "max_soul_size")
                            {
                                if (WhiteOrGreenCount > 4)
                                {
                                    maxSpirits = true;
                                }
                                sendClick();
                            }

                        }

                        if (lastMessage["cmd"].ToString() == "strengthSoul")
                        {
                            processed = true;
                            if (WhiteOrGreenCount > 4)
                            {
                                maxSpirits = true;
                            }
                            sendClick();
                        }

                        if (processed == false)
                        {
                            UpdateBusy("BUSY");
                            dataManager.ProcessData(lastMessage);
                            UpdateBusy("OK");
                        }
                    }
                }

                catch (Exception ex)
                {
                    string test = ex.Message;
                }
            }
        }


        private void sendEnchance()
        {
            enhanceCount++;
            clicker.AutoAdd();

            clicker.Enhance();

        }


        private void sendEnchanceLast(bool skip)
        {
            enhanceCount = 0;
            clicker.AutoAdd();

            if (skip == false)
            {
                // Select boxes
                clicker.SetBoxes();
            }

            clicker.Enhance();
            System.Threading.Thread.Sleep(100);

            clicker.OkToEnhanceBlue();// ok to enchance blue

            clicker.HeroSpiritTab();
            WhiteOrGreenCount = 0;
            maxSpirits = false;
            System.Threading.Thread.Sleep(500);
            sendClick();
        }

        private void sendClick()
        {
            LastEnhance = DateTime.Now;
            if (maxSpirits)
            {

                if (chkCollectOnly.Checked == false)
                {
                    // clear dialogue
                    clicker.OkToEnhanceBlue();

                    // tab select
                    clicker.EnhanceTab();

                    // Page select
                    if (Page2 == true && PageSelectDone == false)
                    {
                        clicker.EnhanceDown();
                        if (Page3)
                        {
                            clicker.EnhanceDown();
                        }
                        PageSelectDone = true;
                    }

                    // item select
                    clicker.SelectItemToEnhance(spiritSelectedY);

                    if (blueOrPurpleCount > 10 && chkDoPurples.Checked)
                    {
                        blueOrPurpleCount -= 8;
                        if (blueOrPurpleCount < 0) blueOrPurpleCount = 0;
                        clicker.ClickFirst8EnhanceBoxes();

                        clicker.Enhance();

                        clicker.OkToEnhanceBluePurple();// ok to enchance blue

                    }
                    else
                    {
                        if (WhiteOrGreenCount > 8)
                        {
                            WhiteOrGreenCount -= 8;

                            sendEnchance();
                        }
                        else
                        {
                            sendEnchanceLast(true);
                            WhiteOrGreenCount = 0;
                        }
                    }
                    UpdateStats();
                }

            }
            else
            {
                PageSelectDone = false;
                if (clickCount > 9)
                {
                    clickCount = 0;
                    clicker.ClearHistory();// clear
                }
                switch (clickIndex)
                {
                    case 0:
                        clicker.WhiteEnhance();

                        break;
                    case 1:
                        clicker.GreenEnhance();
                        break;
                    case 2:
                        clicker.BlueEnhance();
                        blueOrPurpleCount++;
                        break;

                    case 3:
                        clicker.PurpleEnhance();
                        blueOrPurpleCount++;
                        break;

                }
            }
        }

        private void UpdateStats()
        {
            if (this.txtGreenCount.InvokeRequired)
            {
                this.txtGreenCount.BeginInvoke((MethodInvoker)delegate ()
                {
                    this.txtGreenCount.Text = WhiteOrGreenCount.ToString();
                });
            }
            else
            {
                this.txtGreenCount.Text = WhiteOrGreenCount.ToString();
            }
        }

        private void cboEnchanceBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selected = cboEnchanceBox.SelectedItem.ToString();
            spiritSelectedY = int.Parse(selected.Substring(0, selected.IndexOf('(') - 1));
        }

        private void MJsnifferForm_MouseEnter(object sender, EventArgs e)
        {

        }

        private void butReset_Click(object sender, EventArgs e)
        {
            txtGreenCount.Text = "0";
            WhiteOrGreenCount = 0;
        }

        private void butPillar_Click(object sender, EventArgs e)
        {
            frmDammageViewer frm = new frmDammageViewer();
            frm.Show();
        }

        private void chkPage2_CheckedChanged(object sender, EventArgs e)
        {
            Page2 = chkPage2.Checked;
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void SnifferForm_Load(object sender, EventArgs e)
        {
            txtItemInEquip.Visible = false;
            defaultcol = this.BackColor;
            dataManager.dataLayer.OpenConnection();
            dataManager.FoundPurpleInEquipEvent += FoundPurpleInEquip;
            dataManager.BattleEnd += DataManager_BattleEnd;
            dataManager.BattleTimeoutReset += DataManager_BattleTimeoutReset;
            string strIP = null;
            clickerThread = new System.Threading.Thread(ProcessMessage);
            clickerThread.Start();

            IPHostEntry HosyEntry = Dns.GetHostEntry((Dns.GetHostName()));
            if (HosyEntry.AddressList.Length > 0)
            {
                foreach (IPAddress ip in HosyEntry.AddressList)
                {
                    strIP = ip.ToString();
                    cmbInterfaces.Items.Add(strIP);
                }
            }
            if (System.Environment.MachineName == "LAPTOP-MUIBJE7O")
            {
                cmbInterfaces.SelectedIndex = 0;
            }
            else
            {
                cmbInterfaces.SelectedIndex = 1;
            }
            txtOriginX.Text = clicker.OriginX.ToString();
            txtOriginY.Text = clicker.OriginY.ToString();

            cboEnchanceBox.SelectedIndex = 1;
            dataManager.clicker = clicker;

            dataManager.dataLayer.GetArena();
            timer1.Enabled = true;
        }


        private void FoundPurpleInEquip(string message, bool hide)
        {
            this.txtItemInEquip.BeginInvoke((MethodInvoker)delegate ()
            {
                if (hide == true)
                {
                    txtItemInEquip.Visible = false;
                }
                else
                {
                    txtItemInEquip.Visible = true;
                    txtItemInEquip.Text = message;
                }
            });
        }

        private void chkCycleGalaxy_CheckedChanged(object sender, EventArgs e)
        {
            dataManager.cycleGalaxy = chkCycleGalaxy.Checked;
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            Page3 = checkBox1.Checked;
        }

        private GlobalHotkey ghk;

        private void ButClicky_Click(object sender, EventArgs e)
        {
            ghk = new GlobalHotkey(GlobalHotkey.SHIFT, Keys.F1, this);
            ghk.Register();
        }

        protected override void WndProc(ref Message m)
        {
            if (m.Msg == GlobalHotkey.WM_HOTKEY_MSG_ID)
                HandleHotkey();
            base.WndProc(ref m);
        }
        private void HandleHotkey()
        {
            MouseOperations.MouseEvent(MouseOperations.MouseEventFlags.LeftDown);
            System.Threading.Thread.Sleep(10);
            MouseOperations.MouseEvent(MouseOperations.MouseEventFlags.LeftUp);
            // System.Threading.Thread.Sleep(50);
        }

        private void butAttach_Click(object sender, EventArgs e)
        {
            MouseOperations.MousePoint cc;
            cc = MouseOperations.GetCursorPosition();

            for (int i = 0; i < 16; i++)
            //int i = 0;
            {
                double offset = (double)i * 21.4;
                int x = 105;
                int y = 164 + (int)offset;
                clicker.SetAndClickWithOrigin(x, y, 20);
                System.Threading.Thread.Sleep(200);
                x = 286;
                y = 194 + (int)offset;
                clicker.SetAndClickWithOrigin(x, y, 50);
                System.Threading.Thread.Sleep(400);

                clicker.SetAndClickWithOrigin(600, 265, 50);


                System.Threading.Thread.Sleep(400);
                clicker.SetAndClickWithOrigin(683, 317, 50); // attack
                System.Threading.Thread.Sleep(400);
                clicker.SetAndClickWithOrigin(446, 350, 50); // already hit 
                //System.Threading.Thread.Sleep(500);

                clicker.SetAndClickWithOrigin(373, 357, 50); // ok
                System.Threading.Thread.Sleep(1800);
                // long wait

                clicker.SetAndClickWithOrigin(809, 40, 50);
                System.Threading.Thread.Sleep(100);
                clicker.SetAndClickWithOrigin(809, 40, 50); // close battle


                clicker.SetAndClickWithOrigin(680, 103, 50); // back to gal
                System.Threading.Thread.Sleep(700);
                // small wait


            }
            MouseOperations.SetCursorPosition(cc.X, cc.Y);

        }

        private void butVisit_Click(object sender, EventArgs e)
        {
            MouseOperations.MousePoint cc;
            cc = MouseOperations.GetCursorPosition();

            for (int i = 0; i < 20; i++)
            {
                clicker.SetAndClickWithOrigin(600, 265, 10);//planet click
                System.Threading.Thread.Sleep(100);

                clicker.SetAndClickWithOrigin(678, 255, 10);//visit
                System.Threading.Thread.Sleep(500);

                clicker.SetAndClickWithOrigin(447, 370, 10);//Exit
                System.Threading.Thread.Sleep(100);
                clicker.SetAndClickWithOrigin(834, 81, 10);//Exit
                System.Threading.Thread.Sleep(500);
            }
            MouseOperations.SetCursorPosition(cc.X, cc.Y);

        }

        private void butDaily_Click(object sender, EventArgs e)
        {
            MouseOperations.MousePoint cc;
            cc = MouseOperations.GetCursorPosition();
            for (int i = 0; i < 21; i++)
            {
                double offset = (double)i * 76.05;
                int x = 30 + (int)offset;
                int y = -49;
                clicker.SetAndClickWithOrigin(x, y, 10);//tab select
                System.Threading.Thread.Sleep(100);
                clicker.SetAndClickWithOrigin(456, 375, 10);//Spin
                System.Threading.Thread.Sleep(100);
                clicker.SetAndClickWithOrigin(611, 288, 10);//Close spin
                System.Threading.Thread.Sleep(100);
                clicker.SetAndClickWithOrigin(876, 308, 10);//Collect
            }
            MouseOperations.SetCursorPosition(cc.X, cc.Y);

        }

        private void DataManager_BattleEnd()
        {
            if (chkAutoPirate.Checked)
            {
                System.Threading.Thread.Sleep(4000);
                ClickPirate();
            }
        }

        private void DataManager_BattleTimeoutReset()
        {
            _LastAction = DateTime.Now;
        }

        private void CheckForIdle()
        {
            if (chkAutoPirate.Checked == true && _LastAction < DateTime.Now.AddMinutes(-1))
            {
                _LastAction = DateTime.Now;
                ClickPirate();
            }
        }

        private DateTime _LastAction;
        private bool _pirateActive;
        private int _battleCount = 0;

        private void butPirate_Click(object sender, EventArgs e)
        {
            chkAutoPirate.Checked = true;
            //clicker.SetAndClickWithOrigin (cc.X - clicker.OriginX, cc.Y - clicker.OriginY, 10);// Auto click
            ClickPirate();
        }

        private void ClickPirate()
        {
            _pirateActive = true;
            MouseOperations.MousePoint cc;
            cc = MouseOperations.GetCursorPosition();

            //for (int i = 0; i < 21; i++)
            int i = 0;
            {
                double offset = (double)i * 76.05;
                int x = 30 + (int)offset;
                int y = -49;

                clicker.SetAndClickWithOrigin(767, 54, 50);// close popup
                //clicker.SetAndClickWithOrigin(x, y, 50);//tab select
                clicker.SetAndClickWithOrigin(768, 54, 50);// close mission window
                System.Threading.Thread.Sleep(100);
                clicker.SetAndClickWithOrigin(751, 124, 50);// close battle
                clicker.SetAndClickWithOrigin(834, 83, 50);// back from planet
                System.Threading.Thread.Sleep(400);

                //1551, -49, 76.05
                if (chkP10.Checked)
                {
                    clicker.SetAndClickWithOrigin(202, 393, 50);// p10
                    System.Threading.Thread.Sleep(200);
                    clicker.SetAndClickWithOrigin(258, 386, 50);// p10
                }
                else
                {
                    clicker.SetAndClickWithOrigin(313, 474, 50);// p9 
                    System.Threading.Thread.Sleep(200);
                    //clicker.SetAndClickWithOrigin(370, 474, 10);// p9 
                    clicker.SetAndClickWithOrigin(398, 463, 50);// visit 
                }

                // wait for planet to load
                System.Threading.Thread.Sleep(1000);
                clicker.SetAndClickWithOrigin(454, 373, 50);// 
                System.Threading.Thread.Sleep(500);



                // building clicks
                clicker.SetAndClickWithOrigin(182, 149, 10);// 
                clicker.SetAndClickWithOrigin(409, 160, 10);// 
                clicker.SetAndClickWithOrigin(722, 167, 10);// 
                clicker.SetAndClickWithOrigin(164, 283, 10);// 
                clicker.SetAndClickWithOrigin(343, 344, 10);// 
                clicker.SetAndClickWithOrigin(677, 344, 10);// 
                clicker.SetAndClickWithOrigin(523, 423, 10);// 
                clicker.SetAndClickWithOrigin(440, 492, 10);// 
                clicker.SetAndClickWithOrigin(633, 383, 10);// 
                clicker.SetAndClickWithOrigin(192, 400, 10);// 

                System.Threading.Thread.Sleep(100);

                clicker.SetAndClickWithOrigin(377, 357, 50);// OK click
                System.Threading.Thread.Sleep(500);
                clicker.SetAndClickWithOrigin(658, 128, 50);// next click on battle
                System.Threading.Thread.Sleep(800);
                clicker.SetAndClickWithOrigin(697, 133, 50);// next click pirate
                System.Threading.Thread.Sleep(200);
                clicker.SetAndClickWithOrigin(697, 133, 50);// next click pirate

                System.Threading.Thread.Sleep(200);
                clicker.SetAndClickWithOrigin(658, 128, 50);// next click on battle
                System.Threading.Thread.Sleep(200);
                clicker.SetAndClickWithOrigin(697, 133, 50);// next click pirate
                System.Threading.Thread.Sleep(200);
                clicker.SetAndClickWithOrigin(697, 133, 50);// next click pirate


                // wait for your turn animation
                System.Threading.Thread.Sleep(500);
                clicker.SetAndClickWithOrigin(104, 451, 50);// Auto click
                                                            // wait for battle to complete



            }

            MouseOperations.SetCursorPosition(cc.X, cc.Y);
            _pirateActive = false;

        }

        private void butEnhanceBlues_Click(object sender, EventArgs e)
        {

            MouseOperations.MousePoint cc;
            cc = MouseOperations.GetCursorPosition();


            blueOrPurpleCount -= 8;
            if (blueOrPurpleCount < 0) blueOrPurpleCount = 0;
            clicker.ClickFirst8EnhanceBoxes();

            clicker.Enhance();

            clicker.OkToEnhanceBluePurple();// ok to enchance blue

            MouseOperations.SetCursorPosition(cc.X, cc.Y);
        }
    }
}