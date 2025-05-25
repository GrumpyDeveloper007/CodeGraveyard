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
using System.Xml;
using System.Collections;

namespace FluorineFx.Messaging.Config
{
    /// <summary>
    /// The flex-client element of the services configuration file.
    /// </summary>
    public sealed class FlexClientSettings
    {
        int _timeoutMinutes = 0;//20;

        /// <summary>
        /// Gets or sets the number of minutes before an idle FlexClient is timed out.
        /// </summary>
        public int TimeoutMinutes
        {
            get { return _timeoutMinutes; }
            set { _timeoutMinutes = value; }
        }

        internal FlexClientSettings()
		{
		}

        internal FlexClientSettings(XmlNode flexClientNode)
		{
            XmlNode timeoutNode = flexClientNode.SelectSingleNode("timeout-minutes");
            if (timeoutNode != null)
			{
                _timeoutMinutes = Convert.ToInt32(timeoutNode.InnerXml);
			}
		}
    }
}
