using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.IO;
using System.Xml;

namespace Kamacho.DNF.AMF
{
	public class AMFReader : BinaryReader
	{
		private AMFEnvelope _envelope;
		private DateTime _groundZero = DateTime.Parse("1/1/1970", null, System.Globalization.DateTimeStyles.AssumeUniversal & System.Globalization.DateTimeStyles.AdjustToUniversal);
		private Dictionary<int,AMFData> _references;

		public AMFReader(Stream stream) : base(stream) { }

		public AMFEnvelope ReadRequest()
		{
			_envelope = new AMFEnvelope();

			ProcessRequest();

			return _envelope;
		}

		private void ProcessRequest()
		{
			_envelope.Version = ReadByte();
			_envelope.ClientType = (AMFClientType)ReadByte();

			ushort headerCount = ReadUInt16();
			if (headerCount > 0)
				ProcessHeaders(headerCount);

			ushort bodyCount = ReadUInt16();
			if (bodyCount > 0)
				ProcessBodies(bodyCount);
		}

		private void ProcessHeaders(ushort headerCount)
		{
			for (int i = 0; i < headerCount; i++)
			{
				_references = new Dictionary<int, AMFData>();
				AMFHeader header = new AMFHeader();
				header.Name = ReadUTF();
				header.MustUnderstand = ReadBoolean();

				uint headerLength = ReadUInt32();

				header.Value = ReadAMFData();

				_envelope.Headers.Add(header);
			}
		}

		private void ProcessBodies(ushort bodyCount)
		{
			for (int i = 0; i < bodyCount; i++)
			{
				_references = new Dictionary<int, AMFData>();
				AMFBody body = new AMFBody();
				body.Target = ReadUTF();
				body.ResponseId = ReadUTF();

				uint bodyLength = ReadUInt32();

				body.Value = ReadAMFData();

				_envelope.Bodies.Add(body);
			}
		}


		/* special routines for handling things the base class doesn't do so well */

		private string ReadUTF()
		{
			//first 2 bytes give us the length;
			ushort length = ReadUInt16();

			if (length == 0)
				return string.Empty;

			byte[] bytes = new byte[length];
			Read(bytes, 0, length);
			return Encoding.UTF8.GetString(bytes);
		}

		private string ReadLongUTF()
		{
			uint length = ReadUInt32();
			if (length == 0)
				return string.Empty;

			byte[] bytes = new byte[length];
			Read(bytes, 0, Convert.ToInt32(length));
			return Encoding.UTF8.GetString(bytes);
		}

		public override ushort ReadUInt16()
		{
			return BitConverter.ToUInt16(ReadBackwards(2), 0);
		}

		public override uint ReadUInt32()
		{
			return BitConverter.ToUInt32(ReadBackwards(4), 0);
		}

		public override double ReadDouble()
		{
			return BitConverter.ToDouble(ReadBackwards(8), 0);
		}

		private byte[] ReadBackwards(int numBytes)
		{
			byte[] bytes = new byte[numBytes];
			for (int i = numBytes - 1; i >= 0; --i)
			{
				bytes[i] = ReadByte();
			}

			return bytes;
		}


		//look at the type code to determine what we are dealing with
		private AMFData ReadAMFData()
		{
			AMFDataType dataType = (AMFDataType)ReadByte();

			return ParseAMFDataForType(dataType);
		}

