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


Public Function GetCurrentUserID() As Long
    GetCurrentUserID = vCurrentUserID
End Function

''
Public Sub GlobalLogOnUser(pUserID As Long)
    vCurrentUserID = pUserID
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
    Dim Found As Boolean
    For i = 0 To vNumSystemSettings
        If (vSystemSettings(i).Name = pName) Then
            vSystemSettings(i).Value = pValue
            Found = True
            Exit For
        End If
    Next
    
    If (Found = False) Then
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
    ' Check for no users
    
    
 '   If (OpenRecordset(rstemp, "SELECT * FROM [users]", dbOpenDynaset) = True) Then
'        If (rstemp.EOF = True) Then
'            Call rstemp.AddNew
'            rstemp!Name = "S"
'            rstemp!Password = ""
'
'            rstemp!MNUSales = True
'            rstemp!MNUSalesEntry = True
'            rstemp!MNUConfig = True
'            rstemp!MNUUserManager = True
'
'            Call rstemp.Update
'        End If
'        Call rstemp.Close
'    End If
    
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
    
    ' Setup GBMailing
'    If (Val(GetServerSetting("ENABLE_GBMAILING")) = 1) Then
'        If (FRMuGBMailing.ConnectGBMailing()) Then
'        Else
'            ' Failed to init gbmailing
'            Call Messagebox("Unable To Load GBMailing", vbExclamation)
'        End If
'    End If
    
End Function

''
Public Function Shutdown() As Boolean
'    If (Val(GetServerSetting("ENABLE_GBMAILING")) = 1) Then
'        Call FRMuGBMailing.CloseGBMailing
'    End If
    End
End Function

''
Public Function FormatContext(pContext As Object, pWidth As Double, pText As String) As String
    Dim tempstring As String
    Dim i As Long
    Dim c As String
    
    i = 1
    
    
    tempstring = ""
    Do While (i <= Len(pText))
        c = Mid$(pText, i, 1)
        If (pContext.TextWidth(tempstring & c) < pWidth) Then
            tempstring = tempstring & c
        Else
            If (InStrRev(tempstring, " ") > 0) Then
                FormatContext = FormatContext & Left$(tempstring, InStrRev(tempstring, " ")) & vbCrLf
                tempstring = Right$(tempstring, Len(tempstring) - InStrRev(tempstring, " ")) & c
            Else
                tempstring = tempstring & vbCrLf & c
            End If
        End If
        i = i + 1
    Loop
    
    FormatContext = FormatContext & tempstring
End Function




