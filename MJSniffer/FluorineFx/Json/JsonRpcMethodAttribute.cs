using System;
using System.Data;
using System.Reflection;
using FluorineFx.Invocation;
using FluorineFx.Util;
using FluorineFx.Json.Rpc;
using FluorineFx.Json.Services;

namespace FluorineFx.Json
{
    /// <summary>
    /// Indicates whether an operation (method) can be invoked using Json RPC.
    /// </summary>
    [Serializable]
    [AttributeUsage(AttributeTargets.Method)]
    public sealed class JsonRpcMethodAttribute : Attribute, IInvocationResultHandler
    {
        private string _name;

        /// <summary>
        /// Initializes a new instance of the JsonRpcMethodAttribute class.
        /// </summary>
        public JsonRpcMethodAttribute() { }
        /// <summary>
        /// Initializes a new instance of the JsonRpcMethodAttribute class.
        /// </summary>
        /// <param name="name"></param>
        public JsonRpcMethodAttribute(string name)
        {
            _name = name;
        }

        public string Name
        {
            get { return StringUtils.MaskNullString(_name); }
            set { _name = value; }
        }


        #region IInvocationResultHandler Members

        public void HandleResult(IInvocationManager invocationManager, MethodInfo methodInfo, object obj, object[] arguments, object result)
        {
            if (invocationManager.Result is DataSet)
            {
                DataSet dataSet = result as DataSet;
                invocationManager.Result = TypeHelper.ConvertDataSetToASO(dataSet, false);
            }
            if (invocationManager.Result is DataTable)
            {
                DataTable dataTable = result as DataTable;
                invocationManager.Result = TypeHelper.ConvertDataTableToASO(dataTable, false);
            }
        }

        #endregion
    }
}
