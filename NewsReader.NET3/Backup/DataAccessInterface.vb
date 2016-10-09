Option Strict Off
Option Explicit On
Module DataAccessInterface
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Coded by Dale Pitman
	''
	
	' ADO Compatibility
	Public Const dbOpenTable As Integer = 1
	Public Const dbOpenDynamic As Integer = 16
	Public Const dbOpenDynaset As Integer = 2
	Public Const dbOpenSnapshot As Integer = 4
	Public Const dbForwardOnly As Integer = 256
	Public Const cWildCard As String = "%" ' % in ADO, * in DAO
	Public Const cDateChar As String = "#" '
	Public Const cTextField As String = "'"
	
	Public db As New ADODB.Connection
	'Public Const cConnectionString As String = "driver={SQL Server};server=80.3.208.133;database=simpleinvoice;uid=Test;pwd=TEST"
#Const UseSQLServer = 0 ' 1=yes,0=no
	
	''
	Public Sub GetTablesCBO(ByRef pCBO As System.Windows.Forms.ComboBox, ByRef pShowSystem As Boolean)
		Dim rstemp As ADODB.Recordset
		rstemp = db.OpenSchema(ADODB.SchemaEnum.adSchemaTables)
		
		Call pCBO.Items.Clear()
		' Loop through the list and print the table names
		Do While (rstemp.EOF = False)
			If (pShowSystem = False And UCase(Left(rstemp.Fields("TABLE_NAME").Value, 4)) = "MSYS") Then
				
			Else
				Call pCBO.Items.Add(rstemp.Fields("TABLE_NAME").Value)
			End If
			rstemp.MoveNext()
		Loop 
		
	End Sub
	
	''
	Public Function ConnectDatabase(ByRef pName As String) As Boolean
		Dim SystemPath As String
		Dim KeepChecking As Boolean
		KeepChecking = True
		ConnectDatabase = True
		
		SystemPath = GetSetting(cRegistoryName, "Settings", pName, "NODATABASE")
		Do While (KeepChecking = True)
			'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
			If (Dir(SystemPath) = "" Or SystemPath = "NODATABASE") Then
				SystemPath = OpenDialogue(pName, "NewsReader*.mdb")
				If (SystemPath = "") Then
					SystemPath = "NODATABASE"
				End If
				Call SaveSetting(cRegistoryName, "settings", pName, SystemPath)
				If (SystemPath = "NODATABASE") Then
					ConnectDatabase = False
				End If
				KeepChecking = False
			Else
				KeepChecking = False
			End If
		Loop 
		If (ConnectDatabase = True) Then
			'ado
			'Microsoft OLE DB Provider for SQL Server
			'  db.Properties
			db.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & SystemPath
			db.Mode = ADODB.ConnectModeEnum.adModeReadWrite
			db.Open()
			'        db.Properties("Jet OLEDB:Max Buffer Size") = 65536
			'        db.Properties("Jet OLEDB:Flush Transaction Timeout") = 0
			'        db.Properties("Jet OLEDB:Shared Async Delay") = 20000 'milliseconds
		End If
	End Function
	
	''
	Public Function DisConnectDatabase() As Boolean
		db.Close()
		'UPGRADE_NOTE: Object db may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		db = Nothing
	End Function
	
	'' Create a record and return a uid, database indpendent
	Public Function CreateRecordWithSQL(ByRef pSQLString As String) As Integer
		Dim rstemp As ADODB.Recordset
		Dim TableName As String
		Dim tempstring As String
		Dim datastring As String
		Dim i As Integer
		Dim stringclass As New StringClass
		Dim stringclass2 As New StringClass
		CreateRecordWithSQL = -1
		On Error GoTo TableError
		
		
		'SET NOCOUNT ON INSERT INTO
		'      IColTest(F2) VALUES('Balloon')SELECT @@IDENTITY SET NOCOUNT OFF
		
