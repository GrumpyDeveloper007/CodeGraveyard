using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

using PcapDotNet.Packets.Ethernet;
using PcapDotNet.Packets.IpV4;
using PcapDotNet.Packets.Transport;
using PcapDotNet.Packets;
using PcapDotNet.Core;
using FluorineFx.IO;

namespace MJsniffer
{
    public class PacketInjector
    {


        private byte[] whiteReq = { 0, 0, 0, 53, 120, 218, 227, 226, 102, 228, 78, 206, 77, 241, 76, 97, 17, 229, 76, 73, 44, 73, 228, 98, 148, 76, 46, 74, 77, 44, 73, 45, 242, 204, 75, 73, 173, 96, 97, 96, 100, 7, 74, 179, 137, 66, 4, 131, 243, 75, 115, 24, 1, 80, 250, 14, 52 };
        //{ 0, 0, 0, 54, 120, 218, 227, 226, 102, 228, 78, 206, 77, 241, 76, 97, 105, 174, 102, 7, 50, 216, 68, 147, 139, 82, 19, 75, 82, 131, 243, 75, 115, 56, 83, 18, 75, 18, 185, 24, 37, 33, 34, 69, 158, 121, 41, 169, 21, 44, 12, 140, 140, 0, 139, 0, 15, 29};
        private byte[] yellowReq = { 0, 0, 0, 53, 120, 218, 227, 226, 102, 228, 78, 206, 77, 241, 76, 97, 17, 227, 76, 73, 44, 73, 228, 98, 148, 76, 46, 74, 77, 44, 73, 45, 242, 204, 75, 73, 173, 96, 97, 100, 100, 7, 74, 179, 137, 66, 4, 131, 243, 75, 115, 24, 1, 81, 54, 14, 54 };
        //{ 0, 0, 0, 54, 120, 218, 227, 226, 102, 228, 78, 206, 77, 241, 76, 97, 105, 174, 101, 7, 50, 216, 68, 147, 139, 82, 19, 75, 82, 131, 243, 75, 115, 56, 83, 18, 75, 18, 185, 24, 37, 33, 34, 69, 158, 121, 41, 169, 21, 44, 140, 140, 140, 0, 139, 85, 15, 32 };
        private byte[] blueReq = { 0, 0, 0, 53, 120, 218, 227, 226, 102, 228, 78, 206, 77, 241, 76, 97, 17, 231, 76, 73, 44, 73, 228, 98, 148, 76, 46, 74, 77, 44, 73, 45, 242, 204, 75, 73, 173, 96, 97, 98, 100, 7, 74, 179, 137, 66, 4, 131, 243, 75, 115, 24, 1, 81, 114, 14, 56 };

        public byte[] uncompressedWiteReq = { 10, 11, 1, 9, 100, 97, 116, 97, 10, 1, 25, 99, 114, 101, 97, 116, 101, 114, 73, 110, 100, 101, 120, 4, 0, 1, 7, 99, 109, 100, 6, 21, 99, 114, 101, 97, 116, 101, 83, 111, 117, 108, 11, 99, 109, 100, 73, 100, 4, 131, 68, 1 };
        //private byte[] uncompressedWiteReq = { 10, 11, 1, 11, 99, 109, 100, 73, 100, 4, 39, 9, 100, 97, 116, 97, 10, 1, 25, 99, 114, 101, 97, 116, 101, 114, 73, 110, 100, 101, 120, 4, 0, 1, 7, 99, 109, 100, 6, 21, 99, 114, 101, 97, 116, 101, 83, 111, 117, 108, 1 };
        //private byte[] uncompressedWiteReq2 = { 10, 11, 1, 9, 100, 97, 116, 97, 10, 1, 25, 99, 114, 101, 97, 116, 101, 114, 73, 110, 100, 101, 120, 4, 0, 1, 7, 99, 109, 100, 6, 21, 99, 114, 101, 97, 116, 101, 83, 111, 117, 108, 11, 99, 109, 100, 73, 100, 4, 131, 49, 1 };
        //homemade 10,11,1,11,99,109,100,73,100,4,39,9,100,97,116,97,10,1,25,99,114,101,97,116,101,114,73,110,100,101,120,4,0,1,7,99,109,100,6,21,99,114,101,97,116,101,83,111,117,108,1,

        uint LastSequenceNumber;
        uint LastAcknowledgmentNumber;
        string SourceIP;
        UInt16 sourceport;
        int cmdId;
        uint LastIdent;
        bool messageSent = false;

        PacketCommunicator communicator;


        public PacketInjector()
        {

            IList<LivePacketDevice> allDevices = LivePacketDevice.AllLocalMachine;
            PacketDevice selectedDevice = allDevices[0];
            communicator = selectedDevice.Open(100, PacketDeviceOpenAttributes.Promiscuous, 1000);
        }

        private class command
        {
            public int cmdId;
            public Dictionary<string, string> data = new Dictionary<string, string>();
            public string cmd;
        }

        Dictionary<string, object> DecodeCommand(byte[] command)
        {
            MemoryStream decompressed = new MemoryStream(command, 0, command.Length);
            AMFDeserializer amfDeserializer = new FluorineFx.IO.AMFDeserializer(decompressed);
            Dictionary<string, object> tmp = (Dictionary<string, object>)amfDeserializer.ReadAMF3Data();
            return tmp;
        }

        byte[] EncodeCommand(Dictionary<string, object> tmp)
        {
            MemoryStream compressed = new MemoryStream();
            //compressed.WriteByte(10);
            AMFSerializer amfSerializer = new FluorineFx.IO.AMFSerializer(compressed);
            amfSerializer.UseLegacyCollection = false;
            amfSerializer.WriteAMF3Data(tmp);
            byte[] test = compressed.ToArray();
            return test;
        }

