/*
	FluorineFx open source library 
	Copyright (C) 2007 Zoltan Csibi, zoltan@TheSilentGroup.com, FluorineFx.com 
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

using System;
using System.IO;
using System.Collections;
using System.Collections.Specialized;
using System.Configuration;
using System.Reflection;
using FluorineFx.Exceptions;
using FluorineFx.Configuration;
#if !FXCLIENT
using System.Web;
using FluorineFx.Context;
#endif
#if !SILVERLIGHT
using log4net;
#endif
#if !(NET_1_1)
using System.Collections.Generic;
#endif

namespace FluorineFx
{
	/// <summary>
	/// This type supports the Fluorine infrastructure and is not intended to be used directly from your code.
	/// </summary>
	class ObjectFactory
	{
#if !SILVERLIGHT
		private static readonly ILog log = LogManager.GetLogger(typeof(ObjectFactory));
#endif

#if !(NET_1_1)
        private static Dictionary<string, Type> _typeCache = new Dictionary<string, Type>();
#else
		private static Hashtable _typeCache = new Hashtable();
#endif
		private static string[] _lacLocations;

		static ObjectFactory()
		{
			_lacLocations = TypeHelper.GetLacLocations();
		}

		static public Type Locate(string typeName)
		{
			if( typeName == null || typeName == string.Empty )
				return null;

			string mappedTypeName = typeName;
			mappedTypeName = FluorineConfiguration.Instance.GetMappedTypeName(typeName);

			//Lookup first in our cache.
			lock(typeof(Type))
			{
                Type type = null;
                if( _typeCache.ContainsKey(mappedTypeName) )
                    type = _typeCache[mappedTypeName] as Type;
				if( type == null )
				{

					type = FluorineFx.TypeHelper.Locate(mappedTypeName);
					if(type != null)
					{
						_typeCache[mappedTypeName] = type;
						return type;
					}
					else
					{
						//Locate in LAC
						type = LocateInLac(mappedTypeName);
					}
				}
				return type;
			}
		}

		static public Type LocateInLac(string typeName)
		{
			//Locate in LAC
			if( typeName == null || typeName == string.Empty )
				return null;

			string mappedTypeName = typeName;
			mappedTypeName = FluorineConfiguration.Instance.GetMappedTypeName(typeName);

			//Lookup first in our cache.
			lock(typeof(Type))
			{
                Type type = null;
                if (_typeCache.ContainsKey(mappedTypeName))
                    type = _typeCache[mappedTypeName] as Type;
				if( type == null )
				{

					//Locate in LAC
					for(int i = 0; i < _lacLocations.Length; i++)
					{
						type = FluorineFx.TypeHelper.LocateInLac(mappedTypeName, _lacLocations[i]);
						if(type != null)
						{
							_typeCache[mappedTypeName] = type;
							return type;
						}
					}
				}
				return type;
			}
		}

		static internal void AddTypeToCache(Type type)
		{
			if( type != null )
			{
				lock(typeof(Type))
				{
					_typeCache[type.FullName] = type;
				}
			}
		}

		static public bool ContainsType(string typeName)
		{
			if( typeName != null )
			{
				lock(typeof(Type))
				{
					return _typeCache.ContainsKey(typeName);
				}
			}
			return false;
		}

		static public object CreateInstance(Type type)
		{
			return CreateInstance(type, null);
		}

		static public object CreateInstance(Type type, object[] args)
		{
			if( type != null )
			{
				lock(typeof(Type))
				{
					if (type.IsAbstract && type.IsSealed)
					{
						return type;
					}
					else
					{
						if( args == null )
#if SILVERLIGHT
                            return type.InvokeMember(null, BindingFlags.DeclaredOnly | BindingFlags.Public | BindingFlags.Instance | BindingFlags.CreateInstance | BindingFlags.Static, null, null, new object[] { });
#else
							return Activator.CreateInstance(type, BindingFlags.CreateInstance|BindingFlags.Public|BindingFlags.Instance|BindingFlags.Static, null, new object[]{}, null);
#endif
						else
#if SILVERLIGHT
                            return type.InvokeMember(null, BindingFlags.DeclaredOnly | BindingFlags.Public | BindingFlags.Instance | BindingFlags.CreateInstance | BindingFlags.Static, null, null, args);
#else
                            return Activator.CreateInstance(type, BindingFlags.CreateInstance|BindingFlags.Public|BindingFlags.Instance|BindingFlags.Static, null, args, null);
#endif
					}
				}
			}
			return null;
		}

		static public object CreateInstance(string typeName)
		{
			return CreateInstance(typeName, null);
		}

		static public object CreateInstance(string typeName, object[] args)
		{
			Type type = Locate(typeName);
			return CreateInstance(type, args);
		}
	}
}
