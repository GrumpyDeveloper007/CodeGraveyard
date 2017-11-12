Attribute VB_Name = "ProjectNameMain"
Option Explicit
''*************************************************************************
'' Main Object
''
'' Coded by Dale Pitman


Private Type SystemSettingsTYPE
    Name As String
    Value As String
End Type

Private vSystemSettings() As SystemSettingsTYPE
Private vNumSystemSettings As Long
Private vCurrentUserID As Long

Public Sub CreateDBStructures()
    Dim rstemp As Recordset
    If (OpenRecordsetNOOutput(rstemp, "Setting", dbOpenTable)) Then
        
    Else
        Call Execute("CREATE TABLE [Setting] ( [rName] TEXT (30),[rValue] TEXT (50) )", True)
        Call Execute("CREATE TABLE [E_Employee] ( [UID] COUNTER ,[Name] TEXT (50),[Include] BIT,[UserID] LONG )", True)
        Call Execute("CREATE TABLE [E_EventAction] ( [UID] COUNTER ,[EventType] LONG,[EventSubType] LONG,[Action] LONG,[Address] LONG,[SubAddress] LONG )", True)
    End If
    
End Sub


Public Function GetCurrentUserID() As Long
    GetCurrentUserID = vCurrentUserID
End Function

''
Public Sub GlobalLogOnUser(pUserID As Long)
    vCurrentUserID = pUserID
End Sub

''
Public Function GetServerSetting(pName As String, pMultiUserEnable As Boolean) As String
    Dim i As Long
    Dim rstemp As Recordset
    GetServerSetting = ""
    For i = 0 To vNumSystemSettings - 1
        If (vSystemSettings(i).Name = pName) Then
            GetServerSetting = vSystemSettings(i).Value
            If (OpenRecordset(rstemp, "SELECT * FROM setting WHERE rname=" & cTextField & pName & cTextField, dbOpenDynaset)) Then
                If (rstemp.EOF = False) Then
                    GetServerSetting = Trim$(rstemp!rValue & "")
                End If
            End If
            Exit For
        End If
    Next
End Function

''
Public Sub SetServerSetting(pName As String, pValue As String)
    Dim i As Long
    Dim Found As Boolean
    For i = 0 To vNumSystemSettings - 1
        If (vSystemSettings(i).Name = pName) Then
            vSystemSettings(i).Value = pValue
            Found = True
            Exit For
        End If
    Next
    
    If (Found = False) Then
        Call Execute("INSERT INTO setting (rname,rvalue) VALUES (" & cTextField & pName & cTextField & "," & cTextField & pValue & cTextField & ")")
        'add to list
        Call LoadServerSettings
    Else
        Call Execute("UPDATE setting SET rvalue=" & cTextField & pValue & cTextField & " WHERE rname=" & cTextField & pName & cTextField)
    End If
End Sub

''
Private Function GetToken(ByRef pString As String, pDelimiter As String) As String
    GetToken = Left$(pString, InStr(pString, pDelimiter) - 1)
    pString = Right$(pString, Len(pString) - Len(GetToken) - 1)
End Function

''
Public Function Startup() As Boolean
    Dim rstemp As Recordset
    Dim i As Long
    ' Check for no user
'    If (OpenRecordset(rstemp, "SELECT * FROM [user]", dbOpenDynaset) = True) Then
'        If (rstemp.EOF = True) Then
'            Call rstemp.AddNew
'            rstemp!Name = "S"
'            rstemp!Password = ""
'
'            rstemp!MNUConfig = True
'            rstemp!MNUUserManager = True
'
'            Call rstemp.Update
'        End If
'        Call rstemp.Close
'    End If
    
    Call LoadServerSettings
   
    ' Load Titles
'    Call GlobalTitles.LoadTitles
   
    ' Load handling
'    Call LoadHandling
End Function

''
Private Sub LoadServerSettings()
    Dim rstemp As Recordset
    Dim i As Long
    ' Load system setting
    If (OpenRecordset(rstemp, "SELECT * FROM setting", dbOpenSnapshot) = True) Then
        If (rstemp.EOF = False) Then
            Call rstemp.MoveLast
            Call rstemp.MoveFirst
            ReDim vSystemSettings(rstemp.RecordCount)
            i = 0
            Do While (rstemp.EOF = False)
                vSystemSettings(i).Name = Trim$(rstemp!rName & "")
                vSystemSettings(i).Value = Trim$(rstemp!rValue & "")
                i = i + 1
                Call rstemp.MoveNext
            Loop
            vNumSystemSettings = i - 1
            Call rstemp.Close
        Else
            vNumSystemSettings = -1
        End If
    End If
End Sub

''
Public Function Shutdown() As Boolean
    End
End Function




