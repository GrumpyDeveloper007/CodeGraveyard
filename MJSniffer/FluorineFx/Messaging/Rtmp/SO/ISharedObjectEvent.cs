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

namespace FluorineFx.Messaging.Rtmp.SO
{
	/// <summary>
	/// This type supports the Fluorine infrastructure and is not intended to be used directly from your code.
	/// </summary>
	public enum SharedObjectEventType 
	{
		Unknown = 0,
		SERVER_CONNECT,
		SERVER_DISCONNECT, 
		SERVER_SET_ATTRIBUTE, 
		SERVER_DELETE_ATTRIBUTE, 
		SERVER_SEND_MESSAGE, 
		CLIENT_CLEAR_DATA, 
		CLIENT_DELETE_ATTRIBUTE, 
		CLIENT_DELETE_DATA, 
		CLIENT_INITIAL_DATA, 
		CLIENT_STATUS, 
		CLIENT_UPDATE_DATA, 
		CLIENT_UPDATE_ATTRIBUTE, 
		CLIENT_SEND_MESSAGE
	};

	/// <summary>
	/// One update event for a shared object received through a connection.
	/// </summary>
	public interface ISharedObjectEvent
	{
		/// <summary>
		/// Gets the type of the event.
		/// </summary>
		SharedObjectEventType Type{ get; }
		/// <summary>
		/// Returns the key of the event.
		/// 
		/// Depending on the type this contains:
		/// <ul>
		/// <li>the attribute name to set for SET_ATTRIBUTE</li>
		/// <li>the attribute name to delete for DELETE_ATTRIBUTE</li>
		/// <li>the handler name to call for SEND_MESSAGE</li>
		/// </ul>
		/// In all other cases the key is <code>null</code>.
		/// </summary>
		string Key{ get; }
		/// <summary>
		/// Returns the value of the event.
		/// 
		/// Depending on the type this contains:
		/// <ul>
		/// <li>the attribute value to set for SET_ATTRIBUTE</li>
		/// <li>a list of parameters to pass to the handler for SEND_MESSAGE</li>
		/// </ul>
		/// In all other cases the value is <code>null</code>.
		/// </summary>
		object Value{ get; }
	}
}
