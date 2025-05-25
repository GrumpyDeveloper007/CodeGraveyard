/*
	FluorineFx open source library 
	Copyright (C) 2007 Zoltan Csibi, zoltan@TheSilentGroup.com, FluorineFx.com 
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/
using System;
using FluorineFx.Messaging.Api;
using FluorineFx.Messaging.Api.Event;

namespace FluorineFx.Messaging.Rtmp.Event
{
	/// <summary>
	/// This type supports the Fluorine infrastructure and is not intended to be used directly from your code.
	/// </summary>
    [CLSCompliant(false)]
    public sealed class ClientBW : BaseEvent
	{
		private int _bandwidth;
		private byte _value2;

		public ClientBW(int bandwidth, byte value2):base(EventType.STREAM_CONTROL)
		{
			_dataType = Constants.TypeClientBandwidth;
			_bandwidth = bandwidth;
			_value2 = value2;
		}

		public int Bandwidth
		{
			get{ return _bandwidth; }
			set{ _bandwidth = value; }
		}

		public byte Value2
		{
			get{ return _value2; }
			set{ _value2 = value; }
		}

		public override string ToString()
		{
			return "ClientBW: " + _bandwidth + " value2: " + _value2;
		}
	}
}
