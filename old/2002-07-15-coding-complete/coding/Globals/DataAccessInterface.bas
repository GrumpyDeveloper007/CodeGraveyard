Attribute VB_Name = "DataAccessInterface"
Option Explicit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Coded by Dale Pitman
''

' ADO Compatibility
Public Const dbOpenTable As Long = 1
Public Const dbOpenDynamic As Long = 16
Public Const dbOpenDynaset As Long = 2
Public Const dbOpenSnapshot As Long = 4
Public Const dbForwardOnly As Long = 256
Public Const cWildCard As String = "%" ' % in ADO, * in DAO
Public Const cDateChar As String = "#" '
Public Const cTextField As String = "'"

Public db As New ADODB.Connection
'Public Const cConnectionString As String = "driver={SQL Server};server=80.3.208.133;database=simpleinvoice;uid=Test;pwd=TEST"
#Const UseSQLServer = 0 ' 1=yes,0=no

''
Public Sub GetTablesCBO(pCBO As ComboBox, pShowSystem As Boolean)
    Dim rstemp As Recordset
    Set rstemp = db.OpenSchema(adSchemaTables)

    Call pCBO.Clear
    ' Loop through the list and print the table names
    Do While (rstemp.EOF = False)
        If (pShowSystem = False And UCase$(Left$(rstemp!TABLE_NAME, 4)) = "MSYS") Then
            
        Else
            Call pCBO.AddItem(rstemp!TABLE_NAME)
        End If
        rstemp.MoveNext
    Loop

End Sub

''
Public Function ConnectDatabase(pName As String) As Boolean
    Dim SystemPath As String
    Dim KeepChecking As Boolean
    KeepChecking = True
    ConnectDatabase = True
    
    SystemPath = GetSetting(cRegistoryName, "Settings", pName, "NODATABASE")
    Do While (KeepChecking = True)
        If (Dir(SystemPath) = "" Or SystemPath = "NODATABASE") Then
            SystemPath = OpenDialogue(pName, pName)
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
        db.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & SystemPath
        db.Mode = adModeReadWrite
        db.Open
    End If
End Function

''
Public Function DisConnectDatabase() As Boolean
    db.Close
    Set db = Nothing
End Function

'' Create a record and return a uid, database indpendent
Public Function CreateRecordWithSQL(pSQLString As String) As Long
    Dim rstemp As Recordset
    Dim TableName As String
    Dim Tempstring As String
    Dim datastring As String
    Dim i As Long
    Dim stringclass As New stringclass
    Dim stringclass2 As New stringclass
    CreateRecordWithSQL = -1
    On Error GoTo TableError
    
    
    'SET NOCOUNT ON INSERT INTO
'      IColTest(F2) VALUES('Balloon')SELECT @@IDENTITY SET NOCOUNT OFF

