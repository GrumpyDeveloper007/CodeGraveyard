using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using System.Collections;
using System.Reflection;

namespace Kamacho.DNF.AMF
{
	public class AMFWriter : BinaryWriter
	{
		private AMFEnvelope _envelope;
		private DateTime _groundZero = DateTime.Parse("1/1/1970", null, System.Globalization.DateTimeStyles.AssumeUniversal & System.Globalization.DateTimeStyles.AdjustToUniversal);
		private DateTime _localGroundZero = DateTime.Parse("1/1/1970");


		public AMFWriter(Stream output, AMFEnvelope envelope)
			: base(output)
		{
			_envelope = envelope;
		}

		public void WriteResponse()
		{
			//output the result to Flex
			Write(_envelope.Version);
			Write((byte)_envelope.ClientType);
			Write(Convert.ToUInt16(_envelope.Headers.Count));

			foreach (AMFHeader header in _envelope.Headers)
			{
				WriteUTF(header.Name);
				Write(header.MustUnderstand);
				Write(-1);
				WriteAMFData(header.Value.DataType, header.Value.Data);
			}

			Write(Convert.ToUInt16(_envelope.Bodies.Count));

			foreach (AMFBody body in _envelope.Bodies)
			{
				WriteUTF(body.ResponseId + "/onResult");
				WriteUTF("null");
				Write(-1);

				if (body.ReturnValue == null)
				{
					Write((byte)AMFDataType.Null);
				}
				else
				{
					//is this AMFDATA
					if (body.ReturnValue is AMFData)
					{
						AMFData amfData = body.ReturnValue as AMFData;
						WriteAMFData(amfData.DataType, amfData.Data);
					}
					else
						ProcessUnknownObject(body.ReturnValue);
				}
			}
		}

		private void ProcessUnknownObject(object data)
		{
            //if no data, then get out
            if (data == null)
                return;

			//could be anything, but we are going to send it back
			//as a typed object
			Type t = data.GetType();
			
			object[] attributes = t.GetCustomAttributes(true);
			bool ok = false;

			ActionScriptObject aso = new ActionScriptObject();

			if (attributes != null)
			{
				foreach (Attribute attribute in attributes)
				{
					if (attribute is AMFEnabled)
					{
						ok = true;
						aso.TypeName = ((AMFEnabled)attribute).ActionScriptTypeName;
						break;
					}
				}

				if (ok)
				{
					//get the properties and fields for this type and then we can get those attributes
					//that we need to export
					FieldInfo[] fields = t.GetFields();
					if (fields != null)
					{
						foreach (FieldInfo field in fields)
						{
							attributes = field.GetCustomAttributes(typeof(AMFProperty), true);
							if (attributes != null)
							{
								foreach (AMFProperty propertyAttribute in attributes)
								{
									string key = propertyAttribute.Name;
									AMFDataType propertyType = propertyAttribute.ActionScriptDataType;

									//get the value
									object propertyValue = field.GetValue(data);

									//save it
									AMFData amfData = new AMFData();
									amfData.DataType = propertyType;
									amfData.Data = propertyValue;
									aso.Properties[key] = amfData;
								}
							}
						}
					}

					//do the same thing for the props
					PropertyInfo[] properties = t.GetProperties();
					if (properties != null)
					{
						foreach (PropertyInfo property in properties)
						{
							attributes = property.GetCustomAttributes(typeof(AMFProperty), true);
							if (attributes != null)
							{
								foreach (AMFProperty propertyAttribute in attributes)
								{
									string key = propertyAttribute.Name;
									AMFDataType propertyType = propertyAttribute.ActionScriptDataType;

									//get the value

									object propertyValue = property.GetValue(data, null);

									//save it
									AMFData amfData = new AMFData();
									amfData.DataType = propertyType;
									amfData.Data = propertyValue;
									aso.Properties[key] = amfData;
								}
							}
						}
					}
				}
			}

			if (!ok)
			{
				if (data is ActionScriptObject)
					WriteActionScriptObject(data as ActionScriptObject);
                else if (data is int)
                {
                    Write((byte)AMFDataType.Number);
                    Write(Convert.ToDouble(data));
                }
                else
                    throw new Exception("Type returned for Flex was not marked as AMFEnabled: " + t.ToString());
			}
			else
				WriteActionScriptObject(aso);
		}

		private void WriteUTF(string value)
		{
			int length = (value == null) ? 0 : value.Length;
			Write(Convert.ToUInt16(length));
			if(length > 0)
				Write(Encoding.UTF8.GetBytes(value), 0, length);
		}

		private void WriteLongUTF(string value)
		{
			int length = (value == null) ? 0 : value.Length;
			Write(Convert.ToUInt32(length));
			if(length > 0)
				Write(Encoding.UTF8.GetBytes(value), 0, length);
		}

