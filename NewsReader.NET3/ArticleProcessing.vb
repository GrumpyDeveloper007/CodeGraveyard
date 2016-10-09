Option Strict Off
Option Explicit On
Module ArticleProcessing
	''*************************************************************************
	''
	'' Coded by Dale Pitman
	''
	
	'' Scan through the file table looking for matches to the autohide table, set hide status if match
	Public Sub ProcessAutoHide(ByRef pGroupType As Integer)
		Dim rstemp As ADODB.Recordset
		Dim rsAutoHide As ADODB.Recordset
		Dim i As Integer
		Dim FileName As String
		Dim clsArticleProcessor As New cArticleProcessing
		Dim Hidden As Boolean
		
		
		MDIMain.LBLAction.Text = "Processing Autohides"
		If (OpenRecordset(rsAutoHide, "SELECT * FROM [AutoHide]", dbOpenSnapshot)) Then
			
		End If
		
		'If (rsAutoHide.EOF = False) Then
		i = 0
		If (OpenRecordset(rstemp, "SELECT * FROM [File] WHERE Hide=False AND GroupTypeID=" & pGroupType, dbOpenDynaset)) Then
			Do While (rstemp.EOF = False)
				Hidden = False
				If i Mod 50 = 0 Then
					MDIMain.LBLAction.Text = "Processing Autohides - " & i
				End If
				i = i + 1
				If rstemp.Fields("FileName").Value <> "" Then
					FileName = clsArticleProcessor.GetFileNameWithNoExtenstion(rstemp.Fields("FileName").Value)
					
					If InStr(1, rstemp.Fields("FileName").Value, ".EXE", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("FileName").Value, "german", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("Name").Value, "german", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("FileName").Value, "nordic", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("Name").Value, "nordic", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("Name").Value, "vip pw", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("FileName").Value, "vip pw", CompareMethod.Text) > 0 Then
						rstemp.Fields("Hide").Value = True
						rstemp.Update()
						Hidden = True
					End If
					
					
					If MDIMain.CBOGroupType.Text = "Console" Then
						If UCase(Left(rstemp.Fields("FileName").Value, 4)) = "SYN-" Or UCase(Left(rstemp.Fields("FileName").Value, 4)) = "VOR-" Or UCase(Left(rstemp.Fields("FileName").Value, 4)) = "GMB-" Or UCase(Left(rstemp.Fields("FileName").Value, 4)) = "DMZ-" Then
							rstemp.Fields("Hide").Value = True
							rstemp.Update()
							Hidden = True
						Else
							If UCase(Left(rstemp.Fields("FileName").Value, 3)) = "QF-" Or UCase(Left(rstemp.Fields("FileName").Value, 2)) = "P-" Then
								rstemp.Fields("Hide").Value = True
								rstemp.Update()
								Hidden = True
							Else
								If InStr(1, rstemp.Fields("FileName").Value, "JPN", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("Name").Value, "JPN", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("FileName").Value, "JAP", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("Name").Value, "JAP", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("FileName").Value, "USA", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("Name").Value, "USA", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("FileName").Value, "NTSC", CompareMethod.Text) > 0 Or InStr(1, rstemp.Fields("Name").Value, "NTSC", CompareMethod.Text) > 0 Then
									rstemp.Fields("Hide").Value = True
									rstemp.Update()
									Hidden = True
								Else
								End If
							End If
						End If
					End If
					
					
					If Hidden = False Then
						If (InStr(1, rstemp.Fields("Name").Value & FileName, ".xvid", CompareMethod.Text) > 0 And FRMOptions.FilterXVID) Or (InStr(1, rstemp.Fields("Name").Value & FileName, ".svcd", CompareMethod.Text) > 0 And FRMOptions.FilterSVCD) Then
							rstemp.Fields("Hide").Value = True
							rstemp.Update()
						Else
							If (rsAutoHide.EOF = False) Then
								Call rsAutoHide.MoveFirst()
								Do While (rsAutoHide.EOF = False)
									If FileName = rsAutoHide.Fields("FileName").Value Then
										rstemp.Fields("Hide").Value = True
										rstemp.Update()
										Exit Do
									End If
									Call rsAutoHide.MoveNext()
								Loop 
							End If
						End If
					End If
				End If
				
				
				Call rstemp.MoveNext()
				System.Windows.Forms.Application.DoEvents()
			Loop 
			
		End If
		'End If
	End Sub
End Module