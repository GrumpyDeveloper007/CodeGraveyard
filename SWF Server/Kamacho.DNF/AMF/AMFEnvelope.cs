using System;
using System.Collections.Generic;
using System.Text;

namespace Kamacho.DNF.AMF
{
	public class AMFEnvelope
	{
		public byte Version;
		public AMFClientType ClientType;

		public List<AMFHeader> Headers = new List<AMFHeader>();
		public List<AMFBody> Bodies = new List<AMFBody>();
	}
}
