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
Public Function GetServerSetting(pName As String, pMultiUserEnable As Boolean) As String
    Dim i As Long
    Dim rstemp As Recordset
    GetServerSetting = ""
    For i = 0 To vNumSystemSettings
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
    For i = 0 To vNumSystemSettings
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
    If (OpenRecordset(rstemp, "SELECT * FROM [user]", dbOpenDynaset) = True) Then
        If (rstemp.EOF = True) Then
            Call rstemp.AddNew
            rstemp!Name = "S"
            rstemp!Password = ""
            
'            rstemp!MNUSales = True
'            rstemp!MNUSalesEntry = True
            rstemp!MNUConfig = True
            rstemp!MNUUserManager = True
            
            Call rstemp.Update
        End If
        Call rstemp.Close
    End If
    
    Call LoadServerSettings
   
    ' Load Titles
    Call GlobalTitles.LoadTitles
   
    ' Setup GBMailing
'    If (Val(GetServerSetting("ENABLE_GBMAILING")) = 1) Then
'        If (FRMuGBMailing.ConnectGBMailing()) Then
'        Else
'            ' Failed to init gbmailing
'            Call Messagebox("Unable To Load GBMailing", vbExclamation)
'        End If
'    End If
    
    ' Load handling
'    Call LoadHandling
End Function

Public Sub LoadHandling()
    Dim i As Long
    Dim rstemp As Recordset
    FRMContextMenu.ShowHandlingPopupMenu = False
    Call FRMContextMenu.Show
    Call FRMContextMenu.Hide
    If (OpenRecordset(rstemp, "SELECT * FROM handling ORDER BY [name]", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            i = 0
            FRMContextMenu.ShowHandlingPopupMenu = True
            
            Do While (rstemp.EOF = False)
                If (FRMContextMenu.MNUHandlingItem.Count - 1 < i) Then
                    Call Load(FRMContextMenu.MNUHandlingItem(i))
                End If
                FRMContextMenu.MNUHandlingItem(i).Caption = Trim$(rstemp!Name & "")
                FRMContextMenu.MNUHandlingItem(i).Tag = Val(rstemp!cost & "")
            
                Call rstemp.MoveNext
                i = i + 1
            Loop
            
            ' Unload any unnessary menu items
            Do While (FRMContextMenu.MNUHandlingItem.Count > i)
                FRMContextMenu.MNUHandlingItem(i).Visible = False
                i = i + 1
            Loop
        End If
    End If
    

End Sub

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
'    If (Val(GetServerSetting("ENABLE_GBMAILING")) = 1) Then
'        Call FRMuGBMailing.CloseGBMailing
'    End If
    End
End Function

