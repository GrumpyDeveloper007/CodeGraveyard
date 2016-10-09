Option Strict Off
Option Explicit On
Option Compare Text
Imports VB = Microsoft.VisualBasic
Friend Class FRMMain
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' Main form, contains all the start points and is database access hub
	''
	'' Coded by Dale Pitman - PyroDesign
	
    Private m_lngStart As Integer
    Private m_BitmapProcessor As New cBitmapProcessor
    Private m_GroupPath As String

    Private m_Mp3StyleFileNameProcessing As Boolean

    Dim m_FileCache(500) As FileTYPE '' Used to store file UID's, while updating article list
    Dim m_FileCacheMax As Long '' Current size of cache
    Dim m_FileCachePtr As Long '' Internal pointer within cache (so cache becomes a queue(LIFO))
    Const cFileCacheSize As Short = 50 '' Optimum size seems to be about 30/thread
    Dim m_FileCacheCurrentSize As Long

    Public m_GroupTypeID As Integer

    Private Structure FileTYPE
        Dim Subject As String
        Dim FileName As String
        Dim UID As Integer
        Dim TotalArticles As Long
    End Structure

    '' Search criteria(Input Parameters)


    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Public m_lngDatabase As Integer
    Public m_lngDBSearch As Integer
    Private m_blnGettingMissingArticles As Boolean
    Private m_lngCacheSearch As Integer
    Private m_lngSubjectProcessing As Integer
    Private m_dtProcessArticleStartTime As Date
    Public m_lngLastCompleteFile As Integer

    '' All articles for the current file
    Private m_ArticleID() As ArticleType
    Private m_ArticleMax As Long

    Private rsfile As ADODB.Recordset

    Private m_rsMissingArticle As ADODB.Recordset
    Private m_ArticleProcessor As New cArticleProcessing

    Public m_IgnorePaths As ADODB.Recordset
    Private m_File(1) As Integer
    Private m_FileArticles(1) As Long
    Private m_month As Integer

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    Public Sub GetIgnorePaths()
        Call OpenRecordset(m_IgnorePaths, "SELECT * FROM IgnorePaths", dbOpenSnapshot)
    End Sub

    Public Sub ChangeGroupType(ByRef cbo As System.Windows.Forms.ComboBox)
        Dim rstemp As ADODB.Recordset
        Dim sql As String
        Dim i As Integer
        Dim t As Integer

        MDIMain.mnuSelectedGroupType.DropDownItems(cbo.SelectedIndex).Select()
        MDIMain.mnuSelectedGroupType.Text = "Current - " & MDIMain.CBOGroupType.Text

        Call CBONewsGroup.Items.Clear()
        If (cbo.SelectedIndex = 0) Then
            ' all
            sql = "SELECT * FROM [group] WHERE grouptypeid>0"
            m_GroupTypeID = -1
        Else
            If (OpenRecordset(rstemp, "SELECT * FROM [grouptype] WHERE uid=" & VB6.GetItemData(cbo, cbo.SelectedIndex), dbOpenSnapshot)) Then
                m_GroupTypeID = rstemp.Fields("UID").Value
                m_GroupPath = rstemp.Fields("downloadpath").Value & ""
                If m_GroupPath = "" Then
                    m_GroupPath = "C:\"
                    Call MsgBox("No download path has been set for this group, please go into 'Add/Remove groups' and set the download path.", MsgBoxStyle.Exclamation, "Group download path")
                End If
                'frmIMDBHolder.m_SearchForIMDB = rstemp.Fields("searchforimdb").Value
            End If
            sql = "SELECT * FROM [group] WHERE grouptypeid=" & m_GroupTypeID
        End If

        i = 0
        If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
            MDIMain.mnuSelectedGroups.DropDownItems.Clear()

            Do While (rstemp.EOF = False)
                Call CBONewsGroup.Items.Add(rstemp.Fields("GroupName").Value)
                MDIMain.mnuSelectedGroups.DropDownItems.Add(rstemp.Fields("GroupName").Value, Nothing, New System.EventHandler(AddressOf MDIMain.mnuSelectedGroups_ItemClick))
                i = i + 1

                Call rstemp.MoveNext()
            Loop
            If (CBONewsGroup.Items.Count > 0) Then
                CBONewsGroup.SelectedIndex = 0
            End If
        End If

        If (m_GroupTypeID = 2) Then
            frmReaderHolder.DownloadingMp3 = True
            m_Mp3StyleFileNameProcessing = True
        Else
            frmReaderHolder.DownloadingMp3 = False
            m_Mp3StyleFileNameProcessing = False
        End If
        '    Call FRMViewFiles.RefreshGroupID(m_GroupTypeID)
    End Sub

    Private Sub CMDClear_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDClear.Click
        TXTrx.Text = ""
    End Sub

    Public Sub UpdateRx(ByRef pIndex As Integer, ByRef pString As String)
        TXTrx.Text = TXTrx.Text & pIndex & ":" & pString
        TXTrx.SelectionStart = Len(TXTrx.Text)
    End Sub


    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    '' Form objects

    Public Sub CMDDownloadFiles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDDownloadFiles.Click
        Call frmReaderHolder.ResetLastDownloadedID()

        'Set rsArticle = Nothing
        ReDim m_ArticleID(0)
        m_ArticleMax = 1
        'UPGRADE_NOTE: Object rsfile may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        rsfile = Nothing
        m_blnGettingMissingArticles = False
        frmReaderHolder.GetMissingArticles = False

        frmReaderHolder.DownloadFiles()
    End Sub

    Public Sub CMDGetAllGroups_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDGetAllGroups.Click
        ReDim m_Groups(100000)
        m_MaxGroup = 0
        frmReaderHolder.m_cNewsReader.DGetAllGroups()
    End Sub

    Private Sub cmdPar_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdPar.Click
        Call CheckSchedule(True)
    End Sub

    Public Sub CMDViewFiles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDViewFiles.Click
        'Call ShowForm(FRMViewFiles)
    End Sub

    '' Set forms location, as stored in registory
    Private Sub FRMMain_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        Dim threads As Integer
        Dim i As Integer
        Dim t As Integer


        ReDim m_ArticleID(0)
        m_ArticleMax = 1

        m_month = Val(GetServerSetting("Month", False))
        If m_month <> CDbl(VB6.Format(Now, "mm")) Then
            Call SetServerSetting("Month", VB6.Format(Now, "mm"))
            m_month = CInt(VB6.Format(Now, "mm"))
            Call SetServerSetting("BytesTotal", CStr(0))
        End If
        m_BytesTotal = Val(GetServerSetting("BytesTotal", False))

        frmReaderHolder.Init()

        If (CBONewsGroup.Items.Count > 0) Then
            CBONewsGroup.SelectedIndex = 0
        End If

        MDIMain.Init()

        Call AllFormsLoad(Me)

        threads = CInt(GetSetting(cRegistoryName, "Settings", "Threads", CStr(3)))
        Call MDIMain.mnuThreads_Click(7)
        lblFilename0.Text = ""
        lblFilename1.Text = ""

    End Sub

    '' Save forms location
    Private Sub FRMMain_FormClosed(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
        Call SetServerSetting("BytesTotal", CStr(m_BytesTotal))

        Call frmReaderHolder.ResetLastDownloadedID()

        Call GetWindowPosition(Me)
        Call AllFormsUnLoad(Me)
    End Sub

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''

    Private Sub CheckSchedule(ByRef bForce As Boolean)
        Static ScheduleRun As Boolean
        Static ScheduleArticleUpdateRun As Boolean
        Static ScheduleRunning As Boolean
        Static ParFilename As String
        Static LastExecuteTime As Date
        Static FileList(1000) As String
        Static FileListMax As Integer
        Static FileListIndex As Integer
        Static rsGroups As ADODB.Recordset

        Static StartSchedule As Boolean
        Static i As Integer
        Static dblBytesTotal As Double
        If bForce = True Then
            StartSchedule = True
        End If

        If FRMOptions.StartPars = True Then
            'StartSchedule = False
            For i = 0 To 22
                If FRMOptions.Schedule(i) = True And CDbl(VB6.Format(Now, "hh")) >= i And CDbl(VB6.Format(Now, "hh")) < i + 1 Then
                    StartSchedule = True
                End If
            Next

            ' Only run at night
            If StartSchedule = True Then

                ' If its the first day of the month then reset the amount downloaded
                If VB.Day(Now) = 1 Then
                    m_BytesTotal = 0
                End If

                If ScheduleArticleUpdateRun = False Then
                    Call SetServerSetting("BytesTotal", CStr(m_BytesTotal))
                    Call cmdGetNewArticles_Click(cmdGetNewArticles, New System.EventArgs())
                    ScheduleArticleUpdateRun = True
                End If

                If ScheduleRun = False Then

                    ' Wait 3min before starting another par2
                    'UPGRADE_WARNING: DateDiff behavior may be different. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6B38EC3F-686D-4B2E-B5A5-9E8E7A762E32"'
                    If DateDiff(Microsoft.VisualBasic.DateInterval.Minute, LastExecuteTime, Now) >= 3 Then
                        If ScheduleRunning = False Then
                            FileListIndex = 0
                            FileListMax = 0

                            Call OpenRecordset(rsGroups, "SELECT distinct Downloadpath FROM [grouptype]", dbOpenSnapshot)

                            Do While rsGroups.EOF = False
                                'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
                                ParFilename = Dir(rsGroups.Fields("downloadpath").Value & "*.par2")
                                Do While ParFilename <> ""
                                    If InStr(1, ParFilename, "vol", CompareMethod.Text) = 0 And ParFilename <> "" Then
                                        FileList(FileListMax) = rsGroups.Fields("downloadpath").Value & ParFilename
                                        FileListMax = FileListMax + 1
                                    End If
                                    'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
                                    ParFilename = Dir()
                                Loop
                                Call rsGroups.MoveNext()
                            Loop
                            Call rsGroups.Close()

                            ScheduleRunning = True
                        End If

                        ParFilename = FileList(FileListIndex)
                        FileListIndex = FileListIndex + 1

                        If FileListIndex < FileListMax Then
                            'App.Path = "C:\Program Files\"
                            Call Shell("C:\Program Files\QuickPar\QuickPar.exe " & Chr(34) & ParFilename & Chr(34), AppWinStyle.NormalFocus)
                            LastExecuteTime = Now
                        Else
                            ScheduleRun = True
                            StartSchedule = False
                        End If
                    End If
                End If
            Else
                LastExecuteTime = Now
                ScheduleRun = False
                ScheduleArticleUpdateRun = False
                ScheduleRunning = False
            End If
        End If
    End Sub

    Private Sub CheckDownload()
        Static ScheduleRun As Boolean

        Static StartSchedule As Boolean
        Static i As Integer

        StartSchedule = False
        For i = 0 To 22
            If FRMOptions.Download(i) = True And CDbl(VB6.Format(Now, "hh")) >= i And CDbl(VB6.Format(Now, "hh")) < i + 1 Then
                StartSchedule = True
            End If
        Next

        ' Only run at night
        If StartSchedule = True Then
            If ScheduleRun = False Then
                If MDIMain.LBLProgress_0.Text = "Inactive" Then
                    Call CMDDownloadFiles_Click(CMDDownloadFiles, New System.EventArgs())
                End If
                ScheduleRun = True
            End If
        Else
            If ScheduleRun = True Then
                frmReaderHolder.Disconnect()
                MDIMain.LBLProgress_0.Text = "Inactive"
                MDIMain.LBLProgress_1.Text = "Inactive"
                MDIMain.LBLProgress_2.Text = "Inactive"
                MDIMain.LBLProgress_3.Text = "Inactive"
                MDIMain.LBLProgress_4.Text = "Inactive"
                MDIMain.LBLProgress_5.Text = "Inactive"
                MDIMain.LBLProgress_6.Text = "Inactive"
                MDIMain.LBLProgress_7.Text = "Inactive"
            End If
            ScheduleRun = False
        End If
    End Sub

    Private Sub Tmr_Tick(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles Tmr.Tick
        Static ClearByteCounter As Integer
        Static packetString As String
        Dim i As Long
        Dim t As Long
        'Static ZeroCount As Long
        ClearByteCounter = ClearByteCounter + 1
        If (ClearByteCounter = 4) Then
            t = 2
            i = m_BytesFor2Second '\ 2# '\ 1024#
            i = i / t
            t = 1024
            i = i / 1024

            If packetString <> MDIMain.LBLProgress_0.Text Then
                packetString = MDIMain.LBLProgress_0.Text
            Else
                If chkautofix.CheckState = System.Windows.Forms.CheckState.Checked And packetString <> "Inactive" Then
                    Call CMDDownloadFiles_Click(CMDDownloadFiles, New System.EventArgs())
                End If
            End If

            MDIMain.LBLTransfer.Text = "KB / sec =" & (i)
            MDIMain.LBLTransfer.Refresh()
            'Call CheckSchedule(False)
            'Call CheckDownload
            ClearByteCounter = 0

            If m_BytesFor2Second > 0 Then
                m_BytesTotal = m_BytesTotal + m_BytesFor2Second
            End If

            If m_month <> CDbl(VB6.Format(Now, "mm")) Then
                Call SetServerSetting("Month", VB6.Format(Now, "mm"))
                Call SetServerSetting("BytesTotal", CStr(0))
                m_month = CInt(VB6.Format(Now, "mm"))
            End If


            MDIMain.lblBytesTotal.Text = "GB Total =" & VB6.Format((m_BytesTotal) / 1024 / 1024 / 1024, "###,###,##0.00")


            m_BytesFor2Second = 0
        End If
    End Sub

    ''''''''''''''''''''''''''''''


    '''''''''''''''''''''''''''''''''

    Public ReadOnly Property LSTTX(ByVal index As Integer) As System.Windows.Forms.ListBox
        Get
            If (index = 0) Then
                Return _LSTTx_0
            End If
            If (index = 1) Then
                Return _LSTTx_1
            End If
            If (index = 2) Then
                Return _LSTTx_2
            End If
            If (index = 3) Then
                Return _LSTTx_3
            End If
            If (index = 4) Then
                Return _LSTTx_4
            End If
            If (index = 5) Then
                Return _LSTTx_5
            End If
            If (index = 6) Then
                Return _LSTTx_6
            End If
            If (index = 7) Then
                Return _LSTTx_7
            End If
        End Get
    End Property


    Public Sub LogEvent(ByRef pName As String, ByRef Index As Integer)
        If (InStr(pName, "authinfo") > 0) Then
            ' Dont show password/ username info
            Call LSTTx(Index).Items.Add(VB.Left(Replace(pName, vbCrLf, ""), InStrRev(pName, " ")) & "****")
        Else
            Call LSTTx(Index).Items.Add(Replace(pName, vbCrLf, ""))
        End If
        LSTTx(Index).SetSelected(LSTTx(Index).Items.Count - 1, True)
        If (LSTTx(Index).Items.Count > 50) Then
            LSTTx(Index).Items.Clear()
        End If
    End Sub

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    Private Function TargetFilesExists(ByRef pfilename As String) As Boolean
        Dim TargetPath As String

        TargetPath = GetTargetFilePath(pfilename, "", False)

        'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If (Dir(TargetPath & pfilename, FileAttribute.Normal) <> "") Then
            TargetFilesExists = True
        Else
            TargetFilesExists = False
        End If

    End Function

    '''''''''''''''''''''''''''''''''''
    '' Update the current articles field depending on how many article records are attached
    '' to the current file
    Public Sub ScanForFiles()
        Dim rstemp As ADODB.Recordset
        Dim rsfile As ADODB.Recordset
        Dim i As Integer

        Dim LastFilename As String
        Dim ids() As ArticleType
        Dim ArticleCount As Long

        'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
        System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
        MDIMain.LBLAction.Text = "Scanning articles for files"

        ' Update files and remove old files
        MDIMain.LBLAction.Text = "Updating files table"
        i = 0
        If (OpenRecordset(rsfile, "SELECT * FROM file WHERE GroupTypeID=" & m_GroupTypeID & " AND TotalArticles>CurrentArticles", dbOpenDynaset)) Then
            Do While (rsfile.EOF = False)
                On Error GoTo error_Renamed
                Call GetAllArticlesByFileID(rsfile.Fields("UID").Value, ids)
                ArticleCount = UBound(ids) + 1

                rsfile.Fields("currentarticles").Value = ArticleCount
                'LastFileName = rsfile!Name

                i = i + 1
                If (i Mod 20 = 0) Then
                    System.Windows.Forms.Application.DoEvents()
                    MDIMain.LBLAction.Text = "Updating files table - " & i
                End If

                Call rsfile.MoveNext()
            Loop

        End If

        MDIMain.LBLAction.Text = "Done"
        'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
        System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
        Exit Sub
error_Renamed:
        ArticleCount = 0
        Resume Next
    End Sub

    Public Sub cmdGetNewArticles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDGetNewArticles.Click

        Call Execute("DELETE FROM [File] WHERE [PostDate] > #" & VB6.Format(DateAdd(Microsoft.VisualBasic.DateInterval.Year, -1, Now), "mm/dd/yyyy") & "# AND [PostDate] <#" & VB6.Format(DateAdd(Microsoft.VisualBasic.DateInterval.Month, -1, Now), "mm/dd/yyyy") & "#", True)
        m_lngDatabase = 0
        m_FileCacheMax = 0
        m_FileCachePtr = 0

        Call frmReaderHolder.Disconnect()

        frmReaderHolder.GetMissingArticles = False

        If CBONewsGroup.Items.Count > 0 Then
            CBONewsGroup.SelectedIndex = 0
            m_dtProcessArticleStartTime = Now
            m_blnGettingMissingArticles = False

            frmReaderHolder.A_StillRunning = True
            frmReaderHolder.m_cNewsReader.m_GroupName = CBONewsGroup.Text
            frmReaderHolder.m_cNewsReader.DGetNewArticles()

            m_FileCacheCurrentSize = 3 * cFileCacheSize

            m_lngStart = GetTickCount
        Else
            Call MsgBox("No newsgroups belong to this group, please use 'Add/Remove groups' to add some.", MsgBoxStyle.Exclamation, "Get new articles")
        End If
    End Sub

    Private Function getnextfile() As Boolean

        getnextfile = True
getnextfile:
        ' Get the file list
        If (OpenRecordset(rsfile, "SELECT * FROM [File] f WHERE f.downloadfile=true AND f.downloadedsuccessfully=false AND f.downloading=false AND GroupTypeID=" & m_GroupTypeID & " AND PauseFile=false ORDER BY postdate ASC", dbOpenSnapshot)) Then
        End If

        If (rsfile.EOF = False) Then
            Dim filename As String
            Dim uid As Integer
            filename = rsfile.Fields("FileName").Value
            If TargetFilesExists(filename) Then
                Call Execute("UPDATE FILE SET PauseFile=True WHERE UID=" & rsfile.Fields("UID").Value)
                GoTo getnextfile
            End If

            Call Execute("UPDATE  File SET Downloading=true WHERE UID=" & rsfile.Fields("UID").Value, True)
            uid = rsfile.Fields("UID").Value
            Call GetAllArticlesByFileID(uid, m_ArticleID)

            If UBound(m_ArticleID) > 0 Or m_ArticleID(0).ArticleID <> 0 Then
                m_ArticleMax = 0
            Else
                Call rsfile.MoveNext()
                GoTo getnextfile
            End If
        Else
            'end of download list
            CMDDownloadFiles.Enabled = True
            MDIMain.LBLAction.Text = "Completed Download"
            getnextfile = False
        End If
    End Function

    Public Sub DownloadFile(ByRef clsNewsReader As cNewsReader)
        Dim sql As String
        Dim GroupID As Integer
        Dim rsGroup As ADODB.Recordset

        If frmReaderHolder.NumberOfThreads < clsNewsReader.Index + 1 Then
            ' finish processing for this thread
            MDIMain.LBLProgress(clsNewsReader.Index) = "Inactive"
            clsNewsReader.Disconnect()
            Exit Sub
        End If

        Call clsNewsReader.ResetBuffer()

        If m_ArticleMax > UBound(m_ArticleID) Then
getnextfile:

            If getnextfile() = False Then
                Call clsNewsReader.DownloadCompleted()
                GoTo fin
            End If

            m_File(1) = m_File(0)
            lblFilename1.Text = lblFilename0.Text
            m_FileArticles(1) = m_FileArticles(0)
            'Call m_BitmapProcessor.RefreshDownloadBitmap(grdBitmapSmall, m_File(1), m_FileArticles(0))
            m_File(0) = rsfile.Fields("UID").Value
            m_FileArticles(0) = rsfile.Fields("TotalArticles").Value
            lblFilename0.Text = rsfile.Fields("FileName").Value
        End If

        If rsfile.Fields("TotalArticles").Value <> 1 Then
            'Find a article to download, using downloaded bitmap and currently active threads
            Do While (m_ArticleMax <= UBound(m_ArticleID))
                Dim filename As String
                Dim fileindex As Integer
                Dim totalarticles As Integer
                Dim uid As Integer
                filename = rsfile.Fields("FileName").Value
                fileindex = CInt(m_ArticleID(m_ArticleMax).FileIndex)
                totalarticles = rsfile.Fields("TotalArticles").Value
                uid = rsfile.Fields("UID").Value

                If (m_BitmapProcessor.CheckFileBitmap(filename, fileindex, totalarticles) > 0) Then
                    m_ArticleMax = m_ArticleMax + 1
                Else
                    If frmReaderHolder.CheckCurrentlyDownloadingIndex(uid, m_ArticleID(m_ArticleMax).FileIndex, 0) = True Then
                        m_ArticleMax = m_ArticleMax + 1
                    Else
                        If (OpenRecordset(rsGroup, "SELECT * FROM [group] WHERE uid=" & m_ArticleID(m_ArticleMax).GroupID, dbOpenSnapshot)) Then
                            If (rsGroup.EOF = False) Then
                                Exit Do
                            Else
                                m_ArticleMax = m_ArticleMax + 1
                            End If
                        End If
                    End If
                End If
            Loop
        End If
        If m_ArticleMax > UBound(m_ArticleID) Then
            rsfile.MoveNext()
            GoTo getnextfile
        End If

        'Copy details to class
        If clsNewsReader.m_LastFileID <> rsfile.Fields("UID").Value Then
            clsNewsReader.m_LastFileID = rsfile.Fields("UID").Value
            clsNewsReader.m_LastFileName = rsfile.Fields("FileName").Value
            Call frmReaderHolder.CheckFileNameOverride(clsNewsReader)
            clsNewsReader.m_TotalArticles = rsfile.Fields("TotalArticles").Value
        End If
        clsNewsReader.FileIndex = m_ArticleID(m_ArticleMax).FileIndex
        clsNewsReader.m_ArticleNumber = m_ArticleID(m_ArticleMax).ArticleID

        clsNewsReader.m_LastArticleIndex = m_ArticleID(m_ArticleMax).FileIndex
        clsNewsReader.m_LastFileSubject = rsfile.Fields("Name").Value
        If clsNewsReader.m_LastFileID = m_File(0) Then
            'Call m_BitmapProcessor.RefreshDownloadBitmap(GRDBitmap, clsNewsReader.m_LastFileID, rsfile!TotalArticles)
        Else
            'Call m_BitmapProcessor.RefreshDownloadBitmap(grdBitmapSmall, clsNewsReader.m_LastFileID, rsfile!TotalArticles)
        End If

        If (m_GroupTypeID = 2) Then
            MDIMain.LBLProgress(clsNewsReader.Index) = clsNewsReader.m_LastFileName & "-" & rsfile.Fields("Name").Value & "(/" & clsNewsReader.FileIndex & "/" & rsfile.Fields("TotalArticles").Value & ") " '& i \ 60 & ":" & i Mod 60 & "]"
        Else
            MDIMain.LBLProgress(clsNewsReader.Index) = clsNewsReader.m_LastFileName & "(/" & clsNewsReader.FileIndex & "/" & rsfile.Fields("TotalArticles").Value & ") " '& i \ 60 & ":" & i Mod 60 & "]"
        End If

        GroupID = m_ArticleID(m_ArticleMax).GroupID
        If rsfile.Fields("TotalArticles").Value = 1 Then
            m_ArticleMax = m_ArticleMax + 1
        End If

        If (clsNewsReader.m_SelectedGroupID <> GroupID) Then
            ' Select the group
            If (OpenRecordset(rsGroup, "SELECT * FROM [group] WHERE uid=" & GroupID, dbOpenSnapshot)) Then
                If (rsGroup.EOF = False) Then
                    clsNewsReader.m_GroupName = rsGroup.Fields("GroupName").Value
                    MDIMain.LBLAction.Text = "Waiting for group to be selected."
                    Call clsNewsReader.SelectGroup()
                Else
                End If
            End If

        Else
            MDIMain.LBLAction.Text = "Processing article " & clsNewsReader.FileIndex & " (" & UBound(m_ArticleID) & ")"

            Call clsNewsReader.DownloadArticle((clsNewsReader.m_ArticleNumber))
        End If

fin:
    End Sub



    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ''

    Public Function GetTargetFilePath(ByRef pfilename As String, ByRef psubject As String, ByRef pDontCreateFolder As Boolean) As String
        Dim TargetPath As String
        Dim FolderName As String

        If (m_GroupTypeID = 1) Then

            If (UCase(VB.Right(pfilename, 3)) = "JPG" Or UCase(VB.Right(pfilename, 3)) = "BMP") Then
                TargetPath = FRMOptions.JPGPath
            Else
                TargetPath = m_GroupPath 'm_MovieTempPath
            End If
        Else
            If (m_GroupTypeID = 2) Then
                FolderName = Trim(psubject)

                If FolderName <> "" Then
                    FolderName = Trim(FolderName) & "\"
                End If

                TargetPath = m_GroupPath & FolderName 'FRMOptions.Mp3Path

                If (pDontCreateFolder = False) Then
                    'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
                    If (Dir(TargetPath, FileAttribute.Directory) = "") Then
                        Call MkDir(TargetPath)
                    End If
                End If
            Else
                TargetPath = m_GroupPath
            End If
        End If
        GetTargetFilePath = TargetPath
    End Function

    Public Sub MoveFile(ByRef pfilename As String, ByRef psubject As String)
        'UPGRADE_NOTE: FileSystem was upgraded to FileSystem_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
        Dim FileSystem_Renamed As New Scripting.FileSystemObject
        Dim extenstion As String
        Dim TargetPath As String

        TargetPath = GetTargetFilePath(pfilename, psubject, False)

        extenstion = "_"
        On Error GoTo fileexists
        Call FileSystem_Renamed.MoveFile(FRMOptions.TempDownloadPath & pfilename, TargetPath & pfilename)
        On Error GoTo CannotDeleteTemp
        'Call FileSystem.DeleteFile(FRMOptions.TempDownloadPath & pfilename & ".txt")
        GoTo Continue_Renamed
Nexttry:

        'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If (Dir(FRMOptions.TempDownloadPath & pfilename) <> "") Then
            Call FileSystem_Renamed.MoveFile(FRMOptions.TempDownloadPath & pfilename, TargetPath & pfilename & extenstion)
        End If
Continue_Renamed:
        Exit Sub
CannotDeleteTemp:
        Resume Next
fileexists:
        Call MsgBox(Err.Description)
        If Err.Number = 76 Then
            Call MsgBox(Err.Description)
        End If
        If Err.Number = 58 Then
            Resume Next
        End If
        extenstion = extenstion & "_"
        If extenstion = "____" Then
            Exit Sub
        End If
        Resume Nexttry
    End Sub

    Private Sub MoveIncompleteFile(ByRef pfilename As String, ByRef psubject As String)
        'UPGRADE_NOTE: FileSystem was upgraded to FileSystem_Renamed. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
        Dim FileSystem_Renamed As New Scripting.FileSystemObject
        Dim extenstion As String
        Dim TargetPath As String

        'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If (Dir(FRMOptions.TempDownloadPath & pfilename) <> "") Then

            TargetPath = GetTargetFilePath(pfilename, psubject, False)

            On Error GoTo fileexists
            extenstion = "_"
            'Call FileSystem.DeleteFile(FRMOptions.TempDownloadPath & pFileName & ".txt")
            Call FileSystem_Renamed.MoveFile(FRMOptions.TempDownloadPath & pfilename & ".txt", TargetPath & pfilename & ".txt")
            Call FileSystem_Renamed.MoveFile(FRMOptions.TempDownloadPath & pfilename, TargetPath & pfilename) '& ".incomplete"
            GoTo Continue_Renamed
Nexttry:

            'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
            If (Dir(FRMOptions.TempDownloadPath & pfilename) <> "") Then
                Call FileSystem_Renamed.MoveFile(FRMOptions.TempDownloadPath & pfilename, TargetPath & pfilename & ".incomplete" & extenstion)
            End If
        End If
Continue_Renamed:
        Exit Sub
fileexists:
        extenstion = extenstion & "_"
        Resume Nexttry
    End Sub


    Public Function CheckJPGExists(ByRef pfilename As String, ByRef psubject As String) As Boolean
        Dim t As Integer
        CheckJPGExists = False

        Me.m_IgnorePaths.MoveFirst()

        Do While Me.m_IgnorePaths.EOF = False
            'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
            If Dir(Me.m_IgnorePaths.Fields("path").Value & pfilename) <> "" Then
                CheckJPGExists = True
                Exit Do
            End If
            Me.m_IgnorePaths.MoveNext()
        Loop

        If InStr(LCase(psubject & pfilename), "naus") > 0 Then
            CheckJPGExists = True
        End If
        If InStr(LCase(psubject & pfilename), "danske") > 0 Then
            CheckJPGExists = True
        End If

        If InStr(LCase(psubject & pfilename), "dutch") > 0 Then
            CheckJPGExists = True
        End If
        If InStr(LCase(psubject & pfilename), "swedish") > 0 Then
            CheckJPGExists = True
        End If
        If InStr(LCase(psubject & pfilename), "danish") > 0 Then
            CheckJPGExists = True
        End If

    End Function



    '''''''''''''''''''''''''
    ''

    Public Sub ProcessArticle(ByRef pArticleNumber As Long, ByRef psubject As String, ByRef pLineCount As Integer, ByRef pPostDate As Date, ByRef pGroupID As Integer, ByRef pLinesExpected As Integer, ByRef pIndex As Integer)
        Static FoundFileRecord As Boolean

        Static Current As FileTYPE
        Static i As Integer
        Static t As Integer
        Static FileIndex As Integer
        Static rsfile As ADODB.Recordset

        Static CacheHit As Integer
        Static RecTotal As Integer

        Static Found As Boolean
        Static ExpectedSec As Integer

        Static fileid As Integer

        Static tempstring As String

        ' Update record
        FoundFileRecord = False

        m_lngStart = GetTickCount

        m_ArticleProcessor.Mp3Mode = m_Mp3StyleFileNameProcessing

        Call m_ArticleProcessor.ProcessSubject(psubject)

        If m_ArticleProcessor.TotalArticles > 0 And m_ArticleProcessor.FileName <> "" Then

            Current.TotalArticles = m_ArticleProcessor.TotalArticles
            FileIndex = m_ArticleProcessor.ArticleNumber
            Current.FileName = Replace(VB.Left(m_ArticleProcessor.FileName, 250), ":", "")
            Current.Subject = VB.Left(m_ArticleProcessor.GroupName, 250)

            m_lngSubjectProcessing = m_lngSubjectProcessing + GetTickCount - m_lngStart

            m_lngStart = GetTickCount

            RecTotal = RecTotal + 1
            ' Check cache, if in mp3 mode match by filename,subject
            If m_Mp3StyleFileNameProcessing = True Then
                For t = 0 To m_FileCacheMax - 1
                    If m_FileCache(t).Subject = Current.Subject And m_FileCache(t).FileName = Current.FileName Then
                        fileid = m_FileCache(t).UID
                        FoundFileRecord = True
                        CacheHit = CacheHit + 1
                    End If
                Next
            Else
                For t = 0 To m_FileCacheMax - 1
                    If m_FileCache(t).TotalArticles = Current.TotalArticles And m_FileCache(t).FileName = Current.FileName Then
                        fileid = m_FileCache(t).UID
                        FoundFileRecord = True
                        CacheHit = CacheHit + 1
                    End If
                Next

            End If
            m_lngCacheSearch = m_lngCacheSearch + GetTickCount - m_lngStart


            m_lngStart = GetTickCount
            If FoundFileRecord = False Then

                If m_Mp3StyleFileNameProcessing = True Then
                    Call OpenRecordset(rsfile, "SELECT * FROM  File WHERE filename=" & Chr(34) & FilterString(Current.FileName) & Chr(34) & " AND name=" & Chr(34) & FilterString(Current.Subject) & Chr(34), dbOpenDynaset)
                Else
                    Call OpenRecordset(rsfile, "SELECT * FROM  File WHERE filename=" & Chr(34) & FilterString(Current.FileName) & Chr(34) & " AND TotalArticles=" & Current.TotalArticles, dbOpenDynaset)
                End If

                If (rsfile.EOF = True) Then
                    rsfile.AddNew()

                    rsfile.Fields("GroupTypeID").Value = m_GroupTypeID
                    rsfile.Fields("FileName").Value = Current.FileName
                    rsfile.Fields("Name").Value = Current.Subject
                    rsfile.Fields("TotalArticles").Value = Current.TotalArticles
                    rsfile.Fields("PostDate").Value = pPostDate

                    'rsfile!debug = Left$(psubject, 255)

                    If (m_GroupTypeID = 1 And FRMOptions.AutoDownloadJPG) Then
                        If (UCase(VB.Right(Current.FileName, 4)) = ".JPG") Then

                            If CheckJPGExists(Current.FileName, Current.Subject) = True Then
                                Found = True
                            End If

                            If Found = False Then
                                rsfile.Fields("DownloadFile").Value = True
                            End If
                        End If
                    End If
                    rsfile.Update()
                End If

                If (m_FileCacheMax < m_FileCacheCurrentSize) Then
                    Current.UID = rsfile.Fields("UID").Value
                    'UPGRADE_WARNING: Couldn't resolve default property of object m_FileCache(m_FileCacheMax). Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
                    m_FileCache(m_FileCacheMax) = Current

                    m_FileCacheMax = m_FileCacheMax + 1
                Else
                    ' Rotate cache data
                    If (m_FileCachePtr >= m_FileCacheCurrentSize) Then
                        m_FileCachePtr = 0
                    End If
                    Current.UID = rsfile.Fields("UID").Value
                    'UPGRADE_WARNING: Couldn't resolve default property of object m_FileCache(m_FileCachePtr). Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
                    m_FileCache(m_FileCachePtr) = Current

                    m_FileCachePtr = m_FileCachePtr + 1
                End If

                fileid = rsfile.Fields("UID").Value

                FoundFileRecord = True

                m_lngDBSearch = m_lngDBSearch + GetTickCount - m_lngStart
            End If

            m_lngStart = GetTickCount

            If FileIndex < 32768 Then
                'While WorkerThread.IsAlive()
                'System.Threading.Thread.Sleep(1)
                ' End While
                'WorkerThread.Start(New threadParamaters(fileid, pArticleNumber, pGroupID, CShort(FileIndex)))
                Call UpdateFileIDs(fileid, pArticleNumber, pGroupID, CShort(FileIndex))
                'WorkerThread = New System.Threading.Thread(AddressOf FileSaveWorkerThread)
            End If

            m_lngDatabase = m_lngDatabase + GetTickCount - m_lngStart

        End If

        m_lngStart = GetTickCount

        If pArticleNumber Mod 500 = 1 Then
            'UPGRADE_WARNING: DateDiff behavior may be different. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6B38EC3F-686D-4B2E-B5A5-9E8E7A762E32"'
            If DateDiff(Microsoft.VisualBasic.DateInterval.Second, m_dtProcessArticleStartTime, Now) > 0 Then
                If CInt(pLineCount / DateDiff(Microsoft.VisualBasic.DateInterval.Second, m_dtProcessArticleStartTime, Now)) > 0 Then
                    'UPGRADE_WARNING: DateDiff behavior may be different. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6B38EC3F-686D-4B2E-B5A5-9E8E7A762E32"'
                    ExpectedSec = (pLinesExpected - pLineCount) / CInt(pLineCount / DateDiff(Microsoft.VisualBasic.DateInterval.Second, m_dtProcessArticleStartTime, Now))
                End If
            End If

            MDIMain.LBLProgress(pIndex) = "Lines =" & pLineCount & "(" & pLinesExpected & ") " & VB6.Format(ExpectedSec \ 3600, "##") & ":" & VB6.Format((ExpectedSec \ 60) Mod 60, "00") & ":" & VB6.Format(ExpectedSec Mod 60, "00")
            If RecTotal > 0 Then
                tempstring = "db = " & m_lngDatabase / 1000
                tempstring = tempstring & ": SP = " & m_lngSubjectProcessing / 1000
                tempstring = tempstring & ": DBS = " & m_lngDBSearch / 1000
                tempstring = tempstring & ": CS = " & m_lngCacheSearch / 1000
                tempstring = tempstring & ": proc = " & m_BufferProcessing / 1000
                tempstring = tempstring & ": WinS = " & m_WSTime / 1000
                'tempstring = tempstring & "(" & m_FileCacheMax & ")"
                'tempstring = tempstring & "CH=" & Format(CacheHit / RecTotal * 100, "00.0")
                tempstring = tempstring & " Total = " & m_TotalTime / 1000
                'tempstring = tempstring & " miss = " & (m_TotalTime - m_lngDatabase - m_lngDBSearch - m_lngCacheSearch - m_BufferProcessing - m_WSTime - m_lngSubjectProcessing) / 1000

                MDIMain.LBLAction.Text = tempstring
                GC.Collect()
            End If
            MDIMain.Refresh()
            MDIMain.LBLTransfer.Refresh()
        End If

    End Sub
End Class