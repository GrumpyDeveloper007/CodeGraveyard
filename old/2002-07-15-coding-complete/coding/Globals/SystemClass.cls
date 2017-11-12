VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SystemClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'' Middle tier object, that controls system functionality
''
''
Private db As DataBase

''
Property Let DataBase(pDatabase As DataBase)
    Set db = pDatabase
End Property


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

''
Private Function openrecordset(precordset As Recordset, name, ptype, Optional poptions)

End Function


''
Public Function ExecuteSQL(pSQL As String) As Boolean
    On Error GoTo TableError
    Call db.Execute(pSQL)
    If (db.RecordsAffected = 0) Then
        Call MsgBox("No recordset effected", vbExclamation)
        ExecuteSQL = False
    Else
        ExecuteSQL = True
    End If
    Exit Function
    
TableError:
    MsgBox "Error Status (" & Trim(Erl) & ").  " & Error$ & " has occurred."
    ExecuteSQL = False
End Function

'' Create record function, using 'deny read' locking to avoid duplicate id's
Public Function CreateRecord(pTableName As String, pPartialSQLString As String) As Boolean
    Dim rsGetid As Recordset
    Dim NewID As Long
    Dim NewSQL As String
    Dim lSQL As String
    Dim rSQL As String
    If (openrecordset(rsGetid, "select max(uid) as maxid from " & pTableName, dbDenyRead)) Then
        If (rsGetid.EOF = True) Then
            NewID = 1
        Else
            NewID = Val(rsGetid!maxid & "") + 1
        End If
        
        lSQL = Mid$(pPartialSQLString, 2, InStr(pPartialSQLString, ")"))
        rSQL = Right$(pPartialSQLString, Len(pPartialSQLString) - InStrRev(pPartialSQLString, "("))
        NewSQL = " (uid," & lSQL & " VALUES (" & NewID & "," & rSQL
        CreateRecord = ExecuteSQL("INSERT INTO " & pTableName & NewSQL)
        
        rsGetid.Close
    End If
End Function

''
Public Function UpdateRecord(pTableName As String, pPartialSQLString As String) As Boolean
    UpdateRecord = ExecuteSQL("UPDATE " & pTableName & " set " & pPartialSQLString)
End Function

'' Recalculates all record uid's
Public Sub CompressTable(pTableName As String)
    Dim rsTable As Recordset
    Dim NewID As Long
    NewID = 1
    If (openrecordset(rsTable, "select * from " & pTableName, dbOpenDynaset, dbDenyRead)) Then
        Do While (rsTable.EOF = False)
            rsTable.Edit
            rsTable!UID = NewID
            rsTable.Update
            NewID = NewID + 1
            rsTable.MoveNext
        Loop
        rsTable.Close
    End If
End Sub

'' Delete a record from a table by uid
Public Function DeleteID(pTableName As String, pUid As Long) As Boolean
'    DeleteID = dbsystem.ExecuteSQL("DELETE * FROM " & pTableName & " where uid=" & pUid)
End Function

'' Only works under single user env, (remove later)
Public Function GetNewID(pTableName As String) As Long
    Dim rsGetid As Recordset
    If (openrecordset(rsGetid, "select max(uid) as maxid from " & pTableName, dbOpenSnapshot)) Then
        If (rsGetid.EOF = True) Then
            GetNewID = 1
        Else
            GetNewID = Val(rsGetid!maxid & "") + 1
        End If
        rsGetid.Close
    End If
End Function

''
Public Function AddToApplianceLog(pApplianceNumber As Long, pLocation As String, ptype As String) As Boolean
    AddToApplianceLog = ExecuteSQL("INSERT INTO applog (appliancen,location,[date],type) VALUES (" _
    & pApplianceNumber & "," _
    & Chr$(34) & pLocation & Chr$(34) & "," _
    & Chr$(34) & Now & Chr$(34) & "," _
    & Chr$(34) & ptype & Chr$(34) & ")")
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

''
Public Sub LoadDeliveryPeople(pDeliveryID() As Long, pDeliveryName() As String, pNumberDeliveryPeople As Long)
    Dim rsDeliveryPeople As Recordset
    Dim i As Long
    Dim isok As Boolean
    
    isok = openrecordset(rsDeliveryPeople, "SELECT * FROM delP order by uid", dbOpenSnapshot, dbForwardOnly)
    '3011 database on there
    i = 0
    If (isok = True) Then
        Do While (rsDeliveryPeople.EOF = False)
            pDeliveryID(i) = rsDeliveryPeople!UID
            pDeliveryName(i) = rsDeliveryPeople!name & ""
            rsDeliveryPeople.MoveNext
            i = i + 1
        Loop
        rsDeliveryPeople.Close
    End If
    If (i = 0) Then
'        Call uDebug.SignalError(-1, "Unable to read any delivery people from database", diModeOK, "Add delivery people or fix database structure")
    End If
    pNumberDeliveryPeople = i
End Sub

''
Public Sub LoadSlots(pSlotID() As Long, pSlotName() As String, pNumberSlots As Long)
    Dim rsSlots As Recordset
    Dim isok As Boolean
    Dim i As Long
    isok = openrecordset(rsSlots, "SELECT * from dslots order by uid", dbOpenSnapshot, dbForwardOnly)
    i = 0
    If (isok = True) Then
        Do While (rsSlots.EOF = False)
            pSlotID(i) = rsSlots!UID
            pSlotName(i) = rsSlots!name
            rsSlots.MoveNext
            i = i + 1
        Loop
        rsSlots.Close
    End If
    
    If (i = 0) Then
