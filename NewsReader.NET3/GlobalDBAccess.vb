Option Strict Off
Option Explicit On
Module GlobalDBAccess
	''*************************************************************************
	''
	'' Coded by Dale Pitman
	''
	
	
	'Public Function GetGroupName(pUID As Long) As String
	'    Dim rsGroup As Recordset
	'    GetGroupName = ""
	'    If OpenRecordset(rsGroup, "SELECT * FROM [Group] WHERE UID=" & pUID, dbOpenSnapshot) Then
	'        If rsGroup.EOF = False Then
	'            GetGroupName = rsGroup!GroupName
	'        End If
	'    End If
	'End Function
	'
	Public Function GetGroupID(ByRef pName As String) As Integer
		Dim rsGroup As ADODB.Recordset
		GetGroupID = -1
		If OpenRecordset(rsGroup, "SELECT * FROM [Group] WHERE GroupName='" & pName & "'", dbOpenSnapshot) Then
			If rsGroup.EOF = False Then
				GetGroupID = rsGroup.Fields("UID").Value
			End If
		End If
	End Function
End Module