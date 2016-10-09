Option Strict Off
Option Explicit On
Module ProjectNameMain
	''*************************************************************************
	'' Main Object
	''
	'' Coded by Dale Pitman
	
	
	Private Structure SystemSettingsTYPE
		Dim Name As String
		Dim Value As String
	End Structure
	
	Private vSystemSettings() As SystemSettingsTYPE
	Private vNumSystemSettings As Integer
	Private vCurrentUserID As Integer
	
	
	Public Function GetCurrentUserID() As Integer
		GetCurrentUserID = vCurrentUserID
	End Function
	
	''
	Public Sub GlobalLogOnUser(ByRef pUserID As Integer)
		vCurrentUserID = pUserID
	End Sub
	
	''
	Public Function GetServerSetting(ByRef pName As String, ByRef pMultiUserEnable As Boolean) As String
		Dim i As Integer
		Dim rstemp As ADODB.Recordset
		GetServerSetting = ""
		For i = 0 To vNumSystemSettings
			If (vSystemSettings(i).Name = pName) Then
				GetServerSetting = vSystemSettings(i).Value
				If (OpenRecordset(rstemp, "SELECT * FROM setting WHERE rname=" & cTextField & pName & cTextField, dbOpenDynaset)) Then
					If (rstemp.EOF = False) Then
						GetServerSetting = Trim(rstemp.Fields("rValue").Value & "")
					End If
				End If
				Exit For
			End If
		Next 
	End Function
	
	''
	Public Sub SetServerSetting(ByRef pName As String, ByRef pValue As String)
		Dim i As Integer
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
			Call LoadServerSettings()
		Else
			Call Execute("UPDATE setting SET rvalue=" & cTextField & pValue & cTextField & " WHERE rname=" & cTextField & pName & cTextField)
		End If
	End Sub
	
	''
	Private Function GetToken(ByRef pString As String, ByRef pDelimiter As String) As String
		GetToken = Left(pString, InStr(pString, pDelimiter) - 1)
		pString = Right(pString, Len(pString) - Len(GetToken) - 1)
	End Function
	
	''
	Public Function Startup() As Boolean
		' Check for no user
		
		Call LoadServerSettings()
		
		
	End Function
	
	
	''
	Private Sub LoadServerSettings()
		Dim rstemp As ADODB.Recordset
		Dim i As Integer
		' Load system setting
		If (OpenRecordset(rstemp, "SELECT * FROM setting", dbOpenSnapshot) = True) Then
			If (rstemp.EOF = False) Then
				Call rstemp.MoveLast()
				Call rstemp.MoveFirst()
				ReDim vSystemSettings(rstemp.RecordCount)
				i = 0
				Do While (rstemp.EOF = False)
					vSystemSettings(i).Name = Trim(rstemp.Fields("rName").Value & "")
					vSystemSettings(i).Value = Trim(rstemp.Fields("rValue").Value & "")
					i = i + 1
					Call rstemp.MoveNext()
				Loop 
				vNumSystemSettings = i - 1
				Call rstemp.Close()
			Else
				vNumSystemSettings = -1
			End If
		End If
	End Sub
	
	''
	Public Function Shutdown() As Boolean
		End
	End Function
End Module