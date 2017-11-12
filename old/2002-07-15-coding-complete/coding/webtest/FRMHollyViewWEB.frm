VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "Mscomctl.ocx"
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "shdocvw.dll"
Begin VB.Form FRMHollyViewWEB 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Holly View"
   ClientHeight    =   7410
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11430
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7410
   ScaleWidth      =   11430
   Begin VB.CommandButton CMDRefresh 
      Caption         =   "Refresh"
      Height          =   315
      Left            =   8880
      TabIndex        =   5
      Top             =   120
      Width           =   975
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   4800
      Top             =   360
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin SHDocVwCtl.WebBrowser WebBrowser1 
      Height          =   4575
      Left            =   5640
      TabIndex        =   4
      Top             =   480
      Width           =   5655
      ExtentX         =   9975
      ExtentY         =   8070
      ViewMode        =   0
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   1
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      NoWebView       =   0   'False
      HideFileNames   =   0   'False
      SingleClick     =   0   'False
      SingleSelection =   0   'False
      NoFolders       =   0   'False
      Transparent     =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   ""
   End
   Begin VB.CommandButton CMDArchiveOld 
      Caption         =   "Archive Old"
      Height          =   315
      Left            =   5640
      TabIndex        =   3
      Top             =   120
      Width           =   975
   End
   Begin VB.CommandButton CMDReadAll 
      Caption         =   "Read All"
      Height          =   315
      Left            =   7800
      TabIndex        =   2
      Top             =   120
      Width           =   975
   End
   Begin VB.CommandButton CMDRead 
      Caption         =   "Read"
      Height          =   315
      Left            =   6720
      TabIndex        =   1
      Top             =   120
      Width           =   975
   End
   Begin MSComctlLib.TreeView TREForum 
      Height          =   4935
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   5415
      _ExtentX        =   9551
      _ExtentY        =   8705
      _Version        =   393217
      LabelEdit       =   1
      Style           =   4
      Appearance      =   1
   End
   Begin VB.Label lblBR 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   10560
      TabIndex        =   7
      Top             =   120
      Width           =   765
   End
   Begin VB.Label lblStat 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Bytes Received:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   8400
      TabIndex        =   6
      Top             =   120
      Width           =   2010
   End
End
Attribute VB_Name = "FRMHollyViewWEB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private vThreadNumber As Long
Private vLastUID As Long

Private aCmd As String, aPath As String, lBytes As Long, lBuf As Long, aFile As String
Private vrsTopic As Recordset
Private vrsThreads As Recordset
Private vAction As String
Private vCurrentThreadNumber As Long
Private vCurrentTopicNumber As Long

Private Function LookForConversations(pSearchText As String) As Boolean
    Dim leftpos As Long
    Dim tempstring As String
    Dim threadnumber As Long
    Dim topicnumber As Long
    Dim ThreadSubject As String
    Dim rstemp As Recordset
    Dim NumberOfReplys As Long
    Const lookkey As String = "ShowConversation.asp"

    tempstring = pSearchText
    leftpos = InStr(tempstring, lookkey)
    Do While (leftpos > 0)
        tempstring = Mid$(tempstring, leftpos + 27)
        threadnumber = Left$(tempstring, InStr(tempstring, "&") - 1)
        tempstring = Mid$(tempstring, InStr(tempstring, "&") + 6)
        topicnumber = Left$(tempstring, InStr(tempstring, Chr$(34)) - 1)
        If (topicnumber = 9) Then
            ThreadSubject = ThreadSubject
        End If
        ThreadSubject = Mid$(tempstring, 20 + Len(topicnumber & ""), InStr(tempstring, "</a>") - (20 + Len(topicnumber & "")))
        leftpos = InStr(tempstring, lookkey)
        NumberOfReplys = Val(Mid$(tempstring, InStr(tempstring, "(") + 1, 5))
        

        If (OpenRecordset(rstemp, "SELECT * FROM Thread WHERE Threadnumber=" & threadnumber & " AND Topicnumber=" & topicnumber, dbOpenDynaset)) Then
            If (rstemp.EOF = False) Then
                rstemp.Edit
                rstemp!ThreadSubject = ThreadSubject
                rstemp!threadnumber = threadnumber
                rstemp!topicnumber = topicnumber
                If (rstemp!NumberOfReplys < NumberOfReplys) Then
                    rstemp!ReadReplys = True
                End If
                rstemp!NumberOfReplys = NumberOfReplys
                rstemp!old = False
                rstemp.Update
            Else
                rstemp.AddNew
                rstemp!ThreadSubject = ThreadSubject
                rstemp!threadnumber = threadnumber
                rstemp!topicnumber = topicnumber
                rstemp!NumberOfReplys = NumberOfReplys
                rstemp!ReadReplys = True
                rstemp!read = False
                rstemp!old = False
                rstemp.Update
            End If
            rstemp.Close
        End If
    Loop
