Attribute VB_Name = "DataAccessInterface"
Option Explicit

' ADO Compatibility
Public Const dbOpenTable As Long = 1
Public Const dbOpenDynamic As Long = 16
Public Const dbOpenDynaset As Long = 2
Public Const dbOpenSnapshot As Long = 4
Public Const dbForwardOnly As Long = 256
Public Const cWildCard As String = "%" ' % in ADO, * in DAO
Public Const cDateChar As String = "'" '
Public Const cTextField As String = "'"

Private db As New ADODB.Connection
'Public Const cConnectionString As String = "driver={SQL Server};server=80.3.208.133;database=simpleinvoice;uid=Test;pwd=TEST"
#Const UseSQLServer = 0 ' 1=yes,0=no

''
Public Function ConnectDatabase(pName As String) As Boolean
    Dim SystemPath As String
    ConnectDatabase = True
    
    SystemPath = GetSetting(cRegistoryName, "Settings", pName, "NODB")
    If (Dir(SystemPath) = "" Or SystemPath = "NODB") Then
        If (SystemPath = "NODB") Then
            ConnectDatabase = False
        End If
    End If
    
    If (ConnectDatabase = True) Then
'ado
'Microsoft OLE DB Provider for SQL Server
'        db.ConnectionString = "Provider=SQLOLEDB.1;Data Source=62.254.14.102;database=simpleinvoice;uid=Test;pwd="
        
        db.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & SystemPath
        db.Mode = adModeReadWrite
        db.Open
    End If
End Function

Public Function DisConnectDatabase()
    db.Close
    Set db = Nothing
End Function

'' Create a record and return a uid, database indpendent
Public Function CreateRecordWithSQL(pSQLString As String) As Long
    Dim rstemp As Recordset
    Dim TableName As String
    Dim TempString As String
    Dim datastring As String
    Dim i As Long
    Dim StringClass As New StringClass
    Dim stringclass2 As New StringClass
    CreateRecordWithSQL = -1
    On Error GoTo TableError
    
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
        CreateRecordWithSQL = rstemp!UID
        Call StringClass.Tokenise(pSQLString)
        TempString = Mid$(StringClass.Tokens(3), 2, Len(StringClass.Tokens(3)) - 2)
        datastring = Mid$(StringClass.Tokens(5), 2, Len(StringClass.Tokens(5)) - 2)
        StringClass.Tokenise (TempString)
        stringclass2.Tokenise (datastring)
        For i = 0 To StringClass.NumTokens
            TempString = StringClass.Tokens(i) & ","
            datastring = stringclass2.Tokens(i) & ","
            
            If (Left$(datastring, 1) = "'" Or Left$(datastring, 1) = Chr$(34)) Then
                rstemp(Left$(TempString, InStr(TempString, ",") - 1)) = Mid$(datastring, 2, InStr(datastring, ",") - 3)
            Else
                rstemp(Left$(TempString, InStr(TempString, ",") - 1)) = Val(Mid$(datastring, 1, InStr(datastring, ",") - 1))
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
        If (ErrorCheck("")) Then
            Resume
        End If
    End If
End Function

''
Public Function ChangeFieldSize(pTableName As String, pFieldName As String, pFieldSize As Long) As Boolean
    Screen.MousePointer = vbHourglass
    Call Execute("Alter table " & pTableName & " Add Column [Temp] Text (" & pFieldSize & ")", True)
    Call Execute("Update " & pTableName & " set Temp=" & pFieldName, True)
    Call Execute("Alter Table " & pTableName & " drop column " & pFieldName, True)
    Call Execute("Alter table " & pTableName & " Add Column " & pFieldName & " Text (" & pFieldSize & ")", True)
    Call Execute("Update " & pTableName & " Set " & pFieldName & "=Temp", True)
    Call Execute("alter table " & pTableName & " Drop Column Temp", True)
    Screen.MousePointer = vbDefault
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
        If (ErrorCheck(pName)) Then
            Resume
        End If
        OpenRecordset = False
    End If
End Function

Public Function Execute(pSQL As String, Optional SuppressWarnings As Boolean = False) As Long
    On Error GoTo TableError

    Call db.Execute(pSQL, Execute)
    If (Execute = 0) Then
        If (SuppressWarnings = False) Then
            Call Messagebox("No recordset effected [" & pSQL & "]", vbExclamation)
        End If
    Else
    End If
    Exit Function
    
TableError:
    If (ErrorCheck(pSQL)) Then
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

