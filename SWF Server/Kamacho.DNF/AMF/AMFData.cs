using System;
using System.Collections.Generic;
using System.Text;

namespace Kamacho.DNF.AMF
{
	public class AMFData
	{
		public AMFDataType DataType;
		public object Data;

        public AMFData()
        {
        }

        public AMFData(AMFDataType type, object data)
        {
            DataType = type;
            Data = data;
        }
	}
}