#If UseSQLServer = 1 Then
		'UPGRADE_NOTE: #If #EndIf block was not upgraded because the expression UseSQLServer = 1 did not evaluate to True or was not evaluated. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="27EE2C3C-05AF-4C04-B2AF-657B4FB6B5FC"'
		' SQL Server method
		pSQLString = "SET NOCOUNT ON " & pSQLString & "SELECT @@IDENTITY as inn  SET NOCOUNT OFF"
		If (OpenRecordset(rstemp, pSQLString, dbOpenSnapshot)) Then
		If (rstemp.EOF = False) Then
		CreateRecordWithSQL = rstemp!inn
		End If
		End If
#Else
		' Access method, problem with "temp,temp3" type fields
		TableName = Mid(pSQLString, 13, InStr(Right(pSQLString, Len(pSQLString) - 13), " "))
		If (OpenRecordset(rstemp, TableName, dbOpenTable)) Then
			Call rstemp.AddNew()
			CreateRecordWithSQL = rstemp.Fields("UID").Value
			Call stringclass.Tokenise(pSQLString, True)
			tempstring = Mid(stringclass.Tokens(3), 2, Len(stringclass.Tokens(3)) - 2)
			datastring = Mid(stringclass.Tokens(5), 2, Len(stringclass.Tokens(5)) - 2)
			Call stringclass.Tokenise(tempstring, True)
			Call stringclass2.Tokenise(datastring, True)
			For i = 0 To stringclass.NumTokens
				tempstring = stringclass.Tokens(i) & ","
				datastring = stringclass2.Tokens(i) & ","
				
				If (Left(datastring, 1) = "'" Or Left(datastring, 1) = Chr(34)) Then
					rstemp.Fields(Left(tempstring, InStr(tempstring, ",") - 1)).Value = Mid(datastring, 2, InStr(datastring, ",") - 3)
				Else
					rstemp.Fields(Left(tempstring, InStr(tempstring, ",") - 1)).Value = Val(Mid(datastring, 1, InStr(datastring, ",") - 1))
				End If
			Next 
			Call rstemp.Update()
			Call rstemp.Close()
		End If
#End If
		Exit Function
		
TableError: 
		If Err.Number = 94 Then
			Resume  'next
		Else
			If (ErrorCheck(ErrorToString(), "CreateRecordWithSQL (" & pSQLString & ")")) Then
				Resume 
			End If
			
		End If
	End Function
	
	''
	Public Function GetTableDef(ByRef pName As String) As Integer
		'    Set GetTableDef =
	End Function
	
	''
	Public Function ChangeFieldSize(ByRef pTableName As String, ByRef pFieldName As String, ByRef pFieldSize As Integer) As Boolean
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		Call Execute("Alter table " & pTableName & " Add Column [Temp] Text (" & pFieldSize & ")", True) ' add a temp field with the new size
		Call Execute("Update " & pTableName & " set Temp=" & pFieldName, True) ' move the data to the new field
		Call Execute("Alter Table " & pTableName & " drop column " & pFieldName, True) ' drop the original field
		Call Execute("Alter table " & pTableName & " Add Column " & pFieldName & " Text (" & pFieldSize & ")", True) ' add the Original field with its new size
		'    Set tdTableDef = GetTableDef(pTableName)
		'    tdTableDef.Fields(pFieldName).AllowZeroLength = True
		'    Set tdTableDef = Nothing
		
		Call Execute("Update " & pTableName & " Set " & pFieldName & "=Temp", True) ' move the data bacj from the temp field to the org field
		Call Execute("alter table " & pTableName & " Drop Column Temp", True) ' drop the temp field
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Function
	
	''
	Public Function OpenRecordsetNOOutput(ByRef pRecordset As ADODB.Recordset, ByRef pName As String, ByRef pType As Integer, Optional ByRef pOption As Object = 0, Optional ByRef pRunServerSide As Boolean = False) As Boolean
		On Error GoTo TableError
		
		' ADO
		pRecordset = New ADODB.Recordset
		Select Case pType
			Case dbOpenTable, dbOpenDynaset
				'UPGRADE_WARNING: Couldn't resolve default property of object pOption. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				If (pOption = dbForwardOnly) Then
					Call pRecordset.Open(pName, db, ADODB.CursorTypeEnum.adOpenKeyset, ADODB.LockTypeEnum.adLockReadOnly)
				Else
					Call pRecordset.Open(pName, db, ADODB.CursorTypeEnum.adOpenDynamic, ADODB.LockTypeEnum.adLockPessimistic)
				End If
			Case dbOpenSnapshot
				Call pRecordset.Open(pName, db, ADODB.CursorTypeEnum.adOpenStatic)
			Case Else
				Call MsgBox("Not supported yet")
		End Select
		
		OpenRecordsetNOOutput = True
		Exit Function
		
