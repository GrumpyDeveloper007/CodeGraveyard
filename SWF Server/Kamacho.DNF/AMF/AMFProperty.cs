using System;
using System.Collections.Generic;
using System.Text;

namespace Kamacho.DNF.AMF
{
	[AttributeUsage(AttributeTargets.Field | AttributeTargets.Property)]
	public class AMFProperty : Attribute
	{
		public AMFDataType ActionScriptDataType;
		public string Name;

		public AMFProperty(AMFDataType type, string name)
		{
			ActionScriptDataType = type;
			Name = name;

			switch (type)
			{
				case AMFDataType.AMF3:
				case AMFDataType.EndOfObject:
				case AMFDataType.Movie:
				case AMFDataType.Null:
				case AMFDataType.Object:
				case AMFDataType.Recordset:
				case AMFDataType.Reference:
				case AMFDataType.TypedObject:
				case AMFDataType.Undefined:
				case AMFDataType.Unsupported:
					throw new Exception("The AMFDataType specified [" + type.ToString() + "] for [" + name + "] is not allowed for return to flex applications.");
			}
		}
	}
}
