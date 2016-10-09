using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Reflection;


namespace Kamacho.DNF.AMF
{
	public static class AMFDeserializer
	{
		public static object Deserialize(ActionScriptObject aso, Type type)
		{
			if (aso == null)
				return null;

			//create an instance of the type
			object rehydrated = Activator.CreateInstance(type);

			//now we have to go through all of the properties and attributes
			DeserializeProperties(aso, type, rehydrated);

			return rehydrated;
		}

		private static void DeserializeFields(ActionScriptObject aso, Type type, object instance)
		{
			//get the custom attributes of the object
			FieldInfo[] fields = type.GetFields();
			if (fields != null)
			{
				foreach (FieldInfo field in fields)
				{
					object[] attributes = field.GetCustomAttributes(typeof(AMFProperty), true);
					if (attributes != null)
					{
						foreach (AMFProperty propertyAttribute in attributes)
						{
							string key = propertyAttribute.Name;
							AMFDataType propertyType = propertyAttribute.ActionScriptDataType;

							//if we don't have let default value take over
							if (!aso.Properties.ContainsKey(key))
								continue;

							AMFData data = aso.Properties[key] as AMFData;

							if (data.Data == null)
								continue;

							switch (propertyType)
							{
								case AMFDataType.AMFEnabledObject:
									if (field.FieldType.Name == "Object")
										field.SetValue(instance, data.Data);
									else
										field.SetValue(instance, Deserialize(data.Data as ActionScriptObject, field.FieldType));
									break;
								case AMFDataType.Array:
									ArrayList al = data.Data as ArrayList;
									ArrayList alValues = new ArrayList();
									if (al != null && al.Count > 0)
									{
										object[] arrayItemAttributes = field.GetCustomAttributes(typeof(AMFArrayItem), true);

										Dictionary<string, Type> itemMap = new Dictionary<string, Type>();
										if (arrayItemAttributes != null)
										{
											foreach (AMFArrayItem arrayItemAttribute in arrayItemAttributes)
											{
												itemMap.Add(arrayItemAttribute.TypeName, arrayItemAttribute.TargetType);
											}
										}

										foreach (AMFData alData in al)
										{
											object dataValue = null;

											if (alData.Data is ActionScriptObject)
											{
												ActionScriptObject arrayItemASO = alData.Data as ActionScriptObject;
												if (itemMap.ContainsKey(arrayItemASO.TypeName))
													dataValue = GetArrayElementValue(alData, itemMap[arrayItemASO.TypeName]);
												else
													dataValue = GetArrayElementValue(alData, field.FieldType.GetElementType());
											}
											else
												dataValue = GetArrayElementValue(alData, field.FieldType.GetElementType());
											
											
											if(dataValue != null)
												alValues.Add(dataValue);
										}

										field.SetValue(instance, alValues.ToArray(field.FieldType.GetElementType()));
									}
									break;
								case AMFDataType.Boolean:
								case AMFDataType.LongString:
								case AMFDataType.String:
                                case AMFDataType.UTCDate:
                                case AMFDataType.Date:
									field.SetValue(instance, data.Data);
									break;
                                case AMFDataType.Guid:
                                    field.SetValue(instance, new Guid(data.Data.ToString()));
                                    break;
                                case AMFDataType.Number:
									switch (field.FieldType.Name)
									{
										case "Int32":
											field.SetValue(instance, Convert.ToInt32(data.Data));
											break;
                                        case "Int16":
                                            field.SetValue(instance, Convert.ToInt16(data.Data));
                                            break;
                                        case "Int64":
                                            field.SetValue(instance, Convert.ToInt64(data.Data));
                                            break;
										case "Decimal":
											field.SetValue(instance, Convert.ToDecimal(data.Data));
											break;
									}
									break;
							}
						}
					}
				}
			}
		}

