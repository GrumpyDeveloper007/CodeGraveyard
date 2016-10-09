using System;
using System.Collections.Generic;
using System.Text;

namespace Kamacho.DNF.AMF
{
	public enum AMFDataType
	{
		Number = 0,
		Boolean = 1,
		String = 2,
		Object = 3,
		Movie = 4,
		Null = 5,
		Undefined = 6,
		Reference = 7,
		MixedArray = 8,
		EndOfObject = 9,
		Array = 10,
		Date = 11,
		LongString = 12,
		Unsupported = 13,
		Recordset = 14,
		Xml = 15,
		TypedObject = 16,
		AMF3 = 17,
		AMFEnabledObject = 18,
		UTCDate = 19,
        Guid = 20
	}
}
