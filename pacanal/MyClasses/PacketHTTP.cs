using System;
using System.Windows.Forms;

namespace MyClasses
{

	public class PacketHTTP
	{

		public struct PACKET_HTTP
		{
			public string [] Contents;
		}


		public PacketHTTP()
		{

		}


		public static bool Parser( ref TreeNodeCollection mNode, 
			byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , bool DisplayData )
		{
			TreeNode mNodex;
			string Tmp = "";
			int Size = 0;
			int i = 0;
			char [] seperator = new char[2];
			PACKET_HTTP PHttp;

			seperator[0] = (char) 13;
			seperator[1] = (char) 10;

			Size = PacketData.GetLength(0) - Index;

			mNodex = new TreeNode();
			mNodex.Text = "HTTP ( Hyper Text Transfer Protocol )";
			Function.SetPosition( ref mNodex , Index , PacketData.Length - Index , true );
	
			try
			{
				for( i = 0; i < Size; i ++ )
				{
					if( ( PacketData[ Index ]  > 31 ) | 
						( PacketData[ Index ] < 129 ) | 
						( PacketData[ Index ] == 13 ) | 
						( PacketData[ Index ] == 10 ) )
						Tmp += (char) PacketData[ Index ];
					else
						Tmp += " ";

					Index++;
				}
				
				PHttp.Contents = Tmp.Split( seperator );

				if( DisplayData )
				{
					for( i = 0; i < PHttp.Contents.GetLength(0); i ++ )
					{
						Tmp = (string) PHttp.Contents.GetValue( i );
						Tmp = Tmp.Trim();
						if( Tmp != "" )
							mNodex.Nodes.Add( Tmp + "\\r\\n" );
					}
				}
				else
				{
					mNodex.Nodes.Add("Continutiation Message");
				}
				
				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "HTTP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = PHttp.Contents[0];

				mNode.Add( mNodex );
				
			}
			catch( Exception Ex )
			{
				mNode.Add( mNodex );
				Tmp = "[ Malformed HTTP packet. Remaining bytes don't fit an HTTP packet. Possibly due to bad decoding ]";
				mNode.Add( Tmp );
				Tmp = "[ Exception raised is <" + Ex.GetType().ToString() + "> at packet index <" + Index.ToString() + "> ]";
				mNode.Add( Tmp );
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed HTTP packet. Remaining bytes don't fit an HTTP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}


		public static bool Parser( byte [] PacketData , 
			ref int Index , 
			ref ListViewItem LItem , bool DisplayData )
		{
			string Tmp = "";
			int Size = 0;
			int i = 0;
			char [] seperator = new char[2];
			PACKET_HTTP PHttp;

			seperator[0] = (char) 13;
			seperator[1] = (char) 10;

			Size = PacketData.GetLength(0) - Index;

			try
			{
				for( i = 0; i < Size; i ++ )
				{
					if( ( PacketData[ Index ]  > 31 ) | 
						( PacketData[ Index ] < 129 ) | 
						( PacketData[ Index ] == 13 ) | 
						( PacketData[ Index ] == 10 ) )
						Tmp += (char) PacketData[ Index ];
					else
						Tmp += " ";

					Index++;
				}
				
				PHttp.Contents = Tmp.Split( seperator );

				LItem.SubItems[ Const.LIST_VIEW_PROTOCOL_INDEX ].Text = "HTTP";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = PHttp.Contents[0];

			}
			catch
			{
				Tmp = "[ Malformed HTTP packet. Remaining bytes don't fit an HTTP packet. Possibly due to bad decoding ]";
				LItem.SubItems[ Const.LIST_VIEW_INFO_INDEX ].Text = "[ Malformed HTTP packet. Remaining bytes don't fit an HTTP packet. Possibly due to bad decoding ]";

				return false;
			}

			return true;

		}

	}
}
