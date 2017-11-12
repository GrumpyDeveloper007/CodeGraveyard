using System;
using System.Windows.Forms;
using System.ComponentModel;
using System.Collections;

namespace MyClasses
{

	public class ColumnSorter : IComparer
	{
		public int CurrentColumn = 0; // Colun index to be sorted
		public int Direction = 0; // 0 : Ascending, 1 : Descending
		public int ColumnType = 0; // 0 : Integer , 1 : Double , 2 : String
		public bool CaseSensitivity = true;

		public int Compare(object x, object y)
		{
			int CurValue1 = 0, CurValue2 = 0;
			double DCurValue1 = 0.0, DCurValue2 = 0.0;

			try
			{
				ListViewItem rowA = (ListViewItem)x;
				ListViewItem rowB = (ListViewItem)y;

				if( ColumnType <= 0 )
				{
					CurValue1 = int.Parse( rowA.SubItems[CurrentColumn].Text );
					CurValue2 = int.Parse( rowB.SubItems[CurrentColumn].Text );
					if( Direction == 0 )
					{ 
						if( CurValue1 < CurValue2 ) return -1;
						if( CurValue1 == CurValue2 ) return 0;
						return 1;
					}
					else
					{
						if( CurValue1 < CurValue2 ) return 1;
						if( CurValue1 == CurValue2 ) return 0;
						return -1;
					}
				}
				else if( ColumnType == 1 )
				{
					DCurValue1 = double.Parse( rowA.SubItems[CurrentColumn].Text );
					DCurValue2 = double.Parse( rowB.SubItems[CurrentColumn].Text );

					if( Direction == 0 )
					{
						if( DCurValue1 < DCurValue2 ) return -1;
						if( DCurValue1 == DCurValue2 ) return 0;
						return 1;
					}
					else
					{
						if( DCurValue1 < DCurValue2 ) return 1;
						if( DCurValue1 == DCurValue2 ) return 0;
						return -1;
					}
				}
				else
				{
					if( Direction == 0 )
						return String.Compare( rowA.SubItems[CurrentColumn].Text , rowB.SubItems[CurrentColumn].Text , CaseSensitivity );

					return ( -1 * String.Compare( rowA.SubItems[CurrentColumn].Text , rowB.SubItems[CurrentColumn].Text , CaseSensitivity ) );
				}
			}
			catch
			{
				return -1;
			}

		}
	
		public ColumnSorter()
		{

		}
	}
}