		private static void DeserializeProperties(ActionScriptObject aso, Type type, object instance)
		{
			DeserializeFields(aso, type, instance);

			//get the custom attributes of the object
			PropertyInfo[] fields = type.GetProperties();
			if (fields != null)
			{
				foreach (PropertyInfo field in fields)
				{
					object[] attributes = field.GetCustomAttributes(typeof(AMFProperty), true);
					
					if (attributes != null)
					{
						foreach (AMFProperty propertyAttribute in attributes)
						{
							string key = propertyAttribute.Name;
							AMFDataType propertyType = propertyAttribute.ActionScriptDataType;

							//if we don't have let default value take over
							if (!aso.Properties.ContainsKey(key))
								continue;

							AMFData data = aso.Properties[key] as AMFData;

							//if we don't have let default value take over
							if (data.Data == null || !field.CanWrite)
								continue;

							switch (propertyType)
							{
								case AMFDataType.AMFEnabledObject:
									if (field.PropertyType.Name == "Object")
										field.SetValue(instance, data.Data, null);
									else
										field.SetValue(instance, Deserialize(data.Data as ActionScriptObject, field.PropertyType), null);
									break;
								case AMFDataType.Array:
									
									ArrayList al = data.Data as ArrayList;
									ArrayList alValues = new ArrayList();
									if (al != null && al.Count > 0)
									{
										object[] arrayItemAttributes = field.GetCustomAttributes(typeof(AMFArrayItem), true);

										Dictionary<string, Type> itemMap = new Dictionary<string, Type>();
										if (arrayItemAttributes != null)
										{
											foreach (AMFArrayItem arrayItemAttribute in arrayItemAttributes)
											{
												itemMap.Add(arrayItemAttribute.TypeName, arrayItemAttribute.TargetType);
											}
										}

										foreach (AMFData alData in al)
										{
											object dataValue = null;

											if (alData.Data is ActionScriptObject)
											{
												ActionScriptObject arrayItemASO = alData.Data as ActionScriptObject;
												if(itemMap.ContainsKey(arrayItemASO.TypeName))
													dataValue = GetArrayElementValue(alData, itemMap[arrayItemASO.TypeName]);
												else
													dataValue = GetArrayElementValue(alData, field.PropertyType.GetElementType());
											}
											else
												dataValue = GetArrayElementValue(alData, field.PropertyType.GetElementType());
											
											if (dataValue != null)
												alValues.Add(dataValue);
										}

										field.SetValue(instance, alValues.ToArray(field.PropertyType.GetElementType()), null);
									}
									break;
								case AMFDataType.Boolean:
								case AMFDataType.LongString:
								case AMFDataType.String:
								case AMFDataType.UTCDate:
								case AMFDataType.Date:
									field.SetValue(instance, data.Data, null);
									break;
                                case AMFDataType.Guid:
                                    field.SetValue(instance, new Guid(data.Data.ToString()), null);
                                    break;
								
								
								case AMFDataType.Number:
									switch (field.PropertyType.Name)
									{
										case "Int32":
											field.SetValue(instance, Convert.ToInt32(data.Data), null);
											break;
                                        case "Int16":
                                            field.SetValue(instance, Convert.ToInt16(data.Data), null);
                                            break;
                                        case "Int64":
                                            field.SetValue(instance, Convert.ToInt64(data.Data), null);
                                            break;
										case "Decimal":
											field.SetValue(instance, Convert.ToDecimal(data.Data), null);
											break;
									}
									break;
							}
						}
					}
				}
			}
		}

		private static object GetArrayElementValue(AMFData sourceData, Type memberType)
		{
			switch (sourceData.DataType)
			{
				case AMFDataType.AMFEnabledObject:
				case AMFDataType.Object:
				case AMFDataType.TypedObject:
				case AMFDataType.Reference:
					return Deserialize(sourceData.Data as ActionScriptObject, memberType);
				case AMFDataType.Number:
					switch (memberType.Name)
					{
						case "Int32":
							return Convert.ToInt32(sourceData.Data);
                        case "Int16":
                            return Convert.ToInt16(sourceData.Data);
                        case "Int64":
                            return Convert.ToInt64(sourceData.Data);
                            break;
						case "Decimal":
							return Convert.ToDecimal(sourceData.Data);
					}
					break;
				case AMFDataType.Boolean:
				case AMFDataType.Date:
				case AMFDataType.LongString:
				case AMFDataType.String:
				case AMFDataType.Xml:
					return sourceData.Data;
                case AMFDataType.Guid:
                    return new Guid(sourceData.Data.ToString());
			}

			return null;
		}
	}
}
