using System;
using System.Collections.Generic;
using System.Text;

namespace Kamacho.DNF.AMF
{
	[AttributeUsage(AttributeTargets.Field | AttributeTargets.Property, AllowMultiple=true)]
	public class AMFArrayItem : Attribute
	{
		public string TypeName;
		public Type TargetType;

		public AMFArrayItem(string typeName, Type targetType)
		{
			TypeName = typeName;
			TargetType = targetType;
		}
	}
}