End Function

Private Sub GetDatac2(adata As String)
    Dim vData As Variant
    Do
        vData = Inet1.GetChunk(512, icString)
        DoEvents
        If Len(vData) = 0 Then Exit Do
        adata = adata & vData
        lblBR.Caption = CStr(Len(adata))
    Loop
End Sub

Private Sub getnexttopic()
    Dim exitloop As Boolean
    If (vAction = "ReadThreads") Then
        If (vrsTopic.EOF = False) Then
            lblBR.Caption = "": lblStat.ForeColor = vbRed
            Inet1.URL = "http://www.hollyoaks.com/members/forum/tree.asp?TPID=" & vrsTopic!Number
            Inet1.Execute , aCmd
            vrsTopic.MoveNext
        Else
            vrsTopic.Close
            lblStat.Caption = "Finished downloading articles"
            Call LoadView
            Call RefreshView
            Call ShowReplys
            Screen.MousePointer = vbDefault
            
        End If
    Else
    End If
End Sub



'' Add Node
Private Sub AddChildNode(pNodes As Nodes, pParent As Long, pText As String, pTag As Long, ByRef pCursor As Long, pBold As Boolean, pold As Boolean)
    Dim mnode As Node
    Set mnode = pNodes.Add(pParent, tvwChild)
    mnode.Text = pText
    mnode.Bold = pBold
    If (pold = True) Then
        mnode.BackColor = &HFF00&
    Else
        mnode.BackColor = &HFFFFFF
    End If
    mnode.Tag = pTag
    pCursor = pCursor + 1
End Sub


