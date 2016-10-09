Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class frmIMDBHolder
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' This form is designed to look up imdb tags in description and convert them to film names
	''
	'' Coded by Dale Pitman - PyroDesign
	
	Private m_IMDBFilmName As String
	Private m_IMDBSummary As String
	Private m_IMDBBuffer As String
	
	Private m_rxBuffer As String
	
	Public m_SearchForIMDB As Boolean
	
	
	'' Just search for any numeric string >7 chars
	Private Function GetIMDBNumber(ByRef pString As String) As String
		Dim FoundChars As Integer
		Dim IMDBStart As Integer
		Dim i As Integer
		IMDBStart = -1
		GetIMDBNumber = ""
		For i = 1 To Len(pString)
			If (IsNumeric_Renamed(Mid(pString, i, 1)) = True) Then
				FoundChars = FoundChars + 1
			Else
				If (IMDBStart > -1 And FoundChars > 6) Then
					GetIMDBNumber = VB6.Format(Mid(pString, IMDBStart + 1, i - IMDBStart - 1), "0000000")
					Exit For
				End If
				FoundChars = 0
			End If
			
			If (FoundChars > 4) Then
				IMDBStart = i - FoundChars
			End If
		Next 
	End Function
	
	Private Sub WinsockHttp_DataArrival(ByVal bytesTotal As Integer)
		Dim rcv As String
		On Error Resume Next
		'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.GetData. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		WinsockHttp.GetData(rcv, VariantType.String)
		On Error GoTo 0
		
		m_IMDBBuffer = m_IMDBBuffer & rcv
		m_rxBuffer = m_IMDBBuffer
		'' Look for the film name
		Dim TitlePos As Integer
		Dim PlotSummaryPos As Integer
		
		TitlePos = InStr(m_IMDBBuffer, "<title>")
		PlotSummaryPos = InStr(m_IMDBBuffer, "Plot Summary:")
		If (TitlePos > 0) Then
			TitlePos = TitlePos + 7
			m_IMDBFilmName = Mid(m_IMDBBuffer, TitlePos, InStr(TitlePos, m_IMDBBuffer, "</title>") - TitlePos)
			If (PlotSummaryPos > 0) Then
				If (InStr(PlotSummaryPos, m_IMDBBuffer, vbLf) > 0) Then
					PlotSummaryPos = PlotSummaryPos + 13 + 4
					m_IMDBSummary = Mid(m_IMDBBuffer, PlotSummaryPos, InStr(PlotSummaryPos, m_IMDBBuffer, vbLf) - PlotSummaryPos)
					'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.Close. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					WinsockHttp.Close()
				End If
			End If
		End If
		'<title>Koroshiya 1 (2001)</title>
		'Plot Summary:
	End Sub
	
	Public Sub CMDGetIMDBTags_Click()
		Dim sckClosing As Object
		Dim sckConnecting As Object
		Dim sckClosed As Object
		Dim co As String
		
		Dim rstemp As ADODB.Recordset
		Dim tempstring As String
		Dim i As Integer
		
		Dim IMDBCacheNumber(2000) As String
		Dim IMDBCacheName(2000) As String
		Dim IMDBCacheSummary(2000) As String
		Dim IMDBCacheMax As Integer
		Dim t As Integer
		Dim DontCache As Boolean
		
		If m_SearchForIMDB = True Then
			
			MDIMain.LBLAction.Text = "Searching for IMDB tags"
			
			i = 0
			If (OpenRecordset(rstemp, "SELECT * FROM  File WHERE IMDBSearchDone=false AND grouptypeid=" & FRMMain.m_GroupTypeID & " ORDER BY Name", dbOpenDynaset)) Then
				Do While (rstemp.EOF = False)
					MDIMain.LBLProgress(0).Text = i & "(" & rstemp.RecordCount & ")"
					i = i + 1
					tempstring = GetIMDBNumber(rstemp.Fields("Name").Value)
					If (tempstring = "") Then
						' try filename
						tempstring = GetIMDBNumber(rstemp.Fields("FileName").Value)
					End If
					
					If (tempstring <> "") Then
						m_IMDBFilmName = ""
						m_IMDBBuffer = ""
						m_IMDBSummary = ""
						m_rxBuffer = ""
						
						'Search cache
						DontCache = False
						For t = 0 To IMDBCacheMax - 1
							If (tempstring = IMDBCacheNumber(t)) Then
								DontCache = True
								m_IMDBFilmName = IMDBCacheName(t)
								m_IMDBSummary = IMDBCacheSummary(t)
							End If
						Next 
						
						
						If (DontCache = False) Then
retry: 
							'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.State. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							If (WinsockHttp.State <> sckClosed) Then
								'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.Close. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
								Call WinsockHttp.Close()
							End If
							'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.Connect. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							Call WinsockHttp.Connect()
							'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.State. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							Do While (WinsockHttp.State <= sckConnecting)
								System.Windows.Forms.Application.DoEvents()
							Loop 
							'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.State. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							If WinsockHttp.State = 8 Then
								GoTo retry
							End If
							'Call WinsockHttp.SendData("GET /Title?" & tempstring & " HTTP/1.1" & vbCrLf & "Host: www.imdb.com" & vbCrLf & "User-Agent: Mozilla/5.0 (WinNT)" & vbCrLf & vbCrLf)
							'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.SendData. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							Call WinsockHttp.SendData("GET /title/tt" & tempstring & "/ HTTP/1.1" & vbCrLf & "Host: www.imdb.com" & vbCrLf & "User-Agent: Mozilla/5.0 (WinNT)" & vbCrLf & vbCrLf)
							'http://www.imdb.com/title/tt0304711/
							'
							'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.State. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							Do While (WinsockHttp.State <> sckClosed And WinsockHttp.State <> sckClosing And m_IMDBFilmName = "")
								System.Windows.Forms.Application.DoEvents()
							Loop 
							'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.State. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							If (WinsockHttp.State <> sckClosed) Then
								'UPGRADE_WARNING: Couldn't resolve default property of object WinsockHttp.Close. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
								Call WinsockHttp.Close()
							End If
						End If
						
						
						If (m_IMDBFilmName <> "" And VB.Left(m_IMDBFilmName, 4) <> "503 " And VB.Left(m_IMDBFilmName, 4) <> "302 ") Then
							
							rstemp.Fields("IMDBName").Value = VB.Left(m_IMDBFilmName, 50)
							rstemp.Fields("IMDBNumber").Value = tempstring
							rstemp.Fields("imdbsearchdone").Value = True
							Call rstemp.Update()
							
							If (DontCache = False) Then
								IMDBCacheNumber(IMDBCacheMax) = tempstring
								IMDBCacheName(IMDBCacheMax) = m_IMDBFilmName
								IMDBCacheSummary(IMDBCacheMax) = m_IMDBSummary
								IMDBCacheMax = IMDBCacheMax + 1
							End If
						Else
							' If it is not found
							If (VB.Left(m_IMDBFilmName, 4) <> "302 ") Then
								rstemp.Fields("imdbsearchdone").Value = True
								Call rstemp.Update()
							End If
							
						End If
						
					End If
					Call rstemp.MoveNext()
					
				Loop 
			End If
			MDIMain.LBLProgress(0).Text = "Done"
			MDIMain.LBLAction.Text = "Done searching for IMDB tags"
			m_rxBuffer = ""
		End If
		'"User-Agent: Sam Spade 1.14"'
	End Sub
End Class