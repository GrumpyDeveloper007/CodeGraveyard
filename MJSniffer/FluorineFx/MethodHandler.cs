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
using System.ComponentModel;
using System.Collections;
using System.Reflection;
#if !(NET_1_1)
using System.Collections.Generic;
#endif
#if !SILVERLIGHT
using log4net;
#endif
using FluorineFx.Exceptions;

namespace FluorineFx
{
	/// <summary>
	/// This type supports the Fluorine infrastructure and is not intended to be used directly from your code.
	/// </summary>
	public sealed class MethodHandler
	{
#if !SILVERLIGHT
        private static readonly ILog log = LogManager.GetLogger(typeof(MethodHandler));
#endif
        /// <summary>
        /// Initializes a new instance of the MethodHandler class.
        /// </summary>
		private MethodHandler()
		{
		}
        /// <summary>
        /// This method supports the Fluorine infrastructure and is not intended to be used directly from your code.
        /// </summary>
        /// <param name="type"></param>
        /// <param name="methodName"></param>
        /// <param name="arguments"></param>
        /// <returns></returns>
		public static MethodInfo GetMethod(Type type, string methodName, IList arguments)
		{
			return GetMethod(type, methodName, arguments, false);
		}

        /// <summary>
        /// This method supports the Fluorine infrastructure and is not intended to be used directly from your code.
        /// </summary>
        /// <param name="type"></param>
        /// <param name="methodName"></param>
        /// <param name="arguments"></param>
        /// <param name="exactMatch"></param>
        /// <returns></returns>
        public static MethodInfo GetMethod(Type type, string methodName, IList arguments, bool exactMatch)
        {
            return GetMethod(type, methodName, arguments, exactMatch, true);
        }

        /// <summary>
        /// This method supports the Fluorine infrastructure and is not intended to be used directly from your code.
        /// </summary>
        /// <param name="type"></param>
        /// <param name="methodName"></param>
        /// <param name="arguments"></param>
        /// <param name="exactMatch"></param>
        /// <param name="throwException"></param>
        /// <returns></returns>
        public static MethodInfo GetMethod(Type type, string methodName, IList arguments, bool exactMatch, bool throwException)
        {
            return GetMethod(type, methodName, arguments, exactMatch, throwException, true);
        }

        /// <summary>
        /// This method supports the Fluorine infrastructure and is not intended to be used directly from your code.
        /// </summary>
        /// <param name="type"></param>
        /// <param name="methodName"></param>
        /// <param name="arguments"></param>
        /// <param name="exactMatch"></param>
        /// <param name="throwException"></param>
        /// <param name="traceError"></param>
        /// <returns></returns>
        public static MethodInfo GetMethod(Type type, string methodName, IList arguments, bool exactMatch, bool throwException, bool traceError)
		{
			MethodInfo[] methodInfos = type.GetMethods(BindingFlags.Public|BindingFlags.Instance|BindingFlags.Static);
#if !(NET_1_1)
            List<MethodInfo> suitableMethodInfos = new List<MethodInfo>();
#else
			ArrayList suitableMethodInfos = new ArrayList();
#endif
            for (int i = 0; i < methodInfos.Length; i++)
            {
                MethodInfo methodInfo = methodInfos[i];
                if (methodInfo.Name == methodName)
                {
                    if ((methodInfo.GetParameters().Length == 0 && arguments == null)
                        || (arguments != null && methodInfo.GetParameters().Length == arguments.Count))
                        suitableMethodInfos.Add(methodInfo);
                }
            }
            if (suitableMethodInfos.Count > 0)
            {
                //Overloaded methods may suffer performance penalties because of type conversion checking
                for (int i = suitableMethodInfos.Count-1; i >= 0; i--)
                {
                    MethodInfo methodInfo = suitableMethodInfos[i] as MethodInfo;
                    ParameterInfo[] parameterInfos = methodInfo.GetParameters();
                    bool match = true;
                    //Matching method name and parameters number
                    for (int j = 0; j < parameterInfos.Length; j++)
                    {
                        ParameterInfo parameterInfo = parameterInfos[j];
                        if (!exactMatch)
                        {
                            if (!TypeHelper.IsAssignable(arguments[j], parameterInfo.ParameterType))
                            {
                                match = false;
                                break;
                            }
                        }
                        else
                        {
                            if (arguments[j] == null || arguments[j].GetType() != parameterInfo.ParameterType)
                            {
                                match = false;
                                break;
                            }
                        }
                    }
                    if (!match)
                        suitableMethodInfos.Remove(methodInfo);
                }
            }
			if( suitableMethodInfos.Count == 0 )
			{
                string msg = __Res.GetString(__Res.Invocation_NoSuitableMethod, methodName);
                if (traceError)
                {
#if !SILVERLIGHT
                    if (log.IsErrorEnabled)
                    {
                        log.Error(msg);
                        for (int j = 0; arguments != null && j < arguments.Count; j++)
                        {
                            object arg = arguments[j];
                            string trace;
                            if (arg != null)
                                trace = __Res.GetString(__Res.Invocation_ParameterType, j, arg.GetType().FullName);
                            else
                                trace = __Res.GetString(__Res.Invocation_ParameterType, j, "null");
                            log.Error(trace);
                        }
                    }
#endif
                }
				if( throwException )
					throw new FluorineException(msg);
			}
			if( suitableMethodInfos.Count > 1 )
			{
                string msg = __Res.GetString(__Res.Invocation_Ambiguity, methodName);
				if( throwException )
					throw new FluorineException(msg);
			}
            if (suitableMethodInfos.Count > 0)
                return suitableMethodInfos[0] as MethodInfo;
            else
                return null;
		}
	}
}