TableError: 
		OpenRecordsetNOOutput = False
	End Function
	
	
	'' Used by all recordset functions, allows error check to be in one place
	Public Function OpenRecordset(ByRef pRecordset As ADODB.Recordset, ByRef pName As String, ByRef pType As Integer, Optional ByRef pOption As Object = 0, Optional ByRef pRunServerSide As Boolean = False) As Boolean
		On Error GoTo TableError
		
		' ADO
		pRecordset = New ADODB.Recordset
		Select Case pType
			Case dbOpenTable, dbOpenDynaset
				'UPGRADE_WARNING: Couldn't resolve default property of object pOption. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				If (pOption = dbForwardOnly) Then
					Call pRecordset.Open(pName, db, ADODB.CursorTypeEnum.adOpenKeyset, ADODB.LockTypeEnum.adLockReadOnly)
				Else
					Call pRecordset.Open(pName, db, ADODB.CursorTypeEnum.adOpenDynamic, ADODB.LockTypeEnum.adLockPessimistic)
				End If
			Case dbOpenSnapshot
				Call pRecordset.Open(pName, db, ADODB.CursorTypeEnum.adOpenStatic)
			Case Else
				Call MsgBox("Not supported yet")
		End Select
		
		OpenRecordset = True
		Exit Function
		
TableError: 
		If Err.Number = 94 Then
			Resume  'next
		Else
			'If (ErrorCheck(error$, "OpenRecordset (" & pName & ")")) Then
			'    Resume
			' End If
			OpenRecordset = False
		End If
	End Function
	
	''
	Public Function Execute(ByRef pSql As String, Optional ByRef SuppressWarnings As Boolean = False) As Integer
		On Error GoTo TableError
		
		Call db.Execute(pSql, Execute)
		If (Execute = 0) Then
			If (SuppressWarnings = False) Then
				Call Messagebox("No recordset effected [" & pSql & "]", MsgBoxStyle.Exclamation)
			End If
		Else
		End If
		Exit Function
TableError: 
		If Err.Number = -2147467259 Then ' Table locked
			System.Windows.Forms.Application.DoEvents()
			Resume 
		End If
		If (ErrorCheck(ErrorToString(), "Execute  (" & pSql & ")")) Then
			System.Windows.Forms.Application.DoEvents()
			Resume 
		End If
		Execute = False
	End Function
	
	'' Process strings to make compatible with sql strings
	Public Function FilterString(ByVal pString As String) As String
		Dim pos As Integer
		pos = InStr(pString, Chr(34))
		FilterString = ""
		Do While (pos > 0)
			FilterString = FilterString & Left(pString, pos) & Chr(34)
			pString = Right(pString, Len(pString) - pos)
			pos = InStr(pString, Chr(34))
		Loop 
		FilterString = FilterString & pString
		FilterString = Replace(FilterString, Chr(0), "")
	End Function
	
	''
	Public Function MoveLastFirst(ByRef pRecordset As ADODB.Recordset) As Boolean
		Call pRecordset.MoveLast()
		Call pRecordset.MoveFirst()
	End Function
End Module