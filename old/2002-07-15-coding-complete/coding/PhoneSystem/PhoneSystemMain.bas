Attribute VB_Name = "PhoneSystemMain"
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


Public Function GetCurrentUserID() As Long
    GetCurrentUserID = vCurrentUserID
End Function

''
Public Sub GlobalLogOnUser(pUserID As Long)
    vCurrentUserID = pUserID
End Sub

''
Public Function GetWorkstationSetting(pName As String) As String
    GetWorkstationSetting = GetSetting(cRegistoryName, "SETTINGS", pName, "")
End Function

''
Public Sub SetWorkstationSetting(pName As String, pValue As String)
    Call SaveSetting(cRegistoryName, "SETTINGS", pName, pValue)
End Sub

''
Public Function GetServerSetting(pName As String) As String
    Dim i As Long
    GetServerSetting = ""
    For i = 0 To vNumSystemSettings
        If (vSystemSettings(i).Name = pName) Then
            GetServerSetting = vSystemSettings(i).Value
            Exit For
        End If
    Next
End Function

''
Public Sub SetServerSetting(pName As String, pValue As String)
    Dim i As Long
    Dim found As Boolean
    For i = 0 To vNumSystemSettings
        If (vSystemSettings(i).Name = pName) Then
            vSystemSettings(i).Value = pValue
            found = True
            Exit For
        End If
    Next
    
    If (found = False) Then
        Call Execute("INSERT INTO settings ([name],[value]) VALUES ('" & pName & "','" & pValue & "')")
    Else
        Call Execute("UPDATE settings SET [value]='" & pValue & "' WHERE name='" & pName & "'")
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
    
    ' Load system Settings
    If (OpenRecordset(rstemp, "SELECT * FROM [settings]", dbOpenSnapshot) = True) Then
        If (rstemp.EOF = False) Then
            Call rstemp.MoveLast
            Call rstemp.MoveFirst
            ReDim vSystemSettings(rstemp.RecordCount)
            i = 0
            Do While (rstemp.EOF = False)
                vSystemSettings(i).Name = rstemp!Name & ""
                vSystemSettings(i).Value = rstemp!Value & ""
                i = i + 1
                Call rstemp.MoveNext
            Loop
            vNumSystemSettings = i - 1
            Call rstemp.Close
        Else
            vNumSystemSettings = -1
        End If
    End If
End Function

''
Public Function Shutdown() As Boolean
    End
End Function