		private AMFData ParseAMFDataForType(AMFDataType dataType)
		{
			AMFData data = new AMFData();
			data.DataType = dataType;

			switch (dataType)
			{
				case AMFDataType.AMF3:
					throw new Exception("Flex AMF3 is not supported");

				case AMFDataType.Array:
					data.Data = ReadArrayList();
					if(data.Data != null)
						_references[_references.Count] = data;
					break;

				case AMFDataType.Boolean:
					data.Data = ReadBoolean();
					break;

				case AMFDataType.Date:
					
					double millisecondsFromGroundZero = ReadDouble();
					DateTime adjusted = _groundZero.AddMilliseconds(millisecondsFromGroundZero);

                    data = new AMFDateData();
                    data.DataType = dataType;
                    data.Data = adjusted;


					//read the timezone 
                    //comes in as minutes off of gmt
                    int tzOffset = Convert.ToInt32(ReadUInt16());
                    if (tzOffset > 720) //per AMF anything over 12 hours is subtracted from 2^16
                        tzOffset = (65536 - tzOffset) * -1;

                    int totalOffset = tzOffset * 60000 * -1; //gives us total milliseconds offset

                    //use the offset to add milliseconds to the date
                    //adjusted.AddMilliseconds(totalOffset)
                    ((AMFDateData)data).TimezoneOffset = totalOffset;
					if (adjusted == DateTime.MinValue)
						((AMFDateData)data).ClientDate = DateTime.MinValue;
					else 
						((AMFDateData)data).ClientDate = adjusted.AddMilliseconds(totalOffset);

					//now we need to set the actual data to be represented
					//as a date for the server timezone
					data.Data = DateTime.Parse(data.Data.ToString(), null, System.Globalization.DateTimeStyles.AssumeUniversal);

					break;

				case AMFDataType.LongString:
					data.Data = ReadLongUTF();
					break;

				case AMFDataType.MixedArray:
					data.Data = ReadMixedArray();
					if (data.Data != null)
						_references[_references.Count] = data;
					break;

				
				case AMFDataType.Number:
					data.Data = ReadDouble();
					break;

				case AMFDataType.Object:
					data.Data = ReadActionScriptObject(false);
					if (data.Data != null)
						_references[_references.Count] = data;
					break;


				case AMFDataType.Reference:
					int referenceCounter = Convert.ToInt32(ReadUInt16()) - 1;
					if (!_references.ContainsKey(referenceCounter))
						return null;
					else
						data = _references[referenceCounter];
					break;

				case AMFDataType.String:
					data.Data = ReadUTF();
					break;

				case AMFDataType.TypedObject:
					data.Data = ReadActionScriptObject(true);
					if (data.Data != null)
						_references[_references.Count] = data;
					break;

				case AMFDataType.Xml:
					string xml = ReadLongUTF();
					XmlDocument doc = new XmlDocument();
					doc.LoadXml(xml);
					data.Data = doc;
					break;
			}

			return data;
		}

		private object ReadActionScriptObject(bool typed)
		{
			ActionScriptObject aso = new ActionScriptObject();

			if (typed)
				aso.TypeName = ReadUTF();

			Dictionary<string, object> values = aso.Properties;

			//get the first key
			string key = ReadUTF();
			//get the first type
			AMFDataType dataType = (AMFDataType)ReadByte();

			while (dataType != AMFDataType.EndOfObject)
			{
				values[key] = ParseAMFDataForType(dataType);

				key = ReadUTF();
				dataType = (AMFDataType)ReadByte();
			}

			return aso;
		}

		private ArrayList ReadArrayList()
		{
			//get the length
			uint length = ReadUInt32();
			ArrayList list = new ArrayList();

			for (uint i = 0; i < length; i++)
			{
				object value = ReadAMFData();
				if (value != null  )
				{
					list.Add(value);
				}
			}

			return list;
		}

		private Dictionary<string, object> ReadMixedArray()
		{
			uint highestIndex = ReadUInt32(); //doesn't matter

			Dictionary<string, object> values = new Dictionary<string, object>();

			//get the first key
			string key = ReadUTF();
			//get the first type
			AMFDataType dataType = (AMFDataType)ReadByte();

			while (dataType != AMFDataType.EndOfObject)
			{
				values[key] = ParseAMFDataForType(dataType);

				key = ReadUTF();
				dataType = (AMFDataType)ReadByte();
			}

			return values;
		}
	}
}