        byte[] Compress(byte[] uncompressed)
        {
            MemoryStream outStream = new MemoryStream();
            outStream.Capacity = 4096;
            ComponentAce.Compression.Libs.zlib.ZOutputStream test2 = new ComponentAce.Compression.Libs.zlib.ZOutputStream(outStream, ComponentAce.Compression.Libs.zlib.zlibConst.Z_DEFAULT_COMPRESSION);
            test2.FlushMode = 4;
            test2.Write(uncompressed, 0, uncompressed.Length);
            byte[] whitereq2;
            whitereq2 = outStream.ToArray();
            return whitereq2;
        }

        private Packet BuildTcpPacket()
        {
            EthernetLayer ethernetLayer = new EthernetLayer
            {
                Source = new MacAddress("60:6C:66:6B:01:6B"),
                Destination = new MacAddress("68:76:4f:fe:b4:9f"),
                EtherType = EthernetType.None, // Will be filled automatically.
            };

            IpV4Layer ipV4Layer = new IpV4Layer
            {
                //Source = new IpV4Address("192.168.1.2"),
                Source = new IpV4Address("192.168.43.197"),
                CurrentDestination = new IpV4Address("50.16.190.195"),
                Fragmentation = new IpV4Fragmentation(IpV4FragmentationOptions.DoNotFragment, 0),
                HeaderChecksum = null, // Will be filled automatically.
                Identification = (ushort)(LastIdent + 1),
                Options = IpV4Options.None,
                Protocol = null, // Will be filled automatically.
                Ttl = (byte)Convert.ToInt16(128),
                TypeOfService = 0,
            };


            // flag fun here later
            TcpLayer tcpLayer = new TcpLayer();
            tcpLayer.SourcePort = (ushort)sourceport;
            tcpLayer.DestinationPort = (ushort)6100;
            tcpLayer.Checksum = null;// Will be filled automatically.
            tcpLayer.SequenceNumber = Convert.ToUInt32(LastSequenceNumber);
            tcpLayer.AcknowledgmentNumber = Convert.ToUInt32(LastAcknowledgmentNumber);

            tcpLayer.ControlBits = TcpControlBits.Push | TcpControlBits.Acknowledgment;


            tcpLayer.Window = (ushort)Convert.ToUInt16(4261);
            tcpLayer.UrgentPointer = 0;
            tcpLayer.Options = TcpOptions.None;

            Dictionary<string, object> tmp = DecodeCommand(uncompressedWiteReq);

            int cc = (int)tmp["cmdId"];
            tmp["cmdId"] = cmdId + 1;
            cmdId++;
            byte[] test = EncodeCommand(tmp);
            for (int i = 0; i < uncompressedWiteReq.Length; i++)
            {
                if (test[i] != uncompressedWiteReq[i])
                {
                    i = i;
                }
            }


            Dictionary<string, object> tmp2 = DecodeCommand(test);


            //uncompressedWiteReq[10] = (byte)(cmdId+1);

            byte[] whitereq2 = Compress(test);
            byte[] whitereq3 = new byte[whitereq2.Length + 4];
            for (int i = 0; i < whitereq2.Length; i++)
            {
                whitereq3[i + 4] = whitereq2[i];
            }
            whitereq3[3] = (byte)whitereq2.Length;

            PayloadLayer payloadLayer = new PayloadLayer
            {

                Data = new Datagram(whitereq3),
            };

            PacketBuilder builder = new PacketBuilder(ethernetLayer, ipV4Layer, tcpLayer, payloadLayer);


            messageSent = true;
            return builder.Build(DateTime.Now);
        }
        private Packet BuildAckTcpPacket()
        {
            EthernetLayer ethernetLayer = new EthernetLayer
            {
                Source = new MacAddress("60:6C:66:6B:01:6B"),
                Destination = new MacAddress("68:76:4f:fe:b4:9f"),
                EtherType = EthernetType.None, // Will be filled automatically.
            };

            IpV4Layer ipV4Layer = new IpV4Layer
            {
                //Source = new IpV4Address("192.168.1.2"),
                Source = new IpV4Address("192.168.43.197"),
                CurrentDestination = new IpV4Address("50.16.190.195"),
                Fragmentation = new IpV4Fragmentation(IpV4FragmentationOptions.DoNotFragment, 0),
                HeaderChecksum = null, // Will be filled automatically.
                Identification = (ushort)(LastIdent + 1),
                Options = IpV4Options.None,
                Protocol = null, // Will be filled automatically.
                Ttl = (byte)Convert.ToInt16(128),
                TypeOfService = 0,
            };


            // flag fun here later
            TcpLayer tcpLayer = new TcpLayer();
            tcpLayer.SourcePort = (ushort)sourceport;
            tcpLayer.DestinationPort = (ushort)6100;
            tcpLayer.Checksum = null;// Will be filled automatically.
            tcpLayer.SequenceNumber = Convert.ToUInt32(LastSequenceNumber);
            tcpLayer.AcknowledgmentNumber = Convert.ToUInt32(LastAcknowledgmentNumber);

            tcpLayer.ControlBits = TcpControlBits.Acknowledgment;


            tcpLayer.Window = (ushort)Convert.ToUInt16(4261);
            tcpLayer.UrgentPointer = 0;
            tcpLayer.Options = TcpOptions.None;

            PayloadLayer payloadLayer = new PayloadLayer
            {

                Data = new Datagram(new byte[0]),
            };

            PacketBuilder builder = new PacketBuilder(ethernetLayer, ipV4Layer, tcpLayer, payloadLayer);


            messageSent = true;
            return builder.Build(DateTime.Now);
        }

        public  void sendACK()
        {
            Packet test = BuildAckTcpPacket();
            communicator.SendPacket(test);
        }

    }
}
