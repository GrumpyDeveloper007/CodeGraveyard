using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MJsniffer
{
    public partial class GamePlayer : Form
    {
        public GamePlayer()
        {
            InitializeComponent();
        }

        private void GamePlayer_Load(object sender, EventArgs e)
        {
            TcpClient tcpclnt = new TcpClient();
            Console.WriteLine("Connecting.....");

            tcpclnt.Connect("172.21.5.99", 8001);
            // use the ipaddress as in the server program

            Console.WriteLine("Connected");
            Console.Write("Enter the string to be transmitted : ");

            String str = Console.ReadLine();
            Stream stm = tcpclnt.GetStream();

            ASCIIEncoding asen = new ASCIIEncoding();
            byte[] ba = asen.GetBytes(str);
            Console.WriteLine("Transmitting.....");

            stm.Write(ba, 0, ba.Length);

            byte[] bb = new byte[100];
            int k = stm.Read(bb, 0, 100);

            for (int i = 0; i < k; i++)
                Console.Write(Convert.ToChar(bb[i]));

            //2aae589e2a256da9ba7f50b33192934b

            tcpclnt.Close();
        }

        private void BuildPacket()
        {
            MemoryStream ms = new MemoryStream();

            ComponentAce.Compression.Libs.zlib.ZInputStream test = new ComponentAce.Compression.Libs.zlib.ZInputStream(ms);

        }
    }
}