#If UseSQLServer = 1 Then
    ' SQL Server method
    pSQLString = "SET NOCOUNT ON " & pSQLString & "SELECT @@IDENTITY as inn  SET NOCOUNT OFF"
    If (OpenRecordset(rstemp, pSQLString, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            CreateRecordWithSQL = rstemp!inn
        End If
    End If
#Else
    ' Access method, problem with "temp,temp3" type fields
    TableName = Mid$(pSQLString, 13, InStr(Right$(pSQLString, Len(pSQLString) - 13), " "))
    If (OpenRecordset(rstemp, TableName, dbOpenTable)) Then
        Call rstemp.AddNew
        CreateRecordWithSQL = rstemp!Uid
        Call stringclass.Tokenise(pSQLString, True)
        Tempstring = Mid$(stringclass.Tokens(3), 2, Len(stringclass.Tokens(3)) - 2)
        datastring = Mid$(stringclass.Tokens(5), 2, Len(stringclass.Tokens(5)) - 2)
        Call stringclass.Tokenise(Tempstring, True)
        Call stringclass2.Tokenise(datastring, True)
        For i = 0 To stringclass.NumTokens
            Tempstring = stringclass.Tokens(i) & ","
            datastring = stringclass2.Tokens(i) & ","
            
            If (Left$(datastring, 1) = "'" Or Left$(datastring, 1) = Chr$(34)) Then
                rstemp(Left$(Tempstring, InStr(Tempstring, ",") - 1)) = Mid$(datastring, 2, InStr(datastring, ",") - 3)
            Else
                rstemp(Left$(Tempstring, InStr(Tempstring, ",") - 1)) = Val(Mid$(datastring, 1, InStr(datastring, ",") - 1))
            End If
        Next
        Call rstemp.Update
        Call rstemp.Close
    End If
#End If
    Exit Function

TableError:
    If Err = 94 Then
        Resume 'next
    Else
        If (ErrorCheck(Error$, "CreateRecordWithSQL (" & pSQLString & ")")) Then
            Resume
        End If
        
    End If
End Function

''
Public Function GetTableDef(pName As String) As Long
'    Set GetTableDef =
End Function

''
Public Function ChangeFieldSize(pTableName As String, pFieldName As String, pFieldSize As Long) As Boolean
    Screen.MousePointer = vbHourglass
    Call Execute("Alter table " & pTableName & " Add Column [Temp] Text (" & pFieldSize & ")", True)    ' add a temp field with the new size
    Call Execute("Update " & pTableName & " set Temp=" & pFieldName, True)     ' move the data to the new field
    Call Execute("Alter Table " & pTableName & " drop column " & pFieldName, True)    ' drop the original field
    Call Execute("Alter table " & pTableName & " Add Column " & pFieldName & " Text (" & pFieldSize & ")", True)    ' add the Original field with its new size
'    Set tdTableDef = GetTableDef(pTableName)
'    tdTableDef.Fields(pFieldName).AllowZeroLength = True
'    Set tdTableDef = Nothing
    
    Call Execute("Update " & pTableName & " Set " & pFieldName & "=Temp", True)    ' move the data bacj from the temp field to the org field
    Call Execute("alter table " & pTableName & " Drop Column Temp", True)    ' drop the temp field
    Screen.MousePointer = vbDefault
End Function

''
Public Function OpenRecordsetNOOutput(pRecordset As Recordset, pName As String, pType As Long, Optional pOption = 0, Optional pRunServerSide As Boolean = False) As Boolean
    On Error GoTo TableError
    
    ' ADO
    Set pRecordset = New ADODB.Recordset
    Select Case pType
        Case dbOpenTable, dbOpenDynaset
            If (pOption = dbForwardOnly) Then
                Call pRecordset.Open(pName, db, adOpenKeyset, adLockReadOnly)
            Else
                Call pRecordset.Open(pName, db, adOpenDynamic, adLockPessimistic)
            End If
        Case dbOpenSnapshot
                Call pRecordset.Open(pName, db, adOpenStatic)
        Case Else
            Call MsgBox("Not supported yet")
    End Select

    OpenRecordsetNOOutput = True
    Exit Function

TableError:
    OpenRecordsetNOOutput = False
End Function


'' Used by all recordset functions, allows error check to be in one place
Public Function OpenRecordset(pRecordset As Recordset, pName As String, pType As Long, Optional pOption = 0, Optional pRunServerSide As Boolean = False) As Boolean
    On Error GoTo TableError
    
    ' ADO
    Set pRecordset = New ADODB.Recordset
    Select Case pType
        Case dbOpenTable, dbOpenDynaset
            If (pOption = dbForwardOnly) Then
                Call pRecordset.Open(pName, db, adOpenKeyset, adLockReadOnly)
            Else
                Call pRecordset.Open(pName, db, adOpenDynamic, adLockPessimistic)
            End If
        Case dbOpenSnapshot
                Call pRecordset.Open(pName, db, adOpenStatic)
        Case Else
            Call MsgBox("Not supported yet")
    End Select

    OpenRecordset = True
    Exit Function

TableError:
    If Err = 94 Then
        Resume 'next
    Else
        If (ErrorCheck(Error$, "OpenRecordset (" & pName & ")")) Then
            Resume
        End If
        OpenRecordset = False
    End If
End Function

''
Public Function Execute(pSql As String, Optional SuppressWarnings As Boolean = False) As Long
    On Error GoTo TableError

    Call db.Execute(pSql, Execute)
    If (Execute = 0) Then
        If (SuppressWarnings = False) Then
            Call Messagebox("No recordset effected [" & pSql & "]", vbExclamation)
        End If
    Else
    End If
    Exit Function
TableError:
    If (ErrorCheck(Error$, "Execute  (" & pSql & ")")) Then
        Resume
    End If
    Execute = False
End Function

'' Process strings to make compatible with sql strings
Public Function FilterString(pString As String) As String
    Dim pos As Long
    pos = InStr(pString, Chr$(34))
    FilterString = ""
    Do While (pos > 0)
        FilterString = FilterString & Left$(pString, pos) & Chr$(34)
        pString = Right$(pString, Len(pString) - pos)
        pos = InStr(pString, Chr$(34))
    Loop
    FilterString = FilterString & pString
End Function

''
Public Function MoveLastFirst(pRecordset As Recordset) As Boolean
    Call pRecordset.MoveLast
    Call pRecordset.MoveFirst
End Function

