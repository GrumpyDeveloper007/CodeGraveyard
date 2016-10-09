using System;
using System.Collections.Generic;
using System.Text;

namespace Kamacho.DNF.AMF
{
	[AttributeUsage(AttributeTargets.Class)]
	public class AMFEnabled : Attribute
	{
		public string ActionScriptTypeName;

		public AMFEnabled(string typeName)
		{
			ActionScriptTypeName = typeName;
		}
	}
}
