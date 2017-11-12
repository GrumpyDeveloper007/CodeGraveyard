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

Public db As New ADODB.Connection
'Public Const cConnectionString As String = "driver={SQL Server};server=80.3.208.133;database=simpleinvoice;uid=Test;pwd=TEST"
#Const UseSQLServer = 0 ' 1=yes,0=no

Public RecordsAffected As Long


Public Function DisConnectDatabase()
    db.Close
    Set db = Nothing
End Function

'Private vCommonDialogControl As CommonDialog

''function to locate and save a specified database
Private Function LocateDatabase(DatabaseName As String) As String
    On Error GoTo Dialog_Cancelled
    'setup the common dialog control
    With MDIMain.CommonDialogControl
        .InitDir = App.Path
        .Filter = DatabaseName & "|" & DatabaseName
        .CancelError = True
        .DialogTitle = "Locate " & DatabaseName & " database"
        'Show the open dialog
        .ShowOpen
        'save the returned setting
        SaveSetting cRegistoryName, "settings", DatabaseName, .FileName
        'return the path
        LocateDatabase = .FileName
    End With
    Exit Function
Dialog_Cancelled:
    'if there was an error or the user cancelled the function, return "****"
    LocateDatabase = "****"
    Exit Function
End Function

''
Public Function ConnectDatabase(pName As String) As Boolean
    Dim SystemPath As String
    Dim KeepChecking As Boolean
    KeepChecking = True
    ConnectDatabase = True
    
    SystemPath = GetSetting(cRegistoryName, "Settings", pName, "****")
    Do While (KeepChecking = True)
        If (Dir(SystemPath) = "" Or SystemPath = "****") Then
            SystemPath = LocateDatabase(pName)
            If (SystemPath = "****") Then
'                If (MsgBox("You cannot run this program without the database.  Do you want to look again?", vbQuestion + vbYesNo, "Unable to Continue") = vbNo) Then
                    ConnectDatabase = False
                    KeepChecking = False
'                End If
            End If
        Else
            KeepChecking = False
        End If
    Loop
    If (ConnectDatabase = True) Then
'        If (InStrRev(SystemPath, "\") >= 0) Then
'            vDataPath = Left$(SystemPath, InStrRev(SystemPath, "\"))
'        Else
'            vDataPath = ""
'        End If

'ado
'Microsoft OLE DB Provider for SQL Server
'        db.ConnectionString = "Provider=SQLOLEDB.1;Data Source=62.254.14.102;database=simpleinvoice;uid=Test;pwd="
        

'        db.ConnectionString = cConnectionString
        db.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & SystemPath
        ';Packet Size=512
        
        db.Mode = adModeReadWrite
        db.Open
    End If
End Function


'' Create a record and return a uid, database indpendent
Public Function CreateRecordWithSQL(pSQLString As String) As Long
    Dim rstemp As Recordset
    Dim TableName As String
    Dim TempString As String
    Dim datastring As String
    Dim i As Long
    Dim stringclass As New stringclass
    Dim stringclass2 As New stringclass
    CreateRecordWithSQL = -1
    On Error GoTo TableError
    
'Create Procedure MyInsert
'       @FieldVal Varchar(30), @id Int OUTPUT AS
'       Insert Into IColTest (F2) Values(@FieldVal)
'       Select @id = @@Identity
    
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
        CreateRecordWithSQL = rstemp!UID
        Call stringclass.Tokenise(pSQLString)
        TempString = Mid$(stringclass.Tokens(3), 2, Len(stringclass.Tokens(3)) - 2)
        datastring = Mid$(stringclass.Tokens(5), 2, Len(stringclass.Tokens(5)) - 2)
        stringclass.Tokenise (TempString)
        stringclass2.Tokenise (datastring)
        For i = 0 To stringclass.NumTokens
            TempString = stringclass.Tokens(i) & ","
            datastring = stringclass2.Tokens(i) & ","
            
            If (Left$(datastring, 1) = "'" Or Left$(datastring, 1) = Chr$(34)) Then
                rstemp(Left$(TempString, InStr(TempString, ",") - 1)) = Mid$(datastring, 2, InStr(datastring, ",") - 3)
            Else
                rstemp(Left$(TempString, InStr(TempString, ",") - 1)) = Val(Mid$(datastring, 1, InStr(datastring, ",") - 1))
            End If
'            TempString = Right$(TempString, (Len(TempString) - InStr(TempString, ",")))
'            datastring = Right$(datastring, (Len(datastring) - InStr(datastring, ",")))
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
'    Dim tdTableDef As TableDef
    Screen.MousePointer = vbHourglass
    ' add a temp field with the new size
    Call Execute("Alter table " & pTableName & " Add Column [Temp] Text (" & pFieldSize & ")", True)
    ' move the data to the new field
    Call Execute("Update " & pTableName & " set Temp=" & pFieldName, True)
    ' drop the original field
    Call Execute("Alter Table " & pTableName & " drop column " & pFieldName, True)
    ' add the Original field with its new size
    Call Execute("Alter table " & pTableName & " Add Column " & pFieldName & " Text (" & pFieldSize & ")", True)
'    Set tdTableDef = GetTableDef(pTableName)
'    tdTableDef.Fields(pFieldName).AllowZeroLength = True
'    Set tdTableDef = Nothing
    ' move the data bacj from the temp field to the org field
    Call Execute("Update " & pTableName & " Set " & pFieldName & "=Temp", True)
    ' drop the temp field
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
    
    ' DAO
'    If (pRunServerSide = True) Then
'        If (pOption = 0) Then
'            Set pRecordset = db.OpenRecordset(pName, pType)
'        Else
'            Set pRecordset = db.OpenRecordset(pName, pType, pOption)
'        End If
'    Else
'        If (pOption = 0) Then
'            Set pRecordset = db.OpenRecordset(pName, pType)
'        Else
'            Set pRecordset = db.OpenRecordset(pName, pType, pOption)
'        End If
'    End If

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

    Call db.Execute(pSQL, RecordsAffected)
'    RecordsAffected = db.RecordsAffected
    Execute = RecordsAffected
    If (RecordsAffected = 0) Then
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

''
Public Function MoveLastFirst(pRecordset As Recordset) As Boolean
    Call pRecordset.MoveLast
    Call pRecordset.MoveFirst
End Function

