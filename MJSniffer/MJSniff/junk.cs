using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MJsniffer
{
    class junk
    {
        private void test()
        {
            /*
if (enableLog)
{
    string rawData = Encoding.UTF8.GetString(dataBuffer, 0, dataLength2).Replace("\0", "");

    rawData = Encoding.UTF8.GetString(theImageDecompressed, 0, len).Replace("\0", "");
if (tmp["cmd"].ToString() == "createSoul" && outgoing)
{
    cmdId = int.Parse(tmp["cmdId"].ToString());
    inject. uncompressedWiteReq = new byte[len];
    for (int t = 0; t < len; t++)
    {
        inject.uncompressedWiteReq[t] = theImageDecompressed[t];
    }
}

    rawData = "";
    foreach (var item in tmp)
    {

        if (item.Value is Dictionary<string, object>)
        {
            rawData += item.Key + " {";
            Dictionary<string, object> subgroup = (Dictionary<string, object>)item.Value;
            foreach (var item2 in subgroup)
            {
                if (item2.Value is Dictionary<string, object>)
                {
                    Dictionary<string, object> datagroup = (Dictionary<string, object>)item2.Value;
                    foreach (var item3 in datagroup)
                    {
                        rawData += item3.Key + ":" + item3.Value.ToString() + ",";
                    }
                }
                else
                {
                    if (item2.Value != null)
                    {
                        rawData += item2.Key + ":" + item2.Value.ToString() + ",";
                    }
                }
            }
            rawData += "}";
        }
        else
        {
            rawData += item.Key + ":" + item.Value.ToString();
        }
        rawData += ",";
    }
    message = rawData + "\r\n";
                                 
}*/


            /*                    if (UInt16.Parse(tcpHeader.SourcePort) == 6100)
                   {
                        LastAcknowledgmentNumber = uint.Parse(tcpHeader.SequenceNumber);
                    }

                    if (UInt16.Parse(tcpHeader.DestinationPort) == 6100)
                    {
                        LastSequenceNumber = uint.Parse(tcpHeader.SequenceNumber);
                        if (tcpHeader.AcknowledgementNumber.Length > 0)
                        {
                            LastAcknowledgmentNumber = uint.Parse(tcpHeader.AcknowledgementNumber);
                        }

                        LastIdent = ushort.Parse(ipHeader.Identification);
                    }
                    UpdateSeq();
                    
                    SourceIP = ipHeader.SourceAddress.ToString();
                    
                    if (enableLog)
                    {
                        TreeNode tcpNode = nodeHelper.MakeTCPTreeNode(tcpHeader, LastSequenceNumber, LastAcknowledgmentNumber);
                        //rootNode.Nodes.Add(ipNode);
                        rootNode.Nodes.Add(tcpNode);


                        //If the port is equal to 53 then the underlying protocol is DNS
                        //Note: DNS can use either TCP or UDP thats why the check is done twice
                        if (tcpHeader.DestinationPort == "53" || tcpHeader.SourcePort == "53")
                        {
                            TreeNode dnsNode = nodeHelper.MakeDNSTreeNode(tcpHeader.Data, (int)tcpHeader.MessageLength);
                            rootNode.Nodes.Add(dnsNode);
                        }
                    }
                    */

        }
    }
}