'        Call uDebug.SignalError(-1, "Unable to read any delivery slots", diModeOK, "Add slots")
    End If
    pNumberSlots = i
End Sub

'' Get locations, put in combo box
Public Sub ReadLocations(pComboBox As ComboBox)
    Dim rslocation As Recordset
    Call pComboBox.Clear
    If (openrecordset(rslocation, "APPLOC", dbOpenTable)) Then
        Do While (rslocation.EOF = False)
            Call pComboBox.AddItem(rslocation!Location)
            Call rslocation.MoveNext
        Loop
        Call rslocation.Close
    End If
    pComboBox.Text = pComboBox.List(0)
End Sub

''
Public Sub ReadEngineers(pComboBox As ComboBox, pIncludeDepot As Integer)
    Dim rsEngineer As Recordset
    Dim SQLstring As String

    SQLstring = "select EngineerNa,EngineerNu from Engineer "
    If (pIncludeDepot = False) Then
        SQLstring = SQLstring & " where EngineerNu > 0 "
    End If
    SQLstring = SQLstring & "Order by EngineerNu"
'    Call pComboBox.Clear
    
    If (openrecordset(rsEngineer, SQLstring, dbOpenSnapshot, dbForwardOnly)) Then
        Do While (rsEngineer.EOF() = False)
            Call pComboBox.AddItem(Trim$(rsEngineer!EngineerNa) & "" + " (" + Trim(rsEngineer!engineernu) + ")")
            Call rsEngineer.MoveNext
        Loop
        Call rsEngineer.Close
    End If
    If (pComboBox.ListCount > 0) Then
        pComboBox.Text = pComboBox.List(0)
    End If
End Sub

''
Public Sub ReadCleaners(pComboBox As ComboBox)
    Dim rsCleaners As Recordset

'    Call pComboBox.Clear
    If (openrecordset(rsCleaners, "Cleaner", dbOpenSnapshot, dbForwardOnly)) Then
        Do While (rsCleaners.EOF = False)
            Call pComboBox.AddItem(Trim$(rsCleaners!cleanernam & ""))
            pComboBox.ItemData(pComboBox.NewIndex) = rsCleaners!CleanerNum
            Call rsCleaners.MoveNext
        Loop
        Call rsCleaners.Close
    End If
    If (pComboBox.ListCount > 0) Then
        pComboBox.Text = pComboBox.List(0)
    End If
End Sub


''
Public Function FindModelDescription(pModelNumber As String) As String
    Dim rsModelFile As Recordset
    Dim sql As String

    FindModelDescription = "N/A"
    If (pModelNumber <> "") Then
        pModelNumber = UCase$(pModelNumber)
        sql = "Select imbspr,imbpds from CSFIMBF1 where imbspr = '" & pModelNumber & "'"

        If (openrecordset(rsModelFile, sql, dbOpenSnapshot)) Then
            If (rsModelFile.RecordCount > 0) Then
                'rsModelFile.MoveFirst
                FindModelDescription = rsModelFile!IMBPDS
            End If
        End If
    End If
End Function

'' Returns manafacturer code from model number
Public Function GetManafacturerCode(pModelNumber As String) As String
    Dim sSql As String
    Dim rsSearch1 As Recordset

    ' Return blank on any error
    GetManafacturerCode = ""
    
'    sSql = "select IMBPDS,IMBSBC from " & tblModelNumber & _
'           " where IMBSPR = '" & pModelNumber & "'"
    If (openrecordset(rsSearch1, sSql, dbOpenSnapshot)) Then
        If (rsSearch1.RecordCount > 0) Then
            GetManafacturerCode = rsSearch1!IMBSBC
        End If
    End If
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

'' Loads last position of window or default position
Public Sub SetWindowPosition(pForm As Form)
    Dim Left As Double
    Dim Top As Double
    Dim Width As Double
    Dim Height As Double
    Dim WindowState As Long
    Left = GetSetting(App.EXEName, "Forms", pForm.name & ".Left", -1)
    Top = GetSetting(App.EXEName, "Forms", pForm.name & ".Top", -1)
    Width = GetSetting(App.EXEName, "Forms", pForm.name & ".Width", -1)
    Height = GetSetting(App.EXEName, "Forms", pForm.name & ".Height", -1)
    WindowState = GetSetting(App.EXEName, "Forms", pForm.name & ".WindowState", vbNormal)
    pForm.WindowState = WindowState
    If (WindowState = vbNormal) Then
    
        If (Width <> -1 And Height <> -1) Then
            pForm.Width = Width
            pForm.Height = Height
        End If
        If (Left <> -1 And Top <> -1) Then
            pForm.Left = Left
            pForm.Top = Top
        Else
            Call GlobalFunctions.MDICenterScreen(pForm)
        End If
    End If
End Sub

'' Saves last position of window, so it can be restored when opened again
Public Sub GetWindowPosition(pForm As Form)
    Call SaveSetting(App.EXEName, "Forms", pForm.name & ".Width", pForm.Width)
    Call SaveSetting(App.EXEName, "Forms", pForm.name & ".Height", pForm.Height)
    Call SaveSetting(App.EXEName, "Forms", pForm.name & ".Left", pForm.Left)
    Call SaveSetting(App.EXEName, "Forms", pForm.name & ".Top", pForm.Top)
    Call SaveSetting(App.EXEName, "Forms", pForm.name & ".WindowState", pForm.WindowState)
End Sub

