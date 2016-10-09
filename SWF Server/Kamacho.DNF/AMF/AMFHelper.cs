using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Kamacho.DNF.AMF
{
    public class AMFHelper
    {
        public static ActionScriptObject TransformDataSet(DataSet ds)
        {
            ActionScriptObject aso = new ActionScriptObject();
            aso.TypeName = "Kamacho.DNF.DTO.DataSetDTO";

            List<ActionScriptObject> dataTables = new List<ActionScriptObject>();

            foreach (DataTable dt in ds.Tables)
            {
                dataTables.Add(ProcessDataTable(dt));
            }

            aso.Properties.Add("tables", new AMFData(AMFDataType.Array, dataTables));

			return aso;
        }

        private static ActionScriptObject ProcessDataTable(DataTable dt)
        {
            ActionScriptObject aso = new ActionScriptObject();
            aso.TypeName = "Kamacho.DNF.DTO.DataTableDTO";

            List<ActionScriptObject> columns = new List<ActionScriptObject>();

            //now go through the columns

			Dictionary<string, AMFDataType> dataTypes = new Dictionary<string, AMFDataType>();

            foreach (DataColumn dc in dt.Columns)
            {
                ActionScriptObject column = new ActionScriptObject();
                column.TypeName = "Kamacho.DNF.DTO.DataColumnDTO";

                column.Properties.Add("name", new AMFData(AMFDataType.String, dc.ColumnName));

                AMFDataType columnType = AMFDataType.Unsupported;

				Type dataType = dc.DataType;
				if (dataType == typeof(Boolean))
					columnType = AMFDataType.Boolean;
				else if (dataType == typeof(String))
					columnType = AMFDataType.LongString;
				else if (dataType == typeof(DateTime))
					columnType = AMFDataType.Date;
				else if(dataType == typeof(Byte)
					|| dataType ==  typeof(Decimal)
					|| dataType ==   typeof(Double)
					|| dataType ==   typeof(Int16)
					|| dataType ==   typeof(Int32)
					|| dataType ==   typeof(SByte)
					|| dataType ==   typeof(Single)
					|| dataType ==   typeof(TimeSpan)
					|| dataType ==   typeof(UInt16)
					|| dataType ==   typeof(UInt32)
					|| dataType ==   typeof(UInt64))
					columnType = AMFDataType.Number;
				else
					columnType = AMFDataType.String;


				column.Properties.Add("dataType", new AMFData(AMFDataType.String, columnType));
				dataTypes.Add(dc.ColumnName, columnType);
				
                columns.Add(column);
            }

            aso.Properties.Add("columns", new AMFData(AMFDataType.Array, columns));

			//now we can go through the rows
			List<ActionScriptObject> rows = new List<ActionScriptObject>();
			foreach (DataRow dr in dt.Rows)
			{
				ActionScriptObject row = new ActionScriptObject();
                row.TypeName = "Kamacho.DNF.DTO.DataRowDTO";

				//get the values for the row
				List<ActionScriptObject> values = new List<ActionScriptObject>();
				foreach (DataColumn dc2 in dt.Columns)
				{
					ActionScriptObject rowValue = new ActionScriptObject();
                    rowValue.TypeName = "Kamacho.DNF.DTO.DataRowValueDTO";
					rowValue.Properties.Add("name", new AMFData(AMFDataType.String, dc2.ColumnName));
					rowValue.Properties.Add("data", new AMFData(dataTypes[dc2.ColumnName], dr[dc2]));

					values.Add(rowValue);
				}

				row.Properties.Add("values", new AMFData(AMFDataType.Array, values));
				rows.Add(row);
			}

			aso.Properties.Add("rows", new AMFData(AMFDataType.Array, rows));

			return aso;
        }
    }
}
