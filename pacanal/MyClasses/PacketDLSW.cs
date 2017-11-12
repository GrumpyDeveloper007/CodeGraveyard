using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketDLSW
	{

		public struct PACKET_DLSW
		{
			public byte Version;
			public byte HeaderLength;
			public ushort MessageLength;
			public uint RemoteDataLinkCorrelator;
			public uint RemoteDLCPortId; // Data Link Control
			public ushort Reserved1;
			public byte MessageType;
			public byte FlowControlByte; // DLSw information message ends here
			//DLSw control message continues
			public byte ProtocolId;
			public byte HeaderNumber;
			public ushort Reserved2;
			public byte LargestFrameSize;
			public byte SSPFlags;
			public byte CircuitPriority;
			public byte OldMessageType;
			public string TargetMACAddress; // 6 bytes
			public string OriginMACAddress; // 6 bytes
			public byte OriginLSAP; // Link Service Access Point
			public byte TargetLSAP;
			public byte FrameDirector;
			public byte Reserved3;
			public ushort Reserved5;
			public ushort DLCPortId;
			public uint X; // ?????
			public uint OriginDLCPortId;
			public uint OriginTransporter;
			public uint TargetDataLink;

			public ushort DlcHeaderLength;
			public uint OriginDLC;
			public uint TargetDLCPortId;
			public uint TargetTransportId;
			public uint Reserved6;

		}

		public PacketDLSW()
		{
		}


		private static void ParseCapEx( ref TreeNodeCollection mNode, 
			byte [] PacketData , ref int Index,
			ref ListViewItem LItem )
		{
			/*mlen=tvb_get_ntohs(tvb,0);
			gdsid=tvb_get_ntohs(tvb,2);
			proto_tree_add_text (tree,tvb,0,2,"Capabilities Length =  %d",mlen) ;
			proto_tree_add_text (tree,tvb,2,2,"%s",val_to_str( gdsid, dlsw_gds_vals, "Invalid GDS ID"));
			proto_item_append_text(ti2," - %s",val_to_str( gdsid, dlsw_gds_vals, "Invalid GDS ID"));
			switch (gdsid) 
			{
				case Const.DLSW_GDSID_ACK:
					break;
				case Const.DLSW_GDSID_REF:
					proto_tree_add_text (tree,tvb,4,2,"Erorr pointer =  %d",tvb_get_ntohs(tvb,4));
					proto_tree_add_text (tree,tvb,6,2,"Erorr cause = %s",
						val_to_str(tvb_get_ntohs(tvb,6), dlsw_refuse_vals, "Unknown refuse cause"));
					break;
				case Const.DLSW_GDSID_SEND:
					while (offset < mlen)
					{
						vlen=tvb_get_guint8(tvb,offset);
						vtype=tvb_get_guint8(tvb,offset+1);
						ti=proto_tree_add_text (tree,tvb,offset,vlen,"%s",
							val_to_str(vtype,dlsw_vector_vals,"Unknown vector type"));
						dlsw_vector_tree = proto_item_add_subtree(ti, ett_dlsw_vector);
						proto_tree_add_text (dlsw_vector_tree,tvb,offset,1,  "Vector Length = %d",vlen);
						proto_tree_add_text (dlsw_vector_tree,tvb,offset+1,1,"Vector Type   = %s (0x%02x)",
							val_to_str(vtype,dlsw_vector_vals,"Unknown vector type"),vtype);
						switch (vtype)
						{
							case 0x81:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"OUI = 0x%06x",tvb_get_ntoh24(tvb,offset+2));
								break;
							case 0x82:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"DLSw Version = %d.%d",tvb_get_guint8(tvb,offset+2),tvb_get_guint8(tvb,offset+3));
								break;
							case 0x83:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"Initial Pacing Window = %d",tvb_get_ntohs(tvb,offset+2));
								break;
							case 0x84:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"Version String = %s",tvb_format_text(tvb,offset+2,vlen-2));
								break;
							case 0x85:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"MAC Address Exclusivity = %s",tvb_get_guint8(tvb,offset+2)==1?"On":"Off");
								break;
							case 0x86:
								while (i<vlen-2)
								{
									sap=tvb_get_guint8(tvb,offset+2+i);
									proto_tree_add_text (dlsw_vector_tree,tvb,offset+2+i,1,
										"SAP List Support = 0x%x0=%s 0x%x2=%s 0x%x4=%s 0x%x6=%s 0x%x8=%s 0x%xa=%s 0x%xc=%s 0x%xe=%s",
										i,sap&0x80?"on ":"off",i,sap&0x40?"on ":"off",i,sap&0x20?"on ":"off",i,sap&0x10?"on ":"off",
										i,sap&0x08?"on ":"off",i,sap&0x04?"on ":"off",i,sap&0x02?"on ":"off",i,sap&0x01?"on ":"off");
									i++;
								}
								break;
							case 0x87:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"TCP connections  = %d",tvb_get_guint8(tvb,offset+2));
								break;
							case 0x88:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"NetBIOS Name Exclusivity = %s",tvb_get_guint8(tvb,offset+2)==1?"On":"Off");
								break;
							case 0x89:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"MAC Address List = %s / %s",tvb_bytes_to_str(tvb,offset+2,6)
									,tvb_bytes_to_str(tvb,offset+8,6));
								break;
							case 0x8a:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,"NetBIOS name = %s", tvb_format_text(tvb,offset+2,vlen-2));
								break;
							case 0x8b:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"Vendor OUI = 0x%06x",tvb_get_ntoh24(tvb,offset+2));
								break;
							case 0x8c:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,
									"Multicast Version Number = %d",tvb_get_guint8(tvb,offset+2));
								break;
							default:
								proto_tree_add_text (dlsw_vector_tree,tvb,offset+2,vlen-2,"Vector Data = ???");
						}
						offset+=vlen;
					};
					break;
				default:
					proto_tree_add_text (tree,tvb,4,mlen - 4,"Unknown data");
			}*/

		}

		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , ref int Index,
			ref ListViewItem LItem )
		{
			TreeNode mNodex;
			TreeNode mNode1;
			string Tmp = "";
			int kk = 0, kkk = 0;
			PACKET_DLSW PDlsw;
			byte byteValue = 0;

			mNodex = new TreeNode();
			mNodex.Text = "DLSw ( Data Link Switching )";
			kk = Index;

			PDlsw.DlcHeaderLength = 0;

			try
			{
				mNode1 = new TreeNode();
				mNode1.Text = "DLSW HEADER";
				kkk = Index;

				PDlsw.Version = PacketData[ Index ++ ];
				Tmp = "Version : " + Function.ReFormatString( PDlsw.Version , Const.GetDlswVersionString( PDlsw.Version ) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

				PDlsw.HeaderLength = PacketData[ Index ++ ];
				Tmp = "Header Length : " + Function.ReFormatString( PDlsw.HeaderLength , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );
			
				PDlsw.MessageLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Message Length : " + Function.ReFormatString( PDlsw.MessageLength , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PDlsw.RemoteDataLinkCorrelator = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Remote DLC : " + Function.ReFormatString( PDlsw.RemoteDataLinkCorrelator , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

				PDlsw.RemoteDLCPortId = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Remote DLC PID : " + Function.ReFormatString( PDlsw.HeaderLength , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

				PDlsw.Reserved1 = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
				Tmp = "Reserved : " + Function.ReFormatString( PDlsw.HeaderLength , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

				PDlsw.MessageType = PacketData[ Index ++ ];
				Tmp = "Message Tpye : " + Function.ReFormatString( PDlsw.MessageType , Const.GetDlswTypeString( PDlsw.MessageType ) );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

				PDlsw.FlowControlByte = PacketData[ Index ++ ];
				Tmp = "Flow Control Byte : " + Function.ReFormatString( PDlsw.FlowControlByte , null );
				mNode1.Nodes.Add( Tmp );
				Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );


				if( PDlsw.HeaderLength != Const.DLSW_INFO_HEADER )
				{
					PDlsw.ProtocolId = PacketData[ Index ++ ];
					Tmp = "Protocol ID : " + Function.ReFormatString( PDlsw.ProtocolId , null );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

					PDlsw.HeaderNumber = PacketData[ Index ++ ];
					Tmp = "Header Number : " + Function.ReFormatString( PDlsw.HeaderNumber , null );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

					PDlsw.Reserved2 = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
					Tmp = "Reserved : " + Function.ReFormatString( PDlsw.Reserved2 , null );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

					PDlsw.LargestFrameSize = PacketData[ Index ++ ];
					Tmp = "Largest Frame Size : " + Function.ReFormatString( PDlsw.LargestFrameSize , null );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

					PDlsw.SSPFlags = PacketData[ Index ++ ];
					Tmp = "SSP Flags : " + Function.ReFormatString( PDlsw.SSPFlags , null );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

					PDlsw.CircuitPriority = PacketData[ Index ++ ];
					Tmp = "Circuit Priority : " + Function.ReFormatString( PDlsw.CircuitPriority , Const.GetDlswPriorityString( PDlsw.CircuitPriority ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

					PDlsw.OldMessageType = PacketData[ Index ++ ];
					Tmp = "Old Message Type : " + Function.ReFormatString( PDlsw.OldMessageType , Const.GetDlswTypeString( PDlsw.OldMessageType ) );
					mNode1.Nodes.Add( Tmp );
					Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

					if( PDlsw.MessageType == Const.DLSW_CAP_EXCHANGE )
					{
						//PDlsw.ProtocolId = PacketData[ Index ++ ];
						Index += 14;
						Tmp = "Not used for CapEx" ;
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 14 , 14 , false );

						PDlsw.FrameDirector = PacketData[ Index ++ ];
						Tmp = "Frame Direction : " + Function.ReFormatString( PDlsw.FrameDirector , PDlsw.FrameDirector == 1 ? "Capabilities request":"Capabilities response" );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

						//PDlsw.ProtocolId = PacketData[ Index ++ ];
						Index += 33;
						Tmp = "Not used for CapEx";
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 33 , 33 , false );
					}
					else
					{
						PDlsw.TargetMACAddress = Function.GetMACAddress( PacketData , ref Index );
						Tmp = "Target MAC Address : " + PDlsw.TargetMACAddress;
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 6 , 6 , false );

						PDlsw.OriginMACAddress = Function.GetMACAddress( PacketData , ref Index );
						Tmp = "Origin MAC Address : " + PDlsw.OriginMACAddress;
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 6 , 6 , false );

						PDlsw.OriginLSAP = PacketData[ Index ++ ];
						Tmp = "Origin Link SAP : " + Function.ReFormatString( PDlsw.OriginLSAP , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

						PDlsw.TargetLSAP = PacketData[ Index ++ ];
						Tmp = "Target Link SAP : " + Function.ReFormatString( PDlsw.TargetLSAP , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

						PDlsw.FrameDirector = PacketData[ Index ++ ];
						Tmp = "Frame Direction : " + Function.ReFormatString( PDlsw.FrameDirector , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

						PDlsw.Reserved3 = PacketData[ Index ++ ];
						Tmp = "Reserved : " + Function.ReFormatString( PDlsw.Reserved3 , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 1 , 1 , false );

						PDlsw.Reserved5 = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Reserved : " + Function.ReFormatString( PDlsw.Reserved5 , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

						PDlsw.DlcHeaderLength = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "DLC Header Length : " + Function.ReFormatString( PDlsw.DlcHeaderLength , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 2 , 2 , false );

						PDlsw.OriginDLCPortId = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Reserved : " + Function.ReFormatString( PDlsw.OriginDLCPortId , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

						PDlsw.OriginDLC = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Origin DLC : " + Function.ReFormatString( PDlsw.OriginDLC , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

						PDlsw.OriginTransporter = Function.Get2Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Origin Transport ID : " + Function.ReFormatString( PDlsw.OriginTransporter , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

						PDlsw.TargetDLCPortId = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Target DLC Port ID : " + Function.ReFormatString( PDlsw.TargetDLCPortId , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

						PDlsw.TargetDataLink = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Target DLC : " + Function.ReFormatString( PDlsw.TargetDataLink , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

						PDlsw.TargetTransportId = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Target Transport ID : " + Function.ReFormatString( PDlsw.TargetTransportId , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

						PDlsw.Reserved6 = Function.Get4Bytes( PacketData , ref Index , Const.NORMAL );
						Tmp = "Reserved : " + Function.ReFormatString( PDlsw.Reserved6 , null );
						mNode1.Nodes.Add( Tmp );
						Function.SetPosition( ref mNode1 , Index - 4 , 4 , false );

					}

				}

				Function.SetPosition( ref mNode1 , kk , Index - kk , false );
				mNodex.Nodes.Add( mNode1 );

				Tmp = "Dlsw Data ";
				mNode1.Nodes.Add( Tmp );

				switch( PDlsw.MessageType )
				{
					case Const.DLSW_CAP_EXCHANGE:
						ParseCapEx( ref mNode , PacketData , ref Index , ref LItem );
						break;
					case Const.DLSW_IFCM:
					case Const.DLSW_INFOFRAME:
					case Const.DLSW_KEEPALIVE:
						Tmp = "Data ";
						mNode1.Nodes.Add( Tmp );
						break;

					default:
						if( PDlsw.DlcHeaderLength != 0 )
						{
							Index = PDlsw.HeaderLength;

							byteValue = PacketData[ Index ++ ];
							Tmp = "DLC Header - AC byte : " + Function.ReFormatString( byteValue , null );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

							byteValue = PacketData[ Index ++ ];
							Tmp = "DLC Header - FC byte : " + Function.ReFormatString( byteValue , null );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

							byteValue = PacketData[ Index ++ ];
							Tmp = "DLC Header - DA : " + Function.GetMACAddress( PacketData , ref Index );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 6 , 6 , false );

							Tmp = "DLC Header - SA : " + Function.GetMACAddress( PacketData , ref Index );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 6 , 6 , false );

							Tmp = "DLC Header - RIF : " + Function.GetString( PacketData , ref Index , 18 );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 18 , 18 , false );

							byteValue = PacketData[ Index ++ ];
							Tmp = "DLC Header - DSAP : " + Function.ReFormatString( byteValue , null );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

							byteValue = PacketData[ Index ++ ];
							Tmp = "DLC Header - SSAP : " + Function.ReFormatString( byteValue , null );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

							byteValue = PacketData[ Index ++ ];
							Tmp = "DLC Header - Ctrl : " + Function.ReFormatString( byteValue , null );
							mNodex.Nodes.Add( Tmp );
							Function.SetPosition( ref mNodex , Index - 1 , 1 , false );

						}

						Tmp = "Dlsw Data ";
						mNode1.Nodes.Add( Tmp );
						break;

				}


				Function.SetPosition( ref mNodex , kk , Index - kk , true );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "DLSw";
				Tmp = "DLSw " + PDlsw.Version.ToString() + " : " + Const.GetDlswVersionString( PDlsw.Version );
				Tmp += "," + PDlsw.MessageType.ToString() + " : " + Const.GetDlswTypeString( PDlsw.MessageType );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed DLSw packet. Remaining bytes don't fit an DLSw packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = Tmp;

				return false;
			}

			return true;

		}




	}
}
