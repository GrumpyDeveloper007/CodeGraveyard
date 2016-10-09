using System;
using System.Collections.Generic;
using System.Text;

namespace Kamacho.DNF.AMF
{
	public class ActionScriptObject
	{
		public string TypeName = string.Empty;
		public Dictionary<string, object> Properties = new Dictionary<string, object>();

		public void AddProperty(string name, AMFDataType type, object value)
		{
			AMFData data = new AMFData(type, value);
			Properties[name] = data;
		}
	}
}
