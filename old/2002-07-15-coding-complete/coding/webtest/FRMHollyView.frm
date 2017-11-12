VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "Flp32x20.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form FRMHollyView 
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
   Begin LpLib.fpList GRDReply 
      Height          =   2175
      Left            =   5640
      TabIndex        =   9
      Top             =   2640
      Width           =   5655
      _Version        =   131073
      _ExtentX        =   9975
      _ExtentY        =   3836
      _StockProps     =   68
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Text            =   ""
      Columns         =   3
      Sorted          =   0
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   1
      SearchMethod    =   0
      VirtualMode     =   0   'False
      VRowCount       =   0
      DataSync        =   3
      ThreeDInsideStyle=   1
      ThreeDInsideHighlightColor=   -2147483633
      ThreeDInsideShadowColor=   -2147483642
      ThreeDInsideWidth=   1
      ThreeDOutsideStyle=   1
      ThreeDOutsideHighlightColor=   16777215
      ThreeDOutsideShadowColor=   -2147483632
      ThreeDOutsideWidth=   1
      ThreeDFrameWidth=   0
      BorderStyle     =   0
      BorderColor     =   -2147483642
      BorderWidth     =   1
      ThreeDOnFocusInvert=   0   'False
      ThreeDFrameColor=   -2147483633
      Appearance      =   0
      BorderDropShadow=   0
      BorderDropShadowColor=   -2147483632
      BorderDropShadowWidth=   3
      ScrollHScale    =   2
      ScrollHInc      =   0
      ColsFrozen      =   0
      ScrollBarV      =   2
      NoIntegralHeight=   0   'False
      HighestPrecedence=   0
      AllowColResize  =   0
      AllowColDragDrop=   0
      ReadOnly        =   0   'False
      VScrollSpecial  =   0   'False
      VScrollSpecialType=   0
      EnableKeyEvents =   -1  'True
      EnableTopChangeEvent=   -1  'True
      DataAutoHeadings=   -1  'True
      DataAutoSizeCols=   2
      SearchIgnoreCase=   -1  'True
      ColDesigner     =   "FRMHollyView.frx":0000
      ScrollBarH      =   3
      DataFieldList   =   ""
      ColumnEdit      =   0
      ColumnBound     =   0
      Style           =   0
      MaxDrop         =   0
      ListWidth       =   0
      EditHeight      =   0
      GrayAreaColor   =   0
      ListLeftOffset  =   0
      ComboGap        =   0
      MaxEditLen      =   0
      VirtualPageSize =   0
      VirtualPagesAhead=   0
      ExtendCol       =   0
      ColumnLevels    =   1
      ListGrayAreaColor=   -2147483637
      GroupHeaderHeight=   -1
      GroupHeaderShow =   -1  'True
      AllowGrpResize  =   0
      AllowGrpDragDrop=   0
      MergeAdjustView =   0   'False
      ColumnHeaderShow=   -1  'True
      ColumnHeaderHeight=   -1
      GrpsFrozen      =   0
      BorderGrayAreaColor=   -2147483637
      ExtendRow       =   0
   End
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   3720
      Top             =   5520
   End
   Begin InetCtlsObjects.Inet Inet2 
      Left            =   5520
      Top             =   2280
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      AccessType      =   1
      Protocol        =   4
      URL             =   "http://"
      RequestTimeout  =   5
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   675
      Left            =   2520
      TabIndex        =   18
      Top             =   2040
      Width           =   1455
   End
   Begin VB.CheckBox CHKShowArchive 
      Caption         =   "Archive"
      Height          =   255
      Left            =   5595
      TabIndex        =   17
      Top             =   1935
      Width           =   975
   End
   Begin VB.CommandButton CMDRefresh 
      Caption         =   "Refresh"
      Height          =   315
      Left            =   11040
      TabIndex        =   16
      Top             =   840
      Width           =   975
   End
   Begin VB.CheckBox CHKAutoCase 
      Caption         =   "Autocase"
      Height          =   255
      Left            =   5580
      TabIndex        =   15
      Top             =   1620
      Width           =   975
   End
   Begin VB.CommandButton CMDArchiveOld 
      Caption         =   "Archive Old"
      Height          =   315
      Left            =   7800
      TabIndex        =   12
      Top             =   840
      Width           =   975
   End
   Begin VB.CommandButton CMDReadAll 
      Caption         =   "Read All"
      Height          =   315
      Left            =   10320
      TabIndex        =   11
      Top             =   480
      Width           =   975
   End
   Begin VB.CommandButton CMDRead 
      Caption         =   "Read"
      Height          =   315
      Left            =   9120
      TabIndex        =   10
      Top             =   480
      Width           =   975
   End
   Begin VB.TextBox TXTMessage 
      Height          =   1395
      Left            =   6600
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   8
      Top             =   1200
      Width           =   4695
   End
   Begin ELFTxtBox.TxtBox1 TXTSubject 
      Height          =   315
      Left            =   6600
      TabIndex        =   2
      Top             =   120
      Width           =   4695
      _ExtentX        =   8281
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   0
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
   Begin ELFTxtBox.TxtBox1 TXTFrom 
      Height          =   315
      Left            =   6600
      TabIndex        =   4
      Top             =   480
      Width           =   2415
      _ExtentX        =   4260
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   0
   End
   Begin ELFTxtBox.TxtBox1 TXTDate 
      Height          =   315
      Left            =   6600
      TabIndex        =   6
      Top             =   840
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   0
   End
   Begin ELFTxtBox.TxtBox1 TXTThreadNumber 
      Height          =   315
      Left            =   9840
      TabIndex        =   13
      Top             =   840
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   0
   End
   Begin VB.Label LBLz 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Thread No"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   4
      Left            =   8760
      TabIndex        =   14
      Top             =   840
      Width           =   975
   End
   Begin VB.Label LBLz 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Message"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   3
      Left            =   4800
      TabIndex        =   7
      Top             =   1200
      Width           =   1695
   End
   Begin VB.Label LBLz 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   2
      Left            =   6000
      TabIndex        =   5
      Top             =   840
      Width           =   495
   End
   Begin VB.Label LBLz 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "From"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   1
      Left            =   4800
      TabIndex        =   3
      Top             =   480
      Width           =   1695
   End
   Begin VB.Label LBLz 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Subject"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   4800
      TabIndex        =   1
      Top             =   120
      Width           =   1695
   End
