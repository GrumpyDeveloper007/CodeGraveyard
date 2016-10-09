using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Xml;

namespace Kamacho.DNF.AMF
{
	public class AMFClientRequest
	{
		public string Command;
		public string Id;

		public AMFData Parameters;
        public AMFData[] ParameterList { get { return (this.Parameters == null) ? null : Parameters.Data as AMFData[]; } }

		public object Response;
		public List<AMFHeader> Headers;
        public AMFBody ParentBody;

        public int GetInt(int index) { return Convert.ToInt32(ParameterList[index].Data); }
        public short GetShort(int index) { return Convert.ToInt16(ParameterList[index].Data); }
        public long GetLong(int index) { return Convert.ToInt64(ParameterList[index].Data); }
        public decimal GetDecimal(int index) { return Convert.ToDecimal(ParameterList[index].Data); }

        public string GetString(int index) { return (string)ParameterList[index].Data; }
        public ActionScriptObject GetActionScriptObject(int index) { return (ActionScriptObject)ParameterList[index].Data; }

        public object GetTypedObject(int index, Type typeToReturn)
        {
            ActionScriptObject aso = GetActionScriptObject(index);
            return AMFDeserializer.Deserialize(aso, typeToReturn);
        }

        public ArrayList GetList(int index) { return ParameterList[index].Data as ArrayList; }

        public DateTime GetDate(int index) { return (DateTime)ParameterList[index].Data; }
        public DateTime GetDateAsEnteredOnClient(int index) { return ((AMFDateData)ParameterList[index].Data).ClientDate; }

        public XmlDocument GetXml(int index) { return ParameterList[index].Data as XmlDocument; }
        public Guid GetGuid(int index) { return (Guid)ParameterList[index].Data; }

	}
}
