Option Strict Off
Option Explicit On
Friend Class cNewsReader
	''*************************************************************************
	''
	'' Coded by Dale Pitman
	''
	
	'' The big news reader class, handles all winsock communcations and low level processing
	
    Public Event ProcessArticle(ByRef pArticleNumber As Long, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer)
    Public Event ProcessMissingArticle(ByRef pArticleNumber As Long, ByRef pGroupID As Integer)
	
    Public Event AddUpdateGroup(ByRef pName As String, ByRef pLowArticle As Long, ByRef pHighArticle As Long, ByRef pPostability As String)
	Public Event PacketRecieved(ByRef pNumber As Integer)
	Public Event CancelDownloadArticleExpired()
	Public Event UpdateRx(ByRef pData As String)
	Public Event TriggerDownloadFile(ByRef pNextRecord As Boolean)
	Public Event LogEvent(ByRef pName As String)
	Public Event ProcessAllGroupsList()
	Public Event ProcessAllArticleList()
	Public Event UpdateLastFileName(ByRef pfilename As String, ByRef pLastFileID As Integer)
	Public Event GetOutputSegmentSize(ByRef pOutputSegSize As Integer, ByRef pfilename As String, ByRef pLastFileID As Integer, ByRef pLastArticleIndex As Integer)
	Public Event MoveFile(ByRef pfilename As String, ByRef psubject As String)
	Public Event FileDownloadedSuccessfully(ByRef pLastFileID As Integer)
    Public Event GetLastArticleForGroup(ByRef pLastArticleID As Long, ByRef pGroupID As Integer, ByRef pServerID As Integer)
	
    Public Event GetNextMissingArticle(ByRef pArticleID As Long, ByRef pGroupID As Integer, ByRef pArticleNumber As Integer)
	
	'UPGRADE_ISSUE: Winsock object was not upgraded. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6B85A2A7-FE9F-4FBE-AA0C-CF11AC86A305"'
    Private WithEvents clsWinsock As New AxMSWinsockLib.AxWinsock
	Private m_BitmapProcessor As New cBitmapProcessor
	Private m_Index As Integer ' Used to identify this class
	
	Private m_BinaryBuffer() As Byte '5000000
	Public m_BinaryBufferMax As Integer
	Private m_lngStart As Integer
	
	Public Enum AutoActionENUM
		None = 0
		DownloadFiles = 1
		GetNewArticles = 2
		GetAllGroups = 3
	End Enum
	
	Public m_AutoAction As AutoActionENUM
	
	Public m_blnDownloadingMp3 As Boolean
	
	Private m_FileIndex As Integer ' So the parent know what is being downloaded
	
	'internal variables
	Private m_ProcessingWinsock As Boolean '' Used to stop processing 2 packets at once (event within current event)
	Private m_PacketNumber As Integer '' Simple count of the number of packets
	Public m_LinesProcessed As Integer '' When reading new article lists
	Private m_rxBuffer As String
	Public m_SelectedGroupID As Integer '' Used to keep track of the group the reader is attached to
	Public m_LinesExpected As Integer
	Private m_ArticleStartTime As Date ' start time of article download
	Public m_lastarticleDuration As Integer ' Total time to process last article
	Public m_LastFileName As String
    Public m_LastArticleIndex As Long
    Public m_TotalArticles As Long
	Public m_LastFileSubject As String
	Public m_GroupName As String
    Public m_ArticleNumber As Long
	
	Public m_LastFileID As Integer
	
	Private Structure ArticleType
        Dim ArticleNumber As Long
		Dim Subject As String
		Dim LineCount As Integer
		Dim PostDate As Date
	End Structure
	
	Private m_Article As ArticleType
    Private m_LastArticleID As Long
	Private m_GetMissingArticles As Boolean
    Private m_MissingArticleID As Long
	
	Private m_ConnectionRetrys As Integer
	
	
	'server
	Dim SendUsername As Boolean 'flag whether sending login name required
	Dim SendPassword As Boolean 'flag whether sending login password required
	Dim Username1 As String 'username if required
	Dim Password1 As String 'password if required
	
	'newsgroup
    Dim ArticleCount1 As Long  'estimated number of articles in selected newsgroup
    Dim FirstArticle1 As Long 'first article in selected newsgroup
    Dim LastArticle1 As Long  'last article in selected newsgroup
	
	'other
	Dim State1 As TNNTPState 'current state of control
	
	'control states
	Public Enum TNNTPState
		NNTP_STAT_DISCONNECTED = 0 'disconnected
		NNTP_STAT_DISCONNECTING = 1 'disconnecting
		NNTP_STAT_CONNECTED = 2 'connected (idle)
		NNTP_STAT_CONNECTING = 3 'connecting
		NNTP_STAT_SELECTING = 4 'selecting newsgroup
		NNTP_STAT_GETLIST = 5 'receiving newsgroups
		NNTP_STAT_GETXOVER = 6 'receiving headers
		NNTP_STAT_GETSTAT = 7 'receiving article state
		NNTP_STAT_GETARTICLE = 8 'receiving article
		NNTP_STAT_GETHEADER = 9 'receiving header
		NNTP_STAT_GETBODY = 10 'receiving body
		NNTP_STAT_GOTOLAST = 11 'seeking previous article
		NNTP_STAT_GOTONEXT = 12 'seeking next article
		NNTP_STAT_POSTING = 13 'posting
	End Enum
	
	'return codes
	Public Enum TNNTPRc
		NNTP_RC_NONE = 0
		NNTP_RC_NOTCONNECTED = 1
		NNTP_RC_HOSTNOTFOUND = 2
		NNTP_RC_BUSY = 3
		NNTP_RC_SOCKERR = 4
		NNTP_RC_CANCELED = 5
		NNTP_RC_TIMEOUT = 6
		NNTP_RC_POSTING = 200
		NNTP_RC_NOPOSTING = 201
		NNTP_RC_CLOSING = 205
		NNTP_RC_GROUPSELECTED = 211
		NNTP_RC_LIST = 215
		NNTP_RC_ARTICLE = 220
		NNTP_RC_HEAD = 221
		NNTP_RC_BODY = 222
		NNTP_RC_STAT = 223
		NNTP_RC_DATAFOLLOWS = 224
		NNTP_RC_NEWARTICLES = 230
		NNTP_RC_NEWGROUPS = 231
		NNTP_RC_TRANSFERRED = 235
		NNTP_RC_POSTEDOK = 240
		NNTP_RC_AUTHENTICATIONACCEPTED = 281
		NNTP_RC_SENDARTICLETRANSFERRED = 335
		NNTP_RC_SENDARTICLE = 340
		NNTP_RC_MOREAUTHENTICATIONREQUIRED = 381
		NNTP_RC_SERVICEDISCONTINUED = 400
		NNTP_RC_NOSUCHNEWSGROUP = 411
		NNTP_RC_NOTINANEWSGROUP = 412
		NNTP_RC_NOARTICLESELECTED = 420
		NNTP_RC_NONEXTARTICLE = 421
		NNTP_RC_NOLASTARTICLE = 422
		NNTP_RC_BADARTICLENUMBER = 423
		NNTP_RC_ARTICLENOTFOUND = 430
		NNTP_RC_DONTSEND = 435
		NNTP_RC_TRANSFERFAILED = 436
		NNTP_RC_ARTICLEREJECTED = 437
		NNTP_RC_POSTINGNOTALLOWD = 440
		NNTP_RC_POSTINGFAILED = 441
		NNTP_RC_AUTHENTICATIONREQUIRED = 480
		NNTP_RC_AUTHENTICATIONREJECTED = 482
		NNTP_RC_NOSUCHCOMMAND = 500
		NNTP_RC_SYNTAXERROR = 501
		NNTP_RC_ACCESSRESTRICTED = 502
		NNTP_RC_PROGRAMNOTFAULT = 503
		NNTP_RC_CONNECTIONFAILURE1 = 504
		NNTP_RC_CONNECTIONFAILURE2 = 505
	End Enum
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Properties
	
	
	Public Property FileIndex() As Integer
		Get
			FileIndex = m_FileIndex
		End Get
		Set(ByVal Value As Integer)
			m_FileIndex = Value
		End Set
	End Property
	
	
	Public Property Index() As Integer
		Get
			Index = m_Index
		End Get
		Set(ByVal Value As Integer)
			m_Index = Value
		End Set
	End Property
	
	Public ReadOnly Property BinaryBuffer() As Byte()
		Get
			BinaryBuffer = VB6.CopyArray(m_BinaryBuffer)
		End Get
	End Property
	
    Public ReadOnly Property ArticleNumber() As Long
        Get
            ArticleNumber = m_Article.ArticleNumber
        End Get
    End Property
	
	Public ReadOnly Property ArticleLineCount() As Integer
		Get
			ArticleLineCount = m_Article.LineCount
		End Get
	End Property
	
	Public ReadOnly Property ArticlePostDate() As Date
		Get
			ArticlePostDate = m_Article.PostDate
		End Get
	End Property
	
	Public ReadOnly Property ArticleSubject() As String
		Get
			ArticleSubject = m_Article.Subject
		End Get
	End Property
	
	
	Public Property GetMissingArticles() As Boolean
		Get
			GetMissingArticles = m_GetMissingArticles
		End Get
		Set(ByVal Value As Boolean)
			m_GetMissingArticles = Value
		End Set
	End Property
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	''
	
    Public Sub SetWinsock(ByRef pWinsock As AxMSWinsockLib.AxWinsock)
        clsWinsock = pWinsock
    End Sub
	
	'UPGRADE_NOTE: Class_Initialize was upgraded to Class_Initialize_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
	Private Sub Class_Initialize_Renamed()
		ReDim Preserve m_BinaryBuffer(260000)
	End Sub
	Public Sub New()
		MyBase.New()
		Class_Initialize_Renamed()
	End Sub
	
    Private Sub clsWinsock_Close(ByVal sender As Object, ByVal e As System.EventArgs) Handles clsWinsock.CloseEvent
        If m_AutoAction <> AutoActionENUM.None Then
            '        RaiseEvent StatusChanged("Closed")
            Call Connect()
        End If
    End Sub
	
    Private Sub clsWinsock_DataArrival(ByVal sender As System.Object, ByVal e As AxMSWinsockLib.DMSWinsockControlEvents_DataArrivalEvent) Handles clsWinsock.DataArrival
        Static rcv As String
        Static i As Integer
        Static bytedata() As Byte
        Static SplitLine() As String
        Static lngStart As Integer
        Dim BytesTotal As Integer
        BytesTotal = e.bytesTotal

        Try

            lngStart = GetTickCount
            If m_ProcessingWinsock = False Then
                m_ProcessingWinsock = True

                If BytesTotal > 0 Then

                    'get received data
                    rcv = ""
                    'UPGRADE_WARNING: Couldn't resolve default property of object clsWinsock.GetData. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
                    clsWinsock.GetData(bytedata)

                    If State1 = TNNTPState.NNTP_STAT_GETBODY Or State1 = TNNTPState.NNTP_STAT_GETXOVER Or State1 = TNNTPState.NNTP_STAT_GETLIST Then
                        ' copy buffer
                        If m_BinaryBufferMax + UBound(bytedata) + 1 > UBound(m_BinaryBuffer) Then
                            ReDim Preserve m_BinaryBuffer(m_BinaryBufferMax + UBound(bytedata) + 1)
                        End If
                        Call CopyArray(bytedata, UBound(bytedata) + 1, m_BinaryBuffer, m_BinaryBufferMax)
                        m_BinaryBufferMax = m_BinaryBufferMax + UBound(bytedata) + 1
                    Else
                        For i = 0 To UBound(bytedata)
                            If State1 <> TNNTPState.NNTP_STAT_GETBODY And State1 <> TNNTPState.NNTP_STAT_GETXOVER Then
                                rcv = rcv & Chr(bytedata(i))
                            End If
                        Next
                        RaiseEvent UpdateRx(rcv)
                    End If

                    m_BytesFor2Second = m_BytesFor2Second + BytesTotal

                    m_WSTime = m_WSTime + GetTickCount - lngStart

                    Select Case State1
                        Case TNNTPState.NNTP_STAT_GETBODY
                            m_PacketNumber = m_PacketNumber + 1
                            RaiseEvent PacketRecieved(m_PacketNumber)

                            If UBound(bytedata) > 3 Then
                                If bytedata(0) = Asc("4") And bytedata(1) = Asc("2") And bytedata(2) = Asc("3") And bytedata(3) = Asc(" ") Then
                                    '                            If FRMOptions.UseAlternateServer = True Then
                                    '                                If m_GetMissingArticles = False Then
                                    '                                    m_GetMissingArticles = True
                                    '                                    Call Connect
                                    '                                Else
                                    '                                    m_GetMissingArticles = False
                                    '                                    Call Connect
                                    '                                    RaiseEvent CancelDownloadArticleExpired
                                    '                                End If

                                    '                            Else
                                    RaiseEvent CancelDownloadArticleExpired()
                                    '                            End If
                                End If
                            End If

                            Call ProcessArticleBody()
                        Case TNNTPState.NNTP_STAT_GETLIST
                            Call ProcessGroupList()
                        Case TNNTPState.NNTP_STAT_GETXOVER
                            Call ProcessArticleList()
                        Case TNNTPState.NNTP_STAT_CONNECTING
                            If SendUsername = False And SendPassword = False Then
                                State1 = TNNTPState.NNTP_STAT_CONNECTED
                                If (m_AutoAction = AutoActionENUM.DownloadFiles) Then
                                    RaiseEvent TriggerDownloadFile(False)
                                Else
                                    If (m_AutoAction = AutoActionENUM.GetNewArticles) Then
                                        Call SelectGroup()
                                    Else
                                        If (m_AutoAction = AutoActionENUM.GetAllGroups) Then
                                            'set start/end times for statistics
                                            m_LinesProcessed = 0
                                            m_rxBuffer = ""

                                            State1 = TNNTPState.NNTP_STAT_GETLIST

                                            'all newsgroups (LIST)
                                            Call SendData(1, "LIST" & vbCrLf)
                                        End If
                                    End If
                                End If
                                'send username
                            Else
                                m_SelectedGroupID = -1
                                If SendUsername Then
                                    SendUsername = False
                                    Call SendData(1, "authinfo user " & Username1 & vbCrLf)
                                    'send password
                                Else
                                    If SendPassword Then
                                        SendPassword = False
                                        Call SendData(1, "authinfo pass " & Password1 & vbCrLf)
                                    End If
                                End If
                            End If

                        Case TNNTPState.NNTP_STAT_SELECTING
                            rcv = Replace(rcv, vbLf, "")
                            rcv = Replace(rcv, vbCr, "")
                            If rcv <> "" Then
                                SplitLine = Split(rcv)
                                'ok
                                If SplitLine(0) = CStr(TNNTPRc.NNTP_RC_GROUPSELECTED) Then
                                    m_ConnectionRetrys = 0
                                    State1 = TNNTPState.NNTP_STAT_CONNECTED
                                    ArticleCount1 = CLng(SplitLine(1))
                                    FirstArticle1 = CLng(SplitLine(2))
                                    LastArticle1 = CLng(SplitLine(3))

                                    If ArticleCount1 < 2000 Then
                                        SelectGroup()
                                    Else
                                        m_SelectedGroupID = GetGroupID(Replace(SplitLine(4), vbCrLf, ""))

                                        If m_GetMissingArticles = False Then
                                            ' Delete old articles
                                        Else
                                            '                                Call Execute("DELETE FROM article2 WHERE GroupID=" & m_SelectedGroupID & " AND ArticleNumber<" & FirstArticle1, True)
                                        End If

                                        If m_AutoAction = AutoActionENUM.DownloadFiles Then
                                            Call DownloadArticle(m_ArticleNumber)
                                        Else
                                            ' Only delete when getting new articles
                                            If ArticleCount1 > 20000 Then
                                                'Call Execute("DELETE FROM article WHERE GroupID=" & m_SelectedGroupID & " AND ArticleNumber<" & FirstArticle1 - 10000, True)
                                            End If

                                            If (m_AutoAction = AutoActionENUM.GetNewArticles) Then
                                                m_rxBuffer = ""
                                                If GetXover() = False Then
                                                    State1 = TNNTPState.NNTP_STAT_CONNECTED
                                                    RaiseEvent ProcessAllArticleList()
                                                End If

                                            End If
                                        End If
                                    End If
                                    'error
                                Else
                                    ' Group Does not exist
                                    State1 = TNNTPState.NNTP_STAT_CONNECTED
                                    ArticleCount1 = 0
                                    FirstArticle1 = 0
                                    LastArticle1 = 0
                                End If
                            End If

                        Case Else
                            'process data line by line
                    End Select
                End If
                m_ProcessingWinsock = False
            End If
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try

        m_TotalTime = m_TotalTime + GetTickCount - lngStart
    End Sub
	
    Private Sub clsWinsock_Error(ByVal sender As Object, ByVal e As AxMSWinsockLib.DMSWinsockControlEvents_ErrorEvent) Handles clsWinsock.Error
        'socket error (also raised when server not found)
        State1 = TNNTPState.NNTP_STAT_DISCONNECTED

        ' auto reconnect
        Call Connect()
    End Sub
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Public Interface
	
	Public Sub ResetBuffer()
		m_rxBuffer = ""
		m_PacketNumber = 0
		m_BinaryBufferMax = 0
	End Sub
	
	Public Sub SelectGroup()
		State1 = TNNTPState.NNTP_STAT_SELECTING
		Call SendData(1, "GROUP " & m_GroupName & vbCrLf)
	End Sub
	
    Public Sub DownloadArticle(ByRef pArticleNumber As Long)
        State1 = TNNTPState.NNTP_STAT_GETBODY
        m_ArticleStartTime = Now
        Call SendData(1, "BODY " & pArticleNumber & vbCrLf)
    End Sub
	
	Public Sub DownloadCompleted()
		State1 = TNNTPState.NNTP_STAT_CONNECTED
	End Sub
	
	'' First run function, setup state of class, so it can be restored through any event flow
	Public Function DGetNewArticles() As Boolean
		Dim rstemp As ADODB.Recordset
		
		m_ConnectionRetrys = 0
		
		m_LinesProcessed = 0
		m_rxBuffer = ""
		DGetNewArticles = False
		
		' Normal mode
		
		'Retrieving all available article headers
		m_AutoAction = AutoActionENUM.GetNewArticles
		Call Connect()
		DGetNewArticles = True
		
		
	End Function
	
	Public Sub DGetAllGroups()
		m_ConnectionRetrys = 0
		m_AutoAction = AutoActionENUM.GetAllGroups
		Call Connect()
	End Sub
	
	Public Sub dDownloadFiles()
		m_ConnectionRetrys = 0
		m_FileIndex = -1
		
		m_AutoAction = AutoActionENUM.DownloadFiles
		Call Connect()
	End Sub
	
	'' Gets a list of the new articles on the server
	Public Function GetXover() As Boolean
        Dim FirstArticle As Long
		Dim GroupID As Integer
        Dim ArticleNumber As Long
        Dim GroupFirstArticle As Long
		
		m_BinaryBufferMax = 0
		State1 = TNNTPState.NNTP_STAT_GETXOVER
		GroupFirstArticle = FirstArticle1
		
		' Normal operation
		m_LinesProcessed = 0
		If m_GetMissingArticles = False Then
			RaiseEvent GetLastArticleForGroup(FirstArticle, m_SelectedGroupID, 0)
		Else
			RaiseEvent GetLastArticleForGroup(FirstArticle, m_SelectedGroupID, 1)
		End If
		
		If FirstArticle <> 0 Then
			FirstArticle1 = FirstArticle
		End If
		
		' Get all
		m_LinesExpected = LastArticle1 - FirstArticle1
		
		'NextMacro = GetNextGroup
		If m_LinesExpected = 0 Then
			Call ProcessEndOfCommand()
		Else
			If GroupFirstArticle + (ArticleCount1 * (100# - FRMOptions.MaxArticleAge)) / 100# > FirstArticle1 Then
				FirstArticle1 = GroupFirstArticle + (ArticleCount1 * (100# - FRMOptions.MaxArticleAge)) / 100#
			End If
			
			m_LastArticleID = FirstArticle1 - 1
			Call SendData(1, "XOVER " & VB6.Format(FirstArticle1, "00000000") & "-" & vbCrLf)
		End If
		GetXover = True
	End Function
	
	Public Sub Connect()
		If m_ConnectionRetrys < FRMOptions.ConnectionAttempts Or FRMOptions.ConnectionAttempts = 0 Then
			m_ConnectionRetrys = m_ConnectionRetrys + 1
			
            clsWinsock.Close()
			
			If m_GetMissingArticles = False Then
				Username1 = FRMOptions.Username
				Password1 = FRMOptions.Password
                clsWinsock.RemoteHost = FRMOptions.ServerName
			Else
				Username1 = FRMOptions.BackupUsername
				Password1 = FRMOptions.BackupPassword
                clsWinsock.RemoteHost = FRMOptions.BackupServerName
			End If
			
            If clsWinsock.RemoteHost = "" Then
                Call MsgBox("No servername has been entered please go into 'options' and enter details", MsgBoxStyle.Exclamation, "Newsreader thread " & m_Index)
                Exit Sub
            End If
			
			m_SelectedGroupID = -1
			SendUsername = Username1 <> ""
			SendPassword = Password1 <> ""
			State1 = TNNTPState.NNTP_STAT_CONNECTING
			
            clsWinsock.RemotePort = 119 '9000 ' 7000, 8000, or 9000
            clsWinsock.Connect()
		Else
			m_AutoAction = AutoActionENUM.None
			RaiseEvent LogEvent("Connection retry Limit reached")
            MDIMain.LBLProgress(m_Index) = "Connection retry Limit reached"
		End If
	End Sub
	
	Public Sub Disconnect()
		'set start/end times for statistics
		m_AutoAction = AutoActionENUM.None
		State1 = TNNTPState.NNTP_STAT_DISCONNECTING
		Call SendData(1, "QUIT" & vbCrLf)
        clsWinsock.Close()
	End Sub
	
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Private functions
	
	Private Function NewsServerDateToDate(ByRef pString As String) As Date
		Dim AddValue As Integer
		Dim AddSec As Integer
		On Error GoTo dateError
		pString = Replace(pString, "GMT+1", "") ' do later
		pString = Replace(pString, "(AKST)", "") ' do later
		pString = Replace(pString, "(EST)", "") ' do later
		pString = Replace(pString, "(MST)", "") ' do later
		pString = Replace(pString, "(CET)", "") ' do later
		pString = Replace(pString, "(CST)", "") ' do later
		pString = Replace(pString, "(PST)", "") ' do later
		pString = Replace(pString, "(UTC)", "") ' do later
		pString = Replace(pString, "(GMT)", "")
		pString = Replace(pString, "(PDT)", "")
		pString = Replace(pString, "(JST)", "")
		pString = Replace(pString, "(KST)", "")
		
		pString = Replace(pString, "GMT", "")
		pString = Replace(pString, "PST", "") ' do later
		pString = Replace(pString, "AKST", "") ' do later
		pString = Replace(pString, "EST", "") ' do later
		pString = Replace(pString, "MST", "") ' do later
		pString = Replace(pString, "CET", "") ' do later
		pString = Replace(pString, "CST", "") ' do later
		pString = Replace(pString, "UTC", "") ' do later
		pString = Replace(pString, "PDT", "") ' do later
		
		pString = Replace(pString, "UT", "") ' do later
		'    pString = Replace(pString, "C", "") ' do later
		
		pString = Trim(pString)
		pString = Mid(pString, InStr(pString, ",") + 1)
		If (Mid(pString, Len(pString) - 4, 1) = "-" Or Mid(pString, Len(pString) - 4, 1) = "+") Then
			AddValue = CInt(Mid(pString, Len(pString) - 3, 2))
			AddSec = CInt(Mid(pString, Len(pString) - 1, 2))
			pString = Left(pString, Len(pString) - 5)
		Else
			AddValue = 0
			AddSec = 0
		End If
		'tempstring = Mid$(pString, 6, 2) & "/" & Mid$(pString, 9, 3) & "/" & Mid$(pString, 13, 4) & Mid$(pString, 17, 9)
		NewsServerDateToDate = CDate(pString)
		NewsServerDateToDate = DateAdd(Microsoft.VisualBasic.DateInterval.Month, AddSec, NewsServerDateToDate)
		NewsServerDateToDate = DateAdd(Microsoft.VisualBasic.DateInterval.Hour, AddValue, NewsServerDateToDate)
		Exit Function
dateError: 
		NewsServerDateToDate = Now
	End Function
	
	
	Private Function NextLine(ByRef pString As String, ByRef pBegin As Integer) As Integer
		NextLine = InStr(pBegin + 1, pString, vbCrLf)
		If (NextLine = 0) Then
			NextLine = InStr(pBegin + 1, pString, vbLf)
		End If
	End Function
	
	Private Sub SendData(ByRef pIndex As Short, ByRef pData As String)
		RaiseEvent LogEvent(pData)
		On Error Resume Next
        Call clsWinsock.SendData(pData)
    End Sub
	
	Private Function GetNextLine(ByRef pLineCursor As Integer) As Boolean
		Static i As Integer
		
		GetNextLine = False
		m_rxBuffer = CStr(0)
		If pLineCursor <= m_BinaryBufferMax Then
			m_rxBuffer = Chr(m_BinaryBuffer(pLineCursor))
			For i = pLineCursor + 1 To m_BinaryBufferMax
				m_rxBuffer = m_rxBuffer & Chr(m_BinaryBuffer(i))
				If m_BinaryBuffer(i) = 10 And m_BinaryBuffer(i - 1) = 13 Then 'Asc(vbLf)' Asc(vbCr)
					pLineCursor = i + 1
					GetNextLine = True
					Exit For
				End If
			Next 
		End If
	End Function
	
	'' Scans the binary buffer for (xover) article detail lines
	Private Sub ProcessArticleList()
		
		Static EndOfLine As Boolean
		Static TabPosition As Integer
		Static Tab2 As Integer
		Static Tab3 As Integer
		Static Tab4 As Integer
		Static Tab5 As Integer
		Static Tab6 As Integer
		Static Tab7 As Integer
		Static Tab8 As Integer
		Static LineCursor As Integer
		
		Static i As Integer
		Static t As Integer
		
		Static skipline As Boolean
		Static First4Chars As Integer
		
		Static StartLine As Integer
		Static lngStart As Integer
		
		'1814959
		'NNTP Monitor Test Message
		'NNTP-Monitor@cicprobe1.se.bredband.com
		'Mon, 13 Jan 2003 19:01:06 GMT
		'<S1EU9.38184$Y2.1550@news2.bredband.com>
		'914
		'1
		'Xref: newspeer1-gui.server.ntli.net alt.test:1814959
		'subject, author,date, message-id, references, byte count, and line count
		
		LineCursor = 0
		
		EndOfLine = True
		Do While EndOfLine = True
			lngStart = GetTickCount
			
			' Read in next line
			StartLine = LineCursor
			EndOfLine = False
			m_rxBuffer = ""
			
			m_rxBuffer = "                                                                                                                                                                                                                                                                                                            "
			'EndOfLine = ReadLine(m_BinaryBuffer, m_BinaryBufferMax, LineCursor, m_rxBuffer) = 0
			
			If LineCursor <= m_BinaryBufferMax Then
				m_rxBuffer = Chr(m_BinaryBuffer(LineCursor))
				For i = LineCursor + 1 To m_BinaryBufferMax
					m_rxBuffer = m_rxBuffer & Chr(m_BinaryBuffer(i))
					If m_BinaryBuffer(i - 1) = 13 And m_BinaryBuffer(i) = 10 Then 'Asc(vbLf)' Asc(vbCr)
						LineCursor = i + 1
						EndOfLine = True
						Exit For
					End If
				Next 
			End If
			
			m_LinesProcessed = m_LinesProcessed + 1
			skipline = Not EndOfLine
			
			
			If skipline = False Then
				
				If Left(m_rxBuffer, 1) = "." Then
					'If m_BinaryBuffer(StartLine) = 46 Then
					Exit Do
				Else
					If Mid(m_rxBuffer, 4, 1) = " " Then
						First4Chars = CInt(Left(m_rxBuffer, 4))
						If First4Chars = 224 Or First4Chars = 200 Or First4Chars = 381 Or First4Chars = 281 Or First4Chars = 420 Then
							skipline = True
						End If
						
						If First4Chars = 412 Then
							' Error
							State1 = TNNTPState.NNTP_STAT_CONNECTED
							skipline = True
						End If
					End If
					
					
					If skipline = False Then
						TabPosition = InStr(m_rxBuffer, vbTab)
						Tab2 = InStr(TabPosition + 1, m_rxBuffer, vbTab)
						
						' Check for invalid line data
						If Tab2 <> 0 Then
							Tab3 = InStr(Tab2 + 1, m_rxBuffer, vbTab)
							Tab4 = InStr(Tab3 + 1, m_rxBuffer, vbTab)
							If Tab4 <> 0 Then
								Tab5 = InStr(Tab4 + 1, m_rxBuffer, vbTab)
								Tab6 = InStr(Tab5 + 1, m_rxBuffer, vbTab)
								Tab7 = InStr(Tab6 + 1, m_rxBuffer, vbTab)
								
								Tab8 = InStr(Tab7 + 1, m_rxBuffer, vbTab)
								If Tab8 <> 0 Then
                                    m_Article.ArticleNumber = CLng(Mid(m_rxBuffer, 1, TabPosition - 1))
									
									m_Article.Subject = Mid(m_rxBuffer, TabPosition + 1, Tab2 - TabPosition - 1)
									'author tab2,tab3
									m_Article.PostDate = NewsServerDateToDate(Mid(m_rxBuffer, Tab3 + 1, Tab4 - Tab3 - 1))
									'message id tab4,tab5
									'references tab5,tab6
									'byte count tab6,tab7
									m_Article.LineCount = Val(Mid(m_rxBuffer, Tab7 + 1, Tab8 - Tab7 - 1))
									m_BufferProcessing = m_BufferProcessing + GetTickCount - lngStart
									RaiseEvent ProcessArticle(m_Article.ArticleNumber, m_Article.Subject, m_LinesProcessed, m_Article.PostDate, m_SelectedGroupID, m_LinesExpected) ' m_Article.LineCount
									If m_LinesProcessed Mod 100 = 1 Then
										Call SetServerSetting("GroupMax-" & m_SelectedGroupID, CStr(m_Article.ArticleNumber))
									End If
								End If
							End If
						End If
					End If
				End If
			End If
			
		Loop 
		
		'If m_BinaryBuffer(StartLine) = 46 Then '"."
		If Left(m_rxBuffer, 1) = "." And skipline = False Then
			'    Call SetServerSetting("GroupMax-" & m_SelectedGroupID, CStr(m_Article.ArticleNumber))
			Call ProcessEndOfCommand()
		End If
		
		' Process part lines
		If LineCursor >= m_BinaryBufferMax Or LineCursor = m_BinaryBufferMax Then
			m_BinaryBufferMax = 0
		Else
			t = 0
			For i = LineCursor To m_BinaryBufferMax
				m_BinaryBuffer(t) = m_BinaryBuffer(i)
				t = t + 1
			Next 
			
			m_BinaryBufferMax = t - 1
		End If
		
	End Sub
	
	'' Store the group list in a buffer
	Private Sub ProcessGroupList()
		Dim EndOfLine As Boolean
		Dim SpacePosition As Integer
		Dim NextSpace As Integer
		Dim LineData As String
		
		Dim Name As String
		Dim LowArticle As Double
		Dim HighArticle As Double
		Dim Postability As String
		Dim i As Short
		Dim t As Integer
		
		Dim LineCursor As Integer
		
		LineCursor = 0
		EndOfLine = GetNextLine(LineCursor)
		
		EndOfLine = InStr(m_rxBuffer, vbCrLf)
		If (Left(m_rxBuffer, Len("231 New newsgroups follow.")) = "231 New newsgroups follow.") Then
			EndOfLine = GetNextLine(LineCursor)
		End If
		
		If (Left(m_rxBuffer, Len("215 NewsGroups Follow")) = "215 NewsGroups Follow") Then
			EndOfLine = GetNextLine(LineCursor)
		End If
		If (Left(m_rxBuffer, Len("215 ")) = "215 ") Then
			EndOfLine = GetNextLine(LineCursor)
		End If
		
        MDIMain.LBLProgress(0) = CStr(m_LinesProcessed)
		
		LineData = m_rxBuffer
		
		Do While EndOfLine = True
			m_LinesProcessed = m_LinesProcessed + 1
			'microsoft.public.de.german.windows.server.networking 0000000004 0000000002 y
			If (Left(LineData, 1) = ".") Then
				EndOfLine = 0
				Call ProcessEndOfCommand()
			Else
				SpacePosition = InStr(LineData, " ")
				NextSpace = InStr(SpacePosition + 1, LineData, " ")
				
				Name = Mid(LineData, 1, SpacePosition - 1)
				HighArticle = CDbl(Mid(LineData, SpacePosition + 1, 10))
				LowArticle = CDbl(Mid(LineData, NextSpace + 1, 10))
				Postability = Mid(LineData, Len(LineData), 1)
				
				RaiseEvent AddUpdateGroup(Name, LowArticle, HighArticle, Postability)
				
				EndOfLine = InStr(m_rxBuffer, vbCrLf)
			End If
			
			EndOfLine = GetNextLine(LineCursor)
			LineData = m_rxBuffer
			
		Loop 
		
		' Process part lines
		If LineCursor >= m_BinaryBufferMax Or LineCursor = m_BinaryBufferMax Then
			m_BinaryBufferMax = 0
		Else
			t = 0
			For i = LineCursor To m_BinaryBufferMax
				m_BinaryBuffer(t) = m_BinaryBuffer(i)
				t = t + 1
			Next 
			
			m_BinaryBufferMax = t - 1
		End If
		
	End Sub
	
	'' Fired once a command has completed (recieve '.')
	Private Sub ProcessEndOfCommand()
		Dim i As Integer
		
		On Error GoTo dbUpdateError
		
		Select Case State1
			Case TNNTPState.NNTP_STAT_GETLIST
				m_AutoAction = AutoActionENUM.None
				RaiseEvent ProcessAllGroupsList()
				State1 = TNNTPState.NNTP_STAT_CONNECTED
				
			Case TNNTPState.NNTP_STAT_GETXOVER
				
				'Get Group ID
				State1 = TNNTPState.NNTP_STAT_CONNECTED
				RaiseEvent ProcessAllArticleList()
				
			Case Else
		End Select
		Exit Sub
dbUpdateError: 
		If Err.Number = -2147467259 Or Err.Number = -2147217887 Then ' Table locked
			System.Windows.Forms.Application.DoEvents()
			Resume 
		End If
		If (ErrorCheck(ErrorToString(), "")) Then
			System.Windows.Forms.Application.DoEvents()
			Resume 
		End If
		
	End Sub
	
	'' Processes the complete article stored in the buffer
	Private Sub ProcessArticleBody()
		Dim i As Integer
		Dim DownloadNextFile As Boolean
		
		Dim tempstring As String
		Dim YencHeader As String
		Dim YencHeaderLine2 As String
		Dim YbeginPos As Integer
		Dim YLinePos As Integer
		Dim yencFileBeginPos As Integer
		Dim FileName As String
		Dim UUEncodeBeginPos As Integer
		
		Dim DataStart As Integer
		Dim fileid As Integer
		
		Dim t As Integer
		Static WriteBuffer(5000000) As Byte '
		Dim WriteMax As Integer
		Dim LastLine As String
		
		Dim YencCRC As String
		Dim OutputFileSize As Integer
        Dim yEncCRCFromDownload As UInteger
		
		Dim OutputSegmentSize As Integer
		Dim DownloadedSuccessfully As Boolean
		
		Dim bytearray2() As Byte '' Used in process article body, to store output to file
		
		Dim ArticleDownloadedSuccessful As Boolean
		
		Dim EndOfBodyPos As Integer
		Dim NewFile As Boolean
		
		DownloadNextFile = True
		DownloadedSuccessfully = False
		FileName = ""
		ArticleDownloadedSuccessful = False
		
		On Error GoTo permissiondenied
		' Look for end of transmission char
		Dim linelength As Integer
		If m_BinaryBufferMax > 10 Then
			
			' Check to ensure the buffer is complete
			tempstring = ""
			For t = 0 To 10
				tempstring = tempstring & Chr(m_BinaryBuffer(m_BinaryBufferMax - 10 + t))
			Next 
			
			EndOfBodyPos = InStr(tempstring, vbCrLf & ".")
			
			If EndOfBodyPos > 0 Then
				'UPGRADE_WARNING: DateDiff behavior may be different. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6B38EC3F-686D-4B2E-B5A5-9E8E7A762E32"'
				m_lastarticleDuration = DateDiff(Microsoft.VisualBasic.DateInterval.Second, m_ArticleStartTime, Now)
				If (Mid(tempstring, EndOfBodyPos + 3, 2) = vbCrLf) Then
					YbeginPos = 0
					
					tempstring = ""
					For t = 0 To 400
						tempstring = tempstring & Chr(m_BinaryBuffer(t))
					Next 
					
					UUEncodeBeginPos = 0
					YbeginPos = InStr(tempstring, "=ybegin")
					UUEncodeBeginPos = InStr(tempstring, vbCrLf & "begin")
					
					fileid = FreeFile
					
					If YbeginPos > 0 Then
						YencHeader = Mid(tempstring, YbeginPos, NextLine(tempstring, YbeginPos) - YbeginPos)
						YencHeaderLine2 = Mid(tempstring, YbeginPos + Len(YencHeader) + 2, NextLine(tempstring, YbeginPos + Len(YencHeader)) - (YbeginPos + Len(YencHeader)) - 2)
						
						t = InStr(YencHeaderLine2, "ypart begin=")
						If t = 0 Then
							yencFileBeginPos = 1
						Else
							yencFileBeginPos = CInt(Mid(YencHeaderLine2, t + 12, InStr(t + 12, YencHeaderLine2, " ") - t - 12))
							YLinePos = InStr(YencHeader, "part=") + 5
							'YendFileNumber = Mid$(YencHeader, YLinePos, InStr(YLinePos, YencHeader, " ") - YLinePos)
						End If
						
						FileName = m_LastFileName
						'If m_blnDownloadingMp3 = True Then
						'Else
						'    FileName = Mid$(YencHeader, InStr(YencHeader, "name=") + 5)
						'RaiseEvent UpdateLastFileName(FileName, m_LastFileID)
						'    m_LastFileName = FileName
						'End If
						
						' Save File
						If InStr(tempstring, "=ypart begin=") = 0 Then
							DataStart = InStr(tempstring, "=ybegin")
						Else
							DataStart = InStr(tempstring, "=ypart begin=")
						End If
						DataStart = InStr(DataStart, tempstring, vbCrLf) + 1
						
						t = CopyTo(m_BinaryBuffer, m_BinaryBufferMax, WriteBuffer, WriteMax, DataStart)
						t = t + 4
						LastLine = ""
						
						Do While m_BinaryBuffer(t) <> 10 And t < m_BinaryBufferMax
							LastLine = LastLine & Chr(m_BinaryBuffer(t))
							t = t + 1
						Loop 
						
						LastLine = Replace(LastLine, vbCr, " ")
						If (LastLine = "" Or InStr(LastLine, "crc32=") = 0) Then
							' Invalid packet
							DownloadNextFile = False
							RaiseEvent LogEvent("Bad yenc article")
						Else
							t = InStr(LastLine, "crc32=")
							YencCRC = UCase(Mid(LastLine, t + 6, InStr(t, LastLine, " ") - t - 6))
							t = InStr(LastLine, "size=")
							OutputFileSize = CInt(Mid(LastLine, t + 5, InStr(t, LastLine, " ") - t - 5))
							
							ReDim bytearray2(OutputFileSize - 1)
							
							yEncCRCFromDownload = GetCRC2(WriteBuffer, WriteMax, bytearray2, OutputFileSize - 1)
                            If (yEncCRCFromDownload = UInteger.Parse(YencCRC, Globalization.NumberStyles.HexNumber)) Then
                                '&&HCA49FA48
                                '   CA49FA48
                                'Valid packet

                                ' New file create to max size
                                'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
                                If Dir(FRMOptions.TempDownloadPath & FileName, FileAttribute.Normal) = "" Then
                                    NewFile = True
                                End If

                                FileOpen(fileid, FRMOptions.TempDownloadPath & FileName, OpenMode.Binary, OpenAccess.Write)
                                If NewFile = True Then
                                    If m_TotalArticles > 1 Then
                                        FilePut(fileid, 0, OutputFileSize * (m_TotalArticles - 1) - 4)
                                    End If
                                End If

                                FilePut(fileid, bytearray2, yencFileBeginPos)
                                FileClose(fileid)

                                Call m_BitmapProcessor.UpdateFileBitmap(FileName, m_LastArticleIndex, m_TotalArticles)
                                ArticleDownloadedSuccessful = True
                            Else
                                ' Invalid packet - invalid crc
                                DownloadNextFile = False
                                RaiseEvent LogEvent("Bad yenc article")
                            End If
						End If
						
					Else
						
						If UUEncodeBeginPos > 0 Then
							YencHeader = Mid(tempstring, UUEncodeBeginPos + 2, InStr(UUEncodeBeginPos + 1, tempstring, vbCrLf) - UUEncodeBeginPos - 2)
							FileName = m_LastFileName
							If m_blnDownloadingMp3 Then
							Else
								'FileName = Mid$(YencHeader, InStr(InStr(YencHeader, " ") + 1, YencHeader, " ") + 1)
								'RaiseEvent UpdateLastFileName(FileName, m_LastFileID)
								'm_LastFileName = FileName
							End If
							
						Else
							' fucked buffer ignore
							UUEncodeBeginPos = InStr(tempstring, "body")
						End If
						
						RaiseEvent GetOutputSegmentSize(OutputSegmentSize, FileName, m_LastFileID, m_LastArticleIndex)
						
						If m_LastArticleIndex <> 1 Then
							If m_LastArticleIndex = 0 Then
								m_LastArticleIndex = m_LastArticleIndex + 1
							End If
							yencFileBeginPos = OutputSegmentSize * (m_LastArticleIndex - 1) + 1
						Else
							yencFileBeginPos = 1
						End If
						
						If OutputSegmentSize = 0 And m_LastArticleIndex <> 1 Then 'And
							' bad buffer
							DownloadNextFile = False
						Else
							' Try to decode using uuencode
							i = 0
							t = 0
							
							Do While i < m_BinaryBufferMax
								
								' look for first line
								If m_BinaryBuffer(i) = 10 Then
									If m_BinaryBuffer(i + 1) = Asc(".") And m_BinaryBuffer(i + 2) = 13 Then
										Exit Do
									Else
										If m_BinaryBuffer(i + 1) = Asc("e") And m_BinaryBuffer(i + 2) = Asc("n") And m_BinaryBuffer(i + 3) = Asc("d") Then
											' end (last line)
											Exit Do
										Else
											If (m_BinaryBuffer(i + 1) <> 10 And m_BinaryBuffer(i + 1) <> 13) Then 'And (m_BinaryBuffer(i + 1) <> 13 And m_BinaryBuffer(i + 1) <> 13)
												' Line found
												i = i + 1
												If m_BinaryBuffer(i) = Asc("b") And m_BinaryBuffer(i + 1) = Asc("e") And m_BinaryBuffer(i + 2) = Asc("g") And m_BinaryBuffer(i + 3) = Asc("i") And m_BinaryBuffer(i + 4) = Asc("n") Then
													' begin (ignore this line)
												Else
													
													tempstring = ""
													linelength = m_BinaryBuffer(i) - 32 '* 4 / 3
													If m_BinaryBuffer(i) = Asc(".") And m_BinaryBuffer(i + 1) = 13 Then
														Exit Do
													End If
													If m_BinaryBuffer(i) = 96 Then
														linelength = 0
													End If
													
													i = i + 1
													Do While linelength > 0 And i < m_BinaryBufferMax
														' Bit of c code to fast convert 4 base64 bytes to 3
														Call Base64(m_BinaryBuffer, WriteBuffer, i, t)
														i = i + 4
														
														If linelength > 0 Then
															linelength = linelength - 1
															t = t + 1
														End If
														
														If linelength > 0 Then
															linelength = linelength - 1
															t = t + 1
														End If
														
														If linelength > 0 Then
															linelength = linelength - 1
															t = t + 1
														End If
													Loop 
												End If
											End If
											
										End If
										
									End If
								End If
								i = i + 1
							Loop 
							
							If t > 0 Then
								ReDim bytearray2(t - 1)
								Call CopyArray(WriteBuffer, t, bytearray2, 0)
								
								' New file create to max size
								'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
								If Dir(FRMOptions.TempDownloadPath & FileName, FileAttribute.Normal) = "" Then
									NewFile = True
								End If
								
								FileOpen(fileid, FRMOptions.TempDownloadPath & FileName, OpenMode.Binary, OpenAccess.Write)
								If NewFile = True Then
									If m_TotalArticles > 1 And OutputSegmentSize > 0 Then
                                        FilePut(fileid, 0, (m_TotalArticles - 1) * OutputSegmentSize)
									End If
								End If
                                FilePut(fileid, bytearray2, yencFileBeginPos)
								
								
								FileClose(fileid)
								Call m_BitmapProcessor.UpdateFileBitmap(FileName, m_LastArticleIndex, m_TotalArticles)
								ArticleDownloadedSuccessful = True
								
								If (m_LastArticleIndex = 1) Then
									Call Execute("UPDATE [File] SET OutputSegmentSize=" & t, True)
								End If
							Else
								' fucked
							End If
							
						End If
					End If
badArticle: 
					
					' Check to see if the file was completed
					
					If (m_BitmapProcessor.IsCompleteFileBitmap(FileName, m_TotalArticles) = True) Then
						RaiseEvent MoveFile(FileName, m_LastFileSubject)
						
						DownloadedSuccessfully = True
					End If
					
					If (DownloadedSuccessfully = True) Then
						RaiseEvent FileDownloadedSuccessfully(m_LastFileID)
					End If
					
					' If article downloaded unsucessfully, try alternate server
					'If FRMOptions.UseAlternateServer = True Then
					'    If ArticleDownloadedSuccessful = False Then
					'        m_GetMissingArticles = True
					'        Call Connect
					'
					'    Else
					'        If m_GetMissingArticles = True Then
					'            m_GetMissingArticles = False
					'            Call Connect
					'        Else
					'            ' Get Next File here
					'            RaiseEvent TriggerDownloadFile(True)
					'        End If
					
					'    End If
					'Else
					' Get Next File here
					RaiseEvent TriggerDownloadFile(True)
					'End If
				Else
					' Buffer not complete
				End If
			End If
		End If
		Exit Sub
permissiondenied: 
		If Err.Number = 5 Or Err.Number = 9 Then
			' bad article
			DownloadNextFile = False
			RaiseEvent LogEvent("Bad article - permission denied (" & Err.Description & ")")
			Resume badArticle
			
		Else
			System.Windows.Forms.Application.DoEvents()
			Resume 
		End If
	End Sub
End Class