End
Attribute VB_Name = "FRMHollyView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private vThreadNumber As Long
Private vLastUID As Long

Private vcount As Long

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


Private Sub CHKShowArchive_Click()
    Call LoadView
End Sub

Private Sub CMDArchiveOld_Click()
    Dim rstemp As Recordset
    Screen.MousePointer = vbHourglass
    Call Execute("INSERT INTO replyarchive SELECT UID,ReplyUserName,ReplyDate,ReplyDescription,Threadnumber,TopicNumber,NewReply FROM reply WHERE old=true", True)
    Call Execute("DELETE FROM reply WHERE old=true", True)
    
    If (OpenRecordset(rstemp, "SELECT * FROM thread WHERE old=true", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call Execute("INSERT INTO replyarchive SELECT UID,ReplyUserName,ReplyDate,ReplyDescription,Threadnumber,TopicNumber,NewReply FROM reply WHERE threadnumber=" & rstemp!threadnumber, True) '& " AND topicnumber=" & rstemp!topicnumber
                Call Execute("DELETE FROM reply WHERE threadnumber=" & rstemp!threadnumber, True) '& " AND topicnumber=" & rstemp!topicnumber
                Call rstemp.MoveNext
            Loop
        End If
    End If
    Call Execute("INSERT INTO threadarchive SELECT * FROM Thread WHERE old=true", True)
    Call Execute("DELETE FROM thread WHERE old=true", True)
    Call Execute("UPDATE threadarchive SET archivedate='" & Format(Now, "mm/dd/yyyy") & "' WHERE isnull(archivedate)", True)
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
    Dim sql As String
    
    TREForum.Nodes.Clear
    
    sql = "SELECT * FROM topic"
'    If (CHKShowArchive.Value = vbChecked) Then
'        sql = sql & " UNION SELECT * FROM topicarchive"
'    End If
    If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
        Do While (rstemp.EOF = False)
        
            Set mnode = TREForum.Nodes.Add()
            mnode.Text = AutoCase(rstemp!topicname, True)
            mnode.Tag = -1
            mnode.Expanded = True
            
            sql = "SELECT * FROM thread WHERE topicnumber=" & rstemp!Number & " ORDER BY threadnumber DESC"
            If (OpenRecordset(rsthread, sql, dbOpenSnapshot)) Then
                Do While (rsthread.EOF = False)
                
                    If (rsthread!read = True) Then
                        Call AddChildNode(TREForum.Nodes, mnode.Index, rsthread!ThreadSubject, rsthread!Uid, cursor, False, rsthread!old)
                    Else
                        Call AddChildNode(TREForum.Nodes, mnode.Index, rsthread!ThreadSubject, rsthread!Uid, cursor, True, rsthread!old)
                    End If
                
                    Call rsthread.MoveNext
                Loop
            End If
            If (CHKShowArchive.Value = vbChecked) Then
                sql = " SELECT * FROM threadarchive WHERE topicnumber=" & rstemp!Number & " ORDER BY threadnumber DESC"
                If (OpenRecordset(rsthread, sql, dbOpenSnapshot)) Then
                    Do While (rsthread.EOF = False)
                    
                        If (rsthread!read = True) Then
                            Call AddChildNode(TREForum.Nodes, mnode.Index, rsthread!ThreadSubject, rsthread!Uid, cursor, False, rsthread!old)
                        Else
                            Call AddChildNode(TREForum.Nodes, mnode.Index, rsthread!ThreadSubject, rsthread!Uid, cursor, True, rsthread!old)
                        End If
                    
                        Call rsthread.MoveNext
                    Loop
                End If
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
    Call Unload(Me)
    
    Call FRMHollyMain.Show
End Sub

Private Sub Command1_Click()
            Inet2.URL = "http://www.aldur.wox.org:8080/k9fxp/showthread.php?s=7a5b8d79572db84cb997b918d1b99352&threadid=3762"
            Inet2.Execute , "LIST"

End Sub

Private Sub Form_Load()
    Call SetWindowPosition(Me)
    
    
    Dim rstemp As Recordset
    Dim rstemp2 As Recordset
    Dim sql As String
    sql = "SELECT replyusername, count(*) AS posts From Reply GROUP BY replyusername "
    'UNION SELECT replyusername, count(*) AS posts From replyarchive GROUP BY replyusername"

    If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
        Do While (rstemp.EOF = False)
            If (OpenRecordset(rstemp2, "SELECT * FROM Users WHERE userName='" & rstemp!replyUsername & "'", dbOpenDynaset)) Then
                If (rstemp2.EOF = False) Then
                    rstemp2.Edit
                Else
                    rstemp2.AddNew
                    rstemp2!Startdate = Now
                End If
                
                rstemp2!username = rstemp!replyUsername
                rstemp2!posts = rstemp!posts
                Call rstemp2.Update
            End If
            Call rstemp.MoveNext
        Loop
    End If
    
    Call LoadView
'    Set mnode = TreProject.Nodes.Add()
'    mnode.Text = TxtPath.Text
'    mnode.Tag = -1
'    mnode.Expanded = True
    
'    Call AddChildNode(TreProject.Nodes, SelectedFormNode, "Form Objects", -1, Cursor)

End Sub

Private Sub Form_Resize()
    Dim otherwidths As Long
    If (Me.ScaleHeight > 0 And Me.ScaleWidth > 0) Then
    TREForum.Height = Me.ScaleHeight - (100 + TREForum.Top)
    GRDReply.Height = Me.ScaleHeight - (100 + GRDReply.Top)
    
    GRDReply.Width = Me.ScaleWidth - (100 + GRDReply.Left)
    GRDReply.Col = 0
    otherwidths = GRDReply.ColWidth
    GRDReply.Col = 1
    otherwidths = otherwidths + GRDReply.ColWidth
    GRDReply.Col = 2
    GRDReply.ColWidth = GRDReply.Width - (otherwidths + 300)
    TXTMessage.Width = Me.ScaleWidth - (100 + TXTMessage.Left)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
End Sub

Private Sub ShowReplys()
    Dim rstemp As Recordset
    Dim tempstring As String
    Dim datestring As String
    Dim linecount As Long
    Dim i As Long
    Dim t As String
    GRDReply.Clear
    If (OpenRecordset(rstemp, "SELECT * FROM reply WHERE threadnumber=" & vThreadNumber & " ORDER BY replydate", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
        Else
            If (OpenRecordset(rstemp, "SELECT * FROM replyarchive WHERE threadnumber=" & vThreadNumber & " ORDER BY replydate", dbOpenSnapshot)) Then
            End If
        End If
        Do While (rstemp.EOF = False)
        
        
            'tempstring = AutoWidth(Replace(Trim$(rstemp!replydescription), Chr$(13), ""), 30)
            GRDReply.Col = 2
            tempstring = rstemp!replydescription & ""
            tempstring = Replace(tempstring, "<img src=images/smile.gif>", " :)")
            tempstring = Replace(tempstring, "<img src=images/wink.gif>", " ;)")
            tempstring = Replace(tempstring, "<img src=images/frown.gif>", " :(")
            tempstring = Replace(tempstring, "<img src=images/tongue.gif>", " :p")
            tempstring = Replace(tempstring, "<img src=images/eek.gif>", " :eek:")
            tempstring = Replace(tempstring, "<img src=images/cool.gif>", " :cool:")
            tempstring = Replace(tempstring, "<img src=images/biggrin.gif>", " :biggrin:")
            tempstring = Replace(tempstring, "<img src=images/angry.gif>", " :#")
            tempstring = Replace(tempstring, "<img src=images/crying.gif>", " :'(")
            tempstring = Replace(tempstring, "<img src=images/nonplussed.gif>", " :s")
            tempstring = Replace(tempstring, "<img src=images/mad.gif>", " :mad:")
            tempstring = Replace(tempstring, "<img src=images/sick.gif>", " :sick:")
            tempstring = Replace(tempstring, "<img src=images/straightfaced.gif>", " :sick:")
            tempstring = Replace(tempstring, "<img src=images/webmonkey.gif>", " :webmonkey:")
            tempstring = Replace(tempstring, "<img src=images/ed.gif>", " :ed:")
            tempstring = FormatContext(Me, GRDReply.ColWidth - 100, tempstring) & vbCrLf
            'tempstring = AutoWidth2(Me, tempstring, GRDReply.ColWidth - 200)
            'Replace(Trim$(rstemp!replydescription), Chr$(13), "")
            linecount = 0
            For i = 1 To Len(tempstring)
                If (Mid$(tempstring, i, 1) = Chr$(13)) Then
                    linecount = linecount + 1
                End If
            Next
            
            datestring = Format(rstemp!replydate, "dd/mm/yy")
            For i = 1 To linecount
                If (CHKAutoCase.Value = vbChecked) Then
                    Call GRDReply.AddItem(rstemp!replyUsername & vbTab & datestring & vbTab & AutoCase(tempstring, False))
                Else
                    Call GRDReply.AddItem(rstemp!replyUsername & vbTab & datestring & vbTab & tempstring)
                End If
                datestring = ""
                t = t & tempstring
                GRDReply.Col = -1
                GRDReply.Row = GRDReply.ListCount - 1
                GRDReply.ListApplyTo = ListApplyToIndividual
                GRDReply.BackColor = &HFFFFFF
                If (rstemp!replyUsername = "Ed" Or rstemp!replyUsername = "Webmonkey" Or rstemp!replyUsername = "pinchy") Then
                    GRDReply.ForeColor = &HFF
                Else
                    GRDReply.ForeColor = &H0
                End If
                If (rstemp!newreply = True) Then
                    GRDReply.BackColor = &HB7B7B7
                    
                Else
                    'GRDReply.BackColor = &HFFFFFF
                End If
                
                If (rstemp!old = True) Then
                    GRDReply.BackColor = &HFF00&
                    
                Else
                End If
            
            Next
        
        
            rstemp.MoveNext
        Loop
    End If
    GRDReply.TopIndex = GRDReply.ListCount - 1
End Sub

Private Sub Inet2_StateChanged(ByVal State As Integer)
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
'            Inet2.URL = "http://www.aldur.wox.org:8080/k9fxp/showthread.php?s=7a5b8d79572db84cb997b918d1b99352&threadid=3762"
'            Inet2.Execute , "LIST"
        Case icResponseCompleted
            Dim vData As Variant
            Do
                vData = Inet2.GetChunk(512, icString)
                DoEvents
                If Len(vData) = 0 Then Exit Do
            Loop
        
            aStat = "Remote Error"
    End Select
TXTSubject.Text = aStat
End Sub

Private Sub Timer1_Timer()
    On Error Resume Next
    If TXTSubject.Text = "Remote Error" Then
        If (vcount <= 1000) Then
        
            Inet2.URL = "http://www.aldur.wox.org:8080/k9fxp/showthread.php?s=7a5b8d79572db84cb997b918d1b99352&threadid=3762"
            Inet2.Execute , "LIST"
            vcount = vcount + 1
        Else: Timer1.Enabled = False
        End If
    End If
End Sub

Private Sub TREForum_NodeClick(ByVal Node As MSComctlLib.Node)
    Dim rstemp As Recordset
    Dim tempstring As String
    Dim i As Long
    vLastUID = Node.Tag
    If (Node.Tag > -1) Then

        If (OpenRecordset(rstemp, "SELECT * FROM thread WHERE uid=" & Node.Tag, dbOpenSnapshot)) Then
            If (rstemp.EOF = False) Then
                TXTThreadNumber.Text = rstemp!threadnumber
                TXTSubject.Text = rstemp!ThreadSubject
                TXTFrom.Text = rstemp!threadusername & ""
                TXTDate.Text = Format(rstemp!threaddate, "dd/mm/yyyy")
                TXTMessage.Text = rstemp!threadmessage & ""
                vThreadNumber = rstemp!threadnumber
            Else
                If (OpenRecordset(rstemp, "SELECT * FROM threadarchive WHERE uid=" & Node.Tag, dbOpenSnapshot)) Then
                    If (rstemp.EOF = False) Then
                        TXTThreadNumber.Text = rstemp!threadnumber
                        TXTSubject.Text = rstemp!ThreadSubject
                        TXTFrom.Text = rstemp!threadusername & ""
                        TXTDate.Text = Format(rstemp!threaddate, "dd/mm/yyyy")
                        TXTMessage.Text = rstemp!threadmessage & ""
                        vThreadNumber = rstemp!threadnumber
                    End If
                End If
            End If
        End If
        
        Call ShowReplys
    Else
        TXTSubject.Text = ""
        TXTFrom.Text = ""
        TXTDate.Text = ""
        TXTMessage.Text = ""
        
    End If
End Sub
'WebBrowser1.Navigate()
Private Sub WebBrowser1_StatusTextChange(ByVal Text As String)

End Sub