		private void WriteAMFData(AMFDataType dataType, object data)
		{
			switch (dataType)
			{
				case AMFDataType.AMF3:
				case AMFDataType.Movie:
				case AMFDataType.Null:
				case AMFDataType.Recordset:
				case AMFDataType.Reference:
				case AMFDataType.Undefined:
				case AMFDataType.Unsupported:
					Write((byte)AMFDataType.Null);
					break;
				case AMFDataType.Array:
					Write((byte)AMFDataType.Array);
					WriteArray((IList)data);
					break;
				case AMFDataType.Boolean:
					Write((byte)AMFDataType.Boolean);
					Write((bool)data);
					break;
				case AMFDataType.Date:
					Write((byte)AMFDataType.Date);
					DateTime date = ((DateTime)data).ToUniversalTime();
					TimeSpan millisecondsSinceGroundZero = date.Subtract(_groundZero);
					Write(millisecondsSinceGroundZero.TotalMilliseconds);
					
					//don't have the timezone, so we will just fake one
					Write(Convert.ToUInt16(0));
					break;		
				case AMFDataType.UTCDate: //treat date time as a UTC date
					Write((byte)AMFDataType.Date);
					DateTime localDate = ((DateTime)data);
					TimeSpan localMillisecondsSinceGroundZero = localDate.Subtract(_localGroundZero);
					Write(localMillisecondsSinceGroundZero.TotalMilliseconds);

					//don't have the timezone, so we will just fake one
					Write(Convert.ToUInt16(0));
					break;
				case AMFDataType.LongString:
					Write((byte)AMFDataType.LongString);
					WriteLongUTF((string)data);
					break;
				case AMFDataType.MixedArray:
					Write((byte)AMFDataType.MixedArray);
					WriteMixedArray(data as Dictionary<string, object>);
					break;
				case AMFDataType.Number:
					Write((byte)AMFDataType.Number);
					Write(Convert.ToDouble(data));
					break;
				case AMFDataType.Object:
					WriteActionScriptObject(data as ActionScriptObject);
					break;
				case AMFDataType.String:
					Write((byte)AMFDataType.String);
					WriteUTF((string)data);
					break;
                case AMFDataType.Guid:
                    Write((byte)AMFDataType.String);
                    WriteUTF(data.ToString());
                    break;
				case AMFDataType.TypedObject:
					WriteActionScriptObject(data as ActionScriptObject);
					break;
				case AMFDataType.Xml:
					Write((byte)AMFDataType.Xml);
					XmlDocument doc = data as XmlDocument;
					if (doc == null)
						WriteLongUTF(string.Empty);
					else
						WriteLongUTF(doc.OuterXml);
					break;
			}
		}

		private void WriteArray(IList data)
		{
			uint length = 0;
			if (data == null)
			{
				Write(length);
				return;
			}

			length = Convert.ToUInt32(data.Count);
			Write(length);
			for (int i = 0; i < data.Count; i++)
			{
				AMFData arrayData = data[i] as AMFData;
				if (arrayData != null)
					WriteAMFData(arrayData.DataType, arrayData.Data);
				else
				{
					if (data[i] == null)
						Write((byte)AMFDataType.Null);
					else
						ProcessUnknownObject(data[i]);
				}
			}
		}

		private void WriteActionScriptObject(ActionScriptObject aso)
		{
			if (aso.TypeName != string.Empty && aso.TypeName != null)
			{
				Write((byte)AMFDataType.TypedObject);
				WriteUTF(aso.TypeName);
			}
			else
				Write((byte)AMFDataType.Object);

			foreach (KeyValuePair<string,object> kvp in aso.Properties)
			{
				WriteUTF(kvp.Key);

				AMFData data = kvp.Value as AMFData;
				if (data == null)
					Write((byte)AMFDataType.Null);
				else
				{
					//this will allow us to have nested objects as properties
					//on our AMF objects
					if (data.DataType == AMFDataType.AMFEnabledObject)
					{	
						if(data.Data != null)
							ProcessUnknownObject(data.Data);
						else
							Write((byte)AMFDataType.Null);
					}
					else 
						WriteAMFData(data.DataType, data.Data);
				}
			}

			//write out the end record
			Write(Convert.ToUInt16(0));
			Write((byte)AMFDataType.EndOfObject);
		}

		private void WriteMixedArray(Dictionary<string, object> properties)
		{
			//always let them know we don't have any numeric indexes
			//this way it is all keyed as strings
			Write(Convert.ToUInt32(0));

			if (properties == null)
			{
				Write(Convert.ToUInt16(0));
				Write((byte)AMFDataType.EndOfObject);
				return;
			}

			foreach (KeyValuePair<string, object> kvp in properties)
			{
				WriteUTF(kvp.Key);

				AMFData data = kvp.Value as AMFData;
				if (data == null)
				{
					if (kvp.Value == null)
						Write((byte)AMFDataType.Null);
					else
						ProcessUnknownObject(kvp.Value);
				}
				else
					WriteAMFData(data.DataType, data.Data);
			}

			Write(Convert.ToUInt16(0));
			Write((byte)AMFDataType.EndOfObject);
		}

		public override void  Write(ushort value)
		{
			WriteBackwards(BitConverter.GetBytes(value));
		}

		public override void Write(uint value)
		{
			WriteBackwards(BitConverter.GetBytes(value));
		}

		public override void Write(double value)
		{
			WriteBackwards(BitConverter.GetBytes(value));
		}

		

		private void WriteBackwards(byte[] value)
		{
			for (int i = value.Length - 1; i >= 0; --i)
			{
				Write(value[i]);
			}
		}
	}
}
