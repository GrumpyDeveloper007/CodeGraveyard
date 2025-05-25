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
        private Color defaultcol;

        private Socket mainSocket;                          //The socket which captures all incoming packets
        private byte[] byteData = new byte[4096];
        private bool bContinueCapturing = false;            //A flag to check if packets are to be captured or not
        const int buffersize = 1024 * 1024 * 10;
        //bool packetInBuffer = false;
        int bufferIndex = 0;

        //uint LastSequenceNumber;
        //uint LastAcknowledgmentNumber;
        //string SourceIP;
        //UInt16 sourceport;
        int cmdId;
        int clickIndex = 0;
        int clickCount = 0;
        int WhiteOrGreenCount = 0;
        int blueOrPurpleCount = 0;
        int enhanceCount = 0;
        bool maxSpirits = false;
        int spiritSelectedY;
        bool enableLog=false;
        Clicker clicker = new Clicker();
        Dictionary<string, object> lastMessage;
        bool MessageReady = false;
        System.Threading.Thread clickerThread;
        bool running = true;
        bool Page2 = false;
        bool PageSelectDone = false;


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

                    //Bind the socket to the selected IP address
                    mainSocket.Bind(new IPEndPoint(IPAddress.Parse(cmbInterfaces.Text), 0));

                    //Set the socket  options
                    mainSocket.SetSocketOption(SocketOptionLevel.IP,            //Applies only to IP packets
                                               SocketOptionName.HeaderIncluded, //Set the include the header
                                               true);                           //option to true

                    byte[] byTrue = new byte[4] { 1, 0, 0, 0 };
                    byte[] byOut = new byte[4] { 1, 0, 0, 0 }; //Capture outgoing packets

                    //Socket.IOControl is analogous to the WSAIoctl method of Winsock 2
                    // mainSocket.RemoteEndPoint = 6100;
                    mainSocket.IOControl(IOControlCode.ReceiveAll,              //Equivalent to SIO_RCVALL constant
                        //of Winsock 2
                                         byTrue,
                                         byOut);

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
                byteData.CopyTo(localByte,0);
                if (bContinueCapturing)
                {
                    byteData = new byte[4096];

                    //Another call to BeginReceive so that we continue to receive the incoming
                    //packets
                    mainSocket.BeginReceive(byteData, 0, byteData.Length, SocketFlags.None,
                        new AsyncCallback(OnReceive), null);
                }
                ParseData(localByte, nReceived);

            }
            catch (ObjectDisposedException)
            {
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "MJsniffer", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }



        private void AddListItem(byte[] data, int packetLength, bool outgoing)
        {
            string text = "";
            //text=BitConverter.ToString(tcpHeader.Data).Replace("-", "").Substring(0, tcpHeader.MessageLength * 2)
            int dataLength2 = 0;
            string message = "";

            if (packetLength > 4)
            {
                for (int i = 0; i < packetLength; i++)
                {
                    //captureBuffer += data[i] + ",";
                    dataBuffer[bufferIndex] = data[i];
                    bufferIndex++;
                }
                dataLength2 = (dataBuffer[0] << 24) + (dataBuffer[1] << 16) + (dataBuffer[2] << 8) + dataBuffer[3];
                if (dataBuffer[0] > 0)
                {
                    string rawData = Encoding.UTF8.GetString(data, 0, packetLength).Replace("\0", "");
                    message = "unknown packet form :" + rawData + "\r\n";
                    bufferIndex = 0;

                }
                else
                {

                    if (dataLength2 <= bufferIndex)
                    {

                        MemoryStream memStream = new MemoryStream(dataBuffer, 4, dataLength2);
                        int len = 0;

                        byte[] theImageDecompressed = new byte[buffersize];

                        MemoryStream ms = new MemoryStream();
                        Stream s = new ComponentAce.Compression.Libs.zlib.ZOutputStream(ms);
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
                        }


                        if (len > 0)
                        {
                            try
                            {

                                //System.IO.File.WriteAllBytes("test.bin", theImageDecompressed);

                                MemoryStream decompressed = new MemoryStream(theImageDecompressed, 0, len);
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
                this.txtBusy.BeginInvoke((MethodInvoker)delegate()
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
                this.txtXY.BeginInvoke((MethodInvoker)delegate()
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
            TreeNode rootNode = new TreeNode();

            //Since all protocol packets are encapsulated in the IP datagram
            //so we start by parsing the IP header and see what protocol data
            //is being carried by it
            IPHeader ipHeader = new IPHeader(byteData, nReceived);
            if (!(ipHeader.SourceAddress.ToString() == "50.16.190.195"))
            //if (!(ipHeader.SourceAddress.ToString() == "107.22.186.133"))
            //
            {
                //ipHeader.DestinationAddress.ToString() == "50.16.190.195" ||
                return;
            }


            // TreeNode ipNode = nodeHelper.MakeIPTreeNode(ipHeader);

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

                case Protocol.UDP:
                    return;

                    UDPHeader udpHeader = new UDPHeader(ipHeader.Data,              //IPHeader.Data stores the data being 
                        //carried by the IP datagram
                                                       (int)ipHeader.MessageLength);//Length of the data field                    

                    if (enableLog)
                    {
                        //rootNode.Nodes.Add(ipNode);
                        TreeNode udpNode = nodeHelper.MakeUDPTreeNode(udpHeader);

                        rootNode.Nodes.Add(udpNode);

                        //If the port is equal to 53 then the underlying protocol is DNS
                        //Note: DNS can use either TCP or UDP thats why the check is done twice
                        if (udpHeader.DestinationPort == "53" || udpHeader.SourcePort == "53")
                        {

                            TreeNode dnsNode = nodeHelper.MakeDNSTreeNode(udpHeader.Data,
                                //Length of UDP header is always eight bytes so we subtract that out of the total 
                                //length to find the length of the data
                                                               Convert.ToInt32(udpHeader.Length) - 8);
                            rootNode.Nodes.Add(dnsNode);
                        }
                    }

                    break;

                case Protocol.Unknown:
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
            }
            catch
            {
            }
        }


        private void butSend_Click(object sender, EventArgs e)
        {
            WhiteOrGreenCount = 0;
            sendClick();
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

                        MessageReady = false;

                        if (lastMessage["cmd"].ToString() == "createSoul")
                        {
             
                            maxSpirits = false;
                            clickCount++;
                            if (clickIndex == 0 || clickIndex == 1)
                            { WhiteOrGreenCount++; }

                            if (((FluorineFx.ASObject)lastMessage["data"]).ContainsKey("openNext"))
                                if (((FluorineFx.ASObject)lastMessage["data"])["openNext"].ToString() == "True")
                                {
                                    clickIndex++;
                                    if (clickCount > 1)
                                    {
                                        blueOrPurpleCount++;
                                    }
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
                            cmdId = int.Parse(lastMessage["cmdId"].ToString());

                        }

                        if (lastMessage["cmd"].ToString() == "comfirmInfo")
                        {
                      
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
                 
                            if (WhiteOrGreenCount > 4)
                            {

                                maxSpirits = true;
                            }
                            sendClick();
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
            if (maxSpirits)
            {
                if (chkCollectOnly.Checked==false )
                {
                    // clear dialogue
                    clicker.OkToEnhanceBlue();


                    // tab select
                    clicker.EnhanceTab();

                    // Page select
                    if (Page2 == true && PageSelectDone == false)
                    {
                        clicker.EnhanceDown();
                        PageSelectDone = true;
                    }

                    // item select
                    clicker.SelectItemToEnhance(spiritSelectedY);


                    if (WhiteOrGreenCount > 8)
                    {
                        WhiteOrGreenCount -= 8;
                        UpdateStats();

                        sendEnchance();
                    }
                    else
                    {
                        sendEnchanceLast(true);
                        WhiteOrGreenCount = 0;
                        UpdateStats();
                    }

                    blueOrPurpleCount = 0;
                }
                else
                {
                    //clicker.OkToEnhanceBlue();

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
                //Packet test = BuildTcpPacket();
                //communicator.SendPacket(test);
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
                        break;

                    case 3:
                        clicker.PurpleEnhance();
                        break;

                }
            }
        }

        private void UpdateStats()
        {
            if (this.txtGreenCount.InvokeRequired)
            {
                this.txtGreenCount.BeginInvoke((MethodInvoker)delegate()
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


        private void chkPage2_CheckedChanged(object sender, EventArgs e)
        {
            Page2 = chkPage2.Checked;
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }



        private void SnifferForm_Load(object sender, EventArgs e)
        {
            defaultcol = this.BackColor;

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
            cmbInterfaces.SelectedIndex = 2;
            txtOriginX.Text = clicker.OriginX.ToString();
            txtOriginY.Text = clicker.OriginY.ToString();

            cboEnchanceBox.SelectedIndex = 9;


        }



        private void butAssign_Click(object sender, EventArgs e)
        {
            clicker.ArmyButton();
            clicker.FirstAssign();
            clicker.ArmyBarMaxTo1();
            clicker.ArmyBarMaxTo2();
            clicker.ArmyBarMaxTo3();
            clicker.ArmyBarMaxTo4();
            clicker.AssignArmy();
        }

        private void butMaxArmy_Click(object sender, EventArgs e)
        {
            clicker.ArmyButton();
            clicker.FirstAssign();
            clicker.ArmyBar1ToMax ();
            clicker.ArmyBar2ToMax();
            clicker.ArmyBar3ToMax();
            clicker.ArmyBar4ToMax();
            clicker.AssignArmy();
        }


        private void timer_arena_Tick(object sender, EventArgs e)
        {
            clicker.WOHCraft();
            clicker.WOHArena();
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            UpdateXY();

        }
    }
}