Private Sub CMDArchiveOld_Click()
    Dim rstemp As Recordset
    Screen.MousePointer = vbHourglass
    If (OpenRecordset(rstemp, "SELECT * FROM thread WHERE old=true", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call Execute("INSERT INTO replyarchive SELECT * FROM reply WHERE threadnumber=" & rstemp!threadnumber, True) '& " AND topicnumber=" & rstemp!topicnumber
                Call Execute("DELETE FROM reply WHERE threadnumber=" & rstemp!threadnumber, True) '& " AND topicnumber=" & rstemp!topicnumber
                Call rstemp.MoveNext
            Loop
        End If
    End If
    Call Execute("INSERT INTO threadarchive SELECT * FROM Thread WHERE old=true", True)
    Call Execute("DELETE FROM thread WHERE old=true", True)
    Call LoadView
    Call RefreshView
    Call ShowReplys
    Screen.MousePointer = vbDefault
End Sub

Private Sub CMDRead_Click()
    Dim i As Long
    Screen.MousePointer = vbHourglass
    Call Execute("UPDATE reply SET newreply=false WHERE threadnumber=" & vThreadNumber, True)
    Call Execute("UPDATE thread SET read=true WHERE threadnumber=" & vThreadNumber, True)
    Call RefreshView
    Call ShowReplys
    Screen.MousePointer = vbDefault
End Sub

Private Sub RefreshView()
    Dim i As Long
    Dim mnode As Node
    Dim rstemp As Recordset
    Dim rsthread As Recordset
    Dim cursor As Long
    
    For i = 1 To TREForum.Nodes.Count
        If (TREForum.Nodes(i).Tag >= 0) Then
            If (OpenRecordset(rsthread, "SELECT * FROM thread WHERE uid=" & TREForum.Nodes(i).Tag & " ORDER BY threadnumber DESC", dbOpenSnapshot)) Then
                If (rsthread.EOF = False) Then
                    If (rsthread!read = True) Then
                        TREForum.Nodes(i).Bold = False
                    Else
                        TREForum.Nodes(i).Bold = True
                    End If
                    If (rsthread!old = True) Then
                        TREForum.Nodes(i).BackColor = &HFF00&
                    Else
                        TREForum.Nodes(i).BackColor = &HFFFFFF
                    End If
                
                    Call rsthread.MoveNext
                End If
            End If
        End If
    Next
    TREForum.SetFocus
    
End Sub


Private Sub LoadView()
    Dim mnode As Node
    Dim rstemp As Recordset
    Dim rsthread As Recordset
    Dim cursor As Long
    
    TREForum.Nodes.Clear
    If (OpenRecordset(rstemp, "SELECT * FROM topic", dbOpenSnapshot)) Then
        Do While (rstemp.EOF = False)
        
            Set mnode = TREForum.Nodes.Add()
            mnode.Text = AutoCase(rstemp!topicname, True)
            mnode.Tag = -1
            mnode.Expanded = True
            
            If (OpenRecordset(rsthread, "SELECT * FROM thread WHERE topicnumber=" & rstemp!Number & " ORDER BY threadnumber DESC", dbOpenSnapshot)) Then
                Do While (rsthread.EOF = False)
                
                    If (rsthread!read = True) Then
                        Call AddChildNode(TREForum.Nodes, mnode.Index, rsthread!ThreadSubject, rsthread!Uid, cursor, False, rsthread!old)
                    Else
                        Call AddChildNode(TREForum.Nodes, mnode.Index, rsthread!ThreadSubject, rsthread!Uid, cursor, True, rsthread!old)
                    End If
                
                    Call rsthread.MoveNext
                Loop
            
            
            End If
            
            
            rstemp.MoveNext
        Loop
    
    End If
End Sub


Private Sub CMDReadAll_Click()
    Screen.MousePointer = vbHourglass
    Call Execute("UPDATE reply SET newreply=false ", True)
    Call Execute("UPDATE thread SET read=true ", True)
    Call RefreshView
    Call ShowReplys
    Screen.MousePointer = vbDefault
End Sub

Private Sub CMDRefresh_Click()
    Call SetWindowPosition(Me)
    MousePointer = vbHourglass
    aCmd = "LIST"
    
    Screen.MousePointer = vbHourglass
    Call Execute("UPDATE thread SET old=true")
    vAction = "ReadThreads"
    If (OpenRecordset(vrsTopic, "SELECT * FROM topic", dbOpenSnapshot)) Then
        Call getnexttopic
    End If
End Sub

Private Sub Form_Load()
    Call SetWindowPosition(Me)
    
    Call LoadView
'    Set mnode = TreProject.Nodes.Add()
'    mnode.Text = TxtPath.Text
'    mnode.Tag = -1
'    mnode.Expanded = True
    
'    Call AddChildNode(TreProject.Nodes, SelectedFormNode, "Form Objects", -1, Cursor)

End Sub

Private Sub Form_Resize()
    Dim otherwidths As Long
    TREForum.Height = Me.ScaleHeight - (100 + TREForum.Top)
    WebBrowser1.Height = Me.ScaleHeight - (100 + WebBrowser1.Top)
    WebBrowser1.Width = Me.ScaleWidth - (100 + WebBrowser1.Left)
    
    lblBR.Left = Me.ScaleWidth - (100 + lblBR.Width)
    lblStat.Left = lblBR.Left - (100 + lblStat.Width)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
End Sub

Private Sub ShowReplys()
    Dim rstemp As Recordset
    Dim tempstring As String
    Dim linecount As Long
    Dim i As Long
End Sub

Private Sub Inet1_StateChanged(ByVal State As Integer)
    Dim adata As String, a As String, k As Long, aStat As String
    Select Case State
        Case icNone
            aStat = ""
        Case icResolvingHost
            aStat = "Resolving Host"
        Case icHostResolved
            aStat = "Host Resolved"
        Case icConnecting
            aStat = "Connecting"
        Case icConnected
            aStat = "Connected"
        Case icRequesting
            aStat = "Sending Request"
        Case icRequestSent
            aStat = "Request Sent"
        Case icReceivingResponse
            aStat = "Receiving Response"
        Case icResponseReceived
            aStat = "Response Received"
        Case icDisconnecting
            aStat = "Disconnecting"
        Case icDisconnected
            aStat = "Disconnected"
        Case icError
            aStat = "Remote Error"
            MousePointer = vbDefault
        Case icResponseCompleted
            lblStat.ForeColor = vbButtonText
            lblStat.Caption = "Response Completed": DoEvents
            Select Case aCmd
                Case "DIR"
                Case "LIST"
                    Call GetDatac2(adata)
                    If (vAction = "ReadThreads") Then
                        Call LookForConversations(adata)
                    Else
'                        If (vAction = "ReadReplys") Then
'                            Call ReadThread(adata)
'                        Else
'                        End If
                    End If
                    Call getnexttopic
                Case "GET"
                Case "PUT"
            End Select
            MousePointer = vbDefault
            Exit Sub
    End Select
    lblStat.Caption = aStat
End Sub

Private Sub TREForum_NodeClick(ByVal Node As MSComctlLib.Node)
    Dim rstemp As Recordset
    Dim tempstring As String
    Dim i As Long
    vLastUID = Node.Tag
    If (Node.Tag > -1) Then

        If (OpenRecordset(rstemp, "SELECT * FROM thread WHERE uid=" & Node.Tag, dbOpenSnapshot)) Then
            If (rstemp.EOF = False) Then
                Call WebBrowser1.Navigate("http://www.hollyoaks.com/members/forum/ShowConversation.asp?STHID=" & rstemp!threadnumber & "&TPID=" & rstemp!topicnumber)
                vThreadNumber = rstemp!threadnumber
            End If
        End If
        
        Call ShowReplys
    Else
        
    End If
End Sub
'WebBrowser1.Navigate()
Private Sub WebBrowser1_StatusTextChange(ByVal Text As String)

End Sub
